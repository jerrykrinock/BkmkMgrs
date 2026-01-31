#import "ExtoreZen.h"
#import "BkmxGlobals.h"
#import "NSError+MyDomain.h"

static const ExtoreConstants extoreConstants = {
	/* canEditAddDate */                  NO, // See Note 190352
	/* canEditComments */                 BkmxCanEditInStyle1Only,
	/* canEditFavicon */                  YES,
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
	/* canEditVisitCount */               NO,
	/* canCreateNewDocuments */           YES,
	/* ownerAppDisplayName */             @"Zen Browser",
	/* webHostName */                     nil,
	/* authorizationMethod */             BkmxAuthorizationMethodNone,
	/* accountNameHint */                 nil,
	/* oAuthConsumerKey */                nil,
	/* oAuthConsumerSecret */             nil,
	/* oAuthRequestTokenUrl */            nil,
	/* oAuthRequestAccessUrl */           nil,
	/* oAuthRealm */                      nil,
	/* appSupportRelativePath */          @"zen",
	/* defaultFilename */                 @"places.sqlite",
	/* defaultProfileName */              @"default",
	/* iconResourceFilename */            nil,
	/* iconInternetURL */                 nil,
	/* fileType */                        @"sqlite",
	/* ownerAppObservability */           0, // Do not use!! Use class method instead
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
	/* minBrowserVersionMajor */          0,
	/* minBrowserVersionMinor */          0,
	/* minBrowserVersionBugFix */         0,
	/* minSystemVersionForBrowsMajor */   0,
	/* minSystemVersionForBrowMinor */    0,
	/* minSystemVersionForBrowBugFix */   0
} ;


@implementation ExtoreZen

+ (const ExtoreConstants *)constants_p {
	return &extoreConstants ;
}

+ (NSArray*)browserBundleIdentifiers {
    return @[@"app.zen-browser.zen"] ;
}

#pragma mark - Profile Discovery

/*
 Returns the path to Zen's Application Support directory for a given home path.
 */
+ (NSString*)zenAppSupportPathForHomePath:(NSString*)homePath {
    if (!homePath) {
        homePath = NSHomeDirectory() ;
    }
    return [[homePath stringByAppendingPathComponent:@"Library/Application Support"] stringByAppendingPathComponent:@"zen"] ;
}

/*
 Returns the path to Zen's profiles.ini file for a given home path.
 */
+ (NSString*)profilesIniPathForHomePath:(NSString*)homePath {
    return [[self zenAppSupportPathForHomePath:homePath] stringByAppendingPathComponent:@"profiles.ini"] ;
}

/*
 Parses the Zen profiles.ini file and returns an array of dictionaries,
 each containing the profile info (Name, Path, IsRelative, Default).
 Zen uses the same profiles.ini format as Firefox.
 */
+ (NSArray*)profileDictionariesForHomePath:(NSString*)homePath {
    NSString* profilesIniPath = [self profilesIniPathForHomePath:homePath] ;
    NSString* contents = [NSString stringWithContentsOfFile:profilesIniPath
                                                   encoding:NSUTF8StringEncoding
                                                      error:nil] ;
    if (!contents) {
        return nil ;
    }

    NSMutableArray* profiles = [NSMutableArray array] ;
    NSMutableDictionary* currentProfile = nil ;

    for (NSString* line in [contents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]) {
        NSString* trimmedLine = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] ;

        // Check for section header like [Profile0], [Profile1], etc.
        if ([trimmedLine hasPrefix:@"[Profile"]) {
            if (currentProfile) {
                [profiles addObject:currentProfile] ;
            }
            currentProfile = [NSMutableDictionary dictionary] ;
        }
        else if (currentProfile && [trimmedLine containsString:@"="]) {
            NSArray* parts = [trimmedLine componentsSeparatedByString:@"="] ;
            if ([parts count] >= 2) {
                NSString* key = [parts[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] ;
                NSString* value = [[parts subarrayWithRange:NSMakeRange(1, [parts count] - 1)] componentsJoinedByString:@"="] ;
                value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] ;
                currentProfile[key] = value ;
            }
        }
    }

    // Don't forget the last profile
    if (currentProfile) {
        [profiles addObject:currentProfile] ;
    }

    return profiles ;
}

+ (NSArray*)profilePseudonyms:(NSString*)homePath {
    NSArray* profileDicts = [self profileDictionariesForHomePath:homePath] ;
    NSMutableArray* pseudonyms = [NSMutableArray array] ;

    for (NSDictionary* profileDict in profileDicts) {
        NSString* path = profileDict[@"Path"] ;
        if (path) {
            [pseudonyms addObject:[path lastPathComponent]] ;
        }
    }

    return pseudonyms ;
}

+ (NSArray*)profileNames {
    return [self profileNamesForHomePath:nil] ;
}

+ (NSArray*)profileNamesForHomePath:(NSString*)homePath {
    NSArray* profileDicts = [self profileDictionariesForHomePath:homePath] ;
    NSMutableArray* names = [NSMutableArray array] ;

    for (NSDictionary* profileDict in profileDicts) {
        NSString* name = profileDict[@"Name"] ;
        if (name) {
            [names addObject:name] ;
        }
    }

    return names ;
}

+ (NSString*)displayedSuffixForProfileName:(NSString*)profileName
                                  homePath:(NSString*)homePath {
    // For Zen, return the profile name as the suffix if there are multiple profiles
    NSArray* profileNames = [self profileNamesForHomePath:homePath] ;
    if ([profileNames count] > 1) {
        return [NSString stringWithFormat:@" (%@)", profileName];
    }
    return @"" ;
}

+ (NSString*)pathForProfileName:(NSString*)profileName
                       homePath:(NSString*)homePath
                        error_p:(NSError**)error_p {
    NSArray* profileDicts = [self profileDictionariesForHomePath:homePath] ;

    for (NSDictionary* profileDict in profileDicts) {
        NSString* name = profileDict[@"Name"] ;
        if ([name isEqualToString:profileName]) {
            NSString* path = profileDict[@"Path"] ;
            NSString* isRelative = profileDict[@"IsRelative"] ;

            if ([isRelative isEqualToString:@"1"]) {
                // Path is relative to the Zen app support directory
                NSString* zenPath = [self zenAppSupportPathForHomePath:homePath] ;
                return [zenPath stringByAppendingPathComponent:path] ;
            } else {
                // Path is absolute
                return path ;
            }
        }
    }

    if (error_p) {
        *error_p = [NSError errorWithDomain:[NSError myDomain]
                                       code:847301
                                   userInfo:@{
                                       NSLocalizedDescriptionKey: [NSString stringWithFormat:
                                           @"Could not find Zen Browser profile named '%@'", profileName]
                                   }] ;
    }

    return nil ;
}

@end
