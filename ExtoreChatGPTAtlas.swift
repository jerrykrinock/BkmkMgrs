import Foundation

@objc
extension ExtoreChatGPTAtlas {

    @objc
    class open override func refreshFromDiskOur(inMemoryProfileInfoCache cache: ProfileInfoCache!) {

        /* Atlas stores its profile metadata in a binary plist at
         ~/Library/Application Support/com.openai.atlas/profiles/profile-store-data.bak.data
         The non-backup .data file appears to be encrypted, so we
         read the .bak.data file which is a readable plist.

         Each profile entry has:
           id.userID    e.g. "user-si5jBy8c5egbExq5ZTY20Baw"
           id.accountID e.g. "7635ff55-af8e-43eb-9c8c-cc64051c5c1d"
           id.index     e.g. 0 or 1
           name         e.g. "Profile 1" (the user-visible display name)

         The Chromium profile directory name is constructed as:
           <userID>__<accountID>           (when index == 0)
           <userID>__<accountID>__<index>  (when index > 0)
         */

        let homePath = NSHomeDirectory()
        let profileStorePath = (homePath as NSString)
            .appendingPathComponent("Library/Application Support/com.openai.atlas/profiles/profile-store-data.bak.data")

        var displayProfileNames = Dictionary<String,Any>()

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: profileStorePath))
            if let plist = try PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
               let profiles = plist["profiles"] as? [[String: Any]] {
                for profile in profiles {
                    guard let name = profile["name"] as? String,
                          let idDict = profile["id"] as? [String: Any],
                          let userID = idDict["userID"] as? String,
                          let accountID = idDict["accountID"] as? String
                    else { continue }

                    let index = idDict["index"] as? Int ?? 0
                    var folderName = "\(userID)__\(accountID)"
                    if index > 0 {
                        folderName += "__\(index)"
                    }
                    displayProfileNames[folderName] = name
                }
            }
        } catch {
            /* Could not read or parse the profile store file. */
        }

        if displayProfileNames.count == 0 {
            /* Fall back: enumerate user-* directories in the browser
             support path and use folder names as display names. */
            guard let appSupportPath = self.browserSupportPath(forHomePath: nil) else {
                displayProfileNames["Default"] = "Default"
                cache.displayProfileNames = (displayProfileNames as NSDictionary).mutableCopy() as! NSMutableDictionary
                return
            }
            let appSupportUrl = URL(fileURLWithPath: appSupportPath)
            if let contents = try? FileManager.default.contentsOfDirectory(
                at: appSupportUrl,
                includingPropertiesForKeys: [URLResourceKey.isDirectoryKey],
                options: [.skipsHiddenFiles]
            ) {
                for itemUrl in contents {
                    let folderName = itemUrl.lastPathComponent
                    guard folderName.hasPrefix("user-") else { continue }
                    let resourceValues = try? itemUrl.resourceValues(forKeys: Set([URLResourceKey.isDirectoryKey]))
                    if resourceValues?.isDirectory == true {
                        displayProfileNames[folderName] = folderName
                    }
                }
            }
        }

        if displayProfileNames.count == 0 {
            displayProfileNames["Default"] = "Default"
        }

        cache.displayProfileNames = (displayProfileNames as NSDictionary).mutableCopy() as! NSMutableDictionary
    }

    @objc
    class func allProfilesThisHomeSwiftly() -> Set<String> {
        let profileInfoCache = self.profileInfoCache()
        let displayProfileNames = profileInfoCache?.displayProfileNames
        let profileNames = displayProfileNames?.allKeys as! Array<String>
        return Set(profileNames)
    }

}
