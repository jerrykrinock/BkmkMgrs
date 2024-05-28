#import <Cocoa/Cocoa.h>
#import "BkmxGlobals.h"

#if DEBUG
BOOL gDoLog = NO ;
#endif

/*SSYDBL*/ /* Just a test to see if you searched correctly for that. */

NSTimeInterval const constSheepSafariHelperTimeoutRead = 59.4288;
NSTimeInterval const constSheepSafariHelperTimeoutWrite = 74.4299;
NSTimeInterval const constSheepSafariHelperTimeoutPerLoad = 4.789;

// Distributed Notifications
NSString* const constNameBkmxDistributedNote = @"BkmxDistributedNote" ;

// Action Identifiers to BkmxNotifier
NSString* const constUserNotificationActionIndentifierPresentError = @"userNotificationActionIndentifierPresentError";
NSString* const constUserNotificationActionIndentifierShowHelpAnchor = @"userNotificationActionIndentifierShowHelpAnchor";

// Miscellaneous Junk
__attribute__((visibility("default"))) NSString* const constAll = @"all" ;
__attribute__((visibility("default"))) NSString* const constKeyAgentRedoDelay = @"agentRedoDelay";
NSString* const constAppNameBkmxAgent = @"BkmxAgent" ;
NSString* const constAppNameBookMacster = @"BookMacster" ;
NSString* const constAppNameMarkster = @"Markster" ;
NSString* const constAppNameSmarky = @"Smarky" ;
NSString* const constAppNameSynkmark = @"Synkmark" ;
__attribute__((visibility("default"))) NSString* const constSawChange = @"sawChange" ;
NSString* const constCompanyName = @"Sheep Systems" ;
NSString* const constKeyCurrentValue = @"currentValue" ;
NSString* const constKeyDontPauseSyncing = @"dontPauseSyncing" ;
NSString* const constKeyIsNewBeNice = @"isNewBeNice" ;
NSString* const constKeyLaunchBrowserPref = @"launchBrowserPref" ;
NSString* const constKeyLogText = @"logText";
NSString* const constKeyMaxValue = @"maxValue" ;
__attribute__((visibility("default"))) NSString* const constKeyExitStatus = @"exitStatus";
NSString* const constKeySeverity = @"severity" ;
NSString* const constKeyStatus = @"status";
__attribute__((visibility("default"))) NSString* const constKeySummary = @"summary";
NSString* const constKeyTimeoutTimer = @"timeoutTimer";
NSString* const constSupportUrl = @"https://www.sheepsystems.com/support/" ;
NSString* const constForumUrl = @"https://sheepsystems.com/discuss/YaBB.pl?board=" ;
NSString* const constSupportArticlesUrl = @"https://www.sheepsystems.com/files/support_articles/bkmx/" ;
NSString* const constLegacyAppProductUrl = @"https://sheepsystems.com/products/bookdog" ;
NSString* const constSparkleFeedPrefix = @"https://sheepsystems.com" ;
NSString* const constSparkleFeedSuffix = @"appcast.xml" ;
NSString* const constEmDash = @"\u2014" ;
NSString* const constEllipsis = @"\u2026" ;
NSString* const constNonbreakingSpace = @"\u00a0" ;
__attribute__((visibility("default"))) NSString* const constLegacyAppName = @"Bookdog" ;
__attribute__((visibility("default"))) NSString* const constLegacyAppBundleIdentifier = @"com.sheepsystems.Bookdog" ;
__attribute__((visibility("default"))) NSInteger const constMinimumBookmarksChangeDelay2 = 10 ;
__attribute__((visibility("default"))) NSString* const constKeySheepSafariHelperResultSafariFrameworkTattle = @"safariFrameworkTattle";
__attribute__((visibility("default"))) NSString* const constKeySheepSafariHelperResultIssues = @"issues";
__attribute__((visibility("default"))) NSString* const constKeySheepSafariHelperTrialsByDepthReport = @"trialsByDepthReport";
__attribute__((visibility("default"))) NSString* const constKeySheepSafariHelperResultLimboInsertionsCount = @"limboInsertionsCount";
__attribute__((visibility("default"))) NSString* const constKeySheepSafariHelperResultLimboRemovalsCount = @"limboRemovalsCount";
__attribute__((visibility("default"))) NSString* const constKeySheepSafariHelperResultLimboOrphanCount = @"limboOrphanCount";
__attribute__((visibility("default"))) NSString* const constKeySheepSafariHelperResultLimboOrphanDisappearedCount = @"limboOrphanDisappearedCount";
__attribute__((visibility("default"))) NSString* const constKeySheepSafariHelperResultSaveResults = @"saveResults";
__attribute__((visibility("default"))) NSString* const constKeySheepSafariHelperDidRequestSyncClientTrigger = @"didRequestSyncClientTrigger";
__attribute__((visibility("default"))) NSString* const constNoPid = @"noPid" ;
NSString* const constSeparatorLineForBookMacster = @"\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500" ;
// The above is eight repititions E2 94 80, which is the UTF-8 representation of Unicode code point 0x2500, a horizontal line from the Box Drawing set
NSString* const constSeparatorLineForSafariHorizontal = @"\u2500\u2500\u2500\u2500\u2500" ;
// The above is five repititions E2 94 80, which is the UTF-8 representation of Unicode code point 0x2500, a horizontal line from the Box Drawing set
NSString* const constSeparatorLineForSafariVertical = @"\u2507" ;
// The above E2 94 87, is the UTF-8 representation of Unicode code point 0x2507, a dashed vertical line from the Box Drawing set
NSString* const constSeparatorUrlScheme = @"separator://";
__attribute__((visibility("default"))) NSString* const constSorryNullExtore = @"SORRY-NULL-EXTORE"  ; // Must match string in background.html in Chrome Extension
__attribute__((visibility("default"))) NSString* const constSorryNullProfile = @"SORRY-NULL-PROFILE"  ; // Must match string in background.html in Chrome Extension
NSString* const constUrlBookmacsterizer = @"javascript:document.location.href='bookmacster://add?url='+encodeURIComponent(location.href)+'&name='+encodeURIComponent(document.title)+'&comments='+encodeURIComponent(window.getSelection())+'&userAgent='+encodeURIComponent(navigator.userAgent);" ;
NSString* const constUrlBookmacsterizerSignaturePrefix = @"javascript:document.location.href='bookmacster://add?" ;
NSString* const constNameMomd = @"BookMacster" ;
NSString* const constKeyRequiresVersion = @"RequiresVersion" ;
NSString* const constKeyRetrialsRecommended = @"retrialsRecommended";
NSString* const constKeySavedWithVersion = @"SavedWithVersion" ;
__attribute__((visibility("default"))) NSString* const constKeyExtensionName = @"extensionName";
__attribute__((visibility("default"))) NSString* const constKeyExtensionVersion = @"extensionVersion" ;
NSString* const constKeyExtension1Version = @"extension1Version" ;
NSString* const constKeyExtension2Version = @"extension2Version" ;
__attribute__((visibility("default"))) NSString* const constKeyExtoreName = @"extoreName" ;
__attribute__((visibility("default"))) NSString* const constKeyProfileName = @"profileName" ;
NSString* const constPortNameBookmacsterize = @"com.sheepsystems.BookMacster.bookmacsterize" ;
NSString* const constBkmxUrlScheme = @"bookmacster" ;

// Entity names
NSString* const constEntityNameBookshig = @"Bookshig_entity" ;
NSString* const constEntityNameMacster = @"Macster_entity" ;
NSString* const constEntityNameClient = @"Client_entity" ;
NSString* const constEntityNameClixid = @"Clixid_entity" ;
NSString* const constEntityNameCommand = @"Command_entity" ;
NSString* const constEntityNameDupetainer = @"Dupetainer_entity" ;
NSString* const constEntityNameExporter = @"Exporter_entity" ;
NSString* const constEntityNameErrorLog = @"ErrorLog_entity" ;
NSString* const constEntityNameFolderMap = @"FolderMap_entity" ;
NSString* const constEntityNameImporter = @"Importer_entity" ;
NSString* const constEntityNameIxporter = @"Ixporter_entity" ;
NSString* const constEntityNameSyncer = @"Syncer_entity" ;
NSString* const constEntityNameImportLog = @"ImportLog_entity" ;
NSString* const constEntityNameExportLog = @"ExportLog_entity" ;
NSString* const constEntityNameIxportLog = @"IxportLog_entity" ;
NSString* const constEntityNameLog = @"Log_entity" ;
NSString* const constEntityNameMessageLog = @"MessageLog_entity" ;
NSString* const constEntityNameStarkoid = @"Starkoid_entity" ;
NSString* const constEntityNameDupe = @"Dupe_entity" ;
NSString* const constEntityNameStark = @"Stark_entity" ;
NSString* const constEntityNameStarlobute = @"Starlobute_entity" ;
NSString* const constEntityNameStarxid = @"Starxid_entity" ;
NSString* const constEntityNameTalderMap = @"TalderMap_entity" ;
NSString* const constEntityNameTag = @"Tag_entity" ;
NSString* const constEntityNameTagMap = @"TagMap_entity" ;
NSString* const constEntityNameTrigger = @"Trigger_entity" ;

// General-purpose keys, may be used by more than one class and User Defaults
NSString* const constKeyAliasRecords = @"aliasRecords" ;
__attribute__((visibility("default"))) NSString* const constKeyAppName = @"appName" ;
NSString* const constKeyAnyStarkCatchypeOrder = @"anyStarkCatchypeOrder" ;
__attribute__((visibility("default"))) NSString* const constKeyAvailableDocAliasUuids = @"availableDocAliasUuids" ;
NSString* const constKeyCaseSensitive = @"caseSensitive" ;
NSString* const constKeyChoices = @"choices";
NSString* const constKeyClidentifier = @"clidentifier" ;
NSString* const constKeyClidentifiers = @"clidentifiers" ;
NSString* const constKeyClient = @"client" ;
NSString* const constKeyClientoid = @"clientoid";
NSString* const constKeyDepth = @"depth" ;
NSString* const constKeyDidSucceedInvocation = @"didSucceedInvocation" ;
__attribute__((visibility("default"))) NSString* const constKeyDocUuid = @"docUuid" ;
NSString* const constKeyDoDisplay = @"doDisplay" ;
NSString* const constKeyDoOnlyExporter = @"doOnlyExporter";
NSString* const constKeyDoOnlyImportersArray = @"doOnlyImportersArray";
NSString* const constKeyDoOnlyImportersSet = @"doOnlyImportersSet";
NSString* const constKeyEfficiently= @"efficiently";
NSString* const constKeyExformat = @"exformat" ;
NSString* const constKeyExporters = @"exporters" ;
NSString* const constKeyError = @"error" ;
NSString* const constKeyErrorCount = @"errorCount" ;
NSString* const constKeyExid = @"exid" ;
NSString* const constKeyIsActive = @"isActive" ;
NSString* const constKeyIsAnImporter = @"isAnImporter" ;
NSString* const constKeyIsTestRun = @"isTestRun" ;
NSString* const constKeyIsDoneSelectorName = @"isDoneSelectorName" ;
NSString* const constKeyIsDoneTarget = @"isDoneTarget" ;
NSString* const constKeyIxporter = @"ixporter" ;
NSString* const constKeyIxportBookmacsterizerOnly = @"ixportBookMacsterizerOnly" ;
NSString* const constKeyIxportLog = @"ixportLog" ;
NSString* const constKeyIxportPolarity = @"ixportPolarity" ;
NSString* const constKeyKey = @"key" ;
NSString* const constKeyLaunchTimeoutTimer = @"launchTimeoutTimer" ;
NSString* const constKeyLastJobSerial = @"lastJobSerial";
NSString* const constKeyLogVerbosity = @"logVerbosity";
NSString* const constKeyMacster = @"macster" ;
NSString* const constKeyParentExid = @"parentExid" ;
NSString* const constKeyPath = @"path" ;
NSString* const constKeyPaths = @"paths" ;
NSString* const constKeyPreferredCatchype = @"preferredCatchype" ;
NSString* const constKeyReport = @"report";
NSString* const constKeyShouldAddToKeychain = @"shouldAddToKeychain" ;
NSString* const constKeyShowInspectorOverride = @"showInspectorOverride" ;
NSString* const constKeySpecialOptions = @"specialOptions" ;
NSString* const constKeySucceeded = @"succeeded" ;
NSString* const constKeyStark = @"stark" ;
NSString* const constKeyStarks = @"starks" ;
NSString* const constKeyString = @"string" ;
NSString* const constKeySubjectUri = @"subjectUri";
NSString* const constKeySyncerIndex = @"syncerIndex";
NSString* const constKeySyncerReason = @"syncerReason";
NSString* const constKeySyncerUri = @"syncerUri";
NSString* const constKeyTag = @"tag" ;
NSString* const constKeyTagsAdded = @"tagsAdded" ;
NSString* const constKeyTagsDeleted = @"tagsDeleted" ;
NSString* const constKeyTimeout = @"timeout" ;
NSString* const constKeyTimeoutForExidsInfo = @"timeoutForExidsInfo" ;
// NSString* const constKeyThisUserIxportStartDate = @"thisUserIxportStartDate" ;  // Removed in BookMacster 1.11
NSString* const constKeyTrigger = @"trigger";
NSString* const constKeyTriggerCause = @"triggerCause";
NSString* const constKeyTriggerIndex = @"triggerIndex";
NSString* const constKeyTriggers = @"triggers" ;
__attribute__((visibility("default"))) NSString* const constKeyTriggerUri = @"triggerUri" ;
NSString* const constKeyUserCancelled = @"userCanceled" ;
NSString* const constKeyUninhibitSecondsAfterDone = @"uninhibitSecondsAfterDone" ;
NSString* const constKeyWantsNewSubfolder = @"wantsNewSubfolder" ;
NSString* const constKeyWholeWords = @"wholeWords" ;

// Keys passed to browser messenger or extension during Ixport via Extension operations
// Warning: These are also used in Javascript files in extensions,
// so if you want to change, you must change in Javascript too.
// In addition, those commented // Firefox Bookmarks API are one of 
// the possible values of the 'type' property returned by
// Application.Bookmarks.Xxxx and the 'children' of these
// objects.
NSString* const constKeyTestNumber = @"testNumber" ;
NSString* const constKeyTestResult = @"testResult" ;
NSString* const constKeyCuts = @"cuts" ;
NSString* const constKeyPuts = @"puts" ;
NSString* const constKeyRepairs = @"repairs" ;
NSString* const constKeyIsNew = @"isNew" ;
NSString* const constKeyType = @"type";
NSString* const BkmxConstTypeBookmark = @"bookmark" ;     // Firefox Bookmarks API 
NSString* const BkmxConstTypeFolder = @"folder" ;         // Firefox Bookmarks API and Chrome JSON file (Style 1)
NSString* const BkmxConstTypeSeparator = @"separator" ;   // Firefox Bookmarks API 
NSString* const BkmxConstTypeLivemark = @"livemark" ;
NSString* const BkmxConstTypeRssArticle = @"article" ;
NSString* const BkmxConstTypeFeedUrl = @"feedUrl" ;
NSString* const BkmxConstTypeBar = @"bar" ;  
NSString* const BkmxConstTypeMenu = @"menu" ;
NSString* const BkmxConstTypeUnfiled = @"unfiled" ;
NSString* const BkmxConstTypeOhared = @"ohared" ;
NSString* const constKeyProgressMajorNum = @"progressMajorNum" ;
NSString* const constKeyProgressMajorDen = @"progressMajorDen" ;
NSString* const constKeyProgressMinorNum = @"progressMinorNum" ;
NSString* const constKeyProgressMinorDen = @"progressMinorDen" ;

// Keys used in staging dictionaries in user defaults
__attribute__((visibility("default"))) NSString* const constKeyAgentCause = @"cause" ;
__attribute__((visibility("default"))) NSString* const constKeyDateCreated = @"dateCreated" ;
__attribute__((visibility("default"))) NSString* const constKeyFireDate = @"fireDate" ;
__attribute__((visibility("default"))) NSString* const constKeyStagedUri = @"stagedUri" ;
__attribute__((visibility("default"))) NSString* const constKeySerialString = @"serialString" ;

// Keys to userInfo in SSYOperations
NSString* const constKeyActionName = @"actionName" ;
NSString* const constKeyAgentDoesImport = @"agentDoesImport" ;
NSString* const constKeyAgentIndex = @"agentIndex" ;
NSString* const constKeyAgentUri = @"agentUri" ;
NSString* const constKeyDocument = @"document" ;
NSString* const constKeyClientShouldSelfDestruct = @"clientShouldSelfDestruct" ;
NSString* const constKeyClientTask = @"clientTask" ;
NSString* const constKeyCloseWhenDone = @"closeWhenDone" ;
NSString* const constKeyCompletionHandler = @"completionHandler" ;
NSString* const constKeyConsolidateAndRemoveNow = @"consolidateAndRemoveNow" ;
NSString* const constKeyCountOfDeletedStarks = @"countDelStarks" ;
NSString* const constKeyDeletedFolderLineages = @"deletedFolderLineages" ;
NSString* const constKeyDocumentType = @"documentType" ;
NSString* const constKeyMergedFolderLineages = @"mergedFolderLineages" ;
NSString* const constKeyDeference = @"deference" ;
NSString* const constKeyDidBeginUndoGrouping = @"didBeginUndoGrouping" ;
NSString* const constKeyDidClaimBaton = @"didClaimBaton";
NSString* const constKeyDidExportAnything = @"didExportAnything" ;
NSString* const constKeyDidImportAnything = @"didImportAnything" ;
NSString* const constKeyDidReadExternal = @"didReadExternal" ;
NSString* const constKeyDoIgnoreDisparateDupes = @"doIgnoreDispDupes" ;
NSString* const constKeyDidMirror = @"didMirror" ;
NSString* const constKeyDidRevert = @"didRevert" ;
NSString* const constKeyDidSort = @"didSort" ;
NSString* const constKeyDidTryWrite = @"didTryWrite" ;
NSString* const constKeyDocumentWasDirty = @"documentWasDirty" ;
NSString* const constKeyDontStopOthersIfError = @"dontStopOthersIfError" ;
NSString* const constKeyDoReportDupes = @"doReportDupes" ;
NSString* const constKeyExceptAllowed = @"exceptAllowed" ;
NSString* const constKeyExtore = @"extore" ;
NSString* const constKeyExportFeedbackDic = @"exportFeedbackDic" ;
NSString* const constKeyDupeDic = @"dupeDic" ;
NSString* const constKeyFilePathParent = @"filePathParent" ;
NSString* const constKeyHartainerSharypesRead = @"hartainerSharypesRead";
NSString* const constKeyHartainerSharypesRemoved = @"hartainerSharypesWritten";
NSString* const constKeyGrandDoneInvocation = @"grandDoneInvocation" ;
NSString* const constKeyIfNotNeeded = @"ifNotNeeded" ;
NSString* const constKeyIgnoreNoInternet = @"ignoreNoInternet" ;
NSString* const constKeyIgnoreLimit = @"ignoreLimit" ;
NSString* const constKeyIsLastBkmxDoc = @"isLastBkmxDoc" ;
NSString* const constKeyIsLastIxporter = @"isLastIxporter" ;
NSString* const constKeyJob = @"job";
NSString* const constKeyJustInstallingExtension = @"justInstallingExtension" ;
NSString* const constKeyKeepSourceNotDestin = @"keepSourceNotDestin" ;
NSString* const constKeyBrowserPathsLaunched = @"browserPathsLaunched" ;
NSString* const constKeyMoreDoneInvocations = @"auxMsgs" ;
NSString* const constKeyNewExidsCount = @"newExidsCount" ;
NSString* const constKeyPauseSyncersIfUserCancelsExport = @"pauseSyncersIfUserCancelsExport" ;
NSString* const constKeyPerformanceType = @"performanceType" ;
NSString* const constKeyPlusAllFailed = @"plusAllFailed" ;
NSString* const constKeyBrowserPathQuit = @"browserPathQuit" ;
NSString* const constKeySaveOperation = @"saveOperation" ;
NSString* const constKeySecondPrep = @"secondPrep" ;
NSString* const constKeyShouldInstallExtension1 = @"shouldInstallExtension1" ;
NSString* const constKeySkipImportNoChanges = @"skipImportNoChanges" ;
NSString* const constKeyNoItemsToUpload = @"noItemsUpload" ;
NSString* const constKeyLegacyItemProps = @"legacyItemProps" ;
NSString* const constKeyOverlayClient = @"overlayClient" ;
NSString* const constKeyRootStark = @"rootStark" ;
NSString* const constKeyStarkload = @"starkload" ;
NSString* const constKeySuffixesFileCopied = @"suffixesFileCopied" ;
NSString* const constKeySafariLockDirectories = @"safariLockDirectories" ;
NSString* const constKeyUnflaggedImportClients = @"unflaggedImportClients";
NSString* const constKeyVerifySince = @"verifySince" ;
NSString* const constKeyWaitInterval = @"waitInterval" ;

// Method Placeholders
NSString* const constMethodPlaceholderImport1 = @"import1" ;
NSString* const constMethodPlaceholderImportAll = @"importA" ;
NSString* const constMethodPlaceholderExport1 = @"export1"  ;
NSString* const constMethodPlaceholderExportAll = @"exportA" ;

// Notifications
NSString* const constNoteBkmxWindowsDidRearrange = @"BkmxWinsDidRearrange" ;
NSString* const constNoteBkmxDidFinishSaving = @"BkmxDidFinishSaving";
NSString* const constNoteBkmxFindResultsNeedRefresh = @"BkmxFindResultsNeedRefresh" ;
NSString* const constNoteBkmxSelectionDidChange = @"BkmxSelectionDidChange" ;
NSString* const constNoteBkmxSyncerDidChange = @"BkmxSyncerDidChange" ;
NSString* const constNoteBkmxClientDidChange = @"BkmxClientDidChange" ;
NSString* const constNoteBkmxMacsterDidChange = @"BkmxMacsterDidChange" ;

// Pboard Types
NSString* const constBkmxPboardTypeDraggableStark = @"com.sheepsystems.BkmkMgrs.draggableStark";
NSString* const constBkmxPboardTypeStark = @"constBkmxPboardTypeStark" ;
NSString* const constBkmxPboardTypeSafariLegacy = @"BookmarkDictionaryListPboardType" ;  // First noticed this no longer worked in macOS 10.15.
NSString* const constBkmxPboardTypeSafari = @"com.apple.Safari.bookmarkDictionaryList" ;


// Extore Media Types

// Make these short and concise because they will actually
// be seen in filenames and descriptions.  The context
// will be obvious, so just give the variable part.
NSString* const constBkmxExtoreMediaUnknown = @"unknown";
NSString* const constBkmxExtoreMediaThisUser = @"thisUser" ;
NSString* const constBkmxExtoreMediaFTP = @"ftp" ;
NSString* const constBkmxExtoreMediaLoose = @"loose" ;

// Hartainer symbols used in Xbel metadata
NSString* const constBkmxSymbolHartainerBar = @"BBar" ;
NSString* const constBkmxSymbolHartainerMenu = @"Menu" ;
NSString* const constBkmxSymbolHartainerUnfiled = @"Unfl" ;
NSString* const constBkmxSymbolHartainerOhared = @"Ohar" ;

// Exformat names - Local Apps
NSString* const constExformatBraveBeta = @"BraveBeta" ;
NSString* const constExformatBravePublic = @"BravePublic" ;
NSString* const constExformatCanary = @"Canary" ;
NSString* const constExformatChrome = @"Chrome" ;
NSString* const constExformatChromium = @"Chromium" ;
NSString* const constExformatEdge = @"Edge" ;
NSString* const constExformatEdgeBeta = @"EdgeBeta" ;
NSString* const constExformatEdgeDev = @"EdgeDev" ;
NSString* const constExformatEpic = @"Epic" ;
NSString* const constExformatFirefox = @"Firefox" ;
NSString* const constExformatHtml = @"Html" ;
NSString* const constExformatICab = @"ICab" ;
NSString* const constExformatOmniweb = @"OmniWeb" ;
NSString* const constExformatOpera = @"Opera" ;
NSString* const constExformatOrion = @"Orion" ;
NSString* const constExformatSafari = @"Safari" ;
NSString* const constExformatVivaldi = @"Vivaldi" ;
NSString* const constExformatXbel = @"Xbel" ;

// Exformat names - Web Apps
NSString* const constExformatDiigo = @"Diigo" ;
NSString* const constExformatPinboard = @"Pinboard" ;


// Preferences (User Defaults) Keys

// Root Preference Keys
// Hey you!  Consider adding any new root pref keys to keysToKeep in -[Uninstaller reset]
NSString* const constKeyGeneralUninhibitDate = @"generalUninhibitDate" ;
NSString* const constKeyUninhibitDatesPerTriggerCause = @"uninhibitDatesPerTriggerCause" ;
__attribute__((visibility("default"))) NSString* const constKeyAgentStagings = @"agentStagings" ;
// Hey you!  Consider adding any new root pref keys to keysToKeep in -[Uninstaller reset]
__attribute__((visibility("default"))) NSString* const constKeyAlertFailure = @"alertFailure" ;
__attribute__((visibility("default"))) NSString* const constKeyAlertStage = @"alertStage" ;
// Hey you!  Consider adding any new root pref keys to keysToKeep in -[Uninstaller reset]
__attribute__((visibility("default"))) NSString* const constKeyAlertStart = @"alertStart" ;
__attribute__((visibility("default"))) NSString* const constKeyAlertSuccess = @"alertSuccess" ;
NSString* const constKeyAltKeyInspectsLander = @"altKeyInspectsLander" ;
NSString* const constKeyBkmxDocsWarningLimit = @"bkmxDocsWarningLimit" ;
// Hey you!  Consider adding any new root pref keys to keysToKeep in -[Uninstaller reset]
__attribute__((visibility("default"))) NSString* const constKeyBookmarksChangeDelay1 = @"bookmarksChangeDelay1" ;
__attribute__((visibility("default"))) NSString* const constKeyBookmarksChangeDelay2 = @"bookmarksChangeDelay2" ;
// Hey you!  Consider adding any new root pref keys to keysToKeep in -[Uninstaller reset]
NSString* const constKeyBookmarksInDoxtus = @"bookmarksInDoxtus" ;
__attribute__((visibility("default"))) NSString* const constKeyBrowserWeQuitDates = @"browserWeQuitDates";
NSString* const constKeyClientsLastChangeWrittenDate = @"clientsLastExported" ;
NSString* const constKeyClientsLastImportPreHash = @"clientsLastImportPreHash";
NSString* const constKeyClientsLastImportPostHash = @"clientsLastImportPostHash";
NSString* const constKeyClientsLastExportPreHash = @"clientsLastExportPreHash";
NSString* const constKeyClientsLastExportPostHash = @"clientsLastExportPostHash";
// Hey you!  Consider adding any new root pref keys to keysToKeep in -[Uninstaller reset]
__attribute__((visibility("default"))) NSString* const constKeyClientsDirt = @"clientsDirt";
/* The next two keys are legacy keys, for version up to 2.x, which archives
 colors with [NSArchiver archivedDataWithRootObject:.  The next next two keys
 are the new keys, for version 3.x and later, which archives colors with
 +[NSKeyedArchiver archivedDataWithRootObject:requiringSecureCoding:error:].
 The new keys are necessary because if version 3 just overwrote the old data
 values, users who downgraded for any reason would get black for both sortable
 and unsortable. */
NSString* const constKeyColorSortable = @"colorSortable" ;  // legacy version 1-2
NSString* const constKeyColorUnsortable = @"colorUnsortable" ;  // legacy version 1-2
NSString* const constKeyColorSort = @"colorSort";  // version 3+
NSString* const constKeyColorUnsort = @"colorUnsort";  // version 3+
// Hey you!  Consider adding any new root pref keys to keysToKeep in -[Uninstaller reset]
NSString* const constKeyColumnWidths = @"columnWidths" ;
NSString* const constKeyCompositeImportSettingsHash = @"compositeImportSettingsHash";
NSString* const constKeyDidWarnBrave1_7 = @"didWarnBrave1_7";
NSString* const constKeyDidWarnExpiringSoonV3 = @"didWarnExpiringSoonV3";
NSString* const constKeyDefaultCruftSpecs = @"defaultCruftSpecs" ;
__attribute__((visibility("default"))) NSString* const constKeyLastJsonExport = @"lastJsonExport" ;
NSString* const constKeyDispose302Perm = @"dispose302Perm" ;  // Warning: xib BkmxDoc > Reports > Verify > an NSMatrix > Selected Tag is bound to this key
NSString* const constKeyDispose302Unsure = @"dispose302Unsure" ;  // Warning: xib BkmxDoc > Reports > Verify > an NSMatrix > Selected Tag is bound to this key 
// Hey you!  Consider adding any new root pref keys to keysToKeep in -[Uninstaller reset]
NSString* const constKeyDocRecentDisplayNames = @"docRecentDisplayNames" ;
__attribute__((visibility("default"))) NSString* const constKeyDocAliasRecords = @"docAliasRecords" ;
__attribute__((visibility("default"))) NSString* const constKeyDocLastSaveToken = @"docLastSaveToken" ;
NSString* const constKeyDontShowDragTips = @"dontShowDragTips" ;
NSString* const constKeyDontWarnBadCommandEnd = @"dontWarnBadCommandEnd" ;
// Hey you!  Consider adding any new root pref keys to keysToKeep in -[Uninstaller reset]
NSString* const constKeyDontWarnExport = @"dontWarnExport" ;
// Hey you!  Consider adding any new root pref keys to keysToKeep in -[Uninstaller reset]
NSString* const constKeyDontWarnMultiDocSyncers = @"dontWarnMultiDocSyncers" ;
NSString* const constKeyDontWarnOtherMacBrowsers = @"dontWarnOtherMacBrowsers" ;
// Hey you!  Consider adding any new root pref keys to keysToKeep in -[Uninstaller reset]
NSString* const constKeyDontWarnSyncingSuspended = @"dontWarnSyncingSuspended";
NSString* const constKeyDontWarnV3UpgradeNeeded = @"dontWarnV3UpgradeNeeded";
NSString* const constKeyDontWelcome = @"dontWelcome" ;
// Hey you!  Consider adding any new root pref keys to keysToKeep in -[Uninstaller reset]
NSString* const constKeyDoOpenAfterLaunchUuids = @"doOpenAfterLaunchUuids" ;
NSString* const constKeyDoxtusShowHideQuitMenuItemsPosition = @"doxtusShowHideQuitMenuItemsPosition";
NSString* const constKeyForceStyle1Client = @"forceStyle1Client";
NSString* const constKeyExidFailureRateAllowed = @"exidFailureRateAllowed" ;
// Hey you!  Consider adding any new root pref keys to keysToKeep in -[Uninstaller reset]
NSString* const constKeyExidFailuresAllowed = @"exidFailuresAllowed" ;
NSString* const constKeyDaysIxportDiary = @"daysIxportDiary" ;
// Hey you!  Consider adding any new root pref keys to keysToKeep in -[Uninstaller reset]
NSString* const constKeyFightThreshold = @"fightThreshold" ;
NSString* const constKeyDaysLog = @"daysLog" ;
__attribute__((visibility("default"))) NSString* const constKeyIgnoredPrefixes = @"ignoredPrefixes" ;
__attribute__((visibility("default"))) NSString* const constKeyIgnoreNextLoginTrigger = @"ignoreNextLoginTrigger" ;
NSString* const constKeyHideErrors = @"hideErrors" ;
// Hey you!  Consider adding any new root pref keys to keysToKeep in -[Uninstaller reset]
NSString* const constICloudFolderLimit = @"iCloudFolderLimit";
NSString* const constKeyInspectorWasShowing = @"inspectorShowing" ;
NSString* const constKeyKeepLegacyArtifacts = @"keepLegacyArtifacts" ;
// Hey you!  Consider adding any new root pref keys to keysToKeep in -[Uninstaller reset]
NSString* const constKeyLandCommentsLimit = @"landCommentsLimit" ;
NSString* const constKeyLandingRecents = @"landingRecents" ;
// Hey you!  Consider adding any new root pref keys to keysToKeep in -[Uninstaller reset]
NSString* const constKeyLandDupeAction = @"landDupeAction" ;
NSString* const constKeyLastDateDragTipsShown = @"lastDateDragTipsShown" ;
NSString* const constKeyLastLocalFileCruftCleaning = @"lastLocalFileCruftCleaning";
// Hey you!  Consider adding any new root pref keys to keysToKeep in -[Uninstaller reset]
NSString* const constKeyLandWithSound = @"landWithSound" ;
NSString* const constKeyLaunchInBackground = @"launchInBackground" ;
// Hey you!  Consider adding any new root pref keys to keysToKeep in -[Uninstaller reset]
__attribute__((visibility("default"))) NSString* const constKeyLaunchQuietlyNextTime = @"launchQuietlyNextTime" ;
NSString* const constKeyLocalMocSyncs = @"localMocSyncs" ;
__attribute__((visibility("default"))) NSString* const constKeyDebugIxportHashes = @"debugIxportHashes";
NSString* const constKeyDebugTraceVerbosity = @"debugTraceVerbosity";
// Hey you!  Consider adding any new root pref keys to keysToKeep in -[Uninstaller reset]
__attribute__((visibility("default"))) NSString* const constKeyMinExportLimit = @"minExportLimit";
NSString* const constKeyMiniSearchPosition = @"miniSearchPosition" ;
// Hey you!  Consider adding any new root pref keys to keysToKeep in -[Uninstaller reset]
NSString* const constKeyMiniSearchRecents = @"miniSearchRecents";
// Hey you!  Consider adding any new root pref keys to keysToKeep in -[Uninstaller reset]
NSString* const constKeyQuickSearchParms = @"quickSearchParms" ;
__attribute__((visibility("default"))) NSString* const constKeyReadStyle2TxTimeout = @"readStyle2TxTimeout" ;
__attribute__((visibility("default"))) NSString* const constKeyRecentQuits = @"recentQuits" ;
__attribute__((visibility("default"))) NSString* const constKeySafariMoreAgentSecs = @"safariMoreAgentSecs";
NSString* const constKeySafariPushCountSheepSafariHelper = @"safariPushCountSheepSafariHelper";
NSString* const constKeySafariPushCountThomas = @"safariPushCountThomas";
NSString* const constKeySafariPushLastSheepSafariHelper = @"safariPushLastSheepSafariHelper";
NSString* const constKeySafariPushLastThomas = @"safariPushLastThomas";
NSString* const constKeySafariPushStyle = @"safariPushStyle";
NSString* const constKeySafariPushPriorCkms = @"safariPushPriorCkms";
NSString* const constKeySendPerformanceData = @"sendPerformanceData";
NSString* const constKeySafariCullForThomas = @"safariCullForThomas";
NSString* const constKeyShoeboxSafeSyncLimit = @"shoeboxSafeSyncLimit" ;
// Hey you!  Consider adding any new root pref keys to keysToKeep in -[Uninstaller reset]
NSString* const constKeyShortcutAnywhereMenu = @"shortcutAnywhereMenu" ;
NSString* const constKeyShortcutAddQuickly = @"shortcutAddQuickly" ;
// Hey you!  Consider adding any new root pref keys to keysToKeep in -[Uninstaller reset]
NSString* const constKeyShortcutAddAndInspect = @"shortcutAddAndInspect" ;
NSString* const constKeyStatusItemStyle = @"statusItemStyle" ;
// Hey you!  Consider adding any new root pref keys to keysToKeep in -[Uninstaller reset]
NSString* const constKeySortShoeboxDuringSyncs = @"sortShoeboxDuringSyncs" ;
// Hey you!  Consider adding any new root pref keys to keysToKeep in -[Uninstaller reset]
__attribute__((visibility("default"))) NSString* const constKeySoundFailMinor = @"soundFailMinor" ;
__attribute__((visibility("default"))) NSString* const constKeySoundFailMajor = @"soundFailMajor" ;
__attribute__((visibility("default"))) NSString* const constKeySoundStage = @"soundStage" ;
// Hey you!  Consider adding any new root pref keys to keysToKeep in -[Uninstaller reset]
__attribute__((visibility("default"))) NSString* const constKeySoundStart = @"soundStart" ;
__attribute__((visibility("default"))) NSString* const constKeySoundSuccess = @"soundSuccess" ;
// Hey you!  Consider adding any new root pref keys to keysToKeep in -[Uninstaller reset]
NSString* const constKeySyncFirefoxOnQuit = @"syncFirefoxOnQuit";
NSString* const constKeySyncSnapshotsLimitMB = @"syncSnapshotsLimitMB" ;
NSString* const constKeyMenuFontSize = @"menuFontSize" ;
NSString* const constKeyTableFontSize = @"tableFontSize" ;
// Hey you!  Consider adding any new root pref keys to keysToKeep in -[Uninstaller reset]
NSString* const constKeyTagDelimiterDefault = @"tagDelimiterDefault" ;
NSString* const constKeyTagDelimiterReplacement = @"tagDelimiterReplacement" ;
NSString* const constKeyTextCopyTemplate = @"textCopyTemplate";
// Hey you!  Consider adding any new root pref keys to keysToKeep in -[Uninstaller reset]
NSString* const constKeyThrottlePeriod = @"throttlePeriod" ;
NSString* const constKeyTriggerBlinderKeys = @"triggerBlinderKeys" ;
NSString* const constKeyUserHasBeenToldAboutBkmxNotifierA = @"userHasBeenToldAboutBkmxNotifierA";
// Hey you!  Consider adding any new root pref keys to keysToKeep in -[Uninstaller reset]
__attribute__((visibility("default"))) NSString* const constKeyWaitAfterLogin = @"waitAfterLogin";
__attribute__((visibility("default"))) NSString* const constKeyWaitAfterWake = @"waitAfterWake";
NSString* const constKeyVisitWarningThreshold = @"visitWarningThreshold" ;
__attribute__((visibility("default"))) NSString* const constKeyWatches = @"watches" ;
NSString* const constKeyXugradeImported = @"xugradeImported" ;
// Hey you!  Consider adding any new root pref keys to keysToKeep in -[Uninstaller reset]
NSString* const constKeyYellowSyncExplained = @"yellowSyncExplained";


// Autosave keys
NSString* const constKeyDocAutosaves = @"docAutosaves" ;
NSString* const constAutosaveTabs = @"tabs" ;
NSString* const constAutosaveOutlineMode = @"outlineMode" ;
NSString* const constAutosaveSearchOptions = @"searchOptions" ;
NSString* const constAutosaveSearchFor = @"searchFor" ;
NSString* const constAutosaveSearchIn = @"searchIn" ;
NSString* const constAutosaveWindowFrame = @"winFrame" ;
NSString* const constAutosaveTabContentSizes = @"tabContentSizes" ;
NSString* const constAutosaveContentSplitView = @"contentSplit" ;
NSString* const constAutosaveContentTableColumns = @"contentCols" ;
NSString* const constAutosaveFindTableColumns = @"findCols" ;
NSString* const constAutosaveDupesTableColumns = @"dupesCols" ;
NSString* const constAutosaveRecentLandings = @"recentLandings" ;
NSString* const constAutosaveTabTop = @"top" ;
NSString* const constAutosavePrefsWindow = @"prefsWindow" ;


// Preferences Window Names used for autosaving window positions
NSString* const constWindowNameInspector = @"Inspector" ;


// Stark Properties
NSString* const constKeyAddDate = @"addDate" ;
NSString* const constKeyColor = @"color" ;
NSString* const constKeyComments = @"comments" ;
NSString* const constKeyExids = @"exids" ;
NSString* const constKeyClients = @"clients" ;
NSString* const constKeyFavicon = @"favicon" ;
NSString* const constKeyFaviconUrl = @"faviconUrl" ;
NSString* const constKeyIsAllowedDupe = @"isAllowedDupe" ;
NSString* const constKeyIsAutoTab = @"isAutoTab" ;
NSString* const constKeyIsExpanded = @"isExpanded" ;
NSString* const constKeyDontExportExformats = @"dontExportExformats" ;
NSString* const constKeyDontVerify = @"dontVerify" ;
NSString* const constKeyDupe = @"dupe" ;
NSString* const constKeyIsShared = @"isShared" ;
NSString* const constKeyLastChengDate = @"lastChengDate" ;
NSString* const constKeyLastModifiedDate = @"lastModifiedDate" ;
NSString* const constKeyLastVisitedDate = @"lastVisitedDate" ;
NSString* const constKeyMaster = @"master" ;
NSString* const constKeyName = @"name" ;  // Referenced in DefaultDefaults.plist
NSString* const constKeyOperaPanelPosition = @"operaPanelPosition" ;
NSString* const constKeyOperaPersonalBarPosition = @"operaPersonalBarPosition" ;
NSString* const constKeyOwnerValues = @"ownerValues" ;
//NSString* const constKeyRating = @"rating" ;
NSString* const constKeyRssArticles = @"rssArticles" ;
NSString* const constKeySharype = @"sharype" ;
NSString* const constKeySharypeCoarse = @"sharypeCoarse" ;
NSString* const constKeyShortcut = @"shortcut" ;
NSString* const constKeySortable = @"sortable" ;
NSString* const constKeySortDirective = @"sortDirective" ;
NSString* const constKeyEffectiveIndex = @"effectiveIndex" ;
NSString* const constKeyStarkid = @"starkid" ;
NSString* const constKeySponsorIndex = @"sponsorIndex" ;
NSString* const constKeySponsoredIndex = @"sponsoredIndex" ;
NSString* const constKeyIxportingIndex = @"ixportingIndex";
NSString* const constKeyTags = @"tags" ;
NSString* const constKeyTagsString = @"tagsString" ;  // Referenced in DefaultDefaults.plist
NSString* const constKeyToRead = @"toRead" ;
NSString* const constKeyUrl = @"url" ;
NSString* const constKeyUrlOrStats = @"urlOrStats" ;
NSString* const constKeyVerifierAdviceArray = @"adviceArray" ;
NSString* const constKeyVerifierAdviceMultiLiner = @"verifierAdviceMultiLiner" ;
NSString* const constKeyVerifierAdviceOneLiner = @"verifierAdviceOneLiner" ;
NSString* const constKeyVerifierCode = @"verifierCode" ;
NSString* const constKeyVerifierCodeUsingHttps = @"verifierCodeUsingHttps" ;
NSString* const constKeyVerifierDetails = @"verifierDetails" ;
NSString* const constKeyVerifierDisposition = @"verifierDisposition" ;
NSString* const constKeyVerifierHeaderGetter = @"verifierHeaderGetter" ;
NSString* const constKeyVerifierLastDate = @"verifierLastDate" ;
NSString* const constKeyVerifierLastResult = @"verifierLastResult" ;
NSString* const constKeyVerifierNeedsRetest = @"verifierNeedsRetest" ;
NSString* const constKeyVerifierNsErrorDomain = @"verifierNSErrorDomain" ;
NSString* const constKeyVerifierPriorUrl = @"verifierPriorUrl" ;
NSString* const constKeyVerifierReason = @"verifierReason" ;
NSString* const constKeyVerifierStark = @"theStark" ;
NSString* const constKeyVerifierSubtype302 = @"verifierSubtype302" ;
NSString* const constKeyVerifierSuggestedUrl = @"verifierSuggestedUrl" ;
NSString* const constKeyVerifierUrl = @"verifierUrl" ;
NSString* const constKeyVisitCount = @"visitCount" ;
NSString* const constKeyVisitCountString = @"visitCountString" ;
NSString* const constKeyVisitor = @"visitor" ; // also a Bookshig attribute
NSString* const constKeyVisitorWindowFrame = @"visitorWindowFrame" ;


// Column Identifiers
NSString* const constKeyPhrase = @"phrase" ;
NSString* const constKeyTrailingSpace = @"trailingSpace" ;

// Other KVO Keys
NSString* const constKeySyncer = @"syncer" ;

// Error Domains
__attribute__((visibility("default"))) NSString* const constBkmxAgentErrorDomain = @"BkmxAgent Error Domain" ;
__attribute__((visibility("default"))) NSString* const SheepSafariHelperErrorDomain = @"SheepSafariHelperErrorDomain";


// Error Keys
__attribute__((visibility("default"))) NSString* const SSYDocumentUuidErrorKey = @"Document UUID" ;
__attribute__((visibility("default"))) NSString* const SSYDocumentAliasDataErrorKey = @"Document Alias Data" ;
NSString* const constKeyProblemKey = @"problemKey" ;
NSString* const constKeyBadAgentIndex = @"badAgentIndex" ;
NSString* const constKeyBadCommandIndex = @"badCommandIndex" ;
NSString* const constKeyTagDelimiterActual = @"tagDelimiterActual" ;
