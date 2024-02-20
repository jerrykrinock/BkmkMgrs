#import <Foundation/Foundation.h>

@protocol TabViewSizing <NSObject>

- (SSYSizability)sizabilityForTabViewItem:(NSTabViewItem*)tabViewItem ;
- (NSString*)nameOfTabDisallowedInViewingModeForTabViewItem:(NSTabViewItem*)tabViewItem ;
- (void)changeToSubtabAllowedInViewingMode ;
- (BOOL)        rawTabView:(NSTabView*)tabView
   shouldSelectTabViewItem:(NSTabViewItem*)tabViewItem ;

@end
