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
        var statusInt = -3
        
        var error: NSError? = nil
        let kickerPath = Bundle.mainAppBundle().path(forHelper: "BkmxAgentRunner.app")
        if let appSupportPath  = Bundle.main.applicationSupportPathForMotherApp() {
            let appSupportUrl = URL(fileURLWithPath: appSupportPath)
            let stdoutUrl = appSupportUrl.appendingPathComponent("BkmxAgentRunnerLog.txt")
            let stdoutPath = stdoutUrl.path
            /* Remove stdout of previous run from disk.
             The "?" ignores error if file is not present */
            try? FileManager.default.removeItem(atPath: stdoutPath)
            let subcommand = String(format: "--\(whatDo)")
            let arguments = [
                "-a",
                kickerPath,
                "-W",
                "--stdout",
                stdoutPath,
                "--args",
                subcommand]
            let taskResult = SSYShellTasker.doShellTaskCommand("/usr/bin/open",
                                                               arguments: arguments as [Any],
                                                               inDirectory: nil,
                                                               stdinData: nil,
                                                               stdoutData_p: nil,
                                                               stderrData_p: nil,
                                                               timeout: 20.0,
                                                               error_p: &error)
            if (taskResult != 0) {
                // throw BkmxAgentRunnerErrorTOTALSWIFT.couldNotEvenLaunchAgentRunner(underlying: error)
                let wrappedError = BkmxAgentRunnerError(.couldNotEvenLaunchAgentRunner, underlying: error)
                throw wrappedError
            }
            var stdoutData: Data? = nil
            do {
                stdoutData = try Data(contentsOf: stdoutUrl)
            } catch {
                throw BkmxAgentRunnerError(.couldNotReadLogFileFromAgentRunner)
            }
            if let stdoutData = stdoutData {
                let stdoutString = String(decoding: stdoutData, as: UTF8.self)
                let scanner = Scanner(string: stdoutString)
                
                /* Scan and discard into _ the 'log' text: */
                _ = scanner.scanUpToString("BkAgRnRsltRETVAL: ") ?? "??"
                
                /* Scan and discard into _ a delimiter */
                _ = scanner.scanString("BkAgRnRsltRETVAL: ")
                
                returnValue = scanner.scanInt() ?? -11
                
                /* Scan and discard into _ a delimiter: */
                _ = scanner.scanString("BkAgRnRsltSTATUS: ")
                
                statusInt = scanner.scanInt() ?? -13
            }            
        }
        
        return [
            constKeyReturnValue: returnValue,
            constKeyStatus: statusInt
        ]
    }
    
    
    @objc
    func bkmxAgentRegistrationStatusReport() -> String {
        if #available(macOS 13, *) {
            do {
                let results = try self.kickBkmxAgent(kickType: .status)
                let status = Int32((results[constKeyStatus] as? Int) ?? Int(BkmxAgentStatusUnknown.rawValue))
                switch status {
                case BkmxAgentStatusUnknown.rawValue:
                    return NSLocalizedString("Someting weent wrong.  The status of BkmxAgentRunnner could not be determined.",
                                             comment: "what it says"
                    )
                case BkmxAgentStatusNotAvailableDueToMacOS12OrEarlier.rawValue:
                    return NSLocalizedString("The status of BkmxAgentRunnner (in  > System Settings > Login Items) could not be determined because you are running macOS 12 or earlier.  You must look in there manually if you suspect it is not enabled.",
                                             comment: "what it says"
                    )
                case BkmxAgentStatusNotRequested.rawValue:
                    return NSLocalizedString("Something went wrong.  BkmxAgentRunner did not get our question about its status.",
                                             comment: "what it says"
                    )
                case BkmxAgentStatusNotRegistered.rawValue:
                    return NSLocalizedString("BkmxAgent is not running, probably because there is no bookmarks collection with Syncing on.",
                                             comment: "what it says"
                    )
                case BkmxAgentStatusEnabled.rawValue:
                    return NSLocalizedString("BkmxAgentRunner is enabled in main menu:  > System Settings > Login Items BkmxAgentRunner, and is therefore able to run BkmxAgent.  (Good!)",
                                             comment: "what it says"
                    )
                case BkmxAgentStatusRequiresApproval.rawValue:
                    return "*** " + NSLocalizedString("mustEnableAgentRunner",
                                                      comment: "what it says"
                    ) + " ***"
                case BkmxAgentStatusUnknown.rawValue:
                    return NSLocalizedString("Someting went wrong.  macOS does not recognize that BkmxAgentRunner is even installed.",
                                             comment: "what it says"
                    )
                case BkmxAgentStatusNoSuchService.rawValue:
                    return NSLocalizedString("Cannot tell if the correct BkmmxAgent is running or not, because SMAppService says it does not recognize the bundle identifier which BkmxAgentRunner gave it.  (Very strange!!)",
                                             comment: "what it says"
                    )
                default:
                    return NSLocalizedString("Someting *really* went wrong.  BkmxAgentRunner returned an unknown response when asked for its status.",
                                             comment: "what it says"
                    )
                }
            } catch {
                return "macOS could not determine registration status of \(constAppNameBkmxAgent) because \(String(describing: error))"
            }
        } else {
            return "Registration status of \(constAppNameBkmxAgent) is not available in macOS 12 or earlier."
        }
    }
}
