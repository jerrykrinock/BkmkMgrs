import Foundation

@objc class Tag : SSYManagedObject {
    // MARK: Managed Properties

    @objc @NSManaged var starks: Set<Stark>
    @objc @NSManaged var string: String?
    /* If I wanted this to follow the same design pattern as the code
     that I wrote in Stark.m in year 2009, instead of the above line, I
     would use the following custom setter (which requires a trivial
     custom getter to be paired with it.  However, since KVO seems to
     be better in Swift*/
    //    @objc var string: String? {
    //        set {
    //            willChangeValue(forKey: constKeyString)
    //            self.postWillSetNewValue(string,
    //                                     forKey: constKeyString);
    //            setPrimitiveValue(newValue, forKey: constKeyString)
    //            didChangeValue(forKey: constKeyString)
    //        }
    //        get {
    //            willAccessValue(forKey: constKeyString)
    //            let string = primitiveValue(forKey: constKeyString) as! String
    //            didAccessValue(forKey: constKeyString)
    //            return string
    //        }
    //    }
 
    // MARK: Key Value Observing (KVO)
    
    /* Reference for this sesction:
     https://developer.apple.com/documentation/swift/using-key-value-observing-in-swift
     Option-click on NSKeyValueObservation or observe() for laugns. */

    var changedStarksObservation: NSKeyValueObservation?
    var changedStringObservation: NSKeyValueObservation?

    override func prepareForDeletion() {
        /* If you don't stop observing when a Tag is deleted, then during the
         next save or autosave operation, the Tag will be un-deleted (its
         .deleted property will change from true back to false and its
         context's count of .deletedObjects will decrement) and the observer
         will be invoked to indicate that the .string property is being
         changed from what it was originally to nil. */
        self.stopObserving()
    }

    override func willTurnIntoFault() {
        /* If you do not stop observing, while document is being closed,
         you get this pair of messages logged to console for every Tag object:
         error:  API Misuse: Attempt to serialize store access on non-owning coordinator (PSC = 0x600002c5cc00, store PSC = 0x0)
         CoreData: error:  API Misuse: Attempt to serialize store access on non-owning coordinator (PSC = 0x600002c5cc00, store PSC = 0x0) */
        self.stopObserving()
    }

    func stopObserving() {
        self.changedStarksObservation = nil
        self.changedStringObservation = nil
    }

    func startObserving() {
        /* I considered two other ways of acting when `starks` changed:
         • override Core Data accessors
         • implement willChangeValue(forKey:)
         but this way, using KVO, seemed to be the most straightforward and
         probably efficient, despite the lack of documentation. */
        self.changedStarksObservation = observe (
            \.self.starks,
             options: [.old]) {object, change in
//                 var oldStarkNames: String = ""
//                 for stark in (change.oldValue ?? Set<Stark>()) as Set<Stark>{
//                     oldStarkNames.append(stark.name as String)
//                 }
//                 oldStarkNames = String(describing:oldStarkNames)
//                 var newStarkNames: String = ""
//                 for stark in change.newValue ?? Set<Stark>() as Set<Stark> {
//                     newStarkNames.append(stark.name as String)
//                 }
//                 newStarkNames = String(describing:newStarkNames)
//                 let string = String(describing:self.string)
//                 print("\(string) with \(self.starks.count) starks GOT NEW STARKS: isPrior = \(change.isPrior)\n   old: \(oldStarkNames)\n   new: \(newStarkNames)")
                 
                 /* In the following line, I should be able to replace
                  self.starks with change.newValue.  But the latter is nil!! */
                 if (!self.isDeleted) {
                     /*  Reported to Apple as FB11476687: The `change`, an
                      NSKeyValueObservedChange sent prior to has
                      change.newValue = NSNull instead of the new value.
                      Fortunately, I don't need the new value, but I need
                      it to *not* be an NSNull, in order to get by this line:
                      if ([newValue isKindOfClass:[NSNull class]]) { return; }
                      in -[BkmxDoc objectWillChangeNote:].  My workaround is
                      therefore to send a fake new value… */
                     var oldValue: Any?
                     if (change.oldValue as Any?) is Set<Stark> {
                         oldValue = change.oldValue
                     } else if (change.oldValue == nil) {
                         oldValue = "NIL_OLD_STARKS"
                     } else {
                         oldValue = "Some " + String(describing:type(of:change.oldValue)) + " of value: " + String(describing:change.oldValue)
                     }
                     self.postDidChangeOldValue(oldValue,
                                                forKey: constKeyStarks);
                 }
                 if (self.starks == nil) {
                     /* Empirically, this branch executes when there are
                      0 starks, even though 0 starks are not allowed. */
                     self.managedObjectContext?.delete(self)
                 } else if (self.starks.count == 0) {
                     /* Empirically, I see that this branch never executes,
                      maybe because in the .xcdatamodel > Tag_entity >
                      Relationships, `starks` has a minimum count set to
                      1 (and the Xcode user interface will now allow me
                      to reduce it to 0).  But I have this branch in case
                      the fact that `starks` is nil when there are zero
                      starks changes at a future date and starts being
                      an empty set instead.*/
                     self.managedObjectContext?.delete(self)
                 }
             }
        
        /* I think this is only necessary in case the user performs a
         secondary click in the Tag Cloud (RPTokanControl) and selects
         `Rename` from the contextual menu.   In the second parameter of
         observe(), options, the .prior option states that we want the
         third parameter (the callback) to be called prior to the change. */
        self.changedStringObservation = observe (
            \.self.string,
             options: [.old]) {object, change in
 //                print("GOT NEW STRING: isPrior = \(change.isPrior)\n   old: \(String(describing: change.oldValue))\n   new: \(String(describing: change.newValue))")
                 /* No-op if this is a "after change" callback. */
                 if (!self.isDeleted) {
                     /*  Reported to Apple as FB11476687: The `change`, an
                      NSKeyValueObservedChange sent prior to has
                      change.newValue = NSNull instead of the new value.
                      Fortunately, I don't need the new value, but I need
                      it to *not* be an NSNull, in order to get by this line:
                      if ([newValue isKindOfClass:[NSNull class]]) { return; }
                      in -[BkmxDoc objectWillChangeNote:].  My workaround is
                      therefore to send a fake new value… */
                     var oldValue: String??
                     if (change.oldValue is String) {
                         oldValue = change.oldValue
                     } else if (change.oldValue == nil) {
                         oldValue = "NIL_OLD_STRING"
                     } else {
                         oldValue = "Some " + String(describing:type(of:change.oldValue)) + " of value: " + String(describing:change.oldValue)
                     }
                     self.postWillSetNewValue(oldValue as Any?,
                                              forKey: constKeyString);
                 }
             }
    }
    
    @objc
    override func awakeFromFetch() {
       // print("Upon fetch, \(String(describing: self.string)) is tagging \(self.starks.map({$0.name}))")
        super.awakeFromFetch()
        self.startObserving()
    }
    
    @objc
    override func awakeFromInsert() {
        super.awakeFromInsert()
        self.startObserving()
    }
    
    // MARK: Comparators
    
    @objc func localizedCaseInsensitiveCompare(_ other:Tag) -> ComparisonResult {
        guard let otherString = other.string else {
            return ComparisonResult.orderedDescending
        }
        guard let selfString = self.string else {
            return ComparisonResult.orderedAscending
        }
        return selfString.localizedCaseInsensitiveCompare(otherString)
    }
    
    @objc func caseInsensitiveCompare(_ other: Tag) -> ComparisonResult {
        guard let selfString = self.string else {
            return .orderedAscending
        }
        guard let otherString = other.string else {
            return .orderedDescending
        }
        return selfString.caseInsensitiveCompare(otherString)
    }
    
    @objc override func shortDescription() -> String {
        let starks = (self.starks.map({$0.name}) as NSArray).componentsJoined(by: ",")
        let owner = (self as SSYManagedObject).allocOwner()
        return ("<Tag> \(self.truncatedID() ?? "<NO-STRING>") isF=\(self.isFault) isD=\(self.isDeleted) isA=\(self.isAvailable()) \(self.string ?? "<NO-STARKS>") on \(starks) owr:\(owner ?? "NONE")")
    }
}

// MARK: Core Data Generated accessors

@objc extension Tag {
    
    @objc(addStarksObject:)
    @NSManaged public func addToStarks(_ value: Stark)
    
    @objc(removeStarksObject:)
    @NSManaged public func removeFromStarks(_ value: Stark)
    
    @objc(addStarks:)
    @NSManaged public func addToStarks(_ values: NSSet)
    
    @objc(removeStarks:)
    @NSManaged public func removeFromStarks(_ values: NSSet)
    
}
