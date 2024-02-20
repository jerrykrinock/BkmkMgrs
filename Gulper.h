#import <Cocoa/Cocoa.h>

@protocol GulperDelegate ;
@protocol Startainer ;
@protocol StarCatcher ;
@protocol StarkReplicator ;


@interface Gulper : NSObject {
	NSObject <GulperDelegate> * m_delegate ;
}

- (id)initWithDelegate:(NSObject <GulperDelegate> *)delegate ;

- (BOOL)gulpStartainer:(NSObject <Startainer, StarCatcher, StarkReplicator> *)destin
				  info:(NSMutableDictionary*)info 
			   error_p:(NSError**)error_p ;

+ (NSArray*)sortDescriptorsForGulping ;
+ (NSArray*)sortDescriptorsForMergingHartainers ;

@end
