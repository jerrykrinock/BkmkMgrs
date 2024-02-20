#import "ExportLog.h"
#import "BkmxBasis+Strings.h"
#import "NSString+LocalizeSSY.h"
#import "NSString+MoreComparisons.h"
#import "NSSet+MoreComparisons.h"
#import "Starkoid.h"

@implementation ExportLog

@dynamic exporterDisplayName ;
@dynamic exporterUri ;

- (NSString*)title {
	NSString* words ;
	NSInteger errorCode = [[self errorCode] longValue] ;
	if (errorCode == constBkmxErrorIsTestRun) {
		words = [NSString localize:@"testRun"] ;
	}
	else if (errorCode == constBkmxErrorNone) {
		words = [[BkmxBasis sharedBasis] labelExport] ;
	}
	else {
		words = [[NSString localize:@"errorColon"] stringByAppendingFormat:@"%ld", (long)errorCode] ;
	}
	
	return [NSString stringWithFormat:
			@"%@ %@ %C %@ [%@]",
			[super title],
			words,
			(unsigned short)0x2192, // arrow -->
			[self exporterDisplayName],
			[self whoDo]] ;
}

- (BOOL)hadSameEffectAsExportLog:(ExportLog*)other {
	
	// This will give us a quick, early return in most cases
	if (![NSString isEqualHandlesNilString1:[self displayStatistics]
									string2:[other displayStatistics]]) {
		return NO ;
	}
	
	// We could compute an 'essence' value for each starkoid in each of the two
	// sets, then compare the sets of essences.  But that would always require
	// all that computation, when usually there will be many
	// unmatched starkoids, and we only need one unmatched to return NO.
	// So, we use the following method which should be much more efficient
	// in the usual case.
	BOOL matchedAllStarkoids = YES ;
	NSMutableArray* otherStarkoids = [[other starkoids] mutableCopy] ;
	for (Starkoid* starkoid in [self starkoids]) {
		Starkoid* matchedOtherStarkoid = nil ;
		for (Starkoid* otherStarkoid in otherStarkoids) {
			if ([starkoid isInEssence:otherStarkoid]) {
				matchedOtherStarkoid = otherStarkoid ;
				break ;
			}
		}
		
		if (matchedOtherStarkoid) {
			// Starkoids cannot match more than one in the other set
			[otherStarkoids removeObject:matchedOtherStarkoid] ;
		}
		else {
			matchedAllStarkoids = NO ;
			break ;
		}
	}
	[otherStarkoids release] ;
	if (!matchedAllStarkoids) {
		return NO ;
	}				
		
	return YES ;
}


@end