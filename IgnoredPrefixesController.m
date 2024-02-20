#import "IgnoredPrefixesController.h"
#import "SSYWindowHangout.h"

@interface IgnoredPrefixesController ()

@end

@implementation IgnoredPrefixesController

/* Do not make the mistake of setting this method as the didEndSelector for
 the sheet *and* wiring the *Done* button to it.  That would cause it to
 be invoked twice, which will invoke [self release] twice, which will crash. */
- (IBAction)done:(id)sender {
    [self retain] ;
    [[[self window] sheetParent] endSheet:[self window]
                               returnCode:NSAlertFirstButtonReturn] ;

	[[self window] close] ;
    // This will also release the sheet's controller (IgnoredPrefixesController)
    // due to the action of SSYWindowHangout.
	// Window itself is set to "Release when closed" in xib.
    [self release] ;
}

+ (void)showSheetOnWindow:(NSWindow*)window {
	IgnoredPrefixesController* sheetController = [[IgnoredPrefixesController alloc] initWithWindowNibName:@"IgnoredPrefixes"] ;
    [SSYWindowHangout hangOutWindowController:sheetController] ;
    [sheetController release] ;
	
	// Note: In the nib containing the sheet/window, make sure that in the
	// window attribute "Visible on Launch" is NOT checked.  If it is,
	// the window will display immediately as a freestanding window
	// instead of the next line attaching it to hostWindow as a sheet.
	
	NSWindow* sheet = [sheetController window] ;
	
	[window beginSheet:sheet
     completionHandler:^void(
                             NSModalResponse modalResponse) {
         // Nothing to do here
     }] ;
}

@end
