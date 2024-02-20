#import "OperationClearUndo.h"
#import "Operation_Common.h"
#import "NSError+MyDomain.h"
#import "BkmxDoc.h"
#import "Chaker.h"
#import "Extore.h"
#import "Starker.h"
#import "NSString+LocalizeSSY.h"
#import "NSString+VarArgs.h"
#import "BkmxBasis+Strings.h"
#import "NSError+InfoAccess.h"
#import "Bookshig.h"
#import "Exporter.h"
#import "Client.h"
#import "Job.h"
#import "Macster.h"
#import "NSInvocation+Quick.h"
#import "NSDictionary+KeyPaths.h"
#import "NSNumber+SomeMore.h"
#import "NSError+Recovery.h"
#import "NSDocumentController+DisambiguateForUTI.h"
#import "SSYMH.AppAnchors.h"
#import "NSUserDefaults+MainApp.h"
#import "NSNumber+NoLimit.h"
#import "NSError+MyDomain.h"
#import "NSObject+MoreDescriptions.h"


@implementation SSYOperation (OperationIxportLimits)

- (void)clearForIxport {	
	[self doSafely:_cmd] ;
}

- (void)clearForIxport_unsafe {
	NSMutableDictionary* info = [self info] ;
	Ixporter* ixporter = [info objectForKey:constKeyIxporter] ;
	BkmxDoc* bkmxDoc = [info objectForKey:constKeyDocument] ;
	if (!bkmxDoc) {
		NSLog(@"Internal Error 208-9593") ;
	}
	BOOL beginningProduct = (
							 [ixporter isAnExporter]
							 ||
                             /* The following is smarter than looking at the index
                              of this job, because it ignores any previous imports
                              which were skipped due to, for example, no change
                              in import hash.  In other words, it is YES if this
                              is the first *executed* import. */
							 ([[bkmxDoc starker] destinees] ==  nil)
							 ) ;
	if (beginningProduct) {
		[[bkmxDoc chaker] begin] ;
		[bkmxDoc clearSuccessfulIxporters] ;
	}
}

- (void)limitSafe {
	NSMutableDictionary* info = [self info] ;
	BOOL ignoreLimit = [[info objectForKey:constKeyIgnoreLimit] boolValue] ;

	if (ignoreLimit) {
		// This may happen if an importer's client willIgnoreLimit, or if the
		// user has clicked "IgnoreLimit" in attemptRecoveryFromError:::::
		return ;
	}
	
	[self prepareLock] ;
	[self doSafely:_cmd] ;
	[self blockForLock] ;
}

- (void)limitSafeIsDone {
	[self unlockLock] ;
}

- (void)limitSafe_unsafe {
	[self lockLock] ;

	NSMutableDictionary* info = [self info] ;
	
    BkmxDoc* bkmxDoc = [info objectForKey:constKeyDocument];
	Ixporter* ixporter = [info objectForKey:constKeyIxporter] ;
	
	SSYModelChangeCounts changeCounts = [[bkmxDoc chaker] changeCounts] ;
	/* We ignore .slides, .moves, and (since BkmkMgrs 2.3) .updated. */
	uint32_t totalChangeCount = (uint32_t)(changeCounts.added + changeCounts.deleted) ;

	int32_t limit ;
	NSString* operationName = nil ;
	NSString* targetName = nil ;
    
	// If this is an Import operation, this method should only run after
	// importing the last Client/Importer.  So the following if() is
	// checking only the nature of the last Client.  However, since we
	// don't mix imports and exports in the same operation, that suffices.
	if ([[ixporter client] willIgnoreLimit]) {
		// This may happen for exporters only ???
		limit = BKMX_NO_LIMIT ;
	}
	else if ([ixporter isAnImporter]) {
		// The operation was an Import
		if ([[[bkmxDoc shig] importCount] integerValue] == 0) {
			limit = BKMX_NO_LIMIT ;
		}
		else {
			switch ([[BkmxBasis sharedBasis] iAm]) {
                case BkmxWhich1AppSmarky:
                case BkmxWhich1AppSynkmark:
                    limit = (uint32_t)[[NSUserDefaults standardUserDefaults] syncAndGetMainAppIntegerForKey:constKeyShoeboxSafeSyncLimit] ;
                    // See Note UnsignedLimit below.
                    break ;
                case BkmxWhich1AppMarkster:
                    limit = BKMX_NO_LIMIT ;
                    break ;
                case BkmxWhich1AppBookMacster:
                    limit = (uint32_t)[[[bkmxDoc macster] safeLimitImport] integerValue] ;
                    break ;
            }
			operationName = [[BkmxBasis sharedBasis] labelImport] ;
			targetName = [bkmxDoc displayName] ;
		}
		
		// Added in BookMacster 1.11.
		// Set import count for next time.
		if (totalChangeCount > 0) {
            NSNumber* newImportCount = [[[bkmxDoc shig] importCount] plus1] ;
			[[bkmxDoc shig] setImportCount:newImportCount] ;
		}
	}
	else {
		// The operation was an Export
		if ([[ixporter ixportCount] integerValue] == 0) {
			limit = BKMX_NO_LIMIT ;
		}
		else {
			switch ([[BkmxBasis sharedBasis] iAm]) {
                case BkmxWhich1AppSmarky:
                case BkmxWhich1AppSynkmark:
                    limit = (uint32_t)[[NSUserDefaults standardUserDefaults] syncAndGetMainAppIntegerForKey:constKeyShoeboxSafeSyncLimit] ;
                    // See Note UnsignedLimit below.
                    break ;
                case BkmxWhich1AppMarkster:
                    limit = BKMX_NO_LIMIT ;
                    break ;
                case BkmxWhich1AppBookMacster:
                    limit = (uint32_t)[[(Exporter*)ixporter safeLimit] integerValue] ;
                    break ;
            }
			operationName = [[BkmxBasis sharedBasis] labelExport] ;
			targetName = [[ixporter client] displayName] ;
		}
	}

	if (totalChangeCount > limit) {
		NSString* logMessage = [NSString stringWithFormat:
								@"+%ld \u0394%ld -%ld exceeded %@ Safe Limit of %ld",
								(long)changeCounts.added,
								(long)changeCounts.updated,
								(long)changeCounts.deleted,
								operationName,
								(long)limit] ;
		[[BkmxBasis sharedBasis] logFormat:logMessage] ;
		if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
			if ([ixporter isAnImporter]) {
				// Main App Import

				// If the import may be wrong, better stop the remainder of the show.
				[self skipNoncleanupOperationsInOtherGroups] ;
				
				SSYAlert* alert = [SSYAlert alert] ;
				NSString* targetName = [bkmxDoc displayName] ;
				NSString* msg = [NSString stringWithFormat:
								 @"%@\n\n%@  %@",
								 [NSString localizeFormat:
								  @"imex_manyChangesImportX7",
								  [NSString stringWithInt:changeCounts.added],
								  [NSString stringWithInt:changeCounts.updated],
								  [NSString stringWithInt:changeCounts.deleted],
								  targetName,
								  [NSString stringWithInt:totalChangeCount],
								  [[BkmxBasis sharedBasis] labelSafeLimit],
								  [NSString stringWithInt:limit]],
								 [NSString localizeFormat:
								  @"undoodooX",
								  [[BkmxBasis sharedBasis] labelContent],
								  [NSString localize:@"edit"]],
								 [NSString localizeFormat:
								  @"changesSeeReportX",
								  [NSString stringWithFormat:
								   @"%@ \xe2\x96\xb8 %@",
								   [[BkmxBasis sharedBasis] labelReports],
								   [[BkmxBasis sharedBasis] labelDiaries]]
								  ]
								 ] ;
                // The following qualification was added in BookMacster 1.14.9
                if ([[info objectForKey:constKeyPerformanceType] integerValue] != BkmxPerformanceTypeUser) {
                    msg = [[bkmxDoc macster] pauseSyncersAndAppendToMessage:msg] ;
                }
				[alert setSmallText:msg] ;
				[alert setButton1Title:[NSString localize:@"ok"]] ;
                [alert setHelpAddress:constHelpAnchorSafeSyncLimit] ;
				NSInteger iconStyle = SSYAlertIconCritical ;
                BOOL no = NO;
				NSInvocation* invocation = [NSInvocation invocationWithTarget:[info objectForKey:constKeyDocument]
                                                                     selector:@selector(runModalSheetAlert:resizeable:iconStyle:modalDelegate:didEndSelector:contextInfo:)
															  retainArguments:YES
															argumentAddresses:&alert, &no, &iconStyle, NULL, NULL, NULL] ; 
				[info addObject:invocation
				   toArrayAtKey:constKeyMoreDoneInvocations] ;
				
				// We gave the user our warning stating that they could undo.
				// Now we proceed with the import.
				[self limitSafeIsDone] ;
			}
			else {
				// Main App Export
				// Nothing has been done so far, and we are going to
				// setError: which will abort timestampExported.
				
				// Ask user right now if they want to do a Test Run, Cancel,
				// or Export Anyhow, then wait for callback.
				
				SSYAlert* alert = [SSYAlert alert] ;
				NSString* targetName = [(Client*)[(Extore*)[info objectForKey:constKeyExtore] client] displayName] ;
				NSString* msg = [NSString localizeFormat:
								 @"imex_manyChangesExportX7",
								 [NSString stringWithInt:changeCounts.added],
								 [NSString stringWithInt:changeCounts.updated],
								 [NSString stringWithInt:changeCounts.deleted],
								 targetName,
								 [NSString stringWithInt:totalChangeCount],
								 [[BkmxBasis sharedBasis] labelSafeLimit],
								 [NSString stringWithInt:limit]] ;
                // The following qualification was added in BookMacster 1.14.9
                if ([[info objectForKey:constKeyPerformanceType] integerValue] != BkmxPerformanceTypeUser) {
                    msg = [[bkmxDoc macster] pauseSyncersAndAppendToMessage:msg] ;
                }
				[alert setSmallText:msg] ;
				[alert setClickTarget:self] ;
				[alert setClickSelector:@selector(handleExceededExportSafeLimitAlert:)] ;
				[alert setButton1Title:[NSString localize:@"testRun"]] ;
				[alert setButton2Title:[[BkmxBasis sharedBasis] labelCancel]] ;
				[alert setButton3Title:[NSString localizeFormat:
										@"anyhowX",
										[[BkmxBasis sharedBasis] labelExport]]] ;
                [alert setHelpAddress:constHelpAnchorSafeSyncLimit] ;
				[bkmxDoc runModalSheetAlert:alert
                                 resizeable:NO
                                  iconStyle:SSYAlertIconCritical
                              modalDelegate:nil
                             didEndSelector:NULL
                                contextInfo:NULL] ;
                // Callback is via the clickTarget/clickSelector, see above.
			}
		}
		else {
			// In BkmxAgent.  Can't display a dialog now.
			// Create an NSError object including recovery info.
			
			// Nothing has been done so far, and -[self setError:] below
			// will ensure that nothing is done.  For example, 
			// If this is an Import, any subsequent Save operation will be aborted.
			// If this is an Export, any subsequent Export operation will be aborted.

			NSString* msg = [NSString localizeFormat:
							 @"imex_manyChangesIxportX8",
							 operationName,
							 [NSString stringWithInt:changeCounts.added],
							 [NSString stringWithInt:changeCounts.updated],
							 [NSString stringWithInt:changeCounts.deleted],
							 targetName,
							 [NSString stringWithInt:totalChangeCount],
							 [[BkmxBasis sharedBasis] labelSafeLimit],
							 [NSString stringWithInt:limit]] ;
			if ([ixporter isAnExporter]  && (changeCounts.deleted > 25)) {
				msg = [msg stringByAppendingFormat:
					   @"\n\n%@",
					   [NSString localizeFormat:
						@"imex_deleteReallyX2",
						[NSString stringWithInt:changeCounts.deleted],
						targetName,
						[[BkmxBasis sharedBasis] labelCancel]]] ;
			}
			NSInteger errorCode = [ixporter isAnImporter] ? constBkmxErrorImportChangesExceededLimit : constBkmxErrorExportChangesExceededLimit ;
			NSError* error = SSYMakeError(errorCode, msg) ;
			Ixporter* ixporter = [info objectForKey:constKeyIxporter] ;
			error = [error errorByAddingUserInfoObject:[[ixporter client] clientoid]
												forKey:@"Clientoid"] ;
			error = [error errorByAddingLocalizedTitle:[NSString localize:@"warning"]] ;
			NSString* stringOpen = [[BkmxBasis sharedBasis] labelOpen] ;
			NSArray* recoveryOptions = [NSArray arrayWithObjects:
										stringOpen,
										[[BkmxBasis sharedBasis] labelCancel],
										nil] ;
            NSString* menuItemTitle;
            NSString* verb;
            if ([ixporter isAnImporter]) {
                menuItemTitle = [[BkmxBasis sharedBasis] labelImportFromAll];
                verb = @"importing manually";
            } else {
                menuItemTitle = [[BkmxBasis sharedBasis] labelExportToAll];
                verb = @"exporting 'Anyhow' or as a 'Test Run'";
            }
            NSString* menuPath = [NSString stringWithFormat:
                                  @"%@ > %@",
                                  [NSString localize:@"file"],
                                  menuItemTitle] ;
 			NSString* recoverySuggestion = [NSString stringWithFormat:
											@"Click '%@' to open the document.  "
											@"Then retry manually by clicking in the menu: "
											@"%@.  "
                                            @"After so %@, you shall be able to see the changes in the tab Reports > Sync Log.",
											stringOpen,
											menuPath,
                                            verb] ;
			// Even though agents will be paused when this error is displayed,
			// that will not happen until after the user clicks 'View' to the
			// user notification.  We want to pause agents immediately.
			recoverySuggestion = [[bkmxDoc macster] pauseSyncersAndAppendToMessage:recoverySuggestion] ;
			error = [error errorByAddingLocalizedRecoverySuggestion:recoverySuggestion] ;
			error = [error errorByAddingLocalizedRecoveryOptions:recoveryOptions] ;
			error = [error errorByAddingRecoveryAttempterUrl:[bkmxDoc fileURL]] ;
			error = [error errorByAddingUserInfoObject:[NSNumber numberWithBool:[ixporter isAnImporter]]
												forKey:constKeyIsAnImporter] ;
			error = [error errorByAddingUserInfoObject:[[ixporter client] index]
												forKey:constKeyIndex] ;
            error = [error errorByAddingHelpAddress:constHelpAnchorSafeSyncLimitError] ;
			
			// Setting this error will abort timestampExport
			// and abort any upcoming Save operation.
			[self setError:error] ;
			[self limitSafeIsDone] ;
		}
	}
	else {
		[self limitSafeIsDone] ;
	}
}

/* Note UnsignedLimit
 NSUserDefaults does not have -unsignedIntegerForKey:,
 only -integerForKey:.  I think it's OK to use the signed
 integer method, because it's how we interpret it that
 matters.  See #define BKMX_NO_LIMIT for more.
*/

/*!
 @details  This method is used for exports, not imports.
*/
- (void)handleExceededExportSafeLimitAlert:(SSYAlert*)alert {
	switch ([alert alertReturn]) {
		case NSAlertFirstButtonReturn:
			// Test Run
			[[self info] setObject:[NSNumber numberWithBool:YES]
							forKey:constKeyIsTestRun] ;
            [[BkmxBasis sharedBasis] logFormat:@"User clicked 'Test Run'"] ;
			break ;
		case NSAlertSecondButtonReturn:;
			// Cancel
			NSError* error = SSYMakeError(constBkmxErrorUserCancelled, @"User cancelled") ;
			// Setting this error will abort the export.
			[self setError:error] ;

			break ;
		case NSAlertThirdButtonReturn:
            // Export Anyhow
            [[BkmxBasis sharedBasis] logFormat:@"User clicked 'Export Anyhow'"] ;

			break ;
	}
	
	[self limitSafeIsDone] ;
}

/*!
 @details  This operation should run for exports only.
*/
- (void)warnSlow {
	// This operation is skipped if we're doing a test run (SDTR)
	if ([[[self info] objectForKey:constKeyIsTestRun] boolValue] == YES) {
		return ;
	}

	[self prepareLock] ;
	[self doSafely:_cmd] ;
	[self blockForLock] ;
}

- (void)warnSlowIsDone {
	[self unlockLock] ;
}

- (void)warnSlow_unsafe {
	[self lockLock] ;
	
	NSMutableDictionary* info = [self info] ;
	
	BkmxDoc* bkmxDoc = (BkmxDoc*)[info objectForKey:constKeyDocument] ;
    NSString* desc ;
    if (!bkmxDoc) {
        desc = [NSString stringWithFormat:
               @"No extore in %@",
               [info shortDescription]] ;
        NSError* error = SSYMakeError(484902, desc) ;
        // Setting this error will abort timestampExport
        // and abort any upcoming Save operation.
        [self setError:error] ;
        [self warnSlowIsDone] ;
    }

    Extore* extore = (Extore*)[info objectForKey:constKeyExtore] ;
    if (!extore) {
        desc = [NSString stringWithFormat:
               @"No extore in %@",
               [info shortDescription]] ;
        NSError* error = SSYMakeError(484903, desc) ;
        // Setting this error will abort timestampExport
        // and abort any upcoming Save operation.
        [self setError:error] ;
        [self warnSlowIsDone] ;
    } else {
        NSUInteger slowExportThreshold = [extore slowExportThreshold] ;

        SSYModelChangeCounts changeCounts = [[bkmxDoc chaker] changeCounts] ;
        NSInteger totalChangeCount = changeCounts.added + changeCounts.updated + changeCounts.slid + changeCounts.deleted ;

        if (totalChangeCount > slowExportThreshold) {
            if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
                // Main App Export
                // Nothing has been done so far, and we are going to
                // setError: which will abort timestampExported.
                SSYAlert* alert = [extore warnSlowAlertProposed:totalChangeCount
                                                      threshold:slowExportThreshold] ;

                if (alert) {
                    [alert setClickTarget:self] ;
                    [alert setClickSelector:@selector(handleSlowExportWarningAlert:)] ;

                    [bkmxDoc runModalSheetAlert:alert
                                     resizeable:NO
                                      iconStyle:SSYAlertIconCritical
                                  modalDelegate:nil
                                 didEndSelector:NULL
                                    contextInfo:NULL] ;
                }
                else {
                    [self warnSlowIsDone] ;
                }
            }
            else {
                // In BkmxAgent.  Can't display a dialog now.
                // Set an NSError object.

                // This shouldn't happen very often!
                NSString* desc ;
                NSString* warnSlowFormatString = [extore warnSlowFormatString] ;
                if (warnSlowFormatString) {
                    desc = [NSString stringWithFormat:
                            warnSlowFormatString,
                            (long)totalChangeCount] ;
                }
                else {
                    desc = [NSString stringWithFormat:
                            @"Browser will take too long to swallow %ld changes.",
                            (long)totalChangeCount] ;
                }
                NSInteger errorCode = 916540 ;
                NSError* error = SSYMakeError(errorCode, desc) ;
                NSString* openDocumentInstructions ;
                switch ([[BkmxBasis sharedBasis] iAm]) {
                    case BkmxWhich1AppBookMacster:
                        openDocumentInstructions = [[NSString alloc] initWithFormat:
                                                    @"Run %@ and open %@.",
                                                    [[BkmxBasis sharedBasis] appNameLocalized],
                                                    [bkmxDoc displayNameShort]] ;
                        break ;
                    default:
                        openDocumentInstructions = [[NSString alloc] initWithFormat:
                                                    @"Run %@.",
                                                    [[BkmxBasis sharedBasis] appNameLocalized]] ;
                }
                NSString* sugg = [NSString stringWithFormat:
                                  @"• Quit Firefox.\n"
                                  @"• %@\n"
                                  @"• Click in the menu File > Export to all.\n"
                                  @"• Click the 'Syncing' button in the toolbar to re-enable syncing.",
                                  openDocumentInstructions] ;
                [openDocumentInstructions release] ;
                error = [error errorByAddingLocalizedRecoverySuggestion:sugg] ;
                error = [error errorByAddingUserInfoObject:[NSNumber numberWithUnsignedInteger:slowExportThreshold]
                                                    forKey:@"Change Count Threshold"] ;
                error = [error errorByAddingUserInfoObject:[NSNumber numberWithUnsignedInteger:totalChangeCount]
                                                    forKey:@"Change Count"] ;
                
                // Setting this error will abort timestampExport
                // and abort any upcoming Save operation.
                [self setError:error] ;
                [self warnSlowIsDone] ;
            }
        }
        else {
            [self warnSlowIsDone] ;
        }
    }
}

/*!
 @details  This method is used for exports, not imports.
 */
- (void)handleSlowExportWarningAlert:(SSYAlert*)alert {
	switch ([alert alertReturn]) {
		case NSAlertFirstButtonReturn:
			// Proceed Anyhow
			// But wait 5 seconds in case the user quickly quit, say, Firefox
			// and Firefox takes a long time to quit.
			// In testing, I think that maybe 1 second is enough, but if not,
			// the user gets asked to to quit Firefox and then reinstall the
			// extension, which is pretty bad.
			sleep (5) ;
			break ;
		case NSAlertSecondButtonReturn:;
			// Cancel
			NSError* error = SSYMakeError(constBkmxErrorUserCancelled, @"User cancelled") ;
			// Setting this error will abort the export.
			[self setError:error] ;
			
			break ;
	}
	
	[self warnSlowIsDone] ;
}

/*!
 @details  This operation should run for exports only.
 */
- (void)exportCheckStuffMidway {
    [self prepareLock] ;
    [self doSafely:_cmd] ;
    [self blockForLock] ;
}

- (void)exportCheckStuffMidwayIsDone {
    [self unlockLock] ;
}

- (void)exportCheckStuffMidway_unsafe {
    [self lockLock] ;

    NSMutableDictionary* info = [self info] ;

    BkmxDoc* bkmxDoc = (BkmxDoc*)[info objectForKey:constKeyDocument] ;
    NSString* desc ;
    if (!bkmxDoc) {
        desc = [NSString stringWithFormat:
                @"No bkmxDoc in %@",
                [info shortDescription]] ;
        NSError* error = SSYMakeError(484904, desc) ;
        // Setting this error will abort timestampExport
        // and abort any upcoming Save operation.
        [self setError:error] ;
        [self exportCheckStuffMidwayIsDone] ;
    }

    Extore* extore = (Extore*)[info objectForKey:constKeyExtore] ;
    if (!extore) {
        desc = [NSString stringWithFormat:
                @"No extore among the %ld keys in operation's `info`",
                info.allKeys.count] ;
        NSError* error = SSYMakeError(484905, desc) ;
        // Setting this error will abort timestampExport
        // and abort any upcoming Save operation.
        error = [error errorByAddingUserInfoObject:[info shortDescription]
                                            forKey:@"shortDescription of operation's `info`"];
        [self setError:error] ;
        [self exportCheckStuffMidwayIsDone] ;
    } else {
        NSError* error = nil;
        BOOL ok = [extore exportCheckStuffMidwayError_p:&error];
        if (!ok) {
            [self setError:error] ;
        }

        [self exportCheckStuffMidwayIsDone] ;
    }
}

@end
