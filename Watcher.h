#import <Foundation/Foundation.h>

@class SSYPathObserver;
@class Watch;
@class IxportBaton;

NS_ASSUME_NONNULL_BEGIN

__attribute__((visibility("default"))) @interface Watcher : NSObject {
    NSMutableSet <NSTimer*> * _timers;
    NSMutableSet <NSString*> * _observeAppLaunchBundleIdentifiers;
    NSMutableSet <NSString*> * _observeAppQuitBundleIdentifiers;
    NSMutableSet <SSYPathObserver*> * _pathObservers;
    NSMutableDictionary* _lastTriggerDates;
    NSMutableDictionary <NSString*, IxportBaton*> * _ixportsInProgessBatons;
    NSMutableSet <Watch*> * _watchesInHandling;
    NSString* _lastRealizedWatchesReport;
}

+ (Watcher*)sharedWatcher;

/*!
 @details  Returns the number of errrors which occurred
 */
- (void)realizeWatches_errorCodes:(NSMutableArray*)errorCodes;

@property (readonly) NSString* lastRealizedWatchesReport;
@property (readonly) NSMutableSet <Watch*> * watchesInHandling;
@property (readonly) NSInteger watchesDoneHandlingCount;

- (NSString*)currentWatchesReport;
- (NSString*)currentBatonsReport;

- (void)doneHandlingWatch:(Watch*)watch;

- (BOOL)claimIxportBatonForClidentifier:(NSString*)clidentifier
                              jobSerial:(NSInteger)jobSerial
                                canWait:(BOOL)canWait;

- (void)unclaimIxportBatonForClidentifier:(NSString*)clidentifier
                                jobSerial:(NSInteger)jobSerial;


@end

NS_ASSUME_NONNULL_END
