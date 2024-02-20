#import <Cocoa/Cocoa.h>


/*!
 @brief    Category for transforming a BkmxSortable value to a human-readable name

 @details  This category is referenced in bindings in BkmxDoc.nib.
*/
@interface NSNumber (SortableDisplay)

/*!
 @brief    Returns a localized, human-readable expression of the
 receiver, interpreted as an BkmxSortable enumerated value.
*/
- (NSString*)sortableDisplayName ;

@end
