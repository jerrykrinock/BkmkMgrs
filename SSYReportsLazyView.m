#import "SSYReportsLazyView.h"
#import "ReportsViewController.h"

@implementation SSYReportsLazyView

+ (Class)lazyViewControllerClass {
    return [ReportsViewController class] ;
}

+ (NSString*)lazyNibName {
    return @"Reports" ;
}

@end
