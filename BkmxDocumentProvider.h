#import <Foundation/Foundation.h>

@class BkmxDoc ;
@class ClientListView ;

@protocol BkmxDocumentProvider <NSObject>

/*
 @details  I tried to name this simply 'document', but this caused an infinite
 loop because, it looks like, -[NSDocumentController frontmostDocument]
 makes its determination by sending -document to the key or main window.
 Here is a couple loop cycles snipped from the call stack…
 #49805	0x00000001000e644d in -[PrefsWinCon document] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/PrefsWinCon.m:669
 #49806	0x00007fff8cc3855d in -[NSDocumentController frontmostDocument] ()
 #49807	0x0000000100031737 in -[BkmxDocumentController frontmostDocument] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/BkmxDocumentController.m:903
 #49808	0x0000000100031fc4 in -[BkmxDocumentController shoeboxDocument] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/BkmxDocumentController.m:993
 #49809	0x00000001000e644d in -[PrefsWinCon document] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/PrefsWinCon.m:669
 #49810	0x00007fff8cc3855d in -[NSDocumentController frontmostDocument] ()
 #49811	0x0000000100031737 in -[BkmxDocumentController frontmostDocument] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/BkmxDocumentController.m:903
 #49812	0x0000000100031fc4 in -[BkmxDocumentController shoeboxDocument] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/BkmxDocumentController.m:993
 #49813	0x00000001000e644d in -[PrefsWinCon document] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/PrefsWinCon.m:669
 */
- (BkmxDoc*)theDocument ;

/*
 @details  Bound by the image view in Settings.xib > Clients/Browsers
 and in Preferences.xib > Syncing
 */
- (NSImage*)documentImage ;

- (NSButton*)importPostprocButton ;

- (ClientListView*)clientListView ;

- (IBAction)revealTabViewClients ;

- (IBAction)guideUserToSafeLimitMenuItem:(NSMenuItem*)menuItem ;

@end
