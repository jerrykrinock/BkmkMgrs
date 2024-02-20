#import "Operation_Common.h"
#import "BkmxGlobals.h"
#import "BkmxBasis+Strings.h"
#import "Extore.h"
#import "Client+SpecialOptions.h"
#import "SSYOtherApper.h"
#import "NSString+LocalizeSSY.h"
#import "NSError+SSYAdds.h"
#import "SSYProgressView.h"
#import "Ixporter.h"
#import "SSYDooDooUndoManager.h"
#import "BkmxGlobals.h"
#import "NSError+SSYAdds.h"
#import "AgentPerformer.h"
#import "NSInvocation+Nesting.h"
#import "SSYOperationQueue.h"
#import "Bookshig.h"
#import "Macster.h"
#import "NSDate+NiceFormats.h"
#import "NSError+SSYAdds.h"
#import "Starxider.h"
#import "Chaker.h"
#import "Stark.h"
#import "Starker.h"
#import "Stange.h"
#import "NSObject+MoreDescriptions.h"
#import "Trigger.h"
#import "ExportLog.h"
#import "Agent.h"
#import "Bkmslf.h"
#import "BkmslfWinCon.h"
#import "NSUserDefaults+Bkmx.h"
#import "StarkEditor.h"
#import "Stager.h"
#import "SSYSemaphore.h"
#import "AddonsMuleDriver.h"
#import "AddonsMule.h"

NSString* const constKeyMule = @"mule" ;
NSString* const constKeyExtensionInstaller = @"extensionInstaller" ;


@interface ExtensionInstaller : NSObject <AddonsCallbackee> {
    SSYOperation* m_operation ;
}

- (id)initWithOperation:(SSYOperation*)operation ;

@end

@interface ExtensionInstaller ()

@property (assign) SSYOperation* operation ;

@end

@implementation ExtensionInstaller

@synthesize operation = m_operation ;

- (id)initWithOperation:(SSYOperation*)operation {
    self = [super init] ;
    if (self) {
        [self setOperation:operation] ;
    }
    
    return self ;
}

- (void)beginIndeterminateTaskVerb:(NSString*)verb
                         forExtore:(Extore*)extore {
	Bkmslf* bkmslf = [[[self operation] info] objectForKey:constKeyDocument] ;
	[[bkmslf progressView] setIndeterminate:YES
                          withLocalizedVerb:verb] ;
}

- (void)muleIsDoneForExtore:(Extore*)extore {
    [[self operation] unlockLock] ;
	Bkmslf* bkmslf = [[[self operation] info] objectForKey:constKeyDocument] ;
    [[bkmslf progressView] clearAll] ;
    [[[self operation] info] removeObjectForKey:constKeyMule] ;
    [[[self operation] info] removeObjectForKey:constKeyExtensionInstaller] ;
}

- (void)presentError:(NSError*)error {
	Bkmslf* bkmslf = [[[self operation] info] objectForKey:constKeyDocument] ;
    [bkmslf presentError:error] ;
}

@end


@implementation SSYOperation (Operation_Common) 

/*
 This method was added in BookMacster 1.13.6.  This is to ensure that,
 for a new client, if an Extension 1 (syncing extension) is available,
 it is installed.  Prior to this, code in -[Macster macsterBusinessNote:]
 invoked -ensureForClient if applicable, which installed
 the extension immediately.  That was problematic because (1) it was
 unexpected by the user, (2) the modal sheet for installing the Firefox
 extension conflicted with the modal sheet suggesting to Export or
 Pause, and (3) it occurred even if the user intended a Client other
 than Firefox or Chrome, but Firefox or Chrome showed up as the default
 immediately upon clicking the (+) button to add a Client.
 
 This new code, instead, checks the installation during each import and export
 from the main app (NSApp).  If the user ignores our advice and does not export
 from the main app during initial configuration, this won't work.
 How can we catch that?
 */
- (void)ensureExtension1Installed {
	[self doSafely:_cmd] ;
}

- (void)ensureExtension1Installed_unsafe {
    if (NSApp) {
        Extore* extore = [[self info] objectForKey:constKeyExtore] ;
        Client* client = [extore client] ;
 
        BOOL mayInstall ;
        NSError* error = nil ;
        BOOL ok = [extore addonMayInstall:&mayInstall
                                  error_p:&error] ;
        if (ok && mayInstall) {
            NSDictionary* result = [extore peekAddon] ;
            NSError* error = [result objectForKey:constKeyError] ;
            NSInteger errorCode = [error code] ;
            if (
                ((errorCode & EXTORE_ERROR_CODE_MASK_EXTENSION1_NOT_FOUND) > 0)
                ||
                ((errorCode & EXTORE_ERROR_CODE_MASK_EXTENSION1_DOWNREV) > 0)
                ||
                ((errorCode & EXTORE_ERROR_CODE_MASK_PLUGIN_NOT_FOUND) > 0)
                ||
                ((errorCode & EXTORE_ERROR_CODE_MASK_PLUGIN_DOWNREV) > 0)
                ) {
                Bkmslf* bkmslf = [[client macster] bkmslf] ;
                NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             [NSNumber numberWithInteger:1], constKeyExtensionIndex,
                                             extore, constKeyExtore,
                                             bkmslf, constKeyDocument,
                                             [[self info] objectForKey:constKeyDeference], constKeyDeference,
                                             nil] ;
                [extore installAddonThenQuitItInfo:info
                                           error_p:&error] ;
            }
        }
    }
}

- (void)skipNoncleanupOperationsInOtherGroups {
	NSSet* goodGroups = [NSSet setWithObjects:
						 constGroupNameAgentPerformEnd,
						 [[self info] objectForKey:constKeySSYOperationGroup],
						 nil] ;
	[[self operationQueue] setSkipOperationsExceptGroups:goodGroups] ;
}

- (void)markAgentUnstaged {
	[Stager removeStagingForAgentUri:[[self info] objectForKey:constKeyAgentUri]
								 pid:[[self info] objectForKey:constKeyStagingPid]] ;	
}

- (void)getReadWriteStyles {
	// We may need to access the managed property [[extore client] extoreMedia],
	// so we must divert to the main thread as usual…
	[self doSafely:_cmd] ;
}

- (void)getReadWriteStyles_unsafe {
	Extore* extore = [[self info] objectForKey:constKeyExtore] ;

	NSError* error = nil ;
    BkmxReadWriteStyles readWriteStyles = [extore readWriteStylesError_p:&error] ;
    if (error) {
        [self setError:error] ;
    }
	[[self info] setObject:[NSNumber numberWithInteger:readWriteStyles]
					forKey:constKeyReadWriteStyles] ;
}

- (void)packExternalFile {
	BOOL ok = YES ;
	NSError* error = nil ;
	Extore* extore = [[self info] objectForKey:constKeyExtore] ;
	BkmxReadWriteStyles readWriteStyles = [[[self info] objectForKey:constKeyReadWriteStyles] integerValue] ;
	NSInteger importStyle = BkmxReadStyleFromReadWriteStyles(readWriteStyles) ;
	if ([extore shouldPackFilesForReadWriteStyle:importStyle]) {
		// It's important to catch the error here, since this is the first
		// time that the database will be accessed; errors are quite likely.
		ok = [extore packExternalFileError_p:&error] ;
	}
	
	if (!ok) {
		[self setError:error] ;
	}
}

- (void)packScratchFile {
	// This operation is skipped if we're doing a dry run (SDDR)
	if ([[[self info] objectForKey:constKeyIsDryRun] boolValue] == YES) {
		return ;
	}
	
	BOOL ok = YES ;
	NSError* error = nil ;
	Extore* extore = [[self info] objectForKey:constKeyExtore] ;
	BkmxReadWriteStyles readWriteStyles = [[[self info] objectForKey:constKeyReadWriteStyles] integerValue] ;
	NSInteger writeStyle = BkmxWriteStyleFromReadWriteStyles(readWriteStyles) ;
	if ([extore shouldPackFilesForReadWriteStyle:writeStyle]) {
		// It's important to catch the error here, since this is the first
		// time that the database will be accessed; errors are quite likely.
		ok = [extore packScratchFileError_p:&error] ;
	}
	
	if (!ok) {
		[self setError:error] ;
		[self errorizeIxportLog] ;
	}
}

- (void)beginUndoGrouping {
	// We're not doing any Core Data-base access, but NSUndoManager is not
	// thread safe either.
	[self doSafely:_cmd] ;

	[[self info] setObject:[NSNumber numberWithBool:YES]
					forKey:constKeyDidBeginUndoGrouping] ;
}

- (void)beginUndoGrouping_unsafe {
	[(SSYDooDooUndoManager*)[(Bkmslf*)[self owner] undoManager] beginManualUndoGrouping] ;
}


/*!
 @brief    Sets the undo action in the bkmslf's undo manager.

 @details  This method should be invoked after any other operation which
 might set an undo action might be invoked.&nbsp;  It wraps an _unsafe
 version because NSUndoManager is not thread-safe.
*/
- (void)setUndoActionName {
	NSString* actionName = [[self info] objectForKey:constKeyActionName] ;
	// In Worker, actionName will be nil.  Actually, this method should not
	// be queued and therefore not invoked in Worker, so the following if()
	// is defensive programming.  But probably a good idea.
	if (actionName) {
		[self doSafely:_cmd] ;
	}
}

- (void)setUndoActionName_unsafe {
	NSString* actionName = [[self info] objectForKey:constKeyActionName] ;
	//*** Commented out in BookMacster verison 1.3.5 since I don't see what this has to do with newExidsCount.
	//*** NSInteger newExidsCount = [[[self info] objectForKey:constKeyNewExidsCount] integerValue] ;
	//*** if (newExidsCount > 0) {
	//*** 	// The operation just completed was an export -- 20101124: Huh???
	//*** 	// actionName should be -[BkmxBasis(Strings) labelNewIdentifiers]
	//*** 	actionName = [NSString stringWithFormat:
	//*** 				  @"%@ (%d)",
	//*** 				  actionName,
	//*** 				  newExidsCount] ;
	//*** }
	[(SSYDooDooUndoManager*)[(Bkmslf*)[self owner] undoManager] setActionName:actionName] ;
}

- (void)checkBreath {
	NSError* error = nil ;
	Bkmslf* bkmslf = [[self info] objectForKey:constKeyDocument] ;

	BOOL ok = [bkmslf checkBreathError_p:&error] ;
	if (!ok) {
		[self setError:error] ;
	}	
}

- (void)renewExtore {
	[self doSafely:_cmd] ;
}

- (void)renewExtore_unsafe {
	Ixporter* ixporter = [[self info] objectForKey:constKeyIxporter] ;
	if (!ixporter) {
		NSError* error = SSYMakeError(458501, @"No ixporter in info") ;
		error = [error errorByAddingUserInfoObject:[self info]
											forKey:@"Bad info"] ;
		[self setError:error] ;
		return ;
	}
	
	NSError* error = nil  ;
	Extore* extore = [ixporter renewExtoreError_p:&error] ;
	
	if (extore) {
		[[self info] setObject:extore
						forKey:constKeyExtore] ;
	}
	else {
		error = [SSYMakeError(19675, @"Could not renew store") errorByAddingUnderlyingError:error] ;
		error = [error errorByAddingUserInfoObject:[[self info] objectForKey:constKeyIxporter]
											forKey:@"Ixporter"] ;
		[self setError:error] ;
	}
}


#if 0
// These methods were removed in BookMaster 1.10.2
/*!
 @brief    If running in MainApp, and our Client's media is this user,
 add key constKeyThisUserIxportStartDate, with value of current
 date, to given info dictionary and also to user defaults, synchronizing
 defaults.
 
 @details  The presence of this key will be 
 */
 ! ! ! ! ! ! ! ! ! ! ! ! ! ! THIS CODE IS #if REMOVED ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !
- (void)lockOutOthers {
	[self doSafely:_cmd] ;
}
- (void)lockOutOthers_unsafe {
 ! ! ! ! ! ! ! ! ! ! ! ! ! ! THIS CODE IS #if REMOVED ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !
	Ixporter* ixporter = [[self info] objectForKey:constKeyIxporter] ;
	Client* client = [ixporter client] ;
	if ([[client extoreMedia] isEqualToString:constBkmxExtoreMediaThisUser]) {
		NSDate* dateLockedByOther = [[NSUserDefaults standardUserDefaults] objectForKey:constKeyThisUserIxportStartDate] ;
		NSDate* now = [NSDate date] ;
		NSError* error = nil ;
		if (dateLockedByOther) {
			 ! ! ! ! ! ! ! ! ! ! ! ! ! ! THIS CODE IS #if REMOVED ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !
			NSTimeInterval timeSinceOtherStarted = [now timeIntervalSinceDate:dateLockedByOther] ;
			if (timeSinceOtherStarted < TIMEOUT_FOR_OTHER_BOOKMACSTER_OR_WORKER_TO_IMPORT) {
				// Another BookMacster is in the process of doing an ixport.
				// We must abort.
				NSString* msg ;
				msg = [NSString localize:@"couldNotWriteFile"] ;
				NSInteger code = NSApp ? constBkmxErrorCouldNotWriteLockedFileMainApp : constBkmxErrorCouldNotWriteLockedFileWorker ;
				error = SSYMakeError(code, msg) ;

				 ! ! ! ! ! ! ! ! ! ! ! ! ! ! THIS CODE IS #if REMOVED ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !

				if (NSApp) {
					msg = @"This Client is currently being accessed by another BookMacster process." ;
				}
				else {
					msg = @"This Client is currently being accessed by another BookMacster process."
					@"  Often this is due to launchd over-reacting to a WatchPath and falsely triggering an Agent when a file is merely *read* by BookMacster performing an Import."
					@"  You should ignore this error." ;
				}
				error = [error errorByAddingLocalizedFailureReason:msg] ;
				error = [error errorByAddingUserInfoObject:[NSNumber numberWithDouble:timeSinceOtherStarted]
																			   forKey:@"TimeSinceOtherStarted"] ;
				error = [error errorByAddingUserInfoObject:dateLockedByOther
													forKey:@"DateLockedByOther"] ;
				
				 ! ! ! ! ! ! ! ! ! ! ! ! ! ! THIS CODE IS #if REMOVED ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !

				// This will abort further operations.
				[self setError:error] ;
			}
			else {
				// Another BookMacster started an ixport but did not
				// complete it before the timeout.  It must have crashed.
				// We assume that the user is already aware of the crash, so
				// we just log it and proceed with our ixport.
				[[BkmxBasis sharedBasis] logMessage:
				 @"Ignoring stale lock %@.  Other BkMxtr|Worker crashed?",
				 [dateLockedByOther geekDateTimeString]] ;
			}
		}
		 ! ! ! ! ! ! ! ! ! ! ! ! ! ! THIS CODE IS #if REMOVED ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !

		// If no error, we set the lock
		if (!error) {
			[[NSUserDefaults standardUserDefaults] setObject:now
													  forKey:constKeyThisUserIxportStartDate] ;
			[[NSUserDefaults standardUserDefaults] synchronize] ;
			[[self info] setObject:now
							forKey:constKeyThisUserIxportStartDate] ;
			 ! ! ! ! ! ! ! ! ! ! ! ! ! ! THIS CODE IS #if REMOVED ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !
		}
		else {
			Ixporter* ixporter = [[self info] objectForKey:constKeyIxporter] ;
			if ([ixporter isAnImporter]) {
				// See Note 520948…
				[self skipNoncleanupOperationsInOtherGroups] ;
				 ! ! ! ! ! ! ! ! ! ! ! ! ! ! THIS CODE IS #if REMOVED ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !
			}
		}			
	}
}
 ! ! ! ! ! ! ! ! ! ! ! ! ! ! THIS CODE IS #if REMOVED ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !
#endif

- (void)quillLegacyApps {
	[self doSafely:_cmd] ;
}

- (void)quillLegacyApps_unsafe {
	[[BkmxBasis sharedBasis] quillIfRunningLegacyAppOrHelper] ;
}

- (void)quillBrowserIsDone {
	Bkmslf* bkmslf = [[self info] objectForKey:constKeyDocument] ;
	Extore* extore = [[self info] objectForKey:constKeyExtore] ;
		
	[[bkmslf macster] unblindTriggersWithKeys:[[self info] objectForKey:constKeyTriggerBlinderKeys]] ;	
	
	NSError* error = [extore error] ;
	if (error) {
		[self setError:error] ;

		Ixporter* ixporter = [[self info] objectForKey:constKeyIxporter] ;
		if ([ixporter isAnImporter]) {
			// See Note 520948…
			[self skipNoncleanupOperationsInOtherGroups] ;
		}
	}
	else {
		// For example, in the case of constBkmxErrorBrowserAddonFailedWillTryToInstall,
		// we will be here because that error was set into the operation (us) instead of
		// the extore, since we needed a nil error in the extore to proceed with the
		// add-on installation.
	}

	[self unlockLock] ;
}

- (void)quillBrowserForClientTask:(BkmxClientTask)clientTask {
	Extore* extore = [[self info] objectForKey:constKeyExtore] ;
	Client* client = [extore client] ;
	
	if ([[client  extoreMedia] isEqualToString:constBkmxExtoreMediaThisUser]) {
		// Operation involves the current user's local web browser.    		
		[[self info] setObject:[NSNumber numberWithInteger:clientTask]
						forKey:constKeyClientTask] ;
		[extore insquillIfNeededForOperation:self] ;
	}
	else {
		// Quilling browser is not applicable.  Just invoke the callback.
		[self quillBrowserIsDone] ;
	}
}

- (void)quillBrowserForReading {
	[self prepareLock] ;
	[self doSafely:_cmd] ;	
	[self blockForLock] ;
}

- (void)quillBrowserForReading_unsafe {
	[self lockLock] ;
	
	// Unsafe because of [client extoreMedia] access in this method…
	[self quillBrowserForClientTask:BkmxClientTaskRead] ;
}

- (void)readExternal {
	// Added loop in BookMacster 1.11.  The loop will normally only execute once,
	// except after installing an add-on, then it will execute twice.
	while ([[[self info] objectForKey:constKeyDoneTryingToRead] boolValue] == NO) {
		Extore* extore = [[self info] objectForKey:constKeyExtore] ;
		
		// The following is not necessary on the first iteration, because
		// it will be overwriting the readWriteStyles written earlier
		// by the explicit getReadWriteStyles operation with the same
		// values.  However, if a browser is quit for addon installation,
		// it will be different on the second iteration.
		// For Chrome, will change from 0x22 to 0x11.
		// Fore Firefox, will change from 0x12 to 0x11.
		NSError* error = nil ;
        BkmxReadWriteStyles readWriteStyles = [extore readWriteStylesError_p:&error] ;
		if (error) {
            [self setError:error] ;
        }
        [[self info] setObject:[NSNumber numberWithInteger:readWriteStyles]
						forKey:constKeyReadWriteStyles] ;

		[self prepareLock] ;
		[self doSafely:_cmd] ;	
		[self blockForLock] ;
	}
}

- (void)readExternal_unsafe {
	[self lockLock] ;
	Ixporter* ixporter = [[self info] objectForKey:constKeyIxporter] ;
	if ([[self info] objectForKey:constKeySkipImportNoChanges]) {
		[[BkmxBasis sharedBasis] logMessage:@"%@ unchanged since last import \u279E Skip Reading", [[ixporter client] displayName]] ;
		[[self info] setObject:[NSNumber numberWithBool:YES]
						forKey:constKeyDoneTryingToRead] ;
		[self readExternalIsDone] ;
		return ;
	}
	
	Extore* extore = [[self info] objectForKey:constKeyExtore] ;
	
	// Note 954938
	
	// Due to the vagaries of Core Data, the Extore may not be deallocced
	// when it goes out of scope.  If that happens, it and its starker may be
	// re-used for subsequent exports.  So, In case we're re-using
	// an old starker, we first empty it out.
	// (I may have fixed Extore re-use by releasing it in -[Client didTurnIntoFault], but I'm not sure.)
	[[extore starker] deleteAllStarks] ;
	
	// Read data from external store into its emptied starker.

	[self setError:nil] ;
	
	Bkmslf* bkmslf = [[self info] objectForKey:constKeyDocument] ;
	[[bkmslf progressView] setIndeterminate:YES
						withLocalizedVerb:[NSString localizeFormat:
										   @"fileReadingX",
										   [[extore client] displayName]]] ;

	BkmxReadWriteStyles readWriteStyles = [[[self info] objectForKey:constKeyReadWriteStyles] integerValue] ;
	NSInteger readStyle = BkmxReadStyleFromReadWriteStyles(readWriteStyles) ;
	switch (readStyle) {
		case 1:;
			[[self info] setObject:[NSNumber numberWithBool:YES]
							forKey:constKeyDoneTryingToRead] ;
			BkmxIxportPolarity polarity = [ixporter isAnImporter] ? BkmxIxportPolarityImport : BkmxIxportPolarityExport ;
			[extore readExternalStyle1ForPolarity:polarity] ;
			// Tbe above method executes synchronously, so when we're here, it's done.
			// We invoke the callback now.
			[self readExternalIsDone] ;
			break ;
		case 2:
			[extore readExternalStyle2ForOperation:self] ;
			break ;
		default:;
			NSString* msg = [NSString stringWithFormat:
							 @"Unrecognized Ixport Style: %@",
							 [[self info] objectForKey:constKeyReadWriteStyles]] ;
			NSError* error = SSYMakeError(635238, msg) ;
			[self setError:error] ;
			[self readExternalIsDone] ;
	}
}

- (void)readExternalIsDone {		
	Extore* extore = [[self info] objectForKey:constKeyExtore] ;
	Client* client = [extore client] ;
	Bkmslf* bkmslf = [[self info] objectForKey:constKeyDocument] ;
	
	NSError* error = [extore error] ;
	if (error) {
		[self setError:error] ;
		Ixporter* ixporter = [[self info] objectForKey:constKeyIxporter] ;
		if ([ixporter isAnImporter]) {
			/*
			 Note 520948.
			 Now we come to the question of whether or not, in a multi-Client
			 import, we should abort the remaining Client imports given
			 that this Client import has failed.  Although I think this
			 did not happen in earlier versions, in BookMacster 1.6.7 I note
			 that other such Client imports are *not* aborted.  Because of the way
			 that I've written -[Ixporter mergeFromStartainer::::] and -[Ixporter gulpStartainer::::],
			 to set things up if the Client isBeginningProduct, and to
			 clean up if the Client isEndingProduct, this means that many
			 important things will not get done if this failed import
			 happens to be the first or last in the list!  I looked for a
			 few minutes at factoring out the first-client setup and
			 last-client cleanup code from -[Ixporter mergeFromStartainer:toStartainer:info:error_p:],
			 but the isBeginningProduct and isEndingProduct code is branched
			 in multiple times, and so this would be a real mess.
			 CORRECTION: Did isEndingProduct mess 20111213
			 Another 
			 alternative, which would work for isBeginningProduct, is to
			 switch isBeginningProduct on at the beginning, and then switch it off after
			 the first successful Client is merged.  That would actually be
			 simpler than what I'm doing now.  But this would not work for isEndingProduct,
			 at least until someone invents an easy way to go back in time and re-run
			 code with different parameters!  (If Import Clients are A, B and
			 C, and C fails, you'd need to go back in time and re-run B with
			 isEndingProject set to YES.)  Finally, I considered whether the
			 user would really want a partial import, and concluded that the
			 answer is NO.  Particularly if Import's "Delete Unmatched Items"
			 is checked ON, which it is be default, skipping an import Client 
			 could cause items expected from that import to be deleted.
			 It seems that, in most cases, things might get put out of order, causing
			 a massive churn, and another massive re-churn back to normal the
			 next time that the import is run successfully with all Clients.
			 
			 Therefore, in BookMacster 1.7/1.6.8, I added the following statement: */
			[self skipNoncleanupOperationsInOtherGroups] ;
		}
	}
	
	// We still need to do this, even if we're reading in to do a 
	// comparison for export.  Otherwise, the import will not match
	// the export and churn will occur.
	if ([client doSpecialMapping]) {
		[extore doSpecialMappingAfterImport] ;
	}
	
	[[bkmslf progressView] clearAll] ;
	
	if (![[[self info] objectForKey:constKeySkipImportNoChanges] boolValue]) {
		// This was moved from Note 954938 in BookMacster 1.11.2, because
		// when it was there, it did not check for error, and also it executed
		// even if this method did not execute, because no import was done,
		// because a browser add-on was found needing to be installed first.
		if (![self error]) {
			[[self info] setObject:[NSNumber numberWithBool:YES]
							forKey:constKeyDidReadExternal] ;
		}
	}	
	
	[self unlockLock] ;
}

// Added in BookMacster 1.6
- (void)updateCaches {
	[self doSafely:_cmd] ;
}

// Maybe this could be done on a non-main thread, but I don't want to investigate now.	
- (void)updateCaches_unsafe {
	Bkmslf* bkmslf = (Bkmslf*)[self owner] ;
	SSYModelChangeCounts changeCounts = [[bkmslf chaker] changeCounts] ;
	if (changeCounts.added + changeCounts.deleted > 0) {
		[[bkmslf starker] clearCaches] ;

		// Actually, I'm not sure if it's even necessary any more.  It's a left-over
		// line of code from Bookdog.
		[bkmslf clearBroker] ;
	}
}


- (void)syncLog {
	[self doSafely:_cmd] ;
}

- (void)syncLog_unsafe {
	Bkmslf* bkmslf = [[self info] objectForKey:constKeyDocument] ;
	Ixporter* ixporter = [[self info] objectForKey:constKeyIxporter] ;
	
	// For an importer, this method will only run in the grand summary operation group.
	// For an exporter, this method will at the end of each Client.
	
	Ixporter* singleIxporter = nil ;
	if ([ixporter isAnImporter]) {
		singleIxporter = [[self info] objectForKey:constKeySingleIxporter] ;
		ixporter = nil ;
	}

	IxportLog* ixportLog = [[bkmslf chaker] endForSingleImporter:singleIxporter
														exporter:ixporter
														isDryRun:[[self info] objectForKey:constKeyIsDryRun]] ;
	
	// Stash this into 'info' in case an error occurs during
	// the actual export, packing, or pushing of the changes,
	// so that we can roll it back (delete it)
	[[self info] setValue:ixportLog   // ixportLog may be nil
				   forKey:constKeyIxportLog] ;
}

- (void)actuallyDelete {
	[self doSafely:_cmd] ;
}

- (void)actuallyDelete_unsafe {
	Bkmslf* bkmslf = [[self info] objectForKey:constKeyDocument] ;
	Chaker* chaker = [bkmslf chaker] ;
	NSDictionary* stanges = [chaker stanges] ;
	NSMutableSet* doomedStarks = [[NSMutableSet alloc] init] ;
	for (NSString* starkid in stanges) {
		Stange* stange = [stanges objectForKey:starkid] ;
		SSYModelChangeAction changeType = [stange changeType] ;
		if ((changeType == SSYModelChangeActionRemove) || (changeType == SSYModelChangeActionCancel)) {
			Stark* stark = [stange stark] ;
			[doomedStarks addObject:stark] ;
		}
	}
	
	[StarkEditor removeStarks:doomedStarks
					   bkmslf:bkmslf] ;
	[doomedStarks release] ;
}

- (BOOL)anyChangesToWrite {
	Bkmslf* bkmslf = (Bkmslf*)[self owner] ;
	Extore* extore = [[self info] objectForKey:constKeyExtore] ;
	// The following must be invoked on main thread due to Core Data access
	return [[bkmslf chaker] hasChangesForExtore:extore] ;
}

- (void)quillBrowserForWriting {
	// This operation is skipped if we're doing a dry run (SDDR)
	if ([[[self info] objectForKey:constKeyIsDryRun] boolValue] == YES) {
		return ;
	}
	
	[self prepareLock] ;
	[self doSafely:_cmd] ;	
	[self blockForLock] ;
}

- (void)quillBrowserForWriting_unsafe {
	[self lockLock] ;
	if (![self anyChangesToWrite]) {
		[self quillBrowserIsDone] ;
		return ;
	}
	
	// Unsafe because of [client extoreMedia] access in this method…
	[self quillBrowserForClientTask:BkmxClientTaskWrite] ;
}

- (void)quillBrowserAndInstallAddon {
	[self prepareLock] ;
	[self doSafely:_cmd] ;	
	[self blockForLock] ;
}

- (void)quillBrowserAndInstallAddon_unsafe {
	[self lockLock] ;
	
	[[self info] setObject:[NSNumber numberWithBool:YES]
					forKey:constKeyAddonHasAlreadyFailed] ;

	// Unsafe because of [client extoreMedia] access in this method…
	[self quillBrowserForClientTask:BkmxClientTaskInstallAddOn] ;
}

// No longer needed.  See other instances of Note 289059.
#if 0
- (void)revitalizeTrigger {
	// Since the trigger is a Core Data object which will be accessing
	// its properties, we swing over to the main thread for safety
	[self doSafely:_cmd] ;
}
- (void)revitalizeTrigger_unsafe {
	Trigger* trigger = [[self info] objectForKey:constKeyTiredTrigger] ;
	
	NSError* error = nil ;
	BOOL ok = [trigger revitalizeLaunchdAgentError_p:&error] ;

	if (!ok) {
		[self setError:error] ;
	}
}
#endif

+ (void)tickleRunLoop {
    // No op
}

/* This method is called from the -main of the first NSOperation
 in an Agent task.  Like all NSOperations, it's running on a
 secondary thread. */
- (void)beginWork {
	Bkmslf* bkmslf = [[self info] objectForKey:constKeyDocument] ;
	NSInteger performanceType = [[[self info] objectForKey:constKeyPerformanceType] integerValue] ;	
	[bkmslf setCurrentPerformanceType:performanceType] ;
	
	// Tell the world that we've been dequeued, unless we're going to do it later.
	if (![[[self info] objectForKey:constKeyAgentDoesImport] boolValue]) {
		[Stager removeStagingForAgentUri:[[self info] objectForKey:constKeyAgentUri]
									 pid:[[self info] objectForKey:constKeyStagingPid]] ;	
	}
}

/* This method is called from the -main of the final NSOperation
 in an Agent task.  Like all NSOperations, it's running on a
 secondary thread. */
+ (void)terminateWorkInfo:(NSDictionary*)info {
	Bkmslf* bkmslf = [info objectForKey:constKeyDocument] ;
	if ([bkmslf currentPerformanceType] == BkmxPerformanceTypeUpstaged) {
		BkmslfWinCon* bkmslfWinCon = [bkmslf bkmslfWinCon] ;
		[bkmslfWinCon performSelectorOnMainThread:@selector(decrementPerformNowCount)
									   withObject:nil
									waitUntilDone:NO] ;
		
		SSYSemaphorePidKey* thisJobPidKey = [info objectForKey:constKeyJobPidKey] ;
		if (thisJobPidKey) {
			SSYSemaphorePidKey* currentPidKey = [SSYSemaphore currentPidKeyEnforcingTimeLimit:0.0] ;
			if ([currentPidKey isEqual:thisJobPidKey]) {
				NSError* error = nil ;
				BOOL ok = [SSYSemaphore clearError_p:&error] ;
				if (!ok) {
					NSLog(@"Internal Error 721-0387 %@", error) ;
				}
			}
		}
	}
	
	[bkmslf setCurrentPerformanceType:BkmxPerformanceTypeUser] ;
	
	[[AgentPerformer sharedPerformer] setIsDone:YES] ;
	
    // The following is
	// to install an input source on the main run loop, so that
    // in Worker-main.m, in main(), -runLoop:beforeDate: will
    // unblock, the above exit condition will be tested, found
    // to be true, and cause the loop to break so that Worker
    // can continue along to exit.
//    [self performSelectorOnMainThread:@selector(tickleRunLoop)
//                           withObject:nil
//                        waitUntilDone:NO] ;
	// Note that, as of BookMacster 1.11, in this method we
	// *are* on the main thread.
}

#define COUNT_OF_OBJ_C_BUILTIN_ARGUMENTS_SELF_AND_SEL 2

+ (NSMutableDictionary*)infoInInvocation:(NSInvocation*)invocation {
	NSMutableDictionary* info = nil ;
	NSString* selectorString = NSStringFromSelector([invocation selector]) ;
	// selectorString is typically:
	// 	  "queueGroup:selectorNames:addon:info:block:owner:doneThread:doneTarget:doneSelector:keepWithNext:"
	NSArray* argumentNames = [selectorString componentsSeparatedByString:@":"] ;
	NSInteger indexOfInfoArg = [argumentNames indexOfObject:@"info"] ;
	// indexOfInfoArg is typically = 1
	if (indexOfInfoArg == NSNotFound) {
		NSLog(@"Internal Error 235-6850 : %@", selectorString) ;
		return nil ;
	}
	[invocation getArgument:&info
					atIndex:(indexOfInfoArg + COUNT_OF_OBJ_C_BUILTIN_ARGUMENTS_SELF_AND_SEL)] ;
	// More defensive programming...
	if (![info isKindOfClass:[NSMutableDictionary class]]) {
		NSLog(@"Internal Error 547-2015 : %@", info) ;
		return nil ;
	}

	if (!info) {
		NSLog(@"Internal Error 647-0079 : %@", [invocation longDescription]) ;
	}
	
	// OK, it's probably safe.  (Sorry, no way to check mutability.)
	return info ;
}

+ (void)inInfoOfInvocation:(NSInvocation*)invocation
				 setObject:(id)object
					forKey:(NSString*)key {
	if (!object) {
		return ;
	}
	
	// Some defensive programming:
	if ([[invocation methodSignature] numberOfArguments] < 3) {
		NSLog(@"Internal Error 501-6547") ;
		return ;
	}
	// It will be safe to get argument at index 2
	
	NSArray* queueOperationsInvocs ;
	if ([invocation hasEggs]) {
		[invocation getArgument:&queueOperationsInvocs
						atIndex:2] ;  // Index 2 is the first "real" argument
	}
	else {
		queueOperationsInvocs = [NSArray arrayWithObject:invocation] ;
	}

	for (NSInvocation* queueOperationsInvoc in queueOperationsInvocs) {
		NSMutableDictionary* info = [self infoInInvocation:queueOperationsInvoc] ;

		[info setObject:object
				 forKey:key] ;
	}
}

+ (void)modifyInvocation:(NSInvocation*)invocation
			newDeference:(BkmxDeference)newDeference 
		  setIgnoreLimit:(BOOL)setIgnoreLimit {
	// Some defensive programming:
	if ([[invocation methodSignature] numberOfArguments] < 3) {
		NSLog(@"Internal Error 235-1948") ;
		return ;
	}
	// It will be safe to get argument at index 2
	
	NSArray* queueOperationsInvocs ;
	if ([invocation hasEggs]) {
		[invocation getArgument:&queueOperationsInvocs
						atIndex:2] ;  // Index 2 is the first "real" argument
	}
	else {
		queueOperationsInvocs = [NSArray arrayWithObject:invocation] ;
	}
	for (NSInvocation* queueOperationsInvoc in queueOperationsInvocs) {
		NSMutableDictionary* info = [self infoInInvocation:queueOperationsInvoc] ;
		
		if (newDeference != BkmxDeferenceUndefined) {
			[info setObject:[NSNumber numberWithInteger:newDeference]
					 forKey:constKeyDeference] ;
		}

		if (setIgnoreLimit) {
			[info setObject:[NSNumber numberWithBool:YES]
					 forKey:constKeyIgnoreLimit] ;
		}
	}
}

- (void)timestampImporter {
	[self doSafely:_cmd] ;
}

- (void)timestampImporter_unsafe {
	Bkmslf* bkmslf = [[self info] objectForKey:constKeyDocument] ;
	Ixporter* ixporter = [[self info] objectForKey:constKeyIxporter] ;
	[bkmslf setAsNowLastImportedDateForClient:[ixporter client]] ;
}

- (void)saveExidsMoc {
	// This operation is skipped if we're doing a dry run (SDDR)
	if ([[[self info] objectForKey:constKeyIsDryRun] boolValue] == YES) {
		return ;
	}
	
	[self doSafely:_cmd] ;
}

- (void)saveExidsMoc_unsafe {
	NSError* error = nil ;
	Bkmslf* bkmslf = (Bkmslf*)[self owner] ;
	SSYProgressView* progressView = [bkmslf progressView] ;
	[progressView setIndeterminate:YES
				 withLocalizedVerb:[NSString localizeFormat:
									@"savingX",
									[NSString localize:@"identifiers"]]] ;		
	BOOL ok = [(Starxider*)[bkmslf starxider] save:&error] ;
	[progressView clearAll] ;
	
	if (!ok) {
		[self setError:error] ;
	}
}

- (void)requinchBrowserMaybe {
	// This operation is skipped if we're doing a dry run (SDDR)
	if ([[[self info] objectForKey:constKeyIsDryRun] boolValue] == YES) {
		return ;
	}
	
	[self prepareLock] ;
	[self doSafely:_cmd] ;	
	[self blockForLock] ;
}

- (void)requinchBrowserMaybe_unsafe {
	[self lockLock] ;

	Bkmslf* bkmslf = [[self info] objectForKey:constKeyDocument] ;
	[bkmslf requinchBrowserMaybeForOperation:self] ;
}

- (void)requinchBrowserIsDone {	
	[self unlockLock] ;
}

- (void)writeTrace {
	[[BkmxBasis sharedBasis] writeTrace] ;
}

- (void)errorizeIxportLog {
	[self doSafely:_cmd] ;
}

- (void)errorizeIxportLog_unsafe {
	NSInteger errorCode = [[self error] code] ;
	if (errorCode != constBkmxErrorNone) {
		IxportLog* ixportLog = [[self info] objectForKey:constKeyIxportLog] ;
		if (ixportLog) {
			[ixportLog setStarkoids:nil] ;
			[ixportLog setDisplayStatistics:nil] ;
			[ixportLog setErrorCode:[NSNumber numberWithLong:errorCode]] ;
			Bkmslf* bkmslf = [[self info] objectForKey:constKeyDocument] ;
			Bookshig* shig = [bkmslf shig] ;
			// The following can take a second or more
			[[BkmxBasis sharedBasis] saveDiariesMocForIdentifier:[shig uuid]] ;
		}
	}
}

- (void)uninhibit {
	[self doSafely:_cmd] ;
	// Is there a superstition that NSUserDefaults must be accessed on the main thread?
}

- (void)uninhibit_unsafe {
	NSDictionary* info = [self info] ;
	NSNumber* uninhibitSeconds = [info objectForKey:constKeyUninhibitSecondsAfterDone] ;
	if (uninhibitSeconds) {
		NSDate* uninhibitDate = [NSDate dateWithTimeIntervalSinceNow:[uninhibitSeconds doubleValue]] ;
		[[BkmxBasis sharedBasis] logMessage:@"Moved General Uninhibit back to %@", [uninhibitDate geekDateTimeString]] ;
		[[NSUserDefaults standardUserDefaults] setGeneralUninhibitDate:uninhibitDate] ;
		// And since this will be soon read by a Worker process,
		[[NSUserDefaults standardUserDefaults] synchronize] ;
	}
}	



#ifndef BKMSLF_SUPPORTS_AUTOSAVE_IN_PLACE
#warning Something is wrong.  BKMSLF_SUPPORTS_AUTOSAVE_IN_PLACE should be defined as either 1 or 0.
#endif

#if BKMSLF_SUPPORTS_AUTOSAVE_IN_PLACE
/*!
 @details  Used to queue non-cancellable Auto Saves.
 */
- (void)reallyAutosave {
	[self doSafely:_cmd] ;
}

- (void)reallyAutosave_unsafe {
	NSDictionary* info = [self info] ;
	Bkmslf* bkmslf = [info objectForKey:constKeyDocument] ;
	
	void (^completionHandler)(NSError*) = [info objectForKey:constKeyCompletionHandler] ;
	
	[bkmslf reallyAutosaveWithCompletionHandler:completionHandler] ;
	// Note: completionHandler will be released by the receiver of the above message.
}	

#endif // BKMSLF_SUPPORTS_AUTOSAVE_IN_PLACE

- (void)blindAllBrowserQuitTriggers {
#if 0
#warning We're blinding browser quit triggers
	if (NSApp) {
		NSMutableSet* blinderKeys = nil ;	
		Bkmslf* bkmslf = [[self info] objectForKey:constKeyDocument] ;
		Ixporter* ixporter = [[self info] objectForKey:constKeyIxporter] ;
		Client* client = [ixporter client] ;
		for (Agent* agent in [[bkmslf macster] agents]) {
			for (Trigger* trigger in [agent triggers]) {
				if ([trigger triggerTypeValue] == BkmxTriggerBrowserQuit) {
					if ([trigger client] == client) {
						NSString* blinderKey = [trigger blind] ;						
						// Note that the above blinding and later unblinding also revitalizes.
						if (blinderKey) {
							if (!blinderKeys) {
								blinderKeys = [[NSMutableSet alloc] init] ;
							}
							[blinderKeys addObject:blinderKey] ;
						}
					}
				}
			}
		}
		
		NSSet* triggerBlinderKeys = [[blinderKeys copy] autorelease] ;
		[blinderKeys release] ;
		[[self info] setValue:triggerBlinderKeys
					   forKey:constKeyTriggerBlinderKeys] ;
	}
#endif
}

@end