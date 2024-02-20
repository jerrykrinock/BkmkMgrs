#import <Cocoa/Cocoa.h>
#import "BkmxAppDel.h"
#import "BkmxGlobals.h"

@class Stark ;
@class StarkLocation ;



@interface StarkEditor : NSObject {
}

/*!
 @brief    Efficiently removes many starks from their parents, adjusting sibling
 indexes as necessary, removes any associated starxids, and removes
 the starks from their managed object contexts

 @param    bkmxDoc  If starks are being removed from a Collection, you must
 pass it in here so that -[BkmxDoc postSortMaybeNot] will be invoked on it at
 the end of this process.  Also, progress will be indicated in the progress
 view of the passed-in BkmxDoc.  If you don't need either of those two tasks
 done, or if there is no associated BkmxDoc, you may pass in nil.
*/
+ (void)removeStarks:(NSSet*)starks
             bkmxDoc:(BkmxDoc*)bkmxDoc ;

/*!
 @brief    Attempts to obtain an array of subject starks from a given sender.
 
 @details  Attempts the following choices, in this order, returning
 whichever first responds to the necessary selectors and returns a non-nil
 answer:
 <ol>
 <li>If sender is itself a single stark, returns an array containing it</li>
 <li>If sender is a collection, returns the collection.</li>
 <li>If sender responds to selector -representedObject (which means it's
 probably an NSMenuItem)...
 <ol>
 <li>If representedObject is a collection, returns the collection.</li>
 <li>If representedObject responds to -selectedStarks (which means that
 it is a window controller BkmxDocChildWindowController), returns those
 -selectedStarks</li>
 <li>If representedObject is a is a view in a window with a window
 controller that responds to -selectedStarks (which means that the window
 controller is a BkmxDocChildWindowController), returns those
 -selectedStarks.</li>
 </ol>
 <li>If sender responds to -selectedStarks (which means that
 it is a window controller BkmxDocChildWindowController), returns those
 -selectedStarks</li>
 <li>If sender is a view in a window with a window controller that
 responds to -selectedStarks (which means that the window controller is
 a BkmxDocChildWindowController), returns those -selectedStarks</li>
 <li>Ignores sender.&nbsp; If the current -mainWindow of the 
 application is a window with a window controller that
 responds to -selectedStarks (which means that the window controller is
 a BkmxDocChildWindowController), returns those -selectedStarks</li>
 </ol>
 */
+ (NSArray*)starksFromSender:(id)sender ;

+ (StarkCanParent)canInsertStarks:(NSArray*)items
                       intoParent:(Stark*)parent ;

/*!
 @brief    
 
 @details  Performs an action upon a subject collection of Stark instances.
 Important: The owner of the Stark instances must be a BkmxDoc.  Using this
 method in an attempt to parent Starks in Extores will raise 'does not
 recognize selector' exceptions.
 @param    action  The action to be performed
 @param    items  An array of subject starks upon which to perform the action,
 or a single stark
 @param    newParent  For add, move or copy operations, the parent into which
 the subject item(s) should be added, moved or copied.
 @param    proposedIndex  For add, move or copy operations, the index at which
 the subject item(s) should be added in, moved to or copied to.  To add under
 existing siblings, you may pass NSNotFound.
 @param    revealDestin  If YES, will deselect whatever is selected in the user
 interface, and instead select and reveal the subject starks after the move.
 @result   The lowest-value (most failed) result of the attempted move(s)
 */
+ (StarkCanParent)parentingAction:(BkmxParentingAction)action
                            items:(id)items
                        newParent:(Stark*)targetParent
                         newIndex:(NSInteger)proposedIndex
                     revealDestin:(BOOL)revealDestin ;

+ (void)moveItem:(id)item
		toParent:(id)parentNew
         atIndex:(NSInteger)indexNew ;
+ (void)moveItem:(id)item
	  toLocation:(StarkLocation*)location ;
+ (void)moveAndSortNoRevealStarks:(NSArray*)starks
                      toNewParent:(Stark*)newParent ;
+ (BOOL)moveNoRevealStarks:(NSArray*)starks
               toNewParent:(Stark*)newParent ;
+ (void)copyNoRevealStarks:(NSArray*)starks
               toNewParent:(Stark*)newParent ;
+ (void)mergeFolders:(NSArray*)folders
          intoFolder:(Stark*)survivorFolder ;
	
+ (void)setSortableBool:(BOOL)yn
				 sender:(id)sender ;

+ (void)addTags:(NSArray*)newTags
	toBookmarks:(NSArray*)bookmarks ;
+ (void)removeTags:(NSArray*)deletedTags
	 fromBookmarks:(NSArray*)bookmarks ;

+ (void)copyCut:(BOOL)cut
		 sender:(id)sender ;

+ (void)setSortDirectiveTopStark:(Stark*)item ;
+ (void)setSortDirectiveTopStarks:(NSArray*)starks ;
+ (void)setSortDirectiveBottomStark:(Stark*)item ;
+ (void)setSortDirectiveBottomStarks:(NSArray*)starks ;
+ (void)setSortDirectiveNormalStark:(Stark*)item ;
+ (void)setSortDirectiveNormalStarks:(NSArray*)starks ;

+ (void)visitStark:(Stark*)stark ;

+ (void)visitItems:(NSArray*)items
	urlTemporality:(BkmxUrlTemporality)urlTemporality ;

+ (void)swapPriorAndCurrentUrls:(id)sender ;
+ (void)swapSuggestedAndCurrentUrls:(id)sender ;

@end
