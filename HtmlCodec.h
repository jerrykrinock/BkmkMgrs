#import <Cocoa/Cocoa.h>

@class Extore ;
@class Starker ;
@class Clientoid ;
@class ISO8601DateFormatter ;

extern NSString* const constHtmlElementNameHtml ;
extern NSString* const constHtmlElementNameTitle ;
extern NSString* const constHtmlElementNameComments ;
extern NSString* const constHtmlElementNameFolder ;
extern NSString* const constHtmlElementNameBookmark ;
extern NSString* const constHtmlElementNameSeparator ;
extern NSString* const constHtmlElementNameInfo ;
extern NSString* const constHtmlElementNameMetadata ;

extern NSString* const constHtmlAttributeNameVersion ;
extern NSString* const constHtmlAttributeNameUrl ;
extern NSString* const constHtmlAttributeNameExid ;
extern NSString* const constHtmlAttributeNameAddDate ;
extern NSString* const constHtmlAttributeNameIsNotExpanded ;
extern NSString* const constHtmlAttributeNameFavicon ;
extern NSString* const constHtmlAttributeNameIsBar ;
extern NSString* const constHtmlAttributeNameLastModified ;
extern NSString* const constHtmlAttributeNameLastVisited ;
extern NSString* const constHtmlAttributeNameOwner ;

extern NSString* const constHtmlAttributeValueYes ;
extern NSString* const constHtmlAttributeValueNo ;

@interface HtmlCodec : NSObject {
	Starker* m_starker ;  // weak
	Clientoid* m_clientoid ; // weak
}

@property (nonatomic, assign) Starker* starker ;
@property (nonatomic, assign) Clientoid* clientoid ;

+ (NSDateFormatter*)dateFormatter ;

- initWithExtore:(Extore*)extore ;

@end

