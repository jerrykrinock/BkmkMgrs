#import "StarkContainersFlatMenu.h"
#import "Stark.h"
#import "NSMenuItem+Font.h"

@implementation StarkContainersFlatMenu

- (void)menuNeedsUpdate:(NSMenu*)menu {
	[menu removeAllItems] ;
	
	NSArray* starks = [self representedObjects] ;
	NSImage* folderImage = [NSImage imageNamed:@"folder.tif"] ;
//	CGFloat fontSize = [[NSUserDefaults standardUserDefaults] doubleForKey:constKeyMenuFontSize] ;
	CGFloat imageHeight = [[menu font] pointSize] ;
	NSSize imageSize = NSMakeSize(imageHeight, imageHeight) ;
	[folderImage setSize:imageSize] ;
	Stark* selectedRepresentedObject = [self selectedRepresentedObject] ;
	
	NSMenuItem* selectedMenuItem = nil ;
	for (Stark* stark in starks) {
        NSMenuItem* menuItem = [[NSMenuItem alloc] initWithTitle:[stark nameNoNil]
                                                          action:[self selector]
                                                   keyEquivalent:@""] ;
		[menuItem setRepresentedObject:stark] ;
		[menuItem setTarget:[self target]] ;
		[menuItem setImage:folderImage] ;
		[menuItem setIndentationLevel:[stark lineageDepth]] ;
		[menu addItem:menuItem] ;
		[menuItem release] ;
		[menuItem setFontColor:[stark color]
						  size:0.0] ;
		if (stark == selectedRepresentedObject) {
			selectedMenuItem = menuItem ;
		}
	}
	
	NSPopUpButton* owningPopUpButton = [self owningPopUpButton] ;
	if (selectedMenuItem) {
		[owningPopUpButton selectItem:selectedMenuItem] ;
		[owningPopUpButton synchronizeTitleAndSelectedItem] ;
	}
}

@end
