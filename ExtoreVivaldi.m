#import "ExtoreVivaldi.h"
#import "StarkTyper.h"
#import "BkmxGlobals.h"
#import "Starker.h"
#import "BkmxBasis.h"

static const ExtoreConstants extoreConstants = {
    /* canEditAddDate */                  NO, // See Note 190352
    /* canEditComments */                 BkmxCanEditInStyleEither,
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
    /* canEditShortcut */                 BkmxCanEditInStyleEither,
    /* canEditTags */                     BkmxCanEditInStyleNeither,
    /* canEditUrl */			          YES,
    /* canEditVisitCount */               NO,
    /* canCreateNewDocuments */           YES,
    /* ownerAppDisplayName */             @"Vivaldi",
    /* webHostName */                     nil,
    /* authorizationMethod */             BkmxAuthorizationMethodNone,
    /* accountNameHint */                 nil,
    /* oAuthConsumerKey */                nil,
    /* oAuthConsumerSecret */             nil,
    /* oAuthRequestTokenUrl */            nil,
    /* oAuthRequestAccessUrl */           nil,
    /* oAuthRealm */                      nil,
    /* appSupportRelativePath */          @"Vivaldi",
    /* defaultFilename */                 @"Bookmarks",
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
    /* hasMenu */                         NO,  // See Note VivaldiOtherBookmarks
    /* hasUnfiled */                      NO,
    /* hasOhared */                       NO,
    /* tagDelimiter */                    nil,
    /* dateRef1970Not2001 */              YES,
    /* hasOrder */                        YES,
    /* hasFolders */                      YES,
    /* ownerAppIsLocalApp */              YES,
    /* defaultSpecialOptions */           0x0000000000000000LL,
    /* extensionInstallDirectory */       @"Extensions",
    /* minBrowserVersionMajor */          1,
    /* minBrowserVersionMinor */          3,
    /* minBrowserVersionBugFix */         501,
    /* minSystemVersionForBrowsMajor */   0,
    /* minSystemVersionForBrowMinor */    0,
    /* minSystemVersionForBrowBugFix */   0
} ;

/* Note VivaldiOtherBookmarks
 
 Even though Vivaldi does not have an "Other Bookmarks" or equivalent in its
 user interface, it has an empty "other" JSON dictionary in its Bookmarks
 file.
 
 • If we export any items into that 'other' branch, Vivaldi will
 not display these  items anywhere in its user interface.  Presumably this
 'other' branch is just a stub from the Chromium source code.  But it is for
 real, because if we later import from Vivaldi, even using Style 2, the items
 will be in the imported data!  So it's like they are there, due to the
 Chromium source code, but Vivaldi does not support Other Bookmarks in its
 user interface.  This all makes sense, but is still weird.
 
 */

@implementation ExtoreVivaldi

/*
 The following implementation is the same in all subclasses, but we define it
 in each subclass in order to pick up the static variables which are different
 in each Extore subclass' implementation file.
 */
+ (const ExtoreConstants *)constants_p {
    return &extoreConstants ;
}

+ (NSArray*)browserBundleIdentifiers {
    return [NSArray arrayWithObject:@"com.vivaldi.Vivaldi"] ;
}

+ (NSString*)fileParentRelativePath {
    return @"" ; // empty because the Bookmarks file is inside the profile folder
}

+ (PathRelativeTo)fileParentPathRelativeTo {
    return PathRelativeToProfile ;
}

/*!
 @details  We do not use the 'other' branch.  Vivaldi does not use it either.
 (see Note VivaldiOtherBookmarks).  However, if we do not pass the empty
 'other' branch through during a Style 1 export, Vivaldi will reject our
 export and reset to empty bookmarks.  Therefore it is important that we
 override this method and *not* include @"other". */
- (NSSet*)hartainersWeEdit {
    return [NSSet setWithObjects:
            @"bookmark_bar",
            nil] ;
}

- (Stark*)fosterParentForStark:(Stark *)stark {
    /* Vivaldi puts everything in the bar. */
    return [[self starker] bar] ; 
}

+ (BOOL)syncExtensionAvailable {
    return ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppBookMacster)
    || ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppSynkmark)
    || ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppMarkster);
}

+ (BOOL)supportsMultipleProfiles {
    return YES;
}

+ (BkmxGrabPageIdiom)peekPageIdiom {
    return BkmxGrabPageIdiomSSYInterappServer ;
}

- (NSString*)uninstallInstructionsForExtensionIndex:(NSInteger)extensionIndex {
    NSString* answer = [NSString stringWithFormat:
                        @"To uninstall the %@ extension:\n\n"
                        @"• Run %@.\n\n"
                        @"• Click in the menu: Tools > Extensions.  A tab with a list of extensions will appear.\n\n"
                        @"• Click the trash can button adjacent '%@' and affirm the removal.\n\n"
                        @"• If you want the extension to be fully removed immediately, you must quit and then relaunch %@.",
                        [self extensionDisplayNameForExtensionIndex:extensionIndex],
                        [self ownerAppDisplayName],
                        [self extensionDisplayNameForExtensionIndex:extensionIndex],
                        [self ownerAppDisplayName]];
    
    return answer;
}

/*!
 @details  I just took a good educated guess as to what should be in here after
 comparing the implementations in ExtoreChromy and ExtoreOpera.  Luckily,
 it worked :)  (Fixed in BkmkMgrs 2.3.7, was not implemented before that.)
 */
- (NSArray*)keyPathsInChecksum {
    return  @[
              @"bookmark_bar",
              @"other",
              @"synced",
              @"trash"] ;
}

@end
