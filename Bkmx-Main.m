#import <Cocoa/Cocoa.h>
#include <sys/ptrace.h>

#if 0
#define SWIZZLE_NSLOG 1
#endif

#if SWIZZLE_NSLOG

extern void _NSSetLogCStringFunction(void(*)(const char *, unsigned, BOOL));

static void SSYDebugLogCString(const char *message, unsigned length,
                               BOOL withSyslogBanner) {
    fprintf(stderr, "Hey!! %s\n", message);
}

#endif


int main(int argc, const char *argv[]) {

#ifndef DEBUG
#if 0
#warning a Building Release Build which is Attachable for Debugging
#else
	//  See http://www.seoxys.com/3-easy-tips-to-prevent-a-binary-crack/
	ptrace(PT_DENY_ATTACH, 0, 0, 0);
#endif
#endif

	if (getenv("NSZombieEnabled")) {
		NSLog (@"NSZombieEnabled for debugging.  Will degrade performance") ;
	}
	
	if (getenv("NSAutoreleaseFreedObjectCheckEnabled")) {
		NSLog (@"NSAutoreleaseFreedObjectCheckEnabled for debugging. Will degrade performance") ;
	}
    
#if DEBUG
    if (getenv("MallocPreScribble")) {
        NSLog (@"MallocPreScribble is on") ;
    }
    if (getenv("MallocScribble")) {
        NSLog (@"MallocScribble is on") ;
    }
#endif
    
#if SWIZZLE_NSLOG
    _NSSetLogCStringFunction(SSYDebugLogCString);
#endif
    
    return NSApplicationMain(argc, argv);
}
