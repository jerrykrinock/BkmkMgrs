#import <Cocoa/Cocoa.h>
#import "BkmxDocViewController.h"
#import "TabViewSizing.h"
#import "BkmxDocTabViewControls.h"

@class DupesOutlineView ;
@class SSYProgressView ;
@class FindViewController ;
@class SSYArrayController ;
@class SSYTabView ;
@class Dupetainer ;

@interface ReportsViewController : BkmxDocViewController
<
BkmxDocTabViewControls,
TabViewSizing,
NSOutlineViewDelegate
> {
    IBOutlet DupesOutlineView* dupesOutlineView ;
    IBOutlet SSYProgressView* dupesStatus ;
    IBOutlet NSObjectController* dupetainerController ;
    IBOutlet FindViewController* findViewController ;
    IBOutlet SSYArrayController* ixportDiariesArrayController ;
    IBOutlet NSPopUpButton* logsPopup ;
    IBOutlet SSYTabView* reportsTabView ;
    IBOutlet NSButton* showAdditionsSwitch ;
    IBOutlet NSButton* showDeletionsSwitch ;
    IBOutlet NSButton* showMovesSwitch ;
    IBOutlet NSButton* showSlidesSwitch ;
    IBOutlet NSButton* showUpdatesSwitch ;
    IBOutlet SSYArrayController* starkoidsArrayController ;
    IBOutlet NSTableView* starkoidsTableView ;
    IBOutlet NSSegmentedControl* switchReportsTab ;
    IBOutlet NSTabViewItem* tabDupes ;
    IBOutlet NSTabViewItem* tabFind ;
    IBOutlet NSTabViewItem* tabLogs ;
    IBOutlet NSTabViewItem* tabVerify ;
}

- (DupesOutlineView*)dupesOutlineView ;
- (FindViewController*)findViewController ;
- (SSYTabView*)reportsTabView ;

- (BOOL)findTabIsSelected ;

- (NSArray*)selectedObjects ;

/*!
 @brief    Deletes all the receiver's selected starks from their
 managed object context.
 */
- (IBAction)deleteSelectedDupeStarks:(id)sender ;

/*!
 @brief    Sets isAllowedDupe to YES for each selected stark in the
 receiver
 */
- (IBAction)allowSelectedDupeStarks:(id)sender ;

/*!
 @brief    Returns the starks that are selected in the receiver's
 dupesOutlineView.
 */
- (NSArray*)selectedDupeStarks ;

/*!
 @brief    Returns YES if one or more starks in the receiver are selected.
 */
- (BOOL)hasDupeStarkSelection ;

- (void)updateIxportDiariesTableForObject:(id)object ;

- (void)selectNewestIxportLog ;

- (IBAction)updateIxportDiariesTable:(id)sender ;

- (IBAction)writeLogToFile:(id)sender ;

- (NSString*)writeLogToPath:(NSString*)path
					   back:(NSInteger)back
					doStamp:(BOOL)doStamp
					error_p:(NSError**)error_p ;

/*
 @details  Bound to in BkmxDoc.xib
 */
- (IBAction)cleanDefunctDiaryEntries:(id)sender ;

@end
