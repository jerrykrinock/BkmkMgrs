#import "SSYSplitView.h"

@implementation SSYSplitView

#if 0
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

- (void)resizeSubviewsWithOldSize:(NSSize)oldBoundsSize {

 NSRect screenFrame = [[[self window] screen] frame] ;

    if (oldBoundsSize.width > screenFrame.size.width) {
        NSLog(@"Warning 502-9481 clipped split view width to %f",
              screenFrame.size.width) ;
    }
    if (oldBoundsSize.height > screenFrame.size.height) {
        NSLog(@"Warning 502-9482 clipped split view height to %f",
              screenFrame.size.height) ;
    }
    
    [super resizeSubviewsWithOldSize:oldBoundsSize] ;
}
#endif


@end
