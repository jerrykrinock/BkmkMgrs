#import "BkmxNotifierAppDel+AlertActions.h"
#import "NSBundle+MainApp.h"
#import "SSYAppleScripter.h"
#import "BkmxGlobals.h"

@implementation BkmxNotifierAppDel (BkmxNotifierAppDel_AlertActions)

- (void)    userNotificationCenter:(UNUserNotificationCenter *)center
    didReceiveNotificationResponse:(UNNotificationResponse *)response
             withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(macos(10.14)){
    NSString* actionIdentifier = response.actionIdentifier;
    if ([actionIdentifier hasPrefix:constUserNotificationActionIndentifierPresentError]) {
        CFPreferencesSetAppValue(
                                 (CFStringRef)@"launchQuietlyNextTime",
                                 (CFPropertyListRef)[NSNumber numberWithBool:YES],
                                 (CFStringRef)[[NSBundle mainAppBundle] bundleIdentifier]
                                 );
        NSString* errorCodeClause = @"";
        if (actionIdentifier.length > constUserNotificationActionIndentifierPresentError.length) {
            NSString* suffix = [actionIdentifier substringFromIndex:constUserNotificationActionIndentifierPresentError.length];
            NSInteger targetErrorCode = suffix.integerValue;
            if (targetErrorCode != 0) {
                errorCodeClause = [NSString stringWithFormat:
                                   @" code %ld",
                                   targetErrorCode];
            }
        }
        NSString* source = [NSString stringWithFormat:
                            @"tell application \"%@\"\n"
                            @"activate\n"
                            @"present last logged error%@\n"
                            @"end tell",
                            [[NSBundle mainAppBundle] bundlePath],
                            // Prior to BookMacster version 1.3.19, the above was:
                            // [[BkmxBasis sharedBasis] mainAppNameUnlocalized]
                            // However that would sometimes tell the wrong version
                            // of BookMacster.  Arghhhh!!!
                            // bundlePath is typically /Applications/BookMacster.app
                            errorCodeClause
                            ] ;
        NSTimeInterval const secondsAllowedForUserToDismissDialog = 44.567;
        [SSYAppleScripter executeScriptSource:source
                              ignoreKeyPrefix:nil
                                     userInfo:nil
                         blockUntilCompletion:YES
                              failSafeTimeout:secondsAllowedForUserToDismissDialog
                            completionHandler:^(id  _Nullable payload, id  _Nullable userInfo, NSError * _Nullable scriptError) {
            if (scriptError) {
                // Since this *is* the error-presenting method, all
                // we can do with this error-presenting error is log it.
                NSLog(@"Internal Error 561-9018.  A second error occurred upon telling main app to present the last error.  Second error: %@ %@",
                      [scriptError localizedDescription],
                      [scriptError description]) ;
            }
        }];
        
    } else if ([actionIdentifier hasPrefix:constUserNotificationActionIndentifierShowHelpAnchor]) {
        if (actionIdentifier.length > constUserNotificationActionIndentifierShowHelpAnchor.length) {
            NSString* anchor = [actionIdentifier substringFromIndex:constUserNotificationActionIndentifierShowHelpAnchor.length];
            /* We display help in our Help Book on the internet instead of in
             the local Help Viewer because -[NSHelpManager openPage:inBook:] is
             STILL broken in macOS 12 Beta 6 :( */
            NSURL* url = [NSURL URLWithString:@"http://sheepsystems.com/bookmacster/HelpBook"];
            url = [url URLByAppendingPathComponent:anchor];
            void (^wrappedCompletionHandler)(NSRunningApplication*, NSError*) = ^void (NSRunningApplication *app, NSError *error) {
                completionHandler();
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
    }
    
    if (completionHandler) {
        completionHandler();
        [NSApp terminate:nil];
    }
}

/* I implemented this method after watching this segment of WWDC video:
 https://developer.apple.com/videos/play/wwdc2018/710/?time=1655
 You see she her example is in iOS.  I am not sure if this method is ever
 called  in macOS.  It seems like it should get called if user clicks in
 the body of an alert (not on one of the buttons.  But it does not.  So maybe
 this is all for naught.  Oh, well. */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
   openSettingsForNotification:(UNNotification *)notification API_AVAILABLE(macos(10.14)) {
    NSString* source = [NSString stringWithFormat:
                        @"tell application \"%@\"\n"
                        @"activate\n"
                        @"open notification settings\n"
                        @"end tell",
                        [[NSBundle mainAppBundle] bundlePath]
                        ] ;
    [SSYAppleScripter executeScriptSource:source
                          ignoreKeyPrefix:nil
                                 userInfo:nil
                     blockUntilCompletion:YES
                          failSafeTimeout:15.879
                        completionHandler:^(id  _Nullable payload, id  _Nullable userInfo, NSError * _Nullable scriptError) {
        if (scriptError) {
            // Since this *is* the error-presenting method, all
            // we can do with this error-presenting error is log it.
            NSLog(@"Internal Error 561-9043.  An error occurred upon telling main app to open its notification settings.  Second error: %@ %@",
                  [scriptError localizedDescription],
                  [scriptError description]) ;
        }
    }];
}
    
@end
