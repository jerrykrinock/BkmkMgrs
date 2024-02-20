import Foundation
import Cocoa

/*
 Explanation of why we have the BkmxAgentRunner helper app:
 
 There are apparently memory leaks which we cannot find in BkmxAgent, or maybe
 these leaks are just Core Data being Core Data.  Anyhow, we have seen that
 memory usage in BkmnxAgent increases with each syncing operation.  Our fix
 for this is to quit and relaunch BkmxAgent after each syncing operation.
 
 Until BkmkMgrs 3.1, we did this by calling -terminate: in BkmxAgent, and relied
 on macOS Service Management magic to relaunch it.  But then in a beta version
 of macOS 14.3, we found that the relaunching did not happen.  Apparently this
 was a bug in that beta, because in the next beta it started working again.
 But by that point, we was far down the road of this new mechanism, which is
 also less kludgey that -terminate:
 
 The new mechanism is BkmxAgentRunner, a faceless background app which is
 launched by either the main app or BkmxAgent with a commnand-line argument
 to start, stop, reboot or read the status of BkmxAgent, which now resides
 in the /Contents/Library/LoginItems of BkmxAgentRunner rather than in
 the main app.  (The move was because SMAppService can only operate upon
 services which reside in their own package.)
 
 The downside is that in  > System Settings > Login Items, users must now
 switch on "BkmxAgentRunner" instead of the more recognizable main app name.
 */

@main
class BkmxAgentRunnerAppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        do {
            agentRunnerLogger.log("BkmxAgentRunner launched at \(NSDate())")
            let kickerBundle = Bundle.main
            let kickerBundleURL = kickerBundle.bundleURL
            let agentBundleURL = kickerBundleURL.appendingPathComponent("Contents").appendingPathComponent("Library").appendingPathComponent("LoginItems").appendingPathComponent("BkmxAgent.app")
            let agentBundle = Bundle(url: agentBundleURL)
            if let agentBundleIdentifier = agentBundle?.bundleIdentifier {
                agentRunnerLogger.log("Our BkmxAgent is: \(agentBundleIdentifier)")
                let commandLiner = try BkmxAgentRunnerCommandLiner.parse()
                let whatDo = try commandLiner.getArgs()
                try BkmxAgentRunner().kick(agentBundleIdentifier, whatDo: whatDo)
                agentRunnerLogger.log("Terminating at \(NSDate())")
                NSApplication.shared.terminate(self)
            } else {
                agentRunnerLogger.log("Failed: BkmxAgent or its bundle identifier was not found in Contents/Library/LoginItems\n")
            }
        } catch {
            agentRunnerLogger.log("Error running BkmxAgentRunner: \(String(describing: error))")
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}
