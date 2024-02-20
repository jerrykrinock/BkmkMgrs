#import "OperationExpand.h"
#import "BkmxDoc.h"


@implementation SSYOperation (OperationExpand)


- (void)expandAllContent {
	[self doSafely:_cmd] ;
}

- (void)expandAllContent_unsafe {
    BkmxDoc* bkmxDoc = [self.info objectForKey:constKeyDocument];
	[bkmxDoc expandAllContentWork] ;
}	


@end
