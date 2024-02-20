#import "Extore.h"

@class SSYSqliter ;

extern NSString* const constExtensionFilenameExtension;

@interface ExtoreFirefox : Extore <NSXMLParserDelegate> {

	SSYSqliter* _sqliter ;

	NSNumber* m_rootTagsMozBookmarksIndex ;
	
	NSInteger m_trialsToCreateAllPlaces ;
	
	NSDictionary* _rootAttributes ;
	
	// Used while parsing the extensions's install.rdf file to find the version,
	BOOL m_accumulatingParsedCharacterData ;
    
	// Added for performance optimization on BookMacster 1.11 so that
	// -mozParentOfMozBookmarksID: does not need to fetch repeatedly.
	NSDictionary* m_parentsCached ;

	/* Added this cache in BkmkMgrs 2.7.1.  It made a huge improvement in
     exporting to Firefox changes numbering +25169 Δ3 ↖0 ↕0 -551.

     Before 2.7.1, there was no cache.  -mozPlacesIDForURL: would always
     execute a query.  The biggest loop in the middle of
     -writeUsingStyle1InOperation:, "for (stark in starks)", which calls
     -mozPlacesIDForURL: in two places, took about 100 minutes to execute.

     Then, I added this cache and changed -mozPlacesIDForURL: to first check
    the cache before each fetch.  Apparently, each mozPlacesID had been fetched
     an average of 2.5 times, because this reduced the time for that loop to
     execute from 100 to 40 minutes.

     Finally, I pre-populated this cache with one query prior to the beginning
     of that loop, and removed the query entirely from -mozPlacesIDForURL:.
     This further reduced the execution time of that loop, to 6 minutes. */
    NSMutableDictionary* m_mozPlacesForUrlCache;
}

/*!
 @brief    Given an Id of an item in moz_bookmarks, executes
 a query on the receiver's Places database to get the guid.

 @details  Used for to update BkmxDocs from prior to BookMacster 1.3.19
 @param    guid_p  On return, will point to the guid found.  Will crash
 if you do not supply a valid pointer.
 @param    id the primary key of the subject bookmark item, which was
 formerly used as the exid.
 @param    error_p  On return, if an error occurred, will point to the 
 error.  Will crash if you do not supply a valid pointer. 
 @result   
*/
- (BOOL)migratedGuid_p:(NSString**)guid_p
				fromId:(NSString*)exid
			   error_p:(NSError**)error_p ;	

/*!
 @brief    Begin an sqlite transaction in places.sqlite, locking
 it so that Firefox cannot get in.

 @details   If this succeeds, it must be balanced by an
 endTransactionError_p:

*/
- (BOOL)beginTransactionError_p:(NSError**)error_p ;
	

- (BOOL)endTransactionError_p:(NSError**)error_p ;

@end


