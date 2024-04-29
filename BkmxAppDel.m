#import <Bkmxwork/Bkmxwork-Swift.h>
#import "ActiveBrowserObserver.h"
#import "Syncer.h"
#import "AgentPerformer.h"
#import "BkmxAppDel+Actions.h" // For EventHotKeyRef, EventKHotKeyID, EventTypeSpec, EventType
#import "BkmxAppDel+Capabilities.h"
#import "BkmxBasis+Strings.h"
#import "BkmxDoc+Actions.h"
#import "BkmxDoc+GuiStuff.h"
#import "BkmxDocumentController.h"
#import "BkmxDocumentProvider.h"
#import "BkmxDocWinCon.h"
#import "BkmxWatch.h"
#import "Chromessengerer.h"
#import "Client+SpecialOptions.h"
#import "ContentOutlineView.h"
#import "DoxtusMenu.h"
#import "ErrorLog.h"
#import "ExtensionsVersionChecker.h"
#import "ExtoreChromy.h"
#import "ExtoreSafari.h"
#import "Firefox53Upgrader.h"
#import "Importer.h"
#import "Exporter.h"
#import "InspectorController.h"
#import "LogsWinCon.h"
#import "Macster.h"
#import "MAKVONotificationCenter.h"
#import "MiniSearchWinCon.h"
#import "NewUserSetupWinCon.h"
#import "NoStark.h"
#import "NSArray+SafeGetters.h"
#import "NSArray+Stringing.h"
#import "NSBundle+HelperPaths.h"
#import "NSBundle+MainApp.h"
#import "NSBundle+SSYMotherApp.h"
#import "NSDate+Microsoft1601Epoch.h"
#import "NSDate+NiceFormats.h"
#import "NSDictionary+SimpleMutations.h"
#import "NSDocumentController+DisambiguateForUTI.h"
#import "NSDocumentController+MoreRecents.h"
#import "NSDocumentController+OpenExpress.h"
#import "NSEntityDescription+SSYMavericksBugFix.h"
#import "NSError+InfoAccess.h"
#import "NSError+MyDomain.h"
#import "NSError+Recovery.h"
#import "NSError+SSYInfo.h"
#import "NSFileManager+SomeMore.h"
#import "NSInvocation+Quick.h"
#import "NSManagedObjectContext+Cheats.h"
#import "NSMenu+Ancestry.h"
#import "NSMenu+Initialize.h"
#import "NSMenu+StarkContextual.h"
#import "NSObject+MoreDescriptions.h"
#import "NSString+LocalizeSSY.h"
#import "NSString+MorePaths.h"
#import "NSString+Clipboard.h"
#import "NSString+SSYDotSuffix.h"
#import "NSString+SSYExtraUtils.h"
#import "NSUserDefaults+Bkmx.h"
#import "NSUserDefaults+KeyPaths.h"
#import "NSUserDefaults+MoreTypes.h"
#import "PrefsWinCon.h"
#import "SettingsViewController.h"
#import "SRCommon.h"
#import "SSWebBrowsing.h"
#import "SSYAppInfo.h"
#import "SSYDooDooUndoManager.h"
#import "SSYEventInfo.h"
#import "SSYKeychain.h"
#import "SSYLabelledList.h"
#import "SSYLabelledRadioButtons.h"
#import "SSYLaunchdBasics.h"
#import "SSYLaunchdGuy.h"
#import "SSYLazyNotificationCenter.h"
#import "SSYLicenseBuyController.h"
#import "SSYLicenseMaintainer.h"
#import "SSYLicensePersistor.h"
#import "SSYLicensor.h"
#import "SSYListPicker.h"
#import "SSYMH.AppAnchors.h"
#import "SSYMOCManager.h"
#import "SSYMojo.h"
#import "SSYOtherApper.h"
#import "SSYProcessTyper.h"
#import "SSYRepresentative.h"
#import "SSYShellTasker.h"
#import "SSYShoeboxDocument-Categories.h"
#import "SSYShortcutActuator.h"
#import "SSYShortcutActuator.h"
#import "SSYSpotlighter.h"
#import "SSYSuffixedMenuItem.h"
#import "SSYVectorImages.h"
#import "SSYVersionTriplet+BkmxLegacyEffectivness.h"
#import "SSYWindowHangout.h"
#import "SSYXugradeApp.h"
#import "Stager.h"
#import "Stark+Attributability.h"
#import "Stark+LegacyArtifacts.h"
#import "Stark+Sorting.h"
#import "StarkEditor.h"
#import "Starker.h"
#import "Starki.h"
#import "SUConstants.h"  // Requires adding Sparkle source directory to Build Settings ▸ Header Search Paths.  Note that, because this header is not "public" in the Sparkle Framework build, #import "Sparkle/SUConstants.h" will not work.
#import "Trigger.h"
#import "SSYInterappClient.h"
#import "Watch.h"
#import "BkmxAgentProtocol.h"
#import "SSYUUID.h"
#import "Job.h"
#import "ExtoreBravePublic.h"
#import "ClientChoice.h"
#import "SSYRecurringDate.h"
#import "BkmxNotifierCaller.h"


NSString* const constNoteLaunchInBackgroundSwitchedOff = @"launchInBackgroundSwitchedOff" ;
NSString* const constLegacyKeyLaunchDocUuids = @"launchDocUuids" ;

static BOOL xorr(BOOL a, BOOL b) {
    return ((a||b)  && !(a&&b)) ;
}

NSString* const skuForBookMacster2 = @"637504";
NSString* const skuForMarkster2 = @"635947";
NSString* const skuForSynkmark2 = @"637644";
NSString* const skuForSmarky2 = @"637650";

NSString* const skuForBookMacster3 = @"630463";
NSString* const skuForMarkster3 = @"637637";
NSString* const skuForSynkmark3 = @"637647";
NSString* const skuForSmarky3 = @"637653";

@interface BkmxAppDel ()

@property (assign) BOOL didDisplayBrokenLoginItemError ;
@property (retain) NSFont* fontTable ;
@property (assign) BOOL didFinishLaunchingEarlyChores ;
@property (assign) NSTimeInterval dateHitShortcutActuator ;
@property (assign) BOOL didWarnMultiDocSyncers ;
@property (retain) NSRunningApplication* lastActiveBrowserApp ;

@end

@implementation BkmxAppDel

@synthesize noWelcome = m_noWelcome ;
@synthesize didDisplayBrokenLoginItemError = m_didDisplayBrokenLoginItemError ;
@synthesize didFinishLaunchingEarlyChores = m_didFinishLaunchingEarlyChores ;
@synthesize dateHitShortcutActuator = m_dateHitShortcutActuator ;
@synthesize didWarnMultiDocSyncers = m_didWarnMultiDocSyncers ;
@synthesize lastActiveBrowserApp = m_lastActiveBrowserApp ;
@synthesize isUninstalling = m_isUninstalling ;
@synthesize isResetting = m_isResetting ;
@synthesize isTerminating = m_isTerminating ;
@synthesize needsTriggersCheckedForFirefox53 = m_needsTriggersCheckedForFirefox53;


- (BkmxBasis*)basis {
	return [BkmxBasis sharedBasis] ;
}

- (NSString*)appSKU {
    NSString* appSKU;
    NSInteger majorVersion = [SSYAppInfo currentVersionTriplet].major;
    switch(majorVersion) {
        case 2:
            switch ([[BkmxBasis sharedBasis] iAm]) {
                case BkmxWhich1AppSmarky:
                    appSKU = skuForSmarky2 ;
                    break ;
                case BkmxWhich1AppSynkmark:
                    appSKU = skuForSynkmark2 ;
                    break ;
                case BkmxWhich1AppMarkster:
                    appSKU = skuForMarkster2 ;
                    break ;
                case BkmxWhich1AppBookMacster:
                    appSKU = skuForBookMacster2 ;
                    break ;
            }
            break;
        case 3:
            switch ([[BkmxBasis sharedBasis] iAm]) {
                case BkmxWhich1AppBookMacster:
                    appSKU = skuForBookMacster3;
                    break ;
                case BkmxWhich1AppSmarky:
                    appSKU = skuForSmarky3;
                    break ;
                case BkmxWhich1AppSynkmark:
                    appSKU = skuForSynkmark3;
                    break ;
                case BkmxWhich1AppMarkster:
                    appSKU = skuForMarkster3;
                    break ;
            }
            break;
        default:
            appSKU = nil;
    }
    
    return appSKU ;
}

- (void)getIfInstalledAndLooksOkOtherBkmxApp:(SSYXugradeApp**)xugradeApp_p
                                    withName:(NSString*)appName
                                     version:(NSString*)version
                                         sku:(NSString*)sku {
    if (xugradeApp_p != NULL) {
        if (*xugradeApp_p == nil) {
            NSString* licenseeNameUserDefaultsKey ;
            NSString* licenseKeyUserDefaultsKey ;

            NSInteger skuInteger = [sku integerValue] ;
            if (skuInteger == 1) {
                licenseeNameUserDefaultsKey = @"LicenseeName" ;
                licenseKeyUserDefaultsKey = @"SerialNumber" ;
                // Legacy of stupid eSellerate calls 'key' a 'serial'
            }
            else {
                NSInteger majorVersion;
                if (skuInteger <=5 ){
                    majorVersion = 1;
                } else if (
                           [sku isEqualToString:skuForBookMacster2] ||
                           [sku isEqualToString:skuForMarkster2] ||
                           [sku isEqualToString:skuForSynkmark2] ||
                           [sku isEqualToString:skuForSmarky2]
                           ) {
                    majorVersion = 2;
                } else if (
                           [sku isEqualToString:skuForBookMacster3] ||
                           [sku isEqualToString:skuForMarkster3] ||
                           [sku isEqualToString:skuForSynkmark3] ||
                           [sku isEqualToString:skuForSmarky3]
                           ) {
                    majorVersion = 3;
                }
                else {
                    majorVersion = 0;
                    NSLog(@"Internal Error 483-3948  Need code for new version here.");
                }
                licenseeNameUserDefaultsKey = SSYLCPrefsNameKey(majorVersion) ;
                licenseKeyUserDefaultsKey = SSYLCPrefsKeyKey(majorVersion) ;
            }
            NSString* bundleIdentifier = [BkmxBasis appIdentifierForAppName:appName] ;
            if (version) {
                appName = [appName stringByAppendingFormat:
                           @" %@",
                           version] ;
            }
            *xugradeApp_p = [[SSYXugradeApp alloc] initWithSku:sku
                                                          name:appName
                                              bundleIdentifier:bundleIdentifier
                                   licenseeNameUserDefaultsKey:licenseeNameUserDefaultsKey
                                     licenseKeyUserDefaultsKey:licenseKeyUserDefaultsKey] ;
            if (![*xugradeApp_p installedlLooksOk]) {
                [*xugradeApp_p release] ;
                *xugradeApp_p = nil ;
            }
            else {
                [*xugradeApp_p autorelease] ;
            }
        }
    }
}

- (SSYXugradeApp*)bestApparentXugradeApp {
    SSYXugradeApp* xugradeApp = nil ;
    
    /* In each case, start with the app which is most likely to give the
     biggest discount for the user.  To calculate this exactly, we would
     need to know how long the user had the app and use our current price
     schedule.  We're not going to go there.  This is close enough.  Some
     users may get "overcharged" by up to a few dollars.  */
    if ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppBookMacster) {
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameBookMacster
                                           version:@"2"
                                               sku:skuForBookMacster2] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameBookMacster
                                           version:@"1"
                                               sku:@"0002"] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameSynkmark
                                           version:@"3"
                                               sku:skuForSynkmark3] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameMarkster
                                           version:@"3"
                                               sku:skuForMarkster3] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameSmarky
                                           version:@"3"
                                               sku:skuForSmarky3] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameMarkster
                                           version:@"2"
                                               sku:skuForMarkster2] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameSynkmark
                                           version:@"2"
                                               sku:skuForSynkmark2] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameSmarky
                                           version:@"2"
                                               sku:skuForSmarky2] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameMarkster
                                           version:@"1"
                                               sku:@"0005"] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameSynkmark
                                           version:@"1"
                                               sku:@"0004"] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameSmarky
                                           version:@"1"
                                               sku:@"0003"] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:@"Bookdog"
                                           version:@"1"
                                               sku:@"0001"] ;
    }
    else if ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppMarkster) {
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameBookMacster
                                           version:@"3"
                                               sku:skuForBookMacster3] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameSynkmark
                                           version:@"3"
                                               sku:skuForSynkmark3] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameSmarky
                                           version:@"3"
                                               sku:skuForSmarky2] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:@"BookMacster"
                                           version:@"2"
                                               sku:skuForBookMacster2] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameMarkster
                                           version:@"2"
                                               sku:skuForMarkster2] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameSynkmark
                                           version:@"2"
                                               sku:skuForSynkmark2] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameSmarky
                                           version:@"2"
                                               sku:skuForSmarky2] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameBookMacster
                                           version:@"1"
                                               sku:@"0002"] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameMarkster
                                           version:@"1"
                                               sku:@"0005"] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameSynkmark
                                           version:@"1"
                                               sku:@"0004"] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameSmarky
                                           version:@"1"
                                               sku:@"0003"] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:@"Bookdog"
                                           version:@"1"
                                               sku:@"0001"] ;
    }
    else if ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppSynkmark) {
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameBookMacster
                                           version:@"3"
                                               sku:skuForBookMacster3] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameMarkster
                                           version:@"3"
                                               sku:skuForMarkster3] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameSmarky
                                           version:@"3"
                                               sku:skuForSmarky3] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:@"BookMacster"
                                           version:@"2"
                                               sku:skuForBookMacster2] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameMarkster
                                           version:@"2"
                                               sku:skuForMarkster2] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameSynkmark
                                           version:@"2"
                                               sku:skuForSynkmark2] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameSmarky
                                           version:@"2"
                                               sku:skuForSmarky2] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameBookMacster
                                           version:@"1"
                                               sku:@"0002"] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameMarkster
                                           version:@"1"
                                               sku:@"0005"] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameSynkmark
                                           version:@"1"
                                               sku:@"0004"] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameSmarky
                                           version:@"1"
                                               sku:@"0003"] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:@"Bookdog"
                                           version:@"1"
                                               sku:@"0001"] ;
    }
    else if ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppSmarky) {
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameBookMacster
                                           version:@"3"
                                               sku:skuForBookMacster3] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameSynkmark
                                           version:@"3"
                                               sku:skuForSynkmark3] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameMarkster
                                           version:@"3"
                                               sku:skuForMarkster3] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:@"BookMacster"
                                           version:@"2"
                                               sku:skuForBookMacster2] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameMarkster
                                           version:@"2"
                                               sku:skuForMarkster2] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameSynkmark
                                           version:@"2"
                                               sku:skuForSynkmark2] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameBookMacster
                                           version:@"1"
                                               sku:@"0002"] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameMarkster
                                           version:@"1"
                                               sku:@"0005"] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameSynkmark
                                           version:@"1"
                                               sku:@"0004"] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:constAppNameSmarky
                                           version:@"1"
                                               sku:@"0003"] ;
        [self getIfInstalledAndLooksOkOtherBkmxApp:&xugradeApp
                                          withName:@"Bookdog"
                                           version:@"1"
                                               sku:@"0001"] ;
    }
    
    return xugradeApp ;
}

// Only runs in BookMacster
- (void)didDismissMultiDocAgentsAlert:(SSYAlert*)alert {
    NSInteger checkboxState = [alert checkboxState] ;
    if (checkboxState == NSControlStateValueOn) {
        [[NSUserDefaults standardUserDefaults] setBool:YES
                                                forKey:constKeyDontWarnMultiDocSyncers] ;
    }
}

- (void)warnMultiDocsInWatches:(NSSet*)watches {
    if (![self didWarnMultiDocSyncers]) {
        if (![[NSUserDefaults standardUserDefaults] boolForKey:constKeyDontWarnMultiDocSyncers]) {
            [self setDidWarnMultiDocSyncers:YES] ;
            NSSet* docDescriptions = [BkmxDocumentController documentDescriptionsFromWatches:watches];
            if (docDescriptions.count > 1) {
                NSString* docsList = [BkmxDocumentController documentListFromWatches:watches];
                NSString* msg = [NSString stringWithFormat:
                                 @"You currently have %ld Documents with Syncers:\n"
                                 @"%@\n"
                                 @"This can lead to conflicts and undesired results, "
                                 @"particularly if different documents' Syncers are "
                                 @"syncing the same %@.\n\n"
                                 @"Unless you've carefully thought through what you're "
                                 @"doing, you should remove %ld unwanted Syncrs.  "
                                 @"To remove a Syncer,\n\n"
                                 @"   \xe2\x80\xa2  Activate the app which created it.\n"
                                 @"   \xe2\x80\xa2  Open the document.\n"
                                 @"   \xe2\x80\xa2  Switch off syncing.\n\n"
                                 @"Or you can remove all agents from all Sheep "
                                 @"Systems apps en masse by clicking in the menu: %@ > "
                                 @"'%@…'.",
                                 (long)docDescriptions.count,
                                 docsList,
                                 [[BkmxBasis sharedBasis] labelClients],
                                 (long)(docDescriptions.count - 1),
                                 [[BkmxBasis sharedBasis] appNameLocalized],
                                 [[BkmxBasis sharedBasis] labelStopAllSyncingNow]
                                 ] ;
                SSYAlert* alert = [SSYAlert alert] ;
                [alert setSmallText:msg] ;
                [alert setIconStyle:SSYAlertIconCritical] ;
                if ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppBookMacster) {
                    [alert setCheckboxTitle:[NSString localize:@"dontShowAdvisoryAgain"]] ;
                    [alert setClickTarget:self] ;
                    [alert setClickSelector:@selector(didDismissMultiDocAgentsAlert:)] ;
                }
                [alert setButton1Title:[[BkmxBasis sharedBasis] labelOk]] ;
                [alert setRightColumnMinimumWidth:350] ;  // So the docsList doesn't wrap
                [alert display] ;
            }
        }
    }
}

/*!
 @brief    Method to avoid crashes if items on the intraAppCopy array,
 orphaned when their ancestral document closes, are later
 attempted to be pasted.	
*/
- (void)clearIntraAppItemArraysOfBkmxDoc:(BkmxDoc*)bkmxDoc {
	for (Stark* stark in [self intraAppCopyArray]) {
		if ([stark owner] == bkmxDoc) {
			[stark setParent:nil] ;
		}
	}
    
    NSArray<ContentProxy*>* proxies = [[NSPasteboard generalPasteboard] readObjectsForClasses:@[[ContentProxy class]]
                                                                                      options:nil];
	for (ContentProxy* proxy in proxies) {
        Stark* stark = [proxy stark];

        if ([stark owner] == bkmxDoc) {
			[stark setParent:nil] ;
		}
	}
}

- (void)forgetBkmxDocNote:(NSNotification*)notification {
}

- (NSMutableArray*)intraAppCopyArray {
	if (!intraAppCopyArray) {
		intraAppCopyArray = [[NSMutableArray alloc] init] ;
	}
	
	return intraAppCopyArray ;
}

- (PrefsWinCon*)prefsWinCon {
    PrefsWinCon* prefsWinCon = (PrefsWinCon*)[SSYWindowHangout hungOutWindowControllerOfClass:[PrefsWinCon class]] ;
	if (!prefsWinCon) {
		prefsWinCon = [[PrefsWinCon alloc] init] ;
        [SSYWindowHangout hangOutWindowController:prefsWinCon] ;
        [prefsWinCon release] ;
	}
	
	return prefsWinCon ;
}

- (void)revealPrefsTabIdentifier:(NSString*)identifier {
    [self preferences:self];
    [[self prefsWinCon] revealTabViewIdentifier1:identifier
                                     identifier2:nil];
}

- (MiniSearchWinCon*)miniSearchWinCon {
	if (!m_miniSearchWinCon) {
		m_miniSearchWinCon = [[MiniSearchWinCon alloc] init] ;
	}
	
	return m_miniSearchWinCon ;
}

- (LogsWinCon*)logsWinCon {
	if (!m_logsWinCon) {
		m_logsWinCon = [[LogsWinCon alloc] init] ;
	}
	
	return m_logsWinCon ;
}

- (void)displayErrorLogs {
	[self setNoWelcome:YES] ;
	[[self logsWinCon] displayErrors] ;
}

- (NSInteger)presentLastLoggedErrorWithCode:(NSInteger)code {
    BOOL requiresCode = NO;
    if (code != 0){
        requiresCode = YES;
    }
    NSManagedObjectContext* moc = [[BkmxBasis sharedBasis] logsMoc] ;
    
    NSError* error = nil ;
    NSInteger i = 1 ;
    /* Iterate each time deeper into error logs, sorted by timestamp, until the
    last one is a non-hide error. */
    NSInteger lastFetchCount = 0;
    BOOL maybeMore = YES;
    BOOL done1 = NO;
    BOOL done2 = NO;
    BOOL done3 = NO;
    BOOL done4 = NO;
    NSError* latestError = nil;
    do {
        NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init] ;
        [fetchRequest setEntity:[NSEntityDescription SSY_entityForName:constEntityNameErrorLog
                                                inManagedObjectContext:moc]] ;
        NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:constKeyTimestamp
                                                                       ascending:NO] ;
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]] ;
        [sortDescriptor release] ;
        [fetchRequest setFetchLimit:i] ;
        NSError* fetchError = nil ;
        NSArray* fetchResults = [moc executeFetchRequest:fetchRequest
                                                   error:&fetchError] ;
        [fetchRequest release] ;

        if (fetchResults.count == lastFetchCount) {
            maybeMore = NO;
        } else {
            lastFetchCount = fetchResults.count;
        }
        
        if (maybeMore) {
            if (fetchResults) {
                ErrorLog* errorLog = [fetchResults lastObject] ;
                error = [errorLog error] ;
                
                if (!latestError) {
                    /* See Note UseLatestError */
                    latestError = error;
                }
                
                [errorLog markAsPresented] ;
                [[BkmxBasis sharedBasis] saveLogsMoc] ;
            }
            else {
                NSLog(@"Internal Error 923-9230 %@", fetchError) ;
                NSBeep() ;
            }
        }

        // Any one of four conditions shall cause this loop to be done…
        done1 = (error == nil);
        done2 = ((requiresCode == NO) && (![gSSYAlertErrorHideManager shouldHideError:error]));
        done3 = ((requiresCode == YES) && (error.code == code));
        done4 = maybeMore == NO;
        i++ ;
    } while (!done1 && !done2 && !done3 && !done4);
    
    if ([gSSYAlertErrorHideManager shouldHideError:error]) {
        error = nil;
    }
    
    if ((done2 == NO) && (done3 == NO) && (done4 == YES)) {
        /* Note UseLatestError
         The loop checked all the errors in the database but did not
         find any meeting the specification, for example, because a nonzero
         error code was passed in, but there were no errors with that code.
         */
        error = latestError;
    }
        
    error = [error errorByAddingIsLogged] ;
    if (!error) {
        error = SSYMakeError(103989, @"There are no significant errors in your Error Log.") ;
    }
    NSInteger result = [SSYAlert alertError:error] ;
    return result ;
}


- (NSInteger)openNotificationSettings {
    [self preferences:self];
    [[self prefsWinCon] openNotificationSettings];
    
    return 0;
}

- (InspectorController*)inspectorController {
	if (!inspectorController) {
		inspectorController = [[InspectorController alloc] init] ;
	}
	
	return inspectorController ;
}

- (InspectorController*)inspectorControllerWeakly {
    return inspectorController;
}

- (NSString*)helpBookName {
	if (!helpBookName) {
		helpBookName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleHelpBookName"] ;
		[helpBookName retain] ;
	}
	return helpBookName ;
}

/* Important: This will not work until after you have run
 Help Indexer to create a Help Index, and possibly Help Viewer Hammer!
 */
- (void)openHelpAnchor:(NSString*)anchor {
	if (!anchor) {
		return ;
	}

    // Temporary workaround unil Apple fixes help anchors, which are
    // broken in macOS 10.14, and do not work in earlier systems
    // with current builds of our apps for a different reason, which is that
    // they also broke the help indexer utility (hiutil).  The problem I see
    // in macOS 12 Bata 6 is that the Old Code will open the Help Book to the
    // top of the *page* containing the given anchor, but it will not scroll
    // to the section with the anchor.
    [self displayHelpBookAnchor:anchor];

	// Old Code, hope to resurrect someday
//    NSString* bookName = [self helpBookName] ;
//    [[NSHelpManager sharedHelpManager] openHelpAnchor:anchor
//                                               inBook:bookName] ;
}

- (void)setSelectedStark:(id)selectedStark {
    [selectedStark retain];
    [m_selectedStark release];
    m_selectedStark = selectedStark;
    
    [[self inspectorControllerWeakly] setSelectedStark:selectedStark];
}

- (Stark*)selectedStark {
    return m_selectedStark;
}
    
- (void)setSelectedStarki:(id)selectedStarki {
    [selectedStarki retain];
    [m_selectedStarki release];
    m_selectedStarki = selectedStarki;

    [[self inspectorControllerWeakly] setSelectedStarki:selectedStarki];
}

- (Starki*)selectedStarki {
    return m_selectedStarki;
}
    
- (BOOL)starkOrStarksSelected {
	BOOL answer = [[self selectedStark] isKindOfClass:[Stark class]] ;
	
	return answer ;
}

+ (NSSet*)keyPathsForValuesAffectingStarkOrStarksSelected {
	return [NSSet setWithObjects:
			@"selectedStark",
			nil] ;
}

- (NSString*)descOfFont:(NSFont*)font {
	return [[font fontDescriptor] description] ;
}

- (NSFont*)fontWithBetterSymbolsFromFont:(NSFont*)fontIn {
	// Disable for now
	return fontIn ;
	
#if 0
    NSString* myFontName = @"SheepSymbols" ;
	CGFloat myFontSize = [fontIn pointSize] ;
	NSFont* myFont = [NSFont fontWithName:myFontName
									 size:myFontSize] ;
	NSFontDescriptor* myFontDescriptor = [NSFontDescriptor fontDescriptorWithName:myFontName
																			 size:myFontSize] ;
	NSString* fontInName = [fontIn fontName] ;
	NSFontDescriptor* fontInDescriptor = [NSFontDescriptor fontDescriptorWithName:fontInName
																			 size:myFontSize] ;
	NSArray* fontDescriptorArray = [NSArray arrayWithObjects:
									myFontDescriptor,
									fontInDescriptor,
									nil] ;
	NSDictionary* fontDescriptorAttributes = [NSDictionary dictionaryWithObject:fontDescriptorArray
																		 forKey:NSFontCascadeListAttribute] ;											
	NSFontDescriptor* fontDescriptor = [myFont fontDescriptor] ;
	fontDescriptor = [fontDescriptor fontDescriptorByAddingAttributes:fontDescriptorAttributes] ;
	NSFont* cascadedFont = [NSFont fontWithDescriptor:fontDescriptor
												 size:myFontSize] ;
	return cascadedFont ;
#endif
}

- (void)setFontTable:(NSFont*)fontTable {
	@synchronized(self) {
		if (fontTable != m_fontTable) {
			[m_fontTable release];
			m_fontTable = [fontTable retain] ;
		}
	}
}


- (NSFont*)fontTable {
	NSFont* fontTable ;
	@synchronized(self) {
		if (!m_fontTable) {
			// Get font size
			NSInteger tableFontSize ;
			NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
			NSNumber* oTableFontSize = [userDefaults objectForKey:constKeyTableFontSize] ;
			if (oTableFontSize) {
				tableFontSize = [oTableFontSize integerValue] ;
			}
			else {
				tableFontSize = 11 ; // default default
			}
			
			// Use it to make the font
			m_fontTable = [NSFont fontWithName:@"Helvetica"
										  size:tableFontSize] ;
			if (!m_fontTable) {
				// This Mac does not have Helvetica, so we use
				// whatever their system font, probably Lucida Grande.
				// The disadvantages of Lucida Grande are:
				//    (1) It's not kerned as tightly, looks more monospaced
				//    (2) It does not have an italic version, so my 
				//           convertFont:toHaveTrait:NSItalicFontMask below will return self, thus
				//           the italic fonts won't be italic.
				m_fontTable = [NSFont systemFontOfSize:tableFontSize] ;
			}
			
			m_fontTable = [self fontWithBetterSymbolsFromFont:m_fontTable] ;
			[m_fontTable retain] ;
		}		
		fontTable = [[m_fontTable retain] autorelease] ;
	}

	return fontTable ;
}

- (DoxtusMenu*)doxtusMenu {
	if (!m_doxtusMenu) {
		m_doxtusMenu = [[DoxtusMenu alloc] init] ;
	}
	
	return m_doxtusMenu ;
}

@synthesize dragTipShownCountOption = m_dragTipShownCountOption ;
@synthesize dragTipShownCountShift = m_dragTipShownCountShift ;
@synthesize dragTipShownCountContextual = m_dragTipShownCountContextual;

- (void)registerLastDragTipDate {
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date]
                                              forKey:constKeyLastDateDragTipsShown] ;
}

- (void)incrementDragTipShownCountShift {
    m_dragTipShownCountShift++ ;
    [self registerLastDragTipDate] ;
}

- (void)incrementDragTipShownCountOption {
    m_dragTipShownCountOption++ ;
    [self registerLastDragTipDate] ;
}

- (void)incrementDragTipShownCountContextual {
    m_dragTipShownCountContextual++ ;
    [self registerLastDragTipDate] ;
}

#define TIME_INTERVAL_BETWEEN_SHOWING_DRAG_TIPS 14*24*60*60 // 14 days

- (NSInteger)howManyTimesToShowDragTipsThisLaunch {
    if (m_howManyTimesToShowDragTipsThisLaunch < 0) {
        if ([SSYAppInfo isNewUser]) {
            m_howManyTimesToShowDragTipsThisLaunch = 2 ;
        }
        else if ([[NSUserDefaults standardUserDefaults] boolForKey:constKeyDontShowDragTips]) {
            m_howManyTimesToShowDragTipsThisLaunch = 0 ;
        }
        else {
            NSDate* lastDateDragTipsShown = [[NSUserDefaults standardUserDefaults] objectForKey:constKeyLastDateDragTipsShown] ;
            if ([lastDateDragTipsShown respondsToSelector:@selector(timeIntervalSinceNow)]) {
                NSTimeInterval timeIntervalSinceLastShown = -[lastDateDragTipsShown timeIntervalSinceNow] ;
                m_howManyTimesToShowDragTipsThisLaunch = (timeIntervalSinceLastShown > TIME_INTERVAL_BETWEEN_SHOWING_DRAG_TIPS) ? 1 : 0 ;
            }
            else {
                // Either tips have never been shown, or pref is corrupt.
                m_howManyTimesToShowDragTipsThisLaunch = 1 ;
            }
        }
    }
    
    return m_howManyTimesToShowDragTipsThisLaunch ;
}

- (NSColor*)colorBlueText {
	if(!colorBlueText) {
		colorBlueText = [NSColor colorWithCalibratedRed:.53125 green: .578125 blue:1.0 alpha:1.0] ; ;
		
		[colorBlueText retain] ;
	}
	
	return colorBlueText ;
}

- (NSArray*)bookmarksOnPasteboard {
    NSArray<ContentProxy*>* proxies = [[NSPasteboard generalPasteboard] readObjectsForClasses:@[[ContentProxy class]]
                                                                                      options:nil];
    NSMutableArray* bookmarks = [[NSMutableArray alloc] init] ;
    for (ContentProxy* proxy in proxies) {
        [[proxy stark] classifyBySharypeDeeply:YES
                                    hartainers:nil
                                   softFolders:nil
                                        leaves:bookmarks
                                       notches:nil] ;
	}
	
	NSArray* output = [bookmarks copy] ;
	[bookmarks release] ;
	
	return [output autorelease] ;
}

- (void)tweakMainMenu {
	NSMenu* menu ;
	NSMenuItem* item ;

	// **** Tweaks to Application Menu **** //
	menu = [[[NSApp mainMenu] itemWithTag:1000] submenu] ;
	[menu setDelegate:self] ; // Needed to invoke -menuNeedsUpdate:
	// Tweaks to "Manage Browser Extensions..."
	item = [menu itemWithTag:1505] ;
	[item setTitle:[[[BkmxBasis sharedBasis] labelManageBrowserExtensions] ellipsize]] ;
	// Tweaks to "Reset and Start Over…"
	item = [menu itemWithTag:1553] ;
	[item setTitle:[[[BkmxBasis sharedBasis] labelResetAndStartOver] ellipsize]] ;
	// Tweaks to "Uninstall…"
	item = [menu itemWithTag:1555] ;
	[item setTitle:[[[BkmxBasis sharedBasis] labelUninstall] ellipsize]] ;
	// Tweaks to "Logs…"
	item = [menu itemWithTag:48320] ;
	[item setTitle:[[[BkmxBasis sharedBasis] labelLogs] ellipsize]] ;
 	// Tweaks to "Empty Cache..."
	item = [menu itemWithTag:1520] ;
	[item setTitle:[[[BkmxBasis sharedBasis] labelEmptyCache] ellipsize]] ;
	// Tweaks to "Errors From Workers' Agents" Submenu of "BookMacster" Submenu of Main Menu **** //
	menu = [[menu itemWithTag:1760] submenu] ;
	[menu setDelegate:self] ; // Needed to invoke -menuNeedsUpdate:
	// Tweaks to "Licensing (Registration) Submenu of "BookMacster" Submenu of Main Menu **** //
	menu = [[menu itemWithTag:1200] submenu] ;
	[menu setDelegate:self] ; // Needed to invoke -menuNeedsUpdate:


    // **** Tweaks to "File" Submenu of Main Menu **** /
    menu = [[[NSApp mainMenu] itemWithTag:500] submenu] ;
    // In Markster, remove "Import from all" and "Export to all"
    if ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppMarkster) {
        item = [menu itemWithTag:4301] ;
        [menu removeItem:item] ;
        item = [menu itemWithTag:4302] ;
        [menu removeItem:item] ;
    }
    [menu setDelegate:self] ; // Needed to invoke -menuNeedsUpdate:
	if ([[BkmxBasis sharedBasis] iAm] != BkmxWhich1AppBookMacster) {
        // Shoebox app
        // "Close" the main window also means Quit
        item = [menu itemWithTag:48117] ;
        [item setTitle:[[BkmxBasis sharedBasis] labelCloseAndQuit]] ;
#if 0
        // #if 0 because this hardly works
        item = [menu itemWithTag:48112] ;
        if (item) {
            [menu removeItem:item] ;
        }
        item = [menu itemWithTag:48114] ;
        if (item) {
            [menu removeItem:item] ;
        }
        item = [menu itemWithTag:48120] ;
        if (item) {
            [menu removeItem:item] ;
        }
#endif
    }
    // Tweaks to "Save As"
    item = [menu itemWithTag:48119] ;
    [item setTitle:[[item title] ellipsize]] ;
    // Tweaks to "Save and Move"
    item = [menu itemWithTag:48120] ;
    if (item) {
        for (NSMenuItem* aItem in [menu itemArray]) {
            if ([aItem action] == @selector(moveDocument:)) {
                [menu removeItem:item] ;
                item = nil ;
                break ;
            }
        }
        [item setToolTip:[NSString localizeFormat:@"saveMoveToolTip",
                          [NSString localize:@"saveAs"]]] ;
        [item setTitle:[[NSString stringWithFormat:
                         @"%@ %@",
                         [NSString localize:@"saveAs"],
                         [NSString localize:@"move"]] ellipsize]] ;
    }
    // Tweaks to "CloseAndDelete"
    item = [menu itemWithTag:48400] ;
    [item setTitle:[[BkmxBasis sharedBasis] labelCloseAndTrash]] ;
    // Tweaks to "Import from only"
    item = [menu itemWithTag:580] ;
    [[item submenu] setDelegate:self] ;  // Needed to invoke -menuNeedsUpdate:
    switch([[BkmxBasis sharedBasis] iAm]) {
        case BkmxWhich1AppSmarky:
            [item setTitle:[[BkmxBasis sharedBasis] labelImportFromOthers]] ;
            break ;
        case BkmxWhich1AppSynkmark:
        case BkmxWhich1AppBookMacster:
            [item setTitle:[[BkmxBasis sharedBasis] labelImportFromOnly]] ;
            break ;
        case BkmxWhich1AppMarkster:
            [item setTitle:[[BkmxBasis sharedBasis] labelImportFrom]] ;
            break ;
    }
    // Tweaks to "Export to only"
    item = [menu itemWithTag:585] ;
    [[item submenu] setDelegate:self] ;  // Needed to invoke -menuNeedsUpdate:
    switch([[BkmxBasis sharedBasis] iAm]) {
        case BkmxWhich1AppSmarky:
            [item setTitle:[[BkmxBasis sharedBasis] labelExportToOthers]] ;
            break ;
        case BkmxWhich1AppSynkmark:
        case BkmxWhich1AppBookMacster:
            [item setTitle:[[BkmxBasis sharedBasis] labelExportToOnly]] ;
            break ;
        case BkmxWhich1AppMarkster:
            [item setTitle:[[BkmxBasis sharedBasis] labelExportTo]] ;
            break ;
    }
    // Tweaks to "Install Bookmarklet into ▸"
    item = [menu itemWithTag:587] ;
    [item setTitle:[NSString stringWithFormat:@"Install %@ into", [NSString localize:@"bookmarklet"]]] ;
    [[item submenu] setDelegate:self] ;  // Needed to invoke -menuNeedsUpdate:

	// **** Tweaks to "Bookmarks" Submenu of Main Menu **** /
	menu = [[[NSApp mainMenu] itemWithTag:4000] submenu] ;
    [menu setTitle:[[BkmxBasis sharedBasis] labelBookmarks]] ;
	[menu setDelegate:self] ; // Needed to invoke -menuNeedsUpdate:
	// Tweaks to "Outline Mode"
	item = [menu itemWithTag:4120] ;
	[item setTitle:[[BkmxBasis sharedBasis] labelShowFolders]] ;
	// Tweaks to "Aggressively Normalize URLs"
	item = [menu itemWithTag:48485] ;
	[item setTitle:[@"Aggressively Normalize URLs" ellipsize]] ;
	// Tweaks to "Delete All Dupes"
	item = [menu itemWithTag:48480] ;
	[item setTitle:[[[BkmxBasis sharedBasis] labelDeleteAllDupes] ellipsize]] ;
	// Tweaks to "Set Up Sync…"
	item = [menu itemWithTag:4350] ;
	[item setTitle:[[NSString localizeFormat:@"setUpX", [NSString localize:@"imex_sync"]] ellipsize]] ;
	// Tweaks to "Show Sync Log"
	item = [menu itemWithTag:4370] ;
	[item setTitle:[[NSString localizeFormat:@"showX", [[BkmxBasis sharedBasis] labelSyncLog]] ellipsize]] ;
	// Tweaks to "Safe Sync Limit ▸"
	item = [menu itemWithTag:4360] ;
	[item setTitle:[[BkmxBasis sharedBasis] labelSafeLimit]] ;
		

	// **** Tweaks to "Syncing" Submenu in Smarky or Synkmark **** /
	menu = [[[NSApp mainMenu] itemWithTag:4100] submenu] ;
    [menu setTitle:NSLocalizedString(@"Syncing", nil)] ;
    [menu setDelegate:self] ; // Needed to invoke -menuNeedsUpdate:
    // Tweaks to "Show Sync Log"
    item = [menu itemWithTag:4370] ;
    [item setTitle:[[NSString localizeFormat:@"showX", [[BkmxBasis sharedBasis] labelSyncLog]] ellipsize]] ;
    // Tweaks to "Settings…"
    item = [menu itemWithTag:4350] ;
    [item setTitle:[[BkmxBasis sharedBasis] labelSettings]] ;
	
    
    // **** Tweaks to "Edit" Submenu of Main Menu **** //
    menu = [[[NSApp mainMenu] itemWithTag:3000] submenu] ;
    [menu setDelegate:self] ; // Needed to invoke -menuNeedsUpdate:
    // Tweaks to "Will be Sorted"
    item = [menu itemWithTag:3500] ;
    [item setToolTip:[NSString localizeFormat:@"sortedToolTip", [[BkmxBasis sharedBasis] appNameLocalized]]];

	// Tweaks to "Will be Sorted"
	item = [menu itemWithTag:3510] ;
	[item setToolTip:NSLocalizedString(@"Sorts only the selected folder, by an attribute which you will select", nil)] ;

    // Tweaks to "Add New Item"
    NSMenuItem* newItemItem = [menu itemWithTag:3400];
    [newItemItem setTitle:[NSString localizeFormat:
                            @"addX",
                            [NSString localizeFormat:
                             @"new%0",
                             [[BkmxBasis sharedBasis] labelItem]]]] ;
    menu = [newItemItem submenu];
    // Tweaks to "Soft Folder"
    [[menu itemWithTag:3410] setTitle:[[BkmxBasis sharedBasis] labelSoftainer]] ;
    // Tweaks to "Bookmark"
    [[menu itemWithTag:3420] setTitle:[[BkmxBasis sharedBasis] labelLeaf]] ;
    // Tweaks to "Separator"
    [[menu itemWithTag:3430] setTitle:[[BkmxBasis sharedBasis] labelSeparator]] ;

	// **** Tweaks to "Window" Submenu of Main Menu **** //
	menu = [[[NSApp mainMenu] itemWithTag:6000] submenu] ;
    [menu setDelegate:self] ; // Needed to invoke -menuNeedsUpdate:

    // Tweaks to "Bookmarks"
	item = [menu itemWithTag:6401] ;
	[item setTitle:[[BkmxDocumentController sharedDocumentController] shoeboxDocumentBaseName]] ;
	// Tweaks to "Content"
	item = [menu itemWithTag:6410] ;
	[item setTitle:[[BkmxBasis sharedBasis] labelContent]] ;
	// Tweaks to "Settings"
	item = [menu itemWithTag:6420] ;
	[item setTitle:[[BkmxBasis sharedBasis] labelSettings]] ;
	// Tweaks to "Reports"
	item = [menu itemWithTag:6430] ;
	[item setTitle:[[BkmxBasis sharedBasis] labelReports]] ;
    // Tweaks to "Reports"
    item = [menu itemWithTag:6500] ;
    [item setTitle:[[BkmxBasis sharedBasis] labelShowInspector]] ;

	// **** Tweaks to "Help" Submenu of Main Menu **** //
	menu = [[[NSApp mainMenu] itemWithTag:7000] submenu] ;
	// Tweaks to "%0 Help"
	item = [menu itemWithTag:48612] ;
	[item setTitle:[NSString localizeFormat:@"helpBook", [[BkmxBasis sharedBasis] appNameLocalized]]] ;
	// Tweaks to "%0 Support Web Page"
	item = [menu itemWithTag:48626] ;
	[item setTitle:[NSString localizeFormat:@"supportWeb", constCompanyName]] ;
	// Tweaks to "Visit Forum to Discuss <AppName>"
	item = [menu itemWithTag:48624] ;
	[item setTitle:[NSString localizeFormat:@"forumVisitX", [[BkmxBasis sharedBasis] appNameLocalized]]] ;
    [menu setDelegate:self] ; // Needed to invoke -menuNeedsUpdate:

    if (@available(macOS 10.15, *)) {
        NSMenuItem* newItem = [NSMenuItem new];
        newItem.title = NSLocalizedString(@"Trash crufty document support files…", nil);
        newItem.target = self;
        newItem.action = @selector(showCleanDocSupportFilesWindow);
        [menu addItem:newItem];
        [newItem release];
    }
    
    if (@available(macOS 10.15, *)) {
        NSMenuItem* newItem = [NSMenuItem new];
        newItem.title = NSLocalizedString(@"Wipe clean Safari and iCloud…", nil);
        newItem.target = self;
        newItem.action = @selector(wipeSafari);
        [menu addItem:newItem];
        [newItem release];
    }
}

- (void)showCleanDocSupportFilesWindow {
    if (@available(macOS 10.15, *)) {
        CleanDocSupportFilesController* controller = [CleanDocSupportFilesController new];
        // Don't need SSYWindowHangout here because WipeSafariController is defined in Swift.
        [controller makeWindow];
        [controller release];
    }
}

- (void)wipeSafari {
    if (@available(macOS 10.15, *)) {
        WipeSafariController* controller = [WipeSafariController new];
        // Don't need SSYWindowHangout here because WipeSafariController is defined in Swift.
        [controller makeWindow];
        [controller release];
    }
}

/*
- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
	return NO ;
}
*/

- (NSMenu *)applicationDockMenu:(NSApplication *)sender {
	DoxtusMenu* menu = [self doxtusMenu] ;
	// I presume that the following will send -menuNeedsUpdate: to menu's
	// delegate, which is the menu itself:
	[menu update] ;
	// If that doesn't seem to work, try sending it directly
	// [menu menuNeedsUpdate:menu] ;
	return menu ;
}

- (void)dealloc {
	[[MAKVONotificationCenter defaultCenter] removeObserver:self] ;
	
	[helpBookName release] ;
	[m_selectedStark release] ;
	[m_selectedStarki release] ;
	[intraAppCopyArray release] ;
	[m_logsWinCon release] ;
    [m_miniSearchWinCon release] ;
    [m_lastActiveBrowserApp release] ;
	[inspectorController release] ;
	[m_fontTable release] ;
	[m_doxtusMenu release] ;
    [_jobQueue release];

    for (NSTimer* timer in [_agentTimeoutters allValues]) {
        [timer invalidate];
    }
    [_agentTimeoutters release];
	
	[colorBlueText release] ;

	[super dealloc] ;
}

-  (BOOL) applicationShouldOpenUntitledFile:(NSApplication *)sender {
	return NO ;
}

/*
 - (BOOL)isValidUnicodeUnichar:(unichar)charCode {
	NSCharacterSet* cs = [NSCharacterSet characterSetWithRange:NSMakeRange(charCode,1)] ;
	NSString* s = [[NSString alloc] initWithFormat:@"%C", charCode] ;
	NSRange r = [s rangeOfCharacterFromSet:cs
								   options:0
									 range:NSMakeRange(0,1)] ;
	[s release] ;
	return (r.location != NSNotFound) ;
}


- (void)testChar:(unichar)charCode {
	NSLog(@"character %5d=0x%x. valid=%d",
		  charCode,
		  charCode,
		  [self isValidUnicodeUnichar:charCode]) ;
}
*/

- (void)mikeAshObserveValueForKeyPath:(NSString*)keyPath
							 ofObject:(id)object
							   change:(NSDictionary*)change
							 userInfo:(id)userInfo {
	if (object == [NSUserDefaults standardUserDefaults]) {
		if ([keyPath isEqualToString:constKeyTableFontSize]) {
			[self setFontTable:nil] ;
		}
	}
}

- (void)processedErrorNote:(NSNotification*)note {
	NSError* error = [note object] ;
	if (![error isLogged]) {
		[[BkmxBasis sharedBasis] logError:error
						  markAsPresented:YES] ;
	}
}

/*
 The json object represented by the jsonText should be structured like this:
 deletions
 (array of dictionaries with keys:)
 exid (required)
 insertions
 (array of dictionaries with keys:)
 parentExid (required)
 index (optional)
 name (optional)
 url (optional)
 moves
 (array of dictionaries with keys:)
 exid (required)
 parentExid (required)
 index (optional)
 updates
 (array of dictionaries with keys:)
 exid (required)
 name (optional)
 url (optional)
 */
- (void)appendOutput:(NSString *)output {
	NSLog(@"Got output: %@", output) ;
}

// This method is a callback which your controller can use to do other initialization when a process
// is launched.
- (void)processStarted{
	NSLog(@"Process started") ;
}
// This method is a callback which your controller can use to do other cleanup when a process
// is halted.
- (void)processFinished {
	NSLog(@"Process finished") ;
}

#if 0
- (void)getNote:(NSNotification*)note {
	NSString* msg = [NSString stringWithFormat:
					 @"Received %@",
					 [note name]] ;
	if ([[note name] isEqualToString:SSYPathObserverChangeNotification]) {
		msg = [msg stringByAppendingFormat:
			   @"\n   Path:         %@\n"
			   "   Change Flags: %p\n"
			   "   UserInfo:     %@\n",
			   [[note userInfo] objectForKey:SSYPathObserverPathKey],
			   [[[note userInfo] objectForKey:SSYPathObserverChangeFlagsKey] integerValue],
			   [[note userInfo] objectForKey:SSYPathObserverUserInfoKey]] ;
	}
	else if ([[note name] isEqualToString:NSThreadWillExitNotification]) {
		msg = [msg stringByAppendingFormat:
			   @" for thread named %@\n",
			   [note object]] ;
	}
	
	NSLog(@"%@", msg) ;
}
#endif

- (void)registerDefaultDefaults {
    [[NSUserDefaults standardUserDefaults] registerDefaults:[[BkmxBasis sharedBasis] defaultDefaults]] ;
}

-(BOOL)doesLaunchInBackground {
    return [[NSUserDefaults standardUserDefaults] boolForKey:constKeyLaunchInBackground] ;
}

+ (NSSet*)keyPathsForValuesAffectingDoesLaunchInBackground {
    NSString* keyPath ;
    keyPath = [NSString stringWithFormat:
               @"userDefaults.%@",
               constKeyLaunchInBackground] ;
    return [NSSet setWithObjects:
            keyPath,
            nil] ;
}

- (BOOL)hasStatusItem {
    return ([[NSUserDefaults standardUserDefaults] boolForKey:constKeyStatusItemStyle] != BkmxStatusItemStyleNone) ;
}

+ (NSSet*)keyPathsForValuesAffectingHasStatusItem {
    NSString* keyPath ;
    keyPath = [NSString stringWithFormat:
               @"userDefaults.%@",
               constKeyStatusItemStyle] ;
    return [NSSet setWithObjects:
            keyPath,
            nil] ;
}

- (BOOL)hasFloatingMenu {
#if (MAC_OS_X_VERSION_MIN_REQUIRED >= 1060)
    return [[SSYShortcutActuator sharedActuator] hasKeyComboForSelectorName:@"popUpAnywhereMenu"] ;
#else
    return NO ;
#endif
}

#if (MAC_OS_X_VERSION_MIN_REQUIRED >= 1060)
+ (NSSet*)keyPathsForValuesAffectingHasFloatingMenu {
    return [NSSet setWithObjects:
            @"dateHitShortcutActuator",
            nil] ;
}
#endif

/*
 @brief    Shim so that +keyPathsForValuesAffectingCanRunInBackground
 will work
 */
- (NSUserDefaults*)userDefaults {
    return [NSUserDefaults standardUserDefaults] ;
}

/*
 @details  Bound to in PrefsWindow.xib > General for Markster, BookMacster
 */
- (BOOL)canRunInBackground {
    if ([self hasStatusItem]) {
        return YES ;
    }
    if ([self hasFloatingMenu]) {
        return YES ;
    }
    
    // The following qualification is necessary to prevent an infinite loop
    // among this method and Cocoa bindings.  Apparently, because
    // in the "Launch in Background" checkbox in PrefsWindow.xib > General,
    // canRunInBackground is bound to the "enabled" binding and
    // constKeyLaunchInBackground is bound to the "value" binding, hitting
    // the "value" binding invokes this method as Cocoa bindings needs to
    // determine whether to redraw with the checkbox enabled or not.
    if ([[NSUserDefaults standardUserDefaults] boolForKey:constKeyLaunchInBackground]) {
        // This is kind of a kludgey piggy-back method of switching OFF
        // canRunInBackground whenever it becomes infeasible.  But it works.
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:constKeyLaunchInBackground] ;
        [[NSNotificationCenter defaultCenter] postNotificationName:constNoteLaunchInBackgroundSwitchedOff
                                                            object:self] ;
    }
    return NO ;
}

+ (NSSet*)keyPathsForValuesAffectingCanRunInBackground {
    return [NSSet setWithObjects:
            [NSString stringWithFormat:@"userDefaults.%@", constKeyStatusItemStyle],
            @"dateHitShortcutActuator",
            nil] ;
}

- (void)hitShortcutActuator:(NSNotification*)note {
    [self setDateHitShortcutActuator:[[NSDate date] timeIntervalSinceReferenceDate]] ;
}

- (id)init {
#if 0
    // How To Use Swift in Objective-C Demo
    SwiftObjcInteropTester* swoo = [SwiftObjcInteropTester new];
    NSLog(@"first swoo is %@", swoo);
    [swoo initWithFoo:-95];
    NSLog(@"second swoo is %@", swoo);
    [swoo initWithFoo:-98 foo2:@"Hola"];
    NSLog(@"third swoo is %@", swoo);
    [swoo swiftMe];
    [swoo instanceFuncWithParm:@"El Perro"];
    [SwiftObjcInteropTester classFunc];
    [SwiftObjcInteropTester classFuncWithParm:@"Bonehead"];
    
    // MARK: Secure vs. Legacy Archiving Compatibility Test
    NSError *errS = nil, *errSToS = nil, *errLToS = nil;
    [swoo release];
    
    SwiftObjcInteropTester* swoo8 = [SwiftObjcInteropTester new];
    swoo8.foo = -8;
    SwiftObjcInteropTester* swoo9 = [SwiftObjcInteropTester new];
    swoo9.foo = -9;

    NSData* secureArchive = [NSKeyedArchiver archivedDataWithRootObject:swoo8
                                                  requiringSecureCoding:YES
                                                                  error:&errS];
    NSData* legacyArchive = [NSKeyedArchiver archivedDataWithRootObject:swoo9];
 
    SwiftObjcInteropTester* swooSToS = [NSKeyedUnarchiver unarchivedObjectOfClass:[SwiftObjcInteropTester class]
                                                    fromData:secureArchive
                                                       error:&errSToS];
    NSLog(@"secure to secure: %@ errS: %@", swooSToS, errS);

    SwiftObjcInteropTester* swooSToL = [NSKeyedUnarchiver unarchiveObjectWithData:secureArchive];
    NSLog(@"secure to legacy: %@ errSToL: %@", swooSToL, errSToS);

    SwiftObjcInteropTester* swooLToS = [NSKeyedUnarchiver unarchivedObjectOfClass:[SwiftObjcInteropTester class]
                                                    fromData:legacyArchive
                                                       error:&errLToS];
    NSLog(@"legacy to secure: %@ errLToS: %@", swooLToS, errLToS);

    SwiftObjcInteropTester* swooLToL = [NSKeyedUnarchiver unarchiveObjectWithData:legacyArchive];
    NSLog(@"legacy to legacy: %@", swooLToL);

    exit(0);
#endif


#if 0
    // To decode a Base64 encoded zip file into a zip file
    NSData* b64 = [[NSData alloc] initWithContentsOfFile:@"/Users/jk/Desktop/Temp/Trouble.b64"] ;
    NSDate* raw = [b64 dataBase64Decoded] ;
    [raw writeToFile:@"/Users/jk/Desktop/Temp/Trouble.zip" atomically:YES] ;
    exit(0) ;
#endif
#if 0
#warning Logging identifier of this Mac upon launch
	NSData* hashedMACAddress = [SSYIOKit hashedMACAddress] ;
	NSString* base64HashedMACAddress = nil ;
	if (hashedMACAddress) {
		base64HashedMACAddress = [hashedMACAddress stringBase64Encoded] ;
	}
	NSLog (@"macId = %@", base64HashedMACAddress) ;
#endif
	
	self = [super init] ;
	if (self) {
        [self registerDefaultDefaults] ;

        // Use this prior to testing the default for constKeyLaunchInBackground,
        // so it will remove it if corrupt prefs left app un-showable.
        [self canRunInBackground] ;
        
        // So it will be lazily calculated if and when needed
        m_howManyTimesToShowDragTipsThisLaunch = -1 ;

#if 0
		NSLog(@"17596: availableFonts: %@", [[NSFontManager sharedFontManager] availableFonts]) ;
		
		NSString* fontName ;
		NSFont* font ;
		NSFontTraitMask traitMask ;
		
		fontName = @"LucidaGrande" ;
		font = [NSFont fontWithName:fontName size:11.0] ;
		traitMask = [[NSFontManager sharedFontManager] traitsOfFont:font] ; 
		NSLog(@"traits are %p for %@",
			traitMask,			  
			  fontName) ;

		fontName = @"Helvetica" ;
		font = [NSFont fontWithName:fontName size:11.0] ;
		traitMask = [[NSFontManager sharedFontManager] traitsOfFont:font] ; 
		NSLog(@"traits are %p for %@",
			  traitMask,			  
			  fontName) ;
		
		fontName = @"SheepSymbols" ;
		font = [NSFont fontWithName:fontName size:11.0] ;
		traitMask = [[NSFontManager sharedFontManager] traitsOfFont:font] ; 
		NSLog(@"traits are %p for %@",
			  traitMask,			  
			  fontName) ;

		fontName = @"SheepSymbols-Italic" ;
		font = [NSFont fontWithName:fontName size:11.0] ;
		traitMask = [[NSFontManager sharedFontManager] traitsOfFont:font] ; 
		NSLog(@"traits are %p for %@",
			  traitMask,			  
			  fontName) ;

		fontName = @"SheepSymbols-BoldItalic" ;
		font = [NSFont fontWithName:fontName size:11.0] ;
		traitMask = [[NSFontManager sharedFontManager] traitsOfFont:font] ; 
		NSLog(@"traits are %p for %@",
			  traitMask,			  
			  fontName) ;
#endif		

		// The following is needed in case the Inspector window has as its subject
		// a Stark whose BkmxDoc is being closed and deallocced.  If the subject is not
		// changed, besides confusing the user with an unavailable subject, such which will cause a 
		// crash or exception if the user then clicks anything in the Inspector window which causes
		// the Stark to invoke its -bkmxDoc method, which looks up its ancestry to the deallocced BkmxDoc.
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(updateSelectedStarkFromWindowNote:)
													 name:constNoteBkmxWindowsDidRearrange
												   object:nil] ;
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(updateSelectedStarkFromWindowNote:)
													 name:constNoteBkmxSelectionDidChange
												   object:nil] ;
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(processedErrorNote:)
													 name:SSYAlertDidProcessErrorNotification
												   object:nil] ;
		
		[[NSUserDefaults standardUserDefaults] addObserver:self
												forKeyPath:constKeyTableFontSize
												  selector:@selector(mikeAshObserveValueForKeyPath:ofObject:change:userInfo:)
												  userInfo:nil
												   options:0] ;
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(forgetBkmxDocNote:)
													 name:SSYUndoManagerDocumentWillCloseNotification
												   object:nil] ;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(hitShortcutActuator:)
                                                     name:SSYShortcutActuatorDidChangeShortcutsNotification
                                                   object:nil] ;				
    }

	return self ;
}

- (void)chooseRecentDocumentWithMode:(SSYAlertMode)mode
                   completionHandler:(void(^)(NSDocument*))completionHandler {
	NSArray* recentDocumentUrls = [[NSDocumentController sharedDocumentController] recentDocumentURLs] ;
	NSArray* displayNames = [[NSDocumentController sharedDocumentController] recentDocumentDisplayNames] ;

    NSMutableDictionary* contextObjectsMutant = [NSMutableDictionary new];
    [contextObjectsMutant setValue:recentDocumentUrls
                            forKey:constKeyChoices];
    /* Must copy block when passing through collection.  https://stackoverflow.com/questions/13043197/ios-store-block-in-dictionary-or-array */
    [contextObjectsMutant setValue:[[completionHandler copy] autorelease]
                            forKey:constKeyCompletionHandler];
    NSDictionary* contextObjects = [contextObjectsMutant copy];
    [contextObjectsMutant release];
    [contextObjects autorelease];
	
	NSString* msg = [NSString localizeFormat:
					 @"choose%0",
					 [[NSDocumentController sharedDocumentController] defaultDocumentDisplayName]] ;
	[[SSYListPicker listPicker] userPickFromList:displayNames
										toolTips:nil
								   lineBreakMode:NSLineBreakByTruncatingMiddle
										 message:msg
						  allowMultipleSelection:NO
							 allowEmptySelection:NO
									button1Title:[[BkmxBasis sharedBasis] labelOpen]
									button2Title:nil
									initialPicks:nil
									 windowTitle:[[BkmxBasis sharedBasis] labelOpen]
										   alert:nil
                                            mode:mode
									didEndTarget:self
								  didEndSelector:@selector(chooseRecentDocumentPart2SelectedIndexes:contextObjects:)
								  didEndUserInfo:contextObjects
							 didCancelInvocation:nil] ;
}

- (void)chooseRecentDocumentPart2SelectedIndexes:(NSIndexSet*)selectedIndexes
                                  contextObjects:(NSDictionary*)contextObjects {
    NSArray* recentDocumentUrls = [contextObjects objectForKey:constKeyChoices];
	NSURL* url = [[recentDocumentUrls objectsAtIndexes:selectedIndexes] firstObjectSafely] ;
	[[BkmxDocumentController sharedDocumentController] openAndDisplayDocumentUrl:url
                                                               completionHandler:[contextObjects objectForKey:constKeyCompletionHandler]] ;
}

- (void)showWelcomeOrShoeboxOrNothing {
	if (
		![self noWelcome]
		&&
		![[[NSUserDefaults standardUserDefaults] objectForKey:constKeyDontWelcome] boolValue]
		) {

        if ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppBookMacster) {
            BkmxDocumentController* docController = [NSDocumentController sharedDocumentController];
            if ([[docController documents] count] == 0) {
                SSYAlert* alert = [SSYAlert alert] ;
                [alert setIconStyle:SSYAlertIconInformational] ;
                [alert setRightColumnMinimumWidth:300] ;
                [alert setButton1Title:[NSString localize:@"ok"]] ;
                [alert setButton2Title:[NSString localize:@"cancel"]] ;
                [alert setWindowTitle:[[BkmxBasis sharedBasis] appNameLocalized]] ;

                NSArray* recentDocumentUrls = [docController recentDocumentURLs] ;
                BOOL recentDocAvailable = ([recentDocumentUrls count] > 0) ;

                NSArray* choices = [NSArray arrayWithObjects:
                                    [[NSString localizeFormat:
                                      @"documentChoice1",
                                      [docController defaultDocumentDisplayName]] ellipsize],
                                    [[NSString localizeFormat:
                                      @"documentChoice2",
                                      [docController defaultDocumentDisplayName]] ellipsize],
                                    nil] ;
                SSYLabelledRadioButtons* radioButtons = [SSYLabelledRadioButtons radioButtonsWithLabel:nil
                                                                                               choices:choices
                                                                                                 width:500.0] ;
                if (recentDocAvailable) {
                    // Pre-choose the second choice, "Open an existing document"
                    [radioButtons setSelectedIndex:1] ;
                }
                [alert addOtherSubview:radioButtons
                               atIndex:0] ;

                // The built-in checkbox provided by SSYAlert goes above the other subviews,
                // which in this case is the radio button.  We want it to be below, so
                // instead we make our own checkbox.
                NSButton* checkbox = [[NSButton alloc] initWithFrame:NSZeroRect] ;
                [checkbox setTitle:[[BkmxBasis sharedBasis] labelShowWelcomeOnLaunch]] ;
                [checkbox sizeToFit] ;
                [checkbox setButtonType:NSButtonTypeSwitch] ;
                [[checkbox cell] setControlSize:NSControlSizeSmall] ;
                [checkbox setFont:[SSYAlert smallTextFont]] ;
                [checkbox setState:NSControlStateValueOn] ;
                // Note that the userDefault 'dontWelcome' must be NO or nil, or else we wouldn't be here.
                // So we set 'doShow' to the opposite state, NSControlStateValueOn
                [alert addOtherSubview:checkbox
                               atIndex:1] ;
                [checkbox release] ;

                [alert display] ;

                // Added in BookMacster 1.19.8 to fix bug that window was not getting
                // keyboard focus.
                [NSApp activateIgnoringOtherApps:YES] ;

                /*
                 I noticed the following problem after updating to macOS 10.9…

                 BAD: When I Build and Run a Debug configuration in Xcode, the Welcome
                 window displays behind the Xcode window.

                 BAD: I build a Release configuration using xcodebuild, and launch
                 in Finder with ⌘O, the Welcome window displays behind the Finder
                 window which contains it (but in front of other Finder windows).

                 GOOD: But if I simply copy the Release product to a different folder,
                 and launch the copy, the Welcome window displays frontmost.

                 GOOD: Presumably as an extension of the above, it works fine after
                 zipping and unzipping as an actual user would.

                 A possible explanation is that the app is still an LSUIElement,
                 although -[BkmxAppDel applicationDidFinishLaunching:] does run
                 before this method does.

                 The following was found to solve the problem and was therefore
                 added in BookMacster 1.19.6.  -makeKeyAndOrderFront: with delay did
                 not work.
                 */
                [[alert window] performSelector:@selector(orderFrontRegardless)
                                     withObject:nil
                                     afterDelay:0.0] ;

                [alert setClickTarget:self] ;
                [alert setClickSelector:@selector(userDidSelectOpenSomething:)] ;
                [alert setClickObject:[NSNumber numberWithBool:recentDocAvailable]] ;
            }
        }
        else {
            [self openShoeboxDocumentCreateIfNeeded] ;
        }
    }
}

- (void)openShoeboxDocumentCreateIfNeeded {
    [[NSDocumentController sharedDocumentController] shoeboxDocumentForcibly:YES
                                                           completionHandler:^(BkmxDoc* shoeboxDocument) {
                                                               [shoeboxDocument configureNewShoebox] ;
                                                           }] ;
}

- (void)userDidSelectOpenSomething:(SSYAlert*)alert {
    NSButton* checkbox = [[alert otherSubviews] objectAtIndex:1] ;
	if ([checkbox state] == NSControlStateValueOff) {
		// User unchecked the "Show this window when launching" box
		[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES]
												  forKey:constKeyDontWelcome] ;
	}

    SSYLabelledRadioButtons* radioButtons = [[alert otherSubviews] objectAtIndex:0] ;
	BOOL recentDocAvailable = [[alert clickObject] boolValue] ;
	
	if ([alert alertReturn] == NSAlertFirstButtonReturn) {
        if ([radioButtons selectedIndex] == 0) {
            // User wants a new document
            [[NSDocumentController sharedDocumentController] newDocument:nil] ;
        }
        else {
            // User wants an existing document
            if (recentDocAvailable) {
                [self chooseRecentDocumentWithMode:SSYAlertModeModalSession
                                 completionHandler:NULL] ;
            }
            else {
                [[NSDocumentController sharedDocumentController] openDocument:self] ;
            }
        }
    }
}

- (NSString*)triggerUriFromDocumentUuid:(NSString*)docUuid
							 agentIndex:(NSNumber*)agentIndex
						   triggerIndex:(NSNumber*)triggerIndex {
	NSString* triggerUri = nil ;
	if ([docUuid isKindOfClass:[NSString class]]) {
		if ([agentIndex respondsToSelector:@selector(integerValue)]) {
			if ([triggerIndex respondsToSelector:@selector(integerValue)]) {
				Macster* macster = [[BkmxBasis sharedBasis] macsterWithDocUuid:docUuid
																  createIfNone:NO] ;
				Syncer* syncer = [macster syncerAtIndex:[agentIndex integerValue]] ;
				Trigger* trigger = [[syncer triggersOrdered] objectSafelyAtIndex:[triggerIndex integerValue]] ;
				triggerUri = [trigger objectUriMakePermanent:YES
													  document:nil] ;
				if (!triggerUri) {
					NSLog(@"Internal Error 309-9287 %@ %@", [syncer shortDescription], [trigger shortDescription]) ;
				}
			}
		}
	}
	
	return triggerUri ;
}

- (NSSet*)uuidsOfDocsWithSyncersError_p:(NSError**)error_p {
    NSMutableSet* uuidsOfDocsWithSyncers = [NSMutableSet new];
    NSArray* mocs = [[BkmxBasis sharedBasis] allSettingsMocsOnDisk] ;
    NSError* error = nil;
    for (NSManagedObjectContext* moc in mocs) {
        NSPersistentStore* store = [moc store1];
        NSURL* url = [store URL];
        NSString* path = [url path];
        NSString* filename = [path lastPathComponent];
        NSScanner* scanner = [[NSScanner alloc] initWithString:filename];
        [scanner scanString:constBaseNameSettings
                 intoString:NULL];
        [scanner scanString:@"-"
                 intoString:NULL];
        NSString* uuid = nil;
        [scanner scanUpToString:@"."
                     intoString:&uuid];
        [scanner release];

        if (uuid.length == 36) {
            NSError* underlyingError = nil;
            NSArray* syncers = [SSYMojo allObjectsForEntityName:constEntityNameSyncer
                                           managedObjectContext:moc
                                                        error_p:&underlyingError];
            if (underlyingError) {
                SSYMakeError(478403, @"Error finding syncers");
                error = [error errorByAddingUnderlyingError:underlyingError];
            }
            if (!error) {
                if (syncers.count > 0) {
                    [uuidsOfDocsWithSyncers addObject:uuid];
                }
            } else {
                break;
            }
        }
    }

    NSSet* answer = [uuidsOfDocsWithSyncers copy];

    [uuidsOfDocsWithSyncers release];
    [answer autorelease];

    if (error && error_p) {
        *error_p = error ;
    }

    return answer;
}

/*!
 @brief    Migrate data in Application Support, Preferences,
 and macOS Keychain items to the current version, as indicated by the
 previous version run found in the User Defaults.
*/
- (void)migrateAppDataToCurrentVersion {
    [SSYAppInfo calculateUpgradeState] ;
	SSYVersionTriplet* previousVersionTriplet = [SSYAppInfo previousVersionTriplet] ;
	SSYVersionTriplet* regularThreshold ;
    
    // The first comparison is kind of odd in that we need to act in
	// case there was *any* change in version since the last run.
	// So we don't have a fixed threshold, but use the current version
	// as the threshold
	regularThreshold = [SSYAppInfo currentVersionTriplet] ;
    
    if ([previousVersionTriplet isBkmxEffectivelyEarlierThanRegular:regularThreshold]) {
        // Data Model may have changed.  Rather than going to the trouble
        // of migrating local caches of bookmarks from web apps, just
        // hose them away.  They will be redownloaded if/when needed.
        // Note: If we did not do this,
        // -[SSYMOCManager persistentStoreCoordinatorType::::::]
        // will return NSCocoaErrorDomain code 134140 "Persistent store migration
        // failed, missing mapping model" which will be presented to the user
        // with a recovery suggestion to click "Move".  Everything will be OK
        // after that, but this is an unnecessary annoyance.
        NSArray* clientoids = [Clientoid allClientoidsWithSqliteStores] ;
        NSArray* identifiers = [clientoids valueForKeyPath:constKeyClidentifier] ;
        
        for (NSString* identifier in identifiers) {
            [SSYMOCManager removeSqliteStoreForIdentifier:identifier] ;
            NSLog(@"Due to app upgrade, deleting cache for %@", identifier) ;
        }
        
        NSString* msg = [NSString stringWithFormat:
                         @"This app version updated: %@ to %@",
                         [previousVersionTriplet string],
                         [regularThreshold string]] ;
        [[BkmxBasis sharedBasis] logFormat:msg] ;
    }

    /* BookMacster 1.12, 1.12.1 and 1.12.2 incorrectly wrote the prefs key
     "SUFeedURL" as "SUFeedURLKey".  Then I found it wrong again in
     BookMacster 1.14.3.  It looks like I fixed the read, but not the write!!*/
    regularThreshold = [SSYVersionTriplet versionTripletWithMajor:1
                                                            minor:14
                                                           bugFix:4] ;
    if ([previousVersionTriplet isBkmxEffectivelyEarlierThanRegular:regularThreshold]) {
        regularThreshold = [SSYVersionTriplet versionTripletWithMajor:1
                                                                minor:11
                                                               bugFix:9] ;
        if ([regularThreshold isBkmxEffectivelyEarlierThanRegular:previousVersionTriplet]) {
            NSString* bogusKey = @"SUFeedURLKey" ;
            NSString* bogusValue = [[NSUserDefaults standardUserDefaults] stringForKey:bogusKey] ;
            if (bogusValue) {
                [[NSUserDefaults standardUserDefaults] setObject:bogusValue
                                                          forKey:SUFeedURLKey] ; // which is "SUFeedURL"
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:bogusKey] ;
            }
        }
    }
    
    /* BookMacster 1.17-1.19 incorrectly wrote the prefs key
     "SUFeedURL" without the second slash in https://sheepsystems.com.  But
     only users who touched the Production/Beta/Alpha preference during this
     time would be affected.  But we don't know who those are.  So we do the
     following fix the first time any user who had a version between 1.17.0
     and 1.19.0 inclusive updates to 1.19.1 or later. */
    regularThreshold = [SSYVersionTriplet versionTripletWithMajor:1
                                                            minor:19
                                                           bugFix:1] ;
    if ([previousVersionTriplet isBkmxEffectivelyEarlierThanRegular:regularThreshold]) {
        regularThreshold = [SSYVersionTriplet versionTripletWithMajor:1
                                                                minor:16
                                                               bugFix:99] ;
        if ([regularThreshold isBkmxEffectivelyEarlierThanRegular:previousVersionTriplet]) {
            NSString* currentValue = [[NSUserDefaults standardUserDefaults] stringForKey:SUFeedURLKey] ;
            if ([currentValue hasPrefix:@"http:/sheep"]) {
                NSString* fixedValue = [currentValue stringByReplacingCharactersInRange:NSMakeRange(0,6)
                                                                             withString:@"https://"] ;
                [[NSUserDefaults standardUserDefaults] setObject:fixedValue
                                                          forKey:SUFeedURLKey] ;
            }
        }
    }
    
    // In BookMacster 1.19.1, and possibly earlier versions, Sheep-Sys-Worker
    // wrote its own preferences file.  This was no good because whatever
    // it wrote would not be read by main app.  That is fixed.  We remove any
    // such file..
    regularThreshold = [SSYVersionTriplet versionTripletWithMajor:1
                                                            minor:19
                                                           bugFix:4] ;
    if ([previousVersionTriplet isBkmxEffectivelyEarlierThanRegular:regularThreshold]) {
        NSString* workerPrefsPath = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"Preferences"] stringByAppendingPathComponent:@"com.sheepsystems.Sheep-Sys-Worker.plist"] ;
        [[NSFileManager defaultManager] removeIfExistsItemAtPath:workerPrefsPath
                                                         error_p:NULL] ;
    }

    regularThreshold = [SSYVersionTriplet versionTripletWithMajor:1
                                                            minor:19
                                                           bugFix:9] ;
    if ([previousVersionTriplet isBkmxEffectivelyEarlierThanRegular:regularThreshold]) {
        BOOL oldShowStatusItemPref = [[NSUserDefaults standardUserDefaults] boolForKey:@"showStatusMenu"] ;
        BkmxStatusItemStyle style = oldShowStatusItemPref ? BkmxStatusItemStyleGray : BkmxStatusItemStyleNone ;
        [[NSUserDefaults standardUserDefaults] setInteger:style
                                                   forKey:constKeyStatusItemStyle] ;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"showStatusMenu"] ;
    }

    // Remove NPAPI Plugin, which has now been replaced by Chromessenger
    regularThreshold = [SSYVersionTriplet versionTripletWithMajor:1
                                                            minor:22
                                                           bugFix:9] ;
    if ([previousVersionTriplet isBkmxEffectivelyEarlierThanRegular:regularThreshold]) {
        NSString* path =
        [[[[NSHomeDirectory() stringByAppendingPathComponent:@"Library"]
           stringByAppendingPathComponent:@"Internet Plug-Ins"]
          stringByAppendingPathComponent:@"SheepSystemsNPAPIPlugin"]
         stringByAppendingPathExtension:@"plugin"] ;
        
        // This method will return NO and an error if file not found, so
        // we ignore return value and ignore error.
        [[NSFileManager defaultManager] removeItemAtPath:path
                                                   error:NULL] ;
    }
    
    // BkmxStatusItemStyleColor is not supported starting in Version 1.22.26,
    // for compatibility with macOS 10.10 that requires
    regularThreshold = [SSYVersionTriplet versionTripletWithMajor:1
                                                            minor:22
                                                           bugFix:26] ;
    if ([previousVersionTriplet isBkmxEffectivelyEarlierThanRegular:regularThreshold]) {
        NSInteger statusItemStyle = [[NSUserDefaults standardUserDefaults] integerForKey:constKeyStatusItemStyle] ;
        if (statusItemStyle > BkmxStatusItemStyleGray) {
            // User had been using BkmxStatusItemStyleColor, now deprecated
            statusItemStyle = BkmxStatusItemStyleGray ;
            [[NSUserDefaults standardUserDefaults] setInteger:statusItemStyle
                                                       forKey:constKeyStatusItemStyle] ;
        }
    }

    // Starting with BkmkMgrs 2.0, the Sparkle feed should be https://
    // for compatibility with ATS (App Transport Security)
    regularThreshold = [SSYVersionTriplet versionTripletWithMajor:2
                                                            minor:0
                                                           bugFix:0] ;
    if ([previousVersionTriplet isBkmxEffectivelyEarlierThanRegular:regularThreshold]) {
        NSString* sparkleFeedUrl = [[NSUserDefaults standardUserDefaults] stringForKey:SUFeedURLKey] ;
        if ([sparkleFeedUrl hasPrefix:@"http:"]) {
            sparkleFeedUrl = [sparkleFeedUrl substringFromIndex:4] ;
            sparkleFeedUrl = [@"https" stringByAppendingString:sparkleFeedUrl] ;
            [[NSUserDefaults standardUserDefaults] setObject:sparkleFeedUrl
                                                      forKey:SUFeedURLKey] ;
        }
    }
    
    // Starting with BkmkMgrs 2.0.2, Google Bookmarks is no longer supported.
    // Any such Clients must be removedl
    regularThreshold = [SSYVersionTriplet versionTripletWithMajor:2
                                                            minor:0
                                                           bugFix:2] ;
    if ([previousVersionTriplet isBkmxEffectivelyEarlierThanRegular:regularThreshold]) {
        NSArray* mocs = [[BkmxBasis sharedBasis] allSettingsMocsOnDisk] ;
        for (NSManagedObjectContext* moc in mocs) {
            NSArray* clients = [SSYMojo allObjectsForEntityName:constEntityNameClient
                                           managedObjectContext:moc
                                                        error_p:NULL] ;
            for (Client* client in clients) {
                if ([[client exformat] isEqualToString:@"Google"]) {
                    [moc deleteObject:client] ;
                    [moc save:NULL] ;
                }
            }
        }
    }
    
    regularThreshold = [SSYVersionTriplet versionTripletWithMajor:2
                                                            minor:0
                                                           bugFix:4] ;
    if ([previousVersionTriplet isBkmxEffectivelyEarlierThanRegular:regularThreshold]) {
        if ([[BkmxBasis sharedBasis] iAm] != BkmxWhich1AppSmarky) {
            NSString* msg = [NSString stringWithFormat:
                             @"If you have been using %@ with Google Chrome or Chrome Canary, please click 'Learn more' to learn how to update your Extensions.",
                             [[BkmxBasis sharedBasis] appNameLocalized]]  ;
            SSYAlert* alert = [SSYAlert alert] ;
            [alert setSmallText:msg] ;
            [alert setTitleText:@"Update Info for Google Chrome Users"] ;
            [alert setIconStyle:SSYAlertIconWarning] ;
            [alert setButton1Title:@"Learn more"] ;
            [alert setButton2Title:@"I don't use Chrome/Canary"] ;
            [alert runModalDialog] ;
            NSInteger alertReturn = [alert alertReturn] ;
            if (alertReturn == NSAlertFirstButtonReturn) {
                [SSWebBrowsing browseToURLString:@"https://www.sheepsystems.com/files/support_articles/bkmx/chrome-new-exts-2015.html"
                         browserBundleIdentifier:nil
                                        activate:YES] ;
            }
        }
    }

    regularThreshold = [SSYVersionTriplet versionTripletWithMajor:2
                                                            minor:0
                                                           bugFix:7] ;
    if ([previousVersionTriplet isBkmxEffectivelyEarlierThanRegular:regularThreshold]) {
        if ([[BkmxBasis sharedBasis] iAm] != BkmxWhich1AppSmarky) {
            NSString* msg = [NSString stringWithFormat:
                             @"If you have been using %@ with Firefox, please click 'Learn more' to learn how to update your Extensions.",
                             [[BkmxBasis sharedBasis] appNameLocalized]]  ;
            SSYAlert* alert = [SSYAlert alert] ;
            [alert setSmallText:msg] ;
            [alert setTitleText:@"Update Info for Firefox Users"] ;
            [alert setIconStyle:SSYAlertIconWarning] ;
            [alert setButton1Title:@"Learn more"] ;
            [alert setButton2Title:@"I don't use Firefox"] ;
            [alert runModalDialog] ;
            NSInteger alertReturn = [alert alertReturn] ;
            if (alertReturn == NSAlertFirstButtonReturn) {
                [SSWebBrowsing browseToURLString:@"https://www.sheepsystems.com/files/support_articles/bkmx/firefox-new-exts-2015.html"
                         browserBundleIdentifier:nil
                                        activate:YES] ;
            }
        }
    }

    regularThreshold = [SSYVersionTriplet versionTripletWithMajor:2
                                                            minor:3
                                                           bugFix:0] ;
    if ([previousVersionTriplet isBkmxEffectivelyEarlierThanRegular:regularThreshold]) {
        self.needsTriggersCheckedForFirefox53 = YES;
        /* The code which this will cause to run is in Firefox53Upgrader.  We
         put it in there because we want to queue the SSYAlert which it may
         create with another SSYAlert (checking for legacy extensions), and
         the latter we are going to tests for at each launch, not just the
         first launch of BkmkMgrs 2.3. */
    }

    regularThreshold = [SSYVersionTriplet versionTripletWithMajor:2
                                                            minor:4
                                                           bugFix:4] ;
    if ([previousVersionTriplet isBkmxEffectivelyEarlierThanRegular:regularThreshold]) {
        /* Remove bogus syncing files in Application Support which were
         created and abandoned due to bugs in BkmkMgrs 2.3 thru 2.4.2 */
        NSString* appSupportPath = [[NSBundle mainBundle] applicationSupportPathForMotherApp] ;
        NSString* path1 = [appSupportPath stringByAppendingPathComponent:@"Changes"] ;
        NSString* path2;
        NSArray* filenames;
        NSMutableSet* fullPaths = [NSMutableSet new];

        path2 = [path1 stringByAppendingPathComponent:@"ExidFeedback"] ;
        filenames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path2
                                                                        error:NULL];
        for (NSString* filename in filenames) {
            NSString* path3 = [path2 stringByAppendingPathComponent:filename];
            [fullPaths addObject:path3];
        }

        path2 = [path1 stringByAppendingPathComponent:@"Exported"] ;
        filenames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path2
                                                                        error:NULL];
        for (NSString* filename in filenames) {
            NSString* path3 = [path2 stringByAppendingPathComponent:filename];
            [fullPaths addObject:path3];
        }

        for (NSString* path in fullPaths) {
            BOOL isBad = NO;
            NSString* filename = [path lastPathComponent];
            if ([filename isEqualToString:@"Opera.json"]) {
                isBad = YES;
            }
            if ([[filename pathExtension] isEqualToString:@"json"]) {
                NSArray* nameComponents = [filename componentsSeparatedByString:@"."];
                if (nameComponents.count == 4) {
                    if ([[nameComponents objectAtIndex:1] isEqualToString:[nameComponents objectAtIndex:2]]) {
                        isBad = YES;
                    }
                }
            }
            
            if (isBad) {
                [[NSFileManager defaultManager] removeItemAtPath:path
                                                           error:NULL];
            }
        }
        [fullPaths release];
    }

    regularThreshold = [SSYVersionTriplet versionTripletWithMajor:2
                                                            minor:4
                                                           bugFix:9] ;
    if ([previousVersionTriplet isBkmxEffectivelyEarlierThanRegular:regularThreshold]) {
        /* Some versions between 2.4.3 and 2.4.8 inclusive (I think it was broke,
         then fixed, then broke again) of Synkmark would create a bastard quatch
         runner launchd syncer.  The filename and label was "…BookMacster…",
         but the Program Arguments inside was "…Synkmark…".  Because of the
         latter, it mostly worked, except for a edge case if you quit Firefox
         while Synkmark was running, there would be Error 193835.

         The following code detects and removes such a bastard quatch runner
         syncer. */
        if ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppSynkmark) {
            NSString* badPrefix = [[BkmxBasis appIdentifierForAppName:constAppNameBookMacster] stringByAppendingDotSuffix:@"QuatchRunner"];
            NSDictionary* agents = [SSYLaunchdBasics installedLaunchdAgentsWithPrefix:badPrefix];
            for (NSString* agentKey in [agents allKeys]) {
                NSDictionary* syncer = [agents objectForKey:agentKey];
                NSString* label = [syncer objectForKey:@"Label"];
                if ([label hasSuffix:@"QuatchRunner"]) {
                    NSString* firstArg = [[syncer objectForKey:@"ProgramArguments"] firstObject];
                    if ([firstArg rangeOfString:@"Synkmark.app/Contents/Helpers/Sheep-Sys-Quatch"].location != NSNotFound) {
                        [SSYLaunchdGuy removeAgentWithLabel:label
                                                 afterDelay:0
                                                 justReload:NO
                                                    timeout:10.384];
                    }
                }
            }
        }
    }

    /* Version 2.4.8 would write "Changes" to the Safari Bookmarks.plist
     file even if syncing was off.  These will pile up until the next time
     that a user edits (insert, update, delete) a bookmark in Safari, after
     which Safari will remove the errant "Changes", or until the user
     switches on iCloud syncing.  So, most users will probably not be
     affected.  But for those who, for whatever reason, don't usually edit
     bookmarks in Safari, in 2.4.9 - 2.4.11, we  detected and remove such
     "Changes" here.  Because of the complexity of determining whether or
     iCloud is on when CloudKitMigrationState = 3, and the fact that it
     looks like piled-up Changes are now supported, this code was removed
     in 2.4.12. */

    regularThreshold = [SSYVersionTriplet versionTripletWithMajor:2
                                                            minor:5
                                                           bugFix:0] ;
    if ([previousVersionTriplet isBkmxEffectivelyEarlierThanRegular:regularThreshold]) {
        NSString* lastDirectory = [[NSUserDefaults standardUserDefaults] objectForKey:@"NSNavLastRootDirectory"];
        if ([lastDirectory isEqualToString:@"~/Library/Application Support/BookMacster/Bookmarkshelf Documents"]) {
            [[NSUserDefaults standardUserDefaults ] setObject:@"~/Library/Application Support/BookMacster/Collections"
                                                       forKey:@"NSNavLastRootDirectory"];
        }
    }

    regularThreshold = [SSYVersionTriplet versionTripletWithMajor:2
                                                            minor:9
                                                           bugFix:0] ;
    if ([previousVersionTriplet isBkmxEffectivelyEarlierThanRegular:regularThreshold]) {
        NSError* error = nil;
        NSSet* uuidsOfDocsWithSyncers = [self uuidsOfDocsWithSyncersError_p:&error];
        if (!error) {
            /* This loop for updating documents looks like it may not always
             close documents that are opened.  Do not clone this loop.  Clone
             instead the loop in version case 2.9.8. */
            for (NSString* uuid in uuidsOfDocsWithSyncers) {
            [[BkmxDocumentController sharedDocumentController] openDocumentWithUuid:uuid
                                                                            appName:nil
                                                                            display:NO
                                                                     aliaserTimeout:18.765
                                                                  completionHandler:^(BkmxDoc* bkmxDoc,
                                                                                      NSURL* resolvedUrl,
                                                                                      BOOL documentWasAlreadyOpen,
                                                                                      NSError* underlyingError) {
                                                                      NSError* error = nil;
                                                                      if (!bkmxDoc) {
                                                                          error = SSYMakeError(478405, @"Error opening to get legacy agents");
                                                                      } else if (![bkmxDoc respondsToSelector:@selector(realizeSyncersToWatchesError_p:)]) {
                                                                          /* Got a crash report from a user of BkmkMgrs 2.9.8 before the above
                                                                           if() was written, indicating that bkmxDoc was a old Bkmslf !! */
                                                                          NSString* msg = [NSString stringWithFormat:
                                                                                           @"Tried to migrate Syncers of instance of %@.  That will not work here.",
                                                                                           [bkmxDoc className]];
                                                                          error = SSYMakeError(478406, msg);
                                                                      }
                                                                      error = [error errorByAddingUnderlyingError:underlyingError];

                                                                      if (!error) {
                                                                          BOOL ok = [bkmxDoc realizeSyncersToWatchesError_p:&underlyingError];
                                                                          if (!ok) {
                                                                              error = SSYMakeError(478407, @"Error syncing legacy agents");
                                                                              error = [error errorByAddingUnderlyingError:underlyingError];
                                                                          }
                                                                      }
                                                                      [bkmxDoc close];
                                                                      [[BkmxBasis sharedBasis] logError:error
                                                                                        markAsPresented:NO];
                                                                  }] ;
            }

            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"workerAgentPath"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }

	/* In version 2.9.1, I replaced class BkmxWatch with Watch.  But users
     updating from 2.9.0 with syncing active have BkmxWatch objects in their
     user defaults under key constKeyWatches.  We need to replace those. */
    regularThreshold = [SSYVersionTriplet versionTripletWithMajor:2
                                                            minor:9
                                                           bugFix:1] ;
    if ([previousVersionTriplet isBkmxEffectivelyEarlierThanRegular:regularThreshold]) {
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSData* data  = [[NSUserDefaults standardUserDefaults] valueForKey:constKeyWatches];
        if (![data isKindOfClass:[NSData class]]) {
            data = nil;
        }
        NSSet <BkmxWatch*> * oldWatches = nil;
        if (data) {
            // Sorry, Apple: Need to get old watches with deprecated method
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
            oldWatches = [NSKeyedUnarchiver unarchiveObjectWithData:data];
#pragma GCC diagnostic warning "-Wdeprecated-declarations"
        }
        // Check for corrupt prefs
        if (![oldWatches respondsToSelector:@selector(member:)]) {
            oldWatches = nil ;
        }

        /* The following if() is defensive because users who pass the
         previous version threshold test above should have only BkmxWatch
         objects in their watches (oldWatches). */
        if ([[oldWatches anyObject] respondsToSelector:@selector(triggerOrSyncerUri)]) {
            /* User has old BkmxWatch objects which need to be converted
             to new Watch objects. */
            NSMutableSet <Watch*> * newWatches = [NSMutableSet new];
            for (BkmxWatch* oldWatch in oldWatches) {
                Watch* newWatch = [oldWatch copyAsWatch];
                [newWatches addObject:newWatch];
                [newWatch release];
            }

            /* Sorry, Apple: Need to re-set old watches with deprecated method
             for users who are doing a big jump upgrade from less than 2.9.1
             to 3.0 or later.  Later in this method, in the branch for
             converting users to 3.0.0, the watches now being set will be
             converted again, this time to secure archives. */
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
            data = [NSKeyedArchiver archivedDataWithRootObject:newWatches];
#pragma GCC diagnostic warning "-Wdeprecated-declarations"
            [newWatches release];
            [[NSUserDefaults standardUserDefaults] setObject:data
                                                      forKey:constKeyWatches];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }

    regularThreshold = [SSYVersionTriplet versionTripletWithMajor:2
                                                            minor:9
                                                           bugFix:3] ;
    if ([previousVersionTriplet isBkmxEffectivelyEarlierThanRegular:regularThreshold]) {
        NSError* error = nil;
        NSSet* uuidsOfDocsWithSyncers = [self uuidsOfDocsWithSyncersError_p:&error];

        if (!error) {
            NSInteger __block countdown = uuidsOfDocsWithSyncers.count;
            /* This loop for updating documents looks like may not always
             close documents that are opened.  Do not clone this loop.  Clone
             instead the loop in the next version case, 2.9.8. */
            for (NSString* __block uuid in uuidsOfDocsWithSyncers) {
                [[BkmxDocumentController sharedDocumentController] openDocumentWithUuid:uuid
                                                                                appName:nil
                                                                                display:NO
                                                                         aliaserTimeout:18.765
                                                                      completionHandler:^(BkmxDoc* bkmxDoc,
                                                                                          NSURL* resolvedUrl,
                                                                                          BOOL documentWasAlreadyOpen,
                                                                                          NSError* underlyingError) {
                                                                          NSError* error = nil;
                                                                          if (bkmxDoc) {
                                                                              if (![bkmxDoc respondsToSelector:@selector(realizeSyncersToWatchesError_p:)]) {
                                                                                  /* Similar reasoning to migration to 2.9.0, above.  I thought I should
                                                                                   fix this one too*/
                                                                                  NSString* msg = [NSString stringWithFormat:
                                                                                                   @"Tried to migrate Syncers of instance of %@.  That will not work here.",
                                                                                                   [bkmxDoc className]];
                                                                                  error = SSYMakeError(478515, msg);
                                                                                  error = [error errorByAddingUnderlyingError:underlyingError];
                                                                              }

                                                                              if (!error) {
                                                                                  Macster* macster = [bkmxDoc macster];
                                                                                  uint64_t syncerConfig = [macster syncerConfigValue];
                                                                                  if ((syncerConfig & constBkmxSyncerConfigIsAdvanced) == 0) {
                                                                                      // This document has only Simple Syncers
                                                                                      NSArray* syncers = [SSYMojo allObjectsForEntityName:constEntityNameSyncer
                                                                                                                     managedObjectContext:macster.managedObjectContext
                                                                                                                                  error_p:&error];
                                                                                      if (!error) {
                                                                                          for (Syncer* syncer in syncers) {
                                                                                              NSMutableSet* badTriggers = [NSMutableSet new];
                                                                                              for (Trigger* trigger in [syncer triggers]) {
                                                                                                  if ([trigger triggerTypeValue] == BkmxTriggerBrowserQuit) {
                                                                                                      Client* client = [trigger client];
                                                                                                      if ([[client exformat] isEqualToString:constExformatFirefox]) {
                                                                                                          if ([[client extoreMedia] isEqualToString:constBkmxExtoreMediaThisUser]) {
                                                                                                              [badTriggers addObject:trigger];
                                                                                                          }
                                                                                                      }
                                                                                                  }
                                                                                              }

                                                                                              for (Trigger* badTrigger in badTriggers) {
                                                                                                  [[BkmxBasis sharedBasis] logFormat:@"Removing deprecated trigger %@", [Trigger smallDescriptionOfTrigger:badTrigger]];
                                                                                                  [syncer removeTriggersObject:badTrigger];
                                                                                              }

                                                                                              [badTriggers release];
                                                                                          }
                                                                                          [bkmxDoc saveMacster];

                                                                                      }

                                                                                      BOOL ok = [bkmxDoc realizeSyncersToWatchesError_p:&underlyingError];
                                                                                      if (!ok) {
                                                                                          error = SSYMakeError(478517, @"Error realizing revised Syncers");
                                                                                          error = [error errorByAddingUnderlyingError:underlyingError];
                                                                                      }
                                                                                      [bkmxDoc close];
                                                                                  }
                                                                              }
                                                                          } else {
                                                                              /* This will happen if the file of bkmxDoc has been removed
                                                                               within the last 60 days.  Its orphaned settings file will
                                                                               still be.  Ignore this error. */
                                                                          }

                                                                          @synchronized (self) {
                                                                              countdown--;
                                                                              if (countdown == 0) {
                                                                                  [[BkmxBasis sharedBasis] rebootSyncAgentReport_p:NULL
                                                                                                                           title_p:NULL
                                                                                                                           error_p:nil];
                                                                              }
                                                                          }
                                                                      }] ;
            }
        }
    }

    regularThreshold = [SSYVersionTriplet versionTripletWithMajor:2
                                                            minor:9
                                                           bugFix:8] ;
    if ([previousVersionTriplet isBkmxEffectivelyEarlierThanRegular:regularThreshold]) {
        /* Prior to BkmxMgrs 3.0, there was a section here to call
         -[BkmxDoc migrateHashesFromLegacySettingsMOCToUserDefaults] on any
         known .bmco file which has syncers.  To eliminate a bunch of code
         and attributes in the data model starting in Bkmx019, we don't do
         that any more.  Users updating from prior to BkmkMgrs 2.9.8 will
         start with last(im|port)(Pre|Post)Hash values of 0x0.  I think that
         just means they need to import from all browsers, not a big deal
         for someone who has waited that long to update their app. */

        /* In this version, we added ivars to the Watch object, so
         that the archives in user defaults key `watches` are not in valid. */
        [[NSUserDefaults standardUserDefaults] removeAllWatchesExceptDocUuid:nil];
        [self realizeSyncersOfAllDocumentsToWatchesThenDo:NULL];

        /* Finally, we need the new BkmxAgent to read the new watch format */
        [[BkmxBasis sharedBasis] rebootSyncAgentReport_p:NULL
                                                 title_p:NULL
                                                 error_p:NULL];
    }

    regularThreshold = [SSYVersionTriplet versionTripletWithMajor:2
                                                            minor:9
                                                           bugFix:12] ;
    if ([previousVersionTriplet isBkmxEffectivelyEarlierThanRegular:regularThreshold]) {
        NSArray* mocs = [[BkmxBasis sharedBasis] allSettingsMocsOnDisk] ;
        for (NSManagedObjectContext* moc in mocs) {
            NSArray* clients = [SSYMojo allObjectsForEntityName:constEntityNameClient
                                           managedObjectContext:moc
                                                        error_p:NULL] ;
            for (Client* client in clients) {
                if (NO
                    || [[client exformat] isEqualToString:constExformatBraveBeta]
                    || [[client exformat] isEqualToString:constExformatBravePublic]
                    || [[client exformat] isEqualToString:constExformatCanary]
                    || [[client exformat] isEqualToString:constExformatChrome]
                    || [[client exformat] isEqualToString:constExformatChromium]
                    || [[client exformat] isEqualToString:constExformatEpic]
                    || [[client exformat] isEqualToString:constExformatVivaldi]
                    ) {
                    if ([client launchBrowserPref] == BkmxIxportLaunchBrowserPreferenceNever) {
                        [client setLaunchBrowserPref:BkmxIxportLaunchBrowserPreferenceAuto];
	                    [moc save:NULL] ;
                    }
                }
            }
        }
    }

    regularThreshold = [SSYVersionTriplet versionTripletWithMajor:2
                                                            minor:10
                                                           bugFix:21] ;
    if ([previousVersionTriplet isBkmxEffectivelyEarlierThanRegular:regularThreshold]) {
        if (![[NSUserDefaults standardUserDefaults] boolForKey:constKeyDidWarnBrave1_7]) {
            /* User must reinstall any Brave extensions because they were
             configured with ExtoreName = "ExtoreBrave" in their localStorage.
             Need to change to "ExtoreBravePublic". */
            NSArray* clientoids = [Clientoid allClientoidsForLocalAppsThisUserByPopularity:NO
                                                                      includeUninitialized:YES
                                                                      includeNonClientable:YES] ;
            NSManagedObjectContext* moc = [SSYMOCManager managedObjectContextType:NSInMemoryStoreType
                                                                            owner:nil
                                                                       identifier:nil
                                                                         momdName:nil
                                                                recreateIfCorrupt:NO
                                                                          error_p:NULL] ;
            NSMutableArray* extores = [[NSMutableArray alloc] init] ;
            for (Clientoid* clientoid in clientoids) {
                if ([[clientoid exformat] isEqualToString:[Extore exformatForExtoreClass:[ExtoreBravePublic class]]]) {
                    Client* client = [NSEntityDescription insertNewObjectForEntityForName:constEntityNameClient
                                                                   inManagedObjectContext:moc];
                    [client setLikeClientChoice:[ClientChoice clientChoiceWithClientoid:clientoid]];
                    Extore* extore = [Extore extoreForIxporter:[client importer]
                                                     clientoid:nil
                                                     jobSerial:0
                                                       error_p:NULL] ;
                    if (extore) {
                        [extores addObject:extore] ;
                    }
                }
            }
            
            NSMutableArray* mustReinstallItemDescriptions = [NSMutableArray new];
            for (Extore* extore in extores) {
                for (NSInteger extensionIndex = 1; extensionIndex <= 2; extensionIndex++) {
                    NSInteger braveExtensionVersion = [extore extensionVersionForExtensionIndex:extensionIndex];
                    if (braveExtensionVersion > 0) {
                        NSString* item =
                        [NSString stringWithFormat:@"     • %@ extension in Brave",
                         (extensionIndex == 1) ? @"Sync" : @"Button"];
                        if (![extore.client.profileName isEqualToString:[ExtoreBravePublic defaultProfileName]]) {
                            item = [item stringByAppendingFormat:
                                    @" profile \"%@\"",
                                    extore.client.profileName];
                        }
                        [mustReinstallItemDescriptions addObject:item];
                    }
                }
            }
            [extores release];
            
            if (mustReinstallItemDescriptions.count > 0) {
                NSString* msg = [NSString stringWithFormat:
                                 @"You have previously installed the following browser extensions into Brave\n\n%@.\n\nThere is a little chore you must do to make it work again, and other things to be aware of when using Brave 1.7, scheduled for release on April 7, 2020…",
                                 [mustReinstallItemDescriptions componentsJoinedByString:@"\n"]];
                NSInteger alertReturn = [SSYAlert runModalDialogTitle:@"Sorry to bother you!"
                                                              message:msg
                                                              buttons:
                                         @"Tell me more",
                                         @"I like it when things don't work",
                                         nil];
                if (alertReturn == SSYAlertFirstButtonReturn) {
                    [SSWebBrowsing browseToURLString:@"https://sheepsystems.com/discuss/YaBB.pl?num=1585976459/0#0"
                             browserBundleIdentifier:nil
                                            activate:YES];
                    [[NSUserDefaults standardUserDefaults] setBool:YES
                                                            forKey:constKeyDidWarnBrave1_7];
                }
            }
            
            [mustReinstallItemDescriptions release];
        }
    }
    
    regularThreshold = [SSYVersionTriplet versionTripletWithMajor:2
                                                            minor:11
                                                           bugFix:0];
    if ([previousVersionTriplet isBkmxEffectivelyEarlierThanRegular:regularThreshold]) {
        NSInteger oldSyncSnapshotsCount;
        NSNumber* oldSyncSnapshotsNumber = [[NSUserDefaults standardUserDefaults] valueForKey:@"syncSnapshots"];
        if ([oldSyncSnapshotsNumber respondsToSelector:@selector(integerValue)]) {
            oldSyncSnapshotsCount = [oldSyncSnapshotsNumber integerValue] ;
            if (oldSyncSnapshotsCount != 5) {
                // A custom value was set, not the old default value of 5
                NSInteger syncSnapshotsLimitMB = oldSyncSnapshotsCount * 6 * 10 / 5 ;
                [[NSUserDefaults standardUserDefaults] setSyncSnapshotsLimitMB:syncSnapshotsLimitMB];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"syncSnapshots"];
            } else {
                // Do not set.  The default value in DefaultDefaults.plist will be used.
            }
                
        }
    }

    regularThreshold = [SSYVersionTriplet versionTripletWithMajor:2
                                                            minor:11
                                                           bugFix:0] ;
    if ([previousVersionTriplet isBkmxEffectivelyEarlierThanRegular:regularThreshold]) {
        NSString* baseKey = @"SSYAlertSounderCustom-";
        NSArray* suffixes = @[@"WindUp", @"StartWork", @"Success", @"Failure"];
        NSMutableArray* paths = [NSMutableArray new];
        for (NSString* suffix in suffixes) {
            NSString* key = [baseKey stringByAppendingString:suffix];
            NSString* path = [[NSUserDefaults standardUserDefaults] objectForKey:key];
            if (path) {
                [paths addObject:path];
            }
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        }
        
        if (paths.count > 0) {
            NSString* message = [NSString stringWithFormat:
                                 @"You have previously set custom sound file(s) to play when %@'s Agent performs syncing tasks.  In accordance with current Apple recommendations, this version of %@ has changed the way we do that.  These sounds are now delivered via your macOS Notification Center.\n\nIf you wish to continue hearing your custom sounds, click the \"?\" button below to learn how to move and rename the following custom sound files:\n\n%@",
                                 [[BkmxBasis sharedBasis] appNameLocalized],
                                 [[BkmxBasis sharedBasis] appNameLocalized],
                                 [paths listValuesOnePerLineForKeyPath:nil]];
            SSYAlert* alert = [SSYAlert new];
            alert.titleText = @"Sorry to bother you";
            alert.smallText = message;
            alert.helpAddress = @"agentCustomSound";
            [alert runModalDialog];
            [alert release];
        }
        
        [paths release];
        
        /* Migrate preference from the old definition
         "Time to wait before starting to import changes from web browsers"
         to the new definition:
         "Delay before starting to import changes from web browsers" */
        NSInteger oldDelay = [Stager bookmarksChangeDelay2];
        /* If no value in preferences, the above will return the value from
         DefaultDefaults.plist, which was 300 but is now 60. */
        NSInteger newDelay;
        switch (oldDelay) {
            case 30:
            case 150:
            case 210:
            case 270:
                newDelay = oldDelay + 30;
                break;
            case 300:
                /* This should not happen, except in testing when Xcode
                 fails to copy the new DefaultDefaults.plist to the product's
                 Contents/Resources.  The value in DefaultDefaults.plist has
                 been changed to from 300 to 60. */
                newDelay = oldDelay;
                break;
            default:
                newDelay = 60;
        }
        /* The following test is so that users who have never touched
         bookmarksChangeDelay2 will continue to have no value for this key
         in their preferences file.  It might come in handy, as it did with
         the change from 300 to 60 in BkmkMgrs 3.0. */
        if (newDelay != oldDelay) {
            [[NSUserDefaults standardUserDefaults] setObject:@(newDelay)
                                                      forKey:constKeyBookmarksChangeDelay2];
        }
    }
    
    regularThreshold = [SSYVersionTriplet versionTripletWithMajor:3
                                                            minor:0
                                                           bugFix:0] ;
    if ([previousVersionTriplet isBkmxEffectivelyEarlierThanRegular:regularThreshold]) {
        /* Remove all stagings, because they will be changed to use
         secure archiving.  Stagings are pretty much ephemeral. */
        [Stager removeAllStagingsExceptDocUuid:nil];
        
        [[NSUserDefaults standardUserDefaults] upgradeDeprecatedArchiveDataForOldKey:constKeyColorSortable
                                                                              newKey:constKeyColorSort];
        [[NSUserDefaults standardUserDefaults] upgradeDeprecatedArchiveDataForOldKey:constKeyColorUnsortable
                                                                              newKey:constKeyColorUnsort];

        /* However, watches are not ephemeral, so we convert those now. */
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSData* data  = [[NSUserDefaults standardUserDefaults] valueForKey:constKeyWatches];
        if (![data isKindOfClass:[NSData class]]) {
            data = nil;
        }
        NSSet <Watch*> * watches = nil;
        if (data) {
            // Sorry, Apple: Need to get old watches with deprecated method
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
            watches = [NSKeyedUnarchiver unarchiveObjectWithData:data];
#pragma GCC diagnostic warning "-Wdeprecated-declarations"
        }
        // Check for corrupt prefs
        if (![watches respondsToSelector:@selector(member:)]) {
            watches = nil ;
        }
        
        if (watches) {
            for (Watch* watch in watches) {
                NSObject* subject = watch.subject;
                if ([subject isKindOfClass:[NSNumber class]]) {
                    watch.subject = [NSString stringWithFormat:@"%ld", [(NSNumber*)subject integerValue]];
                } else if ([subject isKindOfClass:[SSYRecurringDate class]]) {
                    watch.subject = [(SSYRecurringDate*)subject stringRepresentation];
                }
            }
            NSError* error = nil;
            data = [NSKeyedArchiver archivedDataWithRootObject:watches
                                         requiringSecureCoding:YES
                                                         error:&error];
            if (error) {
                NSLog(@"Internal Error 774-2348: %@", error);
            }
            [[NSUserDefaults standardUserDefaults] setObject:data
                                                      forKey:constKeyWatches];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }

    }
}

/*!
 @brief    If app is launched by doubleclicking a document, this method
 runs before the document is opened, unlike -applicationDidFinishLaunching:
 which runs after.

 @details  Warning.  Do not use this method for anything GUI.
 See details in doFinishLaunchingEarlyChores for links to references.
- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {
}
 */

- (void)cleanDefunctLogEntriesTimer:(NSTimer*)notUsed {
	[[BkmxBasis sharedBasis] cleanDefunctLogEntries] ;
}

- (NSString*)associatedBackgroundAppBundleIdentifier {
    return [[BkmxBasis sharedBasis] urlHandlerBundleIdentifier] ;
}

- (BOOL)application:(NSApplication*)app
           openFile:(NSString*)filename {
    [self doFinishLaunchingEarlyChores] ;

    // Return NO to defer document opening to usual methods
    return NO ;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Remember that, if the app is launched by doubleclicking one of its documents,
    // this method will execute ^after^ the document is initialized and loaded.
    // If you want something to always execute before any document loads, put
    // it into -init, or if it requires GUI
    // or AppKit, in -doFinishLaunchingEarlyChores instead of here.

    [self doFinishLaunchingEarlyChores] ;

    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults] ;
    
    [[Sparkler shared] start];

    // Starting in BookMacster 1.11.6, we no longer install an event handler
    // for bookmacster:// here.  The Sheep-Systems-Bookmarks-UrlHandler
    // helper does it.

    // Note that the following will *create* a DoxtusMenu instance, which
    // is the only one ever created.  Like a singleton, but it's not.
    DoxtusMenu* doxtusMenu = [self doxtusMenu] ;
    @try {
        [doxtusMenu bind:constKeyStatusItemStyle
                toObject:[NSUserDefaults standardUserDefaults]
             withKeyPath:constKeyStatusItemStyle
                 options:0] ;
    }
    @catch (NSException *exception) {
        // This happened in developing BookMacster 1.19.9.
        NSLog(@"Warning 390-7348: %@", exception) ;
    }
    @finally {
    }

    if ([userDefaults boolForKey:SUEnableAutomaticChecksKey]) {
        [SSYLicenseMaintainer maintainAfterMin:0.05
                                           max:0.08] ;
    }

    [userDefaults forgetDefunctDocumentsWithWatchesAndEnDisableBkmxAgent];

    if ([SSYAppInfo isNewUser]) {
        // Smarky deviates from the value in DefaultDefaults.plist in…
        if ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppSmarky) {
            [[NSUserDefaults standardUserDefaults] setBool:YES
                                                    forKey:constKeySortShoeboxDuringSyncs] ;
        }

        /* If user never saw that it was green, user will not need to know
         to know that we "changed" it to yellow. */
        [[NSUserDefaults standardUserDefaults] setBool:YES
                                                forKey:constKeyYellowSyncExplained];
    }

    // This is for *my* convenience, in case I kill the app while debugging
    [userDefaults synchronize] ;

    [self showNewUserHelpOrElseLaunchDocsOrWelcomeAndAnyErrors] ;

    // cleanDefunctLogEntries, first in 75 seconds…
    [NSTimer scheduledTimerWithTimeInterval:75.0
                                     target:self
                                   selector:@selector(cleanDefunctLogEntriesTimer:)
                                   userInfo:nil
                                    repeats:NO] ;
    // then once a day…
    [NSTimer scheduledTimerWithTimeInterval:[BkmxBasis secondsPerDay]
                                     target:self
                                   selector:@selector(cleanDefunctLogEntriesTimer:)
                                   userInfo:nil
                                    repeats:YES] ;

    [[BkmxBasis sharedBasis] scheduleFileCruftCleaning];

    // Create an Active Browser Observer, and *then* a Shortcut Actuator.
    // Together they will handle our global keyboard shortcuts
    [ActiveBrowserObserver sharedObserver] ;
    if ([[SSYShortcutActuator sharedActuator] hasAnyKeyCombo]) {
        [[ActiveBrowserObserver sharedObserver] startObserving] ;
        [[ActiveBrowserObserver sharedObserver] observeNow];
    }

    [[BkmxBasis sharedBasis] logFormat:@"Did finish launching"] ;
    NSString* mainBundlePath = [[NSBundle mainBundle] bundlePath];
    [[BkmxBasis sharedBasis] logFormat:@"Did finish launching bundlePath: %@", mainBundlePath];

    // Added in BookMacster 1.12.6, to make our URL handler *persist* in
    // the LaunchServices preferences.  Apparently it does not, because
    // maybe it is our -UrlHandler is a helper, in Contents/Helpers ?
    LSSetDefaultHandlerForURLScheme(
                                    (CFStringRef)constBkmxUrlScheme,
                                    (CFStringRef)[[BkmxBasis sharedBasis] urlHandlerBundleIdentifier]
                                    ) ;

    if ([SSYProcessTyper currentType] != NSApplicationActivationPolicyRegular) {
        if ([[NSUserDefaults standardUserDefaults] integerForKey:constKeyStatusItemStyle] == BkmxStatusItemStyleNone) {
            KeyCombo keyCombo = [[SSYShortcutActuator sharedActuator] keyComboForSelectorName:@"popUpAnywhereMenu"] ;
            if (keyCombo.code != -1) {
                // Launching in background, and the only way for the user to
                // to show the app is going to be the keyboard shortcut to
                // the Floating Menu.
                NSString* readableCombo = SRStringForCocoaModifierFlagsAndKeyCode(keyCombo.flags, keyCombo.code) ;
                NSString* format = NSLocalizedString(@"%@ is running in background.", @"The %@ is the name of an app");
                NSString* title = [NSString stringWithFormat:format, [[BkmxBasis sharedBasis] appNameLocalized]];
                NSString* body = [NSString stringWithFormat:
                                  @"To show %@, activate a web browser and type %@",
                                  [[BkmxBasis sharedBasis] appNameLocalized],
                                  readableCombo] ;
                [BkmxNotifierCaller presentUserNotificationTitle:title
                                                  alertNotBanner:YES
                                                        subtitle:nil
                                                            body:body
                                                       soundName:nil
                                                      actionDics:nil
                                                         error_p:NULL];

            }
        }
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:constKeyDontWarnV3UpgradeNeeded]) {
        if (![[BkmxBasis sharedBasis] verifyVersionIsAdequate]) {
            /* Since this is only during launching the app, and since the user
             has not yet attempted to ixport with Safari, there is no error yet.
             We want this to be displayed as only informational. */
            NSString* msg = [NSString stringWithFormat:
                             @"%@\n\n%@",
                             [[BkmxBasis sharedBasis] versionInadequateDescription],
                             [[BkmxBasis sharedBasis] versionInadequateRecoverySuggestion]];
            SSYAlert* alert = [SSYAlert new];
            [alert setSmallText:msg];
            [alert setTitleText:@"Update required for macOS 10.13 Ventura"];
            [alert setCheckboxTitle:[NSString localize:@"dontAskAgain"]];
            [alert setRightColumnMinimumWidth:375.0];
            [alert setIconStyle:SSYAlertIconInformational];
            [alert setButton1Title:[NSString localize:@"checkForUpdate"]];
            [alert setButton2Title:[NSString localize:@"close"]];
            [alert runModalDialog];
            NSInteger alertReturn = [alert alertReturn];

            if (alertReturn == NSAlertFirstButtonReturn) {
                [[Sparkler shared] checkForUpdates];
            }
            if ([alert checkboxState] == NSControlStateValueOn) {
                [[NSUserDefaults standardUserDefaults] setBool:YES
                                                        forKey:constKeyDontWarnV3UpgradeNeeded] ;
            }
        }
    }
}



/*!
 @brief    Method for chores which must always run when app launches,
 and always before any document is opened, even if app is launched
 by doubleclicking a document.

 @details  http://lists.apple.com/archives/Cocoa-dev/2010/Sep/msg00448.html
 or http://www.cocoabuilder.com/archive/cocoa/293279-very-simple-demo-modal-dialog-causes-later-modal-session-to-crash.html?q=applicationWillFinishLaunching+Krinock#293279
*/
- (void)doFinishLaunchingEarlyChores {

	if (![self didFinishLaunchingEarlyChores]) {
        [self setDidFinishLaunchingEarlyChores:YES];

		/* Main Thread Chores */
        if (([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppBookMacster) || ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppMarkster)) {
            [self launchUrlHandlerAfterDelay:1.0];
        }
        [self maybeTransformToUIElement];
        [self migrateAppDataToCurrentVersion];
        [[NSApp mainMenu] doInitialization];
        [self tweakMainMenu];
        [Firefox53Upgrader upgradeAsNeeded];
        [ExtensionsVersionChecker checkInstalledExtensionVersions];
        
        dispatch_queue_t aSerialQueue = dispatch_queue_create(
                                                              "com.sheepsystems.BkmkMgrs.earlyChores",
                                                              DISPATCH_QUEUE_SERIAL
                                                              ) ;
        dispatch_async(aSerialQueue, ^{
            /* Secondary Thread Chores */
            [self ensureGoodLocation];
            [self checkNoSiblingAppsRunningElseWarnAndQuit];
            [self killAnyLegacyLaunchdAgents];
            [self killAnyOldieLoginItemsWithBasename:constAppNameBkmxAgent];
            [[NSUserDefaults standardUserDefaults] updateBkmxAgentServiceStatus_offOnly:NO];
            [[BkmxBasis sharedBasis] checkAndHandleAppExpirationOrUpdate:^{
                [self ensureChromessengerSymlink];
                
                /* Trying this to eliminate several seconds of delay which
                 sometimes occurs when a sound is played for the first time. */
                [[SSYSound shared] prepare:@"Dupe"];
                [[SSYSound shared] prepare:@"LandBookmark"];
            }];
        });
    }
}

- (void)launchUrlHandlerAfterDelay:(NSTimeInterval)launchDelaySeconds {
    /* Until 20201204, the following code ran immediately.  But even after
     adding the 3-second delay for *verifying* the launch (see "Until 20201123"
     below), it still fails 1/8 times, and now Activity Monitor shows that
     indeed the URL handler is *not* running.  So now I've added the following
     which delays the *launching*.  After this fix, I launched it 12 times and
     got no failures.  We'll see what happens!
     
     Note that this 1-second delay might make the URL Handler no longer a
     viable "dance partner" with +[SSYProcessTyper dance].  But after spending
     20 minutes reading the history, I think this is no longer necessary, and
     if it is necessary in some edge edge case, +[SSYProcessTyper dance] has
     the fallback of dancing with Finder.
     */
    NSString* queueName = [NSString stringWithFormat:
                           @"com.sheepsystems.BkmkMgrs.launchUrlHandler-%02ld",
                           m_launchUrlHandlerFailureCount];
    dispatch_queue_t aSerialQueue = dispatch_queue_create(
                                                          [queueName UTF8String],
                                                          DISPATCH_QUEUE_SERIAL
                                                          );
    dispatch_after(
                   dispatch_time(DISPATCH_TIME_NOW, launchDelaySeconds * NSEC_PER_SEC),
                   aSerialQueue, ^{
        sleep(2);
        NSString* helperName = [[[BkmxBasis sharedBasis] appFamilyName] stringByAppendingString:@"-UrlHandler.app"] ;
        NSString* path = [[NSBundle mainBundle] pathForHelper:helperName];
        NSInteger __block errorCode = 0;
        NSString* __block errorDescription = nil;
        NSError* underlyingError = nil;
        BOOL ok = NO;
#if 0
#warning Simulating URL Handler launch failure
        if (m_launchUrlHandlerFailureCount < 10) {
            ok = YES;
        } else {
            ok = [SSYOtherApper launchApplicationPath:path
                                             activate:NO
                                        hideGuardTime:0.0
                                              error_p:&underlyingError] ;
        }
#else
        ok = [SSYOtherApper launchApplicationPath:path
                                         activate:NO
                                    hideGuardTime:0.0
                                          error_p:&underlyingError] ;
#endif
        if (ok) {
            if (underlyingError == nil) {
                [[BkmxBasis sharedBasis] logFormat:@"Says macOS: Succeeded launching %@", path];
            } else {
                errorCode = 834001;
                errorDescription = @"Says macOS: Launched URL Handler OK but with error?!?!";
            }
        } else {
            errorCode = 834002;
            errorDescription = @"Says macOS: Failed to launch our URL Handler";
        }
        
        /* Until 20201123, the following code ran immediately.  But after doing a
         dozen or so launches on my new MacBook Air with Apple Silicon, two of them
         failed with error 834003 and in the last one I saw that in fact the URL
         Handler *was* running.  Assuming some time delay may be needed.  Here ypu
         */
        NSInteger verifyDelaySeconds = 3;
        dispatch_queue_t aSerialQueue = dispatch_queue_create(
                                                              "com.sheepsystems.BkmkMgrs.verifyUrlHandlerRunning",
                                                              DISPATCH_QUEUE_SERIAL
                                                              );
        dispatch_after(
                       dispatch_time(DISPATCH_TIME_NOW, verifyDelaySeconds * NSEC_PER_SEC),
                       aSerialQueue, ^{
            sleep(3);
            NSRunningApplication* urlHandler = [[NSRunningApplication runningApplicationsWithBundleIdentifier:[[BkmxBasis sharedBasis] urlHandlerBundleIdentifier]] firstObject];
            NSInteger maxAllowedTrials = 7;
            if (urlHandler) {
                NSString* msg = [NSString stringWithFormat:
                                 @"URL Handler has pid = %05d",
                                 urlHandler.processIdentifier];
                [[BkmxBasis sharedBasis] logString:msg];
            } else if (m_launchUrlHandlerFailureCount < maxAllowedTrials) {
                m_launchUrlHandlerFailureCount++;
                NSTimeInterval newDelay = 2 * m_launchUrlHandlerFailureCount;
                NSString* msg = [NSString stringWithFormat:
                 @"Failure %ld launching URL Handler.  Will retry after %0.2f seconds.",
                 (long)m_launchUrlHandlerFailureCount,
                 newDelay];
                [[BkmxBasis sharedBasis] logString:msg];
                [self launchUrlHandlerAfterDelay:newDelay];
            }
            else {
                errorCode = 834003;
                errorDescription = [NSString stringWithFormat:
                                    @"Says macOS: Launched our URL handler (%ld times).  But still not running :(",
                                    (long)maxAllowedTrials];
            }
            
            if ((errorCode != 0) || (underlyingError != nil)) {
                errorDescription = [errorDescription stringByAppendingString:@"\n\n(The Sheep-Sys-UrlHandler is needed to land bookmarks directly from browsers.)"];
                NSError* error = SSYMakeError(errorCode, errorDescription);
                error = [error errorByAddingUnderlyingError:underlyingError];
                error = [error errorByAddingUserInfoObject:helperName
                                                    forKey:@"URL Handler Name"];
                error = [error errorByAddingUserInfoObject:path
                                                    forKey:@"URL Handler path"];
                error = [error errorByAddingUserInfoObject:[urlHandler description]
                                                    forKey:@"URL Handler running app description"];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    /* Actually, this error should be displayed for
                     BookMacster users too, but as of 2021-Feb-09, more users
                     (3 vs 1) have complained about Error 834003 than have
                     complained about landing bookmarks not working because the
                     URL Handler is not running.  This is, of course, because
                     >95% of BookMacster users do not land bookmarks directly.
                     So, for BookMacster, we log the error and move on.  The
                     errors will be in their logs if they complain to me about
                     bookmark landing not working. */
                    if ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppMarkster) {
                        [SSYAlert alertError:error];
                    }
                    [[BkmxBasis sharedBasis] logError:error
                                      markAsPresented:NO];
                });
            }
        });
    });
}

- (void)maybeTransformToUIElement {
    if (
        [[NSUserDefaults standardUserDefaults] boolForKey:constKeyLaunchInBackground]
        &&
        ![SSYEventInfo alternateKeyDown]) {
        [SSYProcessTyper transformToUIElement:nil] ;
    }
}

- (void)terminateShowingError:(NSError*)error {
    [SSYAlert alertError:error] ;
    [[NSApplication sharedApplication] terminate:self] ;
}

- (void)terminateSafelyShowingError:(NSError*)error {
    if ([[NSThread currentThread] isMainThread]) {
        [self terminateShowingError:error];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self terminateShowingError:error];
        });
    }
}

- (void)checkNoSiblingAppsRunningElseWarnAndQuit {
    NSError* error = nil ;
    BOOL ok = [[BkmxBasis sharedBasis] checkNoSiblingAppsRunningError_p:&error] ;
    if (!ok) {
        // We've done all the basic setup now.  Since this app is
        // expired, we don't want to do any more.
        [self terminateSafelyShowingError:error];
    }
}

- (void)ensureGoodLocation {
    NSString* path = [[NSBundle mainBundle] bundlePath];
    NSError* error = nil;
    BOOL ok = [[NSFileManager defaultManager] fileIsPermanentAtPath:path
                                                            error_p:&error];
    if (!ok) {
        NSString* msg = [NSString stringWithFormat:
                         NSLocalizedString(
                                           @"%@ appears to be installed in the following location:\n\n"
                                           @"%@\n\n"
                                           @"In this location, macOS may prevent some things from working properly.  Therefore, for your well-being, %@ will quit when you click 'OK'.",
                                           nil),
                         [[BkmxBasis sharedBasis] appNameLocalized],
                         path,
                         [[BkmxBasis sharedBasis] appNameLocalized]];
        error = [SSYMakeError(298460, msg) errorByAddingUnderlyingError:error];
        msg = [NSString stringWithFormat:
               NSLocalizedString(@"Easy…\n\n"
                                 @"     • 'OK' this message.\n"
                                 @"     • Drag the %@ .app package into your /Applications folder.\n"
                                 @"     • Double-click it to relaunch.\n\n"
                                 @"Note: It is OK to then drag %@ from /Applications into your Dock.  The macOS Dock is special – it will get an 'alias' to the real %@, which will remain in /Applications. ",
                                 nil),
               [[BkmxBasis sharedBasis] appNameLocalized],
               [[BkmxBasis sharedBasis] appNameLocalized],
               [[BkmxBasis sharedBasis] appNameLocalized]];
        error = [error errorByAddingLocalizedRecoverySuggestion:msg];
        [self terminateSafelyShowingError:error];
    }
}

- (void)ensureChromessengerSymlink {
    if ([[BkmxBasis sharedBasis] iAm] != BkmxWhich1AppSmarky) {
        // We do this each time the app launches, because in case the app
        // has been moved, the symlink needs to be updated.
        NSError* error = nil;
        BOOL ok = [Chromessengerer ensureSymlinkError_p:&error] ;
        if (!ok) {
            [SSYAlert performSelectorOnMainThread:@selector(alertError:)
                                       withObject:error
                                    waitUntilDone:NO];
        }
    }
}

- (void)killAnyLegacyLaunchdAgents {
    NSMutableSet* successes = [NSMutableSet new];
    NSMutableSet* failures = [NSMutableSet new];
    [SSYLaunchdGuy removeAgentsWithPrefix:[[NSBundle mainBundle] bundleIdentifier]
                               afterDelay:1.0
                                  timeout:15.0
                                successes:successes
                                 failures:failures];
    if (successes.count + failures.count > 0) {
        NSString* msg = [NSString stringWithFormat:
                         @"Removed %ld legacy launch jobs (failed %ld)",
                         successes.count,
                         failures.count];
        [[BkmxBasis sharedBasis] logFormat:msg];
    }
    [successes release];
    [failures release];
}

- (NSString*)childBundleIdentifierForName:(NSString*)name {
        NSString* string = [[NSBundle mainAppBundle] bundleIdentifier];
        // string = "com.sheepsystems.<someting>"
        string = [string stringByDeletingDotSuffix];
        // string = "com.sheepsystems"
        string = [string stringByAppendingDotSuffix:name] ;
        // string = "com.sheepsystems.<name>"

        return string;
}

- (void)killAnyOldieLoginItemsWithBasename:(NSString*)name {
    NSError* error = nil;

    NSString* searchString = [self childBundleIdentifierForName:name];
    NSSet* candidateInfos = [SSYOtherApper infosOfProcessesNamed:[NSSet setWithObject:searchString]
                                                            user:NSUserName()
                                                         error_p:&error];
    if (error) {
        error = [SSYMakeError(189357, @"Could not get running BkmxAgent processes") errorByAddingUnderlyingError:error];
        [[BkmxBasis sharedBasis] logError:error
                          markAsPresented:NO];
    }
    NSString* desiredBundleIdentifier = nil;
    if (candidateInfos.count > 0) {
        desiredBundleIdentifier = [[BkmxBasis sharedBasis] bundleIdentifierForLoginItemName:name
                                                                                inWhich1App:[[BkmxBasis sharedBasis] iAm]
                                                                                    error_p:&error];
        // desiredBundleIdentifier is, for example, com.sheepsystems.BkmxAgent-20180927-153817
    }

    NSMutableSet* killedOldies = [NSMutableSet new];
    if (desiredBundleIdentifier) {
        for (NSDictionary* info in candidateInfos) {
            NSString* candidateExecutableOrBundleID = [info objectForKey:SSYOtherApperKeyExecutable];

            /*
             As explained in the SSYOtherApper class documentation, the
             candidateExecutableOrBundleID is usually the path to a executable,
             such as:
             •   /Applications/BookMacster.app/Library/LoginItems/BkmxAgent.app/Contents/MacOS/BkmxAgent-20180927-153817
             but it may also be a bundle identifier such as
             •   com.sheepsystems.BkmxAgent-20180927-153817

             Taking advantage of the fact that our BkmxAgent's executable name
             is name is the same as its bundle identifier, and is unique to
             each build, we now handle each case: */
            NSString* candidateBundleIdentifier;
            if ([candidateExecutableOrBundleID rangeOfString:@"/"].location != NSNotFound) {
                // candidateExecutableOrBundleID must be a path
                NSString* candidateLastDot = [candidateExecutableOrBundleID lastPathComponent];
                // candidateLastDot is, for example: BkmxAgent-20180927-123456
                candidateBundleIdentifier = [desiredBundleIdentifier stringByDeletingDotSuffix];
                // candidateBundleIdentifier is, for example: com.sheepsystems
                candidateBundleIdentifier = [candidateBundleIdentifier stringByAppendingDotSuffix:candidateLastDot];
                // candidateBundleIdentifier is, for example: BkmxAgent-20180927-123456
            } else {
                // candidateExecutableOrBundleID must be a bundle ID
                candidateBundleIdentifier = candidateExecutableOrBundleID;
            }

            if (![desiredBundleIdentifier isEqualToString:candidateBundleIdentifier]) {
                /* candidateBundleIdentifier represents a BkmxAgent XPC Service
                 which is probably from a previous version of this app.
                 Kill it. */
                /* For concise logging when this method returns to the caller,
                 we remove the "com.sheepsystems" prefix. */
                NSString* oldie = [desiredBundleIdentifier pathExtension];
                // oldie is, for example: BkmxAgent-20180927-153817
                [killedOldies addObject:oldie];

                pid_t candidatePid = ((NSNumber*)[info objectForKey:SSYOtherApperKeyPid]).intValue;

                [SSYOtherApper killThisUsersProcessWithPid:candidatePid
                                                       sig:SIGTERM
                                                   timeout:10.0];
                /* The above method always returns YES, even when you send
                 a SIGKILL and launchd relaunches the process immediately.

                 Why SIGTERM?

                 Somehow, I got an earlier version of BkmxAgent stuck in my
                 system.  Its service would always launch when I log back in or
                 restart.  I tried passing sig = 1, 2, 3, ... 15.  The first
                 14 did not work because the system would immediately restart
                 the service with a new process as soon as I killed it.  But,
                 miraculously, sig = 15 (=SIGTERM) worked.   */

            }
        }

        NSString* what = @"oldie agent";
        if (killedOldies.count > 1) {
            NSString* oldiesList = [[killedOldies allObjects] listValuesForKey:nil
                                                                   conjunction:nil
                                                                    truncateTo:0];
            what = [what stringByAppendingString:@"s"];
            NSString* msg = [NSString stringWithFormat:
                             @"Killed %@: %@",
                             what,
                             oldiesList];
            [[BkmxBasis sharedBasis] logFormat:msg];
        }
    }
    [killedOldies release];
}

- (void)showUnpresentedErrors {
	if ([[BkmxBasis sharedBasis] hasUnpresentedErrors]) {
		[self displayErrorLogs] ;
	}
}

- (void)applicationDidBecomeActive:(NSNotification *)aNotification {
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:constKeyLaunchQuietlyNextTime] ;
}

- (void)showWelcomeOrShoeboxOrNothingDelayed {
    /* We do the following with a delay because, if a document is opened by
     state restoration during relaunch after app has been abruptly terminated
     or crashed, that always happens last, long after this point.  So, in that
     case, at this point, the document controller's `documents` will still
     be nil/empty.

     This delay is not needed when app is launched by the AppleScript
    'open document' command, nor by doubleclicking a document in Finder,
     nor by previous setting of "Automatically open this document when
     BookMacster launches. */
    [self performSelector:@selector(showWelcomeOrShoeboxOrNothing)
               withObject:nil
               afterDelay:0.0] ;
}

- (void)openDocsSetToOpenAfterLaunch {
    NSArray* uuids = [[NSUserDefaults standardUserDefaults] docUuidsToOpenAfterLaunch] ;
    NSInteger countOfUuids = [uuids count] ;
    NSInteger __block i = 0 ;
    NSMutableString* __block displayUuidList = nil ;
    /* In the following && condition, the first test ensures that we are not
     going to open a document because it has the checkbox "Automatically open
     this document when Bkmx launches" checkbox on, but we have not done that
     yet.   The second test ensures that the document controller is not about
     to open a document which has been doubleclicked in Finder or clicked in
     Dock (some users put documents in their Dock).  We only jump to show
     the welcome, etc. if both conditions are true. */
    if ((uuids.count == 0) && !([(BkmxDocumentController*)[NSDocumentController sharedDocumentController] haveADoc])) {
        [self showWelcomeOrShoeboxOrNothingDelayed] ;
    }
    else {
        for (NSString* uuid in uuids) {
            [[BkmxDocumentController sharedDocumentController] openDocumentWithUuid:uuid
                                                                            appName:[[BkmxBasis sharedBasis] appNameUnlocalized]
                                                                            display:YES
                                                                     aliaserTimeout:19.178
                                                                  completionHandler:^(BkmxDoc* bkmxDoc,
                                                                                      NSURL* resolvedUrl,
                                                                                      BOOL documentWasAlreadyOpen,
                                                                                      NSError* error) {
                                                                      if (!displayUuidList) {
                                                                          displayUuidList = [[NSMutableString alloc] init] ;
                                                                      }
                                                                      if (displayUuidList.length > 0) {
                                                                          [displayUuidList appendString:@", "] ;
                                                                      }
                                                                      [displayUuidList appendString:[uuid substringToIndex:4]] ;
                                                                      if (!bkmxDoc) {
                                                                          [displayUuidList appendString:@"(FAIL)"] ;
                                                                          [SSYAlert alertError:error] ;
                                                                      }

                                                                      i++ ;
                                                                      if (i == countOfUuids) {
                                                                          [self showWelcomeOrShoeboxOrNothingDelayed] ;
                                                                          [[BkmxBasis sharedBasis] logFormat:[NSString stringWithFormat:
                                                                                                               @"Launch open %ld: %@",
                                                                                                               countOfUuids,
                                                                                                               displayUuidList]] ;
                                                                          [displayUuidList release] ;
                                                                      }
                                                                  }] ;
        }
    }
}

- (void)openPreferredDocsOrShoeboxOrWelcome {
    if ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppBookMacster) {
        if (![SSYEventInfo alternateKeyDown]) {
            /* Open any documents set for auto-opening in user defaults.
             Testing in macOS 10.13.3 Beta 2 (17D25b), 20171228, BkmkMgrs 2.5,
             I found that the following must be delayed; otherwise when
             -[BkmxDocumentController openDocumentWithContentsOfURL:display:completionHandler:]
             invokes super (which is NSDocument), super will return nil
             document to the completion handler, which will cause this app
             to silently remove it from recent documents and also from user
             defaults' array doOpenAfterLaunchUuids, which is *very* annoying
             because the only way the user could open it after that is with
             File > Open.

             Testing in the same hour, this did not happen when opening an old
             .bkmslf document with BkmkMgrs 2.4.12.  So the problem is caused
             by BSManagedDocument or the way documents are opened.  (Is
             there such a thing as asynchronous document opening and is that
             absent in the old .bkmslf regime?)

             Anyhow, I found that wrapping the following in a delay:0.0 call
             fixed the problem.  Here it is… */
            [self performSelector:@selector(openDocsSetToOpenAfterLaunch)
                       withObject:nil
                       afterDelay:0.0];
        }
        else {
            [self showWelcomeOrShoeboxOrNothingDelayed] ;
        }
    }
    else {
        [self showWelcomeOrShoeboxOrNothingDelayed] ;
    }
}

- (NSString *)helpAnchorForNewbie {
    NSString* helpAnchor = nil ;
    switch ([[BkmxBasis sharedBasis] iAm]) {
        case BkmxWhich1AppSmarky:
            helpAnchor = constHelpAnchorStartSmarky ;
            break ;
        case BkmxWhich1AppSynkmark:
            helpAnchor = constHelpAnchorStartSynkmark ;
            break ;
        case BkmxWhich1AppMarkster:
            helpAnchor = constHelpAnchorStartMarkster ;
            break ;
        default:
            break ;
    }
    
    return helpAnchor ;
}

- (void)showNewUserHelpOrElseLaunchDocsOrWelcomeAndAnyErrors {
    BOOL isNewUser = [SSYAppInfo isNewUser] ;
    if (isNewUser) {
        NSString *helpAnchor;
        helpAnchor = [self helpAnchorForNewbie] ;
        
        if (helpAnchor) {
            // This is a shoebox app
            [self openPreferredDocsOrShoeboxOrWelcome];
            [self performSelector:@selector(openHelpAnchor:)
                       withObject:helpAnchor
                       afterDelay:3.0] ;
        }
        else {
            // This is BookMacster
            [NewUserSetupWinCon showWindow] ;
        }
	}
	else {
		/*
		 The following condition was changed in BookMacster 1.11.
		 Prior to that, it was if(![NSScriptCommand currentCommand]) which
		 did not work, because that stupid thing is hardly ever non-nil.
		 
		 What I'd like to do is to *not* do any of the stuff in this 
		 method if we were launched by AppleScript.  But after trying
		 for a couple hours, I gave up looking for a way to determine
		 if we were launched by AppleScript.  Others gave up too…
		 http://www.cocoabuilder.com/archive/cocoa/191642-determine-if-app-is-launched-thru-alias.html
		 (2007-10-29 cocoa-dev@lists.apple.com)
		 I think the problem is that Cocoa has no concept of being
		 "launched by AppleScript", because whether triggered by
		 AppleScript or by user double-clicking, in either case an
		 app is launched in the same way, by launchd.
		 
		 As a workaround, I now set the boolean key constKeyLaunchQuietlyNextTime
		 in User Defaults whenever BkmxNotifier-A is getting ready to launch
		 or activate the Main App.  I'd like to remove that key in this method,
		 but that would miss cases where the Main App is already running.
		 Luckily, this method runs *before* -applicationDidBecomeActive:, so I
		 remove that key in there.
		 */
		 if (![[NSUserDefaults standardUserDefaults] boolForKey:constKeyLaunchQuietlyNextTime]) {
             [self openPreferredDocsOrShoeboxOrWelcome];
			
             // Delay this in case we receive the AppleScript command to 'display error logs'.
             // That command should execute first, showing all the errors.  Then showUnpresentedErrors
             // will find the unviewed errors queue to be empty and, as desired, not even display.
             [self performSelector:@selector(showUnpresentedErrors)
                        withObject:nil
                        afterDelay:0.0] ;			
		}
	}
}

- (void)showInspectorWithOomph {
    // Warning: Deleting or reordering of any of these statements may break something,
    [NSApp activateIgnoringOtherApps:YES] ;
    
    [self doShowInspector:YES] ;
    
    NSWindow* inspectorWindow = [[self inspectorController] window] ;
    
    // To make the window float in front of the browser app
    [inspectorWindow setLevel:NSFloatingWindowLevel] ;
    
    [inspectorWindow display] ;
    [[self inspectorController] showWindow:self] ;

    // To make sure that keyboard focus is on the Name field
    [[self inspectorController] setFirstResponderToNameField] ;
}

- (void)doShowInspector:(BOOL)desiredState {
    BOOL currentState = [self inspectorShowing] ;
    if (currentState != desiredState) {
        @synchronized(self) {
            if (desiredState) {
                [[self inspectorController] showWindow:self] ;
            }
            else {
                [[self inspectorController] closeWindow] ;
                
                // Added in BookMacster 1.8, in case it was shown by -landNewBookmarkWithInfo:,
                // which setHidesOnDeactivate:NO
                [[self inspectorController] setHidesOnDeactivate] ;
                
                for (BkmxDoc* doc in [[NSDocumentController sharedDocumentController] documents]) {
                    if ([doc respondsToSelector:@selector(firePostLandingTimer)]) {
                        [doc firePostLandingTimer] ;
                    }
                }
            }
        }
        [[NSUserDefaults standardUserDefaults] setBool:desiredState
                                                forKey:constKeyInspectorWasShowing] ;
    }
    
    // In BkmxMgrs 1.22.23, I gave up on trying to use Cocoa Bindings for this:
    for (NSDocument* document in [[NSDocumentController sharedDocumentController] documents]) {
        if ([document respondsToSelector:@selector(bkmxDocWinCon)]) {
            BkmxDocWinCon* bkmxDocWinCon = [(BkmxDoc*)document bkmxDocWinCon] ;
            [bkmxDocWinCon setInspectorButtonState:desiredState] ;
        }
    }
}

// Prior to BookMacster 1.19.9, the export was just done immediately.
// This method is new.
- (void)considerPostLandingExportForDocumentIndex:(NSNumber*)documentIndex {
    BkmxDoc* bkmxDoc = [[[NSDocumentController sharedDocumentController] documents] objectAtIndex:[documentIndex integerValue]] ;
    if (!bkmxDoc) {
        return ;
    }
    
    /*
     See if the document has any Agent which is triggered by BkmxTriggerLanding,
     and if so, create an invocation to perform it
     */
    // See  Note NoteBkmxLandingTrigger.
    NSInvocation* invocation = nil ;
    for (Syncer* syncer in [[bkmxDoc macster] syncers]) {
        for (Trigger* trigger in [syncer triggers]) {
            if ([trigger triggerTypeValue] == BkmxTriggerLanding) {
                BkmxDeference deference = BkmxDeferenceAsk ; // Doesn't matter since we're not importing or exporting
                BOOL ignoreLimit = YES ; // Ditto
                Job* job = [Job new];
                job.serial = [[NSUserDefaults standardUserDefaults] nextJobSerialforCreator:@"New Bookmark Landing"];
                job.syncerUri = syncer.objectID.URIRepresentation.absoluteString;
                job.syncerIndex = syncer.index.integerValue;
                job.triggerUri = trigger.objectID.URIRepresentation.absoluteString;
                job.triggerIndex = trigger.index.integerValue;
                job.docUuid = [bkmxDoc uuid];
                job.appName = [[BkmxBasis sharedBasis] appNameUnlocalized];
                BkmxPerformanceType performanceType = BkmxPerformanceTypeUser;
                invocation = [NSInvocation invocationWithTarget:[AgentPerformer sharedPerformer]
                                                       selector:@selector(performOverrideDeference:ignoreLimit:job:performanceType:errorAlertee:)
                                                retainArguments:YES
                                              argumentAddresses:&deference, &ignoreLimit, &job, &performanceType, &bkmxDoc];
                [job release];
                break ;
            }
            if (invocation) {
                break ;
            }
        }
    }
    
    if (!invocation) {
        return ;
    }
    
    // Note that it's now 2 seconds after the new bookmark has landed.
    if (![self inspectorShowing]) {
        // Perform the syncer immediately
        [invocation invoke] ;
    }
    else {
        // Give the user some time to work in the Inspector.
        // Agent will be performed when the Inspector window is closed, or
        // after INSPECTION_TIMEOUT, whichever comes first.
        NSTimer* timer = [NSTimer timerWithTimeInterval:IDLE_EDITING_TIMEOUT
                                             invocation:invocation
                                                repeats:NO] ;
        [[NSRunLoop currentRunLoop] addTimer:timer
                                     forMode:NSDefaultRunLoopMode] ;
        [bkmxDoc setPostLandingTimer:timer] ;
    }
}

- (void)landNewBookmarkWithInfo:(NSDictionary*)browmarkInfo {
	Stark* parent = [browmarkInfo objectForKey:constKeyParent] ;
	BkmxDoc* bkmxDoc = nil ;
	if (parent) {
		/* We must have been invoked by an "Add to" or "Add Here" item in
        Doxtus Menu.  Target document is already open. */
		bkmxDoc = (BkmxDoc*)[parent owner] ;
        [self landNewBookmarkWithInfo:browmarkInfo
                          intoBkmxDoc:bkmxDoc];
	}
	else {
		/* We must have been invoked by the BookMacsterize Bookmarklet,
         or our BookMacster Button browser extension, or AppleScript. */
		NSArray* documents = [[NSDocumentController sharedDocumentController] documents] ;
		NSInteger nDocuments = [documents count] ;
		if (nDocuments <= 1) {
			if (nDocuments < 1) {
				[self chooseRecentDocumentWithMode:SSYAlertModeModalDialog
                                 completionHandler:^void(NSDocument* bkmxDoc){
                                     [self landNewBookmarkWithInfo:browmarkInfo
                                                       intoBkmxDoc:(BkmxDoc*)bkmxDoc];
                                 }] ;
			}
			bkmxDoc = [documents firstObjectSafely] ;
            [self landNewBookmarkWithInfo:browmarkInfo
                              intoBkmxDoc:bkmxDoc];
		}
		else {
			SSYAlert* alert = [SSYAlert alert] ;
			NSString* label = [[NSString localizeFormat:
							   @"addWhatToX1",
							   [[BkmxBasis sharedBasis] labelLeaf]] colonize] ;
			SSYLabelledList* list = [SSYLabelledList listWithLabel:label
														   choices:[documents valueForKey:@"displayName"]
                                           allowsMultipleSelection:NO
                                              allowsEmptySelection:YES
														  toolTips:nil
													 lineBreakMode:NSLineBreakByTruncatingMiddle
													maxTableHeight:500.0] ;
			[alert addOtherSubview:list
						   atIndex:0] ;
			[alert runModalDialog] ;
			
			NSInteger selectedIndex = [[list selectedIndexes] firstIndex] ;
			if (selectedIndex == NSNotFound) {
				NSBeep() ;
				return ;
			}
			
			bkmxDoc = [documents objectAtIndex:selectedIndex] ;
            [self landNewBookmarkWithInfo:browmarkInfo
                              intoBkmxDoc:bkmxDoc];
		}
	}
}

- (void)landNewBookmarkWithInfo:(NSDictionary*)browmarkInfo
                    intoBkmxDoc:(BkmxDoc*)bkmxDoc {
	// The following condition was added in BookMacster 1.8.  The effect
	// is that, if the BkmxDoc window is minimized to the dock during
	// landing of a new bookmark, it will stay minimized to the dock.
	// To fix the original problem of the Inspector not showing the new
	// bookmark, we now do that later, see Note 529128 below.
	if ([(NSApplication*)NSApp isActive]) {
		// We want the new bookmark to be the app-wide selectedStark so that
		// it will show in the Inspector after insertion.  One of the requirements
		// for that is that its BkmxDoc be the front one.  But even if we don't
		// show Inspector, or even show windows, it still seems appropriate to 
		// move the BkmxDoc with a newly-landed bookmark to the front. 
		BkmxDocWinCon* bkmxDocWinCon = [bkmxDoc bkmxDocWinCon] ;
		[[bkmxDocWinCon window] orderFront:self] ;
	}

	BOOL showInspector ;
	// The following qualification was added in BookMacster 1.12.6 ;
    if ([[browmarkInfo objectForKey:constKeyShowInspectorOverride] boolValue] == YES) {
        // Event is from either of our two menu items in Firefox.  If inspector
        // should be shown ("Add & Inspect"), it will happen as the result of
        // a subsequent, separate "display inspector" AppleScript command.
       showInspector = NO ;
    }
    else {
        NSString* showInspectorInput = [browmarkInfo objectForKey:@"showInspector"] ;
        if (showInspectorInput) {
            // Event is from either the "Add Quickly" or "Add & Inspect"
            // global keyboard shortcut.
            // These two commands correspond to showInspector = NO and YES.
            showInspector = [showInspectorInput integerValue] > 0 ;
        }
        else {
            // Event is from the BookMacsterize bookmarklet, or Chrome button.
            // User's intention to showInspector or not is given by the state
            // of the option/alt key, according to this:
            //   altKeyDown  altKeyToInspectLander   !altKeyToInspectLander   xor   inspect
            //       0                0                        1               1       1
            //       0                1                        0               0       0
            //       1                0                        1               0       0
            //       1                1                        0               1       1
            showInspector = xorr([SSYEventInfo alternateKeyDown], ![[NSUserDefaults standardUserDefaults] boolForKey:constKeyAltKeyInspectsLander]) ;
        }
    }
    
	if (bkmxDoc) {
		// The following was added in BookMacster version 1.3.19, to fix a bug which
		// was that the new bookmark could not be selected and thus would not show
		// in the Inspector if it did not happen to satisfy the filter criteria.
		// The condition was added in BookMacster 1.5, when I noticed that
		// this was causing a switch from outline mode to flat mode.
		BkmxDocWinCon* bkmxDocWinCon = [bkmxDoc bkmxDocWinCon] ;
		if (![bkmxDocWinCon outlineMode]) {
			[bkmxDocWinCon clearQuickSearch] ;
		}
		
		// Added in BookMacster 1.7.3 after I realized that users with Usage
		// Style 3 may otherwise never need to license, due to Lion's Auto Save
		BOOL licensedOk = YES ;
		if (NSAppKitVersionNumber >= 1100) {
			if (![[BkmxBasis sharedBasis] isBkmxAgent]) {  // Probably this test is defensive programming
				if (SSYLCCurrentLevel() < SSYLicenseLevelValid) {
					// Try to make a sale
					[SSYLicenseBuyController showWindow] ;
					licensedOk = NO ;
				}
			}
		}		

		Stark* newBookmark = nil ;
		if (licensedOk) {
			newBookmark = [bkmxDoc landNewBookmarkSaveWithInfo:browmarkInfo] ;
			// Added in BookMacster 1.8 (This is Note 529128)
			[self setSelectedStark:newBookmark] ;
		}
		
		if (newBookmark) {
            [bkmxDoc setLastLandedBookmark:newBookmark] ;

			// The following lines, added in BookMacster 1.7.1/1.6.8, do 2 things,
			// relevant if the tab view is not already set to Content…
			// • It is probably what the user wants, to see their new
			//   bookmark in their Content View, even if they last looked at a
			//   different tab.
			// • It activates the 'selectedStark' KVO chain, so that the Inspector,
			//   if shown, will show the new item instead of being empty
			[bkmxDoc revealTabViewIdentifier:constIdentifierTabViewContent] ;
            // Prior to BookMacster 1.14.4, I did this…
			// [[[bkmxDoc bkmxDocWinCon] contentOutlineView] selectObjects:[NSArray arrayWithObject:newBookmark]
			// 									 byExtendingSelection:NO] ;
            // but that did not scroll row to visible.  So I changed to this…
            [[[bkmxDoc bkmxDocWinCon] contentOutlineView] showStarks:[NSArray arrayWithObject:newBookmark]
                                                          selectThem:YES
                                                      expandAsNeeded:YES] ;
			if (showInspector) {
                // Delay added in BkmkMgrs 1.22.19
                [self performSelector:@selector(showInspectorWithOomph)
                           withObject:nil
                           afterDelay:0.0] ;
				[[self inspectorController] prepareSaveUponCloseBkmxDoc:bkmxDoc] ;
            }
		}
        
        // To avoid a crash in case bkmxDoc closes within the next 2 seconds,
        // I pass its index to the delayed performer.  In the rare event
        // that someone is able to close that document and open a new one
        // in 2 seconds, well, we might export, or not, unexpectedly.
        NSNumber* documentIndex = [NSNumber numberWithInteger:[[[NSDocumentController sharedDocumentController] documents] indexOfObject:bkmxDoc]] ;
#define WAIT_TO_SEE_IF_INSPECTOR_IS_SHOWN 2.0
        [self performSelector:@selector(considerPostLandingExportForDocumentIndex:)
                   withObject:documentIndex
                   afterDelay:WAIT_TO_SEE_IF_INSPECTOR_IS_SHOWN] ;
    }
}

- (void)landNewBookmarkAndInspect:(BOOL)inspect {
	NSDictionary* info = [[(BkmxAppDel*)[NSApp delegate] doxtusMenu] grabActivePage];
	info = [info dictionaryBySettingValue:[NSNumber numberWithBool:(BOOL)inspect]
								   forKey:@"showInspector"] ;
	[(BkmxAppDel*)[NSApp delegate] landNewBookmarkWithInfo:info] ;
}

- (void)landNewBookmarkQuickly {
	[self landNewBookmarkAndInspect:NO] ;
}

- (void)landNewBookmarkAndInspect {
	[self landNewBookmarkAndInspect:YES] ;
}

- (void)landNewBookmarkFromMenuItem:(NSMenuItem*)menuItem {
    NSDictionary* browmarkInfo = [menuItem representedObject] ;
	[self landNewBookmarkWithInfo:browmarkInfo] ;
}

- (void)visitAllOfRepresentative:(NSObject <SSYRepresentative> *)menuItem {
    Stark* stark = [menuItem representedObject] ;
    NSArray* items ;
    
    /* On 20130506, I received a console log from a user indicating that an
     exception happened here…
     
     May  3 15:12:21 mac0001.local BookMacster[45181]: -[_NSStateMarker canHaveChildren]: unrecognized selector sent to instance 0x10041b360
     May  3 15:12:21 --- last message repeated 1 time ---
     May  3 15:12:21 mac0001.local BookMacster[45181]: (
     0   CoreFoundation                      0x00007fff880c9b06 __exceptionPreprocess + 198
     1   libobjc.A.dylib                     0x00007fff877c33f0 objc_exception_throw + 43
     2   CoreFoundation                      0x00007fff8816040a -[NSObject(NSObject) doesNotRecognizeSelector:] + 186
     3   CoreFoundation                      0x00007fff880b802e ___forwarding___ + 414
     4   CoreFoundation                      0x00007fff880b7e18 _CF_forwarding_prep_0 + 232
     5   Bkmxwork                            0x000000010001a0ff -[BkmxAppDel visitAllOfRepresentative:] line WAS-2242 below
     6   AppKit                              0x00007fff8a2d0989 -[NSApplication sendAction:to:from:] + 342
     7   AppKit                              0x00007fff8a2d07e7 -[NSControl sendAction:to:] + 85
     8   AppKit                              0x00007fff8a6d3b14 -[NSTableView _sendAction:to:row:column:] + 90
     9   AppKit                              0x00007fff8a6c574d -[NSTableHeaderView mouseDown:] + 633
     10  Bkmxwork                            0x00000001000f1b6a -[SSYTableHeaderView mouseDown:], last line which invokes super
     11  AppKit                              0x00007fff8a2fde47 forwardMethod + 125
     12  AppKit                              0x00007fff8a2fde47 forwardMethod + 125
     13  AppKit                              0x00007fff8a2c553e -[NSWindow sendEvent:] + 6853
     14  Bkmxwork                            0x00000001000a50e4 -[SSYHintableWindow sendEvent:]
     15  AppKit                              0x00007fff8a2c1674 -[NSApplication sendEvent:] + 5761
     16  AppKit                              0x00007fff8a1d724a -[NSApplication run] + 636
     17  AppKit                              0x00007fff8a17bc06 NSApplicationMain + 869
     18  BookMacster                         0x0000000100001ae8 BookMacster + 6888
     19  BookMacster                         0x00000001000019f4 BookMacster + 6644
     
     So, apparently 'stark' was an _NSStateMarker object.  I could not reproduce
     that by clicking or doubleclicking on a column header in the content 
     outine, but whatever this is easy to fix.  Added in BookMacster 1.15… */
    if (![stark respondsToSelector:@selector(canHaveChildren)]) {
        NSBeep() ;
        return ;
    }
    
    if ([stark canHaveChildren]) {  // Line WAS-2242.  See above.
        // This branch wil execute if the user either double=clicks a folder
        // in the content outline, or else clicks one of the "Visit all <n>
        // Bookmarks" items in one of the hierarchical menus.
        items = [stark childrenOrdered] ;
    }
    else {
        // This branch added in BookMacster 1.14.4.  This branch will execute
        // when the user double-clicks a bookmark, not a folder, in the
        // Content Outline.
        items = [NSArray arrayWithObject:stark] ;
    }
    [StarkEditor visitItems:items
             urlTemporality:BkmxUrlTemporalityCurrent] ;
}

#if MAC_OS_X_VERSION_MIN_REQUIRED > 1050
- (void)popUpAnywhereMenu {
	[[self doxtusMenu] popUpAnywhereMenu] ;
}
#endif

/*!
 @details  Invoked by "Show BookMacster" in Doxtus menu, when we are
 *not* an LSUIElement.
*/
- (IBAction)activate:(id)sender {
	[NSApp activateIgnoringOtherApps:YES] ;
}

- (IBAction)background:(id)sender {
    // The following was added in BookMacster 1.18
    NSMutableArray* documentUrlsToReopen = [[NSMutableArray alloc] init] ;
    for (NSDocument* document in [[NSDocumentController sharedDocumentController] documents]) {
        [documentUrlsToReopen addObject:[document fileURL]] ;
    }
    
    /* The following was added in BookMacster 1.16.1.  Otherwise,
     after adding a bookmark while in this background mode, the
     document window will become visible again.  Checking respondsToSelector:
     was added in BookMacster 1.19.6
     
     Omission of the NSStatusWindowLevel window, which is in fact the status
     menu item itself, was added in BookMacster 1.19.7, to fix bug that, well,
     obviously, the status item disappears.  How was this not caught for so
     long?  User 'spaceman' said it started in 1.19.6, but that does not make
     sense.
     */
    [self setIsBackgrounding:YES] ;
    for (NSWindow* window in [NSApp windows]) {
        if ([window level] != NSStatusWindowLevel) {
            if ([[window delegate] respondsToSelector:@selector(windowShouldClose:)]) {
                if ([[window delegate] windowShouldClose:window]) {
                    BkmxDoc* bkmxDoc = [[window windowController] document] ;
                    if ([bkmxDoc respondsToSelector:@selector(managedObjectContext)]) {
                        NSError* error = nil ;
                        [[bkmxDoc managedObjectContext] save:&error] ;
                        if (error) {
                            NSLog(@"Internal Error 624-9585 %@ saving %@", error, bkmxDoc) ;
                        }
                    }
                    [window close] ;
                }
            }
            else {
                // This is expected for the Preferences
                [window close] ;
            }
        }
        else {
            // This is expected for the Status Item (NSStatusBarWindow)
        }
    }
    [self setIsBackgrounding:NO] ;
    
    /* By the way, for debugging, here are the values of Cocoa's window levels.
     0 = NSNormalWindowLevel  (Document window, SSYHintableWindow; Drawer window, NSDrawerWindow; Inspector, NSPanel)
     3 = NSFloatingWindowLevel
     3 = NSSubmenuWindowLevel
     3 = NSTornOffMenuWindowLevel
     24 = NSMainMenuWindowLevel
     25 = NSStatusWindowLevel  (Status Item (Menu Extra), NSStatusBarWindow)
     20 = NSDockWindowLevel
     8 = NSModalPanelWindowLevel
     101 = NSPopUpMenuWindowLevel
     103 =        (Any tool tips hanging around, NSToolTipPanel)
     1000 = NSScreenSaverWindowLevel */
    
	[SSYProcessTyper transformToUIElement:self] ;

    for (NSURL* url in documentUrlsToReopen) {
        [[BkmxDocumentController sharedDocumentController] openDocumentUrl:url
                                                                   display:NO
                                                         completionHandler:NULL] ;
    }
    
    [documentUrlsToReopen release] ;
}

/*!
 @brief    Delegate method

 @details  Instead o returning NSTerminateCancel, this method *should* return
 NSTerminateLater and the documeent closing methods should later invoke
 -replyToApplicationShouldTerminate:.  Howver, you see in
 -[BkmxDoc prepareToClose] that there are three conditions which can cause
 termination to be delayed, so it would take me several hours of thinking
 through and considering possible edge case bugs.  Delaying operations while
 you insert and perform other operations can be really tricky.

 It now works this way:  Upon File > Quit, if a document is in a state that may
 prevent termination, the user has the option of performing the action or not,
 but in either case the document window is closed.  So the *next* time the user
 commands File > Quit, the app quits immediately.  I realize this requires an
 extra click from the user, but it is obvious to do this when they see that the
 app is still running.  Someday, if I have nothing to do, I might work on
 adding NSTerminateLater and -replyToApplicationShouldTerminate:.
 */
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    NSArray* documents = [[NSDocumentController sharedDocumentController] documents] ;
    NSApplicationTerminateReply shouldTerminate = NSTerminateNow ;
    for (BkmxDoc* bkmxDoc in documents) {
        if ([bkmxDoc respondsToSelector:@selector(bkmxDocWinCon)]) {
            BkmxDocWinCon* winCon = [bkmxDoc bkmxDocWinCon] ;
            /* (If app is running in Background mode, winCon is nil) */
            if (winCon) {
                if (![winCon windowShouldClose:self]) {
                    shouldTerminate = NSTerminateCancel;
                    break ;
                }
            }
        }
    }

	return shouldTerminate ;
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    [[self inspectorController] endEditing];
    [self setIsTerminating:YES] ;
    [[NSNotificationCenter defaultCenter] removeObserver:[BkmxBasis sharedBasis]] ;
    [[NSNotificationCenter defaultCenter] removeObserver:(BkmxAppDel*)[NSApp delegate]] ;
    [[SSYLazyNotificationCenter defaultCenter] removeObserver:self] ;
}

- (void)showStark:(Stark*)stark
         selectIt:(BOOL)selectIt
	bringToFront:(BOOL)bringToFront {
	BkmxDocWinCon* bkmxDocWinCon = [(BkmxDoc*)[stark owner] bkmxDocWinCon] ;
    [bkmxDocWinCon showStark:stark
                    selectIt:selectIt] ;
	if (bringToFront) {
		[bkmxDocWinCon showWindow:self] ;
	}
}

//- (void)updateSearchResultsLockScroll:(BOOL)lockScroll {
//	[[self searchController] searchAndUpdateResultsLockScroll:lockScroll] ;
//}

- (void)updateSelectedStarkFromWindowNote:(NSNotification*)note {
	id stark = nil ;  // May be either a Stark or NoStark
		
    BkmxDoc* currentBkmxDoc = [[NSDocumentController sharedDocumentController] frontmostDocument] ;
    // Needed for observing by inspector controller
    [self setCurrentBkmxDoc:currentBkmxDoc] ;
    BkmxDocWinCon* windowController = [currentBkmxDoc bkmxDocWinCon] ;

    // This is needed for the inspector controller, which observes our
    // selectedStarki property
    Starki* starki = [[[(BkmxDocWinCon*)windowController cntntViewController] contentOutlineView] selectedStarki] ;
    [self setSelectedStarki:starki] ;
    /* Prior to the fix in BookMacster 2.12.6, crashes would occur here
     with note=BkmxWinsDidRearrange, esactly the same as occurs
     for note=BkmxSelectionDidChange, see below Note CocoaBindingsIsBad. */

	stark = [(BkmxDocWinCon*)windowController selectedStark] ;
	BOOL ok = YES ;
	// Note that stark may be an _NSStateMarker
	// Starting in BookMacster version 1.3.12, we replace
	// those with an object that can give the appropriate
	// answer for -lineageStatus in particular.
	if (![stark isKindOfClass:[Stark class]]) {
        /* This 'stark', the newly-selected stark in the front document,
         is either nil or a NoStark or an _NSStateMarker of some kind.
         In this case, we want to keep the currently selected stark if
         it is still available.  This reason for this is the following
         scenario:
         • Minimize Collection window to the dock
         • Activate a cooperating web browser
         • Add & Inspect
         • In the Inspector, Move the new bookmark
         Without the following code, the Inspector will go show no stark
         at this point.  This is because the outline's selection goes
         to nil.  I'm not sure why, because, if the Collection
         window is *not* minimized to the Dock, the selected stark
         is still selected after moving it.  Maybe a non-visible outline
         view is not allowed to have a selection or something.
         Anyhow, here's the fix…  */
		Stark* currentStark = [self selectedStark] ;
		if ([currentStark isKindOfClass:[Stark class]]) {
			if ([currentStark isAvailable]) {
				// Do not change the currently selectedStark
				ok = NO ;
                /* Whoops, crash EXC_BAD_ACCESS on the above line running in
                 macOS 11.3 Beta 8 Xcode 12.  Here is, I think, what I did:
                 Import from Safari
                 Click tab "Settings" (by mistake)
                 Click tab "Reports" when "Sync Log" is the active sub-tab.
                 Worked with no crash on second try :(  */
			}
		}
		
		// Since the newly-selected stark nor the currently selectedStark
		// are any good.  So,
		stark = [NoStark noStark] ;
	}

	if (ok) {
        [self setSelectedStark:stark] ;
        /*  Note CocoaBindingsIsBad
         
         Prior to the fix in BookMacster 2.12.6, crashes would occur often here
         with note=BkmxSelectionDidChange when script testSaf
         (bash alias for BkmkMgrs/BookMacsterTests/Cases/Safari/run.sh)
         while closing the third .bmco doe in the test (Safari-3), if the
         Inspector was showing during the current app run.  Now, they occur
         less often but I still saw one of 2022-04-29.  (The inspector
         will show after opening a document in the current app run if it was
         showing during quit of the previous app run.)  Here is a typical
         crash stack of the earlier crash:
         
         #0 0x000000018f7b7afc in object_getClass ()
         #1 0x00000001908ad1cc in _NSKeyValueObservationInfoGetObservances ()
         #2 0x000000019089cd64 in -[NSObject(NSKeyValueObservingPrivate) _changeValueForKeys:count:maybeOldValuesDict:maybeNewValuesDict:usingBlock:] ()
         #3 0x00000001908caa60 in -[NSObject(NSKeyValueObservingPrivate) _changeValueForKey:key:key:usingBlock:] ()
         #4 0x00000001908e7e40 in _NSSetObjectValueAndNotify ()
         #5 0x000000010168c444 in -[BkmxAppDel updateSelectedStarkFromWindowNote:] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/BkmxAppDel.m:3805
         
         where the last line is the call to [self setSelectedStark:] (above)
         or [self setSelectedStarki] (further above).
         
         These crashes occurred due to the binding to  App.delegate.selectedStark
         and App.delegate.selectedStarki in  Inspector.xib.  I tried to bind
         these through one object controller, two object controllers, or
         zero object controllers (outlets in consuming views bound to
         AppDelegate with key path selectedStark(i).whatever), and it always
         crashes, even when nothing is bound to the object controller,
         that is, if the object controller is a dead end..  My conclusion is
         that this is a bug in Cocoa Bindings.
         
         * * * *
         
         Well, but that did not totally fix the problem…
         
         Well, the crash occurred again, 2022-09-22, while developing, running
         BookMacster 3.0.4 in Xcode.  This occurred after app had been
         running for 3 hours, I did the safari test (`testsaf`) three hours
         ago, and now I just re-opened …/Collections/Safari-1.bmco.  So it's
         like the trigger is set by running that test script 3 hours ago?
         Oh, and this time the inspector was not showing and was never showing
         at all since the app launched 3 hours ago.  So the problem is not
         caused by the Inspector per se.
         
         Crash occurred again on 2023-09-08, after BookMacster ad been sitting
         idle in the Xcode debugger for 2 days.  */
    }
    
	NSArray* selectedStarks = [windowController selectedStarks] ;
    if (
        /* The following qualification, added in BookMacster 1.22.9, fixes bug
         so that Inspector no longer changes to "No Selection" when the selected
         bookmark is moved into a collapsed folder in Outline Mode.  Note that
         selectedStarki is what the stark controller in the Inspector window is
         bound to. */
        ([selectedStarks count] > 0)
        ||
        /* Added to keep the previous qualification from being too restrictive,
         so that Inspector does not continue to show stark after its document
         has closed which could, of course cause a crash if user touches it.
         In this case, selected starks *should* be set to nil. */
        !windowController
        ||
        /* Added to make the Inspector subject go to "No Selection" when
         a stark is deleted.  (In this case, 'stark' obtained from 
         [windowController selectedStark] will be a NSNoSelectionMarker,
         and then, above, it will be changed to a NoStark.) */
        ([stark isKindOfClass:[NoStark class]])
        ) {
        starki = [Starki starkiWithStarks:selectedStarks] ;
        [self setSelectedStarki:starki] ;
    }
}

- (void)setIfNoBkmxDocWindowsSelectedStark:(Stark*)stark {
	// I think that one could also use ([SSYAppLSUI currentType] == SSYProcessTyperTypeForeground)  here
	// But I thought maybe this would be more reliable.
	for (NSWindow* window in [NSApp windows]) {
		if ([[window windowController] isKindOfClass:[BkmxDocWinCon class]]) {
			if ([window isVisible]) {
				return ;
			}
		}
	}
	
	// If we made it here, there are no BkmxDoc document windows open.
	[self setSelectedStark:stark] ;
    
    // The following was added to fix bug, in BookMacster 1.12
    Starki* starki = [Starki starkiWithStarks:[NSArray arrayWithObject:stark]] ;
	[self setSelectedStarki:starki] ;
}

- (IBAction)makeForeground:(id)sender {
	// The following if() was added in BookMacster 1.11 to fix the fact that, after
	// changing the code to invoke this method, if any documents were open, if BookMacster
	// was already not a LSUIElement, and if any document windows were open, a second
	// window would be opened for each document, by -makeWindowControllers, in the enclosed loop 
	if ([SSYProcessTyper currentType] != NSApplicationActivationPolicyRegular)  {
		[SSYProcessTyper transformToForeground:nil] ;
		
		for (BkmxDoc* bkmxDoc in [[NSDocumentController sharedDocumentController] documents]) {
			// The following "if" was added in BookMacster 1.13.2, to handle
            // the case when the app was showing (has a window controller),
            // was put into LSUIElement type ("Hide BookMacster") and then
            // back into Foreground type ("Show BookMacster").  In this case,
            // it will already have a window controller and a window, and
            // we don't want another.
            if (![bkmxDoc bkmxDocWinCon]) {
                [bkmxDoc makeWindowControllers] ;
            }
			[[[bkmxDoc bkmxDocWinCon] window] display] ;
            [[bkmxDoc bkmxDocWinCon] updateWindowForStark:nil] ;
		}
	}
}

#pragma mark * Show/Hide Inspector

- (void)showInspectorIfItWasShowing {
	if ([[[NSUserDefaults standardUserDefaults] objectForKey:constKeyInspectorWasShowing] boolValue]) {
        [self showInspectorWithOomph] ;
	}
}

- (BOOL)inspectorShowing {
	BOOL inspectorShowing ;
	@synchronized(self) {
        inspectorShowing = [[NSUserDefaults standardUserDefaults] boolForKey:constKeyInspectorWasShowing] ;
	}
	return inspectorShowing ;
}

- (void)inspectorShowUrls {
	[inspectorController showUrls] ;
}

- (NSUserDefaults*)standardUserDefaults {
	return [NSUserDefaults standardUserDefaults] ;
}

- (NSString*)activeBrowserExformat {
	NSArray* supportedBundleIdentifiers = [[BkmxBasis sharedBasis] supportedLocalAppBundleIdentifiers] ;
	
	NSRunningApplication* anApp = [[NSWorkspace sharedWorkspace] frontmostApplication] ;
    NSRunningApplication* activeBrowserApp = nil ;
	NSString* bundleIdentifier = [anApp bundleIdentifier] ;
	if ([supportedBundleIdentifiers indexOfObject:bundleIdentifier] != NSNotFound) {
		activeBrowserApp = anApp ;
        [self setLastActiveBrowserApp:anApp] ;
	}
    
    if (!activeBrowserApp) {
		NSArray* runningApplications = [[NSWorkspace sharedWorkspace] runningApplications] ;
        /* Unfortunately, the order of -runningApplications is unspecified.
         What we really want is the "frontmoster" or most-recently-active
         browser app.  We approximate that by using the one that *we* most
         recently saw as active, if it is still running. */
        if ([runningApplications indexOfObject:[self lastActiveBrowserApp]] != NSNotFound) {
            activeBrowserApp = [self lastActiveBrowserApp] ;
        }
        
        /* If that didn't work, pick the "first" running browser app, which as
         I've said is unspecified, but it is usually the first launched.
         Oh, well. */
        if (!activeBrowserApp) {
            for (anApp in runningApplications) {
                bundleIdentifier = [anApp bundleIdentifier] ;
                if ([supportedBundleIdentifiers indexOfObject:bundleIdentifier] != NSNotFound) {
                    activeBrowserApp = anApp ;
                    break ;
                }
            }
        }
	}
	
	NSString* exformat = nil ;
	if (activeBrowserApp) {
        NSString* activeBrowserBundleIdentifier = [activeBrowserApp bundleIdentifier] ;
        NSInteger index = [[[BkmxBasis sharedBasis] supportedLocalAppBundleIdentifiers] indexOfObject:activeBrowserBundleIdentifier] ;
        NSArray* exformats = [[BkmxBasis sharedBasis] supportedLocalAppExformatsIncludeNonClientable:YES] ;
        if ((index != NSNotFound) && (index < [exformats count])) {
            exformat = [exformats objectAtIndex:index] ;
        }
        else {
            NSLog(@"Internal Error 524-8584 %@ :: %@", activeBrowserApp, activeBrowserBundleIdentifier) ;
        }
	}

	return exformat ;
}

- (BOOL)attemptRecoveryFromError:(NSError *)error 
				  recoveryOption:(NSUInteger)recoveryOption {
	error = [error deepestRecoverableError] ;
	if (
        [[NSDocumentController sharedDocumentController] indicatesNoDataModelError:error]
        ||
        (error.code == constBkmxErrorNeedVersion3)
        ){
		switch (recoveryOption) {
			case NSAlertFirstButtonReturn:
				// "Check for Update"
                [[Sparkler shared] checkForUpdates];
				break ;
			case NSAlertSecondButtonReturn:
				// "Cancel"
			default:
				break ;
		}
	}
	
	return YES ;
}

- (NSArray*)tagCompletionsForTagPrefix:(NSString*)prefix
                         selectIndex_p:(NSInteger*)index_p {
	// This is so that the calling field editor does not force the
	// first completion onto the user.
	if (index_p) {
        *index_p = -1 ;   
    }
	
	// Now, the actual work of finding all existing, matching tags
	NSMutableSet* mutableSet = [[NSMutableSet alloc] init] ;
	for (BkmxDoc* bkmxDoc in [[NSDocumentController sharedDocumentController] documents]) {
		NSCountedSet* someTags = [[bkmxDoc tagger] allTags] ;
        [mutableSet unionSet:someTags] ;
	}
	
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"string beginswith[cd] %@", prefix] ;
    [mutableSet filterUsingPredicate:predicate] ;
    NSArray* candidateTags = [mutableSet allObjects] ;
    [mutableSet release] ;

    // Sort the array.
    // I decided not to do this…
    // NSArray* answer = [compositeSet arrayOrderedByCount] ;
    // because it would be confusing to the user.
    // Actually, it *would* be a good idea to *not* limit
    // the number of tags in the previous loop, then order by
    // count in order to make the cutoff at 15, then re-order
    // alphabetically.  But that would take too much programming
    // effort for too little usability gain.
    // So I just simply alphabetize the arbitrary first 15…
    candidateTags = [candidateTags sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] ;
    NSArray* candidateStrings = [candidateTags valueForKey:constKeyString];
    
	return candidateStrings;
}

- (IBAction)guideUserToSafeLimitMenuItem:(NSMenuItem*)sender {
    NSObject <BkmxDocumentProvider> * target ;
    if ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppBookMacster) {
        // Safe limit controls are in document window
        BkmxDocWinCon* winCon = [[[NSDocumentController sharedDocumentController] frontmostDocument] bkmxDocWinCon] ;
        
        // See "Warning about other windows" in SafeLimitGuider.h
        [[winCon window] makeKeyAndOrderFront:self] ;

        target = [winCon settingsViewController] ;
    }
    else {
        // Safe limit controls are in Preferences window.
        target = [self prefsWinCon] ;

        // See "Warning about other windows" in SafeLimitGuider.h
        [[(PrefsWinCon*)target window] makeKeyAndOrderFront:self] ;
    }
    
    // See "Warning about other windows" in SafeLimitGuider.h
    [self doShowInspector:NO] ;

    [target guideUserToSafeLimitMenuItem:sender] ;
}

- (NSImage*)statusItemImageForStyle:(BkmxStatusItemStyle)style {
    NSImage* image ;
    switch (style) {
        case BkmxStatusItemStyleNone:
            image = nil ;
            break ;
        case BkmxStatusItemStyleFlat:
            image = [SSYVectorImages imageStyle:SSYVectorImageStyleBookmark
                                         wength:16
                                          color:nil
                                   darkModeView:nil // For this template image, Cocoa will handle luminance inversion when in Dark Mode
                                  rotateDegrees:0.0
                                          inset:0.0] ;
            break ;
        case BkmxStatusItemStyleGray:
        default: ;
            /* This will happen when a user who had style set to the deprecated
             BkmxStatusItemStyleColor = 30 updates from BkmkMgrs 1.x to 2.x.
             No, I didn't check why, I just saw it happen once :( */

            image = [[NSImage imageNamed:@"AppIcon"] copy] ;
            [image setSize:NSMakeSize(20.0, 20.0)] ;
            if (style == BkmxStatusItemStyleGray) {
                /* setTemplate:YES is also needed here, to force the image
                 to be displayed as grayscale in the sample in Preferences >
                 Appearance. */
                [image setTemplate:YES] ;
            }
            [image autorelease] ;
            break ;
    }
    
    return image ;
}

- (void)endEditingForInspector {
    [inspectorController endEditing] ;
}

#define QUEUED_JOB_STATUS_LIFETIME 1.5

- (NSArray*)jobQueue {
    if ([NSDate timeIntervalSinceReferenceDate] > self.jobsQueueRefreshDate + QUEUED_JOB_STATUS_LIFETIME) {
        [_jobQueue release];
        _jobQueue = nil;
     }

    return _jobQueue;
}

- (NSMutableDictionary*)agentTimeoutters {
    if (!_agentTimeoutters) {
        _agentTimeoutters = [NSMutableDictionary new];
    }

    return _agentTimeoutters;
}

- (void)handleAgentCommunicationError:(NSError*)error {
    [SSYAlert performSelectorOnMainThread:@selector(alertError:)
                               withObject:error
                            waitUntilDone:NO];
}

- (void)handleAgentProxyMessagingError:(NSError*)error
                           thenDoBlock:(void (^)(NSError* error))errorBlock {
    error = [error errorByAddingUserInfoObject:[[BkmxBasis sharedBasis] runningAgentDescription]
                                        forKey:@"Running Agent Description"];
    errorBlock(error);
}

#define TALK_TO_AGENT_TIMEOUT 8.634

- (void)handleGenericAgentTimeoutTimer:(NSTimer*)timer {
    void (^errorBlock)(NSError*) = timer.userInfo;
    NSString* desc = [[NSString alloc] initWithFormat:
                      NSLocalizedString(@"No response from agent after %0.1f seconds", nil),
                      TALK_TO_AGENT_TIMEOUT];
    NSError* error = SSYMakeError(297742, desc);
    [desc release];
    [self handleAgentProxyMessagingError:error
                             thenDoBlock:errorBlock];

    NSString* uuid = nil;
    for (NSString* aUuid in [[self agentTimeoutters] allKeys]) {
        NSTimer* aTimer = [[self agentTimeoutters] objectForKey:uuid];
        if (aTimer == timer) {
            uuid = aUuid;
            break;
        }
    }

    if (uuid) {
        [[self agentTimeoutters] removeObjectForKey:uuid];
    }
}

- (void)registerNewTimeoutterWithUuid:(NSString*)uuid
                           errorBlock:(void (^)(NSError*))errorBlock {
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSTimer* timeoutter = [NSTimer scheduledTimerWithTimeInterval:TALK_TO_AGENT_TIMEOUT
                                                               target:self
                                                             selector:@selector(handleGenericAgentTimeoutTimer:)
                                                             userInfo:errorBlock
                                                              repeats:NO];
        [[self agentTimeoutters] setObject:timeoutter
                                    forKey:uuid];
    });
}

- (void)destroyTimeoutterOnMainThreadForUuid:(NSString*)uuid {
    NSTimer* timer = [[self agentTimeoutters] objectForKey:uuid];
    [timer invalidate];
    [[self agentTimeoutters] removeObjectForKey:uuid];
}

- (void)destroyTimeoutterForUuid:(NSString*)uuid {
    [self performSelectorOnMainThread:@selector(destroyTimeoutterOnMainThreadForUuid:)
                           withObject:uuid
                        waitUntilDone:NO];
}

typedef void (^TaskBlockType)(id <BkmxAgentProtocol>);

/*!
 @brief    Wrapper method for invoking XPC services which handles getting
 the proxy, creating a timeout timer, and handling low-level errors

 @details  This method will launch a BkmxAgent if it is not already running

 @param    taskBlock  Code block to be executed after the proxy is obtained.
 Of course, this should include whatever call you want to send to the XPC
 service.

 @param    errorBlock  Code blcok which will be executed if any of these occur:
 • Bundle ID of agent could not be found
 • Connection times out waiting for a reply from the XPC service
 • Connection could not be created
 • Proxy encounters an error while handling request

 @param    timeoutterUuid  UUID which will be used to identify the timeout
 timer which this mehod creates.  Both the taskBlock and the errorBlock
 passed to this mehod should invoke -destroyTimeoutterForUuid: and pass this
 UUID.
 */
- (void)getAgentProxyAndThenDoBlock:(TaskBlockType)taskBlock
                     ifErrorDoBlock:(void (^)(NSError*))errorBlock
                     timeoutterUuid:(NSString*)timeoutterUuid {
    dispatch_queue_t aSerialQueue = dispatch_queue_create(
                                                          "com.sheepsystems.BkmxAgentProxy",
                                                          DISPATCH_QUEUE_SERIAL
                                                          ) ;
    dispatch_async(aSerialQueue, ^{
        [self registerNewTimeoutterWithUuid:timeoutterUuid
                                 errorBlock:errorBlock];

        NSError* __block error = nil;
        NSString* bundleIdentifier = [[BkmxBasis sharedBasis] bundleIdentifierForLoginItemName:constAppNameBkmxAgent
                                                                                   inWhich1App:[[BkmxBasis sharedBasis] iAm]
                                                                                       error_p:&error];
        if (bundleIdentifier) {
            // This will launch BkmxAgent if it is not already running.
            NSXPCConnection* connection = [[NSXPCConnection alloc] initWithMachServiceName:bundleIdentifier
                                                                                   options:0];
            if (connection == nil) {
                NSString* errorDesc = [NSString stringWithFormat:
                                       @"Could not connect to agent %@",
                                       bundleIdentifier];
                error = SSYMakeError(279854, errorDesc);
                error = [error errorByAddingUserInfoObject:[[BkmxBasis sharedBasis] runningAgentDescription]
                                                    forKey:@"Running Agent Description"];
            }

            if (error) {
                [self handleAgentProxyMessagingError:error
                                         thenDoBlock:errorBlock];
            } else {
                NSXPCInterface* interface = [NSXPCInterface interfaceWithProtocol:@protocol(BkmxAgentProtocol)];
                // Next line is necessary to pass a custom class (Job) via XPC:
                [interface setClasses:[NSSet setWithObjects: [NSArray class], [NSString class], [NSDate class], [Job class], nil]
                          forSelector:@selector(getJobsThenDo:)
                        argumentIndex:0
                              ofReply:YES];
                connection.remoteObjectInterface = interface;
                [connection resume];

                id <BkmxAgentProtocol> agentProxy = [connection remoteObjectProxyWithErrorHandler:^(NSError *messageHandlingError) {
                    /* This block will be run if and whenever proxy encounters
                     an error handling a message.  If the message sent to
                     the proxy has a reply handler, then either this block or the
                     reply handler will be called exactly once.

                     This method will always be invoked on a secondary thread. */
                    [self destroyTimeoutterForUuid:timeoutterUuid];
                    [connection invalidate];
                    error = SSYMakeError(984680, @"Agent Proxy encountered error.");
                    error = [error errorByAddingUnderlyingError:messageHandlingError];
                    [self handleAgentProxyMessagingError:error
                                             thenDoBlock:errorBlock];
                }];

                taskBlock(agentProxy);
            }
            [connection release];
        } else {
            error = [SSYMakeError(908558, @"Could not find bundle and/or bundle identifier for Agent") errorByAddingUnderlyingError:error];
            [self handleAgentProxyMessagingError:error
                                     thenDoBlock:errorBlock];
        }
    });
}

- (void)updateJobsQueueThenDo:(void (^)(NSArray<Job*>*, NSError*))thenDo {
    if ([[BkmxBasis sharedBasis] runningAgents].count > 0) {
        NSString* timeoutterUuid = [SSYUuid uuid];

        void (^taskBlock)(id<BkmxAgentProtocol>) = ^void(id<BkmxAgentProtocol> agentProxy) {
            [agentProxy getJobsThenDo:^(NSArray<Job*>* jobQueue) {
                [self destroyTimeoutterForUuid:timeoutterUuid];
                if (jobQueue) {
                    self.jobsQueueRefreshDate = [NSDate timeIntervalSinceReferenceDate];
                    thenDo(jobQueue,nil);
                } else {
                    NSError* error = SSYMakeError(552083, @"BkmxAgent did not return list of queued jobs");
                    self.jobsQueueRefreshDate = [NSDate timeIntervalSinceReferenceDate];
                    thenDo(nil, error);
                }
            }];
        };

        void (^errorBlock)(NSError*) = ^void(NSError* error) {
            [self destroyTimeoutterForUuid:timeoutterUuid];
            self.jobsQueueRefreshDate = [NSDate timeIntervalSinceReferenceDate];
            error = [SSYMakeError(984681, @"Error getting updated jobs queue from Agent") errorByAddingUnderlyingError:error];
            [[BkmxBasis sharedBasis] logError:error
                              markAsPresented:NO];
            thenDo(nil, error);
        };

        [self getAgentProxyAndThenDoBlock:taskBlock
                           ifErrorDoBlock:errorBlock
                           timeoutterUuid:timeoutterUuid];
    } else {
        self.jobsQueueRefreshDate = [NSDate timeIntervalSinceReferenceDate];
        thenDo(nil, nil);
    }
}

- (void)cancelStagedAndQueuedJobsInAgentForDocumentUuid:(NSString*)docUuid {
    if ([[BkmxBasis sharedBasis] runningAgents].count > 0) {
        NSString* timeoutterUuid = [SSYUuid uuid];

        void (^taskBlock)(id<BkmxAgentProtocol>) = ^void(id<BkmxAgentProtocol> agentProxy) {
            [agentProxy cancelStagedAndQueuedJobsForDocUuid:docUuid
                                                     thenDo:^(NSInteger unstagedCount, NSInteger unqueuedCount) {
                                                         [self destroyTimeoutterForUuid:timeoutterUuid];
                                              NSString* report = [NSString stringWithFormat:
                                                                  @"Unstaged %ld, unqueued %ld jobs",
                                                                  unstagedCount,
                                                                  unqueuedCount];
                                              [[BkmxBasis sharedBasis] logFormat:report];
                                          }];
        };

        void (^errorBlock)(NSError*) = ^void(NSError* error) {
            [self destroyTimeoutterForUuid:timeoutterUuid];
            error = [SSYMakeError(constBkmxErrorCancellingStagedAndQueuedJobsInAgent,
                                  @"Error cancelling jobs in Agent") errorByAddingUnderlyingError:error];
            [[BkmxBasis sharedBasis] logError:error
                              markAsPresented:NO];
        };

        [self getAgentProxyAndThenDoBlock:taskBlock
                           ifErrorDoBlock:errorBlock
                           timeoutterUuid:timeoutterUuid];
    } else {
        [[BkmxBasis sharedBasis] logFormat:@"Cancel jobs but BkmxAgent not running -> Nothing to cancel"];
    }
}

- (void)demoPresentUserNotificationWithTitle:(NSString*)title
                              alertNotBanner:(BOOL)alertNotBanner
                                    subtitle:(NSString*)subtitle
                                        body:(NSString*)body
                                   soundName:(NSString*)soundName
                                      window:(NSWindow*)window {
    NSError* error = nil;
    if ([[BkmxBasis sharedBasis] runningAgents].count > 0) {
        if (title || soundName) {
            NSString* timeoutterUuid = [SSYUuid uuid];
            
            void (^taskBlock)(id<BkmxAgentProtocol>) = ^void(id<BkmxAgentProtocol> agentProxy) {
                [agentProxy demoPresentUserNotificationWithTitle:title
                                                  alertNotBanner:alertNotBanner
                                                        subtitle:subtitle
                                                            body:body
                                                       soundName:soundName
                                                          thenDo:^(NSError* notificationError) {
                    if (notificationError) {
                        // SSYAlert must be created on main thread
                        dispatch_queue_t mainQueue = dispatch_get_main_queue() ;
                        dispatch_sync(mainQueue, ^{
                            SSYAlert* alert = [SSYAlert new];
                            [alert alertError:notificationError
                                     onWindow:window
                            completionHandler:NULL];
                            [alert release];
                        }) ;
                    }
                }];
            };
            
            void (^errorBlock)(NSError*) = ^void(NSError* error) {
                [self destroyTimeoutterForUuid:timeoutterUuid];
                error = [SSYMakeError(constBkmxErrorCancellingStagedAndQueuedJobsInAgent,
                                      @"Error cancelling jobs in Agent") errorByAddingUnderlyingError:error];
                [[BkmxBasis sharedBasis] logError:error
                                  markAsPresented:NO];
            };
            
            [self getAgentProxyAndThenDoBlock:taskBlock
                               ifErrorDoBlock:errorBlock
                               timeoutterUuid:timeoutterUuid];
        } else {
            error = SSYMakeError(294848, @"To demonstrate an Alert, Banner and/or sound, you must switch on one of the checkboxes.");
        }
    } else {
        error = SSYMakeError(294849, @"Our syncing agent (BkmxAgent) must be running to demonstrate its notifications.\n\nPlease return here and retry this demo after you have activated some Syncing.");
    }
    
    if (error) {
        SSYAlert* alert = [SSYAlert new];
        [alert alertError:error
                 onWindow:window
        completionHandler:NULL];
        [alert release];
    }
}

- (NSString*)reportForError:(NSError*)error {
    return [NSString stringWithFormat:
            NSLocalizedString(@"*** Error %ld:  %@.  Underlying Error %ld:  %@.  That part of this report, which should be here,  is therefore omitted.\n", nil),
            error.code,
            error.localizedDescription,
            error.underlyingError.code,
            error.underlyingError.localizedDescription];
}

- (void)getWatchesReportThen:(void (^)(NSString*))then {
    if ([[BkmxBasis sharedBasis] runningAgents].count > 0) {
        NSString* timeoutterUuid = [SSYUuid uuid];

        void (^taskBlock)(id<BkmxAgentProtocol>) = ^void(id<BkmxAgentProtocol> agentProxy) {
            [agentProxy getWatchesReportThenDo:^(NSString *report) {
                [self destroyTimeoutterForUuid:timeoutterUuid];
                if (!report) {
                    NSError* error = SSYMakeError(552287, @"BkmxAgent did not return report of last realized Sync Watches");
                    [[BkmxBasis sharedBasis] logError:error
                                      markAsPresented:NO];
                    report = [self reportForError:error];
                }
                then(report);

            }];
        };

        void (^errorBlock)(NSError*) = ^void(NSError* error) {
            [self destroyTimeoutterForUuid:timeoutterUuid];
            error = [SSYMakeError(984683, @"Error getting Watches report from Agent") errorByAddingUnderlyingError:error];
            [[BkmxBasis sharedBasis] logError:error
                              markAsPresented:NO];
            NSString* report = [self reportForError:error];
            then(report);
        };

        [self getAgentProxyAndThenDoBlock:taskBlock
                           ifErrorDoBlock:errorBlock
                           timeoutterUuid:timeoutterUuid];
    } else {
        NSString* report = NSLocalizedString(@"Sections omitted here because Agent is not running or not responding.\n", nil);
        then(report);
    }
}

- (void)restartSyncWatchesThen:(void (^)(NSError*))then {
    /* We use BkmxWhichAppsMain instead of BkmxWhichAppsAny because each
     app (BookMacster, Synkmark, Smarky) has its own agent with a different
     bundle identifier. */
    NSSet <Watch*>* watches = [[NSUserDefaults standardUserDefaults] watchesForApps:BkmxWhichAppsMain];
    if (watches > 0) {
        NSString* timeoutterUuid = [SSYUuid uuid];

        void (^taskBlock)(id<BkmxAgentProtocol>) = ^void(id<BkmxAgentProtocol> agentProxy) {
            [agentProxy restartSyncWatchesThenDo:^(NSInteger errorCount) {
                [self destroyTimeoutterForUuid:timeoutterUuid];
                if (errorCount > 0) {
                    NSString* errorDesc = [NSString stringWithFormat:
                                           @"Agent encountered %ld errors when restarting watches.  "
                                           @"To see errors, click in the menu: %@ > %@, then click tab %@.",
                                           errorCount,
                                           [[BkmxBasis sharedBasis] appNameLocalized],
                                           [NSString localize:@"logs"],
                                           [NSString localize:@"errors"]];
                    NSError* error = SSYMakeError(889572, errorDesc);
                    then(error);
                }
            }];
        };

        void (^errorBlock)(NSError*) = ^void(NSError* error) {
            error = [SSYMakeError(984684, @"Error restarting Watches in Agent") errorByAddingUnderlyingError:error];
            [[BkmxBasis sharedBasis] logError:error
                              markAsPresented:NO];
            [self destroyTimeoutterForUuid:timeoutterUuid];
            then(error);
        };

        [self getAgentProxyAndThenDoBlock:taskBlock
                           ifErrorDoBlock:errorBlock
                           timeoutterUuid:timeoutterUuid];
    } else {
        [[BkmxBasis sharedBasis] logFormat:@"No sync watches to restart"];
        then(nil);
    }
}

- (void)finishRemovingAllSyncersFromDocUuid:(NSString *)docUuid {
    Macster* macster = [[BkmxBasis sharedBasis] macsterWithDocUuid:docUuid
                                                      createIfNone:NO] ;
    for (Syncer* syncer in [macster syncers]) {
        [Stager removeStagingForSyncerUri:[syncer objectUriMakePermanent:NO
                                                                document:nil]];
    }

    [macster deleteAllSyncers] ;
    [macster save];
}

- (void)removeSyncersForDocumentUuid:(NSString*)docUuid {
    if (!docUuid) {
        return ;
    }

    [self cancelStagedAndQueuedJobsInAgentForDocumentUuid:docUuid];

    /* Must be done on main thread due to Core Data access */
    [self performSelectorOnMainThread:@selector(finishRemovingAllSyncersFromDocUuid:)
                           withObject:docUuid
                        waitUntilDone:YES];
}

- (NSMenuItem*)stopAllSyncingMenuItem {
    return  [[[[NSApp mainMenu] itemWithTag:1000] submenu] itemWithTag:48200];
}

- (void)setStopAllSyncingMenuItemEnabled:(BOOL)enabled {
    /* Note EnDisDynamicMenuItem
     Supposedly, setting .enabled has no effect on this menu item, because
     its menu (the app-name menu) uses Automatic Menu Enabling  (which is on
     by default).  However this is kind of a weird case since I am usually
     enabling it here while it is displayed.  I find that setting .enabled
     *does* have an effect.  Before I started enabling it while displayed,
     in BkmkMgrs 2.8, I en/disabled it by setting the action to something/nil.
     For maximum reliability, I now do BOTH. */
    NSMenuItem* menuItem = [self stopAllSyncingMenuItem];
    [menuItem setAction:(enabled ? @selector(stopAllSyncing:) : NULL)] ;
    menuItem.enabled = enabled;
}

- (void)updateStopAllSyncingMenuItemWithJobs:(NSArray<Job*>*)jobs
                                       error:(NSError*)errorIn {
    // If agent is not running, jobs will be nil.  That is OK.

    NSInteger countQueued = jobs.count;
    NSInteger countStaged = 0;
    NSDictionary* stagedJobArchives = [[NSUserDefaults standardUserDefaults] stagedJobArchivesForApps:BkmxWhichAppsAny];
    if ([stagedJobArchives isKindOfClass:[NSDictionary class]]) {
        countStaged = stagedJobArchives.count;
    } else {
        NSAssert(stagedJobArchives == nil, @"stagingInfos wrong class: %@", [stagedJobArchives className]);
    }
    NSInteger countDocs = [Syncer totalDocsOfAnyAppWithInstalledSyncers] ;

    NSString* suffix1;
    BOOL anythingToDo = (countStaged + countQueued + countDocs > 0);
    if (anythingToDo) {
        NSMutableString* status = [[NSMutableString alloc] init];
        if (countDocs > 0) {
            [status appendFormat:@"%ld documents syncing", countDocs];
        }
        if (countStaged > 0) {
            if (status.length > 0) {
                [status appendString:@", "];
            }
            [status appendFormat:@"%ld jobs staged", countStaged];
        }
        if (countQueued > 0) {
            if (status.length > 0) {
                [status appendString:@", "];
            }
            [status appendFormat:@"%ld jobs queued or running", countQueued];
        }
        suffix1 = [NSString stringWithFormat:
                   @"(%@)",
                   status];
        [status release];
    } else {
        suffix1 = [NSString stringWithFormat:
                   @"(%@)",
                   NSLocalizedString(@"Nothing to stop", nil)];
    }

    NSString* suffix2 = @"";
    if (errorIn) {
        suffix2 = [NSString stringWithFormat:
                   NSLocalizedString(@" but Error %ld", nil),
                   errorIn.code];
    }

    NSString* title = [NSString stringWithFormat:
                       @"%@ %@%@…",
                       [[BkmxBasis sharedBasis] labelStopAllSyncingNow],
                       suffix1,
                       suffix2];

    NSMenuItem* menuItem = [self stopAllSyncingMenuItem];
    [menuItem setTitle:title] ;

    [self setStopAllSyncingMenuItemEnabled:anythingToDo];
 }

// Note: For this to work, I must be the delegate for the relevant menus
// These delegations are set in -tweakMainMenu
- (void)menuNeedsUpdate:(NSMenu*)menu {
    // Since old C does not allow declarations within a switch block, ...
    BOOL state ;
    NSArray* starks ;
    NSString* title ;
    NSString* list ;
    BkmxDoc* bkmxDoc ;
    BkmxDocWinCon* currentBkmxDocWincon ;
    NSMenuItem* menuItem ;
    SEL action;
    NSInteger supertag = [menu supertag] ;

    switch (supertag)  {
        case 1000:
            // Application menu of Main Menu

            // Background BookMacster
            menuItem = [menu itemWithTag:1560] ;
            BOOL canRunInBackground = ([(BkmxAppDel*)[NSApp delegate] canRunInBackground]) ;
            id target ;
            if (canRunInBackground) {
                target = self ;
                action = @selector(background:) ;
            }
            else {
                target = nil ;
                action = NULL ;
            }
            [menuItem setTarget:target] ;
            [menuItem setAction:action] ;
            [menuItem setTitle:[[BkmxBasis sharedBasis] labelBackgroundApp]] ;
            NSString* toolTip ;
            if (!canRunInBackground) {
                toolTip = @"Background operation equires enabling either the "
                @"Status Item in Prefs > Appearance or Keyboard Shortcut to "
                @"the Floating Menu in Prefs > Shortcuts." ;
            }
            else {
                toolTip = [[BkmxBasis sharedBasis] toolTipBackground] ;
            }
            [menuItem setToolTip:NSLocalizedString(toolTip, nil)];

            // Stop all Syncing now
            menuItem = [menu itemWithTag:48200];
            NSArray* jobQueue = [self jobQueue];
            if (jobQueue) {
                [self updateStopAllSyncingMenuItemWithJobs:jobQueue
                                                     error:nil];
            } else {
                menuItem.title = NSLocalizedString(@"Stop Syncing: Please wait for status…", nil);
                [self setStopAllSyncingMenuItemEnabled:NO];
                [self updateJobsQueueThenDo:^(NSArray<Job*>* jobsQueue, NSError* error) {
                    /* Since menu updating must be done on main thread, … */
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self updateStopAllSyncingMenuItemWithJobs:jobsQueue
                                                             error:error];
                    });
                }];
            }
            break ;
        case 500:;
            // File Menu of Main Menu
            currentBkmxDocWincon = [(BkmxDoc*)[[NSDocumentController sharedDocumentController] frontmostDocument] bkmxDocWinCon] ;
            BOOL hasDocumentWindow = (currentBkmxDocWincon != nil) ;
            NSMenu* submenu ;



            // Add, maybe, the "Welcome Start Here" to the "New BkmxDoc" item
            menuItem = [menu itemWithTag:48115] ;
            NSString* docType = [[NSDocumentController sharedDocumentController] defaultDocumentDisplayName] ;
            NSString* prefix = [NSString localizeFormat:@"new%0", docType] ;
            NSString* suffix = nil ;
            if (
                [SSYAppInfo isNewUser]
                &&
                ([[[NSDocumentController sharedDocumentController] recentDocumentURLs] count] == 0)
                &&
                ([[[NSDocumentController sharedDocumentController] documents] count] == 0)
                ) {
                suffix = [NSString stringWithFormat:@"        %@%C",
                          [NSString localize:@"startHere"],
                          (unsigned short)0x2026] ;
            }
            [(SSYSuffixedMenuItem*)menuItem setTitlePrefix:prefix
                                                    suffix:suffix] ;

            [self updateIxportOnlyItemsInMenu:menu] ;

            // Export BookMacsterize Bookmarklet
            menuItem = [menu itemWithTag:587] ;
            // See Note 982343 at end of file.
            if (hasDocumentWindow) {
                // Make submenu = the submenu of the "Export Bookmarklet to ▸" item
                submenu = [[NSMenu alloc] init] ;
                [menuItem setSubmenu:submenu] ;
                [submenu setDelegate:currentBkmxDocWincon] ;
                [submenu release] ;
            }
            else {
                [menuItem setSubmenu:nil] ;
            }
            [[menuItem submenu] setDelegate:currentBkmxDocWincon] ;
            [menuItem setEnabled:hasDocumentWindow] ;

            /* Disable Close and Trash if document has no URL (because it
             has not been saved yet)  In this case, Close and Trash will not
             work because there it requires a fileURL.  There may be a way to
             trash the temporary document, but I know that is a rabbit hole
             which could take the better part of day to explore.  So I just
             disable the menu item. */
            /* Apparently, this menu also uses Automatic Menu
             Enabling (which is on by default), because
             -[NSMenuItem setEnabled:] has no effect.  Therefore I
             disable by setting its action to nil instead…*/
            if ([[[NSDocumentController sharedDocumentController] frontmostDocument] fileURL]) {
                action = @selector(closeAndTrash:);
            } else {
                action = NULL;
            }
            menuItem = [menu itemWithTag:48400];
            [menuItem setAction:action];

            // "Import All (…) and Export All (…) items
            for (NSMenuItem* item in [menu itemArray]) {
                if ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppSmarky) {
                    NSInteger tag = [item tag] ;
                    switch (tag) {
                        case 4301:
                            // Main Menu > File > Import All
                            title = NSLocalizedString(@"Import from Safari", nil);
                            [item setTitle:title] ;
                            break ;
                        case 4302:
                            // Main Menu > File > Export All
                            title = NSLocalizedString(@"Export to Safari", nil);
                            [item setTitle:title] ;
                            break ;
                    }
                }
                else {
                    list = nil ;
                    title = [self getTitleAndUpdateImexAllMenuItem:item
                                                            list_p:&list] ;

                    if (title) {
                        if (list) {
                            title = [title stringByAppendingFormat:
                                     @" (%@)",
                                     list] ;
                        }

                        [item setTitle:title] ;
                    }
                }
            }

            [self updateIxportOnlyItemsInMenu:menu] ;

            if ([menu respondsToSelector:@selector(removeNonShoeboxMultiDocItems)]) {
                // This is Markster, Smarky or Synkmark.  We get this by
                // including SSYShoeboxDocument-Categories.m in these *app*
                // targets instead of in Bkmxwork.
                [menu removeNonShoeboxMultiDocItems] ;
            }
            else {
                // This is BookMacster or BkmxAgent.
            }

            break ;
        case 1200:
            // Licensing (Registration) Submenu of Application Menu of Main Menu
            break ;
        case 3000:
            // Edit menu of Main Menu

            starks = [StarkEditor starksFromSender:nil] ;
            // Note: starks could be nil if the Preferences window, for example,
            // was NSApp's mainWindow.
            for (NSMenuItem* item in [menu itemArray]) {
                title = nil ;
                switch ([item tag]) {
                    case 3200:
                        // Main Menu > Edit > Visit
                        title = [[BkmxBasis sharedBasis] labelVisitForBookmarksCount:[Starker countOfBookmarksInItems:starks]
                                                                      urlTemporality:BkmxUrlTemporalityCurrent] ;
                        break ;
                    case 3510:;
                        currentBkmxDocWincon = [(BkmxDoc*)[[NSDocumentController sharedDocumentController] frontmostDocument] bkmxDocWinCon] ;
                        [NSMenu configureToSortNowItem:item
                                             smallFont:NO
                                                starks:[currentBkmxDocWincon selectedStarks]] ;
                        break ;
                    case 3500:
                        // Main Menu > Edit > Will Be Sorted
                        [item setState:[Starker areSortableItems:starks]] ;
                        /* Apparently, this menu also uses Automatic Menu
                         Enabling (which is on by default), because
                         -[NSMenuItem setEnabled:] has no effect.  Therefore I
                         disable by setting the action to nil instead…*/
                        action = NULL;
                        for (Stark* stark in starks) {
                            if ([stark canHaveChildren]) {
                                action = @selector(setSelectedSortable:);
                                break;
                            }
                        }
                        [item setAction:action];
                        break ;
                    case 3911:
                        title = [[BkmxBasis sharedBasis] labelSortAtTop] ;
                        break ;
                    case 3912:
                        title = [[BkmxBasis sharedBasis] labelSortAtNormally] ;
                        break ;
                    case 3913:
                        title = [[BkmxBasis sharedBasis] labelSortAtBottom] ;
                        break ;
                }
                if (title) {
                    [item setTitle:title] ;
                }
            }

            /* The hierarchical items *Copy to >*, *Move to >*,
             and *Merge into >* are removed and re-created from
             scratch each time this method runs. */
            NSMenuItem* item;
            item = [menu itemWithTag:BKMX_STARK_CONTEXTUAL_MENU_ITEM_TAG_COPY_TO];
            if (item) {
                [menu removeItem:item];
            }
            item = [menu itemWithTag:BKMX_STARK_CONTEXTUAL_MENU_ITEM_TAG_MOVE_TO];
            if (item) {
                [menu removeItem:item];
            }
            item = [menu itemWithTag:BKMX_STARK_CONTEXTUAL_MENU_ITEM_TAG_MERGE_INTO];
            if (item) {
                [menu removeItem:item];
            }
            [menu addHierarchicalItemsForStarks:starks
                                   startAtIndex:6];

            break ;
        case 4100:
            // Syncing menu of main menu
            for (NSMenuItem* item in [menu itemArray]) {
                title = nil ;
                list = nil ;
                switch ([item tag]) {
                    case 4380:
                        // Pause/Resume syncing
                        title = [self getTitleAndUpdateSyncControlMenuItem:item
                                                                    list_p:&list] ;
                        break ;
                    default:
                        // Show Sync Log…
                        // Preferences…
                        // No updates are needed
                        ;
                }

                if (title) {
                    [item setTitle:title] ;
                }
            }
            break ;
        case 4000:
            // Bookmarks menu of Main Menu

            bkmxDoc = [[NSDocumentController sharedDocumentController] frontmostDocument] ;
            NSSet* starksSet;
            /* The following if-else is an ptimization added in BkmkMgrs 3.0 to
             speed closing of a document, to avoid fetching starks which are
             still faulted (not been fetched from the Core Data store yet) in
             case Starker's cachedAllObjects has not been populated.  This case
             can occur if user opens a document then very soon closes it. */
            if ([[[bkmxDoc windowControllers] firstObject] isClosing]) {
                starksSet = nil;
            } else {
                starksSet = [[bkmxDoc starker] allObjectsQuickly];
            }
            for (NSMenuItem* item in [menu itemArray]) {
                title = nil ;
                list = nil ;
                NSInteger nArtifactfulStarks ;
                switch ([item tag]) {
                    case 4120:
                        // Main Menu > Bookmarks > Displays Folders
                        state = NO ;
                        NSArray* windowControllers = [[[NSDocumentController sharedDocumentController] frontmostDocument] windowControllers] ;
                        // At this writing, each document only has one windowController, and it
                        // does respond to 'outlineMode', but we code defensively:
                        for (BkmxDocWinCon* winCon in windowControllers) {
                            SEL const selector = @selector(outlineMode) ;
                            if ([winCon respondsToSelector:selector]) {
                                state = [(id)winCon outlineMode] ;
                                break ;
                            }
                        }
                        [item setState:state] ;
                        break ;
                    case 4201:
                        // Main Menu > Bookmarks > Sort All
                        if ([bkmxDoc needsSort]) {
                            title = [[BkmxBasis sharedBasis] labelSortAll] ;
                        }
                        else {
                            // Adaed in BookMacster 1.12
                            title = NSLocalizedString(@"Bookmarks are all sorted", nil) ;
                        }
                        // By the way, this menu item is en/disabled in
                        // -[BkmxDoc(ActionValidator) validateMenuItem:]
                        break ;
                    case 4202:
                        // Main Menu > Bookmarks > Find Duplicates
                        if ([bkmxDoc needsDupeFind]) {
                            title = [[BkmxBasis sharedBasis] labelFindDupes] ;
                        }
                        else {
                            // Adaed in BookMacster 1.12
                            title = NSLocalizedString(@"See Reports \u25B8 Duplicates", nil) ;
                        }
                        // By the way, this menu item is en/disabled in
                        // -[BkmxDoc(ActionValidator) validateMenuItem:]
                        break ;
                    case 4401:
                        // Main Menu > Bookmarks > Verify...
                        title = [[BkmxBasis sharedBasis] labelVerifyEllipsis] ;
                        break ;
                    case 4402:
                        // Main Menu > Bookmarks > Upgrade Insecure Bookmarks...
                        title = NSLocalizedString(@"Upgrade Insecure Bookmarks…", nil) ;
                        break ;
                    case 4403:
                        // Main Menu > Bookmarks > Remove URL Cruft...
                        title = NSLocalizedString(@"Remove URL Cruft…", nil) ;
                        break ;
                    case 4540:
                        // Main Menu > Bookmarks > Consolidate Folders
                        title = [[BkmxBasis sharedBasis] labelConsolidateFolders] ;
                        [item setToolTip:[NSString localize:@"consolidateFoldersTT"]] ;
                        break ;
                    case 4510:
                        // Main Menu > Bookmarks > Expand Roots
                        title = [[BkmxBasis sharedBasis] labelExpandRoots] ;
                        break ;
                    case 4520:
                        // Main Menu > Bookmarks > Collapse Roots
                        title = [[BkmxBasis sharedBasis] labelCollapseRoots] ;
                        break ;
                    case 4550:
                        // Main Menu > Bookmarks > Delete All Items
                        title = [[BkmxBasis sharedBasis] labelDeleteAllContent] ;
                        break ;
                    case 4702:
                        // Main Menu > Bookmarks > Remove Bookdog Artifacts
                        nArtifactfulStarks = 0 ;
                        for (Stark* stark in starksSet) {
                            if ([stark hasLegacyArtifacts]) {
                                nArtifactfulStarks++ ;
                            }
                        }
                        title = [NSString stringWithFormat:
                                 @"%@ (%ld)",
                                 [[BkmxBasis sharedBasis] labelRemoveLegacyArtifacts],
                                 (long)nArtifactfulStarks] ;
                        break ;
                    default:
                        // This handles the "Sync" menu items, which are in the
                        // "Bookmarks" menu in BookMacster
                        title = [self getTitleAndUpdateSyncControlMenuItem:item
                                                                    list_p:&list] ;
                }

                if (title) {
                    if (list) {
                        title = [title stringByAppendingFormat:
                                 @" (%@)",
                                 list] ;
                    }

                    [item setTitle:title] ;
                }
            }
        case 6000:
            menuItem = [menu itemWithTag:6500] ;
            NSInteger state = [self inspectorShowing] ? NSControlStateValueOn : NSControlStateValueOff ;
            [menuItem setState:state] ;
            break ;
        case 7000:
            menuItem = [menu itemWithTag:7039] ;
            if ([SSYEventInfo alternateKeyDown]) {
                if (!menuItem) {
                    menuItem = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Dump and Crash!", nil)
                                                          action:@selector(dumpAndCrash:)
                                                   keyEquivalent:@""] ;
                    menuItem.target = self ;
                    menuItem.tag = 7039 ;
                    [menu addItem:menuItem] ;
                }
            }
            else {
                if (menuItem) {
                    [menu removeItem:menuItem] ;
                }
            }
            break ;
    }
}

- (void)updateIxportOnlyItemsInMenu:(NSMenu*)menu {
    NSMenuItem* menuItem ;
    BkmxDocWinCon* currentBkmxDocWincon = [(BkmxDoc*)[[NSDocumentController sharedDocumentController] frontmostDocument] bkmxDocWinCon] ;
    BOOL hasDocumentWindow = (currentBkmxDocWincon != nil) ;
    NSMenu* submenu ;

    // One-Time Import
    menuItem = [menu itemWithTag:580] ;
    // See Note 982343 at end of file.
    if (hasDocumentWindow) {
        // Make submenu = the submenu of the "Import from only ▸" item
        submenu = [[NSMenu alloc] init] ;
        [menuItem setSubmenu:submenu] ;
        [submenu setDelegate:currentBkmxDocWincon] ;
        [submenu release] ;
    }
    else {
        [menuItem setSubmenu:nil] ;
    }
    [[menuItem submenu] setDelegate:currentBkmxDocWincon] ;
    [menuItem setEnabled:hasDocumentWindow] ;

    // One-Time Export
    menuItem = [menu itemWithTag:585] ;
    // See Note 982343 at end of file.
    if (hasDocumentWindow) {
        // Make submenu = the submenu of the "Export to only ▸" item
        submenu = [[NSMenu alloc] init] ;
        [menuItem setSubmenu:submenu] ;
        [submenu setDelegate:currentBkmxDocWincon] ;
        [submenu release] ;
    }
    else {
        [menuItem setSubmenu:nil] ;
    }
    [[menuItem submenu] setDelegate:currentBkmxDocWincon] ;
    [menuItem setEnabled:hasDocumentWindow] ;
}

- (NSString*)getTitleAndUpdateSyncControlMenuItem:(NSMenuItem*)item
                                           list_p:(NSString**)list_p {
    NSInteger tag = [item tag] ;

    BkmxDoc* bkmxDoc ;
    if ([[BkmxBasis sharedBasis] isShoeboxApp]) {
        bkmxDoc = [[NSDocumentController sharedDocumentController] frontmostDocument] ;
        /* That does not use [self shoeboxDocumentNicelyCompletionHandler:]
         because, if the shoebox document is not available, this would cause
         Error 153802 to be generated and displayed *again*. */
    }
    else {
        bkmxDoc = [[NSDocumentController sharedDocumentController] frontmostDocument] ;
    }

    BkmxDocWinCon* currentBkmxDocWincon = [bkmxDoc bkmxDocWinCon] ;
    // currentBkmxDocWincon may be nil.

    NSString* title = nil ;
    NSString* list = nil ;

    switch (tag) {
        case 4360:;
            // Main Menu > Bookmarks > Safe Sync Limit
            BOOL hasDocumentWindow = (currentBkmxDocWincon != nil) ;
            [item setEnabled:hasDocumentWindow] ;
            // See Note 982343 at end of file.
            if (hasDocumentWindow) {
                // Make menu = the submenu of "Safe Sync Limit"
                NSMenu* menu = [[NSMenu alloc] init] ;
                [item setSubmenu:menu] ;
                [menu release] ;

                // Make item = the "Import" item of the submenu of "Safe Sync Limit"
                item = [[NSMenuItem alloc] initWithTitle:[[BkmxBasis sharedBasis] labelImport]
                                                  action:@selector(safeSyncLimitImport:)
                                           keyEquivalent:@""] ;
                [menu addItem:item] ;
                [item release] ;

                // Make item = the "Export ▸" item of the submenu "Safe Sync Limit"
                item = [[NSMenuItem alloc] init] ;
                [item setTitle:[[BkmxBasis sharedBasis] labelExport]] ;
                [menu addItem:item] ;
                [item setTag:4362] ;
                [item release] ;

                // Make menu = the submenu of the "Export ▸" item
                menu = [[NSMenu alloc] init] ;
                [item setSubmenu:menu] ;
                [menu setDelegate:currentBkmxDocWincon] ;
                [menu release] ;
            }
            else {
                [item setSubmenu:nil] ;
            }
            break;
        case 4380:;
            // Main Menu > Bookmarks > Pause/Resume Syncing
            if (currentBkmxDocWincon) {
                switch([currentBkmxDocWincon agentsPausitivity]) {
                    case NSControlStateValueOn:
                        title = NSLocalizedString(@"Pause Syncing", nil) ;
                        [item setAction:@selector(toggleSync:)] ;
                        [item setEnabled:YES] ;
                        break ;
                    case NSControlStateValueOff:
                        title = NSLocalizedString(@"Resume Syncing", nil) ;
                        [item setAction:@selector(toggleSync:)] ;
                        break ;
                    case NSControlStateValueMixed:
                    default:
                        title = NSLocalizedString(@"Syncing not set up", nil) ;
                        [item setAction:NULL] ;
                }
            }
            else {
                title = NSLocalizedString(@"Syncing not set up", nil) ;
                [item setAction:NULL] ;
            }
            break ;
    }

    if (list && list_p) {
        *list_p = list ;
    }

    return title ;
}

- (NSString*)getTitleAndUpdateImexAllMenuItem:(NSMenuItem*)item
                                       list_p:(NSString**)list_p {
    NSInteger tag = [item tag] ;
    NSString* title = nil ;
    NSString* list = nil ;
    BkmxDoc* bkmxDoc = [[NSDocumentController sharedDocumentController] frontmostDocument] ;

    switch (tag) {
        case 4301:
            // Main Menu > File > Import All
            title = [[BkmxBasis sharedBasis] labelImportFromAll] ;
            list = [[bkmxDoc macster] readableImportsList] ;
            break ;
        case 4302:
            // Main Menu > File > Export All
            title = [[BkmxBasis sharedBasis] labelExportToAll] ;
            list = [[bkmxDoc macster] readableExportsListOnlyIfVulnerable:NO
                                                            maxCharacters:48] ;
            break ;
    }

    if (list && list_p) {
        *list_p = list ;
    }

    return title ;
}

- (void)crash {
    // Crash by attempting to assign data in absolute address 0x1
    int* p = (int*)1 ;
    *p = 0 ;
}

- (void)dumpClasses {
    NSString* path = [[NSBundle mainBundle] applicationSupportPathForMotherApp] ;
    NSString* filename = [NSString stringWithFormat:
                          @"ClassDump_%@.txt",
                          [[NSDate date] compactDateTimeString]] ;
    path = [path stringByAppendingPathComponent:filename] ;
    SSYDebugLogObjcClassesByBundleToFile (
                                          path,
                                          NULL) ;
}

- (void)stopAllSyncingForApps:(BkmxWhichApps)whichApps {
    [[NSUserDefaults standardUserDefaults] removeAllWatchesExceptDocUuid:nil];
    [Stager removeAllStagingsExceptDocUuid:nil];
    [self removeAllSyncersExceptDocUuid:nil
                      completionHandler:^void(void) {
        [self finishStopAllSyncing];
    }];
}
 
- (void)removeAllSyncersExceptDocUuid:(NSString*)docUuid
                    completionHandler:(void (^)(void))completionHandler {
    BkmxDocumentController* documentController = [BkmxDocumentController sharedDocumentController];
    NSInteger __block i = 0;
    BOOL willFinishAsynchronously = NO;
    NSSet* uuids = [(BkmxAppDel*)[NSApp delegate] uuidsOfDocsWithSyncersError_p:NULL];
    for (NSString* uuid in uuids) {
        if (![uuid isEqualToString:docUuid]) {
            // Sorry about the following hack but I can't think of any
            // other way to prevent document repairs.
            [[BkmxBasis sharedBasis] setClandestine:YES] ;
            willFinishAsynchronously = YES;
            [documentController openDocumentWithUuid:uuid
                                             appName:nil // Search all 3 apps
                                             display:NO
                                      aliaserTimeout:29.065
                                   completionHandler:^(
                                                       BkmxDoc* bkmxDoc,
                                                       NSURL* resolvedUrl,
                                                       BOOL documentWasAlreadyOpen,
                                                       NSError* error) {
                [[BkmxBasis sharedBasis] setClandestine:NO] ;
                if (bkmxDoc) {
                    NSSet* agents = [[bkmxDoc macster] syncers] ;
                    [[BkmxBasis sharedBasis] logFormat:
                     @"Pausing %@ syncers of %@",
                     [NSString stringWithFormat:@"%ld", [agents count]],
                     uuid] ;

                    /* Because we have *opened* bkmxDoc and it is alive and running,
                     all we need to do is to set an appropriate syncer
                     configuration.  Notifications sent after the run loop
                     cycles will propagate this "none" syncer configuration to
                     the actual syncers in the Settings store (via
                     -[Macster syncSyncersFromSyncingConfig]). */
                    BOOL syncersArePaused = NO;
                    if ([[NSDocumentController sharedDocumentController] fileUrlSaysThisIsAShoebox:bkmxDoc]) {
                        /* The idea here is that we want to remove any existing agents,
                         but in Smarky and Synkmark we never really do that; what we
                         want instead is to be in the default state, which is to have
                         the default auto agents, but have them be paused.  The
                         following lines of code will do that. */
                        syncersArePaused = [[bkmxDoc macster] ensureAutoSyncersExistDoAlert:NO] ;
                    }
                    /*
                     If the macster currently does not have all auto agents, the
                     above method created and destroyed agents as necessary to
                     make it so, and then paused them.  If we paused agents
                     twice the second time, below,
                     the not-all-auto-agents state of agentsConfig would be
                     copied to syncersPausedConfig, resulting in an illegal, no-syncer
                     state for Smarky or Synkmark, until the next time the app was
                     launched.  What it looks like is the Syncing button in the
                     toolbar shows the gray "syncing is not configured" icon,
                     but there is no way to configure syncing from this state in
                     Smarky or BookMacster.  All of this can happen with the
                     following Steps to Reproduce…
                     - Switch on syncing
                     - Do not respond to "Sync status has changed" sheet yet.
                     - App Menu > Stop all Syncing now
                     - Button: Kill
                     - Button: OK
                     - In "Sync status has changed" sheet, button: Pause Syncing
                     
                     • However, if the macster current *does* have all auto agents,
                     the above method did nothing, so we need to pause Syncers now.
                     */
                    if (!syncersArePaused) {
                        [[bkmxDoc macster] pauseSyncers] ;
                    }
                    
                    if (documentWasAlreadyOpen) {
                        // The previously-open documentd may
                        // be running operations for the Agent right now.  Stop those.
                        [[bkmxDoc operationQueue] cancelAllOperations] ;
                        // I know that there are generally clean-up operations that
                        // have now been cancelled that still should be done.
                        // Probably more than this, but at least it's a start…
                        [[BkmxBasis sharedBasis] setCurrentAppleScriptCommand:nil] ;
                    }
                    else {
                        // The document was not already opened when we opened it.
                        // Do now those things (noted above)that would normally
                        // not be done until the run loop cycles
                        [[bkmxDoc macster] syncSyncersFromSyncingConfig] ;
                        [bkmxDoc saveMacster] ;
                        
                        // So we can close it immediately
                        [bkmxDoc close] ;
                    }
                } else {
                    /* This is a bogus or ghost document of some kind.
                     Don't worry about removing its syncers.  Log but do not
                     present the error. */
                    [[BkmxBasis sharedBasis] logError:error
                                      markAsPresented:NO];
                }
                
                i++;
                if (i == uuids.count) {
                    if (completionHandler) {
                        completionHandler();
                    }
                }
            }] ;
            
        }
    }
    
    
    if (!willFinishAsynchronously) {
        if (completionHandler) {
            completionHandler();
        }
    }
}

- (void)stopAllSyncingEllipsis {
    NSArray* jobsQueue = self.jobQueue;
    if (jobsQueue) {
        [self stopAllSyncingWithJobs:jobsQueue
                               error:nil];
    } else {
        [self updateJobsQueueThenDo:^(NSArray<Job*>* jobsQueue, NSError* error) {
            [self stopAllSyncingWithJobs:jobsQueue
                                   error:error];
        }];
    }
}

- (void)stopAllSyncingWithJobs:(NSArray<Job*>*)jobs
                         error:(NSError*)errorIn {
    // If agent is not running, jobs will be nil.  That is OK.
    NSSet <Watch*>* watches = [[NSUserDefaults standardUserDefaults] watchesForApps:BkmxWhichAppsAny];
    NSSet* documentDescriptions = [BkmxDocumentController documentDescriptionsFromWatches:watches];
    NSString* logMsg = [NSString stringWithFormat:
                        @"'Stop' found %ld queued, %ld docs",
                        (long)jobs.count,
                        (long)documentDescriptions.count
                        ] ;
    [[BkmxBasis sharedBasis] logFormat:logMsg] ;

    NSInteger countStaged = [[NSUserDefaults standardUserDefaults] stagedJobArchivesForApps:BkmxWhichAppsAny].count;

    NSMutableString* jobList = [NSMutableString new];
    for (Job* job in jobs) {
        [jobList appendFormat:@"%@\n", job.description];
    }
    if (errorIn) {
        [jobList appendFormat:
         NSLocalizedString(@"Error %ld occurred: %@", nil),
         errorIn.code,
         errorIn.localizedDescription];
        [jobList appendString:@"\n"];
    }

    NSString* docsList = [BkmxDocumentController documentListFromWatches:watches] ;

    NSString* punctuationOfQueuedJobs = (jobs.count > 0) ? @":" : @"" ;
    NSString* punctuationOfDocs = ([docsList length] > 0) ? @":" : @"" ;
    NSString* msg = [NSString stringWithFormat:
                     @"You currently have:\n\n"

                     @"%ld jobs staged\n\n"

                     @"%ld jobs running or queued%@\n"
                     @"%@\n"

                     @"%ld Collections with Syncers%@\n"
                     @"%@\n\n"

                     @"Click \"Kill\" to cancel all jobs and remove Syncers from all of these Collections.",
                     countStaged,
                     (long)jobs.count,
                     punctuationOfQueuedJobs,
                     jobList,
                     (long)documentDescriptions.count,
                     punctuationOfDocs,
                     docsList
                     ];
    [jobList release];
    [self performSelectorOnMainThread:@selector(displayStopAllSyncingDialogWithText:)
                           withObject:msg
                        waitUntilDone:NO];
}

- (void)displayStopAllSyncingDialogWithText:(NSString*)text {
    SSYAlert* alert = [SSYAlert alert] ;
    [alert setSmallText:text] ;
    [alert setTitleText:[[BkmxBasis sharedBasis] labelStopAllSyncingNow]] ;
    [alert setButton1Title:@"Kill"] ;
    [alert setButton2Title:[[BkmxBasis sharedBasis] labelCancel]] ;
    [alert setRightColumnMinimumWidth:350] ;  // So the docsList doesn't wrap
    [alert runModalDialog] ;
    NSInteger alertReturn = [alert alertReturn] ;
    if (alertReturn == NSAlertFirstButtonReturn) {
        // Remove all Syncers in any document
        [[BkmxBasis sharedBasis] logFormat:@"User clicked \"Stop all Syncing\""] ;
        [self stopAllSyncingForApps:BkmxWhichAppsAny];
    }
}

- (void)realizeSyncersOfAllDocumentsToWatchesThenDo:(void (^)(void))thenDo {
    NSAssert(![[BkmxBasis sharedBasis] isBkmxAgent], @"Agent tried to sync syncers");
    NSError* error = nil;
    NSSet* documents = [self uuidsOfDocsWithSyncersError_p:&error];
    NSInteger __block countdown = documents.count;
    if (documents.count > 0) {
        for (NSString* uuid in documents) {
            BkmxDocumentController* dc = [NSDocumentController sharedDocumentController];
            [dc openDocumentWithUuid:uuid
                             appName:[[BkmxBasis sharedBasis] appNameUnlocalized]
                             display:NO
                      aliaserTimeout:24.065
                   completionHandler:^(
                                       BkmxDoc* bkmxDoc,
                                       NSURL* resolvedUrl,
                                       BOOL documentWasAlreadyOpen,
                                       NSError* error) {
                       [bkmxDoc realizeSyncersToWatchesError_p:&error];
                       if (!documentWasAlreadyOpen) {
                           [bkmxDoc close] ;
                       }
                       @synchronized(documents) {
                           countdown--;
                           if (countdown == 0) {
                               if (thenDo) {
                                   thenDo();
                               }
                           }
                       }
                   }];
        }
    } else {
        if (thenDo) {
            thenDo();
        }
    }
}

/*!
 @brief    Returns the full path to the syncing status reports subdirectory,
 creating one if it does not exist, and removing the oldest files to make
 room for one more while staying under the limit.
 */
- (NSString*)prepareSyncingStatusReportsPath {
    NSFileManager* fm = [NSFileManager defaultManager] ;
    NSError* error = nil ;
    BOOL ok ;

    NSString* path =  [[[NSBundle mainBundle] applicationSupportPathForMotherApp] stringByAppendingPathComponent:@"SyncingStatusReports"];
    ok = [fm ensureDirectoryAtPath:path
                           error_p:&error] ;
    if (!ok) {
        NSLog(@"Internal Error 513-9924 %@", error) ;
    }

    NSArray* filenames = [fm contentsOfDirectoryAtPath:path
                                                 error:&error] ;
    if (error) {
        NSLog(@"Internal Error 624-2633 %@", error) ;
    }

    NSInteger const nAllowed = 9 ;
    NSInteger nExisting = (NSInteger)[filenames count];
    NSInteger nToRemove = nExisting - nAllowed;
    if (nToRemove > nExisting) {
        nToRemove = nExisting;
    }
    if (nToRemove > 0) {
        // Remove some files
        NSMutableArray* sortedNames = [filenames mutableCopy] ;
        [sortedNames sortUsingSelector:@selector(compare:)] ;
        NSRange rangeToRemove = NSMakeRange(0, nToRemove) ;
        NSArray* namesToRemove = [sortedNames subarrayWithRange:rangeToRemove] ;
        for (NSString* filename in namesToRemove) {
            NSString* fullPath = [path stringByAppendingPathComponent:filename] ;

            NSError* error = nil ;
            [[NSFileManager defaultManager] removeItemAtPath:fullPath
                                                       error:&error] ;
            if (error) {
                NSLog(@"Internal Error 844-8320 %@", error) ;
            }
        }
        [sortedNames release] ;
    }

    return path ;
}

- (void)writeSyncingStatusReportToFileThenDo:(void (^)(void))thenDo {
    [self getSyncingStatusThenDo:^(NSString* report) {
        NSString* path = [self prepareSyncingStatusReportsPath];
        NSString* filename = [[NSString alloc] initWithFormat:
                              @"SSR-%@.txt",
                              [[NSDate date] compactDateTimeString]];
        path = [path stringByAppendingPathComponent:filename];
        [filename release];
        NSData* data = [report dataUsingEncoding:NSUTF8StringEncoding];
        [data writeToFile:path
               atomically:YES];
        thenDo();
    }];
}

- (void)finishStopAllSyncing {
    /* If syncers were indeed removed from the Macster by the caller,
     then -{Macster macsterBusinessNote:] should call
     -[BkmxDoc realizeSyncersToWatchesError_p:] which will
     also remove watches from user defaults.  However, if due
     to some error, we started out with no syncers but did have
     (orphaned) watches, that method might not run.  So, to
     be sure, we now explicitly remove the watches. */
    [[NSUserDefaults standardUserDefaults] removeAllWatchesExceptDocUuid:nil];

    /* Removing all Syncers should have cause the BkmxAgent service to
     be terminated, but just in case that did not work, we do it again: */
    NSError* error = nil;
    NSDictionary* result = [[BkmxBasis sharedBasis] kickBkmxAgentWithKickType:KickType_Stop
                                                 error:&error];
    NSNumber* returnValueNumber = [result objectForKey:constKeyReturnValue];
    NSString* msg = nil;
    if ([returnValueNumber respondsToSelector:@selector(integerValue)]) {
        NSInteger returnValue = [returnValueNumber integerValue];
        if (returnValue == 0) {
            msg = @"All Syncers of Smarky, Synkmark or BookMacster have been removed, and the BkmxAgent process has been quit." ;
        } else {
            error = [SSYMakeError(285791, @"Agent runner failed") errorByAddingUnderlyingError:error];
        }
    } else {
        error = [SSYMakeError(285792, @"Agent runner failed bad") errorByAddingUnderlyingError:error];
    }

    if (msg) {
        [SSYAlert runModalDialogTitle:nil
                              message:msg
                              buttons:nil];
    }
    
    [SSYAlert alertError:error];
}

- (void)showSyncingStatus {
    [self getSyncingStatusThenDo:^(NSString* report) {
        [self performSelectorOnMainThread:@selector(displaySyncStatusReport:)
                               withObject:report
                            waitUntilDone:NO];
    }];
}

- (void)getSyncingStatusThenDo:(void (^)(NSString*))thenDo {
    NSArray* jobQueue = [self jobQueue];
    if (jobQueue) {
        // queuedJobs is fresh enough
        [self getSyncingStatusWithJobsQueue:jobQueue
                                      error:nil
                                     thenDo:thenDo];
    } else {
        // queuedJobs is stale
        [self updateJobsQueueThenDo:^(NSArray<Job*>* jobsQueue, NSError* error) {
            [self getSyncingStatusWithJobsQueue:jobsQueue
                                          error:error
                                         thenDo:thenDo];
        }];
    }
}

- (void)getSyncingStatusWithJobsQueue:(NSArray<Job*>*)jobsQueue
                                error:(NSError*)errorIn
                               thenDo:(void (^)(NSString*))thenDo {
    // If agent is not running, jobs will be nil.  That is OK.
    
    [self getWatchesReportThen:^(NSString* watchesReport) {
        NSMutableString* report = [NSMutableString new];

        if (errorIn) {
            [report appendFormat:
             NSLocalizedString(@"Error %ld occurred: %@", nil),
             errorIn.code,
             errorIn.localizedDescription];
            [report appendString:@"\n\n"];
        }

        [report appendString:[ExtoreSafari fullDiskAccessReport]];
        [report appendString:@"\n"];

        [report appendString:[[BkmxBasis sharedBasis] bkmxAgentRegistrationStatusReport]];
        [report appendString:@"\n\n"];
        
        [report appendString:[[BkmxBasis sharedBasis] runningAgentDescription]];
        [report appendString:@"\n\n"];

        NSArray* allBkmxAgentPids = [SSYOtherApper pidsOfMyRunningExecutablesName:constAppNameBkmxAgent
                                                                          zombies:YES
                                                                       exactMatch:NO];
        [report appendFormat:@"Process Identifiers of all running BkmxAgent executables: %@\n\n", allBkmxAgentPids];

        [report appendString:watchesReport];
        [report appendString:@"\n"];

        [report appendString:NSLocalizedString(@"Watches for all of our apps:\n", nil)];
        [report appendString:@"\n"];

        [report appendString:@"1.  "];
        [self appendWatchesForApp:BkmxWhichAppsBookMacster
                         toReport:report];
        [report appendString:@"2.  "];
        [self appendWatchesForApp:BkmxWhichAppsSynkmark
                         toReport:report];
        [report appendString:@"3.  "];
        [self appendWatchesForApp:BkmxWhichAppsSmarky
                         toReport:report];

        [report appendFormat:NSLocalizedString(@"Staged Jobs", nil)];
        [report appendString:@":\n\n"];

        NSArray<Job*>* jobs = [[NSUserDefaults standardUserDefaults] stagedJobsForApps:BkmxWhichAppsMain];
        if (jobs.count > 0) {
            for (Job* job in jobs) {
                [report appendFormat:@"%@\n", job.description];
            }
        } else {
            [report appendString:NSLocalizedString(@"[None]", nil)];
            [report appendString:@"\n"];
        }
        [report appendString:@"\n"];

        [report appendFormat:
         @"%@: %@\n\n",
         NSLocalizedString(@"Queued or Running Jobs", nil),
         jobsQueue];

        NSString* reportCopy = [report copy];

        if (thenDo) {
            thenDo(reportCopy);
        }

        [report release];
        [reportCopy release];
    }];
}

- (void)appendWatchesForApp:(BkmxWhichApps)whichApp
                   toReport:(NSMutableString*)report {
    NSString* appName = [[BkmxBasis sharedBasis] appNameForApps:whichApp];
    [report appendFormat:@"Watches for %@:  ", appName];
    NSArray* watches = [[NSUserDefaults standardUserDefaults] humanSortedWatchesForApps:whichApp];
    [report appendString:[watches description]];
    [report appendString:@"\n\n"];
}

- (void)displaySyncStatusReport:(NSString*)report {
    SSYAlert* alert = [SSYAlert alert];
    [alert setTitleText:NSLocalizedString(@"Syncing Status Report",nil)];
    [alert setSmallText:report];
    [alert setButton1Title:NSLocalizedString(@"Done", nil)];
    [alert setButton2Title:NSLocalizedString(@"Copy to Clipboard", nil)];
    [alert setClickTarget:self] ;
    [alert setClickSelector:@selector(handleClickWithClipboardButtonAlert:)];
    [alert setRightColumnMinimumWidth:750.0];
    [alert doooLayout];
    [alert setDontGoAwayUponButtonClicked:YES];
    [alert display];
}

- (void)handleClickWithClipboardButtonAlert:(SSYAlert*)alert {
    if ([alert alertReturn] == NSAlertFirstButtonReturn) {
        [alert goAway];
    }
    else if ([alert alertReturn] == NSAlertSecondButtonReturn) {
        NSMutableString* clip = [NSMutableString new];
        [clip appendString:@"# "];
        [clip appendString:[alert titleText]];
        [clip appendString:@"\n\n"];
        [clip appendString:[alert smallText]];
        [clip appendString:@"\n"];

        [clip copyToClipboard];
        [clip release];
    }
}

/* Help Anchors are broken in macOS 10.14, at least, as they are formed
 in my app's Help Book.  Until I get a workaround that works, I
 implement in my app delegate displayHelpBookAnchor: which displays
 the given help anchor in the Help Book on my web page.  It is called from
 SSYAlert when user clicks a Help button.

 Important: This method is also called from SSYAlert, via
 NSSelectorFromString().
 */
- (void)displayHelpBookAnchor:(NSString*)anchor {
    NSURL* url = [NSURL URLWithString:@"http://sheepsystems.com/bookmacster/HelpBook"];
    url = [url URLByAppendingPathComponent:anchor];
    void (^wrappedCompletionHandler)(NSRunningApplication*, NSError*) = ^void (NSRunningApplication *app, NSError *error) {
    };
    CFErrorRef error = nil;
    NSURL* exampleUrl = [NSURL URLWithString:@"https://example.com"];
    CFURLRef defaultWebBrowserUrl = LSCopyDefaultApplicationURLForURL((__bridge CFURLRef)exampleUrl,
                                                                      kLSRolesViewer,
                                                                      &error
                                                                      );
    [[NSWorkspace sharedWorkspace] openURLs:@[url]
                       withApplicationAtURL:(__bridge NSURL*)defaultWebBrowserUrl
                              configuration:[NSWorkspaceOpenConfiguration configuration]
                          completionHandler:wrappedCompletionHandler];
}


@end



#if 0
// Mouse Manipulation Demo

// Get the mouse location
CGEventRef ourEvent = CGEventCreate(NULL) ;
CGPoint mouseLoc = CGEventGetLocation(ourEvent) ;
NSLog(@"Mouse location: %f %f", mouseLoc.x, mouseLoc.y);
// You can also get the mouse location using Cocoa:
// 	  NSPoint mouseLoc = [NSEvent mouseLocation];
// However in this case the y-coordinate is flipped

// Stuff needed to click the menu
CGMouseButton button = kCGMouseButtonLeft ;
CGEventType type ;
CGPoint point ;
point.x = 1060 ;
point.y = 20 ;
CGEventRef theEvent ;

// Left mouse down on menu
type = kCGEventLeftMouseDown ;
theEvent = CGEventCreateMouseEvent(NULL, type, point, button);
CGEventSetType(theEvent, type);
CGEventPost(kCGHIDEventTap, theEvent);
CFRelease(theEvent);

sleep(0.1) ;

// Left mouse up
type = kCGEventLeftMouseUp ;
theEvent = CGEventCreateMouseEvent(NULL, type, point, button);
CGEventSetType(theEvent, type);
CGEventPost(kCGHIDEventTap, theEvent);
CFRelease(theEvent);

sleep(0.1) ;

// Return mouse to original location
type = kCGEventMouseMoved ;
point.x = mouseLoc.x ;
point.y = mouseLoc.y ;
theEvent = CGEventCreateMouseEvent(NULL, type, point, button);
CGEventSetType(theEvent, type);
CGEventPost(kCGHIDEventTap, theEvent);
CFRelease(theEvent);

#endif

/*
 Note TPTWorkaround
 
 From:  https://devforums.apple.com/thread/203753  2013-09-09   BookMacster 1.18
 
 I am happy to see that a 5-years longstanding bug in TransformProcessType(),
 noted by Mike Ash, and earlier by others, has been fixed!
 
 (The bug was that after invoking TransformProcessType to bring a process from
 the background to the foreground, the foregrounded app would not get the menu
 bar until after a different app was activated and then the foregrounded app was
 activated by the user clicking it in the Dock or doing ⌘-tab.  Trying to do
 these activations programatically, as a workaround, experimenting with delays,
 etc., resulted only in hours of frustration.)
 
 But, in my case, it requires a code change to do this during app launching.
 
 My app has a user preference to Launch in Background.  The way it works is
 straightforward: I set LSUIElement to "1" in the Info.plist, then during
 launch, check the user's preference, and if user wants it in the foreground,
 TransformProcessType() to foreground type.  Prior to Mavericks, this needed
 to be done early, in the app delegate's -init, or it wouldn't work.  Now,
 it needs to be done later, in -applicationDidFinishLaunching.  A table …
 
 * macOS     -init[1]    -aDFL[2]       Result
 * ----     ------      --------       ------
 *             -           TPT         FAIL
 * 10.8-      TPT           -          PASS  <-- Do this
 *            TPT          TPT         PASS
 ----       ------      --------       ------
 *             -           TPT         PASS  <-- Do this
 * 10.9       TPT           -          FAIL
 *            TPT          TPT         FAIL
 
 where
 
 10.8- means macOS 10.8 and earlier
 TPT under -init[1] means: Invoke TransformProcessType in -[AppDelegate init].
 TPT under -adfl[2] means: Invoke TransformProcessType in -[AppDelegate applicationDidFinishLaunching].
 PASS means that the app's menu appears in the main menu bar immediately after activating.
 FAIL means the opposite.
 
 As you can see, there is no combination of [1] and [2] which works for both
 10.9 and earlier systems, so I've had to work around this by – hold your nose
 – testing for (NSAppKitVersion >= 1200) and invoking TransformProcessType()
 in the appropriate method to get PASS.
 
 Although there is nothing in the documentation of TransformProcessType() which
 mentions that it doesn't work at some times, I can certainly understand how the
 "process type" would be ill-defined during app launch, causing unexpected
 behavior.  I have reproduced the behavior in a small demo project, but my
 inclination is to not file a bug – Because it took 5 years to get this fixed,
 I'm worried that if it gets touched again it might get re-broken in a different
 way which is not amenable to workaround.
 
 If anyone wants my demo project, ask me for TransformProcessDemo and I'll post
 it on GitHub for you.
 
 Further tests, after fixing, in 10.9…
 
 PASS  Doubleclick in Finder
 PASS  Put in Dock and click
 PASS  AppleScript "Launch Application"
 PASS  Launch using the open(1) command in Terminal.app
 PASS  Launch using the LaunchBar app launcher
 FAIL  Launch using the Alfred app launcher
 
 UPDATE: In 10.11, it appears that the dance is only invoked when the app is
 launched in Xcode
 
*/

/* Note OpeningSystemPreferencePanes
 
 macOS Preference Panes are opened by their URL.  To get the URL for a
 specific preference pane,
 
 • View thet contents of /System/Library/PreferencePanes
 • Find the Preference Pane you wish to open and view the contents of its package.
 • Open its Contents/Info.plist.
 • Read the value of CFBundleIdentifier and call this <bundleID>
 • The URL for that pane is: x-apple.systempreferences:<bundleID>
 • If you want to get the URL for a specific tab, or a specific tab and
 source list item, you must add a query string, and the only way I have
 found to determine the magic query string is to either make a good guess,
 or find where other developers have published the answers.  Example URLs:
 
 For Security & Privacy > Privacy > Camera:
 x-apple.systempreferences:com.apple.preference.security?Privacy_Camera
 
 For Security & Privacy > Privacy > Full Disk Access:
 x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles
 
 Resources where I found these:
 
 https://github.com/MacPaw/PermissionsKit/tree/master/PermissionsKit/Private
 https://stackoverflow.com/questions/6652598/cocoa-button-opens-a-system-preference-page
*/
