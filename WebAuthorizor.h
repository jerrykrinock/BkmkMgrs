#import <Foundation/Foundation.h>
#import "BkmxGlobals.h"

NS_ASSUME_NONNULL_BEGIN

@class BkmxDoc;
@class Client;
@class Ixporter;

@interface WebAuthorizor : NSObject

@property (weak) Client* client;

/*!
 @brief
 
 @details
 @param    info  A dictionary containing constKeyIxporter and,
 optionally, in case of an Import or Export, constKeyDidSucceedInvocation.
 */
- (void)getOAuthAuthorizationWithInfo:(NSMutableDictionary*)info;

- (void)askUserAccountInfoForIxporter:(Ixporter*)ixporter
                                 info:(nullable NSDictionary*)info ;

/*!
 @brief    Subclasses must override to return the url which a user
 would browse to in order to create a new account.

 @details  Default implementation logs an internal error and
 returns nil.
*/
- (nullable NSString*)urlToCreateNewAccount ;

/*!
 @brief    Tests whether or not the receiver can log in
 with the credentials available, sets constKeySucceeded and
 possibly constKeyError in the info accordingly, then
 invokes the callback -endLoginTestInfo:

 @details  The default implementation sets constKeySucceeded
 to YES and then invokes -endLoginTestInfo:.  Subclasses which
 require login should override this method.
*/
- (void)testLoginWithInfo:(NSMutableDictionary*)info ;


- (void)beginLoginTestInfo:(NSMutableDictionary*)info ;
- (void)endLoginTestInfo:(NSMutableDictionary*)info ;

/*!
 @brief    If info indicates success and if user desired, adds the receiver's
 current login credential to her macOS Keychain, then invokes
 -sendIsDoneMessageFromInfo.
*/
- (void)updateKeychainFromInfo:(NSMutableDictionary*)info ;

/*!
 @brief    Returns the localized message shown in a sheet
 to the user advising them that they are about to be taken
 to the provider's website to link this application to their
 account with the provider.

 @details  The default implementation returns nil.  Subclasses
whose authorizationMethod is BkmxAuthorizationMethodOAuth
should override this method.
*/
- (nullable NSString*)linkServiceMessage;

+ (NSSet*)ssySyncCredentialErrorCodesSet;

+ (NSInvocation*)didSucceedEnteringAccountInfoInvocation;

@end

NS_ASSUME_NONNULL_END
