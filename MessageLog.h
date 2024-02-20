#import <Cocoa/Cocoa.h>
#import "LogEntry.h"

@interface MessageLog : LogEntry {
}

@property (retain) NSString* message ;

- (NSString*)stringRepresentation ;

@end
