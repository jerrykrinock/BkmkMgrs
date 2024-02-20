#import "NSMenu+StarkContextual.h"
#import "NSString+LocalizeSSY.h"
#import "BkmxArrayCategories.h"
#import "BkmxBasis+Strings.h"
#import "Stark+Sorting.h"
#import "Stark+Attributability.h"
#import "BkmxDoc+ActionValidator.h"
#import "NSString+SSYExtraUtils.h"
#import "StarkContainersHierarchicalMenu.h"
#import "StarkEditor.h"
#import "NSMenuItem+Bkmx.h"
#import "BkmxAppDel+Actions.h"
#import "BkmxDoc+Actions.h"
#import "Stark+Sorting.h"
#import "BkmxDocumentController.h"


@implementation NSMenu (StarkContextual)

- (void)addShowInspectorItem {
	if ([(BkmxAppDel*)[NSApp delegate] inspectorShowing]) {
		return ;
	}
	
	NSMenuItem* menuItem ;
    menuItem = [[NSMenuItem alloc] initWithTitle:[[BkmxBasis sharedBasis] labelShowInspector]
                                          action:@selector(inspectorShowOrNot:)
                                   keyEquivalent:@"i"] ;
	[menuItem setKeyEquivalentModifierMask:(NSEventModifierFlagShift | NSEventModifierFlagCommand)] ;
	[menuItem setTarget:(BkmxAppDel*)[NSApp delegate]];
	[self addItem:menuItem];
	[menuItem release];
}

- (void)addSeparatorItem {
	NSMenuItem* menuItem ;
	menuItem = [NSMenuItem separatorItem] ;
	[self addItem:menuItem] ;
}

- (void)addVisitItemsForBookmarks:(NSArray*)bookmarks {
	NSString* title ;
	SEL action ; 
	NSMenuItem* menuItem ;
	id target ;
	BkmxDoc* bkmxDoc = [[BkmxDocumentController sharedDocumentController] frontmostDocument] ;

	// User 'mercury' reported a crash here.  I finally found the problem,
	// and fixed it by implementing -[BkmxDocumentController frontmostDocument]
	// in BookMacster 1.3.0.  But I leave in the following interim
	// bandaid which was added back in BookMacster 0.2.0.
	if (!bkmxDoc) {
		NSLog(@"Internal error 395-1890 mercury contextual menu issue") ;
		return ;
	}	
	
	// Visit (Current URL)
	[bkmxDoc visitMenuItemParametersForUrlTemporality:BkmxUrlTemporalityCurrent
											target_p:&target
											action_p:&action
											 title_p:&title] ;
    menuItem = [[NSMenuItem alloc] initWithTitle:title
                                          action:action
                                   keyEquivalent:@"k"];
	[menuItem setKeyEquivalentModifierMask:(NSEventModifierFlagCommand)] ;
	[menuItem setTarget:target] ;
	[menuItem setRepresentedObject:bookmarks] ;
	[self addItem:menuItem] ;
	[menuItem release] ;	
	
	// Visit (Prior URL)
	[bkmxDoc visitMenuItemParametersForUrlTemporality:BkmxUrlTemporalityPrior
											   target_p:&target
											   action_p:&action
												title_p:&title] ;
    menuItem = [[NSMenuItem alloc] initWithTitle:title
                                          action:action
                                   keyEquivalent:@"k"];
	[menuItem setKeyEquivalentModifierMask:(NSEventModifierFlagOption | NSEventModifierFlagCommand)] ;
	[menuItem setTarget:target] ;
	[menuItem setRepresentedObject:bookmarks] ;
	[self addItem:menuItem] ;
	[menuItem release] ;	
	
	// Visit (Suggested URL)
	[bkmxDoc visitMenuItemParametersForUrlTemporality:BkmxUrlTemporalitySuggested
											   target_p:&target
											   action_p:&action
												title_p:&title] ;
    menuItem = [[NSMenuItem alloc] initWithTitle:title
                                          action:action
                                   keyEquivalent:@"k"];
	[menuItem setKeyEquivalentModifierMask:(NSEventModifierFlagShift | NSEventModifierFlagOption | NSEventModifierFlagCommand)] ;
	[menuItem setTarget:target] ;
	[menuItem setRepresentedObject:bookmarks] ;
	[self addItem:menuItem] ;
	[menuItem release] ;	
}

- (void)addCopyAndCutItemForStarks:(NSArray*)starks {
	NSMenuItem* menuItem ;

	// Copy
    menuItem = [[NSMenuItem alloc] initWithTitle:[NSString localize:@"copy"]
                                          action:@selector(copy:)
                                   keyEquivalent:@"c"] ;
    [menuItem setTarget:[[NSDocumentController sharedDocumentController] frontmostDocument]] ;
	[menuItem setRepresentedObject:starks] ;
    [self addItem:menuItem] ;
    [menuItem release] ;

	// Cut
    menuItem = [[NSMenuItem alloc] initWithTitle:[NSString localize:@"cut"]
                                          action:@selector(cut:)
                                   keyEquivalent:@"x"];
    [menuItem setTarget:[[NSDocumentController sharedDocumentController] frontmostDocument]] ;
	[menuItem setRepresentedObject:starks] ;
    [self addItem:menuItem];
    [menuItem release];
}

- (void)addHierarchicalContentItemWithTitle:(NSString*)title
								   selector:(SEL)selector
                                        tag:(NSInteger)tag
                                      index:(NSInteger)index
							  payloadStarks:(NSArray*)payloadStarks
									enabled:(BOOL)enabled {
    NSMenuItem* menuItem = [[NSMenuItem alloc] initWithTitle:title
                                                      action:NULL
                                               keyEquivalent:@""];
	StarkContainersHierarchicalMenu* submenu = [[StarkContainersHierarchicalMenu alloc] initWithTarget:[StarkEditor class]
																							  selector:selector
																							targetInfo:payloadStarks] ;
	[menuItem setSubmenu:submenu] ;
	[submenu setDoRoot:YES] ;
	[submenu setDelegate:submenu] ;
	[submenu release] ;
	// Because this item does not get queried by validateMenuItem
	// (apparently because it's hierarchical but I'm not sure why
	// that would matter), we disable it now if no starks.
	[menuItem setEnabled:enabled] ;
    menuItem.tag = tag;

	[self insertItem:menuItem
             atIndex:index];
    [menuItem release];
}	

- (void)addHierarchicalItemsForStarks:(NSArray*)starks
                         startAtIndex:(NSInteger)index {
    if (index == NSNotFound) {
        index = self.itemArray.count;
    }
	[self addHierarchicalContentItemWithTitle:[NSString localize:@"copyTo"]
									 selector:@selector(copyNoRevealStarks:toNewParent:)
                                          tag:BKMX_STARK_CONTEXTUAL_MENU_ITEM_TAG_COPY_TO
                                        index:index
								payloadStarks:starks
									  enabled:([starks count] > 0)] ;
	[self addHierarchicalContentItemWithTitle:[NSString localize:@"moveTo"]
									 selector:@selector(moveNoRevealStarks:toNewParent:)
                                          tag:BKMX_STARK_CONTEXTUAL_MENU_ITEM_TAG_MOVE_TO
                                        index:index+1
								payloadStarks:starks
									  enabled:([starks count] > 0)] ;
    BOOL allAreFolders = NO;
    if (starks.count > 0) {
        allAreFolders = YES;
        for (Stark* stark in starks) {
            if (![stark canHaveChildren]) {
                allAreFolders = NO ;
                break ;
            }
        }
    }
	[self addHierarchicalContentItemWithTitle:[NSString localize:@"mergeInto"]
									 selector:@selector(mergeFolders:intoFolder:)
                                          tag:BKMX_STARK_CONTEXTUAL_MENU_ITEM_TAG_MERGE_INTO
                                        index:index+2
								payloadStarks:starks
									  enabled:allAreFolders] ;
}

- (void)addHierarchicalItemsForStarks:(NSArray*)starks {
    [self addHierarchicalItemsForStarks:starks
                           startAtIndex:NSNotFound];
}

- (void)addDeleteItemForStarks:(NSArray*)starks {
	NSMenuItem* menuItem ;
	NSString* deleteKeyEquivalent = [NSString stringWithFormat:@"%C", (unsigned short)0x232B] ;
    menuItem = [[NSMenuItem alloc] initWithTitle:[NSString localize:@"delete"]
                                          action:@selector(deleteItems:)
                                   keyEquivalent:deleteKeyEquivalent] ;
    [menuItem setTarget:[[NSDocumentController sharedDocumentController] frontmostDocument]] ;
	[menuItem setRepresentedObject:starks] ;
    [self addItem:menuItem] ;
    [menuItem release] ;
}

- (void)addItemSortBy:(BkmxSortBy)sortBy
			smallFont:(BOOL)useSmallFont
			   starks:(NSArray*)starks {
	NSMenuItem* item ;
	NSString* title = [[BkmxBasis sharedBasis] labelForSortBy:sortBy] ;
    item = [[NSMenuItem alloc] initWithTitle:title
                                      action:@selector(sortBy:)
                               keyEquivalent:@""] ;
	[item setTarget:[Stark class]] ;
	if (useSmallFont) {
	}
	[item setRepresentedObject:starks] ;
	[item setTag:sortBy] ;
	[self addItem:item] ;
	[item release] ;
}

+ (void)configureToSortNowItem:(NSMenuItem*)menuItem
					 smallFont:(BOOL)useSmallFont
						starks:(NSArray*)starks {
	BOOL canDo = NO;
	for (Stark* stark in starks) {
		if ([[stark children] count] > 0) {
			canDo = YES ;
			break ;
		}
	}
	
	NSString* title = [NSString localize:@"sortNowBy"] ;
	[menuItem setTitle:title] ;
	
	[menuItem setEnabled:canDo] ;
	
	if (canDo) {
		NSMenu* menu = [NSMenu new] ;
		
		[menu addItemSortBy:BkmxSortByName
				  smallFont:useSmallFont
					 starks:starks] ;
		[menu addItemSortBy:BkmxSortByRating
				  smallFont:useSmallFont
					 starks:starks] ;
		[menu addItemSortBy:BkmxSortByUrl
				  smallFont:useSmallFont
					 starks:starks] ;
		[menu addItemSortBy:BkmxSortByDomainHostPath
				  smallFont:useSmallFont
					 starks:starks] ;
		[menu addItemSortBy:BkmxSortByShortcut
				  smallFont:useSmallFont
					 starks:starks] ;
		[menu addSeparatorItem] ;
		[menu addItemSortBy:BkmxSortByAddDate
				  smallFont:useSmallFont
					 starks:starks] ;
		[menu addItemSortBy:BkmxSortByLastModified
				  smallFont:useSmallFont
					 starks:starks] ;
		[menu addItemSortBy:BkmxSortByLastVisited
				  smallFont:useSmallFont
					 starks:starks] ;
		[menu addSeparatorItem] ;
		[menu addItemSortBy:BkmxSortByVerifyStatusCode
				  smallFont:useSmallFont
					 starks:starks] ;
		[menu addItemSortBy:BkmxSortByVisitCount
				  smallFont:useSmallFont
					 starks:starks] ;
		
		[menuItem setSubmenu:menu] ;
		[menu release] ;
	}
}

- (void)addSortNowItemForStarks:(NSArray*)starks {
    NSMenuItem* menuItem = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"DUMMY-TITLE", nil)
                                                      action:NULL
                                               keyEquivalent:@""] ;
	[NSMenu configureToSortNowItem:menuItem
						 smallFont:YES
							starks:starks] ;
	[self addItem:menuItem] ;
	[menuItem release] ;
}

- (void)addSetSortableItemForContainers:(NSArray*)containers {
	NSMenuItem* menuItem ;
	NSInteger currentStates = [containers allShouldSort] ;
	SEL action = NULL ;
	if ([containers count] > 0) {
		switch (currentStates) {
			case NSControlStateValueOn:
				action = @selector(setSortableNo:) ;
				break ;
			default: // NSControlStateValueOff or NSControlStateValueMixed:
				action = @selector(setSortableYes:) ;
				break ;
		}
	}
    menuItem = [[NSMenuItem alloc] initWithTitle:[NSString localize:@"willBeSorted"]
                                          action:action
                                   keyEquivalent:@""] ;
	[menuItem setTarget: ([containers count] > 0) ? [[NSDocumentController sharedDocumentController] frontmostDocument] : nil] ;
	[menuItem setState:currentStates] ;
	[menuItem setRepresentedObject:containers] ;
	[menuItem setToolTip:[NSString localizeFormat:@"sortedToolTip", [[BkmxBasis sharedBasis] appNameLocalized]]] ;
	[self addItem:menuItem];
	[menuItem release];
}

- (void)addSortDirectiveItemsForSoftFoldersAndBookmarks:(NSArray*)softFoldersAndBookmarks {
	NSMenuItem* menuItem ;
	NSString* title ;
	SEL action ;
	NSString* keyEquivalent ;
	NSInteger currentTopStates = NSControlStateValueOff ;
	NSInteger currentBottomStates = NSControlStateValueOff ;
	if ([softFoldersAndBookmarks count] > 0) {		
		currentTopStates = [softFoldersAndBookmarks allHaveSortDirectiveValue:BkmxSortDirectiveTop] ;
		currentBottomStates = [softFoldersAndBookmarks allHaveSortDirectiveValue:BkmxSortDirectiveBottom] ;
	}
	
	// Sort at Top	
	title = [NSString stringWithFormat:
			 @"%@ %@",
			 [NSString localize:@"atSort"],
			 [NSString localize:@"atTop"]] ;
	id target = nil ;
    // See Note NilTargetDisMenu
    if (
		(currentTopStates != NSControlStateValueOn)
		&& 
		([softFoldersAndBookmarks allCanAcceptSortDirective])
		) {
		// At least one stark is not already set to sort at top,
		// and can accept such a setting
        target = [[NSDocumentController sharedDocumentController] frontmostDocument] ;
	}
    action = @selector(setSortDirectiveTop:) ;
	keyEquivalent = [NSString stringWithFormat:@"%C", (unsigned short)0x2191] ;  // up arrow
    menuItem = [[NSMenuItem alloc] initWithTitle:title
                                          action:action
                                   keyEquivalent:keyEquivalent] ;
	[menuItem setKeyEquivalentModifierMask:(NSEventModifierFlagOption | NSEventModifierFlagCommand)] ;
	[menuItem setTarget:target] ;
	[menuItem setRepresentedObject:softFoldersAndBookmarks];
	[menuItem setState:currentTopStates] ;
	[self addItem:menuItem];
	[menuItem release];
	
	// Sort Normally	
	title = [NSString stringWithFormat:
			 @"%@ %@",
			 [NSString localize:@"atSort"],
			 [NSString localize:@"normally"]] ;
	target = nil ;
    // See Note NilTargetDisMenu
	if (
		(
		 (currentTopStates != NSControlStateValueOff)  // At least one set set to sort at top
		 ||
		 (currentBottomStates != NSControlStateValueOff)  // At least one is set to sort at bottom
		 )
		&&
		([softFoldersAndBookmarks allCanAcceptSortDirective])		
		) {
		// At least one has a setting which can be removed
        target = [[NSDocumentController sharedDocumentController] frontmostDocument] ;
	}
	action = @selector(setSortDirectiveNormal:) ;keyEquivalent = [NSString stringWithFormat:@"%C", (unsigned short)0x2190] ;  // down arrow
    menuItem = [[NSMenuItem alloc] initWithTitle:title
                                          action:action
                                   keyEquivalent:keyEquivalent] ;
	[menuItem setKeyEquivalentModifierMask:(NSEventModifierFlagOption | NSEventModifierFlagCommand)] ;
	[menuItem setTarget:target] ;
	[menuItem setRepresentedObject:softFoldersAndBookmarks];
	NSInteger sortingNormally ;
	if (
		(currentTopStates == NSControlStateValueOff)  // None are set to sort at top
		&&
		(currentBottomStates == NSControlStateValueOff)  // None are set to sort at bottom
		)
	{
		// All starks are set to sort normal
		sortingNormally = NSControlStateValueOn ;
	}
	else if (
			 (currentTopStates == NSControlStateValueOn)  // All are set to sort at top
			 ||
			 (currentBottomStates == NSControlStateValueOn)  // All are set to sort at bottom
			 )
	{
		// None of the starks are set to normal
		sortingNormally = NSControlStateValueOff ;
	}
	else {
		sortingNormally = NSControlStateValueMixed ;
	}
	[menuItem setState:sortingNormally] ;
	[self addItem:menuItem];
	[menuItem release];
	
	// Sort at Bottom	
	title = [NSString stringWithFormat:
			 @"%@ %@",
			 [NSString localize:@"atSort"],
			 [NSString localize:@"atBottom"]] ;
	target = nil ;
    // See Note NilTargetDisMenu
	if (
		(currentBottomStates != NSControlStateValueOn)
		&& 
		([softFoldersAndBookmarks allCanAcceptSortDirective])
		) {
		// At least is not set to sort at bottom,
		// and can accept such a setting
        target = [[NSDocumentController sharedDocumentController] frontmostDocument] ;
	}
    action = @selector(setSortDirectiveBottom:) ;
	keyEquivalent = [NSString stringWithFormat:@"%C", (unsigned short)0x2193] ;  // down arrow
    menuItem = [[NSMenuItem alloc] initWithTitle:title
                                          action:action
                                   keyEquivalent:keyEquivalent] ;
	[menuItem setKeyEquivalentModifierMask:(NSEventModifierFlagOption | NSEventModifierFlagCommand)] ;
	[menuItem setTarget:target] ;
	[menuItem setRepresentedObject:softFoldersAndBookmarks];
	[menuItem setState:currentBottomStates] ;
	[self addItem:menuItem];
	[menuItem release];
}

- (void)addClearDontVerifyItemForBookmarks:(NSArray*)bookmarks {
    id target = nil ;
    // See Note NilTargetDisMenu
	// See if any of the selected bookmarks has 'dontVerify' = YES
	for (Stark* bookmark in bookmarks) {
		if ([[bookmark dontVerify] boolValue]) {
			// If no target, item will be disabled
            target = [[NSDocumentController sharedDocumentController] frontmostDocument] ;
			break ;
		}
	}
	// If target is still nil, menu item will be disabled.

    SEL action = @selector(clearDontVerify:) ;
    NSMenuItem* menuItem = [[NSMenuItem alloc] initWithTitle:[NSString localizeFormat:@"clearX", [[[BkmxBasis sharedBasis] labelDontVerify] doublequote]]
                                                      action:action
                                               keyEquivalent:@""];
	[menuItem setTarget:target] ;
	[menuItem setRepresentedObject:bookmarks] ;
	[self addItem:menuItem];
	[menuItem release];	
}

- (void)addSwapUrlsItemsForBookmarks:(NSArray*)bookmarks {
	NSMenuItem* menuItem ;
	SEL action ;
	
	// See if any of the selected bookmarks have prior urls
	id target = nil ;
    // See Note NilTargetDisMenu
	for (Stark* bookmark in bookmarks) {
		if ([bookmark verifierPriorUrl]) {
            target = [[NSDocumentController sharedDocumentController] frontmostDocument] ;
			break ;
		}
	}
	// If target is still nil, menu item will be disabled.
	
	// Add "Swap Current and Prior URLs" menu item
    action = @selector(swapPriorAndCurrentUrls:) ;
    menuItem = [[NSMenuItem alloc] initWithTitle:[[BkmxBasis sharedBasis] labelSwapPriorAndCurrentUrl]
                                          action:action
                                   keyEquivalent:@""] ;
    [menuItem setTarget:target] ;
	[menuItem setRepresentedObject:bookmarks] ;
	[self addItem:menuItem] ;
	[menuItem release] ;
	
	// See if any of the selected bookmarks have suggested urls
	target = nil ;
    // See Note NilTargetDisMenu
	for (Stark* bookmark in bookmarks) {
		if ([bookmark verifierSuggestedUrl]) {
            target = [[NSDocumentController sharedDocumentController] frontmostDocument] ;
			break ;
		}
	}
	// If target is still nil, menu item will be disabled.
	
	// Add "Swap Current and Suggested URLs" menu item
    action = @selector(swapSuggestedAndCurrentUrls:) ;
    menuItem = [[NSMenuItem alloc] initWithTitle:[[BkmxBasis sharedBasis] labelSwapSuggestedAndCurrentUrl]
                                          action:action
                                   keyEquivalent:@""] ;
	[menuItem setTarget:target] ;
	[menuItem setRepresentedObject:bookmarks] ;
	[self addItem:menuItem] ;
	[menuItem release] ;
}

+ (NSMenu*)menuWithAllActionsForSelectedStarks:(NSArray*)selectedStarks {
	// Filter so that starks contains only Stark objects, and not, for example,
	// an _NSStateMarker such as the <NO SELECTION MARKER>
	NSMutableArray* starks = [[NSMutableArray alloc] init] ;
	for (Stark* stark in selectedStarks) {
		if ([stark isKindOfClass:[Stark class]]) {
			[starks addObject:stark] ;
		}
	}
	
	// Process the selection to find info about its contents.  These results
	// will be used in this method only to validate menu items, and to show user
	// in menu title how many bookmarks will be affected.
	NSMutableArray* hartainers = [[NSMutableArray alloc] init] ;
	NSMutableArray* softFolders = [[NSMutableArray alloc] init] ;  
	NSMutableArray* bookmarks = [[NSMutableArray alloc] init] ;
	NSMutableArray* notches = [[NSMutableArray alloc] init] ;
	for(Stark* item in starks) {
		[item classifyBySharypeDeeply:NO
                           hartainers:hartainers
						  softFolders:softFolders
							   leaves:bookmarks
							  notches:notches] ;
	}
	
	NSArray* softFoldersAndBookmarks = [softFolders arrayByAddingObjectsFromArray:bookmarks] ;
	NSArray* containers = [hartainers arrayByAddingObjectsFromArray:softFolders] ;
	NSArray* softStarks = [softFoldersAndBookmarks arrayByAddingObjectsFromArray:notches] ;
    NSArray* allBookmarks = [Stark immediateBookmarksInHartainers:hartainers
                                                      softFolders:softFolders
                                                        bookmarks:bookmarks] ;
	
	// Create the menu
    NSMenu* menu = [[NSMenu alloc] initWithTitle:@""];
    [menu setFont:[NSFont systemFontOfSize:[[NSUserDefaults standardUserDefaults] doubleForKey:constKeyMenuFontSize]]] ;
	
	// Now, add menu items
	[menu addShowInspectorItem] ;
	[menu addVisitItemsForBookmarks:allBookmarks] ;
	[menu addSeparatorItem] ;
	[menu addCopyAndCutItemForStarks:starks] ;
	[menu addHierarchicalItemsForStarks:starks] ;
	[menu addDeleteItemForStarks:softStarks] ;
	[menu addSortNowItemForStarks:starks] ;
	[menu addSeparatorItem] ;
	[menu addSetSortableItemForContainers:containers] ;
	[menu addSortDirectiveItemsForSoftFoldersAndBookmarks:softFoldersAndBookmarks] ;
	[menu addClearDontVerifyItemForBookmarks:bookmarks] ;
	[menu addSwapUrlsItemsForBookmarks:bookmarks] ;
    
	// Clean up
	[starks release] ;
	[hartainers release] ;
	[softFolders release] ;
	[bookmarks release] ;
	[notches release] ;
	
	// Add a title for debugging
	[menu setTitle:[NSString stringWithFormat:@"Menu 224-1958"]] ;
	
	return [menu autorelease] ;
}	

@end

/* Note NilTargetDisMenu
 From this document…
 From http://developer.apple.com/documentation/Cocoa/Conceptual/MenuList/Articles/EnablingMenuItems.html#//apple_ref/doc/uid/20000261
 "If the menu item’s target is set, then NSMenu first checks to see if
 that object implements the item’s action method. If it does not, then
 the item is disabled."
 Well, I tried using NULL for selector but the menu item was still enabled.
 Using nil for target disables the item as desired.
 */
