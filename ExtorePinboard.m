#import "ExtorePinboard.h"
#import "SSWebBrowsing.h"
#import "Client.h"
#import "Stark.h"
#import "NSString+BkmxURLHelp.h"
#import "NSString+SSYExtraUtils.h"

static const ExtoreConstants extoreConstants = {
	/* canEditAddDate */                  YES,
	/* canEditComments */                 BkmxCanEditInStyleEither,
	/* canEditFavicon */                  NO,
	/* canEditFaviconUrl */               NO,
	/* canEditIsAutoTab */                NO,
	/* canEditIsExpanded */               NO,
	/* canEditIsShared */                 YES,
	/* canEditLastChengDate */            NO,
	/* canEditLastModifiedDate */         NO,
	/* canEditLastVisitedDate */          NO,
	/* canEditName */                     YES,
	/* canEditRating */                   NO,
	/* canEditRssArticles */              NO,
    /* canEditSeparators */               BkmxCanEditInStyleNeither,
	/* canEditShortcut */                 BkmxCanEditInStyleNeither,
	/* canEditTags */                     BkmxCanEditInStyleEither,
	/* canEditUrl */			          YES,
	/* canEditVisitCount */               NO,
	/* canCreateNewDocuments */           NO,
	/* ownerAppDisplayName */             @"Pinboard",
	/* webHostName */                     @"pinboard.in",
	/* authorizationMethod */             BkmxAuthorizationMethodHttpAuth,
	/* accountNameHint */                 @"Username",
	/* oAuthConsumerKey */                nil,
	/* oAuthConsumerSecret */             nil,
	/* oAuthRequestTokenUrl */            nil,
	/* oAuthRequestAccessUrl */           nil,
	/* oAuthRealm */                      nil,
	/* appSupportRelativePath */          nil,
	/* defaultFilename */                 @"https://api.pinboard.in/v1/",
	/* defaultProfileName */              nil,
	/* iconResourceFilename */            nil,
	/* iconInternetURL */                 @"http://pinboard.in/bluepin.gif",
	/* fileType */                        nil,
	/* ownerAppObservability */           OwnerAppObservabilityNone,
	/* canPublicize */                    YES,
	/* silentlyRemovesDuplicates */       YES,
	/* normalizesURLs */                  NO,
	/* catchesChangesDuringSave */        YES,
	/* telltaleString */                  nil,
	/* hasBar */                          NO,
	/* hasMenu */                         NO,
	/* hasUnfiled */                      NO,
	/* hasOhared */                       NO,
	/* tagDelimiter */                    @" ",
	/* dateRef1970Not2001 */              NO,
	/* hasOrder */                        NO,
	/* hasFolders */                      NO,
	/* ownerAppIsLocalApp */              NO,
	/* defaultSpecialOptions */           0x0000000000000000LL,
	/* extensionInstallDirectory */       nil,
	/* minBrowserVersionMajor */          0,
	/* minBrowserVersionMinor */          0,
	/* minBrowserVersionBugFix */         0,
	/* minSystemVersionForBrowsMajor */   0,
	/* minSystemVersionForBrowMinor */    0,
	/* minSystemVersionForBrowBugFix */   0
} ;


@implementation ExtorePinboard

/*
 This implementation is the same in all subclasses, but we define it
 in each subclass in order to pick up the static const extoreConstants
 struct which is different in each Extore subclass' implementation file.
 */
+ (const ExtoreConstants *)constants_p {
	return &extoreConstants ;
}

+ (NSArray*)browserBundleIdentifiers {
    return nil ;
}

- (NSTimeInterval)requestsAllMinimumTimeInterval {
#ifdef LOCAL_FILE_PATH_TO_OVERRIDE_EXTOREWEBFLAT_DOWNLOAD
	return 0.0 ;
#else
	// As specified ("five minutes") in http://pinboard.in/api/
	return 300.0 ;
#endif
}

- (BOOL)givesHttpError429WhenAllPostsHaveBeenSent {
	return YES ;
}

- (BOOL)itemNotFoundIndicatedByData:(NSData*)data {
	BOOL answer = NO ;
	/* When Pinboard cannot find a specified URL, it returns data looking something like this:
	 <?xml version="1.0" encoding="UTF-8" ?>
	 <result code="item not found" />
	 <!-- generated 02/18/12 23:02:49 UTC -->	
	Yes, I know I should use an NSXMLParser for this but the business
	 manager says we have more important things to do. */
	NSString* responseString = [[NSString alloc] initWithData:data
													 encoding:NSUTF8StringEncoding] ;
	if ([responseString containsString:@"\"item not found\""]) {
		answer = YES ;
	}
	[responseString release] ;
    
	return answer ;
}

- (void)getFreshExid_p:(NSString**)exid_p
            higherThan:(NSInteger)higherThan
              forStark:(Stark*)stark
               tryHard:(BOOL)tryHard {
	*exid_p = [[stark url] md5HashAsLowercaseHex] ;
}

- (void)viewOnline {
	NSString* url = [@"http://pinboard.in/u:" stringByAppendingString:[[self clientoid] profileName]] ;
	[SSWebBrowsing browseToURLString:url
			 browserBundleIdentifier:nil
							activate:YES] ;
}

- (NSSet*)throttledErrorCodes {
	return [NSSet setWithObjects:
			[NSNumber numberWithInteger:429],
			nil] ;
}

- (NSString*)urlToCreateNewAccount {
	return @"http://pinboard.in/signup/" ;
}

- (NSString*)keyLastPostsAll {
	NSString* key = [@"pinboard" stringByAppendingString:[super keyLastPostsAll]] ;
	return key ;
}

- (BOOL)isExportableStark:(Stark*)stark
			   withChange:(NSDictionary*)change {
#if IS_EXPORTABLE_STARK_WILL_ALWAYS_RETURN_YES
	return YES  ;
#endif
	
	// Superclass ExtoreWebFlat disallows exporting of folders, separators
	// and 1Password Bookmarklets.
	if (![super isExportableStark:stark
					   withChange:change]) {
		return NO ;
	}
	
	NSString* url = [stark url] ;
	if (!url) {
		return NO ;
	}
	
	// For Google, we remove all candidates which have a non-HTTP or empty URL.
	// (The latter result from non-HTTP bookmarks downloaded from Google.)
	// In the case of uploading, we don't want to overwrite a non-HTTP bookmark which has a URL
	// In the case of deleting, we cannot distinguish between non-HTTP bookmarks that don't
	// have a URL, so the ...SameUrl... methods will return the first bookmark
	// found with no URL, not necessarily the correct target, so the wrong bookmark may be
	// deleted.
	// Actually, there are other kinds of url which Google will return an empty string
	// for, for example something such as "http://%20www.junk.com"
	// But I don't have time right now to find them all.  
	// Testing with
	//      [NSURL urlWithString:[bookmark url]] != nil 
	// is not the answer because it allows file:///, feed://, ftp://, about:blank and some javascript:// urls
	
	return YES ;
}

/*
 @details   Added this implementationin BookMacster 1.13.1 when I disocvered
 that changing the name of a bookmark, or adding tags, and then add/uploading
 it caused no change at Pinboard.
 */
- (BOOL)changedBookmarksMustBeDeleted {
	return YES ;
}



@end
