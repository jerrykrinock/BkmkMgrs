#import <Cocoa/Cocoa.h>


/*!
 @brief    Category for transforming an object which is either a Client
 or a SSYRecurringDate to a human-readable display name or day name
 
 @details  This category is referenced in bindings in BkmxDoc.nib.
 */
@interface NSObject (TrigDetailDisplay)

/*!
 @brief    Returns a localized, human-readable expression of the
 receiver.
 */
- (NSString*)triggerDetailDisplayName ;

@end
