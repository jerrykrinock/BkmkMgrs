#import "BkmxBasis+OSLog.h"
#import <os/log.h>
#import "NSBundle+MainApp.h"

@implementation BkmxBasis (OSLog)

- (void)consoleLogAsError:(BOOL)markAsError
                   format:(NSString*)format, ... {
    static dispatch_once_t onceToken;
    static os_log_t logger;
    
    dispatch_once(&onceToken, ^{
        NSString* subsystemLabel = [[NSBundle mainAppBundle] bundleIdentifier];
        NSString* categoryLabel = [[NSBundle mainBundle] bundleIdentifier];
        if (!subsystemLabel) {
            subsystemLabel = @"Bkmx-no-subsystem";
        }
        if (!categoryLabel) {
            categoryLabel = @"Bkmx-no-category";
        }
        // This creates a thread-safe object
        logger = os_log_create(
                               subsystemLabel.UTF8String,
                               categoryLabel.UTF8String
                               );
    });
    
    va_list ap;
    va_start(ap, format);
    NSString *logMessage = [[NSString alloc] initWithFormat:format arguments:ap];
    va_end(ap);
    
    /* For God's sake, format all of our messages formatted as public, so we
     don't get any annoying "PRIVATE" blacked-out messages in the console. */
    if (markAsError) {
        os_log_error(logger, "%{public}@", logMessage);
    } else {
        /* We like the looks of OS_LOG_TYPE_DEFAULT better than OS_LOG_TYPE_INFO */
        os_log(logger, "%{public}@", logMessage);
    }
}



@end
