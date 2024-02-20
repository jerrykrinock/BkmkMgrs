#import "BkmxScriptCommands.h"
#import "BkmxDoc+Actions.h"
#import "Syncer.h"
#import "AgentPerformer.h"
#import "SSYOperationQueue.h"
#import "BkmxBasis.h"
#import "Trigger.h"
#import "Macster.h"
#import "BkmxDocWinCon.h"
#import "NSObject+MoreDescriptions.h"
#import "BkmxAppDel+Actions.h"
#import "Extore.h"
#import "NSUserDefaults+Bkmx.h"
#import "BkmxDocumentController.h"
#import "Job.h"

/* No method declarations are necessary since AppleScripts don't read header
 files.  Declarations are kind of in the .sdef file. */

/*!
 @brief    Superclass for other script command subclasses which
 require suspension until threaded operations are done.
*/
@interface BkmxThreadedScriptCommand : NSScriptCommand

- (void)resumeExecutionWithResult:(id)result ;

@end

@implementation BkmxThreadedScriptCommand

- (void)resumeExecutionWithResult:(id)result {
    /* I tried adding [[AgentPerformer sharedPerformer] nowWorkingJobSerial]
     to this log entry, but apparently [[AgentPerformer sharedPerformer] nowWorkingJobSerial]
     has already been set to 0 at this point. */
	[[BkmxBasis sharedBasis] logFormat:@"Done \u279E Returning to AppleScripter"] ;
	[[BkmxBasis sharedBasis] setCurrentAppleScriptCommand:nil] ;
	[super resumeExecutionWithResult:result] ;
}
/*
 Sometimes the above method ends in a memory leak…
 
 Process 43752: 110808 nodes malloced for 14399 KB
 Process 43752: 1 leak for 48 total leaked bytes.
 Leak: 0x109907690  size=48  zone: DefaultMallocZone_0x100724000   NSScriptExecutionContextMoreIVars  ObjC  Foundation
 0x7c7d7d88 0x00007fff 0x00000000 0x00000000 	.}}|............
 0x00000000 0x00000000 0x00000000 0x00000000 	................
 0x00000000 0x00000000 0x00000000 0x00000000 	................
 Call stack: [thread 0x107c04000]: | start_wqthread | _pthread_wqthread | _dispatch_worker_thread2 | _dispatch_queue_invoke | _dispatch_source_invoke | _dispatch_client_callout | _dispatch_after_timer_callback | _dispatch_client_callout | __NSOQDelayedFinishOperations | -[NSObject(NSKeyValueObservingPrivate) _changeValueForKey:key:key:usingBlock:] | NSKeyValueDidChange | NSKeyValueNotifyObserver | -[SSYOperationQueue observeValueForKeyPath:ofObject:change:context:] SSYOperationQueue.m:221 | -[BkmxThreadedScriptCommand resumeExecutionWithResult:] BkmxScriptCommands.m:31 | -[NSAppleEventManager(NSInternal) _resumeIfNotTopHandling:withScriptCommandResult:] | -[NSAppleEventHandling resumeWithScriptCommandResult:] | -[NSScriptCommand(NSInternal) _populateReplyAppleEventWithResult:] | +[NSScriptExecutionContext sharedScriptExecutionContext] | -[NSScriptExecutionContext init] | _objc_rootAllocWithZone | class_createInstance | calloc | malloc_zone_calloc
*/

@end


/* This is an verb-first script command implementation. */
/* This is the more sensible way to implement a command
 with no direct parameter. */
@interface DisplayErrorLogsScriptCommand : NSScriptCommand
@end
@implementation DisplayErrorLogsScriptCommand
- (id)performDefaultImplementation {
	[(BkmxAppDel*)[NSApp delegate] displayErrorLogs] ;
	
	id result = [super performDefaultImplementation] ;
	// Note: The return value will be nil in this case.
	
	return result ;
}
@end

/* This is an verb-first script command implementation. */
/* This is the more sensible way to implement a command
 with no direct parameter. */
@interface PresentLastLoggedErrorScriptCommand : NSScriptCommand
@end
@implementation PresentLastLoggedErrorScriptCommand
- (id)performDefaultImplementation {
	[(BkmxAppDel*)[NSApp delegate] makeForeground:self] ;
    NSDictionary* evaluatedArguments = [self evaluatedArguments] ;
    NSNumber* codeNumber = [evaluatedArguments objectForKey:@"code"] ;
    NSInteger code = 0;
    if ([codeNumber respondsToSelector:@selector(integerValue)]) {
        code = codeNumber.integerValue;
    }
	NSInteger result = [(BkmxAppDel*)[NSApp delegate] presentLastLoggedErrorWithCode:code] ;
	
	[super performDefaultImplementation] ;
	// Note: The return value will be nil in this case.
	
	return [NSNumber numberWithInteger:result] ;
}
@end

/* This is an verb-first script command implementation. */
/* This is the more sensible way to implement a command
 with no direct parameter. */
@interface OpenNotificationSettingsScriptCommand : NSScriptCommand
@end
@implementation OpenNotificationSettingsScriptCommand
- (id)performDefaultImplementation {
    [(BkmxAppDel*)[NSApp delegate] makeForeground:self] ;
    NSInteger result = [(BkmxAppDel*)[NSApp delegate] openNotificationSettings] ;
    
    [super performDefaultImplementation] ;
    // Note: The return value will be nil in this case.
    
    return [NSNumber numberWithInteger:result] ;
}
@end

/* This is an verb-first script command implementation. */
/* This is the more sensible way to implement a command
 with no direct parameter. */
@interface DisplayInspectorScriptCommand : NSScriptCommand
@end
@implementation DisplayInspectorScriptCommand
- (id)performDefaultImplementation {
	[(BkmxAppDel*)[NSApp delegate] showInspectorWithOomph] ;
	
	id result = [super performDefaultImplementation] ;
	// Note: The return value will be nil in this case.

	return result ;
}
@end

/* This is an verb-first script command implementation. */
/* This is the more sensible way to implement a command
 with no direct parameter. */
@interface DisplayManageBrowserAddOnsScriptCommand : NSScriptCommand
@end
@implementation DisplayManageBrowserAddOnsScriptCommand
- (id)performDefaultImplementation {
	[(BkmxAppDel*)[NSApp delegate] manageAddOns:self] ;
	
	id result = [super performDefaultImplementation] ;
	// Note: The return value will be nil in this case.
    
	return result ;
}
@end

/* This is an verb-first script command implementation. */
/* This is the more sensible way to implement a command
 with no direct parameter. */
@interface HideInspectorScriptCommand : NSScriptCommand
@end
@implementation HideInspectorScriptCommand
- (id)performDefaultImplementation {
	[(BkmxAppDel*)[NSApp delegate] doShowInspector:NO] ;
	
	id result = [super performDefaultImplementation] ;
	// Note: The return value will be nil in this case.
    
	return result ;
}
@end

@interface AddBookmarkCommand : NSScriptCommand
@end
@implementation AddBookmarkCommand
- (id)performDefaultImplementation {
	
	NSDictionary* evaluatedArguments = [self evaluatedArguments] ;
	[(BkmxAppDel*)[NSApp delegate] landNewBookmarkWithInfo:evaluatedArguments] ;

	id result = [super performDefaultImplementation] ;
	// Note: The return value will be nil in this case.
	
	return result ;
}
@end

@interface NSScriptCommand (UndoManagerExceptions)

- (void)handleUndoManagerExceptionBkmxDoc:(BkmxDoc*)bkslf ;

@end

@implementation NSScriptCommand (UndoManagerExceptions)

- (void)handleUndoManagerExceptionBkmxDoc:(BkmxDoc*)bkmxDoc {
	id undoManager = [bkmxDoc undoManager] ;
	SEL selector = NSSelectorFromString(@"exception") ;
	if ([undoManager respondsToSelector:selector]) {
		// Undo Manager must be an instance of GCUndoManager.  Yea!!
		NSException* exception = [undoManager performSelector:selector] ;
		if (exception) {
			[self setScriptErrorNumber:353030] ;
			[self setScriptErrorString:[NSString stringWithFormat:
										@"%@.  Reason: %@\ninfo:%@",
										[exception name],
										[exception reason],
										[exception userInfo]]] ;
			selector = NSSelectorFromString(@"clearException") ;
			if ([undoManager respondsToSelector:selector]) {
				[undoManager performSelector:selector] ;
			}	
		}
	}
}

@end



@interface RevealTabCommand : NSScriptCommand
@end
@implementation RevealTabCommand
- (id)performDefaultImplementation {
	BkmxDoc* bkmxDoc = [self evaluatedReceivers] ;
	if (![bkmxDoc respondsToSelector:@selector(revealTabViewIdentifier:)]) {
		[self setScriptErrorNumber:19101] ;
		[self setScriptErrorString:[NSString stringWithFormat:@"Receiver must be a Collection (.bmco file)"]] ;
		return nil ;
	}
	
	NSDictionary* evaluatedArguments = [self evaluatedArguments] ;
	NSString* identifier = [evaluatedArguments objectForKey:@"Identifier"] ;
	if (!identifier) {
		[self setScriptErrorNumber:19102] ;
		[self setScriptErrorString:[NSString stringWithFormat:@"Command 'reveal tab' requires parameter 'identifier'"]] ;
		return nil ;
	}
	
	BOOL ok = [bkmxDoc revealTabViewIdentifier:identifier] ;
	if (!ok) {
		[self setScriptErrorNumber:19103] ;
		[self setScriptErrorString:[NSString stringWithFormat:@"Unrecognized tab view identifier '%@'", identifier]] ;
	}

	NSNameSpecifier* nameSpecifier = [super performDefaultImplementation] ;

	return nameSpecifier ;
}
@end

@interface PerformCommand : BkmxThreadedScriptCommand
@end
@implementation PerformCommand
- (id)performDefaultImplementation {
	// Note that because this command requires syncer and trigger *objects*
	// as direct parameter and parameter, AppleScript has already done the
	// range checking for us.  In other words, if someone says to perform
	// for trigger trigger 15, AppleScript will say that it can't get
	// trigger 15.
	
	Syncer* syncer = [self evaluatedReceivers] ;
	NSInteger agentIndex = [[syncer index] integerValue] ;
	if (![syncer isKindOfClass:[Syncer class]]) {
		[[BkmxBasis sharedBasis] logFormat:@"Rejected AppleScript : Bad syncer"] ;
		[self setScriptErrorNumber:19111] ;
		[self setScriptErrorString:[NSString stringWithFormat:@"Receiver of command 'perform' must be an syncer"]] ;
		return nil ;
	}
	
	NSDictionary* evaluatedArguments = [self evaluatedArguments] ;
	Trigger* trigger = [evaluatedArguments objectForKey:@"trigger"] ;
	if (trigger) {
		if (![trigger isKindOfClass:[Trigger class]]) {
			[[BkmxBasis sharedBasis] logFormat:@"Rejected AppleScript : Bad trigger"] ;
			[self setScriptErrorNumber:19112] ;
			[self setScriptErrorString:[NSString stringWithFormat:@"Parameter 'for trigger' must be a trigger"]] ;
			return nil ;
		}
	}

	[[BkmxBasis sharedBasis] logFormat:
	 @"AppleScripted: perform Syncer %d, %@",
	 agentIndex+1,
	 [Trigger smallDescriptionOfTrigger:trigger]] ;
	
	[[BkmxBasis sharedBasis] setCurrentAppleScriptCommand:self] ;

    BkmxDocumentController* dc = (BkmxDocumentController*)[NSDocumentController sharedDocumentController];
    [dc openDocumentWithUuid:syncer.macster.docUuid
                     appName:nil
                     display:NO
              aliaserTimeout:20.3211
           completionHandler:^(BkmxDoc *bkmxDoc, NSURL *resolvedUrl, BOOL documenWasAlreadyOpen, NSError *error) {
               if (error) {
                   NSString* msg = [NSString stringWithFormat:
                                    @"AppleScript : Could not open Collection : %@",
                                    error] ;
                   [[BkmxBasis sharedBasis] logFormat:msg] ;
                   [self setScriptErrorNumber:19120] ;
                   [self setScriptErrorString:msg] ;
               }
               else {
                   [[bkmxDoc operationQueue] setScriptCommand:self] ;
                   Job* job = [Job new];
                   job.serial = [[NSUserDefaults standardUserDefaults] nextJobSerialforCreator:@"AppleScript Perform Syncer"];
                   job.syncerUri = syncer.objectID.URIRepresentation.absoluteString;
                   job.syncerIndex = syncer.index.integerValue;
                   job.triggerUri = trigger.objectID.URIRepresentation.absoluteString;
                   job.triggerIndex = trigger.index.integerValue;
                   job.docUuid = bkmxDoc.uuid;
                   [[AgentPerformer sharedPerformer] performOverrideDeference:BkmxDeferenceUndefined
                                                                  ignoreLimit:NO
                                                                          job:job
                                                              performanceType:BkmxPerformanceTypeScripted
                                                                 errorAlertee:nil] ;
                   [job release];
                   
                   [self suspendExecution] ;
                   // The corresponding invocation of -resumeExecutionWithResult: is
                   // done in -[SSYOperationQueue observeValueForKeyPath:ofObject:change:context:],
                   // when the number of operations == 0; i.e. when all operations are finished.
                   // -[NSScriptCommand suspendExecution] is magic.  Although it
                   // returns immediately, and this method returns a "result", this result is held
                   // somewhere and the calling AppleScript is left hanging until
                   // -resumeExecutionWithResult: executes.
               }
           }] ;
    
    return nil ;
}
@end

@interface ImportCommand : BkmxThreadedScriptCommand
@end
@implementation ImportCommand
- (id)performDefaultImplementation {
	// Get the receiver/object of the command
	BkmxDoc* bkmxDoc = [self evaluatedReceivers] ;
	if (![bkmxDoc isKindOfClass:[BkmxDoc class]]) {
		[[BkmxBasis sharedBasis] logFormat:@"Rejected AppleScript : Bad Collection parameter"] ;
		[self setScriptErrorNumber:19121] ;
		[self setScriptErrorString:[NSString stringWithFormat:@"Direct object of command 'import' must be an open Collection"]] ;
		return nil ;
	}
	
    if ([[[bkmxDoc macster] activeImportersOrdered] count] < 1) {
        [[BkmxBasis sharedBasis] logFormat:@"Rejected AppleScript : No active importers"] ;
		[self setScriptErrorNumber:19122] ;
		[self setScriptErrorString:[NSString stringWithFormat:@"No active import clients"]] ;
		return nil ;
        
    }
	
	[[BkmxBasis sharedBasis] logFormat:
	 @"AppleScripted: import %@",
	 [bkmxDoc displayName]] ;
	
	// Get the parameters
	NSDictionary* evaluatedArguments = [self evaluatedArguments] ;
	NSNumber* deference = [evaluatedArguments objectForKey:@"deference"] ;
	if (!deference) {
		deference = [NSNumber numberWithInteger:BkmxDeferenceAsk] ;
	}
	NSNumber* ignoreLimit = [evaluatedArguments objectForKey:@"ignoreLimit"] ;  // defaults to nil

	[[BkmxBasis sharedBasis] setCurrentAppleScriptCommand:self] ;
	
	[[bkmxDoc operationQueue] setScriptCommand:self] ;
    
    Job* job = [Job new];
    job.serial = [[NSUserDefaults standardUserDefaults] nextJobSerialforCreator:@"AppleScript Import"];
	NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								 [NSNumber numberWithBool:YES], constKeyIfNotNeeded,
								 [NSNumber numberWithInteger:BkmxPerformanceTypeScripted], constKeyPerformanceType,
								 deference, constKeyDeference,
								 bkmxDoc, constKeyDocument,
                                 job, constKeyJob,
								 ignoreLimit, constKeyIgnoreLimit, // may be nil sentinel
								 nil] ;
    [job release];
	[bkmxDoc importLaInfo:info
	 grandDoneInvocation:nil] ;
	
	[self suspendExecution] ;
	// The corresponding invocation of -resumeExecutionWithResult: is
	// done in -[SSYOperationQueue observeValueForKeyPath:ofObject:change:context:],
	// when the number of operations == 0; i.e. when all operations are finished.
	// -[NSScriptCommand suspendExecution] is magic.  Although it
	// returns immediately, and this method returns a "result", this result is held
	// somewhere and the calling AppleScript is left hanging until
	// -resumeExecutionWithResult: executes.
	
	return nil ;
}
@end


@interface ExportCommand : BkmxThreadedScriptCommand
@end
@implementation ExportCommand
- (id)performDefaultImplementation {
	// Get the receiver/object of the command
	BkmxDoc* bkmxDoc = [self evaluatedReceivers] ;
	if (![bkmxDoc isKindOfClass:[BkmxDoc class]]) {
		[[BkmxBasis sharedBasis] logFormat:@"Rejected AppleScript : Bad Collection parameter"] ;
		[self setScriptErrorNumber:19125] ;
		[self setScriptErrorString:[NSString stringWithFormat:@"Direct object of command 'export' must be an open Collection"]] ;
		return nil ;
	}
    
    if ([[[bkmxDoc macster] activeExportersOrdered] count] < 1) {
        [[BkmxBasis sharedBasis] logFormat:@"Rejected AppleScript : No active exporters"] ;
		[self setScriptErrorNumber:19126] ;
		[self setScriptErrorString:[NSString stringWithFormat:@"No active export clients"]] ;
		return nil ;

    }
	
	[[BkmxBasis sharedBasis] logFormat:
	 @"AppleScripted: export %@",
	 [bkmxDoc displayName]] ;
		
	// Get the parameters
	NSDictionary* evaluatedArguments = [self evaluatedArguments] ;
	NSNumber* deference = [evaluatedArguments objectForKey:@"deference"] ;
	if (!deference) {
		deference = [NSNumber numberWithInteger:BkmxDeferenceAsk] ;
	}
	NSNumber* ignoreLimit = [evaluatedArguments objectForKey:@"ignoreLimit"] ;  // defaults to nil
	
	[[BkmxBasis sharedBasis] setCurrentAppleScriptCommand:self] ;
	[[bkmxDoc operationQueue] setScriptCommand:self] ;
	
    Job* job = [Job new];
    job.serial = [[NSUserDefaults standardUserDefaults] nextJobSerialforCreator:@"AppleScript Perform Syncer"];
	NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								 [NSNumber numberWithInteger:BkmxPerformanceTypeScripted], constKeyPerformanceType,
								 [NSNumber numberWithBool:YES], constKeyIfNotNeeded,
								 deference, constKeyDeference,
                                 job, constKeyJob,
								 ignoreLimit, constKeyIgnoreLimit, // may be nil sentinel
								 nil] ;
    [job release];
	[bkmxDoc exportPerInfo:info] ;
	
	[self suspendExecution] ;
	// The corresponding invocation of -resumeExecutionWithResult: is
	// done in -[SSYOperationQueue observeValueForKeyPath:ofObject:change:context:],
	// when the number of operations == 0; i.e. when all operations are finished.
	// -[NSScriptCommand suspendExecution] is magic.  Although it
	// returns immediately, and this method returns a "result", this result is held
	// somewhere and the calling AppleScript is left hanging until
	// -resumeExecutionWithResult: executes.
	
	return nil ;
}
@end

@interface ImportOnlyCommand : BkmxThreadedScriptCommand
@end
@implementation ImportOnlyCommand
- (id)performDefaultImplementation {
	// Get the receiver/object of the command
	BkmxDoc* bkmxDoc = [self evaluatedReceivers] ;
	if (![bkmxDoc isKindOfClass:[BkmxDoc class]]) {
		[[BkmxBasis sharedBasis] logFormat:@"Rejected AppleScript : Bad Collection"] ;
		[self setScriptErrorNumber:19131] ;
		[self setScriptErrorString:[NSString stringWithFormat:@"Direct object of command 'one_time import' must be an open Collection"]] ;
		return nil ;
	}
	
	[[BkmxBasis sharedBasis] logFormat:
	 @"AppleScripted: one_time import %@",
	 [bkmxDoc displayName]] ;
	
	NSDictionary* evaluatedArguments = [self evaluatedArguments] ;

	NSString* exformat = [evaluatedArguments objectForKey:@"exformat"] ;
	if (!exformat) {
		[self setScriptErrorNumber:19132] ;
		[self setScriptErrorString:[NSString stringWithFormat:@"Command 'one_time import' requires parameter 'file format'"]] ;
		return nil ;
	}
	
	NSString* path = [evaluatedArguments objectForKey:@"path"] ;
	
	[[BkmxBasis sharedBasis] setCurrentAppleScriptCommand:self] ;
	[[bkmxDoc operationQueue] setScriptCommand:self] ;
    Job* job = [Job new];
    job.serial = [[NSUserDefaults standardUserDefaults] nextJobSerialforCreator:@"AppleScript Perform ImportOnly"];
	[bkmxDoc performForUserQuickIxportPolarity:(BkmxIxportPolarity)BkmxIxportPolarityImport
                                      exformat:exformat
                                          path:path
                                     extraInfo:@{constKeyJob: job}] ;
    [job release];
	
	[self suspendExecution] ;
	// The corresponding invocation of -resumeExecutionWithResult: is
	// done in -[SSYOperationQueue observeValueForKeyPath:ofObject:change:context:],
	// when the number of operations == 0; i.e. when all operations are finished.
	// -[NSScriptCommand suspendExecution] is magic.  Although it
	// returns immediately, and this method returns a "result", this result is held
	// somewhere and the calling AppleScript is left hanging until
	// -resumeExecutionWithResult: executes.
	
	return nil ;
}
@end

@interface ExportOnlyCommand : BkmxThreadedScriptCommand
@end
@implementation ExportOnlyCommand
- (id)performDefaultImplementation {
	// Get the receiver/object of the command
	BkmxDoc* bkmxDoc = [self evaluatedReceivers] ;
	if (![bkmxDoc isKindOfClass:[BkmxDoc class]]) {
		[[BkmxBasis sharedBasis] logFormat:@"Rejected AppleScript : Bad Collection"] ;
		[self setScriptErrorNumber:19141] ;
		[self setScriptErrorString:[NSString stringWithFormat:@"Direct object of command 'one_time export' must be an open Collection"]] ;
		return nil ;
	}
	
	[[BkmxBasis sharedBasis] logFormat:
	 @"AppleScripted: one_time export %@",
	 [bkmxDoc displayName]] ;
	
	NSDictionary* evaluatedArguments = [self evaluatedArguments] ;
	
	NSString* exformat = [evaluatedArguments objectForKey:@"exformat"] ;
	if (!exformat) {
		[self setScriptErrorNumber:19142] ;
		[self setScriptErrorString:[NSString stringWithFormat:@"Command 'one_time export' requires parameter 'file format'"]] ;
		return nil ;
	}
	
	NSString* path = [evaluatedArguments objectForKey:@"path"] ;
	
	[[BkmxBasis sharedBasis] setCurrentAppleScriptCommand:self] ;
	[[bkmxDoc operationQueue] setScriptCommand:self] ;
	
    Job* job = [Job new];
    job.serial = [[NSUserDefaults standardUserDefaults] nextJobSerialforCreator:@"AppleScript Perform ExportOnly"];
    [bkmxDoc performForUserQuickIxportPolarity:(BkmxIxportPolarity)BkmxIxportPolarityExport
                                      exformat:exformat
                                          path:path
                                     extraInfo:@{constKeyJob: job}];
    [job release];
	
	[self suspendExecution] ;
	// The corresponding invocation of -resumeExecutionWithResult: is
	// done in -[SSYOperationQueue observeValueForKeyPath:ofObject:change:context:],
	// when the number of operations == 0; i.e. when all operations are finished.
	// -[NSScriptCommand suspendExecution] is magic.  Although it
	// returns immediately, and this method returns a "result", this result is held
	// somewhere and the calling AppleScript is left hanging until
	// -resumeExecutionWithResult: executes.
	
	return nil ;
}
@end

@interface WriteSyncLogCommand : NSScriptCommand
@end
@implementation WriteSyncLogCommand
- (id)performDefaultImplementation {
	BkmxDoc* bkmxDoc = [self evaluatedReceivers] ;
	if (![bkmxDoc respondsToSelector:@selector(bkmxDocWinCon)]) {
		[self setScriptErrorNumber:19151] ;
		[self setScriptErrorString:[NSString stringWithFormat:@"Receiver must be a collection (.bmco file)"]] ;
		return nil ;
	}
	
	NSDictionary* evaluatedArguments = [self evaluatedArguments] ;
	NSString* path = [evaluatedArguments objectForKey:@"path"] ;
	NSNumber* backObject = [evaluatedArguments objectForKey:@"back"] ;
	NSInteger back = backObject ? [backObject integerValue] : 0 ;
	NSNumber* stampObject = [evaluatedArguments objectForKey:@"stamp"] ;
	BOOL doStamp = stampObject ? [stampObject boolValue] : YES ;
	
	NSError* error = nil ;
	path = [[bkmxDoc bkmxDocWinCon] writeLogToPath:path
                                              back:back
                                           doStamp:doStamp
                                           error_p:&error] ;
	if (!path) {
		[self setScriptErrorNumber:(int)[error code]] ;
		[self setScriptErrorString:[error localizedDescription]] ;
		NSLog(@"%@", [error longDescription]) ;
	}
		
	return path ;

	// NSNameSpecifier* nameSpecifier = [super performDefaultImplementation] ;
	// return nameSpecifier ;
}
@end

@interface MakeNewLocalClientCommand : NSScriptCommand
@end
@implementation MakeNewLocalClientCommand
- (id)performDefaultImplementation {
	BkmxDoc* bkmxDoc = [self evaluatedReceivers] ;
	if (![bkmxDoc respondsToSelector:@selector(makeNewLocalClientWithExformat:profileName:)]) {
		[self setScriptErrorNumber:19161] ;
		[self setScriptErrorString:[NSString stringWithFormat:@"Receiver must be a collection (.bmco file)"]] ;
		return nil ;
	}
	
	NSDictionary* evaluatedArguments = [self evaluatedArguments] ;
	NSString* exformat = [evaluatedArguments objectForKey:@"exformat"] ;
	if (!exformat) {
		[self setScriptErrorNumber:19162] ;
		[self setScriptErrorString:[NSString stringWithFormat:@"Command 'make new local client' requires parameter 'browser'"]] ;
		return nil ;
	}
	
	// Added in BookMacster 1.20.5
    NSString* profileName = [evaluatedArguments objectForKey:@"profileName"] ;
    if (!profileName) {
        Class extoreClass = [Extore extoreClassForExformat:exformat] ;
        profileName = [extoreClass defaultProfileName] ;
    }
    
	[bkmxDoc makeNewLocalClientWithExformat:exformat
                                profileName:profileName] ;
	
	NSNameSpecifier* nameSpecifier = [super performDefaultImplementation] ;
	return nameSpecifier ;
}
@end

@interface DeleteAllClientsCommand : NSScriptCommand
@end
@implementation DeleteAllClientsCommand
- (id)performDefaultImplementation {
	BkmxDoc* bkmxDoc = [self evaluatedReceivers] ;
	if (![bkmxDoc respondsToSelector:@selector(deleteAllClients)]) {
		[self setScriptErrorNumber:19171] ;
		[self setScriptErrorString:[NSString stringWithFormat:@"Receiver must be a collection (.bmco file)"]] ;
		return nil ;
	}
	
	[bkmxDoc deleteAllClients] ;
	
	NSNameSpecifier* nameSpecifier = [super performDefaultImplementation] ;
	return nameSpecifier ;
}
@end

@interface DeleteAllContentCommand : BkmxThreadedScriptCommand
@end
@implementation DeleteAllContentCommand
- (id)performDefaultImplementation {
	// Get the receiver/object of the command
	BkmxDoc* bkmxDoc = [self evaluatedReceivers] ;
	if (![bkmxDoc isKindOfClass:[BkmxDoc class]]) {
		[[BkmxBasis sharedBasis] logFormat:@"Rejected AppleScript : Bad Collection"] ;
		[self setScriptErrorNumber:19181] ;
		[self setScriptErrorString:[NSString stringWithFormat:@"Direct object of command 'delete all content' must be an open Collection"]] ;
		return nil ;
	}
	
	[[BkmxBasis sharedBasis] logFormat:
	 @"AppleScripted: delete all content"] ;
	
	[[BkmxBasis sharedBasis] setCurrentAppleScriptCommand:self] ;
	[[bkmxDoc operationQueue] setScriptCommand:self] ;
	
	[bkmxDoc deleteAllContent] ;
	
	[self suspendExecution] ;
	// The corresponding invocation of -resumeExecutionWithResult: is
	// done in -[SSYOperationQueue observeValueForKeyPath:ofObject:change:context:],
	// when the number of operations == 0; i.e. when all operations are finished.
	// -[NSScriptCommand suspendExecution] is magic.  Although it
	// returns immediately, and this method returns a "result", this result is held
	// somewhere and the calling AppleScript is left hanging until
	// -resumeExecutionWithResult: executes.
	
	return nil ;
}
@end

@interface UndoCommand : NSScriptCommand
@end
@implementation UndoCommand
- (id)performDefaultImplementation {
	BkmxDoc* bkmxDoc = [self evaluatedReceivers] ;
	if (![bkmxDoc respondsToSelector:@selector(undoManager)]) {
		[self setScriptErrorNumber:19191] ;
		[self setScriptErrorString:[NSString stringWithFormat:@"Receiver must be a collection (.bmco file)"]] ;
		return nil ;
	}
	
	[[bkmxDoc undoManager] undo] ;

	[self handleUndoManagerExceptionBkmxDoc:bkmxDoc] ;
	
	return nil ;
}
@end


@interface RedoCommand : NSScriptCommand
@end
@implementation RedoCommand
- (id)performDefaultImplementation {
	BkmxDoc* bkmxDoc = [self evaluatedReceivers] ;
	if (![bkmxDoc respondsToSelector:@selector(undoManager)]) {
		[self setScriptErrorNumber:19201] ;
		[self setScriptErrorString:[NSString stringWithFormat:@"Receiver must be a collection (.bmco file)"]] ;
		return nil ;
	}
	
	[[bkmxDoc undoManager] redo] ;
	
	[self handleUndoManagerExceptionBkmxDoc:bkmxDoc] ;
	
	return nil ;
}
@end
