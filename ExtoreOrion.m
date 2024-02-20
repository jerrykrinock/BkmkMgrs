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

@end
