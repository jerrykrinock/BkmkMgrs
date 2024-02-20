#import <Cocoa/Cocoa.h>

@class Stark ;

@interface Starki : NSObject {
	NSArray* m_starks ;
}

@property (retain, readonly) NSArray* starks ;
@property (readonly) Stark* stark ;

+ (Starki*)starkiWithStarks:(NSArray*)starks ;

@property (assign) NSArray* tags ;

@end
