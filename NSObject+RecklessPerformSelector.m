#import "NSObject+RecklessPerformSelector.h"


@implementation NSObject (RecklessPerformSelector)

#pragma mark Methods taking 0 parameters

- (void)recklessPerformVoidSelector:(SEL)selector {
    IMP imp = [self methodForSelector:selector];
    void (*func)(id, SEL) = (void (*)(id, SEL))imp;
    func(self, selector);
}

- (BOOL)recklessPerformBoolSelector:(SEL)selector {
    IMP imp = [self methodForSelector:selector];
    BOOL (*func)(id, SEL) = (BOOL (*)(id, SEL))imp;
    return func(self, selector);
}

- (id)recklessPerformSelector:(SEL)selector {
    IMP imp = [self methodForSelector:selector];
    id (*func)(id, SEL) = (id (*)(id, SEL))imp;
    return func(self, selector);
}

#pragma mark Methods taking 1 parameters

- (void)recklessPerformVoidSelector:(SEL)selector
                             object:(id)object {
    IMP imp = [self methodForSelector:selector];
    void (*func)(id, SEL, id) = (void (*)(id, SEL, id))imp;
    func(self, selector, object);
}

- (BOOL)recklessPerformBoolSelector:(SEL)selector
                             object:(id)object {
    IMP imp = [self methodForSelector:selector];
    BOOL (*func)(id, SEL, id) = (BOOL (*)(id, SEL, id))imp;
    return func(self, selector, object);
}

- (id)recklessPerformSelector:(SEL)selector
                       object:(id)object {
    IMP imp = [self methodForSelector:selector];
    id (*func)(id, SEL, id) = (id (*)(id, SEL, id))imp;
    return func(self, selector, object);
}

#pragma mark Methods taking 2 parameters

- (void)recklessPerformVoidSelector:(SEL)selector
                             object:(id)object1
                             object:(id)object2 {
    IMP imp = [self methodForSelector:selector];
    void (*func)(id, SEL, id, id) = (void (*)(id, SEL, id, id))imp;
    func(self, selector, object1, object2);
}

- (BOOL)recklessPerformBoolSelector:(SEL)selector
                             object:(id)object1
                             object:(id)object2 {
    IMP imp = [self methodForSelector:selector];
    BOOL (*func)(id, SEL, id, id) = (BOOL (*)(id, SEL, id, id))imp;
    return func(self, selector, object1, object2);
}

- (id)recklessPerformSelector:(SEL)selector
                       object:(id)object1
                       object:(id)object2 {
    IMP imp = [self methodForSelector:selector];
    id (*func)(id, SEL, id, id) = (id (*)(id, SEL, id, id))imp;
    return func(self, selector, object1, object2);
}

@end
