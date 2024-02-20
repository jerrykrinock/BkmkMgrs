#import "Operation_Common.h"
#import "BkmxBasis+Strings.h"
#import "NSError+MyDomain.h"
#import "Extore.h"
#import "Client+SpecialOptions.h"
#import "NSInvocation+Quick.h"
#import "NSString+LocalizeSSY.h"
#import "NSError+InfoAccess.h"
#import "SSYProgressView.h"
#import "Ixporter.h"
#import "SSYDooDooUndoManager.h"
#import "AgentPerformer.h"
#import "NSInvocation+Nesting.h"
#import "SSYOperationQueue.h"
#import "Macster.h"
#import "NSDate+NiceFormats.h"
#import "Starxider.h"
#import "Chaker.h"
#import "Starker.h"
#import "Stange.h"
#import "NSObject+MoreDescriptions.h"
#import "ExportLog.h"
#import "Syncer.h"
#import "BkmxDoc.h"
#import "NSUserDefaults+Bkmx.h"
#import "StarkEditor.h"
#import "Stager.h"
#import "ExtensionsMule.h"
#import "NSArray+SafeGetters.h"
#import "BkmxDocWinCon.h"
#import "ExtoreWebFlat.h"
#import "Stark.h"
#import "NSUserDefaults+MainApp.h"
#import "NSArray+Stringing.h"
#import "SSYEventInfo.h"
#import "SSYMH.AppAnchors.h"
#import "Job.h"
#import "AgentPerformer.h"
#import "SSYDeallocDetector.h"
#import "Watcher.h"


NSString* const constKeyMule = @"mule" ;


@implementation SSYOperation (Operation_Common)

- (void)ensureFiles {
    [self doSafely:_cmd] ;
}

- (void)ensureFiles_unsafe {
    // May be unsafe because of accesses to -[Extore client]
    Extore* extore = [[self info] objectForKey:constKeyExtore] ;
    
    BkmxDoc* bkmxDoc = [self.info objectForKey:constKeyDocument];
    [[bkmxDoc progressView] setIndeterminate:YES
                           withLocalizedVerb:[NSString stringWithFormat:
                                              @"%@ (%@)",
                                              [NSString localizeFormat:@"syncPullingX", [NSString localize:@"000_Safari_Bookmarks"]],
                                              [[extore client] displayName]]
                                    priority:SSYProgressPriorityRegular] ;

    NSSet* suffixes = nil ;
    NSError* error = nil ;
    BOOL ok = [extore ensureFilesGetSuffixes_p:&suffixes
                                       error_p:&error] ;
    if ([suffixes count] > 0) {
        [[self info] setObject:suffixes
                        forKey:constKeySuffixesFileCopied] ;
    }
    
    if (!ok) {
        [self setError:error] ;

        Ixporter* ixporter = [[self info] objectForKey:constKeyIxporter] ;
        if ([ixporter isAnImporter]) {
            // See Note 520948…
            [self skipNoncleanupOperationsInOtherGroups] ;
        }
    }
}

- (void)checkClientAvailability {
#if 0
#warning Ignoring client availability
    return ;
#endif
    [self doSafely:_cmd] ;
}

- (void)checkClientAvailability_unsafe {
    Extore* extore = [[self info] objectForKey:constKeyExtore] ;
    if ([extore ownerAppIsLocalApp]) {
        Client* client = [extore client] ;
        if ([[client extoreMedia] isEqualToString:constBkmxExtoreMediaThisUser]) {
            Clientoid* clientoid = [client clientoid] ;
            BOOL clientIsTemporary = [client willSelfDestruct] ;
            NSArray* availableClientoids = [Clientoid allClientoidsForLocalAppsThisUserByPopularity:NO
                                                                               includeUninitialized:YES
                                                                               includeNonClientable:clientIsTemporary] ;
            if ([availableClientoids indexOfObject:clientoid] == NSNotFound) {
                NSString* whatNot ;
                switch ([[BkmxBasis sharedBasis] iAm]) {
                    case BkmxWhich1AppSmarky:
                    case BkmxWhich1AppSynkmark:
                    case BkmxWhich1AppMarkster:
                        whatNot = [[BkmxBasis sharedBasis] labelBookmarks] ;
                        break ;
                    case BkmxWhich1AppBookMacster:
                        whatNot = [[BkmxBasis sharedBasis] labelClient] ;
                }
                NSString* locDex = [NSString stringWithFormat:
                                    @"%@ %@",
                                    whatNot,
                                    [NSString localize:@"notAvailable"]] ;
                NSError* error = SSYMakeError(259284, locDex) ;
                NSString* target = [client displayName] ;
                NSString* suggestion = [NSString stringWithFormat:
                                        @"Either restore bookmarks to %@, or delete %@ from the list of %@",
                                        target,
                                        target,
                                        [[BkmxBasis sharedBasis] labelClients]] ;
                error = [error errorByAddingLocalizedRecoverySuggestion:suggestion] ;
                [self setError:error] ;
            }
        }
    }
}

- (void)getImporter {
    Ixporter* ixporter = [[self info] objectForKey:constKeyIxporter] ;
    Importer* importer = [[ixporter client] importer] ;
    if (importer) {
        [[self info] setObject:importer
                        forKey:constKeyImporter] ;
    }
}

// This method was added in BookMacster 1.19.7
- (void)waitForClientProfile {
    BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument] ;
    [bkmxDoc blockWaitingForClientProfile] ;
    
    // Will block here until lock condition is SSY_OPERATION_CLEARED
    
    /*
     The following section was written for the of catching the user-cancelled
     error which occurs in the edge case when user did a File >
     or (Im|Ex)port to only > Google Bookmarks (New/Other), and later
     clicks "Cancel" button when asked for the account name.  We want to head
     off any other errors, the next one of which would occur in
     -renewExtore_unsafe when it was found that the client had been abandoned
     and thus no ixporter.
     
     I filter for only this particular error in order to avoid introducing
     other bugs.  I remember one of the reasons why we have the -renewExtore
     method is to clear (and ignore) other errors.
     */
    [self performSelectorOnMainThread:@selector(getImporter)
                           withObject:nil
                        waitUntilDone:YES] ;
    Importer* importer = [[self info] objectForKey:constKeyImporter] ;
    /* That was tricky.  The importer is the guy that has the extore that
     has the user-cancelled error that we want.  In the case of a cancelled
     "Import from only" operation, the importer == ixporter.  But in the case
     of an "Export to only" operation, we need to drill up into the client
     and then back down to get the exporter's sibling importer.  Also, notice
     that we did it on the main thread to avoid a Core Data multi-threading
     assertion. */
    NSError* error = [[importer extore] error] ;
    if (
        [[error domain] isEqualToString:BkmxExtoreWebFlatErrorDomain]
        &&
        ([error code] == constNonhierarchicalWebAppErrorCodeUserCancelled)
        ) {
        [self setAllGroupsError:error] ;
        /* The above will cause subsequent operations to no-op.  The *AllGroups*
         variation is used because, while the current operation group is
         Import-Grande, we need operations in the client-specific import
         operation groups, named in the form ImportXX(Y), to be no-opped too. */
    }
}

- (void)prepareInfoForReading {
    [[self info] setObject:[NSNumber numberWithInteger:BkmxClientTaskRead]
                    forKey:constKeyClientTask] ;
}

- (void)prepareInfoForWriting {
    [[self info] setObject:[NSNumber numberWithInteger:BkmxClientTaskWrite]
                    forKey:constKeyClientTask] ;
}

- (void)skipNoncleanupOperationsInOtherGroups {
    NSString* saveGroupName = NSStringFromSelector(@selector(saveDocumentInfo:));
    /* Saving doesn't really help in most cases of changes imported from
     one client being overwritten by a subsequent import from a different
     client, because by default an import overwrites everything that it *can*.
     (For example of a *can't*, Chrome can't overwrite separators).  That
     problem is solved by staging a sync redo and properly importing from both
     clients instead of just the one on the subsequent import.  However, maybe
     there are some edge cases where it does help (sending via Dropbox to
     another Mac?), and it seems like bad programming practice to throw the
     new data away.  So I include -saveDocumentInfo: in aborted jobs anyhow. */
    NSSet* goodGroups = [NSSet setWithObjects:
                         [[self info] objectForKey:constKeySSYOperationGroup], // The current group
                         constGroupNameAgentPerformEnd,  // The last group
                         saveGroupName,
                         nil] ;
    [[self operationQueue] setSkipOperationsExceptGroups:goodGroups] ;
}

- (void)getIxportStyle {
    // We may need to access the managed property [[extore client] extoreMedia],
    // so we must divert to the main thread as usual…
    [self doSafely:_cmd] ;
}

- (void)getIxportStyle_unsafe {
    Extore* extore = [[self info] objectForKey:constKeyExtore] ;

    if ([self.info objectForKey:constKeyForceStyle1Client] == extore.client) {
        [[BkmxBasis sharedBasis] logFormat:@"Enforcing style 1 for %@", [extore.client displayName]];
        [extore setIxportStyle:1];
    }
    else {
        BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument] ;
        [[bkmxDoc progressView] setIndeterminate:YES
                               withLocalizedVerb:[NSString stringWithFormat:
                                                  @"Getting appropriate styles from %@",
                                                  [extore ownerAppDisplayName]]
                                        priority:SSYProgressPriorityRegular] ;

        NSError* error = nil ;
        [extore determineYourIxportStyleError_p:&error];
        if (error) {
            [self setError:error] ;
        }
    }
}

- (void)launchBrowserIfNeeded {
    [self doSafely:_cmd];
}

- (void)launchBrowserIfNeeded_unsafe {
    Extore* extore = [[self info] objectForKey:constKeyExtore];
    NSError* error = nil;
    BOOL ok = [extore launchOwnerAppIfNecessaryForPolarity:BkmxIxportPolarityImport
                                                      info:[self info]
                                                   error_p:&error];
    if (!ok) {
        [self setError:error] ;
    }
}

- (void)beginUndoGrouping {
    // We're not doing any Core Data-base access, but NSUndoManager is not
    // thread safe either.
    [self doSafely:_cmd] ;

    [[self info] setObject:[NSNumber numberWithBool:YES]
                    forKey:constKeyDidBeginUndoGrouping] ;
}

- (void)beginUndoGrouping_unsafe {
    BkmxDoc* bkmxDoc = [self.info objectForKey:constKeyDocument];
    [(SSYDooDooUndoManager*)[bkmxDoc undoManager] beginManualUndoGrouping] ;
}


/*!
 @brief    Sets the undo action in the bkmxDoc's undo manager.

 @details  This method should be invoked after any other operation which
 might set an undo action might be invoked.&nbsp;  It wraps an _unsafe
 version because NSUndoManager is not thread-safe.
*/
- (void)setUndoActionName {
    NSString* actionName = [[self info] objectForKey:constKeyActionName] ;
    // In BkmxAgent, actionName will be nil.  Actually, this method should not
    // be queued and therefore not invoked in BkmxAgent, so the following if()
    // is defensive programming.  But probably a good idea.
    if (actionName) {
        [self doSafely:_cmd] ;
    }
}

- (void)setUndoActionName_unsafe {
    NSString* actionName = [[self info] objectForKey:constKeyActionName] ;
    //*** Commented out in BookMacster verison 1.3.5 since I don't see what this has to do with newExidsCount.
    //*** NSInteger newExidsCount = [[[self info] objectForKey:constKeyNewExidsCount] integerValue] ;
    //*** if (newExidsCount > 0) {
    //***     // The operation just completed was an export -- 20101124: Huh???
    //***     // actionName should be -[BkmxBasis(Strings) labelNewIdentifiers]
    //***     actionName = [NSString stringWithFormat:
    //***                   @"%@ (%d)",
    //***                   actionName,
    //***                   newExidsCount] ;
    //*** }
    BkmxDoc* bkmxDoc = [self.info objectForKey:constKeyDocument];
    [(SSYDooDooUndoManager*)[bkmxDoc undoManager] setActionName:actionName] ;
}

- (void)beginDebugTrace {
    NSInteger traceLevel;
    if ([SSYEventInfo alternateKeyDown] && [SSYEventInfo shiftKeyDown]) {
        traceLevel = 5;
    } else {
        traceLevel = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppIntegerForKey:constKeyDebugTraceVerbosity];
    }
    [[BkmxBasis sharedBasis] setTraceLevel:traceLevel];
    /* This is the only place where we set traceLevel.  Since this method runs
     before ixport, there is no need to reset it to zero at the end of the
     ixport. */

    if ([[BkmxBasis sharedBasis] traceLevel] > 0) {
        /* Getting displayName of ixporter accesses client, which is a Core
         Data relationship.  So we must do this safely… */
        [self doSafely:_cmd] ;
    }
}

- (void)beginDebugTrace_unsafe {
    Ixporter* ixporter = [[self info] objectForKey:constKeyIxporter] ;
    NSString* verb;
    NSString* direction;
    NSString* subjectName;
    if ([ixporter isAnImporter]) {
        verb = @"Import from";
        direction = @"to";

        NSArray* importersToDo = [[self info] objectForKey:constKeyDoOnlyImportersArray];
        if (importersToDo) {
            subjectName = [importersToDo listValuesForKey:@"displayName"];
        } else {
            subjectName = @"all";
        }

    } else {
        verb = @"Export to";
        direction = @"from";
        subjectName = [ixporter displayName];
    }

    BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument] ;
    NSString* header = [NSString stringWithFormat:
                        @"%@ %@\n"
                        @"%@:\n"
                        @"   %@\n"
                        @"   %@\n"
                        @"   %@\n\n",
                        verb,
                        subjectName,
                        direction,
                        [bkmxDoc displayNameShort],
                        [bkmxDoc uuid],
                        [[bkmxDoc fileURL] path]] ;
    [[BkmxBasis sharedBasis] beginDebugTraceWithHeader:header] ;
}

- (void)checkBreath {
    NSError* error = nil ;
    BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument] ;

    BOOL ok = [bkmxDoc checkBreathError_p:&error] ;
    if (!ok) {
        [self setError:error] ;
    }    
}

- (void)renewExtore {
    [self doSafely:_cmd] ;
}

- (void)renewExtore_unsafe {
    Ixporter* ixporter = [[self info] objectForKey:constKeyIxporter] ;
    if (!ixporter) {
        NSError* error = SSYMakeError(458501, @"No ixporter in info") ;
        error = [error errorByAddingUserInfoObject:[self info]
                                            forKey:@"Bad info"] ;
        [self setError:error] ;
        return ;
    }
    
    NSError* error = nil  ;
    Extore* extore = [ixporter renewExtoreForJobSerial:((Job*)[[self info] objectForKey:constKeyJob]).serial
                                               error_p:&error] ;
    
    if (extore) {
        [[self info] setObject:extore
                        forKey:constKeyExtore] ;
#if 0
#warning Testing leak of Operation's info
        /* Note that the "armed" and "deallocced" messages are logged to app's
         Logs, not any console. */
        {
            NSString* msg = [NSString stringWithFormat:@"info %p deallocced %@ %@ %p", self.info, [[self info] objectForKey:constKeySSYOperationGroup], extore.displayName, extore] ;
            NSInvocation* invocation = [NSInvocation invocationWithTarget:[BkmxBasis sharedBasis]
                                                                 selector:@selector(logFormat:)
                                                          retainArguments:YES
                                                        argumentAddresses:&msg] ;
            SSYDeallocDetector* deallocDetector = [SSYDeallocDetector detectorWithInvocation:invocation
                                                                                      logMsg:nil] ;
            [self.info setObject:deallocDetector
                          forKey:@"Info Leak Detector"] ;
            msg = [NSString stringWithFormat:@"info %p armed %@ %@ %p", self.info, [[self info] objectForKey:constKeySSYOperationGroup], extore.displayName, extore];
            [[BkmxBasis sharedBasis] logFormat:msg];
        }
#endif

    }
    else {
        error = [SSYMakeError(19675, @"Could not renew store") errorByAddingUnderlyingError:error] ;
        error = [error errorByAddingUserInfoObject:[[self info] objectForKey:constKeyIxporter]
                                            forKey:@"Ixporter"] ;
        [self setError:error] ;
    }
}

- (void)askQuitIsDone {
    [self unlockLock] ;
}

- (void)readExternal {
    [self prepareLock] ;
    [self doSafely:_cmd] ;
    [self blockForLock] ;
}

- (void)readExternal_unsafe {
    [self lockLock] ;

    Extore* extore = [[self info] objectForKey:constKeyExtore] ;

    Ixporter* ixporter = [[self info] objectForKey:constKeyIxporter] ;
    if ([[self info] objectForKey:constKeySkipImportNoChanges]) {
        [[BkmxBasis sharedBasis] logFormat:@"%@ unchanged since last import \u279E Skip Reading", [[ixporter client] displayName]] ;
        [self readExternalIsDone] ;
        return ;
    }
    
    // Note 954938
    
    // Due to the vagaries of Core Data, the Extore may not be deallocced
    // when it goes out of scope.  If that happens, it and its starker may be
    // re-used for subsequent exports.  So, In case we're re-using
    // an old starker, we first empty it out.
    // (I may have fixed Extore re-use by releasing it in -[Client didTurnIntoFault], but I'm not sure.)
    [extore clearTransMoc];
    
    // Read data from external store into its emptied starker.

    [self setError:nil] ;
    
    BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument] ;
    [[bkmxDoc progressView] setIndeterminate:YES
                           withLocalizedVerb:[NSString localizeFormat:
                                              @"fileReadingX",
                                              [[extore client] displayName]]
                                    priority:SSYProgressPriorityRegular] ;
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]];

    /* Use __weak per Apple Documentation >
     Programming With Objective-C >
     Working with Blocks >
     Avoid Strong Reference Cycles when Capturing self */
    SSYOperation* __weak weakSelf = self;

    // Declare a block named `completionHandler` and assign a one-liner to it.
    void (^completionHandler)(void) = ^void(void) {
        [weakSelf readExternalIsDone];
    };

    BkmxIxportPolarity polarity = [ixporter isAnImporter] ? BkmxIxportPolarityImport : BkmxIxportPolarityExport;

    [extore readExternalUsingCurrentStyleWithPolarity:polarity
                                            jobSerial:((Job*)[[self info] objectForKey:constKeyJob]).serial
                                    completionHandler:completionHandler];
}

- (void)readExternalIsDone {
    Extore* extore = [[self info] objectForKey:constKeyExtore] ;
    Client* client = [extore client] ;
    BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument] ;
    
    NSError* error = [extore error] ;
    if (error) {
        [self setError:error] ;
        Ixporter* ixporter = [[self info] objectForKey:constKeyIxporter] ;
        if ([ixporter isAnImporter]) {
            /*
             Note 520948.
             Now we come to the question of whether or not, in a multi-Client
             import, we should abort the remaining Client imports given
             that this Client import has failed.  Although I think this
             did not happen in earlier versions, in BookMacster 1.6.7 I note
             that other such Client imports are *not* aborted.  Because of the way
             that I've written -[Ixporter mergeFromStartainer::::] and -[Ixporter gulpStartainer::::],
             to set things up if the Client isBeginningProduct, and to
             clean up if the Client isEndingProduct, this means that many
             important things will not get done if this failed import
             happens to be the first or last in the list!  I looked for a
             few minutes at factoring out the first-client setup and
             last-client cleanup code from -[Ixporter mergeFromStartainer:toStartainer:info:error_p:],
             but the isBeginningProduct and isEndingProduct code is branched
             in multiple times, and so this would be a real mess.
             CORRECTION: Did isEndingProduct mess 20111213
             Another 
             alternative, which would work for isBeginningProduct, is to
             switch isBeginningProduct on at the beginning, and then switch it off after
             the first successful Client is merged.  That would actually be
             simpler than what I'm doing now.  But this would not work for isEndingProduct,
             at least until someone invents an easy way to go back in time and re-run
             code with different parameters!  (If Import Clients are A, B and
             C, and C fails, you'd need to go back in time and re-run B with
             isEndingProduct set to YES.)  Finally, I considered whether the
             user would really want a partial import, and concluded that the
             answer is NO.  Particularly if Import's "Delete Unmatched Items"
             is checked ON, which it is be default, skipping an import Client 
             could cause items expected from that import to be deleted.
             It seems that, in most cases, things might get put out of order, causing
             a massive churn, and another massive re-churn back to normal the
             next time that the import is run successfully with all Clients.
             
             Therefore, in BookMacster 1.7/1.6.8, I added the following statement: */
            [self skipNoncleanupOperationsInOtherGroups];

            /* Since we have aborted, if we are in BkmxAgent, we need to
             schedule a redo. */
            Job* job = ((Job*)[self.info objectForKey:constKeyJob]);
            if (job) {
                /* We must be in BkmxAgent, because if we are in main app,
                 job will be nil. */
                job.reason = AgentReasonStageRedo;
                [Stager stageJob:job
                           phase:@"ImportErr"];
            }
        }
    }
    
    // We still need to do this, even if we're reading in to do a 
    // comparison for export.  Otherwise, the import will not match
    // the export and churn will occur.
    if ([client doSpecialMapping]) {
        [extore doSpecialMappingAfterImport] ;
    }
    
    [[bkmxDoc progressView] clearAll] ;
    
    if (![[[self info] objectForKey:constKeySkipImportNoChanges] boolValue]) {
        // This was moved from Note 954938 in BookMacster 1.11.2, because
        // when it was there, it did not check for error, and also it executed
        // even if this method did not execute, because no import was done,
        // because a browser extension was found needing to be installed first.
        if (![self error]) {
            [[self info] setObject:[NSNumber numberWithBool:YES]
                            forKey:constKeyDidReadExternal] ;
        }
    }

    [self unlockLock] ;
}

- (void)recordHartainersRead {
    [self doSafely:_cmd] ;
}

- (void)recordHartainersRead_unsafe {
    NSSet* hartainers = [self hartainerSharypesInExtore];
    [[self info] setObject:hartainers
                    forKey:constKeyHartainerSharypesRead];
}

- (void)recordHartainersRemoved {
    [self doSafely:_cmd] ;
}

- (void)recordHartainersRemoved_unsafe {
    NSSet* hartainerSharypesRead = [[self info] objectForKey:constKeyHartainerSharypesRead];
    NSSet* hartainerSharypesWritten = [self hartainerSharypesInExtore];
    NSMutableSet* hartainerSharypesRemoved = [NSMutableSet new];
 
    if (![hartainerSharypesRead isEqualToSet:hartainerSharypesWritten]) {
        // Seems like there should be a NSSet method to do this, but there is not…
        for (NSNumber* hartainerNumber in hartainerSharypesRead) {
            if (![hartainerSharypesWritten member:hartainerNumber]) {
                [hartainerSharypesRemoved addObject:hartainerNumber];
            }
        }
    }
    
    if (hartainerSharypesRemoved.count > 0) {
        NSSet* answer = [hartainerSharypesRemoved copy];
        [[self info] setObject:answer
                        forKey:constKeyHartainerSharypesRemoved];
        [[self info] setObject:@(YES)
                        forKey:constKeyIgnoreLimit];
        [answer release];
    }
    
    [hartainerSharypesRemoved release];
}

- (NSSet*)hartainerSharypesInExtore {
    NSMutableSet* hartainerSharypes = [NSMutableSet new];
    Extore* extore = [[self info] objectForKey:constKeyExtore];
    if ([[extore starker] bar] != nil) {
        [hartainerSharypes addObject:@(SharypeBar)];
    }
    if ([[extore starker] menu] != nil) {
        [hartainerSharypes addObject:@(SharypeMenu)];
    }
    if ([[extore starker] unfiled] != nil) {
        [hartainerSharypes addObject:@(SharypeUnfiled)];
    }
    if ([[extore starker] ohared] != nil) {
        [hartainerSharypes addObject:@(SharypeOhared)];
    }
    
    NSSet* answer = [hartainerSharypes copy];
    [hartainerSharypes release];
    [answer autorelease];
    
    return answer;
}

- (void)updateCaches {
    [self doSafely:_cmd] ;
}

// Maybe this could be done on a non-main thread, but I don't want to investigate now.    
- (void)updateCaches_unsafe {
    BkmxDoc* bkmxDoc = [self.info objectForKey:constKeyDocument];
    SSYModelChangeCounts changeCounts = [[bkmxDoc chaker] changeCounts] ;
    if (changeCounts.added + changeCounts.deleted > 0) {
        [[bkmxDoc starker] clearCaches] ;

        // Actually, I'm not sure if it's even necessary any more.  It's a left-over
        // line of code from Bookdog.
        [bkmxDoc clearBroker] ;
    }
}


- (void)syncLog {
    [self doSafely:_cmd] ;
}

- (void)syncLog_unsafe {
    BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument] ;
    Ixporter* ixporter = [[self info] objectForKey:constKeyIxporter] ;
    
    // For an importer, this method will only run in the grand summary operation group.
    // For an exporter, this method will at the end of export for each Client.
    
    NSArray* importers = nil;
    Ixporter* exporter = nil;
    if ([ixporter isAnImporter]) {
        importers = [[self info] objectForKey:constKeyDoOnlyImportersArray] ;
    } else {
        exporter = ixporter;
    }

    IxportLog* ixportLog = [[bkmxDoc chaker] endForImporters:importers
                                                    exporter:exporter
                                                   isTestRun:[[self info] objectForKey:constKeyIsTestRun]] ;
    
    // Stash this into 'info' in case an error occurs during
    // the actual export, packing, or pushing of the changes,
    // so that we can roll it back (delete it)
    [[self info] setValue:ixportLog   // ixportLog may be nil
                   forKey:constKeyIxportLog] ;
}

- (void)actuallyDelete {
    [self doSafely:_cmd] ;
}

- (void)actuallyDelete_unsafe {
    BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument] ;
    Chaker* chaker = [bkmxDoc chaker] ;
    NSDictionary* stanges = [chaker stanges] ;
    NSMutableSet* doomedStarks = [[NSMutableSet alloc] init] ;
    for (NSString* starkid in stanges) {
        Stange* stange = [stanges objectForKey:starkid] ;
        SSYModelChangeAction changeType = [stange changeType] ;
        if ((changeType == SSYModelChangeActionRemove) || (changeType == SSYModelChangeActionCancel)) {
            Stark* stark = [stange stark] ;
            [doomedStarks addObject:stark] ;
        }
    }
    
    [StarkEditor removeStarks:doomedStarks
                       bkmxDoc:bkmxDoc] ;
    [doomedStarks release] ;
}

+ (void)tickleRunLoop {
    // No op
}

- (void)beginWork {
    [[BkmxBasis sharedBasis] forJobSerial:((Job*)[self.info objectForKey:constKeyJob]).serial
                                logFormat:
     @"Beginning work with %@ operations",
     @(self.operationQueue.operations.count)];
    BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument] ;
    BkmxPerformanceType performanceType = (BkmxPerformanceType)[[[self info] objectForKey:constKeyPerformanceType] integerValue] ;
    [bkmxDoc setCurrentPerformanceType:performanceType] ;
}

- (void)claimBaton {
    if ([[BkmxBasis sharedBasis] isBkmxAgent]) {
        BOOL skip = [[[self info] objectForKey:constKeySkipImportNoChanges] boolValue];
        if (!skip) {
            NSString* clidentifier = ((Ixporter*)[[self info] objectForKey:constKeyIxporter]).client.clientoid.clidentifier;
            NSInteger jobSerial = ((Job*)[self.info objectForKey:constKeyJob]).serial;
            [[BkmxBasis sharedBasis] forJobSerial:jobSerial
                                       logString:@"Will claim baton"];
            [[Watcher sharedWatcher] claimIxportBatonForClidentifier:clidentifier
                                                           jobSerial:jobSerial
                                                             canWait:YES];
            [[BkmxBasis sharedBasis] forJobSerial:jobSerial
                                       logString:@"Did claim baton"];

            [[self info] setObject:@YES
                            forKey:constKeyDidClaimBaton];
        }
    }
}

+ (void)terminateWorkInfo:(NSDictionary*)info {
    BkmxDoc* bkmxDoc = [info objectForKey:constKeyDocument];

    if ([[BkmxBasis sharedBasis] isBkmxAgent]) {
        [[AgentPerformer sharedPerformer] finishJob:((Job*)[info objectForKey:constKeyJob])
                                            bkmxDoc:bkmxDoc];
    } else {
        /* In case performance type was AppleScript, change it back to User. */
	    [bkmxDoc setCurrentPerformanceType:BkmxPerformanceTypeUser];
    }
}

#define COUNT_OF_OBJ_C_BUILTIN_ARGUMENTS_SELF_AND_SEL 2

+ (NSMutableDictionary*)infoInInvocation:(NSInvocation*)invocation {
    NSMutableDictionary* info = nil ;
    NSString* selectorString = NSStringFromSelector([invocation selector]) ;
    // selectorString is typically:
    //       "queueGroup:selectorNames:addon:info:block:doneThread:doneTarget:doneSelector:keepWithNext:"
    NSArray* argumentNames = [selectorString componentsSeparatedByString:@":"] ;
    NSInteger indexOfInfoArg = [argumentNames indexOfObject:@"info"] ;
    // indexOfInfoArg is typically = 1
    if (indexOfInfoArg == NSNotFound) {
        NSLog(@"Internal Error 235-6850 : %@", selectorString) ;
        return nil ;
    }
    [invocation getArgument:&info
                    atIndex:(indexOfInfoArg + COUNT_OF_OBJ_C_BUILTIN_ARGUMENTS_SELF_AND_SEL)] ;
    // More defensive programming...
    if (![info isKindOfClass:[NSMutableDictionary class]]) {
        NSLog(@"Internal Error 547-2015 : %@", info) ;
        return nil ;
    }

    if (!info) {
        NSLog(@"Internal Error 647-0079 : %@", [invocation longDescription]) ;
    }
    
    // OK, it's probably safe.  (Sorry, no way to check mutability.)
    return info ;
}

+ (void)inInfoOfInvocation:(NSInvocation*)invocation
                 setObject:(id)object
                    forKey:(NSString*)key {
    if (!object) {
        return ;
    }
    
    // Some defensive programming:
    if ([[invocation methodSignature] numberOfArguments] < 3) {
        NSLog(@"Internal Error 501-6547") ;
        return ;
    }
    // It will be safe to get argument at index 2
    
    NSArray* queueOperationsInvocs ;
    if ([invocation hasEggs]) {
        [invocation getArgument:&queueOperationsInvocs
                        atIndex:2] ;  // Index 2 is the first "real" argument
    }
    else {
        queueOperationsInvocs = [NSArray arrayWithObject:invocation] ;
    }

    for (NSInvocation* queueOperationsInvoc in queueOperationsInvocs) {
        NSMutableDictionary* info = [self infoInInvocation:queueOperationsInvoc] ;

        [info setObject:object
                 forKey:key] ;
    }
}

+ (void)modifyInvocation:(NSInvocation*)invocation
            newDeference:(BkmxDeference)newDeference 
          setIgnoreLimit:(BOOL)setIgnoreLimit {
    // Some defensive programming:
    if ([[invocation methodSignature] numberOfArguments] < 3) {
        NSLog(@"Internal Error 235-1948") ;
        return ;
    }
    // It will be safe to get argument at index 2
    
    NSArray* queueOperationsInvocs ;
    if ([invocation hasEggs]) {
        [invocation getArgument:&queueOperationsInvocs
                        atIndex:2] ;  // Index 2 is the first "real" argument
    }
    else {
        queueOperationsInvocs = [NSArray arrayWithObject:invocation] ;
    }
    for (NSInvocation* queueOperationsInvoc in queueOperationsInvocs) {
        NSMutableDictionary* info = [self infoInInvocation:queueOperationsInvoc] ;
        
        if (newDeference != BkmxDeferenceUndefined) {
            [info setObject:[NSNumber numberWithInteger:newDeference]
                     forKey:constKeyDeference] ;
        }

        if (setIgnoreLimit) {
            [info setObject:[NSNumber numberWithBool:YES]
                     forKey:constKeyIgnoreLimit] ;
        }
    }
}

- (void)timestampImported {
    [self doSafely:_cmd] ;
}

- (void)timestampImported_unsafe {
    BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument] ;
    Ixporter* ixporter = [[self info] objectForKey:constKeyIxporter] ;
    [bkmxDoc setAsNowLastImportedDateForClient:[ixporter client]] ;
}

- (void)removeNeedsImportFlag {
    /* This operation is run at the end of both imports and exports.  Regarding
     the latter, although data may have been unexpectedly overwritten, the
     fact is that if we exported, there is no longer any data that needs
     importing! */
    // This operation is skipped if we're doing a test run (SDTR)
    if ([[[self info] objectForKey:constKeyIsTestRun] boolValue] == YES) {
        return ;
    }

    [self doSafely:_cmd] ;
}

- (void)removeNeedsImportFlag_unsafe {
    BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument];
    Extore* extore = [[self info] objectForKey:constKeyExtore];
    Client* client = [extore client];

    NSString* reason = nil;
    Ixporter* ixporter = [[self info] objectForKey:constKeyIxporter] ;
    if ([ixporter isAnImporter]) {
        // This was an import
        reason = @"Import";
    } else if ([[[self info] objectForKey:constKeyClientShouldSelfDestruct] boolValue] == NO) {
        // This was an export to a permanent client
        reason = @"Export";
    }

    if (reason) {
        BOOL didClearSomething = [Stager clearNeedsImportClient:client
                                                 toDocumentUuid:[bkmxDoc uuid]];
        if (didClearSomething) {
            [[BkmxBasis sharedBasis] logFormat:
             @"%@ \u279e Unflagged that %@ Needs Import",
             reason,
             [client displayName]];

            NSMutableSet* unflaggedImportClients = [[self info] objectForKey:constKeyUnflaggedImportClients];
            /* unflaggedImportClients will be nil during manual import/exports
             by main app, but will be an empty set during Agent operations.
             It is set in -performOverrideDeference:::::.  Due to didClearSomething,
             this code will normally not execute during manual import/export.
             But it might if Agent crashed. */
            [unflaggedImportClients addObject:client];
        }
    }
}

- (void)saveExidsMoc {
    // This operation is skipped if we're doing a test run (SDTR)
    if ([[[self info] objectForKey:constKeyIsTestRun] boolValue] == YES) {
        return ;
    }
    
    [self doSafely:_cmd] ;
}

- (void)saveExidsMoc_unsafe {
    NSError* error = nil ;
    BkmxDoc* bkmxDoc = [self.info objectForKey:constKeyDocument];
    SSYProgressView* progressView = [[bkmxDoc progressView] setIndeterminate:YES
                                                           withLocalizedVerb:[NSString localizeFormat:
                                                                              @"savingX",
                                                                              [NSString localize:@"identifiers"]]
                                                                    priority:SSYProgressPriorityRegular] ;
    BOOL ok = [(Starxider*)[bkmxDoc starxider] save:&error] ;
    [progressView clearAll] ;
    
    if (!ok) {
        [self setError:error] ;
    }
}

- (void)errorizeIxportLog {
    [self doSafely:_cmd] ;
}

- (void)errorizeIxportLog_unsafe {
    NSInteger errorCode = [[self error] code] ;
    if (errorCode != constBkmxErrorNone) {
        IxportLog* ixportLog = [[self info] objectForKey:constKeyIxportLog] ;
        if (ixportLog) {
            [ixportLog setStarkoids:nil] ;
            [ixportLog setDisplayStatistics:nil] ;
            [ixportLog setErrorCode:[NSNumber numberWithLong:errorCode]] ;
            BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument] ;
            // The following can take a second or more
            [[BkmxBasis sharedBasis] saveDiariesMocForIdentifier:bkmxDoc.uuid] ;
        }
    }
}

- (void)uninhibit {
    [self doSafely:_cmd] ;
    // Is there a superstition that NSUserDefaults must be accessed on the main thread?
}

- (void)uninhibit_unsafe {
    NSDictionary* info = [self info] ;
    NSNumber* uninhibitSeconds = [info objectForKey:constKeyUninhibitSecondsAfterDone] ;
    if (uninhibitSeconds) {
        NSDate* uninhibitDate = [NSDate dateWithTimeIntervalSinceNow:[uninhibitSeconds doubleValue]] ;
        [[BkmxBasis sharedBasis] logFormat:@"Moved General Uninhibit back to %@", [uninhibitDate geekDateTimeString]] ;
        [[NSUserDefaults standardUserDefaults] setGeneralUninhibitDate:uninhibitDate] ;
        // And since this will be soon read by BkmxAgent,
        [[NSUserDefaults standardUserDefaults] synchronize] ;
    }
}

- (void)checkAndReportExtension1Status {
    if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
        [self doSafely:_cmd];
    }
}

- (void)checkAndReportExtension1Status_unsafe {
    BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument] ;
    [bkmxDoc checkAndReportExtension1Status] ;
}

- (void)reallyAutosave {
    [self doSafely:_cmd] ;
}

- (void)reallyAutosave_unsafe {
    NSDictionary* info = [self info] ;
    BkmxDoc* bkmxDoc = [info objectForKey:constKeyDocument] ;
    
    void (^completionHandler)(NSError*) = [info objectForKey:constKeyCompletionHandler] ;
    
    [bkmxDoc reallyAutosaveWithCompletionHandler:completionHandler] ;
    // Note: completionHandler will be released by the receiver of the above message.
}    

- (void)cleanUpServer {
    [self doSafely:_cmd] ;
}

- (void)cleanUpServer_unsafe {
    Ixporter* ixporter = [[self info] objectForKey:constKeyIxporter];

    /* The following apparently breaks a retain cycle.  Without it, the
     extore does not dealloc, and the interapp .FromClient server remains
     open on the system, whic prevents Workers from opening their own
     .FromClient ports when needed to sync, until BookMacster is totally
     quit. */
    [[ixporter extore] unleaseInterappServer];
}

- (void)blindAllBrowserQuitTriggers {
}

- (void)warnSyncSuspended {
    [self doSafely:_cmd] ;
}

- (void)warnSyncSuspended_unsafe {
    NSDictionary* info = [self info];
    BkmxDoc* bkmxDoc = [info objectForKey:constKeyDocument];
    SSYAlert* alert = [SSYAlert new];
    NSString* format = NSLocalizedString(
                                      @"To avoid conflicts with your editing of this Collection, automatic Syncing with %@ is suspended until you finish and %@.\n\n"
                                      @"If, during the past few minutes, you have made bookmarks changes in %@ which have not been imported yet, you should %@ > %@ those changes now.",
                                         nil);
    NSString* untilWhat;
    if ([[BkmxBasis sharedBasis] isShoeboxApp]) {
        untilWhat = [NSString localizeFormat:
                     @"quitApp%@",
                     [[BkmxBasis sharedBasis] appNameLocalized]];
    } else {
        untilWhat = NSLocalizedString(@"close this window", nil);
    }
    
    NSString* msg = [NSString stringWithFormat:
                     format,
                     [[BkmxBasis sharedBasis] labelClients],
                     untilWhat,
                     [[BkmxBasis sharedBasis] labelClients],
                     NSLocalizedString(@"File", nil),
                     [[BkmxBasis sharedBasis] labelImport]
                     ];
    [alert setSmallText:msg];
    [alert setHelpAddress:constHelpAnchorLeaveRunning] ;
    [alert setCheckboxTitle:[NSString localize:@"dontShowAdvisoryAgain"]] ;
    [bkmxDoc runModalSheetAlert:alert
                     resizeable:NO
                      iconStyle:SSYAlertIconInformational
              completionHandler:^(NSModalResponse modalResponse) {
                  NSInteger checkboxState = [alert checkboxState] ;
                  if (checkboxState == NSControlStateValueOn) {
                      [[NSUserDefaults standardUserDefaults] setBool:YES
                                                              forKey:constKeyDontWarnSyncingSuspended];
                      [alert release];
                  }
              }];
}

- (void)rollUnexportedDeletions {
    [self doSafely:_cmd] ;
}

- (void)rollUnexportedDeletions_unsafe {
    BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument];
    Macster* macster = [bkmxDoc macster];

    for (Client* client in [macster clients]) {
        [client rollUnexportedDeletions];
    }
    [macster save];
}

- (void)forgetDocumentIfItWasNotFound {    
}

@end
