#import "ExtoreEpic.h"
#import "StarkTyper.h"
#import "BkmxGlobals.h"
#import "BkmxBasis.h"

static const ExtoreConstants extoreConstants = {
    /* canEditAddDate */                  NO, // See Note 190352
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
    /* ownerAppDisplayName */             @"Epic",
    /* webHostName */                     nil,
    /* authorizationMethod */             BkmxAuthorizationMethodNone,
    /* accountNameHint */                 nil,
    /* oAuthConsumerKey */                nil,
    /* oAuthConsumerSecret */             nil,
    /* oAuthRequestTokenUrl */            nil,
    /* oAuthRequestAccessUrl */           nil,
    /* oAuthRealm */                      nil,
    /* appSupportRelativePath */          @"HiddenReflex/Epic",
    /* defaultFilename */                 @"Bookmarks",
    /* defaultProfileName */              @"Default",
    /* iconResourceFilename */            nil,
    /* iconInternetURL */                 nil,
    /* fileType */                        @"",
#if 0
    /* Use this if I ever get the extension working */
    /* ownerAppObservability */           OwnerAppObservabilitySpecialFile,
#else
    /* ownerAppObservability */           OwnerAppObservabilityBookmarksFile,
#endif
    /* canPublicize */                    NO,
    /* silentlyRemovesDuplicates */       NO,
    /* normalizesURLs */                  NO,
    /* catchesChangesDuringSave */        NO,
    /* telltaleString */                  @"checksum",
    /* hasBar */                          YES,
    /* hasMenu */                         YES,
    /* hasUnfiled */                      NO,
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


@implementation ExtoreEpic

/*
 The following implementation is the same in all subclasses, but we define it
 in each subclass in order to pick up the static variables which are different
 in each Extore subclass' implementation file.
 */
+ (const ExtoreConstants *)constants_p {
    return &extoreConstants ;
}

+ (NSArray*)browserBundleIdentifiers {
    return [NSArray arrayWithObject:@"com.hiddenreflex.Epic"] ;
}

+ (NSString*)fileParentRelativePath {
    return @"" ; // empty because the Bookmarks file is inside the profile folder
}

+ (PathRelativeTo)fileParentPathRelativeTo {
    return PathRelativeToProfile ;
}

+ (BOOL)syncExtensionAvailable {
#if 0
    /* Use this if I ever get the extension working */
    return [[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppBookMacster ;
#else
    return NO ;
#endif
}

/* Not used since Epic never approved my extension. */
- (NSString*)uninstallInstructionsForExtensionIndex:(NSInteger)extensionIndex {
    NSString* answer = [NSString stringWithFormat:
                        @"To uninstall the %@ extension:\n\n"
                        @"• Run %@.\n\n"
                        @"• Click in the menu: Window > Extensions.  A tab with a list of extensions will appear.\n\n"
                        @"• Click the trash can button adjacent '%@' and affirm the removal.\n\n"
                        @"• If you want the extension to be fully removed immediately, you must quit and then relaunch %@.",
                        [self extensionDisplayNameForExtensionIndex:extensionIndex],
                        [self ownerAppDisplayName],
                        [self extensionDisplayNameForExtensionIndex:extensionIndex],
                        [self ownerAppDisplayName]];

    return answer;
}

@end
