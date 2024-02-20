@class Extore ;
@class Clientoid ;

/*!
 @brief    Provides a class method for parsing Pinboard XML responses
 into the localMoc of a given extore
*/
@interface DelPinParser : NSObject <NSXMLParserDelegate> {
    NSXMLParser* parser;
    NSData* data;
	
	BOOL _insertDates ;
	BOOL _doStarks ;
	BOOL _insertBundles ;
	NSInteger _debugCount ; 
	
	Extore* _extore ;  // weak
	Clientoid* clientoid ;
	NSDate* lastUpdateTime ;
	NSError* m_error ;
}

/*!
 @brief    Parses given data downloaded from del.icious, obtaining, optionally:
 posts and tags, dates and/or bundles.

 @detail  
 @param    data  
 @param    doStarks  If YES, bookmarks and tags are parsed from data
 and inserted into the localMoc of the extore.
 @param    doDates  Switches on a function which is not implemented at this time.
 @param    doBundles  Switches on a function which is not implemented at this time.
 @param    extore  The extore into whose localMoc any bookmarks and tags found will be
 inserted as starks, and whose client's clientoid the exid of each
 inserted stark will be associated with.  If the data to be parsed does not include
 any bookmarks, for example, if we are merely parsing for a lastUpdateTime,
 you may pass nil.
 @param    lastUpdateTime  Pointer to an NSDate* or NULL.&nbsp; If not NULL, and 
 a last update time is found while parsing the data, an NSDate representing this time
 will be assigned to this pointer.
 @param    error  Pointer to an NSError* or NULL.&nbsp; If not NULL, and an error
 occurs, an NSError explaining the error will be assigned to this pointer.
 @result   YES if the operation completes with no error, otherwise NO.
*/
+ (BOOL) parseData:(NSData*)data
		  doStarks:(BOOL)doStarks
		   doDates:(BOOL)doDates
		 doBundles:(BOOL)doBundles
			extore:(Extore*)extore
	lastUpdateTime:(NSDate**)lastUpdateTime
			 error:(NSError**)error ;

+ (NSDateFormatter*)dateFormatterForDeliPin ;

@end
