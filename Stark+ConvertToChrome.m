#import "Stark+ConvertToChrome.h"
#import "ExtoreChrome.h"
#import "Client.h"
#import "NSDate+Microsoft1601Epoch.h"

@implementation Stark (ConvertToChrome)

- (id)extoreItemStyle1ForChromeExtore:(Extore*)extore {
	NSMutableDictionary* nodeOut = nil ;
	Sharype sharype = [self sharypeValue] ;
	id value ;
	
	// Note: Below, we rely on our documentation that -name, and -url shall not return nil
    if (
		(sharype == SharypeBookmark)
		||
		(sharype == SharypeLiveRSS)
		) {
        // It's a bookmark (leaf)

		nodeOut = [NSMutableDictionary dictionaryWithObjectsAndKeys:
				   [self nameNoNil], @"name",                                // Cannot be nil [1]
				   @"url", @"type",                                          // Cannot be nil 
				   [self exidForClientoid:extore.client.clientoid], @"id",   // Cannot be nil
				   [self url], @"url",                                       // Cannot be nil
				   nil ] ;
		// 1.  Using -nameNoNil guards against a nil name which might occur if
		//     corrupt data was imported from an Import Client, or other program bugs.
	}
	else if ([StarkTyper canHaveChildrenSharype:sharype]) {
        // It's a folder

		// Prepare name
		NSString* name ;
		NSDictionary* fileProperties = [extore fileProperties] ;
		if (([self sharypeValue] == SharypeBar)) {
			name = [fileProperties objectForKey:constKeyExtoreLabelOfBar]  ;
		}
		else if ([self sharypeValue] == SharypeMenu) {
			name = [fileProperties objectForKey:constKeyExtoreLabelOfMenu]  ;
		}
		else {
			//  Using -nameNoNil guards against a nil name which might occur if
			//     corrupt data was imported from an Import Client, or other program bugs.
			name = [self nameNoNil] ;
		}

		// Prepare lastModified date string
		NSString* lmDateString = nil ;
		// The next line was changed in BookMacster 1.11, see Note 190351
		NSDate* lmDate = [self ownerValueForKey:constKeyLastModifiedDate] ;
		if (lmDate) {
			uint64 lmMicrosecondsSince1601 = [(NSDate*)lmDate microsecondsSince1601] ;
			lmDateString = [NSString stringWithFormat:@"%qd", lmMicrosecondsSince1601] ;
		}

		nodeOut = [NSMutableDictionary dictionaryWithObjectsAndKeys:
				   name, @"name",                                               // Cannot be nil
				   @"folder", @"type",                                          // Cannot be nil
				   [self exidForClientoid:[[extore client] clientoid]], @"id",  // Should not be nil
	 			   lmDateString, @"date_modified",                              // May be nil
				   nil ] ;
		// We give nodeOut an *empty* container for its children
		// We do not copy the children since we need a deep copy, copies of the children.
		// We do this even if the container has no children, because we found (hard way) that
		// Chrome does ont accept a Group with no "Children" array, even an empty one.  See
		// Version History for 3.2.1 for more details on Chrome behavior.  For the sake of
		// simplicity, we do this for all folders, not just those at the "Groups" (top) level.
		// I checked Safari and it does not need empty arrays for empty Collections, nor
		// does it write them itself.
		[nodeOut setObject:[NSMutableArray array] forKey:@"children"] ;
	}
	else
	{
		// SharypeSeparator, not exported to Chrome
		nodeOut = nil ; 
	}
	
    // For some reason, upon rewriting, Chrome removes date_modified added to bookmarks, but accepts
	// them on folders.  date_added is accepted on either bookmarks or folders.
	// The next line was changed in BookMacster 1.11, see Note 190351
    if ((value = [self ownerValueForKey:constKeyAddDate])) {
		// value is a date
		uint64 microsecondsSince1601 = [(NSDate*)value microsecondsSince1601] ;
		NSString* dateString = [NSString stringWithFormat:@"%qd", microsecondsSince1601] ;
		[nodeOut setObject:dateString
					forKey:@"date_added"] ;
	}
    
    if ((value = [self ownerValueForKey:constKeyGuid])) {
        [nodeOut setObject:value
                    forKey:constKeyGuid] ;
    }
    
    NSMutableDictionary* metaInfo = nil ;
    if ([[extore class] canEditCommentsInStyle:1]) {
        value = [self comments] ;
        if (value) {
            if (!metaInfo) {
                metaInfo = [[NSMutableDictionary alloc] init] ;
            }
            [metaInfo setValue:value
                        forKey:@"Description"] ;
        }
    }
    if ([[extore class] canEditShortcutInStyle:1]) {
        value = [self shortcut] ;
        if (value) {
            if (!metaInfo) {
                metaInfo = [[NSMutableDictionary alloc] init] ;
            }
            [metaInfo setValue:value
                        forKey:@"Nickname"] ;
        }
    }

    NSDictionary* ownerMetaInfo = [self ownerValueForKey:constKeyMetaInfo] ;
    if (ownerMetaInfo) {
        for (NSString* key in [ownerMetaInfo allKeys]) {
            value = [ownerMetaInfo objectForKey:key] ;
            if (!metaInfo) {
                metaInfo = [[NSMutableDictionary alloc] init] ;
            }
            [metaInfo setObject:value
                         forKey:key] ;
        }
    }
    
    if (metaInfo) {
        NSDictionary* metaInfoCopy = [metaInfo copy] ;
        [metaInfo release] ;
        [nodeOut setObject:metaInfoCopy
                    forKey:constKeyMetaInfo] ;
        [metaInfoCopy release] ;
    }
    
    value = [self ownerValueForKey:constKeySyncTransactionVersion] ;
    if (value) {
        [nodeOut setObject:value
                    forKey:constKeySyncTransactionVersion] ;
    }
    
    
    return nodeOut ;
}

@end
