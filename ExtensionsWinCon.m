#import "ExtensionsMule.h"
#import "ExtensionsWinCon.h"
#import "BkmxBasis+Strings.h"
#import "NSString+LocalizeSSY.h"
#import "SSYMH.AppAnchors.h"
#import "BkmxAppDel.h"
#import "ManageExtensionsControl.h"
#import "NSWindow+Sizing.h"
#import "ExtensionDetectionTester.h"
#import "Extore.h"

@interface ExtensionsWinCon ()

@property NSTimeInterval lastRefresh;

@end

@implementation ExtensionsWinCon

@synthesize isWaitingForCallback = m_isWaitingForCallback ;

- (void)didEndExtensionsDownrevWarningSheet:(NSWindow*)sheet
                                     option:(NSInteger)optionNotUsed
                                    notUsed:(void*)notUsed {
	[sheet orderOut:self] ;
}

+ (NSString*)nibName {
	return @"ManageExtensions" ;
}

- (IBAction)moreTests:(id)sender {
    ExtensionDetectionTester* detectionTester = [[ExtensionDetectionTester alloc] init] ;
    NSWindow* window = [self window] ;
    [window beginSheet:[detectionTester window]
     completionHandler:^void(
                             NSModalResponse modalResponse) {
         /* Nothing do do here. */
     }] ;
    [detectionTester release] ;
}

- (void)awakeFromNib {
	// Per Discussion in documentation of -[NSObject respondsToSelector:].
	// the superclass name in the following must be hard-coded.
	if ([SSYTempWindowController instancesRespondToSelector:@selector(awakeFromNib)]) {
		[super awakeFromNib] ;
	}
	
    NSString* introText = @"• Extensions are only for Firefox and Chrome-ish browsers, not Safari.\n"
    @"• Clicking buttons in here may launch or quit a web browser." ;
    [introText_outlet setStringValue:introText] ;
	[versionsLabel_outlet setStringValue:[NSString stringWithFormat:
                                          @"%@ / %@",
                                          [NSString localize:@"versionsInstalled"],
                                          [NSString localize:@"status"]]] ;
    [refreshButton_outlet setToolTip:[NSString localize:@"refreshTT"]] ;
	
	NSWindow* window = [self window] ;

	[window setTitle:[[BkmxBasis sharedBasis] labelManageBrowserExtensions]] ;
	// Because we want -windowShouldClose:…
    [[self window] setDelegate:self] ;
	
    [self refresh] ;
	
	// In case this window is showing because an upgrade requirement is
	// detected upon launch, make sure that this window shows in the front.
	// It seems to work with this 0.5 delay; even goes in front of the
	// "Welcome" modal dialog.  Did not work with 0.0 delay.
	[[self window] performSelector:@selector(makeKeyAndOrderFront:)
						withObject:self
						afterDelay:0.5] ;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleAppActivation:)
                                                 name:NSApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (IBAction)help:(id)sender {	
	[(BkmxAppDel*)[NSApp delegate] openHelpAnchor:constHelpAnchorBrowserExtensions] ;
}

- (NSString*)toolTipRefresh {
    return @"Click this button to re-read information from the disk and refresh the data shown in this window." ;
}

- (void)moveView:(NSView*)control
          downBy:(CGFloat)addedHeight {
    NSPoint origin = [control frame].origin ;
    origin.y -= addedHeight ;
    [control setFrameOrigin:origin] ;
}

- (void)handleAppActivation:(NSNotification*)note {
    BOOL isBounce;
    /* De-bouncing is needed when pushing the Test button for Chrome
     in macOS 10.11 Beta 2 when Chrome is not running and must be
     launched.  Without this de-bouncing, positive test result will
     be removed by another refresh after about 1/2 second. */
    NSTimeInterval now = NSDate.date.timeIntervalSinceReferenceDate;
    if (now < self.lastRefresh + 10) {
        isBounce = YES;
    }
    else {
        isBounce = NO;
    }
    
    if (!isBounce) {
        [self refresh];
    }
}

- (void)refresh {
    self.lastRefresh = NSDate.date.timeIntervalSinceReferenceDate;

    CGFloat addedHeight = [managerView_outlet refresh] ;

    [self moveView:moreTestsButton_outlet
            downBy:addedHeight] ;
    [self moveView:closeButton_outlet
            downBy:addedHeight] ;

    [[self window] setFrameToFitContentThenDisplay:YES] ;
}

/* This method is called by (1) round "refresh" button in Manage Browser
 Extensions window, and (2) NSApplicationDidBecomeActiveNotification. */
- (IBAction)refresh:(id)sender {
    BOOL isBounce = NO;
    if ([sender isKindOfClass:[NSNotification class]]) {
        /* De-bouncing is needed when pushing the Test button for Chrome
         in macOS 10.11 Beta 2 when Chrome is not running and must be
         launched.  Without this de-bouncing, positive test result will
         be removed by another refresh after about 1/2 second. */
        NSTimeInterval now = NSDate.date.timeIntervalSinceReferenceDate;
        if (now < self.lastRefresh + 10) {
            isBounce = YES;
        }
        self.lastRefresh = now;
    }
    if (!isBounce) {
        [managerView_outlet quitStaleBrowsers];
        [self refresh];
    }
}

- (void)alertError:(NSError*)error {
	if (![[BkmxBasis sharedBasis] shouldHideError:error]) {
        [SSYAlert alertError:error
                    onWindow:[self window]
               modalDelegate:nil
              didEndSelector:NULL
                 contextInfo:NULL] ;
    }
}

- (void)alertMessage:(NSString*)message {
    SSYAlert* alert = [SSYAlert alert] ;
    [alert setSmallText:message] ;
    [alert runModalSheetOnWindow:[self window]
                      resizeable:NO
                   modalDelegate:nil
                  didEndSelector:NULL
                     contextInfo:NULL] ;
}

- (NSString*)success {
    return @"Success." ;
}

- (IBAction)close:(id)sender {
    [[self window] close] ;
}

#pragma mark * ExtensionsCallbackee Protocol Support

- (void)presentError:(NSError*)error {
	NSWindow* window = [self window] ;
	[SSYAlert alertError:error
				onWindow:window
		   modalDelegate:nil
		  didEndSelector:NULL
			 contextInfo:NULL] ;
}

- (void)presentAlert:(SSYAlert*)alert
   completionHandler:(void (^)(NSModalResponse))handler {
    NSWindow* window = [self window] ;
    [alert runModalSheetOnWindow:window
                      resizeable:NO
               completionHandler:handler];
}

- (void)abortForExtore:(Extore*)extore {
	[managerView_outlet stopSpinningForExtore:extore] ;
}

- (void)muleIsDoneForExtore:(Extore*)extore {
    [extore unleaseInterappServer] ;
	[self setIsWaitingForCallback:NO] ;
	[self refresh] ;
    [self abortForExtore:extore] ;
}


- (void)beginIndeterminateTaskVerb:(NSString*)verb
						 forExtore:(Extore*)extore {
    [managerView_outlet beginIndeterminateTaskVerb:(NSString*)verb
                                         forExtore:extore] ;
}

- (void)refreshAndDisplay {
    [self refresh] ;
    [self.window display] ;
}

/*
 Not really a part of the ExtensionsCallbackee protocol, but necessary to avoid 
 crashes when acting as such a delegate/callbackee
 */
- (BOOL)windowShouldClose:(id)sender {
	BOOL answer = ![self isWaitingForCallback] ;
	return answer ;
}

@end
