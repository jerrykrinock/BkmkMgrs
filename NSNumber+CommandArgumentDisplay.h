#import <Cocoa/Cocoa.h>


/*!
 @brief    Category for transforming a Command argument to a human-readable name
 
 @details  This category is referenced in bindings in BkmxDoc.nib.
 */
@interface NSNumber (CommandArgumentDisplay)

/*!
 @brief    Returns a localized, human-readable expression of the
 receiver, interpreted as a Command argument.
 */
- (NSString*)commandArgumentDisplayName ;

@end
