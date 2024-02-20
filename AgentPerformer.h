#import <Cocoa/Cocoa.h>
#import <UserNotifications/UserNotifications.h>
#import "BkmxGlobals.h"
#import "SSYErrorAlertee.h"

//#import <Growl-WithInstaller/GrowlApplicationBridge.h>

@class Syncer;
@class BkmxDoc;
@class Job;
@class Trigger;

__attribute__((visibility("default"))) @interface AgentPerformer : NSObject <SSYErrorAlertee> {
    NSMutableArray* _jobQueue;
    NSMutableSet* _queueingDelayTimers;
}

+ (AgentPerformer*)sharedPerformer ;

@property (readonly) NSArray<Job*>* jobQueue;
@property (readonly) NSInteger jobsDoneCount;

@property (retain, readonly) NSError* error;
@property NSInteger dupesCount;
@property NSInteger activeAgentIndex;
@property (readonly) NSInteger nowWorkingJobSerial;

- (void)finishJob:(Job*)job
          bkmxDoc:(BkmxDoc*)bkmxDoc;

- (NSString*)alertTitle;

- (void)registerError:(NSError*)error;


/*!
 @brief    Adds a job to the queue after a specified delay

 @details  If the delay is > 0.0, this also called "staging" the job.

 In actual operation, the queue is almost always empty, and the
 job is done immediately after the specified `delay`.  But not always!
 */

- (void)queueJob:(Job*)job
      afterDelay:(NSTimeInterval)delay;

- (NSInteger)cancelDoingDelayedJobsWithSyncerUri:(NSString*)syncerUri;
- (NSInteger)cancelDoingDelayedJobsWithDocUuid:(NSString*)docUuid;
- (NSInteger)cancelDoingQueuedJobsWithDocUuid:(NSString*)docUuid;

+ (CFURLRef)iconUrl;

/*!
 @param    ignoreLimit  As of BookMacster 1.11, I am passing NO in all
 invocations of this method.  It could be useful as an AppleScript
 command parameter, though, so I am not deleting the parameter.
 @param    job  important info, including the uris with which macster, syncer
 and trigger will be fetched; also needed o stage a do over if necessary
 For performance types other than BkmxPerformanceTypeAgent, you will
 likely have created a job serial but won't have a job.
 */
- (void)performOverrideDeference:(BkmxDeference)overrideDeference
                     ignoreLimit:(BOOL)ignoreLimit
                             job:(Job*)job
                 performanceType:(BkmxPerformanceType)performanceType
                    errorAlertee:(NSObject <SSYErrorAlertee> *)errorAlertee;

+ (NSString*)notificationTitleForStaged;
+ (NSString*)notificationTitleForStarted;
+ (NSString*)notificationTitleForSuccess;
+ (NSString*)notificationTitleForFailure;

- (BkmxDocumentStatusInMainApp)checkIfOpenInMainAppDocUuid:(NSString *)docUuid
                                                 jobSerial:(NSInteger)jobSerial;

@end
