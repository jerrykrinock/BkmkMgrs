#import <Foundation/Foundation.h>

@class Job;

/* The protocol that this service will vend as its API. This header file will
 also need to be visible to the process hosting the service. */
@protocol BkmxAgentProtocol

- (void)restartSyncWatchesThenDo:(void (^)(NSInteger errorCount))thenDo;

- (void)getJobsThenDo:(void (^)(NSArray<Job*>* jobsQueue))thenDo;

- (void)getWatchesReportThenDo:(void (^)(NSString* report))thenDo;

- (void)cancelStagedAndQueuedJobsForDocUuid:(NSString*)docUuid
                                     thenDo:(void (^)(NSInteger unstagedCount, NSInteger unqueuedCount))thenDo;

- (void)demoPresentUserNotificationWithTitle:(NSString*)title
                              alertNotBanner:(BOOL)alertNotBanner
                                    subtitle:(NSString*)subtitle
                                        body:(NSString*)body
                                   soundName:(NSString*)soundName
                                      thenDo:(void (^)(NSError*))thenDo;

@end
