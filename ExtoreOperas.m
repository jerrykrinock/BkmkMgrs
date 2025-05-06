#import "ExtoreOperas.h"
#import "StarkTyper.h"
#import "BkmxGlobals.h"
#import "BkmxBasis.h"
#import "Chromessengerer.h"
#import "Client.h"
#import "ExtoreChrome.h"
#import "NSString+MorePaths.h"
#import "BkmxDoc.h"
#import "NSError+MyDomain.h"
#import "SSYMH.AppAnchors.h"
#import "NSString+SSYExtraUtils.h"


@implementation ExtoreOperas

+ (NSString*)extraBrowserSupportPathForSpecialManifest {
    return [[[NSString applicationSupportPathForHomePath:nil] stringByAppendingPathComponent:@"Google"]  stringByAppendingPathComponent:@"Chrome"];
}

+ (PathRelativeTo)fileParentPathRelativeTo {
    return PathRelativeToProfile;
}

+ (NSString*)extension1Uuid {
    /* For version packaged by Opera Web Store */
    return @"gjaglmjolgdmflpgoamdaopepgnbpjjk" ;
}

+ (NSString*)extension2Uuid {
    /* For version packaged by Opera Web Store */
    return @"aejkhhhjkgghcikooddepdphflcaodca" ;
}

+ (NSURL*)sourceUrlForExtensionIndex:(NSInteger)extensionIndex {
    NSURL* url ;
    switch (extensionIndex) {
        case 1:
            url = [NSURL URLWithString:@"https://addons.opera.com/en/extensions/details/bookmacster-sync/"] ;
            break ;
        case 2:
            url = [NSURL URLWithString:@"https://addons.opera.com/en/extensions/details/bookmacster-button/"] ;
            break ;
        default:
            url = nil ;
    }
    
    return url ;
}

- (NSString*)ownerAppSyncServiceDisplayName {
    return @"Opera Account" ;
}

/*
 The nonexistent AppleScript support in Opera does not understand the command
 'close windows'.
 */
- (BOOL)shouldCloseWindowsWhenQuitting {
    return NO ;
}

+ (BOOL)syncExtensionAvailable {
    return ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppBookMacster)
    || ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppSynkmark)
    || ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppMarkster);
}

+ (BOOL)style1Available {
    /* Support for Style 1 was removed from Opera in BkmkMgrs 2.5,3 after
     I discovered that, starting with Opera 48, there is apparently some
     "salt" or other additional encoding in the Bookmarks file's checksum.
     I reproduced two files (with 0 soft items) one saved by Opera 47 and one
     saved by Opera 48, which were identical except for different checksums. */
    return NO;
}

+ (BOOL)profileStuffMayBeInstalledInParentFolder {
    /* When Opera started supporting profiles in 103 or 104 (Oct 2023), it moved
     all of the profile stuff into a profile subfolder.  If someone is running
     a version of Opera older than 103 or 104, the profile stuff might still be
     in the old location, which is the parent of that profile folder. */
    return YES;
}

+ (BOOL)supportsMultipleProfiles {
    return YES;
}

- (BOOL)style1Available {
    return [[self class] style1Available];
}

- (BkmxIxportLaunchBrowserPreference)launchBrowserPreference {
    return BkmxIxportLaunchBrowserPreferenceAlways;
}

- (void)followUpExtensionInstallWithInfo:(NSMutableDictionary *)info {
}

- (void)prepareBrowserForIxportWithInfo:(NSMutableDictionary*)info {
    if (![self extension1Installed]) {
        BkmxDoc* bkmxDoc = [info objectForKey:constKeyDocument];
        NSString* prompt = [[NSString alloc] initWithFormat:
                            @"Please install our BookMacster Sync extension into %@, then return here.",
                            [[self clientoid] displayName]];
        [bkmxDoc requestUserInstallExtensionWithPrompt:prompt
                                     completionHandler:^void(NSModalResponse modalResponse) {
                                         NSError* error = nil;
                                         if (modalResponse == NSAlertFirstButtonReturn) {
                                             SSYAlert* alert = [SSYAlert alert] ;
                                             [alert setIconStyle:SSYAlertIconInformational] ;
                                             [alert setTitleText:@"Browser Extension Needed"] ;
                                             [alert setSmallText:@"Click 'Done' after you have installed and tested the BookMacster Sync extension in Opera."] ;
                                             [alert setButton1Title:@"Done"] ;
                                             [alert setButton2Title:@"Cancel"] ;
                                             [alert setHelpAddress:constHelpAnchorAccessLocalApp];
                                             [alert doooLayout] ;
                                             [bkmxDoc runModalSheetAlert:alert
                                                              resizeable:NO
                                                               iconStyle:SSYAlertIconInformational
                                                       completionHandler:^void(NSModalResponse modalResponse) {
                                                           NSError* error =  nil;
                                                           if (modalResponse == NSAlertFirstButtonReturn) {
                                                               if (![self extension1Installed]) {
                                                                   NSString* desc = [[NSString alloc] initWithFormat:
                                                                                     @"Cannot import or export with %@ because the BookMacster Sync extension is not installed into  %@.",
                                                                                     [[self clientoid] displayName],
                                                                                     [[self clientoid] displayName]
                                                                                     ];
                                                                   error = SSYMakeError(473894, desc);
                                                                   [desc release];
                                                                   self.error = error;
                                                               }
                                                           } else {
                                                               error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                                                           code:NSUserCancelledError
                                                                                       userInfo:nil];
                                                               self.error = error;
                                                           }

                                                           BOOL ok = !error;

                                                           [info setObject:[NSNumber numberWithBool:ok]
                                                                    forKey:constKeySucceeded] ;
                                                           [self sendIsDoneMessageFromInfo:info];
                                                       }];
                                         } else {
                                             error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                                         code:NSUserCancelledError
                                                                     userInfo:nil];
                                             self.error = error;
                                             [info setObject:@NO
                                                      forKey:constKeySucceeded] ;
                                             [self sendIsDoneMessageFromInfo:info];
                                         }
                                     }];
        [prompt release];
    } else {
        [info setObject:@YES
                 forKey:constKeySucceeded] ;
        [self sendIsDoneMessageFromInfo:info] ;
    }
}

- (void)prepareBrowserForImportWithInfo:(NSMutableDictionary*)info {
    [self prepareBrowserForIxportWithInfo:info];
}

- (void)prepareBrowserForExportWithInfo:(NSMutableDictionary*)info {
    [self prepareBrowserForIxportWithInfo:info];
}

- (NSString*)messageHowToForceAutoUpdateExtensionIndex:(NSInteger)extensionIndex {
    return NSLocalizedString(
                             @"• Click in the main menu > View > Show Extensions."
                             @"\n• If there is a button titled ‘Developer Mode’, click it.  If there is a button titled ‘Exit Developer Mode’, just do next step."
                             @"\n• Click the button titled ‘Update Extensions now’."
                             @"\n• Verify that our updated extension is *enabled*.", nil);
}

- (NSString*)uninstallInstructionsForExtensionIndex:(NSInteger)extensionIndex {
    NSString* answer = [NSString stringWithFormat:
                        @"To uninstall the %@ extension:\n\n"
                        @"• Run %@.\n\n"
                        @"• Click in the menu: Window > Extensions.  A tab with a list of extensions will appear.\n\n"
                        @"• Mouse over the '%@' section.  Notice the  which appears.\n\n"
                        @"• Click that \"X\" and affirm the removal.\n\n"
                        @"• If you want the extension to be fully removed immediately, you must quit and then relaunch %@.",
                        [self extensionDisplayNameForExtensionIndex:extensionIndex],
                        [self ownerAppDisplayName],
                        [self extensionDisplayNameForExtensionIndex:extensionIndex],
                        [self ownerAppDisplayName]];

    return answer;
}


@end
