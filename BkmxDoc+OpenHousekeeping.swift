import Foundation

extension BkmxDoc {
    
    @objc
    func scheduleOpenHousekeeping() {
        /* Timers must be set on the main thread. */
        DispatchQueue.main.async(execute: {
            var cleaningTimers = Set<Timer>()
            
            // Note that we could not do this earlier, because it
            // needs an operational macster, starker and starxider.
            // cleanDefunctLogEntries, first in 75 seconds…
            cleaningTimers.insert(Timer.scheduledTimer(withTimeInterval: 105.0,
                                                       repeats: false,
                                                       block: { timer in
                self.cleanDefuncTalderMapsInBackground()
            }))
            // then once a day…
            cleaningTimers.insert(Timer.scheduledTimer(withTimeInterval: Double(BkmxBasis.secondsPerDay()),
                                                       repeats: true,
                                                       block: { timer in
                self.cleanDefuncTalderMapsInBackground()
            }))
            
            // Note that we could not do this earlier, because it
            // needs an operational macster, starker and starxider.
            // cleanDefunctLogEntries, first in 95 seconds…
            cleaningTimers.insert(Timer.scheduledTimer(withTimeInterval: 115.0,
                                                       repeats: false,
                                                       block: { timer in
                self.cleanDefunctDiaryEntriesInBackground()
            }))
            // then once a day, 120 seconds later…
            cleaningTimers.insert(Timer.scheduledTimer(withTimeInterval: Double(BkmxBasis.secondsPerDay()) + 120.0,
                                                       repeats: false,
                                                       block: { timer in
                self.cleanDefunctDiaryEntriesInBackground()
            }))
            
            self.cleaningTimers = cleaningTimers
        })
                                   
        // Do these immediately
        self.noteRecentDisplayName()
        self.removeAnyGhostSyncers()
        self.registerAliasForUuidInUserDefaults()
        
        let backgroundQueue = DispatchQueue.global()
        let deadline = DispatchTime.now() + .seconds(1)
        backgroundQueue.asyncAfter(deadline: deadline,
                                   qos: .background) {
            self.settingsPrivateContext()?.perform {
                self.checkForBadClientsAnMaybeCleanOrphanedDocSupportObjects()
            }
        }
    }
    
    func cleanDefuncTalderMapsInBackground() {
        DispatchQueue.global().async(execute: {
            let starksContext = NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType)
            starksContext.persistentStoreCoordinator = self.managedObjectContext.persistentStoreCoordinator
            
            let starker = Starker.init(managedObjectContext: starksContext,
                                       entityName: constEntityNameStark)

            guard let starker = starker else {
                let errorOut = NSError.init(code: 485732,
                                            localizedDescription: "Could not get starker in \(#function)",
                                            underlyingError: nil)
                self.logAsInformationalError(errorOut)
                return
            }
            
            guard let settingsContext = self.settingsPrivateContext() else {
                return
            }
            
            let talderMapper = TalderMapper.init(managedObjectContext: settingsContext)
 
            guard let talderMapper = talderMapper else {
                let errorOut = NSError.init(code: 485735,
                                            localizedDescription: "Could not get talder mapper in \(#function)",
                                            underlyingError:nil )
                self.logAsInformationalError(errorOut)
                return
            }
            
            self.cleanDefunctTalderMaps(starker: starker, talderMapper:talderMapper)
        })
    }
    
    func cleanDefunctTalderMaps(starker: Starker,
                                talderMapper: TalderMapper) {
        var allStarkids: Set<String>?
        starker.managedObjectContext.performAndWait {
            allStarkids = Set(starker.allStarks().map { $0.starkid })
        }
        var talderMapsToRemove = Set<TalderMap>()
        talderMapper.managedObjectContext.perform {
            for talderMap in talderMapper.allObjects() {
                if let folderId = talderMap.folderId {
                    if (!(allStarkids ?? Set<String>()).contains(folderId)) {
                        talderMapsToRemove.insert(talderMap)
                    }
                }
            }
            for talderMap in talderMapsToRemove {
                talderMapper.delete(talderMap)
            }

            do {
                try talderMapper.save()
            } catch {
                let errorOut = NSError.init(code: 485736,
                                            localizedDescription: "Could not save in \(#function)",
                                            underlyingError: error)
                self.logAsInformationalError(errorOut)
                return
            }
        }
    }
    
    func cleanDefunctDiaryEntriesInBackground () {
        DispatchQueue.global(qos: .background).async {
            self.cleanDefunctDiaryEntries()
        }
    }
    
    @objc
    func cleanDefunctDiaryEntries () {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        guard let settingsContext = self.settingsPrivateContext() else {
            return
        }
        fetchRequest.entity = NSEntityDescription .ssy_entity(forName: constEntityNameMacster,
                                                              in: settingsContext)
        var olderThanDays = 100*365  // default to 100 years
        settingsContext.performAndWait {
            do {
                let macster = try settingsContext.fetch(fetchRequest).first as? Macster
                olderThanDays = macster?.daysDiary.intValue ?? 100*365  // default to 100 years
            } catch {
                let errorOut = NSError.init(code: 485834,
                                            localizedDescription: "Could not save in \(#function)",
                                            underlyingError: error)
                self.logAsInformationalError(errorOut)
                return
            }
        }

        let cutoffDate = Date.init(timeIntervalSinceNow: Double(-(olderThanDays*BkmxBasis.secondsPerDay())))
        
        let diariesStoreIdentifier = BkmxBasis.shared().filename(forMocName: constBaseNameExids,
                                                                 identifier: self.uuid)
        var diariesCoordinator: NSPersistentStoreCoordinator? = nil
        do {
            diariesCoordinator = try SSYMOCManager.persistentStoreCoordinatorType(NSSQLiteStoreType,
                                                                                  identifier: diariesStoreIdentifier,
                                                                                  momdName: constNameMomd,
                                                                                  recreateIfCorrupt: false)
        } catch {
            let errorOut = NSError.init(code: 485737,
                                        localizedDescription: "Could not get Diaries coordinator in \(#function)",
                                        underlyingError: error)
            self.logAsInformationalError(errorOut)
            return
        }
        
        let diariesContext = NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType)
        diariesContext.persistentStoreCoordinator = diariesCoordinator
        BkmxBasis.shared().deleteObjects(ofEntity: constEntityNameIxportLog,
                                         olderThan: cutoffDate,
                                         managedObjectContext: diariesMoc)
    }
    
    func settingsPrivateContext() -> NSManagedObjectContext? {
        let settingsStoreIdentifier = BkmxBasis.shared().settingsMocFilename(forIdentifier: self.uuid)
        var settingsCoordinator: NSPersistentStoreCoordinator? = nil
        do {
            settingsCoordinator = try SSYMOCManager.persistentStoreCoordinatorType(NSSQLiteStoreType,
                                                                                   identifier: settingsStoreIdentifier,
                                                                                   momdName: constNameMomd,
                                                                                   recreateIfCorrupt: false)
        } catch {
            let errorOut = NSError.init(code: 485733,
                                        localizedDescription: "Could not get Settings coordinator in \(#function)",
                                        underlyingError: error)
            self.logAsInformationalError(errorOut)
            return nil
        }
        
        let settingsContext = NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType)
        settingsContext.persistentStoreCoordinator = settingsCoordinator

        return settingsContext
    }
    
    @objc
    func migrateOperaLocalDataToOpera103WithProfiles() -> Void {
        /* The following "correct" way to get the defaultProfileName
         does not work
         let constants = ExtoreOpera.constants_p() as ExtoreConstants
         let defaultProfileName = constants.defaultProfileName
         maybe because ExtoreConstants does not have default values.
         So, I use the following ugly hard-coding: */
        let defaultProfileName = "Default"

        if let settingsMoc = self.settingsMoc {
            settingsMoc.performAndWait {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
                fetchRequest.entity = NSEntityDescription .ssy_entity(forName: constEntityNameClient,
                                                                      in: exidsMoc)
                fetchRequest.predicate = NSPredicate(format:"exformat == %@ AND extoreMedia == %@ AND profileName == nil", constExformatOpera, constBkmxExtoreMediaThisUser)
                settingsMoc.performAndWait {
                    do {
                        /* In previous versions, it was not possible to have
                         more than one Opera client, so OK to use .first… */
                        if let client = try settingsMoc.fetch(fetchRequest).first as? Client {
                            if (client.profileName == nil) {
                                client.profileName = defaultProfileName
                                try settingsMoc.save()
                                BkmxBasis.shared().logString("Migrated Opera client to 'Default' profile")
                            }
                        }
                    } catch {
                        let errorOut = NSError.init(code: 894882,
                                                    localizedDescription: "Could not fetch Opera client in \(#function)",
                                                    underlyingError: error)
                        self.logAsInformationalError(errorOut)
                        return
                    }
                }
            }
        }

        if let exidsMoc = self.exidsMoc {
            exidsMoc.performAndWait {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
                fetchRequest.entity = NSEntityDescription .ssy_entity(forName: constEntityNameClixid,
                                                                      in: exidsMoc)
                fetchRequest.predicate = NSPredicate(format:"clidentifier == \"Opera||thisUser|||\"")
                exidsMoc.performAndWait {
                    do {
                        if let legacyOperaClixids = try exidsMoc.fetch(fetchRequest) as? [Clixid] {
                            var nFixedClixids = 0
                            for clixid in legacyOperaClixids {
                                clixid.clidentifier = "Opera|Default|thisUser|||"
                                nFixedClixids += 1
                            }
                            try exidsMoc.save()
                            BkmxBasis.shared().logString("Migrated \(nFixedClixids) Opera clixids to 'Default' profile")
                        }
                    } catch {
                        let errorOut = NSError.init(code: 894882,
                                                    localizedDescription: "Could not upgrade clidenifiers in \(#function)",
                                                    underlyingError: error)
                        self.logAsInformationalError(errorOut)
                        return
                    }
                }
            }
        }
    }
    
}
