#import <Foundation/Foundation.h>

/*
 @brief    Companion to abstract class BkmxDocViewController, declaring the
 methods which are required for subclasses but not implemented in 
 BkmxDocViewController
 */
@protocol BkmxDocTabViewControls <NSObject>

- (void)reload ;
- (void)updateWindow ;
- (void)tearDown ;
- (BOOL)disallowInVersionsBrowserTabViewItem:(NSTabViewItem*)tabViewItem ;
- (void)autosaveAllCurrentValues ;

@end
