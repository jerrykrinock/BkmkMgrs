#import <Foundation/Foundation.h>
#import "BkmxAgentProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface BkmxAgentXPCListener : NSXPCListener <NSXPCListenerDelegate, BkmxAgentProtocol>

+ (BkmxAgentXPCListener*)sharedListener;

@end

NS_ASSUME_NONNULL_END
