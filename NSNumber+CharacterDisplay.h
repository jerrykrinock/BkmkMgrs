#import <Cocoa/Cocoa.h>


/*!
 @brief    Category for transforming a delimiter character value
 into a human-readable expression.
 
 @details  This category is referenced in bindings in BkmxDoc.nib
 and PrefsWindow.nib.
 */
@interface NSNumber (CharacterDisplay)

/*!
 @brief    Returns a localized, human-readable expression of the
 receiver, with its -unsignedShortValue interpreted as a unicode character.
 */
- (NSString*)characterDisplayName ;

@end
