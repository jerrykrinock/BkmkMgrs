#import "NSError+Bkmx.h"
#import "NSError+InfoAccess.h"
#import "NSError+LowLevel.h"

@implementation NSError (Bkmx)

+ (NSArray*)additionalKeysInDescriptionForDialog {
	return [NSArray arrayWithObjects:
			@"document",
			@"syncer",
			nil] ;
}

- (BOOL)looksLikeTriggerOrAgentNotFound {
    if ([self code] == -1728) {
        if ([[self domain] isEqualToString:SSYAppleScriptErrorDomain]) {
            // The localized description of the target error is, for example,
            // "Can't get trigger 2 of syncer 3 of collection 1"
            // We look for several key words/phrases.
            NSString* desc = [[self localizedDescription] lowercaseString] ;
            if ([desc rangeOfString:@"get"].location != NSNotFound) {
                if ([desc rangeOfString:@"trigger"].location != NSNotFound) {
                    if ([desc rangeOfString:@"syncer"].location != NSNotFound) {
                        return YES ;
                    }
                }
            }
        }
    }
    
    return NO ;
}

@end
