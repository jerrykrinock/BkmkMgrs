#import "NSString+DangerousUrl.h"


@implementation NSString (DangerousUrl)

- (BOOL)isDangerous {
	// See http://del.icio.us/doc/dangerous
	
	BOOL answer = YES ;
	
	if ([self hasPrefix:@"http://"]) {
		answer = NO ;
	}
	else if ([self hasPrefix:@"https://"]) {
		answer = NO ;
	}
	else if ([self hasPrefix:@"ftp://"]) {
		answer = NO ;
	}
	else if ([self hasPrefix:@"news://"]) {
		answer = NO ;
	}
	else if ([self hasPrefix:@"feed://"]) {
		// They don't list this scheme as dangerous, but
		// they accept it without making it not shared,
		// and silently change it to http://
		answer = NO ;
	}
	else if ([self hasPrefix:@"gopher://"]) {
		answer = NO ;
	}
	else if ([self hasPrefix:@"mms://"]) {
		answer = NO ;
	}
	else if ([self hasPrefix:@"irc://"]) {
		answer = NO ;
	}
	else if ([self hasPrefix:@"color:"]) {
		answer = NO ;
	}
	
	return answer ;
}

@end
