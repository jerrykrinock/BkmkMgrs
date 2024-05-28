#import "Stager.h"
#import "Syncer.h"
#import "AgentPerformer.h"
#import "BkmxGlobals.h"
#import "Trigger.h"
#import "NSDate+Components.h"
#import "Macster.h"
#import "NSDate+NiceFormats.h"
#import "BkmxBasis+Strings.h"
#import "NSObject+MoreDescriptions.h"
#import "NSBundle+MainApp.h"
#import "NSUserDefaults+MainApp.h"
#import "NSUserDefaults+KeyPaths.h"
#import "NSUserDefaults+SSYOtherApps.h"
#import "NSUserDefaults+Bkmx.h"
#import "Client.h"
#import "Clientoid.h"
#import "Job.h"
#import "Watch.h"
#import "NSError+MyDomain.h"
#import "BkmxNotifierCaller.h"
#import "NSError+InfoAccess.h"

@implementation Stager

+ (NSInteger)bookmarksChangeDelay2 {
	NSNumber* number = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppValueForKey:constKeyBookmarksChangeDelay2] ;
	NSInteger answer = 60 ;  // Default value
	if ([number respondsToSelector:@selector(integerValue)]) {
		// Note that the above is satisifed by either a Number or a String
		// value.  We write a Number, but since this was once a hidden pref,
		// we support users that may put in a string instead.

		answer = MAX(constMinimumBookmarksChangeDelay2, [number integerValue]) ;
	}
	
	return answer ;
}

+ (NSString*)stageJob:(Job*)job
                phase:(NSString*)phase {
    Job* priorStagedJob = nil;
    NSString* didExpireMessage = nil;
    NSString* verdict;
    BOOL alreadyStaged = [Stager isAlreadyStagedSyncerUri:job.syncerUri
                                              stagedJob_p:&priorStagedJob
                                       didExpireMessage_p:&didExpireMessage];
    if (didExpireMessage)  {
        [[BkmxBasis sharedBasis] forJobSerial:job.serial
                                    logFormat:didExpireMessage];
    }

    NSString* reason;
    NSTimeInterval delay;
    switch (job.reason) {
        case AgentReasonNone:
            delay = 0.0;
            reason = @"none-WHOOPS"; // should never occur
            break;
        case AgentReasonStageSoon:
            delay = [self bookmarksChangeDelay2] ;
            reason = @"soon";
            break;
        case AgentReasonStageAsap:
            delay = 5.0 ;
            reason = @"asap";
            break;
        case AgentReasonStageRedo:
            delay = AGENT_REDO_DELAY ;
            reason = @"redo";
            break;
    }

    if (alreadyStaged) {
        NSString* msg = [NSString stringWithFormat:@"%@: Import (%@) already staged: Job %@ fireDate: %@ for Agt %ld of doc %@",
                         phase,
                         reason,
                         priorStagedJob.serialString,
                         [job.stagingFireDate hourMinuteSecond],
                         job.syncerIndex + 1,
                         [job.docUuid substringToIndex:4]] ;
        [[BkmxBasis sharedBasis] forJobSerial:job.serial
                                    logFormat:msg];
        verdict = @"already staged \u279e End";
    } else {
        NSDate* dateCreated = [NSDate date];
        NSDate* fireDate = [dateCreated dateByAddingTimeInterval:delay];
        job.dateStagingWasSet = dateCreated;
        job.stagingFireDate = fireDate;

        NSArray* keyPathArray = [NSArray arrayWithObjects:
                                 constKeyAgentStagings,
                                 job.syncerUri,
                                 nil];
        NSError* encodingError = nil;
        NSData* data = [NSKeyedArchiver archivedDataWithRootObject:job
                                             requiringSecureCoding:YES
                                                             error:&encodingError];
        if (encodingError) {
            encodingError = [SSYMakeError(constBkmxErrorEncodingJobForStaging, @"Error securely encoding Job for staging") errorByAddingUnderlyingError:encodingError];
            [[BkmxBasis sharedBasis] logError:encodingError
                              markAsPresented:NO];
            verdict = [NSString stringWithFormat:@"Error %ld occurred", (long)encodingError.code];
        } else if (data) {
            [[NSUserDefaults standardUserDefaults] setAndSyncMainAppValue:data
                                                          forKeyPathArray:keyPathArray];
            
            /* Present User Notification (alert or banner, sound, both, or neither) */
            if (delay >= 5.0) {
                NSString* title = nil;
                NSString* subtitle = nil;
                NSString* body = nil;
                NSString* soundName = nil;
                if ([[NSUserDefaults standardUserDefaults] syncAndGetMainAppBoolForKey:constKeyAlertStage]) {
                    title = [AgentPerformer notificationTitleForStaged];
                    NSInteger minutes = delay / 60.0;
                    NSInteger seconds = delay - minutes * 60;
                    if ((minutes == 1) && (seconds == 0)) {
                        /* 1:00 is ambiguous.  "60 seconds" is more understandable. */
                        minutes = 0;
                        seconds = 60;
                    }
                    NSString* when;
                    if (minutes > 0) {
                        when = [NSString stringWithFormat:
                                @"%ld:%02ld mins:secs",
                                minutes,
                                seconds];
                    } else {
                        when = [NSString stringWithFormat:
                                @"%ld seconds",
                                seconds];
                    }
                    subtitle = [NSString stringWithFormat:
                                @"will start in %@",
                                when];
                    NSString* importWhatList = [self displayListOfClientsNeedingImportForJob:job];
                    if (importWhatList.length > 0) {
                        body = [NSString stringWithFormat:
                                @"to import %@",
                                importWhatList];
                    }
                }
                if ([[NSUserDefaults standardUserDefaults] syncAndGetMainAppBoolForKey:constKeySoundStart]) {
                    soundName = @"BookMacsterSyncStage";
                }
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

            [[AgentPerformer sharedPerformer] queueJob:job
                                            afterDelay:delay];
            NSString* timeString = [[[NSDate dateWithTimeIntervalSinceNow:delay] geekDateTimeString] substringFromIndex:11];
            
            verdict = [NSString stringWithFormat:@"staged %@", reason];
            [[BkmxBasis sharedBasis] forJobSerial:job.serial
                                        logFormat:@"%@: Staged (%@) to sync at %@", phase, reason, timeString];
        } else {
            encodingError = SSYMakeError(constBkmxErrorEncodingJobForStagingUnknown, @"Unknown error securely encoding Job for staging");
            [[BkmxBasis sharedBasis] logError:encodingError
                              markAsPresented:NO];
            verdict = [NSString stringWithFormat:@"Error %ld occurred", (long)encodingError.code];
        }
    }

    return verdict;
}

+ (NSString*)displayListOfClientsNeedingImportForJob:(Job*)job {
    NSArray* clidentifiers = [self clidentifiersNeedingImportToDocumentUuid:job.docUuid];
    NSString* answer;
    if (clidentifiers.count == 1) {
        NSMutableString* importWhat = [NSMutableString new];
        for (NSString* clidentifier in clidentifiers) {
            Clientoid* clientoid = [Clientoid clientoidWithClidentifier:clidentifier];
            [importWhat appendString:clientoid.displayName];
            [importWhat appendString:@", "];
        }
        NSRange trailingCommaAndSpace = NSMakeRange(importWhat.length - 2, 2);
        [importWhat deleteCharactersInRange:trailingCommaAndSpace];
        answer = [importWhat copy];
        [importWhat release];
        [answer autorelease];
    } else {
        answer = [NSString stringWithFormat:
                  @"%ld %@",
                  clidentifiers.count,
                  [[BkmxBasis sharedBasis] labelClients]];
    }
    return answer;
}

+ (Job*)jobStagedForSyncerUri:(NSString*)syncerUri {
	NSArray* keyPathArray = [NSArray arrayWithObjects:
							 constKeyAgentStagings,
							 syncerUri,
							 nil] ;
	NSData* jobArchive = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppValueForKeyPathArray:keyPathArray] ;

    Job* job = nil;
    // Defend against corrupt prefs
	if ([jobArchive isKindOfClass:[NSData class]]) {
        NSError* decodingError = nil;
        job = [NSKeyedUnarchiver unarchivedObjectOfClass:[Job class]
                                                fromData:jobArchive
                                                   error:&decodingError];
        if (decodingError) {
            decodingError = [SSYMakeError(constBkmxErrorDecodingStagedJob, @"Error securely decoding staged Job") errorByAddingUnderlyingError:decodingError];
            [[BkmxBasis sharedBasis] logError:decodingError
                              markAsPresented:NO];
        }
	}
	
	return job;
}

/*
 Lower STAGING_TIMEOUT_SECONDS means shorter period of not detecting bookmarks
 changes after a Agent is aborted  by an error or crashes.  But if we make it
 too short, we shall get more agents if agents don't complete and clear within
 that time.  I think 20 minutes is enough.
 */
#define STAGING_TIMEOUT_SECONDS 1200.0

+ (BOOL)isAlreadyStagedSyncerUri:(NSString*)syncerUri
                     stagedJob_p:(Job**)job_p
              didExpireMessage_p:(NSString**)didExpireMessage_p {
    BOOL answer = NO;
    NSString* didExpireMessage = nil;
    Job* job = [self jobStagedForSyncerUri:syncerUri];
    if (job) {
        NSDate* fireDate = job.stagingFireDate ;
        if ([fireDate respondsToSelector:@selector(timeIntervalSinceNow)]) {
            NSTimeInterval timeIntervalSinceFireDate = -[fireDate timeIntervalSinceNow] ;
            if (timeIntervalSinceFireDate < STAGING_TIMEOUT_SECONDS) {
                answer = YES;
            }
            else {
                answer = NO;
                NSTimeInterval margin = STAGING_TIMEOUT_SECONDS - timeIntervalSinceFireDate;
                didExpireMessage = [NSString stringWithFormat:
                                    @"Expired staging by Job %@ %@ (margin %0.1f)",
                                    job.serialString,
                                    [fireDate geekDateTimeString],
                                    margin];

                /* We must remove it from user defaults, and remove its
                 ticking timer, if any, from the delayed jobs ofagent
                 performer. */
                [self removeStagingForSyncerUri:syncerUri];
                [[AgentPerformer sharedPerformer] cancelDoingDelayedJobsWithSyncerUri:(NSString *)syncerUri];
            }
        }
    }

    if (job && job_p) {
        *job_p = job;
    }

    if (didExpireMessage && didExpireMessage_p) {
        *didExpireMessage_p = didExpireMessage;
    }

    return answer ;
}

+ (void)removeStagingForSyncerUri:(NSString*)agentUri {
	if (agentUri) {
        NSObject* expectedDictionary = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppValueForKey:constKeyAgentStagings];
        if (expectedDictionary == nil) {
            // Nothing to remove from
        }
        else if ([expectedDictionary isKindOfClass:[NSDictionary class]]) {
            [[NSUserDefaults standardUserDefaults] removeAndSyncMainAppKey:agentUri
                                                       fromDictionaryAtKey:constKeyAgentStagings];
        } else {
            /* Something is wrong.  agentStagings should be a dictionary
             whose keys are syncer URI strings and whos values are
             archives of Jobs as NSData.  After running a bunch of different
             versions of BookMacster, 2.7-2.9,  in macOS 10.11, I found that
             agentStagings was instead a NSData of 135 bytes that appeared to
             be an empty archive:
             62706C69 73743030 D4010203 04050608 09582476 65727369 6F6E5824 6F626A65 63747359 24617263 68697665 72542474 6F701200 0186A0A1 0755246E 756C6C5F 100F4E53 4B657965 64417263 68697665 72D10A0B 54726F6F 74800008 111A232D 3237393F 51545900 00000000 00010100 00000000 00000C00 00000000 00000000 00000000 00005B
             Solution: Remove the whole thing because it is unuseable. */
            NSLog(@"Internal Error 523-4481.  Removing %@", expectedDictionary);
            [[NSUserDefaults standardUserDefaults] removeAndSyncMainAppKey:constKeyAgentStagings];
        }
	}
}

+ (void)removeAllStagingsExceptDocUuid:(NSString*)docUuid {
    for (NSNumber* whichAppNumber in [[BkmxBasis sharedBasis] agentableAppWhichApps]) {
        BkmxWhichApps whichApp = (BkmxWhichApps)whichAppNumber.integerValue;
        NSArray<Job*>* jobs = [[NSUserDefaults standardUserDefaults] stagedJobsForApps:whichApp];
        NSMutableSet* badJobs = [NSMutableSet new];
        NSMutableSet* goodJobs = [NSMutableSet new];
        for (Job* job in jobs) {
            if (![docUuid isEqualToString:job.docUuid]) { // always true if !docUuid
                [badJobs addObject:job];
            } else {
                [goodJobs addObject:job];
            }
        }
        
        if (badJobs.count > 0) {
            // It is easier to start from scratch
            //NSString* appName = [[BkmxBasis sharedBasis] appNameForApps:whichApp];
            NSString* bundleIdentifier = [[BkmxBasis sharedBasis] bundleIdentifiersForApps:whichApp].anyObject;
            [[NSUserDefaults standardUserDefaults] removeAndSyncKey:constKeyAgentStagings
                                                      applicationId:bundleIdentifier];

            for (Job* job in goodJobs) {
                NSArray* keyPathArray = [NSArray arrayWithObjects:
                                         constKeyAgentStagings,
                                         job.syncerUri,
                                         nil];
                NSError* error = nil;
                NSData* data = [NSKeyedArchiver archivedDataWithRootObject:job
                                                     requiringSecureCoding:YES
                                                                     error:&error];
                if (error) {
                    NSLog(@"Internal Error 848-3284 %@", error);
                }
                [[NSUserDefaults standardUserDefaults] setAndSyncMainAppValue:data
                                                              forKeyPathArray:keyPathArray];
            }
        } else {
            // Only one job, and it is good.  There is nothing to do.
        }
        [badJobs release];
        [goodJobs release];
    }
}

+ (BOOL)needsImportClidentifier:(NSString*)clidentifier
                 toDocumentUuid:(NSString*)documentUuid {
    NSArray* keyPathArray = @[
                              constKeyClientsDirt,
                              documentUuid,
                              clidentifier];
    NSDate* date = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppValueForKeyPathArray:keyPathArray];
    BOOL needsImport;
    if (!date) {
        needsImport = NO;
    } else if (![date respondsToSelector:@selector(timeIntervalSinceNow)]) {
        // Defensive programming
        [[BkmxBasis sharedBasis] logFormat:@"Error in Stager: expected NSDate, got %@: %@", date.className, date] ;
        needsImport = YES;
    } else {
        /* Until BkmkMgrs 2.9.1, we checked the date here to insure that
         the the staging timeout had not been exceeded and if so cleared
         the client dirt.  But that broke the new resuscitate feature
         because when the resuscitated job began to perform it would find
         that 0 clients needed importing. */
        needsImport = YES;
    }

    return needsImport;
}

+ (void)setNeedsImportClidentifier:(NSString*)clidentifier
                    toDocumentUuid:(NSString*)documentUuid {
    NSArray* keyPathArray = @[
                              constKeyClientsDirt,
                              documentUuid,
                              clidentifier];
    [[NSUserDefaults standardUserDefaults] setAndSyncMainAppValue:[NSDate date]
                                                  forKeyPathArray:keyPathArray];
}

+ (NSArray*)clidentifiersNeedingImportToDocumentUuid:(NSString*)documentUuid {
    NSDictionary* datesByClidentifier = nil;
    if (documentUuid) {
        NSArray* keyPathArray = @[
                                  constKeyClientsDirt,
                                  documentUuid];
        datesByClidentifier = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppValueForKeyPathArray:keyPathArray];
    } else {
        datesByClidentifier = @{};
    }

    return [datesByClidentifier allKeys];
}

+ (BOOL)clearNeedsImportClient:(Client*)client
                toDocumentUuid:(NSString*)documentUuid {
    NSArray* keyPathArray = @[
                              constKeyClientsDirt,
                              documentUuid];
    NSDictionary* datesByClidentifier = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppValueForKeyPathArray:keyPathArray];
    BOOL anythingToRemove = [datesByClidentifier count] > 0;
    if (anythingToRemove) {
        [[NSUserDefaults standardUserDefaults] removeAndSyncMainAppKey:[[client clientoid] clidentifier]
                                          fromDictionaryAtKeyPathArray:keyPathArray];
    }

    /* Remove the whole dictionary for this document, if it is now empty.
     For fail-safe cleanliness, we check this regardless of whether or not
     we removed anything. */
    if ([[self clidentifiersNeedingImportToDocumentUuid:documentUuid] count] == 0) {
        [[NSUserDefaults standardUserDefaults] removeAndSyncMainAppKey:documentUuid
                                          fromDictionaryAtKeyPathArray:@[constKeyClientsDirt]];
    }

    return anythingToRemove;
}

+ (BOOL)anyAppIsWatchingPath:(NSString*)path {
    NSSet* watches = [[NSUserDefaults standardUserDefaults] watchesForApps:BkmxWhichAppsAny];
   for (Watch* watch in watches) {
        if (watch.watchType == WatchTypePathTouched) {
            NSString* subjectPath = (NSString*)watch.subject;
            if ([subjectPath isKindOfClass:[NSString class]]) {
                if ([subjectPath isEqualToString:path]) {
                    return YES;
                }
            }
        }
    }

    return NO;
}

@end
