#import <Cocoa/Cocoa.h>
#import "BkmxAppDel.h"

@interface BkmxAppDel (Actions) 

- (IBAction)shoeboxShowSyncLog:(id)sender ;
- (IBAction)shoeboxToggleSync:(id)sender ;
- (IBAction)checkForUpdate:(id)sender ;
- (IBAction)preferences:(id)sender ;
- (IBAction)showMiniSearchWindow:(id)sender ;
- (IBAction)showShoeboxWindow:(id)sender ;
- (IBAction)orderFrontCustomAboutPanel: (id) sender; //	Variation on NSApplication’s orderFrontStandardAboutPanel:
- (IBAction)support:(id)sender;
- (IBAction)videoTutorials:(id)sender ;
- (IBAction)visitForum:(id)sender;
- (IBAction)troubleZipper:(id)sender;
- (IBAction)touchSafariBookmarks:(id)sender;
- (IBAction)showSyncingStatus:(id)sender;
- (IBAction)rebootSyncAgent:(id)sender;
- (IBAction)dumpAndCrash:(id)sender ;
- (IBAction)showLogs:(id)sender ;
- (IBAction)resetApp:(id)sender ;
// Note: Simply uninstall: conflicts with action in ExtensionsManagerView which is First Responder…
- (IBAction)uninstallApp:(id)sender ;  
- (IBAction)licenseBuy:(id)sender;
- (IBAction)licenseInfo:(id)sender;
- (IBAction)licenseInfoRetryDownload:(id)sender;
- (IBAction)licenseInfoLostRequest:(id)sender ;
- (IBAction)inspectorShowOrNot:(id)sender ;
- (IBAction)inspectStark:(NSMenuItem*)sender ;

@end

@interface BkmxAppDel (AgentActions)

- (IBAction)stopAllSyncing:(id)sender ;
/*!
 @details  This is the action for the "Number of recent Snapshots to keep"
 in Preferences ▸ Syncing.
 */
- (IBAction)cleanExcessSyncSnapshots:(id)sender;

@end

@interface BkmxAppDel (SyncActions)
- (IBAction)manageAddOns:(id)sender ;

@end

@interface BkmxAppDel (BookMacsterActions)
- (IBAction)emptyCache:(id)sender ;

@end



