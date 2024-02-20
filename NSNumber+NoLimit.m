#import "NSNumber+NoLimit.h"
#import "NSString+LocalizeSSY.h"
#import "NSString+VarArgs.h"

@implementation NSNumber (LimitsDisplay)

- (NSString*)limitsDisplay {
	NSInteger value = [self integerValue] ;
	NSString* s ;
	
	if (value == BKMX_NO_LIMIT) {
		s = @"\xe2\x88\x9e" ;  // Infinity symbol
	}
	else {
		s = [NSString stringWithInt:value] ;
	}	
	
	return s ;
}

@end
