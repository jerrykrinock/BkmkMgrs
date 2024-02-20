#import <Cocoa/Cocoa.h>

@class Macster ;
@class BkmxDoc ;

@interface ImportPostprocController : NSWindowController
#if (MAC_OS_X_VERSION_MAX_ALLOWED >= 1060)
	<NSMenuDelegate>
#endif
{
	IBOutlet NSPopUpButton* ibo_importSafeLimitPopup ;
    IBOutlet NSPopUpButton* defaultParentPopup ;
	Macster* m_macster ;
}

@property (assign) Macster* macster ;

+ (void)showSheetOnWindow:(NSWindow*)window
                 document:(BkmxDoc*)document ;

- (id)initWithMacster:(Macster*)macster ;

- (NSPopUpButton*)importSafeLimitPopup ;

- (IBAction)done:(id)sender ;

- (IBAction)help:(id)sender ;

@end
