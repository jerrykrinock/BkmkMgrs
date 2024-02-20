#import "ExtensionsVersionChecker.h"
#import "ExtensionsWinCon.h"
#import "BkmxBasis+Strings.h"
#import "NSString+LocalizeSSY.h"
#import "Chromessengerer.h"
#import "ExtoreChromy.h"
#import "SSYAppInfo.h"
#import "SSYVersionTriplet+BkmxLegacyEffectivness.h"
#import "Clientoid.h"
#import "SSYAlert.h"

@implementation ExtensionsVersionChecker

+ (void)checkInstalledExtensionVersions {
    if ([[BkmxBasis sharedBasis] iAm] != BkmxWhich1AppSmarky) {
        NSDictionary* results ;
        [Extore addonableExtores_p:NULL
                         results_p:&results] ;
        
        NSString* warning = nil ;
        NSInteger iconStyle = SSYAlertIconNoIcon ;
        for (NSString* clidentifier in [results allKeys]) {
            NSDictionary* result = [results objectForKey:clidentifier] ;
            NSError* error = [result objectForKey:constKeyError] ;
            NSInteger errorCode = [error code] ;
            // Note that we do not care if addons are not found, i.e.
            // EXTORE_ERROR_CODE_MASK_EXTENSION1_NOT_FOUND
            // or EXTORE_ERROR_CODE_MASK_EXTENSION2_NOT_FOUND.
            // This is because the user may not have a need for them.
            // We're only interested in DOWNREV errors.

            /* The following, added on 20160614, is because the Button
             is not useful in Synkmark and more importantly old versions of it
             can interfere with the necessary *Sync* extension. */
            if (
                ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppSynkmark)
                &&
                ((errorCode & EXTORE_ERROR_CODE_MASK_EXTENSION2_DOWNREV) > 0)
                ) {
                Clientoid* clientoid = [Clientoid clientoidWithClidentifier:clidentifier] ;
                NSString* format = NSLocalizedString(@"Please activate %@, and in its Add-Ons or Extensions window, remove any \"%@\" extension.  It is old, not useful and may cause trouble.\n\nDo not remove the \"Sync\" Extension.", nil) ;
                warning = [NSString stringWithFormat:
                           format,
                           clientoid.displayName,
                           @"BookMacster Button"
                           ] ;
                iconStyle = SSYAlertIconCritical ;
            }
            else if (
                ((errorCode & EXTORE_ERROR_CODE_MASK_EXTENSION1_DOWNREV) > 0)
                ||
                ((errorCode & EXTORE_ERROR_CODE_MASK_EXTENSION2_DOWNREV) > 0)
                ) {
                warning = [NSString localizeFormat:
                           @"browserExtensionsDownrevX",
                           [[BkmxBasis sharedBasis] appNameLocalized]] ;
                iconStyle = SSYAlertIconInformational ;
                break ;
            }
        }

        if (warning) {
            ExtensionsWinCon* addonsWinCon = [ExtensionsWinCon showWindow] ;
            SSYAlert* alert = [SSYAlert alert] ;
            [alert setIconStyle:iconStyle] ;
            [alert setSmallText:warning] ;
            [alert setButton1Title:[[BkmxBasis sharedBasis] labelOk]] ;
            [alert doooLayout] ;
            [alert runModalSheetOnWindow:[addonsWinCon window]
                              resizeable:NO
                           modalDelegate:nil
                          didEndSelector:NULL
                             contextInfo:NULL] ;
        }
    }
}

@end
