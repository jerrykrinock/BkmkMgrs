import Foundation

extension BkmxDoc {
    
    enum StarkState {
        case ok
        case hopeless
        case badlyTagged
        case discontiguousChildren
        case noStarkId
        case duplicateExid
    }
    
    @objc
    func ensureIntegrityInBackground() {
        self.doInABackgroundContext({ starksIntegrityEnsureMoc, error in
            // Ssee NoteMergeCleanup regarding this…
            starksIntegrityEnsureMoc?.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump

            if let error = error {
                let errorOut = NSError.init(code: 485521,
                                            localizedDescription: "Could not get moc in \(#function)",
                                            underlyingError: error)
                self.logAsInformationalError(errorOut)
                return
            }
            
            if (starksIntegrityEnsureMoc == nil) {
                return
            }

            self.ensureDocumentIntegrity(starksIntegrityEnsureMoc: starksIntegrityEnsureMoc)
        })
    }
    
    func ensureDocumentIntegrity(starksIntegrityEnsureMoc: NSManagedObjectContext?) {
        
        /* Most errors are minor and just get logged.  Only if something really
         bad happens do we return NO and set error_p. */
        
        let normalLaunch = !SSYEventInfo.shiftKeyDown()
        
        // Note that if this is the first time we are opening this bkmxDoc
        // on this Mac account, a Macster instance has just been created.
        
        let starker = Starker.init(managedObjectContext: starksIntegrityEnsureMoc,
                                   entityName: constEntityNameStark)

        guard let starker = starker else {
            let errorOut = NSError.init(code: 485522,
                                        localizedDescription: "Could not get starker in \(#function)",
                                        underlyingError: error)
            self.logAsInformationalError(errorOut)
            return
        }
        
       /*
         Re-creating and re-gistering the file alias is not necessary if the
         file bookmark (file alias) is not stale.  However, the only way to find
         if a file bookmark is stale is by sending one of the NSURL methods that
         resolves the alias, namely
         +URLByResolvingBookmarkData:options:relativeToURL:bookmarkDataIsStale:error:
         or
         –initByResolvingBookmarkData:options:relativeToURL:bookmarkDataIsStale:error:
         I presume that would be more work than "just doing it", that is, that
         resolving a bookmark/alias is more work than re-creating one.  So,
         so that's what we just did.
         */
        
        // Remove any orphaned or untyped starks
        var orphans = Set<String>()
        var untypeds =  Set<String>()
        var badlyTagged = Set<String>()
        var hasDiscontiguousChildren = Set<String>()
        var noStarkid = Set<String>()
        
        enum StarkState: Int {
            case ok = 0
            case hopeless = 2
            case badlyTagged = 4
            case discontiguousChildren = 8
            case noStarkId = 16
        }
        
        /* The following section will fetch for duplicate exids in the same
         client.  I tested it and it appears to detect (but not yet delete –
         see the "todo".  But then I found that this is not really an issue
         for the use where I had originally seen such duplicates.  So I left
         it in only for DEBUG. */
#if DEBUG
        /* Swift Lesson:  Note that the #if DEBUG works as in C files
         only because in: Project Navigator > Targets > Bkmxwork >
         Build Settings > Swift Compiler > Custom Flags > Other Flags > Debug
         I added the entry "-D DEBUG".*/
        var exidDedupingError: Error? = nil
        do {
            let storeIdentifier = BkmxBasis.shared().exidsMocFilename(forIdentifier: self.uuid)
            let exidsCoordinator = try SSYMOCManager.persistentStoreCoordinatorType(NSSQLiteStoreType,
                                                                                    identifier: storeIdentifier,
                                                                                    momdName: constNameMomd,
                                                                                    recreateIfCorrupt: false)
            let exidsContext = NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType)
            exidsContext.persistentStoreCoordinator = exidsCoordinator

            if let clixidEntity = NSEntityDescription.entity(forEntityName: constEntityNameClixid, in: exidsContext) {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: constEntityNameClixid)
                let exidExpr = NSExpression(forKeyPath: constKeyExid)
                let countExpr = NSExpressionDescription()
                let countVariableExpr = NSExpression(forVariable: "count")
                let clidentifierProperty = clixidEntity.propertiesByName[constKeyClidentifier]!
                let exidProperty = clixidEntity.propertiesByName[constKeyExid]!
                countExpr.name = "count"
                countExpr.expression = NSExpression(forFunction: "count:", arguments: [ exidExpr ])
                countExpr.expressionResultType = .integer64AttributeType
                fetchRequest.resultType = .dictionaryResultType
                fetchRequest.sortDescriptors = [ NSSortDescriptor(key: constKeyExid, ascending: true) ]
                fetchRequest.propertiesToGroupBy = [clidentifierProperty, exidProperty]
                fetchRequest.propertiesToFetch = [clidentifierProperty, exidProperty, countExpr ]
                fetchRequest.havingPredicate = NSPredicate(format: "%@ > 1", countVariableExpr)
                var results: [Any] = [Any]()
                exidsContext.performAndWait {
                    do {
                        results = try exidsContext.fetch(fetchRequest)
                        if (results.count > 0) {
                            /* Todo: Delete the duplicate exids or something.
                             Will new ones be created during the next export? */
                        }
                    } catch {
                        exidDedupingError = NSError.init(code: 485537,
                                                         localizedDescription: "Could not fetch for dupe exids in \(#function)",
                                                         underlyingError: error)
                    }
                }
            }
        } catch {
            exidDedupingError = NSError.init(code: 485538,
                                             localizedDescription: "Could not create Exids stack in \(#function)",
                                             underlyingError: error)
        }
        if (exidDedupingError != nil) {
            BkmxBasis.shared().logError(exidDedupingError,
                                        markAsPresented: false)
        }
#endif

        if let allStarks = starker.allStarks() {
            var allStarksOk = true
            
            for stark in allStarks {
                // Collect Problem Data
                
                let sharype = stark.sharypeValue()
                var thisStarkState: Int = 0
                if (sharype != SharypeRoot) {
                    if (stark.parent == nil) {
                        thisStarkState = StarkState.hopeless.rawValue
                        orphans.insert(stark.shortDescription())
                        allStarksOk = false
                    }
                }
                if (thisStarkState != StarkState.hopeless.rawValue) {
                    if (sharype == SharypeUndefined) {
                        thisStarkState = StarkState.hopeless.rawValue
                        untypeds.insert(stark.shortDescription())
                        allStarksOk = false
                    }
                }
                if (thisStarkState != StarkState.hopeless.rawValue) {
                    if (!stark.canHaveTags() && (stark.tags.count > 0)) {
                        thisStarkState += StarkState.badlyTagged.rawValue
                        badlyTagged.insert(stark.shortcut)
                        allStarksOk = false
                    }
                }
                if (thisStarkState != StarkState.hopeless.rawValue) {
                    if (stark.canHaveChildren()) {
                        var index = 0
                        for child in stark.childrenOrdered() {
                            if (child.indexValue() != index) {
                                thisStarkState += StarkState.discontiguousChildren.rawValue
                                hasDiscontiguousChildren.insert(stark.shortDescription())
                                allStarksOk = false
                                break
                            }
                            index += 1
                        }
                    }
                }
                if (thisStarkState != StarkState.hopeless.rawValue) {
                    if (stark.starkid == nil) {
                        thisStarkState += StarkState.noStarkId.rawValue
                        noStarkid.insert(stark.shortDescription())
                        allStarksOk = false
                    }
                }
                
                // Repair any problems which can be fixed
                if (normalLaunch) {
                    if (thisStarkState & StarkState.hopeless.rawValue > 0) {
                        // This stark is not repairable
                        stark.remove()
                    } else {
                        // This stark can be repaired
                        
                        if ((thisStarkState & StarkState.badlyTagged.rawValue > 0)) {
                            stark.tags = nil
                        }
                        
                        if (thisStarkState & StarkState.discontiguousChildren.rawValue > 0) {
                            var index = 0
                            for child in stark.childrenOrdered() {
                                child.index = NSNumber(value: index)
                                index += 1
                            }
                        }
                        
                        if (thisStarkState & StarkState.noStarkId.rawValue > 0) {
                            stark.starkid = SSYUuid.compactUuid()
                        }
                    }
                }
                
            }

            if (!allStarksOk) {
                if let originalUrl = self.fileURL {
                    let fm = FileManager.default
                    
                    let corruptPath = URL(fileURLWithPath: originalUrl.path.hashifiedPath())
                    do {
                        try fm.copyItem(at: originalUrl,
                                        to: corruptPath)
                    } catch {
                        let errorOut = NSError.init(code: 485523,
                                                    localizedDescription: "Could not copy original file in \(#function)",
                                                    underlyingError: error)
                        self.logAsInformationalError(errorOut)
                        return
                    }
                    
                    /* Save our fixes, after setting up an observer to
                     merge and log the results*/
                    do {
                        NotificationCenter.default.addObserver(self,
                                                               selector: #selector(mergeAndLogIntegrityFixes(_:)),
                                                               name: NSNotification.Name.NSManagedObjectContextDidSave,
                                                               object: starksIntegrityEnsureMoc)
                        /* In the above, the `object` parameter specifies that we
                         only want notifications from this private starksContext
                         in which we made the changes. */
                        try starksIntegrityEnsureMoc?.save()
                    } catch {
                        let savingError = NSError.init(code: 485539,
                                                       localizedDescription: "Could not save fixed integrity in \(self.displayName() ?? self.fileURL?.path ?? "?!?")",
                                                       underlyingError: error)
                        BkmxBasis.shared().logError(savingError,
                                                    markAsPresented: false)
                    }
                }
            }
        }
    }
    
    @objc func mergeAndLogIntegrityFixes(_ notification: Notification) {
        self.managedObjectContext.perform {
            self.managedObjectContext.mergeChanges(fromContextDidSave: notification)
        }
//        let nDeleted = (notification.userInfo?[NSDeletedObjectsKey] as? Set<NSManagedObject>)?.count ?? 0
//        let nInserted = (notification.userInfo?[NSInsertedObjectsKey] as? Set<NSManagedObject>)?.count ?? 0
//        let nUpdated = (notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject>)?.count ?? 0
//        let nRefreshed = (notification.userInfo?[NSRefreshedObjectsKey] as? Set<NSManagedObject>)?.count ?? 0
//        let summary = "\(nDeleted) deleted, \(nInserted) inserted, \(nUpdated) updated, \(nRefreshed) refreshed"
        let summary = notification.changesSummary()

        let error = NSError(domain: NSError.myDomain(),
                            code: 405540,
                            userInfo: [NSLocalizedDescriptionKey:"Fixed Document Integrity",
                                       "Fix counts": summary])
        BkmxBasis.shared().logError(error, markAsPresented: false)

        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.NSManagedObjectContextDidSave,
                                                  object: notification.object)
    }
}
