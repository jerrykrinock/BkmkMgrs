#include <sys/ptrace.h>
#import "AgentPerformer.h"
#import "BkmxBasis.h"
#import "SSYOtherApper.h"
#import "NSUserDefaults+MainApp.h"
// constKeyBrowserWeQuitDates is declared in BkmxGlobals.h, pulled in via BkmxBasis.h.

static void handleSIGTERM(int signum) {
    [[BkmxBasis sharedBasis] forJobSerial:0
                                logFormat:@"Process ending life cuz SIGTERM"];

    exit(0) ;
}

/* Hidden invocation mode used by -[BkmxDoc requinchBrowserMaybeForInfo:].  When
 BkmxAgent has launched a browser only in order to read its bookmarks, it wants
 to quit that browser again after a "hold" delay.  BkmxAgent cannot do this
 with a plain -performSelector:afterDelay: invocation, because it recycles
 itself (to shed Core Data memory) as soon as its Job is done -- usually in well
 under the hold time -- so the invocation would die with the process before it
 fired.  Instead BkmxDoc spawns a detached, session-leader copy of this same
 executable (POSIX_SPAWN_SETSID, so launchd's teardown of the recycling agent
 does not kill it) running in this mode.  Its whole life is: wait out the hold,
 quit the browser, exit.  Argument vector:
    argv[1]  this flag, "--quitBrowserAfterHold"
    argv[2]  browser bundle path to quit
    argv[3]  hold time (seconds) to wait before quitting
    argv[4]  quit timeout (seconds) passed to SSYOtherApper
    argv[5]  closeWindows      ("1" or "0")
    argv[6]  killAfterTimeout  ("1" or "0")
 Returns the process exit code if this was a quitter invocation, or -1 if the
 arguments are not a quitter invocation and normal startup should proceed. */
/* Note: the "--quitBrowserAfterHold" sentinel below is also matched, verbatim, by
 the agent-detection code (BkmxAgentRunner.swift and BkmxBasis+Swift.swift, via
 NSRunningApplication+WaitFor.swift) so that these browser-quitter processes --
 which are copies of this very executable -- are not mistaken for a running
 BkmxAgent.  Keep all four spellings in sync (here, BkmxDoc.m, and those two). */
static int BkmxRunBrowserQuitterIfRequested(int argc, const char* argv[]) {
    if ((argc < 7) || (strcmp(argv[1], "--quitBrowserAfterHold") != 0)) {
        return -1 ;
    }

    @autoreleasepool {
        NSString* path = [NSString stringWithUTF8String:argv[2]] ;
        NSTimeInterval holdTime = atof(argv[3]) ;
        NSTimeInterval timeout = atof(argv[4]) ;
        BOOL closeWindows = (atoi(argv[5]) != 0) ;
        BOOL killAfterTimeout = (atoi(argv[6]) != 0) ;

        NSLog(@"BkmxAgent browser-quitter: will quit %@ in %g s (timeout %g, closeWindows %d, kill %d)",
              path, holdTime, timeout, closeWindows, killAfterTimeout) ;

        [NSThread sleepForTimeInterval:holdTime] ;

        /* Record that *we*, not the user, are quitting this browser now, so the
         rest of BookMacster does not mistake it for user activity.  This
         mirrors -[Extore prepareForBrowserQuitPath:], and doing it here (at
         actual quit time) rather than at scheduling time is if anything more
         correct. */
        if (path) {
            [[NSUserDefaults standardUserDefaults] setAndSyncMainAppValue:[NSDate date]
                                                          forKeyPathArray:@[constKeyBrowserWeQuitDates, path]] ;
        }

        NSError* error = nil ;
        BOOL wasRunning = NO ;
        BOOL ok = [SSYOtherApper quitThisUsersAppWithBundlePath:path
                                                   closeWindows:closeWindows
                                                        timeout:timeout
                                               killAfterTimeout:killAfterTimeout
                                                   wasRunning_p:&wasRunning
                                                        error_p:&error] ;
        NSLog(@"BkmxAgent browser-quitter: quit %@ ok=%d wasRunning=%d error=%@",
              path, ok, wasRunning, error) ;
    }

    return 0 ;
}

int main(int argc, const char *argv[]) {

    /* Must run before any app / Core Data startup: this may be a lightweight,
     detached invocation whose only job is to quit a browser after a delay. */
    int quitterResult = BkmxRunBrowserQuitterIfRequested(argc, argv) ;
    if (quitterResult >= 0) {
        return quitterResult ;
    }

    signal(SIGTERM, handleSIGTERM) ;

#ifndef DEBUG
    //  See http://www.seoxys.com/3-easy-tips-to-prevent-a-binary-crack/
    ptrace(PT_DENY_ATTACH, 0, 0, 0);
#endif
    
    // #define KEEP_ZOMBIES
#ifdef KEEP_ZOMBIES
    setenv("NSZombieEnabled", "YES", 1);
    setenv("NSAutoreleaseFreedObjectCheckEnabled", "YES", 1);
#endif
    
    if (getenv("NSZombieEnabled")) {
        NSLog (@"NSZombieEnabled for debugging.  Will degrade performance");
    }
    
    if (getenv("NSAutoreleaseFreedObjectCheckEnabled")) {
        NSLog (@"NSAutoreleaseFreedObjectCheckEnabled for debugging. Will degrade performance");
    }

    return NSApplicationMain(argc, argv);
}


