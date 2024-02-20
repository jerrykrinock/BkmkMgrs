#import <Foundation/Foundation.h>
#import "BkmxGlobals.h"

/*!
 @brief    The original "Watch" class

 @details  This class has been replaced by class Watch.  But it is needed for
 conversion of existing objects archived in User Defaults, during the first
 run of BkmkMgrs 2.9.1 or later, for users who update from BkmkMgrs 2.9.0.
 */
@class Watch;

@interface BkmxWatch : NSObject <NSCoding>

@property (atomic, assign) WatchType watchType;
@property (atomic, copy) NSObject* subject;
@property (atomic, copy) NSString* docUuid;
@property (atomic, copy) NSString* appName;
@property (atomic, copy) NSString* triggerOrSyncerUri;
@property (atomic, assign) NSTimeInterval throttleInterval;
@property (atomic, assign) BOOL runAtLoad;

- (Watch*)copyAsWatch;

@end
