import Foundation
import ServiceManagement
import SSYSwift

extension BkmxBasis {
    
    func demoExpiresSoonWarning() -> String? {
        if !UserDefaults.standard.bool(forKey: constKeyDidWarnExpiringSoonV3) {
            let daysToExpire = SSYLCDaysToExpire()
            let appName = self.appNameLocalized ?? "this app"
            if (daysToExpire < 40) {
                let format = NSLocalizedString("This demo version of %@ will expire and stop working in %ld days.  To continue using %@, please update to the latest version.", comment: "what it says!")
                return String(format: format, appName, daysToExpire, appName)
            }
        }
        
        return nil
    }
    
    @objc
    func checkAndHandleAppExpirationOrUpdate(_ thenDo: () -> Void) {
        if (SSYLCDaysToExpire() <= 0) {
            let format = NSLocalizedString("This temporary free demo version of %@ expired on %@.",
                                           comment: "Placeholders are an app name and a date.")
            let msg = String(format: format,
                             self.appNameLocalized,
                             LongExpirationDateString())
            DispatchQueue.main.sync {
                let alertReturn = SSYAlert.runModalDialogTitle(NSLocalizedString("Application has expired", comment: "no comment"),
                                                               message: msg,
                                                               buttonsArray: [
                                                                NSLocalizedString("Check for Update", comment: "no comment"),
                                                                NSLocalizedString("Quit", comment: "no comment")
                                                               ])
                switch alertReturn {
                case NSApplication.ModalResponse.alertFirstButtonReturn.rawValue:
                    Sparkler.shared.checkForUpdates()
                    
                default:
                    NSApplication.shared.terminate(self)
                }
            }
        }
        thenDo()
    }
    
    @objc
    @discardableResult
    func kickBkmxAgent(kickType: KickType) throws -> RunnerResult {
        var runnerResult: RunnerResult
        
        if (kickType == .stop) || (kickType == .status) || (self.coreDataMigrationDelegate == nil) || (self.coreDataMigrationDelegate?.countMigrationsInProcess == 0) {
            if #available(macOS 14.0, *) {
                runnerResult = runRunner(kickType: kickType)
                let duration = runnerResult.duration
                var durationString: String
                durationString = String(format:  "%0.3f", duration)
                if (duration < 0.0) {
                    durationString = durationString + " <nonsense>"
                }
                let readableKickType = BkmxAgentRunner.commandName(kickType: kickType)
                Self.shared().logString("BkmxAgent took \(durationString) secs to \(readableKickType) [2]")
                if let error = runnerResult.error {
                    throw error
                }
            } else {
                runnerResult = RunnerResult()
                var url = URL(fileURLWithPath:ProcessInfo().arguments[0])
                let command = BkmxAgentRunner.commandName(kickType: kickType)
                Self.shared().logString("Main app will \(command) BkmxAgent")
                if (self.isBkmxAgent()) {
                    // url = ../MainApp.app/Contents/Library/LoginItems/BkmxAgent.app/Contents/MacOS/BkmxAgent
                    url = url.deletingLastPathComponent() // ../MainApp.app/Contents/Library/LoginItems/BkmxAgent.app/Contents/MacOS
                    url = url.deletingLastPathComponent() // ../MainApp.app/Contents/Library/LoginItems/BkmxAgent.app/Contents/
                    url = url.deletingLastPathComponent() // ../MainApp.app/Contents/Library/LoginItems/BkmxAgent.app/
                    url = url.deletingLastPathComponent() // ../MainApp.app/Contents/Library/LoginItems/
                    url = url.deletingLastPathComponent() // ../MainApp.app/Contents/Library/
                } else {
                    // url = ../MainApp.app/Contents/MacOS/MainApp
                    url = url.deletingLastPathComponent() // ../MainApp.app/Contents/MacOS
                }
                url = url.deletingLastPathComponent()  // ../MainApp.app/Contents
                let agentBundleURL = url.appendingPathComponent("Library").appendingPathComponent("LoginItems").appendingPathComponent("BkmxAgent.app")
                self.logString("Computed agent bundle URL: \(agentBundleURL)")
                let agentBundle = Bundle(url: agentBundleURL)
                if let agentBundleIdentifier = agentBundle?.bundleIdentifier {
                    if (kickType == .reboot) {
                        let agentPid = SSYOtherApper.pid(ofProcessNamed: constAppNameBkmxAgent,
                                                         orBundleIdentifier: agentBundleIdentifier,
                                                         user: NSUserName())
                        if (agentPid > 0) {
                            self.logString("Will kill pid \(agentPid) so macOS will relaunch \(constAppNameBkmxAgent)")
                            kill(agentPid, SIGKILL)
                        } else {
                            self.logString("No BkmxAgent pid to kill")
                        }
                        /* We rely on macOS to notice that we killed the BkmxAgent
                         process and relaunch it.  (This did work reliably in
                         macOSS 13 and earlier.) */
                    } else if (kickType == .status) {
                        /* This function always gets the status, later. */
                    } else {
                        let kickResult = BkmxAgentRunner().kick(
                            agentBundleIdentifier,
                            orExecutableName: constAppNameBkmxAgent,
                            command: kickType)
                        let code = kickResult.errorCode ?? 0
                        if code > 0 {
                            throw self.makeError(
                                code: code,
                                desc: kickResult.errorDesc,
                                sugg: kickResult.errorSugg)
                        }
                    }
                    
                    /* If in macOS 13 or greater, we can run BkmxAgentRunner
                     to get the resulting status only. */
                    if #available(macOS 13.0, *) {
                        runnerResult = runRunner(kickType: kickType)
                    } else {
                        let agentPid = SSYOtherApper.pid(ofProcessNamed: constAppNameBkmxAgent,
                                                         orBundleIdentifier: agentBundleIdentifier,
                                                         user: NSUserName())
                        runnerResult.agentStatus = (agentPid > 0) ? BkmxAgentStatusEnabled : BkmxAgentStatusNotRegistered
                    }
                }
            }
        } else {
            // Do nothing
            runnerResult = RunnerResult()
            runnerResult.agentStatus = BkmxAgentStatusNotRequested
        }
        
        return runnerResult
    }
    
    @objc
    class RunnerResult : NSObject {
        @objc public var exitStatus: Int32 = -13
        @objc public var agentStatus: BkmxAgentStatus = BkmxAgentStatusInternalError
        @objc public var logText: String = "Internal Error 284-2747"
        @objc public var duration: Double = -1.0  // Would like to make this type TimeInterval and default to nil but cannot because it is @objc.
        @objc public var error: NSError? = nil
    }
    
    private func runRunner(kickType: KickType) -> RunnerResult {
        let command = BkmxAgentRunner.commandName(kickType: kickType)
        
        Self.shared().logString("Will run runner to \(command) BkmxAgent")
        
        let subcommand = String(format: "--\(command)")
        let arguments = [
            subcommand]
        let runnerResult = RunnerResult()
        let runnerUrl = URL(fileURLWithPath: Bundle.mainAppBundle().path(forMacOS: "BkmxAgentRunner"))
        let taskResult = SSYTask.run(runnerUrl,
                                     arguments: arguments,
                                     timeout: 20.0,
                                     wait:true)
        
        switch taskResult {
        case .success(let programResult):
            runnerResult.exitStatus = programResult.exitStatus
            if let stderr = programResult.stderr {
                /* This should never happen, because, I believe, there is no
                 code in BkmxAgentRunner which emits stderr.  Error description
                 and recovery suggestion are encoded into stdout. */
                let stderrString = String(decoding: stderr, as: UTF8.self)
                if stderrString.count > 0 {
                    Self.shared().logString("BkmxAgentRunner surprisingly returned stderr: \(stderrString)")
                }
            }
            if let stdout = programResult.stdout {
                let stdoutString = String(decoding: stdout, as: UTF8.self)
                let scanner = Scanner(string: stdoutString)
                
                runnerResult.logText = scanner.scanUpToString("BkAgRnRsltSTATUS: ") ?? "??"
                _ = scanner.scanString("BkAgRnRsltSTATUS: ")
                
                /* Scan the status value*/
                if var agentStatusRawValue = scanner.scanInt32() {
                    /* If BkmxAgentStatus was a Swift enum, its initializer
                     BkmxAgentStatus() would return nil if agentStatusRawValue
                     was not one of the enumeration values, and we could
                     use the ?? to change it to BkmxAgentStatus.internalError.
                     But since it is an Objective-C enum, the initializer
                     would either, I don't know, crash or return the
                     invalid value.  So, for safety, we check it.  Yes,
                     this is fragile, but Objective-C is fragile. */
                    if ((agentStatusRawValue < -4) || (agentStatusRawValue > 3)) {
                        agentStatusRawValue = BkmxAgentStatusInternalError.rawValue
                    }
                    runnerResult.agentStatus = (BkmxAgentStatus(agentStatusRawValue))
                }
                
                _ = scanner.scanString("BkAgRnRsltDURATION: ")

                /* Scan the duration value */
                if var duration = scanner.scanDouble() {
                    runnerResult.duration = duration
                }
                
                if (runnerResult.exitStatus != EXIT_SUCCESS) {
                    _ = scanner.scanUpToString("BkAgRnRsltERRDESC: ") ?? "No error description!"
                    _ = scanner.scanString("BkAgRnRsltERRDESC: ")
                    
                    let errorDesc = scanner.scanUpToString("BkAgRnRsltERRSUGG: ") ?? "No Error Desc!  Here is the whole stdout from BkmxAgentRunner:\n \(stdoutString)"
                    _ = scanner.scanString("BkAgRnRsltERRSUGG: ")
                    
                    var errorSugg = scanner.scanUpToCharacters(from: CharacterSet())
                    
                    if (runnerResult.agentStatus == BkmxAgentStatusRequiresApproval) && ((kickType == .start) || (kickType == .reboot)) {
                        /* errorSugg should be nil in this situation.  But even if it is
                         not, the following error suggestion is likely to be better, so
                         we overwrite errorSugg in this special case. */
                        errorSugg = String(format:
                                            NSLocalizedString("maybeEnableAgentRunner", comment:"what it says"),
                                           self.appNameLocalized,
                                           self.appNameLocalized)
                    }
                    
                    var userInfo = [NSLocalizedDescriptionKey:"Agent Runner ran but failed."]
                    if runnerResult.logText.count > 0 {
                        userInfo["BkmxAgentRunner Log"] = runnerResult.logText
                    }
                    runnerResult.error = self.makeError(
                        code: 283733,
                        desc: errorDesc,
                        sugg: errorSugg)
                }
            }
        case .failure(let error):
            print("Error: \(error)")
            runnerResult.agentStatus = BkmxAgentStatusInternalError
        }
        
        return runnerResult
    }
    
    private func makeError(code: Int, desc: String?, sugg: String?) -> NSError {
        var userInfo = Dictionary<String, Any>()
        if let desc = desc {
            if (desc.count > 0) {
                userInfo[NSLocalizedDescriptionKey] = desc.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        if let sugg = sugg {
            if (sugg.count > 0) {
                userInfo[NSLocalizedRecoverySuggestionErrorKey] = sugg.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        return NSError(domain: "BkmxAgentRunnerErrorDomain",
                       code: code,
                       userInfo:userInfo)
    }
    
    
    @objc
    func bkmxAgentRegistrationStatusReport() -> String {
        if #available(macOS 13, *) {
            do {
                let result = try self.kickBkmxAgent(kickType: .status)
                let runnerExitStatus = result.exitStatus
                if (runnerExitStatus == EXIT_SUCCESS) {
                    let status = result.agentStatus
                    switch status {
                    case BkmxAgentStatusUnknown:
                        return NSLocalizedString("Someting weent wrong.  The registration status of BkmxAgent could not be determined.",
                                                 comment: "what it says"
                        )
                    case BkmxAgentStatusNotAvailableDueToMacOS12OrEarlier:
                        return NSLocalizedString("Our ability to run Login Items (in  > System Settings > Login Items) could not be determined because you are running macOS 12 or earlier.  If you suspect we are not enabled, look at our switch status in there.",
                                                 comment: "what it says"
                        )
                    case BkmxAgentStatusNotRequested:
                        return NSLocalizedString("Something went wrong.  BkmxAgentRunner did not get our question about the status of BkmxAgent registration.",
                                                 comment: "what it says"
                        )
                    case BkmxAgentStatusNotRegistered:
                        return NSLocalizedString("BkmxAgent is not running, probably because there is no bookmarks collection with Syncing on.",
                                                 comment: "what it says"
                        )
                    case BkmxAgentStatusEnabled:
                        return self.agentEnabledOKText()
                    case BkmxAgentStatusRequiresApproval:
                        return "*** " + self.agentDisabledWarningText() + " ***"
                    case BkmxAgentStatusUnknown:
                        return NSLocalizedString("Someting went wrong.  macOS does not recognize that our internal tool BkmxAgentRunner is even installed.",
                                                 comment: "what it says"
                        )
                    case BkmxAgentStatusNoSuchService:
                        return NSLocalizedString("macOS does not recognize the identifier of BkmxAgent.  This is expected if you have never enabled Syncing since last updating this app.",
                                                 comment: "what it says"
                        )
                    default:
                        return NSLocalizedString("Someting *really* went wrong.  Got an unknown response when querying the status of BkmxAgent registration.",
                                                 comment: "what it says"
                        )
                    }
                } else {
                    var errorDesc: String!
                    let intro = NSLocalizedString("Could not determine registration status of \(constAppNameBkmxAgent) because of error:", comment: "what it says")
                    if let error = result.error {
                        if let errorDesc1 = error.longDescription() {
                            errorDesc = errorDesc1
                        }
                    }
                    return ("\(intro) \(errorDesc ?? "Unknown error, sorry!")")
                }
            } catch {
                return "Could not determine registration status of \(constAppNameBkmxAgent) because \(String(describing: (error as NSError).longDescription))"
            }
        } else {
            return "Registration status of \(constAppNameBkmxAgent) is not available in macOS 12 or earlier."
        }
    }
    
    @objc
    func agentDisabledWarningText() -> String {
        return String(format:
                        NSLocalizedString("mustEnableAgentRunner", comment:"what it says"),
                      self.appNameLocalized,
                      self.appNameLocalized,
                      self.appNameLocalized,
                      self.appNameLocalized)
    }
    
    func agentEnabledOKText() -> String {
        return String(format:
                        NSLocalizedString("agentEnabledOK", comment:"what it says"),
                      self.appNameLocalized)
    }
    
    
    @objc
    func killLoginItem(_ bundleIdentifier: String,
                       pid: pid_t) throws {
        var ok = SSYOtherApper.killThisUsersProcess(withPid: pid,
                                                    sig: SIGTERM,
                                                    timeout: 10.0)
        /*
         Why SIGTERM?
         Somehow, I got an earlier version of BkmxAgent stuck in my
         system.  Its service would always launch when I log back in or
         restart.  I tried passing sig = 1, 2, 3, ... 15.  The first
         14 did not work because the system would immediately restart
         the service with a new process as soon as I killed it.  But,
         miraculously, sig = 15 (=SIGTERM) worked.   */
        
        /* Wait up for 5 seconds for it to terminate. */
        let timeout = 5.0
        ok = NSRunningApplication.waitForApp(bundleIdentifier: bundleIdentifier,
                                             orExecutableName: constAppNameBkmxAgent,
                                             expectRunning: ExpectRunning.no,
                                             timeout: timeout)
        
        if (!ok) {
            /* Even killing did not work. */
            let userInfo = [NSLocalizedDescriptionKey: "Told macOS to SIGTERM old \(bundleIdentifier), but pid \(pid) is still running after \(timeout) secs."]
            throw NSError(domain: NSError.myDomain(),
                          code: 373906,
                          userInfo:userInfo)
        }
        
        /* We shall return immediately, but we will call back 15 seconds
         later if we see that macOS relaunched the old agent. */
        let serialQueue = DispatchQueue(label: "BkmkMgrs.checkThatOldBkmxAgentStaysQuit")
        let checkItTime = DispatchTime.now() + .seconds(15)
        serialQueue.asyncAfter(deadline: checkItTime) {
            let oldAgentsStillRunning = NSRunningApplication.runningApplications(withBundleIdentifier: bundleIdentifier)
            if (oldAgentsStillRunning.isEmpty) {
                BkmxBasis.shared().logString("macOS has *not* restarted the old agent (Good!)")
            } else {
                let newPids = oldAgentsStillRunning.map{$0.processIdentifier}
                let userInfo = [NSLocalizedDescriptionKey: "Told macOS to SIGTERM old \(bundleIdentifier), and pid \(pid) did quit after a few seconds, but then macOS apparently relaunched it with a new pid(s) \(newPids)."]
                let error = NSError(domain: NSError.myDomain(),
                                    code: 373907,
                                    userInfo:userInfo)
                
                if (Thread.current.isMainThread) {
                    SSYAlert.alertError(error)
                } else {
                    DispatchQueue.main.async {
                        SSYAlert.alertError(error)
                    }
                }
                BkmxBasis.shared().logError(error,
                                            markAsPresented: true)
            }
        }
    }
    
    @objc
    func agentDescription (
        executableName: String?,
        bundleIdentifier: String?,
        pid: pid_t,
        rawEtime: String?,
        launchDate: Date?) -> String {
            let parentAppName = self.appNameContainingAgent(withBundleIdentifier: bundleIdentifier)
            let eTime = SSYOtherApper.humanReadableEtime(rawEtime, launch:launchDate)
            return "A BkmxAgent process with these attributes is running:\n    Name: \(executableName ?? "???? (expected if `ps` gave bundle identifier instead)")\n    Bundle Identifier: \(bundleIdentifier ?? "????")\n    Found in app package: \(parentAppName ?? "????")\n    Process Identifier (pid): \(pid)\n    was launched \(eTime ?? "????") ago"
        }
    
    @objc
    func agentDescriptionsGotByUnix() -> [String]? {
        var targetBundleIdentifier: String? = nil
        do {
            targetBundleIdentifier =  try self.bundleIdentifier(forLoginItemName: constAppNameBkmxAgent,
                                                                    inWhich1App: self.iAm())
        } catch {
            return nil
        }
        var agentDescriptions = [String]()
        let args = ["-xaww", "-o", "pid=", "-o", "etime=", "-o", "comm="]
        let programResults = SSYTask.run(
            URL(fileURLWithPath: "/bin/ps"),
            arguments: args,
            inDirectory: nil,
            stdinput: nil,
            timeout: 9.0)
        if (programResults[SSYTask.exitStatusKey] as? Int32 == EXIT_SUCCESS) {
            if let stdoutData = programResults[SSYTask.stdoutKey] as? Data {
                if let processInfosString = String(data: stdoutData, encoding: .utf8) {
                    let processInfoStringsArray = processInfosString.components(separatedBy: "\n")
                    let eTimeCharacterSet = CharacterSet(charactersIn: "01234567890:-")
                    for processInfoString in processInfoStringsArray {
                        let scanner = Scanner(string: processInfoString)
                        /* Scanner skips whitespace by default, which is what we want since
                         the three fields we are about to scan are separated by whitespace. */
                        let pid = scanner.scanInt()
                        let etime = scanner.scanCharacters(from: eTimeCharacterSet)
                        var executableName: String?  = nil
                        var bundleIdentifier: String? = nil
                        if let executablePathOrBundleIdentifier = scanner.scanCharacters(from: .urlPathAllowed) {
                            if let fullURL = URL(string: executablePathOrBundleIdentifier) {
                                if (fullURL.pathComponents.count > 1) {
                                    let executablesUrl = fullURL.deletingLastPathComponent()
                                    let contentsUrl = executablesUrl.deletingLastPathComponent()
                                    let bundleUrl = contentsUrl.deletingLastPathComponent()
                                    executableName = bundleUrl.lastPathComponent
                                    let bundlePath = bundleUrl.absoluteString
                                    let bundle = Bundle(path:bundlePath)
                                    bundleIdentifier = bundle?.bundleIdentifier
                                } else {
                                    bundleIdentifier = executablePathOrBundleIdentifier
                                }
                                if (targetBundleIdentifier == bundleIdentifier) {
                                    let agentDescription = self.agentDescription(
                                        executableName: executableName,
                                        bundleIdentifier: bundleIdentifier,
                                        pid: pid_t(pid ?? 0),
                                        rawEtime: etime,
                                        launchDate: nil)
                                    agentDescriptions.append(agentDescription)
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return agentDescriptions
    }
    
    @objc
    func rawEtimeOfApp(app: NSRunningApplication) -> String? {
        var etimeString: String? = nil
        let pid = app.processIdentifier
        let pidString = String(pid)
        let args = ["-p", pidString, "-o", "etime="]
        let programResults = SSYTask.run(
            URL(fileURLWithPath: "/bin/ps"),
            arguments: args,
            inDirectory: nil,
            stdinput: nil,
            timeout: 5.3)
        if (programResults[SSYTask.exitStatusKey] as? Int32 == EXIT_SUCCESS) {
            if let stdoutData = programResults[SSYTask.stdoutKey] as? Data {
                etimeString = String(data: stdoutData, encoding: .utf8)
            }
        }
        
        return etimeString
    }
    
}
     
