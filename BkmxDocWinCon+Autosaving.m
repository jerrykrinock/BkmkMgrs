#import "BkmxDocWinCon+Autosaving.h"
#import "NSUserDefaults+KeyPaths.h"
#import "FindViewController.h"
#import "NSTableView+Autosave.h"
#import "SSYTabView.h"
#import "ContentOutlineView.h"
#import "DupesOutlineView.h"
#import "BkmxDoc+Autosaving.h"
#import "NSSplitView+Fraction.h"
#import "CntntViewController.h"
#import "SettingsViewController.h"
#import "ReportsViewController.h"
#import "ContentOutlineView.h"
#import "FindTableView.h"
#import "NSArray+Stringing.h"

@implementation BkmxDocWinCon (Autosaving)

- (NSString*)uuid {
	NSString* uuid = nil ;
	
	NSDocument* document = [self document] ;
	SEL selector = @selector(uuid) ;
	if ([document respondsToSelector:selector]) {
		uuid = [document performSelector:@selector(uuid)] ;
	}
	
	return uuid ;
}

// Autosave Setters

// Gets notified whenever window is resized or moved
- (void)autosaveWindowFrameNote:(NSNotification*)notification {
	if (![self autosaveArmed]) {
		return ;
	}
	
	if ([self isInVersionBrowser]) {
		return ;
	}
	
	NSArray* keyPathArray = [[self document] autosaveKeyPathArrayWithLastKeys:constAutosaveWindowFrame] ;
	if (keyPathArray) {
		NSString* autosaveString = [[self window] stringWithSavedFrame] ;
		[[NSUserDefaults standardUserDefaults] setValue:autosaveString
										forKeyPathArray:keyPathArray] ;
	}
}

// Gets notified whenever window is resized
- (void)autosaveActiveTabViewSizeNote:(NSNotification*)notification {
	if (![self autosaveArmed]) {
		return ;
	}
	
	if ([self windowIsBeingAutosized]) {
		return ;
	}

	NSTabViewItem* tabViewItem = [self activeTabViewItem] ;

	if ([self sizabilityForTabViewItem:tabViewItem] != SSYSizabilityUserSizable) {
		return ;
	}
	
	NSString* tabViewItemIdentifier = [tabViewItem identifier] ;

	NSArray* lastKeys = [NSArray arrayWithObjects:
						 constAutosaveTabContentSizes,
						 tabViewItemIdentifier,
						 nil] ; 
	NSArray* keyPathArray = [[self document] autosaveKeyPathArrayWithLastKeys:lastKeys] ;
	if (keyPathArray) {
		NSSize windowSize = [[self window] frame].size ;
        CGFloat deadHeight = [self deadHeightForTabViewItem:tabViewItem] ;
		CGFloat tabHeight = windowSize.height - deadHeight ;
        NSSize tabSize = NSMakeSize(windowSize.width, tabHeight) ;
		NSString* sizeString = NSStringFromSize(tabSize) ;
        [[NSUserDefaults standardUserDefaults] setValue:sizeString
										forKeyPathArray:keyPathArray] ;
	}
}

- (void)autosaveTableColumnsInTableView:(NSTableView*)tableView {
	if (![self autosaveArmed]) {
		return ;
	}
	
	NSString* lastKey ;
	if ((id)tableView == [self contentOutlineView]) {
		lastKey = constAutosaveContentTableColumns ;
	}
	else if (tableView == [self findTableView]) {
		lastKey = constAutosaveFindTableColumns ;
	}
	else {
		lastKey = constAutosaveDupesTableColumns ;
	}
	
	NSArray* keyPathArray = [[self document] autosaveKeyPathArrayWithLastKeys:lastKey] ;
	if (keyPathArray) {
		NSDictionary* state = [tableView currentState] ;
		[[NSUserDefaults standardUserDefaults] setValue:state
										forKeyPathArray:keyPathArray] ;
	}
}

- (void)autosaveSelectedTabViewItem:(NSTabViewItem*)tabViewItem
						  inTabView:(NSTabView*)tabView {
	if (![self autosaveArmed]) {
		return ;
	}
	
	NSString* identifier = nil ;
	if (tabView == topTabView) {
		identifier = constAutosaveTabTop ;
	}
	else {
		// The tabView is buried in view(s) descending from a parent tab view
        NSView* view = tabView ;
        while (view) {
            // Defensive programming
            if (![view respondsToSelector:@selector(superview)]) {
                // tabView does not descend from NSView.  Get outta here!
                break ;
            }
            
            view = [view superview] ;
            if ([view respondsToSelector:@selector(selectedTabViewItem)]) {
                identifier = [[(NSTabView*)view selectedTabViewItem] identifier] ;
                break ;
            }
        }
	}
	NSArray* keyPathArray = [[self document] autosaveKeyPathArrayWithLastKeys:constAutosaveTabs] ;
	if (!identifier) {
		return ;
	}

	keyPathArray = [keyPathArray arrayByAddingObject:identifier] ;
	NSString* value = [tabViewItem identifier] ;
	[[NSUserDefaults standardUserDefaults] setValue:value
									forKeyPathArray:keyPathArray] ;
}

- (void)autosaveAllCurrentValues {
	[self autosaveWindowFrameNote:nil] ;
	[self autosaveActiveTabViewSizeNote:nil] ;
	[self autosaveSelectedTabViewItem:[[self topTabView] selectedTabViewItem]
							inTabView:[self topTabView]] ;
	// What about Inspector showing?
    
    // Besides the aesthetic value of farming out to each window controller to
    // perform autosaving of its own subviews, there is a practical value.
    // That is, if one or more of these views is not loaded, its method will
    // become a noop instead of persisting incorrect NULL/nil/zero values.
    [[self cntntViewController] autosaveAllCurrentValues] ;
    [[self settingsViewController] autosaveAllCurrentValues] ;
    [[self reportsViewController ] autosaveAllCurrentValues] ;
}

// Autosave Getters

- (NSString*)autosavedWindowFrame {
	NSArray* keyPathArray = [[self document] autosaveKeyPathArrayWithLastKeys:constAutosaveWindowFrame] ;
	NSString* windowFrame = nil ;
	if (keyPathArray) {
		windowFrame = [[NSUserDefaults standardUserDefaults] valueForKeyPathArray:keyPathArray] ;
	}
	
	// Check in case of corrupt prefs
	if (windowFrame && ![windowFrame isKindOfClass:[NSString class]]) {
		NSLog(@"Warning 856-3106 Ignoring corrupt pref") ;
		windowFrame = nil ;
	}
	
	return windowFrame ;
}

- (NSString*)autosavedContentSizeOfTabViewItem:(NSTabViewItem*)tabViewItem {
	NSString* tabViewItemIdentifier = [tabViewItem identifier] ;
	NSArray* lastKeys = [NSArray arrayWithObjects:
						 constAutosaveTabContentSizes,
						 tabViewItemIdentifier,
						 nil] ; 
	NSArray* keyPathArray = [[self document] autosaveKeyPathArrayWithLastKeys:lastKeys] ;
	NSString* sizeString = nil ;
	sizeString = [[NSUserDefaults standardUserDefaults] valueForKeyPathArray:keyPathArray] ;
	
	// Check in case of corrupt prefs
	if (sizeString && ![sizeString isKindOfClass:[NSString class]]) {
		NSLog(@"Warning 412-7826 Ignoring corrupt pref for %@", keyPathArray) ;
		sizeString = nil ;
	}
	
	return sizeString ;
}

- (NSString*)autosavedContentSplitView {
	NSArray* keyPathArray = [[self document] autosaveKeyPathArrayWithLastKeys:constAutosaveContentSplitView] ;
	NSString* split = nil ;
	if (keyPathArray) {
		split = [[NSUserDefaults standardUserDefaults] valueForKeyPathArray:keyPathArray] ;
	}
	
	// Check in case of corrupt prefs
	if (split && ![split isKindOfClass:[NSString class]]) {
		NSLog(@"Warning 944-2554 Ignoring corrupt pref") ;
		split = nil ;
	}
	
	return split ;
}

- (NSDictionary*)autosavedColumnStateForTableView:(NSTableView*)tableView {
	NSString* lastKey ;
	if ((id)tableView == (id)[self contentOutlineView]) {
		lastKey = constAutosaveContentTableColumns ;
	}
	else if (tableView == [self findTableView]) {
		lastKey = constAutosaveFindTableColumns ;
	}
	else {
		NSLog(@"Internal Error 010-4605. Bad table view %@ != %@ nor %@ in%@",
              tableView,
              [self contentOutlineView],
              [self findTableView],
              self) ;
		return nil ;
	}
	
	NSArray* keyPathArray = [[self document] autosaveKeyPathArrayWithLastKeys:lastKey] ;
	NSDictionary* answer = nil ;
	if (keyPathArray) {
		answer = [[NSUserDefaults standardUserDefaults] valueForKeyPathArray:keyPathArray] ;
	}
	
	// Check in case of corrupt prefs
	if (answer && ![answer isKindOfClass:[NSDictionary class]]) {
		NSLog(@"Warning 645-4150 Ignoring corrupt pref") ;
		answer = nil ;
	}
	
	return answer ;
}

- (NSDictionary*)tabAutosaves {
	NSArray* keyPathArray = [[self document] autosaveKeyPathArrayWithLastKeys:constAutosaveTabs] ;
	NSDictionary* autosaves = [[NSUserDefaults standardUserDefaults] valueForKeyPathArray:keyPathArray] ;
    
	// Check in case of corrupt prefs
	if (![autosaves isKindOfClass:[NSDictionary class]]) {
		if (autosaves) {
            NSLog(@"Warning 523-0952 Ignoring corrupt pref") ;
        }
        autosaves = nil ;
	}
	
    return autosaves ;
}


@end