#import "ExtoreOperaAir.h"

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
    /* canEditUrl */                      YES,
    /* canEditVisitCount */               NO,
    /* canCreateNewDocuments */           YES,
    /* ownerAppDisplayName */             @"Opera Air",
    /* webHostName */                     nil,
    /* authorizationMethod */             BkmxAuthorizationMethodNone,
    /* accountNameHint */                 nil,
    /* oAuthConsumerKey */                nil,
    /* oAuthConsumerSecret */             nil,
    /* oAuthRequestTokenUrl */            nil,
    /* oAuthRequestAccessUrl */           nil,
    /* oAuthRealm */                      nil,
    /* appSupportRelativePath */          @"com.operasoftware.OperaAir",
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
    /* hasMenu */                         YES,
    /* hasUnfiled */                      YES,
    /* hasOhared */                       YES,
    /* tagDelimiter */                    nil,
    /* dateRef1970Not2001 */              YES,
    /* hasOrder */                        YES,
    /* hasFolders */                      YES,
    /* ownerAppIsLocalApp */              YES,
    /* defaultSpecialOptions */           0x0000000000000000LL,
    /* extensionInstallDirectory */       @"Extensions",
    /* minBrowserVersionMajor */          37,
    /* minBrowserVersionMinor */          0,
    /* minBrowserVersionBugFix */         0,
    /* minSystemVersionForBrowsMajor */   0,
    /* minSystemVersionForBrowMinor */    0,
    /* minSystemVersionForBrowBugFix */   0
} ;

@implementation ExtoreOperaAir

/*
 The following implementation is the same in all subclasses, but we define it
 in each subclass in order to pick up the static variables which are different
 in each Extore subclass' implementation file.
 */
+ (const ExtoreConstants *)constants_p {
    return &extoreConstants ;
}

+ (NSArray*)browserBundleIdentifiers {
    return [NSArray arrayWithObject:@"com.operasoftware.OperaAir"] ;
}

+ (NSString*)fileParentRelativePath {
    /* Return name of subfolder in ~/Library/Application Support/ */
    return @"com.operasoftware.OperaAir" ;
}

@end
