#import <Cocoa/Cocoa.h>
#import "BkmxDocViewController.h"
#import "TabViewSizing.h"
#import "RPTokenControl.h"
#import "SSYMenuButton.h"
#import "BkmxDocTabViewControls.h"

// Besides being used in -menuNeedsUpdate: in BkxmDocWinCon and addNew: in this file,
// these tags are also used in BookMacsterMain.xib, in the "Add New"
// menu items in the Selection menu.
#define TAG_NEW_SOFT_FOLDER 3410
#define TAG_NEW_BOOKMARK 3420
#define TAG_NEW_SEPARATOR 3430
#define TAG_NEW_BOOKMACSTERIZER 3440

@class ContentOutlineView ;
@class ContentDataSource ;
@class Stark ;
@class SSYTokenField ;

@interface CntntViewController : BkmxDocViewController <
BkmxDocTabViewControls,
SSYMenuMaker,
TabViewSizing,
NSOutlineViewDelegate,
RPTokenControlDelegate
> {
    IBOutlet RPTokenControl* tagCloud ;
    IBOutlet ContentOutlineView* contentOutlineView ;
    IBOutlet NSTextView* filterAnnunciator ;
    IBOutlet NSPopover* tagsPopover ;
    IBOutlet NSButton* buttonShowTags ;
    IBOutlet NSSplitView* splitView ;
    IBOutlet NSSegmentedControl* switchDisplayFolders ;
    IBOutlet NSSegmentedControl* switchFilterLogic ;
    IBOutlet NSTextField* textLineage ;
    // Outlet bookshigController is needed for Document Revert to work, added in BookMacster 1.5.
    IBOutlet NSObjectController* bookshigController ;
    IBOutlet NSImageView* lineageImageView ;
    
	BOOL m_outlineMode ;
	BOOL m_isReloadingData ;
    BOOL m_isInFlatModeForSearch ;
	NSToolTipTag m_disclosureTriangleToolTip ;

    ContentDataSource* m_contentDataSource ;
}

- (ContentOutlineView*)contentOutlineView ;


- (NSSplitView*)splitView ;

@property (assign) BOOL outlineMode ;

- (void)setBackToOutlineMode ;

/*
 @details  This method is needed by
 -[StarkLocation canInsertItems:fix:outlineView:]
 */
- (BkmxDoc*)document ;

- (IBAction)setOutlineModeFromSegmentedControl:(NSSegmentedControl*)sender ;

- (IBAction)showTagsPopover:(id)sender ;

- (void)updateDetailViewForStarks:(NSArray*)starks ;

- (NSArray*)selectedStarks ;

- (void)safelySelectFirstItem ;

- (void)invalidateFlatCache ;

- (void)updateWindowForStark:(Stark*)stark ;

- (void)updateOutlineMode ;

- (void)filterTagsForObject:(id)object ;

- (void)clearAllContentFilters ;

- (void)showStark:(Stark*)stark
         selectIt:(BOOL)selectIt ;

- (IBAction)search:(id)sender ;

- (void)deselectAll ;

- (void)reloadStarks:(NSSet*)starks ;

- (NSArray*)selectedTags;

// CLEAR-STAGING //- (void)clearReloadStaging ;

@end

