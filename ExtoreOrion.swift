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
    
    /* Added in BkmkMgrs 3.3.7.  Do not export empty folders to Orion.  It was found
     in 2026 Feb that, if you attempt an export which contains an empty folder to
     Orion, the BookMacster Sync extension will time out when getting exids, running
     -[Extore timedOutExportFeedbackTimer:] and displaying in a dialog to the user
     that Orion "did not send new identifiers as expected after we exported to it.".
     Importing empty folders from Orion works OK.  This issue is not seen in Google
     Chrome.

     HISTORY / WHY HERE AND NOT IN -isExportableStark:withChange:

     This empty-folder filtering was first (wrongly) implemented by overriding
     -isExportableStark:withChange: to return NO for a childless soft folder.  That
     broke the export of *every* soft folder, not just the empty ones.  The reason:
     -isExportableStark:withChange: (via -[Extore shouldExportStark:withChange:]) is
     invoked repeatedly *during* the merge, while -[Gulper gulpStartainer:info:error_p:]
     is still assembling the tree one relationship at a time —
       • from -[Ixporter objectWillChangeNote:] as each stark's index/parent/children
         is set (it is the gate for recording the change in the Chaker), and
       • from -[Ixporter mergeFromStartainer:toStartainer:info:error_p:].
     At those moments a soft folder transiently has zero children (its children have
     not been wired up yet), so the emptiness test fired for folders that were about
     to be filled, and their "add" was dropped from the Chaker.  The result (and the
     caches in -[Ixporter shouldExportStark:positiveCache:negativeCache:extore:]) made
     the premature verdict stick.

     -tweakExport is the correct hook.  It runs exactly once, as the ordered step
     "tweakExportForClient", *after* the merge is complete, when the transMoc tree is
     final and child counts are trustworthy, and *before* -checkAggregateExids and
     -writeAndDelete (so the empty folders never reach the "get exids" round-trip that
     times out).  It operates on the extore's throwaway in-memory transMoc, so pruning
     here affects only this client's write, not the shared document or other clients.
     (The Chaker's change observer is removed at the end of the merge, so these
     deletions are not recorded as changes to push.)  */
    @objc
    open override func tweakExport() {
        super.tweakExport()

        guard let moc = self.transMoc, let starker = self.starker() else {
            return
        }

        /* Prune bottom-up: removing an empty soft folder may leave its parent empty,
         so we repeat until a pass removes nothing.  -processPendingChanges propagates
         each deletion through the parent→child relationship so that the parent's
         -numberOfChildren is up to date on the next pass.  */
        var didRemoveAny = true
        while didRemoveAny {
            didRemoveAny = false
            for stark in starker.allStarks() {
                if stark.sharypeValue() == Sharype(SharypeSoftFolder) && stark.numberOfChildren() == 0 {
                    moc.delete(stark)
                    didRemoveAny = true
                }
            }
            if didRemoveAny {
                moc.processPendingChanges()
            }
        }
    }

    @objc
    class func allProfilesThisHomeSwiftly() -> Set<String> {
        let profileInfoCache = self.profileInfoCache()
        let displayProfileNames = profileInfoCache?.displayProfileNames
        let profileNames = displayProfileNames?.allKeys as! Array<String>
        return Set(profileNames)
    }
        
}
