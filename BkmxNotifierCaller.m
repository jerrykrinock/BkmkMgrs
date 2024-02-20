#import "BkmxNotifierCaller.h"
#import <UserNotifications/UserNotifications.h>
#import "BkmxBasis.h"
#import "BkmxGlobals.h"
#import "NSError+MyDomain.h"
#import "NSError+InfoAccess.h"
#import "Bkmxwork/Bkmxwork-Swift.h"

#define ALERT_THROTTLE_PERIOD 4.0


static NSTimeInterval  BkmxNotifierCallerLastAlertTime = 0.0;

@implementation BkmxNotifierCaller

+ (BOOL)presentUserNotificationTitle:title
                      alertNotBanner:(BOOL)alertNotBanner
                            subtitle:(NSString*)subtitle
                                body:(NSString*)body
                           soundName:(NSString *)soundName
                          actionDics:(NSArray<NSDictionary*>*)actionDics
                             error_p:(NSError**)error_p {
#if 0
#warning Logging notifications for debugging
    [[BkmxBasis sharedBasis] logFormat:
         @"BONEHEAD Presenting user %@ (copy this to see more lines)\n"
     @"   title: %@\n"
     @"   subtitle: %@\n"
     @"   body: %@\n"
     @"   soundName: %@\n"
     @"   actionDics: %@\n",
     alertNotBanner ? @"alert" : @"banner",
     title ? title : @"(NIL)",
     subtitle ? subtitle : @"(NIL)",
     body ? body : @"(NIL)",
     soundName ? soundName : @"(NIL)",
     actionDics ? actionDics : @"(NIL)"
    ];
#endif
    NSError* error = nil;
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSinceReferenceDate];
    if (!alertNotBanner) {
        if (currentTime - BkmxNotifierCallerLastAlertTime < ALERT_THROTTLE_PERIOD) {
            [[BkmxBasis sharedBasis] logFormat:@"Throttled notify: %@ > %@ > %@",
             title,
             subtitle,
             body];
            error = SSYMakeError(constBkmxErrorAgentNotificationsAreThrottled, @"So as to not be annoying, our Agent throttles its notifications.\n\nYou must wait a few seconds between demos.");
        }
    }
    
    if (!error) {
        BkmxNotifierCallerLastAlertTime = currentTime;
        
        NSMutableDictionary* parms = [NSMutableDictionary new];
        if (title) {
            [parms setObject:title
                      forKey:BkmxNotifierKeys.title];
        }
        if (subtitle) {
            [parms setObject:subtitle
                      forKey:BkmxNotifierKeys.subtitle];
        }
        if (body) {
            [parms setObject:body
                      forKey:BkmxNotifierKeys.body];
        }
        if (soundName) {
            [parms setObject:soundName
                      forKey:BkmxNotifierKeys.soundName];
        }
        if (actionDics) {
            [parms setObject:actionDics
                      forKey:BkmxNotifierKeys.actionDics];
        }
        
        NSTask* task = [NSTask new];
        NSError* jsonError = nil;
        NSData* data = [NSJSONSerialization dataWithJSONObject:parms
                                                       options:0
                                                         error:&jsonError];
            if (data && !jsonError) {
            NSPipe* pipeStdin = [[NSPipe alloc] init];
            NSFileHandle* fileStdin = [pipeStdin fileHandleForWriting];
            [task setStandardInput:pipeStdin];
            
            NSString* path = [[[NSProcessInfo processInfo] arguments] firstObject];
            if ([[path lastPathComponent] isEqualToString:constAppNameBkmxAgent]) {
                // path = /Applications/BookMacster.app/Contents/Library/LoginItems/BkmxAgent.app/Contents/macOS/BkmxAgent
                path = [path stringByDeletingLastPathComponent];
                // path = /Applications/BookMacster.app/Contents/Library/LoginItems/BkmxAgent.app/Contents/macOS
                path = [path stringByDeletingLastPathComponent];
                // path = /Applications/BookMacster.app/Contents/Library/LoginItems/BkmxAgent.app/Contents
                path = [path stringByDeletingLastPathComponent];
                // path = /Applications/BookMacster.app/Contents/Library/LoginItems/BkmxAgent.app
                path = [path stringByDeletingLastPathComponent];
                // path = /Applications/BookMacster.app/Contents/Library/LoginItems
                path = [path stringByDeletingLastPathComponent];
                // path = /Applications/BookMacster.app/Contents/Library
                path = [path stringByDeletingLastPathComponent];
                // path = /Applications/BookMacster.app/Contents
            } else {
                // We are in the main app
                // path = /Applications/BookMacster.app/Contents/macOS/BookMacster|Synkmark|Markster|Smarky
                path = [path stringByDeletingLastPathComponent];
                // path = /Applications/BookMacster.app/Contents/macOS
                path = [path stringByDeletingLastPathComponent];
                // path = /Applications/BookMacster.app/Contents
            }

            NSString* helperExecutableName = @"BkmxNotifier-";
            NSString* helperSuffix = alertNotBanner ? @"A" : @"B";
            if (alertNotBanner) {
                helperSuffix = @"A";
            } else {
                helperSuffix = @"B";
            }
            helperExecutableName = [helperExecutableName stringByAppendingString:helperSuffix];
            NSString* helperAppName = [helperExecutableName stringByAppendingPathExtension:@"app"];
            path = [path stringByAppendingPathComponent:@"Helpers"];
            path = [path stringByAppendingPathComponent:helperAppName];
            path = [path stringByAppendingPathComponent:@"Contents"];
            path = [path stringByAppendingPathComponent:@"MacOS"];
            path = [path stringByAppendingPathComponent:helperExecutableName];
            
            /* We use a try/catch at this point because old NSTask can throw
             exceptions, which in case we are being called to notify of a staging
             would prevent -[AgentPerformer finishJob:bkmxDoc:] from finishing,
             which would leave the trigger still "in handling" forever, which would
             cause future sync jobs to stall in the queue waiting for this job to
             finish, which is really annoying. */
            @try {
                [task setLaunchPath:path];
                [task launch] ;
                if ([task isRunning]) {
                    // Note: The following won't execute if no stdinData, since fileStdin will be nil
                    [fileStdin writeData:data] ;
                    [fileStdin closeFile] ;
                }
            } @catch (NSException *exception) {
                NSError* error = SSYMakeError(298485, @"Could not launch BkmxNotifier helper");
                error = [error errorByAddingUserInfoObject:path
                                                    forKey:@"Launch Path"];
                error = [error errorByAddingUnderlyingException:exception];
                error = [error errorByAddingLocalizedFailureReason:@"Maybe the helper is missing from this app's package"];
                error = [error errorByAddingLocalizedRecoverySuggestion:@"Try to reinstall this app."];
                /* Do not try to present the error because that would likely end us
                 up in the same @try section above, throwing another exception and
                 ending in an infinite loop. */
            } @finally {
            }
        } else {
            error = SSYMakeError(298483, @"Could not encode notification for BkmxNotifier");
            error = [error errorByAddingUnderlyingError:error];
        }
    }
    
    if (error && error_p) {
        *error_p = error ;
    }

    return (error == nil);
}

+ (BOOL)presentUserNotificationOfError:(NSError*)error
                                 title:title
                        alertNotBanner:(BOOL)alertNotBanner
                              subtitle:(NSString*)subtitle
                                  body:(NSString*)body
                             soundName:(NSString *)soundName
                       targetErrorCode:(NSInteger)targetErrorCode
                               error_p:(NSError**)error_p {
    if (!error || ![[BkmxBasis sharedBasis] shouldHideError:error]) {
        NSString* actionIdentifier = constUserNotificationActionIndentifierPresentError;
        if (targetErrorCode != 0) {
            actionIdentifier = [actionIdentifier stringByAppendingFormat:@"%ld", targetErrorCode];
        }
        NSDictionary* actionDic = @{
            BkmxNotifierKeys.actionIdentifier: actionIdentifier,
            BkmxNotifierKeys.title: NSLocalizedString(@"More…", nil),
            BkmxNotifierKeys.options: @(UNNotificationActionOptionNone)
        };
        NSArray<NSDictionary*>* actionDics = @[actionDic];
        
        NSError* presentationError = nil;
        
        [self presentUserNotificationTitle:title
                            alertNotBanner:alertNotBanner
                                  subtitle:subtitle
                                      body:body
                                 soundName:soundName
                                actionDics:actionDics
                                   error_p:&presentationError];
        
        if (presentationError && error_p) {
            *error_p = presentationError ;
        }
        
        return (presentationError == nil);
    }
    
    if (error_p) {
        *error_p = nil;
    }

    return YES;
}

+ (BOOL)presentUserNotificationWithHelpTitle:title
                              alertNotBanner:(BOOL)alertNotBanner
                                    subtitle:(NSString*)subtitle
                                        body:(NSString*)body
                                   soundName:(NSString *)soundName
                              helpBookAnchor:(NSString*)helpBookAnchor
                                     error_p:(NSError**)error_p {
    NSArray* actionDics = nil;
    if (helpBookAnchor != nil) {
        if (@available(macOS 10.14, *)) {
            NSString* actionIdentifier = constUserNotificationActionIndentifierShowHelpAnchor;
            actionIdentifier = [actionIdentifier stringByAppendingString:helpBookAnchor];
            NSDictionary* actionDic = @{
                BkmxNotifierKeys.actionIdentifier: actionIdentifier,
                BkmxNotifierKeys.title: NSLocalizedString(@"Details…", nil),
                BkmxNotifierKeys.options: @(UNNotificationActionOptionNone)
            };
            actionDics = @[actionDic];
        }
    }
    
    NSError* error = nil;
    
    [self presentUserNotificationTitle:title
                        alertNotBanner:alertNotBanner
                              subtitle:subtitle
                                  body:body
                             soundName:soundName
                            actionDics:actionDics
                               error_p:&error];
    
    if (error && error_p) {
        *error_p = error ;
    }

    return (error == nil);
}



@end



