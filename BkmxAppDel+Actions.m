#import <Sparkle/Sparkle.h>
#import <Bkmxwork/Bkmxwork-Swift.h>
#import "BkmxAppDel+Actions.h"
#import "NSError+DecodeCodes.h"
#import "SSYAboutPanelController.h"
#import "NSString+VarArgs.h"
#import "NSString+Clipboard.h"
#import "BkmxBasis+Strings.h"
#import "BkmxDoc+Actions.h"
#import "BkmxDocWinCon.h"
#import "Extore.h"
#import "NSString+LocalizeSSY.h"
#import "Starker.h"
#import "SSWebBrowsing.h"
#import "StarkEditor.h"
#import "SSYListPicker.h"
#import "SSYMOCManager.h"
#import "BkmxDocumentController.h"
#import "NSString+SSYExtraUtils.h"
#import "NSArray+SortDescriptorsHelp.h"
#import "NSDocumentController+DisambiguateForUTI.h"
#import "SSYLicensingParms.h"
#import "SSYLicenseBuyController.h"
#import "SSYLicenseInfoController.h"
#import "SSYLicensor.h"
#import "Stark+Attributability.h"
#import "Syncer.h"
#import "NSObject+MoreDescriptions.h"
#import "NSInvocation+Quick.h"
#import "Macster.h"
#import "Stager.h"
#import "SSYTroubleZipper.h"
#import "ExtensionsWinCon.h"
#import "Uninstaller.h"
#import "SSYAppInfo.h"
#import "SUUpdater.h"
#import "NSUserDefaults+MainApp.h"
#import "Starki.h"
#import "NSUserDefaults+Bkmx.h"
#import "PrefsWinCon.h"
#import "SSYEventInfo.h"
#import "Watch.h"
#import "SSYInterappClient.h"
#import "SSYAlert.h"
#import "NSError+MyDomain.h"
#import "NSError+InfoAccess.h"
#import "NSError+MoreDescriptions.h"
#import "ExtoreSafari.h"


@implementation BkmxAppDel (Actions) 

- (void)shoeboxDocumentNicelyCompletionHandler:(void(^)(BkmxDoc*))completionHandler {
    [[NSDocumentController sharedDocumentController] shoeboxDocumentForcibly:NO
                                                           completionHandler:^(BkmxDoc* shoeboxDocument) {
                                                               if (completionHandler) {
                                                                   completionHandler(shoeboxDocument) ;
                                                               }
                                                           }] ;
}

- (IBAction)shoeboxShowSyncLog:(id)sender {
    [self shoeboxDocumentNicelyCompletionHandler:^(BkmxDoc* bkmxDoc) {
        [[bkmxDoc bkmxDocWinCon] revealTabViewIdentifier:constIdentifierTabViewDiaries] ;
    }] ;
}

- (IBAction)shoeboxSetUpSync:(id)sender {
    switch ([[BkmxBasis sharedBasis] iAm]) {
        case BkmxWhich1AppSmarky:
        case BkmxWhich1AppSynkmark:
            [(BkmxAppDel*)[NSApp delegate] preferences:self] ;
            [(PrefsWinCon*)[(BkmxAppDel*)[NSApp delegate] prefsWinCon] revealTabViewIdentifier1:constIdentifierTabViewPrefsSyncing
                                                                                    identifier2:nil] ;
            break ;
        case BkmxWhich1AppMarkster:
        case BkmxWhich1AppBookMacster:
            NSLog(@"Internal Error 241-0948") ;
            break ;
    }
}

- (IBAction)shoeboxToggleSync:(id)sender {
    [self shoeboxDocumentNicelyCompletionHandler:^(BkmxDoc* bkmxDoc) {
        [[bkmxDoc macster] toggleSync] ;
    }] ;
}

- (IBAction)checkForUpdate:(id)sender {
    [[Sparkler shared] checkForUpdates];
}

- (IBAction)preferences:(id)sender {
	[[self prefsWinCon] showWindow:self] ;
}

- (IBAction)showMiniSearchWindow:(NSMenuItem*)menuItem {
    [[self miniSearchWinCon] showWindow:self] ;
}

- (IBAction)showShoeboxWindow:(id)sender {
    [[NSDocumentController sharedDocumentController] shoeboxDocumentForcibly:YES
                                                           completionHandler:NULL] ;
}

- (IBAction)orderFrontCustomAboutPanel: (id) sender {
	SSYAboutPanelController* instance = [SSYAboutPanelController sharedInstance] ;
    [instance showPanel];
}

- (IBAction)support:(id)sender {
	[SSWebBrowsing browseToURLString:constSupportUrl
			 browserBundleIdentifier:nil
							activate:YES] ;
}

- (IBAction)videoTutorials:(id)sender {
	[SSWebBrowsing browseToURLString:constSupportArticlesUrl
			 browserBundleIdentifier:nil
							activate:YES] ;
}

- (IBAction)visitForum:(id)sender {
    NSString* appNameLower = [[[BkmxBasis sharedBasis] appNameUnlocalized] lowercaseString] ;
	[SSWebBrowsing browseToURLString:[constForumUrl stringByAppendingString:appNameLower]
			 browserBundleIdentifier:nil
							activate:YES] ;
}

- (IBAction)showLogs:(id)sender {
#if 0
#warning Hijacked showLogs:
    NSMutableString* s = [[NSMutableString alloc] initWithString:@"Hello"] ;
    [s appendString:@" World"] ;
    [s release] ;
    [s release] ;
    NSLog(@"Here you go: %@", s) ;
    return ;
#endif
	[[self logsWinCon] showWindow:self] ;
}

- (IBAction)licenseBuy:sender {
	[SSYLicenseBuyController showWindow] ;
}

- (IBAction)licenseInfo:sender {
	[SSYLicenseInfoController showWindow] ; 
}

- (IBAction)resetApp:sender {
	[Uninstaller reset] ;
}

- (IBAction)uninstallApp:sender {
    [Uninstaller uninstall] ; 
}

- (IBAction)licenseInfoRetryDownload:sender {
	[SSYLicensor retrieveInfoFromPublisher];
}

- (IBAction)licenseInfoLostRequest:sender {
	[SSWebBrowsing browseToURLString:constLicensingParmsLostInfoRequestUrl
			 browserBundleIdentifier:nil
							activate:YES] ;
}

- (IBAction)inspectorShowOrNot:(id)sender {
	BOOL currentState = [self inspectorShowing] ;
	BOOL desiredState = NO ;
	if ([sender respondsToSelector:@selector(value)]) {
		// sender is the Inspector button on the toolbar
		desiredState = (currentState == NSControlStateValueOn) ? NSControlStateValueOff : NSControlStateValueOn ;
	}
	else if ([sender isKindOfClass:[NSMenuItem class]]){
        // sender is the main menu > Selection > Show Inspector menu item.
        // This method is called before the state changes, so we negate:
        desiredState = !currentState ;
    }
    else {
        NSLog(@"Internal Error 644-8209 %@", sender) ;
    }
    
    [self doShowInspector:desiredState] ;
}

#if 0
#warning Purchasing is disabled
#define PURCHASING_ENABLED NO
#else
#define PURCHASING_ENABLED YES
#endif

- (BOOL)validateUserIinterfaceItem:(NSMenuItem*)item {
	BOOL enabled = YES ;
	switch ([item tag]) {
		case 1230:
			// License Info
			enabled = PURCHASING_ENABLED ;
			break ;
		case 1210:;
			// Try or Buy
			SSYLicenseLevel licenseLevel = SSYLCCurrentLevel() ;
			enabled = ((licenseLevel != SSYLicenseLevelRegular) && PURCHASING_ENABLED) ;
			break ;
		case 1252:
			// Request Lost License Info
			enabled = YES ;
			break ;
		case 1250:
			// Retry Download License Info
			enabled = ([[NSUserDefaults standardUserDefaults] objectForKey:constKeyLicensingUuid] != nil) ;
			break ;
		/* As of 0.9.22, Empty Cache... is always enabled.  This is because
			 it would greatly increase the expense of running this method by
			 accessing keychain, and this method is invoked typically 100 times
			 during the first minute by the KeyCue app (verison 4.5).  This made
			 BookMacster run really slow for the first minute.		Here is the old code:
	    case 1520:
			 // Empty Cache...
			 enabled = ([[Clientoid allClientoidsWithSqliteStores] count] > 0) ;
			 break ;
			 */
	}
	
	return enabled ;
}

- (IBAction)dumpAndCrash:(id)sender {
    [self dumpClasses] ;
    [self crash] ;
}

- (IBAction)troubleZipper:(id)sender {
    [self dumpClasses];
    [self writeSyncingStatusReportToFileThenDo:^{
        [SSYTroubleZipper getAndRun];
    }];
}

- (IBAction)touchSafariBookmarks:(id)sender {
    NSError* error = nil;
    BOOL ok = [ExtoreSafari touchBookmarksPlistError_p:&error];
    if (ok) {
        NSString* msg = NSLocalizedString(@"The Safari bookmarks file has just been touched.  If Safari was being watched by Syncing, if you look in this app's Logs window and hit the round refresh button, you should see a bunch of new log entries, beginning with:\n\nSaw: Path touched: /Users/jk/Library/Safari/Bookmarks.plist\n\nThere may be several such bunches, as Safari or iCloud may respond with additional touches.", nil);
        [SSYAlert runModalDialogTitle:nil
                              message:msg
                              buttons:nil];
    } else {
        [SSYAlert alertError:error];
    }
}

- (void)showSyncingStatus:(id)sender {
    [self showSyncingStatus];
}

- (IBAction)rebootSyncAgent:(id)sender {
    [[NSUserDefaults standardUserDefaults] removeAllWatchesExceptDocUuid:nil];
    [BkmxBasis sharedBasis].manualAgentRebootInProgress  = YES;
    [self realizeSyncersOfAllDocumentsToWatchesThenDo:^{
        NSError* error = nil;
        NSString* report = nil;
        NSString* title = nil;

        [[BkmxBasis sharedBasis] rebootSyncAgentReport_p:&report
                                                 title_p:&title
                                                 error_p:&error];
        [BkmxBasis sharedBasis].manualAgentRebootInProgress  = NO;

        if ([[NSThread currentThread] isMainThread]) {
            [self displayRebootSyncTitle:title
                                  report:report
                                   error:error];
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self displayRebootSyncTitle:title
                                      report:report
                                       error:error];
            });
        }

        [[BkmxBasis sharedBasis] logError:error
                          markAsPresented:NO];
    }];
}

- (void)displayRebootSyncTitle:(NSString*)title
                        report:(NSString*)report
                         error:(NSError*)error {
    NSString* msg = report;

    if (error) {
        /* Since this should be quite rare, display the long description,
         for the developer to see :) */
        msg = [msg stringByAppendingFormat:
               @"\n\n\n%@\n\n%@",
               NSLocalizedString(@"Error:", nil),
               [error longDescription]
               ];
    }

    SSYAlert* alert = [SSYAlert new];
    [alert setIconStyle:SSYAlertIconNoIcon];
    if (error) {
        [alert setTitleText:title];
    } else {
        [alert setTitleText:title];
    }
    alert.smallText = msg;

    [alert setButton1Title:NSLocalizedString(@"Done", nil)];
    [alert setButton2Title:NSLocalizedString(@"Copy to Clipboard", nil)];
    [alert setClickTarget:self] ;
    [alert setClickSelector:@selector(handleClickWithClipboardButtonAlert:)];
    [alert doooLayout];
    [alert setDontGoAwayUponButtonClicked:YES];
    [alert display];
    [alert release];
}

#if 0
- (IBAction)logAliasRecords:(id)sender {
	NSString* stringOut = nil ;
	NSString* logFilename = @"BookMacster_Test_Result.txt" ;
	NSString* msg ;
	msg = @"This is a special debugging function to help with a particular problem.  "
	@"Don't do this unless our Support team asked you to." ;
	NSInteger alertReturn = [SSYAlert runModalDialogTitle:nil
												  message:msg
												  buttons:@"Don't", @"Do", nil] ;
	if (alertReturn != NSAlertSecondButtonReturn) {
		return ;    
	}
	
	NSDictionary* docAliasRecords = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppValueForKey:constKeyDocAliasRecords] ;
	NSString* nonstarterError = nil ;
	
	if (!docAliasRecords) {
		nonstarterError = @"Could not get doc alias records" ;
		goto end ;
	}	
	if (![docAliasRecords respondsToSelector:@selector(objectForKey:)]) {
		nonstarterError = [NSString stringWithFormat:
						   @"Expected dictionary for docAliasRecords, got %@",
						   [docAliasRecords className]] ;
		goto end ;
	}
	
	
	NSMutableDictionary* paths = [NSMutableDictionary dictionary] ;
	NSMutableDictionary* errors = [NSMutableDictionary dictionary] ;
	for (NSString* uuid in docAliasRecords) {
		NSError* error = nil ;
		NSData* docAliasRecord = [docAliasRecords objectForKey:uuid] ;
		NSString* docPath = [docAliasRecord pathFromAliasRecordWithTimeout:120.0
																   error_p:&error] ;
		if (!docPath) {
			docPath = @"Sorry, nil path" ;
		}
		[paths setObject:docPath
				  forKey:uuid] ;
		if (!error) {
			error = [NSError errorWithDomain:@"SSYNoErrorErrorDomain"
										code:0
									userInfo:[NSDictionary dictionaryWithObject:@"No error"
																		 forKey:NSLocalizedDescriptionKey]] ;
		}
		[errors setObject:error
				   forKey:uuid] ;
	}
	
	NSMutableDictionary* output = [NSMutableDictionary dictionary] ;
	[output setObject:docAliasRecords
			   forKey:constKeyDocAliasRecords] ;
	[output setObject:paths
			   forKey:@"paths"] ;
	[output setObject:errors
			   forKey:@"errors"] ;
	
	stringOut = [output longDescription] ;
	
end:;
	NSString* logPath ;
	logPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Desktop"] ;
	logPath = [logPath stringByAppendingPathComponent:logFilename] ;
	if (stringOut) {
		[stringOut writeToFile:logPath
					atomically:NO
					  encoding:NSUTF8StringEncoding
						 error:NULL] ;
	}
	else if (nonstarterError) {
		[nonstarterError writeToFile:logPath
						  atomically:NO
							encoding:NSUTF8StringEncoding
							   error:NULL] ;
	}
	
	msg = [NSString stringWithFormat:
		   @"Please send our support team the following file which should have been written to your Desktop:\n   %@",
		   logFilename] ;
	[SSYAlert runModalDialogTitle:nil
						  message:msg
						  buttons:nil] ;	
}	
#endif

/* Note 982343
This note explains why, as of BookMacster 1.6.2, I make these submenus completely in code when needed,
 and setSubmenu:nil when not needed, instead of instantiating them in the nib.  Another acceptable
 alternative would have been to instantiate them in the nib, and stash them in instance variables
 when not needed (in case they were needed again later), but I thought that making them in code
 when needed was cleaner.
 
 A crash would occur sometimes if I launch or quit BookMacster with AppleScript while opening or
 closing documents.  It would also sometimes occur if I did this manually.
 
 A similar (but not the same call stack) crash was reported and fixed in Google's Chromium code:
 
 http://code.google.com/p/chromium/issues/detail?id=33890
 
 Relevant snippets from that entry:
 
 *  *  *
 
 OK, I can repro it. I guessed this might happen on first run, so I nuked all my Chromium 
 settings, launched, declined importing bookmarks, then immediately moused down in the 
 menu bar as soon as the browser window appeared. If you wait a second before bringing 
 up the menu, there's no crash.
 
 The problem is that GetBookmarkModel()->GetBookmarkBarNode() returns NULL, and 
 UpdateMenu then tries to dereference that. 
 
 In a flash of brilliance I solved the crash as follows: call model->IsLoaded() and do 
 nothing if not. 
 
 *  *  *
 
 Here's the crash I was seeing:
 
 #0	0x99e2df98 in objc_msgSend
 #1	0x00040400 in -[ContentDataSource outlineView:objectValueForTableColumn:byItem:] at ContentDataSource.m:395
 #2	0x98ebcce4 in -[NSCarbonMenuImpl _carbonPopulateEvent:handlerCallRef:]
 #3	0x98ebca55 in NSSLMMenuEventHandler
 #4	0x99af1c2f in DispatchEventToHandlers
 #5	0x99af0ef6 in SendEventToEventTargetInternal
 #6	0x99af0d55 in SendEventToEventTargetWithOptions
 #7	0x99b3dc67 in SendMenuPopulate
 #8	0x99b3d523 in SendMenuOpening
 #9	0x99ce3b50 in _SimulateMenuOpening
 #10	0x99cd85ba in OpenMenuForInspection
 #11	0x99cd89ff in MenuData::HandleGetNamedAccessibleAttribute
 #12	0x99cd9a42 in MenuData::ContentViewGetNamedAccessibleAttribute
 #13	0x99b7a510 in HIObject::DispatchAccessibilityEvent
 #14	0x99cd6e0b in MenuData::MenuContentViewAccessibilityHandler
 #15	0x99af1c2f in DispatchEventToHandlers
 #16	0x99af0ef6 in SendEventToEventTargetInternal
 #17	0x99af0d55 in SendEventToEventTargetWithOptions
 #18	0x99b893f6 in Accessible::SendEvent
 #19	0x99b8a804 in Accessible::GetNamedAttributeData
 #20	0x99b8aa4d in HLTBCopyUIElementAttributeValue
 #21	0x99cd9ad1 in MenuData::GetNamedAccessibleAttributeSelf
 #22	0x99b7a510 in HIObject::DispatchAccessibilityEvent
 #23	0x99b7a0ac in HIObject::HandleClassAccessibilityEvent
 #24	0x99af2216 in HIObject::EventHook
 #25	0x99af1c2f in DispatchEventToHandlers
 #26	0x99af0ef6 in SendEventToEventTargetInternal
 #27	0x99af0d55 in SendEventToEventTargetWithOptions
 #28	0x99b893f6 in Accessible::SendEvent
 #29	0x99b8a804 in Accessible::GetNamedAttributeData
 #30	0x99b8aa4d in HLTBCopyUIElementAttributeValue
 #31	0x99b8aae1 in CarbonCopyAttributeValueCallback
 #32	0x990ee1e7 in CopyCarbonUIElementAttributeValue
 #33	0x990f1627 in CopyAttributeValue
 #34	0x97a317fd in _AXXMIGCopyAttributeValue
 #35	0x97a3d8c3 in _XCopyAttributeValue
 #36	0x97a0e041 in mshMIGPerform
 #37	0x9281e46b in __CFRunLoopRun
 #38	0x9281c3f4 in CFRunLoopRunSpecific
 #39	0x9281c221 in CFRunLoopRunInMode
 #40	0x99b1ee04 in RunCurrentEventLoopInMode
 #41	0x99b1eaf5 in ReceiveNextEventCommon
 #42	0x99b1ea3e in BlockUntilNextEventMatchingListInMode
 #43	0x98e8a595 in _DPSNextEvent
 #44	0x98e89dd6 in -[NSApplication nextEventMatchingMask:untilDate:inMode:dequeue:]
 #45	0x98e4c1f3 in -[NSApplication run]
 #46	0x98e44289 in NSApplicationMain
 #47	0x00001dd5 in main at MainApp-Main.m:49
 
 The behavior in -[ContentDataSource outlineView:objectValueForTableColumn:byItem:] is anomalous.
 Sometimes this method does not appear in the stack.  Sometimes, it goes into an infinite loop
 in that method.  The couple times when I was able to stop it in gdb, in
 -[ContentDataSource outlineView:objectValueForTableColumn:byItem:], I saw that self, the parameters,
 and all of the local variables are either invalid objects or null.  Apparently, it ends up there
 because the program counter got smashed.  Conclusion: I'm not worried about this method.
 
 I did a class dump on the method below that in the stack,
 -[ContentDataSource outlineView:objectValueForTableColumn:byItem:], and found that it has a
 -menu method, and indeed this returns an NSMenu.  More than once, I've found that the NSMenu
 it returns is my "Import from only >" menu in BookMacster's File menu.  This method is dynamically
 updated by -menuNeedsUpdate:, and, on my Mac, because I have alot of web app accounts for
 testing, contains quite a few items, 32.  However, in gdb, I can send it messages with no error,
 as shown in this gdb session transcript:
 
 (gdb) po [0xa10990 itemArray]
 <NSCFArray 0x194f1fb0>(
 <NSMenuItem: 0x1a24bee0 Camino>,
 <NSMenuItem: 0x1924d430 Chrome (QuickMerge – No Delete)>,
 <NSMenuItem: 0x1924cb50 Chrome (Client Settings)>,
 <NSMenuItem: 0x19237a60 Chromium>,
 <NSMenuItem: 0x1a309570 Delicious-Old-Skool - New/Other>,
 <NSMenuItem: 0x1923cdf0 Delicious-Old-Skool (jerry@ieee.org)>,
 <NSMenuItem: 0x19239a90 Delicious-Old-Skool (jerrykrinock)>,
 <NSMenuItem: 0xaf88f0 Delicious-Yahoo! - New/Other>,
 <NSMenuItem: 0x1a25a840 Delicious-Yahoo! (jerry@ieee.org)>,
 <NSMenuItem: 0x1a3b5290 Delicious-Yahoo! (jerryYahoo)>,
 <NSMenuItem: 0x1a3bef40 Firefox>,
 <NSMenuItem: 0x1a24c1a0 Firefox (dev)>,
 <NSMenuItem: 0x1a226e90 Firefox (test)>,
 <NSMenuItem: 0x1a328df0 Firefox (virgin)>,
 <NSMenuItem: 0xae7180 Firefox (virgin4)>,
 <NSMenuItem: 0x1a3b7f20 Google Bookmarks - New/Other>,
 <NSMenuItem: 0x1925ef30 Google Bookmarks (bookmarks522@gmail.com)>,
 <NSMenuItem: 0x19228bc0 Google Bookmarks (jerry@ieee.org) (QuickMerge – No Delete)>,
 <NSMenuItem: 0x1924b2f0 Google Bookmarks (jerry@ieee.org) (Client Settings)>,
 <NSMenuItem: 0x1924c0d0 Google Bookmarks (jerry@sheepsystems.com)>,
 <NSMenuItem: 0x19240060 Google Bookmarks (jerrykrinock@gmail.com)>,
 <NSMenuItem: 0x1a217700 iCab>,
 <NSMenuItem: 0x19238580 OmniWeb>,
 <NSMenuItem: 0x1a302050 Opera>,
 <NSMenuItem: 0x1a332bb0 Pinboard - New/Other>,
 <NSMenuItem: 0xaf8390 Pinboard (jerry@ieee.org)>,
 <NSMenuItem: 0x1925e1c0 Pinboard (jerrykrinock)>,
 <NSMenuItem: 0xaf44c0 Safari (QuickMerge – No Delete)>,
 <NSMenuItem: 0x1a32bf30 Safari (Client Settings)>,
 <NSMenuItem: 0xaa7650 Shiira>,
 <NSMenuItem: 0x1a32f9d0 ➤ Other Macintosh User Account>,
 <NSMenuItem: 0x19477d20 ➤ Choose File (Advanced)>
 )
 
 (gdb) p (int)[0xa10990 numberOfItems]
 $2 = 32
 (gdb) po [0xa10990 supermenu]
 <NSMenu: 0xa10160>
 Title: File
 Supermenu: 0xa12310 (MainMenu), autoenable: YES
 Items:     (
 <NSMenuItem: 0xa10180 New Collection>,
 <NSMenuItem: 0xa10240 Open>,
 <NSMenuItem: 0xa10280 Open Recent, submenu: 0xa102e0 (Open Recent)>,
 <NSMenuItem: 0xa104e0 >,
 <NSMenuItem: 0xa10520 Close>,
 <NSMenuItem: 0xa10560 Close and Trash…>,
 <NSMenuItem: 0xa0fed0 Save>,
 <NSMenuItem: 0xa105a0 Save As…>,
 <NSMenuItem: 0xa105e0 Save As Move…>,
 <NSMenuItem: 0xa10640 Save All>,
 <NSMenuItem: 0xa106a0 Revert>,
 <NSMenuItem: 0xa106f0 >,
 <NSMenuItem: 0xa0d720 Import from only, submenu: 0xa10990 (importOnly)>,
 <NSMenuItem: 0xa0d780 Export to only, submenu: 0xa10a80 (exportOnly)>,
 <NSMenuItem: 0xa0d820 Export Bookmarklet to, submenu: 0xa10b50 (exportBookMacsterizeBookmarklet)>
 )
 (gdb) po [0xa10990 title]
 importOnly
 (gdb) p (int)[0xa10990 showsStateColumn]
 $3 = 1
 (gdb) po [0xa10990 delegate] 
 
 Whoops.  It didn't like that one.  It caused gdb to freeze.  When I hit 'enter', I just get
 a blank line.  Hitting the 'Continue' button, multiple times, does not do anything either.
 According to Activity Monitor, -[ContentDataSource outlineView:objectValueForTableColumn:byItem:]
 was replaced on the top of the call stack by 'start' and then objc_msgSend.  That's correct;
 I now have the function 'start' twice in my call stack, one at the top and one at the bottom…
 
 Sampling process 20251 for 3 seconds with 1 millisecond of run time between samples
 Sampling completed, processing symbols...
 Analysis of sampling BookMacster (pid 20251) every 1 millisecond
 Call graph:
 2373 Thread_144608   DispatchQueue_1: com.apple.main-thread  (serial)
 2373 start
 2373 main
 2373 NSApplicationMain
 2373 -[NSApplication run]
 2373 -[NSApplication nextEventMatchingMask:untilDate:inMode:dequeue:]
 2373 _DPSNextEvent
 2373 BlockUntilNextEventMatchingListInMode
 2373 ReceiveNextEventCommon
 2373 RunCurrentEventLoopInMode
 2373 CFRunLoopRunInMode
 2373 CFRunLoopRunSpecific
 2373 __CFRunLoopRun
 2373 mshMIGPerform
 2373 _XCopyAttributeValue
 2373 _AXXMIGCopyAttributeValue
 2373 CopyAttributeValue
 2373 CopyCarbonUIElementAttributeValue
 2373 CarbonCopyAttributeValueCallback(__CFData const*, unsigned long, __CFString const*, void const**, void*)
 2373 HLTBCopyUIElementAttributeValue
 2373 Accessible::GetNamedAttributeData(__CFString const*, void const*, void const**, unsigned char*)
 2373 Accessible::SendEvent(OpaqueEventRef*, bool) const
 2373 SendEventToEventTargetWithOptions
 2373 SendEventToEventTargetInternal(OpaqueEventRef*, OpaqueEventTargetRef*, HandlerCallRec*)
 2373 DispatchEventToHandlers(EventTargetRec*, OpaqueEventRef*, HandlerCallRec*)
 2373 HIObject::EventHook(OpaqueEventHandlerCallRef*, OpaqueEventRef*, void*)
 2373 HIObject::HandleClassAccessibilityEvent(OpaqueEventHandlerCallRef*, OpaqueEventRef*, void*)
 2373 HIObject::DispatchAccessibilityEvent(OpaqueEventRef*, unsigned long long, AccessibilityHandlers const*, void*)
 2373 MenuData::GetNamedAccessibleAttributeSelf(unsigned long long, __CFString const*, unsigned long, OpaqueEventRef*)
 2373 HLTBCopyUIElementAttributeValue
 2373 Accessible::GetNamedAttributeData(__CFString const*, void const*, void const**, unsigned char*)
 2373 Accessible::SendEvent(OpaqueEventRef*, bool) const
 2373 SendEventToEventTargetWithOptions
 2373 SendEventToEventTargetInternal(OpaqueEventRef*, OpaqueEventTargetRef*, HandlerCallRec*)
 2373 DispatchEventToHandlers(EventTargetRec*, OpaqueEventRef*, HandlerCallRec*)
 2373 MenuData::MenuContentViewAccessibilityHandler(OpaqueEventHandlerCallRef*, OpaqueEventRef*, void*)
 2373 HIObject::DispatchAccessibilityEvent(OpaqueEventRef*, unsigned long long, AccessibilityHandlers const*, void*)
 2373 MenuData::ContentViewGetNamedAccessibleAttribute(unsigned long long, __CFString const*, unsigned long, OpaqueEventRef*, void*)
 2373 MenuData::HandleGetNamedAccessibleAttribute(unsigned long long, __CFString const*, unsigned long, OpaqueEventRef*)
 2373 OpenMenuForInspection(MenuData*)
 2373 _SimulateMenuOpening
 2373 SendMenuOpening(MenuSelectData*, MenuData*, double, unsigned long, __CFDictionary*, unsigned char, unsigned char*)
 2373 SendMenuPopulate(MenuData*, OpaqueEventTargetRef*, unsigned long, double, unsigned long, OpaqueEventRef*, unsigned char*)
 2373 SendEventToEventTargetWithOptions
 2373 SendEventToEventTargetInternal(OpaqueEventRef*, OpaqueEventTargetRef*, HandlerCallRec*)
 2373 DispatchEventToHandlers(EventTargetRec*, OpaqueEventRef*, HandlerCallRec*)
 2373 NSSLMMenuEventHandler
 2373 -[NSCarbonMenuImpl _carbonPopulateEvent:handlerCallRef:]
 2373 start
 2373 
 
 Maybe the delegate is no good?
 
 6/10 times crashed when running a certain script, which I could later not reproduce
 
 To try and fix it, I added this code:
 
 if (!currentBkmxDocWincon) {
 [item setSubmenu:nil] ;
 }
 
 to the One-Time Import menu along with two other similar menus (tags 580, 585, 587).
 
 Result:
 
 1/10 times crashed doing this same certain thing.
 
 But now it crashed in different menu with a submenu, tag 4362.  So, now I've added
 the same fix to menus with tag 4360 and 4362.
 
 I hope it's fixed :))
*/

- (IBAction)manageAddOns:sender {
    if ([SSYEventInfo alternateKeyDown]  && [SSYEventInfo shiftKeyDown] && [SSYEventInfo commandKeyDown]) {
        // The following is needed to test unpacked browser extensions
        ((BkmxAppDel*)[NSApp delegate]).relaxedExtensionDetection = YES;
    }
    [ExtensionsWinCon showWindow];
}

- (IBAction)cleanExcessSyncSnapshots:(id)sender {
	[Extore cleanExcessSyncSnapshots] ;
}

- (IBAction)emptyCache:(id)sender {
	NSArray* clientoids = [[Clientoid allClientoidsWithSqliteStores] arraySortedByStringValueForKey:@"displayName"] ;
	NSString* msg ;
	
	// Pick Sources
	msg = [NSString stringWithFormat:
		   @"%@\n\n%@",
		   [[BkmxBasis sharedBasis] labelCacheDefine],
		   [[BkmxBasis sharedBasis] labelCacheEmptyDef]] ;
	if ([clientoids count] > 0) {
		// There are caches available to clear
		[[SSYListPicker listPicker] userPickFromList:[clientoids valueForKey:@"displayName"]
											toolTips:nil
									   lineBreakMode:NSLineBreakByTruncatingMiddle
											 message:msg
							  allowMultipleSelection:YES
								 allowEmptySelection:NO
										button1Title:[[BkmxBasis sharedBasis] labelEmpty]
										button2Title:nil
										initialPicks:nil
										 windowTitle:[[BkmxBasis sharedBasis] labelEmptyCache]
											   alert:nil
                                                mode:SSYAlertModeModalSession
										didEndTarget:self
									  didEndSelector:@selector(emptyCachePart2SelectedIndexes:clientoidsArray:)
									  didEndUserInfo:clientoids
								 didCancelInvocation:nil] ;
	}
	else {
		// No caches available at this time.
		msg = [msg stringByAppendingString:@"\n\n---\n\n"] ;
		msg = [msg stringByAppendingString:[NSString localize:@"cacheNoneNow"]] ;
		[SSYAlert runModalDialogTitle:[[BkmxBasis sharedBasis] labelEmptyCache]
							  message:msg
							  buttons:nil] ;
	}
}

- (void)emptyCachePart2SelectedIndexes:(NSIndexSet*)selectedIndexes
                       clientoidsArray:(NSArray*)clientoids {
	NSArray* doomedIdentifiers = [[clientoids objectsAtIndexes:selectedIndexes] valueForKeyPath:constKeyClidentifier] ;
	
	for (NSString* identifier in doomedIdentifiers) {
		[SSYMOCManager removeSqliteStoreForIdentifier:identifier] ;
	}
}

- (IBAction)stopAllSyncing:(id)sender {
    [self stopAllSyncingEllipsis];
}

- (IBAction)inspectStark:(NSMenuItem*)sender {
    Stark* stark = [sender representedObject] ;
    [self setSelectedStark:stark] ;
    Starki* starki = [Starki starkiWithStarks:[NSArray arrayWithObject:stark]] ;
	[self setSelectedStarki:starki] ;
    [self showInspectorWithOomph] ;
}

@end

