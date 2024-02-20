import Foundation

class SafariWiper {
    let errorDomain = "SafariCleanerErrorDomain"
    
    func wipe () -> String {
        var result: String?
        var errorOut: NSError? = nil
        do {
            var tree = try self.plistOnDisk()
            
            var children: Array<Dictionary<String, Any>>? = nil
            /* Delete any Children except the first four (History, Bar, Menu, Reading List. */
            if let childrenIn = tree?["Children"] as? Array<Dictionary<String, Any>> {
                children = Array(childrenIn.prefix(4))
            }
            /* Delete any Children of Children index 0-3 */
            if let children2 = children {
                var newChildren = Array<Dictionary<String, Any>>()
                for child in children2 {
                    var newChild = child
                    newChild["Children"] = nil
                    newChildren.append(newChild)
                }
                tree?["Children"] = newChildren
            }

            /* Delete Changes of Sync */
            if let syncIn = tree?["Sync"] as? Dictionary<String, Any> {
                var sync = syncIn
                sync["Changes"] = nil
                tree?["Sync"] = sync
            }
            
            /* Write modified tree to disk */
            do {
                let data = try PropertyListSerialization.data(fromPropertyList: tree as Any,
                                                              format: .binary,
                                                              options: 0)
                try data.write(to: self.fileUrl())
                result = "Successfully cleaned all items and all changes from Safari"
            } catch {
                errorOut = error as NSError
            }
            
        } catch {
            errorOut = error as NSError
        }
        
        if let errorOut = errorOut {
            result = "Error \(errorOut.code): \(errorOut.longDescription() ?? "No description")"
        }
        return result ?? "Unknown result from SafariCleaner.clean"
        
    }
    
    func currentChangeCount () throws -> Int {
        var changesCount : Int = 0
        do {
            let tree = try self.plistOnDisk()

            if let sync = tree?["Sync"] as? Dictionary<String, Any> {
                if let changes = sync["Changes"] as? Dictionary<String, Any> {
                    changesCount = changes.count
                }
            }
        } catch {
            throw error
        }
            
        return changesCount
    }
    
    func fileUrl() -> URL {
        return URL.init(fileURLWithPath: NSHomeDirectory())
            .appendingPathComponent("Library")
            .appendingPathComponent("Safari")
            .appendingPathComponent("Bookmarks.plist")
    }
    
    func plistOnDisk() throws -> Dictionary<String, Any>? {
        var tree : Dictionary<String, Any>? = nil
        do {
            let data = try Data.init(contentsOf: self.fileUrl())
            tree = try PropertyListSerialization.propertyList(from: data, format: nil) as? Dictionary<String, Any> ?? Dictionary()
        } catch {
            throw NSError.init(
                domain: self.errorDomain,
                code: 283755,
                localizedDescription: "Could not get Bookmarks plist cuz " + (error as NSError).description)
        }

        return tree
    }

}
