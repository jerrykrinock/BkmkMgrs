import Foundation
import OSLog

let agentRunnerLogger = BkmxAgentRunnerLogger()

class BkmxAgentRunnerLogger {
    let osLogger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                          category: "BkmxAR-gory")
    func log(_ s: String) {
        let sds = String(describing: s)
        /* Log to system console */
        /* TIP: If expected messages are not shown in Console.app, in Console.app main
         menu > Action > Include Info/Debug Messages.  Thanks to:
         https://www.avanderlee.com/debugging/oslog-unified-logging/   */
        osLogger.debug("\(sds, privacy: .public)")
        /* Log to stdout, which main app has directed to ~/ApplicationSupport/BookMacster/BkmxAgentRunnerLog.txt */
        print("\(sds)")
    }
}
