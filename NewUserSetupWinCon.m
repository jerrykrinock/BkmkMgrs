#import "NewUserSetupWinCon.h"
#import "SSYVectorImages.h"
#import "NSImage+Transform.h"
#import "BkmxDocumentController.h"

@interface NewUserSetupWinCon ()

@property (copy) NSString* stringValue ;
@property (retain) WKWebView* webView ;

@end

@implementation NewUserSetupWinCon

@synthesize stringValue = m_stringValue ;

- (void)dealloc {
    [_webView release];
    [m_stringValue release] ;
    
    [super dealloc] ;
}

+ (NSString*)nibName {
	return @"NewUserSetup" ;
}

- (void)awakeFromNib {
    [bookView setHidden:YES] ;
    [[self window] center] ;

    NSImage* triangleImage = [SSYVectorImages imageStyle:SSYVectorImageStyleTriangle53
                                                  wength:8.0
                                                   color:[NSColor grayColor]
                                            darkModeView:nil // Ignored since we passed in a constant `color`
                                           rotateDegrees:90.0
                                                   inset:0.0] ;
    [forwardBackControl setImage:triangleImage
                      forSegment:0] ;
    triangleImage = [triangleImage imageRotatedByDegrees:180] ;
    [forwardBackControl setImage:triangleImage
                      forSegment:1] ;

}

- (NSString*)helpBookName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleHelpBookName"] ;
}

- (NSString*)helpBookSubdirectoryName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleHelpBookFolder"] ;
}

- (void)setUrlStringForSectionIndex:(NSInteger)index {
    NSString* filename = [NSString stringWithFormat:
                          @"SSYMH.01.%02ld",
                          (long)index] ;
    NSURL* url = [[NSBundle mainBundle] URLForResource:filename
                                         withExtension:@"html"
                                          subdirectory:[self helpBookSubdirectoryName]] ;
    if (url) {
        NSString* string = [url absoluteString] ;
        [self setStringValue:string] ;

        // Switch views
        [bigButtonsView setHidden:YES] ;
        [bookView setHidden:NO] ;

        NSRect useableFrame = [[NSScreen mainScreen] visibleFrame] ;
        // useableFrame does not include main menu bar or Dock.
#define USE_HEIGHT_FACTOR 0.90  // Cosmetic decision: Use 90% of the available screen height
        CGFloat height = useableFrame.size.height * USE_HEIGHT_FACTOR ;
        CGFloat y = useableFrame.size.height * (1 - USE_HEIGHT_FACTOR) / 2 + useableFrame.origin.y ;
        // Above, + visibleFrame.origin.y is the top of the dock, if the dock
        // is showing at the bottom of the screen
        
        NSRect windowFrame = [[self window] frame] ;
        windowFrame.size.height = height ;
        windowFrame.origin.y = y ;
        [[self window] setFrame:windowFrame
                        display:YES
                        animate:YES] ;

        // This loads the requested page from the Help Book
        WKWebViewConfiguration* configuration = [[WKWebViewConfiguration alloc] init];
        NSRect webViewFrame = bigButtonsView.frame;
        webViewFrame.size.height = self.window.contentView.frame.size.height - helpNavigationRect.frame.size .height;
        WKWebView *webView = [[WKWebView alloc] initWithFrame:webViewFrame
                                                configuration:configuration];
        [configuration release];
        webView.navigationDelegate = self;
        self.webView = webView;
        [webView release];
        NSURLRequest *nsrequest=[NSURLRequest requestWithURL:url];
        [webView loadRequest:nsrequest];
        [bookView addSubview:webView];
    }
}

- (IBAction)showUseSingly:(id)sender {
    [self setUrlStringForSectionIndex:4] ;
}

- (IBAction)showUseSync:(id)sender {
    [self setUrlStringForSectionIndex:5] ;
}

- (IBAction)showUseDirectly:(id)sender {
    [[BkmxDocumentController sharedDocumentController] setSkipAskingForClients:YES] ;
    [self setUrlStringForSectionIndex:6] ;
}

- (IBAction)showUseCustom:(id)sender {
    [self setUrlStringForSectionIndex:7] ;
}

- (IBAction)forwardBack:(NSSegmentedControl*)sender {
    if ([sender selectedSegment] == 0) {
        [self.webView goBack] ;
        [forwardBackControl setSelected:NO
                             forSegment:0] ;
    }
    else {
        [self.webView goForward] ;
        [forwardBackControl setSelected:NO
                             forSegment:1] ;
    }
}

- (IBAction)search:(NSSearchField*)sender {
    [[NSHelpManager sharedHelpManager] findString:[sender stringValue]
                                           inBook:[self helpBookName]] ;
}

#pragma mark WKNavigationDelegate methods

- (void)         webView:(WKWebView*)webView
       didFailNavigation:(WKNavigation *)navigation
               withError:(NSError *)error {
    NSLog(@"Internal Error 492-4880 %@", error);
}

- (void)        webView:(WKWebView*)sender
    didFinishNavigation:(WKNavigation *)navigation {
    [forwardBackControl setEnabled:[sender canGoBack] forSegment:0] ;
    [forwardBackControl setEnabled:[sender canGoForward] forSegment:1] ;
}

@end
