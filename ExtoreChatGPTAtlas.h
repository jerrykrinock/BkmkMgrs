#import "ExtoreGooChromy.h"

@interface ExtoreChatGPTAtlas : ExtoreGooChromy {
}

/* Needed because Swift cannot access extoreConstants_p becaause
the ExtoreConstants struct contains pointers to objects. */
+ (NSString*)appSupportRelativePath;

@end
