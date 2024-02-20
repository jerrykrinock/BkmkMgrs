#import "NSNumber+SharypeCoarseDisplay.h"
#import "BkmxBasis+Strings.h"


@implementation NSNumber (SharypeCoarseDisplay)

- (NSString*)sharypeCoarseDisplayName {
	Sharype sharypeValue = [self shortValue] ;
	NSString* string ;
	
	switch (sharypeValue) {
		case SharypeCoarseHartainer:
			string = [[BkmxBasis sharedBasis] labelHartainer] ;
			break ;
		case SharypeCoarseSoftainer:
			string = [[BkmxBasis sharedBasis] labelSoftainer] ;
			break ;
		case SharypeCoarseLeaf:
			string = [[BkmxBasis sharedBasis] labelLeaf] ;
			break ;
		case SharypeCoarseNotch:
			string = [[BkmxBasis sharedBasis] labelNotch] ;
			break ;
		case SharypeUndefined:
			string = @"" ;
			break ;
		default:
			string = @"Err: See Console" ;
			NSLog(@"Internal Error 345-0574.  No display name for sharype %@", self) ;
	}
	
	return string ;
}


@end

