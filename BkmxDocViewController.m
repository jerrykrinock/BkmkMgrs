#import <Bkmxwork/Bkmxwork-Swift.h>
#import "BkmxDocViewController.h"
#import "StarkTableColumn.h"
#import "Stark+Attributability.h"
#import "BkmxDocWinCon+Autosaving.h"
#import "BkmxOutlineView.h"
#import "BkmxDocTabViewControls.h"
#import "NSObject+SuperUtils.h"
#import "GCUndoManager.h"
#import "SafeLimitGuider.h"

@interface BkmxDocViewController ()

@end

@implementation BkmxDocViewController

@synthesize windowController = m_windowController ;
@synthesize awakened = m_awakened ;

- (void)defensiveProgramming {
    if (self) {
        if ([self isMemberOfClass: [BkmxDocViewController class]]) {
            NSLog(@"Internal Error 194-3867 %@ is an abstract class", [self className]) ;
        }
        if (![self conformsToProtocol:@protocol(BkmxDocTabViewControls)]) {
            NSLog(@"Internal Error 194-2390 %@ no conform", [self className]) ;
        }
    }
}

- (id)initWithCoder:(NSCoder*)aDecoder {
    self = [super initWithCoder:aDecoder] ;
    [self defensiveProgramming] ;
    return self ;
}

- (void)endEditing:(NSNotification*)note {
	[[self windowController] endEditing] ;
}

#pragma mark * Delegate Methods


#pragma mark NSTableView delegate messages

/*
 This method does not get invoked for the Content Outline View, because it is
 effectively overridden by the implementation of -[ContentOutlineView
 outlineView:toolTipForCell:rect:tableColumn:item:mouseLocation:].
 */
- (NSString*)tableView:(NSTableView*)tableView
		toolTipForCell:(NSCell*)cell
				  rect:(NSRectPointer)rect
		   tableColumn:(NSTableColumn*)tableColumn
				   row:(NSInteger)row
		 mouseLocation:(NSPoint)mouseLocation {
	NSString* toolTip = nil ;
	
	NSDictionary* contentInfo = [tableView infoForBinding:@"content"] ;
	NSArrayController* arrayController = [contentInfo valueForKey:NSObservedObjectKey] ;
	Stark* stark = [[arrayController arrangedObjects] objectAtIndex:row] ;
	if ([stark isAvailable]) {  // <-- This test added in BookMacster 1.16
        // If user is hovering over a dupe in the Dupes table, stark could actually be
        // a Dupe instance.
        // So we check if it acts like a Stark instance before sending the message.
        if ([stark respondsToSelector:@selector(toolTipForTableColumn:)]) {
            toolTip = [stark toolTipForTableColumn:tableColumn] ;
        }
    }
	return toolTip ;
}

- (BOOL)           tabView:(NSTabView*)tabView
   shouldSelectTabViewItem:(NSTabViewItem*)tabViewItem {
    return [[self windowController] tabView:tabView
                    shouldSelectTabViewItem:tabViewItem] ;
}

- (void)       tabView:(NSTabView*)tabView
 willSelectTabViewItem:(NSTabViewItem*)tabViewItem {
    [[self windowController] tabView:tabView
               willSelectTabViewItem:tabViewItem] ;
}

- (void)       tabView:(NSTabView*)tabView
  didSelectTabViewItem:(NSTabViewItem*)tabViewItem {
    [[self windowController] tabView:tabView
                didSelectTabViewItem:tabViewItem] ;
}

- (void)tearDown {
    [self setWindowController:nil] ;
}

- (BkmxDoc*)document {
    return [[self windowController] document] ;
}

@end
