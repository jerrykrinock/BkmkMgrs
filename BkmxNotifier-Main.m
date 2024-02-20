#include <sys/ptrace.h>
#import "AgentPerformer.h"

static void handleSIGTERM(int signum) {
    NSLog(@"Process ending life cuz SIGTERM");

    exit(0) ;
}

int main(int argc, const char *argv[]) {
    
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


