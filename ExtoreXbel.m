#import "ExtoreXbel.h"
#import "Stark.h"
#import "NSError+InfoAccess.h"
#import "XbelDecoder.h"
#import "XbelEncoder.h"
#import "OperationExport.h"
#import "NSError+MyDomain.h"

static const ExtoreConstants extoreConstants = {
	/* canEditAddDate */                  YES,
	/* canEditComments */                 BkmxCanEditInStyleEither,
	/* canEditFavicon */                  YES,
	/* canEditFaviconUrl */               NO,
	/* canEditIsAutoTab */                NO,
	/* canEditIsExpanded */               YES,
	/* canEditIsShared */                 NO,
	/* canEditLastChengDate */            NO,
	/* canEditLastModifiedDate */         YES,
	/* canEditLastVisitedDate */          YES,
	/* canEditName */                     YES,
	/* canEditRating */                   NO,
	/* canEditRssArticles */              NO,
    /* canEditSeparators */               BkmxCanEditInStyleEither,
	/* canEditShortcut */                 BkmxCanEditInStyleNeither,
	/* canEditTags */                     BkmxCanEditInStyleNeither,
	/* canEditUrl */			          YES,
	/* canEditVisitCount */               NO,
	/* canCreateNewDocuments */           YES,
	/* ownerAppDisplayName */             @".xbel",
	/* webHostName */                     nil,
	/* authorizationMethod */             BkmxAuthorizationMethodNone,
	/* accountNameHint */                 nil,
	/* oAuthConsumerKey */                nil,
	/* oAuthConsumerSecret */             nil,
	/* oAuthRequestTokenUrl */            nil,
	/* oAuthRequestAccessUrl */           nil,
	/* oAuthRealm */                      nil,
	/* appSupportRelativePath */          nil,
	/* defaultFilename */                 nil,
	/* defaultProfileName */              nil,
	/* iconResourceFilename */            nil,
	/* iconInternetURL */                 nil,
	/* fileType */                        @"xbel",
	/* ownerAppObservability */           OwnerAppObservabilityNone,
	/* canPublicize */                    NO,
	/* silentlyRemovesDuplicates */       NO,
	/* normalizesURLs */                  NO,
	/* catchesChangesDuringSave */        NO,
	/* telltaleString */                  @"<!DOCTYPE xbel>",
	/* hasBar */                          YES,
	/* hasMenu */                         YES,
	/* hasUnfiled */                      YES,
	/* hasOhared */                       YES,
	/* tagDelimiter */                    nil,
	/* dateRef1970Not2001 */              NO, // Actually does not apply, since dates use ISO 8601 format, i.e. 1994-11-05T08:15:30-05:00
	/* hasOrder */                        YES,
	/* hasFolders */                      YES,
	/* ownerAppIsLocalApp */              YES, // Actually it's no app.  Maybe need a new value here?
	/* defaultSpecialOptions */           0x0000000000000000LL,
	/* extensionInstallDirectory */       nil,
	/* minBrowserVersionMajor */          0,
	/* minBrowserVersionMinor */          0,
	/* minBrowserVersionBugFix */         0,
	/* minSystemVersionForBrowsMajor */   0,
	/* minSystemVersionForBrowMinor */    0,
	/* minSystemVersionForBrowBugFix */   0
} ;


@implementation ExtoreXbel

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

+ (BOOL)parentSharype:(Sharype)parentSharype
  canHaveChildSharype:(Sharype)childSharype {
	BOOL answer = ((parentSharype & (SharypeGeneralContainer)) > 0) ;
	return answer ;
}

+ (BkmxIxportTolerance)toleranceForIxportStyle:(NSInteger)ixportStyle {
	BkmxIxportTolerance tolerance = BkmxIxportToleranceAllowsNone ;
	if (ixportStyle == 1) {
		tolerance = BkmxIxportToleranceAllowsReading + BkmxIxportToleranceAllowsWriting ;
	}
	
	return tolerance ;
}

+ (PathRelativeTo)fileParentPathRelativeTo {
	return PathRelativeToNone ;
}

+ (NSString*)fileParentRelativePath {
	return nil ;
}

- (BOOL)isExportableStark:(Stark*)stark
			   withChange:(NSDictionary*)change {
#if IS_EXPORTABLE_STARK_WILL_ALWAYS_RETURN_YES
	return YES  ;
#endif
	
	// Xbel does not support Smart Bookmarks.
	if ([stark sharypeValue] == SharypeSmart) {
		return NO ;
	}
	else if ([stark is1PasswordBookmarklet]) {
		return NO ;
	}		
	
	return YES ;
}

#if 0
// The following was deleted as of BookMacster 1.3.2
// It is problematic because, while XBEL files allow
// duplicates, this method will give the same exid
// for duplicate starks.  So we now use the base
// class default exids (uuids) instead.
- (NSString*)cheesyExidForStark:(Stark*)stark {
	NSString* signature = [[stark lineageNamesDoSelf:YES
											 doOwner:NO] componentsJoinedByString:@""] ;
	NSString* exid = [signature md5HashAsLowercaseHex] ;
	return exid ;
}
- (void)getFreshExid_p:(NSString**)exid_p
            higherThan:(NSInteger)higherThan
              forStark:(Stark*)stark
               tryHard:(BOOL)tryHard {
	*exid_p = [self cheesyExidForStark:stark] ;
}
#endif

- (void)readExternalStyle1ForPolarity:(BkmxIxportPolarity)polarity
                    completionHandler:(void(^)(void))completionHandler {
	[self setError:nil] ;
	
	NSError* error = nil ;

	NSString* path = [self workingFilePathError_p:&error] ;
	NSData* data = nil ;
	BOOL ok = NO ;

	if (!path) {
		error = [SSYMakeError(518375, @"No path") errorByAddingUnderlyingError:error] ;
		[self setError:error] ;
		goto end ;
	}
	else {
		data = [NSData dataWithContentsOfFile:path
									  options:NSMappedRead
										error:&error] ;
	}
	
	if (!data)	{
		error = [SSYMakeError(845132, @"No data") errorByAddingUnderlyingError:error] ;
		error = [error errorByAddingUserInfoObject:path
											forKey:@"Path"] ;
		[self setError:error] ;
		goto end ;
	}
	else {
		ok = [XbelDecoder decodeData:data
							  extore:self
							 error_p:&error] ;
	}

	if (!ok)	{
		error = [SSYMakeError(654784, @"Error parsing XBEL") errorByAddingUnderlyingError:error] ;
		error = [error errorByAddingUserInfoObject:path
											forKey:@"Path"] ;
		[self setError:error] ;
		goto end ;
	}

end:;
	completionHandler() ;
}

+ (BOOL)canProbablyImportFileType:type
							 data:data {
	if (![type isEqualToString:@"plist"]) {
		return NO ;
	}
    if (!data) {
        return NO ;
    }
	
	NSDictionary* root = [NSPropertyListSerialization propertyListWithData:data
                                                                   options:NSPropertyListImmutable
                                                                    format:NULL
                                                                     error:NULL] ;
	if ([root objectForKey:[self constants_p]->telltaleString]) {
		return YES ;
	}
	
	return NO ;
}

- (void)writeUsingStyle1InOperation:(SSYOperation*)operation {
	NSError* error = nil ;
	NSData* data ;
    BOOL ok = [XbelEncoder generateXbelExportData_p:&data
                                             extore:self
                                            error_p:&error] ;
	if (ok) {		
		NSString* path = [self workingFilePathError_p:&error] ;
		ok = (path != nil) ;
		if (ok) {
			ok = [self writeData:data
						  toFile:path] ;
		}
	}
	
	if (!ok) {
		[self setError:error] ;
	}
	
	[operation writeAndDeleteDidSucceed:ok] ;
}

@end
