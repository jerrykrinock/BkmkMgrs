#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "SSYTempWindowController.h"

@interface NewUserSetupWinCon : SSYTempWindowController <WKNavigationDelegate> {
    IBOutlet NSView* bigButtonsView ;
    IBOutlet NSView* bookView ;
    IBOutlet NSSegmentedControl* forwardBackControl ;
    IBOutlet NSSearchField* searchField ;
    IBOutlet NSView* helpNavigationRect ;
    
    NSString* m_stringValue ;
}

- (IBAction)showUseSingly:(id)sender ;
- (IBAction)showUseSync:(id)sender ;
- (IBAction)showUseDirectly:(id)sender ;
- (IBAction)showUseCustom:(id)sender ;

- (IBAction)forwardBack:(NSSegmentedControl*)sender ;
- (IBAction)search:(NSSearchField*)sender ;

@end
