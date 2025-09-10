#import "ManageExtensionsControl.h"
#import "ExtensionsMule.h"
#import "ExtensionsWinCon.h"
#import "BkmxBasis+Strings.h"
#import "NSString+LocalizeSSY.h"
#import "Client.h"
#import "Extore.h"
#import "Clientoid.h"
#import "SSYProgressView.h"
#import "NSString+VarArgs.h"
#import "NSString+SSYExtraUtils.h"
#import "NSArray+SafeGetters.h"
#import "NSError+MoreDescriptions.h"
#import "BkmxAppDel.h"


enum ResultDisplayMode_enum {
    ResultDisplayModeError = 0,
    ResultDisplayModeVersions = 1,
    ResultDisplayModeProgress = 2
} ;
typedef enum ResultDisplayMode_enum ResultDisplayMode ;


@interface ManageExtensionsControl ()

@property (retain) NSMutableDictionary* iconViews ;
@property (retain) NSMutableDictionary* versionViews ;
@property (retain) NSMutableDictionary* progressViews ;
@property (retain) NSMutableDictionary* errorViews ;
@property (assign) BOOL isRefreshing;


@end

#define BUTTON_VERTICAL_MARGIN 2.0
#define NAME_FIELD_WIDTH 250.0
#define NAME_TEXT_FIELD_MARGIN 2.0
#define VERSION_STATUS_ERROR_TEXT_FIELD_MARGIN 5.0
#define STATUS_ICON_HEIGHT 20.0
#define STATUS_ICON_WIDTH 20.0
#define SPACING_BETWEEN_CONTROLS 3.0
#define ONE_FOR_NOT_APPLICABLE 1

@implementation ManageExtensionsControl

@synthesize anyExtensionsAvailable = m_anyExtensionsAvailable ;
@synthesize defaultButton = m_defaultButton ;
@synthesize iconViews = m_iconViews ;
@synthesize versionViews = m_versionViews ;
@synthesize errorViews = m_errorViews ;
@synthesize progressViews = m_progressViews ;
@synthesize rowHeight = m_rowHeight ;
@synthesize mule = m_mule ;
@synthesize clidentifiersWithStalePrefs = m_clidentifiersWithStalePrefs;

- (void)dealloc {
	[m_mule release] ;
    [m_iconViews release] ;
    [m_versionViews release] ;
    [m_progressViews release];
    [m_errorViews release] ;
    [m_clidentifiersWithStalePrefs release];
	
	[super dealloc] ;
}

- (CGFloat)currentHeight {
	// Even if no clients, need 1 for "Not Applicable"
	CGFloat height = MAX([[[self mule] extores] count], 1) * [self rowHeight] ;
	return height ;
}

- (NSInteger)indexForExtore:(Extore*)extore {
	NSInteger index =[[[self mule] extores] indexOfObject:extore] ;
	return index ;
}

- (ExtensionsMule*)mule {
	if (!m_mule) {
		m_mule = [[ExtensionsMule alloc] initWithDelegate:(ExtensionsWinCon*)[[self window] windowController]] ;
	}
	
	return m_mule ;
}

- (void)awakeFromNib {
    // Per Discussion in documentation of -[NSObject respondsToSelector:].
	// the superclass name in the following must be hard-coded.
#if 0
	if ([NSControl instancesRespondToSelector:@selector(awakeFromNib)]) {
		[super awakeFromNib] ;
	}
#endif
    
	[self setRowHeight:[self frame].size.height] ;
    [self setIconViews:[NSMutableDictionary dictionaryWithCapacity:8]] ;
    [self setVersionViews:[NSMutableDictionary dictionaryWithCapacity:8]] ;
    [self setProgressViews:[NSMutableDictionary dictionaryWithCapacity:8]] ;
    [self setErrorViews:[NSMutableDictionary dictionaryWithCapacity:8]] ;
}

- (NSImage*)emptyStatusImage {
	return [[[NSImage alloc] initWithSize:NSMakeSize(STATUS_ICON_WIDTH, STATUS_ICON_HEIGHT)] autorelease] ;
}

- (NSButton*)buttonAtPoint:(NSPoint)point {
	NSRect frame = NSMakeRect(
							  point.x,
							  point.y + BUTTON_VERTICAL_MARGIN,
							  80.0, // temporary, will be changed by -sizeToFit
							  [self rowHeight] - 2 * BUTTON_VERTICAL_MARGIN
							  ) ;
	NSButton* button = [[NSButton alloc] initWithFrame:frame] ;
	[button setBezelStyle:NSBezelStyleRounded] ;
	[button setTarget:self] ;
	
	return [button autorelease] ;	
}


- (NSArray*)iconViewsForExtore:(Extore*)extore {
	return [[self iconViews] objectForKey:[[[extore client] clientoid] clidentifier]] ;
}

- (NSArray*)versionViewsForExtore:(Extore*)extore {
	return [[self versionViews] objectForKey:[[[extore client] clientoid] clidentifier]] ;
}

- (NSArray*)progressViewsForExtore:(Extore*)extore {
    return [[self progressViews] objectForKey:[[[extore client] clientoid] clidentifier]] ;
}

- (NSArray*)errorViewsForExtore:(Extore*)extore {
	return [[self errorViews] objectForKey:[[[extore client] clientoid] clidentifier]] ;
}

- (void)stopSpinningForExtore:(Extore*)extore {
    [[[self progressViewsForExtore:extore] firstObject] stopSpinning] ;
}

- (void)setResultDisplayMode:(ResultDisplayMode)resultDisplayMode
					  extore:(Extore*)extore {
	switch (resultDisplayMode) {
		case ResultDisplayModeVersions:
			for (NSTextField* versionView in [self versionViewsForExtore:extore]) {
                [versionView setHidden:NO] ;
            }
            for (SSYProgressView* progressView in [self progressViewsForExtore:extore]) {
                [progressView setHidden:YES] ;
            }
            for (NSTextField* errorView in [self errorViewsForExtore:extore]) {
                [errorView setHidden:YES] ;
            }
			break ;
        case ResultDisplayModeProgress:
            for (NSTextField* versionView in [self versionViewsForExtore:extore]) {
                [versionView setHidden:YES] ;
            }
            for (SSYProgressView* progressView in [self progressViewsForExtore:extore]) {
                [progressView setHidden:NO] ;
            }
            for (NSTextField* errorView in [self errorViewsForExtore:extore]) {
                [errorView setHidden:YES] ;
            }
            break ;
        case ResultDisplayModeError:
            for (NSTextField* versionView in [self versionViewsForExtore:extore]) {
                [versionView setHidden:YES] ;
            }
            for (SSYProgressView* progressView in [self progressViewsForExtore:extore]) {
                [progressView setHidden:YES] ;
            }
            for (NSTextField* errorView in [self errorViewsForExtore:extore]) {
                [errorView setHidden:NO] ;
            }
            break ;
	}
}

- (void)clearStatusAndResultForExtore:(Extore*)extore {
	for (NSImageView* statusIconView in [self iconViewsForExtore:extore]) {
        [statusIconView setImage:[self emptyStatusImage]] ;
        [statusIconView display] ;
    }
	for (NSTextField* errorView in [self errorViewsForExtore:extore]) {
        [errorView setStringValue:@""] ;
    }
}

- (IBAction)test:(id)button {
	Extore* extore = [[[self mule] extores] objectAtIndex:[ExtensionsMule extoreIndexForTag:[button tag]]] ;
	
	[self clearStatusAndResultForExtore:extore] ;
	
	[self setResultDisplayMode:ResultDisplayModeProgress
						extore:extore] ;
	NSString* msg = [NSString localizeFormat:
					 @"waitingFor%0",
					 [[extore client] displayName]] ;
	SSYProgressView* progressView = [[self progressViewsForExtore:extore] firstObject] ;
	[progressView setStringValue:[msg ellipsize]] ;
    [progressView startSpinning];

	[self clearStatusAndResultForExtore:extore] ;
	[(ExtensionsWinCon*)[[self window] windowController] setIsWaitingForCallback:YES] ;
	[[self mule] testForExtore:extore] ;
}

- (void)registerStalePrefsForExtore:(Extore*)extore {
    if (!self.clidentifiersWithStalePrefs) {
        NSMutableSet* newEmptySet = [NSMutableSet new];
        self.clidentifiersWithStalePrefs = newEmptySet;
        [newEmptySet release];
    }
    [self.clidentifiersWithStalePrefs addObject:extore.client.clientoid.clidentifier];
}

- (IBAction)install:(id)button {
	Extore* extore = [[[self mule] extores] objectAtIndex:[ExtensionsMule extoreIndexForTag:[button tag]]] ;
	
	[self setResultDisplayMode:ResultDisplayModeError
						extore:extore] ;
    
	[[self mule] installForTag:[button tag]
                        window:[self window]] ;

    [self registerStalePrefsForExtore:extore];
}

- (IBAction)uninstall:(id)button {
	[button setEnabled:NO] ;
	Extore* extore = [[[self mule] extores] objectAtIndex:[ExtensionsMule extoreIndexForTag:[button tag]]] ;
	[self setResultDisplayMode:ResultDisplayModeError
						extore:extore] ;
	[[[self progressViewsForExtore:extore] firstObject] startSpinning] ;
	
	[(ExtensionsWinCon*)[[self window] windowController] setIsWaitingForCallback:YES] ;
	[[self mule] uninstallForTag:[button tag]] ;

    [self registerStalePrefsForExtore:extore];
}

- (void)makeRowWithResult:(NSDictionary*)result
              extoreIndex:(NSInteger)extoreIndex
                   extore:(Extore*)extore
          extensionVersion:(NSInteger)extensionVersion
            extensionIndex:(NSInteger)extensionIndex
       extensionMinVersion:(NSInteger)extensionMinVersion
                         y:(CGFloat)y {

    // Decode result
    BOOL tested = ([[result objectForKey:constKeyIsActualTestResult] boolValue] == YES) ;
    NSError* error = [result objectForKey:constKeyError] ;
    NSInteger errorCode = [error code] ;
    BOOL needsUpdate = (
                        (extensionIndex == 1)
                        &&
                        (
                         ((errorCode & EXTORE_ERROR_CODE_MASK_EXTENSION1_DOWNREV) > 0)
                         ||
                         (extensionVersion == EXTORE_EXTENSION_VERSION_COULD_NOT_DETERMINE)
                         )
                        )
    ||
    (
     (extensionIndex == 2)
     &&
     ((errorCode & EXTORE_ERROR_CODE_MASK_EXTENSION2_DOWNREV) > 0)
     ) ;
    
    // Create the item view
    NSRect itemFrame = NSMakeRect(
                                  10.0,
                                  y,
                                  [self frame].size.width - 10.0,
                                  [self rowHeight]) ;
    NSView* itemView = [[NSView alloc] initWithFrame:itemFrame] ;
    [self addSubview:itemView] ;
    
    CGFloat x = 0 ;
    
    // Add the Client's Name to the item view
    CGFloat nameFieldHeight = [self rowHeight] - 2 * NAME_TEXT_FIELD_MARGIN ;
    CGFloat nameFieldWidth = NAME_FIELD_WIDTH ;
    NSRect frame = NSMakeRect(
                              x,
                              NAME_TEXT_FIELD_MARGIN,
                              nameFieldWidth,
                              nameFieldHeight
                              ) ;
    NSTextField* nameField = [[NSTextField alloc] initWithFrame:frame] ;
    [nameField setBordered:NO] ;
    [nameField setDrawsBackground:NO] ;
    [nameField setEditable:NO] ;
    [[nameField cell] setLineBreakMode:NSLineBreakByClipping] ;
    [itemView addSubview:nameField] ;
    [nameField release] ;
    NSString* name = [[extore client] displayName] ;
    [nameField setStringValue:name] ;
    x += nameFieldWidth ;
    x += SPACING_BETWEEN_CONTROLS ;
    
    NSString* tooltip = nil ;
    
    // Add the "Install" button to the item view (title is variable)
    NSButton* installButton = [self buttonAtPoint:NSMakePoint(x, 0)] ;
    [installButton setTag:[ExtensionsMule tagForExtoreIndex:extoreIndex
                                             extensionIndex:extensionIndex
                                                 isAnUpdate:needsUpdate]] ;
    [installButton setAction:@selector(install:)] ;
    tooltip = [extore tooltipForInstallButtonForExtensionIndex:extensionIndex] ;
    [installButton setToolTip:tooltip] ;
    [itemView addSubview:installButton] ;
    // Set title
    NSString* title ;
    if (needsUpdate) {
        title = [[BkmxBasis sharedBasis] labelUpdateVerb] ;
        
        // Another little dance because we're staring from the bottom, going up.
        // This *latest* install button must be the default button, respond to
        // the 'return' key and be the first responder.  Clear these states
        // in the current (prior) default button, if any.
        NSButton* priorDefaultButton = [self defaultButton] ;
        [priorDefaultButton setKeyEquivalent:@""] ;
        [priorDefaultButton resignFirstResponder] ;
        // Now set the new default/return-key/first-responder button.
        [installButton becomeFirstResponder] ;
        [installButton setKeyEquivalent:@"\r"] ;
        [self setDefaultButton:installButton] ;
    }
    else {
        title = [[BkmxBasis sharedBasis] labelInstall] ;
    }
    [installButton setTitle:title] ;
    [installButton sizeToFit];
    // Possibly patch up the keyboard loop
    if (needsUpdate) {
        // Another little dance because we're staring from the bottom, going up.
        // This *latest* install button must be the default button, respond to
        // the 'return' key and be the first responder.  Clear these states
        // in the current (prior) default button, if any.
        NSButton* priorDefaultButton = [self defaultButton] ;
        [priorDefaultButton setKeyEquivalent:@""] ;
        [priorDefaultButton resignFirstResponder] ;
        // Now set the new default/return-key/first-responder button.
        [installButton becomeFirstResponder] ;
        [installButton setKeyEquivalent:@"\r"] ;
        [self setDefaultButton:installButton] ;
    }
    x += [installButton frame].size.width ;
    x += SPACING_BETWEEN_CONTROLS ;
    
    // Add the "Uninstall" button to the item view
    NSButton* uninstallButton = [self buttonAtPoint:NSMakePoint(x, 0)] ;
    title = [[BkmxBasis sharedBasis] labelUninstall] ;
    [uninstallButton setTitle:title] ;
    [uninstallButton sizeToFit];
    [uninstallButton setTag:[ExtensionsMule tagForExtoreIndex:extoreIndex
                                               extensionIndex:extensionIndex
                                                   isAnUpdate:needsUpdate]] ;
    /* In the above, needsUpdate is ignored. */
    [uninstallButton setAction:@selector(uninstall:)] ;
    [itemView addSubview:uninstallButton] ;
    x += [uninstallButton frame].size.width ;
    x += SPACING_BETWEEN_CONTROLS ;
    
    // Add to the item view (or at least make with title) the "Test" button
    NSButton* testButton = [self buttonAtPoint:NSMakePoint(x, 0)] ;
    [testButton setTitle:[[BkmxBasis sharedBasis] labelTest]] ;
    [testButton sizeToFit];
    if (extensionIndex == 1) {
        [testButton setTag:[ExtensionsMule tagForExtoreIndex:extoreIndex
                                              extensionIndex:extensionIndex
                                                  isAnUpdate:needsUpdate]] ;
        /* In the above, needsUpdate is ignored. */
        [testButton setAction:@selector(test:)] ;
        [itemView addSubview:testButton] ;
    }
    x += [testButton frame].size.width + 2.0;
    // No x += SPACING_BETWEEN_CONTROLS here; want "Test" button close to the status icon,
    // and the NSRoundedBezelStyle does not completely fill the width of its frame anyhow.
    
    NSString* clidentifier = [[[extore client] clientoid] clidentifier] ;
    
    // Add the image view for the green checkmark or red 'X'
    CGFloat statusIconBottom = ([self rowHeight] - STATUS_ICON_HEIGHT) / 2 -1.0;
    // The +4.0 was added as an empirical tweak
    frame = NSMakeRect(
                       x,
                       statusIconBottom,
                       STATUS_ICON_WIDTH,
                       STATUS_ICON_HEIGHT
                       ) ;
    NSImageView* imageView = [[NSImageView alloc] initWithFrame:frame] ;
    [itemView addSubview:imageView] ;
    [imageView release] ;
    BOOL dontDisableInstall = NO ;
    // Set appropriate image
    NSImage* image ;
    if (tested  && (extensionIndex == 1)) {
        NSString* imageName ;
        // We mask out bits for Extension 2 errors, because we are calculating
        // results in this row for Extension 1.
        NSInteger relevantErrorBits = errorCode & ~EXTORE_ERROR_CODE_MASK_EXTENSION2_ERRORS ;
        if (relevantErrorBits == 0) {
            imageName = @"circle_ok.tif" ;
        }
        else if (
                 // These to issues will only affect the operation of Extension 1
                 ((extensionIndex == 1) && (errorCode & EXTORE_ERROR_CODE_MASK_IPC_PROFILE_CROSSTALK) > 0)
                 ||
                 ((extensionIndex == 1) && (errorCode & EXTORE_ERROR_CODE_MASK_IPC_PROFILE_NULL) > 0)
                 ) {
            imageName = @"circle_warning.tif" ;
            dontDisableInstall = YES ;
        }
        else {
            imageName = @"circle_stop.tif" ;
            dontDisableInstall = YES ;
        }
        image = [NSImage imageNamed:imageName] ;
    }
    else {
        // Use an empty image
        image = [self emptyStatusImage] ;
    }
    [imageView setImage:image] ;
    // Because we're working from the bottom up, the Extension 2 row will
    // be created before the Extension 1 row.  Hence we insert at index 0 …
    [[[self iconViews] objectForKey:clidentifier] insertObject:imageView
                                                       atIndex:0] ;
    if ([[NSApp delegate] respondsToSelector:@selector(relaxedExtensionDetection)]) {
        if (((BkmxAppDel*)[NSApp delegate]).relaxedExtensionDetection) {
            dontDisableInstall = YES ;
        }
    } else {
        // We are in BkmxAgent
    }

    
    
    x += STATUS_ICON_WIDTH ;

    // Finally, add the errorProgress view, and the version number view.
    // Note that they are colocated, and that either the errorProgress view,
    // or the version views, will be hidden.
    // Use all of the remaining width.
    CGFloat width = [self frame].size.width - x  ;
    
    frame = NSMakeRect(
                       x,
                       VERSION_STATUS_ERROR_TEXT_FIELD_MARGIN -4.0,
                       width,
                       [self rowHeight] - 2 * VERSION_STATUS_ERROR_TEXT_FIELD_MARGIN
                       ) ;
    frame.size.width = width ;
    
    ResultDisplayMode resultDisplayMode
    = (errorCode <= EXTORE_ERROR_MAX_ADDON_ERROR)
    ? ResultDisplayModeVersions
    : ResultDisplayModeError ;
    [self setResultDisplayMode:resultDisplayMode
                        extore:extore] ;
    
#define PROGRESS_VIEW_OFFSET NSMakePoint(6.0, 6.0)
#define PROGRESS_VIEW_INSET 3.0
    NSRect progressFrame = frame;
    progressFrame.origin.x += PROGRESS_VIEW_OFFSET.x - STATUS_ICON_WIDTH;
    progressFrame.origin.y += PROGRESS_VIEW_OFFSET.y;
    progressFrame.size.height -= 2 * PROGRESS_VIEW_INSET;
    SSYProgressView* progressView = [[SSYProgressView alloc] initWithFrame:progressFrame] ;
    [itemView addSubview:progressView] ;
    // Because we're working from the bottom up, the Extension 2 row will
    // be created before the Extension 1 row.  Hence we insert at index 0 …
    [[[self progressViews] objectForKey:clidentifier] insertObject:progressView
                                                           atIndex:0];
    [progressView release];

#define ERROR_VIEW_OFFSET NSMakePoint(0.0, 0.0)
#define ERROR_VIEW_INSET 0.0
    NSRect errorFrame = frame;
    errorFrame.origin.x += ERROR_VIEW_OFFSET.x;
    errorFrame.origin.y += ERROR_VIEW_OFFSET.y;
    errorFrame.size.height -= 2 * ERROR_VIEW_INSET;
    NSTextField* errorView = [[NSTextField alloc] initWithFrame:errorFrame];
    [itemView addSubview:errorView];
    // Ditto previous comment
    [[[self errorViews] objectForKey:clidentifier] insertObject:errorView
                                                        atIndex:0] ;
    [errorView release] ;
    [errorView setBordered:NO] ;
    [errorView setDrawsBackground:NO] ;
    [errorView setEditable:NO] ;
    [errorView setFont:[NSFont systemFontOfSize:11.0]] ;

    if (resultDisplayMode == ResultDisplayModeError) {
        NSString* errorString = [error localizedDescription] ;
        if (!errorString) {
            errorString = @"" ;
        }
        [errorView setStringValue:errorString] ;
    }
    else {
        NSTextField* versionView = [[NSTextField alloc] initWithFrame:frame] ;
        [itemView addSubview:versionView] ;
        [versionView setBordered:NO] ;
        [versionView setDrawsBackground:NO] ;
        [versionView setEditable:NO] ;
        [versionView setFont:[NSFont systemFontOfSize:11.0]] ;
        NSString* string ;
        
        BOOL extensionOperable = NO ;
        if (extensionVersion == EXTENSION_VERSION_UNKNOWN_BECAUSE_ITS_BEEN_ZIPPED_BY_FIREFOX_3) {
            // Staged by Firefox 3, still zipped
            string = @"Hidden until used" ;
            extensionOperable = YES ;
        }
        else if (
                 (
                  ((extensionIndex == 1) && (errorCode & EXTORE_ERROR_CODE_MASK_EXTENSION1_NOT_FOUND) > 0)
                  ||
                  ((extensionIndex == 2) && (errorCode & EXTORE_ERROR_CODE_MASK_EXTENSION2_NOT_FOUND) > 0)
                  )
                 ) {
            // Not installed
            string = [NSString localize:@"installedNot"] ;
            
            [uninstallButton setEnabled:NO] ;
        }
        else if (needsUpdate) {
            // Downrev
            extensionOperable = YES ;
            NSString* extensionVersionString ;
            if (extensionVersion > 0) {
                extensionVersionString = [NSString stringWithInt:extensionVersion] ;
            }
            else {
                extensionVersionString = @"??" ;
            }
            string = [NSString localizeFormat:
                      @"versionOldNeedX2",
                      extensionVersionString,
                      [NSString stringWithInt:extensionMinVersion]] ;
        }
        else if (extensionMinVersion == 0) {
            // Installed
            string = [NSString localize:@"installed"] ;
            if (errorCode == 0) {
                [installButton setEnabled:NO];
            }
        }
        else {
            // OK
            extensionOperable = YES ;
            string = [NSString stringWithFormat:@"%ld (OK)", (long)extensionVersion] ;
            if (!dontDisableInstall) {
                [installButton setEnabled:NO];
            }
        }
        
        if (extensionOperable) {
            NSError* isRunningError = nil ;
            OwnerAppRunningState runningState = [extore ownerAppRunningStateError_p:&isRunningError] ;
            if (isRunningError) {
                NSLog(@"Internal Error 737-5842 %@", [error longDescription]) ;
            }
            if (runningState == OwnerAppRunningStateRunningProfileAvailable) {
                string = [string stringByAppendingFormat:
                          @" (%@)",
                          [NSString localize:@"loaded"]] ;
            }
            else {
                string = [string stringByAppendingFormat:
                          @" (%@)",
                          [NSString localize:@"loadedNot"]] ;
            }
        }

        [versionView setStringValue:string] ;
        
        // Because we're working from the bottom up, the Extension 2 row will
        // be created before the Extension 1 row.  Hence we insert at index 0 …
        [[[self versionViews] objectForKey:clidentifier] insertObject:versionView
                                                              atIndex:0];
        [versionView release];
    }
    
    [itemView release];
}

- (void)quitStaleBrowsers {
    /* Quit browsers if there are any virgin installs, because the new versions
     may not be written to the Preferences file on disk (in Firefox and
     possibly others) until the browser quits, and it is these Preferences
     which we read in -[Extore extensionVersionForExtensionIndex] which are
     going to be called when we refreshResults. */
    NSMutableSet* clidentifiersNoLongerStale = [NSMutableSet new];
    for (NSString* clidentifier in self.clidentifiersWithStalePrefs) {
        for (Extore* extore in [[self mule] extores]) {
            if ([extore.client.clientoid.clidentifier isEqualToString:clidentifier]) {
                BOOL didQuitOrWasNotRunning = [extore quitOwnerAppWithTimeout:10.0
                                                                preferredPath:nil
                                                             killAfterTimeout:YES
                                                                 wasRunning_p:NULL
                                                                pathQuilled_p:NULL
                                                                      error_p:NULL];
                if (didQuitOrWasNotRunning) {
                    [clidentifiersNoLongerStale addObject:clidentifier];
                }

            }
        }
    }
    for (NSString* clidentifier in clidentifiersNoLongerStale) {
        [self.clidentifiersWithStalePrefs removeObject:clidentifier];
    }
    [clidentifiersNoLongerStale release];

}

- (CGFloat)refresh {
	// This method builds the following subview structure:
	// # ExtensionsManagerView (self)
	// ## 0.  Row 0 Subview
	// ### 0.  Client Name Text Field
	// ### 1.  'Install' Button
	// ### 2.  'Uninstall' Button
	// ### 3.  'Test' Button
	// ### 4.  Test Result (Status Icon) NSImageView
	// ### 5.  Error View (SSYProgressView)
	// ### 6.  Extension Version Text Field
	// ## 1.  Row 1 Subview
    // ### 0.  Client Name Text Field
	// etc.
    
    /* The following lockout was added on 2021-010-03 BkmkMgrs 2.11 to fix a
     2-years-long but rarely-occuring bug.  Rarely, this method may be called
     again before a first call had finished making all of the calls to
     -[ManageExtensionsControl makeRowWithResult:extoreIndex:extore:extensionVersion:extensionIndex:extensionMinVersion:y:]
     to make all of its rows.  That would cause the local variable
     `versionView` in that method to be an invalid object at times or, in
     macOS 11, `itemView` would be an invalid object.  I have not taken the
     time to understand the complete picture, but whatever the reason, we
     don't want two instances of this method running simultaneously, so … */
   if (self.isRefreshing) {
        return 0;
    }
    self.isRefreshing = YES;
    
	[[self mule] refreshResults] ;
	
	// Remove all existing Client/Row subviews
	NSArray* subviewsCopy = [[self subviews] copy] ;
	for (NSView* subview in subviewsCopy) {
		[subview removeFromSuperviewWithoutNeedingDisplay] ;
	}
	[subviewsCopy release] ;
	
	CGFloat rowHeight = [self rowHeight] ;
	NSRect frame = [self frame] ;
    CGFloat oldHeight = frame.size.height ;
	NSArray* extores = [[self mule] extores] ;

	NSInteger extoreIndex = [extores count] - 1 ;
    NSInteger rowIndex = 0 ;
    NSInteger familiesIndex = 0 ;
	[self setDefaultButton:nil] ;
	if ([extores count] > 0) {
        /* Just because we can, we store making the rows as Obj-C blocks :) */
        void (^makeRow)(void) ;
        NSMutableDictionary* makeRowBlocks = [[NSMutableDictionary alloc] init] ;

        // Because y=0 at the bottom, we start with the last extore and work up.
        CGFloat __block y = 0 ;
        for (Extore* extore in [extores reverseObjectEnumerator]) {
            // The following is to give visual feedback to the user that a
            // refresh has occurred when the click the "Refresh" button.
            [self display] ;
            usleep(20000) ;
            if (extoreIndex == [extores count] - 1) {
                usleep(100000) ;
            }
            
            // Make arrays to store the subviews we shall create
            NSString* clidentifier = [[[extore client] clientoid] clidentifier] ;
            // Each array will have an entry for Extension 1 and Extension 2
            [[self iconViews] setObject:[NSMutableArray arrayWithCapacity:2]
                                 forKey:clidentifier] ;
            [[self versionViews] setObject:[NSMutableArray arrayWithCapacity:2]
                                    forKey:clidentifier] ;
            [[self progressViews] setObject:[NSMutableArray arrayWithCapacity:2]
                                  forKey:clidentifier] ;
            [[self errorViews] setObject:[NSMutableArray arrayWithCapacity:2]
                                  forKey:clidentifier] ;

			// Get result and its derivative variables
			NSDictionary* result = [[[self mule] results] objectForKey:[[[extore client] clientoid] clidentifier]] ;

            NSInteger extensionVersion ;
            NSString* familyName ;
            NSInteger extensionMinVersion ;
                        
            /* Extension 1, the Sync extension */
            if (
                ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppBookMacster)
                ||
                ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppSynkmark)
                ) {
                familyName = [extore extension1BriefDescription] ;
                extensionVersion = [[result objectForKey:constKeyExtension1Version] integerValue] ;
                extensionMinVersion = [extore minVersionForExtensionIndex:1] ;
                makeRow = Block_copy(^{
                    [self makeRowWithResult:result
                                extoreIndex:extoreIndex
                                     extore:extore
                           extensionVersion:extensionVersion
                             extensionIndex:1
                        extensionMinVersion:extensionMinVersion
                                          y:y] ;
                    y += [self rowHeight] ;
                });
                NSMutableArray* siblings = [makeRowBlocks objectForKey:familyName] ;
                if (!siblings) {
                    siblings = [[NSMutableArray alloc] init] ;
                    [makeRowBlocks setObject:siblings
                                      forKey:familyName] ;
                    [siblings release] ;
                }
                [siblings addObject:makeRow] ;
                Block_release(makeRow);
                /* Had we not used Block_copy() and Block_release() here, the
                 blocks in `siblings` would all be the last block created, in
                 addition to other possible memory management issues due
                 to flaunting Apple recommendations. */
                rowIndex++ ;
            }
            
            /* Extension 2, the Button extension */
            if (
                ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppBookMacster)
                ||
                ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppMarkster)
                ) {
                familyName = [extore extension2BriefDescription] ;
                if (familyName) {
                    extensionVersion = [[result objectForKey:constKeyExtension2Version] integerValue] ;
                    extensionMinVersion = [extore minVersionForExtensionIndex:2] ;
                    makeRow = [^{
                        [self makeRowWithResult:result
                                    extoreIndex:extoreIndex
                                         extore:extore
                               extensionVersion:extensionVersion
                                 extensionIndex:2
                            extensionMinVersion:extensionMinVersion
                                              y:y] ;
                        y += [self rowHeight] ;
                    } copy] ;
                    /* Above, making a copy is necessary because, apparently
                     blocks are indirect pointer-like things, and without making
                     a copy, we'd add the same last one to 'siblings' for each
                     loop iteration. */
                    NSMutableArray* siblings = [makeRowBlocks objectForKey:familyName] ;
                    if (!siblings) {
                        siblings = [[NSMutableArray alloc] init] ;
                        [makeRowBlocks setObject:siblings
                                          forKey:familyName] ;
                        [siblings release] ;
                    }
                    [siblings addObject:makeRow] ;
                    [makeRow release] ;  /* because makeRow is a -copy */
                    rowIndex++ ;
                }
            }
            
			extoreIndex-- ;
		}
        
        /* Sort the "Syncing" extension family last, so that it will
         be at the top when we draw from the bottom up. */
        NSArray* sortedMakeRowBlocks = [[makeRowBlocks allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *key1, NSString *key2) {
            NSComparisonResult answer ;
            if ([key1 rangeOfString:@"Sync"].location != NSNotFound) {
                answer = NSOrderedDescending ;
            }
            else if ([key2 rangeOfString:@"Sync"].location != NSNotFound) {
                answer = NSOrderedAscending ;
            }
            else {
                answer = [key1 caseInsensitiveCompare:key2] ;
            }
            
            return answer ;
        }];

        for (NSString* familyName in sortedMakeRowBlocks) {
            NSArray* familyMembers = [makeRowBlocks objectForKey:familyName] ;
            for (void(^makeRowBlock)(void) in familyMembers) {
                makeRowBlock() ;
            }
#define MARGIN_BELOW_FAMILY_HEADER 5.0
            // Use size (10.0,10.0), will sizeToFit later…
            NSRect frame = NSMakeRect(0.0, y + MARGIN_BELOW_FAMILY_HEADER, 10.0, 10.0) ;
            NSTextField* textField = [[NSTextField alloc] initWithFrame:frame] ;
            NSFont* font = [[NSFontManager sharedFontManager] convertFont:[textField font]
                                                              toHaveTrait:NSBoldFontMask] ;
            NSDictionary* attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                   font, NSFontAttributeName,
                                   nil] ;
            NSAttributedString* as = [[NSAttributedString alloc] initWithString:familyName
                                                 attributes:attrs] ;
            [textField setAttributedStringValue:as] ;
            [as release] ;
            [textField setBordered:NO] ;
            [textField setDrawsBackground:NO] ;
            [textField setEditable:NO] ;
            [textField setEnabled:NO] ;
            [textField sizeToFit];
            [self addSubview:textField] ;
            [textField release] ;
            y += [self rowHeight] ;
            familiesIndex++ ;
        }
        [makeRowBlocks release] ;
        
        [self setAnyExtensionsAvailable:YES] ;
	}
	else {
		CGFloat width = [self frame].size.width ;
		NSRect frame = NSMakeRect(19.0, -VERSION_STATUS_ERROR_TEXT_FIELD_MARGIN, width, rowHeight) ;
		NSTextField* textField = [[NSTextField alloc] initWithFrame:frame] ;
		[textField setBordered:NO] ;
		[textField setDrawsBackground:NO] ;
		[textField setEditable:NO] ;
		[textField setEnabled:NO] ;
		[textField setTextColor:[NSColor disabledControlTextColor]] ;
		NSString* text = NSLocalizedString(@"Extensions do not apply to any of your browsers.", nil) ;
		[textField setStringValue:text] ;
		[self addSubview:textField] ;
		[textField release] ;
        rowIndex++ ;
        [self setAnyExtensionsAvailable:NO] ;
	}
    
    [[self mule] clearAllActualTestResults];

    /* One for each row, one for each family headng */
    CGFloat newHeight = rowHeight * (rowIndex + familiesIndex) ;
    CGFloat addedHeight  = newHeight - oldHeight ;
	frame.size.height = newHeight ;
	frame.origin.y = frame.origin.y - addedHeight ;
    [self setFrame:frame] ;
    self.isRefreshing = NO;
    return addedHeight ;
}

- (void)beginIndeterminateTaskVerb:(NSString*)verb
						 forExtore:(Extore*)extore {
	[self setResultDisplayMode:ResultDisplayModeProgress
						extore:extore] ;
	SSYProgressView* progressView = [[self progressViewsForExtore:extore] firstObjectSafely] ;
	[progressView setStringValue:[verb ellipsize]] ;
	[progressView startSpinning] ;
}


@end
