#import "NSNumber+HttpRatesDisplay.h"
#import "Client+SpecialOptions.h"
#import "NSString+TimeIntervals.h"

@implementation NSNumber (HttpRateDisplay)

- (NSString*)httpRateInitialDisplayName {
	return [NSString stringWithUnitsForTimeInterval:self.doubleValue
										   longForm:YES] ;
}

- (NSString*)httpRateRestDisplayName {
	return [NSString stringWithUnitsForTimeInterval:self.doubleValue
										   longForm:YES] ;
}

- (NSString*)httpRateBackoffDisplayName {
	return [NSString stringWithFormat:@"%0.2f", self.doubleValue] ;
}

@end
