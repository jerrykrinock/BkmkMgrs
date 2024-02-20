#import "SSYContentLazyView.h"
#import "CntntViewController.h"

@implementation SSYContentLazyView

+ (Class)lazyViewControllerClass {
    return [CntntViewController class] ;
}

+ (NSString*)lazyNibName {
    return @"Content" ;
}

@end
