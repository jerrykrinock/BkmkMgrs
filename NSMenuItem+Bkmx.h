#import <Cocoa/Cocoa.h>

// Used for menu item titles Xxx and Yyy in "Add Xxx to Your Landing (Yyy)"
#define MENU_ITEM_MAX_DISPLAY_CHARS_SHORT 22
// Used for menu item titles "Add Here: "Xxx"" or "Inspect "Xxx"" where Xxx is the name of a bookmark or folder
#define MENU_ITEM_MAX_DISPLAY_CHARS_MEDIUM 55
// Used for menu item titles "Xxx" where Xxx is the name of a bookmark or folder
#define MENU_ITEM_MAX_DISPLAY_CHARS_LONG 64

@class Stark ;

@interface NSMenuItem (Bkmx) 

/*!
 @brief    Scales a given image to that of the receiver's menu's font size, and
 sets it as the receiver's image.
 
 @details  Obviously, you should set the receiver's menu's font size before
 invoking this method.  Also, for some obscure reason, you must set the 
 receiver's title before invoking this method.  Otherwise, your title will
 apparently be set to nil and appear as "NSMenuItem".
*/
- (void)scaleAndSetImage:(NSImage*)image ;


/*!
 @brief    Makes the receiver into an "Add Here:" menu item

 @param    info  browmarkInfo
*/
- (void)addHereifyWithInfo:(NSDictionary*)info ;

/*!
 @brief    Makes the receiver into an "Visit All" menu item
 
 @param    parent  The container whose children will be visited when the
 receiver performs its action
 */
- (void)visitAllifyOfParent:(Stark*)parent ;

/*!
 @brief    Makes the receiver into an "… into a new subfolder" menu item
 
 @param    info  browmarkInfo
 */
- (void)newSubfolderifyWithInfo:(NSDictionary*)info ;

@end
