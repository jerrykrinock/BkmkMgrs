#import "DoxtusMenu.h"
#import "BkmxBasis+Strings.h"
#import "NSError+MyDomain.h"
#import "NSString+SSYExtraUtils.h"
#import "NSString+LocalizeSSY.h"
#import "NSDocumentController+DisambiguateForUTI.h"
#import "NSDocumentController+MoreRecents.h"
#import "NSString+Truncate.h"
#import "Extore.h"
#import "StarkEditor.h"
#import "Stark+Attributability.h"
#import "Starker.h"
#import "BkmxDoc.h"
#import "NSMenuItem+Font.h"
#import "SSYProcessTyper.h"
#import "SSYInterappClient.h"
#import "SSYAppleScripter.h"
#import "NSDictionary+SimpleMutations.h"
#import "NSDictionary+BSJSONAdditions.h"
#import "NSMenuItem+Bkmx.h"
#import "SSWebBrowsing+Bkmx.h"
#import "Bookshig.h"
#import "SSYMiniProgressWindow.h"
#import "NSString+Data.h"
#import "SSYDynamicMenu.h"
#import "NSDocumentController+OpenExpress.h"
#import "BkmxAppDel+Actions.h"
#import "Bkmslf.h"

@interface DoxtusMenu ()

@property (retain) NSStatusItem* statusItem ;
//NOTUSED@property (retain) NSDictionary* addHereInfo ;
@property (retain) NSDictionary* lastBrowmarkInfo ;
@property (assign) BOOL pumpIsPrimed ;

- (StarkContainersHierarchicalMenu*)hierMenu ;

@end

@implementation DoxtusMenu

@synthesize exformat = m_exformat ;
@synthesize statusItem = m_statusItem ;
//NOTUSED@synthesize addHereInfo = m_addHereInfo ;
@synthesize lastBrowmarkInfo = m_lastBrowmarkInfo ;
@synthesize pumpIsPrimed = m_pumpIsPrimed ;

- (StarkContainersHierarchicalMenu*)hierMenu {
	if (!m_hierMenu) {
		m_hierMenu = [[StarkContainersHierarchicalMenu alloc] initWithTarget:[StarkEditor class]
																	selector:@selector(visitStark:)  
																  targetInfo:nil] ;
        /* Above, the selector visitStark: is needed when user clicks a
         *bookmark* in one of the hierarchical menus.  I mistakenly passed nil
         in BookMacster 1.14.4, fixed the problem in BookMacster 1.14.8 */
        [m_hierMenu setDoVisitAll:YES] ;
	}
		
	return m_hierMenu ;
}


- (void)dealloc {
    [m_exformat release] ;
    [m_statusItem release] ;
    [m_hierMenu release] ;
    //NOTUSED[m_addHereInfo release] ;
    [m_lastBrowmarkInfo release] ;

	[super dealloc] ;
}

#define BROWSER_PEEK_TIMEOUT 2.5

+ (NSDictionary*)browmarkInfoViaInterappServerForExtoreClass:(Class)extoreClass {
    NSString* profileName = [extoreClass frontmostProfileInOwnerApp] ;
    NSArray* names ;
    NSArray* profilePseudonyms = [extoreClass profilePseudonyms:NSHomeDirectory()];
    if (profileName) {
        // Chromy
        names = [NSArray arrayWithObject:profileName] ;
    }
    else if ([profilePseudonyms count] > 0) {
        /* Firefox does not give us any way to determine the frontmost profile,
         so frontmostProfileInOwnerApp returns nil, so we need to check
         all of the available profiles until we find one whose port
         (provided by our Firefox extension) currently responds. */
        names = profilePseudonyms ;
    }
    else {
        // Opera or Vivaldi
        names = [NSArray arrayWithObject:[extoreClass defaultProfileName]];
    }

    NSError* error = nil ;
    BOOL ok = NO ;
    NSString* portName = nil ;
    NSData* rxData = nil ;
    for (NSString* aName in names) {
        NSString* browserExtensionPortName = [extoreClass browserExtensionPortNameForProfileName:aName] ;
        
        char rxHeaderByte = 0 ;
        rxData = nil ;
        portName = [browserExtensionPortName stringByAppendingString:@".ToClient"] ;
        ok = [SSYInterappClient sendHeaderByte:constInterappHeaderByteForGrabRequest
                                     txPayload:nil
                                      portName:portName
                                          wait:YES
                                rxHeaderByte_p:&rxHeaderByte
                                   rxPayload_p:&rxData
                                     txTimeout:0.5
                                     rxTimeout:BROWSER_PEEK_TIMEOUT
                                       error_p:&error] ;
        if (ok) {
            break ;
        }
    }
    if (!rxData) {
        ok = NO;
    }

    NSDictionary* browmarkInfo = nil ;

    NSString* jsonString = nil ;
    if (ok) {
        if (rxData) {
            jsonString = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSString class]
                                                           fromData:rxData
                                                              error:&error];
        }
        
        if (jsonString) {
            browmarkInfo = [NSDictionary dictionaryWithJSONString:jsonString
                                                       accurately:NO] ;
            if (!browmarkInfo) {
                NSLog(@"Internal Error 741-6883 decoding json: %@", jsonString) ;
            }
        }
        else {
            NSString* dataString = [[NSString stringWithDataUTF8:rxData] stringByTruncatingMiddleToLength:1024
                                                                                               wholeWords:NO] ;
            NSLog(@"Error 361-2252 unarchiving jsonString from %ld bytes : %@\nError: %@", (long)[rxData length], dataString ? (NSObject*)dataString : (NSObject*)rxData, error) ;
        }
    }
    else {
        // This is expected if Firefox is activated but user has not installed
        // our Firefox extension, but can also occur if Firefox is tied up and
        // does not provide a response within BROWSER_PEEK_TIMEOUT seconds.
        browmarkInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                        error, constKeyError,
                        nil] ;
    }
    
    return browmarkInfo ;
}


- (SSYMiniProgressWindow*)startProgressForExformat:(NSString*)exformat {
	Class extoreClass = [Extore extoreClassForExformat:exformat] ;
	NSString* ownerAppDisplayName = [extoreClass ownerAppDisplayName] ;
	NSString* verb = [NSString localizeFormat:
					  @"waitingFor%0",
					  ownerAppDisplayName] ;
    NSPoint mouseLocation = [NSEvent mouseLocation] ;
	SSYMiniProgressWindow* progressWindow = [[SSYMiniProgressWindow alloc] initWithVerb:verb
																				  point:mouseLocation] ;
	// The following balances the +alloc.  Yes, I tested this.
	[progressWindow setReleasedWhenClosed:YES] ;
	
	return progressWindow ;
}

- (NSDictionary*)browmarkInfoViaAppleScriptForExformat:(NSString*)exformat {
    __block NSError* error = nil;
	__block NSDictionary* answer = nil;
    NSString* errorDesc;
	BOOL pumpNeedsPriming = ![self pumpIsPrimed] && [exformat isEqualToString:constExformatSafari] ;
	
	SSYMiniProgressWindow* progressWindow = nil ;
	// There is a better way to do this, discovered after I made the 'pumpNeedsPriming'
	// kludge, for Mac OS 10.6 or later.  In the Mac OS 10.6 Release Notes, it says
	// that NSAppleScript may now be invoked from any thread.  Therefore, we could
	// set a timer for 1 second, then execute the script on a background thread.  If
	// the timer fires, it will startProgressForExformat.  Etc., etc.
	if (pumpNeedsPriming) {
		progressWindow = [self startProgressForExformat:exformat] ;
		[self setPumpIsPrimed:YES] ;
	}

    NSString* scriptName = [@"GetFrom" stringByAppendingString:exformat];

	NSString* scriptPath = [[NSBundle mainBundle] pathForResource:scriptName
														   ofType:@"scpt"
													  inDirectory:@"AppleScripts"] ;
    NSString* scriptNamePlusSE = [scriptName stringByAppendingString:@"+SE"] ;
    /*
     PlusSE is a longer script, available for some exformats, which tries to
     get the selected text as 'comments' using the notoriously unreliable
     'System Events'.  This works most of the time in macOS 10.8 and earlier
     and will work in 10.9+ if Apple ever chooses to fix Bug 14989783, AND if
     the user has added BookMacster to System Preferences > Security & Privacy
     > Accessibility when prompted, which will happen the first time they try
     to land a new bookmark via this mechanism in macOS 10.9+.
     */
	NSString* scriptPathSE = [[NSBundle mainBundle] pathForResource:scriptNamePlusSE
														   ofType:@"scpt"
													  inDirectory:@"AppleScripts"] ;
    if (!scriptPath) {
        scriptPath = scriptPathSE ;
    }
    else if (scriptPathSE) {
        /*
         Both the non-SE and SE scripts are available.  Use if macOS
         version is 10.8 or earlier.  In macOS 10.9, it makes user grant
         access to BookMacster to "control the computer" in System
         Preferences > Security & Privacy > Privacy > Accessibility, and
         then even after doing that it still doesn't work.  See Apple
         Bug 14989783.  And then there is more weirdness, that if BookMacster
         has been denied access on a different user account on the same Mac,
         it might not even ask, just deny.  Retest that!  It's a big mess.
         If Apple ever fixes that bug and I ever try to restore this feature,
         this might help too: https://devforums.apple.com/message/880534#880534
         */
        BOOL useSE = (NSAppKitVersionNumber < 1200) ;
        if (useSE) {
            scriptPath = scriptPathSE ;
        }
    }
	
   if (!scriptPath) {
       errorDesc = [[NSString alloc] initWithFormat:
                    @"%@ (or without +SE) resource not found",
                    scriptPath];
		error = SSYMakeError(112098, errorDesc) ;
       [errorDesc release];
	}

    NSURL* scriptUrl = nil;
    if (!error) {
		scriptUrl = [NSURL fileURLWithPath:scriptPath];
        if (!scriptUrl) {
            errorDesc = [[NSString alloc] initWithFormat:
                         @"%@ (or without +SE) resource not found",
                         scriptPath];
            error = SSYMakeError(558091, errorDesc) ;
            [errorDesc release];
        }
    }

    if (!error) {
        [SSYAppleScripter executeScriptWithUrl:scriptUrl
                                   handlerName:nil
                             handlerParameters:nil
                               ignoreKeyPrefix:@"z"
                                      userInfo:nil
                          blockUntilCompletion:YES
                             failSafeTimeout:10.555
                             completionHandler:^(id  _Nullable payload, id  _Nullable userInfo, NSError * _Nullable scriptError) {
                                 error = scriptError;
                                 [error retain];
                                 if (!error) {
                                     if (payload) {
                                         answer = payload;
                                         [answer retain];
                                     }
                                 }
                             }];
        [error autorelease];
        [answer autorelease];
    }

    [progressWindow close] ;
	
    [[BkmxBasis sharedBasis] logError:error
                      markAsPresented:YES];
    
    /* If the user attempts to land a bookmark when a browser is the active
     app, but that browser has no window open, the script will fail with
     code 2 in NSPOSIXErrorDomain.  We shall not bother the user with that. */
    if (error.code != 2) {
        if (![error.domain isEqualToString:NSPOSIXErrorDomain]) {
            [SSYAlert alertError:error];
        }
    }

	return answer ;
}

- (NSDictionary*)grabActivePage {

	BkmxGrabPageIdiom peekPageIdiom = BkmxGrabPageIdiomNone ;
	
	NSDictionary* grabeeBrowserInfo ;
	NSString* activeAppPath ;
	Class extoreClass ;
	NSString* exformat ;
	[SSWebBrowsing getActiveBrowserExtoreClass:&extoreClass
									exformat_p:&exformat
							bundleIdentifier_p:NULL
										path_p:&activeAppPath] ;
		
	NSDictionary* browmarkInfo = nil ;
	if (extoreClass) {
		peekPageIdiom = [extoreClass peekPageIdiom] ;
	}

	switch (peekPageIdiom) {
		case BkmxGrabPageIdiomNone:
			grabeeBrowserInfo = nil ;
			break;
		case BkmxGrabPageIdiomSSYInterappServer:;			
			browmarkInfo = [[self class] browmarkInfoViaInterappServerForExtoreClass:extoreClass] ;
			break ;
		case BkmxGrabPageIdiomAppleScript:
			browmarkInfo = [self browmarkInfoViaAppleScriptForExformat:exformat] ;
			// The browmarkInfo produced by AppleScripts already includes key/value "path".
			break ;
	}
	
	browmarkInfo = [browmarkInfo dictionaryBySettingValue:activeAppPath
												   forKey:constKeyPath] ;
	return browmarkInfo ;
}

+ (void)populateMostOfMenu:(NSMenu*)menu
					bkmxDoc:(BkmxDoc*)bkmxDoc
			  browmarkInfo:(NSDictionary*)browmarkInfo
				  hierMenu:(StarkContainersHierarchicalMenu*) hierMenu {
	NSMenu *submenu = nil ;
	NSMenuItem *item ;
	SEL action;
    Stark* root = nil;
    /* The following test is needed in case a old Bkmslf file is opened during
     application launching.  Bkmslf is now a empty class which will not
     respond to -starker.  */
    if (![bkmxDoc isKindOfClass:[Bkmslf class]]) {
        root = [[bkmxDoc starker] root] ;
    }
    CGFloat fontSize = [[NSUserDefaults standardUserDefaults] doubleForKey:constKeyMenuFontSize] ;
	NSFont* font = [NSFont systemFontOfSize:fontSize] ;
    
    NSError* error = [browmarkInfo objectForKey:constKeyError] ;
    
    /*
     NSMenu is not very smart about sizing itself.  If you setTitle:, then 
     setFont: to a bigger size, the title will be truncated.  (Oddly, it doesn't
     just get clipped, it gets properly elliipsized in the middle!).  Anyhow,
     to solve that problem, we setFont: early!
     */
    [menu setFont:font] ;
    
	if ([[browmarkInfo objectForKey:constKeyUrl] length] > 0) {
		NSArray* recentLandings = [bkmxDoc recentLandings] ;
		
        NSImage* folderImage = [NSImage imageNamed:@"folder.tif"] ;
        NSImage* addingImage = [NSImage imageNamed:@"prefsAdding.png"] ;
        
		// Add the "Add Xxxx to ▸" menu item
		NSMenuItem* item = [[NSMenuItem alloc] init] ;
        NSString* name = [[[browmarkInfo objectForKey:constKeyName] stringByTruncatingMiddleToLength:MENU_ITEM_MAX_DISPLAY_CHARS_MEDIUM
                                                                                         wholeWords:YES] doublequote] ;
        // If name is empty, it will now be 2 characters, the doublequotes.
        if ([name length] < 3) {
            name = @"this web page" ;
        }
        [item setTitle:[NSString localizeFormat:
						@"addWhatToX1",
						name]] ;
		[menu addItem:item] ;
		[item scaleAndSetImage:addingImage] ;
		[item release] ;
		
		// Since we've already had to fetch recentLandings, I think that
		// it would be efficient to create the submenu now.
		
		submenu = [[NSMenu alloc] init] ;
        [submenu setFont:font] ;
		[item setSubmenu:submenu] ;
		
		Stark* landing = [[bkmxDoc shig] landing] ;

		// Add one item for each Recent Landing
		for (Stark* aLanding in recentLandings) {
			item = [[NSMenuItem alloc] init] ;
			[item setTarget:(BkmxAppDel*)[NSApp delegate]] ;
			[item setAction:@selector(landNewBookmarkFromMenuItem:)] ;
			[item setRepresentedObject:[browmarkInfo dictionaryBySettingValue:aLanding
																	   forKey:constKeyParent]] ;
			NSString* title = [[aLanding name] stringByTruncatingMiddleToLength:MENU_ITEM_MAX_DISPLAY_CHARS_LONG
																	wholeWords:YES] ;
			if (aLanding == landing) {
				title = [title stringByAppendingFormat:
						 @" (%@)",
						 [[BkmxBasis sharedBasis] labelNewBookmarkLandingShort]] ;
			}
			[submenu addItem:item] ;
			[item scaleAndSetImage:folderImage] ;

			[item setTitle:title] ;
			[item release] ;
		}
		
		// If the default New Bookmark Landing and/or Root have not already been
		// added as Recent Landings, we should add them.
		BOOL shouldAddRecentLanding = [recentLandings indexOfObject:landing] == NSNotFound ;
		BOOL shouldAddRoot = (root != landing)
		&& ([recentLandings indexOfObject:root] == NSNotFound)
		&& [bkmxDoc rootLeavesOk] ;
		
		// Separator item, if warranted
		if (([recentLandings count] > 0) && (shouldAddRecentLanding || shouldAddRoot)) {
			item = [NSMenuItem separatorItem] ;
			[submenu addItem:item] ;
		}
		
		// New Bookmark Landing
		if (shouldAddRecentLanding) {
			item = [[NSMenuItem alloc] init] ;
			[item setRepresentedObject:[browmarkInfo dictionaryBySettingValue:landing
																	   forKey:constKeyParent]] ;
			[item setTarget:(BkmxAppDel*)[NSApp delegate]] ;
			[item setAction:@selector(landNewBookmarkFromMenuItem:)] ;
			NSString* landingProperName = [[landing name] stringByTruncatingMiddleToLength:MENU_ITEM_MAX_DISPLAY_CHARS_SHORT
																				wholeWords:YES] ;
            NSString* landingName = [NSString stringWithFormat:
                                     @"%@ (%@)",
                                     landingProperName,
                                      [[BkmxBasis sharedBasis] labelNewBookmarkLandingShort]] ;
            /*
             The order of the following statements may be important to prevent
             the menu item title from being truncated for large font sizes.
             I'm not sure.  Worked on the problem for about an hour and in te
             end it seemed to go away by itself.
             */
			[item setTitle:landingName] ;
            [item scaleAndSetImage:folderImage] ;
			[submenu addItem:item] ;
			[item release] ;
        }
		
		// "Root" item
		if (shouldAddRoot) {
			item = [[NSMenuItem alloc] init] ;
			[item setRepresentedObject:[browmarkInfo dictionaryBySettingValue:root
																	   forKey:constKeyParent]] ;
			[item setTarget:(BkmxAppDel*)[NSApp delegate]] ;
			[item setAction:@selector(landNewBookmarkFromMenuItem:)] ;
			[item setTitle:[root name]] ;
			[item scaleAndSetImage:folderImage] ;
			[submenu addItem:item] ;
			[item release] ;
		}
	}
    else {
        NSString* msg ;
        switch ([error code]) {
            case SSYInterappClientErrorCantFindReceiver:
                msg = [NSString stringWithFormat:
                       NSLocalizedString(@"Please check extension in %@ > Manage Browser Extensions", nil),
                       [[BkmxBasis sharedBasis] appNameLocalized]] ;
                break ;
            case SSYInterappClientErrorReceiveTimeout:
                msg = NSLocalizedString(@"Browser may be busy, please try again", nil) ;
                break ;
            default:
                msg = nil ;
        }

        if (msg) {
            /* Should make this item clickable, to help book anchor */
            item = [[NSMenuItem alloc] init] ;
            [item setTitle:msg] ;
            [menu addItem:item] ;
            [item release] ;
        }
    }
	
	[submenu release] ;
    [hierMenu setDoRoot:NO] ;
	
    if ([[NSUserDefaults standardUserDefaults] boolForKey:constKeyBookmarksInDoxtus]) {
	// Add one item for each child of root
        for (Stark* stark in [root childrenOrdered]) {
            id target ;
            
            if ([stark canHaveUrl]) {
                // Visitable item at root
                target = hierMenu ;
                action = @selector(hierarchicalMenuAction:) ;
            }
            else {
                target = nil ;
                action = NULL ;
            }
            
            if ([stark sharypeValue] == SharypeSeparator) {
                item = [NSMenuItem separatorItem] ;
                [menu addItem:item] ;
            }
            else {
                item = [[NSMenuItem alloc] initWithTitle:[stark nameNoNil]
                                                  action:action
                                           keyEquivalent:@""] ;
                [menu addItem:item] ;
                [item release] ;
                [item setRepresentedObject:stark] ;
                [item setFontColor:[stark color]
                              size:fontSize] ;
                [item setTarget:target] ;
                if ([stark canHaveChildren]) {
                    NSMenu* submenu = [[NSMenu alloc] init] ;
                    [submenu setFont:font] ;
                    [submenu setDelegate:hierMenu] ;
                    [item setSubmenu:submenu] ;
                    [submenu release] ;
                }
            }
        }
    }
}

- (void)insertMiniSearchMenuItem {
    NSString* title = NSLocalizedString(@"Mini Search", nil);
    NSMenuItem* item = [[NSMenuItem alloc] initWithTitle:title
                                                  action:@selector(showMiniSearchWindow:)
                                           keyEquivalent:@""];
    [item setTarget:(BkmxAppDel*)[NSApp delegate]];
    [self insertItem:item
             atIndex:[self numberOfItems]];
    [item release];
}

- (void)insertShowHideQuitMenuItems {
    NSString* title;
    NSMenuItem* item;
    SEL action;

    // "Show BookMacster" menu item
    title = [[BkmxBasis sharedBasis] labelShowApp] ;
    if ([SSYProcessTyper currentType] == NSApplicationActivationPolicyRegular)  {
        action = @selector(activate:) ;
    }
    else {
        // "Show BookMacster" menu item
        action = @selector(makeForeground:) ;
    }
    item = [[NSMenuItem alloc] initWithTitle:title
                                      action:action
                               keyEquivalent:@""] ;
    [item setTarget:(BkmxAppDel*)[NSApp delegate]] ;
    [self insertItem:item
             atIndex:[self numberOfItems]] ;
    [item release] ;

    // "Background BookMacster" menu item.
    if ([SSYProcessTyper currentType] == NSApplicationActivationPolicyRegular) {
        if (NSAppKitVersionNumber >= NSAppKitVersionNumber10_7) {
            // However we first need to make sure that we're showing as a
            // Status Item, lest BookMacster disappear completely!
            if ([[NSUserDefaults standardUserDefaults] integerForKey:constKeyStatusItemStyle] != BkmxStatusItemStyleNone) {
                title = [NSString stringWithFormat:
                         @"Background %@",
                         [[BkmxBasis sharedBasis] appNameLocalized]] ;
                item = [[NSMenuItem alloc] initWithTitle:title
                                                  action:@selector(background:)
                                           keyEquivalent:@""] ;
                [item setTarget:(BkmxAppDel*)[NSApp delegate]] ;
                [item setToolTip:[[BkmxBasis sharedBasis] toolTipBackground]] ;
                [self insertItem:item
                         atIndex:[self numberOfItems]] ;
                [item release] ;
            }
        }
    }

    // "Quit BookMacster" menu item
    title = [NSString stringWithFormat:
             @"Quit %@",
             [[BkmxBasis sharedBasis] appNameLocalized]] ;
    item = [[NSMenuItem alloc] initWithTitle:title
                                      action:@selector(terminate:)
                               keyEquivalent:@""] ;
    [item setTarget:NSApp] ;
    [self insertItem:item
             atIndex:[self numberOfItems]] ;
    [item release] ;
}

/*!
 @brief    Refreshes the receiver's menu
*/
- (void)refresh {
	[self removeAllItems] ;
	
	NSMenuItem* item ;
	NSMenu* submenu ;
	NSString* title ;
	
	NSString* exformat = [(BkmxAppDel*)[NSApp delegate] activeBrowserExformat] ;
	NSArray* documents = [[NSDocumentController sharedDocumentController] documents] ;
	NSInteger nDocuments = [documents count] ;
	NSDictionary* browmarkInfo = [self lastBrowmarkInfo] ;
    
    // Use user's preferred font size for self.  This fontSize and font will
    // also be applied to any submenus.
    CGFloat fontSize = [[NSUserDefaults standardUserDefaults] doubleForKey:constKeyMenuFontSize] ;
	NSFont* font = [NSFont systemFontOfSize:fontSize] ;
    [self setFont:font] ;
	
	if (!exformat) {
		// No supported browser is running
		title = [NSString localizeFormat:
				 @"no%0",
				 [NSString localize:@"browser"]] ;
		item = [[NSMenuItem alloc] initWithTitle:title
										  action:NULL
								   keyEquivalent:@""] ;
		[self insertItem:item
				 atIndex:[self numberOfItems]] ;
		[item release] ;
	}

    NSInteger miniSearchPosition = [[NSUserDefaults standardUserDefaults] integerForKey:constKeyMiniSearchPosition] ;
    NSInteger showHideQuitItemsPosition = [[NSUserDefaults standardUserDefaults] integerForKey:constKeyDoxtusShowHideQuitMenuItemsPosition];

    BOOL needsUpperSeparator = NO;
    if (miniSearchPosition == 0) {
        if (nDocuments > 0) {
            [self  insertMiniSearchMenuItem];
            needsUpperSeparator = YES;
            // and, so it will not be inserted again, below…
            miniSearchPosition = NSIntegerMax ;
        }
    }

    if (showHideQuitItemsPosition == 0) {
        [self insertShowHideQuitMenuItems];
        needsUpperSeparator = YES;
    }

    if (needsUpperSeparator) {
        [self insertItem:[NSMenuItem separatorItem]
                 atIndex:[self numberOfItems]] ;
    }
    
    NSInteger priorNumberOfItems = [self numberOfItems] ;
    SEL action ;

    if (nDocuments > 0) {
        // Collection(s) are available to add new items to and visit old items from
        
        [self setExformat:exformat] ;
        
        StarkContainersHierarchicalMenu* hierMenu = [self hierMenu] ;
        if ([[browmarkInfo objectForKey:constKeyUrl] length] > 0) {
            [hierMenu setAddHereInfo:browmarkInfo] ;
        }
        [hierMenu setDoLeaves:YES] ;
        
        NSArray* documents = [[NSDocumentController sharedDocumentController] documents] ;
        BOOL oneDoc = ([documents count] == 1) ;
        
        if (oneDoc) {
            BkmxDoc* bkmxDoc = (BkmxDoc*)[documents objectAtIndex:0] ;
            
            [DoxtusMenu populateMostOfMenu:self
                                   bkmxDoc:bkmxDoc
                              browmarkInfo:browmarkInfo
                                  hierMenu:hierMenu] ;
        }
        else if (
                 [[NSUserDefaults standardUserDefaults] boolForKey:constKeyBookmarksInDoxtus]
                 ||
                 browmarkInfo // because we'll still need the "Add here" menu item
                 ) {
            [hierMenu setDoRoot:YES] ;
            
            // Add one item for each document
            for (BkmxDoc* bkmxDoc in documents) {
                item = [[NSMenuItem alloc] initWithTitle:[bkmxDoc displayName]
                                                  action:NULL
                                           keyEquivalent:@""] ;
                [self insertItem:item
                         atIndex:[self numberOfItems]] ;
                [item release] ;
                NSMenu* submenu = [[NSMenu alloc] init] ;
                [submenu setFont:font] ;
                [DoxtusMenu populateMostOfMenu:submenu
                                       bkmxDoc:bkmxDoc
                                  browmarkInfo:browmarkInfo
                                      hierMenu:hierMenu] ;
                [item setSubmenu:submenu] ;
                [submenu release] ;
            }
        }
 	}
	else {
		// No BkmxDoc is open.  Need a BkmxDoc to either Visit or Add.
		title = [NSString localizeFormat:
				 @"openNoX",
				 [[NSDocumentController sharedDocumentController] defaultDocumentDisplayName]] ;
		item = [[NSMenuItem alloc] initWithTitle:title
										  action:NULL
								   keyEquivalent:@""] ;
		[self insertItem:item
				 atIndex:[self numberOfItems]] ;
		[item release] ;
		
		// "Open Recent, show the window" menu item
        // The following if() qualification was added in BookMacster 1.16.1
		if ([SSYProcessTyper currentType] == NSApplicationActivationPolicyRegular)  {
            title = NSLocalizedString(@"Open Recent, show the window", nil) ;
            item = [[NSMenuItem alloc] initWithTitle:title
                                              action:nil
                                       keyEquivalent:@""] ;
            [item setTarget:[NSDocumentController sharedDocumentController]] ;
            [self insertItem:item
                     atIndex:[self numberOfItems]] ;
            [item release] ;
            action = @selector(openAndDisplayDocumentUrlInMenuItem:) ;
            NSDocumentController* dc = [NSDocumentController sharedDocumentController];
            submenu = [dc recentDocumentsSubmenuWithTarget:dc
                                                    action:action
                                                  fontSize:fontSize] ;
            [item setSubmenu:submenu] ;
        }
		
		// "Open Recent, dock the window" menu item
        // The following if() qualification was added in BookMacster 1.16.1
		if ([SSYProcessTyper currentType] == NSApplicationActivationPolicyRegular)  {
            title = NSLocalizedString(@"Open Recent, dock the window", nil) ;
            item = [[NSMenuItem alloc] initWithTitle:title
                                              action:nil
                                       keyEquivalent:@""] ;
            [item setTarget:[NSDocumentController sharedDocumentController]] ;
            [self insertItem:item
                     atIndex:[self numberOfItems]] ;
            [item release] ;
            action = @selector(openMiniaturizedDocumentUrlInMenuItem:) ;
            submenu = [[NSDocumentController sharedDocumentController] recentDocumentsSubmenuWithTarget:[NSDocumentController sharedDocumentController]
                                                                                                 action:action
                                                                                               fontSize:fontSize] ;
            [submenu setFont:font] ;
            [item setSubmenu:submenu] ;
        }
        
		// WARNING: I tried to make this menu item work when we're not LSUIElement
		// but it was weird.  BkmxAppDel/Inspector didn't get the selectedStark,
		// if you "Add & Inspect", and the window showed up in the dock but
		// nothing happened if you clicked on it.
		if ([SSYProcessTyper currentType] != NSApplicationActivationPolicyRegular)  {
			// "Open Recent, don't show the window" menu item
			title = NSLocalizedString(@"Open Recent, don't show the window", nil) ;
			item = [[NSMenuItem alloc] initWithTitle:title
											  action:nil
									   keyEquivalent:@""] ;
			[item setTarget:[NSDocumentController sharedDocumentController]] ;
			[self insertItem:item
					 atIndex:[self numberOfItems]] ;
			[item release] ;
			action = @selector(openWindowlessDocumentUrlInMenuItem:) ;
			submenu = [[NSDocumentController sharedDocumentController] recentDocumentsSubmenuWithTarget:[NSDocumentController sharedDocumentController]
																								 action:action
																							   fontSize:fontSize] ;
            [submenu setFont:font] ;
			[item setSubmenu:submenu] ;
		}				

	}
	
    if ([self numberOfItems] > priorNumberOfItems) {
        // Separator
        [self insertItem:[NSMenuItem separatorItem]
                 atIndex:[self numberOfItems]] ;
    }
    
    if (miniSearchPosition == 1) {
        if (nDocuments > 0) {
            [self insertMiniSearchMenuItem];
            // and, so it will not be inserted again, below…
            miniSearchPosition = NSIntegerMax ;
        }
    }

    // "Inspect [Last Landed]" menu item
    Stark* lastLandedBookmark = nil ;
    for (BkmxDoc* bkmxDoc in [[NSDocumentController sharedDocumentController] documents]) {
        if ([bkmxDoc respondsToSelector:@selector(lastLandedBookmark)]) {
            Stark* stark = [bkmxDoc lastLandedBookmark] ;
            if (!lastLandedBookmark) {
                lastLandedBookmark = stark ;
            }
            else if ([[stark addDate] timeIntervalSinceReferenceDate] > [[lastLandedBookmark addDate] timeIntervalSinceReferenceDate]) {
                lastLandedBookmark = stark ;
            }
        }
    }
    if (lastLandedBookmark) {
        title = [NSString stringWithFormat:
                 @"Inspect %@",
                 [[[lastLandedBookmark name] stringByTruncatingMiddleToLength:MENU_ITEM_MAX_DISPLAY_CHARS_MEDIUM
                                                                   wholeWords:YES] doublequote]] ;
        item = [[NSMenuItem alloc] initWithTitle:title
                                          action:@selector(inspectStark:)
                                   keyEquivalent:@""] ;
        [item setTarget:(BkmxAppDel*)[NSApp delegate]] ;
        [item setRepresentedObject:lastLandedBookmark] ;
        [self insertItem:item
                 atIndex:[self numberOfItems]] ;
        [item release] ;
    }
    
    if (showHideQuitItemsPosition > 0) {
        [self insertShowHideQuitMenuItems];
    }

    if ([SSYProcessTyper currentType] != NSApplicationActivationPolicyRegular) {
        // Separator
        [self insertItem:[NSMenuItem separatorItem]
                 atIndex:[self numberOfItems]] ;
        

        title = [NSString stringWithFormat:
                 @"(%@ is in background.)",
                 [[BkmxBasis sharedBasis] appNameLocalized]] ;
		item = [[NSMenuItem alloc] initWithTitle:title
										  action:NULL
								   keyEquivalent:@""] ;
		[self insertItem:item
				 atIndex:[self numberOfItems]] ;
		[item release] ;
    }
    
    if (miniSearchPosition == 2) {
        if (nDocuments > 0) {
            [self insertMiniSearchMenuItem];
        }
    }
}

- (id)init {
	self = [super initWithTitle:NSLocalizedString(@"Doxtus Menu", nil)] ;  // Title is for troubleshooting only
	if (self) {
		[self setAutoenablesItems:YES] ;
		[self setDelegate:self] ;
        [self setFont:[NSFont systemFontOfSize:[[NSUserDefaults standardUserDefaults] doubleForKey:constKeyMenuFontSize]]] ;
		[self refresh] ;
	}
	
	return self ;
}	

- (void)popUpAnywhereMenu {
    NSPoint mouseLocation = [NSEvent mouseLocation] ;
	NSArray* itemArray = [self itemArray] ;
    if ([itemArray count] > 0) {
        NSMenuItem* item = [itemArray objectAtIndex:0] ;
        [self popUpMenuPositioningItem:item
                            atLocation:mouseLocation
                                inView:nil] ;
    }
}

// KVC Compliance for 'statusItemStyle'

- (void)setStatusItemStyle:(BkmxStatusItemStyle)style {
    NSStatusItem* item = [self statusItem] ;
    if ((style != BkmxStatusItemStyleNone) && (item != nil)) {
        // Keep the existing status item
    }
    else if ((style != BkmxStatusItemStyleNone) && (item == nil)) {
        // Create the currently-nonexistent status item
        
		NSStatusBar *bar = [NSStatusBar systemStatusBar] ;
		
		item = [bar statusItemWithLength:NSSquareStatusItemLength] ;
		[self setStatusItem:item] ;
		
        /* If I log here the value of highlightsBy before setting it, I see it
         is 0x9 = NSContentsCellMask + NSChangeBackgroundCellMask.  Apparently
         this is the default value.  I also tried this:
         ((NSButtonCell*)(item.button.cell)).highlightsBy = NSChangeGrayCellMask;
         But as far as I can see, either way works the same.  So I leave it
         at the defaulte. */

		[item setMenu:self] ;
		[self refresh] ;
	}
	else {
        // Destroy the existing status item
        
		// According to Status Bar Programming Topics > 
		// Creating Status Items, "When deallocated, the status
		// item removes itself from the status bar."
		// Okey dokey.  Well, -setStatusItem:nil does this.
		[self setStatusItem:nil] ;
	}
    
    NSImage* image = [(BkmxAppDel*)[NSApp delegate] statusItemImageForStyle:style] ;
    if ((floor(NSAppKitVersionNumber) > NSAppKitVersionNumber10_9)) {
        /* The effect of setting this oddly-named property to YES is
         that the image will reverse luminosity for users who have
         switched on "Use dark menu bar and Dock" in System Preferences
         > General in OS X 10.10 or later.  As a side effect, it is
         displayed in grayscale (no color) */
        [image setTemplate:YES] ;
    }
    [self statusItem].button.image=image;

    // In the above, if style is BkmxStatusItemStyleNone, [self statusItem]
    // will be nil and image will be nil.  Otherwise, [self statusItem] will
    // be non-nil and image will be non-nil.
    
    m_statusItemStyle = style ;
}

// Just needed for KVC, to make statusItemStyle bindable.
- (BkmxStatusItemStyle)statusItemStyle {
    return m_statusItemStyle ;
}

/* Note the distinct delegations.  Although a Doxtus Menu instance is
 its own delegate and therefore this here -menuNeedsUpdate:
 method is invoked whenever it is displayed, the delegate
 of its hierarchical submenus is the topmost hierarchical
 instance of StarkContainersHierarchicalMenu.  To see
 this, search this file for setDelegate:
 */
- (void)menuNeedsUpdate:(NSMenu*)menu {
	NSDictionary* browmarkInfo ;
    switch ([[BkmxBasis sharedBasis] iAm]) {
        case BkmxWhich1AppBookMacster:
        case BkmxWhich1AppMarkster:
            browmarkInfo = [self grabActivePage] ;
            // Instead of simply passing browmarkInfo to -refresh, we remember
            // it in an instance variable.  This is done so that if the user
            // accidentally activates a non-browser app, then clicks us, which
            // will cause -grabActivePage to return nil, we'll still have the
            // browmark info from the prior web page.
            if (browmarkInfo) {
                [self setLastBrowmarkInfo:browmarkInfo] ;
            }
            
            break ;
        default:
            browmarkInfo = nil ;
    }

	[self refresh] ;
}

@end
