#import "NSString+LocalizeSSY.h"
#import "BkmxGlobals.h"

@implementation NSNumber (CommandArgumentDisplay)

- (NSString*)commandArgumentDisplayName {
	BkmxDeference deference = [self shortValue] ;
	NSString* string ;
	
	switch (deference) {
		case BkmxDeferenceAsk:
			string = [NSString localize:@"deferenceAsk"] ;
			break ;
		case BkmxDeferenceYield:
			string = [NSString localize:@"deferenceYield"] ;
			break ;
		case BkmxDeferenceQuit:
			string = [NSString localize:@"deferenceQuit"] ;
			break ;
		case BkmxDeferenceKill:
			string = [NSString localize:@"deferenceKill"] ;
			break ;
		default:
			string = @"" ;
	}
	
	return string ;
}


@end

