#import "ApproveCruftController.h"
#import "NSString+SSYHttpQueryCruft.h"
#import "NS(Attributed)String+Geometrics.h"
#import "StarkCruft.h"
#import "Stark.h"
#import "BkmxAppDel.h"
#import "SSYMH.AppAnchors.h"

@interface ApproveCruftController ()

@end

@implementation ApproveCruftController

- (instancetype)initWithStarkCrufts:(NSSet <StarkCruft*> *)starkCrufts {
    self = [super initWithWindowNibName:@"ApproveCruft"] ;
    if (self) {
        self.starkCrufts = starkCrufts ;
    }
    
    return self ;
}

- (void)windowDidLoad {
    [super windowDidLoad] ;
    
    self.starkCruftsArrayController.content = self.starkCrufts.allObjects ;
    /* Deselect all: */
    [self.starkCruftsArrayController setSelectionIndexes:[NSIndexSet indexSet]] ;
    
    NSArray* sortDescriptors = @[
                                 [[[NSSortDescriptor alloc] initWithKey:@"stark.nameNoNil" ascending:YES] autorelease]
                                 ] ;
    self.starkCruftsArrayController.sortDescriptors = sortDescriptors ;
    
    [self.removeSelectedCruftButton bind:@"enabled"
                                toObject:self.starkCruftsArrayController
                             withKeyPath:@"hasSelection"
                                 options:0] ;
}

- (void)dealloc {
    [self.removeSelectedCruftButton unbind:@"enabled"] ;
    [_starkCrufts release] ;
    
    [super dealloc] ;
}

- (IBAction)selectAll:(id)sender {
    NSRange allRange = NSMakeRange(0, ((NSArray*)self.starkCruftsArrayController.content).count) ;
    NSIndexSet* all = [NSIndexSet indexSetWithIndexesInRange:allRange] ;
    self.starkCruftsArrayController.selectionIndexes = all ;
}

- (IBAction)selectNone:(id)sender {
    self.starkCruftsArrayController.selectionIndexes = [NSIndexSet indexSet] ;
}

- (IBAction)help:(id)sender {
    [(BkmxAppDel*)[NSApp delegate] openHelpAnchor:constHelpAnchorCruft] ;
}

- (void)endWithReturnCode:(NSInteger)returnCode {
    [[[self window] sheetParent] endSheet:[self window]
                               returnCode:returnCode] ;
    
    // Window is set to "Release when closed" in xib
    // The windowController (self) is released in the completion handler
    // inside -[BkmxDoc(Actions) removeCruft:].
}

- (IBAction)cancel:(id)sender {
    [self endWithReturnCode:NSAlertSecondButtonReturn] ;
}

- (IBAction)removeSelectedCruft:(id)sender {
    Stark* anyStark = ((StarkCruft*)[self.starkCruftsArrayController.arrangedObjects firstObject]).stark ;
    NSManagedObjectContext* managedObjectContext = [anyStark managedObjectContext] ;

    [[managedObjectContext undoManager] beginUndoGrouping] ;

    for (StarkCruft* starkCruft in self.starkCruftsArrayController.selectedObjects) {
        NSString* decruftedUrl = [starkCruft.stark.url urlStringByRemovingCruftyQueryPairsInRanges:starkCruft.cruftRanges] ;
        starkCruft.stark.url = decruftedUrl ;
    }
    
    [managedObjectContext.undoManager setActionName:NSLocalizedString(@"Remove Cruft", nil)] ;
    [[managedObjectContext undoManager] endUndoGrouping] ;

    /* Must do this last because it will dealloc self. */
    [self endWithReturnCode:NSAlertFirstButtonReturn] ;
}

- (NSAttributedString*)attributedStringForRow:(NSInteger)row
                                       column:(NSInteger)column {
    NSAttributedString* answer ;
    StarkCruft* starkCruft = [((NSArray*)self.starkCruftsArrayController.arrangedObjects) objectAtIndex:row] ;
    switch (column) {
        case 0:
            answer = starkCruft.nameAttributed ;
            break ;
        case 1:
            answer = starkCruft.urlAttributedAndHighlighted ;
            break ;
        default:
            answer = nil ;
            NSAssert(NO, @"Internal Error 624-5838") ;
    }
    
    return answer ;
}

- (void)tableViewColumnDidResize:(NSNotification*)aNotification {
    NSIndexSet* allRowIndexes = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, self.tableView.numberOfRows)] ;
    [self.tableView noteHeightOfRowsWithIndexesChanged:allRowIndexes] ;
    [allRowIndexes release] ;
}

- (CGFloat)tableView:(NSTableView*)tableView
         heightOfRow:(NSInteger)row {
    /* I considered are other methods to calculate the height of multiline text
     required including a method suggested by Corbin Dunn of Apple:
     http://stackoverflow.com/questions/7504546/view-based-nstableview-with-rows-that-have-dynamic-heights
     and this method described by the amazing Ken Thomases, which uses Auto
     Layout somehow:
     http://stackoverflow.com/questions/21203208/view-based-nstableview-make-row-height-dependent-on-content
     
     It looks like both of them use the "dummy" view, as suggested by Corbin, to
     do the Heavy Lifting.  Instead, I use the Layout Manager via my
     NS(Attributed)String+Geometrics.h category.  I also use a bit of Auto
     Layout: the text field in each column is constrainted top, bottom, leading
     and trailing to its superview, which is the cell's view (view-based table).
     It is this trick which, I think, causes both views (and both text fields)
     to assume the larger of the height required by either of them.
     
     There may be better ways to do this, but it "works for me".
     
     Finally, note that the attributed strings contain fonts in their attributes.
     I think this is important because, otherwise, the Heavy Lifing measurement
     had better use the same font as the text field does.  Otherwise, the text
     field or table view could use a default font which would require a different
     measurement.
     */
    
    /* We start with 1.0 instead of 0 because, when view first loads and table
     is empty, for some reason, Cocoa still invokes this method.  In this case,
     the 'height' any loop iterations below will be 0.0, and if we started with
     0.0, we would return 0.0, which would raise an exception. */
    CGFloat tallestHeight = 1.0 ;
    for (NSInteger columnIndex=0; columnIndex<tableView.tableColumns.count; columnIndex++) {
        NSAttributedString* as = [self attributedStringForRow:row
                                                       column:columnIndex] ;
        CGFloat width = [[[tableView tableColumns] objectAtIndex:columnIndex] width] ;
        /* The following compensates for the inset of NSTextField from its cell
         view in xib: 2.0 points on the left and 2.0 on the right. */
        width -= 4.0 ;
        CGFloat height = [as heightForWidth:width] ;  // The Heavy Lifting

        /* The following, I think, compensates for overhead required for the
         border of the NSTextField in which this will be displayed. */
        height += 4.0 ;
        /* The following compensates for the inset of NSTextField from its cell
         view in xib: 2.0 points on the top and 2.0 on the bottom. */
        height += 4.0 ;
        height += tableView.intercellSpacing.height ;
        
        if (height > tallestHeight) {
            tallestHeight = height ;
        }
    }

    return tallestHeight ;
}

@end
