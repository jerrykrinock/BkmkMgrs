#import "NSString+LocalizeSSY.h"
#import "BkmxBasis+Strings.h"

@implementation NSNumber (CharacterDisplay)

- (NSString*)characterDisplayName {
	NSString* answer ;
	unichar theChar = [self unsignedShortValue] ;
	NSString* keyword = nil ;
	switch (theChar) {
		case YOUR_DEFAULT_TAG_DELIMITER:
			answer = [NSString localizeFormat:
					  @"yourThing",
					  [[BkmxBasis sharedBasis] labelTagDelimiterDefault1]] ;
			theChar = [[[NSUserDefaults standardUserDefaults] objectForKey:constKeyTagDelimiterDefault] integerValue] ;
			break ;
		case ',':
			keyword = @"pnctuComma" ;
			break ;
		case ';':
			keyword = @"pnctuSemicolon" ;
			break ;
		case ' ':
			keyword = @"pnctuSpace" ;
			break ;
		case '-':
			keyword = @"pnctuHyphen" ;
			break ;
		case 160:
			keyword = @"pnctuNonbreakingSpace" ;
			break ;
		case '_':
			keyword = @"punctuUnderscore" ;
			break ;
		case 8212:
			keyword = @"punctuEmDash" ;
			break ;
		default:
			keyword = @"Interal Error 613-0192" ;
	}
	
	if (keyword) {
		answer = [NSString localize:keyword] ;
	}
	
	BOOL isPrintable = ((theChar != 32) && (theChar != 160)) ;
	
	if (isPrintable) {
		answer = [NSString stringWithFormat:
				  @"%@ (\"%C\")",
				  answer,
				  theChar] ;
	}
	
	return answer ;
}

@end
