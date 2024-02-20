#import "Stark+ConvertToSafari.h"
#import "ExtoreSafari.h"
#import "Client.h"
#import "BkmxAppDel+Capabilities.h"
#import "BkmxBasis.h"
#import "NSObject+MoreDescriptions.h"
#import "NSObject+DoNil.h"

@implementation Stark (ConvertToSafari)

- (id)extoreItemForSafari:(ExtoreSafari*)extore {
    if ([self isDeletedThisIxport]) {
		return nil ;
	}
	
	NSMutableDictionary* nodeOut = nil ;
    Sharype sharype = [self sharypeValue] ;
	id value ;
    
   if ([StarkTyper canHaveUrlSharype:sharype]) {
	   // Safari uses "Title" for folder names, which are in the outer dic
	   // But it uses "title" for bookmark names which in the inner dic
	   NSMutableDictionary* stupidURIDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
											 [self nameNoNil], @"title",  
											 nil ] ;
    	nodeOut = [NSMutableDictionary dictionaryWithObjectsAndKeys:
				   stupidURIDic, constKeySafariUriDictionary,
				   @"WebBookmarkTypeLeaf", @"WebBookmarkType",
				   [self url], @"URLString",  // may be nil sentinel
				   nil] ;
		// Optional keys.  Check to see if the BookMacster key exists before setting
	   if ((value = [self exidForClientoid:[[extore client] clientoid]])) {
			// Camino default bookmarks don't all have UUID.
			// Don't know about Safari, but let's just do it the same way, not creating if none.
    		[nodeOut setObject:value
						forKey:@"WebBookmarkUUID"] ;
	   }

       value = [self ownerValueForKey:constKeySafariReadingListNonSyncDic] ;
       if (value) {
           [nodeOut setObject:value
                       forKey:constKeySafariReadingListNonSyncDic] ;
       }

       NSDictionary* readingListDic = [self ownerValueForKey:constKeySafariReadingListDic] ;
       // Do not do this.  See Note 20171101SC.
       //       if (readingListDic && self.comments) {
       //           NSMutableDictionary* readingListDicMutant = [readingListDic mutableCopy];
       //           [readingListDicMutant setObject:self.comments
       //                                    forKey:constKeySafariCommentsKey];
       //           readingListDic = [readingListDicMutant copy];
       //           [readingListDic autorelease];
       //           [readingListDicMutant release];
       //       }
       if (readingListDic) {
           [nodeOut setObject:readingListDic
                       forKey:constKeySafariReadingListDic] ;
       }

       value = [self ownerValueForKey:constKeySafariImageUrlKey];
       if (value) {
           [nodeOut setObject:value
                       forKey:constKeySafariImageUrlKey];
       }
	}
    else if ([StarkTyper canHaveChildrenSharype:sharype]) {
    	NSString* name ;
		if ([self sharypeValue] == SharypeBar) {
    		name = constKeySafariBookmarksBarIdentifier ;
    	}
		else if ([self sharypeValue] == SharypeMenu) {
    		name = constKeySafariBookmarksMenuIdentifier;
    	}
        else if ([self sharypeValue] == SharypeMenu) {
            name = constKeySafariReadingListIdentifier;
        }
		else {
    		// A little defensive programming here.  Little bugs or maybe a corrupt
			// Import Client could bring forth a folder with nil name.  Since
			// +dictionaryWithObjectsAndKeys won't like that, use nameNoNil to be safe.
			name = [self nameNoNil] ;
    	}
		// Safari uses "Title" for folder names, which are in the outer dic
		// But it uses "title" for bookmark names which in the inner dic
		nodeOut = [NSMutableDictionary dictionaryWithObjectsAndKeys:
				   @"WebBookmarkTypeList", @"WebBookmarkType",
				   name, @"Title",
				   nil ] ;
    	// If self has children, we give nodeOut an *empty* container for its children
    	// We do not copy the children since we need a deep copy, copies of the children.
		// The "count > 0" condition was added in BookMacster 1.8 after I saw that I
		// was writing empty child arrays but Safari 5.1.1 was not.
    	if ([[self childrenOrdered] count] > 0) {
    		[nodeOut setObject:[NSMutableArray array]
						forKey:@"Children"] ;			
		}
    	if ([[self isAutoTab] boolValue] != 0) {
    		[nodeOut setObject:[NSNumber numberWithBool:YES]
						forKey:@"WebBookmarkAutoTab"] ;
		}
		// Optional key.  Check to see if the key exists before setting
		if ((value = [self exidForClientoid:[[extore client] clientoid]])) {
			// Indeed, Camino items do not necessarily have a UUID.
			// Don't know about Safari, but let's just do it the same way.
    		[nodeOut setObject:value
						forKey:@"WebBookmarkUUID"] ;
		}
    }
    else if (sharype == SharypeSeparator) {
		// We fake this as bookmark:
		NSString* separator = ([[self parent] sharypeValue] == SharypeBar)
        ? constSeparatorLineForSafariVertical
        : constSeparatorLineForSafariHorizontal ;
		
		NSDictionary* stupidURIDic = [NSDictionary dictionaryWithObjectsAndKeys:
    		separator, @"title",  // Safari uses "Title" in the outer dic, but "title" in the inner dic
    		@"", @"",
    		nil ] ;
    	nodeOut = [NSMutableDictionary dictionaryWithObjectsAndKeys:
				   stupidURIDic, constKeySafariUriDictionary,
				   @"", @"URLString",
				   @"WebBookmarkTypeLeaf", @"WebBookmarkType",
				   [self exidForClientoid:extore.client.clientoid], @"WebBookmarkUUID",
				   nil ] ;
	}
    else {
    	NSLog(@"Internal Error 920-0182 %@", [self shortDescription]) ;
		nodeOut = nil ;  // should never happen
	}
	
	// So far, I have only seen "WebBookmarkIdentifier" keys in the proxy collections
	// but the name implies they may become more general, so I always check for them.
	NSString* webBookmarkIdentifier = [self ownerValueForKey:constKeySafariWebBookmarkIdentifier] ;
	if (webBookmarkIdentifier) {
		[nodeOut setObject:webBookmarkIdentifier
					forKey:constKeySafariWebBookmarkIdentifier] ;		
	}
	
	NSDictionary* syncDic = [self ownerValueForKey:constKeySafariSyncInfo] ;
	// syncDic will be nil for new bookmarks, and starting in BookMacster 1.11,
	// will be nil for *moved* bookmarks, due to a bug which was fixed, in
    // -[ExtoreSafari processExportChangesForOperation:error_p:].
    // WELL MAYBE NOT.
    // It was re-fixed in BookMacster 1.13.6
	if (syncDic) {
		[nodeOut setObject:syncDic
					forKey:constKeySafariSync_Item] ;		
	}
	
	return nodeOut ;
}

@end
