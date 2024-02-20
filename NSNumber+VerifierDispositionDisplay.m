#import "NSNumber+VerifierSubtype302Display.h"
#import "BkmxBasis+Strings.h"
#import "BkmxGlobals.h"

@implementation NSNumber (VerifierDispositionDisplay)

- (NSString*)verifierDispositionDisplayName {
	BkmxFixDispo value = (BkmxFixDispo)[self integerValue] ;
	NSString* string ;
	
	switch (value) {
		case BkmxFixDispoNotApplicable:
			string = nil ;
			break ;
		case BkmxFixDispoToBeDetermined:
			string = [NSString stringWithFormat:
					  @"%@ (%@)",
					  [[BkmxBasis sharedBasis] labelUpdatedNot],
					  [[BkmxBasis sharedBasis] labelUnknown]] ;
			break ;
		case BkmxFixDispoLeaveAsIs:
			string = [NSString stringWithFormat:
					  @"%@ (%@)",
					  [[BkmxBasis sharedBasis] labelUpdatedNot],
					  [[BkmxBasis sharedBasis] labelBrokenNot]] ;
			break ;
		case BkmxFixDispoDoUpdate:
			string = [[BkmxBasis sharedBasis] labelUpdated] ;
			break ;
        case BkmxFixDispoDoUpgradeInsecure:
            string = [[BkmxBasis sharedBasis] labelSecured] ;
            break ;
		case BkmxFixDispoLeaveBroken:
			string = [NSString stringWithFormat:
					  @"%@ (%@)",
					  [[BkmxBasis sharedBasis] labelUpdatedNot],
					  [[BkmxBasis sharedBasis] labelBroken]] ;
			break ;
		default:
			string = @"Err: See Console" ;
			NSLog(@"Internal Error 554-9054.  No display name for dispo %@", self) ;
	}
	
	return string ;
}


@end
