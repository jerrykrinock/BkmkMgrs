#import <Cocoa/Cocoa.h>
#import "SSYTempWindowController.h"
#import "ExtensionsCallbackee.h"

@class ManageExtensionsControl ;
@class ExtensionDetectionTester ;

@interface ExtensionsWinCon : SSYTempWindowController <NSWindowDelegate, ExtensionsCallbackee> {
	IBOutlet NSTextField* introText_outlet ;
	IBOutlet NSTextField* versionsLabel_outlet ;
    IBOutlet ManageExtensionsControl* managerView_outlet ;
    IBOutlet NSButton* refreshButton_outlet ;
    IBOutlet NSButton* moreTestsButton_outlet ;
    IBOutlet NSButton* closeButton_outlet ;
    
    ExtensionDetectionTester* m_detectionTester ;
    
    BOOL m_isWaitingForCallback ;
}

/*!
 @details  The only purpose of this is to keep the window from being closed
 if the receiver might get a callback.
 */
@property (assign) BOOL isWaitingForCallback ;

- (IBAction)help:(id)sender ;
- (IBAction)refresh:(id)sender ;
- (IBAction)moreTests:(id)sender ;
- (IBAction)close:(id)sender ;

- (void)refresh;

@end
