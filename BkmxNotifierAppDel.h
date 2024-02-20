#import <Cocoa/Cocoa.h>
#import <UserNotifications/UserNotifications.h>

/* Note WhyBkmxNotifierAandB
 
 This project contains two BkmxNotifier targets, -A and -B.  The only
 differences in their products are
 
 • Bundle identifier
 • Bundle (.app) name
 • Executable name
 • Category BkmxNotifierAppDel+BkmxNotifierAppDel_AlertActions.m, in -A only
 • Several additional source files which this category depends on, in -A only
 
 Except for these differences, the same code files are compiled, the
 same Resource files, and even the same Info.plist source, because the
 Info.plist file is preprocessed and the three different values are built
 from parameters.
 
 The reason for having the two targets is that -A is for notifying of errors,
 for which the user should enable Notification Alerts, and -B is for notifying
 info messages, for which the user should enable Notification Banners.
 */

/* Don't need no stinkin' categories.  Just use one for everything.  */
extern NSString* constCategoryIdentifierEverything;

@interface BkmxNotifierAppDel : NSObject <NSApplicationDelegate, UNUserNotificationCenterDelegate>

@end

