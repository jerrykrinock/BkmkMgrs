#import "Watcher.h"
#import "BkmxBasis+Strings.h"
#import "Watch.h"
#import "NSUserDefaults+Bkmx.h"
#import "SSYPathObserver.h"
#import "SSYRecurringDate.h"
#import "ExtoreSafari.h"
#import "NSDate+NiceFormats.h"
#import "NSError+MyDomain.h"
#import "TriggHandler.h"
#import "Trigger.h"
#import "NSFileManager+SomeMore.h"
#import "NSDate+NiceFormats.h"
#import "Job.h"
#import "NSError+InfoAccess.h"

static Watcher* sharedWatcher = nil;

enum IxportBatonState_enum
{
    IxportBatonStateBlocked = 0,
    IxportBatonStateBlockedButStale = 1,
    IxportBatonStateFree = 2
} ;
typedef enum IxportBatonState_enum IxportBatonState;

@interface IxportBaton : NSObject

@property (copy) NSDate* date;
@property (assign) NSInteger jobSerial;

@end

@implementation IxportBaton

- (NSString*)description {
    NSString* desc = [[NSString alloc] initWithFormat:
                      @"Baton %@ %@",
                      [Job serialStringForSerial:self.jobSerial],
                      [self.date geekDateTimeString]];
    [desc autorelease];
    return desc;
}

- (void)dealloc {
    [_date release];

    [super dealloc];
}

@end


@interface Watcher ()

@property (readonly) NSMutableSet <NSTimer*> * timers;
@property (readonly) NSMutableSet <NSString*> * observeAppLaunchBundleIdentifiers;
@property (readonly) NSMutableSet <NSString*> * observeAppQuitBundleIdentifiers;
@property (readonly) NSMutableSet <SSYPathObserver*> * pathObservers;
@property (readonly) NSMutableDictionary* lastTriggerDates;
@property (copy) NSString* lastRealizedWatchesReport;
@property (assign) NSInteger watchesDoneHandlingCount;

@end

@implementation Watcher

+ (Watcher*)sharedWatcher {
    @synchronized(self) {
        if (!sharedWatcher) {
            sharedWatcher = [[Watcher alloc] init];
        }
    }
    
    return sharedWatcher;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        /* We need these to be assigned immediately because we
         use it as a token like this: @synchronized(_watchesInHandling)
         to prevent simultaneous reading and writing of it. */
        _watchesInHandling = [NSMutableSet new];
        _ixportsInProgessBatons = [NSMutableDictionary new];
    }

    return self;
}

- (void)dealloc {
    [[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self] ;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_timers release];
    [_observeAppLaunchBundleIdentifiers release];
    [_observeAppQuitBundleIdentifiers release];
    [_pathObservers release];
    [_lastTriggerDates release];
    [_watchesInHandling release];
    [_ixportsInProgessBatons release];
    [_lastRealizedWatchesReport release];
    
    [super dealloc] ;
}

- (NSMutableSet*)timers {
    @synchronized(self) {
        if (!_timers) {
            _timers = [NSMutableSet new];
        }
        
        return _timers;
    }
}

- (NSMutableSet*)observeAppLaunchBundleIdentifiers {
    @synchronized(self) {
        if (!_observeAppLaunchBundleIdentifiers) {
            _observeAppLaunchBundleIdentifiers = [NSMutableSet new];
        }
        
        return _observeAppLaunchBundleIdentifiers;
    }
}

- (NSMutableSet*)observeAppQuitBundleIdentifiers {
    @synchronized(self) {
        if (!_observeAppQuitBundleIdentifiers) {
            _observeAppQuitBundleIdentifiers = [NSMutableSet new];
        }
        
        return _observeAppQuitBundleIdentifiers;
    }
}

- (NSMutableSet*)pathObservers {
    @synchronized(self) {
        if (!_pathObservers) {
            _pathObservers = [NSMutableSet new];
        }
        
        return _pathObservers;
    }
}

- (NSString*)currentWatchesReport {
    NSMutableString* report = [NSMutableString new];

    NSMutableSet* currentlyWatchedPaths = [NSMutableSet new];
    for (SSYPathObserver* observer in self.pathObservers) {
        [currentlyWatchedPaths unionSet:observer.currentlyWatchedPaths];
    }
	[report appendString:NSLocalizedString(@"Path Watches Now Armed (active kqueues):\n", nil)];
    for (NSString* path in currentlyWatchedPaths) {
        [report appendString:@"\n• "];
        [report appendString:path];
    }
    [currentlyWatchedPaths release];

    [report appendString:@"\n\n"];

    [report appendString:NSLocalizedString(@"Watches which are temporarily muted because a recent trigger is still in handling:\n", nil)];
    @synchronized (_watchesInHandling) {
        if (self.watchesInHandling.count > 0) {
            for (Watch* watch in self.watchesInHandling) {
                [report appendString:@"\n• "];
                [report appendString:watch.description];
            }
        } else {
            [report appendString:@"\n[None]"];
        }
    }
    [report appendString:@"\n"];

    NSString* answer = [report copy];
    [report release];
    [answer autorelease];

    return answer;
}

- (void)realizeWatches_errorCodes:(NSMutableArray*)errorCodes {
    // First: switch off, invalidate and remove all existing observers
    
    [[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    for (NSTimer* timer in self.timers) {
        [timer invalidate];
    }
    for (SSYPathObserver* observer in self.pathObservers) {
        observer.isWatching = NO;
    }
    [self.timers removeAllObjects];
    [self.observeAppLaunchBundleIdentifiers removeAllObjects];
    [self.observeAppQuitBundleIdentifiers removeAllObjects];
    [self.pathObservers removeAllObjects];
    
    // Second: Parse current watches and create new watches
    
    NSMutableString* report = [NSMutableString new];

    NSString* formatString = NSLocalizedString(@"Pid %d has had the following Watches running since %@", nil);
    [report appendFormat:
     formatString,
     getpid(),
     [[NSDate date] geekDateTimeString]];
    [report appendString:@"\n\n"];
    NSInteger miscellaneousWatchesCount = 0;

    /* We use BkmxWhichAppsMain instead of BkmxWhichAppsAny because each
     app (BookMacster, Synkmark, Smarky) has its own agent with a different
     bundle identifier. */
   NSSet <Watch*>* watches = [[NSUserDefaults standardUserDefaults] watchesForApps:BkmxWhichAppsMain];
    
    for (Watch* watch in watches) {
        NSTimer* timer = nil;;
        NSArray* observeAppBundleIdentifiers = nil;
        NSString* path = nil;
        NSString* observePath = nil;
        NSError* error = nil;
        id subject = watch.subject;
        switch (watch.watchType) {
            case WatchTypeUndefined:
                [report appendFormat:@"• Skipping undefined: %@\n", watch];
                break;
            case WatchTypeLogIn:
                /* There is nothing to install here.  BkmxAgent checks for
                 Login watches during -applicationDidFinishLaunching. */
            	[report appendFormat:@"• Watching for whenever you log in to macOS\n"];
                miscellaneousWatchesCount++;
                break;
            case WatchTypePeriodic:
                /* Both NSString and NSNumber respond as desired to the message
                 -doubleValue.  So we don't need a branch for the legacy case
                 of NSNumber here. */
                if ([subject respondsToSelector:@selector(doubleValue)]) {
                    timer = [NSTimer scheduledTimerWithTimeInterval:((NSNumber*)subject).doubleValue
                                                             target:self
                                                           selector:@selector(fireWatch:)
                                                           userInfo:watch
                                                            repeats:YES];
                    miscellaneousWatchesCount++;
                }
                break;
            case WatchTypeAppLaunch:
            case WatchTypeAppQuit:
                /* For these trigger types, subject will be an NSString for
                 either the legacy case or modern case of Watch. */
                if ([subject isKindOfClass:[NSString class]]) {
                    Class extoreClass = NSClassFromString((NSString*)subject) ;
                    if (extoreClass) {
                        observeAppBundleIdentifiers = [extoreClass browserBundleIdentifiers];
                    }
                }
                break;
            case WatchTypeScheduled:;
                SSYRecurringDate* recurringDate = nil;
                if ([subject isKindOfClass:([NSString class])]) {
                    // modern case
                    recurringDate = [SSYRecurringDate recurringDateWithString:subject];
                } else if ([subject respondsToSelector:@selector(weekday)]) {
                    // legacy case
                    recurringDate = (SSYRecurringDate*)subject;
                }
                if (recurringDate) {
                    NSTimeInterval timeInterval = recurringDate.timeIntervalToNextOccurrence;
                    timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                             target:self
                                                           selector:@selector(fireWatch:)
                                                           userInfo:watch
                                                            repeats:NO];
                    miscellaneousWatchesCount++;
                }
                break;
            case WatchTypePathTouched:
                path = (NSString*)watch.subject;
                if ([path isKindOfClass:[NSString class]]) {
                    observePath = path;
                }
                break;
            case WatchTypeLanding:
                /* There is nothing to install here because the landing
                 is done in the main app, and the main app does the export
                 or whatever. */
	            [report appendFormat:@"• Watching for whenever you land a new bookmark directly to %@\n", watch.appName];
                miscellaneousWatchesCount++;
                break;
        }
        
        if (timer) {
            [self.timers addObject:timer];
            [report appendFormat:
             @"• Will notice at time %@\n",
             [timer.fireDate geekDateTimeString]];
        }
        
        if (observeAppBundleIdentifiers) {
            switch(watch.watchType) {
                case WatchTypeAppLaunch:
                    [report appendFormat:@"• Watching for any launch of %@\n", observeAppBundleIdentifiers];
                    [self.observeAppLaunchBundleIdentifiers addObjectsFromArray:observeAppBundleIdentifiers];
                    break;
                case WatchTypeAppQuit:
                    [report appendFormat:@"• Watching for any quitting of %@\n", observeAppBundleIdentifiers];
                    [self.observeAppQuitBundleIdentifiers addObjectsFromArray:observeAppBundleIdentifiers];
                    break;
                default:
                    [report appendFormat:@"• Internal Error 624-6958: %@\n", watch];
            }
        }
        
        if (observePath) {
            NSString* const problematicSuffix = @"Library/Safari/Bookmarks.plist";
            
            /* A better way to do the above would be to use
             -[Clientoid filePathParentError_p:], but to get there I'd need
             watch.triggerUri > Client > Clientoid.  This is good
             enough for now. */
            BOOL canAccess = YES;
            if ([observePath hasSuffix:problematicSuffix]) {
                error = nil;
                canAccess = [ExtoreSafari preflightFileAccessForPath:observePath
                                                             error_p:&error];
                if (error) {
                    [[BkmxBasis sharedBasis] logError:error
                                      markAsPresented:NO];
                    [errorCodes addObject:@(error.code)];
                }
            }
            if (canAccess) {
                SSYPathObserver* pathObserver = [SSYPathObserver new];
                error = nil;
                BOOL ok = YES;
                if ([path hasPrefix:[[BkmxBasis sharedBasis] detectedChangesPath]]) {
                    /* This branch is in case the user has not changed any
                     bookmarks in the browser since installing the
                     BookMacster Sync extension.  In this case, directory
                     ~/Library/Application Support/BookMacster/Changes/Detected/<browserName>/<profile>
                     will not exist, and -addPath::::: will fail because
                     creating the underlying kqueue requires existence.  To
                     prevent that, we now create if necessary the required
                     directory.  It will be an empty folder but that is
                     sufficient. */
                    ok = [[NSFileManager defaultManager] ensureDirectoryAtPath:observePath
                                                                       error_p:&error];
                }
                if (ok) {
                    [pathObserver addPath:observePath
                               watchFlags:0
                             notifyThread:nil
                                 userInfo:watch
                                  error_p:&error];
                }
                if (error) {
                    NSString* desc = [[NSString alloc] initWithFormat:
                                     @"Could not begin watching path:\n%@",
                                     observePath];
                    error = [SSYMakeError(837441, desc) errorByAddingUnderlyingError:error];
                    [desc release];
                    [[BkmxBasis sharedBasis] logError:error
                                      markAsPresented:NO];
                    /* Do not increment errorCount here, because we don't need this
                     error to be presented.  Usually, the underlying error is
                     812002 file not found, and in that case other, more
                     directly understandable errors will occur eventually. */
                } else {
                    [report appendFormat:
                     @"• Watching for any change in file%@\n",
                     observePath];
                    [self.pathObservers addObject:pathObserver];
                }
                [pathObserver release];
            }
        }
    }
    
    // Third, add common observers for any added observances
    
    if (self.observeAppLaunchBundleIdentifiers.count > 0) {
        NSNotificationCenter* notificationCenter = [[NSWorkspace sharedWorkspace] notificationCenter] ;
        [notificationCenter addObserver:self
                               selector:@selector(handleAppQuinchNote:)
                                   name:NSWorkspaceDidLaunchApplicationNotification
                                 object:nil] ;
    }
    
    if (self.observeAppQuitBundleIdentifiers.count > 0) {
        NSNotificationCenter* notificationCenter = [[NSWorkspace sharedWorkspace] notificationCenter] ;
        [notificationCenter addObserver:self
                               selector:@selector(handleAppQuinchNote:)
                                   name:NSWorkspaceDidTerminateApplicationNotification
                                 object:nil] ;
    }
    
    if (self.pathObservers.count > 0) {
        NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter] ;
        [notificationCenter addObserver:self
                               selector:@selector(handlePathTouchNote:)
                                   name:SSYPathObserverChangeNotification
                                 object:nil] ;
        
    }

    [report appendFormat:
     @"Summary: Watching %ld paths, %ld apps for launch, %ld apps for quit, %ld miscellaneous watches\n",
     (long)self.pathObservers.count,
     (long)self.observeAppLaunchBundleIdentifiers.count,
     (long)self.observeAppQuitBundleIdentifiers.count,
     miscellaneousWatchesCount];
    
    // Fourth, summmarize results

    NSString* reportCopy = [report copy];
    [report release];
    self.lastRealizedWatchesReport = reportCopy;
    [reportCopy release];
}

- (void)fireWatch:(NSTimer*)timer {
    Watch* watch = [timer userInfo];
    [[BkmxBasis sharedBasis] forJobSerial:0
                                logFormat:@"Saw: timer fire for %@", watch];
    
    BkmxTriggerType triggerTypeValue;
    switch (watch.watchType) {
        case WatchTypePeriodic:
            triggerTypeValue = BkmxTriggerPeriodic;
            break;
        case WatchTypeScheduled:
            triggerTypeValue = BkmxTriggerScheduled;
            break;
        default:
            triggerTypeValue = BkmxTriggerImpossible;
            NSLog(@"Internal Error 582-8742");
    }
    NSString* triggerCause = [Trigger causeStringForType:triggerTypeValue];

    [self mullOverTriggerCausedBy:triggerCause
                         forWatch:watch];

/*
 DOES NOT MAKE SENSE.  PERIODIC Vs. WatchTypeScheduled
    FOR PERIODIC, SUBJECT is NSNumber
    FOR SCHEDULED, SUBJECT is SSYRecurringDate
    TESTING, IT SEEMS THE SCHEDULED DID NOT WORK ON JUNE 2 18:40
 */
    // For Scheduled type, schedule a new timer for next period
    if (watch.watchType == WatchTypeScheduled) {
        // The nonrepeating `timer` should have invalidated itself
        [self.timers removeObject:timer];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:((NSNumber*)watch.subject).doubleValue
                                                 target:self
                                               selector:@selector(fireWatch:)
                                               userInfo:watch
                                                repeats:YES];
        [self.timers addObject:timer];
        [[BkmxBasis sharedBasis] forJobSerial:0
                                    logFormat:
         @"Reset scheduled timer at %@ for %@\n",
         [timer.fireDate geekDateTimeString],
         watch];
    }
}

- (void)handleAppQuinchNote:(NSNotification*)note {
    NSRunningApplication* affectedApp = [[note userInfo] objectForKey:NSWorkspaceApplicationKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSSet* watches = [[NSUserDefaults standardUserDefaults] watchesThisApp] ;
    
    for (Watch* watch in watches) {
        NSString* docUuid = watch.docUuid ;
        NSString* triggerUri = watch.triggerUri ;
        if (!docUuid) {
            continue ;
        }
        if (!triggerUri) {
            continue ;
        }
        
        if (watch.watchType == WatchTypeAppLaunch) {
            if ([note.name isEqualToString:NSWorkspaceDidLaunchApplicationNotification]) {
                NSString* extoreClassName = (NSString*)watch.subject;
                if ([extoreClassName isKindOfClass:[NSString class]]) {
                    Class extoreClass = NSClassFromString(extoreClassName) ;
                    if (extoreClass) {
                        NSArray* browserBundleIdentifiers = [extoreClass browserBundleIdentifiers];
                        NSString* affectedAppBundleIdentifier = affectedApp.bundleIdentifier;
                        for (NSString* watchBundleIdentifier in browserBundleIdentifiers) {
                            if ([watchBundleIdentifier isEqualToString:affectedAppBundleIdentifier])  {
                                [[BkmxBasis sharedBasis] forJobSerial:0
                                                            logFormat:
                                 @"Saw: Launch of %@",
                                 affectedApp.localizedName];
                                
                                NSString* triggerCause = [NSString stringWithFormat:
                                                          @"%@ launched",
                                                          affectedApp.localizedName];
                                [self mullOverTriggerCausedBy:triggerCause
                                                     forWatch:watch];
                            }
                        }
                    }
                }
            }
        } else if (watch.watchType == WatchTypeAppQuit) {
            if ([note.name isEqualToString:NSWorkspaceDidTerminateApplicationNotification]) {
                NSString* extoreClassName = (NSString*)watch.subject;
                if ([extoreClassName isKindOfClass:[NSString class]]) {
                    Class extoreClass = NSClassFromString(extoreClassName) ;
                    if (extoreClass) {
                        NSArray* browserBundleIdentifiers = [extoreClass browserBundleIdentifiers];
                        NSString* affectedAppBundleIdentifier = affectedApp.bundleIdentifier;
                        for (NSString* watchBundleIdentifier in browserBundleIdentifiers) {
                            if ([watchBundleIdentifier isEqualToString:affectedAppBundleIdentifier])  {
                                [[BkmxBasis sharedBasis] forJobSerial:0
                                                            logFormat:@"Saw: Quit of %@", affectedApp.localizedName];
                                
                                NSString* triggerCause = [NSString stringWithFormat:
                                                          @"%@ quit",
                                                          affectedApp.localizedName];
                                [self mullOverTriggerCausedBy:triggerCause
                                                     forWatch:watch];
                            }
                        }
                    }
                }
            }
        }
    }
}

- (void)handlePathTouchNote:(NSNotification*)note {
    Watch* watch = [note.userInfo objectForKey:SSYPathObserverUserInfoKey];
    [[BkmxBasis sharedBasis] forJobSerial:0
                                logFormat:@"Saw: Path touched: %@", watch.subject];
    
    NSString* path = (NSString*)watch.subject;
    if ([path isKindOfClass:[NSString class]]) {
        [self mullOverTriggerCausedBy:path
                             forWatch:watch];
    } else {
        [[BkmxBasis sharedBasis] forJobSerial:0
                                    logFormat:@"Internal Error 529-7834 %@", path];
    }
}

- (void)mullOverTriggerCausedBy:(NSString*)triggerCause
                       forWatch:(Watch*)watch {
    BOOL ok = YES;

    if (ok) {
        /* I'm not sure if this could ever happen, but just in case… */
        NSString* mainAppName = [[BkmxBasis sharedBasis] mainAppNameUnlocalized];
        if (![watch.appName isEqualToString:mainAppName]) {
            ok = NO;
            NSString* msg = [NSString stringWithFormat:
                             @"watch's main app=%@ but agent's main app =%@ \u279e Ignore",
                             watch.appName,
                             mainAppName];
            [[BkmxBasis sharedBasis] forJobSerial:0
                                        logFormat:msg];
        }
    }

    /* See if too soon since last trigger (throttled) */
    if (ok) {
        NSDate* lastTriggerDate = [self.lastTriggerDates objectForKey:watch.uniqueIdentifier];
        if (lastTriggerDate) {
            NSTimeInterval timeSinceLastTrigger = -lastTriggerDate.timeIntervalSinceNow;
            if (timeSinceLastTrigger < watch.throttleInterval) {
                ok = NO;
                NSString* msg = [NSString stringWithFormat:
                                 @"Throttled (%0.1f < %0.1f): %@ \u279e Ignore",
                                 timeSinceLastTrigger,
                                 watch.throttleInterval,
                                 watch.uniqueIdentifier];
                [[BkmxBasis sharedBasis] forJobSerial:0
                                            logFormat:msg];
            }
        }
    }

    /* Note WhyWatchesInHandling
     See if a prior trigger for this watch is in process.  This is necessary
     because macOS sometimes takes seconds or tens of seconds to launch
     SheepSafariHelper when we open a XPC connection and request that SheepSafariHelper do a
     -importForKlientAppDescription::.  I think that, because of the singletons in
     SafariFramework, SheepSafariHelper can only handle one request at a time (although
     in fact we only allow one request per process run).  If we get another
     trigger in the meantime, as often occurs, we need to ignore it.

     This watchesInHandling is *almost* redundant with ixportBaton.  The
     ixportBaton lockout is actually more comprehensive because it also locks
     out for “actual work” operations.  However, the watchesInHandling lockout
     is set earlier, in -mullOverTrigger…::, while the IxportBaton lockout is
     not set until -handleTriggerForWatch::, in the middle of that method,
     after it is determined that a hash check is needed.*/

    @synchronized (_watchesInHandling) {
        if (ok) {
            if ([self.watchesInHandling member:watch]) {
                ok = NO;
                NSString* msg = [NSString stringWithFormat:
                                 @"Now handling prior trig for %@ \u279e Ignore",
                                 watch.uniqueIdentifier];
                [[BkmxBasis sharedBasis] forJobSerial:0
                                            logFormat:msg];
            }
        }

        if (ok) {
            NSString* identifier = watch.uniqueIdentifier;
            [self.lastTriggerDates setObject:[NSDate date]
                                      forKey:identifier];
            [[BkmxBasis sharedBasis] forJobSerial:0
                                        logFormat:@"Begin handling %@", identifier];
            [self.watchesInHandling addObject:watch];
            TriggHandler* triggHandler = [TriggHandler new];
            [triggHandler handleTriggerForWatch:watch
                                   triggerCause:triggerCause];
            [triggHandler release];
        }
    }
}

- (NSMutableDictionary*)lastTriggerDates {
    @synchronized(self) {
        if (!_lastTriggerDates) {
            _lastTriggerDates = [NSMutableDictionary new];
        }

        return _lastTriggerDates;
    }
}

- (void)doneHandlingWatch:(Watch*)watch {
    @synchronized (_watchesInHandling) {
        [self.watchesInHandling removeObject:watch];
        self.watchesDoneHandlingCount = self.watchesDoneHandlingCount + 1;
    }
}

#define IXPORT_IN_PROGRESS_TIMEOUT 30*60


- (BOOL)ixportBatonAvailableForClidentifier:(NSString*)clidentifier
                                  jobSerial:(NSInteger)jobSerial {
    IxportBaton* existingBaton;
    @synchronized (_ixportsInProgessBatons) {
        existingBaton = [_ixportsInProgessBatons objectForKey:clidentifier];
    }
    IxportBatonState state;
    NSString* readableState;
    if (existingBaton) {
        NSTimeInterval timeSincePriorStart = -[existingBaton.date timeIntervalSinceNow];
        if (timeSincePriorStart > IXPORT_IN_PROGRESS_TIMEOUT) {
            state = IxportBatonStateBlockedButStale;
            readableState = @"blocked but stale";
            [readableState retain];
        } else {
            state = IxportBatonStateBlocked;
            readableState = [[NSString alloc] initWithFormat:
            @"blocked %0.1f secs",
            IXPORT_IN_PROGRESS_TIMEOUT - timeSincePriorStart ];
        }
    } else {
        state = IxportBatonStateFree;
        readableState = @"is free";
        [readableState retain];
    }

    [[BkmxBasis sharedBasis] forJobSerial:jobSerial
                                logFormat:
     @"Baton %@ %@", clidentifier, readableState];
    [readableState release];

    return state != IxportBatonStateBlocked;
}

- (BOOL)claimIxportBatonForClidentifier:(NSString*)clidentifier
                              jobSerial:(NSInteger)jobSerial
                                canWait:(BOOL)canWait {
    NSAssert(!canWait || ![[NSThread currentThread] isMainThread], @"Claiming baton with wait on main thread");
    [[BkmxBasis sharedBasis] forJobSerial:jobSerial
                                logFormat:
     @"Attempting to claim baton for clidentifier %@; can %@wait", clidentifier, canWait ? @"" : @"not "];
    while (YES) {
        BOOL available = [self ixportBatonAvailableForClidentifier:clidentifier
                                                         jobSerial:jobSerial];
        if (available) {
            @synchronized (_ixportsInProgessBatons) {
                IxportBaton* newBaton = [[IxportBaton alloc] init];
                newBaton.date = NSDate.date;
                newBaton.jobSerial = jobSerial;
                [_ixportsInProgessBatons setObject:newBaton
                                            forKey:clidentifier];
                [newBaton release];
            }
            return YES;
        } else if (canWait) {
            /* This should hardly ever occur. */
            sleep(10);
        } else {
            return NO;
        }
    }
}

- (void)unclaimIxportBatonForClidentifier:(NSString*)clidentifier
                                jobSerial:(NSInteger)jobSerial {
    IxportBaton* existingBaton;
    NSString* badNews;
    @synchronized (_ixportsInProgessBatons) {
        existingBaton = [_ixportsInProgessBatons objectForKey:clidentifier];
        if (existingBaton) {
            if (existingBaton.jobSerial == jobSerial) {
                [_ixportsInProgessBatons removeObjectForKey:clidentifier];
                badNews = @"";
                [badNews retain];
            } else {
                badNews = [[NSString alloc] initWithFormat:@"WHOOPS: was J%@", [Job serialStringForSerial:existingBaton.jobSerial]];
            }
        } else {
            badNews = [@"WHOOPS: Not existing" retain];
        }
    }

    [[BkmxBasis sharedBasis] forJobSerial:jobSerial
                                logFormat:
     @"Baton unclaimed %@%@", clidentifier, badNews];
    [badNews release];
}

- (NSString*)currentBatonsReport {
    NSMutableString* report = [[NSMutableString alloc] init];
    [report appendString:@"Active Batons:\n"];

    if ([_ixportsInProgessBatons count] > 0) {
        for (NSString* key in _ixportsInProgessBatons) {
            IxportBaton* baton = [_ixportsInProgessBatons objectForKey:key];
            [report appendFormat:@"%@ : %@", key, baton];
        }
    } else {
        [report appendString:@"\n[None]"];
    }
    [report appendString:@"\n"];

    NSString* answer = [report copy];
    [report release];
    [answer autorelease];

    return answer;
}



@end
