#import "ProfileInfoCache.h"
#import "NSDate+NiceFormats.h"

@implementation  ProfileInfoCache

@synthesize displayProfileNames = m_displayProfileNames ;
@synthesize shouldSuffix = m_shouldSuffix ;
@synthesize lastUpdate = m_lastUpdate ;

- (NSString*)description {
    return [NSString stringWithFormat:
            @"%@ state:\n"
            @"displayProfileNames: %@\n"
            @"shouldSuffix: %hhd\n"
            @"lastUpdate: %@",
            [super description],
            [self displayProfileNames],
            [self shouldSuffix],
            [[NSDate dateWithTimeIntervalSinceReferenceDate:[self lastUpdate]] geekDateTimeString]] ;
}

@end

