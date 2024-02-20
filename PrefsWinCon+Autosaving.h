#import "PrefsWinCon.h"
#import "StarkTyper.h"

@interface PrefsWinCon (Autosaving) 

// Utilities

- (NSArray*)autosaveKeyPathArrayWithLastKeys:(id)lastKeys ;

// Setters

- (void)autosaveWindowFrameNote:(NSNotification*)notification ;
- (void)autosaveActiveTabViewSizeNote:(NSNotification*)notification ;
- (void)autosaveSelectedTabViewItem:(NSTabViewItem*)tabViewItem
						  inTabView:(NSTabView*)tabView ;

- (void)autosaveAllCurrentValues ;

// Getters

- (NSString*)autosavedWindowFrame ;
- (NSString*)autosavedContentSizeOfTabViewItem:(NSTabViewItem*)tabViewItem ;


// Integrated Getter - Displayers

- (void)restoreAutosavedTabViewSelections ;

@end
