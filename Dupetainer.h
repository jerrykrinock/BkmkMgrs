#import <Cocoa/Cocoa.h>
#import "SSYManagedObject.h"

@class Dupe ;

// Constants (defined in .m)

// Dupetainer Attributes
extern NSString* const constKeyDupes ;
extern NSString* const constKeyDupesOrdered ;


@interface Dupetainer : SSYManagedObject <NSOutlineViewDataSource, NSComboBoxDataSource> {
	// Managed object properties are declared in the data model, not here
	
	NSArray* m_dupesOrdered ;
}

// Relationships

/*!
 @brief    The set of the Dupes in the receiver's document.
 */
@property (retain) NSSet* dupes ;

//@property (retain) id dummy ;

#pragma mark * Shallow Value-Added Getters

/*!
 @brief    Returns whether or not the receiver contains one or more dupes.&nbsp; 
 KVObservable.
 */
- (BOOL)hasOneOrMore ;

/*!
 @brief    The receiver's dupes, ordered by URL.
 
 @details  This value is derived directly from the 'dupes' property.&nbsp; 
 For efficiency, it is cached as an instance variable.&nbsp;  Whenever dupes may
 have changed, you must send -clearCache which clears this instance variable
 and forces it to be regenerated the next time it is accessed.&nbsp;  And,
 yes, performance without this cache is unbearably slow when there is a
 large number of dupes because the entire set of dupes must be sorted
 for each invocation of outlineView:child:ofItem.
 */
@property (retain, readonly) NSArray* dupesOrdered ;

/*!
 @brief    Returns an NSMutableDictionary of all of the receiver's dupes.&nbsp;
 Keys are the common url] of each group.&nbsp;
 Value is an array of starks having this common url].&nbsp; 
 
 @details  Suitable for +[DupeFinder eliminateDupesWithInfo:] constKeyDupeDic.
 */
- (NSMutableDictionary*)allDupeDic ;


#pragma mark * Other Methods

/*!
 @brief    Clears the dupesOrdered cache, so that the current dupes
 will be re-ordered the next time that -dupesOrdered are accessed.

 @details  This is used instead of a notification because this
 clearing must be done before notifications that order -reloadData
 of the dupesOutlineView get posted.
*/
- (void)clearCache ;

/*!
 @brief    Given a dictionary of Dupes objects, sets a new set of Dupes
 in the receiver's document.
*/
- (void)setDupesWithDictionary:(NSDictionary*)dupesDictionary ;

/*!
 @brief    Iterates through the receiver's dupes and
 removes starks from dupes, and also removes dupes themselves that
 are no longer dupes because the receiver's owner's shig's
 ignoreDisparateDupes has been switched on, or because it was
 already on and starks have been moved to different collections.
 
 @details  This may be needed, for example, if the owner's shig's 
 ignoreDisparateDupes is switched from NO to YES.
 
 Unless the user has let dupes get out of control,
 most users will have many fewer dupes than bookmarks, and therefore
 while finding dupes may take a long time, removing vestiges
 should be quick and able to be done on the fly.
 */
- (void)checkAndRemoveDupeDisparagees ;

/*!
 @brief    Iterates through the receiver's dupes and in each one
 removes starks that no longer belong due to changes in URL or
 isAllowedDupe, and removes the dupe itself if it now has less
 than two starks.  Then, remembering the starks with changed
 URLs, creates new dupes if necessary.
 
 @details   Unless the user has let dupes get out of control,
 most users will have many fewer dupes than bookmarks, and therefore
 while finding dupes may take a long time, removing vestiges
 should be quick and able to be done on the fly.
 */
- (void)checkAndRemoveDupeVestiges ;

@end

@interface Dupetainer (CoreDataGeneratedAccessors)

- (void)addDupesObject:(Dupe *)value;
- (void)removeDupesObject:(Dupe *)value;
- (void)addDupes:(NSSet *)value;
- (void)removeDupes:(NSSet *)value;

@end
