#import "Watch.h"
#import "NSObject+MoreDescriptions.h"
#import "NSObject+DoNil.h"
#import "TriggHandler.h"
#import "Clientoid.h"

NSString* constKeyWatchType = @"watchType";
NSString* constKeySubject = @"subject";
NSString* constKeyThrottleInterval = @"throttleInterval";
NSString* constKeyRunAtLoad = @"runAtLoad";
/* Other constKey… are not here because they are in BkmxGlobals. */

@interface Watch ()

@property (assign) BOOL isActive;

@end


@implementation Watch

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    Watch* copy = [[Watch allocWithZone: zone] init];

    copy.watchType = self.watchType;
    copy.subject = self.subject;
    copy.docUuid = self.docUuid;
    copy.appName = self.appName;
    copy.clientoid = self.clientoid;
    copy.triggerUri = self.triggerUri;
    copy.syncerUri = self.syncerUri;
    copy.triggerIndex = self.triggerIndex;
    copy.syncerIndex = self.triggerIndex;
    copy.efficiently = self.efficiently;
    copy.throttleInterval = self.throttleInterval;
    copy.runAtLoad = self.runAtLoad;

    return copy ;
}

- (void)encodeWithCoder:(nonnull NSCoder*)coder {
    [coder encodeInteger:self.watchType forKey:constKeyWatchType];
    [coder encodeObject:self.subject forKey:constKeySubject];
    [coder encodeObject:self.docUuid forKey:constKeyDocUuid];
    [coder encodeObject:self.appName forKey:constKeyAppName];
    [coder encodeObject:self.clientoid forKey:constKeyClientoid];
    [coder encodeObject:self.syncerUri forKey:constKeySyncerUri];
    [coder encodeObject:self.triggerUri forKey:constKeyTriggerUri];
    [coder encodeInteger:self.syncerIndex forKey:constKeySyncerIndex];
    [coder encodeInteger:self.triggerIndex forKey:constKeyTriggerIndex];
    [coder encodeInteger:self.efficiently forKey:constKeyEfficiently];
    [coder encodeDouble:self.throttleInterval forKey:constKeyThrottleInterval];
    [coder encodeBool:self.runAtLoad forKey:constKeyRunAtLoad];
}

- (BOOL)isEqual:(Watch*)other {
    if (other == self) {
        return YES;
    }
    if (!other) {
        return NO;
    }
    if (![other isKindOfClass:[self class]]) {
        return NO;
    }

    return [self isEqualToWatch:other];
}

- (BOOL)isEqualToWatch:(Watch*)other {
    if (other.watchType != self.watchType) {
        return NO;
    }
    if (![NSObject isEqualHandlesNilObject1:other.subject
                                    object2:self.subject]) {
        return NO;
    }
    if (![NSObject isEqualHandlesNilObject1:other.docUuid
                                    object2:self.docUuid]) {
        return NO;
    }
    if (![NSObject isEqualHandlesNilObject1:other.appName
                                    object2:self.appName]) {
        return NO;
    }
    if (![NSObject isEqualHandlesNilObject1:other.clientoid
                                    object2:self.clientoid]) {
        return NO;
    }
    if (![NSObject isEqualHandlesNilObject1:other.syncerUri
                                    object2:self.syncerUri]) {
        return NO;
    }
    if (![NSObject isEqualHandlesNilObject1:other.triggerUri
                                    object2:self.triggerUri]) {
        return NO;
    }
    if (other.syncerIndex != self.syncerIndex) {
        return NO;
    }
    if (other.triggerIndex != self.triggerIndex) {
        return NO;
    }
    if (other.efficiently != self.efficiently) {
        return NO;
    }
    if (other.throttleInterval != self.throttleInterval) {
        return NO;
    }
    if (other.runAtLoad != self.runAtLoad) {
        return NO;
    }

    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = self.watchType;
    hash ^= self.subject.hash;
    hash ^= self.docUuid.hash;
    hash ^= self.appName.hash;
    hash ^= self.clientoid.hash;
    hash ^= self.syncerUri.hash;
    hash ^= self.triggerUri.hash;
    hash ^= self.syncerIndex * 1000;
    hash ^= self.triggerIndex * 1000;
    hash ^= self.efficiently ? 1234 : 5678;
    // throttle interval within 1/1000 second is close enough to be "equal".
    hash ^= (NSUInteger)ceil(self.throttleInterval * 1000);
    hash ^= self.subject.hash;

    return hash;
}

+ (NSString*)humanReadableType:(WatchType)type {
    switch (type) {
        case WatchTypeUndefined:
            return @"Undefined";
        case WatchTypeLogIn:
            return @"UserLogIn";
        case WatchTypePeriodic:
            return @"Periodic-";
        case WatchTypeAppQuit:
            return @"App-Quits";
        case WatchTypeScheduled:
            return @"Scheduled";
        case WatchTypePathTouched:
            return @"PathTouch";
        case WatchTypeLanding:
            return @"B-Landing";
        case WatchTypeAppLaunch:
            return @"AppLaunch";
    }
}

- (NSString*)humanReadableType {
    return [[self class] humanReadableType:self.watchType];
}

- (NSString*)shortDocUuid {
    NSString* answer;
    if (self.docUuid.length <= 3) {
        answer = self.docUuid;
    } else {
        answer = [self.docUuid substringToIndex:4];
    }

    answer = [answer copy];
    [answer autorelease];

    return answer;
}

- (NSString*)shortTriggerUri {
    if (!self.triggerUri) {
        return nil;
    }

    NSScanner* scanner = [[NSScanner alloc] initWithString:self.triggerUri];
    [scanner scanUpToString:@"//"
                 intoString:NULL];
    [scanner scanString:@"//"
             intoString:NULL];
    [scanner scanUpToString:@"/"
                 intoString:NULL];
    [scanner scanString:@"/"
             intoString:NULL];
    NSMutableString* mutant = [[self.triggerUri substringFromIndex:scanner.scanLocation] mutableCopy];
    [scanner release];
    [mutant replaceOccurrencesOfString:constEntityNameSyncer
                            withString:@"Sycr"
                               options:0
                                 range:NSMakeRange(0, mutant.length)];
    [mutant replaceOccurrencesOfString:constEntityNameTrigger
                            withString:@"Trig"
                               options:0
                                 range:NSMakeRange(0, mutant.length)];
    NSString* answer = [mutant copy];
    [mutant release];
    [answer autorelease];
    return answer;
}

- (NSString*)shortSubject {
    NSString* shortSubject;
    if (
        (self.watchType == WatchTypePathTouched)
        // This condition is defensive programming:
        && [self.subject respondsToSelector:@selector(last2PathComponents)]
        ) {
        NSString* path = (NSString*)(self.subject);
        shortSubject = [path last2PathComponents];
    } else {
        shortSubject = self.subject.shortDescription;
    }

    return shortSubject;
}

- (NSString*)description {
    return [NSString stringWithFormat:
            @"%@ subj=%@ app=%@ dUUID=%@ cli=%@ %@ inPr=%hhd actv=%hhd",
            self.humanReadableType,
            self.shortSubject,
            self.appName,
            self.shortDocUuid,
            self.clientoid.clidentifier,
            self.shortTriggerUri,
            self.inProgress,
            self.isActive];
}

- (NSString*)uniqueIdentifier {
    return [NSString stringWithFormat:
            @"%@:%@:%@:%@",
            self.humanReadableType,
            self.shortSubject,
            self.appName,
            self.shortDocUuid
            ];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder*)decoder {
    self = [super init] ;

    if (self) {
        _watchType = (WatchType)[decoder decodeIntegerForKey:constKeyWatchType];
        _subject = [[decoder decodeObjectOfClass:[NSString class]
                                          forKey:constKeySubject] retain];
        _docUuid = [[decoder decodeObjectOfClass:[NSString class]
                                          forKey:constKeyDocUuid] retain];
        _appName = [[decoder decodeObjectOfClass:[NSString class]
                                          forKey:constKeyAppName] retain];
        _clientoid = [[decoder decodeObjectOfClass:[Clientoid class]
                                            forKey:constKeyClientoid] retain];
        _syncerUri = [[decoder decodeObjectOfClass:[NSString class]
                                            forKey:constKeySyncerUri] retain];
        _triggerUri = [[decoder decodeObjectOfClass:[NSString class]
                                             forKey:constKeyTriggerUri] retain];
        _syncerIndex = [decoder decodeIntegerForKey:constKeySyncerIndex];
        _triggerIndex = [decoder decodeIntegerForKey:constKeyTriggerIndex];
        _efficiently = [decoder decodeIntegerForKey:constKeyEfficiently];
        _throttleInterval = [decoder decodeDoubleForKey:constKeyThrottleInterval];
        _runAtLoad = [decoder decodeBoolForKey:constKeyRunAtLoad];
    }

    return self;
}

- (void)dealloc {
    [_subject release];
    [_docUuid release];
    [_appName release];
    [_clientoid release];
    [_syncerUri release];
    [_triggerUri release];

    [super dealloc];
}

- (void)activate {
    self.isActive = YES;
}

- (void)deactivate {
    self.isActive = NO;
}

@end
