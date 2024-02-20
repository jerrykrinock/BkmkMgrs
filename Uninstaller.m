#import "Uninstaller.h"
#import "NSFileManager+SomeMore.h"
#import "NSString+MorePaths.h"
#import "ExtensionsMule.h"
#import "SSYLaunchdGuy.h"
#import "SSYAlert.h"
#import "BkmxBasis+Strings.h"
#import "BkmxDoc.h"
#import "Clientoid.h"
#import "NewUserSetupWinCon.h"
#import "SSYLicensePersistor.h"
#import "BkmxAppDel.h"
#import "SSYLicense.h"
#import "SSYAppInfo.h"
#import "SSYAppInfo.h"
#import "SSYMH.AppAnchors.h"
#import "NSBundle+SSYMotherApp.h"
#import "SSYShellTasker.h"
#import "NSString+SSYDotSuffix.h"
#import "SSYLabelledList.h"
#import "NSArray+SSYMutations.h"
#import "SSYCachyAliasResolver.h"
#import "SSYAlert.h"
#import "Chromessengerer.h"

@interface Uninstaller ()

@property (retain) NSDictionary* extensionsResults ;

@end

@implementation Uninstaller

@synthesize extensionsResults = m_extensionsResults ;

- (NSMutableString*)log {
	if (!m_log) {
		m_log = [[NSMutableString alloc] init] ;
	}
	
	return m_log ;
}

- (ExtensionsMule*)mule {
	if (!m_mule) {
		m_mule = [[ExtensionsMule alloc] initWithDelegate:self] ;
	}
	
	return m_mule ;
}

- (void)showResultsQuitTrashPrefsAndExit {
	NSDictionary* results = [self extensionsResults] ;
	BOOL ok = YES ;
	for (NSString* clidentifier in results) {
		NSDictionary* result = [results objectForKey:clidentifier] ;
		if ([result count] > 0) {
			Clientoid* clientoid = [Clientoid clientoidWithClidentifier:clidentifier] ;
			[[self log] appendFormat:
			 @"\n*** Warning: Browser addon for %@ might not have been uninstalled.\n",
			 [clientoid displayName]] ;
			ok = NO ;
		}
	}
	if (ok) {
		[[self log] appendString:@"\nAll browser extensions appear to have been removed.\n"] ;
	}
	
    // The following is required for the prefs file to remain trashed
    // and not reappear.  I don't know exactly why; certainly something to do
    // with prefs caching in Mavericks.  A temporary prefs file, with name
    // ending in .plist.xxxxxx or something like that, appears momentarily.
    // This delay happens three times (see below).  I think that maybe the
    // third one is overkill, but I was getting inconsistent results.
    // Possibly it can be shortened and/or run fewer than three times
    NSInteger finalDelay = 5 ;
    
	[[self log] appendString:
	 [NSString stringWithFormat
      :@"\n"
      @"Click 'Bye-Bye' to quit and trash the currently-running %@ application's package and the preferences file, and quit.  It will take about %ld seconds",
      [[BkmxBasis sharedBasis] appNameLocalized],
      (long)(3 * finalDelay)]] ;
	
	[SSYAlert runModalDialogTitle:@"Uninstall Results"
						  message:[self log]
						  buttons:@"Bye-bye!", nil] ;

    NSUserDefaults* sud = [NSUserDefaults standardUserDefaults ] ;
    NSArray* installedKeys = (NSArray*)CFPreferencesCopyKeyList(
                                                                (CFStringRef)[[NSBundle mainBundle] bundleIdentifier],
                                                                kCFPreferencesCurrentUser,
                                                                kCFPreferencesAnyHost
                                                                ) ;
    for (NSString* key in installedKeys) {
        [sud removeObjectForKey:key] ;
    }
    [installedKeys release] ;
    [sud synchronize] ;
	
	NSString* path ;
    
	path = [NSString libraryPathForHomePath:NSHomeDirectory()] ;
	path = [path stringByAppendingPathComponent:@"Preferences"] ;
	path = [path stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]] ;
	path = [path stringByAppendingDotSuffix:@"LSSharedFileList"] ;
	path = [path stringByAppendingPathExtension:@"plist"] ;
	[[NSFileManager defaultManager] trashPath:path
								 scriptFinder:YES
									  error_p:NULL] ;
    
    sleep((unsigned int)finalDelay) ;
    
    // For some strange reason, the following logs:
    //   Domain (com.sheepsystems.Synkmark) not found.
    //   Defaults have not been changed.
    // But it's the "right thing to do", so I do it anyhow.
    NSString* command = @"/usr/bin/defaults" ;
    NSArray* args = [NSArray arrayWithObjects:
                     @"delete",
                     [[NSBundle mainBundle] bundleIdentifier],
                     nil] ;
    [SSYShellTasker doShellTaskCommand:command
                             arguments:args
                           inDirectory:nil
                             stdinData:nil
                          stdoutData_p:NULL
                          stderrData_p:NULL
                               timeout:0.0  // return immediately
                               error_p:NULL] ;
    
    sleep((unsigned int)finalDelay) ;

    // Trash the now-empty prefs file
	// Had we tried to trash the prefs earlier, Cocoa may have recreated
	// for some reason.
	path = [NSString libraryPathForHomePath:NSHomeDirectory()] ;
	path = [path stringByAppendingPathComponent:@"Preferences"] ;
	path = [path stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]] ;
	path = [path stringByAppendingPathExtension:@"plist"] ;
	[[NSFileManager defaultManager] trashPath:path
								 scriptFinder:YES
									  error_p:NULL] ;

    sleep((unsigned int)finalDelay) ;
    
    // Trash the now-empty prefs file AGAIN
	path = [NSString libraryPathForHomePath:NSHomeDirectory()] ;
	path = [path stringByAppendingPathComponent:@"Preferences"] ;
	path = [path stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]] ;
	path = [path stringByAppendingPathExtension:@"plist"] ;
	[[NSFileManager defaultManager] trashPath:path
								 scriptFinder:YES
									  error_p:NULL] ;
    
    // Trash this app
	// Had we trashed the app earlier, at least when running in Xcode,
	// it sometimes crashed.
	path = [[NSBundle mainBundle] bundlePath] ;
	[[NSFileManager defaultManager] trashPath:path
								 scriptFinder:YES
									  error_p:NULL] ;	
	
	// Technically, we should do this here, but it doesn't matter
	// [self release] ;
	
	// Don't use -[NSApp terminate:] here because it might cause the prefs
	// file which we just trashed to be recreated.  Do this instead:
	exit(0) ;
}

- (void)dealloc {
	[m_log release] ;
	[m_mule release] ;
    [m_extensionsResults release] ;
	
	[super dealloc] ;
}

- (void)uninstallAllAddOns {
	ExtensionsMule* mule = [self mule] ;
	[mule uninstallAllExtensions] ;
}

- (void)closeAllOpenDocuments {
	for (BkmxDoc* document in [[NSDocumentController sharedDocumentController] documents]) {
		[document close] ;
	}
}

- (void)trashAllKnownDocumentsAndTheirLocalDataExceptThoseOfAppNames:(NSSet*)exceptAppNames {
    NSError* error = nil ;
    NSDictionary* aliasRecords = [[NSUserDefaults standardUserDefaults] objectForKey:constKeyDocAliasRecords] ;
    NSMutableSet* defunctUuids = [NSMutableSet new] ;
    NSString* thisAppName = [[BkmxBasis sharedBasis] appNameUnlocalized] ;
    BOOL trashMostDocuments = ![[BkmxBasis sharedBasis] isShoeboxApp] ;
    for (NSString* uuid in [aliasRecords allKeys]) {
        NSData* aliasRecord = [aliasRecords objectForKey:uuid] ;
        NSString* path = [[SSYCachyAliasResolver sharedResolver] pathFromAlias:aliasRecord
                                                                      useCache:YES
                                                                       timeout:3.0
                                                                      lifetime:0.0
                                                                       error_p:NULL] ;
        /* We ignored the error because it is possible to have alias records of
         documents which have been deleted already. */
        
        
        if (path) {
            NSString* basename = [[path lastPathComponent] stringByDeletingPathExtension] ;
            BOOL isThisAppsShoebox = [basename isEqualToString:thisAppName] ;
            BOOL protectThisDocument = [exceptAppNames member:basename] != nil ;
            BOOL trashIt = (isThisAppsShoebox || (trashMostDocuments && !protectThisDocument) ) ;
         
            if (trashIt) {
                [[NSFileManager defaultManager] trashPath:path
                                             scriptFinder:YES
                                                  error_p:&error] ;
                if (error) {
                    [[self log] appendFormat:@"*** Failed to remove document: %@ because %@", path, [error localizedDescription]] ;
                }
                else {
                    [[self log] appendFormat:@"\nTrashed (recent): %@", path] ;
                }
            }
            
            [defunctUuids addObject:uuid] ;
        }
        else {
            [defunctUuids addObject:uuid] ;
        }
	}
    
    NSString* appSupportPath = [[NSBundle mainBundle] applicationSupportPathForMotherApp] ;
    NSArray* filenames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:appSupportPath
                                                                             error:NULL] ;
    for (NSString* filename in filenames) {
        for (NSString* uuid in defunctUuids) {
            if ([[filename stringByDeletingPathExtension] hasSuffix:uuid]) {
                NSString* filePath = [appSupportPath stringByAppendingPathComponent:filename] ;
                [self trashPath:filePath] ;
                break ;
            }
        }
    }
    
    [defunctUuids release] ;
}

- (void)trashPath:(NSString*)path {
    NSError* error = nil ;
	BOOL ok = [[NSFileManager defaultManager] trashPath:path
                                           scriptFinder:YES
                                                error_p:&error] ;
    if (ok) {
        [[self log] appendFormat:@"\nTrashed: %@", path] ;
    }
    else {
        [[self log] appendFormat:@"\nFailed to trash %@ because %@", path, [error localizedDescription]] ;
    }
}

- (void)trashAppSupportButPreserveLogs:(BOOL)preserveLogs {
	NSString* path = [[NSBundle mainBundle] applicationSupportPathForMotherApp] ;
    
    if (preserveLogs) {
        NSArray* filenames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path
                                                                                 error:NULL] ;
        for (NSString* filename in filenames) {
            if (![filename hasPrefix:constBaseNameLogs]) {
                NSString* filePath = [path stringByAppendingPathComponent:filename] ;
                [self trashPath:filePath] ;
            }
        }
    }
    else {
        [self trashPath:path] ;
    }
}

- (void)reset {
	NSString* title = [[BkmxBasis sharedBasis] labelResetAndStartOver] ;
    NSString* removeAgents ;
    switch ([[BkmxBasis sharedBasis] iAm]) {
        case BkmxWhich1AppMarkster:
            removeAgents = @"" ;
            break ;
        default:
            removeAgents = @"\u2022 Remove the BkmxAgent (which runs any Syncers)\n" ;
    }
	NSString* msg = [NSString stringWithFormat:
                     @"Click '%@' to \n\n"
                     "\u2022 Trash any documents you have created in %@\n"
                     "%@"
                     "\u2022 Remove most %@ preferences\n\n"
                     @"and start over as a New User.  "
                     @"(Any license Info will remain.)",
                     title,
                     [[BkmxBasis sharedBasis] appNameLocalized],
                     removeAgents,
                     [[BkmxBasis sharedBasis] appNameLocalized]
                     ] ;

    SSYAlert* alert = [SSYAlert alert] ;
	[alert setWindowTitle:title] ;
    [alert setButton1Title:[[BkmxBasis sharedBasis] labelCancel]] ;
    [alert setButton2Title:title] ;
	[alert setIconStyle:SSYAlertIconCritical] ;
    [alert setHelpAddress:constHelpAnchorResetAndStartOver] ;
	[alert setSmallText:msg] ;
    // So the three bullet points don't line wrap…
    [alert setRightColumnMinimumWidth:400.0] ;
	[alert display] ;
	
	[alert runModalDialog] ;
	
    NSInteger result = [alert alertReturn] ;

	if (result == NSAlertFirstButtonReturn) {
		return ;
	}
	
    [(BkmxAppDel*)[NSApp delegate] stopAllSyncingForApps:BkmxWhichAppsAny];
    [(BkmxAppDel*)[NSApp delegate] setIsResetting:YES];
    [self closeAllOpenDocuments] ;
    [self trashAllKnownDocumentsAndTheirLocalDataExceptThoseOfAppNames:[NSSet setWithArray:[self otherAppNames]]] ;
    [(BkmxAppDel*)[NSApp delegate] setIsResetting:NO] ;
    [self trashAppSupportButPreserveLogs:YES] ;
    
    NSUserDefaults* sud = [NSUserDefaults standardUserDefaults] ;
    
    /* Because there are many more keys I want to delete than those which
    I want to keep, and because many keys are not installed, it is more
     efficient to get all of the installed keys and then delete each, unless
     this is one of the keys I want to keep.
     */
    NSArray* installedKeys = (NSArray*)CFPreferencesCopyKeyList(
                                                                (CFStringRef)[[NSBundle mainBundle] bundleIdentifier],
                                                                kCFPreferencesCurrentUser,
                                                                kCFPreferencesAnyHost
                                                                ) ;
    // Using kCFPreferencesCurrentHost in the above will give
    // the wrong result.
    
    NSMutableSet* keysToKeep = [[NSMutableSet alloc] initWithObjects:
                                constKeyXugradeImported,
                                constKeyColorSortable,
                                constKeyColorUnsortable,
                                constKeyMenuFontSize,
                                constKeyTableFontSize,
                                nil];
    for (NSInteger i=1; i<=[SSYAppInfo currentVersionTriplet].major; i++) {
        [keysToKeep addObject:SSYLCPrefsNameKey(i)];
        [keysToKeep addObject:SSYLCPrefsKeyKey(i)];
    }

    for (NSString* key in installedKeys) {
        if (![keysToKeep member:key]) {
            [sud removeObjectForKey:key] ;
        }
    }
    [keysToKeep release];
    [installedKeys release] ;
    
    [(BkmxAppDel*)[NSApp delegate] registerDefaultDefaults] ;
    
    [sud synchronize] ;
    
    [SSYAppInfo calculateUpgradeState] ;
    // Should be reset to SSYNewUser now.
    
    NSString* helpAnchor = [(BkmxAppDel*)[NSApp delegate] helpAnchorForNewbie] ;
    
    if (helpAnchor) {
        // This is a shoebox app
        [(BkmxAppDel*)[NSApp delegate] openShoeboxDocumentCreateIfNeeded] ;
        [(BkmxAppDel*)[NSApp delegate] openHelpAnchor:helpAnchor] ;
    }
    else {
        // this is BookMacster
        [NewUserSetupWinCon showWindow] ;
    }
    
    if ([[BkmxBasis sharedBasis] iAm] != BkmxWhich1AppSmarky) {
        NSError* error = nil;
        BOOL ok = [Chromessengerer ensureSymlinkError_p:&error] ;
        if (!ok) {
            [SSYAlert alertError:error] ;
        }
    }

    [[BkmxBasis sharedBasis] logFormat:@"****** DID RESET AND START OVER ******"] ;
}

- (NSString*)uninstallDialogTitle {
    NSString* format = NSLocalizedString(@"Uninstall %@", nil) ;
    NSString* title = [NSString stringWithFormat:
                       format,
                       [[BkmxBasis sharedBasis] appNameLocalized]] ;
    return title ;
}

- (NSArray*)otherAppNames {
    NSArray* names = @[constAppNameSmarky,
                       constAppNameSynkmark,
                       constAppNameMarkster,
                       constAppNameBookMacster] ;
    return [names arrayByRemovingObject:[[BkmxBasis sharedBasis] appNameLocalized]] ;
}

- (void)uninstall {
    NSString* msg ;
    
    msg = @"If you have any of our other apps installed, and wish to continue using the other app, select it below so that this Uninstall will preserve the shared components.\n\n"
    @"APPS TO BE PRESERVED, IF INSTALLED:" ;
    NSArray* choices = [self otherAppNames] ;
    SSYLabelledList* labelledList = [SSYLabelledList listWithLabel:NSLocalizedString(msg, nil)
                                                           choices:choices
                                           allowsMultipleSelection:YES
                                              allowsEmptySelection:YES
                                                          toolTips:nil
                                                     lineBreakMode:NSLineBreakByTruncatingMiddle
                                                    maxTableHeight:500.0] ;
    SSYAlert* alert = [SSYAlert alert] ;
    [alert setTitleText:[self uninstallDialogTitle]] ;
    [alert addOtherSubview:labelledList
                   atIndex:0] ;
    alert.noSpaceBetweenOtherSubviews = YES ;
    [alert runModalDialog] ;
    NSArray* appNamesToLeave = [labelledList selectedValues] ;
    
    BOOL leaveBrowserExtensions = (
                                   ([appNamesToLeave indexOfObject:constAppNameSynkmark] != NSNotFound)
                                   || ([appNamesToLeave indexOfObject:constAppNameBookMacster] != NSNotFound)
                                   ) ;
    BOOL leaveAppSupportFolder = [appNamesToLeave count] > 0 ;
    
    NSString* extensionsString = leaveBrowserExtensions ? @"" : @"- Uninstall any of our Browser Extensions and quit the browsers (to unload them).\n" ;
    NSString* docString = [[BkmxBasis sharedBasis] isShoeboxApp] ? @"this app's .bmco document file" : @"all Recent Collections" ;
    NSString* appSupportString = leaveAppSupportFolder ? @"" : @"- Trash the Application Support folder (which is at ~/Library/Application Support/BookMacster).\n\n" ;
    msg = [NSString stringWithFormat:
           @"Click 'Uninstall' to do the following:\n\n"
           @"%@"
           @"- Close and Trash %@.\n"
           @"%@"
           @"\nAfter you click 'Uninstall', %@ will go silent as work is done.  Confirmation will be presented after a minute or so.",
           extensionsString,
           docString,
           appSupportString,
           [[BkmxBasis sharedBasis] appNameLocalized]] ;
    NSInteger result = [SSYAlert runModalDialogTitle:[self uninstallDialogTitle]
                                             message:msg
                                             buttons:
                        [[BkmxBasis sharedBasis] labelCancel],
                        [[BkmxBasis sharedBasis] labelUninstall],
                        nil] ;
    if (result == NSAlertSecondButtonReturn) {
        [self uninstallButLeaveBrowserExtensions:leaveBrowserExtensions
                           leaveAppSupportFolder:leaveAppSupportFolder
                                   leaveAppNames:[NSSet setWithArray:appNamesToLeave]] ;
    }
}

- (void)uninstallButLeaveBrowserExtensions:(BOOL)leaveBrowserExtensions
                     leaveAppSupportFolder:(BOOL)leaveAppSupportFolder
                             leaveAppNames:(NSSet*)appNamesToLeave {
    if (!leaveBrowserExtensions) {
        [self uninstallAllAddOns] ;
    }

    [(BkmxAppDel*)[NSApp delegate] stopAllSyncingForApps:BkmxWhichAppsAny];
    // So that focused apps will not quit when shoebox closes…
    [(BkmxAppDel*)[NSApp delegate] setIsUninstalling:YES] ;
    [self closeAllOpenDocuments] ;
    // The following is to clear out macOS memory of recent documents, which is
    // probably stored in
    // ~/Library/Preferences/com.sheepsystems.<APP_NAME>.LSSharedFileList.plist,
    // so that it won't try to auto-open and report error 153802 in case the
    // app is reinstalled later.  Especially needed for shoebox apps.
    [[NSDocumentController sharedDocumentController] clearRecentDocuments:self] ;
    [self trashAllKnownDocumentsAndTheirLocalDataExceptThoseOfAppNames:appNamesToLeave] ;
    // So that errors won't occur when Logs.sql can't be found…
    [[BkmxBasis sharedBasis] disableLogging] ;
    if (!leaveAppSupportFolder) {
        [self trashAppSupportButPreserveLogs:NO] ;
    }
	
    [[self log] appendFormat:@"\n"] ;
	
	// Wait for results, then quit
	[self performSelector:@selector(showResultsQuitTrashPrefsAndExit)
			   withObject:nil
			   afterDelay:5.0] ;
}

+ (void)uninstall {
	Uninstaller* instance = [[Uninstaller alloc] init] ;
	[instance uninstall] ;
    [instance release] ;
}

+ (void)reset {
	Uninstaller* instance = [[Uninstaller alloc] init] ;
	[instance reset] ;
    [instance release] ;
}


#pragma mark * ExtensionsCallbackee Protocol Support

- (void)beginIndeterminateTaskVerb:(NSString*)verb
						 forExtore:(Extore*)extore {
}

- (void)muleIsDoneForExtore:(Extore*)extore {
	NSDictionary* results = [NSDictionary dictionaryWithDictionary:[[self mule] results]] ;
	[self setExtensionsResults:results] ;
}

- (void)presentError:(NSError*)error {
	// Don't bother the user with it!
}

- (void)presentAlert:(SSYAlert*)alert
     completionHandler:(void (^)(NSModalResponse))handler {
    [alert runModalDialog];
    handler(NSModalResponseOK);
}

- (void)refreshAndDisplay {
}

@end
