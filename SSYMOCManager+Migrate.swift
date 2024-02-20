import Foundation

@objc
extension SSYMOCManager {
    @objc
    class func migrateIfNeeded(url: URL, momdName: String) throws {
        let delegate = BkmxCoreDataMigrationDelegate()
        let manager = CoreDataProgressiveMigrator.init(storeUrl: url,
                                                       storeType: NSSQLiteStoreType,
                                                       momdName: momdName,
                                                       delegate: delegate)
        try manager.migrateStoreIfNeeded()
    }
}
