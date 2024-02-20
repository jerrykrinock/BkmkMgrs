#import <Bkmxwork/Bkmxwork-Swift.h>
#import "InspectorController.h"
#import "ExtoreOpera.h" // Needed for -localizedStrings
#import "NSMenu+PopOntoView.h"
#import "BkmxBasis+Strings.h"
#import "NSMenu+StarkContextual.h"
#import "Stark+Sorting.h"
#import "SSYProgressView.h"
#import "StarkContainersHierarchicalMenu.h"
#import "StarkEditor.h"
#import "BkmxDoc+GuiStuff.h"
#import "NSArray+SafeGetters.h"
#import "SSYMH.AppAnchors.h"
#import "SSYDooDooUndoManager.h"
#import "SSYTokenField.h"
#import "Starki.h"
#import "BkmxAppDel+Capabilities.h"
#import "BkmxAppDel+Actions.h"
#import "SSYEventInfo.h"
#import "SSYVectorImages.h"
#import "SSYDragDestinationTextView.h"
#import "SSYSidebarController.h"
#import "NSView+SSYDarkMode.h"
#import "NSObject+DoNil.h"

NSString* const starkiObserverKeyPath = @"selection.stark.tags";

@interface InspectorController ()

@property (assign) BkmxDoc* saveUponCloseBkmxDoc ;
@property (retain) NSMutableArray* boundCheckboxes ;
@property (readonly)NSMutableSet* observedTags;
@property (assign) NSTimer* kludgeWindowWillCloseTimer ;
@property (assign) BOOL isClosing ;
@property (assign) CGFloat mainViewWidth;
@property (assign) CGFloat mainViewHeight;

@end


@implementation InspectorController

@synthesize saveUponCloseBkmxDoc = m_saveUponCloseBkmxDoc ;
@synthesize boundCheckboxes = m_boundCheckboxes ;

- (void)setSelectedStark:(Stark*)stark {
    [starkController setContent:stark];
}

- (void)setSelectedStarki:(Stark*)starki {
    if (![NSObject isEqualHandlesNilObject1:starki
                                    object2:[starkiController content]]) {

        [starkiController setContent:starki];
    }
}

- (StarkContainersHierarchicalMenu*)moveHypermenu {
    if (!m_moveHypermenu) {
        m_moveHypermenu = [[StarkContainersHierarchicalMenu alloc] initWithTarget:[StarkEditor class]
                                                                         selector:@selector(moveAndSortNoRevealStarks:toNewParent:)
                                                                       targetInfo:nil] ;  // targetInfo is set on the fly
        [m_moveHypermenu setDoRoot:YES] ;
    }

    return m_moveHypermenu ;
}

- (NSMenu*)menuForButton:(NSButton*)button {
    Stark* stark = [(BkmxAppDel*)[NSApp delegate] selectedStark] ;
    NSArray* starks ;
    if ([stark isKindOfClass:[Stark class]]) {
        starks = [NSArray arrayWithObject:stark] ;
    }
    else {
        // stark is probably an _NSStateMarker such as NSNoSelectionMarker
        // Replace with nil and an empty array.
        stark = nil ;
        starks = [NSArray array] ;
    }

    // Create four arrays
    NSMutableArray* hartainers = [NSMutableArray array] ;
    NSMutableArray* softFolders = [NSMutableArray array] ;
    NSMutableArray* bookmarks = [NSMutableArray array] ;
    NSMutableArray* notches = [NSMutableArray array] ;
    [stark classifyBySharypeDeeply:NO
                        hartainers:hartainers
                       softFolders:softFolders
                            leaves:bookmarks
                           notches:notches] ;
    // At this point, one of the four arrays will contain one object,
    // the selected stark, and the other three arrays will be empty.

    NSArray* softFoldersAndBookmarks = [softFolders arrayByAddingObjectsFromArray:bookmarks] ;
    NSArray* softStarks = [softFoldersAndBookmarks arrayByAddingObjectsFromArray:notches] ;

    // Get all bookmarks, including immediate children of containers
    NSArray* allBookmarks = [Stark immediateBookmarksInHartainers:hartainers
                                                      softFolders:softFolders
                                                        bookmarks:bookmarks] ;

    // Create the submenu
    NSMenu* menu = [[NSMenu alloc] initWithTitle:@""];

    // Now, add menu items
    [menu addVisitItemsForBookmarks:allBookmarks] ;
    [menu addSeparatorItem] ;
    [menu addCopyAndCutItemForStarks:starks] ;
    [menu addHierarchicalItemsForStarks:starks] ;
    [menu addDeleteItemForStarks:softStarks] ;
    [menu addSeparatorItem] ;
    [menu addSortDirectiveItemsForSoftFoldersAndBookmarks:softFoldersAndBookmarks] ;
    [menu addSeparatorItem] ;
    [menu addSwapUrlsItemsForBookmarks:bookmarks] ;

    // Add a title for debugging
    [menu setTitle:[NSString stringWithFormat:@"CM in %@", self]] ;

    return [menu autorelease] ;
}

- (NSArray*)selectedObjects {
    Stark* selectedStark = [(BkmxAppDel*)[NSApp delegate] selectedStark] ;
    return [NSArray arrayWithObject:selectedStark] ;
}

- (NSArray*)selectedStarks {
    return [self selectedObjects] ;
}

- (SSYStarRatingView*)starRatingView {
    return starRatingView ;
}


- (id)init {
    return [super initWithWindowNibName:@"Inspector"] ;
}

- (void)endObservers {
    if (m_isObserving) {
        [[NSNotificationCenter defaultCenter] removeObserver:self] ;
        [[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self] ;
        m_isObserving = NO ;
    }
}

- (void)dealloc {
    [starkiController removeObserver:self
                          forKeyPath:starkiObserverKeyPath] ;

    [tagsField unbind:@"enabled"] ;
    [tagsField unbind:@"editable"] ;
    [tagsField unbind:@"toolTip"] ;
    [tagsField unbind:@"tokenizingCharacter"] ;
    [lineageField unbind:constKeyStaticConfigInfo] ;
    [starRatingView unbind:constKeyRating] ;

    for (NSButton* checkbox in [self boundCheckboxes]) {
        [checkbox unbind:@"value"] ;
    }
    [m_boundCheckboxes release] ;

    [self removeAnyObserversFromAllTags];
    [m_observedTags release];
    
    [m_moveHypermenu release] ;
    [self endObservers] ;

    [super dealloc] ;
}

- (NSDictionary*)beForgiving {
    return [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                       forKey:NSRaisesForNotApplicableKeysBindingOption] ;
}

- (NSDictionary*)beForgivingAndNotNil {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithBool:NO], NSRaisesForNotApplicableKeysBindingOption,
            NSIsNotNilTransformerName, NSValueTransformerNameBindingOption,
            nil] ;
}

- (void)startObservers {
    if (!m_isObserving) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(commitEditing:)
                                                     name:NSOutlineViewSelectionDidChangeNotification
                                                   object:nil] ;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(commitEditing:)
                                                     name:NSTableViewSelectionDidChangeNotification
                                                   object:nil] ;

        [lineageField bind:constKeyStaticConfigInfo
                  toObject:starkiController
               withKeyPath:@"selection.lineageStatus"
                   options:nil] ;

        NSDictionary* beForgiving = [self beForgiving] ;

        [starRatingView bind:constKeyRating
                    toObject:starkiController
                 withKeyPath:@"selection.rating"
                     options:beForgiving] ;

        /* The following NSTokenField bindings are defined in NSTokenField, but
         Interface Builder does not show them.  So we must bind (and unbind)
         manually.  The 'value' binding is available, but we don't use that for
         a different reason, see Note 20120717. */
        [tagsField bind:@"editable"
               toObject:starkiController
            withKeyPath:@"selection.allStarksAreTaggable"
                options:beForgiving] ;
        [tagsField bind:@"enabled"
               toObject:starkiController
            withKeyPath:@"selection.allStarksAreTaggable"
                options:beForgiving] ;
        [tagsField bind:@"tokenizingCharacter"
               toObject:[NSUserDefaults standardUserDefaults]
            withKeyPath:constKeyTagDelimiterDefault
                options:0] ;
        [tagsField bind:@"toolTip"
               toObject:[(BkmxAppDel*)[NSApp delegate] basis]
            withKeyPath:@"toolTipTags"
                options:0] ;

        [starkiController addObserver:self
                           forKeyPath:starkiObserverKeyPath
                              options:0
                              context:NULL] ;

        [tagsField setFont:[NSFont systemFontOfSize:11.0]] ;
        m_isObserving = YES ;
    }
}

- (void)removeAnyObserversFromAllTags {
    for (Tag* tag in self.observedTags) {
        [tag removeObserver:self
                 forKeyPath:constKeyString
                    context:NULL];
    }
}

- (void)refreshTagsField {
    NSSet* newTags = [[starkiController content] tags] ;
    NSArray* newTagsArray ;
    if ([newTags respondsToSelector:@selector(allObjects)]) {
        newTagsArray = [newTags allObjects] ;
        newTagsArray = [newTagsArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] ;
    }
    else {
        // Probably it's an _NSStateMarker
        newTagsArray = nil ;
    }
    
    /* The following is needed so that we will observe if the tags
     remain the same but a string inside one of the tags changes.  Yes,
     this can happen – if the user performs a seconday click on a tag
     in the Tag Cloud in document Content View, then from the contextual
     menu selects "Rename <xxx>". */
    [self removeAnyObserversFromAllTags];
    [self.observedTags removeAllObjects];
    for (Tag* tag in newTagsArray) {
        [tag addObserver:self
              forKeyPath:constKeyString
                 options:0
                 context:NULL];
        [self.observedTags addObject:tag];
    }
    [tagsField setObjectValue:newTagsArray];
    tagsField.needsDisplay = YES;
}

/* Note 20120717, updated 20151128.

 There is some weird bug in OS 10.7, still in 10.11, or else some other mistake
 on my part, which causes the following problem if I bind the "value" of the
 NSTokenField tagsField to the content or selection of the Stark Controller in
 InspectorController.nib, as I do with all of the other stark attribute
 controls.

 The bug is that, when editing the togs/token field in the Inspector, when user
 hits the down-arrow key, instead of stepping into the completions menu, the
 token ends editing immediately, setting its value to the first completion in
 the menu.  If I bind don't bind the "value", or bind it to a property of this
 InspectorController instead of to the starkController, then it behaves
 properly.  Until BkmkMgrs 2.0.6 I used the latter solution, but when I had to
 move the -unbind messages from -endObservers to -dealloc due to some strange
 change, I think, in the way El Capitan switches app from Regular to Background
 (LSUIElement), this caused a bindings burp.  So now I am using the former
 solution, not binding, and KVO + target/action instead.

 Specifically, in the model-to-view direction I use KVO, observing the content
 of the starkController.  In the view-to-model direction I use target/action,
 -setTagsKludge:.

 Back in 2012 I tried to reproduce this problem in a small test project
 (TokenBindingTest), but could not reproduce.  In the test project, it always
 works properly whether I bind via an object controller or directly to the data
 model object.
 */
- (void)observeValueForKeyPath:(NSString*)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:starkiObserverKeyPath]) {
        [self refreshTagsField] ;
    }
    else if ([keyPath isEqualToString:constKeyString]) {
        /* A string inside a tag will be changed, causing the observation
         which we set up in the previous branch (above) to fire.
         We need to tell the tagsField to update its cell *after* the change
         has occurred.  So we need a little delay… */
        [self performSelector:@selector(refreshTagsField)
                   withObject:nil
                   afterDelay:0.1];
    }
}

- (NSMutableSet*)observedTags {
    if (!m_observedTags) {
        m_observedTags = [NSMutableSet new];
    }
    
    return m_observedTags;
}

- (IBAction)setTagsKludge:(NSTokenField*)sender {
    NSArray* newTags = [sender objectValue] ;
    [(Starki*)[starkiController content] setTags:newTags] ;
}

- (void)createCheckboxForExformat:(NSString*)exformat
                          frame_p:(NSRect*)frame_p
                        iCheckTag:(NSInteger)iCheckTag {
    NSView* view = rightSidebarController.sidebarView;
    NSButton* checkbox = [[NSButton alloc] init] ;
    [[self boundCheckboxes] addObject:checkbox] ;
    frame_p->origin.y -= frame_p->size.height ;
    [checkbox setButtonType:NSButtonTypeSwitch] ;
    [checkbox setFrame:*frame_p] ;
    [[checkbox cell] setControlSize:NSControlSizeSmall] ;
    [view addSubview:checkbox] ;
    [checkbox release] ;
    Class extoreClass = [Extore extoreClassForExformat:exformat] ;
    NSString* title = [extoreClass ownerAppDisplayName] ;
    [checkbox setTitle:title] ;
    [checkbox setTag:iCheckTag] ;
    [checkbox bind:@"value"
          toObject:starkiController
       withKeyPath:[NSString stringWithFormat:@"selection.shouldExportTo%@", exformat]
           options:[self beForgiving]] ;
    [checkbox bind:@"enabled"
          toObject:starkiController
       withKeyPath:@"selection"
           options:[self beForgivingAndNotNil]] ;
}

#define CHECKBOX_VERTICAL_MARGIN 10.0
#define BOTTOM_MARGIN 20.0
#define CHECKBOX_HEIGHT 16.0

- (void)populateExportExcludes {
#if 0
    // This was the original code, and should work if I ever find the root
    // cause of checkboxes not being bound.
    if ([self boundCheckboxes] != nil) {
        // We've already created the checkboxes
        return ;
    }
#else
    // Kludge to stop the problem which I saw once, which is that checkboxes
    // seemed to be unbound.  This was added in BookMacster 1.13.6
    NSTextField* heading = nil ;
    NSView* view = rightSidebarController.sidebarView;
    for (NSView* subview in [NSArray arrayWithArray:[view subviews]]) {
        // The first subview is the heading text
        if (!heading) {
            heading = (NSTextField*)subview ;
        }
        else {
            [subview removeFromSuperviewWithoutNeedingDisplay] ;
        }
    }
#endif

    [self setBoundCheckboxes:[NSMutableArray array]] ;

    /* We use the constant rightSidebarController.sidebarLength instead of
     rightSidebarView.width because the latter will be 0.0 if collapsed. */

    CGFloat topOfTopCheckbox = heading.frame.origin.y - CHECKBOX_VERTICAL_MARGIN;
    NSRect frame = NSMakeRect(
                              heading.frame.origin.x,
                              topOfTopCheckbox,
                              (rightSidebarController.sidebarLength - heading.frame.origin.x),
                              CHECKBOX_HEIGHT
                              ) ;

    NSInteger iCheckTag = 0 ;

    for (NSString* exformat in [[BkmxBasis sharedBasis] supportedExformatsOrderedByName]) {
        [self createCheckboxForExformat:exformat
                                frame_p:&frame
                              iCheckTag:iCheckTag];
        iCheckTag++ ;
    }

    view.needsDisplay = YES;
}

- (void)awakeFromNib {
    /* Trick to make a NSTextView, which only comes in a NSScrollView in
     Interface Builder, to not bounce up and down if user touches it
     accidentally with a vertical "scroll" swipe. */
    nameField.enclosingScrollView.verticalScrollElasticity = NSScrollElasticityNone ;
    shortcutField.enclosingScrollView.verticalScrollElasticity = NSScrollElasticityNone ;

    nameField.activateUponDrop = YES ;
    shortcutField.activateUponDrop = YES ;
    commentsField.activateUponDrop = YES ;

    nameField.ignoreTabsAndReturns = YES;
    shortcutField.ignoreTabsAndReturns = YES;
    commentsField.ignoreTabsAndReturns = YES;

    /* Grab these original view sizes from Interface Builder. */
    self.mainViewWidth = mainView.frame.size.width;
    self.mainViewHeight = mainView.frame.size.height;

    [[self window] setTitle:[[BkmxBasis sharedBasis] labelInspector]] ;

    [lineageImageView setImage:[SSYVectorImages imageStyle:SSYVectorImageStyleLineage
                                                    wength:[lineageImageView frame].size.width
                                                     color:nil
                                              darkModeView:self.window.contentView
                                             rotateDegrees:0.0
                                                     inset:0.0]] ;
    NSColor* controlAccentColor;
    if (@available(macOS 10.14, *)) {
        controlAccentColor = [NSColor controlAccentColor];
    } else {
        controlAccentColor = [NSColor blueColor];
    }

    [bottomSidebarControllerButton setImage:[SSYVectorImages imageStyle:SSYVectorImageStyleWindowWithSidebar
                                                                 wength:0.75 * [bottomSidebarControllerButton frame].size.width
                                                                  color:controlAccentColor
                                                           darkModeView:nil // For this template image, Cocoa will handle luminance inversion when in Dark Mode
                                                          rotateDegrees:-90.0
                                                                  inset:0.0]] ;

    [rightSidebarControllerButton setImage:[SSYVectorImages imageStyle:SSYVectorImageStyleWindowWithSidebar
                                                                wength:0.75 * [rightSidebarControllerButton frame].size.width
                                                                 color:controlAccentColor
                                                          darkModeView:nil // For this template image, Cocoa will handle luminance inversion when in Dark Mode
                                                         rotateDegrees:0.0
                                                                 inset:0.0]] ;

    [self setShouldCascadeWindows:NO] ;
    [[self window] setFrameAutosaveName:constWindowNameInspector] ;

    [labelName setToolTip:[Extore legendForKey:constKeyName]] ;
    [labelURL setToolTip:[Extore legendForKey:constKeyUrl]] ;
    [labelShortcut setToolTip:[Extore legendForKey:constKeyShortcut]] ;
    [labelTags setToolTip:[Extore legendForKey:constKeyTags]] ;
    [labelComments setToolTip:[Extore legendForKey:constKeyComments]] ;

    [(NSPanel*)[self window] setFloatingPanel:NO] ;

    [self startObservers] ;

    // So that keys tab, shift-tab, return, etc. change the key view
    // instead of being entered as text…
    [commentsField setFieldEditor:YES] ;
}

- (IBAction)help:(id)sender {
#if 0
#warning Hijacked Inspector Help
    return ;
#endif
    [(BkmxAppDel*)[NSApp delegate] openHelpAnchor:constHelpAnchorInspector] ;
}

/* This is a kludge for the fact that, when app is operating in the
 background as LSUIElement, if user clicks the red 'close' button,
 -windowWillClose is not received, but -windowShouldClose is received.
 This misbehavior may be new in macOS 10.11 El Capitan.  If the system
 behaves properly and sends us -windowWillClose, kludgeWindowWillCloseTimer
 will be invalidated before it fires.  If the system sends us -windowShouldClose
 but not window -windowWillClose, the the timer will fire and do invoke
 -windowWillClose. */
- (BOOL)windowShouldClose:(id)sender {
    if (![self isClosing]) {
        /* If we get here, that means this was a *real* -windowShouldClose
         message, sent by the system, not one caused by
         -[BkmxAppDel background:] sending -[InspectorController closeWindow]
         which in turn sends -[NSWindow performClose]. */
        if ([self kludgeWindowWillCloseTimer] == nil) {
            NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                              target:self
                                                            selector:@selector(doWindowWillCloseTimer:)
                                                            userInfo:nil
                                                             repeats:NO] ;
            [self setKludgeWindowWillCloseTimer:timer] ;
        }
    }

    return YES ;
}

- (void)doWindowWillCloseTimer:(NSTimer*)timer {
    [self windowWillClose:nil] ;
}

- (void)windowWillClose:(NSNotification *)notification {
    [[self kludgeWindowWillCloseTimer] invalidate] ;
    [self setKludgeWindowWillCloseTimer:nil] ;

    if ([self isClosing] == NO) {
        [self setIsClosing:YES] ;
        [self endEditing] ;

        if (![(BkmxAppDel*)[NSApp delegate] isTerminating]) {
            /* We temporarily disable observers so that this method
             will not be re-invoked when [(BkmxAppDel*)[NSApp delegate] doShowInspector:]
             invokes [[[self inspectorController] window] closeWindow],
             which will cause us to invoke -performClose, which will
             cause the NSWindowWillCloseNotification to be posted again. */
            [self endObservers] ;

            // This is in case the window is closed by user clicking the 'close'
            // button.  We need to set the NSUserDefault, the state of the any
            // 'Inspector' buttons in open .bmco document windows, and the state
            // of the 'Show Inspector' menu items in any menus that might open in
            // the future.
            [(BkmxAppDel*)[NSApp delegate] doShowInspector:NO] ;
        }

        [[self saveUponCloseBkmxDoc] saveDocument] ;
    }
    [self setIsClosing:NO] ;

}

- (void)setFirstResponderToNameField {
    [[self window] makeFirstResponder:nameField] ;
}

- (void)showUrls {
    [bottomSidebarController expandSidebar:YES
                           mainViewMinimum:self.mainViewHeight
                                   animate:YES] ;
}

- (IBAction)showUrls:(NSButton*)sender {
    [bottomSidebarController expandSidebar:(sender.state == NSControlStateValueOn)
                           mainViewMinimum:self.mainViewHeight
                                   animate:YES] ;
}

- (IBAction)showExportExclusions:(NSButton*)sender {
    [rightSidebarController expandSidebar:(sender.state == NSControlStateValueOn)
                          mainViewMinimum:self.mainViewWidth
                                  animate:YES] ;
    [self populateExportExcludes] ;
    if ([SSYEventInfo alternateKeyDown]) {
        Starki* currentStarki = [[starkiController selectedObjects] firstObjectSafely];
        NSLog(
              @"Exids of starkid=%@ %@\n%@",
              [currentStarki stark].starkid,
              [currentStarki stark].name,
              [currentStarki stark].exids);
    }
}

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)aWindow {
    NSUndoManager* undoManager ;

    Stark* stark = [(BkmxAppDel*)[NSApp delegate] selectedStark] ;
    // The following if() is because if there is no selection,
    // stark will in fact be an _NSStateMarker, in particular the <NO SELECTION MARKER>,
    // which will not respond to -owner.
    if ([stark respondsToSelector:@selector(owner)]) {
        undoManager = [[(NSPersistentDocument*)[stark owner] managedObjectContext] undoManager] ;
    }
    else {
        undoManager = nil ;
    }
    return undoManager ;
}

- (void)commitEditing:(NSNotification*)note {
    [starkiController commitEditing] ;
}

- (void)popMoveMenuOntoLineageField:(id)sender {
    // sender is the "Move" hyperlink, an SSYRolloverButton.

    // The temptation is to assign currentSubject from [starkController selection].
    // However, that returns a stupid proxy which will not respond to -owner, later.
    // However, because starkController is a concrete instance of NSObjectController,
    // [starkController selectedObjects] returns an array containing the receiver’s
    // content object.  The real object.  That's what we need.
    Starki* currentStarki = [[starkiController selectedObjects] firstObjectSafely] ;
    // Although a Starki object can stand in for a stark if all you need are simple
    // properties, due to its implementations of (set)valueForUndefinedKey:, in this
    // case we're going to be sending more complicated messages such as
    // -[Stark classifyBySharypeDeeply:hartainers:softFolders:bookmarks:separators:].
    // So we'd better dig out the stark…
    Stark* currentSubject = [[currentStarki starks] firstObjectSafely] ;
    [[self moveHypermenu] setTargetInfo:currentSubject] ;

    // I spent a few hours trying to make the following a StarkContainersFlatMenu,
    // so it would look more like the one in Safari > Add Bookmark.  But I abandoned
    // it for several reasons:
    // *  The modern way to do this is to use the new method:
    //       -[NSMenu popUpMenuPositioningItem:atLocation:inView].
    //    This was added in Mac OS 10.6 "for popping up a menu as if it were a popup button".
    //    This method probably does both (a) setting the checkmark on the selected
    //    item and (b) scrolling the initial position of the menu so that the
    //    selected item is at the mouse click.
    // *  In the absence of Mac OS 10.6, you must use a real NSPopupButton.  I
    //    created one in this method here, and found that this accomplished
    //    (a) but not (b).  I don't know how to accomplish (b).
    // *  Although a large menu appears immediately, it scrolls slowly and jerkily
    //    when you hit the arrows at the top and bottom of the screen.
    // *  Unless a small relative movement is desired, which is not often likely, the
    //    hierarchical thing may be more what the user wants anyhow.
    NSRect frame = [sender frame] ;
    NSPoint point = NSMakePoint(frame.size.width, frame.size.height) ;
    [[self moveHypermenu] popOntoView:sender
                              atPoint:point
                            pullsDown:NO] ;
}

- (void)bkmxDocWillClose:(NSNotification*)note {
    // Better forget the bkmxDoc we remembered
    [self setSaveUponCloseBkmxDoc:nil] ;
}

- (void)prepareSaveUponCloseBkmxDoc:(BkmxDoc*)bkmxDoc {
    // To make sure we don't crash by sending a message to a closed BkmxDoc,
    // if it closes before we do…
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bkmxDocWillClose:)
                                                 name:SSYUndoManagerDocumentWillCloseNotification
                                               object:bkmxDoc] ;
    [self setSaveUponCloseBkmxDoc:bkmxDoc] ;

    // Also, only leave this open for 60 seconds
    [self performSelector:@selector(setSaveUponCloseBkmxDoc:)
               withObject:nil
               afterDelay:60.0] ;
}

#pragma mark * NSWindowDelegate methods

/*
 The following implementation serves at least two purposes:

 1.  (Probably) needed to trigger action of tagsField.
     See Note 510494.  This was added as a bug fix in BookMacster 1.15.3.

 2.  To update the data model in case the window is closed while a control
 has dirty text in it.  It still appears to not work if the app is Quit while
 a control (tested with Shortcut field) has dirty text in it.
 
 It may also correct similar problems for other fields.
 */
- (void)endEditing {
    /*
     The following code, though rather strange, is copied out of the
     documentation of -[NSWindow endEditingFor]
     */
    if ([[self window] makeFirstResponder:[self window]]) {
        // Apparently, we're done because it worked.
    }
    else {
        // Last resort
        [[self window] endEditingFor:nil];
    }
}

- (void)windowDidResignMain:(NSNotification*)notification {
    [self endEditing] ;
}

- (void)windowDidResignKey:(NSNotification*)notification {
    [self endEditing] ;
}

- (void)closeWindow {
    [[self window] performClose:self] ;
}

- (void)setHidesOnDeactivate {
    [[self  window] setHidesOnDeactivate:YES] ;
}

#pragma mark * NSControlTextEditingDelegate Delegate Methods

- (NSArray*)   tokenField:(NSTokenField*)tokenField
  completionsForSubstring:(NSString*)substring
             indexOfToken:(NSInteger)tokenIndex
      indexOfSelectedItem:(NSInteger*)index_p {
    NSArray* completions = nil ;
    if (tokenField == tagsField) {
        return [(BkmxAppDel*)[NSApp delegate] tagCompletionsForTagPrefix:substring
                                                           selectIndex_p:index_p] ;
    }
    
    return completions ;
}

#pragma mark * NSTokenFieldDelegate Delegate Methods

- (NSString*)            tokenField:(NSTokenField *)tokenField
  displayStringForRepresentedObject:(id)representedObject {
    return [representedObject string];
}

- (id)                  tokenField:(NSTokenField*)tokenField
 representedObjectForEditingString:(NSString*)editingString {
    Tagger* tagger = [[[[self selectedStarks] firstObject] owner] tagger];
    Tag* newTag = [tagger tagWithString:editingString];
    return newTag;
}

@end
