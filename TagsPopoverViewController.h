#import <Cocoa/Cocoa.h>

@class SSYTokenField ;
@class ContentOutlineView ;
@class CntntViewController ;

@interface TagsPopoverViewController : NSViewController {
    IBOutlet NSTextField* labelField ;
    IBOutlet SSYTokenField* tokenField ;
    IBOutlet ContentOutlineView* contentOutlineView ;
    IBOutlet CntntViewController* contentViewController ;
    IBOutlet NSPopover* popover ;
}

- (void)tearDown ;
- (IBAction)dismiss:(id)sender ;

@end
