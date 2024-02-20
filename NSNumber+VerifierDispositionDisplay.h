#import <Cocoa/Cocoa.h>


/*!
 @brief    Category for transforming a BkmxFixDispo to
 a human-readable name
 */
@interface NSNumber (VerifierDispositionDisplay)

/*!
 @brief    Returns a localized, human-readable expression of the
 receiver, interpreted as a BkmxFixDispo.
 */
- (NSString*)verifierDispositionDisplayName ;

@end

