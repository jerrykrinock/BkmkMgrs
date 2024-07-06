#import <Bkmxwork/Bkmxwork-Swift.h>
#import "NSString+LocalizeSSY.h"
#import "BkmxBasis.h"
#import "Syncer.h"
#import "AgentPerformer.h"
#import "BkmxDoc.h"
#import "BkmxAgentAppDel.h"
#import "BkmxBasis.h"
#import "BkmxDocumentController.h"
#import "Client.h"
#import "Clientoid.h"
#import "Command.h"
#import "Exporter.h"
#import "Importer.h"
#import "Job.h"
#import "Macster.h"
#import "NSArray+Stringing.h"
#import "NSDate+NiceFormats.h"
#import "NSError+InfoAccess.h"
#import "NSError+SSYInfo.h"
#import "NSData+FileAlias.h"
#import "SSYOperationQueue.h"
#import "NSString+VarArgs.h"
#import "SSYRunLoopTickler.h"
#import "NSError+MoreDescriptions.h"
#import "NSUserDefaults+MainApp.h"
#import "NSUserDefaults+Bkmx.h"
#import "NSBundle+MainApp.h"
#import "Operation_Common.h"
#import "SSYUserInfo.h"
#import "SSYSystemUptimer.h"
#import "Trigger.h"
#import "Stager.h"
#import "NSError+MyDomain.h"
#import "NSObject+MoreDescriptions.h"
#import "NSInvocation+Quick.h"
#import "SSYAppleScripter.h"
#import "SSYMojo.h"
#import "BkmxNotifierCaller.h"
#import "NSManagedObjectContext+Cheats.h"

static AgentPerformer* sharedPerformer = nil ;

@interface AgentPerformer ()

@property (retain) NSError* error;
@property (assign) NSInteger nowWorkingJobSerial;
@property (assign) NSInteger jobsDoneCount;

@end

@implementation AgentPerformer

+ (AgentPerformer*)sharedPerformer {
    @synchronized(self) {
        if (!sharedPerformer) {
            sharedPerformer = [[self alloc] init] ;
        }
        return sharedPerformer ;
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        /* Create empty jobQueue now, instead of when adding first job,
         because, to verify XPC operation, if no jobs are added, we want
         -[BkmxAgentXPCListener getJobsThenDo:] to return an empty array
         instead of nil. */
        _jobQueue = [NSMutableArray new];
    }

    return self;
}

+ (CFURLRef)iconUrl {
    NSString* appName = constAppNameBkmxAgent ;
    // appName will be "BkmxAgent"
    NSBundle* bundle = [NSBundle mainAppBundle] ;
    NSString* iconPath = [bundle pathForImageResource:appName] ;
    CFURLRef iconUrl = NULL ;
    if (iconPath) {
        iconUrl = (CFURLRef)[NSURL fileURLWithPath:iconPath] ;
    }
    else {
        NSLog(@"Internal Error 235-0181 No resource for appName=%@, bundlePath=%@, iconPath=%@",
              appName,
              [bundle bundlePath],
              iconPath) ;
    }

    return iconUrl ;
}

@synthesize error = m_error ;
@synthesize dupesCount = m_dupesCount ;
@synthesize activeAgentIndex = m_activeAgentIndex ;

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self] ;
	[m_error release] ;
	
	[super dealloc] ;
}

- (NSString*)alertTitle {
    return constAppNameBkmxAgent ;
}

- (NSArray<Job*>*)jobQueue {
    @synchronized (_jobQueue) {
        return [[_jobQueue copy] autorelease];
    }
}

- (NSMutableSet*)queueingDelayTimers {
    @synchronized(self) {
        if (!_queueingDelayTimers) {
            _queueingDelayTimers = [NSMutableSet new];
        }

        return _queueingDelayTimers;
    }
}

- (void)queueJob:(Job*)job
      afterDelay:(NSTimeInterval)delay {
    if (delay == 0.0) {
        [self queueJob:job];
    } else {
        NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:delay
                                                          target:self
                                                        selector:@selector(queueJobForTimer:)
                                                        userInfo:job
                                                         repeats:NO];
        [[self queueingDelayTimers] addObject:timer];
    }
}

- (void)queueJob:(Job*)job {
//TODO Needs a timeout to detect a stalled job plugging the queue (to replace semaphore)
    /*     Does SSYOperationQueue have a timeout? */

    /* The following test is now defensive programming, because I have now
     found and fixd the root cause which called this method with nil job. */
    if (job) {
        @synchronized (_jobQueue) {
            [_jobQueue addObject:job];
        }
        NSString* cause = [NSString stringWithFormat:@"J%@ +++", job.serialString];
        [self tickleJobQueueForCause:cause];
    }
}

- (void)tickleJobQueueForCause:(NSString*)cause {
    Job* topJob;
    @synchronized (_jobQueue) {
        topJob = _jobQueue.firstObject;
    }

    NSString* working;
    if (self.nowWorkingJobSerial > 0) {
        working = [@"J" stringByAppendingString:[Job serialStringForSerial:self.nowWorkingJobSerial]];
    } else {
        working = @"[None]";
    }
    NSString* queued;
    if (_jobQueue.count > 0) {
        NSMutableString* queuedList = [NSMutableString new];
        for (Job* job in _jobQueue) {
            if (queuedList.length > 0) {
                [queuedList appendFormat:@", "];
            }
            [queuedList appendString:@"J"];
            [queuedList appendString:job.serialString];
        }
        queued = [queuedList copy];
        [queuedList release];
        [queued autorelease];
    } else {
        queued = @"[None]";
    }
    [[BkmxBasis sharedBasis] forJobSerial:0
                                logFormat:
     @"Tickle (%@):  Working: %@   Queued: %@",
     cause,
     working,
     queued];
    if (self.nowWorkingJobSerial != topJob.serial) {
        NSAssert(topJob.serial != 0, @"Only -finishJob:: is supposed to set nowWorkingJobSerial to zero");
        self.nowWorkingJobSerial = topJob.serial;
        [self doNowJob:topJob];
    }
}

+ (NSString*)notificationTitleForStaged {
    return @"Sync operation has been staged";
}

+ (NSString*)notificationTitleForStarted{
    return @"Sync operation has started";
}

+ (NSString*)notificationTitleForSuccess {
    return @"Sync operation succeeded";
}

+ (NSString*)notificationTitleForFailure {
    return @"Sync operation failed";
}

- (void)finishJob:(Job*)job
          bkmxDoc:(BkmxDoc*)bkmxDoc {
    /* Defensive programming.  This method is only called in BkmxAgent, but
     just make sure …*/
    NSAssert([[BkmxBasis sharedBasis] isBkmxAgent], @"-[AgentPerformer finishJob::] abused [1]");

	/* If the document is still open (which it may not be, particularly if
     error occurred), in case we are going to abruptly reboot, we don't
     want the document to be corrupted.  If we are not going to reboot, we
     don't want the next job that runs to re-use the document, because that
     might cause unforseen undesired results.  The following statement behaves
     correctly in all of these cases… */
    [bkmxDoc close];
    
    if (self.nowWorkingJobSerial == 0) {
        /* This method has apparently already been called for this job. */
        return;
    }

    /* Indicate that there is no job working any more… */
    self.nowWorkingJobSerial = 0;

	/* Remove finished job from jobQueue */
    @synchronized (_jobQueue) {
        if (job) {
            Job* firstJob = [_jobQueue firstObject];
            /* First, a sanity check. */
            if (firstJob && job) {
                if (job.serial != firstJob.serial) {
                    NSError* error = SSYMakeError(978527, @"Jobs not same as expected when finishing");
                    error = [error errorByAddingUserInfoObject:job
                                                        forKey:@"Passed In Job"];
                    error = [error errorByAddingUserInfoObject:firstJob
                                                        forKey:@"First Job in Queue"];
                    [[BkmxBasis sharedBasis] logError:error
                                      markAsPresented:NO];
                }
            }
            [_jobQueue removeObject:job];
            self.jobsDoneCount = self.jobsDoneCount + 1;
        } else {
#if DEBUG
            NSError* error = SSYMakeError(978528, @"Asked to remove nil job");
            Job* firstJob = [_jobQueue firstObject];
            error = [error errorByAddingUserInfoObject:firstJob
                                                forKey:@"First Job in Queue"];
            [[BkmxBasis sharedBasis] logError:error
                              markAsPresented:NO];
#endif
            /* Unfortunately, when we are called by
             -[AgentPerformer alertError:], job may be nil.  In this case, we
             must use a more unreliable method. */
            if (_jobQueue.firstObject != nil) {
                [_jobQueue removeObjectAtIndex:0];
                self.jobsDoneCount = self.jobsDoneCount + 1;
            }
        }
    }

    /* Compute a summaryCode for logging and sound playing */
    NSInteger summaryCode = 0;  // Assume success
    NSError* performanceError = self.error;
    if (performanceError.code != 0) {
        summaryCode = performanceError.code;
    }

	/* Present User Notification (alert, sound, both, or neither) */
    NSString* title = nil;
    NSString* subtitle = nil;
    NSString* body = nil;
    NSString* soundName = nil;
    BOOL isAMajorError;
    if (summaryCode == 0) {
        isAMajorError = NO;
        if ([[NSUserDefaults standardUserDefaults] syncAndGetMainAppBoolForKey:constKeyAlertSuccess]) {
            title = [AgentPerformer notificationTitleForSuccess];
            subtitle = @"Your bookmarks are synced";
        }
        if ([[NSUserDefaults standardUserDefaults] syncAndGetMainAppBoolForKey:constKeySoundSuccess]) {
            soundName = @"BookMacsterSyncSuccess";
        }
    } else if ([gSSYAlertErrorHideManager shouldHideError:performanceError]) {
        isAMajorError = NO;
        if ([[NSUserDefaults standardUserDefaults] syncAndGetMainAppBoolForKey:constKeyAlertFailure]) {
            title = [AgentPerformer notificationTitleForFailure];
            subtitle = [NSString stringWithFormat:@"Minor Error %ld", performanceError.code];
            if (performanceError.code == constBkmxErrorBrowserBookmarksWereChangedDuringSync) {
                NSNumber* secondsToRedo = [performanceError.userInfo objectForKey:constKeyAgentRedoDelay];
                NSAssert (secondsToRedo != nil, @"Missing constKeyAgentRedoDelay");
                body = [NSString stringWithFormat:
                        @"Will import from all in %ld seconds",
                        [secondsToRedo longValue]];
            } else if (performanceError.code == constBkmxErrorMainAppHasDocOpenSoWontSync) {
                NSString* path = [[NSDocumentController sharedDocumentController] pathOfDocumentWithUuid:job.docUuid
                                                                                                 appName:nil
                                                                                                 timeout:30.0
                                                                                                  trials:6
                                                                                                   delay:10
                                                                                                 error_p:NULL];
                body = [NSString stringWithFormat:
                        @"Not syncing cuz %@ is open.",
                        path.lastPathComponent];
            } else {
                body = @"Usually syncs OK next time";
            }
        }
        if ([[NSUserDefaults standardUserDefaults] syncAndGetMainAppBoolForKey:constKeySoundFailMinor]) {
            soundName = @"BookMacsterSyncFailMinor";
        }
    } else {
        isAMajorError = YES;
        /* There is no user default to mute major errors.  Alert shall be
         displayed and sounded.  */
        title = [AgentPerformer notificationTitleForFailure];
        subtitle = @"Recent changes are not synced";
        body = NSLocalizedString(@"Mouse here and click the button which will appear.", nil);
        if ([[NSUserDefaults standardUserDefaults] syncAndGetMainAppBoolForKey:constKeySoundFailMajor]) {
            soundName = @"BookMacsterSyncFailMajor";
        }
    }
    NSError* notifyingError = nil;
    /* We pass nil for `error` in the following because we want all errors
     which made it to this point to be displayed as either alert or banner. */
    [BkmxNotifierCaller presentUserNotificationOfError:nil
                                                 title:title
                                        alertNotBanner:isAMajorError
                                              subtitle:subtitle
                                                  body:body
                                             soundName:soundName
                                       targetErrorCode:performanceError.code
                                               error_p:&notifyingError];
    [[BkmxBasis sharedBasis] logError:notifyingError
                      markAsPresented:NO];


	/* Tickle the jobQueue */
    NSString* cause = [NSString stringWithFormat:@"J%@ ---", job.serialString];
    [self tickleJobQueueForCause:cause];

	/* Log result */
    [[BkmxBasis sharedBasis] forJobSerial:job.serial
                                logFormat:@"Performer Result: %@",
                                           @(summaryCode)];

	/* Maybe reboot ourself */
    [self performSelector:@selector(maybeRebootMeLoggingJob:)
               withObject:job
               afterDelay:3.0];
}

- (void)maybeRebootMeLoggingJob:(Job*)job {
    [[BkmxBasis sharedBasis] forJobSerial:job.serial
                                logString:@"Will maybe reboot"];

    [(BkmxAgentAppDel*)[NSApp delegate] rebootMeIfNonePendingLoggingJobSerial:job.serial];
}

- (NSInteger)cancelDoingDelayedJobsWithSyncerUri:(NSString*)syncerUri {
    NSSet* frozenQueueingDelayTimers = [[self queueingDelayTimers] copy];
    NSInteger count = 0;
    for (NSTimer* timer in frozenQueueingDelayTimers) {
        Job* job = [timer userInfo];
        NSString* aSyncerUri = job.syncerUri;
        if ([aSyncerUri isEqualToString:syncerUri]) {
            [timer invalidate];
            [[self queueingDelayTimers] removeObject:timer];
            count++;
        }
    }
    [frozenQueueingDelayTimers release];

    return count;
}



- (NSInteger)cancelDoingDelayedJobsWithDocUuid:(NSString*)docUuid {
    NSSet* frozenQueueingDelayTimers = [[self queueingDelayTimers] copy];
    NSInteger count = 0;
    for (NSTimer* timer in frozenQueueingDelayTimers) {
        Job* job = [timer userInfo];
        if ([job.docUuid isEqualToString:docUuid]) {
            [timer invalidate];
            [[self queueingDelayTimers] removeObject:timer];
            count++;
        }
    }
    [frozenQueueingDelayTimers release];

    return count;
}

- (NSInteger)cancelDoingQueuedJobsWithDocUuid:(NSString*)docUuid {
    NSInteger count = 0;
    @synchronized (_jobQueue) {
        count = _jobQueue.count;
        if (count > 1) {
            [_jobQueue removeObjectsInRange:NSMakeRange(1, count - 1)];
        }
    }

    return count;
}

- (void)queueJobForTimer:(NSTimer*)timer {
    [[self queueingDelayTimers] removeObject:timer];
    Job* job = timer.userInfo;
	[[BkmxBasis sharedBasis] forJobSerial:job.serial
                                logFormat:@"Staging delay fired, adding to queue"];
    [self queueJob:job];
}

- (void)alertError:(NSError*)error {
    [self registerError:error];
}

- (void)registerError:(NSError*)error {
	if (!error) {
		return ;
	}
	
	// Added in BookMacster 1.3.19 so that a process will not present multiple errors.
	// This can happen in the following way.  Say that an Syncer's commands are:
	// Import, Sort, Export, Save; and there are two Export Clients.
	// The queue will be added two five times: Import, Sort,
	// Export Client 1, Export Client 2, Save.  And each one will invoke 
	// -[BkmxDoc finishGroupOfOperationsWithInfo:].  If an error occurs in the Import, this error
	// will be in 'info' each of the six times that -finishGroupOfOperationsWithInfo is invoked,
	// and thus will be presented six times.  The following line prevents that
	if ([self error]) {
		return ;
	}
	
	// Add more information to the error
	NSString* docUuid = [[error userInfo] objectForKey:SSYDocumentUuidErrorKey] ;
	NSData* docAliasRecord = [[[NSUserDefaults standardUserDefaults] syncAndGetMainAppValueForKey:constKeyDocAliasRecords] objectForKey:docUuid] ;
	NSString* docPath = [docAliasRecord pathFromAliasRecordWithTimeout:60.0
															   error_p:NULL] ;
	error = [error errorByAddingUserInfoObject:docPath
										forKey:@"Document Path"] ;
	
	error = [error errorByAddingTimestampNow] ;
	
	// Since it is going to be presented in the main app, 
	// which is another process, the recovery attempter 
	// object will no longer be available, so we remove
	// it.  (However, we do not remove the 
	// recoveryAttempterUrl, since that should work.)
	error = [error errorByRemovingRecoveryAttempter] ;
	
    // Set this error as an instance variable.  There are two reasons for this:
    //    1.  So that we don't resend any more errors
    //    2.  It is needed by -finishJob::, to log performance result
    [self setError:error] ;

    // Archive to Logs.sql
	[[BkmxBasis sharedBasis] logError:error
					  markAsPresented:NO] ;
	    
    BkmxDoc* bkmxDoc = [[[NSDocumentController sharedDocumentController] documents] firstObject];
    BOOL documentIsClosedSoApparentlyNoMoreToDo = bkmxDoc == nil;
    if (
        (documentIsClosedSoApparentlyNoMoreToDo && [[BkmxBasis sharedBasis] isBkmxAgent])
        // Above, the test -isBkmxAgent is defensive programming.
        ||
        ![[error userInfo] objectForKey:constKeyDontStopOthersIfError]
        ) {
            Job* job = [error.userInfo objectForKey:constKeyJob];
            [[BkmxBasis sharedBasis] logFormat:@"Aborting this do of %@ cuz Error %ld",
             job.serialString,
             (long)error.code];
            [self abortJob:job];
    }
 }

- (void)abortJob:(Job*)job {
    /* Agent should have zero or one document open.  The zero happens if the
     document has already been closed due to an error. */
    BkmxDoc* bkmxDoc = [[[NSDocumentController sharedDocumentController] documents] firstObject];
    
    [self finishJob:job
            bkmxDoc:bkmxDoc];
}

/*!
 @brief    Returns the index of the document matching a given
 document uuid in a given BookMacster family app indicated by its bundle path

 @details  If the bundlePath parameter is nil, or if the indicated
 app has no windows open, or if the indicated document is not
 open, returns NSNotFound.

 @param    bundlePath undle Path (/path/to/App.app) of the
 app whose document's uuid is desired.  If the given app is
 not running, this function will *launch* that app, so you'd better
 make sure its running before invoking this method.  This parameter may be nil.
 @result   If the main app has open a document with the given uuid, returns
 its index in the main app's documents, starting with 0.  If the main app does
 not have open a document with the given uuid, returns NSNotFound.  If an
 error occurs, returns -1.
 */
- (NSInteger)indexOfDocumentInMainAppWithUuid:(NSString*)docUuid
                                   bundlePath:bundlePath
                                      error_p:(NSError**) error_p {
    if (!bundlePath) {
        return NSNotFound;
    }

    __block NSError* error = nil;

    NSURL* scriptUrl = nil;
    if (!error) {
        scriptUrl = [[NSBundle mainAppBundle] URLForResource:@"GetDocumentUuids"
                                               withExtension:@"scpt"
                                                subdirectory:@"AppleScripts"];

        if (!scriptUrl) {
            error = SSYMakeError(329871, @"Could not load script from app resources");
            [error retain];
        }
    }

    __block NSArray* uuids = nil;
    if (!error) {
        [SSYAppleScripter executeScriptWithUrl:scriptUrl
                                   handlerName:@"get_document_uuids"
                             handlerParameters:@[bundlePath]
                               ignoreKeyPrefix:nil
                                      userInfo:nil
                          blockUntilCompletion:YES
                               failSafeTimeout:95.55
                             completionHandler:^void(NSArray* _Nullable answers,
                                                     id _Nullable userInfo,
                                                     NSError * _Nullable scriptError) {
                                 if (scriptError) {
                                     error = SSYMakeError(329872, @"Could not get doc UUIDs from main app");
                                     error = [error errorByAddingUnderlyingError:scriptError];
                                     [error retain];
                                 } else if ([answers conformsToProtocol:@protocol(NSFastEnumeration)]) {
                                     uuids = (NSArray*)answers;
                                     [uuids retain];
                                 }
                             }];
    }

    NSInteger index = NSNotFound;
    if (!error) {
        NSInteger i = 0;
        for (NSString* uuid in uuids) {
            if ([uuid isEqualToString:docUuid]) {
                index = i;
                i++;
            }
        }
    }

    [uuids release];

    if (error) {
        index = -1;
    }

    if (error && error_p) {
        *error_p = error;
    }
    [error autorelease];

    return index;
}

- (BkmxDocumentStatusInMainApp)checkIfOpenInMainAppDocUuid:(NSString *)docUuid
                                                 jobSerial:(NSInteger)jobSerial {
    BkmxDocumentStatusInMainApp status;
    NSString* mainBundleIdentifier = [[NSBundle mainAppBundle] bundleIdentifier] ;
    NSString* mainAppRunningBundlePath = nil ;
    NSRunningApplication* runningApp = [[NSRunningApplication runningApplicationsWithBundleIdentifier:mainBundleIdentifier] lastObject] ;
    mainAppRunningBundlePath = [[runningApp bundleURL] path] ;
    [[BkmxBasis sharedBasis] forJobSerial:jobSerial
                                logFormat:@"Is main app running? %@", mainAppRunningBundlePath ? [NSString stringWithFormat:@"Yes, %@", mainAppRunningBundlePath] : @"Nope!"] ;
    
    if (mainAppRunningBundlePath) {
        NSInteger indexOfSubjectDocument = NSNotFound ;
        NSError* mainAppDocIndexingError = nil;
        indexOfSubjectDocument = [self indexOfDocumentInMainAppWithUuid:docUuid
                                                             bundlePath:mainAppRunningBundlePath
                                                                error_p:&mainAppDocIndexingError];
        if (indexOfSubjectDocument == -1) {
            [[BkmxBasis sharedBasis] logError:mainAppDocIndexingError
                              markAsPresented:NO];
            [[BkmxBasis sharedBasis] forJobSerial:jobSerial
                                        logFormat:@"Bad: Could not check doc open in main app"] ;
            status = BkmxDocumentStatusInMainAppIndeterminateDueToError;
        } else if (indexOfSubjectDocument == NSNotFound){
            status = BkmxDocumentStatusInMainAppRunningButNotOpen;
        } else {
            status = BkmxDocumentStatusInMainAppDocIsOpen;
        }
    } else {
        status = BkmxDocumentStatusInMainAppNotRunning;
    }
    return status;
}

- (void)doNowJob:(Job*)job {
    NSAssert([[BkmxBasis sharedBasis] isBkmxAgent], @"-[AgentPerformer finishJob::] abused [2]");
    
    [[BkmxBasis sharedBasis] forJobSerial:job.serial
                                logFormat:@"Dequeued \u279E Starting work Final screening"];

    /* Clear any state remaining from any previous job */
    self.error = nil;

    /* If user has just logged in recently, wait a little while.  This is
     because the system, and web browser extensions in particular, may
     take a long time to respond, causing timeout errors. */
    NSTimeInterval waitNeeded;
    NSError* loginFindError = nil;
    NSDate* loginDate = [SSYUserInfo whenThisUserLoggedInError_p:&loginFindError];
    if (loginDate) {
        [[BkmxBasis sharedBasis] forJobSerial:job.serial
                                    logFormat:@"User login was at %@", [loginDate geekDateTimeString]];
    } else {
        [[BkmxBasis sharedBasis] forJobSerial:job.serial
                                    logFormat:@"Couldn't get login time; Check 'Errors' tab"];
        [[BkmxBasis sharedBasis] logError:loginFindError
                          markAsPresented:NO];
        // Ignore the problem
        loginDate = [NSDate distantPast];
    }
    NSTimeInterval secondsSinceLogin = -[loginDate timeIntervalSinceNow];
    NSTimeInterval secondsRequiredSinceLogin = [[[NSUserDefaults standardUserDefaults] syncAndGetMainAppValueForKey:constKeyWaitAfterLogin] integerValue];
    waitNeeded = secondsRequiredSinceLogin - secondsSinceLogin;
    if (waitNeeded > 0) {
        NSString* msg = [NSString stringWithFormat:@"Shall wait %ld secs cuz recent user login", (long)waitNeeded];
        [[BkmxBasis sharedBasis] forJobSerial:job.serial
                                    logFormat:msg];
        sleep (waitNeeded);
    }

    /* If system has awakened just recently, wait a little while.  This is
     because the system, and web browser extensions in particular, may
     take a long time to respond, causing timeout errors. */
    NSError* wakeTimeError = nil;
    NSDate* wakeDate = [SSYSystemUptimer lastWakeFromSleepError_p:&wakeTimeError];
    if (wakeDate) {
        [[BkmxBasis sharedBasis] forJobSerial:job.serial
                                    logFormat:@"System wake was at %@", [wakeDate geekDateTimeString]];
    } else {
        [[BkmxBasis sharedBasis] forJobSerial:job.serial
                                    logFormat:@"Couldn't get last wake time; Check 'Errors' tab"];
        [[BkmxBasis sharedBasis] logError:wakeTimeError
                          markAsPresented:NO];
        // Ignore the problem
        wakeDate = [NSDate distantPast];
    }
    NSTimeInterval secondsSinceWake = -[wakeDate timeIntervalSinceNow];
    NSTimeInterval secondsRequiredSinceWake = [[[NSUserDefaults standardUserDefaults] syncAndGetMainAppValueForKey:constKeyWaitAfterWake] integerValue];
    waitNeeded = secondsRequiredSinceWake - secondsSinceWake;
    if (waitNeeded > 0) {
        NSString* msg = [NSString stringWithFormat:@"Shall wait %ld secs cuz recent system wake", (long)waitNeeded];
        [[BkmxBasis sharedBasis] forJobSerial:job.serial
                                    logFormat:msg];
        sleep (waitNeeded);
    }

    /* After this point, one of the following will happen:

     • No performance because an errorWhoops will have occurred
     • No performance because .bmco document found to be open in main app.
     • Performance

     In all of these cases, the action required of us by the syncer's staging
     will be all done, so we remove the staging because we do not want further
     triggers to be ignored due to "already staged".  */
    [Stager removeStagingForSyncerUri:job.syncerUri];
    [self cancelDoingDelayedJobsWithSyncerUri:job.syncerUri];
    [[BkmxBasis sharedBasis] forJobSerial:job.serial
                                logFormat:
     @"Removed any staging of syncer %d of doc %@",
     (job.syncerIndex + 1),
     [job.docUuid substringToIndex:4]];

    BOOL ok = YES;

    if (ok) {

        // Figure out who, if anyone, should do the work.

        NSString* docUuid = job.docUuid;
        NSInteger jobSerial = job.serial;
        
        BkmxDocumentStatusInMainApp status = [self checkIfOpenInMainAppDocUuid:docUuid jobSerial:jobSerial];
        
        NSString* reasonForDoWorkMyself;
        switch (status) {
            case BkmxDocumentStatusInMainAppIndeterminateDueToError:
                reasonForDoWorkMyself = @"Error! Assume main not running" ;
                [[BkmxBasis sharedBasis] forJobSerial:job.serial
                                            logFormat:@"%@ \u279E Do the work", reasonForDoWorkMyself];
                break;
            case BkmxDocumentStatusInMainAppNotRunning:
                reasonForDoWorkMyself = @"Main not running" ;
                [[BkmxBasis sharedBasis] forJobSerial:job.serial
                                            logFormat:@"%@ \u279E Do the work", reasonForDoWorkMyself];
                break;
            case BkmxDocumentStatusInMainAppRunningButNotOpen:
                reasonForDoWorkMyself = @"Main running but not subj doc" ;
                [[BkmxBasis sharedBasis] forJobSerial:job.serial
                                            logFormat:@"%@ \u279E Do the work", reasonForDoWorkMyself];
                break;
            case BkmxDocumentStatusInMainAppDocIsOpen:;
                NSString* msg = @"Main has doc open \u279E Won't sync";
                [[BkmxBasis sharedBasis] forJobSerial:job.serial
                                            logFormat:msg] ;
                NSError* error = SSYMakeError(constBkmxErrorMainAppHasDocOpenSoWontSync, msg);
                error = [error errorByAddingIsOnlyInformational];
                self.error = error;
                ok = NO;
                break;
        }
    }

    if (ok) {
        [[BkmxBasis sharedBasis] forJobSerial:job.serial
                                    logFormat:@"Commanding Syncer to perform"] ;

        [self performOverrideDeference:BkmxDeferenceUndefined
                           ignoreLimit:NO
                                   job:job
                       performanceType:BkmxPerformanceTypeAgent
                          errorAlertee:[AgentPerformer sharedPerformer]] ;
    } else {
        [[AgentPerformer sharedPerformer] finishJob:job
                                            bkmxDoc:nil];
        /* It is OK to pass bkmxDoc = nil because we have not opened any
         BkmxDoc yet and therefore there is no bkmxDoc for -finishJob::
         to worry about closing. */
    }
}

- (NSError*)addRecoverySuggestionToError:(NSError*)error {
    NSString* suggestion;
    if ([[BkmxBasis sharedBasis] isShoeboxApp]) {
        suggestion = @"Click the 'Syncing' button in the toolbar as needed to switch syncing OFF and then back ON.";
    } else {
        suggestion =
        @"Unless you have understand this to be the result of recently deleting a .bmco Collection, you should do this delete all syncers and over.  To do that\n\n"
        @"• Click in the main menu: BookMacster > Stop All Syncing Now\n"
        @"• Affirm your intent by clicking 'Kill'.\n"
        @"• Open any .bmco documents which you want to continue syncing (probably only one)\n"
        @"• Click the tab 'Settings' > 'Syncing’ and reconfigured as desired.";
    }
    error = [error errorByAddingLocalizedRecoverySuggestion:suggestion];

    return error ;
}

- (NSError*)addInfoOnSyncersInMoc:(NSManagedObjectContext*)managedObjectContext
                          macster:(Macster*)macster
                          toError:(NSError*)error {
    error = [error errorByAddingUserInfoObject:[macster shortDescription]
                                        forKey:@"Macster"];
    error = [error errorByAddingUserInfoObject:[managedObjectContext shortDescription]
                                        forKey:@"Moc"];
    error = [error errorByAddingUserInfoObject:[[managedObjectContext store1] shortDescription]
                                        forKey:@"Perrsistent Store"];
    error = [error errorByAddingUserInfoObject:[[managedObjectContext store1] URL]
                                        forKey:@"Persistent Store URL"];
    NSArray* allSyncers = [SSYMojo allObjectsForEntityName:constEntityNameSyncer
                                      managedObjectContext:managedObjectContext
                                                   error_p:NULL];
    error = [error errorByAddingUserInfoObject:@(allSyncers.count)
                                        forKey:@"Syncers, count"];
    error = [error errorByAddingUserInfoObject:allSyncers
                                        forKey:@"Syncers, all"];
    return error;
}

- (void)performOverrideDeference:(BkmxDeference)overrideDeference
                     ignoreLimit:(BOOL)ignoreLimit
                             job:(Job*)job
                 performanceType:(BkmxPerformanceType)performanceType
                    errorAlertee:(NSObject <SSYErrorAlertee> *)errorAlertee {
    BkmxDocumentController* dc = (BkmxDocumentController*)[NSDocumentController sharedDocumentController];
    [dc openDocumentWithUuid:job.docUuid
                     appName:job.appName
                     display:NO
              aliaserTimeout:40.1232
           completionHandler:^(BkmxDoc *bkmxDoc, NSURL *resolvedUrl, BOOL documentWasAlreadyOpen, NSError *error) {
               NSString* msg;
               BOOL ok = YES;

               if (error) {
                   ok = NO;
                   [[BkmxBasis sharedBasis] logError:error
                                     markAsPresented:NO];
                   [[BkmxBasis sharedBasis] forJobSerial:job.serial
                                               logFormat:
                    @"Aborting cuz Error %@ %@",
                    @(error.code),
                    error.localizedDescription];
               }

               if (ok) {
                   if (!bkmxDoc) {
                       ok = NO;
                       error = SSYMakeError(125907, @"Could not find Collection file for Syncer (which is not in Viewing Mode)") ;
                       error = [self addRecoverySuggestionToError:error];
                       error = [error errorByAddingUserInfoObject:job
                                                           forKey:constKeyJob];
                       if ([errorAlertee isKindOfClass:[AgentPerformer class]]) {
                           [(AgentPerformer*)errorAlertee registerError:error];
                       } else {
                           [errorAlertee alertError:error];
                       }
                   }
               }

               Macster* macster = [bkmxDoc macster];
               NSManagedObjectContext* managedObjectContext = [macster managedObjectContext];
               NSPersistentStoreCoordinator* persistentStoreCoordinator = [managedObjectContext persistentStoreCoordinator];

               Syncer* syncer = nil;
               if (ok) {
                   NSURL* syncerUrl = [NSURL URLWithString:job.syncerUri];
                   if (syncerUrl) {
                       NSManagedObjectID* syncerID = [persistentStoreCoordinator managedObjectIDForURIRepresentation:syncerUrl];
                       if (syncerID) {
                           syncer = [managedObjectContext objectWithID:syncerID];
                           // See Note MattGObjectID
                           if (![syncer isAvailable]) {
                               ok = NO;
                               NSString* desc = [[NSString alloc] initWithFormat:
                                                 @"Syncer %p for %@, %@ is not available",
                                                 syncer,
                                                 syncerID,
                                                 job];
                               error = SSYMakeError(125787, desc);
                               [desc release];
                               error = [self addInfoOnSyncersInMoc:managedObjectContext
                                                           macster:macster
                                                           toError:error];
                               error = [self addRecoverySuggestionToError:error] ;
                               [errorAlertee alertError:error] ;
                           }
                       } else {
                           ok = NO;
                           NSString* desc = [[NSString alloc] initWithFormat:
                                             @"No syncer with URI %@ for %@",
                                             syncerUrl,
                                             job];
                           error = SSYMakeError(125788, desc) ;
                           [desc release];
                           error = [self addInfoOnSyncersInMoc:managedObjectContext
                                                       macster:macster
                                                       toError:error];
                           error = [self addRecoverySuggestionToError:error];
                           [errorAlertee alertError:error] ;
                       }
                   } else {
                       ok = NO;
                       NSString* desc = [[NSString alloc] initWithFormat:
                                         @"No syncer with URI %@ for %@",
                                         job.syncerUri,
                                         job];
                       error = SSYMakeError(125789, desc) ;
                       [desc release];
                       error = [self addRecoverySuggestionToError:error];
                       [errorAlertee alertError:error] ;
                   }
               }

               Trigger* trigger = nil;
               if (ok) {
                   NSURL* triggerUrl = [NSURL URLWithString:job.triggerUri];
                   if (triggerUrl) {
                       NSManagedObjectID* triggerID = [persistentStoreCoordinator managedObjectIDForURIRepresentation:triggerUrl];
                       if (triggerID) {
                           trigger = [managedObjectContext objectWithID:triggerID];
                           // See Note MattGObjectID
                           if (![trigger isAvailable]) {
                               ok = NO;
                               error = SSYMakeError(125797, @"Trigger is not available") ;
                               error = [self addRecoverySuggestionToError:error];
                               [errorAlertee alertError:error] ;
                           }
                       } else {
                           ok = NO;
                           error = SSYMakeError(125798, @"No trigger ID") ;
                           error = [self addRecoverySuggestionToError:error];
                           [errorAlertee alertError:error] ;
                       }
                   } else {
                       ok = NO;
                       error = SSYMakeError(125799, @"No trigger URL") ;
                       error = [self addRecoverySuggestionToError:error];
                       [errorAlertee alertError:error] ;
                   }
               }

               if (ok) {
                   /* The next line is so that Chaker will know which agent index did the
                    changes when writing entries to Sync Log. */
                   [[AgentPerformer sharedPerformer] setActiveAgentIndex:syncer.index.integerValue];

                   [[BkmxBasis sharedBasis] forJobSerial:job.serial
                                               logFormat:
                    @"Queueing operations for %@",
                    [[bkmxDoc uuid] substringToIndex:4]];

                   /* We suspend the queue, and execute all commands.  Of course,
                    executing these commands doesn't do any work, just loads them
                    into the queue.  Then we un-suspend the queue to let the
                    actual work begin.  The suspension is necessary because
                    we modify `beginInfo` and possibly `info`, which is used by
                    the actual work, during this method.

                    Also, if an error occurs, we want it to abort all future
                    commands, which requires that all future commands already be
                    in the queue. */
                   [[bkmxDoc operationQueue] setSuspended:YES] ;
                   msg = [NSString stringWithFormat:
                          @"Befor loading, %@ ops in Queue for doc %@ %p",
                          @([[[bkmxDoc operationQueue] operations] count]),
                          [[bkmxDoc uuid] substringToIndex:4],
                          bkmxDoc];
                   [[BkmxBasis sharedBasis] forJobSerial:job.serial
                                               logFormat:msg];

                   NSArray* selectorNames ;
                   NSMutableDictionary* beginInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                     bkmxDoc, constKeyDocument,
                                                     @(performanceType), constKeyPerformanceType,
                                                     job.syncerUri, constKeyAgentUri,
                                                     @(job.syncerIndex), constKeyAgentIndex,
                                                     [bkmxDoc uuid], constKeyDocUuid,
                                                     job.serialString, constKeySerialString,
                                                     job, constKeyJob,  // may be nil
                                                     nil];

                   selectorNames = [NSArray arrayWithObjects:
                                    @"beginWork",
                                    nil] ;
                   [[bkmxDoc operationQueue] queueGroup:@"Syncer-Perform-Begin"
                                                  addon:NO
                                          selectorNames:selectorNames
                                                   info:beginInfo
                                                  block:NO
                                             doneThread:nil
                                             doneTarget:nil
                                           doneSelector:NULL
                                           keepWithNext:NO] ;

#if 0
                   // The following shows the type of nonsense needed to make sure you're reading
                   // the latest value from a Core Data store.  I used it for awhile.
                   [managedObjectContext processPendingChanges] ;
                   NSTimeInterval oldStalenessInterval = [managedObjectContext stalenessInterval] ;
                   [self managedObjectContext setStalenessInterval:0.0] ;
                   [self managedObjectContext refreshObject:self
                                               mergeChanges:NO] ;
                   // <maybe do something>
                   [managedObjectContext setStalenessInterval:oldStalenessInterval] ;
#endif

                   /* The unflaggedImportClients will have clients added during
                    imports that may need to be read during export.  Therefore,
                    we want this same mutable set to be in the dictionaries for
                    all imports and exports in this job.  So we create only one,
                    and add it to each imexInfo we create subsequently. */
                   NSMutableSet* unflaggedImportClients = [NSMutableSet set];

                   BOOL agentDoesImport = NO ;
                   BOOL agentDoesExport = NO ;
                   for (Command* command in [syncer commandsOrdered]) {
                       NSString* methodName = [command method] ;
                       id argument = [command argument] ;

                       BOOL do1 = [Command does1MethodName:methodName] ;

                       // If the command is constMethodPlaceholderImport1, constMethodPlaceholderImportAll,
                       // constMethodPlaceholderExport1 or constMethodPlaceholderExportAll,
                       // it must be swizzled into importPerInfo: or exportPerInfo:,
                       // and an 'info' argument must be constructed.
                       BOOL doSwizzleArgument = NO ;
                       // Detect constMethodPlaceholderImport1 or constMethodPlaceholderImportAll
                       if ([Command doesImportMethodName:methodName]) {
                           methodName = @"importPerInfo:" ;
                           doSwizzleArgument = YES ;
                           agentDoesImport = YES ;
                       }
                       // constMethodPlaceholderExport1 or constMethodPlaceholderExportAll
                       else if ([Command doesExportMethodName:methodName]) {
                           methodName = @"exportPerInfo:" ;
                           doSwizzleArgument = YES ;
                           agentDoesExport = YES ;
                       }

                       if (doSwizzleArgument) {
                           /* The current command is import1, importA, export1 or exportA */
                           NSMutableDictionary* imexInfo = [NSMutableDictionary dictionary] ;
                           [imexInfo setObject:bkmxDoc
                                        forKey:constKeyDocument] ;
                           [imexInfo setObject:syncer
                                        forKey:constKeySyncer] ;
                           [imexInfo setValue:job  // may be nil
                                       forKey:constKeyJob] ;
                           [imexInfo setValue:job.serialString
                                       forKey:constKeySerialString] ;
                           [imexInfo setObject:job.syncerUri
                                        forKey:constKeyAgentUri] ;
                           [imexInfo setObject:unflaggedImportClients
                                        forKey:constKeyUnflaggedImportClients];

                           // Added in BookMacster 1.7/1.6.8, in case an error occurs
                           // and Agent sends error with recovery info to Main App,
                           // Main App needs to know which trigger to re-do from scratch.
                           // Starting in BookMacster 1.9.5, trigger may be nil,
                           // to signify 'all' triggers.
                           if (job.triggerUri) {
                               [imexInfo setValue:job.triggerUri
                                           forKey:constKeyTriggerUri] ;
                           }
                           else {
                               NSLog(@"Internal Error 309-9295 %@ %@ :\n%@", [syncer shortDescription], [job shortDescription], SSYDebugBacktrace()) ;
                           }

                           if (ignoreLimit) {
                               [imexInfo setObject:[NSNumber numberWithBool:YES]
                                            forKey:constKeyIgnoreLimit] ;
                           }

                           if (job.triggerType == BkmxTriggerBrowserQuit) {
                               [imexInfo setObject:trigger.client
                                            forKey:constKeyForceStyle1Client];
                               [[BkmxBasis sharedBasis] forJobSerial:job.serial
                                                           logFormat:
                                @"Browser Quit trigger \u279E style 1 for %@",
                                [Clientoid clientoidWithClidentifier:job.clidentifier].displayName]  ;
                           }

                           if (!argument) {
                               // This is not an error.  Example: If triggerType =
                               // bookmarks changed, and trigger's client is Safari,
                               // the Import commands by default do not even have
                               // a selection in the Command's arguments popup.
                               argument = [NSNumber numberWithInteger:BkmxDeferenceUndefined] ;
                           }

                           if (![argument respondsToSelector:@selector(integerValue)]) {
                               NSString* msg = [NSString stringWithFormat:
                                                @"Detail for Command '%@' must be a number",
                                                methodName] ;
                               error = SSYMakeError(265479, msg) ;
                               error = [self addRecoverySuggestionToError:error];
                           }
                           else {
                               if (do1) {
                                   if (agentDoesImport) {
                                       Importer* triggeringImporter = [[trigger client] importer];
                                       NSArray* dirtyClidentifiers = [Stager clidentifiersNeedingImportToDocumentUuid:[bkmxDoc uuid]];
                                       NSMutableArray* dirtyImporters = [NSMutableArray new];
                                       BOOL anyDirtyClients = NO;
                                       for (NSString* clidentifier in dirtyClidentifiers) {
                                           Importer* importer = [[macster clientForClidentifier:clidentifier] importer];
                                           if (importer) {
                                               [dirtyImporters addObject:importer];
                                               [[BkmxBasis sharedBasis] forJobSerial:job.serial
                                                                           logFormat:
                                                @"Added %@ to importing queue",
                                                clidentifier];
                                               anyDirtyClients = YES;
                                           } else {
                                               [[BkmxBasis sharedBasis] forJobSerial:job.serial
                                                                           logFormat:
                                                @"Could not find client for %@ \u279e ignoring",
                                                clidentifier];
                                           }
                                       }
                                       NSString* msg = [[NSString alloc] initWithFormat:
                                                        @"%ld clients {%@} need importing",
                                                        dirtyImporters.count,
                                                        [dirtyImporters listValuesForKey:@"displayName"]];
                                       [[BkmxBasis sharedBasis] forJobSerial:job.serial
                                                                   logFormat:msg];
                                       [msg release];
                                       if ([[BkmxBasis sharedBasis] isBkmxAgent] && !anyDirtyClients) {
                                           NSString* msg = @"Syncer should import but 0 Clients need it \u279e Abort";
                                           [[BkmxBasis sharedBasis] forJobSerial:job.serial
                                                                       logFormat:msg];
                                           error = SSYMakeError(constBkmxErrorImportCommandBut0ClientsNeedIt, msg);
                                       }
                                       NSMutableSet* doOnlyImportersMutant = [NSMutableSet new];
                                       /* doOnlyImporters will be sorted to proper order in -importLaInfo */
                                       if (triggeringImporter) {
                                           [doOnlyImportersMutant addObject:triggeringImporter];
                                       }
                                       if (dirtyImporters.count > 0) {
                                           [doOnlyImportersMutant addObjectsFromArray:dirtyImporters];
                                       }
                                       [dirtyImporters release];

                                       NSSet* doOnlyImporters = nil;
                                       if (doOnlyImportersMutant.count > 0) {
                                           doOnlyImporters = [doOnlyImportersMutant copy];
                                       }
                                       [doOnlyImportersMutant release];

                                       if (doOnlyImporters) {
                                           [imexInfo setObject:doOnlyImporters
                                                        forKey:constKeyDoOnlyImportersSet];
                                       } else {
                                           /* Not setting constKeyDoOnlyImportersSet in imexInfo will
                                            cause -importLaInfo to add active importers of ALL clients. */
                                       }
                                       [doOnlyImporters release];
                                   }

                                   if (agentDoesExport) {
                                       Exporter* triggeringExporter = [[trigger client] exporter];
                                       if (triggeringExporter) {
                                           [imexInfo setObject:triggeringExporter
                                                        forKey:constKeyDoOnlyExporter];
                                       } else {
                                           /* Not setting constKeyDoOnlyExporter in imexInfo will
                                            cause -exportPerInfo to add active exporters of ALL clients. */
                                       }
                                   }
                               }

                               // Actually, this is only needed for an 'export' command,
                               // but we throw it in all commands for defensive programmming.
                               if (agentDoesImport) {
                                   [imexInfo setObject:[NSNumber numberWithBool:YES]
                                                forKey:constKeyAgentDoesImport] ;
                                   [beginInfo setObject:[NSNumber numberWithBool:YES]
                                                 forKey:constKeyAgentDoesImport] ;
                               }

                               // Calculate and set 'deference' into imexInfo
                               BkmxDeference deferenceValue = (BkmxDeference)[argument integerValue] ;
                               if (overrideDeference != BkmxDeferenceUndefined) {
                                   deferenceValue = overrideDeference  ;
                               }
                               [imexInfo setObject:[NSNumber numberWithInteger:deferenceValue]
                                            forKey:constKeyDeference] ;
                               [imexInfo setObject:[NSNumber numberWithInteger:performanceType]
                                            forKey:constKeyPerformanceType] ;

                               argument = imexInfo ;
                           }
                       }

                       SEL selector = NSSelectorFromString(methodName) ;

                       if (!error) {
                           if ([bkmxDoc respondsToSelector:selector]) {
                               [bkmxDoc performSelector:selector
                                             withObject:argument] ;
                           }
                           else {
                               NSString* msg = [NSString stringWithFormat:
                                                @"This app does not know how to do '%@'.  "
                                                @"Syncer in '%@' is corrupt or needs to be updated.  Launch the app, switch syncing OFF and then back to READY.",
                                                [command method],
                                                [bkmxDoc displayName]] ;
                               error = SSYMakeError(12908, msg) ;
                               error = [error errorByAddingUserInfoObject:[command shortDescription]
                                                                   forKey:@"Command, offending"];
                               error = [error errorByAddingUserInfoObject:@([syncer commandsOrdered].count)
                                                                   forKey:@"Commands, count"];
                               error = [error errorByAddingUserInfoObject:[[syncer commandsOrdered] shortDescription]
                                                                   forKey:@"Commands, all"];
                           }
                       }
                   }

                   if (!error) {
                       if (agentDoesExport) {
                           [bkmxDoc clearPostLandingTimer] ;
                       }

                       NSMutableDictionary* endInfo = [beginInfo mutableCopy];

                       NSMutableArray* names = [[NSMutableArray alloc] initWithArray:@[
                                                                                       @"rollUnexportedDeletions",
                                                                                       @"forgetDocumentIfItWasNotFound"
                                                                                       ]];
                       NSArray* selectorNames = [names copy];
                       [names release];

                       [[bkmxDoc operationQueue] queueGroup:constGroupNameAgentPerformEnd
                                                      addon:NO
                                              selectorNames:selectorNames
                                                       info:endInfo
                                                      block:NO
                                                 doneThread:nil
                                                 doneTarget:[SSYOperation class]
                                               doneSelector:@selector(terminateWorkInfo:)
                                               keepWithNext:NO] ;
                       [selectorNames release];
                       [endInfo release] ;

                       /* Present User Notification (alert, sound, both, or neither) */
                       NSString* title = nil;
                       NSString* subtitle = nil;
                       NSString* body = nil;
                       NSString* soundName = nil;
                       if ([[NSUserDefaults standardUserDefaults] syncAndGetMainAppBoolForKey:constKeyAlertStart]) {
                           title = @"Sync operation has started";
                           NSString* importWhatList = [Stager displayListOfClientsNeedingImportForJob:job];
                           if (importWhatList.length > 0) {
                               body = [NSString stringWithFormat:
                                       @"Importing %@",
                                       importWhatList];
                           }
                       }
                       if ([[NSUserDefaults standardUserDefaults] syncAndGetMainAppBoolForKey:constKeySoundStart]) {
                           soundName = @"BookMacsterSyncStart";
                       }
                       /* We may be in the main app here.  This can happen after
                        landing a new bookmark.  See -[BkmxAppDel considerPostLandingExportForDocumentIndex:].
                        But we do not sounds to run in the main app. */
                       if ([[BkmxBasis sharedBasis] isBkmxAgent] && (title || subtitle || body || soundName)) {
                           NSError* notifyingError = nil;
                           [BkmxNotifierCaller presentUserNotificationTitle:title
                                                             alertNotBanner:NO
                                                                   subtitle:subtitle
                                                                       body:body
                                                                  soundName:soundName
                                                                 actionDics:nil
                                                                    error_p:&notifyingError];
                           [[BkmxBasis sharedBasis] logError:notifyingError
                                             markAsPresented:NO];
                       }

                       msg = [NSString stringWithFormat:
                              @"After loading, %@ ops in Queue for doc %@ %p",
                              @([[[bkmxDoc operationQueue] operations] count]),
                              [[bkmxDoc uuid] substringToIndex:4],
                              bkmxDoc];
                        [[BkmxBasis sharedBasis] forJobSerial:job.serial
                                                    logFormat:msg];

                       [[bkmxDoc operationQueue] setSuspended:NO] ;
                   } else {
                    [self abortFalseStartForJob:job
                                        bkmsDoc:bkmxDoc
                                          error:error
                                   errorAlertee:errorAlertee];
                   }
               } else {
                   [self abortFalseStartForJob:job
                                       bkmsDoc:bkmxDoc
                                         error:error
                                  errorAlertee:errorAlertee];
               }
           }] ;
}

- (void)abortFalseStartForJob:(Job*)job
                      bkmsDoc:(BkmxDoc*)bkmxDoc
                        error:(NSError*)error
                 errorAlertee:(NSObject <SSYErrorAlertee> *)errorAlertee {
    error = [error errorByAddingUserInfoObject:job
                                        forKey:constKeyJob];
    /* True, document will be closed after the "Error has occurred" dialog
     clears, by finishJob:bkmxDoc:.  But we close it now in case user clicks
     "View", which launches the main app, which may try to open the document,
     which will fail due to file coordination if are holding it open, which
     will cause Error 257938, */
    [bkmxDoc close];
    
    if ([errorAlertee isKindOfClass:[AgentPerformer class]]) {
        [(AgentPerformer*)errorAlertee registerError:error];
    } else {
        [errorAlertee alertError:error];
    }

    if ([[BkmxBasis sharedBasis] isBkmxAgent]) {
        [self finishJob:job
                bkmxDoc:bkmxDoc];
        /* It is OK if bkmxDoc is nil because in that case we have not opened any
         BkmxDoc yet and therefore there is no bkmxDoc for -finishJob::
         to worry about closing. */
    }
}

@end

/*  Note MattGObjectID

 From https://www.cocoawithlove.com/2008/08/safely-fetching-nsmanagedobject-by-uri.html

 "But there's a catch: these methods [-managedObjectIDForURIRepresentation: and
 -objectWithID:] do not actually fetch the object from the persistent store.
 If the object doesn't exist, these methods will still succeed, giving you an
 NSManagedObjectID or NSManagedObject referencing a non-existent entry in the
 persistent store (which will throw an NSObjectInaccessibleException if you try
 to fault it). The reality is that, despite their appearance, these methods are
 for constructing object ID's, they don't search the persistent store."

 Matt suggests fetching the object at this point, and his blog post gives a
 method in a category of NSManagedObjectContext to do this.  But I think that
 my -isAvailable will is equivalent
 */

