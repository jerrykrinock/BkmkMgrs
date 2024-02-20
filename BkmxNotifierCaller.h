#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

__attribute__((visibility("default"))) @interface BkmxNotifierCaller : NSObject {
}

/*!
 @brief   Basic Notification Method
 */
+ (BOOL)presentUserNotificationTitle:(NSString* _Nullable)title
                      alertNotBanner:(BOOL)alertNotBanner
                            subtitle:(NSString* _Nullable)subtitle
                                body:(NSString* _Nullable)body
                           soundName:(NSString* _Nullable)soundName
                          actionDics:(NSArray<NSDictionary*>* _Nullable)actionDics
                             error_p:(NSError** _Nullable)error_p;

/*!
 @brief   Wrapper around the Basic Notification Method which includes an action
 based on constUserNotificationActionIndentifierShowHelpAnchor and a way to
 make this method a no-op.
 
 @param   error  If -[BkmxBasis shouldHideError:] returns YES when `error`
 is passed to it, or it `error` is nil, this method becomes a no-op.  That is
 all this `error` is used for.  No attributes of the `error` appear in any
 user notification.
 */
+ (BOOL)presentUserNotificationOfError:(NSError* _Nullable)error
                                 title:(NSString* _Nullable)title
                        alertNotBanner:(BOOL)alertNotBanner
                              subtitle:(NSString* _Nullable)subtitle
                                  body:(NSString* _Nullable)body
                             soundName:(NSString* _Nullable)soundName
                       targetErrorCode:(NSInteger)targetErrorCode
                               error_p:(NSError** _Nullable)error_p;

/*!
 @brief   Wrapper around the Basic Notification Method which includes an action
 based on constUserNotificationActionIndentifierPresentError
 */
+ (BOOL)presentUserNotificationWithHelpTitle:(NSString* _Nullable)title
                              alertNotBanner:(BOOL)alertNotBanner
                                    subtitle:(NSString* _Nullable)subtitle
                                        body:(NSString* _Nullable)body
                                   soundName:(NSString* _Nullable)soundName
                              helpBookAnchor:(NSString* _Nullable)helpBookAnchor
                                     error_p:(NSError** _Nullable)error_p;

@end

NS_ASSUME_NONNULL_END
