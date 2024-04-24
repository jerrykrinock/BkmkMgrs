import Foundation

do {
    agentRunnerLogger.log("LAUNCHED-AT \(NSDate())")
    let executableURL = URL(fileURLWithPath:ProcessInfo().arguments[0])
    let macOSPath = executableURL.deletingLastPathComponent()
    let contentsPath = macOSPath.deletingLastPathComponent()
    let agentBundleURL = contentsPath.appendingPathComponent("Library").appendingPathComponent("LoginItems").appendingPathComponent("BkmxAgent.app")
    let agentBundle = Bundle(url: agentBundleURL)
    if let agentBundleIdentifier = agentBundle?.bundleIdentifier {
        agentRunnerLogger.log("Our BkmxAgent is: \(agentBundleIdentifier)")
        let commandLiner = try BkmxAgentRunnerCommandLiner.parse()
        let whatDo = try commandLiner.getArgs()
        let retult = BkmxAgentRunner().kick(agentBundleIdentifier, whatDo: whatDo)
        agentRunnerLogger.log("TERMINATING-AT: \(NSDate())\n")
        agentRunnerLogger.log("BkAgRnRsltRETVAL: \(retult.returnValue)\n")
        agentRunnerLogger.log("BkAgRnRsltSTATUS: \(retult.status.rawValue)\n")
        if let errorDesc = retult.errorDesc {
            agentRunnerLogger.log("BkAgRnRsltERRDESC: \(errorDesc)\n")
        }
        if let errorSugg = retult.errorSugg {
            agentRunnerLogger.log("BkAgRnRsltERRSUGG: \(errorSugg)\n")
        }
        exit(0)
    } else {
        agentRunnerLogger.log("Failed: BkmxAgent or its bundle identifier was not found in Contents/Library/LoginItems\n")
    }
} catch {
    agentRunnerLogger.log("Error running BkmxAgentRunner: \(String(describing: error))")
}
