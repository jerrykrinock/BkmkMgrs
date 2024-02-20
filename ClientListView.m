#import "ClientListView.h"
#import "SSYVectorImages.h"
#import "SSYBinderView.h"
#import "Macster.h"
#import "ClientChoice.h"
#import "Ixporter.h"
#import "Client.h"
#import "BkmxBasis+Strings.h"
#import "NSString+LocalizeSSY.h"
#import "NSArray+SSYMutations.h"
#import "BkmxDocWinCon.h"
#import "BkmxDocumentController.h"
#import "NSError+InfoAccess.h"
#import "Clientoid.h"
#import "ClientInfoController.h"
#import "BkmxDoc.h"
#import "BkmxDocumentProvider.h"
#import "Extore.h"
#import "NSMenuItem+Font.h"
#import "ClientListButton.h"
#import "NS(Attributed)String+Geometrics.h"
#import "BkmxDoc.h"

NSString* const constNoteClientListViewDidReheight = @"clientListViewDidReheight" ;
NSString* const constKeyClientListViewNewHeight = @"clientListViewNewHeight" ;
NSString* const constKeyKeyPath = @"clientsOrdered" ;

@interface ClientListView ()

@property (assign) CGFloat initialY ;
@property (assign) CGFloat rowHeight ;
@property (assign) BOOL hasPlaceholderChoice ;
@property (assign) NSInteger itemCount;

- (void)update ;

@end


@implementation ClientListView

@synthesize initialY = m_initialY ;
@synthesize rowHeight = m_rowHeight ;
@synthesize hasPlaceholderChoice = m_hasPlaceholderChoice ;
@synthesize hasAdvancedButton = m_hasAdvancedButton ;

- (NSString*)accessibilityLabel {
    return [NSString stringWithFormat:
            NSLocalizedString(@"List of available %@", nil),
            [[BkmxBasis sharedBasis] labelClients]];
}

- (Macster*)macster {
	id bkmxDoc = [documentProvider theDocument] ;
	Macster* macster = [bkmxDoc macster] ;
	
	return macster ;
}

- (NSArray*)clients {
	Macster* macster = [self macster] ;
	NSArray* clients = [macster valueForKeyPath:constKeyKeyPath] ;
	return clients ;
}

+ (CGFloat)rowHeight {
    return 28.0;
}

- (CGFloat)rowHeight {
    return [[self class] rowHeight];
}

- (void)setRowHeight:(CGFloat)rowHeight {
    m_rowHeight = rowHeight;
}

- (CGFloat)currentHeight {
	CGFloat height = MAX([[self clients] count], 1) * [self rowHeight] ;
	return height ;
}

/*!
 @details  The purpose of this is to stop receiving notifications
 SSYDocumentDidSaveNotification and constNoteBkmxClientDidChange
 which were set in -awakeFromNib, after it has been announced that
 the window is closing.  Added in BookMacster 1.6.4 to fix
 occasional crashes seen when AppleScripting documents to close.
 It seems to have worked.
*/
- (void)removeObservers {
	[[NSNotificationCenter defaultCenter] removeObserver:self] ;
}


- (void)dealloc {
	// This should already have been done by -[BkmxDocWinCon windowWillClose],
	// but we do it once more as defensive programming.
	[self removeObservers] ;

	[super dealloc] ;
}

- (CGFloat)buttonImageDiameter {
    // Not important because it's going to be scaled anyhow
	return [self rowHeight] ;
}

#define OFFSET_ADDED_TO_TAG_OF_GEAR_BUTTON 1000

- (NSInteger)indexOfControl:(NSControl*)control {
    return control.tag % OFFSET_ADDED_TO_TAG_OF_GEAR_BUTTON;
}

- (BOOL)isGearButton:(NSControl*)control {
    return control.tag >= OFFSET_ADDED_TO_TAG_OF_GEAR_BUTTON;
}

- (NSInteger)tagForGearButtonAtClientIndex:(NSInteger)index {
    return index + OFFSET_ADDED_TO_TAG_OF_GEAR_BUTTON;
}

- (void)moveButton:(NSButton*)sender
			 delta:(NSInteger)delta {
    NSInteger oldIndex = [self indexOfControl:sender];
	NSInteger newIndex = oldIndex + delta ;
	
	Client* client = [[self clients] objectAtIndex:oldIndex] ;
	Client* otherClient = [[self clients] objectAtIndex:newIndex] ;
	
	[client setIndex:[NSNumber numberWithInteger:newIndex]] ;
	[otherClient setIndex:[NSNumber numberWithInteger:oldIndex]] ;
}

// Until BookMacster 1.5.6, the following two methods were named
// -moveUp: and -moveDown:.  But this caused these messages to ge
// received by the window, and an exception, if you hit the up-arrow
// or down-arrow key while ClientListNiew was showing.  So I changed
// the names in that class, and also here, to resolve the conflict.

- (IBAction)moveClientUp:(NSButton*)sender {
	[self moveButton:sender
			   delta:-1] ;
}

- (IBAction)moveClientDown:(NSButton*)sender {
	[self moveButton:sender
			   delta:+1] ;
}
          
- (IBAction)add:(NSButton*)sender {
    NSError* operationsInProgressError = [[BkmxDocumentController sharedDocumentController] operationsInProgressErrorWithCode:600481
                                                                                                                  ignoreQueue:nil] ;
    if (operationsInProgressError) {
        operationsInProgressError = [operationsInProgressError errorByAddingLocalizedRecoverySuggestion:@"Wait until other operations are done before adding another Client."] ;
        [[self window] presentError:operationsInProgressError] ;
        return ;
    }
    
	[[self macster] insertNextLikelyClient:self] ;

	[self update] ;
}

/* Find Call Hierarchy says that this method is never used.  Not sure. */
- (IBAction)remove:(NSButton*)sender {
    NSError* operationsInProgressError = [[BkmxDocumentController sharedDocumentController] operationsInProgressErrorWithCode:600481
                                                                                                 ignoreQueue:nil] ;
    if (operationsInProgressError) {
        operationsInProgressError = [operationsInProgressError errorByAddingLocalizedRecoverySuggestion:@"Wait until other operations are done before removing a Client."] ;
        [[self window] presentError:operationsInProgressError] ;
        return ;
    }
    
	NSInteger index = [self indexOfControl:sender];
	Client* client = [[self clients] objectAtIndex:index] ;
	[[self macster] deleteClient:client] ;

	[self update] ;
}

- (IBAction)info:(id)button {
	NSInteger index = [self indexOfControl:button] ;
	Client* client = [[self clients] objectAtIndex:index] ;

	ClientInfoController* sheetController = [(ClientInfoController*)[ClientInfoController alloc] initWithClient:client] ;
	// Note: sheetController is released in -[ClientInfoController done:]
	
	// Note: In the nib containing the sheet/window, make sure that in the
	// window attribute "Visible on Launch" is NOT checked.  If it is,
	// the window will display immediately as a freestanding window
	// instead of the next line attaching it to hostWindow as a sheet.
	
	NSWindow* hostWindow = [self window] ;
	NSWindow* sheet = [sheetController window] ;
	
    [hostWindow beginSheet:sheet
              completionHandler:^void(NSModalResponse modalResponse) {
                  [sheetController release] ;
              }] ;
}

- (IBAction)setActiveImportsButton:(id)button {
	NSInteger index = [self indexOfControl:button];
	Client* client = [[self clients] objectAtIndex:index] ;
	NSNumber* isActive = [NSNumber numberWithBool:([button state] == NSControlStateValueOn)] ;
	[[client importer] setIsActive:isActive] ;
}

- (IBAction)setActiveExportsButton:(id)button {
    NSInteger index = [self indexOfControl:button];
	Client* client = [[self clients] objectAtIndex:index] ;
	NSNumber* isActive = [NSNumber numberWithBool:([button state] == NSControlStateValueOn)] ;
	[[client exporter] setIsActive:isActive] ;
}

- (IBAction)selectClientMenuItem:(id)menuItem {
	ClientChoice* newChoice = [menuItem representedObject] ;
	NSInteger index = [menuItem tag] ;
	Client* client = [[self clients] objectAtIndex:index] ;
	[client setLikeClientChoice:newChoice] ;
}

- (void)awakeFromNib {
	// Per Discussion in documentation of -[NSObject respondsToSelector:].
	// the superclass name in the following must be hard-coded.
	if ([NSControl instancesRespondToSelector:@selector(awakeFromNib)]) {
		[super awakeFromNib] ;
	}
	
	[self setInitialY:[self frame].origin.y] ;
	NSAssert([self frame].size.height == [[self class] rowHeight], @"Height of view in nib does not equal the value returned by +[ClientListView rowHeight].  Change one or the other.");
    [self setAccessibilityElement:YES];

	/* Add plus button */ {
		NSButton* plusButton = [ClientListButton buttonAtPoint:NSZeroPoint
                                          height:[self rowHeight]
                                            type:NSButtonTypeMomentaryPushIn] ;
		[plusButton setImage:[SSYVectorImages imageStyle:SSYVectorImageStylePlus
												  wength:[self buttonImageDiameter]
												   color:nil
                                            darkModeView:nil // For this template image, Cocoa will handle luminance inversion when in Dark Mode
                                           rotateDegrees:0.0
                                                   inset:[self buttonImageDiameter]*0.2]] ;
        plusButton.accessibilityLabel = [NSString stringWithFormat:
                                         NSLocalizedString(@"Add another %@", nil),
                                         [[BkmxBasis sharedBasis] labelClient]];
		// We target the plus button to a forwarding method within self,
		// instead of directly to the current macster's -insertNextLikelyClient:,
		// because our macster will change if our document undergoes a Save As
		// operation using Apple's Save As implementation.
		[plusButton setTarget:self] ;
		[plusButton setAction:@selector(add:)] ;
		// -setBackgroundColor doesn't work unless you setBordered:NO, but the
		// latter results in a square button instead of a round one.
		//[[plusButton cell] setBackgroundColor:[NSColor greenColor]] ;
		//[plusButton setBordered:NO] ;
		NSString* tip = [NSString localizeFormat:
						 @"addX",
						 [NSString localizeFormat:
						  @"new%0",
						  [[BkmxBasis sharedBasis] labelClient]]] ;
		[plusButton setToolTip:tip] ;
		[self addSubview:plusButton] ;
	}
	
	// In case of a Save As operation, we'll need to update view due to
	// window controller's document's new macster
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(note:)
												 name:BkmxDocDidSaveNotification
											   object:[documentProvider theDocument]] ;
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(note:)
												 name:constNoteBkmxClientDidChange
											   object:nil] ;
	
    // Added delay in BookMacster 1.21, to ensure that -setHasAdvancedButton
    // in -[SettingsViewController awakeFromNib] would run before -update.
	[self performSelector:@selector(update)
               withObject:nil
               afterDelay:0.0] ;
}

- (void)setFrame:(NSRect)frame {
	CGFloat oldY = [self frame].origin.y ;
	[super setFrame:frame] ;
	
	CGFloat newY = frame.origin.y ;
	CGFloat deltaY = newY - oldY ;
	[self setInitialY:([self initialY] + deltaY)] ;
}

#define ONE_FOR_PLUS_BUTTON 1
#define BITSHIFT_FOR_SUBVIEW_INDEX 8*sizeof(NSInteger)/2
#define POPUP_BUTTON_WIDTH_IN_ADDITION_TO_TEXT 30.0
- (NSControl*)gearButtonForClientAtIndex:(NSInteger)index {
	NSControl* button = nil ;
	
	// Maybe defensive programming…
	if ([[self subviews] count] > 1) {
		NSView* rowView = [[self subviews] objectAtIndex:(index + ONE_FOR_PLUS_BUTTON)] ;
        for (NSControl* control in [rowView subviews]) {
            if ([self isGearButton:control]) {
                button = control;
            }
        }
	}
	
	return button ;
}

- (CGFloat)requiredWidth {

    Macster* macster = [self macster] ;
    NSArray* menuChoices = [macster availableClientChoicesAlwaysIncludeChooseFile:NO
                                                                   includeWebApps:YES
                                                             includeNonClientable:NO] ;
    CGFloat requiredWidth = 0.0;
    for (ClientChoice* choice in menuChoices) {
        NSString* name = [choice displayName];
        NSMenu* simulatedMenu = [[NSMenu alloc] init];
        NSFont* font = [simulatedMenu font];
        [simulatedMenu release];
        CGFloat width = [name widthForHeight:CGFLOAT_MAX
                                        font:font];
        if (width > requiredWidth) {
            requiredWidth = width;
        }
    }

    requiredWidth += POPUP_BUTTON_WIDTH_IN_ADDITION_TO_TEXT;
    requiredWidth += [self deadWidth];

    return requiredWidth;
}

- (void)menuNeedsUpdate:(NSMenu*)menu {
	[menu removeAllItems] ;
	
	// Decode indexes from title
	NSInteger encodedIndexes = [[menu title] integerValue] ;
	NSInteger clientIndexBitmask = ((NSInteger)1 << BITSHIFT_FOR_SUBVIEW_INDEX) - 1 ;
	NSInteger subviewIndex = encodedIndexes >> BITSHIFT_FOR_SUBVIEW_INDEX ;
	NSInteger clientIndex = encodedIndexes & clientIndexBitmask ;

	NSView* itemView = [[self subviews] objectAtIndex:subviewIndex] ;
	NSPopUpButton* popUpButton = nil ;
	for (NSPopUpButton* control in [itemView subviews]) {
		if ([control respondsToSelector:@selector(selectItem:)]) {
			popUpButton = control ;
			break ;
		}
	}
	Clientoid* clientoid = [(Client*)[[self clients] objectAtIndex:clientIndex] clientoid] ;
	ClientChoice* currentChoice = [ClientChoice clientChoiceWithClientoid:clientoid] ;
	
	NSArray* menuChoices = [[self macster] availableClientChoicesAlwaysIncludeChooseFile:NO
                                                                          includeWebApps:YES
                                                                     includeNonClientable:NO] ;

    BOOL currentChoiceIsUnavailable = [currentChoice isLocalThisUserNotInChoices:menuChoices] ;
    
	// Add more choices to include non-thisUser "other" items
	// which are in use.
	NSMutableArray* moreChoices = [[NSMutableArray alloc] init] ;
	for (Client* client in [self clients]) {
		if (![[client extoreMedia] isEqualToString:constBkmxExtoreMediaThisUser]) {
			Clientoid* clientoid = [client clientoid] ;
			ClientChoice* choice = [ClientChoice clientChoiceWithClientoid:clientoid] ;
			[moreChoices addObject:choice] ;
		}
	}

    // Still, after all this, it is possible that the current choice is still
	// not in the list, because it may be a web app account which has never been
	// imported and thus does not have any local moc .sql file.
	// So, we now add it explicitly at the end, to moreChoices.  We added it to
    // *moreChoices* so that it will be uniqued out of duplicated.
	[moreChoices addObject:currentChoice] ;

	menuChoices = [menuChoices arrayByAddingUniqueObjectsFromArray:moreChoices] ;
	[moreChoices release] ;
	
	NSInteger j = 0 ;

	[self setHasPlaceholderChoice:NO] ;
    for (ClientChoice* choice in menuChoices) {
		NSMenuItem* menuItem = [menu insertItemWithTitle:[choice displayName]
												  action:@selector(selectClientMenuItem:)
										   keyEquivalent:@""
												 atIndex:j] ;
		[menuItem setTag:clientIndex] ;
		BOOL isSelected = [choice isEqual:currentChoice] ;
		BOOL enabled = ![choice isInUse] || isSelected ;
 		if (enabled) {
			[menuItem setTarget:self] ;
			[menuItem setRepresentedObject:choice] ;
		}
        else {
            // This branch added in BookMacster 1.14.7
            [menuItem setTarget:nil] ;
            [menuItem setEnabled:NO] ;
        }
		if (isSelected) {
			[popUpButton selectItem:menuItem] ;
		}
        
        if ([[choice clientoid] isPlaceholder]) {
            [self setHasPlaceholderChoice:YES] ;
        }

        // Added in BookMacster 1.22.16 because, in macOS 10.10, the menu items'
        // text are light gray, hard to read.  This happens in both
        // BookMacster > document > Settings > Clients and in
        // Synkmark > Preferences > Syncing
        //  Setting to [NSColor controlTextColor] does not help, still gray.
        [menuItem setFontColor:[NSColor controlTextColor]
                          size:0.0] ;

        // Added in BookMacster 1.20
        if (currentChoiceIsUnavailable) {
            if (choice == currentChoice) {
                // Prepend a HEAVY MULTIPLICATION X (heavy red 'X') to the title
                NSString* title = [NSString stringWithFormat:
                                   @"%C %@",
                                   (unichar)0x2716,
                                   [menuItem title]] ;
                [menuItem setTitle:title] ;
                /* Make it reddish.  It would be better to have deep red
                 normally, and light red when the item was highlighted, as the
                 latter would better contrast with the deep blue highlight
                 background, and such behavior would mimic the way other menu
                 items switch from black to white.  However, I gave up on that
                 after a couple of reasonable ideas failed,
                 http://stackoverflow.com/questions/20722374/set-font-color-of-nsmenuitem-to-alternate-when-highlighted
                 and instead I use a compromised "pretty deep" red… */
                NSColor* color = [NSColor colorWithCalibratedRed:1.0 green:0.25 blue:0.25 alpha:1.0] ;
                [menuItem setFontColor:color
                                  size:0.0] ;
                [menuItem setToolTip:[NSString stringWithFormat:
                                      @"This Client is no longer available and will not function.\n\n"
                                      @"You should either restore its data to %@, or click it and select a client which is available, or delete it.",
                                      [[[choice clientoid] extoreClass] ownerAppDisplayName]]] ;
            }
        }
        
		j++ ;
	}
}

- (CGFloat)widthPerButton {
    // We make the arbitrary cosmetic decision that width should equql height.
    return [self rowHeight];
}

- (CGFloat)deadWidth {
    NSInteger countOfButtons = 6; // [+], [-], [] Import, [] Export, [^], [v]
    if ([self hasAdvancedButton]) {
        countOfButtons++;
    }

    return countOfButtons * [self widthPerButton];
}

- (void)update {
	m_updatePending = NO ;
	NSArray* subviewsCopy = [[self subviews] copy] ;
	// Note that the [+] button is a separate mini-view.
	// The [+] button is *not* part of the item view to which it is adjacent.
	NSInteger si = 0 ;
	for (SSYBinderView* subview in subviewsCopy) {
		// Remove all except the [+] button subview, which is the
		// first subview.
		if (si > 0) {
			[subview removeFromSuperviewWithoutNeedingDisplay] ;
		}
		si++ ;
	}
	[subviewsCopy release] ;
	
	CGFloat widthPerButton = [self widthPerButton] ;
	// This -widthPerButton is to leave room on the left for the [+] button
	NSRect frame = [self frame] ;
	CGFloat itemWidth = frame.size.width - widthPerButton * ONE_FOR_PLUS_BUTTON ;
	NSArray* clients = [self clients] ;
	NSInteger rowCount = MAX([clients count], ONE_FOR_PLUS_BUTTON) ;
	CGFloat newHeight = [self rowHeight] * rowCount ;
	frame.size.height = newHeight ;
	frame.origin.y = [self initialY] - (frame.size.height - [self rowHeight]) ;
	// Invoke super to bypass our implementation of setFrame:
	[super setFrame:frame] ;
	
	NSDictionary* userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithDouble:newHeight]
														 forKey:constKeyClientListViewNewHeight] ;
	NSNotification* notification = [NSNotification notificationWithName:constNoteClientListViewDidReheight
																 object:self
															   userInfo:userInfo] ;	
	[[NSNotificationCenter defaultCenter] postNotification:notification] ;
	
	CGFloat x ;
	CGFloat y = frame.size.height ;	
	
	NSButton* button ;
	NSString* tip ;
	
    CGFloat popUpHeight = [self rowHeight] - 2 * [ClientListButton buttonMargin] ;
    CGFloat popUpWidthWithMargins = [self frame].size.width - [self deadWidth] ;
    CGFloat popUpWidth = popUpWidthWithMargins - 2 * [ClientListButton buttonMargin] ;
    CGFloat upDownButtonInset = [self rowHeight] / 4;
    CGFloat upDownButtonWength = [self rowHeight] - 2 * upDownButtonInset;

    NSInteger clientIndex = 0 ;
	if ([clients count] > 0) {	
		for (Client* client in clients) {
			// Create the item view
			y -= widthPerButton ;
			NSRect itemFrame = NSMakeRect(
										  widthPerButton * ONE_FOR_PLUS_BUTTON,
										  y,
										  itemWidth,
										  widthPerButton) ;
			SSYBinderView* itemView = [[SSYBinderView alloc] initWithFrame:itemFrame] ;
			[self addSubview:itemView] ;
			[itemView release] ;
			
			x = 0 ;
			
			// Add the minus button to the item view
            button = [ClientListButton buttonAtPoint:NSZeroPoint
                                              height:[self rowHeight]
                                                type:NSButtonTypeMomentaryPushIn] ;

            [button setImage:[SSYVectorImages imageStyle:SSYVectorImageStyleMinus
                                                  wength:[self buttonImageDiameter]
                                                   color:nil
                                            darkModeView:nil // For this template image, Cocoa will handle luminance inversion when in Dark Mode
                                           rotateDegrees:0.0
                                                   inset:[self buttonImageDiameter]*0.2]] ;
            button.accessibilityLabel = [NSString stringWithFormat:
                                         NSLocalizedString(@"Remove this %@", nil),
                                         [[BkmxBasis sharedBasis] labelClient]];
			[button setTarget:self] ;
			[button setAction:@selector(remove:)] ;
			[itemView addSubview:button] ;
			[button setTag:clientIndex] ;
			tip = [NSString localizeFormat:
				   @"removeX",
				   [[BkmxBasis sharedBasis] labelClient]] ;
			[button setToolTip:tip] ;
			x += widthPerButton ;
			
			// Add the popup menu to the item view
			NSRect frame = NSMakeRect(
									  x + [ClientListButton buttonMargin],
									  [ClientListButton buttonMargin],
									  popUpWidth,
									  popUpHeight
									  ) ;
			NSPopUpButton* popUpButton = [[NSPopUpButton alloc] initWithFrame:frame] ;
			[itemView addSubview:popUpButton] ;
			[popUpButton release] ;
			[popUpButton setBordered:NO] ;
            // [[popUpButton cell] setTruncatesLastVisibleLine:NO];  // has no effect :(
            // [[popUpButton cell] setLineBreakMode:NSLineBreakByTruncatingMiddle];  // has no effect :(
			NSMenu* menu = [popUpButton menu] ;
			// Since we don't use the title of this menu, we cleverly
			// use the 'title' attribute to pass the index of this subview,
			// and the index of the client which we'll need in -menuNeedsUpdate:.
			// Note: Given that the plus button is the first subview, the
			// subviewIndex should be 1+clientIndex, but we're doing defensive
			// programming today.
			NSInteger subviewIndex = [[self subviews] count] - 1 ;
			NSInteger encodedIndexes = clientIndex + (subviewIndex << BITSHIFT_FOR_SUBVIEW_INDEX) ;
			[menu setTitle:[NSString stringWithFormat:@"%ld", (long)encodedIndexes]] ;
			[menu setDelegate:self] ;
			// Needed for -[NSMenuItem setEnabled:],
			// in -menuNeedsUpdate, to work ...
			[menu setAutoenablesItems:NO] ;
			// Populate the menu and set the selection ...
			[self menuNeedsUpdate:menu] ;
			x += popUpWidthWithMargins ;
			
            // If wanted, add the Advanced Settings button to the item view
            if ([self hasAdvancedButton]) {
                button = [ClientListButton buttonAtPoint:NSMakePoint(x, 0)
                                                  height:[self rowHeight]
                                                    type:NSButtonTypeMomentaryPushIn] ;
                button.accessibilityLabel = [NSString stringWithFormat:
                                             NSLocalizedString(@"Edit advanced settings for %@", nil),
                                             [[BkmxBasis sharedBasis] labelClient]];
                [button setImage:[NSImage imageNamed:NSImageNameAdvanced]] ;
                [button setTarget:self] ;
                [button setAction:@selector(info:)] ;
                [itemView addSubview:button] ;
                [button setTag:[self tagForGearButtonAtClientIndex:clientIndex]];
                tip = [[BkmxBasis sharedBasis] labelShowAdvancedSettings] ;
                [button setToolTip:tip] ;
                x += widthPerButton ;
            }
            
			// Add the Import checkbox to the item view
            button = [ClientListButton buttonAtPoint:NSMakePoint(x, 0)
                                              height:[self rowHeight]
                                                type:NSButtonTypeSwitch] ;
            button.accessibilityLabel = NSLocalizedString(@"Import from", nil);
			[itemView bindSubview:button
					  bindingName:@"value"
						 toObject:[client importer]
					  withKeyPath:@"isActive"
						  options:nil] ;
			[itemView addSubview:button] ;
			[button setTag:clientIndex] ;
			tip = [NSString localize:@"imex_clientActiveImp"] ;
			[button setToolTip:tip] ;
			x += widthPerButton ;
			
			// Add the Export checkbox to the item view
            button = [ClientListButton buttonAtPoint:NSMakePoint(x, 0)
                                              height:[self rowHeight]
                                                type:NSButtonTypeSwitch] ;
			[itemView bindSubview:button
					  bindingName:@"value"
						 toObject:[client exporter]
					  withKeyPath:@"isActive"
						  options:nil] ;
			[itemView addSubview:button] ;
			[button setTag:clientIndex] ;
            button.accessibilityLabel = NSLocalizedString(@"Export to", nil);
			tip = [NSString localize:@"imex_clientActiveExp"] ;
			[button setToolTip:tip] ;
			x += widthPerButton ;
			
			// Add the Up button to the item view
			if ([client indexValue] > 0) {
                button = [ClientListButton buttonAtPoint:NSMakePoint(x + upDownButtonInset, 0 + upDownButtonInset)
                                                  height:upDownButtonWength
                                                    type:NSButtonTypeMomentaryPushIn] ;
                button.bordered = NO;
				[button setImage:[SSYVectorImages imageStyle:SSYVectorImageStyleTriangle90
													  wength:[self buttonImageDiameter]
													   color:nil
                                                darkModeView:nil // For this template image, Cocoa will handle luminance inversion when in Dark Mode
                                               rotateDegrees:0.0
                                                       inset:0.0]];
				[button setTarget:self] ;
				[button setAction:@selector(moveClientUp:)] ;
                button.accessibilityLabel = NSLocalizedString(@"Move up", nil);
				[itemView addSubview:button] ;
				[button setTag:clientIndex] ;
				tip = [NSString stringWithFormat:
					   @"%@\n\n%@",
					   [NSString localize:@"imex_clientEarlier"],
					   [NSString localize:@"imex_clientOrderWhy"]] ;
				[button setToolTip:tip] ;
			}
            x += upDownButtonWength ;

			// Add the Down button to the item view
			NSInteger lastIndex ;
			lastIndex = [[[self macster] clients] count] - 1 ;
			if ([client indexValue] < lastIndex) {
                button = [ClientListButton buttonAtPoint:NSMakePoint(x + upDownButtonInset, 0 + upDownButtonInset)
                                                  height:upDownButtonWength
                                                    type:NSButtonTypeMomentaryPushIn] ;
                button.bordered = NO;
				[button setImage:[SSYVectorImages imageStyle:SSYVectorImageStyleTriangle90
													  wength:[self buttonImageDiameter]
													   color:nil
                                                darkModeView:nil // For this template image, Cocoa will handle luminance inversion when in Dark Mode
                                               rotateDegrees:180
                                                       inset:0.0]] ;
				[button setTarget:self] ;
				[button setAction:@selector(moveClientDown:)] ;
                button.accessibilityLabel = NSLocalizedString(@"Move down", nil);
				[itemView addSubview:button] ;
				[button setTag:clientIndex] ;
				tip = [NSString stringWithFormat:
					   @"%@\n\n%@",
					   [NSString localize:@"imex_clientLater"],
					   [NSString localize:@"imex_clientOrderWhy"]] ;
				[button setToolTip:tip] ;
			}
			
			if ([[[client clientoid] extoreMedia] isEqualToString:constBkmxExtoreMediaLoose]) {
				[itemView setToolTip:[client filePathError_p:NULL]] ;
			}
			clientIndex++ ;
		}
        
        self.itemCount = clientIndex;
	}
	else {
		CGFloat height = widthPerButton ;
		CGFloat width = [self frame].size.width - ONE_FOR_PLUS_BUTTON * widthPerButton ;
		// I hate using negative coordinate values, but -5.0 is needed to
		// make the text line up with the [+] button.  Go figure.
		NSRect frame = NSMakeRect(widthPerButton, -5.0, width, height) ;
		NSTextField* textField = [[NSTextField alloc] initWithFrame:frame] ;
		[textField setBordered:NO] ;
		[textField setDrawsBackground:NO] ;
		[textField setEditable:NO] ;
		[textField setEnabled:NO] ;
		// Note: The standard system font is not available in italic.  Use Helvetica instead.
		NSFont* font = [NSFont fontWithName:@"Helvetica"
									   size:[NSFont systemFontSize]] ;
		font = [[NSFontManager sharedFontManager] convertFont:font
												  toHaveTrait:NSItalicFontMask] ;
		[textField setFont:font] ;
		[textField setTextColor:[NSColor disabledControlTextColor]] ;
		NSString* text = [NSString stringWithFormat:
						  @"%C%@",
						  (unsigned short)0x2190,  // Arrow pointing left
						  [NSString localizeFormat:
						  @"clickToAddX",
						  [[BkmxBasis sharedBasis] labelClient]]] ;
		[textField setStringValue:text] ;
		[self addSubview:textField] ;
		[textField release] ;
	}

	NSButton* plusButton = [[self subviews] objectAtIndex:0] ;
	BOOL enablePlus ;
    if ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppBookMacster) {
        // For BookMacster, we need to always allow the placeholder
        // "Click to Choose" item at the bottom, in order to allow for
        // web app New/Other, Choose File (Advanced) and Other Macintosh User Account
        // items which are not included in nextLikelyClientChoice.
        // However, we only want one of these.  So we return NO if there
        // already is one.
        enablePlus = ![self hasPlaceholderChoice] ;
    }
    else {
        // Other apps do not support
        // web app New/Other, Choose File (Advanced) and Other Macintosh User Account,
        // and will never get a "Click to Choose" item.  So we only enablePlus
        // if there is a next likely choice.
        enablePlus = ([[self macster] nextLikelyClientChoice] != nil) ;
    }
	[plusButton setEnabled:enablePlus] ;
}

- (void)note:(NSNotification*)note {
	// The notification object of constNoteBkmxClientDidChange is a Macster
	// instance, but when we registered for constNoteBkmxClientDidChange,
	// we did not specify an object.  So we need to filter out other
	// Macsters.
	if ([[note name] isEqualToString:constNoteBkmxClientDidChange]) {
		if ([note object] != [self macster]) {
			return ;
		}
	}
	// (The alternative to the above is to specify a Macster object when
	// adding the observer, but then we'd have to observe for a Save As,
	// then unregister that observer and add a new observer with the
	// new Macster.  Certainlly this way is a tiny performance hit, but
    // it is much easier.)
	
	[self update] ;
}


@end
