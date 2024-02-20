#import "BkmxGlobals.h"

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        NSString* scheme = constBkmxUrlScheme ;
        NSString* bundleId = @"com.sheepsystems.Sheep-Sys-UrlHandler" ;
        OSStatus status = LSSetDefaultHandlerForURLScheme(
                                                          (__bridge CFStringRef)scheme,
                                                          (__bridge CFStringRef)bundleId
                                                          ) ;
        NSString* msg ;
        NSInteger level ;
        if (status == noErr) {
            msg = @"Your Launch Services database has agreed to launch "
            "BookMacster's URL Handler when the BookMacsterizer bookmarklet "
            "is clicked." ;
            level = kCFUserNotificationPlainAlertLevel ;
            
            NSArray* handlers = (__bridge NSArray*)CFPreferencesCopyAppValue (
                                                                              CFSTR("LSHandlers"),
                                                                              CFSTR("com.apple.LaunchServices")
                                                                              ) ;
           NSLog(@"handlers:\n%@", handlers) ;
           for (NSDictionary* handler in handlers) {
                if ([[handler objectForKey:@"LSHandlerURLScheme"] isEqualToString:scheme]) {
                    msg = [msg stringByAppendingFormat:
                           @"\n\nand then we found the result:\n%@",
                           handler] ;
                    // Don't break in case there is >1 (conflicting entries)
                }
            }
        }
        else {
            msg = [NSString stringWithFormat:@"Sorry, an error occurred.  "
                   "OSStatus=%ld", (long)status] ;
            level = kCFUserNotificationCautionAlertLevel ;
        }
        
		CFUserNotificationDisplayAlert (
										0,  // no timeout
										level,
										NULL,
										NULL,
										NULL,
										CFSTR("Fix Result"),
										(__bridge CFStringRef)msg,
										NULL,
										NULL,
										NULL,
										NULL) ;
    }

	return 0 ;
}