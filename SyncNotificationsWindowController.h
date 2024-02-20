#import <Cocoa/Cocoa.h>

@interface SyncNotificationsWindowController : NSWindowController {
    
}

@property (readonly) NSString* windowHeading;

- (IBAction)demoAgentNotification:(NSButton*)sender ;

- (IBAction)done:(NSButton*)sender ;

- (IBAction)visitSystemPreferences:(NSButton*)sender ;

- (IBAction)helpNotificationCenter:(NSButton*)sender ;

- (IBAction)helpCustomSounds:(NSButton*)sender ;

+ (void)showSheetOnWindow:(NSWindow*)window ;

@end
