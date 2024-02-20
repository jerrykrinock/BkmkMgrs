#import "NSSet+CountedSet.h"


@implementation NSSet (CountedSet)

- (NSCountedSet*)countedSet {
	return [[[NSCountedSet alloc] initWithSet:self] autorelease] ;
}

@end
