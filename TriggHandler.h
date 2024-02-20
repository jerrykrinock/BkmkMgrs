#import <Foundation/Foundation.h>

@class Watch;

@interface NSString (BkmxLast2)

- (NSString*)last2PathComponents;

@end

__attribute__((visibility("default"))) @interface TriggHandler : NSObject {
}

- (void)handleTriggerForWatch:(Watch*)watch
                 triggerCause:(NSString*)triggerCause;

@end
