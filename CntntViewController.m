#import "Bkmxwork/Bkmxwork-Swift.h"
#import "CntntViewController.h"
#import "Stark+Attributability.h"
#import "BkmxBasis+Strings.h"
#import "NSString+LocalizeSSY.h"
#import "NS(Attributed)String+Geometrics.h"
#import "BkmxDocWinCon+Autosaving.h"
#import "ContentOutlineView.h"
#import "ContentDataSource.h"
#import "NSView+Layout.h"
#import "SSYTokenField.h"
#import "Starker.h"
#import "BkmxSearchField.h"
#import "BkmxDoc+Autosaving.h"
#import "SSYSearchField.h"
#import "NSObject+SuperUtils.h"
#import "MAKVONotificationCenter.h"
#import "NSSplitView+Fraction.h"
#import "NSInvocation+Quick.h"
#import "StarkEditor.h"
#import "NSString+Clipboard.h"
#import "NSString+SSYExtraUtils.h"
#import "StarkTableColumn.h"
#import "SSMoveableToolTip.h"
#import "SSYLabelledTextField.h"
#import "MAKVONotificationCenter.h"
#import "NSUserDefaults+KeyPaths.h"
#import "GCUndoManager.h"
#import "SSYToolbarButton.h"
#import "SSYVectorImages.h"
#import "TagsPopoverViewController.h"
#import "SSYUUID.h"

@interface CntntViewController ()

@property (assign) BOOL isInFlatModeForSearch ;
@property (retain) ContentDataSource* contentDataSource ;

@end

@implementation CntntViewController

#pragma mark Accessor Methods

@synthesize contentDataSource = m_contentDataSource ;
@synthesize isInFlatModeForSearch = m_isInFlatModeForSearch ;

- (id)initWithCoder:(NSCoder*)aDecoder {
    self = [super initWithCoder:aDecoder] ;
    
    return self ;
}

- (BkmxDoc*)document {
    return [[self windowController]  document] ;
}

- (ContentOutlineView*)contentOutlineView {
    return contentOutlineView ;
}

- (NSSplitView*)splitView {
    return splitView ;
}

#pragma mark Other Methods

- (void)invalidateFlatCache {
    [[self contentDataSource] invalidateFlatCache] ;
}


- (void)deselectAll {
    [contentOutlineView deselectAll:self] ;
}

- (SSYSizability)sizabilityForTabViewItem:(NSTabViewItem*)tabViewItem {
    // Because the Content Tab has no subtabs, we
    return SSYSizabilityUnknown ;
    // We do not return the answer for the Content Tab itself, because we
    // don't have access to tabContent in this class.  That is handled
    // in -[BkmxDocWinCon sizabilityForTabViewItem:].
    // Yes, we are being somewhat overly pedantic here.
}

- (NSString*)nameOfTabDisallowedInViewingModeForTabViewItem:(NSTabViewItem*)tabViewItem {
    // All tabs are allowed in viewing mode
    return nil ;
}

- (void)changeToSubtabAllowedInViewingMode {
    // This method intentinally left blank
}

- (BOOL)        rawTabView:(NSTabView*)tabView
   shouldSelectTabViewItem:(NSTabViewItem*)tabViewItem {
    return YES ;
}

- (NSArray*)selectedStarks {
    return [contentOutlineView selectedStarks] ;
}

- (void)safelySelectFirstItem {
    if ([contentOutlineView numberOfRows] > 0) {
        NSIndexSet* firstRow = [NSIndexSet indexSetWithIndex:0] ;
        [contentOutlineView selectRowIndexes:firstRow
                        byExtendingSelection:NO] ;
    }
}

- (void)updateOutlineMode {
	BOOL outlineMode = [self outlineMode] ;
	
	NSArray* selectedStarks = [self selectedStarks] ;

    [contentOutlineView clearProxiesAndReload] ;  // Reloads outline view immediately, for safety, due to cleared proxies
    [self reloadIncludingData:YES
                       starks:nil] ;  // Reloads other subviewes in the Cntnt tab.

    /* Now that we've got the *actual* selected starks, we deselect them,
     because if we switch between outline mode and table mode, the same
     row index will be selected, which in general will be a different stark,
     and we don't want this to be restored by -reloadDataReally.  For the same
     reason, we do this with a delay, because the scrolling and selecting
     done by -reloadDateReally will scroll to and select the wrong items. */
    [contentOutlineView deselectAll:self] ;
    if ([selectedStarks count] > 0) {
        [contentOutlineView performSelector:@selector(showSelectAndExpandStarks:)
                                 withObject:selectedStarks
                                 afterDelay:CONTENT_OUTLINE_VIEW_RELOAD_DELAY_2] ;
	}
	else {
		[contentOutlineView realizeIsExpandedValuesFromModelFromRoot:nil] ;
	}
	
	if (outlineMode) {
		m_disclosureTriangleToolTip = [contentOutlineView addToolTipRect:NSMakeRect(0,0,35,100)
																  owner:[NSString localize:@"disclosureTriangle"]
															   userData:nil] ;
	}
	else {
		[contentOutlineView removeToolTip:m_disclosureTriangleToolTip] ;
	}
    
    [contentOutlineView setSortable:!outlineMode] ;
}

- (void)autosaveOutlineMode:(BOOL)mode {
	if (![[self windowController]  autosaveArmed]) {
		return ;
	}
	
	NSArray* keyPathArray = [[[self windowController]  document] autosaveKeyPathArrayWithLastKeys:constAutosaveOutlineMode] ;
	NSNumber* value = [NSNumber numberWithBool:mode] ;
	[[NSUserDefaults standardUserDefaults] setValue:value
									forKeyPathArray:keyPathArray] ;
}

- (BOOL)outlineMode {
	BOOL outlineMode ;
	@synchronized(self) {
		outlineMode = m_outlineMode ;
	}
	return outlineMode ;
}

- (void)setOutlineMode:(BOOL)outlineMode {
	@synchronized(self) {
		if (m_outlineMode != outlineMode) {
			// Propagate to instance variable
			m_outlineMode = outlineMode ;
			// Propagate to outline view
			[self updateOutlineMode] ;
			// Propagate to user defaults
			// Maybe the following 'if' is not necessary?
			if ([[self windowController]  autosaveArmed]) {
				[self autosaveOutlineMode:outlineMode] ;
			}
		}
	}
}

- (void)setBackToOutlineMode {
    if (![self outlineMode]) {
        if ([self isInFlatModeForSearch]) {
            [self setOutlineMode:YES] ;
            [self setIsInFlatModeForSearch:NO] ;
        }
    }
}

- (IBAction)setOutlineModeFromSegmentedControl:(NSSegmentedControl*)sender {
	NSInteger currentSegment = [sender selectedSegment] ;
	BOOL currentState = (currentSegment == 1) ;
	[self setOutlineMode:currentState] ;
}

- (IBAction)showTagsPopover:(id)sender {
    [tagsPopover showRelativeToRect:[sender bounds]
                             ofView:sender
                      preferredEdge:NSRectEdgeMinX] ;
}

- (void)updateDetailViewForStarks:(NSArray*)starks {
	NSString* string = nil ;
	NSColor* color = nil ;
	
    if ((starks == nil) || ([starks  count] == 0)) {
        string = [NSString localizeFormat:@"no%0", [NSString localize:@"selection"]] ;
        color = [NSColor disabledControlTextColor] ;
    }
    else {
        NSString* concensusValue = nil ;
        for (Stark* item in starks) {
            NSString* value = [item lineageLineDoSelf:NO
                                              doOwner:NO] ;
            // value will be at least a non-nil empty string (if no lineage)
            if (concensusValue == nil) {
                concensusValue = value ;
            }
            else if (![value isEqualToString:concensusValue]) {
                string = [[BkmxBasis sharedBasis] labelMultipleValues] ;
                color = [NSColor disabledControlTextColor] ;
                break ;
            }
        }
        
        if (!string) {
            // No conficts; all items had same value
            string = concensusValue ;
            color = [NSColor controlTextColor] ;
        }
    }
	
	if (string) {
        if (string.length == 0) {
            if (starks.count == 1) {
                string = NSLocalizedString(@"(Selected item is at root.)", nil) ;
            }
            else {
                string = NSLocalizedString(@"(Selected items are at root.)", nil) ;
            }
        }
		[textLineage setStringValue:string] ;
		
		// Tool Tip is overflowed string, or else regular tooltip
		NSSize size = [textLineage frame].size ;
		CGFloat requiredWidth = [string widthForHeight:size.height
												  font:[textLineage font]] ;
		NSString* toolTip = (requiredWidth > size.width) ? string : [[BkmxBasis sharedBasis] toolTipLineage] ;
		[textLineage setToolTip:toolTip] ;
	}
	if (color) {
		[textLineage setTextColor:color] ;
	}
}

- (void)autosaveContentSplitView:(NSSplitView*)splitView_ {
	if (![[self windowController]  autosaveArmed]) {
		return ;
	}
	
	NSArray* keyPathArray = [[[self windowController]  document] autosaveKeyPathArrayWithLastKeys:constAutosaveContentSplitView] ;
	if (keyPathArray) {
		NSString* string = [NSString stringWithFormat:@"%0.3f", [splitView_ fraction]] ;
		[[NSUserDefaults standardUserDefaults] setValue:string
										forKeyPathArray:keyPathArray] ;
	}
}

// This method is invoked indirectly by observeValueForKeyPath::::
// and also directly as the action of switchFilterLogic, wired in IB,
// and also directly as the action of the search field, wired in IB.
- (IBAction)search:(id)sender {
	if ([sender isKindOfClass:[NSToolbarItem class]]) {
		[switchFilterLogic setSelectedSegment:0] ;
	}
	
	NSString* newTargetString = nil ;
	NSNumber* newTargetDays = nil ;
    if ([sender isKindOfClass:[NSMenuItem class]]) {
        NSInteger tag = [(NSMenuItem*)sender tag] ;
        if ((tag & BKMX_SEARCH_FIELD_MENU_ITEM_TAG_LAST_TOUCHED) != 0) {
            NSInteger targetDays ;
            if ((tag & BKMX_SEARCH_FIELD_MENU_ITEM_TAG_LAST_DAY) != 0) {
                targetDays = 1 ;
            }
            else if ((tag & BKMX_SEARCH_FIELD_MENU_ITEM_TAG_LAST_WEEK) != 0) {
                targetDays = 7 ;
            }
            else if ((tag & BKMX_SEARCH_FIELD_MENU_ITEM_TAG_LAST_MONTH) != 0) {
                targetDays = 30 ;
            }
            else if ((tag & BKMX_SEARCH_FIELD_MENU_ITEM_TAG_LAST_QUARTER) != 0) {
                targetDays = 92 ;
            }
            else {
                targetDays = 0 ;
                NSLog(@"Internal Error 392-3953 %lx", (long)tag) ;
            }
            
            newTargetDays = [NSNumber numberWithInteger:targetDays] ;
            [[self windowController]  clearQuickSearch] ;
        }
        else {
            newTargetString = [[self windowController]  searchText] ;
        }
    }
    else {
        newTargetString = [[self windowController]  searchText] ;
    }
    
    [[[self windowController]  searchField] appendToRecentSearches:newTargetString] ;
    
    Stark* item ;
	
	// Send to System Find Pasteboard
	NSPasteboard *pasteboard = [NSPasteboard pasteboardWithName:NSPasteboardNameFind];
	[pasteboard declareTypes:[NSArray arrayWithObject:NSPasteboardTypeString] owner:nil];
	[pasteboard setString:newTargetString
                  forType:NSPasteboardTypeString];
    
	// Remember which proxies were selected
	NSArray* selectedProxies = [contentOutlineView selectedObjects] ;
	
	// Remember the visible items
    CGFloat extraPoints ;
	NSArray* visibleItems = [contentOutlineView visibleItemsAndExtraPoints_p:&extraPoints] ;
	
	// Deselect all objects in the controller
	[contentOutlineView deselectAll:nil] ;
	
	// Set the filter string in the dataSource
	ContentDataSource* dataSource = [self contentDataSource] ;
	[dataSource setFilterString:newTargetString] ;
    [dataSource setFilterDays:newTargetDays] ;
	NSSet* selectedTags = [NSSet setWithArray:[tagCloud selectedObjects]] ;
	[dataSource setFilterTags:selectedTags] ;
	[dataSource setFilterTagsLogic:[switchFilterLogic selectedSegment]] ;
    
	// By invalidating the cache, we cause a search and sort
	// to be done when we -reload, below
	[dataSource invalidateFlatCache] ;
	
    BOOL isActuallySearching = ([sender isKindOfClass:[SSYToolbarButton class]]) ;
    BOOL isActuallyFiltering = (sender == switchFilterLogic) ;

    if (
        (isActuallySearching && ([newTargetString length] == 0))
        // We are executing because the Quick Search field has been cleared.
        ||
        (isActuallyFiltering && ([switchFilterLogic selectedSegment] == 0))
        // We are executing because the Tags Filter has just been switched off.
         ) {
        // In either of these two cases, the user would probably appreciate
        // if we do this…
        [self setBackToOutlineMode] ;
    }
    else {
        // Make sure content is showing, and that its view is flat
        [[self windowController]  revealTabViewContent:self] ;
        if ([self outlineMode]) {
            [self setIsInFlatModeForSearch:YES] ;
            [self setOutlineMode:NO] ;
        }
    }
    
	// Reload
	[contentOutlineView clearProxiesAndReload] ;  // Reloads outline view immediately, for safety, due to cleared proxies
    [self reloadIncludingData:NO
                       starks:nil] ;  // Reloads outline view later, and also reloads other subviewes in the Cntnt tab.
	
	// Restore selection
	NSMutableIndexSet* selectionIndexes = [[NSMutableIndexSet alloc] init] ;
	for(item in selectedProxies) {
		NSInteger index = [contentOutlineView rowForItem:item] ;
		if (index != NSNotFound) {
			[selectionIndexes addIndex:index] ;
		}
	}
	[contentOutlineView selectRowIndexes:selectionIndexes
                    byExtendingSelection:NO] ;
	[selectionIndexes release] ;
	
	// Restore the scroll
	[contentOutlineView scrollToMakeVisibleItems:visibleItems
                                 plusExtraPoints:extraPoints] ;
}

+ (NSSet*)keyPathsForValuesAffectingSearchText {
	return [NSSet setWithObjects:
			@"tagCloud.selectedTokens",
			nil] ;
}

- (BOOL)switchFilterEnabled {
	return ([[tagCloud selectedTokens] count] > 0) ;
}

+ (NSSet*)keyPathsForValuesAffectingSwitchFilterEnabled {
	return [NSSet setWithObjects:
			@"tagCloud.selectedTokens",
			nil] ;
}

- (NSString*)switchFilterToolTip {
	if ([[tagCloud selectedTokens] count] > 0) {
		// Explain what the buttons do
		return 	[NSString localizeFormat:@"filterSwitchTTX4",
				 [NSString localize:@"070_tags_Pinboard"],
				 @"-",
				 @"\xe2\x9c\x93",
				 [NSString stringWithFormat:
				  @"%@%@",
				  @"\xe2\x9c\x93",
				  @"\xe2\x9c\x93"]] ;
	}
	else {
		// Disabled because no tags are selected
		return [NSString localizeFormat:@"tagsViewControlTip2%0",
				[NSString localize:@"070_tags_Pinboard"]] ;
	}
}

+ (NSSet*)keyPathsForValuesAffectingSwitchFilterToolTip {
	return [NSSet setWithObjects:
			@"tagCloud.selectedTokens",
			nil] ;
}

- (void)filterTagsForObject:(id)object {
    if (object == tagCloud) {
        if ([switchFilterLogic selectedSegment] > 0) {
            // The tag filter is switched on, and tag(s) have changed.
            // Re-search (which also switches outlineMode:OFF)
            [self search:switchFilterLogic] ;
        }
    }
}

- (void)showOrHideTagCloud {
#warning FIX showOrHideTagCloud
#if 0
    // Patch tag cloud in/out of keyboard loop
	Tagger* tagger = [[[self windowController]  document] tagger] ;
	NSSet* allTags = [tagger allTags] ;
	NSUInteger count = [allTags count] ;
    
	if (count > 0) {
		[switchDisplayFolders setNextKeyView:whatever] ;
	}
	else {
		[switchDisplayFolders setNextKeyView:contentOutlineView] ;
	}
#endif
}

- (IBAction)addNew:(id)sender {
	ContentOutlineView* ov = [self contentOutlineView] ;
	Sharype newSharype ;
	NSInteger selectedRow = [ov selectedRow] ; // row of last item selected, or -1 if no row selected
	Stark* selectedItem = nil ;
	if (selectedRow > -1) {
		selectedItem = [ov starkAtRow:selectedRow] ;
	}
	else {
		selectedItem = [[[[self windowController]  document] starker] root] ;
	}
	
	NSInteger tag = [(NSMenuItem*)sender tag] ;
	switch(tag) {
		case TAG_NEW_SOFT_FOLDER: // folder
			newSharype = SharypeSoftFolder ;
			break ;
		case TAG_NEW_BOOKMARK: // bookmark
		case TAG_NEW_BOOKMACSTERIZER: // bookmacsterizer
			newSharype = SharypeBookmark ;
			break ;
		case TAG_NEW_SEPARATOR: // separator
			newSharype = SharypeSeparator ;
			break ;
        default:
            newSharype = SharypeUndefined ;
	}
    
	// Create the new stark
	Stark* newItem ;
	if (tag == TAG_NEW_BOOKMACSTERIZER) {
		newItem = [[[[self windowController]  document] starker] freshBookMacsterizer] ;
	}
	else {
		newItem = [[[[self windowController]  document] starker] freshDatedStark] ;
		[newItem setSharypeValue:newSharype] ;
        NSString* url;
		
		if (tag == TAG_NEW_SEPARATOR) {
            [newItem separatorify];
		}
		else if (tag == TAG_NEW_BOOKMARK){
			// Set name
			[newItem setName:[NSString localize:@"untitled"]] ;
            
			// Set url
			url = @"https://" ;
			NSString* clipboard = [NSString clipboard] ;
			if ([clipboard isValidUrl]) {
				url = clipboard ;
			}
			[newItem setUrl:url] ;
		}
		else {
			// Soft folder
			[newItem setName:[NSString localize:@"untitled"]] ;
		}
	}
	
	NSArray* newItems = [NSArray arrayWithObject:newItem] ;
	
	// Fix the location if this BkmxDoc cannot accept this new item there
	StarkLocation* selectedLocation = [StarkLocation starkLocationWithParent:selectedItem
																	   index:0] ;
	StarkCanParent canInsert = [selectedLocation canInsertItems:newItems
                                                            fix:StarkLocationFixParentAndIndex
                                                    outlineView:contentOutlineView] ;
	if (canInsert > StarkCanParentNopeDemarcation) {
		// Invoke high-level method which moves them into the tree.
		[StarkEditor parentingAction:BkmxParentingAdd
							   items:newItems
						   newParent:[selectedLocation parent]
							newIndex:[selectedLocation index]
						revealDestin:YES] ;
		
		// Finally, select the item's name for editing by user
		if ((tag == TAG_NEW_SOFT_FOLDER) || (tag == TAG_NEW_BOOKMARK)) {
            ContentProxy* newProxy = [[contentOutlineView dataSource] proxyForStark:newItem] ;
			NSInteger iNewRow = [ov rowForItem:newProxy] ;
			// You must select the row first (above) before focusing for editing
			[ov selectRowIndexes:[NSIndexSet indexSetWithIndex:iNewRow] byExtendingSelection:NO] ;
			
			// For some reason, if I simply focus on the new item for editing now,
			// it edits for a few milliseconds, then goes back to normal.  Maybe it's
			// my undo manager ending the undo group?  Anyhow, I solved the problem
			// by doing it after an infinitesimal delay:
			BOOL yes = YES ;
			NSInvocation* invocation = [NSInvocation invocationWithTarget:ov
																 selector:@selector(editColumn:row:withEvent:select:)
														  retainArguments:YES
														argumentAddresses:NULL, &iNewRow, NULL, &yes] ;
			[invocation performSelector:@selector(invoke)
							 withObject:nil
							 afterDelay:0.0] ;
		}
	}
	else {
		NSBeep() ;
	}
}

- (void)clearAllContentFilters {
	[switchFilterLogic selectSegmentWithTag:0] ;
	[switchFilterLogic sendAction:[switchFilterLogic action]
							   to:[switchFilterLogic target]] ;
	// By invalidating the cache, we cause a search and sort
	// to be done when we -reloadContent
	ContentDataSource* dataSource = [self contentDataSource] ;
	[dataSource invalidateFlatCache] ;
}

- (void)showStark:(Stark*)stark
         selectIt:(BOOL)selectIt {
	[contentOutlineView showStark:stark
                         selectIt:selectIt] ;
}

#pragma mark * Outline View Delegate ?? Methods

- (void)outlineViewItemDidCollapse:(NSNotification *)notification {
	ContentProxy* object = [[notification userInfo] objectForKey:@"NSObject"] ;
    if ([object respondsToSelector:@selector(stark)]) {
        // Object is a ContentProxy
        Stark* stark = [(ContentProxy*)object stark] ;
		[(Stark*)stark setIsExpanded:[NSNumber numberWithBool:NO]] ;
		[(GCUndoManager*)[[[self windowController]  document] undoManager] setActionIsDiscardable:YES] ;
        // Typecast in the above line is for when Deploymate tests if this
        // project can run in macOS 10.6.  NSUndoManager did not support
        // -setActionIsDiscardable until 10.7, but we are using
        // GCUndoManager which does, and since it's in our source code, it
        // does so without regard to OS X version.
	}
	else {
	}
}

- (BOOL)outlineView:(NSOutlineView *)outlineView
   shouldExpandItem:(id)item {
	BOOL answer = YES ; // Defensive programming
	if ([outlineView respondsToSelector:@selector(springLoadingEnabled)]) {
		// ContentOutlneView
		answer = [(ContentOutlineView*)outlineView springLoadingEnabled] ;
	}
    else {
        NSLog(@"Internal error 624-9335 %@", outlineView) ;
    }
	
	return answer ;
}

/*
 @details  The 'selectedObjects' is an ivar of BkmxOutlineView.  This method
 keeps this ivar in sync with the outline's selected indexes.
 */
- (void)outlineViewSelectionDidChange:(NSNotification*)notification {
   BkmxOutlineView* outlineView = [notification object] ;
    if ([outlineView respondsToSelector:@selector(setSelectedObjects:)]) {
        NSArray* starks = [outlineView objectsAtRowIndexes:[outlineView selectedRowIndexes]] ;
        [outlineView setSelectedObjects:starks] ;
    }
}

- (void)outlineViewItemDidExpand:(NSNotification *)notification {
    id object = [[notification userInfo] objectForKey:@"NSObject"] ;
    if ([object respondsToSelector:@selector(stark)]) {
        // Object is a ContentProxy
        Stark* stark = [(ContentProxy*)object stark] ;
        if (![[stark isExpanded] isEqual:[NSNumber numberWithBool:YES]]) {
            [stark setIsExpanded:[NSNumber numberWithBool:YES]] ;
            
            [(GCUndoManager*)[[[self windowController] document] undoManager] setActionIsDiscardable:YES] ;
            // Typecast in the above line is for when Deploymate tests if this
            // project can run in macOS 10.6.  NSUndoManager did not support
            // -setActionIsDiscardable until 10.7, but we are using
            // GCUndoManager which does, and since it's in our source code, it
            // does so without regard to OS X version.
        }
    }
    else {
        // Defensive programming
    }
}

- (BOOL)    outlineView:(NSOutlineView *)aOV
  shouldEditTableColumn:(NSTableColumn *)aTableColumn
                   item:(id)proxy {
    Stark* stark = [proxy stark] ;
    // The following is put in here to avoid crashes in case the user tries to
    // delete an item while editing it.  I tried to use controlTextDidBeginEditing:(NSNotification*)aNotification
    // but this method does not get called until the user types a key, which is sometimes too late to
    // avoid a crash if the delete button is clicked.  We have to disable delete as soon as
    // the text field is selected.
    
    //  Do not allow editing of either column in immoveable items
    if (![stark isEditable])
    {
        //NSRunInformationalAlertPanel([NSString localize:@"sorry"], [NSString localize:@"cantEditBarOrMenu"], [NSString localize:@"ok"], nil, nil) ;
        //The above happens after editing the item above the bar or menu, even if I -deselectAl
        //during -controlTextDidEndEditing.
        return NO ;  // Cannot change name of fixed items!
    }
    
    if ([stark sharypeValue] == SharypeSeparator)
        return NO ;
    
    // Do not allow editing of url column except in bookmarks
    if (([stark sharypeValue] != SharypeBookmark) && ([[aTableColumn identifier] isEqualToString:@"url"]))
        return NO ;
    
    return YES ;
}


/* The following delegate method never gets invoked.  (Mac OS 10.5.7).  I've read in
 cocoa-dev list archives that this may be a bug, and that it works if column reordering
 is enabled.  But I don't want column reordering and have not tried that.
 - (void)outlineView:(NSOutlineView *)outlineView
 didClickTableColumn:(NSTableColumn *)tableColumn {
 }
 */

/*
 This method implementation effectively overrides -[BkmxDocViewController
 tableView:toolTipForCell:rect:tableColumn:row:mouseLocation:]
 */
- (NSString*)outlineView:(NSOutlineView *)outlineView
          toolTipForCell:(NSCell*)cell
                    rect:(NSRectPointer)rect
             tableColumn:(NSTableColumn*)tableColumn
                    item:(ContentProxy*)proxy
           mouseLocation:(NSPoint)mouseLocation {
    NSString* toolTip = @"" ;
    Stark* stark = [proxy stark] ;
    if ([stark isAvailable]) {  // <-- This test added in BookMacster 1.16
        // If user is hovering over one of the other columns in the Ixporters or
        // Exporters table, or a dupe in the Dupes table, stark could actually be
        // an Ixporter or Dupe instance.
        // So we check if it acts like a Stark instance before sending the message.
        if ([stark respondsToSelector:@selector(toolTipForTableColumn:)]) {
            toolTip = [stark toolTipForTableColumn:tableColumn] ;
        }
    }
    
    return toolTip ;
}

#pragma mark * RPTokenControlDelegate Delegate Methods

- (void)tokenControl:(RPTokenControl*)tokenControl
         renameToken:(NSString*)tag {
    SSYAlert* alert = [SSYAlert alert] ;
    NSString* prompt = [NSString stringWithFormat:@"Rename tag '%@' in any bookmark to", tag] ;
    SSYLabelledTextField* textField = [SSYLabelledTextField labelledTextFieldSecure:NO
                                                                 validationSelector:NULL
                                                                   validationObject:nil
                                                                   windowController:self
                                                                       displayedKey:prompt
                                                                     displayedValue:tag
                                                                           editable:YES
                                                                                tag:0  // not used
                                                                       errorMessage:nil] ;
    [alert addOtherSubview:textField
                   atIndex:0] ;
    
    
    
    [alert setButton2Title:[[BkmxBasis sharedBasis] labelCancel]] ;
    
    BkmxDoc* bkmxDoc = [[self windowController]  document] ;
    
    [bkmxDoc runModalSheetAlert:alert
                     resizeable:NO
                      iconStyle:SSYAlertIconInformational
                  modalDelegate:self
                 didEndSelector:@selector(didEndRenameTagSheet:returnCode:contextInfo:)
                    contextInfo:[tag retain]] ;
    
}

- (void)didEndRenameTagSheet:(NSWindow*)sheet
                  returnCode:(NSInteger)returnCode
                 contextInfo:(NSString*)oldString {
    // This method has probably been broken since I fixed the mess with
    // SSYAlert no longer retaining itself, or something like that, until I
    // fixed it in BookMacster 1.20.1.
 	[sheet orderOut:self] ;
	if (returnCode == NSAlertFirstButtonReturn) {
        BkmxDoc* bkmxDoc = [[self windowController]  document] ;
        NSString* newString = nil ;
        for (NSView* view in [[sheet contentView] subviews]) {
            if ([view respondsToSelector:@selector(valueField)]) {
                SSYLabelledTextField* labelledTextField = (SSYLabelledTextField*)view ;
                newString = [[labelledTextField valueField] stringValue] ;
            }
        }
        if (newString) {
            [bkmxDoc changeStringInTagWhichHasString:oldString
                                            toString:newString];
        }
	}
    
    /* This was delivered as a void* contextInfo, so it must have been
     retained for us. */
    [oldString release];
}

- (NSString*)menuItemTitleToDeleteTokenControl:(RPTokenControl*)tokenControl
                                         count:(NSInteger)count
                                     tokenName:(NSString*)tokenName {
    NSString *title;
    NSString* subject ;
    if (count < 2) {
        subject = [NSString stringWithFormat:
                   @"'%@'",
                   tokenName] ;
    }
    else {
        subject = [NSString localizeFormat:
                   @"tagsX",
                   (long)count] ;
    }
    
    title = [NSString localizeFormat:
             @"delete%0",
             subject] ;
    
    return title ;
}

#pragma SSYMenuMaker Protocol Support

- (NSMenu*)menuForButton:(NSButton*)button {
	NSMenu* menu = [[[NSMenu alloc] init] autorelease] ;
	
	NSMenuItem* menuItem ;
	
	switch ([button tag]) {
		case 49111:
			// This is the "+" button in the Content tab
			// Menu item for new Soft Folder
            menuItem = [[NSMenuItem alloc] initWithTitle:[[BkmxBasis sharedBasis] labelSoftainer]
                                                  action:@selector(addNew:)
                                           keyEquivalent:@""] ;
            [menuItem setTarget:self] ;
            [menuItem setTag:TAG_NEW_SOFT_FOLDER] ;
            [menu addItem:menuItem] ;
            [menuItem release] ;
            
            // Menu item for new bookmark
            menuItem = [[NSMenuItem alloc] initWithTitle:[[BkmxBasis sharedBasis] labelLeaf]
                                                  action:@selector(addNew:)
                                           keyEquivalent:@""] ;
            [menuItem setTarget:self] ;
            [menuItem setTag:TAG_NEW_BOOKMARK] ;
            [menu addItem:menuItem] ;
            [menuItem release] ;
            
            // Menu item for new separator
            menuItem = [[NSMenuItem alloc] initWithTitle:[[BkmxBasis sharedBasis] labelSeparator]
                                                  action:@selector(addNew:)
                                           keyEquivalent:@""] ;
            [menuItem setTarget:self] ;
            [menuItem setTag:TAG_NEW_SEPARATOR] ;
            [menu addItem:menuItem] ;
            [menuItem release] ;
            
            // Menu item for "BookMacster Direct" bookmarklet
            menuItem = [[NSMenuItem alloc] initWithTitle:[[BkmxBasis sharedBasis] labelBookmacsterize]
                                                  action:@selector(addNew:)
                                           keyEquivalent:@""] ;
            [menuItem setTarget:self] ;
			[menuItem setTag:TAG_NEW_BOOKMACSTERIZER] ;
			[menu addItem:menuItem] ;
			[menuItem release] ;
            
			break ;
	}
	
	return menu ;
}	

#pragma mark NSDraggingDestination Protocol Support

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
	NSArray* tags = [tagCloud selectedTokens] ;
	if ((tags != nil) && ([tags count] > 0)) {
		return NSDragOperationCopy ;
	}
	else {
		return NSDragOperationNone ;
	}
}

- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender {
	NSArray* tags = [tagCloud selectedTokens] ;
	if ((tags != nil) && ([tags count] > 0)) {
		NSString* tipText = [NSString stringWithFormat:@"%@:\n\n%@:\n%@",
							 [NSString localize:@"tagBookmarks"],
							 [NSString localize:@"070_tags_Pinboard"],
							 [tags componentsJoinedByString:@"\n"]] ;
		NSPoint tipOrigin = [sender draggingLocation] ;
		tipOrigin.x += 20 ;
		[SSMoveableToolTip setString:tipText
                                font:[contentOutlineView moveableToolTipFont]
							  origin:tipOrigin
							inWindow:[[self windowController]  window]];
		return NSDragOperationLink ;
	}
	else {
		return NSDragOperationNone ;
	}
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
	[SSMoveableToolTip goAway] ;
    // Tag dropped bookmarks with selectedTag (singular) from tagCloud
	NSPasteboard *pboard;
    pboard = [sender draggingPasteboard];
    BOOL ok = NO ;
	if ([[pboard types] containsObject:constBkmxPboardTypeDraggableStark]) {
        NSArray<NSString*>* jsonWays = [pboard readObjectsForClasses:@[[NSString class]]
                                                             options:nil];
        NSMutableArray* bookmarks = [NSMutableArray new];
        for (NSString* jsonWay in jsonWays) {
            DraggableStark* draggableStark = [[DraggableStark alloc] initWithJsonString:jsonWay];
            Stark* stark = [draggableStark stark];
            if ([stark canHaveTags]) {
                [bookmarks addObject: draggableStark];
            }
            [draggableStark release];
        }
		NSArray* tags = [tagCloud selectedObjects] ;
		[StarkEditor addTags:tags
                 toBookmarks:bookmarks];
        [bookmarks release];
        
		ok = YES ;
	}
	return ok ;
}

- (void)draggingExited:(id <NSDraggingInfo>)sender {
	// I do this here in case it gets dragged to another window
    [SSMoveableToolTip goAway] ;
}


- (void)userMassDeletedTags:(NSNotification*)note {
    NSSet* deletedTags = [[note userInfo] objectForKey:RPTokenControlUserDeletedTokensKey] ;
    [[[[self windowController]  document] tagger] removeTags:deletedTags] ;
}

#pragma mark NSSplitView Delegate

- (void)splitViewDidResizeSubviews:(NSNotification*)note {
    NSSplitView* aSplitView = [note object] ;
    [self autosaveContentSplitView:aSplitView] ;
}

#pragma mark Infrastructure

- (void)mikeAshObserveValueForKeyPath:(NSString*)keyPath
							 ofObject:(id)object
							   change:(NSDictionary*)change
							 userInfo:(id)userInfo {
    if ([keyPath isEqualToString:@"selectedTokens"]) {
        [self filterTagsForObject:object] ;
	}
}

- (void)tearDown {
	// To fix crash if Split view tries to update as window is closing.
    // http://lists.apple.com/archives/cocoa-dev/2012/Aug/msg00638.html
	[splitView setDelegate:nil] ;
    
    ContentDataSource* contentDataSource = [contentOutlineView dataSource] ;
    [contentDataSource tearDown];
    [contentDataSource setDocument:nil] ;

    
	// Messaging table views' delegates and data sources after they are
    // gone causes indeterminate crashes.
	[contentOutlineView setDelegate:nil] ;
	[contentOutlineView setDataSource:nil] ;
    
    [(TagsPopoverViewController*)[tagsPopover contentViewController] tearDown] ;

	// Must unbind the things that we bound, bad things from happening as the window closes.
	// The table columns have been seen to get Core Data Console Burps like this:
	// "The NSManagedObject with ID:0x16f7f2f0 <x-coredata://A_UUID/Stark_entity/p20> has been invalidated."
	[(StarkTableColumn*)[contentOutlineView tableColumnWithIdentifier:@"userDefinedC0"] unbindValue] ;
	[(StarkTableColumn*)[contentOutlineView tableColumnWithIdentifier:@"userDefinedC1"] unbindValue]  ;
	// And these other views have been seen to get valueForKey: and/or setValue:forKey: messages
	// after they have been deallocated, causing crashes.
    [bookshigController unbind:@"managedObjectContext"] ;
    
    [[MAKVONotificationCenter defaultCenter] removeObserver:self] ;  // Needed for @"selectedTokens" of RPTokenControl
	[[NSNotificationCenter defaultCenter] removeObserver:self] ;

    [super tearDown] ;
}

- (void)reloadIncludingData:(BOOL)includingData
                     starks:(NSSet*)starks {
    if (!m_isReloadingData) {
        if ([[[[self windowController]  document] starker] root]) {
            m_isReloadingData = YES ;
            
            CGFloat fontSize = [[[NSUserDefaults standardUserDefaults] objectForKey:constKeyTableFontSize] doubleValue] ;
            NSFont* font = [NSFont systemFontOfSize:fontSize] ;
            
            ContentDataSource* dataSource = [self contentDataSource] ;
            BOOL outlineMode = [self outlineMode] ;
            [dataSource refreshFilterAnnunciationForOutlineMode:outlineMode] ;
            NSString* filterAnnunciation = [dataSource filterAnnunciation] ;
            [filterAnnunciator setFont:font] ;
            // filterAnnunciation will be nil because dataSource is nil during
            // -awakeFromNib > restoreAutosavedOutlineMode
            if (filterAnnunciation) {
                [filterAnnunciator setString:filterAnnunciation] ;
            }
            
            // Resize filterAnnunciator and contentOutlineView to fit filterAnnunciation
            CGFloat top = [[filterAnnunciator enclosingScrollView] top] ;
            CGFloat bottom = [[contentOutlineView enclosingScrollView] bottom] ;
            CGFloat contentScrollViewHeight ;
            if (![self outlineMode]) {
                // Table mode.
                [filterAnnunciator setHidden:NO] ;
                
                CGFloat annunciatorHeight = [filterAnnunciation heightForWidth:[[filterAnnunciator enclosingScrollView] width]
                                                                          font:[filterAnnunciator font]] ;
                [[filterAnnunciator enclosingScrollView] setHeight:annunciatorHeight] ;
                CGFloat annunciatorBottom = top - annunciatorHeight ;
                [[filterAnnunciator enclosingScrollView] setBottom:annunciatorBottom] ;
                
#define MARGIN_BELOW_FILTER_ANNUNCIATOR 2.0
                contentScrollViewHeight = annunciatorBottom - MARGIN_BELOW_FILTER_ANNUNCIATOR - bottom ;
            }
            else {
                // Outline mode.
                [filterAnnunciator setHidden:YES] ;
                
                contentScrollViewHeight = top - bottom + 1.0 ;
                // I don't know why it needs the +1.0.  I set the scroll view's height
                // to 374.0 in Interface Builder (same as the Tag Cloud's scroll view,
                // so their tops are even), but here, for some stupid reason, the value
                // of 'top' is 373.0.
            }
            [[contentOutlineView enclosingScrollView] setHeight:contentScrollViewHeight] ;
            
            if (includingData) {
                if (starks) {
                    // Partial Reload
                    [contentOutlineView reloadStarks:starks] ;
                }
                else {
                    // Full Reload
                    [contentOutlineView reloadData] ;
                }
            }

            [tagCloud setFixedFontSize:fontSize] ;
            [tagCloud setObjectValue:[[[[self windowController] document] tagger] allTags]] ;
            [contentOutlineView updateNameColumnHeading] ;
            
            m_isReloadingData = NO ;
            
            [textLineage setFont:font] ;
        }
	}
}

- (void)reload {
    [self reloadIncludingData:YES
                       starks:nil] ;
}

- (void)reloadStarks:(NSSet*)starks {
    [self reloadIncludingData:YES
                       starks:starks] ;
}

// CLEAR-STAGING //- (void)clearReloadStaging {
// CLEAR-STAGING //    [contentOutlineView clearReloadStaging] ;
// CLEAR-STAGING //}

- (BOOL)disallowInVersionsBrowserTabViewItem:(NSTabViewItem*)tabViewItem {
    return NO ;
}

- (void)updateWindowForStark:(Stark*)stark {
	[self showOrHideTagCloud] ;
    
    NSSet* starks ;
    if (stark) {
        starks = [NSSet setWithObject:stark] ;
    }
    else {
        starks = nil ;
    } ;
    
	[self reloadIncludingData:YES
                       starks:starks] ;
	
	// The following only takes 6 milliseconds for my 1200 bookmarks
	// Intel Core 2 Duo Early 2006 Mac Mini
	[[[self windowController]  document] refreshVerifySummary] ;
	
    [self updateDetailViewForStarks:[self selectedStarks]] ;
}

- (void)updateWindow {
    [self updateWindowForStark:nil] ;
}

- (void)restoreAutosavedOutlineMode {
	NSArray* keyPathArray = [[[self windowController]  document] autosaveKeyPathArrayWithLastKeys:constAutosaveOutlineMode] ;
	NSNumber* mode = [[NSUserDefaults standardUserDefaults] valueForKeyPathArray:keyPathArray] ;
	// Check in case of corrupt prefs
	if (mode && [mode respondsToSelector:@selector(boolValue)]) {
		[self setOutlineMode:[mode boolValue]] ;
	}
	else {
		// Default to YES, since if NO people think all their folders have disappeared.
		// Don't worry about new documents because this value will be properly set
		// in -[BkmxDoc configureNewAfterClients] which runs *later*.
		[self setOutlineMode:YES] ;
	}
}

- (void)autosaveAllCurrentValues {
	[self autosaveContentSplitView:[self splitView]] ;
	[[self windowController]  autosaveTableColumnsInTableView:contentOutlineView] ;
	[self autosaveOutlineMode:[self outlineMode]] ;
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
    
    [lineageImageView setImage:[SSYVectorImages imageStyle:SSYVectorImageStyleLineage
                                                    wength:[lineageImageView frame].size.width
                                                     color:nil
                                              darkModeView:self.view
                                             rotateDegrees:0.0
                                                     inset:0.0]] ;
    
	// Set the tool tips which are static, never change:
    [[switchDisplayFolders cell] setToolTip:[NSString localizeFormat:
                                             @"displayWhatX2",
                                             [[BkmxBasis sharedBasis] labelMainContentView],
                                             [[BkmxBasis sharedBasis] labelOutlineMode]]
                                 forSegment:0] ;
	[[switchDisplayFolders cell] setToolTip:[NSString localizeFormat:
											 @"displayWhatX2",
											 [[BkmxBasis sharedBasis] labelMainContentView],
											 [[BkmxBasis sharedBasis] labelTableMode]]
								 forSegment:1] ;
    
    NSImage* image ;
    image = [SSYVectorImages imageStyle:SSYVectorImageStyleTag
                                 wength:100.0  // does not matter, will be scaled
                                  color:nil
                           darkModeView:nil // For this template image, Cocoa will handle luminance inversion when in Dark Mode
                          rotateDegrees:0.0
                                  inset:0.0] ;
    [buttonShowTags setImage:image] ;
    image = [SSYVectorImages imageStyle:SSYVectorImageStyleDash
                                 wength:[switchFilterLogic widthForSegment:0]
                                  color:nil
                           darkModeView:nil // For this template image, Cocoa will handle luminance inversion when in Dark Mode
                          rotateDegrees:0.0
                                  inset:0.0] ;
    [[switchFilterLogic cell] setImage:image
                            forSegment:0] ;
    image = [SSYVectorImages imageStyle:SSYVectorImageStyleCheck1
                                 wength:[switchFilterLogic widthForSegment:1]
                                  color:nil
                           darkModeView:nil // For this template image, Cocoa will handle luminance inversion when in Dark Mode
                          rotateDegrees:0.0
                                  inset:0.0] ;
    [[switchFilterLogic cell] setImage:image
                            forSegment:1] ;
    image = [SSYVectorImages imageStyle:SSYVectorImageStyleCheck2
                                 wength:[switchFilterLogic widthForSegment:2]
                                  color:nil
                           darkModeView:nil // For this template image, Cocoa will handle luminance inversion when in Dark Mode
                          rotateDegrees:0.0
                                  inset:0.0] ;
    [[switchFilterLogic cell] setImage:image
                            forSegment:2] ;
    
    // tagCloud will be enabled, to receive drops, and delete tags,
    // but not totally editable
	[tagCloud setEditability:RPTokenControlEditability1] ;
	// So that bookmarks dragged onto tagCloud can be tagged:
	[tagCloud setLinkDragType:constBkmxPboardTypeDraggableStark] ;
	[tagCloud setDelegate:self] ;
	[tagCloud setAppendCountsToStrings:YES] ;
    
	[self showOrHideTagCloud] ;
	
    [tagCloud setDragImage:[SSYVectorImages imageStyle:SSYVectorImageStyleTag
                                                wength:20.0
                                                 color:nil
                                          darkModeView:nil // For this template image, Cocoa will handle luminance inversion when in Dark Mode
                                         rotateDegrees:0.0
                                                 inset:0.0]] ;
    
	[[BkmxBasis sharedBasis] setPlaceholdersForTagsInTokenField:tagCloud] ;
	
    /* Should do this before setting data source, because the latter, at least
     in Yosemite, will start to pre-load data or something – I don't know why
     but anyhow it will send, for example, -outlineView:numberOfChildrenOfItem:
     to the data source, which, if it is still in table mode when it should
     be in outline mode, respond with count of all starks, which will result in
     the sending ~50 -outlineView:child:ofItem: messages, which will result in
     the creation of ~50 extraneous nil-parent proxies. */
    [self restoreAutosavedOutlineMode] ;

    ContentDataSource* contentDataSource = [[ContentDataSource alloc] initWithDocument:[[self windowController]  document]] ;
    [self setContentDataSource:contentDataSource] ;
    [contentOutlineView setDataSource:contentDataSource] ;
    [contentDataSource release] ;
	[contentOutlineView setDelegate:self] ;
    
    /* Removed in BookMacter 1.17 because this is done by UDC mechanism now
    // Set localized title of URL column in outline
     NSTableColumn* column = [contentOutlineView tableColumnWithIdentifier:@"url"] ;
	NSCell* headerCell = [column headerCell] ;
	NSString* localizedTitle = [NSString localize:@"columnHeadingURL"] ;
	[headerCell setTitle:localizedTitle] ;
    */
    
	[self updateOutlineMode] ;
	
	[[NSNotificationCenter defaultCenter] addObserver:[self windowController] 
											 selector:@selector(handleChangedSelectionNotification:)
												 name:NSOutlineViewSelectionDidChangeNotification
											   object:contentOutlineView] ;
	
    // Added in BookMacster 1.12
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(userMassDeletedTags:)
												 name:RPTokenControlUserDeletedTokensNotification
											   object:tagCloud] ;
    
    [tagCloud addObserver:self
			   forKeyPath:@"selectedTokens"
				 selector:@selector(mikeAshObserveValueForKeyPath:ofObject:change:userInfo:)
				 userInfo:nil
				  options:0] ;
    
    // Removed in BookMacster 1.17 because this is already done about 25 lines above in -initWithDocument:.
	// [(ContentDataSource*)[contentOutlineView dataSource] setDocument:[[self windowController]  document]] ;

	NSInteger selectedSegment ;
	selectedSegment = [self outlineMode] ? 0 : 1 ;
	[switchDisplayFolders setSelectedSegment:selectedSegment] ;
	
    // Default value in case nothing is found in user defaults.
    // Safari does not support tags, so hide them in Smarky.
    double fraction = ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppSmarky) ? 1.0 : 0.8 ;
	NSString* string = [[self windowController]  autosavedContentSplitView] ;
    if ([string respondsToSelector:@selector(componentsSeparatedByString:)]) {
        NSArray* stringComponents = [string componentsSeparatedByString:@" "] ;
        if ([stringComponents count] ==1) {
           fraction = [[stringComponents objectAtIndex:0] doubleValue] ;
            if (fraction == FLT_MAX) {
                fraction = 0.8 ;
            }
        }
        else if ([stringComponents count] == 3) {
            // autosavedContentSplitView is apparently three numbers, as was
            // written by RBSplitView which was used prior to BookMacster 1.12.
            // First component is numberOfSubviews; should be 2 but we ignore it.
            double width0 = [[stringComponents objectAtIndex:1] doubleValue] ;
            double width1 = [[stringComponents objectAtIndex:2] doubleValue] ;
            fraction = MAX (width1 / (width0 + width1), 0.0) ;
        }
    }
    
    [splitView setFraction:fraction] ;

    // Now that we've got the window sized, tabs selected, and split view
    // (if applicable) sized, we can safely populate
	// the views with data and not have to worry about, for example,
	// sending -sizeToFit messages to subviews that will later be resized.
	[self updateWindow] ;

    // Restoring the content column widths needs further delay because selection
    // of the tab view, which will resize the table to its final size, has not
    // occurred yet. (Delay added in BookMacster 1.17.)
    NSDictionary* state = [[self windowController]  autosavedColumnStateForTableView:contentOutlineView] ;
    [contentOutlineView performSelector:@selector(restoreFromAutosaveState:)
                              withObject:state
                              afterDelay:BKMX_DOC_WINDOW_OPENING_DELAY__RESTORE_COLUMNS] ;
}

- (void)dealloc {
    // This is done elsewhere, but I added this here in BookMacster 1.12
    // because I think this might be the *correct* place to do it.
    [contentOutlineView setDataSource:nil] ;
	[m_contentDataSource release] ;
    
	[super dealloc] ;
}

- (NSArray<Tag*>*)selectedTags {
    return [tagCloud selectedObjects];
}
    
    @end
