#import "ExtoreOrion.h"
#import "Bkmxwork/Bkmxwork-Swift.h"
#import "StarkTyper.h"
#import "BkmxGlobals.h"
#import "Stark.h"
#import "SSYTreeTransformer.h"
#import "Starker.h"

/* Key under which, during a read (import, or the read phase of an export), we
 stash the exid of Orion's root-level container folder ("Bookmarks").  It is
 needed again at export time, to direct root-level items back into it.  See
 Note OrionRoot. */
static NSString* const constKeyOrionRootContainerExid = @"orionRootContainerExid" ;

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
	/* minSystemVersionForBrowBugFix */   0,
	/* rootLeavesOk */                    YES,  // See Note OrionRoot
	/* rootSoftainersOk */                YES   // See Note OrionRoot
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

/*
 Note OrionRoot

 Unlike the other Chromish browsers, which require every bookmark and soft
 folder to live inside one of the two hard folders (the Bookmarks Bar and the
 "Other Bookmarks" folder), Orion also supports bookmarks at the root level.
 The W3CBE bookmarks tree which Orion's extension sends us in a Style 2 import
 therefore has *three* hard folders among the children of the root node:

     children[0]  "Favorites"      -> our Bar
     children[1]  "Bookmarks Bar"  -> our Menu ("Other Bookmarks")
     children[2]  "Bookmarks"      -> holds the root-level items

 The GooChromy superclass extracts the first two as the bar and menu hard
 folders.  For a genuine Google Chrome, children[2] is the "mobile"/synced
 tree, which we intentionally ignore.  For Orion, though, children[2] is the
 root-level container, and its items belong at the root of our collection --
 NOT in our Unfiled hard folder (which is displayed as the "Reading List").
 So we graft its children directly under rootOut, as loose siblings of the bar
 and menu.

 EXPORT.  Because root-level items end up as loose children of our root -- a
 stark which has no exid (the import mate explicitly skips the root, so one
 could not be carried on it anyway) -- the generic change packager emits them
 with NO parentExid, which the GooChromy extension cannot act upon (unlike the
 Safari helper, which treats a nil parentExid as "root").  So we bridge the gap
 ourselves, entirely in the app:

   • During the read, we stash the "Bookmarks" container's exid (here).  The
     read also happens at the start of every export, so the value is fresh and
     on this same extore instance when the export's writing phase runs.
   • -relocateLocalItemsToLocalHardFoldersInChangesDic: (called just before the
     changes are sent) stamps that stashed exid onto every parentExid-less put,
     sending the root-level items into the "Bookmarks" container.
   • -indexOffsetForRoot shifts their indexes down past the bar and menu hard
     folders, so they are 0-based within that container.
 */
- (void)graftRootLevelStarksFromExtoreTree:(NSDictionary*)treeIn
                                   rootOut:(Stark*)rootOut
                               transformer:(SSYTreeTransformer*)transformer {
    NSArray* children = [treeIn objectForKey:@"children"] ;
    if ([children isKindOfClass:[NSArray class]] && (children.count >= 3)) {
        NSDictionary* bookmarksFolder = [children objectAtIndex:2] ;

        /* Remember the container's exid, for the export direction. */
        NSString* containerExid = [bookmarksFolder objectForKey:@"id"] ;
        if (containerExid) {
            [[self fileProperties] setObject:containerExid
                                      forKey:constKeyOrionRootContainerExid] ;
        }

        NSArray* rootItems = [bookmarksFolder objectForKey:@"children"] ;
        if ([rootItems isKindOfClass:[NSArray class]]) {
            for (NSDictionary* itemIn in rootItems) {
                /* NB: ExtoreOrion.m is compiled under ARC, so unlike the
                 equivalent loops in the non-ARC ExtoreChromy/ExtoreSafari we
                 do not -release itemOut; ARC balances the +1 from
                 copyDeepTransformOf: after moveToBkmxParent: has grafted it. */
                Stark* itemOut = [transformer copyDeepTransformOf:itemIn] ;
                [itemOut moveToBkmxParent:rootOut] ;
            }
        }
    }
}

/*
 The loose root-level items are grafted after the bar and menu hard folders
 (-assembleAsTreeWithBar:… places those at indexes 0 and 1), so under our root
 they occupy indexes 2, 3, ….  In Orion they live inside the "Bookmarks"
 container and must be indexed from 0 there, so we shift them down by the number
 of hard folders present at our root.  See Note OrionRoot.
 */
- (NSInteger)indexOffsetForRoot {
    NSInteger nHartainers = 0 ;
    if ([[self starker] bar]) { nHartainers++ ; }
    if ([[self starker] menu]) { nHartainers++ ; }
    if ([[self starker] unfiled]) { nHartainers++ ; }
    if ([[self starker] ohared]) { nHartainers++ ; }
    return -nHartainers ;
}

/*
 Direct every root-level item (a put with no parentExid; in Orion everything
 else lives in a hard folder, which always has an exid) into Orion's
 "Bookmarks" container.  See Note OrionRoot.
 */
- (NSDictionary*)relocateLocalItemsToLocalHardFoldersInChangesDic:(NSDictionary*)changesDic {
    /* The superclass handles the (Google-Chrome-only) dual-tree case; for
     Orion it returns changesDic unchanged. */
    changesDic = [super relocateLocalItemsToLocalHardFoldersInChangesDic:changesDic] ;

    NSString* rootContainerExid = [[self fileProperties] objectForKey:constKeyOrionRootContainerExid] ;
    NSArray* puts = [changesDic objectForKey:constKeyPuts] ;
    if (!rootContainerExid || ![puts isKindOfClass:[NSArray class]]) {
        return changesDic ;
    }

    NSMutableArray* correctedPuts = [NSMutableArray arrayWithCapacity:puts.count] ;
    BOOL didCorrectAny = NO ;
    for (NSDictionary* put in puts) {
        if (![put objectForKey:constKeyParentExid]) {
            NSMutableDictionary* correctedPut = [put mutableCopy] ;
            [correctedPut setObject:rootContainerExid
                             forKey:constKeyParentExid] ;
            [correctedPuts addObject:correctedPut] ;
            didCorrectAny = YES ;
        }
        else {
            [correctedPuts addObject:put] ;
        }
    }

    if (didCorrectAny) {
        NSMutableDictionary* fixedChangesDic = [changesDic mutableCopy] ;
        [fixedChangesDic setObject:correctedPuts
                            forKey:constKeyPuts] ;
        changesDic = fixedChangesDic ;
    }

    return changesDic ;
}

@end
