#import "Importer.h"
#import "Client.h"
#import "Macster.h"
#import "BkmxBasis.h"

@interface Importer (CoreDataGeneratedPrimitiveAccessors)

- (Client *)primitiveClient;
- (void)setPrimitiveClient:(Client *)value;

@end


@interface Importer ()

@property (retain) Client* client ;

@end


@implementation Importer

@dynamic client;

#if 0
#warning Logging Debug Extras for Importer
/*- (id)retain {
 id x = [super retain] ;
 NSLog(@"113033: After retain, rc=%d", [self retainCount]) ;
 return x ;
 }
 - (id)autorelease {
 id x = [super autorelease] ;
 NSLog(@"111008: After autorelease, rc=%d", [self retainCount]) ;
 return x ;
 }
 - (oneway void)release {
 NSInteger rc = [self retainCount] ;
 [super release] ;
 NSLog(@"113300: After release, rc=%d", rc-1) ;
 return ;
 }
- (void)awakeFromFetch {
	NSLog(@"1627 %s rc=%d", __PRETTY_FUNCTION__, [self retainCount]) ;
	[super awakeFromFetch] ;
}
- (void)dealloc {
 NSLog(@"%s rc=%d", __PRETTY_FUNCTION__) ;
 [super dealloc] ;
 }
- (void)didTurnIntoFault {
	NSLog(@"%s rc=%d", __PRETTY_FUNCTION__) ;
	[super didTurnIntoFault] ;
}
 */
#endif

#if 0
 -------- NOT USED --------------
- (Client *)client {
    id tmpObject;
    
    [self willAccessValueForKey:@"client"];
    tmpObject = [self primitiveClient];
    [self didAccessValueForKey:@"client"];
    
    return tmpObject;
}

- (void)setClient:(Client *)value 
{
    [self willChangeValueForKey:@"client"];
    [self setPrimitiveClient:value];
    [self didChangeValueForKey:@"client"];
}
#endif


@end
