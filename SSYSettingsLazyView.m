#import "SSYSettingsLazyView.h"
#import "SettingsViewController.h"

@implementation SSYSettingsLazyView

+ (Class)lazyViewControllerClass {
    return [SettingsViewController class] ;
}

+ (NSString*)lazyNibName {
    return @"Settings" ;
}

@end
