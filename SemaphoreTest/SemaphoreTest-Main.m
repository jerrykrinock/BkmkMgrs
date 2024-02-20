#import "SSYSemaphore.h"
#import <Carbon/Carbon.h>
#import <unistd.h>

void seedRandomNumberGenerator() {
    double fseed = [[NSDate date] timeIntervalSinceReferenceDate] ;
    //    Remove integer part to base it on the current fraction of a second
    fseed -= (int)fseed ;
    //    0 <= fseed < 1.0
    fseed *= 0x7fffffff ;
    int seed = (int)fseed ;
    //    0 <= seed <= 2^31-1
    srandom(seed) ;
}

float randomPeriod(float min, float max) {
    float intervalMilliseconds = (max - min)*1000 ;
    int randomMilliseconds = random() % (int)intervalMilliseconds ;
    return min + randomMilliseconds/1000.0 ;
}

@interface Doer : NSObject {
    int nWorks ;
    NSString* m_key ;
}

@property (retain) NSString* key ;

@end


@implementation Doer

@synthesize key = m_key ;

+ (NSString*)sharedTextFilePath {
    NSString* path = NSHomeDirectory() ;
    path = [path stringByAppendingPathComponent:@"Desktop"] ;
    path = [path stringByAppendingPathComponent:@"SemaphoreTestFile.txt"] ;
    return path ;
}

- (void)dealloc {
    [m_key release] ;
    
    [super dealloc] ;
}

- (void)doWork {
    NSError* error = nil  ;
    
    BOOL ok = [SSYSemaphore acquireWithKey:[self key]
                                    setKey:[self key]
                                    forPid:[[NSProcessInfo processInfo] processIdentifier]
                            initialBackoff:1.0
                             backoffFactor:1.35
                                maxBackoff:10.0
                                   timeout:15.0
                                 timeLimit:30.0
                                   error_p:&error] ;
    if (ok) {
        [[NSSound soundNamed:@"Tink"] play] ;  // beginning work
        NSLog(@"Got semaphore, working for %@", [self key]) ;
        ok = [[self key] writeToFile:[[self class] sharedTextFilePath]
                          atomically:YES
                            encoding:NSUTF8StringEncoding
                               error:&error] ;
        
        if (!ok) {
            NSLog(@"Error 182-9282: %@", error) ;
        }
        
        sleep(randomPeriod(1.0, 2.0)) ; // Time required to do work
        nWorks++ ;
        
        error = nil ;
        NSString* readKey = [[NSString alloc] initWithContentsOfFile:[[self class] sharedTextFilePath]
                                                            encoding:NSUTF8StringEncoding
                                                               error:&error] ;
        
        if (![readKey isEqualToString:[self key]]) {
            // Another process must have written to the shared text file path
            // while we were holding the semaphore.  If this ever happens,
            // there is a BUG in SSYSemaphore.  The whole idea of SSYSemaphore
            // is to prevent such collisions!
            NSLog(@"COLLISION!!  Expected:%@  Read:%@", [self key], readKey) ;
            [[NSSound soundNamed:@"Submerge"] play] ;
        }
        
        [readKey release] ;
        
        if (error) {
            NSLog(@"Error 183-9383: %@", error) ;
        }

        
        NSLog(@"Work done.  Clearing semaphore.") ;
        [[NSSound soundNamed:@"Pop"] play] ;  // ending work
        [SSYSemaphore clearError_p:NULL] ;
        sleep(randomPeriod(0.2, 2.0)) ; // Rest after work, give other processes a chance
    }
    else {
        if ([error code] == ETIME) {
            // Timed out
            NSLog(@"Retries timed out.  Do some recovery??") ;
        }
        else if (error) {
            // Some unexpected error
            NSLog(@"Error 184-9484: %@", [error description]) ;
        }
        [[NSSound soundNamed:@"Basso"] play] ;
    }
    
    // Wait a random time and then try more work
    [NSTimer scheduledTimerWithTimeInterval:randomPeriod(2, 5)
                                     target:self
                                   selector:@selector(doWork)
                                   userInfo:nil
                                    repeats:NO] ;
}

@end


int main(int argc, const char *argv[]) {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
    seedRandomNumberGenerator() ;
    Doer* doer = [[Doer alloc] init] ;
    int bytes = 0 ;
    for (int i=0; i<4; i++) {
        int byte = (int)random() ;
        // For readability, use only lowercase ASCII characters a-z:
        byte = (byte % 26) + 97 ;
        bytes += (byte << 8*i) ;
    }
    NSData* data = [NSData dataWithBytes:&bytes
                                  length:sizeof(int)] ;
    NSString* key = [[NSString alloc] initWithData:data
                                          encoding:NSASCIIStringEncoding] ;
    NSLog(@"Key for this tool: %@", key) ;
    [doer setKey:key] ;
    [key release] ;
    [doer doWork] ;
    
    [[NSRunLoop currentRunLoop] run] ;
    
    [pool release] ;
    return 0 ;
}

