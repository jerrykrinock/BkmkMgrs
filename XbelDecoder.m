#import <Bkmxwork/Bkmxwork-Swift.h>
#import "XbelDecoder.h"
#import "Stark.h"
#import "NSString+SSYExtraUtils.h"
#import "Starker.h"
#import "NSError+InfoAccess.h"
#import "NSError+MyDomain.h"
#import "Extore.h"


@interface XbelDecoder ()

@property (nonatomic, retain) NSXMLParser* parser ;

/*!
 @brief    The current string being parsed inside an element.
*/
@property (nonatomic, retain) NSMutableString* currentString ;

/*!
 @brief    The current lineage of starks.  

 @details  The first element in this array is the receiver's
 extore's starker's root stark.
*/
@property (nonatomic, retain) NSMutableArray* currentStarks ;

/*!
 @brief    The attributes of the element currently being parsed
 
 @details  NSXMLParser only gives these when the element begins.
 But sometimes you need to save them for when the element ends.
 */
@property (nonatomic, retain) NSDictionary* currentAttributes ;

@end


@implementation XbelDecoder

@synthesize currentString = m_currentString ;
@synthesize currentStarks = m_currentStarks ;
@synthesize currentAttributes = m_currentAttributes ;
@synthesize parser = m_parser ;


- initWithData:(NSData*)data
		extore:(Extore*)extore {
	if (data) {
		self = [super initWithExtore:extore] ;
		
		if (self != nil) {
			NSXMLParser* parser = [[NSXMLParser alloc] initWithData:data] ;
			[parser setDelegate:self] ;
			[self setParser:parser] ;
			[parser release] ;
			
			NSMutableString* currentString = [[NSMutableString alloc] init] ;
			[self setCurrentString:currentString] ;
			[currentString release] ;

			NSMutableArray* currentStarks = [[NSMutableArray alloc] init] ;
			[self setCurrentStarks:currentStarks] ;
			[currentStarks release] ;
			
			Starker* starker = [self starker] ;
			Stark* root = [starker root] ;
			[currentStarks addObject:root] ;
		}
	}
	
	return self ;
}

- (void) dealloc {
	[m_parser release] ;
	[m_currentString release] ;
	[m_currentStarks release] ;
	[m_currentAttributes release] ;
	
    [super dealloc] ;
}

- (BOOL)decode {
	BOOL ok = [[self parser] parse] ;
	return ok ;
}

+ (BOOL) decodeData:(NSData*)data
			extore:(Extore*)extore
		   error_p:(NSError**)error_p {
	XbelDecoder* instance = [[XbelDecoder alloc] initWithData:data
													 extore:extore] ;
    
	BOOL ok = [instance decode] ;
	
	if (!ok && error_p) {
		*error_p = [instance error] ;
	}
	
	[instance release] ;
	    
	return ok ;
}

+ (NSSet*)starkElements {
	return [NSSet setWithObjects:
			constXbelElementNameFolder,
			constXbelElementNameBookmark,
			constXbelElementNameSeparator,
			nil] ;
}
			

#pragma mark * NSXMLParser Delegate Methods

- (void)    parser:(NSXMLParser*)parser
   didStartElement:(NSString*)elementName
	  namespaceURI:(NSString*)namespaceURI
	 qualifiedName:(NSString*)qualifiedName
		attributes:(NSDictionary*)attributeDict {
	
	if ([[XbelDecoder starkElements] member:elementName]) {
		// We've got a new stark
		
		Starker* starker = [self starker] ;
		Stark* stark = [starker freshStark] ;
		[stark moveToBkmxParent:[[self currentStarks] lastObject]
						atIndex:NSNotFound
						restack:YES] ;
		[[self currentStarks] addObject:stark] ;

		NSString* string ;

		Sharype sharype ;
		if ([elementName isEqualToString:constXbelElementNameBookmark]) {
			sharype = SharypeBookmark ;

			NSString* url = [[attributeDict objectForKey:constXbelAttributeNameUrl] stringByDecodingXMLEntities] ;
			[stark setUrl:url] ;
			
			string = [attributeDict objectForKey:constXbelAttributeNameLastModified] ;
			if (string) {
				[stark setLastModifiedDate:[[XbelCodec dateFormatter] dateFromString:string]] ;
			}
			
			string = [attributeDict objectForKey:constXbelAttributeNameLastVisited] ;
			if (string) {
				[stark setLastVisitedDate:[[XbelCodec dateFormatter] dateFromString:string]] ;
			}
		}
		else if ([elementName isEqualToString:constXbelElementNameFolder]) {
			string = [attributeDict objectForKey:constXbelAttributeNameIsBar] ;
			sharype = [string isEqualToString:constXbelAttributeValueYes] ? SharypeBar : SharypeSoftFolder ;
			string = [attributeDict objectForKey:constXbelAttributeNameIsNotExpanded] ;
			// The XBEL standard does not seem to specify a default value if folder is nil.
			// I choose notExpanded=no which means isExpanded=YES.
			BOOL isExpanded = ![string isEqualToString:constXbelAttributeValueYes] ;
			[stark setIsExpanded:[NSNumber numberWithBool:isExpanded]] ;
		}
		else {
			sharype =  SharypeSeparator ;
			[stark setName:@"Separator"] ;
		}		
		[stark setSharypeValue:sharype] ;
		
		string = [attributeDict objectForKey:constXbelAttributeNameExid] ;
		if (string) {
			[stark setExid:string
			  forClientoid:[self clientoid]] ;
		}
		
		string = [attributeDict objectForKey:constXbelAttributeNameAddDate] ;
		if (string) {
			[stark setAddDate:[[XbelCodec dateFormatter] dateFromString:string]] ;
		}
	}
	else {		
		// The contents are collected in parser:foundCharacters:.
		m_accumulatingParsedCharacterData = YES ;
		// The mutable string needs to be reset to empty.
		[m_currentString setString:@""] ;
		
		// We'll need this later, if elementName is metadata
		[self setCurrentAttributes:attributeDict] ;
	}
	
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
	NSMutableArray* currentStarks = [self currentStarks] ;
	if (m_accumulatingParsedCharacterData) {
		// Stop accumulating parsed character data. We won't start again until specific elements begin.
		m_accumulatingParsedCharacterData = NO ;
		Stark* stark = [currentStarks lastObject] ;
		// A copy is needed here because (apparently) Core Data's setters don't
		// copy the string immediately.  Without the copy, all names and all
		// comments in all starks have same value as the last one parsed.
		NSString* value = [[self currentString] copy] ;
		if ([elementName isEqualToString:constXbelElementNameTitle]) {
			[stark setName:value] ;
		}
		else if ([elementName isEqualToString:constXbelElementNameComments]) {
			[stark setComments:value] ;
		}
		else if ([elementName isEqualToString:constXbelElementNameMetadata]) {
			/* Webnote (formerly Webnote Happy) puts 'tags', 'private' and 'shared'
			 as metadata.  We try and import those in this section.  Example:
			 <bookmark href="http://www.apple.com/" added="2010-05-04T15:57:03-0700" modified="2010-10-18T14:01:07-0700">
			 <title>Apple</title>
			 <desc>This is Apple's website</desc>
			 <info>
			 <metadata owner="http://www.happyapps.com/webnotehappy/xbel/tags">computer Stuff</metadata>
			 <metadata owner="http://www.happyapps.com/webnotehappy/xbel/shared">0</metadata>
			 <metadata owner="http://www.happyapps.com/webnotehappy/xbel/private">0</metadata>
			 </info>
			 </bookmark>
			 The fact that 'metadata' is a sub-element of 'info' doesn't matter.  All that
			  matters is that it's also a sub-element of 'bookmark', so we're in the current stark.
				*/
			NSDictionary* attributes = [self currentAttributes] ;
			NSString* owner = [attributes objectForKey:constXbelAttributeNameOwner] ;
			NSInteger isShared = NSControlStateValueMixed ;
			if ([owner hasSuffix:@"tags"]) {
				NSArray* tags = [value componentsSeparatedByString:@" "] ;
                [[(Extore*)[stark owner] tagger] addTagStrings:[NSSet setWithArray:tags]
                                                            to:stark];
			}
			else if ([owner hasSuffix:@"shared"]) {
				if ([value integerValue] == 0) {
					isShared = NSControlStateValueOff ;
				}
				else if ([value integerValue] == 1) {
					isShared = NSControlStateValueOn ;
				} 
			}
			else if ([owner hasSuffix:@"private"]) {
				if ([value integerValue] == 0) {
					isShared = NSControlStateValueOn ;
				}
				else if ([value integerValue] == 1) {
					isShared = NSControlStateValueOff ;
				} 
			}
            // OK to hard-code "BookMacster" because Xbel is only supported in BookMacster?
			else if ([owner isEqualToString:@"com.sheepsystems.BookMacster/hartainer"]) {
				Sharype sharype = SharypeUndefined ;
				if ([value isEqualToString:constBkmxSymbolHartainerBar]) {
					sharype = SharypeBar ;
				}
				else if ([value isEqualToString:constBkmxSymbolHartainerMenu]) {
					sharype = SharypeMenu ;
				}
				else if ([value isEqualToString:constBkmxSymbolHartainerUnfiled]) {
					sharype = SharypeUnfiled ;
				}
				else if ([value isEqualToString:constBkmxSymbolHartainerOhared]) {
					sharype = SharypeOhared ;
				}
				
				[stark setSharypeValue:sharype] ;
			}
            // OK to hard-code "BookMacster" because Xbel is only supported in BookMacster?
			else if ([owner isEqualToString:@"com.sheepsystems.BookMacster/exid"]) {
                [stark setExid:value
                  forClientoid:[self clientoid]] ;
            }
            
			switch (isShared) {
				case NSControlStateValueOn:
					[stark setIsShared:[NSNumber numberWithBool:YES]] ;
					break ;
				case NSControlStateValueOff:
					[stark setIsShared:[NSNumber numberWithBool:NO]] ;
					break ;
				default:
					break ;
			}
		}
		
		[value release] ;
	}
	
	if ([[XbelDecoder starkElements] member:elementName]) {
		// This is the end of a stark element (folder, separator, bookmark)
		if ([currentStarks count] > 0) {
			[currentStarks removeLastObject] ;
		}
		else {
			NSString* msg = [NSString stringWithFormat:@"Unbalanced element '%@' in XML", elementName] ;
			NSError* error = SSYMakeError(513958, msg) ;
			[self setError:error] ;
			[parser abortParsing] ;
		}
	}
}

- (void)  parser:(NSXMLParser*)parser
 foundCharacters:(NSString*)string {
    if (m_accumulatingParsedCharacterData) {
        // If the current element is one whose content we care about, append 'string'
        // to the property that holds the content of the current element.
        //
        [[self currentString] appendString:string] ;
    }
}

- (void)     parser:(NSXMLParser*)parser
 parseErrorOccurred:(NSError*)error {
	if (error) {
		// Possibly we have already set an error and aborted parsing.
		// The error we have already set would be the underlying error.
		[self setError:[error errorByAddingUnderlyingError:[self error]]] ;
	}
}

@end
