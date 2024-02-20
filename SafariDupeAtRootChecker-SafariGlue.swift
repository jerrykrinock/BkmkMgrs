import Foundation

/* Even though I could put these methods in the main files of these structs,
 SafariDupeAtRootChecker.swift and Starkoid.swift, I put them in this separate
 file, to show symmetry with SafariDupeAtRootChecker-BmcoGlue.swift */

extension SafariDupeAtRootChecker {

    @objc
    class func errorFromRootSafariDics(_ safariDics: [Dictionary<String, Any>]) -> NSError? {
        let starkoids = Self.rootSafariChildoids(safariDics: safariDics)
        return Self.error(starkoids, inBmco:false)
    }

    class func rootSafariChildoids(safariDics: [Dictionary<String, Any>]) -> [SafariRootChildoid] {
        return safariDics.map {
            SafariRootChildoid.init(safariDic: $0)
        }
    }

}

extension SafariRootChildoid {
    
    init(safariDic: Dictionary<String, Any>) {
        let type = safariDic["WebBookmarkType"] as? String
        if (type == "WebBookmarkTypeList") {
            self.isFolder = true
            self.name = safariDic["Title"] as? String
        } else if (type == "WebBookmarkTypeLeaf") {
            let innerDic = safariDic["URIDictionary"] as? Dictionary<String, Any>
            if let innerDic = innerDic {
                self.name = innerDic["title"] as? String
            }
            self.url = safariDic["URLString"] as? String
        }
    }
    
}
