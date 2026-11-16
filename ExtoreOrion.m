#import "ExtoreOrion.h"
#import "Bkmxwork/Bkmxwork-Swift.h"
#import "StarkTyper.h"
#import "BkmxGlobals.h"

static const ExtoreConstants extoreConstants = {
	/* canEditAddDate */                  NO,
	/* canEditComments */                 BkmxCanEditInStyleNeither,
	/* canEditFavicon */                  NO,
	/* canEditFaviconUrl */               NO,
	/* canEditIsAutoTab */                NO,
	/* canEditIsExpanded */               NO,
	/* canEditIsShared */                 NO,
	/* canEditLastChengDate */            NO,
	/* canEditLastModifiedDate */         NO,  // See Note 190351
	/* canEditLastVisitedDate */          NO,
	/* canEditName */                     YES,
	/* canEditRating */                   NO,
	/* canEditRssArticles */              NO,
    /* canEditSeparators */               BkmxCanEditInStyleNeither,
	/* canEditShortcut */                 BkmxCanEditInStyleNeither,
	/* canEditTags */                     BkmxCanEditInStyleNeither,
	/* canEditUrl */			          YES,
	/* canEditVisitCount */               NO,
	/* canCreateNewDocuments */           YES,
	/* ownerAppDisplayName */             @"Orion",
	/* webHostName */                     nil,
	/* authorizationMethod */             BkmxAuthorizationMethodNone,
	/* accountNameHint */                 nil,
	/* oAuthConsumerKey */                nil,
	/* oAuthConsumerSecret */             nil,
	/* oAuthRequestTokenUrl */            nil,
	/* oAuthRequestAccessUrl */           nil,
	/* oAuthRealm */                      nil,
	/* appSupportRelativePath */          @"Orion",
	/* defaultFilename */                 @"NO-BUENO-1",
	/* defaultProfileName */              @"Default",
	/* iconResourceFilename */            nil,
	/* iconInternetURL */                 nil,
	/* fileType */                        @"",
	/* ownerAppObservability */           OwnerAppObservabilitySpecialFile,
	/* canPublicize */                    NO,
	/* silentlyRemovesDuplicates */       NO,
	/* normalizesURLs */                  NO,
	/* catchesChangesDuringSave */        NO,
	/* telltaleString */                  @"checksum",
	/* hasBar */                          YES,
	/* hasMenu */                         YES,
	/* hasUnfiled */                      NO,   // See Note OrionRL
	/* hasOhared */                       NO,
	/* tagDelimiter */                    nil,
	/* dateRef1970Not2001 */              YES, 
	/* hasOrder */                        YES,
	/* hasFolders */                      YES,
	/* ownerAppIsLocalApp */              YES,
	/* defaultSpecialOptions */           0x0000000000000000LL,
	/* extensionInstallDirectory */       @"Extensions",
	/* minBrowserVersionMajor */          0,
	/* minBrowserVersionMinor */          0,
	/* minBrowserVersionBugFix */         0,
	/* minSystemVersionForBrowsMajor */   0,
	/* minSystemVersionForBrowMinor */    0,
	/* minSystemVersionForBrowBugFix */   0
} ;

/*
 Note OrionRL
 
 Orion does have a Reading List, however it is not accessible by the W3CBE extensions API.
 So we do not support it.
 */

/*
 Note: Orion files on disk
 
 By the way, the Bookmarks are stored in:
 ~/Library/Application Support/Orion/Defaults/favourites.plist
 and the Reading List items are stored in:
 ~/Library/Application Support/Orion/Defaults/reading_list.plist
 The file formats are different than both Chrome (of course, since it is
 a plist and not a json file), and different than Safari's Bookmarks.plist
 (which is a plist file and does include Reading List items.)
 */


@implementation ExtoreOrion

/*
 The following implementation is the same in all subclasses, but we define it
 in each subclass in order to pick up the static variables which are different
 in each Extore subclass' implementation file.
 */
+ (const ExtoreConstants *)constants_p {
	return &extoreConstants ;
}

+ (NSArray*)browserBundleIdentifiers {
    return [NSArray arrayWithObject:@"com.kagi.kagimacOS"] ;
}

- (NSString*)ownerAppSyncServiceDisplayName {
    return @"Orion's syncing" ;
}

+ (NSString*)fileParentRelativePath {
	return @"NO-BUENO-2" ; // empty because the Bookmarks file is inside the profile folder
}

+ (PathRelativeTo)fileParentPathRelativeTo {
    return PathRelativeToProfile ;
}

+ (BOOL)syncExtensionAvailable {
    return YES ;
}

+ (BOOL)style1Available {
    /* Orion uses a proprietary bookmarks file format on disk, different than
     any other browser, wh
     ich I refuse to reverse engineer,  So no style 1. */
    return NO;
}

+ (BOOL)supportsMultipleProfiles {
    return YES;
}

+ (NSSet*)allProfilesThisHome {
    return [ExtoreOrion allProfilesThisHomeSwiftly];
}

- (BOOL)style1Available {
    return [[self class] style1Available];
}

- (BkmxIxportLaunchBrowserPreference)launchBrowserPreference {
    return BkmxIxportLaunchBrowserPreferenceAlways;
}

+ (NSString*)appSupportRelativePath {
    return [self constants_p]->appSupportRelativePath;
}

/*
 The other Chromish browsers identify every bookmark with a small sequential
 integer exid.  Orion's exid space is instead heterogeneous: the hard folders
 are small integers (beginning with 1), the default bookmarks that ship with
 Orion are integers (beginning with 100), but every user-created soft folder and
 bookmark gets a 32-hex UUID string (e.g.
 "A310D544-F2BF-44EA-AEAF-899F31613655").

 ExtoreChromy turns on -shouldCheckAggregateExids, which exists to guarantee
 that the integer exids of a true Chromium are unique, valid array indexes,
 re-minting any that are not.  That check parses each exid with
 -[NSString integerValue], which is meaningless for Orion's UUIDs: every UUID
 that begins with a hex *letter* (a-f) parses to 0, so any two of them appear to
 "collide" at 0.  The check would then re-mint one of the colliding items --
 nondeterministically, since it iterates -allStarks in set order -- to a bogus
 integer exid.  When the victim happened to be an item being deleted, its cut
 carried an exid that does not exist in Orion, and the deletion failed
 (BookMacster Sync "Error 633844: Failed ... to delete item").

 Orion assigns its own ids (integer or UUID) and reports them back to us, and
 the only integer exids we ever mint are placeholders for brand-new items (via
 -getFreshExid_p:..., which returns m_highestUsedId+1, above every existing
 integer-parsed id, then are replaced by Orion's real id via exid feedback).  So
 the aggregate check is both unnecessary and harmful here.  We turn it off.
 */
- (BOOL)shouldCheckAggregateExids {
    return NO ;
}

@end
