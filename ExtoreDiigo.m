#import <Bkmxwork/Bkmxwork-Swift.h>
#import "ExtoreDiigo.h"
#import "SSWebBrowsing.h"
#import "Client+SpecialOptions.h"
#import "Stark.h"
#import "NSString+URIQuery.h"
#import "HttpTalker.h"
#import "Starker.h"
#import "NSError+InfoAccess.h"
#import "NSString+LocalizeSSY.h"
#import "BkmxBasis+Strings.h"
#import "SSYProgressView.h"
#import "SSYMOCManager.h"
#import "NSString+VarArgs.h"
#import "NSArray+BSJSONAdditions.h"
#import "NSString+SSYExtraUtils.h"
#import "NSDate+Components.h"
#import "NSFileHandle+SSYExtras.h"
#import "NSArray+Whitespace.h"
#import "NSError+MoreDescriptions.h"
#import "NSError+MyDomain.h"
#import "NSError+Recovery.h"
#import "NSUserDefaults+MainApp.h"
#import "NSInvocation+Quick.h"
#import "WebAuthorizor.h"

static NSDateFormatter* static_diigoDateFormatter = nil ;


@interface NSString (Diigo)

- (NSString*)encodeForDiigo ;

@end

// Diigo API documentation says that the string values of a bookmark's
// 'title', 'url', 'tags' and 'desc' attributes are limited to 250
// characters.  However, if I browse in Firefox to a site which has a
// URL length of 547 characters,
// http://images.search.yahoo.com/images/view?back=http%3A%2F%2Fimages.search.yahoo.com%2Fsearch%2Fimages%3Fp%3Darchery%2520bow%26sp%3D1%26fr2%3Dsp-top%26y%3DSearch%26ei%3DUTF-8%26fr%3Dsfp%26x%3Dwrt%26js%3D1%26ni%3D21%26ei%3DUTF-8%26SpellState%3Dn-3780247932_q-A1WT%2FYu2nZqAp%2Fhjg8CaKQAAAA%40%40&w=300&h=300&imgurl=www.acasports.co.uk%2Fimages%2Farchery_singlebowpackage.jpg&rurl=http%3A%2F%2Fwww.acasports.co.uk%2Findex.php%3FcPath%3D260_443&size=12.8kB&name=archery_singlebowpackage.jpg&p=archery%20bow&type=JPG&oid=38296133709607f0&no=8&tt=83264
// add it to Diigo using the Diigo toolbar, and then email it
// to myself using the Diigo web app, I get not 250 but the first 512
// characters.  Furthermore, if I send this 512-character URL back to
// Diigo in a DELETE request, it works.  So it looks like maybe the
// limit has been increased to 512 since they wrote that document.
// Now, I can't imagine anyone having tags or a name that long.  A
// long URL is possible, but if Diigo doesn't accept it, the user is
// going to get unexpected results anyhow.  Well, so I set it at 2048.
// We'll see what happens.
#define DIIGO_MAX_STRING 2048

@implementation NSString (Diigo)

- (NSString*)encodeForDiigo {
	NSString* answer = [self encodePercentEscapesPerStandard:SSYPercentEscapeStandardRFC3986] ;
	answer = [answer substringToIndex:MIN([answer length], DIIGO_MAX_STRING)] ;
	return answer ;
}

@end



static NSString* const constBkmxDiigoAppKey = @"904fef01a43ef01f" ;

static const ExtoreConstants extoreConstants = {
	/* canEditAddDate */                  NO,  // See note Diigo324
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
	/* ownerAppDisplayName */             @"Diigo",
	/* webHostName */                     @"diigo.com",
	/* authorizationMethod */             BkmxAuthorizationMethodHttpAuth,
	/* accountNameHint */                 @"User Name",
	/* oAuthConsumerKey */                nil,
	/* oAuthConsumerSecret */             nil,
	/* oAuthRequestTokenUrl */            nil,
	/* oAuthRequestAccessUrl */           nil,
	/* oAuthRealm */                      nil,
	/* appSupportRelativePath */          nil,
	/* defaultFilename */                 @"https://secure.diigo.com/api/v2/",
	/* defaultProfileName */              nil,
	/* iconResourceFilename */            nil,
	/* iconInternetURL */                 @"http://www.diigo.com/favicon.ico", // For a better way, see http://codingclues.eu/2009/retrieve-the-favicon-for-any-url-thanks-to-google/
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
	/* tagDelimiter */                    @"\"",
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

/*
 Note Diigo324.  Diigo downloads contain an created_at attribute on
 each bookmark.  This is the last date that a bookmark was added in an upload.
 It's not what we want.  Example: Add a newborn bookmark at 8:50.  Upload it
 to Diigo at 9:01.  Now download it.  It will say that the created_at is 9:01,
 which won't match what our stark and will cause
 -supportedAttributesAreEqualComparingStark::: to return NO, resulting in
 spurious churning during imports and exports.
 */


#ifdef LOCAL_FILE_PATH_TO_OVERRIDE_EXTOREWEBFLAT_DOWNLOAD
#define DIIGO_DOWNLOAD_INTERVAL_TO_AVOID_BANNING 0
#else
#define DIIGO_DOWNLOAD_INTERVAL_TO_AVOID_BANNING 10
#endif

@implementation ExtoreDiigo

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

+ (NSArray*)defaultSpecialDoubles {
    return @[@1.0, @15.0, @1.1];
}

// Added in BookMacster 1.11
+ (NSString*)tagStringFromTagsArray:(NSArray*)array {
	NSMutableString* string = [[NSMutableString alloc] init] ;
	NSInteger i = 0 ;
	NSUInteger count = [array count] ;
	for (Tag* tag in array) {
		[string appendString:[tag.string doublequote]] ;
		if (++i < count) {
			[string appendString:@","] ;
		}
	}
	
	NSString* answer = [NSString stringWithString:string] ;
	[string release] ;
	
	return answer ;
}

// In BookMacster 1.11, I changed the tagDelimiterString for Diigo from ","
// to "\"".  That fixed exports, but broke imports, because they still use
// the comma when returning bookmarks.  So this fixes imports…
+ (NSArray*)tagArrayFromString:(NSString*)string {
	NSString* delimiter = @"," ;
	NSArray* array = [string componentsSeparatedByString:delimiter] ;
	array = [array arrayByTrimmingWhitespaceFromStringsAndRemovingEmptyStrings] ;
	
	return array ;
}

+ (NSDateFormatter*)dateFormatterForDiigo {
    if (!static_diigoDateFormatter) {
        static_diigoDateFormatter = [[NSDateFormatter alloc] init] ;
        //  Typical Diigo date: YYYY/MM/DD HH:MM:SS ±HHMM
        [static_diigoDateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss Z"] ;
        [static_diigoDateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]] ;
    }
    
    return static_diigoDateFormatter ;
}

- (BOOL)changedBookmarksMustBeDeleted {
	// Workaround for bug in Diigo…
	// http://feedback.diigo.com/forums/76543-bugs/suggestions/2704929-api-fails-to-change-title-of-bookmark
	// SUMMARY.  If you try and change the title of a bookmark using the
	// 'Save bookmark' command, it does not work unless the new title has
	// more characters than the old title.
	// Later, I also found another bug: Tags are not deleted.
	// Returning YES here works around that bug too.
	return YES ;
}

- (NSSet*)throttledErrorCodes {
	// Note: From Delicious 2, the expected "ban" error is:
	//    (Error Domain=SSYOAuthTalkerErrorDomain Code=153024)
	// with underlying error:
	//    (Error Domain=SSYSynchronousHttpErrorDomain Code=999)
	// However, since banning is the Delicious error you get
	// 90% of the time, and the other 10% is "No Internet",
	// I have a liberal interpretation of banning…
	return [NSSet setWithObjects:
			[NSNumber numberWithInteger:503],
			[NSNumber numberWithInteger:999],
			nil] ;
}

/*
 + (float)multiplierForHttpHighRateInitial {
	return 4.0 ;
}
*/

#define SECONDS_MARGIN_FOR_SERVER_CLOCK_ERRORS 15.0

- (NSDate*)decodeRetryDateFromData:(NSData*)rxData
						   error_p:(NSError**)error_p  {
    NSError* error = nil;
	NSDate* retryDate = nil ;
	if (rxData) {
        NSDictionary* dictionary = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:rxData
                                                                                  options:BkmxBasis.optionsForNSJSON
                                                                                    error:&error];
        if (!dictionary) {
            error = [SSYMakeError(284921, @"Could not decode Retry Date from Diigo") errorByAddingUnderlyingError: error];
        }
        
        NSString* messageFromDiigo = [dictionary objectForKey:@"message"] ;
		if (messageFromDiigo) {
			// If this is a throttling, messageFromDiigo is, for example:
			// "API Limit Exceeded. IP limit reached. Next reset at 2011-08-20 07:00:03 UTC"
			error = [error errorByAppendingLocalizedFailureReason:
						[NSString stringWithFormat:
						 @"Message from Diigo: \"%@\"",
						 messageFromDiigo]] ;
			NSString* lowercaseMessageFromDiigo = [messageFromDiigo lowercaseString] ;
			if (
				([lowercaseMessageFromDiigo containsString:@"api"])
				&& 
				([lowercaseMessageFromDiigo containsString:@"limit"])
				&& 
				([lowercaseMessageFromDiigo containsString:@"reset"])
				) {
                NSScanner* scanner = [[NSScanner alloc] initWithString:messageFromDiigo] ;
                [scanner setCharactersToBeSkipped:nil] ;
                [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet]
                                        intoString:NULL] ;
                NSInteger location = [scanner scanLocation] ;
                [scanner release] ;
                if ([messageFromDiigo length] > location + 19) {
                    NSString* dateString = [messageFromDiigo substringWithRange:NSMakeRange(location, 19)] ;
                    NSDateFormatter* aDateFormatter = [[NSDateFormatter alloc] init] ;
                    [aDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"] ;
                    [aDateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]] ;
                    retryDate = [aDateFormatter dateFromString:dateString] ;
                    [aDateFormatter release] ;
                    retryDate = [retryDate dateByAddingTimeInterval:SECONDS_MARGIN_FOR_SERVER_CLOCK_ERRORS] ;
                }
			}
		}
	}
    
    if (error && error_p) {
        *error_p = error ;
    }

	
	return retryDate ;
}

- (BOOL)talkToSubpathQuery:(NSString*)subpathQuery
				httpMethod:(NSString*)httpMethod
					client:(Client*)client
				   timeout:(CGFloat)timeout
			 receiveData_p:(NSData**)receiveData_p 
				   error_p:(NSError**)error_p {
#if 0
#define FAKE_DIIGO_THROTTLING 1
#warning Faking Diigo Throttling.  Do not ship this build!
    NSSet* methodsToThrottle = [NSSet setWithObjects:
                                // @"GET", // Uncomment to throttle bookmark downloads and login tests
                                @"POST", // Uncomment to throttle bookmark additions during exports
                                @"DELETE", // Uncomment to throttle bookmark deletions during exports
                                nil] ;
#endif

	// At one point, I thought that Diigo was failing my request and sending
	// a retry date that was in the past.  So I wrote the following loop to
	// retry in case they do that.  Later, I learned that the behavior I was
	// seeing was actually due to another mistake.  So, the following could
	// be simplified by removing the loop.  But from what I've seen of Diigo,
	// and since this code is tested I decided to just leave it in, because
	// you never know what kind of stupid thing Diigo will throw at you next.
	// The following loop might help.	
	NSInteger numberOfRetries = 0 ;
	BOOL ok ;
    NSError* error = nil ;
	BOOL done = NO ;
	while (done == NO) {
#ifdef FAKE_DIIGO_THROTTLING
        BOOL doFakeErrorThisTime = NO ;
        if ([methodsToThrottle member:httpMethod] != nil) {
            if ((ssyDebugGlobalInteger % 5) == 4) {
                doFakeErrorThisTime = YES ;
            }
        }
        ssyDebugGlobalInteger++ ;
#endif
#define DIIGO_REQUEST_TIMEOUT 125.6
		
#ifdef FAKE_DIIGO_THROTTLING
        if (doFakeErrorThisTime) {
            ok = NO ;
            error = SSYMakeError(400, @"API Limit Exceeded or something") ;
        }
        else {
            ok = [HttpTalker talkToSubpathQuery:subpathQuery
                                     httpMethod:httpMethod
                                         client:[self client]
                                        timeout:DIIGO_REQUEST_TIMEOUT  
                                  receiveData_p:receiveData_p
                                        error_p:&error] ;
        }
#else
        ok = [HttpTalker talkToSubpathQuery:subpathQuery
								 httpMethod:httpMethod
									 client:[self client]
									timeout:DIIGO_REQUEST_TIMEOUT
							  receiveData_p:receiveData_p
									error_p:&error] ;
#endif

		if (ok) {
			done = YES ;
		}
		else {
			NSDate* retryDate = [self decodeRetryDateFromData:*receiveData_p
                                                      error_p:&error] ;
#ifdef FAKE_DIIGO_THROTTLING
            if (doFakeErrorThisTime) {
                retryDate = [NSDate dateWithTimeIntervalSinceNow:30.0] ;
            }
#endif
			if (retryDate && ([error code] == 400)) {
				if (([retryDate timeIntervalSinceNow] > 0)) {
					// Retry date is in the future
                    NSString* errDesc = @"Diigo said our request has exceeded their limit." ;
                    error = [SSYMakeError(constBkmxErrorClientAPIThrottled, errDesc) errorByAddingUnderlyingError:error] ;
                    error = [error errorByAddingUserInfoObject:retryDate
                                                              forKey:SSYRetryDateErrorKey] ;
					done = YES ;
				}
				else if (numberOfRetries < 5) {
					// This branch never executes.  See comment above.
					// Retry date is in the past!!  Arghh!!  It should work!!  Wait a few seconds and Try again…
					sleep(3) ;
					numberOfRetries++ ;
				}
				else {
					done = YES ;
				}
			}
			else {
				done = YES ;
			}
		}
	}
	
	if (!ok) {
		error = [error errorByAddingUserInfoObject:[NSDate date]
												  forKey:SSYTimestampErrorKey] ;
		error = [error errorByAddingUserInfoObject:subpathQuery
												  forKey:@"Subpath Query"] ;
		error = [error errorByAddingUserInfoObject:httpMethod
												  forKey:@"HTTP Method"] ;
		[self handleHttpError:error
					requested:subpathQuery
						stark:nil
				 receivedData:*receiveData_p
			   prettyFunction:__PRETTY_FUNCTION__] ;
		// The above method returns its modified error in [self error].
		// But we need it in a local variable, so we do this…
		error = [self error] ;
		// Later, we'll re-write it to [self setError:] because that's how
		// other such errors work.
		// One of these days I need to straighten out that mess.
	}
	
    if (error && error_p) {
        *error_p = error ;
    }
    
	return ok ;
}

- (void)viewOnline {
	NSString* url = [@"http://www.diigo.com/user/" stringByAppendingString:[[self clientoid] profileName]] ;
	[SSWebBrowsing browseToURLString:url
			 browserBundleIdentifier:nil
							activate:YES] ;
}

- (NSString*)urlToCreateNewAccount {
	return @"https://secure.diigo.com/sign-up" ;
}

- (NSString*)keyLastPostsAll {
	NSString* key = [@"diigo" stringByAppendingString:[super keyLastPostsAll]] ;
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
	
	// Although there is no documentation of this on Diigo site, Diigo
	// returns HTTP Status 400 'Bad Request' with the following JSON value
	// for receive data:
	// "message":"Error detected. Please check your input. Contact service@diigo.com if there's any problem."
	// if you give it a file:// or ftp:// URL.  I presume that the only thing
	// Diigo accepts is HTTP.  So, I pasted in the following code
	// from the now-extince ExtoreGoogle's implementation of this method.
	// It will disallow such URLs and more.
	if (![url hasPrefix:@"http"]) {
		return NO ;
	}
	
	NSURL* uurl = [NSURL URLWithString:url] ;
	
	if ([[uurl fragment] hasPercentEscapeEncodedCharacters]) {
		return NO ;
	}
	
	if ([uurl port] != 0) {
		if ([[uurl host] isEqualToString:@"localhost"]) {
			return NO ;
		}
	}

	return YES ;
}

- (NSString*)encodedProfileName {
	return [[[self clientoid] profileName] encodeForDiigo] ;
}

#define BOOKMARKS_PER_CHUNK 100

- (BOOL)bookmarksFromDiigoStartIndex:(NSInteger)startIndex
							   data_p:(NSData**)data_p
							  error_p:(NSError**)error_p {	
	//Build the request string
	NSString* subpathQuery = [[NSString alloc] initWithFormat:@"bookmarks?user=%@&start=%ld&count=%ld&filter=all&key=%@",
						   // Note: parameters 'sort', 'tag' and 'list' are intentionally not passed
						   [self encodedProfileName],
						   (long)startIndex,
						   (long)BOOKMARKS_PER_CHUNK,
						   constBkmxDiigoAppKey] ; 
	
	NSData* data = nil ;
	NSError* error = nil ;
	BOOL ok = [self talkToSubpathQuery:subpathQuery
							httpMethod:@"GET"
								client:[self client]
							   timeout:20.0
						 receiveData_p:&data
							   error_p:&error] ;
	
	[subpathQuery release] ;
	
	if (data_p) {
		*data_p = data ;
	}
	if (error_p) {
		*error_p = error ;
	}
	
	return ok ;
}

- (NSDate*)dateWithDiigoDateString:(NSString*)string {
    NSDate* date = [[[self class] dateFormatterForDiigo] dateFromString:string] ;
	return date ;
}

- (void)setDownloadingProgressView:(SSYProgressView*)progressView
                          gotCount:(NSInteger)gotCount {
    progressView = [progressView setIndeterminate:YES
                                withLocalizedVerb:[NSString stringWithFormat:
                                                   @"Downloading bookmarks (got %ld)",
                                                   (long)gotCount]
                                         priority:SSYProgressPriorityRegular] ;
    [progressView setProgressBarWidth:245.0] ;
	[progressView setHasCancelButtonWithTarget:self
										action:@selector(cancel:)] ;
}

#if 0
#define READ_DIIGO_IMPORT_FROM_FILE 1
#else
#define READ_DIIGO_IMPORT_FROM_FILE 0
#endif

- (void)downloadStartingAtIndex:(NSInteger)startIndex
                   progressView:(SSYProgressView*)progressView
                   localStarker:(Starker*)localStarker
              completionHandler:(void(^)(void))completionHandler
              rawDataFileHandle:(NSFileHandle*)rawDataFileHandle
                       gotItems:(NSInteger)gotItems {
    BkmxTaskStatus status = BkmxTaskStatusNotDone ;
    BOOL ok = YES ;
    NSDate* resumeDate = nil ;
    if ([self error]) {
        status = BkmxTaskStatusAllDone ;
        ok = NO ;
    }
    else {
        NSError* error = nil ;
        NSData* dataChunk = nil ;
#if READ_DIIGO_IMPORT_FROM_FILE
        NSLog(@"11560 Using test data from webdata file") ;
        dataChunk = [NSData dataWithContentsOfFile:@"/Users/jk/Desktop/Temp/Diigo-8K.webData"] ;
        ok = YES ;
#else
        ok = [self bookmarksFromDiigoStartIndex:startIndex
                                         data_p:&dataChunk
                                        error_p:&error] ;
#endif
        if (!ok) {
            if (([error code] == constBkmxErrorClientAPIThrottled) && NSApp) {
                resumeDate = [[error userInfo] objectForKey:SSYRetryDateErrorKey] ;
                NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
                [formatter setTimeStyle:NSDateFormatterLongStyle] ;
                NSString* resumeDateString = [formatter stringFromDate:resumeDate] ;
                [formatter release] ;
                
                NSString* text = [NSString stringWithFormat:
                                  @"Got %ld items, throttled by Diigo!  Waiting until time %@",
                                  (long)(gotItems),
                                  resumeDateString] ;
                progressView = [progressView setIndeterminate:YES
                                            withLocalizedVerb:text
                                                     priority:SSYProgressPriorityRegular] ;
                [progressView setProgressBarWidth:50.0] ;
                [progressView setHasCancelButtonWithTarget:self
                                                    action:@selector(cancel:)] ;
                status = BkmxTaskStatusWaiting ;
                [self setError:nil] ;
            }
            else {
                if ([error code] == constBkmxErrorClientAPIThrottled) {
                    NSString* text ;
                    text= [NSString stringWithFormat:
                           @"Throttled by Diigo after downloading %ld items",
                           (long)(gotItems)] ;
                    error = [SSYMakeError(constBkmxErrorClientAPIThrottled, text) errorByAddingUnderlyingError:error] ;
                    text= [NSString stringWithFormat:
                           @"Browse to http://diigo.com, log in and see how many items you have.  "
                           @"Divide that number by %ld.  The result is the number of hours it will probably take to complete the import.  "
                           @"When you are ready to wait that long, launch %@ and import from %@. "
                           @"The process will not require your attention, but your Mac must be left running and your account logged in.",
                           (long)gotItems,
                           [[self clientoid] displayName],
                           [[BkmxBasis sharedBasis] appNameLocalized]
                           ] ;
                    error = [error errorByAddingLocalizedRecoverySuggestion:text] ;
                }
                
                [self setError:error] ;
                status = BkmxTaskStatusAllDone ;
                ok = NO ;
            }
        }
        
        NSString* stringChunk ;
        if (dataChunk) {
            if ([rawDataFileHandle offsetInFile] == 0) {
                NSString* header =
                @"This file may have '][' at chunk (request) boundaries.  "
                @"To use, replace all '][' with ',', and remove this line.  "
                @"You'll then have a file of JSON data.\n" ;
                [rawDataFileHandle writeData:[header dataUsingEncoding:NSUTF8StringEncoding]] ;
            }
            [rawDataFileHandle writeData:dataChunk] ;
            stringChunk = [[NSString alloc] initWithData:dataChunk
                                                encoding:NSUTF8StringEncoding] ;
        }
        else {
            stringChunk = nil ;
        }
        
        if (stringChunk && (status == BkmxTaskStatusNotDone)) {
            NSArray* diigoBookmarks = [NSArray arrayWithJSONString:stringChunk
                                                        accurately:NO] ;
#if READ_DIIGO_IMPORT_FROM_FILE
            NSLog(@"From file, got %ld items from %ld bytes (%ld chars)", [diigoBookmarks count], (long)[dataChunk length], (long)[stringChunk length]) ;
#else
            NSInteger lastStartIndex = startIndex ;
#endif
            for (NSDictionary* diigoBookmark in diigoBookmarks) {
                NSString* url = [diigoBookmark objectForKey:@"url"] ;
                if (url) {
                    Stark* stark = [localStarker freshStark] ;
                    [stark setSharypeValue:SharypeBookmark] ;
                    [stark setName:[diigoBookmark objectForKey:@"title"]] ;
                    [stark setUrl:url] ;
                    [stark setComments:[diigoBookmark objectForKey:@"desc"]] ;
                    NSString* tagsString = [diigoBookmark objectForKey:@"tags"] ;
                    if (![tagsString isEqualToString:@"no_tag"]) {
                        NSArray* tags = [[self class] tagArrayFromString:tagsString] ;
                        [[self localTagger] addTagStrings:[NSSet setWithArray:tags]
                                                       to:stark];
                    }
                    if ([[diigoBookmark objectForKey:@"shared"] isEqualToString:@"yes"]) {
                        [stark setIsShared:[NSNumber numberWithBool:YES]] ;
                    }
                    if ([[diigoBookmark objectForKey:@"readlater"] isEqualToString:@"yes"]) {
                        [stark setToRead:[NSNumber numberWithBool:YES]] ;
                    }
                    // Todo: What about Diigo's "comments" (not our "comments") and "annotations"?
                    [stark setFreshExidForExtore:self
                                         tryHard:NO] ;
                    
                    [stark setAddDate:[self dateWithDiigoDateString:[diigoBookmark objectForKey:@"created_at"]]] ;
                    [stark setLastModifiedDate:[self dateWithDiigoDateString:[diigoBookmark objectForKey:@"updated_at"]]] ;
                    
                    gotItems++ ;
                }
                
                startIndex++ ;
            }
#if READ_DIIGO_IMPORT_FROM_FILE
            status = BkmxTaskStatusAllDone ;
#else
            if (
                (startIndex == lastStartIndex)              // No bookmarks were just parsed
                ||
                ((startIndex % BOOKMARKS_PER_CHUNK) > 0)    // A remainder of bookmarks were just parsed
                ) {
                status = BkmxTaskStatusAllDone ;
            }
#endif
        }
        
        [stringChunk release] ;
    }
    
    if (status == BkmxTaskStatusAllDone) {
        [rawDataFileHandle closeFile] ;
        
        if (ok) {
            [self swallowDownload] ;
            [self saveLocalAndSyncToTrans];
        }
        else {
            // We don't want to leave a corrupt or, more likely, empty cache for this client,
            // because it will be used on the next Import.  So, we destroy it.
            [SSYMOCManager removeSqliteStoreForIdentifier:[[self clientoid] clidentifier]] ;
        }
        
        [progressView clearAll] ;
        
        completionHandler() ;
    }
    else {
        NSTimeInterval waitInterval ;
        if (status == BkmxTaskStatusNotDone) {
            [self setDownloadingProgressView:progressView
                                    gotCount:gotItems] ;
            waitInterval =  0.1 ; // Allow for Cancel button to be active.
        }
        else {
            waitInterval = [resumeDate timeIntervalSinceNow] ;
        }

        NSInvocation* invocation = [NSInvocation invocationWithTarget:self
                                                             selector:@selector(downloadStartingAtIndex:progressView:localStarker:completionHandler:rawDataFileHandle:gotItems:)
                                                      retainArguments:YES
                                                    argumentAddresses:&startIndex, &progressView, &localStarker, &completionHandler, &rawDataFileHandle, &gotItems] ;
        NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:waitInterval
                                                      invocation:invocation
                                                         repeats:NO] ;
        // Assign timer to instance variable so it can be cancelled.
        [self setRequestTimer:timer] ;
    }
}

- (void)swallowDownload {
    [[NSUserDefaults standardUserDefaults] setAndSyncMainAppValue:[NSDate date]
                                                           forKey:[self keyLastPostsAll]] ;
    
    NSError* saveError = nil ;
    BOOL savedOk = [[self localMoc] save:&saveError] ;
    if (!savedOk) {
        saveError = [SSYMakeError(77257, @"Failed moc save after inserting") errorByAddingUnderlyingError:saveError] ;
        [self setError:saveError] ;
    }
}

- (void)syncWebServerToLocalThenCompletionHandler:(void(^)(void))completionHandler {
    BOOL ok = YES ;
	NSError* error = nil ;
	SSYProgressView* progressView = [self progressView] ;
	
	if (![self localMoc]) {
		// [self error] should be already set

        // We don't want to leave a corrupt or, more likely, empty cache for this client,
        // because it will be used on the next Import.  So, we destroy it.
        [SSYMOCManager removeSqliteStoreForIdentifier:[[self clientoid] clidentifier]] ;
    
        [progressView clearAll] ;
        completionHandler() ;
	}
    else {
        [self clearLocalMoc];

        ok = [[self localMoc] save:&error] ;
        if (!ok) {
            if (!error) {
                NSString* msg = @"Failed moc save after deleting all" ;
                error = SSYMakeError(65054, msg) ;
            }
            [self setError:error] ;
            
            [progressView clearAll] ;
            completionHandler();
        }
        else {
            // Make sure it's not too soon since last time
            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults] ;
            NSDate* dateLastGotAll = [userDefaults syncAndGetMainAppValueForKey:[self keyLastPostsAll]] ;
            NSInteger timeSinceLast = dateLastGotAll
            ? -((NSInteger)[dateLastGotAll timeIntervalSinceNow])
            : DIIGO_DOWNLOAD_INTERVAL_TO_AVOID_BANNING ;
            if (timeSinceLast < DIIGO_DOWNLOAD_INTERVAL_TO_AVOID_BANNING) {
                error = SSYMakeError(constBkmxErrorNotAvailableAtThisTime, [NSString localize:@"cancelledOperation"]) ;
                error = [error errorByAddingLocalizedFailureReason:[NSString localizeFormat:
                                                                    @"imex_importNoBan",
                                                                    [self ownerAppDisplayName],
                                                                    [[BkmxBasis sharedBasis] appNameLocalized]]] ;
                NSInteger waitInterval = (DIIGO_DOWNLOAD_INTERVAL_TO_AVOID_BANNING - timeSinceLast) ;
                error = [error errorByAddingUserInfoObject:[NSNumber numberWithDouble:(double)waitInterval]
                                                    forKey:constKeyWaitInterval] ;
                NSString* format = NSLocalizedString(@"Wait %@ seconds and then try again", nil);
                NSString* suggestion = [NSString stringWithFormat:format,
                                        [NSString stringWithInt:waitInterval]];
                error = [error errorByAddingLocalizedRecoverySuggestion:suggestion] ;
                [self setError:error] ;
                // We don't want to leave a corrupt or, more likely, empty cache for this client,
                // because it will be used on the next Import.  So, we destroy it.
                [SSYMOCManager removeSqliteStoreForIdentifier:[[self clientoid] clidentifier]] ;
                
                [progressView clearAll] ;
                completionHandler() ;
            }
            else {
                // Get all bookmarks from server
                [self setDownloadingProgressView:progressView
                                        gotCount:0] ;
                
                NSFileHandle* rawDataFileHandle = nil ;
                NSString* snapshotPath = [self prepareNextSnapshotPathWithLabel:@"Dwnld"] ;
                if (snapshotPath) {
                    rawDataFileHandle = [NSFileHandle clearateFileHandleForWritingAtPath:snapshotPath] ;
                }
                
                NSInteger startIndex = 0 ;
                Starker* localStarker = [self localStarker] ;
                NSInteger gotItems = 0 ;
                [self downloadStartingAtIndex:startIndex
                                 progressView:progressView
                                 localStarker:localStarker
                            completionHandler:completionHandler
                            rawDataFileHandle:rawDataFileHandle
                                     gotItems:gotItems] ;
            }
        }
    }
}

- (void)testLoginWithInfo:(NSMutableDictionary*)info {
    NSError* error = nil ;
#if USE_LOCAL_DOT_SQL_CACHES_WHEN_IMPORTING_WEB_EXTORES
	BOOL ok = YES ;
#else
	NSString* subpathQuery = [[NSString alloc] initWithFormat:@"bookmarks?user=%@&start=%ld&count=%ld&filter=all&key=%@",
							  // Note: parameters 'sort', 'tag' and 'list' are intentionally not passed
							  [[self clientoid] profileName],
							  (long)0,
							  (long)1,  // Ask for 1 bookmark
							  constBkmxDiigoAppKey] ; 
	
	NSData* data = nil ;
	BOOL ok = [self talkToSubpathQuery:subpathQuery
							httpMethod:@"GET"
								client:[self client]
							   timeout:20.0
						 receiveData_p:&data
							   error_p:&error] ;
    error = [self errorByInsertingRetryLaterSuggestionInError:error] ;
    [subpathQuery release] ;
	
	if (ok) {
		NSString* string = [[NSString alloc] initWithData:data
												 encoding:NSUTF8StringEncoding] ;
		if (string) {
			NSArray* diigoBookmarks = [NSArray arrayWithJSONString:string
														accurately:NO] ;
			if (!diigoBookmarks) {
				error = SSYMakeError(498741, @"Could not understand data from Diigo") ;
				error = [error errorByAddingUserInfoObject:string
													forKey:@"Rx String"] ;
			}
		}
		else {
			error = SSYMakeError(347935, @"Could not decode data from Diigo") ;
		}
        
        [string release] ;
	}
#endif
	
	[self setError:error] ;
	
	[info setObject:[NSNumber numberWithBool:ok]
			 forKey:constKeySucceeded] ;
	[info setValue:error
			forKey:constKeyError] ;	
	
	[self.client.webAuthorizor endLoginTestInfo:info] ;
}

- (NSError*)errorByInsertingRetryLaterSuggestionInError:(NSError*)error {
    if ([error code] == constBkmxErrorClientAPIThrottled) {
        NSDate* retryDate = [[error userInfo] objectForKey:SSYRetryDateErrorKey] ;
        NSString* recoverySuggestion = [NSString stringWithFormat:
                                        @"Try again after %@:%@.  "
                                        @"(Cycling power on your DSL or cable modem to get a new IP address "
                                        @"will *not* help, because %@ throttles by %@ account name too.)",
                                        [retryDate hourString],
                                        [retryDate minuteString],
                                        [self ownerAppDisplayName],
                                        [self ownerAppDisplayName]] ;
        error = [error errorByAddingLocalizedRecoverySuggestion:recoverySuggestion] ;
    }
    
    return error ;
}


- (BOOL)deleteAtServerStark:(Stark*)stark 
					error_p:(NSError**)error_p {
	NSString* subpathQuery = [[NSString alloc] initWithFormat:
							  @"bookmarks?key=%@&user=%@&title=%@&url=%@",
							  constBkmxDiigoAppKey,
							  [self encodedProfileName],
							  [[stark nameNoNil] encodeForDiigo],
							  [[stark urlNoNil] encodeForDiigo]] ; 
	
	NSError* error = nil ;
	NSData* rxData = nil ;
	BOOL ok = [self talkToSubpathQuery:subpathQuery
							httpMethod:@"DELETE"
								client:[self client]
							   timeout:20.0
						 receiveData_p:&rxData
							   error_p:&error] ;
    error = [self errorByInsertingRetryLaterSuggestionInError:error] ;
	[subpathQuery release] ;
	
	if (error_p) {
		*error_p = error ;
	}
	
	return ok ;
}

- (BOOL)addAtServerStark:(Stark*)stark 
				 error_p:(NSError**)error_p {
	NSMutableString* subpathQuery = [[NSMutableString alloc] initWithFormat:
									 @"bookmarks?key=%@&user=%@&title=%@&url=%@",
									 constBkmxDiigoAppKey,
									 [self encodedProfileName],
									 // url and name ("title") are required by Diigo API
									 [[stark nameNoNil] encodeForDiigo],
									 [[stark urlNoNil] encodeForDiigo]] ; 

	// Other parameters are optional
	id value ;

	// Diigo's 'shared' defaults to NO, same as our 'isShared'
	value = [stark isShared] ;
	if ([value boolValue]) {
		[subpathQuery appendString:@"&shared=yes"] ;
	}
	
	value = [stark tags] ;
	if (value) {
		[subpathQuery appendFormat:@"&tags=%@", [[[self class] tagStringFromTagsArray:value] encodeForDiigo]] ;
	}

	value = [stark comments] ;
	if (value) {
		[subpathQuery appendFormat:@"&desc=%@", [value encodeForDiigo]] ;
	}
	
	// Diigo's 'shared' defaults to NO, same as our 'isShared'
	value = [stark toRead] ;
	if ([value boolValue]) {
		[subpathQuery appendString:@"&readLater=yes"] ;
	}
	
	NSError* error = nil ;
	NSData* rxData = nil ;
	BOOL ok = [self talkToSubpathQuery:subpathQuery
							httpMethod:@"POST"
								client:[self client]
							   timeout:20.0
						 receiveData_p:&rxData
							   error_p:&error] ;
    error = [self errorByInsertingRetryLaterSuggestionInError:error] ;
	[subpathQuery release] ;
	if (error_p) {
		*error_p = error ;
	}
	
	return ok ;
}

- (NSUInteger)slowExportThreshold {
	return 1500 ;  // was 140 until BookMacster 1.22.1
}

- (SSYAlert*)warnSlowAlertProposed:(NSUInteger)proposed
						 threshold:(NSUInteger)threshold {
	// Ask user right now if they want to do this, or use the Diigo
	// toolbar in Firefox instead.
	
	SSYAlert* alert = [SSYAlert alert] ;
	NSString* labelProceed = [NSString localizeFormat:
							  @"anyhowX",
							  [NSString localizeFormat:@"proceed"]] ;
	NSString* labelCancel = [[BkmxBasis sharedBasis] labelCancel] ;
#define SECONDS_PER_HOUR 3600
    float estimateInHours = proposed/threshold + (proposed * [[self client] httpRateInitial])/SECONDS_PER_HOUR + 1 ;
	NSString* estimatedTime = [NSString localizeFormat:
							   @"timeIntHoursX",
							   [NSString stringWithFormat:@"%0.1f", estimateInHours]] ;
	NSString* msg = [NSString localizeFormat:
					 @"diigoThrottleX5",
					 [NSString stringWithInt:proposed],
					 [NSString stringWithInt:threshold],
					 estimatedTime,
					 labelProceed,
					 labelCancel] ;
	[alert setSmallText:msg] ;
	[alert setButton1Title:labelProceed] ;
	[alert setButton2Title:labelCancel] ;
	
	return alert ;
}


@end
