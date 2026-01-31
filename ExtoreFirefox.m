#import "ExtoreFirefox.h"
#import "SSYFirefoxProfiler.h"
#import "BkmxGlobals.h"

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

#pragma mark - Profile Discovery (delegating to SSYFirefoxProfiler)

+ (NSArray*)profilePseudonyms:(NSString*)homePath {
    return [[SSYFirefoxProfiler profilePseudonymsForHomePath:homePath] valueForKey:@"lastPathComponent"] ;
}

+ (NSArray*)profileNames {
    return [SSYFirefoxProfiler profileNames] ;
}

+ (NSString*)displayedSuffixForProfileName:(NSString*)profileName
                                  homePath:(NSString*)homePath {
    NSString* answer =[SSYFirefoxProfiler displayedSuffixForProfileName:profileName
                                                               homePath:homePath] ;
    return answer ;
}

+ (NSString*)pathForProfileName:(NSString*)profileName
                       homePath:(NSString*)homePath
                        error_p:(NSError**)error_p {
    return [SSYFirefoxProfiler pathForProfileName:profileName
                                         homePath:homePath
                                          error_p:error_p] ;
}

@end
