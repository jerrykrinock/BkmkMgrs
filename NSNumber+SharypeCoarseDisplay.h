#import <Cocoa/Cocoa.h>


/*!
 @brief    Category for transforming a Sharype Coarseto a human-readable name
 */
@interface NSNumber (SharypeCoarseDisplay)

/*!
 @brief    Returns a localized, human-readable expression of the
 receiver, interpreted as a Sharype Coarse.
 */
- (NSString*)sharypeCoarseDisplayName ;

@end
