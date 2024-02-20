#import "BkmxWatch.h"
#import "Watch.h"
#import "SSYRecurringDate.h"

extern NSString* constKeyWatchType;
extern NSString* constKeySubject;
// NSString* constKeyDocUuid = @"docUuid";  // defined in BkmxGlobals
// NSString* constKeyAppName = @"appName";  // defined in BkmxGlobals
NSString* constKeyTriggerOrSyncerUri = @"triggerOrSyncerUri";
extern NSString* constKeyThrottleInterval;
extern NSString* constKeyRunAtLoad;

@interface BkmxWatch ()

@end


@implementation BkmxWatch

- (nonnull id)copyAsWatch {
    Watch* copy = [Watch new];

    copy.watchType = self.watchType;
    switch (copy.watchType) {
        case WatchTypePeriodic:;
            NSNumber* number = (NSNumber*)self.subject;
            if ([number respondsToSelector:@selector(integerValue)]) {
                copy.subject = [NSString stringWithFormat:@"%ld", [(NSNumber*)number integerValue]];
            }
            break;
        case WatchTypeAppQuit:
        case WatchTypePathTouched:
        case WatchTypeAppLaunch:;
            NSString* string = (NSString*)self.subject;
            if ([string isKindOfClass:[NSString class]]) {
                copy.subject = string;
            }
            break;
        case WatchTypeScheduled:;
            SSYRecurringDate* recurringDate = (SSYRecurringDate*)self.subject;
            if ([recurringDate isKindOfClass:[SSYRecurringDate class]]) {
                copy.subject = [recurringDate stringRepresentation];
            }
            break;
        case WatchTypeUndefined:
        case WatchTypeLogIn:
        case WatchTypeLanding:
            copy.subject = nil;
            break;
    }
    copy.docUuid = self.docUuid;
    copy.appName = self.appName;
    copy.triggerUri = self.triggerOrSyncerUri;  // <-- Different names
    copy.throttleInterval = self.throttleInterval;
    copy.runAtLoad = self.runAtLoad;

    return copy ;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super init] ;

    if (self) {
        _watchType = (WatchType)[decoder decodeIntegerForKey:constKeyWatchType];
        _subject = [[decoder decodeObjectOfClass:[NSObject class] forKey:constKeySubject] retain];
        _docUuid = [[decoder decodeObjectOfClass:[NSString class]
                                          forKey:constKeyDocUuid] retain];
        _appName = [[decoder decodeObjectOfClass:[NSString class]
                                          forKey:constKeyAppName] retain];
        _triggerOrSyncerUri = [[decoder decodeObjectOfClass:[NSString class]
                                                     forKey:constKeyTriggerOrSyncerUri] retain];
        _throttleInterval = [decoder decodeDoubleForKey:constKeyThrottleInterval];
        _runAtLoad = [decoder decodeBoolForKey:constKeyRunAtLoad];
    }

    return self;
}

/* Not used any more but needed to conform to procotol NSCoding */
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInteger:self.watchType forKey:constKeyWatchType];
    [coder encodeObject:self.subject forKey:constKeySubject];
    [coder encodeObject:self.docUuid forKey:constKeyDocUuid];
    [coder encodeObject:self.appName forKey:constKeyAppName];
    [coder encodeObject:self.triggerOrSyncerUri forKey:constKeyTriggerOrSyncerUri];
    [coder encodeDouble:self.throttleInterval forKey:constKeyThrottleInterval];
    [coder encodeBool:self.runAtLoad forKey:constKeyRunAtLoad];
}

- (void)dealloc {
    [_subject release];
    [_docUuid release];
    [_appName release];
    [_triggerOrSyncerUri release];

    [super dealloc];
}

@end
