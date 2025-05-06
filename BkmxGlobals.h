#import <CoreFoundation/CoreFoundation.h> // For CopyCurrentConsoleUsername()
#import <Cocoa/Cocoa.h>
#import "StarkTyper.h"

#pragma mark * #defines

// Since simple integers take up the same number of bytes as a pointer,
// and since it can be painful to maintain synchronization between the
// extern declarations in the .h file and the assignments in the .m
// file, I use #define for integer constants.  Actually, it's more efficient
// since I don't need the definition for each value -- A constant used
// in N places takes up only N integer-sized chunks instead of N+1.

// Warning: Starting with BookMacster version 1.5.7, error codes are stored in users'
// IxportLog objects in their databases.

// No errors
#define constBkmxErrorNone 0

// Warnings
#define constBkmxErrorWarning 101000
#define constBkmxErrorUserCancelled 101001
#define constBkmxErrorUserSaidRevert 101002  // Not used
#define constBkmxErrorNoItemsToUpload 101003
#define constBkmxErrorNoCandidates 101004
#define constBkmxErrorNoChangesToExport 101005
#define constBkmxErrorNoChangesToImport 101006
#define constBkmxErrorNotAvailableAtThisTime 101020
#define constBkmxErrorCantReadBookmarksNoIdea 101050
#define constBkmxErrorBrowserRunningJustYielded 101061
#define constBkmxErrorBrowserBookmarksWereChangedDuringSync 101063
#define constBkmxErrorBrowserRunningQuitCancelled 101064
#define constBkmxErrorCouldNotExport 101066
#define constBkmxErrorIsTestRun 101080
#define constBkmxErrorNoDirection 101090
#define constBkmxErrorMainAppHasDocOpenSoWontSync 101091
#define constBkmxErrorAgentNotificationsAreThrottled 101092
#define constBkmxErrorNeedVersion3 101093

// Minor Errors
// Was using 200x for these but got tired of getting Project Find
// results full of stupid copyright statements.  ARGHHH!!!
#define constBkmxErrorWorkerGotBadArguments 1019001
#define constBkmxErrorMinor 103000
#define constBkmxErrorAppIsExpiredButSparkleDidNotFindUpdate 284749
#define constBkmxErrorFileConflict 103001
#define constBkmxErrorCancellingStagedAndQueuedJobsInAgent 984682
#define constBkmxErrorCantFindIt 103002
#define constBkmxErrorBrowserTooOld 103003
#define constBkmxErrorCantDecode 103004
#define constBkmxErrorAppTooOldForBookmarkskhelf 103007
#define constBkmxErrorBrowserMessengerOrExtensionDead 103008
#define constBkmxErrorImportChangesExceededLimit 103011
#define constBkmxErrorExportChangesExceededLimit 103012
#define constBkmxErrorFightDetected 103015
#define constBkmxErrorMultipleAgentsRunning 283755
#define constBkmxErrorRequestedAgentNotAvailable 3021 // was 384001
#define constBkmxErrorTriggerNoUri 382261
#define constBkmxErrorTriggerNotFound 382262
#define constBkmxErrorTriggerWrongClass 382263
#define constBkmxErrorTriggerUnavailable 382264
#define constBkmxErrorTriggersAgentNotFound 103023 // was 384003
#define constBkmxErrorTriggersAgentNotAvailable 103024 // was 384004
#define constBkmxErrorCantFindTrigger 103025 // was 384005
#define constBkmxErrorTookTooLongToInstallBrowserExtension 103040 // was 264948
#define constBkmxErrorEncodingJobForStaging 104841
#define constBkmxErrorEncodingJobForStagingUnknown 104842
#define constBkmxErrorDecodingStagedJob 104843
#define constBkmxErrorDecodingAStagedJob 104844
#define constBkmxErrorExceededComfortLimitForStyle2Export 103044
#define constBkmxBrowserStoppedRespondingDuringStyle2Export  103045  // was 694812
#define constBkmxErrorClientAPIThrottled 103047
#define constBkmxErrorCouldNotReenableTrigger 103050
#define constBkmxErrorImportCommandBut0ClientsNeedIt 103052
#define constBkmxErrorAgentApparentlyFellBackToStyle1ThusNeededBrowserQuitButAgentCannotQuitBrowsers 103053
#define constBkmxErrorCouldNotAccessBookmarksData 123511
#define constBkmxErrorExtensionDidNotRespond 145725
#define constBkmxErrorImportTimedOut 651507
#define constBkmsErrorSheepSafariHelperHadIssuesReading 772000
#define constBkmsErrorSheepSafariHelperHadIssuesWriting 772001
#define constBkmxErrorTimedOutGettingExidsFromClient 453973
#define constBkmxErrorInUserNotificationAuthorization 927183
#define constBkmxErrorCouldNotGetBundleInMain 293835

// Major Errors
#define constBkmxErrorMajor 108000
#define constBkmxErrorCantConnectToServer 108001
#define constBkmxErrorCantCreateDirectory 108002
#define constBkmxErrorCantFindPreferencesFile 108003
#define constBkmxErrorCantMassUpload 108004
#define constBkmxErrorCantReadBookmarks 108005
#define constBkmxErrorCantReadDirectory 108006
#define constBkmxErrorCantReadFile 108007
#define constBkmxErrorCantUploadOne 108008
#define constBkmxErrorCantWritePersistentAuxiliaryData 108009
#define constBkmxErrorCouldNotWriteUserDefaults 108010
#define constBkmxErrorFailedRemoving1AtServer 108011
#define constBkmxErrorFileParsingError 108012
#define constBkmxErrorManagedObjectContextUnknownSaveError 108013
#define constBkmxErrorNoSelection 108014
#define constBkmxErrorNotLicensedToWrite 108015
#define constBkmxErrorNoUser 108016
#define constBkmxErrorNumberOfRootsNotEqual1 108017
#define constBkmxErrorNoData 108018
#define constBkmxErrorCantWriteFile 108019
#define constBkmxErrorCouldNotImportData 108020
#define constBkmxErrorCouldNotCreatePersistentDocument 108021
#define constBkmxErrorCouldNotWriteLockedFileMainApp 108022
#define constBkmxErrorCouldNotWriteLockedFileWorker 108023
#define constBkmxErrorAppIsExpired 108025

// Ixporter Special Option Constants
// Note that these can be assigned differently in different extores                                 Uses
// However, they share common default values in the data model: 0LL all 0s                          Bits     Used by Extore Subclasses
// ------------------------------------------------------------------------   --------------------  ----     -----------------------------
#define constBkmxIxportSpecialOptionBitmaskDoSpecialMapping                   0x0000000000000001LL  // 0     Opera
#define constBkmxIxportSpecialOptionBitmaskDontWarnOwnerSync                  0x0000000000000002LL  // 1     Chromy
#define constBkmxIxportSpecialOptionBitmaskDownloadPolicyForImport            0x0000000000000003LL  // 0,1   Http = {Deli, Pinboard, Diigo}
#define constBkmxIxportSpecialOptionBitmaskDownloadPolicyForExport            0x000000000000000CLL  // 2,3   Http = {Deli, Pinboard, Diigo}
#define constBkmxIxportSpecialOptionBitmaskLaunchBrowserPref                  0x000000000000000CLL  // 2,3   Chromy, Firefox
#define constBkmxIxportSpecialOptionBitmaskDontImportTrash                    0x0000000000000010LL  // 4     Opera
#define constBkmxIxportSpecialOptionBitmaskNoLoosiesInMenu                    0x0000000000000010LL  // 4     Chromy
// #define constBkmxIxportSpecialOptionBitmaskDontUseOtherBookmarks           0x0000000000000020LL  // 5     Chromy  Removed in BookMacster 1.22.16
#define constBkmxIxportSpecialOptionBitmaskFakeUnfiled                        0x0000000000000040LL  // 7     Chromy
#define constBkmxIxportSpecialOptionBitmaskNadaMenu                           0x0000000000000010LL  // 6     Safari
#define constBkmxIxportSpecialOptionBitmaskHttpRateInitial                    0x0000000000000030LL  // 4,5   Http = {Deli, Pinboard, Diigo}
#define constBkmxIxportSpecialOptionBitmaskAssumeLoggedInToCorrectAccount     0x0000000000000080LL  // 7     formerly Google Bookmarks
#define constBkmxIxportSpecialOptionBitmaskHttpRateRest                       0x00000000000001C0LL  // 6,7,8 Http = {Deli, Pinboard, Diigo}
#define constBkmxIxportSpecialOptionBitmaskHttpRateBackoff                    0x0000000000000600LL  // 9-10  Http = {Deli, Pinboard, Diigo}


// Miscellaneous, parameters
#define SECS_SHOW_OLD_BEFORE_NEW 0.035
#define THROTTLE_PERIOD_FOR_SECOND_PASS 0.5
#define TIMEOUT_FOR_APP_TO_QUIT 15.0
#define TIMEOUT_FOR_APP_TO_BE_KILLED 3.0
#define LAUNCH_QUIT_RETEST_INTERVAL 0.5
#define TIME_FOR_APP_TO_STABILIZE 3.0
#define TIMEOUT_BROWSER_API_TEST 6.0
#define TIMEOUT_EXID_FEEDBACK_MIN_MAIN_APP 30.1386  // Was 5.0 until BookMacster 1.9.3, 15.0 until BookMacster 2.4.10
#define TIMEOUT_EXID_FEEDBACK_MIN_WORKER 300.2844  // Was 5.0 until BookMacster 1.9.3, 15.0 until BookMacster 2.4.10
#define IDLE_EDITING_TIMEOUT 30.0
#define SAW_CHANGE_DEBOUNCE_INTERVAL 5.0468
#define SECONDS_NEEDED_FOR_ONE_ALERT_SOUND 3
#define AGENT_REDO_DELAY 60.0
#define SNAPSHOT_MAX_LIMIT_MB 1000


#if DEBUG
// When debugging, make the lockout timer very short in case we crash and want to re-test.
#define TIMEOUT_FOR_OTHER_BOOKMACSTER_OR_WORKER_TO_IMPORT 10.0
#else
#define TIMEOUT_FOR_OTHER_BOOKMACSTER_OR_WORKER_TO_IMPORT 90.0
#endif

// About 68 years' worth of seconds.  This is the largest number which you can
// use without causing an integer overflow when run in
// 32-bit mode.  Also, note that we do not use INT_MAX because this will
// overflow if used as an argument to +[NSDate dateWithTimeIntervalSinceNow:]
// when run in 64-bit mode.
#define SAFE_DISTANT_FUTURE_SECONDS 0x7fffffff

#define YOUR_DEFAULT_TAG_DELIMITER 0xF001  // a "private-use" unicode code point
                                           // hard-coded as default in data model!

#define constBkmxSyncerConfigNone              0x0000000000000000LL
#define constBkmxSyncerConfigIsAdvanced        0x0000000000000001LL
#define constBkmxSyncerConfigImportChanges     0x0000000000000010LL
#define constBkmxSyncerConfigSort              0x0000000000000020LL
#define constBkmxSyncerConfigExportToClients   0x0000000000000040LL
#define constBkmxSyncerConfigExportFromCloud   0x0000000000000100LL
#define constBkmxSyncerConfigExportLanding     0x0000000000000200LL

#define BkmxExportHashBitMaskDidChangeBit     0x8000000000000000LL
#define BkmxExportHashBitMaskExtoreContent    0x7FFFFFFF00000000LL
#define BkmxExportHashBitMaskBkmxDocStuff     0x00000000FFFFFFFFLL
#define BkmxExportHashBitMaskWholePayload     0x7FFFFFFFFFFFFFFFLL

#define constExtensibilityNone        0x0
#define constExtensibilitySawChange   0x1
#define constExtensibilityImport      0x2
#define constExtensibilityExport      0x4

// Interapp Messaging

// Generic Messages
#define constInterappHeaderByteForAcknowledgment 'a'  // synchronous response, payload to come later, asynchronously
#define constInterappHeaderByteForProgress 'p'
#define constInterappHeaderByteForErrors 'z'

// Version Check, asynchronous request and response
// Although it seems really silly for a simple version check to need to be
// asynchronous, that is the case, because in the Firefox extension this
// requires ExtensionManager.getExtensionByID, which is asynchronous.
#define constInterappHeaderByteForTest 't'
#define constInterappHeaderByteForVersionCheck 'v'

// Get current profile name, synchronous request and response
#define constInterappHeaderByteForProfileRequest 'o'
#define constInterappHeaderByteForProfileResponse 'q'

// Importing, asynchronous request and response
#define constInterappHeaderByteForImport 'i'          // request
#define constInterappHeaderByteForBookmarksTree 'b'   // async response, including payload

// Exporting, asynchronous request and response
#define constInterappHeaderByteForExport 'e'          // request, including payload
#define constInterappHeaderByteForExportFeedback 'f'    // async response, with payload

// Grabbing the currently-viewing web page to populate DoxtusMenu
#define constInterappHeaderByteForGrabRequest 'g'
#define constInterappHeaderByteForGrabResponse 's'

// Expressive BOOL types

#define BkmxIxportPolarityImport YES
#define BkmxIxportPolarityExport NO
typedef BOOL BkmxIxportPolarity ;

#define BkmxBooleanOpAnd YES
#define BkmxBooleanOpOr  NO
typedef BOOL BkmxBooleanOp ;
// used "Op" instead of "Operator" because compiler thinks "operator" in method names is the 'operator' keyword.

#pragma mark * Global Variables
extern BOOL gDoLog ;

#pragma mark * enums

/* In Swift, these will appear as KickType.nothing, KickType.start, etc. */
typedef NS_ENUM(NSUInteger, KickType) {
    KickType_Nothing = 0,
    KickType_Start = 1,
    KickType_Stop = 2,
    KickType_Reboot = 3,
    KickType_Status = 4
};

enum BkmxAgentStatus_enum {
    /* The negative ones are my additions. */
    BkmxAgentStatusInternalError = -4,
    BkmxAgentStatusUnknown = -3,
    BkmxAgentStatusNotAvailableDueToMacOS12OrEarlier = -2,
    BkmxAgentStatusNotRequested = -1,
    /* The positive ones here replicate Apple's SMAppService.Status */
    BkmxAgentStatusNotRegistered = 0,  // The last call to SMAppService.unregister() occurred after the last call to SMAppService.register(), so the service is not registered, in other words, it is not running.  In System Settings > Login Items > the status of the switch of the app which contains the service as a Login Item could be either ON or OFF.  If you want to know the status of that switch, you must first call SMAppService.register() (which will register the service if approval has beebn granted) and then read SMAppService.status again.
    BkmxAgentStatusEnabled = 1,  // The last call to SMAppService.register() occurred after the last call to SMAppService.unregister(), and in System Settings > Login Items, the app which contains the service as a Login Item is switched ON.  Therefore, the service is registered, in other words, it is running :)
    BkmxAgentStatusRequiresApproval = 2, // The last call to SMAppService.register() was later than the last run of SMAppService.unregister(), but in System Settings > Login Items, the app which contains the service as a Login Item is switched OFF.  Therefore, the service is not registered, in other words, it is not running.
    BkmxAgentStatusNoSuchService = 3 //  The macOS has no record of the service with the given bundle identifier, and so of course it is not registered, in other words, not running.  This will happen if no installed app has the service contained in its Contents/Library/LoginItems.
} ;
typedef enum BkmxAgentStatus_enum BkmxAgentStatus;

enum BkmxClientTask_enum
{
	BkmxClientTaskRead = 1,
	BkmxClientTaskWrite = 2,
	BkmxClientTaskInstall = 4
} ;
typedef enum BkmxClientTask_enum BkmxClientTask ;

enum BkmxParentingAction_enum
{
	BkmxParentingActionNone, // 0
    BkmxParentingAdd,        // 1
	BkmxParentingRemove,     // 2
	BkmxParentingCopy,       // 3
	BkmxParentingMoveOrCopy, // 4 Move if intra-document, Copy if inter-document
    BkmxParentingMove        // 5
	// The opposite 'undo' actions are not needed since Core Data handles undo
} ;
typedef enum BkmxParentingAction_enum BkmxParentingAction ;

enum BkmxParentingMasks_enum
{
	BkmxParentingNone = 0x0,
	BkmxParentingUndo = 0x4 
} ;
typedef enum BkmxParentingMasks_enum BkmxParentingMasks ;

enum BkmxFixDispo_enum
{
	// Warning: These values = tags in Reports.xib > Verify
	// They are also used in users' user defaults, and the 0 is 
	// the default value in the data model.  --> Don't mess with these!
	BkmxFixDispoNotApplicable = -1,
	BkmxFixDispoToBeDetermined = 0,
	BkmxFixDispoLeaveAsIs = 3,
	BkmxFixDispoDoUpdate = 6,
    BkmxFixDispoDoUpgradeInsecure = 7,
	BkmxFixDispoLeaveBroken = 9
} ;
typedef enum BkmxFixDispo_enum BkmxFixDispo ;

enum BkmxHttp302_enum
{
	BkmxHttp302NotApplicable = 0,
	BkmxHttp302Disagree = 1,
	BkmxHttp302Unsure = 2,
	BkmxHttp302Agree = 3
} ;
typedef enum BkmxHttp302_enum BkmxHttp302 ;
	
enum BkmxSortable_enum  // Warning: Values = tags in Inspector xib
{
	BkmxSortableNo = NSControlStateValueOff,
	BkmxSortableYes = NSControlStateValueOn,
	BkmxSortableAsParent = NSControlStateValueMixed,
	BkmxSortableAsDefault = 127
} ;
typedef enum BkmxSortable_enum BkmxSortable ;

enum SortBy_enum
{
	// These are stored as the value of the sortBy
	// attribute of entity Bookshig in user documents.
	BkmxSortByName = 0,
	BkmxSortByUrl = 1,
	BkmxSortByDomainHostPath = 2,
	BkmxSortByRating = 3,
	// These are not store in user documents
	BkmxSortByShortcut,
	BkmxSortByAddDate,
	BkmxSortByLastModified,
	BkmxSortByLastVisited,
	BkmxSortByVerifyStatusCode,
	BkmxSortByVisitCount,
} ;
typedef enum SortBy_enum BkmxSortBy ;
	
enum BkmxSortingSegmentation_enum
{
	BkmxSortingSegmentationMixAndSortAll = 0x00,
	BkmxSortingSegmentationFoldersAtTopSortingBoth = 0x01,
	BkmxSortingSegmentationFoldersAtBottomSortingBoth = 0x02,
    BkmxSortingSegmentationFoldersAtTopSortingFoldersOnly = 0x03,
    BkmxSortingSegmentationFoldersAtBottomSortingFoldersOnly = 0x04,
    BkmxSortingSegmentationFoldersAtTopSortingBookmarksOnly = 0x05,
    BkmxSortingSegmentationFoldersAtBottomSortingBookmarksOnly = 0x06,
    BkmxSortingSegmentationIllegalValue = 0x7e,
    BkmxSortingSegmentationDontKnow = 0x7f,
} ;
typedef enum BkmxSortingSegmentation_enum BkmxSortingSegmentation ;
	
enum BkmxSortDirective_enum 
{
	BkmxSortDirectiveNotApplicable = -1,
	BkmxSortDirectiveNormal = 0,
	BkmxSortDirectiveTop = 1,
	BkmxSortDirectiveBottom = 2
} ;
typedef enum BkmxSortDirective_enum BkmxSortDirective ;

enum BkmxFabricateFolders_enum
{
	BkmxFabricateFoldersOff = 0,
	BkmxFabricateFoldersOne = 1,
	BkmxFabricateFoldersAll = 32767 
} ;
typedef enum BkmxFabricateFolders_enum BkmxFabricateFolders ;

enum BkmxMergeBy_enum
{
    BkmxMergeByNone      =  0,
    BkmxMergeByExid      =  1,
    BkmxMergeByExidOrUrl =  2
} ;
typedef enum BkmxMergeBy_enum BkmxMergeBy;

enum BkmxMergeBias_enum
{
	// The following are hard-coded to menu item index in BkmxDoc.nib
	// See NSNumber+mergeBiasDisplay.m
	//                                  Import      Export
	//                                  ------      ------
	BkmxMergeBiasKeepSource  =  0, //  Client[1]   BkmxDoc[1]                                     
	BkmxMergeBiasKeepDestin  =  1, //  BkmxDoc      Client
	BkmxMergeBiasKeepBoth    =  2  //   Both       Both
	// Notes:
	// 1.  Default for Ixporters (both subentities) in Data Model (.xcdatamodel) 
} ;
typedef enum BkmxMergeBias_enum BkmxMergeBias ;

enum BkmxMergeResolutionTags_enum
{
                                               //  Checkbox      Value        UserThinks        Actual Behavior
	BkmxMergeResolutionKeepDestinTags   = -1,  //    [-]     NSControlStateValueMixed     No action        Keep destin tags
	BkmxMergeResolutionKeepSourceTags   =  0,  //    [ ]      NSControlStateValueOff    Keep source tags   Keep source tags
	BkmxMergeResolutionKeepBothTags     =  1,  //    [/]      NSControlStateValueOn       Merge tags           Merge tags
} ;
typedef enum BkmxMergeResolutionTags_enum BkmxMergeResolutionTags ;

enum BkmxTriggerType_enum
{
	BkmxTriggerImpossible    = -0x01,
    BkmxTriggerLogIn         = 0x00,  // 0 is the default value in data model
    BkmxTriggerPeriodic      = 0x01,
	BkmxTriggerBrowserQuit   = 0x02,
	BkmxTriggerScheduled     = 0x04,
	BkmxTriggerSawChange     = 0x08,
	BkmxTriggerCloud         = 0x10,
	BkmxTriggerLanding       = 0x20,
    BkmxTriggerBrowserLaunch = 0x40  // not used (yet?)
} ;
typedef enum BkmxTriggerType_enum BkmxTriggerType ;

/* These roughly correspond to BkmxTriggerType values.  They are used at a
 lower level, to actually implement the BkmxTriggerType values, in BkmxAgent. */
enum WatchType_enum
{
    WatchTypeUndefined     = 0x00, // BkmxTriggerImpossible
    WatchTypeLogIn         = 0x01,  // BkmxTriggerLogIn
    WatchTypePeriodic      = 0x02,  // BkmxTriggerPeriodic
    WatchTypeAppQuit       = 0x03,  // BkmxTriggerBrowserQuit
    WatchTypeScheduled     = 0x08,  // BkmxTriggerScheduled
    WatchTypePathTouched   = 0x10,  // BkmxTriggerSawChange, BkmxTriggerCloud
    WatchTypeLanding       = 0x20,  // BkmxTriggerLanding
    WatchTypeAppLaunch     = 0x40
} ;
typedef enum WatchType_enum WatchType ;

enum BkmxDeference_enum
{
	BkmxDeferenceUndefined     =  0x00,
	BkmxDeferenceYield         =  0x01,
	BkmxDeferenceAsk           =  0x02,
	BkmxDeferenceQuit          =  0x03,
	BkmxDeferenceKill          =  0x04,
	BkmxDeferenceCancelled     =  0x10
	// These constants are mirrored in BookMacster.sdef
	// You must change them there too if you change them here.
} ;
typedef enum BkmxDeference_enum BkmxDeference ;

enum BkmxDocumentStatusInMainApp_enum
{
    BkmxDocumentStatusInMainAppIndeterminateDueToError = -1 ,
    BkmxDocumentStatusInMainAppNotRunning = 0 ,
    BkmxDocumentStatusInMainAppRunningButNotOpen = 1 ,
    BkmxDocumentStatusInMainAppDocIsOpen= 2 ,
} ;
typedef enum BkmxDocumentStatusInMainApp_enum BkmxDocumentStatusInMainApp ;

enum BkmxHartainer_enum
{
	BkmxHartainerRoot = 0 ,
	BkmxHartainerBar = 1 ,
	BkmxHartainerMenu = 2 ,
	BkmxHartainerOhared = 3
} ;
typedef enum BkmxHartainer_enum BkmxHartainer ;

/*
 @details  The ordering of this one was made unnatural for backward
 compatibility with the BOOL assumeServerUnchangedDuringExport, which
 downloadPolicyForExport replaced in BookMacster 1.22.4.  Get over it. */
enum BkmxIxportDownloadPolicy_enum
{
	BkmxIxportDownloadPolicyAutomatic = 0,
	BkmxIxportDownloadPolicyNever = 1,
	BkmxIxportDownloadPolicyAlways = 2
} ;
typedef enum BkmxIxportDownloadPolicy_enum BkmxIxportDownloadPolicy ;

enum BkmxUrlTemporality_enum
{
	BkmxUrlTemporalityPrior = -1,
	BkmxUrlTemporalityCurrent = 0,
	BkmxUrlTemporalitySuggested = 1
} ;
typedef enum BkmxUrlTemporality_enum BkmxUrlTemporality ;

enum BkmxGrabPageIdiom_enum
{
	// cannot grab page:
	BkmxGrabPageIdiomNone,
	// grab page by acting as an SSYInterappServer
	BkmxGrabPageIdiomSSYInterappServer,
	// grab page by sending it an AppleScript message
	BkmxGrabPageIdiomAppleScript
} ;
typedef enum BkmxGrabPageIdiom_enum BkmxGrabPageIdiom ;

enum Advice_enum
{
	advNone,
	advUpdated,
	advUntrusted,
	advBadRedirect,
	advFileGone,
	advTryAgain,
	advHostGone,
	advBadURL,
	advPageGone,
	advNewPageSameDomainBkmx,
	advTooManyRedirects,
	adv400to403,
	advVacuumCleaner,
	adv302,
	advFalseAlarm,
	advRSS,
	advIfOK
} ;
typedef enum Advice_enum Advice ;

enum BkmxAuthorizationMethod_enum {
	BkmxAuthorizationMethodNone,
	BkmxAuthorizationMethodHttpAuth,
	BkmxAuthorizationMethodOAuth,
    BkmxAuthorizationMethodManual
} ;
typedef enum BkmxAuthorizationMethod_enum BkmxAuthorizationMethod ;

enum PathRelativeTo_enum {
	PathRelativeToNone,
	PathRelativeToRoot,
	PathRelativeToHome,
	PathRelativeToLibrary,
	PathRelativeToApplicationSupport,
	PathRelativeToPreferences,
	PathRelativeToProfile
} ;
typedef enum PathRelativeTo_enum PathRelativeTo ; 

/*!
 @brief    Measure of what level of Ixport operations a Client's
 owner app allows with its bookmarks while it is running.
 
 @details  The answer also depends on the ixport style of the
 proposed ixport operation, but that is embodied elsewhere in the
 context.
 */
enum BkmxIxportTolerance_enum {
	BkmxIxportToleranceAllowsNone            = 0,
	BkmxIxportToleranceAllowsReading         = 1,
	BkmxIxportToleranceAllowsWriting         = 2,
	BkmxIxportToleranceAllowsInstallingAddOn = 4
} ;
typedef enum BkmxIxportTolerance_enum BkmxIxportTolerance ; 

typedef NSInteger BkmxIxportStyle;

/*
 Ixport Styles are…
 0  Unknown
 1  Style 1
 2  Style 2
 I don't think we need an enum for that!
*/

enum BkmxCanEditInStyle_enum {
    BkmxCanEditInStyleNeither = 0,
    BkmxCanEditInStyle1Only = 1,
    BkmxCanEditInStyle2Only = 2,
    BkmxCanEditInStyleEither = 3
};
typedef enum BkmxCanEditInStyle_enum BkmxCanEditInStyle;

enum BkmxIxportLaunchBrowserPreference_enum {
    BkmxIxportLaunchBrowserPreferenceNever = -1,
    BkmxIxportLaunchBrowserPreferenceAuto = 0,
    BkmxIxportLaunchBrowserPreferenceAlways = 1
} ;
typedef enum BkmxIxportLaunchBrowserPreference_enum BkmxIxportLaunchBrowserPreference ;

 /*!
 @brief    Indicates the nature of the file path which may be
 watched by launchd to be notified when bookmarks of an external
 store for the current Mac user change.
 */
enum OwnerAppObservability_enum {
	OwnerAppObservabilityNone = 0,
	OwnerAppObservabilityOnQuit = 1,
	OwnerAppObservabilitySpecialFile = 2,
	OwnerAppObservabilityBookmarksFile = 4
} ;
typedef enum OwnerAppObservability_enum OwnerAppObservability ; 

enum Disposition_enum {
    kNone,
    kDeleteIt,
    kMarkAllowed
} ;
typedef enum Disposition_enum Disposition ;

enum LandDupeAction_enum {
    LandDupeActionAsk,
    LandDupeActionMerge,
    LandDupeActionCancel,
    LandDupeActionKeepBoth
} ;
typedef enum LandDupeAction_enum LandDupeAction ;

/*
 In the future, I should use -[BkmxDoc currentPerformanceType] more, instead
 of comparing NSApp, currentCommand or currentAppleScriptCommand to nil
 because these comparisons are kludgey and maybe fragile.
 */
enum BkmxPerformanceType_enum {
	BkmxPerformanceTypeUser = 0,      // in Main App, initiated manually by user clicking a command.  See note 20120712
	BkmxPerformanceTypeAgent = 1,    // in BkmxAgent
	BkmxPerformanceTypeScripted = 2,  // in Main App, AppleScripted
    /*
     Note 20120712.  Prior to BookMacster 1.11.6, BkmxPerformanceTypeUser = 4.  However, although
     I tested for that in many places, I in many of the user action methods, I did not set
     this value into the info dictionary, and even if I did set it into the info dictionary,
     the only place where I copied it from the info dictionary into the bkmxDoc's ivar is
     in -[SSYOperation beginWork], which is only queued if a command is queued by
     -[AgentPerformer performOverrideDeference:::::].  So it was never seen.  Now it seems that
     I am doing a good job of setting it in that method; it is, indeed, one of the
     parameters.  And it is reset it in -[SSYOperation terminateWorkInfo:].  So I decided
     that the best thing would be to eliminate BkmxPerformanceTypeNone, which had been
     0 and make BkmxPerformanceTypeUser = 0, which makes it the default when reading
     either the info dictionary or the BkmxDoc's ivar.   So it's a kind of
     defensive programming.
     */
} ;
typedef enum BkmxPerformanceType_enum BkmxPerformanceType ; 

#pragma mark * structs

/*!
 @brief    Reason why BkmxAgent has been summoned
 */
enum AgentReason_enum {
    AgentReasonNone = 0x00,
    AgentReasonStageSoon = 0x01,
    AgentReasonStageAsap = 0x02,
    AgentReasonStageRedo = 0x04
};
typedef enum AgentReason_enum AgentReason;

enum BkmxLogProcessType_enum {
    BkmxLogProcessTypeNone                 =  0,
    BkmxLogProcessTypeBkmxAgent            =  1,
    BkmxLogProcessTypeWorker               =  2,  // deprecated after BkmkMgrs 2.8.7
    BkmxLogProcessTypeMainAppScripted      =  3,  // deprecated in BookMacster 1.20.3
    BkmxLogProcessTypeSmarkyScripted       =  5,
    BkmxLogProcessTypeSynkmarkScripted     =  6,
    BkmxLogProcessTypeMarksterScripted     =  7,
    BkmxLogProcessTypeBookMacsterScripted  =  8,
    BkmxLogProcessTypeSmarky               =  9,
    BkmxLogProcessTypeSynkmark             = 10,
    BkmxLogProcessTypeMarkster             = 11,
    BkmxLogProcessTypeBookMacster          = 12,
    BkmxLogProcessTypeQuatch               = 13,   // deprecated after BkmkMgrs 2.8.7
} ;
typedef enum BkmxLogProcessType_enum BkmxLogProcessType ;

enum BkmxStatusItemStyle_enum {
    BkmxStatusItemStyleNone   = 0,
    BkmxStatusItemStyleFlat   = 10,
    BkmxStatusItemStyleGray   = 20
} ;
typedef enum BkmxStatusItemStyle_enum BkmxStatusItemStyle ;

enum BkmxTaskStatus_enum {
    BkmxTaskStatusNotDone   = 0,
    BkmxTaskStatusWaiting   = 1,
    BkmxTaskStatusAllDone   = 2
} ;
typedef enum BkmxTaskStatus_enum BkmxTaskStatus ;


struct BkmxMigrateResults_struct {
	NSInteger nCopied ;
	NSInteger nNotCopied ;
	NSInteger nExistingDeleted ;
	BOOL succeeded ;
} ;
typedef struct BkmxMigrateResults_struct BkmxMigrateResults ;

struct FolderStatistics_struct  {
	NSInteger nSubfolders ;
	NSInteger nBookmarks ;
} ;
typedef struct FolderStatistics_struct FolderStatistics ;

#pragma mark * Constants (defined in .m)

extern NSTimeInterval const constSheepSafariHelperTimeoutRead;
extern NSTimeInterval const constSheepSafariHelperTimeoutWrite;
extern NSTimeInterval const constSheepSafariHelperTimeoutPerLoad;

// Distributed Notifications
extern NSString* const constNoteBkmxMessageLogged ;
extern NSString* const constNameBkmxDistributedNote ;

extern NSString* const constUserNotificationActionIndentifierPresentError;
extern NSString* const constUserNotificationActionIndentifierShowHelpAnchor;

// Miscellaneous Junk
extern NSString* const constAll ;
extern NSString* const constKeyAgentRedoDelay;
extern NSString* const constAppNameBkmxAgent;
extern NSString* const constAppNameBookMacster ;
extern NSString* const constAppNameMarkster ;
extern NSString* const constAppNameSmarky ;
extern NSString* const constAppNameSynkmark ;
extern NSString* const constSawChange ;
extern NSString* const constCompanyName ;
extern NSString* const constKeyDontPauseSyncing ;
extern NSString* const constKeyIsNewBeNice;
extern NSString* const constSupportUrl ;
extern NSString* const constForumUrl ;
extern NSString* const constSupportArticlesUrl ;
extern NSString* const constLegacyAppProductUrl ;
extern NSString* const constSparkleFeedPrefix ;
extern NSString* const constSparkleFeedSuffix ;
extern NSString* const constEmDash ;
extern NSString* const constEllipsis ;
extern NSString* const constKeyCurrentValue ;
extern NSString* const constKeyExtoreName ;
extern NSString* const constKeyMaxValue ;
extern NSString* const constNonbreakingSpace ;
extern NSString* const constLegacyAppName ;
extern NSString* const constLegacyAppBundleIdentifier ;
extern NSString* const constLegacyHelperBundleIdentifier ;
extern NSInteger const constMinimumBookmarksChangeDelay2 ;
extern NSString* const constSeparatorLineForBookMacster ;
extern NSString* const constSeparatorLineForSafariHorizontal ;
extern NSString* const constSeparatorLineForSafariVertical ;
extern NSString* const constSeparatorUrlScheme;
extern NSString* const constSorryNullExtore  ; // Must match string in background.html in Chrome Extension
extern NSString* const constSorryNullProfile  ; // Must match string in background.html in Chrome Extension
extern NSString* const constKeyLaunchBrowserPref ;
extern NSString* const constKeyLogText;
extern NSString* const constKeyExitStatus;
extern NSString* const constKeySeverity ;
extern NSString* const constKeyStatus;
extern NSString* const constKeySummary;
extern NSString* const constKeyTimeoutTimer;
extern NSString* const constUrlBookmacsterizer ;
extern NSString* const constUrlBookmacsterizerSignaturePrefix ;
extern NSString* const constNameMomd ;
extern NSString* const constKeyRequiresVersion ;
extern NSString* const constKeyRetrialsRecommended;
extern NSString* const constKeySavedWithVersion ;
extern NSString* const constKeyExtensionName ;
extern NSString* const constKeyExtensionVersion ;
extern NSString* const constKeyExtension1Version ;
extern NSString* const constKeyExtension2Version ;
extern NSString* const constKeyProfileName ;
extern NSString* const constPortNameBookmacsterize ;
extern NSString* const constBkmxUrlScheme ;

// Entity names
extern NSString* const constEntityNameSyncer ;
extern NSString* const constEntityNameBookshig ;
extern NSString* const constEntityNameMacster ;
extern NSString* const constEntityNameClient ;
extern NSString* const constEntityNameClixid ;
extern NSString* const constEntityNameCommand ;
extern NSString* const constEntityNameDupe ;
extern NSString* const constEntityNameDupetainer ;
extern NSString* const constEntityNameErrorLog ;
extern NSString* const constEntityNameExporter ;
extern NSString* const constEntityNameFolderMap ;
extern NSString* const constEntityNameImporter ;
extern NSString* const constEntityNameIxporter ;
extern NSString* const constEntityNameImportLog ;
extern NSString* const constEntityNameExportLog ;
extern NSString* const constEntityNameIxportLog ;
extern NSString* const constEntityNameLog ;
extern NSString* const constEntityNameStarkoid ;
extern NSString* const constEntityNameMessageLog ;
extern NSString* const constEntityNameStark ;
extern NSString* const constEntityNameStarlobute ;
extern NSString* const constEntityNameStarxid ;
extern NSString* const constEntityNameTag ;
extern NSString* const constEntityNameTagMap ;
extern NSString* const constEntityNameTalderMap ;
extern NSString* const constEntityNameTrigger ;

// General-purpose keys, may be used by more than one class and User Defaults
extern NSString* const constKeyAliasRecords ;
extern NSString* const constKeyAppName ;
extern NSString* const constKeyAnyStarkCatchypeOrder ;
extern NSString* const constKeyAvailableDocAliasUuids ;
extern NSString* const constKeyCaseSensitive ;
extern NSString* const constKeyChoices;
extern NSString* const constKeyClidentifier ;
extern NSString* const constKeyClidentifiers ;
extern NSString* const constKeyClient ;
extern NSString* const constKeyClientoid;
extern NSString* const constKeyDepth ;
extern NSString* const constKeyDidSucceedInvocation ;
extern NSString* const constKeyDocUuid ;
extern NSString* const constKeyDoDisplay ;
extern NSString* const constKeyDoOnlyExporter;
extern NSString* const constKeyDoOnlyImportersArray;
extern NSString* const constKeyDoOnlyImportersSet;
extern NSString* const constKeyEfficiently;
extern NSString* const constKeyExformat ;
extern NSString* const constKeyError ;
extern NSString* const constKeyErrorCount ;
extern NSString* const constKeyExid ;
extern NSString* const constKeyIsActive ;
extern NSString* const constKeyIsTestRun ;
extern NSString* const constKeyIsAnImporter ;
extern NSString* const constKeyIsDoneSelectorName ;
extern NSString* const constKeyIxportBookmacsterizerOnly ;
extern NSString* const constKeyIxportLog ;
extern NSString* const constKeyIxportPolarity ;
extern NSString* const constKeyKey ;
extern NSString* const constKeyLaunchTimeoutTimer ;
extern NSString* const constKeyLastJobSerial;
extern NSString* const constKeyLogVerbosity;
extern NSString* const constKeyMacster ;
extern NSString* const constKeyIsDoneTarget ;
extern NSString* const constKeyIxporter ;
extern NSString* const constNoPid ;
extern NSString* const constKeySheepSafariHelperResultIssues;
extern NSString* const constKeySheepSafariHelperTrialsByDepthReport;
extern NSString* const constKeySheepSafariHelperResultLimboInsertionsCount;
extern NSString* const constKeySheepSafariHelperResultLimboRemovalsCount;
extern NSString* const constKeySheepSafariHelperResultLimboOrphanCount;
extern NSString* const constKeySheepSafariHelperResultLimboOrphanDisappearedCount;
extern NSString* const constKeySheepSafariHelperResultSafariFrameworkTattle;
extern NSString* const constKeySheepSafariHelperResultSaveResults;
extern NSString* const constKeySheepSafariHelperDidRequestSyncClientTrigger;
extern NSString* const constKeyParentExid ;
extern NSString* const constKeyPath ;
extern NSString* const constKeyPaths ;
extern NSString* const constKeyPreferredCatchype ;
extern NSString* const constKeyReport;
extern NSString* const constKeyShouldAddToKeychain ;
extern NSString* const constKeyShowInspectorOverride ;
extern NSString* const constKeySpecialOptions ;
extern NSString* const constKeyIxportingIndex;
extern NSString* const constKeyStark ;
extern NSString* const constKeyStarks ;
extern NSString* const constKeyString ;
extern NSString* const constKeySubjectUri ;
extern NSString* const constKeySucceeded;
extern NSString* const constKeySyncerIndex;
extern NSString* const constKeySyncerReason;
extern NSString* const constKeySyncerUri;
extern NSString* const constKeyTag ;
extern NSString* const constKeyTagsAdded ;
extern NSString* const constKeyTagsDeleted ;
extern NSString* const constKeyTimeout ;
extern NSString* const constKeyTimeoutForExidsInfo ;
extern NSString* const constKeyTrigger;
extern NSString* const constKeyTriggerIndex;
extern NSString* const constKeyTriggerCause;
extern NSString* const constKeyTriggers;
extern NSString* const constKeyTriggerUri ;
extern NSString* const constKeyUserCancelled ;
extern NSString* const constKeyUninhibitSecondsAfterDone ;
extern NSString* const constKeyWantsNewSubfolder ;
extern NSString* const constKeyWholeWords ;

// Keys passed to browser messenger or extension during Ixport via Extension operations
extern NSString* const constKeyTestNumber ;
extern NSString* const constKeyTestResult ;
extern NSString* const constKeyCuts ;
extern NSString* const constKeyPuts ;
extern NSString* const constKeyRepairs ;
extern NSString* const constKeyIsNew ;
extern NSString* const constKeyType ;
extern NSString* const BkmxConstTypeBookmark ;
extern NSString* const BkmxConstTypeFolder ;
extern NSString* const BkmxConstTypeSeparator ;
extern NSString* const BkmxConstTypeLivemark ;
extern NSString* const BkmxConstTypeRssArticle ;
extern NSString* const BkmxConstTypeFeedUrl ;
extern NSString* const BkmxConstTypeBar;
extern NSString* const BkmxConstTypeMenu;
extern NSString* const BkmxConstTypeUnfiled;
extern NSString* const BkmxConstTypeOhared;
extern NSString* const constKeyProgressMajorNum ;
extern NSString* const constKeyProgressMajorDen ;
extern NSString* const constKeyProgressMinorNum ;
extern NSString* const constKeyProgressMinorDen ;
// For Live Bookmarks (Livemarks), Firefox stores two URL; the regular URL
// and the feed URL.  We ignore the regular URL and only store the feed URL.
// Should fix that one of these days - would have to add another attribute
// to Stark.

// Keys used in staging dictionaries in user defaults
extern NSString* const constKeyAgentCause ;
extern NSString* const constKeyDateCreated;
extern NSString* const constKeyFireDate;
extern NSString* const constKeyStagedUri ;
extern NSString* const constKeySerialString;

// Keys to userInfo in SSYOperations
extern NSString* const constKeyActionName ;
extern NSString* const constKeyAgentDoesImport ;
extern NSString* const constKeyAgentIndex ;
extern NSString* const constKeyAgentUri ;
extern NSString* const constKeyDocument ;
extern NSString* const constKeyClientShouldSelfDestruct ;
extern NSString* const constKeyClientTask ;
extern NSString* const constKeyCloseWhenDone ;
extern NSString* const constKeyCompletionHandler ;
extern NSString* const constKeyConsolidateAndRemoveNow ;
extern NSString* const constKeyDocumentType ;
extern NSString* const constKeyKeepSourceNotDestin ;
extern NSString* const constKeyDeletedFolderLineages ;
extern NSString* const constKeyDidClaimBaton ;
extern NSString* const constKeyDidExportAnything ;
extern NSString* const constKeyDidImportAnything ;
extern NSString* const constKeyMergedFolderLineages ;
extern NSString* const constKeyDeference ;
extern NSString* const constKeyDidBeginUndoGrouping ;
extern NSString* const constKeyDidReadExternal ;
extern NSString* const constKeyDoIgnoreDisparateDupes ;
extern NSString* const constKeyDidMirror ;
extern NSString* const constKeyDidRevert ;
extern NSString* const constKeyDidSort ;
extern NSString* const constKeyDidTryWrite ;
extern NSString* const constKeyDocumentWasDirty ;
extern NSString* const constKeyDontStopOthersIfError ;
extern NSString* const constKeyDoReportDupes ;
extern NSString* const constKeyDupeDic ;
extern NSString* const constKeyFilePathParent ;
extern NSString* const constKeyHartainerSharypesRead;
extern NSString* const constKeyHartainerSharypesRemoved;
extern NSString* const constKeyExceptAllowed ;
extern NSString* const constKeyExtensionInstaller ;
extern NSString* const constKeyExtore ;
extern NSString* const constKeyExportFeedbackDic ;
extern NSString* const constKeyCountOfDeletedStarks ;
extern NSString* const constKeyGrandDoneInvocation ;
extern NSString* const constKeyIfNotNeeded ;
extern NSString* const constKeyIgnoreNoInternet ;
extern NSString* const constKeyIgnoreLimit ;
extern NSString* const constKeyIsLastBkmxDoc ;
extern NSString* const constKeyIsLastIxporter ;
extern NSString* const constKeyJob;
extern NSString* const constKeyJustInstallingExtension ;
extern NSString* const constKeyMoreDoneInvocations ;
extern NSString* const constKeyNoItemsToUpload ;
extern NSString* const constKeyBrowserPathsLaunched ;
extern NSString* const constKeyLegacyItemProps ;
extern NSString* const constKeyNewExidsCount ;  // Appears to be set OK, but not used for anything.  BookMacster version 1.3.5.
extern NSString* const constKeyOverlayClient ;
extern NSString* const constKeyPauseSyncersIfUserCancelsExport ;
extern NSString* const constKeyPerformanceType ;
extern NSString* const constKeyPlusAllFailed ;
extern NSString* const constKeyRootStark ;
extern NSString* const constKeyBrowserPathQuit ;
extern NSString* const constKeySaveOperation ;
extern NSString* const constKeySecondPrep ;
extern NSString* const constKeyShouldInstallExtension1 ;
extern NSString* const constKeySkipImportNoChanges ;
extern NSString* const constKeyStarkload ;
extern NSString* const constKeySuffixesFileCopied ;
extern NSString* const constKeySafariLockDirectories ;
extern NSString* const constKeyUnflaggedImportClients;
extern NSString* const constKeyVerifySince ;
extern NSString* const constKeyWaitInterval ;

// Method Placeholders
#define DEFAULT_IMPORT_METHOD constMethodPlaceholderImport1
/* Maybe that should be constMethodPlaceholderImportAll? */
extern NSString* const constMethodPlaceholderImport1 ;
extern NSString* const constMethodPlaceholderImportAll ;
extern NSString* const constMethodPlaceholderExport1 ;
extern NSString* const constMethodPlaceholderExportAll ;

// Notifications
extern NSString* const constNoteBkmxWindowsDidRearrange ;
extern NSString* const constNoteBkmxDidFinishSaving;
extern NSString* const constNoteBkmxFindResultsNeedRefresh ;
extern NSString* const constNoteBkmxAgentRunnerUpdateNeeded ;
extern NSString* const constNoteBkmxSelectionDidChange ;
extern NSString* const constNoteBkmxSyncerDidChange ;
extern NSString* const constNoteBkmxClientDidChange ;
extern NSString* const constNoteBkmxMacsterDidChange ;

// Pboard Types
extern NSString* const constBkmxPboardTypeDraggableStark;  // used for drag and drop
extern NSString* const constBkmxPboardTypeStark ; // used for copy and paste
extern NSString* const constBkmxPboardTypeSafariLegacy;
extern NSString* const constBkmxPboardTypeSafari;

// Extore Media Types

extern NSString* const constBkmxExtoreMediaUnknown ;
extern NSString* const constBkmxExtoreMediaThisUser ;
extern NSString* const constBkmxExtoreMediaFTP ;
extern NSString* const constBkmxExtoreMediaLoose ;

// Hartainer symbols used in Xbel metadata
extern NSString* const constBkmxSymbolHartainerBar ;
extern NSString* const constBkmxSymbolHartainerMenu ;
extern NSString* const constBkmxSymbolHartainerUnfiled ;
extern NSString* const constBkmxSymbolHartainerOhared ;

// Exformat names - Local Apps
extern NSString* const constExformatBraveBeta;
extern NSString* const constExformatBravePublic;
extern NSString* const constExformatCanary ;
extern NSString* const constExformatChrome ;
extern NSString* const constExformatChromium ;
extern NSString* const constExformatEdge ;
extern NSString* const constExformatEdgeBeta ;
extern NSString* const constExformatEdgeDev ;
extern NSString* const constExformatEpic ;
extern NSString* const constExformatFirefox ;
extern NSString* const constExformatHtml ;
extern NSString* const constExformatICab ;
extern NSString* const constExformatOmniweb ;
extern NSString* const constExformatOpera ;
extern NSString* const constExformatOperaAir ;
extern NSString* const constExformatOrion ;
extern NSString* const constExformatSafari ;
extern NSString* const constExformatVivaldi ;
extern NSString* const constExformatXbel ;

// Exformat names - Web Apps
extern NSString* const constExformatDiigo ;
extern NSString* const constExformatPinboard ;

// Preferences (User Defaults) Keys

// Root Preference Keys
extern NSString* const constKeyGeneralUninhibitDate ;
extern NSString* const constKeyUninhibitDatesPerTriggerCause ;
/*!
 @brief    A dictionary whose keys are Syncer URI, and whose values are
 NSData archives of Jobs.  Jobs now include the date staging was set, and
 the staging fire date.
 */
extern NSString* const constKeyAgentStagings;
extern NSString* const constKeyAlertFailure ;
extern NSString* const constKeyAlertStage ;
extern NSString* const constKeyAlertStart ;
extern NSString* const constKeyAlertSuccess ;
extern NSString* const constKeyAltKeyInspectsLander ;
/*!
 @details  This value is effectively a BOOL, for new users that started with
 BookMacster 1.19.  By default it is 1, and it only increases once, to 2, when
 a second document is added after user clicks "Keep Both".  It never increases
 beyond 2.
 */
extern NSString* const constKeyBkmxDocsWarningLimit ;
extern NSString* const constKeyBookmarksChangeDelay1 ;
extern NSString* const constKeyBookmarksChangeDelay2 ;
extern NSString* const constKeyBookmarksInDoxtus ;
extern NSString* const constKeyBrowserWeQuitDates;
extern NSString* const constKeyClientsLastChangeWrittenDate ;
extern NSString* const constKeyClientsLastImportPreHash;
extern NSString* const constKeyClientsLastImportPostHash;
extern NSString* const constKeyClientsLastExportPreHash;
extern NSString* const constKeyClientsLastExportPostHash;
extern NSString* const constKeyClientsDirt;
extern NSString* const constKeyColorSortable ;
extern NSString* const constKeyColorUnsortable ;
extern NSString* const constKeyColorSort;
extern NSString* const constKeyColorUnsort;
extern NSString* const constKeyColumnWidths ;
extern NSString* const constKeyCompositeImportSettingsHash;
extern NSString* const constKeyDidWarnBrave1_7;
extern NSString* const constKeyDidWarnExpiringSoonV3;
extern NSString* const constKeyDefaultCruftSpecs ;
extern NSString* const constKeyLastJsonExport ;
extern NSString* const constKeyDispose302Perm ;
extern NSString* const constKeyDispose302Unsure ;
/*!
 @brief    A dictionary where keys are document uuid strings
 and values are file aliases.
*/
extern NSString* const constKeyDocAliasRecords ;
/*!
 @brief    A dictionary where keys are document uuid strings
 and values are display names, populated with only 
 recent documents.
 */
extern NSString* const constKeyDocLastSaveToken ;
extern NSString* const constKeyDontShowDragTips ;
extern NSString* const constKeyDocRecentDisplayNames ;
extern NSString* const constKeyDontWarnBadCommandEnd ;
extern NSString* const constKeyDontWarnExport ;
extern NSString* const constKeyDontWarnMultiDocSyncers ;
extern NSString* const constKeyDontWarnOtherMacBrowsers ;
extern NSString* const constKeyDontWarnSyncingSuspended;
extern NSString* const constKeyDontWarnV3UpgradeNeeded;
extern NSString* const constKeyDontWelcome ;
extern NSString* const constKeyDoOpenAfterLaunchUuids ;
extern NSString* const constKeyForceStyle1Client ;
/*!
 @brief    Specifies how many failures are acceptable and
 what success rate is acceptable when obtaining exids of items
 during round 2 of getting exids.

 @details  Integer part specifies number acceptable and
 fractional part specifies required success rate.&nbsp; 
 If either test fails, error is generated and user alerted. */
extern NSString* const constKeyExidFailureRateAllowed ;
extern NSString* const constKeyExidFailuresAllowed ;
/*!
 @brief    When a new ixport log is inserted, if there are more
 than this number, the oldest one is deleted.
 */
extern NSString* const constKeyDaysLog ;
extern NSString* const constKeyDaysIxportDiary ;
extern NSString* const constKeyDoxtusShowHideQuitMenuItemsPosition;
extern NSString* const constKeyFightThreshold ;
extern NSString* const constKeyLimitDefaultExport ;
extern NSString* const constKeyLimitDefaultImport ;
extern NSString* const constKeyHideErrors ;
extern NSString* const constICloudFolderLimit;
extern NSString* const constKeyIgnoredPrefixes ;
extern NSString* const constKeyIgnoreNextLoginTrigger ;
extern NSString* const constKeyInspectorWasShowing ;
extern NSString* const constKeyKeepLegacyArtifacts ;
extern NSString* const constKeyLandCommentsLimit ;
extern NSString* const constKeyLandingRecents ;
extern NSString* const constKeyLandDupeAction ;
extern NSString* const constKeyLastDateDragTipsShown ;
extern NSString* const constKeyLastLocalFileCruftCleaning;
extern NSString* const constKeyLandWithSound ;
extern NSString* const constKeyLaunchInBackground ;
extern NSString* const constKeyLaunchQuietlyNextTime ;
extern NSString* const constKeyLocalMocSyncs ;
extern NSString* const constKeyDebugIxportHashes;
extern NSString* const constKeyDebugTraceVerbosity;
extern NSString* const constKeyMiniSearchRecents ;
extern NSString* const constKeyMinExportLimit ;
extern NSString* const constKeyMiniSearchPosition ;
extern NSString* const constKeyQuickSearchParms ;
extern NSString* const constKeyReadStyle2TxTimeout ;
extern NSString* const constKeyRecentQuits ;
extern NSString* const constKeySafariMoreAgentSecs;
extern NSString* const constKeySafariCullForThomas;
extern NSString* const constKeySafariPushCountSheepSafariHelper;
extern NSString* const constKeySafariPushCountThomas;
extern NSString* const constKeySafariPushLastSheepSafariHelper;
extern NSString* const constKeySafariPushLastThomas;
extern NSString* const constKeySafariPushStyle;
extern NSString* const constKeySafariPushPriorCkms;
extern NSString* const constKeySendPerformanceData;
extern NSString* const constKeyShoeboxSafeSyncLimit ;
extern NSString* const constKeyShortcutAnywhereMenu ;
extern NSString* const constKeyShortcutAddQuickly ;
extern NSString* const constKeyShortcutAddAndInspect ;
/*!
 @brief    A Boolean which stores whether or not to show the
 Status Menu (NSStatusItem, "Status Item", "menu extra") for the app.
*/
extern NSString* const constKeyStatusItemStyle ;
extern NSString* const constKeySortShoeboxDuringSyncs ;
extern NSString* const constKeySoundFailMinor ;
extern NSString* const constKeySoundFailMajor ;
extern NSString* const constKeySoundStage ;
extern NSString* const constKeySoundStart ;
extern NSString* const constKeySoundSuccess ;
extern NSString* const constKeySyncFirefoxOnQuit ;
extern NSString* const constKeySyncSnapshotsLimitMB ;
extern NSString* const constKeyTableFontSize ;
extern NSString* const constKeyMenuFontSize ;
extern NSString* const constKeyTagDelimiterDefault ;
extern NSString* const constKeyTagDelimiterReplacement ;
extern NSString* const constKeyTextCopyTemplate;
extern NSString* const constKeyThrottlePeriod ;
extern NSString* const constKeyTriggerBlinderKeys ;
extern NSString* const constKeyUserHasBeenToldAboutBkmxNotifierA;
extern NSString* const constKeyWaitAfterLogin;
extern NSString* const constKeyWaitAfterWake;
extern NSString* const constKeyWatches ;
extern NSString* const constKeyVisitWarningThreshold ;
/*!
 @brief    Boolean, indicates whether or not preferences
 from the cross/upgrade app have been imported.
 */
extern NSString* const constKeyXugradeImported ;
extern NSString* const constKeyYellowSyncExplained;

// Autosave keys
extern NSString* const constKeyDocAutosaves ;
extern NSString* const constAutosaveTabs ;
extern NSString* const constAutosaveOutlineMode ;
extern NSString* const constAutosaveSearchOptions ;
extern NSString* const constAutosaveSearchFor ;
extern NSString* const constAutosaveSearchIn ;
extern NSString* const constAutosaveWindowFrame ;
extern NSString* const constAutosaveTabContentSizes ;
extern NSString* const constAutosaveContentSplitView ;
extern NSString* const constAutosaveContentTableColumns ;
extern NSString* const constAutosaveFindTableColumns ;
extern NSString* const constAutosaveDupesTableColumns ;
extern NSString* const constAutosaveRecentLandings ;
extern NSString* const constAutosaveTabTop ;
extern NSString* const constAutosavePrefsWindow ;


// Preferences Window Names used for autosaving window positions
extern NSString* const constWindowNameInspector ;


// Stark Properties
extern NSString* const constKeyAddDate ;
extern NSString* const constKeyColor ;
extern NSString* const constKeyComments ;
extern NSString* const constKeyExids ;
extern NSString* const constKeyFavicon ;
extern NSString* const constKeyFaviconUrl ;
extern NSString* const constKeyIsAllowedDupe ;
extern NSString* const constKeyIsAutoTab ;
extern NSString* const constKeyIsExpanded ;
extern NSString* const constKeyClients ;
extern NSString* const constKeyDontExportExformats ;
extern NSString* const constKeyDontVerify ;
extern NSString* const constKeyDupe ;
extern NSString* const constKeyIsShared ;
extern NSString* const constKeySortable ;
extern NSString* const constKeySortDirective ;
extern NSString* const constKeyLastChengDate ;
extern NSString* const constKeyLastModifiedDate ;
extern NSString* const constKeyLastVisitedDate ;
extern NSString* const constKeyMaster ;
extern NSString* const constKeyName ;
extern NSString* const constKeyOwnerValues ;
extern NSString* const constKeySharype ;
extern NSString* const constKeyOperaPanelPosition ;
extern NSString* const constKeyOperaPersonalBarPosition ;
extern NSString* const constKeyRating ;
extern NSString* const constKeyRssArticles ;
extern NSString* const constKeyShortcut ;
extern NSString* const constKeySharype ;
extern NSString* const constKeySharypeCoarse ;
extern NSString* const constKeyStarkid ;
extern NSString* const constKeyEffectiveIndex ;
extern NSString* const constKeySponsorIndex ;
extern NSString* const constKeySponsoredIndex ;
extern NSString* const constKeyTags ;
extern NSString* const constKeyTagsString ;
extern NSString* const constKeyToRead ;
extern NSString* const constKeyUrl ;
extern NSString* const constKeyUrlOrStats ;
extern NSString* const constKeyVerifierAdviceArray ;
extern NSString* const constKeyVerifierAdviceMultiLiner ;
extern NSString* const constKeyVerifierAdviceOneLiner ;
extern NSString* const constKeyVerifierCode ;
extern NSString* const constKeyVerifierCodeUsingHttps ;
extern NSString* const constKeyVerifierDetails ;
extern NSString* const constKeyVerifierDisposition ;
extern NSString* const constKeyVerifierHeaderGetter ;
extern NSString* const constKeyVerifierNeedsRetest ;
extern NSString* const constKeyVerifierLastDate ;
extern NSString* const constKeyVerifierLastResult ;
extern NSString* const constKeyVerifierNsErrorDomain ;
extern NSString* const constKeyVerifierPriorUrl ;
extern NSString* const constKeyVerifierReason ;
extern NSString* const constKeyVerifierStark ;
extern NSString* const constKeyVerifierSubtype302 ;
extern NSString* const constKeyVerifierSuggestedUrl ;
extern NSString* const constKeyVerifierUrl ;
extern NSString* const constKeyVisitCount ;
extern NSString* const constKeyVisitCountString ;
extern NSString* const constKeyVisitor ;  // also a Bookshig attribute
extern NSString* const constKeyVisitorWindowFrame ;


// Column Identifiers
extern NSString* const constKeyPhrase ;
extern NSString* const constKeyTrailingSpace ;


// Other KVO Keys
extern NSString* const constKeySyncer ;

// Error Domains
extern NSString* const constBkmxAgentErrorDomain ;
extern NSString* const SheepSafariHelperErrorDomain;

// Error Keys
extern NSString* const SSYDocumentUuidErrorKey ;
extern NSString* const SSYDocumentAliasDataErrorKey ;
extern NSString* const constKeyProblemKey ;
extern NSString* const constKeyBadAgentIndex ;
extern NSString* const constKeyBadCommandIndex ;
extern NSString* const constKeyTagDelimiterActual ;

