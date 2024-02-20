#import "NSDictionary+ToStark.h"
#import "Extore.h"
#import "Startainer.h"

@interface NSNull (BkmxDefensive) 

/*!
 @brief     Defensive programming.  While testing BookMacster version 1.3.19,
 this method once got an NSNull while ixporting Firefox.  Could not reproduce.
*/
- (id)modelAsStarkInStartainer:(NSObject <Startainer>*)startainer ;
 
@end

@implementation NSNull (BkmxDefensive) 

- (id)modelAsStarkInStartainer:(NSObject <Startainer>*)startainer {
	NSLog(@"Internal Error 512-0981") ;
	return nil ;
}

@end



@implementation NSDictionary (ToStark)

- (Stark*)modelAsStarkInStartainer:(NSObject <Startainer>*)startainer {
	return [startainer starkFromExtoreNode:self] ;
}

- (NSArray*)childrenWithUppercaseC {
	return [self objectForKey:@"Children"] ;
}

- (NSArray*)childrenWithLowercaseC {
	return [self objectForKey:@"children"] ;
}

@end