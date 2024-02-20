#import "ExtoreHttp.h"


@interface ExtoreDeliPin : ExtoreHttp {

}

- (BOOL)givesHttpError429WhenAllPostsHaveBeenSent ;

- (BOOL)itemNotFoundIndicatedByData:(NSData*)data ;

/*!
 @brief    Returns a format string containing a single %d format specifier
 which will be replaced by the index of the first bookmark desired

 @details  This method was added in BookMacster 1.11.9, to support the
 new "tag_separator=comma" required by Delicious.  I presume that it
 is not required by Pinboard, hence this method
*/
- (NSString*)postsAllFormatString ;

@end
