#import "SSYRecurringDate.h"
#import "Client.h"
#import "Trigger.h"
#import "BkmxBasis+Strings.h"
#import "NSString+LocalizeSSY.h"

@implementation NSObject (TrigDetailDisplay)

- (NSString*)triggerDetailDisplayName {
	NSString* detail = @"?#!" ;
	
	if ([self isKindOfClass:[Client class]]) {
		detail = [(Client*)self displayName] ;
	}
	else if ([self isKindOfClass:[NSNumber class]]) {
        NSInteger value = [(NSNumber*)self integerValue] ;
        
        /*
         The following is kind of kludgey, because I use number
         values to represent three different things, depending on
         if the trigger type is Login, Periodic, or Scheduled.
         But, fortunately, the set of valid values is discrete,
         selected from a popup, and each one is only valid for
         one trigger type.  So I discern the trigger type and
         hence the interpretation by looking at the value.
         */
        
        // Values for Trigger Type "Login"
        if (value == TRIGGER_DETAIL_EFFICIENTLY_NO) {
            detail = @"every login, always" ;
        }
        else if (value == TRIGGER_DETAIL_EFFICIENTLY_YES) {
            detail = @"only if this .bmco has changed" ;
        }
        // Values for Trigger Type "Periodic"
        else if ((value > 24 * 60 * 60) && (value != SSRecurringDateWildcard)){
            detail = [NSString stringWithFormat:@"Every %ld days", (long)value/(24*60*60)] ;
        }
        else if ((value > 60 * 60) && (value != SSRecurringDateWildcard)) {
            detail = [NSString stringWithFormat:@"Every %ld hours", (long)value/(60*60)] ;
        }
        else if ((value > 60) && (value != SSRecurringDateWildcard)) {
            detail = [NSString stringWithFormat:@"Every %ld minutes", (long)value/(60)] ;
        }
        else if ((value > 10) && (value != SSRecurringDateWildcard)) {
            detail = [NSString stringWithFormat:@"Every %ld seconds", (long)value] ;
        }
        // Values for Trigger Type "Scheduled"
        else if (value >= 0) {
            detail = [SSYRecurringDate displayStringForWeekday:value] ;
        }
	}
	else if ([self isKindOfClass:[NSString class]]) {
		if ([(NSString*)self isEqualToString:constNoImportSources]) {
			detail = [NSString localizeFormat:
					  @"no%0",
					  [[BkmxBasis sharedBasis] labelClients]] ;
		}
	}
	
	return detail ;
}

@end
