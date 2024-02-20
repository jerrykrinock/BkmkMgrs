#import "HeaderGetter.h"
#import "Stark.h"
#import "NSString+BkmxURLHelp.h"
#import "SSWebBrowsing.h"
#import "NSString+LocalizeSSY.h"
#import "BkmxBasis+Strings.h"


@interface HeaderGetter ()

@property (retain) Stark* bookmark ;
@property (retain) id target ;
@property (retain) NSTimer* timer ;
@property (retain) NSString* fallbackProposedURL ;
@property (retain) NSString* reasonOn1stTry ;
@property (retain) NSString* userAgent ;
@property (retain) NSURLSession* session;

@property (assign) BOOL didSendHeaders;

@end


@implementation HeaderGetter

@synthesize bookmark ;
@synthesize target ;
@synthesize timer ;
@synthesize fallbackProposedURL ;
@synthesize reasonOn1stTry ;
@synthesize userAgent ;
@synthesize session;

- (void)fixRequest:(NSMutableURLRequest*)mutableRequest {
	[mutableRequest setValue:[self userAgent] forHTTPHeaderField:@"User-Agent"];
    // [mutableRequest setTimeoutInterval:_timeout] ; // This does not work.
    [mutableRequest setCachePolicy:NSURLRequestReloadIgnoringCacheData] ;
	[mutableRequest setHTTPShouldHandleCookies:NO] ;
	// The above is to NOT send stored cookies placed by "other applications which use the
	// [Apple] URL Loading System".  (See paragraph "Cookie Storage" in 
	// "ADC Home > Reference Library > Guides > Cocoa > Networking > URL Loading System").
	// In Bookdog 3.6 and earlier, we did not send this message, and therefore
	// cookies were sent because setHTTPShouldHandleCookies defaults to YES.  
	// The only ill effect I have found from sending cookies is with Google AdWords:
	// https://adwords.google.com/select/starter/AdStatus.   If the above message is YES,
	// then the FIRST time after application launch, Google will send a 302 response with
	// location https://adwords.google.com/select/?gsessionid=-Iy2NJtJpRo, where the
	// sessionid is random, which our 302 algorithm recognizes as an unnecessary redirect.
	// But, the SECOND and any SUBSEQUENT time that verify is run after Bookmarksman launch,
	// Google will send a 302 response with https://adwords.google.com/select/, which
	// survives our 302 algorithm as one that looks like it's permanent, when in fact
	// if the user later uses this redirect, enters name and password, then the NEXT
	// page will silently fail to load.  A real bug!!
	
	// Warning.  For a while I found that My Yahoo!: http://my.yahoo.com/p/d.html?v
	// would be automatically fixed by Bookmarksman ("sure about this one") if 
	// setHTTPShouldHandleCookies:NO, but subsequent retesting disproved this.  I don't
	// know why.  Maybe I wasn't doing what I thought I was doing, or maybe this was due
	// to other changes.
	
	// So, for now at least, we say Cookies:NO
}	

- (void)setAndBeginSessionWithURL:(NSURL*)url {
	//[url setProperty:[self userAgent] forKey:@"User-Agent"];  // This does not seem to work; when I ask for "Safari", I get "CFNetwork"
														   // If I use "Bookdog/2.0" as the agent, then Bon Vivant travel, http://www.bvt-usa.com/ gives "badbrowser.htm"
	NSURLRequest* request=[NSURLRequest requestWithURL:url
											  cachePolicy:NSURLRequestReloadIgnoringCacheData
										  timeoutInterval:65536.0]; // since timeoutInterval is broken, we set it to a large value.
	
	NSMutableURLRequest *mutableRequest = [request mutableCopy];
	[self fixRequest:mutableRequest] ;
	
	// Optional code to use a HEAD request instead of a GET, but found that this gives wrong 
	//   answers from 26 out of 1200 websites.  See Results_Diff_GET_HEAD.xls
	// 1 of 2 places
	// For the following o work, must make theRequest an NSMutableURLRequest
	// [mutableRequest setHTTPMethod:@"HEAD"] ;
    NSURLSession* session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:self
                                                     delegateQueue:nil];
    self.session = session;
    /* Of course, the actual work needs to be done on a secondary thread since
     we are going to block this thread with dispatch_semaphore_wait(). */
    dispatch_queue_t aSerialQueue = dispatch_queue_create(
                                                          "SSYSynchronousHttp Worker",
                                                          DISPATCH_QUEUE_SERIAL
                                                          ) ;

    dispatch_async(aSerialQueue, ^{
        NSURLSessionDataTask* task = [session dataTaskWithRequest:mutableRequest
                                                completionHandler:^(NSData * _Nullable data,
                                                                    NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
            [self handleResponse:response
                           error:error] ;
        }];
        
        // Fire off the request
        [task resume];
    });
    [mutableRequest release];
	
	self.session = session;

	_cancelled = NO ;
}

- (void)sendHeaders:(NSMutableDictionary*)headers {
    /* The first headers generated are generally the best.  In particular, if
     we are called by -timeout, in milliseconds we will be called again by
     -handleResponse:error: for the same bookmark.  The former has the better
     verifier code and verifier disposition (-1001, BkmxFixDispoLeaveBroken)
     while the latter's is not as informative (0, BkmxFixDispoLeaveAsIs).
     Also, since each bookmark only increments Brokers.nWaiting once, and since
     gotHeaders decrements Brokers.nWaiting once for each call, sending
     gotHeaders twice will cause nWaiting to finish with a negative value
     instead of 0. */
    if (!self.didSendHeaders) {
        self.didSendHeaders = YES;
        if ([[NSThread currentThread] isMainThread]) {
            [[self target] performSelector:_targetMethod
                                withObject:[[headers retain] autorelease]];
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [[self target] performSelector:_targetMethod
                                    withObject:[[headers retain] autorelease]];
            });
        }
    };
}

- (void)handleResponse:(NSURLResponse*)response
                 error:(NSError*)errorNotUsed {  // maybe it should be used?
    /* We've got what we need, so kill this dog. */
    [self abortSession] ;
    
    NSInteger iCode  ;
    NSString* verifierReason ;
    NSMutableString* location = nil ;
    NSMutableArray* advice = [NSMutableArray array] ; // an empty array
    // Begin building our "headers" information
    NSMutableDictionary* headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [self bookmark], constKeyVerifierStark,
                                    [NSNumber numberWithInteger:BkmxFixDispoLeaveBroken], constKeyVerifierDisposition,   // Default is to fix manually.  Later, we'll change all 200s to oIgnore, 301s to BkmxFixDispoDoUpdate, etc.
                                    nil ] ;
    
    // The following qualification was added in BookMacster 1.15
    BOOL __block isAvailable;
    NSString* __block url;
    if ([[NSThread currentThread] isMainThread]) {
        isAvailable = self.bookmark.isAvailable;
        url = self.bookmark.url;
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            isAvailable = self.bookmark.isAvailable;
            url = self.bookmark.url;
        });
    }
    if (isAvailable) {
        if ([response respondsToSelector:@selector(statusCode)])  // An NSHTTPURLResponse will, other NSURLResponses will not
        {
            iCode = [(NSHTTPURLResponse*)response statusCode];
            verifierReason = [NSHTTPURLResponse localizedStringForStatusCode: iCode] ;
        }
        else
        {
            // This will happen for local file:/// urls, and also for ftp://
            verifierReason = [NSString localize:@"noCode"] ;
            // We consider the file:/// to be OK, because otherwise they would not have didFailWithError, and the ftp and others to be unknown
            if ([url sameSchemeAs:@"file:///a/b"])
            {
                iCode = 200 ;
            }
            else
            {
                iCode = 0 ;
            }
        }

        // Declare a few questions and answers which may change if we read a "Location"
        BOOL redirectIndicatesNotFound = NO ;
        BOOL locationGood = NO ;
        BOOL pageMayBeGone = NO ;
        
        // See if we can get a "Location" field from the response
        if ([response respondsToSelector:@selector(allHeaderFields)])
        {
            NSDictionary* allFields = [(NSHTTPURLResponse*)response allHeaderFields] ;
            NSString* locationImmutable = [allFields objectForKey:@"Location"] ;
            
            if (!locationImmutable)
                locationImmutable = [self fallbackProposedURL] ;
            
            if (locationImmutable)
            {
                redirectIndicatesNotFound = [locationImmutable has_NotFound_Keyword] ;
                if ([locationImmutable startsWithScheme])
                {
                    locationGood = YES ;
                    location = [NSMutableString stringWithString:locationImmutable] ;
                    // Restore feed:// scheme if this was faked when request was created
                    if (_feedFake)
                    {
                        // feed:// redirects are always no improvement over the original
                        // so, we don't use them anyhow.
                        //FIXTHIS    urlProposedFiltered = nil ;
                        // Former Code for unstuffing http back to feed:
                        NSRange schemeRange = NSMakeRange(0,4) ;
                        [location replaceCharactersInRange:schemeRange withString:@"feed"] ;
                    }
                }
            }
            
            // I could do something with this but I don't.  It's not used very often, I believe.
            // NSString* lastModified = [allFields objectForKey:@"Last-Modified"] ;
        }
        
        // We want to return the error that we got on the first try, if there was one, instead of this error.
        if (_errorIn1stResponse)
        {
            iCode = _errorIn1stResponse ;
            if ([self reasonOn1stTry])
                verifierReason = [self reasonOn1stTry] ;
        } else if ([response respondsToSelector:@selector(statusCode)]) {
            /* `response` must be an NSHTTPURLResponse because other
             NSURLResponses subclasses will not responde to -statusCode. */
            NSInteger iCode = [(NSHTTPURLResponse*)response statusCode];
            verifierReason = [NSHTTPURLResponse localizedStringForStatusCode: iCode] ;
        }
        else
        {
            iCode = 0 ;
            verifierReason = [NSString localize:@"noCode"] ;
        }
        
        // 2. Set ivars
        if (_errorIn1stResponse == 0) {
            _errorIn1stResponse = iCode ;
        }
        if (verifierReason) {
            [self setReasonOn1stTry:verifierReason] ;
        }

        
        // Now we consider each error code, in some cases look at other conditions, and set the advice and the fix:
        NSString* strURLNowHave = url ;
        NSURL* urlNowHave = [NSURL URLWithString:strURLNowHave] ;
        
        // Now we consider each error code, in some cases look at other conditions, and set the advice and the fix:
        if (iCode < -1199) {
            [advice addObject:[NSNumber numberWithInteger:advUntrusted]] ;
            if ([location sameHostPathButHTTPvsHTTPS:strURLNowHave])
                [headers setObject:[NSNumber numberWithInteger:BkmxFixDispoDoUpdate] forKey:constKeyVerifierDisposition] ;
        }
        else if (iCode < -1099) {
            [headers setObject:[NSNumber numberWithBool:YES] forKey:constKeyVerifierNeedsRetest] ;
            [advice addObject:[NSNumber numberWithInteger:advFileGone]] ;
        }
        else if (iCode == -1007) {
            [advice addObject:[NSNumber numberWithInteger:advTooManyRedirects]] ;
        }
        else if (iCode < -1000) {
            // I'm not sure if advTryAgain applies to -1002, -1003, -1004
            [headers setObject:[NSNumber numberWithBool:YES] forKey:constKeyVerifierNeedsRetest] ;
            [advice addObject:[NSNumber numberWithInteger:advTryAgain]] ;
        }
        else if (iCode < -999) {
            [advice addObject:[NSNumber numberWithInteger:advBadURL]] ;
        }
        else if (iCode < -998) {
            [advice addObject:[NSNumber numberWithInteger:advHostGone]] ;
        }
        // Code 0 is "unknown"
        else if (iCode==0) {
            [headers setObject:[NSNumber numberWithInteger:BkmxFixDispoLeaveAsIs] forKey:constKeyVerifierDisposition] ;
        }
        // 200s are OK, of course
        else if ((iCode>=200) && (iCode<300)) {
            [headers setObject:[NSNumber numberWithInteger:BkmxFixDispoLeaveAsIs] forKey:constKeyVerifierDisposition] ;
        }
        // 301s and 302s
        else if((iCode==301) || (iCode==302))
        {
            if (locationGood)
            {
                // Automatically fix all 301s that have well-formed redirects
                if (iCode==301) {
                    [headers setObject:[NSNumber numberWithInteger:BkmxFixDispoDoUpdate] forKey:constKeyVerifierDisposition] ;
                    [advice addObject:[NSNumber numberWithInteger:advUpdated]] ;
                }
                else {
                    // 302s
                    [headers setObject:[NSNumber numberWithInteger:BkmxFixDispoToBeDetermined]
                                forKey:constKeyVerifierDisposition] ;
                    [headers setObject:[NSNumber numberWithInteger:BkmxHttp302Unsure]
                                forKey:constKeyVerifierSubtype302] ;
                    if ([location hasPrefix:strURLNowHave])
                    {
                        [headers setObject:[NSNumber numberWithInteger:BkmxHttp302Agree] forKey:constKeyVerifierSubtype302] ;
                    }
                    else
                    {
                        if( redirectIndicatesNotFound )
                        {
                            [location setString:[NSString stringWithFormat:@"%@://%@", [urlNowHave scheme], [urlNowHave host]]] ;
                            [advice addObject:[NSNumber numberWithInteger:advPageGone]] ;
                        }
                        else
                        {
                            if ([strURLNowHave isEqualToString:location])
                            {
                                // redirect is same as url now have, obviously it is OK!
                                [headers setObject:[NSNumber numberWithInteger:BkmxHttp302Agree] forKey:constKeyVerifierSubtype302] ;
                            }
                            else
                            {
                                if ([location isKnownUnnecessaryRedirect])
                                    [headers setObject:[NSNumber numberWithInteger:BkmxHttp302Agree] forKey:constKeyVerifierSubtype302] ;
                                else
                                {
                                    if ([location sameHostPathButHTTPvsHTTPS:strURLNowHave])
                                        [headers setObject:[NSNumber numberWithInteger:BkmxHttp302Disagree] forKey:constKeyVerifierSubtype302] ;
                                    else
                                    {
                                        if ([location schemeIs_feed])
                                            [headers setObject:[NSNumber numberWithInteger:BkmxHttp302Disagree] forKey:constKeyVerifierSubtype302] ;
                                        else
                                        {
                                            if (![location looksLikeVacuumCleaner])
                                            {
                                                if(![location pathAndQueryTooLong])
                                                {
                                                    if (![strURLNowHave urlHasSameDomainAs:location])
                                                        [headers setObject:[NSNumber numberWithInteger:BkmxHttp302Disagree] forKey:constKeyVerifierSubtype302] ;
                                                    else
                                                    {
                                                        [advice addObject:[NSNumber numberWithInteger:advNewPageSameDomainBkmx]] ;
                                                        if([location looksLikeParallelLoadedHostTo: strURLNowHave])
                                                            [headers setObject:[NSNumber numberWithInteger:BkmxHttp302Agree] forKey:constKeyVerifierSubtype302] ;
                                                        else
                                                        {
                                                            if(![location sameHostAs:strURLNowHave])
                                                                [headers setObject:[NSNumber numberWithInteger:BkmxHttp302Disagree] forKey:constKeyVerifierSubtype302] ;
                                                            else
                                                            {
                                                                if(![location sameSchemeAs:strURLNowHave])
                                                                    [headers setObject:[NSNumber numberWithInteger:BkmxHttp302Disagree] forKey:constKeyVerifierSubtype302] ;
                                                                else
                                                                {
                                                                    if(![strURLNowHave hasPath] || [strURLNowHave isProbablyOK])
                                                                        [headers setObject:[NSNumber numberWithInteger:BkmxHttp302Agree] forKey:constKeyVerifierSubtype302] ;
                                                                    else
                                                                    {
                                                                        // [advice addObject:[NSNumber numberWithInt:adv302]] ;
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                                else
                                                    [headers setObject:[NSNumber numberWithInteger:BkmxHttp302Agree] forKey:constKeyVerifierSubtype302] ;
                                            }
                                            else
                                                [advice addObject:[NSNumber numberWithInteger:advVacuumCleaner]] ;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else
            {
                [headers setObject:[NSNumber numberWithInteger:BkmxFixDispoLeaveAsIs]
                            forKey:constKeyVerifierDisposition] ;  //  This is in case we are in phase kRetestingSome
                [headers setObject:[NSNumber numberWithBool:YES]
                            forKey:constKeyVerifierNeedsRetest] ;  // This is in case we are in phase kFirstPass
            }
            if ((iCode==302) && (![advice count]))
            {
                // Default advice for 302s, in case none has been given in the above.
                [advice addObject:[NSNumber numberWithInteger:adv302]] ;
            }
        }
        else if (iCode < 403)
            [advice addObject:[NSNumber numberWithInteger:adv400to403]] ;
        else if (iCode == 403)
        {
            [advice addObject:[NSNumber numberWithInteger:adv400to403]] ;
            [advice addObject:[NSNumber numberWithInteger:advVacuumCleaner]] ;
        }
        else if (iCode == 404)
        {
            [advice addObject:[NSNumber numberWithInteger:advPageGone]] ;
            pageMayBeGone = YES ;
            location = [[[NSString stringWithFormat:@"%@://%@", [urlNowHave scheme], [urlNowHave host]] mutableCopy] autorelease] ;
            if ([strURLNowHave stupidWebmaster404])
            {
                [headers setObject:[NSNumber numberWithInteger:BkmxFixDispoLeaveAsIs]
                            forKey:constKeyVerifierDisposition] ;
                iCode = 200 ;
            }
        }
        else if (iCode <500)
            [advice addObject:[NSNumber numberWithInteger:advNone]] ;
        else if (iCode < 504)
        {
            [advice addObject:[NSNumber numberWithInteger:advFalseAlarm]] ;
            pageMayBeGone = YES ;
        }
        else
            [advice addObject:[NSNumber numberWithInteger:advNone]] ;
        
        if (pageMayBeGone)
            [advice addObject:[NSNumber numberWithInteger:advIfOK]] ;
        
        if ([url hasPrefix:@"feed"])
            [advice addObject:[NSNumber numberWithInteger:advRSS]] ;
        
        // Add the newly-computed answers to our "headers" output
        [headers setObject:[NSNumber numberWithInteger:iCode] forKey:constKeyVerifierCode] ;
        [headers setObject:advice forKey:constKeyVerifierAdviceArray] ;
        if (location)
            [headers setObject:[NSString stringWithString:location] forKey:constKeyVerifierSuggestedUrl] ;
        if (verifierReason)
            [headers setObject:[NSString stringWithString:verifierReason] forKey:constKeyVerifierReason] ;
    }

    // and send it off
    [headers setObject:self forKey:constKeyVerifierHeaderGetter] ;

    [self sendHeaders:headers];
}

- (void)doConnect
{
	// Create the request

	NSString* urlString = [(Stark*)[self bookmark] url] ;

	if (urlString) {
        NSRange firstFour = NSMakeRange(0, 4) ;
        _feedFake = NO ;
        if ([urlString hasPrefix:@"feed://"]) {
            NSMutableString* temp = [NSMutableString stringWithString:urlString] ;
            // Ondra Cada's hack, which Bob Ippolito says is not a hack...
            // This is to patch the problem immediately sends a message to my
            // delegate method -URLSession:task:didCompleteWithError:], giving
            // error -1002 "unsupported URL".  It seems to barf as soon as
            // it sees the scheme "feed"; it doesn't even try to find the host.
            [temp replaceCharactersInRange:firstFour
                                withString:@"http"] ;
            urlString = [NSString stringWithString:temp] ;
            _feedFake = YES ;
        }
        if (
            ([self verifyType] == BrokerVerifyTypeSecurifySecondPass)
            &&
            [urlString hasPrefix:@"http://"]
            ) {
            NSMutableString* temp = [NSMutableString stringWithString:urlString] ;
            [temp replaceCharactersInRange:firstFour
                                withString:@"https"] ;
            urlString = [NSString stringWithString:temp] ;
        }
        
        NSString* urlStringFixed = [urlString stringByFixingFirefoxQuicksearch] ;
        
        if([[[self bookmark] dontVerify] boolValue]) {
            urlStringFixed = @"guaranteedToFail" ;
            /* This is to make sure that this session ends up in
             -URLSession:task:didCompleteWithError:], where we
             have the code for handling false alarms. */
        }

        NSURL* url = [NSURL URLWithString:urlStringFixed] ;
        [self setAndBeginSessionWithURL:url] ;
    }
    
	if (self.session) {
		NSTimer* timer_ = [NSTimer scheduledTimerWithTimeInterval:_timeout
														  target:self
														selector:@selector(timeout:)
														userInfo:nil
														 repeats:NO] ;
		[self setTimer:timer_] ;
	}	
	else {
		// Session failed, send headers and bail out
        self.bookmark.verifierDispositionValue = BkmxFixDispoLeaveBroken;
		NSMutableDictionary* headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:
				self, constKeyVerifierHeaderGetter,
				[self bookmark], constKeyVerifierStark,
				[NSNumber numberWithInteger:9998], constKeyVerifierCode,
				[NSString localize:@"connectionFailed"], constKeyVerifierReason,
				nil ];
        [self sendHeaders:headers];
	}
}

- (id)initWithBookmark:(id)bookmark_
				 index:(NSInteger)i
            verifyType:(VerifyType)verifyType
		  sendResultTo:(id)receiveTarget
		  usingMessage:(SEL)receiveSelector
			   timeout:(CGFloat)timeout
			 userAgent:(NSString*)userAgent_ {
	if ((self = [super init]))
	{
		_errorIn1stResponse = 0 ;
		[self setReasonOn1stTry:nil] ;
		[self setFallbackProposedURL:nil] ;
		
		// Set object instance variables
		[self setBookmark:bookmark_] ;
		[self setTarget:receiveTarget] ;
		[self setUserAgent:userAgent_] ;
		
		// Set non-object instance variables
		_targetMethod = receiveSelector ;
		_index = i ;
		_timeout = timeout ;
        _verifyType = verifyType ;
		
		[self doConnect] ;
	}
    
	return self;
}

- (void)dealloc {
    if (!_cancelled) {
        [session invalidateAndCancel];
    }
    [bookmark release] ;
	[target release] ;
	[timer release] ;
    [fallbackProposedURL release];
	[reasonOn1stTry release] ;
	[userAgent release] ;
    [session release];

	[super dealloc] ;
}

- (void)abortSession {
	if (!_cancelled) {
		[self.session invalidateAndCancel];
		_cancelled = YES ;
	}
	
	NSTimer* timer_ = [self timer] ;
	if ([timer_ isValid]) {
		[timer_ invalidate] ; 
	}
}

- (void)timeout:(id)timerNotUsed {
	[self abortSession] ;

	NSMutableDictionary* headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:
		self, constKeyVerifierHeaderGetter,
		[self bookmark], constKeyVerifierStark,
		[NSNumber numberWithInteger:-1001], constKeyVerifierCode,
		[NSString localize:@"1001Official"], constKeyVerifierReason,
		[NSNumber numberWithInteger:BkmxFixDispoLeaveBroken], constKeyVerifierDisposition,
		[NSNumber numberWithBool:YES], constKeyVerifierNeedsRetest,
		[NSArray arrayWithObject:[NSNumber numberWithInteger:advTryAgain]], constKeyVerifierAdviceArray,
		nil];

    [self sendHeaders:headers];
}

- (void)       URLSession:(NSURLSession *)session
                     task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
               newRequest:(NSURLRequest *)request
        completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    NSMutableURLRequest *mutableRequest = [request mutableCopy] ;
    // returned request has had the User-Agent field stripped, maybe other damage, so fix it...
    [self fixRequest:mutableRequest] ;
	// Now, replace the request argument with our fixed request
	request = [mutableRequest copy] ;
	[mutableRequest release] ;

	// 1. Gather data
	NSString* locationRequest = [[request URL] absoluteString] ;

	NSInteger iCode = 0 ;
	NSString* verifierReason = nil ;
		
	if ([response respondsToSelector:@selector(statusCode)])  // An NSHTTPURLResponse will, other NSURLResponses will not
	{
		iCode = [(NSHTTPURLResponse*)response statusCode];
		verifierReason = [NSHTTPURLResponse localizedStringForStatusCode: iCode] ;
	}
	else
	{
		iCode = 0 ; 
		verifierReason = [NSString localize:@"noCode"] ;
	}
	
	// 2. Set ivars
    if (_errorIn1stResponse == 0) {
        _errorIn1stResponse = iCode ;
    }
    if (verifierReason) {
		[self setReasonOn1stTry:verifierReason] ;
    }
	
	// Test for bad URL in request added 2005 Nov 10:
	// It is to fix hangs in Jaguar, since a "bad url" -1000 error in Jaguar will never give a response or error, and thus the HeaderGetter will never send a gotResponse: message to Broker
	// Prior to this time, the only line was: [self setFallbackProposedURL:locationRequest] ;
	BOOL goodRequest = NO ;
	if (locationRequest)
	{
		if (([NSURL URLWithString:locationRequest] != nil)  && [locationRequest length] > 3 )
		// Latter condition is needed because an empty string makes a valid URL.
		// I don't think you could have a useful URL with fewer than 4 characters?
		// The above test and below "else" was added 2005 Nov 10
		{
			[self setFallbackProposedURL:locationRequest] ;
			// Many sites give the same strings in locationRequest and locationResponse.  
			// But, of those that are different, I get better results with locationRequest.
			goodRequest = YES ;
		}
	}
	
	// 3. Abort if request is no good
	if (!goodRequest) {
		[request release] ;  // Leak fixed 20090520
		request = nil ;
		// send a fake response, which will send gotHeaders: to Broker, cancel and release this session
		[self abortSession] ;  // just to stop it immediately
        [self handleResponse:response
                       error:nil];
	}
	// end of fix added 2005 Nov 10

	// Code for compatibility with CURLHandle which does not have this method.  Tested, but currently not used.
	// else {
		// In the original Bookdog 2.0, we did not have this clause.  We simply returned the request, which caused
		// the system to request data from the new host specified by the location in the request.  Now, for
		// compabitility with CURLHandle, we instead abort the connection and set a new connection with the
		// new location from request.  The result is the same ??		
	//	//	request = nil ;
	//	[self abortConnection] ;
	//	[self setAndBeginConnectionWithURL:url] ;
	//}	
	
	
	// Optional code to use a HEAD request instead of a GET, but found that this gives wrong 
	//   answers from 26 out of 1200 websites.  See Results_Diff_GET_HEAD.xls
	// 2 of 2 places
	// NSMutableURLRequest* requestForHEAD = [NSMutableURLRequest requestWithURL:[request URL] cachePolicy:[request cachePolicy] timeoutInterval:[request timeoutInterval]] ;
	// [requestForHEAD setHTTPMethod:@"HEAD"] ;
	// return requestForHEAD

    if (completionHandler) {
        completionHandler(request);
    }
    
    [request release];
}

- (void)handleError:(NSError * _Nullable)error
              iCode:(NSInteger)iCode {
    NSString* verifierReason ;
    
    // We want to return the error that we got on the first try, if there was one,
    // instead of this error; unless this error is -1007 too many redirects
    if ((_errorIn1stResponse) && (iCode!=-1007) && (_errorIn1stResponse!=301) && (_errorIn1stResponse!=302)) {
        iCode = _errorIn1stResponse ;
        verifierReason = [self reasonOn1stTry] ;
    }
    else if (iCode == -1012) {
        verifierReason = [NSString localize:@"siteWantsPassword"] ;
    }
    else {
        verifierReason = [error localizedDescription] ;
    }
    
    //NSLog(@"Setting code of %@ to %i", [bookmark name], iCode) ;
    // Set keys "Bookmark, constKeyVerifierCode, and "Fix".  The latter may be overwritten, below
    NSMutableDictionary* headers = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [self bookmark], constKeyVerifierStark,
                                    [NSNumber numberWithInteger:BkmxFixDispoLeaveBroken], constKeyVerifierDisposition, // Default is to fix manually; this may be overwritten, below
                                    [NSNumber numberWithInteger:iCode], constKeyVerifierCode, // -1002 if scheme="feed", -1003 for no such TLD
                                    nil ] ;
    
    
    // Set keys constKeyVerifierReason and constKeyVerifierNsErrorDomain
    if (verifierReason) {
        [headers setObject:verifierReason forKey:constKeyVerifierReason] ;
    }
    NSString* verifierNSErrorDomain = [error domain] ;
    if (verifierNSErrorDomain) {
        [headers setObject:verifierNSErrorDomain forKey:constKeyVerifierNsErrorDomain] ;
    }
    // Now we consider each error code, in some cases look at other conditions, to...
    // Set keys constKeyVerifierAdviceArray, "Fix", constKeyVerifierSuggestedUrl and "Needs Retest":
    NSString* strURLNowHave = [[self bookmark] url] ;
    NSMutableArray* advice = [NSMutableArray array] ; // an empty array
    if (iCode < -1199)
    {
        [advice addObject:[NSNumber numberWithInteger:advUntrusted]] ;
    }
    else if (iCode < -1099)
    {
        [headers setObject:[NSNumber numberWithBool:YES] forKey:constKeyVerifierNeedsRetest] ;
        [advice addObject:[NSNumber numberWithInteger:advFileGone]] ;
    }
    else if (iCode == -1012) // "Needs Login"
    {
        [headers setObject:[NSNumber numberWithInteger:BkmxFixDispoLeaveAsIs] forKey:constKeyVerifierDisposition] ;
    }
    else if (iCode == -1007)
    {
        [advice addObject:[NSNumber numberWithInteger:advTooManyRedirects]] ;
    }
    else if (iCode < -1002)  // I'm not sure if advTryAgain applies to -1004
    {
        [headers setObject:[NSNumber numberWithBool:YES] forKey:constKeyVerifierNeedsRetest] ;
        [advice addObject:[NSNumber numberWithInteger:advTryAgain]] ;
    }
    else if (
             (iCode == -1002)     // -1002 is for "unsupported URL".  del.icio.us will show here
             ||
             (
              (iCode == -1000)  // -1000 is "Bad URL". Other javascripts will show here
              &&    ([strURLNowHave hasPrefix:@"javascript:"])
              )
             )
    {
        [headers setObject:[NSNumber numberWithInteger:BkmxFixDispoLeaveAsIs] forKey:constKeyVerifierDisposition] ;
    }
    
    else if (iCode < -1000)  // I'm not sure if advTryAgain applies to -1002, -1003, -1004
    {
        [headers setObject:[NSNumber numberWithBool:YES] forKey:constKeyVerifierNeedsRetest] ;
        [advice addObject:[NSNumber numberWithInteger:advTryAgain]] ;
    }
    else if (iCode < -999) {
        [advice addObject:[NSNumber numberWithInteger:advBadURL]] ;
    }
    else if (iCode < -998)
        [advice addObject:[NSNumber numberWithInteger:advHostGone]] ;
    
    [headers setObject:advice forKey:constKeyVerifierAdviceArray] ;
    
    if ((_errorIn1stResponse==301)||(_errorIn1stResponse==302))
    {
        [advice addObject:[NSNumber numberWithInteger:advBadRedirect]] ;
        if ([self fallbackProposedURL]) {
            // added this line to fix hang in verifying Matt's Bookmarks.plist in Tiger, 2005 Nov 10
            // This hang occurred from *** NSCFMutableDictionary: attempt to insert nil error caused by the next line:
            [headers setObject:[self fallbackProposedURL]
                        forKey:constKeyVerifierSuggestedUrl] ;
        }
        else {
            NSLog(@"Saved by the 2005 Nov 10 nil-fallback fix for bookmark %@", [[self bookmark] name]) ;
        }
    }
    else if ((iCode<-1002) && (iCode>-1005))  // iCode is -1003 or -1004
    {
        // Set verifierSuggestedUrl to existing scheme://domain
        NSURL* theURL = [NSURL URLWithString:strURLNowHave] ;  // nil if strURL is not a good URL
        NSString* theDomain = [strURLNowHave domainOfURL] ;  // nil if strURL is not a good URL
        
        if (theDomain && theURL) {
            [headers setObject:[NSString stringWithFormat:@"%@://%@", [theURL scheme], theDomain] forKey:constKeyVerifierSuggestedUrl] ;
        }
    }
    
    // Wipe out most everything if this was a dontVerify
    if ([[[self bookmark] dontVerify] boolValue]) {
        [headers setObject:[NSNumber numberWithInteger:BkmxFixDispoLeaveAsIs] forKey:constKeyVerifierDisposition] ;
        [headers setObject:[[BkmxBasis sharedBasis] labelDontVerify]
                    forKey:constKeyVerifierReason] ;
        [headers removeObjectForKey:constKeyVerifierNsErrorDomain] ;
        [headers removeObjectForKey:constKeyVerifierSuggestedUrl] ;
        [headers removeObjectForKey:constKeyVerifierCode] ;
        [headers removeObjectForKey:constKeyVerifierAdviceArray] ;
        [headers removeObjectForKey:constKeyVerifierNeedsRetest] ;
    }
    
    // Finally, add the "sender", and send it off
    [headers setObject:self forKey:constKeyVerifierHeaderGetter];

    [self sendHeaders:headers];
}

- (void)       URLSession:(NSURLSession *)session
didBecomeInvalidWithError:(NSError *)error {
	NSInteger iCode = [error code];
	
	// We've got what we need, so kill this dog
	[self abortSession] ;

	if ((_errorIn1stResponse==0)  && (iCode < -1199)) {
		// Some "Untrusted Certificate" errors will give us a redirect
		// if we try again replacing the scheme https with http 
		_errorIn1stResponse = iCode ;
		[self setReasonOn1stTry:[error localizedDescription]] ;
		[self doConnect] ;
	}
	else if (error) {
        if ([[NSThread currentThread] isMainThread]) {
            [self handleError:error
                        iCode:iCode];
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self handleError:error
                            iCode:iCode];
            });
        }
	}
}

@end
