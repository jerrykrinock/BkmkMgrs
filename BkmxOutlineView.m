#import <Bkmxwork/Bkmxwork-Swift.h>
#import "BkmxAppDel.h"
#import "BkmxOutlineView.h"
#import "NSFont+Height.h"
#import "NSArray+Select1.h"
#import "BkmxDoc+Actions.h"
#import "NSTableView+Scrolling.h"
#import "Stark.h"
#import "ContentDataSource.h"

@implementation BkmxOutlineView

+ (void)initialize {
    [self exposeBinding:@"selectedObject"] ;
    [self exposeBinding:@"selectedObjects"] ;
}

@synthesize selectedObjects ;

/*
 - (NSArray*)selectedObjects {
 NSArray* sos = [[selectedObjects retain] autorelease] ;
	return sos;
 }
 
 - (void)setSelectedObjects:(NSArray *)value {
 if (selectedObjects != value) {
 [selectedObjects release];
 selectedObjects = [value copy];
 }
 }
 */

- (BOOL)isVisibleItem:(id)item {
    BOOL output = NO ;
    NSInteger row = [self rowForItem:item] ;
    if (row >= 0) {
        NSRect itemRect = [self rectOfRow:row] ;
        NSRect visibleRect = [[self enclosingScrollView] documentVisibleRect] ;
        output = ((NSMinY(visibleRect) <= NSMinY(itemRect)) && (NSMaxY(visibleRect) >= NSMaxY(itemRect))) ;
    }
    return output ;
}

- (NSArray*)visibleItemsAndExtraPoints_p:(CGFloat*)extraPoints_p {
    NSMutableArray* visibleItems = [[NSMutableArray alloc] init] ;
    NSRect visibleRowsRect = [self visibleRowsRect] ;
    CGFloat scrollAmount = visibleRowsRect.origin.y ;
    CGFloat rowPitch = [self rowHeight] + [self intercellSpacing].height ;
    CGFloat rawTopVisibleRow = scrollAmount/rowPitch ;
    NSInteger topVisibleRow = (NSInteger)rawTopVisibleRow ;
    if (extraPoints_p) {
        *extraPoints_p = (rawTopVisibleRow - topVisibleRow) * rowPitch ;
    }
    NSInteger nRows = [self numberOfRows] ;
    NSInteger nVisibleRows = MIN(ceil(visibleRowsRect.size.height/rowPitch), nRows) ;
    NSInteger bottomVisibleRow = topVisibleRow + nVisibleRows - 1 ;
    for (NSInteger i=topVisibleRow; i<=bottomVisibleRow; i++) {
        id visibleItem = [self itemAtRow:i] ;
        // For the Content Outline, visibleItem is a ContentProxy instance
        if (visibleItem) {
            [visibleItems addObject:visibleItem] ;
        }
    }
    
    NSArray* answer = [NSArray arrayWithArray:visibleItems] ;
    [visibleItems release] ;
    
    return answer ;
}

- (void)scrollToMakeVisibleItems:(NSArray*)items
                 plusExtraPoints:(CGFloat)extraPoints {
    NSInteger topVisibleRow = NSNotFound ;
    for (id item in items) {
        if ([item respondsToSelector:@selector(isDirty)]) {
            if ([(ContentProxy*)item isDirty]) {
                continue ;
            }
        }
        
        NSInteger row = [self rowForItem:item] ;
        topVisibleRow = MIN(row, topVisibleRow) ;
    }
    
    if (topVisibleRow >= 0) {
        [self scrollRowToTop:topVisibleRow
             plusExtraPoints:extraPoints] ;
    }
    else {
        // No row was found for any of items.  Do nothing.
    }
}

- (BkmxDoc*)document {
    return [[[self window] windowController] document] ;
}

- (NSArray*)objectsAtRowIndexes:(NSIndexSet*)indexSet {
    NSMutableArray* objects = [[NSMutableArray alloc] init] ;
    
    NSUInteger i = [indexSet firstIndex] ;
    while ((i != NSNotFound)) {
        id object = [self modelObjectAtRow:i] ;
        if (object) {
            [objects addObject:object] ;
        }
        
        i = [indexSet indexGreaterThanIndex:i] ;
    }
    
    NSArray* output = [objects copy] ;
    [objects release] ;
    return [output autorelease] ;
}


- (NSInteger)countOfSelectedObjects {
    return [[self selectedObjects] count] ;
}

- (id)selectedObject {
    id object = [[self selectedObjects] select1] ;
    return object ;
}
+ (NSSet*)keyPathsForValuesAffectingSelectedObject {
    return [NSSet setWithObjects:
            @"selectedObjects",
            nil] ;
}

- (void)awakeFromNib {
    // Per Discussion in documentation of -[NSObject respondsToSelector:].
    // the superclass name in the following must be hard-coded.
    if ([NSOutlineView instancesRespondToSelector:@selector(awakeFromNib)]) {
        [super awakeFromNib] ;
    }
    
    [self setAllowsEmptySelection:YES] ;
    
    /*
     Note that I do not register for NSUndoManagerWillUndoChangeNotification
     and NSUndoManagerWillRedoChangeNotification to -deselectAll:  While it
     is desirable to deselect all items so that only the re-appeared item
     will be selected.  But it is not desirable when undoing an attribute
     change, to deselect the item whose attribute you just restored!
     */
}

- (void)selectObjects:(NSArray*)objects
 byExtendingSelection:(BOOL)extend {
    NSMutableIndexSet* indexSet = [[NSMutableIndexSet alloc] init] ;
    for (id item in objects) {
        if ([item isKindOfClass:[Stark class]]) {
            item = [(ContentDataSource*)[self dataSource] proxyForStark:(Stark*)item] ;
        }
        else {
            // item is often a ContentProxy.  We leave that as is.
        }
        
        NSInteger iRow = [self rowForItem:item] ;
        if (iRow >= 0) {  // rowForItem returns -1 if can't find, not NSNotFound
            [indexSet addIndex:iRow] ;
        }
    }
    
    if ([indexSet count] > 0) {
        if (!extend) {
            [self deselectAll:self] ;
        }
        [self selectRowIndexes:indexSet
          byExtendingSelection:YES] ;
    }
    
    [indexSet release] ;
}

- (NSMutableDictionary*)cellTips {
    if (!m_cellTips) {
        m_cellTips = [[NSMutableDictionary alloc] init] ;
    }
    
    return m_cellTips ;
}

// Added in BookMacster 1.17
- (BOOL)shouldCollapseAutoExpandedItemsForDeposited:(BOOL)deposited {
    return YES ;
}

// ContentOutlineView subclass overrides this.
- (id)modelObjectAtRow:(NSInteger)row {
    return [self itemAtRow:row] ;
}

- (void)reloadData {
    [self setRowHeight:[[(BkmxAppDel*)[NSApp delegate] fontTable] tableRowHeight]] ;
    [super reloadData] ;
    
    /* Using +[ContentProxies starksForProxies] here would have been a better
     programming practice, but that would require two loops.  The following
     should be more efficient. */
    NSIndexSet* selectedRowIndexes = [self selectedRowIndexes] ;
    NSMutableArray* selectedStarks = [[NSMutableArray alloc] init] ;
    NSUInteger i = [selectedRowIndexes firstIndex] ;
    while ((i != NSNotFound)) {
        Stark* stark = [self modelObjectAtRow:i] ;
        // If the stark representing the proxy has been deleted, stark = nil
        if (stark) {
            [selectedStarks addObject:stark] ;
        }
        i = [selectedRowIndexes indexGreaterThanIndex:i] ;
    }
    [self setSelectedObjects:[NSArray arrayWithArray:selectedStarks]] ;
    [selectedStarks release] ;
    [[self cellTips] removeAllObjects] ;
    [self removeAllToolTips] ;
}

- (void) dealloc {
    [selectedObjects release] ;
    [m_cellTips release] ;
    
    [self setDelegate:nil] ;
    [self setDataSource:nil] ;
    
    
    [super dealloc] ;
}

- (void)addToolTip:(NSString*)tip
              rect:(NSRect)rect {
    NSToolTipTag tag = [self addToolTipRect:rect
                                      owner:self
                                   userData:nil] ;
#if 0
    NSBezierPath *p = [NSBezierPath bezierPathWithRect:rect];
    [[NSColor redColor] set] ;
    [p stroke] ;
#endif
    [[self cellTips] setObject:tip
                        forKey:[NSNumber numberWithInteger:tag]] ;
}

- (NSString *)view:(NSView*)view
  stringForToolTip:(NSToolTipTag)tag
             point:(NSPoint)point
          userData:(void *)userData {
    NSDictionary* tips = [self cellTips] ;
    NSNumber* key = [NSNumber numberWithInteger:tag] ;
    NSString* tip = [tips objectForKey:key] ;
    return tip ;
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
            NSInteger firstDeletedRow = NSNotFound ;
            NSInteger aRow = [[self selectedRowIndexes] firstIndex] ;
            if ((aRow != NSNotFound) && (aRow < firstDeletedRow)) {
                firstDeletedRow = aRow ;
            }

            [[[[self window] windowController] document] deleteItems:self] ;
            didDo = YES ;

            if (firstDeletedRow < [self numberOfRows]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSIndexSet* indexSet = [NSIndexSet indexSetWithIndex:firstDeletedRow] ;
                    [self selectRowIndexes:indexSet
                      byExtendingSelection:NO] ;
                }) ;
            }
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


@end
