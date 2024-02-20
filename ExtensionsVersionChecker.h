#import <Cocoa/Cocoa.h>

@class ExtensionsMule ;

@interface ExtensionsVersionChecker : NSObject {
}

/*!
 @brief    Checks to see that all *installed* addons are
 of the correct version, showing a message and the
 app's Manage Browser Extensions window if any are not.
 
 @details  Even though this test only looks at the version
 numbers on the disk and does not actually test the addons,
 the actual test should not be necessary because, when we
 install an API, we do so by opening a proper installer
 package in the browser.  We don't just drop our API into
 the filesystem.  If a user has manually disabled one of
 our addons or corrupted it, they'll have to do the test
 manually by clicking it in the menu.
 */
+ (void)checkInstalledExtensionVersions ;

@end
