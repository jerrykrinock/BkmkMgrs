#import <objc/message.h>
#import "Job.h"
#import "BkmxGlobals.h"
#import "Trigger.h"
#import "Syncer.h"
#import "Macster.h"
#import "NSObject+MoreDescriptions.h"
#import "NSManagedObject+Debug.h"
#import "NSString+SSYExtraUtils.h"
#import "NSDate+NiceFormats.h"

/* These must exactly match the @property symbol names.  There may be a more
 "introspective" way to do this, but I've done enough research today. */
NSString* const constKeyJobCause = @"cause";
NSString* const constKeyJobDocUuid = @"docUuid";
NSString* const constKeyJobAppName = @"appName";
NSString* const constKeyJobReason = @"reason";
NSString* const constKeyJobSerial = @"serial";
NSString* const constKeyJobSyncerUri = @"syncerUri";
NSString* const constKeyJobSyncerIndex = @"syncerIndex";
NSString* const constKeyJobTriggerUri = @"triggerUri";
NSString* const constKeyJobTriggerIndex = @"triggerIndex";
NSString* const constKeyJobTriggerType = @"triggerType";
NSString* const constKeyJobClidentifier = @"clidentifier";
NSString* const constKeyJobDateStagingWasSet = @"dateStagingWasSet";
NSString* const constKeyJobStagingFireDate = @"stagingFireDate";

@implementation Job

- (NSString*)serialString {
    return [Job serialStringForSerial:self.serial];
}

- (void)dealloc {
    [_cause release];
    [_docUuid release];
    [_appName release];
    [_syncerUri release];
    [_triggerUri release];
    [_clidentifier release];
    [_dateStagingWasSet release];
    [_stagingFireDate release];

    [super dealloc];
}

+ (NSString*)serialStringForSerial:(NSInteger)serial {
    return [NSString stringWithFormat:@"%04ld", (long)serial];
}

- (NSString*)description {
    NSString* staging;
    if (self.dateStagingWasSet) {
        staging = [NSString stringWithFormat:
                   NSLocalizedString(@"Staged at %@ to fire at %@", nil),
                   [self.dateStagingWasSet hourMinuteSecond],
                   [self.stagingFireDate hourMinuteSecond]];
    } else {
        staging = NSLocalizedString(@"(not staged)", nil);
    }
    return [NSString stringWithFormat:
            @"Job %@ for trig(type=%ld,idx=%ld,uri=%@) %@ of doc %@ of %@",
            self.serialString,
            (long)self.triggerType,
            (long)self.triggerIndex,
            [NSManagedObject truncatedIDForManagedObjectWithUri:self.triggerUri
                                                     entityName:constEntityNameTrigger],
            staging,
            [self.docUuid substringToIndex:4],
            self.appName];
}


#pragma mark  NSSecureCoding Protocol Support

/*!
 @details  This is required for NSSecureCoding in macOS 10.12 or later.
 */
+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:self.cause forKey:constKeyJobCause];
    [coder encodeObject:self.docUuid forKey:constKeyJobDocUuid];
    [coder encodeObject:self.appName forKey:constKeyJobAppName];
    [coder encodeInteger:self.reason forKey:constKeyJobReason];
    [coder encodeInteger:self.serial forKey:constKeyJobSerial];
    [coder encodeObject:self.syncerUri forKey:constKeyJobSyncerUri];
    [coder encodeInteger:self.syncerIndex forKey:constKeyJobSyncerIndex];
    [coder encodeObject:self.triggerUri forKey:constKeyJobTriggerUri];
    [coder encodeInteger:self.triggerIndex forKey:constKeyJobTriggerIndex];
    [coder encodeInteger:self.triggerType forKey:constKeyJobTriggerType];
    [coder encodeObject:self.clidentifier forKey:constKeyJobClidentifier];
    [coder encodeObject:self.dateStagingWasSet forKey:constKeyJobDateStagingWasSet];
    [coder encodeObject:self.stagingFireDate forKey:constKeyJobStagingFireDate];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    self = [super init] ;
    _cause = [[coder decodeObjectOfClass:[NSString class]
                                  forKey:constKeyJobCause] retain];
    _docUuid = [[coder decodeObjectOfClass:[NSString class]
                                    forKey:constKeyJobDocUuid] retain];
    _appName = [[coder decodeObjectOfClass:[NSString class]
                                    forKey:constKeyJobAppName] retain];
    _reason = [coder decodeIntForKey:constKeyJobReason];
    _serial = [coder decodeIntegerForKey:constKeyJobSerial];
    _syncerUri = [[coder decodeObjectOfClass:[NSString class]
                                      forKey:constKeyJobSyncerUri] retain];
    _syncerIndex = [coder decodeIntegerForKey:constKeyJobSyncerIndex];
    _triggerUri = [[coder decodeObjectOfClass:[NSString class]
                                       forKey:constKeyJobTriggerUri] retain];
    _triggerIndex = [coder decodeIntegerForKey:constKeyJobTriggerIndex];
    _triggerType = [coder decodeIntForKey:constKeyJobTriggerType];
    _clidentifier = [[coder decodeObjectOfClass:[NSString class]
                                         forKey:constKeyJobClidentifier] retain];
    _dateStagingWasSet = [[coder decodeObjectOfClass:[NSDate class]
                                              forKey:constKeyJobDateStagingWasSet] retain];
    _stagingFireDate = [[coder decodeObjectOfClass:[NSDate class]
                                            forKey:constKeyJobStagingFireDate] retain];
    return self;
}

@end
