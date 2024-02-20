#import "DupesOutlineView.h"
#import "Stark.h"
#import "NSMenu+StarkContextual.h"
#import "BkmxDocWinCon.h"
#import "BkmxGlobals.h"

@implementation DupesOutlineView

- (NSMenu*)menuForTableColumnIndex:(NSInteger)iCol rowIndex:(NSInteger)iRow {
	id item = [self itemAtRow:iRow] ;
	NSMenu* menu = nil ;
	
	if ([item isKindOfClass:[Stark class]]) {
		if ([[self selectedObjects] indexOfObjectIdenticalTo:item] == NSNotFound) {
			// Clicked item is not in selection, so we change
			// the selection to be only the clicked item
			// (because this is how The Finder does it).
			[self selectRowIndexes:[NSIndexSet indexSetWithIndex:iRow] byExtendingSelection:NO] ;
		}
		
		// Create the menu
		menu = [[NSMenu alloc] initWithTitle:@""];
        [menu setFont:[NSFont systemFontOfSize:[[NSUserDefaults standardUserDefaults] doubleForKey:constKeyMenuFontSize]]] ;
		[menu autorelease] ;
		
		// Now, add menu items
		
		NSArray* selectedStarks = [[[self window] windowController] selectedDupeStarks] ;
		[menu addCopyAndCutItemForStarks:selectedStarks] ;
		[menu addHierarchicalItemsForStarks:selectedStarks] ;
		[menu addDeleteItemForStarks:selectedStarks] ;
		[menu addSeparatorItem] ;
		[menu addShowInspectorItem] ;
 	}
	else {
		// Item must be of class Dupe.  No contextual menu.
	}
		
	return menu ;
}

- (void)awakeFromNib {
	// Per Discussion in documentation of -[NSObject respondsToSelector:].
	// the superclass name in the following must be hard-coded.
	if ([BkmxOutlineView instancesRespondToSelector:@selector(awakeFromNib)]) {
		[super awakeFromNib] ;
	}
	
	// Just before an undo or redo operation, we want to deselect all items,
	// so that, after the undo or redo, only the affected items will be selected
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(deselectAll:)
												 name:NSUndoManagerWillUndoChangeNotification
											   object:[[self document] undoManager]] ;
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(deselectAll:)
												 name:NSUndoManagerWillRedoChangeNotification
											   object:[[self document] undoManager]] ;
}

- (void)reloadData {
	[super reloadData] ;
	[self expandItem:nil // nil says to expand all items (macOS 10.5 or later)
	  expandChildren:YES] ;
    // Added in BookMacster 1.21:
    [self selectRowIndexes:[NSIndexSet indexSet]
      byExtendingSelection:NO] ;
    /* The above is kind of cheesy.  I mean, what if data gets reloaded for
     some reason other than the selection being deleted?  However, I can't
     think of any way that would happen.  Switching tabs does not do it.
     Well, I'm just going to leave it cheesy. */
}

@end
