#import "Broker.h"
#import "BkmxAppDel.h"
#import "NSError+MyDomain.h"
#import "Stark.h"
#import "HeaderGetter.h"
#import "BkmxDoc+Actions.h"
#import "Bookshig.h"
#import "BkmxDocWinCon.h"
#import "NSString+LocalizeSSY.h"
#import "SSYLicenseMaintainer.h"
#import "InspectorController.h"
#import "SSYProgressView.h"
#import "NSError+InfoAccess.h"
#import "BkmxBasis.h"

#define VERIFY_IS_NOT_DONE 0
#define VERIFY_IS_DONE 1


@interface Broker ()

@property (retain) NSArray* bookmarksFlat ;
@property (retain) NSMutableArray* headerGetters ;
@property (retain) NSError* error ;
@property dispatch_semaphore_t doneSemaphore ;

@end


@implementation Broker

@synthesize brokenBookmarkHeaders ;
@synthesize brokenBookmarks ;
@synthesize autoFixedBookmarks ;
@synthesize bookmarksFlat ;
@synthesize headerGetters ;
@synthesize error ;

- (void)setThrottle:(NSTimer*)throttle {
	[throttle retain] ;
	if ([_throttle isValid]) {
		[_throttle invalidate] ;
	}
	[_throttle release] ;
	_throttle = throttle ;
}

- (NSTimer*)throttle {
	return _throttle ;
}

- (void)setWarnStallTimer:(NSTimer*)warnStallTimer {
	[warnStallTimer retain] ;
	if ([_warnStallTimer isValid]) {
		[_warnStallTimer invalidate] ;
	}
	[_warnStallTimer release] ;
	_warnStallTimer = warnStallTimer ;
}

- (NSTimer*)warnStallTimer {
	return _warnStallTimer ;
}

- (enum VerifyPhase)verifyPhase {
	return verifyPhase ;
}


- (id)initWithDocument:(id)document_ {
	if ((self = [super initWithDocument:document_]))
	{
		[self setAutoFixedBookmarks: [NSMutableArray array]] ;
		[self setHeaderGetters:[NSMutableArray array]] ;
		[self setThrottle:nil] ;
		[self setWarnStallTimer:nil] ;
		
		verifyPhase = kIdle ;
	}
	return self ;
}

- (void)clear {
	[[self brokenBookmarkHeaders] removeAllObjects] ;
	[[self brokenBookmarks] removeAllObjects] ;
	[[self autoFixedBookmarks] removeAllObjects] ;
}

- (void)dealloc {
	[bookmarksFlat release] ;
	[brokenBookmarkHeaders release];
	[brokenBookmarks release];
	[headerGetters release] ;
	[autoFixedBookmarks release];
	[error release] ;
	
    [super dealloc] ;
}

- (void)doFixAuto {
    if ([self autoFixedBookmarks]) {
        [[self autoFixedBookmarks] removeAllObjects] ;
    }
    else {
        NSMutableArray* array = [[NSMutableArray alloc] init] ;
        [self setAutoFixedBookmarks:array] ;
        [array release] ;
    }
    
    // Now, loop through all the broken bookmarks and, fix or unfix,
    for (Stark* aBrokenBookmark in [self brokenBookmarks]) {
        NSString *urlPrior, *urlSuggested, *urlCurrent ;
        if (
            ([aBrokenBookmark verifierDispositionValue] == BkmxFixDispoDoUpdate)
            ||
            ([aBrokenBookmark verifierDispositionValue] == BkmxFixDispoDoUpgradeInsecure)
            ) {
            urlSuggested = [aBrokenBookmark verifierSuggestedUrl] ;
            // The following condition ensures that we have not already fixed it
            // If so, we don't want to do it again because it is innefficient
            // and more importantly verifierPrioUrl would be overwritten and lost forever
            if (urlSuggested) {
                // Should fix it
                
                // Copy url  existing --> old
                urlPrior = [aBrokenBookmark url] ;
                if (urlPrior) {
                    [aBrokenBookmark setVerifierPriorUrl:urlPrior] ;
                }
                
                // Copy url  proposed --> existing
                [aBrokenBookmark setUrl:urlSuggested] ;
                
                // Remove the proposed url
                [aBrokenBookmark setVerifierSuggestedUrl:nil] ;
            }
            // Add the bookmark to the autoFixedBookmarks
            // (whether it was just now fixed, or fixed previously)
            [[self autoFixedBookmarks] addObject:aBrokenBookmark] ;
        }
        else {
            urlPrior = [aBrokenBookmark verifierPriorUrl] ;
            // If it was fixed previously, un-fix it
            // If it was fixed previously, this will return non-nil:
            if (urlPrior) {
                // Should unfix it
                
                // Copy url current --> proposed
                urlCurrent = [aBrokenBookmark url] ;
                if (urlCurrent) {
                    [aBrokenBookmark setVerifierSuggestedUrl:urlCurrent] ;
                }
                
                // Copy url old --> current
                [aBrokenBookmark setUrl:urlPrior] ;
                
                // Remove the prior url
                [aBrokenBookmark setVerifierPriorUrl:nil] ;
            }
        }
    }
}

- (void)restartThrottle {
	if
	(
			(iNext < nToVerify)
		&&
		(
				(verifyPhase == kFirstPass)
			||	(verifyPhase == kRetestingSome)
		)
	)
	{
			// (Note: We cannot change the interval of a throttle after it has been created, so we....

		// Get current value of period
		CGFloat period ;
		if (verifyPhase == kFirstPass)
		{
			period = MAX(currentThrottlePeriod, [[[NSUserDefaults standardUserDefaults] objectForKey:constKeyThrottlePeriod] doubleValue]) ;
		}
		else
			period = THROTTLE_PERIOD_FOR_SECOND_PASS ;

		// Create a new one
	 	[self setThrottle:[NSTimer scheduledTimerWithTimeInterval:period
														   target:self
														 selector:@selector(verifyMore:)
														 userInfo:nil
														  repeats:YES]] ;
		recentTimeoutRate = 0.0 ;
	}
	else
	{
			[self allDone:nil] ;		
	}
}

- (BOOL)retestSome {
    verifyPhase = kRetestingSome ;
    iNext = 0 ;
    nGot = 0 ;
   	nWaiting = 0 ;
   	doneSending = NO ;
   	
	nToVerify = [[self bookmarksFlat] count] ;
	
	[[[self document] bkmxDocWinCon] startVerifyProgressWithLocalizedVerb:[NSString stringWithFormat:
																			 @"%@ %li %@.  (%@)",
																			 [NSString localize:@"retesting"],
																			 (long)nToBeRetested,
																			 [NSString localize:@"nonresponders"],
																			 [NSString stringWithFormat:[NSString localize:@"nDone"], (long)nGot]
																			 ]
																	  limit:nToBeRetested
																	 broker:self] ;
	
	[self restartThrottle] ;
	
	return YES ;
}

- (void)verifyMore:(id)notUsed {
	NSInteger nMaxSimultaneousConnections = (verifyPhase == kFirstPass) ? nSimultaneous : N_SIMULTANEOUS_CONNECTION_ATTEMPTS_RETEST ;
	
	if (iNext >= nToVerify) {
        NSString* textWhatDoing ;
        NSString* waitingForReplies = [NSString localize:@"waitingForReplies"] ;
		if (verifyPhase == kFirstPass) {
            if ([self verifyType] == BrokerVerifyTypeRegularVerify) {
                textWhatDoing = [NSString stringWithFormat:
                                 @"%@ (%@)",
                                 waitingForReplies,
                                 @"first try"] ;
            }
            else {
                textWhatDoing = waitingForReplies ;
            }
            verifyPhase = kWaitingFirst ;
		}
		else if (verifyPhase == kRetestingSome) {
            if ([self verifyType] == BrokerVerifyTypeRegularVerify) {
                textWhatDoing = [NSString stringWithFormat:
                                 @"%@ (%@)",
                                 waitingForReplies,
                                 @"second try"] ;
            }
            else {
                textWhatDoing = waitingForReplies ;
            }
			verifyPhase = kWaitingSecond ;
		}
		else {
			NSLog(@"done sending when verifyPhase=%ld, should not happen", (long)verifyPhase) ;
			// Try to recover by pretending this was completion of second pass
			textWhatDoing = @"done while waiting?" ;
			verifyPhase = kWaitingSecond ;
		}
					
		// Restart the ticker to monitor when all replies have been received
		[[[self document] progressView] setIndeterminate:YES
                                       withLocalizedVerb:textWhatDoing
                                                priority:SSYProgressPriorityRegular] ;
		[[[self document] bkmxDocWinCon] updateThrottleView] ;
		[self setThrottle:[NSTimer scheduledTimerWithTimeInterval:1.0
													target:self
												  selector:@selector(monitorAllDone:)
												  userInfo:nil
												   repeats:YES]] ;
		doneSending = YES ;
	}
	else if (nWaiting < nMaxSimultaneousConnections) {			
		// Stop indicating stalled condition
		[[[[self document] bkmxDocWinCon] progressView] setIndeterminate:NO] ;
		[self setWarnStallTimer:nil] ;

		// Send another one
		if (verifyPhase == kFirstPass) {
			if (iNext==25) {
				// Most people should give up on Little Snitch after 25 bookmarks
				// Also, most people have more than 25 bookmarks.
                [SSYLicenseMaintainer maintainAfterMin:.05
                                                   max:.1] ;
			}
			[self verifyBookmark:[[self bookmarksFlat] objectAtIndex:iNext]] ;
			iNext++;
		}
		else if (verifyPhase == kRetestingSome) {
			// Loop through broken bookmark headers until we find the next one which needsRetest
			NSMutableDictionary* nextBrokenBookmarkHeader ;
			BOOL needsRetest = NO ;
			while ((needsRetest==NO) && (iNext < nToVerify) ) {
				nextBrokenBookmarkHeader = [[self brokenBookmarkHeaders] objectAtIndex:iNext] ;
				if ([nextBrokenBookmarkHeader objectForKey:constKeyVerifierNeedsRetest]) {
									needsRetest = YES ;
				}
				else {
					iNext++ ;
				}
			}
			
			if (needsRetest) {
				[self verifyBookmark:[nextBrokenBookmarkHeader objectForKey:constKeyVerifierStark]] ;
				[[self brokenBookmarkHeaders] removeObjectAtIndex:iNext] ;  // Removes the original entry reporting retest needed
				// Also, we do not increment iNext here, because the next one will now move down to index iNext.
				// Also, to match this non-increment, we must decrement the max limit:
				nToVerify-- ;
				[[[self document] bkmxDocWinCon] shortenVerifyVerbTo:[NSString stringWithFormat:
																	 @"%@ %li %@.  (%@)",
																	 [NSString localize:@"retesting"],
																	 (long)nToBeRetested,
																	 [NSString localize:@"nonresponders"],
																	 [NSString stringWithFormat:[NSString localize:@"nDone"], (long)nGot]
																	 ]] ;
			}
		}
		else {
			NSLog(@"Internal Error 549-1097") ;
		}
	}
	else
	{
		// Too many requests waiting for answer, do nothing
			
		if (![[self warnStallTimer] isValid])
		{
			[self setWarnStallTimer:[NSTimer scheduledTimerWithTimeInterval:2.5
																	 target:self
																   selector:@selector(warnStall)
																   userInfo:nil
																	repeats:NO]] ;
		}
	}
}

-(void)warnStall {
	[self setWarnStallTimer:nil] ;
	[[[self document] progressView] setIndeterminate:YES] ;
}

- (void)verifyBookmark:(id)bm {
	// Prior to BookMacster 1.7/1.6.8, I used this:
	// NSBundle* mainBundle = [NSBundle mainAppBundle] ;
	// NSString* appVersion = [mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"] ;
	// NSString* userAgent = [NSString stringWithFormat:@"%@/%@", [[BkmxBasis sharedBasis] appNameUnlocalized], appVersion] ;
	// But a user reported, and I confirmed, that this caused at least two sites, www.capitalone.com and www.facebook.com,
	// to respond with a 301 redirect to their mobile/miniaturized web pages, m.capitalone.com and m.facebook.com.
	// So, now I spoof Safari…
	NSString* userAgent = @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_1) AppleWebKit/534.48.3 (KHTML, like Gecko) Version/5.1 Safari/534.48.3" ;
	// I also tried something a bit simpler, "AppleWebKit (KHTML, like Gecko) Safari".  That fixed the problem
	// for Facebook but not for Capital One.
	
    // alloc]init a HeaderGetter to get this bookmark's headers from the internet.
	HeaderGetter* headerGetter = [[HeaderGetter alloc] initWithBookmark:bm
																  index:iNext
                                                             verifyType:[self verifyType]
														   sendResultTo:self
														   usingMessage:@selector(gotHeaders:)
																timeout:30.0  // Was 6 hours, via an ivar, prior to BookMacster 1.6.3
															  userAgent:userAgent] ;
	// Some other User-Agent strings (not used)
	//USER_AGENT_SAFARI @"Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en) AppleWebKit/418 (KHTML, like Gecko) Safari/417.9.3"
	//USER_AGENT_CAMINO  @"Mozilla/5.0 (Macintosh; U; Intel Mac OS X; chrome://navigator/locale/navigator.properties; rv:1.9a1) Gecko/20060608 Camino/1.2+"
	//USER_AGENT_FIREFOX @"Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.8.0.2) Gecko/20060308 Firefox/1.5.0.2"
	//USER_AGENT_CFNETWORK @"CFNetwork/129.16"
	[[self headerGetters] addObject:headerGetter] ;
	[headerGetter release] ;  // Bookdog did not release this due to suspected crashing bugs in earlier Mac OS versions' NSURLConnection
	
	nWaiting++ ;
	[[[self document] bkmxDocWinCon] setVerifyNWaiting:nWaiting] ;
    [[[self document] bkmxDocWinCon] appendToVerifyLog:[bm nameNoNil]] ;
}

-(void)allDone:(id)allDoneInfo {
	/* We have now made a list of broken bookmarks, with a trouble description
     for each one.  But we have not added these keys to bookmarks tree. */
   
	if ((verifyPhase == kWaitingFirst) && ([self verifyType] == BrokerVerifyTypeRegularVerify)) {
		[self retestSome] ;
	}
	else {
        [self finishVerifyWithInfo:nil] ;
	}
}

-(NSDictionary*)monitorAllDone:(id)allDoneInfo {
	if ( (nWaiting < 1) && (doneSending) )
	{
		// Got all of the stragglers
		[self setThrottle:nil] ;
		[self allDone:nil] ;
	}

	return allDoneInfo ;
}

// Will back off if TIMED_OUT_TOLERANCE of the last TIMED_OUT_MEMORY timed out
#define TIMED_OUT_MEMORY 5
#define TIMED_OUT_MEMORY_GAIN  (1 - 1/(CGFloat)TIMED_OUT_MEMORY)
#define TIMED_OUT_INPUT_GAIN    1/(CGFloat)TIMED_OUT_MEMORY
#define TIMED_OUT_RATE_TOO_HIGH .5
#define TIMED_OUT_RATE_TOO_LOW .05
#define BACKOFF_FACTOR 2.5
#define SPEEDUP_FACTOR 2.0
#define THROTTLE_PERIOD_MAX 1.0
// Note: THROTTLE_PERIOD_MIN is instead [[[NSUserDefaults standardUserDefaults] objectForKey:KEY_THROTTLE_PERIOD] floatValue].

- (BOOL)attemptRecoveryFromError:(NSError *)error_ 
					 recoveryOption:(NSUInteger)recoveryOption {
	switch (recoveryOption) {
		case NSAlertThirdButtonReturn:
			// Ignore all
			ignoreNoInternet = YES ;
		case NSAlertFirstButtonReturn:
			// Ignore this one; let it be retested
			break ;
		case NSAlertSecondButtonReturn:
			// Cancel - Abort All
			failed = YES ;
			// If we don't abort, will get NSArray beyond bounds exceptions later.
			[self abortLongTask] ;
	}
	
	return !failed ;
}

- (void)gotHeaders:(NSMutableDictionary*)headers {
	HeaderGetter* hg = [headers objectForKey:constKeyVerifierHeaderGetter] ;
	
	[hg abortSession] ; // just to be sure.  This should be not necessary!
	
	[[self headerGetters] removeObject:hg] ;

	[headers removeObjectForKey:constKeyVerifierHeaderGetter] ; // We remove this key because it will cause trouble later
	// if this is a "kShow" bookmark, because this key will be added to the bookmark when we
	// "addTroubleKeysToBookmarks".  Then, later when we writeToFileNoQuestionsAsked, it will cause an error since it does not respond to copyWithZone:
	// Also, this is needed to avoid memory leak?
	
	if (verifyPhase == kRetestingSome) {
		[[[self document] bkmxDocWinCon] shortenVerifyVerbTo:[NSString stringWithFormat:
															 @"%@ %li %@.  (%@)",
															 [NSString localize:@"retesting"],
															 (long)nToBeRetested,
															 [NSString localize:@"nonresponders"],
															 [NSString stringWithFormat:[NSString localize:@"nDone"], (long)nGot]
															 ]] ;
	}

	nGot++ ;
	[[[[self document] bkmxDocWinCon] progressView] setDoubleValue:nGot];

	nWaiting-- ;
	[[[self document] bkmxDocWinCon] setVerifyNWaiting:nWaiting] ;
	NSString* name = [[headers objectForKey:constKeyVerifierStark] nameNoNil] ;
    [[[self document] bkmxDocWinCon] removeFromVerifyLog:name] ;

	NSNumber* oCode = [headers objectForKey:constKeyVerifierCode] ;
	NSInteger code = [oCode integerValue] ;
	
	if (!failed)
	{
		// Process the data in the header
		if (ignoreNoInternet) {
			[headers removeObjectForKey:constKeyVerifierNeedsRetest] ;
		}
		else if (([headers objectForKey:constKeyVerifierNeedsRetest])  && (verifyPhase < kRetestingSome)) {
			nToBeRetested++ ;
		}
		
		BkmxFixDispo fd = (BkmxFixDispo)[[headers objectForKey:constKeyVerifierDisposition] integerValue] ;
		
		/* Note: The header, which is was contstructed by either of the HeaderGetter delegate methods
		 connection:didReceiveResponse: or connection:didFailWithError:, will contain some of the
		 keys from the family constKeyVerifierXxxxx. */
		
		[[self brokenBookmarkHeaders] addObject:headers] ;
		
		switch (fd)
		{
			case BkmxFixDispoDoUpdate:
			case BkmxFixDispoLeaveBroken:
			case BkmxFixDispoToBeDetermined:
				if (verifyPhase == kFirstPass)
					nBroken++ ;
				break ;
			default: // BkmxFixDispoLeaveAsIs
				// do not add to nBroken
				break;
		}		

		// See if throttle needs to be adjusted and if so do it.
		
		recentTimeoutRate = recentTimeoutRate * TIMED_OUT_MEMORY_GAIN + ((code == -1001) ? 1 : 0) * TIMED_OUT_INPUT_GAIN ;
		nReceivedSinceLastThrottleChange++ ;
		// NSLog(@"timedOut=%d rcvd %d/%d timeoutRate=%f", (code == -1001), nReceivedSinceLastThrottleChange, nWaitingWhenBackedOff, recentTimeoutRate) ;
		if (nReceivedSinceLastThrottleChange > nWaitingWhenBackedOff)
		{
			CGFloat newThrottlePeriod = currentThrottlePeriod ;
			if (recentTimeoutRate > TIMED_OUT_RATE_TOO_HIGH)
			{
				newThrottlePeriod = MIN(THROTTLE_PERIOD_MAX, currentThrottlePeriod*BACKOFF_FACTOR) ;
				nSimultaneous = 6 ;
				connectionsHaveBeenDroppedBefore = YES ;
			}
			else if (recentTimeoutRate < TIMED_OUT_RATE_TOO_LOW)
			{
				newThrottlePeriod = MAX(currentThrottlePeriod/SPEEDUP_FACTOR, [[[NSUserDefaults standardUserDefaults] objectForKey:constKeyThrottlePeriod] doubleValue]) ;
				if (connectionsHaveBeenDroppedBefore) {
					nSimultaneous = 8 ;
				}
			}
			
			if (newThrottlePeriod != currentThrottlePeriod) {
				NSLog(@"%@ from %0.1f to %0.1f per second.", (newThrottlePeriod > currentThrottlePeriod) ? @"Slowing" : @"Speeding", 1/currentThrottlePeriod, 1/newThrottlePeriod) ;
				nWaitingWhenBackedOff = nWaiting ;
				nReceivedSinceLastThrottleChange = 0 ;
				currentThrottlePeriod = newThrottlePeriod ;
				[self restartThrottle] ;
			}
		}
			
		// Handle if error was "not connected to the internet"
		
		if ((code == -1009) && !ignoreNoInternet) {
			Stark* stark = [headers objectForKey:constKeyVerifierStark] ;
			NSString* msg = [NSString stringWithFormat:
							 @"%@\n\n%@",
							 [NSString localize:@"080_verifyFailedInternet"],
							 [stark url]] ;
			NSError* error_ = SSYMakeError(20992, msg) ;
			error_ = [error_ errorByAddingUserInfoObject:stark
												  forKey:@"Bookmark involved"] ;
			
			if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
				NSArray* recoveryOptions = [NSArray arrayWithObjects:
											[NSString localize:@"ignore"],
											[NSString localize:@"cancel"],
											[NSString localizeFormat:
											 @"ignoreThing",
											 [@"all" capitalizedString]],
											nil] ;
				error_ = [error_ errorByAddingLocalizedRecoveryOptions:recoveryOptions] ;
				error_ = [error_ errorByAddingRecoveryAttempter:self] ;
				[self setError:error_] ;
				[SSYAlert alertError:[self error]] ;
			}					
			else {
				[self setError:error_] ;

				// Task is running unattended.  We've already set the error
				// Abort the task immediately.
				[self abortLongTask] ;
			}

		}
	}		
}

- (void)abortLongTask {
	NSUInteger nHG = [[self headerGetters] count] ;
	NSInteger i ;
	
	for (i=nHG-1; i>=0; i--)
	{
		HeaderGetter* hg = [[self headerGetters] objectAtIndex:i] ;
        [hg abortSession] ;
		[[self headerGetters] removeObject:hg] ;
	}
    
	[self setThrottle:nil] ;
	nToVerify = 0 ; // This keeps any more from being sent until -verifyStarks::::: is run again.
	//[_tw markAsCancelled] ;  // probably not needed
    NSMutableDictionary * summaryMessages = [NSMutableDictionary dictionaryWithObjectsAndKeys:
    	@"1", @"wasCancelled",
    	nil ] ;
	[self finishVerifyWithInfo:summaryMessages] ;
}

-(void)finishVerifyWithInfo:(id)userInfo {
	// Note: This method runs in the primary thread
	// It is normally called from verifyStarks:::::, when the verifyAllTask ends,
	// but also will be called from abortLongTask:
	// if the user cancels or if an error occurs.

	NSInteger i ;
	
	if ([[self document] verifyInProgress]) {
		// The above is because: If the verify has already been cancelled,
		// we want to ignore this call when the last straggler has arrived!

		verifyPhase = kIdle ;
		[[[self document] bkmxDocWinCon] updateThrottleView] ;

		[[[self document] progressView] setIndeterminate:YES
                                     withLocalizableVerb:@"mergingResults"
                                                priority:SSYProgressPriorityRegular] ;

		NSUInteger nBB = [[self brokenBookmarkHeaders] count] ;
        _nSecurifySucceeded = 0 ;
        _nSecurifyFailed = 0 ;
        
        NSRange firstFour = NSMakeRange(0, 4) ;
        for (i=nBB-1; i>=0; i--) {
			/* The array brokenBookmarkHeaders now contains "headers": dictionaries of "trouble keys"
			which were generated during verification.  One of the trouble keys is the bookmark itself.
			The task here is to create, from each header, a (Stark*) bookmark which is the bookmark itself,
			with the rest of the trouble keys added to it, and then add all these bookmarks to
			the array brokenBookmarks. */
			
 			NSDictionary* headers = [[self brokenBookmarkHeaders] objectAtIndex:i] ;
			
			// Get the bookmark (stark) out of the headers
			Stark* stark = [headers objectForKey:constKeyVerifierStark] ;
            // The following qualification was added in BookMacster 1.15
            if ([stark isAvailable]) {
                NSNumber* code = [headers objectForKey:constKeyVerifierCode] ;
                BOOL securifySucceeded = NO ;
                if ([self verifyType] == BrokerVerifyTypeSecurifySecondPass) {
                    if ([code integerValue] == 200) {
                        securifySucceeded = YES ;
                        _nSecurifySucceeded++ ;
                    }
                    else {
                        _nSecurifyFailed++ ;
                    }
                }

                BOOL shouldUpdateForReal = (
                                            ([self verifyType] != BrokerVerifyTypeSecurifySecondPass)
                                            ||
                                            securifySucceeded) ;
                if (shouldUpdateForReal) {
                    NSString* suggestedUrl = [headers objectForKey:constKeyVerifierSuggestedUrl] ;

                    if (securifySucceeded) {
                        /* This branch is for Upgrade Insecure Bookmarks. */
                        [stark setVerifierPriorUrl:[stark url]] ;
                        NSMutableString* securifiedUrl = [NSMutableString stringWithString:[stark url]] ;
                        [securifiedUrl replaceCharactersInRange:firstFour
                                                     withString:@"https"] ;
                        [stark setVerifierSuggestedUrl:securifiedUrl] ;
                        [stark setVerifierDispositionValue:BkmxFixDispoDoUpgradeInsecure] ;
                    }
                    else {
                        /* This branch is for regular Verify operations. */
                        [stark setVerifierDisposition:[headers objectForKey:constKeyVerifierDisposition]] ;
                        
                        /* Test the suggested url before setting it, because 95%
                         of sites returning a 200 also have a
                         verifierSuggestedUrl to the same original url. We don't
                         want to show our users a "suggested" url which is the
                         same as the original url. */
                        if (![[stark url] isEqualToString:suggestedUrl]) {
                            [stark setVerifierSuggestedUrl:suggestedUrl] ;
                        }
                    }

                    // Copy the remaining interesting keys from the headers to the stark
                    [stark setVerifierCode:code] ;
                    [stark setVerifierAdviceArray:[headers objectForKey:constKeyVerifierAdviceArray]] ;
                    [stark setVerifierNSErrorDomain:[headers objectForKey:constKeyVerifierNsErrorDomain]] ;
                    [stark setVerifierPriorUrl:[headers objectForKey:constKeyVerifierPriorUrl]] ;
                    [stark setVerifierReason:[headers objectForKey:constKeyVerifierReason]] ;
                    [stark setVerifierSubtype302:[headers objectForKey:constKeyVerifierSubtype302]] ;
                    [stark setVerifierLastDate:[NSDate date]] ;
                    [stark setVerifierUrl:[stark url]] ;
                    /* Note that we do not copy constKeyVerifierNeedsRetest or
                     constKeyVerifierHeaderGetter since we don't need these
                     values any more. */
                }

                // To make sure bookmark was not deleted (=orphaned) by user
                // since the verification started, we only add items that still have a parent
                if ([stark parent]) {  
                    [[self brokenBookmarks] addObject:stark] ;
                }
            }
        }

		[[NSURLCache sharedURLCache] removeAllCachedResponses] ;

		[[[self document] bkmxDocWinCon] verifyIsDone] ;

		[[self document] setVerifyInProgress:NO] ;
		
		[[[self document] progressView] clearAll] ;

		[[self document] updateViews:nil] ;  // Is this needed?
		
        [[self document] postVerifyDone] ;
        
        if ([self doneSemaphore] != NULL) {
            dispatch_semaphore_signal([self doneSemaphore]) ;
        }
		
		/* Make all the results' views obvious to the user, unless this is
        only the first of two passes. */
        if ([self verifyType] != BrokerVerifyTypeSecurifyFirstPass) {
            [[[self document] bkmxDocWinCon] revealTabViewVerify] ;
        }
	}
}

- (BOOL)verifyStarks:(NSArray*)starks
          verifyType:(VerifyType)verifyType
	ignoreNoInternet:(BOOL)ignoreNoInternet_
	   waitUntilDone:(BOOL)waitUntilDone_
			 error_p:(NSError**)error_p {
    failed = NO ;
	ignoreNoInternet = NO ;
    verifyPhase = kFirstPass ;
    iNext = 0 ;
    nGot = 0 ;
   	nWaiting = 0 ;
   	nToBeRetested = 0 ;
   	doneSending = NO ;
   	nBroken = 0 ;
	nSimultaneous = N_SIMULTANEOUS_CONNECTION_ATTEMPTS_1stPASS ;
	waitUntilDone = waitUntilDone_ ;
	[self setError:nil] ;
	
	// Start out at the user's default
	currentThrottlePeriod = [[[NSUserDefaults standardUserDefaults] objectForKey:constKeyThrottlePeriod] doubleValue] ;
	
	[self setBookmarksFlat:starks] ;
	
	NSMutableArray* brokenBookmarkHeaders_ = [[NSMutableArray alloc] init] ;
	[self setBrokenBookmarkHeaders:brokenBookmarkHeaders_] ;
	[brokenBookmarkHeaders_ release] ;
	
	NSMutableArray* brokenBookmarks_ = [[NSMutableArray alloc] init] ;
	[self setBrokenBookmarks:brokenBookmarks_] ;
	[brokenBookmarks_ release] ;
	
    nToVerify = [[self bookmarksFlat] count] ;    
	[[self document] tellVerifyStarted] ;
    NSString* verb ;
    switch (verifyType) {
        case BrokerVerifyTypeRegularVerify:
            verb = [NSString localize:@"080_verifying"] ;
            break ;
        case BrokerVerifyTypeSecurifyFirstPass:
            verb = @"Verifying https:// responses (1st of 2 Passes)" ;
            break ;
        case BrokerVerifyTypeSecurifySecondPass:
            verb = @"Verifying https:// responses (2nd of 2 Passes)" ;
            break ;
    }
	[[[self document] bkmxDocWinCon] startVerifyProgressWithLocalizedVerb:verb
																   limit:nToVerify
																  broker:self] ;
	
	// Although this is not obvious, -restartThrottle triggers the heavy
	// lifting in this class, because it sets the 'throttle' timer which
	// triggers -verifyMore:, which invokes -verifyBookmark:, which creates
	// the HeaderGetter, which asynchronously invokes -gotHeaders:.
	// Also, -restartThrottle eventually invokes -allDone:, which invokes
	// -finishVerifyWithInfo:, which must run on the main thread since this
	// is the method which changes attributes of the bookmarks in the data
	// model to reflect the verification, and it is part of our design
	// that Core Data access always be on the main thread.
	//
	// Thus, we need -restartThrottle to run on the main thread.
	// Note that in Main app, we will already be on the main thread, but in
	// BkmxAgent, we will not be on the main thread.  
	[self performSelectorOnMainThread:@selector(restartThrottle)
						   withObject:nil
						waitUntilDone:NO] ;
	
	[[[self document] bkmxDocWinCon] updateThrottleView] ;
	
	BOOL returnValue = YES ;
    
    if (waitUntilDone_) {
        if (nToVerify > 0) {
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0) ;
            [self setDoneSemaphore:semaphore] ;
            double timeooutSeconds = 6 * 60 * 60 ;  // 6 hours
            int64_t timeoutNanoseconds = timeooutSeconds * 1e9 ;
            dispatch_time_t timeout = dispatch_time(
                                                    DISPATCH_TIME_NOW,
                                                    timeoutNanoseconds) ;
            // Will block here until work is done, or timeout
            long result = dispatch_semaphore_wait(
                                                  [self doneSemaphore],
                                                  timeout) ;
            if (result != 0) {
                // timed out
                NSString* msg = [NSString stringWithFormat:@"Time to verify exceeded limit of %f seconds.", timeooutSeconds] ;
                NSError* error_ = SSYMakeError(28081, msg) ;
                [self setError:error_] ;
            }
            dispatch_release(semaphore) ;
            [self setDoneSemaphore:NULL] ;
        }
        
        if ([self error] && error_p) {
            *error_p = [self error] ;
        }
        
        returnValue = ([self error] == nil) ;
    }

    return returnValue ;
}

- (BOOL)verifyStarks:(NSArray*)starks
          verifyType:(VerifyType)verifyType
			   since:(NSDate*)since
       plusAllFailed:(BOOL)plusAllFailed
    ignoreNoInternet:(BOOL)ignoreNoInternet_
	   waitUntilDone:(BOOL)waitUntilDone_
			 error_p:(NSError**)error_p {
    NSString* msg ;
    switch (verifyType) {
        case BrokerVerifyTypeRegularVerify:
            msg = @"Begin Regular Verify" ;
            break ;
        case BrokerVerifyTypeSecurifyFirstPass:
            msg = @"Begin Securify First Pass" ;
            break ;
        case BrokerVerifyTypeSecurifySecondPass:
            msg = @"Begin Securify Second Pass" ;
            break ;
    }
    [[BkmxBasis sharedBasis] logFormat:msg] ;
	NSMutableArray* starksToVerify = [[NSMutableArray alloc] init] ;
	for (Stark* stark in starks) {
        NSDate* __block lastVerified = nil ;

        /* Core Data access ahead - must use main thread, but carefully becase
         dispatch_sync() to the main queue will deadlock if we're already on
         the main queue. */
        if ([NSThread currentThread].isMainThread) {
            lastVerified = [stark verifierLastDate] ;
            [lastVerified retain] ;
        }
        else {
            dispatch_queue_t mainQueue = dispatch_get_main_queue() ;
            dispatch_sync(mainQueue, ^{
                lastVerified = [stark verifierLastDate] ;
                [lastVerified retain] ;
            }) ;
        }

        if (!lastVerified) {
			[starksToVerify addObject:stark] ;
		}
		else if ([lastVerified compare:since] == NSOrderedAscending) {
			[starksToVerify addObject:stark] ;			
		}
        else if (plusAllFailed && ([[stark verifierCode] integerValue] != 200)) {
            [starksToVerify addObject:stark] ;
        }
        
        [lastVerified release] ;
	}
    NSString* logMessage = [[NSString alloc] initWithFormat:
                            @"Verifying %tu/%tu bookmarks",
                            [starksToVerify count],
                            [starks count]] ;
    [[BkmxBasis sharedBasis] logFormat:logMessage] ;
    [logMessage release] ;

	NSArray* starksToVerifyCopy = [NSArray arrayWithArray:starksToVerify] ;
	[starksToVerify release] ;
    
    [self setVerifyType:verifyType] ;
	
	return [self verifyStarks:starksToVerifyCopy
                   verifyType:verifyType
			 ignoreNoInternet:ignoreNoInternet_
				waitUntilDone:waitUntilDone_
					  error_p:error_p] ;
}

@end

/*
 Note NoverloadVer.  The user was getting information overload with the
 Inspector panel popping open, I think.  These things are also done in the
 -[FindViewController findStarksThatAreXxx] methods which are invoked when
 the user clicks one of the three magnifying glass buttons in the report.
 I decided that was better, to leave it there and deleted lines of code
 in -[BkmxDocWinCon revealTabViewVerify and in
 -[Broker finishVerifyWithInfo:].
 */


/*
The following example shows how you could use an NSLock object to coordinate the updating of a visual display, whose data is being calculated by several threads. If the thread cannot acquire the lock immediately, it simply continues its calculations until it can acquire the lock and update the display.

BOOL moreToDo = YES;

NSLock *theLock = [[NSLock alloc] init];

...

while (moreToDo) {

	[self doSomeCalcs] ;

    if ([theLock tryLock]) {

		[self updateSharedDisplay]
	
        [theLock unlock];

    }

}


> Hi folks,
>
> if I run a method in a thread of its own, and that
> method calls another function or method that could
> block indefinately, is there a way to force the
> thread to exit after some defined amount of time?
>
> For example:
>
> - mainThreadDetacherMethod {
>     // Run in main thread.
>     [NSTimer scheduledTimer...];
>     [NSThread detachNewThreadSelector:@selector(runner:)...];
> }
>
> - (void)runner:arg {
>     // Run in another thread.
>     NSAutoreleasePool *pool = [[NSAutoreleasePool allc] init];
>     [self setRunningThread:[NSThread currentThread]];
>     while (1) {
>         // do nothing.
>     }
>     [pool release];
> }


Don't do that. This is evil. You should never block indefinitely in  
a thread. Use APIs with timeout, and loop if you need.

To exit a thread, throw an exception from within it. Catch this  
exception at the lowest level of your thread and fall through.

In compute code, call repetively a method that will check a  
thread-private flag to see if someone requested the thread to exit.

To stop a thread, set this flag from another thread.

This may look ugly (and it really is), but it is the only way I know  
to avoid loosing resources when arbitrary stopping a thread.

Cheers,

--fred

Just another note on this, most of which was covered by Fred Stark's reply.

  If you really have something that could block indefinitely (say, socket I/O), then you can set a flag saying that the thread should exit and close the file descriptor it is using.  This will cause an error code to be returned and you can then check the flag (or maybe you don't need a flag if this was the only work the thread was to perform).

-tim
*/
