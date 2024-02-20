#import "XbelCodec.h"

@class Stark ;
@class Extore ;
@class Starker ;
@class Clientoid ;
@class ISO8601DateFormatter ;

/*!
 @brief    Provides a class method for parsing contents of XBEL XML files
 into the localMoc of a given extore
*/
@interface XbelDecoder : XbelCodec <NSXMLParserDelegate> {
    BOOL m_accumulatingParsedCharacterData ;
	NSMutableString* m_currentString ;
	NSDictionary* m_currentAttributes ;
	NSMutableArray* m_currentStarks ;
	NSXMLParser* m_parser;
}

/*!
 @brief    Parses given XBEL data into the starker of a given extore.

 @detail  
 @param    data  
 @param    extore  The extore into whose localMoc any items parsed will be
 inserted as starks.
 @param    error  Pointer to an NSError* or NULL.  If not NULL, and an error
 occurs, an NSError explaining the error will be assigned to this pointer.
 @result   YES if the operation completes with no error, otherwise NO.
*/
+ (BOOL)decodeData:(NSData*)data
		   extore:(Extore*)extore
		  error_p:(NSError**)error_p ;

@end
