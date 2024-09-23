import Foundation
import ServiceManagement
import Cocoa
import SSYSwift

// " Result Tuplet"
typealias KickResult = (
    agentStatus: BkmxAgentStatus,
    duration: TimeInterval,
    errorCode: Int?,
    errorDesc: String?,
    errorSugg: String?
)

class BkmxAgentRunner {
    
    public class func commandName(kickType: KickType) -> String {
        switch (kickType) {
        case .stop:
            return "stop"
        case .start:
            return "start"
        case .reboot:
            return "reboot"
        case .nothing:
            return "nothing"
        case .status:
            return "status"
        default:
            return "dunno"
        }
    }
    
    func kick(_ bundleIdentifier: String,
              orExecutableName: String,
              command: KickType) -> KickResult {
        var errorCode: Int? = nil
        var errorDesc: String? = nil
        var errorSugg: String? = nil
        
        let readableKickType = Self.commandName(kickType: command)
        agentRunnerLogger.log("Will --\(readableKickType) \(bundleIdentifier)")

        /* The time to launch BkmxAgent has been observed to be as much as
         20 seconds on my M1 MacBook Air running macOS 15, if I Restart with
         BookMacster and a dozen other apps running, and the checkbox
         "Reopen windows when logging back in" ON.  So we triple
         20 seconds for margin:  */
        let timeout = 60.1232
        var ok: Bool
        let processName = ProcessInfo.processInfo.processName
        var duration = -3.777
        let startDate = Date()
        switch (command) {
        case .start:
            self.switchLoginItem(true, bundleIdentifier: bundleIdentifier)
            ok = NSRunningApplication.waitForApp(bundleIdentifier: bundleIdentifier,
                                                 orExecutableName: orExecutableName,
                                                 expectRunning: ExpectRunning.yes,
                                                 timeout: timeout)
            if (!ok) {
                errorCode = 288421
                errorDesc = "\(processName) commanded macOS to start \(bundleIdentifier), but it was still not running after \(timeout) seconds."
            }
        case .stop:
            self.switchLoginItem(false, bundleIdentifier: bundleIdentifier)
            ok = NSRunningApplication.waitForApp(bundleIdentifier: bundleIdentifier,
                                                 orExecutableName: orExecutableName,
                                                 expectRunning: ExpectRunning.no,
                                                 timeout: timeout)
            if (!ok) {
                errorCode = 288422
                errorDesc = "\(processName) commanded macOS to stop \(bundleIdentifier), but it was still running after \(timeout) seconds."
            }
        case .reboot:
            self.switchLoginItem(false, bundleIdentifier: bundleIdentifier)
            ok = NSRunningApplication.waitForApp(bundleIdentifier: bundleIdentifier,
                                                 orExecutableName: orExecutableName,
                                                 expectRunning: ExpectRunning.no,
                                                 timeout: timeout)
            if (!ok) {
                errorCode = 288423
                errorDesc = "\(processName) commanded macOS to stop \(bundleIdentifier), so it could be rebooted, but it was still  running after \(timeout) seconds."
                errorSugg = "Try to quit BkmxAgent by using the Activity Monitor app."
            } else {
                self.switchLoginItem(true, bundleIdentifier: bundleIdentifier)
                ok = NSRunningApplication.waitForApp(bundleIdentifier: bundleIdentifier,
                                                     orExecutableName: orExecutableName,
                                                     expectRunning: ExpectRunning.yes,
                                                     timeout: timeout)
                if (!ok) {
                    errorCode = 288424
                    errorDesc = "\(processName) commanded macOS to relaunch \(bundleIdentifier) after quitting, but it was still not running after \(timeout) seconds."
                }
            }
        case .status:
            ok = true
        case .nothing:
            errorCode = 288425
            errorDesc = "Nothing to do"
        @unknown default:
            errorCode = 288426
            errorDesc = "Unknown KickType"
        }

        duration = Date().timeIntervalSince(startDate)
        agentRunnerLogger.log("BkmxAgent took \(duration) seconds to \(readableKickType) [1]")

        let agentStatus = self.getAgentStatus(bundleIdentifier)

        return KickResult(agentStatus, duration, errorCode, errorDesc, errorSugg)
    }
    
    
    fileprivate func getAgentStatus(_ bundleIdentifier: String) -> BkmxAgentStatus {
        if #available(macOS 13.0, *) {
            let service = SMAppService.loginItem(identifier: bundleIdentifier)
            let agentStatusAsInt = service.status.rawValue
            /* Note that if the service is disallowed in System Settings >
             Login Items AND the service is not registered, the above system
             call will ignore the Login Items setting and return .notRegistered.
             Therefore, you cannot get the Login Item switch status of a service
             unless it is registered or trying to be registered. */
            agentRunnerLogger.log("Got SMAppService status: \(agentStatusAsInt)")
            let agentStatus = BkmxAgentRunner.bkmxAgentStatus(smStatus: agentStatusAsInt)
            agentRunnerLogger.log("Translated to BkmxAgentStatus: \(agentStatus.rawValue) = \(self.humanReadableBkmxAgentStatus(agentStatus))")
            return agentStatus
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
    
    fileprivate func humanReadableBkmxAgentStatus(_ status: BkmxAgentStatus) -> String {
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
    
    fileprivate func switchLoginItem(_ onOff: Bool, bundleIdentifier: String) {
        if #available(macOS 14, *) {
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
            agentRunnerLogger.log("Will try legacy SMLoginItemSetEnabled: \(onOff ? "true" : "false")\n")
            let ok = SMLoginItemSetEnabled(cfBundleIdentifier, onOff)
            if (!ok) {
                agentRunnerLogger.log("SMLoginItemSetEnabled failed switching \(onOff ? "on" : "off")\n")
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
