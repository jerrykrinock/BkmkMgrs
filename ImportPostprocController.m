#import "ImportPostprocController.h"
#import "Macster.h"
#import "SSYMH.AppAnchors.h"
#import "BkmxAppDel.h"
#import "BkmxDoc.h"

@implementation ImportPostprocController

@synthesize macster = m_macster ;

- (NSPopUpButton*)importSafeLimitPopup {
	return ibo_importSafeLimitPopup ;
}

- (id)initWithMacster:(Macster*)macster {
	self = [super initWithWindowNibName:@"ImportPostproc"] ;
	if (self) {
		[self setMacster:macster] ;		
	}
	
	return self ;
}

- (void)awakeFromNib {
    NSMenu* menu = [defaultParentPopup menu] ;
    [menu setDelegate:self] ;
    
    // The following is needed so that the popup will initially display
    // the current value instead of "??" which is the title of the one and only
    // menu item set in the xib file.
    [self menuNeedsUpdate:menu] ;
}

/* Do not make the mistake of setting this method as the didEndSelector for
 the sheet *and* wiring the *Done* button to it.  That would cause it to
 be invoked twice, which will invoke [self release] twice, which will crash. */
- (IBAction)done:(id)sender {
    [self retain] ;
    [[[self window] sheetParent] endSheet:[self window]
                               returnCode:NSAlertFirstButtonReturn] ;
	[[self window] close] ;
	// Window is set to "Release when closed" in xib
	// Balance the -alloc] init] in -[ClientListView info:]
	[self release] ;
}

- (IBAction)help:(id)sender {
	[(BkmxAppDel*)[NSApp delegate] openHelpAnchor:constHelpAnchorTabClients] ;
}

- (IBAction)setPreferredCatchypeFromMenuItem:(NSMenuItem*)menuItem {
    NSNumber* sharypeNumber = [menuItem representedObject] ;
    [[self macster] setPreferredCatchype:sharypeNumber] ;
    [[self macster] save] ;
}

- (void)menuNeedsUpdate:(NSMenu*)menu {
	[menu removeAllItems] ;
    NSNumber* selectedSharype = [[self macster] preferredCatchype] ;

	for (NSNumber* sharype in [[[self macster] bkmxDoc] availableHartainers]) {
        NSString* title = [[[self macster] bkmxDoc] displayNameForHartainer:sharype] ;
        NSMenuItem* menuItem = [[NSMenuItem alloc] initWithTitle:title
                                                          action:@selector(setPreferredCatchypeFromMenuItem:)
                                                   keyEquivalent:@""] ;
		[menuItem setRepresentedObject:sharype] ;
		[menuItem setTarget:self] ;
		[menu addItem:menuItem] ;
		[menuItem release] ;
        if ([selectedSharype isEqualToNumber:sharype]) {
            [defaultParentPopup selectItem:menuItem] ;
            [defaultParentPopup synchronizeTitleAndSelectedItem] ;
        }
	}
}

+ (void)showSheetOnWindow:(NSWindow*)window
                 document:(BkmxDoc*)document {
	ImportPostprocController* sheetController = [[ImportPostprocController alloc] initWithMacster:[document macster]] ;
	// Note: In the nib containing the sheet/window, make sure that in the
	// window attribute "Visible on Launch" is NOT checked.  If it is,
	// the window will display immediately as a freestanding window
	// instead of the next line attaching it to hostWindow as a sheet.
	
	NSWindow* sheet = [sheetController window] ;
	
    [window beginSheet:sheet
              completionHandler:^void(NSModalResponse modalResponse) {
                  // Nothing to do, just
                  [sheetController release] ;
              }] ;
}

@end
