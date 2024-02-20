#import <Cocoa/Cocoa.h>


@class Stark ;
@protocol Startainer ;


@interface NSDictionary (ToStark)

- (Stark*)modelAsStarkInStartainer:(NSObject <Startainer>*)startainer ;

- (NSArray*)childrenWithUppercaseC ;

- (NSArray*)childrenWithLowercaseC ;

@end

