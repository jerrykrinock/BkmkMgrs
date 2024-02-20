#import "PrefsWinCon+Autosaving.h"
#import "NSUserDefaults+KeyPaths.h"
#import "BkmxGlobals.h"
#import "BkmxDoc.h"

@implementation PrefsWinCon (Autosaving)

// This is declared in superclass NSWindowController
- (NSString*)windowTitleForDocumentDisplayName:(NSString *)displayName {
	NSMutableString* title = [NSMutableString stringWithFormat:
							  @"%@  %C  %@", 
							  displayName,
							  (unsigned short)0x25C7, // or C6, or E7
							  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]] ;
	return title ;
}

- (NSString*)uuid {
	NSString* uuid = nil ;
	
	NSDocument* document = [self document] ;
	SEL selector = @selector(uuid) ;
	if ([document respondsToSelector:selector]) {
		uuid = [document performSelector:@selector(uuid)] ;
	}
	
	return uuid ;
}

// Autosave Utility method

/*!
 @brief    Returns a key path array which may be used to access an
 autosaved value relative to the receiver's document in user defaults.
 
 @details  The answer is the array {constAutosavePrefsWindow,
 appendage}, where appendage is derived from the lastKeys parameter. 
 @param    lastKeys  If lastKeys is a string, appendage is this single
 object.  If lastKeys is an array, appends the array as multiple 
 objects.
 */
- (NSArray*)autosaveKeyPathArrayWithLastKeys:(id)lastKeys {
	NSArray* kpa = [NSArray arrayWithObjects:
					constAutosavePrefsWindow,
					nil] ;		
	if ([lastKeys respondsToSelector:@selector(objectAtIndex:)]) {
		// lastKeys is an array
		kpa = [kpa arrayByAddingObjectsFromArray:lastKeys] ;
	}
	else {
		// lastKeys is a string
		kpa = [kpa arrayByAddingObject:lastKeys] ;
	}
	
	return kpa ;
}

// Autosave Setters

// Gets notified whenever window is resized or moved
- (void)autosaveWindowFrameNote:(NSNotification*)notification {
	if (![self autosaveArmed]) {
		return ;
	}
	
	NSArray* keyPathArray = [self autosaveKeyPathArrayWithLastKeys:constAutosaveWindowFrame] ;
	if (keyPathArray) {
		[[NSUserDefaults standardUserDefaults] setValue:[[self window] stringWithSavedFrame]
										forKeyPathArray:keyPathArray] ;
	}
}

// Gets notified whenever window is resized
- (void)autosaveActiveTabViewSizeNote:(NSNotification*)notification {
	if (![self autosaveArmed]) {
		return ;
	}
	
	NSTabViewItem* tabViewItem = [self activeTabViewItem] ;
	NSString* tabViewItemIdentifier = [tabViewItem identifier] ;
	if ([self windowIsBeingAutosized]) {
		return ;
	}
	NSArray* lastKeys = [NSArray arrayWithObjects:
						 constAutosaveTabContentSizes,
						 tabViewItemIdentifier,
						 nil] ; 
	NSArray* keyPathArray = [self autosaveKeyPathArrayWithLastKeys:lastKeys] ;
	if (keyPathArray) {
		NSSize size = [[self window] frame].size ;
		size.height -= [self deadHeightForTabViewItem:tabViewItem] ;
		NSString* sizeString = NSStringFromSize(size) ;
		[[NSUserDefaults standardUserDefaults] setValue:sizeString
										forKeyPathArray:keyPathArray] ;
	}
}

- (void)autosaveSelectedTabViewItem:(NSTabViewItem*)tabViewItem
						  inTabView:(NSTabView*)tabView {
	if (![self autosaveArmed]) {
		return ;
	}
	
	NSString* identifier ;
	if (tabView == self.tabViewController.tabView) {
		identifier = constAutosaveTabTop ;
	}
	else {
		// The tabView is in a view which is itself in a parent tab view
		identifier = [(NSTabViewItem*)[(NSTabView*)[[tabView superview] superview] selectedTabViewItem] identifier] ;
	}
	NSArray* keyPathArray = [self autosaveKeyPathArrayWithLastKeys:constAutosaveTabs] ;
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
	[self autosaveSelectedTabViewItem:[self.tabViewController.tabView selectedTabViewItem]
							inTabView:self.tabViewController.tabView] ;
}

// Autosave Getters

- (NSString*)autosavedWindowFrame {
	NSArray* keyPathArray = [self autosaveKeyPathArrayWithLastKeys:constAutosaveWindowFrame] ;
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
	NSArray* keyPathArray = [self autosaveKeyPathArrayWithLastKeys:lastKeys] ;
	NSString* sizeString = nil ;
	if (keyPathArray) {
		sizeString = [[NSUserDefaults standardUserDefaults] valueForKeyPathArray:keyPathArray] ;
	}
	
	// Check in case of corrupt prefs
	if (sizeString && ![sizeString isKindOfClass:[NSString class]]) {
		NSLog(@"Warning 412-7825 Ignoring corrupt pref") ;
		sizeString = nil ;
	}
	
	return sizeString ;
}


// Integrated Getter - Displayers

- (void)restoreAutosavedTabViewSelections {
	NSArray* keyPathArray = [self autosaveKeyPathArrayWithLastKeys:constAutosaveTabs] ;
	NSDictionary* tabViewSettings = [[NSUserDefaults standardUserDefaults] valueForKeyPathArray:keyPathArray] ;
	if (!tabViewSettings) {
		return ;
	}
	
	// Check in case of corrupt prefs
	if (![tabViewSettings isKindOfClass:[NSDictionary class]]) {
		if (tabViewSettings) {
            NSLog(@"Warning 523-0989 Ignoring corrupt pref") ; // Was Warning 523-0952 until BookMacster 1.17 but that was a dupe.
        }
		return ;
	}
	
	NSString* topSetting = constIdentifierTabViewPrefsGeneral ; // default value
	for (NSString* identifier in tabViewSettings) {
		if ([identifier isEqualToString:constAutosaveTabTop]) {
			topSetting = [tabViewSettings objectForKey:identifier] ;
		}
		else {
			// Drill down two levels to set the lower-level tab
			[self revealTabViewIdentifier1:identifier
							   identifier2:[tabViewSettings objectForKey:identifier]] ;
		}
	}
	// Set the upper-level tab
	[self.tabViewController.tabView selectTabViewItemWithIdentifier:topSetting] ;
}

@end
