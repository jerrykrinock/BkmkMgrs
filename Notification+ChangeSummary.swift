import Foundation
import SSYSwift

extension Notification {
    func changesSummary() -> String {
        var summary = "\n"
        if let deletionsSummary = self.summaryOfSet((self.userInfo?[NSDeletedObjectsKey] as? Set<NSManagedObject>)) {
            summary.append("DELETED:\n")
            summary.append(deletionsSummary)
        }
        if let insertionsSummary = self.summaryOfSet((self.userInfo?[NSInsertedObjectsKey] as? Set<NSManagedObject>)) {
            summary.append("INSERTED:\n")
            summary.append(insertionsSummary)
        }
        if let updatedSummary = self.summaryOfSet((self.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject>)) {
            summary.append("UPDATED:\n")
            summary.append(updatedSummary)
        }
        if let refreshesSummary = self.summaryOfSet((self.userInfo?[NSRefreshedObjectsKey] as? Set<NSManagedObject>)) {
            summary.append("REFRESHED:\n")
            summary.append(refreshesSummary)
        }
        summary.removeLast()  // removes the last "\n"
        
        return summary
    }
    
    func summaryOfSet(_ changedObjects: Set<NSManagedObject>?) -> String? {
        if let changedObjects = changedObjects {
            var countedSet = CountedSetByHash<String>()
            for object in changedObjects {
                if let entityName = object.entity.name {
                    var trimmedEntityName = entityName
                    let uselessSuffix = "_entity"
                    if (entityName.hasSuffix(uselessSuffix)) {
                        trimmedEntityName = String(entityName.prefix(entityName.count - uselessSuffix.count))
                        countedSet.add(trimmedEntityName)
                    }
                }
            }
            
            if (countedSet.count > 0) {
                return countedSet.description
            } else {
                return nil;
            }
        }
        
        return nil
    }
    
}

