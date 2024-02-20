import Foundation
import ServiceManagement

typealias Retult = (returnValue: Int, status: BkmxAgentStatus)

class BkmxAgentRunner {
    func kick(_ bundleIdentifier: String, whatDo: KickType) throws {
        var retult = Retult(1, BkmxAgentStatusUnknown)
        var ok = false
        
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
        
        switch (whatDo) {
        case .start:
            try self.switchLoginItem(true, bundleIdentifier: bundleIdentifier)
            ok = NSRunningApplication.waitForApp(bundleIdentifier: bundleIdentifier, expectRunning: true, timeout: 3.0)
        case .stop:
            try self.switchLoginItem(false, bundleIdentifier: bundleIdentifier)
            ok = NSRunningApplication.waitForApp(bundleIdentifier: bundleIdentifier, expectRunning: false, timeout: 3.0)
        case .reboot:
            try self.switchLoginItem(false, bundleIdentifier: bundleIdentifier)
            NSRunningApplication.waitForApp(bundleIdentifier: bundleIdentifier, expectRunning: false, timeout: 3.0)
            try self.switchLoginItem(true, bundleIdentifier: bundleIdentifier)
            ok = NSRunningApplication.waitForApp(bundleIdentifier: bundleIdentifier, expectRunning: true, timeout: 3.0)
        case .status:
            ok = true
        case .nothing:
            agentRunnerLogger.log("Nothing to do")
            retult = (7, BkmxAgentStatusNotRequested)
        @unknown default:
            agentRunnerLogger.log("Unknown KickType")
            retult = (8, BkmxAgentStatusNotRequested)
        }

        retult.returnValue = (ok == true) ? 0 : 1
        retult.status = self.getStatus(bundleIdentifier)

        
        agentRunnerLogger.log("BkAgRnRsltRETVAL: \(retult.returnValue)")
        agentRunnerLogger.log(String(format: "BkAgRnRsltSTATUS: %d", retult.status.rawValue))
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
    
    func switchLoginItem(_ onOff: Bool, bundleIdentifier: String) throws {
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
    
    /**
     Checks if an app with the given bundle identifier is running, waiting
     up to a timeout of 3 seconds to meet a given expectation
     
     - parameter expectRunning: true if you want to wait for the app to be
     running, false if you want to wait for the app to be not running
     - returns: true if your running/not expectation is met within the timeout,
     false if a timeout occurs before the expectation is met
     */
  
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
