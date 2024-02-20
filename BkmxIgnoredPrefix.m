#import "BkmxIgnoredPrefix.h"
#import "NSString+LocalizeSSY.h"

@implementation BkmxIgnoredPrefix

@synthesize phrase ;
@synthesize hasTrailingSpace ;

+ (NSSet*)keyPathsForValuesAffectingString {
	return [NSSet setWithObjects:
			@"phrase",
			@"hasTrailingSpace",
			nil] ;
}

- (NSString*)string {
	NSString* s = [[self hasTrailingSpace] boolValue] 
	? [[self phrase] stringByAppendingString:@" "]
	: [self phrase] ;
	
	return s ;
}

- (void)setString:s {
	BOOL hasTrailingSpace_ = NO ;
	
	if ([s hasSuffix:@" "]) {
		s = [s substringToIndex:([s length] - 1)] ;
		hasTrailingSpace_ = YES ;
	}
	
	[self setPhrase:s] ;
	[self setHasTrailingSpace:[NSNumber numberWithBool:hasTrailingSpace_]] ;
}

// This init override is necessary because, without it, when the user clicks the "+" button
// and the array controller comes here to create a new object, the newly-created object
// will return nil for -phrase and -hasTrailingSpace, raising an 'attempt to insert nil
// object into array' exception.  Hmmm... doesn't quite make sense, because the 
// BkmxIgnoredPrefix object itself should be what is inserted, and it is not nil.
// But, oh, well, it works.  Need to give the "untitled" name also, anyhow.
- (id) init {
	self = [super init];
	if (self != nil) {
		[self setString:[NSString localize:@"untitled"]] ;
	}
	return self;
}

- (NSString*)description {
	return [NSString stringWithFormat:@"BkmxIgnoredPrefix: \"%@\"", [self string]] ;
}

- (void) dealloc {
	[phrase release] ;
	[hasTrailingSpace release] ;
	
	[super dealloc];
}

@end

