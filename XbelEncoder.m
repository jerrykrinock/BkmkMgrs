#import "XbelEncoder.h"
#import "Stark.h"
#import "Starker.h"
#import "StarkTyper.h"

@interface Stark (Xbel)

- (NSXMLElement*)xbelElementWithDateFormatter:(NSDateFormatter*)formatter
                                    clientoid:(Clientoid*)clientoid ;

@end

@implementation Stark (Xbel)

- (NSXMLElement*)xbelElementWithDateFormatter:(NSDateFormatter*)formatter
                                    clientoid:(Clientoid*)clientoid {
	
	Sharype sharypeCoarseValue = [self sharypeCoarseValue] ;
	NSString* elementName = nil ;
	NSMutableDictionary* attributes = [[NSMutableDictionary alloc] init] ;
	id object ;
	NSXMLElement* infoElement = nil ;
    infoElement = [NSXMLElement elementWithName:constXbelElementNameInfo] ;

	switch (sharypeCoarseValue) {
		case SharypeCoarseHartainer:;
			Sharype sharype = [self sharypeValue] ;
			NSString* symbol ;
			switch (sharype) {
				case SharypeBar:
					symbol = constBkmxSymbolHartainerBar ;
					break;
				case SharypeMenu:
					symbol = constBkmxSymbolHartainerMenu ;
					break;
				case SharypeUnfiled:
					symbol = constBkmxSymbolHartainerUnfiled ;
					break;
				case SharypeOhared:
					symbol = constBkmxSymbolHartainerOhared ;
					break;
				default:
					symbol = nil ;
					break;
			}
			
			if (symbol) {
				NSXMLElement* metadataElement = [NSXMLElement elementWithName:constXbelElementNameMetadata
															   stringValue:symbol] ;
				NSDictionary* attributes = [NSDictionary dictionaryWithObject:@"com.sheepsystems.BookMacster/hartainer"
																	   forKey:@"owner"] ;
				[metadataElement setAttributesAsDictionary:attributes] ;
				[infoElement addChild:metadataElement] ;
			}
			
		case SharypeCoarseSoftainer:
			// isExpanded
			object = [self isExpanded] ;
			if (object) {
				object = [object boolValue] ? constXbelAttributeValueNo : constXbelAttributeValueYes ;
			}
			else {
				// Folder is not expanded, so isNotExpanded is YES
				object = constXbelAttributeValueYes ;
			}
			[attributes setObject:object
						   forKey:constXbelAttributeNameIsNotExpanded] ;
			elementName = constXbelElementNameFolder ;
			
			break ;
		case SharypeCoarseLeaf:
			elementName = constXbelElementNameBookmark ;

			object = [self url] ;
			[attributes setValue:object
						  forKey:constXbelAttributeNameUrl] ;

			object = [self lastModifiedDate] ;
			if (object) {
				[attributes setValue:[formatter stringFromDate:(NSDate*)object]
							  forKey:constXbelAttributeNameLastModified] ;
			}
			
			object = [self lastVisitedDate] ;
			if (object) {
				[attributes setValue:[formatter stringFromDate:(NSDate*)object]
							  forKey:constXbelAttributeNameLastVisited] ;
			}
			
			break ;
		case SharypeCoarseNotch:
			elementName = constXbelElementNameSeparator ;
			break ;
	}
	
    object = [self exidForClientoid:clientoid] ;
    if (object) {
        NSXMLElement* metadataElement = [NSXMLElement elementWithName:constXbelElementNameMetadata
                                                          stringValue:object] ;
        NSDictionary* attributes = [NSDictionary dictionaryWithObject:@"com.sheepsystems.BookMacster/exid"
                                                               forKey:@"owner"] ;
        [metadataElement setAttributesAsDictionary:attributes] ;
        [infoElement addChild:metadataElement] ;
    }
    
    
    
	NSXMLElement* element = [[NSXMLElement alloc] initWithName:elementName] ;
	if (infoElement) {
		[element addChild:infoElement] ;
	}
	
	object = [self addDate] ;
	if (object) {
		[attributes setValue:[formatter stringFromDate:(NSDate*)object]
					  forKey:constXbelAttributeNameAddDate] ;
	}
	
	[element setAttributesAsDictionary:attributes] ;
	[attributes release] ;

	// name
	object = [self name] ;
	if (object) {
		NSXMLElement* child = [NSXMLElement elementWithName:constXbelElementNameTitle
												stringValue:object] ;
		[element addChild:child] ;
	}
	
	// comments
	object = [self comments] ;
	if (object) {
		NSXMLElement* child = [NSXMLElement elementWithName:constXbelElementNameComments
												stringValue:object] ;
		[element addChild:child] ;
	}
	
	// children (recursion)
	for (Stark* child in [self childrenOrdered]) {
		NSXMLElement* xbelChild = [child xbelElementWithDateFormatter:formatter
                                                            clientoid:(Clientoid*)clientoid] ;
		[element addChild:xbelChild] ;
	}
		
	return [element autorelease] ;
}

@end



@implementation XbelEncoder

- (BOOL)getData:(NSData**)data_p {
	
	// Every XML document needs a root element, so we create a root element, then use it
	// to create our new document
	
	NSXMLElement* root = [[NSXMLElement alloc] initWithName:constXbelElementNameXbel] ;
	NSXMLDocument* doc = [[NSXMLDocument alloc] initWithRootElement:root] ;
	[root release] ;

	// A DTD is needed to create the header line "<!DOCTYPE xbel>"
	NSXMLDTD* dtd = [[NSXMLDTD alloc] initWithKind:NSXMLDTDKind] ;
	[dtd setName:constXbelElementNameXbel] ;
	[doc setDTD:dtd] ;
    [dtd release] ;
    
	NSDictionary *attr = [NSDictionary dictionaryWithObject:@"1.0"
													 forKey:constXbelAttributeNameVersion] ;
	[root setAttributesAsDictionary:attr] ;
    
	for (Stark* child in [[[self starker] root] childrenOrdered]) {
		[root addChild:[child xbelElementWithDateFormatter:[XbelCodec dateFormatter]
                                                 clientoid:[self clientoid]]] ;
	}

	NSMutableData* data = [[@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" dataUsingEncoding:NSUTF8StringEncoding] mutableCopy] ;
	[data appendData:[doc XMLDataWithOptions:NSXMLNodePrettyPrint]] ;
    [doc release] ;
	*data_p = [NSData dataWithData:data] ;
	[data release] ;
		
	return YES ;
}

+ (BOOL)generateXbelExportData_p:(NSData**)data_p
                          extore:(Extore*)extore
                         error_p:(NSError**)error_p {
	XbelEncoder* instance = [[XbelEncoder alloc] initWithExtore:extore] ;
    
	BOOL ok = [instance getData:data_p] ;
	
	if (!ok && error_p) {
		*error_p = [instance error] ;
	}
	
	[instance release] ;
	
	return ok ;
}

@end
