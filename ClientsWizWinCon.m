#import "ClientsWizWinCon.h"
#import "ClientoidPlus.h"
#import "NSImage+Transform.h"
#import "SSYMH.AppAnchors.h"
#import "NSObject+SuperUtils.h"
#import "SSYVectorImages.h"
#import "ClientListNiew.h"
#import "Macster.h"
#import "Client.h"
#import "BkmxDoc.h"
#import "BkmxBasis.h"
#import "BkmxAppDel.h"
#import "NSDocumentController+DisambiguateForUTI.h"

@interface ClientsWizWinCon ()

@property (retain) NSMutableArray* clientoidsPlus ;
@property (retain) NSInvocation* doneInvocation ;

@end


@implementation ClientsWizWinCon

@synthesize clientoidsPlus = m_clientoidsPlus ;
@synthesize doneInvocation = m_doneInvocation ;

- (id)initWithBkmxDoc:(BkmxDoc*)bkmxDoc
	  doneInvocation:(NSInvocation*)invocation {
	self = [super initWithWindowNibName:@"ClientsWiz"] ;
	if (self) {
		[self setDocument:bkmxDoc] ;
		[self setDoneInvocation:invocation] ;
	}

	return self ;
}

+ (NSArray*)availableClientoids {
    return [ClientoidPlus availableClientableClientoidsPlus] ;
}

+ (BOOL)canOfferAnyClients {
    return ([[self availableClientoids] count] > 0) ;
}

+ (void)runWithBkmxDoc:(BkmxDoc*)bkmxDoc
		   thenInvoke:(NSInvocation*)invocation {
	ClientsWizWinCon* instance = [[ClientsWizWinCon alloc] initWithBkmxDoc:bkmxDoc
														   doneInvocation:invocation] ;
    NSWindow* window = [(NSWindowController*)[bkmxDoc bkmxDocWinCon] window] ;
    [window beginSheet:[instance window]
     completionHandler:^void(NSModalResponse modalResponse) {
         [instance release] ;
     }] ;
}

#if 0
#warning Logging retain, release for ClientsWizWinCon
- (id)retain {
	id x = [super retain] ;
	NSLog(@"111033: After retain, rc=%ld", (long)[self retainCount]) ;
	return x ;
}
/*- (id)autorelease {
 id x = [super autorelease] ;
 NSLog(@"111008: After autorelease, rc=%d", [self retainCount]) ;
 return x ;
 }
 */
- (oneway void)release {
	NSInteger rc = [self retainCount] ;
	[super release] ;
	NSLog(@"111300: After release, rc=%ld", (long)(rc-1)) ;
	return ;
}
#endif

- (void)dealloc {
	[m_clientoidsPlus release] ;
	[m_doneInvocation release] ;
	
	[super dealloc] ;
}

- (void)awakeFromNib {
	// Safely invoke super
	[self safelySendSuperSelector:_cmd
                   prettyFunction:__PRETTY_FUNCTION__
						arguments:nil] ;

	NSString* imageName ;
    if ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppBookMacster) {
        imageName = [[NSDocumentController sharedDocumentController] defaultDocumentDisplayName] ;
    }
    else {
        imageName = @"NSApplicationIcon" ;
    }
    [bigAppImageView setImage:[NSImage imageNamed:imageName]] ;
    NSImage* arrowImage = [SSYVectorImages imageStyle:SSYVectorImageStyleTriangle53
											   wength:[clientUpArrow frame].size.width
												color:nil
                                         darkModeView:nil // For this template image, Cocoa will handle luminance inversion when in Dark Mode
                                        rotateDegrees:0.0
                                                inset:0.0] ;
	[clientUpArrow setImage:arrowImage] ;
	arrowImage = [arrowImage imageRotatedByDegrees:180.0] ;
	[clientDownArrow setImage:arrowImage] ;
	
	// Get available ClientoidPlus objects, make mutable, sort by name, set
	NSMutableArray* clientoidsPlus = [[ClientsWizWinCon availableClientoids] mutableCopy] ;
	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"displayName"
																   ascending:YES
																	selector:@selector(localizedCaseInsensitiveCompare:)] ;
	[clientoidsPlus sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] ;
	[sortDescriptor release] ;
	[self setClientoidsPlus:clientoidsPlus] ;
	[clientoidsPlus release] ;
	
	// Set indexes and initial setting of Import and Export checkboxes
	BOOL defaultDoImportExport = ([clientoidsPlus count] > 1) ? NO : YES ;
	NSInteger i = 0 ;
	for (ClientoidPlus* clientoidPlus in clientoidsPlus) {
		[clientoidPlus setDoImport:defaultDoImportExport] ;
		[clientoidPlus setDoExport:defaultDoImportExport] ;
		[clientoidPlus setIndex:i] ;
		i++ ;
	}
    
	CGFloat originalHeight = [clientListNiew frame].size.height ;
	
	// Set content into clientListNiew, which will cause it to get taller
	[clientListNiew setContentProvider:self
							   keyPath:@"clientoidsPlus"] ;
	
	// Make the window taller to accomodate clientListNiew
	CGFloat deltaY = [clientListNiew frame].size.height - originalHeight ;
	NSRect frame = [[self window] frame] ;
	frame.size.height += deltaY ;

	[[self window] setFrame:frame display:NO] ;
	
    if (clientListNiew.itemCount > 1) {
        [labelReorder setHidden:NO];
    } else {
        [labelReorder setHidden:YES];
    }
    
	[self addObserver:clientListNiew
		   forKeyPath:@"clientoidsPlus"
			  options:0
			  context:NULL] ;
}

- (IBAction)help:(id)sender {
	[(BkmxAppDel*)[NSApp delegate] openHelpAnchor:constHelpAnchorNewBkmxDoc] ;
}

- (void)endSheet {
    [self retain] ;  // Balanced with release, below.
    /* This will run the completion handler, which will release self. */
    [[[self window] sheetParent] endSheet:[self window]] ;

	[self removeObserver:clientListNiew
			  forKeyPath:@"clientoidsPlus"] ;
	
	[[self window] close] ;
    [self release] ;
	// Window is set to "Release when closed" in xib
}

- (IBAction)ok:(id)sender {
    [self retain] ;
    [self endSheet] ;

	// The following line was commented out in BookMacster version 1.3.15
	// BOOL firstClient = YES ;
	Macster* macster = [[self document] macster] ;
	[macster deleteAllClients] ;
	for (ClientoidPlus* clientoidPlus in [self clientoidsPlus]) {
		if ([clientoidPlus doImport] || [clientoidPlus doExport]) {
			Client* client = [macster freshClientAtIndex:NSNotFound
                                               singleUse:NO] ;
			[client setLikeClientoidPlus:clientoidPlus] ;
		}
	}
	
	[[self doneInvocation] invoke] ;

    [self release] ;
}

@end
