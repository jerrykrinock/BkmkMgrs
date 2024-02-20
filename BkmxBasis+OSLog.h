#import "BkmxBasis.h"

NS_ASSUME_NONNULL_BEGIN

@interface BkmxBasis (OSLog)

- (void)consoleLogAsError:(BOOL)markAsError
                   format:(NSString*)format, ... ;

@end

NS_ASSUME_NONNULL_END
