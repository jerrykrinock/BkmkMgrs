#import <Cocoa/Cocoa.h>
#import "SSYManagedObject.h"

extern NSString* const constKeyMessage ;
extern NSString* const constKeyTimestamp ;


@interface LogEntry : SSYManagedObject {
}

@property (retain) NSNumber* processType ;
@property (retain) NSNumber* processId ;
@property (retain) NSDate* timestamp ;

- (NSString*)formattedDate ;
- (NSString*)processDisplayType ;

@end
