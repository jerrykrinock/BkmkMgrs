#import <Bkmxwork/Bkmxwork-Swift.h>
#import "ReportsViewController.h"
#import "Stark.h"
#import "StarkEditor.h"
#import "SSYSizability.h"
#import "BkmxBasis+Strings.h"
#import "SSYTabView.h"
#import "FindViewController.h"
//#import "VerifySummary.h"
#import "BkmxDoc.h"
#import "NSString+LocalizeSSY.h"
#import "IxportLog.h"
#import "NSArray+SafeGetters.h"
#import "Starkoid.h"
#import "NSPredicate+SSYMore.h"
#import "NSError+MyDomain.h"
#import "NSString+SSYExtraUtils.h"
#import "NSArray+Stringing.h"
#import "NSNumber+SharypeCoarseDisplay.h"
#import "NSNumber+ChangeTypesSymbols.h"
#import "BkmxDocWinCon+Autosaving.h"
#import "NSObject+SuperUtils.h"
#import "DupesOutlineView.h"
#import "Dupetainer.h"
#import "SSYProgressView.h"
#import "FindTableView.h"
#import "NSFont+Height.h"
#import "StarkTableColumn.h"
#import "Macster.h"
#import "MAKVONotificationCenter.h"

@interface ReportsViewController ()

@end

@implementation ReportsViewController

#pragma mark Accessor Methods

- (SSYTabView*)reportsTabView {
    return reportsTabView ;
}

- (DupesOutlineView*)dupesOutlineView {
    return dupesOutlineView ;
}

- (FindViewController*)findViewController {
    return findViewController ;
}

#pragma mark Other Methods

- (BOOL)findTabIsSelected {
    return [[[reportsTabView selectedTabViewItem] identifier] isEqualToString:constIdentifierTabViewFindReplace] ;
}

- (SSYSizability)sizabilityForTabViewItem:(NSTabViewItem*)tabViewItem {
    SSYSizability sizability ;
    
	if (tabViewItem == tabFind) {
		sizability = SSYSizabilityUserSizable ;
	}
	else if (tabViewItem == tabDupes) {
		sizability = SSYSizabilityUserSizable ;
	}
	else if (tabViewItem == tabVerify) {
		sizability = SSYSizabilityFixed ;
	}
	else if (tabViewItem == tabLogs) {
		sizability = SSYSizabilityUserSizable ;
	}
    else {
        sizability = SSYSizabilityUnknown ;
    }
    
    return sizability ;
}

- (NSString*)nameOfTabDisallowedInViewingModeForTabViewItem:(NSTabViewItem*)tabViewItem {
    NSString* tabName = nil ;
    if (tabViewItem == tabLogs) {
        tabName = [[BkmxBasis sharedBasis] labelSyncLog] ;
    }
    return tabName ;
}

- (void)changeToSubtabAllowedInViewingMode {
    NSInteger selectedIndex = [reportsTabView selectedTabIndex] ;
    // Disallow Sync Logs (index 3)
    NSIndexSet* disallowedIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(3,1)] ;
    if ([disallowedIndexes containsIndex:selectedIndex]) {
        [reportsTabView selectTabViewItem:tabFind] ;
    }
}

- (BOOL)        rawTabView:(NSTabView*)tabView
   shouldSelectTabViewItem:(NSTabViewItem*)tabViewItem {
    return YES ;
}

- (NSArray*)selectedObjects {
    return [[findViewController findArrayController] selectedObjects] ;
}

// It would probably make more sense if I moved this into DupesOutlineView,
// renamed it -selectedStarks and implemented similar methods in ContentOutlineView
// and FindTableView (which would be a new subclass), and then used this
// -selectedStarks instead of -selectedObjects to access starks.
- (NSArray*)selectedDupeStarks {
	NSIndexSet* selectedStarkIndexes = [dupesOutlineView selectedRowIndexes] ;
	NSMutableArray* starks = [[NSMutableArray alloc] init] ;
	NSUInteger i = [selectedStarkIndexes firstIndex] ;
	while ((i != NSNotFound)) {
		id object = [dupesOutlineView itemAtRow:i] ;
		if ([object isKindOfClass:[Stark class]]) {
			[starks addObject:object] ;
		}
		i = [selectedStarkIndexes indexGreaterThanIndex:i] ;
	}
	
	NSArray* answer = [starks copy] ;
	[starks release] ;
	
	return [answer autorelease] ;
}

- (IBAction)deleteSelectedDupeStarks:(id)sender {
	NSArray* selectedStarks_ = [self selectedDupeStarks] ;
	if ([selectedStarks_ count] > 0) {
		// We cannot just -[moc deleteObject:stark]
		// because we also need to adjust indexes of siblings
		// and make sure that child items are not removed twice
		// if user has selected chlid and parent.
		// This method does that for us:
		[StarkEditor parentingAction:BkmxParentingRemove
							   items:selectedStarks_
						   newParent:nil
							newIndex:0
						revealDestin:YES] ;
		// Prior to BookMacster 1.11.4, parentingAction was passed
		// as BkmxParentingMove, which was incorrect, but worked
		// until BookMacster 1.11 when the above method was optimized.
	}
	else {
		NSBeep() ;
	}
}

- (IBAction)allowSelectedDupeStarks:(id)sender {
	NSArray* selectedStarks_ = [self selectedDupeStarks] ;
	if ([selectedStarks_ count] > 0) {
		for (Stark* stark in selectedStarks_) {
			[stark setIsAllowedDupe:[NSNumber numberWithBool:YES]] ;
		}
	}
	else {
		NSBeep() ;
	}
}

- (BOOL)hasDupeStarkSelection {
	return ([[self selectedDupeStarks] count] > 0) ;
}

- (void)selectNewestIxportLog {
	// Since we sort them descending by serial number, the newest is first.
	[ixportDiariesArrayController selectFirstArrangedObject] ;
}

- (void)updateIxportDiariesTable {
	IxportLog* selectedIxportLog = [[ixportDiariesArrayController selectedObjects] firstObjectSafely] ;
	NSSet* starkoidsSet = [selectedIxportLog starkoids] ;
	[starkoidsArrayController setContent:starkoidsSet] ;
    
	NSMutableSet* changeTypes = [[NSMutableSet alloc] init] ;
	if([showAdditionsSwitch state] == NSControlStateValueOn) {
		[changeTypes addObject:[NSNumber numberWithInteger:SSYModelChangeActionInsert]] ;
	}
	if([showUpdatesSwitch state] == NSControlStateValueOn) {
		[changeTypes addObject:[NSNumber numberWithInteger:SSYModelChangeActionMosh]] ;
		[changeTypes addObject:[NSNumber numberWithInteger:SSYModelChangeActionSlosh]] ;
		[changeTypes addObject:[NSNumber numberWithInteger:SSYModelChangeActionModify]] ;
	}
	if([showSlidesSwitch state] == NSControlStateValueOn) {
		[changeTypes addObject:[NSNumber numberWithInteger:SSYModelChangeActionSlosh]] ;
		[changeTypes addObject:[NSNumber numberWithInteger:SSYModelChangeActionSlide]] ;
	}
	if([showMovesSwitch state] == NSControlStateValueOn) {
		[changeTypes addObject:[NSNumber numberWithInteger:SSYModelChangeActionMosh]] ;
		[changeTypes addObject:[NSNumber numberWithInteger:SSYModelChangeActionMove]] ;
	}
	if([showDeletionsSwitch state] == NSControlStateValueOn) {
		[changeTypes addObject:[NSNumber numberWithInteger:SSYModelChangeActionRemove]] ;
	}
    
	NSPredicate* predicate = [NSPredicate orPredicateWithKeyPath:constKeyChangeType
														  values:changeTypes] ;
	[changeTypes release] ;
	[starkoidsArrayController setFilterPredicate:predicate] ;
	
	// Make sure the table view re-adjusts the row heights.
	NSIndexSet* allRows = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [starkoidsTableView numberOfRows])] ;
	[starkoidsTableView noteHeightOfRowsWithIndexesChanged:allRows] ;
}

- (void)updateIxportDiariesTableForObject:(id)object {
    if (object == ixportDiariesArrayController) {
        [self updateIxportDiariesTable] ;
    }
}

- (IBAction)updateIxportDiariesTable:(id)sender {
	[self updateIxportDiariesTable] ;
}

- (IBAction)writeLogToFile:(id)sender {
	NSError* error = nil ;
	NSString* path = [self writeLogToPath:nil
									 back:0
								  doStamp:YES
								  error_p:&error] ;
	
	if (path) {
		NSString* msg = [NSString stringWithFormat:
						 @"%@\n\n%@",
						 [NSString localize:@"fileWrotePath"],
						 path] ;
		SSYAlert* alert = [SSYAlert alert] ;
		[alert setSmallText:msg] ;
		// Enough room so the file path should fit on one line, unless someone's
		// Mac account short name is really long.
		[alert setRightColumnWidth:500] ;
        [[[self windowController]  document] runModalSheetAlert:alert
                                                     resizeable:NO
                                                      iconStyle:SSYAlertIconInformational
                                                  modalDelegate:nil
                                                 didEndSelector:NULL
                                                    contextInfo:NULL] ;
	}
	else {
		[(BkmxDoc*)[[self windowController]  document] alertError:error] ;
	}
}

- (NSString*)writeLogToPath:(NSString*)path
					   back:(NSInteger)back
					doStamp:(BOOL)doStamp
					error_p:(NSError**)error_p {
	BOOL ok = YES ;
	NSError* error = nil ;
	NSMutableString* log = nil ;
	
	NSInteger index ;
	if (back > 0) {
		index = back ;
	}
	else {
		index = [[ixportDiariesArrayController selectionIndexes] firstIndex] ;
		if (index == NSNotFound) {
			ok = NO ;
			error = SSYMakeError(921380, @"No log selected") ;
			goto end ;
		}
	}
	
	IxportLog* selectedIxportLog = [[ixportDiariesArrayController arrangedObjects] objectAtIndex:index] ;
	if (!selectedIxportLog) {
		ok = NO ;
		error = SSYMakeError(921381, @"Could not make log text") ;
		goto end ;
	}
	
	if (!path) {
		// Create filename
		NSMutableString* formattedDate = [[selectedIxportLog formattedDate] mutableCopy] ;
		// Slashes, as in yy/mm/dd, are not allowed in Mac filenames
		[formattedDate replaceOccurrencesOfString:@"/"
									   withString:@"-"] ;
		// Colons, as in 18:52:02, would be changed to slashes.  We'd
		// rather have 185202, as in Time Machine volumes.
		[formattedDate replaceOccurrencesOfString:@":"
									   withString:@""] ;
		// And I don't like spaces either
		[formattedDate replaceOccurrencesOfString:@" "
									   withString:@"-"] ;
		NSString* logFilename = [NSString stringWithFormat:
								 @"%@-Log#%04ld@%@.txt",
								 [[BkmxBasis sharedBasis] appNameLocalized],
								 (long)[[selectedIxportLog serialNumber] integerValue],
								 formattedDate] ;
		[formattedDate release] ;
		
		// Create file path
		path = [NSHomeDirectory() stringByAppendingPathComponent:@"Desktop"] ;
		path = [path stringByAppendingPathComponent:logFilename] ;
	}
	
	NSMutableArray* changeTypes = [NSMutableArray array] ;
	if([showAdditionsSwitch state] == NSControlStateValueOn) {
		[changeTypes addObject:[[BkmxBasis sharedBasis] labelAdditions]] ;
	}
	if([showUpdatesSwitch state] == NSControlStateValueOn) {
		[changeTypes addObject:[[BkmxBasis sharedBasis] labelUpdates]] ;
	}
	if([showMovesSwitch state] == NSControlStateValueOn) {
		[changeTypes addObject:[[BkmxBasis sharedBasis] labelMoves]] ;
	}
	if([showSlidesSwitch state] == NSControlStateValueOn) {
		[changeTypes addObject:[[BkmxBasis sharedBasis] labelSlides]] ;
	}
	if([showDeletionsSwitch state] == NSControlStateValueOn) {
		[changeTypes addObject:[[BkmxBasis sharedBasis] labelDeletions]] ;
	}
	NSString* filterDescription = [changeTypes listValuesForKey:nil
													conjunction:[NSString localize:@"filterRuleAnd"]
													 truncateTo:0] ;
	
	NSString* title = [selectedIxportLog title] ;
	if (!doStamp) {
		NSScanner* scanner = [[NSScanner alloc] initWithString:title] ;
		[scanner scanUpToString:@"("
					 intoString:NULL] ;
		NSInteger startCharacterOmittingSerialNumberAndTimestamp = [scanner scanLocation] ;
		[scanner release] ;
		title = [title substringFromIndex:startCharacterOmittingSerialNumberAndTimestamp] ;
	}
	log = [[NSMutableString alloc] initWithString:title] ;
	[log appendFormat:@"\n\n*** Showing %@ ***\n\n", filterDescription] ;
	
	NSArray* starkoids = [starkoidsArrayController arrangedObjects] ;
	for (Starkoid* starkoid in starkoids) {
		NSMutableString* endThing = [[starkoid lineageAndUpdates] mutableCopy] ;
		[endThing replaceOccurrencesOfString:@"\n"
								  withString:@"\n\t\t"] ;
		[log appendFormat:@"%@\t%@\t%@\n",
		 [[starkoid sharypeCoarse] sharypeCoarseDisplayName],
		 [[starkoid changeType] changeTypeDisplaySymbol],
		 endThing] ;
		[endThing release] ;
	}
	
	ok = [log writeToFile:path
			   atomically:NO
				 encoding:NSUTF8StringEncoding
					error:&error] ;
	
end:
	if (!error && error_p) {
		*error_p = error ;
	}
	
	[log release] ;
	
	return (ok ? path : nil) ;
}

- (BOOL)disallowInVersionsBrowserTabViewItem:(NSTabViewItem*)tabViewItem {
    return (
            (tabViewItem == tabLogs)
            ) ;
}

- (IBAction)cleanDefunctDiaryEntries:(id)sender {
    [[[self windowController] document] cleanDefunctDiaryEntries] ;
}

#pragma mark NSTableViewDelegate Protocol Methods

- (NSIndexSet*)           outlineView:(NSOutlineView*)outlineView
 selectionIndexesForProposedSelection:(NSIndexSet*)proposedSelectionIndexes {
    NSMutableIndexSet* newIndexSet = [NSMutableIndexSet indexSet] ;
    NSUInteger i = [proposedSelectionIndexes firstIndex] ;
    while ((i != NSNotFound)) {
        // Allow only starks to be selected, not dupes
        id proposedSelectionItem = [outlineView itemAtRow:i] ;
        if ([proposedSelectionItem isKindOfClass:[Stark class]]) {
            [newIndexSet addIndex:i] ;
        }
        
        i = [proposedSelectionIndexes indexGreaterThanIndex:i] ;
    }
    
	return newIndexSet ;
}
#pragma mark Infrastructure

- (void)mikeAshObserveValueForKeyPath:(NSString*)keyPath
							 ofObject:(id)object
							   change:(NSDictionary*)change
							 userInfo:(id)userInfo {
    if ([keyPath isEqualToString:@"selectionIndex"]) {
        [self updateIxportDiariesTableForObject:object] ;
    }
}

- (void)tearDown {
   // Messaging table views' delegates and data sources after they are
    // gone causes indeterminate crashes.
    [dupesOutlineView setDelegate:nil] ;
    [dupesOutlineView setDataSource:nil] ;
    
    // Needed to remove observing @"selectionIndex" of ixportDiariesArrayController
    [[MAKVONotificationCenter defaultCenter] removeObserver:self] ;

    // Must unbind the things that we bound, bad things from happening as the window closes.
	// The table columns have been seen to get Core Data Console Burps like this:
	// "The NSManagedObject with ID:0x16f7f2f0 <x-coredata://A_UUID/Stark_entity/p20> has been invalidated."
    [(StarkTableColumn*)[[findViewController findTableView] tableColumnWithIdentifier:@"userDefinedF0"] unbindValue]  ;
	[(StarkTableColumn*)[[findViewController findTableView] tableColumnWithIdentifier:@"userDefinedF1"] unbindValue]  ;
	[starkoidsArrayController unbind:@"contentSet"] ;
 	[dupesStatus unbind:constKeyStaticConfigInfo] ;
	[switchReportsTab unbind:@"selectedIndex"] ;
	[reportsTabView unbind:@"selectedTabIndex"] ;

    [super tearDown] ;
}

- (void)reload {
	[dupesOutlineView reloadData] ;
	[[findViewController findTableView] reloadData] ;
	[starkoidsTableView setRowHeight:[[(BkmxAppDel*)[NSApp delegate] fontTable] tableRowHeight]] ;
	[starkoidsTableView reloadData] ;
}

- (void)updateWindow {
	[self reload] ;
	
	NSNotification* note = [NSNotification notificationWithName:constNoteBkmxFindResultsNeedRefresh
														 object:[self windowController] ] ;
	[[NSNotificationQueue defaultQueue] enqueueNotification:note
                                               postingStyle:NSPostWhenIdle] ;
	
	
	// The following only takes 6 milliseconds for my 1200 bookmarks
	// Intel Core 2 Duo Early 2006 Mac Mini
	[[[self windowController]  document] refreshVerifySummary] ;
}

- (void)autosaveAllCurrentValues {
	[[self windowController]  autosaveTableColumnsInTableView:dupesOutlineView] ;
	[[self windowController]  autosaveTableColumnsInTableView:[findViewController findTableView]] ;
	[[self windowController]  autosaveSelectedTabViewItem:[reportsTabView selectedTabViewItem]
							inTabView:reportsTabView] ;
}

- (void)awakeFromNib {
    if ([self awakened]) {
        return ;
    }
    [self setAwakened:YES] ;
    
	// Safely invoke super
	[self safelySendSuperSelector:_cmd
                   prettyFunction:__PRETTY_FUNCTION__
						arguments:nil] ;
    
    [starkoidsArrayController setHeightControllingColumnIndex:2] ;
	
	[starkoidsArrayController bind:@"tableFontSize"
						  toObject:[NSUserDefaults standardUserDefaults]
					   withKeyPath:constKeyTableFontSize
						   options:nil] ;
	
	// Bind "Reports" Tab View to its Segmented Control
	// Bind so that changes will propagate from toolbarItemReports to switchReportsTab
	[switchReportsTab bind:@"selectedIndex"
                  toObject:reportsTabView
               withKeyPath:@"selectedTabIndex"
                   options:0] ;
	// Bind so that changes will propagate from switchReportsTab to toolbarItemReports
	[reportsTabView bind:@"selectedTabIndex"
                toObject:switchReportsTab
             withKeyPath:@"selectedSegment"
                 options:0] ;
	
	[switchReportsTab setLabel:[[BkmxBasis sharedBasis] labelFindReplace]
					forSegment:0] ;
	[switchReportsTab setLabel:[[BkmxBasis sharedBasis] labelDuplicates]
					forSegment:1] ;
	[switchReportsTab setLabel:[[BkmxBasis sharedBasis] labelVerify]
					forSegment:2] ;
	[switchReportsTab setLabel:[[BkmxBasis sharedBasis] labelDiaries]
					forSegment:3] ;
	
	[dupesOutlineView setDataSource:[[[self windowController]  document] dupetainer]] ;
    [dupesOutlineView setDelegate:self] ;
    
	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:constKeySerialNumber
																   ascending:NO
																	selector:@selector(compare:)] ;
	NSArray* sortDescriptors = [NSArray arrayWithObject:sortDescriptor] ;
	[sortDescriptor release] ;
	[ixportDiariesArrayController setSortDescriptors:sortDescriptors] ;
    
	// Starting in BookMacster 1.6.2, we sort starkoids with three sort descriptors
	// to improve determinism in the Ixport Logs, for automated regression testing
	NSMutableArray* sort3Descriptors = [[NSMutableArray alloc] initWithCapacity:4] ;
	sortDescriptor = [[NSSortDescriptor alloc] initWithKey:constKeyLineage
												 ascending:YES
												  selector:@selector(localizedCaseInsensitiveCompare:)] ;
	[sort3Descriptors addObject:sortDescriptor] ;
	[sortDescriptor release] ;
	sortDescriptor = [[NSSortDescriptor alloc] initWithKey:constKeyChangeType
												 ascending:YES
												  selector:@selector(compare:)] ;
	[sort3Descriptors addObject:sortDescriptor] ;
	[sortDescriptor release] ;
	sortDescriptor = [[NSSortDescriptor alloc] initWithKey:constKeyFromDisplayName
												 ascending:YES
												  selector:@selector(localizedCaseInsensitiveCompare:)] ;
	[sort3Descriptors addObject:sortDescriptor] ;
	[sortDescriptor release] ;
	[starkoidsArrayController setSortDescriptors:sort3Descriptors] ;
	[sort3Descriptors release] ;
	[self updateIxportDiariesTable] ;

    [[NSNotificationCenter defaultCenter] addObserver:[self windowController] 
											 selector:@selector(handleChangedSelectionNotification:)
												 name:NSOutlineViewSelectionDidChangeNotification
											   object:dupesOutlineView] ;
	
	[[NSNotificationCenter defaultCenter] addObserver:[self windowController] 
											 selector:@selector(handleChangedSelectionNotification:)
												 name:NSTableViewSelectionDidChangeNotification
											   object:[findViewController findTableView]] ;
	
	[[NSNotificationCenter defaultCenter] addObserver:[self windowController] 
											 selector:@selector(tabViewChangedNote:)
												 name:SSYTabViewDidChangeItemNotification
											   object:reportsTabView] ;
	
	[ixportDiariesArrayController addObserver:self
								   forKeyPath:@"selectionIndex"
									 selector:@selector(mikeAshObserveValueForKeyPath:ofObject:change:userInfo:)
									 userInfo:nil
									  options:0] ;
	

	[dupesStatus bind:constKeyStaticConfigInfo
			 toObject:[[self windowController]  document]
		  withKeyPath:@"dupesStatusInfo"
			  options:nil] ;
    
    // Restore the Reports tab selection to autosaved value, if it works
    NSDictionary* autosaves = [[self windowController]  tabAutosaves] ;
    NSString* tabIdentifier = [autosaves objectForKey:constIdentifierTabViewReports] ;
    if (!tabIdentifier) {
        tabIdentifier = constIdentifierTabViewFindReplace ;
    }
    [reportsTabView selectTabViewItemWithIdentifier:tabIdentifier] ;
        
    // Now that we've got the autosaves (window size, tab selection, split view
	// sizes, user-defined columns, and columns widths) we can safely populate
	// the views with data and not have to worry about, for example,
	// sending -sizeToFit messages to subviews that will later be resized.
	[self updateWindow] ;
	// Note that we do not do the following in the table view's -awakeFromNib
	// because we would need to access [[tableView window] windowController]
	// in order to send -autosavedColumnStateForTableView, but if the
	// table view's tab is not initially showing, [tableView window] would be
	// nil.  We could use the -viewDidMoveToWindow trick, but then we'd need to
	// lock that out so it only happens once.  Doing it here ain't bad.
    NSDictionary* state = [[self windowController]  autosavedColumnStateForTableView:[findViewController findTableView]] ;
	[[findViewController findTableView] performSelector:@selector(restoreFromAutosaveState:)
                                             withObject:state
                                             afterDelay:0.0] ;
    
}

- (void)dealloc {
    // This is done elsewhere, but I added this here in BookMacster 1.12
    // because I think this might be the *correct* place to do it.
    [dupesOutlineView setDataSource:nil] ;
    
    [super dealloc] ;
}

@end
