#import "NSNumber+SortDirectiveDisplay.h"
#import "BkmxBasis+Strings.h"
#import "BkmxGlobals.h"


@implementation NSNumber (SortDirectiveDisplay)

- (NSString*)sortDirectiveDisplayName {
	BkmxSortDirective sortDirective = [self shortValue] ;
	NSString* string ;
	
	switch (sortDirective) {
		case BkmxSortDirectiveNotApplicable:
			string = NSLocalizedString(@"not applicable", nil) ;
			break ;
		case BkmxSortDirectiveNormal:
			string = [[BkmxBasis sharedBasis] labelNormally] ;
			break ;
		case BkmxSortDirectiveTop:
			string = [[BkmxBasis sharedBasis] labelTop] ;
			break ;
		case BkmxSortDirectiveBottom:
			string = [[BkmxBasis sharedBasis] labelBottom] ;
			break ;
		default:
			string = @"Internal Error 340-6843" ;
	}
	
	return string ;
}


@end
