import Foundation

extension URL {
    func catPath(_ end: URL) -> URL{
        let comps = end.pathComponents
        var cat = self
        for comp in comps {
            cat.appendPathComponent(comp)
        }
        
        return cat
    }
}

extension BkmxDocumentController {
    func allStoresMigratedForDocumentUuid(_ docUuid: String) -> Bool {
        do {
            var hacker = CoreDataVersionHacker()
            let allVersionNames = try hacker.availableVersionNames(momdName: constNameMomd)
            guard let currentVersion = allVersionNames.last else {
                /* This error means that the app was not built properly.  Do
                 not bother reporting it, because it will have
                 already ooccured and been dealt with during the actual
                 migration.  Just keep the comiler happy. */
                return false
            }
            let bundle = Bundle.mainAppBundle()
            let currentModel = try NSManagedObjectModel.loadFrom(bundle: bundle,
                                                                 momdName: constNameMomd,
                                                                 versionName: currentVersion)
            var metadata: [String: Any]
            
            /* Check the 3 ancillary storese.  For efficiency, check the one
             which will be migrated last first, etc. */
            
           if (self.checkMigration(basename: constBaseNameExids,
                                    uuid: docUuid,
                                    currentModel: currentModel) == false) {
                return false
            }
            if (self.checkMigration(basename: constBaseNameSettings,
                                    uuid: docUuid,
                                    currentModel: currentModel) == false) {
                return false
            }
            if (self.checkMigration(basename: constBaseNameDiaries,
                                    uuid: docUuid,
                                    currentModel: currentModel) == false) {
                return false
            }

            /* Check the .bmco document package */
            
            
            let docPath = try self.pathOfDocument(withUuid: docUuid,
                                                  appName: nil,
                                                  timeout: 10,
                                                  trials: 3,
                                                  delay: 1)
            guard let storePath = BSManagedDocument.storePath(forDocumentPath: docPath) else {
                /* Again, if this happens, we have been or will be in trouble elsewhere. */
                return false
            }
            metadata = try NSPersistentStoreCoordinator.metadataForPersistentStore(ofType: NSSQLiteStoreType,
                                                                                   at: URL(fileURLWithPath: storePath),
                                                                                   options: nil)
            if (!currentModel.isConfiguration(withName: nil,
                                              compatibleWithStoreMetadata: metadata)) {
                return false;
            }
        } catch {
        BkmxBasis.shared().logError(error,
                                    markAsPresented: false)
        }
        
        /* We have checked all stores and not yet returned false.  Therefore,
         all stores associated with this document must be done migrating. */
        return true
    }

    func checkMigration(basename: String, uuid: String, currentModel: NSManagedObjectModel) -> Bool {
        let appSupportUrl = URL(fileURLWithPath: Bundle.mainAppBundle().applicationSupportPathForMotherApp())

        guard let basenameAndUuid = BkmxBasis.shared()?.filename(forMocName:basename,
                                                                 identifier:uuid) else {
            /* Again, if this happens, we have been or will be in trouble elsewhere. */
            return false
        }

        /* I tried to do this concatenation with URL methods, in particular
         .appendingPathComponent, but it gave me to slashes between
         the appSupportUrl and the basenameAndUuid.  I understand strings!! */
        let storeUrl = URL(fileURLWithPath: appSupportUrl.path + "/" + basenameAndUuid + "." + SSYManagedObjectContextPathExtensionForSqliteStores)
        do {
            let metadata = try NSPersistentStoreCoordinator.metadataForPersistentStore(ofType: NSSQLiteStoreType,
                                                                                       at: storeUrl,
                                                                                       options: nil)
            let result = currentModel.isConfiguration(withName: nil,
                                                      compatibleWithStoreMetadata: metadata)
            return result
        } catch {
            /* Since the class function
             NSPersistentStoreCoordinator.metadataForPersistentStore(ofType:at:options:)
             returns a non-optional dictionary, I presume that if a store does
             not exist at the given URL, it would throw an error, which would
             send us here.  There is no migration necessary on a nonexistent
             store, so we …*/
            return true
        }
    }
}
