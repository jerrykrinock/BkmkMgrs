#import "Firefox53Upgrader.h"
#import "Syncer.h"
#import "Trigger.h"
#import "Macster.h"
#import "Client.h"
#import "BkmxBasis+Strings.h"
#import "ExtoreFirefox.h"
#import "BkmxDocumentController.h"
#import "NSArray+Stringing.h"
#import "Clientoid.h"
#import "ExtensionsWinCon.h"
#import "SSYAlert.h"
#import "SSWebBrowsing.h"
#import "BkmxAppDel.h"
#import "Watch.h"
#import "NSUserDefaults+Bkmx.h"

static NSMutableArray* static_alertQueue = nil;

@implementation Firefox53Upgrader

+ (SSYAlert*)upgradeAnyLegacyTriggers {
    SSYAlert* alert = nil;
    NSSet* watches = [[NSUserDefaults standardUserDefaults] watchesThisApp] ;

    NSMutableSet* documentNamesWithAdvancedSyncersWatchingFirefox = [NSMutableSet new];
    NSMutableSet* documentNamesWithSimpleAgentsWatchingFirefoxThatWereFixed = [NSMutableSet new];
    for (Watch* watch in watches) {
        NSString* docUuid = watch.docUuid;
        Macster* macster = [[BkmxBasis sharedBasis] macsterWithDocUuid:docUuid
                                                          createIfNone:NO] ;
        NSString* mayNeedSimpleFixDocumentName = nil;
        for (Syncer* syncer in [macster syncers]) {
            for (Trigger* trigger in [syncer triggers]) {
                Client* client = trigger.client;
                if ([[client clientoid] extoreClass] == [ExtoreFirefox class]) {
                    NSString* path = [(BkmxDocumentController*)[NSDocumentController sharedDocumentController] pathOfDocumentWithUuid:docUuid
                                                                                                                              appName:[[BkmxBasis sharedBasis] appNameUnlocalized]
                                                                                                                              timeout:3.0
                                                                                                                               trials:2
                                                                                                                                delay:0.0
                                                                                                                              error_p:NULL];
                    if (path) {
                        NSString* docName = [path lastPathComponent];
                        if ([macster syncerConfigValue] == constBkmxSyncerConfigIsAdvanced) {
                            [documentNamesWithAdvancedSyncersWatchingFirefox addObject:docName];
                        } else {
                            mayNeedSimpleFixDocumentName = docName;
                            break;
                        }
                    }
                }
            }

            if (mayNeedSimpleFixDocumentName) {
                break;
            }
        }
        if (mayNeedSimpleFixDocumentName) {
            BOOL didFix = [macster fixTriggersIfSimpleSyncers];
            if (didFix) {
                [documentNamesWithSimpleAgentsWatchingFirefoxThatWereFixed addObject:mayNeedSimpleFixDocumentName];
            }
        }
    }
    if ((documentNamesWithSimpleAgentsWatchingFirefoxThatWereFixed.count > 0) || (documentNamesWithAdvancedSyncersWatchingFirefox.count > 0)) {
        alert = [SSYAlert alert];
        NSMutableString* msg = [NSMutableString new];
        [msg appendString:@"Due to changes in Firefox 53, particularly if you use Separators, Tags, Keywords (shortcuts), Descriptions (Comments) or Live Bookmarks," ];
        if (documentNamesWithSimpleAgentsWatchingFirefoxThatWereFixed.count > 0) {
            [msg appendFormat:@"\n\n• You may notice some differences in syncing behavior"];
            if ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppBookMacster) {
                [msg appendFormat:@" in these documents: %@.", [documentNamesWithSimpleAgentsWatchingFirefoxThatWereFixed.allObjects listNames]];
            }
            else {
                [msg appendString:@"."];
            }
        }
        if (documentNamesWithAdvancedSyncersWatchingFirefox.count > 0) {
            [msg appendFormat:@"\n\n• You may want to add a 'Browser Quit – Firefox' trigger to the Advanced Syncers you have configured in documents: %@",
             [documentNamesWithAdvancedSyncersWatchingFirefox.allObjects listNames]];
        }
        [msg appendString:@"\n\nA support article on our website has more information.  If you'd like to read that now, click 'More Info…'."];

        [alert setSmallText:msg];
        [msg release];
        [alert setButton1Title:@"Done"];
        [alert setButton2Title:@"More Info…"];
        [alert setIconStyle:SSYAlertIconInformational];

        [alert setClickObject:@"https://sheepsystems.com/files/support_articles/bkmx/firefox53.html"];
    }

    [documentNamesWithAdvancedSyncersWatchingFirefox release];
    [documentNamesWithSimpleAgentsWatchingFirefoxThatWereFixed release];

    return alert;
}

+ (SSYAlert*)upgradeAnyLegacyExtensions {
    SSYAlert* alert = nil;
    NSMutableArray* clientoids = [[NSMutableArray alloc] init] ;

    // Some utility variables
    Clientoid* clientoid ;
    NSString* profileName ;

    NSArray* profileNames = [[ExtoreFirefox class] profileNames] ;
    if ([profileNames count] == 0) {
        profileNames = [NSArray arrayWithObject:[[ExtoreFirefox class] constants_p]->defaultProfileName] ;
    }
    NSArray* oldExtensionFilenames = @[
                                       @"syncextension@sheepsystems.com",   // old
                                       @"menuextension@sheepsystems.com",   // old
                                       @"firefoxextension@sheepsystems.com" // older
                                       ];
    NSMutableArray* successes = [NSMutableArray new];
    NSMutableArray* failures = [NSMutableArray new];
    NSMutableSet* affectedProfiles = [NSMutableSet new];
    for (profileName in profileNames) {
        clientoid = [Clientoid clientoidThisUserWithExformat:constExformatFirefox
                                                 profileName:profileName] ;
        [clientoids addObject:clientoid] ;
        NSString* extensionsDir = [[clientoid filePathParentError_p:NULL] stringByAppendingPathComponent:@"extensions"];
        NSInteger i = 1;
        for (NSString* filename in oldExtensionFilenames) {
            NSString* path = [extensionsDir stringByAppendingPathComponent:filename];
            BOOL didRemove = [[NSFileManager defaultManager] removeItemAtPath:path
                                                                        error:NULL];
#if 0
#warning Faking Firefox 53
            didRemove = YES;
#endif
            if (didRemove) {
                NSInteger extensionIndex;
                NSString* extensionShortName;
                NSString* destinName;
                switch (i) {
                    case 1:  // @"syncextension@sheepsystems.com"
                    case 3:  // @"firefoxextension@sheepsystems.com"
                        /* In case 3, we don't know if the user needs the Sync
                         extensionIndex=1, the Button extensionIndex=2, or
                         both, but for 90% of users the answer is probably the
                         Sync extensionIndex=1.  So we go with that. */
                    default:
                        extensionIndex = 1;
                        extensionShortName = @"Sync";
                        destinName = [[ExtoreFirefox class] extension1Uuid];
                        break;
                    case 2:  // i==2 --> @"menuextension@sheepsystems.com"
                        extensionIndex = 2;
                        extensionShortName = @"Button";
                        destinName = [[ExtoreFirefox class] extension2Uuid];
                        break;
                }

                NSURL* url = [[ExtoreFirefox class] sourceUrlForExtensionIndex:extensionIndex];
                NSString* sourcePath = [url path];
                NSString* destinPath = [extensionsDir stringByAppendingPathComponent:destinName];
                destinPath = [destinPath stringByAppendingPathExtension:constExtensionFilenameExtension];
                // Example: /Users/jk/Library/Application Support/Firefox/Profiles/r99d1moz.default/extensions/{5be4a1a1-c477-423d-a946-13c1d880306f}.xpi
                /* Remove in case there is already a file there.  This is
                 mostly for testing, although it might have a value? */
                [[NSFileManager defaultManager] removeItemAtPath:destinPath
                                                           error:NULL];
                /* destinPath will be nil if [clientoid filePathParentError_p:NULL]
                 returned nil.  That's a problem, but it is elsewhere.  So
                 we check for nil here to avoid raising an unrelated and
                 confusing exception here. */
                if (destinPath) {
                    BOOL ok = [[NSFileManager defaultManager] copyItemAtPath:sourcePath
                                                                      toPath:destinPath
                                                                       error:NULL];
                    NSString* readable = [NSString stringWithFormat:
                                          @"%@ Extension in Firefox profile '%@'",
                                          extensionShortName,
                                          profileName];
                    if (ok) {
                        [successes addObject:readable];
                        [affectedProfiles addObject:profileName];
                    } else {
                        [failures addObject:readable] ;
                    }
                }
            }

            i++;
        }
    }

    [clientoids release];

    if (failures.count > 0) {
        NSString* msg = [NSString stringWithFormat:
                         @"%ld errors occurred when attempting to automatically upgrade your Firefox extensions.  "
                         @"Please retry to 'Install' the following:\n\n%@",
                         failures.count,
                         failures];
        ExtensionsWinCon* addonsWinCon = [ExtensionsWinCon showWindow] ;
        alert = [SSYAlert alert] ;
        [alert setIconStyle:SSYAlertIconWarning] ;
        [alert setSmallText:msg] ;
        [alert setButton1Title:[[BkmxBasis sharedBasis] labelOk]] ;
        [alert doooLayout] ;
        [alert runModalSheetOnWindow:[addonsWinCon window]
                          resizeable:NO
                       modalDelegate:nil
                      didEndSelector:NULL
                         contextInfo:NULL] ;
    } else if (successes.count > 0) {
        NSString* msg1 = [NSString stringWithFormat:
                          @"%ld obsolete Firefox extension(s) have been removed and replaced with upgrades.  "
                          @"Please do this to complete the installation:"
                          @"\n\n• Quit Firefox if it is running.",
                          successes.count];
        NSString* msg2;
        if ([[ExtoreFirefox class] profileNames].count == 1) {
            // 1 profile existing, 1 profile affected
            msg2 = @"\n• Launch Firefox.";
        } else if (affectedProfiles.count == 1) {
            // Multiple profiles existing, 1 profile affected
            msg2 = [NSString stringWithFormat:
                    @"\n• Launch Firefox into profile '%@'.",
                    affectedProfiles.anyObject];
        } else {
            // Multiple profiles existing, multiple profiles affected
            msg2 = [NSString stringWithFormat:
                    @"\n• Relaunching Firefox into each of the profiles (%@) in turn…\n",
                    [[affectedProfiles allObjects] listValuesForKey:nil conjunction:nil truncateTo:0]];
        }
        NSString* msg3 =
        @"\n• Read the notice which appears, 'Another program…'."
        @"\n• !!! Switch on checkbox 'Allow this installation' !!!"
        @"\n• Click 'Continue'.";
        NSString* msg4 = (successes.count == 1) ? @"" : @"\n• Repeat last three steps until all are approved.";
        NSString* msg5 = @"\n• Quit Firefox.";

        NSString* msg = [NSString stringWithFormat:
                         @"%@%@%@%@%@",
                         msg1, msg2, msg3, msg4, msg5];

        alert = [SSYAlert alert] ;
        [alert setIconStyle:SSYAlertIconWarning] ;
        [alert setSmallText:msg] ;
        [alert setButton1Title:[[BkmxBasis sharedBasis] labelOk]] ;
        [alert setButton1Title:@"OK, I did it"];
    }

    [successes release];
    [failures release];
    [affectedProfiles release];

    return alert;
}

+ (void)upgradeAsNeeded {
    static_alertQueue = [NSMutableArray new];

#if 0
#warning Testing Alert Queue
    SSYAlert* alert;

    alert = [SSYAlert alert];
    [alert setSmallText:@"You didn't comb your hair."];
    [alert setButton1Title:@"Done"];
    [alert setButton2Title:@"Example"];
    [alert setClickObject:@"http://example.com"];
    [self queueAlert:alert];

    alert = [SSYAlert alert];
    [alert setSmallText:@"Your shoe is untied."];
    [self queueAlert:alert];
#else

    /* This is important enough that we want it checked on every launch. */
    [self queueAlert:[self upgradeAnyLegacyExtensions]];

    /* This is not as important so we only do it when initially upgrading
     to BkmkMgrs 2.3. */
    if ([(BkmxAppDel*)[NSApp delegate] needsTriggersCheckedForFirefox53]) {
        [self queueAlert:[self upgradeAnyLegacyTriggers]];
    }
#endif

    [self doNextAlert];
}

+ (void)queueAlert:(SSYAlert*)alert {
    if (alert) {
        [alert setRightColumnMinimumWidth:380.0];
        [alert doooLayout];
        [alert setClickTarget:self];
        [alert setClickSelector:@selector(handleClickInAlert:)];
        [static_alertQueue addObject:alert];
    }
}

+ (void)handleClickInAlert:(SSYAlert*)alert {
    if ([alert alertReturn] == NSAlertSecondButtonReturn) {
        [SSWebBrowsing browseToURLString:(NSString*)[alert clickObject]
                 browserBundleIdentifier:nil
                                activate:YES] ;
        /* Without sleeping for at least 1 second, the web browser invoked in
         the previous statement will not come forward of other applications.
         Weird, but not worth troubleshooting.  Just give it 2 seconds. */
        sleep(2);
    }
}

+ (void)doNextAlert {
    SSYAlert* nextAlert = [static_alertQueue firstObject];
    if (nextAlert) {
        [nextAlert runModalDialog];
        [static_alertQueue removeObjectAtIndex:0];
        [self doNextAlert];
    }
    else {
        [static_alertQueue release];
    }
}

@end
