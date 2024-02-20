#import <Bkmxwork/Bkmxwork-Swift.h>
#import "OperationDeleteAllContent.h"
#import "BkmxDoc.h"
#import "SSYProgressView.h"
#import "Starker.h"
#import "BkmxBasis+Strings.h"
#import "StarkEditor.h"

@implementation SSYOperation (OperationDeleteAllContent)


- (void)deleteAllContent {
	[self doSafely:_cmd] ;
}

- (void)deleteAllContent_unsafe {
    BkmxDoc* bkmxDoc = [self.info objectForKey:constKeyDocument];
	[[BkmxBasis sharedBasis] logFormat:@"Deleting all Content in %@", [bkmxDoc displayName]] ;
    NSError* error = nil;

    /* Theoreticaly, we could just delete all starks and rely on the Casecade
     Delete Rule to deet*/
    BOOL ok = [[bkmxDoc tagger] deleteAllObjectsError_p:&error];
    if (ok) {
        ok = [[bkmxDoc starker] deleteAllObjectsError_p:&error];
    }
    if (!ok) {
        [self setError:error];
    }
    
    [[bkmxDoc managedObjectContext] processPendingChanges];
}

// Cannot run in arbitrary thread since NSUndoManager is not thread safe.
- (void)showCompletionDeleteAllContent {
	[self doSafely:_cmd] ;
}

- (void)showCompletionDeleteAllContent_unsafe {
    BkmxDoc* bkmxDoc = [self.info objectForKey:constKeyDocument];
	SSYProgressView* progressView = [bkmxDoc progressView] ;
	if (progressView) {
		// Must be in MainApp
		[progressView showCompletionVerb:[[BkmxBasis sharedBasis] labelDeleteAllContent]
                                  result:nil
                                priority:SSYProgressPriorityRegular] ;
	}
}	


@end
