#import "Stark+ConvertToICab.h"
#import "Stark+ConvertToICab.h"
#import "ExtoreICab.h"
#import "Client.h"
#import "NSNumber+SomeMore.h"

@implementation Stark (ConvertToICab)


- (NSMutableDictionary*)extoreItemForICab:(ExtoreICab*)extore {
	NSMutableDictionary* nodeOut = nil ;
	Sharype sharype = [self sharypeValue] ;
	NSString* typeString ;
	NSString* folderTypeString = nil ;
	
	// Start with keys common to all types
	switch (sharype) {
		case SharypeBookmark:
		case SharypeLiveRSS:
			typeString = constKeyIcabTypeBookmark ;
			break;
		case SharypeBar:
			folderTypeString = constKeyIcabTypeBar ;
			// No break
		case SharypeSoftFolder:
			typeString = constKeyIcabTypeFolder ;
			break;
		case SharypeSmart:
			typeString = constKeyIcabTypeSmartFolder ;
			break;
		case SharypeRoot:
			typeString = constKeyIcabTypeFolder ;
			// This will be ignored and overwritten from fileProperties anyhow,
			// but, oh, well.
			break;
        case SharypeSeparator:
            typeString = constKeyIcabTypeSeparator;
            break;
		default:
			// The following types should not be seen here:
			// SharypeMenu
			// SharypeUnfiled
			// SharypeOhared
			// SharypeRSSArticle
			// SharypeSeparator
			NSLog(@"Internal Error 513-1904 iCab no take %@", [StarkTyper readableSharype:sharype]) ;
			typeString = constKeyIcabTypeBookmark ;
			break ;
	}
	
	nodeOut = [NSMutableDictionary dictionaryWithObjectsAndKeys:
			   [self nameNoNil], constKeyIcabName,
			   typeString, constKeyIcabType,
			   [self comments], constKeyIcabComments,   // may be nil
			   nil ] ;
	
	if ([extore supportsUniqueExids]) {
		// File being exported to was created by iCab 5.0 or later
		[nodeOut setValue:[self exidForClientoid:[[extore client] clientoid]]
				   forKey:constKeyIcabUuid] ;		
	}
	
	if ([self sharypeCoarseValue] == SharypeCoarseLeaf) {
		// Leaf-only attributes
		[nodeOut setValue:[self url]
				   forKey:constKeyIcabUrl] ;		
		[nodeOut setValue:[self addDate]
				   forKey:constKeyIcabAddDate] ;
		[nodeOut setValue:[[[self tags] valueForKey:@"string"] componentsJoinedByString:@" "]
				   forKey:constKeyIcabTags] ;		
		[nodeOut setValue:[self ownerValueForKey:constKeyIcabTopTen]
				   forKey:constKeyIcabTopTen] ;		
		[nodeOut setValue:[self ownerValueForKey:constKeyIcabCheckFlags]
				   forKey:constKeyIcabCheckFlags] ;		
	}
	else {
		// Node-only attributes
		[nodeOut setValue:[[self isExpanded] negateBoolValue]
				   forKey:constKeyIcabClosed] ;
		[nodeOut setValue:folderTypeString
				   forKey:constKeyIcabFolderType] ;
		[nodeOut setValue:[self ownerValueForKey:constKeyIcabRules]
				   forKey:constKeyIcabRules] ;		
		[nodeOut setValue:[self ownerValueForKey:constKeyIcabFBOpen]
				   forKey:constKeyIcabFBOpen] ;		
	}
	
	return nodeOut ;
}

@end

