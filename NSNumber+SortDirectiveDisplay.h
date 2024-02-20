#import <Cocoa/Cocoa.h>


/*!
 @brief    Category for transforming a BkmxSortDirective value to a human-readable name
 
 @details  This category is referenced in bindings in BkmxDoc.nib.
 */
@interface NSNumber (SortDirectiveDisplay)

/*!
 @brief    Returns a localized, human-readable expression of the
 receiver, interpreted as an BkmxSortDirective enumerated value.
 */
- (NSString*)sortDirectiveDisplayName ;

@end
