#import "LogsWinCon.h"
#import "BkmxBasis.h"
#import "NSArray+SafeGetters.h"
#import "ErrorLog.h"
#import "BkmxBasis+Strings.h"

// For debugging
#import "BkmxGlobals.h"

NSString* const constIdentifierTabViewErrors = @"errors" ;
NSString* const constIdentifierTabViewMessages = @"messages" ;

@interface LogsWinCon ()

@property (retain) MessageLog* priorLastMessageLog ;

@end



@implementation LogsWinCon

@synthesize messageSearchString = m_messageSearchString ;
@synthesize priorLastMessageLog = m_priorLastMessageLog ;

- (id)init {
	self = [super initWithWindowNibName:@"Logs"] ;
	if (self) {
	}
	
	return self;
}


-(void)	dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self] ;
	[[NSDistributedNotificationCenter defaultCenter] removeObserver:self] ;
	[ibo_messagesAC removeObserver:self
						forKeyPath:@"content"] ;
	
	[m_messageSearchString release] ;
	[m_priorLastMessageLog release] ;
	
	[super dealloc] ;
}

- (NSString*)labelForTabIndex:(NSInteger)index {
	SEL selector ;
	switch (index) {
		case 0:
			selector = @selector(labelMessages) ;
			break ;
		case 1:
        default:
			selector = @selector(labelErrors) ;
			break ;
	}
	
	return [[BkmxBasis sharedBasis] performSelector:selector] ;
}

- (void)showHideButtons {
	if ([[[ibo_logsTabView selectedTabViewItem] identifier] isEqualToString:constIdentifierTabViewErrors]) {
		[ibo_supportButton setHidden:NO] ;
		[ibo_refreshButton setHidden:YES] ;
	}
	else {
		[ibo_supportButton setHidden:YES] ;
		[ibo_refreshButton setHidden:NO] ;
	}	
}

- (void)awakeFromNib {
	// Per Discussion in documentation of -[NSObject respondsToSelector:],
	// the superclass name in the following must be hard-coded.
	if ([NSView instancesRespondToSelector:@selector(awakeFromNib)]) {
		[super awakeFromNib] ;
	}
	
	for (NSInteger i=0; i<[ibo_tabSelector segmentCount]; i++) {
		[ibo_tabSelector setLabel:[self labelForTabIndex:i]
                       forSegment:i] ;
	}
	
	// Set sort descriptors in array controllers to order by date.
	NSSortDescriptor* sortDescriptor ;
	NSArray* sortDescriptors ;
	sortDescriptor = [[NSSortDescriptor alloc] initWithKey:constKeyTimestamp
												 ascending:YES
												  selector:@selector(compare:)] ;
	sortDescriptors = [NSArray arrayWithObject:sortDescriptor] ;
	[sortDescriptor release] ;
	[ibo_messagesAC setSortDescriptors:sortDescriptors] ;
	sortDescriptor = [[NSSortDescriptor alloc] initWithKey:constKeyTimestamp
												 ascending:NO
												  selector:@selector(compare:)] ;
	sortDescriptors = [NSArray arrayWithObject:sortDescriptor] ;
	[sortDescriptor release] ;
	[ibo_errorsAC setSortDescriptors:sortDescriptors] ;
	// Note that in the xib we have set these array controllers to Auto Rearrange Content.
	
	[self showHideButtons] ;

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(buttonWillPopNote:)
												 name:NSPopUpButtonWillPopUpNotification
											   object:ibo_errorsPopUp] ;
	
	[[NSDistributedNotificationCenter defaultCenter] addObserver:self
														selector:@selector(refreshMessageLogNote:)
															name:[[BkmxBasis sharedBasis] messageLoggedNotificationName]
														  object:constNameBkmxDistributedNote] ;
	
	[ibo_messagesAC addObserver:self
					 forKeyPath:@"content"
						options:0
						context:NULL] ;
	// I don't remove this observer because the observed object, ibo_messagesAC,
	// should be gone before the observer (self, windowController) is gone.
	// So, Cocoa should clean it up automatically.
}

/*!
 @details  This is to keep the Messages table scrolled to the bottom whenever a
 new message is added to the array controller.
*/
- (void)observeValueForKeyPath:(NSString*)keyPath
					  ofObject:(id)object
						change:(NSDictionary*)change
					   context:(void*)context {
	// The following is always a useless NSNull, thanks to bug in NSArrayController
	// NSArray* oldContent = [change objectForKey:NSKeyValueChangeOldKey] ;

	BOOL shouldScrollToBottom = NO ;

	if (![self priorLastMessageLog]) {
		// The Messages table is being displayed for the first time.
		shouldScrollToBottom = YES ;
	}
	else {
		// See if the Messages table had been scrolled to the bottom before
		// this latest change to the data model was made (last line was added).
		NSRect documentVisibleRect = [[ibo_messagesTableView enclosingScrollView] documentVisibleRect] ;
		NSRect rectOfPriorLastMessageLog = [ibo_messagesTableView rectOfRow:[[ibo_messagesAC arrangedObjects] indexOfObject:[self priorLastMessageLog]]] ;
		CGFloat bottomOfPriorLastMessage = NSMaxY(rectOfPriorLastMessageLog) ;
		CGFloat bottomOfVisibleRect = NSMaxY(documentVisibleRect) ;
		// We allow a tolerance of 3.0 points on scrolling.  In testing, the
		// 3.0 tolerance proved to be not necessary; 0.0 works as well.  
		// But I think some tolerance is appropriate here.
        if (fabs(bottomOfPriorLastMessage - bottomOfVisibleRect) < 3.0) {
			// Yes, the Messages table had been scrolled to the bottom before
			// this last line was added.
			shouldScrollToBottom = YES ;
		}
        // NSLog(@"Visible Y = (%%05ld rows  abs(%0.1f - %0.1f = %0.1f  --> %hhd", [[ibo_messagesAC arrangedObjects] count], bottomOfPriorLastMessage, bottomOfVisibleRect, fabs(bottomOfPriorLastMessage - bottomOfVisibleRect), shouldScrollToBottom) ;
	}
	[self setPriorLastMessageLog:[[ibo_messagesAC arrangedObjects] lastObject]] ;
	
	if (shouldScrollToBottom) {
        NSInteger lastRow = [[ibo_messagesAC arrangedObjects] count] - 1;
        // NSLog(@"Scrolling to last row (%ld)", lastRow) ;
		[ibo_messagesTableView scrollRowToVisible:lastRow] ;
	}
}

- (void)refreshMessageLogNote:(NSNotification*)notUsed {
	[ibo_messagesAC fetch:self] ;
}

- (IBAction)refresh:(id)sender {
    [ibo_messagesAC fetch:self] ;
    // Convoluted way of telling NSTableView to scroll to the bottom…
    [ibo_messagesTableView scrollRowToVisible:[[ibo_messagesAC content] count] - 1] ;
}

- (void)revealTabViewIdentifier:(NSString*)identifier {
	[ibo_logsTabView selectTabViewItemWithIdentifier:identifier] ;
}

- (void)delayedMarkSelectedErrorAsPresented {
	ErrorLog* errorLog = [[ibo_errorsAC selectedObjects] firstObjectSafely] ;
	[errorLog markAsPresented] ;
	[[BkmxBasis sharedBasis] saveLogsMoc] ;
}	

- (void)markSelectedErrorAsPresented {
	[self performSelector:@selector(delayedMarkSelectedErrorAsPresented)
			   withObject:nil
			   afterDelay:2.0] ;
}

- (void)buttonWillPopNote:(NSNotification*)note {
	[self markSelectedErrorAsPresented] ;
	[ibo_errorsAC fetch:self] ;
}

- (void)      tabView:(NSTabView*)tabView
  didSelectTabViewItem:(NSTabViewItem*)tabViewItem {
	if ([[tabViewItem identifier] isEqualToString:constIdentifierTabViewErrors]) {
		if ([[self window] isVisible]) {
			[self markSelectedErrorAsPresented] ;
		}
	}
	
	[self showHideButtons] ;
}

- (IBAction)support:(id)sender {
	[SSYAlert supportError:[(ErrorLog*)[[ibo_errorsAC selectedObjects] firstObjectSafely] error]] ;
}

- (void)displayErrors {
	[self showWindow:self] ;
	[self revealTabViewIdentifier:constIdentifierTabViewErrors] ;
	// To make sure that any recent error just inserted by BkmxAgent gets displayed…
	[ibo_errorsAC fetch:self] ;
	[ibo_errorsAC rearrangeObjects] ;
	if ([ibo_errorsPopUp numberOfItems] > 0) {
		[ibo_errorsPopUp selectItemAtIndex:0] ;
	}
}

- (IBAction)cleanDefunctLogEntries:(id)sender {
	[[BkmxBasis sharedBasis] cleanDefunctLogEntries] ;
}

- (NSPredicate*)messageFilterPredicate {
	NSPredicate* predicate = nil ;
	if ([[self messageSearchString] length] > 0) {
		predicate = [NSPredicate predicateWithFormat:@"(processId = %ld) OR (message like[cd] %@)",
					 (long)[[self messageSearchString] integerValue],
					 [NSString stringWithFormat:
					  @"*%@*",
					  [self messageSearchString]]] ;
	}

	return predicate ;
}
+ (NSSet*)keyPathsForValuesAffectingMessageFilterPredicate {
	return [NSSet setWithObjects:
			@"messageSearchString",
			nil] ;
}

- (IBAction)copy:(id)sender {
	NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
	NSArray* providedDragTypes = [NSArray arrayWithObjects:NSPasteboardTypeString, nil] ;
	[pasteboard declareTypes:providedDragTypes
					   owner:nil] ;
	// Above, we can say owner:nil since we are going to provide data immediately
	
	// For pasting to other apps, copy tab/return name/urls of starks
	NSArray* selectedEntries = [[ibo_messagesAC selectedObjects] valueForKey:@"stringRepresentation"] ;
	NSString* string = [selectedEntries componentsJoinedByString:@"\n"] ;
	
	if ([string length] > 0) {
		[pasteboard setString:string
					  forType:NSPasteboardTypeString];
	}
}




@end
