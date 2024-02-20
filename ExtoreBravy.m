#import "ExtoreBravy.h"
#import "StarkTyper.h"
#import "BkmxGlobals.h"
#import "Starker.h"
#import "SSYVersionTriplet.h"
#import "BkmxBasis.h"
#import "NSString+MorePaths.h"

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
	/* ownerAppDisplayName */             @"Brave",
	/* webHostName */                     nil,
	/* authorizationMethod */             BkmxAuthorizationMethodNone,
	/* accountNameHint */                 nil,
	/* oAuthConsumerKey */                nil,
	/* oAuthConsumerSecret */             nil,
	/* oAuthRequestTokenUrl */            nil,
	/* oAuthRequestAccessUrl */           nil,
	/* oAuthRealm */                      nil,
	/* appSupportRelativePath */          @"BraveSoftware/Brave-Browser",
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
	/* hasMenu */                         YES,  // See Note Other-Menu
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

@implementation ExtoreBravy

/*
 The following implementation is the same in all subclasses, but we define it
 in each subclass in order to pick up the static variables which are different
 in each Extore subclass' implementation file.
 */
+ (const ExtoreConstants *)constants_p {
	return &extoreConstants ;
}

+ (NSArray*)browserBundleIdentifiers {
    return [NSArray arrayWithObject:@"com.brave.Browser"] ;
}

+ (NSString*)fileParentRelativePath {
	return @"" ; // empty because the Bookmarks file is inside the profile folder
}

+ (PathRelativeTo)fileParentPathRelativeTo {
    return PathRelativeToProfile ;
}

+ (NSString*)extraBrowserSupportPathForSpecialManifest {
    return [[[NSString applicationSupportPathForHomePath:nil] stringByAppendingPathComponent:@"Google"]  stringByAppendingPathComponent:@"Chrome"];
}

/*!
 @details  Even for Brave Versions 1.2-1.6 which did not use "Other
 Bookmarks", Brave will reject our Style 1 export and reset to empty
 bookmarks.  Same behavior as Vivaldi.  Therefore it is important that we
 override this method and *not* include @"other". */
- (NSSet*)hartainersWeEdit {
    return [NSSet setWithObjects:
            @"bookmark_bar",
            nil] ;
}

- (Stark*)fosterParentForStark:(Stark *)stark {
    /* Brave puts everything in the bar. */
    return [[self starker] bar] ;
}

+ (BOOL)syncExtensionAvailable {
    return YES ;
}

- (BOOL)hasMenu {
    BOOL answer;
    NSString* caseID;
    switch (self.ixportStyle) {
        case 2: {
            answer = self.menuWasOnDisk;
            caseID = @"IsOnDisk";
            break;
        }
        case 1: {
            if (!self.menuWasOnDisk) {
                /* The way Brave (and Chrome) works today, this will never
                happen, because the 'other' hartainer is always in the
                 Bookmarks file, even if it is not used.  So, this branch
                 should never execute.  But just in case they change, it… */
                answer = NO;
                caseID = @"NotOnDisk";
                break;
            }
            // intentionally no break;
        }
        default: { // presumably 0, style unknown due to no import or export yet
            NSString* bundleIdentifier = [[[self class] browserBundleIdentifiers] firstObject];
            NSString* versionString = [SSYVersionTriplet rawVersionStringFromBundleIdentifier:bundleIdentifier];
            /* Today, Brave 1.7, Brave prefixes its version string with the
             Chromium version and a dot.  For example, if versionString is
             "80.1.5.2", this means Chromium 80, Brave 1.5.2.  So we need to
             ignore the first component. */
            NSArray* versionParts = [versionString componentsSeparatedByString:@"."];
            if (versionParts.count == 4) {
                versionParts = [versionParts subarrayWithRange:NSMakeRange(1,3)];
                versionString = [versionParts componentsJoinedByString:@"."];
            }
            SSYVersionTriplet* versionTriplet = [SSYVersionTriplet versionTripletFromString:versionString];
            if (versionTriplet) {
                SSYVersionTriplet* v1_2 = [SSYVersionTriplet versionTripletWithMajor:1
                                                                               minor:2
                                                                              bugFix:0];
                if ([versionTriplet isEarlierThan:v1_2]) {
                    answer = YES;
                    caseID = @"Brave<1.2";
                } else {
                    SSYVersionTriplet* v1_7 = [SSYVersionTriplet versionTripletWithMajor:1
                                                                                   minor:7
                                                                                  bugFix:0];
                    if ([versionTriplet isEarlierThan:v1_7]) {
                        answer = NO;
                        caseID = @"1.2<Brave<1.7";
                    } else {
                        answer = YES;
                        caseID = @"Brave>1.7";
                    }
                }
            } else {
                /* Brave 1.7 is scheduled for release on 2020-Apr-07.  Assume
                 that most people will have it in three days.  Set threshold
                 to 2020-Apr-10. */
                NSTimeInterval secs2020_04_10 = 1586476800.0;
                NSDate* threshold = [NSDate dateWithTimeIntervalSince1970:secs2020_04_10];
                if ([[NSDate date] isGreaterThan:threshold]) {
                    /* Assume they have Brave 1.7+ */
                    answer = YES;
                    caseID = @"date>Apr10";
                } else {
                    answer = NO;
                    caseID = @"date<Apr10";
                }
            }
            break;
        }
    }
    
    NSString* classID;
    NSString* className = [self className];
    if ([className hasSuffix:@"Public"]) {
        classID = @"Publ";
    } else if ([className hasSuffix:@"Beta"]) {
        classID = @"Beta";
    } else {
        classID = className;
        NSLog(@"Internal Error 283-2374");
    }
    NSString* msg = [NSString stringWithFormat:
                     @"Brave %@ %@ menu : style=%ld %@",
                     classID,
                     answer ? @"HAS" : @"NO",
                     self.ixportStyle,
                     caseID];
    [[BkmxBasis sharedBasis] logString:msg];
    
    return answer;
}


@end

/* Note Other-Menu

The Bookmarks file always contains the "Other" hard folder, probably because it
inherits it from Chromium.  But it is not used in Brave versions 1.2 - 1.6.
It does not appear in the user interface, and there is no way to add items to
it.  But in Brave 1.7, they brought it back.
Original issue, removing it:
https://github.com/brave/brave-browser/issues/5158
Some users complained…
https://community.brave.com/t/other-bookmarks/101541/2
And there was a follow-up.
https://github.com/brave/brave-browser/issues/7115
*/

