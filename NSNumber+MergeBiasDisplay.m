#import "NSNumber+mergeBiasDisplay.h"
#import "BkmxGlobals.h"
#import "NSString+LocalizeSSY.h"
#import "NSDocumentController+DisambiguateForUTI.h"


@implementation NSNumber (mergeBiasDisplay)

- (NSString*)mergeBiasImportDisplayName {
	BkmxMergeBias value = [self shortValue] ;
	NSString* s ;
	
	switch (value) {
		case BkmxMergeBiasKeepSource:
			s = [NSString localize:@"imex_clientAbbrev"] ;
			break ;
		case BkmxMergeBiasKeepDestin:
			s = [[[NSDocumentController sharedDocumentController] defaultDocumentFilenameExtension] capitalizedString] ;
			break ;
		case BkmxMergeBiasKeepBoth:
			s = [NSString localize:@"mergeKeepBoth"] ;
			break ;
		default:
			return @"Internal Error 340-3685" ;
	}	
	
	return s ;
}

- (NSString*)mergeBiasExportDisplayName {
	BkmxMergeBias value = [self shortValue] ;
	NSString* s ;
	
	switch (value) {
		case BkmxMergeBiasKeepSource:
			s = [[[NSDocumentController sharedDocumentController] defaultDocumentFilenameExtension] capitalizedString] ;
			break ;
		case BkmxMergeBiasKeepDestin:
			s = [NSString localize:@"imex_clientAbbrev"] ;
			break ;
		case BkmxMergeBiasKeepBoth:
			s = [NSString localize:@"mergeKeepBoth"] ;
			break ;
		default:
			return @"Internal Error 340-8843" ;
	}	
	
	return s ;
}

@end
