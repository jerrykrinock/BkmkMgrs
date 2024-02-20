#import "MiniSearchWinCon.h"
#import "Stark+Sorting.h"
#import "BkmxSearchField.h"
#import "NSUserDefaults+KeyPaths.h"
#import "NSSet+SimpleMutations.h"
#import "BkmxDoc.h"
#import "Starker.h"
#import "StarkEditor.h"
#import "NSFont+Height.h"
#import "SSYProcessTyper.h"

NSString* constKeyMiniSearchParms = @"miniSearchParms" ;

@interface MiniSearchWinCon ()

@property (copy) NSString* searchText ;
@property (assign) CGFloat deadHeight ;
@property (retain) NSArray* searchResults ;

@end

@implementation MiniSearchWinCon

@synthesize searchText = m_searchText ;
@synthesize deadHeight = m_deadHeight ;
@synthesize searchResults = m_searchResults ;

- (void)dealloc {
    [m_searchText release] ;
    [m_searchResults release] ;
    
    [super dealloc] ;
}

- (id)init {
    self = [super initWithWindowNibName:@"MiniSearchWindow"] ;

    return self ;
}

- (void)awakeFromNib {
	[searchField populateFromUserDefaultsForDelegate:self
                                    includeSearchFor:NO] ;
    [self setDeadHeight:[[self window] frame].size.height] ;
    [searchResultsTableView setTarget:self] ;
    [searchResultsTableView setAction:@selector(visit:)] ;
}

- (void)showWindow:(id)sender {
    NSEvent* currentEvent = [NSApp currentEvent] ;
    NSPoint location = [currentEvent locationInWindow] ;
    NSSize size = [[self window] frame].size ;
	CGFloat screenHeight = [[[self window] screen] visibleFrame].size.height ;
    NSRect newRect = NSMakeRect(location.x, screenHeight, size.width, size.height) ;
    [[self window] setFrame:newRect
                    display:YES] ;
    
    // Refresh
    [searchField populateFromUserDefaultsForDelegate:self
                                    includeSearchFor:NO] ;
    
    [[self window] setTitle:NSLocalizedString(@"Mini Search", nil)] ;
    
    [[self window] makeKeyAndOrderFront:self] ;
    if ([SSYProcessTyper currentType] == NSApplicationActivationPolicyRegular) {
        [NSApp activateIgnoringOtherApps:YES] ;
    }
}

- (NSSet*)autosavedSearchValueForKey:(NSString*)key {
	NSArray* keyPathArray = [NSArray arrayWithObjects:
                             constKeyMiniSearchParms,
                             key,
                             nil] ;
	NSArray* array = nil ;
	if (keyPathArray) {
		array = [[NSUserDefaults standardUserDefaults] valueForKeyPathArray:keyPathArray] ;
	}
	
	// Check in case of corrupt prefs
	if (array && ![array isKindOfClass:[NSArray class]]) {
		NSLog(@"Warning 328-9817 Ignoring corrupt pref %@", key) ;
		array = nil ;
	}
    
	if (
		!array // User has never touched this part of the Mini Search menu
		||
		([array count] < 1)  // Corrupt prefs, since we don't allow writing < 1 element
		) {
		
		// Piggy back onto the default Quick Search parms.  The Quick Search
        // code was written first.
		
		NSArray* keyPathArray = [NSArray arrayWithObjects:
                                 constKeyQuickSearchParms,
                                 key,
                                 nil] ;
		array = [[NSUserDefaults standardUserDefaults] valueForKeyPathArray:keyPathArray] ;
	}
	
	// Check in case of corrupt prefs
	if (array && ![array isKindOfClass:[NSArray class]]) {
		NSLog(@"Warning 851-1284 Ignoring corrupt pref %@", key) ;
		array = [NSArray array] ;
	}
	
	if (!array) {
		array = [NSArray array] ;
	}
	
    NSSet* answer = [NSSet setWithArray:array] ;
	return answer ;
}

- (Sharype)sharypesMask {
	NSSet* searchForSharypes = [self autosavedSearchValueForKey:constAutosaveSearchFor] ;
    
	return [StarkTyper sharypesMaskForSearchForSharypesSet:searchForSharypes] ;
}

- (void)removeSearchResults {
    for (NSView* subview in [[[self window] contentView] subviews]) {
        if ([subview isKindOfClass:[NSScrollView class]]) {
            [subview removeFromSuperviewWithoutNeedingDisplay] ;
        }
    }
    
    NSRect windowFrame = [[self window] frame] ;
    windowFrame.size.height = [self deadHeight] ;
	CGFloat screenHeight = [[[self window] screen] visibleFrame].size.height ;
    windowFrame.origin.y = screenHeight ;
    [[self window] setFrame:windowFrame
                    display:NO] ;
}

- (void)windowWillClose:(NSNotification *)notification {
    [self removeSearchResults] ;
    [searchResultsTableView deselectAll:self] ;
    [searchField setStringValue:@""] ;
}

- (void)visit:(id)sender {
    NSInteger rowIndex = -1 ;
    
    // The following if…else if must be in the following order, because 
    // NSTableViewinherits from NSControl, oddly, it responds to -integerValue
    // (and, in my experience, returns 0).
    if ([sender respondsToSelector:@selector(clickedRow)]) {
        rowIndex = [sender clickedRow] ;
    }
    else if ([sender respondsToSelector:@selector(integerValue)]) {
        rowIndex = [sender integerValue] ;
    }
    
    if ((rowIndex > -1) && (rowIndex < [[self searchResults] count])) {
        [StarkEditor visitStark:[[self searchResults] objectAtIndex:rowIndex]] ;
    }
    else {
        // This happens if the user hits the tab key, into the table view, while
        // the searchResults are empty, then hits the 'space' bar.
        // -[MiniSearchTableView keyDown:] will send us an NSNumber whose value
        // is -1.  Just close the window.
    }
    
    // The following line would cause other windows to open when we are
    // a UIElement type process, unless they override -displayIfNeeded,
    // -display, -canBecomeKeyWindow, and -canBecomeMainWindow, as
    // SSYHintableWindow does.
    [[self window] close] ;
}

#define INEXPLICABLE_EXTRA_OOMPH_NEEDED_TO_GET_ALL_THE_WAY_UP 4.0

- (IBAction)search:(BkmxSearchField*)sender {
	NSString* newTargetString = [searchField stringValue] ;
    [searchField appendToRecentSearches:newTargetString] ;
    
    if ([newTargetString length] < 1) {
        [self removeSearchResults] ;
    }
    else {
        // Send to System Find Pasteboard
        NSPasteboard *pasteboard = [NSPasteboard pasteboardWithName:NSPasteboardNameFind] ;
        [pasteboard declareTypes:[NSArray arrayWithObject:NSPasteboardTypeString] owner:nil] ;
        [pasteboard setString:newTargetString forType:NSPasteboardTypeString] ;
        
        NSArray* documents = [[NSDocumentController sharedDocumentController] documents] ;
        NSMutableArray* roots = [[NSMutableArray alloc] init] ;
        for (BkmxDoc* bkmxDoc in documents) {
            if ([bkmxDoc respondsToSelector:@selector(starker)]) {
                [roots addObject:[[bkmxDoc starker] root]] ;
            }
        }
        
        NSMutableArray* allStarks = [[NSMutableArray alloc] init] ;
        
        for (Stark* root in roots) {
            [root classifyBySharypeDeeply:YES
                               hartainers:nil
                              softFolders:nil
                                   leaves:allStarks
                                  notches:nil] ;
            [allStarks removeObject:root] ;
        }
        [roots release] ;
        
        NSSet* searchOptions = [self autosavedSearchValueForKey:constAutosaveSearchOptions] ;
        BOOL caseSensitive = [searchOptions member:constKeyCaseSensitive] != nil ;
        BOOL wholeWords = [searchOptions member:constKeyWholeWords] != nil ;
        NSArray* searchResults = [Stark filteredSortedStarksFromStarks:allStarks
                                                          searchString:newTargetString
                                                            searchDays:nil
                                                    searchInAttributes:[self autosavedSearchValueForKey:constAutosaveSearchIn]
                                                               sortKey:constKeyName
                                                         caseSensitive:caseSensitive
                                                            wholeWords:wholeWords
                                                         sortAscending:YES
                                                            filterTags:nil
                                                       filterTagsLogic:0
                                                       foldersAtBottom:NO] ;
        [self setSearchResults:searchResults] ;
        [allStarks release] ;
        
        CGFloat screenHeight = [[[self window] screen] visibleFrame].size.height ;
        CGFloat tableHeight = 0.0 ;
        
        if ([searchResults count] > 0) {
            NSFont* font = [(BkmxAppDel*)[NSApp delegate] fontTable] ;
            CGFloat width = [[self window] frame].size.width ;
            NSView* contentView = [[self window] contentView] ;
            CGFloat rowHeight = [[(BkmxAppDel*)[NSApp delegate] fontTable] tableRowHeight] ;
            [searchResultsTableView setRowHeight:rowHeight] ;
            [searchResultsTableView setFont:font] ;
            NSSize intercellSpacing = [searchResultsTableView intercellSpacing] ;
            CGFloat extraTopAndBottomMarginsForBigSur = 2*rowHeight;
            tableHeight = MIN([searchResults count] * (rowHeight + intercellSpacing.height) + extraTopAndBottomMarginsForBigSur, screenHeight - [self deadHeight]) ;
            NSRect frame = NSMakeRect(0, 0, width, tableHeight) ;
            NSScrollView* scrollView = [searchResultsTableView enclosingScrollView] ;
            [scrollView setFrame:frame] ;
            [contentView addSubview:scrollView] ;
            [searchField setNextKeyView:searchResultsTableView] ;

            NSRect windowFrame = [[self window] frame] ;
            windowFrame.size.height = [self deadHeight] + tableHeight ;
            windowFrame.origin.y = screenHeight - windowFrame.size.height + INEXPLICABLE_EXTRA_OOMPH_NEEDED_TO_GET_ALL_THE_WAY_UP ;
            [[self window] setFrame:windowFrame
                            display:YES] ;
        }
        else {
            [self removeSearchResults] ;
        }

        [searchResultsTableView reloadData] ;
    }
}

#pragma mark NSTableViewDataSource Protocol Support

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    NSInteger answer = [[self searchResults] count] ;
    return answer ;
}

- (id)              tableView:(NSTableView *)tableView
    objectValueForTableColumn:(NSTableColumn*)tableColumn
                          row:(NSInteger)row {
    NSArray* searchResults = [self searchResults] ;
    id answer ;
    if ((row >= 0) && (row < [searchResults count])) {
        answer =  [[searchResults objectAtIndex:row] nameNoNil] ;
    }
    else {
        answer = @"--" ;
        NSLog(@"Internal Error 624-0509 %ld/%ld", (long)row, (long)[searchResults count]) ;
    }
    
    return answer ;
}

#pragma mark BkmxSearchDelegate Protocol Support

- (IBAction)changeSearchParm:(NSMenuItem*)menuItem {
	NSString* key ;
    id object ;
    [BkmxSearchField decodeMenuItem:menuItem
                            toKey_p:&key
                         toObject_p:&object] ;
    
	NSArray* keyPathArray = [NSArray arrayWithObjects:
                             constKeyMiniSearchParms,
                             key,
                             nil] ;
	BOOL proposedState = ([menuItem state] == NSControlStateValueOff) ;
	BOOL ok = YES ;
	
	
	NSSet* existingSet = [self autosavedSearchValueForKey:key] ;
	// Because existingArray may be the default value and not really existing in
	// user defaults under the keyPathArray, we do not use our cool deep
	// mutators -[NSUserDefaults addUniqueObject:toArrayAtKeyPathArray:]
	// and -[NSUserDefaults removeObject:fromArrayAtKeyPathArray:] to set
	// the new values, but instead mutate existingArray and overwrite the
	// whole thing from scratch.
	
	// Note: existingSet may be empty but will not be nil.
	
	// Before counting, check in case there are corrupt prefs
	if (![existingSet respondsToSelector:@selector(count)]) {
		existingSet = [NSSet set] ;
	}
	
	if (!proposedState && ![key isEqualToString:constAutosaveSearchOptions]) {
		// Do not allow the last item to be removed
		if ([existingSet isEqualToSet:[NSSet setWithObject:object]]) {
			ok = NO ;
		}
	}
	
	if (ok) {
		NSSet* newSet ;
		if (proposedState) {
			newSet = [existingSet setByAddingObject:object] ;
		}
		else {
			newSet = [existingSet setByRemovingObject:object] ;
		}
		
		[[NSUserDefaults standardUserDefaults] setValue:[newSet allObjects]
										forKeyPathArray:keyPathArray] ;
		[[NSUserDefaults standardUserDefaults] synchronize] ;
		
        /* Because we do not have direct access to the
         actual menu in an NSSearchField, but can only -setSearchMenuTemplate:
         which NSSearchField uses to create the actual menu, setting the
         state of the *real* menu item passed in to this method is insufficient,
         because the next time NSSearchField constructs a new menu from the
         template, the state will be reverted to its old value.  Instead, we
         need to change the *template*, which will cause NSSearchField to
         re-create its menu from the template, and also the change will stick
         the next time it is recreated.  To change the template, we invoke the
         following special method which re-creates the template, including its
         special placeholders… */
        [searchField populateFromUserDefaultsForDelegate:self
                                        includeSearchFor:NO] ;
        
		[self search:menuItem] ;
	}
	else {
		NSBeep() ;
	}
	
}


@end
