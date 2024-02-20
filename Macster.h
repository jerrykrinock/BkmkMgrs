#import <Cocoa/Cocoa.h>
#import "BkmxGlobals.h"
#import "SSYManagedObject.h"
#import "StarkTyper.h"

@class BkmxDoc ;
@class Ixporter ;
@class Syncer ;
@class Extore ;
@class SSYMojo ;
@class Stark ;
@class Client ;
@class Trigger ;
@class SSYAlert ;
@class ClientChoice ;

extern NSString* const constKeyClientsDummyForKVO ;

extern NSString* const constKeyAutosaveUponClose ;
extern NSString* const constKeyDeleteUnmatchedMxtr ;
extern NSString* const constKeyDaysDiary ;
extern NSString* const constKeyAutoExport ;
extern NSString* const constKeyDoFindDupesAfterOpen ;
extern NSString* const constKeyAutoImport ;
extern NSString* const constKeyDoSortAfterOpen ;
extern NSString* const constKeySafeLimitImport ;

extern NSString* const constKeySyncerConfig ;
extern NSString* const constKeySyncers ;
extern NSString* const constKeyClients ;
extern NSString* const constKeyCommands ;

@interface Macster : SSYManagedObject {
	BkmxDoc* m_bkmxDoc ;
	BOOL m_syncersDummyForKVO ;
	BOOL m_clientsDummyForKVO ;
	
	BOOL m_clientTouchedAll ;
	NSInteger m_clientTouchSeverity ;
	NSInteger m_syncerTouchSeverity ;
	NSInteger m_macsterTouchSeverity ;
	BOOL m_syncerTouchedAll ;
    BOOL m_delayedExportWarningIsPending ;
	
	long long m_syncerPausedConfig ;
	// I could use m_syncerPausedConfig != 0, but for KVObservability I need this…
	BOOL m_syncersPaused ;
    NSTimer* m_badTriggerSayer ;
}

@property (assign) NSInteger clientTouchSeverity ;
@property BOOL syncersDummyForKVO ;
@property BOOL syncersPaused ;

/*!
 @brief    An NSArray indicating the order in which unmappable
 items not abled to be mapped into the receiver's preferredCatchype
 should be attempted to be mapped.
 
 @details  Presently, the setter for this variable is never used
 and therefore the getter returns nil.  Invoker
 should defer to the same value in User Defaults when it gets nil.
 */
@property (retain) NSArray* anyStarkCatchypeOrder ;

@property BOOL clientsDummyForKVO ;

/*!
 @brief    A number whose boolean value indicates whether or not
 the normal macOS behavior when attempting to close a dirty
 document, displaying a dialog with Cancel, Save, Don't Save,
 is altered so that a dirty document is saved automatically and
 then closed
 */
@property (retain) NSNumber* autosaveUponClose ;

/*!
 @brief    A number whose bool value indicates whether or not the
 receiver performs a Delete Unmatched Items during Import of the first
 client in its importers ordered
 */
@property (retain) NSNumber* deleteUnmatchedMxtr ;

/*!
 @brief    A number whose value indicates the number of days
 that the receiver keeps it diary before discarding old
 entries
 
 @details  If 0, then no diary entries are ever kept
 */
@property (retain) NSNumber* daysDiary ;

/*!
 @brief    Indicates whether or not the receiver's 
 document should automatically find dupes whenever
 it is opened.
 */
@property (retain) NSNumber* doFindDupesAfterOpen ;

/*!
 @brief    Indicates whether or not the receiver's 
 document should automatically open whenever this
 (main, GUI) application is launched.
 */
@property (retain) NSNumber* doSortAfterOpen ;

/*!
 @brief    Indicates whether or not the receiver's 
 document should automatically sort its contents
 whenever it is opened.
 */
@property (retain) NSNumber* autoImport ;

/*!
 @brief    Indicates whether or not the receiver's 
 document should automatically perform export before
 it is saved.
 */
@property (retain) NSNumber* autoExport ;

/*!
 @brief    A number with sharypeValue equal to the sharype of the
 hartainer in which the user prefers unmappable items to be placed,
 regardless of whether or not this hartainer is available in the
 receiver.
 */
@property (retain) NSNumber* preferredCatchype ;

@property (retain) NSNumber* safeLimitImport ;

@property (retain) BkmxDoc* bkmxDoc ;

/*!
 @brief    Posts the constNoteBkmxSyncerDidChange notification
 @param    syncer  The syncer which was touched, or nil to 
 indicate that all syncers were touched or that it is not
 known which syncer(s) were touched
 */
- (void)postTouchedSyncer:(Syncer*)syncer
                 severity:(NSInteger)severity ;

/*!
 @brief    Posts the constNoteBkmxClientDidChange notification

 @details  Declared here so that Clients and Ixporters may
 invoke this when they change their properties.
 
 @param    syncer  The syncer which was touched, or nil to
 indicate that all syncers were touched or that it is not
 known which syncer(s) were touched
 @param    severity  Roughly indicate what was touched, according
 to the following scale:

 1
 unexportedDeletions
 failedLastExport
 
 3
 index
 safeLimit
 specialOptions
 preferredCatchype
 
 4
 any ixporter properties
 
 5
 exformat
 extorageAlias
 extoreMedia
 profileName
 profileNameAlternate
 
 7
 add or remove client(s)
*/
- (void)postTouchedClient:(Client*)clent
				 severity:(NSInteger)severity ;

/*!
 @brief    A number, the bits of whose 64-bit value indicate
 one or more of the constBkmxSyncerConfig constants.
 */
@property (retain) NSNumber* syncerConfig ;

/*!
 @brief    Returns the value of the receiver's syncerConfig attribute
 */
- (long long)syncerConfigValue ;
 
/*!
 @brief    An ordered set of the  Syncers currently assigned in the receiver
 
 @details  The set may be ordered by the -index attributes of its members.
 Ordering is only necessary in this case to give the user a consistent
 table display.
 */
@property (retain) NSSet* syncers ;

@property (retain) NSSet* clients ;

/*!
 @brief    Removes old and sets new objects into the receiver's syncers
 set, conferring order by setting the -index of each object in the array
 
 @details  Triggers KVO notifications.
 @param    newObjects  The array of new objects, each of which
 must conform to the SSYIndexee protocol, i.e., have an 'index' property.
 */
- (void)setSyncersOrdered:(NSArray*)newObjects ;

- (void)removeSyncers:(NSSet*)value ;

- (NSArray*)clientsOrdered ;

- (NSString*)truncatedListOrPlaceholderForClients:(NSArray*)clients
									maxCharacters:(NSUInteger)maxCharacters ;

/*!
 @brief    Returns a list of clients with a given activeness, for
 example, "Safari, Chrome [and] Firefox"

 @param    selector  If @selector(importer), returns a list of clients
 whose importer is active.  If @selector(importer), returns a list of
 clients whose importer is active.  If NULL, returns a list of clients
 whose either importer or exporter is active.
 @param    onlyIfVulnerable  If YES, and if 'selector' is @selector(exporter) or
 NULL, only clients whose exporter's deleteUnmatched property is YES will appear
 in the result.  If NO, no such filtering is done.
 @param    maxCharacters  Same effect as 'maxCharacters' in method
 -readableExportsListOnlyIfVulnerable::.
*/
- (NSString*)clientListForSelector:(SEL)selector
                  onlyIfVulnerable:(BOOL)onlyIfVulnerable
					 maxCharacters:(NSUInteger)maxCharacters ;

/*!
 @brief    Returns a sub-array of the receiver's clients which have either
 an active importer, active exporter or both
*/
- (NSArray*)activeClients ;

- (NSArray*)clientsWithIxportBothActive ;

/*!
 @brief    Returns the receiver's client which matches a given clidentifier,
 or nil if no such client exists in the receiver
*/
- (Client*)clientForClidentifier:(NSString*)clidentifier ;

/*!
 @brief    Returns a set containing any of the receiver's client which
 match a given extore.
 
 @details  Returns an empty set if no such client exists in the receiver
 */
- (NSSet*)clientsForExformat:(NSString*)exformat ;

/*!
 @brief    Returns the subset of the receiver's clients whose
 extore media is constBkmxExtoreMediaThisUser
 */
- (NSSet*)thisUserClients ;

/*!
 @brief    Returns the subset of the receiver's clients whose
 extore's ownerAppIsLocalApp
 */
- (NSSet*)thisUserLocalClients ;

/*!
 @brief    Returns an array of the receiver's syncers objects,
 sorted ascending by their 'index'.
 @result   The sorted array.
 */
- (NSArray*)syncersOrdered ;

- (void)deleteClient:(Client*)client ;

- (void)deleteAllClients ;

- (void)deleteAllSyncers ;

/*!
 @brief    Returns the syncer at the given index, or nil if the
 index is out of range.
 */
- (Syncer*)syncerAtIndex:(NSInteger)index ;

/*!
 @brief    Returns a new Ixporter, inserted at a given index, or at as
 low an index as possible, in the receiver's importers,
 in the receiver's managed object context.
 
 @details  If inserting the new Ixporter in the receiver's 
 importers would create a gap in the sequence of their
 indexes, the index is reduced to a value which would close the gap.
 @param    index  The desired index of the new Ixtnernalizer, or
 NSNotFound to use the next index.
 
 The array controller in the nib does not use this method.
 
 @result   The new Ixporter
 - (Ixporter*)addImporterAtIndex:(NSInteger)index ;
 */

/*!
 @brief    Creates a new thisUser client for a given exformat

 @details  Saves the receiver's managed object context when done
*/
- (void)makeNewLocalClientWithExformat:(NSString*)exformat
                           profileName:(NSString*)profileName ;

/*!
 @brief    Returns a new Client, inserted at a given index, or at as
 low an index as possible, in the receiver's syncers,
 into the receiver's managed object context.
 
 @details  The returned Client object has an importer and exporter,
 and both of their isActive are set to the model default value of YES.
 @param    index  The desired index of the new Client, or NSNotFound
 to insert it at the end
 @param    singleUse  Pass YES if this client is to be for a single use and
 therefore would not affect syncing.  Pass NO to indicate that this is a
 permanent client and, for example, the "Sync Status has changed" warning
 should be shown to the user.
 @result   The new Client
 */
- (Client*)freshClientAtIndex:(NSInteger)index
                    singleUse:(BOOL)singleUse ;

- (void)removeClientsObject:(Client*)value ;

/*!
 @brief    Returns a new Syncer, inserted at a given index, or at as
 low an index as possible, in the receiver's syncers,
 into the receiver's managed object context.
 
 @details  If inserting the new Syncer in the receiver's 
 exporters would create a gap in the sequence of their
 indexes, the index is reduced to a value which would close the gap.
 @param    index  The desired index of the new Syncer, or NSNotFound
 to insert it at the end
 @result   The new Syncer
 */
- (Syncer*)freshSyncerAtIndex:(NSInteger)index ;

// The following two methods work but are not needed, since
// the array controllers in the nib know how to do this.
///*!
// @brief    Action which invokes newImporterAtIndex:NSNotFound,
// to create a new importer at the end, but does not return it.
//*/
//- (IBAction)addNewImporter ;

///*!
// @brief    Action which invokes newExporterAtIndex:NSNotFound,
// to create a new exporter at the end, but does not return it.
// */
//- (IBAction)addNewExporter ;

/*!
 @brief    Action which invokes freshSyncerAtIndex:NSNotFound,
 to create a new syncer at the end, but does not return it.
 */
- (IBAction)addNewSyncer ;

/*!
 @brief    Unblinds any trigger in the receiver's managed object
 context which has a blinder key in a given set
*/
- (BOOL)unblindTriggersWithKeys:(NSSet*)triggerBlinderKeys
                        error_p:(NSError**)error_p ;

/*!
 @brief    Returns an array of importers which are active in the
 receiver's clients, ordered per the indexes of their owning clients.
 */
- (NSArray*)activeImportersOrdered ;

/*!
 @brief    Returns an array of exporters which are active in the
 receiver's clients, ordered per the indexes of their owning clients.
 */
- (NSArray*)activeExportersOrdered ;

/*!
 @brief    An set of the export operations which should be
 executed when the receiver performs a Export.
 
 @details  Calculated on the fly by filtering the receiver's
 clients and returning their importers.
 */
- (NSSet*)importers ;

/*!
 @brief    An set of the import operations which should be
 executed when the receiver performs a Import.
 
 @details  Calculated on the fly by filtering the receiver's
 clients and returning their importers.
 */
- (NSSet*)exporters ;

- (NSString*)readableImportsList ;

/*!
 @brief    Returns a human-readable list of the display names of
 all of the receiver's clients whose exporters are active

 @param    onlyIfVulnerable  If YES, only clients whose exporter's
 deleteUnmatched property is YES will appear in the result.  If NO, no such
 filtering is done.
 @param    maxCharacters  Limit to which the output is nicely truncated in
 the middle.  Also, if this value is > 100, the last client in the list
 is preceded by the conjunction "and".
 @result   
*/
- (NSString*)readableExportsListOnlyIfVulnerable:(BOOL)onlyIfVulnerable
                                   maxCharacters:(NSUInteger)maxCharacters ;

- (NSString*)docUuid ;

- (NSInteger)removeOrphanedObjectsOfClass:(Class)class ;

- (void)fixDeferencelessIECommands ;

/*!
 @details  The value of syncerPausedConfig uses the constBkmxSyncerConfig, interpreted as follows
 
 • constBkmxSyncerConfigNone         Syncing is not paused.
 • constBkmxSyncerConfigIsAdvanced   Syncing has been paused by setting isActive to NO in
 -                                  all of the receiver's (advanced) Syncers.  To resume,
 -                                  set isActive to YES in all of the receiver's Syncers.
 • all other states                 Syncing has been paused by setting syncerConfig from
 -                                  this state to constBkmxSyncerConfigNone.  To resume,
 -                                  set syncerConfig back to this state.
 */
@property (assign) long long syncerPausedConfig ;

- (BOOL)fixTriggersIfSimpleSyncers;

- (void)syncSyncersFromSyncingConfig ;

/*!
 @brief    Returns whether or not the receiver has a
 thisUser AND *local* extore.
 
 @details  Someday, I will split thisUser into two separate
 types: thisUser (local) and webApp.  Then the name
 will be self-explanatory
 */
- (BOOL)hasAThisUserActiveImportClient ;

/*!
 @brief    Returns YES is any of the receiver's Clients have
 extoreMedia = constBkmxExtoreMediaThisUser, ownerApp is a
 local app, and has observability != OwnerAppObservabilityNone.
*/
- (BOOL)hasAnImportClientWithObserveableBookmarksChanges ;

- (ClientChoice*)nextLikelyClientChoice ;

- (IBAction)insertNextLikelyClient:(id)sender ;

- (void)setSyncerConfigImportChanges:(BOOL)yn ;

- (void)setSyncerConfigSort:(BOOL)yn ;

- (void)setSyncerConfigExportToClients:(BOOL)yn ;

- (void)setSyncerConfigExportCloud:(BOOL)yn ;

- (void)setSyncerConfigExportLanding:(BOOL)yn ;

- (void)syncersSetExpertise:(BOOL)detailed ;

- (void)setSyncerConfigActiveValueNone ;

- (void)setSyncerConfigFullSync ;

- (long long)syncerConfigActiveValue ;

- (void)toggleSync ;

/*!
 @param    includeNonClientable  Include choices which are not allowed as clients
 but are allowed in manual import/exports using "Import from only" or "Export to
 only".
 */
- (NSArray*)availableClientChoicesAlwaysIncludeChooseFile:(BOOL)includeChooseFile
                                           includeWebApps:(BOOL)includeWebApps
                                      includeNonClientable:(BOOL)includeNonClientable ;

/*!
 @brief    Returns YES if the receiver has at least one syncer which will
 import and/or export assuming that it is active or not paused

 @details  This method does not consider whether or not there are clients
 with active importers or exporters.  It only worries about syncers.
 @param    doQualifyExport  This defines the meaning of "import and/or export".
 If NO, only syncers that import are qualified.  If YES, syncers that
 import, syncers that export, and syncers that do both are all qualified.
*/
- (BOOL)aSyncerWouldIxportIfActivatedOrResumedDoQualifyExport:(BOOL)doQualifyExport ;

- (void)pauseSyncers ;

- (NSString*)pauseSyncersAndAppendToMessage:(NSString*)message ;

/*!
 @brief    Sets constKeyDontWarnExport in user defaults from the state of the
 checkbox in a given alert, possibly pauses the receiver's syncers and sets the
 property syncerPausedConfig */
- (void)pauseSyncers:(BOOL)pauseSyncers
			  alert:(SSYAlert*)alert ;

- (uint32_t)importSettingsHash ;

/*!
 @brief    Returns a Trigger object given its uri

 @param    triggerUri  The permanent URI of either a Syncer or
 a Trigger in the receiver's context
 @param    agent_p  If not NULL, upon return, will point to the Agent
 represented by the given URI, or the Syncer of the Trigger represented
 by the given URI, or nil if an error occurs which causes this method
 to return NO.  In other words, if this method returns YES, *agent_p
 will point to a good syncer and will not be nil.
 @param    trigger_p  If not NULL, upon return, will point to the
 Trigger represented by the given URI, or nil if the given URI represents
 a Syncer.
 @param    error_p  If not NULL, and if result is NO, will point to
 a short string explaining which problem occurred.
 @result   The target Trigger object, or nil if any of the following occurs:
 • Given uri is nil
 • Given uri does not represent a Trigger in the receiver
 • Given uri represents a Trigger which is not available
 */
- (Trigger*)triggerWithUri:(NSString*)triggerUri
                   error_p:(NSError**)error_p ;
/*!
 @brief    Saves the receiver's moc immediately

 @details  Ordinarily, you should post a notification such as
 constNoteBkmxClientDidChange or constNoteBkmxSyncerDidChange,
 maybe taking advantage of coalescing, instead of using this method.
*/
- (void)save ;

- (NSArray*)folderMappings ;
- (NSArray*)tagMappings ;

- (BOOL)isPoisedToSync;

/*
 @details  The signature of this method was changed in BookMacster 1.19.2 from
 -resumeSyncersThenAutoExport:(BOOL)autoExport, because it didn't and doesn't do
 what that name said it did.  That is, it did not auto export.  The autoExport
 parameter was ignored.
 */
- (void)resumeSyncers ;

/*
 @details  In Smarky or Synkmark, during both initial document creation
 (-awakeFromInsert) and document opening (-awakeFromFetch), we check that all
 of the the three simple syncer configurations are ON.  If not, we activate them,
 but Pause syncing.  Syncing must always be started or resumed by the user's
 manually clicking the command.
 
 
 @param    doAlert  YES if you want this method to alert the user if syncers were
 created and paused.
 @result   YES if syncers were fixed and paused, NO if nothing was done because
 auto syncers are currently active.
 */
- (BOOL)ensureAutoSyncersExistDoAlert:(BOOL)doAlert ;

- (void)updateAllClientsCompositeImportSettingsHashesInUserDefaults;

- (void)warnSyncingAffectedAfterDelay ;

- (void)ensureAutoSyncersExistAfterDelay;

@end

/*
 Note 290293.  Summary: "delete" does more than just "remove"!
 On 20110606, BookMacster 1.5.7, I learned that that
 the Core Data accessors remove<Foos>object: and remove<Foos>: do
 *not* delete the object; they just remove it from the relationship.
 Because I didn't know this, I found that Collections
 are full of orphan Clients, Syncers, Commands and Triggers.  To
 emphasize the difference between *removing* and *deleting*, besides
 fixing the implementations, I renamed the following methods:
 
 removeClient:  -->  deleteClient:
 removeTrigger:  -->  deleteTrigger: (*)
 removeCommand:  -->  deleteCommand: (*)
 removeAllClients  -->  deleteAllClients
 removeAllSyncers  -->  deleteAllSyncers
 removeAllCommands  -->  deleteAllCommands
 removeAllTriggers  -->  deleteAllTriggers
 
 (*) Actually, the original method did not exist at the time.
 I created the new method and used it where I had been using
 remove<Foos>Object:, which was not deleting as desired.
*/
