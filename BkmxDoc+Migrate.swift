import Foundation

@objc
extension BkmxDoc {
    @objc
    func migrateIfNeeded() throws {
        guard let storeUrl = BSManagedDocument.persistentStoreURL(forDocumentURL: self.fileURL) else {
            /* This will happen if when user clicks in the main menu:
             File > Duplicate.  Nothing to migrate, not an error. */
            return ;
        }
        let delegate = BkmxCoreDataMigrationDelegate()
        let manager = CoreDataProgressiveMigrator.init(storeUrl: storeUrl,
                                                       storeType: NSSQLiteStoreType,
                                                       momdName: constNameMomd,
                                                       delegate: delegate)
        do {
            let migratedVersions = try manager.migrateStoreIfNeeded()
            
            if (migratedVersions != nil) {
                /* A migration has occurred, meaning that this is the first time
                 running a new version of Bkmx which alters the data model.
                 The Settings MOC and Exids MOC will be created and therefore their
                 stores will be migrated soon, when we create a Macster for this
                 document.  But a Diaries MOC will not be created until a user
                 clicks the Reports tab, which most users never do.  So we could
                 have old Diaries stores on disk for many years!  To prevent that,
                 we now create a Diaries MOC, but only if one already exists on
                 disk because, for example, Markster users may not have one.
                 */
                let wholeIdentifier = BkmxBasis.shared().filename(forMocName: constBaseNameDiaries,
                                                                        identifier: self.uuid)
                if let diariesMocUrl = SSYMOCManager.sqliteStoreURL(withIdentifier: wholeIdentifier) {
                    if (FileManager.default.fileExists(atPath: diariesMocUrl.path)) {
                        _ = self.diariesMoc
                    }
                }
            }
            
            
        } catch {
            throw error
        }
    }
    
    class func uuidOfDocumentWithStoreUrl(_ url: URL) -> String? {
        let documentUrl = url.deletingLastPathComponent().deletingLastPathComponent()
        return Self.uuidOfDocumentWithUrl(documentUrl)
    }
    
    class func uuidOfDocSupportMoc(_ url: URL) -> String? {
        let filename = url.deletingPathExtension().lastPathComponent
        /* UUID have 32 hex characters and 4 hyphens */
        return String(filename.suffix(36))
    }
    
    @objc
    class func uuidOfDocumentWithUrl(_ url: URL) -> String? {
        do {
            guard let auxiliaryDataPath = BSManagedDocument.auxiliaryDataFilePath(forDocumentPath: url.path) else {
                throw NSError.init(domain: "BkmxDocErrorDomain",
                                   code: 335910,
                                   localizedDescription: "Could not get auxiliary data path")
            }
            
            let auxData = try Data.init(contentsOf: URL(fileURLWithPath: auxiliaryDataPath))
            let dic = try PropertyListSerialization.propertyList(from: auxData, format: nil) as? Dictionary<String, Any> ?? Dictionary()
            let uuid = dic[constKeyDocUuid] as? String ?? "No-UUID-Error-2"
            return uuid
        } catch {
            BkmxBasis.shared().logError(NSError.init(domain: "BkmxDocErrorDomain",
                                                     code: 335910,
                                                     localizedDescription: "Could not get auxiliary data path").addingUnderlyingError(error),
            markAsPresented: false)
        }
        
        return nil
    }
}
