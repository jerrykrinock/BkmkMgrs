#import "OperationRevert.h"
#import "BkmxGlobals.h"
#import "BkmxDoc.h"
#import "NSString+LocalizeSSY.h"
#import "SSYProgressView.h"

@implementation SSYOperation (OperationRevert)

- (void)revert {
	[self doSafely:_cmd] ;
}

- (void)revert_unsafe {	
	BOOL ok ;
	NSError* error = nil ;

	BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument] ;

	ok = [bkmxDoc revertError_p:&error] ;
	if (ok) {
		[[self info] setObject:[NSNumber numberWithBool:YES]
						forKey:constKeyDidRevert] ;
	}
	else {
		[self setError:error] ;
	}
}

// Cannot run in arbitrary thread since NSUndoManager is not thread safe.
- (void)showCompletionReverted {
	[self doSafely:_cmd] ;
}

- (void)showCompletionReverted_unsafe {
    BkmxDoc* bkmxDoc = [self.info objectForKey:constKeyDocument];
	SSYProgressView* progressView = [bkmxDoc progressView] ;
	if (progressView) {
		// Must be in MainApp
		if ([[[self info] objectForKey:constKeyDidRevert] boolValue]) {
			[progressView showCompletionVerb:[NSString localize:@"revert"]
                                      result:nil
                                    priority:SSYProgressPriorityRegular] ;
		}
	}
}	

@end
