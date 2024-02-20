#import <Cocoa/Cocoa.h>
#import "BkmxDoc.h"

extern NSString* const constKeyLastContentTouchDate ;

/*!
 @brief    A category on BkmxDoc that provides methods which are only used in
 the GUI, in particular many key paths for binding to.

 @details  Many of the simple methods which are accessed via bindings are not declared.
*/
@interface BkmxDoc (GuiStuff)

@end
