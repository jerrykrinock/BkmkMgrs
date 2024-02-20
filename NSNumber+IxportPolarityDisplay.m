#import "NSNumber+IxportPolarityDisplay.h"

#import "BkmxBasis+Strings.h"

@implementation NSNumber (IxportPolarityDisplay)

- (NSString*)ixportPolarityDisplay {
	BOOL integerValue = [self integerValue] ;
	NSString* string ;
	
	if (integerValue == BkmxIxportPolarityImport) {
        string = [[BkmxBasis sharedBasis] labelImport];
    } else if (integerValue == BkmxIxportPolarityExport) {
        string = [[BkmxBasis sharedBasis] labelExport];
    } else {
        string = @"" ;
	}
	
	return string ;
}


@end
