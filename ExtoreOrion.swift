import Foundation

@objc
extension ExtoreOrion {
    
    @objc
    class open override func refreshFromDiskOur(inMemoryProfileInfoCache cache: ProfileInfoCache!) {
        
        /* Try to read the "profiles" file which we have reverse-engineered. */
        let profilesFileUrl = URL(fileURLWithPath: self.browserSupportPath(forHomePath: nil)).appendingPathComponent("profiles", isDirectory: false)
        let profilesFilePath = profilesFileUrl.path
        var displayProfileNames = Dictionary<String,Any>()
        do {
            if(FileManager.default.isReadableFile(atPath: profilesFilePath)) {
                let data = try Data(contentsOf: URL(fileURLWithPath: profilesFilePath))
                let decoder = PropertyListDecoder()
                let rootDic = try decoder.decode([String: AnyDecodable].self, from:data) as Dictionary<String, AnyDecodable>
                /* This dictionary is a little strange.  If there is only
                 one profile, 'Default", then its information is stored as
                 a dictionary under key "defaults".  If there is more than
                 one profile, then similar information dictionaries for the
                 *additional* profiles are stored in an *array* under key
                 "profiles".  In other words, it's like multiple profile
                 support was bolted on after the initial design :(  */
                let defaultsDic = rootDic["defaults"]?.value as? Dictionary<String, Any>
                let profileName = defaultsDic?["identifier"]  // probably "Defaults"
                let displayProfileName = defaultsDic?["name"]  // probably "Default"
                /* The following 'if let' should always execute, since there
                 is always at least one profile. */
                if let profileName = profileName as? String, let displayProfileName = displayProfileName as? String{
                    /* Append to our displayProfileNames. */
                    displayProfileNames[profileName] = displayProfileName
                }
                /* The following will execute if there is more than one
                 profile. */
                if let otherProfileDics = rootDic["profiles"]?.value as? [Dictionary<String, Any>] {
                    for otherProfileDic in otherProfileDics {
                        let profileName = otherProfileDic["identifier"]
                        let displayProfileName = otherProfileDic["name"]
                        /* Append to our displayProfileNames in the same
                         way as we appended the default profile. */
                        if let profileName = profileName as? String, let displayProfileName = displayProfileName as? String{
                                displayProfileNames[profileName] = displayProfileName
                        }
                    }
                }
            }
        } catch {
            /* Could not read the "profiles" file.  This may happen if
             Orion changes in the future.  This will cause displayProfileNames
             to be empty, which we handle subsequently. */
        }
        
        if (displayProfileNames.count == 0) {
            /* Our reverse-engineered file reading or file decoding failed.
             Assume that there is only the default profile, with the default
             display name. */
            displayProfileNames["Defaults"] = "default"
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
