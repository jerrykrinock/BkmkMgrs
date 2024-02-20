#import <Cocoa/Cocoa.h>
#import "SSYMenuButton.h"

@class Stark ;
@class SSYProgressView ;
@class StarkContainersHierarchicalMenu ;
@class SSYStarRatingView ;
@class SSYTokenField ;
@class BkmxDoc ;
@class BkmxAppDel ;
@class SSYDragDestinationTextView ;
@class SSYSidebarController;

@interface InspectorController : NSWindowController <SSYMenuMaker> {
    IBOutlet id labelComments;
    IBOutlet id labelTags;
    IBOutlet id labelName;
    IBOutlet id labelPriorUrl;
    IBOutlet id labelURL;
    IBOutlet id labelShortcut;
    IBOutlet id labelVerifierCode;
    IBOutlet id labelVisitCount;
    IBOutlet NSImageView* lineageImageView;

    IBOutlet NSView* mainView;
    IBOutlet NSView* rightSidebarView;
    IBOutlet NSView* bottomSidebarView;

    IBOutlet SSYSidebarController* rightSidebarController;
    IBOutlet SSYSidebarController* bottomSidebarController;

    IBOutlet NSButton* bottomSidebarControllerButton ;
    IBOutlet NSButton* rightSidebarControllerButton ;
    IBOutlet NSButton* gearButton ;

    IBOutlet NSObjectController* starkController ;
    IBOutlet NSObjectController* starkiController ;

    /* You can enable drag support in either a NSTextField or NSTextView.  In
     this case, since I must use an NSTextView for the 'comments' field anyhow,
     it was less bother to use the NSTextView, as SSYDragDestinationTextView. */
    IBOutlet SSYDragDestinationTextView* nameField ;
    IBOutlet SSYDragDestinationTextView* shortcutField ;
    IBOutlet SSYDragDestinationTextView* commentsField ;
    IBOutlet SSYProgressView* lineageField ;
    IBOutlet SSYStarRatingView* starRatingView ;
    IBOutlet SSYTokenField* tagsField ;

    StarkContainersHierarchicalMenu* m_moveHypermenu ;
    BOOL m_isObserving ;

    BkmxDoc* m_saveUponCloseBkmxDoc ;

    NSMutableArray* m_boundCheckboxes ;
    NSMutableSet* m_observedTags;
}

- (void)setSelectedStark:(Stark*)stark;
- (void)setSelectedStarki:(Stark*)starki;

- (void)showUrls;

- (IBAction)help:(id)sender;
- (IBAction)showUrls:(NSButton*)sender;
- (IBAction)showExportExclusions:(NSButton*)sender;

// See Note 20120717 for explanation of this.
- (IBAction)setTagsKludge:(NSTokenField*)sender ;

- (void)prepareSaveUponCloseBkmxDoc:(BkmxDoc*)bkmxDoc  ;

- (SSYStarRatingView*)starRatingView ;

- (void)popMoveMenuOntoLineageField:(id)sender ;

- (void)setFirstResponderToNameField ;

- (void)closeWindow ;

- (void)setHidesOnDeactivate ;

- (void)endEditing ;

@end
