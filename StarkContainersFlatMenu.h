#import <Cocoa/Cocoa.h>
#import "SSYDynamicMenu.h"

/*!
 @brief    A menu which implements the non-lazy delegate methods of NSMenuDelegate
 required to populate a flat menu of starks, like the one you get in Safari when
 you click "Add Bookmark..." and select the location.
 
 @details  Note that a flat menu is necessary if it is desired to show the current
 selection and allow the user to go both up and down in the hierarchy.
 */
@interface StarkContainersFlatMenu : SSYDynamicMenu {
}

@end
