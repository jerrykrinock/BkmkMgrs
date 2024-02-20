import Foundation

@objc
class Tagger : SSYMojo {
    @objc init(managedObjectContext: NSManagedObjectContext) {
        super.init(managedObjectContext: managedObjectContext,
                   entityName:constEntityNameTag)
    }
    
    func fetchTags(predicate: NSPredicate?) -> [Tag] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: constEntityNameTag)
        if (predicate != nil) {
            fetchRequest.predicate = predicate
        }
        var array: [Tag]
        do {
            let fetchResult = try self.managedObjectContext.fetch(fetchRequest)
            array = fetchResult as! [Tag]
        } catch {
            NSLog("Internal Error 382-2256")
            array = []
        }
        
        return array
    }
    
    /**
     Returns a NSCountedSet of all the tags existing in all of
     starks in the receiver's managed object context
     
     The count of each object in the result indicates how many
     bookmarks are so tagged.
     */
    @objc public var allTags : NSCountedSet {
        let allTagsArray = self.fetchTags(predicate: nil)
        let set = NSCountedSet()
        for tag in allTagsArray {
            /* Iterate over starks to accumulate the correct .count for
             each Tag element.  Unfortunately, there is no method to just
             set the count of an element.  To set the count of an element
             to N, you must add() it to the set N times. */
            for _ in tag.starks {
                /* Note that we do not access any properties of the stark,
                 here represented by _.  If we did, that might require
                 the stark to be fetched, which would be costly. */
                set.add(tag)
            }
        }
        
        return set
    }
    
    @objc func removeTags(_ tags: Set<Tag>) {
        for tag in tags {
            self.managedObjectContext.delete(tag)
        }
    }
    
    @objc func tag(string: String) -> Tag {
        /* Since the token field knows the tokenizing character, editingString
         should not include any instances of the tokenizing character.  But
         it might include whitespace or newlines on either end. */
        let trimmedString = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        var tag: Tag!
        if let existingTag = self.fetchTags(predicate: NSPredicate(format:"string ==[cd] %@", trimmedString)).first {
            tag = existingTag
        } else {
            tag = NSEntityDescription.insertNewObject(forEntityName: constEntityNameTag,
                                                      into: self.managedObjectContext) as? Tag
            /* I force the following because I don't think the above could ever
             fail to produce a Tag object.  */
            tag!.string = trimmedString
        }
        
        return tag
    }
    
    /**
     "Adds" tags from a different managed object context to a Stark in the
     callee'a managed object context
     
     Of course, due to the different contexts, this function will use an
     existing tag in its context, or insert a new tag if a tag with the
     given string does not already exist.
     */
    @objc func addForeignTags(_ foreignTags:Set<Tag>, to stark:Stark) {
        var nativeTagsToAdd = Set<Tag>()
        for foreignTag in foreignTags {
            let nativeTag = self.tag(string: foreignTag.string ?? "")
            nativeTag.addToStarks(stark)
            nativeTagsToAdd.insert(nativeTag)
        }
        stark .addTags(nativeTagsToAdd)
    }
    
    @objc @discardableResult func addTagString(_ string:String, to stark:Stark) -> Tag {
        let tag = self.tag(string: string)
        tag.addToStarks(stark)
        return tag;
    }
    
    @objc func addTagStrings(_ strings:Set<String>, to stark:Stark) {
        var tags = Set<Tag>()
        for string in strings {
            let tag = self.tag(string: string)
            tags.insert(tag)
        }
        stark.addTags(Set(tags))
    }
    
    @objc func updateTagStrings(_ proposedStrings:Array<String>, inStark stark:Stark) {
        /* I tried to write something more Swift-like, using Set and map,
         but since I want to preserve order, and since Swift does not yet have
         a built-in OrderedSet, and I did not want to include this monster:
         https://github.com/apple/swift-collections
         I instead said, well, loops still work :) */
        let existingStrings = stark.tags.map { $0.string }
        var stringsToAdd = Set<String>()
        var tagsToRemove = Set<Tag>()
        for tag in stark.tags {
            if (!proposedStrings.contains(tag.string!)) {
                tagsToRemove.insert(tag)
            }
        }
        for string in proposedStrings {
            if (!existingStrings.contains(string)) {
                stringsToAdd.insert(string)
            }
        }
        stark.removeTags(tagsToRemove)
        self.addTagStrings(stringsToAdd, to: stark)
    }
    
    @objc func deleteAll() {
        do {
            try super.deleteAllObjectsError_p()
        } catch {
            SSYAlert.alertError(error as NSError)
        }
    }
}

