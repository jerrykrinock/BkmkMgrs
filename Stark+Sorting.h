#import <Cocoa/Cocoa.h>
#import "Stark.h"

@interface Stark (Sorting)

+ (NSArray *)filteredSortedStarksFromStarks:(NSMutableArray*)starks
                               searchString:(NSString*)searchString
                                 searchDays:(NSNumber*)searchDays
                         searchInAttributes:(NSSet*)searchInAttributes
                                    sortKey:(NSString*)sortKey
                              caseSensitive:(BOOL)caseSensitive
                                 wholeWords:(BOOL)wholeWords
                              sortAscending:(BOOL)sortAscending
                                 filterTags:(NSSet*)filterTags
                            filterTagsLogic:(NSInteger)filterTagsLogic
                            foldersAtBottom:(BOOL)foldersAtBottom ;

- (NSArray*)descendantsFilteredSortedWithSharypesMask:(Sharype)sharypesMask
                                         searchString:(NSString*)searchString
                                           searchDays:(NSNumber*)searchDays
                                     stringSearchKeys:(NSSet*)searchInAttributes
                                        caseSensitive:(BOOL)caseSensitive
                                           wholeWords:(BOOL)wholeWords
                                              sortKey:(NSString*)sortKey
                                        sortAscending:(BOOL)sortAscending
                                         matchingTags:(NSSet*)filterTags
                                                logic:(NSInteger)filterTagsLogic ;

/*
 @details  This method will recurse into children if height > 0
 and will decrement height on each recursion.
 For an unlimited deep search set height to INT_MAX
 */
- (void)classifyBySharypeHeight:(NSInteger)height
					 hartainers:(NSMutableArray*)hartainers
					softFolders:(NSMutableArray*)softFolders
						 leaves:(NSMutableArray*)leaves
						notches:(NSMutableArray*)notches ;
/*!
 @brief    Classifies the receiver and its descendants by sharype and returns
 a list in the order in which they would appear in an outline.
 
 @details    If you are not interested in items of a particular sharype,
 pass nil for its corresponding parameter.
 
 The reason we need the output to be ordered is for -bookmarkContainers.
 
 @param    deeply  Says whether or not the search should go deeper than
 the immediate children of the receiver ?!?! WRONG ?!?! seems that this was
 changed in BkmkMgrs 1.12.7 and now, if NO, does not recurse into ANY children.
 What good is that?  Yet, I do use this method in several places and pass NO.
 Need to study this!
 @param    hartainers  An initialized NSMutableArray into which will be put items
 whose sharype returns NO to [StarkTyper isMoveableSharype:].
 @param    leaves  Same as hartainers, but this is for type SharypeCoarseLeaf.
 @param    separators  Same as hartainers, but this is for type SharypeSeparator
 */
- (void)classifyBySharypeDeeply:(BOOL)deeply
					 hartainers:(NSMutableArray*)hartainers
					softFolders:(NSMutableArray*)folders
						 leaves:(NSMutableArray*)bookmarks
						notches:(NSMutableArray*)separators ;

/*!
 @brief    Returns YES if the receiver and another stark have the
 same normalized url which is not nil and not zero length, 
 otherwise returns NO

 @details  If either the receiver and otherStark have nil or 0-length url,
 returns NO.  This is very important for mergeFromStartainer::: or gulpStartainer:::
 because this method compares folders too, and all folders have nil url.
 @param    otherBookmark  
*/
- (BOOL)marksSameSiteAs:(Stark*)otherBookmark ;

- (NSComparisonResult)compareNames:(Stark*)otherStark ;

/*!
 @brief    Compares the receiver with another stark, using sorting rules
 defined in the receiver's owner's shig
 
 @details  The receiver's owner must respond to -shig with a Bookshig
 or an exception will be raised if an undefined selector is invoked.
 @param    otherStark  The other stark with which the receiver is to be 
 compared.
 
 @result   NSOrderedAscending, NSOrderedSame, or NSOrderedDescending.&nbsp; 
 Which one you get is the defined the same as by -[NSString compare:].
 */
- (NSComparisonResult)compare:(Stark *)otherStark ;

/*!
 @brief    Compares the receiver with another stark, using sorting rules
 defined in the receiver's owner's shig, but considering only the name
 and the values of their name and sortDirective attributes.
 
 @details  The receiver's owner must respond to -shig with a Bookshig
 or an exception will be raised if an undefined selector is invoked.
 @param    otherStark  The other stark with which the receiver is to be 
 compared.
 
 @result   NSOrderedAscending, NSOrderedSame, or NSOrderedDescending.&nbsp; 
 Which one you get is the defined the same as by -[NSString compare:].
 */
- (NSComparisonResult)nameCompare:(Stark*)otherStark ;

/*!
 @brief    Compares the receiver with another stark, by -lineageLine
 
 @param    otherStark  The other stark with which the receiver is to be 
 compared.
 
 @result   NSOrderedAscending, NSOrderedSame, or NSOrderedDescending.&nbsp; 
 Which one you get is the defined the same as by -[NSString compare:].
 */
- (NSComparisonResult)lineageLineCompare:(Stark *)otherStark ;

/*!
 @brief    Compares the quality of the attributes of the receiver with
 that of another stark.
 
 @details  Uses a complicated formula which is in the app documentation
 somewhere.
 
 @result   If the receiver is better, returns NSOrderedDescending.&nbsp; 
 If the receiver is worse, returns NSOrderedAscending.
 */
- (NSComparisonResult)overallQualityCompare:(Stark*)otherBookmark ;


/*!
 @brief    Returns an array containing all of the receiver's descendants,
 and, optionally, first the receiver itself, all in a deterministic order

 @details  The deterministic order is based upon (1) a depth-first
 tree traversal and (2) sorting by index using -childrenOrdered
 of each node.
*/
- (NSMutableArray*)descendantsWithSelf:(BOOL)withSelf ;

/*!
 @brief    Sorts the immediate children only of the receiver according
 to the value of its own -shouldSort, or owner's settings, using
 -[Stark compare:].
 */
- (void)sortShallowly ;

+ (void)sortBy:(NSMenuItem*)sender ;

@end
