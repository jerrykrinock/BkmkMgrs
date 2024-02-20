#import <Cocoa/Cocoa.h>

@class StarkCruft ;

@interface ApproveCruftController : NSWindowController

@property (assign) IBOutlet NSArrayController* starkCruftsArrayController ;
@property (retain) NSSet <StarkCruft*> * starkCrufts ;
@property (assign) IBOutlet NSTableView* tableView ;
@property (assign) IBOutlet NSButton* removeSelectedCruftButton ;

- (instancetype)initWithStarkCrufts:(NSSet <StarkCruft*> *)starkCrufts ;

- (IBAction)help:(id)sender ;
- (IBAction)cancel:(id)sender ;
- (IBAction)selectAll:(id)sender ;
- (IBAction)selectNone:(id)sender ;
- (IBAction)removeSelectedCruft:(id)sender ;

@end
