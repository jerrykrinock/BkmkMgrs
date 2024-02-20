#import <Cocoa/Cocoa.h>
#import "ExtensionsCallbackee.h"

@class ExtensionsMule ;

@interface Uninstaller : NSObject <ExtensionsCallbackee> {
	NSMutableString* m_log ;
	ExtensionsMule* m_mule ;
}

+ (void)reset ;

+ (void)uninstall ;

@end
