#import "BkmxDoc+Actions.h"
#import "StarkEditor.h"
#import "NSString+LocalizeSSY.h"
#import "BkmxArrayCategories.h"
#import "Starker.h"
#import "Bookshig.h"
#import "BkmxDocWinCon.h"
#import "VerifySinceController.h"
#import "FindViewController.h"
#import "BkmxBasis+Strings.h"
#import "Stark+LegacyArtifacts.h"
#import "NSInvocation+Quick.h"
#import "NSString+SSYExtraUtils.h"
#import "SSYProgressView.h"
#import "SSYMH.AppAnchors.h"
#import "NSDocumentController+DisambiguateForUTI.h"
#import "SSYSheetEnder.h"
#import "Macster.h"
#import "Client.h"
#import "ClientChoice.h"
#import "Importer.h"
#import "Exporter.h"
#import "SSYDeallocDetector.h"
#import "SSYLabelledRadioButtons.h"
#import "ReportsViewController.h"
#import "NSDocument+SSYAutosaveBetter.h"
#import "NSDictionary+SimpleMutations.h"
#import "Broker.h"
#import "SpecifyCruftController.h"
#import "ApproveCruftController.h"
#import "NSString+SSYHttpQueryCruft.h"
#import "StarkCruft.h"
#import "Extore.h"

// For debugging

@implementation BkmxDoc (Actions)

- (IBAction)copy:(id)sender {
    [StarkEditor copyCut:NO
                  sender:sender] ;
}

- (IBAction)cut:(id)sender {
    // See note 598295 at end of this file
    if ([self ssy_isInViewingMode]) {
        NSBeep() ;
        return ;
    }
    
    [StarkEditor copyCut:YES
                  sender:sender] ;
}

- (IBAction)clearDontVerify:(id)sender {
    // See note 598295 at end of this file
    if ([self ssy_isInViewingMode]) {
        NSBeep() ;
        return ;
    }
    
    NSArray* starks = [StarkEditor starksFromSender:sender] ;
    SSYDooDooUndoManager *undoer = (SSYDooDooUndoManager*)[[[starks lastObject] owner] undoManager] ;
    for (Stark* item in starks) {
        if ([[item dontVerify] boolValue]) {
            [item setDontVerify:[NSNumber numberWithBool:NO]] ;
        }
    }
    
    NSString* actionName = [NSString stringWithFormat:@"%@ (%@)",
                            [NSString localizeFormat:@"clearX",
                             [[[BkmxBasis sharedBasis] labelDontVerify] doublequote]],
                            [starks readableName]] ;
    [undoer setActionName:actionName] ;
}

- (IBAction)visitItems:(id)sender {
    [StarkEditor visitItems:[StarkEditor starksFromSender:sender]
             urlTemporality:BkmxUrlTemporalityCurrent] ;
}

- (IBAction)visitPriorUrlItems:(id)sender {
    [StarkEditor visitItems:[StarkEditor starksFromSender:sender]
             urlTemporality:BkmxUrlTemporalityPrior] ;
}

- (IBAction)visitSuggestedUrlItems:(id)sender {
    [StarkEditor visitItems:[StarkEditor starksFromSender:sender]
             urlTemporality:BkmxUrlTemporalitySuggested] ;
}

- (IBAction)deleteItems:(id)sender {
    // See note 598295 at end of this file
    if ([self ssy_isInViewingMode]) {
        NSBeep() ;
        return ;
    }
    
    NSArray* proposedDeletions = [StarkEditor starksFromSender:sender] ;
    BkmxDoc* document = nil ;
    
    NSMutableArray* deletions = [proposedDeletions mutableCopy] ;
    for (Stark* stark in proposedDeletions) {
        if (!document) {
            document = (BkmxDoc*)[stark owner] ;
        }
        Sharype sharype = [stark sharypeValue] ;
        if ([StarkTyper isHartainerCoarseSharype:sharype]) {
            // The following if() is "just to make sure"
            if ([document isKindOfClass:[BkmxDoc class]]) {
                [deletions removeObject:stark] ;
                
                // Even though the hartainer is not going to be deleted, I
                // want its children to be deleted.  Normally, this happens
                // due to the Cascade Delete Rule for stark's children in
                // the data model.  However, it won't happen here because the
                // hartainer is in fact not deleted.
                [deletions addObjectsFromArray:[[stark children] allObjects]] ;
            }
        }
    }
    
    NSArray* items = [deletions copy] ;
    [deletions release] ;
    
    [StarkEditor parentingAction:BkmxParentingRemove
                           items:items
                       newParent:nil
                        newIndex:0
                    revealDestin:YES] ;
    // Above, revealDestin is needed to deselect the removed items.
    
    [items release] ;

    [self noticeStarkDeletions];
}

- (IBAction)setSortable:(id)sender {
    // See note 598295 at end of this file
    if ([self ssy_isInViewingMode]) {
        NSBeep() ;
        return ;
    }
    
    [StarkEditor setSortableBool:![sender state]
                          sender:nil] ;
}

- (IBAction)setSortableYes:(id)sender {
    // See note 598295 at end of this file
    if ([self ssy_isInViewingMode]) {
        NSBeep() ;
        return ;
    }
    
    [StarkEditor setSortableBool:YES
                          sender:sender] ;
}

- (IBAction)setSortableNo:(id)sender {
    // See note 598295 at end of this file
    if ([self ssy_isInViewingMode]) {
        NSBeep() ;
        return ;
    }
    
    [StarkEditor setSortableBool:NO
                          sender:sender] ;
}

- (void)setSelectedSortable:(id)sender {
    [self setSortable:sender];
}

- (IBAction)nudgeSelectionDown:(id)sender {
    // See note 598295 at end of this file
    if ([self ssy_isInViewingMode]) {
        NSBeep() ;
        return ;
    }
    
    Stark* item = [self selectedStark] ;
    
    // If this is a move within the same parent,
    // the ApplicationController -action:items:toParent:targetItem:atIndex method is going
    // to retarget the index by subtracting one, which makes it work correctly for drag and drop,
    // but not for us.  So we have to un-compensate for this by adding one:
    StarkLocation* location = [item locationDown1] ;
    if ([location parent] == [item parent]) {
        [location setIndex:([location index] + 1)] ;
    }
    
    [StarkEditor moveItem:item toLocation:location] ;
}

- (IBAction)nudgeSelectionUp:(id)sender {
    // See note 598295 at end of this file
    if ([self ssy_isInViewingMode]) {
        NSBeep() ;
        return ;
    }
    
    Stark* item = [self selectedStark] ;
    [StarkEditor moveItem:item toLocation:[item locationUp1]] ;
}

- (IBAction)swapPriorAndCurrentUrls:(id)sender {
    // See note 598295 at end of this file
    if ([self ssy_isInViewingMode]) {
        NSBeep() ;
        return ;
    }
    
    [StarkEditor swapPriorAndCurrentUrls:sender] ;
}

- (IBAction)swapSuggestedAndCurrentUrls:(id)sender {
    // See note 598295 at end of this file
    if ([self ssy_isInViewingMode]) {
        NSBeep() ;
        return ;
    }
    
    [StarkEditor swapSuggestedAndCurrentUrls:sender] ;
}

- (IBAction)aggresivelyNormalizeUrls:(id)sender {
    // See note 598295 at end of this file
    if ([self ssy_isInViewingMode]) {
        NSBeep() ;
        return ;
    }
    
    SSYAlert* alert = [SSYAlert alert] ;
    NSString* msg = @"This action will remove any trailing forward slash from the end of the *path* portion of any URL in this document, unless said slash is the only character in the *path*.\n\nThis can result in finding more duplicates.  Click the round '?' button for more info." ;
    [alert setSmallText:msg] ;
    [alert setButton1Title:[NSString localizeFormat:@"proceed"]] ;
    [alert setButton2Title:[[BkmxBasis sharedBasis] labelCancel]] ;
    [alert setHelpAddress:constHelpAnchorAggressivelyNormalizeUrls] ;
    [self runModalSheetAlert:alert
                  resizeable:NO
                   iconStyle:SSYAlertIconInformational
               modalDelegate:self
              didEndSelector:@selector(didEndAggressivelyNormalizeSheet:returnCode:contextInfo:)
                 contextInfo:NULL] ;
}

- (void)didEndAggressivelyNormalizeSheet:(NSWindow*)sheet
                              returnCode:(NSInteger)returnCode
                             contextInfo:(void*)contextInfo {
    switch (returnCode) {
        case NSAlertFirstButtonReturn:;
            NSInteger nFixed = [self aggressivelyNormalizeUrls] ;
            NSString* what = [NSString stringWithFormat:
                              @"%ld bookmarks",
                              (long)nFixed] ;
            
            SSYAlert* alert = [SSYAlert alert] ;
            NSString* msg = [NSString stringWithFormat:
                             @"%@ had their URLs changed.",
                             what] ;
            [alert setSmallText:msg] ;
            [self runModalSheetAlert:alert
                          resizeable:NO
                           iconStyle:SSYAlertIconInformational
                       modalDelegate:nil
                      didEndSelector:NULL
                         contextInfo:NULL] ;
            
            if (nFixed > 0) {
                [self setUndoActionNameForAction:SSYModelChangeActionModify
                                          object:nil
                                       objectKey:nil
                                      updatedKey:constKeyUrl
                                           count:nFixed] ;
            }
            
            
            
            break ;
        default:
            ;
    }
}

- (IBAction)setSortDirectiveTop:(id)sender {
    // See note 598295 at end of this file
    if ([self ssy_isInViewingMode]) {
        NSBeep() ;
        return ;
    }
    
    [StarkEditor setSortDirectiveTopStarks:[StarkEditor starksFromSender:sender]] ;
}

- (IBAction)setSortDirectiveBottom:(id)sender {
    // See note 598295 at end of this file
    if ([self ssy_isInViewingMode]) {
        NSBeep() ;
        return ;
    }
    
    [StarkEditor setSortDirectiveBottomStarks:[StarkEditor starksFromSender:sender]] ;
}

- (IBAction)setSortDirectiveNormal:(id)sender {
    // See note 598295 at end of this file
    if ([self ssy_isInViewingMode]) {
        NSBeep() ;
        return ;
    }
    
    [StarkEditor setSortDirectiveNormalStarks:[StarkEditor starksFromSender:sender]] ;
}

#if 0
static CGFloat s = -20 ;

- (void)scrolly:(NSTimer*)timer {
    ContentOutlineView* cov = [timer userInfo] ;
    [cov scrollPoint:NSMakePoint(0, s)] ;
    printf("Scrolled to %0.1f\n", s) ;
    s += 3.0 ;
    if (s >= 55) {
        [timer invalidate] ;
        printf("Done\n") ;
        s = -20 ;
    }
}
#endif

- (IBAction)documentInfo:(id)sender {
    NSMutableString* msg = [[NSMutableString alloc] init] ;
    NSString* displayKey ;
    NSString* lineItem ;
    
    // statistics
    lineItem = [[[self starker] root] displayStatsLong] ;
    [msg appendString:lineItem] ;
    
    // filePath
    displayKey = [NSString localize:@"filePath"] ;
    lineItem = [self descriptionForKeyPath:@"fileURL.path"
                                displayKey:displayKey] ;
    if (lineItem) {
        [msg appendString:@"\n\n"] ;
        [msg appendString:lineItem] ;
    }
    
    // identifier
    displayKey = @"Unique Identifier (UUID)" ;
    lineItem = [self descriptionForKeyPath:@"uuid"
                                displayKey:displayKey] ;
    if (lineItem) {
        [msg appendString:@"\n\n"] ;
        [msg appendString:lineItem] ;
    }
    
    SSYAlert* alert = [SSYAlert alert] ;
    [alert setTitleText:[self displayName]] ;
    [alert setSmallText:msg] ;
    // So that user can copy desired values to clipboard:
    [[alert smallTextView] setSelectable:YES] ;
    
    [msg release] ;
    //[alert setRightColumnMinimumWidth:500] ;
    [alert setButton1Title:[NSString localize:@"close"]] ;
    [self runModalSheetAlert:alert
                   resizeable:NO
                   iconStyle:SSYAlertIconInformational
               modalDelegate:nil
              didEndSelector:NULL
                 contextInfo:NULL] ;
}

- (IBAction)import:(id)sender {
    // See note 598295 at end of this file
    if ([self ssy_isInViewingMode]) {
        NSBeep() ;
        return ;
    }
    
    NSMutableDictionary* info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 // Since we've definitely got the GUI here, deference is ask
                                 [NSNumber numberWithInteger:BkmxDeferenceAsk], constKeyDeference,
                                 // The following line was added in BookMacster 1.14.9
                                 [NSNumber numberWithInteger:BkmxPerformanceTypeUser], constKeyPerformanceType,
                                 [NSNumber numberWithBool:YES], constKeyIfNotNeeded,
                                 self, constKeyDocument,
                                 nil] ;
    [self importLaInfo:info
   grandDoneInvocation:NULL] ;
}

- (IBAction)export:(id)sender {
    [self exportIfPermittedInfo:nil] ;
}

- (IBAction)sort:(id)sender {
    // See note 598295 at end of this file
    if ([self ssy_isInViewingMode]) {
        NSBeep() ;
        return ;
    }
    
    [self sort] ;
}

- (IBAction)consolidateFolders:(id)sender {
    // See note 598295 at end of this file
    if ([self ssy_isInViewingMode]) {
        NSBeep() ;
        return ;
    }
    
    [self consolidateFolders] ;
}

- (IBAction)findDupes:(id)sender {
    // See note 598295 at end of this file
    if ([self ssy_isInViewingMode]) {
        NSBeep() ;
        return ;
    }
    
    [self findDupes] ;
}

- (IBAction)deleteAllDupes:(id)sender {
    // See note 598295 at end of this file
    if ([self ssy_isInViewingMode]) {
        NSBeep() ;
        return ;
    }
    
    SSYAlert* alert = [SSYAlert alert] ;
    
    NSString* soft_or_softOrHard =
    [[[self shig] ignoreDisparateDupes] boolValue]
    ? [[BkmxBasis sharedBasis] labelSoftainers]
    : [NSString stringWithFormat:
       @"%@ %@ %@",
       [[BkmxBasis sharedBasis] labelSoftainers],
       [NSString localize:@"filterRuleOr"],
       [[BkmxBasis sharedBasis] labelHartainers]] ;
    NSString* msg = [NSString stringWithFormat:
                     @"%@\n\n%@",
                     [[BkmxBasis sharedBasis] toolTipDeleteAllDupes],
                     [NSString localizeFormat:
                      @"dupeGroupsDellAllTTNX",
                      soft_or_softOrHard]] ;
    [alert setSmallText:msg] ;
    [alert setButton1Title:[[BkmxBasis sharedBasis] labelDoIt]] ;
    [alert setButton2Title:[NSString localize:@"cancel"]] ;
    [alert setHelpAddress:constHelpAnchorDeleteAllDupes] ;
    [self runModalSheetAlert:alert
                  resizeable:NO
                   iconStyle:SSYAlertIconCritical
               modalDelegate:self
              didEndSelector:@selector(didEndDeleteAllDupesSheet:returnCode:contextInfo:)
                 contextInfo:NULL] ;
}

- (void)didEndDeleteAllDupesSheet:(NSWindow*)sheet
                       returnCode:(NSInteger)returnCode
                      contextInfo:(void*)notUsed {
    [sheet orderOut:self] ;
    if(returnCode == NSAlertFirstButtonReturn) {
        [self deleteAllDupes] ;
    }
}

- (IBAction)deleteAllContent:(id)sender {
    // See note 598295 at end of this file
    if ([self ssy_isInViewingMode]) {
        NSBeep() ;
        return ;
    }
    
    [self deleteAllContent] ;
}

- (IBAction)expandRoots:(id)sender {
    [self expandRootChildren:YES] ;
}

- (IBAction)collapseRoots:(id)sender {
    [self expandRootChildren:NO] ;
}

- (IBAction)verify:(id)sender {
    // See note 598295 at end of this file
    if ([self ssy_isInViewingMode]) {
        NSBeep() ;
        return ;
    }
    
    VerifySinceController* windowController = [[VerifySinceController alloc] initWithWindowNibName:@"VerifySince"] ;
    // windowController is released in the completion handler.
    
    // Note: In the nib containing the sheet/window, make sure that in the
    // window attribute "Visible on Launch" is NOT checked.  If it is,
    // the window will display immediately as a freestanding window
    // instead of the next line attaching it to hostWindow as a sheet.
    
    NSWindow* hostWindow = [[self bkmxDocWinCon] window] ;
    
    [hostWindow beginSheet:[windowController window]
         completionHandler:^void(
                                 NSModalResponse modalResponse) {
             /* If user clicks "Verify", modalResponse = 1000.
              If user clicks "Cancel", modalResponse = 1002 */
             NSDate* since = [(VerifySinceController*)windowController since] ;
             BOOL plusAllFailed = [(VerifySinceController*)windowController plusAllFailed] ;
             [(VerifySinceController*)windowController release] ;
             
             if (modalResponse == NSAlertFirstButtonReturn) {
                 [self verifyAllSince:since
                        plusAllFailed:plusAllFailed
                        waitUntilDone:NO] ;
             }
         }] ;
}

- (void)verifyDialogDidEnd:(NSWindow*)sheet
                returnCode:(NSModalResponse)modalResponse
               contextInfo:(void*)windowController {
    
}

// Invoked by the Gear button in BkmxDoc.xib's tab Reports > Verify
- (IBAction)verifyAllNeverVerified:(id)sender {
    // See note 598295 at end of this file
    if ([self ssy_isInViewingMode]) {
        NSBeep() ;
        return ;
    }
    
    [self verifyAllSince:[NSDate distantPast]
           plusAllFailed:NO
           waitUntilDone:NO] ;
}


- (IBAction)removeCruft:(id)sender {
    // See note 598295 at end of this file
    if ([self ssy_isInViewingMode]) {
        NSBeep() ;
        return ;
    }
    
    SpecifyCruftController* windowController = [[SpecifyCruftController alloc] init] ;
    
    // Note: In the nib containing the sheet/window, make sure that in the
    // window attribute "Visible on Launch" is NOT checked.  If it is,
    // the window will display immediately as a freestanding window
    // instead of the next line attaching it to hostWindow as a sheet.
    
    NSWindow* hostWindow = [[self bkmxDocWinCon] window] ;
    
    [hostWindow beginSheet:[windowController window]
         completionHandler:^void(
                                 NSModalResponse modalResponse) {
             [(SpecifyCruftController*)windowController release] ;
             
             if (modalResponse == NSAlertFirstButtonReturn) {
                 [self findCruftyStarks] ;
             }
         }] ;
}

- (void)findCruftyStarks {
    NSError* error = nil ;
    NSArray <NSDictionary*>* cruftSpecs = [[NSUserDefaults standardUserDefaults] objectForKey:@"queryCruftSpecs"] ;
    NSMutableSet <StarkCruft*> * starkCrufts = [NSMutableSet new] ;
    for (Stark* stark in self.starker.allStarks) {
        NSString* oldUrl = stark.url ;
        NSArray* ranges = [oldUrl rangesOfQueryCruftSpecs:cruftSpecs
                                                  error_p:&error] ;
        if (error) {
            [SSYAlert alertError:error
                        onWindow:[[self bkmxDocWinCon] window]
                   modalDelegate:nil
                  didEndSelector:NULL
                     contextInfo:NULL] ;
            break ;
        }
        
        if (ranges.count > 0) {
            StarkCruft* starkCruft = [StarkCruft new] ;
            starkCruft.stark = stark ;
            starkCruft.cruftRanges = ranges ;
            [starkCrufts addObject:starkCruft] ;
            [starkCruft release] ;
        }
    }
    
    NSWindow* hostWindow = [[self bkmxDocWinCon] window] ;
    
    if (starkCrufts.count > 0) {
        ApproveCruftController* windowController = [[ApproveCruftController alloc] initWithStarkCrufts:starkCrufts] ;
        
        // Note: In the nib containing the sheet/window, make sure that in the
        // window attribute "Visible on Launch" is NOT checked.  If it is,
        // the window will display immediately as a freestanding window
        // instead of the next line attaching it to hostWindow as a sheet.
        
        [hostWindow beginSheet:[windowController window]
             completionHandler:^void(
                                     NSModalResponse modalResponse) {
                 [(ApproveCruftController*)windowController release] ;
                 /* Actual work is done in
                  -[ApproveCruftController removeSelectedCruft] */
             }] ;
    }
    else {
        SSYAlert* alert = [SSYAlert new] ;
        NSString* msg = NSLocalizedString(@"Your bookmarks are clean – none have any of the Cruft which you specified.", nil) ;
        [alert setSmallText:msg] ;
        [alert setIconStyle:SSYAlertIconInformational] ;
        [alert setButton1Title:NSLocalizedString(@"OK", nil)] ;
        [alert doooLayout] ;
        [hostWindow beginSheet:[alert window]
              completionHandler:^void(NSModalResponse modalResponse) {
                  [alert release] ;
              }] ;
    }
    
    [starkCrufts release] ;
}

- (IBAction)find:(id)sender {
    // The following payloads the ReportsLazyView in case it is not.
    [[self bkmxDocWinCon] revealTabViewReports:self] ;
    [[[[self bkmxDocWinCon] reportsViewController] findViewController] reveal] ;
}

- (void)legacyArtifactSavexDialogDidEnd:(NSWindow*)sheet
                             returnCode:(NSInteger)returnCode
                            contextInfo:(void*)windowController {
    if (returnCode == NSAlertFirstButtonReturn) {
        [self export:self] ;
        [self saveDocument:self] ;
    }
}

- (void)legacyArtifactDialogDidEnd:(NSWindow*)sheet
                        returnCode:(NSInteger)returnCode
                       contextInfo:(void*)contextInfo {
    if (returnCode == NSAlertFirstButtonReturn) {
        NSInteger nRemoved = 0 ;
        for (Stark* stark in [[self starker] allStarks]) {
            BOOL didDo = NO ;
            if ([stark removeLegacyUUIDFromBrowprietaries]) {
                didDo = YES ;
            }
            if ([stark updateSortDirectivesRemoveLegacy:YES]) {
                didDo = YES ;
            }
            if ([stark removeLegacyUUIDFromComments]) {
                didDo = YES ;
            }
            if (didDo) {
                nRemoved++ ;
            }
        }
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:constKeyKeepLegacyArtifacts] ;
        
        SSYAlert* alert = [SSYAlert alert] ;
        [alert setSmallText:[NSString localizeFormat:
                             @"artifactsBookdog2",
                             [NSNumber numberWithInteger:nRemoved],
                             [[BkmxBasis sharedBasis] labelExportAndSave],
                             [[self macster] readableExportsListOnlyIfVulnerable:NO
                                                                   maxCharacters:512]]] ;
        [alert setRightColumnMinimumWidth:300] ;
        [alert setButton1Title:[[BkmxBasis sharedBasis] labelExportAndSave]] ;
        [alert setButton2Title:[NSString localize:@"notYet"]] ;
        [self runModalSheetAlert:alert
                      resizeable:NO
                       iconStyle:SSYAlertIconInformational
                   modalDelegate:self
                  didEndSelector:@selector(legacyArtifactSavexDialogDidEnd:returnCode:contextInfo:)
                     contextInfo:NULL] ;
    }
}


- (IBAction)removeLegacyArtifacts:(id)sender {
    // See note 598295 at end of this file
    if ([self ssy_isInViewingMode]) {
        NSBeep() ;
        return ;
    }
    
    SSYAlert* alert = [SSYAlert alert] ;
    [alert setSmallText:[NSString localizeFormat:
                         @"artifactsBookdog1",
                         [[BkmxBasis sharedBasis] labelRemove]]] ;
    [alert setRightColumnMinimumWidth:400] ;
    [alert setButton1Title:[NSString localize:@"remove"]] ;
    [alert setButton2Title:[NSString localize:@"cancel"]] ;
    [self runModalSheetAlert:alert
                   resizeable:NO
                   iconStyle:SSYAlertIconInformational
               modalDelegate:self
              didEndSelector:@selector(legacyArtifactDialogDidEnd:returnCode:contextInfo:)
                 contextInfo:NULL] ;
}

- (void)saveDocumentActionPart1OpType:(NSSaveOperationType)saveOperation {
    // Prior to BookMacster 1.3.6, I tested for valid syncers here, then
    // invoked invalidAgentSheetDidEnd:returnCode:contextInfo:.
    // I thought I'd leave this wrapper in case any similar asynchronous
    // call was ever required again.
    
    [self saveDocumentActionPart2OpType:saveOperation] ;
}

- (IBAction)closeAndTrash:(id)sender {
    // See note 598295 at end of this file
    if ([self ssy_isInViewingMode]) {
        NSBeep() ;
        return ;
    }
    
    NSString* displayName = [self displayName] ;
    NSString* msg = [NSString stringWithFormat:
                     @"%@ %@",
                     [NSString localizeFormat:
                      @"trashWillX",
                      displayName],
                     [NSString localize:@"agentsUnDoc"]] ;
    SSYAlert* alert = [SSYAlert alert] ;
    [alert setSmallText:msg] ;
    [alert setButton1Title:[[BkmxBasis sharedBasis] labelOk]] ;
    [alert setButton2Title:[[BkmxBasis sharedBasis] labelCancel]] ;
    [self runModalSheetAlert:alert
                  resizeable:NO
                   iconStyle:SSYAlertIconCritical
               modalDelegate:self
              didEndSelector:@selector(didEndCloseAndDeleteSheet:returnCode:contextInfo:)
                 contextInfo:NULL] ;
}

- (IBAction)saveDocument:(id)sender {
    // See note 598295 at end of this file
    if ([self ssy_isInViewingMode]) {
        NSBeep() ;
        return ;
    }
    
    BkmxPerformanceType type = ([[BkmxBasis sharedBasis] currentAppleScriptCommand] != nil) ? BkmxPerformanceTypeScripted : BkmxPerformanceTypeUser ;
    [self setCurrentPerformanceType:type] ;
    [self saveDocumentActionPart1OpType:NSSaveOperation] ;
    [self setCurrentPerformanceType:BkmxPerformanceTypeUser] ;
}


- (IBAction)saveDocumentAs:(id)sender {
    // See note 598295 at end of this file
    if ([self ssy_isInViewingMode]) {
        NSBeep() ;
        return ;
    }

    [super saveDocumentAs:sender];
}

- (IBAction)clearProgressView:(id)sender {
    [[self progressView] clearAll] ;
}

- (void)performForUserIxportPolarity:(BkmxIxportPolarity)ixportPolarity
                              client:(Client*)client
                                info:(NSDictionary*)extraInfo {
    NSMutableDictionary* info = [NSMutableDictionary dictionary] ;
    
    // The following line was added in BkmkMgrs 1.22.19
    [info setObject:[NSNumber numberWithInteger:BkmxPerformanceTypeUser]
             forKey:constKeyPerformanceType] ;
    
    if (extraInfo) {
        [info addEntriesFromDictionary:extraInfo] ;
    }
    
    Ixporter* ixporter ;
    NSInvocation* invocation ;
    if (ixportPolarity == BkmxIxportPolarityImport) {
        ixporter = [client importer] ;
        invocation = [NSInvocation invocationWithTarget:self
                                               selector:@selector(importPerInfo:)
                                        retainArguments:YES
                                      argumentAddresses:&info] ;
        [info setObject:[NSSet setWithObject:ixporter]
                 forKey:constKeyDoOnlyImportersSet] ;
    }
    else {
        ixporter = [client exporter] ;
        invocation = [NSInvocation invocationWithTarget:self
                                               selector:@selector(exportIfPermittedInfo:)
                                        retainArguments:YES
                                      argumentAddresses:&info] ;
        [info setObject:ixporter
                 forKey:constKeyDoOnlyExporter] ;
    }
    [info setObject:[NSNumber numberWithInteger:BkmxDeferenceAsk]
             forKey:constKeyDeference] ;
    
    if ([client willSelfDestruct]) {
        // We want to delete the quickie client "when we are done with it".
        // If all goes well, that would be in -[BkmxDoc finishGroupOfOperationsWithInfo],
        // but might not be if there is an error, such as a browser running,
        // and the user chooses to recover by clicking the "Quit Application(s)"
        // button.  However, we are definitely done with it when the 'info'
        // dictionary is deallocated!  So, we place a deallocDetector set to
        // delete the quickie client in the 'info' dictionary.
        NSInvocation* deleteClientInvocation = [NSInvocation invocationWithTarget:[client managedObjectContext]
                                                                         selector:@selector(deleteObject:)
                                                                  retainArguments:YES
                                                                argumentAddresses:&client] ;
        // Bug fixed in BookMacster 1.11…  Method -[SSYDeallocDetector dealloc] sometimes,
        // about half the time, runs on a non-main thread!  When this would happen, the
        // -[NSManagedObjectContext deleteObject:] method sometimes deleted the client,
        // sometimes not, but always the temporary client was still apparent in
        // Settings ▸ Clients, at least until the document was reopened, sometimes longer.
        // Anyhow, the sin is accessing the Settings MOC on a non-main thread.  To fix
        // that, I now wrap the above invocation in another invocation which is to
        // perform it on the main thread, then put the wrapped invocation into info.
        // Amazingly, it fixed the problem.  Before fix: 5/10 fail.  After fix: 0/10 fail.
        BOOL yes = YES ;
        NSInvocation* deleteClientOnMainThreadInvocation = [NSInvocation invocationWithTarget:[NSInvocation class]
                                                                                     selector:@selector(invokeOnMainThreadTarget:selector:retainArguments:waitUntilDone:argumentAddresses:)
                                                                              retainArguments:YES
                                                                            argumentAddresses:&deleteClientInvocation, &(@selector(invoke)), &yes, &yes, NULL] ;
        SSYDeallocDetector* deallocDetector = [SSYDeallocDetector detectorWithInvocation:deleteClientOnMainThreadInvocation
                                                                                  logMsg:nil] ;
        [info setObject:deallocDetector
                 forKey:@"Acme Single-Use Client Destroyer"] ;
        [info setObject:[NSNumber numberWithBool:YES]
                 forKey:constKeyClientShouldSelfDestruct] ;
    }
    
    if ([client willOverlay]) {
        [info setObject:[NSNumber numberWithBool:YES]
                 forKey:constKeyOverlayClient] ;
    }
    
    if ([client willIgnoreLimit]) {
        [info setObject:[NSNumber numberWithBool:YES]
                 forKey:constKeyIgnoreLimit] ;
    }
    
    if ([client exformat]) {
        // User must have chosen an "actual" client
        [invocation invoke] ;
    }
    else {
        // User must have chosen the "Other Mac Account" or
        // "Choose File (Advanced)" item.  Stash the invocation
        // away until client has been configured.
        [client setWaitingInvocation:invocation] ;
    }
}

- (void)doSingleIxportPolarity:(BkmxIxportPolarity)ixportPolarity
                       overlay:(BOOL)overlay
                   ignoreLimit:(BOOL)ignoreLimit
                         alert:(SSYAlert*)alert
                  clientChoice:(ClientChoice*)clientChoice
                 regularClient:(Client*)client
                          info:(NSDictionary*)extraInfo {
    BOOL forceStyle1 = NO;
    if (alert) {
        SSYLabelledRadioButtons* radioButtons = [[alert otherSubviews] objectAtIndex:0] ;
        overlay = ([radioButtons selectedIndex] == 1) ;
        ignoreLimit = ([radioButtons selectedIndex] == 1) ;

        forceStyle1 = [alert checkboxState];
    }

    /* The following was added in BkmxMgrs 1.22.20.  It may be just defensive
     programming because a client should always have an importer an an
     exporter, unless you mess with the Exids.sql as I have done today.  Anyhow,
     it fixes a crash in that case. */
    BOOL passedInClientHasRequiredPolarity =
    (
     ((ixportPolarity == BkmxIxportPolarityImport) && ([client importer] != nil))
     ||
     ((ixportPolarity == BkmxIxportPolarityExport) && ([client exporter] != nil))
     ) ;
    
    if (!client || overlay || !passedInClientHasRequiredPolarity) {
        /* Discard the passed-in regular client and instead insert a new,
         temporary, self-destructing client. */
        client = [[self macster] freshClientAtIndex:NSNotFound
                                          singleUse:YES] ;
        
        // Configure the new client

        if (ixportPolarity == BkmxIxportPolarityImport) {
            [client setClientFileExistence:BkmxClientFileMustBeExisting] ;
        }
        else {
            [client setClientFileExistence:BkmxClientFileUsersChoiceDefaultToNew] ;
        }

        [client setLikeClientChoice:clientChoice] ;

        [client setWillSelfDestruct:YES] ;
        [client setWillIgnoreLimit:ignoreLimit] ;
        [client setWillOverlay:overlay] ;
        
        [[client importer] setIsActive:[NSNumber numberWithBool:NO]] ;
        [[client exporter] setIsActive:[NSNumber numberWithBool:NO]] ;
    }
    else {
        // Use passed-in client
    }
    
    if (forceStyle1) {
        if (!extraInfo) {
            extraInfo = @{constKeyForceStyle1Client:client};
        }
        else {
            extraInfo = [extraInfo dictionaryBySettingValue:client
                                                     forKey:constKeyForceStyle1Client];
        }
    }

    [self performForUserIxportPolarity:ixportPolarity
                                client:client
                                  info:extraInfo] ;
}

- (void)performForUserQuickIxportPolarity:(BkmxIxportPolarity)ixportPolarity
                                   object:(id)object
                                     info:(NSDictionary*)extraInfo {
    if (extraInfo) {
        extraInfo = [extraInfo dictionaryBySettingValue:[NSNumber numberWithBool:YES]
                                                 forKey:constKeyIfNotNeeded] ;
    }
    else {
        extraInfo = @{constKeyIfNotNeeded : @YES} ;
    }
    
    Client* client ;
    if ([object isKindOfClass:[Client class]]) {
        client = (Client*)object ;
        [self performForUserIxportPolarity:ixportPolarity
                                    client:client
                                      info:extraInfo] ;
    }
    else if ([object isKindOfClass:[ClientChoice class]]) {
        client = nil ;
        for (Client* aClient in [[self macster] clients]) {
            if ([[aClient clientoid] isEqual:[(ClientChoice*)object clientoid]]) {
                client = aClient ;
                break ;
            }
        }
        
        if (![[extraInfo objectForKey:constKeyIxportBookmacsterizerOnly] boolValue]) {
            // Give user the choice of using Client Settings or Quick Ixport Settings
            SSYAlert* alert = [SSYAlert alert] ;
            [alert setIconStyle:SSYAlertIconCritical] ;
            NSString* clientDisplayName = client ? [client displayName] : [(ClientChoice*)object displayName] ;
            NSString* destinDisplayName = (ixportPolarity == BkmxIxportPolarityImport) ? [self displayNameShort] : clientDisplayName ;
            NSString* ixportPolarityName ;
            Ixporter* ixporter ;
            if (ixportPolarity == BkmxIxportPolarityImport) {
                ixportPolarityName = [[BkmxBasis sharedBasis] labelImport] ;
                ixporter = [client importer] ;
                [client setClientFileExistence:BkmxClientFileMustBeExisting] ;
            }
            else {
                ixportPolarityName = [[BkmxBasis sharedBasis] labelExport] ;
                ixporter = [client exporter] ;
                [client setClientFileExistence:BkmxClientFileUsersChoiceDefaultToExisting] ;
            }
            BOOL wouldDeleteUnmatched = [[ixporter deleteUnmatched] boolValue] ;
            NSString* deleteUnmatchedString ;
            if (wouldDeleteUnmatched) {
                deleteUnmatchedString = @"Delete unmatched items" ;
            }
            else {
                deleteUnmatchedString = @"Do not delete unmatched items" ;
            }
            
            BOOL isBookMacster = [[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppBookMacster ;
            NSString* stringNormal = ((client != nil) && isBookMacster)
            ? [NSString stringWithFormat:
               @"Do a Normal %@ into %@, obeying all the settings in Settings > Clients.  %@.  Warn if Safe Limit is exceeded.  (Good choice if this Client is synced – will re-establish or maintain sync.)",
               ixportPolarityName,
               destinDisplayName,
               deleteUnmatchedString]
            : [NSString stringWithFormat:
               @"Do a Normal %@ into %@, deleting existing items which are not matched.",
               ixportPolarityName,
               destinDisplayName,
               nil] ;
            NSString* stringOverlay = ((client != nil) && isBookMacster)
            ? [NSString stringWithFormat:
               @"Do an Overlay.  Do not delete any existing items in %@.  Do not observe any limits.  (Good choice for a special, one-off %@.)",
               destinDisplayName,
               ixportPolarityName]
            : [NSString stringWithFormat:
               @"Do an Overlay.  Do not delete any existing items in %@.",
               destinDisplayName] ;
            
            NSArray* choices = [NSArray arrayWithObjects:
                                stringNormal,
                                stringOverlay,
                                nil] ;
            SSYLabelledRadioButtons* labelledRadioButtons = [SSYLabelledRadioButtons radioButtonsWithLabel:nil
                                                                                                   choices:choices
                                                                                                     width:500.0] ;
            [labelledRadioButtons setSelectedIndex:0] ;
            [alert addOtherSubview:labelledRadioButtons
                           atIndex:0] ;
            [alert setButton1Title:[NSString localize:@"ok"]] ;
            [alert setButton2Title:[NSString localize:@"cancel"]] ;

            /* Note that the following condition will return NO because client
             will be nil if the browser being exported to is not one of the
             receiver's Clients.  Therefore, it will always return NO for
             Markster.  It will always return NO for for Safari because
             +[ExtoreSafari hasProprietarySyncThatNeedsOwnerAppRunning] returns
             NO.  It will only return YES for Firefox, Chrome, Canary, or
             if one of these browsers is a Client.  */
            if ([[[client clientoid] extoreClass] hasProprietarySyncThatNeedsOwnerAppRunning]) {
                if (![[[client clientoid] extoreClass] requiresStyle2WhenProprietarySyncIsActive]) {
                    if ([[[client clientoid] extoreClass] style1Available]) {
                        NSString* checkboxTitle = [NSString stringWithFormat:
                                                   @"Do NOT launch %@ to coordinate syncing.",
                                                   [[[client clientoid] extoreClass] ownerAppDisplayName]];
                        [alert setCheckboxTitle:checkboxTitle];
                        [alert setRightColumnWidth:400.0];
                    }
                }
            }
                
            BOOL thisWillBeIgnored = NO ;  // (because alert is non-nil)
            NSArray* invocations = [NSArray arrayWithObjects:
                                    // Default button.
                                    // If user clicks "OK" button…
                                    [NSInvocation invocationWithTarget:self
                                                              selector:@selector(doSingleIxportPolarity:overlay:ignoreLimit:alert:clientChoice:regularClient:info:)
                                                       retainArguments:YES
                                                     argumentAddresses:&ixportPolarity, &thisWillBeIgnored, &thisWillBeIgnored, &alert, &object, &client, &extraInfo],
                                    // If user clicks "Cancel" button…
                                    [NSNull null],
                                    nil] ;
            
            [self runModalSheetAlert:alert
                           resizeable:NO
                           iconStyle:SSYAlertIconInformational
                       modalDelegate:[SSYSheetEnder class]
                      didEndSelector:@selector(didEndGenericSheet:returnCode:retainedInvocations:)
                         contextInfo:[invocations retain]] ;
        }
        else {
            // Just go with the Quick Ixport, overlay style, ignoring limit
            [self doSingleIxportPolarity:ixportPolarity
                                 overlay:YES
                             ignoreLimit:YES
                                   alert:nil
                            clientChoice:(ClientChoice*)object
                           regularClient:nil
                                    info:extraInfo] ;
        }
    }
    else if ([object isKindOfClass:[Clientoid class]]) {
        // We have been AppleScripted to do a Quick Ixport
        
        // Insert a new client
        client = [[self macster] freshClientAtIndex:NSNotFound
                                          singleUse:YES] ;
        
        Clientoid* clientoid = (Clientoid*)object ;
        [client setIvarsThenInvokeWaitingIfAnyLikeClientoid:clientoid] ;
        
        if (ixportPolarity == BkmxIxportPolarityImport) {
            [client setClientFileExistence:BkmxClientFileMustBeExisting] ;
        }
        else {
            [client setClientFileExistence:BkmxClientFileUsersChoiceDefaultToExisting] ;
        }
        
        [client setWillSelfDestruct:YES] ;
        
        // The following two settings follow documentation of 'one_time import'
        // and 'one_time export' in our sdef file…
        [client setWillIgnoreLimit:NO] ;  // Actually not needed since willIgnoreLimit is NO by default
        [client setWillOverlay:YES] ;
        
        [[client importer] setIsActive:[NSNumber numberWithBool:NO]] ;
        [[client exporter] setIsActive:[NSNumber numberWithBool:NO]] ;
        
        [self performForUserIxportPolarity:ixportPolarity
                                    client:client
                                      info:extraInfo] ;
    }
    else {
        NSLog(@"Internal Error 623-3929 %@", object) ;
        return ;
    }
}

- (void)performForUserQuickIxportPolarity:(BkmxIxportPolarity)ixportPolarity
                                 menuItem:(NSMenuItem*)menuItem
                                extraInfo:(NSDictionary*)extraInfo {
    id object = [menuItem representedObject] ;
    [self performForUserQuickIxportPolarity:ixportPolarity
                                     object:object
                                       info:extraInfo] ;
}

- (void)performForUserQuickIxportPolarity:(BkmxIxportPolarity)ixportPolarity
                                 exformat:(NSString*)exformat
                                     path:(NSString*)path
                                extraInfo:(NSDictionary*)extraInfo {
    Clientoid* clientoid = nil ;
    if (path) {
        clientoid = [Clientoid clientoidLooseWithExformat:exformat
                                                     path:path] ;
    }
    else {
        clientoid = [Clientoid clientoidThisUserWithExformat:exformat
                                                 profileName:nil] ;
    }
    
    [self performForUserQuickIxportPolarity:ixportPolarity
                                     object:clientoid
                                       info:extraInfo] ;
}

- (void)exportAndCloseToExporters:(NSArray*)exporters {
    NSDictionary* extraInfo = nil ;
    NSInteger nToGo = [exporters count] ;
    for (Exporter* exporter in exporters) {
        Client* client = [exporter client] ;
        NSMenuItem* menuItem = [[NSMenuItem alloc] init] ;
        [menuItem setRepresentedObject:client] ;
        nToGo-- ;
        if (nToGo == 0) {
            NSInvocation* grandDoneInvocation = [NSInvocation invocationWithTarget:self
                                                                          selector:@selector(close)
                                                                   retainArguments:NO
                                                                 argumentAddresses:NULL] ;
            extraInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                         grandDoneInvocation, constKeyGrandDoneInvocation,
                         nil] ;
        }
        [self performForUserQuickIxportPolarity:BkmxIxportPolarityExport
                                       menuItem:menuItem
                                      extraInfo:extraInfo] ;
        [menuItem release] ;
    }
}

- (IBAction)importOnly:(NSMenuItem*)menuItem {
    // See note 598295 at end of this file
    if ([self ssy_isInViewingMode]) {
        NSBeep() ;
        return ;
    }
    
    [self performForUserQuickIxportPolarity:BkmxIxportPolarityImport
                                   menuItem:menuItem
                                  extraInfo:nil] ;
}

- (IBAction)exportOnly:(NSMenuItem*)menuItem {
    // See note 598295 at end of this file
    if ([self ssy_isInViewingMode]) {
        NSBeep() ;
        return ;
    }
    
    [self performForUserQuickIxportPolarity:BkmxIxportPolarityExport
                                   menuItem:menuItem
                                  extraInfo:nil] ;
}

- (IBAction)exportBookMacsterizer:(NSMenuItem*)menuItem {
    // See note 598295 at end of this file
    if ([self ssy_isInViewingMode]) {
        NSBeep() ;
        return ;
    }
    
    NSDictionary* extraInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithBool:YES], constKeyIxportBookmacsterizerOnly,
                               nil] ;
    [self performForUserQuickIxportPolarity:BkmxIxportPolarityExport
                                   menuItem:menuItem
                                  extraInfo:extraInfo] ;
}

@end

// Note 598295.  We disable any non-discardable action that can
// change the data model when in viewing mode (which is the
// "Yesterday at XX:XX" window on the right side of the Versions
// Browser) because you can't change the past.  Note that, although
// these actions might not be available via their normal controls,
// they may be available via keyboard shortcuts.
