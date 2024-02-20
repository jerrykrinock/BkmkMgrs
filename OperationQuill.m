#import "OperationQuill.h"
#import "OperationExport.h"
#import "Client.h"
#import "Extore.h"
#import "NSError+InfoAccess.h"
#import "NSString+LocalizeSSY.h"
#import "BkmxBasis+Strings.h"
#import "BkmxDoc.h"
#import "NSObject+MoreDescriptions.h"
#import "NSString+BkmxDisplayNames.h"
#import "NSError+MyDomain.h"
#import "ExtoreChromy+UserOpenProfile.h"
#import "SSYProgressView.h"

@implementation SSYOperation (Quill)

- (BOOL)needsQuill {
    // Set the following to 11 for logging, 0 for normal
#if 0
    // Further set the following to 1 for decision only, 2 for verbose
#define NEEDS_QUILL_LOG_LEVEL 1
#if NEEDS_QUILL_LOG_LEVEL > 0
#warning Logging decision in -[SSYOperation(Quill) needsQuill]
#endif
#endif
#if NEEDS_QUILL_LOG_LEVEL > 1
	NSLog(@"Entering %s", __PRETTY_FUNCTION__) ;
#endif
	
    BOOL ok = YES ;
    NSError* error = nil ;
    BOOL needsQuill = NO ;

	NSMutableDictionary* info = [self info] ;
    Extore* extore = [[self info] objectForKey:constKeyExtore] ;

    /* There is no benefit to quitting a browser for which style 1 is not
     available (such as Opera). */
    if ([extore style1Available]) {
        Client* client = [extore client] ;
        BkmxClientTask clientTask = (BkmxClientTask)[[info objectForKey:constKeyClientTask] integerValue] ;

        BkmxDoc* bkmxDoc = [info objectForKey:constKeyDocument] ;
        SSYProgressView* progressView = [bkmxDoc progressView] ;
        [progressView setIndeterminate:YES
                     withLocalizedVerb:[NSString stringWithFormat:@"Getting status of %@", [extore displayName]]
                              priority:SSYProgressPriorityRegular] ;
        OwnerAppRunningState runningState = [extore ownerAppRunningStateError_p:&error] ;
        if (ok) {
            if (runningState == OwnerAppRunningStateError) {
#if NEEDS_QUILL_LOG_LEVEL > 0
                NSLog(@"Error getting runningState: %@", error) ;
#endif
                [self setError:error] ;
                ok = NO ;
            }
        }

        if (ok) {
#if NEEDS_QUILL_LOG_LEVEL > 1
            NSString* runningStateString ;
            switch (runningState) {
                case OwnerAppRunningStateError :
                    runningStateString = @"Error" ;
                    break ;
                case OwnerAppRunningStateNotRunning :
                    runningStateString = @"NotRunning" ;
                    break ;
                case OwnerAppRunningStateRunningProfileWrongOne :
                    runningStateString = @"RunningProfileWrongOne" ;
                    break ;
                case OwnerAppRunningStateRunningProfileNotLoaded :
                    runningStateString = @"RunningProfileNotLoaded" ;
                    break ;
                case OwnerAppRunningStateRunningProfileAvailable :
                    runningStateString = @"RunningProfileAvailable" ;
                    break ;
            }
            NSLog(@"   client = %@", [client displayName]) ;
            NSLog(@"   clientTask = 0x%lx  ixportStyle = %ld", (long)clientTask, extore.ixportStyle) ;
            NSLog(@"   toleratesClientTask: returns %ld", (long)[extore toleratesClientTask:clientTask]) ;
            NSLog(@"   operation = %@", self) ;
            NSLog(@"   OwnerAppRunningState: %@", runningStateString) ;
#endif
            if (![[client  extoreMedia] isEqualToString:constBkmxExtoreMediaThisUser]) {
                // Branch 1.  Leave needsQuill = NO.
#if NEEDS_QUILL_LOG_LEVEL > 0
                NSLog(@"   NEEDS-QUILL: B1.  Not 'this' user.  Quill not needed.") ;
#endif
            }
            else if (runningState == OwnerAppRunningStateNotRunning) {
                // Branch 2.  Leave needsQuill = NO.
#if NEEDS_QUILL_LOG_LEVEL > 0
                NSLog(@"   NEEDS-QUILL: B2.  Not running.  Quill not needed.") ;
#endif
            }
            else if (
                     [extore toleratesClientTask:clientTask]
                     ) {
                // Branch 3.  Leave needsQuill = NO.
#if NEEDS_QUILL_LOG_LEVEL > 0
                NSLog(@"   NEEDS-QUILL: B3.  Current running state OK.  Quill not needed.") ;
#endif
            }
            else {
                // Branch 4.  Quill the browser now.  This occurs, for example, when
                // exporting to Opera, if Opera is running, even in BookMacster 1.13.6.
                // It also happens if Chrome is running, signed in to Google, and the
                // extension is installed but the messenger is not.
#if NEEDS_QUILL_LOG_LEVEL > 0
                NSLog(@"   NEEDS-QUILL: B4.  Quill is needed.") ;
#endif
                needsQuill = YES ;

                if (runningState == OwnerAppRunningStateRunningProfileWrongOne) {
                    // What's happened here is that we need to just quill the browser
                    // because of the runningState, not because the
                    // extension failed.  If we reinstalled the extension unnecesarily,
                    // besides being a stupid thing to do, the widget, if on, would be
                    // cleared.
#if NEEDS_QUILL_LOG_LEVEL > 0
                    NSLog(@"   NEEDS-QUILL B4A: Profile wrong one for ImEx.") ;
#endif
                    [[BkmxBasis sharedBasis] logFormat:
                     @"Bummer: %@ running wrong profile not %@",
                     [[client exformat] exformatDisplayName],
                     [client profileName]] ;
                }
            }
        }
    }

    return needsQuill ;
}

- (void)finishQuill {
    NSError* error = nil ;
    
	Extore* extore = [[self info] objectForKey:constKeyExtore] ;
	
    if ([self needsQuill]) {
        if (![self error]) {
            BkmxDeference deference = (BkmxDeference)[[[self info] objectForKey:constKeyDeference] integerValue] ;
            NSInteger errorCode = 0 ;
            NSString* errorDescription = nil ;
            NSString* recoverySuggestion = nil;
            switch (deference) {
                case BkmxDeferenceAsk:
                    errorCode = 524857 ;
                    break ;
                case BkmxDeferenceCancelled:
                    // Was errorCode = 524858 until BookMacster 1.15
                    errorCode = constBkmxErrorUserCancelled ;
                    break ;
                case BkmxDeferenceKill:
                    [extore killBrowser] ;
                    break ;
                case BkmxDeferenceQuit:
                    [extore quitOwnerAppCleanlyForOperation:self
                                                    error_p:&error] ;
                    break ;
                case BkmxDeferenceUndefined:
                    errorCode = 524859 ;
                    break ;
                case BkmxDeferenceYield:
                    if ([[BkmxBasis sharedBasis] isBkmxAgent]) {
                        errorCode = constBkmxErrorAgentApparentlyFellBackToStyle1ThusNeededBrowserQuitButAgentCannotQuitBrowsers ;
                        errorDescription = [NSString stringWithFormat:
                                            @"Could not export to %@ because the our Sync extension was required but not found.  A necessary bookmarks syncing operation has been aborted.",
                                            [extore ownerAppDisplayName]] ;
                        recoverySuggestion = [NSString stringWithFormat:
                                              @"• Run %@.\n"
                                              @"• Click in the menubar: %@ > Manage Browser Extensions….\n"
                                              @"• \"Install\" the Sync extension into %@.\n"
                                              @"• \"Test\" and ensure that it works.",
                                              [[BkmxBasis sharedBasis] mainAppNameLocalized],
                                              [[BkmxBasis sharedBasis] mainAppNameLocalized],
                                              [[BkmxBasis sharedBasis] mainAppNameLocalized]
                                              ];
                    } else {
                        errorCode = constBkmxErrorBrowserRunningJustYielded ;
                        errorDescription = [NSString stringWithFormat:
                                            @"Yielded to running %@",
                                            [extore ownerAppDisplayName]] ;
                    }
                    break ;
            }
            
            if (errorCode != 0) {
                if (!errorDescription) {
                    errorDescription = @"Internal Error" ;
                }
                error = SSYMakeError(errorCode, errorDescription) ;
                if (recoverySuggestion) {
                    error = [error errorByAddingLocalizedRecoverySuggestion:recoverySuggestion];
                }
            }
        }
    }

    if (error) {
        [self setError:error] ;
    }

    [self unlockLock] ;
}

- (void)didEndAskQuitBrowserSheet:(NSWindow*)sheet
                       returnCode:(NSInteger)returnCode
                      contextInfo:(void*)notUsed {
	[sheet orderOut:self] ;
	
	switch (returnCode) {
		case NSAlertFirstButtonReturn:
            // Escalate the deference in info
            [[self info] setObject:[NSNumber numberWithInteger:BkmxDeferenceQuit]
                            forKey:constKeyDeference] ;
			break ;
        // This branch was added in BookMacster 1.15…
		case NSAlertSecondButtonReturn:
            // Cancel
            [[self info] setObject:[NSNumber numberWithInteger:BkmxDeferenceCancelled]
                            forKey:constKeyDeference] ;

            // Added in BookMacster 1.19.
            [self setError:[NSError errorWithDomain:NSCocoaErrorDomain
                                               code:NSUserCancelledError
                                           userInfo:nil]] ;
			break ;
		default:;
	}
    
    [self finishQuill] ;
}

- (void)askIfOkToQuitBrowser {
	NSMutableDictionary* info = [self info] ;
	Extore* extore = [info objectForKey:constKeyExtore] ;
	Client* client = [extore client] ;
	
    NSString* defaultOption = [NSString localizeFormat:
                               @"quitApp%@",
                               [client displayNameWithoutProfile]] ;
	
    NSString* alternateOption = [NSString localize:@"cancel"] ;
    
    NSString* defaultDetail = [NSString localizeFormat:
                               @"operationsAndXX",
                               defaultOption,
                               [[[BkmxBasis sharedBasis] labelRetry] lowercaseString]] ;
    
    NSString* msg = [NSString localizeFormat:@"mustQuitApp", [extore ownerAppDisplayName]] ;
    if (defaultOption) {
        msg = [NSString stringWithFormat:
               @"%@\n\n%@",
               msg,
               [NSString localizeFormat:
                @"operationClickDetailXX",
                defaultDetail,
                defaultOption]] ;
    }
    
    BkmxDoc* bkmxDoc = [[client macster] bkmxDoc] ;
    if (!bkmxDoc) {
        bkmxDoc = [info objectForKey:constKeyDocument] ;
    }
    NSWindow* window = [(NSWindowController*)[bkmxDoc bkmxDocWinCon] window] ;
    
    SSYAlert* alert = [SSYAlert alert] ;
    [alert setSmallText:msg] ;
    [alert setButton1Title:defaultOption] ;
    [alert setButton2Title:alternateOption] ;
    
    [alert setIconStyle:SSYAlertIconInformational] ;
    
    [alert runModalSheetOnWindow:window
                      resizeable:NO
                   modalDelegate:self
                  didEndSelector:@selector(didEndAskQuitBrowserSheet:returnCode:contextInfo:)
                     contextInfo:NULL] ;
}

- (BOOL)userMustQuitChrome {
    Extore* extore = [[self info] valueForKey:constKeyExtore] ;
    Client* client = [extore client] ;
    BkmxClientTask clientTask = (BkmxClientTask)[[[self info] objectForKey:constKeyClientTask] integerValue] ;
    OwnerAppRunningState runningState = [extore ownerAppRunningStateError_p:NULL] ;

    BOOL userMustQuitChrome = NO ;
    BOOL isRunningButNotNecessarilyInThisProfile =
    (runningState == OwnerAppRunningStateRunningProfileNotLoaded);
    
    if (clientTask != BkmxClientTaskInstall) {
        if (
            isRunningButNotNecessarilyInThisProfile
            &&
            ([extore extension1Installed])
            ) {
            // What's happened here is that we need to just quill the browser
            // because of the runningState, not because the
            // extension failed.
            // I think that the following statement is no longer true since
            // we split the Chrome Extension into two pieces:
            // If we reinstalled the extension unnecesarily,
            // besides being a stupid thing to do, the widget, if on, would be
            // cleared.
#if NEEDS_QUILL_LOG_LEVEL > 0
            NSLog(@"   Profile not loaded for ImEx.") ;
#endif
            NSString* profileDisplayName = [[extore class] displayProfileNameForProfileName:[client profileName]] ;
            [[BkmxBasis sharedBasis] logFormat:
             @"Profile '%@' is not loaded in %@",
             profileDisplayName,
             [[client exformat] exformatDisplayName]] ;

            userMustQuitChrome = YES ;
        }
    }
    
    return userMustQuitChrome ;
}

- (void)quillBrowser_unsafe {
    BOOL willFinishQuillAfterAskingUser = NO ;
    
    Extore* extore = [[self info] objectForKey:constKeyExtore] ;
    [extore setError:nil] ;
    
    if ([self needsQuill]) {
        if (![self error]) {
            if ([self userMustQuitChrome]) {
                SEL chromyWorkaround = @selector(askUserOpenProfileForOperation:) ;
                if ([extore respondsToSelector:chromyWorkaround]) {
                    [extore performSelector:chromyWorkaround
                                 withObject:self] ;
                    willFinishQuillAfterAskingUser = YES ;
                }
            }
            else {
                BkmxDeference deference = (BkmxDeference)[[[self info] objectForKey:constKeyDeference] integerValue] ;
                if (deference == BkmxDeferenceAsk) {
                    [self askIfOkToQuitBrowser] ;
                    willFinishQuillAfterAskingUser = YES ;
                } else {
                    /* This is what happens when running in Agent if extension
                     is not installed in a browser.  The subsequent result will
                     be constBkmxErrorAgentApparentlyFellBackToStyle1ThusNeededBrowserQuitButAgentCannotQuitBrowsers. */
                }
            }
        }
    }
        
    if (!willFinishQuillAfterAskingUser) {
        [self finishQuill] ;
    }
}

- (void)quillBrowser {
    BOOL doIt = YES ;
    if ([[[self info] objectForKey:constKeyClientTask] integerValue] == BkmxClientTaskWrite) {
        if ([[[self info] objectForKey:constKeyIsTestRun] boolValue] == YES) {
            doIt = NO ;
        }
        else if (![self anyChangesToWrite]) {
            doIt = NO ;
        }
    }
    
    if (doIt) {
        BOOL alreadyLockedThisMustBeARetry = ([self lockIsBlocking]) ;
        // alreadyLockedThisMustBeARetry will be YES
        if (!alreadyLockedThisMustBeARetry) {
            [self prepareLock] ;
        }
        [self doSafely:_cmd] ;
        [self blockForLock] ;
    }
}

@end
