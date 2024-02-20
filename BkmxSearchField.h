#import <Cocoa/Cocoa.h>
#import "SSYSearchField.h"

@class BkmxDocWinCon ;
@protocol BkmxSearchDelegate ;

#define BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_FOR           0x00000001
#define BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_IN            0x00000002
#define BKMX_SEARCH_FIELD_MENU_ITEM_TAG_LAST_TOUCHED         0x00000004
#define BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_OPTIONS       0x00000008

#define BKMX_SEARCH_FIELD_MENU_ITEM_TAG_CASE_SENSITIVE       0x00000010
#define BKMX_SEARCH_FIELD_MENU_ITEM_TAG_WHOLE_WORDS          0x00000020

#define BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_BOOKMARKS     0x00001000
#define BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_FOLDERS       0x00002000

#define BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_NAME          0x00010000
#define BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_TAGS          0x00020000
#define BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_URL           0x00040000
#define BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_SHORTCUT      0x00080000
#define BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_COMMENTS      0x00100000

#define BKMX_SEARCH_FIELD_MENU_ITEM_TAG_LAST_DAY             0x01000000
#define BKMX_SEARCH_FIELD_MENU_ITEM_TAG_LAST_WEEK            0x02000000
#define BKMX_SEARCH_FIELD_MENU_ITEM_TAG_LAST_MONTH           0x04000000
#define BKMX_SEARCH_FIELD_MENU_ITEM_TAG_LAST_QUARTER         0x08000000

/*!
 @brief    Provides the menu for the "Quick Search" field

 @details  The reason for making this menu in code instead of in the xib
 is because this is the only way I can see to set the states (checkmarks)
 of items based on User Defaults.
*/
@interface BkmxSearchField : SSYSearchField {
}

+ (void)decodeMenuItem:(NSMenuItem*)menuItem
               toKey_p:(NSString**)key_p
            toObject_p:(id*)object_p ;

/*!
 @brief

 @details   Because the order of sending -awakeFromNib to archived objects in nib
 is not defined, and since File's Owner is an archived object in nib,
 we don't use -awakeFromNib but instead invoke this method at the proper
 time in the Owner's -awakeFromNib.
 
 @param    includeSearchFor  If NO, the menu will include a "Search for" section
 with two items "Bookmarks" and "Folders".  If YES, this section will be absent.
*/
- (void)populateFromUserDefaultsForDelegate:(NSObject <BkmxSearchDelegate> *)bkmxDocWinCon
                           includeSearchFor:(BOOL)includeSearchFor ;

@end
