#import <Bkmxwork/Bkmxwork-Swift.h>
#import "ExtoreWebFlat.h"
#import "NSError+DecodeCodes.h"
#import "NSError+Recovery.h"
#import "NSError+MyDomain.h"
#import "NSError+SSYInfo.h"
#import "Stark.h"
#import "Starker.h"
#import "SSYProgressView.h"
#import "NSString+LocalizeSSY.h"
#import "Client.h"
#import "OperationExport.h"
#import "BkmxBasis+Strings.h"
#import "SSYLabelledTextField.h"
#import "BkmxDoc.h"
#import "SSWebBrowsing.h"
#import "SSYSynchronousHttp.h"
#import "Ixporter.h"
#import "NSInvocation+Quick.h"
#import "Macster.h"
#import "NSError+InfoAccess.h"
#import "NSError+MoreDescriptions.h"
#import "Client+SpecialOptions.h"
#import "NSString+TimeIntervals.h"
#import "NSDate+Components.h"
#import "SSYOperationQueue.h"
#import "SSYWrappingCheckbox.h"
#import "SSYMOCManager.h"
#import "WebAuthorizor.h"

#if USE_LOCAL_DOT_SQL_CACHES_WHEN_IMPORTING_WEB_EXTORES
#import "NSError+InfoAccess.h"
#endif

NSString* const constKeyPendingAdditions = @"pendingAdditions" ;
NSString* const constKeyPendingDeletions = @"pendingDeletions" ;
NSString* const constKeyFailedAdditions = @"failedAdditions" ;
NSString* const constKeyFailedDeletions = @"failedDeletions" ;
NSString* const constKeyMassUploads = @"massUploads" ;
NSString* const constKeyNDone = @"nDone" ;
NSString* const constKeyNTasks = @"nTasks" ;
NSString* const constHttpBackoff = @"httpBackoff" ;

NSString* const BkmxExtoreWebFlatErrorDomain = @"BkmxExtoreWebFlatErrorDomain" ;
NSString* const BkmxExtoreWebFlatErrorItemSummary = @"Item Summary" ;

@interface ExtoreWebFlat () 

@property (copy) NSDate* requestTimerFireDate ;
@property (retain) NSDictionary* requestTimerUserInfo ;

@end


@implementation ExtoreWebFlat

+ (BkmxIxportTolerance)toleranceForIxportStyle:(NSInteger)ixportStyle {
	BkmxIxportTolerance tolerance = BkmxIxportToleranceAllowsNone ;
	if (ixportStyle == 1) {
		tolerance = BkmxIxportToleranceAllowsReading + BkmxIxportToleranceAllowsWriting ;
	}
	
	return tolerance ;
}

+ (BOOL)parentSharype:(Sharype)parentSharype
  canHaveChildSharype:(Sharype)childSharype {
	BOOL answer ;
	answer =
	((childSharype & (SharypeCoarseLeaf)) > 0)
	&&
	((parentSharype & (SharypeGeneralContainer)) > 0) ;
	
	return answer ;
}

+ (PathRelativeTo)fileParentPathRelativeTo {
	return PathRelativeToNone ;
}

+ (NSString*)fileParentRelativePath {
	return @"" ;
}

+ (NSArray*)trySubhosts {
	return [NSArray arrayWithObjects:
			@"www", // for Google Bookmarks
			@"my", // for Pinboard, maybe.  Not sure.
			@"secure", // for Diigo
			nil] ;
}

+ (NSArray*)defaultSpecialDoubles {
    return @[@1.0, @5.0, @1.1];
}

+ (NSString*)displayedSuffixForProfileName:(NSString*)profileName
                                  homePath:(NSString*)homePath {
    NSString* answer ;
    if (profileName) {
        answer = [NSString stringWithFormat:@" (%@)", profileName] ;
    }
    else {
        answer = @"" ;
    }
    return answer ;
}

@synthesize requestTimerFireDate = m_requestTimerFireDate ;
@synthesize requestTimerUserInfo = m_requestTimerUserInfo ;

- (NSTimeInterval)requestsAllMinimumTimeInterval {
#ifdef LOCAL_FILE_PATH_TO_OVERRIDE_EXTOREWEBFLAT_DOWNLOAD
	return 0.0 ;
#else
	return 60.0 ;
#endif
}

- (NSTimer*)requestTimer {
	return m_requestTimer ;
}

- (NSSet*)throttledErrorCodes {
	return nil ;
}

- (BOOL)isThrottledError:(NSError*)error {
	if (![error involvesOneOfCodesInSet:[self throttledErrorCodes]
								 domain:nil]) {
		return NO ;
	}
	
	NSString* msg = [NSString stringWithFormat:
					 @"Sorry, you've been throttled by %@.  HTTP Status Code = %ld",
					 [[self clientoid] displayName],
					 (long)[error mostUnderlyingErrorCode]] ;
	[[BkmxBasis sharedBasis] logFormat:msg] ;
	
	return YES ;
}

- (IBAction)cancel:(id)sender {
	NSError* error_ = SSYMakeError(constBkmxErrorUserCancelled, [[BkmxBasis sharedBasis] stringCancelledOperation]) ;
	
	// The following is in case something weird happened, and there already is a [self error].
	// More likely, [self error] will be nil and the following will be a noop.
	error_ = [error_ errorByAddingUnderlyingError:[self error]] ;
	
	[self setError:error_] ;
	
	// Added in BookMacster 1.7/1.6.8, because the output timer set when
	// we are throttled by Diigo in -scheduleRetryAtDate:: can take an hour
	// or more to fire, and we need our -cancel: operation to be more 
	// responsive than that.
    [[self requestTimer] fire] ;
	// Firing the timer will invoke -doNextOutputInfo: immediately,
	// but -doNextOutputInfo: will immediately goto end when it
	// sees that we have setError: to non-nil.
}

- (void)setRequestTimer:(NSTimer*)timer {
    /* Starting with BookMacster 1.21.?, and until BookMacster 1.22.1, I did
     [m_requestTimer invalidate] here, to invalidate the old timer.  That
     caused a couple of crashes when m_requestTimer had been deallocced,
     (1) during an export to Diigo, when the downloading was done and the
     uploading began and (2) if computer was slept during the "additions" or
     "deletions" writing after computer woke from sleep, due to the mechanism
     I have in here for sleep/wake.  These were really hairy, and finally I
     decided to just remove it.  I thin it was only in there as a "good
     programming practice", but turned out to be bad in this case because
     m_requestTimer is not retained. */

	m_requestTimer = timer ;
}

- (void)scheduleBackedOffOutputInfo:(NSMutableDictionary*)info {
	NSNumber* oldBackoff = [info objectForKey:constHttpBackoff] ;
	NSNumber* newBackoff = [NSNumber numberWithDouble:([oldBackoff doubleValue] * [[self client] httpRateBackoff])] ;
	NSTimeInterval waitInterval = [[self client] httpRateRest] ;
	NSString* humanReadableWaitInterval = [NSString stringWithUnitsForTimeInterval:waitInterval
																		  longForm:YES] ;
	NSString* msg = [NSString stringWithFormat:
					 @"Will wait %@, then resume with interval %5.3f",
					 humanReadableWaitInterval,
					 [newBackoff doubleValue] * [[self client] httpRateInitial]] ;
	[[BkmxBasis sharedBasis] logFormat:msg] ;
	
	// Note that, because -[NSDictionary objectForKey:] does not retain+autorelease
	// its return value, the retainCount of oldBackoff here is 1.  It is going
	// to be deallocced when we replace it in the dictionary right now…
	[info setObject:newBackoff
			 forKey:constHttpBackoff] ;
	NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:waitInterval
													  target:self
													selector:@selector(doNextOutputInfo:)
													userInfo:info
													 repeats:NO] ;
	[self setRequestTimer:timer] ;
	NSString* progressText = [NSString stringWithFormat:
							  @"%@ (%@)",
							  [NSString localizeFormat:
							   @"waitingFor%0",
							   [NSString localize:@"server"]],
							  humanReadableWaitInterval] ;
	
	SSYProgressView* progressView = [[self bkmxDoc] progressView] ;
	[progressView setVerb:progressText
				   resize:NO] ;
}

- (void)scheduleRetryAtDate:(NSDate*)retryDate
					   info:(NSMutableDictionary*)info {
	NSString* msg = [NSString stringWithFormat:
					 @"Throttled by %@ until %@:%@.  Waiting.",
					 [[self class] ownerAppDisplayName],
					 [retryDate hourString],
					 [retryDate minuteString]] ;
	[[BkmxBasis sharedBasis] logFormat:msg] ;
	
	[self setARequestTimerToFireAtDate:retryDate
							  userInfo:info] ;
	
	SSYProgressView* progressView = [[self bkmxDoc] progressView] ;
	[progressView setVerb:msg
				   resize:NO] ;
}

- (void)scheduleRegularOutputInfo:(NSMutableDictionary*)info {
	NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:([[info objectForKey:constHttpBackoff] doubleValue] * [[self client] httpRateInitial])
													  target:self
													selector:@selector(doNextOutputInfo:)
													userInfo:info
													 repeats:NO] ;
	[self setRequestTimer:timer] ;
}

- (BOOL)deleteAtServerStark:(Stark*)stark
					error_p:(NSError**)error_p {
	NSString* msg = [NSString stringWithFormat:
					 @"Forgot to override %s in %@",
					 __PRETTY_FUNCTION__,
					 self] ;
	if (error_p) {
		*error_p = SSYMakeError(982348, msg) ;
	}
	
	return NO ;
}

- (BOOL)addAtServerStark:(Stark*)stark
				 error_p:(NSError**)error_p {
	NSString* msg = [NSString stringWithFormat:
					 @"Forgot to override %s in %@",
					 __PRETTY_FUNCTION__,
					 self] ;
	if (error_p) {
		*error_p = SSYMakeError(292349, msg) ;
	}
	
	return NO ;
}

- (void)doNextOutputInfo:(NSTimer*)timer {
	NSMutableDictionary* info = [[[timer userInfo] retain] autorelease] ;
	[self setRequestTimer:nil] ; //  Important, since timer will be autoreleased now.
	BOOL allDone = NO ; // We'll set to YES if we find otherwise
	NSMutableSet* pendingAdditions = [info objectForKey:constKeyPendingAdditions] ;
	NSMutableSet* pendingDeletions = [info objectForKey:constKeyPendingDeletions] ;
	NSInteger nDone = [[info objectForKey:constKeyNDone] integerValue] ;
	NSInteger nTasks = [[info objectForKey:constKeyNTasks] integerValue] ;
	NSError* error_ = nil ;
	
	// The following is in case user cancelled (by invoking super's -cancel: action)
	// We did not do this at the very top of this method since some of the
	// variable initializations above may be needed in the goto end:
	if ([self error]) {
		goto end ;
	}
	
	SSYProgressView* progressView = [[self bkmxDoc] progressView] ;
	
	// Recall that pendingDeletions are in the localMoc.
	Stark* localStark ;
	if ((localStark = [pendingDeletions anyObject])) {
		// There are still deletion(s) left to do, so do a deletion
		// Announce it
		NSString* progressGuts = [NSString stringWithFormat:
								  @"(%ld/%ld) %@",
								  (long)nDone,
								  (long)nTasks,
								  [localStark name]] ;
		NSString* progressText = [NSString localizeFormat:@"deletingAt%0%1",
								  [self ownerAppDisplayName],
								  progressGuts] ;
		
		[progressView setDoubleValue:(nDone+1)] ;
		// +1 because it looks better to start at 1% and finish at 100%
		// rather than to start at 0% and finish at 99%
		[progressView setVerb:progressText
					   resize:NO] ;
		
		BOOL ok = [self deleteAtServerStark:localStark
									error_p:&error_] ;
		if (!ok) {
			NSDate* retryDate = [[error_ userInfo] objectForKey:SSYRetryDateErrorKey] ;
			if ([self isThrottledError:error_]) {
				[self scheduleBackedOffOutputInfo:info] ;
				error_ = nil ;
				[self setError:nil] ;
				return ;
				// Note: -scheduleBackedOffOutputInfo: is in lieu of scheduleRegularOutputInfo:.
			}
			else if (retryDate != nil) {
				// Throttled by Diigo, usually for about an hour
				[self scheduleRetryAtDate:retryDate
									 info:info] ;
				error_ = nil ;
				[self setError:nil] ;
				return ;
			}
			else {
				[self handleHttpError:error_
							requested:nil
								stark:localStark
						 receivedData:nil
					   prettyFunction:__PRETTY_FUNCTION__] ;
				error_ = [error_ errorByAddingUserInfoObject:[NSString stringWithFormat:@"%ld/%ld", (long)nDone, (long)[progressView maxValue]]
													  forKey:@"Current Progress"] ;
				goto end ;
			}
		}
		
		// Delete in localMoc
		NSManagedObjectContext* localMoc_ = [self localMoc] ;
		if (!localMoc_) {
			// [self error] should be already set
			goto end ;
		}
		[localMoc_ deleteObject:localStark] ;
		
		// Save immediately, to try and keep remote server and local
		// Core Data store in sync; uploads may be interrupted.
		BOOL savedOk = [localMoc_ save:&error_] ;
		if (!savedOk) {
			error_ = [SSYMakeError(56846, @"Failed to save MOC") errorByAddingUnderlyingError:error_] ;
			[self setError:error_] ;
			goto end ;
		}
		
		[pendingDeletions removeObject:localStark] ;
		nDone++ ;
	}
	else {
		// All deletions are done, see if any additions
		// Recall that pendingAdditions are in the transMoc, not the localMoc
		Stark* transStark ;
		if ((transStark = [pendingAdditions anyObject])) {
			// Do an addition
			
			// Announce it
			NSString* progressGuts = [NSString stringWithFormat:
									  @"(%ld/%ld) %@",
									  (long)nDone,
									  (long)nTasks,
									  [transStark name]] ;
			NSString* progressText = [NSString localizeFormat:@"uploading%0", progressGuts] ;
			[progressView setDoubleValue:nDone] ;
			// NO MORE!!  +1 because it looks better to start at 1% and finish at 100%
			// rather than to start at 0% and finish at 99%
			[progressView setVerb:progressText
						   resize:NO] ;
			
			BOOL ok = [self addAtServerStark:transStark
									 error_p:&error_] ;
			if (!ok) {
				NSDate* retryDate = [[error_ userInfo] objectForKey:SSYRetryDateErrorKey] ;
				if ([self isThrottledError:error_]) {
					[self scheduleBackedOffOutputInfo:info] ;
					error_ = nil ;
					[self setError:nil] ;
					return ;
					// Note: -scheduleBackedOffOutputInfo: is in lieu of scheduleRegularOutputInfo:.
				}
				else if (retryDate != nil) {
					// Throttled by Diigo, usually for about an hour
					[self scheduleRetryAtDate:retryDate
										 info:info] ;
					error_ = nil ;
					[self setError:nil] ;
					return ;
				}
				else {
					[self handleHttpError:error_
								requested:nil
									stark:transStark
							 receivedData:nil
						   prettyFunction:__PRETTY_FUNCTION__] ;
					error_ = [error_ errorByAddingUserInfoObject:[NSString stringWithFormat:@"%ld/%ld", (long)nDone, (long)[progressView maxValue]]
														  forKey:@"Current Progress"] ;
					goto end ;
				}
			}
			
			// In localMoc, update existing stark, or insert a new one
			Stark* existingLocalStark = [[self localStarker] starkWithEqualValueForKey:constKeyUrl
																			   asStark:transStark] ;
			if (existingLocalStark) {
				[existingLocalStark overwriteAttributesFromStark:transStark] ;
			}
			else {
                [self.localStarker insertStarkLikeStark:transStark] ;
			}
			// Save immediately, to try and keep remote server and local
			// Core Data store in sync because uploads may be interrupted.
			BOOL savedOk = [[self localMoc] save:&error_] ;
			if (!savedOk) {
				error_ = [SSYMakeError(56874, @"Failed to save MOC") errorByAddingUnderlyingError:error_] ;
				[self setError:error_] ;
				goto end ;
			}
			
			[pendingAdditions removeObject:transStark] ;
			nDone++ ;
		}
		else {
			// No more deletions or additions to do.
			allDone = YES ;
		}
	}
	
	[info setObject:[NSNumber numberWithInteger:nDone]
			 forKey:constKeyNDone] ;
	
end:;
	if (allDone || [self error]) {
		[self syncToServerAndLocalDidSucceed:([self error] == nil)
								  doneTarget:[info objectForKey:constKeySSYOperationQueueDoneTarget]] ;
	}
	else {
		[self scheduleRegularOutputInfo:info] ;
	}
}

- (void)setARequestTimerToFireAtDate:(NSDate*)date
							userInfo:(NSDictionary*)userInfo {
	NSTimer* timer = [[NSTimer alloc] initWithFireDate:date
											  interval:0.0
												target:self
											  selector:@selector(doNextOutputInfo:)
											  userInfo:userInfo
											   repeats:NO] ;
	[[NSRunLoop currentRunLoop] addTimer:timer
								 forMode:NSDefaultRunLoopMode] ;
	[timer release] ;
	[self setRequestTimer:timer] ;
}

- (void)willSleepNote:(NSNotification*)note {
	// Because a timer loses time during system sleep, we grab its user info and discard it…
	[self setRequestTimerFireDate:[[self requestTimer] fireDate]] ;
	[self setRequestTimerUserInfo:[[self requestTimer] userInfo]] ;
	// We did the retain] autorelease] because when we invalidate the timer, its
	// -userInfo will be released immediately.
	[[self requestTimer] invalidate] ;
}

- (void)didWakeNote:(NSNotification*)note {
	// And create a new timer to fire at the original fire date which we remembered,
	// but no sooner than 20 seconds from now.  The 20 seconds is to allow the system
	// to get its internet bearings back, so we don't get a "no internet connection" error
	// when we fire and -doNextOutputInfo:
	if ([self requestTimerFireDate]) {
		NSDate* newFireDate = [[NSDate dateWithTimeIntervalSinceNow:20.0] laterDate:[self requestTimerFireDate]] ;
		[self setARequestTimerToFireAtDate:newFireDate
								  userInfo:[self requestTimerUserInfo]] ;
	}
	
	[self setRequestTimerFireDate:nil] ;
	[self setRequestTimerUserInfo:nil] ;
}

		 
- (SSYOAuthTalker*)talker {
	if (!m_talker) {
		m_talker = [[SSYOAuthTalker alloc] initWithAccounter:[self client]] ;
		[m_talker setConsumerKey:[self extoreConstants_p]->oAuthConsumerKey] ;
		[m_talker setConsumerSecret:[self extoreConstants_p]->oAuthConsumerSecret] ;
		[m_talker setOAuthRealm:[self extoreConstants_p]->oAuthRealm] ;
		[m_talker setRequestAccessUrl:[self extoreConstants_p]->oAuthRequestAccessUrl] ;
		[m_talker setApiUrl:[[self class] defaultFilename]] ;
	}
	
	return m_talker ;
}

- (void)dealloc {
	[[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self
																  name:NSWorkspaceWillSleepNotification
																object:[NSWorkspace sharedWorkspace]] ;
	[[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self
																  name:NSWorkspaceDidWakeNotification
																object:[NSWorkspace sharedWorkspace]] ;

	[m_requestTimerFireDate release] ;
	[m_talker release] ;
    [m_requestTimerUserInfo release] ;
	
	[super dealloc] ;
}

/*!
 @brief    Copies all bookmarks from the receiver's localMoc into its
 transMoc, and deletes all other items, so that the transMoc contents
 mirrors the localMoc contents.
 
 @details  Sets the receiver's error ivar if any error occurs.
 
 Used by -readExternalStyle1ForPolarity::.
 */
- (void)syncLocalToTrans {
	NSError* error = nil ;
	
	NSString* verb = [NSString localizeFormat:
					  @"synchronizingWith%0%1",
					  [NSString localize:@"document"],
					  [NSString localize:@"storeLocal"]] ;
	SSYProgressView* progressView = [[[self bkmxDoc] progressView] setIndeterminate:YES
                                                                  withLocalizedVerb:verb
                                                                           priority:SSYProgressPriorityRegular] ;

	NSManagedObjectContext* localMoc_ = [self localMoc] ;
	if (!localMoc_) {
		// [self error] should be already set
		goto end2 ;
	}
	
	// Clean out transMoc
    [self clearTransMoc];

	// Get all objects out of localMoc
	NSArray* localStarks = [[self localStarker] allObjectsError_p:&error] ;
	if (error) {
		goto end ;
	}
	
	/* For all local starks, insert a copy into the transMoc, creating and
     connecting tags to replicate te Tags on the local stark.  Then (just for
	deteministicity) sort them, and finally add to root. */
	NSMutableArray* transStarks = [[NSMutableArray alloc] init] ;
	if (localStarks) {
		for (Stark* localStark in localStarks) {
			if ([localStark isRoot]) {
				// Don't want incest
				continue ;
			}
			
			Stark* transStark = [localStark replicatedOrphanStarkFreshened:NO
                                                                replicator:self] ;
            [transStarks addObject:transStark] ;
            
            [[self tagger] addForeignTags:[NSSet setWithArray:localStark.tags]
                                       to:transStark];
        }
	}
	NSSortDescriptor* sd1 = [[NSSortDescriptor alloc] initWithKey:constKeyName
														ascending:YES] ;
	NSSortDescriptor* sd2 = [[NSSortDescriptor alloc] initWithKey:constKeyUrl
														ascending:YES] ;
	[transStarks sortUsingDescriptors:[NSArray arrayWithObjects:sd1, sd2, nil]] ;
	[sd1 release] ;
	[sd2 release] ;
	Stark* root = [[self starker] root] ;
	for (Stark* transStark in transStarks) {
		// This also sets the index ...
        /* In BookMacster 1.21.1, I tried to improve the performance of this
         loop by replacing the following with
        [transStark moveToBkmxParent:root
                             atIndex:NSNotFound
                             restack:NO] ;
         and then -[root restackChildrenStealthily:NO] when the loop was done.
         But it only made the performance slightly worse.
         (8000 items increased from ~8 to ~10 seconds,
         averaging several tries.)
        */
		[transStark moveToBkmxParent:root] ;
	}
	[transStarks release] ;
	
	BOOL savedOk = [[self transMoc] save:&error] ;
	if (!savedOk) {
		if (!error) {
			NSString* msg = @"Unknown error during trans moc save" ;
			error = SSYMakeError(56841, msg) ;
		}
		goto end ;
	}
	
end:;	
	if (error) {
        error = [SSYMakeError(524050, @"Error while transferring data") errorByAddingUnderlyingError:error] ;
        [self setError:error] ;
    }
end2:
	[progressView clearAll] ;
}

- (void)saveLocalAndSyncToTrans {
    NSError* error_ = nil ;
    // Note that we preflighted the localMoc in
    // -readExternalStyle1ForPolarity::
    BOOL savedOk = [[self localMoc] save:&error_] ;
    if (savedOk) {
        // If we made it here, localMoc was synced to web server OK
        // We need to log the time this was done.
        NSDate* date = [self lastDateExternalWasTouched] ;
        // Prior to BookMacster 1.1.3, the above was externallyDerivedLastKnownTouch.
        // The problem with that was: If -lastDateExternalWasTouched moved its
        // answer later, to dateLastExported, due to the DeliPin bug noted in
        // there, then -lastDateExternalWasTouched would return NO.
        // Using -lastDateExternalWasTouched seems to make more sense.
        [[self client] setLastLocalMocSync:date] ;
    }
    else {
        if (!error_) {
            NSString* msg = @"Unknown error during local moc save" ;
            error_ = SSYMakeError(84658, msg) ;
        }
        [self setError:error_] ;
    }
    
    [self syncLocalToTrans] ;
}

- (BOOL)smartNeedsDownload {
    return
    ![self localMocIsSyncedWithExternal]
    ||
    ![self localMocExists] ;
}

- (void)readExternalStyle1ForPolarity:(BkmxIxportPolarity)polarity
                    completionHandler:(void(^)(void))completionHandler {
	BOOL ok = YES ;
	
#if USE_LOCAL_DOT_SQL_CACHES_WHEN_IMPORTING_WEB_EXTORES
#warning Will always use local caches
	BOOL needsDownload = NO ;
	if (![self localMocExists]) {
		NSString* msg = [NSString stringWithFormat:
						 @"App was compiled with USE_LOCAL_DOT_SQL_CACHES_WHEN_IMPORTING_WEB_EXTORES, "
						 "but cannot find local cache file %@",
						 [[SSYMOCManager sqliteStoreURLWithIdentifier:[[self clientoid] clidentifier]] path]] ;
		[self setError:SSYMakeError(151310, msg)] ;
		ok = NO ;
	}
#else
	BOOL needsDownload ;
	if ([[self client] willSelfDestruct]) {
        needsDownload = YES ;
    }
    else {
        if (polarity == BkmxIxportPolarityImport) {
            switch ([[self client] downloadPolicyForImport]) {
                case BkmxIxportDownloadPolicyAlways:
                    needsDownload = YES ;
                    break ;
                case BkmxIxportDownloadPolicyNever:
                    needsDownload = NO ;
                    break ;
                case BkmxIxportDownloadPolicyAutomatic:
                    needsDownload =[self smartNeedsDownload] ;
                    break ;
            }
        }
        else {
            switch ([[self client] downloadPolicyForImport]) {
                case BkmxIxportDownloadPolicyAlways:
                    needsDownload = YES ;
                    break ;
                case BkmxIxportDownloadPolicyNever:
                    needsDownload = NO ;
                    break ;
                case BkmxIxportDownloadPolicyAutomatic:
                    needsDownload =[self smartNeedsDownload] ;
                    break ;
            }
        }
    }
    
	// -smartNeedsDownload invokes -localMocIsSyncedWithExternal whiwch
    // invokes -lastDateExternalWasTouched which may have set an error.
    if ([self error]) {
		ok = NO ;
	}
#endif

    if (ok) {
#if DONT_USE_LOCAL_CACHES
        needsDownload = YES ;
#endif
        
#if 0
#warning Forcing needsDownload
        needsDownload = YES ;
#endif
        
        // Sync web server to localMoc if needed
        if (needsDownload) {
            NSString* msg = [NSString stringWithFormat:
                             @"Need to download from %@",
                             [[self clientoid] displayName]] ;
            [[BkmxBasis sharedBasis] logFormat:msg] ;
            NSManagedObjectContext* localMoc_ = [self localMoc] ;
            if (localMoc_) {
                [self syncWebServerToLocalThenCompletionHandler:completionHandler] ;
            }
            else {
                // [self error] should be already set
                completionHandler() ;
            }
            
        }
        else {
            NSString* msg = [NSString stringWithFormat:
                             @"Nothing new at %@ \u279E Skip download",
                             [[self clientoid] displayName]] ;
            [[BkmxBasis sharedBasis] logFormat:msg] ;
            [self syncLocalToTrans] ;
            completionHandler() ;
        }
    }
    else {
        completionHandler() ;
    }
}

- (BOOL)isExportableStark:(Stark*)stark
			   withChange:(NSDictionary*)change {
#if IS_EXPORTABLE_STARK_WILL_ALWAYS_RETURN_YES
	return YES  ;
#endif
	
	if (![super isExportableStark:stark
					   withChange:change]) {
		return NO ;
	}
	
	NSString* urlString = [stark url] ;
	
	if (![StarkTyper doesDisplayInNoFoldersViewSharype:[stark sharypeValue]]) {
		return NO ;
	}
	else if ([stark isBookmacsterizer]) {
		// Pinboard will accept this bookmarklet, but it's useless up there.
		return NO ;
	}
	else if ([urlString hasPrefix:@"data"]) {
		// Pinboard  will accept this, but it will truncate
		// the URL to simply "data".
		return NO ;
	}
	else if ([stark is1PasswordBookmarklet]) {
		return NO ;
	}
	
	NSURL* daUrl = [NSURL URLWithString:urlString] ;
	
	NSString* host = [daUrl host] ;
	if ([host hasSuffix:@"."]) {
		return NO ;
	}
	
	return YES ;
}

- (BOOL)changedBookmarksMustBeDeleted {
	return NO ;
}

- (void)writeUsingStyle1InOperation:(SSYOperation*)operation {
	[self setError:nil] ;
	
	NSMutableSet* pendingAdditions = [NSMutableSet set] ;
	NSMutableSet* pendingDeletions = [NSMutableSet set] ;
	
	SSYProgressView* progressView = [[self bkmxDoc] progressView] ;
	[progressView setIndeterminate:YES
               withLocalizableVerb:@"comparing"
                          priority:SSYProgressPriorityRegular] ;

	// Prior to BookMacster version 1.3.19, we used [[self starker] allStarks],
	// but now mergeFromStartainer:::/gulpStartainer:::: does not delete deleted starks, just
	// orphans them.  So we now use [[[self starker] root] children].
	NSSet* transBookmarks = [[[self starker] root] children] ;
	
	// Process each bookmark to populate pendingAdditions and also mark
	// starks which are matched
	NSNumber* zero = [NSNumber numberWithInteger:0] ;
	[[self localStarker] setAllStarksNotMatched] ;
	NSDictionary* localStarksKeyedByUrl = [[self localStarker] starksKeyedByKey:constKeyUrl] ;
	for (Stark* transBookmark in transBookmarks) {
		NSString* targetKey = [transBookmark valueForKey:constKeyUrl] ;
		Stark* localBookmark = [localStarksKeyedByUrl objectForKey:targetKey] ;
		if (localBookmark) {
			// There is an existing bookmark in localMoc which matches transBookmark.
			// Mark this one as "matched" by giving it 
			// any non-nil sponsorIndex
			[localBookmark setSponsorIndex:zero] ;

			if (![self supportedAttributesAreEqualComparingStark:transBookmark
													  otherStark:localBookmark
                                                     ixportStyle:1]) {
				// We have found a CHANGE
				[pendingAdditions addObject:transBookmark] ;
				if ([self changedBookmarksMustBeDeleted]) {
					[pendingDeletions addObject:localBookmark] ;
				}
			}
		}
		else if ([self shouldExportStark:transBookmark
							  withChange:nil]) {
			// We have found an ADDITION.
			[pendingAdditions addObject:transBookmark] ;
		}
	}
	
	// All local bookmarks which were not matched to transient trans bookmarks
	// are the ones that need to be deleted.
	
	// Thus we have found, en masse, the DELETIONS.
	NSMutableArray* unmatchedLeaves = [[NSMutableArray alloc] init] ;
	for (NSString* url in localStarksKeyedByUrl) {
		Stark* stark = [localStarksKeyedByUrl objectForKey:url] ;
		
		if (
			[StarkTyper isLeafCoarseSharype:[stark sharypeValue]]
			&&
			([stark sponsorIndex] == nil)
			) {
			[unmatchedLeaves addObject:stark] ;
		}
		
	}	
	[pendingDeletions addObjectsFromArray:unmatchedLeaves] ;
	[unmatchedLeaves release] ;
	
	// Tidy up.  It is probably not necessary to do this, because we'll
	// do it again (see above) the next time we start this operation,
	// but I don't like to leave temporary garbage in a persistent store
	[self.localStarker setAllStarksNotMatched] ;	
	
	// Note that:
	//    pendingDeletions is an array of starks in the localMoc.
	//    pendingAdditions is an array of starks in the transMoc.
	
	BOOL ok = YES ;
	
	if ([pendingAdditions count] + [pendingDeletions count] == 0) {
		[self setError:SSYMakeError(constBkmxErrorNoItemsToUpload, @"No items to upload")] ;
		ok = NO ;
	}

	// The following could fail and set self's error
	NSManagedObjectContext* localMoc_ = [self localMoc] ;
	if (!localMoc_) {
		// [self error] should be already set
		ok = NO ;
	}
	
	if (ok) {
		NSInvocation* invocation = [NSInvocation invocationWithTarget:self
															 selector:@selector(cancel:)
													  retainArguments:YES
													argumentAddresses:NULL] ;
		[operation setCancellor:invocation] ;
		[[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
															   selector:@selector(willSleepNote:)
																   name:NSWorkspaceWillSleepNotification
																 object:[NSWorkspace sharedWorkspace]] ;
		[[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
															   selector:@selector(didWakeNote:)
																   name:NSWorkspaceDidWakeNotification
																 object:[NSWorkspace sharedWorkspace]] ;
		[self syncToServerAndLocalAdditions:pendingAdditions
								  deletions:pendingDeletions
								 doneTarget:operation] ;
	}
	else {
		// Skip the actual syncing
		[self syncToServerAndLocalDidSucceed:NO
								  doneTarget:operation] ;
	}
}

- (void)syncToServerAndLocalDidSucceed:(BOOL)didSucceed
							doneTarget:(SSYOperation*)doneTarget {
	[[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self
																  name:NSWorkspaceWillSleepNotification
																object:[NSWorkspace sharedWorkspace]] ;
	[[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self
																  name:NSWorkspaceDidWakeNotification
																object:[NSWorkspace sharedWorkspace]] ;
	if (!didSucceed) {
		goto end ;
	}

	NSError* error_ = nil ;
	NSManagedObjectContext* localMoc_ = [self localMoc] ;
	didSucceed = [localMoc_ save:&error_] ;
	if (!didSucceed) {
		if (!error_) {
			NSString* msg = @"Unknown error during local moc save" ;
			error_ = SSYMakeError(49907, msg) ;
		}
		[self setError:error_] ;
		goto end ;
	}
	
	/* Note 20120625.
	 The following code was moved in BookMacster 1.11.5, 
	 in to -[SSYOperation(OperationExport) timestampExported_unsafe].
	 The problem was that Maciej at Pinboard discovered that posts/update
	 was an expensive operation for him, and started returning HTTP 
	 error 429 if posts/update was called more than once within 5
	 seconds.  With the following call in that method, we were doing
	 it twice.  So now I call it only once, in that method, and 
	 write the result to both client's lastLocalMocSyncDate
	 and user default's lastChangeWrittenDate for the client.
	 */
	// If we made it here, localMoc was synced to web server OK
	// We need to log the time this was done.
	// NSDate* date ;
	// BOOL ok = [self getExternallyDerivedLastKnownTouch:&date] ;
	// if (!ok) {
	//	goto end ;
	// }
	// [[self client] setLastLocalMocSync:date] ;
	
end:;
	SSYProgressView* progressView = [[self bkmxDoc] progressView] ;
	[progressView clearAll] ;
	[doneTarget writeAndDeleteDidSucceed:didSucceed] ;
}

- (void)syncWebServerToLocalThenCompletionHandler:(void(^)(void))completionHandler {
	NSLog(@"Internal Error 984-2564.  Forgot to override %s", __PRETTY_FUNCTION__) ;

    completionHandler() ;
}

- (void)syncToServerAndLocalAdditions:(NSMutableSet*)additions
							deletions:(NSMutableSet*)deletions
						   doneTarget:(SSYOperation*)doneTarget {
	NSLog(@"Internal Error 345-9828.  Forgot to override %s", __PRETTY_FUNCTION__) ;
}

#if 0
#warning Debugging Memory Retain Release in Extore
- (void)retain {
	NSLog(@"9219: %@ rc to %ld", self, (long)([self retainCount] + 1)) ;
	[super retain] ;
}

- (oneway void)release {
	NSLog(@"9220: %@ rc to %ld", self, (long)([self retainCount] - 1)) ;
	[super release] ;
}
#endif

- (void)handleHttpError:(NSError*)error
			  requested:(NSString*)requested
				  stark:(Stark*)stark
		   receivedData:(NSData*)receivedData
		 prettyFunction:(const char*)prettyFunction {
	error = [error errorByAddingUserInfoObject:[self ixporter]
										forKey:constKeyIxporter] ;
	error = [error errorByAddingRecoveryAttempter:self] ;
	error = [error errorByAddingUserInfoObject:[[self clientoid] profileName]
										  forKey:@"Account"] ;
	error = [error errorByAddingUserInfoObject:requested
										  forKey:@"Request Details"] ;
	error = [error errorByAddingPrettyFunction:prettyFunction] ;
	if (stark) {
		NSString* newFailureReason = [NSString stringWithFormat:
								   @"Trouble may be with a bookmark named '%@'",
								   [stark nameNoNil]] ;
		error = [error errorByAppendingLocalizedFailureReason:newFailureReason] ;

        error = [error errorByAddingUserInfoObject:[stark nameAndUrl]
                                            forKey:BkmxExtoreWebFlatErrorItemSummary] ;

		if ([error code] == 414) {
			// This was added in BookMacster 1.11 when it was seen that
			// Pinboard returns HTTP Error 414 if a posts/add request exceeds some
			// threshold which appears to be around 8K bytes.  It is not 
			// documented in their API.
			error = [error errorByAddingLocalizedRecoverySuggestion:
					 @"Search for that Bookmark using the Quick Search in BookMacster.  "
					 @"Then open the Inspector, look at the text in all of its fields and see if some are very long.  "
					 @"If you find some that are very long, shorten them to a more normal length."] ;
		}
	}
	if ([error involvesCode:-1009
					 domain:(NSString*)kCFErrorDomainCFNetwork]) {
		NSString* suggestion = [NSString localize:@"internetGetMakeSure"] ;
		error = [error errorByAddingLocalizedRecoverySuggestion:suggestion] ;
	}
	if ([[error domain] isEqualToString:SSYSynchronousHttpErrorDomain]) {
		if ([error involvesOneOfCodesInSet:[WebAuthorizor ssySyncCredentialErrorCodesSet]]) {
			NSString* suggestion = [NSString localize:@"accountInfoReenter"] ;
			error = [error errorByAddingLocalizedRecoverySuggestion:suggestion] ;
			NSArray* options = [NSArray arrayWithObjects:
								[NSString localize:@"reenter"],
								[[BkmxBasis sharedBasis] labelCancel],
								nil] ;
			
			error = [error errorByAddingLocalizedRecoveryOptions:options] ;
		}
			 
		NSString* possibleHtmlTag = nil ;
		NSData* data = [[error userInfo] objectForKey:SSYSynchronousHttpReceivedDataErrorKey] ;
		if (data) {
			possibleHtmlTag = [[NSString alloc] initWithBytes:[data bytes]
															 length:6
														   encoding:NSUTF8StringEncoding] ;
		}
		BOOL hasHtml = [[possibleHtmlTag lowercaseString]isEqualToString:@"<html>"] ;
        [possibleHtmlTag release] ;
		if (([error code] >= 500) && ([error code] <= 999) && hasHtml) {
			NSString* suggestion = [NSString localizeFormat:
									@"errorUnexpectHtmlViewX",
									[NSString localize:@"view_v"]] ;
			error = [error errorByAddingLocalizedRecoverySuggestion:suggestion] ;
			
			NSArray* options = [NSArray arrayWithObjects:
								[NSString localize:@"view_v"],
								[[BkmxBasis sharedBasis] labelCancel],
								nil] ;
			error = [error errorByAddingLocalizedRecoveryOptions:options] ;
		}
	}	
	else if ([[error domain] isEqualToString:SSYOAuthTalkerErrorDomain]) {
		if (([error code] == 401) || ([error involvesCode:SSYOAuthTalkerCredentialNotFoundErrorCode])) {
			NSString* suggestion = [NSString localizeFormat:
									@"oAuthLinkRedoX3",
									[NSString localize:@"oAuthReLink"],
									[[BkmxBasis sharedBasis] appNameLocalized],
									[[self ixporter] displayName]] ;
			error = [error errorByAddingLocalizedRecoverySuggestion:suggestion] ;
			
			NSArray* options = [NSArray arrayWithObjects:
								[NSString localize:@"oAuthReLink"],
								[[BkmxBasis sharedBasis] labelCancel],
								nil] ;
			error = [error errorByAddingLocalizedRecoveryOptions:options] ;
		}
	}
	else if ([[error domain] isEqualToString:BkmxExtoreWebFlatErrorDomain]) {
		if ([error code] == constNonhierarchicalWebAppErrorCodeNeedsAccountInfo) {
			NSString* suggestion = [NSString localize:@"accountInfoReenter"] ;
			error = [error errorByAddingLocalizedRecoverySuggestion:suggestion] ;
			NSArray* options = [NSArray arrayWithObjects:
								[NSString localize:@"reenter"],
								[[BkmxBasis sharedBasis] labelCancel],
								nil] ;
			
			error = [error errorByAddingLocalizedRecoveryOptions:options] ;
		}
	}
	[self setError:error] ;
	[self clarifyErrorForRequest:requested
					receivedData:receivedData] ;
}


- (void)askUserAccountInfoForIxporter:(Ixporter *)ixporter {
    NSMutableDictionary* info = nil ;
    info = [NSMutableDictionary dictionaryWithObject:[WebAuthorizor didSucceedEnteringAccountInfoInvocation]
                                              forKey:constKeyDidSucceedInvocation] ;
    
    /* If we are here because the password was not found in the
     macOS Keychain, self will already be partially torn down
     to the point that self.client is nil.  However, the
     ixporter which we cleverly stashed in the error's userInfo
     will of course still have a client, so the following works… */
    [ixporter.client.webAuthorizor askUserAccountInfoForIxporter:ixporter
                                                            info:info] ;
}

- (void)attemptRecoveryFromError:(NSError *)error
				  recoveryOption:(NSUInteger)recoveryOption
						delegate:(id)dontUseThis
			  didRecoverSelector:(SEL)useInvocationFromInfoDicInstead
					 contextInfo:(void*)contextInfo {

	BOOL didRecover = NO ;
	error = [error deepestRecoverableError] ;
	if ([[error domain] isEqualToString:BkmxExtoreWebFlatErrorDomain]) {
		switch ([error code]) {
			case constNonhierarchicalWebAppErrorCodeNeedsAccountInfo:
				didRecover = YES ;
				if (recoveryOption == NSAlertFirstButtonReturn) {
					// Bad or missing password
					
					Ixporter* ixporter = [[error userInfo] objectForKey:constKeyIxporter] ;
                    
                    if (ixporter) {
                        [self askUserAccountInfoForIxporter:ixporter] ;
                        [ixporter renewExtoreForJobSerial:self.jobSerial
                                                  error_p:NULL];
                    } else {
                        NSError* error = SSYMakeError(327370, @"Cannot ask user for account info because error has no ixporter");
                        [[BkmxBasis sharedBasis] logError:error
                                          markAsPresented:NO];
                    }
					break ;
				}
		}
	}
	else if ([[error domain] isEqualToString:SSYSynchronousHttpErrorDomain]) {
		if ([error involvesOneOfCodesInSet:[WebAuthorizor ssySyncCredentialErrorCodesSet]]) {
			didRecover = YES ;
			if (recoveryOption == NSAlertFirstButtonReturn) {
				Ixporter* ixporter = [[error userInfo] objectForKey:constKeyIxporter] ;
				
                if (ixporter) {
                    [self askUserAccountInfoForIxporter:ixporter] ;
                } else {
                    NSError* error = SSYMakeError(327390, @"Cannot ask user for account info because error has no ixporter");
                    [[BkmxBasis sharedBasis] logError:error
                                      markAsPresented:NO];
                }
			}
		}
		else if (([error code] >= 500) && ([error code] <= 999)) {
			didRecover = YES ;
			if (recoveryOption == NSAlertFirstButtonReturn) {
				// Banned
				
				// I believe that this branch probably no longer ever executes since the
				// 503 and 999 error codes are detected by -[ExtoreWebFlat isThrottledError:],
				// in -[ExtoreHttp doNextOutputInfo:], and also handled in that
				// method without even presenting to the user.
				NSData* data = [[error userInfo] objectForKey:SSYSynchronousHttpReceivedDataErrorKey] ;
				NSString* possibleHtmlTag = [[NSString alloc] initWithBytes:[data bytes]
																	 length:6
																   encoding:NSUTF8StringEncoding] ;
				BOOL hasHtml = [[possibleHtmlTag lowercaseString]isEqualToString:@"<html>"] ;
                [possibleHtmlTag release] ;
				if (hasHtml) {
					// Write html to temporary file
					NSString* tempFilename = [NSString stringWithFormat:
											  @"UnexpectedHTML_%@.html",
											  [[NSProcessInfo processInfo] processName]] ;
					NSString* tempPath = [NSTemporaryDirectory() stringByAppendingPathComponent:tempFilename] ;
					[data writeToFile:tempPath
						   atomically:NO] ;
					
					// Open in user's default browser
					NSString* htmlFileURL = [NSString stringWithFormat:@"file://%@", tempPath] ;
					[SSWebBrowsing browseToURLString:htmlFileURL
							 browserBundleIdentifier:nil
											activate:YES] ;					
				}
			}
		}
	}
	else if ([[error domain] isEqualToString:SSYOAuthTalkerErrorDomain]) {
		Ixporter* ixporter = [[error userInfo] objectForKey:constKeyIxporter] ;
		NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObject:ixporter
																	   forKey:constKeyIxporter] ;
		switch ([error code]) {
			case SSYOAuthTalkerRequestFailedErrorCode:
				didRecover = YES ;
				if (recoveryOption == NSAlertFirstButtonReturn) {
					// Transfer error's didRecoverInvocation to info's didSucceedInvocation.
					// This is used in case bad credentials are discovered during Import or Export.
					[info setValue:[WebAuthorizor didSucceedEnteringAccountInfoInvocation]
							forKey:constKeyDidSucceedInvocation] ;					
				}
				break ;
			case SSYOAuthTalkerCredentialNotFoundErrorCode:
			case 401:  // (HTTP Status Code "Not authorized")
				didRecover = YES ;
				if (recoveryOption == NSAlertFirstButtonReturn) {
					[self.client.webAuthorizor getOAuthAuthorizationWithInfo:info] ;
				}
				break ;
		}
	}
	
	if (!didRecover) {
        if (error && [super respondsToSelector:@selector(attemptRecoveryFromError:recoveryOption:delegate:didRecoverSelector:contextInfo:)]) {
            [super attemptRecoveryFromError:error
                             recoveryOption:recoveryOption
                                   delegate:dontUseThis
                         didRecoverSelector:useInvocationFromInfoDicInstead
                                contextInfo:contextInfo];
        } else if (error) {
            NSLog(@"Internal Error 584-3848");
        } else {
            NSLog(@"Internal Error 584-3849");
        }
 	}
}

@end
