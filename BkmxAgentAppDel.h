#import <Cocoa/Cocoa.h>
#import "BkmxAgentProtocol.h"

@interface BkmxAgentAppDel : NSObject <NSApplicationDelegate>

@property (assign) NSInteger completedSyncJobSerial;

- (void)loadAndRealizeWatches_errorCodes:(NSMutableArray*)errorCodes;

/*!
 @brief    Reboots the current process, which must be a BkmxAgent XPC Service

 @details  Reboot is done by killing the curent process and relying on launchd
 to relaunch it.

 This method is called

 (1) after completing a sync job, with actual work, to eliminate memory leaks
 (2) shortly after waking from sleep, to recreate any kqueues which may have
 died
 */
- (void)rebootMeIfNonePendingLoggingJobSerial:(NSInteger)jobSerial;

@end

