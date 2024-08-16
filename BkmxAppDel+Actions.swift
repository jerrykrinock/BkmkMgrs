import Foundation
import AppKit
import ServiceManagement
import SSYSwift

extension BkmxAppDel {
    private func agentBundleIdentifier() -> String? {
        let executableURL = URL(fileURLWithPath:ProcessInfo().arguments[0])
        let macOSPath = executableURL.deletingLastPathComponent()
        let contentsPath = macOSPath.deletingLastPathComponent()
        let agentBundleURL = contentsPath.appendingPathComponent("Library").appendingPathComponent("LoginItems").appendingPathComponent("BkmxAgent.app")
        let agentBundle = Bundle(url: agentBundleURL)
        return agentBundle?.bundleIdentifier
    }
    
    @IBAction func legacyStartBkmxAgent(_ sender: NSMenuItem) {
        if let agentBundleIdentifier = self.agentBundleIdentifier() {
            let ok = SMLoginItemSetEnabled(agentBundleIdentifier as CFString, true)
            BkmxAgentRunnerLogger().log("\(ok ? "Succeeded" : "Failed") legacy start \(agentBundleIdentifier)")
        }
    }
    
    @IBAction func legacyStopBkmxAgent(_ sender: NSMenuItem) {
        if let agentBundleIdentifier = self.agentBundleIdentifier() {
            let ok = SMLoginItemSetEnabled(agentBundleIdentifier as CFString, false)
            BkmxAgentRunnerLogger().log("\(ok ? "Succeeded" : "Failed") legacy stop \(agentBundleIdentifier)")
        }
    }
}
