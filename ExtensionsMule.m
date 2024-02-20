#import "ExtensionsMule.h"
#import "NSString+LocalizeSSY.h"
#import "Client.h"
#import "Extore.h"
#import "Clientoid.h"
#import "SSYOperationQueue.h"
#import "SSYOtherApper.h"
#import "NSDictionary+SimpleMutations.h"
#import "NSError+InfoAccess.h"
#import "NSError+MyDomain.h"
#import "BkmxDocumentController.h"
#import "NSError+MoreDescriptions.h"
#import "SSYOperationQueue.h"
#import "BkmxBasis.h"

enum ExtensionsMuleTask_enum {
	ExtensionsMuleTaskTest = 0,
	ExtensionsMuleTaskUninstall = 2
} ;
typedef enum ExtensionsMuleTask_enum ExtensionsMuleTask ;

NSString* const constKeyIsActualTestResult = @"isActualTestResult" ;
NSString* const constKeyExtensionIndex = @"extensionIndex" ;
NSString* const constKeyIgnoredQueue = @"ignoredQueue" ;

@interface ExtensionsMule ()

@property (retain) NSDate* testTimeout ;
@property (retain) NSMutableDictionary* currentInfo ;
@property (retain) NSInvocation* workToDo ;
@property (assign) NSObject <ExtensionsCallbackee> * delegate ;
@property (retain, readonly) SSYOperationQueue* operationQueue ;

@end

@implementation ExtensionsMule

/* In the following four methods, we encode the information into the 64-bit
 integer tag like this:
 
00000000 00000000 00000000 00000000 TTTTTTTT TTTTTTTT IIIIIIII 0000000U
 
 where
 
 TTTTTTTT TTTTTTTT = extore index      mask = 0x00000000FFFF0000
          IIIIIIII = extension index   mask = 0x000000000000FF00
                 U = isAnUpdate        mask = 0x0000000000000001
*/

+ (NSInteger)tagForExtoreIndex:(NSInteger)extoreIndex
                extensionIndex:(NSInteger)extensionIndex
                    isAnUpdate:(BOOL)isAnUpdate {
    NSInteger isUpdateTerm = isAnUpdate ? 1 : 0 ;
    return ((extoreIndex << 16) + (extensionIndex << 8) + isUpdateTerm) ;
}

+ (NSInteger)extoreIndexForTag:(NSInteger)tag {
    return tag >> 16 ;
}

+ (NSInteger)extensionIndexForTag:(NSInteger)tag {
    NSInteger answer = (tag & 0x000000000000FF00) >> 8 ;
    return answer ;
}

+ (NSInteger)isAnUpdateForTag:(NSInteger)tag {
    BOOL answer = ((tag & 0x0000000000000001) == 0) ? NO : YES ;
    return answer ;
}

@synthesize extores = m_extores ;
@synthesize testTimeout = m_testTimeout ;
@synthesize workToDo = m_workToDo ;
@synthesize currentInfo = m_currentInfo ;
@synthesize delegate = m_delegate ;

- (SSYOperationQueue*)operationQueue {
	if (!m_operationQueue) {
		m_operationQueue = [[SSYOperationQueue alloc] init] ;
	}
	
	return m_operationQueue ;
}

- (NSMutableDictionary*)results {
	if (!m_results) {
		m_results = [[NSMutableDictionary alloc] init] ;
	}
	
	return m_results ;
}

- (void)deleteClientsOfExtores:(NSArray*)extores {
	for (Extore* extore in extores) {
		Client* client = [extore client] ;
		NSManagedObjectContext* moc = [client managedObjectContext] ;
		[moc deleteObject:client] ;
	}
}

- (void)dealloc {
	[[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self] ;
	[[[self currentInfo] objectForKey:constKeyLaunchTimeoutTimer] invalidate] ;
	
	[self deleteClientsOfExtores:[self extores]] ;
	
	[m_extores release] ;
	[m_results release] ;
	[m_testTimeout release] ;
	[m_currentInfo release] ;
	[m_workToDo release] ;
	[m_operationQueue release] ;
	
    [super dealloc] ;
}

#define LOGGING_MEMORY_MANAGEMENT_FOR_AOM 0
#if LOGGING_MEMORY_MANAGEMENT_FOR_AOM
- (id)retain {
	id x = [super retain] ;
	NSString* line = [NSString stringWithFormat:@"%@ %p retained %03ld %@", [self className], self, (long)[self retainCount], SSYDebugCaller()] ;
    NSLog(@"%@", line) ;
	return x ;
}
- (id)autorelease {
	id x = [super autorelease] ;
	NSString* line = [NSString stringWithFormat:@"%@ %p autoreleased %@",  [self className], self, SSYDebugCaller()] ;
    NSLog(@"%@", line) ;
	return x ;
}

- (oneway void)release {
	NSInteger rc = [self retainCount] ;
    NSString* className = [self className] ;
	[super release] ;
	NSString* line = [NSString stringWithFormat:@"%@ %p released %03ld %@",  className, self, (long)rc, SSYDebugCaller()] ;
	//[SSYLinearFileWriter writeLine:line] ;
    NSLog(@"%@", line) ;
	return ;
}
#endif


- (NSMutableDictionary*)makeInfoForExtore:(Extore*)extore {
	return [NSMutableDictionary dictionaryWithObjectsAndKeys:
			extore, constKeyExtore,
			nil] ;
}

- (void)finishInstallInfo:(NSDictionary*)info {
	Extore* extore = [info objectForKey:constKeyExtore] ;
	NSError* error = [info objectForKey:constKeyError] ;
	if (!error) {
		// Needed to pick up error 256456, possibly others???
		error = [extore error] ;
	}
	
	if (error) {
		NSObject <ExtensionsCallbackee> * delegate = [self delegate] ;
		[delegate presentError:error] ;
	}
	
	[[self delegate] muleIsDoneForExtore:extore] ;
}


- (void)quitBrowserForExtore:(Extore*)extore
					someInfo:(NSMutableDictionary*)someInfo
				  doneTarget:(id)doneTarget
				doneSelector:(SEL)doneSelector {
	NSString* msg = [NSString localizeFormat:
					 @"quitting%0",
					 [extore ownerAppDisplayName]] ;
	[[self delegate] beginIndeterminateTaskVerb:msg
											forExtore:extore] ;
	
	NSMutableDictionary* info = [self makeInfoForExtore:extore] ;
	if (someInfo) {
		[info addEntriesFromDictionary:someInfo] ;
	}
	if (![info objectForKey:constKeyDeference]) {
        [info setObject:[NSNumber numberWithInteger:BkmxDeferenceQuit]
                 forKey:constKeyDeference] ;
    }
    [info setObject:[NSNumber numberWithInteger:BkmxClientTaskInstall]
                    forKey:constKeyClientTask] ;
	[info setObject:[NSNumber numberWithInteger:BkmxPerformanceTypeUser]
			 forKey:constKeyPerformanceType] ;
	[[self operationQueue] cancelAllOperations] ;
    NSArray* selectorNames = [NSArray arrayWithObjects:
                              @"quillBrowser",
                              nil] ;
	[[self operationQueue] queueGroup:NSStringFromSelector(_cmd)
                                addon:NO
                        selectorNames:selectorNames
                                 info:info
                                block:NO
                           doneThread:nil     // defaults to the current (main) thread
                           doneTarget:doneTarget
                         doneSelector:doneSelector
                         keepWithNext:NO] ;
}

- (void)quitBrowserForExtore:(Extore*)extore {
	NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								 extore, constKeyExtore,
								 [NSNumber numberWithInteger:BkmxPerformanceTypeUser], constKeyPerformanceType,
								 nil] ;
	[self quitBrowserForExtore:extore
					  someInfo:info
					doneTarget:self
				  doneSelector:@selector(finishInstallInfo:)] ;
}

- (void)displayWaitingForClientForExtore:(Extore*)extore {
	NSString* msg = [NSString localizeFormat:
					 @"waitingFor%0",
					 [(Client*)[extore client] displayName]] ;
	[[self delegate] beginIndeterminateTaskVerb:msg
									  forExtore:extore] ;
}

- (void)launchThenTestInfo:(NSMutableDictionary*)info {
	Extore* extore = [info objectForKey:constKeyExtore] ;
    [extore retain] ;
    NSError* error = nil ;
	[extore launchOwnerAppPath:[extore browserBundlePath]
                      activate:NO
                       error_p:&error] ;
    if (error) {
        NSLog(@"Internal Error 521-02673 %@", [error longDescription]) ;
    }
    
	[self displayWaitingForClientForExtore:extore] ;

	[extore testExtensionForMule:self] ;
    [extore release] ;
}

- (void)clearResultsForExtore:(Extore*)extore {
    // Defensive programming
    if (!extore) {
        return ;
    }
	[[self results] setObject:[NSDictionary dictionary]
					   forKey:[[[extore client] clientoid] clidentifier]] ;
}

- (void)clearAllActualTestResults {
    NSDictionary* results = [[self results] copy] ;
	for (NSString* clidentifier in results) {
        NSDictionary* subdic = [[self results] objectForKey:clidentifier] ;
        subdic = [subdic dictionaryByRemovingObjectForKey:constKeyIsActualTestResult] ;
        [[self results] setObject:subdic
                           forKey:clidentifier] ;
    }
    [results release] ;
}

- (void)doUninstallForInfo:(NSDictionary*)info {
    Extore* extore = [info objectForKey:constKeyExtore] ;
    NSInteger extensionIndex = [[info objectForKey:constKeyExtensionIndex] integerValue] ;
    SSYAlert* alert = [SSYAlert alert];
    [alert setSmallText:[extore uninstallInstructionsForExtensionIndex:extensionIndex]];
    [alert setHelpAddress:[extore uninstallHelpAnchorForExtensionIndex:extensionIndex]];
    [alert setIconStyle:SSYAlertIconInformational];
    [[self delegate] presentAlert:alert
                  completionHandler:^(NSModalResponse response) {
                      [self clearResultsForExtore:extore] ;
                      [[self delegate] muleIsDoneForExtore:extore] ;
                  }];
}

/*!
 @brief    	Performs to some task, which may require that the
 browser be running in the correct profile, and if so ensures that indeed it
 is running in the correct profile before doing so.
 */

- (void)doTask:(ExtensionsMuleTask)task
		  info:(NSMutableDictionary*)info {
    /* Until 20180122, there was a test here to see if any documents had
     any operations in their operation queue, and to abort if so.  That aborted
     installation of the Opera extension during a first import, which is being
     made necessary since, as of this release, we're no longer supporting
     Style 1 with Opera.  So, I just eliminated that test-and-abort.  I hope
     there is no down-side to this.  I hope it was there as a vestige of some
     prior day when ExtensionsMule used the operation queue of the associated
     document.  At this time, ExtensionsMule has its own operation queue. */
    Extore* extore = [info objectForKey:constKeyExtore] ;
	if (task == ExtensionsMuleTaskUninstall) {
        // This does not require any pre-quitting of browsers.
        // Just do it.
		[self doUninstallForInfo:info] ;
	}	
	else {
        NSError* error = nil ;
        OwnerAppRunningState runningState = [extore ownerAppRunningStateError_p:&error] ;
        if (runningState == OwnerAppRunningStateError) {
            [SSYAlert alertError:error] ;
        }
		else if (
                 (runningState == OwnerAppRunningStateRunningProfileWrongOne)
                 ||
                 (runningState == OwnerAppRunningStateRunningProfileNotLoaded)
                 ) {
			// Worst case.  Must quit first, then proceed to
			// -launchThenTestInfo: as a doneSelector.
			SEL doneSelector = NULL ;
			switch (task) {
				case ExtensionsMuleTaskTest:
					doneSelector = @selector(launchThenTestInfo:) ;
					break ;
				default:
					NSLog(@"Internal Error 278-7342") ;
			}
			[extore updateOwnerAppQuinchState:OwnerAppQuinchStateNeedsQuill] ;
			[self quitBrowserForExtore:extore
							  someInfo:info
							doneTarget:self
						  doneSelector:doneSelector] ;
		}
		else if (runningState == OwnerAppRunningStateNotRunning) {
			// Middle case.  Not running.  Proceed immediately to
			// -launchThenTestInfo:.
			switch (task) {
				case ExtensionsMuleTaskTest:
					[self launchThenTestInfo:info] ;
					break ;
				default:
					NSLog(@"Internal Error 278-7376") ;
			}
		}
		else {
			// Must be OwnerAppRunningStateRunningProfileOk
			// Best case.  Already running in correct profile.  Just do it.
			switch (task) {
				case ExtensionsMuleTaskTest:
					[extore testExtensionForMule:self] ;
					break ;
				default:
					NSLog(@"Internal Error 278-7374") ;
			}
		}
	}
}

- (void)installForTag:(NSInteger)tag
               window:(NSWindow*)window {
	Extore* extore = [[self extores] objectAtIndex:[[self class] extoreIndexForTag:tag]] ;
    BOOL isAnUpdate = [[self class] isAnUpdateForTag:tag] ;
    NSInteger extensionIndex = [[self class] extensionIndexForTag:tag] ;
    NSString* howToForceAutoUpdateExtensionMessage = [extore messageHowToForceAutoUpdateExtensionIndex:extensionIndex];
    
    if (isAnUpdate && howToForceAutoUpdateExtensionMessage) {
        NSString* format = NSLocalizedString(@"%@ updates its extensions periodically.  Possibly you have not run %@ lately."
                                             @"\n\nTo update its extensions immediately,"
                                             @"\n\n• Run %@."
                                             @"\n%@", nil) ;
        NSString* message = [NSString stringWithFormat:
                             format,
                             [extore ownerAppDisplayName],  // without profile name
                             [[extore client] displayName],   // with profile name
                             [[extore client] displayName],   // with profile name
                             howToForceAutoUpdateExtensionMessage];
        SSYAlert* alert1 = [SSYAlert alert] ;
        [alert1 setSmallText:message] ;
        [alert1 setButton1Title:@"OK"] ;
        [alert1 setIconStyle:SSYAlertIconInformational] ;
        [alert1 doooLayout] ;
        [window beginSheet:[alert1 window]
         completionHandler:^void(NSModalResponse modalResponse) {
             // Nothing to do
         }] ;
    }
    else {
        [extore installExtensionIndex:extensionIndex
                           hostWindow:window
                                 mule:self] ;
    }
}

- (void)uninstallForTag:(NSInteger)tag {
	Extore* extore = [[self extores] objectAtIndex:[[self class] extoreIndexForTag:tag]] ;
    NSInteger extensionIndex = [[self class] extensionIndexForTag:tag] ;
    NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithInteger:extensionIndex], constKeyExtensionIndex,
                                 extore, constKeyExtore,
                                 nil] ;
	[self doTask:ExtensionsMuleTaskUninstall
            info:info] ;
}



- (void)testForExtore:(Extore*)extore {
	[self displayWaitingForClientForExtore:extore] ;

	NSMutableDictionary* info = [self makeInfoForExtore:extore] ;
	
	[self setTestTimeout:[NSDate dateWithTimeIntervalSinceNow:7.0]] ;
	
	[self doTask:ExtensionsMuleTaskTest
            info:info] ;
}

- (void)refreshResults {
	NSArray* newExtores ;
	NSMutableDictionary* newResults ;
	[Extore addonableExtores_p:&newExtores
					 results_p:&newResults] ;
	
	// If newExtores' clientoids all match clientoids of existing extores, discard
	// them and delete their clients.  Otherwise, replace
	// old extores with new, and delete the existing extores' clients.
	// The reason we go through the trouble of conserving the existing extores is
	// in case there are tests still in progress for which we will receive a callback
	// upon completion.
	BOOL allMatched = NO ;
	if ([newExtores count] == [[self extores] count]) {
		allMatched = YES ;
		// This matching by index will work since -addonableExtores_p:: returns
		// extores ordered deterministically
		NSInteger i = 0 ;
		for (Extore* oldExtore in [self extores]) {
			Extore* newExtore = [newExtores objectAtIndex:i] ;
			if (![[[newExtore client] clientoid] isEqual:[[oldExtore client] clientoid]]) {
				allMatched = NO ;
				break ;
			}
			i++ ;
		}
	}
	if (allMatched) {
		// No need to make new extores
		[self deleteClientsOfExtores:newExtores] ;
	}
	else {
		// Need new extores
		[self deleteClientsOfExtores:[self extores]] ;
		[self setExtores:newExtores] ;
	}
	
	// Replace results with new results, unless the old result is actual
	// and the new result is non-actual
	for (NSString* clidentifier in newResults) {
		NSDictionary* newResult = [newResults objectForKey:clidentifier] ;
		NSDictionary* oldResult = [[self results] objectForKey:clidentifier] ;
		BOOL newResultIsActual = [[newResult objectForKey:constKeyIsActualTestResult] boolValue] ;
		BOOL oldResultIsActual = [[oldResult objectForKey:constKeyIsActualTestResult] boolValue] ;
		if (!(oldResultIsActual && !newResultIsActual)) {
			[[self results] setObject:newResult
							   forKey:clidentifier] ;
		}
	}
}

- (void)muleRefreshAndDisplay {
    [self refreshResults] ;
    [[self delegate] refreshAndDisplay] ;
}

- (id)initWithDelegate:(NSObject <ExtensionsCallbackee> *)delegate {
	self = [super init] ;
	if (self) {
		[self setDelegate:delegate] ;
	}
	
	return self ;
}

- (void)extore:(Extore*)extore
	testResult:(NSDictionary*)result {
	// Return immediately if the given extore is
	// no longer in the 'extores' array, because it's probably been deallocced.
	// But don't use -indexOfObject: because that will probably sent a message
	// to it, potentially causing a crash.
	BOOL stillAlive = NO ;
	for (Extore* anExtore in [self extores]) {
		if (extore == anExtore) {
			stillAlive = YES ;
			break ;
		}
	}
	if (!stillAlive) {
		return ;
	}
	
    [self setTestTimeout:nil] ;
    result = [result dictionaryBySettingValue:[NSNumber numberWithBool:YES]
                                       forKey:constKeyIsActualTestResult] ;
    [[self results] setObject:result
                       forKey:[[[extore client] clientoid] clidentifier]] ;
    [[self delegate] muleIsDoneForExtore:extore] ;
}

- (void)uninstallAllExtensions {
	[self refreshResults] ;
	NSInteger extoreCount = [[self extores] count] ;
	for (NSInteger extoreIndex=0 ; extoreIndex<extoreCount; extoreIndex++) {
        NSInteger tag ;
        tag = [ExtensionsMule tagForExtoreIndex:extoreIndex
                                 extensionIndex:2
                                     isAnUpdate:NO] ;
		[self uninstallForTag:tag] ;
        tag = [ExtensionsMule tagForExtoreIndex:extoreIndex
                                 extensionIndex:1
                                     isAnUpdate:NO] ;
		[self uninstallForTag:tag] ;
	}
}

@end
