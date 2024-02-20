@class Extore ;

@interface  NSString (NSStringBkmxBkmxURLHelp) 

- (BOOL)isSmartSearchUrl ;

- (NSString*)md5HashAsLowercaseHex ;
	// creates an 128-bit (7-byte) MD5 hash of the string,
	// then converts it to a 32-(ASCII)-character (32-byte)
	// string of hexadecimal digits, using lowercase for a-f
	// (This is the "urlHash" used by del.icio.us)

- (NSString*)normalizedUrl ;
	// The above may mangle javascript-schemed bookmarks by doing strict RFC2396 encoding.
	// I'm not sure; unless all characters required to be %escape encoded by RFC2396
	// should already by &escape encoded.  Note that the & and ; characters are not encoded
	// by RFC2396.

- (NSString*)aggressivelyNormalizedUrl ;

- (BOOL)containsUnquotedUnescapedApostrophe ;
- (NSDictionary*)queries ;
- (NSInteger)locationOfUnquotedSubstring:(NSString*)tc ;
- (NSString*)quotedAttributeValueForKey:(NSString*)key ;
- (NSString*)unquotedAttributeValueForKey:(NSString*)key ;
- (NSComparisonResult)compareByDomainHostPathWith:(NSString*)otherString ;
- (BOOL)urlHasSameDomainAs:(NSString*)otherURL ;
- (NSString*)domainOfURL ; // returns nil if self is not xxx.yyy.zzz
- (BOOL)has_NotFound_Keyword ;
- (BOOL)startsWithScheme ;
- (BOOL)looksLikeVacuumCleaner ;
- (BOOL)isKnownUnnecessaryRedirect ;
- (BOOL)isProbablyOK ;
- (BOOL)stupidWebmaster404 ;
	// Not used any more:
- (BOOL)isEqualExceptForQueryToString:(NSString*)orig ;
- (BOOL)pathAndQueryTooLong ;
- (BOOL)schemeIs_feed ;
- (BOOL)looksLikeParallelLoadedHostTo:(NSString*)strURLOld ;
- (BOOL)sameHostAs:(NSString*)otherURL ;
- (BOOL)sameSchemeAs:(NSString*)otherURL ;
- (BOOL)hasPath ;  // Note: a single unpunctuated word such as "bonehead" has path = itself
- (BOOL)sameHostPathButHTTPvsHTTPS:(NSString*)otherURL ;
- (BOOL)sameAllButHTTPvsHTTPS:(NSString*)otherURL ;
- (NSString*)https_from_http ;
- (NSString*)http_from_https ;
- (BOOL)marksSameSiteAs:(NSString*)otherUrl ;
- (NSString*)stringByDecodingAmpEscapes;

/*!
 @param    level  controls what characters to encode:
 1: only the five characters <>&\"
 2: those five characters, plus any non-ASCII character
 */
- (NSString*)stringByEncodingWithAmpEscapesLevel:(NSInteger)level;

@end

