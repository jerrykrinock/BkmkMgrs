#import "BkmxUrlHandlerAppDelegate.h"
#import "NSString+URIQuery.h"
#import "BkmxGlobals.h"
#import "NSError+LowLevel.h"
#import "NSBundle+MainApp.h"
#import "SSYAppleScripter.h"
#import "SSYEventInfo.h"
#import "BkmxBasis.h"

static NSDateFormatter* static_logDateFormatter = nil;

/*
 On 20131211, I'd seen test results indicating that I was not getting the
 NSWorkspaceDidTerminateApplicationNotification when the main app was
 killed abruptly.  So I added a watchdog.  But then later tests showed that
 I *was* always getting NSWorkspaceDidTerminateApplicationNotification.
 */
#define USE_WATCHDOG 0

@interface BkmxUrlHandlerAppDelegate ()

@property (retain) NSFileHandle* logFileHandle;

@end

@implementation BkmxUrlHandlerAppDelegate

+ (NSDateFormatter*)logDateFormatter {
    if (!static_logDateFormatter) {
        static_logDateFormatter = [[NSDateFormatter alloc] init] ;
        [static_logDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"] ;
    }

    return static_logDateFormatter ;
}



/*
 This method needs to find out whether it is BookMacster or Markster which
 is running and should get the new bookmark.  I tried my NSBundle+MainBundle
 method replacement, and alhtough that should have worked in real life, it
 did not work when testing in Xcode because, when a bookmacster:// URL is
 invoked, macOS annoyingly launches the build of Sheep-Sys-URLHandler
 which is in this project's Products directory and not the one which is
 packaged into BookMacster or Markster, so the enclosing bundle is not as
 expected.  So, instead, I used this more robust method of seeing what is
 running on the system.
 */
- (NSString*)mainAppNameInAppleScriptError_p:(NSError**)error_p {
    NSString* answer = nil ;
    NSError* error = nil ;
#if MAC_OS_X_VERSION_MIN_REQUIRED < 1060
    answer = constAppNameBookMacster ;
#else 
    NSArray* runningApps = [[NSWorkspace sharedWorkspace] runningApplications] ;
    for (NSRunningApplication* runningApp in runningApps) {
        NSString* name = [runningApp localizedName] ;
        if ([name isEqualToString:constAppNameMarkster]) {
            answer = constAppNameMarkster ;
            break ;
        }
        if ([name isEqualToString:constAppNameBookMacster]) {
            answer = constAppNameBookMacster ;
            break ;
        }
    }

    if (!answer) {
        // This is an error because this app should only be
        // running when one of the above apps is running.
        NSString* desc = @"None of our bookmark-receiving apps are running." ;
        error = [NSError errorWithDomain:@"SheepSysErrorDomain"
                                    code:959283
                                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                          desc, NSLocalizedDescriptionKey,
                                          nil]] ;
    }
#endif
    
    if (error && error_p) {
        *error_p = error ;
    }

    return answer ;
}

- (void)logString:(NSString*)string {
    if (!self.logFileHandle) {
        NSFileManager* fileManager = [NSFileManager defaultManager];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                             NSApplicationSupportDirectory,
                                                             NSUserDomainMask,
                                                             YES
                                                             ) ;
        NSString* appSupportPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil ;
        // Append "/BookMacster"
        appSupportPath = [appSupportPath stringByAppendingPathComponent:@"BookMacster"] ;
                        
        NSString* filename = @"UrlHandlerLog.txt";
        NSString* path = [appSupportPath stringByAppendingPathComponent:filename];

        BOOL isDirectory = NO;
        BOOL exists = [fileManager fileExistsAtPath:path
                                        isDirectory:&isDirectory];
        BOOL needsCreate = NO;
        if (exists) {
            if (isDirectory) {
                [fileManager removeItemAtPath:path
                                        error:NULL];
                needsCreate = YES;
            }
        } else {
            needsCreate = YES;
        }
        if (needsCreate) {
            [fileManager createFileAtPath:path
                                 contents:[NSData data]
                               attributes:nil] ;
        }

        NSFileHandle* fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:path] ;
        self.logFileHandle = fileHandle;
    }
    
    NSMutableString* line = [NSMutableString new];
    [line appendString:[[[self class] logDateFormatter] stringFromDate:[NSDate date]]];
    [line appendString:@" ["];
    [line appendFormat:@"%05d", getpid()];
    [line appendString:@"]"];
    [line appendString:@": "];
    [line appendString:string];
    [line appendString:@"\n"];
    NSData* data = [line dataUsingEncoding:NSUTF8StringEncoding];

    if (@available(macOS 10.15, *)) {
        unsigned long long junk;
        [self.logFileHandle seekToEndReturningOffset:&junk
                                               error:NULL];
    } else {
        [self.logFileHandle seekToEndOfFile];
    }
    if (@available(macOS 10.15, *)) {
        [self.logFileHandle writeData:data
                                error:NULL];
    } else {
        [self.logFileHandle writeData:data];
    }
    
    /* In macOS 10.15, the following is not necessary.  But since this log
     is for debugging strange issues, we do this to increase reliability.*/
    if (@available(macOS 10.15, *)) {
        [self.logFileHandle synchronizeAndReturnError:NULL];
    } else {
        [self.logFileHandle synchronizeFile];
    }
}

#define MAX_BYTES_ALLOWED_IN_FILE 5000

- (void)pruneLogFile {
    if (@available(macOS 10.15, *)) {
        unsigned long long junk;
        [self.logFileHandle seekToEndReturningOffset:&junk
                                               error:NULL];
    } else {
        [self.logFileHandle seekToEndOfFile];
    }
    NSInteger fileSize = [self.logFileHandle offsetInFile];
    if (fileSize > MAX_BYTES_ALLOWED_IN_FILE) {
        NSData* data;
        if (@available(macOS 10.15, *)) {
            [self.logFileHandle seekToOffset:0
                                       error:NULL];
            data = [self.logFileHandle readDataToEndOfFileAndReturnError:NULL];
        } else {
            [self.logFileHandle seekToFileOffset:0];
            data = [self.logFileHandle readDataToEndOfFile];

        }
        NSInteger firstByteToKeep = data.length - MAX_BYTES_ALLOWED_IN_FILE * 3 / 4;
        NSRange rangeToKeep = NSMakeRange(firstByteToKeep, data.length - firstByteToKeep);
        data = [data subdataWithRange:rangeToKeep];
        if (@available(macOS 10.15, *)) {
            [self.logFileHandle truncateAtOffset:0
                                           error:NULL];
            [self.logFileHandle writeData:data
                                    error:NULL];
        } else {
            [self.logFileHandle truncateFileAtOffset:0];
            [self.logFileHandle writeData:data];
        }
    }
}

/*!
 @details  This custom URL handler is used to received messages from
 both the BookMacsterize bookmarklet and the Bookmarking Widgets in
 Firefox and Chrome.
 */
- (void)handleGetURLEvent:(NSAppleEventDescriptor*)event
		   withReplyEvent:(NSAppleEventDescriptor*)replyEvent {
	// One might think that replyEvent should be a "double star" ** handle.
	// However, Apple Event Descriptors seem to be mutable.  If you wanted
	// to change the reply (which we don't), you'd put, for example,  the
	// result in replyEvent as keyDirectObject, or an error as
	// keyErrorString and keyErrorNumber.
    NSString* logMsg = [[NSString alloc] initWithFormat:
                        @"pid=%05d is handling a URL event",
                        getpid()];
    [self logString:logMsg];
	NSAppleEventDescriptor* descriptor = [[NSAppleEventManager sharedAppleEventManager] currentAppleEvent] ;
	NSInteger i ;
	for (i=1; i<=[descriptor numberOfItems]; i++) {
		NSAppleEventDescriptor* subdescriptor = [descriptor descriptorAtIndex:i] ;
		if ([descriptor keywordForDescriptorAtIndex:i] == '----') {
			NSString* encodedString = [subdescriptor stringValue] ;
			NSString* query = [[NSURL URLWithString:encodedString] query] ;
			NSString* host = [(NSURL*)[NSURL URLWithString:encodedString] host] ;  // Typecast for Deploymate
			if ([host isEqualToString:@"add"]) {
				// This branch can be invoked by either
				// (1) the BookMacsterize Bookmarklet or
				// (2) the Bookmarking Widgets in Firefox or Chrome
                NSError* error = nil ;
                NSString* forwardeeAppName = [self mainAppNameInAppleScriptError_p:&error] ;
                if (!forwardeeAppName) {
                    NSLog(@"Could not create bookmark because %@", error) ;
                }
                else {
                    NSDictionary* info = [query queryDictionary] ;
                    
                    /*
                     Here are four typical 'info' dictionaries…
                     
                     From Google Chrome Widget… {
                     name = "apple.com developer center - Google Search";
                     tabId = 2;
                     tabIndex = 0;
                     url = "http://www.google.com/search?q=apple.com+developer+center&aq=1&oq=apple.com%2Fdeveloper&sugexp=chrome,mod=5&sourceid=chrome&ie=UTF-8";
                     windowId = 1;
                     }
                     
                     From Firefox "Add" … {
                     comments = "";
                     name = "MacUpdate: Download Apple Mac Software & iPhone Software";
                     processName = firefox;
                     showInspector = 0;
                     url = "https://www.macupdate.com/";
                     userAgent = "Mozilla/5.0 (Macintosh; Intel macOS 10.7; rv:14.0) Gecko/20100101 Firefox/14.0";
                     }
                     
                     From Firefox "Add & Inspect" … {
                     comments = "";
                     name = "Download Passenger for Mac - Server password generator. MacUpdate.com";
                     processName = firefox;
                     showInspector = 1;
                     url = "https://www.macupdate.com/app/mac/5979/passenger";
                     userAgent = "Mozilla/5.0 (Macintosh; Intel macOS 10.7; rv:14.0) Gecko/20100101 Firefox/14.0";
                     }
                     
                     From BookMacsterizer bookmarklet in Safari … {
                     comments = "\n";
                     name = "Songs - Google Docs";
                     url = "https://docs.google.com/spreadsheet/ccc?key=0AtRWY6IZDbovdDJZRzZHQTQ4ZHNZVVVUZUdjM2hwRmc#gid=0";
                     userAgent = "Mozilla/5.0 (Macintosh; Intel macOS 10_7_4) AppleWebKit/534.57.2 (KHTML, like Gecko) Version/5.1.7 Safari/534.57.2";
                     }
                     
                     From BookMacsterizer bookmarklet in Firefox … {
                     comments = "";
                     name = "Graphics-Interactives";
                     url = "http://www.ap.org/products-services/Graphics-Interactives";
                     userAgent = "Mozilla/5.0 (Macintosh; Intel macOS 10.8; rv:17.0) Gecko/17.0 Firefox/17.0";
                     }

                     
                     */

                    NSNumber* showInspector = [info objectForKey:@"showInspector"];

                    /* The processName value, [info objectForKey:@"processName"],
                     was used for the old XUL Firefox extension which provided
                     two menu items ("Add Quickly", "Add & Inspect"), to show
                     or not the Inspector.  But since Firefox uses the
                     BookMacster Button (1 button) extension, that key/value
                     pair is ignored.  Its value is now typically
                     "Chromessenger". */

                    NSURL* scriptUrl = [[NSBundle mainAppBundle] URLForResource:@"LandNewBookmark"
                                                                  withExtension:@"scpt"
                                                                   subdirectory:@"AppleScripts"];

                    id newBookmarkName = [info objectForKey:constKeyName];
                    if (!newBookmarkName) {
                        /* See Note WhyEmptyString-WhyNotNull in SSYAppleScripter.h */
                         newBookmarkName = @"";
                    }
                    id newBookmarkUrl = [info objectForKey:constKeyUrl];
                    if (!newBookmarkUrl) {
                        /* See Note WhyEmptyString-WhyNotNull in SSYAppleScripter.h */
                        newBookmarkUrl = @"";
                    }
                    id newBookmarkComments = [info objectForKey:constKeyComments];
                    if (!newBookmarkComments) {
                        /* See Note WhyEmptyString-WhyNotNull in SSYAppleScripter.h */
                        newBookmarkComments = @"";
                    }

                    NSArray* handlerParameters = @[
                                                   forwardeeAppName,
                                                   newBookmarkName,
                                                   newBookmarkUrl,
                                                   newBookmarkComments,
                                                   ];
                    [SSYAppleScripter executeScriptWithUrl:scriptUrl
                                               handlerName:@"land_new_bookmark"
                                         handlerParameters:handlerParameters
                                           ignoreKeyPrefix:nil
                                                  userInfo:nil
                                      blockUntilCompletion:YES
                                         failSafeTimeout:10.555
                                         completionHandler:^void(NSArray* _Nullable answers,
                                                                 id _Nullable userInfo,
                                                                 NSError * _Nullable scriptError) {
                                             /* We display inspector with a separate script, in case
                                              landing the bookmark displayed a dialog due to duplicate
                                              or more than one document open – which one. */
                                             if (scriptError) {
                                                 NSLog(@"Handling landing new bookmark: %@  Error: %@",
                                                       encodedString,
                                                       error) ;
                                             }
                                             else if ([showInspector integerValue] == 1) {
                                                 NSURL* scriptUrl2 = [[NSBundle mainAppBundle] URLForResource:@"DisplayInspector"
                                                                                                withExtension:@"scpt"
                                                                                                 subdirectory:@"AppleScripts"];
                                                 [SSYAppleScripter executeScriptWithUrl:scriptUrl2
                                                                            handlerName:@"display_inspector"
                                                                      handlerParameters:@[forwardeeAppName]
                                                                        ignoreKeyPrefix:nil
                                                                               userInfo:nil
                                                                   blockUntilCompletion:NO
                                                                        failSafeTimeout:11.555
                                                                      completionHandler:^void(NSDictionary* _Nullable answers,
                                                                                              id _Nullable userInfo,
                                                                                              NSError * _Nullable scriptError) {
                                                                          if (scriptError) {
                                                                              NSLog(@"Displaying Inspector for: %@.  Error: %@",
                                                                                    encodedString,
                                                                                    scriptError) ;
                                                                          }
                                                                      }];
                                             }
                                         }];

                }
			}
            
			break ;
		}
	}
}

- (NSBundle*)mainAppBundle {
    // Bug fixed in BookMacster 1.19.9, until which I was simply using
    // [NSBundle mainAppBundle] here, but that returned the bundle of this app,
    // not the bundle of, for example, BookMacster, which is expected.
    NSString* bundlePath = [[NSBundle mainBundle] bundlePath] ;
    // bundlePath is path/to/BookMacster.app/Contents/Helpers/Sheep-Sys-Urlhandler.app
    bundlePath = [bundlePath stringByDeletingLastPathComponent] ;
    // bundlePath is path/to/BookMacster.app/Contents/Helpers
    bundlePath = [bundlePath stringByDeletingLastPathComponent] ;
    // bundlePath is path/to/BookMacster.app/Contents
    bundlePath = [bundlePath stringByDeletingLastPathComponent] ;
    // bundlePath is path/to/BookMacster.app
    
    return [NSBundle bundleWithPath:bundlePath];
}

- (NSString*)mainAppBundleIdentifier {
    if (!m_mainAppBundleIdentifier) {
        m_mainAppBundleIdentifier = [[self mainAppBundle] bundleIdentifier] ;
    }
	return m_mainAppBundleIdentifier ;
}

- (NSString*)mainAppName {
    return [[[[self mainAppBundle] bundlePath] lastPathComponent] stringByDeletingPathExtension];
}

- (void)goByeBye {
    [[NSWorkspace sharedWorkspace] removeObserver:self
                                       forKeyPath:@"runningApplications"] ;
    [self logString:@"Terminating normally"];
    [[NSApplication sharedApplication] terminate:self] ;
}

- (void)observeValueForKeyPath:(NSString*)keyPath
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context {
    NSArray* ourApp = [NSRunningApplication runningApplicationsWithBundleIdentifier:[self mainAppBundleIdentifier]] ;
    if ([ourApp count] < 1) {
        [self goByeBye] ;
    }
}

- (pid_t)pidOfThisUsersAppWithBundleIdentifier:(NSString*)bundleIdentifier {
	pid_t pid = 0 ; // not found
	
	if (bundleIdentifier) {
        // Running the main run loop is necessary for -runningApplications to
        // update.  The next line is actually necessary in tools which may be lacking
        // a running run loop, and it actually works.
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]] ;
        /* Upon reading Apple documtation of -runningApplications more
         and -runUntilDate: more carefully, several years later, I think that
         the following line would be better than the above line:
         [[NSRunLoop mainRunLoop] runMode:NSRunLoopCommonModes
                               beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.01]] ;
         However, when I tried to test this, in a command-line tool, even when
         running in a dispatch_async serial queue (DISPATCH_QUEUE_SERIAL),
         I find that this method works with *either* or *neither* NSRunLoop
         -runXXX call.  Maybe it is only necessary in older macOS versions?
         I'm on macOS 10.15.6 beta now.  Well, I don't know.  So I'm just
         leaving as was for now. */
        NSArray* runningApps = [[NSWorkspace sharedWorkspace] runningApplications] ;
		for (NSRunningApplication* runningApp in runningApps) {
			if ([[runningApp bundleIdentifier] isEqualToString:bundleIdentifier]) {
				pid = [runningApp processIdentifier] ;
				break ;
			}
		}
	}
	
	return pid ;
}

- (pid_t)pidUsingScrewballMethodOfAppName:(NSString*)appName
                      executableName:(NSString*)executableName {
    pid_t pid = 0;
    NSArray* args = [NSArray arrayWithObjects:
                     @"-x",       // include processes which do not have a controlling terminal, such as apps
                     @"-o",       // print the value of the following key
                     @"pid=",
                     @"-o",       // print the value of the following key
                     @"command=",
                     nil] ;
    NSString* const command = @"/bin/ps";
    
    NSTask* task = [NSTask new];
    task.launchPath = command;
    task.arguments = args;
    NSPipe* pipeStdout = [[NSPipe alloc] init] ;
    [task setStandardOutput:pipeStdout];
    NSFileHandle* fileStdout = [pipeStdout fileHandleForReading];
    [task setStandardOutput:pipeStdout];
    [task launch];
    [task waitUntilExit];
    NSData* data = [fileStdout readDataToEndOfFile] ;
    NSString* text = [[NSString alloc] initWithData:data
                                           encoding:NSUTF8StringEncoding];

    for (NSString* line in [text componentsSeparatedByString:@"\n"]) {
        NSString* targetString = [NSString stringWithFormat:
                                  @"%@.app/Contents/MacOS/%@",
                                  appName,
                                  executableName];
        if ([line rangeOfString:targetString].location != NSNotFound) {
            pid = [[[line componentsSeparatedByString:@" "] firstObject] intValue];
            break;
        }
    }

    return pid;
}


#if USE_WATCHDOG
- (void)checkMainAppWatchdog:(NSTimer*)timer {
 	pid_t pid = [self pidOfThisUsersAppWithBundleIdentifier:[self mainAppBundleIdentifier]] ;
    pid_t originalMainAppPid = [[timer userInfo] unsignedIntegerValue] ;
	if (pid != originalMainAppPid) {
		// Main app has apparently crashed.  (Otherwise, we would have already
		// terminated by executing observeValueForKeyPath::::.)
       [self goByeBye] ;
	}
}
#endif

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSString* logMsg = [[NSString alloc] initWithFormat:@"Launched: pid=%05d: path=%@", getpid(), [[[NSProcessInfo processInfo] arguments] objectAtIndex:0]];
    [self logString:logMsg];
	// Begin watching for main app to quit normally
    // Testing in macOS 10.8: This observation is received whether the app
    // quits normally, crashes, or is terminated by a unix signal, and also
    // works for apps which are running in the background, as an LSUIElement,
    // which BookMacster can be.
    [[NSWorkspace sharedWorkspace] addObserver:self
                                    forKeyPath:@"runningApplications"
                                       options:0
                                       context:NULL] ;
    // Thanks to Peter Ammon of Apple for tipping us to this more modern way of
    // watching for apps to quit.
    
    // Make sure main app did not terminate before we got here
    NSString* bundleIdentifier = [self mainAppBundleIdentifier];
    logMsg = [[NSString alloc] initWithFormat:@"Looking for main app as %@", bundleIdentifier];
    [self logString:logMsg];
	pid_t pid = [self pidOfThisUsersAppWithBundleIdentifier:bundleIdentifier];
    if (pid == 0) {
        NSString* mainAppName = [self mainAppName];
        /* It seems that whenever user Michael V. installs an update of
         BookMacster, the normal method fails to find BookMacster running and
         we terminate immediately.  To try and fix this, starting in BkmkMgrs
         2.10.29, if the pid of BookMacster is not found we try this new
         Screwball method, which is based on /bin/ps instead of
         -[NSWorkspace runningApplications]. */
        pid = [self pidUsingScrewballMethodOfAppName:mainAppName
                                      executableName:mainAppName];
        if (pid == 0) {
            /* Sleep and then try hoth methods again. */
            sleep(2);
            pid = [self pidOfThisUsersAppWithBundleIdentifier:bundleIdentifier];
            if (pid == 0) {
                pid = [self pidUsingScrewballMethodOfAppName:mainAppName
                                              executableName:mainAppName];
                if (pid == 0) {
                    // Main app must have terminated before we finished launching.
                    [self logString:@"Terminating immediately"];
                    [[NSApplication sharedApplication] terminate:self];
                } else {
                    [self logString:@"Got main app pid by screwball method on 2nd try"];
                }
            } else {
                [self logString:@"Got main app pid by normal method on 2nd try"];
            }
        } else {
            [self logString:@"Got main app pid by screwball method on 1st try"];
        }
    } else {
        [self logString:@"Got main app pid by normal method on 1st try"];
    }
    
    [self pruneLogFile];
    
#if USE_WATCHDOG
    // But we will not receive an NSWorkspaceDidTerminateApplicationNotification
    // if the main app crashes.  To handle that case, we also watchdog it
#if DEBUG
    NSTimeInterval const watchdogPeriod =  5.0 ;
#else
    NSTimeInterval const watchdogPeriod = 60.0 ;
#endif
    
    [NSTimer scheduledTimerWithTimeInterval:watchdogPeriod
                                     target:self
                                   selector:@selector(checkMainAppWatchdog:)
                                   userInfo:[NSNumber numberWithUnsignedInteger:pid]
                                    repeats:YES] ;
#endif
    
	// To receive the "bookmacster://...." incantations from other apps…
	NSAppleEventManager *appleEventManager = [NSAppleEventManager sharedAppleEventManager] ;
	[appleEventManager setEventHandler:self
						   andSelector:@selector(handleGetURLEvent:withReplyEvent:)
						 forEventClass:kInternetEventClass
							andEventID:kAEGetURL] ;
}

@end
