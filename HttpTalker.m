#import "HttpTalker.h"
#import "BkmxBasis.h"
#import "Client.h"
#import "SSYKeychain.h"
#import "SSYSynchronousHttp.h"
#import "NSError+InfoAccess.h"
#import "NSString+LocalizeSSY.h"
#import "ExtoreWebFlat.h"
#import "NSBundle+MainApp.h"

// states
enum {
	kStartOver = 0,
	kCheckIfPassword = 17,
	kGotPasswordReadyToTry = 26,
	kDoneSucceeded = 90,
	kDoneFailed = 91
} ;


@interface HttpTalker ()

@property (assign) Client* client ;
@property (copy) NSString* url ;
@property (copy) NSString* bodyString ;
@property (copy) NSString* httpMethod ;
@property (assign) NSTimeInterval timeout ;
@property (retain) NSHTTPURLResponse* response ;
@property (retain) NSData* responseData ;
@property (retain) NSDate* timeToGiveUp ;
@property (assign) BOOL usernameIsFromClient ;
@property (retain) NSError* error ;

@end

@implementation HttpTalker

@synthesize client = m_client ;
@synthesize url ;
@synthesize bodyString ;
@synthesize httpMethod ;
@synthesize timeout = m_timeout ;
@synthesize response ;
@synthesize responseData ;
@synthesize timeToGiveUp ;
@synthesize usernameIsFromClient ;
@synthesize error = m_error ;

+ (NSString*)userAgent {
	NSBundle* mainBundle = [NSBundle mainAppBundle] ;
	NSString* appName = [[BkmxBasis sharedBasis] appNameUnlocalized] ;
	NSString* appVersion = [mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"] ;
	NSString* userAgent = [NSString stringWithFormat:@"%@/%@", appName, appVersion] ;
	// For Google, had to use @"Mozilla/5.0 (Macintosh; U; Intel macOS; en) AppleWebKit/418.9.1 (KHTML, like Gecko) Safari/419.3"

	return userAgent ;
}
	

- (void)tryPayload {
	/* If the stupid URL Loading System in Tiger finds a credential for del.icio.us in
		NSURLCredentialStorage, it will use it instead of presenting an
		authentication challenge to the NSURLConnection delegate.  This
		could result in data from the wrong account being accessed if this
		default credential is not the one for the account we want now.  To 
		solve this, before opening the connection we create a credential for
		the desired account, create a protection space for del.icio.us, and
		then tell NSURLCredential storage to set the former as the default
		credential for the latter.  
		
		This is fixed, and the default credential set here is ignored in Leopard.
		In Leopard, SSYSynchronousHttp receives -connection:didReceiveAuthenticationChallenge,
		which provides the correct credential.  So, the following code is for Tiger only,
		although it does not do any harm in Leopard.  */
	// Reuseable Variables
	NSURLCredentialStorage* sharedCredentialStorage = [NSURLCredentialStorage sharedCredentialStorage] ;
	NSURLProtectionSpace* protectionSpace ;
	NSURLCredential* credential ;
	
#if 0
#warning HttpTalker is purging credentials
	NSEnumerator* e ; 
	NSEnumerator* f ;
	NSDictionary* credentials ;
	NSString* credentialKey ;
	credentials = [sharedCredentialStorage allCredentials] ;
	e = [credentials keyEnumerator] ;
	while ((protectionSpace = [e nextObject])) {
		if ([[protectionSpace host] containsString:@"del.icio.us"]) {
			NSDictionary* credentials = [sharedCredentialStorage credentialsForProtectionSpace:protectionSpace] ;
			f = [credentials keyEnumerator] ;
			while ((credentialKey = [f nextObject])) {
				credential = [credentials objectForKey:credentialKey] ;
				[sharedCredentialStorage removeCredential:credential forProtectionSpace:protectionSpace] ;
				NSLog(@"CreDebug:       ** Removed credential key: %@", credentialKey) ;
				NSLog(@"CreDebug:                     description: %@", credential) ;
				NSLog(@"CreDebug:                            host: %@", [credential user]) ;
				NSLog(@"CreDebug:                        password: %@", [credential password]) ;
				NSLog(@"CreDebug:                     persistence: %ld", (long)[credential persistence]) ;
			}
		}
	}
	NSLog(@"CreDebug:\n\nAfter removing all") ;
	while ((protectionSpace = [e nextObject])) {
		if ([[protectionSpace host] containsString:@"del.icio.us"]) {
			NSLog(@"CreDebug: PROTECTION SPACE       host: %@", [protectionSpace host]) ;
			NSLog(@"CreDebug:                     address: %p", protectionSpace) ;
			NSLog(@"CreDebug:                     isProxy: %ld", (long)[protectionSpace isProxy]) ;
			NSLog(@"CreDebug:                        port: %ld", (long)[protectionSpace port]) ;
			NSLog(@"CreDebug:                    protocol: %@", [protectionSpace protocol]) ;
			NSLog(@"CreDebug:                   proxyType: %@", [protectionSpace proxyType]) ;
			NSLog(@"CreDebug:                       realm: %@", [protectionSpace realm]) ;
			NSLog(@"CreDebug:  receivesCredentialSecurely: %ld", (long)[protectionSpace receivesCredentialSecurely]) ;
			NSLog(@"CreDebug:           defaultCredential: %@", [sharedCredentialStorage defaultCredentialForProtectionSpace:protectionSpace]) ;
			credentials = [sharedCredentialStorage credentialsForProtectionSpace:protectionSpace] ;
			f = [credentials keyEnumerator] ;
			credentialKey ;
			while ((credentialKey = [f nextObject])) {
				NSURLCredential* credential = [credentials objectForKey:credentialKey] ;
				NSLog(@"CreDebug:                **CREDENTIAL key: %@", credentialKey) ;
				NSLog(@"CreDebug:                     description: %@", credential) ;
				NSLog(@"CreDebug:                            host: %@", [credential user]) ;
				NSLog(@"CreDebug:                        password: %@", [credential password]) ;
				NSLog(@"CreDebug:                     persistence: ld", (long)[credential persistence]) ;
			}
		}
	}
#endif
	
	// Create new credential
	credential = [NSURLCredential credentialWithUser:[[self client] profileName]
											password:[[self client] serverPassword]
										 persistence:NSURLCredentialPersistenceForSession] ;
	// Using NSURLCredentialPersistencePermanent would store it in keychain.
		// We don't do that because did that earlier,
		// but only if the user checked the box.
	// Create new protection space
	protectionSpace = [[NSURLProtectionSpace alloc] initWithHost:@"api.del.icio.us"
															port:0  // 0 = "use default port for protocol"
														protocol:@"https"
														   realm:@"del.icio.us API"
											authenticationMethod:NSURLAuthenticationMethodDefault] ;
	// In the above, it is important to use the realm "del.icio.us API", because this
	// is the realm given in the protection space of the authentication challenge from del.icio.us.
	// Otherwise, the URL Loading system will create a new protection space after
	// it succesfully logs in, with realm "del.icio.us API", and will make it the
	// default credential for that realm, and then in subsequent requests it will
	// just use this credential without even sending a didReceiveAuthenticationChallenge
	// to the NSURLConnection delegate.  Thus, the delegate does not get the opportunity
	// to specify a username.  So, if a different account is in fact desired, this
	// will result in the wrong account being accessed.

	// Install new credential for new protection space
	[sharedCredentialStorage setDefaultCredential:credential
							   forProtectionSpace:protectionSpace] ;
    // Added in BookMacster 1.12 to fix memory leak reported by clang:
    [protectionSpace release] ;
	
//	NSLog(@"8370 Protection space with host:%@ protocol:%@ realm:%@\nnow has default credential with username:%@ password:%@", [protectionSpace host], [protectionSpace protocol], [protectionSpace realm], [credential user], [credential password]) ;

#if 0
#warning HttpTalker is logging credentials
	credentials = [sharedCredentialStorage allCredentials] ;
	e = [credentials keyEnumerator] ;
	NSLog(@"CreDebug:\n\nAfter removing old and setting new default credential %p for api.del.icio.us/%p to %@:%@", credential, protectionSpace, [credential user], [credential password] ) ;
	while ((protectionSpace = [e nextObject])) {
		if ([[protectionSpace host] containsString:@"del.icio.us"]) {
			NSLog(@"CreDebug: PROTECTION SPACE       host: %@", [protectionSpace host]) ;
			NSLog(@"CreDebug:                     address: %p", protectionSpace) ;
			NSLog(@"CreDebug:                     isProxy: %ld", (long)[protectionSpace isProxy]) ;
			NSLog(@"CreDebug:                        port: %ld", (long)[protectionSpace port]) ;
			NSLog(@"CreDebug:                    protocol: %@", [protectionSpace protocol]) ;
			NSLog(@"CreDebug:                   proxyType: %@", [protectionSpace proxyType]) ;
			NSLog(@"CreDebug:                       realm: %@", [protectionSpace realm]) ;
			NSLog(@"CreDebug:  receivesCredentialSecurely: %ld", (long)[protectionSpace receivesCredentialSecurely]) ;
			NSLog(@"CreDebug:           defaultCredential: %@", [sharedCredentialStorage defaultCredentialForProtectionSpace:protectionSpace]) ;
			credentials = [sharedCredentialStorage credentialsForProtectionSpace:protectionSpace] ;
			f = [credentials keyEnumerator] ;
			credentialKey ;
			while ((credentialKey = [f nextObject])) {
				NSURLCredential* credential = [credentials objectForKey:credentialKey] ;
				NSLog(@"CreDebug:                **CREDENTIAL key: %@", credentialKey) ;
				NSLog(@"CreDebug:                     description: %@", credential) ;
				NSLog(@"CreDebug:                            host: %@", [credential user]) ;
				NSLog(@"CreDebug:                        password: %@", [credential password]) ;
				NSLog(@"CreDebug:                     persistence: %ld", (long)[credential persistence]) ;
			}
		}
	}
#endif	

	NSHTTPURLResponse* response_ = nil ;
	NSData* responseData_ = nil ;
	NSError* error = nil ;
	
	// SSYSynchronousHttp is my wrapper around NSURLConnection which also operates in another thread
	// (since the timeout in Apple's NSURLConnection doesn't work).  The main thread polls the worker
	// thread for a response, or until the timeout occurs.  It's all very complicated.
	BOOL ok = [SSYSynchronousHttp SSYSynchronousHttpUrl:[self url]
											 httpMethod:[self httpMethod]
												headers:nil
											 bodyString:[self bodyString] 
											   username:[[self client] profileName]
											   password:[[self client] serverPassword]
												timeout:[self timeout] 
											  userAgent:[HttpTalker userAgent] 
											 response_p:&response_ 
										  receiveData_p:&responseData_
												error_p:&error] ;
	[self setResponse:response_] ;
	// The following line of code was inside if(ok){} below until BookMacster 1.7/1.6.8, because when
	// Diigo sends a throttling error it puts a "message" in the response data.
	// Until BookMacster 1.7/1.6.8, the following line of code was inside if(ok){} below.
	[self setResponseData:responseData_] ;
	
	if (ok) {
		_whatsNext = 90 ;
		// 	[self setResponseData:responseData_] ; // Until BookMacster 1.7/1.6.8
	}
	else {
		// Return error
		[self setError:error] ;
		
		_whatsNext = 91 ;
	}	
}

- (void)askUserToSelectAccountIfNone {
	if ([[self client] profileName]) {
		_whatsNext = 17 ;
	}
	else {
		NSError* error = [NSError errorWithDomain:BkmxExtoreWebFlatErrorDomain
											 code:constNonhierarchicalWebAppErrorCodeNeedsAccountInfo
										 userInfo:nil] ;
		error = [error errorByAddingLocalizedDescription:[NSString localize:@"accountInfoMissing"]] ;
		error = [error errorByAddingPrettyFunction:__PRETTY_FUNCTION__] ;
		[self setError:error] ;
		_whatsNext = 91 ;
	}
}

- (void)getPasswordFromKeychainIfNeeded {
	// First try: Cached in Client
	NSString* password = [[self client] serverPassword] ;
	
	// Second try: Keychain
	if (!password) {
        password = [SSYKeychain passwordForServost:[[self client] webHostName]
                                       trySubhosts:[ExtoreWebFlat trySubhosts]
                                           account:[[self client] profileName]
                                             clase:(NSString*)kSecClassInternetPassword
                                           error_p:NULL] ;
		[[self client] setServerPassword:password] ;
	}
	
	// Now, see if we succeeded or failed for next state
	if (password) {
		_whatsNext = 26 ;
	}
	else {
		NSError* error = [NSError errorWithDomain:BkmxExtoreWebFlatErrorDomain
											 code:constNonhierarchicalWebAppErrorCodeNeedsAccountInfo
										 userInfo:nil] ;
		error = [error errorByAddingLocalizedDescription:[NSString localize:@"accountInfoMissing"]] ;
		[self setError:error] ;
		_whatsNext = 91 ;
	}
}

- (BOOL)runStateMachineUntilDone {
	while ((_whatsNext != kDoneSucceeded) && (_whatsNext != kDoneFailed)) {
		//NSLog(@"RebugLog: 16836 _whatsNext = %i", _whatsNext) ;
		switch (_whatsNext) {
			case 0: 
				[self askUserToSelectAccountIfNone] ;
				break ;
			case 17: 
				[self getPasswordFromKeychainIfNeeded] ;
				break ;
			case 26:	
				[self tryPayload] ;
				break ;
			default:
				NSLog(@"HttpTalker unknown state %ld", (long)_whatsNext) ;
		}
	}
	//NSLog(@"RebugLog: 17836 _whatsNext = %i", _whatsNext) ;
	
	return (_whatsNext == kDoneSucceeded) ;
}

- (id)initWithURL:(NSString*)url_
	   httpMethod:(NSString*)httpMethod_
	   bodyString:(NSString*)bodyString_
		  timeout:(CGFloat)timeout
		   client:(Client*)client {
	if ((self = [super init])) {
		[self setUrl:url_] ;
		[self setHttpMethod:httpMethod_] ;
		[self setBodyString:bodyString_] ;
		[self setTimeout:timeout] ;
		[self setResponse:nil] ;
		[self setResponseData:nil] ;
		[self setClient:client] ;
	}
	
	return self ;
}

- (void) dealloc {
	[url release] ;
	[httpMethod release] ;
	[bodyString release] ;
	[response release] ;
	[responseData release] ;
	[timeToGiveUp release] ;
	[m_error release] ;

	[super dealloc];
}

#if 0
#define LOG_RESPONSE_TIMES 1
#endif

+ (BOOL)talkToSubpathQuery:(NSString*)subpathQuery
				httpMethod:(NSString*)httpMethod
					client:(Client*)client
				   timeout:(CGFloat)timeout
			 receiveData_p:(NSData**)hdlResponseData 
				   error_p:(NSError**)error_p {
	BOOL ok = NO ;
    NSError* error = nil ;
	NSString* filePath = [client filePathError_p:&error] ;
    NSString* url = [filePath stringByAppendingString:subpathQuery] ;
#define HTTP_TALKER_MAX_TRIALS_COUNT 2
    CGFloat timeoutEach = timeout/HTTP_TALKER_MAX_TRIALS_COUNT ;
    if (url && !error) {
        NSInteger nTrials = 0 ;
        while (YES) {
            HttpTalker* instance = [[HttpTalker alloc] initWithURL:url
                                                        httpMethod:httpMethod
                                                        bodyString:nil
                                                           timeout:timeoutEach
                                                            client:client] ;
            
#if LOG_RESPONSE_TIMES
            NSDate* startDate = [NSDate date] ;
#endif
            ok = [instance runStateMachineUntilDone] ;
#if LOG_RESPONSE_TIMES
            NSDate* endDate = [NSDate date] ;
#endif
            if (hdlResponseData) {
                *hdlResponseData = [instance responseData] ;
            }
            
            error = [instance error] ;
            
            [instance release] ;

            nTrials++ ;
            if (ok) {
#if LOG_RESPONSE_TIMES
                NSLog(@"Success-secs: %0.3f  %07.3f", [startDate timeIntervalSinceReferenceDate], [endDate timeIntervalSinceDate:startDate]) ;
#endif
                break ;
            }
            if (nTrials > HTTP_TALKER_MAX_TRIALS_COUNT) {
                break ;
            }
            
#if LOG_RESPONSE_TIMES
            NSLog(@"Fail #%ld-secs: %0.3f  %07.3f", nTrials, [startDate timeIntervalSinceReferenceDate], [endDate timeIntervalSinceDate:startDate]) ;
#endif
            
            // For a timeout error, none of the following four will break
            if ([error code] != -1001) {
#if LOG_RESPONSE_TIMES
                NSLog(@"Breaking because outer errorCode = %ld", (long)[error code]) ;
#endif
                break ;
            }
            if (![[error domain] isEqualToString:SSYSynchronousHttpErrorDomain]) {
#if LOG_RESPONSE_TIMES
                NSLog(@"Breaking because outer error domain = %@", [error domain]) ;
#endif
                break ;
            }
            NSError* underlyingError = [[error userInfo] objectForKey:NSUnderlyingErrorKey] ;
            if ([underlyingError code] != -1001) {
#if LOG_RESPONSE_TIMES
                NSLog(@"Breaking because underlying errorCode = %ld", (long)[underlyingError code]) ;
#endif
                break ;
            }
            if (![[underlyingError domain] isEqualToString:NSURLErrorDomain]) {
#if LOG_RESPONSE_TIMES
                NSLog(@"Breaking because underlying error domain = %@", [underlyingError domain]) ;
#endif
                break ;
            }
        }
    }

	if (error && error_p) {
		*error_p = error ;
	}
	
	return ok ;
}

@end
