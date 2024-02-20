#import "XbelCodec.h"
#import "Extore.h"
#import "Client.h"

NSString* const constXbelElementNameXbel = @"xbel" ;
NSString* const constXbelElementNameTitle = @"title" ;
NSString* const constXbelElementNameComments = @"desc" ;
NSString* const constXbelElementNameFolder = @"folder" ;
NSString* const constXbelElementNameBookmark = @"bookmark" ;
NSString* const constXbelElementNameSeparator = @"separator" ;
NSString* const constXbelElementNameInfo = @"info" ;
NSString* const constXbelElementNameMetadata = @"metadata" ;

NSString* const constXbelAttributeNameVersion = @"version" ;
NSString* const constXbelAttributeNameUrl = @"href" ;
NSString* const constXbelAttributeNameExid = @"id" ;
NSString* const constXbelAttributeNameAddDate = @"added" ;
NSString* const constXbelAttributeNameIsNotExpanded = @"folded" ;
NSString* const constXbelAttributeNameFavicon = @"icon" ;
NSString* const constXbelAttributeNameIsBar = @"toolbar" ;
NSString* const constXbelAttributeNameLastModified = @"modified" ;
NSString* const constXbelAttributeNameLastVisited = @"visited" ;
NSString* const constXbelAttributeNameOwner = @"owner" ;

NSString* const constXbelAttributeValueYes = @"yes" ;
NSString* const constXbelAttributeValueNo = @"no" ;

static NSDateFormatter* static_xbelDateFormatter = nil ;

@implementation XbelCodec

@synthesize starker = m_starker ;
@synthesize clientoid = m_clientoid ;
@synthesize error = m_error ;

+ (NSDateFormatter*)dateFormatter {
    if (!static_xbelDateFormatter) {
        static_xbelDateFormatter = [[NSDateFormatter alloc] init] ;
        //  Typical XBEL date: 2015-11-17T18:34:47-0800
        [static_xbelDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssxx"] ;
    }
    
    return static_xbelDateFormatter ;
}

- initWithExtore:(Extore*)extore {
	self = [super init] ;
	
	if (self != nil) {
		[self setStarker:[extore starker]] ;
		[self setClientoid:[[extore client] clientoid]] ;
	}
	
	return self ;
}

- (void) dealloc {
    [m_error release] ;
	
    [super dealloc] ;
}

@end
