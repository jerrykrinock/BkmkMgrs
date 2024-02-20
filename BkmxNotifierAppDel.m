/* Instead of the following kludge, involving Preprocessor Macros in Build Settings,
 I could have changed the Objective-C Bridging Header in one of the two targets
 to match the other and only impot the matched header.  But I thought it
 would be better to put this kludge out in open code. */
#if JERRY_KLUDGE_IS_TARGET_A
#import <BkmxNotifier_A-Swift.h>
#endif
#if JERRY_KLUDGE_IS_TARGET_B
#import <BkmxNotifier_B-Swift.h>
#endif

#import "BkmxNotifierAppDel.h"
#import "BkmxGlobals.h"


NSString* constCategoryIdentifierEverything = @"categoryIdentifierAlertError";

@implementation BkmxNotifierAppDel

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {
    if (@available(macOS 10.14, *)) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSError* error = nil;
    /* This little app requires a JSON dictionary of parameters
     to be fed to it via stdin.  Since I would rather not spend the time it
     would take to build that test harness until necessary (and it would be
     messy because Xcode schemes do not support passing stdin to executables,
     as explained here:
     https://stackoverflow.com/questions/7629886/how-can-i-pipe-stdin-from-a-file-to-the-executable-in-xcode-4,
     So instead I took the lazy way out and just give it fake data with the
     following #if… */
#if 0
#warning BkmxNotifier is being compiled with fake input data
    NSData *stdinData = nil;
    NSDictionary* parms = @{
        BkmxNotifierKeys.title : @"My Title",
        BkmxNotifierKeys.subtitle : @"My Subtitle",
        BkmxNotifierKeys.body : [[NSDate date] description],
    };
    NSLog(@"Launch arguments: %@", [[NSProcessInfo processInfo] arguments]);
#else
    NSFileHandle *stdinFileHandle = [NSFileHandle fileHandleWithStandardInput];
    NSData *stdinData = [NSData dataWithData:[stdinFileHandle readDataToEndOfFile]];
    
    NSDictionary* parms = [NSJSONSerialization JSONObjectWithData:stdinData
                                                          options:0
                                                            error:&error];
#endif
    NSString* title = nil;
    NSString* subtitle = nil;
    NSString* body = nil;
    NSString* soundName = nil;
    NSArray* actionDics = nil;
    if (error) {
        /* This happened when running a main app in the Xcode debugger because,
         for some reason, a BkmxNotifier is launched with stdin passed as an
         empty string.  This does not happen when launching a main app in
         Finder.  So I wrote this code to find what was happening – You can
         see the result in the system Console.app via syslog().  Another thing
         that I found  was that, in this case, the parent process ID
         returned by getppid() is 1, which is, of course, launchd.  I am not
         sure if that is normal or not.  Also, I am not sure if execution
         of this branch was just due to some edge case in my developemnt
         environment which will never occur again.  But if it does, it will
         log only to the system console and not be presented as a notification
         to the user.  Well, also this might be defensive programming in case,
         while up/down/grading from BkmkMgres 2 to BkmkMgrs 3, somehow, a
         BkmkkNotofier gets launched with stdin encoded as JSON when it is
         expecting the old NSKeyedArchive, or vice versa.  */
        NSString* issue = @"BkmxNotifier launched but will terminate immediately cuz could not decode its stdin.";
        NSString* stdinAsString;
        if (stdinData) {
            stdinAsString = [[NSString alloc] initWithData:stdinData
                                                  encoding:NSUTF8StringEncoding];
            if (!stdinAsString) {
                stdinAsString = [[NSString alloc] initWithData:stdinData
                                                      encoding:NSASCIIStringEncoding];
                if (!stdinAsString) {
                    stdinAsString = stdinData.description;
                }
            }
        } else {
            stdinAsString = @"Sorry, nil";
        }
        syslog(
               LOG_ERR,
               "%s",
               [NSString stringWithFormat:
                @"%@ :: Error: %@ :: length=%ld :: %@ :: ppid=%d",
                issue,
                [error localizedDescription],
                (long)stdinData.length,
                stdinAsString,
                getppid()]
               .UTF8String);
    } else {
        title = [parms objectForKey:BkmxNotifierKeys.title];
        subtitle = [parms objectForKey:BkmxNotifierKeys.subtitle];
        body = [parms objectForKey:BkmxNotifierKeys.body];
        soundName = [parms objectForKey:BkmxNotifierKeys.soundName];
        actionDics = [parms objectForKey:BkmxNotifierKeys.actionDics];
    }
    
    BOOL needsAnything = (title != nil) || (subtitle != nil) || (body != nil) || (soundName != nil);
    if (needsAnything) {
        BOOL needsAlerts = ((title != nil)|| (subtitle != nil) || (body != nil));
        BOOL needsSounds = (soundName != nil);
        
        [self ensureAuthorizedForNotificationAlerts:needsAlerts
                                             sounds:needsSounds];
        
        /* If we are in BkmxNotifier-A, we only alert one event, which is a major
         error.  So we don't need more than the current notification to remain in
         Notification Center.  Furthermore, our process will keep running until
         the user responds.  And if the user does not respond (clicks 'Close'
         instead of 'More', or in System Preferences has BkmxNotifier-A set to
         show only 'Banners' and ignores the notification, or set to 'None', then
         our process will continue running until restart or until the system
         removes the notification, which may take 2 weeks.
         
         In consideration of these facts, we now remove any previous notifications
         still in Notification Center by BkmxNotifier-A, and quit the
         BkmxNotifier-A processes which are waiting for their response. */
        if ([[[NSBundle mainBundle] bundleIdentifier] hasSuffix:@"-A"]) {
            [self removeAllPreviousNotifications];
            
            /* Unfortunately, removing a notification does not send a response
             to the application process.  Or maybe it sends the response to us
             instead of the prior application process which "added" the
             notification.  So, to clean that up, we now quit any other
             BkmxNotifier-A processe which are current running. */
            NSString* bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
            NSArray* runningApplications = [[NSWorkspace sharedWorkspace] runningApplications];
            pid_t pid = getpid();
            for (NSRunningApplication* runningApp in runningApplications) {
                NSString* aBundleIdentifier = [runningApp bundleIdentifier];
                if ([aBundleIdentifier isEqualToString:bundleIdentifier]) {
                    pid_t aPid = [runningApp processIdentifier];
                    if (aPid != pid) {
                        [runningApp terminate];
                    }
                }
            }
        }
        
        [self presentTitle:title
                  subtitle:subtitle
                      body:body
                 soundName:soundName
                actionDics:actionDics];
        
        /* Compute how long to keep running after presenting the notification.
         We have three cases…
         • For BkmxNotifier-A, I choose 5 minutes.  We could let it go indefinitely,
         but I feel bad about leaving a useless process running.  If the user
         clicks the action button ("More…") after 5 minutes and we are terminated,
         the system will seamlessly re-launch another BkmxNotifier-A to handle the
         action.  Nice, Apple.
         * For BkmxNotifier-B, if no sound is played, 0.1 seconds.  Could be 0 but,
         you know, the value 0 sometimes gives unexpected results in computer
         software in general, so I use 0.1.
         * For BkmxNotifier-B, if a sound is played, 5.0 seconds, to allow time
         for the sound to play.  The sounnd is less than a second, but the system
         might not present it immediately.  If the system is so busy that it does
         not present our notification in 5 seconds, well, we probably don't want
         to add to the business anyhow. */
        NSTimeInterval delaySecs = 5 * 60;
        if ([[[NSBundle mainBundle] bundleIdentifier] hasSuffix:@"-B"]) {
            delaySecs = soundName ? 5.0 : 0.1;
        }
        
        /* Dispatch our termination. */
        dispatch_after(
                       dispatch_time(DISPATCH_TIME_NOW, delaySecs * NSEC_PER_SEC),
                       dispatch_get_main_queue(), ^{
                           [NSApp terminate:nil];
                       });
    } else {
        [NSApp terminate:nil];
    }
}

- (void)ensureAuthorizedForNotificationAlerts:(BOOL)needsAlerts
                                       sounds:(BOOL)needsSounds {
    NSString* what;
    if (needsAlerts) {
        if (needsSounds) {
            what = @"alerts & sounds";
        } else {
            what = @"alerts only";
        }
    } else if (needsSounds) {
        what = @"sounds only";
    } else {
        what = @"none";
    }
    NSString* msg = [NSString stringWithFormat:
                     @"Authorizing Notifications: %@",
                     what];
    NSLog(@"%@", msg);
    
    if (@available(macOS 10.14, *)) {
        UNAuthorizationOptions options = 0;
        if (needsAlerts) {
            options += UNAuthorizationOptionAlert;
        }
        if (needsSounds) {
            options += UNAuthorizationOptionSound;
        }

        UNUserNotificationCenter* unc = [UNUserNotificationCenter currentNotificationCenter];
        
        [unc requestAuthorizationWithOptions:options
                           completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                NSLog(@"Authorization to present macOS User Notifications was granted");
            } else {
                NSString* msg = [NSString stringWithFormat:
                                 @"Could not get authorization to present macOS User Notifications with options %ld due to %@",
                                 (long)options,
                                 [error description]];
                NSLog(@"%@", msg);
            }
        }];
    } else {
        /* Deprecated in macOS 10.14, NSUserNotificationCenter will be used.
         It does not require authorizations, woohoo. */
    }
}

- (void)removeAllPreviousNotifications {
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeAllDeliveredNotifications];
}

- (void)presentTitle:(NSString*)title
            subtitle:(NSString*)subtitle
                body:(NSString*)body
           soundName:(NSString*)soundName
          actionDics:(NSArray<NSDictionary*>*)actionDics {
    if (title || subtitle || body || soundName) {
        if (!title) {
            title = @"";
            /* Compiler will complain if content.title can be set to nil
             (even though it is not declared as Nonnull in header.
             However, an empty string works just as good.   That is, if
             all three text fields (title, subtitle, body) are nil or empty
             strings, no alert or banner will appear.  But, if given,
             sound will occur. */
        }
        if (!subtitle) {
            subtitle = @"";
        }
        if (!body) {
            body = @"";
        }
        CFUUIDRef cfUUID = CFUUIDCreate(kCFAllocatorDefault);
        NSString* uuid = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfUUID));
        CFRelease(cfUUID);

        UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
        content.title = title;
        content.subtitle = subtitle;
        content.body = body;
        
        /* Bug in macOS 10.15?   Does not find sound without actual
         filename extension? */
        if ([soundName hasPrefix:@"BookMacsterSync"]) {
            soundName = [soundName stringByAppendingPathExtension:@"aiff"];
        }
        
        if (soundName) {
            UNNotificationSound* sound = [UNNotificationSound soundNamed:soundName];
            content.sound = sound;
        }
        
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
#if DEBUG
        NSLog(@"Preparing notification with title: %@; subtitle: %@; body: %@",
              title,
              subtitle,
              body);
#endif

        if ([[[NSBundle mainBundle] bundleIdentifier] hasSuffix:@"-A"]) {
            NSMutableArray<UNNotificationAction*>* actions = [NSMutableArray new];
            for (NSDictionary* actionDic in actionDics) {
                UNNotificationAction* action = [UNNotificationAction actionWithIdentifier:[actionDic objectForKey:BkmxNotifierKeys.actionIdentifier]
                                                                                    title:@"More…"
                                                                                  options:UNNotificationActionOptionNone];
                [actions addObject:action];
            }
            content.categoryIdentifier = constCategoryIdentifierEverything;
            /* In the next call, the UNNotificationCategoryOptionCustomDismissAction is
             necessary in order that the delegate method -[BkmxNotifierAppDel
             userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler:]
             is called when user clicks the 'Close' button in a banner or
             alert, or clicks in the non-button area of an alert. */
            UNNotificationCategory* category = [UNNotificationCategory categoryWithIdentifier:constCategoryIdentifierEverything
                                                                                      actions:actions
                                                                            intentIdentifiers:@[]  // these would be for Siri
                                                                                      options:UNNotificationCategoryOptionCustomDismissAction];
            
            /* Apple documentation of -[UNUserNotificationCenter setNotificationCategories:] says
             "Call this method at launch time… Typically, you call this method only once."
             We are actually doing that, since we launch a new BkmxNotifier for each
             notification we present. */
            [center setNotificationCategories:[NSSet setWithObject:category]];
        }
        
        UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:uuid
                                                                              content:content
                                                                              trigger:nil];
        [center addNotificationRequest:request
                 withCompletionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSString* msg = [NSString stringWithFormat:
                                 @"Could not add macOS User Notifications request due to %@",
                                 [error description]];
                NSLog(@"%@", msg);
            } else {
#if DEBUG
                NSLog(@"macOS Notification Center accepted request %@", request);
#endif
            }
        }];
    }
}

@end
