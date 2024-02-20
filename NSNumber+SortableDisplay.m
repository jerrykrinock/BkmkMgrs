#import "BkmxBasis+Strings.h"


@implementation NSNumber (SortableDisplay)

- (NSString*)sortableDisplayName {
	BkmxSortable sortableValue = [self shortValue] ;
	NSString* string ;
	
	switch (sortableValue) {
		case BkmxSortableNo:
			string = [[BkmxBasis sharedBasis] labelSortDont] ;
			break ;
		case BkmxSortableYes:
			string = [[BkmxBasis sharedBasis] labelSortDo] ;
			break ;
		case BkmxSortableAsParent:
			string = [[BkmxBasis sharedBasis] labelSortIfParent] ;
			break ;
		case BkmxSortableAsDefault:
            if ([[BkmxBasis sharedBasis] isShoeboxApp]) {
                string = [[BkmxBasis sharedBasis] labelSettingsPrefsUse] ;
            }
            else {
                string = [[BkmxBasis sharedBasis] labelSettingsDocumentUse] ;
            }
			break ;
		default:
			string = @"Internal Error 345-6558" ;
	}
	
	return string ;
}


@end