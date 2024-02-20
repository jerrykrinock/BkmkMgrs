#import "ExtoreLocalAtomic.h"

// Dictionary keys used in BkmxFileProperties dictionaries only in this subclass
// There are more, common keys in Extore.h.
extern NSString* const constKeyPlistExformat ;     //  NSNumber*      Safari only      NSPropertyListFormat: 100=xml, 200=binary
extern NSString* const constKeyProxyCollections ;  //  NSArray*       Safari only
extern NSString* const constKeyRootAttributes ;    //  NSDictionary*  Safari, iCab

@class Stark ;

@interface ExtoreLocalPlist : ExtoreLocalAtomic {
}


/*!
 @brief

 @details  Must be implemented by subclasses.  Default implementation
 returns NULL
 
 @result   The reformatter
*/
- (SEL)reformatStarkToExtore ;

- (NSDictionary*)extoreTreeError_p:(NSError**)error_p;

@end


