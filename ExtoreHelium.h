#import "ExtoreGooChromy.h"

@interface ExtoreHelium : ExtoreGooChromy {
}

/* Needed because Swift cannot access extoreConstants_p because
the ExtoreConstants struct contains pointers to objects. */
+ (NSString*)appSupportRelativePath;

@end
