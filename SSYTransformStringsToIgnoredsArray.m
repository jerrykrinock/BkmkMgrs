#import "SSYTransformStringsToIgnoredsArray.h"
#import "BkmxIgnoredPrefix.h"

@implementation SSYTransformStringsToIgnoredsArray

+ (Class)transformedValueClass {
    return [NSMutableArray class] ;
}

+ (BOOL)allowsReverseTransformation {
    return YES ;
}

- (id)transformedValue:(id)stringsArray {
	NSMutableArray* ignoredPrefixesArray = [[NSMutableArray alloc] init] ;
	NSString* s ;
	NSEnumerator* e = [stringsArray objectEnumerator] ;
	while ((s = [e nextObject])) {
		BkmxIgnoredPrefix* bip = [[BkmxIgnoredPrefix alloc] init] ;
		[bip setString:s] ;
		[ignoredPrefixesArray addObject:bip] ;
		[bip release] ;
	}
	
	return [ignoredPrefixesArray autorelease] ;
}

- (id)reverseTransformedValue:(id)bipArray {
	NSMutableArray* stringsArray = [[NSMutableArray alloc] init] ;
	BkmxIgnoredPrefix* bip ;
	NSEnumerator* e = [bipArray objectEnumerator] ;
	while ((bip = [e nextObject])) {
		NSString* s = [bip string] ;
		[stringsArray addObject:s] ;
	}
	
	return [stringsArray autorelease] ;
}


@end
