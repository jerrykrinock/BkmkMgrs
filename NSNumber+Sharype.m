#import "NSNumber+Sharype.h"


@implementation NSNumber (Sharype)

+ (NSNumber*)numberWithSharype:(Sharype)sharype {
	return [NSNumber numberWithUnsignedShort:sharype] ;
}

- (Sharype)sharypeValue {
	return [self unsignedShortValue] ;
}

- (NSString*)readableSharype {
    return [StarkTyper readableSharype:[self sharypeValue]] ;
}

@end
