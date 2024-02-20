#import "BkmxDoc+GuiStuff.h"
#import "NSError+Recovery.h"
#import "BkmxAppDel+Capabilities.h"
#import "NSArray+Stringing.h"
#import "Stark+Sorting.h"
#import "Starker.h"
#import "Bookshig.h"
#import "BkmxBasis+Strings.h"
#import "NSString+LocalizeSSY.h"
#import "NSUserDefaults+Bkmx.h"
#import "Extore.h"
#import "NSImage+Merge.h"
#import "Macster.h"
#import "SSYProgressView.h"
#import "Dupetainer.h"
#import "NSError+DecodeCodes.h"
#import "NSObject+MoreDescriptions.h"
#import "NSError+InfoAccess.h"
#import "NSError+SSYInfo.h"
#import "BkmxDoc+Actions.h"

NSString* const constKeyLastContentTouchDate = @"lastContentTouchDate" ;

@implementation BkmxDoc (GuiStuff)

/*
 In the following four methods, the logic is that
 (1) It's always OK to start one if you don't have one
 (2) If you have one, you can only remove it if it is empty.
 */
- (BOOL)canChangeHasBar {
	return (NO
			|| !([self hasBar] == YES)
			|| ([[[self starker] bar] numberOfChildren] == 0)
			) ;
}
+ (NSSet*)keyPathsForValuesAffectingCanChangeHasBar {
	return [NSSet setWithObject:constKeyLastContentTouchDate] ;
}

- (BOOL)canChangeHasMenu {
	return (NO
			|| !([self hasMenu] == YES)
			|| ([[[self starker] menu] numberOfChildren] == 0)
			) ;
}
+ (NSSet*)keyPathsForValuesAffectingCanChangeHasMenu {
	return [NSSet setWithObject:constKeyLastContentTouchDate] ;
}

- (BOOL)canChangeHasUnfiled {
	return (NO
			|| !([self hasUnfiled] == YES)
			|| ([[[self starker] unfiled] numberOfChildren] == 0)
			) ;
}
+ (NSSet*)keyPathsForValuesAffectingCanChangeHasUnfiled {
	return [NSSet setWithObject:constKeyLastContentTouchDate] ;
}

- (BOOL)canChangeHasOhared {
	return (NO
			|| !([self hasOhared] == YES)
			|| ([[[self starker] ohared] numberOfChildren] == 0)
			) ;
}
+ (NSSet*)keyPathsForValuesAffectingCanChangeHasOhared {
	return [NSSet setWithObject:constKeyLastContentTouchDate] ;
}


- (BOOL)canChangeRootSoftainersOk {
	BOOL answer ;
	
	if ([[[self shig] rootSoftainersOk] boolValue]) {
		// Currently the targets are allowed.  See if there are any.
		Stark* root = [[self starker] root] ;
		NSMutableArray* targets = [[NSMutableArray alloc] init] ;
        [root classifyBySharypeHeight:1  // was effectively 0, fixed in BookMacster 1.19.0
						   hartainers:nil
						  softFolders:targets
							   leaves:nil
							  notches:nil] ;
		// Allow change to NO only if there are not any existing
		// targets that would violate the proposed disallowance.
		answer = ([targets count] == 0) ;
		[targets release] ;
	}
	else {
		// Currently the targets are not allowed.
		// It would always be ok to start allowing them.
		answer = YES ;
	}
	
	return answer ;
}
+ (NSSet*)keyPathsForValuesAffectingCanChangeRootSoftainersOk {
	return [NSSet setWithObject:constKeyLastContentTouchDate] ;
}


- (BOOL)canChangeRootLeavesOk {
	BOOL answer ;
	
	if ([[self.shig rootLeavesOk] boolValue]) {
		// Currently the targets are allowed.  See if there are any.
		Stark* root = [[self starker] root] ;
		NSMutableArray* targets = [[NSMutableArray alloc] init] ;
        [root classifyBySharypeHeight:1  // was effectively 0, fixed in BookMacster 1.19.0
                           hartainers:nil
						  softFolders:nil
                               leaves:targets
                              notches:nil] ;
		// Allow change to NO only if there are not any existing
		// targets that would violate the proposed disallowance.
		answer = ([targets count] == 0) ;
		[targets release] ;
	}
	else {
		// Currently the targets are not allowed.
		// It would always be ok to start allowing them.
		answer = YES ;
	}
	
	return answer ;
}
+ (NSSet*)keyPathsForValuesAffectingCanChangeRootLeavesOk {
	return [NSSet setWithObject:constKeyLastContentTouchDate] ;
}



- (BOOL)canChangeRootNotchesOk {
	BOOL answer ;
	
	if ([[self.shig rootNotchesOk] boolValue]) {
		// Currently the targets are allowed.  See if there are any.
		Stark* root = [[self starker] root] ;
		NSMutableArray* targets = [[NSMutableArray alloc] init] ;
        [root classifyBySharypeHeight:1  // was effectively 0, fixed in BookMacster 1.19.0
							 hartainers:nil
						  softFolders:nil
							leaves:nil
						   notches:targets] ;
        
		// Allow change to NO only if there are not any existing
		// targets that would violate the proposed disallowance.
		answer = ([targets count] == 0) ;
		[targets release] ;
	}
	else {
		// Currently the targets are not allowed.
		// It would always be ok to start allowing them.
		answer = YES ;
	}
	
	return answer ;
}
+ (NSSet*)keyPathsForValuesAffectingCanChangeRootNotchesOk {
	return [NSSet setWithObject:constKeyLastContentTouchDate] ;
}

- (NSString*)toolTipHasBar {
	NSString* toolTip = [NSString localizeFormat:
						 @"availableIn",
						 [self labelBar],  // Refers to our Bookmarks Bar
						 [[(BkmxAppDel*)[NSApp delegate] exformatsThatHaveSharype:SharypeBar] listValuesForKey:nil
																					  conjunction:@"&"
																					   truncateTo:0]] ;
	if (![self canChangeHasBar]) {
		// Explain why the control is disabled
		toolTip = [toolTip stringByAppendingFormat:
				   @"\n\n%@",
				   [NSString localizeFormat:
					@"itemsRemoveRemove",
					[self labelBar]]] ;  // Refers to our Bookmarks Bar
	}
	
	return toolTip ;
}
+ (NSSet*)keyPathsForValuesAffectingToolTipHasBar {
	return [NSSet setWithObject:constKeyLastContentTouchDate] ;
}


- (NSString*)toolTipHasMenu {
	NSString* toolTip = [NSString localizeFormat:
						 @"availableIn",
						 [self labelMenu],
						 [[(BkmxAppDel*)[NSApp delegate] exformatsThatHaveSharype:SharypeMenu] listValuesForKey:nil
																					   conjunction:@"&"
																						truncateTo:0]] ;
	if (![self canChangeHasMenu]) {
		// Explain why the control is disabled
		toolTip = [toolTip stringByAppendingFormat:
				   @"\n\n%@",
				   [NSString localizeFormat:
					@"itemsRemoveRemove",
					[self labelMenu]]] ;
	}
	
	return toolTip ;
}
+ (NSSet*)keyPathsForValuesAffectingToolTipHasMenu {
	return [NSSet setWithObject:constKeyLastContentTouchDate] ;
}


- (NSString*)toolTipHasUnfiled {
	NSString* toolTip = [NSString localizeFormat:
						 @"availableIn",
						 [self labelUnfiled],
						 [[(BkmxAppDel*)[NSApp delegate] exformatsThatHaveSharype:SharypeUnfiled] listValuesForKey:nil
																						  conjunction:@"&"
																						   truncateTo:0]] ;
	if (![self canChangeHasUnfiled]) {
		// Explain why the control is disabled
		toolTip = [toolTip stringByAppendingFormat:
				   @"\n\n%@",
				   [NSString localizeFormat:
					@"itemsRemoveRemove",
					[self labelUnfiled]]] ;
	}
		
	return toolTip ;
}
+ (NSSet*)keyPathsForValuesAffectingToolTipHasUnfiled {
	return [NSSet setWithObject:constKeyLastContentTouchDate] ;
}


- (NSString*)toolTipHasOhared {
	NSString* toolTip = [NSString localizeFormat:
						 @"availableIn",
						 [self labelOhared],
						 [[(BkmxAppDel*)[NSApp delegate] exformatsThatHaveSharype:SharypeOhared] listValuesForKey:nil
																						 conjunction:@"&"
																						  truncateTo:0]] ;
	if (![self canChangeHasOhared]) {
		// Explain why the control is disabled
		toolTip = [toolTip stringByAppendingFormat:
				   @"\n\n%@",
				   [NSString localizeFormat:
					@"itemsRemoveRemove",
					[self labelOhared]]] ;
	}
	
	return toolTip ;
}
+ (NSSet*)keyPathsForValuesAffectingToolTipHasOhared {
	return [NSSet setWithObject:constKeyLastContentTouchDate] ;
}


- (NSString*)toolTipRootSoftainersOk {
	NSString* toolTip ;
	if (![self canChangeRootSoftainersOk]) {
		// Explain why the control is disabled
		toolTip = [NSString localizeFormat:
				   @"itemsRemoveDisallow",
				   [[BkmxBasis sharedBasis] labelRoot],
				   [[BkmxBasis sharedBasis] labelSoftainers]] ;
	}
	else {
		// No tooltip if the control is enabled
		toolTip = nil ;
	}
	
	return toolTip ;
}
+ (NSSet*)keyPathsForValuesAffectingToolTipRootSoftainersOk {
	return [NSSet setWithObject:constKeyLastContentTouchDate] ;
}


- (NSString*)toolTipRootLeavesOk {
	NSString* toolTip ;
	if (![self canChangeRootLeavesOk]) {
		// Explain why the control is disabled
		toolTip = [NSString localizeFormat:
				   @"itemsRemoveDisallow",
				   [[BkmxBasis sharedBasis] labelRoot],
				   [[BkmxBasis sharedBasis] labelLeaves]] ;
	}
	else {
		// No tooltip if the control is enabled
		toolTip = nil ;
	}
	
	return toolTip ;
}
+ (NSSet*)keyPathsForValuesAffectingToolTipRootLeavesOk {
	return [NSSet setWithObject:constKeyLastContentTouchDate] ;
}


- (NSString*)toolTipRootNotchesOk {
	NSString* toolTip ;
	if (![self canChangeRootNotchesOk]) {
		// Explain why the control is disabled
		toolTip = [NSString localizeFormat:
				   @"itemsRemoveDisallow",
				   [[BkmxBasis sharedBasis] labelRoot],
				   [[BkmxBasis sharedBasis] labelNotches]] ;
	}
	else {
		// No tooltip if the control is enabled
		toolTip = nil ;
	}
	
	return toolTip ;
}
+ (NSSet*)keyPathsForValuesAffectingToolTipRootNotchesOk {
	return [NSSet setWithObject:constKeyLastContentTouchDate] ;
}

/*!
 @brief    Returns the dictionary of information which is required
 by the staticConfigInfo of the dupesStatus SSYProgressView instance.

 @details   In BookMacster 1.5.6, this method was moved from the Bookshig
 class, where it would occasionally cause KVO errors of a BkmxDoc being
 "deallocated while key-value observers are still registered with it"
 for the key path lastContentTouchDate.  This may be because, in
 +keyPathsForValuesAffectingDupesStatusInfo, putting this method in the
 Bookshig class means I needed this hokey key path: "owner.lastContentTouchDate"
 instead of simply lastContentTouchDate like I have now, see below.  But
 now I need a not-quite-as-hokey keypath, "shig.lastDupesDone".  I say
 this is not quite as hokey because at least I'm going from owner to 
 owned object which seems more natura.  I really don't understand what the
 problem was, but maybe the lesson is don't use hokey key paths. 
 
 Oh, here was one way to reproduce the KVO error referred to above:
 Click File ▸ New BkmxDoc
 Click Home
 Click Save
 In Clients Wizard, tick Firefox
 Click Later to Import Now
 Click No to view documentation
 Click File ▸ Close & Delete
 Click OK to Trash it
*/
- (NSDictionary*)dupesStatusInfo {
	NSString* plainText = nil ;
	NSString* hyperText = nil ;
	id target = nil ;
	NSValue* actionValue = nil ;
	
	if ([[self shig] dupesMaybeMore]) {
		plainText = [NSString localize:@"dupesStale"] ;
		hyperText = [NSString localize:@"080_dupesFind"] ;
		target = self ;
		actionValue = [NSValue valueWithPointer:@selector(findDupes:)] ;
	}
	else {
		NSInteger n = [[[self dupetainer] dupes] count] ; 
		plainText = [NSString localizeFormat:@"dupesGroupsN", n] ;
	}
	
	NSMutableDictionary* dic = [[NSMutableDictionary alloc] init] ;
	if (plainText) {
		[dic setObject:plainText forKey:constKeyPlainText] ;
	}
	if (hyperText) {
		[dic setObject:hyperText forKey:constKeyHyperText] ;
	}
	if (target) {
		[dic setObject:target forKey:constKeyTarget] ;
	}
	if (actionValue) {
		[dic setObject:actionValue forKey:constKeyActionValue] ;
	}
	
	NSDictionary* answer = [dic copy] ;
	[dic release] ;
	
	return [answer autorelease] ;
}

+ (NSSet *)keyPathsForValuesAffectingDupesStatusInfo {
	NSString* hokeyKeyPath1 = [NSString stringWithFormat:
							  @"shig.%@",
							  constKeyLastDupesDone] ;
	NSString* hokeyKeyPath2 = [NSString stringWithFormat:
							  @"shig.%@",
							  constKeyLastDupesMaybeMore] ;
	return [NSSet setWithObjects:
			hokeyKeyPath1,           // for findDupes execution
			hokeyKeyPath2,           // in case shig.ignoreDisparateDupes is switched OFF.
			// hotKeyPath2 was added in BookMacster 1.7.
			// constKeyLastDupesMaybeMore,    // for added starks  // Note: lastDupesMaybeMore, not dupesMaybeMore
			// constKeyLastDupesMaybeLess,    // for deleted starks
			// The above *three* keyPaths were replaced with this one
			// in BookMacster version 1.1.6…
			constKeyLastContentTouchDate,
			// However when finishing BookMacster version 1.3.12 I found that
			// constKeyLastDupesDone was not working for the case when there
			// were no dupes shown, no dupes actually, but "New duplicates, not
			// shown, may exist", and Find Duplicates was clicked, and found
			// nothing.  The Find Duplicates hyperlink should have been disabled
			// after that, but it was not because dupesStatus was not affected.
			
			// Anyhow, constKeyLastContentTouchDate seems to do the job for all cases
			// mentioned in the comment alongside the two replaced,
			// plus undo and redo, which the two replaced did not trigger for.
			nil] ;	
}

// This code was added in BookMacster 1.17 to try and catch the 134030 bug…
- (BOOL)tryToRecoverIf134030Error:(NSError*)error
                              log:(NSMutableString*)log {
    BOOL didRecover = NO ;
    if ([error involvesCode:134030
                     domain:NSCocoaErrorDomain]) {
        NSDictionary* userInfo = [error userInfo] ;
        NSArray* objects = [userInfo valueForKey:NSAffectedObjectsErrorKey] ;
        [log appendFormat:@"Got %ld objects.  ", (long)[objects count]] ;
        for (NSManagedObject* object in objects) {
            if ([object isKindOfClass:[NSManagedObject class]]) {
                BOOL wasInserted = [object isInserted] ;
                [[self managedObjectContext] insertObject:object] ;
                didRecover = [object isInserted] ;
                [log appendFormat:@"Before=%hhd  After=%hhd : %@",
                 wasInserted,
                 didRecover,
                 [object shortDescription]] ;
                if (!didRecover) {
                    //Don't bother trying any more.
                    break ;
                }
            }
        }
        if (didRecover) {
            [self saveDocument] ;  // Custom method, queues save operation
        }
    }
    
    return didRecover ;
}

- (NSError *)willPresentError:(NSError *)error {
    NSMutableString* recoveryLog134030 = [NSMutableString string] ;
    BOOL didRecover = [self tryToRecoverIf134030Error:error
                                                  log:recoveryLog134030] ;
    if ([recoveryLog134030 length] > 0) {
        error = [error errorByAddingUserInfoObject:recoveryLog134030
                                            forKey:@"134030 Recovery Log"] ;

        NSString* formatString ;
        if (didRecover) {
            formatString = @"%@ was able to recover from the error.\n\n%@" ;
        }
        else {
            formatString = @"%@ was not able to recover from the error.  "
            @"You must force quit BookMacster.  You latest bookmark addition "
            @"will probably be lost.\n\n%@" ;
        }

        NSString* pleaForHelp =
        @"We would appreciate you clicking the life-preserver icon and sending "
        @"us the data which is formed into an email message.  Your data may "
        @"help us to find the root cause and prevent these errors "
        @"from occurring in the future." ;

        NSString* suggestion = [NSString stringWithFormat:
                                formatString,
                                [[BkmxBasis sharedBasis] appNameLocalized],
                                pleaForHelp] ;

        error = [error errorByAddingLocalizedRecoverySuggestion:suggestion] ;
    }

    /*  Comments on 2017-06-29, macOS 10.12.6, developing BkmkMgrs 2.5

     Logically, one would think that this would be the end of this method,
     that we would return the possibly modified `error`, because the
     remainder of this method either automatically recovers from or *presents*
     the error.  So it seems this remaining code should be in a override of
     presentError:modalForWindow:delegate:didPresentSelector:contextInfo:
     (which we shall heretofore refer to as presentError:::::) or else
     -presentError:.  (-presentError:, which presents a dialog window,
     never gets called.  Method -presentError:::::, which presents a sheet,
     does get called.

     Apple states in the documentation of both -[NSDocument presentError:::::]
     and -[NSDocument presentError:] the following:

     "You should not override this method but should instead override
     willPresentError:"

     although taken in context I'm not sure if this is a blanket prohibition.

     Anyhow, I tried this, using my own error presentation, [self alertError].
     I split this method here, and put the remainder of the code in a override
     of -presentError::::.  It misbehaved with these steps:

     • Open a .bmco document.
     • Click menu > File > Duplicate.
     • Give it a name and location which would overwrite an existing file.
     -   This method will be invoked with NSCocoaErrorDomain code 67001.
     -   This method returns the same error to -presentError:, the override
     -   will execute [self alertError:] and a sheet will appear.
     • In the sheet which appears, click "Cancel".

     Result: App will hang with spinning circular rainbow forever.

     I think this is because I am not executing the completion parameters which
     are passed to presentError:::::, which log as:

     -  delegate: the BkmxDoc object
     -  didPresentSelector: _somethingDidSomething:soContinue:
     -  contextInfo: <something which is not NULL>

     So I thought maybe that the prohibition was blanket, and put the following
     code back into this method.

     Now what should this method return?

     Returning nil, in the test case described above, or if you modify the test
     case by clicking "Replace", results in the following warning being printed
     to the console:

     "-[NSAlert alertWithError:] called with nil NSError. A generic error
     message will be displayed, but the user deserves better."

     Actually, the predicted "display" does *not* happen.  After the error is
     displayed in my SSYAlert by my code, no other sheets or windows appear.
     But, whatever, I don't like that message in the console.

     The next choice would be to return a NSUserCancelledError as you see
     is done below in most cases.  This worked for me for years, until
     BkmkMgrs 2.5 when I upgraded to BSManagedDocument, async saving, etc.
     After doing that, when I executed the test case described above, whether
     clicking "Replace" or "Cancel", upon later closing the document, app
     would crash 85% of the time, and with zombies turned on revealed that
     the document window (SSYHintableWindow) had received a autorelease after
     it had been deallocced.  I was able to prevent the crash by adding a
     *single* unbalanced -retain.  But then, of course, this caused the window
     to leak in all other cases.  Logging retains and releases during window
     closing resulted in hundreds of lines, so I gave up on debugging that.

     After verifying that the test app which comes with BSManagedDocument does
     not crash in this way, I discovered that if I instead returned the
     passed-in error instead of a NSUserCancelledError in this case, voila
     no crash.  The only problem is that I got a NSBeep in this special case,
     and I'm not sure if that is normal for Error 67001.

     But then after doing all of this work, I decided that for this case
     (warning about overwriting existing document on disk, code 67001), it
     was better to use Apple's presentation after all, because sometimes
     I have no choice – see further comment below. */

    NSError* returnError = nil;

    if (
        [[error domain] isEqualToString:NSCocoaErrorDomain]
        &&
        ([error code] == 67000)
        ) {
        // See Note deadlockWithCocoa67000 at bottom of file.

        NSInteger saveAnywayRecoveryOptionIndex = 1;
        /* Until 2017-06-02, I thought that the "Save Anyway" option was 0, and
         set saveAnywayRecoveryOptionIndex to 0.  On this date, while testing
         Synkmark > Reset and Start Over…, which evokes Error 67000 with a
         probability of about 10%, I found that the result was to invoke
         -[BkmxDoc revertToURL:::].  I then logged the localized recovery
         options and found that they are these: (
         Revert,
         "Save Anyway",
         "Save As\U2026"
         )
         where as you can see Save Anyway is 1, not 0.  So now, I use 1 as the
         default and try to accomodate future changes by searching for it.  Of
         course this will only work for English localizations… */
        NSInteger i = 0;
        NSString* saveAnywayRecoveryOptionString = @"Deeefault";
        for (NSString* option in [error localizedRecoveryOptions]) {
            if ([option rangeOfString:@"Anyway"].location != NSNotFound) {
                saveAnywayRecoveryOptionString = option;
                saveAnywayRecoveryOptionIndex = i;
                break;
            }
            i++;
        }
        NSLog(@"Internal Error 134-8509: Got error 67000 NSCocoaErrorDomain will silently click %@ [%ld] from among %@",
              saveAnywayRecoveryOptionString,
              saveAnywayRecoveryOptionIndex,
              [error localizedRecoveryOptions]) ;
        [[error recoveryAttempter] attemptRecoveryFromError:error
                                                optionIndex:1
                                                   delegate:nil
                                         didRecoverSelector:NULL
                                                contextInfo:NULL] ;
    } else if (
               [[error domain] isEqualToString:NSCocoaErrorDomain]
               &&
               ([error code] == 67001)
               ) {
        /* This happens if user attempts to save a document at a path which
         overwrites another existing document on disk.  In this case, we want
         to use Apple's presentation, because -willPresentError: only gets
         called if user does this immediately after clicking File > Save As…,
         by typing into the title bar.  If user does this later, Apple's
         presentation will be used and -willPresentError: is not called.
         It makes sense, because it's not really an error.  But I think that
         Apple should be consistent. */
        returnError = [super willPresentError:error];
    } else {
        /* This error is not handled by automatic recovery and should be
         presented to the user.  In this general case, I prefer my error
         presentation to Apple's: */
        [self alertError:error];
    }

    if (!returnError) {
        returnError = [NSError errorWithDomain:NSCocoaErrorDomain
                                          code:NSUserCancelledError
                                      userInfo:nil]  ;
    }

    return returnError;
}

- (NSUserDefaults*)standardUserDefaults {
	return [NSUserDefaults standardUserDefaults] ;
}

- (BOOL)doOpenAfterLaunch {
	BOOL answer = [[NSUserDefaults standardUserDefaults] doOpenAfterLaunchDocUuid:[self uuid]] ;
	return answer ;
}
- (void)setDoOpenAfterLaunch:(BOOL)yn {
	[[NSUserDefaults standardUserDefaults] setDoOpenAfterLaunch:yn
														docUuid:[self uuid]] ;
}
// The following was added in BookMacster 1.2.6, before I found the *real*
// problem.  But I retested with this and it seems like a good idea, so I
// left it in.  Probably not needed now, but would be needed if I ever add
// another way to control doOpenAfterLaunch.
+ (NSSet*)keyPathsForValuesAffectingDoOpenAfterLaunch {
	return [NSSet setWithObjects:
			[@"standardUserDefaults." stringByAppendingString:constKeyDoOpenAfterLaunchUuids],
			nil] ;
}

@end


/*
 Note deadlockWithCocoa67000
 
 The following code, which got the current selector names for
 "helpful" printing along with the internal error which follows,
 deadlocked on the call to -[NSOperationQueue operations] while I
 was testing BookMacster 1.17 in 10.7.  It happened in the BookMacster app.
 The sheet "An Agent's Worker is currently syncing possible changes
 from your Clients" sheet was showing at the time.  I don't understand
 why it deadlocked.  But I concluded that I would be better off not to
 try and print the "helpful" information.
 
 NSMutableArray* selectorNames = [NSMutableArray array] ;
 for (SSYOperation* operation in [[self operationQueue] operations]) {
 if ([operation respondsToSelector:@selector(selector)]) {
 SEL selector = [operation selector] ;
 if (selector) {
 NSString* selectorName = NSStringFromSelector(selector) ;
 if (selectorName) {
 [selectorNames addObject:selectorName] ;
 }
 }
 }
 }
 NSLog(@"Internal Error 134-8564: Silently clicked 'Save Anyway' to 67000 NSCocoaErrorDomain.\npending operation selectors: %@",
 selectorNames) ;
 
Here is a sample showing the deadlock…
 
 Process:         BookMacster [20372]
 Version:         1.17 (1.17)
 Code Type:       X86-64 (Native)
 
 Date/Time:       2013-09-01 21:17:09.342 -0700
 OS Version:      macOS 10.7.5 (11G63)
 Report Version:  7
 
 Call graph:
 2773 Thread_185502   DispatchQueue_1: com.apple.main-thread  (serial)
 + 2773 start  (in BookMacster) + 52  [0x1000019f4]
 +   2773 main  (in BookMacster) + 367  [0x100001b6f]
 +     2773 NSApplicationMain  (in AppKit) + 867  [0x7fff92ea5eac]
 +       2773 -[NSApplication run]  (in AppKit) + 470  [0x7fff92c299b9]
 +         2773 -[NSApplication nextEventMatchingMask:untilDate:inMode:dequeue:]  (in AppKit) + 135  [0x7fff92c2d07d]
 +           2773 _DPSNextEvent  (in AppKit) + 659  [0x7fff92c2d779]
 +             2773 BlockUntilNextEventMatchingListInMode  (in HIToolbox) + 62  [0x7fff95a273fa]
 +               2773 ReceiveNextEventCommon  (in HIToolbox) + 355  [0x7fff95a2756d]
 +                 2773 RunCurrentEventLoopInMode  (in HIToolbox) + 277  [0x7fff95a202bf]
 +                   2773 CFRunLoopRunSpecific  (in CoreFoundation) + 230  [0x7fff8e923486]
 +                     2773 __CFRunLoopRun  (in CoreFoundation) + 1724  [0x7fff8e923e7c]
 +                       2773 _dispatch_main_queue_callback_4CF  (in libdispatch.dylib) + 308  [0x7fff938758f2]
 +                         2773 _dispatch_call_block_and_release  (in libdispatch.dylib) + 18  [0x7fff93873a82]
 +                           2773 __-[NSDocumentController(NSInternal) _onMainThreadInvokeWorker:]_block_invoke_3  (in AppKit) + 492  [0x7fff92ffaf0a]
 +                             2773 __-[NSDocument performAsynchronousFileAccessUsingBlock:]_block_invoke_6  (in AppKit) + 94  [0x7fff92fc9c64]
 +                               2773 -[NSDocument continueFileAccessUsingBlock:]  (in AppKit) + 227  [0x7fff92fc984f]
 +                                 2773 __-[NSDocument saveToURL:ofType:forSaveOperation:completionHandler:]_block_invoke_1  (in AppKit) + 845  [0x7fff92fce7a1]
 +                                   2773 -[NSDocument _fileCoordinator:coordinateReadingContentsAndWritingItemAtURL:byAccessor:]  (in AppKit) + 248  [0x7fff92fe0862]
 +                                     2773 -[NSFileCoordinator(NSPrivate) _coordinateReadingItemAtURL:options:writingItemAtURL:options:error:byAccessor:]  (in Foundation) + 829  [0x7fff8ecafe35]
 +                                       2773 -[NSFileCoordinator(NSPrivate) _invokeAccessor:orDont:thenRelinquishAccessClaimForID:]  (in Foundation) + 207  [0x7fff8ecaca5d]
 +                                         2773 __-[NSDocument saveToURL:ofType:forSaveOperation:completionHandler:]_block_invoke_7  (in AppKit) + 1376  [0x7fff92feb567]
 +                                           2773 __-[NSDocument saveToURL:ofType:forSaveOperation:completionHandler:]_block_invoke_9  (in AppKit) + 436  [0x7fff92fced00]
 +                                             2773 __-[NSDocument saveToURL:ofType:forSaveOperation:completionHandler:]_block_invoke_11  (in AppKit) + 142  [0x7fff92fcefe1]
 +                                               2773 __-[NSDocument saveToURL:ofType:forSaveOperation:delegate:didSaveSelector:contextInfo:]_block_invoke_3  (in AppKit) + 123  [0x7fff92fcd2bc]
 +                                                 2773 -[NSDocument _presentError:thenContinue:]  (in AppKit) + 101  [0x7fff92fdc59b]
 +                                                   2773 -[NSDocument presentError:modalForWindow:delegate:didPresentSelector:contextInfo:]  (in AppKit) + 77  [0x7fff92fd5b1a]
 +                                                     2773 -[BkmxDoc(GuiStuff) willPresentError:]  (in Bkmxwork) + 1021  [0x10003274d]
 +                                                       2773 -[NSOperationQueue operations]  (in Foundation) + 61  [0x7fff8eb41868]
 +                                                         2773 _dispatch_barrier_sync_f_slow  (in libdispatch.dylib) + 137  [0x7fff93875f7a]
 +                                                           2773 _dispatch_thread_semaphore_wait  (in libdispatch.dylib) + 18  [0x7fff93876d8a]
 +                                                             2773 semaphore_wait_trap  (in libsystem_kernel.dylib) + 10  [0x7fff939b96b6]
 
 Total number in stack (recursive counted multiple, when >=5):
 5       objc_msgSend  (in libobjc.A.dylib) + 0  [0x7fff9227be80]
 
 Sort by top of stack, same collapsed (when >= 5):
 kevent  (in libsystem_kernel.dylib)        5546
 __psynch_cvwait  (in libsystem_kernel.dylib)        2773
 semaphore_wait_trap  (in libsystem_kernel.dylib)        2773
 __semwait_signal  (in libsystem_kernel.dylib)        2717
 cerror  (in libsystem_kernel.dylib)        26
 objc_msgSend  (in libobjc.A.dylib)        12
 
 
 */
