#import <Cocoa/Cocoa.h>

@class Client ;

@interface ClientSpecialBoxController : NSViewController {
	Client* m_client ;
}

@property (assign, readonly) Client* client ;

- (id)initWithClient:(Client*)client ;

- (IBAction)helpLaunchBrowserPrefs:(id)sender ;
- (IBAction)helpIxportDownloadPolicy:(id)sender ;
- (IBAction)helpNoLoosiesInMenu:(id)sender ;
- (IBAction)helpFakeUnfiled:(id)sender ;

@end
