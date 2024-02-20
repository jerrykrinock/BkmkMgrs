#import "Dupester.h"
#import "BkmxGlobals.h"

@implementation Dupester

- (id)initWithManagedObjectContext:(NSManagedObjectContext*)managedObjectContext_ {
	if (managedObjectContext_) {
		self = [super initWithManagedObjectContext:managedObjectContext_
										entityName:constEntityNameDupe] ;
		if (self != nil) {
		}
	}
	else {
		// See http://lists.apple.com/archives/Objc-language/2008/Sep/msg00133.html ...
		[super dealloc] ;
		self = nil ;
	}
	
	return self ;
}

@end
