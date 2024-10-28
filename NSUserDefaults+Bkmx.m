#import "NSUserDefaults+Bkmx.h"
#import <Bkmxwork/Bkmxwork-Swift.h>
#import "BkmxBasis+Strings.h"
#import "NSData+FileAlias.h"
#import "NSUserDefaults+KeyPaths.h"
#import "NSError+InfoAccess.h"
#import "NSBundle+HelperPaths.h"
#import "SSYOtherApper.h"
#import "NSFileManager+SomeMore.h"
#import "Syncer.h"
#import "NSDocumentController+MoreRecents.h"
#import "BkmxDoc.h"
#import "Client.h"
#import "Clientoid.h"
#import "Ixporter.h"
#import "NSNumber+SomeMore.h"
#import "NSString+SSYDotSuffix.h"
#import "SSYEventInfo.h"
#import "NSInvocation+Quick.h"
#import "NSArray+Stringing.h"
#import "NSError+MyDomain.h"
#import "BkmxAppDel.h"
#import "NSUserDefaults+MainApp.h"
#import "NSBundle+MainApp.h"
#import "NSUserDefaults+SSYOtherApps.h"
#import "Stager.h"
#import "Watch.h"
#import "Job.h"
#import "BkmxAgentAppDel.h"
#import "BkmxDocumentController.h"

NSString* const constKeyUninhibitorPid = @"pid" ;
NSString* const constKeyUninhibitorDate = @"date" ;


@implementation NSUserDefaults (Bkmx)

/* To securely unarchive a collection, you must specify a set of classes:
 containing (1) the class of the collection, (2) the class(es) of any
 descendant collection(s) of the the collection and (3) the class(es) of
 any descendant custom class(es) in the collection.
 https://stackoverflow.com/questions/52443649/unarchiving-encoded-data-returning-nil-and-incorrect-format
 In this case we have a set of Watches, so …
 */
+ (NSSet*)watchSetClasses {
    return [NSSet setWithObjects:
            [NSSet class],
            [Watch class],
            nil];
}

- (NSSet <Watch*>*)watchesThisApp {
	NSData* data  = [self syncAndGetMainAppValueForKey:constKeyWatches];
    if (![data isKindOfClass:[NSData class]]) {
        data = nil;
    }
    NSSet* watches = nil;
    if (data) {
        NSError* error =  nil;
        watches = [NSKeyedUnarchiver unarchivedObjectOfClasses:[[self class] watchSetClasses]
                                                      fromData:data
                                                         error:&error];
        if (error) {
            NSLog(@"Internal Error 234-4841, %@", error);
        }
    }
	// Check for corrupt prefs
    if (![watches respondsToSelector:@selector(member:)]) {
		watches = nil ;
	}
	return watches ;
}

- (NSSet <Watch*>*)watchesForApps:(BkmxWhichApps)whichApps {
    NSSet* appNames  = [[BkmxBasis sharedBasis] appNamesForApps:whichApps];
    NSMutableSet* watches = [NSMutableSet new];

    for (NSString* aAppName in appNames) {
        NSString* applicationId = [BkmxBasis appIdentifierForAppName:aAppName];
        NSData* data = [self syncAndGetValueForKey:constKeyWatches
                                     applicationId:applicationId];
        if (![data isKindOfClass:[NSData class]]) {
            data = nil;
        }
        NSSet* watchesForAnApp = nil;
        if (data) {
            NSError* error = nil;
            watchesForAnApp = [NSKeyedUnarchiver unarchivedObjectOfClasses:[[self class] watchSetClasses]
                                                                  fromData:data
                                                                     error:&error];
            if (error) {
                NSLog(@"Internal Error 243-5711 %@", error);
            }
        }
        // Check for corrupt prefs
        if (![watchesForAnApp respondsToSelector:@selector(member:)]) {
            watchesForAnApp = nil ;
        }
        
        for (Watch* watch in watchesForAnApp) {
            [watches addObject:watch];
        }
    }

    NSSet* answer = [watches copy];
    [watches release];
    [answer autorelease]; 

    return answer;
}

- (NSDictionary*)stagedJobArchivesForApps:(BkmxWhichApps)whichApps {
    NSSet* appNames  = [[BkmxBasis sharedBasis] appNamesForApps:whichApps];
    NSMutableDictionary* infos = [NSMutableDictionary new];

    for (NSString* aAppName in appNames) {
        NSString* applicationId = [BkmxBasis appIdentifierForAppName:aAppName];
        NSDictionary* infosFor1App = [self syncAndGetValueForKey:constKeyAgentStagings
                                                   applicationId:applicationId];
        if ([infosFor1App isKindOfClass:[NSDictionary class]]) {
            [infos addEntriesFromDictionary:infosFor1App];
        }
    }

    NSDictionary* answer = [infos copy];
    [infos release];
    [answer autorelease];

    return answer;
}

- (NSArray<Job*>*)stagedJobsForApps:(BkmxWhichApps)whichApps {
    NSMutableArray<Job*>* jobs = [NSMutableArray new];
    NSDictionary* stagedArchives = [self stagedJobArchivesForApps:(BkmxWhichApps)whichApps];
    // Ignore the keys, which are the syncerUuid of their Job value
    for (NSData* jobArchive in [stagedArchives allValues]) {
        if ([jobArchive isKindOfClass:[NSData class]]) {
            NSError* decodingError = nil;
            Job* job = [NSKeyedUnarchiver unarchivedObjectOfClass:[Job class]
                                                         fromData:jobArchive
                                                            error:&decodingError];
            if (decodingError) {
                decodingError = [SSYMakeError(constBkmxErrorDecodingAStagedJob, @"Error securely decoding a staged Job") errorByAddingUnderlyingError:decodingError];
                [[BkmxBasis sharedBasis] logError:decodingError
                                  markAsPresented:NO];
            }

            if ([job isKindOfClass:[Job class]]) {
                [jobs addObject:job];
            }
        }
    }

    NSArray<Job*>* answer = [jobs copy];
    [jobs release];
    [answer autorelease];

    return answer;
}

- (NSArray <Watch*>*)humanSortedWatchesForApps:(BkmxWhichApps)whichApps {
    NSSet* set = [self watchesForApps:whichApps];
    NSArray* array = [set allObjects];
    NSArray* sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(
                                                                                 Watch* watch1,
                                                                                 Watch* watch2) {
        return [watch1.humanReadableType compare:watch2.humanReadableType];
    }];
    return sortedArray;
}

- (void (^)(NSError *))finishRestartOfSyncWatches {
    return [(^void(NSError* error) {
        if (error) {
            NSError* restartError = error;
            BOOL ok = [[BkmxBasis sharedBasis] rebootSyncAgentReport_p:NULL
                                                               title_p:NULL
                                                               error_p:&error];
            if (ok) {
                error = [SSYMakeError(118747, @"Failed restarting sync watches, fixed by rebooting agent") errorByAddingUnderlyingError:error];
                // Just log it
                [[BkmxBasis sharedBasis] logError:error
                                  markAsPresented:NO];
                error = nil;
            } else {
                error = [[SSYMakeError(118748, @"Failed restarting sync watches, reboot failed too") errorByAddingUnderlyingError:error] errorByAddingUnderlyingError:restartError];
            }
            [[BkmxBasis sharedBasis] logError:error
                              markAsPresented:YES];
            [SSYAlert alertError:error];
        }
    }) copy];
}

- (void)probablyRestartSyncWatches {
    BkmxAppDel* appDelegate = (BkmxAppDel*)[NSApp delegate];
    NSAssert([appDelegate isKindOfClass:[BkmxAppDel class]], @"Agent should not be updating own status!");
    [appDelegate restartSyncWatchesThen:[self finishRestartOfSyncWatches]];
}

- (void)updateBkmxAgentServiceStatus_offOnly:(BOOL)offOnly {
    NSError* error = nil;
    if ([BkmxBasis sharedBasis].manualAgentRebootInProgress) {
        return;
    }
     if ([[BkmxBasis sharedBasis] isAMainAppWhichCanSync]) {
        BOOL needItRunning = [self watchesForApps:BkmxWhichAppsThis].count > 0;
        BOOL itIsRunning = [[BkmxBasis sharedBasis] runningAgents].count > 0;
        
        if (
            (needItRunning && !itIsRunning && !offOnly)
            ||
            (!needItRunning && itIsRunning)
            ) {
                /* Agent needs to be switched from OFF to ON or vice versa */
                KickType startOrStop = needItRunning ? KickType_Start : KickType_Stop ;
                [[BkmxBasis sharedBasis] kickBkmxAgentWithKickType:startOrStop
                                                             error:&error];
                
                if (error != nil) {
                    NSInteger code = needItRunning ? 582958 : 582957;
                    NSString* desc = [NSString stringWithFormat:
                                      @"Failed to switch BkmxAgent service %@",
                                      needItRunning ? @"ON" : @"OFF"];
                    error = [SSYMakeError(code, desc) errorByAddingUnderlyingError:error];
                    [[BkmxBasis sharedBasis] logError:error
                                      markAsPresented:YES];
                    /* We might be on a secondary thread here, for examole when called from
                     -[NSUserDefaults(Bkmx) forgetDefunctDocumentsWithWatchesAndEnDisableBkmxAgent_worker:]
                     SSYAlert requires main thread. */
                    [SSYAlert performSelectorOnMainThread:@selector(alertError:)
                                               withObject:error
                                            waitUntilDone:NO];
                }
            } else if (needItRunning && !offOnly) {
                /* Agent needs to be running and is already running. */
                
                /* We might be on a secondary thread here, for examole when called from
                 -[NSUserDefaults(Bkmx) forgetDefunctDocumentsWithWatchesAndEnDisableBkmxAgent_worker:]
                 SSYAlert requires main thread. */
                if ([[NSThread currentThread] isMainThread]) {
                    [self probablyRestartSyncWatches];
                } else {
                    [self performSelectorOnMainThread:@selector(probablyRestartSyncWatches)
                                           withObject:nil
                                        waitUntilDone:YES];
                }
            }
    } else if ([[BkmxBasis sharedBasis] isBkmxAgent]) {
        /* This can happen if BkmxAgent processes a serious error such as
         a Sync Fight and needs to switch off syncing.  BkmxAgent cannot
         switch itself off using SMLoginItemSetEnabled. */
        error = SSYMakeError(725340, @"Agent cannot update its own status");
        error = [error errorByAddingUserInfoObject:SSYDebugCaller()
                                            forKey:@"Caller"];
        [[BkmxBasis sharedBasis] logError:error
                          markAsPresented:NO];
    } else {
        /* Must be in Markster.  No-op. */
    }
}

/*!
 @details This method is typically called in main app, but may also be called
 in BkmxAgent if syncing is paused due to a Sync Fight detected.
 */
- (void)mutateWatchesAdditions:(NSSet <Watch*>*)additions
                     deletions:(NSSet <Watch*>*)deletions {
    NSMutableSet* watches = [[self watchesThisApp] mutableCopy];
    if (!watches) {
        watches = [NSMutableSet new];
    }

    [watches minusSet:deletions];
    [watches unionSet:additions];

    NSError* error = nil;
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:watches
                                         requiringSecureCoding:YES
                                                         error:&error];
    if (error) {
        NSLog(@"Internal Error 243-8361: %@", error);
    }

    [watches release];
    [self setAndSyncMainAppValue:data
                          forKey:constKeyWatches];
    [self synchronize];
    if ([[BkmxBasis sharedBasis] isAMainAppWhichCanSync]) {
        [self updateBkmxAgentServiceStatus_offOnly:NO];
    } else if ([[BkmxBasis sharedBasis] isBkmxAgent]) {
        /* This can happen if Agent detects a Sync Fight and pauses syncing.
         Agent cannot update its own service status (switch itself on or
         off, but it can re-realize watches.  If there are no watches any
         more, should remove all watches and run dormantly. */
        BkmxAgentAppDel* appDel = (BkmxAgentAppDel*)[NSApp delegate];
        [appDel loadAndRealizeWatches_errorCodes:nil];
    }
}

- (NSMutableSet*)uuidsOfDocsWithWatchesInApps:(BkmxWhichApps)whichApps {
	NSSet* watches = [self watchesForApps:whichApps] ;
	NSMutableSet* documentUuids = [NSMutableSet set] ;
	for (Watch* watch in watches) {
			// Guard against corrupt prefs.
			if ([watch respondsToSelector:@selector(docUuid)]) {
				NSString* documentUuid = watch.docUuid;
				// Guard against corrupt prefs.  Make sure documentUuid is a string
				if ([documentUuid isKindOfClass:[NSString class]]) {
					[documentUuids addObject:documentUuid] ;
			}
		}
	}
	
	return documentUuids ;
}

- (NSMutableSet*)uuidsOfDocsWithWatchesInThisApp {
    return [self uuidsOfDocsWithWatchesInApps:BkmxWhichAppsThis];
}

- (BOOL)removeWatchesForDocumentUuid:(NSString*)documentUuid {
    BOOL ok = YES;
	if (documentUuid) {
        NSSet* watches = [self watchesThisApp];
        NSMutableSet* watchesToRemove = [NSMutableSet new];
        for (Watch* watch in watches) {
            if ([watch.docUuid isEqualToString:documentUuid]) {
                [watchesToRemove addObject:watch];
            }
        }

        if (watchesToRemove.count > 0) {
            NSMutableSet* watchesMutant = [watches mutableCopy];
            [watchesMutant minusSet:watchesToRemove];
            NSError* error = nil;
            NSData* data = [NSKeyedArchiver archivedDataWithRootObject:watchesMutant
                                                 requiringSecureCoding:YES
                                                                 error:&error];
            if (error) {
                NSLog(@"Internal Error 244-8381: %@", error);
            }
            [watchesMutant release];
            [self setAndSyncMainAppValue:data
                                  forKey:constKeyWatches];

            [self updateBkmxAgentServiceStatus_offOnly:YES];
        }
        [watchesToRemove release];
    }

    return ok;
}

- (void)removeAllWatchesExceptDocUuid:(NSString*)docUuid {
    for (NSNumber* whichAppNumber in [[BkmxBasis sharedBasis] agentableAppWhichApps]) {
        BkmxWhichApps whichApp = (BkmxWhichApps)whichAppNumber.integerValue;
        NSSet<Watch*>* watches = [[NSUserDefaults standardUserDefaults] watchesForApps:whichApp];
        NSMutableSet* badWatches = [NSMutableSet new];
        NSMutableSet* goodWatches = [NSMutableSet new];
        for (Watch* watch in watches) {
            if (![docUuid isEqualToString:watch.docUuid]) { // always true if !docUuid
                [badWatches addObject:watch];
            } else {
                [goodWatches addObject:watch];
            }
        }
        
        if (badWatches.count > 0) {
            // It is easier to start from scratch
            //NSString* appName = [[BkmxBasis sharedBasis] appNameForApps:whichApp];
            NSString* bundleIdentifier = [[BkmxBasis sharedBasis] bundleIdentifiersForApps:whichApp].anyObject;
            [[NSUserDefaults standardUserDefaults] removeAndSyncKey:constKeyWatches
                                                      applicationId:bundleIdentifier];

            if (goodWatches.count > 0) {
                NSError* error = nil;
                NSData* data = [NSKeyedArchiver archivedDataWithRootObject:goodWatches
                                                     requiringSecureCoding:YES
                                                                     error:&error];
                if (error) {
                    NSLog(@"Internal Error 244-2387: %@", error);
                }

                [self setAndSyncValue:data
                               forKey:constKeyWatches
                        applicationId:bundleIdentifier];

                [self updateBkmxAgentServiceStatus_offOnly:YES];
            }
        } else {
            // Only one job, and it is good.  There is nothing to do.
        }
        [badWatches release];
        [goodWatches release];
    }
}

- (void)removeAllSyncingExceptDocUuid:(NSString*)docUuid {
    [self removeAllWatchesExceptDocUuid:docUuid];
    [Stager removeAllStagingsExceptDocUuid:docUuid];
    [(BkmxAppDel*)[NSApp delegate] removeAllSyncersExceptDocUuid:docUuid
                                               completionHandler:NULL];
    [self updateBkmxAgentServiceStatus_offOnly:YES];
}

- (void)forgetDocumentUuid:(NSString*)documentUuid {
    [self removeWatchesForDocumentUuid:documentUuid] ;
	[self removeAndSyncMainAppKey:documentUuid
              fromDictionaryAtKey:constKeyDocRecentDisplayNames] ;
	[self removeAndSyncMainAppKey:documentUuid
              fromDictionaryAtKey:constKeyDocAliasRecords] ;
	[self removeAndSyncMainAppKey:documentUuid
              fromDictionaryAtKey:constKeyDocAutosaves] ;
	// The following had been missing for awhile/???, added in BookMacster 1.2.6:
    [self removeAndSyncMainAppObject:documentUuid
                      fromArrayAtKey:constKeyDoOpenAfterLaunchUuids] ;
}

- (void)forgetDefunctDocumentsWithWatchesAndEnDisableBkmxAgent_worker {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
		
	NSSet* documentUuids = [self uuidsOfDocsWithWatchesInThisApp];

	// Note that we're going to populate two sets:
	NSMutableSet* defunctDocumentUuids = [[NSMutableSet alloc] init] ;
	NSMutableSet* defunctDocumentUrls = [NSMutableSet set] ;
	//
	NSDictionary* docAliasRecords = [self syncAndGetMainAppValueForKey:constKeyDocAliasRecords] ;
	for (NSString* documentUuid in documentUuids) {
		NSData* aliasRecord = [docAliasRecords objectForKey:documentUuid] ;
		NSString* path = [aliasRecord pathFromAliasRecordWithTimeout:10.0
														 error_p:NULL] ;
        if (path) {
            if (![[NSFileManager defaultManager] fileIsPermanentAtPath:path
                                                               error_p:NULL]) {
                [defunctDocumentUuids addObject:documentUuid] ;
                [defunctDocumentUrls addObject:[NSURL fileURLWithPath:path]] ;
            }
        }
        else {
            [defunctDocumentUuids addObject:documentUuid] ;
        }
	}
	
	if ([SSYEventInfo alternateKeyDown]) {
		if ([defunctDocumentUuids count] > 0) {
			NSString* msg = [NSString stringWithFormat:
							 @"When %@ launches, it checks your system for active %@ Syncers and makes sure that all of their associated Collection files still exist and are not trashed.  "
							 @"If it finds any with such defunct Collections, it removes their Syncers, and any other vestiges."
							 @"\n\n"
							 @"%@ just found %ld such defunct Collections, but it did not remove them because you were holding down the option/alternate key.  "
							 @"The identifiers of the defunct Collections are:"
							 @"\n\n"
							 @"%@",
                             [[BkmxBasis sharedBasis] appNameLocalized],
                             [[BkmxBasis sharedBasis] appNameLocalized],
                             [[BkmxBasis sharedBasis] appNameLocalized],
							 (long)[defunctDocumentUuids count],
							 [[defunctDocumentUuids allObjects] listValuesOnePerLineForKeyPath:nil]] ;
			[NSInvocation invokeOnMainThreadTarget:[SSYAlert class]
										  selector:@selector(runModalDialogTitle:message:buttonsArray:)
								   retainArguments:YES
									 waitUntilDone:NO
								 argumentAddresses:NULL, &msg, NULL] ;
		}
	}
    else {
        // Normal operation

        // Do three of the four things which are necessary to completely forget a document
        // The fourth thing, trashing local data files, will be done after
        // 62 days by -cleanOrphanedLocalData.
        for (NSString* defunctDocumentUuid in defunctDocumentUuids) {
            // First thing
            [self forgetDocumentUuid:defunctDocumentUuid];
            NSInteger length = defunctDocumentUuid.length;
            if (length > 4) {
                length = 4;
            }
            [[BkmxBasis sharedBasis] logFormat:@"Forgot-Doc-3 %@", [defunctDocumentUuid substringToIndex:length]] ;
            // Second thing
            [(BkmxAppDel*)[NSApp delegate] removeSyncersForDocumentUuid:defunctDocumentUuid] ;
        }

        for (NSURL* defunctDocumentUrl in defunctDocumentUrls) {
            // Third thing
            [[NSDocumentController sharedDocumentController] forgetRecentDocumentUrl:defunctDocumentUrl] ;
        }

        if ([[BkmxBasis sharedBasis] isAMainAppWhichCanSync]) {
            [self updateBkmxAgentServiceStatus_offOnly:YES];
            // We will also do the above when a document is opened, via -[BkmxDoc readFromURL:ofType:error:]
            // and -[BkmxDoc realizeSyncersToWatchesError_p:].  So this is redundant whenever a document
            // is opened, but it's not redundant if a document is not opened.
        }
    }

    [defunctDocumentUuids release] ;
	[pool release] ;
}

- (void)forgetDefunctDocumentsWithWatchesAndEnDisableBkmxAgent {
	[NSThread detachNewThreadSelector:@selector(forgetDefunctDocumentsWithWatchesAndEnDisableBkmxAgent_worker)
							 toTarget:self
						   withObject:nil] ;
}

- (NSDate*)recentQuitForAppIdentifier:(NSString*)bundleIdentifier {
    NSDictionary* recentQuits = [self syncAndGetMainAppValueForKey:constKeyRecentQuits];
    NSDate* date = [recentQuits objectForKey:bundleIdentifier];
    if (![date isKindOfClass:[NSDate class]]) {
        date = nil;
    }

    return date;
}

- (void)setRecentQuitToNowForAppIdentifier:(NSString*)bundleIdentifier {
    NSMutableDictionary* recentQuits = [[self syncAndGetMainAppValueForKey:constKeyRecentQuits] mutableCopy];
    if (!recentQuits) {
        recentQuits = [NSMutableDictionary new];
    }
    [recentQuits setObject:[NSDate date]
                    forKey:bundleIdentifier];
    [self setAndSyncMainAppValue:recentQuits
                          forKey:constKeyRecentQuits];
    [recentQuits release];
}

- (NSDate*)lastChangeWrittenDateToClientoid:(Clientoid*)clientoid {
	NSArray* keyPathArray = [NSArray arrayWithObjects:
							 constKeyClientsLastChangeWrittenDate,
							 [clientoid clidentifier],
							 nil] ;
	return [self syncAndGetMainAppValueForKeyPathArray:keyPathArray] ;
}

- (void)setLastChangeWrittenDate:(NSDate*)date
						toClient:(Client*)client {
	Exporter* exporter = [client exporter] ;
	[exporter setIxportCount:[[exporter ixportCount] plus1]] ;
	
	// The following save is needed when user begins to close a document
	// with a new Export Client that had never been exported to,
	// and then clicks *Export and Close* in response to the warning of
	// that.  It's probably redundant for a normal export but oh well.
	NSString* uuid = [[[client macster] bkmxDoc] uuid] ;
	// The above [[client macster] bkmxDoc] is
	// OK because, even if there are multiple BkmxDocs open on the same
	// store file, they should have the same uuid in their shig
	[[BkmxBasis sharedBasis] saveSettingsMocForIdentifier:uuid] ;
	
	NSArray* keyPathArray = [NSArray arrayWithObjects:
							 constKeyClientsLastChangeWrittenDate,
							 [[client clientoid] clidentifier],
							 nil] ;
	[self setAndSyncMainAppValue:date
                 forKeyPathArray:keyPathArray] ;
}

- (NSNumber*)lastImportPreHashForClientoid:(Clientoid*)clientoid {
    NSArray* keyPathArray = [NSArray arrayWithObjects:
                             constKeyClientsLastImportPreHash,
                             [clientoid clidentifier],
                             nil] ;
    return [self syncAndGetMainAppValueForKeyPathArray:keyPathArray] ;
}

- (void)setLastImportPreHash:(NSNumber*)hash
                clidentifier:(NSString*)clidentifier {
    if (clidentifier) {
        if (hash) {
            NSArray* keyPathArray = [NSArray arrayWithObjects:
                                     constKeyClientsLastImportPreHash,
                                     clidentifier,
                                     nil] ;
            [self setAndSyncMainAppValue:hash
                         forKeyPathArray:keyPathArray] ;
        } else {
            [self removeAndSyncMainAppKey:clidentifier
             fromDictionaryAtKeyPathArray:@[constKeyClientsLastImportPreHash]];
        }
    }
}

- (NSNumber*)lastImportPostHashForClientoid:(Clientoid*)clientoid {
    NSArray* keyPathArray = [NSArray arrayWithObjects:
                             constKeyClientsLastImportPostHash,
                             [clientoid clidentifier],
                             nil] ;
    return [self syncAndGetMainAppValueForKeyPathArray:keyPathArray] ;
}

- (void)setLastImportPostHash:(NSNumber*)hash
                 clidentifier:(NSString*)clidentifier {
    if (clidentifier) {
        if (hash) {
            NSArray* keyPathArray = [NSArray arrayWithObjects:
                                     constKeyClientsLastImportPostHash,
                                     clidentifier,
                                     nil] ;
            [self setAndSyncMainAppValue:hash
                         forKeyPathArray:keyPathArray];
        } else {
            [self removeAndSyncMainAppKey:clidentifier
             fromDictionaryAtKeyPathArray:@[constKeyClientsLastImportPostHash]];
        }
    }
}

- (NSNumber*)lastExportPreHashForClientoid:(Clientoid*)clientoid {
    NSArray* keyPathArray = [NSArray arrayWithObjects:
                             constKeyClientsLastExportPreHash,
                             [clientoid clidentifier],
                             nil] ;
    return [self syncAndGetMainAppValueForKeyPathArray:keyPathArray] ;
}

- (void)setLastExportPreHash:(NSNumber*)hash
                clidentifier:(NSString*)clidentifier {
    if (clidentifier) {
        if (hash) {
            NSArray* keyPathArray = [NSArray arrayWithObjects:
                                     constKeyClientsLastExportPreHash,
                                     clidentifier,
                                     nil] ;
            [self setAndSyncMainAppValue:hash
                         forKeyPathArray:keyPathArray] ;
        } else {
            [self removeAndSyncMainAppKey:clidentifier
             fromDictionaryAtKeyPathArray:@[constKeyClientsLastExportPreHash]];
        }
    }
}

- (NSNumber*)lastExportPostHashForClientoid:(Clientoid*)clientoid {
    NSArray* keyPathArray = [NSArray arrayWithObjects:
                             constKeyClientsLastExportPostHash,
                             [clientoid clidentifier],
                             nil] ;
    return [self syncAndGetMainAppValueForKeyPathArray:keyPathArray] ;
}

- (void)setLastExportPostHash:(NSNumber*)hash
                 clidentifier:(NSString*)clidentifier {
    if (clidentifier) {
        if (hash) {
            NSArray* keyPathArray = [NSArray arrayWithObjects:
                                     constKeyClientsLastExportPostHash,
                                     clidentifier,
                                     nil] ;
            [self setAndSyncMainAppValue:hash
                         forKeyPathArray:keyPathArray] ;
        } else {
            [self removeAndSyncMainAppKey:clidentifier
             fromDictionaryAtKeyPathArray:@[constKeyClientsLastExportPostHash]];
        }
    }
}

- (uint32_t)compositeImportSettingsHashForClientoid:(Clientoid*)clientoid {
    NSArray* keyPathArray = [NSArray arrayWithObjects:
                             constKeyCompositeImportSettingsHash,
                             [clientoid clidentifier],
                             nil] ;
    return (uint32_t)[[self syncAndGetMainAppValueForKeyPathArray:keyPathArray] integerValue] ;
}

- (void)setCompositeImportSettingsHash:(uint32_t)hash
                             clientoid:(Clientoid*)clientoid {
    if (hash) {
        NSArray* keyPathArray = [NSArray arrayWithObjects:
                                 constKeyCompositeImportSettingsHash,
                                 [clientoid clidentifier],
                                 nil] ;
        [self setAndSyncMainAppValue:@(hash)
                     forKeyPathArray:keyPathArray] ;
    } else {
        [self removeAndSyncMainAppKey:clientoid.clidentifier
         fromDictionaryAtKeyPathArray:@[constKeyCompositeImportSettingsHash]];
    }
}

- (void)updatePreHashWithExtoreContentHash:(uint32_t)currentContentHash
                                 jobSerial:(NSInteger)jobSerial
                                 moreLabel:(NSString*)moreLabel
                                 clientoid:(Clientoid*)clientoid {
    NSString* clidentifier = clientoid.clidentifier;
    if (clidentifier) {
        uint32_t compositeSettingsHash = [self compositeImportSettingsHashForClientoid:clientoid];
        uint32_t bottom = currentContentHash ^ compositeSettingsHash;
        uint64_t oldHash = [[self lastImportPreHashForClientoid:clientoid] unsignedLongLongValue];
        uint64_t newHash = (oldHash & 0xffffffff00000000) + bottom;
        [self setLastImportPreHash:[NSNumber numberWithUnsignedLongLong:newHash]
                      clidentifier:clidentifier];
        NSString* msg = [NSString stringWithFormat:
                         @"%@: Updated lastImportPreHash for %@  was:%016qx  now:%016qx",
                         moreLabel,
                         clientoid.displayName,
                         oldHash,
                         newHash
                         ];
        [[BkmxBasis sharedBasis] forJobSerial:jobSerial
                                    logFormat:msg];
    }
}

- (NSDate*)generalUninhibitDate {
	NSDictionary* record = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppValueForKey:constKeyGeneralUninhibitDate] ;
	if (!record) {
		return [NSDate distantPast] ;
	}

	// As always, we never trust what might be found in user defaults.
	if ([record respondsToSelector:@selector(objectForKey:)]) {
		NSNumber* pidNumber = [record objectForKey:constKeyUninhibitorPid] ;
		if ([pidNumber respondsToSelector:@selector(integerValue)]) {
			int inhibitingPid = (int)[pidNumber integerValue] ;
			BOOL isStillRunning = [SSYOtherApper isProcessRunningPid:inhibitingPid
														thisUserOnly:NO] ;
			if (isStillRunning) {
				NSDate* date = [record objectForKey:constKeyUninhibitorDate] ;
				if ([date isKindOfClass:[NSDate class]]) {
					return date ;
				}
			}
		}
		else {
			NSLog(@"Warning 725-5510  Corrupt prefs record: %@", record) ;
			// Ignore and return distantPast
		}
	}
	else {
		NSLog(@"Warning 746-0074  Corrupt, or pre-Bkmxtr-1.1.12 prefs record: %@", record) ;
		// Prefs are corrupt, or were written by version prior to
		// BookMacster 1.1.12, when this value was a date.
		// Ignore and return distantPast
	}
	
	return [NSDate distantPast] ;
}

- (void)setGeneralUninhibitDate:(NSDate*)date {
	NSNumber* pidNumber = [NSNumber numberWithInteger:[[NSProcessInfo processInfo] processIdentifier]] ;
	NSDictionary* record = [NSDictionary dictionaryWithObjectsAndKeys:
							date, constKeyUninhibitorDate,
							pidNumber, constKeyUninhibitorPid,
							nil] ;
	[[NSUserDefaults standardUserDefaults] setAndSyncMainAppValue:record
                                                           forKey:constKeyGeneralUninhibitDate] ;
}

- (NSDate*)uninhibitDateForTriggerCause:(NSString*)triggerCause {
    NSDate* answer = nil;
    NSDictionary* dates = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppValueForKey:constKeyUninhibitDatesPerTriggerCause];
    if ([dates respondsToSelector:@selector(objectForKey:)]) {
        answer = [dates objectForKey:triggerCause];
        if (![answer isKindOfClass:[NSDate class]]) {
            answer = nil;
        }
    }

    return answer;
}

- (void)setUninhibitDate:(NSDate*)uninhibitDate
         forTriggerCause:(NSString*)triggerCause {
    [[NSUserDefaults standardUserDefaults] setAndSyncMainAppValue:uninhibitDate
                                                  forKeyPathArray:@[constKeyUninhibitDatesPerTriggerCause, triggerCause]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray*)docUuidsToOpenAfterLaunch {
	NSArray* answer = [self syncAndGetMainAppValueForKey:constKeyDoOpenAfterLaunchUuids] ;
	if (![answer isKindOfClass:[NSArray class]]) {
		answer = nil ;
	}
	
	return answer ;
}

- (BOOL)doOpenAfterLaunchDocUuid:(NSString*)uuid {
	NSArray* uuids = [self docUuidsToOpenAfterLaunch] ;
	// The following was added to fix bug in BookMacster 1.2.6…
	if (!uuids) {
		return NO ;
	}

	return ([uuids indexOfObject:uuid] != NSNotFound) ;
}

- (void)setDoOpenAfterLaunch:(BOOL)yn
					 docUuid:(NSString*)uuid {
#if 0
#warning No document will be set to open after launch
	yn = NO ;
#endif
	if (yn) {
		[self addUniqueObject:uuid
				 toArrayAtKey:constKeyDoOpenAfterLaunchUuids] ;
	}
	else {
		[self removeObject:uuid
			fromArrayAtKey:constKeyDoOpenAfterLaunchUuids] ;
	}
}

- (NSString*)displayNameForDocumentUuid:(NSString*)uuid {
	NSArray* keyPathArray = [NSArray arrayWithObjects:
							 constKeyDocRecentDisplayNames,
							 uuid,
							 nil] ;
	return [self syncAndGetMainAppValueForKeyPathArray:keyPathArray] ;
}

- (NSInteger)syncSnapshotsLimitMB {
    NSNumber* syncSnapshotsPref = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppValueForKey:constKeySyncSnapshotsLimitMB] ;
    NSInteger syncSnapshotsValue = 0 ;
    if ([syncSnapshotsPref respondsToSelector:@selector(integerValue)]) {
        syncSnapshotsValue = [syncSnapshotsPref integerValue] ;
    }
    
    return syncSnapshotsValue ;
}

- (void)setSyncSnapshotsLimitMB:(NSInteger)value {
    if (value > SNAPSHOT_MAX_LIMIT_MB) {
        value = SNAPSHOT_MAX_LIMIT_MB;
    }
    NSNumber* number = [NSNumber numberWithInteger:value] ;
    [[NSUserDefaults standardUserDefaults] setAndSyncMainAppValue:number
                                                           forKey:constKeySyncSnapshotsLimitMB] ;
    [[BkmxBasis sharedBasis] logFormat:
     @"Set Sync Snapshots Limit to %d MB",
     value] ;
}

- (NSArray*)defaultQuickSearchParmsForKey:(NSString*)key {
    // Use defaults (which are default defaults but could be a hidden preference)
    
    // A more elegant solution would be to register defaults in the registration domain,
    // using -[NSUserDefaults registerDefaults:] in -[BkmxDocWinCon awakeFromNib].
    // However, this would be messy and maybe not even possible
    // because of the way we have structured the autosave dictionary, with the
    // children of root being the document UUIDs.
    
    NSArray* keyPathArray = [NSArray arrayWithObjects:
                             constKeyQuickSearchParms,
                             key,
                             nil] ;
    NSArray* array = [[NSUserDefaults standardUserDefaults] valueForKeyPathArray:keyPathArray] ;
    
    return array ;
}

- (NSInteger)nextJobSerialforCreator:(NSString*)creator {
    NSInteger serialValue = [[[NSUserDefaults standardUserDefaults] syncAndGetMainAppValueForKey:constKeyLastJobSerial] integerValue];
    serialValue++;
    if (serialValue >= 10000) {
        serialValue -= 10000;

        /* But Serial 0 may be reserved for "no job". */
        if (serialValue == 0) {
            serialValue = 1;
        }
    }
    [[NSUserDefaults standardUserDefaults] setAndSyncMainAppValue:@(serialValue)
                                                           forKey:constKeyLastJobSerial];

    [[BkmxBasis sharedBasis] forJobSerial:serialValue
                                logFormat:
     @"Created for %@",
     creator];

    return serialValue;
}


@end
