#import "NSMenuItem+Bkmx.h"
#import "NSString+LocalizeSSY.h"
#import "NSMenuItem+Font.h"
#import "NSString+Truncate.h"
#import "Stark.h"
#import "BkmxAppDel.h"

@implementation NSMenuItem (Bkmx)

- (void)scaleAndSetImage:(NSImage*)image {
	if (image) {
        CGFloat fontSize = [[[self menu] font] pointSize] ;
		CGFloat imageHeight = fontSize ;
        /*
         Be careful with the above.  For one thing, setting the imageHeight
         larger than the fontSize increases the vertical spacing between the
         menu items.  More importantly, I've seen that, for large font sizes in
         hierarchical menus, the menu depth will be limited!  That is, once you
         get to a depth of, say, 3 or 4, although right-pointing black triangles
         appear at the right edge of items with submenus, the submenus do not
         appear when you select such an item.  The depth gets limited to even
         depths as you increase the multiplier from, say, 1.5 to 2.0 to 4.0.
        */
		NSSize imageSize = NSMakeSize(imageHeight, imageHeight) ;
		[image setSize:imageSize] ;
		[self setImage:image] ;	
	}
}

- (void)addHereifyWithInfo:(NSDictionary*)info {
	[self setRepresentedObject:info] ;
	
	[self setTarget:(BkmxAppDel*)[NSApp delegate]] ;
	[self setAction:@selector(landNewBookmarkFromMenuItem:)] ;
	[self setTitle:[NSString localizeFormat:
					@"addHereX",
					[[info objectForKey:constKeyName] stringByTruncatingMiddleToLength:MENU_ITEM_MAX_DISPLAY_CHARS_LONG
																			wholeWords:YES]]] ;
	NSImage* addBookmarkImage = [NSImage imageNamed:@"prefsAdding.png"] ;
	[self scaleAndSetImage:addBookmarkImage] ;
}

- (void)visitAllifyOfParent:(Stark*)parent {
	[self setRepresentedObject:parent] ;
	
	[self setTarget:(BkmxAppDel*)[NSApp delegate]] ;
	[self setAction:@selector(visitAllOfRepresentative:)] ;
	[self setTitle:[NSString stringWithFormat:
					@"Visit all %ld bookmarks",
					(long)[parent numberOfBookmarks]]] ;
}

- (void)newSubfolderifyWithInfo:(NSDictionary*)info {
	[self setRepresentedObject:info] ;
	
	[self setTarget:(BkmxAppDel*)[NSApp delegate]] ;
	[self setAction:@selector(landNewBookmarkFromMenuItem:)] ;
	[self setTitle:[NSString stringWithFormat:
					@"     %@ into a new subfolder %@",
					constEllipsis,
					constEllipsis]] ;
}

@end
