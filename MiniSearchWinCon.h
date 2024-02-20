#import <Cocoa/Cocoa.h>
#import "BkmxSearchDelegate.h"


@class BkmxSearchField ;

@interface MiniSearchWinCon : NSWindowController <BkmxSearchDelegate, NSTableViewDataSource> {
    IBOutlet BkmxSearchField* searchField ;
    IBOutlet NSTableView* searchResultsTableView ;
    NSString* m_searchText ;
    CGFloat m_deadHeight ;
    NSArray* m_searchResults ;
}

- (IBAction)search:(id)sender ;

@end
