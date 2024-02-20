#import <Cocoa/Cocoa.h>

@class FindViewController ;

@interface FindTableView : NSTableView {
    IBOutlet NSArrayController* arrayControllerPeek ;
}

@property (assign) IBOutlet FindViewController* findViewController ;

- (void)restoreFromAutosaveState:(NSDictionary*)state ;

- (NSArrayController*)arrayControllerPeek ;

@end
