#import "BkmxGlobals.h"

@class Tag;

@interface TalderMapProto : NSObject {
    id m_folder ;
    NSString* m_tag;
    NSNumber* m_polarity ;
}

@property (retain) id folder ;
@property (copy) NSString* tag ;
@property (copy) NSNumber* polarity ;

@end

