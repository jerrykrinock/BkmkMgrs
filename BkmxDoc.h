#import <Cocoa/Cocoa.h>

#import "Startainer.h"
#import "StarCatcher.h"
#import "SSYErrorHandler.h"
#import "StarkReplicator.h"
#import "SSYModelChangeTypes.h"
#import "SSYErrorAlertee.h"
#import "Hartainertainer.h"
#import "BSManagedDocument+SSYMetadata.h"


extern NSString* const constKeyHasBar ;
extern NSString* const constKeyHasMenu ;
extern NSString* const constKeyHasOhared ;
extern NSString* const constKeyHasUnfiled ;

extern NSString* const BkmxDocDidSaveNotification;
extern NSString* const BkmxDocKeySaveOperation;

@class Chaker ;
@class Clientoid;
@class Stark ;
@class Bookshig ;
@class Dupetainer ;
@class Starker ; 
@class Tagger ;
@class SSYProgressView ;
@class BkmxDocWinCon ;
@class Broker ;
@class VerifySummary ;
@class SSYAlert ;
@class SSYDooDooUndoManager ;
@class Macster ;
@class Starxider ;
@class Starlobuter ;
@class TalderMapper ;
@class Extore ;
@class SSYOperation ;
@class SSYOperationQueue ;
@class SSYVersionTriplet ;
@class Ixporter ;
@class SSYBlocker ;

enum BkmxDocHashPart_enum {
	BkmxDocHashPartExtore = 1,
	BkmxDocHashPartBkmxDoc = 2,
	BkmxDocHashPartsBoth = 3
} ;
typedef enum BkmxDocHashPart_enum BkmxDocHashPart ;


/*!
 @brief    Some of the dupes in the receiver's dupetainer to be
 no longer dupes because of deleted starks, changed urls in starks,
 or isAllowedDupe being set in starks..
 */
extern NSString* const constNoteDupesMayContainVestiges ;

/*!
 @brief    Some of the dupes in the receiver's dupetainer to be
 no longer dupes because the receiver's owner's shig's
 ignoreDisparateDupes has been switched on, or because it was
 already on and starks have been moved to different collections.
 */
extern NSString* const constNoteDupesMayContainDisparagees ;

/*!
 @brief    Some event occurred which caused one or more starks
 in the receiver's managed object context to change.&nbsp; This
 is used to tell the outline view to reload data, since the
 outline is populated manually and not via bindings.
 */
extern NSString* const BkmxDocNotificationContentTouched ;

extern NSString* const BkmxDocNotificationStarkTouched ;

/*!
 @brief    BookMacster's default Document.  A "BkmxDoc" is a place
 for storing bookmarks in a given configuration.

 @details  Considered using just one notification instead of seven,
 using userInfo to identify which timestamp to update.  But since
 I need to coalesce on name to reduce the number of notifications,
 this would, for example, coalesce 'sorted' and 'unsorted' into
 one notification instead of having the 'unsorted' be first in/out
 of the queue and 'sorted' last in/out of the queue as desired.
 */
__attribute__((visibility("default"))) @interface BkmxDoc : BSManagedDocument <Hartainertainer, Startainer, StarCatcher, StarkReplicator, SSYErrorAlertee, SSYErrorHandler> {
	BOOL verifyInProgress ;
	
	// Retained managed objects
	Macster* m_macster ;
	Bookshig* m_shig ;
	Dupetainer* m_dupetainer ;
    
    NSManagedObjectModel* m_managedObjectModel ;

	Starxider* m_starxider ;
	Starlobuter* m_starlobuter ;
    TalderMapper* m_talderMapper ;
	Broker* _broker ;
	Starker* m_starker ;
    Tagger* m_tagger;
	SSYOperationQueue* m_operationQueue ;
	NSMutableArray* m_importedExtores ;
	Chaker* m_chaker ;
	// Cache this because it takes a LONG time to make one:
	NSDateFormatter* m_undoDateFormatter ;
	NSError* m_error ;
	VerifySummary* verifySummary ;
	SSYVersionTriplet* m_savedWithVersion ;
	NSDate* lastContentTouchDate ;
	NSMutableDictionary* m_clientLastPreImportedHashes ;
	NSMutableDictionary* m_clientLastPreExportedHashes ;
	NSMutableDictionary* m_clientLastImportedDates ;
	NSMutableArray* m_successfulIxporters ;
    NSSet* m_cleaningTimers ;
    Stark* m_lastLandedBookmark ;
    SSYBlocker* m_waitForClientProfileBlocker ;
	
	BOOL m_isReverting ;
    BOOL m_isSupercededByNewFileOnDisk ;
    BOOL m_isReloadingFromDisk;
	BOOL m_isZombie ;
    BOOL m_didSuperClose;
	BOOL skipAutomaticActions ;
	BOOL m_ignoreChanges ;
	BOOL m_shouldSkipAfterSaveHousekeeping ;
	BOOL m_closeWasRequested ;
	BOOL m_didImportPrimarySource ;
    BOOL m_warnCantSyncNoClientsScheduled ;
	NSInteger m_ixportIndex ;
	NSInteger m_hasHartainersCache ;
	
	NSInteger m_priorNumberOfUndoActions ;
	BkmxPerformanceType m_currentPerformanceType ;
    
    NSTimer* m_postLandingTimer ;
    NSTimer* m_nukePaveWarnTimer ;
    NSTimer* m_refreshVerifyTimer ;
}


#pragma mark * Accessors

/*!
 @brief    Finds the Macster instance which has the receiver's
 uuid from the persistent store in ~/Library/Application Support,
 or creates one if not found, and wires the relationship between
 the receiver and this Macter instance.
 */
- (void)linkToMacster ;

/*!
 @brief    Sets the receiver's macster's bkmxDoc to nil, and sets the
 receiver's macster to nil.

 @details  This message should be sent when closing the receiver.
*/
- (void)unlinkBkmxDocMacster ;

@property (retain) Macster* macster ;
@property (retain, readonly) Starker* starker;
@property (retain, readonly) Tagger* tagger;
@property (retain, readonly) NSManagedObjectContext* exidsMoc;
@property (retain, readonly) NSManagedObjectContext* settingsMoc;
@property (retain, readonly) NSManagedObjectContext* diariesMoc;
@property (retain, readonly) Starxider* starxider;
@property (retain, readonly) Starlobuter* starlobuter;
@property (retain, readonly) TalderMapper* talderMapper;

@property (readonly) NSString* lastSaveToken ;
@property (copy) NSString* lastKnownLastSaveToken;
@property (retain) Stark* lastLandedBookmark ;
@property (assign) BOOL autoSaveInhibited ;
@property (copy) NSString* uuid;

/*!
 @brief    An operation queue which should be used for any operations
 involving the receiver's data.
*/
@property (retain, readonly) SSYOperationQueue* operationQueue ;

@property (retain) NSMutableArray* importedExtores ;
@property (retain) NSError* error ;
/*!
 @brief    This is used only to trigger KVO for dependent keys
 @details  I don't send will/didChangeObjectForKey back-to-back
 because mmalc says not to, here,
 http://lists.apple.com/archives/Cocoa-dev/2006/Jun/msg00166.html
 Although it is in a different context.  Needs further study.
*/
@property (retain) NSDate* lastContentTouchDate  ;
@property (assign) BOOL isReverting ;
@property (assign) BOOL isSupercededByNewFileOnDisk ;
@property (assign) BOOL skipAutomaticActions ;
@property (assign) BOOL ignoreChanges ;
@property (assign) BOOL shouldSkipAfterSaveHousekeeping ;
@property (assign) BOOL didImportPrimarySource ;
@property (retain) NSSet* cleaningTimers ;

// Added in BookMacster 1.19.7
- (void)unlockWaitingForClientProfile ;
- (void)lockWaitingForClientProfile ;
- (void)blockWaitingForClientProfile ;

/*
 In the future, I should use -[Bkmxlf currentPerformanceType] more, instead
 of comparing NSApp, currentCommand or currentAppleScriptCommand to nil
 because these comparisons are kludgey and maybe fragile.
 */
@property (assign) BkmxPerformanceType currentPerformanceType ;

- (void)addRecentLanding:(Stark*)landing ;
- (NSArray*)recentLandings ;
- (void)forgetOperationQueue;
- (void)noteRecentDisplayName;
- (void)registerAliasForUuidInUserDefaults;
- (void)checkForBadClientsAnMaybeCleanOrphanedDocSupportObjects;

#pragma mark * Managing Client Ixports
/*
 # Damn Hashes

 ## Definitions of the Various Hashes (Hash Definitions)

 Importer's lastPreHash (lastPreImportedHash) and lastPostHash (lastPostExportedHash) is:
 •    [63..32] (contentHash of bkmxDoc content          ^ importer's compositeImportSettingsHash)
 •    [31..00] (contentHash of last import from extore  ^ importer's compositeImportSettingsHash)
 where
    importer's compositeImportSettingsHash = 
	   -[Ixporter valuesHash] ^ -[Macster importSettingsHash]
	Note that the first term gives the settings of the importer, and the second
    term gives the settings of Import Postprocessing.

 "preImported" should be updated whenever a client is read.  It indicates the
 last known content of the Extore, which we have already acted upon to schedule
 a job.

 "postImported" should be only updated after an actual import to this document.
 It indicates the last known content of the Extore, which we have actually
 imported or exported.

 Exporter's lastPreHash (lastPreExportedHash) is:
 •    [63]     1 if any changes were written during the last export, otherwise 0
 •    [62..32] contentHash of extore before merging with bkmxDoc content
 •    [31..00] (contentHash of bkmxDoc at time of export ^ valuesHash of exporter's settings)

 Exporter's lastPostHash (lastPostExportedHash) is:
 •    [63..32] not used
 •    [31..00] contentHash of extore after merging with bkmxDoc content
 
 BkmxDocs's lastSaveHash (lastPostExportedHash) is:
 •    [63..32] hash of dupes and bookshig (need to add this later)
 •    [31..00] contentHash of bkmxDoc content
 
 ## How we Use Hashes

 I think there are three places where we check for hashes.  I studied mostly
 the Import hashes.  There might be uses of Export hashes not documented
 here, yet.

 • WCDHC (Worker's Change Detection Hash Check)

 In Worker, when a change is detected, we may read the Client to see
 if its hash is different than the last known data we have read from or
 exported to that client.  First, we compare the content we read with
 postExported.  If that does not match, we compare it with postImported.  If
 the hashes match in either case, we call it a "Rehash-Export" or
 "Rehash-Import".  In any case, we save the new hash to preImported.  If
 neither hash matched, we stage a job.

 • ICHID  (Importer's Check that Hash Is Different)

 During an Import operation, -checkImportHashIsDiff wants to verify
 that the data we have just imported is different than data we have already
 imported.  We always save whatever we read to preImported.  If a difference is
 found with postImported, we save what we've read to postImported and merge
 the import.

 • ECHIS  (Exporter's Check that Hash is Same)

 During an Export operation, -checkExportHashIsDiff wants to verify
 that the data in any Client we are watching for changes has not changed since
 the last time we imported from it or exported to it, so that we do not
 overwrite changes made by the user.  First, we compare the content we read
 with postExported.  If a difference is found, we compare it with preImported.
 If either matches, we allow the export to proceed.  If neither matches, we
 abort the export, we forget the preImport hash for this client, set this
 client as needsImport for this document, and stage a do-over job.



 */


- (NSNumber*)lastPreImportedHashForClient:(Client*)client
							 whichPart:(BkmxDocHashPart)whichPart ;
- (void)rememberLastPreImportedHashForExtore:(Extore*)extore ;
- (void)forgetLastPreImportedHashForClient:(Client*)client ;
- (void)forgetLastPostImportedHashForClient:(Client*)client;

- (NSNumber*)lastPostImportedHashForClient:(Client*)client
                                 whichPart:(BkmxDocHashPart)whichPart;
- (void)rememberLastPostImportedHashForExtore:(Extore*)extore;

- (void)rememberBothLastImportedHashForExtore:(Extore*)extore;

- (NSNumber*)lastPreExportedHashForClient:(Client*)client ;
- (void)setLastPreExportedHash:(unsigned long long)hash
				  forClient:(Client*)client ;
- (void)forgetLastPreExportedHashForClient:(Client*)client ;
- (void)forgetAllLastPreImportedHashes ;
	
/*!
 @brief    Returns the internally-set last import date for
 a given client, or the date from the receiver's macster's
 persistent store, whichever is later.
 
 @details  See -lastImportedDateForClient:
*/
- (NSDate*)lastImportedDateForClient:(Client*)client ;

- (void)setAsNowLastImportedDateForClient:(Client*)client ;

/*!
 @brief    Sets the volatile (ivar) lastImported date
 for a given client in the receiver.

 @details  Beginning with BookMacster 1.7/1.6.8, we do
 not persist a client's lastImported date to the persistent
 store until after the next time that a BkmxDoc has been
 successully saved.  This is because, duh, the import data
 will be lost if it is not saved.  This is important, for example,
 if Worker imports successfully, but aborts during the
 subsequent export, which is before the Save operation.  If the
 lastImported was persisted immediately, a subsequent import
 operation, in particular the one which will occur a few seconds
 later in Main App if the user clicks "Retry" in the error recovery
 dialog, would skip the import because it would erroneously
 computer, in -checkIfExternalChanged_unsafe, that the latest
 import data already exists in the BkmxDoc.
 
 What we do now instead is to write the date to a dictionary
 instance variable in the BkmxDoc, and then persist it after 
 a successful save.
 */
- (void)setAsNowLastImportedDateForClients ;

- (void)forgetVolatileLastPreExportedDataForClientoid:(Clientoid*)clientoid ;


/*!
 @brief    Forgets all the volatile last imported and exported
 dates and hashes for all of the receiver's clients

 @details  This should be done whenever such dates are no longer
 valid, for example, when the receiver is reverted to a saved
 version.  See -lastImportedDateForClient:.
*/
- (void)forgetAllClientsVolatileLastIxportedData ;

/*!
 @brief    Writes the volatile last imported dates (if
 later than the existing persisted date) and
 last imported hashes for all of the receiver's clients
 to the client's persistent store (the "Settings….sql" file)
*/
- (void)persistClientLastPreImportedData ;

/*!
 @brief    Writes the volatile last exported hashes for
 all of the receiver's clients to the client's persistent
 store (the "Settings….sql" file)
 */
- (void)persistClientLastPreExportedData ;

/*!
 @brief    Adds an object to the receiver's importedExtores,
 creating the array if it is nil.
*/
- (void)addImportedExtore:(Extore*)extore ;

- (BOOL)wasImportableStark:(Stark*)stark ;

- (void)clearPostLandingTimer ;

- (void)setPostLandingTimer:(NSTimer*)timer ;

- (void)firePostLandingTimer ;

- (void)setNukePaveWarnTimer:(NSTimer*)timer ;

- (void)performAnyVersionMigrations;

#pragma mark * Basic Infrastructure

/*!
 @brief    A mechanism for aborting delayed invocations which might
 still have references to the receiver after it has been closed.
*/
@property (assign) BOOL isZombie ;

/*!
 @brief    Does things which would be done in -dealloc were
 it not for retain cycles when the receiver is being closed
 for good.
 
 @details  This method checks to see if the receiver -isReverting
 and in that case only unlinks the receiver's macster.  Same
 thing if this method has already run.  See -[BkmxDoc close] for more important info.
 */
- (void)tearDownOnce ;

- (void)reloadFromDiskNow ;

/*!
 @brief    Overridden to do kludgey housekeeping.
 
 @details  According to -[NSDocument close] documentation, this
 method may not always be invoked.  So I also send the same
 messages sent by this override in -[BkmxDocumentController removeDocument:].
 But I do it here too because it's earlier.  Here's an interesting call stack that I
 pulled out of gdb in macOS 10.6.7:
 
 #0 in -[MyDocumentController removeDocument:]
 #1 in -[NSDocument close]
 #2 in -[NSWindowController _windowDidClose]
 #3 in -[NSPersistentDocument revertToContentsOfURL:ofType:error:]
 
 It would be interesting to know when -[MyDocumentController removeDocument:]
 is invoked by other than -[NSDocument close].
 
 The three messages which are sent in this method are also
 sent in -[BkmxDocumentController removeDocument].
 Possibly there is some redundancy i.e. defensive programming.
 */
- (void)close ;

/*!
 @brief    Returns the display name without the filename extension.
 */
- (NSString*)displayNameShort ;

/*!
 @brief    We override -undoManager to return our own subclass, or nil
 if NSAp is nil, as it will be in Worker.
 */
- (SSYDooDooUndoManager*)undoManager ;

/*!
 @brief    The single instance of the 'shig' managed object from the
 receiver's managed object context

 @details  The document's 'shig' is a container for all of the "internal
 metadata"; everything except the starks.
*/
@property (retain, readonly) Bookshig* shig ;

- (NSInteger)aggressivelyNormalizeUrls ;

/*!
 @brief    The single instance of the 'dupetainer' managed object from the
 receiver's managed object context
 
 @details  The document's 'dupetainer' is the Container of Duplicate Groups.
 */
@property (retain, readonly) Dupetainer* dupetainer ;

- (void)clearTalderMapper ;

/*!
 @brief    Runs the window of a given alert as a modal sheet on the
 receiver's window controller's window and returns immediately.
 
 @details  This method is actually just a wrapper which sends 
 -runModalSheetOnWindow:resizeable:modalDelegate:didEndSelector:contextInfo:
 to the given alert.&nbsp; See SSYAlert documentation on that
 method for requirements on delegate and didEndSelector.
 
 You should obtain an alert by invoking [SSYAlert alert] and
 send it whatever messages are required to configure it.  Do not,
 however, send [alert display] because that will cause the alert
 to be displayed as a freestanding window, not attached to the
 receiver's document window as desired.
 
 @param    resizeable  Pass YES to make the sheet resizeable larger by the
 user.  Resizing smaller is is always disabled because SSYAlert is laid out
 by dooLayout to the minimum size.
 @param    resizeable  Pass YES to make the sheet resizeable larger by the
 user.  Resizing smaller is is always disabled because SSYAlert is laid out
 by dooLayout to the minimum workable size.
 @param iconStyle  The icon to be shown along the left edge of the
 sheet.&nbsp; SSYAlertIconInformational or SSYAlertIconCritical
 are recommended because a sheet looks weird with no icon.&nbsp; 
 Of course, the method could have been written with this argument,
 and the iconStyle set in the alert by the invoker, but it has
 been made a parameter to remind the programmer to set it.
 */
- (void)runModalSheetAlert:(SSYAlert*)alert
                resizeable:(BOOL)resizeable
                 iconStyle:(NSInteger)iconStyle
			 modalDelegate:(id)delegate
			didEndSelector:(SEL)didEndSelector
			   contextInfo:(void*)contextInfo ;

- (void)runModalSheetAlert:(SSYAlert *)alert
                resizeable:(BOOL)resizeable
                 iconStyle:(NSInteger)iconStyle
         completionHandler:(void(^)(NSModalResponse modalResponse))completionHandler;


- (void)runModalSheetWithMessage:(NSString*)message ;

/*!
 @brief    Displays an error, running as a modal sheet on the receiver's
 window.&nbsp; This method returns immediately.&nbsp; Control flows to the
 modal delegate's didEndSelector when the user clicks the button, unless
 these parameters are nil, then the sheet itself terminates the process.
*/
- (void)alertError:(NSError*)error_
	 modalDelegate:(id)delegate
	didEndSelector:(SEL)didEndSelector ;	

- (void)importLaInfo:(NSMutableDictionary*)info 
 grandDoneInvocation:(NSInvocation*)grandDoneInvocation ;

- (void)importPerInfo:(NSMutableDictionary*)info ;
- (void)exportPerInfo:(NSMutableDictionary*)info ;

/*!
 @brief    Presents a dialog sheet in which the user must approve exporting,
 invoking -exportWithAlert:info: if the user approves or
 pauseSyncers:alert: if the user declines
*/
- (void)exportIfPermittedInfo:(NSDictionary*)moreInfo ;

- (void)requestUserInstallExtensionWithPrompt:(NSString*)prompt
                            completionHandler:(void (^)(NSModalResponse modalResponse))completionHandler;

- (void)saveAndClearUndo ;


/*!
 @brief    Removes any syncers or quatches of documents which have a
 different UUID than this document, but the same path, or syncers
 with a UUID whose path cannot be resolved.

 @details It is possible that someone might trash and delete a new document
 that has active Syncers, then create a new document at the same path.  The
 old syncers will still be installed.  When they are triggered, Alias
 Manager will find and open the new document.  But, because Macster and
 Syncers are coupled by the document UUID, the user will not see these
 syncers in the Settings ▸ Syncers tab.  Furthermore, the user may well
 create new Syncers to do the same work as the old syncers, which will
 cause very ugly results.
*/
- (void)removeAnyGhostSyncers ;
	

/*!
 @brief    Examines the receiver's macster's Syncers, and syncs the Watch
objects in user defaults to  match their current configuration

 If in Worker or AppleScripted (presumably by Worker), this method is a no-op.
*/
- (BOOL)realizeSyncersToWatchesError_p:(NSError**)error_p ;

- (void)expandAllContentWork ;

- (void)postDupesDone ;
- (void)postDupesMaybeMore ;
- (void)postDupesMayContainVestiges ;
- (void)postSortDone ;
- (void)postSortMaybeNot ;
- (void)postVerifyDone ;
- (void)postVerifyMaybeNot ;
- (void)postTouchedStark:(Stark*)stark ;

#pragma mark * Status Tracking Inputs

- (void)tellVerifyStarted ;


#pragma mark * Status Tracking Outputs

-(BOOL)verificationDone ;
-(BOOL)canVerify ;
@property (assign) BOOL verifyInProgress ;
-(BOOL)canFixBroken ;
-(BOOL)canFixBrokenManual ;


- (BkmxDocWinCon*)bkmxDocWinCon ;
- (Chaker*)chaker ;
- (SSYProgressView*)progressView ;
- (Broker*)broker ;
	

#pragma mark * Document Commands

/*!
 @details  This was added on 2019-04-02 to try and fix the rare but annoying
 bug in which, after deleting some items, some of the remaining adjacent
 items will appear in the outline view as expandable items with no names.
 After some testing, I determined that:

 • The actual problem occurs *before* you delete the item, so doing a redo
 and then deleting the some items again, even though it looks like it
 reproduces the problem, in fact just re-shows the problem.  This is
 corroborated by the fact that if you close and re-open the document, the
 problem is no more.  It is due to a bad ContentProxy in the data source.

 • The actual problem is that after you delete child index N of parent Foo,
 (which is a ContentProxy item) its child N will continue to be the proxy of
 the deleted item, which itself now has children (I don't know how they got
 there) which have no stark.  It is these no-stark children which appear as
 the expandable items with no names.

 I was not able to understand more than that before I accidentally closed the
 document.  But from what I was able to understand, I think the solution may
 be to tell the data source when stuff has been deleted and recheck all
 proxies.  That is what this method does.
 */
- (void)noticeStarkDeletions;

- (void)clearBroker ;

/*!
 @brief    Returns whether or not the receiver's bookmarks may have
 become disoredered since the last time they were ordered, or YES
 if they have never been ordered.
*/
- (BOOL)needsSort ;

/*!
 @brief    Returns whether or not the receiver's bookmarks may have
 any duplicates which are not currently accounted for in its dupes database
 table.
 */
- (BOOL)needsDupeFind ;

/*!
 @brief    If sorting is necessary, sorts all of the receiver's starks,
 obeying sorting rules given in the receiver's shig.

 @details  Necessity is determined by comparing the timestamps
 lastSortDone and lastSortMaybeNot of the receiver's shig.
*/
- (void)sort ;

/*!
 @brief    This method reverts the document immediately and unconditionally,
 without regard to whether or not the document is dirty and without asking
 the user.
 
 @details  This method is invoked directly, by Worker only.
*/
- (BOOL)revertError_p:(NSError**)error_p ;

- (void)consolidateFolders ;

- (void)saveDocument ;

- (void)saveDocumentInfo:(NSMutableDictionary*)info;

/*!
 @brief    The final low-level method that invokes super's
 -saveDocument or -saveDocumentAs.
*/
- (void)saveDocumentFinalOpType:(NSSaveOperationType)saveOperation ;

- (void)saveDocumentOpType:(NSSaveOperationType)saveOperation ;

/*!
 @brief    Returns YES if in the main app, and if there is not a boolean key in
 standard user defaults whose name is SSYDontAutosaveKey and whose boolean
 value is YES; otherwise returns NO
 */
+ (BOOL)autosavesInPlace ;

- (void)reallyAutosaveWithCompletionHandler:(void (^)(NSError *errorOrNil))completionHandler ;

/*!
 @brief    If findDupes is necessary, finds duplicates among the receiver's starks,
 obeying the duplicate-finding rules given in the receiver's shig.
 
 @details  Necessity is determined by comparing the timestamps
 lastDupesDone and lastDupesMaybeMore of the receiver's shig.
 
 Works in another thread, after all pre-existing operations in the process'
 common operation queue have been completed.
*/
- (void)findDupes ;

- (void)deleteAllDupes ;

- (void)deleteAllContent ;

- (BOOL)finishGroupOfOperationsWithInfo:(NSDictionary*)info ;

/*!
 @brief    The current verify summary (statistics) for the receiver
*/
@property (retain) VerifySummary* verifySummary ;

/*!
 @brief    Calculates a new verify summary for the receiver
 and sets it into the verifySummary instance variable.
*/
- (void)refreshVerifySummary ;

- (void)updateVerifyResultsIfAnyAreShowing ;
- (void)showVerifyResults ;

- (void)verifyAll ;

- (void)verifyAllSince:(NSDate*)since
         plusAllFailed:(BOOL)plusAllFailed
		 waitUntilDone:(BOOL)waitUntilDone ;

- (void)showDupesReport;

- (void)showDupesReportAsAgentWithInfo:(NSDictionary*)info;

- (void)updateViews:(NSNotification*)note ;


#pragma mark * Other Methods

- (void)refreshHasHartainersCache ;

- (void)changeStringInTagWhichHasString:(NSString*)oldString
                               toString:(NSString*)newString;

/*!
 @brief    Returns whether or not valid license information is found
 in the app's user defaults or in the receiver's metadata

 @param    error_p  If not NULL and if returning NO,
           will point to an error object encapsulating the error.
 @result   YES if valid license information is found in the app's
 user defaults or in the receiver's metadata, otherwise NO
*/
- (BOOL)checkBreathError_p:(NSError**)error_p ;


/*!
 @brief    Returns an array of NSNumbers representing the Sharypes of
 the hartainers which the receiver "has", in the sense of the-hasXxx
 attributes.
 */
- (NSArray*)availableHartainers ;

/*!
 @brief    Displays (selects) a given tab view item in the
 receiver's window's tab view hierarchy
 
 @details  This method simply forwards the message to the
 receiver's window controller.
 @param    identifier  The identifier of the last tab view
 item in the lineage of the tab view item to be displayed.
 May be nil if only the top tab is desired to be selected.
 @result   YES if the given identifier is valid, otherwise NO.
 */
- (BOOL)revealTabViewIdentifier:(NSString*)identifier ;

- (BOOL)canBeAtRootSharype:(Sharype)sharype ;

/*!
 @brief    Returns the receiver's default parent for a given Sharype.

 @details  When receiver is a BkmxDoc, may return nil momentarily
 as client(s) are being removed or changed.
*/
- (Stark*)fosterParentForSharype:(Sharype)sharype ;

/*!
 @brief    Returns the preferred foster parent for a given
 stark, by examining its Sharype value.
 
 @details  When receiver is a BkmxDoc, may return SharypeDefault
 momentarily as client(s) are being removed or changed.
 */
- (Stark*)fosterParentForStark:(Stark*)stark ;

/*!
 @brief    Returns an array of all the receiver's hartainers and softainer,
 including the root stark if it can accept bookmarks (SharypeCoarseLeaf),
 in the order in which they would appear in an outline view.
 */
- (NSArray*)bookmarkContainers ;

/*!
 @brief    Creates a new bookmark with attributes from a given
 dictionary, located at index 0 in the receiver's shig's
 landing, and selects it.
 
 @result   The new bookmark
*/
- (Stark*)landNewBookmarkSaveWithInfo:(NSDictionary*)info ;

- (NSString*)descriptionForKeyPath:(NSString*)keyPath
						displayKey:(NSString*)displayKey ;

- (NSArray*)selectedStarks ;

/*!
 @details  Because this document can be run in a GUI-less tool, the File's
 Owner of the nib is the window controller instead of the document, as in a
 normal document-based app.  So we need to make the window explicitly
 when a new document is created (initWithType:) or read from a file or
 reverted from a file (readFromURL:::).  Again, remember that when
 NSPersistentDocument reverts, unlike NSDocument, it destroys any
 windows.  What about BSManagedDocument????
 */
- (void)makeWindowControllers ;

/*!
 @brief    Returns the last object in the receiver's selectedStarks,
 or nil if selectedStarks is empty.
 */
- (Stark*)selectedStark ;

- (void)expandRootChildren:(BOOL)expandNotCollapse ;

- (void)setFreshUuid ;

- (void)saveDocumentActionPart2OpType:(NSSaveOperationType)saveOperation ;

/*!
 @brief    Sets and undo action name for the current group and registers
 an undo action to restore the currently-displayed tab view, unless
 the input parameters indicate that this should be a "hidden" action.
 
 @details  There are times when the input parameters will be such
 that no undo action name will be set, and that is what you want,
 for the action to be "hidden".
 @param    action  The type of action which was performed
 @param    object  The object that was inserted, moved, modified, or
 removed.  This parameter is only read if it is an instance of Stark,
 or if the action is SSYModelChangeActionModify or SSYModelChangeActionSort; otherwise it is ignored.
 If not ignored, its name is used in the undo action name.  In
 the latter case, it is used to shorten the search which must be done
 to determine a localized version of the updatedKey, and is sometimes used in the
 undo action to give a better description, appending the type of the object
 that was modified instead of just the name of the attribute that was modified.
 @param    objectKey  The name of the to-many relationship which was
 changed if the action is SSYModelChangeActionInsert, SSYModelChangeActionMove,
 SSYModelChangeActionReplace, or SSYModelChangeActionRemove, and if the object
 parameter is nil or not recognized.  If the action is SSYModelChangeActionModify or the object
 parameter is recognized, this parameter is ignored.
 @param    updatedKey  The key of the attribute whose value(s) were changed.
 This parameter is only read if the action is SSYModelChangeActionModify.
 It will be localized to become the main part of the undo action.  Examples:
 "Change Name", "Change Address".
 @param    count  A count of the items changed.  This parameter is only read if
 the combination of the other parameters is not sufficient to determine a
 localized description of the items changed, and only if it is > 0.  If you 
 don't know the count, pass 0 to be safe.  If it is used, an undo action such
 as "Insert 5 items", "Change 5 items", etc. will be set.
 */
- (void)setUndoActionNameForAction:(SSYModelChangeAction)action
							object:(id)object
						 objectKey:(NSString*)objectKey
						updatedKey:(NSString*)key 
							 count:(NSInteger)count ; 	

/*!
 @brief    Returns whether or not there is valid License Information
 stored in the receiver's store's metadata.

 @details  "metal" = "metadata-stored license information"
*/
- (BOOL)metalValid ;

/*!
 @brief    Acts appropriately to implement Auto Export and/or Resume Syncing
 when a document is about to be closed
 
 @details  Action is described by this table…
 *  Case   syncPaused  autoExport   do
 *  ----   ----------  ----------   --
 *    0      0              0       returns NO.
 *    1      0              1       returns YES.
 *                                  Ask user if should export.
 *                                  Maybe export.
 *                                  Close document.
 *    2      1              0       returns YES.
 *                                  Ask user if syncing should be resumed.
 *                                  If user replies 'Resume', do so with approval
 *                                  Close document.
 *    3      1              1       returns YES.
 *                                  Ask user if syncing should be resumed.
 *                                  If user replies 'Resume', do so, exporting with approval
 *                                  (which will cover the autoExport requirement).
 *                                  If user replies to 'Remove' syncers, remove syncers
 *                                  then ask if should export.
 *                                  Close document.If Auto Export should not be done for this document at this time, or
 
 @result   YES if this method will handle closing, NO if it is OK for the
 invoker to close the document
*/
- (BOOL)prepareToClose ;

- (void)                   doSort:(BOOL)doSort
    thenExportIfPermittedWithInfo:(NSDictionary*)info ;

- (void)closeAndTrash ;

- (void)closeAfterAskAutoExport:(BOOL)autoExport ;

/*!
 @brief    Creates a new thisUser client for a given exformat in
 the receiver's Macster
 
 @details  Saves the receiver's managed object context when done
 */
- (void)makeNewLocalClientWithExformat:(NSString*)exformat
                           profileName:(NSString*)profileName ;

/*!
 @brief    Deletes all clients in the receiver's Macster

 @details  Saves the receiver's managed object context when done
*/
- (void)deleteAllClients ;

/*
 successfulIxporters is only used for imports.  It
 could be used for exports if there was a need.
*/
- (void)clearSuccessfulIxporters  ;
- (void)addSuccessfulIxporter:(Ixporter*)ixporter ;
- (NSArray*)successfulIxporters ;
	
/*!
 @brief    Configuring a new document, Step 1
 */
- (void)configureNewAskingForClients:(BOOL)askForClients ;

/*!
 @brief    Configuring a new document, Step 2
 
 @details  Assumes that desired clients have been added to the
 receiver's macster.
 */
- (void)configureNewAfterClients ;

- (void)showVerifyReport ;

- (void)didEndCloseAndDeleteSheet:(NSWindow*)sheet
					   returnCode:(NSInteger)returnCode
					  contextInfo:(void*)notUsed ;

- (void)saveMacster ;

/*!
 @brief    Returns a localized string,
 "Bookmarks Bar", in English
 */
- (NSString*)labelBar ;

/*!
 @brief    Returns a localized string,
 "Bookmarks Menu", in English
 */
- (NSString*)labelMenu ;

/*!
 @brief    Returns a localized string,
 "Unsorted Bookmarks", in English
 */
- (NSString*)labelUnfiled ;

/*!
 @brief    Returns a localized string,
 "My Shared (in OmniWeb) Bookmarks", in all languages
 */
- (NSString*)labelOhared ;

- (NSString*)displayNameForHartainer:(NSNumber*)hartainer ;

/*
 @details This method was added in BookMacster 1.17 to fix this issue.
 
 Say that user is syncing via Dropbox, with BkmxTriggerCloud, on two Macs A, B.
 Some changes are saved on Mac A.  During -[BkmxDoc
 writeSafelyToURL:ofType:forSaveOperation:error:, a lastSaveToken is created and
 saved in the document's metadata, also in the user defaults.  The document
 gets pushed and pulled by Dropbox to Mac B, and BookMacster on Mac B exports
 to its clients.  Now, let's say that Dropbox decides to "hit" the document for
 some reason.  This will launch a Worker on Mac A into Case 16 which will find
 that the lastSaveToken in the document's metadata matches the lastSaveToken
 in the User Defaults, and it will end with an early exit, ignoring the
 spurious hit as desired.  But that will not work on Mac B, because Mac B
 has an earlier lastSaveToken in its User Defaults.
 
 Obviously, the solution to the problem is for Mac B to update the token in
 its User Defaults during the first round when it imported the changes and
 exported to its Clients.  But when should that be done?  Immediately upon
 reading, or later after the exports had concluded without error?  I tried to
 so it immediately upon reading, in -readFromURL:ofType:error:, but whoops that
 led to a race condition if a document in Dropbox happened to be open when a
 *real* hit, that is, document was actually updated, in Dropbox.  In this
 case, two things happen, independently:
 
 (1) The document closes and re-opens, due to the action of
       -{BkmxDoc presentedSubitemDidChangeAtURL:]
 (2) The kqueue underlying BkmxTriggerCloud triggers a Worker.
 
 Assume (1) happens before (2).  The token will be updated in User Defaults.
 Then when the launched Worker examines the token and compares with User
 Defaults, it finds them to be the same, assumes this was a false hit, and
 does not schedule a job.
 
 So, we need to do this, instead, as part of the Export-Grande operation,
 to be sure that the new data was actually imported, processed, and exported
 to Clients.
 */
- (void)setInUserDefaultsLastSaveToken:(NSString*)token;

- (void)checkAndReportExtension1Status ;

- (void)alertSyncingStillPaused:(NSArray*)browser ;

- (void)warnCantSyncNoClients ;

- (void)configureNewShoebox ;

/*!
 @details  I've had good luck using this method to fix bugs found when some
 major en masse change in the document is found to make the Content Outline
 incorrect due to proxies being screwed up.  Just invoke it after the en masse
 change and voila!
 */
- (void)checkAllProxies:(NSNotification*)noteNotUsed;

/*!
 @brief   For each stark in the receiver, sets the stark's lastModifiedDate
 to the current data if there are any uncommitted changes in the receiver's
 properties.  This method should be called from three places:
 
 1.  At the end of any manual editing operation.  Technically, we catch this
 as any undo grouping is about to end.  Note that this will result in a new
 lastModifiedDate value if a property value is changed in one manual editing
 operation and then changed back a minute later in a subsequent manual editing
 operation.  This should be regarded as expected behavior.  To "cancel" the
 lastModifiedDate change in this case, as we attempted to do prior to
 BkmkMgrs 2.10.23, is problematic and our implementation did not  work in
 all cases.
 
 2.  At the end of any ixport operation.  Note that, in this case, we ignore
 changes which were cancelled out in another part of the same ixport operation.
 For example, say you Export to a client for which some items are not
 exportable.  Say that nonexportable item NE has siblings below it (higher
 index number).  Then do an import.  During the Import, the siblings below this
 NE will get an index number of one lower, to reflect their index in the
 client, in which item NE does not exist.  But during the Connect
 Families phase, the siblings index will be set back up higher.  By calling
 this method only at the end of the entire operation, the lastModifiedDate
 is not set by either of these two cancelling changes.
 
 3.  As part of preparing for any Save operation.  I think this may be
 redundant, since all changes will cause one of the first two calls.  But I am
 not sure, so we continue to call prior to saves as we did prior to
 BkmkMgrs 2.10.23.
 */
- (NSInteger)finalizeStarksLastModifiedDates ;

@end

