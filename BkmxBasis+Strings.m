#import "BkmxBasis+Strings.h"
#import "NSString+SSYExtraUtils.h"
#import "NSNumber+CharacterDisplay.h"
#import "NSString+LocalizeSSY.h"
#import "ExtoreOperas.h"
#import "NSDocumentController+DisambiguateForUTI.h"
#import "BkmxDocumentController.h"
#import "NSArray+Stringing.h"
#import "NSString+BkmxDisplayNames.h"
#import "SSWebBrowsing.h"
#import "RPTokenControl.h"

@interface NSString (BkmxBasisNeeds)

- (NSString*)appendReorderingTipForLabel:(NSString*)label ;

@end

@implementation NSString (BkmxBasisNeeds)

- (NSString*)appendReorderingTipForLabel:(NSString*)label {
	return [NSString stringWithFormat:
			@"%@\n\n%@",
			self,
			[NSString localizeFormat:
			 @"reorderTTX", 
			 label]] ;
}

@end

@implementation BkmxBasis (Strings)

- (NSString*)labelNewIdentifiers {
	return [NSString localizeFormat:
			@"new%0",
			[NSString localize:@"identifiers"]] ;
}

- (NSString*)labelUpdatePath0 {
	return [NSString localize:@"checkForUpdatePath0"] ;
}

- (NSString*)labelUpdatePath1 {
	return [NSString localize:@"checkForUpdatePath1"] ;
}

- (NSString*)labelUpdatePath2 {
	return [NSString localize:@"checkForUpdatePath2"] ;
}

- (NSString*)labelTimeInterval {
	return [NSString localize:@"timeInterval"] ;
}

- (NSString*)labelBookmarkRequests {
	return [NSString localizeFormat:
			@"serverRequestsX",
			[self labelLeaf]] ;
}

- (NSString*)tooltipBookmarkRequests {
	return [NSString localize:@"serverRequestParms"] ;
}

- (NSString*)labelInitialInterval {
	return [NSString localizeFormat:
			@"initialX",
			[self labelTimeInterval]] ;
}

- (NSString*)toolTipInitialInterval {
	return [NSString localize:@"serverRequestInitialWait"] ;
}

- (NSString*)labelRestInterval {
	return [NSString localizeFormat:
			@"restX",
			[self labelTimeInterval]] ;
}

- (NSString*)toolTipRestInterval {
	return [NSString localize:@"serverRequestBanRest"] ;
}

- (NSString*)labelBackoffFactor {
	return [NSString localize:@"serverBackoffFactor"] ;
}

- (NSString*)toolTipBackoffFactor {
	return [NSString localize:@"serverBackoffFactorTT"] ;
}

- (NSString*)labelSupportEmail {
	return [SSYAlert contactSupportToolTip] ;
}

- (NSString*)labelSyncLog {
	return [NSString localizeFormat:
			@"logX",
			[NSString localize:@"imex_sync"]] ;
}

- (NSString*)labelSimple {
	return [NSString localize:@"expertiseSimple"] ;
}

- (NSString*)labelAdvanced {
	return [NSString localize:@"expertiseAdvanced"] ;
}

- (NSString*)stringSyncersSimplify {
	return [NSString localizeFormat:
			@"agentsShowSimpleX",
			[self labelSimple]] ;
}

- (NSString*)labelAdvancedParen {
	return [NSString stringWithFormat:
			@"(%@)",
			[NSString localize:@"expertiseAdvanced"]] ;
}

- (NSString*)labelSyncerImportClients {
	return [NSString localize:@"imex_agentImport"] ;
}

- (NSString*)labelSyncerExportToClients {
	return [NSString localize:@"imex_agentExport"] ;
}

- (NSString*)labelSyncerLanded {
	return [NSString localize:@"imex_agentLanding"] ;
}

- (NSString*)labelSyncerCloud {
	return [NSString localize:@"imex_agentCloud"] ;
}

- (NSString*)tooltipExportCloud {
	return [NSString localizeFormat:
			@"imex_exportCloudTTX",
			[[BkmxDocumentController sharedDocumentController] defaultDocumentDisplayName]] ;
}

- (NSString*)tooltipSimpleView {
	return [NSString localize:@"simpleViewTT"] ;
}

- (NSString*)bookmacsterizeName {
	return [NSString localize:@"bkmxzName"] ;
}

- (NSString*)labelBookmacsterize {
	return [NSString localizeFormat:
			@"bookmarkletX",
			[self bookmacsterizeName]] ;
}

- (NSString*)bookmacsterizeComments {
	return [NSString localize:@"bkmxzComments"] ;
}

- (NSString*)toolTipStatusItemStyle {
	return [NSString localize:@"statusItemTT"] ;
}

- (NSString*)labelCloseAndTrash {
    NSString* maybeAnd = [NSString localize:@"andEndList"] ;
    NSString* maybeSpace = ([maybeAnd length] > 0) ? @" " : @"" ;
	return [NSString stringWithFormat:
			@"%@ %@%@%@%C",
			[NSString localize:@"close"],
			maybeAnd,
            maybeSpace,
			NSLocalizedString(@"Trash", @"Used as a verb, as in 'Trash it'"),
			(unsigned short)0x2026] ;
}

- (NSString*)labelUpdateVerb {
	return [NSString localize:@"updateV"] ;
}

- (NSString*)labelMultipleValues {
	return [NSString localizeFormat:
			@"multiple%0",
			[NSString localize:@"values"]] ;
}

- (NSString*)labelNoName {
	return [NSString localizeFormat:
			@"no%0",
			[NSString localize:@"name"]] ;
}

- (NSString*)labelAddClients {
	return [NSString localizeFormat:
			@"addX",
			[self labelClients]] ;
}

- (NSString*)labelNoLocalClients {
	return [NSString stringWithFormat:
			@"%@.  %@",
			[NSString localizeFormat:
			 @"no%0",
			 [NSString localizeFormat:
			  @"localX",
			  [self labelClients]]],
			[NSString localizeFormat:
			 @"doFirstX",
			 [self labelAddClients]]
			];
}

- (NSString*)labelEnableEli {
	return [[NSString localize:@"enable"] ellipsize] ;
}

- (NSString*)labelNothing {
	return [NSString localize:@"nothing"] ;
}

- (NSString*)labelNotApplicable {
	return [NSString localize:@"applicableNot"] ;
}

- (NSString*)labelDontVerify {
	return [NSString localizeFormat:
			@"dontX",
			[NSString localize:@"080_verify"]] ;
}

- (NSString*)labelSettings {
	return [NSString localize:@"settings"] ;
}

- (NSString*)labelLocalSettings {
	return [NSString localize:@"settingsLocalName"] ;
}

- (NSString*)labelGeneral {
	return [NSString localize:@"general"] ;
}

- (NSString*)labelImport {
	return [NSString localize:@"imex_import"] ;
}

- (NSString*)labelImportFromAll {
	return [NSString localize:@"imex_importFromAll"] ;
}

- (NSString*)labelImportFrom {
	return @"Import from" ;
}

- (NSString*)labelImportFromOnly {
	return @"Import from only" ;
}

- (NSString*)labelImportFromOthers {
	return @"Import from (others)" ;
}

- (NSString*)labelExport {
	return [NSString localize:@"imex_export"] ;
}

- (NSString*)labelExportToAll {
	return [NSString localize:@"imex_exportToAll"] ;
}

- (NSString*)labelExportTo {
	return @"Export to" ;
}

- (NSString*)labelExportToOnly {
	return @"Export to only" ;
}

- (NSString*)labelExportToOthers {
	return @"Export to (others)" ;
}

- (NSString*)labelImportClient {
	return [NSString localize:@"imex_importClient"] ;
}

- (NSString*)labelExportClient {
	return [NSString localize:@"imex_exportClient"] ;
}

- (NSString*)labelSave {
	return [NSString localize:@"save"] ;
}

- (NSString*)labelKeepSortedAlpha {
	return [NSString localize:@"sortedAlphaKeep"] ;
}

- (NSString*)labelCloseAnyhow {
	return [NSString localize:@"closeAnyhow"] ;
}

- (NSString*)labelSaveOnly {
	return [NSString localizeFormat:
			@"onlyX",
			[self labelSave]] ;
}

- (NSString*)labelStructure {
	return [NSString localize:@"structure"] ;
}

- (NSString*)labelSorting {
	return [NSString localize:@"sorting"] ;
}

- (NSString*)labelOpen {
	return [NSString localize:@"open"] ;
}

- (NSString*)labelClose {
	return [NSString localize:@"close"] ;
}

- (NSString*)labelQuit {
	return [NSString localize:@"quit"] ;
}

- (NSString*)labelCloseAndQuit {
    NSString* maybeAnd = [NSString localize:@"andEndList"] ;
    NSString* maybeSpace = ([maybeAnd length] > 0) ? @" " : @"" ;
	return [NSString stringWithFormat:
			@"%@ %@%@%@",
			[self labelClose],
			maybeAnd,
            maybeSpace,
			[self labelQuit]] ;
}

- (NSString*)labelOpenSave {
	return [NSString stringWithFormat:
			@"%@/%@",
			[self labelOpen],
			[self labelSave]] ;
}

- (NSString*)labelFindDupes {
	return [NSString localize:@"080_dupesFind"] ;
}

- (NSString*)labelDupe {
	return [NSString localize:@"dupe"] ;
}

- (NSString*)labelSort {
	return [NSString localize:@"080_sort"] ;
}

- (NSString*)labelSortDirective {
	return [self labelSort] ;
}

- (NSString*)labelSortAt {
	return [NSString localize:@"sortAt"] ;
}

- (NSString*)labelBottom {
	return [NSString localize:@"sortAtBottom"] ;
}

- (NSString*)labelNormally {
	return [NSString localize:@"sortAtNormally"] ;
}

- (NSString*)labelTop {
	return [NSString localize:@"sortAtTop"] ;
}

- (NSString*)labelSortAtBottom {
	return [NSString stringWithFormat:
			@"%@ %@",
			[NSString localize:@"sortAt"],
			[NSString localize:@"sortAtBottom"]] ;
}

- (NSString*)labelSortAtNormally {
	return [NSString stringWithFormat:
			@"%@ %@",
			[NSString localize:@"sortAt"],
			[NSString localize:@"sortAtNormally"]] ;
}

- (NSString*)labelSortAtTop {
	return [NSString stringWithFormat:
			@"%@ %@",
			[NSString localize:@"sortAt"],
			[NSString localize:@"sortAtTop"]] ;
}

- (NSString*)labelSortAll {
	return [NSString localizeFormat:
			@"080_sortX",
			[NSString localize:@"all"]] ;
}

- (NSString*)labelSortDo {
	return [NSString localize:@"080_sortDo"] ;
}

- (NSString*)labelSortDont {
	return [NSString localize:@"080_sortDont"] ;
}

- (NSString*)labelSortIfParent {
	return [NSString localize:@"080_sortIfParent"] ;
}

- (NSString*)labelSettingsDocumentUse {
	return [NSString localize:@"080_settingsDocumentUse"] ;
}

- (NSString*)labelSettingsPrefsUse {
    return [NSString localize:@"080_settingsPrefsUse"] ;
}

- (NSString*)labelHartainer {
	// "Hartainer", in English
	return [NSString localize:@"080_folderHard"] ;
}

- (NSString*)labelHartainers {
	return [NSString localize:@"080_folderHards"] ;
}

- (NSString*)labelHartainersHave {
	return [NSString localizeFormat:
			@"haveTheseX",
			[NSString localize:@"080_folderHards"]] ;
}

- (NSString*)labelItemsAllowedAtRoot {
	return [NSString localize:@"lineageRootItemsAllowed"] ;
}

- (NSString*)labelRoot {
	// "Root", in English
	return [NSString localize:@"lineageRoot"] ;
}

- (NSString*)labelSoftainer {
	// "User-Defined Folder", in English
	return [NSString localize:@"080_folderSoft"] ;
}

- (NSString*)labelSoftainers {
	// "User-Defined Folders", in English
	return [NSString localize:@"080_folderSofts"] ;
}

- (NSString*)labelLeaf {
	// "Bookmark", in English
	return [NSString localize:@"000_Safari_bookmark"] ;
}

- (NSString*)labelLeaves {
	// "Bookmarks", in English
	return [NSString localize:@"000_Safari_Bookmarks"] ;
}

- (NSString*)labelSeparator {
	return [NSString localize:@"001_Camino_separator"] ;	
}

- (NSString*)labelSeparators {
	return [NSString localize:@"001_Camino_separators"] ;	
}

- (NSString*)labelAddDate {
	return [NSString localize:@"002_Firefox_added"] ;
}

- (NSString*)labelColor {
	return [NSString localize:@"color"] ;
}

- (NSString*)labelComments {
	return [NSString localize:@"comments"] ;
}

// Method name constructed by Chaker
- (NSString*)labelIndex {
	return [NSString localize:@"position"] ;
}

- (NSString*)labelIsAllowedDupe {
	// "Allowed Duplicate", in English
	return [NSString localize:@"allowedDupe"] ;
}

- (NSString*)labelIsAutoTab {
	// "070_autotab_Safari", in English
	return [NSString localize:@"070_autotab_Safari"] ;
}

- (NSString*)labelIsDontVerify {
	return [self labelDontVerify] ;
}

- (NSString*)labelIsShared {
	// "Shared", in English
	return [NSString localize:@"shared"] ;
}

- (NSString*)labelLastModifiedDate {
	return [NSString localize:@"002_Firefox_lastModified"] ;
}

- (NSString*)labelVerifierLastResult {
	return [NSString localize:@"080_verifyLastResult"] ;
}

- (NSString*)labelLastVisitedDate {
	return [NSString localize:@"002_Firefox_lastVisited"] ;
}

- (NSString*)labelName {
	return [[NSString localize:@"name"] capitalizedString] ;
}

- (NSString*)labelChildren {
	return [NSString localize:@"children"] ;
}

// Used by Chaker:
- (NSString*)labelParent {
	return [NSString localize:@"columnHeadingParent"] ;
}

// Used by Chaker:
- (NSString*)labelSharype {
	return [NSString localize:@"typeBookmark"] ;
}

- (NSString*)labelSharypeCoarse {
	return [NSString localize:@"typeBookmark"] ;
}

- (NSString*)labelShortcut {
	return [NSString localize:@"070_shortcut_Camino"] ;
}

- (NSString*)labelSortable {
	return [NSString localize:@"sortable"] ;
}

- (NSString*)labelTags {
	return [NSString localize:@"070_tags_Pinboard"] ;
}

// Used by FindController
- (NSString*)labelTagsString {
	return [self labelTags] ;
}

- (NSString*)labelUrlOrStats {
	return [NSString stringWithFormat:
			@"URL (%@)",
			[NSString localize:@"statistics"]] ;
}

- (NSString*)labelUrlCurrent {
	return [NSString localizeFormat:
			@"currentX",
			@"URL"] ;
}

- (NSString*)labelUrlPrior {
	return [NSString localizeFormat:
			@"priorX",
			@"URL"] ;
}

- (NSString*)labelUrlSuggested {
	return [NSString localizeFormat:
			@"suggestedX",
			@"URL"] ;
}

- (NSString*)labelVerifierAdviceOneLiner {
	return [NSString localize:@"080_verifyAdvice"] ;
}

- (NSString*)labelVerifierAdviceMultiLiner {
	return [NSString localize:@"080_verifyAdvice"] ;
}

- (NSString*)labelVerifierPriorUrl {
	return [self labelUrlPrior] ;
}

- (NSString*)labelVerifierSuggestedUrl {
	return [self labelUrlSuggested] ;
}

- (NSString*)labelVerifierCode {
	return [NSString localize:@"080_verifyCode"] ;
}

- (NSString*)labelVerifierDisposition {
	return [NSString localize:@"080_verifyDisposition"] ;
}

- (NSString*)labelVerifierSubtype302 {
	return [NSString localizeFormat:
			@"appraisalX",
			@"HTTP 302"] ;
}

- (NSString*)labelVisitCount {
	return [NSString localize:@"001_Camino_visitCount"] ;
}

- (NSString*)labelVisitCountString {
	return [self labelVisitCount] ;
}

- (NSString*)labelVisitor {
	return [NSString localize:@"visitWith"] ;
}

- (NSString*)labelFaviconUrl {
	// Probably all languages use "Favicon" because this is for geeks only.
	return @"Favicon URL" ;
}

- (NSString*)labelVisitorDefault {
	return [NSString localize:@"visitWithDflt"] ;
}

- (NSString*)labelNoNilForKey:(NSString*)key {
	NSString* label = [key bkmxAttributeDisplayName] ;
	if (!label) {
		label = [key capitalizedString] ;
		NSLog(@"Internal Error 192-0184.  No localized value for %@", key) ;
	}
	
	return label ;
}

- (NSString*)labelNotch {
	// "Separator", in English
	return [NSString localize:@"001_Camino_separator"] ;
}

- (NSString*)labelNotches {
	return [NSString localize:@"001_Camino_separators"] ;
}

- (NSString*)labelContent {
	return [NSString localize:@"content"] ;
}

- (NSString*)labelMenus {
	return [NSString localize:@"menus"] ;
}

- (NSString*)labelTablesTags {
	return [[NSArray arrayWithObjects:
			 [NSString localize:@"tables"],
			 [self labelTags],
			 nil] listNames] ;
}

- (NSString*)labelMainContentView {
	return [NSString localize:@"viewOfMainContent"] ;
}

- (NSString*)labelReports {
	return [NSString localize:@"reports"] ;
}

- (NSString*)labelDuplicates {
	return [NSString localize:@"080_dupes"] ;
}

- (NSString*)labelOutlineMode {
	return [NSString localize:@"modeOutline"] ;
}

- (NSString*)labelAllow {
	return [NSString localize:@"allow"] ;
}

- (NSString*)labelDelete {
	// "Delete", in English
	return [NSString localize:@"delete"] ;
}

- (NSString*)labelBrowser {
	return [NSString localize:@"browser"] ;
}

- (NSString*)labelDefaultWebBrowser {
	NSString* defaultBrowser = [SSWebBrowsing defaultBrowserDisplayName] ;
	
	// Create the "Your default web Browser (xxxxx)" item
	NSString* answer = [NSString stringWithFormat:
						@"%@ (%@)",
						[NSString localizeFormat:
						 @"yourThing",
						 [NSString localizeFormat:
						  @"defaultThing",
						  [self labelBrowser]]],
						defaultBrowser] ;
	
	return answer ;
}

- (NSString*)toolTipShared {
	return [NSString localizeFormat:
			@"sharedTT2",
			[NSString localize:@"shared"]] ;
}

- (NSString*)labelDocumentInfo {
	return [NSString localize:@"documentInfo"] ;
}

- (NSString*)toolTipDocumentInfo {
	return [NSString localize:@"documentInfoToolTip"] ;
}

- (NSString*)labelIgnoreCommonPrefixesCheckbox {
	return [NSString localizeFormat:@"ignoreThing",
			[NSString localize:@"commonPrefixes"]] ;
}

- (NSString*)labelIgnoreDisparateDupes {
	return [NSString localize:@"folderHardDupeIgnore"] ;
}

- (NSString*)toolTipIgnoreDisparateDupes {
	return [NSString localize:@"folderHardDupeIgnoreTT"] ;
}

- (NSString*)labelDoOpenAfterLaunch {
	return [NSString localizeFormat:
			@"afterLaunchDo",
			[[NSString localizeFormat:@"openThing", [NSString localize:@"documentThis"]] lowercaseString],
			[[BkmxBasis sharedBasis] appNameLocalized]] ;
}

- (NSString*)labelIgnoredPrefixes {
    NSString* s ;
    if ([self iAm] == BkmxWhich1AppBookMacster) {
        s = [NSString localizeFormat:
             @"commonPrefixesDescBkmx",
             [NSString localize:@"commonPrefixes"],
             [[NSDocumentController sharedDocumentController] defaultDocumentDisplayName],
             [self labelIgnoreCommonPrefixesCheckbox],
             [self labelSettings],
             [self labelSorting]] ;
    }
    else {
        s = [NSString localizeFormat:
             @"commonPrefixesDescription",
             [NSString localize:@"commonPrefixes"],
             [[NSDocumentController sharedDocumentController] defaultDocumentDisplayName],
             [self labelIgnoreCommonPrefixesCheckbox],
             [self labelSorting]] ;
    }
	return s ;
}

- (NSString*)labelCheckUpdatesOnLaunch {
	return [NSString localizeFormat:
			@"checkUpdatesOnLaunch%0",
			[[BkmxBasis sharedBasis] appNameLocalized]] ;
}

- (NSString*)labelUpdateAutomatically {
	return [NSString localize:@"updateAutomatically"] ;
}

- (NSString*)labelTrailingSpaceCheckbox {
	return [NSString localize:@"checkToIndicateSpace"] ;
}

- (NSString*)labelSortBy {
	return [[NSString localize:@"sortAlphaNumBy"] ellipsize] ;
}

- (NSString*)labelImportPostproc {
	return [NSString stringWithFormat:
			@"%@ (%@)",
			[NSString localizeFormat:
			 @"processingPostX",
			 [self labelImport]],
			[self labelAdvanced]] ;
}

- (NSString*)labelShowImportPostproc {
	return [NSString localizeFormat:
			@"showX",
			[self labelImportPostproc]] ;
}

- (NSString*)labelEntireUrl {
	return [NSString localize:@"entireURL"] ;
}

- (NSString*)labelDomainHostPath {
	return [NSString localize:@"domainHostPath"] ;
}

- (NSString*)labelSortableDefault {
	return [[NSString localize:@"sortable0Default"] ellipsize] ;
}

- (NSString*)labelSortableDo {
	return [NSString localize:@"sortable1Do"] ;
}

- (NSString*)labelSortableDont {
	return [NSString localize:@"sortable2Dont"] ;
}

- (NSString*)labelSortableAsParent {
	return [NSString localize:@"sortable3AsParent"] ;
}

- (NSString*)labelSortRoot {
	return [NSString localize:@"sortRoot"] ;
}

- (NSString*)labelExample {
	return [[NSString localize:@"example"] stringByAppendingString:@":"] ;
}

- (NSString*)labelSortingSegmentation {
	return [[NSString localize:@"withinEachFolderSortMixedOrSep"] ellipsize] ;
}

- (NSString*)labelFoldersAboveBookmarks {
	return [NSString localize:@"foldersAboveBookmarks"] ;
}

- (NSString*)labelBookmarksAboveFolders {
	return [NSString localize:@"bookmarksAboveFolders"] ;
}

- (NSString*)labelMixed {
	return [NSString localize:@"mixed"] ;
}

- (NSString*)labelSegmentSortBoth {
    return [NSString localize:@"segmentSortBoth"] ;
}

- (NSString*)labelSegmentSortFolders {
    return [NSString localize:@"segmentSortFolders"] ;
}

- (NSString*)labelSegmentSortBookmarks {
    return [NSString localize:@"segmentSortBookmarks"] ;
}

- (NSString*)labelEventAppLaunch {
	return [NSString localizeFormat:@"eventAppLaunch",
			[[BkmxBasis sharedBasis] appNameLocalized]] ;
}

- (NSString*)labelEventDocSaved {
	return [NSString localize:@"eventDocSaved"] ;
}

- (NSString*)labelEventLogInMac {
	return [NSString localize:@"eventLogInMac"] ;
}

- (NSString*)labelEventSchedDate {
	return [NSString localize:@"eventScheduled"] ;
}

- (NSString*)labelEventPeriodic {
	return [NSString localize:@"eventPeriodic"] ;
}

- (NSString*)labelEventBookmarksChanged {
	return [NSString localize:@"eventBookmarksChanged"] ;
}

- (NSString*)labelEventBrowserQuit {
	return [NSString localize:@"eventBrowserQuit"] ;
}

- (NSString*)labelEventLanded {
	return [NSString localize:@"eventLanding"] ;
}

- (NSString*)labelEventOtherMacDrop {
	return [NSString localizeFormat:
			@"eventOtherMacUpdate",
			[[NSDocumentController sharedDocumentController] defaultDocumentDisplayName]] ;
}

- (NSString*)labelClient {
    NSString* answer ;
    if ([self iAm] == BkmxWhich1AppBookMacster) {
        answer = [NSString localize:@"imex_client"] ;
    }
    else {
        answer = [self labelBrowser] ;
    }
    
	return answer ;
}

- (NSString*)labelClientImex {
	return [NSString stringWithFormat:
			@"%@ (%@/%@)",
			[self labelClient],
			[self labelImport],
			[self labelExport]] ;
}

- (NSString*)labelClients {
    NSString* answer ;
    switch ([self iAm]) {
        case BkmxWhich1AppSmarky:
            answer = @"Safari" ;
            break ;
        case BkmxWhich1AppSynkmark:
        case BkmxWhich1AppMarkster:
            answer = [NSString localize:@"browsers"] ;
            break ;
        case BkmxWhich1AppBookMacster:
        default:
            answer = [NSString localize:@"imex_clients"] ;
            break ;
    }
    
	return answer ;
}

- (NSString*)labelTagDelimiter {
    return [NSString localize:@"tagDelimiter"] ;
}

- (NSString*)labelTagDelimiterDefault1 {
	return [NSString localizeFormat:
			@"defaultThing",
			[self labelTagDelimiter]] ;
}

- (NSString*)toolTipTagDelimiter {
	return [NSString localize:@"tagDelimiterChooseTT"] ;
}

- (NSString*)toolTipTagDelimiterDefault {
	return [NSString stringWithFormat:
			@"%@\n\n%@",
			[self toolTipTagDelimiter],
			[NSString localizeFormat:
			 @"defaultCanOverrideWith",
			 [self labelSettings],
			 [[NSDocumentController sharedDocumentController] defaultDocumentDisplayName]]] ;
}

- (NSString*)tagDelimiterReplacementToolTip {
	return @"The character which will replace characters "
	@"in tags that are not allowed in the Client, during exports.  For example, Pinboard does not allow "
	@"the space character in tags because it is their Tag Delimiter. " ;
}

- (NSString*)labelLineage {
	return [NSString localize:@"lineage"] ;
}

- (NSString*)toolTipLineage {
	return [NSString localize:@"lineageTT"] ;
}

- (NSString*)labelTableMode {
	return [NSString localize:@"modeTable"] ;
}

+ (NSSet*)keyPathsForValuesAffectingToolTipTags {
	return [NSSet setWithObject:constKeyTagDelimiterDefault] ;
}

- (NSString*)labelIdentifier {
	return [NSString localize:@"identifier"] ;
}

- (NSString*)labelRssArticle {
	return [NSString localize:@"articleRSS"] ;
}

- (NSString*)labelRssFeeds {
	return [NSString localize:@"rssFeed"] ;
}

- (NSString*)labelJavaScriptBookmarklets {
	return [NSString localize:@"javaScriptBookmarklets"] ;
}

- (NSString*)labelFileUrls {
	return [NSString localize:@"fileUrls"] ;
}

- (NSString*)toolTipShowLatestVerifyAndUrl {
	return [NSString localize:@"urlVerifySidebar"] ;
}

- (NSString*)toolTipShowMore {
	return [NSString localizeFormat:
			@"showX", 
			@"more"] ;
}

- (NSString*)labelAfterOpenDo {
	return [NSString localize:@"openAfterDoList"] ;
}

- (NSString*)labelAutosaveUponClose {
	return [NSString localize:@"saveAutoUponClose"] ;
}

- (NSString*)tooltipAutosaveUponClose {
	return [NSString localize:@"saveAutoUponCloseToolTip"] ;
}

- (NSString*)labelBeforeSaveDo {
	return [NSString localize:@"saveBeforeDoList"] ;
}

- (NSString*)labelMerging {
	return [NSString localize:@"mergingNoun"] ;
}

- (NSString*)labelMergeBy {
    return NSLocalizedString(@"Merge by", nil);
}
/*!
 @brief    Returns localized "Keep matched item from"

 @details  Used in ClientInfo.xib
*/
- (NSString*)labelMergeKeep {
	return [NSString localize:@"mergeKeep"] ;
}

- (NSString*)labelMergeKeepItemFrom {
    return NSLocalizedString(@"When merging, keep item from", nil) ;
}

- (NSString*)toolTipMergeKeepExport {
	return [NSString localizeFormat:@"mergeKeepTTX3",
			[self labelExport],
			[[NSDocumentController sharedDocumentController] defaultDocumentDisplayName],
			[self labelClient]
			] ;
}

- (NSString*)toolTipExportSeparators {
	return [NSString localizeFormat:
			@"imex_client_expSepX",
			[NSString stringWithFormat:
			 @"%@:%@",
			 [[BkmxBasis sharedBasis] labelMerging],
			 [[BkmxBasis sharedBasis] labelMergeKeep]]] ;
}

- (NSString*)toolTipExportFileUrls {
	return [NSString localize:@"imex_client_expFileUrl"] ;
}

- (NSString*)toolTipExportJavaScript {
	return [NSString localize:@"imex_client_expJavaScript"] ;
}

- (NSString*)toolTipExportRssFeeds {
	return [NSString localize:@"imex_client_expRssFeed"] ;
}

- (NSString*)toolTipMergeKeepImport {
	return [NSString localizeFormat:@"mergeKeepTTX3",
			[self labelImport],
			[[NSDocumentController sharedDocumentController] defaultDocumentDisplayName],
			[self labelClient]
			] ;
}

- (NSString*)toolTipMergeUrlExport {
	return [NSString localizeFormat:@"mergeKeepUrlTTX2",
			[self labelExport],
			[NSString localizeFormat:
			 @"normalizedX",
			 @"URL"]
			] ;
}

- (NSString*)toolTipMergeUrlImport {
	return [NSString localizeFormat:@"mergeKeepUrlTTX2",
			[self labelImport],
			[NSString localizeFormat:
			 @"normalizedX",
			 @"URL"]
			] ;
}

- (NSString*)toolTipSyncSnapshots {
	return
	@"Sync Snapshots can be used troubleshoot syncing issues or undo exports.  "
	@"They use some disk space, and some milliseconds of system resources during sync operations.\n\n"
	@"If not zero, two snapshots are taken per export, and one per import.\n\n"
	@"Snapshots are in ~/Library/Application Support/BookMacster/SyncSnapshots/" ;
}

- (NSString*)labelFabricateColon {
	return [[NSString localize:@"fabricate"] colonize] ;
}

- (NSString*)labelFabricate {
	return [NSString localize:@"fabricate"] ;
}

- (NSString*)toolTipFabricateTags {
	return [NSString localize:@"tagsFabTagsTT"] ;
}

// This is no longer used
- (NSString*)toolTipFabricateFolders {
	return [NSString localize:@"tagsFabFoldersTT"] ;
}

- (NSString*)toolTipFabFoldersAny {
	return [NSString localize:@"tagsFabFoldersAnyTT"] ;
}

- (NSString*)toolTipFabFoldersMany {
	return [NSString localize:@"tagsFabFoldersManyTT"] ;
}

- (NSString*)labelShareNewItems {
	return [NSString localize:@"shareNewItems"] ;
}

- (NSString*)toolTipShareNewItems {
	return [NSString stringWithFormat:@"%@\n\n%@",
			[NSString localizeFormat:
			 @"sharedTT1",
			 [NSString localize:@"shared"]],
			[self toolTipShared]] ;
}

- (NSString*)labelDefaultParent {
	return [NSString localize:@"parentDefault"] ;
}

- (NSString*)labelDoIt {
	return [NSString localize:@"doIt"] ;
}

- (NSString*)labelDone {
	return [NSString localize:@"done"] ;
}

- (NSString*)labelIgnore {
	return [NSString localize:@"ignore"] ;
}

- (NSString*)toolTipDefaultParentImport {
	return [NSString localizeFormat:
			@"parentDefaultTTX3",
			[self labelImport],
			[self labelClient],
			[self labelHartainer]] ;
}

- (NSString*)toolTipDefaultParentExport {
	return [NSString localizeFormat:
			@"parentDefaultTTX3",
			[self labelExport],
			[[NSDocumentController sharedDocumentController] defaultDocumentDisplayName],
			[self labelHartainer]] ;
}

- (NSString*)labelDeleteAll {
	return [[NSString localizeFormat:
			@"delete%0",
			[NSString localize:@"all"]] ellipsize] ;
}

- (NSString*)toolTipAllowDupe {
	return [NSString localizeFormat:
			@"attributeSetX2",
			[self labelIsAllowedDupe],
			[[NSString localize:@"000_Safari_Bookmarks"] lowercaseString]] ;
}

- (NSString*)labelDeleteAllDupes {
	return [NSString localizeFormat:
			@"delete%0",
			[NSString localizeFormat:
			 @"allX",
			 [NSString localize:@"080_dupes"]]] ;
}

- (NSString*)toolTipDeleteAllDupes {
	return [NSString localize:@"dupesGroupsDelAllTT1"] ;
}

- (NSString*)labelEmptyCache {
	return [NSString localizeFormat:
	  @"emptyX",
	  [NSString localize:@"cache"]] ;
}
	
- (NSString*)labelCacheDefine {
	return [NSString localizeFormat:
			@"cacheDefine",
			[[BkmxBasis sharedBasis] appNameLocalized],
			[NSString localizeFormat:@"000_Safari_Bookmarks"]] ;
}

- (NSString*)labelEmpty {
	return [NSString localize:@"emptyZ"] ;
}

- (NSString*)labelCacheEmptyDef {
	return [NSString localizeFormat:
			@"cacheEmptyHow",
			[[BkmxBasis sharedBasis] appNameLocalized],
			[NSString localizeFormat:@"000_Safari_Bookmarks"],
			[self labelImport],
			[self labelEmpty]] ;
}

- (NSString*)labelActive {
	return [NSString localize:@"active"] ;
}

- (NSString*)toolTipClient {
	return [NSString localize:@"imex_clientTT"] ;
}

- (NSString*)toolTipImportClient {
	return [NSString localize:@"imex_clientImTT"] ;
}

- (NSString*)toolTipExportClient {
	return [NSString localize:@"imex_clientExTT"] ;
}

- (NSString*)toolTipReorderClient {
	return [NSString localizeFormat:
			@"reorderTTX", 
			[self labelClient]] ;
	
}

- (NSString*)labelSyncer {
	return NSLocalizedString(@"Syncer", "A little elf inside the computer that automatically performs a syncing job when certain triggers occur") ;
}

- (NSString*)labelSyncers {
    return NSLocalizedString(@"Syncers", "More than one 'Syncer'") ;
}

- (NSString*)labelSyncing {
    return NSLocalizedString(@"Syncing", nil) ;
}

- (NSString*)labelDeleteAgent {
	return [NSString localizeFormat:
			@"delete%0",
			[NSString localize:@"syncer"]] ;
}

- (NSString*)toolTipSyncers {
	return [NSString localizeFormat:
			@"syncersToolTipX",
			[[BkmxBasis sharedBasis] appNameLocalized]] ;
}

- (NSString*)toolTipSyncersTable {
	return [[self toolTipSyncers] appendReorderingTipForLabel:[self labelSyncer]] ;
}

- (NSString*)toolTipDefaultAgent {
	return [NSString localize:@"agentDefaultTT"] ;
}

- (NSString*)labelTrigger {
	return [NSString localize:@"syncerzTrigger"] ;
}

- (NSString*)labelTriggers {
	return [NSString localize:@"syncerzTriggers"] ;
}

- (NSString*)labelPerform {
	return [[NSString localize:@"perform"] ellipsize] ;
}

- (NSString*)toolTipSyncerPerform {
	return [NSString localizeFormat:
			@"agentPerformToolTipX2",
			[self labelCommands],
			[self labelTrigger]] ;
}

- (NSString*)toolTipTriggers {
	return [NSString localize:@"syncerzTriggersToolTip"] ;
}

- (NSString*)toolTipTriggersTable {
	return [[self toolTipTriggers] appendReorderingTipForLabel:[self labelTrigger]] ;
}

- (NSString*)labelCommand {
	return [NSString localize:@"syncerzCommand"] ;
}

- (NSString*)labelCommands {
	return [NSString localize:@"syncerzCommands"] ;
}

- (NSString*)toolTipCommands {
	return [NSString localizeFormat:@"syncerzCommandsToolTip"] ;
}

- (NSString*)toolTipCommandsTable {
	return [[self toolTipCommands] appendReorderingTipForLabel:[self labelCommand]] ;
}

- (NSString*)labelNewDocument {
	return [NSString localizeFormat:
			@"new%0",
			[NSString localize:@"document"]] ;
}


/*
 Bound to from text field in ClientsWiz.xib
 */
- (NSString*)labelNewDocWizIntro {
	return [NSString localizeFormat:
			@"imexNewDocX1",
			[self labelClients]] ;
}

- (NSString*)labelNewBkmxDoc {
	return [NSString localizeFormat:
			@"new%0",
			[[NSDocumentController sharedDocumentController] defaultDocumentDisplayName]] ;
}

- (NSString*)labelStatusCode {
	return [NSString localize:@"columnHeadingCode"] ;
}

// Should get rid of this but maybe it is used in a nib?
- (NSString*)labelDescription {
	return [self labelComments] ;
}

- (NSString*)labelBrokenNot {
	return [NSString localize:@"brokenNot"] ;
}

- (NSString*)labelUpdated {
	return [NSString localize:@"updated"] ;
}

- (NSString*)labelSecured {
    return [NSString localize:@"secured"] ;
}

- (NSString*)labelUpdatedNot {
	return [NSString localize:@"updatedNot"] ;
}

- (NSString*)labelUpdatedByApp {
	return [NSString localizeFormat:
			@"updatedByX",
			[[BkmxBasis sharedBasis] appNameLocalized]] ;
}

- (NSString*)labelDescribe200 {
	return [[NSHTTPURLResponse localizedStringForStatusCode:200] capitalizedString] ;
}

- (NSString*)labelDescribeOtherOk {
	return [NSString localize:@"otherOK"] ;
}

- (NSString*)labelDescribeSecured {
    return [NSString localize:@"secured"] ;
}

- (NSString*)labelDescribe301 {
	if ([[NSString languageCodeLoaded] isEqualToString:@"it"]) {
		return @"Mosso Permanente" ;  // The one given by "else" is too long in Italiano		
	}
	else if ([[NSString languageCodeLoaded] isEqualToString:@"fr"]) {
		return [NSString stringWithFormat:@"D%Cplacement\nPermanent", (unsigned short)0x00e9] ;  // The one given by "else" is too long in French		
	}
	else {
		return [[NSHTTPURLResponse localizedStringForStatusCode:301] capitalizedString] ;
	}
}

- (NSString*)labelDescribe302ProbTemp {
	return [NSString localize:@"302MoreAz"] ;
}

- (NSString*)labelDescribe302ProbPerm {
	return [NSString localize:@"302MoreDz"] ;
}

- (NSString*)labelDescribe302NotSure {
	return [NSString localize:@"302MoreUz"] ;
}

- (NSString*)labelDescribe404 {
	return [[NSHTTPURLResponse localizedStringForStatusCode:404] capitalizedString] ;
}

- (NSString*)labelDescribe1001 {
	return [NSString localize:@"1001Official"] ;
}

- (NSString*)labelDescribe1003 {
	return [NSString localize:@"1003Official"] ;
}

- (NSString*)labelOtherErrors {
	return [NSString localize:@"otherErrors"] ;
}

- (NSString*)labelBroken {
	return [NSString localize:@"broken"] ;
}

- (NSString*)labelUnknown {
	return [NSString localize:@"unknown"] ;
}

- (NSString*)labelTotalNBookmarks {
	return [NSString localize:@"trailerTotalNBookmarks"] ;
}

- (NSString*)labelAsk {
	return [NSString localize:@"ask"] ;
}

- (NSString*)labelCancel {
	return [NSString localize:@"cancel"] ;
}

- (NSString*)labelMerge {
	return [NSString localize:@"merge"] ;
}

- (NSString*)labelIfDupingBookmark {
	return [NSString localize:@"dupingBookmark"] ;
}

- (NSString*)labelRetry {
	return [NSString localize:@"retry"] ;
}

- (NSString*)labelOk {
	return [NSString localize:@"ok"] ;
}

- (NSString*)labelVerify {
	return [NSString localize:@"080_verify"] ;
}

/*!
 @brief    Returns localized "Keep Both"

 @details  Used in the middle button in the middle of
 the New Bookmark Landing dialog announcing that that
 the proposed bookmark is a duplicate
*/
- (NSString*)labelDoKeepBoth {
	return [NSString localize:@"mergeDoKeepBoth"] ;
}

- (NSString*)labelPreferences {
	return [NSString localize:@"preferences"] ;
}

- (NSString*)labelIxportDiariesLimit {
	return [NSString localize:@"imex_logsKeep"] ;
}

- (NSString*)labelDaysKeep {
	return [NSString localize:@"keepDays"] ;
}

- (NSString*)labelLogs {
	return [NSString localize:@"logs"] ;
}
	
- (NSString*)labelDiaries {
	return [self labelSyncLog] ;
}

- (NSString*)labelErrors {
	return [NSString localize:@"errors"] ;
}

- (NSString*)labelMessages {
	return [NSString localize:@"messages"] ;
}

- (NSString*)labelLogsMsgsErrs {
	return [NSString stringWithFormat:
			@"%@ (%@, %@)",
			[self labelLogs],
			[self labelMessages],
			[self labelErrors]] ;
}

- (NSString*)tooltipReloadMessages {
	return [NSString localizeFormat:
			@"reloadX",
			[self labelMessages]] ;
}

- (NSString*)labelImportOrExport {
	return [NSString stringWithFormat:
			@"%@ %@ %@",
			[self labelImport],
			[NSString localize:@"filterRuleOr"],
			[self labelExport]] ;
}

- (NSString*)labelDiariesImpExp {
	return [NSString stringWithFormat:
			@"%@ (%@)",
			[self labelDiaries],
			[self labelImportOrExport]] ;
}

- (NSString*)labelChooseIxportDiary {
	return [NSString localizeFormat:
			@"choose%0",
			[self labelSyncLog]] ;
}

- (NSString*)labelVerifyColon {
	return [[self labelVerify] colonize] ;
}

- (NSString*)labelNew {
	return [NSString localize:@"new"] ;
}

- (NSString*)labelBookmarks {
	return [NSString localize:@"000_Safari_Bookmarks"] ;
}

- (NSString*)labelCollection {
	return [[NSDocumentController sharedDocumentController] defaultDocumentDisplayName] ;
}

- (NSString*)labelDocuments {
	return [NSString localize:@"documents"] ;
}

- (NSString*)labelAllBookmarks {
	return [NSString localizeFormat:
			@"allX",
			[self labelBookmarks]] ;
}

- (NSString*)labelVerifyAll {
	return [NSString localizeFormat:
			@"080_verifyX",
			[self labelAllBookmarks]] ;
}

- (NSString*)labelVerifiedSince {
	return [NSString localize:@"080_verifyOnlySince"] ;
}

- (NSString*)labelVerifiedNever {
	return [NSString localize:@"080_verifyOnlyNever"] ;
}

- (NSString*)labelVerifyEllipsis {
	return [[self labelVerify] ellipsize] ;
}

- (NSString*)labelUnverified {
	return [NSString localize:@"080_verifyNotDone"] ;
}

- (NSString*)labelSkipped {
	return [NSString localize:@"080_skipped"] ;
}

- (NSString*)labelFindReplace {
	return [NSString localize:@"findReplace"] ;
}

- (NSString*)toolTipHttp1001 {
	return [NSString localize:@"1001More"] ;
}

- (NSString*)toolTipHttp1003 {
	return [NSString localize:@"1003More"] ;
}

- (NSString*)toolTipHttp301 {
	return [NSString localizeFormat:
			@"301More",
			[[BkmxBasis sharedBasis] appNameLocalized]] ;
}

- (NSString*)toolTipHttp302ProbTemp {
	return [NSString localize:@"302MoreA"] ;
}

- (NSString*)toolTipHttp302ProbPerm {
	return [NSString localizeFormat:
			@"302MoreD",
			[[BkmxBasis sharedBasis] appNameLocalized]] ;
}

- (NSString*)toolTipHttp302Unsure {
	return [NSString localizeFormat:
			@"302MoreU",
			[[BkmxBasis sharedBasis] appNameLocalized]] ;
}

- (NSString*)toolTipHttp404 {
	return [NSString localize:@"404More"] ;
}

- (NSString*)toolTipDontVerify {
	return [NSString localizeFormat:
			@"080_verifyDontToolTip",
			[self labelDontVerify]] ;
}

- (NSString*)toolTipUnverifiable {
	return [NSString localizeFormat:
			@"080_skippedExplain",
			[self labelSkipped]] ;
}

- (NSString*)toolTipVerifyOtherOk {
	return [NSString localize:@"siteWantsPassword"] ;
}

- (NSString*)toolTipVerifyUnverified {
	return [NSString localize:@"080_verifyUnverifiedToolTip"] ;
}

- (NSString*)labelSwapPriorAndCurrentUrl {
	return [NSString localizeFormat:
			@"swapX",
			[NSString localize:@"current"],
			[NSString localize:@"prior"],
			@"URL"] ;
}

- (NSString*)labelSwapSuggestedAndCurrentUrl {
	return [NSString localizeFormat:
			@"swapX",
			[NSString localize:@"current"],
			[NSString localize:@"suggested"],
			@"URL"] ;
}

- (NSString*)labelVisit {
	return [NSString localize:@"visit"] ;
}

- (NSString*)labelVisitForBookmarksCount:(NSInteger)nBookmarks
	urlTemporality:(BkmxUrlTemporality)urlTemporality {
	NSString* title ;
		
	if (nBookmarks > 1) {
		title = [NSString stringWithFormat:[NSString localize:@"visitNWebPages"], nBookmarks] ;
	}
	else  {
		title = [self labelVisit] ;
	}
	
	if (urlTemporality == BkmxUrlTemporalityPrior) {
		title = [title stringByAppendingFormat:
				 @" (%@)",
				 [self labelUrlPrior]] ;
	}
	else if (urlTemporality == BkmxUrlTemporalitySuggested) {
		title = [title stringByAppendingFormat:
				 @" (%@)",
				 [self labelUrlSuggested]] ;
	}
	
	return title ;
}

- (NSString*)labelShowFolders {
	return [NSString stringWithFormat:@"%@ (%@)",
			[NSString localizeFormat:
			 @"showX",
			 [[NSString localize:@"folders"] capitalizedString]],
			[self labelOutlineMode]] ;
}	

- (NSString*)labelSearch {
	return [NSString localize:@"findQuick"] ;
}

- (NSString*)labelSearchFor {
	return [NSString localize:@"findQuickFor"] ;
}

- (NSString*)labelSearchIn {
	return [NSString localize:@"findQuickIn"] ;
}

- (NSString*)labelRecentSearches {
	return [NSString localizeFormat:
			@"recent%0",
			[NSString localize:@"searches"]] ;
}

- (NSString*)labelNoRecentSearches {
	return [NSString localizeFormat:
			@"no%0",
			[self labelRecentSearches]] ;
}

- (NSString*)labelClearRecentSearches {
	return [NSString localizeFormat:
			@"clearX",
			[self labelRecentSearches]] ;
}

- (NSString*)labelHelp {
	return [NSString localize:@"help"] ;
}

- (NSString*)labelInspector {
	return [NSString localize:@"inspector"] ;
}

- (NSString*)labelShowInspector {
	return [NSString localizeFormat:
			@"showX",
			[self labelInspector]] ;
}

- (NSString*)labelHideInspector {
	return [NSString localizeFormat:
			@"hideX",
			[self labelInspector]] ;
}

- (NSString*)labelShowApp {
	return [NSString localizeFormat:
			@"showX",
			[self appNameLocalized]] ;
}

- (NSString*)labelBackgroundApp {
	return [NSString localizeFormat:
			@"backgroundVerbX",
			[self appNameLocalized]] ;
}

- (NSString*)labelAutoSaveNo {
	return [NSString localize:@"autoSaveNo"] ;
}

- (NSString*)toolTipBackground {
    return [NSString stringWithFormat:@"%@ %@",
            [NSString localizeFormat:
             @"backgroundToolTipX1",
             [[BkmxBasis sharedBasis] appNameLocalized]],
            [NSString localize:@"backgroundExplain"]] ;
}

- (NSString*)toolTipBackgroundLaunch {
    NSString* answer =  [NSString stringWithFormat:@"%@ %@",
            [NSString localizeFormat:
             @"backgroundLaunchToolTipX1",
             [[BkmxBasis sharedBasis] appNameLocalized]],
            [NSString localize:@"backgroundExplain"]] ;
    if ([[BkmxBasis sharedBasis] isAMainAppWhichCanSync]) {
        answer = [answer stringByAppendingFormat:
                  @"\n\n%@",
                  [NSString localizeFormat:
                   @"backgroundDisrespectX1",
                   [[BkmxBasis sharedBasis] appNameLocalized]]] ;
    }
    
    return answer ;
}

- (NSString*)labelMergeTags {
	return [NSString localizeFormat:
			@"mergeX",
			[self labelTags]] ;
}

- (NSString*)labelFix {
	return [NSString localize:@"080_fix"] ;
}

- (NSString*)labelSyncerBadEndDontWarn {
    NSString* answer = [NSString localizeFormat:
                        @"agentBadEndDontWarn",
                        [self labelCommands],
                        [self labelExport],
                        [self labelSave]] ;
	return answer ;
}

- (NSString*)labelSyncerBadTrigDontWarn {
	return [NSString localizeFormat:
			@"agentBadTrig0DontWarn",
			[self labelTriggers]] ;
}

- (NSString*)labelDontWarnOtherMacBrowsers {
	return [NSString localize:@"quitOtherAccountAppNoWarn"] ;
}

- (NSString*)labelExpandRoots {
    return [NSString localizeFormat:
            @"expandX",
            [NSString localize:@"lineageRootChildren"]] ;
}

- (NSString*)labelCollapseRoots {
    return [NSString localizeFormat:
            @"expandNotX",
            [NSString localize:@"lineageRootChildren"]] ;
}

- (NSString*)labelDeleteAllContent {
	return [NSString localizeFormat:
			@"delete%0",
			[NSString localizeFormat:
			 @"allX",
			 [self labelContent]]] ;
}

- (NSString*)labelRemoveLegacyArtifacts {
	return [NSString localizeFormat:
			@"removeX",
			[NSString localizeFormat:
			 @"artifactsX",
			 constLegacyAppName]] ;
}

- (NSString*)labelRemove {
	return [NSString localize:@"remove"] ;
}

- (NSString*)labelExportAndSave {
	return [NSString stringWithFormat:
			@"%@ %@ %@",
			[self labelExport],
			[self labelAndEndList],
			[self labelSave]] ;
}

- (NSString*)labelExportAndClose {
	return [NSString stringWithFormat:
			@"%@ %@ %@",
			[self labelExport],
			[self labelAndEndList],
			[self labelClose]] ;
}

- (NSString*)labelChooseClients {
	return [NSString localizeFormat:
			@"choose%0",
			[self labelClients]] ;
}

- (NSString*)labelChooseFileFormat {
	return [NSString localizeFormat:
			@"choose%0",
			[NSString localize:@"fileFormat"]] ;
}

- (NSString*)labelForceQuit {
	return [NSString localize:@"quitForce"] ;
}

- (NSString*)labelCheckForUpdate {
	return [NSString localize:@"checkForUpdate"] ;
}

- (NSString*)labelTryCommandCheckForUpdate {
	return [NSString localizeFormat:@"menuMainClickX",
			[NSString stringWithFormat:@"%@ > %@",
			 [[BkmxBasis sharedBasis] mainAppNameLocalized],
			 [self labelCheckForUpdate]]] ;
}

- (NSString*)labelLaunchBrowserPref {
	return @"launch browser during Syncs (Import or Export)" ;
}

- (NSString*)labelChromeOtherBookmarks {
	return [NSString localize:@"004_Chrome_otherBookmarks"] ;
}

- (NSString*)labelSafeLimit {
	return [NSString localize:@"imex_safeSyncLimit"] ;
}

- (NSString*)labelSafeLimitExport {
	return [NSString stringWithFormat:
			@"%@ %@",
			[self labelExport],
			[self labelSafeLimit]] ;
}

- (NSString*)labelSafeLimitImport {
	return [NSString stringWithFormat:
			@"%@ %@",
			[self labelImport],
			[self labelSafeLimit]] ;
}

- (NSString*)labelAdvancedSettings {
	return [NSString localizeFormat:
			@"expertiseAdvancedX",
			[self labelSettings]] ;
}

- (NSString*)labelTalderMaps {
	return [NSString localize:@"mapsTagFolder"] ;
}

- (NSString*)labelTalderMapsEllipsized {
	return [[self labelTalderMaps] ellipsize] ;
}

- (NSString*)labelShowAdvancedSettings {
	return [NSString localizeFormat:
			@"showX",
			[self labelAdvancedSettings]] ;
}

- (NSString*)labelAdvancedSettingsImport {
	return [NSString stringWithFormat:
			@"%@ : %@",
			[self labelImport],
			[self labelAdvancedSettings]] ;
}

- (NSString*)labelDeleteUnmatchedItems {
	return [NSString localize:@"matchDeleteItems"] ;
}

- (NSString*)toolTipDeleteUnmatchedItemsIm {
	return [NSString localizeFormat:
			@"matchDeleteItemsTTIm",
			[NSString localize:@"document"],
			[self labelClients],
			[NSString stringWithFormat:
			 @"%@ URL",
			 [self labelMergeBy]]] ;
}

- (NSString*)toolTipDeleteUnmatchedItemsEx {
	return [NSString localizeFormat:
			@"matchDeleteItemsTTEx",
			[self labelClient],
			[NSString localize:@"document"]] ;
}

- (NSString*)labelOff {
	return [NSString localize:@"off"] ;
}

- (NSString*)labelOne {
	return [NSString localize:@"one"] ;
}

- (NSString*)labelAll {
	return [NSString localize:@"all"] ;
}

/* Bound to by Inspector nib */
- (NSString*)toolTipTags {
	return [NSString localizeFormat:
			@"tagDelimiter_tooltip%0",
			[[[NSUserDefaults standardUserDefaults] objectForKey:constKeyTagDelimiterDefault] characterDisplayName]] ;
}

- (NSString*)toolTipTagCloud {
	return [NSString localize:@"viewOfTagsTT"] ;
}

- (NSString*)labelSortWhich {
	return [[NSString localize:@"sortQWhich"] ellipsize] ;
}

- (NSString*)labelSortHow {
	return [[NSString localize:@"sortQHow"] ellipsize] ;
}

- (NSString*)labelSortOrder {
	return [[NSString localize:@"sortQHow"] ellipsize] ;
}

- (NSString*)labelSortWhen {
	return [[NSString localize:@"sortQWhen"] ellipsize] ;
}

- (NSString*)toolTipCommonPrefixesSwitch {
	return [NSString localize:@"commonPrefixesSwitchTT"] ;
}

- (NSString*)toolTipRoot {
	return [NSString localize:@"lineageRootTT"] ;
}

- (NSString*)labelAndEndList {
	return [NSString localize:@"andEndList"] ;
}

- (NSString*)labelAutoImport {
	return [NSString localize:@"imex_autoImport"] ;
}

- (NSString*)labelAutoExport {
	return [NSString localize:@"imex_autoExport"] ;
}

- (NSString*)labelImportAutoImport {
	return [NSString stringWithFormat:
			@"%@ (%@)",
			[self labelImport],
			[self labelAutoImport]] ;
}

- (NSString*)labelExportAutoExport {
	return [NSString stringWithFormat:
			@"%@ (%@)",
			[self labelExport],
			[self labelAutoExport]] ;
}

- (NSString*)labelColors {
	return [NSString localize:@"colors"] ;
}

- (NSString*)labelFontSize {
	return [NSString localizeFormat:@"sizeX",
			[NSString localize:@"font"]] ;
}

- (NSString*)labelActiveSyncers {
	return [NSString localizeFormat:
			  @"activeX",
			  [self labelSyncers]] ;
}

- (NSString*)labelShowWelcomeOnLaunch {
	return @"Ask what to do if nothing opens on launch" ;
}

- (NSString*)labelItem {
	return [NSString localize:@"item"] ;
}

- (NSString*)labelExpanded {
	return [NSString localize:@"expanded"] ;
}

- (NSString*)labelCollapsed {
	return [NSString localize:@"expandedNot"] ;
}

- (NSString*)labelIsExpanded {
	return [NSString stringWithFormat:
			@"%@/%@",
			[self labelExpanded],
			[self labelCollapsed]] ;
}

- (NSString*)labelFolders {
	return [[NSString localize:@"folders"] capitalizedString] ;
}

- (NSString*)labelShowTagsOrFolders {
	return [NSString localizeFormat:
			@"showX",
			[NSString stringWithFormat:
			 @"%@/%@",
			 [self labelTags],
			 [self labelFolders]]] ; 
}

- (NSString*)labelSortAfterOpen {
	return [NSString stringWithFormat:
			@"%@ : %@",
			[self labelOpen],
			[self labelSort]] ;
}

- (NSString*)labelFindDupesAfterOpen {
	return [NSString stringWithFormat:
			@"%@ : %@",
			[self labelOpen],
			[self labelFindDupes]] ;
}

- (NSString*)labelFabricateFolders {
	return [NSString stringWithFormat:
			@"%@ : %@",
			[self labelFabricate],
			[self labelFolders]] ;
}

- (NSString*)labelFabricateTags {
	return [NSString stringWithFormat:
			@"%@ : %@",
			[self labelFabricate],
			[self labelTags]] ;
}

- (NSString*)labelOneForEachTag {
	return [NSString localizeFormat:
			@"fabOnePerX",
			[NSString localize:@"tag"]] ;
}

- (NSString*)labelFilter {
	return [NSString localize:@"filter"] ;
}

- (NSString*)labelFilterColon {
	return [[self labelFilter] colonize] ;
}

- (NSString*)labelWriteToDesktop {
	return [NSString localizeFormat:
			@"writeToX",
			[NSString localize:@"desktop"]] ;
}

- (NSString*)labelAdditions {
	return [NSString localize:@"changeNounAdds"] ;
}

- (NSString*)labelDeletions {
	return [NSString localize:@"changeNounDeletes"] ;
}

- (NSString*)labelUpdates {
	return [NSString localize:@"changeNounUpdates"] ;
}

- (NSString*)labelMoves {
	return [NSString localize:@"changeNounMoves"] ;
}

- (NSString*)labelSlides {
	return [NSString localize:@"changeNounSlides"] ;
}

- (NSString*)labelAddSymbol {
	return [SSYModelChangeTypes symbolForAction:SSYModelChangeActionInsert] ;
}

- (NSString*)labelMergeSymbol {
	return [SSYModelChangeTypes symbolForAction:SSYModelChangeActionMerge] ;
}

- (NSString*)label3UpdateSymbols {
	return [NSString stringWithFormat:
            @"%@, %@, %@",
            [SSYModelChangeTypes symbolForAction:SSYModelChangeActionModify],
            [SSYModelChangeTypes symbolForAction:SSYModelChangeActionSlosh],
            [SSYModelChangeTypes symbolForAction:SSYModelChangeActionMosh]
            ];
}

- (NSString*)labelMoveSymbol {
	return [SSYModelChangeTypes symbolForAction:SSYModelChangeActionMove] ;
}

- (NSString*)labelSlideSymbol {
	return [SSYModelChangeTypes symbolForAction:SSYModelChangeActionSlide] ;
}

- (NSString*)labelDeleteSymbol {
	return [SSYModelChangeTypes symbolForAction:SSYModelChangeActionRemove] ;
}

- (NSString*)labelStopAllSyncingNow {
    return NSLocalizedString(@"Stop all syncing now", nil);
}

- (NSString*)toolTipAdd {
    return NSLocalizedString(
                             @"new items inserted",
                             nil);
}

- (NSString*)toolTip3Updates {
    return NSLocalizedString(
                             @"items with some attribute(s) modified…\n"
                             @"Δ = but item was not moved\n"
                             @"✛ = also, item was moved within its folder\n"
                             @"✣ = also, item was moved to different folder",
                             nil);
}

- (NSString*)toolTipMove {
    return NSLocalizedString(
                             @"items moved to a different folder",
                             nil);
}

- (NSString*)toolTipSlide {
    return NSLocalizedString(
                             @"items moved within original folder",
                             nil);
}

- (NSString*)toolTipDeletion {
    return NSLocalizedString(
                             @"items deleted",
                             nil);
}

- (NSString*)labelConsolidateFolders {
	return [NSString localizeFormat:
			@"consolidateX",
			[[NSString localize:@"folders"] capitalizedString]] ;
}

- (NSString*)labelDeleteFolders {
	return [NSString localizeFormat:
			@"delete%0",
			[NSString localize:@"folders"]] ;
}

- (NSString*)labelMergeFolders {
	return [NSString localizeFormat:
			@"mergeX",
			[NSString localize:@"folders"]] ;
}

- (NSString*)labelInstall {
	return [NSString localize:@"install"] ;
}

- (NSString*)labelUninstall {
	return [NSString localize:@"installUn"] ;
}

- (NSString*)labelResetAndStartOver {
	return @"Reset and Start Over" ;
}

- (NSString*)labelUrl {
	// "URL" is same in all languages
	return @"URL" ;
}

- (NSString*)labelRating {
	return [NSString localize:@"ratingStars"] ;
}

- (NSString*)labelForSortBy:(BkmxSortBy)sortBy {
	NSString* answer ;
	
	switch (sortBy) {
		case BkmxSortByName:
			answer = [self labelName] ;
			break;
		case BkmxSortByRating:
			answer = [self labelRating] ;
			break ;
		case BkmxSortByUrl:
			answer = [self labelUrl] ;
			break;
		case BkmxSortByDomainHostPath:
			answer = [self labelDomainHostPath] ;
			break;
		case BkmxSortByShortcut:
			answer = [self labelShortcut] ;
			break;
		case BkmxSortByAddDate:
			answer = [self labelAddDate] ;
			break;
		case BkmxSortByLastModified:
			answer = [self labelLastModifiedDate] ;
			break;
		case BkmxSortByLastVisited:
			answer = [self labelLastVisitedDate] ;
			break;
		case BkmxSortByVerifyStatusCode:
			answer = [self labelStatusCode] ;
			break;
		case BkmxSortByVisitCount:
			answer = [self labelVisitCount] ;
			break;
		default:
			answer = [NSString stringWithFormat:@"Internal Error 528-2918 %ld",
			(long)sortBy] ;
	}
	
	return answer ;
}



- (NSString*)labelTest {
	return [NSString localize:@"test"] ;
}

- (NSString*)labelManageBrowserExtensions {
	return [NSString localizeFormat:
			@"manageX",
			[NSString localize:@"browserExtensions"]] ;
}

- (NSString*)toolTipLimitForOperation:(NSString*)operation {
	return [NSString stringWithFormat:
			@"%@\n\n%@",
			[NSString localizeFormat:
			 @"limitOp1X2",
			 [NSString stringWithFormat:
			  @"%@+%@+%@",
			  [self labelAdditions],
			  [self labelUpdates],
			  [self labelDeletions]],
			 operation],
			[NSString localize:@"limitOp2"]] ;
}

- (NSString*)toolTipImportLimit {
	return [self toolTipLimitForOperation:[self labelImport]] ;
}

- (NSString*)toolTipExportLimit {
	return [self toolTipLimitForOperation:[self labelExport]] ;
}

- (NSString*)toolTipIxportLimit {
	return [self toolTipLimitForOperation:[self labelImportOrExport]] ;
}

- (NSString*)labelItems {
	return [NSString localize:@"items"] ;
}

- (NSString*)labelMergeBias {
	return [NSString stringWithFormat:
			@"%@ : %@",
			[self labelMergeBy],
			[self labelItems]] ;
}

- (NSString*)labelMergeUrl {
	return [NSString stringWithFormat:
			@"%@ : %@",
			[self labelMerging],
			[self labelUrl]] ;
}

- (NSString*)labelWhenAddNewFromBrowser {
	return [NSString localizeFormat:
			@"bookmarkNewLandingWhenX2",
			[[self labelLeaf] lowercaseString],
			@"another application"] ;
}

- (NSString*)labelNewBookmarkLanding {
	return [NSString localize:@"bookmarkNewLanding"] ;
}

- (NSString*)labelNewBookmarkLandingShort {
	return [NSString localize:@"bookmarkNewLandingShort"] ;
}

- (NSString*)labelAddQuickly {
	return [NSString localize:@"addQuickly"] ;	
}

- (NSString*)labelAddAndInspect {
	return [NSString localize:@"inspectAfterAdd"] ;	
}

- (NSString*)toolTipAddInspect {
	return [NSString localizeFormat:
			@"inspectAddBookmarkX4",
			[self labelAddQuickly],
			[NSString localize:@"000_Safari_bookmark"],
			[self labelAddAndInspect],
			[self labelInspector]] ;
}

- (NSString*)toolTipAnywhereMenu {
	return [NSString localizeFormat:
			@"menuAnywhereTipX",
			[self appNameLocalized]] ;
}

- (NSString*)toolTipQuikMark {
	return [NSString stringWithFormat:
			@"%@\n\n%@",
			[NSString localizeFormat:
			 @"bookmarkQuikX2",
			 [self labelNewBookmarkLanding],
			 [[NSDocumentController sharedDocumentController] defaultDocumentDisplayName]],
			[self toolTipAddInspect]] ;
}

- (NSString*)toolTipShowExportTo {
    return [NSString localize:@"imex_exExclude"] ;
}


- (NSString*)toolTipNewBookmarkLanding {
	return [NSString localize:@"bookmarkNewLandingToolTip"] ;
}

- (NSString*)labelIfOptKeyUp {
	return [NSString localize:@"keyIfOptUp"] ;
}

- (NSString*)labelIfOptKeyDown {
	return [NSString localize:@"keyIfOptDown"] ;
}

- (NSString*)toolTipAddNewShowInspector {
	return [NSString localize:@"inspectorShowTip"] ;
}

- (NSString*)stringCancelledOperation {
	return [NSString localize:@"cancelledOperation"] ;
}

- (NSString*)stringConflictWithAppName:(NSString*)appName {
	return [NSString localizeFormat:@"conflictBetween2Things",
			appName,
			[self appNameLocalized]] ;
}

- (NSString*)syncRequirementFormat {
    if ([[BkmxBasis sharedBasis] isShoeboxApp]) {
        return @"you quit %@";

    } else {
        return @"you close this document and/or quit %@";
    }
}

- (NSString*)tooltipSyncStatusOff {
    return [NSString stringWithFormat:
            @"Syncing with %@ is configured but paused.",
            [[BkmxBasis sharedBasis] labelClients]];
}

- (NSString*)tooltipSyncStatusOn {
    return [NSString stringWithFormat:
            @"Syncing is ready.  After %@, %@ will be watched, and future changes synced.",
            [NSString stringWithFormat:[self syncRequirementFormat], [self appNameLocalized]],
            [[BkmxBasis sharedBasis] labelClients]];
}

- (NSString*)tooltipSyncStatusDis {
    return [NSString stringWithFormat:
            @"Syncing between the Content of this document and %@ is currently not configured.",
             [[BkmxBasis sharedBasis] labelClients]];
}

- (NSDictionary*)bindingOptionsForTags {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			[[BkmxBasis sharedBasis] labelMultipleValues], NSMultipleValuesPlaceholderBindingOption,
			[NSString localizeFormat:@"no%0", [NSString localize:@"selection"]], NSNoSelectionPlaceholderBindingOption,
			[NSString localize:@"applicableNot"], NSNotApplicablePlaceholderBindingOption,
			[NSString localizeFormat:@"no%0", [NSString localize:@"070_tags_Firefox"]], NSNullPlaceholderBindingOption,
			nil] ;
}

- (void)setPlaceholdersForTagsInTokenField:(RPTokenControl*)tokenField {
	NSDictionary* bindingOptions = [self bindingOptionsForTags] ;
	[tokenField setNoTokensPlaceholder:[bindingOptions objectForKey:NSNullPlaceholderBindingOption]] ;
	[tokenField setMultipleValuesPlaceholder:[bindingOptions objectForKey:NSMultipleValuesPlaceholderBindingOption]] ;
	[tokenField setNotApplicablePlaceholder:[bindingOptions objectForKey:NSNotApplicablePlaceholderBindingOption]] ;
	[tokenField setNoSelectionPlaceholder:[bindingOptions objectForKey:NSNoSelectionPlaceholderBindingOption]] ;
}

- (NSString*)toolTipClickHelp {
    return NSLocalizedString(@"This is complicated.  Click the round \"?\" help button for an explanation.", nil);
}



@end
