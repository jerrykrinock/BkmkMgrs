#import "Bkmxwork/Bkmxwork-Swift.h"
#import "TalderMap.h"
#import "TalderMapProto.h"
#import "Stark.h"

NSString* const constKeyFolderId = @"folderId" ;

@implementation TalderMap

@dynamic folderId ;
@dynamic tag ;
@dynamic index ;
@dynamic ixporter ;

- (void)setAttributesFromProto:(TalderMapProto*)proto {
    [self setTag:[proto tag]] ;
    [self setFolderId:[[proto folder] starkid]] ;
}

@end
