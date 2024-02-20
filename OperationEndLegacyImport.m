#import "OperationEndLegacyImport.h"
#import "Bkmslf.h"
#import "SSYDooDooUndoManager.h"
#import "BkmxAppDel.h"
#import "SSYMH.AppAnchors.h"


@implementation SSYOperation (OperationEndLegacyImport)

- (void)endLegacyImport {
	[self doSafely:_cmd] ;
}

- (void)endLegacyImport_unsafe {
	[[NSApp delegate] openHelpAnchor:constHelpAnchorBookdogUser] ;
}	

@end
