#import <Cocoa/Cocoa.h>

@class Extore;
@class SSYAlert;

@protocol ExtensionsCallbackee

/*!
 @brief    Sent to a delegate when an indeterminate progress
 has begun

 @details  The callbackee should display indeterminate progress
 upon receiving this message
 @param    verb  A localized string indicating what is happening
 @param    extore  The Extore object which is involved in 
 the progress
*/
- (void)beginIndeterminateTaskVerb:(NSString*)verb
                         forExtore:(Extore*)extore ;

/*!
 @brief    Sent to callbackee when new results are available
 for a given Extore object.

 @param    extore  The Extore object for which new results
 are available, if any; otherwise, nil
*/
- (void)muleIsDoneForExtore:(Extore*)extore ;

- (void)presentError:(NSError*)error ;
- (void)presentAlert:(SSYAlert*)alert
   completionHandler:(void (^)(NSModalResponse))handler ;

- (void)refreshAndDisplay ;

@end


