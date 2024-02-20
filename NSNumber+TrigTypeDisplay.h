#import <Cocoa/Cocoa.h>


/*!
 @brief    Category for transforming a Trigger type to a human-readable name
 
 @details  This category is referenced in bindings in BkmxDoc.nib.
 */
@interface NSNumber (TrigTypeDisplay)

/*!
 @brief    Returns a localized, human-readable expression of the
 receiver, interpreted as a Trigger type.
 */
- (NSString*)triggerTypeDisplayName ;

@end
