#import "TransformNullToNeverVerified.h"
#import "NSString+LocalizeSSY.h"

@implementation TransformNullToNeverVerified

+ (Class)transformedValueClass {
	return [NSString class] ;
}

+ (BOOL)allowsReverseTransformation {
	return NO ;
}

- (id)transformedValue:(id)string {
	NSString* answer ;
	if ([string length] > 0) {
		answer = string ;
	}
	else {
		answer = [NSString localizeFormat:
				  @"neverX",
				  [NSString localize:@"080_verifyPast"]] ;
	}
	
	return answer ;
}

@end
