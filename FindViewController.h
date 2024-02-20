#import <Cocoa/Cocoa.h>

@class StarkPredicateEditor ;
@class FindTableView ;
@class BkmxDocWinCon ;
@class ReportsViewController ;
@class SSYMoreObserveableArrayController ;

@interface FindViewController : NSViewController {
	IBOutlet FindTableView* findTableView ; 
	IBOutlet StarkPredicateEditor* predicateEditor;

	IBOutlet NSView* findMiddleView ;			// the progress search view
	IBOutlet NSTextField* findProgressText ;	// search result #
    IBOutlet NSView* replaceControlsSubview ;
    IBOutlet NSTextField* replaceValueField ;
    IBOutlet NSButton* findButton ;
    IBOutlet ReportsViewController* reportsViewController ;
}

@property (assign) BOOL replaceInSelectedNotAll ;

- (FindTableView*)findTableView ;

@property (assign) IBOutlet SSYMoreObserveableArrayController* findArrayController ;
@property (readonly) BOOL canReplace ;

- (IBAction)changedPredicate:(id)sender;

- (void)refreshResultsWithSortKey:(NSString*)sortKey
                        ascending:(BOOL)ascending ;

- (void)reveal ;

- (IBAction)findStarksThatAreDontVerify:(id)sender ;
- (IBAction)findStarksThatAreBroken:(id)sender ;
- (IBAction)findStarksThatAreUpdatedOrSecured:(id)sender ;
- (IBAction)findStarksThatAreUnknown:(id)sender ;
- (IBAction)find:(id)sender ;
- (IBAction)replace:(id)sender ;

@end
