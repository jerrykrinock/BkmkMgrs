#import "FindViewController.h"
#import "Starker.h"
#import "StarkTableColumn.h"
#import "NSString+LocalizeSSY.h"
#import "StarkPredicateEditor.h"
#import "BkmxDocWinCon+Autosaving.h"
#import "NSPredicateEditor+AppleForgot.h"
#import "BkmxAppDel.h"
#import "StarkReplicator.h"
#import "NSIndexSet+MoreRanges.h"
#import "Stark+Sorting.h"
#import "FindTableView.h"
#import "SSYPopUpTableHeaderCell.h"
#import "SSYTableHeaderView.h"
#import "SSYReplacePredicateEditorRowTemplate.h"
#import "SSYAlert.h"
#import "NSError+MyDomain.h"
#import "NSPredicate+SSYPreflight.h"
#import "SSYMoreObserveableArrayController.h"

@interface FindViewController ()

@property (assign) BOOL appleBug7827354Workaround ;

@end

@implementation FindViewController

- (FindTableView*)findTableView {
	return findTableView ;
}

- (BkmxDocWinCon*)windowController {
    return [reportsViewController windowController] ;
}

- (void)awakeFromNib {
	// Start with our findProgressText label empty
	[findProgressText setStringValue: @""] ;
	[findTableView setDelegate:[self windowController]] ;
    predicateEditor.ignoreEmptyStrings = YES ;
    [self showReplaceControls:NO] ;
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(refreshResultsNote:)
												 name:constNoteBkmxFindResultsNeedRefresh
											   object:[self windowController]] ;
    
    [predicateEditor addObserver:self
                      forKeyPath:@"replaceAttributeKey"
                         options:0
                         context:[self class]] ;
    
    [self.findArrayController addObserver:self
                               forKeyPath:NSStringFromSelector(@selector(hasSelection))
                                  options:0
                                  context:[self class]] ;
    [self.findArrayController addObserver:self
                               forKeyPath:NSStringFromSelector(@selector(countOfArrangedObjects))
                                  options:0
                                  context:[self class]] ;
}

- (void)observeValueForKeyPath:(NSString*)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if (context == [self class]) {
        if ([keyPath isEqualToString:@"replaceAttributeKey"]) {
            NSString* replaceAttributeKey = predicateEditor.replaceAttributeKey ;
            [self showReplaceControls:(replaceAttributeKey != nil)] ;
        }
        else if (
                 [keyPath isEqualToString:NSStringFromSelector(@selector(hasSelection))]
                 ||
                 [keyPath isEqualToString:NSStringFromSelector(@selector(countOfArrangedObjects))]
                 ) {
            self.appleBug7827354Workaround = !self.appleBug7827354Workaround ;
        }
    }
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self] ;
    [predicateEditor removeObserver:self
                         forKeyPath:@"replaceAttributeKey"] ;
    [self.findArrayController removeObserver:self
                                  forKeyPath:NSStringFromSelector(@selector(hasSelection))] ;
    [self.findArrayController removeObserver:self
                                  forKeyPath:NSStringFromSelector(@selector(countOfArrangedObjects))] ;
    
	[super dealloc] ;
}

- (void)showReplaceControls:(BOOL)doShow {
    NSRect findButtonFrame = findButton.frame ;
    BOOL doHideReplace ;
    if (doShow) {
        doHideReplace = NO ;
        findButtonFrame.origin.y = 21.0 ;
    }
    else {
        doHideReplace = YES ;
        findButtonFrame.origin.y = 11.0 ;
    }

    [NSAnimationContext beginGrouping];
    [[findButton animator] setFrame:findButtonFrame] ;
//    [[findButton animator] display] ;
    [[replaceControlsSubview animator] setHidden:doHideReplace] ;
    [NSAnimationContext endGrouping] ;
}

#if 0
#warning Logging FindViewController
- (oneway void)release {
	NSInteger rc = [self retainCount] ;
	[super release] ;
	NSString* line = [NSString stringWithFormat:@"%p 111067: After release %03ld\n%@", self, (long)rc - 1, SSYDebugBacktraceDepth(8)] ;
    NSLog(@"%@", line) ;
	return ;
}

- (id)retain {
    id x = [super retain] ;
    NSLog(@"%p 111066: After retain, rc=%ld\n%@", self,  (long)[self retainCount], SSYDebugBacktraceDepth(8)) ;
    return x ;
}
- (id)autorelease {
    id x = [super autorelease] ;
    NSLog(@"%p 111068: After autorelease, rc=%ld\n%@", self, (long)[self retainCount], SSYDebugBacktraceDepth(8)) ;
    return x ;
}
#endif

- (void)refreshResultsNote:(NSNotification*)note {
    SSYTableHeaderView* tableHeaderView = (SSYTableHeaderView*)[findTableView headerView] ;
    StarkTableColumn* sortedColumn = (StarkTableColumn*)[tableHeaderView sortedColumn] ;
    NSString* sortKey = nil ;
    SSYPopUpTableHeaderCell* headerCell ;
    SSYPopupTableHeaderCellSortState sortState = SSYPopupTableHeaderCellSortStateSortedAscending ;
    if (sortedColumn) {
        /* Quite convenient! */
        sortKey = [sortedColumn userDefinedAttribute] ;

        headerCell = (SSYPopUpTableHeaderCell*)[sortedColumn headerCell] ;
        sortState = [(SSYPopUpTableHeaderCell*)headerCell sortState] ;
    }
    if (!sortKey) {
        sortKey = constKeyName ;
    }

    [self refreshResultsWithSortKey:sortKey
                          ascending:(sortState == SSYPopupTableHeaderCellSortStateSortedAscending)] ;
}

- (void)displayError:(NSError*)error {
    if (error) {
        SSYAlert* alert = [[SSYAlert alloc] init] ;
        
        [alert alertError:error
                 onWindow:self.view.window
        completionHandler:^void(
                                NSModalResponse returnCode) {
            [alert release] ;
        }] ;
    }
}

- (void)refreshResultsWithSortKey:(NSString*)sortKey
                        ascending:(BOOL)ascending {
    Stark* anyStark = [[self.findArrayController content] firstObject] ;
    SEL sortSelector ;
    if ([[anyStark valueForKey:sortKey] respondsToSelector:@selector(localizedCaseInsensitiveCompare:)]) {
        sortSelector = @selector(localizedCaseInsensitiveCompare:) ;
    }
    else {
        sortSelector = @selector(compare:) ;
    }
    
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey
                                                                   ascending:ascending
                                                                    selector:sortSelector] ;
    NSArray <NSSortDescriptor*> * sortDescriptors = @[sortDescriptor] ;
    [sortDescriptor release] ;

    NSError* error = nil ;
    
    if ([[self windowController] findTabNowShowing]) {
        NSExpression* lhs = [NSExpression expressionForKeyPath:constKeySharype] ;
        NSExpression* rhs = [NSExpression expressionForConstantValue:@(SharypeRoot)] ;
        NSPredicate* isNotRoot = [NSComparisonPredicate predicateWithLeftExpression:lhs
                                                                        rightExpression:rhs
                                                                               modifier:NSDirectPredicateModifier
                                                                                   type:NSNotEqualToPredicateOperatorType
                                                                                options:0] ;
        NSPredicate* predicate = [predicateEditor objectValue] ;
        
        if (predicate) {
            if (![predicate preflightValidate]) {
                NSString* desc = [[NSString alloc] initWithFormat:
                                  NSLocalizedString(@"Invalid search pattern:\n\n%@", nil),
                                  [predicate predicateFormat]] ;
                error = SSYMakeError(345042, desc) ;
                [desc release] ;
            }
        }
        
        if (!error) {
            if (predicate != nil) {
                predicate = [NSCompoundPredicate andPredicateWithSubpredicates:
                             [NSArray arrayWithObjects:
                              isNotRoot,
                              predicate,
                              nil]] ;
            }
            else {
                predicate = isNotRoot ;
            }
            
            // Remember the current scroll position
            NSRange visibleRowsRange = [findTableView rowsInRect:[findTableView visibleRect]] ;
            NSInteger firstVisibleRow = visibleRowsRange.location ;
            NSInteger lastVisibleRow = (visibleRowsRange.location + visibleRowsRange.length) ;
            
            // Remember the current selection
            NSIndexSet* selectionIndexes = [self.findArrayController selectionIndexes] ;
            NSArray* oldSelection = [self.findArrayController selectedObjects] ;
            
            // Make the change
            [self.findArrayController setFilterPredicate:predicate] ;
            [self.findArrayController setSortDescriptors:sortDescriptors] ;
            /* I don't understand why the following is necessary, but, without it,
             when objects are changed so that they change from satisfying the
             filter predicate to not satisfying the filter predicated, or vice
             versa, even though this code runs, the following two invocations
             or -arrangedObjects, and the results in the Find Table, which is
             bound to -arrangedObjects, still show the old results.  I would
             think that, at least, the direct invocations of -arrangedObjects
             should cause -rearrangeObjects to run internally, and that, maybe
             not so confidently, Cocoa Bindings would cause the same because of
             the table binding.  But, apparently not! */
            [self.findArrayController rearrangeObjects] ;
            
            // Construct the footer text
            Starker* starker = [[[self windowController] document] starker] ;
            NSArray* allStarks = [starker allNonRootStarks] ;
            NSString* foundResultsStr = [[NSString alloc] initWithFormat:
                                         @"%@\n%@",
                                         NSLocalizedString(@"Found:", nil),
                                         [NSString stringWithFormat:
                                          @"%ld/%ld",
                                          (long)[[self.findArrayController arrangedObjects] count],
                                          (long)[allStarks count]]] ;
            [findProgressText setStringValue:foundResultsStr] ;
            [foundResultsStr release] ;
            
            NSInteger count = [[self.findArrayController arrangedObjects] count] ;
            
            // Restore the old scroll position
            NSInteger max = count - 1 ;
            [findTableView scrollRowToVisible:MAX(MIN(firstVisibleRow, max), 0)] ;
            [findTableView scrollRowToVisible:MAX(MIN((lastVisibleRow - 1), max),0)] ;
            // Note: In the above, I don't understand why we need the - 1.
            // But without it, the old top visible row gets scrolled out of view.
            
            // Restore the old selection
            NSIndexSet* survivingSelectionIndexSet = [[self.findArrayController arrangedObjects] indexesOfObjectsPassingTest:^BOOL(
                                                                                                                              id _Nonnull object,
                                                                                                                              NSUInteger index,
                                                                                                                              BOOL* _Nonnull stop) {
                if (!oldSelection) {
                    return NO ;
                }
                if ([oldSelection indexOfObject:object] == NSNotFound) {
                    return NO ;
                }
                return YES ;
            }] ;
            
            NSIndexSet* newSelectionIndexes ;
            if ([survivingSelectionIndexSet count] > 0) {
                newSelectionIndexes = survivingSelectionIndexSet ;
            }
            else if ([selectionIndexes count] > 0) {
                /* All selected items have been deleted.  Select the one, next item.
                 This is what the Edit Bookmarks window in Safari and other Apple apps
                 do. */
                newSelectionIndexes = [selectionIndexes indexesInRange:NSMakeRange(0, count)] ;
                // except act
                if ([newSelectionIndexes count] > 0) {
                    newSelectionIndexes = [NSIndexSet indexSetWithIndex:[newSelectionIndexes firstIndex]] ;
                }
            }
            else {
                /* There was no selection. */
                newSelectionIndexes = [NSIndexSet indexSet] ;
            }
            
            [self.findArrayController setSelectionIndexes:newSelectionIndexes] ;
        }
    }
    
    [self displayError:error] ;
}

- (void)reveal {
	[[self windowController] revealTabViewIdentifier:constIdentifierTabViewFindReplace] ;
}

- (NSString*)stringByReplacingInString:(NSString*)string {
    NSMutableString* copy = [string mutableCopy] ;
    [copy replaceOccurrencesOfString:predicateEditor.stringToBeReplaced
                          withString:replaceValueField.stringValue
                             options:0
                               range:NSMakeRange(0, string.length)] ;
    
    NSString* answer = [copy copy] ;
    [copy release] ;
    [answer autorelease] ;
    return answer ;
}

- (IBAction)find:(id)sender {
    [predicateEditor sendAction:predicateEditor.action
                             to:predicateEditor.target] ;
}

- (BOOL)canReplace {
    BOOL answer ;
    if (self.replaceInSelectedNotAll) {
        answer = self.findArrayController.hasSelection ;
    }
    else {
        answer = self.findArrayController.countOfArrangedObjects > 0 ;
    }

    
    return answer ;
}

+ (NSSet*)keyPathsForValuesAffectingCanReplace {
    return [NSSet setWithObjects:
            @"replaceInSelectedNotAll",
            /* The following two have no effect, I presume because of Apple Bug
             7827354, which is closed as a duplicate of 3404770. */
            @"self.findArrayController.hasSelection",
            @"self.findArrayController.countOfArrangedObjects",
            /* The following is a workaround for Apple Bug 7827354. */
            @"appleBug7827354Workaround",
            nil] ;
}

- (IBAction)replace:(id)sender {
    NSArray* starks ;
    if (self.replaceInSelectedNotAll) {
        starks = self.findArrayController.selectedObjects ;
    }
    else {
        starks = self.findArrayController.arrangedObjects ;
    }

    NSError* error = nil ;
    for (Stark* stark in starks) {
        if ([predicateEditor.replaceAttributeKey isEqualToString:constKeyTagsString]) {
            NSMutableArray* tags = [[NSMutableArray alloc] init] ;
            for (NSString* tag in stark.tags) {
                NSString* newTag = [self stringByReplacingInString:tag] ;
                [tags addObject:newTag] ;
            }
            NSArray* tagsCopy = [tags copy] ;
            stark.tags = tagsCopy ;
            [tags release] ;
            [tagsCopy release] ;
        }
        else {
            NSString* oldString = [stark valueForKey:predicateEditor.replaceAttributeKey] ;
            if (predicateEditor.replaceIsRegex) {
                NSString* pattern = predicateEditor.stringToBeReplaced ;
                NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                                       options:0
                                                                                         error:&error] ;
                /* Documentation does not specify that the above will return
                 nil in the event of an error, so we look for the error first.
                 */
                if (error) {
                    break ;
                }
                
                NSMutableString* mutant = [oldString mutableCopy] ;
                [regex replaceMatchesInString:mutant
                                      options:0
                                        range:NSMakeRange(0, mutant.length)
                                 withTemplate:replaceValueField.stringValue] ;
                NSString* mutatedString = [mutant copy];
                [mutant release];
                [stark setValue:mutatedString
                         forKey:predicateEditor.replaceAttributeKey] ;
                [mutatedString release] ;
            }
            else {
                NSString* newString = [self stringByReplacingInString:oldString] ;
                [stark setValue:newString
                         forKey:predicateEditor.replaceAttributeKey] ;
            }
        }
    }
    
    [self displayError:error] ;
}

- (IBAction)findStarksThatAreDontVerify:(id)sender {
	[self reveal] ;
	
    NSExpression* lhs;
    NSExpression* rhs;
    NSPredicateOperatorType operatorType;

    lhs = [NSExpression expressionForKeyPath:constKeyDontVerify];
    rhs = [NSExpression expressionForConstantValue:@YES];
    operatorType = NSEqualToPredicateOperatorType;
    
    NSPredicate* pred = [NSComparisonPredicate predicateWithLeftExpression:lhs
                                                           rightExpression:rhs
                                                                  modifier:NSDirectPredicateModifier
                                                                      type:operatorType
                                                                   options:0] ;

    [predicateEditor changeRowCountTo:1];
    predicateEditor.objectValue = pred;

    StarkTableColumn* tableColumn ;
	
	tableColumn = (StarkTableColumn*)[[self findTableView] tableColumnWithIdentifier:@"userDefinedF0"] ;
	[tableColumn setUserDefinedAttribute:constKeyUrlOrStats] ;
	[tableColumn sizeToFit] ;
	
	tableColumn = (StarkTableColumn*)[[self findTableView] tableColumnWithIdentifier:@"userDefinedF1"] ;
	[tableColumn setUserDefinedAttribute:constKeyDontVerify] ;
	[tableColumn sizeToFit] ;
}

- (IBAction)findStarksThatAreBroken:(id)sender {
	[self reveal] ;

    NSExpression* lhs;
    NSExpression* rhs;
    NSPredicateOperatorType operatorType;

    lhs = [NSExpression expressionForKeyPath:constKeyVerifierDisposition];
    rhs = [NSExpression expressionForConstantValue:@(BkmxFixDispoLeaveBroken)];
    operatorType = NSEqualToPredicateOperatorType;
    
    NSPredicate* pred = [NSComparisonPredicate predicateWithLeftExpression:lhs
                                                           rightExpression:rhs
                                                                  modifier:NSDirectPredicateModifier
                                                                      type:operatorType
                                                                   options:0] ;
    
    [predicateEditor changeRowCountTo:1];
    predicateEditor.objectValue = pred;
	
	StarkTableColumn* tableColumn ;
	
	tableColumn = (StarkTableColumn*)[[self findTableView] tableColumnWithIdentifier:@"userDefinedF0"] ;
	[tableColumn setUserDefinedAttribute:constKeyVerifierLastResult] ;
	[tableColumn sizeToFit] ;
	
	tableColumn = (StarkTableColumn*)[[self findTableView] tableColumnWithIdentifier:@"userDefinedF1"] ;
	[tableColumn setUserDefinedAttribute:constKeyDontVerify] ;
	[tableColumn sizeToFit] ;

    [(BkmxAppDel*)[NSApp delegate] doShowInspector:YES] ;
	[(BkmxAppDel*)[NSApp delegate] inspectorShowUrls] ;
}

- (IBAction)findStarksThatAreUpdatedOrSecured:(id)sender {
	[self reveal] ;

    NSExpression* lhs;
    NSExpression* rhs;
    NSPredicateOperatorType operatorType;
    NSMutableArray* subpreds = [NSMutableArray new];

    lhs = [NSExpression expressionForKeyPath:constKeyVerifierDisposition];
    rhs = [NSExpression expressionForConstantValue:@(BkmxFixDispoDoUpdate)];
    operatorType = NSEqualToPredicateOperatorType;
    [subpreds addObject:[NSComparisonPredicate predicateWithLeftExpression:lhs
                                                           rightExpression:rhs
                                                                  modifier:NSDirectPredicateModifier
                                                                      type:operatorType
                                                                   options:0]];
    rhs = [NSExpression expressionForConstantValue:@(BkmxFixDispoDoUpgradeInsecure)];
    [subpreds addObject:[NSComparisonPredicate predicateWithLeftExpression:lhs
                                                           rightExpression:rhs
                                                                  modifier:NSDirectPredicateModifier
                                                                      type:operatorType
                                                                   options:0]];
    NSPredicate* pred = [NSCompoundPredicate orPredicateWithSubpredicates:[[subpreds copy] autorelease]];

    [subpreds release];
    [predicateEditor changeRowCountTo:3] ;
    predicateEditor.objectValue = pred;

    StarkTableColumn* tableColumn ;
	
	tableColumn = (StarkTableColumn*)[[self findTableView] tableColumnWithIdentifier:@"userDefinedF0"] ;
	[tableColumn setUserDefinedAttribute:constKeyUrlOrStats] ;
	[tableColumn sizeToFit] ;
	
	tableColumn = (StarkTableColumn*)[[self findTableView] tableColumnWithIdentifier:@"userDefinedF1"] ;
	[tableColumn setUserDefinedAttribute:constKeyVerifierPriorUrl] ;
	[tableColumn sizeToFit] ;
	
    [(BkmxAppDel*)[NSApp delegate] doShowInspector:YES] ;
	[(BkmxAppDel*)[NSApp delegate] inspectorShowUrls] ;
}

/* The very complicated predicate built in this method is a reimplementation
 of the three conditions in -[VerifySummary summarizeIntoSummary:] which
 increment nUnverifiable.  (Search for nUnverifiable++.)  I think that the logic
 regarding verify dispositions has not really been thought through properly,
 especially since I bolted on Upgrade Insecure Bookmarks.  But, it works! */
- (IBAction)findStarksThatAreUnknown:(id)sender {
    [self reveal] ;
    
    NSExpression* lhs;
    NSExpression* rhs;
    NSPredicateOperatorType operatorType;
    NSMutableArray* subpreds = [NSMutableArray new];

    lhs = [NSExpression expressionForKeyPath:constKeyVerifierDisposition];
    rhs = [NSExpression expressionForConstantValue:@(BkmxFixDispoLeaveAsIs)];
    operatorType = NSEqualToPredicateOperatorType;
    [subpreds addObject:[NSComparisonPredicate predicateWithLeftExpression:lhs
                                                           rightExpression:rhs
                                                                  modifier:NSDirectPredicateModifier
                                                                      type:operatorType
                                                                   options:0]];
    lhs = [NSExpression expressionForKeyPath:constKeyVerifierCode];
    rhs = [NSExpression expressionForConstantValue:@200];
    operatorType = NSNotEqualToPredicateOperatorType;
    [subpreds addObject:[NSComparisonPredicate predicateWithLeftExpression:lhs
                                                           rightExpression:rhs
                                                                  modifier:NSDirectPredicateModifier
                                                                      type:operatorType
                                                                   options:0]];
    rhs = [NSExpression expressionForConstantValue:@301];
    [subpreds addObject:[NSComparisonPredicate predicateWithLeftExpression:lhs
                                                           rightExpression:rhs
                                                                  modifier:NSDirectPredicateModifier
                                                                      type:operatorType
                                                                   options:0]];
    rhs = [NSExpression expressionForConstantValue:@302];
    [subpreds addObject:[NSComparisonPredicate predicateWithLeftExpression:lhs
                                                           rightExpression:rhs
                                                                  modifier:NSDirectPredicateModifier
                                                                      type:operatorType
                                                                   options:0]];
    rhs = [NSExpression expressionForConstantValue:@404];
    [subpreds addObject:[NSComparisonPredicate predicateWithLeftExpression:lhs
                                                           rightExpression:rhs
                                                                  modifier:NSDirectPredicateModifier
                                                                      type:operatorType
                                                                   options:0]];
    rhs = [NSExpression expressionForConstantValue:@-1001];
    [subpreds addObject:[NSComparisonPredicate predicateWithLeftExpression:lhs
                                                           rightExpression:rhs
                                                                  modifier:NSDirectPredicateModifier
                                                                      type:operatorType
                                                                   options:0]];
    rhs = [NSExpression expressionForConstantValue:@-1003];
    [subpreds addObject:[NSComparisonPredicate predicateWithLeftExpression:lhs
                                                           rightExpression:rhs
                                                                  modifier:NSDirectPredicateModifier
                                                                      type:operatorType
                                                                   options:0]];
    rhs = [NSExpression expressionForConstantValue:@-1012];
    [subpreds addObject:[NSComparisonPredicate predicateWithLeftExpression:lhs
                                                           rightExpression:rhs
                                                                  modifier:NSDirectPredicateModifier
                                                                      type:operatorType
                                                                   options:0]];
    NSPredicate* pred = [NSCompoundPredicate andPredicateWithSubpredicates:[[subpreds copy] autorelease]];
    
    [subpreds removeAllObjects];
    [subpreds addObject:pred];
    lhs = [NSExpression expressionForKeyPath:constKeyVerifierCode];
    rhs = [NSExpression expressionForConstantValue:@-1002];
    operatorType = NSEqualToPredicateOperatorType;
    [subpreds addObject:[NSComparisonPredicate predicateWithLeftExpression:lhs
                                                           rightExpression:rhs
                                                                  modifier:NSDirectPredicateModifier
                                                                      type:operatorType
                                                                   options:0]];

    rhs = [NSExpression expressionForConstantValue:@0];
    [subpreds addObject:[NSComparisonPredicate predicateWithLeftExpression:lhs
                                                           rightExpression:rhs
                                                                  modifier:NSDirectPredicateModifier
                                                                      type:NSEqualToPredicateOperatorType
                                                                   options:0]];

    pred = [NSCompoundPredicate orPredicateWithSubpredicates:[[subpreds copy] autorelease]];
    [subpreds release];
    

    [predicateEditor changeRowCountTo:11];
    predicateEditor.objectValue = pred;
    
    StarkTableColumn* tableColumn ;
    
    tableColumn = (StarkTableColumn*)[[self findTableView] tableColumnWithIdentifier:@"userDefinedF0"] ;
    [tableColumn setUserDefinedAttribute:constKeyUrlOrStats] ;
    [tableColumn sizeToFit] ;
    
    tableColumn = (StarkTableColumn*)[[self findTableView] tableColumnWithIdentifier:@"userDefinedF1"] ;
    [tableColumn setUserDefinedAttribute:constKeyVerifierPriorUrl] ;
    [tableColumn sizeToFit] ;
    
    [(BkmxAppDel*)[NSApp delegate] doShowInspector:YES] ;
    [(BkmxAppDel*)[NSApp delegate] inspectorShowUrls] ;
}

// Most of the following implementation was ripped from:
// http://developer.apple.com/samplecode/PredicateEditorSample/listing5.html
	
// -------------------------------------------------------------------------------
//	predicateEditorChanged:sender
//
//  This method gets called whenever the predicate editor changes.
//	It is the action of our predicate editor and the single place for all our updates.
//	
//	We need to do potentially three things:
//		1) Fire off a search if the user hits enter.
//		2) Add some rows if the user deleted all of them, so the user isn't left without any rows.
//		3) Resize related views if the number of rows changed (the user hit + or -).
// -------------------------------------------------------------------------------
- (IBAction)changedPredicate:(id)sender {    

    // if the user deleted the first row, then add it again - no sense leaving the user with no rows
    if ([predicateEditor numberOfRows] == 0) {
		[predicateEditor addRow:self];
	}
    
    // resize the window vertically to accomodate our views:
        
    // get the new number of rows, which tells us the needed change in height,
	// note that we can't just get the view frame, because it's currently animating - this method is called before the animation is finished.
    NSInteger newRowCount = [predicateEditor numberOfRows];
    
	// if there's no change in row count, there's no need to resize anything
	if (newRowCount != [predicateEditor previousRowCount]) {
		// The autoresizing masks, by default, allows the NSTableView to grow and keeps the predicate editor fixed.
		// We need to temporarily grow the predicate editor, and keep the NSTableView fixed, so we have to change the autoresizing masks.
		// Save off the old ones; we'll restore them after changing the window frame.
		NSScrollView* tableScrollView = [findTableView enclosingScrollView];
		NSUInteger oldOutlineViewMask = [tableScrollView autoresizingMask];
		
		NSScrollView* predicateEditorScrollView = [predicateEditor enclosingScrollView];
		NSUInteger oldPredicateEditorViewMask = [predicateEditorScrollView autoresizingMask];
		
		[tableScrollView setAutoresizingMask:NSViewWidthSizable | NSViewMaxYMargin];
		[predicateEditorScrollView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
        
		// determine if we need to grow or shrink the window
		BOOL growing = (newRowCount > [predicateEditor previousRowCount]);
		
		// if growing, figure out by how much.  Sizes must contain nonnegative values, which is why we avoid negative floats here.
		CGFloat heightDifference = fabs([predicateEditor rowHeight] * (newRowCount - [predicateEditor previousRowCount]));
		
		// convert the size to window coordinates -
		// if we didn't do this, we would break under scale factors other than 1.
		// We don't care about the horizontal dimension, so leave that as 0.
		//
		NSSize sizeChange = [predicateEditor convertSize:NSMakeSize(0, heightDifference) toView:nil];
		
		// offset the middle view
		NSRect frame = [findMiddleView frame];
		[findMiddleView setFrameOrigin: NSMakePoint(frame.origin.x, frame.origin.y - [predicateEditor rowHeight] * (newRowCount - [predicateEditor previousRowCount]))];
		
		// Change the size of the table:
		// - if we're growing, the table height gets reduced.
		// - if we're shrinking, the height height gets increased.
		NSRect tableScrollFrame = [tableScrollView frame];
		tableScrollFrame.size.height += growing ? -sizeChange.height : +sizeChange.height;
		[tableScrollView setFrame:tableScrollFrame];
		
		// change the size of the predicate editor's enclosing scroll view:
		// - if we're growing, the height goes up and the origin goes down (corresponding to growing down).
		// - if we're shrinking, the height goes down and the origin goes up.
		NSRect predicateScrollFrame = [[predicateEditor enclosingScrollView] frame];
		predicateScrollFrame.size.height += growing ? sizeChange.height : -sizeChange.height;
		predicateScrollFrame.origin.y -= growing ? sizeChange.height : -sizeChange.height;
		[[predicateEditor enclosingScrollView] setFrame:predicateScrollFrame];
		
		// restore the autoresizing mask
		[tableScrollView setAutoresizingMask:oldOutlineViewMask];
		[predicateEditorScrollView setAutoresizingMask:oldPredicateEditorViewMask];
		
		[predicateEditor setPreviousRowCount:newRowCount] ;	// save our new row count
	}
	
	NSNotification* note = [NSNotification notificationWithName:constNoteBkmxFindResultsNeedRefresh
														 object:[self windowController]] ;
	[[NSNotificationQueue defaultQueue] enqueueNotification:note
											   postingStyle:NSPostWhenIdle] ;
}

@end
