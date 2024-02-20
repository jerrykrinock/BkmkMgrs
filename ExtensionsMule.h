#import <Cocoa/Cocoa.h>
#import "ExtensionsCallbackee.h"
#import "BkmxGlobals.h"

extern NSString* const constKeyIsActualTestResult ;
extern NSString* const constKeyExtensionIndex ;

@class Extore ;
@class Client ;
@class SSYOperationQueue ;
@class SSYOperation ;

/*!
 @brief    An object which can install, uninstall, probe, 
 and test web browser extensions (extensions and Messenger) for
 BookMacster
*/
@interface ExtensionsMule : NSObject {
	NSArray* m_extores ;
	NSDate* m_testTimeout ;
	NSMutableDictionary* m_currentInfo ;
	SSYOperationQueue* m_operationQueue ;
	NSInvocation* m_workToDo ;
	
	// An dictionary of dictionaries, one for each client/extore
	NSMutableDictionary* m_results ;
	
	NSObject <ExtensionsCallbackee> * m_delegate ;
}

@property (nonatomic, retain) NSArray* extores ;
@property (nonatomic, retain, readonly) NSMutableDictionary* results ;

/*!
 @brief    Designated initializer for ExtensionsMule

 @param    delegate  An object which will receive
 messages when indeterminate progress begins, and after
 an install?, uninstall? or test is complete.
 The receiver does not retain this object.
*/
- (id)initWithDelegate:(NSObject <ExtensionsCallbackee> *)delegate ;

- (void)refreshResults ;
- (void)muleRefreshAndDisplay ;

/*!
 @brief    Updates the receiver's internal results with a new
 test result from an extore and sends the receiver's
 testCallback selector to its delegate.
 
 @detail   This message is expected as a callback from an
 extore object after a test is completed.
 @param    extore  The extore which is sending its result
 */
- (void)extore:(Extore*)extore
	testResult:(NSDictionary*)result ;

- (void)installForTag:(NSInteger)tag
               window:(NSWindow*)window ;

- (void)uninstallForTag:(NSInteger)tag ;

- (void)testForExtore:(Extore*)extore ;

- (void)quitBrowserForExtore:(Extore*)extore ;

- (void)clearAllActualTestResults ;

+ (NSInteger)tagForExtoreIndex:(NSInteger)extoreIndex
                extensionIndex:(NSInteger)extensionIndex
                    isAnUpdate:(BOOL)isAnUpdate ;

+ (NSInteger)extoreIndexForTag:(NSInteger)tag ;

+ (NSInteger)extensionIndexForTag:(NSInteger)tag ;

+ (NSInteger)isAnUpdateForTag:(NSInteger)tag ;

- (void)uninstallAllExtensions ;

@end
