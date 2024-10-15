#import <Bkmxwork/Bkmxwork-Swift.h>
#import "TriggHandler.h"
#import "BkmxBasis.h"
#import "Watch.h"
#import "Watcher.h"
#import "Bookshig.h"
#import "AgentPerformer.h"
#import "NSError+InfoAccess.h"
#import "NSError+MyDomain.h"
#import "NSError+SSYInfo.h"
#import "NSDocumentController+DisambiguateForUTI.h"
#import "NSArray+Stringing.h"
#import "BkmxBasis+Strings.h"
#import "NSUserDefaults+Bkmx.h"
#import "Client.h"
#import "Syncer.h"
#import "Trigger.h"
#import "Job.h"
#import "NSDate+NiceFormats.h"
#import "Macster.h"
#import "BkmxDocumentController.h"
#import "NSError+LowLevel.h"
#import "NSString+TimeIntervals.h"
#import "NSObject+MoreDescriptions.h"
#import "Extore.h"
#import "NSFileManager+SomeMore.h"
#import "Stager.h"
#import "NSString+MorePaths.h"
#import "NSArray+BSJSONAdditions.h"
#import "NSArray+SortDescriptorsHelp.h"
#import "SSYRunLoopTickler.h"
#import "NSUserDefaults+KeyPaths.h"
#import "NSError+Bkmx.h"
#import "Importer.h"
#import "BSManagedDocument+SSYAuxiliaryData.h"
#import "Stark.h"
#import "Starker.h"
#import "NSBundle+SSYMotherApp.h"
#import "NSBundle+MainApp.h"
#import "NSDate+NiceFormats.h"
#import "NSUserDefaults+MainApp.h"
#import "SSYOtherApper.h"
#import "NSString+Truncate.h"
#import "NSString+SSYDotSuffix.h"
#import "SSYUserInfo.h"
#import "SSYSystemUptimer.h"


enum BkmxShouldCheckLastSaveToken_enum {
    BkmxShouldCheckLastSaveTokenNo = 0,
    BkmxShouldCheckLastSaveTokenOnlyIfEfficient = 1,
    BkmxShouldCheckLastSaveTokenUnconditionally = 2
};
typedef enum BkmxShouldCheckLastSaveToken_enum BkmxShouldCheckLastSaveToken;


@implementation NSString (BkmxLast2)

- (NSString*)last2PathComponents {
    NSString* last = [self lastPathComponent];
    NSString* answer = [[self stringByDeletingLastPathComponent] lastPathComponent];
    if ([answer length] > 0) {
        answer = [answer stringByAppendingString:@"/"];
    }
    answer = [answer stringByAppendingString:last];
    
    return answer;
}


@end


NSString* constStringMessedWithAppSupport = @"Files in Home's Library/Application Support/BookMacster, or maybe BookMacster's Preferences file, were changed behind BookMacster's back.";
NSString* constStringResetSettings = @"Open your Collection(s) in BookMacster.  While you're in there, click Settings > Open/Save, Clients and Syncing, and re-set any missing values.";
NSString* constStringSpaceQuitSuffix = @" quit";

@interface TriggHandler ()
@end

@implementation TriggHandler

+ (NSError*)makeErrorWithCode:(NSInteger)code
                  description:(NSString*)description {
    NSString* localizedDescription = NSLocalizedString(description, nil);
    return SSYMakeError(code, localizedDescription);
}

+ (NSString*)pathForDocumentUuid:(NSString*)docUuid
                         appName:(NSString*)appName
                         error_p:(NSError**)error_p {
    NSError* error = nil;
    NSString* path = [[NSDocumentController sharedDocumentController] pathOfDocumentWithUuid:docUuid
                                                                                     appName:appName
                                                                                     timeout:30.0
                                                                                      trials:6
                                                                                       delay:10
                                                                                     error_p:&error];
    if (!path) {
        [[BkmxBasis sharedBasis] forJobSerial:0
                                    logFormat:
         @"Aborting because %@ can't be found.",
         [docUuid substringToIndex:4]];
        
        // Added in BookMacster 1.21.2
        NSString* msg = [NSString stringWithFormat:
                         @"Could not locate document which reportedly needs syncing attention.  "
                         @"To prevent recurrence, its syncing has been switched off.\n\n"
                         @"Syncing will be switched back on automatically if you can restore and open your document in %@.",
                         [[BkmxBasis sharedBasis] appNameLocalized]];
        error = [SSYMakeError(441059, msg) errorByAddingUnderlyingError:error];
        error = [error errorByAddingUserInfoObject:docUuid
                                            forKey:@"Doc UUID"];
        // The above error code will never be seen because the caller will
        // change it.
        
        // Starting with BookMacster 1.21.2, we do not remove Syncers here
        // because that would kill us if we are in BkmxAgent.  We need to stay
        // alive until the user dismisses the CFAlert dialog.  Instead, we do so
        // at the end of main().
    }
    
    if (error && error_p) {
        *error_p = error;
    }
    return path;
}

+ (BOOL)documentIsSameWithUuid:(NSString*)uuid
                       appName:(NSString*)appName
                       error_p:(NSError**)error_p {
    BOOL answer = NO;
    NSError* error = nil;
    NSString* path = [TriggHandler pathForDocumentUuid:uuid
                                               appName:appName
                                               error_p:&error];
    if (path) {
        NSArray* keyPathArray = [NSArray arrayWithObjects:
                                 constKeyDocLastSaveToken,
                                 uuid,
                                 nil];
        NSString* prefsLastSaveToken = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppValueForKeyPathArray:keyPathArray];
        NSString* docLastSaveToken = [BSManagedDocument auxiliaryObjectForKey:constKeyDocLastSaveToken
                                                          documentPackagePath:path];
#if 0
#warning Logging Syncer lastSaveToken comparisons
        {
            NSString* msg;
            msg = [NSString stringWithFormat:@"Comparing dLSTokens:"];
            [[BkmxBasis sharedBasis] forJobSerial:0
                                        logFormat:msg];
            msg = [NSString stringWithFormat:@"  dLSToken: %@ in prefs", prefsLastSaveToken];
            [[BkmxBasis sharedBasis] forJobSerial:0
                                        logFormat:msg];
            msg = [NSString stringWithFormat:@"  dLSToken %@ in doc aux data", docLastSaveToken];
            [[BkmxBasis sharedBasis] forJobSerial:0
                                        logFormat:msg];
        }
#endif
        answer = [prefsLastSaveToken isEqualToString:docLastSaveToken];
    } else {
        error = [SSYMakeError(18004, @"Could not find document") errorByAddingUnderlyingError:error];
    }
    
    if (error && error_p) {
        *error_p = error;
        answer = NO;
    }
    
    return answer;
}

#if DEBUG
+ (BOOL)persistForDebugDiffsInDetectedChanges:(NSArray*)detectedChanges
                          lastExportedChanges:(NSDictionary*)lastExportedChanges
                           exformatDotProfile:(NSString*) exformatDotProfile
                                      error_p:(NSError**)error_p {
#if 0
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSApplicationSupportDirectory,
                                                         NSUserDomainMask,
                                                         YES
                                                         );
    NSString* path = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    path = [appSupportPath stringByAppendingPathComponent:@"BookMacster"];
#endif
    
    NSString* path = [[NSBundle mainBundle] applicationSupportPathForMotherApp];
    
    BOOL ok;
    NSError* error = nil;
    
    path = [path stringByAppendingPathComponent:@"Changes"];
    path = [path stringByAppendingPathComponent:@"DiffsFoundVsLastExport"];
    path = [path stringByAppendingPathComponent:exformatDotProfile];
    
    // Ensure existence of parent directory
    ok = [[NSFileManager defaultManager] createDirectoryAtPath:path
                                   withIntermediateDirectories:YES
                                                    attributes:nil
                                                         error:&error];
    
    if (ok) {
        // Append filename
        path = [path stringByAppendingPathComponent:[[NSDate date] compactDateTimeString]];
        path = [path stringByAppendingPathExtension:@"txt"];
        
        NSString* payload = [[NSString alloc] initWithFormat:
                             @"Differences were found in Detected vs. Last Exported changes\n\n"
                             @"*** Detected ***\n%@\n"
                             @"*** Last Exported ***\n%@\n",
                             detectedChanges,
                             lastExportedChanges];
        
        ok = [payload writeToFile:path
                       atomically:YES
                         encoding:NSUTF8StringEncoding
                            error:&error];
        [payload release];
    }
    
    if (error && error_p) {
        *error_p = error;
    }
    
    return ok;
}
#endif

#define RESPAWN_MARGIN_SECONDS 2.0

/*
 This method was to filter out those false alarms produced
 by launchd WatchPaths.  We no longer use launchd WatchPaths, but use kqueue
 instead.  I do no know whether or not the kqueue detection now in
 use will produce the same false alarms.
 */
+ (BOOL)isSpuriousLaunchTriggerPath:(NSString*)triggerPath {
    NSDate* triggerFileModificationDate = [[NSFileManager defaultManager] modificationDateForPath:triggerPath];
    BOOL answer = NO;
    if (triggerFileModificationDate) {
        // This trigger handler was created by a watched file change
        NSTimeInterval timeSinceLastTouch = -[triggerFileModificationDate timeIntervalSinceNow];
        // A false trigger caused by Apple Bug ID# 9858248 will respawn *after*
        // either the launchd ThrottleInterval, or, I just saw now, 46 minutes
        // later.
        if (timeSinceLastTouch > ([Stager bookmarksChangeDelay2] - RESPAWN_MARGIN_SECONDS)) {
            // This is spurious trigger by launchd
            answer = YES;
        }
    }
    
    return answer;
}

- (void)logSpuriousChanger:(NSString*)spuriousChanger
                 jobSerial:(NSInteger)jobSerial {
    if (spuriousChanger) {
        NSString* message = [NSString stringWithFormat:
                             @"Ignored spurious %@",
                             spuriousChanger];
        [[BkmxBasis sharedBasis] forJobSerial:jobSerial
                                    logFormat:message];
    }
}

#if 0
#warning Saving Detected & Exported Change files to desktop, not deleting the former
#define SAVE_DETECTED_AND_EXPORTED_CHANGE_FILES_FOR_DEBUGGING 1
#endif


- (void)handleTriggerForWatch:(Watch*)watch
                 triggerCause:(NSString*)triggerCause {
    BOOL ok;

    NSString* creator = [NSString stringWithFormat:
                         @"%@ %@",
                         constAppNameBkmxAgent,
                         watch];
    NSInteger jobSerial = [[NSUserDefaults standardUserDefaults] nextJobSerialforCreator:creator];
    
    NSError* cannotRunAppError = nil;
    ok = [[BkmxBasis sharedBasis] checkNoSiblingAppsRunningError_p:&cannotRunAppError] ;
    if (!ok) {
        [[AgentPerformer sharedPerformer] registerError:cannotRunAppError] ;
        [[BkmxBasis sharedBasis] logError:cannotRunAppError
                          markAsPresented:NO];
        [self endJobSerial:jobSerial
                     watch:watch
                   verdict:@"cannot run app"];
        return;
    }
    
    [[BkmxBasis sharedBasis] checkAndHandleAppExpirationOrUpdate:^{
        [self processTriggerForWatch:watch
                        triggerCause:triggerCause
                           jobSerial:jobSerial];
    }];
}

- (void)processTriggerForWatch:(Watch*)watch
                  triggerCause:(NSString*)triggerCause
                     jobSerial:(NSInteger)jobSerial {

    /* Here are the possible forms of triggerCause…
     Case Note Trigger Type           AgentReason           Example triggerCause string, some from +[Trigger causeStringForType:]
     ---- ---- ------------           -----------           ---------------------------------------
     11   21.  BkmxTriggerLogIn       AgentReasonStageSoon  User logged in
     12   22.  BkmxTriggerBrowserQuit AgentReasonStageAsap  Firefox quit
     13   21.  BkmxTriggerScheduled   AgentReasonStageAsap  Scheduled
     14   21.  BkmxTriggerSawChange   AgentReasonStageSoon  /Users/jk/Library/Safari/Bookmarks.plist
     15   21.  BkmxTriggerSawChange   AgentReasonStageSoon  /Users/jk/Library/Application Support/BookMacster/Detected/ExtoreChrome.<profileName>
     16   21.  BkmxTriggerCloud       AgentReasonStageAsap  /Users/jk/Cloud/Dropbox/MyBkmxDoc.<documentExtension>
     17   21.  BkmxTriggerPeriodic    AgentReasonStageAsap  Periodic

     Note 21.  See -[Trigger launchdAgentDic].
     Note 22.  See -[SSYOtherAppObserver handleAppQuit:].
     */

    AgentReason syncerReason = AgentReasonNone;
    BkmxShouldCheckLastSaveToken shouldCheckLastSaveToken = BkmxShouldCheckLastSaveTokenNo;
    BOOL shouldCheckHash = NO;

    BkmxTriggerType triggerType = BkmxTriggerImpossible;
    if ([triggerCause hasPrefix:@"/"]) {
        // Case 14, 15 or 16
        syncerReason = AgentReasonStageSoon;
        if ([triggerCause pathIsDescendantOf:[[BkmxBasis sharedBasis] detectedChangesPath]]) {
            // Case 15
            triggerType = BkmxTriggerSawChange;
            NSArray* changeFilenames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:triggerCause
                                                                                           error:NULL];
            changeFilenames = [changeFilenames arraySortedByKeyPath:nil];
            NSString* exformatDotProfile = [triggerCause lastPathComponent];

            // I was expecting to be retriggered by launchd a minute later,
            // after detecting a change in Firefox or Chrome, by our deleting
            // of the change file(s), below.  So I added the following section to
            // filter those out in BookMacster 1.11.
            // Note: Prior to BookMacster 1.11, a similar purpose was served by
            // checking the modification date of the .sawChange file.  That was
            // not supposed to happen, but it did.  This *is* supposed to happen,
            // but it's not happening.  Possibly the explanation is that there is
            // a delay before launchd WatchPaths reactivates.  I may have filed
            // a bug in Apple Bug Reporter on that.
            if ([changeFilenames count] == 0) {
                [self logSpuriousChanger:[NSString stringWithFormat:
                                          @"%@ (0 change files in %@)",
                                          exformatDotProfile,
                                          triggerCause]
                               jobSerial:jobSerial];
                [self endJobSerial:jobSerial
                             watch:watch
                           verdict:@" 0 change files"];
                return;
            }

            NSString* exformat = [[exformatDotProfile componentsSeparatedByString:@"."] firstObject];
            Class extoreClass = [Extore extoreClassForExformat:exformat];

            /* The following section compares the Changes file just written by
             our browser extension, which caused this TriggHandler instance,
             with changes remembered from the Last Export, to see if this is a
             spurious change, that extension is just detecting our last export.

             Despite the fact that this section took a lot of programming
             effort, it is still pretty leaky – there are a lot of changes
             which are in fact the extension detecting our last export, which
             are not caught, and we end up having to compare hashes anyhow.

             Leak Example 1.  Folder of 20 bookmarks in Chrome.  We export a
             change to move the item at index 19 to index 10.  Our Last Export
             file contains change items for each item moved, or maybe even
             those not moved.  However, the Changes Detected file produced by
             the browser extension (driven by change notifications from Chrome
             itself) contains only one change.

             Leak Example 2.  Export a deletion to Opera.  The Changes
             Detected file will show that this item, instead of being deleted,
             has been moved to the Trash.  This is true, although it is a
             deletion for our purposes since we ignore Opera's Trash.

             Leak Example 2 could be fixed with some more code, overriding
             +[ExtoreOpera detectedChanges:notInExportedChanges:].  But
             Leak Example 1 could not be fixed without knowledge of all of the
             items in that folder, which requires reading the bookmarks, and
             at that point you may as well calculate the hash. */
            BOOL doDetectChanges = [extoreClass canDetectOurChanges];
            NSMutableArray* detectedChanges;
            BOOL weHaveChanges = YES;
            BOOL didCompareWithLastExport = NO;
            NSInteger nIgnoredFaviconChanges = 0;
            if (doDetectChanges) {
                // Read in and process changes
                detectedChanges = [[NSMutableArray alloc] init];
                NSArray* keyPathArray = [NSArray arrayWithObjects:
                                         constKeyLastJsonExport,
                                         exformatDotProfile,
                                         nil];
                NSNumber* lastJsonExportObject = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppValueForKeyPathArray:keyPathArray];
                NSUInteger lastJsonExport = 0;
                if ([lastJsonExportObject respondsToSelector:@selector(unsignedLongValue)]) {
                    lastJsonExport = [lastJsonExportObject unsignedIntegerValue];
                }
                BOOL lastExportIsStillTimely = YES;
                for (NSString* filename in changeFilenames) {
                    NSString* path = [triggerCause stringByAppendingPathComponent:filename];
                    NSString* fileDateString = [filename stringByDeletingDotSuffix];
                    NSInteger fileDateSeconds = [fileDateString integerValue];
                    if (fileDateSeconds - lastJsonExport < 30) {
                        /* In case this export took more than 10 seconds, its
                         changes will appear in multiple changes files, so we
                         shift the time threshold for the next one later to
                         start at the export time of this one. */
                        if (fileDateSeconds > lastJsonExport) {
                            lastJsonExport = fileDateSeconds;
                        }
                        /* The above is done conditionally because: if a
                         changes file from the client did not get processed due
                         to an error, the lastJasonExport may be later.  We
                         still want to process it now, but we don't want to
                         move lastJsonExport earlier. */
                        lastExportIsStillTimely = YES;
                    }
                    else {
                        lastExportIsStillTimely = NO;
                    }

                    NSString* jsonString = [NSString stringWithContentsOfFile:path
                                                                     encoding:NSUTF8StringEncoding
                                                                        error:NULL];
                    if (jsonString) {
                        NSArray* someChanges = [NSArray arrayWithJSONString:jsonString
                                                                 accurately:NO];
                        for (NSDictionary* aChange in someChanges) {
                            NSString* property = [aChange valueForKey:@"property"];
                            NSString* changeType = [aChange valueForKey:@"changeType"];
                            if (property) {
                                // This happens for changes of type "changed" in Firefox`
                                if ([property respondsToSelector:@selector(isEqualToString:)]) {
                                    if (![property isEqualToString:@"favicon"]) {
                                        [detectedChanges addObject:aChange];
                                    }
                                    else {
                                        nIgnoredFaviconChanges++;
                                    }
                                }
                                else {
                                    NSLog(@"Internal Error 624-9589 key is %@", NSStringFromClass([property class]));
                                }
                            }
                            else if (changeType){
                                /*
                                 This happens for Firefox OR Chrome changes of
                                 types 'created', 'moved', 'changed' or 'removed'.
                                 and also the Firefox non-changes
                                 'beginUpdateBatch' and 'endUpdateBatch' and
                                 Chromy non-changes 'importBegan' and
                                 'importEnded'.
                                 */
                                if ([changeType respondsToSelector:@selector(isEqualToString:)]) {
                                    if ([changeType isEqualToString:@"created"]) {
                                        [detectedChanges addObject:aChange];
                                    }
                                    else if ([changeType isEqualToString:@"moved"]) {
                                        [detectedChanges addObject:aChange];
                                    }
                                    else if ([changeType isEqualToString:@"removed"]) {
                                        [detectedChanges addObject:aChange];
                                    }
                                    // The following was added as bug fix in BookMacster 1.19.7
                                    else if ([changeType isEqualToString:@"changed"]) {  // Example: Bookmark renamed.
                                        [detectedChanges addObject:aChange];
                                    }
                                    else if ([changeType isEqualToString:@"beginUpdateBatch"]) {
                                        // ignore (Firefox)
                                    }
                                    else if ([changeType isEqualToString:@"endUpdateBatch"]) {
                                        // ignore (Firefox)
                                    }
                                    else if ([changeType isEqualToString:@"importBegan"]) {
                                        // ignore (Chromy)
                                    }
                                    else if ([changeType isEqualToString:@"importEnded"]) {
                                        // ignore (Chromy)
                                    }
                                    else {
                                        NSLog(@"Internal Error 624-9622 changeType=%@", changeType);
                                        // ignore
                                    }
                                }
                            }
                            else {
                                NSLog(@"Internal Error 692-02399 %@", aChange);
                            }
                        }
                    }
                }

                // In case this is the last file in this trigger, but
                // there are more to follow in the next trigger,
                [[NSUserDefaults standardUserDefaults] setAndSyncMainAppValue:[NSNumber numberWithUnsignedInteger:lastJsonExport]
                                                              forKeyPathArray:keyPathArray];

                weHaveChanges = ([detectedChanges count] > 0);
                if (weHaveChanges && lastExportIsStillTimely) {
                    // triggerCause is, for example, ...BookMacster/Changes/Detected/Firefox.default
                    NSString* lastExportedChangesPath = [[triggerCause stringByDeletingLastPathComponent] stringByDeletingLastPathComponent];
                    // lastExportedChangesPath is, for example, ...BookMacster/Changes
                    lastExportedChangesPath = [lastExportedChangesPath stringByAppendingPathComponent:@"Exported"];
                    // lastExportedChangesPath is, for example, ...BookMacster/Changes/Exported
                    lastExportedChangesPath = [lastExportedChangesPath stringByAppendingPathComponent:exformatDotProfile];
                    // lastExportedChangesPath is, for example, ...BookMacster/Changes/Exported/Firefox.default
                    lastExportedChangesPath = [lastExportedChangesPath stringByAppendingPathExtension:@"json"];
                    // lastExportedChangesPath is, for example, ...BookMacster/Changes/Exported/Firefox.default.json
#if SAVE_DETECTED_AND_EXPORTED_CHANGE_FILES_FOR_DEBUGGING
                    if (lastExportedChangesPath) {
                        NSString* debugPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Desktop"];
                        debugPath = [debugPath stringByAppendingPathComponent:@"Bkmx-Detected-Change-Diffs"];
                        [[NSFileManager defaultManager] createDirectoryAtPath:debugPath
                                                  withIntermediateDirectories:YES
                                                                   attributes:nil
                                                                        error:NULL];
                        NSString* dateString = [[NSDate date] compactDateTimeString];
                        NSString* debugFilename = [[[[[lastExportedChangesPath lastPathComponent] stringByDeletingPathExtension] stringByAppendingString:@"+"] stringByAppendingString:dateString] stringByAppendingPathExtension:@"json"];
                        debugPath = [debugPath stringByAppendingPathComponent:debugFilename];
                        [[NSFileManager defaultManager] copyItemAtPath:lastExportedChangesPath
                                                                toPath:debugPath
                                                                 error:NULL];
                    }
#endif
                    NSData* lastExportedChangesData = [NSData dataWithContentsOfFile:lastExportedChangesPath];
                    if (lastExportedChangesData) {
                        NSDictionary* lastExportedChanges = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:lastExportedChangesData
                                                                                                    options:BkmxBasis.optionsForNSJSON
                                                                                                  error:NULL];

                        // Exported Changes may need to be corrected with Exid Feedback
                        NSString* exidFeedbackPath = [lastExportedChangesPath stringByDeletingLastPathComponent];
                        // exidFeedbackPath is, for example, ...BookMacster/Changes/Exported
                        exidFeedbackPath = [exidFeedbackPath stringByDeletingLastPathComponent];
                        // exidFeedbackPath is, for example, ...BookMacster/Changes
                        exidFeedbackPath = [exidFeedbackPath stringByAppendingPathComponent:@"ExidFeedback"];
                        // exidFeedbackPath is, for example, ...BookMacster/Changes/ExidFeedback
                        exidFeedbackPath = [exidFeedbackPath stringByAppendingPathComponent:exformatDotProfile];
                        // exidFeedbackPath is, for example, ...BookMacster/Changes/ExidFeedback/Firefox.default
                        exidFeedbackPath = [exidFeedbackPath stringByAppendingPathExtension:@"json"];
                        // exidFeedbackPath is, for example, ...BookMacster/Changes/ExidFeedback/Firefox.default.json
                        NSData* exidFeedbackData = [NSData dataWithContentsOfFile:exidFeedbackPath];
                        if (exidFeedbackData) {
                            NSDictionary* exidFeedbackDic = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:exidFeedbackData
                                                                                                           options:BkmxBasis.optionsForNSJSON
                                                                                                             error:NULL];
                            if (exidFeedbackDic) {
                                NSMutableArray* fixedPuts = [[NSMutableArray alloc] init];
                                for (NSDictionary* put in [lastExportedChanges objectForKey:@"puts"]) {
                                    NSString* exid = [put objectForKey:@"exid"];
                                    NSString* correctedExid = [exidFeedbackDic objectForKey:exid];
                                    if (correctedExid) {
                                        NSMutableDictionary* fixedPut = [put mutableCopy];
                                        [fixedPut setObject:correctedExid
                                                     forKey:@"exid"];
                                        [fixedPuts addObject:fixedPut];
                                        [fixedPut release];
                                    } else {
                                        /* Only newly-inserted items get exid
                                         feedback.  This put is apparently
                                         repair of an existing item. */
                                        [fixedPuts addObject:put];
                                    }
                                }

                                // Defensive programming
                                NSArray* cuts = [lastExportedChanges objectForKey:@"cuts"];
                                if (!cuts) {
                                    cuts = [NSArray array];
                                }

                                lastExportedChanges = [NSDictionary dictionaryWithObjectsAndKeys:
                                                       fixedPuts, @"puts",
                                                       cuts, @"cuts",
                                                       [lastExportedChanges objectForKey:@"repairs"], @"repairs",
                                                       nil];
                                [fixedPuts release];
                            }
                        }

                        // Compare detectedChanges to lastExportedChanges
                        weHaveChanges = [extoreClass detectedChanges:detectedChanges
                                                notInExportedChanges:lastExportedChanges];
#if DEBUG
                        if (weHaveChanges) {
                            NSError* debugWriteError = nil;
                            BOOL debugWriteOk = [TriggHandler persistForDebugDiffsInDetectedChanges:detectedChanges
                                                                                lastExportedChanges:lastExportedChanges
                                                                                 exformatDotProfile:exformatDotProfile
                                                                                            error_p:&debugWriteError];
                            if (!debugWriteOk) {
                                [[BkmxBasis sharedBasis] forJobSerial:jobSerial
                                                            logFormat:@"Error writing diffs for debug: %@", [debugWriteError description]];
                            }
                        }
#endif
                        didCompareWithLastExport = YES;
                    }
                    else {
                        NSLog(@"Internal Error 526-9389 No last exported changes data at expected path %@", lastExportedChangesPath);
                    }
                }

                [detectedChanges release];
            }

            /* Delete all the change files which have now been processed.   (It
             is tempting to simply remove the whole Changes/Detected/ExtoreName
             subdirectory, but that might cause trouble if the extension was
             attempting to write a new changes json file simultaneously. */
            for (NSString* filename in changeFilenames) {
                NSString* path = [triggerCause stringByAppendingPathComponent:filename];
                NSError* removeChangeError = nil;
#if SAVE_DETECTED_AND_EXPORTED_CHANGE_FILES_FOR_DEBUGGING
                NSString* debugPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Desktop"];
                debugPath = [debugPath stringByAppendingPathComponent:@"Bkmx-Detected-Change-Diffs"];
                [[NSFileManager defaultManager] createDirectoryAtPath:debugPath
                                          withIntermediateDirectories:YES
                                                           attributes:nil
                                                                error:NULL];
                NSString* dateString = [[NSDate date] compactDateTimeString];
                NSString* debugFilename = [[[[[path lastPathComponent] stringByDeletingPathExtension] stringByAppendingString:@"+"] stringByAppendingString:dateString] stringByAppendingPathExtension:@"json"];
                debugPath = [debugPath stringByAppendingPathComponent:debugFilename];
                BOOL removeChangeOk = [[NSFileManager defaultManager] moveItemAtPath:path
                                                                              toPath:debugPath
                                                                               error:&removeChangeError];
#else
                BOOL removeChangeOk = [[NSFileManager defaultManager] removeItemAtPath:path
                                                                                 error:&removeChangeError];
#endif
                if (!removeChangeOk) {
                    NSLog(@"Internal Error 624-8772 %@ %@", removeChangeError, path);
                }
            }

            triggerCause = exformatDotProfile;

            if (!weHaveChanges) {
                [self logSpuriousChanger:[NSString stringWithFormat:
                                          @"%@ (%@)",
                                          exformatDotProfile,
                                          didCompareWithLastExport ? @"changes == last export" : @"0 changes to compare"]
                               jobSerial:jobSerial];
                [self endJobSerial:jobSerial
                             watch:watch
                           verdict:@"no changes found"];
                return;
            }
            else if (nIgnoredFaviconChanges > 0) {
                [self logSpuriousChanger:[NSString stringWithFormat:
                                          @"%@ %ld favicon changes",
                                          exformatDotProfile,
                                          (long)nIgnoredFaviconChanges]
                               jobSerial:jobSerial];
                [self endJobSerial:jobSerial
                             watch:watch
                           verdict:@"only favicon changes"];
                return;
            } else {
                [[BkmxBasis sharedBasis] forJobSerial:jobSerial
                                            logFormat:
                 @"Can't discount detected changes using last exported \u279e Check hash"];
                shouldCheckHash = YES;
#if DEBUG
                [[BkmxBasis sharedBasis] forJobSerial:jobSerial
                                            logFormat:
                 @"   …details in ~/Library/Application Support/BookMacster/Changes/DiffsFoundVsLastExport"];
#endif

            }
        }
        else {
            // Case 14 or 16
            NSString* inferredDocumentPath = [BSManagedDocument documentPathForAuxiliaryDataFilePath:triggerCause                                                        documentExtension:[[NSDocumentController sharedDocumentController] defaultDocumentFilenameExtension]];

            if (inferredDocumentPath != nil) {
                // Case 16
                triggerType = BkmxTriggerCloud;
                // e.g., triggerCause = "path/to/Dropbox/MyBkmxDoc.bmco/StoreContent/auxiliaryData.plist"

                /* Since it's only used for logging after this, shorten the
                 triggerCause to only show parent folder and document name. */
                NSArray* pathComps = [triggerCause pathComponents];
                if (pathComps.count >= 4) {
                    if ([[pathComps objectAtIndex:(pathComps.count - 1)] isEqualToString:[BSManagedDocument persistentStoreName]]) {
                        if ([[pathComps objectAtIndex:(pathComps.count - 2)] isEqualToString:[BSManagedDocument storeContentName]]) {
                            pathComps = [pathComps subarrayWithRange:NSMakeRange(pathComps.count-4, 2)];
                            triggerCause = [NSString pathWithComponents:pathComps];
                        }
                    }
                }
                //  Now, triggerCause is, for example, "Dropbox/MyBkmxDoc.bmco"

                NSError* documentProbingError = nil;
                BOOL unchanged = [TriggHandler documentIsSameWithUuid:watch.docUuid
                                                              appName:watch.appName
                                                              error_p:&documentProbingError];
                if (documentProbingError) {
                    [self endJobSerial:jobSerial
                                 watch:watch
                               verdict:@"document probing error"];
                    return;
                }

                if (unchanged) {
                    [self logSpuriousChanger:@"self-trigger by last save (token)"
                                   jobSerial:jobSerial];
                    [self endJobSerial:jobSerial
                                 watch:watch
                               verdict:@"self-trigger by last save"];
                    return;
                }

                /* Wait a few seconds in case the -shm or -wal files have also
                 changed and have not arrived yet.  I've never seen this be
                 a issue during development, but I think it could happen. */
                sleep(5);
                syncerReason = AgentReasonStageAsap;
            }
            else {
                // Case 14
                // e.g., triggerCause = "/Users/jk/Library/Safari/Bookmarks.plist"
                triggerType = BkmxTriggerSawChange;
                NSString* triggerPath = triggerCause;
                triggerCause = [triggerCause last2PathComponents];
                if ([TriggHandler isSpuriousLaunchTriggerPath:triggerPath]) {
                    [self logSpuriousChanger:triggerCause
                                   jobSerial:jobSerial];
                    [self endJobSerial:jobSerial
                                 watch:watch
                               verdict:@"spurious trig per file mod date"];
                    return;
                }

                NSDate* uninhibitDate;
                NSTimeInterval uninhibitMargin;
                uninhibitDate = [[NSUserDefaults standardUserDefaults] uninhibitDateForTriggerCause:triggerCause];
                if (uninhibitDate) {
                    uninhibitMargin = [uninhibitDate timeIntervalSinceNow];
                    if (uninhibitMargin >= 0.0) {
                        [[BkmxBasis sharedBasis] forJobSerial:jobSerial
                                                    logFormat:
                         @"Trigger Cause Uninhibit: %0 (%1)",
                         [uninhibitDate geekDateTimeString],
                         [NSString stringWithUnitsForTimeInterval:uninhibitMargin
                                                         longForm:NO]];
                        [self endJobSerial:jobSerial
                                     watch:watch
                                   verdict:@"inhibited"];
                        return;
                    }
                }

                shouldCheckHash = YES;
            }
        }

        triggerCause = [@"Touch: " stringByAppendingString:triggerCause];
    }
    else if ([triggerCause isEqualToString:[Trigger causeStringForType:BkmxTriggerLogIn]]) {
        // Case 11
        triggerType = BkmxTriggerLogIn;
        if ([[NSUserDefaults standardUserDefaults] syncAndGetMainAppBoolForKey:constKeyIgnoreNextLoginTrigger]) {
            [[NSUserDefaults standardUserDefaults] removeAndSyncMainAppKey:constKeyIgnoreNextLoginTrigger];
            [self endJobSerial:jobSerial
                         watch:watch
                       verdict:@"spurious due to login"];
            return;
        }

        shouldCheckLastSaveToken = BkmxShouldCheckLastSaveTokenOnlyIfEfficient;
    }
    else if ([triggerCause isEqualToString:[Trigger causeStringForType:BkmxTriggerScheduled]]) {
        // Case 13
        triggerType = BkmxTriggerScheduled;
        syncerReason = AgentReasonStageAsap;
        shouldCheckLastSaveToken = BkmxShouldCheckLastSaveTokenUnconditionally;
    }
    else if ([triggerCause isEqualToString:[Trigger causeStringForType:BkmxTriggerPeriodic]]) {
        // Case 17
        triggerType = BkmxTriggerPeriodic;
        syncerReason = AgentReasonStageAsap;
        shouldCheckLastSaveToken = BkmxShouldCheckLastSaveTokenUnconditionally;
    }
    else {
        // Case 12
        // e.g., triggerCause = "Firefox quit"
        triggerType = BkmxTriggerBrowserQuit;
        syncerReason = AgentReasonStageAsap;

        shouldCheckHash = NO;
    }

    // Get the requested Macster
    Macster* macster = [[BkmxBasis sharedBasis] macsterWithDocUuid:watch.docUuid
                                                      createIfNone:NO];
    if (!macster) {
        // As of BookMacster 1.5, no error here because this
        // is expected if the syncer was deleted since the job was staged.
        [self endJobSerial:jobSerial
                     watch:watch
                   verdict:@"macster has disappeared"];
        return;
    }

    [[BkmxBasis sharedBasis] forJobSerial:jobSerial
                                logFormat:
     @"Trigd for S.T=%@.%@ %@ %@ %@",
     @(watch.syncerIndex + 1),
     @(watch.triggerIndex + 1),
     watch.clientoid.displayName,
     watch.appName,
     [watch.docUuid substringToIndex:4]
     ];

    switch (shouldCheckLastSaveToken) {
        case BkmxShouldCheckLastSaveTokenNo:
            break;
        case BkmxShouldCheckLastSaveTokenOnlyIfEfficient:
            if (watch.efficiently == TRIGGER_DETAIL_EFFICIENTLY_NO) {
                break;
            }
        case BkmxShouldCheckLastSaveTokenUnconditionally:;
            NSError* error = nil;
            BOOL unchanged = [TriggHandler documentIsSameWithUuid:watch.docUuid
                                                          appName:watch.appName
                                                          error_p:&error];
            if (error) {
                [self endJobSerial:jobSerial
                             watch:watch
                           verdict:@"error comparing Collections' Last Save Tokens"];
                return;
            }

            if (unchanged) {
                NSString* msg = [NSString stringWithFormat:
                                 @"Skip because unchanged Doc %@",
                                 [watch.docUuid substringToIndex:4]];
                [[BkmxBasis sharedBasis] forJobSerial:jobSerial
                                            logFormat:msg];
                [self endJobSerial:jobSerial
                             watch:watch
                           verdict:@"document is same"];
                return;
            }
    }

    Job* job = [Job new];
    job.cause = triggerCause;
    job.docUuid = watch.docUuid;
    job.appName = watch.appName;
    job.reason = syncerReason;
    job.serial = jobSerial;
    job.syncerIndex = watch.syncerIndex;
    job.syncerUri = watch.syncerUri;
    job.triggerIndex = watch.triggerIndex;
    job.triggerUri = watch.triggerUri;
    job.triggerType = triggerType;
    job.clidentifier = watch.clientoid.clidentifier;
    [job autorelease];

    if (shouldCheckHash) {
        BOOL gotBaton = [[Watcher sharedWatcher] claimIxportBatonForClidentifier:watch.clientoid.clidentifier
                                                                       jobSerial:jobSerial
                                                                         canWait:NO];
        if (!gotBaton) {
            [self endJobSerial:jobSerial
                         watch:watch
                       verdict:@"baton not available (ixport in progress)"];
            return;
        }
    }

    [self retain];

    if (shouldCheckHash) {
        __block Extore* extore = nil;
        /*
         In the actual Import and Export operation sequences, we compare not
         only the input from the client (hash bottom) but the current content
         (hash top), because we only want to skip the operation if *either*
         has changed.  This is important if user, says exports a change to a
         Client, then undoes the change in the Content and Imports.  If we only
         looked at the client (hash bottom), we would see no need to import
         because nothing had changed in the Client.
         
         In this case, however, we are deciding whether or not to stage a job
         based on a supposed change in the Client.  We may therefore safely
         forego staging the job if there is no change in the client.  So we
         are correct in considering the hash bottom only.
         */
        
        /* Wait for any subsequent changes within the debounce interval to
         appear in the Client. */
        [NSThread sleepForTimeInterval:SAW_CHANGE_DEBOUNCE_INTERVAL];
        
        NSError* hashCheckError = nil;
        extore = [Extore extoreForIxporter:nil
                                 clientoid:watch.clientoid
                                 jobSerial:jobSerial
                                   error_p:&hashCheckError];
        [extore determineYourIxportStyleError_p:NULL];
#if DEBUG
        {
            NSString* msg = [NSString stringWithFormat:
                             @"WCDHC: Got style %ld for extore %p",
                             (long)extore.ixportStyle,
                             extore];
            [[BkmxBasis sharedBasis] forJobSerial:jobSerial
                                        logFormat:msg];
        }

        [extore doBackupLabel:@"WCDHC"];
        {
            NSString* msg = [NSString stringWithFormat:
                             @"WCDHC: Did Pre-ipmort backup for extore %p",
                             extore];
            [[BkmxBasis sharedBasis] forJobSerial:jobSerial
                                        logFormat:msg];
        }
#endif
        /* Use __weak per Apple Documentation >
         Programming With Objective-C >
         Working with Blocks >
         Avoid Strong Reference Cycles when Capturing self */
        Extore* __weak weakExtore = extore;
        [extore readExternalUsingCurrentStyleWithPolarity:BkmxIxportPolarityImport
                                                jobSerial:jobSerial
                                        completionHandler:^void() {
                                            @autoreleasepool {
                                                NSError* error = [weakExtore error];
                                                if (error) {
                                                    [[BkmxBasis sharedBasis] logError:error
                                                                      markAsPresented:NO];
                                                    NSString* verdict = [[NSString alloc] initWithFormat:
                                                                         @"Error reading %@ for hash check \u279e Abort",
                                                                         weakExtore.displayName];
                                                    /* We are done with weakExtore. */
                                                    [weakExtore tearDownFor:@"TriggHandlingError"
                                                              jobSerial:job.serial];
                                                    [self endJobSerial:jobSerial
                                                                 watch:watch
                                                               verdict:verdict];
                                                    [verdict release];
                                                } else {
                                                    uint32_t currentContentHash = [weakExtore contentHash];
                                                    /* We are done with weakExtore. */
                                                    [weakExtore tearDownFor:@"TriggHandlingSuccess"
                                                              jobSerial:job.serial];

                                                    BOOL debugIxportHashes = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppBoolForKey:constKeyDebugIxportHashes];
                                                    if (debugIxportHashes) {
                                                        [Stark debug_clearHashComponents];
                                                    }
                                                    if (debugIxportHashes) {
                                                        [Stark debug_writeHashComponentsToDesktopWithPhaseName:@"WCDHC"
                                                                                                    clientName:[watch.clientoid displayName]];
                                                    }

                                                    if (debugIxportHashes) {
                                                        NSString* msg;
                                                        msg = [NSString stringWithFormat:
                                                               @"WCDHC: Import last hash: pre=%016qx post=%016qx",
                                                               [[[NSUserDefaults standardUserDefaults] lastImportPreHashForClientoid:watch.clientoid] unsignedLongLongValue],
                                                               [[[NSUserDefaults standardUserDefaults] lastImportPostHashForClientoid:watch.clientoid] unsignedLongLongValue]
                                                               ];
                                                        [[BkmxBasis sharedBasis] forJobSerial:jobSerial
                                                                                    logFormat:msg];
                                                        msg = [NSString stringWithFormat:
                                                               @"WCDHC: Export last hash: pre=%016qx post=%016qx",
                                                               [[[NSUserDefaults standardUserDefaults] lastExportPreHashForClientoid:watch.clientoid] unsignedLongLongValue],
                                                               [[[NSUserDefaults standardUserDefaults] lastExportPostHashForClientoid:watch.clientoid] unsignedLongLongValue]
                                                               ];
                                                        [[BkmxBasis sharedBasis] forJobSerial:jobSerial
                                                                                    logFormat:msg];
                                                    }

                                                    NSString* rehash = nil;
                                                    // In the next line, we take the bottom 32 bits of the 64-bit lastPostHash
                                                    uint32 lastExportedHash = (uint32)[[[NSUserDefaults standardUserDefaults] lastExportPostHashForClientoid:watch.clientoid] unsignedIntegerValue];
                                                    {
                                                        NSString* msg = [NSString stringWithFormat:
                                                                         @"WCDHC: Export (Cntt) Hash: Old=%08lx Now=%08lx",
                                                                         (long)lastExportedHash,
                                                                         (long)currentContentHash];
                                                        [[BkmxBasis sharedBasis] forJobSerial:jobSerial
                                                                                    logFormat:msg];
                                                    }
                                                    if (currentContentHash == lastExportedHash) {
                                                        rehash = @"Export";
                                                    }
                                                    else {
                                                        /* No hash match for last export, try last import. */
                                                        uint32_t oldImportHashBottom = [[[NSUserDefaults standardUserDefaults] lastImportPostHashForClientoid:watch.clientoid] unsignedIntegerValue] & 0xffffffff;
                                                        uint32_t compositeSettingsHash = [[NSUserDefaults standardUserDefaults] compositeImportSettingsHashForClientoid:watch.clientoid];
                                                        uint32_t currentImportHashBottom = currentContentHash ^ compositeSettingsHash;
                                                        {
                                                            NSString* msg = [NSString stringWithFormat:
                                                                             @"WCDHC: Import (Botm) Hash: Old=%08lx Now=%08lx",
                                                                             (long)oldImportHashBottom,
                                                                             (long)currentImportHashBottom];
                                                            [[BkmxBasis sharedBasis] forJobSerial:jobSerial
                                                                                        logFormat:msg];
                                                        }
                                                        if (currentImportHashBottom == oldImportHashBottom) {
                                                            rehash = @"Import";
                                                        }
                                                        else {
                                                            /* Client's current content matches neither last export nor last import. */
                                                            [[BkmxBasis sharedBasis] forJobSerial:jobSerial
                                                                                        logFormat:
                                                             @"WCDHC: %@ content was changed by others",
                                                             watch.clientoid.displayName];
                                                        }
                                                    }

                                                    /* Save this newly-read hash because, if it indicates a hash
                                                     difference, we are about to schedule a syncing job to fix it.
                                                     If, as usually happens, *something* in the system touchees
                                                     the Bookmarks.plist file before our job runs, we want that
                                                     touch to be ignored as spurious.  It will be, because that
                                                     *something* will not change any hashable values.  So, the
                                                     hash of the extore when the next TriggHandler arrives here in
                                                     response to the file touch will be the same as we saved with
                                                     the next line of code, so it will be deemed a  spurious
                                                     change, specifically a Rehash-Import, as desired.

                                                     Regarding the *something*, I don't know what it is, but
                                                     it happens in macOS 10.13.5 even when iCloud>Safari is OFF. */
                                                    [[NSUserDefaults standardUserDefaults] updatePreHashWithExtoreContentHash:currentContentHash
                                                                                                                    jobSerial:jobSerial
                                                                                                                    moreLabel:@"WCDHC"
                                                                                                                    clientoid:watch.clientoid];

                                                    if (rehash) {
                                                        NSString* spuriousChanger = [NSString stringWithFormat:
                                                                                     @"WCDHC: %@: Rehash-%@",
                                                                                     triggerCause,
                                                                                     rehash];
                                                        [self logSpuriousChanger:spuriousChanger
                                                                       jobSerial:jobSerial];
                                                        [self endJobSerial:jobSerial
                                                                     watch:watch
                                                                   verdict:@"WCDHC rehash"];

                                                        [self release];
                                                    } else {
                                                        [[BkmxBasis sharedBasis] forJobSerial:job.serial
                                                                                    logFormat:@"Not a rehash \u279e  Continue to finish."];
                                                        [self finishHandlingTriggerWithJob:job
                                                                                     watch:watch];
                                                    }
                                                }

                                                [[Watcher sharedWatcher] unclaimIxportBatonForClidentifier:watch.clientoid.clidentifier
                                                                                                 jobSerial:job.serial];
                                            }
                                        }];
    } else {
        [self finishHandlingTriggerWithJob:job
                                     watch:watch];
    }
}

- (void)finishHandlingTriggerWithJob:(Job*)job
                               watch:(Watch*)watch {
    NSString* verdict = nil;

    if (!verdict) {
        // See if licensed
        if (SSYLCCurrentLevel() < SSYLicenseLevelValid) {
            verdict = @"not licensed";
        }
    }

    if (!verdict) {
        /*  See if we are generally inhibited.  This is the first thing we
         do after unpacking the arguments, and getting our user defaults
         up and running.  The reason we do this now is
         because inhibiting only last for 20 seconds.  If we wait until
         after we, say, open the document, we may appear to be uninhibited by that
         time, when really we should have been inhibited before we started. */
        NSDate* uninhibitDate = [[NSUserDefaults standardUserDefaults] generalUninhibitDate];
        NSTimeInterval uninhibitMargin = [uninhibitDate timeIntervalSinceNow];
        if (uninhibitMargin >= 0.0) {
            [[BkmxBasis sharedBasis] forJobSerial:job.serial
                                        logFormat:
             @"General Uninhibit: %0 (%1) \u279E Aborting",
             [uninhibitDate geekDateTimeString],
             [NSString stringWithUnitsForTimeInterval:uninhibitMargin
                                             longForm:NO]];
            verdict = @"general inhibit";
        }
    }

    if (!verdict) {
        NSError* documentPathingError = nil;
        NSString* path = [TriggHandler pathForDocumentUuid:job.docUuid
                                                   appName:job.appName
                                                   error_p:&documentPathingError];
        if (!path) {
            documentPathingError = [SSYMakeError(984722, @"Could not find document") errorByAddingUnderlyingError:documentPathingError];
            documentPathingError = [documentPathingError errorByAddingUserInfoObject:job
                                                                              forKey:constKeyJob];
            [[AgentPerformer sharedPerformer] registerError:documentPathingError];
            verdict = @"could not find Collection";
        }
    }
    
    if (!verdict) {
        BkmxDocumentStatusInMainApp status = [[AgentPerformer sharedPerformer] checkIfOpenInMainAppDocUuid:(NSString*)job.docUuid
                                                                                                 jobSerial:job.serial];
        if (status == BkmxDocumentStatusInMainAppDocIsOpen) {
            verdict = @"Doc is open in main app";
        }
    }


    if (!verdict) {
        if ((job.reason == AgentReasonStageAsap) || (job.reason == AgentReasonStageSoon)) {
            /* Flag import needed, stage job and exit, unless such an import is
             already staged or imminent.  For a week or so during
             2018-02, I experimented with and committed removing any staging
             syncers (.doSoon, .standby).  However that was not a good idea because
             the .doSoon syncer is the mother of a syncing process, and if this
             happened while such a syncing job was already running, launchd
             would send that Worker a SIGTERM, causing it to terminate
             immediately.  UPDATE 2018-09-21.  This should be no longer an issue
             with OneAgent.  Maybe I should again try removing the above condition? */

            Clientoid* clientoid = [Clientoid clientoidWithClidentifier:job.clidentifier];
            if (!clientoid) {
                // This branch is taken for Case 16 (Cloud Trigger)
                job.reason = AgentReasonStageAsap;
                verdict = [Stager stageJob:job
                                  phase:@"WSt"];
            } else {
                if (![Stager needsImportClidentifier:job.clidentifier
                                toDocumentUuid:job.docUuid]) {
                    [Stager setNeedsImportClidentifier:job.clidentifier
                                        toDocumentUuid:job.docUuid];
                    [[BkmxBasis sharedBasis] forJobSerial:job.serial
                                                logFormat:
                     @"WSt: Flagged that %@ needs to be imported",
                     clientoid.displayName];
                }

                verdict = [Stager stageJob:job
                                     phase:@"WSt"];
            }
        }
        else {
            [[AgentPerformer sharedPerformer] queueJob:job
                                            afterDelay:0.0];
            verdict = @"added to queue (bypass staging)";
        }
    }

    [self endJobSerial:job.serial
                 watch:watch
               verdict:verdict];

    [self release];
}

- (void)endJobSerial:(NSInteger)serial
               watch:(Watch*)watch
             verdict:(NSString*)verdict {
    [[Watcher sharedWatcher] doneHandlingWatch:watch];
    NSString* msg = [NSString stringWithFormat:
                     @"Verdict: %@",
                     verdict];
    [[BkmxBasis sharedBasis] forJobSerial:serial
                                logFormat:msg];
}

@end
