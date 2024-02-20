#import "NSMenu+Initialize.h"
#import "BkmxBasis.h"
#import "NSString+LocalizeSSY.h"
#import "SSYLicensingParms.h"
#import "BkmxAppDel.h"
#import "NSDocumentController+DisambiguateForUTI.h"
#import "NSString+SSYExtraUtils.h"


@implementation NSMenu (Initialize)

- (void)doInitialization {
	NSInteger i;
	NSArray* submenus = [self itemArray] ;
	for (i=0; i<[submenus count]; i++)
	{
		NSMenuItem* mi = [submenus objectAtIndex:i] ;	
		NSString* title = [mi title] ;
		NSString* localizedTitle = nil ;
		
		if ([title hasSuffix:@"APP_NAME"]) {
			NSString* prefix = [title substringToIndex:[title length] - 8] ;
			NSString* key = [prefix stringByAppendingString:@"App%@"] ;
			localizedTitle = [NSString localizeFormat:key, [[BkmxBasis sharedBasis] appNameLocalized]] ;
		}
		else if ([title hasSuffix:@"BOUND"]) {
			localizedTitle = nil ;
		}
		else {
			localizedTitle = [NSString localizeWeakly:title] ;
		}
		
		// Overwrite title with localized title
		// For some strange reason, the application menu item returns an empty string instead of
		// "NewApplication" or whatever is entered into Interface Builder when sent the -title
		// message.  That would localize weakly to "" and setTitle: would set an empty string.
		// In Mac OS 10.3-10.5, -setTitle:"" was apparently a no-op, but in Mac OS 10.6 it
		// actually sets an empty string.  So, to fix the fact that in Mac OS 10.6 the title
		// of the application menu was set to an empty string, I now set the title only if
		// localizedTitle is nonzero length (fixed in Bookdog 5.3.5).
		if ([localizedTitle length] > 0) {
			[mi setTitle:localizedTitle] ;  // for 10.3, 10.4
			[[mi submenu] setTitle:localizedTitle] ; // for 10.5 per Apple bug 4861091
		}
		
		[[mi submenu] doInitialization] ; // recursion
	}
}

@end