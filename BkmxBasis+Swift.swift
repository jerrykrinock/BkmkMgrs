import Foundation
import ServiceManagement

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
    func kickBkmxAgent(kickType: KickType) throws -> Dictionary<String, Any> {
        var whatDo = "nuthin"
        if ((kickType == .stop) || (self.coreDataMigrationDelegate == nil) || (self.coreDataMigrationDelegate?.countMigrationsInProcess == 0)) {
            switch (kickType) {
            case .stop:
                whatDo = "stop"
            case .start:
                /* Just to be sure, since it is more robust, when we want
                 to start, we also reboot.  For example, if the BkmxAgent
                 is hung or in some other bad state, we want to quit the
                 old one first. */
                whatDo = "reboot"
            case .reboot:
                whatDo = "reboot"
            case .nothing:
                whatDo = "nothing"
            case .status:
                whatDo = "status"
            default:
                whatDo = "dunno"
            }
        }
        
        Self.shared().logString("Will \(whatDo) BkmxAgent")
        
        var returnValue = 5
        var status = -3
        var logText = "No log text"
        
        var error: NSError? = nil
        let runnerPath = Bundle.mainAppBundle().path(forMacOS: "BkmxAgentRunner")
        let subcommand = String(format: "--\(whatDo)")
        let arguments = [
            subcommand]
        var stdout: NSData? = nil
        var stderr: NSData? = nil
        let taskResult = SSYShellTasker.doShellTaskCommand(runnerPath,
                                                           arguments: arguments as [Any],
                                                           inDirectory: nil,
                                                           stdinData: nil,
                                                           stdoutData_p: &stdout,
                                                           stderrData_p: &stderr,
                                                           timeout: 20.0,
                                                           error_p: &error)
        if (error == nil) {
            if let stderr = stderr {
                let stdoutString = String(decoding: stderr, as: UTF8.self)
                if stdoutString.count > 0 {
                    Self.shared().logString("BkmxAgentRunner returned stderr: \(stdoutString)")
                }
            }

            if (taskResult != 0) {
                let wrappedError = BkmxAgentRunnerError(.couldNotEvenLaunchAgentRunner, underlying: error)
                throw wrappedError
            }
            if let stdout = stdout {
                let stdoutString = String(decoding: stdout, as: UTF8.self)
                let scanner = Scanner(string: stdoutString)
                
                logText = scanner.scanUpToString("BkAgRnRsltRETVAL: ") ?? "??"
                _ = scanner.scanString("BkAgRnRsltRETVAL: ")
                
                returnValue = scanner.scanInt() ?? -11
                
                _ = scanner.scanUpToString("BkAgRnRsltSTATUS: ") ?? "??"
                _ = scanner.scanString("BkAgRnRsltSTATUS: ")

                /* Scan the status value*/
                status = scanner.scanInt() ?? -12

                if (returnValue != 0) {
                    _ = scanner.scanUpToString("BkAgRnRsltERRDESC: ") ?? "No error description!"
                    _ = scanner.scanString("BkAgRnRsltERRDESC: ")

                    let errorDesc = scanner.scanUpToString("BkAgRnRsltERRSUGG: ") ?? "??"
                    _ = scanner.scanString("BkAgRnRsltERRSUGG: ")

                    var errorSugg = scanner.scanUpToCharacters(from: CharacterSet())
                    
                    if (status == BkmxAgentStatusRequiresApproval.rawValue) && ((kickType == .start) || (kickType == .reboot)) {
                        /* errorSugg should be nil in this situation.  But even if it is
                         not, the following error suggestion is likely to be better, so
                         we overwrite errorSugg in this special case. */
                        errorSugg = String(format:
                                        NSLocalizedString("maybeEnableAgentRunner", comment:"what it says"),
                                      self.appNameLocalized,
                                      self.appNameLocalized)
                    }

                    var userInfo = [NSLocalizedDescriptionKey:"Agent Runner ran but failed."]
                    if logText.count > 0 {
                        userInfo["BkmxAgentRunner Log"] = logText
                    }
                    if (errorDesc.count > 0) {
                        userInfo[NSLocalizedDescriptionKey] = errorDesc.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                    if let errorSugg = errorSugg {
                        userInfo[NSLocalizedRecoverySuggestionErrorKey] = errorSugg.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                    error = NSError(domain:"BkmxAgentRunnerErrorDomain",
                                    code: 283732,
                                    userInfo:userInfo)
                    if let error = error {
                        throw error
                    }
                }
            }
        }
        
        return [
            constKeyReturnValue: returnValue,
            constKeyStatus: status,
            constKeyLogText: logText
        ]
    }
    
    @objc
    func bkmxAgentRegistrationStatusReport() -> String {
        if #available(macOS 13, *) {
            do {
                let results = try self.kickBkmxAgent(kickType: .status)
                let returnValue = Int32((results[constKeyReturnValue] as? Int) ?? Int(2))
                if (returnValue == 0) {
                    let status = Int32((results[constKeyStatus] as? Int) ?? Int(BkmxAgentStatusUnknown.rawValue))
                    switch status {
                    case BkmxAgentStatusUnknown.rawValue:
                        return NSLocalizedString("Someting weent wrong.  The registration status of BkmxAgent could not be determined.",
                                                 comment: "what it says"
                        )
                    case BkmxAgentStatusNotAvailableDueToMacOS12OrEarlier.rawValue:
                        return NSLocalizedString("Our ability to run Login Items (in  > System Settings > Login Items) could not be determined because you are running macOS 12 or earlier.  If you suspect we are not enabled, look at our switch status in there.",
                                                 comment: "what it says"
                        )
                    case BkmxAgentStatusNotRequested.rawValue:
                        return NSLocalizedString("Something went wrong.  BkmxAgentRunner did not get our question about the status of BkmxAgent registration.",
                                                 comment: "what it says"
                        )
                    case BkmxAgentStatusNotRegistered.rawValue:
                        return NSLocalizedString("BkmxAgent is not running, probably because there is no bookmarks collection with Syncing on.",
                                                 comment: "what it says"
                        )
                    case BkmxAgentStatusEnabled.rawValue:
                        return self.agentEnabledOKText()
                    case BkmxAgentStatusRequiresApproval.rawValue:
                        return "*** " + self.agentDisabledWarningText() + " ***"
                    case BkmxAgentStatusUnknown.rawValue:
                        return NSLocalizedString("Someting went wrong.  macOS does not recognize that our internal tool BkmxAgentRunner is even installed.",
                                                 comment: "what it says"
                        )
                    case BkmxAgentStatusNoSuchService.rawValue:
                        return NSLocalizedString("Cannot tell if the correct BkmmxAgent is running or not, because SMAppService says it does not recognize the bundle identifier which BkmxAgentRunner gave it.  (Very strange!!)",
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
                    if let error = results[constKeyError] as? NSError {
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
                                    code: 373906,
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
}
     
