#import "BkmxDocumentController.h"
#import <Bkmxwork/Bkmxwork-Swift.h>
#import "NSError+DecodeCodes.h"
#import "NSDocumentController+SSYNukeAndPave.h"
#import "Clientoid.h"
#import "Macster.h"
#import "Client.h"
#import "NSError+MyDomain.h"
#import "NSError+SSYInfo.h"
#import "NSError+InfoAccess.h"
#import "BkmxDoc.h"
#import "NSString+MorePaths.h"
#import "SSYAppInfo.h"
#import "NSError+InfoAccess.h"
#import "NSData+FileAlias.h"
#import "NSString+LocalizeSSY.h"
#import "NSString+SSYExtraUtils.h"
#import "NSDocumentController+DisambiguateForUTI.h"
#import "Watch.h"
#import "NSFileManager+SomeMore.h"
//#import "MAKVONotificationCenter.h"
#import "BkmxDocWinCon.h"
//#import "SSYMOCManager.h"
#import "NSDocumentController+MoreRecents.h"
#import "NSDocumentController+OpenExpress.h"
#import "Syncer.h"
#import "NSUserDefaults+Bkmx.h"
#import "BkmxAppDel+Actions.h"
#import "SSYLicenseInstaller.h" 
#import "Stager.h"
#import "NSURL+FileDisplayName.h"
#import "ClientsWizWinCon.h"
#import "ClientoidPlus.h"
#import "BkmxBasis+Strings.h"
#import "NSInvocation+Quick.h"
#import "SSYOperationQueue.h"
#import "SSYCachyAliasResolver.h"
#import "NSProcessInfo+SSYMoreInfo.h"
#import "SSYMH.AppAnchors.h"
#import "NSError+MoreDescriptions.h"
#import "NSBundle+SSYMotherApp.h"
#import "NSUserDefaults+MainApp.h"
#import "NSUserDefaults+SSYOtherApps.h"
#import "NSBundle+MainApp.h"
#import "NSFileManager+TempFile.h"
#import "SSYDooDooUndoManager.h"
#import "Bkmslf.h"
#import "NSDocumentController+SSYFixLaunchServicesBug.h"
#import "BSManagedDocument+SSYAuxiliaryData.h"

#if 0
#warning  Testing_Document_Opening_Timeout
#define TIMEOUT_FOR_DOCUMENT_TO_OPEN 12.0
#define SLEEP_SECONDS_FOR_FAKING_DOCUMENT_OPENING_FAILURE 20.0
#else
#define TIMEOUT_FOR_DOCUMENT_TO_OPEN 45.1215
#define SLEEP_SECONDS_FOR_FAKING_DOCUMENT_OPENING_FAILURE 0
#endif

NSString* const BkmxDocumentControllerErrorDomain = @"BkmxDocumentControllerErrorDomain" ;

@interface BkmxDocumentController ()

@property (assign) NSInteger lastIssuedDocumentSequenceNumber ;
@property (retain) NSMutableDictionary* docOpeningTimeoutters;
@property (readonly) NSMutableSet* nowMigratingUrls;
@property (assign) NSTimeInterval extraTimeoutDueToMigration;
@property (assign) BOOL haveADoc;

@end

@implementation BkmxDocumentController

+ (BkmxDocumentController*)sharedDocumentController {
    return (BkmxDocumentController*)[super sharedDocumentController] ;
}

/* Due to https://github.com/jerrykrinock/BSManagedDocument/issues/15#issuecomment-692359299 */
- (BOOL)allowsAutomaticShareMenu {
    return NO;
}


#pragma mark * Debugging Overrides

/*
 - (Class)documentClassForType:(NSString *)documentTypeName {
	Class class = [super documentClassForType:documentTypeName] ;
	return class ;
}

- (id)makeUntitledDocumentOfType:(NSString *)typeName
						   error:(NSError **)outError {
	id doc = [super makeUntitledDocumentOfType:typeName
										 error:outError] ;
	return doc ;
}

- (id)openUntitledDocumentAndDisplay:(BOOL)displayDocument
							   error:(NSError **)outError {
	return [super openUntitledDocumentAndDisplay:displayDocument
									error:outError] ;
}

- (IBAction)newDocument:(id)sender {
	[super newDocument:sender] ;
}
*/


#pragma mark * Actual Code

+ (NSSet*)documentDescriptionsFromWatches:(NSSet <Watch*>*)watches {
	NSMutableSet* docDescriptions = [NSMutableSet new] ;
	BkmxDocumentController* documentController = [BkmxDocumentController sharedDocumentController] ;
    CGFloat secondsPerWatch = 15.0/watches.count ;
    for (Watch* watch in watches) {
        NSString* path = [documentController pathOfDocumentWithUuid:watch.docUuid
                                                            appName:watch.appName
                                                            timeout:secondsPerWatch
                                                             trials:1
                                                              delay:0
                                                            error_p:NULL] ;
		NSString* thisDescription = [[NSString alloc] initWithFormat:
                                     @"   \xe2\x80\xa2 %@ (syncing by %@)",
                                     [path lastPathComponent],
                                     watch.appName];
        [docDescriptions addObject:thisDescription];
        [thisDescription release];
    }
    
    NSSet* answer = [docDescriptions copy] ;
    [docDescriptions release] ;
    [answer autorelease];
    
    return answer ;
}

+ (NSString*)documentListFromWatches:(NSSet <Watch*>*)watches {
    NSSet* set = [self documentDescriptionsFromWatches:watches];
    NSArray* array = [set allObjects];
    NSString* string = [array componentsJoinedByString:@"\n"];
    string = [string stringByAppendingString:@"\n"];

    return string;
}

@synthesize lastIssuedDocumentSequenceNumber ;
@synthesize isDuplicating = m_isDuplicating ;
@synthesize skipAskingForClients = m_skipAskingForClients ;

- (BkmxDoc*)alreadyOpenDocWithUuid:(NSString*)uuid {
    for (BkmxDoc* doc in [self documents]) {
        if ([doc respondsToSelector:@selector(uuid)]) {
            if ([[doc uuid] isEqualToString:uuid]) {
                return doc;
            }
        }
    }
    
    return nil;
}

- (NSMutableSet*)nowMigratingUrls {
    if (!m_nowMigratingUrls) {
        m_nowMigratingUrls = [NSMutableSet new];
    }
    
    return m_nowMigratingUrls;
}

- (BOOL)isNowMigratingUrl:(NSURL*)url {
    return [[self nowMigratingUrls] member:url] != nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(migrationStartedNote:)
                                                     name:CoreDataProgressiveMigrator.startedMigration
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(migrationEndedNote:)
                                                     name:CoreDataProgressiveMigrator.endedMigration
                                                   object:nil];
    }
    
    return self;
}

- (void)migrationStartedNote:(NSNotification*)note {
    NSURL* url = [note.userInfo objectForKey:CoreDataProgressiveMigrator.migratingStoreUrl];
    if (url) {
        /* CoreDataProgressiveMigrator gives us the storeURL, whose last two path
         components are StoreContent/persistentStore.  Remove the last two path
         components, to get the document package URL. */
        url = [[url URLByDeletingLastPathComponent] URLByDeletingLastPathComponent];
        [[self nowMigratingUrls] addObject:url];
    }
}

- (void)migrationEndedNote:(NSNotification*)note {
    NSURL* url = [note.userInfo objectForKey:CoreDataProgressiveMigrator.migratingStoreUrl];
    if (url) {
        [[self nowMigratingUrls] removeObject:url];
        if ([self nowMigratingUrls].count == 0) {
            /* I think we only want to do this in the main app.  Otherwise,
             wwe would be rebooting ourself. */
            if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
                [[BkmxBasis sharedBasis] rebootSyncAgentReport_p:NULL
                                                         title_p:NULL
                                                         error_p:NULL];
            }
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_docOpeningTimeoutters release];
    [m_nowMigratingUrls release];;

    [super dealloc];
}

- (void)removeDocument:(NSDocument *)document {
	if ([document respondsToSelector:@selector(tearDownOnce)]) {
		// Document is a BkmxDoc
		[(BkmxDoc*)document tearDownOnce] ;
	}
	
	[super removeDocument:document] ;
}

- (BOOL)indicatesNoDataModelError:(NSError*)error {
    return [CoreDataProgressiveMigration doesErrorIndicateNoModelForStore:error];
}

- (void)documentOpeningTimerTickedWithAlert:(SSYAlert *)alert
                          completionHandler:(void (^)(BkmxDoc *, BOOL, NSError *))completionHandler
                          startTimeInterval:(NSTimeInterval)startTimeInterval
                                        url:(NSURL *)url {
    if ([self isNowMigratingUrl:url]) {
        self.extraTimeoutDueToMigration = self.extraTimeoutDueToMigration + 1.0;
    } else {
    }
    NSTimeInterval timeout = TIMEOUT_FOR_DOCUMENT_TO_OPEN + self.extraTimeoutDueToMigration;
    NSTimeInterval countdown = startTimeInterval - [NSDate timeIntervalSinceReferenceDate] + timeout;
    NSTimeInterval const thresholdToStartShowingCountdown = 7.0; // seconds
    if (countdown > timeout - thresholdToStartShowingCountdown) {
        // Do nothing, just show "Processing…"
    } else if (countdown > 0.0) {
        NSString* smallText;
        NSString* whatDoing;
        NSString* docName = [[url path] lastPathComponent];
        if ([self isNowMigratingUrl:url]) {
            /* We don't know how long migrating will take an therefore
             do not put a limit. */
            whatDoing = [[NSString localizeFormat:
                           @"migratingWhat",
                           docName] ellipsize];
            smallText = [[NSString alloc] initWithFormat:
                         @"%@",
                         whatDoing];
        } else {
            // Show countdown
            whatDoing = [[NSString localizeFormat:
                          @"loadingWhat",
                          docName] ellipsize];
            smallText = [[NSString alloc] initWithFormat:
                         @"%@ (will try %ld more seconds)",
                         whatDoing,
                         (long)(ceil(countdown))];
        }
        [alert setRightColumnWidth:300.0];
        [alert setSmallText:smallText];
        [smallText release];
        [alert doooLayout];
        [alert display];
    } else {
        // Abandon the effort
        NSError* error = SSYMakeError(257938, @"Taking too long to open document");
        NSString* suggestion = [NSString stringWithFormat:
                                NSLocalizedString(@"If you have recently updated %@, please click the '?' Help button for procedures to fix this issue.", nil),
                                [[BkmxBasis sharedBasis] appNameLocalized]
                                ];
        error = [error errorByAddingLocalizedRecoverySuggestion:suggestion];
        error = [error errorByAddingHelpAddress:@"https://www.sheepsystems.com/files/support_articles/bkmx/processing-forever.html"];
        error = [error errorByAddingDontShowSupportEmailButton];
        [self finishOpeningUrl:url
                       display:NO
                         alert:alert
             completionHandler:completionHandler
                      document:nil
                wasAlreadyOpen:NO
                         error:error];
    }
}

- (void)addTimeoutterForUrl:(NSURL*)url
                      alert:(SSYAlert*)alert
          completionHandler:(void (^)(BkmxDoc* document,
                                      BOOL documentWasAlreadyOpen,
                                      NSError* error))completionHandler {
    /* Defensive programming, in case url is nil.  This might happen while
     relaunching, due to state restoration, if a never-saved new document had
     been open during a crash. */
    if (url) {
        if (self.docOpeningTimeoutters == nil) {
            NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
            self.docOpeningTimeoutters = dic;
            [dic release];
        }

        [alert retain];
        /* We retain the alert to prevent later crash, as explained here:
         https://stackoverflow.com/questions/17384599/why-are-block-variables-not-retained-in-non-arc-environments
         http://www.mikeash.com/pyblog/friday-qa-2009-08-14-practical-blocks.html */
        NSTimeInterval startTimeInterval = [NSDate timeIntervalSinceReferenceDate];
        NSTimer* timer;
        if (@available(macOS 10.12, *)) {
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                    repeats:YES
                                                      block:^(NSTimer * _Nonnull timer) {
                                                          [self documentOpeningTimerTickedWithAlert:alert
                                                                                  completionHandler:completionHandler
                                                                                  startTimeInterval:startTimeInterval
                                                                                                url:url];
                                                      }];
        } else {
            NSInvocation* invocation = [NSInvocation invocationWithTarget:self
                                                                 selector:@selector(documentOpeningTimerTickedWithAlert:completionHandler:startTimeInterval:url:)
                                                          retainArguments:YES
                                                        argumentAddresses:&alert, &completionHandler, &startTimeInterval, &url];
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                 invocation:invocation
                                                    repeats:YES];
        }

        /* First, remove and invalidate any existing timer under this key.
         Otherwise, it will still fire!  This can happen when called from
         -reopenDocument… */
        [self removeTimeoutterForUrl:url];
        [self.docOpeningTimeoutters setObject:timer
                                       forKey:url.absoluteString];
    }
}

- (BOOL)isTimeoutInProcessForUrl:(NSURL*)url {
    return ([self.docOpeningTimeoutters objectForKey:url] != nil);
}

- (void)removeTimeoutterForUrl:(NSURL*)url {
     NSTimer* timer = [self.docOpeningTimeoutters objectForKey:url.absoluteString];
    [timer invalidate];
    [self.docOpeningTimeoutters removeObjectForKey:url.absoluteString];
}

- (void)finishOpeningUrl:(NSURL*)url
                 display:(BOOL)display
                   alert:(SSYAlert*)alert
       completionHandler:(void (^)(BkmxDoc* document,
                                    BOOL documentWasAlreadyOpen,
                                    NSError* error))completionHandler
                document:(NSDocument*)document
          wasAlreadyOpen:(BOOL)documentWasAlreadyOpen
                   error:(NSError*)error {
    /* When called during state restoration to reopen a document which was
     never saved, maybe only after an unexpected termination, `document`
     will be OK but `url` will be nil.  So we must test for that. */
    if (url) {
        [self removeTimeoutterForUrl:url];
    }

    if (![error involvesCode:257938]) {
        if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
            if (!document) {
                if ([[self defaultDocumentClass] respondsToSelector:@selector(autosavesInPlace)]) {
                    // Possibly user can retrieve uncorrupted version of document from Verisons Browser
                    if ([[[[url path] lastPathComponent] pathExtension] isEqualToString:[self defaultDocumentFilenameExtension]]) {
                        if ([[self defaultDocumentClass] autosavesInPlace]) {
                            [self tryNukeAndPaveURL:url
                                            errorIn:error
                                       storeOptions:nil
                                 modelConfiguration:nil
                                            display:display
                                  completionHandler:^(
                                                      SSYNukeAndPaveResult result,
                                                      NSString* movedToPath,
                                                      NSDocument* documentOut) {
                                      if (result == SSYNukeAndPaveResultTriedAndSucceeded) {
                                          NSString* msg = [NSString stringWithFormat:
                                                           @"Your document %@ was found to be corrupt and could not be opened.  "
                                                           @"The corrupt data has been moved into here:\n\n%@\n\nand removed from this document.\n\n"
                                                           @"You may wish to revert to an earlier version of this document.  "
                                                           @"To do that, click in the menu: File > Revert to > Browse all versions.",
                                                           [[url path] lastPathComponent],
                                                           movedToPath] ;
                                          NSInvocation* invocation = [NSInvocation invocationWithTarget:document
                                                                                               selector:@selector(runModalSheetWithMessage:)
                                                                                        retainArguments:YES
                                                                                      argumentAddresses:&msg] ;
                                          NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                                                        invocation:invocation
                                                                                           repeats:NO] ;
                                          [(BkmxDoc*)document setNukePaveWarnTimer:timer] ;
                                      }
                                  }] ;
                        }
                    }
                }
                if (!document) {
                    NSString* msg = [NSString stringWithFormat:
                                     @"Could not open %@",
                                     [url path]] ;

                    NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                              msg, NSLocalizedDescriptionKey,
                                              [[NSProcessInfo processInfo] geekyProcessInfo], @"Process Info",
                                              error, NSUnderlyingErrorKey,  // may be nil
                                              url, @"File (?) URL",
                                              nil] ;
                    if (!error) {
                        error = [NSError errorWithDomain:BkmxDocumentControllerErrorDomain
                                                    code:153802  // formerly 1538022
                                                userInfo:userInfo] ;
                        error = [error errorByAddingBacktrace] ;
                    }

                    NSString* thisExtension = [[[url path] lastPathComponent] pathExtension] ;
                    NSString* defaultExtension = [self defaultDocumentFilenameExtension] ;
                    if ([thisExtension isEqualToString:defaultExtension]) {
                        /* Error 257938 already has a recovery suggestion which
                         is more correct than the one to be added here.  Hence
                         the following if() line …*/
                        if (![error localizedRecoverySuggestion]) {
                            NSString* suggestion = nil ;
                            if ([[BkmxBasis sharedBasis] isShoeboxApp]) {
                                if ([SSYAppInfo isNewUser]) {
                                    error = nil ;
                                }
                                else {
                                    NSString* docPre = @"" ;
                                    NSString* docPost = @"" ;
                                    if ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppSmarky) {
                                        docPost = @" and import to it from Safari" ;
                                    }
                                    else {
                                        docPre = @"empty " ;
                                    }
                                    suggestion = [NSString stringWithFormat:
                                                  @"%@ will now create a new %@document%@.  "
                                                  @"If you would rather restore your old data, quit %@ and then restore the following file from a backup:\n\n%@",
                                                  [[BkmxBasis sharedBasis] appNameLocalized],
                                                  docPre,
                                                  docPost,
                                                  [[BkmxBasis sharedBasis] appNameLocalized],
                                                  url.path] ;
                                }
                            }
                            else {
                                suggestion = [NSString stringWithFormat:
                                              @"If you want your old document's data, restore the following file from a backup:\n\n%@",
                                              url.path];
                            }
                            error = [error errorByAddingLocalizedRecoverySuggestion:suggestion] ;
                        }
                    }
                    else {
                        // Presumably the failure was with a .xxxxxxlicenseinstaller file
                        NSString* basename = [[[[url path] lastPathComponent] stringByDeletingPathExtension] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ;
                        NSArray* basenameComponents = [basename componentsSeparatedByString:@" "] ;
                        if ([basenameComponents count] > 1) {
                            NSString* licenseInstallerAppName = [basenameComponents firstObject] ;
                            NSString* secondWord = [basenameComponents objectAtIndex:1] ;
                            NSInteger licenseInstallerMajorVersion = [secondWord integerValue] ;
                            if (licenseInstallerAppName && (licenseInstallerMajorVersion > 0)) {
                                // The file has a version number suffix.
                                NSInteger appMajorVersion = [[SSYAppInfo currentVersionTriplet] major] ;
                                if (licenseInstallerMajorVersion != appMajorVersion) {
                                    NSString* msg = [NSString stringWithFormat:
                                                     @"The License Installer file you attempted to open is for %@ version %ld, but this app is %@ version %ld.",
                                                     licenseInstallerAppName,
                                                     licenseInstallerMajorVersion,
                                                     [[BkmxBasis sharedBasis] appNameLocalized],
                                                     appMajorVersion] ;
                                    /* In this case, do not pass the underlying error because it contains
                                     two levels of not-very-informative "file could not be opened"
                                     statements from Cocoa. */
                                    NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                                              msg, NSLocalizedDescriptionKey,
                                                              url, @"File (?) URL",
                                                              nil] ;
                                    error = [NSError errorWithDomain:BkmxDocumentControllerErrorDomain
                                                                code:153805
                                                            userInfo:userInfo] ;
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    /* Much of what remains to be maybe done must be done on the main thread.
     That includes showing the inspector, showing the license info window,
     making the alert go away, and not obviously, running the completion
     handler.  But that is because Apple documentation of
     -openDocumentWithContentsOfURL:display:completionHandler:
     says we must be on the main thread when invoking completion handler. */
    if ([[NSThread currentThread] isMainThread]) {
        [self finishMainThreadTasksOpeningDocument:document
                            documentWasAlreadyOpen:documentWasAlreadyOpen
                                             error:error
                                               url:url
                                             alert:alert
                                 completionHandler:completionHandler];
    } else {
        dispatch_queue_t mainQueue = dispatch_get_main_queue() ;
        dispatch_sync(mainQueue, ^{
            [self finishMainThreadTasksOpeningDocument:document
                                documentWasAlreadyOpen:documentWasAlreadyOpen
                                                 error:error
                                                   url:url
                                                 alert:alert
                                     completionHandler:completionHandler];
        });
    }
}

- (void)finishMainThreadTasksOpeningDocument:(NSDocument*)document
                      documentWasAlreadyOpen:(BOOL)documentWasAlreadyOpen
                                       error:(NSError*)error
                                         url:(NSURL*)url
                                       alert:(SSYAlert*)alert
                           completionHandler:(void (^)(BkmxDoc* document,
                                                       BOOL documentWasAlreadyOpen,
                                                       NSError* error))completionHandler {
    if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
        BOOL isThrowaway = YES;
        if ([document isKindOfClass:[BkmxDoc class]]) {
            // Actually, it is only necessary to do this when the application launches.
            // But we don't want to do it during -applicationDidFinishLaunching
            // because it looks silly to have it pop up before a document has finished opening,
            // or even to have it open at all if no document opened.
            [(BkmxAppDel*)[NSApp delegate] showInspectorIfItWasShowing] ;
            isThrowaway = NO;
        }
        else if ([document isKindOfClass:[SSYLicenseInstaller class]]) {
            // Show it in the License Info window
            [(BkmxAppDel*)[NSApp delegate] licenseInfo:nil] ;

            // Leave isThrowaway = YES;
        }
        else if ([document isKindOfClass:[Bkmslf class]]) {
            // Leave isThrowaway = YES;
        }

        /* In some weird cases, we get url !=  nil but document = nil.
         I don't want to remove it from Recent Documents in that case. */
        if (document) {
            if (isThrowaway) {
                [document close];

                // The delay was added in BookMacster 1.19.2 after I noticed that
                // .bookmacsterlicenseinstaller files were appearing in the Recent
                // Documents after opening in macOS 10.9.  Delay fixed the problem.
                [self performSelector:@selector(forgetRecentDocumentUrl:)
                           withObject:url
                           afterDelay:0.05] ;
            }
        }
    }

    [alert goAway];
    /* Balance the -retain in all calls to this method. */
    [alert release];
    if (completionHandler) {
        completionHandler((BkmxDoc*)document, documentWasAlreadyOpen, error) ;
    }
}

- (SSYAlert *)preOpenUrl:(NSURL *)url
       completionHandler:(void(^)(
                                  BkmxDoc *document,
                                  BOOL documentWasAlreadyOpen,
                                  NSError *error
                                  ))completionHandler {
    BOOL alreadyOpen = NO ;
    for (NSDocument* document in [self documents]) {
        if ([[document fileURL] isEqual:url]) {
            alreadyOpen = YES ;
            break ;
        }
    }

    //SSYAlert must be worked on the main thread.
    NSAssert([[NSThread currentThread] isMainThread], @"Internal Error 524-9593") ;
    SSYAlert* alert = nil ;
    if (!alreadyOpen) {
        alert = [SSYAlert alert] ;
        [alert setShowsProgressBar:YES] ;
        [alert setIndeterminate:YES] ;
        /* If CA_ASSERT_MAIN_THREAD_TRANSACTIONS is set to 1 in environment,
         the following line raises assertion from "CoreAnimation" saying
         "an implicit transaction wasn't created on a main thread." */
        [alert setProgressBarShouldAnimate:YES] ;
        [alert setSmallTextAlignment:NSTextAlignmentCenter] ;
        [alert setSmallText:[[NSString localizeFormat:
                              @"loadingWhat",
                              [[url path] lastPathComponent]] ellipsize]] ;
        [alert display] ;

        [self addTimeoutterForUrl:url
                            alert:alert
                completionHandler:completionHandler];
    }

    return alert;
}

- (void)raiseIsNotFileUrlErrorWithCompletionHandler:(void (^)(BkmxDoc *, BOOL, NSError *))completionHandler
                                                url:(NSURL *)url {
    NSString* msg = [NSString stringWithFormat:
                     @"Not a file URL: %@",
                     [url absoluteString]] ;
    NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              msg, NSLocalizedDescriptionKey,
                              [[NSProcessInfo processInfo] geekyProcessInfo], @"Process Info",
                              nil] ;
    NSError* error = [NSError errorWithDomain:BkmxDocumentControllerErrorDomain
                                         code:153801
                                     userInfo:userInfo] ;
    // Document -openDocumentWithContentsOfURL:display:completionHandler:
    // says we must be on the main thread when invoking completion handler.
    NSAssert([[NSThread currentThread] isMainThread], @"Internal Error 526-9595") ;
        if (completionHandler) {
            completionHandler(nil, NO, error) ;
        }
}

- (void)openDocumentWithContentsOfURL:(NSURL*)url
                              display:(BOOL)display
                    completionHandler:(void (^)(BkmxDoc* document,
                                                BOOL documentWasAlreadyOpen,
                                                NSError* error))completionHandler {
    SSYAlert* __block alert = nil ;
    /*  In BkmkMgrs 2.9.15 or later, I'm pretty sure we are always on the main
     thread here.  But just in case of a unknown edge case, I left in the non-
     main-thread code.  (The SSYAlert business in preOpenUrl: must be worked
     on the main thread.)  */
    if ([[NSThread currentThread] isMainThread]) {
        [[BkmxBasis sharedBasis] logFormat:@"Begin preopen (main q) %@", url.path];
        alert = [self preOpenUrl:url
               completionHandler:completionHandler];
        [[BkmxBasis sharedBasis] logFormat:@"End preopen (main q) %@", url.path];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[BkmxBasis sharedBasis] logFormat:@"Begin preopen (secy q) %@", url.path];
            alert = [self preOpenUrl:url
                   completionHandler:completionHandler];
            [[BkmxBasis sharedBasis] logFormat:@"End preopen (secy q) %@", url.path];
        });
    }

    /* If an AppleScripter 'tells' us to 'open' a non-file URL, stupid Cocoa
    will raise an exception and stop executing instead of returning an error,
    which will leave our progress alert window up.  Arghhh.
    So we need to test for that and make our own error.

     Update 2017-07-19.  Testing with macOS 10.12.6, I no longer know how to
     reproduce this issue, so maybe this test for file URL is no longer
     necessary.  The obvious, executing the following AppleScript:
     • set aDoc to "NoDoc"
     • tell application "BookMacster"
     •    set aDoc to open document "http://apple.com"
     • end tell
     • log (aDoc)
     does not invoke this method.  It just thinks for a few seconds and then
     says that aDoc is not defined.  */
	if ([url isFileURL]) {
        [alert retain];
        /* We retain the alert to prevent later crash, as explained here:
         https://stackoverflow.com/questions/17384599/why-are-block-variables-not-retained-in-non-arc-environments
         http://www.mikeash.com/pyblog/friday-qa-2009-08-14-practical-blocks.html */
        dispatch_queue_t aSerialQueue = dispatch_queue_create(
                                                              "com.sheepsystems.BkmkMgrs.openingDocument",
                                                              DISPATCH_QUEUE_SERIAL
                                                              ) ;

        dispatch_async(aSerialQueue, ^{
            if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
                [[BkmxBasis sharedBasis] logFormat:@"Begin opening %@", url.path];
            }

            sleep(SLEEP_SECONDS_FOR_FAKING_DOCUMENT_OPENING_FAILURE);
            /* I'm not sure why, but even if we are on a secondary thread,
            `super` NSDocumentController calls the completion handler of the
             following method on the main thread. */

            [super openDocumentWithContentsOfURL:url
                                         display:display
                               completionHandler:^(NSDocument *document,
                                                   BOOL documentWasAlreadyOpen,
                                                   NSError* error) {
                                   if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
                                       [[BkmxBasis sharedBasis] logFormat:@"Finished opening %@", url.path];
                                   }
                                   [self finishOpeningUrl:url
                                                  display:display
                                                    alert:alert
                                        completionHandler:completionHandler
                                                 document:document
                                           wasAlreadyOpen:documentWasAlreadyOpen
                                                    error:error];
                               }];
        });
	}
	else {
        [self raiseIsNotFileUrlErrorWithCompletionHandler:completionHandler
                                                      url:url];
	}
}


/*
 @details  According to Apple documentation of
 -[NSDocumentController openDocumentWithContentsOfURL:display:completionHandler:],
 if we override that method, as we do, we should override this method to do
 much of the same.  So here it is.

 This method is called if app is killed or crashes, by what I think is called
 Cocoa's "state restoration" mechanism, instead of
 openDocumentWithContentsOfURL:display:completionHandler:.

 In Apple's
 https://developer.apple.com/library/archive/documentation/DataManagement/Conceptual/DocBasedAppProgrammingGuideForOSX/
 Document-Based App Programming Guide for Mac
    Core App Behaviors
       Windows Are Restored Automatically
 https://developer.apple.com/library/archive/documentation/DataManagement/Conceptual/DocBasedAppProgrammingGuideForOSX/StandardBehaviors/StandardBehaviors.html#//apple_ref/doc/uid/TP40011179-CH5-SW8
 this method is not mentioned at all.  It says that the work is done by these
 -restoreWindow…::: and -restoreStateWithCoder:.  That's weird, and, I think,
 wrong, and note that it also says, in
 Document-Based App Programming Guide for Mac
     Introduction
 the following:
 "Important: This document is no longer being updated."

 I find that if I kill this app, then relaunch, this method runs, but it is
 passed displayDocument:NO.  Not helpful!!  I can fix that, of course, and
 I did in the dead code below, and indeed that causes the document window
 to display.  But even though I call -preOpenUrl:, my SSYAlert with
 "Processing…" does not display.

Then there is the fact that I effectively have my own user-controlled
 state restoration mechanism for documents, namely the Setting
 "Open this document when <app-name> launches".

 So, I say to hell with this.  Starting with BkmkMgrs 2.9.4, I run the
 completion handler if any with error = a Cocoa "user cancelled" error,
 and just return without invoking super.

 I have tested this with the checkbox in System Preferences > General >
 "Close windows when quitting an app" both OFF and ON and it works fine.
 */
- (void)reopenDocumentForURL:(NSURL *)urlOrNil
           withContentsOfURL:(NSURL*)contentsURL
                     display:(BOOL)displayDocument
           completionHandler:(void (^)(NSDocument *document,
                                       BOOL documentWasAlreadyOpen,
                                       NSError *error))completionHandler; {
    if (completionHandler) {
        NSError* weDontNeedNoStinkinStateRestoration = [NSError errorWithDomain:NSCocoaErrorDomain
                                                                           code:NSUserCancelledError
                                                                       userInfo:nil];
        completionHandler(nil, NO, weDontNeedNoStinkinStateRestoration);
    }

    [[BkmxBasis sharedBasis] logFormat:@"Ignoring Cocoa's -reopenDoc… for %@", urlOrNil.lastPathComponent];
}

// Code removed from reopenDocumentForURL:::: in BkmkMgrs 2.9.4
//    // See explanation in comment above this implementation.
//    if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
//        displayDocument = YES;
//    }
//
//    SSYAlert* __block alert = nil ;
//    /* I don't know if this method might be on a secondary thread, but
//     SSAlert cannot be. */
//    if ([[NSThread currentThread] isMainThread]) {
//        alert = [self preOpenUrl:urlOrNil
//               completionHandler:completionHandler];
//    } else {
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            alert = [self preOpenUrl:urlOrNil
//                   completionHandler:completionHandler];
//        });
//    }
//
//    [alert retain];
//    /* We retain the alert to prevent later crash, as explained here:
//     https://stackoverflow.com/questions/17384599/why-are-block-variables-not-retained-in-non-arc-environments
//     http://www.mikeash.com/pyblog/friday-qa-2009-08-14-practical-blocks.html */
//
//    dispatch_queue_t aSerialQueue = dispatch_queue_create(
//                                                          "com.sheepsystems.BkmkMgrs.reopenDocument",
//                                                          DISPATCH_QUEUE_SERIAL
//                                                          ) ;
//    dispatch_async(aSerialQueue, ^{
//        if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
//            [[BkmxBasis sharedBasis] logFormat:@"Begin reopening on main queue %@", urlOrNil.path];
//        }
//
//        sleep(SLEEP_SECONDS_FOR_FAKING_DOCUMENT_OPENING_FAILURE);
//        [super reopenDocumentForURL:urlOrNil
//                  withContentsOfURL:contentsURL
//                            display:displayDocument
//                  completionHandler:^(NSDocument *document,
//                                      BOOL documentWasAlreadyOpen,
//                                      NSError* error) {
//                      if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
//                          [[BkmxBasis sharedBasis] logFormat:@"Finished reopening on main queue %@", urlOrNil.path];
//                      }
//                      [self finishOpeningUrl:urlOrNil
//                                     display:displayDocument
//                                       alert:alert
//                           completionHandler:completionHandler
//                                    document:document
//                              wasAlreadyOpen:documentWasAlreadyOpen
//                                       error:error];
//                  }] ;
//    });

- (NSString*)uuidListFromError:(NSError*)error {
    NSMutableString* uuidList = nil ;
    for (NSString* uuid in [[error userInfo] objectForKey:constKeyAvailableDocAliasUuids]) {
        if (!uuidList) {
            uuidList = [[NSMutableString alloc] init] ;
        }
        else {
            [uuidList appendString:@","] ;
        }
        [uuidList appendString:[uuid substringToIndex:MIN(4, [uuid length])]] ;
    }
    
    NSString* answer ;
    if (uuidList) {
        answer = [[uuidList copy] autorelease] ;
    }
    else {
        answer = @"<EMPTY>" ;
    }
    [uuidList release] ;

    return answer ;
}

- (NSUInteger)maximumRecentDocumentCount {
    NSInteger answer ;
    if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
        // This is so that BkmxAgent does not write file
        // ~/Library/Preferences/com.sheepsystems.BkmxAgent.LSSharedFileList.plist
        answer = [super maximumRecentDocumentCount] ;
    }
    else {
        answer = 0 ;
    }
    
    return answer ;
}


- (NSString*)pathOfDocumentWithUuid:(NSString*)uuid
                            appName:(NSString*)appName
							timeout:(NSTimeInterval)timeout
                             trials:(NSInteger)trials
                              delay:(NSInteger)delay
							error_p:(NSError**)error_p {
    NSError* underlyingError = nil ;
    NSInteger errorCode = 0 ;
    NSString* errorDescription = nil ;
    NSString* path = nil ;
    NSMutableDictionary* errorUserInfo = [NSMutableDictionary new];

    NSSet* appNames;
    BOOL reportErrorsAggressively;
    if (appName) {
        appNames = [NSSet setWithObject:appName];
        reportErrorsAggressively = YES;
    } else {
        appNames = [[BkmxBasis sharedBasis] agentableAppNames];
        reportErrorsAggressively = NO;
    }

    NSDictionary* aliasRecordsDic = nil;
    for (NSString* appName in appNames) {
        NSString* applicationId = [BkmxBasis appIdentifierForAppName:appName] ;
        aliasRecordsDic = (NSDictionary*)[[NSUserDefaults standardUserDefaults] syncAndGetValueForKey:constKeyDocAliasRecords
                                                                                        applicationId:applicationId];
        NSData* aliasRecord = nil ;
        if (aliasRecordsDic) {
            // Check for corrupt pref before sending message
            if ([aliasRecordsDic respondsToSelector:@selector(objectForKey:)]
                && [aliasRecordsDic respondsToSelector:@selector(count)]
                && [aliasRecordsDic respondsToSelector:@selector(allKeys)]) {
                aliasRecord = [aliasRecordsDic objectForKey:uuid] ;
                if (aliasRecord) {
                    NSDate* startDate = [NSDate date] ;
                    NSInteger nTrials = 0 ;
                    if (trials < 1) {
                        trials = 1 ;
                    }
                    if (delay < 1) {
                        delay = 1 ;
                    }
                    while (!path && (nTrials < trials)) {
                        path = [aliasRecord pathFromAliasRecordWithTimeout:timeout
                                                                   error_p:&underlyingError] ;
                        nTrials++ ;
                        if (!path) {
                            sleep((unsigned int)delay) ;
                        }
                    }
                    if (path) {
                        if (nTrials > 1) {
                            NSTimeInterval elapsed = -[startDate timeIntervalSinceNow] ;
                            NSString* msg = [NSString stringWithFormat:
                                             @"Took %ld trials, total %0.2f secs, to resolve %@ to %@",
                                             (long)nTrials,
                                             elapsed,
                                             [uuid substringToIndex:4],
                                             path] ;
                            NSLog(@"Warning 513-4911 %@", msg) ;
                            [[BkmxBasis sharedBasis] logString:msg] ;
                        }
                    }
                    else if (reportErrorsAggressively) {
                        errorCode = 519881 ;
                        errorDescription = [NSString stringWithFormat:
                                            @"macOS could not provide name nor path from alias record for .bmco file whose uuid=%@",
                                            uuid] ;
                        if (aliasRecord) {
                            [errorUserInfo setObject:aliasRecord
                                              forKey:@"Alias Record"] ;
                        }
                    }
                    
                    break;
                }
                else if (reportErrorsAggressively) {
                    errorCode = 519880 ;
                    errorDescription = [NSString stringWithFormat:
                                        @"No alias record among %ld for document whose uuid=%@",
                                        (long)[aliasRecordsDic count],
                                        uuid];
                    [errorUserInfo setObject:[aliasRecordsDic allKeys]
                                      forKey:@"Found Doc UUIDs"];
                }
            } else if (reportErrorsAggressively) {
                errorCode = 519882;
                errorDescription = @"Bad doc alias records";
                [errorUserInfo setValue:[aliasRecordsDic className]
                                 forKey:@"Alias Records Class Name"];
            }
        } else if (reportErrorsAggressively) {
            errorCode = 519883;
            errorDescription = @"Nil doc alias records";
            /*
             User Chris R. got this error with BookMacster 2.10.18 on
             20200318.  It was from BookMacster main app.  appNames contained
             only 1 item, BookMacster.  Using macOS 10.14.6.
             
             User Jay G. got this error with BookMacster 2.10.28 on
             20200927.  It was from BkmxAgent.  appNames contained
             only 1 item, BookMacster.  Using macOS 10.14.6.  He said it
             occurred after he had "wiped" some stuff.
             */
        }
        if (aliasRecord) {
            break;
        }
    }


	if ((errorCode != 0) && (error_p != NULL)) {
        [errorUserInfo setValue:errorDescription
                         forKey:NSLocalizedDescriptionKey] ;
        [errorUserInfo setValue:underlyingError
                         forKey:NSUnderlyingErrorKey] ;
        [errorUserInfo setValue:[aliasRecordsDic allKeys]
                         forKey:constKeyAvailableDocAliasUuids] ;
        [errorUserInfo setValue:appName
                         forKey:constKeyAppName];
        [errorUserInfo setValue:appNames
                         forKey:@"Searched app names"];

		*error_p = [NSError errorWithDomain:BkmxDocumentControllerErrorDomain
									   code:errorCode
								   userInfo:errorUserInfo] ;
	}

    [errorUserInfo release];

	return path ;
}

- (BOOL)attemptRecoveryFromError:(NSError*)error
				  recoveryOption:(NSUInteger)recoveryOption {
    switch (recoveryOption) {
        case NSAlertFirstButtonReturn:
            // "New"
            // A new document will be created by other methods
            break ;
        case NSAlertSecondButtonReturn:
            // "Quit"
            [[NSApplication sharedApplication] terminate:self] ;
            break ;
        default:
            break ;
    }

	return YES ;
}


- (void)postOpenDocWithUrl:(NSURL*)url
                   bkmxDoc:(BkmxDoc*)bkmxDoc
                      path:(NSString*)path
                      uuid:(NSString*)uuid
                   timeout:(NSTimeInterval)timeout
    documentWasAlreadyOpen:(BOOL)documentWasAlreadyOpen
                     error:(NSError*)error
         completionHandler:(void (^)(BkmxDoc*,
                                     NSURL*,
                                     BOOL,
                                     NSError*))completionHandler {
    BOOL appIsObsolete = [self indicatesNoDataModelError:error];
    NSURL* resolvedUrl = nil ;

   if (path) {
       if (bkmxDoc) {
           // success
           resolvedUrl = url ;
        }
        else {
            // path but no document
            NSString* desc = [NSString stringWithFormat:@"Could not open document at %@", [url path]];
            error = [SSYMakeError(519892, desc) errorByAddingUnderlyingError:error];
        }
    } else {
        /* No path, and presumably no document.  The caller will have provided
         an informative error. */
    }

    if (!bkmxDoc && !appIsObsolete) {
        if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
            // Do two or three of the four things which are necessary to completely forget a document.
            // The fourth thing, trashing local data files, will be done after
            // 62 days by -cleanOrphanedLocalData.
            [[NSUserDefaults standardUserDefaults] forgetDocumentUuid:uuid] ;
            [(BkmxAppDel*)[NSApp delegate] removeSyncersForDocumentUuid:uuid] ;

            // A third thing, forgetting the recent document URL, will be done by Cocoa.

            [[BkmxBasis sharedBasis] logFormat:@"Forgot-Doc-2 %@", [uuid substringToIndex:4]] ;
        }
        else {
            /* We are in BkmxAgent, so we want to be less aggressive about
             removing stuff. */
        }
    }
    
    if (error) {
        if ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppBookMacster) {
            NSString* suggestion = @"Either ignore this error if you have discarded the document, or determine what happened to it and restore it." ;
            error = [error errorByAddingLocalizedRecoverySuggestion:suggestion] ;
        }
        else {
            // This is one of the shoebox apps
            error = [error errorByAddingRecoveryAttempter:self] ;
            NSString* optionNew = [[BkmxBasis sharedBasis] labelNew] ;
            NSString* optionQuit = [[BkmxBasis sharedBasis] labelQuit] ;
            NSString* suggestion = [NSString stringWithFormat:
                                    @"If you want to start over from scratch, click %@.\n\n"
                                    @"If you want to restore the missing file, click %@, restore it, then relaunch %@.",
                                    optionNew,
                                    optionQuit,
                                    [[BkmxBasis sharedBasis] appNameLocalized]] ;
            error = [error errorByAddingLocalizedRecoverySuggestion:suggestion] ;
            NSArray* shoeboxRecoveryOptions = [NSArray arrayWithObjects:
                                               optionNew,
                                               optionQuit,
                                               nil] ;
            error = [error errorByAddingLocalizedRecoveryOptions:shoeboxRecoveryOptions] ;
        }
        
        error = [error errorByAddingUserInfoObject:[NSNumber numberWithDouble:timeout]
                                            forKey:@"Total Timeout"] ;
    }
    
   if (completionHandler) {
        completionHandler(bkmxDoc, resolvedUrl, documentWasAlreadyOpen, error) ;
    }
}

- (void)openDocumentWithUuid:(NSString*)uuid
                     appName:(NSString*)appName
                     display:(BOOL)display
              aliaserTimeout:(NSTimeInterval)aliaserTimeout
           completionHandler:(void(^)(BkmxDoc*,
                                      NSURL*,
                                      BOOL,
                                      NSError*))completionHandler {
    NSError* error = nil ;
    if (uuid) {
#define DELAY_SECONDS 1
#define TRIALS 2
        NSTimeInterval trialTimeout = ((aliaserTimeout-DELAY_SECONDS)/TRIALS) ;
        if (trialTimeout < 1.0) {
            trialTimeout = 1.0 ;
        }
        
        NSString* path = [self pathOfDocumentWithUuid:uuid
                                              appName:appName
                                              timeout:trialTimeout
                                               trials:TRIALS
                                                delay:DELAY_SECONDS
                                              error_p:&error];
        
        if (path) {
            /* Starting with BkmkMgrs 2.10.4, before opening the document,
             we peek into its auxiliary data and verify that the document
             uuid in there is the uuid we specified.  I have seen it happen
             that, if a document at a certain path has disappeared, the
             system file alias resolution mechanism employed by
             pathOfDocumentWithUuid:::::: will open a different document
             which happens to be at the path, probably using the "backup"
             path which is included in a document alias.
             
             This may be a desirable fallback for some apps, but it is *not*
             what we want when opening a document specified by its uuid.  In
             particular, when user activates syncing in Synkmark, we run method
             -[NSUserDefaults removeAllSyncingExceptDocUuid:] which cleans up
             any syncing from old .bmco documents.  If we still have
             a Settings-*.sql file pertaining to an old Synkmark.bmco file on
             disk, but that old Synkmark.bmco file has been deleted from the
             trash, the system will give us the current Synkmark.bmco
             document, and we will kill the syncing which the user had just
             activated milliseconds earlier.  Very bad!  Took me several hours
             to figure out what was going on :(
             */
            NSString* uuidFromDisk = [BkmxDoc uuidOfDocumentWithUrl:[NSURL fileURLWithPath:path]];
            if ([uuidFromDisk isKindOfClass:[NSString class]]) {
                if ([uuidFromDisk isEqualToString:uuid]) {
                    NSURL* url = [NSURL fileURLWithPath:path];
                    [[BkmxDocumentController sharedDocumentController] openDocumentWithContentsOfURL:url
                                                                                             display:display
                                                                                   completionHandler:^(
                                                                                                       NSDocument* bkmxDoc,
                                                                                                       BOOL documentWasAlreadyOpen,
                                                                                                       NSError* openingError) {
                                                                                                           [self postOpenDocWithUrl:url
                                                                                                                            bkmxDoc:(BkmxDoc*)bkmxDoc
                                                                                                                               path:path
                                                                                                                               uuid:uuid
                                                                                                                            timeout:aliaserTimeout  // only for adding to userInfo if error
                                                                                                             documentWasAlreadyOpen:documentWasAlreadyOpen
                                                                                                                              error:openingError
                                                                                                                  completionHandler:completionHandler] ;
                                                                                                       }] ;
                } else {
                    NSString* errorDesc = [NSString stringWithFormat:
                                           @"Found UUID %@, expected %@, in document at path %@",
                                           uuidFromDisk,
                                           uuid,
                                           path];
                    error = [SSYMakeError(523495, errorDesc) errorByAddingUnderlyingError:error];
                    error = [error errorByAddingUserInfoObject:uuid
                                                        forKey:@"Expected UUID"];
                    error = [error errorByAddingUserInfoObject:uuidFromDisk
                                                        forKey:@"Actual UUID"];
                }
            }
        } else {
            NSString* errorDesc = [NSString stringWithFormat:
                                   @"Failed to resolve path for document %@",
                                   [uuid substringToIndex:4]];
            error = [SSYMakeError(523499, errorDesc) errorByAddingUnderlyingError:error];
        }
    } else {
        error = SSYMakeError(125905, @"No doc UUID requested") ;
    }

    if (error) {
        [self postOpenDocWithUrl:nil
                         bkmxDoc:nil
                            path:nil
                            uuid:uuid
                         timeout:aliaserTimeout  // only for adding to userInfo if error
          documentWasAlreadyOpen:NO
                           error:error
               completionHandler:completionHandler];
    } else {
        /* -[BkmxDocumentController openDocumentWithContentsOfURL:display:completionHandler:]
         was invoked and postOpenDocWithUrl:::::::: will be called by its
         completion handler. */
    }
}

- (IBAction)showSyncerssOfDocsAtIndexes:(NSIndexSet*)indexes
                                   info:(NSDictionary*)info {
	NSArray* aliasRecords = [info objectForKey:constKeyAliasRecords] ;
	NSInteger index = [indexes firstIndex] ;
	if (index >= [aliasRecords count]) {
		return ;
	}
	
	NSData* aliasRecord = [aliasRecords objectAtIndex:index] ;
	NSError* error = nil ;
	NSString* path = [[SSYCachyAliasResolver sharedResolver] pathFromAlias:aliasRecord
																  useCache:NO
																   timeout:20.0
																  lifetime:10.0
																   error_p:&error] ;
	if (!path) {
		NSString* msg = @"Could not find file (resolve path) for Collection containing this agent." ;
		error = [SSYMakeError(153835, msg) errorByAddingUnderlyingError:error] ;
		error = [error errorByAddingUserInfoObject:aliasRecord
											forKey:@"AliasRecord"] ;
		[SSYAlert alertError:error] ;
		return ;
	}
	
	NSURL* url = [NSURL fileURLWithPath:path] ;
    [self openDocumentWithContentsOfURL:url
                                display:YES
                      completionHandler:^(BkmxDoc* bkmxDoc,
                                          BOOL documentWasAlreadyOpen,
                                          NSError* error) {
                          if (bkmxDoc) {
                              [bkmxDoc revealTabViewIdentifier:constIdentifierTabViewSyncing] ;
                          }
                          else {
                              NSString* msg = [NSString stringWithFormat:
                                               @"Could not show Syncer, because could not open document at path %@",
                                               path] ;
                              error = [SSYMakeError(897218, msg) errorByAddingUnderlyingError:error] ;
                              [SSYAlert alertError:error] ;
                          }
                      }] ;
}

#define N_DIGITS_IN_SEQUENCE_NUMBER 2

- (NSString *)pathForShoeboxDocuments {
    NSString* path = [[NSBundle mainAppBundle] applicationSupportPathForMotherApp] ;
    return path;
}

- (NSString*)defaultDocumentFolderError_p:(NSError**)error_p {
    NSString * path = [self pathForShoeboxDocuments];
    if ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppBookMacster) {
        path = [path stringByAppendingPathComponent:@"Collections"] ;
    }

    BOOL ok = [[NSFileManager defaultManager] ensureDirectoryAtPath:path
                                                            error_p:error_p] ;
	return (ok ? path : nil) ;
}	

- (NSString *)nextDefaultFilenameError_p:(NSError**)error_p {
	NSFileManager* fileManager = [NSFileManager defaultManager] ;
	NSString* path = [self defaultDocumentFolderError_p:error_p] ;
	
	NSString* filename = nil ;
	if (path) {
		NSError* error = nil ;
		NSArray* filenames = [fileManager contentsOfDirectoryAtPath:path
															  error:&error] ;
		if (error) {
			// Note: -[NSFileManager contentsOfDirectoryAtPath:] returns error NSFileReadNoSuchFileError
			// in NSCocoaErrorDomain if the given path is not found.  That should never happen here.
			NSLog(@"Internal Error 928-2852 %@", error) ;
		}
		NSString* baseName = NSUserName() ;
		NSString* extension = [self defaultDocumentFilenameExtension] ;
		NSInteger extensionLength = [extension length] ;
		NSInteger nameLength = [baseName length] ;
		NSInteger sequenceStringLocation = nameLength + 1 ; // 1 is for the space character
		NSInteger wholeLength = sequenceStringLocation + N_DIGITS_IN_SEQUENCE_NUMBER + 1 + extensionLength ;  // 1 is for the "dot"
		NSInteger highestSequenceNumber = 0 ;
		NSRange sequenceStringRange = NSMakeRange(sequenceStringLocation, N_DIGITS_IN_SEQUENCE_NUMBER) ;
		for (filename in filenames) {
			if ([filename length] == wholeLength) {
				if ([filename hasPrefix:baseName]) {
					NSString* sequenceNumberString = [filename substringWithRange:sequenceStringRange] ;
					NSInteger sequenceNumber = [sequenceNumberString intValue] ;
					highestSequenceNumber = MAX(highestSequenceNumber, sequenceNumber) ;
				}
			}
		}
		
		// highestSequenceNumber is now the highest number that exists on disk.
		// But what if there is a higher-numbered document in memory that has not been saved yet?
		highestSequenceNumber = MAX(highestSequenceNumber, [self lastIssuedDocumentSequenceNumber]) ;
		
		NSInteger nextSequenceNumber = highestSequenceNumber + 1 ;
		[self setLastIssuedDocumentSequenceNumber:nextSequenceNumber] ;
		NSString* formatString = [NSString stringWithFormat:
								  @"%%@-%%0%dld",
								  N_DIGITS_IN_SEQUENCE_NUMBER] ;
		filename = [NSString stringWithFormat:
					formatString,
					baseName,
					(long)nextSequenceNumber] ;
	}

	return filename;
}

- (NSURL*)nextDefaultDocumentUrl {
	NSError* error = nil ;

	NSString* filename = [self nextDefaultFilenameError_p:&error];

	NSURL* url = nil ;
	if (filename) {
		NSString* path = [self defaultDocumentFolderError_p:&error] ;
		path = [path stringByAppendingPathComponent:filename] ;
		NSString* extension = [self defaultDocumentFilenameExtension] ;
		path = [path stringByAppendingPathExtension:extension] ;
		url = [NSURL fileURLWithPath:path] ;
	}
	
	if (!url) {
		// This is not enough to bother the user with, because the system will
		// choose a default file.  So we just log it.
		NSLog(@"%@", [error longDescription]) ;
	}

	return url ;
}

- (BOOL)validateMenuItem:(NSMenuItem *)item {
	BOOL answer ;
	
	if ([item action] == @selector(saveAllDocuments:)) {
		answer = NO ;
		
		for (NSDocument* doc in [self documents]) {
			if ([doc isDocumentEdited]) {
				answer = YES ;
				break ;
			}
		}
	}
	else {
		answer = [super validateMenuItem:item] ;
	}
	
	return answer ;
}

- (NSError *)willPresentError:(NSError *)error {
	// Because I find Apple's error presentation to be unsightly and
	// useless, I present the error using my own method.

    // This section was added in BookMacster 1.12.9, to try and get some
    // more info on some of these inexplicable 134030 errors I'm geting
    // from users
    if ([error involvesCode:134030
                     domain:NSCocoaErrorDomain]) {
        error = [SSYMakeError(134431, @"Error from macOS : Core Data.  Please click the life preserver icon over to your left.")
                 errorByAddingUnderlyingError:error] ;
        error = [error errorByAddingBacktrace] ;
    }
    
    if ([error involvesCode:67001
                     domain:NSCocoaErrorDomain]) {
        /* This occurs during a "Save As" aka "Duplicate" operqation when
         proposing tp overwrite an existing file of the same name.  After this
         early return, Cocoa will show a sheet asking user to afffirm the overwrite */
        return error;
        /* Before Bkmkgrs 3.3.2, we would present the error in our own dialog.  In
         macOS 26 Tahoe, this would cause the following dreaded inscrutable log
         entries when the user clicked the "Replace" button:
         
         -continueFileAccessUsingBlock: was invoked without an outer file access! File access performed inside this block is not safe!
         
         FAULT: NSInternalInconsistencyException: *** -[BkmxDoc _fileAccessStabilizedFileURL]: invoked outside of file access; {
             NSAssertFile = "NSDocument_SerializationAPIs.m";
             NSAssertLine = 849;
         
         *** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: '*** -[BkmxDoc _fileAccessStabilizedFileURL]: invoked outside of file access'
         terminating due to uncaught exception of type NSException
         */
    }
    
	[SSYAlert alertError:error] ;
	
	/* From Apple's "Document-Based Applications Overview":
	 > If you override such a method to prevent some action, but you don't  
	 > want an error alert to be presented to the user, return an error  
	 > object whose domain is NSCocoaErrorDomain and whose code is  
	 > NSUserCancelledError. The Application Kit presents errors through  
	 > the NSApplication implementations of the presentError: and  
	 > presentError:modalForWindow:delegate:didPresentSelector:contextInfo: m 
	 > ethods declared by NSResponder. Those implementations silently  
	 > ignore errors whose domain is NSCocoaErrorDomain and whose code is  
	 > NSUserCancelledError.
	 */
	return [NSError errorWithDomain:NSCocoaErrorDomain
							   code:NSUserCancelledError
						   userInfo:nil]  ;
}

- (void)addDocument:(NSDocument*)document {
    [super addDocument:document] ;

    /* At this time (BookMacster 1.22.14) no one is registered to receive this
     notification but oh well */
    [[NSNotificationCenter defaultCenter] postNotificationName:SSYUndoManagerDocumentDidOpenNotification
														object:document] ;
    
}

/* @details   This method only runs if a document is opened by
 state restoration during relaunch after app has been abruptly terminated
 or crashed, that always happens last, long after this point.

 In this case (state restoration), this method runs
 *way* after the welcome is checked for (if there were no delay).  See comments
 before -[BkmxAppDel showWelcomeOrShoeboxOrNothingDelayed] for more info.

 When user clicks File > Duplicate, this method is called from
 -[NSDocumentController duplicateDocumentWithContentsOfURL:copying:displayName:error:]
 with url = nil.  But I guess we still needs invoke super.  So we still run
 the method but check for nil url at several places.

By the way, this method runs on a secondary thread, although, oddly, unlike
 -openDocumentWithContentsOfURL:display:completionHandler:, it does its work
 synchronously. */
- (NSDocument*)makeDocumentForURL:(NSURL*)url
                withContentsOfURL:(NSURL*)contentsURL
                           ofType:(NSString*)typeName
                            error:(NSError**)error_p {
    self.haveADoc = YES;
	NSString* msg = [self fixLaunchServicesBugForUrl:url
                                            otherUrl:contentsURL
                                          typeName_p:&typeName];
    [[BkmxBasis sharedBasis] logString:msg];

    NSDocument* document;

    BOOL isAlreadyOpenOrOpening = NO;
    if (url) {
        if (![self isTimeoutInProcessForUrl:url]) {
            for (NSDocument* document in [self documents]) {
                NSURL* aUrl = [document fileURL] ;
                if ([aUrl isEqual:url]) {
                    isAlreadyOpenOrOpening = YES;
                    break;
                }
            }
        }
    }

    if (isAlreadyOpenOrOpening) {
        /* Today, 20171114, I saw it happen that, during launch, presumably as
         part of state restoration, after a crash, Cocoa invoked this method
         twice with the same URL.  That caused 1-3 problems during the launch,
         and part of the fix was to check for URLs already open/ing and abort
         the method by taking this branch. */
        if (error_p) {
            /* I never got to to test this, but generally if you want to hide
             an error from the user in Cocoa you make it like so: */
            *error_p = [NSError errorWithDomain:NSCocoaErrorDomain
                                           code:NSUserCancelledError
                                       userInfo:nil];
        }

        document = nil;;
    } else {

        document = [super makeDocumentForURL:url
                           withContentsOfURL:contentsURL
                                      ofType:typeName
                                       error:error_p];
    }

    return document;
}

- (id)makeDocumentWithContentsOfURL:(NSURL*)url
							 ofType:(NSString*)typeName
							  error:(NSError**)error_p {
    self.haveADoc = YES;
    NSString* msg = [self fixLaunchServicesBugForUrl:url
                                            otherUrl:nil
                                          typeName_p:&typeName];
    if (msg) {
        [[BkmxBasis sharedBasis] logString:msg];
    }

    NSError* error = nil ;
	id doc = [super makeDocumentWithContentsOfURL:url
										   ofType:typeName
											error:&error] ;
	
	if (error && error_p) {
		*error_p = error ;
	}

	return doc ;
}

- (NSDocument*)duplicateDocumentWithContentsOfURL:(NSURL*)url
										  copying:(BOOL)duplicateByCopying
									  displayName:(NSString*)displayNameOrNil
											error:(NSError **)outError {
	[self setIsDuplicating:YES] ;
    /* Tell Deploymate to ignore the fact that the following call, although not
     available in macOS 10.6-, is OK because we are already in that method, and
     therefore would not be here if we were operating in 10.6- */
	NSDocument* doc = [super duplicateDocumentWithContentsOfURL:url
														copying:duplicateByCopying
													displayName:displayNameOrNil
														  error:outError] ;
	[self setIsDuplicating:NO] ;
	return doc ;
}

- (BkmxDoc*)makeUntitledDocumentWithSuggestedName:(NSString*)suggestedName
										 display:(BOOL)display
										 error_p:(NSError**)error_p {
	NSError* error = nil ;
	BkmxDoc* bkmxDoc = nil ;
	
#if 0
#warning Not displaying document
	display = NO ;
#endif

    bkmxDoc = [super openUntitledDocumentAndDisplay:display
											 error:&error] ;
	// For a long time, I had this problem where if I set display:YES above,
	// some of the controls in the Settings tab of the main window, in
	// particular the list rows in Sync In/Out, would not get populated.
	// Why didn't they receive KVO notifications and populate when
	// importer and exporter are added, below?
	// To work around this problem, I display:NO here and THEN
	// displayed later.
	// Later, I found that this was not necessary.
	// Just a note in case the problem comes back.
	
	if (!bkmxDoc) {
		error = [SSYMakeError(constBkmxErrorCouldNotCreatePersistentDocument, @"Could not create persistent document") errorByAddingUnderlyingError:error] ;
		goto end ;
	}

end:
	// The automatic (on open) actions should not be performed on a new document.
	[bkmxDoc setSkipAutomaticActions:YES] ;
	
	if (error && error_p) {
		*error_p = error ;
	}
	
	return bkmxDoc ;
}

- (void)forgetDocumentUrl:(NSURL*)url {
	NSError* error = nil ;
    NSString* uuid = nil ;
    NSString* targetPath = [url path] ;
    if (targetPath != nil) {
        NSDictionary* aliasRecords = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppValueForKey:constKeyDocAliasRecords] ;
        for (NSString* aUuid in aliasRecords) {
            NSData* aliasData = [aliasRecords objectForKey:aUuid] ;
            NSString* path = [[SSYCachyAliasResolver sharedResolver] pathFromAlias:aliasData
                                                                          useCache:YES
                                                                           timeout:3.0
                                                                          lifetime:10.0
                                                                           error_p:&error] ;
            if (!path) {
                NSLog(@"Warning 624-3840 %@ %@", url, error) ;
            }
            if ([path isEqualToString:targetPath]) {
                uuid = aUuid ;
                break ;
            }
        }
    }

	// Do two of the four things which are necessary to completely forget a document
    // The fourth thing, trashing local data files, will be done after
    // 62 days by -cleanOrphanedLocalData.
	[[NSUserDefaults standardUserDefaults] forgetDocumentUuid:uuid] ;
    [[BkmxBasis sharedBasis] logFormat:@"Forgot-Doc-1 %@", [uuid substringToIndex:4]] ;
	[(BkmxAppDel*)[NSApp delegate] removeSyncersForDocumentUuid:uuid] ;
	[[NSDocumentController sharedDocumentController] forgetRecentDocumentUrl:url] ;
}

- (void)forgetAndTrashDocWithUuid:(NSString*)uuid
                          fileUrl:(NSURL*)fileUrl {
    // Do three of the four things which are necessary to completely forget a document
    // The fourth thing, trashing local data files, will be done after
    // 62 days by -cleanOrphanedLocalData.
    [[NSUserDefaults standardUserDefaults] forgetDocumentUuid:uuid] ;
    [[BkmxBasis sharedBasis] logFormat:@"Forgot-Doc-0 %@", [uuid substringToIndex:4]] ;
    [(BkmxAppDel*)[NSApp delegate] removeSyncersForDocumentUuid:uuid] ;
    if (@available(macOS 10.14, *)) {
        /* macOS 10.14 seems to take care of removing a trashed item from
         Recent Documents automaatically.  Furthermore, at this time, it
         appears that macOS 10.14 somehow broke by -forgetRecentDocumentUrl:
         method, causing all recent documents to be forgotten.  So, the
         solution is to not call it, do nothing here!  (This was tested with
         macOS10.14.4 Beta 2.) */
    } else {
        [[NSDocumentController sharedDocumentController] forgetRecentDocumentUrl:fileUrl] ;
    }
    
    NSString* path = [fileUrl path] ;
    
    NSError* error = nil ;
    BOOL ok = [[NSFileManager defaultManager] trashPath:path
                                           scriptFinder:NO
                                                error_p:&error] ;
    if (!ok) {
        // Overlying error added in BookMacster 1.15
        error = [SSYMakeError(594822, @"Could not trash document.")  errorByAddingUnderlyingError:error] ;
    }
    [SSYAlert alertError:error] ;
}

- (IBAction)newDocument:(id)sender {
	NSDictionary* aliasRecords = [[NSUserDefaults standardUserDefaults] objectForKey:constKeyDocAliasRecords] ;
	NSInteger count = [aliasRecords count] ;
	NSMutableSet* urls = [[NSMutableSet alloc] initWithCapacity:count] ;
	for (NSData* aliasRecord in [aliasRecords allValues]) {
		id path = [[SSYCachyAliasResolver sharedResolver] pathFromAlias:aliasRecord
															   useCache:YES
																timeout:(6.0/count)
															   lifetime:10.0
																error_p:NULL] ;
		if (path) {
            // The following test was added in BookMacster 1.19
            if ([[NSFileManager defaultManager] fileIsPermanentAtPath:path
                                                              error_p:NULL]) {
                NSURL* url = [NSURL fileURLWithPath:path] ;
                if (url) {
                    [urls addObject:url] ;
                }
            }
		}
	}			

	[urls unionSet:[NSSet setWithArray:[self recentDocumentURLs]]] ;
    // Added in BookMacster 1.19
    for (NSDocument* document in [self documents]) {
        NSURL* url = [document fileURL] ;
        if (url) {
            [urls addObject:[document fileURL]] ;
        }
    }
	NSInteger limit = [[[NSUserDefaults standardUserDefaults] objectForKey:constKeyBkmxDocsWarningLimit] integerValue] ;
    // Defensive programming added in BookMacster 1.19
    limit = MAX(1, limit) ;
	// We test ([urls count] == 1) instead of ([urls count] >= 1) because we
	// don't want to bother long-time users who should already be aware of this.
    // Also see "details" on the declaration of constKeyBkmxDocsWarningLimit.
	if ((limit == 1) && ([urls count] == 1)) {
		NSURL* targetUrl = [urls anyObject] ;
		if (targetUrl) {
			NSString* genericName = [self defaultDocumentDisplayName] ;
			NSString* displayName = [targetUrl fileDisplayName] ;
			NSString* msg = [NSString localizeFormat:
							 @"documentAnotherX2",
							 genericName,
							 displayName] ;
			
			SSYAlert* alert = [SSYAlert alert] ;
			[alert setButton1Title:[NSString localizeFormat:
									@"openThing",
									displayName]] ;
			[alert setButton2Title:[NSString localizeFormat:
									@"trash%0",
									displayName]] ;
			[alert setButton3Title:[[BkmxBasis sharedBasis] labelDoKeepBoth]] ;
			
			[alert setIconStyle:SSYAlertIconInformational] ;
			[alert setSmallText:msg] ;
			[alert setHelpAddress:constHelpAnchorBkmxDocWhatIsIt] ;
			[alert display] ;
			[alert runModalDialog] ;

			switch ([alert alertReturn]) {
				case NSAlertFirstButtonReturn:
					// Open Other
					[self openAndDisplayDocumentUrl:targetUrl
                                  completionHandler:NULL] ;
                    [urls release] ;
					return ;
				case NSAlertSecondButtonReturn:
					// Trash Other
                    // Close any open documents.  Added in BookMacster 1.19.
                    for (NSDocument* document in [self documents]) {
                        [document close] ;
                    }
					[self forgetDocumentUrl:targetUrl] ;
					NSString* path = [targetUrl path] ;
                    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                        NSError* error = nil ;
                        BOOL ok = [[NSFileManager defaultManager] trashPath:path
                                                               scriptFinder:YES
                                                                    error_p:&error] ;
                        if (!ok) {
                            // Overlying error added in BookMacster 1.15
                            error = [SSYMakeError(594827, @"Could not trash document.")  errorByAddingUnderlyingError:error] ;
                            [SSYAlert alertError:error] ;
                            if (error) {
                                // Don't confuse user with multiple dialogs
                                [urls release] ;
                                return ;
                            }
                        }
                    }
                    // Added in BookMacster 1.19…
                    break ;
				case NSAlertThirdButtonReturn :
					// Keep Both
                    limit++ ;
					[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:limit]
															  forKey:constKeyBkmxDocsWarningLimit] ;
					break ;
			}
		}
	}	
	[urls release] ;
	
	NSError* error = nil ;
	BkmxDoc* bkmxDoc = [self makeUntitledDocumentWithSuggestedName:nil
														 display:YES
														 error_p:&error] ;
	
    // One and only one of the following will be a no-op message to nil
    [bkmxDoc configureNewAskingForClients:![self skipAskingForClients]] ;
	[SSYAlert alertError:error] ;
    
    // We never skip asking for clients more than once.
    [self setSkipAskingForClients:NO] ;
}

- (BkmxDoc*)frontmostDocument {
	BkmxDoc* frontmostDocument = [super currentDocument] ;
	
	if (!frontmostDocument) {
		// The following line is probably not necessary, since if a document
		// window was keyWindow, super would have returned it.  But I'm
		// leaving it in since I don't quite understand key windows.
		frontmostDocument = [[[NSApp keyWindow] windowController] document] ;
				
		if (!frontmostDocument) {
			for (NSWindow* window in [NSApp orderedWindows]) {
				frontmostDocument = [[window windowController] document] ;
				if (frontmostDocument) {
					break ;
				}
			}
		}
	}
    
    if (![frontmostDocument isKindOfClass:[BkmxDoc class]]) {
        frontmostDocument = nil ;
    }
	
	return frontmostDocument ;
}

- (BOOL)areAnyOperationsInProgressIgnoringQueue:(NSOperationQueue*)ignoredQueue {
	BOOL operationsInProgress = NO ;
	for (BkmxDoc* bkmxDoc in [self documents]) {
		if ([bkmxDoc respondsToSelector:@selector(operationQueue)]) {
			NSOperationQueue* queue = [bkmxDoc operationQueue] ;
            if (queue != ignoredQueue) {
                if ([[queue operations] count] != 0) {
                    operationsInProgress = YES ;
                    break ;
                }
			}
		}
	}
    
    return operationsInProgress ;
}

- (NSError*)operationsInProgressErrorWithCode:(NSInteger)code
                                  ignoreQueue:(NSOperationQueue*)queue {
    NSError* error = nil ;
    if ([self areAnyOperationsInProgressIgnoringQueue:queue]) {
        error = SSYMakeError(code, @"Other operations are in progress.") ;
        error = [error errorByAddingDontShowSupportEmailButton] ;
        error = [error errorByAddingIsOnlyInformational] ;
    }
    
    return error ;
}

- (NSString*)shoeboxDocumentBaseName {
    NSString* name ;
    if ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppBookMacster) {
        name = nil ;
    }
    else {
        // We are in one of the shoebox apps
        name = [[BkmxBasis sharedBasis] appNameLocalized] ;
    }
    
    return name ;
}

- (NSString*)shoeboxDocumentName {
    return [[self shoeboxDocumentBaseName] stringByAppendingPathExtension:[self defaultDocumentFilenameExtension]] ;
}

- (NSString*)shoeboxLegacyDocumentName {
    return [[self shoeboxDocumentBaseName] stringByAppendingPathExtension:@"bkmslf"] ;
}

- (NSString*)shoeboxDocumentPathError_p:(NSError**)error_p {
    NSError* error = nil ;
    NSString* path =[self defaultDocumentFolderError_p:&error] ;
    path = [path stringByAppendingPathComponent:[self shoeboxDocumentName]] ;

    if (error && error_p) {
        *error_p = error ;
    }

    return path ;
}

- (NSString*)shoeboxLegacyDocumentPath {
    NSString* path =[self defaultDocumentFolderError_p:NULL];
    path = [path stringByAppendingPathComponent:[self shoeboxLegacyDocumentName]];
    return path ;
}

- (void)shoeboxDocumentForcibly:(BOOL)forcibly
              completionHandler:(void(^)(BkmxDoc*))completionHandler {
    if ([[BkmxBasis sharedBasis] isShoeboxApp]) {
        NSError* error = nil ;
        
        NSString* path = [self shoeboxDocumentPathError_p:&error];
        if (path) {
            /* Migrate from legacy .bkmslf if necessary. */
            if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                NSString* legacyPath = [self shoeboxLegacyDocumentPath];
                if ([[NSFileManager defaultManager] fileExistsAtPath:legacyPath]) {
                    [[BkmxBasis sharedBasis] logString:@"Will migrate legacy .bkmslf shoebox"];
                    path = legacyPath;
                }
            }

            NSURL* url = [NSURL fileURLWithPath:path] ;
            if (url) {
               [self openDocumentUrl:url
                              display:YES
                    completionHandler:^(NSDocument* document) {
                        /* Document is normally a .bmco BkmxDoc, but during
                          first run migration will be a .bkmslf Bkmslf. */
                        if (!document && forcibly) {
                            BkmxDoc* bkmxDoc = [super openUntitledDocumentAndDisplay:YES
                                                                               error:(NSError**)&error] ;
                            
                            [[[bkmxDoc bkmxDocWinCon] window] setExcludedFromWindowsMenu:YES] ;

                            if (completionHandler) {
                                completionHandler(bkmxDoc) ;
                            }
                        }
                        else {
                            if ([document isKindOfClass:[BkmxDoc class]]) {
                                BkmxDoc* bkmxDoc = (BkmxDoc*)document;
                                [bkmxDoc setShouldSkipAfterSaveHousekeeping:NO] ;

                                if (completionHandler) {
                                    completionHandler(bkmxDoc) ;
                                }
                            }

                            [[[[document windowControllers] firstObject] window] setExcludedFromWindowsMenu:YES] ;
                        }

                    }] ;
            }
            else {
                error = [SSYMakeError(529487, @"Could not make URL from shoebox path") errorByAddingUnderlyingError:error] ;
                error = [error errorByAddingUserInfoObject:path
                                                    forKey:@"Path"] ;
            }
        }
        else {
            error = SSYMakeError(522487, @"No path for shoebox") ;
        }
        
        if (forcibly && error) {
            NSString* msg = [NSString stringWithFormat:
                             @"Could not create new document"] ;
            error = [SSYMakeError(648388, msg) errorByAddingUnderlyingError:error] ;
            
            [SSYAlert alertError:error] ;
        }
    }

    if (completionHandler) {
        completionHandler(nil) ;
    }
}

- (BOOL)fileUrlSaysThisIsAShoebox:(NSDocument*)doc {
    BOOL answer = NO ;
    if ([[BkmxBasis sharedBasis] isShoeboxApp]) {
        const char* docPathC = [[[doc fileURL] path] fileSystemRepresentation] ;
        if (docPathC) {
            NSArray* shoeboxAppNames = @[
                                         constAppNameSmarky,
                                         constAppNameSynkmark,
                                         constAppNameMarkster];
            for (NSString* appName in shoeboxAppNames) {
                NSString* shoeboxPath = [[[self pathForShoeboxDocuments]
                                          stringByAppendingPathComponent:appName]
                                         stringByAppendingPathExtension:[self defaultDocumentFilenameExtension]];
                const char* shoeboxPathC = [shoeboxPath fileSystemRepresentation] ;
                if (shoeboxPathC) {
                    answer = strcmp(docPathC, shoeboxPathC) == 0 ;
                    if (answer) {
                        break;
                    }
                }
            }
        }
    }

    return answer ;
}

#pragma mark * Methods to set directory in File > Open panel (BookMacster only)

- (NSString*)currentDirectory {
    // Start with the parent of the frontmost document, if there is one
    NSDocument* document = [self currentDocument] ;
    NSString* answer = [[[document fileURL] path] stringByDeletingLastPathComponent] ;
    
    if (!answer) {
        answer = [self defaultDocumentFolderError_p:NULL] ;
    }
    
    if (!answer) {
        // What the hell
        answer = [super currentDirectory] ;
    }
    
    return answer ;
}

/*!
 @details  Workaround for Apple Bug 19496899,
 http://openradar.appspot.com/radar?id=6280770725347328
*/
- (void)patchOpenPanel:(NSOpenPanel*)openPanel {
    if (@available(macOS 10.16, *)) {
        return;
    } else {
        // The following call should work, according to the documentation, but
        // it does not; at least in 10.10 and, if I recall correctly, 10.9.
        [openPanel setDirectoryURL:[NSURL fileURLWithPath:[self currentDirectory]]] ;
        // The following call should not work, but it does.
        [[NSUserDefaults standardUserDefaults] setObject:[self currentDirectory]
                                                  forKey:@"NSNavLastRootDirectory"] ;
    }
}

/*!
 @details  This method is probably not called in recent macOS versions, but
 the documentation is confusing and I'm not sure, so I'm overriding it anyhow.
 */
- (NSInteger)runModalOpenPanel:(NSOpenPanel *)openPanel
                      forTypes:(NSArray *)types {
    [self patchOpenPanel:openPanel] ;
    return [super runModalOpenPanel:openPanel
                           forTypes:types] ;
}

/*!
 @details  This method is called by -openDocument:
 */
- (void)beginOpenPanel:(NSOpenPanel *)openPanel
              forTypes:(NSArray *)inTypes
     completionHandler:(void (^)(NSInteger result))completionHandler {
    [self patchOpenPanel:openPanel] ;
    [super beginOpenPanel:openPanel
                 forTypes:inTypes
        completionHandler:completionHandler] ;
}

@end
