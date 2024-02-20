#import "GoogleTalker.h"
#import "Client.h"
#import "SSYKeychain.h"
#import "SSYSynchronousHttp.h"
#import "SSYUserInfo.h"
#import "NSString+URIQuery.h"
#import "NSData+Base64.h"
#import "NSString+SSYExtraUtils.h"
#import "NSString+LocalizeSSY.h"
#import "NSScanner+GeeWhiz.h"
#import "NSError+SSYAdds.h"
#import "ExtoreGoogle.h"
#import "SSWebBrowsing.h"
#import "SSYLabelledTextField.h"
#import "Bkmslf.h"
#import "NSDictionary+SimpleMutations.h"
#import "Ixporter.h"
#import "NSHTTPURLResponse+Descriptions.h"

NSString* const constUserAgentForGoogle = @"Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en) AppleWebKit/418.9.1 (KHTML, like Gecko) Safari/419.3" ;
// At one point, in makeSureHasGoogleIDGetFrom..., I found that Google returned
// "no search results" if the search string had encoded non-ASCII characters in it, but if
// I changed the User-Agent from the defaut value of CFNetwork to the above, spoofing Safari,
// then it was able to find the bookmark.  Very scary!!!	



@implementation GoogleTalker

+ (NSString*)zxRandomBase64 {
	NSInteger i1 = random() ;
	NSInteger i2 = random() ;
	NSInteger integers[2] ;
	integers[0] = i1 ;
	integers[1] = i2 ;
	NSData* data = [[NSData alloc] initWithBytes:integers length:8] ;
	NSString* b64 = [data stringBase64Encoded] ;	
	[data release] ;
	
	// Now, some fixing, as required by Google
	NSMutableString* zx = [[NSMutableString alloc] initWithString:b64] ;
	// Since we've base64 encoded a 64-bit number, the result
	// will require 64/(log2(64) = 10.666 digits = 11 digits
	// Since a base64 number will always be a multiple of 3?4
	// digits, the last digit will be a "=" pad digit to make 12.
	// So, we remove that and also substitute for the two
	// nonalphanumeric characters that Google seems to use.
	[zx deleteCharactersInRange:NSMakeRange(11,1)] ;
	[zx replaceOccurrencesOfString:@"+"
						withString:@"-"] ;
	[zx replaceOccurrencesOfString:@"/"
						withString:@"_"] ;
	
	NSString* output = [zx copy] ;
	[zx release] ;
	
	return [output autorelease] ;
}

+ (uint32_t)zxRandomDecimal {
	return random() ;
}

+ (NSString*)findEmailInGoogleManageAccountHtml:(NSString*)html {
	// Unfortunately, NSHTTPCookieStorage might not always report cookie changes,
	// as explained in:
	// http://www.cocoabuilder.com/archive/message/cocoa/2007/3/28/181070
	// and even when it does, it might be until a few seconds after the cookie
	// has been deleted.
	
	// So, as a defense against "false alarm" logged-in detections, 
	// we check that the given string does not contain a string: "id=\"Passwd\"".
	// If it does, this is probably a field in the "sign in" button, which means
	// that we got the "sign in" page instead of the user's "manage account" page.
	if ([html containsString:@"id=\"Passwd\""]) {
		return nil ;
	}
	
	NSScanner* scanner = [[NSScanner alloc] initWithString:html] ;
	BOOL done = NO ;
	NSString* domain = @"" ;
	NSMutableString* name = nil ;
	
	while (!done && ![scanner isAtEnd]) {
		BOOL okSoFar = YES ;
		
		NSInteger atLoc ;
		if (okSoFar) {
			BOOL scanned = [scanner scanUpToAndThenLeapOverString:@"@" intoString:NULL] ;
			atLoc = [scanner scanLocation] ;
			if (!scanned || [scanner isAtEnd]) {
				okSoFar = NO ;
			}
		}
		
		if (okSoFar) {
			domain = @"";
			[scanner scanUpToString:@"<" intoString:&domain] ;
			[scanner release] ;
			if ([domain length] < 2) {
				okSoFar = NO ;
			}
		}
		
		if (okSoFar) {
			unichar chr ;	
			name = [NSMutableString stringWithCapacity:32] ;
			NSInteger i = 2 ;
			while ((chr = [html characterAtIndex:(atLoc-i)]) != '>') {
				[name insertString:[NSString stringWithCharacters:&chr length:1] atIndex:0] ;
				i++ ;
			}
			if ([name length] < 1) {
				okSoFar = NO ;
			}
		}
		
		if (okSoFar) {
			done = YES ;
		}
	}
	
	NSString* answer = done ? [NSString stringWithFormat:@"%@@%@", name, domain] : nil ;
	return answer ;
}


/* profileName_p must not be NULL */

+ (BOOL)cookieExists {
	// Determine whether or not the URL Loading System might be logged into Google,
	// by looking for a cookie from google.com named "LSID" which is secure.
	BOOL cookieExists = NO ;
	NSHTTPCookieStorage* sharedCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage] ;
	NSArray* cookies = [sharedCookieStorage cookies] ;
	NSEnumerator* e = [cookies objectEnumerator] ;
	NSHTTPCookie* cookie ;
	while ((cookie = [e nextObject])) {
		NSString* domain = [cookie domain] ;
		if ([domain hasSuffix:@"google.com"]) {
			if ([[cookie name] isEqualToString:@"LSID"]) {
				if ([cookie isSecure]) {
					cookieExists = YES ;
					break ;
				}
			}
		}
	}
	
	return cookieExists ;
}

+ (BOOL)getCurrentlyLoggedinProfileName_p:(NSString**)profileName_p
								  error_p:(NSError**)error_p {
	BOOL ok = YES ;
	NSError* error = nil ;
	*profileName_p = nil ;
	
	// We request the ManageAccount window from Google,
	// and parsing out the profileNameEmail.  I wish there was a better way!
	NSString* urlString = [[NSString alloc] initWithFormat:@"https://www.google.com/accounts/ManageAccount"] ; 
	NSHTTPURLResponse* response = nil ;
	NSData* data = nil ;
	
	if (![self cookieExists]) {
		goto end ;
	}
	
	ok = [SSYSynchronousHttp SSYSynchronousHttpUrl:urlString
										httpMethod:@"GET"
										   headers:nil
										bodyString:nil 
										  username:nil
										  password:nil
										   timeout:10.0 
										 userAgent:constUserAgentForGoogle 
										response_p:&response 
									 receiveData_p:&data
										   error_p:&error] ;
	if (!ok) {
		goto end ;
	}
	
	NSString* s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
	*profileName_p = [self findEmailInGoogleManageAccountHtml:s] ;

	[s release] ;

end:
	[urlString release] ;
	
	if (!ok && error_p) {
		NSString* msg = @"Could not determine currently-logged-in Google account" ;
		error = [SSYMakeError(25123, msg) errorByAddingUnderlyingError:error] ;
		NSString* key ;
		key = [NSString stringWithFormat:@"Response received by %s", __PRETTY_FUNCTION__] ;
		error = [error errorByAddingUserInfoObject:[response longDescription]
											forKey:key] ;
		NSString* html = [[NSString alloc] initWithData:data
											   encoding:NSASCIIStringEncoding] ;
		key = [NSString stringWithFormat:@"ManageAccount HTML received by %s", __PRETTY_FUNCTION__] ;
		error = [error errorByAddingUserInfoObject:html
											forKey:key] ;
		[html release] ;
		*error_p = error ;
	}
	
	return ok ;
}

+ (NSError*)credentialNotAcceptedErrorForSecItemRef:(SecKeychainItemRef)itemRef
										   username:(NSString*)username
									gotFromKeychain:(BOOL)gotFromKeychain {
	NSInteger code = gotFromKeychain ? SSYSynchronousHttpStateKeychainCredentialNotAccepted : SSYSynchronousHttpStateCredentialNotAccepted ;
	NSError* error = [NSError errorWithDomain:SSYSynchronousHttpErrorDomain
										 code:code
									 userInfo:nil] ;
	NSString* msg = [NSString stringWithFormat:
					 @"%@ : %@",
					 [NSString localizeFormat:
					  @"testXResults",
					  [NSString localize:@"connection"]],
					 [NSString localizeFormat:@"failed"]] ;
	
	error = [error errorByAddingLocalizedDescription:msg] ;
	error = [error errorByAddingLocalizedFailureReason:[NSString localizeFormat:
														@"accountInfoBadX",
														username]] ;
	if (gotFromKeychain) {
		// Include info needed to recover from error by removing the
		// bad keychain item.
		NSString* remove = [NSString localize:@"remove"] ;
		msg = [NSString localizeFormat:
			   @"accountInfoBadFixKeyX",
			   remove] ;
		error = [error errorByAddingLocalizedRecoverySuggestion:msg] ;
		error = [error errorByAddingLocalizedRecoveryOptions:[NSArray arrayWithObjects:
															  remove,
															  [NSString localize:@"cancel"],
															  nil]] ;
		NSValue* itemRefObject = [NSValue value: &itemRef
								   withObjCType:@encode(SecKeychainItemRef)] ;
		error = [error errorByAddingUserInfoObject:itemRefObject
											forKey:SSYKeychainItemRef] ;
	}
	
	return error ;
}

+ (BOOL)logInForClient:(Client*)client
			   error_p:(NSError**)error_p{
	BOOL ok = NO ;
	// Must declare these and assign values before first 'goto end' (Fixed in 0.8.4, 0.9.4)
	NSError* error = nil ;
	NSString* galx = @"Nadda" ;
	NSString* responseString = nil ;
	NSHTTPURLResponse* response_ = nil ;
	NSData* responseData_ = nil ;
	NSString* currentProfileName = nil ;

	// If client has no serverPassword, try to get from keychain
	SecKeychainItemRef itemRef ;
	BOOL gotFromKeychain = NO ;
	if (![client serverPassword]) {
		NSString* password = [SSYKeychain internetPasswordUsername:[client profileName]
															  host:[client webHostName]
												possibleSubdomains:[NSArray arrayWithObject:@"www"]
															domain:nil
												   keychainitemRef:&itemRef] ;
		if (password) {
			// Note: serverPassword is a regular, volatile instance variable.
			[client setServerPassword:password] ;
			gotFromKeychain = YES ;
		}
	}
	
	NSString* accountEmail = [client profileName] ;
	NSString* password = [client serverPassword] ;
	
	if (!accountEmail || !password) {
		error = [NSError errorWithDomain:SSYSynchronousHttpErrorDomain
									code:SSYSynchronousHttpStateNeedUsernamePasswordToMakeCredential
								userInfo:nil] ;
		error = [error errorByAddingDontShowSupportEmailButton] ;
		NSString* desc = [NSString stringWithFormat:
						  @"%@\n\n%@",
						  [client displayName],
						  [NSString localizeFormat:
						   @"failedX",
						   [NSString localize:@"connection"]]] ;
						  
		error = [error errorByAddingLocalizedDescription:desc] ;
		error = [error errorByAddingLocalizedFailureReason:[NSString localize:@"accountInfoMissing"]] ;
		
		ok = NO ;
		goto end ;
	}
	
	NSString* body ;
	NSString* encodedBody ;
	
	// Get the GALX value
	
	NSString* urlString = @"https://www.google.com/accounts/Login" ;
	ok = [SSYSynchronousHttp SSYSynchronousHttpUrl:urlString
										httpMethod:@"GET"
										   headers:nil
										bodyString:nil 
										  username:nil
										  password:nil
										   timeout:20.0
										 userAgent:constUserAgentForGoogle 
										response_p:&response_ 
									 receiveData_p:&responseData_
										   error_p:&error] ;
	
	if (!ok) {
		error = [error errorByAddingUserInfoObject:@"Getting GALX"
											forKey:@"Request Description"] ;
		goto end ;
	}
	
	NSArray* cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[response_ allHeaderFields]
															  forURL:[NSURL URLWithString:urlString]] ;
	for (NSHTTPCookie* cookie in cookies) {
		// As far as I've seen, there's only one cookie, so this loop only executes once.
		if ([[cookie name] isEqualToString:@"GALX"]) {
			galx = [cookie value] ;
		}
	}
	// If we don't get a galx value, we'll probably fail, but just continue on
	// in case it works anyhow.
	// I suppose that Google could eliminate the GALX at some point!
	
	// Do the actual login
		
	body = [NSString stringWithFormat:@"Email=%@&Passwd=%@&PersistentCookie=yes&GALX=%@",
			accountEmail,
			password,
			galx] ;
	// Reverse-engineering the tcpflow of Google's login (with https changed to http),
	// I see that they percent-escape encode the "@" in emails, even though this is
	// not strictly per RFC2396.  So, we encode the "@" too:
	encodedBody = [body encodePercentEscapesPerStandard:SSYPercentEscapeStandardRFC2396
												 butNot:@""
												butAlso:@"@"] ;
	
	ok = [SSYSynchronousHttp SSYSynchronousHttpUrl:@"https://www.google.com/accounts/LoginAuth"
										httpMethod:@"POST"
										   headers:nil
										bodyString:encodedBody 
										  username:nil
										  password:nil
										   timeout:20.0
										 userAgent:constUserAgentForGoogle 
										response_p:&response_ 
									 receiveData_p:&responseData_
										   error_p:&error] ;
	
	if (!ok) {
		error = [error errorByAddingUserInfoObject:@"Logging In"
											forKey:@"Request Description"] ;
		goto end ;
	}

	responseString = [[NSString alloc] initWithData:responseData_ encoding:NSASCIIStringEncoding] ;	
	
	if ([responseString containsString:@"https://www.google.com/accounts/LoginAuth"]) {
		// Google is requesting that we log in.  But since we *did* have a username
		// and password, and since Google returned 200, must be a bad
		// username or password.
		error = [self credentialNotAcceptedErrorForSecItemRef:itemRef
													 username:accountEmail
											  gotFromKeychain:gotFromKeychain] ;
		ok = NO ;
		goto end ;
	}
	
	if ([responseString containsString:@"captcha"]) {
		NSLog(@"responseString including CAPTCHA = \n%@", responseString) ;
		// I've seen this happen when trying to change accounts from the same IP address,
		// Probably Google is suspicious and has decided to present a CAPTCHA challenge
		
		// But I'm not sure how to detect it.  I imagine that it also contains the string LoginAuth
		/*
		 <li>Now handles CAPTCHA challenges which are now sometimes issued by Google
		 when attempting to access bookmarks in one Google account immediately after
		 accessing bookmarks from a different Google account.&nbsp; (Therefore,
		 this only affects the few users that have more than one Google account.)
		 A CAPTCHA challenge is the field of wavy characters which you must read to
		 prove that you are a real person.&nbsp; The new behavior is to open the
		 Google login page in the web browser so that you can do this.&nbsp;
		 The old behavior was to repeatedly show the same progress window until the
		 Cancel button was clicked, with no clue as to what the problem was.</li>
		 */

		// Must be a CAPTCHA challenge
		[SSWebBrowsing browseToURLString:@"https://www.google.com/bookmarks"
				 browserBundleIdentifier:@"com.apple.Safari"
								activate:YES] ;

		error = [self credentialNotAcceptedErrorForSecItemRef:itemRef
													 username:accountEmail
											  gotFromKeychain:gotFromKeychain] ;
		ok = NO ;
		goto end ;
	}

	// If we made it this far, apparently we logged in successfully

	// Make sure that the URL Loading System thinks that it is logged into Google,
	// by looking for a cookie from google.com named "LSID" which is secure.
	if (![self cookieExists]) {
		error = [NSError errorWithDomain:SSYNonhierarchicalWebAppErrorDomain
									code:constNonhierarchicalWebAppErrorCodeLoginCookieDidNotStick
								userInfo:nil] ;
		ok = NO ;
		goto end ;
	}
	
	// At this point, at least in the USA, the responseString contains the Manage Account
	// HTML; i.e. what you get from https://www.google.com/accounts/ManageAccount .
	// However, user Jan Fiksdal in Norway instead gets a funky Javascript redirect:
	/*
	 <html>
	 <head>
	 <title>Redirecting</title>
	 <meta http-equiv="refresh" content="0; url=&#39;http://www.google.no/accounts/SetSID?ssdc=1&amp;sidt=e5fXySUBAAA%3D.PUHNibIi8iNsUTDpPRWo6VoSQVxxJa2%2Fva6BgEjqZ9W1ttKaD6asc37sY9lataCGv5BH7yqCJfzsFuIyHnOo54JLjk%2FsS6DKbrDj8MhZ1htW4SYDkY445NbvaQcQYQXti4u8gGfFeYwORYTTuuFzt0seCbKtm5SGrtfYKijqBYFQt4ZmjbHGxF99Qva7aZxjgns9iw06UCz1A6RdPcDPSBEnmDwAhAaqQV1Hcnq4WV%2BBNG7T1iHeytwz9Sz5KECBcXxqQreNmIFJK4U67wkCuOrzKuvx5sD%2BmnyMSJHPzM4%3D.PuC1Wc%2F3f7j9aOwpc5nTfA%3D%3D&amp;continue=https%3A%2F%2Fwww.google.com%2Faccounts%2FManageAccount&#39;">
	 </head>
	 <body bgcolor="#ffffff" text="#000000" link="#0000cc" vlink="#551a8b" alink="#ff0000">
	 <script type="text/javascript" language="javascript">
	 location.replace("http://www.google.no/accounts/SetSID?ssdc\x3d1\x26sidt\x3de5fXySUBAAA%3D.PUHNibIi8iNsUTDpPRWo6VoSQVxxJa2%2Fva6BgEjqZ9W1ttKaD6asc37sY9lataCGv5BH7yqCJfzsFuIyHnOo54JLjk%2FsS6DKbrDj8MhZ1htW4SYDkY445NbvaQcQYQXti4u8gGfFeYwORYTTuuFzt0seCbKtm5SGrtfYKijqBYFQt4ZmjbHGxF99Qva7aZxjgns9iw06UCz1A6RdPcDPSBEnmDwAhAaqQV1Hcnq4WV%2BBNG7T1iHeytwz9Sz5KECBcXxqQreNmIFJK4U67wkCuOrzKuvx5sD%2BmnyMSJHPzM4%3D.PuC1Wc%2F3f7j9aOwpc5nTfA%3D%3D\x26continue\x3dhttps%3A%2F%2Fwww.google.com%2Faccounts%2FManageAccount")
	 </script>
	 </body>
	 </html>
	 */
	// You see, that location.replace() Javascript function in the <body> tells the browser to
	// immediately change locations to http://www.google.no/accounts/, with a query to set
	// a certain session ID, and then continue on to https://www.google.com/accounts/ManageAccount
	// So, as of version 0.9.2, instead of parsing the current responseString to get out the
	// profileName, we invoke this method to get it from scratch:
	ok = [self getCurrentlyLoggedinProfileName_p:&currentProfileName
										 error_p:&error] ;
	
	if (!ok) {
		error = [error errorByAddingUserInfoObject:[NSString stringWithUTF8String:__PRETTY_FUNCTION__]
																		   forKey:@"Where"] ;
		ok = NO ;
		goto end ;
	}
	
	if (!currentProfileName) {
		error = [NSError errorWithDomain:SSYNonhierarchicalWebAppErrorDomain
									code:constNonhierarchicalWebAppErrorCodeAccountNameDidNotEcho
								userInfo:nil] ;
		ok = NO ;
		goto end ;
	}
	
	// Finally!  All tests have passed!!
	ok = YES ;
	
	if (![currentProfileName isEqualToString:[client profileName]]) {
		if (
			[currentProfileName hasSuffix:@"@gmail.com"]
			||
			[currentProfileName hasSuffix:@"@googlemail.com"]
			) {
			// This can happen if a user creates a keychain entry with a non-Google
			// email address and then later adds a gmail or googlemail email address
			// to this account.  Keychain will have the account
			// under the old name, but the Google logged-in screenscrape will
			// show the gmail email
			
			// This should only happen "once in a lifetime" of a document, so...
			NSLog(@"Requested account %@ but Google responded with %@.  Changing to agree with Google",
				  [client profileName], 
				  currentProfileName) ;
			
			// Write to document as a permanent change.
			[client setProfileName:currentProfileName] ;		
		}
		else {
			error = [NSError errorWithDomain:SSYNonhierarchicalWebAppErrorDomain
										code:constNonhierarchicalWebAppErrorCodeLoginWrongAccount
									userInfo:nil] ;
			NSString* msg = [NSString stringWithFormat:
							 @"Google login returned wrong account.\n\nWanted: %@\n\nGot: %@",
							 [client profileName],
							 currentProfileName] ;
			error = [error errorByAddingLocalizedDescription:msg] ;
			ok = NO ;
			goto end ;
		}			
	}
end:
	if (!ok && error_p) {
		error = [error errorByAddingUserInfoObject:[NSNumber numberWithInteger:[responseData_ length]]
											forKey:@"Response Data byte count"] ;
		error = [error errorByAddingUserInfoObject:currentProfileName
											forKey:@"Current Profile Name"] ;
		error = [error errorByAddingUserInfoObject:[response_ longDescription]
											forKey:@"Response Description"] ;
		error = [error errorByAddingUserInfoObject:galx
											forKey:@"GALX"] ;		

		if ([error code] != SSYSynchronousHttpStateNeedUsernamePasswordToMakeCredential) {
			// This is an uncommon error.  Let's append more info...
			error = [error errorByAddingUserInfoObject:responseString
												forKey:@"Response Data"] ;
		}
		
		*error_p = error ;
		
		if ([[error domain] isEqualToString:SSYSynchronousHttpErrorDomain]) {
			if (
				([error code] == SSYSynchronousHttpStateCredentialNotAccepted)
				||
				([error code] == SSYSynchronousHttpStateKeychainCredentialNotAccepted)
				) {
				[client setServerPassword:nil] ;
			}
		}
	}		
	[responseString release] ;
		
	return ok ;
}	


+ (BOOL)talkToUrlString:(NSString*)urlString
			 httpMethod:(NSString*)httpMethod
			 bodyString:(NSString*)bodyString
		  receiveData_p:(NSData**)receiveData_p
				error_p:(NSError**)error_p {
	NSHTTPURLResponse* response = nil ;
	NSData* receiveData = nil ;
	NSError* error = nil ;
	
	BOOL ok = [SSYSynchronousHttp SSYSynchronousHttpUrl:urlString
											 httpMethod:httpMethod
												headers:nil
											 bodyString:bodyString 
											   username:nil
											   password:nil
												timeout:20.0
											  userAgent:constUserAgentForGoogle 
											 response_p:&response
										  receiveData_p:&receiveData
												error_p:&error] ;
	if (receiveData_p) {
		*receiveData_p = receiveData ;
	}
	
	if (error_p) {
		*error_p = error ;
	}

	return ok ;
}

@end

/* The following code logs in to Google using Google Accounts API
 
 NSString* bodyString ;
 NSString* accountEmail ;
 NSString* googleServiceCode ;
 NSString* password ;
 NSString* agentID = @"Sheep_Systems-Bookmarksman-4.1.0" ;
 
 int responseState ;
 NSHTTPURLResponse* response ;
 NSData* responseData ;
 NSString* responseString ;
 
 accountEmail = @"jerry@sheepsystems.com" ;
 password = @"ke3dhd83uj2" ;
 googleServiceCode = @"xapi" ; // This is not correct.  There is no service code for Google Bookmarks.
 bodyString = [[NSString alloc] initWithFormat:@"Email=%@&Passwd=%@&service=%@&source=%@",
 accountEmail, password, googleServiceCode, agentID] ;
 responseState = [SSYSynchronousHttp SSYSynchronousHttpUrl:@"https://www.google.com/accounts/ClientLogin"
 httpMethod:@"POST"
 headers:nil
 bodyString:bodyString 
 timeout:5.0 
 userAgent:agentID 
 responsse_p:&response 
 receive_data_p:&responseData
 error_p:nil] ;
 responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] ;
 NSScanner* scanner = [[NSScanner alloc] initWithString:responseString] ;
 [responseString release] ;
 [scanner scanUpToAndThenLeapOverString:@"Auth=" intoString:NULL] ;
 NSString* auth ;
 [scanner scanUpToString:@"\n" intoString:&auth] ;
 [scanner release] ;
 
 // The remainder of this code uses the 'auth' received to attempt to get bookmarks from Google Bookmarks,
 // but since Google Bookmarks is not one of Google's supported Google API, it does not work.
 
 NSString* urlString = [[NSString alloc] initWithFormat:@"http://www.google.com/bookmarks/lookup?&start=%i&output=rss&num=%i&auth=%@", 0, 3, auth] ; 
 responseState = [SSYSynchronousHttp SSYSynchronousHttpUrl:urlString
 httpMethod:@"GET"
 headers:nil
 bodyString:nil 
 timeout:5.0 
 userAgent:agentID 
 responsse_p:&response 
 receive_data_p:&responseData
 error_p:nil] ;
 [urlString release] ;
 responseString = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding] ;
 [responseString release] ;
 */