import Foundation

/**
    A class for running external command-line programs
 */
@objc
class SSYTask : NSObject {
    static let errorDomain = "SSYTaskErrorDomain"
    
    struct ProgramResult {
        var exitStatus: Int32
        var stdout: Data?
        var stderr: Data?
    }
    
    /**
     Runs an external command-line program, passing stdin and returning stderr
     and stdout.
     
     You can use this function either synchronously, by passing `wait`=true,
     or asynchronously, by passing `wait`=false.
     
     If you so use this function synchronously, you can get the program
     result either as the return value of this function, or in the parameters
     passed to your completion handler.  (Typically, you would use the former
     and pass nil as your completion handler.)
     
     If you so use this function asynchronously, you get the program
     result as the parameters passed to your completion handler.
     
     Credit: This function started with code written by Quinn "The Eskimo":
     https://developer.apple.com/forums/thread/690310
     I've added parameters, and also the process-launching code runs in a
     secondary thread instead of in the main thread.
     
     - important: Passed testing returning 106 KB of stdout data, 0 stdin
     - todo:  Test with more than 106 KB of stdout.  (2) Write an Objective-C wrapper.  Mark this function with @objc to see the issues.
     - parameter command : The program to run, a file URL
     - parameter arguments : The arguments to pass to the program
     - parameter inDirectory : The "current directory" to run the program in
     - parameter stdin : The stdin data to pass to the program
     - parameter timeout : Time interval after which the program will be terminated if it is not yet finished.  Pass nil to allow infinite time.
     - parameter wait :  If true, will block execution in the current thread until the program terminates or exceeds the given timeout.
     - parameter completionHandler : An optional closure to run after the
     program terminates, to which is passed the Result of executing or
     attempting to execute the program.
     
     If the program (a) fails to start, or (b) fails to exit on its own, this Result will be a Result.failure.  An example of (a)) is if you pass a nonexistent `command`.  An example of (b) is if the program has not yet returned when  the `timeout` you passed in expires.  Note that if the program runs and terminates with a nonzero exit code, that will produce a Result.success.  Thus, if you are expecting EXIT\_SUCCESS from the program, you should first verify that you have `Result.success`, and then check its enclosed `ProgramResult.exitStatus`.
     
     If either the stdout or stderr from the program are 0 bytes, the corresponding value in the ProgramResult your completion handler receives will be nil. This function will not return an empty Data object.
     
     (Note that an optional closure like this must be escaping, since the closure is stored inside the Optional.some case.  See https://forums.swift.org/t/allowing-escaping-for-optional-closures-in-method-signature/27556/2)
     - returns: If you passed in wait = true, the ProgramResult returned will be equal to the ProgramResult described above which his passed to the completionHandler. So, ditto that preceding documentation here.
     
     If you passed in wait = false, and the program starts succesfully, returns a Result.success with the encclosed exitStatus = EXIT\_SUCCESS.  Only if the program fails to start will you get a Result.failure.
     - requires: Swift
     */
    @discardableResult
    class func run(_ command: URL,
                   arguments: [String]? = [],
                   inDirectory: URL? = nil,
                   stdin: Data? = nil,
                   timeout: TimeInterval?,
                   wait: Bool = true,
                   completionHandler: ((_ result: Result<ProgramResult, Error>) -> Void)? = nil) -> Result<ProgramResult, Error> {
        let group = DispatchGroup()
        let stdinPipe = Pipe()
        let stdoutPipe = Pipe()
        let stderrPipe = Pipe()
        
        var errorQ: Error? = nil
        var stdout = Data()
        var stderr = Data()
        
        let proc = Process()
        proc.executableURL = command
        if let inDirectory = inDirectory {
            proc.currentDirectoryURL = inDirectory
        }
        if let arguments = arguments {
            proc.arguments = arguments
        }
        proc.standardInput = stdinPipe
        proc.standardOutput = stdoutPipe
        proc.standardError = stderrPipe
        
        var semaphore: DispatchSemaphore? = nil
        if (wait) {
            semaphore = DispatchSemaphore(value: 0)
        }
        
        group.enter()
        
        let queue = DispatchQueue(label: "SSYTask.\(command.lastPathComponent)")
        
        proc.terminationHandler = { _ in
            queue.async {
                group.leave()
            }
        }
        
        /* Define the .notify block, which runs after the external task is
         complete, and std out and stderr have been received.  */
        group.notify(queue: queue) {
            if let completionHandler = completionHandler {
                completionHandler(Self.encodeResult(
                    proc: proc,
                    stdout: stdout,
                    stderr: stderr,
                    wait:wait,
                    error: errorQ))
            }
            semaphore?.signal()
        }
        
        do {
            func posixErr(_ error: Int32) -> Error { NSError(domain: NSPOSIXErrorDomain,
                                                             code: Int(error),
                                                             userInfo: nil) }
            
            /*  If you write to a pipe whose remote end has closed, the OS raises a
             `SIGPIPE` signal whose default disposition is to terminate your
             process.  Helpful!  `F_SETNOSIGPIPE` disables that feature, causing
             the write to fail with `EPIPE` instead. */
            let fcntlResult = fcntl(stdinPipe.fileHandleForWriting.fileDescriptor, F_SETNOSIGPIPE, 1)
            guard fcntlResult >= 0 else { throw posixErr(errno) }
            
            try proc.run()
            
            if let inputDD = stdin?.withUnsafeBytes({ DispatchData(bytes: $0) }) {
                group.enter()
                let writeIO = DispatchIO(type: .stream, fileDescriptor: stdinPipe.fileHandleForWriting.fileDescriptor, queue: queue) { _ in
                    /* See Note HoldHandle */
                    try! stdinPipe.fileHandleForWriting.close()
                }
                writeIO.write(offset: 0, data: inputDD, queue: queue) { isDone, _, error in
                    if isDone || error != 0 {
                        writeIO.close()
                        if errorQ == nil && error != 0 {
                            errorQ = posixErr(error)
                        }
                        group.leave()
                    }
                }
            }
            
            /*  Enter the group and then set up a Dispatch I/O channel to read data
             from the child’s `stdin`.  When that’s done, record any error and
             leave the group. */
            
            group.enter()
            let readStdout = DispatchIO(type: .stream,
                                        fileDescriptor: stdoutPipe.fileHandleForReading.fileDescriptor,
                                        queue: queue) { _ in
                /* See Note HoldHandle */
                try! stdoutPipe.fileHandleForReading.close()
            }
            readStdout.read(
                offset: 0,
                length: .max,
                queue: queue,
                ioHandler: { isDone, chunk, error in
                    stdout.append(contentsOf: chunk ?? .empty)
                    if isDone || error != 0 {
                        readStdout.close()
                        if errorQ == nil && error != 0 {
                            errorQ = posixErr(error)
                        }
                        group.leave()
                    }
                }
            )
            
            group.enter()
            let readStderr = DispatchIO(type: .stream,
                                        fileDescriptor: stderrPipe.fileHandleForReading.fileDescriptor,
                                        queue: queue) { _ in
                /* See Note HoldHandle */
                try! stderrPipe.fileHandleForReading.close()
            }
            readStderr.read(
                offset: 0,
                length: .max,
                queue: queue,
                ioHandler: { isDone, chunk, error in
                    stderr.append(contentsOf: chunk ?? .empty)
                    if isDone || error != 0 {
                        readStderr.close()
                        if errorQ == nil && error != 0 {
                            errorQ = posixErr(error)
                        }
                        group.leave()
                    }
                }
            )
            
            var timeoutResult = DispatchTimeoutResult.success
            if let timeout = timeout {
                timeoutResult = group.wait(timeout: DispatchTime.now() + .nanoseconds(Int(timeout*1e9)))
                if (timeoutResult == .timedOut) {
                    errorQ = NSError(domain: Self.errorDomain,
                                     code: 287593,
                                     userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Task timed out",
                                                                                             comment: "what it says")
                                     ])
                    proc.terminate()
                }
            }
            
            semaphore?.wait()
            
        } catch {
            /* If either the `fcntl` or the `run()` call threw, we set the error
             and manually call the termination handler.  Note that we’ve only
             entered the group once at this point, so the single leave done by the
             termination handler is enough to run the notify block and call the
             client’s completion handler. */
            errorQ = error
            proc.terminationHandler!(proc)
        }
        
        return Self.encodeResult(proc: proc, stdout:stdout, stderr: stderr, wait:wait, error: errorQ)
    }
    
    private class func encodeResult(proc: Process,
                                    stdout: Data?,
                                    stderr: Data?,
                                    wait: Bool,
                                    error: Error?) -> Result<ProgramResult, Error> {
        var result: Result<ProgramResult, Error>
        if let underlyingError = error {
            let programPath = proc.executableURL?.absoluteString ?? "<NO-PROGRAM-PATH>"
            let programName = proc.executableURL?.lastPathComponent ?? "<NO-PROGRAM-NAME>"
            let errorDescription = String(format:
                                            "%s `%s`",
                                          NSLocalizedString(
                                            "An error occurred when attempting to run program",
                                            comment: "This string is followed by the name of the program"),
                                          programName)
            let error = NSError(domain: Self.errorDomain,
                                code: 287595,
                                userInfo: [
                                    NSLocalizedDescriptionKey: errorDescription,
                                    NSUnderlyingErrorKey: underlyingError,
                                    "Full path to program": programPath]
            )
            result = .failure(error)
        } else {
            var exitStatus: Int32
            if (proc.isRunning) {
                if (wait == false) {
                    exitStatus = EXIT_SUCCESS
                } else {
                    exitStatus = -1
                }
            } else {
                exitStatus = proc.terminationStatus
            }
            let programResult: ProgramResult = ProgramResult(
                exitStatus: exitStatus,
                stdout: (stdout?.count ?? 0 > 0) ? stdout : nil,
                stderr: (stderr?.count ?? 0 > 0) ? stderr : nil
            )
            result = .success(programResult)
        }
        
        return result
    }
    
    @objc static var exitStatusKey = "exitStatus"
    @objc static var stdoutKey = "stdout"
    @objc static var stderrKey = "stderr"
    @objc static var errorKey = "error"
    
    /**
     An Objective-C friendly wrapper around the function
     class SSYTask.run(_:arguments:inDirectory:stdin:timeout:wait:completionHandler:)
    
     - parameter command : The program to run, a file URL
     - parameter arguments : The arguments to pass to the program
     - parameter inDirectory : The "current directory" to run the program in
     - parameter stdin : The stdin data to pass to the program
     - parameter timeout : Time interval after which the program will be terminated if it is not yet finished and this function will return.  Pass 0.0 to return immediately and let the program run its course.
     - returns: A dictionary.  If success (as defined in the documentation of
     
     class SSYTask.run(\_:arguments:inDirectory:stdin:timeout:wait:completionHandler:),
     
     this dictionary contains values for keys SSYTaskExitStatusKey, SSYTaskStdoutKey
     and SSYTaskStderrKey if these are not nil.  If failure, contains value for SSYTaskErrorKey.
     */

    @objc
    @discardableResult
    class func run(_ command: URL,
                   arguments: [String]? = [],
                   inDirectory: URL? = nil,
                   stdinput: Data? = nil,
                   timeout: TimeInterval) -> Dictionary<String, Any> {
        let result = Self.run(command,
                              arguments: arguments,
                              inDirectory: inDirectory,
                              stdin: stdinput,
                              timeout: timeout,
                          wait: (timeout != 0.0),
                              completionHandler: nil)

        var returnDic: Dictionary<String, Any> = [:]
        switch result {
        case .success(let programResult):
            returnDic[exitStatusKey] = programResult.exitStatus
            if let stdout = programResult.stdout {
                returnDic[stdoutKey] = stdout
            }
            if let stderr = programResult.stderr {
                returnDic[stderrKey] = stderr
            }
        case .failure(let error):
            returnDic[errorKey] = error
        }

        return returnDic
    }
}

/*
 
Note HoldHandle:
 
FileHandle` will automatically close the underlying file descriptor when you
release the last reference to it.  By holidng on to `inputPipe` until here,
we ensure that doesn’t happen. Andas we have to hold a reference anyway,
we might as well close it explicitly.
 
 */

