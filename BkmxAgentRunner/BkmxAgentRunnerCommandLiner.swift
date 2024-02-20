import Foundation
import ArgumentParser

struct BkmxAgentRunnerCommandLiner: ParsableCommand {
    /* Reference explaining how all of the magic in here works:
     https://www.swift.org/blog/argument-parser/  */

    static let configuration = CommandConfiguration(abstract: "Starts, stops or reboots an enclosed macOS Login Item.")
    
    @Flag var start = false
    @Flag var stop = false
    @Flag var reboot = false
    @Flag var status = false
    
    /* The following is to swallow without error the two arguments which
     are inserted by macOS when it launches a .app (BkmxAgentRunner is a .app):
     "-NSDocumentRevisionsDebugMode" and "YES".  These arguments are not
     passed if you start an app with `open`.  I'm not yet sure what will
     happen when BkmxAgentRunner is launched by the main app. */
    @Argument(parsing: .allUnrecognized) var other: [String] = []
    
    func getArgs() throws -> KickType  {
        agentRunnerLogger.log("Ignoring unrecognized argument(s): \(other)")
        if (start) {
            return .start
        } else if (stop) {
            return .stop
        } else if (reboot) {
            return .reboot
        } else if (status) {
            return .status
        } else {
            return .nothing
        }
    }
}

