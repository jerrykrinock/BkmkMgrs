#import <Sparkle/Sparkle.h>
#import "Bkmxwork/Bkmxwork-Swift.h"
#import "BkmxAgentAppDel.h"
#import "AgentPerformer.h"
#import "BkmxBasis+Strings.h"
#import "Watcher.h"
#import "BkmxDocumentController.h"
#import "NSError+MoreDescriptions.h"
#import "NSUserDefaults+Bkmx.h"
#import "Job.h"
#import "Macster.h"
#import "BkmxAgentXPCListener.h"
#import "SSYOtherApper.h"
#import "NSUserDefaults+MainApp.h"
#import "NSError+MyDomain.h"
#import "NSError+InfoAccess.h"
#import "NSArray+Stringing.h"
#import "SSYAppInfo.h"
#import "NSBundle+MainApp.h"
#import "BkmxNotifierCaller.h"


@interface BkmxAgentAppDel ()

@property (assign) BOOL willHandleWakeSoon;

@end


@implementation BkmxAgentAppDel

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSMutableArray* errorCodes = [NSMutableArray new];

    /* loadDefaultDefaultsOfMainApp must be invoked first; otherwise the
     -[BkmxBasis logFormat:] et al calls in the following calls will not
     make it into the Logs database. */
    [self loadDefaultDefaultsOfMainApp_errorCodes:errorCodes];
    [self logAppStartup_errorCodes:errorCodes];
    [self terminateIfOldie_errorCodes:errorCodes];
    [self loadAndRealizeWatches_errorCodes:errorCodes];
    [self startXPCServiceListener_errorCodes:errorCodes];
    [self resuscitateStagingsFromDisk_errorCodes:errorCodes];
    [self beginWatchingForWakes_errorCodes:errorCodes];
    /* Uncomment this (and implement delegte methods) to get Sparkle in BkmxAgent. */
//    [self beginSparkle_errorCodes:errorCodes];
    [[BkmxBasis sharedBasis] scheduleFileCruftCleaning];

    NSString* title;
    NSString* body;
    if (errorCodes.count > 0) {
        if (errorCodes.count == 1) {
            title = [NSString stringWithFormat:
                               NSLocalizedString(@"Error %@ when starting syncing.", nil),
                               errorCodes.firstObject];
            body = NSLocalizedString(@"Mouse here and click the button which will appear.", nil);
        } else {
            title = [NSString stringWithFormat:
                     NSLocalizedString(@"%ld errors when starting syncing.", nil),
                     errorCodes.count];
            body = [NSString stringWithFormat:
                    NSLocalizedString(@"Error codes: %@.", nil),
                    errorCodes.listDescriptions];
            ;
        }

        NSNumber* targetErrorCodeNumber = errorCodes.lastObject;
        NSInteger targetErrorCode = 0;
        if ([targetErrorCodeNumber respondsToSelector:@selector(integerValue)]) {
            targetErrorCode = targetErrorCodeNumber.integerValue;
        }
        [BkmxNotifierCaller presentUserNotificationOfError:nil
                                                     title:title
                                            alertNotBanner:YES
                                                  subtitle:@"Please fix to ensure bookmarks syncing."
                                                      body:body
                                                 soundName:nil
                                           targetErrorCode:targetErrorCode
                                                   error_p:NULL];
    }
    [errorCodes release];
    [SSYAppInfo calculateUpgradeState];
}

- (NSInteger)logAppStartup_errorCodes:(NSMutableArray*)errorCodes {
    NSArray<NSString *> *args = [[NSProcessInfo processInfo] arguments];
    NSString* executablePath;
    if (args.count > 0) {
    	executablePath = [args objectAtIndex:0];
    } else {
        executablePath = @"Process has no args!";
    }

    [[BkmxBasis sharedBasis] forJobSerial:0
                                logFormat:
     @"Started: %@",
     executablePath];

    return 0;
}

- (void)terminateIfOldie_errorCodes:(NSMutableArray*)errorCodes {
    BOOL apparentlyOldie = YES;
    /* We don't know which of the three apps we are in, so we get the
     bundle identifier of the BkmxAgent in all three of them.  If our
     bundle identifier matches any of the three, then we are not an oldie. */
    for (NSNumber* which1AppNumber in [BkmxBasis syncableWhich1Apps]) {
        BkmxWhich1App which1App = (BkmxWhich1App)which1AppNumber.integerValue;
        NSString* bundleIdentifier = [[BkmxBasis sharedBasis] bundleIdentifierForLoginItemName:constAppNameBkmxAgent
                                                                                   inWhich1App:which1App
                                                                                       error_p:NULL];
        if (bundleIdentifier) {
            BkmxWhichApps whichApps = [BkmxBasis whichAppsFromWhich1App:which1App];
            NSString* name = [[BkmxBasis sharedBasis] appNameForApps:whichApps];
             NSString* isMyID;
            if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:bundleIdentifier]) {
                isMyID = (@" (matches mine)");
                apparentlyOldie = NO;
            } else {
                isMyID = (@"");
            }
            NSString* shortBundleIdentifier;
            NSString* prefix = @"com.sheepsystems.";
            if ([bundleIdentifier hasPrefix:prefix]) {
                shortBundleIdentifier = [bundleIdentifier substringFromIndex:prefix.length];
            } else {
                shortBundleIdentifier = bundleIdentifier;
            }
            [[BkmxBasis sharedBasis] forJobSerial:0
                                        logFormat:@"%@ is in %@%@",
             shortBundleIdentifier,
             name,
             isMyID];
        }
    }
    
    if (apparentlyOldie) {
        NSString* msg = @"Apparently I'm a oldie \u279E Terminating!";
        [[BkmxBasis sharedBasis] forJobSerial:0
                                    logString:msg];
        NSLog(@"%@", msg);
        [NSApp terminate:self];
    }
}

- (void)loadDefaultDefaultsOfMainApp_errorCodes:(NSMutableArray*)errorCodes {
    NSDictionary* defaultDefaults = [[BkmxBasis sharedBasis] defaultDefaults];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultDefaults];
}

- (void)loadAndRealizeWatches_errorCodes:(NSMutableArray*)errorCodes {
    NSString* msg = [NSString stringWithFormat:
                     @"Realizing %ld watches read from disk",
                     [[NSUserDefaults standardUserDefaults] watchesThisApp].count];
    [[BkmxBasis sharedBasis] forJobSerial:0
                                logFormat:msg];
    [[Watcher sharedWatcher] realizeWatches_errorCodes:errorCodes];
}

- (void)startXPCServiceListener_errorCodes:(NSMutableArray*)errorCodes {
    /* Begin accepting incoming connections from main app */
    [[BkmxAgentXPCListener sharedListener] resume];
}

#define RESUSCITATED_STAGING_DELAY 35.0

- (void)resuscitateStagingsFromDisk_errorCodes:(NSMutableArray*)errorCodes {
    /* We use BkmxWhichAppsMain instead of BkmxWhichAppsAny because each
     app (BookMacster, Synkmark, Smarky) has its own agent with a different
     bundle identifier. */
    NSArray<Job*>* jobs = [[NSUserDefaults standardUserDefaults] stagedJobsForApps:BkmxWhichAppsMain];
    for (Job* job in jobs) {
        [[AgentPerformer sharedPerformer] queueJob:job
                                        afterDelay:RESUSCITATED_STAGING_DELAY];
        [[BkmxBasis sharedBasis] logFormat:
         @"Resuscitated Job %@ to run in %@ seconds",
         job.serialString,
         @(RESUSCITATED_STAGING_DELAY)];
    }
}

- (void)beginSparkle_errorCodes:(NSMutableArray*)errorCodes {
    [[Sparkler shared] start];
}


/* We started using the following methods in BkmkMgrs 2.9.3 (2018-11-03), after
 two users reported that sometimes detection of bookmarks changes in browsers
 does not always work after system wakes from sleep.  Our "solution" is to
 kill BkmxAgent, which causes the system to relaunch it, some tens of
seconds after a system wake or screen wake.  We did not get any more complaints
after this, but I really do not know if it helps or not. */
- (void)beginWatchingForWakes_errorCodes:(NSMutableArray*)errorCodes {
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
                                                           selector:@selector(stuffDidWakeNote:)
                                                               name:NSWorkspaceDidWakeNotification
                                                             object:[NSWorkspace sharedWorkspace]];
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
                                                           selector:@selector(stuffDidWakeNote:)
                                                               name:NSWorkspaceScreensDidWakeNotification
                                                             object:[NSWorkspace sharedWorkspace]];
    /* Note that the above observers added set once in the lifetime of a
     BkmxAgent process, and they are never removed.  They don't need to be
     removed because the BkmxAgent process will be killed after they have
     performed their service for us by firing once or several times. */
}

#define HANDLE_WAKE_DELAY 65.0

- (void)stuffDidWakeNote:(NSNotification*)note {
    if (!self.willHandleWakeSoon) {
        self.willHandleWakeSoon = YES;
        [self performSelector:@selector(handleWakeCuz:)
                   withObject:[note.name substringFromIndex:11]
                   afterDelay:HANDLE_WAKE_DELAY];
    }
}

- (void)handleWakeCuz:(NSString*)reason {
    [[BkmxBasis sharedBasis] logFormat:@"May reboot cuz %@", reason];
    [self rebootMeIfNonePendingLoggingJobSerial:0];
    self.willHandleWakeSoon = NO;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

-  (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender {
    return NO ;
}

- (void)dealloc {
    [[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self
                                                                  name:NSWorkspaceDidWakeNotification
                                                                object:[NSWorkspace sharedWorkspace]] ;

    [[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self
                                                                  name:NSWorkspaceScreensDidWakeNotification
                                                                object:[NSWorkspace sharedWorkspace]] ;
    [super dealloc];
}

- (void)rebootMeIfNonePendingLoggingJobSerial:(NSInteger)jobSerial {
#if 0
#warning Rebooting of BkmxAgent is disabled
    [[BkmxBasis sharedBasis] forJobSerial:jobSerial
                                logFormat: @"Not rebooting (This is a test.) \u279e No Reboot"];
    return;
#endif
    [[BkmxBasis sharedBasis] forJobSerial:jobSerial
                                logFormat:[NSString stringWithFormat:
                                           @"We is dead man walking."]];
    self.completedSyncJobSerial = jobSerial;
    BOOL willReboot = [self maybeReboot];
    if (!willReboot) {
        /* There are still job(s) in the queue, probably due to the export(s)
         in our sync operations which caused bookmark change triggers.  So
         we set up some observers to watch when those are done. */
        [[Watcher sharedWatcher] addObserver:self
                                  forKeyPath:@"watchesDoneHandlingCount"
                                     options:0
                                     context:NULL];
        [[AgentPerformer sharedPerformer] addObserver:self
                                           forKeyPath:@"jobsDoneCount"
                                              options:0
                                              context:NULL];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    [self maybeReboot];
}

- (BOOL)maybeReboot {
    /* Triggers now in handling are in-memory and would be lost in a reboot. */
    NSInteger countInHandling = [Watcher sharedWatcher].watchesInHandling.count;
    /* Queued jobs are in-memory and would be lost in a reboot. */
    NSInteger countQueued = [AgentPerformer sharedPerformer].jobQueue.count;
    /* We do not count staged jobs, because staged jobs are in user defaults,
     will be resuscitated from user defaults and queued after any reboot. */

    [[BkmxBasis sharedBasis] forJobSerial:self.completedSyncJobSerial
                                logFormat:[NSString stringWithFormat:
                                           @"Reboot Factors: Triggers-in-handling:%@ Jobs-queued:%@",
                                           @(countInHandling),
                                           @(countQueued)]];
    BOOL willReboot;
    if (countInHandling + countQueued < 1) {
        NSInteger nDocs = 0;
        NSInteger nOps = 0;
        for (BkmxDoc* doc in [[NSDocumentController sharedDocumentController] documents]) {
            nDocs++;
            if ([doc respondsToSelector:@selector(operationQueue)]) {
                nOps += [[doc operationQueue] operations].count;
            }
        }
        NSTimeInterval rebootDelay = 0.0;
        [[BkmxBasis sharedBasis] forJobSerial:self.completedSyncJobSerial
                                    logFormat:@"0 in-handling or queued \u279e Reboot in %@ sec. Bye! [%@ open docs]",
         @(rebootDelay),
         @(nDocs)];

        /* No more jobs pending.  To reduce memory accumulation, reboot
         ourself.  But wait for rebootDelay seconds for the above log entry to
         get into the database because -[BkmxBasis forJobSerial:logFormat:]
         calls into the main thread. */
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(rebootDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[BkmxBasis sharedBasis] rebootSyncAgentReport_p:NULL
                                                     title_p:NULL
                                                     error_p:NULL];
        });
        willReboot = YES;
    } else {
        [[BkmxBasis sharedBasis] forJobSerial:self.completedSyncJobSerial
                                    logFormat:
         @"Got Triggers-in-handling and/or Jobs-queued \u279e No Reboot yet"];
        willReboot = NO;
    }
    
    return willReboot;
}

@end
