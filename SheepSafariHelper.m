#import "SheepSafariHelper.h"
#import "SheepSafariHelper-Swift.h"
#import "BkmxGlobals.h"
#import "SSYIndexee.h"
#import "SSYLinearFileWriter.h"
#import "NSObject+RecklessPerformSelector.h"
#import <objc/runtime.h>

#if 0
// Note Handy-Functions-For-Reverse-Engineering
/* Copied from answer by Buzzy in here:
 https://stackoverflow.com/questions/2094702/get-all-methods-of-an-objective-c-class-or-instance
 */
#import <objc/runtime.h>

/* Running this with SafariPrivateFramework in macOS 13.1 results in 8691 protocola. */
void LogAllRegisteredObjCProtocols(void) {
    unsigned int protocolsCount = 0;
    Protocol *__unsafe_unretained *protocols = objc_copyProtocolList(&protocolsCount);
    NSLog(@"Buzzy Found %d registered Objective-C protocols", protocolsCount);
    for (unsigned int i = 0; i < protocolsCount; i++) {
        Protocol* protocol = protocols[i];
        NSLog(@"Buzzy\tsaf%s",
              protocol_getName(protocol));
    }
    free(protocols);
}

void LogAllMethodsOfProtocolOfFlavor(Protocol* protocol, bool isRequired, bool isInstance) {
    NSString* flavor = [NSString stringWithFormat:
                        @"%@ %@",
                        isRequired ? @"required" : @"optional",
                        isInstance ? @"instance" : @"class"];
    unsigned int methodsCount = 0;
    struct objc_method_description *methodDescriptions = protocol_copyMethodDescriptionList(
                                                                                            protocol,
                                                                                            isRequired,
                                                                                            isInstance,
                                                                                            &methodsCount);
    NSLog(@"Buzzy Found %d %@ methods on %s",
          methodsCount,
          flavor,
          protocol_getName(protocol));
    for (unsigned int i = 0; i < methodsCount; i++) {
        struct objc_method_description methodDescription = methodDescriptions[i];
        NSLog(@"%@ types: %s",
               NSStringFromSelector(methodDescription.name),
               methodDescription.types);
    }
    free(methodDescriptions);
}

void LogAllMethodsOfProtocol(Protocol* protocol) {
    LogAllMethodsOfProtocolOfFlavor(protocol, true, false);
    LogAllMethodsOfProtocolOfFlavor(protocol, false, false);
    LogAllMethodsOfProtocolOfFlavor(protocol, true, true);
    LogAllMethodsOfProtocolOfFlavor(protocol, false, true);
}

/* Running this with SafariPrivateFramework in macOS 13.1 results in 51064 classes. */
void LogAllRegisteredObjCClasses(void) {
    unsigned int classesCount = 0;
    Class *classes = objc_copyClassList(&classesCount);
    NSLog(@"Buzzy Found %d registered Objective-C classes", classesCount);
    for (unsigned int i = 0; i < classesCount; i++) {
        Class class = classes[i];
        NSLog(@"Buzzy\t%s",
              class_getName(class));
    }
    free(classes);
}

/* You probably don't want to use this function because there IS A BETTER WAY,
 which prints normal declarations instead of the "types" which you need to
 decode.  The better way is to use one of these:
 • NSLog(@"%@", [some_object performSelector:@selector(fp_methodDescription)]);
 • NSLog(@"%@", [some_object performSelector:@selector(fp_shortMethodDescription)]);
 Despite their names, both of these print very nicely formatted lists all class
 and instance methods and properties.  fp_methodDescription prints inherited
 methods too (in separate sections, nice!), up to and including NSObject.
 fp_shortMethodDescription does not print inherited methods.
 You can use them in lldb with `po` too.
 Credits: Borys Verebskyi and DarkDust in this question/answer:
 https://stackoverflow.com/questions/2094702/get-all-methods-of-an-objective-c-class-or-instance
 */
void LogAllMethodsOfClass(Class class) {
    unsigned int classMethodCount = 0;
    Method *classMethods = class_copyMethodList(object_getClass(class), &classMethodCount);
    NSLog(@"Buzzy Found %d class methods on %s", classMethodCount, class_getName(class));
    for (unsigned int i = 0; i < classMethodCount; i++) {
        Method method = classMethods[i];

        NSLog(@"%s types: %s",
               sel_getName(method_getName(method)),
               method_getTypeEncoding(method));
    }
    free(classMethods);

    unsigned int instanceMethodCount = 0;
    Method *instanceMethods = class_copyMethodList(class, &instanceMethodCount);
    NSLog(@"Buzzy Found %d instance methods on %s", instanceMethodCount, class_getName(class));
    for (unsigned int i = 0; i < instanceMethodCount; i++) {
        Method method = instanceMethods[i];
        
        NSLog(@"%s types: %s",
              sel_getName(method_getName(method)),
              method_getTypeEncoding(method));
    }
    free(instanceMethods);
}
#endif

NSString* SheepSafariHelperUuid(void) {
    CFUUIDRef cfUUID = CFUUIDCreate(kCFAllocatorDefault) ;
    NSString* uuid = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfUUID)) ;
    CFRelease(cfUUID) ;
    return uuid;
}

@interface NSDate (SheepSafariHelperNiceString)

- (NSString*)niceString;

@end

@implementation NSDate (SheepSafariHelperNiceString)

/*!
 @details  Copied from geekDateTimeString in CategoriesObjC
 */
- (NSString*)niceString {
    /* We take advantage of the fact that -[NSDate description] is
     *documented* to return a string in this format:
     *    YYYY-MM-DD HH:MM:SS ±HHMM
     Starting in Mac OS 10.7, ±HHMM = +0000.  We want the time in the local time
     zone, so we need to read and adjust if necessary. */
    NSString* s = [self description];
    NSInteger tzSign = [[s substringWithRange:NSMakeRange(20,1)] isEqualToString:@"+"] ? +1 : -1;
    NSInteger tzHours = [[s substringWithRange:NSMakeRange(21,2)] integerValue];
    NSInteger tzMinutes = [[s substringWithRange:NSMakeRange(23,2)] integerValue];
    NSInteger tzSeconds = tzSign * (3600*tzHours + 60*tzMinutes);
    NSInteger localTzSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    NSMutableString* localTimeString;
    NSTimeInterval adjustment = localTzSeconds - tzSeconds;
    if (fabs(adjustment) < 0.5) {
        /* We're in a time zone where ±HHMM = +0000, such as Greenwich, England */
        localTimeString = [s mutableCopy];
    } else {
        NSDate* localDate = [[NSDate date] dateByAddingTimeInterval:adjustment];
        localTimeString = [[localDate description] mutableCopy];
    }

    /* Mutate to this format:
     *    YYYY-MM-DD-HHMMSS   */
    [localTimeString deleteCharactersInRange:NSMakeRange(19, [localTimeString length] - 19)];
    [localTimeString deleteCharactersInRange:NSMakeRange(16, 1)];
    [localTimeString deleteCharactersInRange:NSMakeRange(13, 1)];
    [localTimeString replaceCharactersInRange:NSMakeRange(10, 1)
                                   withString:@"-"];

    return [localTimeString copy];
}

@end

@interface NSError (SheepSafariHelperExtras)

- (NSError*)errorByRemovingRetrialRecommendation;

@end

@implementation NSError (SheepSafariHelperExtras)

- (NSError*)errorByRemovingRetrialRecommendation {
    NSMutableDictionary* userInfo = [self.userInfo mutableCopy];
    [userInfo removeObjectForKey:constKeyRetrialsRecommended];
    NSError* error = [NSError errorWithDomain:self.domain
                                         code:self.code
                                     userInfo:[userInfo copy]];
    return error;
}
/*!
 @details  Result will be one line assuming that descriptins of keys and values
 in userInfo are all one line
 */

- (NSString*)oneLineDescription {
    NSMutableString* otherInfo = [[NSMutableString alloc] init];
    for (NSString* key in [self.userInfo allKeys]) {
        if (![key isEqualToString:NSLocalizedDescriptionKey]) {
            [otherInfo appendFormat:
             @"; %@: %@",
             key,
             [self.userInfo objectForKey:key]];
        }
    }
    return [[NSString alloc] initWithFormat:
            @"Error %ld %@%@",
            (long)self.code,
            self.localizedDescription,
            otherInfo];
}

@end


/* @details

 For reasons discussed elsewhere - inexplicable crashes in the Safari
 private frameworks, possibly related to its design based on singletons to
 service a single app process, Safari.app – we only allow a SheepSafariHelper process to
 execute a single import or export operation.  (Note that we exit(0) at the
 end of either.)  But our Agent may send additional -importForKlientAppDescription:: or
 -exportForKlientAppDescription:: requests while a SheepSafariHelper process is running, and when this
 happens XPC will send the request to the already-running process.  Most of
 these requests are prevented by the Watcher.watchesInHandling mechanism
 which was introduced in commit c93469f.  But there can still be such requests,
 for example if a SheepSafariHelper process is running to do an actual sync operation when
 Bookmarks.plist gets hit, causing another trigger that wants a hash check.

 To stop these from creating a second SheepSafariHelper instance to perform a second
 import or export operation in one SheepSafariHelper process, we use this here
 static_sheepSafariHelperBusiness mechanism.  If a second request or subsequent is
 received by a SheepSafariHelper process, we return an error saying that we're busy,

 This error contains constKeyRetrialsRecommended = 10 in its userInfo.  Since
 retrials occur every constSheepSafariHelperExportRetryDuration seconds, and a SheepSafariHelper runs
 usually for 2 seconds or less, one retry should be enough – the XPC system
 will start a new SheepSafariHelper process, unless another SheepSafariHelper had launched for a
 different request in the meantime.  It's essentially a "random contention"
 problem. So, what the hell, constSheepSafariHelperExportRetryDuration * 10 is only
 about 30 seconds. */
static NSString* static_sheepSafariHelperBusiness = nil;

@interface NSAlert (DivertToNSLog)

@end

@implementation NSAlert (DivertToNSLog)

+ (void)load {
    Method originalMethod;
    Method replacedMethod;

    originalMethod = class_getClassMethod(self, @selector(alertWithError:));
    replacedMethod = class_getInstanceMethod(self, @selector(replacement_alertWithError:));
    method_exchangeImplementations(originalMethod, replacedMethod);

    originalMethod = class_getInstanceMethod(self, @selector(setMessageText:));
    replacedMethod = class_getInstanceMethod(self, @selector(replacement_setMessageText:));
    method_exchangeImplementations(originalMethod, replacedMethod);

    originalMethod = class_getInstanceMethod(self, @selector(setInformativeText:));
    replacedMethod = class_getInstanceMethod(self, @selector(replacement_setInformativeText:));
    method_exchangeImplementations(originalMethod, replacedMethod);

    originalMethod = class_getInstanceMethod(self, @selector(runModal));
    replacedMethod = class_getInstanceMethod(self, @selector(replacement_runModal));
    method_exchangeImplementations(originalMethod, replacedMethod);
}

+ (NSAlert*)replacement_alertWithError:(NSError*)error {
    NSLog(@"Creating diverted NSAlert with error: %@ %ld %@",
          error.domain,
          (long)error.code,
          error.userInfo);
    return [self replacement_alertWithError:error];
}

- (void)replacement_setMessageText:(NSString*)text {
    NSLog(@"Set diverted NSAlert message text to: %@", text);
    [self replacement_setMessageText:text];
}

- (void)replacement_setInformativeText:(NSString*)text {
    NSLog(@"Set diverted NSAlert informative text to: %@", text);
    [self replacement_setInformativeText:text];
}

- (NSModalResponse)replacement_runModal {
    NSLog(@"Diverted running of diverted NSAlert");
    return NSModalResponseOK;
}

@end

@interface NSFileManager (SSYEnsureDirectory)

- (BOOL)ensureDirectoryAtUrl:(NSURL*)url
                     error_p:(NSError**)error_p;

@end

@implementation NSFileManager (SSYEnsureDirectory)

- (BOOL)ensureDirectoryAtUrl:(NSURL*)url
                     error_p:(NSError**)error_p {
    NSError* error = nil ;

    BOOL isDirectory ;
    BOOL exists = [self fileExistsAtPath:url.path
                             isDirectory:&isDirectory] ;

    BOOL ok = YES ;
    if (exists && !isDirectory) {
        ok = [self removeItemAtURL:url
                             error:&error] ;
        if (ok) {
            exists = NO ;
        }
        else {
            error = [NSError errorWithDomain:@"SheepSafariHelper Error Domain"
                                        code:129593
                                    userInfo: @{
                                                NSLocalizedDescriptionKey : @"Could not remove file",
                                                @"URL" : url
                                                }];
        }
    }

    if (!exists) {
        NSNumber* octal755 = [NSNumber numberWithUnsignedLong:0755] ;
        // Note that, in 0755, the 0 is a prefix which says to interpret the
        // remainder of the digits as octal, just as 0x is a prefix which says to
        // interpret the remainder of the digits as hexidecimal.  It's in the C
        // language standard!
        NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    octal755, NSFilePosixPermissions,
                                    nil] ;
        ok = [self createDirectoryAtURL:url
            withIntermediateDirectories:YES
                             attributes:attributes
                                  error:&error] ;
    }

    if (error && error_p) {
        *error_p = error ;
    }

    return ok ;
}

@end


NSString* const SheepSafariHelperBarName = @"BookmarksBar";
NSString* const SheepSafariHelperMenuName = @"BookmarksMenu";

/* The following two are to handle the issue that, if the Bookmarks.plist
 file has no bar and/or no menu, -[WebBookmarkGroup load] will apparently
 create the missing bar and/or menu, but it will not write it to the file
 (as expected, because this is only a load operation), and it will conjure
 up exids (UUIDs) for these item(s).  This creates a problem because in our
 export operation, SheepSafariHelper loads the file for reading, sends the tree to main
 app, main app merges, sends export back to a different SheepSafariHelper process which
 does its own load, but since there is still with no bar or menu in the file,
 this so conjures up *different* exids (UUIDs) for the bar ane menu.  The
 parentExid of bar's and menu's children in the `puts` then do not match the
 second set of conjured exids (UUIDs), and the export fails with Issue:
 Cannot find item UUID and then Error 772030.

 Our fix is to assign the bar and menu these two special exids.  Note that
 they are formatted like a regular Safari uuid in case there is somewhere
 in Extore or Ixporter where I have assumed this format.

 Because, oddly in my view, -[WebBookmarkGroup load] does not create a
 missing Reading List aka `unfiled`, we use a different mechanism to handle a
 missing Reading List.  See mustHaveUnfiledInFile.  */
NSString* const SheepSafariHelperBarSpecialExid = @"BkmkMgrs-Bar_-XXXX-XXXXXXXXXXXX";
NSString* const SheepSafariHelperMenuSpecialExid = @"BkmkMgrs-Menu-XXXX-XXXXXXXXXXXX";
NSString* const SheepSafariHelperTabGroupFavoritesSpecialExid = @"BkmkMgrs-Tab_-Grup-Favorites___";

@interface SheepSafariHelper ()

@property (readonly) BookmarksController* bmc;
@property (readonly) WebBookmarkGroup* wbg;
@property (readonly) SAFARI_FOLDER_CLASS* root;
@property (readonly) SAFARI_FOLDER_CLASS* bar;
@property (readonly) SAFARI_FOLDER_CLASS* menu;
@property (readonly) SAFARI_FOLDER_CLASS* readingList;
@property (readonly) NSInteger indexOfFirstSoftItemInRoot;
@property (readonly) dispatch_queue_t serialQueue;

@property (strong) NSData* myLockFileData;
@property (strong) NSDictionary* changes;
@property (readonly) NSArray* puts;
@property (readonly) NSArray* cuts;
@property (readonly) NSArray* repairs;
@property (strong) NSMutableArray* limbo;
@property (assign) NSInteger limboInsertionsCount;
@property (assign) NSInteger limboRemovalsCount;
@property (strong) NSMutableDictionary* stash;
@property (strong) NSMutableDictionary* trialsByDepth;
@property (strong) NSIndexSet* safariProxyIndexesInWBG;
@property (strong) NSMutableDictionary* assignedVsProposedExids;
@property (strong) NSMutableDictionary* indexPathsForProposedExids;
@property (strong) NSMutableDictionary* returnResults;
@property (assign) NSInteger logVerbosity;
@property (assign) NSInteger lastIssueIndex;

@end


@implementation SheepSafariHelper

+ (NSInteger)logVerbosity {
    NSInteger logVerbosity;
    if ([[[NSProcessInfo processInfo] processName] isEqualToString:@"SheepSafariHelperTest"]) {
        logVerbosity = 3;
    } else {
        logVerbosity = [[NSUserDefaults standardUserDefaults] integerForKey:constKeyLogVerbosity];
    }

    return logVerbosity;
}

+ (void)beginLogging {
    if (self.logVerbosity > 0) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                             NSDesktopDirectory,  // or NSLibraryDirectory
                                                             NSUserDomainMask,
                                                             YES
                                                             ) ;
        NSString* logPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil ;
        if (logPath) {
            logPath = [logPath stringByAppendingPathComponent:@"Bkmx-SheepSafariHelper-Logs"];

            NSString* filename = [NSString stringWithFormat:
                                  @"%@-pid=%d",
                                  [SheepSafariHelper niceDateTimeString],
                                  getpid()];
            logPath = [logPath stringByAppendingPathComponent:filename];
            logPath = [logPath stringByAppendingPathExtension:@"txt"];
            [SSYLinearFileWriter setToPath:logPath];
            NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
            NSString* msg = [[NSString alloc] initWithFormat:
                             @"%@ pid %d, has launched from bundle %@",
                             [[NSProcessInfo processInfo] processName],  // "SheepSafariHelper" or "SheepSafariHelperTest"
                             getpid(),
                             bundlePath];
            [SheepSafariHelper logString:msg];
            msg = [[NSString alloc] initWithFormat:
                   @"This file is logging at level %ld",
                   (long)[self logVerbosity]];
            [SheepSafariHelper logString:msg];
        }
    }
}

+ (NSString*)niceDateTimeString {
    return [[NSDate date] niceString];
 }

- (id)init {
    self = [super init];
    if (self) {
        self.logVerbosity = [[self class] logVerbosity];

        _indexOfFirstSoftItemInRoot = -1;
    }

    return self;
}

- (NSURL*)lockFileUrl {
    NSURL* url = [BookmarksController defaultBookmarksFileURL];
    url = [url URLByDeletingLastPathComponent];
    url = [url URLByAppendingPathComponent:@"lock"];
    url = [url URLByAppendingPathComponent:@"details.plist"];
    return url;
}

/*!
 @details  This was added in BkmkMgrs 2.9.9, as part of "save and reload after
 writing each depth of puts" mechanism required for macOS 10.14.4.  The idea
 is that I don't want iClould coming in and reading changes after the save of
 each depth.  I saw that happen, that is, I saw the `lock` and/or
 `details.plist` file appearing and disappearing throughout a multi-level
 export,  and I think it was responsible for some "iCloud on the fritz"
 incidents I also saw.

 To prevent that, I acquire the lock file before the first depth is processed
 (-acquireLockFile) and hold on to it until after the last depth is saved
 {-relinquishLockFile).

 Furthermore, I found that, for this to actually work and not see my lock
 file overwritten by what I assume as iCloud (actually,
 SafariBookmarksSyncAgent), I cannot use my own process name
 ([[NSProcessInfo processInfo] processName]) for LockFileProcessID.  I must
 be untruthful and say that I am "Safari".

 Older Notes:  If we don't do this, at some point, the Safari Private Frameowork
 creates the lock will prevent the SafariBookmarksSyncAgent from syncing to
 iCloud.  Actually, SafariBookmarksSyncAgent will log a message to Console
 every 200 msec: "Lock file appears valid".  Possibly these method would help:
 -[BookmarksController _unlockFileLockerWithCompletionHandler:]
 -[BookmarksController _lockFileLockerWithCompletionHandler:]
 method which it seems I don't need to invoke directly. */
- (BOOL)acquireLockFile {
    BOOL ok = YES;
    NSError* error = nil;

    NSDate* startDate = [NSDate date];
    while (YES) {
        NSData* lockFileData = [NSData dataWithContentsOfURL:self.lockFileUrl];
        if (!lockFileData) {
            break;
        } else if ([lockFileData isEqual:self.myLockFileData]) {
            NSDictionary* info = [NSPropertyListSerialization propertyListWithData:lockFileData
                                                                           options:0
                                                                            format:NULL
                                                                             error:NULL];
            [self reportIssue:[[NSString alloc] initWithFormat:
                               @"Eeek, removing my own lock from %@",
                               [info objectForKey:@"LockFileDate"]]];
            break;
        } else if ([[self analysisOfLockFileData:lockFileData] hasPrefix:@"SheepSafariHelper"]) {
            /* This is expected occasionally, because apparently Safari
             Private Frameworks will/may? acquire a lock on our behalf. */
            [self logIfLevel:5
                      string:@"SPF may have got lock for us"];
            break;
        } else if (-[startDate timeIntervalSinceNow] > [self acquireLockTimeout]) {
            [self reportIssue:[[NSString alloc] initWithFormat:
                               @"Acquire lock timed out cuz %@",
                               [self analysisOfLockFileData:lockFileData]]];
            ok = NO;
            break;
        }

        sleep(4);
    }

    NSData* data = nil;
    [self logIfLevel:5
              string:[[NSString alloc] initWithFormat: @"Acquired lock ok=%hhd", ok]];
    if (ok) {
        NSMutableDictionary* lockDetails = [[NSMutableDictionary alloc] init];
        NSObject* object;
        [lockDetails setObject:[NSDate date]
                        forKey:@"LockFileDate"];
        [lockDetails setObject: @(getpid())
                        forKey:@"LockFileProcessID"];
        [lockDetails setObject:@"Safari"  // See class documentation
                        forKey:@"LockFileProcessName"];
        [lockDetails setObject:NSFullUserName()
                        forKey:@"LockFileUsername"];
        object = [self machineHardwareUUID];
        if (object) {
            [self logIfLevel:5
                      string:@"Got Machine Hardware UUID."];
            [lockDetails setObject:object
                            forKey:@"LockFileHostname"];
        } else {
            [self reportIssue:@"Will create lock without Machine Hardware UUID"];
        }
         
        /* When iCloud syncs Safari bookmarks, it also creates a lock file,
         identical except "LockFileProcessName" is "SafariBookmarksSyncAgent".
         I suspect that when Safari is writing Safari bookmarks, the
         "LockFileProcessName" is "Safari". */
        data = [NSPropertyListSerialization dataWithPropertyList:lockDetails
                                                          format:NSPropertyListBinaryFormat_v1_0
                                                         options:0
                                                           error:&error];
        ok = (data != nil);
        if (!ok) {
            [self reportIssue:[[NSString alloc] initWithFormat:
                               @"Error creating lockDetails data; %@",
                               error]];
        }
    }
    [self logIfLevel:5
              string:@"Created lock file data."];

    if (ok) {
        ok = [[NSFileManager defaultManager] ensureDirectoryAtUrl:[self.lockFileUrl URLByDeletingLastPathComponent]
                                                          error_p:&error];
        if (!ok) {
            [self reportIssue:[[NSString alloc] initWithFormat:
                               @"Error ensuring lock directory; %@",
                               error]];
        }
    }

    if (ok) {
        ok = [data writeToURL:self.lockFileUrl
                   atomically:YES];
        if (ok) {
            [self logIfLevel:5
                      string:@"Wrote lock file."];
        } else {
            [self reportIssue:[[NSString alloc] initWithFormat:
                               @"Error writing lock file; %@",
                               error]];
        }
    }

    if (ok) {
        self.myLockFileData = data;
    }
    
    return ok;
}

- (NSTimeInterval)acquireLockTimeout {
    return constSheepSafariHelperTimeoutWrite / 2;
}

- (NSString*)analysisOfLockFileData:(NSData*)data {
    NSError* error = nil;
    NSDictionary* info = [NSPropertyListSerialization propertyListWithData:data
                                                                   options:0
                                                                    format:NULL
                                                                     error:&error];
    NSString* analysis;
    if ([info respondsToSelector:@selector(objectForKey:)]) {
        NSDate* date = [info objectForKey:@"LockFileDate"];
        if ([date isKindOfClass:[NSDate class]]) {
        }
        analysis = [[NSString alloc] initWithFormat:
                    @"%@ : %@",
                    [info objectForKey:@"LockFileProcessName"],
                    [info objectForKey:@"LockFileDate"]];
    } else {
        analysis = [error description];
    }

    return analysis;
}

- (void)relinquishLockFileExpectantly:(BOOL)expectantly {
    BOOL ok;
    NSError* error = nil;

    if (expectantly) {
        NSData* lockFileData = [NSData dataWithContentsOfURL:self.lockFileUrl];
        if (!lockFileData) {
            [self reportIssue:@"No file lock to relinquish"];
        }
        else if (![lockFileData isEqual:self.myLockFileData]) {
            [self reportIssue:[[NSString alloc] initWithFormat:
                               @"Unexpected file lock: %@",
                               [self analysisOfLockFileData:lockFileData]]];
        }
    }

    ok = [[NSFileManager defaultManager] removeItemAtURL:self.lockFileUrl
                                                   error:&error];
    if (expectantly && !ok) {
        [self reportIssue:[[NSString alloc] initWithFormat:
                           @"Error removing lock file; %@",
                           error]];
    }
    ok = [[NSFileManager defaultManager] removeItemAtURL:[self.lockFileUrl URLByDeletingLastPathComponent]
                                                   error:&error];
    if (expectantly && !ok) {
        [self reportIssue:[[NSString alloc] initWithFormat:
                           @"Error removing lock directory; %@",
                           error]];
    }
}


- (dispatch_queue_t)serialQueue {
    if (!_serialQueue) {
        _serialQueue = dispatch_queue_create(
                                             "com.sheepsystems.SheepSafariHelper-Depths",
                                             DISPATCH_QUEUE_SERIAL
                                             );
    }

    return _serialQueue;
}

/* SheepSafariHelper's logVerbosity may be 0 (no logging) to 5 (max logging).  To set it,
 >     defaults write com.sheepsystems.SheepSafariHelper logVerbosity <N>
 where 0 <= N <= 5
 Note that N=5 will log an entry as each item (bookmark/folder) is found while
 building a tree.  So N=4 may be what you want.
 Log entries will be written to file on Desktop and identically to  NSLog(). */

+ (void)logString:(NSString*)string {
    NSString* logEntry = [[NSString alloc] initWithFormat:
                          @"%@: %@",
                          [self niceDateTimeString],
                          string];
    [SSYLinearFileWriter writeLine:logEntry];
    NSLog(@"%@", logEntry);
}

- (void)logIfLevel:(NSInteger)level
            string:(NSString*)string {
    if (level <= self.logVerbosity) {
        [[self class] logString:string];
    }
}

- (void)addSafariFrameworkTattleToReturnResults {
    NSBundle* safariBundle = [NSBundle bundleForClass:[BookmarksController class]];
    NSString* path = [safariBundle bundlePath];
	[self logIfLevel:1
          string:[[NSString alloc] initWithFormat:
                  @"Using: %@",
                  path]];

    NSString* tattle;
    if ([path isEqualToString:@"/System/Library/PrivateFrameworks/Safari.framework"]) {
        tattle = @"Pvt";
    } else if ([path isEqualToString:@"/System/Library/StagedFrameworks/Safari/Safari.framework"]) {
        tattle = @"Stg";
    } else {
        tattle = @"???";
    }

    [self.returnResults setObject:tattle
                           forKey:constKeySheepSafariHelperResultSafariFrameworkTattle];
}


#pragma mark  Wrappers Around the Weird Private API

- (BookmarksController*)bmc {
    if (!_bmc) {
        NSInteger pathMethod = 0;
        if ([[BookmarksController class] respondsToSelector:@selector(defaultBookmarksFileURL)]) {
            pathMethod = 3;
        } else if ([[BookmarksController class] respondsToSelector:@selector(standardBookmarksFilePath)]) {
            pathMethod = 2;
        } else {
            pathMethod = 1;
        }

        NSInteger initMethod = 0;
        if ([BookmarksController instancesRespondToSelector:@selector(_initWithBookmarksFilePath:builtInBookmarksURL:migratedBookmarksFolder:siteMetadataManagerProvider:)]) {
            // macOS  13 Beta 4 or later
            initMethod = 5;
        } else if ([BookmarksController instancesRespondToSelector:@selector(_initWithBookmarksFilePath:builtInBookmarksURL:migratedBookmarksFolder:spotlightCacheController:siteMetadataManagerProvider:)]) {
            // macOS 10.14.4b3 or later
            initMethod = 4;
        } else if ([BookmarksController instancesRespondToSelector:@selector(_initWithBookmarksFilePath:builtInBookmarksURL:migratedBookmarksFolder:spotlightCacheController:siteMetadataManager:)]) {
            // macOS 10.14.4b1 or 10.14.4b2
            initMethod = 3;
        } else if ([BookmarksController instancesRespondToSelector:@selector(_initWithBookmarksFilePath:migratedBookmarksFolder:spotlightCacheController:)]) {
            // macOS 10.13, 10.12, 10.11.6
            initMethod = 2;
        } else {
            // macOS 10.11.3, and I hope, 10.10.
            initMethod = 1;
        }

        [self logIfLevel:5
                  string:[[NSString alloc] initWithFormat:
                          @"Will use bmc path method %ld, init method %ld",
                          (long)pathMethod,
                          (long)initMethod]];
        if (initMethod == 1) {
            [self logIfLevel:1
                      string:@"PROBABLY TROUBLE AHEAD! cuz bmc init method 1"];
        }
        NSString* path = nil;
        switch (pathMethod) {
            case 3:
                path = [[BookmarksController defaultBookmarksFileURL] path];
                break;
            case 2:
                path = [BookmarksController standardBookmarksFilePath];
                break;
            case 1:
                path = NSHomeDirectory();
                path = [path stringByAppendingPathComponent:@"Library/Safari/Bookmarks.plist"];
                break;
            default:;
        }

        [self logIfLevel:5
                  string:[[NSString alloc] initWithFormat:
                          @"Got path for bmc: %@",
                          path]];

        if (path) {
            switch (initMethod) {
                case 5:
                    _bmc = [[BookmarksController alloc] _initWithBookmarksFilePath:[[BookmarksController defaultBookmarksFileURL] path]
                                                               builtInBookmarksURL:nil
                                                           migratedBookmarksFolder:nil
                                                       siteMetadataManagerProvider:nil];
                    break;
                case 4:
                    _bmc = [[BookmarksController alloc] _initWithBookmarksFilePath:[[BookmarksController defaultBookmarksFileURL] path]
                                                               builtInBookmarksURL:nil
                                                           migratedBookmarksFolder:nil
                                                          spotlightCacheController:nil
                                                       siteMetadataManagerProvider:nil];
                    break;
                case 3:
                    _bmc = [[BookmarksController alloc] _initWithBookmarksFilePath:[[BookmarksController defaultBookmarksFileURL] path]
                                                               builtInBookmarksURL:nil
                                                           migratedBookmarksFolder:nil
                                                          spotlightCacheController:nil
                                                               siteMetadataManager:nil];
                    break;
                case 2:
                    _bmc = [[BookmarksController alloc] _initWithBookmarksFilePath:[[BookmarksController defaultBookmarksFileURL] path]
                                                           migratedBookmarksFolder:nil
                                                          spotlightCacheController:nil];
                    break;
                case 1:
                    _bmc = [[BookmarksController alloc] init];
                    break;
                default:;
            }

            [self logIfLevel:5
                      string:[[NSString alloc] initWithFormat:
                              @"Got bmc: %@",
                              _bmc]];
        }

    }

    return _bmc;
}

- (WebBookmarkGroup*)wbg {
    if (!_wbg) {
        _wbg = [[self bmc] allBookmarks];
    }

    return _wbg;
}

- (BookmarksUndoController*)buc {
    if (!_buc) {
        /* The linker fails to link BookmarksUndoController for some strange
         reason.  See:
         https://forums.raywenderlich.com/t/cant-create-instances-of-apple-private-classes-in-segment-s/35570/3
         So we use NSClassFromString. */
        Class bucClass = NSClassFromString(@"BookmarksUndoController");
        if  ([bucClass respondsToSelector:@selector(initWithUndoManager:dataStore:bookmarksController:)]) {
            // macOS 10.14.4 or later
            _buc =[[bucClass alloc] initWithUndoManager:nil
                                              dataStore:self.bmc
                                    bookmarksController:self.bmc];
            /* It seems to make no difference what parameters you pass to the
             above method.  The first can be [NSUndoManager new] or nil.  The
             second and third can be self.bmc or nil. */
        }
        else if ([bucClass respondsToSelector:@selector(initWithUndoManager:)]) {
            // macOS 10.14.3 or earlier
            _buc =[[bucClass alloc] initWithUndoManager:nil];
        } else {
            // Dios te salve Maria, llena eres de gracia…
            _buc =[[bucClass alloc] init];
        }
    }

    return _buc;
}

- (void)load {
    [self.wbg load]; // Apparently, loads from disk
}

/*!
 @details  We only clear the things that should be cleared for a new depth.
 For example, we do not clear limbo or returnResults.
 */
- (void)clear {
    _buc = nil;
    _wbg = nil;
    _bmc = nil;
    _root = nil;
    _bar = nil;
    _menu = nil;
    _readingList = nil;
    self.safariProxyIndexesInWBG = nil;
    _indexOfFirstSoftItemInRoot = -1;
}

- (void)save {
    // See Note 20171031BMN regarding the following.
    [self setName:SheepSafariHelperBarName
         bookmark:self.bar];
    [self setName:SheepSafariHelperMenuName
         bookmark:self.menu];

    int saveResult = [self.wbg save];  // Apparently, saves to disk
    /* Until 20171227, the only saveResult I've ever seen here is 2.  Even if
     I rm removed the Bookmarks.plist file before calling -save, -save cleverly
     creates a new Boomarks.plist file and returns 2.  However, on 20171227,
     with macOS 10.13.3 Beta 2, I began seeing result 1. */
    NSString* saveResultsString = [self.returnResults objectForKey:constKeySheepSafariHelperResultSaveResults];
    if (saveResultsString) {
        saveResultsString = [saveResultsString stringByAppendingFormat:@",%ld", (long)saveResult];
    } else {
        saveResultsString = [NSString stringWithFormat:@"%ld", (long)saveResult];
    }
    [self.returnResults setObject:saveResultsString
                           forKey:constKeySheepSafariHelperResultSaveResults];
}

- (void)requestSync {
    BOOL didRequestSyncClientTrigger = NO;
    // 10.12+ will execute the following branch.  Not sure about 10.11-
#if 0
#warning Using more aggressive (maybe) requestSync
    if ([BookmarksController respondsToSelector:@selector(requestSyncClientTriggerSyncForBookmarkGroup:skipRequestIfNoChanges:)]) {
        [BookmarksController requestSyncClientTriggerSyncForBookmarkGroup:self.wbg
                                                   skipRequestIfNoChanges:NO];
        didRequestSyncClientTrigger = YES;
    }
#else
    if ([BookmarksController respondsToSelector:@selector(requestSyncClientTriggerSyncForBookmarkGroup:)]) {
        [BookmarksController requestSyncClientTriggerSyncForBookmarkGroup:self.wbg];
        didRequestSyncClientTrigger = YES;
    }
#endif
    [self.returnResults setObject:[NSNumber numberWithBool:didRequestSyncClientTrigger]
                           forKey:constKeySheepSafariHelperDidRequestSyncClientTrigger];
}

- (SAFARI_FOLDER_CLASS*)root {
    if (!_root) {
        _root = [self.wbg topBookmark];
    }

    return _root;
}

- (SAFARI_FOLDER_CLASS*)bar {
    if (!_bar) {
        _bar = [self.bmc bookmarksBarCollection];
    }

    return _bar;
}

- (SAFARI_FOLDER_CLASS*)menu {
    if (!_menu) {
        _menu = [self.bmc bookmarksMenuCollection];
    }

    return _menu;
}

- (SAFARI_FOLDER_CLASS*)readingList {
    if (!_readingList) {
        for (WebBookmark* item in [self.root folderAndLeafChildren]) {  // See Note F&LC
            // Leaf items will not respond…
            if ([item respondsToSelector:@selector(isReadingListFolder)]) {
                if ([(SAFARI_FOLDER_CLASS*)item isReadingListFolder]) {
                    _readingList = (SAFARI_FOLDER_CLASS*)item;
                }
            }
        }
    }

    return _readingList;
}

- (NSInteger)indexOfTabGroupFavorites {
    NSArray* rootChildren = [self.root folderAndLeafChildren];
    NSInteger indexOfMenu = [rootChildren indexOfObject:self.menu];
    NSInteger indexOfBarOrMenu = NSNotFound;
    if (indexOfMenu != NSNotFound) {
        indexOfBarOrMenu = indexOfMenu;
    } else {
        NSInteger indexOfBar = [rootChildren indexOfObject:self.bar];
        if (indexOfBar != NSNotFound) {
            indexOfBarOrMenu = indexOfBar;
        }
    }
    
    NSInteger indexOfTabGroupFavorites = NSNotFound;
    NSInteger highestIndex = [rootChildren count] - 1;
    if (highestIndex > indexOfBarOrMenu) {
        NSInteger possibleIndexOfTabGroupFavorites = indexOfMenu + 1;
        SAFARI_FOLDER_CLASS* possibleTabGroupFavorites = [rootChildren objectAtIndex:possibleIndexOfTabGroupFavorites];
        if (possibleTabGroupFavorites.bookmarkType == 1) {
            if ([possibleTabGroupFavorites.title isEqualToString:@"Tab Group Favorites"]) {
                indexOfTabGroupFavorites = possibleIndexOfTabGroupFavorites;
            }
        }
    }
    
    return indexOfTabGroupFavorites;
}

/*!
 @brief    Returns the index of the first soft item in root in the
 loaded Bookmarks.plist file, or what that index would be if there are no
 soft items in root
 */
- (NSInteger)indexOfFirstSoftItemInRoot {
    if (_indexOfFirstSoftItemInRoot == -1) {
        /*
         In macOS 13
         
         The children of root returned by [[self.root _children] are:
         0  History
         1  Bar
         2  Menu
         3  Tab Group Favorites
         4  Reading List
         The indexes in this array of bar, menu and reading list agree with
         what is returned by
         [self.root indexOfChild:self.bar] = 1
         [self.root indexOfChild:self.menu] = 2
         [self.root indexOfChild:self.readingList] = 4

         But the children of root returned by [self.root folderAndLeafChildren],
         which is what we generally use in this class, and thus what we want, are
         0  Bar
         1  Menu
         2  Tab Group Favorites
         3  Reading List
         
         So you see we want to subract 1 (for the missing "History")  then
         add 1 to get the first soft item.
         */
        NSInteger indexOfLastHardFolderInRoot;

        /* The hard folders always appear in the order: Bar, Menu, Tab Group Favorites, Reading List,
         although some may be absent.  So we search for the highest one,
         starting at the end (Reading List).  If that is not found, try the
         next highest one, etc. */
        
        NSString* whichCase = @"RDL";
        indexOfLastHardFolderInRoot = [self.root indexOfChild:self.readingList];
        if (indexOfLastHardFolderInRoot == NSNotFound) {
            whichCase = @"TGF";
            indexOfLastHardFolderInRoot = [self indexOfTabGroupFavorites];
            if (indexOfLastHardFolderInRoot == NSNotFound) {
                whichCase = @"MNU";
                indexOfLastHardFolderInRoot = [self.root indexOfChild:self.menu];
                if (indexOfLastHardFolderInRoot == NSNotFound) {
                    whichCase = @"BAR";
                    indexOfLastHardFolderInRoot = [self.root indexOfChild:self.bar];
                    if (indexOfLastHardFolderInRoot == NSNotFound) {
                        whichCase = @"?X?";
                        /* Just return NSNotFound and crash or whatever because a
                         wrong guess here could corrupt user's bookmarks. */
                    }
                }
            }
        }
        
        /* The first soft item is indexed one after that of the last hard itrm. */
        _indexOfFirstSoftItemInRoot =  indexOfLastHardFolderInRoot + 1;

        [self logIfLevel:2
                  string:[[NSString alloc] initWithFormat:
                          @"Calcd indexOfFirstSoftItemInRoot = %ld (Case %@)",
                          _indexOfFirstSoftItemInRoot,
                         whichCase]];
    }

    return _indexOfFirstSoftItemInRoot;
}

#if 0
/* This is a replacement for -[WebBookmarkGroup bookmarkForUUID] which I
 wrote one time when I thought it was not working.  It may be handy for
 future use.  If you feed it level = 0 and item = [self root], it
 demontrates how to walk and log the entire tree. */
- (WebBookmark*)recursivelyFindItemWithUuid:(NSString*)uuid
                                      level:(NSInteger)level
                                   inFolder:(WebBookmark*)item {
    NSMutableString* indent = [@"" mutableCopy];
    for (NSInteger i=0; i<level; i++) {
        [indent appendString:@"  "];
    }

    if ([item.UUID isEqualToString:uuid]) {
        return item;
    }

    if ([item respondsToSelector:@selector(folderAndLeafChildren)]) { // See Note F&LC
        level++;
        SAFARI_FOLDER_CLASS* subfolder = (SAFARI_FOLDER_CLASS*)item;
        for (WebBookmark* child in [subfolder folderAndLeafChildren]) { // See Note F&LC
            WebBookmark* answer = [self recursivelySearchForUuid:uuid
                                                           level:level
                                                        inFolder:child];
            if (answer) {
                return answer;
            }
        }
    }

    return nil;
}

- (void)recursivelyLogAllUUIDsInFolder:(WebBookmark*)item {
    printf("%s\n", [item.UUID UTF8String]) ;

    if ([item respondsToSelector:@selector(folderAndLeafChildren)]) { // See Note F&LC
        SAFARI_FOLDER_CLASS* subfolder = (SAFARI_FOLDER_CLASS*)item;
        for (WebBookmark* child in [subfolder folderAndLeafChildren]) { // See Note F&LC
            [self recursivelyLogAllUUIDsInFolder:child];
        }
    }
}
#endif

- (id)itemForUuid:(NSString*)uuid
           caller:(NSInteger)caller {
    id answer;
    if (uuid) {
        answer = [self.wbg bookmarkForUUID:uuid];  // Should be named "itemForUUID:" cuz it gets folders too
        if (!answer) {
            answer = [self.stash objectForKey:uuid];
            if (answer) {
                [self reportIssue:[[NSString alloc] initWithFormat:@"Got from stash for %@", uuid]];
                [self logIfLevel:5
                          string:[[NSString alloc] initWithFormat:@"Got from stash: %@", answer]];
            } else {
                [self reportIssue:[[NSString alloc] initWithFormat:@"Cannot find item UUID %@ for %ld", uuid, caller]];
            }
        }
    }
    else {
        answer = nil;
    }

    return answer;
}

- (WebBookmarkLeaf*)newBookmarkWithParent:(SAFARI_FOLDER_CLASS*)parent
                                    index:(NSInteger)index
                                     name:(NSString*)name
                                      url:(NSString*)url
                                 comments:(NSString*)comments {
    WebBookmarkLeaf* newBookmark = [NSClassFromString(@"WebBookmarkLeaf") bookmarkWithURLString:url
                                                                                          title:name];

    if (!newBookmark) {
        [self reportIssue:[[NSString alloc] initWithFormat:
                           @"Could not create boookmark: %@ %@",
                           name,
                           url]];
    }
    if (!parent) {
        [self reportIssue:[[NSString alloc] initWithFormat:
                           @"No parent where to create bookmark: %@ %@",
                           name,
                           url]];
    }

    if (newBookmark) {
        [self.buc insertBookmark:newBookmark
                         atIndex:index
                inBookmarkFolder:parent
              allowDuplicateURLs:YES];

        if (comments) {
            [self setComments:comments
                     bookmark:newBookmark];
        }
    }

    return newBookmark;
}

- (SAFARI_FOLDER_CLASS*)newFolderSafari2019WithParent:(SAFARI_FOLDER_CLASS*)parent
                                            index:(NSInteger)index
                                             name:(NSString*)name {
    NSDictionary* dicRep = @{
                             @"Title" : name,
                             @"WebBookmarkType" : @"WebBookmarkTypeList",
                             };
    SAFARI_FOLDER_CLASS* newFolder = [SAFARI_FOLDER_CLASS bookmarkFromDictionaryRepresentation:dicRep
                                                                             withGroup:self.wbg];
    /* Do NOT set the exid/UUID here.  Such a UUID will apparently be
     ignored – the UUID which will show up in Bookmarks.plist will be
     different. */

    /* In macOS 12, newFolder may be nil at this point. */
    if (newFolder) {
        [self.buc insertBookmark:newFolder
                         atIndex:index
                inBookmarkFolder:parent
              allowDuplicateURLs:YES];
    }
    
    return newFolder;
}

- (SAFARI_FOLDER_CLASS*)newFolderWithParent:(SAFARI_FOLDER_CLASS*)parent
                                  index:(NSInteger)index
                                   name:(NSString*)name {
    SAFARI_FOLDER_CLASS* newFolder = nil;
    
    if (@available(macOS 10.14.4, *)) {
        newFolder = [self newFolderSafari2019WithParent:parent
                                                  index:index
                                                   name:name];
    } else {
        /* In macOS 10.14.4, the following function seems to be a total no-op.
         In macOS 10.14.4, it will always return nil, and never add a folder
         to the bookmarks as expected.  Regardless of what types you pass for
         the three parameters, it will never raise an exception and never
         cause a crash.  Prior to testing macOS 10.14.4 in 2019 Feg, this
         worked as expected.
         */
        newFolder = [self.buc addNewFolderTo:parent
                                   withTitle:name
                              insertionIndex:index];
        /* Do NOT set the exid/UUID here.  Such a UUID *will* be written to the
         new item's dictionary in the Bookmarks.plist.  However, the record in
         in Sync.Changes will have a *different* BookmarkUUID, so the item will
         not be synced to iCloud and, of course, things will of course go downhill
         from there. */

        /* But there is more.  I in Feb 2019 I also saw indications of the same
         no-op I saw in macOS 10.14.4 when running in macOS 10.13.6, which is,
         hmmmm, now using a staged framework, that is,
            /System/Library/StagedFrameworks/Safari/Safari.framework
         So it looks like this no-op is also appearing in Safari updates
         (Safari coninues to be updated in older macOS versions.)  To fix that,
         I added this check, to use same the "2019" method used for macOS
         10.14.4 if the above older method returns nil: */
        if (newFolder) {
            [self logIfLevel:5
                      string:[[NSString alloc] initWithFormat:
                              @"Made new folder using method 1: %@", name]];
        }

        if (!newFolder) {
            newFolder = [self newFolderSafari2019WithParent:parent
                                                      index:index
                                                       name:name];
            if (newFolder) {
                [self logIfLevel:5
                          string:[[NSString alloc] initWithFormat:
                                  @"Made new folder using method 2: %@", name]];
            }
        }
    }


    /* The following section is needed for macOS 12. */
#define FORCE_USERS_TO_UPGRADE_TO_BKMKMGRS_3_WITH_MACOS_12 0
#if FORCE_USERS_TO_UPGRADE_TO_BKMKMGRS_3_WITH_MACOS_12
#else
    if (!newFolder) {
        /* Eureka minute was 2021 06 11 00:36 */
        newFolder = [self.wbg insertNewBookmarkListAtIndex:index
                                                ofBookmark:parent
                                                 withTitle:name];
        if (newFolder) {
            [self logIfLevel:5
                      string:[[NSString alloc] initWithFormat:
                              @"Made new folder using method 3: %@", name]];
        }
    }
#endif
    
    if (!newFolder) {
        [self reportIssue:[[NSString alloc] initWithFormat:
                           @"All methods failed to add new folder '%@'",
                           name]];
    }

    return newFolder;
}

/*!
 @details  Although I wrote this method to support creation of all three
 hartainers, we only use it for the Unfiled.  We do not use it for Bar nor
 Menu because, oddly -[WebBookmarkGroup load] will always create one if there
 is none in the file and, of course, having two would be a disaster.
 */
- (SAFARI_FOLDER_CLASS*)newHartainerOfType:(NSString*)type {
    NSMutableDictionary* dicRep = [[NSMutableDictionary alloc] init];
    [dicRep setObject:@"WebBookmarkTypeList"
               forKey:@"WebBookmarkType"];
    NSString* name;
    if ([type isEqualToString:BkmxConstTypeBar]) {
        name = @"BookmarksBar";
    } else if ([type isEqualToString:BkmxConstTypeMenu]) {
        name = @"BookmarksMenu";
    } else if ([type isEqualToString:BkmxConstTypeUnfiled]) {
        name = @"com.apple.ReadingList";
        [dicRep setObject:@YES
                   forKey:@"ShouldOmitFromUI"];
    } else {
        NSLog(@"Internal Error 523-9938");
        name = @"";
    }
    [dicRep setObject:name
               forKey:@"Title"];
    /* Do NOT set the exid/UUID here.  Such a UUID will apparently be
     ignored – the UUID which will show up in Bookmarks.plist will be
     different. */

    SAFARI_FOLDER_CLASS* newHartainer = [SAFARI_FOLDER_CLASS bookmarkFromDictionaryRepresentation:[dicRep copy]
                                                                                withGroup:self.wbg];

    if (newHartainer) {
        [self.buc insertBookmark:newHartainer
                         atIndex:self.indexOfFirstSoftItemInRoot
                inBookmarkFolder:self.root
              allowDuplicateURLs:YES];
    }

    return newHartainer;
}

- (void)setName:(NSString*)name
       bookmark:(WebBookmark*)bookmark {
    /* There is an edge case where name here might be an NSNull, if the name
     of an item is changed to an empty string in a browser which allows
     empty strings as names, such as Chrome, and that change is imported
     our app, it will have a nil name (Stark.hame = nil), and then if this
     change is exported to Safari, the relevant Stange will have
     a .updates dictionary which will contain a subdictionary for key 'name'
     which will have an 'old' key/value but not a 'new' key/value.  In the
     changes dictionary sent to SheepSafariHelper, this will be made into an
     NSNull object (see Note HowWeGetNullName).  However, in here,
     -[BookmarksUndoController changeTitleOfBookmark:to:]
     will raise an exception of passed a NSNull name.  But it works OK with
     nil.  The item will appear in Safari to have, and continue to have
     even after a relaunch, an empty name, as expected. */
    if (![name respondsToSelector:@selector(length)]) {
        name = nil;
    }
    
    [self.buc changeTitleOfBookmark:bookmark
                                 to:name];
}

- (void)setUrl:(NSString*)url
      bookmark:(WebBookmark*)bookmark {
    [self.buc changeAddressOfBookmark:bookmark
                                   to:url];
}

- (void)setComments:(NSString*)comments
          bookmark:(WebBookmark*)bookmark {
    /* Sending -setReadingListIemPreviewText to a bookmark which is not in
     Reading List seems to be have no effect.  To avoid trouble, we therefore
     check and only send if `bookmark` is a Reading List item. */

    /* No folders allowed in Reading List, so only consider first ancestor: */
    if (bookmark.parent.isReadingListFolder) {
        [bookmark setReadingListItemPreviewText:comments];
    }
    /*
     I also tried sending:
     [self.buc changePreviewTextOfBookmark:bookmark to:comments isUserCustomized:YES];
     Result: Do not send that.  If sent to a bookmark in the Reading List,
     it adds a "previewText" key/value to the base of the item's dictionary,
     which is not where Safari puts `PreviewText`.  (Safari puts preview text
     for new Reading List items in `ReadingList.PreviewText`).  If sent
     to a bookmark which is not in Reading List, eek, it raises an exception
     from trying to init a new NSDictionary from a nil NSDictionary.  I suspect
     that this is the `ReadingList` dictionary which does not exist in
     non-ReadingList bookmarks. */
}

/* Note: MovingItemRuinsItsUuid
 I think the strangest behavior I've seen from from Safari Private Frameworks
 is that after you move a bookmark using
 -[BookmarksUndoController moveBookmarks:to:startingIndex:], the value of its
 'UUID' property becomes a new UUID which is never seen anywhere else.  When
 you later -save, the moved item's UUID in the Bookmarks.plist file will be
 its original pre-move UUID. */
- (BOOL)moveToParent:(SAFARI_FOLDER_CLASS*)parent
               index:(NSInteger)index
            bookmark:(WebBookmark*)bookmark {
    BOOL ok = NO;
    if (bookmark) {
        /* See Note: MovingItemRuinsItsUuid. */
        ok  = [self.buc moveBookmarks:[NSArray arrayWithObject:bookmark]
                                   to:parent
                        startingIndex:index];
    }

    return ok;
}

- (void)deleteItem:(WebBookmark*)item {
    if (item) {
        [self.buc removeBookmarks:@[item]];
    }
}

#pragma mark Export Processing Methods

- (BOOL)fixAssignedVsProposedExidsFromDiskDepth:(NSInteger)depth
                                        error_p:(NSError **)error_p {
    NSError* error = nil;
    if (self.indexPathsForProposedExids.count > 0) {
        NSDictionary* root = nil;
        NSData* data = [NSData dataWithContentsOfFile:[self wbg].filePath
                                              options:0
                                                error:&error] ;
        if (data) {
            root = [NSPropertyListSerialization propertyListWithData:data
                                                             options:NSPropertyListImmutable
                                                              format:NULL
                                                               error:&error] ;
        }

        if (root && !error) {
            for (NSString* proposedExid in self.indexPathsForProposedExids) {
                NSIndexPath* indexPath = [self.indexPathsForProposedExids objectForKey:proposedExid];
                id currentItem = root;
                NSString* actualExid = nil;
                for (NSInteger i=0; i<indexPath.length; i++) {
                    /* Index path is in reverse order, starting at the bookmark
                     and finishing at the root.  So we read backwards: */
                    NSInteger index = [indexPath indexAtPosition:(indexPath.length - 1 - i)];
                    NSArray* children = [currentItem objectForKey:@"Children"];
                    // Proxies only occur in root
                    if (currentItem == root) {
                        /* The index offset we need will be the number of
                         Safari proxies before the current `index`. */
                        NSInteger offsetForProxies = [self.safariProxyIndexesInWBG countOfIndexesInRange:NSMakeRange(0, index)];
                        index -= offsetForProxies;
                    }
                    if ((i >= 0) && (index < children.count)) {
                        currentItem = [children objectAtIndex:index];
                        actualExid = [currentItem objectForKey:@"WebBookmarkUUID"];
                    }
                }

                if (actualExid) {
                    [self.assignedVsProposedExids setObject:actualExid
                                                     forKey:proposedExid];
                } else if (indexPath) {
                    [self reportIssue:[[NSString alloc] initWithFormat:
                                       @"d=%ld No resolve indexPath %@ for %@",
                                       (long)depth,
                                       indexPath,
                                       proposedExid]];
                } else {
                    [self reportIssue:[[NSString alloc] initWithFormat:
                                       @"d=%ld Neither actualExid nor indexPath for proposedExid %@ in %@",
                                       (long)depth,
                                       proposedExid,
                                       self.indexPathsForProposedExids]];
                }
            }
        }
    }

    if (error && error_p) {
        *error_p = error ;
    }

    return (error == nil);
}

- (BOOL)isBarDic:(NSDictionary*)dic {
    NSString* name = [dic objectForKey:@"Title"];
    if ([name isEqual:@"BookmarksBar"]) {
        return YES;
    }
    /* That may not work if the SafariPrivateFramework has inadvertently
     re-titled the bar from BookmarksBar to the name seen for the bar in
     the user interface, as we have seen happen.  Therefore, we now use
     an alternate method we have found to identify the bar, which will
     only work if the "Sync" subdic is present, which I think is true
     if iCloud syncing has *ever* been enabled on this Bookmarks.plist */
    NSDictionary* syncDic = [dic objectForKey:@"Sync"];
    if ([[syncDic objectForKey:@"ServerID"] isEqual:@"Favorites Bar"]) {
        return YES;
    }
    return NO;
}

- (BOOL)isMenuDic:(NSDictionary*)dic {
    NSString* name = [dic objectForKey:@"Title"];
    if ([name isEqual:@"BookmarksMenu"]) {
        return YES;
    }
    NSDictionary* syncDic = [dic objectForKey:@"Sync"];
    /* See comment in -isBarDic.  Similar situation here. */
    if ([[syncDic objectForKey:@"ServerID"] isEqual:@"Bookmarks Menu"]) {
        return YES;
    }
    return NO;
}

- (void)recursivelyGetExids:(NSMutableSet*)exids
                    nodeDic:(NSDictionary*)node
                      depth:(NSInteger)depth {
    NSString* exid = nil;
    if (depth > 1) {
        exid = [node objectForKey:@"WebBookmarkUUID"];
    } else if (depth == 1) {
        // This is a child of root.  Do not count hartainers or proxies
        NSString* name = [node objectForKey:@"Title"];
        if(
           ![self isBarDic:node]
           && ![self isMenuDic:node]
           && ![name isEqualToString:@"com.apple.ReadingList"]
           // && ![name isEqualToString:@"Tab Group Bookmarks"]
           /* Oddly, Tab Group Bookmarks does not appear in Bookmarks.plist for
            some reason, so do not test for it in case some user names a soft
            folder "Tab Group Bookmarks" */
           && ![[node objectForKey:@"WebBookmarkType"] isEqualToString:@"WebBookmarkTypeProxy"]  // History
           ) {
            exid = [node objectForKey:@"WebBookmarkUUID"];
        }
    } else {
        /* depth == 0.  Ignore root because Safari Private Framework always
         conjures up and assigns to it a new UUID on every load. */
    }

    if (exid) {
        [exids addObject:exid];
    }

    for (NSDictionary* child in [node objectForKey:@"Children"]) {
        [self recursivelyGetExids:exids
                          nodeDic:child
                            depth:(depth+1)];
    }
}

- (void)recursivelyGetExids:(NSMutableSet*)exids
                     nodeWB:(WebBookmark*)node
                      depth:(NSInteger)depth {
    NSString* exid = nil;
    if (depth > 1) {
        exid = node.UUID;
    } else if (depth == 1) {
        // This is a child of root.  Do not count hartainers or proxies
        if (
            (node != self.bar)
            && ![node.title isEqualToString:@"Tab Group Favorites"]
            && (node != self.menu)
            && (node != self.readingList)
            ) {
                NSString* exid = node.UUID;
                if (exid) {
                    [exids addObject:exid];
                }
            }
    } else {
        /* depth == 0.  Ignore root because Safari Private Framework always
         conjures up and assigns to it a new UUID on every load. */
    }
               
    if (exid) {
        [exids addObject:exid];
    }
    
    if ([node respondsToSelector:@selector(folderAndLeafChildren)]) { // See Note F&LC
        // child has its own children, is therefore a folder, aka "list"
        if ([node numberOfChildren] > 0) {
            for (WebBookmark* child in [(SAFARI_FOLDER_CLASS*)node folderAndLeafChildren]) { // See Note F&LC
                [self recursivelyGetExids:exids
                                   nodeWB:child
                                    depth:depth+1];
            }
        }
    }
}

- (NSMutableSet*)exidsOnDisk {
    NSMutableSet* exids = nil;
    NSDictionary* tree = [self plistOnDisk];
    if (tree) {
        exids = [NSMutableSet new];
        [self recursivelyGetExids:exids
                          nodeDic:tree
                            depth:0];
    }

    return exids;
}

- (NSMutableSet*)exidsInMemory {
    NSMutableSet* exids = nil;
    if (self.root) {
        exids = [NSMutableSet new];
        [self recursivelyGetExids:exids
                           nodeWB:self.root
                            depth:0];
        
    }

    return exids;
}

#define LOAD_MAX_TRIALS 8

- (BOOL)waitForLoadWithReason:(NSString*)reason
                      error_p:(NSError**)error_p {
    NSError* error = nil;
    /* Apparently, the above -load is asynchronous, because a delay of
     100-300 milliseconds is typically needed at this point.  The Safari
     Private Framework has a method -_waitForBookmarkGroupGutsToLoad, and
     related methods, which seem like they would be useful for waiting
     here until load is complete, but I have never been able to get any
     of them to work for me.  So instead I poll until the number of items
     loaded equals the number of items currently in the Bookmarks.plist
     file.

     Until BkmkMgrs 2.9.9, I had just slept here, for an arbitrary 1.0
     seconds.  But now since we load for each depth, and users may have
     many depths, the wasting of 700 - 900 milliseconds per depth is too
     much, and may cause the overall timeout of constSheepSafariHelperTimeoutWrite
     to be exceeded unnecesarily.

     I'm not sure if it is a good idea to invoke self.root, as I do below,
     on a secondary thread.  But if I move the following do{} loop into
     the completion handler of dispatch_sync(dispatch_get_main_queue(), ^}
     below, root never gets any children, and TIMEOUT_PAJARA_LOAD occurs
     every time.  Maybe -[WebBookmarkGroup load], although it returns
     quickly, in fact spins off to a secondary thread that calls back to
     the calling thread (the main thread).
     */
    NSMutableSet* exidsOnDisk = [self exidsOnDisk];
    NSDate* startDate = [NSDate date];
    NSInteger nTrialsWithThisCount = 0;
    NSSet* priorMissingExids = [NSSet new];
    NSSet* priorExtraExids = [NSSet new];
    do {
        usleep(100000);
        /* Get exids of the loaded items from the WebBookmarkGroup (wbg). */
        NSMutableSet* extraExids = [self exidsInMemory];
        NSInteger loadCount = extraExids.count;
        NSTimeInterval elapsed = -[startDate timeIntervalSinceNow];
        /* The exids of the loaded items from the WebBookmarkGroup (wbg),
         here called extraExids since we have not done the minus yet, and
         the exidsOnDisk, although they do include the root, do not include
         the Bar, Menu or Reading List, or the "Tab Group Bookmark".
         The counting methods take great pains to ignore those because
         they may or may not be there in the file vs. the wbg.  For
         example, in a new macOS account, with the default bookmarks
         (Apple, iCloud, Yahoo, Bing, Wikipedia, Facebook, etc.),
         the file will have no Bar, Menu or Reading List, but the wbg
         will have Bar and Menu. */

        NSMutableSet* missingExids = [exidsOnDisk mutableCopy];
        [missingExids minusSet:extraExids];
        [extraExids minusSet:exidsOnDisk];

        [self logIfLevel:2
                  string:[[NSString alloc] initWithFormat:@"%@: %ld missing, %ld extra, %ld disk, %ld load, after %0.3f secs",
                          reason,
                          (long)missingExids.count,
                          (long)extraExids.count,
                          (long)exidsOnDisk.count,
                          (long)loadCount,
                          elapsed]];

        if ((missingExids.count == 0) && (extraExids.count == 0)) {
            [self logIfLevel:1
                      string:[[NSString alloc] initWithFormat:@"SheepSafariHelper succeeded loading in %f secs", elapsed]];
            break;
        } else if (elapsed > constSheepSafariHelperTimeoutPerLoad) {
            [self logIfLevel:1
                      string:[[NSString alloc] initWithFormat:@"SheepSafariHelper failed loading, exceeded %f secs", constSheepSafariHelperTimeoutPerLoad]];
            error = [NSError errorWithDomain:SheepSafariHelperErrorDomain
                                        code:772012
                                    userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                              [[NSString alloc] initWithFormat:@"%@ loading timeout", reason], NSLocalizedDescriptionKey,
                                              @2, constKeyRetrialsRecommended,
                                              nil]];
        } else if (([missingExids isEqualToSet:priorMissingExids]) && ([extraExids isEqualToSet:priorExtraExids])) {
            if (nTrialsWithThisCount < LOAD_MAX_TRIALS) {
                nTrialsWithThisCount++;
            } else {
                if (missingExids.count > 0) {
                    [self logIfLevel:1
                              string:[[NSString alloc] initWithFormat:
                                      @"Giving up load with missing exids: %@", missingExids]];
                }
                if (extraExids.count > 0) {
                    [self logIfLevel:1
                              string:[[NSString alloc] initWithFormat:
                                      @"Giving up load with extra exids: %@", extraExids]];
                }
                NSString* story = [[NSString alloc] initWithFormat:
                                       @"Giving up load after %ld trials with %ld missing, %ld extra",
                                   (long)LOAD_MAX_TRIALS,
                                   (long)missingExids.count,
                                   (long)extraExids.count
                ];
#define ACCEPT_INCOMPLETE_LOADS 1
#if ACCEPT_INCOMPLETE_LOADS
                [self reportIssue:story];
#else
                // Starting with BkmkMgrs 2.12.5
                error = [NSError errorWithDomain:SheepSafariHelperErrorDomain
                                            code:772014
                                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                  story, NSLocalizedDescriptionKey,
                                                  @0, constKeyRetrialsRecommended,
                                                  nil]];

#endif
                break;
            }
        } else {
            nTrialsWithThisCount = 1;
            priorMissingExids = [missingExids copy];
            priorExtraExids = [extraExids copy];
        }
    } while (error == nil);

    if (error && error_p) {
        *error_p = error ;
    }

    return (error == nil);
}

- (void)doChanges:(NSDictionary*)changes
            depth:(NSInteger)depth // for debugging
           finale:(void (^)(NSString* assignedVsProposedExids, NSDictionary* returnResults, NSError* error))finale {
    NSNumber* depthKey = @(depth);
    NSInteger thisTrial = ((NSNumber*)[self.trialsByDepth objectForKey:depthKey]).integerValue + 1;
    [self logIfLevel:3
              string:[[NSString alloc] initWithFormat:@"Begin depth %ld trial %ld", (long)depth, (long)thisTrial]];
    [self.trialsByDepth setObject:@(thisTrial)
                           forKey:depthKey];

    [self clear];
    [self load];
    dispatch_async(self.serialQueue, ^{
        NSError* __block error = nil;
        [self waitForLoadWithReason:[[NSString alloc] initWithFormat:@"Writing depth %ld", (long)depth]
                            error_p:&error];
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSArray* rootChildren = ((SAFARI_FOLDER_CLASS*)(self.root)).folderAndLeafChildren;
            if (self.safariProxyIndexesInWBG == nil) {
                NSMutableIndexSet* indexSet = [NSMutableIndexSet new];
                NSInteger i = 0;
                for (WebBookmark* item in rootChildren) {
                    if ([item.title isEqualToString:@"Tab Group Favorites"]) {
                        [indexSet addIndex:i];
                    }
                    i++;
                }
                self.safariProxyIndexesInWBG = [indexSet copy];
            }
            
            if (!error) {
                [self fixAssignedVsProposedExidsFromDiskDepth:depth
                                                      error_p:&error];
                if (error) {
                    error = [NSError errorWithDomain:SheepSafariHelperErrorDomain
                                                code:772013
                                            userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      @2, constKeyRetrialsRecommended,
                                                      [[NSString alloc] initWithFormat:@"Error fixing exids for depth %ld", (long)depth] , NSLocalizedDescriptionKey,
                                                      error, NSUnderlyingErrorKey,
                                                      nil]];
                }
            }

            if (!error) {
                for (NSDictionary* aCut in [changes objectForKey:constKeyCuts]) {
                    [self doCut:aCut
                        error_p:&error];
                    //reportProgress(1, 3, nDone, total);
                    if (error) {
                        break;
                    }
                }
            }

            BOOL anyPutsDone = NO;
            NSArray* deeperPuts = nil;
            if (!error) {
                [self.returnResults setObject:@(self.limboInsertionsCount)
                                       forKey:constKeySheepSafariHelperResultLimboInsertionsCount];
                [self.returnResults setObject:@(self.limboRemovalsCount)
                                       forKey:constKeySheepSafariHelperResultLimboRemovalsCount];

                NSInteger currentDepth = -1;
                NSArray* allPuts = [changes objectForKey:constKeyPuts];
                NSInteger i = 0;
                for (NSDictionary* aPut in allPuts) {
                    NSInteger depthOfThisChange = [[aPut objectForKey:constKeyDepth] integerValue];
                    if (currentDepth == -1) {
                        currentDepth = depthOfThisChange;
                    }

                    if (depthOfThisChange == currentDepth) {
                        [self doPut:aPut
                            error_p:&error];
                        anyPutsDone = YES;
                    } else {
                        deeperPuts = [allPuts subarrayWithRange:NSMakeRange(i, allPuts.count - i)];
                        break;
                    }

                    i++;

                    //reportProgress(2, 3, nDone, total);
#if 0
#warning Testing with fake error creating new items
                    /* Because operations at a given depth are aborted
                     immediately upon error, this test will create an error
                     only for the first put of each level. */
                    if (thisTrial < 2) {
                        error = [NSError errorWithDomain:SheepSafariHelperErrorDomain
                                                    code:773030
                                                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          @"Fake Could not create a new item", NSLocalizedDescriptionKey,
                                                          @4, constKeyRetrialsRecommended,
                                                          aPut, @"Change Dic",
                                                          nil]
                                 ];
                        NSString* exidToWipe = [aPut objectForKey:constKeyExid];
                        [self.indexPathsForProposedExids removeObjectForKey:exidToWipe];
                    }
#endif
                    if (error) {
                        break;
                    }
                }
            }

            if (!error) {
                [self save];
            }

#if 0
#warning NOT RETRYING, for more stressful testing of -[SheepSafariHelper doChanges:]
            NSLog(@"NOT RETRYING *** FOR TESTING");
            retrialsRecommended = 0;
#else
            NSInteger retrialsRecommended = ((NSNumber*)[error.userInfo objectForKey:constKeyRetrialsRecommended]).integerValue;
#endif
            if (retrialsRecommended >= thisTrial) {
                /* Error occurred but retries are recommended.  Call this
                 method again (recurs) with same changes, same depth.
                 This is OK because nothing was saved yet. */
                [self reportIssue:[[NSString alloc] initWithFormat:
                                   @"Retry[M] due to %@",
                                   [error oneLineDescription]]];
                [self doChanges:changes
                          depth:depth
                         finale:finale];
            } else {
                /* Either no error, or recommended retries exhausted */
                error = [error errorByRemovingRetrialRecommendation];
                BOOL isLastDepth = YES;
                if (!error) {
                    if (anyPutsDone) {
                        if (deeperPuts) {
                            NSMutableDictionary* changesForNextDepth = [[NSMutableDictionary alloc] init];
                            [changesForNextDepth setObject:deeperPuts
                                                    forKey:constKeyPuts];
                            NSArray* repairs = [changes objectForKey:constKeyRepairs];
                            if (repairs) {
                                [changesForNextDepth setObject:repairs
                                                        forKey:constKeyRepairs];
                            }
                            /* Normal recursion.  Call this method again with
                             the next depth. */
                            [self doChanges:changesForNextDepth
                                      depth:(depth + 1)
                                     finale:finale];
                            isLastDepth = NO;
                        }
                    }
                }

                if (isLastDepth) {
                    for (NSDictionary* aRepair in [changes objectForKey:constKeyRepairs]) {
                        [self doRepair:aRepair
                               error_p:&error];
                        //reportProgress(3, 3, nDone, total);
                        if (error) {
                            break;
                        }
                    }

                    if (!error) {
                        [self save];
                    }

                    NSInteger retrialsRecommended = ((NSNumber*)[error.userInfo objectForKey:constKeyRetrialsRecommended]).integerValue;
                    if (retrialsRecommended >= thisTrial) {
                        /* Error occurred but retries are recommended.  Retry same
                         changes, same depth.  This is OK because nothing was saved. */
                        [self reportIssue:[[NSString alloc] initWithFormat:
                                           @"Retry[F] due to %@",
                                           [error oneLineDescription]]];
                        [self doChanges:changes
                                  depth:depth
                                 finale:finale];
                    } else {
                        /* Either no error, or recommended retries exhausted */
                        error = [error errorByRemovingRetrialRecommendation];

                        if (!error) {
                            [self fixAssignedVsProposedExidsFromDiskDepth:depth
                                                                  error_p:&error];
                            if (error) {
                                error = [NSError errorWithDomain:SheepSafariHelperErrorDomain
                                                            code:772015
                                                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  @2, constKeyRetrialsRecommended,
                                                                  [[NSString alloc] initWithFormat:@"Error fixing exids for depth %ld", (long)depth] , NSLocalizedDescriptionKey,
                                                                  error, NSUnderlyingErrorKey,
                                                                  nil]];
                            }
                        }

                        [self.returnResults setObject:[NSNumber numberWithInteger:self.limbo.count]
                                               forKey:constKeySheepSafariHelperResultLimboOrphanCount];

                        NSArray* depths = [[self.trialsByDepth allKeys] sortedArrayUsingSelector:@selector(compare:)];
                        NSMutableString* trialsByDepthReport = [[NSMutableString alloc] init];
                        for (NSNumber* depth in depths) {
                            [trialsByDepthReport appendFormat:
                             @"%@:%@ ",
                             depth,
                             [self.trialsByDepth objectForKey:depth]];
                        }
                        [self.returnResults setObject:[trialsByDepthReport copy]
                                               forKey:constKeySheepSafariHelperTrialsByDepthReport];

                        NSString* jsonExidString = nil;
                        if (!error) {
                            if (self.limbo.count > 0) {
                                /* Note Limboites
                                 There should not be any items left in limbo, because
                                 when we generate and send a change to delete a folder
                                 in BkmkMgrs, we also generate and send a change to
                                 delete each one of its descendants. */

                                /* Now we do what we should not need to do… */
                                NSMutableSet* limboites = [NSMutableSet new];
                                NSInteger disappearedCount = 0;
                                for (NSString* limboiteId in self.limbo) {
                                    WebBookmark* item = [self itemForUuid:limboiteId
                                                                   caller:4];
                                    if (item) {
                                        [limboites addObject:item];
                                    } else {
                                        disappearedCount++;
                                    }
                                }
                                [self.returnResults setObject:[NSNumber numberWithInteger:disappearedCount]
                                                       forKey:constKeySheepSafariHelperResultLimboOrphanDisappearedCount];

                                if (limboites.count > 0) {
                                    /* Once, the following method crashed with this:
                                     -[__NSSetM safari_arrayByRemovingRedundantDescendantBookmarks]: unrecognized selector sent to instance
                                     when limboites was empty.  That was due to bug,
                                     which will be fixed before I ship, but I figured
                                     why risk a crash when you've got nothing to do.
                                     Hence, the above if().  Maybe I should eliminate
                                     this altogether? */
                                    [self logIfLevel:5
                                              string:[[NSString alloc] initWithFormat:@"Will remove %ld limboites", limboites.count]];
                                    [self.buc removeBookmarks:limboites];
                                    [self logIfLevel:5
                                              string:@"Did remove limboites"];
                                }
                            }
                        }
                        
                        
                        if (self.logVerbosity >= 5) {
                            NSURL* sourceUrl = [BookmarksController defaultBookmarksFileURL];
                            NSURL* destinUrl = [sourceUrl URLByDeletingLastPathComponent];
                            NSString* filename = [NSString stringWithFormat:@"Bookmarks-PostExportPreFix-%@.plist", [SheepSafariHelper niceDateTimeString]];
                            destinUrl = [destinUrl URLByAppendingPathComponent:filename];
                            [[NSFileManager defaultManager] copyItemAtURL:sourceUrl
                                                                    toURL:destinUrl
                                                                    error:&error];
                        }

                        [self postFixBookmarksFile];
                        
                        if (self.logVerbosity >= 5) {
                            NSURL* sourceUrl = [BookmarksController defaultBookmarksFileURL];
                            NSURL* destinUrl = [sourceUrl URLByDeletingLastPathComponent];
                            NSString* filename = [NSString stringWithFormat:@"Bookmarks-PostExportPostFix-%@.plist", [SheepSafariHelper niceDateTimeString]];
                            destinUrl = [destinUrl URLByAppendingPathComponent:filename];
                            [[NSFileManager defaultManager] copyItemAtURL:sourceUrl
                                                                    toURL:destinUrl
                                                                    error:&error];
                        }

                        [self relinquishLockFileExpectantly:YES];

                        /* For one day, doing maybe 9 export tests, running
                         macOS 10.14.4 beta 2, I had the following line commented out,
                         with Safari iCloud active, to see what would happen.

                         On maybe the 10th export, there was a problem.  Changes did
                         not appear on the iPad after 30 minutes, even after repeated
                         reboots of iPad Safari.  So I added a bookmark on the iPad.
                         This new bookmark appeared on the Mac, and a few seconds
                         later, the missing changes from the Mac appeared on the iPad.

                         So I thought everything was OK.  But then I made more changes
                         on the, deleting all items and adding new items.  But, whoa,
                         all of the deleted items reappeared, so now the Mac had the
                         new items and the deleted items, and in an even more telling
                         sign of iCloud On the Fritz, deleted items which had been in
                         the Favorites/Bar appeared instead at root.

                         So I think the following is really neessary to avoid iCloud
                         On The Fritz. */
                        [self requestSync];

                        NSData* jsonData = nil;
                        if (!error) {
                            /* We could send assignedVsProposedExids as is, a dictionary.
                             But our Chromy extension sends it as a JSON string.
                             BkmkMgrs app will in fact need both representations, so
                             unless we send both we're going to need to do at least one
                             conversion on the other end anyhow.  Conclusion: for nicer
                             symmetry, we convert it to a JSON here, before sending. */
                            jsonData = [NSJSONSerialization dataWithJSONObject:self.assignedVsProposedExids
                                                                       options:NSJSONWritingPrettyPrinted
                                                                         error:&error] ;
                        }

                        if (!error) {
                            jsonExidString = [[NSString alloc] initWithData:jsonData
                                                                   encoding:NSUTF8StringEncoding] ;
                            if (!jsonExidString) {
                                error = [NSError errorWithDomain:SheepSafariHelperErrorDomain
                                                            code:772260
                                                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  @1, constKeyRetrialsRecommended,
                                                                  @"Could not encode JSON exid data to string", NSLocalizedDescriptionKey,
                                                                  jsonData, @"JSON Data",  // could be nil?
                                                                  nil]
                                         ];
                            }
                        }

                        if (finale) {
                            [self logIfLevel:1
                                      string:[NSString stringWithFormat:@"SheepSafariHelper calling back: Finale"]];
                            finale(
                                   jsonExidString,
                                   self.returnResults,
                                   error);
                        }

                        [self logIfLevel:1
                                  string:[[NSString alloc] initWithFormat:
                                          @"Export done, %d exitting with error %ld",
                                          getpid(),
                                          (long)error.code]];

                        [self cleanUpAndExitProcess];
                    }
                }
            }
        });
    });
}

/* The Export Processing Methods function the same as the corresponding methods
 in script.js of BookMacster Sync Extension, except those are asynchronous
 JavaScript and these are synchronous Objective C.  I wrote these methods by
 pasting in the JavaScript and editing, then removing the asynchronous code
 flow.  The latter was necessary because, after changing to Objective-C, I
 had the methods which did the changes calling themselves recursively for
 each change, and of course this would cause the stack to blow for hundreds
 of changes. */

- (void)processChanges:(NSDictionary*)changes
     completionHandler:(void (^)(NSString* assignedVsProposedExids, NSDictionary* returnResults, NSError* error))completionHandler {
    [self logIfLevel:4
              string:[[NSString alloc] initWithFormat:
                      @"Processing changes: %@",
                      changes]];
    NSError* error = nil;

#if 0
#warning Faking SheepSafariHelper error at start of -processChanges::
    [self logIfLevel:0
              string:@"Returning fake error!"];
    error = [NSError errorWithDomain:SheepSafariHelperErrorDomain
                                code:772777
                            userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                      @2, constKeyRetrialsRecommended,
                                      @"Fake Error", NSLocalizedDescriptionKey,
                                      nil]
             ];
    completionHandler(nil, self.returnResults, error);
    [self cleanUpAneExitProcess];
#endif

    if (!error) {
        [self doChanges:changes
                  depth:0
                 finale:completionHandler];
    }
}

- (BOOL)doCut:(NSDictionary*)changeDic
      error_p:(NSError**)error_p {
    BOOL ok = YES;
    NSError* error = nil;
    // Get the item which has the given exid
    WebBookmark* deletee = [self itemForUuid:[changeDic objectForKey:constKeyExid]
                                      caller:3];
    if (!deletee) {
        ok = NO;
        error = [NSError errorWithDomain:SheepSafariHelperErrorDomain
                                    code:772020
                                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                           @"Could not find a deletee", NSLocalizedDescriptionKey,
                                          @3, constKeyRetrialsRecommended,
                                           [changeDic objectForKey:constKeyExid], constKeyExid,  // could be nil?
                                          nil]
                                          ];
    }

    if (ok) {
        if ([deletee respondsToSelector:@selector(folderAndLeafChildren)]) { // See Note F&LC
            /* `deletee` is a folder.  We don't want to delete its contents yet,
             because some descendants may have been moved to other folders.
             Instead, we move all of its children into Bookmarks Bar, and also
             add these children's exids into Limbo.  If a child is later moved,
             we'll remove it from Limbo.  Finally, during last depth, we shall
             delete any children which are still in Limbo, which actually there
             shouldn't be.  See Note Limboites. */
            for (WebBookmark* child in [(SAFARI_FOLDER_CLASS*)deletee folderAndLeafChildren]) { // See Note F&LC
                [self.stash setObject:child
                               forKey:child.UUID];
                /* Get the UUID now due to Note: MovingItemRuinsItsUuid. */
                [self.limbo addObject:child.UUID];
                self.limboInsertionsCount = self.limboInsertionsCount + 1;
                ok = [self moveToParent:self.bar
                                  index:[self.bar numberOfChildren]  // Passing NSNotFound here will fail silently ;)
                               bookmark:child];
                if (!ok) {
                    error = [NSError errorWithDomain:SheepSafariHelperErrorDomain
                                                code:772022
                                            userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      @"SPF failed moving item into limbo", NSLocalizedDescriptionKey,
                                                      @1, constKeyRetrialsRecommended,
                                                      [changeDic objectForKey:constKeyExid], constKeyExid,  // could be nil?
                                                      nil]
                             ];
                    ok = NO;
                }
            }
        }

        [self deleteItem:deletee];
    }

    if (error && error_p) {
        *error_p = error ;
    }

    return ok;
}

- (BOOL)doPut:(NSDictionary*)changeDic
      error_p:(NSError**)error_p {
    BOOL ok = YES;
    NSError* error = nil;

    /* Use the parent's new exid instead of the one assigned by BookMacster.
     (This is why, in the Bkmx app, we sorted insertions by increasing
     depth.  Otherwise, this would not work.) */
    NSString* parentExid;
    NSString* parentProposedExid = [changeDic objectForKey:constKeyParentExid];
    NSInteger index = [[changeDic objectForKey:constKeyIndex] integerValue];
    if (parentProposedExid) {
        // Proposed parent is not root
        NSString* parentAssignedExid = [self.assignedVsProposedExids objectForKey:parentProposedExid];
        if (parentAssignedExid) {
            // Parent is itself a new item
            parentExid = parentAssignedExid;
        }
        else if ([parentProposedExid isEqualToString:SheepSafariHelperBarSpecialExid]){
            parentExid = self.bar.UUID;
        }
        else if ([parentProposedExid isEqualToString:SheepSafariHelperMenuSpecialExid]){
            parentExid = self.menu.UUID;
        }
        else if ([parentProposedExid isEqualToString:SheepSafariHelperTabGroupFavoritesSpecialExid]){
            NSLog(@"Parent is Tab Group Favorites - SHOULD NEVER HAPPEN");
            error = [NSError errorWithDomain:SheepSafariHelperErrorDomain
                                        code:772051
                                    userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                              @"Attempted add child to Tab Group Favorites", NSLocalizedDescriptionKey,
                                              @0, constKeyRetrialsRecommended,
                                              changeDic, @"Change Dic",
                                              nil]];
        } else {
            // Parent is an existing item
            parentExid = parentProposedExid;
        }
    } else {
        // Proposed parent must have been root (Comment 171027)
        parentExid = self.root.UUID;
        index += self.indexOfFirstSoftItemInRoot;
    }

    if ([[changeDic objectForKey:constKeyIsNew] boolValue] == YES) {
        /* Insert a new item */

        SAFARI_FOLDER_CLASS* parentOfNewItem = [self itemForUuid:parentExid
                                                 caller:5];
        NSString* proposedExid = [changeDic objectForKey:constKeyExid];

        WebBookmark* newItem = nil;

        if (parentOfNewItem) {
            NSString* type = [changeDic objectForKey:constKeyType];
            NSString* name = [changeDic objectForKey:constKeyName];
            NSString* url = [changeDic objectForKey:constKeyUrl];
            NSString* comments = [changeDic objectForKey:constKeyComments];

            if (
                [type isEqualToString:BkmxConstTypeBookmark]
                || [type isEqualToString:BkmxConstTypeSeparator]
                || [type isEqualToString:BkmxConstTypeLivemark]
                ) {
                    if ([type isEqualToString:BkmxConstTypeSeparator]) {
                        name = (parentOfNewItem == self.bar)
                        ? constSeparatorLineForSafariVertical
                        : constSeparatorLineForSafariHorizontal;
                    }
                    
                    if (!url) {
                        if ([type isEqualToString:BkmxConstTypeLivemark]) {
                            url = [changeDic objectForKey:BkmxConstTypeFeedUrl];
                        }
                    }
                    
                    newItem = [self newBookmarkWithParent:parentOfNewItem
                                                    index:index
                                                     name:name
                                                      url:url
                                                 comments:comments];
                    
                } else if ([type isEqualToString:BkmxConstTypeFolder]) {
                    newItem = [self newFolderWithParent:parentOfNewItem
                                                  index:index
                                                   name:name];
                    if (newItem) {
                        /* This is only used for during the processing of deeper
                         changes during the current export operation.  But it is
                         needed for that!
                         Comment 2022-06-11.  I don't even think it is used for
                         that any more, since we run -fixAssignedVsProposedExidsFromDiskDepth::
                         after every depth.  I think we could eliminate this
                         if-branch. */
                        [self.assignedVsProposedExids setObject:newItem.UUID
                                                         forKey:proposedExid];
                    }
                } else {
                    /* This is very rare, but happpens, for example if
                     exporting with a non-empty Reading List after the
                     Bookmarks plist file has been deleted on disk, then
                     launching Safari.  Safari will create a new Bookmarks.plist
                     file which has only the Bar and Menu hard folders, no
                     Reading List.  So the main app will add a Reading List
                     as its first 'put'.  */
                    [self logIfLevel:1
                              string:[[NSString alloc] initWithFormat:
                                      @"Rare! Adding new hartainer of type %ld",
                                      (long)type]];
                    newItem = [self newHartainerOfType:type];
                }
        } else {
            ok = NO;
            error = [NSError errorWithDomain:SheepSafariHelperErrorDomain
                                        code:772029
                                    userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                              @"Could not find parent of new item", NSLocalizedDescriptionKey,
                                              @4, constKeyRetrialsRecommended,
                                              changeDic, @"Change Dic",
                                              parentExid ? parentExid : @"nilly" , @"Parent actual exid",
                                              nil]
            ];
        }
        
        if (ok) {
            if (newItem) {
                /* We would like to write the UUID of the new item directly
                 into the self.assignedVsProposedExids dictionary.
                 Unfortunately, apparently just before
                 Bookmarks.plist is written to the disk, by
                 -[WebBookmarkGroup save] those UUID are overwritten and replaced
                 with different UUID.  See Note 20171031NB.  Therefore, we
                 populate indexPathsForProposedExids instead.  We shall use this
                 later to get the uuid from the Bookmarks.plist file.  */
                SAFARI_FOLDER_CLASS* thisParent = parentOfNewItem;
                WebBookmark* thisItem = newItem;
                NSIndexPath* indexPath = [NSIndexPath new];
                while (thisParent != nil) {
                    NSInteger thisIndex;
                    if (thisItem == newItem) {
                        thisIndex = index;
                    } else {
                        thisIndex = [thisParent indexOfChild:thisItem];
                        if (thisIndex == NSNotFound) {
                            thisIndex = [[thisParent folderAndLeafChildren] indexOfObject:thisItem];
                        }
                    }
                    indexPath = [indexPath indexPathByAddingIndex:thisIndex];
                    
                    thisItem = thisParent;
                    thisParent = [thisParent parent];
                }
                
                [self.indexPathsForProposedExids setObject:indexPath
                                                    forKey:proposedExid];
            } else {
                ok = NO;
                error = [NSError errorWithDomain:SheepSafariHelperErrorDomain
                                            code:772030
                                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                  @"Could not create a new item", NSLocalizedDescriptionKey,
                                                  @4, constKeyRetrialsRecommended,
                                                  changeDic, @"Change Dic",
                                                  parentExid ? parentExid : @"nilly" , @"Parent actual exid",
                                                  nil]
                ];
            }
        }
    } else {
        // Move or slide a existing item
        
        WebBookmark* existingItem = [self itemForUuid:[changeDic objectForKey:constKeyExid]
                                               caller:6];
        if (!existingItem) {
            error = [NSError errorWithDomain:SheepSafariHelperErrorDomain
                                        code:772031
                                    userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                              @"Could not find a movee", NSLocalizedDescriptionKey,
                                              @4, constKeyRetrialsRecommended,
                                              changeDic, @"Change Dic",
                                              nil]
            ];
            ok = NO;
        }
        SAFARI_FOLDER_CLASS* newParent = nil;
        if (ok) {
            newParent = [self itemForUuid:parentExid
                                   caller:7];
            if (!newParent) {
                error = [NSError errorWithDomain:SheepSafariHelperErrorDomain
                                            code:772032
                                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                  @"Could not find a movee's new parent", NSLocalizedDescriptionKey,
                                                  @4, constKeyRetrialsRecommended,
                                                  changeDic, @"Change Dic",
                                                  nil]
                ];
                ok = NO;
            }
        }
        
        /* Get the UUID now due to Note: MovingItemRuinsItsUuid. */
        NSString* movedItemExid = existingItem.UUID;
        if (ok) {
            [self.stash setObject:existingItem
                           forKey:existingItem.UUID];
            ok = [self moveToParent:newParent
                              index:index
                           bookmark:existingItem];
        }
        
        if (ok) {
            /* This object has a new parent and therefore no longer belongs
             in limbo any more. */
            NSInteger index = [self.limbo indexOfObject:movedItemExid];
            if (index != NSNotFound) {
                [self.limbo removeObjectAtIndex:index];
                self.limboRemovalsCount = self.limboRemovalsCount + 1;
            }
        }
    }
    
    if (error && error_p) {
        *error_p = error ;
    }
    
    return ok;
}

- (BOOL)doRepair:(NSDictionary*)changeDic
         error_p:(NSError**)error_p {
    NSError* error = nil;
    WebBookmark* existingItem = [self itemForUuid:[changeDic objectForKey:constKeyExid]
                                           caller:2];
    if (!existingItem) {
        error = [NSError errorWithDomain:SheepSafariHelperErrorDomain
                                    code:772040
                                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                          @"Could not find a repairee", NSLocalizedDescriptionKey,
                                          @3, constKeyRetrialsRecommended,
                                          changeDic, @"Change Dic",
                                          nil]
                 ];
    }

    NSString* value;
    value = [changeDic objectForKey:constKeyName];
    if (value) {
        [self setName:value
             bookmark:existingItem];
    }
    value = [changeDic objectForKey:constKeyUrl];
    if (value) {
        [self setUrl:value
            bookmark:existingItem];
    }
    value = [changeDic objectForKey:constKeyComments];
    if (value) {
        [self setComments:value
                 bookmark:existingItem];
    }

    if (error && error_p) {
        *error_p = error ;
    }

    return (error == nil);
}

- (void)reportIssue:(NSString*)issue {
    [self logIfLevel:1
              string:[[NSString alloc] initWithFormat:
                      @"Issue: %@",
                      issue]];
    self.lastIssueIndex = self.lastIssueIndex + 1;
    /* A couple dozen issues will be enough to troubleshoot :|  */
    if (self.lastIssueIndex < 25) {
        NSMutableArray* issues = [self.returnResults objectForKey:constKeySheepSafariHelperResultIssues];
        if (!issues) {
            issues = [NSMutableArray new];
            [self.returnResults setObject:issues
                                   forKey:constKeySheepSafariHelperResultIssues];
        }

        [issues addObject:issue];
    }
}

- (NSDictionary*)recursivelyBuildTreeByAppendingChild:(WebBookmark*)child
                                             toParent:(NSMutableDictionary*)parent
                                                level:(NSInteger)level {
    NSMutableDictionary* childDic = [NSMutableDictionary new];
    NSString* string;
    if (child == self.bar) {
        string = SheepSafariHelperBarSpecialExid;
    } else if (child == self.menu) {
        string = SheepSafariHelperMenuSpecialExid;
    } else if ([child.title isEqualToString:@"Tab Group Favorites"]) {
        /* We ignore the Tab Group Favorites, treating it as a
        WebBookmarkTypeProxy, although unlike History, the other
        WebBookmarkTypeProxy, it appears in the WebBookmarks. */
        return nil;
    } else {
        string = child.UUID;
    }
    if (string) {
        [childDic setObject:string
                     forKey:@"WebBookmarkUUID"];
    } else {
        [self reportIssue:[[NSString alloc] initWithFormat:
                           @"No UUID for child %@",
                           child]];
    }
    NSMutableString* indentation = nil;
    if (self.logVerbosity >= 5) {
        indentation = [NSMutableString new];
        NSString* baseIndentation = @"  ";
        for (NSInteger i=0; i<level; i++) {
            [indentation appendString:baseIndentation];
        }
    }
    if ([child respondsToSelector:@selector(folderAndLeafChildren)]) { // See Note F&LC
        if (self.logVerbosity >= 5) {
            NSString* msg;
            msg = [[NSString alloc] initWithFormat:@"%@Building NODE item:", indentation];
            [[self class] logString:msg];
            msg = [[NSString alloc] initWithFormat:@"%@  %@", indentation, [childDic objectForKey:@"WebBookmarkUUID"]];
            [[self class] logString:msg];
        }
        // child has its own children, is therefore a folder, aka "list"
        [childDic setObject:@"WebBookmarkTypeList"
                     forKey:@"WebBookmarkType"];
        string = child.title;
        if (string) {
            [childDic setObject:string
                         forKey:@"Title"];
        } else {
            [self reportIssue:[[NSString alloc] initWithFormat:
                               @"No title for assumed folder %@ %@ %@",
                               child.className,
                               ([child respondsToSelector:@selector(title)] ? child.title : @"Title???"),
                               ([child respondsToSelector:@selector(UUID)] ? child.UUID : @"UUID???")
                               ]];
        }
        if (self.logVerbosity >= 5) {
            NSString* msg;
            msg = [[NSString alloc] initWithFormat:@"%@  %@", indentation, [childDic objectForKey:@"Title"]];
            [[self class] logString:msg];
            msg = [[NSString alloc] initWithFormat:@"%@  %ld children", indentation, (long)[child numberOfChildren]];
            [[self class] logString:msg];
        }
        if ([child numberOfChildren] > 0) {
            [childDic setObject:[NSMutableArray new]
                         forKey:@"Children"];
            NSInteger nextLevel = level + 1;
            for (WebBookmark* grandchild in [(SAFARI_FOLDER_CLASS*)child folderAndLeafChildren]) { // See Note F&LC
                [self recursivelyBuildTreeByAppendingChild:grandchild
                                                  toParent:childDic
                                                     level:nextLevel];
            }
        }
    } else {
        // child is a bookmark, aka "leaf"
        if (self.logVerbosity >= 5) {
            NSString* msg;
            msg = [[NSString alloc] initWithFormat:@"%@Building LEAF item:", indentation];
            [[self class] logString:msg];
            msg = [[NSString alloc] initWithFormat:@"%@  %@", indentation, [childDic objectForKey:@"WebBookmarkUUID"]];
            [[self class] logString:msg];
        }
        [childDic setObject:@"WebBookmarkTypeLeaf"
                     forKey:@"WebBookmarkType"];
        string = ((WebBookmarkLeaf*)child).URLString;
        if (self.logVerbosity >= 5) {
            NSString* msg;
            msg = [[NSString alloc] initWithFormat:@"%@  %@", indentation, string];
            [[self class] logString:msg];
        }
        if (string) {
            [childDic setObject:string
                         forKey:@"URLString"];
        } else {
            [self reportIssue:[[NSString alloc] initWithFormat:
                               @"No URL for assumed leaf child %@",
                               child]];
        }

        string = child.title;
        if (self.logVerbosity >= 5) {
            NSString* msg;
            msg = [[NSString alloc] initWithFormat:@"%@  %@", indentation, string];
            [[self class] logString:msg];
        }
        if (string) {
            [childDic setObject:@{@"title": string}
                         forKey:@"URIDictionary"];
        } else {
            [self reportIssue:[[NSString alloc] initWithFormat:
                               @"No title for assumed leaf child %@",
                               child]];
        }
    }

    [[parent objectForKey:@"Children"] addObject:childDic];

    return childDic;
}

- (NSError*)bookmarksBusyError {
    NSString* msg = @"Safari bookmarks are being synchronized by another process, probably Apple's iCloud.  We must not touch them now.";
    return [NSError errorWithDomain:SheepSafariHelperErrorDomain
                                code:772053
                            userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                      @3, constKeyRetrialsRecommended,
                                      msg, NSLocalizedDescriptionKey,
                                      @"Wait a few minutes and try again.", NSLocalizedRecoverySuggestionErrorKey,
                                      nil]
             ];
}

- (NSError*)possibleErrorDueToDupesAtRoot {
    NSError* error = nil;
    NSData* data = [NSData dataWithContentsOfFile:[self wbg].filePath
                                          options:0
                                            error:&error] ;
    NSDictionary* root = nil;
    if (data && !error) {
        root = [NSPropertyListSerialization propertyListWithData:data
                                                         options:NSPropertyListImmutable
                                                          format:NULL
                                                           error:&error] ;
    }

    if (root && !error) {
        if ([root respondsToSelector:@selector(valueForKey:)]) {
            NSArray* children = [root valueForKey:@"Children"];
            if (children) {
                error = [SafariDupeAtRootChecker errorFromRootSafariDics:children];
            }
        }
    }
    
    return error;
}

#pragma mark XPC Handlers

- (void)importForKlientAppDescription:(NSString*)customerDescription
                    completionHandler:(void (^)(NSDictionary* tree, NSDictionary* results, NSError* error))completionHandler {
    [self logIfLevel:1
              string:[[NSString alloc] initWithFormat:
                      @"Received Import command from %@",
                      customerDescription]];

    @synchronized (self) {
        if (static_sheepSafariHelperBusiness) {
            [self logIfLevel:1
                      string:@"Busy - Returning error"];
            NSError* error = [NSError errorWithDomain:SheepSafariHelperErrorDomain
                                                 code:772042
                                             userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       @10, constKeyRetrialsRecommended,
                                                       static_sheepSafariHelperBusiness, NSLocalizedDescriptionKey,
                                                       nil]];
            completionHandler(nil, nil, error);
            [self cleanUpAndExitProcess];
        } else {
            static_sheepSafariHelperBusiness = [[NSString alloc] initWithFormat:
                                     @"SheepSafariHelper pid %d is already importing for %@",
                                     getpid(),
                                     customerDescription];

            dispatch_queue_t timeoutWatchdog = dispatch_queue_create(
                                                                     "Load Bookmarks Timeout Watchdog",
                                                                     DISPATCH_QUEUE_SERIAL
                                                                     ) ;

            dispatch_async(timeoutWatchdog, ^{
                [NSThread sleepForTimeInterval:constSheepSafariHelperTimeoutRead];
                NSError* error = [NSError errorWithDomain:SheepSafariHelperErrorDomain
                                                     code:772041
                                                 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           @3, constKeyRetrialsRecommended,
                                                           @"System timed out getting Safari bookmarks", NSLocalizedDescriptionKey,
                                                           [NSNumber numberWithDouble:constSheepSafariHelperTimeoutRead], @"Timeout Secs",
                                                           nil]
                                  ];
                completionHandler(nil, self.returnResults, error);
                [self cleanUpAndExitProcess];
            });
            
            NSError* error = [self possibleErrorDueToDupesAtRoot];
            if (error) {
                completionHandler(nil, self.returnResults, error);
            } else {
                /* See Note 20171023SQ at end of file to learn why the serial queues
                 are used here. */
                dispatch_queue_t aSerialQueue = dispatch_queue_create(
                                                                      "com.sheepsystems.SheepSafariHelper-Import",
                                                                      DISPATCH_QUEUE_SERIAL
                                                                      ) ;
                [self logIfLevel:2
                          string:@"Will load bookmarks for import"];
                /* The following may cause a silent crash if invoked a second time
                 (for example, first to read, then to write). */
                [self load];
                [self logIfLevel:2
                          string:@"Did load bookmarks for import"];
                dispatch_async(aSerialQueue, ^{
                    NSError* __block error = nil;
                    [self waitForLoadWithReason:@"Reading"
                                        error_p:&error];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSDictionary* tree = nil;
                        if (!error) {
                            [self logIfLevel:2
                                      string:@"Getting ready for tree"];
                            
                            self.returnResults = [NSMutableDictionary new];
                            [self addSafariFrameworkTattleToReturnResults];
                            
                            // See Note 20171031BMN regarding the following.
                            [self setName:SheepSafariHelperBarName
                                 bookmark:self.bar];
                            [self setName:SheepSafariHelperMenuName
                                 bookmark:self.menu];
                            
                            [self logIfLevel:2
                                      string:@"Will get root"];
                            SAFARI_FOLDER_CLASS* root = [self root];
#if 0
#warning Testing the Empty Safari Root Error 772052
                            for (WebBookmark* b in root.folderAndLeafChildren) {
                                [root removeChild:b];
                            }
#endif
                            [self logIfLevel:2
                                      string:[[NSString alloc] initWithFormat:
                                              @"Got root %@, %ld children",
                                              root.UUID,
                                              ((SAFARI_FOLDER_CLASS*)root).folderAndLeafChildren.count]];
                            if (((SAFARI_FOLDER_CLASS*)root).folderAndLeafChildren.count < 1) {
                                NSString* msg = @"Could not get Safari bookmarks";
                                [self logIfLevel:1
                                          string:msg];
                                error = [NSError errorWithDomain:SheepSafariHelperErrorDomain
                                                            code:772052
                                                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  @3, constKeyRetrialsRecommended,
                                                                  msg, NSLocalizedDescriptionKey,
                                                                  @"This can happen if your Mac is too busy, or low in disk space.", NSLocalizedRecoverySuggestionErrorKey,
                                                                  nil]
                                ];
                            } else {
                                [self logIfLevel:4
                                          string:@"Will try to acquire lock file"];
                                if ([self acquireLockFile]) {
                                    [self logIfLevel:2
                                              string:@"Will build tree"];
                                    tree = [self recursivelyBuildTreeByAppendingChild:root
                                                                             toParent:nil
                                                                                level:0];
                                    [self relinquishLockFileExpectantly:YES];
                                    [self logIfLevel:2
                                              string:@"Did build tree"];
                                } else {
                                    [self logIfLevel:4
                                              string:@"Could not acquire lock file"];
                                    error = [self bookmarksBusyError];
                                }
                            }
                        }
                        
                        [self logIfLevel:2
                                  string:@"Replying to main app"];
                        
                        completionHandler(tree, self.returnResults, error);
                        
                        NSString* logEntry = [[NSString alloc] initWithFormat:
                                              @"Import done, %d exitting, error: %@",
                                              getpid(),
                                              error];
                        [self logIfLevel:1
                                  string:logEntry];
                        
                        [self cleanUpAndExitProcess];
                        
                        /* Originallly, I did *not* exit(0) at this point, as I do with the
                         export operation, because it appeared that, apparently, the exit()
                         does not happen immediately, so that the subsequent
                         -exportChanges:completionHandler: message will connect to the same
                         process (same PID), just in time for it to be killed some
                         milliseconds later!
                         
                         But when retesting in macOS 10.13.3, I found the opposite problem,
                         which was that SheepSafariHelper would, with 25% probability, crash silently
                         at the [self load] above, when this re-executed for the writing.
                         By "silently", I mean that no dialog is shown and no crash report
                         appears.  Also, the "crosstalk" between the processes, described
                         in the previous paragraph, seems not to occur today!
                         
                         I would like to *not* exit(0) here, because it reduces the time it
                         takes for the export connection to make, typically from 2 seconds
                         down to 1 second.  But, I need to deal with what I see now, and
                         right now, it works with exit(0).  I have dealt with the original
                         problem (later re-use of exitting process) by putting a sleep of
                         several seconds in the completion handler in ExtoreSafari. */
                    });
                });
                
            }
        }
    }
}

- (void)exportForKlientAppDescription:(NSString*)customerDescription
                              changes:(NSDictionary*)changes
                    completionHandler:(void (^)(NSString* indexPathsForProposedExids, NSDictionary* results, NSError* error))completionHandler {
    [self logIfLevel:1
              string:[[NSString alloc] initWithFormat:
                      @"Received Export command from %@",
                      customerDescription]];

    @synchronized (self) {
        if (static_sheepSafariHelperBusiness) {
            [self logIfLevel:1
                      string:@"Busy - Returning error"];
            NSError* error = [NSError errorWithDomain:SheepSafariHelperErrorDomain
                                                 code:772043
                                             userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       @10, constKeyRetrialsRecommended,
                                                       static_sheepSafariHelperBusiness, NSLocalizedDescriptionKey,
                                                       nil]];
            [self logIfLevel:1
                      string:[NSString stringWithFormat:@"Time2Load XPC calling back: Export Me Busy"]];
            completionHandler(nil, nil, error);
            [self cleanUpAndExitProcess];
        } else {
            static_sheepSafariHelperBusiness = [[NSString alloc] initWithFormat:
                                     @"SheepSafariHelper pid %d is already exporting for %@",
                                     getpid(),
                                     customerDescription];
            dispatch_queue_t timeoutWatchdog = dispatch_queue_create(
                                                                     "Export Bookmarks Timeout Watchdog",
                                                                     DISPATCH_QUEUE_SERIAL
                                                                     ) ;

            dispatch_async(timeoutWatchdog, ^{
                [NSThread sleepForTimeInterval:constSheepSafariHelperTimeoutWrite];
                NSError* error = [NSError errorWithDomain:SheepSafariHelperErrorDomain
                                                     code:772051
                                                 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           @2, constKeyRetrialsRecommended,
                                                           @"System timed out processing changes to Safari", NSLocalizedDescriptionKey,
                                                           [NSNumber numberWithDouble:constSheepSafariHelperTimeoutWrite], @"Timeout Secs",
                                                           nil]
                                  ];
                [self logIfLevel:1
                          string:[NSString stringWithFormat:@"SheepSafariHelper calling back: Export, System timed out"]];
                completionHandler(nil, self.returnResults, error);
                [self cleanUpAndExitProcess];
            });

            /* See Note 20171023SQ at end of file to learn why the serial queues
             are used here. */
            dispatch_queue_t aSerialQueue = dispatch_queue_create(
                                                                  "com.sheepsystems.SheepSafariHelper-Export",
                                                                  DISPATCH_QUEUE_SERIAL
                                                                  ) ;
            if ([self acquireLockFile]) {
                dispatch_async(aSerialQueue, ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self logIfLevel:1
                                  string:[[NSString alloc] initWithFormat:
                                          @"Will process changes: %ld C, %ld P, %ld R",
                                          [[changes objectForKey:constKeyCuts] count],
                                          [[changes objectForKey:constKeyPuts] count],
                                          [[changes objectForKey:constKeyRepairs] count]]];
                        if (changes) {
                            self.assignedVsProposedExids = [NSMutableDictionary new];
                            self.indexPathsForProposedExids = [NSMutableDictionary new];
                            self.trialsByDepth = [NSMutableDictionary new];
                            self.returnResults = [NSMutableDictionary new];
                            [self addSafariFrameworkTattleToReturnResults];
                            self.limbo = [NSMutableArray new];
                            self.stash = [NSMutableDictionary new];
                            self.changes = changes;
                            [self processChanges:changes
                               completionHandler:completionHandler];
                        } else {
                            NSError* error = [NSError errorWithDomain:SheepSafariHelperErrorDomain
                                                                 code:772055
                                                             userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                       @"No changes to export", NSLocalizedDescriptionKey,
                                                                       nil]
                                              ];
                            [self logIfLevel:1
                                      string:[NSString stringWithFormat:@"SheepSafariHelper calling back: Export No changes"]];
                            completionHandler(nil, self.returnResults, error);
                            [self cleanUpAndExitProcess];
                        }
                    });
                });
            } else {
                [self logIfLevel:1
                          string:[NSString stringWithFormat:@"SheepSafariHelper calling back: Export No Acquite Lock"]];
                completionHandler(nil, self.returnResults, [self bookmarksBusyError]);
                [self cleanUpAndExitProcess];
            }
        }
    }
}

- (void)cleanUpAndExitProcess {
    [self relinquishLockFileExpectantly:NO];
    [SSYLinearFileWriter close];
    exit(0);
}

#pragma mark Methods Which Might Be Useful If They Worked

//- (void)bookmarkGroup:(WebBookmarkGroup *)arg1
//   bookmarkWasRemoved:(WebBookmark *)arg2
//           fromParent:(SAFARI_FOLDER_CLASS *)arg3 {
//    NSAssert3(NO, @"This never happened before!  wbg:%@  bookmarkWasRemoved: %@  fromParent: %@", arg1, arg2, arg3) ;
//}
//
//
//- (void)bookmarkGroup:(WebBookmarkGroup *)arg1
//   bookmarkWasRemoved:(WebBookmark *)arg2
//           fromParent:(SAFARI_FOLDER_CLASS *)arg3 {
//    NSAssert3(NO, @"This never happened before!  wbg:%@  bookmarkWasRemoved: %@  fromParent: %@", arg1, arg2, arg3) ;
//}
//
//- (void)bookmarkGroup:(WebBookmarkGroup *)arg1
//     bookmarkWasAdded:(WebBookmark *)arg2
//             toParent:(SAFARI_FOLDER_CLASS *)arg3 {
//    NSAssert3(NO, @"This never happened before!  wbg:%@  bookmarkWasAdded: %@  toParent: %@", arg1, arg2, arg3) ;
//}
//
//- (void)bookmarksWereReloadedInGroup:(WebBookmarkGroup *)arg1{
//
//}

/* Note 20171021
 It looks like there is a very nice API for determining whether or not
 iCloud,Safari syncing is on.  So I tried this:  */
#if 0
- (void)isICloudSafariActiveCompletionHandler:(void (^)(BOOL, BOOL))reply {
    Class featureAvailabilityClass = NSClassFromString(@"FeatureAvailability");
    BOOL signedIn = [featureAvailabilityClass isUserSignedIntoICloud];
    BOOL safariOn = [featureAvailabilityClass isSafariSyncEnabled];
    NSLog(@"signedIn=%hhd  safariOn=%hhd", signedIn, safariOn) ;
    reply(signedIn, safariOn);
}
#endif
/* But, sadly, after  5-10 second delay, both of the methods called return
 false NOs, and the debug log indicates a security violation of sorts ……
 2017-10-21 17:05:56.252465-0700 SheepSafariHelper[10285:342031] signedIn=0  safariOn=0
 2017-10-21 17:05:56.353898-0700 SheepSafariHelper[10285:342038] [core] "Error returned from daemon: Error Domain=com.apple.accounts Code=9 "(null)""
 2017-10-21 17:05:56.356645-0700 SheepSafariHelper[10285:342038] [core] "Error returned from daemon: Error Domain=com.apple.accounts Code=9 "(null)""
 2017-10-21 17:05:56.493102-0700 SheepSafariHelper[10285:342036] AOSKit ERROR: XPC CLIENT: Unauthorized client error received
 2017-10-21 17:05:56.493342-0700 SheepSafariHelper[10285:342036] [iCloudPreferences] [AOSAccounts] :  [CopyAOSValue]  : AOSAccountCopyInfo returned no info for accountID jerry@sheepsystems.com key isManagedAppleID dictKey appleAccountInfo

 Possibly this is due to System Integrity Protection, as explained here:

 https://trac.webkit.org/wiki/WebKitNightlyElCapWorkaround

 In case that link goes away, here is the meat of it:

 <meat>

 With the introduction of OS X El Capitan and the ​System Integrity Protection
 security feature, WebKit nightlies and the run-safari WebKit command no longer
 works. They still launch, but the latest WebKit frameworks are ignored and the
 system version of WebKit is used. This is because our use of
 DYLD_FRAMEWORK_PATH is ignored when launching the system Safari (specifically
 the SafariForWebKitDevelopment binary in the Safari app bundle). If you update
 your Mac from a previous version of El Capitan to 10.11.4, the
 SafariForWebKitDevelopment binary gets flagged as "restricted", preventing the
 WebKit nightly from loading its bundled WebKit frameworks. We are exploring a
 fix for this in a software update, but until then you can apply the following
 workaround.

 Note: This workaround is not for the faint of heart, and requires you to run
 commands while booted into the system recovery partition. Proceed with
 caution.

 Steps

 • Print out this page or load it up on a different device for reference.
 • Reboot the machine you want to apply the workaround to with the Command and
 R keys held down. (See ​About OS X Recovery.)
 • When the Mac OS X Utilities window appears, select the Utilities menu in the
 menubar and pick Terminal.  Note: FileVault users will need to go to Disk
 Utility or use diskutil first to unlock their secure partitions.
 • In the Terminal window, type: cd /Volumes && ls -l
 • Find the name of your main boot partition, it is usually something like
 Macintosh HD.
 • Type: cd "Macintosh HD" (or whatever name your boot partition is called).
 • Type: chflags norestricted Library/Application\ Support/Apple/Safari/SafariForWebKitDevelopment
 • Now you can select Restart from the  menu.

 </meat>

 So, maybe doing the same similar chflags to
 /System/Library/PrivateFrameworks/Safari.framework/Versions/A/Safari
 would allow those methods to work.  But, of course, that's not for production.

 */

#pragma mark Debugging Methods

#if 0
- (void)logMethodsOfClassName:(NSString*)className {
    unsigned int methodCount = 0;
    Class clz = NSClassFromString(className);
    Method *methods = class_copyMethodList(clz, &methodCount);

    printf("Found %d methods on '%s'\n", methodCount, class_getName(clz));

    NSMutableString* ss = [NSMutableString new];
    [ss appendFormat:@"%@ has methods:\n", className];
    for (unsigned int i = 0; i < methodCount; i++) {
        Method method = methods[i];
        char buffer[255];
        int cx;
        cx = snprintf(buffer, 255, "%s, encoding '%s'\n",
               sel_getName(method_getName(method)),
               method_getTypeEncoding(method));
        NSString* s = [NSString stringWithCString:buffer
                                         encoding:NSUTF8StringEncoding];
        [ss appendFormat:@"%@\n", s];
    }
    
    [self logIfLevel:5
              string:ss];

    free(methods);
}
#endif

@end

/* Note 20171023SQ

 What's with the serial dispatch queues?  Well, I found that, without them,
 unexpected nil objects were returned.  I've never seen these two lines
 return nil:
 +[BookmarksController sharedController] and
 -[BookmarksController allBookmarks]

 However I would occasionally see these failures:

 * Failure 1: -bookmarksBarCollection is nil.
 * Failure 2: -bookmarksBarCollection it would be non nil
 but its -folderAndLeafChildren would be nil.
 * Failure 3: -bookmarksBarCollection it would be non nil
 and its -folderAndLeafChildren would show, say 9 children, but
 -childAtIndex:8 would be nil.
 * Failure 4: Inexplicable EXC_BAD_ACCESS in
 -[BookmarksUndoController moveBookmarks:to:startingIndex:] when the first
 parameters was an array containing one WebBookmarksLeaf, the second was
 a WebBookmarkList containing 9 children, and and the third was integer 1.
 This should not have crashed.
 * Failure 5:  Occurred during -[WebBookmarkGroup load].  The thread which got
 the message from BookMacster (com.sheepsystems.SheepSafariHelper had this call
 stack:
 #0    0x00007fff51dd2bf9 in search_method_list(method_list_t const*, objc_selector*) ()
 #1    0x00007fff51dd2bd2 in getMethodNoSuper_nolock(objc_class*, objc_selector*) ()
 #2    0x00007fff51dd4f28 in lookUpImpOrForward ()
 #3    0x00007fff51dd4914 in _objc_msgSend_uncached ()
 #4    0x00007fff4acf3808 in __70-[WebBookmarkGroup _finishLoadingBookmarkGroupGutsOnMainQueueIfNeeded]_block_invoke ()
 #5    0x00007fff4aa95b3d in SafariShared::ScopeExitHandler::~ScopeExitHandler() ()
 #6    0x00007fff4acf373e in -[WebBookmarkGroup _finishLoadingBookmarkGroupGutsOnMainQueueIfNeeded] ()
 #7    0x000000010e72311f in __55-[SheepSafariHelper doExport:]_block_invoke at /Users/jk/Documents/Programming/Projects/BkmkMgrs/SheepSafariHelper/SheepSafariHelper.m:1097
 #8    0x000000010e9abd69 in _dispatch_call_block_and_release ()
 #9    0x000000010e9a3e47 in _dispatch_client_callout ()
 #10    0x000000010e9b9cda in _dispatch_queue_serial_drain ()
 #11    0x000000010e9ab8bc in _dispatch_queue_invoke ()
 #12    0x000000010e9bb0dd in _dispatch_root_queue_drain_deferred_wlh ()
 #13    0x000000010e9bff7b in _dispatch_workloop_worker_thread ()
 #14    0x000000010ea2202b in _pthread_wqthread ()
 #15    0x000000010ea21c45 in start_wqthread ()
 while the main thread had this call stack:
 #0    0x00007fff52b848d4 in szone_error ()
 #1    0x00007fff52b79658 in tiny_malloc_from_free_list ()
 #2    0x00007fff52b78403 in szone_malloc_should_clear ()
 #3    0x00007fff52b79cc0 in malloc_zone_calloc ()
 #4    0x00007fff52b7a5d6 in calloc ()
 #5    0x00007fff2b5554be in mdict_rehashd ()
 #6    0x00007fff2b553c0c in -[__NSDictionaryM setObject:forKeyedSubscript:] ()
 #7    0x00007fff4a772928 in addBookmarkToUUIDMapRecursively(WebBookmark*, NSMutableDictionary*) ()
 #8    0x00007fff4a772a1a in ___ZL31addBookmarkToUUIDMapRecursivelyP11WebBookmarkP19NSMutableDictionary_block_invoke ()
 #9    0x00007fff4a77075b in __47-[WebBookmarkList enumerateChildrenUsingBlock:]_block_invoke ()
 #10    0x00007fff4acfbd79 in __59-[WebBookmarkList enumerateChildrenWithOptions:usingBlock:]_block_invoke ()
 #11    0x00007fff2b3f5403 in -[__NSArrayI enumerateObjectsWithOptions:usingBlock:] ()
 #12    0x00007fff4acfbd12 in -[WebBookmarkList enumerateChildrenWithOptions:usingBlock:] ()
 #13    0x00007fff4a76e4bd in -[WebBookmarkList enumerateChildrenUsingBlock:] ()
 #14    0x00007fff4a7729ae in addBookmarkToUUIDMapRecursively(WebBookmark*, NSMutableDictionary*) ()
 #15    0x00007fff4a772870 in -[WebBookmarkGroup _updateSyncDataWithLoadedBookmarks:] ()
 #16    0x00007fff4acf36b7 in -[WebBookmarkGroup _finishLoadingBookmarkGroupGutsOnMainQueueIfNeeded] ()
 #17    0x00007fff4acf3d23 in __56-[WebBookmarkGroup _readBookmarkGroupGutsFromFileAtURL:]_block_invoke_3 ()
 #18    0x000000010e9abd69 in _dispatch_call_block_and_release ()
 #19    0x000000010e9a3e47 in _dispatch_client_callout ()
 #20    0x000000010e9b9cda in _dispatch_queue_serial_drain ()
 #21    0x000000010e9ab8bc in _dispatch_queue_invoke ()
 #22    0x000000010e9a5c9f in _dispatch_root_queue_drain ()
 #23    0x000000010e9a5978 in _dispatch_worker_thread3 ()
 #24    0x000000010ea221c2 in _pthread_wqthread ()
 #25    0x000000010ea21c45 in start_wqthread ()

 which, interestingly, indicates that indeed the work of
 -[WebBookmarkGroup load] is spun off to the main thread.

 I ran tests throughout an evening and into a morning, with timer
 firing off some changes to a collection of 16 items every 30 seconds:

 With the serial queues,
 * No failures after 90 trials.

 Then, without the serial queues,
 * Failure 3 occurred on trial 11.
 * Failure 1 occurred on trial 7.
 * Failure 4 occurred on trial 6.
 * Failure 1 occurred on trial 1.
 * Failure 3 occurred on trial 5.

 Then, with the serial queues,
 * Failure 5 occurred on trial 59.
 * No failures after 9 trials.

 Then, with serial queues, running overnight
 * No failures in 990 trials

 Then, with serial queues,
 * No failures in 147 trials

 I hypothesized that [WebBookmarkGroup load] must be some kind of
 asynchronous operation.  But I could not find any kind of callback to
 indicate when it was done.

 I tried waiting on -[WebBookmarkGroup _waitForBookmarkGroupGutsToLoad]
 after [WebBookmarkGroup load], but the former returns in 1 microsecond
 typical, while the latter takes typically 2 milliseconds for a tiny
 bookmarks collection of a 16 items.

 So I instead wrapped subsequent operations in these serial queues with a
 little delay.
 */

/*  Note 20171031NB
 I tried various methods for creating  new bookmarks and folders.
 The requirements are:

 1.  When iCloud is off, must produce the same result in Bookmarks.plist'
 Sync.Changes as Safari does.  This result is a single change of type "Add".
 2.  Should be able to get the UUID of the new item.

 The code now in -newFolderWithParent::: for macOS 10.14.3 and earlier (which
 uses addNewFolderTo:::) meets both requirements.
 The code now in -newBookmarkWithParent::::, and the code now in
-newFolderWithParent::: for macOS 14.4 and later meets only requirement 1.
 */

/* Here is some alternative code for creating new bookmarks. */
#if 0
{
    NSDictionary* uriDic = [NSDictionary dictionaryWithObjectsAndKeys:
                            name, @"title",
                            nil];
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"WebBookmarkTypeLeaf", @"WebBookmarkType",
                         uriDic, @"URIDictionary",
                         url, @"URLString",
                         nil];
    WebBookmarkLeaf* newBookmark = [[NSClassFromString(@"WebBookmarkLeaf") alloc] initFromDictionaryRepresentation:dic
                                                                                                         withGroup:self.wbg];

    [self.wbg beginMoveBookmarkBetweenParents:newBookmark];


    WebBookmarkLeaf* newBookmark = [NSClassFromString(@"WebBookmarkLeaf") bookmarkOfType:0];
    [newBookmark setURLString:url
         changeWasInteractive:NO];
    [newBookmark setTitle:name
     changeWasInteractive:NO];

    [self.wbg _insertNewBookmarkAtIndex:(unsigned int)index
                             ofBookmark:parent
                              withTitle:name
                                   type:type];
}

[self.wbg addBookmark:newBookmark];

if (newBookmark) {
    /* See Note: MovingItemRuinsItsUuid. */
    [self.buc moveBookmarks:[NSArray arrayWithObject:newBookmark]
                         to:parent
              startingIndex:index];
}

[self.wbg endMoveBookmarkBetweenParents:newBookmark];

[[self wbg] bookmarkChild:newBookmark
         wasAddedToParent:parent];
}
#endif

/* Regarding WebBookmark's long long type:
 0 is a leaf bookmark
 1 is a soft folder
 3 is apparently something, but I've never seen it happen.  Maybe it's a
 proxy (WebBookmarkProxy), like the History proxy.
 <-1 or >3 cause errors when passed into +bookmarkWithType:
 */

/* Note F&LC

 -[WebBookmarkList's -folderAndLeafChildren returns the same array as
 the property _children, unless the receiver is the root.  For the root,
 the array returned by _children has one additional child: the "History"
 object, of type WebBookmarkProxy, at index 0.  Ah, now I get it: the array
 returned by -folderAndLeafChildren contains only objects of type
 WebBookmarkList (folders) and WebBookmarkLeaf.

 I did not know this when I wrote most of the above code.  I preferred
-folderAndLeafChildren because I did not like the underscore in _children.
 So, I am vulnerable to breakage if Apple ever adds any more WebBookmarkProxy
 objects, if the proxy is something I want.  But maybe it will be something
 I don't want :)

*/

/* Note 20171031BMN

 For some strange reason

 Part 1 - Exports

 Whenever I save the wbg, without a fix, in -exportChanges:completionHandler:,
 the titles of BookmarksBar and BookmarksMenu in Bookmarks.plist get changed to
 their display titles, typically "Favorites" and "Bookmarks Menu".  Of course,
 Safari itself does not do this.  Moreover, the first or second time that
 Safari launches after such a save, it will change them back to BookmarksBar
 and BookmarksMenu.  Very strange.

 I tried the obvious fix, which is to set the titles of these two folders to
 their correct values just before [self.wbg save].  That worked, *except* when
 any change was made which changed the order of root's immediate children.
 (Note that the Bar and Menu are in fact the second and third of root's
 immediate children.  After a few hours, I disovered how to fix this exception:
 Also set the titles immediately after loading, that is, [self.wbg load],
 in addition to setting them before -save.  Inexplicable!

 By the way, before setting these titles for the first time, if I log
 self.bar.title and self.menu.title, I find that indeed they are "Favorites"
 and "Bookmarks Menu", as undesired.  The first time I change them, they
 remain at the desired values I set them to through the -save, although, as
 explained above, they are not necessarily written to Bookmarks.plist that
 way.

 Setting the titles in this way has the undesired side effect of writing two
 (bar, menu) records to Bookmarks.plist > Sync.Changes.  However,
 for 5 years (2017-2022) I did not see any issues caused by this side effect,
 and starting in 2022 BkmkMgrs 3.0.8 this side effect is now eliminated as a
 side effect of debugBogusChanges

 Part 2 - Imports

 When running -importWithCompletionHandler:, the same problem.  Setting the
 titles in -load does not help, but if I set the titles again, inside the
 two dispatch_async() blocks, then it works.  Maybe it has something to do
 with threading?

 */

/* Note 20180207NSA

 On 20180207, SheepSafariHelper crashed, and the call stack implied that it was trying
 to create a NSAlert to "tellUserThatExternalChangePreemptedLocalChange".
 See entire call stack below.  I figure this might be one of those "Your
 bookmarks cannot be changed now" messages, and to prevent it I would
 swizzle -[NSAlert init] to return nil.

 Thread 2#0    0x00007fff58b87222 in __workq_kernreturn ()
 #1    0x000000010f20b062 in _pthread_wqthread ()
 #2    0x000000010f20ac45 in start_wqthread ()
 Thread 3#0    0x00007fff58b86d1a in __semwait_signal ()
 #1    0x00007fff58b01724 in nanosleep ()
 #2    0x00007fff58b01618 in usleep ()
 #3    0x000000010dfedc7a in __tsan::BackgroundThread(void*) ()
 #4    0x000000010f20b6b9 in _pthread_body ()
 #5    0x000000010f20b565 in _pthread_start ()
 #6    0x000000010f20ac55 in thread_start ()
 Thread 4 Queue : com.apple.main-thread (serial)
 #0    0x00007fff58b86afe in __pthread_kill ()
 #1    0x000000010f20e1b4 in pthread_kill ()
 #2    0x000000010dfc1155 in wrap_pthread_kill ()
 #3    0x00007fff58ae21ae in abort ()
 #4    0x000000010dfbff1c in wrap_abort ()
 #5    0x00007fff3bcc43d7 in CA::Transaction::push(bool) ()
 #6    0x00007fff3bc1b3b2 in CA::Transaction::ensure_implicit() ()
 #7    0x00007fff3bc2476a in +[CATransaction(CATransactionPrivate) generateSeed] ()
 #8    0x00007fff2dada96f in +[NSDisplayCycle currentDisplayCycle] ()
 #9    0x00007fff2db3e6b6 in -[NSDisplayCycleObserver setNeedsDisplay:] ()
 #10    0x00007fff2daa2d4c in -[NSView _setWindow:] ()
 #11    0x00007fff2dad328b in -[NSFrameView initWithFrame:styleMask:owner:] ()
 #12    0x00007fff2dad301f in -[NSThemeFrame initWithFrame:styleMask:owner:] ()
 #13    0x00007fff2dad1b5a in -[NSWindow _commonInitFrame:styleMask:backing:defer:] ()
 #14    0x00007fff2dad038d in -[NSWindow _initContent:styleMask:backing:defer:contentView:] ()
 #15    0x00007fff2db3de67 in -[NSPanel _initContent:styleMask:backing:defer:contentView:] ()
 #16    0x00007fff2dacfe46 in -[NSWindow initWithContentRect:styleMask:backing:defer:] ()
 #17    0x00007fff2db3de20 in -[NSPanel initWithContentRect:styleMask:backing:defer:] ()
 #18    0x00007fff2db3d664 in -[NSWindowTemplate nibInstantiate] ()
 #19    0x00007fff2da90a0c in -[NSIBObjectData instantiateObject:] ()
 #20    0x00007fff2da8ffbd in -[NSIBObjectData nibInstantiateWithOwner:options:topLevelObjects:] ()
 #21    0x00007fff2da87585 in loadNib ()
 #22    0x00007fff2da86aa9 in +[NSBundle(NSNibLoading) _loadNibFile:nameTable:options:withZone:ownerBundle:] ()
 #23    0x00007fff2dcbc5f6 in +[NSBundle(NSNibLoadingInternal) _loadNibFile:externalNameTable:options:withZone:] ()
 #24    0x00007fff2dd64c1d in _NXLoadNib ()
 #25    0x00007fff2dd645ed in -[NSAlert init] ()
 #26    0x00007fff506bc4c4 in +[BookmarksController _tellUserThatExternalChangePreemptedLocalChange] ()
 #27    0x00007fff506bb903 in __78-[BookmarksController __savePendingChangesSoonWithPriority:completionHandler:]_block_invoke_2.353 ()
 #28    0x000000010dff923c in __tsan::invoke_and_release_block(void*) ()
 #29    0x000000010dff9382 in __tsan::dispatch_callback_wrap(void*) ()
 #30    0x000000010f18dd57 in _dispatch_client_callout ()
 #31    0x000000010f1a3ba9 in _dispatch_queue_serial_drain ()
 #32    0x000000010f1957c9 in _dispatch_queue_invoke ()
 #33    0x000000010f18fbb2 in _dispatch_root_queue_drain ()
 #34    0x000000010f18f88b in _dispatch_worker_thread3 ()
 #35    0x000000010f20b1c2 in _pthread_wqthread ()
 #36    0x000000010f20ac45 in start_wqthread ()
 Enqueued from com.apple.Safari.FileLocker (Thread 6) Queue : com.apple.Safari.FileLocker (serial)
 #0    0x000000010f1a491e in _dispatch_queue_push ()
 #1    0x000000010dff9215 in wrap_dispatch_async ()
 #2    0x00007fff506bb642 in __78-[BookmarksController __savePendingChangesSoonWithPriority:completionHandler:]_block_invoke.352 ()
 #3    0x00007fff50939f94 in ___ZN6Safari10FileLocker27doLockWithCompletionHandlerEU13block_pointerFvNS_10LockResultEEmaaaP12NSDictionary_block_invoke ()
 #4    0x000000010dff923c in __tsan::invoke_and_release_block(void*) ()
 #5    0x000000010dff9382 in __tsan::dispatch_callback_wrap(void*) ()
 #6    0x000000010f18dd57 in _dispatch_client_callout ()
 #7    0x000000010f1a3ba9 in _dispatch_queue_serial_drain ()
 #8    0x000000010f1957c9 in _dispatch_queue_invoke ()
 #9    0x000000010f1a4fb8 in _dispatch_root_queue_drain_deferred_wlh ()
 #10    0x000000010f1a9e91 in _dispatch_workloop_worker_thread ()
 #11    0x000000010f20b02b in _pthread_wqthread ()
 #12    0x000000010f20ac45 in start_wqthread ()
 Enqueued from com.apple.NSXPCConnection.user.78056 (Thread 2) Queue : com.apple.NSXPCConnection.user.78056 (serial)
 #0    0x000000010f1a491e in _dispatch_queue_push ()
 #1    0x000000010dff9215 in wrap_dispatch_async ()
 #2    0x00007fff50939082 in Safari::FileLocker::doLockWithCompletionHandler(void (Safari::LockResult) block_pointer, unsigned long, signed char, signed char, signed char, NSDictionary*) ()
 #3    0x00007fff5093923e in Safari::FileLocker::lockWithCompletionHandler(void (Safari::LockResult) block_pointer) ()
 #4    0x00007fff506ba975 in -[BookmarksController _lockFileLockerWithCompletionHandler:] ()
 #5    0x00007fff506bb1e9 in -[BookmarksController __savePendingChangesSoonWithPriority:completionHandler:] ()
 #6    0x00007fff506bacdd in -[BookmarksController _savePendingChangesSoonWithPriority:completionHandler:] ()
 #7    0x00007fff506bcba5 in -[BookmarksController _savePendingChangesSoonForPossiblyInteractiveBookmarkChange:completionHandler:] ()
 #8    0x00007fff506bd500 in -[BookmarksController bookmarkGroup:bookmarkDidChange:changeWasInteractive:] ()
 #9    0x00007fff50bb3295 in -[WebBookmarkGroup _sendDelegateMessage:withModifiedBookmark:child:changeWasInteractive:] ()
 #10    0x00007fff50bb25b7 in -[WebBookmarkGroup bookmarkDidChange:changedAttributes:changeWasInteractive:] ()
 #11    0x00007fff50babd1c in -[WebBookmark _setTitle:notifyBookmarkGroup:changeWasInteractive:] ()
 #12    0x00007fff50babbf1 in -[WebBookmark setTitle:changeWasInteractive:] ()
 #13    0x00007fff506da2a8 in -[BookmarksUndoController changeTitleOfBookmark:to:] ()
 #14    0x000000010df66d36 in -[SheepSafariHelper setName:bookmark:] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/SheepSafariHelper/SheepSafariHelper.m:306
 #15    0x000000010df65792 in -[SheepSafariHelper load] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/SheepSafariHelper/SheepSafariHelper.m:142
 #16    0x000000010df6e9ad in -[SheepSafariHelper importForKlientAppDescription:completionHandler:] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/SheepSafariHelper/SheepSafariHelper.m:885
 #17    0x00007fff329750ff in __NSXPCCONNECTION_IS_CALLING_OUT_TO_EXPORTED_OBJECT_S2__ ()
 #18    0x00007fff329738cc in -[NSXPCConnection _decodeAndInvokeMessageWithEvent:flags:] ()
 #19    0x00007fff326c0717 in message_handler ()
 #20    0x000000010dff8afd in __wrap_xpc_connection_set_event_handler_block_invoke ()
 #21    0x00007fff58d7eca7 in _xpc_connection_call_event_handler ()
 #22    0x00007fff58d7d451 in _xpc_connection_mach_event ()
 #23    0x000000010f193368 in _dispatch_client_callout4 ()
 #24    0x000000010f193614 in _dispatch_mach_msg_invoke ()
 #25    0x000000010f1a38c1 in _dispatch_queue_serial_drain ()
 #26    0x000000010f191d12 in _dispatch_mach_invoke ()
 #27    0x000000010f1a38c1 in _dispatch_queue_serial_drain ()
 #28    0x000000010f1957c9 in _dispatch_queue_invoke ()
 #29    0x000000010f1a4fb8 in _dispatch_root_queue_drain_deferred_wlh ()
 #30    0x000000010f1a9e91 in _dispatch_workloop_worker_thread ()
 #31    0x000000010f20b02b in _pthread_wqthread ()
 #32    0x000000010f20ac45 in start_wqthread ()
 Thread 5 Queue : com.apple.root.default-qos.overcommit (concurrent)
 #0    0x00007fff58b86fba in __sigsuspend_nocancel ()
 #1    0x000000010f19aaa7 in _dispatch_sigsuspend ()
 #2    0x000000010f19aa92 in _dispatch_sig_thread ()
 Enqueued from com.apple.root.default-qos.overcommit (Thread 0) Queue : com.apple.root.default-qos.overcommit (serial)
 #0    0x000000010f1a448c in _dispatch_root_queue_push ()
 #1    0x000000010f19aa20 in _dispatch_queue_cleanup2 ()
 #2    0x000000010f20d2be in _pthread_tsd_cleanup ()
 #3    0x000000010f20cffd in _pthread_exit ()
 #4    0x000000010f20da79 in pthread_exit ()
 #5    0x000000010f19a997 in dispatch_main ()
 #6    0x00007fff58d84236 in _xpc_objc_main ()
 #7    0x00007fff58d82ee6 in xpc_main ()
 #8    0x00007fff32703475 in -[NSXPCListener resume] ()
 #9    0x000000010df63bec in main at /Users/jk/Documents/Programming/Projects/BkmkMgrs/SheepSafariHelper/main.m:62
 #10    0x00007fff58a36015 in start ()
 Thread 6#0    0x00007fff58b87222 in __workq_kernreturn ()
 Thread 7#0    0x00007fff58b869ae in __psynch_cvwait ()
 #1    0x000000010f20c6a2 in _pthread_cond_wait ()
 #2    0x000000010dffe542 in __tsan::call_pthread_cancel_with_cleanup(int (*)(void*, void*, void*), void*, void*, void*, void (*)(void*), void*) ()
 #3    0x000000010dfbdbe3 in cond_wait(__tsan::ThreadState*, unsigned long, __tsan::ScopedInterceptor*, int (*)(void*, void*, void*), void*, void*, void*) ()
 #4    0x000000010dfbdadc in wrap_pthread_cond_wait ()
 #5    0x00007fff56993cb0 in std::__1::condition_variable::wait(std::__1::unique_lock<std::__1::mutex>&) ()
 #6    0x00007fff341f1cc6 in void std::__1::condition_variable_any::wait<std::__1::unique_lock<bmalloc::Mutex> >(std::__1::unique_lock<bmalloc::Mutex>&) ()
 #7    0x00007fff341f197b in bmalloc::Scavenger::threadRunLoop() ()
 #8    0x00007fff341f1779 in bmalloc::Scavenger::threadEntryPoint(bmalloc::Scavenger*) ()
 #9    0x00007fff341f1ab8 in void* std::__1::__thread_proxy<std::__1::tuple<std::__1::unique_ptr<std::__1::__thread_struct, std::__1::default_delete<std::__1::__thread_struct> >, void (*)(bmalloc::Scavenger*), bmalloc::Scavenger*> >(void*) ()
 #10    0x000000010dfbd38c in __tsan_thread_start_func ()
 #11    0x000000010f20b6b9 in _pthread_body ()
 #12    0x000000010f20b565 in _pthread_start ()
 #13    0x000000010f20ac55 in thread_start ()
 Thread 8 Queue : com.sheepsystems.SheepSafariHelper-Import (serial)
 #0    0x00007fff58b86d1a in __semwait_signal ()
 #1    0x00007fff58b01724 in nanosleep ()
 #2    0x00007fff58b01586 in sleep ()
 #3    0x000000010dfbbfff in wrap_sleep ()
 #4    0x000000010df6eb8c in __45-[SheepSafariHelper importForKlientAppDescription:completionHandler:]_block_invoke at /Users/jk/Documents/Programming/Projects/BkmkMgrs/SheepSafariHelper/SheepSafariHelper.m:889
 #5    0x000000010dff923c in __tsan::invoke_and_release_block(void*) ()
 #6    0x000000010dff9382 in __tsan::dispatch_callback_wrap(void*) ()
 #7    0x000000010f18dd57 in _dispatch_client_callout ()
 #8    0x000000010f1a3ba9 in _dispatch_queue_serial_drain ()
 #9    0x000000010f1957c9 in _dispatch_queue_invoke ()
 #10    0x000000010f1a4fb8 in _dispatch_root_queue_drain_deferred_wlh ()
 #11    0x000000010f1a9e91 in _dispatch_workloop_worker_thread ()
 #12    0x000000010f20b02b in _pthread_wqthread ()
 #13    0x000000010f20ac45 in start_wqthread ()
 Enqueued from com.apple.NSXPCConnection.user.78056 (Thread 2) Queue : com.apple.NSXPCConnection.user.78056 (serial)
 #0    0x000000010f1a491e in _dispatch_queue_push ()
 #1    0x000000010dff9215 in wrap_dispatch_async ()
 #2    0x000000010df6ead3 in -[SheepSafariHelper importForKlientAppDescription:completionHandler:] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/SheepSafariHelper/SheepSafariHelper.m:888
 #3    0x00007fff329750ff in __NSXPCCONNECTION_IS_CALLING_OUT_TO_EXPORTED_OBJECT_S2__ ()
 #4    0x00007fff329738cc in -[NSXPCConnection _decodeAndInvokeMessageWithEvent:flags:] ()
 #5    0x00007fff326c0717 in message_handler ()
 #6    0x000000010dff8afd in __wrap_xpc_connection_set_event_handler_block_invoke ()
 #7    0x00007fff58d7eca7 in _xpc_connection_call_event_handler ()
 #8    0x00007fff58d7d451 in _xpc_connection_mach_event ()
 #9    0x000000010f193368 in _dispatch_client_callout4 ()
 #10    0x000000010f193614 in _dispatch_mach_msg_invoke ()
 #11    0x000000010f1a38c1 in _dispatch_queue_serial_drain ()
 #12    0x000000010f191d12 in _dispatch_mach_invoke ()
 #13    0x000000010f1a38c1 in _dispatch_queue_serial_drain ()
 #14    0x000000010f1957c9 in _dispatch_queue_invoke ()
 #15    0x000000010f1a4fb8 in _dispatch_root_queue_drain_deferred_wlh ()
 #16    0x000000010f1a9e91 in _dispatch_workloop_worker_thread ()
 #17    0x000000010f20b02b in _pthread_wqthread ()
 #18    0x000000010f20ac45 in start_wqthread ()

 */

