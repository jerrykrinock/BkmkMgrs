#import <Cocoa/Cocoa.h>

@interface SpecifyCruftController : NSWindowController

@property (assign) IBOutlet NSArrayController* cruftSpecArrayController ;

- (IBAction)addDefaultItems:(id)sender ;
- (IBAction)help:(id)sender ;
- (IBAction)cancel:(id)sender ;
- (IBAction)search:(id)sender ;

@end
