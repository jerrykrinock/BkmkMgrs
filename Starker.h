#import <Cocoa/Cocoa.h>
#import "Clientoid.h"
#import "SSYMojo.h"
#import "SSYErrorHandler.h"
#import "StarCatcher.h"

@class Stark ;

/*!
 @brief    Instantiated with a managed object context with Starks in it, Starker can
 do many of the common manipulations you need done on those Starks. 

 @details  This object is used in three situations: as either the starker or the
 localStarker for an Extore, or the -managedObjectContext of a BkmxDoc document.
 This class was written because the three situations described all require
 some common methods for accessing Starks and collections of Starks.

 The receiver's managed object context may contain other objects besides Starks.
*/
@interface Starker : SSYMojo {
	NSObject <SSYErrorHandler> * m_owner ;
	Clientoid* clientoid ; // Gotten lazily from owner, retained for efficiency
	Stark* m_root ;
	NSMutableSet* m_cachedAllObjects ;
	NSInteger m_hartainersChangeCount ;
	NSMutableDictionary* m_cachedStarksByKey ;
	NSMutableDictionary* m_cachedHartainers ;
	NSMutableArray* m_destinees ;
}

/*!
 @brief    The number of times that starks have changed.

 @details  This attribute is observable using KVO.  You can use it
 to determine whenever starks have changed.
*/
@property (assign) NSInteger hartainersChangeCount ;

+ (NSInteger)countOfBookmarksInItems:(NSArray*)starks ;

+ (NSInteger)areSortableItems:(NSArray*)items ;

/*!
 @brief    Arranges a given array of starks into a dictionary indexed by the
 starks' exids for a given clientoid, where each object is either a stark, if
 only one stark in a given array has a particular exid for a given clientoid,
 or a set of such starks, if multiple starks have a particular exid for the
 given clientoid
 
 @details  Use this method when you need to get many starks each matching
 a given exid for a single clientoid.  It is efficient because only
 one fetch is done.  The objects in the dictionary are called "starkets",
 because they can be either starks or sets of starks.
 
 @param    starkets  A mutable dictionary, which will be populated in order to
 return the results.  Normally, you pass an empty dictionary.
 @param    clientoid  The clientoid for which each returned stark must have an
 exid
 @param    array  The array of starks from which the to be parsed
 @result   A dictionary of starks, keyed by their exids for the given clientoid
 */
+ (void)populateStarkets:(NSMutableDictionary*)starkets
 keyedByExidForClientoid:(Clientoid*)clientoid
               fromArray:(NSArray*)starks ;

/*!
 @brief    The object which is using the receiver to store its Starks. 
 A weak reference.
 */
@property (assign) NSObject <SSYErrorHandler> * owner ;

/*!
 @brief    A mutable array which is used to collect starks
 during an ixport operation
*/
@property (retain) NSMutableArray* destinees ;

/*!
 @brief    Designated Initializer for Starker instances  ￼

 @details  Both arguments are required.  If either is nil, this
 method will return nil.
 @param    managedObjectContext  See class properties for documentation.
 @param    owner  See class properties for documentation.
 @result  ￼The receiver, or nil if something failed.
 */
- (id)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext_
							 owner:(NSObject <SSYErrorHandler> *)owner ;

/*!
 @brief    Sends -processPendingChanges receiver's managed object context.￼
 */
- (void)processPendingChanges ;

/*!
 @brief    Returns all starks in the receiver's managed object context 
 except the root stark
 */
- (NSArray*)allNonRootStarks ;

- (void)forgetHartainersCache ;

/*!
 @details   The *standin hartainers* concept was added to correct the problem
 that, if an Export client was lacking two hartainers, and each of these
 hartainers in BookMacster contained items, the items would be interleaved
 into the default parent during an export.

 @result    If the hartainer was missing and a standin was added, returns it.
 If the specified hartainer already exists in the store, returns nil.
 */
- (Stark*)makeStandinSharype:(Sharype)sharype ;

- (Stark*)hartainerOfSharype:(Sharype)sharype
					 quickly:(BOOL)quickly ;
- (NSSet<Stark*>*)allHartainers;
- (Stark*)clearStandinHartainerSharype:(Sharype)sharype
			 			   traceLevel:(NSInteger)traceLevel ;

/*!
 @brief    Returns all starks in the receiver's managed object context that
 are not hartainers; return NO to -isHartainer
 
 @param    quickly  If yes, uses -allObjectsQuickly instead of -allObjects
*/
- (NSSet*)allSoftStarksQuickly:(BOOL)quickly ;

/*!
 @brief    Returns all starks in the receiver's managed object context which
 should display in a flat, no-folders view.
 */
- (NSArray*)allNonhierarchicalStarks ;

/*!
 @brief    Returns all starks in the receiver's managed object context for
 which -sharypeValue returns SharypeSeparator
 */
- (NSArray*)allSeparatorStarks ;

/*!
 @brief    Returns a set of all the shortcuts existing in all of
 starks in the receiver's managed object context
 
 @details  A set, by definition, has all of its duplicates
 coalesced into one.&nbsp; However, duplicate shortcuts should
 not be allowed anyhow.
*/
- (NSSet*)allShortcuts ;

/*!
 @brief    Returns the first of the receiver's Starks whose value for a
 given key is equal to the value of the same key in another given Stark￼.

 @details  Typically, the Stark argument will belong to a different managed
 object context.  This method is thus used to find <i>corresponding</i> or
 <i>matching</i> Starks in different managed object contexts.
 
 This implementation uses -valueForKey: on stark.  It might be cheaper
 to change the key argument type to SEL, and use -performSelector: instead??
 
 This method may do a fetch.  If you're thinking of using it in a loop,
 use starksKeyedByKey: instead, for efficiency.
 @param    key  The key whose value is to be matched.
 @param    stark  The other stark whose value is to be matched.
 */
- (Stark*)starkWithEqualValueForKey:(NSString*)key
							asStark:(Stark*)stark ;

/*!
 @brief    A "bulk" version of starkWithEqualValueForKey:asStark: which
 returns all starks in a convenient dictionary with only one fetch.

 @details   Starks which have a nil value for the given key will be
 omitted from the result.
 @param    key  The key whose values will become keys in the result.&nbsp; 
 Of course, the type of these values must be suitable to be a dictionary
 key.&nbsp;
*/
- (NSDictionary*)starksKeyedByKey:(NSString*)key ;

/*!
 @brief    Returns all of the receiver's Starks that have a sponsor, i.e.
 sponsorIndex != nil.
 */
- (NSArray*)matchedStarks ;

/*!
 @brief    Returns all of the receiver's Starks that have no sponsor, i.e.
 sponsorIndex == nil.
 */
- (NSArray*)unmatchedStarks ;

/*!
 @brief    Sets the sponsorIndex to nil in all of the receiver's Starks.
 */
- (void)setAllStarksNotMatched ;

/*!
 @brief    Sets the same new value for the same key in a collection of starks

 @details  All starks in the 'starks' parameter should be in the same managed object
 context because the managed object context is obtained from the first stark
 in starks.
 @param    value  The new value to be set.
 @param    key  The key for which to set the value
 @param    starks  The NSArray of starks which are to be affected.
*/
- (void)setValue:(id)value
		  forKey:(NSString*)key
		inStarks:(id)starks ;

/*!
 @brief    Returns the first stark found of a given sharype in the receiver's
 owner's manged object context, or nil if no such stark exists.

 @details  The intended use is to get the hartainers.
*/
- (Stark*)starkOfSharype:(Sharype)sharype ;

/*!
 @brief    Returns the receiver's root Stark, creating one if none exists.
 
 @detail   BkmxDoc documents synced in from nonhierarchical sources
 will have all their items at root, and therefore when the outline is
 reloaded, if the view is is to displayFolders = YES,
 [BkmxDocOutlineDataSource outlineView:child:ofItem:] will be invoked
 for each item, which will invoke this method, which will do a fetch.&nbsp;
 In an early prototype, displaying a document with 1161 bookmarks at
 root spent 3:45 min:sec just fetching root.&nbsp; So, to eliminate
 that, this method caches the root in an instance variable.
 
 We can get away with simply caching it until there has been a -revert,
 because, once we have a root, it will never be replaced with a new
 root.
 */
@property (retain, readonly) Stark* root ;

- (Stark*)rootChildOfSharype:(Sharype)sharype ;

/*!
 @brief    Returns the receiver's root stark.
 */
- (Stark*)root ;


/*!
 @brief    Returns the receiver's Bookmarks Bar hartainer collection,
or nil if the receiver does not have one.
 */
- (Stark*)bar ;

/*!
 @brief    Returns the receiver's Bookmarks Menu hartainer collection,
 or nil if the receiver does not have one.
 */
- (Stark*)menu ;

/*!
 @brief    Returns the receiver's Bookmarks Unfiled hartainer collection,
 or nil if the receiver does not have one.

 @details  This hartainer collection is nil for most Extores.
 */
- (Stark*)unfiled ;

/*!
 @brief    Returns the receiver's Ohared (OmniWeb Shared) hartainer collection,
 or nil if the receiver does not have one.

 @details  This hartainer collection is nil for most Extores.
 */
- (Stark*)ohared ;

/*!
 @brief    Inserts a new stark into receiver's managed object context
 @result   The newly-inserted stark
 */
- (Stark*)freshStark ;

/*!
 @brief    Inserts a new "BookMacsterize" Bookmarklet into the receiver's
 managed object context.
 @result   The newly-inserted stark
*/
- (Stark*)freshBookMacsterizer ;

/*!
 @brief    Same as freshStark, but, in addition, the addDate and lastModifiedDate
 of the new stark are set to the current date.
 
 @result   The newly-inserted stark
 */
- (Stark*)freshDatedStark ;

/*!
 @brief    ￼Inserts a new stark in the receiver's managed object context and sets
 its attributes to match those of an other stark.

 @details  Enumerates through the attributes of otherStark.&nbsp; For each non-nil
 value found, sets the same value for the same attribute key in the new stark.
 
 @param    otherStark  The stark whose attributes are to be copied.
 */
- (void)insertStarkLikeStark:(Stark*)otherStark ;

/*!
 @brief    A wrapper for sending -save: to the receiver's managed object context
*/
- (BOOL)save:(NSError**)error ;

/*!
 @brief    A wrapper around super's -allObjectsError_p which displays
 the fetch error, if any.
*/
- (NSArray<Stark*>*)allStarks ;

- (void)clearCaches ;

/*!
 @brief    Usually, returns the same result as invoking -allObjects, often
 faster because a fetch is avoided, but possibly stale.

 @details  This method is not very reliable, because it sends old cached
 data, until NSManagedObjectContextObjectsDidChangeNotification is posted
 by the receiver's managed object context.  Read carefully the confusing
 documentation for NSManagedObjectContextObjectsDidChangeNotification.
 In particular, read the part about occurring during -processPendingChanges.
 It seems that this notification never gets posted, and thus the cache
 never gets updated, for a transMoc.
 
 Thus, do *not* use this method if the receiver's managed object context
 is a transMoc.
*/
- (NSSet*)allObjectsQuickly ;

/*!
 @brief   For each stark in the receiver, sets the stark's lastModifiedDate
 back to its old value if all of updates which caused it to be changed were
 undone milliseconds later, and returns the count of starks which have any
 updated values.
 */
- (NSInteger)finalizeStarksLastModifiedDates ;

@end
