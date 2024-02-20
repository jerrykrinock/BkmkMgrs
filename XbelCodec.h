#import <Cocoa/Cocoa.h>

@class Extore ;
@class Starker ;
@class Clientoid ;
@class ISO8601DateFormatter ;

extern NSString* const constXbelElementNameXbel ;
extern NSString* const constXbelElementNameTitle ;
extern NSString* const constXbelElementNameComments ;
extern NSString* const constXbelElementNameFolder ;
extern NSString* const constXbelElementNameBookmark ;
extern NSString* const constXbelElementNameSeparator ;
extern NSString* const constXbelElementNameInfo ;
extern NSString* const constXbelElementNameMetadata ;

extern NSString* const constXbelAttributeNameVersion ;
extern NSString* const constXbelAttributeNameUrl ;
extern NSString* const constXbelAttributeNameExid ;
extern NSString* const constXbelAttributeNameAddDate ;
extern NSString* const constXbelAttributeNameIsNotExpanded ;
extern NSString* const constXbelAttributeNameFavicon ;
extern NSString* const constXbelAttributeNameIsBar ;
extern NSString* const constXbelAttributeNameLastModified ;
extern NSString* const constXbelAttributeNameLastVisited ;
extern NSString* const constXbelAttributeNameOwner ;

extern NSString* const constXbelAttributeValueYes ;
extern NSString* const constXbelAttributeValueNo ;

@interface XbelCodec : NSObject {
	Starker* m_starker ;  // weak
	Clientoid* m_clientoid ; // weak
	NSError* m_error ;
}

@property (nonatomic, assign) Starker* starker ;
@property (nonatomic, assign) Clientoid* clientoid ;
@property (nonatomic, retain) NSError* error ;

+ (NSDateFormatter*)dateFormatter ;

- initWithExtore:(Extore*)extore ;

@end

