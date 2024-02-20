#import "PrefsWinCon.h"
#import "PrefsWinCon+Autosaving.h"
#import "BkmxBasis+Strings.h"
#import "NSString+LocalizeSSY.h"
#import "NSWindow+Sizing.h"
#import "NSTabView+Safe.h"
#import "SSYSizeFixxerSubview.h"
#import "SSYMH.AppAnchors.h"
#import "BkmxAppDel+Actions.h"
#import "NSObject+SuperUtils.h"
#import "SSYShortcutBackEnd.h"
#import "NSTabViewItem+SSYTabHierarchy.h"
#import "SSYSheetEnder.h"
#import "NSInvocation+Quick.h"
#import "NSString+SSYExtraUtils.h"
#import "SUConstants.h"  // Requires adding Sparkle source directory to Build Settings ▸ Header Search Paths.  Note that, because this header is not "public" in the Sparkle Framework build, #import "Sparkle/SUConstants.h" will not work.
#import "BkmxDocumentController.h"
#import "NSDocumentController+DisambiguateForUTI.h"
#import "SSYVectorImages.h"
#import "NSImage+Transform.h"
#import "SSYHintArrow.h"
#import "Bookshig.h"
#import "ClientListView.h"
#import "ClientInfoController.h"
#import "Client.h"
#import "SafeLimitGuider.h"
#import "IgnoredPrefixesController.h"
#import "NSInvocation+Quick.h"
#import "BkmxLazyView.h"
#import "BkmxDoc.h"
#import "SSYShortcutActuator.h"
#import "SyncNotificationsWindowController.h"
#import "SSYDynamicMenu.h"
#import "StarkContainersFlatMenu.h"
#import "SSYDooDooUndoManager.h"
#import "NSDocumentController+FrontOrder.h"
#import "SSWebBrowsing.h"

// These constants must match those in the nib
NSString* const constIdentifierTabViewPrefsGeneralSmarky = @"prefsGeneralSmarky" ;
NSString* const constIdentifierTabViewPrefsGeneralSynkmark = @"prefsGeneralSynkmark" ;
NSString* const constIdentifierTabViewPrefsGeneralMarkster = @"prefsGeneralMarkster" ;
NSString* const constIdentifierTabViewPrefsGeneralBookMacster = @"prefsGeneralBookMacster" ;
NSString* const constIdentifierTabViewPrefsGeneral = @"prefsGeneral" ; // Assigned later, not in the nib
NSString* const constIdentifierTabViewPrefsSortingShoebox = @"prefsSortingShoebox" ;
NSString* const constIdentifierTabViewPrefsSortingBookMacster = @"prefsSortingBookMacster" ;
NSString* const constIdentifierTabViewPrefsSorting = @"prefsSorting" ; // Assigned later, not in tbe nib
NSString* const constIdentifierTabViewPrefsSyncingSmarky = @"prefsSyncingSmarky" ;
NSString* const constIdentifierTabViewPrefsSyncingSynkmark = @"prefsSyncingSynkmark" ;
NSString* const constIdentifierTabViewPrefsSyncingMarkster = @"prefsSyncingMarkster" ;
NSString* const constIdentifierTabViewPrefsSyncingBookMacster = @"prefsSyncingBookMacster" ;
NSString* const constIdentifierTabViewPrefsSyncing = @"prefsSyncing" ; // Assigned later, not in the nib
NSString* const constIdentifierTabViewPrefsShortcuts = @"prefsShortcuts" ;
NSString* const constIdentifierTabViewPrefsAddingMarkster = @"prefsAddingMarkster" ;
NSString* const constIdentifierTabViewPrefsAddingBookMacster = @"prefsAddingBookMacster" ;
NSString* const constIdentifierTabViewPrefsAdding = @"prefsAdding" ; // Assigned later, not in the nib
NSString* const constIdentifierTabViewPrefsAppearanceSmarkySynkmark = @"prefsAppearanceSmarkySynkmark" ;
NSString* const constIdentifierTabViewPrefsAppearanceMarksterBookMacster = @"prefsAppearanceMarksterBookMacster" ;
NSString* const constIdentifierTabViewPrefsAppearance = @"prefsAppearance" ; // Assigned later, not in the nib
NSString* const constIdentifierTabViewPrefsUpdates = @"prefsUpdates" ;

NSString* const constKeyUpdateEagerness = @"updateEagerness" ;


@interface PrefsWinCon ()

@property (assign) BOOL autosaveArmed ;
@property (assign) BkmxDoc* theDocument ;
@property (readonly) NSMutableDictionary* targetViewSizes;

/* Current height of the client list view, not including the height of a
 single row.  In other words, the value of this property should be
 (n-1)*rowHeight, where n is the count of rows. */
@property (assign) CGFloat clientListViewExtraHeight;

@end


@implementation PrefsWinCon

@synthesize laterSize = m_laterSize ;
@synthesize autosaveArmed ;
@synthesize theDocument = m_theDocument ;

-(id)init {
    if ((self = [super initWithWindowNibName:@"PrefsWindow"])) {
    }
    
    return self;
}

- (BOOL)canHaveNoStatusItem {
    BOOL answer ;
    if ([(BkmxAppDel*)[NSApp delegate] doesLaunchInBackground] == NO) {
        answer = YES ;
    }
    else if ([(BkmxAppDel*)[NSApp delegate] hasFloatingMenu] == YES) {
        answer = YES ;
    }
    else {
        answer = NO ;
    }
    
    return answer ;
}

/* To make sure that there is enough room for all toolbar items.  I do not
 want any toolbar items "pushed to the overflow menu", as Apple calls it,
 because as it turns out for this window the maximum number of items ever
 pushed to the overflow menu is one, and there are seven items, so that is
 really stupid to have one item in the overflow menu when any of the three
 narrower tab view items is selected.  Also, note that all toolbar items are
 always visible in this window.
 
 Finally, as it turns out, in BkmkMgrs 3.0, all tabs have a target width
 <= 460.  So the window has a width of 460 for all tab selections. */
#define MINIMUM_DEAD_WIDTH_FOR_TOOLBAR 460.0

- (void)offsetSubviewsInView:(NSView*)view
             toCenterInWidth:(CGFloat)width {
    CGFloat offset = (width - view.frame.size.width) / 2;
    for (NSView* subview in view.subviews) {
        NSRect frame = subview.frame;
        frame.origin.x += offset;
        subview.frame = frame;
    }
}

- (NSMutableDictionary*)targetViewSizes {
    if (!_targetViewSizes) {
        _targetViewSizes = [NSMutableDictionary new];
    }
    return _targetViewSizes;
}

- (NSSize)targetSizeForTabViewItem:(NSTabViewItem*)item {
    NSString* targetSizeString = [self.targetViewSizes objectForKey:item.identifier];
    NSSize targetSize;
    if (!targetSizeString) {
        targetSize = item.view.frame.size;
        if (targetSize.width < MINIMUM_DEAD_WIDTH_FOR_TOOLBAR) {
            [self offsetSubviewsInView:item.view
                       toCenterInWidth:MINIMUM_DEAD_WIDTH_FOR_TOOLBAR];
            targetSize.width = MINIMUM_DEAD_WIDTH_FOR_TOOLBAR;
        }
        [self.targetViewSizes setObject:NSStringFromSize(targetSize)
                             forKey:item.identifier];
    } else {
        targetSize = NSSizeFromString(targetSizeString);
    }
    return targetSize;
}

- (id)appDelegate {
    return (BkmxAppDel*)[NSApp delegate] ;
}

+ (NSSet*)keyPathsForValuesAffectingCanHaveNoStatusItem {
    NSSet* paths = [NSSet setWithObjects:
                    @"appDelegate.doesLaunchInBackground",
                    @"appDelegate.hasFloatingMenu",
                    nil] ;
    return paths ;
}



- (ClientListView*)clientListView {
    return clientListView ;
}

// Needed to fulfill protocol, but not used
- (NSButton*)importPostprocButton {
    return nil ;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self] ;
    [_targetViewSizes release];
    [_tabViewController release];
	
	[super dealloc] ;
}

- (void)clientsDidReheightNote:(NSNotification*)note {
    if ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppSynkmark) {
        CGFloat clientListViewNewHeight = [[note.userInfo objectForKey:constKeyClientListViewNewHeight] floatValue];
        self.clientListViewExtraHeight = clientListViewNewHeight - [ClientListView rowHeight];
        NSTabViewItem* tabViewItem = [self tabViewItemWithIdentifier:constIdentifierTabViewPrefsSyncing];
        if ([self activeTabViewItem] == tabViewItem) {
            [self resizeWindowForLeafTabViewItem:tabViewItem] ;
        }
    }

    BOOL canReorder = [self.clientListView itemCount] > 1;
    if (canReorder) {
        labelReorder.hidden = NO;
    } else {
        labelReorder.hidden = YES;
    }
}

- (void)windowWillClose:(NSNotification *)notification {
    // The following should be a no-op to nil unless we are in Synkmark
    [clientListView removeObservers] ;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
    
    [[self theDocument] saveMacster] ;
}

- (void)warnLaunchInBackgroundSwitchedOff:(NSNotification*)note {
    SSYAlert* alert = [SSYAlert alert] ;
    [alert setSmallText:
     @"Because that global keyboard shortcut was the only way you had to activate BookMacster, "
     @"your preference to 'Launch in Background' has been switched off."] ;
    [alert setHelpAddress:constHelpAnchorBackgrounding] ;
    [alert runModalSheetOnWindow:[self window]
                      resizeable:NO
                   modalDelegate:nil
                  didEndSelector:NULL
                     contextInfo:NULL] ;
}

- (void)reloadNewBookmarkLandingMenu {
    BkmxDoc* bkmxDoc = [self theDocument] ;
	SSYDynamicMenu* menu = (SSYDynamicMenu*)[landingPopup menu] ;
	[menu setRepresentedObjects:[bkmxDoc bookmarkContainers]] ;
	[menu setSelectedRepresentedObject:[[bkmxDoc shig] landing]] ;
	[menu reload] ;
}

- (IBAction)updateVisitor:(NSPopUpButton*)sender {
    id newVisitor = [[sender selectedItem] representedObject] ;
    [[[self theDocument] shig] setVisitor:newVisitor] ;
}

- (IBAction)updateIgnoreDisparateDupes:(NSButton*)sender {
    NSNumber* newValue = [NSNumber numberWithBool:([sender state] == NSControlStateValueOn)] ;
    [[[self theDocument] shig] setIgnoreDisparateDupes:newValue] ;
}

- (void)updateVisitorPopup:(NSPopUpButton*)visitorPopup {
    [visitorPopup setTarget:self] ;
    [visitorPopup setAction:@selector(updateVisitor:)] ;
    NSString* targetVisitor = [[[self theDocument] shig] visitor] ;
    for (NSMenuItem* item in [visitorPopup itemArray]) {
        if ([[item representedObject] isEqual:targetVisitor]) {
            [visitorPopup selectItem:item] ;
            break ;
        }
    }
}

- (void)updateIgnoreDisparatesCheckbox:(NSButton*)checkbox {
    [checkbox setTarget:self] ;
    [checkbox setAction:@selector(updateIgnoreDisparateDupes:)] ;
    [checkbox setState:([[[[self theDocument] shig] ignoreDisparateDupes] boolValue] ? NSControlStateValueOn : NSControlStateValueOff)] ;
}

/*
 Now that I have the fancy -bindBookshigController, I could maybe replace
 some of these calls with Cocoa Bindings and have no Burps.  But for now,
 we have the following, old fashioned target-action, no KVO, which assumes that
 these contols are the only way that these values ever change. */
- (void)updateDocDependentControls {
    switch ([[BkmxBasis sharedBasis] iAm]) {
        case BkmxWhich1AppSmarky:
            [self updateVisitorPopup:visitPopupSmarkyGeneral] ;
            [self updateIgnoreDisparatesCheckbox:ignoreDisparatesCheckboxSmarkyGeneral] ;
            break ;
        case BkmxWhich1AppSynkmark:
            [self updateVisitorPopup:visitPopupSynkmarkGeneral] ;
            [self updateIgnoreDisparatesCheckbox:ignoreDisparatesCheckboxSynkmarkGeneral] ;
            break ;
        case BkmxWhich1AppMarkster:;
            [self updateVisitorPopup:visitPopupMarksterGeneral] ;
            [self updateIgnoreDisparatesCheckbox:ignoreDisparatesCheckboxMarksterGeneral] ;
             break ;
        default:
            ;
    }
}

- (NSDictionary*)bindingOptionsForValues {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @YES, NSAllowsEditingMultipleValuesSelectionBindingOption,
            @YES, NSConditionallySetsEnabledBindingOption,
            @YES, NSRaisesForNotApplicableKeysBindingOption,
            nil] ;
}

- (NSDictionary*)bindingOptionsForMetas {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @YES, NSRaisesForNotApplicableKeysBindingOption,
            nil] ;
}

#if 0
- (void)logBindingsInfo {
    NSLog(@"sortRootCheckbox : value : %@", [sortRootCheckbox infoForBinding:@"value"]) ;
    NSLog(@"ignoreCommonPrefixesCheckbox : value: %@", [ignoreCommonPrefixesCheckbox infoForBinding:@"value"]) ;
    NSLog(@"ignoreCommonPrefixesCheckbox : enabled : %@", [ignoreCommonPrefixesCheckbox infoForBinding:@"enabled"]) ;
    NSLog(@"defaultSortableMatrix : selectedTag : %@", [defaultSortableMatrix infoForBinding:@"selectedTag"]) ;
    NSLog(@"sortByMatrix : selectedTag : %@", [sortByMatrix infoForBinding:@"selectedTag"]) ;
    NSLog(@"sortingSegmentationMatrix : selectedTag : %@", [sortingSegmentationMatrix infoForBinding:@"selectedTag"]) ;
    NSLog(@"sortWhichSegmentsMatrix : selectedTag : %@", [sortWhichSegmentsMatrix infoForBinding:@"selectedTag"]) ;
    NSLog(@"bookshigController : managedObjectContext : %@", [bookshigController infoForBinding:@"managedObjectContext"]) ;
}
#endif

/*
 After fighting Cocoa Bindings Burps with this stupid thing for months, I
 finally decided to give up and bind the items in the Sorting - Shoebox tab
 *manually* to the Bookshig Controller, and bind the Bookshig Controller to 
 the shoebox document manually.  The last straw was this bug:
 * Activate BookMacster.
 * Open three documents (so there will be lots of window closing action,
      and -updateTheDocument will be invoked multiple times)
 * Open Preferences.
 * Click in the Status Item menu: Background BookMacster.
 Result: Bindings Burp saying that the action cannot be completed without a
 managed object context.
 
 After fighting this particular bug for several hours, I concluded that this
 was the only reliable way to fix it.  I copied all of the bindings from
 Interface Builder into this method, and removed them from Interface Builder.
 
 One of the issues is that, it seems, when you remove a tab view item, and
 even if you replace its view with an empty view, the controls in the view
 sometimes hang around.
 */
- (void)bindBookshigController {
    [sortRootCheckbox bind:@"value"
                  toObject:bookshigController
               withKeyPath:@"selection.rootSortable"
                   options:[self bindingOptionsForValues]] ;
    [ignoreCommonPrefixesCheckbox bind:@"value"
                              toObject:bookshigController
                           withKeyPath:@"selection.filterIgnoredPrefixes"
                               options:[self bindingOptionsForValues]] ;
    [ignoreCommonPrefixesCheckbox bind:@"enabled"
                              toObject:bookshigController
                           withKeyPath:@"selection.canFilterIgnoredPrefixes"
                               options:[self bindingOptionsForMetas]] ;
    [defaultSortableMatrix bind:@"selectedTag"
                       toObject:bookshigController
                    withKeyPath:@"selection.defaultSortable"
                        options:[self bindingOptionsForValues]] ;
    [sortByMatrix bind:@"selectedTag"
              toObject:bookshigController
           withKeyPath:@"selection.sortBy"
               options:[self bindingOptionsForValues]] ;
    [sortingSegmentationMatrix bind:@"selectedTag"
                     toObject:bookshigController
                  withKeyPath:@"selection.segmentConfiguration"
                      options:[self bindingOptionsForValues]] ;
    [sortWhichSegmentsMatrix bind:@"selectedTag"
                         toObject:bookshigController
                      withKeyPath:@"selection.sortWhichSegments"
                          options:[self bindingOptionsForValues]] ;
    [sortWhichSegmentsMatrix bind:@"enabled"
                         toObject:bookshigController
                      withKeyPath:@"selection.canPickSortWhichSegments"
                          options:[self bindingOptionsForValues]] ;
    [bookshigController bind:@"managedObjectContext"
                    toObject:self
                 withKeyPath:@"theDocument.managedObjectContext"
                     options:[self bindingOptionsForMetas]] ;
    [bookshigController prepareContent] ;
}

- (void)updateTheDocument {
    BkmxDoc* doc = (BkmxDoc*)[[BkmxDocumentController sharedDocumentController] currentDefaultDocumentAggressively] ;
    [self setTheDocument:doc] ;
}

- (void)awakeFromNib {
    // Lockout required due to use of BkmxLazyView in PrefsWindow.xib
    if (m_isAwaked) {
        return ;
    }
    [self safelySendSuperSelector:_cmd
                  prettyFunction:__PRETTY_FUNCTION__
                       arguments:nil];
    m_isAwaked = YES ;
    
    self.window.contentView.wantsLayer = YES;
    self.tabView.wantsLayer = YES;
    
    SSYTabViewController* tabViewController = [SSYTabViewController new];
    self.tabViewController = tabViewController;
    [tabViewController release];
    self.tabViewController.tabStyle = NSTabViewControllerTabStyleToolbar;
    /* The following two lines seem redundant, but they are not.
     Both lines are necessary or the tab view controller will not
     propagate its tab view items into its tab view.  Also, note that the
     following line sets tabView.delegate = tabViewController, and we
     are not allowed to change the delegate.  Raises assertion if you try ;) */
    self.tabViewController.tabView = self.tabView;
    self.tabViewController.view = self.tabView;
    /* So since we cannot be the delegate, */
    self.tabViewController.surrogate = self;

    if ([[BkmxBasis sharedBasis] isShoeboxApp]) {
        [self bindBookshigController] ;
    }
    
    if (@available(macOS 10.16, *)) {
        self.window.toolbarStyle = NSWindowToolbarStylePreference;
    }
    self.toolbar.delegate = self;
    self.toolbar.displayMode = NSToolbarDisplayModeIconAndLabel;
    
    BOOL hasShortcutsTab = YES ;
    switch ([[BkmxBasis sharedBasis] iAm]) {
        case BkmxWhich1AppSmarky:
            [self addTabViewItemWithView:self.viewGeneralSmarky
                                   label:[[BkmxBasis sharedBasis] labelGeneral]
                              identifier:constIdentifierTabViewPrefsGeneral];
            [self addTabViewItemWithView:self.viewSortingShoebox
                                   label:[[BkmxBasis sharedBasis] labelSorting]
                              identifier:constIdentifierTabViewPrefsSorting];
            [self addTabViewItemWithView:self.viewSyncingSmarky
                                   label:[[BkmxBasis sharedBasis] labelSyncing]
                              identifier:constIdentifierTabViewPrefsSyncing];
            [self addTabViewItemWithView:self.viewAppearanceSmarkySynkmark
                                   label:NSLocalizedString(@"appearance", nil)
                              identifier:constIdentifierTabViewPrefsAppearance];
            [self addTabViewItemWithView:self.viewUpdates
                                   label:[[BkmxBasis sharedBasis] labelUpdates]
                              identifier:constIdentifierTabViewPrefsUpdates];

            clientListView = nil ; // See Note clvCrasher
            clientUpArrow = nil ;
            clientDownArrow = nil ;
            landingPopup = nil ;
            visitPopupSynkmarkGeneral = nil ;
            visitPopupMarksterGeneral = nil ;
            ignoreDisparatesCheckboxSynkmarkGeneral = nil ;
            ignoreDisparatesCheckboxMarksterGeneral = nil ;
            syncSnapshotsLimitFormatterSmarky.maximum = @(SNAPSHOT_MAX_LIMIT_MB);
            break;
        case BkmxWhich1AppSynkmark:
            [self addTabViewItemWithView:self.viewGeneralSynkmark
                                   label:[[BkmxBasis sharedBasis] labelGeneral]
                              identifier:constIdentifierTabViewPrefsGeneral];
            [self addTabViewItemWithView:self.viewSortingShoebox
                                   label:[[BkmxBasis sharedBasis] labelSorting]
                              identifier:constIdentifierTabViewPrefsSorting];
            [self addTabViewItemWithView:self.viewSyncingSynkmark
                                   label:[[BkmxBasis sharedBasis] labelSyncing]
                              identifier:constIdentifierTabViewPrefsSyncing];
            [self addTabViewItemWithView:self.viewAppearanceSmarkySynkmark
                                   label:NSLocalizedString(@"appearance", nil)
                              identifier:constIdentifierTabViewPrefsAppearance];
            [self addTabViewItemWithView:self.viewUpdates
                                   label:[[BkmxBasis sharedBasis] labelUpdates]
                              identifier:constIdentifierTabViewPrefsUpdates];

            landingPopup = nil ;
            hasShortcutsTab = NO ;
            visitPopupSmarkyGeneral = nil ;
            visitPopupMarksterGeneral = nil ;
            ignoreDisparatesCheckboxSmarkyGeneral = nil ;
            ignoreDisparatesCheckboxMarksterGeneral = nil ;
            syncSnapshotsLimitFormatterSynkmark.maximum = @(SNAPSHOT_MAX_LIMIT_MB);
            break ;
        case BkmxWhich1AppMarkster:
            [self addTabViewItemWithView:self.viewGeneralMarkster
                                   label:[[BkmxBasis sharedBasis] labelGeneral]
                              identifier:constIdentifierTabViewPrefsGeneral];
            [self addTabViewItemWithView:self.viewSortingShoebox
                                   label:[[BkmxBasis sharedBasis] labelSorting]
                              identifier:constIdentifierTabViewPrefsSorting];
            [self addTabViewItemWithView:self.viewSyncingMarkster
                                   label:NSLocalizedString(@"Exporting", nil)
                              identifier:constIdentifierTabViewPrefsSyncing];
            [self addTabViewItemWithView:self.viewShortcuts
                                   label:NSLocalizedString(@"Shortcuts", nil)
                              identifier:constIdentifierTabViewPrefsShortcuts];
            [self addTabViewItemWithView:self.viewAddingMarkster
                                   label:NSLocalizedString(@"adding", nil)
                              identifier:constIdentifierTabViewPrefsAdding];
            [self addTabViewItemWithView:self.viewAppearanceMarksterBookMacster
                                   label:NSLocalizedString(@"appearance", nil)
                              identifier:constIdentifierTabViewPrefsAppearance];
            [self addTabViewItemWithView:self.viewUpdates
                                   label:[[BkmxBasis sharedBasis] labelUpdates]
                              identifier:constIdentifierTabViewPrefsUpdates];

            clientListView = nil ; // See Note clvCrasher
            clientUpArrow = nil ;
            clientDownArrow = nil ;
            visitPopupSmarkyGeneral = nil ;
            visitPopupSynkmarkGeneral = nil ;
            ignoreDisparatesCheckboxSmarkyGeneral = nil ;
            ignoreDisparatesCheckboxSynkmarkGeneral = nil ;
            syncSnapshotsLimitFormatterMarkster.maximum = @(SNAPSHOT_MAX_LIMIT_MB);
            break ;
        case BkmxWhich1AppBookMacster:
            [self addTabViewItemWithView:self.viewGeneralBookMacster
                                   label:[[BkmxBasis sharedBasis] labelGeneral]
                              identifier:constIdentifierTabViewPrefsGeneral];
            [self addTabViewItemWithView:self.viewSortingBookMacster
                                   label:[[BkmxBasis sharedBasis] labelSorting]
                              identifier:constIdentifierTabViewPrefsSorting];
            [self addTabViewItemWithView:self.viewSyncingBookMacster
                                   label:[[BkmxBasis sharedBasis] labelSyncing]
                              identifier:constIdentifierTabViewPrefsSyncing];
            [self addTabViewItemWithView:self.viewShortcuts
                                   label:NSLocalizedString(@"Shortcuts", nil)
                              identifier:constIdentifierTabViewPrefsShortcuts];
            [self addTabViewItemWithView:self.viewAddingBookMacster
                                   label:NSLocalizedString(@"adding", nil)
                              identifier:constIdentifierTabViewPrefsAdding];
            [self addTabViewItemWithView:self.viewAppearanceMarksterBookMacster
                                   label:NSLocalizedString(@"appearance", nil)
                              identifier:constIdentifierTabViewPrefsAppearance];
            [self addTabViewItemWithView:self.viewUpdates
                                   label:[[BkmxBasis sharedBasis] labelUpdates]
                              identifier:constIdentifierTabViewPrefsUpdates];

            clientListView = nil ; // See Note clvCrasher
            clientUpArrow = nil ;
            clientDownArrow = nil ;
            landingPopup = nil ;
            visitPopupSmarkyGeneral = nil ;
            visitPopupSynkmarkGeneral = nil ;
            visitPopupMarksterGeneral = nil ;
            ignoreDisparatesCheckboxSmarkyGeneral = nil ;
            ignoreDisparatesCheckboxSynkmarkGeneral = nil ;
            ignoreDisparatesCheckboxMarksterGeneral = nil ;
            syncSnapshotsLimitFormatterBookMacster.maximum = @(SNAPSHOT_MAX_LIMIT_MB);
            break ;
    }
    
    [self updateTheDocument] ;

    // Arrow images in Clients tab (Synkmark only)
    if (clientUpArrow && clientDownArrow) {
        NSImage* arrowImage = [SSYVectorImages imageStyle:SSYVectorImageStyleTriangle53
                                                   wength:[clientUpArrow frame].size.width
                                                    color:nil
                                             darkModeView:nil // For this template image, Cocoa will handle luminance inversion when in Dark Mode
                                            rotateDegrees:0.0
                                                    inset:0.0] ;
        [clientUpArrow setImage:arrowImage] ;
        arrowImage = [arrowImage imageRotatedByDegrees:180.0] ;
        [clientDownArrow setImage:arrowImage] ;
    }
    
	if (hasShortcutsTab) {
        [shortcutBackEndAnywhereMenu awakeWithSelectorName:@"popUpAnywhereMenu"] ;
        [shortcutBackEndAddQuickly awakeWithSelectorName:@"landNewBookmarkQuickly"] ;
        [shortcutBackEndAddAndInspect awakeWithSelectorName:@"landNewBookmarkAndInspect"] ;
        [shortcutBackEndAnywhereMenu setIgnoreThisAppValidation:YES] ;
        [shortcutBackEndAddQuickly setIgnoreThisAppValidation:YES] ;
        [shortcutBackEndAddAndInspect setIgnoreThisAppValidation:YES] ;
    }
    else {
        shortcutBackEndAnywhereMenu = nil ;
        shortcutBackEndAddQuickly = nil ;
        shortcutBackEndAddAndInspect = nil ;
        shortcutRecorderAnywhereMenu = nil ;
        shortcutRecorderAddQuickly = nil ;
        shortcutRecorderAddAndInspect = nil ;
    }
    
    if (clientListView) {
        // We are in Synkmark
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clientsDidReheightNote:)
                                                     name:constNoteClientListViewDidReheight
                                                   object:clientListView] ;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(warnLaunchInBackgroundSwitchedOff:)
                                                 name:constNoteLaunchInBackgroundSwitchedOff
                                               object:(BkmxAppDel*)[NSApp delegate]] ;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bkmxDocOpenOrClose:)
                                                 name:constNoteBkmxWindowsDidRearrange
                                               object:nil] ;
    // constNoteBkmxWindowsDidRearrange was found to work in edge cases where
    // SSYUndoManagerDocumentDidOpenNotification does not.

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(bkmxDocOpenOrClose:)
												 name:SSYUndoManagerDocumentWillCloseNotification
											   object:nil] ;
    
    StarkContainersFlatMenu* newBookmarkLandingMenu = (StarkContainersFlatMenu*)[landingPopup menu] ;
	[newBookmarkLandingMenu setTarget:[[self theDocument] shig]] ;
	[newBookmarkLandingMenu setSelector:@selector(setNewBookmarkLandingFromMenuItem:)] ;
	[newBookmarkLandingMenu setOwningPopUpButton:landingPopup] ;
	[self reloadNewBookmarkLandingMenu] ;
    
    [self updateDocDependentControls] ;

	/* The reason why we just don't set this image in Interface Builder is
     because I don't see any checkbox in Interface Builder to set the
     `template` property.  */
    if (appleMenuExtras) {
        NSImage* image = [NSImage imageNamed:@"AppleMenuExtras"];
        image.template = YES;
        /* Setting isTemplate will cause image luminance to flip in Dark Mode,
         based on the *alpha channel* of the image. */
       [appleMenuExtras setImage:image];
    }
}

- (NSString*)localizeString:(NSString*)key {
	NSString* value = [NSString localize:key] ;
	if (!value) {
		value = key ;
	}
	
	return value ;
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar
     itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier
 willBeInsertedIntoToolbar:(BOOL)flag {
    NSToolbarItem* item = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    item.image = [NSImage imageNamed:itemIdentifier];
    item.target = self;
    item.action = @selector(selectTabViewItem:);
    item.tag = toolbar.items.count;

    return item;
}

- (void)addTabViewItemWithView:(NSView*)view
                         label:(NSString*)label
                    identifier:(NSString*)identifier {
    NSViewController* childViewController = [NSViewController new];
    childViewController.view = view;
    view.wantsLayer = YES;
    /* Yes, the following would be less code if I used the convenient method
     -[NSViewController addChildViewController:] instead of
     -[NSTabViewController insertTabViewItem:atIndex:].  However, I do it this
     way because, if this is the first tab view item being added, the tab view
     controller will select it, which will run -tabView:willSelectTabViewItem:,
     which will run targetSizeForTabViewItem:, which needs the tab view item
     to have an identifier to use as a key in  in self.targetViewSizes.
     Using the convenient method, all of this happens before I can set
     tabViewItem.identifier. */
    NSTabViewItem* tabViewItem = [NSTabViewItem new];
    tabViewItem.identifier = identifier;
    tabViewItem.label = label;
    tabViewItem.view = childViewController.view;
    tabViewItem.viewController = childViewController;
    [childViewController release];
    [self.tabViewController insertTabViewItem:tabViewItem atIndex:self.tabViewController.tabViewItems.count];
    [tabViewItem release];
    NSInteger index = self.toolbar.items.count;
    [self.toolbar insertItemWithItemIdentifier:identifier
                                       atIndex:index];
    [self.toolbar.items objectAtIndex:index].label = label;
}


char *constUpdateDifferee[] = {
	"",
	"/beta",
	"/alpha"
} ;

- (NSArray*)updateFeeds {
    NSMutableArray* feeds = [[NSMutableArray alloc] initWithCapacity:4] ;
    NSString* appNameLower = [[[BkmxBasis sharedBasis] appNameUnlocalized] lowercaseString] ;
    for (NSInteger i=0; i<3; i++) {
        NSString* feed = [NSString stringWithFormat:
                          @"%@/%@%@/%@",
                          constSparkleFeedPrefix,
                          appNameLower,
                          [NSString stringWithUTF8String:constUpdateDifferee[i]],
                          constSparkleFeedSuffix] ;
        [feeds addObject:feed] ;
    }
    
    NSArray* answer = [[feeds copy] autorelease] ;
    [feeds release] ;
    return answer ;
}


- (NSInteger)updateEagerness {
	// The following is kind of messy.
	// I wish Sparkle Project would have provided a delegate outlet for
	// SUFeedURLKey instead of looking in User Defaults.
	
	// Default value of 0 is in case of corrupt prefs.
	NSInteger updateEagerness = 0 ;
	
	NSString* feed = [[NSUserDefaults standardUserDefaults] objectForKey:SUFeedURLKey] ;
    for (NSString* aFeed in [self updateFeeds]) {
        if ([aFeed isEqualToString:feed]) {
            break ;
        }
        updateEagerness++ ;
    }

	return updateEagerness ;
}

- (BOOL)updateBeta {	
	BOOL flag = ([self updateEagerness] > 0) ;
    return flag ;
}

- (BOOL)updateAlpha {	
	BOOL flag = ([self updateEagerness] > 1) ;
	return flag ;
}

+ (NSSet*)keyPathsForValuesAffectingUpdateAlpha {
    return [NSSet setWithObjects:
            constKeyUpdateEagerness,
            nil] ;
}

+ (NSSet*)keyPathsForValuesAffectingUpdateBeta {
    return [NSSet setWithObjects:
            constKeyUpdateEagerness,
            nil] ;
}

- (void)setUpdateEagerness:(NSInteger)newEagerness {
	// The following is kind of messy.
	// I wish Sparkle Project would have provided a delegate outlet for
	// SUFeedURLKey instead of looking in User Defaults.	
	NSString* feed = [[self updateFeeds] objectAtIndex:newEagerness] ;
	[[NSUserDefaults standardUserDefaults] setObject:feed
											  forKey:SUFeedURLKey] ;
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

- (void)setUpdateBeta:(BOOL)yn {
	[self setUpdateEagerness:(yn ? 1 : 0)] ;
}

- (void)setUpdateAlpha:(BOOL)yn {
	[self setUpdateEagerness:(yn ? 2 : 1)] ;
}


/*
 When user switches to a non-leaf tab view item, as far as the
 required window size is concerned, they are switching to the
 selected bottom "leaf" in the tab view hierarchy.  This method
 makes that correction, if necessary.
 
 I could use -selectedLeafmostTabViewItem instead of this.
 */
- (NSTabViewItem*)leafTabViewItemForTabViewItem:(NSTabViewItem*)tabViewItem {
	/* Insert code here if any tab view items are not leaves */
	
	return tabViewItem ;
}

- (NSInteger)indexOfTabViewItemWithIdentifier:(NSString*)identifier {
    NSArray* items = [self.tabViewController tabViewItems];
    NSInteger index = 0;
    BOOL goodIndex = NO;
    for (NSTabViewItem* item in items) {
        if ([item.identifier isEqualToString:identifier]) {
            goodIndex = YES;
            break;
        }
        index++;
    }
    
    if (!goodIndex) {
        index = NSNotFound;
    }

    return index;
}

- (NSTabViewItem*)tabViewItemAtIndex:(NSInteger)index {
    return [[self.tabViewController tabViewItems] objectAtIndex:index];
}

/* This method will return nil if the identified tab view item has not been
 added yet, which may occur if called via -clientListViewDidReheight with
 identifer constIdentifierPrefsTabSyncing. */
- (NSTabViewItem*)tabViewItemWithIdentifier:(NSString*)identifier {
    NSInteger index = [self indexOfTabViewItemWithIdentifier:identifier];
    NSTabViewItem* tabViewItem;
    if ((index != NSNotFound) && (index < self.tabViewController.tabViewItems.count)) {
        tabViewItem = [self tabViewItemAtIndex:index];
    } else {
        tabViewItem = nil;
    }
    
    return tabViewItem;
}

- (void)selectTabViewItem:(NSToolbarItem*)sender {
    [self selectTabViewItemWithIdentifier:[sender itemIdentifier]];
}

- (NSTabViewItem*)selectedTabViewItem {
    NSInteger index = [self.tabViewController selectedTabViewItemIndex];
    return [self.tabViewController.tabViewItems objectAtIndex:index];
}

- (void)selectTabViewItemWithIdentifier:(NSString*)identifier {
    self.tabViewController.selectedTabViewItemIndex = [self indexOfTabViewItemWithIdentifier:identifier];
}

- (NSTabViewItem*)activeTabViewItem {
	return [self leafTabViewItemForTabViewItem:[self selectedTabViewItem]] ;
}

- (NSString*)activeTabViewItemIdentifier {
	return [[self activeTabViewItem] identifier] ;
}

- (void)revealTabViewIdentifier1:(NSString*)identifier1
					 identifier2:(NSString*)identifier2 {
	// The ..Safely.. version is used because I have seen exceptions
	// raised in difficult-to-reproduce corner cases.
	[self selectTabViewItemWithIdentifier:identifier1] ;
	
	if (identifier2) {
        NSTabViewItem* topSelectedTabViewItem = [self selectedTabViewItem] ;
		NSTabView* deeperTabView = [topSelectedTabViewItem deeperTabView] ;
        // The ..Safely.. version is used because I have seen exceptions
        // raised in difficult-to-reproduce corner cases.
        [deeperTabView selectTabViewItemSafelyWithIdentifier:identifier2] ;
	}
	
	[[self window] display] ;
}

- (NSInteger)depthOfTabViewIdentifier:(NSString*)identifier {
	/* Insert code here to return >1 if there are nested tabs */
	return 0 ;
}

- (void)tabViewIdentifiersForLeafIdentifier:(NSString*)leafIdentifier
									  id1_p:(NSString**)id1_p
									  id2_p:(NSString**)id2_p {
	if ([self depthOfTabViewIdentifier:leafIdentifier] == 0) {
		*id1_p = leafIdentifier ;
	}
	/* Insert 'else if' here if there are nested tabs */
}

- (NSArray*)displayedTabViewIdentifiers {
	NSMutableArray* array = [NSMutableArray array] ;
	NSTabViewItem* selectedTabViewItemLevel1 = [self selectedTabViewItem] ;
	if (selectedTabViewItemLevel1) {
		[array addObject:[selectedTabViewItemLevel1 identifier]] ;
        
        NSTabView* deeperTabView = [selectedTabViewItemLevel1 deeperTabView] ;
        NSTabViewItem* selectedTabViewItemLevel2 = [deeperTabView selectedTabViewItem] ;
        
		if (selectedTabViewItemLevel2) {
            [array addObject:[selectedTabViewItemLevel2 identifier]] ;
        }
	}
    
	return [[array copy] autorelease] ;
}

/*!
 @brief    Returns the difference between the window height and the tab view
 height for a given tab view item.
 
 @details  This difference is composed of the title bar height, toolbar height,
 and, for non-root tab view items, the height of the tab 
 control used for selecting the non-root tab view item, and the whitespace above
 and below it.
 */
- (CGFloat)deadHeightForTabViewItem:(NSTabViewItem*)tabViewItem {
	CGFloat deadHeight = [[self window] tootlebarHeight];
	NSInteger depth = [self depthOfTabViewIdentifier:[tabViewItem identifier]] ;
	if (depth > 0) {
		// Not used at this time
	}

	return deadHeight ;
}

#define SYNCING_TAB_VIEW_HEIGHT_NOT_INCLUDING_CLIENT_LIST 330.0

// This method should only run in Synkmark
- (CGFloat)syncingTabMinimumHeight {
    CGFloat answer ;
    if (clientListView == nil) {
        // Signify fixed height with this…
        answer = 0.0 ;
    }
    else {
        answer = (SYNCING_TAB_VIEW_HEIGHT_NOT_INCLUDING_CLIENT_LIST + [clientListView currentHeight]) ;
    }
    
    return answer ;
}

#define WINDOW_SIDE_MARGINS_TO_CLIENT_LIST_VIEW 2*20.0

- (NSSize)minimumSizeForTabViewItem:(NSTabViewItem*)tabViewItem {
	NSString* identifier = [tabViewItem identifier] ;
	
	// IMPORTANT: In the constants that follow, if the width or height is 0.0,
	// this indicates that the width or height is FIXED because 
	// there are no stretchable subviews in that dimension.
	
	// The sizes given in the code here are those needed for the control subviews 
	// ane their whitespace only
	//    not including the title bar
	//    not including the toolbar
	//    not including the segmented control for selecting second-level tab
	
	NSSize size ;
	
	/* Insert 'if' branches here if there are user-resizeable tabs. */
	if  ([identifier isEqualToString:constIdentifierTabViewPrefsSyncing]) {
        CGFloat width = [[self clientListView] requiredWidth];
        width += WINDOW_SIDE_MARGINS_TO_CLIENT_LIST_VIEW;
        if (width < 520.0) {
            width = 520.0;
        }

		size = NSMakeSize(width, [self syncingTabMinimumHeight]) ;
	}
	else {
		// Size is *fixed* for the other tabs.  We signify that thus ...
		size = NSZeroSize ;
	}
	
	return size ;
}

/*!
 @param    tabViewItem  Must be a leaf tab view item
 */
- (NSSize)sizeForTabViewItem:(NSTabViewItem*)tabViewItem {
	// Algorithm for determining current window size for this tab view item:
	
	// If default dimension is 0, this dimension is fixed.  Use the fixed size.
	// Else, if there is an autosaved frame, use its dimension, subject to minimum.
	// Else, use the default dimension, use its dimension, subject to minimum.
	
	NSSize newSize = [self targetSizeForTabViewItem:tabViewItem];
    newSize.width = MAX(newSize.width, MINIMUM_DEAD_WIDTH_FOR_TOOLBAR);
    newSize.width = newSize.width ;
	
	return newSize ;
}

// This method was copied from BkmxDocWinCon
- (NSRect)windowFrameForTabViewItem:(NSTabViewItem*)tabViewItem
                        tabViewSize:(NSSize)tabViewSize {
	NSRect frame = [[self window] frame] ;
    
	// If both of the given tab view dimensions are 0.0, just return the current window frame
	if ((tabViewSize.width != 0.0) || (tabViewSize.height != 0.0)) {
		if (tabViewSize.width > 0.0) {
			CGFloat x = frame.origin.x ;
			CGFloat w = frame.size.width ;
			
			x += (w - tabViewSize.width)/2 ;
			frame.origin.x = x ;
			frame.size.width = tabViewSize.width ;
		}
		
		if (tabViewSize.height > 0.0) {
			CGFloat y = frame.origin.y ;
			CGFloat h = frame.size.height ;
			CGFloat deadHeight = [self deadHeightForTabViewItem:tabViewItem] ;
            CGFloat newWindowHeight = tabViewSize.height + deadHeight ;
            NSTabViewItem* syncingTabViewItem = [self tabViewItemWithIdentifier:constIdentifierTabViewPrefsSyncing];
            if (syncingTabViewItem) {
                if (tabViewItem == syncingTabViewItem) {
                    newWindowHeight += self.clientListViewExtraHeight;
                }
            }
			frame.origin.y = y + h - newWindowHeight ;
			frame.size.height = newWindowHeight ;
		}
	}
	
	return frame ;
}

- (void)resizeWindowForTabViewItem:(NSTabViewItem*)tabViewItem
							  size:(NSSize)tabViewSize {
	NSRect frame = [self windowFrameForTabViewItem:tabViewItem
                                       tabViewSize:tabViewSize] ;
    
	// If windowFrameForTabViewItem:tabViewSize: simply returned the current
	// window frame, don't do anything
	if (
		([[self window] frame].size.width != frame.size.width)
		||
		([[self window] frame].size.height != frame.size.height)
		) {
		[self setWindowIsBeingAutosized:YES] ;
		[[self window] setFrame:frame
						display:YES
						animate:YES] ;
		[self setWindowIsBeingAutosized:NO] ;
	}
}

- (void)resizeWindowForLeafTabViewItem:(NSTabViewItem*)tabViewItem {
    NSSize size = [self sizeForTabViewItem:tabViewItem] ;
    [self resizeWindowForTabViewItem:tabViewItem
                                size:size] ;
}

- (void)constrainWindowSizeForTabViewItem:(NSTabViewItem*)tabViewItem {
	NSWindow* window = [self window] ;
	NSSize contentMinSize = [self minimumSizeForTabViewItem:tabViewItem] ;
	BOOL isUserSizeable = ((contentMinSize.width > 0.0) || (contentMinSize.height > 0.0)) ;

	NSUInteger styleMask = [window styleMask] ;
	if (isUserSizeable) {
		styleMask |= NSWindowStyleMaskResizable ;
	}
	else {
		styleMask &= ~NSWindowStyleMaskResizable ;
	}
	[window setStyleMask:styleMask] ;
    CGFloat deadHeight = [self deadHeightForTabViewItem:tabViewItem] ;
    CGFloat windowContentMinHeight = contentMinSize.height + deadHeight - [window tootlebarHeight] ;
    NSSize windowMinContentSize = NSMakeSize(contentMinSize.width, windowContentMinHeight) ;
	// Note that in the case of a fixed-size tab, we may be setting the
	// minimum width and height to very small or zero here, but that is of no
	// consequence since the window will not be resizeable.
	[window setContentMinSize:windowMinContentSize] ;
    // I tried -setMinSize: instead of -setContentMinSize:, so I could avoid
    // subtracting out the tootlebar height, but inexplicably it did not work…
    // http://lists.apple.com/archives/cocoa-dev/2013/Aug/msg00526.html
}

- (void)resizeWindowAndConstrainSizeForActiveTabViewItem {
	NSTabViewItem* tabViewItem = [self activeTabViewItem] ;
    NSTabViewItem* leafmostItem = [tabViewItem selectedLeafmostTabViewItem] ;
	NSSize size = [self sizeForTabViewItem:leafmostItem]  ;
	[self resizeWindowForTabViewItem:tabViewItem
								size:size] ;
    // Note that we resized the window *before* constraining the size, because,
    // and this is obliquely in NSWindow documentation, -setMinSize will *not*
    // override the size if it is set by -setFrame:display:.
	[self constrainWindowSizeForTabViewItem:tabViewItem] ;
}


// NSTabView delegate messages:

/*
 See comments: "Window resizing may be nonlinear and nonreversible" in
 BkmxDocWinCon.m
 */
- (void)       tabView:(NSTabView*)tabView
 willSelectTabViewItem:(NSTabViewItem*)newItem {
	// Gather data on current item
	NSTabViewItem* nowItem = [self activeTabViewItem] ;
	NSSize currentSize = [[self window] frame].size ;
	currentSize.height -= [self deadHeightForTabViewItem:nowItem] ;
    
	// In case this the item is not the actual leaf
	NSTabViewItem* newLeafItem = [newItem selectedLeafmostTabViewItem] ;
    NSSize newSize = [self targetSizeForTabViewItem:newLeafItem];
    
	CGFloat doNowWidth ;
	CGFloat doLaterWidth ;
	if (newSize.width > currentSize.width) {
		doNowWidth = newSize.width ;
		doLaterWidth = 0.0 ;
	}
	else {
		doNowWidth = 0.0 ;
		doLaterWidth = newSize.width ;
	}
	
	CGFloat doNowHeight ;
	CGFloat doLaterHeight ;
	if (newSize.height > currentSize.height) {
		doNowHeight = newSize.height ;
		doLaterHeight = 0.0 ;
	}
	else {
		doNowHeight = 0.0 ;
		doLaterHeight = newSize.height ;
	}
	
    NSSize doNowSize = NSMakeSize(doNowWidth, doNowHeight) ;
    [self resizeWindowForTabViewItem:newLeafItem
                                size:doNowSize] ;
    
	NSSize doLaterSize = NSMakeSize(doLaterWidth, doLaterHeight) ;
	[self setLaterSize:doLaterSize] ;
}

#if 0
- (BOOL)           tabView:(NSTabView*)tabView
   shouldSelectTabViewItem:(NSTabViewItem*)tabViewItem {
	if (
        ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppSynkmark)
        &&
		([[[tabView selectedTabViewItem] identifier] isEqualToString:constIdentifierTabViewPrefsSyncing])
		&&
		(![[tabViewItem identifier] isEqualToString:constIdentifierTabViewPrefsSyncing])
		) {
		// Synkmark user is moving OUT of Syncing tab view
		[[[self theDocument] shig] userDidEndFussingWithClients] ;
	}
	
	return YES ;
}
#endif

- (void)       tabView:(NSTabView*)tabView
  didSelectTabViewItem:(NSTabViewItem*)tabViewItem {
    // BOOL c1, c2 were added in BookMacster 1.17, to fix some weird edge
    // cases wherein laterSize could have some prior crap in it.  Also note that
    // we then set laterSize to NSZeroSize after we're done reading it once.
    BOOL c1 = ([self laterSize].width > 0.0) ;
    BOOL c2 = ([self laterSize].height > 0.0) ;
    // Do resizing as needed
    if (c1 || c2) {
		[self resizeWindowForTabViewItem:tabViewItem
									size:[self laterSize]] ;
        [self setLaterSize:NSZeroSize] ;
	}
    
    // Note that we resized the window *before* constraining the size, because,
    // and this is obliquely in NSWindow documentation, -setMinSize will *not*
    // override the size if it is set by -setFrame:display:.
    [self constrainWindowSizeForTabViewItem:tabViewItem] ;

    if ([[tabViewItem identifier] isEqualToString:constIdentifierTabViewPrefsSyncing]) {
        [self.clientListView performSelector:@selector(update)
                                  withObject:nil
                                  afterDelay:0.0] ;
    }
}

- (void)bkmxDocOpenOrClose:(NSNotification*)note {
    /* This gets invoked twice when a document closes.  The 1st time, caused by
     SSYUndoManagerDocumentWillCloseNotification, it re-sets theDocument to its
     current value, because currentDefaultDocumentAggressively is still
     returning that because doc has not closed yet.  The second time, caused by
     constNoteBkmxWindowsDidRearrange, it sets theDocument to nil.  Be very
     careful if you mess with this.  Test in shoebox apps, and test in
     BookMacster with multiple document windows open.  */
    NSString* noteName = [note name] ;
    if (
        [noteName isEqualToString:SSYUndoManagerDocumentWillCloseNotification]
        &&
        ([self theDocument] == [note object])
        ) {
        [self setTheDocument:nil] ;
    }
    else {
        [self updateTheDocument] ;
    }
    
    NSInvocation* invocation = [NSInvocation invocationWithTarget:self
                                                         selector:@selector(updateDocDependentControls)
                                                  retainArguments:YES
                                                argumentAddresses:NULL] ;
    [invocation performSelector:@selector(invoke)
                     withObject:nil
                     afterDelay:0.0] ;
}

- (NSImage*)documentImage {
    return [[NSDocumentController sharedDocumentController] defaultDocumentImage] ;
}


- (IBAction)showIgnoredPrefixesSheet:(id)sender {
	[IgnoredPrefixesController showSheetOnWindow:[self window]] ;
}

- (IBAction)help:(id)sender {
	
	// Give anchor a default setting.  Actually, this should always be
	// overwritten in the code that follows.
	NSString* anchor = nil ; // Should be constHelpAnchorPrefsWindow, but that does not exist yet ;
	
	/*
	 if ([identifier isEqualToString:constIdentifierTabViewPrefsWhatever]) {
		anchor = constHelpAnchorTabWhatever ;
	}
	else if ([identifier isEqualToString:constIdentifierTabViewPrefsWhateverElse]) {
		anchor = constHelpAnchorTabWhateverElse ;
	}
	*/
	[(BkmxAppDel*)[NSApp delegate] openHelpAnchor:anchor] ;
}

- (IBAction)helpAgentLaziness:(id)sender {
	[(BkmxAppDel*)[NSApp delegate] openHelpAnchor:constHelpAnchorSyncerLaziness] ;
}

- (IBAction)helpDirectSettings:(id)sender {
	[(BkmxAppDel*)[NSApp delegate] openHelpAnchor:constHelpAnchorDirectSettings] ;
}

- (IBAction)helpFloatingMenu:(id)sender {
    [(BkmxAppDel*)[NSApp delegate] openHelpAnchor:constHelpAnchorFloatingMenu] ;
}

- (IBAction)helpSafeSyncLimit:(id)sender {
	[(BkmxAppDel*)[NSApp delegate] openHelpAnchor:constHelpAnchorSafeSyncLimit] ;
}

- (IBAction)helpSyncFirefoxOnQuit:(id)sender {
    [(BkmxAppDel*)[NSApp delegate] openHelpAnchor:constHelpAnchorSyncFirefoxOnQuit] ;
}

- (IBAction)helpMenuExtra:(id)sender  {
	[(BkmxAppDel*)[NSApp delegate] openHelpAnchor:constHelpAnchorMenuExtra] ;
}

- (IBAction)helpSyncSnapshots:(id)sender {
	[(BkmxAppDel*)[NSApp delegate] openHelpAnchor:constHelpAnchorSyncSnapshots] ;
}

- (IBAction)helpSendPerformanceData:(id)sender {
    [SSWebBrowsing browseToURLString:@"https://sheepsystems.com/privacy/"
             browserBundleIdentifier:nil
                            activate:YES] ;
}

- (IBAction)helpDontWarnSyncingSuspended:(id)sender {
    [(BkmxAppDel*)[NSApp delegate] openHelpAnchor:constHelpAnchorLeaveRunning] ;
}

- (IBAction)helpTextCopyTemplate:(id)sender {
    [(BkmxAppDel*)[NSApp delegate] openHelpAnchor:constHelpAnchorTextCopyTemplate] ;
}


/*
 Methods -helpUseSystemEvents:, -warnSystemEvents:, -prepareSystemEvents:,
 -cancelSystemEvents, -clearSystemEvents were here, #if 0, until
 20131018.
 */

- (IBAction)warnIfLaunchInBackground:(id)sender {
    if ([sender state] == NSControlStateValueOn) {
        switch ([[BkmxBasis sharedBasis] iAm]) {
            case BkmxWhich1AppSmarky:
            case BkmxWhich1AppSynkmark:
                // Button should be unavailable in these apps
                NSLog(@"Internal Error 624-5948") ;
            case BkmxWhich1AppBookMacster:;
                SSYAlert* alert = [SSYAlert alert] ;
                [alert setIconStyle:SSYAlertIconInformational] ;
                [alert setSmallText:[NSString stringWithFormat:
                                     @"Please note that the Launch In Background feature is useful if you want to keep %@ running all of the time, so you can add bookmarks *directly*.\n\n"
                                     @"Launch in Background is **not** recommended if you are using %@ to keep browsers' bookmarks synced and/or sorted.  "
                                     @"For that use case, switch on *Syncing* and then leave %@ quit.",
                                     [[BkmxBasis sharedBasis] appNameLocalized],
                                     [[BkmxBasis sharedBasis] appNameLocalized],
                                     [[BkmxBasis sharedBasis] appNameLocalized]]] ;
                [alert setHelpAddress:constHelpAnchorHideAndScript] ;
                [alert runModalSheetOnWindow:[self window]
                                  resizeable:NO
                               modalDelegate:nil
                              didEndSelector:NULL
                                 contextInfo:NULL] ;
            case BkmxWhich1AppMarkster:
                ; // Do nothing because this is a quite normal usage.
        }
    }
}

- (IBAction)inunstallWidgets:(id)sender {
	[(BkmxAppDel*)[NSApp delegate] manageAddOns:sender] ;
}

- (void)alertError:(NSError*)error
	 modalDelegate:(id)delegate
	didEndSelector:(SEL)didEndSelector {
	[SSYAlert alertError:error
				onWindow:[self window]
		   modalDelegate:delegate
		  didEndSelector:didEndSelector
			 contextInfo:NULL] ;
}

- (void)alertError:(NSError*)error {
	[self alertError:error
	   modalDelegate:nil
	  didEndSelector:NULL] ;
}

- (NSImage*)statusItemImageFlat {
    return [(BkmxAppDel*)[NSApp delegate] statusItemImageForStyle:BkmxStatusItemStyleFlat] ;
}

- (NSImage*)statusItemImageGray {
    return [(BkmxAppDel*)[NSApp delegate] statusItemImageForStyle:BkmxStatusItemStyleGray] ;
    
}


#define IXPORT_LOG_MAX_LIMIT 100



#pragma mark * Tool Tip Delegate Methods

- (NSString *)view:(NSView*)view
  stringForToolTip:(NSToolTipTag)tag
			 point:(NSPoint)point
		  userData:(void*)userData {
	NSString* answer ;
	if (tag == m_altKeyInspectsLanderTooltipTag) {
		answer = [[BkmxBasis sharedBasis] toolTipAddNewShowInspector] ;
	}
    else {
        answer = @"" ;
    }
	
	return answer ;
}

- (IBAction)revealTabViewClients {
	[self revealTabViewIdentifier1:constIdentifierTabViewPrefsSyncing
                       identifier2:nil] ;
}

#pragma mark * Tab View Delegate Methods

#define WINDOW_TOP_PLUS_BOTTOM_MARGINS 30.0


- (IBAction)guideUserToSafeLimitMenuItem:(NSMenuItem*)menuItem {
    [SafeLimitGuider guideUserFromMenuItem:menuItem
                          windowController:self
                          documentProvider:self] ;
}

- (IBAction)syncNotifications:(id)sender {
    [SyncNotificationsWindowController showSheetOnWindow:[self window]] ;
}

- (void)openNotificationSettings {
    [self revealTabViewIdentifier1:constIdentifierTabViewPrefsSyncing
                       identifier2:nil];
    [self syncNotifications:self] ;
}

- (NSImage*)specialImageForTabViewIdentifier:(NSString*)identifier {
    NSImage* image = nil;
    if ([identifier isEqualToString:constIdentifierTabViewPrefsSyncing]) {
        image = [SSYVectorImages imageStyle:SSYVectorImageStyleChasingArrowsFilled
                                     wength:32.0
                                      color:[NSColor blueColor]
                               darkModeView:self.window.contentView
                              rotateDegrees:0.0
                                      inset:0.0];
    } else {
        image = nil;
    }

    return image;
}
@end
