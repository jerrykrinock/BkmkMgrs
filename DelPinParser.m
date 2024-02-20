#import "Bkmxwork/Bkmxwork-Swift.h"
#import "DelPinParser.h"
#import "NSError+MyDomain.h"
#import "Stark.h"
#import "ExtoreWebFlat.h"
#import "NSString+SSYExtraUtils.h"
#import "NSString+BkmxURLHelp.h" // for testing md5 of Izra's Hot Tub
#import "Starker.h"
#import "Ixporter.h"
#import "NSObject+MoreDescriptions.h"
#import "BkmxBasis+Strings.h"
#import "NSError+InfoAccess.h"


static NSDateFormatter* static_deliPinDateFormatter = nil ;


@interface NSData (FixDeliPinBug)

/*!
 @brief    Fixes bug(s) in Pinboard, who sometimes
 send incorrect XML.

 The bug is that Pinboard sometimes sends
 disallowed characters in 'description' and 'href' values.
 In particular the C0 control characters 0x01 throughh 0x1F
 have been seen.  The allowed characters for XML attribute
 values are stated here:
 http://www.w3.org/TR/2006/REC-xml-20060816/#NT-Char
 Reading the inverse of that, the disallowed characters are:
 •  0x00 through 0x1F.  Technically, 0x09, 0x0A and 0x0D are
 allowed, but we disallow them because, per this spec:
 http://www.xml.com/axml/target.html#AVNormalize
 NSXMLParser will turn them into 0x20 space characters.
 •  0xD800 through 0xDFFF
 •  0xFFFE through 0xFFFF
*/
- (NSData*)dataByFixingDeliPinBug ;

@end

@implementation NSData (FixDeliPinBug)

- (NSData*)dataByFixingDeliPinBug {
	NSString* dataString = [[NSString alloc] initWithData:self
												 encoding:NSUTF8StringEncoding] ;
	NSData* dataOut ;
	
	if (!dataString) {
		NSLog(@"Warning 151-5902 %ld bytes not UTF8", (long)[self length]) ;
		// Return self, hoping that there was nothing in self that needed to be fixed
		dataOut = self ;
		goto end ;
	}

	NSMutableCharacterSet* xmlDisallowedCharacterSet = [[NSMutableCharacterSet alloc] init] ;
	[xmlDisallowedCharacterSet addCharactersInRange:NSMakeRange(0x0, 0x20)] ;
	[xmlDisallowedCharacterSet addCharactersInRange:NSMakeRange(0xD800, 0x800)] ;
	[xmlDisallowedCharacterSet addCharactersInRange:NSMakeRange(0xFFFE, 0x2)] ;
	
	NSScanner* scanner = [[NSScanner alloc] initWithString:dataString] ;
	[scanner setCharactersToBeSkipped:nil] ;
	NSMutableString* fixedString = [[NSMutableString alloc] init] ;
	BOOL isInQuote = NO ;
	BOOL didFindQuote ;
	NSString* piece = @"" ;
	NSString* quotedString = @"" ;

	while (![scanner isAtEnd]) {
		[scanner scanUpToString:@"\""
					 intoString:&piece] ;
		[fixedString appendString:piece] ;
		didFindQuote = [scanner scanString:@"\""
								intoString:&piece] ;
		if (didFindQuote) {
			isInQuote = !isInQuote ;
		}
		else {
			break ;
		}
		[fixedString appendString:piece] ;
		// Re-initialize quotedString, because in case the next attribute is an
		// empty string, quotedString will not be touched by -scanUpToString::
		quotedString = @"" ;
		[scanner scanUpToString:@"\""
					 intoString:&quotedString] ;
		didFindQuote = [scanner scanString:@"\""
								intoString:NULL] ;
		if (didFindQuote) {
			isInQuote = !isInQuote ;
		}
		else {
			break ;
		}
		
		NSScanner* subscanner = [[NSScanner alloc] initWithString:quotedString] ;
		[subscanner setCharactersToBeSkipped:nil] ;
		while (![subscanner isAtEnd]) {
			// The following line is a bug fix in BookMacster 1.9.9.
			// This failed with Error 65 if a disallowed character was the *first*
			// character in quotedString, because when no characters are scanned,
			// NSScanner does not alter the 'intoString'.  Not the first time
			// I've been bitten by that!
            piece = @"" ;  
			[subscanner scanUpToCharactersFromSet:xmlDisallowedCharacterSet
									   intoString:&piece] ;
			[fixedString appendString:piece] ;
			if (![subscanner isAtEnd]) {
				unichar disallowedChar = [quotedString characterAtIndex:[subscanner scanLocation]] ;
				[subscanner setScanLocation:[subscanner scanLocation] + 1] ;
				// Now, not only are characters in the disallowed set disallowed,
				// but, except for 0x09, 0x0a and 0x0d, they are not even allowed
				// if you escape them.  Here's how we handle that…
				NSString* replacement ;
				if ((disallowedChar=='\t') || (disallowedChar=='\n') || (disallowedChar=='\r')) {
					replacement = [NSString stringWithFormat:@"&#%ld;", (long)disallowedChar] ;
				}
				else {
					// Instead of just using a fixed replacement, such as 0xBF which
					// is the inverted (Spanish) question-mark, we replace with a
					// decimal string so that, if, for example, we have many bookmarks
					// with the same URL except for a disallowed character, we won't
					// be creating duplicates.  Now, because of the mutated URL, in
					// Pinboard, you won't be able to ever update or delete the
					// bookmark, but, oh, well.
					replacement = [NSString stringWithFormat:
								   @"%C%ld",
								   (unsigned short)0x00BF, // inverted (Spanish) question-mark
								   (long)disallowedChar] ;
				}
				[fixedString appendString:replacement] ;
			}
		}
		[subscanner release] ;
		[fixedString appendString:@"\""] ;
	}
	
	[scanner release] ;
	[xmlDisallowedCharacterSet release] ;
	
	dataOut = [fixedString dataUsingEncoding:NSUTF8StringEncoding] ;	
	[fixedString release] ;

end:
	[dataString release] ;
	
	return dataOut ;
}

@end




@interface DelPinParser ()

@property (retain) NSXMLParser* parser ;
@property (retain) NSData* data ;
@property (retain) NSDate* lastUpdateTime ;
@property (retain) Clientoid* clientoid ;
@property (retain) NSError* error ;

@end


@implementation DelPinParser

@synthesize parser ;
@synthesize data ;
@synthesize lastUpdateTime ;
@synthesize clientoid ;
@synthesize error = m_error ;

+ (NSDateFormatter*)dateFormatterForDeliPin {
    if (!static_deliPinDateFormatter) {
        static_deliPinDateFormatter = [[NSDateFormatter alloc] init] ;
        [static_deliPinDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"] ;
        [static_deliPinDateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]] ;
    }
    
    return static_deliPinDateFormatter ;
}

- (void)setExtore:(Extore*)extore {
	_extore = extore ;
}

- (Extore*)extore {
	return _extore ;
}

- initWithData:(NSData*)data_
	  doStarks:(BOOL)doStarks
	   doDates:(BOOL)doDates
	 doBundles:(BOOL)doBundles
		extore:(Extore*)extore
lastUpdateTime:(NSDate**)hdlLastUpdateTime
		 error:(NSError**)hdlError {
	if (data_) {
		self = [super init] ;
		
		if (self != nil) {
			data_ = [data_ dataByFixingDeliPinBug] ;
			[self setData:data_] ;
			
			// NSString* s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;NSLog(@"RebugLog: 1273 initting parser with data: %@", s) ; [s release] ;
			NSXMLParser* parser_ = [[NSXMLParser alloc] initWithData:data_] ;
			[parser_ setDelegate:self] ;
			[parser_ setShouldResolveExternalEntities:YES] ;
			[self setParser:parser_] ;
			[parser_ release] ;
			
			_doStarks = doStarks ;
			_insertDates = doDates ;
			_insertBundles = doBundles ;
			[self setClientoid:[[extore client] clientoid]] ;
			[self setExtore:extore] ;
			[self setError:nil] ;
		}
	}
	
	return self;
}

- (void) dealloc {
	[data release] ;
	[parser release] ;
	[clientoid release] ;
    [lastUpdateTime release] ;
    [m_error release] ;
	
    [super dealloc];
}

- (void)parse {
	_debugCount = 0 ;
	
	[[self parser] parse] ;
}

+ (BOOL) parseData:(NSData*)data
		  doStarks:(BOOL)doStarks
		   doDates:(BOOL)doDates
		 doBundles:(BOOL)doBundles
			extore:(Extore*)extore
	lastUpdateTime:(NSDate**)hdlLastUpdateTime
			 error:(NSError**)hdlError {
	DelPinParser* instance = [[DelPinParser alloc] initWithData:data
													   doStarks:doStarks
														doDates:doDates
													  doBundles:doBundles
														 extore:extore
												 lastUpdateTime:hdlLastUpdateTime
														  error:hdlError] ;
    
    [instance parse] ;
	NSError* error = [instance error] ;
	
	if (error) {
		goto end ;
	}
	
end:;	
	if (hdlLastUpdateTime) {
		*hdlLastUpdateTime = [instance lastUpdateTime] ;
	}
	if (hdlError) {
		*hdlError = error ;
	}
	
	[instance release] ;
		
	return (error == nil) ;
}

#pragma mark * NSXMLParser Delegate Methods

-(void)     parser:(NSXMLParser*)parser
   didStartElement:(NSString*)elementName
	  namespaceURI:(NSString*)namespaceURI
	 qualifiedName:(NSString*)qualifiedName
		attributes:(NSDictionary*)attributeDict {
	
	if (_doStarks && [elementName isEqualToString:@"post"]) {
		NSString* URLString = [[attributeDict objectForKey:@"href"] stringByDecodingXMLEntities] ;
        
        NSString* postDescription = [[attributeDict objectForKey:@"description"] stringByDecodingXMLEntities];
		NSString* postExtended = [[attributeDict objectForKey:@"extended"] stringByDecodingXMLEntities] ;
        
        NSString* postDateString = [[attributeDict objectForKey:@"time"] stringByDecodingXMLEntities] ;
		NSDate* postDate = nil ;
		if (postDateString) {
            // Must set time zone to local time, format to standard format
			postDate = [[[self class] dateFormatterForDeliPin] dateFromString:postDateString] ;            
		}
		
		NSString* tagString = [[attributeDict objectForKey:@"tag"] stringByDecodingXMLEntities];
		
		NSString* hashString = [[attributeDict objectForKey:@"hash"] stringByDecodingXMLEntities];
	
		NSString* sharedString = [[attributeDict objectForKey:@"shared"] stringByDecodingXMLEntities];
	
		NSNumber* isShared = [NSNumber numberWithBool:YES] ;
	
		if (sharedString && [sharedString isEqualToString:@"no"]) {
			isShared = [NSNumber numberWithBool:NO];
		}
	
		Starker* starker = [[self extore] localStarker] ;
		Stark* stark = [starker freshStark] ;
		[stark setSharypeValue:SharypeBookmark] ;
		[stark setName:(postDescription ? postDescription : [[BkmxBasis sharedBasis] labelNoName])] ;
#if DEBUG_WRITE_IMPORTED_URLS_TO_FILES
		[[self extore] appendBookmarkSSYLinearFileWriterName:postDescription
														 url:URLString] ;
#endif
		// -normalizedUrl added in BookMacster 1.10, when it was found
		// that Pinboard was sending un-normalized URLs, in particular,
		// they could send pathless URLs that don't end in a trailing slash.
        // Tim Jones fails here, in -normalizedUrl
		[stark setUrl:[URLString normalizedUrl]] ;

		if ([postExtended length]) {
			[stark setComments:postExtended] ;
		}
		if (postDate) {
			[stark setAddDate:postDate] ;
		}
		if (![tagString isEqualToString:@"system:unfiled"]) {
			NSArray* tags = [[[self extore] class] tagArrayFromString:tagString] ;
            [[[self extore] localTagger] addTagStrings:[NSSet setWithArray:tags]
                                                    to:stark];
		}
		
		NSString* myHash = [URLString md5HashAsLowercaseHex] ;
		if(![hashString isEqualToString:myHash]) {
            NSString* metaString = [[attributeDict objectForKey:@"meta"] stringByDecodingXMLEntities];
            NSLog(@"Warning hashes don't match for %@\n    meta: %@\n    hash: %@\n  Extore: %@", postDescription, metaString, hashString, myHash);
        }
		
		/* The Local MOC has attribute `exid` on entity Stark, and this is what
         is stored on disk, so we set that now.  This will be copied to `exids`
         in the Trans MOC when
         • -[ExtoreWebFlat syncLocalToTrans]
         • calls -[Stark replicatedOrphanStarkFreshened:replicator:]
         • calls -[Stark copyExidsFromStark:] */
        [stark setExid:hashString];

		[stark setIsShared:isShared] ;

		_debugCount++ ;
	}
	else if ([elementName isEqualToString: @"update"]) {
		NSString* dateString = [attributeDict objectForKey:@"time"] ;
        NSDate* lastUpdateTimey = [[[self class] dateFormatterForDeliPin] dateFromString:dateString] ;

		//NSLog(@"96020 Parsed from del.icio.us lastUpdate: %@", lastUpdateTime) ;
		[self setLastUpdateTime:lastUpdateTimey] ;
	}
	else if ([elementName isEqualToString: @"posts"]) {
		// This is the response to a posts/get API request.
		// All I use this for is to get the username, after a OAuth login.
		// Note: With Pinboard, we know the Pinboard username because the
		// user gives it to us in the "New/Other" sheet.  But with OAuth, we don't.
		// See http://developer.yahoo.net/forum/index.php?showtopic=5011&hl=krinock
		// in Yahoo! Developer Network . YDN Forums . Y!OS . OAuth, date 20100323
		// In BookMacster 1.8 Delicious2 no longer exists.  So the following code should
		// no longer be needed.
		NSString* username = [attributeDict objectForKey:@"user"] ;
		if (username) {
			// Prior to BookMacster 1.1, I unconditionally set the client's 
			// profileName to the username at this point.  But that had two
			// bad effects:
			// 1.  It no longer matches the profileName obtained from keychain,
			// which populates the popup menus in Settings > Clients, so that 
			// the selected item is no longer matched in -[ClientsListView menuNeedsUpdate:].
			// 2.  It no longer matches the exid keys in previously-imported bookmarks.
			// So now, I only set it if it's nil, which it will be on the first test login.
			Extore* extore = [self extore] ;
			Client* client = [[extore ixporter] client] ;
			if (![client profileName]) {
				NSLog(@"Warning 209-9038 Should have already had profileName for %@", [client shortDescription]) ;
				[client setProfileName:username] ;
			}
		}
	}
    else if (_insertBundles) {
		// Not implemented yet.
    }
}

- (NSData*)         parser:(NSXMLParser*)parser
 resolveExternalEntityName:(NSString*)name
				  systemID:(NSString*)systemID {
	return nil ;
}

- (void)     parser:(NSXMLParser*)parser
 parseErrorOccurred:(NSError*)parserError {
	NSString* msg = [NSString stringWithFormat:@"Error occurred while parsing %ld bookmarks in %ld bytes from server.",
                     (long)_debugCount,
                     (long)[[self data] length]] ;
	NSError* error = SSYMakeError(519084, msg) ;
	error = [error errorByAddingUnderlyingError:parserError] ;
	[self setError:error] ;
}

@end
