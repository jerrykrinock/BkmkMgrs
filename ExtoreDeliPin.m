#import <Bkmxwork/Bkmxwork-Swift.h>
#import "ExtoreDeliPin.h"
#import "BkmxBasis+Strings.h"
#import "Stark.h"
#import "Starker.h"
#import "Ixporter.h"
#import "Client.h"
#import "NSError+InfoAccess.h"
#import "HttpTalker.h"
#import "DelPinParser.h"
#import "NSString+URIQuery.h"
#import "NSString+LocalizeSSY.h"
#import "NSString+VarArgs.h"
#import "NSString+SSYExtraUtils.h"
#import "SSYProgressView.h"
#import "SSYMOCManager.h"
#import "NSFileHandle+SSYExtras.h"
#import "SSYSynchronousHttp.h"
#import "NSError+DecodeCodes.h"
#import "NSError+MyDomain.h"
#import "NSUserDefaults+MainApp.h"
#import "WebAuthorizor.h"

@interface ExtoreDeliPin (Private)

- (void)addPendingDeletion:(Stark*)item ;
- (void)addPendingAddition:(Stark*)item ;
- (void)removePendingDeletion:(Stark*)item ;
- (void)removePendingAddition:(Stark*)item ;
- (void)addPendingDeletions:(NSSet*)morePendingDeletions
		addPendingAdditions:(NSSet*)morePendingAdditions ;
- (void)removePendingDeletions:(NSSet*)retractedPendingDeletions
		removePendingAdditions:(NSSet*)retractedPendingAdditions ;

@end



@implementation ExtoreDeliPin

- (BOOL)givesHttpError429WhenAllPostsHaveBeenSent {
	return NO ;
}

- (NSDate*)lastChangeTimeFromServer {
#ifdef LOCAL_FILE_PATH_TO_OVERRIDE_EXTOREWEBFLAT_DOWNLOAD
	// Force download by saying that bookmarks were just modified now.
	return [NSDate date] ;
#endif
	NSError* error_ = nil ;
	NSDate* lastChangeTime = nil ;
	
	NSData* data ;
	NSString* subpathQuery = @"posts/update" ;
    BOOL ok = [HttpTalker talkToSubpathQuery:subpathQuery
                                  httpMethod:@"GET"
                                      client:[self client]
                                     timeout:70.0
                               receiveData_p:&data
                                     error_p:&error_] ;
	if (!ok) {
		[self handleHttpError:error_
					requested:subpathQuery
						stark:nil
				 receivedData:data
			   prettyFunction:__PRETTY_FUNCTION__] ;
	}
	else  {
		[DelPinParser parseData:data
					   doStarks:NO
						doDates:NO
					  doBundles:NO
						 extore:self
				 lastUpdateTime:&lastChangeTime
						  error:&error_] ;
	}
	
	return lastChangeTime ;
}

- (BOOL)getExternallyDerivedLastKnownTouch:(NSDate**)date_p {
	NSError* error_ = nil ;
	[self setError:error_] ;
	
	NSString* msg = [NSString localizeFormat:@"contacting%0", [self ownerAppDisplayName]] ;
    SSYProgressView* progressView = [[[self bkmxDoc] progressView] setIndeterminate:YES
                                                                  withLocalizedVerb:msg
                                                                           priority:SSYProgressPriorityRegular] ;

	// Contact server
	NSDate* date = [self lastChangeTimeFromServer] ;
	
	[progressView clearAll] ;
	
#if 0
#warning Disabled del.icio.us downloads
	return [NSDate distantPast] ;
#endif
	
	if (date_p) {
		*date_p = date ;
	}
	
	return (date != nil) ;
}

- (BOOL)talkToSubpathQuery:(NSString*)subpathQuery
					client:(Client*)client
				   timeout:(CGFloat)timeout
			 receiveData_p:(NSData**)receiveData_p
				   error_p:(NSError**)error_p {
	NSData* responseData = nil ;
	BOOL ok = [HttpTalker talkToSubpathQuery:subpathQuery
								  httpMethod:@"GET"
									  client:client
									 timeout:timeout
							   receiveData_p:&responseData
									 error_p:error_p] ;
	if (ok) {
#if DEBUG
        NSString* responseString = [[NSString alloc] initWithData:responseData
														 encoding:NSUTF8StringEncoding] ;
		[responseString release] ;
#endif
        if (receiveData_p) {
			*receiveData_p = responseData ;
		}
	}
	
	return ok ;
}

- (void)syncWebServerToLocalThenCompletionHandler:(void(^)(void))completionHandler {
	BOOL ok = YES ;
	NSError* error = nil ;
	NSFileHandle* rawDataFileHandle = nil ;
	SSYProgressView* progressView = nil ;
	
	if (![self localMoc]) {
		// [self error] should be already set
		ok = NO ;
		goto end ;
	}

    [self clearLocalMoc];
	
	ok = [[self localMoc] save:&error] ;
	if (!ok) {
		if (!error) {
			NSString* msg = @"Failed moc save after deleting all" ;
			error = SSYMakeError(65054, msg) ;
		}
		[self setError:error] ;
		goto end ;
	}
	
#ifdef LOCAL_FILE_PATH_TO_OVERRIDE_EXTOREWEBFLAT_DOWNLOAD
    NSMutableArray* dataChunks = [NSMutableArray array] ;
	NSData* data = [NSData dataWithContentsOfFile:LOCAL_FILE_PATH_TO_OVERRIDE_EXTOREWEBFLAT_DOWNLOAD] ;
	NSLog(@"11821 Will parse %ld bytes from %@", (long)[data length], LOCAL_FILE_PATH_TO_OVERRIDE_EXTOREWEBFLAT_DOWNLOAD) ;
	if ([[LOCAL_FILE_PATH_TO_OVERRIDE_EXTOREWEBFLAT_DOWNLOAD pathExtension] isEqualToString:WEBDATA_FILE_EXTENSION]) {
        NSString* string = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding] ;
        NSArray* lines = [string componentsSeparatedByString:@"\n"] ;
        NSLog(@"11822 Will patch %@ file which has %ld lines", WEBDATA_FILE_EXTENSION, [lines count]) ;
        [string release] ;
        NSInteger lineIndex = 0 ;
        NSMutableArray* filteredLines = [[NSMutableArray alloc] init] ;
        BOOL gotFirstXmlHeader = NO ;
        while(YES) {
            NSString* line ;
            if (lineIndex < [lines count]) {
                line = [lines objectAtIndex:lineIndex] ;
            }
            else {
                line = nil ;
            }
            // Convert from zero-based to one-based, and increment
            lineIndex++ ;
            if ([line hasPrefix:XML_HEADER] || !line) {
                NSLog(@"11825 End of chunk at line %ld", (long)lineIndex) ;
                if (gotFirstXmlHeader) {
                    string = [filteredLines componentsJoinedByString:@"\n"] ;
                    NSData* dataChunk = [string dataUsingEncoding:NSUTF8StringEncoding] ;
                    [dataChunks addObject:dataChunk] ;
                    [filteredLines removeAllObjects] ;
                }
                else {
                    gotFirstXmlHeader = YES ;
                }
            }
            
            if (!line) {
                NSLog(@"11826 No more lines") ;
                break ;
            }
            else if ([line length] < 1) {
                NSLog(@"11823 Ignoring blank line %ld", (long)lineIndex) ;
            }
            else if ([line hasPrefix:BEGIN_DOWNLOAD_CHUNK_MARKER] || [line hasPrefix:END_DOWNLOAD_CHUNK_MARKER]) {
                NSLog(@"11824 Ignoring chunk marker at line %ld: %@", (long)lineIndex, line) ;
            }
            else {
                [filteredLines addObject:line] ;
            }
        }
        
        string = [filteredLines componentsJoinedByString:@"\n"] ;
        data = [string dataUsingEncoding:NSUTF8StringEncoding] ;
        
        [filteredLines release] ;
    }
    
    for (NSData* dataChunk in dataChunks) {
        [DelPinParser parseData:dataChunk
                       doStarks:YES
                        doDates:NO
                      doBundles:NO
                         extore:self
                 lastUpdateTime:NULL
                          error:&error] ;
        if (error) {
            [self setError:error] ;
            ok = NO ;
            goto end ;
        }
    }
#else
	// Make sure it's not too soon since last time
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults] ;
	NSDate* dateLastGotAll = [userDefaults syncAndGetMainAppValueForKey:[self keyLastPostsAll]] ;
	NSInteger timeSinceLast = dateLastGotAll
	? -((NSInteger)[dateLastGotAll timeIntervalSinceNow])
	: [self requestsAllMinimumTimeInterval] ;
	if (timeSinceLast < [self requestsAllMinimumTimeInterval]) {
		error = SSYMakeError(constBkmxErrorNotAvailableAtThisTime, [NSString localize:@"cancelledOperation"]) ;
		error = [error errorByAddingLocalizedFailureReason:[NSString localizeFormat:
															@"imex_importNoBan",
															[self ownerAppDisplayName],
															[[BkmxBasis sharedBasis] appNameLocalized]]] ;
		NSInteger waitInterval = ([self requestsAllMinimumTimeInterval] - timeSinceLast) ;
		error = [error errorByAddingUserInfoObject:[NSNumber numberWithDouble:(double)waitInterval]
											forKey:constKeyWaitInterval] ;
        NSString* format = NSLocalizedString(@"Wait %@ seconds and then try again", nil);
        NSString* suggestion = [NSString stringWithFormat:format,
                                [NSString stringWithInt:waitInterval]];
        error = [error errorByAddingLocalizedRecoverySuggestion:suggestion] ;
		[self setError:error] ;
		ok = NO ;
		goto end ;
	}
	
	// Get all data from server	
    progressView = [[self progressView] setIndeterminate:YES
                                       withLocalizedVerb:[NSString localizeFormat:
                                                          @"downloading%0",
                                                          [[NSString localize:@"000_Safari_Bookmarks"] lowercaseString]]
                                                priority:SSYProgressPriorityRegular] ;
    [progressView setProgressBarWidth:245.0] ;
	[progressView setHasCancelButtonWithTarget:self
										action:@selector(cancel:)] ;
	
#if DEBUG_WRITE_IMPORTED_URLS_TO_FILES
	[self beginSSYLinearFileWriter] ;
#endif	
	NSUInteger countOfStarksBefore ;
	NSUInteger countOfStarksAfter = 0 ;

	NSString* snapshotPath = [self prepareNextSnapshotPathWithLabel:@"Dwnld"] ;
	if (snapshotPath) {
		rawDataFileHandle = [NSFileHandle clearateFileHandleForWritingAtPath:snapshotPath] ;
	}

    NSString* beginDownloadString = [NSString stringWithFormat:
                                     @"\n%@\n",
                                     BEGIN_DOWNLOAD_CHUNK_MARKER] ;
    NSString* endDownloadString = [NSString stringWithFormat:
                                   @"\n%@\n",
                                   END_DOWNLOAD_CHUNK_MARKER] ;
	NSData* beginDownloadMarker = [beginDownloadString dataUsingEncoding:NSUTF8StringEncoding] ;
	NSData* endDownloadMarker = [endDownloadString dataUsingEncoding:NSUTF8StringEncoding] ;

	do {
		countOfStarksBefore = countOfStarksAfter ;
		NSData* data = nil ;
		NSString* subpathQuery = [NSString stringWithFormat:[self postsAllFormatString], (long)countOfStarksAfter] ;
		ok = [self talkToSubpathQuery:subpathQuery
							   client:[self client]
							  timeout:541.25
                        receiveData_p:&data
							  error_p:&error] ;	
		if (!ok) {
			// errorIsExpected was added in BookMacster 1.9.8 when I found that Pinboard was
			// returning error 429 on the next round after all bookmarks had been sent.
			BOOL errorIsExpected = 
			[error involvesCode:429 domain:SSYSynchronousHttpErrorDomain]
			&&
			[self givesHttpError429WhenAllPostsHaveBeenSent]
			&&
			(countOfStarksAfter > 0) ;
			// countOfStarksAfter>0 is a not-very-good method of distintuishing 429 errors
			// caused by all bookmarks having been received from real 429 errors.  Fortunately,
			// Pinboard seems to not send the 429 error if the user has indeed 0 bookmarks in
			// their account.  But if they ever decided to send a 429 error in the middle of
			// a download, before all bookmarks had been sent, we'd be missing some and not
			// know it.

			if (errorIsExpected) {
				ok = YES ;
				error = nil ;
				break ;
			}
			else {
				[self handleHttpError:error
							requested:subpathQuery
								stark:nil
						 receivedData:data
					   prettyFunction:__PRETTY_FUNCTION__] ;
				goto end ;
			}
		}		

		[rawDataFileHandle writeData:beginDownloadMarker] ;
		[rawDataFileHandle writeData:data] ;
		[rawDataFileHandle writeData:endDownloadMarker] ;
		
		[progressView setHasCancelButtonWithTarget:nil
											action:NULL] ;
		[progressView setIndeterminate:YES
                     withLocalizedVerb:[NSString localize:@"parsing"]
                              priority:SSYProgressPriorityRegular] ;

		[userDefaults setAndSyncMainAppValue:[NSDate date]
                                      forKey:[self keyLastPostsAll]] ;

		// Parse data and insert into moc
		[DelPinParser parseData:data
					   doStarks:YES
						doDates:NO
					  doBundles:NO
						 extore:self
				 lastUpdateTime:NULL
						  error:&error] ;
		if (error) {
			[self setError:error] ;
			[self clarifyErrorForRequest:subpathQuery
							receivedData:data] ;
			ok = NO ;
			goto end ;
		}
		
		countOfStarksAfter = [[[self localStarker] allStarks] count] ;
	} while (countOfStarksAfter > countOfStarksBefore) ;
	
#if DEBUG_WRITE_IMPORTED_URLS_TO_FILES
	[self closeSSYLinearFileWriter] ;
#endif
#endif
	
	[progressView setIndeterminate:YES
                 withLocalizedVerb:[NSString localizeFormat:@"writing%0", [NSString localize:@"000_Safari_Bookmarks"]]
                          priority:SSYProgressPriorityRegular] ;
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;

	if (ok) {
        ok = [[self localMoc] save:&error] ;
    }
    
	if (!ok) {
		error = [SSYMakeError(90257, @"Failed moc save after inserting") errorByAddingUnderlyingError:error] ;
		[self setError:error] ;
		goto end ;
	}
	
end:;	
	[rawDataFileHandle closeFile] ;
	if (!ok) {
		// We don't want to leave a corrupt or, more likely, empty cache for this client,
		// because it will be used on the next Import.  So, we destroy it.
		[SSYMOCManager removeSqliteStoreForIdentifier:self.clientoid.clidentifier] ;
	}
	
	[progressView clearAll] ;
	
    if (ok) {
        [self saveLocalAndSyncToTrans];
    }
    
    completionHandler() ;
}

- (void)testLoginWithInfo:(NSMutableDictionary*)info {
	NSError* error = nil ;
	
#if USE_LOCAL_DOT_SQL_CACHES_WHEN_IMPORTING_WEB_EXTORES
	BOOL ok = YES ;
#else
	Client* client = [[self ixporter] client] ;
	NSData* data ;
	NSString* subpathQuery = @"posts/update" ;
	BOOL ok = [self talkToSubpathQuery:subpathQuery
								client:client
							   timeout:29.52  // was 10.0 until BookMacster 1.22.4, when I added the three trials into HttpTalker
						 receiveData_p:&data
							   error_p:&error] ;	
	
	if (ok) {
		ok = [DelPinParser parseData:data
							doStarks:NO
							 doDates:NO
						   doBundles:NO
							  extore:nil
					  lastUpdateTime:NULL
							   error:&error] ;
	}
#endif
	
	[info setObject:[NSNumber numberWithBool:ok]
			 forKey:constKeySucceeded] ;
	[info setValue:error
			forKey:constKeyError] ;	
	
	[self.client.webAuthorizor endLoginTestInfo:info] ;
}

- (BOOL)itemNotFoundIndicatedByData:(NSData*)data {
	return NO ;
}

- (BOOL)deleteAtServerStark:(Stark*)stark 
					error_p:(NSError**)error_p {
	NSUInteger nTrials = 0 ;
	BOOL done = NO ;
	BOOL ok ;
	NSError* error = nil ;
	NSString* encodedURL = [[stark url] encodePercentEscapesPerStandard:SSYPercentEscapeStandardRFC2396
																 butNot:nil
																butAlso:@"@?&/;+"] ;
	while (!done) {
		NSString* subpathQuery = [[NSString alloc] initWithFormat: @"posts/delete?url=%@", encodedURL] ;
		error = nil ;
		NSData* rxData = nil ;
        ok = [self talkToSubpathQuery:subpathQuery
                               client:[self client]
                              timeout:57.73  // was 30.0 until BookMacster 1.22.4, when I added the three trials into HttpTalker
                        receiveData_p:&rxData
                              error_p:&error] ;
		nTrials++ ;
		if (ok) {
			// This section added in BookMacster 1.10 to handle "item not found" errors
			// from Pinboard
			if ([self itemNotFoundIndicatedByData:rxData]) {
				if (nTrials == 1) {
                    /* I don't have any documentation, but apparently, at one
                     time, I concluded that an encoded URL ending in a
                     percent-escape encoded trailing slash was an issue. */
                    if ([encodedURL hasSuffix:@"%2F"]) {
                        encodedURL = [encodedURL substringToIndex:MAX([encodedURL length] - 3, 0)] ;
                    }
				}
				else {
					// Give up
					NSString* msg = [NSString stringWithFormat:
									 @"%@ said it could not find and therefore cannot delete item whose URL is that of %@",
									 [self displayName],
									 [stark name]] ;
					error = SSYMakeError(825340, msg) ;
					error = [error errorByAddingUserInfoObject:encodedURL
														forKey:@"Encoded URL, 2nd try"] ;
					error = [error errorByAddingUserInfoObject:[[stark url] encodePercentEscapesPerStandard:SSYPercentEscapeStandardRFC2396
																									 butNot:nil
																									butAlso:@"@?&/;+"]
														forKey:@"Encoded URL, 1st try"] ;
					error = [error errorByAddingUserInfoObject:[stark url]
														forKey:@"Raw URL"] ;
					done = YES ;
				}
			}
			else {
				// Assume that it worked
				done = YES ;
			}
		}
		else {
			error = [error errorByAddingUserInfoObject:subpathQuery
												forKey:@"Subpath Query"] ;
			done = YES ;
		}
		[subpathQuery release] ;
	}
	
	if (error_p) {
		*error_p = error ;
	}

	return ok ;
}

- (BOOL)addAtServerStark:(Stark*)stark 
				 error_p:(NSError**)error_p {
	NSMutableString* query = [NSMutableString stringWithFormat:@"?url=%@&description=%@",
							  // url and name ("description") are required by del.icio.us API
							  // Also, BookmarkMO -url and -name will never return nil
							  [[stark url] encodePercentEscapesPerStandard:SSYPercentEscapeStandardRFC2396
																		 butNot:nil
																		butAlso:@"@?&/;+"],
							  [[stark name] encodePercentEscapesPerStandard:SSYPercentEscapeStandardRFC2396
																		  butNot:nil
																		 butAlso:@"@?&/;+"]] ;
	id value ;
	[query appendString:@"&shared="] ;
	value = [[stark isShared] boolValue] ? @"yes" : @"no" ;
	[query appendString:value] ;
	// Other parameters are optional
	value = [stark comments] ;
	if (value) {
		[query appendFormat:@"&extended=%@", [value encodePercentEscapesPerStandard:SSYPercentEscapeStandardRFC2396
																			 butNot:nil
																			butAlso:@"@?&/;+"]] ;
	}
	value = [stark tags] ;
	if (value) {
        NSArray* tagStrings = [value valueForKey:constKeyString];
		[query appendFormat:@"&tags=%@", [[[self class] tagStringFromArray:tagStrings] encodePercentEscapesPerStandard:SSYPercentEscapeStandardRFC2396
																										   butNot:nil
																										  butAlso:@"@?&/;+"]] ;
	}
	value = [stark addDate] ;
	if (value) {
        NSString* dateString = [[DelPinParser dateFormatterForDeliPin] stringFromDate:value] ;
        [query appendFormat:@"&dt=%@", dateString] ;
	}
	
	NSError* error = nil ;
	NSString* subpathQuery = [[NSString alloc] initWithFormat: @"posts/add%@", query];
	BOOL ok = [self talkToSubpathQuery:subpathQuery
								client:[self client]
							   timeout:54.88 // was 30.0 until BookMacster 1.22.4, when I added the three trials into HttpTalker
						 receiveData_p:NULL
							   error_p:&error] ;
	if (!ok) {
		error = [error errorByAddingUserInfoObject:subpathQuery
											forKey:@"Subpath Query"] ;
	}
	[subpathQuery release] ;
	if (error_p) {
		*error_p = error ;
	}
	
	return ok ;
}

- (NSString*)postsAllFormatString {
	return @"posts/all?start=%ld" ;
}


@end
