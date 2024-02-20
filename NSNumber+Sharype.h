#import <Cocoa/Cocoa.h>
#import "StarkTyper.h"


/*!
 @brief    Category for wrapping Sharype values as NSNumber objects

 @details  Use these methods and you won't have to remember that a 
 Sharype is an ^unsigned^ ^short^ integer.
 */
@interface NSNumber (Sharype)

/*!
 @brief    Returns an NSNumber representation of a given sharype
 */
+ (NSNumber*)numberWithSharype:(Sharype)sharype ;

/*!
 @brief    Returns the Sharype value of the receiver
*/
- (Sharype)sharypeValue ;

/*!
 @brief    Returns the Sharype value of the receiver as a readable string
 */
- (NSString*)readableSharype ;

@end
