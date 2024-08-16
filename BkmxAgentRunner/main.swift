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
        
        let kickResult = BkmxAgentRunner().kick(
            agentBundleIdentifier,
            orExecutableName: "BkmxAgent", // Should use constAppNameBkmxAgent, but for economy I don't want ta rget BkmxAgentRunner to include BkmxGlobals or link to Bkmxwork.
            command: whatDo)
        
        agentRunnerLogger.log("TERMINATING-AT: \(NSDate())\n")
        agentRunnerLogger.log("BkAgRnRsltSTATUS: \(kickResult.agentStatus.rawValue)\n")
        var exitStatus = EXIT_SUCCESS
        if let errorDesc = kickResult.errorDesc {
            exitStatus = EXIT_FAILURE
            agentRunnerLogger.log("BkAgRnRsltERRDESC: \(errorDesc)\n")
        }
        if let errorSugg = kickResult.errorSugg {
            agentRunnerLogger.log("BkAgRnRsltERRSUGG: \(errorSugg)\n")
        }
        exit(exitStatus)
    } else {
        agentRunnerLogger.log("Failed: BkmxAgent or its bundle identifier was not found in Contents/Library/LoginItems\n")
        exit(EXIT_FAILURE)
    }
} catch {
    agentRunnerLogger.log("Error running BkmxAgentRunner: \(String(describing: error))")
    exit(EXIT_FAILURE)
}
