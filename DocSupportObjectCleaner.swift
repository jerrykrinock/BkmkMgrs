import Foundation

@objc
class DocSupportObjectCleaner : NSObject {
    var bkmxDoc : BkmxDoc
    
    @objc
    init(bkmxDoc: BkmxDoc) {
        self.bkmxDoc = bkmxDoc
    }
    
    @objc
    func cleanOrphanedDocSupportObjects(info: Dictionary<String, Any>) {
        BkmxBasis.shared().logString("cleanOrphanedDSO is beginning")
        self.bkmxDoc.doInABackgroundContext({ peekAtStarksMoc, error in
            if (error != nil) {
                self.logError(
                    code: 784304,
                    desc: "\(#function) failed to get background context",
                    underlyingError: error)
            } else {
                guard let starksContext = peekAtStarksMoc else {
                    self.logError(
                        code: 784307,
                        desc: "\(#function) failed; no error but no context either (Weird!)",
                        underlyingError: error)
                    return
                }
                do {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
                    fetchRequest.entity = NSEntityDescription .ssy_entity(forName: constEntityNameStark,
                                                                          in: starksContext)
                    let allStarks = try starksContext.fetch(fetchRequest) as! [Stark]
                    /* The following statement will create a set of all current starkids by
                     extracting the starkid value of all starks, or "NO-STARKID" if the starkid
                     value is nil.  The presence of the "NO-STARKID" value in the answer is of
                     course useless except for troubleshooting and keeping the Swift compiler
                     happy. */
                    let starkidsOfCurrentStarks = Set(allStarks.map { $0.starkid ?? "NO-STARKID" })
                    
                    let uuid = info[constKeyDocUuid] as! String
                    let clidentifiers = Set(info[constKeyClidentifiers] as? Array<String> ?? [])

                    self.cleanSettingsStore(docUuid: uuid, starkids: starkidsOfCurrentStarks)
                    self.cleanExidsStore(docUuid: uuid, starkids: starkidsOfCurrentStarks, clidentifiers: clidentifiers)
                } catch {
                    self.logError(
                        code: 784302,
                        desc: "\(#function) failed",
                        underlyingError: error)
                }
            }
        })
    }
    
    private func cleanSettingsStore (docUuid: String, starkids: Set<String>) -> Void {
        var nRemovedStarlobutes = 0
        let settingsStoreFilename = BkmxBasis.shared().settingsMocFilename(forIdentifier: docUuid)
        if let settingsStoreUrl = SSYMOCManager.sqliteStoreURL(withIdentifier: settingsStoreFilename) {
            let settingsPersistentContainer = NSPersistentContainer(name: "cleanOrphaned-Settings",
                                                                    managedObjectModel: self.bkmxDoc.managedObjectModel)
            let settingsPersistentStoreDescription = NSPersistentStoreDescription(url: settingsStoreUrl)
            settingsPersistentStoreDescription.type = NSSQLiteStoreType
            settingsPersistentContainer.persistentStoreDescriptions = [settingsPersistentStoreDescription]
            settingsPersistentContainer.loadPersistentStores { persistentStoreDescription, error in
                if (error != nil) {
                    self.logError(
                        code: 784305,
                        desc: "Failed loading Settings store",
                        underlyingError: error)
                } else {
                    let settingsMoc = settingsPersistentContainer.newBackgroundContext()
                    // Ssee NoteMergeCleanup regarding this…
                    settingsMoc.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump

                    settingsMoc.perform {
                        do {
                            let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
                            fetchRequest.entity = NSEntityDescription .ssy_entity(forName: constEntityNameStarlobute,
                                                                                  in: settingsMoc)
                            /* The following commented-out alternative to the next
                             line does not work due to a type mismatch.
                             let allStarlobutes = try managedObjectContext.execute(fetchRequest) as! [Starlobute] */
                            let allStarlobutes = try settingsMoc.fetch(fetchRequest) as! [Starlobute]
                            // Delete any orphaned starlobutes
                            for starlobute in allStarlobutes {
                                let starkid = starlobute.starkid
                                if let starkid = starkid {
                                    if !starkids.contains(starkid) {
                                        settingsMoc.delete(starlobute)
                                        nRemovedStarlobutes += 1
                                    }
                                }
                            }
                            
                            if (settingsMoc.hasChanges) {
                                /* Save our fixes, after setting up an observer to
                                 merge and log the results*/
                                do {
                                    NotificationCenter.default.addObserver(self,
                                                                           selector: #selector(self.mergeAndLogSettingsCleaning(_:)),
                                                                           name: NSNotification.Name.NSManagedObjectContextDidSave,
                                                                           object: settingsMoc)
                                    /* In the above, the `object` parameter specifies that we
                                     only want notifications from this private settingsMoc
                                     in which we made the changes. */
                                    try settingsMoc.save()
                                } catch {
                                    let savingError = NSError.init(code: 485639,
                                                                   localizedDescription: "Could not save settings cleaning for \(docUuid)",
                                                                   underlyingError: error)
                                    BkmxBasis.shared().logError(savingError,
                                                                markAsPresented: false)
                                }
                            }
                        } catch {
                            self.logError(
                                code: 784301,
                                desc: "Failed with Settings moc",
                                underlyingError: error)
                        }
                    }
                }
            }
        }
    }
    
    private func cleanExidsStore(docUuid: String, starkids: Set<String>, clidentifiers: Set<String>) -> Void {
        let exidsStoreFilename = BkmxBasis.shared().exidsMocFilename(forIdentifier: docUuid)
        if let exidsStoreUrl = SSYMOCManager.sqliteStoreURL(withIdentifier: exidsStoreFilename) {
            let exidsPersistentContainer = NSPersistentContainer(name: "cleanOrphaned-Exids",
                                                                 managedObjectModel: self.bkmxDoc.managedObjectModel)
            let exidsPersistentStoreDescription = NSPersistentStoreDescription(url: exidsStoreUrl)
            exidsPersistentStoreDescription.type = NSSQLiteStoreType
            exidsPersistentContainer.persistentStoreDescriptions = [exidsPersistentStoreDescription]
            exidsPersistentContainer.loadPersistentStores { persistentStoreDescription, error in
                if (error != nil) {
                    self.logError(
                        code: 784306,
                        desc: "Failed loading Exids store",
                        underlyingError: error)
                } else {
                    let exidsMoc = exidsPersistentContainer.newBackgroundContext()
                    // Ssee NoteMergeCleanup regarding this…
                    exidsMoc.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump

                    exidsMoc.performAndWait {
                        do {
                            let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>()
                            fetchRequest1.entity = NSEntityDescription .ssy_entity(forName: constEntityNameStarxid,
                                                                                   in: exidsMoc)
                            let allStarxidsArray = try exidsMoc.fetch(fetchRequest1) as! [Starxid]
                            
                            let allStarxids = Set(allStarxidsArray)
                            var starxidsToKeep = Set<Starxid>()
                            
                            /* Cleanup 1.  Keep only starxids which (a) have a starkid (b) which
                             is of a a currently existing stark, or (c) has at least one
                             clixid identifying a currently-available client.  */
                            for starxid in allStarxids {
                                if let starkid = starxid.starkid {
                                    if (starkids.contains(starkid)) {
                                        /* Passed test (a).  Now test (b) before
                                         adding it to starxidsToKeep. */
                                        let clixids = starxid.clixids as? Set<Clixid> ?? []
                                        for clixid in clixids {
                                            if let clidentifier = clixid.clidentifier {
                                                if (clidentifiers.contains(clidentifier)) {
                                                    starxidsToKeep.insert(starxid)
                                                    break
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            let starxidsToRemove = allStarxids.subtracting(starxidsToKeep)
                            for starxid in starxidsToRemove {
                                exidsMoc.delete(starxid)
                            }

                            /* Cleanup 2.  Remove any clixids whose
                             (a) starxid is nil
                             (b) starxid is not that of a currently existing stark's starkid
                             (c) clidentifier is nil
                             (d) clidentifier is not that a currently existing stark's clidentifier
                             starxid or (b) not related to a currently-available Client.
                             This should not be necessary because of Cascade Delete,
                             deleting a starxid should delete all of its clixids.  However,
                             in developing BkmkMgrs 1.15, I discovered that, as I have seen
                             before in other places, the Cascade Delete Rule did not work as
                             expected.  That is, when a Starxid is deleted, its related Clixid
                             are not deleted, even after -processPendingChanges.  So I added
                             the following section.  In BkmkMgrs 1.22.20, I found the opposite,
                             that the Cascade Delete Rule is working properly and that
                             nRemovedClixids is always 0.  But since this is a clean-up method
                             running on a secondary thread, I just leave it in.  Maybe there
                             was a bug in earlier macOS versions (I'm on 10.10 DP8 now.) */
                            let fetchRequest2 = NSFetchRequest<NSFetchRequestResult>()
                            fetchRequest2.entity = NSEntityDescription .ssy_entity(forName: constEntityNameClixid,
                                                                                   in: exidsMoc)
                            let clixids = try exidsMoc.fetch(fetchRequest2) as! [Clixid]
                            for clixid in clixids {
                                var ok = false
                                if let starkid = clixid.starxid?.starkid {
                                    if (starkids.contains(starkid)) {
                                        if let clidentifier = clixid.clidentifier {
                                            if (clidentifiers.contains(clidentifier)) {
                                                ok = true
                                            }
                                        }
                                    }
                                }
                                if (!ok) {
                                    exidsMoc.delete(clixid)
                                }
                            
                                /* C-way of doing the above, which does not work: */
                //                if (
                //                    (clixid.starxid == nil)
                //                    ||
                //                    (!starkids.contains(clixid.starxid.starkid)) // crash if clixid.starxid.starkid = nil
                //                    ||
                //                    (clixid.clidentifier == nil)
                //                    ||
                //                    (!clidentifiers.contains(clixid.clidentifier))
                //                ) {
                //                    managedObjectContext.delete(clixid)
                //                    nRemovedClixids += 1
                //                }
                            }
                            
                            /* Note that it is not necessary to remove exids in starks, that is,
                             stark.exid, because the attribute Stark.exid, although it is
                             still in the data model as of Bkmx018.xcdatamodel, is no longer
                             used.  */
                            
                            if (exidsMoc.hasChanges) {
                                /* Save our fixes, after setting up an observer to
                                 merge and log the results*/
                                do {
                                    NotificationCenter.default.addObserver(self,
                                                                           selector: #selector(self.mergeAndLogExidCleanings(_:)),
                                                                           name: NSNotification.Name.NSManagedObjectContextDidSave,
                                                                           object: exidsMoc)
                                    /* In the above, the `object` parameter specifies that we
                                     only want notifications from this private exidsMoc
                                     in which we made the changes. */
                                    try exidsMoc.save()
                                } catch {
                                    let savingError = NSError.init(code: 485650,
                                                                   localizedDescription: "Could not save External ID cleaning for \(docUuid)",
                                                                   underlyingError: error)
                                    BkmxBasis.shared().logError(savingError,
                                                                markAsPresented: false)
                                }
                            }
                        } catch {
                            self.logError(
                                code: 784303,
                                desc: "Failed cleaning Exids store",
                                underlyingError: error)
                        }
                    }
                }
            }
        }
    }
    
    @objc func mergeAndLogSettingsCleaning(_ notification: Notification) {
        if let mainMoc = self.bkmxDoc.settingsMoc {
            mainMoc.perform {
                mainMoc.mergeChanges(fromContextDidSave: notification)
            }
        }
        let summary = notification.changesSummary()

        let error = NSError(domain: NSError.myDomain(),
                            code: 405541,
                            userInfo: [NSLocalizedDescriptionKey:"Cleaned Settings",
                                       "Fix counts": summary])
        BkmxBasis.shared().logError(error, markAsPresented: false)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.NSManagedObjectContextDidSave,
                                                  object: notification.object)
    }


    
    @objc func mergeAndLogExidCleanings(_ notification: Notification) {
        if let mainMoc = self.bkmxDoc.exidsMoc {
            mainMoc.perform {
                mainMoc.mergeChanges(fromContextDidSave: notification)
            }
        }
        let summary = notification.changesSummary()

        let error = NSError(domain: NSError.myDomain(),
                            code: 405542,
                            userInfo: [NSLocalizedDescriptionKey:"Cleaned Exids",
                                       "Fix counts": summary])
        BkmxBasis.shared().logError(error, markAsPresented: false)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.NSManagedObjectContextDidSave,
                                                  object: notification.object)
    }

    private func logError(code: Int, desc: String, underlyingError: Error?) {
        BkmxBasis.shared().logErrorInformational(domain:"DocSupportObjectCleaner",
                                                 code: code,
                                                 desc: desc,
                                                 underlyingError: underlyingError);
    }
    
}

/*
 NoteMergeCleanup
 
 Since we are only doing cleanup, we allow changes in the store apparently
 done by others to trump our changes. There should rarely be any, unless the
 user starts editing quickly after document opening??  Whatever, it those
 changes are more important than our cleanup.  Whatever changes we don't save,
 if still issues, shall be re-detected, re-fixed and save the next time we run,
 the next day or whatever.
 
 The constant name `mergeByPropertyStoreTrump` apparently means: Merge each
 object's property independently, and resolve conflicts by allowing the value
 in the store to trump the value which we are pushing.
 */

