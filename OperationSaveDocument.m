#import "OperationSaveDocument.h"
#import "BkmxDoc.h"
#import "AgentPerformer.h"

@implementation SSYOperation (OperationSaveDocument)

- (void)saveDocument {
	/* This section was added in BookMacster 1.7.3 to eliminate hangs, for example…
	 • BookMacster queues a bunch of operations in a document's operation queue. 
	 +   First, there are some operations which edit the document, and near the end
	 +   there is a Save operation.
	 • An error occurs during one of the editing operations.
	 • BookMacster displays a modal dialog asking user to resolve the error.
	 • User ignores the dialog for at least 5 minutes.
	 • During this 5 minutes, Lion will request autosaves every 15 seconds by issuing
	 +   -autosaveWithImplicitCancellability:: with cancellability=YES.  Because it's
	 +   already got operations in the queue and presumably more edits are coming,
	 +   BookMacster responds by invoking the completion handler with an
	 +   NSUserCancelledError; that is, it cancels the autosave.
	 • After 5 minutes, Lion gets impatient and requests autosave with cancellability=NO.
	 +   BookMacster responds by Block_copying the completion handler and adding this
	 +   new Save operation to the operation queue.  Note that the first save operation
	 +   has not executed yet.
	 • User dismisses the modal dialog.
	 • Operations resume dequeueing and executing.
	 • When the original Save operation is dequeued, it experiences the now-familiar
	 +   hang in performActivityWithSynchronousWaiting:usingBlock:.  Apparently this
	 +   is because NSDocument will block in there until the completion
	 +   handler for the recently-requested autosave executes.
	 */	 
	NSInteger i = 0 ;
	for (SSYOperation* operation in [[self operationQueue] operations]) {
		i++ ;
		// The following if() is so we can ignore the current 'save' operation
		if (i>1) {
			if ([operation isKindOfClass:[SSYOperation class]]) {
				NSString* selectorName = NSStringFromSelector([operation selector]) ;
				if (
					[selectorName isEqualToString:@"reallyAutosave"]
					||
					[selectorName isEqualToString:@"saveDocument"]
					) {
					/* Another save operation is on the queue to be executed later.
					 There is no sense in saving now and then re-saving later.  Also, 
					 in the case of reallyAutosave there is an even more important
					 reason.  When reallyAutosave is on the queue, that means that
					 the BkmxDoc has received a -autosaveWithImplicitCancellability:completionHandler:
					 message with cancellability NO, and we have copied the completion
					 handler but have not executed yet.  Therefore if we try and save,
					 we will be blocked in performActivityWithSynchronousWaiting:usingBlock:
					 waiting for reallyAutosave to execute.  That is, a deadlock!
					 
					 Well, the root cause of this deadlock is that we're trying to do this 
					 save and then very soon we're going to do an autosave, which is stupid
					 and redundant.  One of these saves needs to be nixed.  Considering
					 first the Auto Save, I don't see any way to prevent Lion from sending
					 me a autosaveWithImplicitCancellability:: with cancellability=YES when it
					 gets impatient, and once it does so, I don't see any legal way to cancel
					 or in any way not perform the autosave.  So that leaves this Save to be
					 nixed.  This is the implementation.  We've looked ahead in the operation
					 queue to see if any other Saves are on the queue, and we just found
					 one, so we return without doing anything… 
                     
                     This is expected to happen when a new user launches Smarky
                     for the first time, so Warning 464-1857 which was logged
                     here until BookMacster 1.22 was removed.
                     */

					return ;
				}
			}
		}
	}

    BkmxDoc* bkmxDoc = [self.info objectForKey:constKeyDocument];
    BkmxPerformanceType performanceType = [bkmxDoc currentPerformanceType] ;
    BOOL isInAgent = (performanceType == BkmxPerformanceTypeAgent);

    if (isInAgent) {
        /* The purpose of the constNoteBkmxDidFinishSaving mechanism is to
         make our asynchronous saving synchronous, so that the BkmxAgent
         process will not terminate itself before saving is complete.
         (Self-termination is done by -[BkmxAgentAppDel rebootMeIfNonePendingLoggingJobSerial:])
         Another solution to this problem I considered was to opt out of
         asynchronous saving in BkmxAgent; that is, return NO in
         -[BkmxDoc canAsynchronouslyWriteToURL:ofType:forSaveOperation:]
         But I choose or even try that because:
         (1) I have seen that some parts of saving in recent macOS versions
         are asynchronous even if you so opt out of asynchronous saving.
         (2) Since NSDocument and BSManagedDocument and Core Data are so
         complicated, and synchronous vs asynchronous saving may make some
         gut-wrenching changes in behavior, each with its own possible bugs,
         I would rather only need to test and deal with one of them. */
        [self prepareLock];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didFinishSavingNote:)
                                                     name:constNoteBkmxDidFinishSaving
                                                   object:bkmxDoc];
    }
    
    [self doSafely:_cmd] ;

    if (isInAgent) {
        /* Block here until the asynchronous saving is done, effectively making
        it synchronous, as explained in previous comment */
        [self blockForLock];
    }
}

- (void)saveDocument_unsafe {	
    BkmxDoc* bkmxDoc = [self.info objectForKey:constKeyDocument];
	NSNumber* saveOperation = [[self info] objectForKey:constKeySaveOperation] ;
	if (saveOperation) {
		[bkmxDoc saveDocumentFinalOpType:[saveOperation integerValue]] ;
	}
	else {
		NSLog(@"Internal Error 167-8453");
        [[NSNotificationCenter defaultCenter] postNotificationName:constNoteBkmxDidFinishSaving
                                                            object:bkmxDoc];
	}
}

- (void)didFinishSavingNote:(NSNotification*)note {
    [self unlockLock];  // Was locked in -[SSYOperation(OperationSaveDocument) saveDocument]
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:constNoteBkmxDidFinishSaving
                                                  object:nil];
}

@end
