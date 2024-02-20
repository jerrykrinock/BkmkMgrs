#import <Cocoa/Cocoa.h>

#import "SSYManagedObject.h"


@class Dupetainer ;
@class Stark ;


@interface Dupe : SSYManagedObject {
	// Managed object properties are declared in the data model, not here
}

@property (retain) Dupetainer* dupetainer ;
@property (copy) NSString* url ;
@property (retain) NSSet* starks ;

/*!
 @brief    An array of the receiver's starks set, which is ordered by
 lineage alphanumerically if there are not too many.

 @details  The reason why we don't keep it always ordered is that (1) this
 property is used only to make a nice display and (2) there may be a huge
 cpu hit for sorting when the getter is invoked, if a Collection has
 a large number of Dupes which each have a large number of Starks.
 
 The compromises which make this sloppy is that sorting is not done
 if the number of starks exceeds 16.

 Until BookMacster 1.1.6, I stashed this as an ivar, and set it to
 nil, forcing recalculation the next time the getter was invoked,
 in -postWillSetNewStarks:.  However, as is well-known now, Core
 Data's Undo does not invoke custom setters, so after undo
 m_starksOrderedSloppy would have an incorrect, stale value.  The
 other solution, KVObserving starks, has its own set of headaches
 in removing observers, as explained in Apple Bug 6624874 and here:
 http://www.cocoabuilder.com/archive/cocoa/231060-observing-managed-object-changes.html?q=undo+%22custom+setter%22+observe#231066 
*/
- (NSArray*)starksOrderedSloppy ;

- (NSInteger)numberOfStarks ;

@end

@interface Dupe (CoreDataGeneratedAccessors)

- (void)addStarksObject:(Stark *)value;
- (void)removeStarksObject:(Stark *)value;
- (void)addStarks:(NSSet *)value;
- (void)removeStarks:(NSSet *)value;
- (NSComparisonResult)compareUrls:(Dupe*)otherDupe ;

@end

