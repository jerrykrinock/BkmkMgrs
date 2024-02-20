#import "ImportLog.h"
#import "BkmxBasis+Strings.h"
#import "NSString+SSYExtraUtils.h"
#import "NSString+LocalizeSSY.h"

@implementation ImportLog

@dynamic importersDisplayList ;

- (NSString*)title {
	NSString* importersDisplayList = [self importersDisplayList] ;
	NSString* listClause ;
	if ([importersDisplayList containsString:@", "]) {
		listClause = [NSString stringWithFormat:@"(%@)", importersDisplayList] ;
	}
	else if (importersDisplayList) {
		listClause = importersDisplayList ;
	}
    else {
        listClause = [[NSString localize:@"all"] lowercaseString];
    }

	NSString* words ;
	NSInteger errorCode = [[self errorCode] longValue] ;
	if (errorCode == constBkmxErrorIsTestRun) {
		words = [NSString localize:@"testRun"] ;
	}
	else if (errorCode == constBkmxErrorNone) {
		words = [[BkmxBasis sharedBasis] labelImport] ;
	}
	else {
		words = [[NSString localize:@"errorColon"] stringByAppendingFormat:@"%ld", (long)errorCode] ;
	}

	return [NSString stringWithFormat:
			@"%@ %@ %C %@ [%@]",
			[super title],
			words,
			(unsigned short)0x2190, // arrow <--
			listClause,
			[self whoDo]] ;
}

@end
