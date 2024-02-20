#import <Cocoa/Cocoa.h>

#define BKMX_STARK_CONTEXTUAL_MENU_ITEM_TAG_COPY_TO 3710
#define BKMX_STARK_CONTEXTUAL_MENU_ITEM_TAG_MOVE_TO 3720
#define BKMX_STARK_CONTEXTUAL_MENU_ITEM_TAG_MERGE_INTO 3730



/*!
 @brief    An NSMenu helper which can add contextual menu items
 for a Stark context, or return an entire prefabricated menu
 containing all avalailable items.
 
 @details  Items in menus built using the methods of this class
 are disabled as needed when they are created, by setting a
 target, and by setting their action to NULL.&nbsp;  Do not
 implement -validateMenuItem: or -validateUserInterfaceItem
 for these menu items.
 
 Most of the methods take, as arguments, the array of starks
 which would be involved if the menu command is clicked.&nbsp;  
 For convenience, these arrays are passed through to the
 action methods when a menu item is clicked as the
 -representedObject.&nbsp;  (The menu item is the 'sender'
 parameter passed to the action method, so that the action
 method may recover the array by sending [sender representedObject])
 */
@interface NSMenu (StarkContextual)

/*!
 @brief    Adds, at the bottom of the receiver, a menu item which
 is the root of a hierarchical submenu.

 @details  
 @param    title  The title of the new menu item
 @param    selector  A selector with two parameters
 @param    index  Index at which to insert the item in the menu.  Must be
 a nonnegative integer less than or equal to the current count of items in
 the receiver's itemArray
 @param    enabled  Whether or not the new menu item should be
 enabled
*/
- (void)addHierarchicalContentItemWithTitle:(NSString*)title
								   selector:(SEL)selector
                                        tag:(NSInteger)tag
                                      index:(NSInteger)index
							  payloadStarks:(NSArray*)payloadStarks
									enabled:(BOOL)enabled ;
- (void)addShowInspectorItem ;
- (void)addSeparatorItem ;
- (void)addVisitItemsForBookmarks:(NSArray*)bookmarks ;
- (void)addCopyAndCutItemForStarks:(NSArray*)starks ;
/*!
 @brief    Adds three menu items, "Copy to >" and a "Move to >", and
 "Merge into >" into the receiver, by twice invoking
 -addHierarchicalContentItemWithTitle:selector:payloadStarks::enabled:.

 @param    starks  The children of the root of starks for this menu item.
*/
- (void)addHierarchicalItemsForStarks:(NSArray*)starks
                         startAtIndex:(NSInteger)index;
- (void)addHierarchicalItemsForStarks:(NSArray*)starks;
- (void)addDeleteItemForStarks:(NSArray*)items ;
- (void)addSetSortableItemForContainers:(NSArray*)containers ;
- (void)addSortDirectiveItemsForSoftFoldersAndBookmarks:(NSArray*)softFoldersAndBookmarks ;
- (void)addClearDontVerifyItemForBookmarks:(NSArray*)bookmarks ;
- (void)addSwapUrlsItemsForBookmarks:(NSArray*)bookmarks ;
/*!
 @details  This is used in the Main Menu too.
*/
+ (void)configureToSortNowItem:(NSMenuItem*)menuItem
					 smallFont:(BOOL)useSmallFont
						starks:(NSArray*)starks ;


+ (NSMenu*)menuWithAllActionsForSelectedStarks:(NSArray*)selectedStarks ;

@end
