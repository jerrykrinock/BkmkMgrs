#import "NSNumber+VerifierSubtype302Display.h"
#import "BkmxBasis+Strings.h"
#import "BkmxGlobals.h"

@implementation NSNumber (VerifierSubtype302Display)

- (NSString*)verifierSubtype302DisplayName {
	BkmxHttp302 value = [self shortValue] ;
	NSString* string ;
	
	switch (value) {
		case BkmxHttp302NotApplicable:
			string = [[BkmxBasis sharedBasis] labelNotApplicable] ;
			break ;
		case BkmxHttp302Disagree:
			string = [[BkmxBasis sharedBasis] labelDescribe302ProbPerm] ;
			break ;
		case BkmxHttp302Unsure:
			string = [[BkmxBasis sharedBasis] labelDescribe302NotSure] ;
			break ;
		case BkmxHttp302Agree:
			string = [[BkmxBasis sharedBasis] labelDescribe302ProbTemp] ;
			break ;
		default:
			string = @"Err: See Console" ;
			NSLog(@"Internal Error 544-0675.  No display name for subtype302 %@", self) ;
	}
	
	return string ;
}


@end
