#import "BkmxAgentXPCListener.h"
#import "Watcher.h"
#import "BkmxBasis.h"
#import "AgentPerformer.h"
#import "Job.h"
#import "ExtoreSafari.h"
#import "BkmxNotifierCaller.h"


static BkmxAgentXPCListener* sharedListener = nil;


@implementation BkmxAgentXPCListener

+ (BkmxAgentXPCListener*)sharedListener {
    @synchronized(self) {
        if (!sharedListener) {
            sharedListener = [[BkmxAgentXPCListener alloc] init];
        }
    }

    return sharedListener;
}

- (instancetype)init {
    /* LaunchServices automatically registers a mach service of the same
     name as our bundle identifier.  */
    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
    self = [super initWithMachServiceName:bundleId];
    self.delegate = self;
    [[BkmxBasis sharedBasis] logFormat:@"Did init Mach Service %@ in pid %d", bundleId, getpid()];

    return self;
}

- (BOOL)            listener:(NSXPCListener *)listener
   shouldAcceptNewConnection:(NSXPCConnection *)newConnection {
    /* This method is called by the NSXPCListener to filter/configure
     incoming connections. */
    NSXPCInterface* interface = [NSXPCInterface interfaceWithProtocol:@protocol(BkmxAgentProtocol)];
    /* Next line is necessary because we pass a custom class (Job) via XPC */
    [interface setClasses:[NSSet setWithObjects: [NSArray class], [NSString class], [NSDate class], [Job class], nil]
              forSelector:@selector(getJobsThenDo:)
            argumentIndex:0
                  ofReply:YES];
    newConnection.exportedInterface = interface;
    newConnection.exportedObject = self;

    /* Start processing incoming messages */
    [newConnection resume];

    return YES;
}



#pragma mark BkmxAgentProtocol support

- (void)restartSyncWatchesThenDo:(void (^)(NSInteger errorCount))thenDo {
    NSMutableArray* errorCodes = [NSMutableArray new];
    [[Watcher sharedWatcher] realizeWatches_errorCodes:errorCodes];
    thenDo(errorCodes.count);
    [errorCodes release];
}

- (void)getJobsThenDo:(void (^)(NSArray<Job*>* jobQueue))thenDo {
    thenDo([[AgentPerformer sharedPerformer] jobQueue]);
}

- (void)getWatchesReportThenDo:(void (^)(NSString*))thenDo {
    NSMutableString* report = [NSMutableString new];
    [report appendString:[ExtoreSafari fullDiskAccessReport]];
    [report appendString:@"\n"];
    [report appendString:[[Watcher sharedWatcher] lastRealizedWatchesReport]];
    [report appendString:@"\n"];
    [report appendString:[[Watcher sharedWatcher] currentWatchesReport]];
    [report appendString:@"\n"];
    [report appendString:[[Watcher sharedWatcher] currentBatonsReport]];
    NSString* answer = [report copy];
    [report release];
    thenDo(answer);
    [answer release];
}

- (void)cancelStagedAndQueuedJobsForDocUuid:(NSString*)docUuid
                                     thenDo:(void (^)(NSInteger unstagedCount, NSInteger unqueuedCount))thenDo {
    NSInteger unstagedCount = [[AgentPerformer sharedPerformer] cancelDoingDelayedJobsWithDocUuid:docUuid];
    NSInteger unqueuedCount = [[AgentPerformer sharedPerformer] cancelDoingQueuedJobsWithDocUuid:docUuid];
    thenDo(unstagedCount, unqueuedCount);
}

- (void)demoPresentUserNotificationWithTitle:(NSString*)title
                              alertNotBanner:(BOOL)alertNotBanner
                                    subtitle:(NSString*)subtitle
                                        body:(NSString*)body
                                   soundName:(NSString*)soundName
                                      thenDo:(void (^)(NSError*))thenDo {
    NSError* notifyingError = nil;
    [BkmxNotifierCaller presentUserNotificationTitle:title
                                      alertNotBanner:alertNotBanner
                                            subtitle:subtitle
                                                body:body
                                           soundName:soundName
                                          actionDics:nil
                                             error_p:&notifyingError];
    thenDo(notifyingError);
}


@end
