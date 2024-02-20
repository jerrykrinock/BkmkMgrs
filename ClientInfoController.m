#import "ClientInfoController.h"
#import "SSYMH.AppAnchors.h"
#import "BkmxAppDel.h"
#import "Client.h"
#import "Ixporter.h"
#import "ClientSpecialBoxController.h"
#import "TalderMapsController.h"

@interface ClientInfoController ()

@property (retain) ClientSpecialBoxController* specialBoxController ;

@end

@implementation ClientInfoController

@synthesize client = m_client ;
@synthesize specialBoxController = m_specialBoxController ;

- (NSPopUpButton*)exportSafeLimitPopup {
	return exportSafeLimitPopup ;
}


- (id)initWithClient:(Client*)client {
	self = [super initWithWindowNibName:@"ClientInfo"] ;
	if (self) {
		[self setClient:client] ;
		
		ClientSpecialBoxController* specialBoxController = [(ClientSpecialBoxController*)[ClientSpecialBoxController alloc] initWithClient:client] ;
		// For client exformats which do not have special options, the
		// specialBoxController will be nil at this point.
		[self setSpecialBoxController:specialBoxController] ;
		[specialBoxController release] ;
	}
	
	return self ;
}

- (void)dealloc {
	[m_specialBoxController release] ;
	
	[super dealloc] ;
}

#define MARGIN_BETWEEN_BOXES 15.0

- (void)awakeFromNib {
	// Per Discussion in documentation of -[NSObject respondsToSelector:],
	// the superclass name in the following must be hard-coded.
	if ([NSView instancesRespondToSelector:@selector(awakeFromNib)]) {
		[super awakeFromNib] ;
	}
		
	// The initial window height in the nib includes the "dead" height for the
	// title text field at the top and the buttons at the bottom, and
	// the height for the Import Box and the Export Box.  It does not
	// include the height for the Special Box, nor any MARGIN_BETWEEN_BOXES.
	CGFloat deltaH = 0.0 ;
	NSInteger numberOfBoxes = 2 ;
	
	if (![[(Ixporter*)[[self client] importer] isActive] boolValue]) {
		[importBox removeFromSuperviewWithoutNeedingDisplay] ;
		// Since the initial window height *did* assume an Import box, we subtract it
		deltaH -= [importBox frame].size.height ;
		numberOfBoxes -= 1 ;
	}
	
	// If we did not remove the Import Box, its position is taken care
	// of automatically since it is strutted to the top.
	
	if (![[(Ixporter*)[[self client] exporter] isActive] boolValue]) {
		// Since the initial window height *did* assume an Export box, we subtract it
		[exportBox removeFromSuperviewWithoutNeedingDisplay] ;
		deltaH -= [exportBox frame].size.height ;
		numberOfBoxes -= 1 ;
	}
	
	// If we did not remove the Export Box, its position is taken care
	// of automatically since it is strutted to the bottom.
	
	if ([self specialBoxController]) {
		// Since the initial window height *did not* assume a Special box, we add it
		deltaH += [[[self specialBoxController] view] frame].size.height ;
		numberOfBoxes += 1 ;
		
		// Now we need to position the Special Box in between the Import Box
		// which is strutted to the top and the Export Box which is strutted
		// to the bottom
		NSRect specialBoxFrame = [[[self specialBoxController] view] frame] ;
		// specialBoxFrame has the correct size, but its origin point is (0,0).
		// The x is easy; just line it up with one of the other boxes.
		specialBoxFrame.origin.x = [importBox frame].origin.x ;
		// The y is more tricky.  We base it on the position of the Export Box
		CGFloat y ;
		if ([exportBox superview] != nil) {
			// The Export Box is in the picture.
			y = NSMaxY([exportBox frame]) ;
			y += MARGIN_BETWEEN_BOXES ;
		}
		else {
			// The Export Box is not in the picture.
			y = NSMinY([exportBox frame]) ;
		}
		specialBoxFrame.origin.y = y ;
		[[[self specialBoxController] view] setFrame:specialBoxFrame] ;
		[[[self window] contentView] addSubview:[[self specialBoxController] view]] ;
	}
	
	CGFloat marginsBetweenBoxes = (numberOfBoxes - 1) * MARGIN_BETWEEN_BOXES ;
	deltaH += marginsBetweenBoxes ;
	
	NSRect frame = [[self window] frame] ;
	frame.size.height += deltaH ;
	[[self window] setFrame:frame
					display:NO] ;
    
    if (
        (
        [[[self client] availablePolaritiesForFolderMaps] count]
        +
        [[[self client] availablePolaritiesForTagMaps] count]
        )
        < 1) {
        [tagFolderMapsButton setHidden:YES] ;
    }
    
    // So that the popup menu will display the selected item instead of
    // being empty…
    [self menuNeedsUpdate:[defaultParentPopup menu]] ;
}

/* Do not make the mistake of setting this method as the didEndSelector for
 the sheet *and* wiring the *Done* button to it.  That would cause it to
 be invoked twice, which will invoke [self release] twice, which will crash. */
- (IBAction)done:(id)sender {
    [self retain] ;
    /* The following line will run the completion handler which will
    release self, so we temporarily retained it above. */
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

- (IBAction)helpMergeBy:(id)sender {
    [(BkmxAppDel*)[NSApp delegate] openHelpAnchor:constHelpAnchorMergeBy] ;
}

- (IBAction)showTalderMapsSheet:(id)button {
	TalderMapsController* windowController = [(TalderMapsController*)[TalderMapsController alloc] initWithClient:[self client]] ;
	// Note: windowController is released in -[TalderMapsController done:]
    // This gets by Clang because we pass it in contextInfo, even though
    // this actually has no effect.
	
	// Note: In the nib containing the sheet/window, make sure that in the
	// window attribute "Visible on Launch" is NOT checked.  If it is,
	// the window will display immediately as a freestanding window
	// instead of the next line attaching it to hostWindow as a sheet.
	
	NSWindow* hostWindow = [self window] ;
	NSWindow* sheet = [windowController window] ;
	
   [hostWindow beginSheet:sheet
         completionHandler:^void(NSModalResponse modalResponse) {
             [windowController release] ;
         }] ;

}

- (IBAction)setPreferredCatchypeFromMenuItem:(NSMenuItem*)menuItem {
    NSNumber* sharypeNumber = [menuItem representedObject] ;
    [[[self client] exporter] setPreferredCatchype:sharypeNumber] ;
}

- (void)menuNeedsUpdate:(NSMenu*)menu {
	[menu removeAllItems] ;
    NSNumber* selectedSharype = [[[self client] exporter] preferredCatchype] ;
	
	for (NSNumber* sharype in [[[self client] exporter] availableHartainers]) {
        NSString* title = [[[self client] exporter] displayNameForHartainer:sharype] ;
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



@end
