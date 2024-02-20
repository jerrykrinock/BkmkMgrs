#import "ExtensionDetectionTester.h"
#import "Extore.h"
#import "SSYLaunchdGuy.h"
#import "SSYPathObserver.h"
#import "Trigger.h"
#import "NSBundle+MainApp.h"
#import "NSDate+NiceFormats.h"
#import "NSString+Clipboard.h"
#import "BkmxBasis.h"
#import "NSString+SSYDotSuffix.h"

NSMutableSet* static_extensionDetectionTesterHangout = nil ;

@interface ExtensionDetectionTester ()

- (void)logDetectionAtPath:(NSString*)path ;

@end

void ObserveDetection (
                       ConstFSEventStreamRef streamRef,
                       void *clientCallBackInfo,
                       size_t numEvents,
                       void *eventPaths,
                       const FSEventStreamEventFlags eventFlags[],
                       const FSEventStreamEventId eventIds[]) {
	char** pathsC = eventPaths ;
    NSString* path = [NSString stringWithUTF8String:pathsC[0]] ;
    ExtensionDetectionTester* tester = (ExtensionDetectionTester*)clientCallBackInfo ;
	[tester logDetectionAtPath:path] ;
}

@implementation ExtensionDetectionTester

+ (void)load {
    static_extensionDetectionTesterHangout = [[NSMutableSet alloc] init] ;
}

- (void)retainToStatic {
    [static_extensionDetectionTesterHangout addObject:self] ;
}

- (void)releaseFromStatic {
    [static_extensionDetectionTesterHangout removeObject:self] ;
}

- (id)init {
    self = [super initWithWindowNibName:@"ExtensionDetectionTester"] ;
    if (self) {
        [self retainToStatic] ;
    }
    
    return self ;
}

- (NSString*)verboseProfileNameForProfileName:(NSString*)profileName
                                     exformat:(NSString*)exformat {
    Class extoreClass = [Extore extoreClassForExformat:exformat] ;
    NSString* displayProfileName = [extoreClass displayProfileNameForProfileName:profileName] ;
    NSString* answer ;
    if ([displayProfileName isEqualToString:profileName]) {
        answer = profileName ;
    }
    else {
        answer = [NSString stringWithFormat:
                  @"%@ (identifier = '%@')",
                  displayProfileName,
                  profileName] ;
    }
    
    return answer ;
}

- (NSString*)verboseProfileNameForProfileNameDotExformat:(NSString*)profileNameDotExformat {
    NSScanner* scanner = [[NSScanner alloc] initWithString:profileNameDotExformat] ;
    NSString* exformat ;
    [scanner scanUpToString:@"."
                 intoString:&exformat] ;
    NSString* profileName ;
    NSInteger profileNameLocation = [scanner scanLocation] + 1 ;
    [scanner release] ;
    if (profileNameLocation < [profileNameDotExformat length] + 1) {
        profileName = [profileNameDotExformat substringFromIndex:profileNameLocation] ;
    }
    else {
        profileName = @"" ;
    }
    return [self verboseProfileNameForProfileName:profileName
                                         exformat:exformat] ;
}

- (void)logDetectionAtPath:(NSString*)path {
    NSString* s = [NSString stringWithFormat:@"%@  Received change from %@ profile %@\n",
                   [[NSDate date] hourMinuteSecond],
                   [[path lastPathComponent] stringByDeletingDotSuffix],
                   [self verboseProfileNameForProfileNameDotExformat:[path lastPathComponent]]] ;
    NSAttributedString* as = [[NSAttributedString alloc] initWithString:s
                                                             attributes:nil] ;
    
    // Append string to textview
    [[textView textStorage] appendAttributedString:as];
    [as release] ;
    
    if (YES) {
        [textView scrollRangeToVisible: NSMakeRange([[textView string] length], 0)] ;
    }
}

- (IBAction)start:(id)sender  {
    // You can only start the test once.  If user clicks "Done" and then
    // returns to test again, we'll be in a new instance.
    [startTestButton setEnabled:NO] ;
    
    NSString* s ;
    NSAttributedString* as ;
    NSFont* font ;
    NSMutableDictionary* attributes = [NSMutableDictionary new];
    // Oddly, the following is needed for Dark Mode because NSTextView apparently defaults to black-on-black in Dark Mode
    [attributes setObject:[NSColor controlTextColor]
                   forKey:NSForegroundColorAttributeName];
    NSMutableSet* watchPaths = [[NSMutableSet alloc] init] ;
    NSArray* exformats = [[BkmxBasis sharedBasis] supportedLocalAppExformatsIncludeNonClientable:YES] ;
    for (NSString* exformat in exformats) {
        Class extoreClass = [Extore extoreClassForExformat:exformat] ;
        if ([extoreClass syncExtensionAvailable]) {
            if ([extoreClass supportsMultipleProfiles]) {
                NSArray* profileNames = [extoreClass profileNames] ;
                s = [NSString stringWithFormat:
                     @"You have %ld %@ profiles:\n",
                     (long)[profileNames count],
                     [extoreClass ownerAppDisplayName]] ;
                as = [[NSAttributedString alloc] initWithString:s
                                                     attributes:attributes] ;
                [[textView textStorage] appendAttributedString:as];
                [as release];
                for (NSString* profileName in profileNames) {
                    s = [NSString stringWithFormat:@"    %@\n", [self verboseProfileNameForProfileName:profileName
                                                                                              exformat:exformat]] ;
                    as = [[NSAttributedString alloc] initWithString:s
                                                         attributes:attributes] ;
                    [[textView textStorage] appendAttributedString:as];
                    [as release];
                    
                    NSString* watchPath = [Trigger specialWatchFilePathForExformat:exformat
                                                                       profileName:profileName] ;
                    [watchPaths addObject:watchPath] ;
                }
            } else {
                s = [NSString stringWithFormat:
                     @"%@ does not support multiple profiles\n",
                     [extoreClass ownerAppDisplayName]] ;
                as = [[NSAttributedString alloc] initWithString:s
                                                     attributes:attributes] ;
                [[textView textStorage] appendAttributedString:as];
                [as release];
            }
            s = @"\n" ;
            as = [[NSAttributedString alloc] initWithString:s
                                                 attributes:attributes] ;
            [[textView textStorage] appendAttributedString:as];
            [as release];
        }
    }
    
    NSArray* watchPathsArray = [watchPaths allObjects] ;
    [watchPaths release] ;

	FSEventStreamContext context ;
	context.version = 0 ;
	context.info = self ;
	context.retain = NULL ;
	context.release = NULL ;
	context.copyDescription = NULL ;
	
	m_agentActivityStream = FSEventStreamCreate (
                                                 kCFAllocatorDefault,
                                                 ObserveDetection,
                                                 &context,
                                                 (CFArrayRef)watchPathsArray,
                                                 kFSEventStreamEventIdSinceNow,
                                                 0.5,
                                                 0
                                                 ) ;
	FSEventStreamScheduleWithRunLoop(
									 m_agentActivityStream,
									 CFRunLoopGetMain(),
									 kCFRunLoopCommonModes
									 ) ;
	FSEventStreamStart(m_agentActivityStream) ;
    
    s =
    @"This tester is now listening for change detections in all of the above browser/profiles."
    @"\n\nTo test one of them, activate one of the browser apps listed above, in one of the user profiles listed above, and then in that app, add, update or delete any bookmark.  "
    @"\n\nSuccess is indicated if, about 10 seconds later, a line of text appears below, indicating that a change was received from this browser and profile.  "
    @"This means that the extension in that browser and profile is working.  "
    @"\n\nFailure is indicated if nothing appears after 15 seconds.  "
    @"To try to resolve the failure, click 'Done' and then Uninstall and then (re)-Install the non-functioning extension.\n\n" ;
    as = [[NSAttributedString alloc] initWithString:s
                                         attributes:attributes] ;
    [[textView textStorage] appendAttributedString:as] ;
    [as release] ;

    s =
    @"If the test succeeds, note the profile from which the change was received, and make sure it is the same profile given for the Client you think you are syncing.\n\n" ;
    font = [textView font] ;
    font = [[NSFontManager sharedFontManager] convertFont:font
                                              toHaveTrait:NSBoldFontMask] ;
    [attributes setObject:font
                   forKey:NSFontAttributeName];
    as = [[NSAttributedString alloc] initWithString:s
                                         attributes:attributes] ;
    [[textView textStorage] appendAttributedString:as] ;
    [attributes release];
    [as release] ;
}

- (IBAction)done:(id)sender  {
    // Close down the FSEvents
    if (m_agentActivityStream) {
        FSEventStreamStop(m_agentActivityStream) ;
        FSEventStreamUnscheduleFromRunLoop(
                                           m_agentActivityStream,
                                           CFRunLoopGetMain(),
                                           kCFRunLoopCommonModes
                                           ) ;
        FSEventStreamInvalidate(m_agentActivityStream) ;
        FSEventStreamRelease(m_agentActivityStream) ;
    }
    
    [self.window.sheetParent endSheet:self.window
                      returnCode:NSAlertFirstButtonReturn] ;
    [self.window close] ;
    [self.window orderOut:self] ;
    [self releaseFromStatic] ;
}

- (IBAction)copyToClipboard:(id)sender {
    [[[textView textStorage] string] copyToClipboard] ;
}

@end
