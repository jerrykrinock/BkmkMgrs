#import "BkmxDocWinCon.h"
#import "StarkTyper.h"

@interface BkmxDocWinCon (Autosaving) 


// Setters

- (void)autosaveWindowFrameNote:(NSNotification*)notification ;
- (void)autosaveActiveTabViewSizeNote:(NSNotification*)notification ;
- (void)autosaveTableColumnsInTableView:(NSTableView*)tableView ;
- (void)autosaveSelectedTabViewItem:(NSTabViewItem*)tabViewItem
						  inTabView:(NSTabView*)tabView ;

- (void)autosaveAllCurrentValues ;

// Getters

- (NSString*)autosavedWindowFrame ;
- (NSString*)autosavedContentSplitView ;
- (NSDictionary*)autosavedColumnStateForTableView:(NSTableView*)tableView ;
- (NSString*)autosavedContentSizeOfTabViewItem:(NSTabViewItem*)tabViewItem ;
- (NSDictionary*)tabAutosaves ;

@end
