#import <Cocoa/Cocoa.h>
#import "StarkTyper.h"
#import "SSYAlert.h"
#import "BkmxGlobals.h"

@class Macster ;
@class SSYXugradeApp ;
@class BkmxCoreDataMigrationDelegate;
@class SPUUpdater;


enum BkmxWhich1App_enum
{
    BkmxWhich1AppSmarky = 1,
    BkmxWhich1AppSynkmark = 2,
    BkmxWhich1AppMarkster = 4,
    BkmxWhich1AppBookMacster = 8,
};
typedef enum BkmxWhich1App_enum BkmxWhich1App;

enum BkmxWhichApps_enum
{
	BkmxWhichAppsMain = -2,
    BkmxWhichAppsThis = -1,
    BkmxWhichAppsNone = 0,
    BkmxWhichAppsSmarky = 1,
    BkmxWhichAppsSynkmark = 2,
    BkmxWhichAppsMarkster = 4,
    BkmxWhichAppsBookMacster = 8,
    BkmxWhichAppsAny = 15
};
typedef enum BkmxWhichApps_enum BkmxWhichApps;

extern NSString* const constNoteBkmxAutosaveMocIsDirty ;
extern NSString* const constBaseNameSettings ;
extern NSString* const constBaseNameExids ;
extern NSString* const constBaseNameSettings ;
extern NSString* const constBaseNameDiaries ;
extern NSString* const constBaseNameLogs ;



/*!
 @brief    Application functions that are needed by both the Main App
 and BkmxWorker.
 
 @details  Uses a singleton sharedBasis under the hood
*/
__attribute__((visibility("default"))) @interface BkmxBasis : NSObject <SSYAlertErrorHideManager> {
	NSOperationQueue* operationQueue ;
	NSString* _appNameLocalized ;
	NSString* _appNameUnlocalized ;
    NSString* _mainAppNameUnlocalized;
	NSDictionary* m_starkAttributeTypes ;
	Macster* m_macster ;
	NSMutableString* m_trace ;
	NSInteger m_traceLevel ;
	BOOL m_loggingDisabled ;
	NSScriptCommand* m_currentAppleScriptCommand ;
}

+ (BkmxBasis*)sharedBasis ;

@property (class, assign, readonly) NSUInteger optionsForNSJSON;

+ (NSString*)companyIdentifier ;

+ (NSString*)appIdentifierForAppName:(NSString*)appName ;

+ (NSString*)appIdentifierForThisApp;

+ (BkmxWhichApps)whichAppsFromWhich1App:(BkmxWhich1App)which1App;

+ (NSInteger)secondsPerDay;


- (BOOL)isScripted ;

/*!
 @brief    Use to tell the receiver that there is an AppleScript
 command in process.
 
 @details  This is needed because +[NSScriptCommand currentCommand]
 is quite lame and usually returns nil when in fact a script command
 is in process.  I set it only during threaded commands; that is, during
 AppleScript commands which are subclasses of BkmxThreadedScriptCommand.
 */
@property (retain) NSScriptCommand* currentAppleScriptCommand ;
@property (assign) BOOL clandestine ;
@property (assign) BOOL manualAgentRebootInProgress;

- (NSString*)filenameForMocName:(NSString*)mocName
                     identifier:(NSString*)identifier;

- (NSManagedObjectContext*)mocWithFilename:(NSString*)identifier
                         recreateIfCorrupt:(BOOL)recreateIfCorrupt
                                   error_p:(NSError**)error_p;

- (NSString*)exidsMocFilenameForIdentifier:(NSString*)identifier ;

/*!
 @brief    Returns the managed object context for an identified "Exids-"
 persistent store named in ~/Library/Application Support.
  */
- (NSManagedObjectContext*)exidsMocIgnoringError:(BOOL)ignoreError
									  identifier:(NSString*)identifier ;

/*!
 @brief    Returns the managed object context for an identified "Exids-"
 persistent store in ~/Library/Application Support, presenting
 an error dialog via -[SSYAlert alertError:] if there is any problem.
 */
- (NSManagedObjectContext*)exidsMocForIdentifier:(NSString*)identifier ;

#if 0
// This method is not used, because we have -[[BkmxDoc starxider] save:]
/*!
 @brief    Saves the managed object context for an identifier "Exids-"
 persistent store in ~/Library/Application Support.
 */
- (void)saveExidsMocForIdentifier:(NSString*)identifier ;
#endif

- (NSString*)settingsMocFilenameForIdentifier:(NSString*)identifier;

/*!
 @brief    Returns the Settings managed object context for a given
 bkmxDoc document identifier in ~/Library/Application Support.
 */
- (NSManagedObjectContext*)settingsMocIgnoringError:(BOOL)ignoreError
										 identifier:(NSString*)identifier ;

/*!
 @brief    Returns the Settings managed object context for a given
 bkmxDoc document identifier in ~/Library/Application Support.
 */
- (NSManagedObjectContext*)settingsMocForIdentifier:(NSString*)identifier
                                            error_p:(NSError**)error_p ;

- (NSArray*)allSettingsMocsOnDisk ;

/*!
 @brief    Saves the Settings managed object context for a given
 bkmxDoc document identifier in ~/Library/Application Support.
 */
- (void)saveSettingsMocForIdentifier:(NSString*)identifier ;

/*!
 @brief    Returns the application-wide managed object context with a
 persistent store named "Logs" in ~/Library/Application Support.
 
 @details  Starting in BookMacster version 1.3.22, will fail silently
 if there is an error, to eliminate several annoying alerts which would
 occur if the app was not updated.
 */
- (NSManagedObjectContext*)logsMoc ;

- (void)disableLogging ;

/*!
 @brief    Saves the application-wide managed object context with a
 persistent store named "Logs" in ~/Library/Application Support.
 */
- (void)saveLogsMoc ;

/*!
 @brief    Returns the managed object context with a for a given
 BkmxDoc named "Diaries-<uuid>" in ~/Library/Application Support.
  */
- (NSManagedObjectContext*)diariesMocForIdentifier:(NSString*)identifier
									 ignoringError:(BOOL)ignoreError ;

/*!
 @brief    Returns the managed object context with a for a given
 BkmxDoc named "Diaries-<uuid>" in ~/Library/Application Support, presenting
 an error dialog via -[SSYAlert alertError:] if there is any problem.
 */
- (NSManagedObjectContext*)diariesMocForIdentifier:(NSString*)identifier ;

/*!
 @brief    Saves the managed object context with a for a given
 BkmxDoc named "Diaries-<uuid>" ~/Library/Application Support.
 */
- (void)saveDiariesMocForIdentifier:(NSString*)identifier ;

/*!
 @brief    Returns the uuid of the document of a given managed object,
 which is presumed to be stored in a Settings managed object
 context having a persistent store in the app's Application Support
 directory

 @result  The uuid found, or nil if the given object is not found
 in any of the Settings managed object contexts which have a
 persistent store in the app's Application Support directory.  
*/
- (NSString*)docUuidOfSettingsObject:(NSManagedObject*)object  ;

/*!
 @brief    Returns whether or not the receiver's logsMoc
 contains any ErrorLog objects which do not have a 'presented'
 attribute value equal to YES.
*/
- (BOOL)hasUnpresentedErrors ;

/*!
 @brief    Returns the value of the highest ixport serial number 
 among all the ixport logs stored in the diariesMoc of a given
 BkmxDoc, identified by its uuid.
*/
- (NSInteger)lastIxportSerialValueForBkmxDocUuid:(NSString*)bkmxDocUuid ;

/*!
 @brief    Examines all LogEntry objects in the app's Logs persistent
 managed object context and deletes those which are older than
 their relevant "days to keep" limit.
 */
- (void)cleanDefunctLogEntries ;

/*!
 @brief    An application-wide operation queue.
 */
@property (retain, readonly) NSOperationQueue* operationQueue ;

/*!
 @brief    The full path to the currently-running executable.
 */
@property (readonly) NSString* executablePath ;

@property (readonly) NSString* appNameLocalized ;

@property (readonly) NSString* appNameUnlocalized ;

@property (readonly) NSString* appUrlScheme ;

@property (readonly) NSString* mainAppNameLocalized ;

@property (readonly) NSString* mainAppNameUnlocalized ;

@property (readonly) NSData* iconData ;

@property (retain) BkmxCoreDataMigrationDelegate* coreDataMigrationDelegate;

/*!
 @brief    Returns an array of exformats which are the ownerApps of the web
 service applications supported by this application, ordered by popularity.
 */
- (NSArray*)supportedWebAppExformatsOrderedByPopularity ;

/*!
 @brief    Returns a copy of the array returned by
 supportedWebAppExformatsOrderedByPopularity,
 except ordered alphanumerically.
 */
- (NSArray*)supportedWebAppExformats ;

/*!
 @brief    Returns an array of names of the ownerApps which are
 desktop browser applications supported by this application and installed
 on this Mac, regardless of their version.
 
 @details  The array returned will contained exactly the same number
 of objects as the array returned by -supportedLocalAppExformats,
 and between these two arrays, objects with corresponding indexes
 will refer to the same ownerApp.
 */
- (NSArray*)supportedLocalAppBundleIdentifiers ;

/*!
 @brief    Returns an array containing the union of the ownerApps
 in -supportedLocalAppExformats and -supportedWebAppExformats
 */
- (NSArray*)supportedOwnerApps ;
 
/*!
 @brief    Returns an array of exformats which are the ownerApps of the
 desktop browser applications supported by this application, regardless
 of whether they are installed and regardless of their version,
 ordered by popularity.
 */
- (NSArray*)supportedLocalAppExformatsOrderedByPopularityIncludeNonClientable:(BOOL)includeNonClientable ;

/*!
 @brief    Returns a copy of the array returned by
 supportedLocalAppExformatsOrderedByPopularityIncludeNonClientable:,
 except ordered alphanumerically.
 
 @details  The array returned will contained exactly the same number
 of objects as the array returned by -supportedLocalAppBundleIdentifiers,
 and between these two arrays, objects with corresponding indexes
 will refer to the same ownerApp.
 */
- (NSArray*)supportedLocalAppExformatsIncludeNonClientable:(BOOL)includeNonClientable ;

/*!
 @brief    Returns an array containing the array returned by
 supportedLocalAppExformatsOrderedByPopularityIncludeNonClientable: followed
 by the array returned by supportedWebAppExformatsOrderedByPopularity:.
 */
- (NSArray*)supportedExformatsOrderedByPopularity ;

/*!
 @brief    Returns an array of strings consisting of all exformats supported
 by the receiver, ordered alphanumerically
 */
- (NSArray*)supportedExformatsOrderedByName;

/*!
 @brief    Logs a Message Log to the application-wide log.

 @details  If [[[AgentPerformer sharedPerformer] nowWorkingJobSerial] is > 0,
 this method will prepend a prefix derived from that positive integer.  This is
 effectively using it as a (horror!!) global variable.  It saves a lot of code,
 but can lead to bugs if you are not careful.  Fortunately, in this case they
 are only logging bugs.  Such bugs will not occur in main app since main app
 has no AgentPerformer singleton.  But in BkmxAgent, you must be careful – only
 call this method from the *syncing* code, when a job has been dequeued and is
 running.  For other code in BkmxAgent, use -forJobSerial:logFormat:, passing
 jobSerial = 0 if there is no associated job (yet).
 
 @param    ...  At this time, format string modifiers,
 such as the "0.1" in "%0.1f", will cause a crash.  Also, it appears that more
 than one parameter does not work as expected, gives nonsense substitutions with???
*/
- (void)logFormat:(NSString*)formatString, ... ;

/*!
 @details  Same as -logFormat: but does not do substitutions, so is therefore
 safer.  Be sure to use this method instead of that one if there is any
 possibility that the passed-in message (or formatString) contains any "%"
 characters which could spoof a placeholder.
 */
- (void)logString:(NSString*)message;

- (void)forJobSerial:(NSInteger)jobSerial
           logFormat:(NSString*)formatString, ... ;

- (void)forJobSerial:(NSInteger)jobSerial
           logString:(NSString*)message ;
/*!
 @details  Same as -forJobSerial:logFormat: but does not do substitutions, so
 is therefore safer.  Be sure to use this method instead of that one if there
 is any possibility that the passed-in message (or formatString) contains any
 "%" characters which could spoof a placeholder.
 */


/*!
 @brief    Logs a given error to the logsMoc by inserting an
 ErrorLog object into the logsMoc, and optionally sets the
 object's 'presented' attribute to YES; unless the error or 
 one of its descendants is of code NSUserCancelledError in the
 NSCocoaErrorDomain, or of code constBkmxErrorNoChangesToExport in 
 [NSError myDomain].

 @details  Note that errors from main app are presented first,
 and then logged (-[BkmxAppDel presentedErrorNote:]) but
 errors from BkmxAgent are logged first (-[AgentPerformer alertError:])
 and then presented later when the main app launches (-[BkmxAppDel presentedErrorNote:]).
*/
- (void)logError:(NSError*)error
 markAsPresented:(BOOL)markAsPresented ;

- (NSString*)messageLoggedNotificationName ;

- (NSString*)appFamilyName;

- (NSString*)toAgentPortName;

- (NSString*)urlHandlerBundleIdentifier;

- (NSSet*)trivialAttributes ;

/*!
 @details  This method (1) may fail silently and (2) returns immediately,
 before any objects are deleted.
 */
- (void)deleteObjectsOfEntity:(NSString*)entityName
					olderThan:(NSDate*)cutoffDate
		 managedObjectContext:(NSManagedObjectContext*)managedObjectContext ;

/*!
 @brief    Returns whether or not it is ok to run the application.

 @param    error_p  Pointer which will, upon return, if the result is
 NO and said pointer is not NULL, point to an NSError
 describing why it is not ok to run the app.
*/
- (BOOL)checkNoSiblingAppsRunningError_p:(NSError**)error_p ;

/*!
 @brief    Returns the attribute type for a given attribute key.
 
 @details  Attribute types for managed attributes are determined
 by consulting the main bundle's merged managed object model.  
 Attribute types for some other attributes are hard-coded.  
 If key is nil, returns NSUndefinedAttributeType.
 
 Since reading the merged managed object model from disk is
 expensive, only does this once and caches it.
 */
- (NSAttributeType)attributeTypeForStarkKey:(NSString*)key ;

/*!
 @brief    Fetches, or creates if necessary, the Macster instance
 which has a given docUuid
*/
- (Macster*)macsterWithDocUuid:(NSString*)docUuid
				  createIfNone:(BOOL)createIfNone ;


- (void)deleteAllObjectsOfEntities:(NSArray*)entityNames
					   mocBaseName:(NSString*)mocBaseName
						identifier:(NSString*)identifier ;

/*!
 @brief    Replaces the receiver's trace, if any, with a new
 trace initialized to contain some header text, and plays the
 system alert sound "Submarine" in macOS 10.x, "Submerge" in
 macOS 11.x+.
 
 @param    header  The initial text to be set in the trace
*/
- (void)beginDebugTraceWithHeader:(NSString*)header ;

- (void)setTraceLevel:(NSInteger)traceLevel ;

/*!
 @brief    Returns the current traceLevel of the receiver
*/
- (NSInteger)traceLevel ;

/*!
 @brief    Appends text to the receiver's trace
 
 @details  No-op if the receiver's trace trace is nil.
*/
- (void)trace:(NSString*)string ;

/*!
 @brief    Writes the receiver's trace to a .zip file named
 with app name, "Trace", and a timestamp, and sets
 the receiver's trace to nil.
*/
- (void)endAndWriteDebugTrace ;

/*!
 @brief    Returns whether or not the receiver is currently
 doing anything when it receives a -trace: message.
*/
- (BOOL)isTracing ;

/*!
 @brief    Returns which app in our bookmarks manager family is running.
 */
- (BkmxWhich1App)iAm ;

/*!
 @brief    Returns YES if the current app is Smarky, Synkmark or Markster;
 otherwise NO
 */
- (BOOL)isShoeboxApp ;

/*!
 @brief    Returns YES if the current app is BkmxAgent; otherwise NO
 */
- (BOOL)isBkmxAgent;

+ (NSSet*)syncableWhich1Apps;

/*!
 @brief    Returns YES if the current app is Smarky, Synkmark or BookMacster;
 otherwise NO
 */
- (BOOL)isAMainAppWhichCanSync ;

- (NSSet*)allAppNames ;

- (NSString*)appNameForApps:(BkmxWhichApps)whichApps;
- (NSSet*)bundleIdentifiersForApps:(BkmxWhichApps)whichApps;
- (NSSet*)appNamesForApps:(BkmxWhichApps)whichApps;
- (NSString*)appNameForWhich1App:(BkmxWhich1App)which1App;

/*!
 @brief    Returns the set of unlocalized app names in the family which support
 Syncers: Smarky, Synkmark, BookMacster
 */
- (NSSet*)agentableAppNames ;

- (NSSet<NSNumber*>*)agentableAppWhichApps;

- (void)destroyAnyExistingDocSupportMocForMocName:(NSString*)mocName
                                            uuid:(NSString*)uuid ;

- (NSString*)processDisplayTypeForProcessType:(BkmxLogProcessType)processType ;

- (NSDictionary*)defaultDefaults ;

- (NSString*)displayTextForPurpose:(NSInteger)purpose ;

- (NSString*)detectedChangesPath ;

- (NSTimeInterval)timeoutForAppToLaunch ;

- (NSString*)bundleIdentifierForLoginItemName:(NSString*)appName
                                  inWhich1App:(BkmxWhich1App)which1App
                                      error_p:(NSError**)error_p;

- (NSArray<NSRunningApplication*>*)runningAgents;

- (NSString*)appNameContainingAgentWithBundleIdentifier:(NSString*)bundleIdentifier;

- (NSString*)runningAgentDescription;

- (BOOL)rebootSyncAgentReport_p:(NSString**)report_p
                        title_p:(NSString**)titie_p
                        error_p:(NSError**)error_p ;

- (void)scheduleFileCruftCleaning;

- (BOOL)verifyVersionIsAdequate;
- (NSString*)versionInadequateDescription;
- (NSString*)versionInadequateRecoverySuggestion;
- (NSError*)versionInadequateError;

@end
