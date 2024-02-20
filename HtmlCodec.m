#import "HtmlCodec.h"
#import "Extore.h"
#import "Client.h"

NSString* const constHtmlElementNameHtml = @"NETSCAPE-Bookmark-file-1" ;
NSString* const constHtmlElementNameTitle = @"title" ;
NSString* const constHtmlElementNameComments = @"desc" ;
NSString* const constHtmlElementNameFolder = @"folder" ;
NSString* const constHtmlElementNameBookmark = @"bookmark" ;
NSString* const constHtmlElementNameSeparator = @"separator" ;
NSString* const constHtmlElementNameInfo = @"info" ;
NSString* const constHtmlElementNameMetadata = @"metadata" ;

NSString* const constHtmlAttributeNameVersion = @"version" ;
NSString* const constHtmlAttributeNameUrl = @"href" ;
NSString* const constHtmlAttributeNameExid = @"id" ;
NSString* const constHtmlAttributeNameAddDate = @"added" ;
NSString* const constHtmlAttributeNameIsNotExpanded = @"folded" ;
NSString* const constHtmlAttributeNameFavicon = @"icon" ;
NSString* const constHtmlAttributeNameIsBar = @"toolbar" ;
NSString* const constHtmlAttributeNameLastModified = @"modified" ;
NSString* const constHtmlAttributeNameLastVisited = @"visited" ;
NSString* const constHtmlAttributeNameOwner = @"owner" ;

NSString* const constHtmlAttributeValueYes = @"yes" ;
NSString* const constHtmlAttributeValueNo = @"no" ;

static NSDateFormatter* static_htmlDateFormatter = nil ;

@implementation HtmlCodec

@synthesize starker = m_starker ;
@synthesize clientoid = m_clientoid ;

+ (NSDateFormatter*)dateFormatter {
    if (!static_htmlDateFormatter) {
        static_htmlDateFormatter = [[NSDateFormatter alloc] init] ;
        //  Typical HTML date: 2015-11-17T18:34:47-0800
        [static_htmlDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssxx"] ;
    }
    
    return static_htmlDateFormatter ;
}

- initWithExtore:(Extore*)extore {
	self = [super init] ;
	
	if (self != nil) {
		[self setStarker:[extore starker]] ;
		[self setClientoid:[[extore client] clientoid]] ;
	}
	
	return self ;
}

@end
