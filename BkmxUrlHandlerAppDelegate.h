#import <Cocoa/Cocoa.h>


/*!
 @brief    The Sheep-Sys-UrlHandler helper app was added in
 BookMacster 1.11.6.  Prior to this, the bookmacster:// urls were received by
 BookMacster directly, which immediately activated the app and all of its
 windows.  I had kludged together a partial solution by re-activating the web
 browser after landing a bookmark, but that made the Inspector hide, so I set
 the inspector window's 'hidesOnDeactivate' to NO, but then the Inspector
 wouldn't go away when people re-activated the browser.
*/
@interface BkmxUrlHandlerAppDelegate : NSObject {
    NSString* m_mainAppBundleIdentifier ;
}

@end
