#import <Cocoa/Cocoa.h>
#import "SSYErrorAlertee.h"
#import "BkmxDocumentProvider.h"
#import "SSYTabViewController.h"

extern NSString* const constIdentifierTabViewPrefsGeneral ;
extern NSString* const constIdentifierTabViewPrefsAdding ;
extern NSString* const constIdentifierTabViewPrefsSorting ;
extern NSString* const constIdentifierTabViewPrefsAppearance ;
extern NSString* const constIdentifierTabViewPrefsSyncing ;
extern NSString* const constIdentifierTabViewPrefsSyncing ;

@class ClientListView ;

@class Exporter ;
@class Client ;
@class ClientListView ;
@class SSYShortcutBackEnd ;
@class SRRecorderControl ;
@class BkmxLazyView ;

@interface ShowSpaceCharacter : NSValueTransformer
	// This is used by InspectorController also.
@end

@interface PrefsWinCon : NSWindowController
<
SSYErrorAlertee,
BkmxDocumentProvider,
NSTabViewDelegate,
NSToolbarDelegate,
NSViewToolTipOwner
>
{
    IBOutlet ClientListView* clientListView ;
    IBOutlet NSImageView* clientUpArrow ;
    IBOutlet NSImageView* clientDownArrow ;

    IBOutlet NSPopUpButton* landingPopup ;

	IBOutlet SSYShortcutBackEnd* shortcutBackEndAnywhereMenu ;
	IBOutlet SSYShortcutBackEnd* shortcutBackEndAddQuickly ;
	IBOutlet SSYShortcutBackEnd* shortcutBackEndAddAndInspect ;
    IBOutlet SRRecorderControl* shortcutRecorderAnywhereMenu ;
    IBOutlet SRRecorderControl* shortcutRecorderAddQuickly ;
    IBOutlet SRRecorderControl* shortcutRecorderAddAndInspect ;
    
	NSToolTipTag m_altKeyInspectsLanderTooltipTag ;
	
    IBOutlet NSPopUpButton* visitPopupSmarkyGeneral ;
    IBOutlet NSPopUpButton* visitPopupSynkmarkGeneral ;
    IBOutlet NSPopUpButton* visitPopupMarksterGeneral ;
    IBOutlet NSButton* ignoreDisparatesCheckboxSmarkyGeneral ;
    IBOutlet NSButton* ignoreDisparatesCheckboxSynkmarkGeneral ;
    IBOutlet NSButton* ignoreDisparatesCheckboxMarksterGeneral ;
	BOOL m_isAwaked ;
    BOOL m_windowIsBeingAutosized ;
	NSSize m_laterSize ;
	BOOL autosaveArmed ;
    NSMutableDictionary* _targetViewSizes;
    
    IBOutlet NSObjectController* bookshigController ;
    
    BkmxDoc* m_theDocument ;
    
    IBOutlet NSMatrix* defaultSortableMatrix ;
    IBOutlet NSMatrix* sortByMatrix ;
    IBOutlet NSMatrix* sortingSegmentationMatrix ;
    IBOutlet NSMatrix* sortWhichSegmentsMatrix ;
    IBOutlet NSButton* ignoreCommonPrefixesCheckbox ;
    IBOutlet NSButton* sortRootCheckbox ;
    IBOutlet NSImageView* appleMenuExtras ;
    IBOutlet NSTextField* labelReorder;
    
    IBOutlet NSNumberFormatter* syncSnapshotsLimitFormatterBookMacster;
    IBOutlet NSNumberFormatter* syncSnapshotsLimitFormatterMarkster;
    IBOutlet NSNumberFormatter* syncSnapshotsLimitFormatterSynkmark;
    IBOutlet NSNumberFormatter* syncSnapshotsLimitFormatterSmarky;
}

@property (assign) BOOL windowIsBeingAutosized;

@property (assign) IBOutlet NSToolbar* toolbar;
@property (assign) IBOutlet NSTabView* tabView;
@property (retain) SSYTabViewController* tabViewController;

@property (assign) IBOutlet NSView* viewGeneralSmarky;
@property (assign) IBOutlet NSView* viewGeneralSynkmark;
@property (assign) IBOutlet NSView* viewGeneralMarkster;
@property (assign) IBOutlet NSView* viewGeneralBookMacster;
@property (assign) IBOutlet NSView* viewSortingShoebox;
@property (assign) IBOutlet NSView* viewSortingBookMacster;
@property (assign) IBOutlet NSView* viewSyncingSmarky;
@property (assign) IBOutlet NSView* viewSyncingSynkmark;
@property (assign) IBOutlet NSView* viewSyncingMarkster;
@property (assign) IBOutlet NSView* viewSyncingBookMacster;
@property (assign) IBOutlet NSView* viewShortcuts;
@property (assign) IBOutlet NSView* viewAddingMarkster;
@property (assign) IBOutlet NSView* viewAddingBookMacster;
@property (assign) IBOutlet NSView* viewAppearanceSmarkySynkmark;
@property (assign) IBOutlet NSView* viewAppearanceMarksterBookMacster;
@property (assign) IBOutlet NSView* viewUpdates;

@property NSSize laterSize ;
@property (readonly) BOOL autosaveArmed ;
@property (readonly) BOOL updateBeta ;
@property (readonly) BOOL updateAlpha ;

- (NSImage*)statusItemImageFlat ;
- (NSImage*)statusItemImageGray ;

- (BOOL)canHaveNoStatusItem ;

/*!
 @brief    Returns the bottom-leaf tab view item in the
 receiver's windows tab view hierarchy
 */
- (NSTabViewItem*)activeTabViewItem ;

/*!
 @brief    Returns the height of the toolbar at the top, plus, if
 applicable, that of the second-level tabs.
 */
- (CGFloat)deadHeightForTabViewItem:(NSTabViewItem*)tabViewItem ;

/*!
 @brief    Displays (selects) a given tab view item in the
 receiver's window's tab view hierarchy
 
 @param    identifier1  The identifier of the first tab view
 item in the lineage of the tab view item to be displayed.
 @param    identifier2  The identifier of the second tab view
 item in the lineage of the tab view item to be displayed.
 May be nil if only the top tab is desired to be selected.
 */
- (void)revealTabViewIdentifier1:(NSString*)identifier1
					 identifier2:(NSString*)identifier2 ;

- (IBAction)helpAgentLaziness:(id)sender ;

- (IBAction)helpDirectSettings:(id)sender ;

- (IBAction)helpFloatingMenu:(id)sender ;

- (IBAction)helpSafeSyncLimit:(id)sender ;

- (IBAction)helpMenuExtra:(id)sender ;

- (IBAction)helpSyncFirefoxOnQuit:(id)sender ;

- (IBAction)helpSyncSnapshots:(id)sender ;

- (IBAction)helpDontWarnSyncingSuspended:(id)sender;

- (IBAction)helpSendPerformanceData:(id)sender;

- (IBAction)helpTextCopyTemplate:(id)sender;

- (IBAction)warnIfLaunchInBackground:(id)sender ;

- (IBAction)showIgnoredPrefixesSheet:(id)sender ;

- (IBAction)syncNotifications:(id)sender ;

- (void)openNotificationSettings;

- (NSImage*)specialImageForTabViewIdentifier:(NSString*)identifier;

@end
