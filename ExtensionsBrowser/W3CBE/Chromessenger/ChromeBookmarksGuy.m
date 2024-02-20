#import "ChromeBookmarksGuy.h"

#import "BkmxGlobals.h"
#import "SSYInterappClient.h"
#import "SSYInterappServer.h"
#import "Chromessenger.h"
#import "NSSet+SSYJsonClasses.h"

static ChromeBookmarksGuy* sharedBookmarksGuy = nil ;

@interface ChromeBookmarksGuy ()

@property (assign, nonatomic) SSYInterappServer* server ;
@property dispatch_semaphore_t doneSemaphore ;

@end


@implementation ChromeBookmarksGuy

@synthesize server = m_server ;
@synthesize extensionVersion = m_extensionVersion ;
@synthesize responseHeaderByte = m_responseHeaderByte ;
@synthesize responsePayload = m_responsePayload ;

#if DEBUG_RARE_CHROMESSENGER_EXTORE_AND_PROFILE_NAMES_DISAPPEARING_651507
 /* The following four implementations are to catch a rare Error 651507
 in the main app which is caused by Error 465-9025 in Chromessenger which is
 caused by [[ChromeBookmarksGuy sharedBookmarksGuy] outgoingPortName] returning
 "com.sheepsystems.BookMacster.(null).(null).FromClient" which is caused by
 these ivars extoreName and profileName being nil.  I want to log when they
 are set to non-nil (see 2 of 2) and, here if they are ever set to nil.
 */
- (void)setProfileName:(NSString*)profileName {
    [m_profileName release];
    m_profileName = profileName;
    [m_profileName retain];
    if (!m_profileName) {
        syslog(LOG_ERR, "Whoops in guy=%p setting profileName %s",
               self,
               SSYDebugBacktrace().UTF8String);
    }
}

- (NSString*)profileName {
    NSString* answer = [[m_profileName copy] autorelease];
    if (!answer) {
        syslog(LOG_ERR, "Whoops nil profileName guy=%p",
               self);
    }

    return answer;
}

- (void)setExtoreName:(NSString*)extoreName {
    [m_extoreName release];
    m_extoreName = extoreName;
    [m_extoreName retain];
    if (!m_extoreName) {
        syslog(LOG_ERR, "Whoops in guy=%p setting extoreName %s",
               self,
               SSYDebugBacktrace().UTF8String);

    }
}

- (NSString*)extoreName {
    NSString* answer = [[m_extoreName copy] autorelease];
    if (!answer) {
        syslog(LOG_ERR, "Whoops nil extoreName guy=%p",
               self);
    }
    return answer;
}

#else
@synthesize extoreName = m_extoreName ;
@synthesize profileName = m_profileName ;
#endif

+ (ChromeBookmarksGuy*)sharedBookmarksGuy {
    @synchronized(self) {
        if (!sharedBookmarksGuy) {
            sharedBookmarksGuy = [[ChromeBookmarksGuy alloc] init] ;
        }
    }
    
    return sharedBookmarksGuy ;
}

- (void)clearSemaphore {
    if ([self doneSemaphore] != NULL) {
        dispatch_semaphore_signal([self doneSemaphore]) ;
    }
}

- (BOOL)startServerWithExtoreName:(NSString*)extoreName
                      profileName:(NSString*)profileName {
	[self setExtoreName:extoreName] ;
    [self setProfileName:profileName] ;
#if DEBUG_RARE_CHROMESSENGER_EXTORE_AND_PROFILE_NAMES_DISAPPEARING_651507
    syslog(LOG_NOTICE, "guy=%p did set extore.profile %s.%s",
           self,
           self.extoreName.UTF8String,
           self.profileName.UTF8String);
#endif
    NSString* portName = [NSString stringWithFormat:
						  @"%@.%@.%@.ToClient",
						  @"com.sheepsystems.BookMacster",
						  [self extoreName],
                          profileName] ;
	NSError* error = nil ;
	SSYInterappServer* server = [SSYInterappServer leaseServerWithPortName:portName
																  delegate:self
                                                                  userInfo:nil
																   error_p:&error] ;
	if (!server) {
        if (error.code == SSYInterappServerErrorPortNameAlreadyInUse) {
            syslog(LOG_NOTICE,"No port for guy=%p because port %s is already in use",
                   [ChromeBookmarksGuy sharedBookmarksGuy],
                   portName.UTF8String) ;
        }
        else {
            syslog(LOG_ERR,"Error at 412-6243 %s", [[error description] UTF8String]) ;
        }
	}
	[self setServer:server] ;

    return (error == nil);
}

- (NSString*)outgoingPortName {
	NSString* portName = [NSString stringWithFormat:
						  @"%@.%@.%@.FromClient",
						  @"com.sheepsystems.BookMacster",
						  [self extoreName],
                          [self profileName]] ;
	return portName ;
}

/*!
 @details  In the Chromessenger tool, this method is the one which receives
 messages from our native apps for forwarding to the browser extension.  This
 method runs on the secondary thread on which the interapp server was created.
 */
- (void)interappServer:(SSYInterappServer*)server
  didReceiveHeaderByte:(char)headerByte
				  data:(NSData*)data {
    // syslog(LOG_NOTICE, "Will forward to W3CBE Extension command '%c' with %ld bytes\n", headerByte, data.length) ;
	NSString* jsonText = nil;
    NSString* profileName ;
    NSData* profileNameData ;
	switch (headerByte) {
		case constInterappHeaderByteForTest:
			// Get versions and send asynchronously
			[self setResponseHeaderByte:constInterappHeaderByteForAcknowledgment] ;
            [[Chromessenger sharedMessenger] sendGeneralInfo] ;
			break ;
		case constInterappHeaderByteForProfileRequest:
			// Get profile name and return it synchronously
            profileName = [self profileName] ;
            // profileName will be either "Default" or "Profile 1", "Profile 2", etc. or constSorryNullProfile
            profileNameData = [profileName dataUsingEncoding:NSASCIIStringEncoding] ;
            
			[self setResponseHeaderByte:constInterappHeaderByteForProfileResponse] ;
			[self setResponsePayload:profileNameData] ;
			break ;
		case constInterappHeaderByteForImport:
			// Import all bookmarks from browser
			[[Chromessenger sharedMessenger] sendWholeTree] ;
			
			// This branch just sends a simple "ack" response synchronously.
			// The bookmarks data is sent synchronously, later.
			[self setResponseHeaderByte:constInterappHeaderByteForAcknowledgment] ;
			[self setResponsePayload:nil] ;
			break ;
		case constInterappHeaderByteForExport:
			// Export changes to browser
            if (data) {
                NSError* error = nil;
                jsonText = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet jsonClasses]
                                                               fromData:data
                                                                  error:&error];
                if (error) {
                    NSLog(@"Internal Error 823-1938, %@", nil);
                }
            }
			
			if (jsonText) {
                //syslog(LOG_NOTICE, "Will put export of %ld JSON chars to extension\n", jsonText.length) ;
                [[Chromessenger sharedMessenger] putExportAndSendExidsFromJsonText:jsonText] ;
				
				// This branch just sends a simple "ack" response synchronously.
				// The exid feedback is sent synchronously, later.
				[self setResponseHeaderByte:constInterappHeaderByteForAcknowledgment] ;
				[self setResponsePayload:nil] ;
			}
			else {
				//syslog(LOG_NOTICE, "Error unarchiving jsonText from %ld bytes\n", (long)[data length]) ;

				NSString* errorString = [NSString stringWithFormat:@"Error.  Could not decode rx data %ld bytes", (long)[data length]] ;
				NSData* errorData = [errorString dataUsingEncoding:NSUTF8StringEncoding] ;
				[self setResponsePayload:errorData] ;

				NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:@"Desktop"] ;
				path = [path stringByAppendingPathComponent:@"BookMacster-Error-Data"] ;
				[data writeToFile:path
					   atomically:NO] ;				
			}
			break ;
        case constInterappHeaderByteForGrabRequest:;
            /* This is used for Opera and Vivaldi.  It is not used for Chrome
             because Chrome supports AppleScript, so we instead use
             BkmxGrabPageIdiomAppleScript which is better, for Chrome.

             First, because we will get a response from the browser extension
             asynchronously, we create a semaphore. */
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0) ;
            [self setDoneSemaphore:semaphore] ;
            /* The following timeout is how long we think the user can stand
             for -[DoxtusMenu menuNeedsUpdate:]. */
            double timeooutSeconds = 2.0 ;
            int64_t timeoutNanoseconds = timeooutSeconds * 1e9 ;
            dispatch_time_t timeout = dispatch_time(
                                                    DISPATCH_TIME_NOW,
                                                    timeoutNanoseconds);

            // Start the asynchronous work
            [self setResponseHeaderByte:0] ;
            [self setResponsePayload:nil] ;
           [[Chromessenger sharedMessenger] grabCurrentPageInfo] ;

            /* Will block here until extension returns the grab info (on the
             main thread of Chromessenger) and signals the semaphore, which
             takes typically 20 milliseconds, or if that fails, the timeout. */
            long result = dispatch_semaphore_wait(
                                                  [self doneSemaphore],
                                                  timeout);
            if (result != 0) {
                // timed out
                NSString* msg = [NSString stringWithFormat:@"Time to grab bookmark info from %@.%@ exceeded %f seconds, moving on without it.",
                                 self.extoreName,
                                 self.profileName,
                                 timeooutSeconds] ;
                syslog(LOG_WARNING, "%s", msg.UTF8String);
            }
            dispatch_release(semaphore) ;
            [self setDoneSemaphore:NULL] ;

            break ;
	}
    
    /* A response, including the responseHeaderByte and the responsePayload
     set during the above will be sent to the client immediately upon the
     return of this method.  See SSYInterappServerCallBackCreateData() in
     SSYInterappServer.m.  */
}

#if MAC_OS_X_VERSION_MAX_ALLOWED < 1070
#define WHOOPS_NO_ARC 1
#else
#if __has_feature(objc_arc)
#else
#define WHOOPS_NO_ARC 1
#endif
#endif


- (void)dealloc {
	[m_server unleaseForDelegate:self] ;
    
#if !__has_feature(objc_arc)
    [m_responsePayload release] ;
    [m_profileName release] ;
    [m_extoreName release ] ;

    [super dealloc] ;
#endif
}

@end

