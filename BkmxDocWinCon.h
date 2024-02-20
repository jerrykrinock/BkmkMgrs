#import "SSYMenuButton.h"
#import "SSYSizability.h"
#import "BkmxGlobals.h"
#import "BkmxSearchDelegate.h"
#import "BkmxDocumentProvider.h"
#import "TabViewSizing.h"
#import "BkmxLazyView.h"

// Some of these delays are coordinated so that things occur in required order.
#define BKMX_DOC_WINDOW_OPENING_DELAY__RESTORE_COLUMNS	        0.01 // new in BookMacster 1.17
#define BKMX_DOC_WINDOW_OPENING_DELAY__WARN_IF_DROPBOX_TRASH	0.02 // was 0.2 until BookMacster 1.17
#define BKMX_DOC_WINDOW_OPENING_DELAY__ARM_AUTOSAVE	            0.04 // was 0.1 until BookMacster 1.17

@class Syncer ;
@class SSYProgressView ;
@class SSYToolbarButton ;
@class StarkTableColumn ;
@class ContentOutlineView ;
@class SSYSidebarController;
@class Ixporter ;
@class Exporter ;
@class FindViewController ;
@class Stark ;
@class BkmxSearchField ;
@class DupesOutlineView ;
@class SSYTokenField ;
@class VerifyProgressController ;
@class SSYArrayController ;
@class Broker ;
@class SSYTabView ;
@class StarkContainersHierarchicalMenu ;
@class Client ;
@class Dupetainer ;
@class SSYAlert ;
@class BkmxLazyView ;
@class CntntViewController ;
@class SettingsViewController ;
@class ReportsViewController ;
@class FindTableView ;

extern NSString* const constIdentifierTabViewContent ;
extern NSString* const constIdentifierTabViewSettings ;
extern NSString* const constIdentifierTabViewReports ;

extern NSString* const constIdentifierTabViewGeneral ;
extern NSString* const constIdentifierTabViewOpenSave ;
extern NSString* const constIdentifierTabViewClients ;
extern NSString* const constIdentifierTabViewSorting ;
extern NSString* const constIdentifierTabViewStructure ;
extern NSString* const constIdentifierTabViewSyncing ;

extern NSString* const constIdentifierTabViewSimple ;
extern NSString* const constIdentifierTabViewAdvanced ;

extern NSString* const constIdentifierTabViewFindReplace ;
extern NSString* const constIdentifierTabViewDupes ;
extern NSString* const constIdentifierTabViewVerify ;
extern NSString* const constIdentifierTabViewDiaries ;

@interface BkmxDocWinCon : NSWindowController
<
NSTableViewDelegate,
NSMenuDelegate,
NSWindowDelegate,
NSToolbarDelegate,
BkmxSearchDelegate,
BkmxLazyViewWindowController,
NSViewToolTipOwner>
{    
    IBOutlet BkmxLazyView* contentLazyView ;
    IBOutlet BkmxLazyView* settingsLazyView ;
    IBOutlet BkmxLazyView* reportsLazyView ;
    
    // dupetainerController is needed for Document Revert to work, added in BookMacster 1.5.
    IBOutlet SSYProgressView* progressView ;
    IBOutlet BkmxSearchField* searchField ;
    IBOutlet NSTabViewItem* tabContent ;
    IBOutlet NSTabViewItem* tabReports ;
    IBOutlet NSTabViewItem* tabSettings ;
    IBOutlet NSToolbar* toolbar ;
    IBOutlet NSToolbarItem* toolbarItemContent ;
    IBOutlet SSYToolbarButton* toolbarItemHelp ;
    IBOutlet SSYToolbarButton* toolbarItemInspector ;
    IBOutlet NSToolbarItem* toolbarItemReports ;
    IBOutlet NSToolbarItem* toolbarItemSearch ;
    IBOutlet NSToolbarItem* toolbarItemSettings ;
    IBOutlet SSYToolbarButton* toolbarItemSync ;
    IBOutlet SSYSidebarController* sidebarController;
    IBOutlet VerifyProgressController* verifyProgressController ;
    IBOutlet NSView* windowContentView;
    
    IBOutlet SSYTabView* topTabView ;
    IBOutlet NSView* verifyProgressView;

    CntntViewController* m_cntntViewController ;
    SettingsViewController <BkmxDocumentProvider, TabViewSizing> * m_settingsViewController ;
    ReportsViewController* m_reportsViewController ;
	
    NSArray* selectedStarks ;
	
	NSMutableArray* taskQueue ;
	NSTimer* queueChecker ;

	BOOL _busy ;
	BOOL autosaveArmed ;
	NSSize m_laterSize ;
	BOOL selectionChangeTrigger ;
	BOOL m_windowIsBeingAutosized ;
	BOOL m_didWillClose ;
    BOOL m_isAwake;
	BOOL m_isInVersionBrowser ;
	
	NSString* m_searchText ;
}

@property (retain) CntntViewController* cntntViewController ;
@property (retain) SettingsViewController <BkmxDocumentProvider, TabViewSizing> * settingsViewController ;
@property (retain) ReportsViewController* reportsViewController ;

@property (readonly) NSArray* selectedStarks ;
@property (readonly) BOOL autosaveArmed ;
@property NSSize laterSize ;
@property BOOL windowIsBeingAutosized ;
@property (assign) BOOL  outlineMode ;
@property (copy) NSString* searchText ;

- (BkmxSearchField*)searchField ;

- (BOOL)isInVersionBrowser ;

- (void)beginAutosave ;

/*!
 @brief    Returns the height of the toolbar at the top, plus, if
 applicable, that of the second-level tabs, plus that of the
 Status Bar at the bottom.
*/
- (CGFloat)deadHeightForTabViewItem:(NSTabViewItem*)tabViewItem ;

- (SSYTabView*)topTabView ;

- (SSYProgressView*)progressView ;
- (BOOL)outlineMode ;

- (NSString*)explainNotAvailableTabName:(NSString*)tabName ;

/*!
 @brief    Returns the bottom-leaf tab view item in the
 receiver's windows tab view hierarchy
 */
- (NSTabViewItem*)activeTabViewItem ;

- (BOOL)windowShouldClose:(id)sender ;

/*!
 @brief    Returns the identifier of the bottom-leaf tab view
 item in the receiver's windows tab view hierarchy
 */
- (NSString*)activeTabViewItemIdentifier ;

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

/*!
 @brief    Displays (selects) a given tab view item in the
 receiver's window's tab view hierarchy
 
 @param    identifier  The identifier of the last tab view
 item in the lineage of the tab view item to be displayed.
 May be nil if only the top tab is desired to be selected.
 @result   YES if the given identifier is valid, otherwise NO.
 */
- (BOOL)revealTabViewIdentifier:(NSString*)identifier ;

- (IBAction)revealTabViewContent:(id)sender ;
- (IBAction)revealTabViewSettings:(id)sender ;
- (IBAction)revealTabViewReports:(id)sender ;

- (ContentOutlineView*)contentOutlineView ;
- (FindTableView*)findTableView ;
- (DupesOutlineView*)dupesOutlineView ;

- (BOOL)activeTabViewIsUndoable ;

/*!
 @param    tabViewItem  Must be a leaf tab view item
 */
- (void)resizeWindowForLeafTabViewItem:(NSTabViewItem*)tabViewItem ;

- (SSYSizability)sizabilityForTabViewItem:(NSTabViewItem*)tabViewItem ;

- (BOOL)           tabView:(NSTabView*)tabView
   shouldSelectTabViewItem:(NSTabViewItem*)tabViewItem ;

- (void)       tabView:(NSTabView*)tabView
 willSelectTabViewItem:(NSTabViewItem*)newItem ;

- (void)       tabView:(NSTabView*)tabView
  didSelectTabViewItem:(NSTabViewItem*)tabViewItem ;

/*!
 @brief    Resizes the window for a given tab view item size,
 ignoring a given width or height if zero.

 @details  Aesthetic: Preserves vertical center line and
 title bar height on screen.
 
 In the case where the new tab view is going to be bigger, in
 -tabView:willSelectTabViewItem:, we resize the window before
 switching to the new tab view we are accomodating.  Thus,
 when the window did resize notification 
 goes out to -autosaveActiveTabViewSizeNote:, it will
 register this size with the wrong tab view item.  Also,
 we do not need to autosave such a resize in either case,
 since this is not a resizing that was done by the user.
 This method therefore sets windowIsBeingAutosized while it
 is doing its resizing, to lock out autoresize registration.
 
 @param    newSize  The size of the tab view item to be
 displayed, not including the deadHeight which is added
 in by this method.
*/
- (void)resizeWindowForTabViewItem:(NSTabViewItem*)tabViewItem
							  size:(NSSize)newSize ;

/*!
 @brief    Resizes the window to the appropriate (persisted,
 default, or minimum) size, sets the window's minimum size, and
 sets whether or not the window shows the resize control, for
 the currently-selected tab view item.

 @details  This method is needed when creating a new document.
 In the document window in BkmxDoc.xib, the window width is set to 
 that needed to lay out the widest tab view (currently Clients, 620).
 But the first (default) tab shown in a new document (currently
 Content), has a default width which is less than this.  So this
 method sets the window to its default width in that situation.
 
 This method is not needed when re-opening a document,
 because the window's autosave frame takes care of it.
*/
- (void)constrainWindowSizeForTabViewItem:(NSTabViewItem*)tabViewItem ;

- (void)resizeWindowAndConstrainSizeForActiveTabViewItem ;
- (void)selectNewestIxportLog ;
- (void)updateWindowForStark:(Stark*)stark ;
- (IBAction)quickSearch:(id)sender ;

- (BOOL)isShowingVerifyResults ;

/*!
 @brief    Obliterates anything in the receiver's progress view
 and replaces it with a summary of the latest Verify results.
*/
- (void)showVerifyResultsInProgressView ;

- (void)reloadStarks:(NSSet*)starks ;

/*!
 @brief    Sets the userDefinedColumn of the receiver's outline view
 to display the pre-update (prior) url, and also sets the outline
 view to flat (not hierarchical)
*/
- (void)revealTabViewVerify ;

- (void)setInspectorButtonState:(BOOL)state ;

- (id)init ;
- (IBAction)help:(id)sender;

- (IBAction)setOutlineModeFromMenu:(id)sender ;
- (IBAction)showSyncLog:(id)sender ;
- (IBAction)setUpSync:(id)sender ;
- (IBAction)toggleSync:(id)sender ;
- (IBAction)safeSyncLimitImport:(id)sender ;

- (IBAction)search:(id)sender ;

- (void)clearQuickSearch ;

- (void)invalidateFlatCache ;
- (void)reloadContent ;
- (void)reloadAll ;

- (void)reloadNewBookmarkLandingMenu ;

- (void)deselectAll ;

/*!
 @brief    Redisplays the receiver's outline view, in accordance with the latest
 values of the BkmxDocWinCon's 'outlineMode' value.
*/
- (void)updateOutlineMode ;

- (BOOL)findTabNowShowing ;

// To put new task into taskQueue and, when it starts, show a new SSYProgressView
- (void)queueInvocation:(NSInvocation*)invocation
		localizableVerb:(NSString*)verbToDisplay ;
// Invoked by worker threads with NO when work is done...
- (void)setBusy:(BOOL)busy ;
	
//  To show verify progress, which also expands the Verify sidebar
-(void)startVerifyProgressWithLocalizedVerb:(NSString*)verb
									  limit:(NSInteger)limit
									 broker:(Broker*)broker_ ;
	//  Send this to begin the progress bar
	//  textDoing: word to be displayed below the bar, such as @"sorting", @"writing"
	//  	An ellipsis (...) will be appended by this method
	//  Always starts indeterminate.  To set determinate, send message to the SSYProgressView directly.

// To update the Verify sidebar
-(void)shortenVerifyVerbTo:(NSString*)shorterVerb ;
-(void)updateThrottleView ;
-(void)setVerifyNWaiting:(CGFloat)nWaiting ;
-(void)appendToVerifyLog:(NSString*)newLine ;
-(void)removeFromVerifyLog:(NSString*)name ;
-(void)verifyIsDone ;

/*!
 @brief    Forwards same message to the receiver's contentOutlineView.
 */
- (void)showStark:(Stark*)stark
         selectIt:(BOOL)selectIt ;

/*!
 @brief    Returns the receiver's selected starks, or an empty array
 
 @details  Subclasses should override.  The default implementation 
 returns an empty array.
 */
- (NSArray*)selectedStarks ;

/*!
 @brief    Returns the single selected stark, NSNoSelectionMarker, or
 NSMultipleValuesMarker.
 */
- (id)selectedStark ;

- (void)handleChangedSelectionNotification:(NSNotification*)note ;

- (void)endEditing ;

- (void)exposeUIForUserToFixBadAgentIndex:(NSInteger)badAgentIndex
                          badCommandIndex:(NSInteger)badCommandIndex ;

- (void)restoreAutosavedWindowFrame ;

- (NSInteger)agentsPausitivity ; // tristate

/*!
 @brief    Returns the starks that are selected in the receiver's
 dupesOutlineView.
 */
- (NSArray*)selectedDupeStarks ;

/*!
 @brief    Writes one of the receiver's sync logs to a human-readable
 text file at a given path

 @param    path  The full path to which the log should be written,
 or nil if you want the method go generate an appropriate time-based filename
 and write it to the user's desktop.
 @param    back  Specifies which log to write.  If 0, will write the latest
 sync log which is selected in the window, or the most recent log if none is
 selected.  If N>0, will write the log whose serial number L-N where L is the
 latest log's serial number.
 @param    doStamp  YES to include the log serial number and timestamp in
 the first line of the log, NO to omit this.  NO is useful for comparing
 logs of the same ixport done at different times.
 @param    error_p  If not NULL and if an error occurs, upon return,
           will point to an error object encapsulating the error.
 @result   If the method completed successfully, the path to which the
 log was written; otherwise, nil.
*/
- (NSString*)writeLogToPath:(NSString*)path
					   back:(NSInteger)back
					doStamp:(BOOL)doStamp
					error_p:(NSError**)error_p ;


- (IBAction)revealTabViewClients:(id)sender ;

- (void)tabViewChangedNote:(NSNotification*)note ;

- (BOOL)isClosing;

// CLEAR-STAGING //- (void)clearReloadStagingOfContent ;

@end
