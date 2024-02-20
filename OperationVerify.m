#import "OperationVerify.h"
#import "BkmxGlobals.h"
#import "BkmxDoc.h"
#import "Broker.h"


@implementation SSYOperation (OperationVerify)

/* Note that we do ^not^ call back to the main thread
 here using our -doSafely: trick.  This is because
 verifyStarks::::::: is thread-safe and will call back
 to the main thread for us when necessary to access
 the Core Data database.
 
 Also, if we did run -verifyStarks::::::: in the main
 thread, because we pass waitUntilDone:YES, BkmxAgent would
 block the main thread and deadlock our BkmxAgent.
 */
- (void)verify {
	NSError* error = nil ;
    BkmxDoc* bkmxDoc = [self.info objectForKey:constKeyDocument];
	NSArray* starks = [[self info] objectForKey:constKeyStarkload] ;
	NSDate* since = [[self info] objectForKey:constKeyVerifySince] ;
    BOOL plusAllFailed = [[[self info] objectForKey:constKeyPlusAllFailed] boolValue] ;
	BOOL ignoreNoInternet = [[[self info] objectForKey:constKeyIgnoreNoInternet] boolValue] ;
	
    BOOL ok = [[bkmxDoc broker] verifyStarks:starks
                                  verifyType:BrokerVerifyTypeRegularVerify
                                       since:since
                               plusAllFailed:plusAllFailed
                            ignoreNoInternet:ignoreNoInternet
                               waitUntilDone:YES
                                     error_p:&error] ;
	
	if (!ok) {
		[self setError:error] ;
	}
}

@end
