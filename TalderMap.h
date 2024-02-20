#import <Cocoa/Cocoa.h>
#import "SSYManagedObject.h"

@class TalderMapProto ;
@class Ixporter ;

extern NSString* const constKeyFolderId ;

@interface TalderMap : SSYManagedObject 

@property (copy) NSString* folderId ;
@property (copy) NSString* tag ;
@property (copy) NSNumber* index ;
@property (retain) Ixporter* ixporter ;

- (void)setAttributesFromProto:(TalderMapProto*)proto ;

@end
