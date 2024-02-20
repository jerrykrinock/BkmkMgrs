#define N_SIMULTANEOUS_CONNECTION_ATTEMPTS_1stPASS 16
#define N_SIMULTANEOUS_CONNECTION_ATTEMPTS_RETEST 8

#import "BkmxGlobals.h"
#import <Cocoa/Cocoa.h>
#import "SSYDocChildObject.h"

enum VerifyPhase
{
	kIdle,
	kFirstPass,
	kWaitingFirst,
	kRetestingSome,
	kWaitingSecond
} ;

@protocol LongTask

- (void)abortLongTask ;

@end



@interface Broker : SSYDocChildObject < LongTask >
{
	enum VerifyPhase verifyPhase ;
    NSInteger nWaiting ;
	// The above array is built while we are
	// collecting responses from websites.  After it is done, we then
	// add this information to the bookmarks tree.  This is done in the
	// primary thread and locks up the user interface, but it is pretty quick.
	NSInteger iNext ;
	NSInteger nGot ;
	NSInteger nToBeRetested ;
	NSInteger nBroken ;
	NSInteger nToVerify ;
	BOOL connectionsHaveBeenDroppedBefore ;
	NSInteger nSimultaneous ;
	NSInteger nReceivedSinceLastThrottleChange ;
	NSInteger nWaitingWhenBackedOff ;
	CGFloat currentThrottlePeriod ;
	BOOL ignoreNoInternet ;
	CGFloat recentTimeoutRate ;
	BOOL connectionActive ;
	BOOL failed ;
	BOOL doneSending ;
	BOOL waitUntilDone ;

	// object instance variables
	NSTimer* _throttle ;
	NSTimer* _warnStallTimer ;
	NSArray* bookmarksFlat ;
	NSMutableArray* brokenBookmarks ;
	NSMutableArray* brokenBookmarkHeaders ;
	NSMutableArray* headerGetters ;
	NSMutableArray* autoFixedBookmarks ;
	NSError* error ;
}

@property (assign) VerifyType verifyType ;
@property (assign) NSInteger nSecurifySucceeded ;
@property (assign) NSInteger nSecurifyFailed ;
@property (retain) NSMutableArray* brokenBookmarkHeaders ;
@property (retain) NSMutableArray* brokenBookmarks ;
@property (retain) NSMutableArray* autoFixedBookmarks ;

- (void)clear ;
- (enum VerifyPhase)verifyPhase ;
- (void)doFixAuto ;
- (void)restartThrottle ; // Uses current speed from userDefaults

/*!
 @brief    The normal entry point for beginning a Verify operation.

 @details  This method is thread-safe in the sense that it will
 call back and do most of its work on the main thread.
 
 @param    starks  The starks to be verified if they were last 
 verified later than 'since'.
 @param    since  Starks which were lastVerified after this date
 will be skipped in the verification process.&nbsp;  Pass
 [NSDate distantFuture] to verify all of the given starks.
 @param    ignoreNoInternet_  If YES, will ignore the specialness
 of the -1009 "This computer is not connected to the internet"
 response from NSURLConnection, just record this as a normal
 error and keep on verifying additional bookmarks.
 @param    waitUntilDone  
 @param    error_p  
 @result   
*/
- (BOOL)verifyStarks:(NSArray*)starks
          verifyType:(VerifyType)verifyType
			   since:(NSDate*)since
       plusAllFailed:(BOOL)plusAllFailed
	ignoreNoInternet:(BOOL)ignoreNoInternet_
	   waitUntilDone:(BOOL)waitUntilDone
			 error_p:(NSError**)error_p ;

@end
