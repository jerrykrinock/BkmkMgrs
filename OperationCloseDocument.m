#import "OperationCloseDocument.h"
#import "BkmxGlobals.h"
#import "BkmxDoc.h"

@implementation SSYOperation (OperationCloseDocument)

- (void)closeDocument {
	[self doSafely:_cmd] ;
}

- (void)closeDocument_unsafe {	
	BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument] ;
	[bkmxDoc close] ;
}

- (void)reloadFromDisk {
    [self doSafely:_cmd] ;
}

- (void)reloadFromDisk_unsafe {
	BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument] ;
    [bkmxDoc reloadFromDiskNow] ;
}

@end
