import Foundation


protocol WebBookmarkSwift {
    
}

extension SheepSafariHelper {
    func bookmarksFileUrl() -> URL {
        return BookmarksController.defaultBookmarksFileURL() as! URL
    }
    
    @objc
    func plistOnDisk() -> Dictionary<String, Any>? {
        var tree : Dictionary<String, Any>? = nil
        do {
            
            let data = try Data.init(contentsOf: self.bookmarksFileUrl())
            tree = try PropertyListSerialization.propertyList(from: data, format: nil) as? Dictionary<String, Any> ?? Dictionary()
        } catch {
            self.reportIssue("Could not get Bookmarks plist cuz " + (error as NSError).description)
            /* It would be nice to use .descriptionForDialog or .longDescription
             instead of .description but then I would need to include
             a bunch more source files in SheepSafariHelper. */
        }

        return tree
    }
        
    /* In testing with macOS 13 / Safari 16, it seemed that it would take
     longer for Safari exports from our apps than changes made in Safari to
     show up in Safari on other devices.  Sometimes up to 4 hours.  Upon
     investigation, I discovered that, after an export from our apps, there
     would be an extra, bogus change item written to
     Bookmarks.plist > Sync > Changes.  Here is an example
         BookmarkType    String    Folder
         BookmarkUUID    String    AB6A35FC-49C2-4916-A5E1-7F318C226CF0
         Token           String    7AE65D74-3076-4D1C-991D-DED65C70630B
         Type            String    Add
     From past experience, I know that this is telling iCloud that a new
     folder was added, and that to find the details iCloud should search the
     tree in Bookmarks.plist for the item whose WebBookmarkUUID is the same
     as the given BookmarkUUID.  For such a "bogus" change, there is no such
     item in the tree.
     
     From commenting out code, I determined that this bogus item appeared
     even if the only significant calls I made to the SafariPrivateFramework
     were 'load` followed by 'save`.
     
     My hypothesis is that when iCloud (probably SafariBookmarksSyncAgent)
     encounters one of these orphan, bogus changes, it aborts the push
     and tries again later, or maybe there is some mechanism which comes in
     every 4 hours or so (from what I've seen) and does a more aggressive
     push, ignoring the bogus items.
     
     The following function, now called after every export, therefore does
     this work, editing the Bookmarks.plist file directly and removing any
     orphan Changes items.  I think it should work because this method is
     run before the file lock is removed, and SafariBookmarksSyncAgent will
     respect our file lock.
     
     There is another probably beneficial side effect of using this method.
     See Note 20171031BMN.
     */
    @objc
    func postFixBookmarksFile() {
        if let plistOnDisk = self.plistOnDisk() {
            let exids = NSMutableSet()
            self.recursivelyGetExids(exids,
                                     nodeDic: plistOnDisk,
                                     depth: 0)
            let syncDicKey = "Sync"
            let changesDicKey = "Changes"
            let childrenDicKey = "Children"

            let syncDic = plistOnDisk[syncDicKey] as? Dictionary<String, Any>
            var fixedSyncDic: Dictionary<String, Any>? = nil
            if let syncDic = syncDic {
                if var changesArray = syncDic[changesDicKey] as? Array<Dictionary<String, Any>> {
                    let originalCount = changesArray.count
                    var changeIndex = 0;
                    for change in changesArray {
                        var didRemove = false
                        self.logIfLevel(4, string: "postFix before cnt=\(changesArray.count) idx=\(changeIndex)\nconsidering \(String.init(describing: change))")
                        if let uuid = change["BookmarkUUID"] as? String, let type = change["Type"] as? String {
                            if ((!exids.contains(uuid)) && (type != "Delete")) {
                                changesArray.remove(at: changeIndex)
                                self.logIfLevel(2, string: "   postFix removed ORPHAN change")
                                didRemove = true
                            }
                        }
                        if (!didRemove) {
                            if let bookmarkServerID = change["BookmarkServerID"] as? String {
                                if bookmarkServerID == "Favorites Bar" {
                                    changesArray.remove(at: changeIndex)
                                    self.logIfLevel(2, string: "   postFix removed BAR change")
                                    didRemove = true
                                }
                                else if bookmarkServerID == "Bookmarks Menu" {
                                    changesArray.remove(at: changeIndex)
                                    self.logIfLevel(2, string: "   postFix removed MENU change")
                                    didRemove = true
                                }
                            }
                        }

                        if (!didRemove){
                            changeIndex += 1
                            self.logIfLevel(4, string: "   postFix DID NOT REMOVE")
                        }
                        self.logIfLevel(4, string: "   postFix after cnt=\(changesArray.count) idx=\(changeIndex)")
                    }
                    
                    let bogusChangesCount = originalCount - changesArray.count
                    if (bogusChangesCount > 0) {
                        fixedSyncDic = syncDic
                        fixedSyncDic?[changesDicKey] = changesArray
                    }
                    self.logIfLevel(1, string: "postfix deleted \(bogusChangesCount) bogus changes")
                }
            }
            
            var fixedChildrenArray: Array<Dictionary<String, Any>>? = nil
            if let childrenArray = plistOnDisk[childrenDicKey] as? Array<Dictionary<String, Any>> {
                let fixedBar = self.fixHartainer(original: childrenArray[1],
                                                 expectedSyncServerId: "Favorites Bar",
                                                 expectedTitle: "BookmarksBar")
                let fixedMenu = self.fixHartainer(original: childrenArray[2],
                                                  expectedSyncServerId: "Bookmarks Menu",
                                                  expectedTitle: "BookmarksMenu")
                if (fixedBar != nil) || (fixedMenu != nil) {
                    fixedChildrenArray = childrenArray
                    if let fixedBar = fixedBar {
                        fixedChildrenArray?[1] = fixedBar
                    }
                    if let fixedMenu = fixedMenu {
                        fixedChildrenArray?[2] = fixedMenu
                    }
                }
            }

            if (fixedSyncDic != nil) || (fixedChildrenArray != nil) {
                var fixedPlist = plistOnDisk
                if let fixedSyncDic = fixedSyncDic {
                    fixedPlist[syncDicKey] = fixedSyncDic
                }
                if let fixedChildrenArray = fixedChildrenArray {
                    fixedPlist[childrenDicKey] = fixedChildrenArray
                }
                do {
                    let newPlistData = try PropertyListSerialization.data(fromPropertyList: fixedPlist,
                                                                          format:.binary,
                                                                          options: 0)
                    try newPlistData.write(to: self.bookmarksFileUrl())
                } catch {
                    self.reportIssue("Could not rewrite bogusless Bookmarks.plist cuz " + (error as NSError).description)
                    /* It would be nice to use .descriptionForDialog or .longDescription
                     instead of .description but then I would need to include
                     a bunch more source files in SheepSafariHelper. */
                }
            }
        }
    }
    
    func fixHartainer(original: Dictionary<String, Any>?, expectedSyncServerId: String, expectedTitle: String) -> Dictionary<String, Any>? {
        let dicTitleKey = "Title"
        let dicSyncKey = "Sync"
        let dicServerIdKey = "ServerID"
        var fixed: Dictionary<String, Any>? = nil
        
        var fixedTitle: String? = nil
        if let syncServerId = (original?[dicSyncKey] as? Dictionary<String, Any>)?[dicServerIdKey] as? String {
            if (syncServerId == expectedSyncServerId) {
                if let originalTitle = original?[dicTitleKey] as? String {
                    if (originalTitle != expectedTitle) {
                        fixedTitle = expectedTitle
                    }
                }
            }
        }
        
        if (fixedTitle != nil) {
            fixed = original
            fixed?[dicTitleKey] = expectedTitle
        }

        return fixed
    }
    
    @objc
    /// Thanks to https://gist.github.com/satoshimuraki/f811cfe509f9cdd75085
    /// - Returns: The Machine Hardware ID of the Mac
    func machineHardwareUUID() -> String? {
        let platformExpert: io_service_t = IOServiceGetMatchingService(
            kIOMasterPortDefault,
            IOServiceMatching(
                "IOPlatformExpertDevice"
            )
        );
        
        guard let uuidAsCFString = IORegistryEntryCreateCFProperty(
            platformExpert,
            kIOPlatformUUIDKey as CFString,  /* To get serial number instead of hardware UUID, use kIOPlatformSerialNumberKey instead. */
            kCFAllocatorDefault,
            0
        ) else {
            return  nil
        }
        
        IOObjectRelease(
            platformExpert
        );
        
        return (
            uuidAsCFString.takeUnretainedValue() as? String
        ) ?? nil
    }    
}

 
    /* The following commented out code is some very nice Swift implementations
     of 6 funcs, which I wanted to be this Swift extension so I could write
     a unit test.  But I could not get it to wkr so these functions are now
     implemented in Objective-C in SheepSafariHelper.m, which.
     
     The problem was this linking error:
     
     Undefined symbols for architecture arm64:
       "_OBJC_CLASS_$_WebBookmark", referenced from:
           _OBJC_CLASS_$_WebBookmarkForSwift in SheepSafariHelper.o
           objc-class-ref in SheepSafariHelper+Swift.o
          (maybe you meant: _OBJC_CLASS_$_WebBookmarkForSwift)
       "_OBJC_METACLASS_$_WebBookmark", referenced from:
           _OBJC_METACLASS_$_WebBookmarkForSwift in SheepSafariHelper.o
          (maybe you meant: _OBJC_METACLASS_$_WebBookmarkForSwift)
     ld: symbol(s) not found for architecture arm64
     
     The error occurs because the last func
     recursivelyGetExids(_ exids:nodeWB:depth:) takes a WebBookmark as a
     parameter.  Apparently, for some reason, although SheepSafariHelper.m,
     the Apple-private Safari.framework and this file are all linked by the
     linker, even though references to WebBookmark in the Objective-C file
     SheepSafariHelper.m are successfully linked, references to WebBookmark
     in this Swift file are not.  Attempting to fix the issue, in the
     Objective-C file, I defined a new class WebBookmarkForSwift to be a
     subclass of WebBookkmark, and with some additional kludges, declaring
     variables which were actually WebBookmark as SafariWebBookmarkList and
     using carefully and conditionally, After a couple hours, I was able to
     get it to compile and link with no warnings.  But then I got a runtime
     error in that func: Could not cast value of type 'SafariWebBookmarkList'
     to 'WebBookmarkForSwift'.
     
     So I gave up on it.  Although only one func had the problem, for code
     organization, since all six funcs are related, I commented out all 6
     implementations and restored their Objective-C implementations.
     
     Another day in the life of Swift/Objective-C interoperabiity :(
     */
    //    func isBarDic(_ dic: Dictionary<String, Any>) -> Bool {
    //        if let name = dic["Title"] as? String {
    //            if (name == "BookmarksBar") {
    //                return true
    //            }
    //        }
    //
    //        /* If dic is indeed the bar, we may miss the above early return if
    //         SafariPrivateFramework has inadvertently re-titled the bar from
    //         BookmarksBar to the localized name seen for the bar in the user
    //         interface, as we have seen happen.  Therefore, we now use
    //         an alternate method we have found to identify the bar, which will
    //         only work if the "Sync" subdic is present, which I think is true
    //         if iCloud syncing has *ever* been enabled on this Bookmarks.plist */
    //        if let syncDic = dic["Sync"] as? Dictionary<String, Any> {
    //            if let serverID = syncDic["ServerID"] as? String {
    //                if serverID == "Favorites Bar" {
    //                    return true
    //                }
    //            }
    //        }
    //
    //        return false
    //    }
    //
    //    func isMenuDic(_ dic: Dictionary<String, Any>) -> Bool {
    //        if let name = dic["Title"] as? String {
    //            if (name == "BookmarksMenu") {
    //                return true
    //            }
    //        }
    //
    //        /* If dic is indeed the menu, we may miss the above early return if
    //         SafariPrivateFramework has inadvertently re-titled the menu from
    //         BookmarksMenu to the localized name seen for the bar in the user
    //         interface, as we have seen happen.  Therefore, we now use
    //         an alternate method we have found to identify the menu, which will
    //         only work if the "Sync" subdic is present, which I think is true
    //         if iCloud syncing has *ever* been enabled on this Bookmarks.plist */
    //        if let syncDic = dic["Sync"] as? Dictionary<String, Any> {
    //            if let serverID = syncDic["ServerID"] as? String {
    //                if serverID == "Bookmarks Menu" {
    //                    return true
    //                }
    //            }
    //        }
    //
    //        return false
    //    }
    //
    //    @objc
    //    func exidsOnDisk() -> NSMutableSet {
    //        var exids: NSMutableSet? = nil
    //        if let tree = self.plistOnDisk() {
    //            let exidsNonoptional = NSMutableSet()
    //            self.recursivelyGetExids(exidsNonoptional,
    //                                     nodeDic: tree,
    //                                     depth: 0)
    //            exids = exidsNonoptional
    //        }
     //
    //        return exids ?? NSMutableSet()
    //    }
    //
    //    func recursivelyGetExids(
    //        _ exids: NSMutableSet,
    //        nodeDic node: Dictionary<String, Any>,
    //        depth: Int
    //    ) {
    //        var exid: String? = nil
    //        if depth > 1 {
    //            exid = node["WebBookmarkUUID"] as? String
    //        } else if depth == 1 {
    //            // This is a child of root.  Do not count hartainers or proxies
    //            let name = node["Title"] as? String
    //            let type = node["WebBookmarkType"] as? String
    //            if !isBarDic(node)
    //                && !isMenuDic(node)
    //                && (name != "com.apple.ReadingList")
    //                && (type != "WebBookmarkTypeProxy"
    //                ) {
    //                exid = node["WebBookmarkUUID"] as? String
    //            }
    //        } else {
    //        }
    //
    //        if let exidNonOptional = exid {
    //            exids.add(exidNonOptional)
    //        }
    //
    //        if let children = node["Children"] as? Array<Dictionary<String, Any>> {
    //            for child in children {
    //                recursivelyGetExids(exids,
    //                                    nodeDic:child,
    //                                    depth:depth+1)
    //            }
    //        }
    //    }
    //
    //    @objc
    //    func exidsInMemory() -> NSMutableSet {
    //        var exids: NSMutableSet? = nil
    //        if let root = self.root() {
    //            let exidsNonoptional = NSMutableSet()
    //            self.recursivelyGetExids(exidsNonoptional,
    //                                     nodeWB: root,
    //                                     depth: 0)
    //            exids = exidsNonoptional
    //        }
    //        return exids ?? NSMutableSet()
    //    }
    //
    //
    //    func recursivelyGetExids(
    //        _ exids: NSMutableSet,
    //        nodeWB: WebBookmark,
    //        depth: Int
    //    ) {
    //        var exid: String? = nil
    //        if (depth > 1) {
    //            exid = nodeWB.uuid
    //        } else if (depth == 1) {
    //            // This is a child of root.  Do not count hartainers or proxies
    //            if (
    //                (nodeWB != self.bar())
    //                && (nodeWB.title == "Tab Group Favorites")
    //                && (nodeWB != self.menu())
    //                && (nodeWB != self.readingList())
    //            ) {
    //                if let exidNonOptional = nodeWB.uuid {
    //                    exid = exidNonOptional
    //                }
    //            }
    //        } else {
    //            /* depth == 0.  This is root.  Ignore because SafariPrivateFramework
    //             always conjures up and assigns to it a new UUID on every load. */
    //        }
    //
    //        if let exidNonOptional = exid {
    //            exids.add(exidNonOptional)
    //        }
    //
    //        if let nodeFolder = nodeWB as? SafariWebBookmarkList {
    //            /* `child` is a folder, may have its own children */
    //            let numberOfChildren = nodeFolder.numberOfChildren
    //            if (numberOfChildren > 0) {
    //                for child in nodeFolder.folderAndLeafChildren {
    //                    if let childWB = child as? WebBookmark {
    //                        self.recursivelyGetExids(exids,
    //                                                 nodeWB: childWB,
    //                                                 depth: depth+1)
    //                    }
    //                }
    //            }
    //        }
    //    }
    //

