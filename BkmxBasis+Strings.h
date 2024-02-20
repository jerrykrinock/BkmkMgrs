#import <Cocoa/Cocoa.h>
#import "BkmxBasis.h"
#import "BkmxGlobals.h"
#import "SSYArrayController.h"

@class RPTokenControl ;

/*!
 @brief    A category on BkmxBasis that providing localized labels, toolTips
 and other strings.
 
 @details  This is just to keep BkmxBasis.m from getting too long and cluttered
 with trivial stuff.
 */
@interface BkmxBasis (Strings)

- (NSString*)labelNewIdentifiers ;

- (NSString*)labelSupportEmail ;

- (NSString*)labelSyncLog ;

- (NSString*)labelErrors ;

- (NSString*)labelMessages ;

- (NSString*)stringSyncersSimplify ;

- (NSString*)labelSyncerImportClients ;

- (NSString*)labelSyncerExportToClients ;

- (NSString*)labelSyncerLanded ;

- (NSString*)labelSyncerCloud ;

- (NSString*)tooltipSimpleView ;

- (NSString*)bookmacsterizeName ;

- (NSString*)labelBookmacsterize ;

- (NSString*)bookmacsterizeComments ;

- (NSString*)labelUpdateVerb ;

- (NSString*)labelAdditions ;

- (NSString*)labelDeletions ;

- (NSString*)labelUpdates ;

- (NSString*)labelMoves ;

- (NSString*)labelSlides ;

- (NSString*)labelCloseAndTrash ;

- (NSString*)labelMultipleValues ;

- (NSString*)labelNoName ;

- (NSString*)labelAddClients ;

- (NSString*)labelNoLocalClients ;

- (NSString*)labelNothing ;

- (NSString*)labelNotApplicable ;

/*!
 @brief    Returns a localized string,
 "Name", (capitalized) in English
 */
- (NSString*)labelName ;

/*!
 @brief    Returns a localized string,
 "Settings", in English
 */
- (NSString*)labelSettings ;

- (NSString*)labelLocalSettings ;

- (NSString*)labelExport ;

- (NSString*)labelExportToAll ;

- (NSString*)labelExportTo ;

- (NSString*)labelExportToOnly ;

- (NSString*)labelExportToOthers ;

/*!
 @brief    Returns a localized string,
 "Open/Save", in English
 */
- (NSString*)labelOpenSave ;

/*!
 @brief    Returns a localized string,
 "Do sort", in English
 */
- (NSString*)labelSortDo ;

/*!
 @brief    Returns a localized string,
 "Do not sort", in English
 */
- (NSString*)labelSortDont ;

/*!
 @brief    Returns a localized string,
 "Sort if parent is sorted", in English
 */
- (NSString*)labelSortIfParent ;

/*!
 @brief    Returns a localized string,
 "Use Document Settings", in English
 */
- (NSString*)labelSettingsDocumentUse ;

/*!
 @brief    Returns a localized string,
 "Use settings from Preferences", in English
 */
- (NSString*)labelSettingsPrefsUse ;

/*!
 @brief    Returns a localized string,
 "Hard Folders", in English
 */
- (NSString*)labelHartainers ;

/*!
 @brief    Returns a localized string,
 "Hard Folder", in English
 */
- (NSString*)labelHartainer ;

/*!
 @brief    Returns a localized string,
 "Root", in English
 */
- (NSString*)labelRoot ;

/*!
 @brief    Returns a localized string,
 "User-Defined Folder", in English
 */
- (NSString*)labelSoftainer ;

/*!
 @brief    Returns a localized string,
 "User-Defined Folders", in English
 */
- (NSString*)labelSoftainers ;

/*!
 @brief    Returns a localized string,
 "Bookmark", in English
 */
- (NSString*)labelLeaf ;

/*!
 @brief    Returns a localized string,
 "Bookmarks", in English
 */
- (NSString*)labelLeaves ;

/*!
 @brief    Returns a localized string,
 "Separator", in English
 */
- (NSString*)labelNotch ;

/*!
 @brief    Returns a localized string,
 "Separators", in English
 */
- (NSString*)labelNotches ;

/*!
 @brief    Returns a localized string of text which says
 "Your Default Browser (XXXXX)"

 @details  XXXXX is the name of the user's default web browser.
*/
- (NSString*)labelDefaultWebBrowser ;

- (NSString*)labelEventAppLaunch ;

- (NSString*)labelEventDocSaved ;

- (NSString*)labelEventLogInMac ;

- (NSString*)labelEventSchedDate ;

- (NSString*)labelEventPeriodic ;

- (NSString*)labelEventBookmarksChanged ;

- (NSString*)labelEventBrowserQuit ;

- (NSString*)labelEventLanded ;

- (NSString*)labelEventOtherMacDrop ;

- (NSString*)labelClient ;

- (NSString*)labelImport ;

- (NSString*)labelImportFromAll ;

- (NSString*)labelImportFrom ;

- (NSString*)labelImportFromOnly ;

- (NSString*)labelImportFromOthers ;

- (NSString*)labelImportClient ;

- (NSString*)labelExportClient ;

- (NSString*)labelClients ;

- (NSString*)labelDeleteUnmatchedItems ;

- (NSString*)labelConsolidateFolders ;

- (NSString*)labelDeleteFolders ;

- (NSString*)labelMergeFolders ;

/*!
 @brief    Invokes -bkmxAttributeDisplayName, but if
 the answer is nil, returns the given key capitalized
 and logs an internal error.
 */
- (NSString*)labelNoNilForKey:(NSString*)key ;

- (NSString*)labelTagDelimiter ;

- (NSString*)labelTagDelimiterDefault1 ;

- (NSString*)labelDeleteAll ;

- (NSString*)labelDeleteAllDupes ;

- (NSString*)toolTipDeleteAllDupes ;

- (NSString*)labelEmptyCache ;

- (NSString*)labelCacheDefine ;

- (NSString*)labelCacheEmptyDef ;

- (NSString*)labelAutosaveUponClose ;

- (NSString*)labelNewDocument ;

- (NSString*)labelNewBkmxDoc ;

- (NSString*)labelSyncer ;

- (NSString*)labelDeleteAgent ;

- (NSString*)labelDuplicates ;

- (NSString*)labelBroken ;

- (NSString*)labelDontVerify ;

- (NSString*)labelUpdated ;

- (NSString*)labelSecured ;

- (NSString*)labelSwapPriorAndCurrentUrl ;

- (NSString*)labelSwapSuggestedAndCurrentUrl ;

- (NSString*)labelUrlPrior ;

- (NSString*)labelAdvanced ;
	
- (NSString*)labelAdvancedParen ;

- (NSString*)labelVisit ;

- (NSString*)labelVisitForBookmarksCount:(NSInteger)nBookmarks
						  urlTemporality:(BkmxUrlTemporality)urlTemporality ;

- (NSString*)labelShowFolders ;

- (NSString*)labelSearch ;

- (NSString*)labelSearchFor ;

- (NSString*)labelSearchIn ;

- (NSString*)labelRecentSearches ;

- (NSString*)labelNoRecentSearches ;

- (NSString*)labelClearRecentSearches ;

- (NSString*)labelHelp ;

- (NSString*)labelInspector ;

- (NSString*)labelShowInspector ;

- (NSString*)labelHideInspector ;

- (NSString*)labelDescribe302ProbPerm ;

- (NSString*)labelDescribe302NotSure ;

- (NSString*)labelDescribe302ProbTemp ;

- (NSString*)labelBrokenNot ;

- (NSString*)labelUnknown ;

- (NSString*)labelUpdatedNot ;

- (NSString*)labelSort ;

- (NSString*)labelFindDupes ;

- (NSString*)labelComments ;

- (NSString*)labelOk ;

- (NSString*)labelContent ;

- (NSString*)labelReports ;

- (NSString*)labelGeneral ;

- (NSString*)labelStructure ;

- (NSString*)labelSorting ;

- (NSString*)labelSyncers ;

- (NSString*)labelSyncing ;

- (NSString*)labelVerify ;

- (NSString*)labelDoKeepBoth  ;

- (NSString*)labelDaysKeep ;

- (NSString*)labelPreferences ;

- (NSString*)labelLogs ;

- (NSString*)labelDiaries ;

- (NSString*)labelFindReplace ;

- (NSString*)labelSortAll ;

- (NSString*)labelVerifyEllipsis ;

- (NSString*)labelSave ;

- (NSString*)labelCloseAnyhow ;

- (NSString*)labelSaveOnly ;

- (NSString*)labelFix ;

- (NSString*)labelCommands ;

- (NSString*)labelMerge ;

- (NSString*)labelExpandRoots ;

- (NSString*)labelCollapseRoots ;

- (NSString*)labelDeleteAllContent ;

- (NSString*)labelSortAtBottom ;

- (NSString*)labelSortAtNormally ;

- (NSString*)labelSortAtTop ;

- (NSString*)labelSortAt ;

- (NSString*)labelTop ;

- (NSString*)labelBottom ;

- (NSString*)labelNormally ;

- (NSString*)labelStopAllSyncingNow;

- (NSString*)labelRemoveLegacyArtifacts ;

- (NSString*)labelRemove ;

- (NSString*)labelExportAndSave ;

- (NSString*)labelExportAndClose ;

- (NSString*)labelSeparator ;

- (NSString*)labelFolders ;

- (NSString*)labelSeparators ;

- (NSString*)labelChooseFileFormat ;

- (NSString*)labelForceQuit ;

- (NSString*)labelTriggers ;

- (NSString*)labelOpen ;

- (NSString*)labelAsk ;

- (NSString*)labelCancel ;

- (NSString*)labelVisitCount ;

- (NSString*)labelRetry ;

- (NSString*)labelClose ;

- (NSString*)labelQuit ;

- (NSString*)labelCloseAndQuit ;

- (NSString*)labelCheckForUpdate ;

- (NSString*)labelTryCommandCheckForUpdate ;

- (NSString*)labelLineage ;

- (NSString*)labelSafeLimit ;

- (NSString*)labelSafeLimitExport ;

- (NSString*)labelSafeLimitImport ;

- (NSString*)toolTipLineage ;

- (NSString*)labelOutlineMode ;

- (NSString*)labelTableMode ;

- (NSString*)labelMainContentView ;

- (NSString*)labelEmpty ;

- (NSString*)labelAndEndList ;

- (NSString*)labelAutoImport ;

- (NSString*)labelAutoExport ;

- (NSString*)labelTags ;

- (NSString*)labelShowWelcomeOnLaunch ;

- (NSString*)labelItem;

- (NSString*)labelActiveSyncers ;

- (NSString*)labelIsShared ;

- (NSString*)labelVisitor ;

- (NSString*)labelVisitorDefault ;

- (NSString*)labelSortable ;

- (NSString*)labelIsAllowedDupe ;

- (NSString*)labelShortcut ;

- (NSString*)labelIsExpanded ;

- (NSString*)labelShowAdvancedSettings ;

- (NSString*)labelAdvancedSettings ;

- (NSString*)labelTalderMaps ;

- (NSString*)labelTalderMapsEllipsized ;

- (NSString*)labelSortableDefault ;

- (NSString*)labelShowTagsOrFolders ;

- (NSString*)labelShowApp  ;

- (NSString*)labelBackgroundApp ;

- (NSString*)toolTipBackground ;

- (NSString*)labelFindDupesAfterOpen ;

- (NSString*)labelDoOpenAfterLaunch ;

- (NSString*)labelSortAfterOpen ;

- (NSString*)labelIgnoreCommonPrefixesCheckbox ;

- (NSString*)labelHartainersHave ;

- (NSString*)labelIgnoreDisparateDupes ;

- (NSString*)labelDoIt ;

- (NSString*)labelDone ;

- (NSString*)labelRssArticle ;

- (NSString*)labelIgnore ;

- (NSString*)labelItemsAllowedAtRoot ;

- (NSString*)labelChildren ;

- (NSString*)labelNew ;

- (NSString*)labelBookmarks ;

- (NSString*)labelCollection ;

- (NSString*)labelDocuments ;

- (NSString*)labelSortRoot ;

- (NSString*)labelForSortBy:(BkmxSortBy)sortBy ;

- (NSString*)labelSortBy ;

- (NSString*)labelSortingSegmentation ;

- (NSString*)labelFabricateTags ;

- (NSString*)labelOneForEachTag ;

- (NSString*)labelFabricateFolders ;

- (NSString*)labelMergeBias ;

- (NSString*)labelMergeBy ;

- (NSString*)labelDefaultParent ;

- (NSString*)labelShareNewItems ;

- (NSString*)labelActive ;

- (NSString*)labelDescription ;

- (NSString*)labelTrigger ;

- (NSString*)labelCommand ;

- (NSString*)toolTipSyncerPerform ;

- (NSString*)labelWhenAddNewFromBrowser ;

- (NSString*)labelNewBookmarkLanding ;

- (NSString*)labelNewBookmarkLandingShort ;

- (NSString*)toolTipNewBookmarkLanding ;

- (NSString*)labelIfOptKeyUp ;

- (NSString*)labelIfOptKeyDown ;

- (NSString*)labelInstall ;

- (NSString*)labelResetAndStartOver ;

- (NSString*)labelUninstall ;

- (NSString*)labelTest ;

- (NSString*)labelManageBrowserExtensions ;

- (NSString*)toolTipAddNewShowInspector ;

- (NSString*)stringCancelledOperation ;

- (NSString*)stringConflictWithAppName:(NSString*)appName ;

- (NSString*)tooltipSyncStatusOff;

- (NSString*)tooltipSyncStatusOn;

- (NSString*)tooltipSyncStatusDis;

- (void)setPlaceholdersForTagsInTokenField:(RPTokenControl*)tokenField ;

- (NSDictionary*)bindingOptionsForTags ;

@end
