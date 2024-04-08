#import <Bkmxwork/Bkmxwork-Swift.h>
#import "NSError+Recovery.h"
#import "NSError+MyDomain.h"
#import "NSError+SSYInfo.h"
#import "NSError+DecodeCodes.h"
#import "BkmxDoc+Autosaving.h"
#import "TalderMap.h"
#import "ContentOutlineView.h"
#import "Syncer.h"
#import "AgentPerformer.h"
#import "BkmxBasis+Strings.h"
#import "BkmxAppDel+Actions.h"
#import "BkmxDocumentController.h"
#import "BkmxDocWinCon+Autosaving.h"
#import "Watch.h"
#import "Bookshig.h"
#import "Client.h"
#import "ClientChoice.h"
#import "ClientoidPlus.h"
#import "ClientsWizWinCon.h"
#import "ContentDataSource.h"
#import "Dupe.h"
#import "Dupetainer.h"
#import "ExtoreFirefox.h"
#import "ExtoreSafari.h"
#import "Importer.h"
#import "Exporter.h"
#import "NSData+FileAlias.h"
#import "NSString+SSYExtraUtils.h"
#import "OperationExport.h"
#import "NSDate+NiceFormats.h"
#import "NSDictionary+SimpleMutations.h"
#import "NSDocumentController+DisambiguateForUTI.h"
#import "NSDocumentController+MoreRecents.h"
#import "NSError+InfoAccess.h"
#import "NSFileManager+SomeMore.h"
#import "NSInvocation+Quick.h"
#import "NSString+LocalizeSSY.h"
#import "NSString+Truncate.h"
#import "NSUserDefaults+KeyPaths.h"
#import "NSString+BkmxURLHelp.h"
#import "SSYLaunchdBasics.h"
#import "SSYLaunchdGuy.h"
#import "SSYLicenseBuyController.h"
#import "SSYLicensor.h"
#import "SSYVersionTriplet+BkmxLegacyEffectivness.h"
#import "SSYMH.AppAnchors.h"
#import "Stark+Sorting.h"
#import "Stark+Attributability.h"
#import "Starker.h"
#import "Trigger.h"
#import "StarkTableColumn.h"
#import "VerifySummary.h"
#import "SSYOtherApper.h"
#import "NSUserDefaults+Bkmx.h"
#import "MAKVONotificationCenter.h"
#import "NSObject+DoNil.h"
#import "SSYLabelledTextField.h"
#import "SSYLicensePersistor.h"
#import "SSYAppInfo.h"
#import "SSYUuid.h"
#import "SSYOperationQueue.h"
#import "SSYMOCManager.h"
#import "Broker.h"
#import "SSYProcessTyper.h"
#import "SSYProgressView.h"
#import "NSArray+SSYMutations.h"
#import "NSNumber+Sharype.h"
#import "NSObject+MoreDescriptions.h"
#import "SSYDooDooUndoManager.h"
#import "NSArray+Stringing.h"
#import "SafariSyncGuardian.h"
#import "Command.h"
#import "NSString+BkmxDisplayNames.h"
#import "NSString+VarArgs.h"
#import "SSYEventInfo.h"
#import "Chaker.h"
#import "StarkEditor.h"
#import "Operation_Common.h"
#import "NSInvocation+Nesting.h"
#import "NSString+MorePaths.h"
#import "SSYAppleScripter.h"
#import "SSYSheetEnder.h"
#import "Macster.h"
#import "Starxid.h"
#import "Starxider.h"
#import "NSManagedObjectContext+Cheats.h"
#import "NSArray+SafeGetters.h"
#import "Dupester.h"
#import "NSBundle+AppIcon.h"
#import "Starlobute.h"
#import "Starlobuter.h"
#import "Stager.h"
#import "TalderMapper.h"
#import "Clixid.h"
#import "ExtoreOpera.h"
#import "NSUserDefaults+MainApp.h"
#import "NSBundle+MainApp.h"
#import "NSBundle+SSYMotherApp.h"
#import "NSEntityDescription+SSYMavericksBugFix.h"
#import "NSDocument+SSYAutosaveBetter.h"
#import "SSYBlocker.h"
#import "PrefsWinCon.h"
#import "NSDictionary+KeyPaths.h"
#import "BSManagedDocument+SSYAuxiliaryData.h"
#import "SSYRecurringDate.h"
#import "Watcher.h"

#if 0
#warning Logging memory management for BkmxDoc
#define LOGGING_MEMORY_MANAGEMENT_FOR_BkmxDoc 1
#import "SSYLinearFileWriter.h"
#endif

#define HAS_HARTAINERS_UNKNOWN      0x00
#define HAS_HARTAINERS_IS_VALID_BIT 0x01
#define HAS_HARTAINERS_BAR_BIT      0x10
#define HAS_HARTAINERS_MENU_BIT     0x20
#define HAS_HARTAINERS_UNFILED_BIT  0x40
#define HAS_HARTAINERS_OHARED_BIT   0x80

NSString* const constKeyHasBar = @"hasBar" ;
NSString* const constKeyHasMenu = @"hasMenu" ;
NSString* const constKeyHasOhared = @"hasOhared" ;
NSString* const constKeyHasUnfiled = @"hasUnfiled" ;
NSString* const constKeyMetal = @"metal" ;  // Meaning: "metadata-stored license information"

NSString* const constKeyCanCloseDelegate = @"canCloseDelegate" ;
NSString* const constKeyCanCloseShouldCloseSelector = @"canCloseShouldCloseSelector" ;
NSString* const constKeyCanCloseContextInfo = @"canCloseContextInfo" ;

// Upgrade States stored in metadata
NSString* const constKeySawChangeUpgradeOffered = @"sawChangeUpgradeOffered" ;

//  Notifications
NSString* const constNoteDupesMayContainVestiges = @"dupesMayContainVestiges" ;
NSString* const constNoteDupesMayContainDisparagees = @"dupesMayContainDisparagees" ;
NSString* const BkmxDocNotificationContentTouched = @"BkmxDocNotificationContentTouched" ;
NSString* const BkmxDocNotificationStarkTouched = @"BkmxDocNotificationStarkTouched" ;
NSString* const BkmxDocDidSaveNotification = @"BkmsDocDidSaveNotification";

NSString* const BkmxDocKeySaveOperation = @"BkmxDocSaveOperation";
NSString* const BkmxDocKeyDidSucceed = @"BkmxDocDidSucceed";

static BOOL userAffirmedNewSubfolderForNewBookmark ;

void NewSubfolderCallback(
                          CFUserNotificationRef userNotification,
                          CFOptionFlags responseFlags
                          ) ;

void NewSubfolderCallback(
                          CFUserNotificationRef userNotification,
                          CFOptionFlags responseFlags
                          );

void NewSubfolderCallback(
        CFUserNotificationRef userNotification,
        CFOptionFlags responseFlags
) {
    // Bitwise & with 0x3 per the fine print in document
    //     CFUserNotification > Response Codes > Discussion
    responseFlags = responseFlags & 0x3 ;
    switch (responseFlags) {
        case kCFUserNotificationDefaultResponse:
            // OK (right button)
            userAffirmedNewSubfolderForNewBookmark = YES ;
            break ;
        case kCFUserNotificationCancelResponse:
            // Maybe this response happens if the user clicks the "Close"
            // button on the CFUserNotification window, but I don't know
            // because the window we show does not have a "Close" button.
        case kCFUserNotificationAlternateResponse:
            // Cancel (left button)
            userAffirmedNewSubfolderForNewBookmark = NO ;
            break ;
        default:
            NSLog(@"Internal Error 593-9236") ;
            break ;
    }
}


/*
 Note ClangAndNSInvocationCategory

 For some stupid reason, if I copy and paste in the implementation of my
 -[NSInvocation invocationWithInvocations:] method (it is only two lines)
 instead of calling -[NSInvocation invocationWithInvocations:] when creating
 an invocation that is going to get an extra -retain because it is passing
 through contextInfo, the clang static analyzer does not complain of a
 memory leak.  So that is what I do!  But now I need to declare the method
 that is private to NSInvocation+Nesting.m. */
@interface NSInvocation ()
/*
 @details  This method is implemented in NSInvocation+Nesting.m
 */
+ (void)invokeInvocations:(NSArray*)invocations;
@end

@interface NSArray (ReorderForIxport)

- (NSArray*)arrayByReorderingForIxport  ;

@end

@implementation NSArray (ReorderForIxport)

- (NSArray*)arrayByReorderingForIxport  {
    NSMutableArray* output = [[NSMutableArray alloc] init] ;
    id firstObject = [self firstObjectSafely] ;
    if (firstObject) {
        [output addObject:firstObject] ;
    }
    for (NSInteger i=([self count] - 1) ; i>0; i--) {
        [output addObject:[self objectAtIndex:i]] ;
    }
    
    NSArray* answer = [[output copy] autorelease] ;
    [output release] ;
    
    return answer ;
}

@end


@interface BkmxDoc ()

@property (retain) NSString* priorSavedWithVersionString;
@property (retain) NSString* priorRequiresVersionString;
@property (retain) Bookshig* shig ;
@property (retain) Dupetainer* dupetainer ;
@property (assign) NSInteger priorNumberOfUndoActions ;
@property (assign) BOOL warnCantSyncNoClientsScheduled ;
@property (retain, atomic) SSYBlocker* waitForClientProfileBlocker ;
// Even though atomic is the default, I expressed it tom emphasize that
// waitForClientProfileBlocker *will* be accessed from multiple threads.
@property (assign, atomic) NSTimer* refreshVerifyTimer ;
@property (assign, atomic) BOOL isReloadingFromDisk;
@property (assign) BOOL didSuperClose;

- (void)saveDocument ;

@end


@implementation BkmxDoc


#pragma mark * Accessors

@synthesize shig = m_shig ;
@synthesize dupetainer = m_dupetainer ;
@synthesize error = m_error ;
@synthesize macster = m_macster ;
@synthesize lastContentTouchDate ;
@synthesize isReverting = m_isReverting ;
@synthesize isSupercededByNewFileOnDisk = m_isSupercededByNewFileOnDisk ;
@synthesize warnCantSyncNoClientsScheduled = m_warnCantSyncNoClientsScheduled ;
@synthesize isReloadingFromDisk = m_isReloadingFromDisk;
@synthesize didSuperClose = m_didSuperClose;
@synthesize isZombie = m_isZombie ;
@synthesize skipAutomaticActions ;
@synthesize priorNumberOfUndoActions = m_priorNumberOfUndoActions ;
@synthesize importedExtores = m_importedExtores ;
@synthesize ignoreChanges = m_ignoreChanges ;
@synthesize shouldSkipAfterSaveHousekeeping = m_shouldSkipAfterSaveHousekeeping ;
@synthesize didImportPrimarySource = m_didImportPrimarySource ;
@synthesize currentPerformanceType = m_currentPerformanceType ;
@synthesize cleaningTimers = m_cleaningTimers ;
@synthesize waitForClientProfileBlocker = m_waitForClientProfileBlocker ;
@synthesize lastLandedBookmark = m_lastLandedBookmark ;
@synthesize refreshVerifyTimer = m_refreshVerifyTimer ;
/* uuid exactly mirrors what is in the auxiliary data plist but is cached
 so that we don't need to do disk access every time uuid is needed.  This
 may be premature optimization but it was easier to do than testing
 whether or not it is needed. */
@synthesize uuid = m_uuid;

+ (Class)undoManagerClass; {
    Class class = nil;
    if ([[BkmxBasis sharedBasis] isBkmxAgent]) {
        // BkmxAgent does not want an undo manager
        class = nil;
    } else {
        class = [SSYDooDooUndoManager class];
    }
    
    return class;
}

- (void)unlockWaitingForClientProfile {
    [[self waitForClientProfileBlocker] unlockLock] ;
}

- (void)lockWaitingForClientProfile {
    SSYBlocker* blocker = [[SSYBlocker alloc] init] ;
    [self setWaitForClientProfileBlocker:blocker] ;
    [blocker release] ;
    [blocker lockLock] ;
}

- (void)blockWaitingForClientProfile {
    [[self waitForClientProfileBlocker] blockForLock] ;
}


#pragma * Lock out attempts to save while save is already in progress

/*!
 @bried    Override of base class method which is a no-op in case we are
 running in a GUI-less tool (Sheep-Sys-Workder) or are in background mode
 
 @details  Note that when NSPersistentDocument reverts, unlike NSDocument, it
 destroys any windows.  What about BSManagedDocument?
 */
- (void)makeWindowControllers {
    BOOL isForeground = ([SSYProcessTyper currentType] == NSApplicationActivationPolicyRegular) ;
    BOOL isMainApp = (![[BkmxBasis sharedBasis] isBkmxAgent]) ;
    
    if (isMainApp && isForeground) {
        BkmxDocWinCon* bkmxDocWinCon = [[BkmxDocWinCon alloc] init] ;
        [self addWindowController:bkmxDocWinCon] ;
        [bkmxDocWinCon release] ;
        [self showWindows] ;
    }
}

/*!
 @brief    For AppleScriptability.  This is really a property
 of the associated Macster, but we fake it.
 */
- (NSArray*)syncersOrdered {
    return [[self macster] syncersOrdered] ;
}
- (void)setAgentsOrdered:(NSArray*)syncersOrdered {
    [[self macster] setSyncersOrdered:syncersOrdered] ;
}

- (void)makeNewLocalClientWithExformat:(NSString*)exformat
                           profileName:(NSString*)profileName {
    [[self macster] makeNewLocalClientWithExformat:exformat
                                       profileName:profileName] ;
}

- (void)deleteAllClients {
    [[self macster] deleteAllClients] ;
}

#if 0
// I think this is bug was fixed in BookMacster 1.12.3.
// If no more complaints from Gregory Ventana, should delete this and all related code.
#warning Debugging Recent Landings
- (BOOL)shouldDebugRecentLandings {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"debugRecentLandings"] ;
}

#define DEBUG_RECENT_LANDINGS 0
#endif
- (void)addRecentLanding:(Stark*)newLanding {
    // The array in user default stores starkids.
    NSString* starkid = [newLanding starkid] ;
    
    // Add the new starkid
    NSArray* rawRecentLandings = [self autosavedRecentLandings] ;
#if DEBUG_RECENT_LANDINGS
    NSDictionary* starksByStarkid = [[self starker] starksKeyedByKey:constKeyStarkid] ;
    if ([self shouldDebugRecentLandings]) {
        NSLog(@"DBRL-ADD-0 Adding: %@ %@=%@", starkid, [newLanding name], [[starksByStarkid objectForKey:starkid] name]) ;
        NSLog(@"DBRL-ADD-1    Retrieved %ld recent landings for %@:", (long)[rawRecentLandings count], [self uuid]) ;
        for (NSString* aStarkid in rawRecentLandings) {
            NSLog(@"DBRL-ADD-2       %@ %@", aStarkid, [[starksByStarkid objectForKey:aStarkid] name]) ;
        }
    }
#endif
    if (rawRecentLandings) {
        rawRecentLandings = [rawRecentLandings arrayByInsertingObject:starkid
                                                              atIndex:0] ;
    }
    else {
        rawRecentLandings = [NSArray arrayWithObject:starkid] ;
#if DEBUG_RECENT_LANDINGS
        if ([self shouldDebugRecentLandings]) {
            NSLog(@"DBRL-ADD-3    Nil recent landings!") ;
        }
#endif
    }
    
    // Remove earlier duplicates and truncate
    NSMutableArray* newRecentLandings = [rawRecentLandings mutableCopy] ;
    [newRecentLandings removeEqualObjects] ;
    [newRecentLandings trimToStartIndex:0
                                  count:[[NSUserDefaults standardUserDefaults] integerForKey:constKeyLandingRecents]] ;
    
    // Save new array to user defaults
#if DEBUG_RECENT_LANDINGS
    if ([self shouldDebugRecentLandings]) {
        NSLog(@"DBRL-ADD-4       Setting %ld:", (long)[newRecentLandings count]) ;
        for (NSString* bStarkid in newRecentLandings) {
            NSLog(@"DBRL-ADD-5          %@ %@", bStarkid, [[starksByStarkid objectForKey:bStarkid] name]) ;
        }
    }
#endif
    [self autosaveRecentLandings:newRecentLandings] ;
    [newRecentLandings release] ;
}

- (NSArray*)recentLandings {
    // Get the array of starkids from user defaults
    NSArray* rawRecentLandings = [self autosavedRecentLandings] ;
    
    // Fetch the stark for each starkid, building array of
    // starks (recentLandings) and starkids (recentLandingStarkids)
    // Omit any for which stark cannot be found (has been deleted)
    // and limit the number of each
    NSDictionary* starksByStarkid = [[self starker] starksKeyedByKey:constKeyStarkid] ;
#if DEBUG_RECENT_LANDINGS
    if ([self shouldDebugRecentLandings]) {
        NSLog(@"DBRL-GET-0 Getting") ;
        NSLog(@"DBRL-GET-1    Retrieved %ld recent landings for %@:", (long)[rawRecentLandings count], [self uuid]) ;
        for (NSString* aStarkid in rawRecentLandings) {
            NSLog(@"DBRL-GET-2       %@ %@", aStarkid, [[starksByStarkid objectForKey:aStarkid] name]) ;
        }
    }
#endif
    NSMutableArray* recentLandingStarkids = [[NSMutableArray alloc] init] ;
    NSMutableArray* recentLandings = [[NSMutableArray alloc] init] ;
    NSInteger count = 0 ;
    for (NSString* starkid in rawRecentLandings) {
        Stark* stark = [starksByStarkid objectForKey:starkid] ;
        if (stark) {
            [recentLandings addObject:stark] ;
            [recentLandingStarkids addObject:starkid] ;
            count++ ;
            if (count >= [[NSUserDefaults standardUserDefaults] integerForKey:constKeyLandingRecents]) {
                break ;
            }
        }
        else {
#if DEBUG_RECENT_LANDINGS
            if ([self shouldDebugRecentLandings]) {
                NSLog(@"DBRL-GET-3    Removing because it is no longer found: %@ %@", starkid, [stark name]) ;
            }
#endif
            
        }
    }
    
    [self autosaveRecentLandings:recentLandingStarkids] ;
#if DEBUG_RECENT_LANDINGS
    if ([self shouldDebugRecentLandings]) {
        NSLog(@"DBRL-GET-4       Setting %ld:", (long)[recentLandingStarkids count]) ;
        for (NSString* bStarkid in recentLandingStarkids) {
            NSLog(@"DBRL-GET-5          %@ %@", bStarkid, [[starksByStarkid objectForKey:bStarkid] name]) ;
        }
    }
#endif
    
    NSArray* answer = [recentLandings copy] ;
    [recentLandings release] ;
    [recentLandingStarkids release] ;
    
    return [answer autorelease] ;
}

/*!
 @details  Since the managed object context always remains the same, except
 after -[NSPersistentDocument revertToContentsOfURL::: in macOS 10.12 or later,
 we can use this one-shot getter…  What about BSManagedDocument?
 */
- (Starker*)starker {
    if (!m_starker) {
        m_starker = [[Starker alloc] initWithManagedObjectContext:[self managedObjectContext]
                                                            owner:self] ;
    }
    
    return m_starker ;
}

- (void)setStarker:(Starker*)starker {
    [m_starker release];
    m_starker = starker;
    [m_starker retain];
}

- (Tagger*)tagger {
    if (!m_tagger) {
        m_tagger = [[Tagger alloc] initWithManagedObjectContext:[self managedObjectContext]];
    }
    
    return m_tagger ;
}

- (void)setTagger:(Tagger*)tagger {
    [m_tagger release];
    m_tagger = tagger;
    [m_tagger retain];
}

/*!
 @details  This is necessary when executing
 -[NSPersistentDocument revertToContentsOfURL::: in macOS 10.12 or later,
 because that method gives you a new managed object context.
 What about BSManagedDocument?
 */
- (void)forgetStarkerAndTagger {
    [self setStarker:nil];
    [self setTagger:nil];
}

- (SSYOperationQueue*)operationQueue {
    if (!m_operationQueue) {
        m_operationQueue = [[SSYOperationQueue alloc] init] ;
    }
    
    return m_operationQueue ;
}

- (void)forgetOperationQueue {
    /* The following is intended to allow the operation in progress to
     finish.  I think it has no effect because that stuff is happening
     on aother thread. */
    [self.operationQueue setSuspended:NO];
    [self.operationQueue cancelAllOperations];
    
    [m_operationQueue release];
    m_operationQueue = nil;
}

- (void)linkToMacster {
    NSString* uuid = [self uuid] ;
    if (!uuid) {
        NSLog(@"Internal Error 613-9257  No uuid to link Macster") ;
        return ;
    }
    
    Macster* macster = [[BkmxBasis sharedBasis] macsterWithDocUuid:uuid
                                                      createIfNone:YES] ;
    
    [macster setBkmxDoc:self] ;
    [self setMacster:macster] ;
}

- (void)unlinkBkmxDocMacster {
    // The -isInViewingMode condition was added in BookMacster 1.9.8 to fix
    // Bug 00001, which is that a BkmxDoc had a nil macster after being
    // restored from Lion's Versions Browser.  Therefore, none of the Local
    // Settings would have any effect.  For example, setting or unsetting
    // a Syncer would have no effect on launchd agents.  The only problem
    // I've seen with this is that, most of the time, the Macster does not deallocate
    // after its document has been resurrected from the Versions Browser
    // and then closed.  The BkmxDoc deallocs after about 10 seconds.
    // And a new Macster is created when the document is reopened, so that
    // looks pretty bad.  But one time it did deallocate.
    if (![self ssy_isInViewingMode]) {
        [[self macster] setBkmxDoc:nil] ;
        [[self macster] breakRetainCycles] ;
        [self setMacster:nil] ;
    }
}

/*
 Bound to by agentsAC, triggerAC and commandsAC in window
 */
- (NSManagedObjectContext*)settingsMoc {
    NSError* error = nil;
    NSManagedObjectContext* moc = [[BkmxBasis sharedBasis] settingsMocForIdentifier:[self uuid]
                                                                            error_p:&error];
    if (error) {
        [[BkmxBasis sharedBasis] logError:error
                          markAsPresented:NO];
    }
    
    return moc;
}

- (NSManagedObjectContext*)exidsMoc {
    return [[BkmxBasis sharedBasis] exidsMocForIdentifier:[self uuid]];
}

/*
 Bound to in Reports.xib
 */
- (NSManagedObjectContext*)diariesMoc {
    return [[BkmxBasis sharedBasis] diariesMocForIdentifier:[self uuid]];
}

/* Is this necessary? Think: uuid never changes.  But aybe it does
 change during a "Save as" operations? */
+ (NSSet*)keyPathsForValuesAffectingDiariesMoc {
    return [NSSet setWithObjects:
            @"uuid",
            nil] ;
}

- (NSManagedObject*)fetchSingularManagedObjectForEntity:(NSString*)entityName {
    NSManagedObjectContext* context = [self managedObjectContext];
    
    // Since one is placed in the store when a new document is
    // created, there should be one in there
    NSInteger findings = 0 ;
    NSManagedObject* object = [context singularObjectOfEntityName:entityName
                                                        predicate:nil
                                                       findings_p:&findings] ;
    if (findings != 1) {
        NSLog(@"Warning 727-0393  Expected 1 %@ in %@, found %ld.  Fixed.",
              entityName, [self displayName], (long)findings) ;
        
        if ([[BkmxDocumentController sharedDocumentController] respondsToSelector:@selector(isDuplicating)]) {
            if (![[BkmxDocumentController sharedDocumentController] isDuplicating]) {
                [self saveDocument:self] ;
            }
        } else {
            [self saveDocument:self] ;
        }
        // We do the above instead of sending -save: to our
        // managed object context, because the latter results
        // in the annoying "file has been changed by another application"
        // warning if user subsequently dirties and saves it.
        // Note: The above was noted pre-Lion.  Not sure what happens
        // with Auto Save.
    }
    
    return object ;
}

- (void)setFreshUuid {
    [self setUuid:[SSYUuid uuid]] ;
    [self removeAnyGhostSyncers] ;
}

- (void)writeUuidToDisk {
    NSString* uuid = self.uuid;
    if (uuid) {
        BSManagedDocumentAuxiliaryDataWriteResult result = [self setAuxiliaryObject:uuid
                                                                             forKey:constKeyDocUuid];
        NSString* msg;
        switch (result) {
            case BSManagedDocumentAuxiliaryDataWriteResultFailed:
                msg = [NSString stringWithFormat:
                       @"Did not write docUuid %@ to disk (no file yet?)",
                       [uuid substringToIndex:4]];
                break;
            case BSManagedDocumentAuxiliaryDataWriteResultDid:
                msg = [NSString stringWithFormat:
                       @"Wrote docUuid %@ to disk in %@",
                       [uuid substringToIndex:4],
                       self.fileURL.path];
                break;
            case BSManagedDocumentAuxiliaryDataWriteResultUnnecessary:
                msg = [NSString stringWithFormat:
                       @"docUuid already on disk: %@ in %@",
                       [uuid substringToIndex:4],
                       self.fileURL.path];
                break;
        }
        
        [[BkmxBasis sharedBasis] forJobSerial:0
                                    logString:msg];
    }
}

- (void)setUuid:(NSString*)uuid {
    [m_uuid release];
    [uuid retain];
    m_uuid = uuid;
    
    [[BkmxBasis sharedBasis] forJobSerial:0
                                logFormat:
     @"Set document uuid to %@",
     [uuid substringToIndex:4]];
    
    if (uuid) {
        [self writeUuidToDisk];
    }
}

- (NSString*)uuid {
    if (!m_uuid) {
        NSString* uuidFromDisk = [self auxiliaryObjectForKey:constKeyDocUuid];
        if (uuidFromDisk) {
            m_uuid = [uuidFromDisk retain];
        }
    }
    
    return [[m_uuid copy] autorelease];
}

- (Starxider*)starxider {
    if (!m_starxider  && ![self isZombie]) {
        // Occurs once after document is created,
        // also after -forgetStarxider during Save As
        m_starxider = [[Starxider alloc] initWithDocUuid:[self uuid]] ;
    }
    
    return m_starxider ;
}

- (void)forgetStarxider {
    [m_starxider release] ;
    m_starxider = nil ;
}

- (Starlobuter*)starlobuter {
    if (!m_starlobuter  && ![self isZombie]) {
        // Only occurs once during life of the document; also after -forgetStarlobuter during Save As
        m_starlobuter = [[Starlobuter alloc] initWithDocUuid:[self uuid]] ;
    }
    
    return m_starlobuter ;
}

- (void)forgetStarlobuter {
    [m_starlobuter release] ;
    m_starlobuter = nil ;
}

- (TalderMapper*)talderMapper {
    if (!m_talderMapper  && ![self isZombie]) {
        /*
         Only occurs once during life of the document; also after
         -clearTaldermapper during Save As and when TalderMap sheet is done:
         */
        m_talderMapper = [[TalderMapper alloc] initWithDocUuid:[self uuid]] ;
    }
    
    return m_talderMapper ;
}

- (void)clearTalderMapper {
    [m_talderMapper release] ;
    m_talderMapper = nil ;
}


#pragma mark * Managing Clients

- (NSNumber*)lastPreImportedHashForClient:(Client*)client
                                whichPart:(BkmxDocHashPart)whichPart {
    NSNumber* hash = [m_clientLastPreImportedHashes objectForKey:[[client clientoid] clidentifier]] ;
    if (!hash) {
        hash = [[NSUserDefaults standardUserDefaults] lastImportPreHashForClientoid:client.clientoid] ;
    }
    
    if (hash) {
        if (whichPart == BkmxDocHashPartsBoth) {
            // We're done
        }
        else {
            // We need to extract either the top half or bottom half
            uint32_t desiredHalf ;
            if (whichPart == BkmxDocHashPartExtore) {
                // For import hash, the extore is the bottom half.
                // In the following line, we extract the bottom 32 bits of the
                // 64-bit number represented by the value of 'hash'.
                desiredHalf = (uint32_t)[hash unsignedLongValue] ;
            }
            else { // whichPart must be BkmxDocHashPartBkmxDoc
                // For import hash, the BkmxDoc is the top half.
                // That is, we extract the top 32 bits of the
                // 64-bit number represented by the value of 'hash'.
                unsigned long long whole64 = [hash unsignedLongLongValue] ;
                desiredHalf = whole64 >> 32 ;
            }
            
            // Repackage into an object
            hash = [NSNumber numberWithUnsignedLong:desiredHalf] ;
        }
    }
    
    return hash ;
}

- (void)rememberLastPreImportedHashForExtore:(Extore*)extore {
    /* This method is not used, but maybe should be.  See
     Note WhyNotRememberLastPreImportedHashForExtore. */
    /*
     if (!m_clientLastPreImportedHashes) {
     m_clientLastPreImportedHashes = [[NSMutableDictionary alloc] init] ;
     }
     
     Client* client = [extore client] ;
     uint32_t compositeSettingsHash = [[client importer] compositeImportSettingsHash] ;
     uint32_t top = [self contentHash] ^ compositeSettingsHash ;
     BOOL debugIxportHashes = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppBoolForKey:constKeyDebugIxportHashes];
     if (debugIxportHashes) {
     [Stark debug_clearHashComponents] ;
     }
     uint32_t contentHash = [extore contentHash] ;
     if (debugIxportHashes) {
     [Stark debug_writeHashComponentsToDesktopWithPhaseName:@"RIHPr"
     clientName:[client displayName]];
     }
     uint32_t bottom = contentHash ^ compositeSettingsHash ;
     uint64_t hash = ((unsigned long long)top << 32) + bottom ;
     
     if (debugIxportHashes) {
     NSString* msg = [NSString stringWithFormat:@"RIHPr: %@: %08lx ^ %08lx = %08lx",
     [client displayName],
     (long)contentHash,
     (long)compositeSettingsHash,
     (long)bottom];
     [[BkmxBasis sharedBasis] logFormat:msg];
     }
     [m_clientLastPreImportedHashes setObject:[NSNumber numberWithUnsignedLongLong:hash]
     forKey:[[client clientoid] clidentifier]] ;
     */
}

- (NSNumber*)lastPostImportedHashForClient:(Client*)client
                                 whichPart:(BkmxDocHashPart)whichPart {
    NSNumber* hash = [[NSUserDefaults standardUserDefaults] lastImportPostHashForClientoid:client.clientoid];
    
    if (hash) {
        if (whichPart == BkmxDocHashPartsBoth) {
            // We're done
        }
        else {
            // We need to extract either the top half or bottom half
            uint32_t desiredHalf ;
            if (whichPart == BkmxDocHashPartExtore) {
                // For import hash, the extore is the bottom half.
                // In the following line, we extract the bottom 32 bits of the
                // 64-bit number represented by the value of 'hash'.
                desiredHalf = (uint32_t)[hash unsignedLongValue] ;
            }
            else { // whichPart must be BkmxDocHashPartBkmxDoc
                // For import hash, the BkmxDoc is the top half.
                // That is, we extract the top 32 bits of the
                // 64-bit number represented by the value of 'hash'.
                unsigned long long whole64 = [hash unsignedLongLongValue] ;
                desiredHalf = whole64 >> 32 ;
            }
            
            // Repackage into an object
            hash = [NSNumber numberWithUnsignedLong:desiredHalf] ;
        }
    }
    
    return hash ;
}

- (void)rememberLastPostImportedHashForExtore:(Extore*)extore {
    BOOL debugIxportHashes = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppBoolForKey:constKeyDebugIxportHashes];
    Client* client = [extore client] ;
    uint32_t compositeSettingsHash = [[NSUserDefaults standardUserDefaults] compositeImportSettingsHashForClientoid:client.clientoid] ;
    uint32_t top = [self contentHash] ^ compositeSettingsHash ;
    if (debugIxportHashes) {
        [Stark debug_clearHashComponents] ;
    }
    uint32_t contentHash = [extore contentHash] ;
    if (debugIxportHashes) {
        [Stark debug_writeHashComponentsToDesktopWithPhaseName:@"RIHPo"
                                                    clientName:[client displayName]];
    }
    uint32_t bottom = contentHash ^ compositeSettingsHash ;
    uint64_t hash = ((unsigned long long)top << 32) + bottom ;
    
    if (debugIxportHashes) {
        NSString* msg = [NSString stringWithFormat:@"RIHPo: %@: %08lx ^ %08lx = %08lx",
                         [client displayName],
                         (long)contentHash,
                         (long)compositeSettingsHash,
                         (long)bottom];
        [[BkmxBasis sharedBasis] logFormat:msg];
    }
    NSString* clidentifier = client.clientoid.clidentifier;
    if (clidentifier) {
        [[NSUserDefaults standardUserDefaults] setLastImportPostHash:@(hash)
                                                        clidentifier:clidentifier];
    }
}

- (void)rememberBothLastImportedHashForExtore:(Extore*)extore {
    if (!m_clientLastPreImportedHashes) {
        m_clientLastPreImportedHashes = [[NSMutableDictionary alloc] init] ;
    }
    
    Client* client = [extore client] ;
    NSString* key = [[client clientoid] clidentifier];
    if (key) {
        uint32_t compositeSettingsHash = [[NSUserDefaults standardUserDefaults] compositeImportSettingsHashForClientoid:client.clientoid] ;
        uint32_t top = [self contentHash] ^ compositeSettingsHash ;
        BOOL debugIxportHashes = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppBoolForKey:constKeyDebugIxportHashes];
        if (debugIxportHashes) {
            [Stark debug_clearHashComponents] ;
        }
        uint32_t contentHash = [extore contentHash] ;
        if (debugIxportHashes) {
            [Stark debug_writeHashComponentsToDesktopWithPhaseName:@"RIHBo"
                                                        clientName:[client displayName]];
        }
        uint32_t bottom = contentHash ^ compositeSettingsHash ;
        uint64_t hash = ((unsigned long long)top << 32) + bottom ;
        
        if (debugIxportHashes) {
            NSString* msg = [NSString stringWithFormat:@"RIHBo: %@: %08lx ^ %08lx = %08lx",
                             [client displayName],
                             (long)contentHash,
                             (long)compositeSettingsHash,
                             (long)bottom];
            [[BkmxBasis sharedBasis] logFormat:msg];
        }
        NSNumber* hashNumber = [NSNumber numberWithUnsignedLongLong:hash];
        
        [m_clientLastPreImportedHashes setObject:hashNumber
                                          forKey:key] ;
        
        NSString* clidentifier = client.clientoid.clidentifier;
        if (clidentifier) {
            [[NSUserDefaults standardUserDefaults] setLastImportPostHash:@(hash)
                                                            clidentifier:clidentifier];
        }
        
        [self saveMacster];
    }
}

- (NSNumber*)lastPreExportedHashForClient:(Client*)client {
    NSNumber* hash = [m_clientLastPreExportedHashes objectForKey:[[client clientoid] clidentifier]] ;
    if (!hash) {
        hash = [[NSUserDefaults standardUserDefaults] lastExportPreHashForClientoid:client.clientoid] ;
    }
    
    return hash ;
}

- (void)saveMacster {
    [[self macster] save] ;
}

- (void)setLastPreExportedHash:(unsigned long long)hash
                     forClient:(Client*)client {
    if (!client) {
        NSLog(@"Internal Error 918-0912") ;
        return ;
    }
    NSString* clidentifier = [[client clientoid] clidentifier] ;
    if (!clidentifier) {
        NSLog(@"Internal Error 918-0912 %@", [client shortDescription]) ;
        return ;
    }
    
    if (!m_clientLastPreExportedHashes) {
        m_clientLastPreExportedHashes = [[NSMutableDictionary alloc] init] ;
    }
    
    NSNumber* hashObject = [NSNumber numberWithUnsignedLongLong:hash] ;
    [m_clientLastPreExportedHashes setObject:hashObject
                                      forKey:clidentifier] ;
}

- (void)forgetLastPreImportedHashForClient:(Client*)client {
    if ([client isAvailable]) {
        NSString* clidentifier = client.clientoid.clidentifier;
        if (clidentifier) {
            [m_clientLastPreImportedHashes removeObjectForKey:clidentifier] ;
            [[NSUserDefaults standardUserDefaults] setLastImportPreHash:nil
                                                           clidentifier:clidentifier];
            [self saveMacster] ;
            BOOL debugIxportHashes = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppBoolForKey:constKeyDebugIxportHashes];
            if (debugIxportHashes) {
                [[BkmxBasis sharedBasis] logFormat:@"Did forget pre-import hash for %@", [client displayName]] ;
            }
        }
    }
}

- (void)forgetLastPostImportedHashForClient:(Client*)client {
    if ([client isAvailable]) {
        NSString* clidentifier = client.clientoid.clidentifier;
        if (clidentifier) {
            [[NSUserDefaults standardUserDefaults] setLastImportPostHash:nil
                                                            clidentifier:clidentifier];
            [self saveMacster] ;
            BOOL debugIxportHashes = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppBoolForKey:constKeyDebugIxportHashes];
            if (debugIxportHashes) {
                [[BkmxBasis sharedBasis] logFormat:@"Did forget post-import hash for %@", [client displayName]] ;
            }
        }
    }
}

- (void)forgetAllLastPreImportedHashes {
    [m_clientLastPreImportedHashes release] ;
    m_clientLastPreImportedHashes = nil ;
    
    for (Client* client in [[self macster] clients]) {
        NSString* clidentifier = client.clientoid.clidentifier;
        if (clidentifier) {
            [[NSUserDefaults standardUserDefaults] setLastImportPreHash:nil
                                                           clidentifier:clidentifier];
        }
    }
    BOOL debugIxportHashes = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppBoolForKey:constKeyDebugIxportHashes];
    if (debugIxportHashes) {
        [[BkmxBasis sharedBasis] logFormat:@"Did forget import hash for ALL clients"] ;
    }
}

- (void)forgetAllLastPreImportedHashesNote:(NSNotification*)note {
    [self forgetAllLastPreImportedHashes] ;
}

- (void)forgetLastPreExportedHashForClient:(Client*)client {
    if ([client isAvailable]) {
        NSString* clidentifier = client.clientoid.clidentifier;
        if (clidentifier) {
            [m_clientLastPreExportedHashes removeObjectForKey:clidentifier] ;
            [[NSUserDefaults standardUserDefaults] setLastExportPreHash:nil
                                                           clidentifier:clidentifier];
            [self saveMacster] ;
        }
    }
}

- (NSDate*)lastImportedDateForClient:(Client*)client {
    NSDate* persistedDate = [client lastImported] ;
    NSDate* date = [m_clientLastImportedDates objectForKey:[[client clientoid] clidentifier]] ;
    if (persistedDate && date) {
        // Both persisted and volatile dates exist; take the later
        date = [persistedDate laterDate:date] ;
    }
    else if (persistedDate) {
        // Only persisted date exists
        date = persistedDate ;
    }
    else {
        // Only the volatile date, or neither date, exists.
        // Return the volatile date, possibly nil.
    }
    
    return date ;
}

- (void)setAsNowLastImportedDateForClient:(Client*)client {
    if (!m_clientLastImportedDates) {
        m_clientLastImportedDates = [[NSMutableDictionary alloc] init] ;
    }
    
    [m_clientLastImportedDates setObject:[NSDate date]
                                  forKey:[[client clientoid] clidentifier]] ;
}

- (void)setAsNowLastImportedDateForClients {
    NSArray* activeImporters = [[self macster] activeImportersOrdered] ;
    NSDate* now = [NSDate date] ;
    for (Ixporter* importer in activeImporters) {
        if (!m_clientLastImportedDates) {
            m_clientLastImportedDates = [[NSMutableDictionary alloc] init] ;
        }
        
        [m_clientLastImportedDates setObject:now
                                      forKey:[[[importer client] clientoid] clidentifier]] ;
    }
}

- (void)forgetVolatileLastPreExportedDataForClientoid:(Clientoid*)clientoid {
    [m_clientLastPreExportedHashes removeObjectForKey:clientoid.clidentifier];
}

- (void)forgetAllClientsVolatileLastIxportedData {
    [m_clientLastImportedDates release] ;
    m_clientLastImportedDates = nil ;
    
    [m_clientLastPreImportedHashes release] ;
    m_clientLastPreImportedHashes = nil ;
    
    BOOL debugIxportHashes = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppBoolForKey:constKeyDebugIxportHashes];
    if (debugIxportHashes) {
        [[BkmxBasis sharedBasis] logFormat:@"Did forget *all* hashes for *all* clients"] ;
    }
    
    [m_clientLastPreExportedHashes release] ;
    m_clientLastPreExportedHashes = nil ;
}

- (void)persistClientLastPreImportedData {
    NSNumber* hash ;
    
    for (NSString* clidentifier in m_clientLastPreImportedHashes) {
        hash = [m_clientLastPreImportedHashes objectForKey:clidentifier] ;
        Client* client = nil ;
        
        // Persist the hash value
        if (hash) {
            client = [[self macster] clientForClidentifier:clidentifier] ;
            Clientoid* clientoid = client.clientoid;
            if (clientoid.clidentifier) {
                [[NSUserDefaults standardUserDefaults] setLastImportPreHash:hash
                                                               clidentifier:clidentifier];
                BOOL debugIxportHashes = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppBoolForKey:constKeyDebugIxportHashes];
                if (debugIxportHashes) {
                    [[BkmxBasis sharedBasis] logFormat:@"Did persist import hash for %@", [client displayName]] ;
                }
            }
        }
        
        // Persist the date value
        NSDate* newDate = [m_clientLastImportedDates objectForKey:clidentifier] ;
        if (newDate) {
            // Re-use the client from above if we have one
            if (!client) {
                // hash must have been nil
                client = [[self macster] clientForClidentifier:clidentifier] ;
            }
            NSDate* oldDate = [client lastImported] ;
            if (!oldDate || ([newDate compare:oldDate] == NSOrderedDescending)) {
                [client setLastImported:newDate] ;
            }
        }
    }
    
    [self saveMacster] ;
}

- (void)persistClientLastPreExportedData {
    // BookMacster 1.9.8.  Ditto comments in -persistClientLastPreImportedData
    for (NSString* clidentifier in m_clientLastPreExportedHashes) {
        NSNumber* hash = [m_clientLastPreExportedHashes objectForKey:clidentifier] ;
        if (hash) {
            Client* client = [[self macster] clientForClidentifier:clidentifier] ;
            NSString* clidentifier = client.clientoid.clidentifier;
            if (clidentifier) {
                [[NSUserDefaults standardUserDefaults] setLastExportPreHash:hash
                                                               clidentifier:clidentifier];
            }
        }
    }
    
    [self saveMacster] ;
}

- (void)addImportedExtore:(Extore*)extore {
    if (![self importedExtores]) {
        [self setImportedExtores:[NSMutableArray array]] ;
    }
    
    [[self importedExtores] addObject:extore] ;
}

- (BOOL)wasImportableStark:(Stark*)stark {
    for (Extore* extore in [self importedExtores]) {
        if ([extore isExportableStark:stark
                           withChange:nil]) {
            return YES ;
        }
    }
    
    return NO ;
}

- (uint32_t)contentHash {
    NSArray* hashableAttributes = [Stark hashableAttributes] ;
    Stark* root = [[self starker] root] ;
    uint32_t contentHash = [root valuesHashOfAttributes:hashableAttributes] ;
    return contentHash ;
}

- (NSSet*)unsupportedAttributesForSeparators {
    return [NSSet set];
}

- (BOOL)canEditSeparatorsInAnyStyle {
    return YES;
}

#pragma mark * Opening, Creating, Re-Opening Documents

// These little patches are required because [self dupetainer] does
// not work during -init.  So we have to make ourself the
// observer and forward the message.  Also it's probably not a
// good practice to set another object to be an observer, since
// it won't "match" in the same implementation with the
// [[NSNotificationCenter defaultCenter] removeObserver:self].
- (void)checkAndRemoveDupeDisparagees {
    [[self dupetainer] checkAndRemoveDupeDisparagees] ;
    [[self bkmxDocWinCon] reloadAll] ;
}
- (void)checkAndRemoveDupeVestiges {
    [[self dupetainer] checkAndRemoveDupeVestiges] ;
    [[self bkmxDocWinCon] reloadAll] ;
}


#if 0
// The following crap is no longer needed since I started using GCUndoManager!!  Yippee!!!
// This method is for avoiding undo registration and the "dirty dot"
// for any previous actions.
- (void)clearAllChanges {
    /*
     Explanation by Quincey Morris:
     
     Problem: Changes to a managed object context *may* register an undo action with
     the undo manager, *or* create a "pending" change that the undo manager isn't
     told about yet. It's an implementation detail which of the two happens, and
     it can be either way in any given case.
     
     Solution: If the change is registered with the undo manager, you can just tell
     it to remove the change. If the change is pending, there's no way to remove it
     directly, so you must force it to be registered (processPendingChanges) and then
     you can tell the undo manager to remove it (removeAllActions).
     
     Jerry notes that: This solution will clear ALL pending changes, so this can only be
     used when the document is initially opened, not after any changes which really
     should make the document dirty have been made.  The dirty dot will be clean after
     this method runs.
     */
    
    if ([self isReverting]) {
        [self setIsReverting:NO] ;
    }
    else {
        // Normal document opening
        [[self managedObjectContext] processPendingChanges] ;
        [[[self managedObjectContext] undoManager] removeAllActions] ;  // Also sets groupingLevel to 0
        [self updateChangeCount:NSChangeCleared] ;
    }
}
#endif

/* The following override serves two purposes:
 1.  Eliminates compiler warnings when -undoManager is sent SSYDooDooUndoManager
 messages not supported by the base class NSUndoManager.
 2.  Ensures that, in BkmxAgent, NSDocument will not try to
 create an undo manager after I have set it to nil in -initializeCommonAfterPersistenceStackIsUp
.
 */
- (SSYDooDooUndoManager*)undoManager {
    if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
        return (SSYDooDooUndoManager*)[super undoManager] ;
    }
    else {
        return nil ;
    }
}

- (void)finalizeEditsNote:(NSNotification*)note {
    // As always, I use [[self managedObjectContext] hasChanges]
    // instead of [self isDocumentEdited] because the former
    // often returns YES when the latter is NO, and this
    // seems to be the true answer.
    // UPDATE: -isDocumentEdited might be fixed, at least in Lion,
    // with my latest improvements to GCUndoManager.
    // Although it doesn't matter in this case, we note that
    // -[NSManagedObjectContext hasChanges] must be used instead of
    // -isDocumentEdited, in BkmxAgent, because the the latter always
    // returns NO in BkmxAgent.  This is because BkmxAgent has a nil
    // undo manager, and NSDocument relies on notifications
    // from the undo manager to maintain -isDocumentEdited.
    if (![[self managedObjectContext] hasChanges]) {
        return ;
    }
    
    // Some tab view items do not have any controls which
    // affect the data model.
    if (![[self bkmxDocWinCon] activeTabViewIsUndoable]) {
        return ;
    }
    
    
    // Determine whether or not to register a change to the current tab view in the current
    // undo group.  The code with follows looks weird and unsymmetrical, but it implements
    // (efficiently) what has been determined by careful experimentation to be the
    // following Magic Algorithm:
    // doRegister if any one of:
    //   1.  SSYUndoManagerWillEndUndoGroupNotification && !isUndoing
    //       (Register during normal "do" changes by the user, to be used during later Undo.)
    //   2.  NSUndoManagerCheckpointNotification && isUndoing
    //       (Register during undo operations, to be used during later Redo.)
    //   3.  NSUndoManagerCheckpointNotification && isRedoing
    //       (Register during redo operations, to be used during later Undo.)
    // I tried combining cases 1 and 2 above, by observing NSUndoManagerCheckpointNotification
    // without regard to isUndoing, but this caused a proliferation of undo groups, needing to
    // click Undo several times before the desired action was undone.
    // I also tried to use NSUndoManagerWillCloseUndoGroupNotification instead of
    // SSYUndoManagerWillEndUndoGroupNotification, but this caused a "bad group state -
    // attempt to close a nested group with no group open" to be logged from GCUndoManager
    // immediately upon doing an action.
    // Note: All of the above was done before Lion
    NSString* name = [note name] ;
    BOOL doRegister = NO ;
    if ([name isEqualToString:NSUndoManagerCheckpointNotification]) {
        doRegister = [[self undoManager] isUndoing] || [[self undoManager] isRedoing] ;
    }
    else if ([name isEqualToString:SSYUndoManagerWillEndUndoGroupNotification]) {
        doRegister = ![[self undoManager] isUndoing] ;
        [self finalizeStarksLastModifiedDates];
    }
    
    // If doRegister, then register ...
    if (doRegister) {
        NSString* currentTabViewIdentifier = [[self bkmxDocWinCon] activeTabViewItemIdentifier] ;
        [[self undoManager] registerUndoWithTarget:self
                                          selector:@selector(revealTabViewIdentifier:)
                                            object:currentTabViewIdentifier] ;
    }
}

- (void)queueReloadFromDisk {
    NSMutableDictionary* info = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 self, constKeyDocument,
                                 nil] ;
    
    NSArray* selectorNames = [NSArray arrayWithObjects:
                              @"reloadFromDisk",
                              nil] ;
    
    [[self operationQueue] queueGroup:NSStringFromSelector(_cmd)
                                addon:NO
                        selectorNames:selectorNames
                                 info:info
                                block:NO
                           doneThread:nil
                           doneTarget:self
                         doneSelector:NULL
                         keepWithNext:NO] ;
    [info release] ;
}

- (void)reloadFromDiskNow {
    NSString* type = [[NSDocumentController sharedDocumentController] defaultType];
    NSError* error =  nil;
    BOOL ok = [self readFromURL:self.fileURL
                         ofType:type
                          error:&error];
    if (ok) {
        [[self bkmxDocWinCon] reloadAll];
    } else {
        error = [SSYMakeError(274430, @"Tried but failed to reload changes from disk, which may have been from another Mac") errorByAddingUnderlyingError:error];
        [[BkmxBasis sharedBasis] logError:error
                          markAsPresented:NO];
        [self alertError:error];
    }
    
    self.isReloadingFromDisk = NO;
}

/* This method must be run on the main thread. */
- (void)handleMoveToNewUrl:(NSURL*)newURL {
    /* Next line is to continue (after replacing SSYDocFileObserver with
     NSFilePresenter methods like this one on 2017-07-05) the behavior which
     BkmkMgrs has had forever, which is that if user renames file in Finder,
     the new name shows up immediately in the window's title bar, and there is
     no annoying "location of the file cannot be determined" when user later
     clicks File > Save.  This is the way TextEdit works.  Also, I like it
     better this way. */
    [self setFileURL:newURL] ;
    /*  I've found that if -setFileURL: is called on a secondary thread, when
     the text width changes, the horizontal space given the text in the window
     title will be wrong (either a large space between the icon and first
     character of text, and/or text is truncated at end), and once in a while
     there is a crash.  I think maybe this is a bug in macOS 10.12.6, because
     I do not override -windowTitleForDocumentDisplayName:.  Not really sure.
     Anyhow, running it in this method, which must run on the main thread,
     fixes the problem. */
    [self registerAliasForUuidInUserDefaults] ;  // Any thread, but trivial.
    [self noteRecentDisplayName] ;  // Any thread, but trivial.
    [self ifInViewingModePauseAndTell] ; //  Must be on main thread
}

/* This method is invoked when user renames document file in Finder. */
- (void)presentedItemDidMoveToURL:(NSURL *)newURL {
    NSAssert2(![NSObject isEqualHandlesNilObject1:newURL
                                          object2:self.fileURL],
              @"Assert:\nOld URL:%@ \nNew URL", self.fileURL, newURL);
    
    
    if ([[NSThread currentThread] isMainThread]) {
        [self handleMoveToNewUrl:newURL];
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self handleMoveToNewUrl:newURL];
        });
    }
}

#if 0
// For troubleshooing iCloud Drive…
// Question: should these methods invoke
// super?  What about -presentedItemDidChange ?
- (void)presentedSubitemAtURL:(NSURL *)url
               didGainVersion:(NSFileVersion *)version {
    NSLog(@"Goty %s %@ %@", __PRETTY_FUNCTION__, version, url) ;
    [super presentedSubitemAtURL:url
                  didGainVersion:version];
}

- (void)presentedItemDidChange {
    NSLog(@"Goty %s", __PRETTY_FUNCTION__) ;
    [super presentedItemDidChange];
}
#endif

/* This method gets called when I either
 (a) modify the persistenStore file on disk using the sqlite3 command-line
 tool – it is called once.
 Or,
 (b) modify the persistenStore file on disk using the SQLite Professional gui
 tool – it is called several times, preceded by a single call to
 -presentedSubitemAtURL:didGainVersion:.
 
 So, for case (b) I would rather put this code in there.  But I must put it
 in this method, because of case (a). */
- (void)presentedSubitemDidChangeAtURL:(NSURL *)url {
    /* This method is called on a secondary thread. */
    if (!self.isReloadingFromDisk) {
        if (self.lastSaveToken && self.lastKnownLastSaveToken && ![self.lastSaveToken isEqualToString:self.lastKnownLastSaveToken]) {
            NSString* filename = url.path.lastPathComponent;
            /* We use -hasPrefix: because it may be only the -shm or -wal file
             which changed. */
            if ([filename hasPrefix:[[self class] persistentStoreName]]) {
                self.isReloadingFromDisk = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self queueReloadFromDisk] ;
                });
            } else if ([filename rangeOfString:@"conflicted copy"].location != NSNotFound) {
                /* This must be a "conflicted copy" made by Dropbox.  Examples:
                 • persistentStore (Air2's conflicted copy 2017-07-12 (3))
                 • persistentStore-shm (Air2's conflicted copy 2017-07-12 (4))
                 We don't deal with such conflicts.  Trash it silently. */
                [[NSFileManager defaultManager] trashPath:url.path
                                             scriptFinder:NO
                                                  error_p:NULL];
                [[BkmxBasis sharedBasis] logFormat:@"Trashed conflicted file %@", url.path];
            } else {
                /* On 20180214, I found that the following files were frequently
                 (a couple dozen times in a day of heavy testing) being the
                 subject of this method:
                 • /path/to/whatever.bmco/.dat.nosync0d27.vlZzBC
                 • /path/to/whatever.bmco/auxiliaryData.plist
                 I think we should ignore that, so we do nothing here. */
            }
        }
    }
}


+ (void)cleanUpDocSupportMocsForUuid:(NSString*)uuid {
    for (NSDocument* document in[[NSDocumentController sharedDocumentController] documents]) {
        if ([document isKindOfClass:self]) {
            BkmxDoc* otherBkmxDoc = (BkmxDoc*)document ;
            if ([uuid isEqualToString:[otherBkmxDoc uuid]]) {
                /*
                 The doc support mocs for this uuid are still in use by another
                 document.  This will happen if we were invoked as a result of
                 a document in the macOS Versions Browser being closed.
                 */
                return ;
            }
        }
    }
    
    [[BkmxBasis sharedBasis] destroyAnyExistingDocSupportMocForMocName:constBaseNameSettings
                                                                  uuid:uuid] ;
    [[BkmxBasis sharedBasis] destroyAnyExistingDocSupportMocForMocName:constBaseNameExids
                                                                  uuid:uuid] ;
    [[BkmxBasis sharedBasis] destroyAnyExistingDocSupportMocForMocName:constBaseNameDiaries
                                                                  uuid:uuid] ;
}

/*!
 @brief    Release managed object contexts for Exids, Settings and Diaries
 that were opened to support a given .bmco document, identified by its UUID.
 
 @details  This method releases mocs only.  It does not touch any stores
 on disk.
 
 There is a potential retain cycle between BkmxDoc and SSYMOCManager,
 because SSYMOCManager retains the BkmxDoc object passed in
 registerOwnerDocument:ofManagedObjectContext: in its moc dics.  To break that,
 but to avoid the auxiliary mocs being released too soon (yes it does happen and you
 get, for example, Starkoids showing up as invalidated managed objects in the
 stderr), we invoke this method when we receive notification that we are about
 to be closed.
 
 Because of the retain cycle, we could have defined cleanUpDocSupportMocsForUuid:
 as an instance method, but if user has been in the Lion Versions Browser, there
 will be more than one document linked to these auxiliary mocs [1].  So instead
 of releasing them here, we send our uuid to a class object, which of course
 will still be around, and before releasing the auxiliary mocs will first check
 see that no other documents are using them.
 
 [1]  How Lion Versions Browser works.
 When a document is displayed on the right side of the Versions Browser,
 it is backed by a document object, that is, one of us here.  But when the user
 exits Versions Browser, all of these documents are closed and released.  If
 the user clicked 'Restore', the selected file replaces the original file in
 the file system, and the *original* document object receives a
 -readFromURL:ofType:error: message which reads in the restored data.  The
 original document object is therefore not released but continues to live with
 the newly-restored data.
 */
- (void)cleanUpDocSupportMocs {
    [[self class] performSelector:@selector(cleanUpDocSupportMocsForUuid:)
                       withObject:[self uuid]
                       afterDelay:0.0] ;
}

- (void)checkAllProxies:(NSNotification*)noteNotUsed {
    /* I think that the call to -checkProxiesReloadDataAndRealizeIsExpanded
     is probably overkill for some of the callers of this method;
     checkProxies would be sufficient.  But I do not have a test suite at this
     time to prove that :( */
    [[[[self bkmxDocWinCon] cntntViewController] contentOutlineView] checkProxiesReloadDataAndRealizeIsExpanded] ;
}


/*!
 @brief    Releases the receiver's ExidsMoc, SettingsMoc and DiariesMoc which
 are being retained by the SSYMOCManager singleton.
 */
- (void)bkmxDocWillClose:(NSNotification*)note {
    // Core Data access must use main thread
    if ([[NSThread currentThread] isMainThread]) {
        [self mainThreadBkmxDocWillClose:note];
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self mainThreadBkmxDocWillClose:note];
        });
    }
}

- (void)mainThreadBkmxDocWillClose:(NSNotification*)note {
    if (self.isReloadingFromDisk) {
        /* If we allow the following clean-up code to execute while the store
         has already been modified by a external actor, when the starker asks
         for all objects, you'll get this exception(s) logged to the console:
         
         2017-07-11 07:44:28.676423-0700 BookMacster[26451:4534041] [error] error: (6922) I/O error for database at /Users/jk/Library/Application Support/BookMacster/Collections/File > Duplicate.bmco/StoreContent/persistentStore.  SQLite error code:6922, 'disk I/O error'
         CoreData: error: (6922) I/O error for database at /Users/jk/Library/Application Support/BookMacster/Collections/File > Duplicate.bmco/StoreContent/persistentStore.  SQLite error code:6922, 'disk I/O error'
         
         I have seen, in another instance, evidence that this error occurs
         when a store is read when the other actor (Dropbox) has updated the
         main sqlite file but not yet the -shm and/or -wal file, which
         
         Actually, it does not crash, and continues to work, but I presume
         that the fetch and therefore the cleanup fails.  To prevent that, we
         skip the cleanup by doing this: */
        return;
    }
    
    [[MAKVONotificationCenter defaultCenter] removeObserver:self] ;
    [self cleanUpDocSupportMocs] ;
}

// Added in BookMacster 1.19.2 to support -mainAppBundle instead of
// method replacement.  Needed for BkmxAgent where mainBundle != mainAppBundle.
- (NSManagedObjectModel *)managedObjectModel {
    if (m_managedObjectModel) {
        return m_managedObjectModel ;
    }
    
    NSURL *modelURL = [[NSBundle mainAppBundle]
                       URLForResource:[[NSBundle mainAppBundle] motherAppName]
                       withExtension:@"momd"] ;
    if (modelURL) {
        /* This will work for BkmxAgent in Bkmx.app bundle */
        m_managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] ;
    }
    else {
        /* This will work for standalone BkmxAgent; may be needed for testing. */
        m_managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:[NSArray arrayWithObject:[NSBundle mainBundle]]];
    }
    
    return m_managedObjectModel ;
}

- (void)initializeCommonAfterFileUrlSetButBeforePersistenceStackIsUp {
    // Very early initialization tasks required to be done for
    // both newly-created and newly-loaded documents
    
    /* We need to grab the savedWithVersion right now, before it gets
     overwritten.  It gets overwritten very early, for example when
     -[BkmxDocumentController makeDocumentWithContentsOfURL:ofType:error:]
     calls super it will -setFileUrl:, which we have overridden to rewrite
     the auxiliaryData.plist.  This is before the document is open.  */
    self.priorSavedWithVersionString = [self auxiliaryObjectForKey:constKeySavedWithVersion];
    self.priorRequiresVersionString = [self auxiliaryObjectForKey:constKeyRequiresVersion];
}

- (void)initializeCommonAfterPersistenceStackIsUp {
    // Later initialization tasks required to be done for
    // both newly-created and newly-loaded documents

    // There are four possible sequences:
    // Sequence 1.  MainApp opens doc, BkmxAgent opens doc, BkmxAgent saves doc, MainApp saves doc
    // Sequence 2.  BkmxAgent opens doc, MainApp opens doc, MainApp saves doc, BkmxAgent saves doc
    // Sequence 3.  MainApp opens doc, MainApp saves doc, BkmxAgent opens doc, BkmxAgent saves doc
    // Sequence 4.  BkmxAgent opens doc, BkmxAgent saves doc, MainApp opens doc, MainApp saves doc
    // Sequence 1 (possible) and Sequence 2 (rare but possible) result in conflicts.
    // The following says that the conflict should be resolved in favor of the last saver:
    [self.managedObjectContext performBlockAndWait:^{
        [[self managedObjectContext] setMergePolicy:NSOverwriteMergePolicy] ;
    }];
    
    /* However, after creating a new document with File > Save As, and then
     renaming this new document, it is, to my surprise, the *parent* of the
     new document's managed object context which gets immediately saved.  Im
     nacOS 10.14.4 beta 2, this will generate Cocoa Error 133020 (merge
     conflict) if a non-error merge policy has not been set.  So we now fix the
     *parent* context: */
    [self.managedObjectContext.parentContext performBlockAndWait:^{
        [self.managedObjectContext.parentContext setMergePolicy:NSOverwriteMergePolicy] ;
    }];
    
    // The Primary Underlying Notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(objectWillChangeNote:)
                                                 name:SSYManagedObjectWillUpdateNotification
                                               object:nil] ; // nil --> observe all objects in the store!
    
    // Downstream Notifications triggered by the Primary Underlying Notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateViews:)
                                                 name:BkmxDocNotificationContentTouched
                                               object:self] ;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateLastTouchedToNow:)
                                                 name:BkmxDocNotificationContentTouched
                                               object:self] ;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkAndRemoveDupeDisparagees)
                                                 name:constNoteDupesMayContainDisparagees
                                               object:[self shig]] ;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkAndRemoveDupeVestiges)
                                                 name:constNoteDupesMayContainVestiges
                                               object:[self shig]] ;
    
    // Other Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doHousekeepingAfterSaveNotification:)
                                                 name:BkmxDocDidSaveNotification
                                               object:self] ;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearUnexportedDeletions:)
                                                 name:NSUndoManagerDidUndoChangeNotification
                                               object:[self undoManager]] ;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateViews:)
                                                 name:NSUndoManagerDidUndoChangeNotification
                                               object:[self undoManager]] ;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(forgetAllLastPreImportedHashesNote:)
                                                 name:NSUndoManagerDidUndoChangeNotification
                                               object:[self undoManager]] ;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkAllProxies:)
                                                 name:NSUndoManagerDidUndoChangeNotification
                                               object:[self undoManager]] ;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateViews:)
                                                 name:NSUndoManagerDidRedoChangeNotification
                                               object:[self undoManager]] ;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(forgetAllLastPreImportedHashesNote:)
                                                 name:NSUndoManagerDidRedoChangeNotification
                                               object:[self undoManager]] ;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkAllProxies:)
                                                 name:NSUndoManagerDidRedoChangeNotification
                                               object:[self undoManager]] ;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(finalizeEditsNote:)
                                                 name:SSYUndoManagerWillEndUndoGroupNotification
                                               object:[self undoManager]] ;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(finalizeEditsNote:)
                                                 name:NSUndoManagerCheckpointNotification
                                               object:[self undoManager]] ;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bkmxDocWillClose:)
                                                 name:SSYUndoManagerDocumentWillCloseNotification
                                               object:self] ;
    // Added in BookMacster 1.12.8, to fix bug which is obvious if you look at what I'm doing here
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearCachedChildren)
                                                 name:NSUndoManagerWillUndoChangeNotification
                                               object:[self undoManager]] ;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearCachedChildren)
                                                 name:NSUndoManagerWillRedoChangeNotification
                                               object:[self undoManager]] ;
}

- (void)clearCachedChildren {
    Stark* root = [[self starker] root] ;
    [root deeplyForgetCachedChildrenOrdered] ;
}

+ (NSString *)pathForModelNamed:(NSString *)modelName {
    NSString *path = nil;
    NSMutableArray* allBundles = [NSMutableArray arrayWithObject:[NSBundle mainAppBundle]] ;
    [allBundles addObjectsFromArray:[NSBundle allFrameworks]] ;
    
    for(NSBundle* bundle in allBundles) {
        path =  [bundle pathForResource:modelName
                                 ofType:@"mom"] ;
        if (path) {
            break;
        }
    }
    
    return path;
}

- (void)showWindows {
    /* We should always have at least a main window, so we create one if none
     has been created yet. */
    [self bkmxDocWinCon];
    
    /*
     I have seen that we can be on a secondary thread here in a couple cases.
     This is not reproducible in macOS 10.14.4, but I've seen them once every
     week or two.  Weird…
     
     Case 1.  Artificially create Error 257938 by defining the compile-time
     constant Testing_Document_Opening_Timeout,
     
     Case 2.  Landing a new bookmark from Dock Menu or maybe Keyboard
     Shortcut, when a .bmco window is already open
     
     Whatever the case, calling -showWindows from a non-main thread will
     cause the SettingsViewController to -reloadNewBookmarkLandingMenu,
     which will cause starks to be accessed, which will cause Core Data to
     barf from being on the secondary thread.
     
     Looking at the GCD code (dispatch_async) in
     openDocumentWithContentsOfURL:::, I don't see why this could not happen
     in real life.
     
     In a classic example of "it wasn't broke so you shouldn't have tried to
     fix this", in version 2.9.4 (commit 56bdf72), sadly, I did not test for
     main thread and wrapped this entire method (both lines) around a
     -performSelectorOnMainThread:::.  Big mistake because that delayed the
     opening of the window until the next run loop cycle and caused, when
     creating a new document, the Choose Clients/Browsers sheet to open in
     thin air, and also may have caused Cocoa Error 256 preventing the first
     save.  So now, instead, I only delay if we're not on the main thread,
     hoping that the edge-edge case of being on a secondary thread while
     creating a new document never occurs. */
    if ([[NSThread currentThread] isMainThread]) {
        [super showWindows];
    } else {
        NSLog(@"Eeek, tried to showWindows on non-main thread");
        [super performSelectorOnMainThread:@selector(showWindows)
                                withObject:nil
                             waitUntilDone:NO];
    }
}

#pragma mark * Spotlight Importer Support

- (BOOL)setMetadataForStoreAtURL:(NSURL *)url {
    NSPersistentStoreCoordinator *psc = [[self managedObjectContext] persistentStoreCoordinator];
    
    id pStore = [psc persistentStoreForURL:url];
    NSString *departmentName = nil ; //[[self department] valueForKey:@"name"];
    
    if ((pStore != nil) && (departmentName != nil))
    {
        // metadata auto-configured with NSStoreType and NSStoreUUID
        NSMutableDictionary *metadata = [[psc metadataForPersistentStore:pStore]
                                         mutableCopy];
        
        [metadata setObject:[NSArray arrayWithObject:departmentName]
                     forKey:(NSString *)kMDItemKeywords];
        
        [psc setMetadata:metadata forPersistentStore:pStore];
        return YES;
    }
    return NO;
}

/*
 I copied this method out of DepartmentsAndEmployees sample code.
 It seems to be some kind of workaround that is needed for Spotlight metadata
 Also, there may be a bug.  See:
 http://www.cocoabuilder.com/archive/message/cocoa/2008/6/2/208995
 - (BOOL)writeToURL:(NSURL *)absoluteURL
 ofType:(NSString *)typeName
 forSaveOperation:(NSSaveOperationType)saveOperation
 originalContentsURL:(NSURL *)absoluteOriginalContentsURL
 error:(NSError **)error_p
 {
 
 //  needed  -- configure not called for writing existing document
 if ([self fileURL] != nil) {
 //  Spotlight Importer stuff goes here
 [self setMetadataForStoreAtURL:[self fileURL]];
 }
 
 return [super writeToURL:absoluteURL ofType:typeName
 forSaveOperation:saveOperation
 originalContentsURL:absoluteOriginalContentsURL
 error:error_p];
 }
 */

/*!
 @brief    Returns the License Information stored in the receiver's
 store's metadata, or nil if there is no such information.
 
 @details  "metal" = "metadata-stored license information"
 */
- (SSYLCLicenseInfo)metalInfo {
    NSArray* elements = [self auxiliaryObjectForKey:constKeyMetal] ;
    SSYLCLicenseInfo info = {nil, nil} ;
    if ([elements count] == 2) {
        info.licenseeName = [elements objectAtIndex:0] ;
        info.licenseKey = [elements objectAtIndex:1] ;
    }
    
#if 0
#warning Not sucking License Info from document metadata
    info.licenseeName = nil ;
    info.licenseKey = nil ;
#endif
    
    return info ;
}

- (BOOL)metalValid {
#if 0
    return YES;
#warning No license required
#endif
    BOOL ok = NO ;
    SSYLCLicenseInfo docLicenseInfo = [self metalInfo] ;
    SSYLicenseLevel licenseLevel = SSYLCValidate(docLicenseInfo) ;
    if (licenseLevel >= SSYLicenseLevelValid ) {
        // Document has good license info
        SSYLCWriteToThisUsersPrefs(docLicenseInfo);
        ok = YES ;
    }
    
    return ok ;
}

/*!
 @details  Remember the idea here is that we are looking for
 documents which are too *new*, so that we can give the user
 a better warning before Core Data gives its terse and
 technical jargon about the "persistent store".  Thanks to
 Core Data migrations, we can supposedly handle any document
 which requires a version (was produced by a version) which
 is *older* than we are.
 */
- (BOOL)okToOpenDocumentRequiresVersion:(SSYVersionTriplet*)requiresVersion
                           inAppVersion:(SSYVersionTriplet*)appVersion {
    if (!requiresVersion) {
        // Document must be really old, which means that we should
        // be able to open it.
        return YES ;
    }
    
    BOOL appIsTooOld = ([appVersion isBkmxEffectivelyEarlierThanRegular:requiresVersion]) ;
    return !appIsTooOld ;
}

- (void)noteRecentDisplayName {
    /* Before 20170711, (a) we could be invoked from
     -[BkmxDoc mikeAshObserveValueForKeyPath::::] before the persistence stack
     of a reopened document is functioning, and also (b) we could be invoked
     from -[BkmxDoc readFromURL:::] by a corrupt document.  I'm not sure if
     (a) is still possible, now that mikeAshObserveValueForKeyPath::: has been
     replaced with presentedSubitemDidChangeAtURL:.
     
     Anyhow, in either case, [self uuid] will be nil, which would wipe out the
     entire dictionary for key constKeyDocRecentDisplayNames if this method
     were allowed to proceed, and replace it with a single NSString.  So we
     don't let that happen...  */
    NSString* uuid = [self uuid] ;
    if (!uuid) {
        return ;
    }
    
    if ([[BkmxBasis sharedBasis] isBkmxAgent]) {
        // BkmxAgent should not write constKeyDocRecentDisplayNames, neither to the
        // main app prefs domain nor to com.sheepsystems.
        return ;
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:[self displayName]
                                    forKeyPathArray:[NSArray arrayWithObjects:
                                                     constKeyDocRecentDisplayNames,
                                                     uuid,
                                                     nil]];
    /* The following was added on 20171228 as a "good practice".
     It may in fact be not necessary. */
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)registerAliasForUuidInUserDefaults {
    if (![self uuid]) {
        // At some stages early in the process of creating a new BkmxDoc,
        // this method might get invoked before a uuid has been set
        return ;
    }
    
    NSString* path = [[self fileURL] path] ;
    
    if (![[NSFileManager defaultManager] fileIsPermanentAtPath:path
                                                       error_p:NULL]) {
        // This will happen a couple times during a 'Revert' operation.
        // The path will be something like:
        //    /var/folders/PR/PRtZlutkFa82jPnfdYcUUk+++TI/-Tmp-/OriginalDocumentName.<documentExtension>
        return ;
    }
    if ([self ssy_isInViewingMode]) {
        // Added in BookMacster 1.6.2
        // We don't want this alias because it will point to a file like this path:
        // /.DocumentRevisions-V100/PerUID/501/1/com.apple.documentVersions/SOME-UUID.<documentExtension>
        return ;
    }
    
    NSData* alias = [NSData aliasRecordFromPath:path] ;
    NSArray* keyPathArray = [NSArray arrayWithObjects:
                             constKeyDocAliasRecords,
                             [self uuid],
                             nil] ;
    
    [[NSUserDefaults standardUserDefaults] setAndSyncMainAppValue:alias
                                                  forKeyPathArray:keyPathArray] ;
}

- (NSSet*)clidentifiersInStarxids {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
    NSMutableSet* clidentifiers = [NSMutableSet set] ;
    for (Starxid* starxid in [[self starxider] allObjects]) {
        for (Clixid* clixid in [starxid clixids]) {
            NSString* clidentifier = [clixid clidentifier] ;
            [clidentifiers addObject:clidentifier] ;
        }
    }
    NSSet* answer = [clidentifiers copy] ;
    [pool release] ;
    
    return [answer autorelease] ;
}

#pragma mark * Methods Invoked only to update Old Documents, beyond Core Data Migration

/*
 Note 20120307  (Occurs during -updateXxxx methods which change and save document file)
 Save the document using -saveDocumentFinalOpType: instead of -saveDocument:, so that
 -doHousekeepingBeforeSave is invoked, which will add the
 to this document's file's metadata the object [[SSYAppInfo currentVersionTriplet] string]
 for the key constKeySavedWithVersion, thus signifying what we have
 just done, so that it will not be re-done on the next opening.
 Note that this will cause a single ping-pong in Dropbox, because
 -readFromURL:ofType:error: invokes this method.  Here's what happens:
 • Remote Mac with previous version of BookMacster writes this file due to some Content change.
 • Dropbox transmits it to this Mac (ping)
 • This BkmxDoc object detects the new file and opens or re-opens it.
 • This method runs to here
 • -saveDocumentFinalOpType: is invoked
 • -doHousekeepingBeforeSave: is invoked
 • -writeBasicAuxiliaryData: is invoked
 • In auxiliaryData.plist, value for key constKeySavedWithVersion, is updated to this app's version.
 • Dropbox senses the change and copies document back to remote Mac with new metadata (pong)
 • Older version of BookMacster reads in the file but does not update it any more,
 so the pingponging stops there, after the first pingpong.  However, this will recur
 the next time that the remote Mac has an actual change to write, it will revert
 constKeySavedWithVersion to its previous version, causing the above to happen
 all over again.
 */


#pragma mark * Cleaning Up Bad Clients, Orphaned Starxids, Clixids

/*
 The following two methods are adapted from:
 https://gist.github.com/uluckas/3129990,
 which which supposedly works around some bugs as discussed in
 http://lists.apple.com/archives/cocoa-dev/2008/Jun/msg00237.html
 */
- (void)mergeChangesFromContextDidSaveNotification:(NSNotification*)notification {
    NSManagedObjectContext* savedContext = [notification object] ;
    NSManagedObjectContext* affectedContext = nil ;
    NSURL* savedUrl = [[savedContext store1] URL] ;
    if ([savedUrl isEqual:[self fileURL]]) {
        affectedContext = [self managedObjectContext] ;
    }
    else {
        NSManagedObjectContext* exidsMoc = [self exidsMoc] ;
        if ([savedUrl isEqual:[[exidsMoc store1] URL]]) {
            affectedContext = exidsMoc ;
        }
    }
    
    if (affectedContext) {
        // Workaround bug 5982319
        // Fault in all updated objects because chnages to faults won't trigger fetchedResultsControlle
        NSSet* updates = [notification.userInfo objectForKey:NSUpdatedObjectsKey];
        for (NSManagedObject* object in updates) {
            [[affectedContext objectWithID:[object objectID]] willAccessValueForKey:nil];
        }
        
        [affectedContext mergeChangesFromContextDidSaveNotification:notification];
        
        // Workaround for bug 5937572
        // Clean up unexpected 'maintainance' after merge.
        // mergeChangesFromContextDidSaveNotification tries to maintain the object models relations
        // and messes it up. As we only merge consistent changes into a clean context no 'after merge'
        // maintainance is needed. We can safely revert all changes.
        // To still fire all changes, processPendingChanges must be called first though.
        updates = [affectedContext updatedObjects] ;
        for (NSManagedObject* object in updates) {
            [affectedContext refreshObject:object mergeChanges:NO] ;
        }
        // Save the remaining changes (deletes) to get our context clean again
        NSError *error = nil;
        [affectedContext save:&error];
        if (error) {
            NSLog(@"Internal Error 514-8385 %@", error);
        }
        
        if (affectedContext == [self managedObjectContext]) {
            /* To remove Client Associations from Content Outline View, because
             this view does not use bindings, */
            [[self bkmxDocWinCon] reloadContent] ;
        }
    }
}

- (void)contextDidSave:(NSNotification *)notification {
    NSManagedObjectContext *savingContext = (NSManagedObjectContext *) [notification object];
    
    if ([self managedObjectContext] == savingContext) {
        // No need to merge chnages from our our own context
        return;
    }
    
    [self performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
                           withObject:notification
                        waitUntilDone:YES];
}

/*!
 @brief    Removes useless starxids, clixids, and exids on starks
 
 @details  Removes:
 • Any starxids in the receiver's Exids moc whose starkid do not match that of
 an existing stark in the receiver's store
 • Any clixids, or stark's exid, whose clidentifier does not match that of an
 available Client in the user's store.  (Clients need not be currently in
 document's Macster.  This is because some users may sync manually, using Import
 from only > and Export to only > instead of adding Clients.)
 • Any clixids which are no longer related to starxids (possibly because
 their starxid was removed in the first step.)
 after this.
 */
- (void)cleanOrphanedDocSupportObjects {
    /* Get the cheap stuff now, on the main thread, using our convenient
     getters, so we don't need to do special fetches using a different MOC
     when we get to the secondary thread.  Send it as 'info'.  */
    NSArray* clientChoices = [[self macster] availableClientChoicesAlwaysIncludeChooseFile:NO
                                                                            includeWebApps:YES
                                                                      includeNonClientable:NO];
    /* The array clientChoices will include some NSNull objects.  Swift does
     not like such heterogenous arrays and will will not pass it as an
     Array<String>.  So we must remove any object which is not a NSString. */
    NSMutableArray<NSString*>* clidentifiers = [NSMutableArray new];
    for (id clientChoice in clientChoices) {
        if ([clientChoice respondsToSelector:@selector(clientoid)]) {
            Clientoid* clientoid = [clientChoice clientoid];
            if ([clientoid respondsToSelector:@selector(clidentifier)]) {
                NSString* clidentifier = [clientoid clidentifier];
                if (clidentifier) {
                    [clidentifiers addObject:clidentifier];
                }
            }
        }
    }
    
    NSString* uuid = [self uuid] ;
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
                          clidentifiers, constKeyClidentifiers,
                          uuid, constKeyDocUuid,
                          nil] ;
    [clidentifiers release];
    
    /* Do not use self managedObjectContext,store1.URL in the following because
     -`store1` may still be nil at this point. */
    NSURL* storeUrl = [BSManagedDocument persistentStoreURLForDocumentURL:[self fileURL]];
    if (storeUrl) {
        DocSupportObjectCleaner* cleaner = [[DocSupportObjectCleaner alloc] initWithBkmxDoc:self];
        [cleaner cleanOrphanedDocSupportObjectsWithInfo:info];
        [cleaner release];
    } else {
        /* This is a new, unsaved document.  There is nothing to clean. */
    }

}

- (NSArray*)badClients {
    NSArray* choices = [[self macster] availableClientChoicesAlwaysIncludeChooseFile:NO
                                                                      includeWebApps:YES
                                                                includeNonClientable:NO] ;
    NSMutableArray* __block badClients = [[NSMutableArray alloc] init];
    [self.macster.managedObjectContext performBlockAndWait:^{
        NSSet* clients = self.macster.clients;
        
        for (Client* client in clients) {
            ClientChoice* choice = [ClientChoice clientChoiceWithClientoid:[client clientoid]] ;
            BOOL isBad = [choice isLocalThisUserNotInChoices:choices] ;
            if (isBad) {
                [badClients addObject:client] ;
            }
        }
    }];
    
    NSArray* answer = [badClients copy];
    [badClients release];
    [answer autorelease];
    return answer ;
}

- (BOOL)isCurrentlyAvailableClient:(Client*)client {
    NSArray* choices = [[self macster] availableClientChoicesAlwaysIncludeChooseFile:NO
                                                                      includeWebApps:YES
                                                                includeNonClientable:NO] ;
    BOOL answer = YES ;
    ClientChoice* choice = [ClientChoice clientChoiceWithClientoid:[client clientoid]] ;
    BOOL isBad = [choice isLocalThisUserNotInChoices:choices] ;
    if (isBad) {
        answer = NO ;
        NSLog(@"Warning 624-3835 %@ client %@ is not available.",
              [self displayName],
              [client displayName]) ;
    }
    
    return answer ;
}

- (void)warnUserOfBadClients:(NSArray*)badClients {
    SSYAlert* alert = [SSYAlert alert] ;
    NSString* msg = [NSString stringWithFormat:
                     @"Please re-assign or delete %@ which are no longer available on this Macintosh user account:\n\n%@",
                     [[BkmxBasis sharedBasis] labelClients],
                     [[badClients valueForKey:@"displayName"] listNames]] ;
    [alert setSmallText:msg] ;
    
    if ([[BkmxBasis sharedBasis] isShoeboxApp]) {
        /* Show window Preferences tab Syncing and attach a sheet to it. */
        [(BkmxAppDel*)[NSApp delegate] preferences:self];
        [[(BkmxAppDel*)[NSApp delegate] prefsWinCon] revealTabViewIdentifier1:constIdentifierTabViewPrefsSyncing
                                                                  identifier2:nil];
        NSWindow* window = [[(BkmxAppDel*)[NSApp delegate] prefsWinCon] window];
        if (window) {
            [alert runModalSheetOnWindow:window
                              resizeable:NO
                           modalDelegate:nil
                          didEndSelector:NULL
                             contextInfo:NULL];
        }
    } else {
        /* Show tab > Settings > Clients and attach a sheet to it. */
        // Next line is to create the settings view controller in case it is still nil
        [[self bkmxDocWinCon] revealTabViewSettings:self] ;
        [[[self bkmxDocWinCon] settingsViewController] revealTabViewClients] ;
        [self runModalSheetAlert:alert
                      resizeable:NO
                       iconStyle:SSYAlertIconInformational
                   modalDelegate:nil
                  didEndSelector:NULL
                     contextInfo:NULL] ;
    }
}

/*
 @details  I'm not sure how this method coordinates with
 -[Macster removeAnyBadClients].  It seems like that method should
 have removed orphaned single-use clients left by prior crashes in
 Markster and Smarky, but it did not.  So I added the default:
 branch in here.  I know that -[Macster removeAnyBadClients] was
 tailored for correct behavior when sibling app documents are
 opened by "Stop all Syncing now". */
- (void)checkForBadClientsAnMaybeCleanOrphanedDocSupportObjects {
    /* This is a little counterintuitive.  We only check for defunct starxids
     and clixids if all clients are good.  The reason for that is that if
     Firefox has been reset, the bad client will show as available instead of
     the good one ??????  We need the user to fix the clients first ?????
     Then, we'll get it on the next launch.
     */
    if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
        NSArray* badClients = [self badClients] ;
        if ([badClients count] == 0) {
            [self cleanOrphanedDocSupportObjects] ;
        }
        else {
            [((Client*)badClients.firstObject).managedObjectContext performBlockAndWait:^{
                switch ([[BkmxBasis sharedBasis] iAm]) {
                    case BkmxWhich1AppSynkmark:
                        [self warnUserOfBadClients:badClients];
                        [(BkmxAppDel*)[NSApp delegate] revealPrefsTabIdentifier:constIdentifierTabViewPrefsSyncing];
                        break;
                    case BkmxWhich1AppBookMacster:
                        [self warnUserOfBadClients:badClients];
                        [[self bkmxDocWinCon] revealTabViewIdentifier1:constIdentifierTabViewSettings
                                                           identifier2:constIdentifierTabViewClients];
                        break;
                    default:
                        // Smarky and Markster have no interface for user to
                        // delete clients.  Just delete them.
                        for (Client* client in badClients) {
                            [[self macster] deleteClient:client] ;
                        }
                        [[self macster] save] ;
                        break ;
                }
            }];
        }
    }
}

#pragma mark * Regular Document Opening Methods

- (NSString*)lastSaveToken {
    NSString* answer = [self auxiliaryObjectForKey:constKeyDocLastSaveToken] ;
    return answer ;
}

- (void)setInUserDefaultsLastSaveToken:(NSString*)token {
    if (token) {
        NSArray* keyPathArrayForToken = [NSArray arrayWithObjects:
                                         constKeyDocLastSaveToken,
                                         [self uuid],
                                         nil] ;
        NSString* existingLastSaveToken = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppValueForKeyPathArray:keyPathArrayForToken] ;
        if (![token isEqualToString:existingLastSaveToken]) {
            NSString* logMsg = [NSString stringWithFormat:@"Updated %@ token: %@",
                                [[self uuid] substringToIndex:4],
                                token] ;
            [[BkmxBasis sharedBasis] logFormat:logMsg] ;
            
            [[NSUserDefaults standardUserDefaults] setAndSyncMainAppValue:token
                                                          forKeyPathArray:keyPathArrayForToken] ;
        }
    }
}

- (void)requestUserInstallExtensionWithPrompt:(NSString*)msg
                            completionHandler:(void (^)(NSModalResponse modalResponse))completionHandler {
    SSYAlert* alert = [SSYAlert alert] ;
    [alert setIconStyle:SSYAlertIconInformational] ;
    [alert setTitleText:@"Browser Extensions"] ;
    [alert setSmallText:msg] ;
    [alert setButton1Title:[@"Install" ellipsize]] ;
    [alert setButton2Title:@"Cancel"] ;
    [alert doooLayout] ;
    [self runModalSheetAlert:alert
                  resizeable:NO
                   iconStyle:SSYAlertIconInformational
           completionHandler:^void(NSModalResponse modalResponse) {
        NSModalResponse alertReturn = [alert alertReturn] ;
        if (alertReturn == NSAlertFirstButtonReturn) {
            [(BkmxAppDel*)[NSApp delegate] manageAddOns:self] ;
        }
        
        if (completionHandler) {
            completionHandler(modalResponse);
        }
    }];
}

- (void)checkAndReportExtension1Status {
    NSError* error = nil ;
    NSMutableArray* clientNamesNeedingExtension = [NSMutableArray new] ;
    for (Client* client in [[self macster] clients]) {
        if ([[[client exporter] isActive] boolValue] || [[[client importer] isActive] boolValue]) {
            Extore* extore = [Extore extoreForIxporter:[client importer]
                                             clientoid:nil
                                             jobSerial:0
                                               error_p:&error] ;
            if (error) {
                NSLog(@"Internal Error 928-0483 %@", error) ;
            }
            else if ([extore needsExtension1InstallError_p:&error]) {
                if (error) {
                    NSLog(@"Internal Error 928-0442 %@", error) ;
                }
                
                if ([extore style1Available]) {
                    [clientNamesNeedingExtension addObject:[client displayName]] ;
                } else {
                    /* For browsers that do not have style 1 available, such as
                     Opera, the extension status is checked and installation is
                     requested if necessary early during each ixport.  The
                     only way we could end up here is if the user cancelled
                     that prior request to install the extension, or if the
                     installation failed for some reason.  In either of those
                     cases, re-requesting extension installation at this point
                     will only serve to annoy the user. */
                }
            }
            
            /* The following statements are probably not necessary because
             the two messages we sent to extore above did not create any
             interapp server nor link to a managed object context.  But
             I put them in anyhow as a matter of good practice, since they
             safely no-op if not needed. */
            [extore tearDownFor:@"ExtensionCheck"
                      jobSerial:0];
            [[client importer] releaseExtore];
        }
    }
    
    if ([clientNamesNeedingExtension count] > 0) {
        NSMutableString* list = [NSMutableString new] ;
        for (NSString* name in clientNamesNeedingExtension) {
            [list appendFormat:@"\n    %@", name] ;
        }
        NSString* msg = [[NSString alloc] initWithFormat:
                         @"Please install our BookMacster Sync extension into the following browsers, so that"
                         @" %@ can perform future imports and exports without asking you if it's OK to quit them."
                         @"  Our extensions enable %@ to import/export while the browser is running, and are required for syncing."
                         @"\n%@",
                         [[BkmxBasis sharedBasis] appNameLocalized],
                         [[BkmxBasis sharedBasis] appNameLocalized],
                         list] ;
        [list release] ;
        [self requestUserInstallExtensionWithPrompt:msg
                                  completionHandler:NULL] ;
        [msg release];
    }
    
    [clientNamesNeedingExtension release] ;
}

- (void)runModalSheetWithMessage:(NSString*)message {
    SSYAlert* alert = [SSYAlert alert] ;
    [alert setSmallText:message] ;
    [self runModalSheetAlert:alert
                  resizeable:NO
                   iconStyle:SSYAlertIconInformational
               modalDelegate:nil
              didEndSelector:NULL
                 contextInfo:NULL] ;
}

#define STARK_STATE_OK                      0
#define STARK_STATE_HOPELESS                1
#define STARK_STATE_BADLY_TAGGED            2
#define STARK_STATE_DISCONTIGUOUS_CHILDREN  4
#define STARK_STATE_NO_STARKID              8

- (void)ensureShigAndDupetainer {
    Bookshig* shig = (Bookshig*)[self fetchSingularManagedObjectForEntity:constEntityNameBookshig] ;
    [self setShig:shig] ;
    Dupetainer* dupetainer = (Dupetainer*)[self fetchSingularManagedObjectForEntity:constEntityNameDupetainer] ;
    [self setDupetainer:dupetainer] ;
}

- (BOOL)upgradeLegacyMetadataToAuxiliaryDataForKey:(NSString*)key {
    NSObject* object = [self metadataObjectForKey:key];
    if (object) {
        [[BkmxBasis sharedBasis] logFormat:@"Updated legacy metadata for %@", key];
        // Add new
        [self setAuxiliaryObject:object
                          forKey:key];
        // Remove old
        [self setMetadataObject:nil
                         forKey:key
                        error_p:NULL];
        return YES;
    }
    
    return NO;
}

- (void)migrateLegacyMetadataToAuxiliaryData {
    NSSet* legacyMetadataKeys = [NSSet setWithObjects:
                                 constKeySavedWithVersion,
                                 constKeyMetal,
                                 constKeyRequiresVersion,
                                 constKeySawChangeUpgradeOffered,
                                 constKeyDocLastSaveToken,
                                 nil];
    BOOL didFindAnyLegacyKeys = NO;
    for (NSString* key in legacyMetadataKeys) {
        BOOL didFindALegacyKey = [self upgradeLegacyMetadataToAuxiliaryDataForKey:key];
        if (didFindALegacyKey) {
            didFindAnyLegacyKeys = YES;
        }
    }
    if (didFindAnyLegacyKeys) {
        /* Supposedly, the metadata changes should be saved when we save the
         managed object context.  However, whether it is due to a bug in macOS
         10.13.3 Beta 4 which I am using, or some other reason, just saving
         the managed object context at this point does not work.  The deleted
         metadata will remain in the file on the disk.  (This type of problem is
         an example of why I want to get away from using this metadata!)
         Anyhow, to work around that, we insert a dummy object, save, delete
         that dummy object, and then save again. */
        NSError* metadataSaveError = nil;
        BOOL metadataSaveOk;
        NSManagedObject* dummyObject = [NSEntityDescription insertNewObjectForEntityForName:constEntityNameMessageLog
                                                                     inManagedObjectContext:self.managedObjectContext] ;
        metadataSaveOk = [self.managedObjectContext save:&metadataSaveError];
        if (!metadataSaveOk) {
            NSLog(@"Internal Error 836-2736 failed to save after removing legacy metadata: %@", [metadataSaveError longDescription]);
        }
        [self.managedObjectContext deleteObject:dummyObject];
        metadataSaveOk = [self.managedObjectContext save:&metadataSaveError];
        if (!metadataSaveOk) {
            NSLog(@"Internal Error 836-2737 failed to save after removing legacy metadata: %@", [metadataSaveError longDescription]);
        }
    }
}

- (void)uniquifySeparatorUrls {
    NSInteger nUpgradedSeparators = 0;
    
    for (Stark* separator in self.starker.allSeparatorStarks) {
        if ([separator separatorify]) {
            nUpgradedSeparators++;
        }
    }
    
    if (nUpgradedSeparators > 0) {
        NSString* msg = [[NSString alloc] initWithFormat:
                         @"%ld separators in this Collection have been upgraded to play better with current implementations of Safari and iCloud."
                         @"\n\n(Although hidden in this app, each separator now has a unique URL.)",
                         (long)nUpgradedSeparators];
        [self performSelector:@selector(runModalSheetWithMessage:)
                   withObject:msg
                   afterDelay:0.0];
        NSError* error = nil;
        BOOL ok = [[self managedObjectContext] save:&error];
        if (!ok) {
            NSLog(@"Error saving after uniquifySeparatorUrls: %@", error);
        }
    }
}

- (void)fixBadMergeBys {
    /* Bug in Bkmx018_019MigrationPolicy in BkmkMgrs 3.0, 3.0.1, 3.0.2 set
     the mergeBy value to BkmxMergeByNone if the now-defunct attribute
     mergeStark was nil.  I don't think it ever should have been nil, but
     apparently, for many users, it was!  Well, BkmxMergeByNone is
     correct for no users, since that setting did not exist before
     BkmkMgrs 3.0.  And BkmxMergeByExidOrUrl is the default value and is
     correct for 99.9% of use cases.  So we search for any BkmxMergeByNone
     values and change them to BkmxMergeByExidOrUrl */
    BOOL didFixAny = NO;
    for (Client* client in [[self macster] clients]) {
        if ([client.importer.mergeBy integerValue] == BkmxMergeByNone) {
            client.importer.mergeBy = [NSNumber numberWithShort:BkmxMergeByExidOrUrl];
            [[BkmxBasis sharedBasis] logFormat:@"Corrected bad mergeBy in %@", client.importer.shortDescription];
            didFixAny = YES;
        }
        if ([client.exporter.mergeBy integerValue] == BkmxMergeByNone) {
            client.exporter.mergeBy = [NSNumber numberWithShort:BkmxMergeByExidOrUrl];
            [[BkmxBasis sharedBasis] logFormat:@"Corrected bad mergeBy in %@", client.exporter.shortDescription];
            didFixAny = YES;
        }
    }
    
    if (didFixAny) {
        [self saveMacster];
    }
}

- (void)fixHardFoldersSortDirective {
    NSInteger nFixed = 0;
    for (Stark* stark in self.starker.allStarks) {
        if ([stark isHartainer]) {
            if (stark.sortDirectiveValue != BkmxSortDirectiveNotApplicable) {
                stark.sortDirectiveValue = BkmxSortDirectiveNotApplicable;
                nFixed++;
            }
        }
    }
    
    if (nFixed > 0) {
        [[BkmxBasis sharedBasis] logFormat:
         @"Fixed %@ hartainer sort directives",
         @(nFixed)];
        NSError* error = nil;
        BOOL ok = [[self managedObjectContext] save:&error];
        if (!ok) {
            NSLog(@"Error saving after fixHardFoldersSortDirective: %@", error);
        }
    }
}

- (BOOL)readFromURL:(NSURL*)url
             ofType:(NSString*)typeName
              error:(NSError**)error_p {
    BOOL __block ok = YES;
    NSError* __block error = nil;
    
    //   Problem ------->   Missing/Extra Basics          Orphan/Untyped Starks
    //   Fixable ------->          NO                             YES
    //                      ---------------------     ---------------------------
    //   normalLaunch       showErr, abort             fix and noShowErr, noAbort
    //   Shift Key Down     noShowErr, noAbort         noFix and showErr, noAbort
    
    NSString* path = [[self fileURL] path] ;
    if (path) {
        ok = ([[NSFileManager defaultManager] fileIsPermanentAtPath:path
                                                            error_p:&error]) ;
        /*
         Unlike most applications which will open a document that is in the
         Trash and then complain about it later if you want to save changes,
         BookMacster will inform you and refuse to open a document that is
         in the Trash.  Besides
         the fact that we feel this is better behavior, it also provides a
         way out in case a document which you have set to open when BookMacster
         launches becomes corrupted such that BookMacster hangs or crashes
         when it tries to open it.  Rather than having to trash your
         BookMacster preferences and lose all your other settings, you need
         only trash the corrupt document.
         */
    }
    else {
        /* This branch was added in BookMacster 1.6.4.  When user clicks
         File > Duplicate, -path is nil.  It's OK.  Do nothing. */
    }
    
    if (!ok) {
        if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
            // Create error which says that the document is in the trash
            NSString* msg = [NSString localizeFormat:
                             @"openTrashNoX",
                             [path lastPathComponent],
                             [[BkmxBasis sharedBasis] appNameLocalized]] ;
            msg = [msg stringByAppendingString:@"  The problem path is:\n   "] ;
            msg = [msg stringByAppendingString:path] ;
            error = [SSYMakeError(64215, msg) errorByAddingUnderlyingError:error];
        }
        else {
            // Added in BookMacster 1.5
            [[BkmxBasis sharedBasis] logFormat:@"Collection is temporary, maybe trashed.  Abort."] ;
        }

        ok = NO;
        goto end;
    }
    else {
        /* Migrate if needed */
        ok =[self migrateIfNeededAndReturnError:&error];
    }
    
    /* Call super to do actual work */
    if (ok) {
        ok = [super readFromURL:url
                         ofType:typeName
                          error:&error];
    }
    
    if (!ok) {
        /* This will happen if the document's Core Data database is unreadable
         for any reason. */
        [self tearDownOnce] ;
        ok = NO ;
        goto end ;
    }
    
    // The persistence stack should be fully functioning at this point.
    
    [self initializeCommonAfterPersistenceStackIsUp];
    
    // Added in BookMacster 1.5, to fix Document Revert
    // This was all done prior to Lion.
    [self setIsReverting:NO] ;
    
    self.lastKnownLastSaveToken = self.lastSaveToken;
    
    /* Migrate any Legacy Metadata, if found, to Auxiliary Data
     
     Starting with BkmkMgrs 2.5.3, values in the document's file on disk
     for the following keys, which where stored in the Core Data metadata
     (under Z_METADATA in the store), have been moved to the auxiliarlyData
     plist file in the package instead.  This eliminates a lot of headaches,
     and the sleaziness of stuffing my metadata in to Core Data's metadata.
     We now do that moving, in case this is the first time that this document
     is being opened in 2.5.3 or later.
     
     We run this as dispatch_sync instead of async because there is code which
     follows immediately (and possibly other code later in document opening)
     which requires that the auxiliary data be migrated.  We run it on the main
     thread because the legacy metadata is in Core Data and we're still using
     legacy thread confinement for this document.  We must also test which
     thread we are on because, we are normally on a secondary thread here, when
     opening a document in the macOS Versions Brwoser we are typically on the
     main thread here. */
    if ([[NSThread currentThread] isMainThread]) {
        [self migrateLegacyMetadataToAuxiliaryData];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self migrateLegacyMetadataToAuxiliaryData];
        });
    }
    
    /* Because this section reads auxiliaryData, we run it *after* upgrading
     legacy metadata to auxiliary data. */
    NSString* savedWithVersionString = self.priorSavedWithVersionString;
    NSString* requiresVersionString = self.priorRequiresVersionString;
    SSYVersionTriplet* requiresVersion = [SSYVersionTriplet versionTripletFromString:requiresVersionString] ;
    SSYVersionTriplet* appVersion = [SSYAppInfo currentVersionTriplet] ;
    if (![self okToOpenDocumentRequiresVersion:requiresVersion
                                  inAppVersion:appVersion]) {
        NSString* desc = [NSString stringWithFormat:
                          @"%@\n\n    %@: %@\n    %@: %@",
                          [NSString localizeFormat:
                           @"versionDocNewerX2",
                           [[NSDocumentController sharedDocumentController] defaultDocumentDisplayName],
                           [[BkmxBasis sharedBasis] appNameLocalized]],
                          [self displayNameShort],
                          savedWithVersionString,
                          [[BkmxBasis sharedBasis] appNameLocalized],
                          [appVersion string]] ;
        NSArray* recoveryOptions = [NSArray arrayWithObjects:
                                    [NSString localize:@"checkForUpdate"],
                                    [NSString localize:@"cancel"],
                                    nil] ;
        NSDictionary* errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                   desc, NSLocalizedDescriptionKey,
                                   [NSNumber numberWithBool:YES], SSYRecoveryAttempterIsAppDelegateErrorKey,
                                   recoveryOptions, NSLocalizedRecoveryOptionsErrorKey,
                                   [NSString localize:@"checkUpdateDo"], NSLocalizedRecoverySuggestionErrorKey,
                                   nil] ;
        error = [NSError errorWithDomain:[NSError myDomain]
                                    code:constBkmxErrorAppTooOldForBookmarkskhelf
                                userInfo:errorInfo] ;
        ok = NO;
        [self tearDownOnce] ;
        goto end;
    }
    
    if ([[NSThread currentThread] isMainThread]) {
        [self ensureShigAndDupetainer];
    } else {
        dispatch_sync(dispatch_get_main_queue(),  ^{
            [self ensureShigAndDupetainer];
        });
    }
    
    // Create a new uuid if we are duplicating a document.
    if ([[BkmxDocumentController sharedDocumentController] respondsToSelector:@selector(isDuplicating)]) {
        if ([[BkmxDocumentController sharedDocumentController] isDuplicating]) {
            [self setUuid:[SSYUuid uuid]] ;
        }
    }
    
    /* Upgrade legacy if uuid has not yet been copied from shig.  At
     this time, we do not remove the Bookshig.uuid; we just ignore
     it.  It should be removed from the data model the next time we
     version the data model. */
    if (![self uuid]) {
        NSString* uuid = [[self shig] uuid];
        if (uuid) {
            [[BkmxBasis sharedBasis] forJobSerial:0 logFormat:@"Upgrading doc: uuid %@ moved to aux data",
             [uuid substringToIndex:4]];
        }
        else {
            uuid = [SSYUuid uuid];
            [[BkmxBasis sharedBasis] forJobSerial:0 logFormat:@"No UUID found.  All settings will default for new uuid %@",
             [uuid substringToIndex:4]];
            
        }
        [self setUuid:uuid];
    }
    
    // We will need a -macster when we -makeWindowControllers, for example, to
    // populate Clients and Syncers.
    // We needed to wait until [self uuid] would return something
    // before we could do this …
    if (![self ssy_isInViewingMode]) {
        // The above condition was added as a great bug fix in BookMacster 1.11,
        // needed if Versions Browser was ended by keeping the same document,
        // that is, clicking the "Done" button instead of "Restore".
        if ([[NSThread currentThread] isMainThread]) {
            [self linkToMacster] ;
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self linkToMacster] ;
            });
        }
    }
    // The following is needed for document Open only.  It is superflous for Revert since the
    // managed object context does not change.
    // It must be done before -makeWindowControllers because the latter invokes
    // -[BkmxDoc showWindows]
    // -[BkmxDocWinCon showWindow]
    // -[StarkTableColumn dataCellForRow:]
    // -[Stark shouldSort] which invokes
    // -[Stark owner]  which needs the owner
    [SSYMOCManager registerOwnerDocument:self
                  ofManagedObjectContext:[self managedObjectContext]] ;
    // Oddly, -revertToContentsOfURL:ofType:error: *removes* the existing
    // window controller by sending -removeWindowController.  So when this
    // method here is invoked by revertToContentsOfURL:ofType:error:, our
    // -addWindowController: is to replace the one that was just removed.
    //    [self makeWindowControllers] ;  Removed in BookMacster 1.11, when name was changed from -makeTheWindow.
    
    // In case we are reverting, the caches in starker will be invalid, so…
    [[self starker] clearCaches] ;
    // The above is also done in -revertToContentsOfURL:ofType:error:.
    // At first, I only did it here.  Then I found there was a crash or
    // something during revert in some cases and fixed it by doing it
    // there, forgetting that I had already done it here.  Therefore,
    // the above may be redundant now.  I'm not sure.
    
    if ([[BkmxBasis sharedBasis] isBkmxAgent]) {
        goto end;
    }
    if ([[BkmxBasis sharedBasis] clandestine]) {
        goto end;
    }
    
    /* Document upgrades may be done here if they do not need to show a
     sheet, because the window is not open yet.  If a sheet needs to be shown,
     put code in -performAnyVersionMigrations instead.  Do not do upgrade
     if self.fileURL == nil because that signifies we are here as a result
     of File ▸ Duplicate or File ▸ Save As. */
    
    /* Next line was removed in BookMacster 1.11 to stop a single Dropbox
     pingpong which always occurred if other Mac in Dropbox was a different
     BookMacster version. See Note 20120307.
     [self updateSavedWithVersion] ;   */
    
    // If user default does not have valid license info, see if we can get License Info from this document.
    if (SSYLCCurrentLevel() < SSYLicenseLevelValid) {
        SSYLCLicenseInfo docLicenseInfo = [self metalInfo] ;
        SSYLicenseLevel licenseLevel = SSYLCValidate(docLicenseInfo) ;
        if (licenseLevel >= SSYLicenseLevelValid ) {
            // Document has good license info
            SSYLCWriteToThisUsersPrefs(docLicenseInfo) ;
            [[NSNotificationCenter defaultCenter] postNotificationName:SSYLicensingStatusDidChangeNotification
                                                                object:self] ;
            NSString* msg = [NSString stringWithFormat:
                             @"License Information has been extracted from this document and installed into Macintosh user account '%@'.\n\n"
                             @"%@ is now fully functioning and licensed for use by %@.",
                             NSUserName(),
                             [[BkmxBasis sharedBasis] appNameLocalized],
                             docLicenseInfo.licenseeName] ;
            [self performSelector:@selector(runModalSheetWithMessage:)
                       withObject:msg
                       afterDelay:1.5] ;
        }
    }
    
end:
    // The following kludge was added in BookMacster 1.7.3.
    // The problem was that, after restoring a BkmxDoc from Versions Browser,
    // if the Open/Save settings had actions in it, these actions would be
    // performed when the document was RE-opened after returning to the
    // regular macOS desktop (Surprisingly, this is the way that
    // Lion does it.  The BkmxDoc you see in the right side of the Versions
    // Browser is *not* the same one that you see on the regular desktop
    // a few seconds later if you "Restore" it.  Anyhow, if the Open/Save
    // actions included, e.g., Import, the data would be immediately
    // changed, which was particularly upsetting if a user had lost their
    // bookmarks in their browser and was trying to get them back.
    // Also see end of -tearDownOnce.  The reason for that timer is that
    // in case the user elects to cancel from the Versions Browser
    // without restoring anything, then closes and reopens the document
    // for some reason, we want it to behave with normal automatic actions.
    // Now, I tried easier ways to fix this problem, but none of them
    // worked because the active document in the Versions Browser
    // is never available – it doesn't show in -[NSDocumentController documents].
    // Therefore, the only place to grab it is while it's opening or closing,
    // because those are the only things, accessible to us mere mortal 3rd-party
    // developers, that we know are going to happen for sure.  Regarding
    // closing, the documents in the Versions Browser, although they are removed
    // from the screen, are not closed and deallocced until after the
    // restored document has opened, and it's too late.  So here we are,
    // during opening.
    if (ok) {
        if ([self ssy_isInViewingMode]) {
            [self setSkipAutomaticActions:YES] ;
            [self forgetAllLastPreImportedHashes] ;
        }
        else if ([[BkmxBasis sharedBasis] isBkmxAgent] || [[BkmxBasis sharedBasis] clandestine]) {
            [self setSkipAutomaticActions:YES] ;
        }
        else if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
            /* Only if NSApp because  we don't want BkmxAgent doing difficult
             tasks which might result in errors. */
            [self ensureIntegrityInBackground];
            [self scheduleOpenHousekeeping];
            [self performAnyVersionMigrations];
            if (![[BkmxBasis sharedBasis] clandestine]) {
                NSError* syncWatchesError = nil ;
                BOOL ok = [self realizeSyncersToWatchesError_p:&syncWatchesError] ;
                if (!ok) {
                    NSLog(@"Internal Error 623-3342 %@", syncWatchesError) ;
                }
            }
        }
    }
    
    if (error && error_p) {
        *error_p = error ;
    }
    
    return ok ;
}

#if 0
#warning Compiling machineGunBookmarks
- (void)machineGunBookmarks {
#define CREATE_BOOKMARKS_START 48703
#define CREATE_BOOKMARKS_STOP 50000
    NSTimeInterval lastLogged = [[NSDate date] timeIntervalSinceReferenceDate] ;
    Starker* starker = [self starker] ;
    Stark* root = [[self starker] root] ;
    [[self shig] setRootLeavesOk:[NSNumber numberWithBool:YES]] ;
    NSMutableArray* newBookmarks = [[NSMutableArray alloc] init] ;
    for (NSInteger i=CREATE_BOOKMARKS_START; i<CREATE_BOOKMARKS_STOP; i++) {
        NSString* numString = [NSString stringWithFormat:@"%05ld", (long)i] ;
        NSString* name = [NSString stringWithFormat:@"Bkmk-%@", numString] ;
        NSString* url = [NSString stringWithFormat:@"http://example.com/%@/", numString] ;
        NSString* comment = [NSString stringWithFormat:@"Created at %@", [[NSDate date] geekDateTimeString]] ;
        Stark* stark = [starker freshDatedStark] ;
        [stark setName:name] ;
        [stark setUrl:url] ;
        [stark setComments:comment] ;
        [stark setSharypeValue:SharypeBookmark] ;
        [newBookmarks addObject:stark] ;
        NSTimeInterval now = [[NSDate date] timeIntervalSinceReferenceDate] ;
        if ((now - lastLogged > 2) || (i == CREATE_BOOKMARKS_STOP - 1)){
            NSLog(@"Created %@", numString) ;
            [StarkEditor parentingAction:BkmxParentingMove
                                   items:newBookmarks
                               newParent:root
                                newIndex:NSNotFound
                            revealDestin:NO] ;
            [newBookmarks removeAllObjects] ;
            lastLogged = now ;
        }
    }
}
#endif

/*!
 @details  -init is invoked for both newly-created and newly-loaded documents
 For newly-created documents, it is invoked within initWithType:error:
 For newly-loaded documents, it is invoked within initWithContentsOfURL:ofType:error:
 Importantly, the persistence stack is not functioning when this method runs.
 If you require that the managed object context be operational, put your
 code in the later-running method, -readFromURL:ofType:error:
 */
- (id)init {
    self = [super init] ;
#if LOGGING_MEMORY_MANAGEMENT_FOR_BkmxDoc
    NSString* path = [NSString stringWithFormat:@"/Users/jk/Desktop/MM-%p.txt", self];
    [SSYLinearFileWriter setToPath:path] ;
    NSLog(@"%s %p", __PRETTY_FUNCTION__, self) ;
#endif
    
    return self ;
}

/*!
 @details  This method is invoked only for newly-created documents.
 */
- (id)initWithType:(NSString *)type
             error:(NSError **)error_p {
    NSError* error = nil ;
    
    self = [super initWithType:type
                         error:error_p] ;
    if (self) {
        if (error && error_p) {
            *error_p = error ;
            self = nil ;
        }
        
        [self initializeCommonAfterPersistenceStackIsUp];
        [self insertRequiredSingularObjectsInNewDocument];
    }
    
    return self ;
}

- (void)insertRequiredSingularObjectsInNewDocument {
    // New documents begin with an empty object graph.  We add the expected singular objects.
    
    // Add a shig
    Bookshig* shig = [NSEntityDescription insertNewObjectForEntityForName:constEntityNameBookshig
                                                   inManagedObjectContext:[self managedObjectContext]] ;
    [self setShig:shig] ;
    
    // Generate and set a uuid
    [self setUuid:[SSYUuid uuid]] ;
    
    // Now that we have a uuid, we can make a Macster for it
    [self linkToMacster] ;
    
    [SSYMOCManager registerOwnerDocument:self
                  ofManagedObjectContext:[self managedObjectContext]] ;
    
    // Into the new shig, set default document notes
    NSString* notes = [NSString localizeFormat:
                       @"whatWhenWho",
                       [NSString localize:@"document"],
                       [NSDate currentDateFormattedConcisely],
                       NSUserName()] ;
    [shig setNotes:notes] ;
    
    // Removed in BookMacster 1.11 when I finally figured out how
    // to let Cocoa do this, just like normal Cocoa developers do.
    // [self makeWindowControllers] ;
    
    // Add a Dupetainer (Duplicate Group Container)
    Dupetainer* dupetainer = [NSEntityDescription insertNewObjectForEntityForName:constEntityNameDupetainer
                                                           inManagedObjectContext:[self managedObjectContext]] ;
    [self setDupetainer:dupetainer] ;
    
    // Document Dirtying and Undo Registration for the above will be
    // cleared by a timer, to make sure Core Data is done with all
    // whatever crap it decides to do.
}

- (void)clearPostLandingTimer {
    if ([m_postLandingTimer isValid]) {
        [m_postLandingTimer invalidate] ;
    }
    [m_postLandingTimer release] ;
    m_postLandingTimer = nil ;
}

- (void)setPostLandingTimer:(NSTimer*)timer {
    [self clearPostLandingTimer] ;
    
    m_postLandingTimer = timer ;
    [m_postLandingTimer retain] ;
}

- (void)firePostLandingTimer {
    [m_postLandingTimer fire] ;
    [self clearPostLandingTimer] ;
}

- (void)clearNukePaveWarnTimer {
    if ([m_nukePaveWarnTimer isValid]) {
        [m_nukePaveWarnTimer invalidate] ;
    }
    [m_nukePaveWarnTimer release] ;
    m_nukePaveWarnTimer = nil ;
}

- (void)clearRefreshVerifyTimer {
    if ([self.refreshVerifyTimer isValid]) {
        [self.refreshVerifyTimer invalidate] ;
    }
    
    self.refreshVerifyTimer = nil ;
}

- (void)setNukePaveWarnTimer:(NSTimer*)timer {
    [self clearNukePaveWarnTimer] ;
    
    m_nukePaveWarnTimer = timer ;
    [m_nukePaveWarnTimer retain] ;
}

- (void)performAnyVersionMigrations {
    if ([self fileURL] != nil) {
        SSYVersionTriplet* priorSavedWithVersionTriplet = [SSYVersionTriplet versionTripletFromString:self.priorSavedWithVersionString];

        if (!priorSavedWithVersionTriplet) {
            // Assume worst case
            priorSavedWithVersionTriplet = [SSYVersionTriplet versionTripletWithMajor:0
                                                                                minor:0
                                                                               bugFix:0];
        }
        
        SSYVersionTriplet* regularThreshold;
        
        regularThreshold = [SSYVersionTriplet versionTripletWithMajor:2
                                                                minor:9
                                                               bugFix:9] ;
        if ([priorSavedWithVersionTriplet isBkmxEffectivelyEarlierThanRegular:regularThreshold]) {
            [self performSelectorOnMainThread:@selector(uniquifySeparatorUrls)
                                   withObject:nil
                                waitUntilDone:NO];
        }
        
        regularThreshold = [SSYVersionTriplet versionTripletWithMajor:2
                                                                minor:9
                                                               bugFix:11];
        if ([priorSavedWithVersionTriplet isBkmxEffectivelyEarlierThanRegular:regularThreshold]) {
            [self performSelectorOnMainThread:@selector(fixHardFoldersSortDirective)
                                   withObject:nil
                                waitUntilDone:NO];
            
        }
        
        regularThreshold = [SSYVersionTriplet versionTripletWithMajor:2
                                                                minor:10
                                                               bugFix:21];
        if ([priorSavedWithVersionTriplet isBkmxEffectivelyEarlierThanRegular:regularThreshold]) {
            [self performSelectorOnMainThread:@selector(migrateLegacyBraveToBravePublic)
                                   withObject:nil
                                waitUntilDone:NO];
        }
        
        regularThreshold = [SSYVersionTriplet versionTripletWithMajor:3
                                                                minor:0
                                                               bugFix:3];
        if ([priorSavedWithVersionTriplet isBkmxEffectivelyEarlierThanRegular:regularThreshold]) {
            [self performSelectorOnMainThread:@selector(fixBadMergeBys)
                                   withObject:nil
                                waitUntilDone:NO];
        }


        regularThreshold = [SSYVersionTriplet versionTripletWithMajor:3
                                                                minor:0
                                                               bugFix:13];
        if ([priorSavedWithVersionTriplet isBkmxEffectivelyEarlierThanRegular:regularThreshold]) {
            [self performSelectorOnMainThread:@selector(migrateOperaLocalDataToOpera103WithProfiles)
                                   withObject:nil
                                waitUntilDone:NO];
        }
    } else {
        /* See Note NoUpdateNeeded */
    }
    
    /* Note NoUpdateNeeded
     This can happen for a new File ▸ Duplicate or File ▸ Save As document.
     Of course, such a document does not require any updating. */
}

#pragma mark * Basic Infrastructure

- (void)updateChangeCount:(NSDocumentChangeType)change {
    if (
        (change == NSChangeDone)
        || (change == NSChangeUndone)
        || (change == NSChangeRedone)
        ) {
            if (m_postLandingTimer) {
                NSDate* newDate = [NSDate dateWithTimeIntervalSinceNow:IDLE_EDITING_TIMEOUT] ;
                [m_postLandingTimer setFireDate:newDate] ;
            }
        }
    
    [super updateChangeCount:change] ;
}

- (NSString*)displayNameShort {
    return [[self displayName] stringByDeletingPathExtension] ;
}

- (NSString*)displayNameForHartainerSharype:(Sharype)sharype {
    NSString* answer = nil ;
    SEL selector = NULL ;
    switch (sharype) {
        case SharypeRoot:
            answer = [[BkmxBasis sharedBasis] labelRoot] ;
            break;
        case SharypeBar:
            selector = @selector(labelBar) ;
            break;
        case SharypeMenu:
            selector = @selector(labelMenu) ;
            break;
        case SharypeUnfiled:
            selector = @selector(labelUnfiled) ;
            break;
        case SharypeOhared:
            selector = @selector(labelOhared) ;
            break;
        default:
            answer = [NSString stringWithFormat:@"?type=%ld?", (long)sharype] ;
            NSLog(@"Internal Error 324-5745 %ld", (long)sharype) ;
    }
    
    if (selector) {
        answer = [self performSelector:selector] ;
    }
    
    return answer ;
}

/*
 @details  This method is also invoked when a document is restored from the Lion
 Versions Browser.
 */
- (BOOL)revertToContentsOfURL:(NSURL*)inAbsoluteURL
                       ofType:(NSString*)inTypeName
                        error:(NSError**)outError {
    /* Prior to BookMacster 1.12.8, setIsReverting:YES was at the end of this
     secion, after setDupetainer:nil.  This created a bug because when a bksmlf
     was restored from the verisons browser (or reverted, I think), the
     first line, invoking -windowWillClose, will invoke -tearDownOnce, and,
     finding -isReverting to be NO, would do inappropriate stuff such as
     removing needed observers.
     */
    [self setIsReverting:YES] ;
    NSNotification* note = [NSNotification notificationWithName:NSWindowWillCloseNotification
                                                         object:[[self bkmxDocWinCon] window]] ;
    [[self bkmxDocWinCon] windowWillClose:note] ;
    [[self starker] clearCaches] ;
    [self forgetAllClientsVolatileLastIxportedData] ;
    [self setShig:nil] ;
    [self setDupetainer:nil] ;
    [self setSkipAutomaticActions:YES] ;
    
    // Here's what the following method will do to various objects:
    //   OBJECT                    EFFECT OF -[super revertToContentsOfURL:::]
    //   -----------------------   -------------------------------------------
    //   Document (BkmxDoc):       Same object (of course)
    //   Managed object context:   macOS 10.11 and earlier: Same object, but it gets -reset.  10.12: New object
    //   Undo Manager:             Same object, but presumably it gets reset or has all actions removed.
    //                             Change count is not touched.  Needs couplng to new MOC.
    //   Starker and Tagger        See comments on -forgetStarkerAndTagger
    //   Window Controller:        Removes it.  When this method invokes readFromURL:::, we add a new one
    //   Window:                   Goes along with the window controller
    // I note that the same effects occur when a document is restored from
    // the Versions Browser.
    // I think that the changeout of Window  Controller and Window are unique
    // to NSPersistentDocument (Core Data).  That does not occur when reverting
    // or restoring a plain old NSDocument.
    BOOL ok = [super revertToContentsOfURL:inAbsoluteURL
                                    ofType:inTypeName
                                     error:outError] ;
    
    // This is needed for macOS 10.12 or later, due to the new MOC
    [self forgetStarkerAndTagger] ;
    
    /*
     Some Document Feedback that I submitted regarding revertDocumentToSaved:
     
     In revertDocumentToSaved:, it is stated that "The default implementation of
     this method presents an alert dialog giving the user the opportunity to
     cancel the operation. If the user chooses to continue, the method …
     and then invokes revertToContentsOfURL:ofType:error:."
     
     That is not always true.  Quite significantly, the dialog is only shown if
     the document is edited; otherwise this method seems to invoke
     revertToContentsOfURL:ofType:error: immediately.  Furthermore, if the
     document is edited but if document's window is already displaying a sheet
     for another purpose, then the only thing that happens is an NSBeep().
     */
    
    // WAS necessary because, in NS*Persistent*Document, reverting closes the doc's windows…
    // Removed in BookMacster 1.11 when I finally figured out how
    // to let Cocoa do this, just like normal Cocoa developers do.
    //    [self makeWindowControllers] ;
    //    [[self bkmxDocWinCon] showWindow:self] ;
    
    // CLEAR-STAGING //[[self bkmxDocWinCon] clearReloadStagingOfContent] ;
    // CLEAR-STAGING //[[self bkmxDocWinCon] reloadAll] ;
    
    return ok ;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"%@ %p \"%@\"", [self className], self, [self displayName]] ;
}

#pragma mark * Creating Modal Sheets

- (void)runModalSheetAlert:(SSYAlert *)alert
                resizeable:(BOOL)resizeable
                 iconStyle:(NSInteger)iconStyle
         completionHandler:(void(^)(NSModalResponse modalResponse))completionHandler {
    [alert setIconStyle:iconStyle] ;
    NSWindow* window = [[self bkmxDocWinCon] window] ;
    if (window) {
        [alert runModalSheetOnWindow:window
                          resizeable:resizeable
                   completionHandler:completionHandler] ;
    }
}


- (void)runModalSheetAlert:(SSYAlert*)alert
                resizeable:(BOOL)resizeable
                 iconStyle:(NSInteger)iconStyle
             modalDelegate:(id)delegate
            didEndSelector:(SEL)didEndSelector
               contextInfo:(void*)contextInfo {
    [alert setIconStyle:iconStyle] ;
    NSWindow* window = [[self bkmxDocWinCon] window] ;
    if (window) {
        [alert runModalSheetOnWindow:window
                          resizeable:resizeable
                       modalDelegate:delegate
                      didEndSelector:didEndSelector
                         contextInfo:contextInfo] ;
        
        if ([[alert helpAddress] isEqualToString:constHelpAnchorSafeSyncLimit]) {
            [[BkmxBasis sharedBasis] logFormat:@"Warned user of Safe Limit Violation"] ;
        }
    }
    else {
        // The following *was* Internal Error 593-9834 until BookMacster 1.17
        NSLog(@"The following Alert could not be presented because there was no BkmxDoc window:\n%@\n%@\n%@", alert, [[alert window] title], [alert smallText]) ;
        // Additional strings were added to the above in BookMacster 1.12.6
    }
}

- (void)alertError:(NSError*)error
     modalDelegate:(id)delegate
    didEndSelector:(SEL)didEndSelector {
    
    if (YES
        && ![[BkmxBasis sharedBasis] shouldHideError:error]
        && ![error isOnlyInformational]
        && ![[[error userInfo] objectForKey:constKeyDontPauseSyncing] boolValue]
        ) {
        // This is an important error
        if ([[self macster] syncerConfigValue] != constBkmxSyncerConfigNone) {
            // Pause Syncers
            NSString* localizedDescription = [[self macster] pauseSyncersAndAppendToMessage:[error localizedDescription]] ;
            error = [error errorByAddingLocalizedDescription:localizedDescription] ;
        }
    }
    
    if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
        // This is the MainApp executing
        [SSYAlert alertError:error
                    onWindow:[[self bkmxDocWinCon] window]
               modalDelegate:delegate
              didEndSelector:didEndSelector
                 contextInfo:NULL] ;
    }
    else {
        // This is BkmxAgent executing
        [[AgentPerformer sharedPerformer] registerError:error] ;
    }
}

- (void)alertError:(NSError*)error {
    if ([[BkmxBasis sharedBasis] isBkmxAgent]) {
        /* True, document will be closed after the dialog clears, by
         finishJob:bkmxDoc:.  But we close it now in case user clicks "View",
         which launches the main app, which may try to open the document, which I
         think will be delayed by file coordination if are holding it open, which
         may cause Error 257938, */
        [self close];
    }
    [self alertError:error
       modalDelegate:nil
      didEndSelector:NULL] ;
}

- (void)runModalMonologueAlert:(SSYAlert*)alert {
    [self runModalSheetAlert:alert
                  resizeable:NO
                   iconStyle:SSYAlertIconInformational
               modalDelegate:nil
              didEndSelector:NULL
                 contextInfo:NULL] ;
}

#pragma mark * Error Recovery

/*!
 @details  We recover from the Safe Limit error in BkmxDoc.m instead of
 Extore.m because the BkmxDoc is readily available in the event that the
 error occurs in BkmxAgent and we recover using a recoveryAttempterUrl.
 I think that makes sense because the other common error, browser running,
 cannot happen in BkmxAgent.  It will do its deference and just skip it
 if the deference/niceness does not allow work to be done.
 */
- (void)attemptRecoveryFromError:(NSError *)error
                  recoveryOption:(NSUInteger)recoveryOption
                        delegate:(id)dontUseThis
              didRecoverSelector:(SEL)useInvocationFromInfoDicInstead
                     contextInfo:(void*)notUsed {
    error = [error deepestRecoverableError] ;
    /* Note that the domain of the error could be either
     com.sheepsystems.<appName> or com.sheepsystems.BkmxAgent-<timestamp> */
    switch ([error code]) {
        case constBkmxErrorImportChangesExceededLimit:
        case constBkmxErrorExportChangesExceededLimit:
            // Starting in BookMacster 1.5.7, this error only occurs in BkmxAgent.
            // We are not in BkmxAgent now, but the error occurred in BkmxAgent.
            
            // Bug fixed in BookMacster 1.7/1.6.8.  Instead of just re-doing the
            // failed Import or Export, we re-do the whole Syncer.
            // Otherwise, for example, say that the error occurred during the
            // export which followed an import an a sort, and is followed by
            // a save.  If we don't import and sort, we'll just be re-exporting
            // the old Content, and won't save at the end (although autosave
            // will occur in Lion only).  Yikes!!
            
            break ;
        case constBkmxErrorBrowserBookmarksWereChangedDuringSync:
            switch (recoveryOption) {
                case NSAlertFirstButtonReturn:;
                    // "Reset"
                    Client* client = [[error userInfo] objectForKey:constKeyClient] ;
                    [self forgetLastPreImportedHashForClient:client] ;
                    [self forgetLastPreExportedHashForClient:client] ;
                    break ;
                case NSAlertSecondButtonReturn:;
                    // "Cancel"
                    break ;
            }
            break ;
        default:
            NSLog(@"Internal Error 623-1567.  Unknown recovery for %@", [error longDescription]) ;
    }
}

- (NSString*)displayNamesForIxporters:(NSArray*)ixporters {
    return [ixporters listValuesForKey:@"displayName"];
}

#pragma mark * Import and Export

- (void)importLaInfo:(NSMutableDictionary*)info 
 grandDoneInvocation:(NSInvocation*)grandDoneInvocation {
    [self endEditing:nil];
    if ([[NSApp delegate] respondsToSelector:@selector(endEditingForInspector)]) {
        [(BkmxAppDel*)[NSApp delegate] endEditingForInspector] ;
    }
    
    NSSet* doOnlyImportersSet = [info objectForKey:constKeyDoOnlyImportersSet] ;
    
    NSArray* importersToDo = nil ;
    NSString* what;
    if (doOnlyImportersSet) {
        importersToDo = [[doOnlyImportersSet allObjects] arrayByReorderingForIxport];
        [info removeObjectForKey:constKeyDoOnlyImportersSet];
        [info setObject:importersToDo
                 forKey:constKeyDoOnlyImportersArray];
        
        // Access displayName (via client) of importers  in a Core Data thread-safe manner.
        NSString* key = @"displayName";
        NSInvocation* invocation = [NSInvocation invokeOnMainThreadTarget:importersToDo
                                                                 selector:@selector(listValuesForKey:)
                                                          retainArguments:YES
                                                            waitUntilDone:YES
                                                        argumentAddresses:&key];
        [invocation getReturnValue:&what];
    }
    else {
        // This job will import from all clients.
        
        // Importers must execute in the correct active importers in correct order.
        // Otherwise, we'll get:
        //   1.  Unexpected merge results.  User specifies the order.
        //   2.  Orphaned bookmarks in the database, since the Connect Families
        //       phase of ixport operation will occur during what should
        //       have been the last import but may not be.
        //   3.  Incorrect summary statistics displayed, for the same reason.
        
        // Access activeImportersOrdered in a Core Data thread-safe manner.
        NSInvocation* invocation = [NSInvocation invokeOnMainThreadTarget:[self macster]
                                                                 selector:@selector(activeImportersOrdered)
                                                          retainArguments:YES
                                                            waitUntilDone:YES
                                                        argumentAddresses:NULL] ;
        [invocation getReturnValue:&importersToDo] ;
        importersToDo = [importersToDo arrayByReorderingForIxport];
        what = @"all";
    }
    
    NSString* msg = [NSString stringWithFormat:
                     @"Shall queue importing %@",
                     what] ;
    [[BkmxBasis sharedBasis] logFormat:msg] ;
    
    // The pre-import and post-import operations will share the
    // same grandInfo.  One reason to do this is so that the
    // constKeyDidBeginUndoGrouping which is set by -beginUndoGrouping
    // in the pre-ops can be detected by -limitSafe in the post-ops.
    NSMutableDictionary* grandInfo = [NSMutableDictionary dictionary] ;
    // Note that we pass only the first ixporter.  That will suffice, because this ixporter
    // will be used only during -limitSafe for the following purposes:
    // * To see if it is a quickie, and thus the limit should be ignored
    // * To see if it is an importer, which is used in determining the
    //      limit that applies and in constructing the message shown to
    //      the user if the limit is exceeded.
    // * If needed, to get its -ixportCount (actually it would be better
    //      if Bookshig had an -ixportCount.  Bug 230923.
    [grandInfo setValue:[importersToDo firstObjectSafely]
                 forKey:constKeyIxporter] ;
    [grandInfo setValue:[info objectForKey:constKeyDoOnlyImportersArray]
                 forKey:constKeyDoOnlyImportersArray] ;
    [grandInfo setValue:[info objectForKey:constKeyDoOnlyExporter]
                 forKey:constKeyDoOnlyExporter] ;
    // Added in BookMacster 1.9.5 to eliminate Internal Error 208-9593 when recovering
    // from an import which failed due to constBkmxErrorBrowserExtensionFailedWillTryToInstall.
    [grandInfo setObject:self
                  forKey:constKeyDocument] ;
    /* job is needed in case it is necessary to stage a do-over, and for hash  */
    [grandInfo setValue:[info objectForKey:constKeyJob]
                 forKey:constKeyJob] ;
    [grandInfo setValue:[info objectForKey:constKeySerialString]
                 forKey:constKeySerialString] ;
    [grandInfo setValue:[info objectForKey:constKeyAgentDoesImport]
                 forKey:constKeyAgentDoesImport] ;
    // The next two are needed if we are being re-invoked
    // after a Safe Limit error when the user clicked "Ignore Once"
    [grandInfo setValue:[info objectForKey:constKeyTriggerUri]
                 forKey:constKeyTriggerUri] ;
    [grandInfo setValue:[info objectForKey:constKeyIgnoreLimit]
                 forKey:constKeyIgnoreLimit] ;
    [grandInfo setValue:[info objectForKey:constKeyClientShouldSelfDestruct]
                 forKey:constKeyClientShouldSelfDestruct] ;
    [grandInfo setValue:[info objectForKey:constKeyOverlayClient]
                 forKey:constKeyOverlayClient] ;
    [grandInfo setObject:[[BkmxBasis sharedBasis] labelImport]
                  forKey:constKeyActionName] ;
    [grandInfo setValue:grandDoneInvocation
                 forKey:constKeyGrandDoneInvocation] ;
    // The following line was added in BookMacster 1.14.9.  I think it should
    // have been here from the beginning.  Indeed, it was not showing up as
    // expected later.  I don't think think this was causing any problem.
    // However, evidence of the mistake is that the value of constKeyStagingPid
    // was transferred twice in this sequence of statments.  Maybe one of those
    // was supposed to have been this one…
    [grandInfo setValue:[info objectForKey:constKeyPerformanceType]
                 forKey:constKeyPerformanceType] ;
    
    // sponsoredChildren is unique in that the same object is inserted into
    // grandInfo and info for each import.  This is because sponsorships
    // during import of each client must be accumulated and finally gulped.
    NSMutableDictionary* sponsoredChildren = [[NSMutableDictionary alloc] init] ;
    [grandInfo setObject:sponsoredChildren
                  forKey:constKeySponsoredChildren] ;
    [info setObject:sponsoredChildren
             forKey:constKeySponsoredChildren] ;
    [sponsoredChildren release] ;
    
    /* Prepare to add operations to the queue.  Starting in BkmkMgrs 2.5, we
     suspend the queue while adding operations to it.  Otherwise, Xcode's
     ThreadSanitizer may complain while running that we have altered a mutable
     dictionary, presumably info aka grandInfo, while another thread was
     reading it.  However, when we are in BkmxAgent, when running
     -[AgentPerformer performOverrideDeference:::::], which invokes us via
     -importPerInfo:, we are already suspended (for a good reason), and need
     to remain suspended. */
    BOOL didSuspendQueue = NO;
    if (!self.operationQueue.isSuspended) {
        [[self operationQueue] setSuspended:YES];
        didSuspendQueue = YES;
    }
    
    NSArray* selectorNames ;
    
    // Queue pre-import operations
    selectorNames = [NSArray arrayWithObjects:
                     @"beginDebugTrace",
                     @"beginUndoGrouping",
                     @"waitForClientProfile",
                     @"clearForIxport",
                     nil] ;
    [[self operationQueue] queueGroup:@"Import-Grande"
                                addon:NO
                        selectorNames:selectorNames
                                 info:grandInfo
                                block:NO
                           doneThread:nil
                           doneTarget:nil
                         doneSelector:NULL
                         keepWithNext:YES] ;
    
    // Queue import operation for each importer
    NSString* group ;
    for (Ixporter* importer in importersToDo) {
        // Careful here!  Note that we *copy* the info for each
        // importer.  This is because, even though all info copies
        // are initially are the same, they may mutate for each
        // importer as the imports progress!
        NSMutableDictionary* importerInfo = [info mutableCopy] ;
        [[BkmxBasis sharedBasis] logFormat:@"Queueing import for %@", [[importer client] displayName]];
        group = [NSString stringWithFormat:
                 @"Import%02ld(%@)",
                 (long)m_ixportIndex++,
                 importer.client.displayName] ;
        
        [importer importGroup:group
                         info:importerInfo] ;
        [importerInfo release] ;
    }
    
    // Queue post-import operations
    selectorNames = [NSArray arrayWithObjects:
                     @"gulpImport",
                     @"limitSafe",
                     @"syncLog",
                     @"actuallyDelete",
                     @"setUndoActionName",
                     @"updateCaches",
                     @"showCompletionImported",
                     nil] ;
    [[self operationQueue] queueGroup:@"Import-Grande"
                                addon:YES
                        selectorNames:selectorNames
                                 info:grandInfo
                                block:NO
                           doneThread:nil // Defaults to main thread
                           doneTarget:self
                         doneSelector:@selector(finishImportInfo:)
                         keepWithNext:NO] ;
    
    if (didSuspendQueue) {
        [[self operationQueue] setSuspended:NO];
    }
}

- (void)importPerInfo:(NSMutableDictionary*)info {
    if (!info) {
        NSLog(@"Internal Error 838-3923") ;
    }
    
    [info setObject:self
             forKey:constKeyDocument] ;
    
    [self importLaInfo:info
   grandDoneInvocation:nil] ;
}

- (void)exportPerInfo:(NSMutableDictionary*)info {
    [self endEditing:nil] ;
    if ([[NSApp delegate] respondsToSelector:@selector(endEditingForInspector)]) {
        [(BkmxAppDel*)[NSApp delegate] endEditingForInspector] ;
    }
    
    [info setObject:self
             forKey:constKeyDocument] ;
    
    // Hmmmmm: -[Exporter displayName] requires Core Data access!
    NSAssert([NSThread isMainThread], @"Internal Error 374-8284");
    Exporter* singleExporter = [info objectForKey:constKeyDoOnlyExporter] ;
    
    NSArray* exportersToDo ;
    if (singleExporter) {
        exportersToDo = [NSArray arrayWithObject:singleExporter] ;
    }
    else {
        // There is one minor reason here to use the 'Ordered' version
        // of exporters: Incorrect summary statistics may be displayed
        // if exporters are not in correct order.
        
        // Access activeExportersOrdered in a Core Data thread-safe manner.
        NSInvocation* invocation = [NSInvocation invokeOnMainThreadTarget:[self macster]
                                                                 selector:@selector(activeExportersOrdered)
                                                          retainArguments:YES
                                                            waitUntilDone:YES
                                                        argumentAddresses:NULL] ;
        [invocation getReturnValue:&exportersToDo] ;
        exportersToDo = [exportersToDo arrayByReorderingForIxport] ;
    }
    
    for (Ixporter* exporter in exportersToDo) {
        // Careful here!  Note that we copy a separate dictionary
        // instance for each importer.  Even though their initial
        // contents are the same except for grandDoneInvocation,
        // they may mutate for each importer as the imports
        // progress!
#if 0
#warning Using SSYDebuggingMutableDictionary for export's info
        NSMutableDictionary* exporterInfo = [[SSYDebuggingMutableDictionary alloc] init] ;
        [exporterInfo addEntriesFromDictionary:info] ;
#else
        NSMutableDictionary* exporterInfo = [info mutableCopy] ;
#endif
        NSString* group = [NSString stringWithFormat:
                           @"Export%02ld(%@)",
                           (long)m_ixportIndex++,
                           exporter.client.displayName] ;
        
        // Because an export affects only itself,
        [exporterInfo setValue:[NSNumber numberWithBool:YES]
                        forKey:constKeyDontStopOthersIfError] ;
        [exporter exportGroup:group
                         info:exporterInfo] ;
        [exporterInfo release] ;
    }
    
    /* Construct and queue an Export-Grande group which performs the uninhibit,
     and reminds user to install extension if necessary. */
    NSNumber* uninhibitSeconds = [info objectForKey:constKeyUninhibitSecondsAfterDone] ;
    NSMutableDictionary* grandInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      self, constKeyDocument,
                                      nil] ;
    NSMutableArray* selectorNames = [NSMutableArray new];
    if (uninhibitSeconds) {
        [selectorNames addObject:@"uninhibit"] ;
        [grandInfo setObject:uninhibitSeconds
                      forKey:constKeyUninhibitSecondsAfterDone] ;
    }
    if (!singleExporter) {
        [selectorNames addObject:@"checkAndReportExtension1Status"];
    }
    
    NSArray* immutableSelectorNames = [selectorNames copy];
    [[self operationQueue] queueGroup:@"Export-Grande"
                                addon:YES
                        selectorNames:immutableSelectorNames
                                 info:grandInfo
                                block:NO
                           doneThread:nil // Defaults to main thread
                           doneTarget:nil
                         doneSelector:NULL
                         keepWithNext:NO] ;
    [selectorNames release];
    [immutableSelectorNames release];
    
    NSString* what = singleExporter
    ? [NSString stringWithFormat:
       @"only %@",
       [singleExporter displayName]]
    : @"all" ;
    NSString* msg = [NSString stringWithFormat:
                     @"Queued ops to export %@",
                     what] ;
    [[BkmxBasis sharedBasis] logFormat:msg] ;
    
}

- (void)exportDocWithInfo:(NSDictionary*)moreInfo {
    if ([moreInfo objectForKey:constKeyUninhibitSecondsAfterDone] != nil) {
        NSDate* uninhibitDate = [NSDate dateWithTimeIntervalSinceNow:1200.0] ;
        /* Tentatively set the general uninhibit for 20 minutes into the
         future.  When the export completes, this will be rolled back, in
         [SSYOperation(Operation_Common) uninhibit_unsafe], to the value which
         is in the operation's info dictionary, which is 30 seconds after the
         conclusion of the export. */
        [[BkmxBasis sharedBasis] logFormat:@"Set General Uninhibit tentatively to %@", [uninhibitDate geekDateTimeString]] ;
        [[NSUserDefaults standardUserDefaults] setGeneralUninhibitDate:uninhibitDate] ;
        // And since this will be soon read by BkmxAgent,
        [[NSUserDefaults standardUserDefaults] synchronize] ;
    }
    
    NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 // Since we've definitely got the GUI here, deference is ask
                                 [NSNumber numberWithInteger:BkmxDeferenceAsk], constKeyDeference,
                                 [NSNumber numberWithBool:YES], constKeyIfNotNeeded,
                                 [NSNumber numberWithInteger:BkmxPerformanceTypeUser], constKeyPerformanceType,
                                 self, constKeyDocument,
                                 nil] ;
    [info addEntriesFromDictionary:moreInfo] ;
    
    [self exportPerInfo:info] ;
}

- (NSString*)vulnerableClientsListGivenPossibleSingleIxporter:(Ixporter*)singleIxporter {
    NSString* vulnerableClientsList ;
    if (singleIxporter) {
        if ([[singleIxporter deleteUnmatched] boolValue] == YES) {
            vulnerableClientsList = [[singleIxporter client] displayName] ;
        }
        else {
            vulnerableClientsList = nil ;
        }
    }
    else {
        vulnerableClientsList = [[self macster] readableExportsListOnlyIfVulnerable:YES
                                                                      maxCharacters:2048] ;
    }
    
    return vulnerableClientsList ;
}

- (void)exportWithAlert:(SSYAlert*)alert
                   info:(NSDictionary*)info {
    if (alert) {
        NSInteger checkboxState = [alert checkboxState] ;
        if (checkboxState == NSControlStateValueOn) {
            [[NSUserDefaults standardUserDefaults] setBool:YES
                                                    forKey:constKeyDontWarnExport] ;
        }
    }
    
    FolderStatistics stats = [[[self starker] root] addFolderStatistics] ;
    NSInteger nBookmarks = stats.nBookmarks ;
    Exporter* singleExporter = [info objectForKey:constKeyDoOnlyExporter] ;
    NSString* vulnerableClientsList = [self vulnerableClientsListGivenPossibleSingleIxporter:singleExporter] ;
    
    if (
        NSApp
        && ([[info objectForKey:constKeyIxportBookmacsterizerOnly] boolValue] == NO)
        && (nBookmarks < [[NSUserDefaults standardUserDefaults] integerForKey:constKeyMinExportLimit])
        && ([vulnerableClientsList length] > 0)) {
            
            NSString* willBeEmpty = (nBookmarks == 0)
            ? [NSString stringWithFormat:@"\n\nPlease understand: If you click '%@', all bookmarks in %@ WILL BE WIPED OUT.  Their bookmarks will be EMPTY.  If this is not what you want, click '%@'.",
               [[BkmxBasis sharedBasis] labelExport],
               vulnerableClientsList,
               [[BkmxBasis sharedBasis] labelCancel]]
            : @"" ;
            
            NSString* msg = [NSString stringWithFormat:
                             @"Are you REALLY SURE you want to do this?\n\n"
                             @"Clicking %@ will WIPE OUT any existing bookmarks in %@, and replace them with the %ld bookmarks which are in this document.%@",
                             [[BkmxBasis sharedBasis] labelExport],
                             vulnerableClientsList,
                             (long)nBookmarks,
                             willBeEmpty] ;
            SSYAlert* alert = [SSYAlert alert] ;
            [alert setTitleText:@"BOOKMARKS TO BE WIPED OUT!"] ;
            [alert setSmallText:msg] ;
            [alert setIconStyle:SSYAlertIconCritical] ;
            [alert setButton1Title:[[BkmxBasis sharedBasis] labelExport]] ;
            [alert setButton2Title:[[BkmxBasis sharedBasis] labelCancel]] ;
            
            BOOL shouldPause = [[info objectForKey:constKeyPauseSyncersIfUserCancelsExport] boolValue] ;
            NSArray* doneInvocations = [NSArray arrayWithObjects:
                                        // "Export"
                                        [NSInvocation invocationWithTarget:self
                                                                  selector:@selector(exportDocWithInfo:)
                                                           retainArguments:YES
                                                         argumentAddresses:&info],
                                        // "Cancel"
                                        [NSInvocation invocationWithTarget:[self macster]
                                                                  selector:@selector(pauseSyncers:alert:)
                                                           retainArguments:YES
                                                         argumentAddresses:&shouldPause, &alert],
                                        nil] ;
            [self runModalSheetAlert:alert
                          resizeable:NO
                           iconStyle:SSYAlertIconInformational
                       modalDelegate:[SSYSheetEnder class]
                      didEndSelector:@selector(didEndGenericSheet:returnCode:retainedInvocations:)
                         contextInfo:[doneInvocations retain]] ;
            
        }
    else {
        [self exportDocWithInfo:info] ;
    }
}

- (void)                   doSort:(BOOL)doSort
    thenExportIfPermittedWithInfo:(NSDictionary*)info {
    if (doSort) {
        [self sort] ;
    }
    [self exportIfPermittedInfo:info] ;
}

- (void)exportIfPermittedInfo:(NSDictionary*)info {
    if ([self ssy_isInViewingMode]) {
        NSBeep() ;
        return ;
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:constKeyDontWarnExport]) {
        Exporter* singleExporter = [info objectForKey:constKeyDoOnlyExporter] ;
        NSString* clientsList = singleExporter ? [[singleExporter client] displayName] : [[self macster] readableExportsListOnlyIfVulnerable:NO
                                                                                                                               maxCharacters:2048] ;
        NSString* vulnerableClientsList ;
        if ([[info objectForKey:constKeyIxportBookmacsterizerOnly] boolValue]) {
            vulnerableClientsList = nil ;
        }
        else {
            vulnerableClientsList = [self vulnerableClientsListGivenPossibleSingleIxporter:singleExporter] ;
        }
        NSString* wipeoutMessage ;
        if ([vulnerableClientsList length] > 0) {
            wipeoutMessage = [NSString stringWithFormat:
                              @"\xe2\x80\xa2 I understand that whatever bookmarks are currently in %@ will be WIPED OUT.\n\n",
                              vulnerableClientsList] ;
        }
        else {
            wipeoutMessage = @"" ;
        }
        
        NSString* msg = [NSString stringWithFormat:
                             @"By clicking 'Export', I affirm:\n\n"
                         @"\xe2\x80\xa2 I have examined the Content in the document behind this sheet, and approve of it being pushed into %@.\n\n"
                         @"%@"
                         @"\xe2\x80\xa2 I understand that undoing an export is possible but not convenient.",
                         clientsList,
                         wipeoutMessage
        ] ;
        SSYAlert* alert = [SSYAlert alert] ;
        [alert setTitleText:@"Exporting is For Real!"] ;
        [alert setSmallText:msg] ;
        [alert setIconStyle:SSYAlertIconCritical] ;
        [alert setButton1Title:[[BkmxBasis sharedBasis] labelExport]] ;
        [alert setButton2Title:[[BkmxBasis sharedBasis] labelCancel]] ;
        [alert setCheckboxTitle:[NSString localize:@"dontShowAdvisoryAgain"]] ;
        // FIXME 20140204 [alert setHelpAddress:(NSString *)] ;
        
        BOOL shouldPause = [[info objectForKey:constKeyPauseSyncersIfUserCancelsExport] boolValue] ;
        NSArray* doneInvocations = [NSArray arrayWithObjects:
                                    // "Export"
                                    [NSInvocation invocationWithTarget:self
                                                              selector:@selector(exportWithAlert:info:)
                                                       retainArguments:YES
                                                     argumentAddresses:&alert, &info],
                                    // "Cancel"
                                    [NSInvocation invocationWithTarget:[self macster]
                                                              selector:@selector(pauseSyncers:alert:)
                                                       retainArguments:YES
                                                     argumentAddresses:&shouldPause, &alert],
                                    nil] ;
        [self runModalSheetAlert:alert
                      resizeable:NO
                       iconStyle:SSYAlertIconInformational
                   modalDelegate:[SSYSheetEnder class]
                  didEndSelector:@selector(didEndGenericSheet:returnCode:retainedInvocations:)
                     contextInfo:[doneInvocations retain]] ;
    }
    else {
        [self exportWithAlert:nil
                         info:info] ;
    }
}


/*
 Import/Export Method Stack.
 I really need to make a diagram of this one of these days.
 But, at least, here's a start…
 
 Spaces demarcate call-stack "levels".
 Starting at the highest level (the opposite of the way they appear in Xcode's debug window)
 
 ---- BkmxDoc action methods --------------------------------------
 
 • exportAndCloseToExporters:
 • importOnly:
 • exportOnly:
 • exportBookMacsterizer:
 
 • performForUserQuickIxportPolarity:exformat:path:extraInfo:
 • performForUserQuickIxportPolarity:menuItem:extraInfo:
 
 • performForUserQuickIxportPolarity:object:info:
 
 • doSingleIxportPolarity:overlay:ignoreLimit:alert:clientChoice:regularClient:info:
 
 • performForUserIxportPolarity:client:info:
 
 -- At this point, separate import, export.  Still in BkmxDoc -------
 
 • importPerInfo:                     • exportIfPermittedInfo:
 
 • importLaInfo:grandDoneInvocation:  • exportWithAlert:info:
 
 •                                    • exportPerInfo:
 
 */

- (void)closeDocumentInfo:(NSMutableDictionary*)info {
    [info setObject:self
             forKey:constKeyDocument] ;
    
    NSArray* selectorNames = [NSArray arrayWithObjects:
                              @"closeDocument",
                              nil] ;
    
    [[self operationQueue] queueGroup:NSStringFromSelector(_cmd)
                                addon:NO
                        selectorNames:selectorNames
                                 info:info
                                block:NO
                           doneThread:nil
                           doneTarget:nil
                         doneSelector:NULL
                         keepWithNext:NO] ;
}

#pragma mark * Status Tracking Inputs

-(void)tellVerifyStarted {
    verifyInProgress = YES ;
}

- (BOOL)verificationDone {
    return (self.shig.lastVerifyDone != nil) ;
}

- (BOOL)canVerify {
    return (![self verifyInProgress]) ;
}

@synthesize verifyInProgress ;

- (BOOL)canFixBroken {
    return [self verificationDone] ;
}

@synthesize verifySummary ;

- (void)refreshVerifySummary {
    VerifySummary* newSummary = [[VerifySummary alloc] initWithBkmxDoc:self] ;
    [self setVerifySummary:newSummary] ;
    [newSummary release] ;
}

- (void)updateVerifyResultsIfAnyAreShowing {
    if ([self.bkmxDocWinCon isShowingVerifyResults]) {
        [self showVerifyResults];
    }
}

- (void)showVerifyResults {
    if (!self.refreshVerifyTimer) {
        if (@available(macOS 10.12, *)) {
            self.refreshVerifyTimer = [NSTimer scheduledTimerWithTimeInterval:0.0
                                                                      repeats:NO
                                                                        block:^ (NSTimer* _Nonnull timer) {
                [self reallyShowVerifyResultsInProgressViewResultsWithTimer:timer] ;
            }] ;
        }
        else {
            // macOS 10.11 or earlier
            self.refreshVerifyTimer = [NSTimer scheduledTimerWithTimeInterval:0.0
                                                                       target:self
                                                                     selector:@selector(reallyShowVerifyResultsInProgressViewResultsWithTimer:)
                                                                     userInfo:nil
                                                                      repeats:NO] ;
        }
    }
}

- (void)reallyShowVerifyResultsInProgressViewResultsWithTimer:(NSTimer*)timer {
    NSAssert(timer == self.refreshVerifyTimer, @"Internal Error 624-4849") ;
    [self clearRefreshVerifyTimer] ;
    
    // Swap urls as required
    [_broker doFixAuto] ;
    
    // Calculate new results
    [self refreshVerifySummary] ;
    
    // Display
    [[self bkmxDocWinCon] showVerifyResultsInProgressView] ;
}

- (BOOL)canFixBrokenManual {
    return (
            [self verificationDone]
            &&
            ([[self verifySummary] nTotalBroken] > 0)
            ) ;
}


#pragma mark * Singular "Helper" Objects

- (BkmxDocWinCon*)bkmxDocWinCon {
    return [[self windowControllers] firstObjectSafely] ;
}

- (SSYProgressView*)progressView {
    BkmxDocWinCon* bkmxDocWinCon = [self bkmxDocWinCon] ;
    return [bkmxDocWinCon progressView] ;
}

- (Broker*)broker {
    if (!_broker) {
        _broker = [[Broker alloc] initWithDocument:self] ;
    }
    
    return _broker ;
}

- (Chaker*)chaker {
    if (!m_chaker) {
        m_chaker = [[Chaker alloc] initWithBkmxDoc:self] ;
    }
    
    return m_chaker ;
}

- (NSDateFormatter*)undoDateFormatter {
    if (!m_undoDateFormatter) {
        m_undoDateFormatter = [[NSDateFormatter alloc] init] ;
        [m_undoDateFormatter setDateStyle:NSDateFormatterNoStyle];
        [m_undoDateFormatter setTimeStyle:NSDateFormatterLongStyle];
    }
    
    return m_undoDateFormatter ;
}

#pragma mark * Saving

- (void)doHousekeepingAfterSaveNotification:(NSNotification*)note {
    if ([self shouldSkipAfterSaveHousekeeping]) {
        return ;
    }
    
    BOOL ok ;
    NSError* error = nil ;
    
    // The following is necessary if any changes in:
    //    self's uuid or self's fileURL.
    [self registerAliasForUuidInUserDefaults] ;
    
    ok = [[self starxider] save:&error] ;
    if (!ok) {
        [self alertError:error] ;
    }
    
    if ([[[note userInfo] objectForKey:BkmxDocKeyDidSucceed] boolValue]) {
        [self persistClientLastPreImportedData] ;
        [self persistClientLastPreExportedData] ;
        
        NSString* verb = [[BkmxBasis sharedBasis] labelSave] ;
        [[self progressView] showCompletionVerb:verb
                                         result:nil
                                       priority:SSYProgressPriorityLow] ;
    }
    else {
        /* Show prior completions, if any. */
        [[self progressView] showCompletionVerb:nil
                                         result:nil
                                       priority:SSYProgressPriorityLowest] ;
    }
}

- (void)saveDocumentInfo:(NSMutableDictionary*)info {
    // The following is needed by -checkBreath to get metal
    [info setObject:self
             forKey:constKeyDocument];
    
    NSMutableArray* selectorNames = [NSMutableArray new];
    
    if (![[info objectForKey:constKeyIsNewBeNice] boolValue]) {
        /* Allow new documents to be saved with no license. */
        [selectorNames addObject:@"checkBreath"];
    }
    
    [selectorNames addObject:@"saveDocument"];
    NSArray* selectorNamesCopy = [selectorNames copy];
    [selectorNames release];
    
    /*  If we are running under AppleScript then tell operationQueue to block this thread.
     If we did not do this, AppleScript would return to the scripter before
     all operations were complete. */
    [[self operationQueue] queueGroup:NSStringFromSelector(_cmd)
                                addon:NO
                        selectorNames:selectorNamesCopy
                                 info:info
                                block:NO
                           doneThread:[NSThread mainThread]
                           doneTarget:self
                         doneSelector:@selector(finishGroupOfOperationsWithInfo:)
                         keepWithNext:NO] ;
    [selectorNamesCopy release];
}

/*!
 @brief    Returns whether or not a current Save Operation should be
 preceded by an automatic Export
 
 @param    saveAs  YES if the current operation is a Save As operation,
 otherwise NO
 */
- (BOOL)shouldExportBeforeSaveOpType:(NSSaveOperationType)saveOperation {
    if (
        ([[[self macster] autoExport] boolValue])
        &&
        // Do not Auto Export if the operation was initiated by a Syncer or script.
        // This is because 'Export' is a separate script or BkmxAgent command.
        ([self currentPerformanceType] == BkmxPerformanceTypeUser)
        &&
        ![self skipAutomaticActions]
        &&
        (saveOperation == NSSaveOperation) // Not for Save As or Auto Save operations
        ) {
            for (Exporter* exporter in [[self macster] activeExportersOrdered]) {
                NSNumber* oldHashObject = [self lastPreExportedHashForClient:[exporter client]] ;
                
                if (oldHashObject) {
                    unsigned long long oldHash = [oldHashObject unsignedLongLongValue] & BkmxExportHashBitMaskBkmxDocStuff ;
                    unsigned long long newHash = [[exporter client] exportHashFromBkmxDoc:self] & BkmxExportHashBitMaskBkmxDocStuff ;
                    // We use BkmxExportHashBitMaskBkmxDocStuff because, in this case, we
                    // have not read the extore contents.  Our decision is based only on
                    // the BkmxDoc content and exporter settings.
                    if (oldHash != newHash) {
                        // BkmxDoc content or exporter settings have changed
                        return YES ;
                    }
                }
                else {
                    // No prior data, assume worst case, better export
                    return YES ;
                }
            }
        }
    
    // No changes found in any active exporter ▸ No need to export
    return NO ;
}

- (SSYAlert*)askAutoExportAlert {
    SSYAlert* alert = [SSYAlert alert] ;
    NSString* msg = [NSString stringWithFormat:
                     @"%@ %@",
                     [NSString localizeFormat:
                      @"switchedOnX2",
                      [NSString localize:@"imex_autoExport"],
                      [[NSDocumentController sharedDocumentController] defaultDocumentDisplayName]],
                     [NSString localizeFormat:
                      @"imex_exportNowX2",
                      [NSString localize:@"000_Safari_Bookmarks"],
                      [[self macster] readableExportsListOnlyIfVulnerable:NO
                                                            maxCharacters:512]]] ;
    [alert setSmallText:msg] ;
    [alert setButton1Title:[[BkmxBasis sharedBasis] labelExportAndSave]] ;
    [alert setButton2Title:[[BkmxBasis sharedBasis] labelCancel]] ;
    [alert setButton3Title:[[BkmxBasis sharedBasis] labelSaveOnly]] ;
    [alert setCheckboxTitle:[NSString localizeFormat:
                             @"switchOffX",
                             [NSString localize:@"imex_autoExport"]]] ;
    [alert setHelpAddress:constHelpAnchorAutoExport] ;
    
    return alert ;
}

- (void)askAutoExportThenSaveOpType:(NSSaveOperationType)saveOperation {
    SSYAlert* alert = [self askAutoExportAlert] ;
    
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithInteger:saveOperation], constKeySaveOperation,
                          nil] ;
    [info retain] ; // Must be released by didEndSelector
    [self runModalSheetAlert:alert
                  resizeable:NO
                   iconStyle:SSYAlertIconCritical
               modalDelegate:self
              didEndSelector:@selector(exportBeforeSaveSheetDidEnd:returnCode:contextInfo:)
                 contextInfo:info] ;
}

- (void)saveAndClose {
    // Added in BookMacster 1.19.2
    // For some reason, this is not necessary in BookMacster.  Auto Save
    // "just works" when app is terminated.  Hence the checking of -iAm…
    if (
        ([[self class] autosavesInPlace])
        && ([[BkmxBasis sharedBasis] iAm] != BkmxWhich1AppBookMacster)
        ) {
            [[self managedObjectContext] processPendingChanges] ;
            /*
             Frighteningly, -saveDocument: does not quite work here if
             starks were *moved*.  The last moved stark becomes orphaned!
             Using -[NSManagedObjectContext save:] seems to work.
             */
            NSError* error = nil ;
            [[self managedObjectContext] save:&error] ;
            if (error) {
                NSLog(@"Internal Error 531-2908 %@", error) ;
            }
        }
    
    [self closeDocumentInfo:[NSMutableDictionary dictionary]] ;
}

- (void)closeAfterAskAutoExport:(BOOL)autoExport {
    if (autoExport) {
        SSYAlert* alert = [self askAutoExportAlert] ;
        
        NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithBool:YES], constKeyCloseWhenDone,
                              nil] ;
        [info retain] ; // Must be released by didEndSelector
        [self runModalSheetAlert:alert
                      resizeable:NO
                       iconStyle:SSYAlertIconCritical
                   modalDelegate:self
                  didEndSelector:@selector(exportBeforeSaveSheetDidEnd:returnCode:contextInfo:)
                     contextInfo:info] ;
    }
    else {
        [self saveAndClose] ;
    }
}

// Added in BookMacster 1.20.2
- (void)closeAfterAskExportClients:(NSArray*)clients {
    SSYAlert* alert = [SSYAlert alert] ;
    NSString* msg = [NSString stringWithFormat:
                     @"You have made changes to this document which have not been exported to %@.  "
                     @"To keep these browsers in sync, you should Export before closing.",
                     [clients listValuesForKey:@"displayName"
                                   conjunction:[[BkmxBasis sharedBasis] labelAndEndList]
                                    truncateTo:10]] ;
    [alert setSmallText:msg] ;
    [alert setButton1Title:[[BkmxBasis sharedBasis] labelExport]] ;
    [alert setButton2Title:[[BkmxBasis sharedBasis] labelCancel]] ;
    [alert setButton3Title:[[BkmxBasis sharedBasis] labelClose]] ;
    
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
                          clients, constKeyClients,
                          nil] ;
    [info retain] ; // Must be released by didEndSelector
    [self runModalSheetAlert:alert
                  resizeable:NO
                   iconStyle:SSYAlertIconCritical
               modalDelegate:self
              didEndSelector:@selector(exportBeforeCloseSheetDidEnd:returnCode:clients:)
                 contextInfo:info] ;
}

- (void)exportBeforeCloseSheetDidEnd:(SSYAlertWindow*)sheet
                          returnCode:(NSInteger)returnCode
                             clients:(NSArray*)clients {
    // cancel=0=Alternate  export=-1=Other  close=+1=Default
    switch (returnCode) {
        case NSAlertFirstButtonReturn:;
            // Export
            NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         // Since we've definitely got the GUI here, deference is ask
                                         [NSNumber numberWithInteger:BkmxDeferenceAsk], constKeyDeference,
                                         [NSNumber numberWithInteger:BkmxPerformanceTypeUser], constKeyPerformanceType,
                                         [NSNumber numberWithBool:YES], constKeyIfNotNeeded,
                                         [NSNumber numberWithBool:YES], constKeyDidMirror,
                                         nil] ;
            [self exportPerInfo:info] ;
            break ;
        case NSAlertSecondButtonReturn:
            // Cancel
            return ;
        case NSAlertThirdButtonReturn:;
            // Close
            [self saveAndClose] ;
        default:
            break ;
    }
    
    [clients release] ;
}

- (void)doWarnCantSyncNoClients {
    SSYAlert* alert = [SSYAlert alert] ;
    NSString* msg = [NSString stringWithFormat:
                     @"Syncing cannot start because there are no active %@ to sync.\n\n"
                     @"You may add %@ in %@ > %@.",
                     [[BkmxBasis sharedBasis] labelClients],
                     [[BkmxBasis sharedBasis] labelClients],
                     [[BkmxBasis sharedBasis] labelSettings],
                     [[BkmxBasis sharedBasis] labelClients]] ;
    [alert setSmallText:msg] ;
    [alert doooLayout] ;
    [self runModalSheetAlert:alert
                  resizeable:NO
                   iconStyle:SSYAlertIconInformational
               modalDelegate:nil
              didEndSelector:NULL
                 contextInfo:NULL] ;
    [self setWarnCantSyncNoClientsScheduled:NO] ;
}

- (void)warnCantSyncNoClients {
    if (![self warnCantSyncNoClientsScheduled]) {
        [self performSelector:@selector(doWarnCantSyncNoClients)
                   withObject:nil
                   afterDelay:0.0] ;
        [self setWarnCantSyncNoClientsScheduled:YES] ;
    }
}


- (void)askAgentResumeThenCloseWithAutoExport:(BOOL)autoExport {
    SSYAlert* alert = [SSYAlert alert] ;
    NSString* closeOrQuitTitle ;
    switch ([[BkmxBasis sharedBasis] iAm]) {
        case BkmxWhich1AppBookMacster:
            closeOrQuitTitle = [[BkmxBasis sharedBasis] labelClose] ;
            break ;
        default:
            closeOrQuitTitle = [[BkmxBasis sharedBasis] labelCloseAndQuit] ;
            break ;
    }
    NSString* msg = [NSString stringWithFormat:
                     @"Do you want to resume syncing %@ before closing?\n\n"
                     @"If not, click '%@'.",
                     [[[self macster] clientsWithIxportBothActive] listValuesForKey:@"displayName"
                                                                        conjunction:[NSString localize:@"andEndList"]
                                                                         truncateTo:0],
                     closeOrQuitTitle] ;
    [alert setSmallText:msg] ;
    [alert setButton1Title:@"Resume Syncing"] ;
    [alert setButton2Title:[[BkmxBasis sharedBasis] labelCancel]] ;
    [alert setButton3Title:closeOrQuitTitle] ;
    NSArray* doneInvocations = [NSArray arrayWithObjects:
                                // "Resume Syncing"
                                [NSInvocation invocationWithTarget:[self macster]
                                                          selector:@selector(resumeSyncers)
                                                   retainArguments:YES
                                                 argumentAddresses:NULL],
                                // Above, when agents are resumed, this will ask the user
                                // to export and if user approves do so, via
                                // -[Macster macsterTouchNote:], then
                                // -[BkmxDoc exportIfPermittedInfo:], then
                                // -[BkmxDoc exportWithAlert:info:]
                                // "Cancel":
                                [NSNull null],
                                // "Close":
                                [NSInvocation invocationWithTarget:self
                                                          selector:@selector(closeAfterAskAutoExport:)
                                                   retainArguments:NO
                                                 argumentAddresses:&autoExport],
                                nil] ;
    [self runModalSheetAlert:alert
                  resizeable:NO
                   iconStyle:SSYAlertIconInformational
               modalDelegate:[SSYSheetEnder class]
              didEndSelector:@selector(didEndGenericSheet:returnCode:retainedInvocations:)
                 contextInfo:[doneInvocations retain]] ;
}

- (NSArray*)staleExportClients {
    NSMutableArray* staleExportClients = [[NSMutableArray alloc] init] ;
    if (![[[self macster] autoExport] boolValue]) {
        for (Syncer* syncer in [[self macster] syncersOrdered]) {
            if ([syncer isActive]) {
                for (Command* command in [syncer commands]) {
                    if ([Command doesExportMethodName:[command method]]) {
                        NSDate* lastTouched = [[self shig] lastTouched] ;
                        for (Exporter* exporter in [[self macster] activeExportersOrdered]) {
                            Client* client = [exporter client] ;
                            NSDate* dateLastExported = [[NSUserDefaults standardUserDefaults] lastChangeWrittenDateToClientoid:client.clientoid] ;
                            if ([lastTouched timeIntervalSinceReferenceDate] > [dateLastExported timeIntervalSinceReferenceDate]) {
                                [staleExportClients addObject:client] ;
                            }
                        }
                    }
                }
            }
        }
    }
    
    NSArray* answer = [[staleExportClients copy] autorelease] ;
    [staleExportClients release] ;
    return [answer arrayByRemovingEqualObjects] ;
}

- (BOOL)prepareToClose {
    BOOL weWillHandleClosing;
    BOOL ixportIsInProgress = (self.operationQueue.operations.count > 0) ;
    
    if (ixportIsInProgress) {
        weWillHandleClosing = NO ;
    }
    else {
        [self setCurrentPerformanceType:BkmxPerformanceTypeUser] ;
        
        NSArray* staleExportClients = [self staleExportClients] ;
        BOOL staleExport = ([staleExportClients count] > 0) ;
        BOOL autoExport = [self shouldExportBeforeSaveOpType:NSSaveOperation] ;
        BOOL syncPaused = ([[self macster] syncerPausedConfig] != constBkmxSyncerConfigNone) ;
        
        if (syncPaused && ![(BkmxAppDel*)[NSApp delegate] isBackgrounding]) {
            // Case 2 or 3
            [self askAgentResumeThenCloseWithAutoExport:autoExport] ;
            weWillHandleClosing = YES ;
        }
        else if (autoExport) {
            // Case 1
            [self closeAfterAskAutoExport:YES] ;
            weWillHandleClosing = YES ;
        }
        else if (staleExport) {
            [self closeAfterAskExportClients:staleExportClients] ;
            weWillHandleClosing = YES ;
        }
        else {
            // Case 0
            weWillHandleClosing = NO ;
        }
    }
    
    return weWillHandleClosing ;
}

- (void)saveDocumentOpType:(NSSaveOperationType)saveOperation {
    // Note that this method is bypassed during an Auto Save, because
    // -autosaveWithCancellability skips this method and others,
    // and goes right into saveToURL:::completionHandler:
    
    // Execute autoExport, if all conditions correct
    if ([self shouldExportBeforeSaveOpType:saveOperation]) {
        [self askAutoExportThenSaveOpType:saveOperation] ;
    }
    else {
        // Only save, do not export
        NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInteger:saveOperation], constKeySaveOperation,
                                     nil] ;
        [self saveDocumentInfo:info] ;
    }
}

- (void)exportBeforeSaveSheetDidEnd:(SSYAlertWindow*)sheet
                         returnCode:(NSInteger)returnCode
                        contextInfo:(NSDictionary*)contextInfo {
    NSNumber* saveOperation = [contextInfo objectForKey:constKeySaveOperation] ;
    BOOL closeWhenDone = [[contextInfo objectForKey:constKeyCloseWhenDone] boolValue] ;
    [contextInfo release] ;
    
    // This section was moved up from out of the switch() to here in BookMacster 1.9.9
    // so that the checkbox would work when the "Cancel" button was clicked.
    if ([sheet checkboxState] == NSControlStateValueOn) {
        [self revealTabViewIdentifier:constIdentifierTabViewOpenSave] ;
        sleep(1) ;
        [[self macster] setAutoExport:[NSNumber numberWithBool:NO]] ;
        [self saveMacster] ;  // Added as bug fix in BookMacster 1.11.
        [[self bkmxDocWinCon] updateWindowForStark:nil] ;
        [[[self bkmxDocWinCon] window] display] ;
        [[NSSound soundNamed:@"Pop"] play];
    }
    
    switch (returnCode) {
        case NSAlertSecondButtonReturn:
            // Cancel
            break ;
        case NSAlertFirstButtonReturn:;
            // Export and Save
            NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         // Since we've definitely got the GUI here, deference is ask
                                         [NSNumber numberWithInteger:BkmxDeferenceAsk], constKeyDeference,
                                         [NSNumber numberWithInteger:BkmxPerformanceTypeUser], constKeyPerformanceType,
                                         [NSNumber numberWithBool:YES], constKeyIfNotNeeded,
                                         [NSNumber numberWithBool:YES], constKeyDidMirror,
                                         nil] ;
            [self exportPerInfo:info] ;
            // no break here since we also need to maybe save and maybe close
            
        case NSAlertThirdButtonReturn:;
            // Save only
            if (saveOperation) {
                NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             saveOperation, constKeySaveOperation,
                                             nil] ;
                
                [self saveDocumentInfo:info] ;
            }
            else {
                // We were invoked by -close to maybe export only, but not save.
            }
            
            if (closeWhenDone) {
                [self closeDocumentInfo:[NSMutableDictionary dictionary]] ;
            }
            
        default:
            break ;
    }
}

- (void)saveDocumentActionPart2OpType:(NSSaveOperationType)saveOperation {
    // Thread it off
    [self saveDocumentOpType:saveOperation] ;
}

// Note that this method is not the action method.  There is no colon at end.
// It is invoked by BkmxAgent, -landNewBookmarkSaveWithInfo:,
// and -[InspectorController windowWillClose].
- (void)saveDocument {
    [self saveDocumentOpType:NSSaveOperation] ;
}

- (BOOL)revertError_p:(NSError**)error_p {
    NSError* error = nil ;
    NSString* utiType = [[BkmxDocumentController sharedDocumentController] defaultDocumentUTI] ;
    BOOL ok = [self revertToContentsOfURL:[self fileURL]
                                   ofType:utiType
                                    error:&error] ;
    // I don't know why this method requires ofType, since that is included in
    // the file URL.  My implementation of revertToContentsOfURL::: ignores
    // the ofType parameter.
    
    if (!ok && error_p) {
        *error_p = error ;
    }
    
    return ok ;
}

- (SSYVersionTriplet*)requiresVersion {
    return [SSYVersionTriplet versionTripletWithMajor:3
                                                minor:0
                                               bugFix:0] ;
}

- (NSInteger)finalizeStarksLastModifiedDates {
    /*  We need to protect -[Starker finalizeStarksLastModifiedDates] with two
     methods before and after, as shown.  If we don't then if dates are changed,
     Core Data invokes -[GCUndoManager conditionallyBeginUndoGrouping]
     which does a delayed performance of -endUndoGrouping which happens
     *after* the document has been saved and the change count cleared,
     invoking -prepareWithInvocationTarget:, which sends a
     notification which causes Cocoa to send us us an
     -updateChangeCount:NSChangeDone, which makes -isDocumentEdited
     return YES when the window is updated, which causes the dirty dot
     to remain dirty.  And, yes, the -processPendingChanges are
     necessary too.  Without them, the dirty dot is still dirty. */
    [[self managedObjectContext] processPendingChanges] ;
    [[[self managedObjectContext] undoManager] disableUndoRegistration] ;
    NSInteger nUpdatedStarks = [[self starker] finalizeStarksLastModifiedDates] ;
    [[self managedObjectContext] processPendingChanges] ;
    [[[self managedObjectContext] undoManager] enableUndoRegistration] ;
    
    return nUpdatedStarks ;
}

- (void)writeBasicAuxiliaryData {
    NSArray* metal = nil ;
    SSYLicenseLevel currentLevel = SSYLCCurrentLevel() ;
    if (currentLevel >= SSYLicenseLevelRegular) {
        // App has Regular License.  Write it to document's metadata, if same
        // info is not already there.
        // This is done so that people using BookMacster to sync bookmarks among
        // multiple Macs will not need to enter License Information on each one.
        
        SSYLCLicenseInfo appLicenseInfo = SSYLCCurrentLicenseInfo() ;
        SSYLCLicenseInfo docLicenseInfo = [self metalInfo] ;
        
        if (
            ![appLicenseInfo.licenseeName isEqual:docLicenseInfo.licenseeName]
            ||
            ![appLicenseInfo.licenseKey isEqual:docLicenseInfo.licenseKey]
            ) {
                NSString* licenseeName = appLicenseInfo.licenseeName ;
                NSString* licenseKey = appLicenseInfo.licenseKey ;
                metal = [NSArray arrayWithObjects:
                         licenseeName,
                         licenseKey,
                         nil] ;
            }
    }
    
    NSString* requiresVersionString = [[self requiresVersion] string] ;
    NSDictionary* moreMetadata = [NSDictionary dictionaryWithObjectsAndKeys:
                                  requiresVersionString, constKeyRequiresVersion,
                                  [[SSYAppInfo currentVersionTriplet] string], constKeySavedWithVersion,
                                  metal, constKeyMetal, // may be nil
                                  nil] ;
    [self addAuxiliaryKeyValues:moreMetadata];
}

- (BOOL)finalizeStarksLastModifiedDatesAndReturnIfNeededSaveOperationType:(NSSaveOperationType)saveOperation {
    NSManagedObjectContext* managedObjectContext = [self managedObjectContext];
    NSInteger nUpdatedStarks = [self finalizeStarksLastModifiedDates] ;
    BOOL needsSave;
    
    /* We should skip saving if this is not a Save As operation, and if the
     document has no changes.  We use -[NSManagedObjectContext hasChanges]
     instead of [self isDocumentEdited], because the latter always returns NO
     in BkmxAgent because BkmxAgent has a nil undo manager, and NSDocument
     relies on notifications from the undo manager to maintain
     -isDocumentEdited. */
    if ((saveOperation != NSSaveAsOperation) && ![managedObjectContext hasChanges]) {
        [[BkmxBasis sharedBasis] logFormat:
         @"No changes in %@ \u279E Skip saving",
         [self displayName]] ;
        
        needsSave = NO;
    } else {
        [[BkmxBasis sharedBasis] logFormat:
         @"Will save changes in BkmxDoc:   +%d   (%@%@%@)%d   -%d",
         [[managedObjectContext insertedObjects] count],
         [SSYModelChangeTypes symbolForAction:SSYModelChangeActionModify],
         [SSYModelChangeTypes symbolForAction:SSYModelChangeActionMove],
         [SSYModelChangeTypes symbolForAction:SSYModelChangeActionSlide],
         // Test result shows that -[managedObjectContext updatedObjects] is smart enough
         // to return only those objects whose current values differ from their saved/commited
         // values at this time.  That is, if an object had a value changed, but then changed
         // back, it will not be included in -updatedObjects.  Therefore, we could use
         // -[updatedObjects], but this still has two drawbacks.  First, it counts updates of
         // only trivial attributes for which setLastModifiedDate was not changed.  Second,
         // it includes Bookshig and possibly other non-Stark objects.  It would be extra
         // expense to filter out these undesirables.  So, instead of -updatedObjects,
         // we use nUpdatedStarks from -finalizeStarksLastModifiedDates.
         nUpdatedStarks,
         [[managedObjectContext deletedObjects] count]] ;
        
        needsSave = YES;
    }
    
    return needsSave;
}

- (void)doHousekeepingBeforeSave {
    // Needed in case tags were just entered
    [self endEditing:nil];
    NSObject* appDelegate = [NSApp delegate];
    if ([appDelegate respondsToSelector:@selector(endEditingForInspector)]) {
        [(BkmxAppDel*)[NSApp delegate] endEditingForInspector];
    }
    
    [self writeBasicAuxiliaryData] ;
}

- (void)saveDocumentFinalOpType:(NSSaveOperationType)saveOperation {
    // BkmxAgent could be here even if document was not edited
    
    [self doHousekeepingBeforeSave] ;
    
    // Until BookMacster 1.11, the following was done if (![[BkmxBasis sharedBasis] isBkmxAgent]), with the
    // else as shown below.  Following the code, I determined that, besides
    // skipping alot of stuff that didn't really matter, there were two
    // things being skipped that did/might really matter…
    // • -persistClientLastPreImportedData and -persistClientLastPreExportedData
    //   were being skipped, because -doHousekeepingAfterSaveNotification:
    //   was skipped
    // • -blindAllCloudTriggers (after I fixed its invocation) was being
    //   skipped, because writeSafelyToURL:ofType:forSaveOperation:error:
    //   was being skipped.
    // • Fewer future bugs.  The above two were introduced because I thought
    //   that those methods were always running, when in fact they were
    //   only running if (![[BkmxBasis sharedBasis] isBkmxAgent]).  Now they are always running!
    // I just hope I don't introduce any damned autosave hangs by doing this!
    //    if (![[BkmxBasis sharedBasis] isBkmxAgent])    {
    BOOL needsSave = [self finalizeStarksLastModifiedDatesAndReturnIfNeededSaveOperationType:saveOperation];
    if (needsSave) {
        switch (saveOperation) {
            case NSSaveOperation:
                [super saveDocument:self];
                /* The above method returns immediately, even if we override
                 canAsynchronouslyWriteToURL::: to return NO.  See:
                 http://lists.apple.com/archives/cocoa-dev/2011/Aug/msg00855.html */
                break ;
            case NSSaveAsOperation:
                [super saveDocumentAs:self] ;
                break ;
            default:
                NSLog(@"Internal Error 503-2368") ;
        }
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:constNoteBkmxDidFinishSaving
                                                            object:self];
    }
}

- (void)prepareForSaveOperation:(NSSaveOperationType)saveOperation {
    [[NSNotificationCenter defaultCenter] postNotificationName:SSYUndoManagerDocumentWillSaveNotification
                                                        object:self] ;
    
    // Added in BookMacster version 1.3.19
    if (saveOperation == NSSaveAsOperation) {
        // Configure with new parts
        if (!self.uuid) {
            [self setFreshUuid] ;
            NSLog(@"Warning 624-8867 %@", self);
        }
        [self linkToMacster] ;
        [[self bkmxDocWinCon] autosaveAllCurrentValues] ;  // with the fresh uuid
        
        /* Prior to 2017-06-19, there were calls in this method, sent to self,
         to clean up auxiliary mocs, starlobuter, talder mapper, and exids.
         Those were ridiculous because, in a Save As operation, self is in fact
         the *new* document, not the old one.  The "Configure with new parts"
         section above makes sense in this regard.  Also, with the new
         Conventional Document Saving, the new document already may have exids
         at this point from the initial import, and these would be wiped out.
         So, to fix that problem and eliminate the noops, I deleted all of that
         code from here. */
    }
}

- (void)performActivityWithSynchronousWaiting:(BOOL)waitSynchronously
                                   usingBlock:(void (^)(void (^activityCompletionHandler)(void)))inBlock {
    // Starting in BookMacster 1.16, this is hard coded on.
    waitSynchronously = NO ;
    
#if LOGGING_AUTOSAVE_IN_PLACE
    NSString* marker = [[SSYUuid compactUuid] substringToIndex:4];
    NSLog(@">> %s %ld %@ by %@", __PRETTY_FUNCTION__, (long)waitSynchronously, marker, SSYDebugCaller()) ;
    [super performActivityWithSynchronousWaiting:waitSynchronously
                                      usingBlock:block] ;
    NSLog(@"<< %s %@ by %@", __PRETTY_FUNCTION__, marker, SSYDebugCaller()) ;
#else
    [super performActivityWithSynchronousWaiting:waitSynchronously
                                      usingBlock:inBlock] ;
#endif
}

- (BOOL)prepareSavePanel:(NSSavePanel*)savePanel {
    /*
     If this is a shoebox app, I want to
     •  (a) *never* present a Save panel and
     •  (b) always save to the fixed, known shoebox path
     Requirement (b) will be fulfilled if I set the document's fileURL to the
     fixed, known shoebox path.  But if I do that too early, like before the
     first save, I get Error 67000 in NSCocoaErrorDomain when the first
     save occurs, be it a Auto Save or whatever.  And if I do it too late, then
     this method will run and attempt to present a Save sheet.  And since
     saving is somewhat asynchronous nowadays, even if you don't enable
     asynchronous saving, there is no safe place to avoid both.  After a day of
     experimenting, I decided that the most reliable and least hacky way to
     solve this problem is to *not* setFileURL: but instead, let this method
     run, and when it does, moveToURL::, which makes Cocoa setFileURL, and then
     return NO.  When I return NO, the proposed Save panel does not appear, but
     the Save still occurs, which is exactly what I want.  I wish this was
     documented behavior, but I think it is the safest solution.
     
     If this is a non-shoebox app, there is no hack.  I set the default
     directory and filename to desired values, which is a completely legitimate
     use of this method, and return YES, and the Save panel runs.
     */
    if ([[BkmxBasis sharedBasis] isShoeboxApp]) {
        NSError* error = nil;
        NSString* path = [[NSDocumentController sharedDocumentController] shoeboxDocumentPathError_p:&error] ;
        if (!path) {
            NSLog(@"Internal Error 523-4482 %@", self);
        }
        NSURL* url = [NSURL fileURLWithPath:path] ;
        
        [self setShouldSkipAfterSaveHousekeeping:YES] ;
        
        /* If fileURL of bkmxDoc is already identical to url, which is the normal
         case on second and subsequent application runs, the following method
         will simply run its completion handler, which will ensure auto agents. */
        [self      moveToURL:url
           completionHandler:^(NSError *moveError) {
            [self setShouldSkipAfterSaveHousekeeping:NO] ;
            if (moveError) {
                NSString* msg = [NSString stringWithFormat:
                                 @"Could not move new document to shoebox path %@",
                                 path] ;
                moveError = [SSYMakeError(648483, msg) errorByAddingUnderlyingError:error] ;
                
                if (!self) {
                    [SSYAlert alertError:moveError] ;
                }
            }
        }];
        return NO;
    }
    else {
        NSString* suggestedName = [[NSDocumentController sharedDocumentController] nextDefaultFilenameError_p:NULL] ;
        suggestedName = [suggestedName stringByAppendingPathExtension:[[NSDocumentController sharedDocumentController] defaultDocumentFilenameExtension]] ;
        
        /* Set default folder to BookMacster default, unless the user has
         previously saved to a different folder, which will be indicated by
         the user defaults' NSNavLastRootDirectory. */
        NSString* lastDirectory = [[NSUserDefaults standardUserDefaults] objectForKey:@"NSNavLastRootDirectory"];
        
        if (lastDirectory == nil) {
            NSString* suggestedFolder = [[NSDocumentController sharedDocumentController] defaultDocumentFolderError_p:NULL] ;
            if (suggestedFolder) {
                suggestedName = [suggestedName uniqueFilenameInDirectory:suggestedFolder
                                                               maxLength:34
                                                              truncateOk:NO];
                NSURL* url = [NSURL fileURLWithPath:suggestedFolder];
                [savePanel setDirectoryURL:url];
            }
        }
        
        if (suggestedName) {
            [savePanel setNameFieldStringValue:suggestedName];
        }
        
        return YES;
    }
}

/*!
 @brief    Override of new asynchronous saving method invoked by Cocoa
 when running in macOS 10.7 or later.
 
 @details  Note that when user clicks File > Duplicate, a new document is
 created.  This message is sent to the *new* document (not the old one), later,
 when user either types a new filename into the window title bar, or when
 clicking Save, and the Save sheet shows, and user completes the sheet
 and clicks "Save" or "Replace".
 */
- (void)saveToURL:(NSURL *)url
           ofType:(NSString *)typeName
 forSaveOperation:(NSSaveOperationType)saveOperation
completionHandler:(void (^)(NSError *errorOrNil))completionHandler {    
    
    [self prepareForSaveOperation:saveOperation] ;
    
    void (^wrappedCompletionHandler)(NSError*) = ^void (NSError* errorOrNil) {
        completionHandler(errorOrNil);
        [[NSNotificationCenter defaultCenter] postNotificationName:constNoteBkmxDidFinishSaving
                                                            object:self];
    };
    
    /* One time I got this assertion from BSManagedDocument…
     "Can't begin save; another is already in progress. Perhaps you forgot to
     wrap the call inside of -performActivityWithSynchronousWaiting:usingBlock:"
     So I tried wrapping the following call like that, but got deadlocks. */
    [super       saveToURL:url
                    ofType:typeName
          forSaveOperation:saveOperation
         completionHandler:wrappedCompletionHandler] ;
}

#if 0
#warning Autosave In Place is OFF
#else
+ (BOOL)autosavesInPlace {
    BOOL answer = ![[NSUserDefaults standardUserDefaults] boolForKey:SSYDontAutosaveKey];
    
    /* We return YES for both main app and BkmxAgent.  Of course, BkmxAgent does not
     need Auto Save  But we do want Versions to work for BkmxAgent, and
     NSDocument does not provide Versions without Auto Save.  In other words,
     if we returned NO here when in BkmxAgent, saves by BkmxAgent would not show in
     File > Revert to > Browse All Versions….  (Fixed in BkmkMgrs 2.8.5.)
     
     With this fix, I find that Versions is now *too* aggressive.  If you
     switch on syncing, close the document and cause several syncs to occur
     by changing bookmarks in browsers several minutes apart, you'l find that
     there are *two* versions with each change in Versions Browser:  One
     when the change was imported, and another when the document was next
     *opened* to perform the *next* sync.  I don't know what is causeing this
     second, undesired duplicate version because, I see from adding log
     statements that
     (a) -autosaveWithImplicitCancellability:completionHandler: seems to be
     never called during Worker, and
     (b) -saveDocumentFinalOpType: is only called once during each sync.
     Maybe someday I shall find the answer, or maybe it is buried in the
     mystery of NSDocument's Auto Save and Versions code. */
    
#if 0
    /* macOS 13 New Shoebox Hang, Alternative Fix #2 of 2, NOT USED (see #if 0)
     Not used because Alternative Fix #1 of 1 is, I feel, less of a hack. */
    if (answer) {
        BkmxDoc* doc1 = [[[NSDocumentController sharedDocumentController] documents] firstObject];
        answer = doc1.fileURL != nil;
    }
#else
    return answer ;
#endif
}
#endif

/*!
 @details  Before enabling asynchronous saving, if I edited a document, held down the ⌘ key
 and hit S rapidly three times, I would get the now-familiar hang in
 -[NSDocument performActivityWithSynchronousWaiting:usingBlock:] during the second
 -saveDocument:.  If I did the same thing in macOS 10.6, there is no problem because the
 user interface blocks when the first save begins, then sets isDocumentEdited to NO, so that
 my second and third Save commands branch to NSBeep instead.
 */

- (BOOL)canAsynchronouslyWriteToURL:(NSURL *)url
                             ofType:(NSString *)typeName
                   forSaveOperation:(NSSaveOperationType)saveOperation {
    /* Asynchronous saving is incompatible with NSPersistentDocument.
     See Apple Bug 10256418, Sept 2011, also, as of 20170622,
     https://developer.apple.com/documentation/appkit/nspersistentdocument >> "Important".
     
     Supposedly, it is OK with BSManagedDocument.  On 20190917, for
     BkmkMgrs 2.9.15, I switched it on.
     */
    
    return [super canAsynchronouslyWriteToURL:url
                                       ofType:typeName
                             forSaveOperation:saveOperation];
    /* super (BSManagedDocument) will return YES. */
}

#if 0
#warning Logging Auto Save In Place
#define LOGGING_AUTOSAVE_IN_PLACE 1
#endif

- (void)performSynchronousFileAccessUsingBlock:(__attribute__((noescape)) void (^)(void))block {
    /* macOS 13 New Shoebox Hang, Alternative Fix #1 of 2.
     
     The problem I found in macOS 13 is that, when running a shoebox app,
     if the document file, for example Markster.bmco, was removed while
     the app was not running, and then the app was launched, after
     presenting the error indicating that a new document would be created,
     and then after creating the document, there would be a deadlock in
     file coordination which presented a forever beachball on the main
     thread.  My guess is that some guy is trying to access the new file
     while some other guy is trying to  create it.  My logical solution
     here is to abort the access.  It worked.  For another solution that
     worked, search for Alternative Fix #2 of 2. */
    if (self.fileURL != nil) {
        [super performSynchronousFileAccessUsingBlock:block] ;
    } else {
        [[BkmxBasis sharedBasis] logString:@"Aborting file access cuz doc does not exist yet."];
    }
}

#if 0
- (void)performAsynchronousFileAccessUsingBlock:(void (^)(void (^fileAccessCompletionHandler)(void)))block {
    NSString* marker = [[SSYUuid compactUuid] substringToIndex:4];
    NSLog(@">> %s %@ by %@", __PRETTY_FUNCTION__, marker, SSYDebugCaller()) ;
    [super performAsynchronousFileAccessUsingBlock:block] ;
    NSLog(@"<< %s %@ by %@", __PRETTY_FUNCTION__, marker, SSYDebugCaller()) ;
}
#endif

/*!
 @brief    Real autosaving method, buffered by SSYOperationQueue, invoked
 when the autosave operation is dequeued.
 */
- (void)reallyAutosaveWithCompletionHandler:(void (^)(NSError *errorOrNil))completionHandler {
#if LOGGING_AUTOSAVE_IN_PLACE
    NSLog(@">> %s", __PRETTY_FUNCTION__) ;
#endif
    [self doHousekeepingBeforeSave] ;
    
    BOOL needsSave = [self finalizeStarksLastModifiedDatesAndReturnIfNeededSaveOperationType:NSSaveOperation];
    if (needsSave) {
        [super autosaveWithImplicitCancellability:NO
                                completionHandler:completionHandler];
    } else {
        if (completionHandler) {
            completionHandler(nil);
        }
    }
    
    Block_release(completionHandler) ;
#if LOGGING_AUTOSAVE_IN_PLACE
    NSLog(@"<< %s", __PRETTY_FUNCTION__) ;
#endif
}

/*!
 @brief    Override of new autosave method invoked by Cocoa
 when running in macOS 10.7 or later.
 
 @details  Warning: Since we're using the 10.6 SDK, the super method,
 which will be invoked when the operation group added by this method
 is dequeued, is declared in an class extension.  Do not invoke this
 method without testing that you're running under macOS 10.7 or later.
 
 * Case  maenQueue  Cancellable?  Action
 * ----  ---------  ------------  --------------------
 *   1   not busy        X        Add to (empty) queue
 *   2     busy        Yes        Cancel the Save
 *   3     busy         No        Add to (busy) queue
 */
- (void)autosaveWithImplicitCancellability:(BOOL)autosavingIsImplicitlyCancellable
                         completionHandler:(void (^)(NSError *errorOrNil))completionHandler {
#if LOGGING_AUTOSAVE_IN_PLACE
    NSLog(@">> %s  hasCh=%ld  isDocEd=%ld  isCnclbl=%ld  inh=%hhd", __PRETTY_FUNCTION__, (long)[[self managedObjectContext] hasChanges], (long)[self isDocumentEdited], (long)autosavingIsImplicitlyCancellable, [self autoSaveInhibited]) ;
#endif
    
#if 0
#warning Cancelling even non-cancellable autosaves
    if (!autosavingIsImplicitlyCancellable) {
        autosavingIsImplicitlyCancellable = YES ;
        NSLog(@"Warning 092-3804 Cancelling noncancellable autosave") ;
    }
#endif
    
    if (autosavingIsImplicitlyCancellable) {
        if (
            ([[[self operationQueue] operations] count] != 0)
#if 0
#warning Saving even if no changes
#else
            ||
            
            // The following was added in BookMacster 1.7/1.6.8.
            // It is number 2 of 2 fixes to stop Dropbox pingponging.
            
            /* Note 20131215.  Would it be better to test
             [[self managedObjectContext] hasChanges] instead of
             -isDocumentEdited, as I do elsewhere?  Or, even more
             importantly, what if the document has not changed internally
             since the last save, but the document on disk has changed?
             Thought experiment:
             • Syncing via Dropbox.
             • Bookmarks changed on Mac A.
             • Bookmarks changed on Mac B.
             • Dropbox copies from A to B
             • Autosave triggered on Mac B before kqueue closes document.
             • Changes from A will be overwritten if autosave occurs
             • Changes from B will be lost if document is closed while dirty,
             but there should be a warning if that happens.  So actually it's
             better if the autosave does NOT occur.
             */
            (![self isDocumentEdited])
#endif
            ||
            [self autoSaveInhibited]
            ||
            /* The following one never matters because, for some reason,
             this method is never invoked in BkmxAgent.  But I leave it,
             in case that some ever changes. */
            ([[BkmxBasis sharedBasis] isBkmxAgent])
            ) {
#if LOGGING_AUTOSAVE_IN_PLACE
                NSLog(@"<< %s Cancelled", __PRETTY_FUNCTION__) ;
#endif
                
                /* Do not autosave.  Just run the completion handler, if any. */
                if (completionHandler) {
                    completionHandler([NSError errorWithDomain:NSCocoaErrorDomain
                                                          code:NSUserCancelledError
                                                      userInfo:nil]) ;
                }
#if LOGGING_AUTOSAVE_IN_PLACE
                NSLog(@"<< %s Cancelled", __PRETTY_FUNCTION__) ;
#endif
                return ;
            }
    }
    
    // Note that we arrive here either in Case 1 or 3.
    // In Case 1, instead of adding the autosave operation to
    // our queue, we could invoke -reallyAutosaveWithCompletionHandler:
    // synchronously.  However we don't do that because the usual
    // notification sent when work is done, which we need for
    // housekeeping, would not be sent, and also it would be
    // extra code and an extra branch which means more testing
    // and bug possibilities.
    
    NSMutableDictionary* info = [NSMutableDictionary dictionary] ;
    [info setValue:Block_copy(completionHandler) forKey:constKeyCompletionHandler] ;
    [info setObject:self forKey:constKeyDocument] ;
    // The following adds a task to my home-made main operation
    // queue which I wrote back in the Leopard days …
    NSArray* selectorNames = [NSArray arrayWithObject:@"reallyAutosave"] ;
    [[self operationQueue] queueGroup:@"Non-cancellable Autosave"
                                addon:NO
                        selectorNames:selectorNames
                                 info:info
                                block:NO
                           doneThread:nil
                           doneTarget:nil
                         doneSelector:NULL
                         keepWithNext:NO] ;
#if LOGGING_AUTOSAVE_IN_PLACE
    NSLog(@"<< %s Queued", __PRETTY_FUNCTION__) ;
#endif
}

/*!
 @details  After getting several annoyed support questions from users
 who were miffed that their documents were "Locked", I added this in
 BookMacster 1.6.5, to always enable autosaving of documents,
 and never have documents indicated as " – Locked" in window title bars,
 regardless of how long ago they were last saved.  In other words,
 I'm overriding Apple's 14-day limit in favor of infinite days.
 */
- (BOOL)checkAutosavingSafetyAndReturnError:(NSError **)outError {
    return YES ;
}

/* With asynchronous saving, this method runs on a secondary thread. */
- (BOOL)writeSafelyToURL:(NSURL *)absoluteURL
                  ofType:(NSString *)typeName
        forSaveOperation:(NSSaveOperationType)saveOperation
                   error:(NSError **)outError {
    if ([self isSupercededByNewFileOnDisk]) {
        [[BkmxBasis sharedBasis] logFormat:
         @"Not writing %@ cuz superceded on disk.",
         [self displayName]] ;
        return YES ;
    }
    
    // typeName = "com.sheepsystems.bookmacster.collection"
    
    // We unblockUserInteraction *before* invoking super in this method because
    // -[super writeSafelyToURL:ofType:forSaveOperation:error:] is in fact the
    // long-running task that we want to be unblocked for.  Otherwise, it
    // would be pointless.
    [self unblockUserInteraction] ;
    
    NSString* token = [[NSDate date] geekDateTimeStringMilli] ;
    /* We shall store this token in two places, in the user defaults and in the
     document's auxiliary data.  When BkmxAgent gets a BkmxTriggerCloud from
     launchd, it compares the two tokens.  If they are the same, then
     it knows that there is no actual change to the document, and
     ignores it. */
    
    NSError* error = nil;
    
    NSInteger nTrials = 0;
    NSInteger const allowedTrials = 3;
    BOOL ok = YES;
    
    do {
        if (!ok) {
            [NSThread sleepForTimeInterval:1.0];
            NSString* msg = [NSString stringWithFormat:
                             @"Retrying [%ld] write due to %ld %@ with %@",
                             (long)nTrials,
                             (long)error.code,
                             error.localizedDescription,
                             self.fileURL.path];
            [[BkmxBasis sharedBasis] logFormat:msg];
        }
        error = nil;
        ok = [super writeSafelyToURL:absoluteURL
                              ofType:typeName
                    forSaveOperation:saveOperation
                               error:&error];
        nTrials++;
    } while (!ok && (nTrials < allowedTrials));
    
    if (error && outError) {
        error = [SSYMakeError(992544, @"Error writing .bmco file") errorByAddingUnderlyingError:error];
        [[BkmxBasis sharedBasis] logError:error
                          markAsPresented:NO];
        /* We passed andSave:NO because we are currently in a save method,
         so passing YES would probably result in a infinite loop. */
        *outError = error ;
    }
    
    /* Update docLastSaveToken in three places.  To avoid churn, it is
     important that all three have the same value. */
    /* place #1 */
    [[BkmxBasis sharedBasis] forJobSerial:0
                                logFormat:@"01 Setting dlLSToken %@", token];
    self.lastKnownLastSaveToken = token;
    [[BkmxBasis sharedBasis] forJobSerial:0
                                logFormat:@"12 Setting dlLSToken %@", token];
    /* place #2 */
    [self setInUserDefaultsLastSaveToken:token];
    [[BkmxBasis sharedBasis] forJobSerial:0
                                logFormat:@"23 Setting dlLSToken %@", token];
    /* place #3 */
    if (self.fileURL) {
        [self setAuxiliaryObject:token
                          forKey:constKeyDocLastSaveToken];
        [[BkmxBasis sharedBasis] forJobSerial:0
                                    logFormat:@"34 Setting dlLSToken %@", token];
    } else {
        [self addObserver:self
               forKeyPath:@"fileURL"
                  options:0
                  context:NULL];
    }
    
    NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithBool:ok], BkmxDocKeyDidSucceed,
                              [NSNumber numberWithInteger:saveOperation], BkmxDocKeySaveOperation,
                              nil] ;
    NSNotification* note = [NSNotification notificationWithName:BkmxDocDidSaveNotification
                                                         object:self
                                                       userInfo:userInfo] ;
    /* Because we've adopted asynchronous saving, this method runs on a
     non-main thread.  But at least one observer (ClientListView) of this
     notification will invoke GUI operations that must be done on the main
     thread.  So we post it indirectly… */
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:)
                                                           withObject:note
                                                        waitUntilDone:NO] ;
    // Passing waitUntilDone:YES will cause deadlock under certain conditions.  See Note 412246.
    
    if (ok) {
        /* Core Data access must use main thread… */
        if ([[NSThread currentThread] isMainThread]) {
            [self saveInUserDefaultsLastSaveToken:token
                                  forDocumentUuid:[self uuid]];
        }
        else {
            /* In BkmkMgrs 2.9.15, after adopting asynchronous saving, the
             following call was changed from dispatch_sync to _async, ro prevent
             a deadlock which was reproducible by deleting Markster.bmco, launching
             Markster, and OKing creation of a new document.  The deadlock
             was with -[NSDocument _checkAutosavingThenContinue:]. */
            dispatch_async(dispatch_get_main_queue(), ^{
                [self saveInUserDefaultsLastSaveToken:token
                                      forDocumentUuid:[self uuid]];
            });
        }
        
    }
    else {
        NSString* msg = [NSString stringWithFormat:
                         @"Failed saving %@ : %@ %ld",
                         [self displayName],
                         [error domain],
                         (long)[error code]] ;
        [[BkmxBasis sharedBasis] logFormat:msg] ;
    }
    
    return ok ;
}
/*
 Note 412246.  [This note was written before we adopted asynchronous saving.]
 If either of the two waitUntilDone: above are YES, you'll get a deadlock
 when in this test case (and presumably others)…
 • Create a document which has Opera as a Client, no agents.
 • Quit BookMacster.
 • Launch Opera.
 • Launch BookMacster.
 • Re-open that document
 • Edit a bookmark.
 • File ▸ One-Time Export ▸ Opera ▸ Normal Export.
 • Click OK to Quit Opera.
 • Click OK to Relaunch Opera.
 • Activate another app (Xcode, for example).
 Will hang when Auto Save kicks in.
 I didn't investigate the pathology of this deadlock.  Not waiting until done doesn't
 seem like it should be a big deal in either of these cases.
 */

- (void)saveInUserDefaultsLastSaveToken:(NSString*)token
                        forDocumentUuid:(NSString*)uuid {
    NSArray* keyPathArrayForToken = [NSArray arrayWithObjects:
                                     constKeyDocLastSaveToken,
                                     uuid,
                                     nil];
    [[NSUserDefaults standardUserDefaults] setAndSyncMainAppValue:token
                                                  forKeyPathArray:keyPathArrayForToken];
    NSString* msg = [NSString stringWithFormat:
                     @"Did save %@ %@ token=%@",
                     [self displayName],
                     [uuid substringToIndex:4],
                     token];
    [[BkmxBasis sharedBasis] logString:msg];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void*)notUsed {
    if ([keyPath isEqualToString:@"fileURL"]) {
        if (self.fileURL != nil) {
            [self setAuxiliaryObject:self.lastKnownLastSaveToken
                              forKey:constKeyDocLastSaveToken];
            [self removeObserver:self
                      forKeyPath:@"fileURL"];
        } else {
            /* .fileURL was nil when we created this observer, and if indeed
             it changed, it should be non-nil now.*/
            NSLog(@"Warning 837-3892");
        }
    } else {
        /* We are only observing .fileURL. */
        NSLog(@"Warning 837-4682");
    }
}

- (void)     moveToURL:(NSURL *)url
     completionHandler:(void (^)(NSError *))completionHandler {
    BOOL ok = NO;
    if ([[BkmxBasis sharedBasis] isShoeboxApp]) {
        NSString* onlyAllowedPath = [[NSDocumentController sharedDocumentController] shoeboxDocumentPathError_p:NULL];
        if ([url.path isEqualToString:onlyAllowedPath]) {
            ok = YES;
        }
    } else {
        ok = YES;
    }
    
    if (ok) {
        [super     moveToURL:url
           completionHandler:completionHandler];
    } else {
        SSYAlert* alert = [SSYAlert new];
        NSString* format = NSLocalizedString(@"Sorry, for simplicity, %@ does not support moving its document file.\n\n"
                                             @"(Our app for advanced users, %@, supports creation of multiple document files and moving them wherever you want.)", nil);
        NSString* msg = [NSString stringWithFormat:
                             format,
                         [[BkmxBasis sharedBasis] appNameLocalized],
                         [[NSBundle mainBundle] motherAppName]
        ];
        [alert setSmallText:msg];
        [self runModalSheetAlert:alert
                      resizeable:NO
                       iconStyle:SSYAlertIconCritical
               completionHandler:^(NSModalResponse modalResponse) {
            if (completionHandler) {
                NSError* error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                     code:NSUserCancelledError
                                                 userInfo:nil];
                completionHandler(error);
            };
        }];
    }
}

- (void)deleteFromTreeBookmarks:(NSArray*)deletions
             addToTreeBookmarks:(NSArray*)additions {
    Stark* item ;
    
    for (item in deletions) {
        [item moveToBkmxParent:nil] ;  // also removes from previous parent
    }
    
    Stark* newParent = [self.starker root] ;
    for (item in additions) {
        [item moveToBkmxParent:newParent] ;  // also removes from previous parent
    }
}

- (void)noticeStarkDeletions {
    [[[[[self bkmxDocWinCon] cntntViewController] contentOutlineView] dataSource] checkAllProxies];
}

- (void)clearBroker {
    [_broker clear] ;
}

- (void)removeAnyGhostSyncers {
    // We want to do this on another thread for performance reasons.
    // However, NSDocument is not thread-safe, so we must gather info
    // from it first.
    
    NSString* uuid = [self uuid] ;
    NSString* path = [[self fileURL] path] ;
    
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
                          uuid, constKeyDocUuid,
                          path, constKeyPath,
                          nil] ;
    
    [NSThread detachNewThreadSelector:@selector(removeAnyGhostSyncersInfo:)
                             toTarget:self
                           withObject:info];
}

- (void)removeAnyGhostSyncersInfo:(NSDictionary*)info {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
    
    NSString* myUuid = [info objectForKey:constKeyDocUuid] ;
    NSString* myPath = [info objectForKey:constKeyPath] ;
    
    // Form set of all document uuids that have regular agents and/or quatches
    NSMutableSet* watches = [[[NSUserDefaults standardUserDefaults] watchesThisApp] mutableCopy];
    
    NSTimeInterval timeoutPerUuid = 8.0/[watches count] ;
    NSError* error = nil ;
    NSMutableArray* badUuids = [[NSMutableArray alloc] init] ;
    for (Watch* watch in watches) {
        NSString* uuid = watch.docUuid;
        if ([uuid isEqualToString:myUuid]) {
            continue ;
        }
        NSString* path = [[BkmxDocumentController sharedDocumentController] pathOfDocumentWithUuid:uuid
                                                                                           appName:nil
                                                                                           timeout:timeoutPerUuid
                                                                                            trials:1
                                                                                             delay:0
                                                                                           error_p:&error] ;
        if (
            !path
            ||
            [path isEqualToString:myPath] // Agents's document has my path but not my uuid, eeeek!
            ||
            ![[NSFileManager defaultManager] fileIsPermanentAtPath:path
                                                           error_p:NULL]
            ) {
                [badUuids addObject:uuid] ;
                NSLog(@"uuid=%@ will remove ghost Syncers for uuid=%@ (path=%@)",
                      myUuid,
                      uuid,
                      path) ;
            }
    }
    [watches release];
    
    for (NSString* uuid in badUuids) {
        [(BkmxAppDel*)[NSApp delegate] removeSyncersForDocumentUuid:uuid] ;
    }
    
    [badUuids release] ;
    [pool drain] ;
}

#define AGENT_DROPBOX_THROTTLE_INTERVAL 60.0

/*!
 @details This method is typically called in main app, but may also be called
 in BkmxAgent if syncing is paused due to a Sync Fight detected.
 */
- (BOOL)realizeSyncersToWatchesError_p:(NSError**)error_p {
    if ([self isZombie]) {
        //  This can happen when using the Versions Browser.
        //  I'm not sure whether or not it's an issue.
        return YES ;
    }
    
    if ([[BkmxBasis sharedBasis] isBkmxAgent]) {
        if (self.macster.syncers.count > 0) {
            /* Should be defensive programming at this point, but,
             for BkmxAgent, this method is only needed if  agents are
             being removed (due to Sync Fight). */
            return YES;
        }
    }
    
    BOOL ok = YES;
    NSError* error = nil;
    
    if (ok) {
        NSMutableArray* watchesFromCurrentSyncers = [[NSMutableArray alloc] init];
        Macster* macster = [self macster];
        [[macster managedObjectContext] performBlockAndWait:^{
            for (Syncer* syncer in [macster syncersOrdered]) {
                if (![[syncer isActive] boolValue]) {
                    continue ;
                }
                
                for (Trigger* trigger in [syncer triggersOrdered]) {
                    Watch* watch = [Watch new];
                    watch.appName = [[BkmxBasis sharedBasis] mainAppNameUnlocalized];
                    watch.docUuid = self.uuid;
                    watch.clientoid = trigger.client.clientoid;
                    watch.syncerUri = syncer.objectID.URIRepresentation.absoluteString;
                    watch.triggerUri = trigger.objectID.URIRepresentation.absoluteString;
                    watch.syncerIndex = syncer.index.integerValue;
                    watch.triggerIndex = trigger.index.integerValue;
                    watch.efficiently = trigger.efficiently.boolValue;
                    switch(trigger.triggerTypeValue) {
                        case BkmxTriggerImpossible:
                            watch.watchType = WatchTypeUndefined;
                            break;
                        case BkmxTriggerLogIn:
                            watch.watchType = WatchTypeLogIn;
                            watch.runAtLoad = YES;
                            break;
                        case BkmxTriggerPeriodic:
                            watch.watchType = WatchTypePeriodic;
                            watch.subject = [NSString stringWithFormat:@"%ld", [trigger.period integerValue]];
                            break;
                        case BkmxTriggerBrowserQuit:
                        case BkmxTriggerBrowserLaunch:;
                            Client* client = trigger.client;
                            NSString* exformat = client.exformat;
                            Class extoreClass = [Extore extoreClassForExformat:exformat];
                            NSString* extoreClassName = NSStringFromClass(extoreClass);
                            watch.subject = extoreClassName;
                            watch.watchType = (trigger.triggerTypeValue == BkmxTriggerBrowserQuit) ? WatchTypeAppQuit : WatchTypeAppLaunch;
                            watch.throttleInterval = 57.777;
                            break;
                        case BkmxTriggerScheduled:
                            watch.watchType = WatchTypeScheduled;
                            watch.subject = [trigger.recurringDate stringRepresentation];
                            break;
                        case BkmxTriggerSawChange:
                            watch.subject = trigger.client.sawChangeTriggerPath;
                            watch.watchType = WatchTypePathTouched;
                            watch.throttleInterval = SAW_CHANGE_DEBOUNCE_INTERVAL;
                            break;
                        case BkmxTriggerCloud:
                            watch.watchType = WatchTypePathTouched;
                            watch.subject = [BSManagedDocument auxiliaryDataFilePathForDocumentPath:self.fileURL.path];
                            watch.throttleInterval = AGENT_DROPBOX_THROTTLE_INTERVAL;
                            break;
                        case BkmxTriggerLanding:
                            watch.watchType = WatchTypeLanding;
                    }
                    
                    [watchesFromCurrentSyncers addObject:watch];
                    [watch release];
                }
            }
        }];
        
        NSMutableSet* watchesToAdd = [NSMutableSet new];
        NSMutableSet* watchesToKeep = [NSMutableSet new];
        NSMutableSet* watches = [[[NSUserDefaults standardUserDefaults] watchesThisApp] mutableCopy];
        for (Watch* watch in watchesFromCurrentSyncers) {
            BOOL didMatchOld = NO;
            for (Watch* oldWatch in watches) {
                if ([watch isEqual:oldWatch]) {
                    [watchesToKeep addObject:oldWatch];
                    didMatchOld = YES;
                    break;
                }
            }
            
            if (!didMatchOld) {
                [watchesToAdd addObject:watch];
            }
        }
        [watchesFromCurrentSyncers release];
        
        for (Watch* watch in watches) {
            if (![watch.docUuid isEqualToString:self.uuid]) {
                [watchesToKeep addObject:watch];
            }
        }
        
        [watches minusSet:watchesToKeep];
        [watchesToKeep release];
        
        [[NSUserDefaults standardUserDefaults] mutateWatchesAdditions:watchesToAdd
                                                            deletions:watches];
        [watches release];
        [watchesToAdd release];
    }
    
    if (error && error_p) {
        *error_p = error ;
    }
    
    return ok ;
}

- (void)alertSyncingStillPaused:(NSArray*)browsers {
    SSYAlert* alert = [SSYAlert alert] ;
    
    NSString* msg = @"Syncing is paused.\n\n" ;
    
    NSString* appendage ;
    NSString* finalSteps = [NSString stringWithFormat:
                            @"\u2022 Click the 'Syncing' button in the toolbar so it turns yellow.\n\n"
                            @"\u2022 Close this window or quit %@.",
                            [[BkmxBasis sharedBasis] appNameLocalized]];
    if ([browsers count] == 0) {
        appendage = [NSString stringWithFormat:
                     @"To start syncing,\n\n"
                     @"\u2022 Add Synced Browser(s) in Preferences > Syncing.\n\n%@",
                     finalSteps] ;
    }
    else {
        NSString* browserList = [[self macster] truncatedListOrPlaceholderForClients:browsers
                                                                       maxCharacters:128] ;
        appendage = [NSString stringWithFormat:
                     @"To start syncing with %@, after organizing your bookmarks in here,\n\n%@",
                     browserList,
                     finalSteps] ;
    }
    msg = [msg stringByAppendingString:appendage] ;
    
    [alert setSmallText:msg] ;
    [self runModalSheetAlert:alert
                  resizeable:NO
                   iconStyle:SSYAlertIconInformational
               modalDelegate:nil
              didEndSelector:NULL
                 contextInfo:NULL] ;
}

/* This method must be called on the main thread… */
- (void)ifInViewingModePauseAndTell {
    /*
     Because the macster of the frontmost document in the Versions Browser
     (potentially here, self) is nil, we need the macster of the frontmost
     "actual" document.  That is, the document which is on the left side in the
     Versions Browser.  Oddly, when you are in the Versions Browser,
     *   -[NSDocumentController frontmostDocument] returns the frontmost in the
     *         Versions Browser
     *   -[NSDocumentController documents] returns all open *actual* documents,
     *         excluding the ones in the Versions Browser.  The order is,
     *         unfortunately, seems to be the order in which the documents were
     *         opened.
     So, we must do the following shenanighans…
     */
    BkmxDoc* frontmostDocument = [[NSDocumentController sharedDocumentController] frontmostDocument] ;
    NSString* filenameOfFrontmostDocument = [[[frontmostDocument fileURL] absoluteString] lastPathComponent] ;
    Macster* macster = [frontmostDocument macster] ;
    if (!macster) {
        for (BkmxDoc* document in [[NSDocumentController sharedDocumentController] documents]) {
            if ([[[[document fileURL] absoluteString] lastPathComponent] isEqualToString:filenameOfFrontmostDocument]) {
                macster = [document macster] ;
                break ;
            }
        }
    }
    
    uint64_t syncerConfig = [macster syncerConfigValue];
    
    BOOL shouldTell = (
                       (
                        (macster != nil)
                        && [self ssy_isInViewingMode]
                        && (((syncerConfig & constBkmxSyncerConfigExportFromCloud) != 0) || ((syncerConfig & constBkmxSyncerConfigIsAdvanced) != 0))
                        && ([macster syncersPaused] == NO))
                       ) ;
    if (shouldTell) {
        SSYAlert* alert = [SSYAlert alert] ;
        NSString* maybe = ((syncerConfig & constBkmxSyncerConfigExportFromCloud) != 0) ? @"will" : @"may" ;
        NSString* msg = [NSString stringWithFormat:
                         @"This document has syncing enabled.  If and when you click 'Restore', the restored bookmarks %@ be immediately exported to %@.  "
                         @"If you don't want that to happen, first Pause syncing.  To Pause syncing, after you OK this warning, in the Current Document on the left, in the toolbar, click the 'Syncing' button.\n\n"
                         @"If this document is in a Dropbox or similar folder synced to other Macs and %@ is syncing this document on other Macs, the same %@ happen there.  "
                         @"If you don't want that, on those other Macs, pause Syncing in the same way, or just make sure those Macs are off, or at least offline.",
                         maybe,
                         [macster readableExportsListOnlyIfVulnerable:NO
                                                        maxCharacters:NSIntegerMax],
                         [[BkmxBasis sharedBasis] appNameLocalized],
                         maybe] ;
        [alert setSmallText:msg] ;
        
        // Typically, the window is not showing yet, so we need a delay.
        [self performSelector:@selector(runModalMonologueAlert:)
                   withObject:alert
                   afterDelay:0.0] ;
    }
}

- (void)expandAllContentWork {
    [[[self bkmxDocWinCon] contentOutlineView] reloadData] ;
    [[[self bkmxDocWinCon] contentOutlineView] expandItem:(ContentProxy*)nil
                                           expandChildren:YES] ;
}

- (BOOL)needsSort {
    NSDate* lastSortDone = [[self shig] lastSortDone] ;
    NSDate* lastSortMaybeNot = [[self shig] lastSortMaybeNot] ;
    
    BOOL needDo = YES ;
    if (lastSortDone && lastSortMaybeNot) {
        needDo = [lastSortMaybeNot compare:lastSortDone] == NSOrderedDescending ;
    }
    else if (lastSortDone) {
        // This document was sorted but never unsorted
        needDo = NO ;
    }
    
    return needDo ;
}

- (BOOL)needsDupeFind {
    return (
            [[self shig] dupesMaybeMore]
            &&
            ([[[[BkmxBasis sharedBasis] operationQueue] operations] count] == 0)
            ) ;
}

- (void)saveAndClearUndo {
    // In Main App, we are NOT on the main thread here!
    NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithInteger:NSSaveOperation], constKeySaveOperation,
                                 nil] ;
    
    NSArray* selectorNames = [NSArray arrayWithObjects:
                              @"saveDocument",
                              @"clearUndo",
                              nil] ;
    
    [[self operationQueue] queueGroup:NSStringFromSelector(_cmd)
                                addon:NO
                        selectorNames:selectorNames
                                 info:info
                                block:NO
                           doneThread:[NSThread mainThread]
                           doneTarget:self
                         doneSelector:@selector(finishGroupOfOperationsWithInfo:)
                         keepWithNext:NO] ;
}

- (Stark*)insertFreshBookMacsterizer {
    Stark* bookmacsterizer = [[self starker] freshBookMacsterizer] ;
    Stark* bookmacsterizerParent ;
    bookmacsterizerParent = [self hasBar] ? [[self starker] bar] : [[self starker] root] ;
    StarkLocation* location = [StarkLocation starkLocationWithParent:bookmacsterizerParent
                                                               index:NSNotFound] ;
    NSArray* newItemArray = [NSArray arrayWithObject:bookmacsterizer] ;
    [location canInsertItems:newItemArray
                         fix:StarkLocationFixParentAndIndex
                 outlineView:nil] ;
    [StarkEditor parentingAction:BkmxParentingMove
                           items:newItemArray
                       newParent:[location parent]
                        newIndex:[location index]
                    revealDestin:NO] ;
    return bookmacsterizer ;
}


#pragma mark * Heavy Lifting Methods, invoked by Action Methods

/*!
 @brief    Commences a 'revert' operation in the receiver's operation queue.
 
 @details  Until BookMacster 1.5, this method invoked
 -revertDocumentToSaved:, which became a no-op if the sheet showing
 that some other application had modified the file was already
 showing.  That shouldn't have happened, by the way, it's fixed now too.
 */
- (void)revert {
    NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 [NSString localize:@"revert"], constKeyActionName,
                                 self, constKeyDocument,
                                 nil] ;
    
    NSArray* selectorNames = [NSArray arrayWithObjects:
                              // @"beginUndoGrouping", // Don't.  Revert is not undoable.
                              @"revert",
                              @"showCompletionReverted",
                              nil] ;
    
    [[self operationQueue] queueGroup:NSStringFromSelector(_cmd)
                                addon:NO
                        selectorNames:selectorNames
                                 info:info
                                block:NO
                           doneThread:[NSThread mainThread]
                           doneTarget:self
                         doneSelector:@selector(finishGroupOfOperationsWithInfo:)
                         keepWithNext:NO] ;
}

- (void)sort {
    NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 [[BkmxBasis sharedBasis] labelSort], constKeyActionName,
                                 self, constKeyDocument,
                                 nil] ;
    
    NSArray* selectorNames = [NSArray arrayWithObjects:
                              @"beginUndoGrouping",
                              @"sortTreeIfNeeded",
                              @"showCompletionSorted",
                              @"setUndoActionName",
                              nil] ;
    
    [[self operationQueue] queueGroup:NSStringFromSelector(_cmd)
                                addon:NO
                        selectorNames:selectorNames
                                 info:info
                                block:NO
                           doneThread:[NSThread mainThread]
                           doneTarget:self
                         doneSelector:@selector(finishGroupOfOperationsWithInfo:)
                         keepWithNext:NO] ;
}

- (void)consolidateFolders {
    NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 self, constKeyDocument,
                                 [[BkmxBasis sharedBasis] labelConsolidateFolders], constKeyActionName,
                                 [NSMutableArray array], constKeyDeletedFolderLineages,
                                 [NSMutableArray array], constKeyMergedFolderLineages,
                                 [NSNumber numberWithBool:YES], constKeyConsolidateAndRemoveNow,
                                 nil] ;
    
    NSArray* selectorNames = [NSArray arrayWithObjects:
                              @"beginUndoGrouping",
                              @"consolidateFolders",
                              @"displayConsolidatedFolders",
                              @"showCompletionConsolidateFolders",
                              @"setUndoActionName",
                              nil] ;
    
    [[self operationQueue] queueGroup:NSStringFromSelector(_cmd)
                                addon:NO
                        selectorNames:selectorNames
                                 info:info
                                block:NO
                           doneThread:[NSThread mainThread]
                           doneTarget:self
                         doneSelector:@selector(finishGroupOfOperationsWithInfo:)
                         keepWithNext:NO] ;
}

// Needed to support Advanced Syncers, which can command 'findDupes'
- (void)findDupes{
    NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 [self.starker root], constKeyRootStark,
                                 [NSNumber numberWithBool:YES], constKeyDoReportDupes,
                                 [NSNumber numberWithBool:YES], constKeyExceptAllowed,
                                 self, constKeyDocument,
                                 [[self shig] ignoreDisparateDupes], constKeyDoIgnoreDisparateDupes,
                                 [[BkmxBasis sharedBasis] labelFindDupes], constKeyActionName,
                                 nil] ;
    
    NSArray* selectorNames = [NSArray arrayWithObjects:
                              @"beginUndoGrouping",
                              @"findDupes",
                              @"finishFindDupes",
                              @"showCompletionFindDupes",
                              @"setUndoActionName",
                              nil] ;
    
    /*  If we are running under AppleScript then tell operationQueue to block this thread.
     If we did not do this, either AppleScript would return to the scripter before
     all operations were complete. */
    [[self operationQueue] queueGroup:NSStringFromSelector(_cmd)
                                addon:NO
                        selectorNames:selectorNames
                                 info:info
                                block:NO
                           doneThread:[NSThread mainThread]
                           doneTarget:self
                         doneSelector:@selector(finishGroupOfOperationsWithInfo:)
                         keepWithNext:NO] ;
}

- (void)forgetDupes {
    NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 [[self dupetainer] allDupeDic], constKeyDupeDic,
                                 self, constKeyDocument,
                                 @"Forget Duplicate Groups", constKeyActionName,
                                 nil] ;
    
    NSArray* selectorNames = [NSArray arrayWithObjects:
                              @"beginUndoGrouping",
                              @"forgetDupes",
                              @"setUndoActionName",
                              nil] ;
    
    /*  If we are running under AppleScript then tell operationQueue to block this thread.
     If we did not do this, either AppleScript would return to the scripter before
     all operations were complete. */
    [[self operationQueue] queueGroup:NSStringFromSelector(_cmd)
                                addon:NO
                        selectorNames:selectorNames
                                 info:info
                                block:NO
                           doneThread:[NSThread mainThread]
                           doneTarget:self
                         doneSelector:@selector(finishGroupOfOperationsWithInfo:)
                         keepWithNext:NO] ;
}

- (void)deleteAllDupes {
    NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 self, constKeyDocument,
                                 [[BkmxBasis sharedBasis] labelDeleteAllDupes], constKeyActionName,
                                 nil] ;
    
    NSArray* selectorNames = [NSArray arrayWithObjects:
                              @"beginUndoGrouping",
                              @"deleteDupes",
                              @"showCompletionDeleteDupes",
                              @"setUndoActionName",
                              nil] ;
    
    /*  If we are running under AppleScript then tell operationQueue to block this thread.
     If we did not do this, either AppleScript would return to the scripter before
     all operations were complete. */
    [[self operationQueue] queueGroup:NSStringFromSelector(_cmd)
                                addon:NO
                        selectorNames:selectorNames
                                 info:info
                                block:NO
                           doneThread:[NSThread mainThread]
                           doneTarget:self
                         doneSelector:@selector(finishGroupOfOperationsWithInfo:)
                         keepWithNext:NO] ;
}

- (void)deleteAllContent {
    NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 self, constKeyDocument,
                                 [[BkmxBasis sharedBasis] labelDeleteAllContent], constKeyActionName,
                                 nil] ;

    NSArray* selectorNames = [NSArray arrayWithObjects:
                              @"beginUndoGrouping",
                              @"deleteAllContent",
                              @"showCompletionDeleteAllContent",
                              @"setUndoActionName",
                              nil] ;

    /*  If we are running under AppleScript then tell operationQueue to block this thread.
     If we did not do this, either AppleScript would return to the scripter before
     all operations were complete. */
    [[self operationQueue] queueGroup:NSStringFromSelector(_cmd)
                                addon:NO
                        selectorNames:selectorNames
                                 info:info
                                block:NO
                           doneThread:[NSThread mainThread]
                           doneTarget:self
                         doneSelector:@selector(finishGroupOfOperationsWithInfo:)
                         keepWithNext:NO] ;
}

- (void)didEndCloseAndDeleteSheet:(NSWindow*)sheet
                       returnCode:(NSInteger)returnCode
                      contextInfo:(void*)notUsed {
    [sheet orderOut:self] ;
    
    if (returnCode == NSAlertSecondButtonReturn) {
        return ;
    }
    
    NSString* uuid = [self uuid] ;
    NSURL* fileUrl = [self fileURL] ;
    
    [self close] ;
    
    [[NSDocumentController sharedDocumentController] forgetAndTrashDocWithUuid:uuid
                                                                       fileUrl:fileUrl] ;
}

- (void)closeAndTrash {
    [self didEndCloseAndDeleteSheet:nil
                         returnCode:NSAlertFirstButtonReturn
                        contextInfo:NULL] ;
}

- (void)didEndRelaunchSheet:(NSWindow*)sheet
                 returnCode:(NSInteger)returnCode
                contextInfo:(NSDictionary*)info {
    [sheet orderOut:self] ;
    
    Extore* extore = [info objectForKey:constKeyExtore] ;
    
    if (returnCode == NSAlertFirstButtonReturn) {
        SSYProgressView* progressView = [[self progressView] setIndeterminate:YES
                                                            withLocalizedVerb:[NSString localizeFormat:
                                                                               @"launchingX",
                                                                               [extore ownerAppDisplayName]]
                                                                     priority:SSYProgressPriorityRegular] ;
        NSString* path = [info objectForKey:constKeyBrowserPathQuit] ;
        NSError* error = nil ;
        [extore launchOwnerAppPath:path
                          activate:NO
                           error_p:&error] ;
        if (error) {
            NSLog(@"Internal Error 624-5606 %@", error) ;
        }
        [progressView clearAll] ;
    }
    
    // Release context info which was retained earlier
    [info release] ;
}

- (void)requinchBrowserMaybeForInfo:(NSDictionary*)info {
    Extore* extore = [info objectForKey:constKeyExtore] ;
    OwnerAppQuinchState quinchState = [extore ownerAppQuinchState] ;
    if (quinchState == OwnerAppQuinchStateDidQuill) {
        if (![[BkmxBasis sharedBasis] isBkmxAgent] && ![[BkmxBasis sharedBasis] isScripted]) {
            // In Main App, not scripted
            SSYAlert* alert = [SSYAlert alert] ;
            NSString* msg = [NSString stringWithFormat:
                             @"%@\n\n%@",
                             [NSString localize:@"doneIs"],
                             [NSString localizeFormat:
                              @"launchReX",
                              [[extore client] displayNameWithoutProfile]]] ;
            [alert setSmallText:msg] ;
            [alert setButton1Title:[NSString localize:@"yes"]] ;
            [alert setButton2Title:[NSString localize:@"no"]] ;
            [self runModalSheetAlert:alert
                          resizeable:NO
                           iconStyle:SSYAlertIconInformational
                       modalDelegate:self
                      didEndSelector:@selector(didEndRelaunchSheet:returnCode:contextInfo:)
                         contextInfo:[info retain]] ;
        }
        else {
            // In Worker or scripted
            [self didEndRelaunchSheet:nil
                           returnCode:NSAlertFirstButtonReturn
                          contextInfo:[info retain]] ;
        }
    }
    else if (quinchState == OwnerAppQuinchStateDidLaunch) {
        NSString* path = [[info objectForKey:constKeyBrowserPathsLaunched] objectForKey:[[[extore client] clientoid] clidentifier]] ;
        if (!path) {
            path = [extore browserBundlePath] ;
            NSLog(@"Internal Error 254-9446 fallback %@", path) ;
        }
        
        // The browser was not running before we launched it, and the user
        // probably didn't even notice that we did.  So we quit it.
        BOOL no = NO ;
        CGFloat timeout = 10.0 ;
        NSInvocation* invocation = [NSInvocation invocationWithTarget:extore
                                                             selector:@selector(quitOwnerAppWithTimeout:preferredPath:killAfterTimeout:wasRunning_p:pathQuilled_p:error_p:)
                                                      retainArguments:YES
                                                    argumentAddresses:&timeout, &path, &no, NULL, NULL, NULL] ;
        NSString* msg = [NSString stringWithFormat:
                         @"Will quit %@ in %0.1f secs",
                         [extore displayName],
                         [extore quitHoldTime]];
        [[BkmxBasis sharedBasis] logFormat:msg];
        
        [invocation performSelector:@selector(invoke)
                         withObject:nil
                         afterDelay:[extore quitHoldTime]] ;
    }
}

- (void)doMoreDoneInvocationsFromInfo:(NSDictionary*)info {
    for (NSInvocation* invocation in [info objectForKey:constKeyMoreDoneInvocations]) {
        [invocation invoke] ;
    }
}

- (void)handleErrorInOperationInfo:(NSMutableDictionary*)info {
    NSError* error = [info objectForKey:constKeySSYOperationQueueError] ;
    if (!error) {
        return ;
    }
    
    if ([SSYOperationQueue operationGroupsDifferInfo:info
                                           otherInfo:[error userInfo]]) {
        return ;
    }
    
    NSInteger code = [error code] ;
    // Changed in BookMacster 1.5.7:
    // We dontStop if there is a dontStop object = YES in either the info or the error.
    // I've seen it come in the error only.  Not sure if the opposite ever occurs, but
    // if it does, we'd want to dontStop
    BOOL dontStop = NO ;
    NSNumber* dontStopObject = [info objectForKey:constKeyDontStopOthersIfError] ;
    if ([dontStopObject boolValue]) {
        dontStop = YES ;
    }
    else {
        dontStopObject = [[error userInfo] objectForKey:constKeyDontStopOthersIfError] ;
        if ([dontStopObject boolValue]) {
            dontStop = YES ;
        }
    }
    
    if (dontStop) {
        /* This key will be used in -[AgentPerformer alertError:] to
         prevent aborting the job. */
        error = [error errorByAddingUserInfoObject:dontStopObject
                                            forKey:constKeyDontStopOthersIfError] ;
    }
    else {
        // Added in BookMacster 1.6
        NSMutableSet* cancelledInfoDics = [[NSMutableSet alloc] init] ;
        for (SSYOperation* operation in [[self operationQueue] operations]) {
            // defensive programming, to verify that we've got an SSYOperation
            if ([operation respondsToSelector:@selector(info)]) {
                NSDictionary* cancelledInfoDic = [operation info];
                if (cancelledInfoDic) {
                    [cancelledInfoDics addObject:cancelledInfoDic];
                }
            }
            if ([operation respondsToSelector:@selector(selector)]) {
                SEL selector = [operation selector] ;
                // Added in BookMacster 1.11 because it seemed like a good idea…
                if (selector == @selector(doDone:)) {
                    continue ;
                }
            }
            
            [operation cancel] ;
        }
        
        for (NSMutableDictionary* cancelledInfo in cancelledInfoDics) {
            if ([[cancelledInfo objectForKey:constKeyDidBeginUndoGrouping] boolValue]) {
                [(SSYDooDooUndoManager*)[self undoManager] endManualUndoGrouping] ;
                [info removeObjectForKey:constKeyDidBeginUndoGrouping] ;
            }
        }
        
        [cancelledInfoDics release] ;
    }
    
    // Clear out any half-done progress bars.  For example, there
    // is at least one case (and probably more) in Extore Firefox
    // where an error causes a jump out of a loop and bypasses the
    // clearing of the progess bar.
    // In general, it should be safe to say that, if an error occurs,
    // any progress which is still being displayed is nonsense.
    NSString* verb = nil ;
    BOOL isUserCancelledBkmxError = (([error code] == constBkmxErrorUserCancelled) && [[error domain] isEqualToString:[NSError myDomain]]) ;
    BOOL isUserCancelledCocoaError = [error isUserCancelledCocoaError] ;
    if (isUserCancelledBkmxError || isUserCancelledCocoaError) {
        verb = @"Cancelled" ;
    }
    else if ([[BkmxBasis sharedBasis] shouldHideError:error]) {
        verb = @"Same-Skip" ;
    }
    else {
        verb = [NSString localizeFormat:@"error"] ;
    }
    [[self progressView] showCompletionVerb:verb
                                     result:[[info objectForKey:constKeyIxporter] displayName]
                                   priority:SSYProgressPriorityRegular] ;
    
    // Add recovery info and alert user of the error
    switch (code) {
        case constBkmxErrorNotLicensedToWrite:
            // Try to make a sale
            if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
                /* The user may have just purchased a license in response
                 to the error.  We therefore check the current status so that
                 we do not present the SSYLicenseBuyController *again*, which
                 would be very annoying to the user. */
                if (SSYLCCurrentLevel() < SSYLicenseLevelValid) {
                    [SSYLicenseBuyController showWindow] ;
                }
            }
            break ;
            
        default:
            // We only try to pass an invocation pointer if we're in the Main App.  It
            // won't work very well in another process!
            if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
                /* Errors in SheepSafariHelperErrorDomain are generally not recoverable.
                 Adding the didRecoverInvocation just makes it hard to read. */
                if (![[error domain] isEqualToString:SheepSafariHelperErrorDomain]) {
                    // Transfer didRecoverInvocation (which may be a composite of several
                    // invocations), if any, to error's didRecoverInvocation.
                    // (Subsequently will be transferred back from error to info in
                    // -[ExtoreWebFlat attemptRecoveryFromError:recoveryOption:delegate:didRecoverSelector:contextInfo:]
                    // This is used in case bad credentials are discovered during Import or Export,
                    // or in case a browser needs to be quit.
                    NSInvocation* didRecoverInvocation = [[self operationQueue] errorRetryInvocation] ;
                    error = [error errorByAddingDidRecoverInvocation:didRecoverInvocation] ;
                }
            }
            else {
                // The following key makes it possible for us to recover from a Syncer
                // performance error encountered in BkmxAgent by re-executing it in the
                // main app.  Note that this is used instead of the  didRecoverInvocation
                // which won't work.  Probably a better way to do this would be to pass,
                // instead of this, some kind of didRecoverScript
                error = [error errorByAddingUserInfoObject:[info objectForKey:constKeyTriggerUri]
                                                    forKey:constKeyTriggerUri] ;
            }
            
            error = [error errorByAddingUserInfoObject:[info objectForKey:constKeyJob] forKey:constKeyJob];
            
            /* If in Main App, this method will begin a sheet.
             If in BkmxAgent, this method will add a macOS User Notification.
             In both cases, the following call returns synchronously. */
            [self alertError:error] ;
            
            break ;
    }
}

- (void)doGrandDoneInfo:(NSDictionary*)info {
    NSInvocation* grandDoneInvocation = [info objectForKey:constKeyGrandDoneInvocation] ;
    [grandDoneInvocation invoke] ;
}

- (void)finishImportInfo:(NSMutableDictionary*)info {
    [self setDidImportPrimarySource:NO] ;
    [[self starker] setDestinees:nil] ;
    [self setImportedExtores:nil] ;
    
    if ([[info objectForKey:constKeyDidBeginUndoGrouping] boolValue]) {
        [(SSYDooDooUndoManager*)[self undoManager] endManualUndoGrouping] ;
    }
    
    NSError* error = [info objectForKey:constKeySSYOperationQueueError] ;
    if (error) {
        [self handleErrorInOperationInfo:info] ;
    }
    else {
        [[self bkmxDocWinCon] selectNewestIxportLog] ;
    }
    
    [self doMoreDoneInvocationsFromInfo:info] ;
    [self doGrandDoneInfo:info] ;
    
    /* See Note WhyClearOutInfo, below */
    [info removeAllObjects];
    
    [[self bkmxDocWinCon] updateWindowForStark:nil] ;
}

- (BOOL)finishGroupOfOperationsWithInfo:(NSMutableDictionary*)info {
    // We're back on the main thread now.
    
    /* At the end of this method, we are going to remove all objects from
     info, to break a retain cycle(s).  However, requinchBrowserMaybeForInfo
     will require several keys from that dictionary, maybe later, after user
     responds to a sheet or after a delay.  To make it work, instead of passing
     `info` to -requinchBrowserMaybeForInfo:, we now create a new dictionary
     for this purpose, copying the keys we need, and pass that to
     requinchBrowserMaybeForInfo:. */
    NSMutableDictionary* requinchInfo = [NSMutableDictionary new];
    [requinchInfo setValue:[info objectForKey:constKeyExtore]
                    forKey:constKeyExtore];
    [requinchInfo setValue:[info objectForKey:constKeyBrowserPathsLaunched]
                    forKey:constKeyBrowserPathsLaunched];
    [requinchInfo setValue:[info objectForKey:constKeyBrowserPathQuit]
                    forKey:constKeyBrowserPathQuit];
    [self requinchBrowserMaybeForInfo:requinchInfo];
    [requinchInfo release];
    
    Extore* extore = [info objectForKey:constKeyExtore] ;
    NSString* suffix;
    if (extore) {
        suffix = [[NSString alloc] initWithFormat:
                  @", for client: %@",
                  extore.displayName];
    } else {
        suffix = [NSString new];
    }
    NSString* msg = [[NSString alloc] initWithFormat:
                     @"Ending group: `%@`%@",
                     [info objectForKey:constKeySSYOperationGroup],
                     suffix];
    [suffix release];
    [[BkmxBasis sharedBasis] logFormat:msg];
    [msg release];
    Ixporter* ixporter = [info objectForKey:constKeyIxporter] ;
    NSError* error = [info objectForKey:constKeySSYOperationQueueError] ;
    
    if ([ixporter isAnExporter]) {
        if ([[info objectForKey:constKeyIsTestRun] boolValue] == NO) {
            if (!error) {
                SSYModelChangeCounts changeCounts = [[self chaker] changeCounts] ;
                Extore* extore = [ixporter extore];
                NSString* msg = [extore doPostExportTasksAndGetMessageToUserForChangeCounts:changeCounts];
                if (msg) {
                    SSYAlert* alert = [SSYAlert alert] ;
                    [alert setSmallText:msg] ;
                    [alert setButton1Title:[NSString localize:@"ok"]] ;
                    NSInteger iconStyle = SSYAlertIconWarning ;
                    NSInvocation* invocation = [NSInvocation invocationWithTarget:[info objectForKey:constKeyDocument]
                                                                         selector:@selector(runModalSheetAlert:resizeable:iconStyle:modalDelegate:didEndSelector:contextInfo:)
                                                                  retainArguments:YES
                                                                argumentAddresses:&alert, &iconStyle, NULL, NULL, NULL] ;
                    [info addObject:invocation
                       toArrayAtKey:constKeyMoreDoneInvocations] ;
                }
            }
        }
    }
    
    if ([info objectForKey:constKeyDidClaimBaton]) {
        NSString* clidentifier = ixporter.client.clientoid.clidentifier;
        NSAssert(clidentifier, @"Claimed baton but no clidentifier");
        [[Watcher sharedWatcher] unclaimIxportBatonForClidentifier:clidentifier
                                                         jobSerial:((NSNumber*)[info objectForKey:constKeySerialString]).integerValue];
    }
    
    
    // Must be done here instead of as an operation, because it is required to
    // run even if a "no changes" error occurred in merging or exporting.
    // Such an error will abort subsequent operations.
    [extore restoreBrowserStateInfo:info] ;
    
    // The following if() will be NO for Import operation
    // groups but YES for all other operation groups.
    if ([[info objectForKey:constKeyDidBeginUndoGrouping] boolValue]) {
        [(SSYDooDooUndoManager*)[self undoManager] endManualUndoGrouping] ;
    }
    
    // It is important that the following gets executed at the end of an import
    // or export, even if got aborted due to an error.  If these are not executed,
    // (1) the extore will not be deallocced until the doc window is closed,
    // because it is retained by the Ixporter,
    // and (2) immediately after the bkmxDoc is closed, when its managed
    // objects are no longer available, Core Data will try and access the
    // import/export Client (a managed object) which will result in messages
    // like this being logged:
    // The NSManagedObject with ID:0x24f2870 <x-coredata://0FAE5D03-55FF-440D-9AAD-A746E2AADFF8/Client_entity/p7> has been invalidated.
    // *** -[NSFaultHandler turnObject:intoFaultWithContext:]: message sent to deallocated instance 0x24f0e90
    // and then a crash.
    [extore tearDownFor:@"FinishOperations"
              jobSerial:((NSNumber*)[info objectForKey:constKeySerialString]).integerValue];
    [ixporter releaseExtore] ;
    
    // We update the window after each client import because it looks cool.
    [[self bkmxDocWinCon] updateWindowForStark:nil] ;
    
    // Removed in BookMacster 1.11
    //    if ([info objectForKey:constKeyThisUserIxportStartDate]) {
    //        // This was an ixport operation and other BookMacsters have been locked out.
    //        // by writing a key to user defaults.  Relinquish the lock.
    //        [[NSUserDefaults standardUserDefaults] removeObjectForKey:constKeyThisUserIxportStartDate] ;
    //        [[NSUserDefaults standardUserDefaults] synchronize] ;
    //    }
    
    NSArray* directories = [info objectForKey:constKeySafariLockDirectories] ;
    for (NSString* directory in directories) {
        [SafariSyncGuardian relinquishLockForDirectory:directory] ;
    }
    
    BOOL ok ;
    if (error) {
        ok = NO ;
        [self handleErrorInOperationInfo:info] ;
    }
    else {
        ok = YES ;
        [[self bkmxDocWinCon] selectNewestIxportLog] ;
        if ([[info objectForKey:constKeyDoReportDupes] boolValue] == YES) {
            if ([[info objectForKey:constKeyDupeDic] count] > 0) {
                if ([[BkmxBasis sharedBasis] isBkmxAgent]) {
                    [self showDupesReportAsAgentWithInfo:info];
                } else {
                    [self showDupesReport];
                }
            }
            else {
                if (![[BkmxBasis sharedBasis] isScripted]) {
                    SSYAlert* alert = [SSYAlert alert] ;
                    [alert setSmallText:@"No new duplicates were found."] ;
                    [self runModalSheetAlert:alert
                                  resizeable:NO
                                   iconStyle:SSYAlertIconInformational
                               modalDelegate:nil
                              didEndSelector:NULL
                                 contextInfo:NULL] ;
                }
            }
        }
        
        [self addSuccessfulIxporter:[info objectForKey:constKeyIxporter]] ;
    }
    
    [self doMoreDoneInvocationsFromInfo:info] ;
    
    // The following was necessary because of my use of beginManualUndoGrouping,
    // and NSUndoManager.  According
    // to my tests (DepartmentAndEmployees_Dirty) and Graham Cox,
    // http://lists.apple.com/archives/Cocoa-dev/2009/Nov/msg00818.html
    // there is a bug in NSUndoManager which causes an empty undo task to be
    // recorded, which sends a notification that results in the document's
    // -isDocumentEdited returning YES, whenever an undo group is ended,
    // even if the group is empty.  But this bug is not present in GCUndoManager.
    //    if (![[self chaker] hasAnyChanges] && ![info objectForKey:constKeyDocumentWasDirty]) {
    //        [self clearAllChanges] ;
    //    }
    // Woohoo!!
    
    
    // Prior to BookMacster version 1.3.21, the following section was *after* the
    // grand done invocation below.  However, if the document had never been exported
    // while closing, and user got the warning and clicked "Export and Close", the
    // document was apparently in the grand done invocation, and the following would
    // find the ixporter invalidated because the grand done invocation did this
    // call stack:
    //   post:SSYUndoManagerDocumentWillCloseNotification
    //      bkmxDocWillClose
    //         cleanUpDocSupportMocs
    //            destroyManagedObjectContext
    //               ixporter becomes invalidated
    // Putting this section before -doGrandDoneInfo: fixed that problem.
    if ([ixporter isAnExporter]) {
        BOOL exportFailed = [SSYOperationQueue operationGroupsSameInfo:info
                                                             otherInfo:[error userInfo]] ;
        
        if (exportFailed) {
            [[ixporter client] setFailedLastExport:[NSNumber numberWithBool:YES]] ;
        }
        else {
            [[ixporter client] setFailedLastExport:nil] ;
            [[ixporter client] clearUnexportedDeletions] ;
        }
        [[self macster] postTouchedClient:[ixporter client]
                                 severity:1] ;
        
        if (
            [[info objectForKey:constKeyPauseSyncersIfUserCancelsExport] boolValue]
            &&
            (
             // The following will be YES if user clicked "Test Run" instead of "Export Anyhow":
             [[info objectForKey:constKeyIsTestRun] boolValue]
             ||
             // The following will be YES if user clicked "Cancel" instead of "Export Anyhow":
             [[info objectForKey:constKeySSYOperationQueueError] involvesCode:constBkmxErrorUserCancelled]
             )
            ) {
                [[BkmxBasis sharedBasis] logFormat:@"Pausing Syncers due to Test Run"] ;
                [[self macster] pauseSyncers] ;
            }
    }
    
    [self doGrandDoneInfo:info] ;
    
    [[BkmxBasis sharedBasis] endAndWriteDebugTrace];
    
    /* See Note WhyClearOutInfo, below */
    [info removeAllObjects];
    
    return ok ;
}

/* Note WhyClearOutInfo
 [info removeAllObjects was  added on 20181220 and was found to cause info to
 be deallocced at the end of an import or export operation, which was not
 happening if ixport style was 2 and process was BkmxAgent.  I do not
 understand what is going on.  First of all, it is strange that the leak only
 occurs in style 2 and only when running in BkmxAgent.  More stangely, I tried
 to figure out which non-archivable object in `info` was involved in the retain
 cycle, presuming that an archivable object could not be involved in a retain
 cycle.  Result: I got down to the point where only archivable objects were in
 dictionary, see list below, and `info` still leaked!
 
 key: value
 ---- -----
 agentDoesImport: __NSCFBoolean
 clientTask: __NSCFNumber
 isDoneSelectorName: __NSCFConstantString
 agentUri: __NSCFString
 deference: __NSCFNumber
 didClaimBaton: __NSCFBoolean
 didExportAnything: __NSCFBoolean
 dontStopOthersIfError: __NSCFBoolean
 triggerUri: __NSCFString
 didTryWrite: __NSCFBoolean
 secondPrep: __NSCFBoolean
 succeeded: __NSCFBoolean
 didReadExternal: __NSCFBoolean
 performanceType: __NSCFNumber
 serialString: NSTaggedPointerString
 Info Leak Detector: SSYDeallocDetector
 SSYOperationGroup: __NSCFString
 keepSourceNotDestin: __NSCFBoolean
 isLastIxporter: __NSCFBoolean
 */


// This is the method which is invoked directly by IBAction
// Unlike other commands, this one does not block, and since it takes so long,
// we don't want it to block.  But blocking is inherent in SSYQueuedOperation.
// For example, we cannot return an error unless we block.  Therefore, we do
// not use SSYQueued operation for -verify initiated by a user's IBAction.
- (void)verifyAllSince:(NSDate*)since
         plusAllFailed:(BOOL)plusAllFailed
         waitUntilDone:(BOOL)waitUntilDone {
    [[self broker] verifyStarks:[[[self starker] root] extractLeavesOnly]
                     verifyType:BrokerVerifyTypeRegularVerify
                          since:since
                  plusAllFailed:plusAllFailed
               ignoreNoInternet:NO
                  waitUntilDone:NO
                        error_p:NULL] ;
    // Note that with waitUntilDone:NO, the above method will return
    // YES immediately and display the error itself
}

// This is the method which is invoked by BkmxAgent
- (void)verifyAll {
    NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 [[[self starker] root] extractLeavesOnly], constKeyStarkload,
                                 [NSDate distantFuture], constKeyVerifySince,
                                 [NSNumber numberWithBool:YES], constKeyIgnoreNoInternet,
                                 nil] ;
    
    NSArray* selectorNames = [NSArray arrayWithObjects:
                              @"verify",
                              nil] ;
    
    /*  If we are running under AppleScript then tell operationQueue to block this thread.
     If we did not do this, AppleScript would return to the scripter before
     all operations were complete. */
    [[self operationQueue] queueGroup:NSStringFromSelector(_cmd)
                                addon:NO
                        selectorNames:selectorNames
                                 info:info
                                block:NO
                           doneThread:[NSThread mainThread]
                           doneTarget:self
                         doneSelector:@selector(finishGroupOfOperationsWithInfo:)
                         keepWithNext:NO] ;
}

- (void)showDupesReport {
    [self revealTabViewIdentifier:constIdentifierTabViewDupes];
}

- (void)showDupesReportAsAgentWithInfo:(NSDictionary*)info {
    if ([[BkmxBasis sharedBasis] isBkmxAgent]) {
        NSInteger count = [[info objectForKey:constKeyDupeDic] count];
        if (count > 0) {
            NSString* msg = [NSString stringWithFormat:
                             @"%@\n%@\n\n%@\n\n%@",
                             [NSString localizeFormat:
                              @"found%0",
                              [NSString localizeFormat:
                               @"dupesGroupsN",
                               count]],
                             [[NSDate date] medDateShortTimeString],
                             [NSString localizeFormat:@"viewWhatLaunchN",
                              [[BkmxBasis sharedBasis] appNameLocalized],
                              [[NSString localize:@"080_dupes"] lowercaseString],
                              [NSString localize:@"view_v"]],
                             [NSString localizeFormat:@"viewWhatT",
                              [[BkmxBasis sharedBasis] appNameLocalized],
                              [NSString localize:@"laterNext"]]] ;
            CFOptionFlags response ;
            // The following returns whether it "cancelled OK".
            // I'm not sure what that means.  But I don't need it now, anyhow.
            CFUserNotificationDisplayAlert (
                                            0,  // no timeout
                                            0,
                                            [AgentPerformer iconUrl],
                                            NULL,
                                            NULL,
                                            (CFStringRef)constAppNameBkmxAgent,
                                            (CFStringRef)msg,
                                            (CFStringRef)[NSString localize:@"laterNext"],
                                            (CFStringRef)[NSString localize:@"view_v"],
                                            NULL,
                                            &response) ;
            if (response == kCFUserNotificationAlternateResponse) {
                [[NSUserDefaults standardUserDefaults] setAndSyncMainAppBool:YES
                                                                      forKey:constKeyLaunchQuietlyNextTime] ;
                
                NSString* source ;
                source = [NSString stringWithFormat:
                          @"tell application \"%@\"\n"
                          @"   activate\n"
                          @"   set aBkmxDoc to open POSIX file \"%@\"\n"
                          @"   tell aBkmxDoc to reveal tab identifier Duplicates\n"
                          @"end tell",
                          [[NSBundle mainAppBundle] bundlePath],
                          // Prior to BookMacster version 1.3.19, the above was:
                          // [[BkmxBasis sharedBasis] mainAppNameUnlocalized]
                          // However that would sometimes tell the wrong version
                          // of BookMacster.  Arghhhh!!!
                          // bundlePath is typically /Applications/BookMacster.app
                          self.fileURL.path] ;
                [SSYAppleScripter executeScriptSource:source
                                      ignoreKeyPrefix:nil
                                             userInfo:nil
                                 blockUntilCompletion:NO
                                      failSafeTimeout:21.345
                                    completionHandler:NULL];
            }
        }
    }
}

- (void)showVerifyReport {
    [self revealTabViewIdentifier:constIdentifierTabViewVerify] ;
}

#pragma mark * Closing and Memory Management

- (void)canCloseDeferToSuperWithInfo:(NSDictionary*)canCloseInfo {
    [super canCloseDocumentWithDelegate:[canCloseInfo objectForKey:constKeyCanCloseDelegate]
                    shouldCloseSelector:[[canCloseInfo objectForKey:constKeyCanCloseShouldCloseSelector] pointerValue]
                            contextInfo:[[canCloseInfo objectForKey:constKeyCanCloseContextInfo] pointerValue]];
    [canCloseInfo release];
}

- (void)ensureQueuedSelectorName:(NSString*)selectorName
                        moreInfo:(NSDictionary*)moreInfo{
    BOOL closeAlreadyQueued = NO ;
    for (SSYOperation* operation in [[self operationQueue] operations]) {
        if ([operation isKindOfClass:[SSYOperation class]]) {
            NSString* aSelectorName = NSStringFromSelector([operation selector]) ;
            if ([aSelectorName isEqualToString:selectorName]) {
                closeAlreadyQueued = YES ;
                break ;
            }
        }
    }
    
    if (!closeAlreadyQueued) {
        NSMutableDictionary* info = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     self, constKeyDocument,
                                     nil];
        if (moreInfo) {
            [info addEntriesFromDictionary:moreInfo];
        }
        
        NSArray* selectorNames = [NSArray arrayWithObjects:
                                  selectorName,
                                  nil] ;
        
        [[self operationQueue] queueGroup:[NSString stringWithFormat:@"Appended on the fly: %@", selectorName]
                                    addon:NO
                            selectorNames:selectorNames
                                     info:info
                                    block:NO
                               doneThread:[NSThread mainThread]
                               doneTarget:nil
                             doneSelector:NULL
                             keepWithNext:NO] ;
        [info release] ;
    }
}

/* This is some sample code, apparently from a Apple engineer, in Nov 2001,
 demonstrating how to override -[NSDocument canCloseDocumentWithDelegate:shouldCloseSelector:contextInfo:]
 https://lists.apple.com/archives/Cocoa-dev/2001/Nov/msg00940.html
 I updated it a little.
 */

//typedef struct {
//    id delegate;
//    SEL shouldCloseSelector;
//    void *contextInfo;
//} CanCloseAlertContext;
//
//- (void)canCloseAlertSheet:(NSWindow *)inAlertSheet
//           didEndAndReturn:(int)inReturnCode
//           withContextInfo:(void *)inContextInfo {
//    CanCloseAlertContext *canCloseAlertContext = inContextInfo;
//
//    // The user's dismissed our "save changes?" alert sheet. What happens next depends on how the dismissal was done.
//    if (inReturnCode==NSAlertFirstButtonReturn) {
//
//        // The document is not to be saved. Tell the delegate of the original -canCloseDocumentWithDelegate:... to just continue closing.
//        if (canCloseAlertContext->shouldCloseSelector) {
//            void (*callback)(id, SEL, NSDocument *, BOOL, void *) = (void (*)(id, SEL, NSDocument *, BOOL, void *))objc_msgSend;
//            (*callback)(canCloseAlertContext->delegate,
//                        canCloseAlertContext->shouldCloseSelector, self, YES,
//                        canCloseAlertContext->contextInfo);
//        }
//
//    } else if (inReturnCode==NSAlertFirstButtonReturn) {
//
//        // Explicitly dismiss the alert sheet here, because others may be about to be presented.
//        // (I don't remember if this is still necessary in 10.1, but NSDocument still does it, so it apparently doesn't hurt.)
//        if (inAlertSheet) [inAlertSheet orderOut:self];
//
//        // The document is to be saved. Save the document, taking advantage of the fact that in this situation "can close" will be synonymous with "did save."
//        [self saveDocumentWithDelegate:canCloseAlertContext->delegate
//                       didSaveSelector:canCloseAlertContext->shouldCloseSelector
//                           contextInfo:canCloseAlertContext->contextInfo];
//
//    } else {
//
//        // The closing was cancelled. Tell the delegate of the original -canCloseDocumentWithDelegate:... to not close.
//        if (canCloseAlertContext->shouldCloseSelector) {
//            void (*callback)(id, SEL, NSDocument *, BOOL, void *) =
//            (void (*)(id, SEL, NSDocument *, BOOL, void *))objc_msgSend;
//            (*callback)(canCloseAlertContext->delegate,
//                        canCloseAlertContext->shouldCloseSelector, self, NO,
//                        canCloseAlertContext->contextInfo);
//        }
//
//    }
//
//    // Free up the memory that was allocated in -canCloseDocumentWithDelegate:shouldCloseSelector:contextInfo:.
//    free(canCloseAlertContext);
//
//}
//
//- (void)canCloseDocumentWithDelegate:(id)inDelegate
//                 shouldCloseSelector:(SEL)inShouldCloseSelector contextInfo:(void*)inContextInfo {
//
//    // This method may or may not have to actually present the alert sheet.
//    if (![self isDocumentEdited]) {
//
//        // There's nothing to do. Tell the delegate to continue with the close.
//        // This really is how NSDocument invokes delegate selectors.
//        if (inShouldCloseSelector) {
//            void (*callback)(id, SEL, NSDocument *, BOOL, void *) =
//            (void (*)(id, SEL, NSDocument *, BOOL, void *))objc_msgSend;
//            (*callback)(inDelegate, inShouldCloseSelector, self, YES, inContextInfo);
//        }
//
//    } else {
//
//        // Figure out the window on which to present the alert sheet.  This should be easy if you only have one window per document.
//        NSWindow *documentWindow = [[[self windowController] windows] firstObject];
//
//        // Create a record of the context in which the panel is being shown, so we can finish up when it's dismissed.
//        CanCloseAlertContext *closeAlertContext = malloc(sizeof(CanCloseAlertContext));
//        closeContext->delegate = inDelegate;
//        closeContext->shouldCloseSelector = inShouldCloseSelector;
//        closeContext->contextInfo = inContextInfo;
//
//        // Present a "save changes?" alert as a document-modal sheet.
//        [documentWindow makeKeyAndOrderFront:nil];
//        NSBeginAlertSheet(@"Question about saving",
//                          @"",
//                          @"",
//                          @"",
//                          documentWindow,
//                          self,
//                          @selector(canCloseAlertSheet:didEndAndReturn:withContextInfo:),
//                          NULL,
//                          closeContext,
//                          @"Do you want to save???");
//
//    }
//
//}

- (void)canCloseDocumentWithDelegate:(id)delegate
                 shouldCloseSelector:(SEL)shouldCloseSelector
                         contextInfo:(void *)contextInfo {
    if ([[BkmxBasis sharedBasis] isBkmxAgent]) {
        return;
    }
    
    NSMutableDictionary* canCloseInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         delegate, constKeyCanCloseDelegate,
                                         [NSValue valueWithPointer:shouldCloseSelector], constKeyCanCloseShouldCloseSelector,
                                         [NSValue valueWithPointer:contextInfo], constKeyCanCloseContextInfo,
                                         nil] ;
    // canCloseInfo shall be released in -canCloseDeferToSuperWithInfo:
    
    if ([self.macster isPoisedToSync] && ![[NSUserDefaults standardUserDefaults] boolForKey:constKeyUserHasBeenToldAboutBkmxNotifierA]) {
        /* At this point, user must quit System Preferences if running because,
         unfortunately but apparently, the list of apps in System Preferences >
         Notification Center only updates when System Preferences is launched.
         So if System Preferences is left running at this point, it will not
         show in the list of apps, so the user will not be able to set
         BkmxNotifier-A to "Alerts".  I tried quitting System Preferences
         programatically, but that evoked a stupid "BookMacster wants to
         control System Preferences – Do you want to allow this?" alert. */
        NSString* mustQuitSysPrefs = @"";
        NSArray* runningApps = [[NSWorkspace sharedWorkspace] runningApplications];
        for (NSRunningApplication* runningApp in runningApps) {
            /* Since the bundle identifier or path of System Preferences.app
             could change in a future version of macOS, we do the best we
             can and test for either. */
            if ([runningApp.bundleIdentifier isEqualToString: @"com.apple.systempreferences"]
                || [runningApp.bundleURL isEqual:[NSURL fileURLWithPath:@"/System/Applications/System Preferences.app"]]) {
                mustQuitSysPrefs = @"• Quit System Preferences.\n";
            }
        }
        
        NSString* alertAboutAlertMsg = [NSString stringWithFormat:
                                        @"%@"
                                        @"• Read the next 3 steps.\n"
                                        @"• Click \"Go\" (below).\n"
                                        @"• If asked, in the top right corner of yuor screen, please \"Allow\" BkmxNotifier-A to send Notifications.\n"
                                        @"• In the System Preferences > Notification Center which shall appear, select BkmxNotifier-A and ensure that its \"alert style\" is set to \"Alerts\".\n\n"
                                        @"Here is why we ask you to do this:\n\n"
                                        @"Syncing is done by our helper Agent, BkmxAgent.  If BkmxAgent ever detects a problem which causes syncing to stop, BkmxAgent will send a notification to macOS Notification Center, via its special notifier app for Alerts.  This notifier app is named \"BkmxNotifier-A\".\n\n"
                                        @"Without this notification, you might not know that your bookmarks are no longer being managed or synced due to a problem.",
                                        mustQuitSysPrefs];
        SSYAlert* alert = [SSYAlert alert];
        [alert setTitleText:@"Please configure Alerts for Syncing"];
        [alert setSmallText:alertAboutAlertMsg];
        [alert setButton1Title:@"Go"];
        
        [self runModalSheetAlert:alert
                      resizeable:NO
                       iconStyle:SSYAlertIconInformational
                   modalDelegate:self
                  didEndSelector:@selector(didEndTellAboutBkmxNotifierASheet:returnCode:canCloseInfo:)
                     contextInfo:canCloseInfo] ;
        
    } else {
        [self continueCanCloseWithDummySelector:@selector(description)
                                   canCloseInfo:canCloseInfo] ;
    }
}

- (void)didEndTellAboutBkmxNotifierASheet:(NSWindow*)sheet
                               returnCode:(NSInteger)returnCode
                             canCloseInfo:(NSMutableDictionary*)canCloseInfo {
    [(BkmxAppDel*)[NSApp delegate] demoPresentUserNotificationWithTitle:@"This is a demo"
                                                         alertNotBanner:YES
                                                               subtitle:@"This is only a demo"
                                                                   body:@"More details will appear here"
                                                              soundName:@"BookMacsterSyncFailMajor"
                                                                 window:[[self bkmxDocWinCon] window]];
    
    /* This delay is to ensure (well, increase the probability) that
     BkmxNotifier-A will be listed in Notification Center when we open it
     in the next section.  I know it is not there until we add our first
     notification (above).  But I have no idea how long it takes  I
     therefore decided to sleep for 3 seconds, which seems kind of long, but
     the user will be busing reading our demo notification and clicking
     "Allow" during this time anynow.  2 seconds worked too, in a sample of 1.
     
     Also, see Note OpeningSystemPreferencePanes */
    NSURL* url = [NSURL URLWithString:@"x-apple.systempreferences:com.apple.preference.notifications"];
    [[NSWorkspace sharedWorkspace] performSelector:@selector(openURL:)
                                        withObject:url
                                        afterDelay:3.0];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES
                                            forKey:constKeyUserHasBeenToldAboutBkmxNotifierA];
    
    [self continueCanCloseWithDummySelector:@selector(description)
                               canCloseInfo:canCloseInfo];
}

/* The dummySelector is needed to prevent a compiler warning about leaking the
 canCloseInfo where the caller ends while canCloseInfo still has a +1 retain
 count, which is necessary.  Note that the caller must pass a non-NULL dummy
 selector, not NULL. */
- (void)continueCanCloseWithDummySelector:(SEL)dummySelectorNotUsed
                             canCloseInfo:(NSMutableDictionary*)canCloseInfo {
    // Validate agents.  If invalid agents
    // are found, we will asynchronously detour to invalidAgentSheetDidEnd:returnCode:contextInfo:.
    // Otherwise, or if user chooses "Close Anyhow" in the detour,
    // we will invoke on to -canCloseDeferToSuperWithInfo: which will
    // finally invoke the super of this method.
    
    NSString* badAgentMsg = nil ;
    NSInteger agentIndex = 0 ;
    NSInteger commandIndex = NSNotFound ;
    NSString* key = nil ;
    for (Syncer* syncer in [[self macster] syncersOrdered]) {
        NSArray* commands = [syncer commandsOrdered] ;
        
        // Check that results are either exported or saved
        key = constKeyDontWarnBadCommandEnd ;
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:key] boolValue]) {
            Command* lastCommand = [commands lastObjectSafely] ;
            if (
                ![[lastCommand method] isEqualToString:NSStringFromSelector(@selector(saveDocument))]
                &&
                ![[lastCommand method] isEqualToString:constMethodPlaceholderExport1]
                &&
                ![[lastCommand method] isEqualToString:constMethodPlaceholderExportAll]
                ) {
                    badAgentMsg = [NSString localizeFormat:
                                   @"agentBadEnd",
                                   [[BkmxBasis sharedBasis] labelCommands],
                                   [[BkmxBasis sharedBasis] labelExport],
                                   [[BkmxBasis sharedBasis] labelSave]] ;
                    commandIndex = [[lastCommand index] integerValue] ;
                    break ;
                }
        }
        
        agentIndex++ ;
    }
    
    if (badAgentMsg) {
        // Invalid syncer(s) were found.  Display message and end.
        SSYAlert* alert = [SSYAlert alert] ;
        [alert setSmallText:badAgentMsg] ;
        [alert setButton1Title:[[BkmxBasis sharedBasis] labelCloseAnyhow]] ;
        [alert setButton2Title:[[BkmxBasis sharedBasis] labelCancel]] ;
        [alert setButton3Title:[[BkmxBasis sharedBasis] labelFix]] ;
        [alert setCheckboxTitle:[NSString localize:@"dontShowAdvisoryAgain"]] ;
        
        [canCloseInfo setObject:key
                         forKey:constKeyProblemKey];
        [canCloseInfo setObject:[NSNumber numberWithInteger:agentIndex]
                         forKey:constKeyBadAgentIndex];
        [canCloseInfo setObject:[NSNumber numberWithInteger:commandIndex]
                         forKey:constKeyBadCommandIndex];
        
        [self runModalSheetAlert:alert
                      resizeable:NO
                       iconStyle:SSYAlertIconInformational
                   modalDelegate:self
                  didEndSelector:@selector(invalidAgentSheetDidEnd:returnCode:contextInfo:)
                     contextInfo:canCloseInfo] ;
    }
    else if (m_closeWasRequested || ([[[self operationQueue] operations] count] == 0)) {
        // If we got here because m_closeWasRequested, that means that this is the
        // second time that the user has commanded that this document be closed,
        // so we assume that she *really* means it.
        
        // I added the following section in BookMacster 1.9.8 after I produced
        // the familiar autosave hang by clicking the 'close' button twice while
        // a sync redo operation was running.  See Note 20120205.
        BOOL okToDoIt = YES ;
        for (NSOperation* operation in [[self operationQueue] operations]) {
            if ([operation isKindOfClass:[SSYOperation class]]) {
                SSYOperation* ssyOperation = (SSYOperation*)operation ;
                if ([ssyOperation selector] == @selector(reallyAutosave)) {
                    // Now at this point I'd like to either execute the autosave
                    // or maybe fake it by invoking its completion handler.
                    // Unfortunately, executing *either* of the following lines will
                    // cause a crash.  But at least they're different crashes!
                    // [self reallyAutosaveWithCompletionHandler:completionHandler] ;
                    // void (^completionHandler)(NSError*) = [[ssyOperation info] objectForKey:constKeyCompletionHandler] ; if (completionHandler) {completionHandler(nil) ;}
                    // So we do this instead
                    NSLog(@"Warning 513-4933  User really wants to close but sorry autosave is queued") ;
                    okToDoIt = NO ;
                    break ;
                }
            }
        }
        
        if (okToDoIt) {
            if ([[[self operationQueue] operations] count] > 0) {
                SSYAlert* alert = [SSYAlert alert] ;
                [alert setSmallText:@"Will close after operations in process are done."] ;
                [alert setButton1Title:nil] ;
                [self runModalSheetAlert:alert
                              resizeable:NO
                               iconStyle:SSYAlertIconCritical
                           modalDelegate:nil
                          didEndSelector:NULL
                             contextInfo:NULL] ;
                
                /* In the following, it seems it would be more appropriate to pass
                 @"reallyAutosave" and @(NSAutosaveInPlaceOperation).  However,
                 that causes a crash when the non-nil completion handler is called in
                 -[BSManagedDocument saveToURL:ofType:forSaveOperation:completionHandler:].
                 Using @"saveDocument" and @(NSSaveOperation) ==> no crash.  Well, I don't
                 have time now to study this, so I'm leaving it like that.  It saves and
                 does not crash (macOS 10.14.4).  Good enough. */
                if ([[self class] autosavesInPlace]) {
                    [self ensureQueuedSelectorName:@"saveDocument"
                                          moreInfo:@{
                        constKeySaveOperation: @(NSSaveOperation)
                    }];
                }
                
                [self ensureQueuedSelectorName:@"closeDocument"
                                      moreInfo:nil];
            }
            
            [self canCloseDeferToSuperWithInfo:canCloseInfo] ;
        } else {
            [self abortClosingWithInfo:canCloseInfo];
        }
    }
    else {
        m_closeWasRequested = YES ;
        [self abortClosingWithInfo:canCloseInfo];
    }
}

- (void)abortClosingWithInfo:(NSDictionary*)canCloseInfo {
    SEL shouldCloseSelector = [[canCloseInfo objectForKey:constKeyCanCloseShouldCloseSelector] pointerValue];
    void* contextInfo = [[canCloseInfo objectForKey:constKeyCanCloseContextInfo] pointerValue];
    BOOL shouldClose = NO;
    NSInvocation* invocation = [NSInvocation invocationWithTarget:self
                                                         selector:shouldCloseSelector
                                                  retainArguments:YES
                                                argumentAddresses:&self, &shouldClose, &contextInfo];
    [invocation invoke];
    
    [canCloseInfo release];
}

- (void)unexportedChangesSheetDidEnd:(SSYAlertWindow*)sheet
                          returnCode:(NSInteger)returnCode
                         contextInfo:(NSDictionary*)info {
    switch (returnCode) {
        case NSAlertFirstButtonReturn:
            // Go ahead and close anyhow
            [self canCloseDeferToSuperWithInfo:info] ;
            break ;
        case NSAlertSecondButtonReturn:
            // Cancel
            break ;
        case NSAlertThirdButtonReturn:;
            // Export
            NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         // Since we've definitely got the GUI here, deference is ask
                                         [NSNumber numberWithInteger:BkmxDeferenceAsk], constKeyDeference,
                                         [NSNumber numberWithInteger:BkmxPerformanceTypeUser], constKeyPerformanceType,
                                         [NSNumber numberWithBool:YES], constKeyIfNotNeeded,
                                         [NSNumber numberWithBool:YES], constKeyDidMirror,
                                         nil] ;
            [self exportPerInfo:info] ;
            break ;
        default:
            break ;
    }
    
    [info release] ;
}

- (void)invalidAgentSheetDidEnd:(SSYAlertWindow*)sheet
                     returnCode:(NSInteger)returnCode
                    contextInfo:(NSDictionary*)canCloseInfo {
    NSString* key = [canCloseInfo objectForKey:constKeyProblemKey] ;
    NSInteger badAgentIndex = [[canCloseInfo objectForKey:constKeyBadAgentIndex] integerValue] ;
    NSInteger badCommandIndex = [[canCloseInfo objectForKey:constKeyBadCommandIndex] integerValue] ;
    
    if (([sheet checkboxState] == NSControlStateValueOn)  && key) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES]
                                                  forKey:key] ;
    }
    
    switch (returnCode) {
        case NSAlertFirstButtonReturn:
            // Go ahead and close anyhow
            [self canCloseDeferToSuperWithInfo:canCloseInfo] ;
            break ;
        case NSAlertSecondButtonReturn:
            // Cancel
            [self abortClosingWithInfo:canCloseInfo];
            break ;
        case NSAlertThirdButtonReturn:
            // Fix
            [[self bkmxDocWinCon] exposeUIForUserToFixBadAgentIndex:badAgentIndex
                                                    badCommandIndex:badCommandIndex] ;
            [self abortClosingWithInfo:canCloseInfo];
            break ;
        default:
            NSAssert(NO, @"Internal Error 524-3838");
            break ;
    }
}

- (void)tearDownOnce {
    if ([self isZombie]) {
        // This method has already been run
        return ;
    }
    
    // Was here: [self unlinkBkmxDocMacster]
    
    for (NSTimer* timer in [self cleaningTimers]) {
        [timer invalidate] ;
    }
    [self setCleaningTimers:nil] ;  // Defensive programming
    
    [self clearPostLandingTimer] ;
    [self clearNukePaveWarnTimer] ;
    
    if ([self isReverting]) {
        // We're not really going away yet, but Core
        // Data sends a -close during -revert.
        return ;
    }
    
    /* The following, added in BookMacster 1.21, cancels, for examle,
     -[Macster warnSyncingAffected], which was found to cause a crash if
     user closed document within 1.5 seconds of evoking this delayed perform. */
    [NSObject cancelPreviousPerformRequestsWithTarget:[self macster]] ;
    
    /*
     Prior to BookMacster 1.17, I did this earlier, see "Was here:"
     I did this because, I said that "the -macster becomes faulted
     even during a -revert".  I think that, with the checks I added
     in -cleanUpDocSupportMocs, that is no longer true.  And it does
     not make sense to unlink twice, which was still happening
     until I moved this down here.
     */
    [self unlinkBkmxDocMacster] ;
    
    [self setIsZombie:YES] ;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SSYUndoManagerDocumentWillCloseNotification
                                                        object:self] ;
    
    [_broker setDocument:nil] ;
    if (m_starker) {
        /* The above `if` is to prevent deadlock during Core Data migration. */
        [[self starker] setOwner:nil];
    }
    [[self undoManager] removeAllActions];
    
    // Note that we needed to send the notification, above, before removing the document
    // as an observer of such notifications…
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
    [[MAKVONotificationCenter defaultCenter] removeObserver:self] ;
    
    if ([[BkmxBasis sharedBasis] isBkmxAgent]) {
        // Try to clean up any retain cycles so that BkmxDoc will be deallocced.
        [self forgetOperationQueue];
        [self forgetStarkerAndTagger];
        [self forgetStarxider];
        [self forgetStarlobuter];
        [[self settingsMoc] reset];
        [[self exidsMoc] reset];
        [[self diariesMoc] reset];
        [self.shig breakRetainCycles];
        [self.dupetainer breakRetainCycles];
        [self.importedExtores removeAllObjects];
        [m_shig release];
        m_shig = nil;
        [m_dupetainer release];
        m_dupetainer = nil;
        [[self managedObjectContext] reset];
    } else {
        // We don't have the retain cycle problem for some reason.
        // And some of that stuff may still be needed for KVO.
        // I've seen complaints regarding starker in particular
    }
    
    /* The following timeout wrapper was added in BkmkMgrs 3.0.8.
     
     Well, even after the "(moc != nil)" test was added in the next section,
     I found that just trying to *get* the managed object context could still
     get stuck in the following call stack, even though no other thread
     seems to be waiting on performSynchronousFileAccessUsingBlock in this app.
     
     #6    0x00000001b495c024 in -[NSDocument performSynchronousFileAccessUsingBlock:] ()
     #7    0x0000000100ca8628 in -[BkmxDoc performSynchronousFileAccessUsingBlock:] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/BkmxDoc.m:4855
     #8    0x0000000100c8a57c in -[BSManagedDocument managedObjectContext] at /Users/jk/Documents/Programming/Projects/BSManagedDocument/BSManagedDocument.m:128

     A document which exhibits this behavior is:
     Corrupt-Doc-Should-Make-Error-260-not-hang.bmco.  SQLitte Manager agrees,
     saying that that its `persistentStore` is not a good sqlite database.
     Mayabe it is because the -shm is missing.  Whatever!
     
     So, I wrapped `moc=self.managedObjectContext` in the
     following timeout.  The `timeooutSeconds` should be way more than
     enough to get the managed object context.
     
     Note: When this happens, after the timeout expires, and this method
     returns, and
     -[BkmxDocumentController makeDocumentForURL:withContentsOfURL:ofType:error:]
     returns, suddenly -[NSDocument performSynchronousFileAccessUsingBlock:]
     returns, which causes self.managedObjectContext in the block below returns
     a managed object context.  But by that time the Error 260 is already
     being generated, and the managed object context is destroyed.
     
     So the benefit of this timeout wrapper section is that the user gets
     the Error 260 (corrupt document) instead of the app hanging. */
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_queue_t aSerialQueue = dispatch_queue_create(
                                                          "GettingDocMocForTearDown",
                                                          DISPATCH_QUEUE_SERIAL
                                                          );
    NSManagedObjectContext* __block moc = nil;
    dispatch_async(aSerialQueue, ^{
        moc = self.managedObjectContext;
        dispatch_semaphore_signal(semaphore);
    });
    double timeooutSeconds = 5.0 ;
    int64_t timeoutNanoseconds = timeooutSeconds * 1e9 ;
    dispatch_time_t timeout = dispatch_time(
                                            DISPATCH_TIME_NOW,
                                            timeoutNanoseconds);
    dispatch_semaphore_wait(semaphore, timeout);
    dispatch_release(semaphore);

    if (moc != nil) {
        /* The above `if` is to prevent deadlock during document opening if
         the Core Data database is unreadable and we need to -tearDownOnce
         and bail out.  The call stack doing tearDownOnce will look like this:
         
         #4    0x000000019182993c in -[NSDocument performSynchronousFileAccessUsingBlock:] ()
         #5    0x000000010130a74c in -[BSManagedDocument managedObjectContext] at /Users/jk/Documents/Programming/Projects/BSManagedDocument/BSManagedDocument.m:129
         #6    0x0000000101333760 in -[BkmxDoc tearDownOnce] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/BkmxDoc.m:7571
         #7    0x0000000101324780 in -[BkmxDoc readFromURL:ofType:error:] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/BkmxDoc.m:3097
         #8    0x0000000191794acc in -[NSDocument _initWithContentsOfURL:ofType:error:] ()
         #9    0x00000001917949a0 in -[NSDocument initWithContentsOfURL:ofType:error:] ()
         #10    0x000000010131ff1c in -[BkmxDoc initWithContentsOfURL:ofType:error:] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/BkmxDoc.m:1816
         #11    0x00000001917f99a4 in -[NSDocumentController makeDocumentWithContentsOfURL:ofType:error:] ()
         #12    0x00000001011ea408 in -[BkmxDocumentController makeDocumentWithContentsOfURL:ofType:error:] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/BkmxDocumentController.m:1433
         #13    0x0000000191a048e4 in __97-[NSDocumentController makeDocumentWithContentsOfURL:alternateContents:ofType:completionHandler:]_block_invoke ()
         
         while the other call stack doing autosave will look like this:
         
         #4    0x000000019182993c in -[NSDocument performSynchronousFileAccessUsingBlock:] ()
         #5    0x000000010130a74c in -[BSManagedDocument managedObjectContext] at /Users/jk/Documents/Programming/Projects/BSManagedDocument/BSManagedDocument.m:129
         #6    0x000000010132b418 in -[BkmxDoc finalizeStarksLastModifiedDatesAndReturnIfNeededSaveOperationType:] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/BkmxDoc.m:5124
         #7    0x000000010132be4c in -[BkmxDoc reallyAutosaveWithCompletionHandler:] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/BkmxDoc.m:5455
         #8    0x0000000101345f50 in -[SSYOperation(Operation_Common) reallyAutosave_unsafe] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/Operation_Common.m:985
         */
        [SSYMOCManager destroyManagedObjectContext:moc];
    }
}

- (void)close {
    // Contrary to what I read in the documentation, this method seems
    // to always get invoked (macOS 10.7) before a document is closed.
    // However, it's pretty late in the game.  Window controllers (bkmxDocWinCon)
    // is already nil, and presumably the document window has already been closed.
    // If you need to do something before the window closes, -windowShouldClose
    // or windowWillClose: in the NSWindowController delegate.
    
    [[BkmxBasis sharedBasis] saveSettingsMocForIdentifier:[self uuid]] ;
    
    [self tearDownOnce];
    
    /* Testing in maOS 10.15.4, I found that, when closing due to
     AppleScript:
     •  tell application "BookMacster" to close every document
     this method would be called twice, so super will be called twice.
     Although the second call would return immediately, before the first call
     returned, indicating that maybe -[NSDocument close] has its own lockout to
     prevent documentation -[NSDocument close] does not mention that such
     nested calls are supported.  So, even though it did not fix the crash I am
     currently working on, I decided to leave in the following didSuperClose
     lockout. */
    if (!self.didSuperClose) {
        self.didSuperClose = YES;
        [super close];
    }
}

#if LOGGING_MEMORY_MANAGEMENT_FOR_BkmxDoc
- (id)retain {
    id x = [super retain] ;
    NSString* line = [NSString stringWithFormat:@"retained %03ld %@", (long)[self retainCount], SSYDebugCaller()] ;
    [SSYLinearFileWriter writeLine:line] ;
    return x ;
}
- (id)autorelease {
    id x = [super autorelease] ;
    NSString* line = [NSString stringWithFormat:@"autoreleased %@", SSYDebugCaller()] ;
    [SSYLinearFileWriter writeLine:line] ;
    return x ;
}

- (oneway void)release {
    NSInteger rc = [self retainCount] ;
    [super release] ;
    NSString* line = [NSString stringWithFormat:@"released %03ld %@", (long)rc, SSYDebugCaller()] ;
    [SSYLinearFileWriter writeLine:line] ;
    return ;
}
#endif

/*
 Note that this method normally runs about 10 seconds after the BkmxDoc window
 is closed.
 */
- (void)dealloc {
    [[BkmxBasis sharedBasis] logFormat:@"Dealloccing %@", self];

#if LOGGING_MEMORY_MANAGEMENT_FOR_BkmxDoc
    NSString* line = [NSString stringWithFormat:@"deallocced %p", self] ;
    [SSYLinearFileWriter writeLine:line] ;
    NSLog(@"%s %p", __PRETTY_FUNCTION__, self) ;
#endif
    // Developing BookMacster 1.5.4, I once got this complaint from, it seems,
    // an open-on-launch BkmxDoc that never really opened:
    // An instance 0xab9da0 of class BkmxDoc was deallocated while key value observers were still registered with it. Observation info was leaked, and may even become mistakenly attached to some other object. Set a breakpoint on NSKVODeallocateBreak to stop here in the debugger. Here's the current observation info:
    // <NSKeyValueObservationInfo 0xa16e70> (
    //                                       <NSKeyValueObservance 0xac01c0: Observer: 0xac00c0, Key path: fileURL, Options: <New: YES, Old: YES, Prior: NO> Context: 0x301880, Property: 0xa5f600>
    //                                      )
    // Maybe the invocation of this in -bkmxDocWillClose did not get invoked
    // under these circumstances?  Well, so I'll do it here again…
    [[MAKVONotificationCenter defaultCenter] removeObserver:self] ;
    
    // Probably defensive programming because this was already done in -tearDownOnce
    [self clearPostLandingTimer] ;
    [self clearNukePaveWarnTimer] ;
    
    [_priorSavedWithVersionString release];
    [_priorRequiresVersionString release];
    [_lastKnownLastSaveToken release];
    [m_talderMapper release];
    [m_macster release] ;
    [m_starker release] ;
    [m_tagger release];
    [m_operationQueue release] ;
    [_broker release] ;
    [m_shig release] ;
    [m_dupetainer release] ;
    [m_starxider release] ;
    [m_chaker release] ;
    [m_undoDateFormatter release] ;
    [m_importedExtores release] ;
    [m_savedWithVersion release] ;
    [m_error release] ;
    [lastContentTouchDate release] ;
    [verifySummary release] ;
    [m_clientLastPreImportedHashes release] ;
    [m_clientLastPreExportedHashes release] ;
    [m_clientLastImportedDates release] ;
    [m_successfulIxporters release] ;
    [m_starlobuter release] ;
    [m_cleaningTimers release] ;
    [m_waitForClientProfileBlocker release] ;
    [m_lastLandedBookmark release] ;
    [m_uuid release];
    
    [super dealloc] ;
}


#pragma mark * Startainer Protocol Conformance

- (BOOL)hasOrder {
    return YES ;
}

- (BOOL)hasFolders {
    return YES ;
}

-(BOOL)canPublicize {
    return YES ;
}

- (void)refreshHasHartainersCache {
    m_hasHartainersCache = HAS_HARTAINERS_IS_VALID_BIT ;
    for (Stark* stark in [[[self starker] root] childrenOrdered]) {
        if ([stark sharypeValue] == SharypeBar) {
            m_hasHartainersCache += HAS_HARTAINERS_BAR_BIT ;
        }
        else if ([stark sharypeValue] == SharypeMenu) {
            m_hasHartainersCache += HAS_HARTAINERS_MENU_BIT ;
        }
        else if ([stark sharypeValue] == SharypeUnfiled) {
            m_hasHartainersCache += HAS_HARTAINERS_UNFILED_BIT ;
        }
        else if ([stark sharypeValue] == SharypeOhared) {
            m_hasHartainersCache += HAS_HARTAINERS_OHARED_BIT ;
        }
    }
}

- (void)clearHasHartainersCache {
    m_hasHartainersCache = HAS_HARTAINERS_UNKNOWN ;
}

- (BOOL)hasBar {
    if (m_hasHartainersCache == HAS_HARTAINERS_UNKNOWN) {
        [self refreshHasHartainersCache] ;
    }
    
    BOOL answer =  ((m_hasHartainersCache & HAS_HARTAINERS_BAR_BIT) > 0) ;
    return answer ;
}
+ (NSSet*)keyPathsForValuesAffectingHasBar {
    return [NSSet setWithObjects:
            @"starker.hartainersChangeCount",
            nil] ;
}

-(BOOL)hasMenu {
    if (m_hasHartainersCache == HAS_HARTAINERS_UNKNOWN) {
        [self refreshHasHartainersCache] ;
    }
    
    BOOL answer =  ((m_hasHartainersCache & HAS_HARTAINERS_MENU_BIT) > 0) ;
    return answer ;
}
+ (NSSet*)keyPathsForValuesAffectingHasMenu {
    return [NSSet setWithObjects:
            @"starker.hartainersChangeCount",
            nil] ;
}

- (BOOL)hasUnfiled {
    if (m_hasHartainersCache == HAS_HARTAINERS_UNKNOWN) {
        [self refreshHasHartainersCache] ;
    }
    
    BOOL answer =  ((m_hasHartainersCache & HAS_HARTAINERS_UNFILED_BIT) > 0) ;
    return answer ;
}
+ (NSSet*)keyPathsForValuesAffectingHasUnfiled {
    return [NSSet setWithObjects:
            @"starker.hartainersChangeCount",
            nil] ;
}

- (BOOL)hasOhared {
    if (m_hasHartainersCache == HAS_HARTAINERS_UNKNOWN) {
        [self refreshHasHartainersCache] ;
    }
    
    BOOL answer = ((m_hasHartainersCache & HAS_HARTAINERS_OHARED_BIT) > 0) ;
    return answer ;
}
+ (NSSet*)keyPathsForValuesAffectingHasOhared {
    return [NSSet setWithObjects:
            @"starker.hartainersChangeCount",
            nil] ;
}

- (void)addHartainerOfSharype:(Sharype)sharype {
    // Fetch (if there is one)
    Stark* stark = [[self starker] starkOfSharype:sharype] ;
    
    if (!stark) {
        stark = [[self starker] freshDatedStark] ;
        [stark setSharypeValue:sharype] ;
        [stark setIsExpanded:[NSNumber numberWithBool:YES]] ;
        
        // This section added in BookMacster 1.11
        [self clearHasHartainersCache] ;
        NSInteger index = 0 ;
        switch (sharype) {
            case SharypeOhared:
                if ([self hasUnfiled]) {
                    index += 1 ;
                }
            case SharypeUnfiled:
                if ([self hasMenu]) {
                    index += 1 ;
                }
            case SharypeMenu:
                if ([self hasBar]) {
                    index += 1 ;
                }
            default:
                break;
        }
        
        [stark moveToBkmxParent:[[self starker] root]
                        atIndex:index
                        restack:YES] ;
        
        // By default, SharypeUnfiled is unsorted.
        if (sharype == SharypeUnfiled) {
            [stark setSortable:@0] ;
        }
    }
}

- (void)removeHartainerOfSharype:(Sharype)sharype {
    // Fetch (if there is one)
    Stark* stark = [[self starker] starkOfSharype:sharype] ;
    
    if ([stark numberOfChildren] == 0) {
        [stark remove] ;
    }
}

- (void)setHasBar:(NSNumber*)value {
    if ([value boolValue]) {
        [self addHartainerOfSharype:SharypeBar] ;
    }
    else {
        [self removeHartainerOfSharype:SharypeBar] ;
        Sharype preferredCatchypeValue = [[[self macster] preferredCatchype] sharypeValue] ;
        if (preferredCatchypeValue == SharypeBar) {
            // See not 20100317 below
            [[self macster] setPreferredCatchype:[NSNumber numberWithSharype:SharypeRoot]] ;
        }
    }
    
    // The above will often set the wrong action name, for example to
    // "Change Name" as an added Hard Folder's name is changed.
    // This will set the undo action name (back) to "Change Have These Hard Folders:"
    [self setUndoActionNameForAction:SSYModelChangeActionModify
                              object:self
                           objectKey:nil
                          updatedKey:constKeyHasBar
                               count:0] ;
}

- (void)setHasMenu:(NSNumber*)value {
    if ([value boolValue]) {
        [self addHartainerOfSharype:SharypeMenu] ;
    }
    else {
        [self removeHartainerOfSharype:SharypeMenu] ;
        Sharype preferredCatchypeValue = [[[self macster] preferredCatchype] sharypeValue] ;
        if (preferredCatchypeValue == SharypeMenu) {
            // See not 20100317 below
            [[self macster] setPreferredCatchype:[NSNumber numberWithSharype:SharypeRoot]] ;
        }
    }
    
    // The above will often set the wrong action name, for example to
    // "Change Name" as an added Hard Folder's name is changed.
    // This will set the undo action name (back) to "Change Have These Hard Folders:"
    [self setUndoActionNameForAction:SSYModelChangeActionModify
                              object:self
                           objectKey:nil
                          updatedKey:constKeyHasMenu
                               count:0] ;
}

- (void)setHasUnfiled:(NSNumber*)value {
    if ([value boolValue]) {
        [self addHartainerOfSharype:SharypeUnfiled] ;
    }
    else {
        [self removeHartainerOfSharype:SharypeUnfiled] ;
        Sharype preferredCatchypeValue = [[[self macster] preferredCatchype] sharypeValue] ;
        if (preferredCatchypeValue == SharypeUnfiled) {
            // See not 20100317 below
            [[self macster] setPreferredCatchype:[NSNumber numberWithSharype:SharypeRoot]] ;
        }
    }
    
    // The above will often set the wrong action name, for example to
    // "Change Name" as an added Hard Folder's name is changed.
    // This will set the undo action name (back) to "Change Have These Hard Folders:"
    [self setUndoActionNameForAction:SSYModelChangeActionModify
                              object:self
                           objectKey:nil
                          updatedKey:constKeyHasUnfiled
                               count:0] ;
}

- (void)setHasOhared:(NSNumber*)value {
    if ([value boolValue]) {
        [self addHartainerOfSharype:SharypeOhared] ;
    }
    else {
        [self removeHartainerOfSharype:SharypeOhared] ;
        Sharype preferredCatchypeValue = [[[self macster] preferredCatchype] sharypeValue] ;
        if (preferredCatchypeValue == SharypeOhared) {
            // See not 20100317 below
            [[self macster] setPreferredCatchype:[NSNumber numberWithSharype:SharypeRoot]] ;
        }
    }
    
    // The above will often have set the wrong action name, for example to
    // "Change Name" as an added Hard Folder's name is changed.
    // This will set the undo action name (back) to "Change Have These Hard Folders:"
    [self setUndoActionNameForAction:SSYModelChangeActionModify
                              object:self
                           objectKey:nil
                          updatedKey:constKeyHasOhared
                               count:0] ;
}

// Note 20100317.  Until today (BookMacster 0.9.19) I setPreferredCatchype:nil
// Now, SharypeRoot is also the default value for Bookshig's preferredCatchype
// in the data model, so I changed it to that.  Neither answer is a good answer.
// However, this happens only momntarily, when a Macster is being automatically
// reconfigured for a different Import Client. 

- (NSArray*)availableHartainers {
    NSMutableArray* hartainers = [[NSMutableArray alloc] init] ;
    
    if (YES) {
        [hartainers addObject:[NSNumber numberWithSharype:SharypeRoot]] ;
    }
    if ([self hasBar]) {
        [hartainers addObject:[NSNumber numberWithSharype:SharypeBar]] ;
    }
    if ([self hasMenu]) {
        [hartainers addObject:[NSNumber numberWithSharype:SharypeMenu]] ;
    }
    if ([self hasUnfiled]) {
        [hartainers addObject:[NSNumber numberWithSharype:SharypeUnfiled]] ;
    }
    if ([self hasOhared]) {
        [hartainers addObject:[NSNumber numberWithSharype:SharypeOhared]] ;
    }
    
    NSArray* answer = [[hartainers copy] autorelease] ;
    [hartainers release] ;
    
    return answer ;
}
+ (NSSet*)keyPathsForValuesAffectingAvailableHartainers {
    return [NSSet setWithObjects:
            constKeyHasBar,
            constKeyHasMenu,
            constKeyHasUnfiled,
            constKeyHasOhared,
            nil] ;
}

#if 0
// Removed in BookMacster 1.17 as it appears that this method is no longer used.
- (BOOL)supportsSharype:(Sharype)sharype {
    // BkmxDoc supports all Sharypes.
    return YES ;
}
#endif

- (BOOL)canEditAttribute:(NSString*)key
                 inStyle:(BkmxIxportStyle)style {
    // BkmxDoc supports editing any attribute
    return YES ;
}

- (Stark*)starkFromExtoreNode:(NSDictionary*)dic {
    return [ExtoreSafari starkFromExtoreNode:dic
                                     starker:self.starker
                                   clientoid:nil] ;
}

- (void)setToDefaultCollectionStark:(Stark*)addend
                     rootCollection:(Stark*)rootUnderConstruction
                      barCollection:(Stark*)barUnderConstruction
                     menuCollection:(Stark*)menuUnderConstruction
                   oharedCollection:(Stark*)oharedUnderConstruction
                  unfiledCollection:(Stark*)unfiledUnderConstruction {
    [addend moveToBkmxParent:rootUnderConstruction] ;
}

- (BOOL)rootSoftainersOk {
    return [[[self shig] rootSoftainersOk] boolValue] ;
}

- (BOOL)rootLeavesOk {
    return [[[self shig] rootLeavesOk] boolValue] ;
}

- (BOOL)rootNotchesOk {
    return [[[self shig] rootNotchesOk] boolValue] ;
}

// See Accessors section for more protocol conformance methods

#pragma mark * Successful Ixporters

- (void)clearSuccessfulIxporters {
    [m_successfulIxporters release] ;
    m_successfulIxporters = nil ;
}

- (void)addSuccessfulIxporter:(Ixporter*)ixporter {
    if (!ixporter) {
        return ;
    }
    
    if (!m_successfulIxporters) {
        m_successfulIxporters = [[NSMutableArray alloc] init] ;
    }
    
    [m_successfulIxporters addObject:ixporter] ;
}

- (NSArray*)successfulIxporters {
    return [NSArray arrayWithArray:m_successfulIxporters] ;
}


#pragma mark * Other Methods

- (NSString*)labelBar {
    NSString* answer = nil ;
    for (Client* client in [[self macster] clientsOrdered]) {
        Class extoreClass = [client extoreClass] ;
        NSString* possibleAnswer = [extoreClass labelBar] ;
        if (possibleAnswer) {
            if (![possibleAnswer isEqualToString:constDisplayNameNotUsed]) {
                answer = possibleAnswer ;
                break ;
            }
        }
    }
    
    if (!answer) {
        answer = [NSString localize:@"000_Safari7_bookmarksBar"] ;
    }
    
    return answer ;
}
+ (NSSet*)keyPathsForValuesAffectingLabelBar {
    return [NSSet setWithObjects:
            @"macster.clientsDummyForKVO",
            nil] ;
}

- (NSString*)labelMenu {
    NSString* answer = nil ;
    for (Client* client in [[self macster] clientsOrdered]) {
        Class extoreClass = [client extoreClass] ;
        NSString* possibleAnswer = [extoreClass labelMenu] ;
        if (possibleAnswer) {
            if (![possibleAnswer isEqualToString:constDisplayNameNotUsed]) {
                answer = possibleAnswer ;
                break ;
            }
        }
    }
    
    if (!answer) {
        answer = [NSString localize:@"004_Chrome_otherBookmarks"] ;
    }
    
    return answer ;
}
+ (NSSet*)keyPathsForValuesAffectingLabelMenu {
    return [NSSet setWithObjects:
            @"macster.clientsDummyForKVO",
            nil] ;
}

- (NSString*)labelEnableMenu {
    return [NSString stringWithFormat:@"Enable \"%@\"", [self labelMenu]] ;
}
+ (NSSet*)keyPathsForValuesAffectingLabelEnableMenu {
    return [NSSet setWithObjects:
            @"labelMenu",
            nil] ;
}

- (NSString*)labelUnfiled {
    NSString* answer = nil ;
    for (Client* client in [[self macster] clientsOrdered]) {
        Class extoreClass = [client extoreClass] ;
        NSString* possibleAnswer = [extoreClass labelUnfiled] ;
        if (possibleAnswer) {
            if (![possibleAnswer isEqualToString:constDisplayNameNotUsed]) {
                answer = possibleAnswer ;
                break ;
            }
        }
    }
    
    if (!answer) {
        answer = [NSString localize:@"000_Safari_bookmarksReadingList"] ;
    }
    
    return answer ;
}
+ (NSSet*)keyPathsForValuesAffectingLabelUnfiled {
    return [NSSet setWithObjects:
            @"macster.clientsDummyForKVO",
            nil] ;
}

- (NSString*)labelOhared {
    NSString* answer = nil ;
    for (Client* client in [[self macster] clientsOrdered]) {
        Class extoreClass = [client extoreClass] ;
        NSString* possibleAnswer = [extoreClass labelOhared] ;
        if (possibleAnswer) {
            if (![possibleAnswer isEqualToString:constDisplayNameNotUsed]) {
                answer = possibleAnswer ;
                break ;
            }
        }
    }
    
    if (!answer) {
        answer = [NSString localize:@"003_OmniWeb_Shared"] ;
    }
    
    return answer ;
}
+ (NSSet*)keyPathsForValuesAffectingLabelOhared {
    return [NSSet setWithObjects:
            @"macster.clientsDummyForKVO",
            nil] ;
}

- (NSString*)displayNameForHartainer:(NSNumber*)hartainer {
    Sharype sharypeValue = [hartainer shortValue] ;
    NSString* string ;
    
    switch (sharypeValue) {
        case SharypeRoot:
            string = [[BkmxBasis sharedBasis] labelRoot] ;
            break ;
        case SharypeBar:
            string = [self labelBar] ;
            break ;
        case SharypeMenu:
            string = [self labelMenu] ;
            break ;
        case SharypeUnfiled:
            string = [self labelUnfiled] ;
            break ;
        case SharypeOhared:
            string = [self labelOhared] ;
            break ;
        default:
            string = @"345-0091: See Console" ;
            NSLog(@"Internal Error 345-0091.  No display name for sharype %@", self) ;
    }
    
    return string ;
}

- (void)changeStringInTagWhichHasString:(NSString*)oldString
                               toString:(NSString*)newString {
    Tag* tag = [[self tagger] tagWithString:oldString];
    if (tag) {
        tag.string = newString;
    } else {
        NSLog(@"Internal Error 244-8574 Could not find tag with string %@ to change to %@",
              oldString,
              newString);
    }
}

- (BOOL)checkBreathError_p:(NSError**)error_p {
    BOOL ok = YES ;
    if (SSYLCCurrentLevel() < SSYLicenseLevelValid) {
        // Prefs does not have valid license info.
        // See if maybe the document has valid license info
        if (![self metalValid]) {
            ok = NO ;
        }
    }
    
    if (!ok && error_p) {
        *error_p = SSYMakeError(constBkmxErrorNotLicensedToWrite, @"") ;
        // The word "No" is sensible enough to not look ridiculous in
        // the error log, but not sensible enough to be found in a search
        // of the code by a cracker.
    }
    
    return ok ;
}

- (void)updateLastTouchedToNow:(NSNotification*)note {
    [[self shig] setLastTouched:[NSDate date]];
}

- (void)updateViews:(NSNotification*)note {
    [[self bkmxDocWinCon] invalidateFlatCache] ;
    [self clearHasHartainersCache] ;
    Stark* stark = [[note userInfo] objectForKey:constKeyStark] ;
    
    // Change the phony key to trigger observers
    // who are observing content
    [self setLastContentTouchDate:[NSDate date]] ;
    
    // We do this last because it may have progress bars running in
    // in textStatus, textStatus, etc.
    [[self bkmxDocWinCon] updateWindowForStark:stark] ;
}

- (void)clearUnexportedDeletions:(NSNotification*)note {
    for (Client* client in [[self macster] clients]) {
        [client clearUnexportedDeletions] ;
    }
}

- (BOOL)revealTabViewIdentifier:(NSString*)identifier {
    return [[self bkmxDocWinCon] revealTabViewIdentifier:identifier] ;
}

- (NSArray*)bookmarkContainers {
    NSMutableArray* containers = [[NSMutableArray alloc] init] ;
    Stark* root = [[self starker] root] ;
    [root classifyBySharypeDeeply:YES
                       hartainers:containers
                      softFolders:containers
                           leaves:nil
                          notches:nil] ;
    
    if (![[[self shig] rootLeavesOk] boolValue]) {
        [containers removeObject:root] ;
    }
    NSArray* results = [NSArray arrayWithArray:containers] ;
    [containers release] ;
    
    return results ;
}

- (NSInteger)aggressivelyNormalizeUrls {
    NSInteger nFixed = 0 ;
    for (Stark* stark in [[self starker] allObjects]) {
        if ([stark aggresivelyNormalizeUrl] == YES) {
            nFixed++ ;
        }
    }
    
    return nFixed ;
}

- (Stark*)landNewBookmarkSaveWithInfo:(NSDictionary*)info {
    NSString* url = [info objectForKey:constKeyUrl] ;
    NSString* newName = [[info objectForKey:constKeyName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ;
    if ([newName length] < 1) {
        newName = [NSString localize:@"untitled"] ;
    }
    if ([url length] < 1) {
        // Probably someone messed with the JavaScript in our bookmarklet,
        // or user is trying to bookmark a page with no URL.
        NSBeep() ;
        return nil ;
    }
    
    // See if we already have an item with this normalized URL
    // Cannot do a Core Data fetch request because normalized URL is
    // computed on demand and may be nil.  Oh, well ... search in memory!
    Stark* dupeStark = nil ;
    url = [url normalizedUrl] ;
    for (Stark* otherStark in [[self starker] allStarks]) {
        if ([[otherStark url] isEqualToString:url]) {
            dupeStark = otherStark ;
            break ;
        }
    }
    
    Stark* bookmark = nil ;
    
    BOOL landWithSound = [[NSUserDefaults standardUserDefaults] boolForKey:constKeyLandWithSound] ;
    
    if (dupeStark) {
        if (landWithSound) {
            [[SSYSound shared] play:@"Dupe" block:false];
        }
        
        LandDupeAction landDupeAction = (LandDupeAction)[[NSUserDefaults standardUserDefaults] integerForKey:constKeyLandDupeAction] ;
        switch (landDupeAction) {
            case LandDupeActionAsk:
                // The following test is defensive programming, because
                // if !NSApp, we should not be able to get here.
                if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
                    NSString* displayName ;
                    if ([newName length] > 1) {
                        displayName = newName ;
                    }
                    else {
                        displayName = [dupeStark name] ;
                    }
                    displayName = [displayName stringByTruncatingMiddleToLength:48
                                                                     wholeWords:YES] ;
                    NSString* title = [[BkmxBasis sharedBasis] labelDuplicates] ;
                    NSString* msg = [NSString localizeFormat:
                                     @"bookmarkHaveX",
                                     displayName] ;
                    NSString* button1Title = [[BkmxBasis sharedBasis] labelMerge] ;
                    NSString* button2Title = [[BkmxBasis sharedBasis] labelCancel] ;
                    NSString* button3Title = [[BkmxBasis sharedBasis] labelDoKeepBoth] ;
                    
                    if ([SSYProcessTyper currentType] != NSApplicationActivationPolicyRegular) {
                        // Our SSYAlert won't work when we're in UIElement or background mode.
                        // Use CFUserNotification instead.  It's not quite as pretty,
                        // but it works.
                        
                        NSBundle* bundle = [NSBundle mainAppBundle] ;
                        NSString* iconPath = [bundle appIconPath] ;
                        CFURLRef iconUrl ;
                        if (iconPath) {
                            iconUrl = (CFURLRef)[NSURL fileURLWithPath:iconPath] ;
                        }
                        else {
                            iconUrl = NULL ;
                        }
                        
                        CFOptionFlags alertReturn ;
                        // The following returns whether it "cancelled OK".
                        // I'm not sure that means.  But I don't need it now, anyhow.
                        CFUserNotificationDisplayAlert (
                                                        0,  // no timeout
                                                        0,
                                                        iconUrl,
                                                        NULL,
                                                        NULL,
                                                        (CFStringRef)title,
                                                        (CFStringRef)msg,
                                                        (CFStringRef)button1Title,
                                                        (CFStringRef)button2Title,
                                                        (CFStringRef)button3Title,
                                                        &alertReturn) ;
                        // Bitwise & with 0x3 per the fine print in document
                        //     CFUserNotification > Response Codes > Discussion
                        alertReturn = alertReturn & 0x3 ;
                        switch (alertReturn) {
                            case kCFUserNotificationDefaultResponse:
                                // Merge (right button)
                                bookmark = dupeStark ;
                                break ;
                            case kCFUserNotificationCancelResponse:
                                // Maybe this response happens if the user clicks the "Close"
                                // button on the CFUserNotification window, but I don't know
                                // because the window we show does not have a "Close" button.
                            case kCFUserNotificationAlternateResponse:
                                // Cancel (left button)
                                return nil ;
                            case kCFUserNotificationOtherResponse:
                                // Keep Both (middle button)
                                bookmark = [[self starker] freshDatedStark] ;
                                if (landWithSound) {
                                    [[SSYSound shared] play:@"LandBookmark" block:false];
                                }
                                break ;
                        }
                    }
                    else {
                        // Use our SSYAlert because it's prettier.
                        NSInteger alertReturn = [SSYAlert runModalDialogTitle:title
                                                                      message:msg
                                                                      buttons:
                                                 button1Title,
                                                 button2Title,
                                                 button3Title,
                                                 nil] ;
                        
                        switch (alertReturn) {
                            case NSAlertFirstButtonReturn:
                                // Merge
                                bookmark = dupeStark ;
                                break ;
                            case NSAlertSecondButtonReturn:
                                // Cancel
                                return nil ;
                            case NSAlertThirdButtonReturn:
                                // Keep Both
                                bookmark = [[self starker] freshDatedStark] ;
                                if (landWithSound) {
                                    [[SSYSound shared] play:@"LandBookmark" block:false];
                                }
                                break ;
                        }
                    }
                }
                break ;
            case LandDupeActionMerge:
                bookmark = dupeStark ;
                break ;
            case LandDupeActionCancel:
                return nil ;
            case LandDupeActionKeepBoth:
                break ;
        }
    }
    
    Stark* parent = [info objectForKey:constKeyParent] ;
    BOOL useNewParent = YES ;
    if (!parent) {
        parent = [[self shig] landing] ;
        // Starting with BookMacster 1.19.7, the above cannot return nil
        useNewParent = NO ;
    }
    
    BOOL wantsNewSubfolder = [[info objectForKey:constKeyWantsNewSubfolder] boolValue] == YES ;
    NSString* newSubfolderName = nil ;
    if (wantsNewSubfolder) {
        // The following test is defensive programming, because
        // if !NSApp, we should not be able to get here.
        if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
            NSString* title = @"Create new subfolder" ;
            NSString* prompt = @"Name your new subfolder" ;
            NSString* untitled = [NSString localize:@"untitled"] ;
            NSString* button1Title = [[BkmxBasis sharedBasis] labelOk] ;
            NSString* button2Title = [[BkmxBasis sharedBasis] labelCancel] ;
            
            if (([SSYProcessTyper currentType] != NSApplicationActivationPolicyRegular) ) {
                // Our SSYAlert won't work when we're in background mode.
                // Use CFUserNotification instead.  It's not quite as pretty,
                // but it works.
                
                NSBundle* bundle = [NSBundle mainAppBundle] ;
                NSString* iconPath = [bundle appIconPath] ;
                CFURLRef iconUrl ;
                if (iconPath) {
                    iconUrl = (CFURLRef)[NSURL fileURLWithPath:iconPath] ;
                }
                else {
                    iconUrl = NULL ;
                }
                
                SInt32 error ;
                NSDictionary* elements = [NSDictionary dictionaryWithObjectsAndKeys:
                                          button1Title, kCFUserNotificationDefaultButtonTitleKey,
                                          button2Title, kCFUserNotificationAlternateButtonTitleKey,
                                          title, kCFUserNotificationAlertHeaderKey,
                                          prompt, kCFUserNotificationTextFieldTitlesKey,
                                          untitled, kCFUserNotificationTextFieldValuesKey,
                                          iconUrl, kCFUserNotificationIconURLKey,
                                          nil] ;
                CFUserNotificationRef userNote = CFUserNotificationCreate(
                                                                          NULL, // default allocator
                                                                          0,    // no timeout
                                                                          kCFUserNotificationPlainAlertLevel,
                                                                          &error,
                                                                          (CFDictionaryRef)elements) ;
                CFRunLoopSourceRef runLoopSource = CFUserNotificationCreateRunLoopSource(
                                                                                         NULL, // default allocator
                                                                                         userNote,
                                                                                         NewSubfolderCallback,
                                                                                         0) ;
                NSString* waitingForUserToSpecifyNewFolderRunLoopMode = [[[NSBundle mainBundle] bundleIdentifier] stringByAppendingString:@".wFUTSNFRLM"] ;
                CFRunLoopAddSource (
                                    CFRunLoopGetCurrent(),
                                    runLoopSource,
                                    (CFStringRef)waitingForUserToSpecifyNewFolderRunLoopMode) ;
                // Will block here until user dismisses the dialog…
                SInt32 runResult =  CFRunLoopRunInMode (
                                                        (CFStringRef)waitingForUserToSpecifyNewFolderRunLoopMode,
                                                        300.0,  // time out dialog if user does not respond within 5 minutes
                                                        true) ;
                CFRelease(runLoopSource) ;
                
                if (runResult == kCFRunLoopRunHandledSource) {
                    if (userAffirmedNewSubfolderForNewBookmark) {
                        newSubfolderName = (NSString*)CFUserNotificationGetResponseValue (
                                                                                          userNote,
                                                                                          kCFUserNotificationTextFieldValuesKey,
                                                                                          0
                                                                                          ) ;
                        // Whoops, Core Foundation methods don't know autorelease.
                        // We need newSubfolderName to stick around after releasing userNote, its owner…
                        [[newSubfolderName retain] autorelease] ;
                    }
                }
                else {
                    // dialog timed out with no response from user
                    // Process the new bookmark with newSubFolderName = nil
                }
                
                CFRelease(userNote) ;
            }
            else {
                // Use our SSYAlert because it's prettier.
                SSYAlert* alert = [SSYAlert alert] ;
                [alert setTitleText:title] ;
                [alert setButton1Title:button1Title] ;
                [alert setButton2Title:button2Title] ;
                SSYLabelledTextField* textField = [SSYLabelledTextField labelledTextFieldSecure:NO
                                                                             validationSelector:NULL
                                                                               validationObject:nil
                                                                               windowController:nil
                                                                                   displayedKey:prompt
                                                                                 displayedValue:untitled
                                                                                       editable:YES
                                                                                            tag:0  // not used
                                                                                   errorMessage:nil] ;
                [alert addOtherSubview:textField
                               atIndex:0] ;
                [alert runModalDialog] ;
                NSInteger alertReturn = [alert alertReturn] ;
                switch (alertReturn) {
                    case NSAlertFirstButtonReturn:
                        // "OK"
                        newSubfolderName = [textField stringValue] ;
                        break ;
                    case NSAlertSecondButtonReturn:
                        // Cancel
                    default:
                        break ;
                }
            }
        }
        
        if (!newSubfolderName) {
            // User clicked 'Cancel'
            // Cancel the whole thing by returning
            // (I thought about just cancelling the new subfolder, or adding
            // a third button to say "Oh, I changed my mind, create the new
            // bookmark but don't put it into a new subfolder", but decided
            // that would be too confusing.  If the user changes their mind
            // about the new subfolder, they can start all over again.
            return nil ;
        }
    }
    
    if (!bookmark) {
        // bookmark has not been assigned from an existing duplicate.
        // Create the new bookmark.
        bookmark = [[self starker] freshDatedStark] ;
        if (landWithSound) {
            [[SSYSound shared] play:@"LandBookmark" block:false];
        }
    }
    
    if (newSubfolderName) {
        Stark* subfolder = [[self starker] freshDatedStark] ;
        [subfolder setSharypeValue:SharypeSoftFolder] ;
        [subfolder setName:newSubfolderName] ;
        [StarkEditor parentingAction:BkmxParentingMove
                               items:[NSArray arrayWithObject:subfolder]
                           newParent:parent
                            newIndex:0
                        revealDestin:NO] ;
        [parent sortShallowly] ;
        
        // Splice it in.
        parent = subfolder ;
    }
    
    NSString* newComments = [info objectForKey:constKeyComments];
    if (newComments.length > 0) {
        NSUInteger commentsLimit = [[NSUserDefaults standardUserDefaults] integerForKey:constKeyLandCommentsLimit] ;
        newComments = [newComments stringByTruncatingEndToLength:commentsLimit
                                                      wholeWords:YES] ;
        newComments = [newComments stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ;
    } else {
        /* See comment WhyEmptyString-WhyNotNull in SSYAppleScripter.h */
        newComments = nil;
    }
    
    if (bookmark) {
        if (bookmark == dupeStark) {
            // bookmark is the old bookmark.  Merge it.
            
            // Although normalized URLs are same, actual URLs may
            // be different.  Use the new one.  It's not nil.
            [bookmark setUrl:[info objectForKey:constKeyUrl]] ;
            
            // Since the name is the web page title, probably the
            // old name is better, so leave it alone.
            
            // For comments, let's merge them.
            if ([newComments length] > 0) {
                NSString* oldComments = [bookmark comments] ;
                if ([oldComments length] > 0) {
                    newComments = [NSString stringWithFormat:
                                   @"%@\n%@",
                                   oldComments,
                                   newComments] ;
                }
                
                [bookmark setComments:newComments] ;
            }
            
            if (useNewParent) {
                [StarkEditor parentingAction:BkmxParentingMove
                                       items:[NSArray arrayWithObject:bookmark]
                                   newParent:parent
                                    newIndex:0
                                revealDestin:YES] ;
                [parent sortShallowly] ;
            }
            
            [[[self bkmxDocWinCon] contentOutlineView] showStarks:[NSArray arrayWithObject:bookmark]
                                                       selectThem:YES
                                                   expandAsNeeded:NO] ;
        }
        else {
            // bookmark is a new bookmark
            [bookmark setSharypeValue:SharypeBookmark] ;
            // We could do the following three lines with one line,
            //    -[SSYManagedObject setAttributes:],
            // But that would raise an exception if someone messed with the
            // JavaScript in our bookmarklet and added a key to which Stark
            // instances don't respond.  Another reason is that the name of
            // the Yehuda Moon site (http://www.yehudamoon.com/index.php?)
            // has a bunch of tabs and line feeds prepended and appended
            // to the title, so we want to trim whitespace in case there
            // are other sites out there like this.
            [bookmark setUrl:[info objectForKey:constKeyUrl]] ;
            [bookmark setName:newName] ;
            [bookmark setComments:newComments] ;
            // Since the user was just there, give it 1 visit.
            [bookmark setVisitCount:[NSNumber numberWithInteger:1]] ;
            
            [StarkEditor parentingAction:BkmxParentingAdd
                                   items:[NSArray arrayWithObject:bookmark]
                               newParent:parent
                                newIndex:0
                            revealDestin:YES] ;
            [parent sortShallowly] ;
            
            [self setUndoActionNameForAction:SSYModelChangeActionInsert
                                      object:bookmark
                                   objectKey:nil
                                  updatedKey:nil
                                       count:0] ;
        }
    }
    
    [(BkmxAppDel*)[NSApp delegate] setIfNoBkmxDocWindowsSelectedStark:bookmark] ;
    [self addRecentLanding:parent] ;
    
    
    /* Until BookMacster 1.6, the following was simply [self saveDocument]
     However I found that when using the new Add Here: feature, the document
     would sometimes be dirty after the landing.  There were in fact two things
     happening to dirty the dot after a save:
     
     First Thing:
     -[ContentOutlineView processPendingChanges]
     -[ContentOutlineView reloadDate]
     -[BkmxDocWinCon reloadContent]
     -[BkmxDocWinCon reloadAll]
     -[BkmxDocWinCon updateWindowForStark:]
     -[BkmxDoc updateViews:]
     _nsnote_callback
     
     Second Thing:
     -[GCUndoManager registerUndoWithTarget:selector:object:]
     -[BkmxDoc finalizeEditsNote:]
     _nsnote_callback
     
     The First Thing I could solve by sending -updateViews: before
     -saveDocument, but the Second Thing still happened sometime.
     Solution is a delay of 0.0… */
    [self performSelector:@selector(saveDocument)
               withObject:nil
               afterDelay:0.0] ;
    
    return bookmark ;
}                                                        

/* NoteBkmxLandingTrigger
 I considered setting such an syncer as a instance variable, or
 an syncer index, or even just a BOOL indicating that such
 an syncer existed, which the document would check to see if an
 export was necessary after a landing, but then I thought that
 there would be many corner cases to resolve if such an syncer
 was added or removed, and rather than deal with that, since
 new bookmarks are landed rarely, just loop through the several
 agents whenever a new bookmark is landed and see if you find
 one with trigger BkmxTriggerLanding. So there is nothing to
 realizeSyncersToWatchesError_p:.  */

- (BOOL)canBeAtRootSharype:(Sharype)sharype {
    BOOL answer ;
    if ([StarkTyper isLeafCoarseSharype:sharype]) {
        // stark is a leaf
        answer = [[[self shig] rootLeavesOk] boolValue] ;
    }
    else if ([StarkTyper isSoftainerCoarseSharype:sharype]) {
        // stark is a soft container
        answer = [[[self shig] rootSoftainersOk] boolValue] ;
    }
    else if ([StarkTyper isNotchCoarseSharype:sharype]) {
        // stark is a notch (separator)
        answer = [[[self shig] rootNotchesOk] boolValue] ;
    }
    else {
        // stark must be a hartainer
        // Hartainers at root are always OK
        answer = YES ;
    }
    
    return answer ;
}

- (BOOL)canHaveParentSharype:(Sharype)parentSharype
                       stark:(Stark*)stark {
    BOOL answer ;
    if (parentSharype == SharypeRoot) {
        answer = [self canBeAtRootSharype:[stark sharypeValue]] ;
    }
    else {
        answer = YES ;
    }
    
    return answer ;
}

#pragma mark * StarCatcher Protocol Conformance

- (BOOL)parentSharype:(Sharype)parentSharype
  canHaveChildSharype:(Sharype)childSharype {
    // Coarsify the child
    childSharype = [StarkTyper coarseTypeSharype:childSharype] ;
    
    BOOL answer = YES ;
    if (parentSharype == SharypeRoot) {
        answer = [self canBeAtRootSharype:childSharype] ;
    }
    
    return answer ;
}

- (NSArray*)catchypesForSharype:(Sharype)sharype {
    sharype = [StarkTyper coarseTypeSharype:sharype] ;
    NSArray* defaultAnswer  = [[NSUserDefaults standardUserDefaults] arrayForKey:constKeyAnyStarkCatchypeOrder] ;
    if (!defaultAnswer) {
        defaultAnswer = [[[BkmxBasis sharedBasis] defaultDefaults] objectForKey:constKeyAnyStarkCatchypeOrder] ;
    }
    
    NSMutableArray* candidates = [defaultAnswer mutableCopy] ;
    if (![self canBeAtRootSharype:sharype]) {
        [candidates removeObject:[NSNumber numberWithInteger:SharypeRoot]] ;
    }
    
    NSArray* answer = [candidates copy] ;
    [candidates release] ;
    [answer autorelease] ;
    
    return answer ;
}

- (NSArray*)catchypesForStark:(Stark*)stark {
    Sharype sharypeCoarseValue = [stark sharypeCoarseValue] ;
    return [self catchypesForSharype:sharypeCoarseValue] ;
}


- (Stark*)fosterParentForSharype:(Sharype)sharype {
    NSNumber* fosterSharype = [[self macster] preferredCatchype] ;
    if (fosterSharype == nil) {
        NSArray* candidates = [self catchypesForSharype:sharype] ;
        Sharype fosterSharypeValue = SharypeBar ;  // default, should always be overwritten
        for (NSNumber* candidate in candidates) {
            Sharype proposedParentSharype = [candidate unsignedShortValue] ;
            if ([self parentSharype:proposedParentSharype
                canHaveChildSharype:sharype]) {
                fosterSharypeValue = proposedParentSharype ;
            }
        }
        fosterSharype = [NSNumber numberWithSharype:fosterSharypeValue] ;
    }
    
    Stark* fosterParent = [[self starker] hartainerOfSharype:[fosterSharype sharypeValue]
                                                     quickly:YES] ;
    
    // Added in BookMacster 1.19.7, to avoid returning nil in edge cases.
    // Assign one arbitrarily.
    if (!fosterParent) {
        fosterParent = [[self starker] unfiled] ;
    }
    if (!fosterParent) {
        fosterParent = [[self starker] bar] ;
    }
    if (!fosterParent) {
        fosterParent = [[self starker] menu] ;
    }
    if (!fosterParent) {
        fosterParent = [[self starker] ohared] ;
    }
    if (!fosterParent) {
        // This may be disallowed, but we have no choice at this point
        fosterParent = [[self starker] root] ;
        if (![self canBeAtRootSharype:sharype]) {
            /*  Bug 20141116.  This should not be allowed to occur,
             but can occur if there are no items in Content which prevent
             all checkboxes in Structure from being switched off. */
            NSLog(@"Warning: Bad structure.  Sharype %hd not allowed in %@", sharype, self) ;
        }
    }
    
    return fosterParent ;
}

- (Stark*)fosterParentForStark:(Stark*)stark {
    return [self fosterParentForSharype:[stark sharypeValue]] ;
}

- (NSString*)descriptionForKeyPath:(NSString*)keyPath
                        displayKey:(NSString*)displayKey {
    NSString* answer = nil ;
    NSString* value = [[self valueForKeyPath:keyPath] description] ;
    if (value) {
        answer = [NSString stringWithFormat:
                  @"%@: %@",
                  displayKey,
                  value] ;
    }
    
    return answer ;
}

- (void)endEditing:(NSNotification*)notification {
    // Directly access the window controller ivars, because the regular
    // accessors may create these window controllers if they don't exist.
    [[self bkmxDocWinCon] endEditing] ;
}

- (void)postDupesDone {
    // Since other observers of our notification will -reloadData on the
    // dupes outline view, we must make sure that its cache does not have old
    // data in it before posting.
    
    NSNotification* notification = [NSNotification notificationWithName:constNoteDupesDone
                                                                 object:[self shig]] ;
    [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                               postingStyle:NSPostNow
                                               coalesceMask:(NSNotificationCoalescingOnName|NSNotificationCoalescingOnSender)
                                                   forModes:nil] ;
    // In the above, if I use postingStyle:NSPostASAP, then after finding dupes,
    // the dupesStatus does not update from "New duplicates, not shown...." to
    // "N duplicate groups" because the notification catcher -[shig updateTimestamp:]
    // does not get invoked after dupes are done.  Doesn't make sense to me but,
    // anyhow, the extra aggressiveness of NSPostNow will not cause a performance
    // hit in this case since postDupesDone happens rarely.
    // See "Note on Coalesce Mask" at bottom of SSYOperationQueue.m
}

- (void)postDupesMaybeMore {
    // Since other observers of our notification will -reloadData on the
    // dupes outline view, we must make sure that its cache does not old
    // data in it before posting.
    
    NSNotification* notification = [NSNotification notificationWithName:constNoteDupesMaybeMore
                                                                 object:[self shig]] ;
    [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                               postingStyle:NSPostNow  // 20090916  was NSPostASAP
                                               coalesceMask:(NSNotificationCoalescingOnName|NSNotificationCoalescingOnSender)
                                                   forModes:nil] ;
    // See "Note on Coalesce Mask" at bottom of SSYOperationQueue.m
}

- (void)postSortDone {
    NSNotification* notification = [NSNotification notificationWithName:constNoteSortDone
                                                                 object:[self shig]] ;
    [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                               postingStyle:NSPostNow  // 20090916  was NSPostASAP
                                               coalesceMask:(NSNotificationCoalescingOnName|NSNotificationCoalescingOnSender)
                                                   forModes:nil] ;
    // See "Note on Coalesce Mask" at bottom of SSYOperationQueue.m
}

- (void)postSortMaybeNot {
    NSNotification* notification = [NSNotification notificationWithName:constNoteSortMaybeNot
                                                                 object:[self shig]] ;
    [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                               postingStyle:NSPostNow  // 20090916  was NSPostASAP
                                               coalesceMask:(NSNotificationCoalescingOnName|NSNotificationCoalescingOnSender)
                                                   forModes:nil] ;
    // See "Note on Coalesce Mask" at bottom of SSYOperationQueue.m
}

- (void)postVerifyDone {
    NSNotification* notification = [NSNotification notificationWithName:constNoteVerifyDone
                                                                 object:[self shig]] ;
    [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                               postingStyle:NSPostNow  // 20090916  was NSPostASAP
                                               coalesceMask:(NSNotificationCoalescingOnName|NSNotificationCoalescingOnSender)
                                                   forModes:nil] ;
    // See "Note on Coalesce Mask" at bottom of SSYOperationQueue.m
}

- (void)postVerifyMaybeNot {
    NSNotification* notification = [NSNotification notificationWithName:constNoteVerifyMaybeNot
                                                                 object:[self shig]] ;
    [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                               postingStyle:NSPostNow  // 20090916  was NSPostASAP
                                               coalesceMask:(NSNotificationCoalescingOnName|NSNotificationCoalescingOnSender)
                                                   forModes:nil] ;
    // See "Note on Coalesce Mask" at bottom of SSYOperationQueue.m
}

- (void)postDupesMayContainVestiges {
    // Since other observers of our notification will -reloadData on the
    // dupes outline view, we must make sure that its cache does not have old
    // data in it before posting.
    
    NSNotification* notification = [NSNotification notificationWithName:constNoteDupesMayContainVestiges
                                                                 object:[self shig]] ;
    [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                               postingStyle:NSPostWhenIdle
     // Until 20090916, the above was NSPostASAP
     // Until BookMacster 1.3.1, the above was NSPostNow
                                               coalesceMask:(NSNotificationCoalescingOnName|NSNotificationCoalescingOnSender)
                                                   forModes:nil] ;
    // See "Note on Coalesce Mask" at bottom of SSYOperationQueue.m
}

- (void)postDupesMaybeDisparaged {
    // Since other observers of our notification will -reloadData on the
    // dupes outline view, we must make sure that its cache does not have old
    // data in it before posting.
    
    NSNotification* notification = [NSNotification notificationWithName:constNoteDupesMayContainDisparagees
                                                                 object:[self shig]] ;
    [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                               postingStyle:NSPostASAP  // 20090916  was NSPostASAP
                                               coalesceMask:(NSNotificationCoalescingOnName|NSNotificationCoalescingOnSender)
                                                   forModes:nil] ;
    // 0.1.7 was NSPostNow
    // 0.9.8 was NSPostWhenIdle  Changed back in order to fix bug which sometimes caused a new Collection,
    // just created by Importing from Bookdog, to have unsaved changes.  Possible triggers for this may have
    // been: Safari as the sole Import source, > 1000 bookmarks, Bookwatchdog set to sort and find dupes.
    // See "Note on Coalesce Mask" at bottom of SSYOperationQueue.m
}

- (void)postTouchedStark:(Stark*)stark {
    // The order is important here.  First, set flat cache invalid...
    [[self bkmxDocWinCon] invalidateFlatCache] ;
    
    // Then, enqueue the notification that will causes a reloadData, etc., and also
    // blow away all import hashes.
    NSDictionary* userInfo ;
    if (stark) {
        userInfo = [NSDictionary dictionaryWithObject:stark
                                               forKey:constKeyStark] ;
    }
    else {
        userInfo = nil ;
    }
    NSNotification* notification = [NSNotification notificationWithName:BkmxDocNotificationContentTouched
                                                                 object:self
                                                               userInfo:userInfo] ;
    [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                               postingStyle:NSPostASAP
                                               coalesceMask:(NSNotificationCoalescingOnName|NSNotificationCoalescingOnSender)
                                                   forModes:nil] ;
    // See "Note on Coalesce Mask" at bottom of SSYOperationQueue.m
    
    /* We also post a notification, NOT enqueued, which will add the current
     stark to ContentOutlineView's m_reloadStarks.  (The receiver of the
     enqueued notification, above, will only get one stark in its userInfo,
     that of the first notification enqueued into the coalesce group.) */
    [[NSNotificationCenter defaultCenter] postNotificationName:BkmxDocNotificationStarkTouched
                                                        object:self
                                                      userInfo:userInfo] ;
}

- (void)postTouchedTag:(Tag*)tag {
    NSDictionary* userInfo ;
    if (tag) {
        userInfo = [NSDictionary dictionaryWithObject:tag
                                               forKey:constKeyTag] ;
    }
    else {
        userInfo = nil ;
    }
    NSNotification* notification = [NSNotification notificationWithName:BkmxDocNotificationContentTouched
                                                                 object:self
                                                               userInfo:userInfo] ;
    [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                               postingStyle:NSPostASAP
                                               coalesceMask:(NSNotificationCoalescingOnName|NSNotificationCoalescingOnSender)
                                                   forModes:nil] ;
    // See "Note on Coalesce Mask" at bottom of SSYOperationQueue.m
}

- (void)setUndoActionNameForAction:(SSYModelChangeAction)action
                            object:(id)object
                         objectKey:(NSString*)objectKey
                        updatedKey:(NSString*)key 
                             count:(NSInteger)count {
#if 0
#define LOG_SETTING_UNDO_ACTION_NAME 1
#warning Logging Setting of Undo Action Name
#endif
#if LOG_SETTING_UNDO_ACTION_NAME
    NSLog(@"Setting Undo action=%@, object=%@", [SSYModelChangeTypes symbolForAction:action], [object shortDescription]) ;
    NSLog(@"   objectKey=%@, updatedKey=%@, count=%ld", objectKey, key, (long)count) ;
#endif
    NSString* actionKey ;
    switch (action) {
        case SSYModelChangeActionVague:
            actionKey = nil ;
            break ;
        case SSYModelChangeActionInsert:
            actionKey = @"insertX" ;
            break ;
        case SSYModelChangeActionModify:
            actionKey = @"change%0" ;
            break ;
        case SSYModelChangeActionSort:
            actionKey = @"080_sortX" ;
            break ;
        case SSYModelChangeActionMove:
            actionKey = @"moveX" ;
            break ;
        case SSYModelChangeActionReplace:
            actionKey = @"replaceX" ;
            break ;
        case SSYModelChangeActionRemove:
            actionKey = @"delete%0" ;
            break ;
        case SSYModelChangeActionMigrate:
            actionKey = @"migrate%0" ;
            break ;
        default:
            NSLog(@"Internal Error 674-5842 %ld", (long)action) ;
            actionKey = @"?" ;
            break ;
    }

    BkmxBasis* basis = [BkmxBasis sharedBasis] ;
    NSString* localizedChangee = nil ;
    if (action == SSYModelChangeActionModify) {
        if ([object isKindOfClass:[Stark class]]) {
            Stark* stark = (Stark*)object ;
            localizedChangee = [NSString stringWithFormat:
                                @"%@ (%@)",
                                [stark name],
                                [key bkmxAttributeDisplayName]] ;
        }
        else if ([object isKindOfClass:[Bookshig class]]) {
            if ([key isEqualToString:constKeyDefaultSortable]) {
                localizedChangee = [basis labelSortableDefault] ;
            }
            else if ([key isEqualToString:constKeyFilterIgnoredPrefixes]) {
                localizedChangee = [basis labelIgnoreCommonPrefixesCheckbox] ;
            }
            else if ([key isEqualToString:constKeyIgnoreDisparateDupes]) {
                localizedChangee = [basis labelIgnoreDisparateDupes] ;
            }
            else if ([key isEqualToString:constKeyNotes]) {
                localizedChangee = [NSString stringWithFormat:
                                    @"%@ : %@",
                                    [[NSDocumentController sharedDocumentController] defaultDocumentDisplayName],
                                    [basis labelComments]];
            }
            else if ([key isEqualToString:constKeyPreferredCatchype]) {
                localizedChangee = [basis labelDefaultParent] ;
            }
            else if ([key isEqualToString:constKeyRootLeavesOk]) {
                localizedChangee = [NSString stringWithFormat:
                                    @"%@ : %@",
                                    [basis labelItemsAllowedAtRoot],
                                    [basis labelBookmarks]];
            }
            else if ([key isEqualToString:constKeyRootNotchesOk]) {
                localizedChangee = [NSString stringWithFormat:
                                    @"%@ : %@",
                                    [basis labelItemsAllowedAtRoot],
                                    [basis labelSeparator]];
            }
            else if ([key isEqualToString:constKeyRootSoftainersOk]) {
                localizedChangee = [NSString stringWithFormat:
                                    @"%@ : %@",
                                    [basis labelItemsAllowedAtRoot],
                                    [basis labelSoftainers]];
            }
            else if ([key isEqualToString:constKeyRootSortable]) {
                localizedChangee = [basis labelSortRoot] ;
            }
            else if ([key isEqualToString:constKeySortBy]) {
                localizedChangee = [basis labelSortBy] ;
            }
            else if ([key isEqualToString:constKeySortingSegmentation]) {
                localizedChangee = [basis labelSortingSegmentation] ;
            }
            else if ([key isEqualToString:constKeyTagDelimiter]) {
                localizedChangee = [basis labelTagDelimiter] ;
            }
            else if ([key isEqualToString:constKeyVisitor]) {
                localizedChangee = [basis labelVisitorDefault] ;
            }
            else if ([key isEqualToString:constKeyLanding]) {
                localizedChangee = [basis labelNewBookmarkLanding] ;
            }
            else {
                // This is Bookshig change that we don't want to 
                // appear in the Undo menu.  Examples:
                //  lastDupesXxxx, lastSortXxxx, lastTouched, 
                //  lastVerifyXxxx, uuid
            }
        }
        else if ([object isKindOfClass:[Ixporter class]]) {
            if ([key isEqualToString:constKeyIsActive]) {
                localizedChangee = [basis labelActive] ;
            }
            else if ([key isEqualToString:constKeySafeLimit]) {
                localizedChangee = [basis labelSafeLimitExport] ;
            }
            else if ([key isEqualToString:constKeyDeleteUnmatched]) {
                localizedChangee = [basis labelDeleteUnmatchedItems] ;
            }
            else if ([key isEqualToString:constKeyClient]) {
                localizedChangee = [basis labelClient] ;
            }
            else if ([key isEqualToString:constKeyFabricateTags]) {
                localizedChangee = [basis labelFabricateTags] ;
            }
            else if ([key isEqualToString:constKeyFabricateFolders]) {
                localizedChangee = [basis labelFabricateFolders] ;
            }
            else if ([key isEqualToString:constKeyMergeBias]) {
                localizedChangee = [basis labelMergeBias] ;
            }
            else if ([key isEqualToString:constKeyMergeBy]) {
                localizedChangee = [basis labelMergeBy] ;
            }
            else if ([key isEqualToString:constKeyPreferredCatchype]) {
                localizedChangee = [basis labelDefaultParent] ;
            }
            else if ([key isEqualToString:constKeyShareNewItems]) {
                localizedChangee = [basis labelShareNewItems] ;
            }
            else {
                // This is an Ixporter change that we don't want to 
                // appear in the Undo menu.  Examples: 
                // ???
            }
        }
        else if ([object isKindOfClass:[Syncer class]]) {
            if ([key isEqualToString:constKeyIsActive]) {
                localizedChangee = [basis labelActive] ;
            }
            else if ([key isEqualToString:constKeyUserDescription]) {
                localizedChangee = [basis labelDescription] ;
            }
            else {
                // Adding and removing triggers and agents get undo action
                // names set by notification from the array controllers.
                // So, we ignore those here.
            }

            if (localizedChangee) {
                // Change it so that the menu item will read either 
                // "Undo Change Active (Syncer)" or "Undo Change Description (Syncer)"
                localizedChangee = [NSString stringWithFormat:
                                    @"%@ (%@)",
                                    localizedChangee,
                                    [basis labelSyncer]] ;
            }
            else {
                localizedChangee = [basis labelSyncer] ;
            }
        }
        else if ([object isKindOfClass:[Trigger class]]) {
            if ([key isEqualToString:constKeyIsActive]) {
                localizedChangee = [NSString stringWithFormat:
                                    @"%@ (%@)",
                                    [basis labelActive],
                                    [basis labelTrigger]] ;
                // Results in "Undo Change Active (Trigger)"
            }
            else { 
                localizedChangee = [basis labelTrigger] ;
                // The menu item title "Undo Change Trigger" is sufficient
                // to describe for 'recurringDate' and 'triggerType'.
            }

        }
        else if ([object isKindOfClass:[Command class]]) {
            if ([key isEqualToString:constKeyIsActive]) {
                localizedChangee = [NSString stringWithFormat:
                                    @"%@ (%@)",
                                    [basis labelActive],
                                    [basis labelCommand]] ;
                // Results in "Undo Change Active (Command)"
            }
            else { 
                localizedChangee = [basis labelCommand] ;
                // The menu item title "Undo Change Command" is sufficient
                // is sufficient for 'recurringDate' and 'triggerType'.
            }
        }
        else if (object == self) {
            if ([key isEqualToString:constKeyHasBar]) {
                localizedChangee = [NSString stringWithFormat:
                                    @"%@ %@",
                                    [basis labelHartainersHave],
                                    [self labelBar]];
            }
            else if ([key isEqualToString:constKeyHasMenu]) {
                localizedChangee = [NSString stringWithFormat:
                                    @"%@ %@",
                                    [basis labelHartainersHave],
                                    [self labelMenu]];
            }
            else if ([key isEqualToString:constKeyHasOhared]) {
                localizedChangee = [NSString stringWithFormat:
                                    @"%@ %@",
                                    [basis labelHartainersHave],
                                    [self labelOhared]];
            }
            else if ([key isEqualToString:constKeyHasUnfiled]) {
                localizedChangee = [NSString stringWithFormat:
                                    @"%@ %@",
                                    [basis labelHartainersHave],
                                    [self labelUnfiled]];
            }
        }
    }
    else {
        // action is one of:
        // SSYModelChangeActionVague
        // SSYModelChangeActionInsert
        // SSYModelChangeActionSort
        // SSYModelChangeActionMove
        // SSYModelChangeActionReplace
        // SSYModelChangeActionRemove
        // SSYModelChangeActionMigrate
        
        if ([objectKey isEqualToString:constKeyClient]) {
            localizedChangee = [basis labelClient] ;
        }
        else if ([objectKey isEqualToString:constKeySyncers]) {
            localizedChangee = [basis labelSyncer] ;
        }
        else if ([objectKey isEqualToString:constKeyCommands]) {
            localizedChangee = [basis labelCommand] ;
        }
        else if ([objectKey isEqualToString:constKeyTriggers]) {
            localizedChangee = [basis labelTrigger] ;
        }
        else if ([objectKey isEqualToString:constKeyRssArticles]) {
            localizedChangee = [basis labelRssArticle] ;
        }
    }

    NSString* actionName = nil ;
    if (actionKey) { 
        if (localizedChangee) {
            actionName = [NSString localizeFormat:
                          actionKey,
                          localizedChangee] ;
        }
        else  if (count > 0) {
            actionName = [NSString localizeFormat:
                          actionKey,
                          [NSString localizeFormat:
                           @"items%0",
                           [NSString stringWithInt:count]]] ;
        }
    }
    else {
        // action: is SSYModelActionImplied.  Just noun, no verb    
        actionName = localizedChangee ;
        // ... which may or may not be nil
    }

    if (actionName) {
        //         NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
        //         [dateFormatter setDateFormat:@"mm:ss.SSS"];
        //         NSString* timeSuffix  = [dateFormatter stringFromDate:[NSDate date]];
        NSString* timeSuffix = [[self undoDateFormatter] stringFromDate:[NSDate date]];
        actionName = [actionName stringByAppendingFormat:@"  (%@)", timeSuffix] ; 
        [[self undoManager] setActionName:actionName] ;
#if LOG_SETTING_UNDO_ACTION_NAME
        NSLog(@"   Did set actionName to: %@", actionName) ;
#endif
    }
#if LOG_SETTING_UNDO_ACTION_NAME
    else {
        NSLog(@"   Did *not* set any actionName") ;
    }
#endif
}

/*
 This method handles key/value changes in existing Stark, Tag and Dupe objects,
 except for reporting transMoc Stark updates to the chaker and updating the 
 last modified date of exported starks.  Those cases are handled in
 -[Ixporter objectWillChangeNote:].
 */
- (void)objectWillChangeNote:(NSNotification*)notification {
    id object = [notification object] ;
    if ([object managedObjectContext] != [self managedObjectContext]) {
        // Not one of ours
        return ;
    }
    
    if ([self ignoreChanges]) {
        return ;
    }
    
    NSString* keyPath = [[notification userInfo] objectForKey:constKeySSYChangedKey] ;
    id newValue = [[notification userInfo] objectForKey:constKeyNewValue] ;
    id oldValue = [object valueForKeyPath:keyPath] ;
    
    // Apple's KVO sends out notifications even when there has not been any substantial
    // change because, as Quincey Morris says, "Properties are behavior".
    // However, I have no use for such notifications, so I filter those out
    if ([NSObject isEqualHandlesNilObject1:newValue
                                   object2:oldValue]) {
        // Value did not really change.
        return ;
    }
    
    // When objects are deallocced or deleted, values of their properties
    // are set to nil, signified by newValue being an NSNull, so we'll get
    // a flood of such observations, for example, when a document is closed.
    // The following if() makes us ignore such observations.
    // I can't think of anything we'd need to do when a value
    // is set to nil.  For starks, when a stark is deleted, we'll
    // get a change in the children of the parent.  That should do it.
    if ([newValue isKindOfClass:[NSNull class]]) {
        return ;
    }

#if 0
#warning Logging BkmxDoc's objectWillChangeNote:
    NSString* displayOldValue = [oldValue shortDescription] ;
    NSString* displayNewValue = [newValue shortDescription] ;
    NSLog(@"%s\n"
          "      OBJECT: %@\n"
          "     KEYPATH: %@\n"
          "   OLD-VALUE: %@\n"
          "   NEW-VALUE: %@",
          __PRETTY_FUNCTION__,
          [object shortDescription],
          keyPath,
          displayOldValue,
          displayNewValue) ;
#endif
    
    BOOL unsorted = NO ;
    BOOL dupesMaybeDisparaged = NO ;
    BOOL dupesMaybeVestiged = NO ;
    BOOL dupesMaybeMore = NO ;
    BOOL unverified = NO ;
    BOOL starkTouched = NO ;
    BOOL tagTouched = NO;
    BOOL definitelyRemoveFromDupe = NO ;
    BOOL maybeRemoveFromDupe = NO ;
    
    Stark* affectedStark = nil ;
    Tag* affectedTag = nil;
    if ([object isKindOfClass:[Stark class]]) {
        affectedStark = (Stark*)object ;
        starkTouched = YES ;
        if ([keyPath isEqualToString:constKeyUrl]) {
            // A change in any url could create a duplicate
            dupesMaybeMore = YES ;
            // will cause object to become unverified
            unverified = YES ;
            // could destroy sorting if sorting by url
            if ([[self shig] sortByValue] == BkmxSortByUrl) {
                unsorted = YES ;
            }
            // will make it no longer a dupe, if it was, and normalized url has changed
            maybeRemoveFromDupe = YES ;
        }
        else if (
                 ([[self shig] sortByValue] == BkmxSortByName)
                 && (
                     [keyPath isEqualToString:constKeySortDirective]
                     ||
                     [keyPath isEqualToString:constKeyName]
                     )
                 ) {
                     unsorted = YES ;
                 }
        else if ([keyPath isEqualToString:constKeyChildren]) {
            unsorted = YES ;
        }
        else if ([keyPath isEqualToString:constKeyIndex]) {
            // But this may not happen because there is a stealthy way to
            // change a Stark's index.  See USE_OPTIMIZED_RESTACK_CHILDREN.
            unsorted = YES ;
            affectedStark = [(Stark*)object parent] ;
        }
        else if ([keyPath isEqualToString:constKeyIsAllowedDupe]) {
            if ([newValue boolValue]) {
                definitelyRemoveFromDupe = YES ;
                dupesMaybeVestiged = YES ;
            }
            else {
                dupesMaybeMore = YES ;
            }
        }
        else if ([keyPath isEqualToString:constKeyVerifierCode]) {
            unverified = YES ;
        }
        else if ([keyPath isEqualToString:constKeyVerifierDisposition]) {
            unverified = YES ;
        }
        else if ([keyPath isEqualToString:constKeySortable]) {
            if ([newValue boolValue]) {
                unsorted = YES ;
            }
        }
        else if ([keyPath isEqualToString:constKeyParent]) {
            if ([[[self shig] ignoreDisparateDupes] boolValue]) {
                // Note that when an item is moved to a different parent, because of the fact
                // that -[Stark moveToBkmxParent:atIndex:] first moves the item out of the old
                // parent's children, which causes Core Data to nullify the 'parent' relationship,
                // and THEN moves the item into the new parent's children, which causes Core
                // Data to set a new 'parent' relationship, this method will be invoked twice,
                // firstly to set the parent from old to nil, and secondly to set the parent
                // from nil to new.  I tried to change -[Stark moveToBkmxParent:atIndex:] to do
                // it the other way around.  This immediately caused a problem that when the item
                // was deleted by -[NSMutableSet(Indexing) removedIndexedObject:], its index was
                // now the index in the new siblings instead of the index in the old siblings.
                // To fix that, I implemented and used a method
                // -[NSMutableSet(Indexing) removedIndexedObject:atIndex:] instead, which worked
                // OK except now things were screwed up if I simply moved items down in the same
                // family.  Also I saw an extra undo group, and an array underrun exception.
                // I'm not sure if these were related, but with with hairy issues like that going
                // on I decided to just put it back the way it was and allow this method to
                // be invoked twice.  At least the notifications it causes are coalesced.
                Stark* oldCollection = [oldValue collection] ;
                Stark* newCollection = [newValue collection] ;
                if ((newCollection != oldCollection)) {
                    // If stark was moved out of a collection where it had duped another stark
                    dupesMaybeDisparaged = YES ;
                    
                    // If stark was moved in to a collection where it now dupes another stark,
                    // unless it was orphaned (new parent = nil)
                    if (newValue != nil) {
                        dupesMaybeMore = YES ;
                    }
                    
                    // Now, doing both of the above looks wrong when in fact the first event
                    // above what was actually happened.  However, it is possible that,
                    // although a dupe was disparaged, another dupe could have been created
                    // by pairing with a third stark in the destination collection.
                    // Therefore, it is appropriate in the Dupes report to see one dupe
                    // disappear at the same time that "New duplicates, not shown, may exist"
                    // is displayed.
                }
            }
        }
        else if ([keyPath isEqualToString:constKeyRating]) {
            if ([[self shig] sortByValue] == BkmxSortByRating) {
                unsorted = YES ;
            }
        }
        else if ([keyPath isEqualToString:constKeyTags]) {
            starkTouched = YES;
        }
        
        if (![[[BkmxBasis sharedBasis] trivialAttributes] member:keyPath]) {
            [[self chaker] updateStark:object
                                   key:keyPath
                              oldValue:oldValue
                              newValue:newValue] ;
#if 0 
#warning Logging when BkmxDoc's objectWillChangeNote: sets a lastModifiedDate
            NSLog(@"-[BkmxDoc objChgNot:] %@", [object shortDescription]) ;
            NSLog(@"     keyPath: %@", keyPath) ;
            NSLog(@"     oldValue: %@", [oldValue shortDescription]) ;
            NSLog(@"     newValue: %@", [newValue shortDescription]) ;
#endif
            
            affectedStark = (Stark*)object ;
        }
    }
    else if ([object isKindOfClass:[Tag class]]) {
        affectedTag = object;
        tagTouched = YES;
    }
    else if ([object isKindOfClass:[Bookshig class]]) {
        if ([keyPath isEqualToString:constKeyIgnoreDisparateDupes]) {
            if ([newValue boolValue]) {
                dupesMaybeDisparaged = YES ;
            }
            else {
                dupesMaybeMore = YES ;
            }
        }
        else if ([keyPath isEqualToString:constKeyDefaultSortable]) {
            unsorted = YES ;
        }
        else if ([keyPath isEqualToString:constKeyFilterIgnoredPrefixes]) {
            unsorted = YES ;
        }
        else if ([keyPath isEqualToString:constKeyRootSortable]) {
            unsorted = YES ;
        }
        else if ([keyPath isEqualToString:constKeySortBy]) {
            unsorted = YES ;
        }
        else if ([keyPath isEqualToString:constKeySortingSegmentation]) {
            unsorted = YES ;
        }
    }
    else if ([object isKindOfClass:[Dupe class]]) {
        if ([keyPath isEqualToString:constKeyStarks]) {
            if ([newValue count] < 2) {
#if 0
#warning NOT deleting dupes
#else
                [[self managedObjectContext] deleteObject:object] ;
                dupesMaybeVestiged = YES ;
#endif
            }
            
            // Note: We reload data in -checkAndRemoveDupeVestiges, after
            // coalescing, since doing it here repeatedly took all day.
        }
    }
    
    // If BkmxDoc had an -objectDidChangeNote: method which was invoked
    // for all changes, it would be better to put
    // the following in objectDidChangeNote:, because then the
    // desired undo action would never be overwritten by the action
    // of post-change business logic.  For example:
    //    -[Trigger setTriggerType]
    // But since we don't, we invoke it here, and
    // re-invoke it at the end of setters that require it.
    [self setUndoActionNameForAction:SSYModelChangeActionModify
                              object:object
                           objectKey:nil
                          updatedKey:keyPath
                               count:0] ;
    
    // Conclusion 1.  Remove from dupe if applicable
    if (maybeRemoveFromDupe || definitelyRemoveFromDupe) {
        Stark* stark = (Stark*)object ;
        Dupe* dupe = [stark dupe] ;
        if (dupe) {
            NSString* url = [stark url] ;
            if (
                // Case 1: url has apparently been changed:
                ![[dupe url] isEqualToString:url]
                ||
                // Case 2: isAllowedDupe has apparently been switched on
                definitelyRemoveFromDupe
                ) {
                    [stark setDupe:nil] ;
                    // Don't worry about updating the dupe now.
                    // The above will trigger ^another^ kvo notification,
                    // subsequently causing this method to be invoked
                    // ^again^, with object = theDupe.
                }
        }
    }
    
    // In order to take advantage of queueing and coalescing, instead of invoking removeAllDupesThatAreNoLongerDupes
    // directly, we enqueue further notifications.
    if (dupesMaybeVestiged) {
        [self postDupesMayContainVestiges] ;
    }
    
    if (unsorted) {
        [self postSortMaybeNot] ;
    }
    
    if (dupesMaybeMore) {
        [self postDupesMaybeMore] ;
    }
    
    if (dupesMaybeDisparaged) {
        [self postDupesMaybeDisparaged] ;
    }
    
    if (unverified) {
        [self postVerifyMaybeNot] ;
    }
    
    if (starkTouched && affectedStark) {
        [self postTouchedStark:affectedStark] ;
    }
    
    if (tagTouched) {
        [self postTouchedTag:affectedTag] ;
    }
}

- (NSArray*)selectedStarks {
    return [[self bkmxDocWinCon] selectedStarks] ;
}

- (Stark*)selectedStark {
    Stark* answer = [[self selectedStarks] lastObject] ;
    return answer ;
}

- (void)expandRootChildren:(BOOL)expandNotCollapse {
    for (Stark* child in [[[self starker] root] children]) {
        [child setIsExpanded:[NSNumber numberWithBool:expandNotCollapse]] ;
    }
    
    [[self bkmxDocWinCon] reloadContent] ;
}

/*!
 @brief    Configuring a new document, Step 3
 
 @param    doneInvocation  Assumed to have been retained earlier and is
 released in this method
 */
- (void)didEndAskImportSheet:(NSWindow*)sheet
                  returnCode:(NSInteger)returnCode
              doneInvocation:(NSInvocation*)doneInvocation {
#if 0
#warning Ending at didEndAskImportSheet
    return ;
#endif
    NSInvocation* saveAndClearUndo = [NSInvocation invocationWithTarget:self
                                                               selector:@selector(saveAndClearUndo)
                                                        retainArguments:YES
                                                      argumentAddresses:NULL] ;
    NSArray* invocations = [NSArray arrayWithObjects:
                            saveAndClearUndo,
                            doneInvocation,  // may be nil
                            nil] ;
    /* Note RetainIxportSheetDone
     doneInvocation should have been retained by callers.  There are 3
     cases.  For some reason, Case 3 in macOS 10.14.4 Beta 5 will not crash
     if unretained, but Case 1 will crash.  Did not test other cases in other
     systems because one case crashing is enough :) */
    [doneInvocation release] ;
    NSInvocation* grandDoneInvocation = [NSInvocation invocationWithInvocations:invocations] ;

    if (returnCode == NSAlertFirstButtonReturn) {
        // Do import, save, doneInvocation

        NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     // Since we've definitely got the GUI here, deference is ask
                                     [NSNumber numberWithInteger:BkmxDeferenceAsk], constKeyDeference,
                                     [NSNumber numberWithInteger:BkmxPerformanceTypeUser], constKeyPerformanceType,
                                     [NSNumber numberWithBool:YES], constKeyIfNotNeeded,
                                     self, constKeyDocument,
                                     nil] ;
        [self importLaInfo:info
       grandDoneInvocation:grandDoneInvocation] ;
    }
    else {
        // Do save, doneInvocation
        [grandDoneInvocation invoke] ;
    }
}

/*!
 @brief    Configuring a new document, Step 2
 */
- (void)newDocWizardAskImportThenInvoke:(NSInvocation*)doneInvocation {
    if ([[[self macster] importers] count] > 0) {
        SSYAlert* alert = [SSYAlert alert] ;
        [alert setIconStyle:SSYAlertIconInformational] ;
        [alert setButton1Title:@"Import Existing Bookmarks"] ;
        [alert setButton3Title:@"Create Empty Document"] ;
        [alert setWindowTitle:[[BkmxBasis sharedBasis] labelNewBkmxDoc]] ;
        [alert setSmallText:@"You probably want to import existing bookmarks from the web browsers you just indicated."] ;

        /* Allow user to focus her attention on the alert. */
        [[self progressView] clearAll] ;

        [self runModalSheetAlert:alert
                       resizeable:NO
                       iconStyle:SSYAlertIconInformational
                   modalDelegate:self
                  didEndSelector:@selector(didEndAskImportSheet:returnCode:doneInvocation:)
                     contextInfo:[doneInvocation retain]] ;
        // doneInvocation is released in -didEndAskImportSheet:::
    }
    else {
        [self didEndAskImportSheet:nil
                        returnCode:NSAlertThirdButtonReturn
                    doneInvocation:[doneInvocation retain]] ;
        // doneInvocation is released in -didEndAskImportSheet:::
    }
}

- (void)setDoOpenAfterLaunch {
    [[NSUserDefaults standardUserDefaults] setDoOpenAfterLaunch:YES
                                                        docUuid:[self uuid]] ;
}

- (void)askOpenOnLaunch {
    /* Without the following delay, when creating a new document, for some
     reason the -saveDocument: method run by -[BkmxDoc saveDocumentFinalOpType:]
     (which is invoked by OperationSave) will not show the save sheet.  It is
     as though the sheet shown by askOpenOnLaunchNow not only precedes but
     cancels the sheet shown by -saveDocument:. */
    [self performSelector:@selector((askOpenOnLaunchNow))
               withObject:nil
               afterDelay:1.0];
}

- (void)askOpenOnLaunchNow {
    SSYAlert* alert = [SSYAlert alert] ;
    [alert setSmallText:[NSString localizeFormat:
                         @"question%0",
                         [[BkmxBasis sharedBasis] labelDoOpenAfterLaunch]]] ;
    [alert setButton1Title:[NSString localize:@"no"]] ;
    [alert setButton2Title:[NSString localize:@"yes"]] ;

    NSArray* invocations = [NSArray arrayWithObjects:
                            // Default button.  "No".  Proceed to end…
                            (id)[NSNull null],
                            // Alternate button.  "Yes".  set doOpenAfterLaunch, then end……
                            [NSInvocation invocationWithTarget:self
                                                      selector:@selector(setDoOpenAfterLaunch)
                                               retainArguments:YES
                                             argumentAddresses:NULL],
                            nil] ;

    [self runModalSheetAlert:alert
                  resizeable:NO
                   iconStyle:SSYAlertIconInformational
               modalDelegate:[SSYSheetEnder class]
              didEndSelector:@selector(didEndGenericSheet:returnCode:retainedInvocations:)
                 contextInfo:[invocations retain]] ;
}

- (void)configureNewAskingForClients:(BOOL)askForClients {
    // Always invocation2: Configure Bookshig, BookMacsterizer, Syncers, etc.
    NSInvocation* invocation2 = [NSInvocation invocationWithTarget:self
                                                          selector:@selector(configureNewAfterClients)
                                                   retainArguments:YES
                                                 argumentAddresses:NULL] ;
    // Not always invocation1: Choose clients
    NSInvocation* invocation1 = nil ;
    if (askForClients && [ClientsWizWinCon canOfferAnyClients]) {
        invocation1 = [NSInvocation invocationWithTarget:[ClientsWizWinCon class]
                                                selector:@selector(runWithBkmxDoc:thenInvoke:)
                                         retainArguments:YES
                                       argumentAddresses:&self, &invocation2, NULL] ;
        [invocation1 invoke] ;
    }
    else {
        // This branch added in BookMacster 1.16.4.
        // No local clients with any bookmarks
        [invocation2 invoke] ;
    }
}

- (void)configureNewAfterClients {
    Bookshig* shig = [self shig] ;
    Macster* macster = [self macster] ;

    [shig configureStructureForClients] ;
    [shig configurePreferredCatchype] ;

    // Set the last user-defined column in the Main Content View to something appropriate
    NSString* key = nil ;
    if ([[macster importers] count] > 1) {
        key = constKeyClients ;
    }
    else if ([[macster importers] count] == 1) {
        Class extoreClass = [[(Importer*)[[macster importers] anyObject] client] extoreClass] ;
        for (NSString* attribute in [Stark thirdAttributePriority]) {
            if ([extoreClass canEditAttribute:attribute
                                      inStyle:1]) {
                key = attribute ;
                break ;
            }
        }
    }
    if (!key) {
        key = constKeyTags ;
    }
    [(StarkTableColumn*)[[[[self bkmxDocWinCon] contentOutlineView] tableColumns] objectAtIndex:2] selectUserDefinedMenuItemForKey:key] ;  // constKeyVisitCountString

    // Set outlineMode appropriately
    BOOL outlineMode = NO ;
    if ([[macster clients] count] == 0) {
        // Prefer this as the default
        outlineMode = YES ;
    }
    else {
        for (Importer* importer in [macster importers]) {
            const ExtoreConstants* constants_p = [[[importer client] extoreClass] constants_p] ;
            // Defensive programming, in case constants_p is NULL.
            if (constants_p) {
                if ((constants_p->hasOrder) || (constants_p->hasFolders)) {
                    outlineMode = YES ;
                    break ;
                }
            }
        }
    }
    [[self bkmxDocWinCon] setOutlineMode:outlineMode] ;

    BOOL askOpenOnLaunch ;
    if ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppBookMacster) {
        askOpenOnLaunch = [[[NSUserDefaults standardUserDefaults] docUuidsToOpenAfterLaunch] count] > 0 ;
        if (askOpenOnLaunch) {
            askOpenOnLaunch = YES ;
        }
        else {
            // Don't ask,
            askOpenOnLaunch = NO ;
            // just do it.
            [self setDoOpenAfterLaunch] ;
        }
    }
    else {
        askOpenOnLaunch = NO ;
    }
    
    NSInvocation* thenInvoke = nil;
    NSMutableDictionary* saveInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInteger:NSSaveOperation], constKeySaveOperation,
                                     @YES, constKeyIsNewBeNice,
                                     nil] ;
    NSInvocation* saveInvocation = [NSInvocation invocationWithTarget:self
                                                             selector:@selector(saveDocumentInfo:)
                                                      retainArguments:YES
                                                    argumentAddresses:&saveInfo];

    NSArray* invocations;
    if (askOpenOnLaunch) {
        /* See Note ClangAndNSInvocationCategory to learn why I do not use
         my -[NSInvocation invocationWithInvocations:] method here. */
        invocations = @[
                        [NSInvocation invocationWithTarget:self
                                                  selector:@selector(askOpenOnLaunch)
                                           retainArguments:YES
                                         argumentAddresses:NULL],
                        saveInvocation];
        thenInvoke = [NSInvocation invocationWithTarget:[NSInvocation class]
                                               selector:@selector(invokeInvocations:)
                                        retainArguments:YES
                                      argumentAddresses:&invocations];
    }
    else if ([[BkmxBasis sharedBasis] isShoeboxApp]) {
        /* See Note ClangAndNSInvocationCategory to learn why I do not use
         my -[NSInvocation invocationWithInvocations:] method here. */
        invocations = @[
                        [NSInvocation invocationWithTarget:[self macster]
                                                  selector:@selector(ensureAutoSyncersExistAfterDelay)
                                           retainArguments:YES
                                         argumentAddresses:NULL],
                        saveInvocation];
        thenInvoke = [NSInvocation invocationWithTarget:[NSInvocation class]
                                               selector:@selector(invokeInvocations:)
                                        retainArguments:YES
                                      argumentAddresses:&invocations];
    } else {
        thenInvoke = saveInvocation;
    }
    
    switch ([[BkmxBasis sharedBasis] iAm]) {
        case BkmxWhich1AppSmarky:
        case BkmxWhich1AppSynkmark:
            // Don't ask whether to import, just do it
            [self didEndAskImportSheet:nil
                            returnCode:NSAlertFirstButtonReturn
                        doneInvocation:[thenInvoke retain]] ;
            /* Why retain doneInvocation? See Note RetainIxportSheetDone.
             This is Case 3. */
            break ;
        case BkmxWhich1AppMarkster:
            NSLog(@"Internal Error 624-5959") ;
            break;
        case BkmxWhich1AppBookMacster:
            // Ask before importing
            [self performSelector:@selector(newDocWizardAskImportThenInvoke:)
                       withObject:thenInvoke // could be nil
                       afterDelay:0.0] ;
            break ;
    }
}

/*
 Here's a little flow chart of where we can go from here.
 The 2-branch decisions (1)-(3) are made in prior methods and passed
 along via 'done' invocations or 'done' target+selectors.
 Because Decision (3) may be prescribed depending on
 Decision (2), there are only (2+1)*2*2=12 possibilities
 instead of 2^4=16.
 *     Import  askOpenOnLaunch   setOpenOnLaunch
 *       0           0                 0            Tested OK in BookMacster 1.5
 *       0           1                 0            Tested OK in BookMacster 1.5
 *       0           1                 1            Tested OK in BookMacster 1.5
 *       1           0                 0            Tested OK in BookMacster 1.5
 *       1           1                 0            Tested OK in BookMacster 1.5
 *       1           1                 1            Tested OK in BookMacster 1.5
 * 
 * 
 *     configureNewAfterClients
 *                |
 *                V
 *   newDocWizardAskImportThenInvoke:
 *                |
 *                V
 *  didEndAskImportSheet:returnCode:doneInvocation: 
 *                |
 *               (1)-------------------\
 *                |                    |
 *                V                    |
 *          importLaInfo:              |
 *                |                    |
 *                V                    |
 *        saveAndClearUndo             |
 *                |                    |
 *                |<-------------------/
 *                |
 *               (2)-------------------\
 *                |                    |
 *                V                    |
 *         askOpenOnLaunch             |
 *                |                    |
 *  /------------(3)<------------------/
 *  |             |
 *  |             V
 *  |     setDoOpenAfterLaunch
 *  |             |
 *  |             | 
 *  \------------>|  
 *                |
 *                |
 *                V
 *              "end"
 */

- (NSString*)badShoeboxClientDescription {
    NSInteger countOfClients = 0 ;
    NSInteger countOfBadClients = 0 ;
    
    Macster* macster = [self macster] ;
    for (Client* client in [macster clients]) {
        countOfClients++ ;
        if (([client importer] == nil) || ([client exporter] == nil)) {
            countOfBadClients++ ;
        }
    }
    
    NSString* answer = nil ;
    if ((countOfClients < 1) || (countOfBadClients > 0)) {
        answer = [NSString stringWithFormat:
                  @"%ld clients, %ld bad",
                  (long)countOfClients,
                  (long)countOfBadClients] ;
    }
    
    return answer ;
}

- (void)configureNewShoebox {
    switch ([[BkmxBasis sharedBasis] iAm]) {
        case BkmxWhich1AppSmarky:
        case BkmxWhich1AppSynkmark:;
            NSString* clientIssue = [self badShoeboxClientDescription] ;
            if (clientIssue) {
                NSString* msg = [NSString stringWithFormat:@"%@: Will fix", clientIssue] ;
                [[BkmxBasis sharedBasis] logFormat:msg] ;
                
                switch ([[BkmxBasis sharedBasis] iAm]) {
                    case BkmxWhich1AppSmarky:;
                        Macster* macster = [self macster] ;
                        [macster deleteAllClients] ;  // Probably not needed
                        Clientoid* clientoid = [Clientoid clientoidThisUserWithExformat:constExformatSafari
                                                                            profileName:nil] ;
                        Client* client = [macster freshClientAtIndex:NSNotFound
                                                           singleUse:NO] ;
                        [client setIvarsThenInvokeWaitingIfAnyLikeClientoid:clientoid] ;
                        [self configureNewAfterClients] ;
                        break ;
                    case BkmxWhich1AppSynkmark:
                        [self configureNewAskingForClients:YES] ;
                        break ;
                    default:
                        break ;
                }
            }
            break;
        case BkmxWhich1AppMarkster:;
            NSMutableDictionary* saveInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             [NSNumber numberWithInteger:NSSaveOperation], constKeySaveOperation,
                                             @YES, constKeyIsNewBeNice,
                                             nil] ;
            [self saveDocumentInfo:saveInfo];
            break;
        default:;
    }
}

- (void)migrateLegacyBraveToBravePublic {
    Macster* macster = [self macster];

    for (Client* client in macster.clients) {
        if ([client.exformat isEqualToString:@"Brave"]) {
            client.exformat = constExformatBravePublic;
        }
    }
    
    for (Starxid* starxid in [[self starxider] allObjects]) {
        for (Clixid* clixid in [starxid clixids]) {
            NSString* clidentifier = [clixid clidentifier];
            NSString* exformat = [Clientoid exformatInClidentifier:clidentifier];
            if ([exformat isEqualToString:@"Brave"]) {
                clidentifier = [Clientoid clidentifier:clidentifier
                                       withNewExformat:constExformatBravePublic];
                clixid.clidentifier = clidentifier;
            }
        }
    }

    [macster save];
}

#pragma mark * Debugging

- (void)setFileURL:(NSURL*)url {
    [super setFileURL:url];
   /* This override is necessary when creating a new document, because during
    the first call to -setUuid:, the fileURL is nil and therefore it is not
    written to the auxiliary data plist on disk. */
    if (url) {
        [self initializeCommonAfterFileUrlSetButBeforePersistenceStackIsUp];

        [self writeUuidToDisk];
        /* We need to do this now.  There was probably a prior invocation
         of writeBasicAuxiliaryData during the initial save of this new
         document, in -doHousekeepingBeforeSave. However, that time, -fileURL
         was nil, so -writeBasicAuxiliaryData would have been a noop. */
        [self writeBasicAuxiliaryData];
    }
}

#if 0
- (void)setFileType:(NSString*)fileType {
    [super setFileType:fileType] ;
}
- (void)setFileModificationDate:(NSDate*)modDate {
    [super setFileModificationDate:modDate] ;
}
#endif

#if 0
- (void)logDebugUndoGroupingLevelUnsafeWithTag:(NSNumber*)tag {
    NSLog(@"tag: %4ld  undo gl=%ld  um=%p", (long)[tag integerValue], (long)[[self undoManager] groupingLevel], [self undoManager]) ;
}

- (void)logDebugUndoGroupingLevelWithTag:(NSInteger)tag {
    [self performSelectorOnMainThread:@selector(logDebugUndoGroupingLevelUnsafeWithTag:)
                           withObject:[NSNumber numberWithInteger:tag]
                        waitUntilDone:YES] ;
}
#endif

#if 0
- (void)debugLogObjectsEntityName:(NSString*)entityName {
    NSManagedObjectContext* moc = [self managedObjectContext] ;
    [moc processPendingChanges] ;  // Has no effect.
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init] ;
    NSArray* fetches = nil ;
    if (moc) {
        [fetchRequest setEntity:[NSEntityDescription SSY_entityForName:entityName
                                                inManagedObjectContext:moc]] ;
        fetches = [moc executeFetchRequest:fetchRequest
                                     error:NULL] ;
    }
    [fetchRequest release] ;
    
    NSLog(@"This BkmxDoc contains %ld objects of entity %@:\n%@",
          (long)[fetches count],
          entityName,
          [fetches shortDescription]) ;
    // -shortDescription is a method I've written to give pertinent info
    // about managed objects and collections of managed objects, without
    // filling the console/screen like -[NSManagedObject description] does.
}
#endif

@end
