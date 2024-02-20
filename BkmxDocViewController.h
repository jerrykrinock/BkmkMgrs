#import "SSYExtrospectiveViewController.h"

@class BkmxDocWinCon ;
@class BkmxDoc ;

/*
 @brief    An abstract class for view controllers whose views are loaded into
 the tab views of a BkmxDoc document window
 
 @details  If an instance is initialized whose class is not a subclass of this
 class, which conforms to protocol BkmxDocTabViewControls, an error will be
 logged to stderr.
 */
@interface BkmxDocViewController : NSViewController {
    BkmxDocWinCon* m_windowController ;
    BOOL m_awakened ;
}

@property (assign) BkmxDocWinCon* windowController ;
@property (assign) BOOL awakened ;

- (void)defensiveProgramming ;

- (BkmxDoc*)document ;

- (void)tearDown ;

@end
