#import <Cocoa/Cocoa.h>
#import "BkmxBasis.h"

@class Watch;
@class Client;
@class Clientoid;
@class Trigger;
@class Job;

@interface NSUserDefaults (Bkmx)

/*!
 @brief    Returns all of the receiver's watches.
*/
- (NSSet <Watch*>*)watchesThisApp;

/*!
 @brief    Returns the current set of watches for a given app, or all three
 apps (BookMacster, Synkmark, Smarky)
 */
- (NSSet <Watch*>*)watchesForApps:(BkmxWhichApps)whichApps;

- (NSArray <Watch*>*)humanSortedWatchesForApps:(BkmxWhichApps)whichApps;

- (void)mutateWatchesAdditions:(NSSet <Watch*>*)additions
                     deletions:(NSSet <Watch*>*)deletions;

- (NSDictionary*)stagedJobArchivesForApps:(BkmxWhichApps)whichApp;

- (NSArray<Job*>*)stagedJobsForApps:(BkmxWhichApps)whichApps;

/*!
 @brief    Returns all document uuids listed as a document uuid in any of the
 receiver's watches for the a given app.
 */
- (NSMutableSet*)uuidsOfDocsWithWatchesInApps:(BkmxWhichApps)whichApps;

/*!
 @brief    Returns all document uuids listed as a document uuid in any of the
 receiver's watches for the currently-running app
 */
- (NSMutableSet*)uuidsOfDocsWithWatchesInThisApp ;

/*!
 @brief    In the receiver's watches, removes any references to a
 given document uuid, and also removes any watches which have no
 document uuids as a result of this, and if there are no document uuids
 with watches, removes the BkmxAgent
*/
- (BOOL)removeWatchesForDocumentUuid:(NSString*)documentUuid ;

- (void)removeAllWatchesExceptDocUuid:(NSString*)docUuid;

- (void)removeAllSyncingExceptDocUuid:(NSString*)docUuid;
/*!
 @brief    Removes all mention of a given document uuid from 
 user defaults.

 @details  Removes related (1) watches, (2) alias records,
 (3) autosave values and (4) recent document display names
 @param    documentUuid  The uuid to be purged.
*/
- (void)forgetDocumentUuid:(NSString*)documentUuid ;

/*!
 @details  Iterates through the receiver's watches, finds all
 of the referenced document uuids, also iterates through the
 receiver's docAliases.&nbsp;  For any document found to have a
 "Bad alias" (see below), tells the app to completely forget
 the document by doing four things:
 <ul>
 <li>Sends -removeWatchesForDocumentUuid: to standardUserDefaults</li>
 <li>Sends -[BkmxBasis removeMacsterForUuid:] to the sharedBasis</li>
 <li>Sends +[BkmxAppDel removeSyncersForDocumentUuid:]</li>
 <li>Sends -forgetRecentDocumentUrl: to the shared NSDocumentController</li>
 <li>Removes defunctDocumentUuid from constKeyDocRecentDisplayNames in standardUserDefaults</li>
 </ul>
 
 
 Bad aliases means: Either no alias in the docAliases
 dictionary, an unresolvable alias, or an alias that resolves
 to a path which is in the user's Trash.&nbsp;  Returns
 immeidately and runs in a new thread since resolving aliases
 can take a long time.
 
 Then, after the watches in user defaults are thus updated
 invokes addQuatchRunnerOrElseKillQuatchAsRequiredError_p
 on the main thread and presents any error which occurs in the
 application's shared SSYAlert.
*/
- (void)forgetDefunctDocumentsWithWatchesAndEnDisableBkmxAgent ;

- (NSDate*)recentQuitForAppIdentifier:(NSString*)bundleIdentifier;
- (void)setRecentQuitToNowForAppIdentifier:(NSString*)bundleIdentifier;

- (NSDate*)lastChangeWrittenDateToClientoid:(Clientoid*)clientoid ;

- (void)setLastChangeWrittenDate:(NSDate*)date
						toClient:(Client*)client ;

/*!
 @brief    Hash of the last (imported content + import options)
 imported from a given Clientoid
 */
- (NSNumber*)lastImportPreHashForClientoid:(Clientoid*)clientoid;
- (void)setLastImportPreHash:(NSNumber*)hash
                clidentifier:(NSString*)clidentifier;

/*!
 @brief    Hash of the last source and destination contents (payload) and
 import/export settings after merging in last ixport for a given Clientoid

 @details  This attribute is currently not used.  Its counterpart in
 Exporter is used.
 */
- (NSNumber*)lastImportPostHashForClientoid:(Clientoid*)clientoid;
- (void)setLastImportPostHash:(NSNumber*)hash
                 clidentifier:(NSString*)clidentifier;
/*!
 @brief    Hash of the last source and destination contents (payload) and
 import/export settings prior to merging in the last ixport with the receiver
 */
- (NSNumber*)lastExportPreHashForClientoid:(Clientoid*)clientoid;
- (void)setLastExportPreHash:(NSNumber*)hash
                clidentifier:(NSString*)clidentifier;

/*!
 @brief    Hash of the last source and destination contents (payload) and
 import/export settings after merging in last ixport with the receiver
 */
- (NSNumber*)lastExportPostHashForClientoid:(Clientoid*)clientoid;
- (void)setLastExportPostHash:(NSNumber*)hash
                 clidentifier:(NSString*)clidentifier;

/*!
 @details  Starting with BkmkMgrs 2.9.8, this is now stored in user defaults,
 so that BkmxAgent can access it to check hashes when handling triggers
 without Core Data access.  This is a bit dangerous.  It is now important that
 -[Macster updateAllClientsCompositeImportSettingsHashesInUserDefaults:] be
 called whenever Settings are changed.  So I do this in
 -[Macster macsterBusinessNote:], and also, as defensive programming, in
 -[Macster awakeFromFetch].
 */
- (uint32_t)compositeImportSettingsHashForClientoid:(Clientoid*)clientoid;
- (void)setCompositeImportSettingsHash:(uint32_t)hash
                             clientoid:(Clientoid*)clientoid;

- (void)updatePreHashWithExtoreContentHash:(uint32_t)currentContentHash
                                 jobSerial:(NSInteger)jobSerial
                                 moreLabel:(NSString*)moreLabel
                                 clientoid:(Clientoid*)clientoid;

- (NSDate*)generalUninhibitDate ;
- (void)setGeneralUninhibitDate:(NSDate*)date ;

- (NSDate*)uninhibitDateForTriggerCause:(NSString*)triggerCause;
- (void)setUninhibitDate:(NSDate*)uninhibitDate
         forTriggerCause:(NSString*)triggerCause;

- (NSArray*)docUuidsToOpenAfterLaunch;
- (BOOL)doOpenAfterLaunchDocUuid:(NSString*)uuid;
- (void)setDoOpenAfterLaunch:(BOOL)yn
					 docUuid:(NSString*)uuid;

- (NSString*)displayNameForDocumentUuid:(NSString*)uuid ;

/*!
 @brief    Updates the running/not status of BkmxAgent if it is not correct
 based on current watches, or if running and watches are present, restarts
 the watches
 @param    offOnly  If YES, will only switch the BkmxAgent OFF, never on, and
 never reboot
 */
- (void)updateBkmxAgentServiceStatus_offOnly:(BOOL)offOnly;

- (NSInteger)syncSnapshotsLimitMB ;
- (void)setSyncSnapshotsLimitMB:(NSInteger)value ;

- (NSArray*)defaultQuickSearchParmsForKey:(NSString*)key ;

- (NSInteger)nextJobSerialforCreator:(NSString*)cause;

@end
