#import "ClientSpecialBoxController.h"
#import "Client.h"
#import "NSString+BkmxDisplayNames.h"
#import "NSString+LocalizeSSY.h"
#import "Extore.h"
#import "Macster.h"
#import "BkmxAppDel.h"
#import "SSYMH.AppAnchors.h"
#import "NSString+SSYExtraUtils.h"


@interface ClientSpecialBoxController ()

@property (assign) Client* client ;

@end


@implementation ClientSpecialBoxController

@synthesize client = m_client ;

- (BkmxDoc*)document {
    return [[[self client] macster] bkmxDoc] ;
}

- (id)initWithClient:(Client*)client {
	Class extoreClass = [client extoreClass] ;		
	NSString* specialNibName = [extoreClass specialNibName] ;
	// Super's -initWithNibName:bundle: will raise an exception if the
	// named nib is not found.  So we need to preflight it.
	NSString* nibPath = [[NSBundle mainBundle] pathForResource:specialNibName
														ofType:@"nib"] ;
	if (!nibPath) {
		return nil ;
	}

	self = [super initWithNibName:specialNibName
						   bundle:nil] ;
	if (self) {
		[self setClient:client] ;
	}
	
	return self ;
}

#if 0
/*
 In BookMacster 1.5.7, I found that when a Collection window containing a
 Client for which the Advanced Client Settings sheet had Special Options
 which had been showing was later closed, I would get the dreaded
 "An instance 0x1653cb0 of class Client… was deallocated while key value
  observers were still registered with it…, going on to implicate the
  binding(s) on the controls in the special box.  I fixed this by:
 
 • Make this class a subclass of NSSpeciController instead of NSObject.
 • Replace the -initWithClient implementation below with the one above.
 • Remove the ibo_box outlet and 'box' ivar,  In ClientInfoController,
 invoke our -view instead of -box.
 • In each Special nib file, add an Object Controller.  Name it
 "Client Controller".  Bind its Content Object to File's Owner ▸ client.
 • In each Special nib file, disconnect the defunct ibo_box outlet
 from File's Owner.
 • In each Special nib file, note that, because it is now a subclass of 
 NSViewController, File's Owner now has a -view outlet.  Connect it to
 the top-level NSBox in the nib.
 • In each Special nib file, change all controls' bindings from from
 File's Owner ▸ client.whatever to Client Controller ▸ content ▸ whatever.
*/
- (id)initWithClient:(Client*)client {
	self = [super init] ;
	if (self) {
		// Needed immediately for bindings, when nib loads… 
		[self setClient:client] ;
		
		Class extoreClass = [client extoreClass] ;
		
		NSString* specialNibName = [extoreClass specialNibName] ;
		BOOL didLoadNib = [NSBundle loadNibNamed:specialNibName
										   owner:self] ;
		
		if (!didLoadNib) {
			// The given Client does not have a Special Box.
			// See http://lists.apple.com/archives/Objc-language/2008/Sep/msg00133.html ...
			[super dealloc] ;
			self = nil ;
		}
	}
	
	return self ;
}
#endif

/* Bound to in the nib */
- (NSString*)boxTitle {

	NSString* name = [[[self client] exformat] exformatDisplayName] ;
	return [NSString localizeFormat:
			@"settingsSpecialForX",
			name] ;
}

- (IBAction)helpLaunchBrowserPrefs:(id)sender {
	[(BkmxAppDel*)[NSApp delegate] openHelpAnchor:constHelpAnchorLaunchBrowserPref] ;
}

- (IBAction)helpIxportDownloadPolicy:(id)sender {
	[(BkmxAppDel*)[NSApp delegate] openHelpAnchor:constHelpAnchorIxportDownloadPolicy] ;
}

- (IBAction)helpNoLoosiesInMenu:(id)sender {
    [(BkmxAppDel*)[NSApp delegate] openHelpAnchor:constHelpAnchorNoLoosiesInMenu] ;
}
- (IBAction)helpFakeUnfiled:(id)sender {
    [(BkmxAppDel*)[NSApp delegate] openHelpAnchor:constHelpAnchorFakeUnfiled] ;
}

- (NSString*)labelIxportDownloadPolicy {
    return [@"Download from the server during" ellipsize] ;
}

@end
