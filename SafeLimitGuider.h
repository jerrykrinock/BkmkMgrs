#import <Foundation/Foundation.h>
#import "BkmxDocumentProvider.h"

@interface SafeLimitGuider : NSObject {
    NSWindowController <BkmxDocumentProvider> * m_windowController ;
    NSObject <BkmxDocumentProvider> * m_documentProvider ;
}

/*!
 @details  Warning about other windows.  Make sure that your target window
 is not obscured by other windows.  Also remember that
 -[NSWindow makeKeyAndOrderFront:] will not help against windows in higher
 levels, such as floating palettes for example Inspectors */
+ (void)guideUserFromMenuItem:(NSMenuItem*)menuItem
             windowController:(NSWindowController*)windowController
             documentProvider:(NSObject <BkmxDocumentProvider> *)documentProvider ;

+ (void)removeWindowController:(NSWindowController*)windowController
              documentProvider:(NSObject <BkmxDocumentProvider> *)documentProvider ;

@end
