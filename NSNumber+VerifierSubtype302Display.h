#import <Cocoa/Cocoa.h>


/*!
 @brief    Category for transforming a BkmxHttp302 to
 a human-readable name
 */
@interface NSNumber (VerifierSubtype302Display)

/*!
 @brief    Returns a localized, human-readable expression of the
 receiver, interpreted as a BkmxHttp302.
 */
- (NSString*)verifierSubtype302DisplayName ;

@end
