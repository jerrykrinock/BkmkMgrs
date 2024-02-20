#import <Cocoa/Cocoa.h>
#import "SSYVersionTriplet.h"

@interface SSYVersionTriplet (BkmxLegacyEffectivness)

- (SSYVersionTriplet*)effectiveBkmxVersion ;

- (BOOL)isBkmxEffectivelyEarlierThanRegular:(SSYVersionTriplet*)threshold ;

@end
