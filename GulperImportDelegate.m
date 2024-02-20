#import "GulperImportDelegate.h"
#import "BkmxDoc.h"
#import "NSArray+SafeGetters.h"
#import "Extore.h"
#import "Client.h"
#import "Importer.h"
#import "BkmxGlobals.h"
#import "Macster.h"

@implementation GulperImportDelegate

- (BkmxDoc*)bkmxDoc {
	return m_bkmxDoc ;
}

- (void)setBkmxDoc:(BkmxDoc*)bkmxDoc {
	m_bkmxDoc = bkmxDoc ;
}

- (id)initWithBkmxDoc:(BkmxDoc*)bkmxDoc {
	self = [super init] ;
	if (self) {
		m_bkmxDoc = bkmxDoc ;
	}
	
	return self ;
}

- (BOOL)isAnImporter  {
	return YES ;
}


- (BOOL)isAnExporter  {
	return NO ;
}

- (NSString*)displayName {
	return @"Import Gulper" ;
}

- (NSNumber*)fabricateFolders  {
	for (Extore* extore in [[self bkmxDoc] importedExtores]) {
		Importer* importer = [[extore client] importer] ;
		NSNumber* fabricateFolders = [importer fabricateFolders] ;
		if ([fabricateFolders shortValue] > BkmxFabricateFoldersOff) {
			// Bug 201112171.  This is screwed up.  What if a later importer has a different value?
			return fabricateFolders ;
		}
	}
	
	return [NSNumber numberWithShort:BkmxFabricateFoldersOff] ;
}

- (BkmxMergeBias)mergeBiasValue  {
	NSArray* importedExtores = [[self bkmxDoc] importedExtores] ;
	Extore* firstExtore = [importedExtores firstObjectSafely] ;
	Client* firstClient = [firstExtore client] ;
	Importer* importer = [firstClient importer] ;
	// Bug 201112172.  This is screwed up.  What about the other imported extores?

	BkmxMergeBias mergeBiasValue ;
	if (importer) {
		mergeBiasValue = [[importer mergeBias] shortValue] ;
	}
	else {
		mergeBiasValue = BkmxMergeBiasKeepSource ;
	}
	
	return mergeBiasValue ;
}

/*
 @details  A similar method, applicable for imports *and* exports,
 is implemented in Ixporter.
*/
- (BOOL)shouldDeleteUnmatchedItemsWithInfo:(NSDictionary*)info {
	
	if ([[info objectForKey:constKeyOverlayClient] boolValue]) {
		return NO ;
	}	

#if ONLY_PRIMARY_SOURCE_CAN_IMPORT_DELETIONS
	if (![self isPrimarySource]  && ![bkmxDoc didImportPrimarySource]) {
		return NO ;
	}
#endif
	
	return [[[[self bkmxDoc] macster] deleteUnmatchedMxtr] boolValue] ;
}

// Should only be used -isAnExporter, which should be never
- (void)objectWillChangeNote:(NSNotification*)note  {
	NSLog(@"Internal Error 298-5874 %@", note) ;
}





@end
