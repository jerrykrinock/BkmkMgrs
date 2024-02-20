#import "NSNumber+FabricateFoldersDisplay.h"
#import "BkmxGlobals.h"

@implementation NSNumber (FabricateFoldersDisplay)

- (NSString*)fabricateFoldersDisplayName {
	BkmxFabricateFolders value = [self shortValue] ;
	NSString* s ;
	
	switch (value) {
		case BkmxFabricateFoldersOff:
			s = @"0" ;
			break ;
		case BkmxFabricateFoldersOne:
			s = @"1" ;
			break ;
		case BkmxFabricateFoldersAll:
			s = @"\xe2\x88\x9e" ;
			break ;
		default:
			return @"Internal Error 340-5741" ;
	}	
	
	return s ;
}


@end
