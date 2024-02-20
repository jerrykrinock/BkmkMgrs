#import "ClientListNiew.h"
#import "SSYVectorImages.h"
#import "SSYBinderView.h"
#import "ClientListButton.h"
#import "NSString+LocalizeSSY.h"
#import "ClientoidPlus.h"
#import "BkmxBasis+Strings.h"

@interface ClientListNiew ()

@property (nonatomic, assign) CGFloat initialY ;
@property (nonatomic, assign) CGFloat initialHeight ;
@property (nonatomic, assign) ClientsWizWinCon* contentProvider ;
@property (nonatomic, copy) NSString* keyPath ;
@property (nonatomic, assign) NSInteger itemCount;

- (void)update ;

@end


@implementation ClientListNiew

@synthesize initialY = m_initialY ;
@synthesize initialHeight = m_initialHeight ;
@synthesize choiceProvider = m_choiceProvider ;
@synthesize contentProvider = m_contentProvider ;
@synthesize keyPath = m_keyPath ;

+ (void)initialize {
    //	[self exposeBinding:@"objects"] ;
}

- (NSString*)accessibilityLabel {
    return [NSString stringWithFormat:
            NSLocalizedString(@"List of available %@", nil),
            [[BkmxBasis sharedBasis] labelClients]];
}

- (void)dealloc {
	if (m_didBind) {
	}

	[m_keyPath release] ;
	
	[super dealloc] ;
}

- (CGFloat)buttonImageDiameter {
    // Not important because it's going to be scaled anyhow
    return [self initialHeight] ;
}

- (NSMutableArray*)objects {
	return [[self contentProvider] valueForKeyPath:[self keyPath]] ;
}

- (void)setContentProvider:(ClientsWizWinCon*)contentProvider
				   keyPath:(NSString*)keyPath {
	[self setContentProvider:contentProvider] ;
	[self setKeyPath:keyPath] ;
	
	// Perform initial load by simulating a change
	[self update] ;
	
	m_didBind = YES ;
}

- (void)moveButton:(NSButton*)sender
			 delta:(NSInteger)delta {
	// Assign new indexes
	NSInteger oldIndex = [sender tag] ;
	NSInteger newIndex = oldIndex + delta ;
	ClientoidPlus* clientoidPlus = [[self objects] objectAtIndex:oldIndex] ;
	ClientoidPlus* otherClientoidPlus = [[self objects] objectAtIndex:newIndex] ;
	[clientoidPlus setIndex:newIndex] ;
	[otherClientoidPlus setIndex:oldIndex] ;
	
	// Sort the array
	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index"
																   ascending:YES] ;
	[[self objects] sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] ;
	[sortDescriptor release] ;

	// Update the view
	[self update] ;
}

// Until BookMacster 1.5.6, the following two methods were named
// -moveUp: and -moveDown:.  But this caused these messages to be
// received by the window, and an exception, if you hit the up-arrow
// or down-arrow key while ClientListNiew was showing.  So I changed
// the names to resolve the conflict.

- (IBAction)moveClientUp:(NSButton*)sender {
	[self moveButton:sender
			   delta:-1] ;
}

- (IBAction)moveClientDown:(NSButton*)sender {
	[self moveButton:sender
			   delta:+1] ;
}

- (IBAction)updateView:(NSButton*)sender {
	[self update] ;
}

- (IBAction)setActiveImportsButton:(id)button {
	// As a convenience and cue to the user, we switch on Exporting
	// if they switch on Importing.
	NSInteger index = [button tag] ;
	BOOL yn = ([button state] == NSControlStateValueOn) ;
	ClientoidPlus* clientoidPlus = [[self objects] objectAtIndex:index] ;
	// Not needed because done by bindings: [clientoidPlus setDoImport:yessir] ;
	if (yn) {
		[clientoidPlus setDoExport:YES] ;
		[self update] ;
	}
}

/*
 // Not needed because this is handled by bindings.
 - (IBAction)setActiveExportsButton:(id)button {
	NSInteger index = [button tag] ;
	ClientoidPlus* clientoidPlus = [[self objects] objectAtIndex:index] ;
	[clientoidPlus setDoExport:([button state] == NSControlStateValueOn)] ;
}
*/

- (void)awakeFromNib {
	// Per Discussion in documentation of -[NSObject respondsToSelector:].
	// the superclass name in the following must be hard-coded.
	if ([NSControl instancesRespondToSelector:@selector(awakeFromNib)]) {
		[super awakeFromNib] ;
	}
	
	[self setInitialY:[self frame].origin.y] ;
	[self setInitialHeight:[self frame].size.height] ;
    [self setAccessibilityElement:YES];
}

- (void)setFrame:(NSRect)frame {
	CGFloat y = [self frame].origin.y ;
	[super setFrame:frame] ;
	
	CGFloat deltaY = frame.origin.y - y ;
	[self setInitialY:([self initialY] + deltaY)] ;
}

#define NUMBER_OF_SMALL_BUTTONS_IN_ITEM_VIEW 4  // Import, Export, Up, Down
#define ONE_FOR_PLUS_BUTTON 0

- (void)update {
	NSArray* subviewsCopy = [[self subviews] copy] ;
	for (SSYBinderView* subview in subviewsCopy) {
		[subview removeFromSuperviewWithoutNeedingDisplay] ;
	}
	[subviewsCopy release] ;
	
	NSArray* objects = [self objects] ;
	CGFloat unitPitch = [self initialHeight] ;
	// The -unitPitch is to leave room on the left for the [+] button...
	NSRect frame = [self frame] ;
	CGFloat itemWidth = frame.size.width - unitPitch * ONE_FOR_PLUS_BUTTON ;
	// MIN is so that, even if no objects, we still get a solitary [+] button...
	NSInteger rowCount = MAX([objects count], ONE_FOR_PLUS_BUTTON) ;
    frame.size.height = [self initialHeight] * rowCount ;
	frame.origin.y = [self initialY] - (frame.size.height - [self initialHeight]) ;
	// Invoke super to bypass our implementation of setFrame:
	[super setFrame:frame] ;
	
	CGFloat x ;
	CGFloat y = frame.size.height ;	

	NSButton* button ;
	NSString* tip ;
    
    CGFloat upDownButtonInset = [self initialHeight] / 4;
    CGFloat upDownButtonWength = [self initialHeight] - 2 * upDownButtonInset;
	
	NSInteger index = 0 ;
	for (ClientoidPlus* clientoidPlus in objects) {
        // Create the item view
		y -= unitPitch ;
		NSRect itemFrame = NSMakeRect(
									  unitPitch * ONE_FOR_PLUS_BUTTON,
									  y,
									  itemWidth,
									  unitPitch) ;
		SSYBinderView* itemView = [[SSYBinderView alloc] initWithFrame:itemFrame] ;
		[self addSubview:itemView] ;
		[itemView release] ;
		
		x = 0 ;
		
		// Add the nameField to the item view
		CGFloat nameFieldHeight = [self initialHeight] - 2 * [ClientListButton buttonMargin] ;
		CGFloat nameFieldWidthWithMargins = [self frame].size.width - (NUMBER_OF_SMALL_BUTTONS_IN_ITEM_VIEW + ONE_FOR_PLUS_BUTTON) * unitPitch ;
		CGFloat nameFieldWidth = nameFieldWidthWithMargins - 2 * [ClientListButton buttonMargin] ;
		NSRect frame = NSMakeRect(
								  x + [ClientListButton buttonMargin],
								  [ClientListButton buttonMargin],
								  nameFieldWidth,
								  nameFieldHeight
								  ) ;
		NSTextField* nameField = [[NSTextField alloc] initWithFrame:frame] ;
		[itemView addSubview:nameField] ;
		[nameField release] ;
		[nameField setBordered:NO] ;
		[nameField setDrawsBackground:NO] ;
		[nameField setEditable:NO] ;
		[nameField setStringValue:[clientoidPlus displayName]] ;
		NSColor* textColor = ([clientoidPlus doImport] || [clientoidPlus doExport])
		? [NSColor controlTextColor]
		: [NSColor disabledControlTextColor] ;
		[nameField setTextColor:textColor] ;
		x += nameFieldWidthWithMargins ;
		
		// Add the Import checkbox to the item view
        button = [ClientListButton buttonAtPoint:NSMakePoint(x, 0)
                                          height:[self initialHeight]
                                            type:NSButtonTypeSwitch] ;
        button.accessibilityLabel = NSLocalizedString(@"Import from", nil);
		[itemView bindSubview:button
				  bindingName:@"value"
					 toObject:clientoidPlus
				  withKeyPath:@"doImport"
					  options:nil] ;
		[itemView addSubview:button] ;
		// If this checkbox is checked or unchecked, we may
		// need to change the text color of its sibling nameField.
		// Rather than get fancy and set up an observer, we just
		// set a simple target and action ...
		[button setTarget:self] ;
		[button setAction:@selector(setActiveImportsButton:)] ;
		[button setTag:index] ;
		x += unitPitch ;

		// Add the Export checkbox to the item view
        button = [ClientListButton buttonAtPoint:NSMakePoint(x, 0)
                                          height:[self initialHeight]
                                            type:NSButtonTypeSwitch] ;
        button.accessibilityLabel = NSLocalizedString(@"Export to", nil);
        [itemView bindSubview:button
				  bindingName:@"value"
					 toObject:clientoidPlus
				  withKeyPath:@"doExport"
					  options:nil] ;
		[itemView addSubview:button] ;
		// If this checkbox is checked or unchecked, we may
		// need to change the text color of its sibling nameField.
		// Rather than get fancy and set up an observer, we just
		// set a simple target and action ...
		[button setTarget:self] ;
		[button setAction:@selector(updateView:)] ;
		x += unitPitch ;

		// Add the Up button to the item view
		if ([clientoidPlus index] > 0) {
            button = [ClientListButton buttonAtPoint:NSMakePoint(x + upDownButtonInset, 0 + upDownButtonInset)
                                              height:upDownButtonWength
                                                type:NSButtonTypeMomentaryPushIn] ;
            button.bordered = NO;
            button.accessibilityLabel = NSLocalizedString(@"Move up", nil);
			[button setImage:[SSYVectorImages imageStyle:SSYVectorImageStyleTriangle90
												  wength:[self buttonImageDiameter]
												   color:nil
                                            darkModeView:nil // For this template image, Cocoa will handle luminance inversion when in Dark Mode
                                           rotateDegrees:0.0
                                                   inset:0.0]] ;
			[button setTarget:self] ;
			[button setAction:@selector(moveClientUp:)] ;
			[itemView addSubview:button] ;
			[button setTag:index] ;
			tip = [NSString stringWithFormat:
				   @"%@\n\n%@",
				   [NSString localize:@"imex_clientEarlier"],
				   [NSString localize:@"imex_clientOrderWhy"]] ;
			[button setToolTip:tip] ;
		}
		x += upDownButtonWength ;

		// Add the Down button to the item view
		NSInteger lastIndex ;
		lastIndex = [objects count] - 1 ;
		if ([clientoidPlus index] < lastIndex) {
            button = [ClientListButton buttonAtPoint:NSMakePoint(x + upDownButtonInset, 0 + upDownButtonInset)
                                              height:upDownButtonWength
                                                type:NSButtonTypeMomentaryPushIn] ;
            button.bordered = NO;
            button.accessibilityLabel = NSLocalizedString(@"Move down", nil);
			[button setImage:[SSYVectorImages imageStyle:SSYVectorImageStyleTriangle90
												  wength:[self buttonImageDiameter]
												   color:nil
                                            darkModeView:nil // For this template image, Cocoa will handle luminance inversion when in Dark Mode
                                           rotateDegrees:180
                                                   inset:0.0]] ;
			[button setTarget:self] ;
			[button setAction:@selector(moveClientDown:)] ;
			[itemView addSubview:button] ;
			[button setTag:index] ;
			tip = [NSString stringWithFormat:
				   @"%@\n\n%@",
				   [NSString localize:@"imex_clientLater"],
				   [NSString localize:@"imex_clientOrderWhy"]] ;
			[button setToolTip:tip] ;
		}
		
		index++ ;
	}
    
    self.itemCount = index;
}

@end
