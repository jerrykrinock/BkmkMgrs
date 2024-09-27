#import "BkmxAppDel+Actions.h"
#import "BkmxGlobals.h"
#import "NSError+MyDomain.h"
#import "BkmxBasis+Strings.h"
#import "ContentOutlineView.h"
#import "StarkTableColumn.h"
#import "BkmxDoc+Autosaving.h"
#import "Dupetainer.h"
#import "BkmxDocWinCon+Autosaving.h"
#import "Bookshig.h"
#import "Extore.h"
#import "VerifyProgressController.h"
#import "VerifySummary.h"
#import "StarkEditor.h"
#import "SSYSizeFixxerSubview.h"
#import "NSArray+SSYMutations.h"
#import "FindViewController.h"
#import "SSYTokenField.h"
#import "Syncer.h"
#import "NSObject+SuperUtils.h"
#import "NSView+Layout.h"
#import "NSString+Clipboard.h"
#import "MAKVONotificationCenter.h"
#import "NSUserDefaults+KeyPaths.h"
#import "NSUserDefaults+Bkmx.h"
#import "PrefsWinCon.h"
#import "Stark.h"
#import "Starkoid.h"
#import "Starker.h"
#import "SSYToolbarButton.h"
#import "SSYLaunchdBasics.h"
#import "NSString+LocalizeSSY.h"
#import "SSYProgressView.h"
#import "NSTabView+Safe.h"
#import "NSInvocation+Quick.h"
#import "NSDocumentController+DisambiguateForUTI.h"
#import "NSArray+Stringing.h"
#import "SSYTabView.h"
#import "SSYSidebarController.h"
#import "BkmxSearchField.h"
#import "NS(Attributed)String+Geometrics.h"
#import "NSTableView+Autosave.h"
#import "SSYDooDooUndoManager.h"
#import "NSWindow+Sizing.h"
#import "IxportLog.h"
#import "SSYHintArrow.h"
#import "NSArray+SafeGetters.h"
#import "NSFont+Height.h"
#import "StarkContainersFlatMenu.h"
#import "SSYMH.AppAnchors.h"
#import "NSString+SSYExtraUtils.h"
#import "NSNumber+SharypeCoarseDisplay.h"
#import "NSNumber+ChangeTypesSymbols.h"
#import "SSYSheetEnder.h"
#import "ClientListView.h"
#import "SSYVectorImages.h"
#import "NSImage+Transform.h"
#import "NSSet+SimpleMutations.h"
#import "Macster.h"
#import "Stager.h"
#import "ClientInfoController.h"
#import "ImportPostprocController.h"
#import "Trigger.h"
#import "DupesOutlineView.h"
#import "BkmxDoc+GuiStuff.h"
#import "BkmxDoc+Actions.h"
#import "ClientChoice.h"
#import "Client.h"
#import "NSMenu+Ancestry.h"
#import "NSPredicate+SSYMore.h"
#import "NSSplitView+Fraction.h"
#import "SSYLabelledTextField.h"
#import "BkmxLazyView.h"
#import "CntntViewController.h"
#import "SettingsViewController.h"
#import "ReportsViewController.h"
#import "NSTabViewItem+SSYTabHierarchy.h"
#import "SafeLimitGuider.h"
#import "NSEntityDescription+SSYMavericksBugFix.h"
#import "NSDocument+SSYAutosaveBetter.h"
#import "SSYEventInfo.h"
#import "SSYOperationQueue.h"
#import "SSYToolbarButton.h"

// For troubleshooting only

#define MIN_OUTLINE_DEPTH 1
#define MAX_OUTLINE_DEPTH 6

// The following are tab views' dentifiers in BkmxDoc.nib

NSString* const constIdentifierTabViewContent = @"content" ;
NSString* const constIdentifierTabViewSettings = @"settings" ;
NSString* const constIdentifierTabViewReports = @"reports" ;

NSString* const constIdentifierTabViewGeneral = @"general" ;
NSString* const constIdentifierTabViewOpenSave = @"openSave" ;
NSString* const constIdentifierTabViewSorting = @"sorting" ;
NSString* const constIdentifierTabViewStructure = @"structure" ;
NSString* const constIdentifierTabViewClients = @"clients" ;
NSString* const constIdentifierTabViewSyncing = @"syncing" ;

NSString* const constIdentifierTabViewSimple = @"simple" ;
NSString* const constIdentifierTabViewAdvanced = @"advanced" ;

NSString* const constIdentifierTabViewFindReplace = @"findReplace" ;
NSString* const constIdentifierTabViewDupes = @"dupes" ;
NSString* const constIdentifierTabViewVerify = @"verify" ;
NSString* const constIdentifierTabViewDiaries = @"diaries" ;


/* No longer used
 // This NSNumber category is necessary so that the -tagsArray
// message can flow through the binding of the little cloud's
// object value to the BkmxDocWinCon via the key path
// contentView.selectedObject.tagsArray
@interface NSNumber (TagsArray)
- (id)tagsArray ;
@end
@implementation NSNumber (TagsArray)
- (id)tagsArray {
	return self ;
}
@end
*/


@interface BkmxDocWinCon ()

@property (assign) BOOL selectionChangeTrigger ;
@property (assign) BOOL autosaveArmed ;
@property (assign) NSTimer* yellowSyncExplainTimer;
@property (assign) BOOL isObservingForYellowSyncExplain;
@property (assign) BOOL isAwake;

/*!
 @brief    Indicates whether or not we are in the version browser;
 see details.
 
 @details  Note the difference between -[BkmxDocWinCon isInVersionBrowser]
 and -[NSDocument ssy_isInViewingMode].  The former indicates
 that we are in either the "Current Document" *or* the "Yesterday at XX:XX",
 i.e. either the left- or right-hand window in the
 version browser.  The latter indicates that we are
 the "Prior Version", right-hand window in the version browser.
 */
@property (assign) BOOL isInVersionBrowser ;

@end



@implementation BkmxDocWinCon

@synthesize selectionChangeTrigger ;
@synthesize autosaveArmed ;
@synthesize laterSize = m_laterSize ;
@synthesize windowIsBeingAutosized = m_windowIsBeingAutosized ;
@synthesize searchText = m_searchText ;

@synthesize cntntViewController = m_cntntViewController ;
@synthesize settingsViewController = m_settingsViewController ;
@synthesize reportsViewController = m_reportsViewController ;

- (ContentOutlineView*)contentOutlineView {
    return [[self cntntViewController] contentOutlineView] ;
}

- (DupesOutlineView*)dupesOutlineView {
    return [[self reportsViewController] dupesOutlineView] ;
}

- (void)setAViewController:(NSViewController*)aViewController {
    if ([aViewController isKindOfClass:[CntntViewController class]]) {
        [self setCntntViewController:(CntntViewController*)aViewController] ;
    }
    else if ([aViewController isKindOfClass:[SettingsViewController class]]) {
        [self setSettingsViewController:(SettingsViewController*)aViewController] ;
    }
    else if ([aViewController isKindOfClass:[ReportsViewController class]]) {
        [self setReportsViewController:(ReportsViewController*)aViewController] ;
    }
}

- (FindTableView*)findTableView {
    FindViewController* findViewController = [[self reportsViewController] findViewController] ;
    FindTableView* findTableView = [findViewController findTableView] ;

    return findTableView ;
}

- (BkmxSearchField*)searchField {
    return searchField ;
}

// Apparently, the NSWindowWillEnterVersionBrowserNotification is not received
// if a document opens on the right side of the version browser, i.e. in
// viewing mode.  Therefore we need to override this getter as such…
- (BOOL)isInVersionBrowser {
	BOOL answer ;
	@synchronized(self) {
		answer = (m_isInVersionBrowser || [[self document] ssy_isInViewingMode]) ;
	}
	
	return answer ;
}

// … and, because Xcode cannot pair a synthesized setter with a user-defined getter
// for a writable atomic property,

- (void)setIsInVersionBrowser:(BOOL)newValue {
	@synchronized(self) {
		m_isInVersionBrowser = newValue ;
	}
}

- (BOOL)outlineMode {
    return [[self cntntViewController] outlineMode] ;
}

- (void)setOutlineMode:(BOOL)outlineMode {
    [[self cntntViewController] setOutlineMode:outlineMode] ;
}

- (SSYProgressView*)progressView {
	return progressView ;
} 

- (SSYTabView*)topTabView  {
	return topTabView ;
}

- (void)showWindow:(id)sender { // overrides base class method 
	[self updateWindowForStark:nil] ;
	[super showWindow:self] ; 	// !! This also makes key and orders front !!
}

- (NSTabViewItem*)activeTabViewItem {
	NSTabViewItem* selectedTabViewItem = [topTabView selectedTabViewItem] ;
	return [selectedTabViewItem selectedLeafmostTabViewItem] ;
}

- (NSString*)activeTabViewItemIdentifier {
	return [[self activeTabViewItem] identifier] ;
}

- (void)revealTabViewIdentifier1:(NSString*)identifier1
                     identifier2:(NSString*)identifier2 {
	// The ..Safely.. version is used because I have seen exceptions
	// raised in difficult-to-reproduce corner cases.
	[topTabView selectTabViewItemSafelyWithIdentifier:identifier1] ;
	
	if (identifier2) {
        NSTabViewItem* topSelectedTabViewItem = [topTabView selectedTabViewItem] ;
		NSTabView* deeperTabView = [topSelectedTabViewItem deeperTabView] ;
        // The ..Safely.. version is used because I have seen exceptions
        // raised in difficult-to-reproduce corner cases.
        [deeperTabView selectTabViewItemSafelyWithIdentifier:identifier2] ;
	}
}

- (NSInteger)depthOfTabViewIdentifier:(NSString*)identifier {
	// Level 0 tabs
	if ([identifier isEqualToString:constIdentifierTabViewContent]) {
		return 0 ;
	}
	if ([identifier isEqualToString:constIdentifierTabViewSettings]) {
		return 0 ;
	}
	if ([identifier isEqualToString:constIdentifierTabViewReports]) {
		return 0 ;
	}
	
	// Level 2 tabs
	if ([identifier isEqualToString:constIdentifierTabViewSimple]) {
		return 2 ;
	}
	if ([identifier isEqualToString:constIdentifierTabViewAdvanced]) {
		return 2 ;
	}

	// If we are here, it must be one of the Level 1 tabs
	return 1 ;
}

- (BOOL)parentTabIsSettingsForTabViewIdentifier:(NSString*)identifier {
	return (
			[identifier isEqualToString:constIdentifierTabViewGeneral]
			||
			[identifier isEqualToString:constIdentifierTabViewOpenSave]
			||
			[identifier isEqualToString:constIdentifierTabViewClients]
			||
			[identifier isEqualToString:constIdentifierTabViewSorting]
			||
			[identifier isEqualToString:constIdentifierTabViewStructure]
			||
			[identifier isEqualToString:constIdentifierTabViewSyncing]
			||
			[identifier isEqualToString:constIdentifierTabViewSimple]
			||
			[identifier isEqualToString:constIdentifierTabViewAdvanced]
			) ;		
}

- (BOOL)parentTabIsReportsForTabViewIdentifier:(NSString*)identifier {
	return (
			[identifier isEqualToString:constIdentifierTabViewDupes]
			||
			[identifier isEqualToString:constIdentifierTabViewVerify]
			||
			[identifier isEqualToString:constIdentifierTabViewFindReplace]
			||
			[identifier isEqualToString:constIdentifierTabViewDiaries]
			) ;			
}

- (void)tabViewIdentifiersForLeafIdentifier:(NSString*)leafIdentifier
									  id1_p:(NSString**)id1_p
									  id2_p:(NSString**)id2_p {
	if ([self depthOfTabViewIdentifier:leafIdentifier] == 0) {
		*id1_p = leafIdentifier ;
	}
	else if ([self parentTabIsSettingsForTabViewIdentifier:leafIdentifier]) {
		*id1_p = constIdentifierTabViewSettings ;
		*id2_p = leafIdentifier ;
	}
	else if ([self parentTabIsReportsForTabViewIdentifier:leafIdentifier]) {
		*id1_p = constIdentifierTabViewReports ;
		*id2_p = leafIdentifier ;
	}	
}

- (BOOL)revealTabViewIdentifier:(NSString*)identifier {
	NSString* id1 = nil ;
	NSString* id2 = nil ;
	[self tabViewIdentifiersForLeafIdentifier:identifier
										id1_p:&id1
										id2_p:&id2] ;
	
	if (!id1) {
		return NO ;
	}
	
	[self revealTabViewIdentifier1:id1
					   identifier2:id2] ;
	return YES ;
}

- (IBAction)revealTabViewContent:(id)sender {
	[self revealTabViewIdentifier1:constIdentifierTabViewContent
					   identifier2:nil] ;
}

- (IBAction)revealTabViewSettings:(id)sender {
	[self revealTabViewIdentifier1:constIdentifierTabViewSettings
					   identifier2:nil] ;
}

- (IBAction)revealTabViewReports:(id)sender {
	[self revealTabViewIdentifier1:constIdentifierTabViewReports
					   identifier2:nil] ;
}

- (IBAction)revealTabViewMenuItem:(NSMenuItem*)sender {
    
	[self revealTabViewIdentifier1:constIdentifierTabViewReports
					   identifier2:nil] ;
}

- (IBAction)revealTabViewClients:(id)sender {
	[self revealTabViewIdentifier1:constIdentifierTabViewSettings
					   identifier2:constIdentifierTabViewClients] ;
}

- (NSArray*)displayedTabViewIdentifiers {
	NSMutableArray* array = [NSMutableArray array] ;
	NSTabViewItem* selectedTabViewItemLevel1 = [topTabView selectedTabViewItem] ;
	if (selectedTabViewItemLevel1) {
		[array addObject:[selectedTabViewItemLevel1 identifier]] ;

        NSTabView* deeperTabView = [selectedTabViewItemLevel1 deeperTabView] ;
        NSTabViewItem* selectedTabViewItemLevel2 = [deeperTabView selectedTabViewItem] ;

		if (selectedTabViewItemLevel2) {
            [array addObject:[selectedTabViewItemLevel2 identifier]] ;
        }
	}

	return [[array copy] autorelease] ;
}

#define SEGMENTED_CONTROL_AND_SURROUNDING_WHITESPACE_HEIGHT 37.0

#define STATUS_BAR_HEIGHT 23.0

#define REGULAR_TAB_VIEW_CONTROL_AND_SURROUNDING_WHITESPACE_HEIGHT 40.0
#define TEXT_AGENTS_OPERATE_UPON_YOUR_PRIME_BOOKMARKSHELF_HEIGHT 34.0
#define AGENTS_TABS_EXTRA_HEIGHT   REGULAR_TAB_VIEW_CONTROL_AND_SURROUNDING_WHITESPACE_HEIGHT \
+ TEXT_AGENTS_OPERATE_UPON_YOUR_PRIME_BOOKMARKSHELF_HEIGHT 

/*!
 @brief    Returns the difference between the window height and the tab view
 height for a given tab view item.

 @details  This difference is composed of the title bar height, toolbar height,
 status bar height and, for non-root tab view items, the height of the segmented
 control used for selecting the non-root tab view item, and the whitespace above
 and below it.
*/
- (CGFloat)deadHeightForTabViewItem:(NSTabViewItem*)tabViewItem {
	CGFloat deadHeight = [[self window] tootlebarHeight] + STATUS_BAR_HEIGHT ;
	NSInteger depth = [self depthOfTabViewIdentifier:[tabViewItem identifier]] ;
	if (depth > 0) {
		// tabViewItem is General, Sorting, ... Syncing; or Find, Dupes, ... Logs
		deadHeight += SEGMENTED_CONTROL_AND_SURROUNDING_WHITESPACE_HEIGHT ;
	}
	if (depth > 1) {
		// tabViewItem is Simple or Advanced
		deadHeight += AGENTS_TABS_EXTRA_HEIGHT ;
	}
	return deadHeight ;
}

- (SSYSizability)sizabilityForTabViewItem:(NSTabViewItem*)tabViewItem {
    SSYSizability sizability = SSYSizabilityUnknown ;
    
    if (tabViewItem == tabContent) {
        sizability = SSYSizabilityUserSizable ;
    }
    
    if ((sizability == SSYSizabilityUnknown) && [self cntntViewController]) {
		sizability = [[self cntntViewController] sizabilityForTabViewItem:tabViewItem] ;
	}
    if ((sizability == SSYSizabilityUnknown) && [self settingsViewController])  {
		sizability = [[self reportsViewController] sizabilityForTabViewItem:tabViewItem] ;
	}
    if ((sizability == SSYSizabilityUnknown) && [self reportsViewController])  {
		sizability = [[self reportsViewController] sizabilityForTabViewItem:tabViewItem] ; ;
	}

    return sizability ;
}

#define WINDOW_SIDE_MARGINS_TO_CLIENT_LIST_VIEW 2*20.0

- (NSSize)minimumSizeForTabViewItem:(NSTabViewItem*)tabViewItem {
	NSString* identifier = [tabViewItem identifier] ;
	
	// IMPORTANT: In the constants that follow, if the width or height is 0.0,
	// this indicates that the width or height is FIXED because 
	// there are no stretchable subviews in that dimension.
	
	// The sizes given in the code here are those needed for the control subviews 
	// ane their whitespace, plus, if applicable, the segmented control for
	// selecting second-level tab
	//    not including the title bar
	//    not including the toolbar
	//    not including
	//    not including the status bar
	
	NSSize size ;
	
	if ([identifier isEqualToString:constIdentifierTabViewContent]) {
		size = NSMakeSize(550.0, 180.0) ; 
	}
	else if ([identifier isEqualToString:constIdentifierTabViewFindReplace]) {
		size = NSMakeSize(580.0, 190.0) ; 
	}
	else if ([identifier isEqualToString:constIdentifierTabViewDupes]) {
		size = NSMakeSize(550.0, 160.0) ; 
	}
	else if ([identifier isEqualToString:constIdentifierTabViewClients]) {
        CGFloat width = [[self.settingsViewController clientListView] requiredWidth];
        width += WINDOW_SIDE_MARGINS_TO_CLIENT_LIST_VIEW;
        if (width < 520.0) {
            width = 520.0;
        }

		size = NSMakeSize(width, [[self settingsViewController] clientTabMinimumHeight]) ;
	}
	else if ([identifier isEqualToString:constIdentifierTabViewDiaries]) {
		size = NSMakeSize(500.0, 200.0) ;  // 200 was 160 til BookMacster 1.17
	}
	else if ([identifier isEqualToString:constIdentifierTabViewGeneral]) {
		if ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppBookMacster) {
            size = NSMakeSize(580.0, 360.0) ;
        }
        else {
            size = NSZeroSize ;
        }
	}
	else if ([identifier isEqualToString:constIdentifierTabViewAdvanced]) {
		size = NSMakeSize(580.0,  334.0) ; // 334 was 445 til BookMacster 1.17
	}
	else {
		size = NSZeroSize ;
	}

	return size ;
}

- (NSSize)defaultSizeForTabViewItem:(NSTabViewItem*)tabViewItem {
	NSString* identifier = [tabViewItem identifier] ;
	
	// IMPORTANT: In the constants that follow, if the width or height is 0.0,
	// this indicates that the width or height is FIXED because 
	// there are no stretchable subviews in that dimension.

	// The sizes given in the code here are those needed for their subviews
	// ane surrounding whitespace only
	//    not including the title bar
	//    not including the toolbar
	//    not including the segmented control for selecting second-level tab
	//    not including the status bar
	
	NSSize size ;
	
	if ([identifier isEqualToString:constIdentifierTabViewContent]) {
		size = NSMakeSize(560.0, 350.0) ; 
	}
	else if ([identifier isEqualToString:constIdentifierTabViewFindReplace]) {
		size = NSMakeSize(580.0, 350.0) ; 
	}
	else if ([identifier isEqualToString:constIdentifierTabViewDupes]) {
		size = NSMakeSize(560.0, 350.0) ; 
	}
	else if ([identifier isEqualToString:constIdentifierTabViewClients]) {
		size = NSMakeSize(516.0, [[self settingsViewController] clientTabMinimumHeight]) ;
	}
	else if ([identifier isEqualToString:constIdentifierTabViewDiaries]) {
		size = NSMakeSize(560.0, 350.0) ; 
	}
	else if ([identifier isEqualToString:constIdentifierTabViewGeneral]) {
        if ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppBookMacster) {
            size = NSMakeSize(580.0, 350.0) ;
        }
        else {
            // Because we don't have the "Comments" text field, size is fixed…
            size = NSZeroSize ;
        }
	}
	else if ([identifier isEqualToString:constIdentifierTabViewAdvanced]) {
		size = NSMakeSize(580.0,  420.0) ;
	}
	else {
		// Size is *fixed* for the other tabs.  We signify that thus ...
		size = NSZeroSize ;
	}
	
	return size ;
}

/*!
 @brief    Returns the fixed size that the top tab view should be, for a 
 given leaf tab view item.
 
 @details  The fixed size is calculated by finding the top/right edge of the
 topmost/rightmost item and subtracting from this the bottom/left
 edge of the bottommost/leftmost item, and then adding some
 whitespace around the edges.
 
 @param    tabViewItem  Must be a leaf tab view item
 */
- (NSSize)fixedSizeForTabViewItem:(NSTabViewItem*)tabViewItem {
	NSArray* subviews = [[tabViewItem view] subviews] ;

    NSSize size = [SSYSizeFixxerSubview fixedSizeAmongSubviews:subviews
                                                   defaultSize:NSMakeSize(800.0, 600.0)] ;

	return size ;
}

- (NSSize)sizeForTabViewItem:(NSTabViewItem*)tabViewItem {
	// Algorithm for determining current window size for this tab view item:
	
	// If default dimension is 0, this dimension is fixed.  Use the fixed size.
	// Else, if there is an autosaved frame, use its dimension, subject to minimum.
	// Else, use the default dimension, use its dimension, subject to minimum.

	NSSize autosavedSize = NSZeroSize ;
	NSString* sizeString = [self autosavedContentSizeOfTabViewItem:tabViewItem] ;
	if (sizeString) {
		autosavedSize = NSSizeFromString(sizeString) ;
	}
	NSSize defaultSize = [self defaultSizeForTabViewItem:tabViewItem] ;
	NSSize minimumSize = [self minimumSizeForTabViewItem:tabViewItem] ;

	NSSize newSize ;

    if (defaultSize.width == 0.0)  {
		newSize.width = [self fixedSizeForTabViewItem:tabViewItem].width ;
	}
	else {
		if (autosavedSize.width > 0.0) {
			newSize.width = autosavedSize.width ;
		}
		else {
			newSize.width = defaultSize.width ;
		}
		
		newSize.width = MAX(newSize.width, minimumSize.width) ;
	}
	
	if (defaultSize.height == 0.0)  {
		newSize.height = [self fixedSizeForTabViewItem:tabViewItem].height ;
	}
	else {
		if (autosavedSize.height > 0.0) {
			newSize.height = autosavedSize.height ;
		}
		else {
			newSize.height = defaultSize.height ;
		}
		
		newSize.height = MAX(newSize.height, minimumSize.height) ;
	}
	
	// A special consideration for the Settings subtabs
	NSString* identifier = [tabViewItem identifier] ;
	if ([self parentTabIsSettingsForTabViewIdentifier:identifier]) {
		newSize.width = MAX(newSize.width, [[self settingsViewController] minimumWidth]) ;
	}

	return newSize ;
}

- (NSRect)windowFrameForTabViewItem:(NSTabViewItem*)tabViewItem
                        tabViewSize:(NSSize)tabViewSize {
    /* If both of the given tab view dimensions are 0.0, we will return the
     current window frame. */
	NSRect frame = [[self window] frame] ;

	if ((tabViewSize.width != 0.0) || (tabViewSize.height != 0.0)) {
		if (tabViewSize.width > 0.0) {
			CGFloat x = frame.origin.x ;
			CGFloat w = frame.size.width ;
			
			x += (w - tabViewSize.width)/2 ;
			frame.origin.x = x ;
			frame.size.width = tabViewSize.width ;
		}
		
		if (tabViewSize.height > 0.0) {
			CGFloat y = frame.origin.y ;
			CGFloat h = frame.size.height ;
			
			CGFloat deadHeight = [self deadHeightForTabViewItem:tabViewItem] ;
            CGFloat newWindowHeight = tabViewSize.height + deadHeight ;
			frame.origin.y = y + h - newWindowHeight ;
			frame.size.height = newWindowHeight ;
		}
	}
	
	return frame ;
}

- (void)resizeWindowForTabViewItem:(NSTabViewItem*)tabViewItem
							  size:(NSSize)tabViewSize {
	if ([self isInVersionBrowser]) {
		return ;
	}
    
    /*
     The following code was added in BookMacster 1.17 to fix this situation…
     • Set tab Settings to General.
     • Set tab Reports to Dupes.
     • Set top tab to Reports
     • Close window.
     • Reopen window.  Reports > Duplicates will be shown.
     • Click the top tab: Settings
     The tabView:willSelectTabViewItem: and tabView:didSelectTabViewItem:
     NSTabView delegate methods will be triggered when you click the tab
     Settings, but will not work correctly because, at the time that
     tabView:willSelectTabViewItem: runs, the SettingsLazyView has not loaded
     its payload and still has its placeholder views.  It therefore sets the
     window to a bogus size and, more significantly in this case, assigns
     a bogus value to the ivar laterSize.  To correct the problem of window
     not being resized for already-set tabs when a view is initially loaded,
     we have designed -tabDidPayloadNote: to invoke
     [self resizeWindowAndConstrainSizeForActiveTabViewItem].  And indeed,
     this happens next, and it works.  But then, a few milliseconds later,
     tabView:didSelectTabViewItem: runs.  It operates based on the bogus
     laterSize, resizing the window to the wrong size.  In other words,
     tabDidPayloadNote: fixes the initial damage done by
     tabView:willSelectTabViewItem:, but not the time bomb that it lays.
     To fix the time bomb, we do the following.  Another way to do this might
     be to verify that [self laterSize] is not NSZeroSize
     */
    if (![tabViewItem isViewPayloaded]) {
        return ;
    }
	
	NSRect frame = [self windowFrameForTabViewItem:tabViewItem
                                       tabViewSize:tabViewSize] ;

    /* If windowFrameForTabViewItem:tabViewSize: simply returned the current
     window frame, don't do anything */
	if (
		([[self window] frame].size.width != frame.size.width)
		||
		([[self window] frame].size.height != frame.size.height)
		) {
		[self setWindowIsBeingAutosized:YES] ;

		[[self window] setFrame:frame
						display:YES
						animate:YES] ;

		[self setWindowIsBeingAutosized:NO] ;
	}
}

- (void)resizeWindowForLeafTabViewItem:(NSTabViewItem*)tabViewItem {
    NSSize size = [self sizeForTabViewItem:tabViewItem] ;
    [self resizeWindowForTabViewItem:tabViewItem
                                size:size] ;
}

- (void)constrainWindowSizeForTabViewItem:(NSTabViewItem*)tabViewItem {
	NSWindow* window = [self window] ;
    SSYSizability sizability = [self sizabilityForTabViewItem:tabViewItem] ;
	BOOL isUserSizeable = (sizability == SSYSizabilityUserSizable) ;

	NSUInteger styleMask = [window styleMask] ;
	if (isUserSizeable) {
		styleMask |= NSWindowStyleMaskResizable ;
	}
	else {
		styleMask &= ~NSWindowStyleMaskResizable ;
	}
	[window setStyleMask:styleMask] ;

    NSSize tabMinSize = [self minimumSizeForTabViewItem:tabViewItem] ;
    CGFloat deadHeight = [self deadHeightForTabViewItem:tabViewItem] ;
    CGFloat windowContentMinHeight = tabMinSize.height + deadHeight - [window tootlebarHeight] ;
    NSSize windowMinContentSize = NSMakeSize(tabMinSize.width, windowContentMinHeight) ;
	// Note that in the case of a fixed-size tab, we may be setting the
	// minimum width and height to very small or zero here, but that is of no
	// consequence since the window will not be resizeable.
	[window setContentMinSize:windowMinContentSize] ;
    // I tried -setMinSize: instead of -setContentMinSize:, so I could avoid
    // subtracting out the tootlebar height, but inexplicably it did not work…
    // http://lists.apple.com/archives/cocoa-dev/2013/Aug/msg00526.html
}

- (void)resizeWindowAndConstrainSizeForActiveTabViewItem {
	NSTabViewItem* tabViewItem = [self activeTabViewItem] ;
    NSTabViewItem* leafmostItem = [tabViewItem selectedLeafmostTabViewItem] ;
	NSSize size = [self sizeForTabViewItem:leafmostItem]  ;
	[self resizeWindowForTabViewItem:tabViewItem
								size:size] ;
    // Note that we resized the window *before* constraining the size, because,
    // and this is obliquely in NSWindow documentation, -setMinSize will *not*
    // override the size if it is set by -setFrame:display:.
	[self constrainWindowSizeForTabViewItem:tabViewItem] ;
}


// NSTabView delegate messages:

/*
 Window resizing may be nonlinear and nonreversible...
 
 If we resize the window before changing tab view items,
 then if user selects a tab view item whose size is smaller than
 the minimum size of the current tab view item, the current
 tab view item will be squished as the window is resized,
 and the *next* time it is displayed, it will be ugly --
 typically some subviews which had been separated will overlap.
 
 If we resize the window after changing tab view items,
 then if user selects a new tab view item whose minimum size is
 larger than the current window size (which is possible of
 the minimum size of the current tab view item is smaller),
 then the the new tab view item will be squished as soon as
 it is swapped in.  It will be displayed ugly -- typically some
 subviews which had been separated will overlap, and they will
 not return to their proper positions when the window is
 resized the appropriate size.
 
 The solution to this problem pair is to compare the sizes before
 selecting the tab view item, in tabView:willSelectTabViewItem:.
 If the new size is going to be bigger, we resize the window
 immediately.  If the new size is going to be smaller, we set
 laterSize and resize the window after the tab view
 item is changed, in tabView:didSelectTabViewItem:.
 
 Actually, width and height must be considered separately.
 Repeat the above, first with size=width, then with size=height
 */
- (void)       tabView:(NSTabView*)tabView
 willSelectTabViewItem:(NSTabViewItem*)newItem {
    if (![newItem isViewPayloaded]) {
        return ;
    }
    
	// Gather data on current item
	NSTabViewItem* nowItem = [self activeTabViewItem] ;
	NSSize currentSize = [[self window] frame].size ;
	currentSize.height -= [self deadHeightForTabViewItem:nowItem] ;

	// In case this the item is not the actual leaf
	NSTabViewItem* newLeafItem = [newItem selectedLeafmostTabViewItem] ;

	NSSize newSize = [self sizeForTabViewItem:newLeafItem] ;

	CGFloat doNowWidth ;
	CGFloat doLaterWidth ;
	if (newSize.width > currentSize.width) {
		doNowWidth = newSize.width ;
		doLaterWidth = 0.0 ;
	}
	else {
		doNowWidth = 0.0 ;
		doLaterWidth = newSize.width ;
	}
	
	CGFloat doNowHeight ;
	CGFloat doLaterHeight ;	
	if (newSize.height > currentSize.height) {
		doNowHeight = newSize.height ;
		doLaterHeight = 0.0 ;
	}
	else {
		doNowHeight = 0.0 ;
		doLaterHeight = newSize.height ;
	}
	
    NSSize doNowSize = NSMakeSize(doNowWidth, doNowHeight) ;
    [self resizeWindowForTabViewItem:newLeafItem
                                size:doNowSize] ;
    
	NSSize doLaterSize = NSMakeSize(doLaterWidth, doLaterHeight) ;
	[self setLaterSize:doLaterSize] ;
}

- (void)       tabView:(NSTabView*)tabView
  didSelectTabViewItem:(NSTabViewItem*)tabViewItem {
	//  Handle autosave
	if ([self autosaveArmed]) {
		// We don't want to store the tab view selection for syncingTabView,
		// because, for robustness and data consistency, that state is
		// is restored in accordance with the 'syncerConfig'
		// attribute of the Macster, stored in the settingsMoc.
		// So we ignore it here.  See -restoreSyncingTabViewSelection.
		if (
            // If settingsViewController is nil, Settings.xib is not loaded
            // and therefore tabView could *not* be syncingTabView…
            ![self settingsViewController]
            ||
            // Or, if settingsViewController is up and running, ask it
            [[self settingsViewController] shouldAutosaveStateOfTabView:tabView]) {
			[self autosaveSelectedTabViewItem:tabViewItem
									inTabView:tabView] ;
		}
	}

	/* Propagate possible change in selected stark.  The 'if` condition
     was added in an attempt to fix Note CocoaBindingsIsBad.  At first
     I thought it helped, then not, but I left it in since it seems like
     a good idea. */
    if (m_isAwake) {
        [self handleChangedSelectionNotification:nil] ;
    }
	
	// In case this the item is 'settings' or 'reports'
	tabViewItem = [tabViewItem selectedLeafmostTabViewItem] ;
	
    // BOOL c1, c2 were added in BookMacster 1.17, to fix some weird edge
    // cases wherein laterSize could have some prior crap in it.  Also note that
    // we then set laterSize to NSZeroSize after we're done reading it once.
    BOOL c1 = ([self laterSize].width > 0.0) ;
    BOOL c2 = ([self laterSize].height > 0.0) ;
    // Do resizing as needed
    if (c1 || c2) {
		[self resizeWindowForTabViewItem:tabViewItem
									size:[self laterSize]] ;
        [self setLaterSize:NSZeroSize] ;
	}
    
    // Note that we resized the window *before* constraining the size, because,
    // and this is obliquely in NSWindow documentation, -setMinSize will *not*
    // override the size if it is set by -setFrame:display:.
    [self constrainWindowSizeForTabViewItem:tabViewItem] ;
    

    if ([[tabViewItem identifier] isEqualToString:constIdentifierTabViewClients]) {
        [[self.settingsViewController clientListView] performSelector:@selector(update)
                                                           withObject:nil
                                                           afterDelay:0.0] ;
    }

    // The following should not be necessary if the Simple or Advanced
	// tab was clicked by the user, because this tab will be remembered
	// by the window autosave.  It is necessary, however, if Syncers are
	// set in code, for example on a first run, and then the window
	// is opened for the first time.
	
	// Select the appropriate sub-tab (Simple or Advanced)
	[[self settingsViewController] selectSyncingTabPerCurrentExpertise] ;
    
    [self updateSearchFieldPlaceholder] ;
}

+ (NSSet*)undoableTabViewIdentifiers {
	return [NSSet setWithObjects:
			constIdentifierTabViewContent,
			constIdentifierTabViewDupes,
			constIdentifierTabViewGeneral,
			constIdentifierTabViewSorting,
			constIdentifierTabViewStructure,
			nil] ;
}

- (BOOL)activeTabViewIsUndoable {
	NSString* activeIdentifier = [self activeTabViewItemIdentifier] ;
	return ([[BkmxDocWinCon undoableTabViewIdentifiers] member:activeIdentifier] != nil) ;
}

- (NSString*)explainNotAvailableTabName:(NSString*)tabName {
	NSDocumentController* dc = [NSDocumentController sharedDocumentController] ;
	return 	 [NSString localizeFormat:
              @"accountDataDefX2",
              tabName,
              [dc defaultDocumentDisplayName]] ;
}

- (BOOL)           tabView:(NSTabView*)tabView
   shouldSelectTabViewItem:(NSTabViewItem*)tabViewItem {
	BOOL isInViewingMode = [[self document] ssy_isInViewingMode] ;
	if (isInViewingMode) {
		// First, consider selection of leaf tabs which are strictly disallowed
		NSString* tabName = nil ; // If tabName != nil, we'll return NO below
        if (!tabName) {
            tabName = ([[self cntntViewController] nameOfTabDisallowedInViewingModeForTabViewItem:tabViewItem]) ;
        }
        if (!tabName) {
            tabName = ([[self reportsViewController] nameOfTabDisallowedInViewingModeForTabViewItem:tabViewItem]) ;
        }
        if (!tabName) {
            tabName = ([[self reportsViewController] nameOfTabDisallowedInViewingModeForTabViewItem:tabViewItem]) ;
        }
		// Second, consider selection of higher-level tabs which we will
		// allow (return YES), but we must make sure that their subtab
		// selection is allowed and, if not, we just change it to one which
		// is allowed.
		else if (tabViewItem == tabContent) {
            [[self cntntViewController] changeToSubtabAllowedInViewingMode] ;
		}
		else if (tabViewItem == tabSettings) {
            [[self reportsViewController] changeToSubtabAllowedInViewingMode] ;
		}
		else if (tabViewItem == tabReports) {
            [[self reportsViewController] changeToSubtabAllowedInViewingMode] ;
		}
		
		if (tabName) {
            // This method may be invoked by Cocoa at the beginning of Viewing Mode,
            // before the window isVisible, which will cause the following sheet
            // to appear in the middle of the screen.  So we check for isVisible
            if ([[self window] isVisible]) {
                NSString* msg = [self explainNotAvailableTabName:tabName] ;
				SSYAlert* alert = [SSYAlert alert] ;
				[alert setSmallText:msg] ;
				[[self document] runModalSheetAlert:alert
                                         resizeable:NO
                                          iconStyle:SSYAlertIconInformational
									  modalDelegate:nil
									 didEndSelector:NULL
										contextInfo:NULL] ;
			}

			return NO ;
		}
	}
	
	BOOL ok = YES ;
    
    BkmxDocViewController <TabViewSizing> * viewController ;
    
    viewController = [self cntntViewController] ;
    if (viewController) {
        ok = ok && [viewController rawTabView:tabView
                      shouldSelectTabViewItem:tabViewItem] ;
    }
    viewController = [self settingsViewController] ;
    if (viewController) {
        ok = ok && [viewController rawTabView:tabView
                      shouldSelectTabViewItem:tabViewItem] ;
    }
    viewController = [self reportsViewController] ;
    if (viewController) {
        ok = ok && [viewController rawTabView:tabView
                      shouldSelectTabViewItem:tabViewItem] ;
    }
	
	return ok ;
}

- (NSArray*)selectedStarks {
	// See which tab view is selected
	NSArray* displayedTabViewIdentifiers = [self displayedTabViewIdentifiers] ;
	NSString* identifier1 = nil ;
	if ([displayedTabViewIdentifiers count] > 0) {
		identifier1 = [displayedTabViewIdentifiers objectAtIndex:0] ;
	}
	NSString* identifier2 = nil ;
	if ([displayedTabViewIdentifiers count] > 1) {
		identifier2 = [displayedTabViewIdentifiers objectAtIndex:1] ;
	}
	
	NSArray* selectedStarks_ = nil ;

	if ([identifier1 isEqualToString:@"reports"] && [identifier2 isEqualToString:@"dupes"]) {
		selectedStarks_ = [self selectedDupeStarks] ;
	}	
	else if ([identifier1 isEqualToString:@"reports"] && [identifier2 isEqualToString:@"findReplace"]){
		selectedStarks_ = [[self reportsViewController] selectedObjects] ;
	}
	else {
		// contentOutlineView is the default
		selectedStarks_ = [[self cntntViewController] selectedStarks] ;
	}	
	// Originally, I sent -isTheActiveControl to the relevant table, but then
	// later I decided that which tab was showing was more significant.
	
	return selectedStarks_ ;
}
+ (NSSet*)keyPathsForValuesAffectingSelectedStarks {
	return [NSSet setWithObjects:
			@"selectionChangeTrigger",
			nil] ;
}

- (id)selectedStark {
	// Cocoa provides "No Selection" placeholders automatically.
	// However, since "No Selection" is too big to fit in the Visit Count
	// field, it says "No S".
	// To fix this problem, in Interface Builder, I set the No Selection
	// Placeholder of its Value bindings to "  ".
	
	// If I return nil instead of NSNoSelectionMarker, the placeholders in
	// the Inspector will show "No Selection" when the window is first
	// created, but once a selection has been made, they will never switch
	// back to "No Selection".  They'll just be empty when the selection
	// goes to nil

	NSArray* selection = [self selectedStarks] ;
	id answer ;
	if ([selection count] == 1) {
		answer = [selection lastObject] ;
	}
	else if (!selection || [selection count] < 1) {
		answer = NSBindingSelectionMarker.noSelectionMarker ;
	}
	else {
		answer = NSBindingSelectionMarker.multipleValuesSelectionMarker ;
	}
	
	return answer ;
}
+ (NSSet*)keyPathsForValuesAffectingSelectedStark {
	return [self keyPathsForValuesAffectingSelectedStarks] ;
}

- (void)deselectAll {
    [[self cntntViewController] deselectAll] ;
}

- (void)handleChangedSelectionNotification:(NSNotification*)note {
	NSTableView* tableView = (NSTableView*)[note object] ;
	if (
		!tableView
		||
		([tableView window] == [self window])
		) {
		[self setSelectionChangeTrigger:![self selectionChangeTrigger]] ;
		[[self cntntViewController] updateDetailViewForStarks:[self selectedStarks]] ;
		
		// When this method had this line:
		// 		[[NSNotificationCenter defaultCenter] postNotificationName:constNoteBkmxSelectionDidChange
		//                                                          object:self] ;
		// I noticed that, as the Find window was displaying 2000 items, the Inspector window
		// would briefly flash attributes for each one.  To fix that, I enqueue and coalesce:
            /* The 'if` condition was added in an attempt to fix
             Note CocoaBindingsIsBad.  At first I thought it helped, then not,
             but I left it in since it seems like a good idea. */
            if (!m_didWillClose) {
                NSNotification* note = [NSNotification notificationWithName:constNoteBkmxSelectionDidChange
                                                                     object:self] ;
                [[NSNotificationQueue defaultQueue] enqueueNotification:note
                                                           postingStyle:NSPostASAP
                                                           coalesceMask:(NSNotificationCoalescingOnName|NSNotificationCoalescingOnSender)
                                                               forModes:nil] ;
            }
		// See "Note on Coalesce Mask" at bottom of SSYOperationQueue.m
	}
}

- (void)selectNewestIxportLog {
	[[self reportsViewController] selectNewestIxportLog] ;
}

- (void)exposeUIForUserToFixBadAgentIndex:(NSInteger)badAgentIndex
                          badCommandIndex:(NSInteger)badCommandIndex {
	[self revealTabViewIdentifier:constIdentifierTabViewSyncing] ;
    
    [[self settingsViewController] exposeUIForUserToFixBadAgentIndex:badAgentIndex
                                                     badCommandIndex:badCommandIndex] ;
}

- (NSString*)writeLogToPath:(NSString*)path
					   back:(NSInteger)back
					doStamp:(BOOL)doStamp
					error_p:(NSError**)error_p {
    NSError* error = nil ;
    if (![self reportsViewController]) {
        [self revealTabViewIdentifier:constIdentifierTabViewDiaries] ;
    }

    if (error_p && error) {
        *error_p = error ;
    }
    
    return [[self reportsViewController] writeLogToPath:path
                                                   back:back
                                                doStamp:doStamp
                                                error_p:error_p] ;
}

- (void)updateSearchFieldPlaceholder {
    NSString* placeholderString = nil ;
	if ([self findTabNowShowing]) {
        placeholderString = @"See below" ;
	}
    else {
        NSArray* keyPathArray = [[self document] autosaveKeyPathArrayWithLastKeys:constAutosaveSearchFor] ;
        NSArray* searchFors = [[NSUserDefaults standardUserDefaults] valueForKeyPathArray:keyPathArray] ;
        if ([searchFors count] == 0) {  // also works for searchFors = nil which is typical
            searchFors = [[NSUserDefaults standardUserDefaults] defaultQuickSearchParmsForKey:constAutosaveSearchFor] ;
        }
        searchFors = [searchFors arrayByRemovingEqualObjects] ;
        NSMutableArray* placeholders = [[NSMutableArray alloc] init] ;
        for (NSNumber* searchFor in searchFors) {
            if ([searchFor respondsToSelector:@selector(integerValue)]) {
                NSInteger searchForValue = [searchFor integerValue] ;
                if ((searchForValue & SharypeCoarseLeaf) == SharypeCoarseLeaf) {
                    [placeholders addObject:@"Bkmrks"] ;
                }
                if ((searchForValue & SharypeGeneralContainer) == SharypeGeneralContainer) {
                    [placeholders addObject:[[BkmxBasis sharedBasis] labelFolders]] ;
                }
            }
        }
        [placeholders sortUsingComparator:^NSComparisonResult(NSString* s1, NSString* s2) {
            return [s1 localizedCaseInsensitiveCompare:s2] ;
        }] ;
        placeholderString = [placeholders listValuesForKey:nil
                                               conjunction:nil
                                                truncateTo:4] ;
        [placeholders release] ;
    }
    
    [[searchField cell] setPlaceholderString:placeholderString] ;
}

- (void)updateWindowForStark:(Stark *)stark {
    NSString* verb = @"Loading Window";
    SSYProgressView* localProgressView = [[self progressView] setIndeterminate:YES
                                                             withLocalizedVerb:verb
                                                                      priority:SSYProgressPriorityLow];
    [[self cntntViewController] updateWindowForStark:stark] ;
    [[self settingsViewController] updateWindow] ;
    [[self reportsViewController] updateWindow] ;
    /* We don't need to annoy the user with "Completed: Loading Window" in the
     Status Bar.  So we send the following message with nil verb.  This will
     will restore any prior completions or progress to the Status Bar, and if
     none of those, just clear it. */
    [localProgressView showCompletionVerb:nil
                                   result:nil
                                 priority:SSYProgressPriorityLowest] ;
}

- (void)reloadNewBookmarkLandingMenu {
    [[self settingsViewController] reloadNewBookmarkLandingMenu] ;
}

- (void)updateOutlineMode {
    [[self cntntViewController] updateOutlineMode] ;
}

- (NSString*)hyperButtonTitleForVerifyResults {
    return [NSString localize:@"report"];
}

- (void)showVerifyResultsInProgressView {
	VerifySummary* summary = [(BkmxDoc*)[self document] verifySummary] ;
	
	NSString* rawText = [NSString stringWithFormat:@"%li %@,  %li %@,  %li %@,  %li %@.",
						 (long)summary.nTotalOk,
						 [NSString localize:@"ok"],
						 (long)summary.nTotalUpdated,
						 [[BkmxBasis sharedBasis] labelUpdated],
						 (long)summary.nTotalBroken,
						 [[BkmxBasis sharedBasis] labelBroken],
						 (long)summary.nTotalUnknown,
						 [NSString localize:@"unknown"]
                         ] ;
	
	[progressView setText:rawText
                hyperText:[self hyperButtonTitleForVerifyResults]
                   target:(BkmxDoc*)[self document]
                   action:@selector(showVerifyReport)] ;
}

- (BOOL)isShowingVerifyResults {
    /* A little kludgey in that if I ever set the Hyper Button's string to
     "Report" for a purpose other than verify results, this method would
     return false positive. */
    return [[[self progressView] hyperText] isEqualToString:[self hyperButtonTitleForVerifyResults]];
}

- (void)revealTabViewVerify {
	[self revealTabViewIdentifier1:constIdentifierTabViewReports
					   identifier2:constIdentifierTabViewVerify] ;
}

// I gave up on Cocoa Bindings for this in BkmkMgrs 1.22.23.
- (void)setInspectorButtonState:(BOOL)state {
    NSInteger newState = (state ? NSControlStateValueOn : NSControlStateValueOff) ;
    [toolbarItemInspector setValue:newState] ;
    NSString* toolTip = state
    ? [[BkmxBasis sharedBasis] labelHideInspector]
    : [[BkmxBasis sharedBasis] labelShowInspector] ;
    [toolbarItemInspector setToolTip:toolTip] ;
}


- (void)mikeAshObserveValueForKeyPath:(NSString*)keyPath
							 ofObject:(id)object
							   change:(NSDictionary*)change
							 userInfo:(id)userInfo {
    if ([keyPath isEqualToString:constKeyTableFontSize]) {
		[self reloadAll] ;
	}
}

/* This observer is only armed if the user defaults value for
 constKeyYellowSyncExplained is NO. */
- (void)observeValueForKeyPath:(NSString*)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if (object == toolbarItemSync) {
        if ([[change objectForKey:NSKeyValueChangeNewKey] integerValue] == NSControlStateValueOn) {
            /* If syncing is Ready when when window opens, value will change to
             ON twice.  Coalesce with a timer to ignore subsequent triggers. */
            [toolbarItemSync removeObserver:self
                                 forKeyPath:@"value"];
            self.isObservingForYellowSyncExplain = NO;
            if (@available(macOS 10.12, *)) {
                self.yellowSyncExplainTimer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                                              repeats:NO
                                                                                block:^(NSTimer * _Nonnull timer) {
                                                                                    [self explainToUserThatYellowIsTheNewGreen];
                                                                                }];
            } else {
                NSInvocation* invocation = [NSInvocation invocationWithTarget:self
                                                                     selector:@selector(explainToUserThatYellowIsTheNewGreen)
                                                              retainArguments:YES
                                                            argumentAddresses:NULL];
                self.yellowSyncExplainTimer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                                           invocation:invocation
                                                                              repeats:NO];
            }
        }
    }
}

- (void)explainToUserThatYellowIsTheNewGreen {
    self.yellowSyncExplainTimer = nil;
    NSString* formatString = NSLocalizedString(
                                               @"In the toolbar up there, you see we've changed the color of the \"Syncing\" button when syncing is \"Ready\" from green to yellow.\n\n"
                                               @"This is to emphasize that, to prevent conflicts, automatic syncing from browsers will not begin until after you close this window or quit %@.", nil);
    NSString* msg = [NSString stringWithFormat:
                     formatString,                                                                                                 [[BkmxBasis sharedBasis] appNameLocalized],
                     [[BkmxBasis sharedBasis] appNameLocalized]
                     ];
    SSYAlert* alert = [SSYAlert new];
    [alert setSmallText:msg];
    [self.document runModalSheetAlert:alert
                           resizeable:NO
                            iconStyle:SSYAlertIconInformational
                    completionHandler:^(NSModalResponse modalResponse) {
                        [[NSUserDefaults standardUserDefaults] setObject:@YES
                                                                  forKey:constKeyYellowSyncExplained];
                    }];
    [alert release];
}

- (void)beginAutosave {
	[self setAutosaveArmed:YES] ;	

	// The following is necessary for a New Document so that the
	// autosave values set during the document opening will be
	// available the SECOND time that a document is opened. We do
	// it here instead of during the save operation because the
	// document is already saved before the window is opened.
	// This method, -beginAutosave, is actually the last thing that
	// happens, apparently because the main thread is tied up by the
	// save operation, even though it's done in the operation queue.
	// See -saveAndClearUndo.  However, the important thing is
	// that it gets done after -awakeFromNib and after
	// setAutoSaveArmed:YES, which we have just executed.
	[self autosaveAllCurrentValues] ;
}

- (BOOL)findTabNowShowing {
    return 	(
             [[[topTabView selectedTabViewItem] identifier] isEqualToString:constIdentifierTabViewReports]
             &&
             [[self reportsViewController] findTabIsSelected]
             ) ;
}

- (void)tabViewChangedNote:(NSNotification*)note {
	if ([self findTabNowShowing]) {
        // Disable the Quick Search
        [toolbarItemSearch setEnabled:NO] ;
        // For performance reasons, we refresh the Find table only when it is showing.  Therefore,
        // we may now need to "pay up" for our past laziness.
		NSNotification* newNote = [NSNotification notificationWithName:constNoteBkmxFindResultsNeedRefresh
																object:self] ;
		[[NSNotificationQueue defaultQueue] enqueueNotification:newNote
												   postingStyle:NSPostWhenIdle] ;
	}
    else {
        [toolbarItemSearch setEnabled:YES] ;
    }
}

- (void)tabWillPayloadNote:(NSNotification*)note {
    [self setAutosaveArmed:NO] ;
}

- (void)tabDidPayloadNote:(NSNotification*)note {
    /*
     Because the NSTabViewDelegate methods -tabView:willSelectTabViewItem: and
    -tabView:willSelectTabViewItem: may not be invoked when a lazy view
     loads its payload, we resize the window "manually".
     */
	[self resizeWindowAndConstrainSizeForActiveTabViewItem] ;
    [self setAutosaveArmed:YES] ;
}

- (NSImage*)imageWithOverlay:(NSImage*)overlay
                     onImage:(NSImage*)image {
    NSImage* imageCopy = [image copy];
    [imageCopy lockFocus];
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
    NSRect rect = NSMakeRect(0.0, 0.0, image.size.width, image.size.height);
    [overlay drawInRect:rect
             fromRect:NSZeroRect
            operation:NSCompositingOperationSourceOver
             fraction:1.00];
    [imageCopy unlockFocus];
    [imageCopy autorelease];
    return imageCopy;
}

- (NSString *)view:(NSView *)view
  stringForToolTip:(NSToolTipTag)tag
			 point:(NSPoint)point
		  userData:(void *)userData {
	return @"Use Dropbox, or a similar service to sync to other Macs.\n\n"
	@"iCloud does not sync in this way, but will sync to your iOS devices via Safari bookmarks.  "
	@"Click the '?' Help button for further explanation." ;
}

- (void)adjustLicenseStatusIndication:(NSNotification*)note {
    SSYLicenseLevel licenseLevel = SSYLCCurrentLevel() ;
    NSString* title = nil;
    NSString* hyperText = nil;
    BOOL needsIt = NO;
    double delaySeconds = 1.0;
    if (licenseLevel < SSYLicenseLevelRegular) {
        needsIt = YES;
        delaySeconds = 3.0;  /* longer, because our progress view setting may
                              be clobbered by an exmpty string as window loads. */
        if (licenseLevel < SSYLicenseLevelValid) {
            title = NSLocalizedString(@"To enable saving and exporting,", nil) ;
            hyperText = @"get a free demo license.";
        }
        else if (licenseLevel == SSYLicenseLevelNotNeeded) {
            title = [NSString stringWithFormat:
                     NSLocalizedString(@"Fully functioning free demo until %@.", nil),
                     LongExpirationDateString(),
                     nil] ;
        } else {
            title = NSLocalizedString(@"Fully functioning demo.", nil) ;
            hyperText = NSLocalizedString(@"Click here to get a regular license.", nil) ;
        }
    }

    /* Delay is needed here because what we set in the progress view may
     clobbered by other settings. */
    dispatch_after(
                   dispatch_time(DISPATCH_TIME_NOW, delaySeconds * NSEC_PER_SEC),
                   dispatch_get_main_queue(), ^{
                       if (needsIt) {
                           [[self progressView] setText:title
                                              hyperText:hyperText
                                                 target:[NSApp delegate]
                                                 action:@selector(licenseBuy:)];
                       } else {
                           [[self progressView] clearAll];
                       }
                   });
}

/* Width and length of each (square) toolbar item: */
#define TOOLBAR_ITEM_WENGTH (32.0 * 0.8)

- (NSToolbarItem*)toolbar:(NSToolbar *)toolbar
    itemForItemIdentifier:(NSToolbarItemIdentifier)identifier
willBeInsertedIntoToolbar:(BOOL)flag {
    NSToolbarItem* answer =  nil;
    /* Oddly, the documentation says:

     A toolbar may ask again for a kind of toolbar item already supplied to
     it, in which case this method may return the same toolbar item it
     returned before.

     Weird.  Anyhow, that is why, below we test for items using "!". */

    if ([identifier isEqualToString:constIdentifierTabViewSettings]) {
        if (!toolbarItemSettings) {
            toolbarItemSettings = [[NSToolbarItem alloc] initWithItemIdentifier:identifier];
            toolbarItemSettings.tag = 21;
            toolbarItemSettings.target = topTabView;
            toolbarItemSettings.action = @selector(changeTabViewItem:);

            answer = toolbarItemSettings;
        }
    } else if ([identifier isEqualToString:@"Sync"]) {
        if (!toolbarItemSync) {
            toolbarItemSync = [[SSYToolbarButton alloc] initWithItemIdentifier:identifier];
            toolbarItemSync.tag = -1;
            [toolbarItemSync setTarget:self];
            [toolbarItemSync setAction:@selector(toggleSync:)];
            /* Because some of the image parts to be used in toolbarItemSync
             should be inverted luminance for Light vs. Dark mode and therefore
             want to be template images, while the colors of others should be
             constant and thus *not* template images, we cannot composite the
             parts into a single image, because a single image must be either
             all template or all not template.  Instead, we make
             toolbarItemSync a *view-based* item.  To do that, we now create
             and and assign to it a NSView. */
            SSYToolbarButtonView* syncingButtonView = [SSYToolbarButtonView new];
            syncingButtonView.toolbarItem = toolbarItemSync;
            
            /* The following two lines set the "size" of the Syncing button in
             the toolbar.  The first line, setting the ssyIntrinsicContentSize,
             is necessary and effective in macOS 11 Big Sur but is not needed
             in macOS 10.11 El Capitan.  The second line, setting the size,
             is necessary and effective in macOS 10.11 El Capitan but is not
             needed in macOS 11 Big Sur.  Probably this has something to do
             with the new toolbar regime in Big Sur, but I have not tested the
             effectiveness of these lines in intervening systems, 10.12-10.15,
             so I am not sure. */
            syncingButtonView.ssyIntrinsicContentSize = NSMakeSize(TOOLBAR_ITEM_WENGTH, TOOLBAR_ITEM_WENGTH);
            syncingButtonView.size = NSMakeSize(TOOLBAR_ITEM_WENGTH, TOOLBAR_ITEM_WENGTH);

            toolbarItemSync.view = syncingButtonView;
            [syncingButtonView release];

            answer = toolbarItemSync;
        }
    }

    [answer autorelease];
    return answer;
}

- (void)awakeFromNib {
    if (self.isAwake) {
        // This method has already run once upon this instance.
        return;
    }
    self.isAwake = YES;
    [[self window] makeKeyAndOrderFront:self];

    // Safely invoke super
	[self safelySendSuperSelector:_cmd
                   prettyFunction:__PRETTY_FUNCTION__
						arguments:nil] ;
    
    /* The 'settings' and 'Sync' toolbar items are not in the nib, because
     not all apps should have them, so we insert them programatically if needed
     later in this method.  However, in macOS 15 Beta 6 and 7, it seems that
     macOS may cache the nib with these items in there the first time that a
     document is opened, so that they are present at this point when subsequent
     documents are opened (FB14892799).  To keep those from causing trouble,
     we now search for those two items and remove if they are found.
     Note: We have also now removed the setting of the toolbar's identifier
     from BkmxDoc.xib.  For explanation see FBFB14892799 comment on 2024-09-26. */
    NSArray* items = [toolbar items];
    NSInteger i = [items count] - 1;
    BOOL alreadyHasSettingsItem = NO;
    BOOL alreadyHasSyncItem = NO;
    for (NSToolbarItem* item in [items reverseObjectEnumerator]) {
        if ([[item itemIdentifier] isEqualToString:constIdentifierTabViewSettings]) {
            toolbarItemSettings = item;
            alreadyHasSettingsItem = YES;
            [[BkmxBasis sharedBasis] logString:@"Surprise: Already has 'Settings' toolbar item (Working around Apple Bug FB14892799)"];
        }
        if ([[item itemIdentifier] isEqualToString:@"Sync"]) {
            toolbarItemSync = (SSYToolbarButton*)item;
            alreadyHasSyncItem = YES;
            [[BkmxBasis sharedBasis] logString:@"Surprise: Already has 'Sync' toolbar item (Working around Apple Bug FB14892799)"];
        }
        i--;
    }
    

    if ([[BkmxBasis sharedBasis] iAm] != BkmxWhich1AppBookMacster) {
        /* To remove the popover on the title bar which because it has controls
         to rename, move, tag, or lock the document.  These will cause trouble
         with a shoebox!  (The symbol name NSWindowDocumentVersionsButton
         is apparently a holdover from the prior usage.) */
        [[[self window] standardWindowButton:NSWindowDocumentVersionsButton] setHidden:YES];
    }
    else if (!alreadyHasSettingsItem) {
        [toolbar insertItemWithItemIdentifier:constIdentifierTabViewSettings
                                      atIndex:2];  // After "Reports"
        /* The above statement caused a call to the delegate method
         -toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:,
         which created the new item and assigned it to the ivar
         toolbarItemSettings. */
    }
    
    if (@available(macOS 10.16, *)) {
        /* I may get this by default, with NSWindowToolbarStyleAutomatic,
         but in case I dont… */
        self.window.toolbarStyle = NSWindowToolbarStyleUnified;
    }
    
    /* The following will be scaled and does not matter.*/
    CGFloat wength = 100.0;
    
    /* I decided on the following number after studying Xcode.app and Mail.app
     Preferences windows in macOS 10.11. */
    CGFloat const insetPercent = 0;
    CGFloat inset = wength * insetPercent / 100.0;
    
    if (@available(macOS 10.16, *)) {
        /* The following code will cause these three toolbar items to appear
         to the left of the window title. */
        toolbarItemContent.navigational = YES;
        toolbarItemReports.navigational = YES;
        toolbarItemSettings.navigational = YES;
    }
    
    if ([[BkmxBasis sharedBasis] isAMainAppWhichCanSync]) {
        if (!alreadyHasSyncItem) {
            NSInteger reportsToolbarItemIndex = [[toolbar items] indexOfObject:toolbarItemReports];
            NSInteger syncingToolbarItemIndex = reportsToolbarItemIndex + 2;
            [toolbar insertItemWithItemIdentifier:@"Sync"
                                          atIndex:syncingToolbarItemIndex];
            /* The above statement caused a call to the delegate method
             -toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:,
             which created the new item and assigned it to the ivar
             toolbarItemSync. */
        }

        NSString* syncOffToolTip = [[[BkmxBasis sharedBasis] tooltipSyncStatusOff] stringByAppendingString:@"\n\nClick this button to make ready for syncing."];
        NSString* syncOnToolTip = [[[BkmxBasis sharedBasis] tooltipSyncStatusOn] stringByAppendingString:@"\n\nClick this button to temporarily pause syncing."];
        NSString* syncDisToolTip = [[[BkmxBasis sharedBasis] tooltipSyncStatusDis] stringByAppendingString:@"\n\nClick this button to show the relevant Settings."];
        [toolbarItemSync setOffToolTip:syncOffToolTip] ;
        [toolbarItemSync setOnToolTip:syncOnToolTip] ;
        [toolbarItemSync setDisToolTip:syncDisToolTip] ;
        /* Create and assign images to toolbarItemSync */
        NSImage* chasingArrows = [SSYVectorImages imageStyle:SSYVectorImageStyleChasingArrows
                                                      wength:TOOLBAR_ITEM_WENGTH
                                                       color:nil
                                                darkModeView:self.window.contentView
                                               rotateDegrees:0.0
                                                       inset:0.0];
        toolbarItemSync.backgroundImage = chasingArrows;
        NSImage* minus = [SSYVectorImages imageStyle:SSYVectorImageStyleMinus
                                              wength:TOOLBAR_ITEM_WENGTH  // See Note NoMatter
                                               color:nil
                                        darkModeView:self.window.contentView
                                       rotateDegrees:0.0
                                               inset:8.0];
        toolbarItemSync.disImage = minus;
        NSImage* redExclam = [SSYVectorImages imageStyle:SSYVectorImageStyleExclamation
                                                  wength:TOOLBAR_ITEM_WENGTH  // See Note NoMatter
                                                   color:[NSColor redColor]
                                            darkModeView:nil // Ignored since we passed in a constant `color`
                                           rotateDegrees:0.0
                                                   inset:2.0] ;
        toolbarItemSync.offImage = redExclam;
        /* For the onImage, we overlay a yellow dot over a slightly larger gray
         circle.  The gray halo, I think, makes it stand out and look more
         yellow against the white (in light mode) or black (in dark mode)
         toolbar background. */
        NSImage* whiteCircle = [SSYVectorImages imageStyle:SSYVectorImageStyleDot
                                                    wength:TOOLBAR_ITEM_WENGTH  // See Note NoMatter
                                                     color:[NSColor grayColor]
                                              darkModeView:self.window.contentView
                                             rotateDegrees:0.0
                                                     inset:7.0];
        NSColor* yellowColor = [NSColor colorWithRed:1.0 green:0.9 blue:0 alpha:1];
        NSImage* yellowDot = [SSYVectorImages imageStyle:SSYVectorImageStyleDot
                                                  wength:TOOLBAR_ITEM_WENGTH  // See Note NoMatter
                                                   color:yellowColor
                                            darkModeView:self.window.contentView
                                           rotateDegrees:0.0
                                                   inset:8.0];
        /* Note NoMatter
         The wength value of this overlay image matters only in so far as it
         normalizes the inset value.  The absolute size / wength  will be
         scaled by -imageWithOverlay:onImage. */
        NSImage* onImage = [self imageWithOverlay:yellowDot
                                          onImage:whiteCircle];
        toolbarItemSync.onImage = onImage;

        [toolbarItemSync setOffLabel:@"Syncing"] ;
        [toolbarItemSync setOnLabel:@"Syncing"] ;
        [toolbarItemSync setDisLabel:@"Syncing"] ;
    }
	
	Macster* macster = [[self document] macster] ;
	[macster setClientsDummyForKVO:![macster clientsDummyForKVO]] ;
	
	[toolbarItemHelp setLabel:[[BkmxBasis sharedBasis] labelHelp]] ;
	[toolbarItemContent setLabel:[[BkmxBasis sharedBasis] labelContent]] ;
	[toolbarItemSettings setLabel:[[BkmxBasis sharedBasis] labelSettings]] ;
	[toolbarItemReports setLabel:[[BkmxBasis sharedBasis] labelReports]] ;
     
    /* Insert flexible space after the last navigation item. */
    NSToolbarItem* lastNavigationItem = toolbarItemSettings;
    if (!lastNavigationItem) {
        lastNavigationItem = toolbarItemReports;
    }
    NSInteger flexibleSpaceItemIndex = [[toolbar items] indexOfObject:lastNavigationItem] + 1;
    [toolbar insertItemWithItemIdentifier:NSToolbarFlexibleSpaceItemIdentifier
                                  atIndex:flexibleSpaceItemIndex];

	[toolbarItemInspector setLabel:[[BkmxBasis sharedBasis] labelInspector]] ;
    
    [toolbarItemHelp setImage:[SSYVectorImages imageStyle:SSYVectorImageStyleHelp
                                                   wength:wength
                                                    color:nil
                                             darkModeView:nil // For this template image, Cocoa will handle luminance inversion when in Dark Mode
                                            rotateDegrees:0.0
                                                    inset:inset]] ;
    [toolbarItemContent setImage:[SSYVectorImages imageStyle:SSYVectorImageStyleBookmarksNoBox
                                                      wength:wength
                                                       color:nil
                                                darkModeView:nil // For this template image, Cocoa will handle luminance inversion when in Dark Mode
                                               rotateDegrees:0.0
                                                       inset:inset]];
    [toolbarItemSettings setImage:[SSYVectorImages imageStyle:SSYVectorImageStyleSettings
                                                       wength:wength
                                                        color:nil
                                                 darkModeView:nil // For this template image, Cocoa will handle luminance inversion when in Dark Mode
                                                rotateDegrees:0
                                                        inset:inset]] ;
    [toolbarItemReports setImage:[SSYVectorImages imageStyle:SSYVectorImageStyleReports
                                                      wength:wength
                                                       color:nil
                                                darkModeView:nil // For this template image, Cocoa will handle luminance inversion when in Dark Mode
                                               rotateDegrees:0.0
                                                       inset:inset]] ;
    
	[toolbarItemInspector setOffImage:[SSYVectorImages imageStyle:SSYVectorImageStyleInfoOff
                                                           wength:wength
                                                            color:nil
                                                     darkModeView:nil // For this template image, Cocoa will handle luminance inversion when in Dark Mode
                                                    rotateDegrees:0.0
                                                            inset:inset]] ;
    [toolbarItemInspector setOnImage:[SSYVectorImages imageStyle:SSYVectorImageStyleInfoOn
                                                          wength:wength
                                                           color:nil
                                                    darkModeView:nil // For this template image, Cocoa will handle luminance inversion when in Dark Mode
                                                   rotateDegrees:0.0
                                                           inset:inset]] ;
    [toolbarItemHelp setFlashDuration:0.7] ;
    
    // In BkmxMgrs 1.22.23, I gave up on trying to use Cocoa Bindings for this.
    [self setInspectorButtonState:[(BkmxAppDel*)[NSApp delegate] inspectorShowing]] ;

	 /* For some inexplicable reason, wiring
	 up the target/action of toobarItemInspector in Interface Builder
	 to FirstResponder's -setNowShowingFromSender: causes, during nib
	 loading, the toolbarItemInspector to receive a setAction: with
	 -setNowShowingFromSender: as expected.  But setTarget: 
	 receives a nil target.  This patches that: */
	[toolbarItemInspector setTarget:(BkmxAppDel*)[NSApp delegate]] ;
	

	/* Must do this before binding, in case it is set to yellow immediately. */
    if (![[NSUserDefaults standardUserDefaults] boolForKey:constKeyYellowSyncExplained]) {
        [toolbarItemSync addObserver:self
                          forKeyPath:@"value"
                             options:NSKeyValueObservingOptionNew
                             context:NULL];
        self.isObservingForYellowSyncExplain = YES;
    }

    // Bind so that data will flow from us to toolbarItem
    [toolbarItemSync bind:@"value"
                 toObject:self
              withKeyPath:@"agentsPausitivity"
                  options:0] ;
	// Propagate initial value
	[toolbarItemSync setValue:[self agentsPausitivity]] ;
	[toolbarItemSync setTarget:self] ;
    
	// Set the tool tips which are static, never change:
	[toolbarItemContent setToolTip:[NSString localizeFormat:
									@"displayWhatX3",
									[[BkmxBasis sharedBasis] labelContent],
									[[NSDocumentController sharedDocumentController] defaultDocumentDisplayName],
									[[NSArray arrayWithObjects:
									 [[BkmxBasis sharedBasis] labelBookmarks],
									 [[BkmxBasis sharedBasis] labelFolders],
									 [[BkmxBasis sharedBasis] labelSeparators],
									 nil] listValuesForKey:nil
											    conjunction:@"&"
												 truncateTo:0]]] ;
	[toolbarItemSettings setToolTip:[NSString localizeFormat:
									 @"displayWhatX3",
									 [[BkmxBasis sharedBasis] labelSettings],
									 [[NSDocumentController sharedDocumentController] defaultDocumentDisplayName],
									 [[NSArray arrayWithObjects:
									  [[BkmxBasis sharedBasis] labelOpenSave],
									  [[BkmxBasis sharedBasis] labelSorting],
									  [[BkmxBasis sharedBasis] labelClients],
									  [[BkmxBasis sharedBasis] labelStructure],
									  [[BkmxBasis sharedBasis] labelSyncing],
									   nil] listValuesForKey:nil
												   conjunction:@"&"
													truncateTo:0]]] ;
	[toolbarItemReports  setToolTip:[NSString localizeFormat:
									 @"displayWhatX3",
									 [[BkmxBasis sharedBasis] labelReports],
									 [[NSDocumentController sharedDocumentController] defaultDocumentDisplayName],
									 [[NSArray arrayWithObjects:
									  [[BkmxBasis sharedBasis] labelDuplicates],
									  [[BkmxBasis sharedBasis] labelVerify],
									  [[BkmxBasis sharedBasis] labelFindReplace],
									  nil] listValuesForKey:nil
												 conjunction:@"&"
												  truncateTo:0]]] ;	
	
	// Make this the primary document window, so that when this window is closed the
	// associated document will close
	[self setShouldCloseDocument:YES] ;

	// This is so I will get NSWindow delegate messages needed by categories
	// such as -windowDidLoad, -windowDidClose:, -windowDidBecomeKey:,
	// -windowWillClose, -windowShouldClose:, -windowWillReturnUndoManager:
	// -window:willResizeForVersionBrowserWithMaxPreferredSize:maxAllowedSize:
	[[self window] setDelegate:self] ;
		
    [searchField populateFromUserDefaultsForDelegate:self
                                    includeSearchFor:YES] ;
	[searchField bind:@"value"
			 toObject:self
		  withKeyPath:@"searchText"
			  options:0] ;

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(tabViewChangedNote:)
												 name:SSYTabViewDidChangeItemNotification
											   object:topTabView] ;
	
	// Why not use the delegate method windowWillEnterVersionBrowser
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(enterVersionBrowserNote:)
												 name:@"NSWindowWillEnterVersionBrowserNotification"
											   object:[self window]] ;

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(exitVersionBrowserNote:)
												 name:@"NSWindowDidExitVersionBrowserNotification"
											   object:[self window]] ;

	// Added in BookMacster 1.9.1 to fix bug, Note 203948
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(endEditing:)
												 name:NSUndoManagerWillUndoChangeNotification
											   object:[[self document] undoManager]] ;

	// Added in BookMacster 1.9.1 to fix bug, Note 203948
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(endEditing:)
												 name:NSUndoManagerWillRedoChangeNotification
											   object:[[self document] undoManager]] ;

    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(tabWillPayloadNote:)
												 name:BkmxLazyViewWillLoadPayloadNotification
											   object:[self window]] ;
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(tabDidPayloadNote:)
												 name:BkmxLazyViewDidLoadPayloadNotification
											   object:[self window]] ;

	[[NSUserDefaults standardUserDefaults] addObserver:self
											forKeyPath:constKeyTableFontSize
											  selector:@selector(mikeAshObserveValueForKeyPath:ofObject:change:userInfo:)
											  userInfo:nil
											   options:0] ;

    // Now restore autosaves.  To avoid conflicts, note that we start
    // at the outermost feature (the window frame), and end with the
    // innermost feature (the column settings).
	[self restoreAutosavedWindowFrame] ;

    // Restore autosaved top tab setting (Content, Settings, or Reports)
    NSDictionary* autosaves = [self tabAutosaves] ;
    NSString* topSetting = [autosaves objectForKey:constAutosaveTabTop] ;
    if (!topSetting) {
        topSetting = constIdentifierTabViewContent ; // default value
    }
    [topTabView selectTabViewItemWithIdentifier:topSetting] ;

    // Now that we've got the autosaves (window size, tab selection, split view
	// sizes, user-defined columns, and columns widths) we can safely populate
	// the views with data and not have to worry about, for example, 
	// sending -sizeToFit messages to subviews that will later be resized.
    [self updateWindowForStark:nil] ;

    // After everyone is done restoring the autosaved
	// parameters, we arm our observers to watch for future changes
	// by the user, which are the only changes that we want.  (If beginAutosave
	// were not used, we'd autosave when things are initially set to
	// their default values, for example, wiping out the autosaved values
	// before they are applied.)
	[self performSelector:@selector(beginAutosave)
			   withObject:nil
			   afterDelay:BKMX_DOC_WINDOW_OPENING_DELAY__ARM_AUTOSAVE] ;
    	
	// Note: The topTabView and the other child tab views have their delegate
	// set to this object, in the xib.

    [self adjustLicenseStatusIndication:nil] ;

    [self queueAfterOpenCommands];

    [self queueWarningIfSyncSuspended];
    m_isAwake = YES;
}

- (void)queueAfterOpenCommands {
    BkmxDoc* bkmxDoc = (BkmxDoc*)[self document];
    Macster* macster = [bkmxDoc macster] ;
    if ([SSYEventInfo alternateKeyDown]) {
        // Alert user of operations which will *not* be done
        NSMutableArray* operationNames = [NSMutableArray array] ;
        if ([[macster autoImport] boolValue]) {
            [operationNames addObject:[[BkmxBasis sharedBasis] labelAutoImport]] ;
        }
        if ([[macster doSortAfterOpen] boolValue]) {
            [operationNames addObject:[[BkmxBasis sharedBasis] labelSort]] ;
        }
        if ([[macster doFindDupesAfterOpen] boolValue]) {
            [operationNames addObject:[[BkmxBasis sharedBasis] labelFindDupes]] ;
        }

        if ([operationNames count] > 0) {
            NSString* msg = [NSString localizeFormat:
                             @"openSkipActionsX",
                             [[NSDocumentController sharedDocumentController] defaultDocumentDisplayName]] ;
            NSString* list = [operationNames listValuesOnePerLineForKeyPath:nil] ;
            msg = [NSString stringWithFormat:
                   @"%@\n\n%@",
                   msg,
                   list] ;
            SSYAlert* alert = [SSYAlert alert] ;
            [alert setSmallText:msg] ;
            [bkmxDoc runModalSheetAlert:alert
                             resizeable:NO
                              iconStyle:SSYAlertIconInformational
                          modalDelegate:nil
                         didEndSelector:nil
                            contextInfo:NULL] ;
        }
    }
    else {
        if (![bkmxDoc skipAutomaticActions] && ![bkmxDoc ssy_isInViewingMode]) {
            if ([[macster autoImport] boolValue]) {
                NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             // Since we've definitely got the GUI here, deference is ask
                                             [NSNumber numberWithInteger:BkmxDeferenceAsk], constKeyDeference,
                                             [NSNumber numberWithInteger:BkmxPerformanceTypeUser], constKeyPerformanceType,
                                             [NSNumber numberWithBool:YES], constKeyIfNotNeeded,
                                             bkmxDoc, constKeyDocument,
                                             nil] ;

                [bkmxDoc importLaInfo:info
                  grandDoneInvocation:nil] ;
            }
            if ([[macster doSortAfterOpen] boolValue]) {
                [bkmxDoc sort] ;
            }
            if ([[macster doFindDupesAfterOpen] boolValue]) {
                [bkmxDoc findDupes] ;
            }
        }
    }

    // skipAutomaticActions should be a one-shot.  Reset it.
    [bkmxDoc setSkipAutomaticActions:NO] ;
}

- (void)queueWarningIfSyncSuspended {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:constKeyDontWarnSyncingSuspended] == NO) {
        BkmxDoc* bkmxDoc = (BkmxDoc*)[self document];
        if (![bkmxDoc ssy_isInViewingMode]) {
            if ([self agentsPausitivity] == NSControlStateValueOn) {
                NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             bkmxDoc, constKeyDocument,
                                             nil] ;

                NSArray* selectorNames = [NSArray arrayWithObjects:
                                          @"warnSyncSuspended",
                                          nil] ;

                [[bkmxDoc operationQueue] queueGroup:NSStringFromSelector(_cmd)
                                               addon:NO
                                       selectorNames:selectorNames
                                                info:info
                                               block:NO
                                          doneThread:nil
                                          doneTarget:nil
                                        doneSelector:NULL
                                        keepWithNext:NO] ;
            }
        }
    }
}

/* Note 203948.  The bug was:
 • User inserts a new object.
 • Object is inserted with -[NSEntityDescription insertNewObjectForEntityForName::].
 • New row appears in the table.
 • New row's "Name" column field editor becomes first responder, showing "untitled". 
 • But instead of entering a name, user hits ⌘Z to Undo.
 • Core Data deletes new object with -[NSManagedObjectContext deleteObject:].
 • Row disappears.
 • User hits ⌘W to close the document.
 
 Result:
 Cocoa Error 134130 with underlying exception: "Cannot update object that was never inserted".  In error's info, affected object is that new object.
*/ 

- (void)setTaskQueue:(NSMutableArray*)taskQueue_ {
	[taskQueue_ retain] ;
	[taskQueue release] ;
	taskQueue = taskQueue_ ;
}

- (id)init {
	self = [super initWithWindowNibName:@"BkmxDoc"] ;

	if (self != nil) {		
		// Note: The delegate is set in IB; I don't do it here
		NSMutableArray* newTaskQueue = [[NSMutableArray alloc] init] ;
		[self setTaskQueue:newTaskQueue] ;
		[newTaskQueue release] ;
	}

	return self ;
}

- (void)dealloc {
    [m_cntntViewController release] ;
    [m_settingsViewController release] ;
    [m_reportsViewController release] ;
    
    [taskQueue release] ;
	[queueChecker release] ;
	[m_searchText release] ;

	[super dealloc] ;
}

#if 0
- (void)debugLogObjectsEntityName:(NSString*)entityName {
	NSManagedObjectContext* managedObjectContext = [[self document] managedObjectContext] ;
	[managedObjectContext processPendingChanges] ;
	SSYMojo* mojo = [[SSYMojo alloc] initWithManagedObjectContext:managedObjectContext
													   entityName:entityName] ;
	NSError* error = nil ;
	NSArray* objects = [mojo allObjectsError_p:error_p] ;
	[SSYAlert alertError:error] ;
	NSLog(@"14382: This doc now contains %ld objects of entity %@:\n%@",
		  (long)[objects count],
		  entityName,
		  [objects shortDescription]) ;
	[mojo release] ;
}
#endif

#if 0
- (void)debugLogObjectsEntityName:(NSString*)entityName {
    NSManagedObjectContext* moc = [[self document] managedObjectContext] ;
    [moc processPendingChanges] ;  // Has no effect.
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init] ;
    NSArray* fetches = nil ;
    if (moc) {
        [fetchRequest setEntity:[NSEntityDescription SSY_entityForName:entityName
                                                inManagedObjectContext:moc]] ;
        fetches = [moc executeFetchRequest:fetchRequest
                                     error:NULL] ;
    }
    [fetchRequest release] ;
    
    NSLog(@"This doc contains %ld objects of entity %@:\n%@",
          (long)[fetches count],
          entityName,
          [fetches shortDescription]) ;
    // -shortDescription is a method I've written to give pertinent info
    // about managed objects and collections of managed objects, without
    // filling the console/screen like -[NSManagedObject description] does.
}
#endif

- (IBAction)quickSearch:(id)sender {
    [self revealTabViewIdentifier:constIdentifierTabViewContent] ;
	[[self window] makeFirstResponder:searchField] ;
}

- (IBAction)help:(id)sender {
	NSString* identifier = [self activeTabViewItemIdentifier] ;
	
	NSString* anchor ;
	
	if ([identifier isEqualToString:constIdentifierTabViewContent]) {
		anchor = constHelpAnchorTabContent ;
	}

	// Bottom leaves in 'Settings' tab.
	// Note that constIdentifierTabViewSettings itself should not occur
	// because -activeTabViewItemIdentifier returns only bottom leaves
	else if ([identifier isEqualToString:constIdentifierTabViewOpenSave]) {
		anchor = constHelpAnchorTabOpenSave ;
	}
	else if ([identifier isEqualToString:constIdentifierTabViewClients]) {
		anchor = constHelpAnchorTabClients ;
	}
	else if ([identifier isEqualToString:constIdentifierTabViewSorting]) {
		anchor = constHelpAnchorTabSorting ;
	}
	else if ([identifier isEqualToString:constIdentifierTabViewStructure]) {
		anchor = constHelpAnchorTabStructure ;
	}
	
	// Bottom leaves in 'Syncers' tab.
	// Note that constIdentifierTabViewSyncing itself should not occur
	// because -activeTabViewItemIdentifier returns only bottom leaves
	else if ([identifier isEqualToString:constIdentifierTabViewSimple]) {
		anchor = constHelpAnchorTabSimple ;
	}
	else if ([identifier isEqualToString:constIdentifierTabViewAdvanced]) {
		anchor = constHelpAnchorTabAdvanced ;
	}
	
	
	// Bottom leaves in 'Reports' tab.
	// Note that constIdentifierTabViewReports itself should not occur
	// because -activeTabViewItemIdentifier returns only bottom leaves
	else if ([identifier isEqualToString:constIdentifierTabViewFindReplace]) {
		anchor = constHelpAnchorTabFind ;
	}
	else if ([identifier isEqualToString:constIdentifierTabViewDupes]) {
		anchor = constHelpAnchorTabDupes ;
	}
	else if ([identifier isEqualToString:constIdentifierTabViewVerify]) {
		anchor = constHelpAnchorTabVerify ;
	}
	else if ([identifier isEqualToString:constIdentifierTabViewDiaries]) {
		anchor = constHelpAnchorTabDiaries ;
	}
    
    else {
        // For tabs that don't have specific help anchors
        anchor = constHelpAnchorCollectionWindow ;
	}
    
	[(BkmxAppDel*)[NSApp delegate] openHelpAnchor:anchor] ;
}

- (void)populateQuickIxportMenu:(NSMenu*)menu
					   selector:(SEL)selector {
	[menu removeAllItems] ;
	
	BkmxDoc* bkmxDoc = (BkmxDoc*)[self document] ;
	Macster* macster = [bkmxDoc macster] ;
	
	NSMenuItem* menuItem ;
	NSString* title ;
	NSInteger j = 0 ;
	NSMutableSet* addedClientoids = [[NSMutableSet alloc] init] ;
	
	BOOL includeWebApps = ([menu supertag] != 587) ;
	for (ClientChoice* choice in [macster availableClientChoicesAlwaysIncludeChooseFile:YES
                                                                         includeWebApps:includeWebApps
                                                                    includeNonClientable:YES]) {
		BOOL inUse = [choice isInUse] ;
		if (inUse) {
			title = [choice displayName] ;
            if ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppSmarky) {
                // Do not list 'Safari' in "Ixport to/from (others)
                continue ;
            }
		}
		else {
			title = [choice displayName] ;
			// If a Loose or Other Mac client is under construction it will not have
			// a title yet, but will appear in
            // -[macster availableClientChoicesAlwaysIncludeChooseFile:::]
            // since
			// that method includes -[Macster clientsOrdered].  And since Cocoa may
			// invoke -menuNeedsUpdate, which may invoke this method at any time,
			// title may be nil at this point, which will cause insertItemWithTitle:::
			// below to throw an exception.  We don't want under-construction items
			// in this menu anyhow, so…
			if (!title) {
				continue ;
			}			
		}
		menuItem = [menu insertItemWithTitle:title
									  action:selector
							   keyEquivalent:@""
									 atIndex:j] ;
		[menuItem setTarget:bkmxDoc] ;
		[menuItem setRepresentedObject:choice] ;
		
		Clientoid* clientoid = [choice clientoid] ;
		if (clientoid) {
			[addedClientoids addObject:clientoid] ;
		}
		j++ ;
		
#if 0
// Removed in BookMacster 1.11
		if (inUse  && (selector != @selector(exportBookMacsterizer:))) {
			BOOL didFind = NO ;
			Client* client ;
			for (client in [macster clients]) {
				if ([[client clientoid] isEqual:[choice clientoid]]) {
					didFind = YES ;
					break ;
				}
			}
			
			if (didFind) {
				title = [NSString stringWithFormat:
						 @"%@ (%@)",
						 [choice displayName],
						 [[BkmxBasis sharedBasis] labelClientSettings]] ;
				
				menuItem = [menu insertItemWithTitle:title
											  action:selector
									   keyEquivalent:@""
											 atIndex:j] ;
				[menuItem setTarget:bkmxDoc] ;
				[menuItem setRepresentedObject:client] ;
				[addedClients addObject:client] ;
				j++ ;
			}
			else {
				NSLog(@"Internal Error 512-4193 %@", choice) ;
			}
		}
#endif
	}
	
	// Add any clients that were missed, for example, clients of loose files
    if ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppBookMacster) {
        if (selector != @selector(exportBookMacsterizer:)) {
            for (Client* client in [macster clients]) {
                Class extoreClass = [client extoreClass] ;
                const ExtoreConstants* constants_p = [extoreClass constants_p] ;
                // Defensive programming, in case constants_p is NULL, which it looks
                // like it probably was for Rob Schnide when he ran BookMacster 1.7.0
                // in macOS 10.6.8, although it didn't do it for me in 10.6.8.
                if (constants_p) {
                    if ((includeWebApps || constants_p->ownerAppIsLocalApp)) {
                        if (![addedClientoids member:[client clientoid]]) {
                            title = [client displayName] ;
                            if (title) {
                                menuItem = [menu insertItemWithTitle:title
                                                              action:selector
                                                       keyEquivalent:@""
                                                             atIndex:j] ;
                                [menuItem setTarget:bkmxDoc] ;
                                [menuItem setRepresentedObject:client] ;
                                j++ ;
                            }
                        }
                    }
                }
            }
        }
    }
    
    [addedClientoids release] ;
}

- (NSArray*)selectedDupeStarks  {
    return [[self reportsViewController] selectedDupeStarks] ;
}

// Note: For this to work, I must be the delegate for the relevant menus
// These delegations are set in -[BkmxAppDel menuNeedsUpdate]
- (void)menuNeedsUpdate:(NSMenu*)menu {
	NSInteger supertag = [menu supertag] ;
	switch (supertag)  {
		case 580:
			// Import from only ►
			[self populateQuickIxportMenu:menu
								 selector:@selector(importOnly:)] ;
			break ;
		case 585:
			// Export to only ►
			[self populateQuickIxportMenu:menu
								 selector:@selector(exportOnly:)] ;			
			break ;
		case 587:
			// Export BookMacsterize Bookmarklet of File Menu of Main Menu
			[self populateQuickIxportMenu:menu
								 selector:@selector(exportBookMacsterizer:)] ;			
			break ;
		case 4362:;
			// Main Menu > Bookmarks > Safe Sync Limit ▸ Export
			[menu removeAllItems] ;
			NSInteger j = 0 ;
			for (Client* client in [[(BkmxDoc*)[self document] macster] clientsOrdered]) {
				NSString* title = [client displayName] ;
				// If a Loose or Other Mac client is under construction it will not have
				// a title yet.  And since Cocoa may invoke -menuNeedsUpdate at any time,
				// title may be nil at this point, which will cause insertItemWithTitle:::
				// below to throw an exception.  We don't want under-construction items
				// in this menu anyhow, so…
				if (!title) {
					continue ;
				}
				
				NSMenuItem* menuItem = [menu insertItemWithTitle:title
														  action:@selector(guideUserToSafeLimitMenuItem:)
												   keyEquivalent:@""
														 atIndex:j] ;
                [menuItem setTarget:(BkmxAppDel*)[NSApp delegate]] ;
				[menuItem setRepresentedObject:client] ;
				j++ ;
			}
			break ;
	}
}

- (IBAction)setOutlineModeFromMenu:(id)sender {
	// Toggle it.
	[self setOutlineMode:![self outlineMode]] ;
}

- (IBAction)showSyncLog:(id)sender {
	[self revealTabViewIdentifier:constIdentifierTabViewDiaries] ;
}

- (IBAction)setUpSync:(id)sender {
    switch ([[BkmxBasis sharedBasis] iAm]) {
        case BkmxWhich1AppSmarky:
        case BkmxWhich1AppSynkmark:
            [(BkmxAppDel*)[NSApp delegate] preferences:self] ;
            [(PrefsWinCon*)[(BkmxAppDel*)[NSApp delegate] prefsWinCon] revealTabViewIdentifier1:constIdentifierTabViewPrefsSyncing
                                                                                    identifier2:nil];
            break ;
        case BkmxWhich1AppMarkster:
            NSLog(@"Internal Error 213-0948") ;
            break ;
        case BkmxWhich1AppBookMacster:
            [self revealTabViewIdentifier:constIdentifierTabViewSyncing] ;
            break ;
    }
}

- (IBAction)toggleSync:(id)sender {
	[[[self document] macster] toggleSync] ;
}

- (NSInteger)agentsPausitivity {
	NSInteger pausitivity ;
	if ([[[self document] macster] aSyncerWouldIxportIfActivatedOrResumedDoQualifyExport:YES]) {
		if ([[[self document] macster] syncersPaused]) {
			pausitivity = NSControlStateValueOff ;
		}
		else {
			pausitivity = NSControlStateValueOn ;
		}
	}
	else {
		pausitivity = NSControlStateValueMixed ;
	}

	return pausitivity ;
}
+ (NSSet*)keyPathsForValuesAffectingAgentsPausitivity {
	return [NSSet setWithObjects:
			@"document.macster.syncersPaused",
			@"document.macster.agentsDummyForKVO",
			@"document.macster.clientsDummyForKVO",
			@"document.macster.syncerPausedConfig",  // Added in BookMacster 1.11 to fix bug that the Sync/Pause/Resume button did not change from "Resume" to "Sync" if syncer(s) were removed while syncer were paused
            @"document.macster.syncerConfig",  // Added in BookMacster 1.19.8 to fix bug that the Sync/Pause/Resume button did not change from "Resume" to "Sync" if syncer(s) were removed while syncer were not paused
            nil] ;
}

- (IBAction)safeSyncLimitImport:(id)sender {
    // See "Warning about other windows" in SafeLimitGuider.h
    [[self window] makeKeyAndOrderFront:self] ;
    [(BkmxAppDel*)[NSApp delegate] doShowInspector:NO] ;

    // Next line is to create the settings view controller in case it is still nil
    [self revealTabViewSettings:self] ;
	[[self settingsViewController] guideUserToSafeLimitMenuItem:sender] ;
}

- (void)clearQuickSearch {
	[searchField setStringValue:@""] ;
	[searchField sendAction:[searchField action]
						 to:[searchField target]] ;
    [[self cntntViewController] clearAllContentFilters] ;
}

- (void)invalidateFlatCache {
    [[self cntntViewController] invalidateFlatCache] ;
}

- (void)reloadContent {
    [[self cntntViewController] reload] ;
}

- (void)reloadStarks:(NSSet*)starks {
    [[self cntntViewController] reloadStarks:starks] ;
}

- (void)reloadAll {
    [self reloadContent] ;
	[[self reportsViewController] reload] ;
    [[self settingsViewController] reload] ;
}

// CLEAR-STAGING //- (void)clearReloadStagingOfContent {
// CLEAR-STAGING //    [[self cntntViewController] clearReloadStaging] ;
// CLEAR-STAGING //}

-(void)checkQueue {
	if([taskQueue count])
	{
		if (!_busy)
		{
			_busy = YES ;
			[[taskQueue objectAtIndex:0] invoke] ;
			[taskQueue removeObjectAtIndex:0] ;
		}
	}
	else
	{
		[queueChecker invalidate] ;
		queueChecker = nil ;
	}
}

- (void)queueInvocation:(NSInvocation*)invocation
		localizableVerb:(NSString*)verbToDisplay {
	[taskQueue addObject:invocation] ;

	[progressView setIndeterminate:YES
               withLocalizableVerb:verbToDisplay
                          priority:SSYProgressPriorityRegular] ;

	if (!queueChecker)
	{
		queueChecker = [NSTimer scheduledTimerWithTimeInterval:0.25
												    target:self
                                                  selector:@selector(checkQueue)
                                                  userInfo:nil
                                                   repeats:YES] ;
    	[queueChecker retain] ;
	}
	
	[self checkQueue] ;
}

- (void)setBusy:(BOOL)busy {
	_busy = busy ;
}

- (void)showVerifyProgressSidebar:(BOOL)doShow
                          animate:(BOOL)doAnimate {
    NSTabViewItem* tabViewItem = [[[self topTabView] selectedTabViewItem] selectedLeafmostTabViewItem];
    CGFloat mainViewMinimum = [self minimumSizeForTabViewItem:tabViewItem].width;
    if (mainViewMinimum == 0.0) {
        mainViewMinimum = [self fixedSizeForTabViewItem:tabViewItem].width;
    }
    [sidebarController expandSidebar:doShow
                     mainViewMinimum:mainViewMinimum
                             animate:doAnimate];
}

- (void)startVerifyProgressWithLocalizedVerb:(NSString*)verb
									  limit:(NSInteger)limit
									 broker:(Broker*)broker_ {
	[verifyProgressController startVerifyWithBroker:broker_] ;
    /* User Interface access ahead - must use main thread. */
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showVerifyProgressSidebar:YES
                                animate:YES];
    }) ;
    SSYProgressView* localProgressView = [self.progressView setIndeterminate:YES
                                                           withLocalizedVerb:verb
                                                                    priority:SSYProgressPriorityRegular] ;
    [localProgressView setMaxValue:limit] ;
}

-(void)shortenVerifyVerbTo:(NSString*)shorterVerb {
	[progressView setVerb:shorterVerb
					resize:NO] ;
}


-(void)updateThrottleView {
	[verifyProgressController updateThrottleView] ;
}

-(void)setVerifyNWaiting:(CGFloat)nWaiting {
	[verifyProgressController setLevelIndication:nWaiting] ;
}
	
-(void)appendToVerifyLog:(NSString*)newLine {
	[verifyProgressController appendToLog:newLine] ;
}

-(void)removeFromVerifyLog:(NSString*)name {
	[verifyProgressController removeFromLog:name] ;
}

-(void)verifyIsDone {
    [self showVerifyProgressSidebar:NO
                            animate:NO];
    /* Passing animate:YES would be prettier, but it causes view to hang
     around and I don't have time to debug it right now. */
}

- (void)showStark:(Stark*)stark
         selectIt:(BOOL)selectIt {
	[[self cntntViewController] showStark:stark
                                 selectIt:selectIt] ;
}

- (BOOL)validateUserInterfaceItem:(NSMenuItem*)item {
	// This method is invoked by items in pullDownAddNew and also in the menu
	// attached to the cell of the Quick Search Field (searchField)
	return YES ;
}

- (void)endEditing {
    /*  In Bookdog 4.0, after I fixed memory leaks so BkmxDoc will dealloc when
     MainWindow closed, I was getting repeatable crashes whenever a Main Window
     was closed while an item in the outline was being edited.  I suspected that
     the field editor had a weak reference to the Stark it was editing, and it
     tried to end editing or otherwise talk to this Stark after it had been
     deallocced. So, I added the following code which I copied out of the
     documentation of endEditingFor:.  It fixed the problem. */
	if ([[self window] makeFirstResponder:[self window]]) {
	}
	else {
		[[self window] endEditingFor:nil];
	}
}

- (void)endEditing:(NSNotification*)note {
	[self endEditing] ;
}

/* 
 Bug 2009071601. The if(frameString) clause in -windowDidLoad does give this
 window the desirable behavior of using the autosaved window frame if available,
 and cascading otherwise.  But then if I open another New Document window, it
 can cascade on top of a window that was opened using a frame string.  Apparently,
 Cocoa maintains under the hood a global "last cascade point", which does not get
 set when I -setFrameFromString.  In this method, I try to set that variable by
 first moving the window to the top of the screen, and then re-setting it to its
 original position by invoking -cascadeTopLeftFromPoint:.  But it still 
 "just doesn't work".
 
 - (void)registerCascade {
 NSLog(@"6460 %s", __PRETTY_FUNCTION__) ;
 
 // Get the current top left point of the window
 NSRect frame = [[self window] frame] ;
 NSPoint topLeftPoint = frame.origin ;
 topLeftPoint.y += frame.size.height ;
 
 // Move the window all the way up to the top left of the screen
 [[self window] cascadeTopLeftFromPoint:NSMakePoint(0,CGFLOAT_MAX)] ;
 [[self window] display] ;
 NSLog(@"7058: sleeping for 2") ;
 usleep(2000000) ;
 
 [self setShouldCascadeWindows:YES] ;
 
 // Now move the window back to its original location, using the
 // -cascade...  method
 [[self window] cascadeTopLeftFromPoint:topLeftPoint] ;
 [[self window] display] ;
 }
 */
- (void)restoreAutosavedWindowFrame {
	// Restore autosaved window frame
	NSString* frameString = [self autosavedWindowFrame] ;
	if (frameString) {
		// Without disabling cascading, setFrameFromString is ignored.
		[self setShouldCascadeWindows:NO] ;
		[[self window] setFrameFromString:frameString] ;
		// The following doesn't work.  See the -registerCascade above
		//[self performSelector:@selector(registerCascade)
		//		   withObject:nil
		//		   afterDelay:2.0] ;
	}	
}


// NSWindow delegate messages:
- (void)windowDidLoad {	
	// Observe future changes in window frame
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(autosaveWindowFrameNote:)
												 name:NSWindowDidResizeNotification
											   object:[self window]] ;
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(autosaveActiveTabViewSizeNote:)
												 name:NSWindowDidResizeNotification
											   object:[self window]] ;
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(autosaveWindowFrameNote:)
												 name:NSWindowDidMoveNotification
											   object:[self window]] ;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adjustLicenseStatusIndication:)
                                                 name:SSYLicensingStatusDidChangeNotification
                                               object:nil] ;
}

+ (void)notify_windowsDidRearrange_delayed {
	// Instead of simply doing this:
	//[[NSNotificationCenter defaultCenter] postNotificationName:constNoteSSYWindowsDidRearrange object:nil] ;		
	// We do this:
	NSNotification* notification = [NSNotification notificationWithName:constNoteBkmxWindowsDidRearrange object:nil] ;
	[[NSNotificationQueue defaultQueue] enqueueNotification:notification
											   postingStyle:NSPostWhenIdle] ;
    // The reason is that the window will hang around until after it is deallocced,
	// presumably by autorelease, which is long after the run loop closing it has completed.
	// So, if we post the notification immediately, when -[NSApplication updateInspectorSubject]  <<< DEPRACATED!!!!
	// sends -[NSApp keyWindow] and -[NSApp orderedWindows], it will have returned to it the
	// window(s) of this document which is being removed, so if the Inspectors current -subject
	// is owned by the document which is being removed, it will not be changed. 
	// We use object:nil instead of self because, when this is invoked by -windowWillClose,
	// the instance is going to be deallocced and will cause a crash.
}	

- (BOOL)isClosing {
    return m_didWillClose;
}


- (void)windowWillClose:(NSNotification *)aNotification {
    // Added in BookMacster 1.15 to support the "Click to Choose…" client
    NSMutableSet* clientsCopy = [[[[self document] macster] clients] copy] ;
    for (Client* client in clientsCopy ) {
        if ([[client clientoid] isPlaceholder]) {
            [client abandon] ;
        }
    }
    [clientsCopy release] ;
    
	// The following three kludges are necessary to avoid three crashes when
	// Restoring an Auto Save version.

	// Fix crash when toolbar tries to validate items as window is closing.
	[toolbar setDelegate:nil] ;  // Probably not necessary

    // This method is called multiple times while window is
    // closing, and when it is called by -revertDocumentToContentsOfURL:::,
    // an -unbind method below crashes, probably because it's trying to
    // unbind something that's already been unbound.
	if (m_didWillClose) {
		return ;
	}
	m_didWillClose = YES ;

	// The following is necessary to keep the binding of the NSObjectController
	// 'Stark Controller' in Inspector.nib, which is observing
	// Application.delegate.selectedStark, from bitching that its subject Stark
	// has been invalidated, or that an observed object has disappeared, when
	// a BkmxDoc window closes.
	Stark* selectedStark = [(BkmxAppDel*)[NSApp delegate] selectedStark] ;
	// But if no selection, selectedStark might be an _NSStateMarker, so test first...
	if ([selectedStark respondsToSelector:@selector(owner)]) {
		if ([selectedStark owner] == [self document]) {
			[(BkmxAppDel*)[NSApp delegate] setSelectedStark:nil] ;
		}
	}
		
    [SafeLimitGuider removeWindowController:self
                           documentProvider:[self settingsViewController]] ;
    
	[toolbarItemSync unbind:@"value"] ;
    [searchField unbind:@"value"] ;
    /* The above was added in BookMacster 1.12 when I saw this upon closing a window…
     05:18:38.385 BookMacster[1185:303] An instance 0x10460d4e0 of class BkmxDocWinCon was deallocated while key value observers were still registered with it. Observation info was leaked, and may even become mistakenly attached to some other object. Set a breakpoint on NSKVODeallocateBreak to stop here in the debugger. Here's the current observation info:
     <NSKeyValueObservationInfo 0x1050ae4d0> (
     <NSKeyValueObservance 0x1077622f0: Observer: 0x107757290, Key path: searchText, Options: <New: NO, Old: NO, Prior: NO> Context: 0x10048faf0, Property: 0x10776b100>
     */

    if (self.isObservingForYellowSyncExplain) {
        [toolbarItemSync removeObserver:self
                             forKeyPath:@"value"];
    }
	[[MAKVONotificationCenter defaultCenter] removeObserver:self] ;
	[[NSNotificationCenter defaultCenter] removeObserver:self] ;	
	[[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self] ;
    [self.yellowSyncExplainTimer invalidate];
    
    [BkmxDocWinCon notify_windowsDidRearrange_delayed] ;
    /* The above line was moved down to here in BkmkMgrs 2.12.6  in an
     attempt to fix Note CocoaBindingsIsBad.  At first I thought it helped,
     then not, but I left it in since it seems like a good idea to send a
     notification which could trigger observers after observers have been
     removed. */
    
	// Added in Bookdog 4.4.0 to fix crash in Leopard.
	[[[self document] retain] autorelease] ;
	// Without the above, you get crash when closing this window,
	// either by hitting red close button or cmd-W.
	// Crash occurs after this method exits:
	// in objc_msgSend
	// in -[NSWindowController _windowDidClose]
	// in -[NSWindow __close]
	// in -[NSWindow _close:]
	// in -[NSApplication sendAction:to:from:]
	// in -[NSControl sendAction:to:]
	// in -[NSCell _sendActionFrom:]
	// in -[NSCell trackMouse:inRect:ofView:untilMouseUp:]
	// in -[NSButtonCell trackMouse:inRect:ofView:untilMouseUp:]
	// in -[NSControl mouseDown:]
	// Reason why this occurs is probably in http://developer.apple.com/releasenotes/Cocoa/AppKit.html
	// in the section "New Behavior in NSWindowController at Window Closing Time"
    
    // Added in BookMacster 1.12…
    [[self document] tearDownOnce] ;
    
    [[self cntntViewController] tearDown] ;
    [[self settingsViewController] tearDown] ;
    [[self reportsViewController] tearDown] ;
    
    if ([[BkmxBasis sharedBasis] isShoeboxApp]) {
        // Should quit when single document window closes.
        
        /*
         However, we don't want to quit the app if we are closing because
         another version has been restored from the Lion Versions Browser.
         And we are in a bit of an odd situation in this case.
         [[NSDocumentController sharedDocumentController] documents] will
         return only our document, because the newly-restored document has
         apparently not been registered with the document controller yet.
         However, the newly-restored document does have a window, so we can
         get it like this…
         */
        BOOL otherDocumentWindowIsOpen = NO ;
        for (NSWindow* window in [NSApp windows]) {
            NSWindowController* wc = [window windowController] ;
            if ([wc isKindOfClass:[self class]]) {
                if (wc != self) {
                    otherDocumentWindowIsOpen = YES ;
                    break ;
                }
            }
        }

        if (
            !otherDocumentWindowIsOpen
            &&
            ![(BkmxAppDel*)[NSApp delegate] isUninstalling]
            &&
            ![[self document] isReverting]  // Added in BookMacster 1.22.16
            &&
            ![(BkmxAppDel*)[NSApp delegate] isResetting]  // Added in BookMacster 1.22.20
            &&
            // So Markster does not quit when user commands it to background:
            !((BkmxAppDel*)[NSApp delegate]).isBackgrounding
            ) {
            // Delay 0.0 added in BookMacster 1.19.2 to fix hang when quitting
            // focused apps
            [NSApp performSelector:@selector(terminate:)
                        withObject:self
                        afterDelay:0.0] ;
        }
    }
}

- (void)windowDidBecomeKey:(NSNotification *)aNotification {
	[BkmxDocWinCon notify_windowsDidRearrange_delayed] ;
}

/*!
 @details  Cocoa calls this method when the user closes the window, but *not*
 when the app is quit  */
- (BOOL)windowShouldClose:(id)sender {
	[self endEditing] ;

	BOOL documentWillHandleClosing = [[self document] prepareToClose] ;
	
	return !documentWillHandleClosing ;
}

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)aWindow {
	NSUndoManager* undoManager = (NSUndoManager*)[[self document] undoManager] ;
	return undoManager ;
}

- (NSSize)                                 window:(NSWindow*)window
  willResizeForVersionBrowserWithMaxPreferredSize:(NSSize)preferredSize
								   maxAllowedSize:(NSSize)allowedSize {
	/*
	 The problem here is that the window size cannot change while we're in the
	 version browser.  (I tried, but Cocoa immediately changes it back after
	 the animation completes.)  So we need to come up with a compromise size
	 which will be best for all tabs.  I considered writing several hundred
	 lines of code here, to examine which tabs had a fixed size, and then
	 finding the largest.  But since the thing is a compromise anyhow, I
	 decided to take the cheesy way out and just hard code it.
	 
	 The height ofSettings ▸ Sorting tab, which is about the largest of the
    fixed-size tabs, is 390 not including the dead height.
	 CGFloat height = 390.0 + [self deadHeightForTabViewItem:tabSorting] ;
	
	 But Advanced Syncers would like maybe 100 more
	 CGFloat height = 490  + [self deadHeightForTabViewItem:tabAdvanced] ;
	
	 But, what the hell, why not use all that they'll give us, up to maybe 800
     */
	CGFloat height = MIN(preferredSize.height, 800.0) ;

	NSSize size = NSMakeSize(590.0, height) ;
	
	return size ;
}
	
- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar {
	return [NSArray arrayWithObjects:
			constIdentifierTabViewContent,
			constIdentifierTabViewSettings,
			constIdentifierTabViewReports,
			nil] ;
}

- (void)enterVersionBrowserNote:(NSNotification*)note {
	// If the active tab view item is not allowed when browsing Versions,
	// switch immediately to the Content tab.
	NSTabViewItem* activeTabViewItem = [self activeTabViewItem] ;
	if (
		[[self reportsViewController] disallowInVersionsBrowserTabViewItem:activeTabViewItem]
        ||
        [[self reportsViewController] disallowInVersionsBrowserTabViewItem:activeTabViewItem]
		) {
		[self revealTabViewContent:nil] ;
	}
	
	[self setIsInVersionBrowser:YES] ;
}

- (void)exitVersionBrowserNote:(NSNotification*)note {
	[self setIsInVersionBrowser:NO] ;
}

#pragma mark BkmxSearchDelegate Protocol Support

- (NSSet*)autosavedSearchValueForKey:(NSString*)key {
	NSArray* keyPathArray = [[self document] autosaveKeyPathArrayWithLastKeys:key] ;
	NSArray* array = nil ;
	if (keyPathArray) {
		array = [[NSUserDefaults standardUserDefaults] valueForKeyPathArray:keyPathArray] ;
	}
	
	// Check in case of corrupt prefs
	if (array && ![array isKindOfClass:[NSArray class]]) {
		NSLog(@"Warning 328-7135 Ignoring corrupt pref %@", key) ;
		array = nil ;
	}
	
	if (
		!array // User has never touched this part of the Quick Search menu
		||
		([array count] < 1)  // Corrupt prefs, since we don't allow writing < 1 element
		) {
		array = [[NSUserDefaults standardUserDefaults] defaultQuickSearchParmsForKey:key] ;        
	}
	
	// Check in case of corrupt prefs
	if (array && ![array isKindOfClass:[NSArray class]]) {
		NSLog(@"Warning 851-3687 Ignoring corrupt pref %@", key) ;
		array = [NSArray array] ;
	}
	
	if (!array) {
		array = [NSArray array] ;
	}
	
	return [NSSet setWithArray:array] ;
}

- (IBAction)search:(id)sender {
    [self revealTabViewContent:sender] ;
    [[self cntntViewController] search:sender] ;
}


- (IBAction)changeSearchParm:(NSMenuItem*)menuItem {
	if (![self autosaveArmed]) {
		return ;
	}
	
	NSString* key ;
    id object ;
    [BkmxSearchField decodeMenuItem:menuItem
                            toKey_p:&key
                         toObject_p:&object] ;
    
    if (key && object) {
        NSArray* keyPathArray = [[self document] autosaveKeyPathArrayWithLastKeys:key] ;

        BOOL proposedState = ([menuItem state] == NSControlStateValueOff) ;
        BOOL ok = YES ;
        
        
        NSSet* existingSet = [self autosavedSearchValueForKey:key] ;
        // Because existingArray may be the default value and not really existing in
        // user defaults under the keyPathArray, we do not use our cool deep
        // mutators -[NSUserDefaults addUniqueObject:toArrayAtKeyPathArray:]
        // and -[NSUserDefaults removeObject:fromArrayAtKeyPathArray:] to set
        // the new values, but instead mutate existingArray and overwrite the
        // whole thing from scratch.
        
        // Note: existingSet may be empty but will not be nil.
        
        // Before counting, check in case there are corrupt prefs
        if (![existingSet respondsToSelector:@selector(count)]) {
            existingSet = [NSSet set] ;
        }
        
        if (!proposedState  && ![key isEqualToString:constAutosaveSearchOptions]) {
            // Do not allow the last item to be removed
            if ([existingSet isEqualToSet:[NSSet setWithObject:object]]) {
                ok = NO ;
            }
        }
        
        if (ok) {
            // The following was removed in BookMacster 1.16.  See note below.
            // [menuItem toggleState] ;
            
            NSSet* newSet ;
            if (proposedState) {
                newSet = [existingSet setByAddingObject:object] ;
            }
            else {
                newSet = [existingSet setByRemovingObject:object] ;
            }
            
            [[NSUserDefaults standardUserDefaults] setValue:[newSet allObjects]
                                            forKeyPathArray:keyPathArray] ;
            [[NSUserDefaults standardUserDefaults] synchronize] ;
            
            /* The following was added as a bug fix in BookMacster 1.16.
             The problem was that, because we do not have direct access to the
             actual menu in an NSSearchField, but can only -setSearchMenuTemplate:
             which NSSearchField uses to create the actual menu, setting the
             state of the *real* menu item passed in to this method is insufficient,
             because the next time NSSearchField constructs a new menu from the
             template, the state will be reverted to its old value.  Instead, we
             need to change the *template*, which will cause NSSearchField to
             re-create its menu from the template, and also the change will stick
             the next time it is recreated.  To change the template, we invoke the
             following special method which re-creates the template, including its
             special placeholders… */
            [searchField populateFromUserDefaultsForDelegate:self
                                            includeSearchFor:YES] ;
        }
        else {
            NSBeep() ;
        }
    }

    // The following payloads the ContentLazyView in case it is not.
    [self revealTabViewContent:self] ;
    
    [self updateSearchFieldPlaceholder] ;
    [[self cntntViewController] search:menuItem] ;
}

// BIG MISTAKE!  NEVER DO THIS!!!!  THIS CODE IS VERY BAD
//- (NSString*)description {
// If this ever gets invoked before -awakeFromNib, it will invoke
// -awakeFromNib in order to get the window and NSLog() will die,
// so that any exceptions in -awakeFromNib due to, for example,
// -document being nil, won't get logged.
//	return [NSString stringWithFormat:@"BkmxDocWinCon of \"%@\"", [[self window] title]] ;
//}

// For debug logging only
/*
- (oneway void)release {
	NSLog(@"RebugLog:  Before releasing, rc=%i for %@", [self retainCount], self) ;
	[super release] ;
}	

- (id)retain {
	[super retain] ;
	NSLog(@"RebugLog:  After retaining, rc=%i for %@", [self retainCount], self) ;
	return self ;
}
*/
@end
