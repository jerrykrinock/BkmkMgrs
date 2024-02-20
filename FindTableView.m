#import "FindTableView.h"
#import "NSMenu+StarkContextual.h"
#import "FindViewController.h"
#import "BkmxDocWinCon.h"
#import "BkmxDoc+Actions.h"
#import "BkmxAppDel.h"
#import "NSFont+Height.h"
#import "StarkTableColumn.h"
#import "NSTableView+Autosave.h"
#import "NSTableView+MoreSizing.h"

@implementation FindTableView

- (NSArrayController*)arrayControllerPeek {
    return arrayControllerPeek ;
}

- (void)awakeFromNib {
    // Per Discussion in documentation of -[NSObject respondsToSelector:],
    // the superclass name in the following must be hard-coded.
    if ([NSTableView instancesRespondToSelector:@selector(awakeFromNib)]) {
        [super awakeFromNib] ;
    }
    
    [self setAllowsEmptySelection:YES] ;
}

#define NUMBER_OF_COLUMNS 3

- (void)restoreFromAutosaveState:(NSDictionary*)state {
	if (state) {
		[super restoreFromAutosaveState:state] ;
	}
	else {
		// New document
		NSAssert1(NUMBER_OF_COLUMNS == [self numberOfColumns], @"nCols=%ld", (long)[self numberOfColumns]) ;
		
		// Set default attributes for the user-defined columns only
		[(StarkTableColumn*)[[self tableColumns] objectAtIndex:1] setUserDefinedAttribute:constKeyUrlOrStats] ;
		[(StarkTableColumn*)[[self tableColumns] objectAtIndex:2] setUserDefinedAttribute:constKeyAddDate] ;
		
		CGFloat defaultWidths[NUMBER_OF_COLUMNS] ;
		NSInteger i = 0 ;
		for (StarkTableColumn* tableColumn in [self tableColumns]) {
			defaultWidths[i] = [tableColumn defaultWidth] ;
			i++ ;
		}
		
		[self proportionWidths:defaultWidths] ;
	}
}

- (void)reloadData {
	[self setRowHeight:[[(BkmxAppDel*)[NSApp delegate] fontTable] tableRowHeight]] ;
	[super reloadData] ;
}

- (void)keyDown:(NSEvent*)event {
	NSString* s = [event charactersIgnoringModifiers] ;
	unichar keyChar = 0 ;
	BOOL didDo = NO ;
	if ([s length] == 1) {
		keyChar = [s characterAtIndex:0] ;
		if ((keyChar == NSCarriageReturnCharacter) || (keyChar == NSEnterCharacter)) {
			// Unless editing is already in process, which is not the
			// case we're trying to handle here, an entire row will
			// be selected and therefore [self selectedColumn] will
			// be the "no selection" indicator, -1. So, we edit column
			// 0.  If the user wants a different column, they can
			// easily tab to it.
			[self editColumn:0
						 row:[self selectedRow]
				   withEvent:nil
					  select:YES] ;
			didDo = YES ;			
		}
		else if (keyChar == NSDeleteCharacter) {
			[[[[self window] windowController] document] deleteItems:self] ;
			didDo = YES ;
		}
	}
	
	NSUInteger modifierFlags = [[NSApp currentEvent] modifierFlags] ;
	BOOL cmdKeyDown = ((modifierFlags & NSEventModifierFlagCommand) != 0) ;
	if (!didDo && !cmdKeyDown) {
		// NSTableView implements its "move selection" action in response to
		// arrow keys whether the cmd key is down or not.  And in Leopard, this is
		// "passed through" to NSOutline/TableView.  So, we only pass to super
		// if cmd key is not down.  For full story see
		// http://www.cocoabuilder.com/archive/message/cocoa/2008/6/5/209320
		[super keyDown:event] ;
	}
	else if (cmdKeyDown) {
		NSBeep() ;
	}
}

- (NSArray*)selectedObjects {
	return [arrayControllerPeek selectedObjects] ;
}

- (NSMenu*)menuForTableColumnIndex:(NSInteger)iCol
						  rowIndex:(NSInteger)iRow {
	NSArrayController* arrayController = [self arrayControllerPeek] ;
	id clickedObject = [[arrayController arrangedObjects] objectAtIndex:iRow] ;
	NSArray* selectedObjects = [arrayController selectedObjects] ;
	if ([selectedObjects indexOfObjectIdenticalTo:clickedObject] == NSNotFound) {
		// Clicked item is not in selection, so we change
		// the selection to be only the clicked item
		// (because this is how The Finder does it).
		[self selectRowIndexes:[NSIndexSet indexSetWithIndex:iRow] byExtendingSelection:NO] ;
	}
	
	
	return [NSMenu menuWithAllActionsForSelectedStarks:[(BkmxDocWinCon*)[self delegate] selectedStarks]] ;
}

@end
