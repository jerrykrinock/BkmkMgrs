#import <Cocoa/Cocoa.h>
#import "LogEntry.h"

extern NSString* const constKeySerialNumber ;

@class Starkoid ;

@interface IxportLog : LogEntry {
}

@property (retain) NSString* displayStatistics ;
@property (retain) NSNumber* errorCode ;
@property (retain) NSSet* starkoids ;
@property (retain) NSNumber* serialNumber ;
@property (retain) NSString* whoDo ;

- (void)addStarkoidsObject:(Starkoid*)value ;

/*!
 @brief    A human-readable title

 @details  Subclasses override this to append additional info
*/
- (NSString*)title ;

@end
