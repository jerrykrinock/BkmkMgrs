#import "SyncNotificationsWindowController.h"
#import "SSYMH.AppAnchors.h"
#import "BkmxAppDel.h"
#import "SSYWindowHangout.h"
#import "BkmxBasis.h"
#import "AgentPerformer.h"

@interface SyncNotificationsWindowController ()

@end

@implementation SyncNotificationsWindowController

- (id)init {
	self = [super initWithWindowNibName:@"SyncNotifications"] ;
	
	return self ;
}

- (NSString*)windowHeading {
    return [NSString stringWithFormat:
            @"%@ syncing is normally invisble and silent.  If you prefer, you can enable more notifications herein.  All notifications are delivered via the macOS Notification Center.",
            [[BkmxBasis sharedBasis] appNameLocalized]
            ];
}

- (NSString*)soundNameForTag:(NSInteger)tag {
    NSString* soundName = nil;
    switch (tag % 1000) {
        case 1:
            if ([[NSUserDefaults standardUserDefaults] boolForKey:constKeySoundStage]) {
                soundName = @"BookMacsterSyncStage";
            }
            break;
        case 2:
            if ([[NSUserDefaults standardUserDefaults] boolForKey:constKeySoundStart]) {
                soundName = @"BookMacsterSyncStart";
            }
            break;
        case 3:
            if ([[NSUserDefaults standardUserDefaults] boolForKey:constKeySoundSuccess]) {
                soundName = @"BookMacsterSyncSuccess";
            }
            break;
        case 4:
            if ([[NSUserDefaults standardUserDefaults] boolForKey:constKeySoundFailMinor]) {
                soundName = @"BookMacsterSyncFailMinor";
            }
            break;
        case 5:
            if ([[NSUserDefaults standardUserDefaults] boolForKey:constKeySoundFailMajor]) {
                soundName = @"BookMacsterSyncFailMajor";
            }
            break;
        default:
            break;
    }

    return soundName;
}

- (NSString*)demoTitleForTag:(NSInteger)tag {
    NSString* title = nil;
    switch (tag % 1000) {
        case 1:
            if ([[NSUserDefaults standardUserDefaults] boolForKey:constKeyAlertStage]) {
                title = [AgentPerformer notificationTitleForStaged] ;
            }
            break;
        case 2:
            if ([[NSUserDefaults standardUserDefaults] boolForKey:constKeyAlertStart]) {
                title = [AgentPerformer notificationTitleForStarted] ;
            }
            break;
        case 3:
            if ([[NSUserDefaults standardUserDefaults] boolForKey:constKeyAlertSuccess]) {
                title = [AgentPerformer notificationTitleForSuccess] ;
            }
            break;
        case 4:
            if ([[NSUserDefaults standardUserDefaults] boolForKey:constKeyAlertFailure]) {
                title = [AgentPerformer notificationTitleForFailure] ;
            }
            break;
        case 5:
            /* No user default test since this is for notications of major
             failures which we do not allow the user to opt out of. */
            title = [AgentPerformer notificationTitleForFailure] ;
            break;
        default:
            break;
    }
    
    if (title) {
        title = [@"DEMO: " stringByAppendingString:title];
    }
    return title;
}

- (IBAction)demoAgentNotification:(NSButton*)sender {
    NSString* title = [self demoTitleForTag:sender.tag];
    NSString* subtitle = title ? @"This will say what happened." : nil;
    NSString* body = title ? @"And here, maybe a little more detail." : nil;
    [(BkmxAppDel*)[NSApp delegate] demoPresentUserNotificationWithTitle:title
                                                         alertNotBanner:(sender.tag >= 1005)
                                                               subtitle:subtitle
                                                                   body:body
                                                              soundName:[self soundNameForTag:sender.tag]
                                                                 window:[self window]];
}

/* Do not make the mistake of setting this method as the didEndSelector for
 the sheet *and* wiring the *Done* button to it.  That would cause it to
 be invoked twice, which will invoke [self release] twice, which will crash. */
- (IBAction)done:(id)sender {
    [self retain] ;
    [[[self window] sheetParent] endSheet:[self window]
                               returnCode:NSAlertFirstButtonReturn] ;
	[[self window] close] ;
	// Window is set to "Release when closed" in xib
    [self release] ;
}

- (IBAction)helpNotificationCenter:(id)sender {
	[(BkmxAppDel*)[NSApp delegate] openHelpAnchor:constHelpAnchorAgentNotificationCenter] ;
}

- (IBAction)helpCustomSounds:(id)sender {
    [(BkmxAppDel*)[NSApp delegate] openHelpAnchor:constHelpAnchorAgentNotificationCustomSounds] ;
}

- (IBAction)visitSystemPreferences:(id)sender {
    /* See Note OpeningSystemPreferencePanes */
    NSURL *URL = [NSURL URLWithString:@"x-apple.systempreferences:com.apple.preference.notifications"];
    [[NSWorkspace sharedWorkspace] openURL:URL];
}

+ (void)showSheetOnWindow:(NSWindow*)window {
	SyncNotificationsWindowController* sheetController = [[SyncNotificationsWindowController alloc] init] ;
    [SSYWindowHangout hangOutWindowController:sheetController] ;
    [sheetController release] ;
	
	// Note: In the nib containing the sheet/window, make sure that in the
	// window attribute "Visible on Launch" is NOT checked.  If it is,
	// the window will display immediately as a freestanding window
	// instead of the next line attaching it to hostWindow as a sheet.
	
	NSWindow* sheet = [sheetController window] ;
	
    [window beginSheet:sheet
     completionHandler:^void(NSModalResponse modalResponse) {
         // Nothing to do
     }] ;
}

@end
