#import <Cocoa/Cocoa.h>
#import "BkmxDocViewController.h"
#import "TabViewSizing.h"
#import "BkmxDocTabViewControls.h"
#import "BkmxDocumentProvider.h"

@class Client ;
@class SSYArrayController ;
@class SSYTabView ;
@class ClientListView ;
@class SyncStatusTextField ;

@interface SettingsViewController : BkmxDocViewController
<
TabViewSizing,
BkmxDocTabViewControls,
BkmxDocumentProvider
> {
    IBOutlet NSObjectController* bookshigController ;
    IBOutlet SSYArrayController* syncersArrayController ;
    IBOutlet NSTabView* syncingTabView ;
    IBOutlet SyncStatusTextField* syncStatusTextField ;
    IBOutlet ClientListView* clientListView ;
    IBOutlet NSImageView* clientUpArrow ;
    IBOutlet NSImageView* clientDownArrow ;
    IBOutlet SSYArrayController* commandsArrayController ;
    IBOutlet NSButton* importPostprocButton ;
    IBOutlet NSButton* simpleAllOrNoneButton ;
    IBOutlet NSTextField* labelHow ;
    IBOutlet NSTextField* labelWhich ;
    IBOutlet NSPopUpButton* landingPopup ;
    IBOutlet SSYTabView* settingsTabView ;
    IBOutlet NSSegmentedControl* switchSettingsTab ;
    IBOutlet NSTabViewItem* tabAdvanced ;
    IBOutlet NSTabViewItem* tabSyncing ;
    IBOutlet NSTabViewItem* tabClients ;
    IBOutlet NSTabViewItem* tabGeneral ;
    IBOutlet NSTabViewItem* tabOpenSave ;
    IBOutlet NSTabViewItem* tabSimple ;
    IBOutlet NSTabViewItem* tabSorting ;
    IBOutlet NSTabViewItem* tabStructure ;
    IBOutlet SSYArrayController* triggersArrayController ;
    IBOutlet NSTextField* labelReorder;
    
	BOOL m_okToSwitchTabViewExpertise ;
	BOOL m_isSelectingSyncingTabView ;
}

- (NSButton*)importPostprocButton ;

- (ClientListView*)clientListView ;

- (SSYTabView*)settingsTabView ;

- (IBAction)helpLocalSettings:(id)sender ;

- (IBAction)helpSimpleSyncers:(id)sender ;

- (BOOL)shouldAutosaveStateOfTabView:(NSTabView*)tabView ;

- (CGFloat)clientTabMinimumHeight ;
- (CGFloat)minimumWidth ;

- (void)selectSyncingTabPerCurrentExpertise ;

- (void)exposeUIForUserToFixBadAgentIndex:(NSInteger)badAgentIndex
                          badCommandIndex:(NSInteger)badCommandIndex ;

- (void)reloadNewBookmarkLandingMenu ;

- (IBAction)performSelectedSyncer:(id)sender;

- (IBAction)showImportPostprocSheet:(id)sender ;

- (IBAction)simpleAllOrNone:(id)sender ;

- (NSString*)simpleAllOrNoneTitle ;

@end
