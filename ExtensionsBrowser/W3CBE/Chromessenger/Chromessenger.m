#import <Cocoa/Cocoa.h>
#import "Chromessenger.h"
#import "BkmxGlobals.h"
#import "SSYInterappClient.h"
#import "ChromeBookmarksGuy.h"
#import "BkmxChangeNotifier.h"
#import "NSDictionary+BSJSONAdditions.h"

static Chromessenger* sharedMessenger = nil ;


@interface Chromessenger ()

@property (retain) NSData* carryoverData ;
@property (retain) NSData* carryoverLengthBytes ;
@property (assign) uint32_t owedBytes ;

@end


@implementation Chromessenger

@synthesize changeNotifier = m_changeNotifier ;
@synthesize owedBytes = m_owedBytes ;
@synthesize carryoverData = m_carryoverData ;
@synthesize carryoverLengthBytes = m_carryoverLengthBytes ;


+ (NSString*)extensionInstallInfoPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSApplicationSupportDirectory,
                                                         NSUserDomainMask,
                                                         YES
                                                         ) ;
    NSString* path = ([paths count] > 0) ? [paths objectAtIndex:0] : nil ;
    path = [path stringByAppendingPathComponent:@"BookMacster"];
    /* I know it is possible and would be better to use the motherAppName
     provided by NSBundle+SSYMotherApp, but even after I worked around all of
     the embedded Info.plist preprocessing issues, in 
     +[NSBundle(MainApp) mainAppBundle], the expression [NSBundle mainBundle]
     was returning a bundle whose bundlePath was:
     *  /Users/jk/Library/Application Support/BookMacster
     which is, of course, because that is where the Chromessenger tool is
     installed.  (The one in the app package is but a symbolic link.)
     So I said, "What the hell, just hard-code the stupid thing." */
    path = [path stringByAppendingPathComponent:@"ExtensionInstallInfo.plist"];
    return path;
}

+ (Chromessenger*)sharedMessenger {
    @synchronized(self) {
        if (!sharedMessenger) {
            sharedMessenger = [[Chromessenger alloc] init] ;
        }
    }

    return sharedMessenger ;
}

- (NSString*)profileName {
    return [[ChromeBookmarksGuy sharedBookmarksGuy] profileName] ;
}

/* See Note NativeMessagingProtocol for explanation of these numbers. */
NSInteger const headerLength = 4;
NSInteger const nativeMessagingAPILimit = 1000000;

- (void)sendJSONDataToExtension:(NSData*)chunkPayload {
    NSInteger length = chunkPayload.length;
    NSAssert(length + headerLength <= nativeMessagingAPILimit, @"Message is too big for Native Messaging");
    NSData* headerData = [NSData dataWithBytes:&length
                                        length:headerLength] ;
    NSMutableData* dataOut = [[NSMutableData alloc] init] ;
    [dataOut appendData:headerData] ;
    [dataOut appendData:chunkPayload] ;

    NSFileHandle* output = [NSFileHandle fileHandleWithStandardOutput] ;
    [output writeData:dataOut] ;
    /* Saul Hansell reports crash at that line with Google's 'Bookmark Manager'
     extension 201411.  Some ideas here…
     http://stackoverflow.com/questions/25729167/why-doesnt-try-catch-work
     */
#if !__has_feature(objc_arc)
    [dataOut release] ;
#endif
}

- (void)sendToExtensionDictionary:(NSDictionary *)dictionary {
    NSError* error = nil;
    // See Note NativeMessagingProtocol
    NSInteger payloadLimit = nativeMessagingAPILimit - headerLength;
    NSData* payloadData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                          options:0 // NSJSONWritingPrettyPrinted
                                                            error:&error];
    if (error) {
        NSLog(@"Failed JSON encoding of dictionary to send to extension via Native Messaging. %s\n", [[error localizedDescription] UTF8String]) ;
    } else {
        NSInteger payloadDataLength = payloadData.length;
        if (payloadDataLength < payloadLimit) {
            /* Normal case.  Send whole payload in one message, no chunking. */
            [self sendJSONDataToExtension:payloadData];
        } else {
            /*
             We must break up payloadData into chunks not exceeding the Native Messaging
             limit of 1 MB when hereby sending from Chromessenger to our BookMacster Sync
             extension.  (Note that it is not necessary to chunk in the opposite direction,
             when sending from the BookMacster Sync extension *to* Chromessenger, because
             in that other direction, the limit is an unfathomable 4 GB.)  References:
             https://developer.chrome.com/docs/extensions/develop/concepts/native-messaging
             https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Native_messaging

             However, we cannot just chunk the data, because the Native
             Messaging protocol requires that the message data be valid JSON,
             which arbitrarily chunked JSON is certainly not.

             So we convert each chunk of data to a string and wrap it in a
             dictionary as the value of a given chunk number, then encode
             *that* dictionary to JSON.

             So the data we send is actually doubly-encoded JSON.  When our
             extension sees no `command` key in the decoded JSON object but
             instead finds the `isLastChunk` key, it will do the appropriate
             thing, decoding the chunkPayload, concatenating to a string buffer
             and then, after all chunks have been received, decoding the string
             buffer.

             True, this is not very efficient.  In addition to the processing,
             encoding the JSON data as JSON again adds typically 20% to the
             data.  This is because many characters, the doublequotes in
             particular (two for each key and two for each value), get
             backslash-escaped.  However, I like it because it preserves
             protocol layering.  This method may accept any arbitrary
             dictionary from any higher-level method and , regardless of the
             dictionary's size or structure, and without probing into its size
             or structure, this method will transparently deliver it to its
             destination, our W3CBE extension, via Native Messaging.

             One nasty wrinkle is that we don't know exactly what the
             overhead is going to be before encoding a chunk, so we don't know
             exactly how much to limit a chunk's payload to.  So this must be
             determined by trial and error, using a `do` loop.  Since I'd like
             to usually get it correct on the first `do` loop iteration, I
             I begin with a generous overhead factor somewhat greater than
             the typically-needed 20%, maybe 30%, increase the overhead factor
             by 10% on each `do` loop iteration, until the encoded JSON size is
             less than the limit.

             Since all this code only executes when a message exceeds 1 MB,
             and that should happen only with exports, and only very rarely,
             I think this is a good design.
             */
            NSInteger mark = 0;
            BOOL isLastChunk= NO;
            NSData* chunkData = nil;
            CGFloat const generousOverheadFactor = 0.3;
            while (mark < payloadData.length) {
                NSData* thisChunkPayloadData = nil;
                NSInteger payloadBytesThisChunk = 0;
                NSInteger chunkOverheadAllowance = nativeMessagingAPILimit * generousOverheadFactor;
                NSInteger chunkIterations = 0;  // for performance analysis only
                do {
                    CGFloat retryOverheadFactor = 1.1;
                    chunkIterations++;
                    chunkOverheadAllowance *= retryOverheadFactor;
                    if (chunkOverheadAllowance > payloadLimit) {
                        syslog(LOG_ERR, "Error 382-3748");
                        break;
                    }
                    NSInteger chunkPayloadLimit = payloadLimit - chunkOverheadAllowance;
                    NSInteger bytesRemaining = payloadData.length - mark;
                    if (bytesRemaining <= chunkPayloadLimit) {
                        isLastChunk = YES;
                        payloadBytesThisChunk = bytesRemaining;
                   } else {
                        isLastChunk = NO;
                        payloadBytesThisChunk = chunkPayloadLimit;
                    }
                    chunkData = [payloadData subdataWithRange:NSMakeRange(mark, payloadBytesThisChunk)];
                    NSString* chunkString = [[NSString alloc] initWithData:chunkData encoding:NSUTF8StringEncoding];
                    NSDictionary* chunkObject = @{
                                                  @"isLastChunk" : [NSNumber numberWithBool:isLastChunk],
                                                  @"chunkPayload" : chunkString,
                                                  @"chunkOverheadAllowance" : @(chunkOverheadAllowance),
                                                  @"chunkIterations" : @(chunkIterations)
                                                  };
                    /* Above, the chunkOverheadAllowance and chunkIterations
                     are sent to the extension for performance analysis and
                     debugging.  Yes, I could NSLog them here, but since Apple
                     ruined Console.app, it will probably be easier to get
                     the numbers out of the console in the browser :(  */
#if !__has_feature(objc_arc)
                    [chunkString release];
#endif
                    thisChunkPayloadData = [NSJSONSerialization dataWithJSONObject:chunkObject
                                                                           options:0
                                                                             error:NULL];
                 } while (thisChunkPayloadData.length > payloadLimit);

                if (thisChunkPayloadData.length > payloadLimit) {
                    // This will happen iff Internal Error 382-3748 occurred.
                    break;
                }

                mark += payloadBytesThisChunk;
                [self sendJSONDataToExtension:thisChunkPayloadData];
            }
        }
    }
}

- (void)sendToExtensionCommand:(NSString*)command
                  otherObjects:(NSDictionary*)otherObjects {
    NSMutableDictionary* everything = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       command, @"command",
                                       nil] ;
    if (otherObjects) {
        [everything addEntriesFromDictionary:otherObjects] ;
    }
    NSDictionary* everythingCopy = [everything copy] ;
    [self sendToExtensionDictionary:everythingCopy] ;
#if !__has_feature(objc_arc)
    [everything release] ;
    [everythingCopy release] ;
#endif
}

/* This handles stdin data from the browser extension and forwards it to our
 native app. */
- (void)handleStdinPayloadData:(NSData *)rxPayloadData {
    if (rxPayloadData) {
        NSString* payloadString = [[NSString alloc] initWithData:rxPayloadData
                                                        encoding:NSUTF8StringEncoding] ;
        // syslog(LOG_NOTICE, "Got payloadData:\n%s", [payloadString UTF8String]) ;
        if (payloadString) {
            NSDictionary* payloads = [NSDictionary dictionaryWithJSONString:payloadString
                                                                 accurately:NO] ;
            BOOL didProcess = NO;
            id rxObject;
            NSString* issue;

            rxObject = [payloads objectForKey:@"startupInfo"] ;
            NSError* error = nil ;
            if (rxObject) {
                NSString* extensionName = [rxObject objectForKey:@"extensionName"] ;
                NSString* extensionVersion = [rxObject objectForKey:@"extensionVersion"] ;
                NSString* profileName = [rxObject objectForKey:@"profileName"] ;
                NSString* extoreName = [rxObject objectForKey:@"extoreName"] ;
                syslog(LOG_NOTICE, "Starting up for %s ver %s, %s.%s\n",
                       [extensionName UTF8String],
                       [extensionVersion UTF8String],
                       [extoreName UTF8String],
                       [profileName UTF8String]) ;
                if ([profileName isEqualToString:constSorryNullProfile] || [extoreName isEqualToString:constSorryNullExtore]) {
                    NSString* path = [[self class] extensionInstallInfoPath];
                    NSData* data = [NSData dataWithContentsOfFile:path];
                    if (data) {
                        NSDictionary* info = [NSPropertyListSerialization propertyListWithData:data
                                                                                       options:0
                                                                                        format:NULL
                                                                                         error:&error];
                        if (error) {
                            syslog(LOG_ERR, "Internal Error 274-9951");
                        }
                        else {
                            extoreName = [info objectForKey:@"extoreName"];
                            profileName = [info objectForKey:@"profileName"] ;
                            [self sendToExtensionCommand:@"configureBasicInfo"
                                            otherObjects:info] ;
                            syslog(LOG_NOTICE, "Sent to %s: configInfo: %s.%s\n",
                                   [extensionName UTF8String],
                                   [extoreName UTF8String],
                                   [profileName UTF8String]) ;
                        }
                    }
                    else {
                        syslog(LOG_NOTICE, "Internal Error 274-9952  No data at path %s\n", [path fileSystemRepresentation]);
                    }
                }

                if ((extoreName != nil) && (profileName != nil)) {
                    NSString* queueName = [NSString stringWithFormat:
                                           @"com.sheepsystems.Chromessenger.ToClient.%@.%@",
                                           extoreName,
                                           profileName];
                    /* We create our server on a secondary thread.  This
                     is necessary to support the "grabbing" of current
                     page info from Opera and Vivaldi, because the browsers
                     return page info asynchronously but the main app requires
                     a synchronous return to fulfill -menuNeedsUpdate of the
                     Doxtus Menu.  The constInterappHeaderByteForGrabRequest to
                     Chromessenger's server will be received on that secondary
                     thread, so it can block while the grabInfo is obtained
                     from the extension and returned to Chromessenger's stdin
                     which of course happens on the main thread. */
                    dispatch_queue_t aSerialQueue = dispatch_queue_create(
                                                                          [queueName UTF8String],
                                                                          DISPATCH_QUEUE_SERIAL
                                                                          ) ;

                    dispatch_async(aSerialQueue, ^{
#if DEBUG_RARE_CHROMESSENGER_EXTORE_AND_PROFILE_NAMES_DISAPPEARING_651507
                        syslog(LOG_NOTICE, "Will start server guy=%p with %s.%s\n",
                               [ChromeBookmarksGuy sharedBookmarksGuy],
                               [extoreName UTF8String],
                               [profileName UTF8String]);
#endif
                        BOOL didStartServer = [[ChromeBookmarksGuy sharedBookmarksGuy] startServerWithExtoreName:extoreName
                                                                                                     profileName:profileName] ;
                        if (didStartServer) {
                            NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
                            [runLoop runUntilDate:[NSDate distantFuture]] ;
                        }
                        else {
                            /* This is *expected* if both BookMacster Sync and BookMacster Button
                             are installed, if we are running for the latter.

                             We want only one server for messages from the BkmkMgrs apps, and we
                             prefer the one from BookMacster Sync.  So, in this case, we allow
                             this thread to exit.  However, we do not allow the main thread to
                             exit, because that one is necessary to service clicks of the
                             BookMacster Button.

                             Just to clarify: When both extensions are installed, there will be two
                             Chromessenger processes running for that browser/profile.  The
                             Chromessenger associated with BookMacster Sync will have a .ToClient
                             port open on the system, and Activity Monitor will show that it has 3
                             threads running.  The one associated with BookMacster Button will not
                             have any port open, and Activity Monitor will show that it has only
                             2 threads running (when idle).

                             Regarding the four stated purposes of our extensions, in this case
                             when both are installed,

                             The Chromessenger associated with BookMacster Sync will handle:
                             • (BkmkMgrs --> Browser) Imports and Exports initiated by BkmkMgrs
                             • (BkmkMgrs <-- Browser) Notifying BkmkMgrs when a internal bookmark is changed.
                             • (BkmkMgrs --> Browser) Answer with grab page info when BkmkMgrs requests it due to Floating Menu, Status Item or Dock Menu.

                             The Chromessenger associated with BookMacster Button will handle:
                             • (BkmkMgrs <-- Browser) Sending page info to BkmkMgrs when BookMacster Button's button is clicked.
                             */

                            // Allow this (secondary) thread to exit.
                        }
                    });
                    NSNumber* extensionVersionObject = [rxObject objectForKey:@"extensionVersion"] ;
                    if ([extensionVersionObject respondsToSelector:@selector(integerValue)]) {
                        NSInteger extensionVersion = [extensionVersionObject integerValue] ;
                        [[ChromeBookmarksGuy sharedBookmarksGuy] setExtensionVersion:extensionVersion] ;
                    }
                    NSString* extensionName = [rxObject objectForKey:@"extensionName"] ;
                    if ([extensionName isKindOfClass:[NSString class]]) {
                        [[ChromeBookmarksGuy sharedBookmarksGuy] setExtensionName:extensionName] ;
                    }
                    BkmxChangeNotifier* changeNotifier = [[BkmxChangeNotifier alloc] initWithExtoreName:extoreName] ;
                    [self setChangeNotifier:changeNotifier] ;
#if !__has_feature(objc_arc)
                    [changeNotifier release] ;
#endif
                }
#if DEBUG_RARE_CHROMESSENGER_EXTORE_AND_PROFILE_NAMES_DISAPPEARING_651507
                else {
                    syslog(LOG_NOTICE, "Got incomplete startupInfo: %s\n",
                           [[rxObject description] UTF8String]);
                }
#endif
                didProcess = YES ;
            }

            rxObject = [payloads valueForKey:@"basicInfo"] ;
            if (rxObject) {
                NSData* txPayload = [NSJSONSerialization dataWithJSONObject:rxObject
                                                                    options:0
                                                                      error:&error];
                if (error) {
                    issue = @"Internal Error 274-9954";
                    syslog(LOG_ERR, "%s", issue.UTF8String);
                    txPayload = [issue dataUsingEncoding:NSUTF8StringEncoding];
                }
                
                /* Note DeadFirefoxExtension
                 
                 This is to try and kludge around a really weird bug I found
                 on 20171106, shortly after adding the nice feature that the
                 Manage Browser Extensions > Test button now calls all the
                 way through to the browser extension.  Firefox was not
                 responding, grrrr.  But now, the Test button kindly fails
                 also.  Upon debugging, I found that the getBasicInfo message
                 was going through Chromessenger and making it to the Firefox
                 extension, and the Firefox extension was sending back the
                 basic info and getting to here.  However, I found that the
                 shared ChromeBookmarksGuy was returning this string
                 for -outgoingPortName
                 
                 com.sheepsystems.BookMacster.(null).(null).FromClient
                 
                 because its properties extoreName, profileName are both nil.
                 
                 and then of course the call below to
                 -[[SSYInterappClient sendHeaderByte::portName:::::::] below
                 would fail due to the bogus portName.
                 
                 I proved this by setting the properties of a running but
                 inoperative Chromessenger which I had attached to with lldb
                 to the correct strings, and then after doing so, this dead
                 Chromessenger operated properly!
                 
                 I don't see how that can happen because this is the same
                 ChromeBookmarksGuy who started the ToClient server port, in
                 -[ChromeBookmarksGuy startServerWithExtoreName:(NSString*)extoreName:profileName:].
                 You see the first two lines of that method set extoreName
                 and profileName, and then use these to create and name the
                 ToClient port, which must be working because the
                 getBasicInfo message made it through to the extension.  And
                 for more evidence,
                 
                 ACA80003:BkmkMgrs jk$ sudo launchctl print user/501 | grep Extore
                 Password:
                 0xa0c93    U   A   com.sheepsystems.BookMacster.ExtoreFirefox.default.ToClient
                 
                 So those properties must have been correctly set at one time
                 How could they change?  I looked at all of the accesses of
                 these two properties.  They each have five.  Four gets, one set:
                 -[ChromeBookmarksGuy startServerWithExtoreName:(NSString*)extoreName:profileName:]
                 which is the same set noted above.  This method in turn has
                 only one caller, -[Chromessenger handleStdinPayloadData:].  And
                 the call is enclosed inside of a block whose execution is
                 conditional upon (extoreName && profileName).  Well, just to
                 be sure I made that a little more explicit:
                 ((extoreName != nil) && (profileName != nil))
                 
                 It remains a mystery how a ChromeBookmarksGuy's extoreName or
                 profileName could ever be nil after the ToClient server
                 is successfully started!!
                 
                 Well, to try and defensively fix this, I added the following
                 code.  Note that it will only succeed for the getBasicInfo,
                 that is, the "Test" message, because this is the only message
                 that gets the extoreName and profileName in its response so
                 we can set the missing properties.  But at least it will log
                 something to the console.
                 
                 A better way to fix this would be to synchronously ask the
                 extension for basic info at this point if needed.  But of
                 course the best way would be to figure out how the extoreName
                 and profileName mysteriously become nil.
                 */
                if ([[ChromeBookmarksGuy sharedBookmarksGuy] extoreName] == nil) {
                    syslog(LOG_WARNING, "Warning 692-0042 Bookmarks Guy has nil ExtoreName!");
                    NSString* extoreName = [[payloads objectForKey:@"basicInfo"] objectForKey:@"extoreName"];
                    if (extoreName) {
                        [[ChromeBookmarksGuy sharedBookmarksGuy] setExtoreName:extoreName];
                        syslog(LOG_WARNING, "Warning 692-0043 Fixed missing extoreName: %s", extoreName.UTF8String);
                    }
                }
                if ([[ChromeBookmarksGuy sharedBookmarksGuy] profileName] == nil) {
                    syslog(LOG_WARNING, "Warning 692-0052 Bookmarks Guy has nil profileName!");
                    NSString* profileName = [[payloads objectForKey:@"basicInfo"] objectForKey:@"profileName"];
                    if (profileName) {
                        [[ChromeBookmarksGuy sharedBookmarksGuy] setProfileName:profileName];
                        syslog(LOG_WARNING, "Warning 692-0053 Fixed missing profileName: %s", profileName.UTF8String);
                    }
                }
                
                NSError* error = nil ;
                BOOL ok = [SSYInterappClient sendHeaderByte:constInterappHeaderByteForVersionCheck
                                                  txPayload:txPayload
                                                   portName:[[ChromeBookmarksGuy sharedBookmarksGuy] outgoingPortName]
                                                       wait:NO // Never saw a problem here, but NO is safer.
                                             rxHeaderByte_p:NULL
                                                rxPayload_p:NULL
                                                  txTimeout:3.0
                                                  rxTimeout:3.0
                                                    error_p:&error] ;
                if (!ok) {
                    syslog(LOG_ERR, "Error 465-9023 code=%ld %s", (long)[error code], [error userInfo].description.UTF8String) ;
                }
                didProcess = YES ;
            }
            
            rxObject = [payloads valueForKey:@"changeInfo"] ;
            if (rxObject) {
                // This branch was formerly handled by syE2P_observeBookmarksChange()

                // In this case, unfortunately we need to re-encode the changeInfo
                // back to a JSON string.  This is because we're going to set it
                // into the jsonBuffer of our BkmxChangeNotifier instance, then
                // write it to a file.
                NSString* jsonString = [rxObject jsonStringValue] ;
                [(BkmxChangeNotifier*)m_changeNotifier handleRawChange:jsonString
                                                               profile:[self profileName]] ;
                didProcess = YES ;
            }

            rxObject = [payloads valueForKey:@"rootChildren"] ;
            if (rxObject) {
                // This branch was formerly handled by ssyE2P_sendBookmarksToBkmx()

                NSString* jsonString = [rxObject jsonStringValue] ;

                NSData* txPayload = [NSKeyedArchiver archivedDataWithRootObject:jsonString
                                                          requiringSecureCoding:YES
                                                                          error:&error];
                if (error) {
                    issue = @"Internal Error 274-9955";
                    syslog(LOG_ERR, "%s", issue.UTF8String);
                    txPayload = [issue dataUsingEncoding:NSUTF8StringEncoding];
                }
                NSTimeInterval rxTimeout = MIN(MAX(3.0, ([txPayload length] * .001)), 30.0) ;
                
                NSError* error = nil ;
                BOOL ok = [SSYInterappClient sendHeaderByte:constInterappHeaderByteForBookmarksTree
                                                  txPayload:txPayload
                                                   portName:[[ChromeBookmarksGuy sharedBookmarksGuy] outgoingPortName]
                                                       wait:NO // Never saw a problem here, but NO is safer.
                                             rxHeaderByte_p:NULL
                                                rxPayload_p:NULL
                                                  txTimeout:3.0
                                                  rxTimeout:rxTimeout
                                                    error_p:&error] ;
                if (!ok) {
                    syslog(LOG_ERR, "Error 465-9025 sharedGuy=%p code=%ld %s",
                           [ChromeBookmarksGuy sharedBookmarksGuy],
                           (long)[error code],
                           [error userInfo].description.UTF8String) ;
                }
                didProcess = YES;
            }

            rxObject = [payloads valueForKey:@"assignedVsProposedExids"] ;
            if (rxObject) {
                NSString* exidFeedbackString = [rxObject jsonStringValue] ;
                NSData* txPayload = [NSKeyedArchiver archivedDataWithRootObject:exidFeedbackString
                                                          requiringSecureCoding:YES
                                                                          error:&error];
                if (error) {
                    issue = @"Internal Error 274-9956";
                    syslog(LOG_ERR, "%s", issue.UTF8String);
                    txPayload = [issue dataUsingEncoding:NSUTF8StringEncoding];
                }
                
                NSTimeInterval rxTimeout = MIN(MAX(2.0, ([txPayload length] * .001)), 20.0) ;
                
                NSError* error = nil ;
                BOOL ok = [SSYInterappClient sendHeaderByte:constInterappHeaderByteForExportFeedback
                                                  txPayload:txPayload
                                                   portName:[[ChromeBookmarksGuy sharedBookmarksGuy] outgoingPortName]
                                                       wait:NO
                           /* When this was YES, this method, apparently because BookMacster would invalidate
                            its server port very quickly upon receiving this message, CFMessagePortSendRequest()
                            would return a kCFMessagePortBecameInvalidError. */
                                             rxHeaderByte_p:NULL
                                                rxPayload_p:NULL
                                                  txTimeout:1.0
                                                  rxTimeout:rxTimeout
                                                    error_p:&error] ;
                if (!ok) {
                    syslog(LOG_ERR, "Error 465-5025 code=%ld %s", (long)[error code], [error userInfo].description.UTF8String) ;
                }
                didProcess = YES;
            }
            
            rxObject = [payloads valueForKey:@"progress"] ;
            if (rxObject) {
                NSData* txPayload = [NSKeyedArchiver archivedDataWithRootObject:rxObject
                                                          requiringSecureCoding:YES
                                                                          error:&error];
                if (error) {
                    issue = @"Internal Error 274-9957";
                    syslog(LOG_ERR, "%s", issue.UTF8String);
                    txPayload = [issue dataUsingEncoding:NSUTF8StringEncoding];
                }
                
                NSError* error = nil ;
                BOOL ok = [SSYInterappClient sendHeaderByte:constInterappHeaderByteForProgress
                                                  txPayload:txPayload
                                                   portName:[[ChromeBookmarksGuy sharedBookmarksGuy] outgoingPortName]
                                                       wait:NO // Never saw a problem here, but NO is safer.
                                             rxHeaderByte_p:NULL
                                                rxPayload_p:NULL
                                                  txTimeout:3.0
                                                  rxTimeout:30.0
                                                    error_p:&error] ;
                if (!ok) {
                    syslog(LOG_ERR, "Error 487-1357 code=%ld %s", (long)[error code], [error userInfo].description.UTF8String) ;
                }
                
                didProcess = YES ;
            }
            
            rxObject = [payloads valueForKey:@"bookmacsterizeUrl"] ;
            if ([rxObject isKindOfClass:[NSString class]]) {
                // Add processName to info.
                NSString* processName = [[[NSProcessInfo processInfo] processName] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                if (processName) {
                    rxObject = [rxObject stringByAppendingFormat:
                                @"&processName=%@",
                                processName] ;
                }
                syslog(LOG_NOTICE, "Bonehead 2: %s", [processName UTF8String]);
                
                /* This is a bit of a trick.  The natural approach would be to
                 send the bookmark to the native app via SSYInterappClient.
                 Instead, we use the bookmacster:// URL scheme, which our
                 UrlHandler is waiting for.  */
                NSURL* url = [NSURL URLWithString:rxObject] ;
                [[NSWorkspace sharedWorkspace] openURL:url] ;
                
                didProcess = YES ;
            }
            
            
            rxObject = [payloads valueForKey:@"grabbedInfo"] ;
            if (rxObject) {
                NSString* rxJson = [rxObject jsonStringValue];
                NSData* rxData = [NSKeyedArchiver archivedDataWithRootObject:rxJson
                                                       requiringSecureCoding:YES
                                                                       error:&error];
                if (error) {
                    issue = @"Internal Error 274-9958";
                    syslog(LOG_ERR, "%s", issue.UTF8String);
                    rxData = [issue dataUsingEncoding:NSUTF8StringEncoding];
                }
                
                [[ChromeBookmarksGuy sharedBookmarksGuy] setResponseHeaderByte:constInterappHeaderByteForGrabResponse];
                [[ChromeBookmarksGuy sharedBookmarksGuy] setResponsePayload:rxData];
                [[ChromeBookmarksGuy sharedBookmarksGuy] clearSemaphore];

                didProcess = YES ;
            }
            rxObject = [payloads valueForKey:@"errors"] ;
            if (rxObject) {
                NSData* txPayload = [NSJSONSerialization dataWithJSONObject:rxObject
                                                                    options:0
                                                                      error:&error];
                if (error) {
                    issue = @"Internal Error 274-9959";
                    syslog(LOG_ERR, "%s", issue.UTF8String);
                    txPayload = [issue dataUsingEncoding:NSUTF8StringEncoding];
                }

                NSError* error = nil ;
                BOOL ok = [SSYInterappClient sendHeaderByte:constInterappHeaderByteForErrors
                                                  txPayload:txPayload
                                                   portName:[[ChromeBookmarksGuy sharedBookmarksGuy] outgoingPortName]
                                                       wait:NO // Never saw a problem here, but NO is safer.
                                             rxHeaderByte_p:NULL
                                                rxPayload_p:NULL
                                                  txTimeout:3.0
                                                  rxTimeout:30.0
                                                    error_p:&error] ;
                if (!ok) {
                    syslog(LOG_ERR, "Error 487-1358 code=%ld %s", (long)[error code], [error userInfo].description.UTF8String) ;
                }

                didProcess = YES ;
            }

            // Handle Message Loopback Test (for debugging only)
            rxObject = [payloads valueForKey:@"testString"] ;
            if (rxObject) {
                if ([rxObject hasPrefix:@"Greeting"]){
                    NSString* msgToBrowser = @"Chromessenger heard you!" ;
                    NSDictionary* replyDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                              msgToBrowser, @"msgToBrowser",
                                              nil] ;
                    [self sendToExtensionDictionary:replyDic];
                    NSLog(@"Messenger Sent Reply:\n%@", replyDic) ;
                    didProcess = YES;
                }
                else if ([rxObject hasSuffix:@"over and out."]){
                    NSLog(@"She's over and out!\n") ;
                    didProcess = YES;
                }
            }

            // Handle Dictionary Loopback Test (for debugging only)
            rxObject = [payloads valueForKey:@"testDictionary"];
            if (rxObject) {
                [self sendToExtensionDictionary:rxObject];
                didProcess = YES;
            }

            if (([payloads allKeys].count > 0) && !didProcess) {
                syslog(LOG_ERR, "Error 465-5030  Dunno how to process any of rx keys %s", [payloads allKeys].description.UTF8String) ;
            }
        }
        else {
            syslog(LOG_ERR, "Error 465-5031  Could not decode UTF8 string from stdin data %s", rxPayloadData.description.UTF8String) ;
        }
#if !__has_feature(objc_arc)
        [payloadString release] ;
#endif
    }
    else {
        syslog(LOG_ERR, "Error 465-5032  No payload in stdin data %s", rxPayloadData.description.UTF8String) ;
    }
}

#define LENGTH_LENGTH 4

/*
 @details  Unix domain sockets have 4K buffers.  So there cannot ever be more
 than 4K of available data at any time, because “available” means “sitting in
 the buffer ready to be copied out”.  Until the 4K in the buffer is read,
 the sending side is blocked.  Therefore, -availableData will never return
 more than 4K.  Therefore, this method has a lot of fancy code for
 stitching together the message fields and, rarely but importantly, their
 4-byte length fields.  (The 4K boundaries from the unix domain socket are
 independent of the message boundaries from Chrome's postMessage function.)
 */
- (void)handleStdinData:(NSData*)dataIn {
    uint32_t dataInBytes = (uint32_t)[dataIn length] ;
    uint32_t pointer = 0 ;
    uint32_t needBytes = 0 ;
    NSMutableData* currentData = nil ;
    // syslog(LOG_NOTICE, "Got stdinData of %ld bytes", dataIn.length) ;
    while (YES) {
        currentData = [[NSMutableData alloc] init] ;
        NSData* carriedOverData = [self carryoverData] ;
        if (carriedOverData) {
            [currentData appendData:carriedOverData] ;
            needBytes = [self owedBytes] ;
            [self setCarryoverData:nil] ;
            [self setOwedBytes:0] ;
        }
        if (needBytes == 0) {
            NSData* carryoverLengthBytes = [self carryoverLengthBytes] ;
            uint32_t carryoverLengthByteLength = 0 ;
            NSMutableData* lengthBytes = [[NSMutableData alloc] init] ;
            if (carryoverLengthBytes) {
                [self setCarryoverLengthBytes:nil] ;
                carryoverLengthByteLength = (uint32_t)[carryoverLengthBytes length] ;
                [lengthBytes appendData:carryoverLengthBytes] ;
            }
            uint32_t newLengthLength = MIN(LENGTH_LENGTH - carryoverLengthByteLength, dataInBytes) ;
            NSRange newLengthRange = NSMakeRange(pointer, newLengthLength) ;
            NSData* newLengthBytes = [dataIn subdataWithRange:newLengthRange] ;
            [lengthBytes appendData:newLengthBytes] ;
            [lengthBytes getBytes:&needBytes
                           length:LENGTH_LENGTH] ;
#if !__has_feature(objc_arc)
            [lengthBytes release] ;
#endif
            pointer += newLengthLength ;
        }
        uint32_t readLength ;
        BOOL isComplete ;
        uint32_t availableBytes = dataInBytes - pointer ;
        if (needBytes > availableBytes) {
            // Read the entire dataInBytes into currentData
            // Store carryOver and bytesOwed for next
            readLength = availableBytes ;
            isComplete = NO ;
        }
        else {
            // Read needBytes into currentData
            // Process currentData as JSON
            readLength = needBytes ;
            isComplete = YES ;
        }
        readLength = MIN(readLength, dataInBytes) ;
        NSRange readRange = NSMakeRange(pointer, readLength) ;
        NSData* newData = [dataIn subdataWithRange:readRange] ;
        [currentData appendData:newData] ;
        pointer += readLength ;

        if (isComplete) {
            [self handleStdinPayloadData:currentData] ;
            needBytes = 0 ;
        }
        else {
            NSData* currentDataCopy = [currentData copy] ;
            [self setCarryoverData:currentDataCopy] ;
            uint32_t owed = (needBytes - (uint32_t)[newData length]) ;
            [self setOwedBytes:owed] ;
        }
#if !__has_feature(objc_arc)
        [currentData release] ;
#endif

        uint32_t remainingBytes = dataInBytes - pointer ;
        if (remainingBytes <= LENGTH_LENGTH) {
            if (remainingBytes != 0) {
                NSRange carryoverLengthRange = NSMakeRange(pointer, remainingBytes) ;
                NSData* carryoverLengthBytes = [dataIn subdataWithRange:carryoverLengthRange] ;
                [self setCarryoverLengthBytes:carryoverLengthBytes] ;
            }
            break ;
        }
    }
}

- (void)sendWholeTree {
    [self sendToExtensionCommand:@"sendWholeTree"
                    otherObjects:nil] ;
}

- (void)putExportAndSendExidsFromJsonText:(NSString*)jsonString {
    NSDictionary* jsonTree = [NSDictionary dictionaryWithJSONString:jsonString
                                                         accurately:NO] ;
    [self sendToExtensionCommand:@"putExportAndSendExids"
                    otherObjects:@{@"jsonTree": jsonTree}] ;
}

- (void)grabCurrentPageInfo {
    [self sendToExtensionCommand:@"grabCurrentPageInfo"
                    otherObjects:nil] ;
}

- (void)sendGeneralInfo {
    BOOL extensionCanDoThis = YES;
    if (
        /* This first half will never affirm, because we don't have a
         Test button for the button extension in the user interface.
         But now we could :)  */
        (
         [[[ChromeBookmarksGuy sharedBookmarksGuy] extensionName] isEqualToString:@"BookMacster Button"]
        &&
        ([[ChromeBookmarksGuy sharedBookmarksGuy] extensionVersion] < 29)
         )
        ||
        (
         [[[ChromeBookmarksGuy sharedBookmarksGuy] extensionName] isEqualToString:@"BookMacster Sync"]
         &&
         ([[ChromeBookmarksGuy sharedBookmarksGuy] extensionVersion] < 41)
         )
        ) {
        extensionCanDoThis = NO;
    }

    if (extensionCanDoThis) {
        [self sendToExtensionCommand:@"getBasicInfo"
                        otherObjects:nil];
    } else {
        NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
                              [[ChromeBookmarksGuy sharedBookmarksGuy] extensionName], constKeyExtensionName,
                              [NSNumber numberWithInteger:[[ChromeBookmarksGuy sharedBookmarksGuy] extensionVersion]], constKeyExtensionVersion,
                              [[ChromeBookmarksGuy sharedBookmarksGuy] profileName], constKeyProfileName,
                              [[ChromeBookmarksGuy sharedBookmarksGuy] extoreName], constKeyExtoreName,
                              @"YesIsCheesy", @"thisInfoIsCheesy",
                              nil] ;
        NSError* error = nil;
        NSData* txPayload = [NSJSONSerialization dataWithJSONObject:info
                                                            options:0
                                                              error:&error];
        if (error) {
            NSString* issue = @"Internal Error 274-9953";
            syslog(LOG_ERR, "%s", issue.UTF8String);
            txPayload = [issue dataUsingEncoding:NSUTF8StringEncoding];
        }


        BOOL ok = [SSYInterappClient sendHeaderByte:constInterappHeaderByteForVersionCheck
                                          txPayload:txPayload
                                           portName:[[ChromeBookmarksGuy sharedBookmarksGuy] outgoingPortName]
                                               wait:NO // Never saw a problem here, but NO is safer.
                                     rxHeaderByte_p:NULL
                                        rxPayload_p:NULL
                                          txTimeout:3.0
                                          rxTimeout:3.0
                                            error_p:&error] ;
        if (!ok) {
            syslog(LOG_ERR, "Error 465-8605 code=%ld %s", (long)[error code], [error userInfo].description.UTF8String) ;
        }
    }
}

#if !__has_feature(objc_arc)
- (void)dealloc {
    [m_changeNotifier release] ;
    [m_carryoverData release] ;
    [m_carryoverLengthBytes release] ;
    
    [super dealloc] ;
}
#endif

@end

/* Note NativeMessagingProtocol

 We package our data according to the Native Messaging protocol spec:
 https://developer.chrome.com/apps/nativeMessaging
 In particular,

 "... each message is serialized using JSON, UTF-8 encoded and is preceded
 with 32-bit message length in native byte order. The maximum size of a
 single message from the native messaging host is 1 MB. ... "

 Of course, I'm not sure if "1 MB" means 1,000,000 or 1,048,576 bytes, so
 we conservatively use the lower value, and also include the 4 header bytes
 in the limit.
 */

