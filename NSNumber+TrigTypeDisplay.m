#import "NSNumber+TrigTypeDisplay.h"
#import "BkmxBasis+Strings.h"

@implementation NSNumber (TrigTypeDisplay)

- (NSString*)triggerTypeDisplayName {
	BkmxTriggerType triggerTypeValue = (BkmxTriggerType)[self integerValue] ;
	NSString* string ;
	
	switch (triggerTypeValue) {
		case BkmxTriggerBrowserQuit:
			string = [[BkmxBasis sharedBasis] labelEventBrowserQuit] ;
			break ;
		case BkmxTriggerSawChange:
			string = [[BkmxBasis sharedBasis] labelEventBookmarksChanged] ;
			break ;
		case BkmxTriggerScheduled:
			string = [[BkmxBasis sharedBasis] labelEventSchedDate] ;
			break ;
		case BkmxTriggerPeriodic:
			string = [[BkmxBasis sharedBasis] labelEventPeriodic] ;
			break ;
		case BkmxTriggerLogIn:
			string = [[BkmxBasis sharedBasis] labelEventLogInMac] ;
			break ;
		case BkmxTriggerCloud:
			string = [[BkmxBasis sharedBasis] labelEventOtherMacDrop] ;
			break ;
		case BkmxTriggerLanding:
			string = [[BkmxBasis sharedBasis] labelEventLanded] ;
			break ;
		default:
			string = @"Unknown" ;
	}
	
	return string ;
}

@end
