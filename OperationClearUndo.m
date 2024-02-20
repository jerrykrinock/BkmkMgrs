#import "OperationClearUndo.h"
#import "BkmxDoc.h"
#import "SSYDooDooUndoManager.h"

@implementation SSYOperation (OperationClearUndo)

- (void)clearUndo {
	[self doSafely:_cmd] ;
}

- (void)clearUndo_unsafe {
    BkmxDoc* bkmxDoc = [self.info objectForKey:constKeyDocument];
	[(SSYDooDooUndoManager*)[bkmxDoc undoManager] removeAllActions] ;
}	


@end
