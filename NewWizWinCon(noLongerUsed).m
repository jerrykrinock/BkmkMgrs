#import "NewWizWinCon.h"
#import "BkmxAppDel+Images.h"
#import "ClientGuy.h"
#import "NSImage+Merge.h"
#import "NSBundle+AppIcon.h"
#import "NSImage+Transform.h"
#import "NSString+LocalizeSSY.h"
#import "NSDocumentController+DisambiguateForUTI.h"
#import "BkmxBasis+Strings.h"
#import "SSYMH.AppAnchors.h"
#import "BkmxAppDel+Actions.h"
#import "SSWebBrowsing.h"
#import "NSObject+SuperUtils.h"

#define MAX_BROWSER_ICONS_FOR_BUTTON 3
#define MIN_BROWSER_ICONS_FOR_BUTTON 2
#define BROWSER_ICON_SPACING 3.0
#define BROWSER_ICON_SIZE 32.0
#define SUBIMAGE_SPACING 0.0

@interface NewWizWinCon ()

@property NSInteger usageStyle ;

@end

@implementation NewWizWinCon

- (id)init {
	self = [super initWithWindowNibName:@"NewWiz"] ;
	if (self) {
		[self showWindow:self] ;
	}
	return self ;
}

@synthesize usageStyle = m_usageStyle ;

- (void)setUsageStyle:(NSInteger)tag {
	m_usageStyle = tag ;
	[button0 setState:NSOffState] ;
	[button1 setState:NSOffState] ;
	[button2 setState:NSOffState] ;
	[button3 setState:NSOffState] ;
	switch (tag) {
		case 0:
			[button0 setState:NSOnState] ;
			break;
		case 1:
			[button1 setState:NSOnState] ;
			break;
		case 2:
			[button2 setState:NSOnState] ;
			break;
		case 3:
			[button3 setState:NSOnState] ;
			break;
		default:
			break;
	}
}

- (void)awakeFromNib {
	// Safely invoke super
	[self safelySendSuperSelector:_cmd
						arguments:nil] ;

	[self showWindow:nil] ;
	[[self window] center] ;
	
	NSArray* subimages ;
	NSImage* image ;
	NSString* title ;
	
	// Construct an array of the user's 3 most popular local-app clients
	NSArray* allPossibleClients = [ClientGuy allClientsForLocalAppsThisUserByPopularity:YES] ;
	
	NSRange clientsRange = NSMakeRange(0, MIN(MAX_BROWSER_ICONS_FOR_BUTTON, [allPossibleClients count])) ;
	NSArray* clients = [allPossibleClients subarrayWithRange:clientsRange] ;		
	
	// Construct an image showing icons of the user's popular browsers, in a row
	NSImage* browsersAllInARow = [[NSApp delegate] browserIconsInARowForClients:clients
																	   minCount:MIN_BROWSER_ICONS_FOR_BUTTON
																		   size:BROWSER_ICON_SIZE
																		spacing:BROWSER_ICON_SPACING] ;
	
	CGFloat wideSideMarginsFor1Icon = ([browsersAllInARow size].width - BROWSER_ICON_SIZE) / 2 ;
	
	// Construct an image showing 1 icon, of the user's most popular browser
	NSImage* browserJust1 = [[NSApp delegate] browserIconsInARowForClients:[clients subarrayWithRange:NSMakeRange(0,1)]
																  minCount:1
																	  size:BROWSER_ICON_SIZE
																   spacing:wideSideMarginsFor1Icon] ;
	
	// Construct a line-sketch of the manifolds for connecting application icons
	NSImage* manifold1Browser = [[NSApp delegate] manifoldWithCount:1
														  itemWidth:[browsersAllInARow size].width
															spacing:0.0] ;
	NSImage* manifold3BrowsersTop = [[NSApp delegate] manifoldWithCount:MAX([clients count], MIN_BROWSER_ICONS_FOR_BUTTON)
															  itemWidth:BROWSER_ICON_SIZE
																spacing:BROWSER_ICON_SPACING] ;
	NSImage* manifold3BrowsersBottom = [manifold3BrowsersTop imageRotatedByDegrees:180.0] ;
	
	// Construct an image with the app icon in the middle and padding on each side
	NSImage* appIcon = [[NSBundle mainBundle] appIcon] ;
	[appIcon setSize:NSMakeSize(BROWSER_ICON_SIZE, BROWSER_ICON_SIZE)] ;
	subimages = [NSArray arrayWithObjects:appIcon, nil] ;
	appIcon = [NSImage imageByTilingImages:subimages
								  spacingX:wideSideMarginsFor1Icon
								  spacingY:BROWSER_ICON_SPACING
								vertically:NO] ;
	
	// Subimages done.
	
	// Set image and title for button 3 (Usage Style 3)
	subimages = [NSArray arrayWithObjects:appIcon, manifold3BrowsersBottom, browsersAllInARow, nil] ;
	image = [NSImage imageByTilingImages:subimages
								spacingX:BROWSER_ICON_SPACING
								spacingY:SUBIMAGE_SPACING
							  vertically:YES] ;
	title = [NSString localizeFormat:
			 @"bkmxNewDocWizU3X",
			 [[BkmxBasis sharedBasis] appNameLocalized]] ;
	[button3 setImage:image] ;
	[button3 setTitle:[NSString localizeFormat:@"bkmxNewDocWizSX", 3]] ;
	[label3 setStringValue:title] ;
	
	// Set image and title for button 2 (Usage Style 2)
	subimages = [NSArray arrayWithObjects:browsersAllInARow, manifold3BrowsersTop, appIcon, nil] ;
	image = [NSImage imageByTilingImages:subimages
								spacingX:BROWSER_ICON_SPACING
								spacingY:SUBIMAGE_SPACING
							  vertically:YES] ;
	title = [NSString localize:@"bkmxNewDocWizU2"] ;
	[button2 setImage:image] ;
	[button2 setTitle:[NSString localizeFormat:@"bkmxNewDocWizSX", 2]] ;
	[label2 setStringValue:title] ;
	
	// Set image and title for button 1 (Usage Style 1)
	subimages = [NSArray arrayWithObjects:browserJust1, manifold1Browser, appIcon, nil] ;
	image = [NSImage imageByTilingImages:subimages
								spacingX:SUBIMAGE_SPACING
								spacingY:BROWSER_ICON_SPACING
							  vertically:YES] ;
	title = [NSString localizeFormat:
			 @"bkmxNewDocWizU1X",
			 [SSWebBrowsing defaultBrowserDisplayName]] ;
	[button1 setImage:image] ;
	[button1 setTitle:[NSString localizeFormat:@"bkmxNewDocWizSX", 1]] ;
	[label1 setStringValue:title] ;
	
	// Set image and title for button 0 (Configure Manually)
	image = [NSImage imageNamed:@"ConfigManual.png"] ;
	title = [NSString stringWithFormat:
			 @"%@ %@ %@",
			 [[BkmxBasis sharedBasis] labelNoClients],
			 constEmDash,
			 [NSString localize:@"bkmxNewDocWizU0"]] ;
	[button0 setImage:image] ;
	[label0 setStringValue:title] ;
	
	// Set window title and other static text in window
	NSString* windowTitle = [[BkmxBasis sharedBasis] labelNewBkmslf] ;
	[[self window] setTitle:windowTitle] ;
	[helpLabel setStringValue:[NSString localize:@"bkmxNewDocWizHelp"]] ;
	NSString* msg = [NSString localizeFormat:
					 @"bkmxNewDocWizT",
					 [[BkmxBasis sharedBasis] appNameLocalized],
					 [[NSDocumentController sharedDocumentController] defaultDocumentDisplayName]] ;
	[headingField setStringValue:msg] ;
	[okButton setTitle:[NSString localize:@"next"]] ;
	[cancelButton setTitle:[NSString localize:@"cancel"]] ;
	
	// Set initial state
	[self setUsageStyle:3] ;	
}


- (void)keyDown:(NSEvent*)event {
	NSString *s = [event charactersIgnoringModifiers] ;
	unichar keyChar = 0 ;
	NSInteger usageStyle = [self usageStyle] ;
	// Oh, I'm so proud of the following elegant math...
	if ([s length] == 1) {
		keyChar = [s characterAtIndex:0] ;
		if (
			(keyChar == NSLeftArrowFunctionKey)
			||
			(keyChar == NSUpArrowFunctionKey)
			) {
			usageStyle += 1 ;
		}
		else if (
			(keyChar == NSDownArrowFunctionKey)
			||
			(keyChar == NSRightArrowFunctionKey)
			) {
			usageStyle -= 1 ;
		}
	}
	if (usageStyle < 0) {
		usageStyle += 4 ;
	}
	usageStyle = usageStyle % 4 ;
	
	[self setUsageStyle:usageStyle] ;
}

- (IBAction)selectUsageStyle:(id)sender {
	[self setUsageStyle:[sender tag]] ;
}

- (IBAction)help:(id)sender {
	[[NSApp delegate] openHelpAnchor:constHelpAnchorUsageStyles] ;
}

- (IBAction)cancel:(id)sender {
	[[self window] close] ;
	[self release] ;
}

- (IBAction)ok:(id)sender {
	[[self window] close] ;
	[[NSApp delegate] newDocWizardPart1WithUsageStyle:[self usageStyle]] ;
	[self release] ;
}

@end