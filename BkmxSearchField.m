#import "BkmxSearchField.h"
#import "BkmxBasis+Strings.h"
#import "BkmxDocWinCon+Autosaving.h"
#import "NSNumber+Sharype.h"


@implementation BkmxSearchField

+ (void)decodeMenuItem:(NSMenuItem*)menuItem
               toKey_p:(NSString**)key_p
            toObject_p:(id*)object_p {
    NSInteger tag = [menuItem tag] ;
    NSString* key = nil ;
    id object = nil ;
    if ((tag & BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_OPTIONS) != 0) {
        // This is a change to one of the "Search Options" items
        key = constAutosaveSearchOptions ;
        
        if ((tag & BKMX_SEARCH_FIELD_MENU_ITEM_TAG_CASE_SENSITIVE) != 0) {
            object = constKeyCaseSensitive ;
        }
        else if ((tag & BKMX_SEARCH_FIELD_MENU_ITEM_TAG_WHOLE_WORDS) != 0) {
            object = constKeyWholeWords ;
        }
        else {
            NSLog(@"Internal Error 392-3951 %lx", (long)tag) ;
        }
    }
    else if ((tag & BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_FOR) != 0) {
        // This is a change to one of the "Search For" items
        key = constAutosaveSearchFor ;
        
        if ((tag & BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_BOOKMARKS) != 0) {
            object = [NSNumber numberWithSharype:SharypeCoarseLeaf] ;
        }
        else if ((tag & BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_FOLDERS) != 0) {
            object = [NSNumber numberWithSharype:SharypeGeneralContainer] ;
        }
        else {
            NSLog(@"Internal Error 392-3951 %lx", (long)tag) ;
        }
    }
    else if ((tag & BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_IN) != 0) {
        // This is a change to one of the "Search In" items
        key = constAutosaveSearchIn ;
        
        if ((tag & BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_NAME) != 0) {
            object = constKeyName ;
        }
        else if ((tag & BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_TAGS) != 0) {
            object = constKeyTagsString ;
        }
        else if ((tag & BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_URL) != 0) {
            object = constKeyUrl ;
        }
        else if ((tag & BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_SHORTCUT) != 0) {
            object = constKeyShortcut ;
        }
        else if ((tag & BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_COMMENTS) != 0) {
            object = constKeyComments ;
        }
        else {
            NSLog(@"Internal Error 392-3952 %lx", (long)tag) ;
        }
    }
    
    if (key_p) {
        *key_p = key ;
    }
    
    if (object_p) {
        *object_p = object ;
    }    
}

- (void)populateFromUserDefaultsForDelegate:(NSObject <BkmxSearchDelegate> *)bkmxDocWinCon
                           includeSearchFor:(BOOL)includeSearchFor {
	// The following code copied from Apple Sample Project 'SearchField'
	// but I made a few improvements
	if ([self respondsToSelector: @selector(setRecentSearches:)]) {
		// Note: Any menu item without a valid action will be disabled
		
		NSMenu* searchMenu = [[[NSMenu alloc] initWithTitle:NSLocalizedString(@"Quick Search Menu", nil)] autorelease] ;
		[searchMenu setAutoenablesItems:YES];
		
		NSMenuItem* item ;		
		NSString* title ;
		NSInteger state ;
		NSSet* itemsOn ;
		
		NSInteger index = 0 ;
        
        
        // *** "Search Options" Section
        
        {
            item = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Search Options", nil)
                                              action:nil
                                       keyEquivalent:@""] ;
            [searchMenu insertItem:item
                           atIndex:index++] ;
            [item release] ;
            
            itemsOn = [bkmxDocWinCon autosavedSearchValueForKey:constAutosaveSearchOptions] ;

            // Case sensitive
            item = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Case sensitive", nil)
                                              action:@selector(changeSearchParm:)
                                       keyEquivalent:@""] ;
            [item setTag:BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_OPTIONS + BKMX_SEARCH_FIELD_MENU_ITEM_TAG_CASE_SENSITIVE] ;
            [item setTarget:bkmxDocWinCon] ;
            state = ([itemsOn member:constKeyCaseSensitive] != nil) ? NSControlStateValueOn : NSControlStateValueOff ;
            [item setState:state] ;
            [searchMenu insertItem:item
                           atIndex:index++] ;
            [item release] ;

            // Whole words
            item = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Whole words", nil)
                                              action:@selector(changeSearchParm:)
                                       keyEquivalent:@""] ;
            [item setTag:BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_OPTIONS + BKMX_SEARCH_FIELD_MENU_ITEM_TAG_WHOLE_WORDS] ;
            [item setTarget:bkmxDocWinCon] ;
            state = ([itemsOn member:constKeyWholeWords] != nil) ? NSControlStateValueOn : NSControlStateValueOff ;
            [item setState:state] ;
            [searchMenu insertItem:item
                           atIndex:index++] ;
            [item release] ;
        }
		
		// *** "Search For" Section

        // Separator
        [searchMenu insertItem:[NSMenuItem separatorItem]
                       atIndex:index++];
        
		if (includeSearchFor) {
            // Search For
            item = [[NSMenuItem alloc] initWithTitle:[[BkmxBasis sharedBasis] labelSearchFor]
                                              action:nil
                                       keyEquivalent:@""] ;
            [searchMenu insertItem:item
                           atIndex:index++] ;
            [item release] ;
            
            itemsOn = [bkmxDocWinCon autosavedSearchValueForKey:constAutosaveSearchFor] ;
            
            // Bookmarks
            item = [[NSMenuItem alloc] initWithTitle:[[BkmxBasis sharedBasis] labelBookmarks]
                                              action:@selector(changeSearchParm:)
                                       keyEquivalent:@""] ;
            [item setTag:BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_FOR + BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_BOOKMARKS] ;
            [item setTarget:bkmxDocWinCon] ;
            state = ([itemsOn member:[NSNumber numberWithSharype:SharypeCoarseLeaf]] != nil) ? NSControlStateValueOn : NSControlStateValueOff ;
            [item setState:state] ;
            [searchMenu insertItem:item
                           atIndex:index++] ;
            [item release] ;
            
            // Folders
            item = [[NSMenuItem alloc] initWithTitle:[[BkmxBasis sharedBasis] labelFolders]
                                              action:@selector(changeSearchParm:)
                                       keyEquivalent:@""] ;
            [item setTag:BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_FOR + BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_FOLDERS] ;
            [item setTarget:bkmxDocWinCon] ;
            state = ([itemsOn member:[NSNumber numberWithSharype:SharypeGeneralContainer]] != nil) ? NSControlStateValueOn : NSControlStateValueOff ;
            [item setState:state] ;
            [searchMenu insertItem:item
                           atIndex:index++] ;
            [item release] ;		
        }

		// *** "Search In" Section
		
		// Separator
		[searchMenu insertItem:[NSMenuItem separatorItem]
					   atIndex:index++];
		
		// Search In
		item = [[NSMenuItem alloc] initWithTitle:[[BkmxBasis sharedBasis] labelSearchIn]
										  action:nil
								   keyEquivalent:@""] ;
		[searchMenu insertItem:item
					   atIndex:index++] ;
		[item release] ;
		
		itemsOn = [bkmxDocWinCon autosavedSearchValueForKey:constAutosaveSearchIn] ;
		
		// Name
		item = [[NSMenuItem alloc] initWithTitle:[[BkmxBasis sharedBasis] labelName]
										  action:@selector(changeSearchParm:)
								   keyEquivalent:@""] ;
        [item setTag:BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_IN + BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_NAME] ;
		[item setTarget:bkmxDocWinCon] ;
		state = [itemsOn member:constKeyName] != nil ? NSControlStateValueOn : NSControlStateValueOff ;
		[item setState:state] ;
		[searchMenu insertItem:item
					   atIndex:index++] ;
		[item release] ;
		
		// Tags
		item = [[NSMenuItem alloc] initWithTitle:[[BkmxBasis sharedBasis] labelTags]
										  action:@selector(changeSearchParm:)
								   keyEquivalent:@""] ;
        [item setTag:BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_IN + BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_TAGS] ;
		[item setTarget:bkmxDocWinCon] ;
		state = [itemsOn member:constKeyTagsString] != nil ? NSControlStateValueOn : NSControlStateValueOff ;
		[item setState:state] ;
		[searchMenu insertItem:item
					   atIndex:index++] ;
		[item release] ;
		
		// URL
		item = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"URL", nil)
										  action:@selector(changeSearchParm:)
								   keyEquivalent:@""] ;
        [item setTag:BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_IN + BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_URL] ;
		[item setTarget:bkmxDocWinCon] ;
		state = [itemsOn member:constKeyUrl] != nil ? NSControlStateValueOn : NSControlStateValueOff ;
		[item setState:state] ;
		[searchMenu insertItem:item
					   atIndex:index++] ;
		[item release] ;
		
		// Shortcut
		item = [[NSMenuItem alloc] initWithTitle:[[BkmxBasis sharedBasis] labelShortcut]
										  action:@selector(changeSearchParm:)
								   keyEquivalent:@""] ;
        [item setTag:BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_IN + BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_SHORTCUT] ;
		[item setTarget:bkmxDocWinCon] ;
		state = [itemsOn member:constKeyShortcut] != nil ? NSControlStateValueOn : NSControlStateValueOff ;
		[item setState:state] ;
		[searchMenu insertItem:item
					   atIndex:index++] ;
		[item release] ;
				
		// Comments
		item = [[NSMenuItem alloc] initWithTitle:[[BkmxBasis sharedBasis] labelDescription]
										  action:@selector(changeSearchParm:)
								   keyEquivalent:@""] ;
        [item setTag:BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_IN + BKMX_SEARCH_FIELD_MENU_ITEM_TAG_SEARCH_COMMENTS] ;
		[item setTarget:bkmxDocWinCon] ;
		state = [itemsOn member:constKeyComments] != nil ? NSControlStateValueOn : NSControlStateValueOff ;
		[item setState:state] ;
		[searchMenu insertItem:item
					   atIndex:index++] ;
		[item release] ;
		
        // *** Recently Touched Section
        
        // Separator
        [searchMenu insertItem:[NSMenuItem separatorItem]
                       atIndex:index++];
        
		// Recently Touched
		item = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"Touched during the last", nil)
										  action:nil
								   keyEquivalent:@""] ;
		[searchMenu insertItem:item
					   atIndex:index++] ;
		[item release] ;
        
		// Day
		item = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"day", nil)
										  action:@selector(changeSearchParm:)
								   keyEquivalent:@""] ;
        [item setTag:BKMX_SEARCH_FIELD_MENU_ITEM_TAG_LAST_TOUCHED + BKMX_SEARCH_FIELD_MENU_ITEM_TAG_LAST_DAY] ;
		[item setTarget:bkmxDocWinCon] ;
		[searchMenu insertItem:item
					   atIndex:index++] ;
		[item release] ;
        
		// Week
		item = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"week", nil)
										  action:@selector(changeSearchParm:)
								   keyEquivalent:@""] ;
        [item setTag:BKMX_SEARCH_FIELD_MENU_ITEM_TAG_LAST_TOUCHED + BKMX_SEARCH_FIELD_MENU_ITEM_TAG_LAST_WEEK] ;
		[item setTarget:bkmxDocWinCon] ;
		[searchMenu insertItem:item
					   atIndex:index++] ;
		[item release] ;
        
		// Month
		item = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"month", nil)
										  action:@selector(changeSearchParm:)
								   keyEquivalent:@""] ;
        [item setTag:BKMX_SEARCH_FIELD_MENU_ITEM_TAG_LAST_TOUCHED + BKMX_SEARCH_FIELD_MENU_ITEM_TAG_LAST_MONTH] ;
		[item setTarget:bkmxDocWinCon] ;
		[searchMenu insertItem:item
					   atIndex:index++] ;
		[item release] ;
        
		// Quarter
		item = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"quarter", nil)
										  action:@selector(changeSearchParm:)
								   keyEquivalent:@""] ;
        [item setTag:BKMX_SEARCH_FIELD_MENU_ITEM_TAG_LAST_TOUCHED + BKMX_SEARCH_FIELD_MENU_ITEM_TAG_LAST_QUARTER] ;
		[item setTarget:bkmxDocWinCon] ;
		[searchMenu insertItem:item
					   atIndex:index++] ;
		[item release] ;
        
        
        // *** Recent Searches Section

        // Separator
        [searchMenu insertItem:[NSMenuItem separatorItem]
                       atIndex:index++];

        // "Recent Searches" Title Item
        title = [[BkmxBasis sharedBasis] labelRecentSearches] ;
        item = [[NSMenuItem alloc] initWithTitle:title
                                          action:nil
                                   keyEquivalent:@""];
        [item setTag:NSSearchFieldRecentsTitleMenuItemTag]; // Tells NSSearchField to give special treatment
        [searchMenu insertItem:item
                       atIndex:index++];
        [item release];

        // "No Recent Searches"
        title = [[BkmxBasis sharedBasis] labelNoRecentSearches] ;
        item = [[NSMenuItem alloc] initWithTitle:title
                                          action:nil
                                   keyEquivalent:@""];
        [item setTag:NSSearchFieldNoRecentsMenuItemTag]; // Tells NSSearchField to give special treatment
        [searchMenu insertItem:item
                       atIndex:index++];
        [item release];

        // Placeholder for the actual Recent Searches
        item = [[NSMenuItem alloc] initWithTitle:title
                                          action:nil
                                   keyEquivalent:@""];
        [item setTag:NSSearchFieldRecentsMenuItemTag]; // Tells NSSearchField to give special treatment
        [searchMenu insertItem:item
                       atIndex:index++];
        [item release];

        // Separator
        item = (NSMenuItem*)[NSMenuItem separatorItem];
        [item setTag:NSSearchFieldRecentsTitleMenuItemTag]; // Tells NSSearchField to give special treatment
        [searchMenu insertItem:item
                       atIndex:index++];

        // Clear Recent Searches
        title = [[BkmxBasis sharedBasis] labelClearRecentSearches] ;
        item = [[NSMenuItem alloc] initWithTitle:title
                                          action:nil
                                   keyEquivalent:@""];
        [item setTag:NSSearchFieldClearRecentsMenuItemTag];	 // Tells NSSearchField to give special treatment
        [searchMenu insertItem:item
                       atIndex:index++];
        [item release];


		// ***** The menu is done, now set it into the cell ***** //

		id searchCell = [self cell] ;
		[searchCell setMaximumRecents:[[NSUserDefaults standardUserDefaults] integerForKey:constKeyMiniSearchRecents]] ;
		[searchCell setSearchMenuTemplate:searchMenu] ;
        
	}
}

@end
