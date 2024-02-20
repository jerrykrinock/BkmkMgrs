#import <xpc/xpc.h>
#import <Foundation/Foundation.h>

#define SAFARI_DAV_CLIENT_ERROR_NO_ERROR     0
#define SAFARI_DAV_CLIENT_ERROR_TIMED_OUT    3
#define SAFARI_DAV_CLIENT_ERROR_OTHER_ERROR  5

int launchctlToSafariDav (NSString* command) ;

int launchctlToSafariDav (NSString* command) {
    NSTask* task = [[NSTask alloc] init] ;
    [task setLaunchPath:@"/bin/launchctl"] ;
    NSArray* arguments = [NSArray arrayWithObjects:
                          command,
                          @"/System/Library/LaunchAgents/com.apple.safaridavclient.plist",
                          nil] ;
    [task setArguments:arguments] ;
    
    [task launch] ;
    [task waitUntilExit] ;
    
    return [task terminationStatus] ;
}

void reloadSafariDavClient(void) ;

void reloadSafariDavClient(void) {
    int taskResult ;
    taskResult = launchctlToSafariDav (@"unload") ;
    NSLog(@"Warning 214-9207 unload result=%d", taskResult) ;
    sleep (1) ;
    taskResult = launchctlToSafariDav (@"load") ;
    NSLog(@"Warning 214-9208 reload result=%d", taskResult) ;
}


int pushIt(
           const char *svcName,
           NSTimeInterval timeout,
           NSTimeInterval priorTimeout,
           NSString** message_p) ;

int pushIt(
           const char *svcName,
           NSTimeInterval timeout,
           NSTimeInterval priorTimeout,
           NSString** message_p) {
    __block int returnValue = SAFARI_DAV_CLIENT_ERROR_NO_ERROR ;
    __block BOOL gotEvent = NO ;
    __block NSString* message =
    @"iCloud Bookmarks syncing was expected, "
    @"but it appears to be not loaded." ;
    // Above line was "nil", and also '*message_p' was used; 'message' did not
    // exist here until BookMacster 1.11.  The *message_p did not seem to
    // make it through the block for some reason, and also it could not be
    // declared __block.  It compiled, but if it was needed because
    // the SafariDAVAgent being unloaded by this,
    // launchctl unload /System/Library/LaunchAgents/com.apple.safaridavclient.plist
    // then it crashed, at one of several places.  Don't quite understand it,
    // but it doesn't crash any more and this code looks much better.
    
    // Create the service for sending
#pragma deploymate push "ignored-api-availability" // See Note Thomas10.7 below
    xpc_connection_t sender ;
    sender = xpc_connection_create_mach_service(
                                                svcName,
                                                NULL,
                                                0
                                                ) ;
#pragma deploymate pop
    // Note: NULL targetQueue defaults to DISPATCH_TARGET_QUEUE_DEFAULT
    // Set an Event Handler
#pragma deploymate push "ignored-api-availability" // See Note Thomas10.7 below
    xpc_connection_set_event_handler(sender, ^(xpc_object_t object) {
#pragma deploymate pop
        // This will give us an error when the server shuts down.
#pragma deploymate push "ignored-api-availability" // See Note Thomas10.7 below
        xpc_type_t type = xpc_get_type(object) ;
#pragma deploymate pop
        if (type != XPC_TYPE_ERROR) {
#pragma deploymate push "ignored-api-availability" // See Note Thomas10.7 below
            char* desc = xpc_copy_description(object) ;
#pragma deploymate pop
            message = [NSString stringWithFormat:@"Unexpected event: %s", desc] ;
            NSLog(@"Warning 529-0484 %@", message) ;
            // We just log this and let it go, since I have no idea what
            // is the message protocol for SafariDAVClient.  In my testing,
            // this branch never executed, but maybe in some future version,
            // it will.
            free(desc) ;
        }
        else {
            if (object == XPC_ERROR_CONNECTION_INTERRUPTED) {
                // We received a "Connection interrupted" error.  This is
                // the expected result!  It indicates that SafariDAVClient
                // has finished its push and has exitted.
            }
            else {
#pragma deploymate push "ignored-api-availability" // See Note Thomas10.7 below
                const char* errorString = xpc_dictionary_get_string(object, XPC_ERROR_KEY_DESCRIPTION) ;
#pragma deploymate pop
                message = [NSString stringWithFormat:
                           @"Unexpected error: %s",
                           errorString] ;
                NSLog(@"Error 529-8467 %@", message) ;
                returnValue = SAFARI_DAV_CLIENT_ERROR_OTHER_ERROR ;
            }
        }
        gotEvent = YES ;
    }) ;
#pragma deploymate push "ignored-api-availability" // See Note Thomas10.7 below
    xpc_connection_resume(sender) ;
#pragma deploymate pop
    
    // Send a message
    xpc_object_t msgDic ;
#pragma deploymate push "ignored-api-availability" // See Note Thomas10.7 below
    msgDic = xpc_dictionary_create(NULL, NULL, 0) ;
#pragma deploymate pop
    // Reverse-engineering of SafariDAVClient shows that I
    // need to send a message in order to launch it, but it
    // does not seem to matter what message I send.  Send something cute…
#pragma deploymate push "ignored-api-availability" // See Note Thomas10.7 below
    xpc_dictionary_set_string(msgDic, "Msg", "Push, with pretty please") ;
    xpc_connection_send_message(sender, msgDic) ;
#pragma deploymate pop

    /*
     See Note on OS_OBJECT_USE_OBJC_RETAIN_RELEASE below
     */
    
#if MAC_OS_X_VERSION_MIN_REQUIRED < 1070
    xpc_release(msgDic) ;
#endif

    if (returnValue == SAFARI_DAV_CLIENT_ERROR_NO_ERROR) {
        /*
         Message has been sent to SafariDAVClient
         Run until SafariDAVClient quits, or timeout.
         
         2012-04-20  Well now it seems that SafariDAVClient cancels the
         connection (we get a "connection interrupted" error) within a few
         seconds from now, even though SafariDAVClient may run for several
         minutes doing the actual upload.  So, the timeout doesn't really
         matter.  I don't know if this is new in macOS 10.7.3 or not.
         */
        
        NSDate* timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeout] ;
        NSDate* pollDate = [NSDate dateWithTimeIntervalSinceNow:1.0] ;
        
        while ([[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                        beforeDate:pollDate]) {
            if ([timeoutDate timeIntervalSinceNow] < 0) {
                message = [NSString stringWithFormat:
                           @"macOS took longer than %0.0f seconds to "
                           @"push your bookmarks export into iCloud.  "
                           @"It may have failed." ,
                           timeout + priorTimeout] ;
                NSLog(@"Warning 527-3959 %@", message) ;
                returnValue = SAFARI_DAV_CLIENT_ERROR_TIMED_OUT ;
                break ;
            }
            if (gotEvent) {
                break ;
            }
            
            pollDate = [NSDate dateWithTimeIntervalSinceNow:2.0] ;
        }
    }
    
    /* In Daemons and Services Programming Guide ▸ Creating XPC Services …
     "11.  Eventually, the application calls xpc_connection_cancel to terminate
     the connection.  Note: Either side of the connection can call
     xpc_connection_cancel. There is no functional difference between the
     application canceling the connection and the service canceling the
     connection."
     
     I think that, in this case, if all goes well, SafariDAVClient
     ("the service") cancels the connection, and that's why I receive the
     "Connection Interrupted" event and end up here.  If I cancel the
     connection after such a success, I then receive another error event,
     "Connection Invalid".  So, I think the best thing is to only cancel
     the connection if things go badly.  I think that cancelling may be
     necessary because I have seen situations wherein if SafariDAVClient
     was not working properly, launchd would try to "respawn" every 10 seconds
     after Thomas ran unsuccessfully.  Eeek.  That happened prior to
     BookMacster 1.11, when I was even more conservative about doing this…
     */
    if (returnValue != SAFARI_DAV_CLIENT_ERROR_NO_ERROR) {
#pragma deploymate push "ignored-api-availability" // See Note Thomas10.7 below
        xpc_connection_cancel(sender) ;
#pragma deploymate pop
    }
    
    if (message_p) {
        *message_p = message ;
    }
    
    return returnValue ;
}

/*
 Note Thomas10.7
 This tool is only invoked by BookMacster or Agent when the latter are running
 in OS X 10.7 or later.  This #pragma exempts the following line(s), until the
 next #pragma deploymate pop, from analysis in shipping apps that require only
 OS X 10.6.
 */

int main (int argc, const char * argv[]) {
    int returnValue ;
    @autoreleasepool {
        const char* svcName ;
        NSTimeInterval timeout = 0.0 ;
        if (argc > 1) {
            svcName = argv[1] ;
        }
        else {
            svcName = "com.apple.safaridavclient.push" ;
        }
        if (argc > 2) {
            int timeoutSeconds ;
            sscanf (argv[2], "%d", &timeoutSeconds) ;
            timeout = timeoutSeconds ;
        }
        else {
            timeout = 60*10 ; // 10 minutes
        }
        
        BOOL done = NO ;
        NSTimeInterval priorTimeout = 0.0 ;
        BOOL userIsInvolved = NO ;
        do {
            NSString* message ;
            returnValue = pushIt(svcName, timeout, priorTimeout, &message) ;
            priorTimeout += timeout ;
            
            if (returnValue == SAFARI_DAV_CLIENT_ERROR_NO_ERROR) {
                if (userIsInvolved) {
                    CFUserNotificationDisplayAlert (
                                                    300.0,  // timeout for user to respond
                                                    kCFUserNotificationPlainAlertLevel,
                                                    NULL,  // use default icon.  Todo: Put the BookMacster icon here
                                                    NULL,
                                                    NULL,
                                                    CFSTR("BookMacster : iCloud Recovery"),
                                                    CFSTR("It seems to have worked now."),
                                                    CFSTR("OK"),
                                                    NULL,
                                                    NULL,
                                                    NULL) ;
                }
                done = YES ;
            }
            else {
                NSString* baseMsg = @"macOS indicated trouble while "
                @"pushing your bookmarks export into iCloud.\n\n" ;
                message = [baseMsg stringByAppendingString:message] ;
                NSString* retryButton ;
                if (returnValue == SAFARI_DAV_CLIENT_ERROR_TIMED_OUT) {
                    timeout += 1 ;
                    timeout *= 1.3 ;
                    retryButton = [NSString stringWithFormat:
                                   @"Give it %0.0f seconds more",
                                   timeout] ;
                }
                else {
                    // returnValue == SAFARI_DAV_CLIENT_ERROR_OTHER_ERROR
                    // SafariDAVClient may be not loaded
                    retryButton = @"Reload and Retry" ;
                }
                userIsInvolved = YES ;
                CFOptionFlags response ;
                CFUserNotificationDisplayAlert (
                                                300.0,  // timeout for user to respond
                                                kCFUserNotificationCautionAlertLevel,
                                                NULL,  // use default icon
                                                NULL,
                                                NULL,
                                                CFSTR("BookMacster : iCloud Error"),
                                                (__bridge CFStringRef)message,
                                                (__bridge CFStringRef)retryButton,
                                                CFSTR("Ignore"),
                                                NULL,
                                                &response) ;
                // Bitwise & with 0x3 per the fine print in document
                //     CFUserNotification Reference > Constants > Response Codes > Discussion
                response = response & 0x3 ;
                if (response == kCFUserNotificationDefaultResponse) {
                    // response is either one of
                    //    kCFUserNotificationAlternateResponse – user clicked "Ignore"
                    //    kCFUserNotificationCancelResponse – user clicked nothing, dialog timed out
                    
                    // Added in BookMacster 1.11
                    if (returnValue == SAFARI_DAV_CLIENT_ERROR_OTHER_ERROR) {
                        reloadSafariDavClient() ;
                    }
                }
                else {
                    done = YES ;
                }
            }
        } while (!done) ;
    }
    
    exit(returnValue) ;
}

/* References
 https://forums.developer.apple.com/thread/4921
 */

/*
Note on OS_OBJECT_USE_OBJC_RETAIN_RELEASE

 The following messages were copied from:
 http://www.cocoabuilder.com/archive/cocoa/323575-os-object-use-objc-retain-release-and-xpc-release.html#323575

 To: cocoa-dev@lists.apple.com
 From: Jerry Krinock

 About a year ago, I built a tool which did some XPC and, following documentation I read somewhere, invoked xpc_release().  This little project uses ARC and stills builds OK in Xcode 4.5.2.

 I want to absorb it into a big old project that contains a couple dozen targets.  So I added a target for it, with ARC.  But building the big project fails because the macro OS_OBJECT_USE_OBJC_RETAIN_RELEASE is defined, and in xpc.h this redefines xpcrelease, which is also apparently a macro, to be a function which invokes -release, which is not allowed under ARC.

 In the little project, OS_OBJECT_USE_OBJC_RETAIN_RELEASE is not defined.  And *I* have not defined it in the big project, in any of my code, but apparently this definition got included somewhere.

 How might it have gotten defined, and should it be defined or not?  In the documentation of xpc_release(), there is no indication to not use it under ARC.  Indeed it could be defined elsewhere, to do something different.

 All of the other targets in the big project do not use ARC.  Both targets are built with the "Latest" (10.8) SDK.

 What's wrong with this picture?

 Thanks,

 Jerry

*****

 From: Greg Parker, Apple Runtime Wrangler
 Date: Nov 4

 If you build with the 10.8 SDK, and your deployment target is 10.8 or later, then dispatch objects and XPC objects become Objective-C objects. If you use ARC then they are ordinary ARC-managed objects and you do not retain and release them yourself.

 You can temporarily revert to the old behavior by defining OS_OBJECT_USE_OBJC=0. Going forward the solution is to remove your manual retain/release calls and let ARC do the work. (I can't remember if the ARC migrator handles dispatch and XPC now. You might try re-running the ARC migrator on your ARC code and see if it catches them.)

 My guess is that your two projects behave differently because they have different deployment targets.

 --
 Greg Parker    <gparker...>    Runtime Wrangler


 ******

 From: Jerry Krinock
 Date: Nov 5

 Continuing.  In here…

 http://opensource.apple.com/source/libdispatch/libdispatch-228.18/os/object
 .h

 I find a maze of #define compiler directives which affect OS_OBJECT_USE_OBJC_RETAIN_RELEASE, and also there is a comment which implies that maybe I should add compiler flag -DOS_OBJECT_USE_OBJC=0 to the file which invokes xpc_release().  Indeed, doing so fixes the error.

 But I don't fully understand what the effect is.  Also, my little project does not have that flag, neither as an option in the relevant source file, nor anywhere in Build Settings.  It builds fine without it.

 Any clues to the intended usage of this OS_OBJECT_USE_OBJC_RETAIN_RELEASE and OS_OBJECT_USE_OBJC would be appreciated.

 Thanks again,

 Jerry

 ******

 From: Quincey Morris
 Date: Nov 5

 On Nov 3, 2012, at 12:55 , Jerry Krinock <jerry...> wrote:

 > I want to absorb it into a big old project that contains a couple dozen targets.  So I added a target for it, with ARC.  But building the big project fails because the macro OS_OBJECT_USE_OBJC_RETAIN_RELEASE is defined, and in xpc.h this redefines xpcrelease, which is also apparently a macro, to be a function which invokes -release, which is not allowed under ARC.

 What does "building the big project fails" mean? Are you saying it fails to build the target you added, or that the older targets no longer build?

 > All of the other targets in the big project do not use ARC.  Both targets are built with the "Latest" (10.8) SDK.

 So it sounds like one of two things happened. Either a build setting got changed at the project level that was then inherited into all the old target build settings and messed up those builds, or the new target is inheriting a build setting (or the absence of a setting) from the project that it needs to be set differently.

 Frankly, if you're not using ARC in the project generally (and don't want to convert the whole project to ARC for practical reasons), you're probably better off just adding manual retain/release code (including xpc_release) back into the tool code. Having subtly different setting distributed around the targets seems like a future maintenance headache. Well, it's already a *current* maintenance headache, really, or you wouldn't be asking about it. :)

 Alternatively, package the tool code as a static library or framework, so that it can continue to live in its own project with its own settings.

 On Nov 5, 2012, at 09:56 , Jerry Krinock <jerry...> wrote:

 > But I don't fully understand what the effect is.  Also, my little project does not have that flag, neither as an option in the relevant source file, nor anywhere in Build Settings.  It builds fine without it.

 Yes, but the little project does have ARC.

 ******

 From: Jean-Daniel Dupas
 Date: Nov 5

 From the Xcode 4.4 release notes:

 GCD and XPC objects support Automated Reference Counting (ARC) in Objective-C. Using GCD and XPC with ARC requires a minimum deployment target of OS X10.8 and is disabled when building with Garbage Collection or for 32-bit Intel. It can be manually disabled by adding OS_OBJECT_USE_OBJC=0 to the "PreprocessorMacros" build setting in Xcode.

 -- Jean-Daniel

 ******

 From: Jerry Krinock
 Date: Nov 8

 On 2012 Nov 03, at 16:28, Greg Parker <gparker...> wrote:

 > If you build with the 10.8 SDK, and your deployment target is 10.8 or later, then dispatch objects and XPC objects become Objective-C objects. If you use ARC then they are ordinary ARC-managed objects and you do not retain and release them yourself.
 >
 > You can temporarily revert to the old behavior by defining OS_OBJECT_USE_OBJC=0.

 Yes, setting setting -DOS_OBJECT_USE_OBJC=0 in the Compiler Flags of the file calling xpc_release(), which is compiled with ARC, fixed the problem.

 > Going forward the solution is to remove your manual retain/release calls and let ARC do the work.

 Are you saying that if a file is compiled with ARC, I should delete calls to xpc_release()?  Read on…

 > You might try re-running the ARC migrator on your ARC code and see if it catches them.

 The little project was written with ARC from the ground up.  So I just ran Edit ▸ Convert to Objective-C ARC on it, and  was told that "No source file changes are necessary".  The call to xpc_release() was not noticed.

 So, neither the xpc_release() documentation, nor the ARC migrator indicate that I should remove the call to xpc_release().  Are they both missing the boat?

 From: Jean-Daniel Dupas
 Date: Nov 8

 Assuming you are targeting 10.8, yes you should remove all xpc_retain/release and dispatch_retain/release calls.

 -- Jean-Daniel

 ******

 From: Jerry Krinock
 Date: Nov 9

 On 2012 Nov 08, at 08:59, Jean-Daniel Dupas <devlists...> wrote:

 > Assuming you are targeting 10.8, yes you should remove all xpc_retain/release and dispatch_retain/release calls.

 Nope.  Targeting 10.6+.

 So then I guess I should stick with the alternative of using xpc_release() and compiling with flag -DOS_OBJECT_USE_OBJC=0.

 I think I should file a bug that these conditions for using or not xpc_release() are not documented.  I think the documentation should be in xpc.h and/or "Transitioning to ARC Release Notes".  Am I looking in the wrong place?

 Jerry

 ******

 From: Greg Parker
 Date: Nov 9

 On Nov 8, 2012, at 5:40 PM, Jerry Krinock <jerry...> wrote:
 > On 2012 Nov 08, at 08:59, Jean-Daniel Dupas <devlists...> wrote:
 >> Assuming you are targeting 10.8, yes you should remove all xpc_retain/release and dispatch_retain/release calls.
 >
 > Nope.  Targeting 10.6+.
 >
 > So then I guess I should stick with the alternative of using xpc_release() and compiling with flag -DOS_OBJECT_USE_OBJC=0.

 You should not need the extra compiler flag. Set your Deployment Target correctly and the headers will handle the rest.

 --
 Greg Parker    <gparker...>    Runtime Wrangler

 ******

 From: Jerry Krinock
 Date: Nov 9

 On 2012 Nov 08, at 18:00, Greg Parker <gparker...> wrote:

 > Set your Deployment Target correctly and the headers will handle the rest.

 Ah, very good!  I didn't notice that someone had set the Deployment Target at the *target* level to "Latest Mac OS X".  That was the whole problem to begin with.  Everything just works now.

 */
