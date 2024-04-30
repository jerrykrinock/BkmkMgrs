import Foundation
import ServiceManagement
import Cocoa

// " Result Tuplet"
typealias Retult = (returnValue: Int, status: BkmxAgentStatus, errorDesc: String?, errorSugg: String?)

class BkmxAgentRunner {
    func kick(_ bundleIdentifier: String, whatDo: KickType) -> Retult{
        var ok = false
        var errorDesc: String? = nil
        var errorSugg: String? = nil
        
        var whatDoing: String
        switch whatDo {
        case .nothing:
            whatDoing = "NOOP"
        case .start:
            whatDoing = "START"
        case .stop:
            whatDoing = "STOP"
        case .reboot:
            whatDoing = "REBOOT"
        case .status:
            whatDoing = "STATUS"
        @unknown default:
            whatDoing = "NOOP"
        }
        agentRunnerLogger.log("Will \(whatDoing) \(bundleIdentifier)")
        
        let timeout = 3.0
        switch (whatDo) {
        case .start:
            self.switchLoginItem(true, bundleIdentifier: bundleIdentifier)
            ok = NSRunningApplication.waitForApp(bundleIdentifier: bundleIdentifier, expectRunning: ExpectRunning.yes, timeout: timeout)
            if (!ok) {
                errorDesc = "Agent Runner commanded macOS to start BkmxAgent, but it was still not running after \(timeout) seconds."
            }
        case .stop:
            self.switchLoginItem(false, bundleIdentifier: bundleIdentifier)
            ok = NSRunningApplication.waitForApp(bundleIdentifier: bundleIdentifier, expectRunning: ExpectRunning.no, timeout: timeout)
            if (!ok) {
                errorDesc = "Agent Runner commanded macOS to stop BkmxAgent, but it was still running after \(timeout) seconds."
            }
        case .reboot:
            self.switchLoginItem(false, bundleIdentifier: bundleIdentifier)
            ok = NSRunningApplication.waitForApp(bundleIdentifier: bundleIdentifier, expectRunning: ExpectRunning.no, timeout: timeout)
            if (!ok) {
                errorDesc = "Agent Runner commanded macOS to stop BkmxAgent, so it could be rebooted, but it was still  running after \(timeout) seconds."
                errorSugg = "Try to quit BkmxAgent by using the Activity Monitor app."
            } else {
                self.switchLoginItem(true, bundleIdentifier: bundleIdentifier)
                ok = NSRunningApplication.waitForApp(bundleIdentifier: bundleIdentifier, expectRunning: ExpectRunning.yes, timeout: timeout)
                if (!ok) {
                    errorDesc = "Agent Runner commanded macOS to relaunch BkmxAgent after quitting, but it was still not running after \(timeout) seconds."
                }
            }
        case .status:
            ok = true
        case .nothing:
            errorDesc = "Nothing to do"
        @unknown default:
            errorDesc = "Unknown KickType"
        }

        let returnValue = (ok == true) ? 0 : 1
        let status = self.getStatus(bundleIdentifier)
        let retult: Retult = (returnValue, status, errorDesc, errorSugg)

        return retult
    }
    
    
    fileprivate func getStatus(_ bundleIdentifier: String) -> BkmxAgentStatus {
        if #available(macOS 13.0, *) {
            let service = SMAppService.loginItem(identifier: bundleIdentifier)
            let statusAsInt = service.status.rawValue
            /* Note that if the service is disallowed in System Settings >
             Login Items AND the service is not registered, the above system
             call will ignore the Login Items setting and return .notRegistered.
             Therefore, you cannot get the Login Item switch status of a service
             unless it is registered or trying to be registered. */
            agentRunnerLogger.log("Got SMAppService status: \(statusAsInt)")
            let status = BkmxAgentRunner.bkmxAgentStatus(smStatus: statusAsInt)
            agentRunnerLogger.log("Translated to BkmxAgentStatus: \(status.rawValue) = \(self.humanReadableBkmxAgentStatus(status))")
            return status
        } else {
            // Fallback on earlier versions
            return BkmxAgentStatusNotAvailableDueToMacOS12OrEarlier
        }

    }
    
    /**
     Maps Apple's SMAppService.Status to my BkmxAgentStatus
     
     - parameter smstatus : It would be nice to have this pamameter be
     SMAppService.Status instead of Int, but no can do since we must compile
     for older versions macOS 11 and 12.
     - returns: The equivalent BkmxAgentStatus
     */
    @discardableResult
    fileprivate class func bkmxAgentStatus(smStatus: Int) -> BkmxAgentStatus{
        switch (smStatus) {
        case 0:
            return BkmxAgentStatusNotRegistered
        case 1:
            return BkmxAgentStatusEnabled
        case 2:
            return BkmxAgentStatusRequiresApproval
        case 3:
            return BkmxAgentStatusNoSuchService
        default:
            return BkmxAgentStatusUnknown
         
        }
    }
    
    func humanReadableBkmxAgentStatus(_ status: BkmxAgentStatus) -> String {
        switch(status) {
        case BkmxAgentStatusUnknown:
            return "Unknown"
        case BkmxAgentStatusNotAvailableDueToMacOS12OrEarlier:
            return "Not Available cuz macOS 12 or earlier"
        case BkmxAgentStatusNotRequested:
            return "Not Requested"
        case BkmxAgentStatusNotRegistered:
            return "Not Registered (not running)"
        case BkmxAgentStatusEnabled:
            return "Enabled (should be running)"
        case BkmxAgentStatusRequiresApproval:
            return "Requires Approval in System Settings > Login Items"
        case BkmxAgentStatusNoSuchService:
            return "No Such Service"
        default:
            return "An Unknown Unknown"
        }
     }
    
    func switchLoginItem(_ onOff: Bool, bundleIdentifier: String) {
        if #available(macOS 13, *) {
            let service = SMAppService.loginItem(identifier: bundleIdentifier)
            if (onOff) {
                do {
                    agentRunnerLogger.log("Will try to register \(bundleIdentifier)")
                    try service.register()
                    agentRunnerLogger.log("Did register service")
                } catch {
                    agentRunnerLogger.log("Error registering: \(String(describing: error.localizedDescription))\n")
                }
            } else {
                do {
                    agentRunnerLogger.log("Will try to unregister \(bundleIdentifier)")
                    try service.unregister()
                    agentRunnerLogger.log("Did unregister service")
                } catch {
                    agentRunnerLogger.log("Error unregistering: \(String(describing: error.localizedDescription))\n")
                }
            }
        } else {
            let cfBundleIdentifier = bundleIdentifier as CFString
            agentRunnerLogger.log("Will try legacy SMLoginItemSetEnabled: \(onOff ? "enable" : "disable"))\n")
            let ok = SMLoginItemSetEnabled(cfBundleIdentifier, onOff)
            if (!ok) {
                agentRunnerLogger.log("SMLoginItemSetEnabled failed switching \(onOff ? "on" : "off"))\n")
            }
        }
    }
    
    // MARK:= Error Handling
    /* This is a work in progress, trying to do as explained here:
     https://www.swiftbysundell.com/articles/providing-a-unified-swift-error-api/ */
    
    func perform<T>(_ expression: @autoclosure () throws -> T,
                    orThrow: (Error) -> Error) throws -> T {
        do {
            return try expression()
        } catch {
            throw orThrow(error)
        }
    }
    
}

import Foundation
