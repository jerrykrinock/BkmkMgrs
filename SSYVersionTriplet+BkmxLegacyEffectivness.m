#import "SSYVersionTriplet+BkmxLegacyEffectivness.h"
#import "BkmxBasis.h"

@implementation SSYVersionTriplet (BkmxLegacyEffectivness)

- (SSYVersionTriplet*)effectiveBkmxVersion {
    SSYVersionTriplet* effectiveVersion = self ;
    SSYVersionTriplet* lastCombinedVersion = [SSYVersionTriplet versionTripletWithMajor:1
                                                                                  minor:6
                                                                                 bugFix:7] ;
    SSYVersionTriplet* firstRegularVersion = [SSYVersionTriplet versionTripletWithMajor:1
                                                                                  minor:7
                                                                                 bugFix:0] ;
    BOOL isLegacy = (
                     [self isLaterThan:lastCombinedVersion]
                     &&
                     [self isEarlierThan:firstRegularVersion]
                     ) ;
    
    if (isLegacy) {
        // Adjust the version to the equivalent regular version
        if ([self isEqual:[SSYVersionTriplet versionTripletWithMajor:1
                                                               minor:6
                                                              bugFix:8]]) {
            effectiveVersion = [SSYVersionTriplet versionTripletWithMajor:1
                                                                    minor:7
                                                                   bugFix:0] ;
        }
        else if ([self isEqual:[SSYVersionTriplet versionTripletWithMajor:1
                                                                    minor:6
                                                                   bugFix:9]]) {
            effectiveVersion = [SSYVersionTriplet versionTripletWithMajor:1
                                                                    minor:8
                                                                   bugFix:0] ;
        }
        else if ([self isEqual:[SSYVersionTriplet versionTripletWithMajor:1
                                                                    minor:6
                                                                   bugFix:10]]) {
            effectiveVersion = [SSYVersionTriplet versionTripletWithMajor:1
                                                                    minor:11
                                                                   bugFix:7] ;
        }
        else if ([self isEqual:[SSYVersionTriplet versionTripletWithMajor:1
                                                                    minor:6
                                                                   bugFix:11]]) {
            effectiveVersion = [SSYVersionTriplet versionTripletWithMajor:1
                                                                    minor:14
                                                                   bugFix:4] ;
        }
        else if ([self isEqual:[SSYVersionTriplet versionTripletWithMajor:1
                                                                    minor:6
                                                                   bugFix:12]]) {
            effectiveVersion = [SSYVersionTriplet versionTripletWithMajor:1
                                                                    minor:14
                                                                   bugFix:8] ;
        }
        else if ([self isEqual:[SSYVersionTriplet versionTripletWithMajor:1
                                                                    minor:6
                                                                   bugFix:13]]) {
            effectiveVersion = [SSYVersionTriplet versionTripletWithMajor:1
                                                                    minor:14
                                                                   bugFix:10] ;
        }
        else if ([self isEqual:[SSYVersionTriplet versionTripletWithMajor:1
                                                                    minor:6
                                                                   bugFix:14]]) {
            effectiveVersion = [SSYVersionTriplet versionTripletWithMajor:1
                                                                    minor:15
                                                                   bugFix:1] ;
        }
        else {
            NSLog(@"Internal Error 624-3438") ;
        }
    }

	return effectiveVersion ;
}

- (BOOL)isBkmxEffectivelyEarlierThanRegular:(SSYVersionTriplet*)threshold {
	return [[self effectiveBkmxVersion] isEarlierThan:threshold] ;
}


@end
