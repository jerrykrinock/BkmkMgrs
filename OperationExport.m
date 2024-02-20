#import "ExtoreWebFlat.h"
#import "NSError+MyDomain.h"
#import "NSError+DecodeCodes.h"
#import "BkmxDoc.h"
#import "BkmxDocWinCon.h"
#import "NSInvocation+Quick.h"
#import "BkmxBasis+Strings.h"
#import "Chaker.h"
#import "NSError+InfoAccess.h"
#import "Importer.h"
#import "Starker.h"
#import "Stark+Sorting.h"
#import "Exporter.h"
#import "NSNumber+Sharype.h"
#import "NSObject+MoreDescriptions.h"
#import "NSUserDefaults+Bkmx.h"
#import "NSString+MoreComparisons.h"
#import "NSString+LocalizeSSY.h"
#import "SSYProgressView.h"
#import "Client+SpecialOptions.h"
#import "Operation_Common.h"
#import "Macster.h"
#import "Syncer.h"
#import "Trigger.h"
#import "Gulper.h"
#import "ExportLog.h"
#import "SSYMH.AppAnchors.h"
#import "NSDictionary+KeyPaths.h"
#import "NSUserDefaults+MainApp.h"
#import "SSYMOCManager.h"
#import "Stager.h"
#import "AgentPerformer.h"
#import "Job.h"
#import "BkmxNotifierCaller.h"


@implementation SSYOperation (OperationExport)

- (void)checkFileConflict {
}

- (void)prepareBrowserForExport1 {
	[self prepareLock] ;
	[self doSafely:(SEL)"prepareBrowserForExport"] ;	
	[self blockForLock] ;
}

- (void)prepareBrowserForExport2 {
	// Added in BookMacster 1.11.
	// prepareBrowserForExportN is run twice during an export, once prior to
	// reading and then again prior to writing.  This is to make sure
	// that iCloud does not pipe up in the meantime.  The first time,
	// we don't want to set a lock on the Safari Bookmarks.plist file.
	// But the second time, we do.  To tell the difference, we add
	// a key to info now indicating that we've executed at least once.
	[[self info] setObject:[NSNumber numberWithBool:YES]
					forKey:constKeySecondPrep] ;
	
	[self prepareLock] ;
	[self doSafely:(SEL)"prepareBrowserForExport"] ;	
	[self blockForLock] ;
}

- (void)prepareBrowserForExport_unsafe {
	[self lockLock] ;

	NSString* extoreMedia = [[(Ixporter*)[[self info] objectForKey:constKeyIxporter] client] extoreMedia] ;
    [[self info] setObject:self
                    forKey:constKeyIsDoneTarget] ;
    NSString* doneSelectorName = @"prepareBrowserForExportIsDoneInfo:" ;
    [[self info] setObject:doneSelectorName
                    forKey:constKeyIsDoneSelectorName] ;

    Extore* extore = [[self info] objectForKey:constKeyExtore] ;
    if ([extoreMedia isEqualToString:constBkmxExtoreMediaThisUser]) {
        [extore prepareBrowserForExportWithInfo:[self info]] ;
    } else if (extoreMedia != nil) {
		// This section was added in BookMacster 1.9.3 to fix exports to 
		// Choose File (Advanced) Clients, which apparently had been broken
		// for a long time.
		[[self info] setObject:[NSNumber numberWithBool:YES]
						forKey:constKeySucceeded] ;
		[extore sendIsDoneMessageFromInfo:[self info]] ;
    } else {
        /* Defensive programming */
        [extore sendIsDoneMessageFromInfo:[self info]] ;
    }
}

- (void)prepareBrowserForExportIsDoneInfo:(NSDictionary*)info {
	if (![[[self info] objectForKey:constKeySucceeded] boolValue]) {
		NSError* error = [[self info] objectForKey:constKeyError] ;
		[self setError:error] ;
	}
	
	[self unlockLock] ;
}

- (void)mergeExport {
	[self doSafely:_cmd] ;
}

- (void)mergeExport_unsafe {
    BkmxDoc* bkmxDoc = [self.info objectForKey:constKeyDocument];
	Exporter* exporter = [[self info] objectForKey:constKeyIxporter] ;
	NSError* error = nil ;
	BOOL ok = [exporter mergeFromStartainer:bkmxDoc
								toStartainer:exporter
										info:[self info]
									 error_p:&error] ;
	if (ok) {
		Gulper* gulper = [[Gulper alloc] initWithDelegate:exporter] ;
		ok = [gulper gulpStartainer:exporter
								 info:[self info]
							  error_p:&error] ;
		[gulper release] ;
	}
	
	if (!ok) {
		[self setError:error] ;
	}
}

- (void)feedbackPreWrite {
	// This operation is skipped if we're doing a test run (SDTR)
	if ([[[self info] objectForKey:constKeyIsTestRun] boolValue] == YES) {
		return ;
	}
	
	[self doSafely:_cmd] ;
}

- (BOOL)anyChangesToWrite {
	BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument] ;
	Extore* extore = [[self info] objectForKey:constKeyExtore] ;

	// At one time, I had a comment in here indicating that
    // "the following must be invoked on main thread due to Core Data access"
    // But today, on 20131213, inspecting the methods invoked, I don't think so.
    BOOL answer = [[bkmxDoc chaker] hasChangesForExtore:extore] ;

	return answer ;
}

/*
 When new exid is obtained for a destinStark, its mateInBkmxDoc is
 extracted from the exportFeedbackDic, and then the mateInBkmxDoc
 has its exid set to the new exid.
*/
- (void)feedbackPreWrite_unsafe {
	if (![self anyChangesToWrite]) {
		return ;
	}
	
	Extore* extore = [[self info] objectForKey:constKeyExtore] ;

	NSArray* starks = [[extore starker] allStarks] ;
	BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument] ;

	NSString* whatDoing = [[BkmxBasis sharedBasis] labelNewIdentifiers] ;
	whatDoing = [whatDoing stringByAppendingString:@" 1/2"] ;
    SSYProgressView* progressView = [[bkmxDoc progressView] setIndeterminate:NO
                                                           withLocalizedVerb:whatDoing
                                                                    priority:SSYProgressPriorityRegular] ;
    // Note: In BkmxAgent, progressView will be nil.
    [progressView setMaxValue:[starks count]] ;
    [progressView setDoubleValue:1.0] ;
	
	Clientoid* clientoid = [[extore client] clientoid] ;
	NSDictionary* exportFeedbackDic = [[self info] objectForKey:constKeyExportFeedbackDic] ;
	NSInteger newExidsCount = 0 ;
	for (Stark* stark in starks) {
		[progressView incrementDoubleValueBy:1.0] ;
		if ([stark isRoot]) { 
			continue ;
		}
		
		// If the user immediately syncs Safari bookmarks to iPhone or .Mac, without Safari "touching" the bookmarks,
		// bookmark without UUID (new bookmarks, just created in this session) will not be picked up by
		// iPhone or .Mac.  So, we make sure that everything has exid (took only 28 msec to generate about 800 UUID
		// on my Intel Core Duo Mac Mini).
		
		// But we don't tryHard because new items have not been uploaded yet.
		NSString* exid = nil ;
        [stark getOrMakeValidExid_p:&exid
                             extore:extore
                      isAfterExport:NO
                            tryHard:NO];

		Stark* mateInBkmxDoc = [exportFeedbackDic objectForKey:[stark objectID]] ;
		if (mateInBkmxDoc) {
			// I'm not sure, but the following if() may have cured some "Core Data could not fulfill a fault..." errors
			if (![mateInBkmxDoc isDeleted]) {
				// Note that if we failed to get a valid exid, the following will
				// remove the exid for this clientoid from the mate.  That seems
				// reasonable.
				
				// We first check to see if there has been any change, to avoid
				// unnecessarily dirtying the dot
				NSString* currentExid = [mateInBkmxDoc exidForClientoid:clientoid] ;
				if (![NSString isEqualHandlesNilString1:currentExid
												string2:exid]) {
					[mateInBkmxDoc setExid:exid
							 forClientoid:clientoid] ;
					newExidsCount++ ;
				}
			}
		}		
	}
	
	if (newExidsCount > 0) {
		[[self info] setObject:[NSNumber numberWithInteger:newExidsCount]
						forKey:constKeyNewExidsCount] ;
	}
}

- (void)restoreRssArticlesInsertAsChildStarks {
	// This operation is skipped if we're doing a test run (SDTR)
	if ([[[self info] objectForKey:constKeyIsTestRun] boolValue] == YES) {
		return ;
	}
	
	[self doSafely:_cmd] ;
}

/*
 The inverse of this method is -[Stark setRssArticlesFromAndRemoveStarks:]
 */
- (void)restoreRssArticlesInsertAsChildStarks_unsafe {
	if (![self anyChangesToWrite]) {
		return ;
	}
	
	Extore* extore = [[self info] objectForKey:constKeyExtore] ;
	Starker* starker = [extore starker] ;
	
	NSArray* allStarks = [starker allStarks] ;
	for (Stark* stark in allStarks) {
		if ([stark sharypeValue] == SharypeLiveRSS) {
			NSArray* dics = [stark rssArticles] ;
			if (dics) {
				NSManagedObjectContext* moc = [starker managedObjectContext] ;
				
				for (NSDictionary* dic in dics) {
					Stark* article = [NSEntityDescription insertNewObjectForEntityForName:constEntityNameStark
																 inManagedObjectContext:moc] ;
					[article setSharype:[NSNumber numberWithSharype:SharypeRSSArticle]] ;
					[article setName:[dic objectForKey:constKeyName]] ;
					[article setUrl:[dic objectForKey:constKeyUrl]] ;
					[article setAddDate:[dic objectForKey:constKeyAddDate]] ;
					[article setLastModifiedDate:[dic objectForKey:constKeyLastModifiedDate]] ;
					[article setShortcut:[dic objectForKey:constKeyShortcut]] ;
					[article setComments:[dic objectForKey:constKeyComments]] ;
					[article setOwnerValues:[dic objectForKey:constKeyOwnerValues]] ;
					[article setExids:[dic objectForKey:constKeyExids]] ;
					
					[article moveToBkmxParent:stark] ;
				}
			}
		}
	}
	
	/* The articles we have just added will be exported if we export in Style 1,
	 but they will not be exported if Style 2, because the latter
	 instead enumerates over the BkmxDoc's chaker's stanges.  This is handled in
	 -[Extore writeUsingStyle2InOperation:].
	 */
}

- (void)doSpecialMappingBeforeExport  {
	// This operation is skipped if we're doing a test run (SDTR)
	if ([[[self info] objectForKey:constKeyIsTestRun] boolValue] == YES) {
		return ;
	}
	
	[self doSafely:_cmd] ;
}

- (void)doSpecialMappingBeforeExport_unsafe {
	if (![self anyChangesToWrite]) {
		return ;
	}
	
	Ixporter* ixporter = [[self info] objectForKey:constKeyIxporter] ;
	if ([[ixporter client] doSpecialMapping] || ([[ixporter client] fakeUnfiled])) {
		Extore* extore = [[self info] objectForKey:constKeyExtore] ;
        BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument] ;
        [extore doSpecialMappingBeforeExportForExporter:(Exporter*)ixporter
                                                bkmxDoc:bkmxDoc] ;
	}
}

- (void)checkAggregateExids {
	// This operation is skipped if we're doing a test run (SDTR)
	if ([[[self info] objectForKey:constKeyIsTestRun] boolValue] == YES) {
		return ;
	}
	
	[self doSafely:_cmd] ;
}

- (void)checkAggregateExids_unsafe {
    if (![self anyChangesToWrite]) {
		return ;
	}
	
	Extore* extore = [[self info] objectForKey:constKeyExtore] ;
	
	// Added in BookMacster 1.11
	if (!extore) {
		NSLog(@"Internal Error 723-3839 %@", [self info]) ;
	}
	
    if ([extore shouldCheckAggregateExids]) {
        Clientoid* clientoid = [[extore client] clientoid] ;
        Starker* starker = [extore starker] ;
        NSArray* allStarks = [starker allStarks] ;
        
        NSInteger highestUsedExid = extore.exidAssignmentsToAvoid.lastIndex ;
        for (Stark* stark in allStarks) {
            NSInteger exidValue = [[stark exidForClientoid:clientoid] integerValue] ;
            if (exidValue > highestUsedExid) {
                highestUsedExid = exidValue ;
            }
        }

        NSMutableIndexSet* usedExidIndexes = [NSMutableIndexSet new] ;
        [usedExidIndexes addIndexes:extore.exidAssignmentsToAvoid] ;
        
        /* Iterate through all starks, remembering each exid found in usedExids,
         and setting a fresh exid if any found that duplicates a prior finding
         or whose integer value is not a valid index. */
        NSInteger nItemsFixed = 0 ;
        for (Stark* stark in allStarks) {
            NSString* exid = [stark exidForClientoid:clientoid] ;
            if (exid) {
                NSInteger exidValue = [exid integerValue] ;

                if ([usedExidIndexes containsIndex:exidValue] || (exidValue < 0) || (exidValue == NSNotFound)) {
                    /* This exid is a dupe or invalid.  Must replace. */
                    NSString* freshExid = nil ;
                    [extore getFreshExid_p:&freshExid
                                higherThan:highestUsedExid
                                  forStark:stark
                                   tryHard:YES] ;
                    NSInteger freshExidValue = freshExid.integerValue ;
#if DEBUG
                    NSLog(@"Replaced invalid or dupe exid %@ with %@ in %@",
                          exid,
                          freshExid,
                          stark.shortDescription);
#endif
                    [stark setExid:freshExid
                      forClientoid:clientoid] ;
                    
                    nItemsFixed++ ;
                    
                    if (freshExidValue > highestUsedExid) {
                        highestUsedExid = freshExidValue ;
                    }
                    
                    [usedExidIndexes addIndex:freshExidValue] ;
                }
                else {
                    [usedExidIndexes addIndex:exidValue] ;
                }
            }
        }
        
        /* At this point, usedExidIndexes contains the values of all exids in 
         the extore which are not doomed, including those which are in the (Opera)
         trash, which do not appear in -allStarks. */
        [usedExidIndexes release] ;

        if (nItemsFixed > 0) {
            NSLog(@"Fixed duped or invalid exid for %ld items",
                  (long)nItemsFixed) ;
        }
    }
}

- (void)tweakExportForClient {
	[self doSafely:_cmd] ;
}

- (void)tweakExportForClient_unsafe {
	Extore* extore = [[self info] objectForKey:constKeyExtore];
	[extore tweakExport];
}

/*!
 @brief    If appropriate, blinds, any BkmxTriggerSawChange
 triggers relevant to the receiver's operation and returns a set of blinderKeys
 if any triggers were blinded.

 @details  If extore returns YES
 to -shouldBlindSawChangeTriggerDuringExport, blinds any trigger of
 any of the agents of the operation's bkmxDoc whose trigger type is
 BkmxTriggerSawChange, and returns a set containing the blinderKeys generated
 by the blinding, or nil if no such triggers were found.
*/
- (NSSet*)prepareTriggersForExportStyle:(NSInteger)exportStyle {
	NSMutableSet* blinderKeys = nil ;	
	BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument] ;
	Extore* extore = [[self info] objectForKey:constKeyExtore] ;
	Ixporter* ixporter = [[self info] objectForKey:constKeyIxporter] ;
	NSString* targetClidentifier = [[[ixporter client] clientoid] clidentifier] ;
	for (Syncer* syncer in [[bkmxDoc macster] syncers]) {
		for (Trigger* trigger in [syncer triggers]) {
			if ([trigger triggerTypeValue] == BkmxTriggerSawChange) {
				if ([[[[trigger client] clientoid] clidentifier] isEqualToString:targetClidentifier]) {
					if ([extore shouldBlindSawChangeTriggerDuringExport]) {
                        NSString* blinderKey = [trigger blind] ;
						if (!blinderKeys) {
							blinderKeys = [[NSMutableSet alloc] init] ;
                        }
                        /* I saw this blinderKey be nil once after some things
                         had gone awry.  So now we check it: */
                        if (blinderKey) {
                            [blinderKeys addObject:blinderKey] ;
                        }
					}
				}
			}
		}
	}
	
	NSSet* answer = ([blinderKeys count] > 0) ? [NSSet setWithSet:blinderKeys] : nil ;
	[blinderKeys release] ;
	
	return answer ;
}

- (void)actualWriteAndDeleteExtore:(Extore*)extore {
    NSString* msg = [NSString stringWithFormat:
                     @"Will write to %@ in style %ld",
                     [[extore client] displayName],
                     (long)extore.ixportStyle] ;
    [[BkmxBasis sharedBasis] logFormat:msg] ;
	NSSet* blinderKeys = [self prepareTriggersForExportStyle:extore.ixportStyle] ;
	[[self info] setValue:blinderKeys
				   forKey:constKeyTriggerBlinderKeys] ;
	
	if ([extore shouldActuallyDeleteBeforeWrite]) {
		[self actuallyDelete_unsafe] ;
	}
	
	[extore doBackupLabel:@"PreEx"] ;

	switch (extore.ixportStyle) {
		case 1:
			[extore writeUsingStyle1InOperation:self] ;
			break ;
		case 2:
			[extore writeUsingStyle2InOperation:self] ;
			break ;
		default:;
			NSString* msg = [NSString stringWithFormat:
							 @"Unrecognized Ixport Style: %@",
							 [NSNumber numberWithInteger:extore.ixportStyle]] ;
			NSError* error = SSYMakeError(685134, msg) ;
			[self setError:error] ;
	} 

	if (![extore shouldActuallyDeleteBeforeWrite]) {
		[self actuallyDelete_unsafe] ;
		/*
		 I think that we could eliminate the above line for exportStyle 2…
		 • -writeUsingStyle2InOperation: did the actual deleting already
		 • The only effect of -actuallyDelete_unsafe is to remove
		 starks from the destinStarker
		 • In this case, the destinStarker is the (temporary)
		 localStarker
		 • The only thing that we're going to do with the local starker
		 before discarding it is to -feedbackPostWrite,
		 and we don't need exids for deleted starks
		 
		 Conclusion: All it probably does is to reduce the size of the
		 [[extore starker] allStarks] which is enumerated through in
		 -feedbackPostWrite.  It would probably be more efficient
		 to *not* do that and let -feedbackPostWrite ignore the
		 deleted starks.  But the decreased cost would only be
		 milliseconds.
		 
		 Decision: No big deal; not worth the risk of introducing bugs.
		 Just leave the above line in there for both exportStyle values.
		 */		 
	}
	
    [[self info] setObject:[NSNumber numberWithBool:YES]
                    forKey:constKeyDidTryWrite] ;
}

- (void)writeAndDeleteTimedOut:(NSTimer*)timer {
    NSError* error = [timer userInfo] ;
    [self setError:error] ;
    [self writeAndDeleteDidSucceed:NO] ;
}

- (void)writeAndDelete {
	// This operation is skipped if we're doing a test run (SDTR)
	if ([[[self info] objectForKey:constKeyIsTestRun] boolValue] == YES) {
		return ;
	}
	
	[self prepareLock] ;
	
	[self doSafely:_cmd] ;

	// Block here until the writing is done
	[self blockForLock] ;
}

#if 0
#warning Forcing write and delete during exports even if no changes
#define WRITE_AND_DELETE_EVEN_IF_NO_CHANGES 1
#endif

- (void)writeAndDelete_unsafe {
	Extore* extore = [[self info] objectForKey:constKeyExtore] ;
    BOOL skipIt;
#if WRITE_AND_DELETE_EVEN_IF_NO_CHANGES
    skipIt = NO;
#else
    skipIt = ![self anyChangesToWrite];
#endif
	if (skipIt) {
		NSString* msg = [NSString stringWithFormat:
						 @"%@ Export, before %@: No changes \u279E Skip",
						 [[extore client] displayName],
						 [extore ownerAppIsLocalApp] ? @"write" : @"upload"] ;
		[[BkmxBasis sharedBasis] logFormat:msg] ;
		[[BkmxBasis sharedBasis] trace:msg] ;
		[[BkmxBasis sharedBasis] trace:@"\n"] ;
		[self lockLock] ;
		[self unlockLock] ;
		
		// The following was added in BookMacster 1.10 so that -timstampExported
		// does not set setLastChangeWrittenDate:toClient, which will cause
		// -[Extore lastDateExternalWasTouched] to return this date, and so the
		// next time an import or export is executed, when 
		// -[ExtoreWebFlat readExternalStyle1ForPolarity::]
        // invokes [self lastDateExternalWasTouched],
		// that method will get this date from
        // -[NSUserDefaults lastChangeWrittenDateToClientoid:]
		// when in fact the write was skipped
		if (![extore ownerAppIsLocalApp]) {
			[[self info] setObject:[NSNumber numberWithBool:YES]
							forKey:constKeyNoItemsToUpload] ;
		}
		
		return ;
	}
	
	BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument] ;
	
	[[self info] setObject:[NSNumber numberWithBool:YES]
					forKey:constKeyDidExportAnything] ;

	NSString* wordBookmarks = [NSString localize:@"000_Safari_Bookmarks"] ;
	NSString* whatDoing = [extore ownerAppIsLocalApp] 
	? [NSString localizeFormat:@"writing%0", wordBookmarks]
    : [NSString localize:@"processing"] ;
    [[bkmxDoc progressView] setIndeterminate:YES
                           withLocalizedVerb:whatDoing
                                    priority:SSYProgressPriorityRegular] ;
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;
    // Note: In BkmxAgent, progressView will be nil.
	[self lockLock] ;  // Will unlock in -writeAndDeleteDidSucceed:
    
    if ([extore ownerAppIsLocalApp]) {
        NSTimeInterval timeout;
        if ([[BkmxBasis sharedBasis] isBkmxAgent]) {
            timeout = 20; // minutes
        } else {
            timeout = 5; // minutes
        }
        timeout *= 60; // seconds
        
        NSString* prefabbedErrorDescription = [NSString stringWithFormat:
                                               @"Timed out (%ld seconds) waiting for bookmarks export to %@ (style=%ld)",
                                               (long)timeout,
                                               extore.clientoid.displayName,
                                               (long)extore.ixportStyle] ;
        NSError* prefabbedError = SSYMakeError(591200, prefabbedErrorDescription) ;
        prefabbedError = [prefabbedError errorByAddingLocalizedFailureReason:@"Sometimes, systems get really slow."] ;
        prefabbedError = [prefabbedError errorByAddingLocalizedRecoverySuggestion:
                          [NSString stringWithFormat:
                           @"If %@ is running, relaunch it, then try (again) to Export to %@.  If this happens repeatedly, please click in the menu Help > Trouble Zipper and send us some data so we can investigte.",
                           extore.clientoid.displayName,
                           extore.clientoid.displayName
                           ]] ;
        NSTimer* timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:timeout
                                                                 target:self
                                                               selector:@selector(writeAndDeleteTimedOut:)
                                                               userInfo:prefabbedError
                                                                repeats:NO] ;
        [[self info] setObject:timeoutTimer
                        forKey:constKeyTimeoutTimer] ;        
    }
    [self actualWriteAndDeleteExtore:extore] ;
}

- (void)pushToCloud {
	// This operation is skipped if we're doing a test run (SDTR)
	if ([[[self info] objectForKey:constKeyIsTestRun] boolValue] == YES) {
		return ;
	}
	
	if ([[[self info] objectForKey:constKeyDidExportAnything] boolValue] == YES) {
		[self doSafely:_cmd] ;
	}
}

- (void)pushToCloud_unsafe {
	Extore* extore = [[self info] objectForKey:constKeyExtore] ;
	NSError* error = nil ;
	BOOL ok = [extore pushToCloudError_p:&error] ;
	if (!ok) {
		[self setError:error] ;
	}
}	

- (void)writeAndDeleteDidSucceed:(BOOL)didSucceed {
    [[[self info] objectForKey:constKeyTimeoutTimer] invalidate] ;
    [[self info] removeObjectForKey:constKeyTimeoutTimer] ;
    
	Extore* extore = [[self info] objectForKey:constKeyExtore] ;
	Client* client = [extore client] ;
    BkmxDoc* bkmxDoc = [self.info objectForKey:constKeyDocument];

	// Empirically determining the wait required, with 3 tries, 1.0 seconds
	// was not enough, but with another 3 tries, 2.0 seconds was enough.
	// I'd like to do 5 seconds, but you know we're going to be missing
	// bookmarks changes during this time.  We'll make it 2.5 seconds.
	// 2.5 seconds is 2500000 microseconds…
#define CLEAR_KQUEUE_STEPS 10
#define CLEAR_KQUEUE_MICROSECONDS_PER_STEP 250000
	SSYProgressView* progressView = [bkmxDoc progressView] ;
	// Note: In BkmxAgent, progressView will be nil.
	[progressView clearAll] ;
	
	// Unblind triggers, if any were blinded
	NSSet* blinderKeys = [[self info] objectForKey:constKeyTriggerBlinderKeys] ;
	if ([blinderKeys count] > 0) {
        /* We delay slightly here, because if we install or even load a
         WatchPaths agent within 2 seconds of when the file was last
         changed, its job will fire immediately upon install/load.

         UPDATE 2018-09-18.  I do not know if the kqueue mechanism,
         which now replaces the launchd mechanism, might also require
         a 2.5 second delay.  I am leaving it in.

         This 2.5 second delay leaves open the possibility that the
         user may make additional bookmarks changes which would be
         missed during this period, while the agent watching it has
         not been reinstalled yet.  So I wrote some code which checked
         the modification date of the watched file before and after
         the wait, and stage a sync redo if there is any difference.
         But then I found another issue – that the modification date
         of a file will not be changed until a second or two after the
         file was written.  So I was always staging sync redos!
         The solution to this is to wait 2-3 seconds before reading
         the file modification date the first time, but at this point
         I don't need the 2-3 second wait to re-activate the agent
         because I've already waited 2-3 seconds to wait for the
         file modification date to change.  In fact, these two
         delays are probably caused by the same mechanism.
         See Apple Bug Reporter Problem ID 10390236.

         Since the wait time required is rather substantial and will
         be annoying to users, we run a gauntlet of conditions to
         only wait here if really necessary…
         */
		BOOL done = NO ;
		for (Syncer* syncer in [[bkmxDoc macster] syncers]) {
			if (done) {
				break ;
			}
			if ([syncer isActive]) {
				for (Trigger* trigger in [syncer triggers]) {
					if ([trigger triggerTypeValue] == BkmxTriggerSawChange) {
						if ([trigger client] == [extore client]) {
							// Wait, with a progress bar
							[progressView setMaxValue:CLEAR_KQUEUE_STEPS] ;
							[progressView setDoubleValue:1.0] ;
							NSString* whatDoing = @"Waiting for macOS to clear its kqueue." ;
							[progressView setVerb:whatDoing
										   resize:YES] ;
							[progressView display] ;
							for (NSInteger i=0; i<CLEAR_KQUEUE_STEPS; i++) {
								[progressView incrementDoubleValueBy:1.0] ;
								usleep(CLEAR_KQUEUE_MICROSECONDS_PER_STEP) ;
							}
							[progressView clearAll] ;
							
							done = YES ; // break out of outer for(syncer) loop
							break ;      // break out of inner for(trigger) loop
						}
					}
				}
			}
		}

        progressView = [progressView setIndeterminate:YES
                                    withLocalizedVerb:@"Waiting for macOS' launchd"
                                             priority:SSYProgressPriorityRegular] ;
        NSError* unblindingError = nil ;
		// The actual unblinding is one line of code…
		[[bkmxDoc macster] unblindTriggersWithKeys:blinderKeys
                                           error_p:&unblindingError] ;
		[progressView clearAll] ;
        
        if (unblindingError) {
            if ([unblindingError code] == constBkmxErrorCouldNotReenableTrigger) {
                // This is an error which we want to display to the user
                // later, but is not a show-stopper for this export.
                NSInvocation* invocation = [NSInvocation invocationWithTarget:[SSYAlert class]
                                                                     selector:@selector(alertError:)
                                                              retainArguments:YES
                                                            argumentAddresses:&unblindingError] ;
                [[self info] addObject:invocation
                          toArrayAtKey:constKeyMoreDoneInvocations] ;
            }
            else {
                // This branch should never execute but is for futureproofing.
                // Assume this error is a show-stopper.
                NSLog(@"Internal Error 233-9464") ;
                [self setError:unblindingError] ;
            }
        }
	}
	
	NSError* error = nil ;
	if (!didSucceed) {
        if (client) {  // Defensive programming, but I've seen this happen due to a bug.
            [bkmxDoc forgetVolatileLastPreExportedDataForClientoid:extore.clientoid];
        }

		// Get the error from its creator
		error = [extore error] ;

		if ([error involvesMyDomainAndCode:constBkmxErrorNoItemsToUpload]) {
			// This is not really an error.  This is a fact that we pass along.
			[[self info] setObject:[NSNumber numberWithBool:YES]
							forKey:constKeyNoItemsToUpload] ;
		}
		else {
            if (error) {  // Defensive programming
                // This is a real error

                // Add title
                NSString* title = [NSString localizeFormat:
                                   @"failedX",
                                   [NSString stringWithFormat:@"Export to %@",
                                    [extore displayName]]] ;
                error = [error errorByAddingLocalizedTitle:title] ;

                // Add more info
                error = [error errorByAddingUserInfoObject:[extore filePathError_p:NULL]
                                                    forKey:@"Extore's filePath"] ;
                error = [error errorByAddingUserInfoObject:extore.clientoid
                                                    forKey:@"Extore's clientoid"] ;

                [self setError:error] ;

                [self errorizeIxportLog] ;
            }
			
			[bkmxDoc forgetLastPreImportedHashForClient:client] ;
			[bkmxDoc forgetLastPreExportedHashForClient:client] ;
		}		
	}

	// Because the Client's content has just been changed,
	// the next time we *im*port, we'll expect to get back what we
    // exported.
    [bkmxDoc rememberBothLastImportedHashForExtore:extore] ;

	[self unlockLock] ;  // Was locked in writeAndDelete_unsafe
}

- (void)feedbackPostWrite {
	// This operation is skipped if we're doing a test run (SDTR)
	if ([[[self info] objectForKey:constKeyIsTestRun] boolValue] == YES) {
		return ;
	}
	
	[self doSafely:_cmd] ;
}

- (void)feedbackPostWrite_unsafe {
	if (![self anyChangesToWrite]) {
		return ;
	}
	
	Extore* extore = [[self info] objectForKey:constKeyExtore] ;
    BkmxDoc* bkmxDoc = [self.info objectForKey:constKeyDocument];
	Client* client = [extore client] ;
	SSYProgressView* progressView = [bkmxDoc progressView] ;
	// Note: In BkmxAgent, progressView will be nil.
	
	[progressView setMaxValue:[[[extore starker] allStarks] count]] ;
	[progressView setDoubleValue:1.0] ;
	NSString* whatDoing = [[BkmxBasis sharedBasis] labelNewIdentifiers] ;
	whatDoing = [whatDoing stringByAppendingString:@" 2/2"] ;
	[progressView setVerb:whatDoing
				   resize:NO] ;
	[progressView display] ;
	
	NSMutableArray* refailedStarks = [NSMutableArray array] ;
	Clientoid* clientoid = [client clientoid] ;
	NSDictionary* exportFeedbackDic = [[self info] objectForKey:constKeyExportFeedbackDic] ;
	NSInteger newExidsCount = [[[self info] objectForKey:constKeyNewExidsCount] integerValue] ;
	for (Stark* stark in [[extore starker] allStarks]) {
		[progressView incrementDoubleValueBy:1.0] ;
		if (![stark isHartainer]) {			
			NSString* exid = nil ;
            [stark getOrMakeValidExid_p:&exid
                                 extore:extore
                          isAfterExport:YES
                                tryHard:YES]; // because this is the second round

			// When it failed to validate, we already set the exid in the
			// mate to nil during the first round.  So now just set it for
			// non-failing cases.
			Stark* mateInBkmxDoc = nil ;
			if (exid) {
				mateInBkmxDoc = [exportFeedbackDic objectForKey:[stark objectID]] ;
				if (mateInBkmxDoc) {
					// I'm not sure, but the following if() may have cured some "Core Data could not fulfill a fault..." errors
					if (![mateInBkmxDoc isDeleted]) {
						// We first check to see if there has been any change, to avoid
						// unnecessary churn
						NSString* currentExid = [mateInBkmxDoc exidForClientoid:clientoid] ;
						if (![NSString isEqualHandlesNilString1:currentExid
														string2:exid]) {
							[mateInBkmxDoc setExid:exid
									 forClientoid:clientoid] ;
							newExidsCount++ ;
						}
					}
				}
			}
			else {
				[refailedStarks addObject:stark] ;
			}
		}
	}
	if (newExidsCount > 0) {
		[[self info] setObject:[NSNumber numberWithInteger:newExidsCount]
						forKey:constKeyNewExidsCount] ;
	}
	
	[progressView clearAll] ;
	
	NSInteger nFailed = [refailedStarks count] ;
	if (nFailed > 0) {
		// Log the failures!
		NSLog(@"%ld items still failed:", (long)nFailed) ;
		NSInteger i = 1 ;
		NSMutableString* moreInfo = [NSMutableString string] ;
		[moreInfo appendString:@"\n"] ;
		for(Stark* stark in refailedStarks) {
			[moreInfo appendFormat:@"%5ld name: %@\n", (long)i, [stark name]] ;
			[moreInfo appendFormat:@"%5ld  url: %@\n", (long)i, [stark url]] ;
			i++ ;
			if (i > 50) {
				break ;
			}
		}
		
		NSNumber* requirementObject ;

		requirementObject = [[NSUserDefaults standardUserDefaults] objectForKey:constKeyExidFailureRateAllowed] ;
		CGFloat failureRateAllowed = requirementObject ? [requirementObject doubleValue] : 0.0 ;
		requirementObject = [[NSUserDefaults standardUserDefaults] objectForKey:constKeyExidFailuresAllowed] ;
		CGFloat nFailuresAllowed = requirementObject ? [requirementObject integerValue] : 0 ;
		
		CGFloat nTotal = (CGFloat)[[[extore starker] allStarks] count] ;
		// Because of the way nFailed is generated, and we are in nFailed > 0, nTotal must be > 0.
		CGFloat failureRate = ((CGFloat)nFailed/nTotal) ; 
		
		if (
			(nFailed > nFailuresAllowed)
			||
			(failureRate > failureRateAllowed)
			) {
			// Create and set an error		 
			NSString* msg = [NSString stringWithFormat:@"Your bookmarks were probably written to %@ OK, but %@ did not return identifiers for %ld items.  These items may not sync properly during future exports.\n\n%@",
							 [[extore client] displayName],
							 [extore ownerAppDisplayName],
							 (long)[refailedStarks count],
							 [[refailedStarks valueForKey:constKeyName] subarrayWithRange:NSMakeRange(0, MIN([refailedStarks count], 10))]] ;
			NSError* error = SSYMakeError(constBkmxErrorCantWritePersistentAuxiliaryData, msg) ;			
			error = [error errorByAddingUserInfoObject:moreInfo
												forKey:@"Failures"] ;
			error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:nFailed]
												forKey:@"nFailed"] ;
			error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:nFailuresAllowed]
												forKey:@"nFailedAllowed"] ;
			error = [error errorByAddingUserInfoObject:[NSNumber numberWithDouble:failureRate]
												forKey:@"failureRate"] ;
			error = [error errorByAddingUserInfoObject:[NSNumber numberWithDouble:failureRateAllowed]
												forKey:@"failureRateAllowed"] ;
			
			[self setError:error] ;
		}
	}	
}	

- (void)checkFight {
	// This operation is skipped if we're doing a test run (SDTR)
	if ([[[self info] objectForKey:constKeyIsTestRun] boolValue] == YES) {
		return ;
	}
	
	if ([[[self info] objectForKey:constKeyPerformanceType] integerValue] == BkmxPerformanceTypeUser) {
		return ;
	}
	
	[self doSafely:_cmd] ;
}

// This method should be invoked for exporters only
- (void)checkFight_unsafe {
	BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument] ;
	Ixporter* ixporter = [[self info] objectForKey:constKeyIxporter] ;

	// Get all export logs
	SSYMojo* mojo = [[SSYMojo alloc] initWithManagedObjectContext:[[BkmxBasis sharedBasis] diariesMocForIdentifier:[bkmxDoc uuid]]
													   entityName:constEntityNameExportLog] ;
	NSError* error = nil ;
	NSArray* immutableExportLogs = [mojo allObjectsError_p:&error] ;
	NSMutableArray* exportLogs = [immutableExportLogs mutableCopy] ;
	[mojo release] ;
	if (error) {
		NSLog(@"Internal Error 233-3291 %@", error) ;
	}

	// Remove export logs from other exporters.
	NSString* thisExporterUri = [ixporter objectUriMakePermanent:NO
                                                        document:nil] ;
	for (ExportLog* exportLog in immutableExportLogs) {
		if (![thisExporterUri isEqualToString:[exportLog exporterUri]]) {
			[exportLogs removeObject:exportLog] ;
		}
	}
	
    // Sort by serial number, most recent first
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:constKeySerialNumber
																   ascending:NO] ;
	[exportLogs sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] ;
	[sortDescriptor release] ;	
	
    // Remove all older ones, only keep number up to fightThreshold
    NSInteger fightThreshold ;
	NSNumber* fightThresholdObject = [[NSUserDefaults standardUserDefaults] objectForKey:constKeyFightThreshold] ;
	if (fightThresholdObject) {
		fightThreshold = [fightThresholdObject integerValue] ;
	}
	else {
		fightThreshold = 4 ;
	}
	NSInteger removeStart = MIN([exportLogs count], fightThreshold) ;  // Will be in range 0..FIGHT_THRESHOLD provided that FIGHT_THRESHOLD > 0.  Will never be > [exportLogs count]
	NSInteger removeLength = [exportLogs count] - removeStart ;
	NSRange removeRange = NSMakeRange(removeStart, removeLength) ;
	[exportLogs removeObjectsInRange:removeRange] ;
	
    /* Declare fighting = YES if all of the remaining export logs (1) exported
     one or more changes and (2) had the same effect as the prior export.
     Otherwise, fighting = NO. */
    BOOL fighting = NO ;
    if ([exportLogs count] >= fightThreshold) {
		fighting = YES ;
		for (NSInteger i=0; i<([exportLogs count] - 1); i++) {
			ExportLog* exportLog = [exportLogs objectAtIndex:i] ;
			if ([[exportLog starkoids] count] == 0) {
				// There are no changes in the latest export.
				// This cannot be a fight because a fight means
				// that you export a change, then import the opposite
				// changes, then export the same changes again.
				fighting = NO ;
				break ;
			}
			ExportLog* priorExportLog = [exportLogs objectAtIndex:(i+1)] ;
			BOOL noFight = ![exportLog hadSameEffectAsExportLog:priorExportLog] ;
			if (noFight) {
				fighting = NO ;
				break ;
			}
		}
	}
	
#define SNAPSHOTS_NEEDED_FOR_TROUBLE_ZIP 8
	if (fighting) {
		Extore* extore = [[self info] objectForKey:constKeyExtore];
        NSInteger count = [extore countOfRecentSnapshotsAvailable];
		BOOL enoughDataForTroubleZip = count >= SNAPSHOTS_NEEDED_FOR_TROUBLE_ZIP;

		if (!enoughDataForTroubleZip) {
            [Extore ensureSpaceForMoreSyncSnapshots];
		}
		else {
			[[bkmxDoc macster] pauseSyncers:YES
									alert:nil] ;
			
			NSString* whatDid = ([[bkmxDoc macster] syncerConfigValue] == constBkmxSyncerConfigIsAdvanced) 
			? @"Your Syncers have been deactivated."
			: @"Syncing has been paused.  Your bookmarks are no longer being sorted nor synced." ;
			NSString* logMsg = @"Fight detected. \u279E " ;
			logMsg = [logMsg stringByAppendingString:whatDid] ;
			[[BkmxBasis sharedBasis] logFormat:logMsg] ;
			
			NSString* exporterDisplayName = [[exportLogs lastObject] exporterDisplayName] ;
			NSDate* fightBeginDate = [(ExportLog*)[exportLogs lastObject] timestamp] ;
			NSInteger minutesFighting = (NSInteger)(-[fightBeginDate timeIntervalSinceNow]/60.0) ;  // /60 converts seconds to minutes
			NSString* desc = [NSString stringWithFormat:
							  @"BookMacster has exported the same changes to %@ %ld times in the last %ld minutes.  "
							  @"But each time, something has changed them back.\n\n"
							  @"%@",
							  exporterDisplayName,
							  (long)fightThreshold,
							  (long)minutesFighting,
							  whatDid] ;
			NSError* error = SSYMakeError(constBkmxErrorFightDetected, desc) ;
			error = [error errorByAddingHelpAddress:constHelpAnchorSyncFight] ;
			error = [error errorByAddingLocalizedRecoverySuggestion:@"Click the (?) Help button on the left for further information."] ;
			[self setError:error] ;
		}

        NSString* msg = [NSString stringWithFormat:
                         @"Sync Fight detected over %@ [%ld/%ld]",
                         [[ixporter client] displayName],
                         (long)count,
                         (long)SNAPSHOTS_NEEDED_FOR_TROUBLE_ZIP] ;
        [[BkmxBasis sharedBasis] logFormat:msg] ;
	}
    
    [exportLogs release] ;
}

- (void)timestampExported {
	// This operation is skipped if we're doing a test run (SDTR)
	if ([[[self info] objectForKey:constKeyIsTestRun] boolValue] == YES) {
		return ;
	}
	
	[self doSafely:_cmd] ;
}

- (void)timestampExported_unsafe {
	// Because we are running in an SSYOperation, we know that
	// has been no error so far
	if (![[self info] objectForKey:constKeyNoItemsToUpload]) {
		Extore* extore = [[self info] objectForKey:constKeyExtore] ;
		// Note: Next line will use Main Window's progressView,
		// if network access is necessary such as for del.icio.us.
		NSDate* previousDate = [extore lastDateExternalWasTouched] ;
		if (!previousDate) {
			[self setError:[extore error]] ;
			return ;
		}
		Client* client = [extore client] ;  // Accesses managed object -- that's why this method is unsafe
		[[NSUserDefaults standardUserDefaults] setLastChangeWrittenDate:[[NSDate date] laterDate:previousDate]
															   toClient:client] ;
		// The following line was moved to here in BookMacster 1.11.5
		// See Note 20120625.
		if ([extore isKindOfClass:[ExtoreWebFlat class]]) {
			// If we made it here, localMoc was synced to web server OK
			// We need to log the time this was done.
			[client setLastLocalMocSync:previousDate] ;
		}
	}
}

- (void)showCompletionExported {
	if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
		[self doSafely:_cmd] ;
	}
}

- (void)showCompletionExported_unsafe {
    BkmxDoc* bkmxDoc = [self.info objectForKey:constKeyDocument];
	Extore* extore = [[self info] objectForKey:constKeyExtore] ;
	
	NSString* whatDid ;
	if ([[[self info] objectForKey:constKeyIsTestRun] boolValue] == YES) {
		whatDid = [NSString localize:@"testRun"] ;
	}
	else {
		whatDid = [[BkmxBasis sharedBasis] labelExport] ;
	}
	
	SSYProgressView* progressView = [bkmxDoc progressView] ;
	NSString* verb = [NSString stringWithFormat:
					  @"%@ %C %@",  // Used symbol since "Export Safari" may not be correct for non-English
					  whatDid,
					  (unsigned short)0x2192,
					  [[extore client] displayName]] ;
	[progressView showCompletionVerb:verb
                              result:[[bkmxDoc chaker] displayStatistics]
                            priority:SSYProgressPriorityRegular] ;
    
    for (NSNumber* hartainerNumber in [[self info] objectForKey:constKeyHartainerSharypesRemoved]) {
        NSString* title = nil;
        NSString* subtitle = nil;
        NSString* body = nil;
        NSString* helpBookAnchor = nil;
        [extore getTextForRemovalOfLegacyHartainer:hartainerNumber.sharypeValue
                                           title_p:&title
                                        subtitle_p:&subtitle
                                            body_p:&body
                                  helpBookAnchor_p:&helpBookAnchor];
        NSError* presentationError = nil;
        [BkmxNotifierCaller presentUserNotificationWithHelpTitle:title
                                                  alertNotBanner:YES
                                                        subtitle:subtitle
                                                            body:body
                                                       soundName:nil
                                                  helpBookAnchor:helpBookAnchor
                                                         error_p:&presentationError];
        if (presentationError) {
            [[BkmxBasis sharedBasis] logError:presentationError
                              markAsPresented:NO];
        }
    }
}

- (void)showTestRunDiary {
	if (![[[self info] objectForKey:constKeyIsTestRun] boolValue]) {
		return ;
	}

	// Interaction with GUI must happen on main thread
	[self doSafely:_cmd] ;
}

- (void)showTestRunDiary_unsafe {
    BkmxDoc* bkmxDoc = [self.info objectForKey:constKeyDocument];
	[bkmxDoc revealTabViewIdentifier:constIdentifierTabViewDiaries] ;
}

- (void)checkImportHashIsSame {
    [self doSafely:_cmd] ;
}

- (void)checkImportHashIsSame_unsafe {
	Extore* extore = [[self info] objectForKey:constKeyExtore] ;
	Client* client = [extore client] ;
	BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument] ;
	
    BOOL agentDoesImport = [[[self info] objectForKey:constKeyAgentDoesImport] boolValue] ;
    if (!agentDoesImport) {
        [[BkmxBasis sharedBasis] logFormat:@"%@: Not BkmxAgent Imp+Exp \u279E No hash check", [client displayName]];
    }
    else {
        BOOL weAreWatchingThisClientForChanges = NO ;
        if ([[client importer] isActive]) {
            for (Trigger* trigger in [client triggers]) {
                if ([trigger triggerTypeValue] == BkmxTriggerSawChange) {
                    weAreWatchingThisClientForChanges = YES ;
                }
            }
        }

        if (!weAreWatchingThisClientForChanges) {
            [[BkmxBasis sharedBasis] logFormat:@"%@: Not watched \u279E No hash check", [client displayName]];
        }
        else {
            BOOL debugIxportHashes = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppBoolForKey:constKeyDebugIxportHashes];
            if (debugIxportHashes) {
                [Stark debug_clearHashComponents] ;
            }
            uint32_t currentContentHash = [extore contentHash] ;
            if (debugIxportHashes) {
                [Stark debug_writeHashComponentsToDesktopWithPhaseName:@"ECHIS"
                                                        clientName:[client displayName]];
            }
            uint32 lastExportedHash = (uint32)[[[NSUserDefaults standardUserDefaults] lastExportPostHashForClientoid:client.clientoid] unsignedIntegerValue] ;
            BOOL matched = (currentContentHash == lastExportedHash);

#if DEBUG
            {
                NSString* msg = [NSString stringWithFormat:
                                 @"ECHIS 1 (old-Exp): %@: %@: %08lx (now) =? %08lx (old)",
                                 [client displayName],
                                 matched ? @"OK" : @"NO",
                                 (long)currentContentHash,
                                 (long)lastExportedHash];
                [[BkmxBasis sharedBasis] logFormat:msg];
            }
#endif

            if (matched) {
                [[BkmxBasis sharedBasis] logFormat:@"ECHIS 2: %@ OK, current hash matches prior export", [client displayName]] ;
            } else {
                NSNumber* oldHashNumber = [bkmxDoc lastPostImportedHashForClient:client
                                                                       whichPart:BkmxDocHashPartExtore] ;
                if (oldHashNumber) {
                    uint32_t oldHashBottom = (uint32_t)[oldHashNumber unsignedLongValue] ;

                    uint32_t compositeSettingsHash = [[NSUserDefaults standardUserDefaults] compositeImportSettingsHashForClientoid:client.clientoid] ;
                    uint32_t newHashBottom = currentContentHash ^ compositeSettingsHash ;

                    matched = (oldHashBottom == newHashBottom);

#if DEBUG
                    {
                        NSString* msg;
                        msg = [NSString stringWithFormat:@"ECHIS 3 (old-Imp): %@: %@: %08lx ^ %08lx = %08lx (now) ?= %08lx (old)",
                               [client displayName],
                               matched ? @"OK" : @"NO",
                               (long)currentContentHash,
                               (long)compositeSettingsHash,
                               (long)newHashBottom,
                               (long)oldHashBottom];
                        [[BkmxBasis sharedBasis] logFormat:msg];
                    }
#endif

                    if (matched) {
                        [[BkmxBasis sharedBasis] logFormat:@"ECHIS 4: %@ OK, current hash matches prior import", [client displayName]] ;
                    } else {
                        NSError* error = nil  ;
                        NSString* msg = [NSString stringWithFormat:
                                         @"ECHIS 5: %@ content was changed by others \u279E Won't export",
                                         [client displayName]];
                        [[BkmxBasis sharedBasis] logFormat:msg] ;

                        BkmxPerformanceType performanceType = [bkmxDoc currentPerformanceType] ;
                        switch (performanceType) {
                            case BkmxPerformanceTypeAgent:
                            case BkmxPerformanceTypeScripted:
                                /*
                                 Update 20180921

                                 Well, the following looks impressive.  But I see that,
                                 although being set here, the property
                                 contentIsStaleDueToChangesInWatchedClientNotImported
                                 is never read.  So I commented out the line of code at
                                 the bottom of this comment, and deleted the property
                                 it was setting. */



                                // Very important, so that [bkmxDoc lastPreImportedHashForClient:whole:]
                                // will return nil on the redo sync run.  Otherwise, we'll
                                // end up here again and end up repeating redo jobs forever!
                                [bkmxDoc forgetLastPreImportedHashForClient:client] ;

                                Job* job = [[self info] objectForKey:constKeyJob];

                                [Stager setNeedsImportClidentifier:client.clientoid.clidentifier
                                                    toDocumentUuid:[bkmxDoc uuid]];
                                [[BkmxBasis sharedBasis] forJobSerial:job.serial
                                                            logFormat:@"ECHIS: 6 Flagged that %@ needs to be imported", [client displayName]] ;

                                for (Client* otherClient in [[self info] objectForKey:constKeyUnflaggedImportClients]) {
                                    [Stager setNeedsImportClidentifier:otherClient.clientoid.clidentifier
                                                        toDocumentUuid:[bkmxDoc uuid]];
                                    [[BkmxBasis sharedBasis] logFormat:@"ECHIS 7: Reflagged that %@ needs to be imported", [otherClient displayName]] ;
                                    /* To ensure that we import this client during the redo: */
                                    [bkmxDoc forgetLastPreImportedHashForClient:otherClient];
                                    [bkmxDoc forgetLastPostImportedHashForClient:otherClient];
                                }

                                if (!job) {
                                    error = SSYMakeError(295857, @"Cannot schedule do-over because no job");
                                    error = [error errorByAddingUserInfoObject:client
                                                                        forKey:constKeyClient] ;
                                    [self setError:error];
                                } else {
                                    error = SSYMakeError(constBkmxErrorBrowserBookmarksWereChangedDuringSync, msg) ;
                                    // This error will be hidden.  The Export will fail silently.
                                    error = [error errorByAddingUserInfoObject:job
                                                                        forKey:constKeyJob];
                                    error = [error errorByAddingUserInfoObject:@(AGENT_REDO_DELAY)
                                                                        forKey:constKeyAgentRedoDelay];

                                    // Abort this export, and any queued exports to other clients
                                    [self setAllGroupsError:error] ;

                                    job.reason = AgentReasonStageRedo;
                                    [Stager stageJob:job
                                               phase:@"ECHIS"];
                                }

                                break ;
                            default:
                                // In Main App, not scripted
                                /* 2017-02-09  I think this branch never runs any more
                                 due to "if (!agentDoesImport)" above, which will always
                                 be true in Main App. */
                                NSAssert(NO, @"I think this should not happen any more");
                        }
                    }
                }
            }

			/* Note WhyNotRememberLastPreImportedHashForExtore

             I really think we should do this here, but it seems to be
             unnecessary, because if we ae indeed importing from a client,
             the redo sync operation scheduled as a result of mismatch in ECHIS
             will do a *real* import as the next operation, and *that* hash
             will be remembered and will prevent a hash mismatch in ECHIS
             during the redo.  But I'm leaving this code here in case I one
             day find out that there are other cases which need this. */
            //[bkmxDoc rememberLastPreImportedHashForExtore:extore];
            //[bkmxDoc persistClientLastPreImportedData];
        }
    }
}

- (void)checkExportHashIsDiff {
	// The following was commented out in BookMacser 1.9.8, because
	// I think that our export hash checking is now leakproof.
	// If any of the BkmxDoc content, Exporter Settings, or content
	// in the Client has changed since the last no-change-after-merge
	// export, this method will *not* set an error and the writing
	// will occur.  It doesn't matter, even if the user has
	// commanded the export manually.  If we read in the data
	// from the Client, and this data and the BkmxDoc content and the
	// Exporter Settings are all the same as the previous export, and
	// if the merge in that previous export showed no changes, there
	// is no need to export and we will not.
	//	if ([[self info] objectForKey:constKeyIfNotNeeded]) {
	//      // This export was commanded manually by the user.
	//		// Do not even check the hash; do this export regardless
	//		return ;
	//	}
	
	[self doSafely:_cmd] ;
}

/*!
 @brief  Checks to see if there are any changes to merge; sets an error if not,
 and remembers the export hash for next time if so.

 @details  We want to cancel the merge whenever possible for efficiency.  Even if
 we do the merge, though, we will later have a chance to cancel the export if there
 are no changes to export.  This method stops useless processing sooner.

 Note that oldHash and newHash are 64 bits, composed of four values…
 |didChange|         extore content           |  bkmxDoc content ^ exporter settings  |
 |   1 bit |           top 31 bits            |         bottom 32 bits               |
 
 (The bottom 32 bits come from -[client exportHashFromBkmxDoc:bkmxDoc].)
 
 Now the only fact we can use is this:  If the bottom three input datas, represented
 by the hash, are merged and result in no changes to export, then the *next* time
 we see that same input, we'll conclude that there will be no changes to export.
 So, oddly, although we need to remember the hash before the merge, because
 merging may change the extore content, we must check after the merge and
 set the didChange bit to 1 if any change occurred and 0 if no change
 occurred, and then only skip future exports if the didChange bit is 0 and the
 other 63 bits match.
 
 The extore content is required due to the following corner case…
 
 Say that Firefox is an Import+Export Client with a Bookmarks Changed trigger.
 Something happens which causes an export, and Firefox gets two bookmarks X and Y,
 in that order, "XY".  Now the user goes and disorders these two bookmarks,
 changing the order to YX.  Syncer is triggered.  Bookmarks YX are imported.  After
 sorting, the order is XY.  Now time to export.  Enter checkExportHash.  If the
 composite hash we compare is based only on bkmxDoc content and exporter settings,
 checkExportHash_unsafe will find that oldHash == newHash because they both have the
 order XY.  Merge and export will be cancelled.  Expected Result: Bookmarks in
 Firefox should have been sorted back to order XY.  Actual Result: They remain YX.
 
 Now, although this is a corner case, it is actually a simple test of BookMacster's
 "sorting syncer" capability which a user might do, and actually, I have executed
 myself many times.  That is, although this corner case may be rare in practice,
 it will not be rare in testing.
*/
- (void)checkExportHashIsDiff_unsafe {
	Extore* extore = [[self info] objectForKey:constKeyExtore] ;
	Client* client = [extore client] ;
	BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument] ;
	
	NSNumber* oldWholeNumber = [bkmxDoc lastPreExportedHashForClient:client] ;
	if (oldWholeNumber) {
		unsigned long long oldWhole = [oldWholeNumber longLongValue] ;
		if ((oldWhole & BkmxExportHashBitMaskDidChangeBit) == 0) {
			unsigned long long upperHalf = ([extore contentHash] & BkmxExportHashBitMaskWholePayload) ;
			unsigned long long newWhole =  (((upperHalf << 32) + [client exportHashFromBkmxDoc:bkmxDoc]) & BkmxExportHashBitMaskWholePayload) ;
			if (oldWhole == newWhole) {
				NSString* msg = [NSString stringWithFormat:
								 @"%@ same merge data as prior, no changes \u279E Skip",
								 [[extore client] displayName]] ;
				[[BkmxBasis sharedBasis] logFormat:msg] ;
				[[BkmxBasis sharedBasis] trace:msg] ;
				[[BkmxBasis sharedBasis] trace:@"\n"] ;
				
#if WRITE_AND_DELETE_EVEN_IF_NO_CHANGES
                // Do not generate this error
#else
                NSError* error = SSYMakeError(constBkmxErrorNoChangesToExport, @"same merge data as prior, no changes") ;
                [self setError:error] ;
#endif
			}
		}
	}
}

- (void)rememberLastPreExportedHashPayload {	
	[self doSafely:_cmd] ;
}

- (void)rememberLastPreExportedHashPayload_unsafe {
	Extore* extore = [[self info] objectForKey:constKeyExtore] ;
	Client* client = [extore client] ;
	BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument] ;
	
	unsigned long long upperHalf = [extore contentHash] ;
	unsigned long long whole =  (upperHalf << 32) + [client exportHashFromBkmxDoc:bkmxDoc] ;
		
	[bkmxDoc setLastPreExportedHash:(whole & BkmxExportHashBitMaskWholePayload)
                         forClient:client] ;
}

/* This must be called on the main thread due to Core Data accesses. */
- (void)debugVerifyHashWithLoopbackThen:(void (^)(void))completionHandler {
    Extore* extore = [[self info] objectForKey:constKeyExtore];
    Client* client = [extore client];

    [extore doBackupLabel:@"PstEx"] ;

    [extore readExternalUsingCurrentStyleWithPolarity:BkmxIxportPolarityImport
                                            jobSerial:0
                                      completionHandler:^void() {
                                        [Stark debug_clearHashComponents] ;
                                        uint32_t readbackHash = [extore contentHash];
                                        [Stark debug_writeHashComponentsToDesktopWithPhaseName:@"VfyExpHsh"
                                                                                    clientName:[client displayName]];
                                        uint32_t persistedHash = [[[NSUserDefaults standardUserDefaults] lastExportPostHashForClientoid:client.clientoid] unsignedIntValue];
                                        NSString* msg;
                                        if (readbackHash == persistedHash) {
                                            msg = [NSString stringWithFormat:@"Export Hash good loopback %08lx for %@",
                                                   (long)readbackHash,
                                                   [extore displayName]];
                                        } else {
                                            msg = [NSString stringWithFormat:@"Export Hash bad loopback! Persisted %08lx, read %08lx for %@",
                                                   (long)persistedHash,
                                                   (long)readbackHash,
                                                   [extore displayName]];
                                            
                                        }
                                        [[BkmxBasis sharedBasis] logFormat:msg];
                                        
                                        if (completionHandler) {
                                            completionHandler();
                                        }
                                    }];
}

- (void)persistLastPostExportedHash {
    [self prepareLock];
	[self doSafely:_cmd];
    [self blockForLock];
}

- (void)persistLastPostExportedHash_unsafe {
    [self lockLock];
	Extore* extore = [[self info] objectForKey:constKeyExtore] ;
	Client* client = [extore client] ;

    if ([extore hashCoversAllAttributesInCurrentStyle]) {
        BOOL debugIxportHashes = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppBoolForKey:constKeyDebugIxportHashes];
        if (debugIxportHashes) {
            [Stark debug_clearHashComponents] ;
        }
        unsigned long long hash = (unsigned long long)[extore contentHash] ;
        if (debugIxportHashes) {
            [Stark debug_writeHashComponentsToDesktopWithPhaseName:@"PrsPstExp"
                                                        clientName:[client displayName]];
        }

        NSString* clidentifier = client.clientoid.clidentifier;
        if (clidentifier) {
            [[NSUserDefaults standardUserDefaults] setLastExportPostHash:[NSNumber numberWithUnsignedLongLong:hash]
                                                            clidentifier:clidentifier];
        }
        
        if (debugIxportHashes) {
            NSString* debugLogMsg = [NSString stringWithFormat:@"PrsPstExp = %016qx for %@", hash, [client displayName]] ;
            [[BkmxBasis sharedBasis] logFormat:debugLogMsg] ;
        }

        [[client macster] save] ;

#if VERIFY_HASH_WITH_IMMEDIATE_LOOPBACK
        [self debugVerifyHashWithLoopbackThen:^void() {
            [self unlockLock];
        }];
#else
        [self unlockLock];
#endif
    } else {
        NSString* msg = [NSString stringWithFormat:
                         @"Not full hash coverage for %@ style %ld \u279e Don't persist",
                         [extore displayName],
                         extore.ixportStyle];
        [[BkmxBasis sharedBasis] logFormat:msg] ;
        [self unlockLock];
    }
}

- (void)rememberLastPreExportedHashChangeBit {	
	[self doSafely:_cmd] ;
}

- (void)rememberLastPreExportedHashChangeBit_unsafe {
	Extore* extore = [[self info] objectForKey:constKeyExtore] ;
	BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument] ;
	
	unsigned long long hash = [[bkmxDoc lastPreExportedHashForClient:[extore client]] longLongValue] ;
	if ([self anyChangesToWrite]) {
		[bkmxDoc setLastPreExportedHash:(hash | BkmxExportHashBitMaskDidChangeBit)
						  forClient:[extore client]] ;
	}
	else {
		[bkmxDoc setLastPreExportedHash:(hash & ~BkmxExportHashBitMaskDidChangeBit)
						  forClient:[extore client]] ;
	}
}


/*
 - (void)template {
	NSError* error = nil ;
	Extore* extore = [[self info] objectForKey:constKeyExtore] ;
  BkmxDoc* bkmxDoc = [self.info objectForKey:constKeyDocument];
  SSYProgressView* progressView = [bkmxDoc progressView] ;
  // Note: In BkmxAgent, progressView will be nil.
  Client* client = [extore client] ;
	
	// Insert code here ...
	
	if (error) {
		[self setError:error] ;
	}
}
 */

@end
