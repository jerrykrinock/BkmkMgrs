#import "SSYOtherAppObserver.h"
#include <sys/ptrace.h>

int main(int argc, const char *argv[]) {
	
#ifndef DEBUG
	//  See http://www.seoxys.com/3-easy-tips-to-prevent-a-binary-crack/
	ptrace(PT_DENY_ATTACH, 0, 0, 0);
#endif
	
	// #define KEEP_ZOMBIES
#ifdef KEEP_ZOMBIES
	setenv("NSZombieEnabled", "YES", 1) ;
	setenv("NSAutoreleaseFreedObjectCheckEnabled", "YES", 1) ;	
#endif
	
	if (getenv("NSZombieEnabled")) {
		NSLog (@"NSZombieEnabled for debugging.  Will degrade performance") ;
	}
	
	if (getenv("NSAutoreleaseFreedObjectCheckEnabled")) {
		NSLog (@"NSAutoreleaseFreedObjectCheckEnabled for debugging. Will degrade performance") ;
	}
    
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
	
	// Create a run loop
	NSRunLoop* runLoop = [NSRunLoop currentRunLoop] ;

	SSYOtherAppObserver* otherAppObserver = [[SSYOtherAppObserver alloc] init] ;
	
	[runLoop run] ;
	
	[otherAppObserver release] ;
	[pool release] ;
	
	return 0 ;
}
