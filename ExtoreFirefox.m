#import "Bkmxwork/Bkmxwork-Swift.h"
#import "ExtoreFirefox.h"
#import "NSError+SuggestMountVolume.h"
#import "NSError+DecodeCodes.h"
#import "SSYFirefoxProfiler.h"
#import "NSError+MyDomain.h"
#import "NSError+SSYInfo.h"
#import "NSString+BkmxURLHelp.h"
#import "SSYSqliter.h"
#import "Stark.h"
#import "Starker.h"
#import "NSDictionary+ToStark.h"
#import "Client.h"
#import "ClientChoice.h"
#import "NSError+InfoAccess.h"
#import "NSString+LocalizeSSY.h"
#import "NSString+Base64.h"
#import "NSData+FileAlias.h"
#import "NSString+SSYExtraUtils.h"
#import "NSString+MorePaths.h"
#import "SSYProgressView.h"
#import "NSArray+SafeGetters.h"
#import "BkmxBasis+Strings.h"
#import "OperationExport.h"
#import "NSObject+MoreDescriptions.h"
#import "Exporter.h"
#import "Importer.h"
#import "SSYOtherApper.h"
#import "SSYTreeTransformer.h"
#import "SSYThreadPauser.h"
#import "NSDate+LongLong1970.h"
#import "SSYUuid.h"
#import "NSFileManager+SomeMore.h"
#import "ConstsFromJavaScript.h"
#import "SSYShellTasker.h"
#import "NSObject+DoNil.h"
#import "NSString+VarArgs.h"
#import "SSYSystemDescriber.h"
#import "SSYMH.AppAnchors.h"
#import "BkmxDoc.h"
#import "NSFileManager+TempFile.h"
#import "SSYSheetEnder.h"
#import "NSString+SSYCaseness.h"
#import "NSBundle+MainApp.h"
#import "SSYXMLPeeker.h"
#import "NSRunningApplication+SSYHideReliably.h"
#import "NSBundle+SSYMotherApp.h"
#import "FirefoxPrefsParser.h"
#import "Chromessengerer.h"
#import "SSYMOCManager.h"
#import "ExtensionsWinCon.h"
#import "NSArray+Stringing.h"
#import "NSUserDefaults+MainApp.h"
#import "NSString+URIQuery.h"
#import "BkmxAppDel.h"

#define SSYAddMethodNameInError(error__) if (error__){error__=[error__ errorByAddingUserInfoObject:[NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding] forKey:SSYMethodNameErrorKey];}

// Columns used in more than one moz table
NSString* const kMozCommonKeyID = @"id" ;
NSString* const kMozCommonKeyAddDate = @"dateAdded" ;
NSString* const kMozCommonKeyLastModifiedDate = @"lastModified" ;

// Columns in table moz_bookmarks
NSString* const kMozBookmarksKeyType = @"type" ;
NSString* const kMozBookmarksKeyPlaceID = @"fk" ;
NSString* const kMozBookmarksKeyParent = @"parent" ;
NSString* const kMozBookmarksKeyPosition = @"position" ;
NSString* const kMozBookmarksKeyName = @"title" ;
NSString* const kMozBookmarksKeyFolderType = @"folder_type" ;
NSString* const kMozBookmarksKeyGuid = @"guid" ;
NSString* const kMozBookmarksKeySyncStatus = @"syncStatus";
NSString* const kMozBookmarksKeySyncChangeCounter = @"syncChangeCounter";

/* The last two are declared thus in the Firefox 54 schema:
 syncStatus INTEGER NOT NULL DEFAULT 0
 syncChangeCounter INTEGER NOT NULL DEFAULT 1

 syncStatus seems to be:

 0 = not synced
 1 = does not need to be synced.  Most of the glue items are here.  However,
 .     some of them (Bookmarks Menu, Bookmarks toolbar, Other Bookmarks,
 .     mobile) are 1 only if syncing is off but become 2 if syncing is on.
 2 = synced

 So I think a good strategy is to insert new items with no syncStatus, so
 they will get the default value of 0, which means they are not synced, which
 means that Firefox Sync will sync them and change their syncStatus later.

 The syncChangeCounter seems to increment whenever a change is made to an
 item's properties.  For folders, this includes addition or deletion of
 children.  If you change a item's name/title 3 times (commit editing 3
 times), the syncChangeCounter will get +3.  This happens even when Firefox
 Sync is off for the profile.

 The syncChangeCounter seems to clear to 0 only after changes are pushed to the
 cloud.

 Thus, the glue items which are fixed to syncStatus = 1 never get their changes
 cleared to 0.
 */

// Columns in table moz_places
NSString* const kMozPlacesKeyURL = @"url" ;
NSString* const kMozPlacesKeyName = @"title" ; // Use title in moz_bookmarks instead of this
NSString* const kMozPlacesKeyRevHost = @"rev_host" ;
NSString* const kMozPlacesKeyVisitCount = @"visit_count" ;
NSString* const kMozPlacesKeyHidden = @"hidden" ;
NSString* const kMozPlacesKeyTyped = @"typed" ;
NSString* const kMozPlacesKeyFaviconID = @"favicon_id" ;
NSString* const kMozPlacesKeyGuid = @"guid" ;

// Columns in table moz_anno_attributes
NSString* const kMozAnnoAttributesKeyName = @"name" ;

// Columns in table moz_items_annos
NSString* const kMozItemsAnnosKeyBookmarkID = @"item_id" ;
NSString* const kMozItemsAnnosKeyAttributeID = @"anno_attribute_id" ;
NSString* const kMozItemsAnnosKeyContent = @"content" ;
NSString* const kMozItemsAnnosKeyFlags = @"flags" ;
NSString* const kMozItemsAnnosKeyExpiration = @"expiration" ;
NSString* const kMozItemsAnnosKeyType = @"type" ;

// Constant data values used in moz tables
const NSInteger kMozBookmarksTypeBookmark = 1 ;
NSInteger const kMozBookmarksTypeFolder = 2 ;
NSInteger const kMozBookmarksTypeSeparator = 3 ;
NSString* const kMozAnnoAttributeNameBookmarkDescription = @"bookmarkProperties/description" ;
NSString* const kMozAnnoAttributeNamePlacesOrganizerQuery = @"PlacesOrganizer/OrganizerQuery" ;
NSString* const kMozAnnoAttributeNameReadOnly = @"placesInternal/READ_ONLY" ;
NSString* const kMozAnnoAttributeNameAllPlaces = @"PlacesOrganizer/OrganizerFolder" ;
NSString* const kMozAnnoAttributeNameLivemarkURI = @"livemark/feedURI" ;

// Hartainers in WebExtension
NSString* const kMozBarGuid     = @"toolbar_____";
NSString* const kMozMenuGuid    = @"menu________";
NSString* const kMozUnfiledGuid = @"unfiled_____";
NSString* const kMozMobileGuid  = @"mobile______";

// My way of dividing Starks from Tags in the all-mixed-up moz_bookmarks table.
enum MozItemType {
	kMozItemTypeNone,
	kMozItemTypeMotherOfAllItems,
	kMozItemTypeRootTags,
	kMozItemTypeStark,  // includes bar, menu, unsorted
	kMozItemTypeTag,
	kMozItemTypeAllPlaces,
	kMozItemTypeHistoryOrStrawRootTags,
	kMozItemTypeAllBookmarks,
	kMozItemTypeStrawMan
} ;

NSString* const constExtension1Name = @"BookMacsterSync" ;
NSString* const constExtension2Name = @"BookMacsterButton" ;
NSString* const constExtensionFilenameExtension = @"xpi" ;

// Keys we use in the 'families' dictionary
NSString* const kChildren = @"children" ;
NSString* const kStark = @"Stark" ;
NSString* const kPosition = @"Posn" ;


@interface NSDictionary (MozNulls)

- (id)mozObjectForKey:(id)key ;

@end

@implementation NSDictionary (MozNulls)

- (id)mozObjectForKey:(id)key {
	id object = [self objectForKey:key] ;
	if ([object isKindOfClass:[NSNull class]]) {
		object = nil ;
	}
	
	return object ;
}

@end


@interface ExtoreFirefox ()

@property (nonatomic, retain) NSNumber* rootTagsMozBookmarksIndex ;
@property (nonatomic, retain) NSDictionary* parentsCached ;

@end

static const ExtoreConstants extoreConstants = {
	/* canEditAddDate */                  NO, // See Note 190352
	/* canEditComments */                 BkmxCanEditInStyle1Only,
	/* canEditFavicon */                  YES,  // but I don't read it at this time
	/* canEditFaviconUrl */               NO,
	/* canEditIsAutoTab */                NO,
	/* canEditIsExpanded */               NO,
	/* canEditIsShared */                 NO,
	/* canEditLastChengDate */            NO,
	/* canEditLastModifiedDate */         NO, // See Note 190351
	/* canEditLastVisitedDate */          NO,
	/* canEditName */                     YES,
	/* canEditRating */                   NO,
	/* canEditRssArticles */              YES,
    /* canEditSeparators */               BkmxCanEditInStyleEither,
	/* canEditShortcut */                 BkmxCanEditInStyleNeither,
	/* canEditTags */                     BkmxCanEditInStyle1Only,
	/* canEditUrl */			          YES,
	/* canEditVisitCount */               NO,  // Changed in BookMacster 1.15.1
	/* canCreateNewDocuments */           YES,
	/* ownerAppDisplayName */             @"Firefox",
	/* webHostName */                     nil,
	/* authorizationMethod */             BkmxAuthorizationMethodNone,
	/* accountNameHint */                 nil,
	/* oAuthConsumerKey */                nil,
	/* oAuthConsumerSecret */             nil,
	/* oAuthRequestTokenUrl */            nil,
	/* oAuthRequestAccessUrl */           nil,
	/* oAuthRealm */                      nil,
	/* appSupportRelativePath */          @"Firefox",
	/* defaultFilename */                 @"places.sqlite",
	/* defaultProfileName */              @"default",
	/* iconResourceFilename */            nil,
	/* iconInternetURL */                 nil,
	/* fileType */                        @"sqlite",
	/* ownerAppObservability */           0, // Do not use!! Use class method instead
    /* The above has *both* because of Separators, Tags, and Live Bookmarks
     only observeable on quit. */
    /* canPublicize */                    NO,
	/* silentlyRemovesDuplicates */       NO,
	/* normalizesURLs */                  NO,
	/* catchesChangesDuringSave */        NO,
	/* telltaleString */                  nil,
	/* hasBar */                          YES,
	/* hasMenu */                         YES,
	/* hasUnfiled */                      YES,
	/* hasOhared */                       NO,
	/* tagDelimiter */                    @",",
	/* dateRef1970Not2001 */              YES,
	/* hasOrder */                        YES,
	/* hasFolders */                      YES,
	/* ownerAppIsLocalApp */              YES,
	/* defaultSpecialOptions */           0x0000000000000000LL,
	/* extensionInstallDirectory */       @"extensions",
	/* minBrowserVersionMajor */          3,
	/* minBrowserVersionMinor */          6,
	/* minBrowserVersionBugFix */         0,
	/* minSystemVersionForBrowsMajor */   0,
	/* minSystemVersionForBrowMinor */    0,
	/* minSystemVersionForBrowBugFix */   0
} ;


@implementation ExtoreFirefox

/* 
 This implementation is the same in all subclasses, but we define it
 in each subclass in order to pick up the static const extoreConstants
 struct which is different in each Extore subclass' implementation file.
 */
+ (const ExtoreConstants *)constants_p {
	return &extoreConstants ;
}

/*
 Channel     Version    .app Package Name        Bundle Identifier
 Aurora (*)  35.0       Aurora                   org.mozilla.firefoxdeveloperedition
 Developer   35.0       FirefoxDeveloperEdition  org.mozilla.firefoxdeveloperedition
 Beta        34.0       Firefox                  org.mozilla.firefox
 Production  33.0       Firefox                  org.mozilla.firefox
 
 (*) apparently deprecated in favor of Developer Edition
 
 All versions now contain two executables in Contents/MacOS: the newer, I think,
 'firefox', which seems to run in all versions, and the older 'firefox-bin',
 which seems to be no longer used.
 */

+ (NSArray*)browserBundleIdentifiers {
    return [NSArray arrayWithObjects:
            @"org.mozilla.firefox",
            @"org.mozilla.firefoxdeveloperedition",
            @"org.mozilla.nightly",
            nil] ;
}

+ (NSString*)labelBar {
    return [NSString localize:@"050_FF3_Bar"] ;
}

+ (NSString*)labelUnfiled {
    return [NSString localize:@"050_FF3_Unfiled"] ;
}

+ (NSString*)labelOhared {
    return constDisplayNameNotUsed ;
}

+ (BOOL)canDetectOurChanges {
	return YES ;
}

+ (BOOL)hasProprietarySyncThatNeedsOwnerAppRunning {
    return YES ;
}

+ (BkmxIxportTolerance)toleranceForIxportStyle:(NSInteger)ixportStyle {
	BkmxIxportTolerance tolerance = BkmxIxportToleranceAllowsNone ;
	// See Note 51398 below.
	if (ixportStyle == 1) {
		tolerance = BkmxIxportToleranceAllowsNone ;
	}
	else if (ixportStyle == 2) {
		tolerance = BkmxIxportToleranceAllowsReading + BkmxIxportToleranceAllowsWriting ;
	}
	
	return tolerance ;
}

/* Note 51398
 
 On 2008 Feb 01, I found that the Minefield "trunk" "nightly build" of Firefox 3.0b3 locked
 the whole database whenever it is running, all sqlite3 queries return error_ 5, SQLITE_BUSY.
 
 On 2010 Apr 07, I concluded that this is still true for Firefox 3.6.
 
 On 2010 Apr 07, I concluded, after about 20 minutes of testing,  that Firefox 4.0 would generally
 allow the database to be read *and written* while Firefox was running, even while
 the Show All Bookmarks (Library) was showing.  Changes from the command line would persist, and
 Firefox never crashed nor corrupted the places.sqlite database.  The only bad thing that happened
 was this:  Once, I had a bookmark named "Calmar2", which was, I believe, selected in the
 Show All Bookmarks (Library) in Firefox.  In command-line sqlite 3.7.5, I executed this query:
 *  update moz_bookmarks set title = "Calmar3" where title = "Calmar2" ;
 The result was that the title of this item was set to "Calmar23".  Eeek!  But everything kept
 working and this change persisted.
 
 But I'm not going to play this game just yet, especially after I just spent 4 months working
 on the damned Firefox Extension.
 
 On 2011 Dec 07, BookMacster 1.9.3, I decided to flip the switch, for imports.  The reason is
 Firefox performance.  Here's the story…
 
 After changing a bookmark in Firefox, when the default BookMacster syncer triggers, if the
 import style is 1, BookMacster asks its Firefox extension for all of its bookmarks, and this
 causes Firefox' user interface in Firefox to become unresponsive and beachball until the
 this is done, which you can see roughly by watching the status bar in BookMacster for the
 "Reading Firefox" phase.  With 1000-2000 bookmarks, it's only for a couple seconds, and since
 BookMacster throttles this to occur at most once every 5 minutes, it is not annoying.
 However, with 3000 or 4000 bookmarks, for some reason Firefox much longer than twice as long,
 more like tens of seconds.
 
 Specifically, with 5028 bookmarks and 289 folders on my 2009 Mac Mini, it takes 25 seconds.
 
 However, I'm not doing it on export, because I've seen other weird things similar to the
 "Calmar23" noted above, if you have Firefox "Show All Bookmarks" "Library" open.  This window
 does not update immediately when BookMacster does a style 1 export.  For example, in this
 window you can still edit the properties of a bookmark which has just been deleted by
 BookMacster in a style 1 export.  But if you re-select it, the selection will simply fail
 and the properties of the previously-selected bookmark will show.  However, when you close
 and re-open the window, the deleted bookmark is gone, as expected.
 
 Hence the use of read style = 1, write style = 2 for BookMacster 1.9.3.
 
 On 2017 Mar 30, I'm now dealing with the fact that, with the new W3CBE extension,
 at least for now, Style 2 does not support separators, comments, or
 tags.  So the hashes are going to be different for styles 1 and 2.  Because I
 read and compute and compare the hash before writing, this means that I can no
 longer have different styles for read and write (I think).  So from now on
 there is no more "read/write styles".  There is only one style, one number,
 1 or 2.
 */

+ (PathRelativeTo)fileParentPathRelativeTo {
	return PathRelativeToProfile ;
}

+ (NSString*)fileParentRelativePath {
	return @"" ; // empty because places.sqlite is inside the profile folder
}

@synthesize rootTagsMozBookmarksIndex = m_rootTagsMozBookmarksIndex ;
@synthesize parentsCached = m_parentsCached ;

- (NSString*)emptyExtoreResourceFilenameAfterUnzipping {
    return @"places.sqlite" ;
}

+ (BOOL)syncExtensionAvailable {
	return YES ;
}

+ (BkmxGrabPageIdiom)peekPageIdiom {
	return BkmxGrabPageIdiomSSYInterappServer ;
}

+ (OwnerAppObservability)ownerAppObservability {
    if ([[NSUserDefaults standardUserDefaults] syncAndGetMainAppBoolForKey:constKeySyncFirefoxOnQuit]) {
        return OwnerAppObservabilitySpecialFile;
    } else {
        return OwnerAppObservabilitySpecialFile;
    }
}

+ (BOOL)addonSupportsPurpose:(NSInteger)purpose {
	BOOL answer = ([[BkmxBasis sharedBasis] iAm] != BkmxWhich1AppSmarky) ;
    return answer ;
}

+ (NSURL*)sourceUrlForExtensionIndex:(NSInteger)extensionIndex {
	NSURL* url ;
    switch (extensionIndex) {
        case 1:
            url = [[NSBundle mainAppBundle] URLForResource:constExtension1Name
                                             withExtension:constExtensionFilenameExtension] ;
            break ;
        case 2:
            url = [[NSBundle mainAppBundle] URLForResource:constExtension2Name
                                             withExtension:constExtensionFilenameExtension] ;
            break ;
        default:
            url = nil ;
    }
    
	return url ;
}

+ (NSString*)browserExtensionPortNameForProfileName:(NSString*)profileName {
    return [NSString stringWithFormat:
            @"%@.%@.%@",
            [[NSBundle mainAppBundle] motherAppBundleIdentifier],
            NSStringFromClass([self class]),
            profileName] ;
}

+ (NSArray*)profilePseudonyms:(NSString*)homePath {
    return [[SSYFirefoxProfiler profilePseudonymsForHomePath:homePath] valueForKey:@"lastPathComponent"] ;
}

+ (NSArray*)profileNames {
    return [SSYFirefoxProfiler profileNames] ;
}

+ (NSString*)displayedSuffixForProfileName:(NSString*)profileName
                                  homePath:(NSString*)homePath {
    return [SSYFirefoxProfiler displayedSuffixForProfileName:profileName
                                                    homePath:homePath] ;
}

+ (NSString*)pathForProfileName:(NSString*)profileName
                       homePath:(NSString*)homePath
                        error_p:(NSError**)error_p {
    return [SSYFirefoxProfiler pathForProfileName:profileName
                                         homePath:homePath
                                          error_p:error_p] ;
}

+ (BOOL)supportsMultipleProfiles {
    return YES;
}


- (NSString*)browserExtensionPortName {
    NSString* answer = [NSString stringWithFormat:
                        @"%@.%@.%@",
                        [[NSBundle mainAppBundle] motherAppBundleIdentifier],
                        NSStringFromClass([self class]),
                        self.clientoid.profileName] ;
    return answer ;
}

- (BOOL)syncExtensionAvailable {
    NSString* path = [[[self class] sourceUrlForExtensionIndex:1] path] ;
	BOOL isResourceAvailable = (path != nil) ;
	BOOL answer = isResourceAvailable ? [[self class] syncExtensionAvailable] : NO ;
	
	return answer ;
}

+ (NSData*)ownerExtensionsJsonForProfilePath:(NSString*)profilePath
                                     error_p:(NSError**)error_p {
    NSError* error = nil ;
    NSData* data = nil ;

    NSString* extensionsJsonPath = [profilePath stringByAppendingPathComponent:@"extensions.json"] ;

    if (!extensionsJsonPath) {
        error = [NSError errorWithDomain:[NSError myDomain]
                                    code:847291
                                userInfo:@{
                                           NSLocalizedDescriptionKey: @"Could not open extensions.json for Firefox profile"
                                           }] ;
    }
    else {
        data = [NSData dataWithContentsOfFile:extensionsJsonPath] ;
    }

    if (error && error_p) {
        *error_p = error ;
    }

    return data ;
}

+ (NSString*)ownerJSPrefsForProfilePath:(NSString*)profilePath
                                error_p:(NSError**)error_p {
    NSError* error = nil ;
    NSString* prefsString = nil ;

    NSString* prefsPath = [profilePath stringByAppendingPathComponent:@"prefs.js"] ;

    if (!prefsPath) {
        error = [NSError errorWithDomain:[NSError myDomain]
                                    code:922840
                                userInfo:@{
                                           NSLocalizedDescriptionKey: @"Could not open prefs for Firefox profile"
                                           }] ;
    }
    else {
        prefsString = [NSString stringWithContentsOfFile:prefsPath
                                                encoding:NSASCIIStringEncoding
                                                   error:&error] ;
    }

    if (error && error_p) {
        *error_p = error ;
    }

    return prefsString ;
}

- (NSString*)ownerJSPrefsError_p:(NSError**)error_p {
    NSError* error = nil ;
    NSString* profilePath = [self profilePathError_p:&error] ;

    return [[self class] ownerJSPrefsForProfilePath:profilePath
                                            error_p:error_p] ;
}

/*
 This method gives a false positive if I install a preferences file (prefs.js)
 from a user's Trouble Zip who is using Firefox Sync, because it contains
 values for keys services.sync.bookmarks.syncID et al.  When Firefox runs
 with these values, if you look in Preferences > Sync, it indicates that
 Firefox Sync is not set up.  I don't know what's missing.  If Mozilla did
 things properly, they should put the credential in the macOS Keychain and
 that would explain why Firefox Sync is in fact inactive, but I looked in *my*
 keychain and couldn't find *my* Firefox/Sync/mozilla item in there.  Not
 surprising.  Anyhow, services.sync.bookmarks.syncID, and two siblings,
 disappear from prefs.js if I "Unlink this device" in my Firefox prefs.  So
 I think that these false positives will not occur for real users.
 */
- (BOOL)isSyncActiveError_p:(NSError**)error_p {
    NSError* error = nil ;
    NSInteger errorCode = 0 ;
    BOOL syncActive = NO ;
    
    NSString* prefsString = [self ownerJSPrefsError_p:&error] ;
    if (!prefsString) {
        errorCode = 924677 ;
        goto end ;
    }
    
    syncActive = [prefsString rangeOfString:@"\"services.sync.bookmarks.syncID\""].location != NSNotFound ;
    /* The above will give a false positive after installing another user's
     prefs.js file using, for example my ReproUserTrouble AppleScript.  This
     will not occur in practice, for real users, I hope.  Anyhow, to
     clear out the services.sync.bookmarks.syncID key (without editing
     prefs.js manually, the obvious way), the following worked:
     • Launch Firefox.
     • Sign in with an account to which I know the password (jerry@ieee.org)
     • Confirm the link sent in email.
     • Sign out.
     Possibly a quit and relaunch or two is necessary during the above.  I'm
     not sure. */
     
    /*  Also, the above condition alone is not enough because 'bookmarks' could
     be one of the 'declinedEngines'.  This happens if the 'Bookmarks' checkbox
     is off in Preferences > Syncing.  So, now we check for that.  Note that
     we changed this on 20170709, after publishing BkmkMgrs 2.4.9.  Previously,
     it looked for the absence of "bookmarks" in the list keyed
     "services.sync.declinedEngines".  However, testing on 20170709 with
     Firefox 55 shows that this is not a reliable indication.  It can be
     present when the "Bookmarks" checkbox is on, and absent when it is off.
     So, the following new code looks for "services.sync.engine.bookmarks"
     being set to false, which seems to be a more reliable indicator, maybe
     perfect.  I got tired of testing after 15 minutes! */
    if (syncActive) {
        /* The following grep pattern looks for a line like this:
             user_pref("services.sync.engine.bookmarks", false);
         allowing for variations in whitespace, and allowing the trailing
         semicolon to be absent since supposedly this is JavaScript. */
        NSString* pattern = @"user_pref\\(\\s?\"services\\.sync\\.engine\\.bookmarks\",\\s?false\\s?\\)";
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                               options:0
                                                                                 error:&error];
        NSRange wholePrefs = NSMakeRange(0, prefsString.length) ;
        NSInteger countOfMatches = [regex numberOfMatchesInString:prefsString
                                                          options:0
                                                            range:wholePrefs];
        syncActive = countOfMatches == 0;
    }
    
end:
    if ((errorCode != 0) && error_p) {
        NSString* genericErrorDescription = @"Error trying to determine whether or not Firefox Sync is active" ;
        NSDictionary* errorInfo = [NSDictionary dictionaryWithObject:genericErrorDescription
                                                              forKey:NSLocalizedDescriptionKey] ;
        error = [[NSError errorWithDomain:[NSError myDomain]
                                     code:errorCode
                                 userInfo:errorInfo] errorByAddingUnderlyingError:error] ;
        *error_p = error ;
    }
    
    return syncActive ;
}

- (NSString*)ownerAppSyncServiceDisplayName {
    return @"Firefox Sync" ;
}

- (NSTimeInterval)waitTimeForBuiltInSyncAfterLaunch {
    // Pass NULL for &error in the following since this is only to cover the
    // edge case when bookmarks need to be synced in from Firefox Sync
    // immediately after the browser is launched.  We didn't do this at all
    // until BookMacster 1.19.6, and no one complained.
    // Also, if this error is persistent it will occur elsewhere.
    NSTimeInterval waitTime = [self isSyncActiveError_p:NULL] ? 6.0 : 0.0 ;
    
    return waitTime ;
}

- (BOOL)toleratesClientTask:(BkmxClientTask)clientTask {
    BOOL answer = [super toleratesClientTask:clientTask] ;
    
#if 0
#warning Logging toleratesClientTask:: for Firefox
#define LOG_toleratesClientTask_FOR_FIREFOX 1
#endif
    
    if (answer == NO) {
        if (self.ixportStyle == 1) {
            if ([self ownerAppRunningStateError_p:NULL] == OwnerAppRunningStateRunningProfileWrongOne) {
#if LOG_toleratesClientTask_FOR_FIREFOX
                NSLog(@"EF: Changed NO -> YES cuz wrong profile, OK for style 1") ;
#endif
                answer = YES ;
            }
        }
    }

#if LOG_toleratesClientTask_FOR_FIREFOX
    NSLog(@"EF: Firefox %@: tolerates %@ task %@ using style %ld",
          [[self clientoid] profileName],
          answer ? @"YES" : @"NO",
          (((clientTask!=1)&&(clientTask!=2)&&(clientTask!=4)) ? @"ERR1" : ((clientTask==1) ? @"READ" : ((clientTask==2) ? @"WRIT" : @"INST"))),
          style
          ) ;
#endif
    
    return answer ;
}

- (NSTimeInterval)quitHoldTime {
    NSTimeInterval answer ;
    NSNumber* quitHoldTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"firefoxQuitHoldTime"] ;
    if (quitHoldTime) {
        answer = [quitHoldTime doubleValue] ;
    }
    else {
        answer = 10.0 ;
    }
    
    return answer ;
}

- (BOOL)shouldBlindSawChangeTriggerDuringExport {
	// Because of the 10-second delay in the extension before the
	// Changes/Detected/*.json file is touched, it wouldn't do any good.
	// Also, user could change bookmarks during that 10 seconds.
	return NO ;
}

/* This is to avoid hash mismatches and consequent churn, because names and
 URLs exported to Firefox as separators will come back as nil when
 later imported because Firefox does not support these atributes in
 separators.  */
- (NSSet*)unsupportedAttributesForSeparators {
    return [NSSet setWithObjects:
            constKeyName,
            constKeyUrl,
            nil];
}


+ (NSInteger)mozBookmarksTypeForSharype:(Sharype)sharype {
	NSInteger answer ;
	// Lots of parentheses needed in next statement.  To my surprise, C Precedence Rules say != precedes |.
	if ([StarkTyper canHaveChildrenSharype:sharype] || [StarkTyper canHaveRssArticlesSharype:sharype]) {
		answer = 2 ;
	}
	else if (
			 (sharype == SharypeBookmark)
			 ||
			 (sharype == SharypeRSSArticle)
			 ||
			 (sharype == SharypeSmart)
			 ) {
		answer = 1 ;
	}
	else {

		// else, must be SharypeSeparator
		answer = 3 ;
	}
	
	return answer ;
}

+ (NSArray*)mozBookmarksColumns {
	return 	[NSArray arrayWithObjects:
			 kMozCommonKeyID,
			 kMozBookmarksKeyType,
			 kMozBookmarksKeyPlaceID,
			 kMozBookmarksKeyParent,
			 kMozBookmarksKeyPosition,
			 kMozBookmarksKeyName,
			 kMozBookmarksKeyFolderType,
			 kMozCommonKeyAddDate,
			 kMozCommonKeyLastModifiedDate,
			 kMozBookmarksKeyGuid,
			 nil] ;	
}

+ (NSArray*)mozItemsAnnosColumns {
	return 	[NSArray arrayWithObjects:
			 kMozCommonKeyID,
			 kMozItemsAnnosKeyBookmarkID,
			 kMozItemsAnnosKeyAttributeID,
			 kMozItemsAnnosKeyContent,
			 kMozItemsAnnosKeyFlags,
			 kMozItemsAnnosKeyExpiration,
			 kMozItemsAnnosKeyType,
			 kMozCommonKeyAddDate,
			 kMozCommonKeyLastModifiedDate,
			 nil] ;	
}

- (BOOL)isSmartUrl:(NSString*)url {
	return [url hasPrefix:@"place:"] ;
}

- (BOOL)isExportableStark:(Stark*)stark
			   withChange:(NSDictionary*)change {
#if IS_EXPORTABLE_STARK_WILL_ALWAYS_RETURN_YES
	return YES  ;
#endif

    if ([[stark url] isSmartSearchUrl]) {
        return YES ;
    }
    
	if ([self isSmartUrl:[stark url]]) {
		return YES ;
	}
    
	if (![super isExportableStark:stark
					   withChange:change]) {
		return NO ;
	}
	
	if ([stark sharypeValue] == SharypeSmart) {
		// It is a Smart Bookmark
		if (![self isSmartUrl:[stark url]]) {
			// But it's not a Firefox Smart Bookmark
			// (Could be an iCab Smart Bookmark)
			return NO ;
		}
	}
	
	if ([stark is1PasswordBookmarklet]) {
		return NO ;
	}
	
	// Added in BookMacster version 1.3.19
	if ([[stark url] hasPrefix:@"chrome://"]) {
		// Firefox nsIIOService.newURI will fail,
		// causing error 624-3039 to be logged.
		return NO ;
	}

	return YES ;
}

- (SSYSqliter*)sqliterError_p:(NSError**)error_p {
    if (_sqliter == nil) {
		NSError* error = nil ;
		NSString* path = [self workingFilePathError_p:&error] ;
		if (path) {
			_sqliter = [[SSYSqliter alloc] initWithPath:path
												error_p:&error] ;
			
			if (_sqliter) {
				// Added in BookMacster 1.3.19, when we started using guid.
				// This is because places.sqlite will have a 'guid' column
				// in 'moz_bookmarks'if it was created or modified in
				// Firefox 4, but not if in Firefox 3.  And, now, this
				// class assumes that we can UPDATE, INSERT and SELECT
				// moz_bookmarks records with guid.  So we do this right
				// up front here, before any queries can be executed.
				BOOL didAdd ;
				
				didAdd = NO ;			
				BOOL ok = [_sqliter ensureColumn:kMozBookmarksKeyGuid
											type:@"TEXT"
										 inTable:@"moz_bookmarks"
										didAdd_p:&didAdd
										   error:&error] ;
				if (ok) {
					if (didAdd) {
						NSLog(@"Note 143-4856.  Added 'guid' column to moz_bookmarks in %@ Places database", [[self clientoid] displayName]) ;
					}
					
					/* If Firefox 4 opens a places.sqlite file which has a
                     'guid' column in moz_bookmarks but none in moz_places, it
                     renames it as places.sqlit.corrupt, ignores it, and
					 reverts to a backup.  Yikes.  So, we put it in. */
					didAdd = NO ;			
					ok = [_sqliter ensureColumn:kMozBookmarksKeyGuid
										   type:@"TEXT"
										inTable:@"moz_places"
									   didAdd_p:&didAdd
										  error:&error] ;
                    if (ok) {
						if (didAdd) {
							NSLog(@"Note 354-1507.  Added 'guid' column to moz_places in %@ Places database", [[self clientoid] displayName]) ;
						}
						
						// In looking at what Firefox 4 does to update a Firefox 3 places.sqlite file,
						// I see that it also adds a couple of unique indexes.  Firefox seems to work
						// fine without them, but it does not seem to add them later.  At least this
						// is what I conclude after playing with Firefox for a few minutes; adding
						// a bookmark and doing a couple of searches.  So, I add them in now:
						BOOL okNotABigDeal ;
						
						// 1 of 2.  moz_bookmarks_guid_uniqueindex index
						didAdd = NO ;			
						okNotABigDeal = [_sqliter ensureIndex:@"moz_bookmarks_guid_uniqueindex"
													   unique:YES
													  inTable:@"moz_bookmarks"
													   column:kMozBookmarksKeyGuid
													 didAdd_p:&didAdd
														error:&error] ;
						if (okNotABigDeal) {
							if (didAdd) {
								NSLog(@"Note 947-0574.  Added 'moz_bookmarks_guid_uniqueindex' in %@ Places database", [[self clientoid] displayName]) ;
							}
						}
						else {
							// Not a big deal.  Just log it and continue.
							NSLog(@"Warning 524-3813.  Could not create index: %@", error) ;
						}

						// 2 of 2.  moz_places_guid_uniqueindex index
						didAdd = NO ;			
						okNotABigDeal = [_sqliter ensureIndex:@"moz_places_guid_uniqueindex"
													   unique:YES
													  inTable:@"moz_places"
													   column:kMozBookmarksKeyGuid
													 didAdd_p:&didAdd
														error:&error] ;
						if (okNotABigDeal) {
							if (didAdd) {
								NSLog(@"Note 647-0135.  Added 'moz_places_guid_uniqueindex' in %@ Places database", [[self clientoid] displayName]) ;
							}
						}
						else {
							// Not a big deal.  Just log it and continue.
							NSLog(@"Warning 819-4616.  Could not create index: %@", error) ;
						}
					}
					else {
						[_sqliter release] ;
						_sqliter = nil ;
						error = [SSYMakeError(368127, @"Could not add guid to moz_places in places.sqlite") errorByAddingUnderlyingError:error] ;
					}
				}
				else {
					[_sqliter release] ;
					_sqliter = nil ;
					error = [SSYMakeError(571328, @"Could not add guid to moz_bookmarks in places.sqlite") errorByAddingUnderlyingError:error] ;
				}
			}
			else {
				error = [SSYMakeError(601582, @"Could not make database object") errorByAddingUnderlyingError:error];
			}
		}
		else {
			error = [SSYMakeError(143984, @"No path to database") errorByAddingUnderlyingError:error] ;
			error = [error maybeAddMountVolumeRecoverySuggestion] ;
		}
		
		if (error && error_p) {
            error = [error errorByAddingHelpAddress:constHelpAnchorFirefoxPrepError] ;
            error = [error errorByAppendingLocalizedRecoverySuggestion:[NSString localize:@"helpButtonClick"]] ;
            error = [error errorByAddingUserInfoObject:path
												forKey:@"Path"] ;
			// Prior to BookMacster 1.11, @"Path" was only added to error 143984.
            
			*error_p = [error errorByAddingBacktrace] ;
		}
    }
	
	return _sqliter; 
}

- (NSError*)improvedError:(NSError*)error {
	NSError* outError ;
	if ([error involvesCode:SQLITE_BUSY
					 domain:SSYSqliterErrorDomain]) {
		outError = [error errorByAddingLocalizedFailureReason:
					@"Firefox or some other app is editing Firefox bookmarks right now."] ;
		outError = [outError errorByAddingLocalizedRecoverySuggestion:
					@"Wait a few seconds and then try again."] ;
	}
	else {
		outError = error ;
	}
	
	return outError ; 
}

- (void)localizeAndSetNameKey:(NSString*)key
	   inMozBookmarksRecordID:(NSInteger)mozBookmarksID {
	NSError* error_ = nil ;
	
	SSYSqliter* sqliter = [self sqliterError_p:&error_] ;
	if (!sqliter) {
		error_ = [error_ errorByAddingUserInfoObject:[NSNumber numberWithInteger:40001]
											forKey:@"Fine Code"] ;
		goto endAfterSettingError ;
	}
	
	NSString* query = [NSString stringWithFormat:@"UPDATE moz_bookmarks SET %@=%@ WHERE %@=%ld",
					   kMozBookmarksKeyName,
					   [[NSString localize:key] stringEsquotedSQLValue],
					   kMozCommonKeyID,
					   (long)mozBookmarksID] ;
	[sqliter runQuery:query
					   error:&error_] ;

	if (error_ != nil) {
		goto endAfterSettingError ;
	}
	
endAfterSettingError:
	if (error_ != nil) {
		[self setError:error_] ;
	}
}

- (void)localizeHartainers {
	// Since I created placesFF0.sqlite in English, the following is actually
	// unnecessary when running in English.  But I do it for testing.
	[self localizeAndSetNameKey:@"050_FF3_Menu" inMozBookmarksRecordID:2] ; // See note **
	[self localizeAndSetNameKey:@"050_FF3_Bar" inMozBookmarksRecordID:3] ; // See note **
	[self localizeAndSetNameKey:@"050_FF3_Tags" inMozBookmarksRecordID:4] ;
	[self localizeAndSetNameKey:@"050_FF3_Unfiled" inMozBookmarksRecordID:5] ; // See note **
	[self localizeAndSetNameKey:@"050_FF3_History" inMozBookmarksRecordID:17] ;
    [self localizeAndSetNameKey:@"050_FF3_Downloads" inMozBookmarksRecordID:18] ;
	[self localizeAndSetNameKey:@"050_FF3_Tags" inMozBookmarksRecordID:19] ;
	[self localizeAndSetNameKey:@"050_FF3_AllBookmarks" inMozBookmarksRecordID:20] ;
	
	// ** These are also set in the BkmxDoc when it is created.  However, during put,
	// we only update items that are !hartainer.  We could omit setting them here
	// and set them there, but I've got several months of testing behind doing not touching
	// them in the normal case (not creating a new document).  Therefore, to reduce the
	// risk of screwing something up I leave that !hartainer qualification during
	// -put and instead set these here also.
	// A further note: Since BookMacster 1.5.7 implemented -[Stark name] to give
	// names for hartainers, these are not seen in BookMacster but they might still
	// be seen in Firefox Manage Bookmarks (Library).
	
	// In Firefox 3 Release Candidate 1, the although the stupid "Add bookmarks here..."
	// comment is still in the places.sqlite file, it is never displayed in the "Show
	// All Bookmarks" library.  If it comes back, I could remove it from placesFF0.sqlite.
	// The strategy is to eliminate instead of localize it because to avoid work, and 
	// anyone using this advanced feature must know what the Bookmarks Toolbar is.
}

- (void)deleteLegacyBackups {
    NSFileManager* fm = [NSFileManager defaultManager] ;
	NSString* dirPath ;
	
	// Remove the old backups which were from BookMacster version 1.3.20 (?) and earlier
	dirPath = [[[NSString applicationSupportPathForHomePath:nil] stringByAppendingPathComponent:[[BkmxBasis sharedBasis] appNameLocalized]] stringByAppendingPathComponent:@"Firefox 3 Backups"] ;
	// Error in here is normal since this file will only be deleted once, and
	// after that there will be an error due to file not found.
	[fm removeItemAtPath:dirPath
				   error:NULL] ;
	
	// Remove the old backups which were from BookMacster version 1.3.20 (?) through 1.6.7
	// Get path to backup directory
	dirPath = [[[NSString applicationSupportPathForHomePath:nil] stringByAppendingPathComponent:[[BkmxBasis sharedBasis] appNameLocalized]] stringByAppendingPathComponent:@"Firefox Backups"] ;
	// Error in here is normal since this file will only be deleted once, and
	// after that there will be an error due to file not found.
	[fm removeItemAtPath:dirPath
				   error:NULL] ;
}

- (void)getFreshExid_p:(NSString**)exid_p
            higherThan:(NSInteger)higherThan
              forStark:(Stark*)stark
               tryHard:(BOOL)tryHard {
	/* Firefox uses a 12-character guid, from the base64url character set
     defined in RFC4648.
     *  https://tools.ietf.org/html/rfc4648#section-5
     *  https://bugzilla.mozilla.org/show_bug.cgi?id=607115  (Comment 2010-11-22 11:19:21 PST) */
    *exid_p = [[SSYUuid compactUuid] substringToIndex:12] ;
}

- (BOOL)migratedGuid_p:(NSString**)guid_p
				fromId:(NSString*)exid
			   error_p:(NSError**)error_p {
	*guid_p = nil ;
    BOOL ok = YES ;
    NSError* error = nil ;
	if (!exid) {
		error = SSYMakeError(648250, @"Nil exid") ;
		error = [error errorByAddingBacktrace] ;
        ok = NO ;
		goto end ;
	}
	
	SSYSqliter* sqliter = [self sqliterError_p:error_p] ;
	if (!sqliter) {
		error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:40002]
                                            forKey:@"Fine Code"] ;
		ok = NO ;
        goto end ;
	}

	NSString* query = [NSString stringWithFormat:@"SELECT %@ FROM moz_bookmarks WHERE %@=%@",
					   kMozBookmarksKeyGuid,
					   kMozCommonKeyID,
					   [exid stringEsquotedSQLValue]] ;
	*guid_p = [sqliter firstRowFromQuery:query
								   error:&error] ;
	if (error) {
		error = [SSYMakeError(684085, @"Failed query for guid") errorByAddingUnderlyingError:*error_p] ;
		error = [error errorByAddingUserInfoObject:exid
                                            forKey:@"Exid"] ;
        ok = NO ;
        goto end ;
	}

	// The guid column has been available in Firefox' database since
	// Firefox 3.0, and it may have been used by Xmarks.  However,
	// only Firefox 4.x fills in a guid when creating a bookmark.
	// If the user is still using Firefox 3.x and no other app such
	// has Xmarks has provided a guid, *guid_p will be nil or 
	// an NSNull instance at this point.  So, we make one up, and
	// write it to places.sqlite…
	if (!*guid_p || ![*guid_p isKindOfClass:[NSString class]]) {
		[self getFreshExid_p:guid_p
				  higherThan:0
					forStark:nil
					 tryHard:NO] ;

		NSDictionary* updates = [NSDictionary dictionaryWithObject:*guid_p
															   forKey:kMozBookmarksKeyGuid] ;
		NSString* query = [SSYSqliter queryUpdateTable:@"moz_bookmarks"
											   updates:updates
										   whereColumn:kMozCommonKeyID
											whereValue:exid] ;
		[sqliter runQuery:query
					error:&error] ;
		if (error) {
			error = [SSYMakeError(336850, @"Failed to set GUID") errorByAddingUnderlyingError:*error_p] ;
			error = [error errorByAddingUserInfoObject:exid
                                                    forKey:@"Exid"] ;
			error = [error errorByAddingUserInfoObject:*guid_p
                                                    forKey:@"Guid"] ;
			ok = NO ;
            goto end ;
		}
	}
	
end:
    if (error_p && error) {
        *error_p = error ;
    }
	return ok ;
}

- (id)mozAnnotationNamed:(NSString*)annotationName
		  forBookmarksID:(NSNumber*)mozBookmarksID {
	id annotation = nil ;
	NSError* error_ = nil ;
	
	SSYSqliter* sqliter = [self sqliterError_p:&error_] ;
	if (!sqliter) {
		error_ = [error_ errorByAddingUserInfoObject:[NSNumber numberWithInteger:40003]
											 forKey:@"Fine Code"] ;
		goto endAfterSettingError ;
	}

	NSString* query = [[NSString alloc] initWithFormat:@"SELECT %@ FROM moz_items_annos WHERE %@=%@ AND %@=(SELECT %@ FROM moz_anno_attributes WHERE %@=%@)",
					   kMozItemsAnnosKeyContent,
					   kMozItemsAnnosKeyBookmarkID,
					   [mozBookmarksID stringEsquotedSQLValue],
					   kMozItemsAnnosKeyAttributeID,
					   // Nested query
					   kMozCommonKeyID,
					   kMozAnnoAttributesKeyName,
					   [annotationName stringEsquotedSQLValue]] ;
	annotation = [sqliter firstRowFromQuery:query
									  error:&error_] ;
	[query release] ;
	if ([annotation isKindOfClass:[NSNull class]]) {
		annotation = nil ;
	}
	
endAfterSettingError:
	if (error_ != nil) {
		[self setError:error_] ;
	}
	
	return annotation ;
}

- (void)forgetMozData {
	[self setRootTagsMozBookmarksIndex:nil] ;
}

- (void)dealloc {
	[_sqliter release] ;

    [m_tagger release];
	[m_rootTagsMozBookmarksIndex release] ;
	[m_parentsCached release] ;
    
	[super dealloc] ;
}

- (NSNumber*)mozBookmarksIndexOfRootName:(NSString*)rootName {
	NSNumber* indexNumber = nil ;
	NSError* error_ = nil ;
	SSYSqliter* sqliter = [self sqliterError_p:&error_] ;
	if (!sqliter) {
		error_ = [error_ errorByAddingUserInfoObject:[NSNumber numberWithInteger:40004]
											  forKey:@"Fine Code"] ;
		goto endAfterSettingError ;
	}

	/* Starting with Firefox 46, or maybe earlier, the guid of the desired
     root will be its name, right padded with underscores to 12 characters. */
    NSMutableString* underscoredRootName = [[NSMutableString alloc] initWithString:rootName] ;
    while (underscoredRootName.length < 12) {
        [underscoredRootName appendString:@"_"] ;
    }
    
    NSString* query ;
    
    query = [NSString stringWithFormat:@"SELECT id FROM moz_bookmarks WHERE guid=%@",
             [underscoredRootName stringEsquotedSQLValue]] ;
    [underscoredRootName release] ;
    indexNumber = [sqliter firstRowFromQuery:query
                                       error:&error_] ;
    if (error_ != nil) {
        SSYAddMethodNameInError(error_)
        error_ = [error_ errorByAddingUserInfoObject:[NSNumber numberWithInteger:1010]
                                              forKey:@"Fine Code"] ;
        goto endAfterSettingError ;
    }

    if (!indexNumber) {
        /* This could be an older version of Firefox, in which the hartainers
        were identified in a table of typically 5 rows, moz_bookmarks_roots.
        (What were they thinking?!?  Someone liked a lot of indirection?)
         This table was dropped in Firefox 46 (or maybe before). */
        query = [NSString stringWithFormat:@"SELECT folder_id FROM moz_bookmarks_roots WHERE root_name=%@",
                 [rootName stringEsquotedSQLValue]] ;
        indexNumber = [sqliter firstRowFromQuery:query
                                           error:&error_] ;
        if (error_ != nil) {
            SSYAddMethodNameInError(error_)
            error_ = [error_ errorByAddingUserInfoObject:[NSNumber numberWithInteger:1011]
                                                  forKey:@"Fine Code"] ;
            goto endAfterSettingError ;
        }
    }
    
    if (!indexNumber) {
        NSString* msg = [[NSString alloc] initWithFormat:
                         @"Could not find hard folder '%@' in Firefox bookmarks datanase.",
                         rootName] ;
        error_ = SSYMakeError(539481, msg) ;
        [msg release] ;
        error_ = [error_ errorByAddingUserInfoObject:[NSNumber numberWithInteger:1012]
                                              forKey:@"Fine Code"] ;
    }

endAfterSettingError:
	if (error_ != nil) {
		[self setError:error_] ;
	}
	
	return indexNumber ;
}

/*!
 @details  This method may set [self error]
 */
- (NSNumber*)rootTagsMozBookmarksIndex {
	if (!m_rootTagsMozBookmarksIndex) {
		[self setRootTagsMozBookmarksIndex:[self mozBookmarksIndexOfRootName:@"tags"]] ;
	}
	
	return m_rootTagsMozBookmarksIndex ;
}

- (NSNumber*)mozParentOfMozBookmarksID:(NSNumber*)subject {
	NSNumber* answer  = nil ; 
	NSError* error_ = nil ;

	// This section was changed in BookMacster 1.11.  Added parentsCached
	// so that a fetch is not necessary each time this method is invoked.
	// (which is once for each read item).  Resulted in 20% speedup of the
	// *Reading Firefox…* phase of an Import operation.
	NSDictionary* parents = [self parentsCached] ;
	if (!parents) {		
		SSYSqliter* sqliter = [self sqliterError_p:&error_] ;
		if (!sqliter) {
			error_ = [error_ errorByAddingUserInfoObject:[NSNumber numberWithInteger:40007]
												  forKey:@"Fine Code"] ;			
			goto endAfterSettingError ;
		}
		
		parents = [sqliter dicForAttribute:kMozBookmarksKeyParent
									   key:kMozCommonKeyID
									 table:@"moz_bookmarks"
									 error:&error_] ;
		if (!parents) {
			error_ = [error_ errorByAddingUserInfoObject:[NSNumber numberWithInteger:40021]
												  forKey:@"Fine Code"] ;			
			goto endAfterSettingError ;
		}
		
		[self setParentsCached:parents] ;
	}
	
	answer = [parents objectForKey:subject] ;
	
	if (answer) {
		// Test added in BookMacster 1.2.4 to make sure that, in a corrupt Firefox
		// bookmarks database, if an item is its own parent, =mozItemTypeForID:
		// does not go in an infinite loop.
		if ([subject isEqualToNumber:answer]) {
			answer = nil ;
		}
		
		if (![answer isKindOfClass:[NSNumber class]]) {
			// Defense against corrupt Firefox bookmarks added in BookMacster 1.11
			NSLog(@"Warning 524-1898 Ignoring %@, not a number", answer) ;
			answer = nil ;
		}
	}

endAfterSettingError:
	if (error_ != nil) {
		[self setError:error_] ;
	}
	
	return answer;
}

- (enum MozItemType)mozItemTypeForID:(NSNumber*)bookmarkID {
	NSInteger bookmarkIdValue = [bookmarkID integerValue] ;
	NSInteger rootTagsIndex = [[self rootTagsMozBookmarksIndex] integerValue] ;
	if ([self error] != nil) {
		goto endWithoutSettingError ;
	}
	
	if (bookmarkIdValue == 1) {
		return kMozItemTypeMotherOfAllItems ;
	}

	if (bookmarkIdValue == rootTagsIndex) {
		return kMozItemTypeRootTags ;
	}
	
	// Iterate to find greatest ancestor
	NSInteger mozBookmarksIDValue = bookmarkIdValue ;
	while (mozBookmarksIDValue != 0) {
		NSInteger parentIDValue = [[self mozParentOfMozBookmarksID:[NSNumber numberWithInteger:mozBookmarksIDValue]] integerValue] ;
		if ([self error] != nil) {
			goto endWithoutSettingError ;
		}
		
		if (parentIDValue == 1) {
			return kMozItemTypeStark ;
		}
		
		if (parentIDValue == rootTagsIndex) {
			return kMozItemTypeTag ;
		}
		
		if (parentIDValue == 0) {
			NSLog(@"Warning 512-5149 No parent for moz item with id=%ld", (long)bookmarkIdValue) ;
			return kMozItemTypeNone ;
		}
		
		// No answer yet; iterate to next ancestor
		mozBookmarksIDValue = parentIDValue ;
	}

endWithoutSettingError:
	// Warning: Multiple 'return' statements above.
	return kMozItemTypeNone ;
}

- (NSString*)urlForMozPlacesID:(NSNumber*)placesID
			  visitCountNumber:(NSNumber**)pVisitCountNumber {
	NSError* error_ = nil ;
	NSString* url = nil ;
	SSYSqliter* sqliter = [self sqliterError_p:&error_] ;
	if (!sqliter) {
		error_ = [error_ errorByAddingUserInfoObject:[NSNumber numberWithInteger:40008]
											  forKey:@"Fine Code"] ;
		goto endAfterSettingError ;
	}

				  if (pVisitCountNumber != NULL) {
		*pVisitCountNumber = nil ;
	}
	if ([placesID respondsToSelector:@selector(integerValue)]) {
		NSString* query = [[NSString alloc] initWithFormat:@"SELECT %@, %@ FROM %@ WHERE %@=%ld",
						   kMozPlacesKeyURL,
						   kMozPlacesKeyVisitCount,
						   @"moz_places", 
						   kMozCommonKeyID,
						   (long)[placesID integerValue]] ;
		NSDictionary* values = [sqliter firstRowFromQuery:query
													error:&error_] ;
		[query release] ;
		if (error_ != nil) {
			goto endAfterSettingError ;
		}
		id value ;
		
		// url
		value = [values valueForKey:kMozPlacesKeyURL] ;
		if ([value isKindOfClass:[NSString class]]) {
			url = value ;
		}
		// visitCount
		if (pVisitCountNumber != NULL) {
			value = [values valueForKey:kMozPlacesKeyVisitCount] ;
			if ([value isKindOfClass:[NSNumber class]]) {
				*pVisitCountNumber = value ;
			}
		}
	}
endAfterSettingError:
	if (error_ != nil) {
		[self setError:error_] ;
	}
	return url ;
}

- (void)extractFromDatabaseTaggings:(NSMutableDictionary*)taggings
						   families:(NSMutableDictionary*)families
					  canonicalTags:(NSMutableDictionary*)canonicalTags
								bar:(Stark**)pBar
							   menu:(Stark**)pMenu
							unfiled:(Stark**)pUnfiled {
	NSInteger mozBookmarksBarIndex = [[self mozBookmarksIndexOfRootName:@"toolbar"] integerValue] ;
	if ([self error] != nil) {
		goto endWithoutSettingError ;
	}
	NSInteger mozBookmarksMenuIndex = [[self mozBookmarksIndexOfRootName:@"menu"] integerValue] ;
	if ([self error] != nil) {
		goto endWithoutSettingError ;
	}
	NSInteger mozBookmarksUnfiledIndex = [[self mozBookmarksIndexOfRootName:@"unfiled"] integerValue] ;
	if ([self error] != nil) {
		goto endWithoutSettingError ;
	}
	
	NSError* error_ = nil ;
	SSYSqliter* sqliter = [self sqliterError_p:&error_] ;
	if (!sqliter) {
		error_ = [error_ errorByAddingUserInfoObject:[NSNumber numberWithInteger:40010]
											  forKey:@"Fine Code"] ;
		goto endAfterSettingError ;
	}

	// Now, read in the entire moz_bookmarks table, to get the
	// 'rawMozBookmarks', an array of dictionaries.
	NSArray* rawMozBookmarks = [sqliter allRowsInTable:@"moz_bookmarks"
												 error:&error_] ;
	if (error_ != nil) {
        // This, or Error 594520, may occur if Firefox has the "empty Library" corruption.
        NSString* s ;
        s = [NSString stringWithFormat:
             @"Could not get bookmarks from %@.",
             [self displayName]] ;
        error_ = [SSYMakeError(290041, s) errorByAddingUnderlyingError:error_] ;
        s = [NSString stringWithFormat:
             @"Activate %@ and check out its bookmarks.  Reset if necessary.",
             [self displayName]] ;
        error_ = [error_ errorByAddingLocalizedRecoverySuggestion:s] ;
		goto endAfterSettingError ;
	}
	
	SSYProgressView* progressView = [self progressView] ;
	[progressView setIndeterminate:NO] ;
	[progressView setMaxValue:[rawMozBookmarks count]] ;
	[progressView setDoubleValue:0.0] ;
	
	// Enumerate through the rawMozBookmarks
	for (NSDictionary* mozBookmarkDic in rawMozBookmarks) {
		NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
		
		[progressView incrementDoubleValueBy:1.0] ;
		NSNumber* mozBookmarksIndexNumber = [mozBookmarkDic objectForKey:kMozCommonKeyID] ;
		if (![mozBookmarksIndexNumber respondsToSelector:@selector(integerValue)]) {
			// Defense against corrupt Firefox bookmarks added in BookMacster 1.11
			NSLog(@"Warning 524-1891 Ignoring %@, not a number", mozBookmarksIndexNumber) ;
			[pool drain] ;
			continue ;
		}

		NSInteger mozBookmarksIndex = [mozBookmarksIndexNumber integerValue] ;
		enum MozItemType mozItemType = [self mozItemTypeForID:mozBookmarksIndexNumber] ;
		if ([self error] != nil) {
			// error_ should be nil here, but just to make sure, we transfer ownership.
			[error_ retain] ;
			[pool drain] ;
			[error_ autorelease] ;
			
			goto endWithoutSettingError ;
		}
		if (mozItemType == kMozItemTypeStark) {
			NSNumber* placesID = [mozBookmarkDic objectForKey:kMozBookmarksKeyPlaceID] ;
			NSNumber* visitCountNumber ;
			// We need the URL immediately to determine whether or not this is a
			// smart bookmark ;
			NSString* url = [self urlForMozPlacesID:placesID
								   visitCountNumber:&visitCountNumber] ;
			if ([self error] != nil) {
				// error_ should be nil here, but just to make sure, we transfer ownership.
				[error_ retain] ;
				[pool drain] ;
				[error_ autorelease] ;

				goto endWithoutSettingError ;
			}

            NSString* guid = [mozBookmarkDic objectForKey:kMozBookmarksKeyGuid];
            if ([guid isKindOfClass:[NSString class]]) {
                if ([guid isEqualToString:kMozMobileGuid]) {
                    [pool drain] ;
                    continue ;
                }
            }
            
            // It's a Stark that we need in our tree
			// Create the stark
			Stark* stark = [self.starker freshStark] ;
			
			// Set exid
			if (![guid isKindOfClass:[NSString class]]) {
				// Whoops this item doesn't have a guid.  ('value'
				// is an NSNull object.)  This can happen
				// if the item was originated by Firefox 3.x, never
				// imported by BookMacster version 1.3.19 or later,
				// and never synced by Xmarks or any other app which
				// may have set a guid.  So we create a fresh guid,
				// and also we write it to places.sqlite.
				[self getFreshExid_p:&guid
						  higherThan:0
							forStark:stark
							 tryHard:YES] ;
				
				NSString* query = [NSString stringWithFormat:@"UPDATE moz_bookmarks SET %@=%@ WHERE %@=%ld",
								   kMozBookmarksKeyGuid,
								   [guid stringEsquotedSQLValue],
								   kMozCommonKeyID,
								   (long)mozBookmarksIndex] ;
				[sqliter runQuery:query
							error:&error_] ;
				
				if (error_ != nil) {
					[error_ retain] ;
					[pool drain] ;
					[error_ autorelease] ;
					goto endAfterSettingError ;
				}
			}
			[stark setExid:guid
			  forClientoid:self.clientoid] ;
			
            id value ;

            // Set name
            value = [mozBookmarkDic objectForKey:kMozBookmarksKeyName] ;
            if ([value isKindOfClass:[NSString class]]) {
                [stark setName:value] ;
            }
            
			// If this is a feed, assign url from the kMozAnnoAttributeNameLivemarkURI annotation
			NSString* livemarkURI = [self mozAnnotationNamed:kMozAnnoAttributeNameLivemarkURI
											  forBookmarksID:mozBookmarksIndexNumber] ;
			if ([self error] != nil) {
				// error_ should be nil here, but just to make sure, we transfer ownership.
				[error_ retain] ;
				[pool drain] ;
				[error_ autorelease] ;

				goto endWithoutSettingError ;
			}
			if (livemarkURI != nil) {
				// The following appears to be not necessary, since Firefox 3 livemarks
				// store their URL in two places in places.sqlite: in moz_places 
				// and also in moz_items_annos.  I don't know which is better.
				// We'll setUrl from the one in moz_items_annos here, and then later,
				// if we find a url in moz_places, we'll overwrite it.
				[stark setUrl:livemarkURI] ;
			}

			// Set sharype value, also assign to bar, menu or unfiled if one of these
			NSNumber* bookmarkTypeObject = [mozBookmarkDic objectForKey:kMozBookmarksKeyType] ;
			if (![bookmarkTypeObject respondsToSelector:@selector(integerValue)]) {
				// Defense against corrupt Firefox bookmarks added in BookMacster 1.11
				NSLog(@"Warning 524-1892 Ignoring %@, not a number", bookmarkTypeObject) ;
				[pool drain] ;
				continue ;
			}
			
			NSInteger mozBookmarkType = [bookmarkTypeObject integerValue] ;
			Sharype sharype ;
			if (mozBookmarkType == kMozBookmarksTypeBookmark) {
				if ([self isSmartUrl:url]) {
					sharype = SharypeSmart ;
				}
				else {
					sharype = SharypeBookmark ;
					// The above is not necessarily true because it may
					// actually be a SharypeRSSArticle.  But in that case,
					// when we later setRssArticlesFromAndRemoveStarks:, the sharype of this
					// starks will be ignored, and this stark itself
					// will be deleted anyhow.
				}
			}
			else if (mozBookmarkType == kMozBookmarksTypeSeparator) {
				sharype = SharypeSeparator ;
                [stark separatorify];
			}
			else {
				// Must be one of the container types.
				// Set this Stark as parent of its family, creating a new family if not exists yet
				NSMutableDictionary* family = [families objectForKey:mozBookmarksIndexNumber] ;
				if (family == nil) {
					family = [NSMutableDictionary dictionary] ;
					[families setObject:family forKey:mozBookmarksIndexNumber] ;
				}
				[family setObject:stark forKey:kStark] ;
				
				// Sanity check
				if (mozBookmarkType != kMozBookmarksTypeFolder) {
					NSLog(@"Internal Error 523-5981 -[ExtoreFirefox put].  Treating unrecognized moz_bookmarks type %ld as folder.  title=%@.", (long)mozBookmarkType, [stark name]) ;
				}
				
				// Identify if bar, menu or unfiled; assign sharype.
				if (mozBookmarksIndex == mozBookmarksBarIndex) {
					sharype = SharypeBar ;
					*pBar = stark ;
				}
				else if (mozBookmarksIndex == mozBookmarksMenuIndex) {
					sharype = SharypeMenu ;
					*pMenu = stark ;
				}
				else if (mozBookmarksIndex == mozBookmarksUnfiledIndex) {
					sharype = SharypeUnfiled ;
					*pUnfiled = stark ;
				}
				else if (livemarkURI) {
					sharype = SharypeLiveRSS ;
				}
				else {
					sharype = SharypeSoftFolder ;
				}
				
				if ([self error] != nil) {
					// error_ should be nil here, but just to make sure, we transfer ownership.
					[error_ retain] ;
					[pool drain] ;
					[error_ autorelease] ;

					goto endWithoutSettingError ;
				}
			}			
			[stark setSharypeValue:sharype] ;
			
			// Add to family, creating family if parent does not exist yet
			NSNumber* parentMozBookmarksIndexNumber = [mozBookmarkDic objectForKey:kMozBookmarksKeyParent] ;
			NSMutableDictionary* family = [families objectForKey:parentMozBookmarksIndexNumber] ;
			if (family == nil) {
				family = [NSMutableDictionary dictionary] ;
				[families setObject:family forKey:parentMozBookmarksIndexNumber] ;
			}
			NSMutableArray* children = [family objectForKey:kChildren] ;
			if (children == nil) {
				children = [NSMutableArray array] ;
				[family setObject:children forKey:kChildren] ;
			}
			NSDictionary* child = [NSDictionary dictionaryWithObjectsAndKeys:
								   stark, kStark,
								   [mozBookmarkDic objectForKey:kMozBookmarksKeyPosition], kPosition,
								   nil] ;
			[children addObject:child] ;
			
			// Set addDate
			value = [mozBookmarkDic objectForKey:kMozCommonKeyAddDate] ;
			[stark setAddDate:[NSDate dateWithLongLongMicrosecondsSince1970:value]] ;
			
			// Set lastModifiedDate
			value = [mozBookmarkDic objectForKey:kMozCommonKeyLastModifiedDate] ;
			[stark setLastModifiedDate:[NSDate dateWithLongLongMicrosecondsSince1970:value]] ;
			
			// Set url
			if (url != nil) {
				[stark setUrl:url] ;
			}
			
			// Set visitCount
			if (visitCountNumber != nil) {
				[stark setOwnerValue:visitCountNumber
                              forKey:constKeyVisitCount] ;
			}
			
			// Set description
			NSString* comments = [self mozAnnotationNamed:kMozAnnoAttributeNameBookmarkDescription
										   forBookmarksID:mozBookmarksIndexNumber] ;
			if ([self error] != nil) {
				// error_ should be nil here, but just to make sure, we transfer ownership.
				[error_ retain] ;
				[pool drain] ;
				[error_ autorelease] ;

				goto endWithoutSettingError ;
			}
			if ([comments length] > 0) {
				[stark setComments:comments] ;
			}
		}
		else if (mozItemType == kMozItemTypeTag) {
			BOOL isRoot = [mozBookmarksIndexNumber isEqual:[self rootTagsMozBookmarksIndex]] ;
			if ([self error] != nil) {
				// error_ should be nil here, but just to make sure, we transfer ownership.
				[error_ retain] ;
				[pool drain] ;
				[error_ autorelease] ;

				goto endWithoutSettingError ;
			}
			if (isRoot) {
				// This is the Root of Tags.
				// It does not contain any useful attributes
				// We are only interested in its children.
			}
			else {
				// We've got either a Tag Folder or a Tag Joiner
				
				// Query to get parent, type and fk
				NSString* query = [[NSString alloc] initWithFormat:@"SELECT %@, %@, %@ FROM %@ WHERE %@=%ld",
								   kMozBookmarksKeyParent,
								   kMozBookmarksKeyType,
								   kMozBookmarksKeyPlaceID,
								   @"moz_bookmarks", 
								   kMozCommonKeyID,
								   (long)mozBookmarksIndex] ;
				NSDictionary* values = [sqliter firstRowFromQuery:query
															error:&error_] ;
				[query release] ;
				if (error_ != nil) {
					[error_ retain] ;
					[pool drain] ;
					[error_ autorelease] ;

					goto endAfterSettingError ;
				}
				
				// Unpack the type
				NSNumber* mozBookmarksTypeNumber = [values objectForKey:kMozBookmarksKeyType] ;
				NSInteger mozBookmarksType = NSNotFound ;
				if ([mozBookmarksTypeNumber respondsToSelector:@selector(integerValue)]) {
					mozBookmarksType = [mozBookmarksTypeNumber integerValue] ;
				}
				
				if (mozBookmarksType == kMozBookmarksTypeBookmark) {
					// It's a Tag Joiner
					
					// Get the url of this tag 
					NSNumber* mozBookmarksPlacesIDNumber = [values objectForKey:kMozBookmarksKeyPlaceID] ;
					// Now do another query to get get the moz_places record,
					if (![mozBookmarksPlacesIDNumber respondsToSelector:@selector(integerValue)]) {
						// Defense against corrupt Firefox bookmarks added in BookMacster 1.11
						NSLog(@"Warning 524-1893 Ignoring %@, not a number", mozBookmarksPlacesIDNumber) ;
						[pool drain] ;
						continue ;
					}
					NSInteger mozBookmarksPlacesID = [mozBookmarksPlacesIDNumber integerValue] ;
					NSString* query = [[NSString alloc] initWithFormat:@"SELECT %@ FROM %@ WHERE %@=%ld",
									   kMozPlacesKeyURL,
									   @"moz_places", 
									   kMozCommonKeyID,
									   (long)mozBookmarksPlacesID] ;
					NSString* urlOfTag = [sqliter firstRowFromQuery:query
															  error:&error_] ;
					[query release] ;
					if (error_ != nil) {
						[error_ retain] ;
						[pool drain] ;
						[error_ autorelease] ;

						goto endAfterSettingError ;
					}

					// Get the Tag Folder that this Tag Joiner it is in
					NSNumber* mozBookmarksTagIndexNumber = [values objectForKey:kMozBookmarksKeyParent] ;

					// Get the Tag, which is the name of this Tag Folder
					NSString* tag = nil ;
					if ([mozBookmarksTagIndexNumber respondsToSelector:@selector(integerValue)]) {
						NSInteger mozBookmarksTagIndex = [mozBookmarksTagIndexNumber integerValue] ;
						// Getting the name requires another query
						NSString* query = [[NSString alloc] initWithFormat:@"SELECT %@ FROM %@ WHERE %@=%ld",
										   kMozBookmarksKeyName,
										   @"moz_bookmarks", 
										   kMozCommonKeyID,
										   (long)mozBookmarksTagIndex] ;
						tag = [sqliter firstRowFromQuery:query
												   error:&error_] ;
						[query release] ;
						if (error_ != nil) {
							[error_ retain] ;
							[pool drain] ;
							[error_ autorelease] ;
							
							goto endAfterSettingError ;
						}
					}
					
					// Got all info, the tag and the url.
					// To finish up, enter it into the taggings dictionary.
					// Howevever, this may have been an orphaned Tag Joiner (corrupt database?)
					// I mean that either urlOfTag or tag may be nil.
					// So we check for that first
					if ((tag != nil) && (urlOfTag != nil)) {
						// Also if a tagging set (of tags) already exists in taggings
						// for this url, we add it to the existing set instead of creating
						// tagging
						NSMutableArray* tagging = [taggings objectForKey:urlOfTag] ;
						if (tagging != nil) {
							// Add to existing tagging array
							[tagging addObject:tag] ;
						}
						else {
							// Create a new tagging array
							tagging = [NSMutableArray arrayWithObject:tag] ;
							[taggings setObject:tagging
										 forKey:urlOfTag] ;
						}
					}
				}
				else {
					// It's a Tag Folder
					
					// These are only used to coalesce bad tags, and only during exports
					if (canonicalTags != nil) {
						// It's an export
						NSString* tag = [mozBookmarkDic objectForKey:kMozBookmarksKeyName] ;
						NSString* canonicalTag = [tag lowercaseString] ;
						NSMutableDictionary* equivalentTags = [canonicalTags objectForKey:canonicalTag] ;
						if (!equivalentTags) {
							equivalentTags = [[NSMutableDictionary alloc] init] ;
							[canonicalTags setObject:equivalentTags
											  forKey:canonicalTag] ;
							[equivalentTags release] ;
						}
						NSMutableArray* tagIds = [equivalentTags objectForKey:tag] ;
						if (!tagIds) {
							tagIds = [[NSMutableArray alloc] init] ;
							[equivalentTags setObject:tagIds
											   forKey:tag] ;
							[tagIds release] ;
						}
						NSNumber* tagId = [mozBookmarkDic objectForKey:kMozCommonKeyID] ;
						[tagIds addObject:tagId] ;
					}
				}
			}
		}
		
		[pool drain] ;
	}
	
	[progressView setIndeterminate:YES] ;
	
endAfterSettingError:
	if (error_ != nil) {
		*pBar = nil ;
		*pMenu = nil ;
		*pUnfiled = nil ;
		[self setError:error_] ;
	}
	
endWithoutSettingError:
	// Defensive programming against having a stale cache
	[self setParentsCached:nil] ;
}

- (void)improveErrorWithCurrentStark:(Stark*)stark {
	NSError* error_ = [self error] ;
	if (error_ !=  nil) {
		NSInteger sqlErrorCode = [SSYSqliter sqlErrorCodeFromErrorCode:[[self error] code]] ;
		NSString* localizedFailureReason = nil ;
		NSString* localizedRecoverySuggestion = nil ;
		if ((sqlErrorCode==SQLITE_BUSY) || (sqlErrorCode==SQLITE_LOCKED)) {
			NSString* ownerAppDisplayName = [self ownerAppDisplayName] ;
			localizedFailureReason = [NSString localizeFormat:@"appLaunchedDuringOperation", ownerAppDisplayName] ;
			localizedRecoverySuggestion = [NSString localizeFormat:@"quitAppTryOperationAgain", ownerAppDisplayName] ;
		}
		else if (sqlErrorCode == SQLITE_TOOBIG) {
			// Found experimentally: Firefox 3.0 RC1, Leopard, a URL of 1466027 chars is OK but 1925120 gives error_ SQLITE_TOOBIG
			NSString* name = [stark name] ;
			localizedFailureReason = [NSString localizeFormat:@"tooLongX", name] ;
			localizedRecoverySuggestion = [NSString localizeFormat:@"delete%0", name] ;
		}
		error_ = [error_ errorByAppendingLocalizedFailureReason:localizedFailureReason] ;
		error_ = [error_ errorByAddingLocalizedRecoverySuggestion:localizedRecoverySuggestion] ;
		[self setError:error_] ;
	}
}

/*!
 @brief    Coalesces duplicate tags, case-insensitively, which
 is what happens when you type tags manually into Firefox'
 Show All Bookmarks / Library

 @details  For algorithm see "Firefox3Database.oo3", 
 section "-coalesceBadTags:error_p: Algorithm".
 
 I wonder if this code could be simplified by using some fancy
 SQL, as I did near the end of this method to remove redundant
 tag joiners?  I don't know.  It worked on the procedural
 algorithm for about a day before I got it working!  If all
 this could be done in one line, it would be pretty amazing.
 
 This method was added in BookMacster 1.11.
*/
- (BOOL)coalesceBadTags:(NSMutableDictionary*)canonicalTags
				error_p:(NSError**)error_p {
	NSString* query ;
	NSError* error = nil ;
	NSMutableDictionary* doomedTagIds = nil ;
	NSInteger nRetagged = 0 ;
	NSInteger nUntagged = 0 ;
	NSInteger nDeletedTags = 0 ;
	NSInteger nDeletedTagJoiners = 0 ;
	
	SSYSqliter* sqliter = [self sqliterError_p:&error] ;
	
	[self beginTransactionError_p:&error] ;
	if (error) {
		error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:20001]
											  forKey:@"Fine Code"] ;
		goto endAfterSettingError ;
	}
	
	doomedTagIds = [[NSMutableDictionary alloc] init] ;
	for (NSString* canonicalTag in canonicalTags) {
		NSDictionary* equivalentTagsDic = [canonicalTags objectForKey:canonicalTag] ;
		NSMutableArray* equivalentTags = [[equivalentTagsDic allKeys] mutableCopy] ;
		[equivalentTags sortUsingSelector:@selector(compareCase:)] ;
		NSNumber* survivor = nil ;
		for (NSString* tag in equivalentTags) {				
			NSArray* tagIds = [equivalentTagsDic objectForKey:tag] ;
			for (NSNumber* tagId in tagIds) {
				if (survivor) {
					[doomedTagIds setObject:survivor
									 forKey:tagId] ;
				}
				else {
					survivor = tagId ;
				}
			}
		}
		[equivalentTags release] ;
	}
	
	for (NSNumber* doomedTagId in doomedTagIds) {
		NSNumber* survivor = [doomedTagIds objectForKey:doomedTagId] ;
		NSError* error = nil ;
		
		// Get the joiner ids of the doomed tag
		query = [NSString stringWithFormat:@"SELECT %@ from moz_bookmarks WHERE %@=%@",
				 kMozCommonKeyID,
				 kMozBookmarksKeyParent,
				 [doomedTagId stringEsquotedSQLValue]] ;
		NSArray* joinerIds = [sqliter runQuery:query
										 error:&error] ;
		if (error != nil) {
			error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:20010]
												forKey:@"Fine Code"] ;
			goto endAfterSettingError ;
		}
		
		// For each joiner id, either delete it or redirect it to the survivor tag
		for (NSNumber* joinerId in joinerIds) {
			// Get its url id
			query = [NSString stringWithFormat:@"SELECT %@ from moz_bookmarks WHERE %@=%@",
					 kMozBookmarksKeyPlaceID,
					 kMozCommonKeyID,
					 [joinerId stringEsquotedSQLValue]] ;
			NSNumber* urlId = [sqliter firstRowFromQuery:query
												   error:&error] ;
			if (error != nil) {
				error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:20020]
													forKey:@"Fine Code"] ;
				goto endAfterSettingError ;
			}
			
			// See if there is another tag joiner (redundee) which makes tagJoiner redundant
			query = [NSString stringWithFormat:@"SELECT %@ from moz_bookmarks WHERE %@=%@ AND %@=%@",
					 kMozCommonKeyID,
					 kMozBookmarksKeyPlaceID,
					 [urlId stringEsquotedSQLValue],
					 kMozBookmarksKeyParent,
					 [survivor stringEsquotedSQLValue]] ;
			NSNumber* redundee = [sqliter firstRowFromQuery:query
													  error:&error] ;
			if (error != nil) {
				error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:20030]
													forKey:@"Fine Code"] ;
				goto endAfterSettingError ;
			}
			
			if (redundee) {
				// This tag joiner is no longer needed.  Delete from database.
				query = [NSString stringWithFormat:@"DELETE from moz_bookmarks WHERE %@=%@",
						 kMozCommonKeyID,
						 [joinerId  stringEsquotedSQLValue]] ;
				[sqliter runQuery:query
							error:&error ] ;
				if (error != nil) {
					error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:20040]
														forKey:@"Fine Code"] ;
					goto endAfterSettingError ;
				}
				nUntagged++ ;
			}
			else {
				// Redirect this tag joiner to the survivor tag
				NSString* query = [NSString stringWithFormat:@"UPDATE moz_bookmarks SET %@=%@ WHERE %@=%@",
								   kMozBookmarksKeyParent,
								   [survivor stringEsquotedSQLValue],
								   kMozCommonKeyID,
								   [joinerId stringEsquotedSQLValue]] ;
				[sqliter runQuery:query
							error:&error] ;
				
				if (error != nil) {
					error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:20050]
														forKey:@"Fine Code"] ;
					goto endAfterSettingError ;
				}
				nRetagged++ ;
			}
		}
		
		// Delete the doomed tag
		query = [NSString stringWithFormat:@"DELETE from moz_bookmarks WHERE %@=%@",
				 kMozCommonKeyID,
				 [doomedTagId  stringEsquotedSQLValue]] ;
		[sqliter runQuery:query
					error:&error ] ;
		if (error != nil) {
			error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:20060]
												forKey:@"Fine Code"] ;
			goto endAfterSettingError ;
		}
		nDeletedTags++ ;
	}
	
	// In developing BookMacster 1.11, I found that places.sqlite had some
	// redundant tag joiners, that is, more than one tag joiner joining
	// the same URL (fk) to the same tag (parent).  So after looking at
	// some examples on the internet I developed the following code which
	// eliminated the redundant ones.  I don't understand much of it, but
	// it worked.  However, then I found that it was my own bug, in 
	// -writeUsingStyle1InOperation: which was creating the redundant
	// tag joiners, and furthermore before they are created in that method,
	// all existing tag joiners would be wiped out.  So, this code is
	// fixing things that are going to be wiped out anyhow for write style 1.
	// But it is effective in eliminating duplicate tag joiners (which 
	// are apparent in Firefox' Library as duplicate tags) in case someone
	// always leaves Firefox running and thus never uses write style 1.
	// t2 is apparently a proxy for "any other row".  I think you could
	// use any symbol, i.e. 'foo', instead of 't2'.
	query = [NSString stringWithFormat:@"DELETE FROM moz_bookmarks WHERE EXISTS "
			 @"(SELECT 1 FROM moz_bookmarks t2 WHERE "
			 @"%@ ISNULL "                                     // title ISNULL.  This is to qualify tag joiners only.
			 @"AND %@=1 "                                      // type = 1.  This is to qualify tag joiners only.
			 @"AND moz_bookmarks.%@ = t2.%@ "                  // The URL (fk) must be the same
			 @"AND moz_bookmarks.%@ = t2.%@ "                  // The tag (parent) must be the same
			 @"AND moz_bookmarks.%@ < t2.%@)",                 // Delete ones with lower id(s), keep the one with higher id
			 kMozBookmarksKeyName,                             // title
			 kMozBookmarksKeyType,                             // type
			 kMozBookmarksKeyPlaceID, kMozBookmarksKeyPlaceID, // fk
			 kMozBookmarksKeyParent, kMozBookmarksKeyParent,   // parent
			 kMozCommonKeyID, kMozCommonKeyID] ;               // id
	[sqliter runQuery:query
				error:&error] ;
	if (error != nil) {
		error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:20070]
											forKey:@"Fine Code"] ;
		goto endAfterSettingError ;
	}
	nDeletedTagJoiners = [sqliter countChangedRows] ;

		
	
endAfterSettingError:;
	[doomedTagIds release] ;
	
	[self endTransactionError_p:&error] ;
	if (error != nil) {
		error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:20080]
											forKey:@"Fine Code"] ;
	}
	
	if (nRetagged | nUntagged | nDeletedTags | nDeletedTagJoiners > 0) {
		NSLog(@"Warning 624-7793 Fixed funky tags in Firefox.  Untagged %ld, retagged %ld, deleted %ld duplicate tags, %ld duplicate joiners.",
			  (long)nUntagged,
			  (long)nRetagged,
			  (long)nDeletedTags,
			  (long)nDeletedTagJoiners) ;
	}
	
	BOOL ok = YES ;
	if (error) {
		ok = NO ;
		if (error_p) {
			*error_p = error ;
		}
	}
	
	return ok ;
}
	

- (void)readExternalStyle1ForPolarity:(BkmxIxportPolarity)polarity
                    completionHandler:(void(^)(void))completionHandler {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
	Stark *bar = nil, *menu = nil, *unfiled = nil ;
	
	[self setError:nil] ;
	[self forgetMozData] ;
		
	NSMutableDictionary* families = [NSMutableDictionary dictionary] ;  // for assigning children, later
	NSMutableDictionary* taggings = [NSMutableDictionary dictionary] ;  // for tagging, later	
	NSMutableDictionary* canonicalTags	= [[NSMutableDictionary alloc] init] ;
	
	// And a few variables, too
	[self extractFromDatabaseTaggings:taggings
							 families:families
						canonicalTags:canonicalTags
								  bar:&bar
								 menu:&menu
							  unfiled:&unfiled] ;
	if ([self error] != nil) {
		goto endWithoutSettingError ;
	}	
	
	if (polarity == BkmxIxportPolarityExport) {
		NSError* error = nil ;
		BOOL okCoalesceTags = [self coalesceBadTags:canonicalTags
											error_p:&error] ;
		if (!okCoalesceTags) {
			// Since coalesceBadTags:error_p: is only to fix possibly 
			// corrupt bookmarks, an error here is probably not fatal
			// and may even be inconsequential.  Just log and continue.
			NSLog(@"Internal Error 734-2348 %@", [error longDescription]) ;
		}
	}
	
	// Enumerate the taggings dictionary and add tags to bookmarks.
	// Note that we will add the tag to ^every bookmark^ that has this url.
	// This is the way Firefox does it when it loads bookmarks from places.sqlite.
	// [Well, actually their tags are unique objects with a to-one relationship
	// to urls (moz_places) which have a to-many relationship to bookmarks
	// (moz_bookmarks).  But the effect is the same.]
    SSYProgressView* progressView = [[self progressView] setIndeterminate:NO
                                                        withLocalizedVerb:[NSString localizeFormat:
                                                                           @"loadingWhat",
                                                                           [[BkmxBasis sharedBasis] labelTags]]
                                                                 priority:SSYProgressPriorityRegular] ;
	// The following section was improved from the stupid
	// code which existed prior to BookMacster 1.11.
	// Before the fix, 4K bookmarks with ~3 bookmarks 
	// per tag executed in 20 seconds.  After, < 0.5 sec.
	NSArray* allStarks = [[self starker] allStarks] ;
	[progressView setMaxValue:[allStarks count]] ;
	NSInteger nStarks = 0 ;
    Tagger* tagger = [self tagger];
	for (Stark* stark in allStarks) {
		NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
		[progressView setDoubleValue:++nStarks] ;
        if ([stark sharypeValue] == SharypeBookmark) {
            NSArray* tags = [taggings objectForKey:[stark url]] ;
            [tagger updateTagStrings:tags
                             inStark:stark];
        }
		[pool release] ;
	}
	
	// Connect up family relationships
	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:kPosition
																   ascending:YES] ;
	NSArray* sortDescriptors = [NSArray arrayWithObject:sortDescriptor] ;
	[sortDescriptor release] ;
    progressView = [progressView setIndeterminate:NO
                                withLocalizedVerb:[NSString localizeFormat:
                                                   @"loadingWhat",
                                                   [[BkmxBasis sharedBasis] labelChildren]]
                                         priority:SSYProgressPriorityRegular] ;
	[progressView setMaxValue:[families count]] ;
	NSInteger nFamilies = 0 ;
	for (NSNumber* anIndex in families) {
		NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
		[progressView setDoubleValue:++nFamilies] ;
		NSDictionary* family = [families objectForKey:anIndex] ;
		NSMutableArray* descendants = [family objectForKey:kChildren] ;
		[descendants sortUsingDescriptors:sortDescriptors] ;
		// Create a new array by taking only the stark key
		// (leaving behind the position key)
		NSMutableArray* sortedDescendants = [[descendants valueForKey:kStark] mutableCopy] ;
		Stark* mother = [family objectForKey:kStark] ;
		if ([mother sharypeValue] == SharypeLiveRSS) {
			[mother setRssArticlesFromAndRemoveStarks:sortedDescendants] ;
		}
		else {
			[mother appendChildren:sortedDescendants] ;
		}
		[sortedDescendants release] ;
		[pool release] ;
	}
	[progressView setIndeterminate:YES] ;
	
endWithoutSettingError:
	[canonicalTags release] ;
	
	[self improveErrorWithCurrentStark:nil] ;
	
	// Set instance variables
	Stark* root = [[self starker] root] ;
	[root setSharypeValue:SharypeRoot] ;
	[root assembleAsTreeWithBar:bar
						   menu:menu
						unfiled:unfiled
						 ohared:nil] ;

	completionHandler();

    [pool release] ;
}

- (NSNumber*)mozPlacesIDForURL:(NSString*)url {
	// moz_places may be referenced by multiple bookmarks, abandoned, never deleted, never changed.
	// This is the case even if the bookmark was never visited.  That means that "never deleted"
	// is not done for the sake of history.
	// Finally, note that multiple bookmarks in Firefox may point the same
	// row (fk) in moz_places.
	
    NSError* error_ = nil;
    /* Check the cache first */
	NSNumber* placesID = [m_mozPlacesForUrlCache objectForKey:url];
    /*   The cache should have all existing (pre-export) URLs in places.sqlite,
     and all those thus far inserted.  So there is no need to do a (costly)
     fetch if placesID is nil here, because it will not find anything. */

	if (url && !placesID) {
        /* This *must* be a new url that we need to insert (see previous
         comment.) */
        SSYSqliter* sqliter = [self sqliterError_p:&error_] ;
        if (!sqliter) {
            error_ = [error_ errorByAddingUserInfoObject:[NSNumber numberWithInteger:40011]
                                                  forKey:@"Fine Code"] ;
        }

        if (!error_ && !placesID) {
            // Requested url does not exist in places
            // Create/Insert a new row
            long long placesIDInt = [sqliter nextLongLongInColumn:kMozCommonKeyID
                                                          inTable:@"moz_places"
                                                     initialValue:1
                                                            error:&error_ ] ;
            if (!error_) {
                placesID = [NSNumber numberWithLongLong:placesIDInt] ;

                NSString* guid ;
                [self getFreshExid_p:&guid
                          higherThan:0
                            forStark:nil
                             tryHard:YES] ;

                NSArray* columns = [NSArray arrayWithObjects:
                                    kMozCommonKeyID,
                                    kMozPlacesKeyURL,
                                    kMozPlacesKeyName,
                                    kMozPlacesKeyRevHost,
                                    kMozPlacesKeyVisitCount,
                                    kMozPlacesKeyHidden,
                                    kMozPlacesKeyTyped,
                                    kMozPlacesKeyGuid,
                                    nil] ;

                // Compute title and rev_host.  Some of this doesn't make sense,
                // but it's all reverse-engineered from what I see done by Firefox.
                // When you set a bookmark in Firefox, the title in moz_places is the
                // value of the 'title' tag in the 'head' of the HTML.  We don't know
                // that unless we visit the page, so I use what I thought I saw Firefox
                // do before I figured out what 'title' in moz_places really was.
                // I did not try and reproduce all the invalid cases such as url="xxxx://x/y/z".
                NSURL* nsurl = (url != nil) ? [NSURL URLWithString:url] : nil ;
                id title = nil ;
                id revHost = nil ;
                NSInteger colonLocation ;
                if ([url hasPrefix:@"http://"]) {
                    title = [nsurl host] ;
                    revHost = [title reverseAsciiChars] ;
                }
                else if ([url hasPrefix:@"feed://"]) {
                    title = [[nsurl path] lastPathComponent] ;
                    revHost = [title reverseAsciiChars] ;
                }
                else if ([url hasPrefix:@"file://"]) {
                    title = [[nsurl path] lastPathComponent] ;
                    revHost = @"" ;
                }
                else if ((colonLocation = [url rangeOfString:@":"].location) != NSNotFound) {
                    // May be a javascript:, smart bookmark place:
                    // or Tag/Bar/Menu/Unfiled place:
                    title = [url substringFromIndex:(colonLocation+1)] ;
                }
                // Fix them up
                if (title == nil) {
                    title = [NSNull null] ;
                }
                if (revHost == nil) {
                    revHost = [NSNull null] ;
                }
                else {
                    revHost = [revHost stringByAppendingString:@"."] ;
                }

                NSArray* values = [NSArray arrayWithObjects:
                                   placesID,                   // id
                                   url,                        // url
                                   title,                      // title
                                   revHost,                    // rev_host
                                   [NSNumber numberWithInteger:0], // visit_count
                                   [NSNumber numberWithInteger:1], // hidden
                                   [NSNumber numberWithInteger:0], // typed
                                   guid,                           // guid
                                   nil] ;
                NSString* query = [SSYSqliter queryInsertIntoTable:@"moz_places"
                                                           columns:columns
                                                            values:values] ;
                [sqliter runQuery:query
                            error:&error_ ] ;
                if (error_ != nil) {
                    error_ = [error_ errorByAddingUserInfoObject:[NSNumber numberWithInteger:5000]
                                                          forKey:@"Fine Code"] ;
                }
            }
        }

        if (placesID) {
            [m_mozPlacesForUrlCache setObject:placesID
                                       forKey:url];
        }
    }

	if (error_ != nil) {
		[self setError:error_ ] ;
	}
	
	return placesID ;
}

- (NSNumber*)attributeIDForAnnotationName:(NSString*)annotationName {
	// Will always return an NSNumber, never nil
	NSNumber* attributeID = nil ;
	NSError* error_ = nil ;
	SSYSqliter* sqliter = [self sqliterError_p:&error_] ;
	if (!sqliter) {
		error_ = [error_ errorByAddingUserInfoObject:[NSNumber numberWithInteger:40013]
											  forKey:@"Fine Code"] ;
		goto endAfterSettingError ;
	}

	NSString* query = [[NSString alloc] initWithFormat:@"SELECT %@ FROM %@ WHERE %@=%@",
					   kMozCommonKeyID,
					   @"moz_anno_attributes", 
					   kMozAnnoAttributesKeyName,
					   [annotationName stringEsquotedSQLValue]] ;
	attributeID = [sqliter firstRowFromQuery:query
									   error:&error_ ] ;
	[query release] ;
	if (error_ != nil) {
		goto endAfterSettingError ;
	}
	if (!attributeID || [attributeID isKindOfClass:[NSNull class]]) {
		// This can happen if the user has never used an annotation of
		// type annotationName before, because Firefox creates them only
		// as needed.  So, we now create one.
		long long nextID = [sqliter nextLongLongInColumn:kMozCommonKeyID
												 inTable:@"moz_anno_attributes"
											initialValue:1
												   error:&error_ ] ;
		if (error_ != nil) {
			goto endAfterSettingError ;
		}
		attributeID = [NSNumber numberWithLongLong:nextID] ;
		NSArray* columns = [NSArray arrayWithObjects:
							kMozCommonKeyID,
							kMozAnnoAttributesKeyName,
							nil] ;
		NSArray* values = [NSArray arrayWithObjects:
						   attributeID,
						   annotationName,
						   nil] ;
		NSString* query = [SSYSqliter queryInsertIntoTable:@"moz_anno_attributes"
												  columns:columns
												   values:values] ;
		[sqliter runQuery:query
					error:&error_ ] ;
		if (error_ != nil) {
			error_ = [error_ errorByAddingUserInfoObject:[NSNumber numberWithInteger:7000]
												forKey:@"Fine Code"] ;
			goto endAfterSettingError ;
		}
		
		// Since this should only happen once in a lifetime,
		NSLog(@"In moz_anno_attributes, created record with id:%@ name:\"%@\"", attributeID, annotationName) ; 
	}
	
endAfterSettingError:
	if (error_ != nil) {
		[self setError:error_ ] ;
	}
	
	return attributeID ;
}

- (void)updateMozAnnosSetContent:(id)newContent
				  annotationName:(NSString*)annotationName
					  bookmarkID:(NSNumber*)bookmarkID {
	// I call this method "update" instead of "set", because it
	// compares new and moz (existing) values and does nothing
	// if they are already the same.
	if (!bookmarkID) {
		NSLog(@"Internal Error 682-0548 %@ : %@", newContent, bookmarkID) ;
	}
    else {
        id mozContent = [self mozAnnotationNamed:annotationName
                                  forBookmarksID:bookmarkID] ;
        if ([self error] != nil) {
            goto endWithoutSettingError ;
        }
        
        NSError* error_ = nil ;
        SSYSqliter* sqliter = [self sqliterError_p:&error_] ;
        if (!sqliter) {
            error_ = [error_ errorByAddingUserInfoObject:[NSNumber numberWithInteger:40014]
                                                  forKey:@"Fine Code"] ;
            goto endAfterSettingError ;
        }
        
        NSString* query = nil ;
        
        if (newContent != nil) {
            if (mozContent != nil) {
                if (![mozContent isEqual:newContent]) {
                    // Case 1.  newContent and mozContent both exist but are different
                    // Must update that record in moz database.
                    NSNumber* now = [[NSDate date] longLongMicrosecondsSince1970] ;
                    NSDictionary* updateDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                               newContent, kMozItemsAnnosKeyContent,
                                               now, kMozCommonKeyLastModifiedDate,
                                               nil] ;
                    // Note that we have set the lastModified time to now, but
                    // have not touched the dateAdded time.  This is how Firefox does it.
                    query = [SSYSqliter queryUpdateTable:@"moz_items_annos"
                                                 updates:updateDic
                                             whereColumn:kMozItemsAnnosKeyBookmarkID
                                              whereValue:bookmarkID] ;
                }
                else {
                    // Case 2.  newContent is same as mozContent.
                    // Do nothing.
                }
            }
            else {
                // Case 3.  newContent is non-nil but mozContent is nil.
                // Must create new entry and insert into moz table.
                
                // We need the identifier of the attribute...
                NSNumber* mozBookmarksDescriptionAttributeID = [self attributeIDForAnnotationName:annotationName] ;
                if ([self error] != nil) {
                    goto endWithoutSettingError ;
                }
                // The above will never return nil
                NSArray* columns = [ExtoreFirefox mozItemsAnnosColumns] ;
                NSNumber* nextID = [NSNumber numberWithLongLong:[sqliter nextLongLongInColumn:kMozCommonKeyID
                                                                                      inTable:@"moz_items_annos"
                                                                                 initialValue:1
                                                                                        error:&error_ ]] ;
                if (error_ != nil) {
                    goto endAfterSettingError ;
                }
                NSNumber* now = [[NSDate date] longLongMicrosecondsSince1970] ;
                NSInteger type = 3 ; // Pre-set to avoid exceptions
                if ([newContent isKindOfClass:[NSString class]]) {
                    type = 3 ;
                }
                else if ([newContent isKindOfClass:[NSNumber class]]) {
                    type = 1 ;
                }
                else {
                    NSLog(@"Internal Error 843-2870.  Attempt to insert in moz_items_annos unsupported content class: %@", [newContent class]) ;
                }
                NSNumber* typeNumber = [NSNumber numberWithInteger:type] ;
                NSArray* values = [NSArray arrayWithObjects:
                                   nextID,                              // id
                                   bookmarkID,                          // item_id
                                   mozBookmarksDescriptionAttributeID,  // anno_attribute_id
                                   newContent,                          // content
                                   [NSNumber numberWithInteger:0],      // flags
                                   [NSNumber numberWithInteger:4],      // expiration
                                   typeNumber,                          // type
                                   now,                                 // dateAdded
                                   [NSNumber numberWithLongLong:0],     // lastModified.  0 seems weird but this is what Firefox does
                                   nil] ;
                
                query  = [SSYSqliter queryInsertIntoTable:@"moz_items_annos"
                                                  columns:(NSArray*)columns
                                                   values:values] ;
            }
        }
        else if (mozContent == nil) {
            // Case 4.  newContent and mozContent are both nil.
            // Do nothing.
        }
        else {
            // Case 5.  newContent is nil but moz has a record.
            // Must remove moz record.
            query = [SSYSqliter queryDeleteFromTable:@"moz_items_annos"
                                         whereColumn:kMozItemsAnnosKeyBookmarkID
                                                isIn:[NSArray arrayWithObject:bookmarkID]] ;
        }
        
        // Run query if any was created
        if (query != nil) {
            [sqliter runQuery:query
                        error:&error_ ] ;
            if (error_ != nil) {
                error_ = [error_ errorByAddingUserInfoObject:[NSNumber numberWithInteger:7500]
                                                      forKey:@"Fine Code"] ;
                goto endAfterSettingError ;
            }
        }
        
    endAfterSettingError:
        if (error_ != nil) {
            [self setError:error_ ] ;
        }
    endWithoutSettingError:	
        ;
    }
}

/*!
 We need this method because, at least in Firefox 4.0 20110316,
 the database does *not* automatically assign an index, or as they call
 it, position, when a new item is inserted into a given parent.  It's
 completely dumb; even allows duplicate indices to be assigned.
*/
- (NSNumber*)nextPositionUnderMozBookmarksParentID:(NSNumber*)parentID {
	NSInteger position = 0 ;
	NSError* error_ = nil ;
	SSYSqliter* sqliter = [self sqliterError_p:&error_] ;
	if (!sqliter) {
		error_ = [error_ errorByAddingUserInfoObject:[NSNumber numberWithInteger:40015]
											  forKey:@"Fine Code"] ;
		goto endAfterSettingError ;
	}
	
	// DESC means give in descending order
	// LIMIT 1 means to only return the first record.
	NSString* query = [NSString stringWithFormat:@"SELECT %@ FROM moz_bookmarks WHERE %@=%@ ORDER BY %@ DESC LIMIT 1",
					   kMozBookmarksKeyPosition,
					   kMozBookmarksKeyParent,
					   [parentID stringEsquotedSQLValue],
					   kMozBookmarksKeyPosition] ;
	NSNumber* lastUsedPosition = [sqliter firstRowFromQuery:query
													  error:&error_ ] ;
	if (error_ != nil) {
		goto endAfterSettingError ;
	}
	if ([lastUsedPosition respondsToSelector:@selector(integerValue)]) {
		// Prior to BookMacster 1.11, above just checked that lastUsedPosition != nil.  Added defensive programming
		position = [lastUsedPosition integerValue] + 1 ;
	}
	
endAfterSettingError:
	if (error_ != nil) {
		[self setError:error_] ;
	}
	
	return [NSNumber numberWithInteger:position] ;
}	

- (void)incrementSyncChangeCounterBy:(NSInteger)increment
                               mozId:(NSNumber*)mozId {
    NSError* nonFatalError = nil;

    SSYSqliter* sqliter = [self sqliterError_p:&nonFatalError] ;

    if (sqliter && !nonFatalError) {
        NSString* query = [[NSString alloc] initWithFormat:
                           @"UPDATE %@ SET %@ = %@ + %ld WHERE %@ = %ld",
                           @"moz_bookmarks",
                           kMozBookmarksKeySyncChangeCounter,
                           kMozBookmarksKeySyncChangeCounter,
                           increment,
                           kMozCommonKeyID,
                           mozId.integerValue];
        [sqliter runQuery:query
                    error:&nonFatalError] ;
        [query release];
    }

    /* Updating syncChangeCounter is probably not that important – I didn't
     bother with it for the first Firefox version or two after they introduced
     it, but if it fails I want to know about this in development. */
    NSAssert(nonFatalError == nil, @"Internal Error 372-7571", nonFatalError);
}

- (BOOL)setVisitCount:(NSNumber*)visitCount
			   forUrl:(NSString*)url
			  error_p:(NSError**)error_p {
	BOOL ok = YES ;
	NSError* error = nil ;
	
	if (!visitCount) {
		visitCount = [NSNumber numberWithInteger:0] ;
	}

	NSString* query = [SSYSqliter queryUpdateTable:@"moz_places"
										   updates:[NSDictionary dictionaryWithObject:visitCount
																			   forKey:kMozPlacesKeyVisitCount]
									   whereColumn:kMozCommonKeyID
										whereValue:[self mozPlacesIDForURL:url]] ;
	SSYSqliter* sqliter = [self sqliterError_p:&error] ;
	if (!sqliter) {
		error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:40016]
											 forKey:@"Fine Code"] ;
		ok = NO ;
		goto end ;
	}
	[sqliter runQuery:query
				error:&error ] ;
	if (error != nil) {
		error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:1125]
											forKey:@"Fine Code"] ;
		ok = NO ;
		goto end ;
	}
	
end:
	if (error && error_p) {
		*error_p = error ;
	}
	
	return ok ;
}

// Added in BookMacster version 1.3.19.
- (NSNumber*)mozIdForBookmarkGuid:(NSString*)guid
						  error_p:(NSError**)error_p {
	NSString* query = [NSString stringWithFormat:@"SELECT %@ from moz_bookmarks WHERE %@=%@",
					   kMozCommonKeyID,	 
					   kMozBookmarksKeyGuid,
					   [guid stringEsquotedSQLValue]] ;
	SSYSqliter* sqliter = [self sqliterError_p:error_p] ;
	NSNumber* daId = nil ;
	if (sqliter) {
		daId = [sqliter firstRowFromQuery:query
									error:error_p] ;
	}
	
	return daId ;
}

- (BOOL)beginTransactionError_p:(NSError**)error_p {
	BOOL ok = YES ;
	NSError* error = nil ;
	SSYSqliter* sqliter = [self sqliterError_p:&error] ;
	if (!sqliter) {
		ok = NO ;
		goto end ;
	}

	[sqliter runQuery:@"BEGIN EXCLUSIVE"
				error:&error] ;
	if (error) {
		ok = NO ;
		goto end ;
	}
	
end:
	if (error && error_p) {
		*error_p = error ;
	}
	
	return ok ;
}

- (BOOL)endTransactionError_p:(NSError**)error_p {
	BOOL ok = YES ;
	NSError* error = nil ;
	SSYSqliter* sqliter = [self sqliterError_p:&error] ;
	if (!sqliter) {
		ok = NO ;
		goto end ;
	}
	
	[sqliter runQuery:@"COMMIT"
				error:&error ] ;
	if (error) {
		ok = NO ;
		goto end ;
	}
	
end:
	if (error && error_p) {
		*error_p = error ;
	}
	
	return ok ;
}

- (void)writeUsingStyle1InOperation:(SSYOperation*)operation {
	Exporter* exporter = [[operation info] objectForKey:constKeyIxporter] ;
	
	BOOL ok = YES ;
	NSError* error = nil ;
	[self setError:nil] ;

	NSMutableArray* starks = nil ;
	NSMutableDictionary* tagsByPlacesId = nil ;
    
    Clientoid* clientoid = self.clientoid;
	BkmxDoc* bkmxDoc = [[exporter client] bkmxDoc] ;
	SSYProgressView* progressView = [[bkmxDoc progressView] setIndeterminate:YES
               withLocalizableVerb:@"comparing"
                          priority:SSYProgressPriorityRegular] ;
	NSString* whatDoing = nil ;

	[self deleteLegacyBackups] ;
	[self forgetMozData] ;
	
    Stark* stark = nil ;

	SSYSqliter* sqliter = [self sqliterError_p:&error] ;
	if (!sqliter) {
		error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:40017]
											forKey:@"Fine Code"] ;
		goto endAfterSettingError ;
	}

	NSSet* mozItems ;
	NSSet* docItems ;
	NSString* query ; 

	ok = [self beginTransactionError_p:&error] ;
	if (!ok) {
		goto endAfterSettingError ;
	}
	
	whatDoing = [NSString localizeFormat:@"comparing%0", [NSString localize:@"050_FF3_Tags"]] ;
	whatDoing = [whatDoing stringByAppendingString:@" (1/8)"] ;
    progressView = [progressView setIndeterminate:YES
                                withLocalizedVerb:whatDoing
                                         priority:SSYProgressPriorityRegular] ;
	[progressView display] ;
	
	// Tags may be referenced by more than one bookmark, and should be deleted when they are no longer referenced
	// by any bookmarks.  The next few sections takes care of that.
	
	// Get tags from database
	query = [NSString stringWithFormat:@"SELECT %@ from moz_bookmarks WHERE %@=%@",
			 kMozBookmarksKeyName,
			 kMozBookmarksKeyParent,
			 [[self rootTagsMozBookmarksIndex] stringEsquotedSQLValue]] ;
	if ([self error] != nil) {
		goto endWithoutSettingError ;
	}
	mozItems = [NSSet setWithArray:[sqliter runQuery:query
											   error:&error ]] ;
	if (error != nil) {
		error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:280]
											forKey:@"Fine Code"] ;
		goto endAfterSettingError ;
	}
	
	// Get tags from document
	// We use setWithSet because -allTags returns a NSCountedSet,
	// which provides item 'counts' by having nonunique items.
	docItems = [NSSet setWithSet:[[self tagger] allTags]] ;
	
	NSMutableSet* deletions ;
	
	// Compare tags to get deletions, additions and changes.
	deletions = [NSMutableSet setWithSet:mozItems] ;
	[deletions minusSet:docItems] ;
	NSMutableSet* additions = [NSMutableSet setWithSet:docItems] ;
	[additions minusSet:mozItems] ;
	
	// Get the identifiers of all the tags to be deleted
	query = [NSString stringWithFormat:@"SELECT %@ from moz_bookmarks WHERE %@ IN %@ AND %@=%@",
			 kMozCommonKeyID,
			 kMozBookmarksKeyName,
			 [deletions  stringEsquotedSQLValue],
			 kMozBookmarksKeyParent,
			 [[self rootTagsMozBookmarksIndex] stringEsquotedSQLValue]] ;
	if ([self error] != nil) {
		goto endWithoutSettingError ;
	}
	NSArray* tagIDsToBeDeleted = [sqliter runQuery:query
											 error:&error ] ;
	if (error != nil) {
		error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:300]
											forKey:@"Fine Code"] ;
		goto endAfterSettingError ;
	}
	
	// Delete deleted tags in database
	query = [NSString stringWithFormat:@"DELETE from moz_bookmarks WHERE %@ IN %@",
			 kMozCommonKeyID,
			 [tagIDsToBeDeleted stringEsquotedSQLValue]] ;
	[sqliter runQuery:query
				error:&error ] ;
	if (error != nil) {
		error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:40018]
											forKey:@"Fine Code"] ;
		goto endAfterSettingError ;
	}
	
	// Delete all tag joiners associated with tags to be deleted
	query = [NSString stringWithFormat:@"DELETE from moz_bookmarks WHERE %@ IN %@",
			 kMozBookmarksKeyParent,
			 [tagIDsToBeDeleted  stringEsquotedSQLValue]] ;
	[sqliter runQuery:query
				error:&error ] ;
	if (error != nil) {
		error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:500]
											forKey:@"Fine Code"] ;
		goto endAfterSettingError ;
	}
	
	// Add added tags to database
	NSArray* columns = [ExtoreFirefox mozBookmarksColumns] ;
	
	NSNumber* now = [[NSDate date] longLongMicrosecondsSince1970] ;
	NSNumber* rootTagID = [self rootTagsMozBookmarksIndex] ;
	if ([self error] != nil) {
		goto endWithoutSettingError ;
	}
	NSMutableArray* values = [NSMutableArray arrayWithObjects:
							  [NSNull null],  // Database will automatically assign next id number
							  [NSNumber numberWithInteger:kMozBookmarksTypeFolder],
							  [NSNull null], // placeID/fk
							  rootTagID, // parent
							  [NSNull null], // will be replaced with position in loop below
							  [NSNull null], // will be replaced with name in loop below
							  [NSNull null], // folderType
							  now,
							  now,
							  [NSNull null], // guid.  But we don't use guid in tags, so we let it be NULL in our newly-inserted tag
							  nil] ;

	[progressView setMaxValue:[additions count]] ;
	[progressView setDoubleValue:1.0] ;
	whatDoing = [NSString localizeFormat:@"comparing%0", [NSString localize:@"000_Safari_Bookmarks"]] ;
	whatDoing = [whatDoing stringByAppendingString:@" (2/8)"] ;
	[progressView setVerb:whatDoing
					resize:YES] ;
	[progressView display] ;

	for (Tag* tag in [additions objectEnumerator]) {
		[values replaceObjectAtIndex:4
						  withObject:[self nextPositionUnderMozBookmarksParentID:rootTagID]] ;
		if ([self error] != nil) {
			goto endWithoutSettingError ;
		}
		[values replaceObjectAtIndex:5
						  withObject:tag.string] ;
		query = [SSYSqliter queryInsertIntoTable:@"moz_bookmarks"
										columns:columns
										 values:values] ;
		 
		[sqliter runQuery:query
					error:&error ] ;
		if (error != nil) {
			error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:600]
												forKey:@"Fine Code"] ;
			goto endAfterSettingError ;
		}
		
		[progressView incrementDoubleValueBy:1.0] ;
	}
	
	// Get existing raw moz_bookmarks
	NSMutableDictionary* rawMozBookmarks = [sqliter mutableDicFromTable:@"moz_bookmarks"
															  keyColumn:kMozCommonKeyID
																  error:&error ] ;
	if (error != nil) {
		error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:205103]
											forKey:@"Fine Code"] ;
		goto endAfterSettingError ;
	}

	// Filter rawMozBookmarks into Starks, Tag Folders and Tag Joiners.  (Ignore history items and other garbage in there.)
	NSMutableDictionary* mozBookmarkItems = [NSMutableDictionary dictionary] ;
	NSMutableDictionary* tagFolderIDs = [NSMutableDictionary dictionary] ;
	NSMutableSet* tagJoiners = [NSMutableSet set] ;

	[progressView setMaxValue:[rawMozBookmarks count]] ;
	[progressView setDoubleValue:1.0] ;
	whatDoing = [NSString localizeFormat:@"filtering", [NSString localize:@"items"]] ;
	whatDoing = [whatDoing stringByAppendingString:@" (4/8)"] ;
	[progressView setVerb:whatDoing
					resize:YES] ;
	[progressView display] ;

    for (NSNumber* key in rawMozBookmarks) {
		if (![key respondsToSelector:@selector(integerValue)]) {
			// Defense against corrupt Firefox bookmarks added in BookMacster 1.11
			NSLog(@"Warning 524-1897 Ignoring %@, not a number", key) ;
			continue ;
		}
		
		enum MozItemType mozItemType = [self mozItemTypeForID:key] ;
		if ([self error] != nil) {
			goto endWithoutSettingError ;
		}

		NSMutableDictionary* rowDic = [rawMozBookmarks objectForKey:key] ;
		switch(mozItemType) {
			case kMozItemTypeStark:;
				// It's a Stark (bookmark, folder, or separator)
				NSNumber* placesID = [rowDic objectForKey:kMozBookmarksKeyPlaceID] ;
				NSNumber* visitCountNumber = nil ;
				NSString* url = [self urlForMozPlacesID:placesID
									   visitCountNumber:&visitCountNumber] ;
				if ([self error] != nil) {
					goto endWithoutSettingError ;
				}
				
				if (url != nil) {
					[rowDic setObject:url
							   forKey:kMozPlacesKeyURL] ;
				}
				if (visitCountNumber != nil) {
					[rowDic setObject:visitCountNumber
							   forKey:kMozPlacesKeyVisitCount] ;
				}

				[mozBookmarkItems setObject:rowDic
                                     forKey:key] ;
				break ;
			case kMozItemTypeTag:;
				// Unpack the type
				NSNumber* mozBookmarksTypeNumber = [rowDic objectForKey:kMozBookmarksKeyType] ;
				if ([mozBookmarksTypeNumber respondsToSelector:@selector(integerValue)]) {
					NSInteger mozBookmarksType = [mozBookmarksTypeNumber integerValue] ;
					if (mozBookmarksType == kMozBookmarksTypeBookmark) {
						// It's a Tag Joiner
						[tagJoiners addObject:key] ;
					}
					else if (![key isEqual:[self rootTagsMozBookmarksIndex]]) {
						// (In the above, we disqualify the tag root itself)
						// It's a Tag Folder
						[tagFolderIDs setObject:key
										 forKey:[rowDic objectForKey:kMozBookmarksKeyName]] ;
					}
					if ([self error] != nil) {
						goto endWithoutSettingError ;
					}
				}
				break ;
			case kMozItemTypeMotherOfAllItems:
			case kMozItemTypeRootTags:
			case kMozItemTypeAllPlaces:
			case kMozItemTypeHistoryOrStrawRootTags:
			case kMozItemTypeAllBookmarks:
			case kMozItemTypeStrawMan:
				break ;
			default:;
				// Fix added in BookMacster 1.2.5.  This is some kind
				// of orphaned, corrupt item.  I've seen items whose parent
				// is themselves; also items who are direct descendants
				// of the Mother of All Items.  Most importantly, these items
				// may have identifiers (id) which have now been re-used by
				// BookMacster for new items or fixing items with duplicate
				// exids.  So, when these items are inserted, sqlite will
				// raise sqlite error SQLITE_CONSTRAINT = 19 and user will 
				// get SSYSqliterErrorDomain error 453009 with FineCode = 1300.
				// To eliminate this problem, we delete the item now.
				// (Actually, the sqlite error will no longer occur in
				// BookMacster version 1.3.19 or later, since we now use
				// guid.  But we still delete the corrupt item anyhow.)
				NSString* query = [SSYSqliter queryDeleteFromTable:@"moz_bookmarks"
													   whereColumn:kMozCommonKeyID
															  isIn:[NSArray arrayWithObject:key]] ;
				[sqliter runQuery:query
							error:&error] ;
				if (error != nil) {
					error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:1000]
														  forKey:@"Fine Code"] ;
					goto endAfterSettingError ;
				}
		}
		
		[progressView incrementDoubleValueBy:1.0] ;
	}
	
	// Defensive programming against having a stale cache
	[self setParentsCached:nil] ;

	// Get Starks from Starker (which were synced from BkmxDoc)
	starks = [[[self starker] allStarks] mutableCopy] ;
	// Remove the root, since it does not have any properties BookMacster can change.
	// (Recall that we also removed the root from rawMozBookmarks.)  The idea is that
	// we do not touch compare, change, delete or add the "All Bookmarks" root
	// in the database.  We just want to leave it as is in the database.
	[starks removeObject:[[self starker] root]] ;
		
	// This next loop loops through document's starks and
	//   - When changed items are found, updates the database to reflect changes.
	//   - Removes matched bookmarks (whether changed or not) from mozBookmarkItems, so
	//        that upon completion mozBookmarkItems will contain only items which must be
	//        removed from the database
	//   - Insert items not found into the database.

	// Sort the starks so that parents will be inserted before
	// their children.  We need this so that parents will have an
	// id in moz_bookmarks so we can assign their 'parent' in
	// moz_bookmarks.
	// (This was added in BookMacster 1.3.19.)
	// Note: -compare: is implemented by Apple in NSNumber
	NSSortDescriptor* descriptor1 = [[NSSortDescriptor alloc] initWithKey:@"lineageDepthObject"
																ascending:YES] ;
	NSArray* descriptors = [NSArray arrayWithObjects:descriptor1, nil] ;
	[descriptor1 release] ;
	[starks sortUsingDescriptors:descriptors] ;

	[progressView setMaxValue:[starks count]] ;
	[progressView setDoubleValue:1.0] ;
	whatDoing = [NSString localizeFormat:@"updatingX", [NSString localize:@"000_Safari_Bookmarks"]] ;
	whatDoing = [whatDoing stringByAppendingString:@" (5/8)"] ;
	[progressView setVerb:whatDoing
					resize:YES] ;
	[progressView display] ;

    /* For best performance, we pre-populate this cache with the following
     call, which performs only one query on places.sqlite.  See declaration of
     m_mozPlacesForUrlCache for performance comparison. */
    m_mozPlacesForUrlCache = [[sqliter dicForAttribute:kMozCommonKeyID
                                                   key:kMozPlacesKeyURL
                                                 table:@"moz_places"
                                                 error:&error] mutableCopy];
    if (error != nil) {
        error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:205111]
                                            forKey:@"Fine Code"] ;
        goto endAfterSettingError ;
    }

	// It is OK to enumerate starks because we are not going to modify it.
	// We only modify mozBookmarkItems.
	for (stark in starks) {
		NSNumber* identifier = [self mozIdForBookmarkGuid:[stark exidForClientoid:clientoid]
												  error_p:&error] ;
		// If stark is a new item which needs to be inserted, 'identifier' will be nil.
		if (error) {
			error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:205105]
												forKey:@"Fine Code"] ;
			goto endAfterSettingError ;
		}

		id mozBookmarkItem = [mozBookmarkItems objectForKey:identifier] ;
		if ([self error] != nil) {
			goto endWithoutSettingError ;
		}

		if (mozBookmarkItem != nil) {
			// This is an update to an existing item

			// Don't compare permanent hartainers, since there will be differences
			// but they are all irrelevant since these are not "real" items...
			BOOL isHartainer = [stark isHartainer] ;
			if ([self error] != nil) {
				goto endWithoutSettingError ;
			}
			if (!isHartainer) {
				id mozValue ;
				
				// Compare type (sharype)
				BOOL matchSharype = YES ;
				mozValue = [mozBookmarkItem objectForKey:kMozBookmarksKeyType] ;
				if (![mozValue respondsToSelector:@selector(integerValue)]) {
					// Defense against corrupt Firefox bookmarks added in BookMacster 1.11
					NSLog(@"Warning 524-1893 Ignoring %@, not a number", mozValue) ;
					continue ;
				}
				
				NSInteger mozType = [mozValue integerValue] ;
				Sharype docSharype = [stark sharypeValue] ;
				if (mozType != [ExtoreFirefox mozBookmarksTypeForSharype:docSharype]) {
					matchSharype = NO ;
				}
				
				Stark* docParent = [stark parent] ;
				
				// Compare parents
				BOOL matchParent = YES ;
				mozValue = [mozBookmarkItem objectForKey:kMozBookmarksKeyParent] ;
				
				NSNumber* docParentId = [self mozIdForBookmarkGuid:[docParent exidForClientoid:clientoid]
														   error_p:&error] ;
                /* docParentId will be nil for the no-name "All Places" bookmark
                 whose id is typically 6-9, and somehow represents the parent
                 of the root items in the "Library" you get when you click
                 Firefox' menu Bookmarks > Show All Bookmarks. */
				
				if (error) {
					error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:205107]
														forKey:@"Fine Code"] ;
					goto endAfterSettingError ;
				}
				if (!identifier) {
					NSLog(@"Internal Error 768-7485 %@", [docParent shortDescription]) ;
				}
				// End of changes for BookMacter version 1.3.19
				long long longLongdocParentId = NSNotFound ;
				if (([mozValue respondsToSelector:@selector(longLongValue)])  && (docParentId != nil)) {
					longLongdocParentId = [docParentId longLongValue] ;
					if ([mozValue longLongValue] != longLongdocParentId) {
						matchParent = NO ;
					}
				}
				
				// Compare positions
				BOOL matchPosition = YES ;
				mozValue = [mozBookmarkItem objectForKey:kMozBookmarksKeyPosition] ;
				if (![mozValue respondsToSelector:@selector(integerValue)]) {
					// Defense against corrupt Firefox bookmarks added in BookMacster 1.11
					NSLog(@"Warning 524-1895 Ignoring %@, not a number", mozValue) ;
					continue ;
				}
				
				NSInteger docPosition = [stark indexValue] ;
				if ([mozValue integerValue] != docPosition) {
					matchPosition = NO ;
				}
				
				// Compare names
				BOOL matchName = YES ;
				mozValue = [mozBookmarkItem objectForKey:kMozBookmarksKeyName] ;
				NSString* docName = [stark nameNoNil] ;
				if ([stark sharypeValue] != SharypeSeparator) {
                    if ([mozValue respondsToSelector:@selector(isEqualToString:)]) {
                        if (![mozValue isEqualToString:docName]) {
                            matchName = NO ;
                        }
                    }
                    else {
                        /* This will occur in the case of the three shadow
                         hard folders which appear after the Show All Bookmarks
                         "Library" window is shown once in Firefox.  These are
                         the items whose fk URLs are moz_places items with the
                         following URLs:
                         * place:folder=TOOLBAR
                         * place:folder=BOOKMARKS_MENU
                         * place:folder=UNFILED_BOOKMARKS
                         In these three cases, the `title` value in
                         places.sqlite is NULL and mozValue will be either
                         NSNull or nil (I've seen it both ways!).  The
                         appropriate action is to just let it go by … */
                    }
				}
				
				// Compare url
				BOOL matchURL = NO ;
				mozValue = [mozBookmarkItem objectForKey:kMozPlacesKeyURL] ;
				NSString* docURL = [stark url] ; // Was FirefoxHack
				if ((mozValue == nil) && (docURL == nil)) {
					matchURL = YES ;
				}
				else if (![mozValue isKindOfClass:[NSString class]]) {
					// Will be NSNull in a corrupt bookmarks database,
					// if the 'url' key in a moz_places record is NULL.
					// which will raise an exception if sent -isEqualToString.
					// Also, the 'url' key in a moz_places record is NULL, I believe
					// that would be a database corruption.  So, I'm declaring it
					// as no match so that record in the database will be updated.
					matchURL = NO ;
					
					// The following test was added in Bookdog 5.1.45
					if (!docURL) {
						NSLog(@"Warning 597-6584.  Nil URL for %@", [stark description]) ;
						docURL = @"" ;
					}
				}
				else if ([mozValue isEqualToString:docURL]) {
					matchURL = YES ;
				}
				else {
					if (docURL == nil) {
						matchURL = YES ;
					}
				}
				
				// Compare visitCount
				// This was added in BookMacster 1.3.19
				BOOL matchVisitCount = YES ;
				mozValue = [mozBookmarkItem objectForKey:kMozPlacesKeyVisitCount] ;
				NSNumber* docVisitCount = [stark ownerValueForKey:constKeyVisitCount] ;
				if ([mozValue integerValue] != [docVisitCount integerValue]) {
					matchVisitCount = NO ;
				}
				
				// Since these are trivialAttributes, I skip comparing them…
				// Compare addDate
				// Compare lastModifiedDate
				
				// Summmarize
				BOOL matchAllInMozBookmarks
				=  matchSharype
				&& matchParent
				&& matchPosition
				&& matchName
				&& matchURL
				&& matchVisitCount ;
				
				// Update moz_bookmarks if any changes
				if (!matchAllInMozBookmarks) {
					NSMutableDictionary* updates = [NSMutableDictionary dictionary] ;
					if (!matchSharype) {
						NSInteger type = [ExtoreFirefox mozBookmarksTypeForSharype:docSharype] ;
						[updates setObject:[NSNumber numberWithInteger:type]
									forKey:kMozBookmarksKeyType] ;
					}
					if (!matchParent && (longLongdocParentId != NSNotFound)) {
						[updates setObject:[NSNumber numberWithLongLong:longLongdocParentId]
									forKey:kMozBookmarksKeyParent] ;
					}
					if (!matchPosition) {
						[updates setObject:[NSNumber numberWithInteger:docPosition]
									forKey:kMozBookmarksKeyPosition] ;
					}
					if (!matchName) {
						[updates setObject:docName
									forKey:kMozBookmarksKeyName] ;
					}
                    /* Note: -mozPlacesIDForURL: will insert a row in
                     moz_places if one does not already exist for docUrl. */
                    NSNumber* placesID = [self mozPlacesIDForURL:docURL];
					if (!matchURL) {
						// The following test was added in Bookdog 5.1.45
						if (!docURL) {
							NSLog(@"Warning 597-6251.  Nil URL for %@", [stark description]) ;
							docURL = @"" ;
						}

						[updates setValue:placesID
								   forKey:kMozBookmarksKeyPlaceID] ;
						if ([self error] != nil) {
							goto endWithoutSettingError ;
						}
					}

					// Update any stuff in moz_bookmarks
					if ([updates count] > 0) {
						query = [SSYSqliter queryUpdateTable:@"moz_bookmarks"
													 updates:updates
												 whereColumn:kMozCommonKeyID
												  whereValue:identifier] ;
						[sqliter runQuery:query
									error:&error] ;
						if (error != nil) {
							error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:1115]
																forKey:@"Fine Code"] ;
							goto endAfterSettingError ;
						}

                        [self incrementSyncChangeCounterBy:updates.count
                                                     mozId:identifier];
 					}

					// Update visit_count in moz_places
					// Added in BookMacster version 1.3.19
					if (!matchVisitCount && docURL) {
						ok = [self setVisitCount:docVisitCount
										  forUrl:docURL
										 error_p:&error] ;
						if (!ok) {
							goto endAfterSettingError ;
						}
					}
					
				}
				
				// Update comments and livemarkURI
				// These are handled separately because they are in a different table, and
				// because they are one:one with bookmarks, are changed when
				// edited in Places Organizer, and are deleted when bookmarks are deleted.
				[self updateMozAnnosSetContent:[stark comments]
								annotationName:kMozAnnoAttributeNameBookmarkDescription
									bookmarkID:identifier] ;
				if ([self error] != nil) {
					goto endWithoutSettingError ;
				}
				if ([stark sharypeValue] == SharypeLiveRSS) {
					[self updateMozAnnosSetContent:[stark url]
									annotationName:kMozAnnoAttributeNameLivemarkURI
										bookmarkID:identifier] ;
				}
				if ([self error] != nil) {
					goto endWithoutSettingError ;
				}
			}				
			[mozBookmarkItems removeObjectForKey:identifier] ;
		}
		else {
			// This is a new item to be inserted

			NSMutableArray* columns = [[NSMutableArray alloc] init] ;
			NSMutableArray* values = [[NSMutableArray alloc] init] ;
			
			BOOL testedOkUnique = NO ;
			NSString* guid ;
			do {
				// If this stark had previously been in this Firefox profile,
				// it will have an exid (guid) for this Firefox profile.
				// It seems that this might be better for Firefox Sync
				// and other apps, if we re-used the old guid.  So that's
				// what we do here.  I'm not sure if this is the correct
				// decision, but likely it doesn't make much difference,
				// except for some corner case which will bite one day.
				// But it's all I can do for now.
				guid = [stark exidForClientoid:clientoid] ;
				if (!guid) {
					// This is normal
					[stark setFreshExidForExtore:self
										 tryHard:YES] ;
					// The above only sets it for the ivar.  So, we need this:
					[stark setExid:[stark exid]
					  forClientoid:clientoid] ;
					guid = [stark exid] ;
				}
				else {
					// This is rare, but can happen, as described above.
				}
				
				// The following section was added in BookMacster version 1.3.19.
				// Since this is a new item, we don't expect it to be in the
				// moz_bookmarks database, but let's look anyhow.
				NSNumber* unexpectedId = [self mozIdForBookmarkGuid:[stark exidForClientoid:clientoid]
															error_p:&error] ;
				if (error) {
					error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:205109]
														forKey:@"Fine Code"] ;
					NSLog(@"%@", error) ;
					break ;
				}
				
				if (unexpectedId) {
					NSLog(@"Guid %@ of new item %@ already in use by id=%@.  Will try fresh guid.", guid, [stark shortDescription], unexpectedId) ;
					[stark setExid:nil
					  forClientoid:clientoid] ;
					testedOkUnique = NO ;
				}
				else {
					testedOkUnique = YES ;
				}
			} while (!testedOkUnique) ;
			
			if (error) {
				[columns release] ;
				[values release] ;
				error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:205110]
													forKey:@"Fine Code"] ;
				goto endAfterSettingError ;
			}
			
			Stark* parent = [stark parent] ;
			Sharype sharype = [stark sharypeValue] ;
			NSNumber* parentIdentifier = [self mozIdForBookmarkGuid:[parent exidForClientoid:clientoid]
															error_p:&error] ;
			if (error) {
				[columns release] ;
				[values release] ;
				error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:205112]
													forKey:@"Fine Code"] ;
				goto endAfterSettingError ;
			}
			
			// Because we sorted starks by lineageDepth, parentIdentifier cannot
			// not be nil.  And if it is, we're going to create an orphan.
			if (!parentIdentifier) {
                [columns release] ;
                [values release] ;
				NSLog(@"Internal Error 254-1922.  Skipping parentless %@", [stark shortDescription]) ;
				continue ;
			}
			
			id value ;
			
			// type/sharype
			[columns addObject:kMozBookmarksKeyType] ;
			[values addObject:[NSNumber numberWithInteger:[ExtoreFirefox mozBookmarksTypeForSharype:sharype]]] ;
			
			// guid
			[columns addObject:kMozBookmarksKeyGuid] ;
			[values addObject:guid] ;
			
			// parent/parent
			[columns addObject:kMozBookmarksKeyParent] ;
			[values addObject:parentIdentifier] ;
			
			// position
			[columns addObject:kMozBookmarksKeyPosition] ;
			[values addObject:[stark index]] ;
			
			// title/name
			if (sharype != SharypeSeparator) {
				value = [stark name] ;
				if (value != nil) {
					[columns addObject:kMozBookmarksKeyName] ;
					[values addObject:value] ;
				}
			}

			// url
			value = [stark url] ;  // Was FirefoxHack
			if (value != nil) {
				[columns addObject:kMozBookmarksKeyPlaceID] ;
                NSNumber* placeID = [self mozPlacesIDForURL:value];
				[values addObject:placeID] ;
				if ([self error] != nil) {
					[columns release] ;
					[values release] ;
					goto endWithoutSettingError ;
				}

            }
			
			// dateAdded/addDate
			[columns addObject:kMozCommonKeyAddDate] ;
			[values addObject:now] ;
			
			// lastModified/lastModifiedDate
			[columns addObject:kMozCommonKeyLastModifiedDate] ;
			[values addObject:now] ;
			
			// Assemble, clean up, and run the query
			query  = [SSYSqliter queryInsertIntoTable:@"moz_bookmarks"
											  columns:(NSArray*)columns
											   values:values] ;
			[sqliter runQuery:query
						error:&error] ;
			
			[columns release] ;
			[values release] ;
			if (error) {
				error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:1300]
													forKey:@"Fine Code"] ;
				goto endAfterSettingError ;
			}
			
            // Because the parent has just had a child added,
            [self incrementSyncChangeCounterBy:1
                                         mozId:parentIdentifier];

            NSNumber* identifier = [self mozIdForBookmarkGuid:guid
													  error_p:&error] ;
			if (error) {
				error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:205227]
													forKey:@"Fine Code"] ;
				goto endAfterSettingError ;
			}
			
			// Update comments and livemarkURI
			// These are handled separately because they are in a different table, and
			// because they are one:one with bookmarks, are changed when
			// edited in Places Organizer, and are deleted when bookmarks are deleted.
			[self updateMozAnnosSetContent:[stark comments]
							annotationName:kMozAnnoAttributeNameBookmarkDescription
								bookmarkID:identifier] ;
			if ([self error] != nil) {
				goto endWithoutSettingError ;
			}
			if ([stark sharypeValue] == SharypeLiveRSS) {
				[self updateMozAnnosSetContent:[stark url]
								annotationName:kMozAnnoAttributeNameLivemarkURI
									bookmarkID:identifier] ;
				if ([self error] != nil) {
					goto endWithoutSettingError ;
				}
			}
			
			ok = [self setVisitCount:[stark ownerValueForKey:constKeyVisitCount]
							  forUrl:[stark url]
							 error_p:&error] ;
			if (!ok) {
				goto endAfterSettingError ;
			}
		}
		
		[progressView incrementDoubleValueBy:1.0] ;
	}
	// So that the last stark does not become part of any later NSError userInfo:
	stark = nil ;
	
	
	/* In the next two sections, DeletePartA and DeletePartB, take care of deleting
     bookmarks which were deleted in document */
	// mozBookmarkItems now contains only those which were not matched to document starks.
	whatDoing = [NSString localizeFormat:@"deleting%0", [NSString localizeFormat:@"deleted%0", [NSString localize:@"000_Safari_Bookmarks"]]] ;
	whatDoing = [whatDoing stringByAppendingString:@" (6/8)"] ;
    progressView = [progressView setIndeterminate:YES
                                withLocalizedVerb:whatDoing
                                         priority:SSYProgressPriorityRegular] ;

    /* DeletePartA here increments the syncChangeCounter of the parent for each
     deleted child.  Note that, now, mozBookmarkItems contains only the deleted
     items.  Also, note that although this can be done with only one SQLite query
     (a "correlated subquery"), as this code was between May 2017 and January
     2018, performance was horrible – a collection of 20K bookmarks sent to me
     by a user took 5 hours to export to Firefox. */
    NSArray* deletedMozIds = [mozBookmarkItems allKeys];
    NSCountedSet* deleteCounts = [NSCountedSet new];
    for (NSNumber* key in mozBookmarkItems) {
        NSDictionary* dic = [mozBookmarkItems objectForKey:key];
        NSNumber* parentMozId = [dic objectForKey:kMozBookmarksKeyParent];
        [deleteCounts addObject:parentMozId];
    }
    NSError* nonFatalError = nil;
    for (NSNumber* parentMozId in deleteCounts) {
        NSInteger changeCount = [deleteCounts countForObject:parentMozId];
        query = [[NSString alloc] initWithFormat:
                 @"UPDATE moz_bookmarks"
                 @"  SET %@ = %@ + %ld"
                 @"    WHERE %@ = %@",
                 kMozBookmarksKeySyncChangeCounter,
                 kMozBookmarksKeySyncChangeCounter,
                 changeCount,
                 kMozCommonKeyID,
                 parentMozId
                 ];
        [sqliter runQuery:query
                    error:&nonFatalError] ;
        /* Updating syncChangeCounter is probably not that important – I didn't
         bother with it for the first Firefox version or two after they introduced
         it, but if it fails I want to know about this in development. */
        NSAssert(nonFatalError == nil, @"Internal Error 372-7849", nonFatalError);
        [query release];
    }
    [deleteCounts release];

    /* DeletePartB here does the actual deleting. */
    query = [SSYSqliter queryDeleteFromTable:@"moz_bookmarks"
								whereColumn:kMozCommonKeyID
									   isIn:deletedMozIds] ;
	[sqliter runQuery:query
				error:&error ] ;
	if (error != nil) {
		error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:1100]
											forKey:@"Fine Code"] ;
		goto endAfterSettingError ;
	}

    // Since annotations are associated one:one with bookmarks, we also go through
	// and delete any annotations associated with the deleted bookmarks.
	query = [SSYSqliter queryDeleteFromTable:@"moz_items_annos"
								whereColumn:kMozItemsAnnosKeyBookmarkID
									   isIn:[mozBookmarkItems allKeys]] ;
    // query can be nil if.
	[sqliter runQuery:query
				error:&error ] ;
	if (error != nil) {
		error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:1200]
											forKey:@"Fine Code"] ;
		goto endAfterSettingError ;
	}
	// Note that we do not delete the tagJoiners associated with this bookmark,
	// because the association is indirect, through a moz_place.  There could be
	// other bookmarks associated with this moz_place and hence the tagJoiner.
	
	

	// Now that all the Tags are in place, AND all the Starks are in place,
	// I can update the tagJoiners (which join the two).

	// First, delete all the tag joiners.  We're going to re-insert all from scratch.
	query = [SSYSqliter queryDeleteFromTable:@"moz_bookmarks"
								 whereColumn:kMozCommonKeyID
										isIn:tagJoiners] ;
    // query can be nil of 'tagJoiners' is empty.
    [sqliter runQuery:query
				error:&error ] ;
	if (error != nil) {
		error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:1350]
											  forKey:@"Fine Code"] ;
		goto endAfterSettingError ;
	}

	// The following two sections, "Registering tags" and "Joining tags", were one
	// section prior to BookMacster 1.11, wherein there was a bug which caused
	// each bookmark in a duplicate group of N to have N tags to each tag.
	
	// Second, register all tags by URL (place) into tagsByPlacesId,
	// a dictionary of sets.
	[progressView setMaxValue:[starks count]] ;
	[progressView setDoubleValue:1.0] ;
	whatDoing = @"Registering tags (7/8)" ;
	[progressView setVerb:whatDoing
					resize:YES] ;
	[progressView display] ;	
	tagsByPlacesId = [[NSMutableDictionary alloc] init] ;
	for (stark in starks) {
		NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
        NSArray* tags = [[stark tags] valueForKey:constKeyString];
		if ([tags count] > 0) {
			NSNumber* placesID = [self mozPlacesIDForURL:[stark url]] ;
			if ([self error] != nil) {
				[error retain] ;
				[pool release] ;
				[error autorelease] ;
				goto endWithoutSettingError ;
			}
			
			NSMutableSet* registeredTags = [tagsByPlacesId objectForKey:placesID] ;
			if (!registeredTags) {
				registeredTags = [NSMutableSet set] ;
				[tagsByPlacesId setObject:registeredTags
								   forKey:placesID] ;
			}
			[registeredTags addObjectsFromArray:tags] ;
		}
		
		[progressView incrementDoubleValueBy:1.0] ;
		[pool release] ;
	}
	
	// Third, create tag joiners from the tagsByPlacesId dictionary
	[progressView setMaxValue:[tagsByPlacesId count]] ;
	[progressView setDoubleValue:1.0] ;
	whatDoing = @"Joining tags (8/8)" ;
	[progressView setVerb:whatDoing
				   resize:YES] ;
	[progressView display] ;	
	NSArray* newTagJoinerColumns = [NSArray arrayWithObjects:
									kMozCommonKeyID,
									kMozBookmarksKeyType,
									kMozBookmarksKeyPlaceID,
									kMozBookmarksKeyParent,
									kMozBookmarksKeyPosition,
									kMozCommonKeyAddDate,
                                    kMozCommonKeyLastModifiedDate,
									nil] ;
    // Sorting added in BookMacster 1.12.4 so that automated tests which require
    // repeatable results, like IxportRegressionTest, Case 5, might give
    // passing results.
    NSMutableArray* tagPlacesIds = [[NSMutableArray alloc] initWithArray:[tagsByPlacesId allKeys]] ;
    [tagPlacesIds sortUsingSelector:@selector(compare:)] ;
    for (NSNumber* placesId in tagPlacesIds) {
		NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
		
		NSSet* tags = [tagsByPlacesId objectForKey:placesId] ;
		for (NSString* tag in tags) {
			NSNumber* nextMozBookmarkID = [NSNumber numberWithLongLong:[sqliter nextLongLongInColumn:kMozCommonKeyID
																							 inTable:@"moz_bookmarks"
																						initialValue:1
																							   error:&error ]] ;
			if (error != nil) {
				error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:205114]
													forKey:@"Fine Code"] ;
				[error retain] ;
				[pool release] ;
				[error autorelease] ;
                [tagPlacesIds release] ;
				goto endAfterSettingError ;
			}
			NSNumber* tagFolderID = [tagFolderIDs objectForKey:tag];
			
            if (!tagFolderID) {
                NSLog(@"Warning 648-0671 Maybe a tagged folder? No tagJoiner for %@ with %@", stark, values) ;
            } else {
                // Have to do a query to find out what is the next available position under this tag.
                // This is really stupid.  Why does Mozilla order the tagged bookmarks of a tag?
                NSNumber* tagFolderPosition = [self nextPositionUnderMozBookmarksParentID:tagFolderID] ;
                if ([self error] != nil) {
                    [error retain] ;
                    [pool release] ;
                    [error autorelease] ;
                    [tagPlacesIds release] ;
                    goto endWithoutSettingError ;
                }
                
                NSArray* values = [NSArray arrayWithObjects:
                                   nextMozBookmarkID,
                                   [NSNumber numberWithInteger:kMozBookmarksTypeBookmark],
                                   placesId,
                                   tagFolderID,
                                   tagFolderPosition,
                                   now,
                                   now,
                                   nil] ;
                query = [SSYSqliter queryInsertIntoTable:@"moz_bookmarks"
                                                 columns:newTagJoinerColumns
                                                  values:values] ;
                [sqliter runQuery:query
                            error:&error ] ;
                if (error != nil) {
                    error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:1400]
                                                        forKey:@"Fine Code"] ;
                    [error retain] ;
                    [pool release] ;
                    [error autorelease] ;
                    [tagPlacesIds release] ;
                    goto endAfterSettingError ;
                }
            }
        }
		[progressView incrementDoubleValueBy:1.0] ;
		[pool release] ;
	}
    [tagPlacesIds release] ;
	
	whatDoing = [NSString localize:@"processing"] ;
	[progressView setIndeterminate:YES
                 withLocalizedVerb:whatDoing
                          priority:SSYProgressPriorityRegular] ;

endAfterSettingError:
	if (error != nil) {
		[self setError:error ] ;
	}
	
endWithoutSettingError:
	[starks release] ;
	[tagsByPlacesId release] ;
    [m_mozPlacesForUrlCache release]; m_mozPlacesForUrlCache = nil;
	
	// Note that we do this even if there was an error, because if we leave
	// the the transaction hanging open, subsequent attempts at save will
	// not be allowed by sqlite and will give SQL error "Cannot begin transaction
	// within transaction", even if the original error has been corrected.
	ok = [self endTransactionError_p:&error] ;
	if (!ok) {
		[self setError:error] ;
	}
	
	[self improveErrorWithCurrentStark:stark] ;
	
	[operation writeAndDeleteDidSucceed:(![self error])] ;
}

- (void)writeUsingStyle2InOperation:(SSYOperation*)operation {
	[self exportJsonViaIpcForOperation:operation] ;
}

+ (BOOL)liveRssAreImmutable {
    return YES ;
}

+ (BOOL)canProbablyImportFileType:type
								  data:data {
	if (![type isEqualToString:@"sqlite"]) {
		return NO ;
	}
	
	// Very cheesy detection method
	NSString* s = [[NSString alloc] initWithData:data
										encoding:NSASCIIStringEncoding] ; // ASCII will not fail
	if ([s rangeOfString:@"moz_bookmarks"].location != NSNotFound) {
		if ([s rangeOfString:@"moz_places"].location != NSNotFound) {
			[s release] ;
			return YES ;
		}
	}
	
	[s release] ;
	return NO ;
}

- (NSNumber*)insertIntoMozTablesPlaceForRootName:(NSString*)rootName
										   title:(NSString*)title
								   overridePlace:(NSString*)overridePlace
							 placesOrganizerName:(NSString*)placesOrganizerName
										parentID:(NSNumber*)parentID {
	if (!parentID) {
		[self setError:SSYMakeError(204982, @"Internal Error")] ;
		return nil ;
	}

	NSError* error = nil ;
	NSNumber* subjectID = nil ;
    
	SSYSqliter* sqliter = [self sqliterError_p:&error] ;
	if (!sqliter) {
		error = [error errorByAddingUserInfoObject:[NSNumber numberWithInt:40019]
											forKey:@"Fine Code"] ;
		goto endAfterSettingError ;
	}
	
	NSString* place ;
	if (overridePlace == nil) {
		place = [NSString stringWithFormat:@"folder=%ld",
				 (long)[[self mozBookmarksIndexOfRootName:rootName] integerValue]] ;
		if ([self error] != nil) {
			goto endWithoutSettingError ;
		}
	}
	else {
		place = overridePlace ;
	}
	NSString* url = [@"place:" stringByAppendingString:place] ;
	
	id titleThing ;
	if (title == nil) {
		titleThing = [NSNull null] ;
	}
	else {
		titleThing = title ;
	}
	
	NSString* guid ;
	[self getFreshExid_p:&guid
			  higherThan:0
				forStark:nil
				 tryHard:YES] ;
	
    NSNumber* now = [NSDate longLongMicrosecondsSince1970];
    NSArray* values = [NSArray arrayWithObjects:
					   [NSNull null],  // Database will automatically assign next id number
					   [NSNumber numberWithInteger:kMozBookmarksTypeBookmark],
					   // The following line will create a place in moz_places
					   [self mozPlacesIDForURL:url],  
					   parentID,
					   [self nextPositionUnderMozBookmarksParentID:parentID],
					   titleThing,
					   [NSNull null],
					   now,
					   now,
					   guid,
					   nil] ;	
	if ([self error] != nil) {
		goto endWithoutSettingError ;
	}
	NSString* query = [SSYSqliter queryInsertIntoTable:@"moz_bookmarks"
											   columns:[ExtoreFirefox mozBookmarksColumns]
												values:values] ;
	[sqliter runQuery:query
				error:&error ] ;
	if (error != nil) {
		error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:9000]
											  forKey:@"Fine Code"] ;
		goto endAfterSettingError ;
	}
	
	// Get the 'id' which the database assigned to the newly-inserted item
	subjectID = [self mozIdForBookmarkGuid:guid
                                   error_p:&error] ;
	if (error != nil) {
		SSYAddMethodNameInError(error)
		error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:209000]
											forKey:@"Fine Code"] ;
		goto endAfterSettingError ;
	}
	
	// Make sure that there exists a moz_item_anno identifying this root, and that it is owned by this root
	NSNumber* placesOrganizerAttributeID = [self attributeIDForAnnotationName:kMozAnnoAttributeNamePlacesOrganizerQuery] ;
	if ([self error] != nil) {
		goto endWithoutSettingError ;
	}
	query = [NSString stringWithFormat:@"SELECT %@ from moz_items_annos WHERE %@=%@ AND %@=%@",
			 kMozCommonKeyID,	 
			 kMozItemsAnnosKeyAttributeID,
			 [placesOrganizerAttributeID  stringEsquotedSQLValue],
			 kMozItemsAnnosKeyContent,
			 [placesOrganizerName stringEsquotedSQLValue]] ;
	NSNumber* itemAnnoIDAllBookmarks = [sqliter firstRowFromQuery:query
															error:&error ] ;
	if (error != nil) {
		goto endAfterSettingError ;
	}
	if (itemAnnoIDAllBookmarks != nil) {
		// Record identifying this root already exists.
		// Just update it to make our new root its owner
		query = [NSString stringWithFormat:@"UPDATE moz_items_annos SET %@=%@ WHERE %@=%@",
				 kMozItemsAnnosKeyBookmarkID,
				 [subjectID stringEsquotedSQLValue],
				 kMozCommonKeyID,
				 [itemAnnoIDAllBookmarks stringEsquotedSQLValue]] ;
	}
	else {
		// Does not exist.  Insert a new record from scratch
		values = [NSArray arrayWithObjects:
				  [NSNumber numberWithLongLong:[sqliter nextLongLongInColumn:kMozCommonKeyID
																	 inTable:@"moz_items_annos"
																initialValue:1
																	   error:&error ]],
				  subjectID,
				  placesOrganizerAttributeID,
				  placesOrganizerName,  // content
				  [NSNumber numberWithInteger:0],  // flags
				  [NSNumber numberWithInteger:4],  // expiration
				  [NSNumber numberWithInteger:3],  // type (1=Boolean)
				  [NSDate longLongMicrosecondsSince1970], // dateAdded
				  [NSNumber numberWithInteger:0],
				  nil] ; // lastModified (0=never modified)
		if (error != nil) {
			goto endAfterSettingError ;
		}
		query = [SSYSqliter queryInsertIntoTable:@"moz_items_annos"
										 columns:[ExtoreFirefox mozItemsAnnosColumns]
										  values:values] ;
	}
	[sqliter runQuery:query
				error:&error ] ;
	if (error != nil) {
		error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:10000]
											  forKey:@"Fine Code"] ;
		goto endAfterSettingError ;
	}
	
endAfterSettingError:
	if (error != nil) {
		[self setError:error ] ;
	}
	
endWithoutSettingError:
	return subjectID ;
}	

/*
 This method and the preceding one are my attempts to repair a Firefox bookmarks
 file which exhibits the "empty Library" problem.  (Show All Bookmarks is empty).
 Comparing a "known good" places.sqlite file with one that was fixed by this
 method, I noted that I was still missing the following entries.  So I added them
 using the sqlite command line, but the Library still came up empty, so I didn't
 bother to write the code that would be necessary to do this
 
 However, the Library has items in it after you launch Firefox the SECOND time.
 So, at least we're kind of good.
 
 Make sure the following names are in moz_anno_attributes
 id
 1  PlacesOrganizer/OrganizerFolder  
 2  places/excludeFromBackup   (Add this)
 3  placesInternal/READ_ONLY
 4  PlacesOrganizer/OrganizerFolder
 
 In moz_items_annos, add three items with 
 item_id = id of All Places in moz_bookmarks
 anno_attribute_id    content
 2                       1
 3                       1
 4                       6
 expiration=4
 type=1
 
 In moz_items_annos, add two items with 
 id = next id
 item_id = 373  (History)
 anno_attribute_id    content     type
 1                   'History'     3
 2                       1         1
 expiration=4
 
 
 In moz_items_annos, add two items with 
 id = next id
 item_id = id of All Tags in moz_bookmarks
 anno_attribute_id    content      type
 1                    'Tags'        3
 2                      1           1
 expiration=4
 
 In moz_items_annos, add three items with 
 id = next id
 item_id = id of All Bookmarks in moz_bookmarks
 anno_attribute_id    content      type
 1                  'All Bookmarks'      3
 2                      1                1
 3                      1                1
 expiration=4
 type=3
 
 In moz_items_annos, add two items with 
 id = next id
 item_id = id of the Bar StrawMan in moz_bookmarks
 anno_attribute_id    content              type
 1               'BookmarksToolbar'          3
 2                      1                    1
 expiration=4
 
 In moz_items_annos, add two items with 
 id = next id
 item_id = id of the Menu StrawMan in moz_bookmarks
 anno_attribute_id    content       type
 1                 'BookmarksMenu'   3
 2                       1           1
 expiration=4
 
 In moz_items_annos, add two items with 
 id = next id
 item_id = id of the Unfiled StrawMan in moz_bookmarks
 anno_attribute_id    content            type
 1                 'UnfiledBookmarks'      3
 2                       1                 1
 expiration=4
*/ 

/*
 This method is used after importing and decoding the JSON
 when reading with style 2.  For style 1, see
 readExternalStyle1ForPolarity::.
 */
- (BOOL)makeStarksFromExtoreTree:(NSDictionary*)treeIn
                         error_p:(NSError**)error_p {
    BOOL ok = YES ;
    @autoreleasepool {
        NSError* error = nil ;

        NSDictionary* clientBookmarksBar = nil ;
        NSDictionary* clientBookmarksMenu = nil ;
        NSDictionary* clientBookmarksUnfiled = nil ;
        NSDictionary* dicIn = nil;
        NSInteger errorCode = 0 ;
        NSString* errorMoreInfo = nil ;
        if ([treeIn isKindOfClass:[NSDictionary class]]) {
            if ((dicIn = [treeIn objectForKey:@"children"])) {
                // This will happen normally if we are invoked from -readExternalStyle2WithCompletionHandler:
                if ([dicIn isKindOfClass:[NSArray class]]) {
                    for (NSDictionary* hartainer in dicIn) {
                        NSString* guid = [hartainer objectForKey:@"id"];
                        if ([guid isEqualToString:kMozBarGuid]) {
                            clientBookmarksBar = hartainer;
                        }
                        else if ([guid isEqualToString:kMozMenuGuid]) {
                            clientBookmarksMenu = hartainer;
                        }
                        else if ([guid isEqualToString:kMozUnfiledGuid]) {
                            clientBookmarksUnfiled = hartainer;
                        }
                    }
                    if (!clientBookmarksBar) {
                        errorCode = 264875 ;
                        errorMoreInfo = @"Nil Bar";
                    }
                    else if (!clientBookmarksMenu) {
                        errorCode = 264876 ;
                        errorMoreInfo = @"Nil Menu";
                    }
                    else if (!clientBookmarksUnfiled) {
                        errorCode = 264877 ;
                        errorMoreInfo = @"Nil Unfiled";
                    }
                }
                else {
                    errorCode = 264872 ;
                    errorMoreInfo = [NSString stringWithFormat:@"Expected array, got %@", [dicIn className]] ;
                }
            }
            else {
                errorCode = 264873 ;
                errorMoreInfo = [NSString stringWithFormat:@"Expected 'children', got %@", [dicIn allKeys]] ;
            }
        }
        else {
            errorCode = 264874 ;
            errorMoreInfo = [NSString stringWithFormat:@"Expected dictionary, got %@", [dicIn className]] ;
        }

        if (errorCode != 0) {
            ok = NO ;
            NSString* errorDesc = [NSString stringWithFormat:
                                   @"Decoded JSON does not meet expectation.  %@",
                                   errorMoreInfo] ;
            error = SSYMakeError(errorCode, errorDesc) ;
        }

        // More checks for corrupt file.
        if (ok && !clientBookmarksBar) {
            ok = NO ;
            error = SSYMakeError(215910, @"No bar in JSON") ;
        }
        if (ok && !clientBookmarksMenu) {
            ok = NO ;
            error = SSYMakeError(295705, @"No menu in JSON") ;
        }
        if (ok && !clientBookmarksUnfiled) {
            ok = NO ;
            error = SSYMakeError(295706, @"No unfiled in JSON") ;
        }
        if (ok && ![clientBookmarksBar respondsToSelector:@selector(objectForKey:)]) {
            ok = NO ;
            error = SSYMakeError(246558, @"JSON bar not a dict") ;
        }
        if (ok && ![clientBookmarksMenu respondsToSelector:@selector(objectForKey:)]) {
            ok = NO ;
            error = SSYMakeError(265490, @"JSON menu not a dict") ;
        }
        if (ok && ![clientBookmarksUnfiled respondsToSelector:@selector(objectForKey:)]) {
            ok = NO ;
            error = SSYMakeError(265491, @"JSON unfiled not a dict") ;
        }

        if (ok) {
            // Create a transformer which we will use to create our collections from Firefox's
            SSYTreeTransformer* transformer = [SSYTreeTransformer
                                               treeTransformerWithReformatter:@selector(modelAsStarkInStartainer:)
                                               childrenInExtractor:@selector(childrenWithLowercaseC)
                                               newParentMover:@selector(moveToBkmxParent:)
                                               contextObject:self] ;

            Stark* rootOut = [[self starker] freshStark] ;
            /* Name of root must match, I think, that assigned in
             -registerBasicsFromStark:, to ensure that hashes will match. */
            [rootOut setName:[NSString localize:@"lineageRoot"]];
            Stark* barOut = [transformer copyDeepTransformOf:clientBookmarksBar] ;
            Stark* menuOut = [transformer copyDeepTransformOf:clientBookmarksMenu] ;
            Stark* unfiledOut = [transformer copyDeepTransformOf:clientBookmarksUnfiled] ;

            // Hide the RSS Articles inside their feeds
            for (Stark* stark in [[self starker] allStarks]) {
                Sharype sharypeValue = [stark sharypeValue] ;
                if (sharypeValue == SharypeLiveRSS) {
                    NSArray* children =[stark childrenOrdered] ;
                    [stark setRssArticlesFromAndRemoveStarks:children] ;
                }
            }

            // Set instance variables
            [rootOut assembleAsTreeWithBar:barOut
                                      menu:menuOut
                                   unfiled:unfiledOut
                                    ohared:nil];

            [barOut release] ;
            [menuOut release] ;
            [unfiledOut release] ;
        }

        if (error_p && error) {
            NSString* s ;
            s = [NSString stringWithFormat:
                 @"Could not decode bookmarks from %@.",
                 [self displayName]] ;
            error = [SSYMakeError(297441, s) errorByAddingUnderlyingError:error] ;
            s = [NSString stringWithFormat:
                 @"Activate %@ and check out its bookmarks.  Reset if corrupt.",
                 [self displayName]] ;
            error = [error errorByAddingLocalizedRecoverySuggestion:s] ;
            *error_p = error;

            [*error_p retain];
        }
    }

    if (error_p) {
        [*error_p autorelease];
    }

	return ok ;
}

- (NSString*)messagePleaseActivateThisProfile {
    return [NSString stringWithFormat:
            @"You have %ld profiles in %@."
            @"\n"
            @"\nPlease run %@ and ensure that it is currently running only in profile '%@'."
            @"\n"
            @"\nTo determine which profile you are currently running in %@, enter about:profiles into a browser window's address bar, then look for the text \"This is the profile in use and it cannot be deleted.  To change profiles, click \"Launch profile in new browser\", which will launch another instance of %@ – you'll actually see two %@ in your Dock.  Be sure to quit any %@ running any non-target profile before proceeding with this installation.",
            (long)[[[self class] profileNames] count],
            [self ownerAppDisplayName],
            [self ownerAppDisplayName],
            self.clientoid.profileName,
            [self ownerAppDisplayName],
            [self ownerAppDisplayName],
            [self ownerAppDisplayName],
            [self ownerAppDisplayName]
            ] ;
}

- (NSString*)helpAnchorForMultipleProfiles {
    return constHelpAnchorFirefoxProfiles ;
}

- (BOOL)profileIsLoadedIfOwnerAppRunningError_p:(NSError **)error_p {
    BOOL profileOk ;
    BOOL ok ;
    NSError* error = nil ;
	
	ok = [self beginTransactionError_p:&error] ;
    
	// Clean up
	if (ok) {
		[self endTransactionError_p:&error] ;
	}
	
	if (!ok && [error involvesCode:SQLITE_BUSY
                            domain:SSYSqliterErrorDomain]) {
		// Firefox 3 must be running this profile.  I may be
		// wrong but, based on my long experience, I think this
		// is may be a more reliable indication than fctrl lock.
		profileOk = YES ;
	}
	else {
		// Either Firefox is not running this profile, or Firefox 4+
		// is running this profile.  (Firefox 4 allows us to 
		// BEGIN EXCLUSIVE while Firefox it is running, because
		// it is using sqlite 3.7.4  See:
		// http://www.sqlite.org/wal.html
		// The last few sections are particularly interesting.
		
		// Get the profile's directory
		NSString* parentPath = [self.clientoid filePathParentError_p:&error] ;
		if (error) {
			// Not a real good answer, but…
			profileOk = YES ;
		}
		else {
            /*
             My first attempt at this was to look for the presence or absence of
             places.sqlite-shm, places.sqlite.wal, cookies.sqlite-shm,
             cookies.sqlite.wal,  At first, it seemed that these files were
             there when Firefox was running their profile only, but then later I
             found cases where the cookies pair were not there when Firefox 4
             was running the profile, and where the places pair was present even
             after Firefox 4 had been quit.
             
             Another almost-alternative would be to run JavaScript in an
             extension, 
             •   var path = Components.classes["@mozilla.org/file/directory_service;1"].getService(Components.interfaces.nsIProperties).get("ProfD", Components.interfaces.nsIFile).path ;
             •   dump("Your path is " + path + "\n") ;
             But that will not work if you're trying to determine the profile
             for extension installation.
             
             Then I discovered that Jonathan Griffin's (Firefox) ProfileManager
             open-source freeware project:
             http://jagriffin.wordpress.com/2011/01/11/profilemanager-1-0_beta1/
             would warn me if I tried to copy a profile while it was running,
             and it worked.  He only tests for the .parentlock file, but I found
             that there is "read" aka "shared" lock on the places.sqlite file
             too.  Because there is no documentation of how these work, I test
             for both, and declare the profile to be in use by Firefox if
             either is found.
             */
			NSString* path = [parentPath stringByAppendingPathComponent:@".parentlock"] ;
			profileOk = ([[NSFileManager defaultManager] unixAdvisoryLockStatusForPath:path] == F_WRLCK) ;
            if (!profileOk) {
                path = [self filePathError_p:NULL] ;
                if (path) {
                    profileOk = ([[NSFileManager defaultManager] unixAdvisoryLockStatusForPath:path] ==  F_RDLCK) ;
#if DEBUG
                    if (profileOk) {
                    NSLog(@"Warning 253-3385 Required second line of defense to find Firefox profile in use!") ;
                    }
#endif
                }
            }
            
            /* Finally, as a last-ditch effort, in case the above two both fail,
             we note that if there is only one Firefox profile, assuming as we
             do that Firefox is running, it, well must be in the correct
             profile :))  Maybe we should maybe make this a first-ditch effort,
             because for those 99% of users with only one Firefox profile, it
             will be 100% reliable! */
            if (!profileOk) {
                profileOk = ([[[self class] profileNames] count] == 1) ;
                if (profileOk) {
                    NSLog(@"Warning 105-8394  Running Firefox profile identification required Case 3") ;
                }
            }
		}
	}
    
    if (error && error_p) {
        *error_p = error ;
    }
    
    return profileOk ;
}

- (OwnerAppRunningState)ownerAppRunningStateError_p:(NSError **)error_p {
    NSError* error = nil ;
	OwnerAppRunningState ownerAppRunningState = [super ownerAppRunningStateError_p:&error] ;
	if (ownerAppRunningState == OwnerAppRunningStateError) {
        if (error_p && error) {
            *error_p = error ;
        }
        return ownerAppRunningState ;
    }
        
	if (ownerAppRunningState == OwnerAppRunningStateNotRunning) {
		return ownerAppRunningState ;
	}
	
	BOOL profileOk ;

    profileOk = [self profileIsLoadedIfOwnerAppRunningError_p:&error];

	return profileOk ? OwnerAppRunningStateRunningProfileAvailable : OwnerAppRunningStateRunningProfileWrongOne ;
	
	/* Tip: There are two ways to tell which profile you are running from the
	 Firefox gui.
     • Method 1.  Click in the menu Tools ▸ Web Developer ▸ Error Console.  Then into the
	 'Code' field, paste and 'Evaluate' this:
	 alert(Components.classes["@mozilla.org/file/directory_service;1"].getService(Components.interfaces.nsIProperties).get("ProfD", Components.interfaces.nsIFile).path);
     • Method 2.  Click in the menu Help ▸ Troubleshooting Information.  Under
     'Application Basics' > 'Profile Folder', click 'Show in Finder'.
	 */
}

- (NSString*)profilePathError_p:(NSError**)error_p {
	return [[self class] pathForProfileName:[[self clientoid] profileName]
                                   homePath:[[self clientoid] homePath]
                                    error_p:error_p] ;
}

/*  I wish we could use /usr/bin/open for this.  See Apple Bug 19070101. */
- (NSInteger)launchFirefoxAtPath:(id)path
                     profilePath:(NSString*)profilePath
                         error_p:(NSError**)error_p {
    NSInteger result ;
    NSError* error = nil ;
    
    if ([path respondsToSelector:@selector(stringByAppendingPathComponent:)]) {
        path = [path stringByAppendingPathComponent:@"Contents"] ;
        path = [path stringByAppendingPathComponent:@"MacOS"] ;

        BOOL exists = NO ;
        BOOL isDirectory = NO ;

        /* Firefox 30+ or so has two executables, "firefox" and "firefox-bin",
         and "firefox" is used when you double-click Firefox.  In older
         versions, it only had and used "firefox-bin".  Both are about but not
         exactly the same size, and seem to work the same.  Weird. */
        path = [path stringByAppendingPathComponent:@"firefox"] ;
        exists = [[NSFileManager defaultManager] fileExistsAtPath:path
                                                      isDirectory:&isDirectory] ;
        if (!exists) {
            path = [path stringByDeletingLastPathComponent] ;
            path = [path stringByAppendingPathComponent:@"firefox-bin"] ;
            exists = [[NSFileManager defaultManager] fileExistsAtPath:path
                                                          isDirectory:&isDirectory] ;
        }

        if (exists && !isDirectory) {
            NSArray* arguments = [NSArray arrayWithObjects:
                                  @"-profile", profilePath,
                                  nil] ;
            result = [SSYShellTasker doShellTaskCommand:path
                                              arguments:arguments
                                            inDirectory:nil
                                              stdinData:nil
                                           stdoutData_p:NULL
                                           stderrData_p:NULL
                                                timeout:0.0 // Don't wait
                                                error_p:&error] ;
            if (result != 0) {
                error = [SSYMakeError(524000, @"Error launching Firefox") errorByAddingUnderlyingError:error] ;
                error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:result]
                                                    forKey:@"Task exit status"] ;
                error = [error errorByAddingUserInfoObject:arguments
                                                    forKey:@"Arguments"] ;
            }
        }
        else {
            result = 524001 ;
            error = SSYMakeError(524001, @"Expected Firefox executable does not exist") ;
            error = [error errorByAddingUserInfoObject:path
                                                forKey:@"Expected Exe Path"] ;
            error = [error errorByAddingUserInfoObject:[NSNumber numberWithBool:exists]
                                                forKey:@"Exists"] ;
            error = [error errorByAddingUserInfoObject:[NSNumber numberWithBool:isDirectory]
                                                forKey:@"Is Directory"] ;
        }
    }
    else {
        result = 524002 ;
        error = SSYMakeError(524002, @"No path") ;
    }
    
    if (error && error_p) {
        error = [error errorByAddingUserInfoObject:path
                                            forKey:@"Path"] ;
        *error_p = error ;
    }
    
    return result ;
}

#define FIREFOX_LAUNCH_TIMEOUT 8.0

- (NSString*)launchOwnerAppPath:(NSString*)pathIn
					   activate:(BOOL)activate
                        error_p:(NSError**)error_p {
    NSError* error = nil ;
    NSInteger result = -999 ;
    NSString* errDesc ;
    NSString* launchedPath = nil ;
    BOOL ok ;
	NSString* profilePath = nil ;
    NSDate* deadline = nil ;
    NSRunningApplication* runningBrowser = nil ;
    
    ok = [self quitOwnerAppWithTimeout:10.0
                         preferredPath:nil
                      killAfterTimeout:YES
                          wasRunning_p:NULL
                         pathQuilled_p:NULL
                               error_p:&error] ;
    if (!ok) {
        errDesc = [NSString stringWithFormat:
                   @"Could not quit %@",
                   [[self clientoid] displayName]] ;
        error = [SSYMakeError(883742, errDesc) errorByAddingUnderlyingError:error] ;
        goto end ;
    }
    
    id path1 = pathIn ;
	if (!path1) {
        path1 = [self browserBundlePath];
	}
	
	profilePath = [self profilePathError_p:&error] ; ;
	if (error) {
        errDesc = [NSString stringWithFormat:
                   @"Error getting profilePath=%@ for %@",
                   profilePath,
                   [[self clientoid] profileName]] ;
		error = [SSYMakeError(513943, errDesc) errorByAddingUnderlyingError:error] ;
        path1 = nil ;
        goto end ;
	}
	
    if (!path1) {
        path1 = [NSNull null] ;
    }
    
    NSArray* paths = [NSArray arrayWithObjects:
                      path1,
                      @"/Applications/Firefox.app",
                      @"/Applications/Firefox Developer Edition.app",
                      nil] ;
    NSMutableArray* errors = [[NSMutableArray alloc] init] ;
    for (NSString* thisPath in paths) {
        NSError* thisError = nil ;
        result = [self launchFirefoxAtPath:thisPath
                               profilePath:profilePath
                                   error_p:&thisError] ;
        if (result == 0) {
            launchedPath = thisPath ;
            break ;
        }
        else {
            if (!thisError) {
                thisError = SSYMakeError(512394, @"Unknown Error") ;
            }
            thisError = [thisError errorByAddingUserInfoObject:thisPath
                                                        forKey:@"Path"] ;
            [errors addObject:thisError] ;
        }
    }
    
    if (result != 0) {
        errDesc = [NSString stringWithFormat:
                   @"Could not launch %@",
                   [[self clientoid] displayName]] ;
		error = SSYMakeError(513944, errDesc) ;
        error = [error errorByAddingUserInfoObject:errors
                                            forKey:@"Path Trial Errors"] ;
    }
    [errors release] ;
    
	if (error || (result != 0)) {
        goto end ;
	}
	
	// When Firefox launches, it will not return a psn immediately, so we need to wait.
	// Even if we don't need to deactivate it, it would probably still be a good idea to
	// block here until the system can give us a running application.
	deadline = [NSDate dateWithTimeIntervalSinceNow:FIREFOX_LAUNCH_TIMEOUT] ;
	do {
        for (NSString* bundleIdentifier in [[self class] browserBundleIdentifiers]) {
            runningBrowser = [[NSRunningApplication runningApplicationsWithBundleIdentifier:bundleIdentifier] firstObjectSafely] ;
            if (runningBrowser) {
                break ;
            }
        }
		usleep (200000) ;
	} while (([deadline timeIntervalSinceNow] > 0.0) && !runningBrowser) ;
    
    if (!runningBrowser) {
        errDesc = [NSString stringWithFormat:
                   @"Waited %0.1f seconds for Firefox to launch in profile '%@' , but it seems to be still dead",
                   FIREFOX_LAUNCH_TIMEOUT,
                   [[self clientoid] profileName]] ;
        error = [error errorByAddingLocalizedRecoverySuggestion:@"See if you can find what's up with Firefox"] ;
        error = SSYMakeError(513955, errDesc) ;
    }

    if (!activate) {
        [runningBrowser hideReliablyWithGuardInterval:2.0] ;
	}

end:
    if (error && error_p) {
        error = [error errorByAddingUserInfoObject:profilePath
                                            forKey:@"Profile Path"] ;
        error = [error errorByAppendingLocalizedRecoverySuggestion:@"If you have ever used Parallels Desktop on this Mac account, copy and past the following link into your web browser to see a possible solution:\n\nhttps://sheepsystems.com/files/support_articles/bkmx/parallelsConflict/index.html"] ;
        *error_p = error ;
    }

    return launchedPath ;
}

- (NSTimeInterval)exportFeedbackTimeoutPerChange {
    /* Firefox was damned slow.  Earlier notes say that 1550 changes on my
     2009 Mac Mini took more than 155 seconds, 0.1 seconds per change.  So,
     until BkmkMgrs 1.22.35 I had set this to 0.5.  However, on 2015-02-21,
     it appears to be much faster: 1678 additions, including a few hundred
     tags, in 12 seconds, which is .007 seconds per change.  So, I changed it
     it to approximately 0.1, the same value that I current use for Chromy.
     But then on 2018-01-25, exporting 32 cuts and 55 puts, total 87, I saw
     it time out when exporting from main app.  The timeout was the minimum
     time of 30.1386.  I looked at the Bookmarks Library in Firefox and saw
     that the changes were just beginning to rapidly occur – in other words,
     a few more seconds would have been enough.  In order to make the
     timeout in this case 40 seconds, this should be 40/87 = 0.45.  OK, so
     I'm going to set it back to 0.5. */
	return 0.50777 ;
}

- (id)tweakedValueFromStark:(Stark*)stark
                     forKey:(NSString*)key {
    id tweakedValue = [stark valueForKey:key] ;
    
    if ([key isEqualToString:constKeyUrl]) {
        tweakedValue = [stark url] ;
        tweakedValue = [tweakedValue decodeOnlyPercentEscapesInUnicodeSet:nil
                                                       uppercaseAnyOthers:NO
                                                  resolveDoubleDotsInPath:YES];
    }
    
    if ([stark sharypeValue] == SharypeSeparator) {
        if (![key isEqualToString:constKeyIndex] && ![key isEqualToString:constKeySharype]) {
            tweakedValue = nil;
        }
    }
    
    return tweakedValue ;
}

- (void)tweakExport {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
	BkmxDoc* bkmxDoc = [[[self client] macster] bkmxDoc] ;
	SSYProgressView* progressView = [bkmxDoc progressView] ;
	
	NSArray* starks = [[self starker] allStarks] ;

	[progressView setMaxValue:[starks count]] ;
	[progressView setDoubleValue:1.0] ;
	NSString* whatDoing = @"Checking tag equivalences for Firefox" ;
	[progressView setVerb:whatDoing
				   resize:YES] ;
	[progressView display] ;

    // Re-activate watching for Stark changes during -tweakExport, because the changes
    // made here may add to or, more likely (in Firefox tags), cancel out changes that
    // were registered during the merge operation, in BkmxDoc's Chaker.
    [[NSNotificationCenter defaultCenter] addObserver:[[self client] exporter]
                                             selector:@selector(objectWillChangeNote:)
                                                 name:SSYManagedObjectWillUpdateNotification
                                               object:nil] ; // Nil because must observe any stark
    // The following is necessary in order for -[Ixporter objectWillChangeNote:]
    // to be notified of changes made during -tweakExport.
    [[[self client] exporter] setBkmxDoc:bkmxDoc] ;

	NSMutableDictionary* tagRecordDic = [[NSMutableDictionary alloc] init] ;
	NSMutableDictionary* badTagRecordDic = [[NSMutableDictionary alloc] init] ;
	for (Stark* stark in starks) {
		[progressView incrementDoubleValueBy:1.0] ;
		for (Tag* tag in [stark tags]) {
			NSString* canonicalTag = [tag.string lowercaseString] ;
			NSMutableDictionary* tagRecord = [tagRecordDic objectForKey:canonicalTag] ;
			if (!tagRecord) {
				tagRecord = [[NSMutableDictionary alloc] init] ;
				[tagRecordDic setObject:tagRecord
								 forKey:canonicalTag] ;
				[tagRecord release] ;
			}
			NSMutableSet* taggedStarks = [tagRecord objectForKey:tag] ;
			if (!taggedStarks) {
				taggedStarks = [[NSMutableSet alloc] init] ;
				[tagRecord setObject:taggedStarks
							  forKey:tag.string] ;
				[taggedStarks release] ;
			}
			[taggedStarks addObject:stark] ;
			
			if ([tagRecord count] > 1) {
				[badTagRecordDic setObject:tagRecord
									forKey:canonicalTag] ;
			}
		}
	}
	
	[tagRecordDic release] ;
	
	[progressView setMaxValue:[badTagRecordDic count]] ;
	[progressView setDoubleValue:1.0] ;
	whatDoing = @"Enforcing tag equivalences for Firefox" ;
	[progressView setVerb:whatDoing
				   resize:YES] ;
	[progressView display] ;
	
	for (NSString* canonicalTag in badTagRecordDic) {
		[progressView incrementDoubleValueBy:1.0] ;
		NSDictionary* tagRecord = [badTagRecordDic objectForKey:canonicalTag] ;
		NSMutableArray* tags = [[tagRecord allKeys] mutableCopy] ;
		[tags sortUsingSelector:@selector(compareCase:)] ;
		NSString* lowestCaseTag = [tags objectAtIndex:0] ;
        [tags release] ;
		for (NSString* tag in tagRecord) {
			NSArray* starks = [tagRecord objectForKey:tag] ;
			for (Stark* taggedStark in starks) {
				// When we *add* the lowestCase tag, because -addTag: invokes
				// -setTags: which invokes -bookMacstrifiedTags:, the
				// existing tag will be removed and replaced with 
				// lowestCaseTag
				[taggedStark addTagString:lowestCaseTag] ;
			}
		}
	}

	[progressView setMaxValue:[starks count]] ;
	[progressView setDoubleValue:1.0] ;
	whatDoing = @"Checking tag conflicts for Firefox" ;
	[progressView setVerb:whatDoing
				   resize:YES] ;
	[progressView display] ;
	
	NSMutableDictionary* tagRecords = [[NSMutableDictionary alloc] init] ;
	NSMutableSet* urlsWithConflictedTags = [[NSMutableSet alloc] init] ;
	for (Stark* stark in [[self starker] allStarks]) {
		[progressView incrementDoubleValueBy:1.0] ;
		NSArray* tags = [stark tags] ;
		NSString* url = [stark url] ;
        if (url) {
			NSMutableDictionary* tagRecord = [tagRecords objectForKey:url] ;
			if (tagRecord) {
				NSMutableArray* priorTags = [tagRecord objectForKey:constKeyTags] ;
                
                // Defensive programming
				if (priorTags && ([priorTags count] == 0)) {
					priorTags = nil ;
				}
				if (tags && ([tags count] == 0)) {
					tags = nil ;
				}

				if (![NSArray isEqualHandlesNilObject1:tags
                                               object2:priorTags]) {
                    if (!priorTags) {
                        priorTags = [NSMutableArray array] ;
                    }
                    else {
                        priorTags = [[priorTags mutableCopy] autorelease] ;
                    }
                    
                    /* Thus, prior tags cannot be nil.
                     Also, because isEqualHandlesNilObject1:object2:
                     returned NO, and because we replaced empty arrays with
                     nil, either priorTags or tags must be nonempty. */
					[priorTags addObjectsFromArray:tags] ;
                    /* therefore priorTags must be nonempty */
					NSArray* reMacstrifiedTags = [priorTags bookMacstrifiedTags] ;
                    /* and so reMacstrifiedTags is nonempty and not nil */
                    reMacstrifiedTags = [[reMacstrifiedTags mutableCopy] autorelease] ;
					[tagRecord setObject:reMacstrifiedTags
                                   forKey:constKeyTags] ;
					[urlsWithConflictedTags addObject:url] ;
				}
				NSMutableArray* starks = [tagRecord objectForKey:constKeyStarks] ;
				[starks addObject:stark] ;
			}
			else {
				NSMutableArray* starks = [[NSMutableArray alloc] init] ;
				[starks addObject:stark] ;
				NSMutableArray* newTags = [tags mutableCopy] ;  // may be nil
				tagRecord = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
							 starks, constKeyStarks,
							 newTags, constKeyTags,  // may be nil
							 nil] ;
				[starks release] ;
				[newTags release] ;
				[tagRecords setObject:tagRecord
							   forKey:url] ;
				[tagRecord release] ;
			}
		}
	}

	[progressView setMaxValue:[starks count]] ;
	[progressView setDoubleValue:1.0] ;
	whatDoing = @"Resolving tag conflicts for Firefox" ;
	[progressView setVerb:whatDoing
				   resize:YES] ;
	[progressView display] ;
	
    for (NSString* url in urlsWithConflictedTags) {
		[progressView incrementDoubleValueBy:1.0] ;
		NSDictionary* tagRecord = [tagRecords objectForKey:url] ;
		for (Stark* stark in [tagRecord objectForKey:constKeyStarks]) {
			NSArray* newTags = [tagRecord objectForKey:constKeyTags] ;
			if (![NSArray isEqualHandlesNilObject1:[stark tags]
										   object2:newTags]) {
				// Tags have already been bookMacstrified, so we shortcut to
                // set the *raw* tags…
				[stark setRawTags:newTags] ;
			}
		}
	}
						
	[tagRecords release] ;
    [badTagRecordDic release] ;
	[urlsWithConflictedTags release] ;
	
	[progressView clearAll] ;

    /* Undo the re-activate which we did at the beginning of this method. */
    [[NSNotificationCenter defaultCenter] removeObserver:[[self client] exporter]
                                                    name:SSYManagedObjectWillUpdateNotification
                                                  object:nil] ;
    // Defensive programming, since ixporter holds bkmxDoc weakly…
    // We set it at the beginning of this method.  Now unset it…
    [[[self client] exporter] setBkmxDoc:nil] ;

	[pool release] ;
}

/*
 Added in BookMacster 1.14.3, after I found that telling Firefox to quit
 with 'close windows', more than half the time, caused it to launch next
 time with "Well, this is embarassing…"
 */
- (BOOL)shouldCloseWindowsWhenQuitting {
    return NO ;
}

+ (BOOL)parentSharype:(Sharype)parentSharype
  canHaveChildSharype:(Sharype)childSharype {
    BOOL ok = [super parentSharype:parentSharype
               canHaveChildSharype:childSharype] ;
    if (ok) {
        // Only other hartainers are allowed in Root
        if (parentSharype == SharypeRoot) {
            if ([StarkTyper coarseTypeSharype:childSharype] != SharypeCoarseHartainer) {
                ok = NO ;
            }
        }
    }
    
    return ok ;
}

+ (NSString*)extension1Uuid {
    /* For version signed by addons.mozilla.org */
    return @"{5be4a1a1-c477-423d-a946-13c1d880306f}" ;
}

+ (NSString*)extension2Uuid {
    /* For version signed by addons.mozilla.org */
    return @"{ffcd605e-1e3e-460b-be92-80366b730886}" ;
}

+ (NSInteger)extensionVersionForExtensionIndex:(NSInteger)extensionIndex
                                   profilePath:(NSString*)profilePath
                                       error_p:(NSError**)error_p {
    if ([[NSApp delegate] respondsToSelector:@selector(relaxedExtensionDetection)]) {
        if (((BkmxAppDel*)[NSApp delegate]).relaxedExtensionDetection) {
            return 999;
        }
    } else {
        // We are in BkmxAgent
    }

    NSError* error = nil ;
    NSData* data = [self ownerExtensionsJsonForProfilePath:profilePath
                                                   error_p:&error] ;
    BOOL ok = (data != nil) ;
    NSInteger answer = 0 ;
    if (ok) {
        NSString* identifier ;
        switch (extensionIndex) {
            case 1:
                identifier = [self extension1Uuid];
                break;
            case 2:
                identifier = [self extension2Uuid];
                break;
            default:
                identifier = nil;
        }

        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data
                                                            options:0
                                                              error:&error];
        if ([dic respondsToSelector:@selector(objectForKey:)]) {
            NSArray* addons = [dic objectForKey:@"addons"];
            if ([addons isKindOfClass:[NSArray class]]) {
                for (NSDictionary* addon in addons) {
                    NSString* thisIdentifier = [addon objectForKey:@"id"];
                    if ([thisIdentifier isKindOfClass:[NSString class]]) {
                        if ([thisIdentifier isEqualToString:identifier]) {
                            answer = ((NSNumber*)[addon objectForKey:@"version"]).integerValue;
                            break;
                        }
                    }
                }
            }
        }
    }

    if (error && error_p) {
        *error_p = error ;
    }

    return answer ;
}

- (NSInteger)extensionVersionForExtensionIndex:(NSInteger)extensionIndex {
    NSInteger extensionVersion = 0 ;
    NSError* error = nil ;
    NSString* profilePath = [self profilePathError_p:&error] ;
    if (profilePath && !error) {
        /* The next line will return 999 if the app delegate's
         .relaxedExtensionDetection property has been set. */
        extensionVersion = [[self class] extensionVersionForExtensionIndex:extensionIndex
                                                               profilePath:profilePath
                                                                   error_p:&error] ;
    }

    /* Ignore error here, because it is possible that the prefs.js file does
     exist in a new Firefox profile. */

    return extensionVersion ;
}

- (BOOL)installMessengerError_p:(NSError**)error_p {
    /*
     All we install here is the special manifest file.  The symlink to the
     Chromessenger tool, in our Application Support folder, is updated each
     time the app launches, by -doFinishLaunchingEarlyChores, whether we
     are using it or not.  It's only a symlink!
     */

    /* Strange that Firefox profiles.ini and, by default, profile folders, are in
     *   ~/Library/Application Support/Firefox
     but their NativeMessagingHosts file is in
     *   ~/Library/Application Support/Mozilla
     Here, we want the latter… */
    NSString* path = [[NSString applicationSupportPathForHomePath:nil] stringByAppendingPathComponent:@"Mozilla"];

    NSDictionary* moreInfos = @{@"allowed_extensions" : @[
                                        [ExtoreFirefox extension1Uuid],
                                        [ExtoreFirefox extension2Uuid]
                                        /* Should add debugging extension UUIDs
                                         here, if Mozilla ever fixes Bug 1378248
                                         https://bugzilla.mozilla.org/show_bug.cgi?id=1378248 t*/
                                        ]} ;
    return [Chromessengerer installSpecialManifestForAppSupportPath:path
                                                            profile:[[self clientoid] profileName]
                                                          moreInfos:moreInfos
                                                            error_p:(NSError**)error_p] ;
}

- (NSString*)messageHowToForceAutoUpdateExtensionIndex:(NSInteger)extensionIndex {
    NSInteger extensionVersion = [self extensionVersionForExtensionIndex:extensionIndex];
    NSString* answer = nil;
    BOOL canAutoUpdate;
    switch (extensionIndex) {
        case 1:
            canAutoUpdate = extensionVersion >= 40;
            break;
        case 2:
            canAutoUpdate = extensionVersion >= 28;
            break;
        default:
            canAutoUpdate = NO; // This should never happen.
    }

    if (canAutoUpdate) {
        answer = NSLocalizedString(
                                   @"• Click in the main menu > Tools > Add-Ons and Themes."
                                   @"\n• Click the button containing the gear icon (‘Tools for all add-ons’)."
                                   @"\n• Click the menu item titled ‘Check for Updates’."
                                   @"\n• Verify that our updated extension is *enabled*", nil);
    }

    return answer;
}

- (NSString*)uninstallInstructionsForExtensionIndex:(NSInteger)extensionIndex {
    NSString* answer = nil;
    if ([[[self class] profileNames] count] > 1) {
        NSString* displayProfileName = [[self class] displayProfileNameForProfileName:[[self clientoid] profileName]];
        answer = [NSString stringWithFormat:
                  @"To uninstall the %@ extension for profile '%@':\n\n"
                  @"• Run %@ in profile '%@'.  If you are not sure how to do that, click the '?' button below for links to Mozilla documentation.\n\n"
                  @"• Click in the menu: Tools > Add-Ons and Themes.  A tab with a list of extensions will appear.\n\n"
                  @"• Click the '...' button adjacent '%@'.\n\n"
                  @"• Click the 'Remove' trash can button and affirm the removal.\n\n"
                  @"• If you want the extension to be fully removed immediately, you must quit and then relaunch %@ into profile '%@'.",
                  [self extensionDisplayNameForExtensionIndex:extensionIndex],
                  displayProfileName,
                  [self ownerAppDisplayName],
                  displayProfileName,
                  [self extensionDisplayNameForExtensionIndex:extensionIndex],
                  [self ownerAppDisplayName],
                  displayProfileName];
    } else {
        answer = [NSString stringWithFormat:
                  @"To uninstall the %@ extension:\n\n"
                  @"• Run %@.\n\n"
                  @"• Click in the menu: Tools > Add-Ons.  A tab with a list of extensions will appear.\n\n"
                  @"• Click the 'Remove' button adjacent '%@' and affirm the removal.\n\n"
                  @"• If you want the extension to be fully removed immediately, you must quit and then relaunch %@.",
                  [self extensionDisplayNameForExtensionIndex:extensionIndex],
                  [self ownerAppDisplayName],
                  [self extensionDisplayNameForExtensionIndex:extensionIndex],
                  [self ownerAppDisplayName]];

    }

    return answer;
}

- (NSString*)uninstallHelpAnchorForExtensionIndex:(NSInteger)extensionIndex {
    return constHelpAnchorFirefoxProfiles;
}


/*!
 @details  Override which invokes super and then adds decodes the extra
 attributes which are supported by Firefox only
 */
- (Stark*)starkFromExtoreNode:(NSDictionary*)dic {
    Stark* stark = [super starkFromExtoreNode:dic];

    NSString* stringValue;

    stringValue = [dic objectForKey:@"comments"] ;
    if (stringValue.length > 0) {
        [stark setComments:stringValue] ;
    }

    if (stark.sharypeValue == SharypeLiveRSS)  {
        // Livemark
        stringValue = [dic objectForKey:BkmxConstTypeFeedUrl] ;
        if (stringValue.length > 0) {
            [stark setUrl:stringValue] ;
        }
    }
    else if ([StarkTyper isLeafCoarseSharype:stark.sharypeValue])  {
        // Bookmark, Smart Bookmark or RSS Article

        if ([self isSmartUrl:stark.url]) {
            stark.sharypeValue = SharypeSmart ;
        }

        NSArray* tagsArray = [dic objectForKey:@"tags"] ;
        [[self tagger] updateTagStrings:tagsArray
                                inStark:stark];

        NSNumber* visitCountNumber = [dic objectForKey:@"visitCount"] ;
        [stark setVisitCount:visitCountNumber] ;
    }

    return stark;
}

@end

/*
 Note 432897

 Study of Firefox Tags
 Date: 20120322
 Version: Firefox 12.0 beta

 The following tests were performed by entering given text into the
 "Tags" field for a bookmark in Firefox' "Library", then tabbing to
 the next field and seeing what you "Get" – that is, what Firefox
 changes the entry to.
 
 Enter:  doo, Doo, DOO, dOo, c, C, B, b, a, a
 Get:    a, B, C, DOO
 
 Enter:  doo, DOO, doo, c, C, B, b, a, a
 Get:    a, b, C, doo
 
 Enter:  eeyore, éeyore
 Get:    eeyore, éeyore
 
 Enter:  éeyore, eeyore
 Get:    eeyore, éeyore
 
 Conclusions: 
 1.  Tags are case-insensitive, but diacritical-sensitive.
 2.  When Firefox deletes duplicate tags, which one is kept is indeterminate
 3.  Tags are sorted alphabetically.
 
 • Localized?
 
 One thing I don't know is whether Firefox' sorting is localized.  That is,
 are they using -caseInsensitiveCompare: or -localizedCaseInsensitiveCompare:?
 Probably neither, since Firefox is not a Cocoa app.  I could test it, based
 on this post:
 
 http://stackoverflow.com/questions/8776781/what-is-the-difference-between-the-following-two-methods
 
 wherein,
 
 "In example, when we have strings: Ltest, Łtest, Mtest, Ztest
 
 caseInsensitiveCompare gives in result: Ltest, Mtest, Ztest, Łtest
 localizedCaseInsensitiveCompare gives in result: Ltest, Łtest, Mtest, Ztest
 
 So I could test it by running Firefox in Polish.  But instead, I'm going to 
 assume that Mozilla did the *correct* thing, used -localizedCaseInsensitiveCompare:.
 If they're currently doing it wrong, maybe they'll fix it in a future release!
*/
