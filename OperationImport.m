#import "OperationImport.h"
#import "Operation_Common.h"
#import "Extore.h"
#import "Importer.h"
#import "Client.h"
#import "SSYProgressView.h"
#import "BkmxDoc.h"
#import "Chaker.h"
#import "Bookshig.h"
#import "Starker.h"
#import "BkmxBasis+Strings.h"
#import "NSDictionary+SimpleMutations.h"
#import "Stark+LegacyArtifacts.h"
#import "NSArray+Stringing.h"
#import "StarkTableColumn.h"
#import "BkmxDocWinCon.h"
#import "Gulper.h"
#import "GulperImportDelegate.h"
#import "NSObject+MoreDescriptions.h"
#import "Job.h"
#import "NSUserDefaults+Bkmx.h"

// Depracated Item Property Keys  These were abbreviated since they actually were written to user defaults.
#define K_ALLOWED_DUPE @"AD"  // Boolean YES (should never be NO but handle NO anyhow)
#define K_FALSE_ALARM @"FA"  // Boolean YES (should never be NO but handle NO anyhow)
#define K_SORTABLE @"S"  // Boolean YES or NO
#define K_SAFARI_SEPARATOR @"SS"  // Boolean YES (should never be NO but handle NO anyhow)
#define K_SAFARI_COMMENTS @"SC"  // String
#define K_SAFARI_SHORTCUT @"SK"  // String

#define LEGACY_ITEM_ID_FINDS         @"LegacyItemIDFinds"
#define LEGACY_ITEM_ID_FIND_DATE     @"LegacyItemIDFindDate"
#define LEGACY_ITEM_ID_NUMBER_FOUND  @"LegacyItemIDNumberFound"


@implementation SSYOperation (OperationImport)

- (void)prepareBrowserForImport {
	[self prepareLock] ;
	[self doSafely:_cmd] ;	
	[self blockForLock] ;
}

- (void)prepareBrowserForImport_unsafe {
	[self lockLock] ;
	// The following creates a temporary retain cycle, because this Operation
	// (self) owns its info, and now we are putting self into the info,
	// so that info will own self.  This retain cycle must be broken by
	// removing the value for constKeyIsDoneTarget when it is no longer
	// needed, and this is done in -[Extore sendIsDoneMessageFromInfo:].
	[[self info] setObject:self
					forKey:constKeyIsDoneTarget] ;
	
	NSString* doneSelectorName = @"prepareBrowserForImportIsDoneInfo:" ;
	[[self info] setObject:doneSelectorName
					forKey:constKeyIsDoneSelectorName] ;

	Extore* extore = [[self info] objectForKey:constKeyExtore] ;
	
    [extore doBackupLabel:@"PreIm"] ;
    
	// The following must eventually invoke -[Extore sendIsDoneMessageFromInfo:]
	// in order to break the temporary retain cycle created above.  It was quite
	// circuitous with ExtoreGoogle!
	[extore prepareBrowserForImportWithInfo:[self info]] ;    
}


- (void)prepareBrowserForImportIsDoneInfo:(NSMutableDictionary*)info {	
	if (![[[self info] objectForKey:constKeySucceeded] boolValue]) {
		NSError* error = [[self info] objectForKey:constKeyError] ;
		[self setError:error] ;

		// See Note 520948…
		[self skipNoncleanupOperationsInOtherGroups] ;
	}
	
	[self unlockLock] ;
}

- (void)checkIfExternalChanged {
	if ([[[self info] objectForKey:constKeyIfNotNeeded] boolValue]) {
		// We must do this import.
		return ;
	}
	
	[self doSafely:_cmd] ;
}

- (void)checkIfExternalChanged_unsafe {
	Extore* extore = [[self info] objectForKey:constKeyExtore] ;
	Client* client = [extore client] ;
	BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument] ;

	// We must do the import if this is a local app with a local addon
	// that can do import.  This is because we assume that the app
	// can make changes to bookmarks without modifying its bookmarks file.
	// (Someday, we might monitor the app for bookmarks changes and then
	// this would not necessarily be true.  We could check the browser's
	// actual internal modification date.)
	if (([extore ownerAppIsLocalApp]) && ([extore addonSupportsPurpose:constExtensibilityImport])) {
		// We must do this import.
		return ;
	}
	// The above section could probably go in -checkIfExternalChanged,
	// because I don't think any Core Data access is involved.  But
	// I do it in here for defensive programming.
	
	// Get lastKnownTouch as last known internal or external touch,
	// whichever is later.
	NSDate* lastKnownTouch = [extore lastDateExternalWasTouched] ;
	if (!lastKnownTouch) {
		// This is not an expected error. -lastDateExternalWasTouched should
		// always return something
		[self setError:[extore error]] ;
		
		// See Note 520948…
		[self skipNoncleanupOperationsInOtherGroups] ;
		
		return ;
	}

	NSDate* lastKnownInternalTouch = [[bkmxDoc shig] lastTouched] ;
	if (lastKnownInternalTouch) {
		lastKnownTouch = [lastKnownInternalTouch laterDate:lastKnownTouch] ;
	}
	
	NSDate* lastImported = [bkmxDoc lastImportedDateForClient:client] ;
	if (lastImported) {
		if ([lastKnownTouch compare:lastImported] != NSOrderedDescending) {
            uint32_t compositeSettingsHash = [[NSUserDefaults standardUserDefaults] compositeImportSettingsHashForClientoid:client.clientoid] ;
			uint32_t currentHash = [bkmxDoc contentHash] ^ compositeSettingsHash ;
			uint32_t priorHash = (uint32_t)[[bkmxDoc lastPreImportedHashForClient:client
															   whichPart:BkmxDocHashPartBkmxDoc] unsignedLongValue] ;
			
			if(currentHash == priorHash) {
				// Neither external file, nor bkmxDoc content, nor importer settings, nor macster's
				// importer settings (Import Postprocessing) have changed since the last import.
				// Skip the import.
				[[self info] setObject:[NSNumber numberWithBool:YES]
								forKey:constKeySkipImportNoChanges] ;
			}
		}
	}
}

- (void)tweakImportForClient {
    if ([[self info] objectForKey:constKeySkipImportNoChanges]) {
        return;
    }

    // Defensive programming
    if (![[[self info] objectForKey:constKeyDidReadExternal] boolValue]) {
        NSLog(@"Internal Error 550-7655");
        return;
    }

    [self doSafely:_cmd];
}

- (void)tweakImportForClient_unsafe {
    @autoreleasepool {
        Extore* extore = [[self info] objectForKey:constKeyExtore];
        [extore tweakImport];
    }
}

- (void)mergeImport {
	if ([[self info] objectForKey:constKeySkipImportNoChanges]) {
		return ;
	}
	
	// Defensive programming added in BookMacster 1.11.2
	if (![[[self info] objectForKey:constKeyDidReadExternal] boolValue]) {
        NSLog(@"Internal Error 550-7624") ;
        /* Warning: Don't use [[self info] shortDescription] here because we
         are not on the main thread and info contains Core Data objects. */
        return ;
	}
	
	[self doSafely:_cmd] ;
}

- (void)mergeImport_unsafe {
	Ixporter* importer = [[self info] objectForKey:constKeyIxporter] ;
    BkmxDoc* bkmxDoc = [self.info objectForKey:constKeyDocument];
	NSError* error = nil ;
	
	BOOL ok = [importer mergeFromStartainer:importer
							   toStartainer:bkmxDoc
									   info:[self info]
									error_p:&error] ;
	if (!ok) {
		[self setError:error] ;

		// See Note 520948…
		[self skipNoncleanupOperationsInOtherGroups] ;
	}
}

- (void)gulpImport {
	if ([[self info] objectForKey:constKeySkipImportNoChanges]) {
		return ;
	}

	[self doSafely:_cmd] ;
}

- (void)gulpImport_unsafe {	
	BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument] ;
	if ([[bkmxDoc importedExtores] count] > 0) {
		NSError* error = nil ;
		
		GulperImportDelegate* gulperImportDelegate = [[GulperImportDelegate alloc] initWithBkmxDoc:bkmxDoc] ;
		Gulper* gulper = [[Gulper alloc] initWithDelegate:gulperImportDelegate] ;
		
		BOOL ok = [gulper gulpStartainer:bkmxDoc
                                    info:[self info]
                                 error_p:&error] ;
		if (!ok) {
			[self setError:error] ;
			
			// See Note 520948…
			[self skipNoncleanupOperationsInOtherGroups] ;
		}
		
		[gulperImportDelegate release] ;
		[gulper release] ;
	}
}

// Cannot run in arbitrary thread since NSUndoManager is not thread safe.
- (void)showCompletionImported {
	if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
		[self doSafely:_cmd] ;
	}
}

- (void)showCompletionImported_unsafe {
	BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument] ;

	// Is last client in this import
	SSYProgressView* progressView = [bkmxDoc progressView] ;
	NSArray* importersDone = [bkmxDoc successfulIxporters] ;
	NSString* displayNames = [[importersDone valueForKey:constKeyClient] listValuesForKey:@"displayName"
																			  conjunction:nil
																			   truncateTo:0] ;
	NSString* verb = [NSString stringWithFormat:
					  @"%@ %C %@",  // Used symbol since "Import Safari" may not be correct for non-English
					  [[BkmxBasis sharedBasis] labelImport],
					  (unsigned short)0x2190, // left-pointing arrow
					  displayNames] ;
	NSString* result = [[bkmxDoc chaker] displayStatistics] ;
	[progressView showCompletionVerb:verb
                              result:result
                            priority:SSYProgressPriorityRegular] ;
}

- (void)checkImportHashIsDiff {
	if ([[[self info] objectForKey:constKeyIfNotNeeded] boolValue]) {
        /* Import regardless of import hash */
    } else {
        /* Only import if import hash is different */
        [self doSafely:_cmd] ;
    }    
}

- (void)checkImportHashIsDiff_unsafe {
	Extore* extore = [[self info] objectForKey:constKeyExtore] ;
    if (![extore hashCoversAllAttributesInCurrentStyle]) {
        NSString* msg = [NSString stringWithFormat:
                         @"ICHID: Not full hash coverage for %@ style %ld \u279e Skip test",
                         [extore displayName],
                         extore.ixportStyle];
        [[BkmxBasis sharedBasis] logFormat:msg];
    } else {
        Client* client = [extore client] ;
        BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument] ;

        NSNumber* oldHashNumber = [bkmxDoc lastPostImportedHashForClient:client
                                                               whichPart:BkmxDocHashPartsBoth] ;
        if (oldHashNumber) {
            Client* client = [extore client] ;
            uint32_t compositeSettingsHash = [[NSUserDefaults standardUserDefaults] compositeImportSettingsHashForClientoid:client.clientoid] ;
            uint32_t bkmxDocContentHash = [bkmxDoc contentHash] ;
            uint32_t currentContentHash = [extore contentHash];

            uint32_t newHashBottom = currentContentHash ^ compositeSettingsHash ;
            uint32_t newHashTop    =  bkmxDocContentHash ^ compositeSettingsHash ;
            // Above, newHashTop, until BookMacster 1.11 the "^ compositeSettingsHash" was missing (Bug 3540345)
            unsigned long long newHash = ((unsigned long long)newHashTop << 32) + newHashBottom ;

            uint64_t oldHash = [oldHashNumber unsignedLongLongValue];

            NSString* msg;
#if DEBUG
            msg = [NSString stringWithFormat:
                   @"ICHID: old=%016qx new=%016qx)",
                   oldHash,
                   newHash];
            [[BkmxBasis sharedBasis] logFormat:msg];
#endif
            if (oldHash == newHash) {
                msg = [NSString stringWithFormat:
                       @"ICHID: Same hash \u279e Skip import %@",
                       [client displayName]] ;
                [[BkmxBasis sharedBasis] logFormat:msg] ;

                [[BkmxBasis sharedBasis] trace:msg] ;
                [[BkmxBasis sharedBasis] trace:@"\n"] ;

                [[self info] setObject:[NSNumber numberWithBool:YES]
                                forKey:constKeySkipImportNoChanges] ;
            } else {
                Job* job = [[self info] objectForKey:constKeyJob];
                [[NSUserDefaults standardUserDefaults] updatePreHashWithExtoreContentHash:currentContentHash
                                                                                jobSerial:job.serial
                                                                                moreLabel:@"ICHID"
                                                                                clientoid:client.clientoid];

                msg = [NSString stringWithFormat:
                       @"ICHID: Diff hash \u279e Shall import %@",
                       [client displayName]];
                [[BkmxBasis sharedBasis] logFormat:msg];
            }
        }
    }
}

- (void)rememberImportHash {
	[self doSafely:_cmd] ;
}

- (void)rememberImportHash_unsafe {
	Extore* extore = [[self info] objectForKey:constKeyExtore] ;
	BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument] ;

	if ([[[self info] objectForKey:constKeyDidReadExternal] boolValue]) {
        [bkmxDoc rememberBothLastImportedHashForExtore:extore];
	}
	else {
		// Because of no readExternal, extore's starker consists of a root only,
		// This is definitely not something we want to remember,
		// especially since this will cause a Whoops! hash
		// mismatch during -[OperationExport checkImportHashIsSame_unsafe],
		// which would cause redo sync operations until infinity!
	}
}

/*
 - (void)template {
 NSError* error = nil ;
 Extore* extore = [[self info] objectForKey:constKeyExtore] ;
 BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument] ;
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
