#import <Foundation/Foundation.h>
#import "Chromessenger.h"

/*!
 @brief    Tool launched by a browser
 
 @details  Messages come from the browser as stdin.  Messages are passed to the
 browser from this tool as stdout.
 
 To test this tool:

 If you want to test deeper than -[Chromessenger handleStdinData:] each message
 sent on stdin must begin with a 4-byte `length` word, as per the Native
 Messaging API:
 https://developer.chrome.com/apps/nativeMessaging

 You may send EOF to stdin in either of two ways…
 * Pipe some data from another program, example:  echo Bird | ./Chromessenger
 * Invoke the program with no stdin, just .Chromessenger.  Then after you
 are done inputting std interatively, type ^D (control-D).  Terminal.app
 makes an EOF when you type ^D.
 */

int main(int argc, const char * argv[]) {
    @autoreleasepool {
#if 0
        NSMutableArray* receives = [[NSMutableArray alloc] init] ;
        NSInteger nBytes = 0 ;
        while(YES) {
            getchar() ;
            if (nBytes >= 131072) {
                NSLog(@"Breaking because nBytes = %ld", (long)nBytes) ;
                break ;
            }
            NSString* s = [[NSString alloc] initWithFormat:@"%018.09f", [[NSDate date] timeIntervalSinceReferenceDate]] ;
            [receives addObject:s] ;
            [s release] ;
            nBytes++ ;
        }
        NSString* result = [receives description] ;
        NSError* error = nil ;
        [result writeToFile:@"/Users/jk/Desktop/Temp/Results.txt"
                 atomically:YES
                   encoding:NSUTF8StringEncoding
                      error:&error] ;
        syslog(LOG_NOTICE, "Done!!!  error = %@", [[error description] UTF8String]) ;
        [receives release] ;
        exit(0) ;
#endif        
        @autoreleasepool {
            /* -[NSFileManager waitForDataInBackgroundAndNotify] docs say I need
             an "active run loop".  I don't know what they mean by "active", but
             the following seems to work. */
            NSDate* verySoon = [NSDate dateWithTimeIntervalSinceNow:0.01] ;
            [[NSRunLoop mainRunLoop] runUntilDate:verySoon] ;

            NSFileHandle* input = [NSFileHandle fileHandleWithStandardInput] ;
            [input waitForDataInBackgroundAndNotify] ;
            NSNotificationCenter* dc = [NSNotificationCenter defaultCenter] ;
            [dc addObserverForName:NSFileHandleDataAvailableNotification
                            object:input
                             queue:nil
                        usingBlock:^(NSNotification* note) {
                            NSFileHandle* input ;
                            input = [NSFileHandle fileHandleWithStandardInput] ;
                            NSData* data = [input availableData];
                            /* data will never exceed 4K bytes.  See comment above
                             -[Chromessenger handleStdinData:]. */
                            if ([data length] > 0) {
                                [[Chromessenger sharedMessenger] handleStdinData:data] ;
                                [input waitForDataInBackgroundAndNotify] ;
                            }
                            else {
                                // Must have received end-of-file (EOF)
                                syslog(LOG_NOTICE, "Exitting due to EOF.  This should only happen when extension unloads.\n") ;
                                exit(0) ;
                            }
                        }] ;
        }
        [[NSRunLoop mainRunLoop] run] ;
    }
    
    syslog(LOG_ERR, "This exit should never happen!\n") ;
    return 0 ;
}


#if 0
NSString* saying = [[NSString alloc] initWithData:data
                                         encoding:NSUTF8StringEncoding] ;
NSTask *task = [[NSTask alloc] init];
task.launchPath = @"/usr/bin/say";
task.arguments  = @[@"-v", @"vicki", saying];
[task launch] ;

// Handle ^C to kill the process
dispatch_source_t sigHandler ;
sigHandler = dispatch_source_create(
                                    DISPATCH_SOURCE_TYPE_SIGNAL,
                                    SIGINT,
                                    0,
                                    dispatch_get_main_queue()) ;
dispatch_source_set_event_handler (
                                   sigHandler,
                                   ^{
                                       NSLog(@"Did get ^C") ;
                                       CFRunLoopStop(CFRunLoopGetMain()) ;
                                   }) ;
dispatch_resume(sigHandler) ;
#endif
