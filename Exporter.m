#import "Exporter.h"
#import "NSNumber+Sharype.h"
#import "Starker.h"
#import "NSObject+MoreDescriptions.h"
#import "NSNumber+NoLimit.h"
#import "Client.h"
#import "Macster.h"
#import "BkmxBasis.h"
#import "Stark.h"
#if CONFIGURE_PREFERRED_CATCHYPE_BASED_ON_CLIENT
#import "Extore.h"
#endif

NSString* const constKeySafeLimit = @"safeLimit" ;

@interface Exporter (CoreDataGeneratedPrimitiveAccessors)

- (Client *)primitiveClient;
- (void)setPrimitiveClient:(Client *)value;
- (void)setPrimitivePreferredCatchype:(NSNumber*)value;
- (NSNumber*)primitiveSafeLimit ;
- (void)setPrimitiveSafeLimit:(NSNumber*)value;

@end


@interface Exporter ()

@property (retain) Client* client ;

@end


@implementation Exporter

@dynamic client;
@dynamic safeLimit ;

#if 0
#warning Logging Debug Extras for Exporter
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
 NSLog(@"1207 %s rc=%d", __PRETTY_FUNCTION__, [self retainCount]) ;
 [super awakeFromFetch] ;
 }
 
 - (void)dealloc {
 NSLog(@"%s", __PRETTY_FUNCTION__) ;
 [super dealloc] ;
 }
 - (void)didTurnIntoFault {
 NSLog(@"%s", __PRETTY_FUNCTION__) ;
 [super didTurnIntoFault] ;
 }
 */
#endif

#if CONFIGURE_PREFERRED_CATCHYPE_BASED_ON_CLIENT
- (void)setClient:(Client *)newValue {
    [self postWillSetNewValue:newValue
                       forKey:constKeyClient];
    [self willChangeValueForKey:constKeyClient];
    [self setPrimitiveClient:newValue] ;
    [self didChangeValueForKey:constKeyClient];
    
    [self configurePreferredCatchypeForClient:newValue];
}

- (void)configurePreferredCatchypeForClient:(Client*)client {
    Class extoreClass = [Extore extoreClassForExformat:[[self client] exformat]] ;
    [self configurePreferredCatchypeForExtoreClass:extoreClass];
}

- (void)configurePreferredCatchypeForExtoreClass:(Class)extoreClass {
#warning No-op for testing
    return;
    
    
    if (extoreClass) {
        NSNumber* preferredCatchype = [NSNumber numberWithSharype:[extoreClass fosterSharypeForSharype:SharypeBookmark]];
        [self setPreferredCatchype:preferredCatchype];
    }
}
#endif

- (void)setPreferredCatchype:(NSNumber*)newValue  {
    [self postWillSetNewValue:newValue
                       forKey:constKeyPreferredCatchype] ;
    [self willChangeValueForKey:constKeyPreferredCatchype] ;
    [self setPrimitivePreferredCatchype:newValue] ;
    [self didChangeValueForKey:constKeyPreferredCatchype] ;
    
    [[[self client] macster] postTouchedClient:[self client]
                                      severity:3] ;
}

- (void)setSafeLimit:(NSNumber*)newValue {
    [self postWillSetNewValue:newValue
                       forKey:constKeySafeLimit] ;
    [self willChangeValueForKey:constKeySafeLimit] ;
    [self setPrimitiveSafeLimit:newValue] ;
    [self didChangeValueForKey:constKeySafeLimit] ;
    
    // Added in BookMacster 1.3.19
    [[[self client] macster] postTouchedClient:[self client]
                                      severity:3] ;
}

// Five stupid implementations since compiler does not seem to realize that we
// inherit from exporter when testing for StarCatcher protocol conformance…

-(BOOL)hasBar {
	return [super hasBar] ;
}

-(BOOL)hasMenu {
	return [super hasMenu] ;
}

-(BOOL)hasUnfiled {
	return [super hasUnfiled] ;
}

-(BOOL)hasOhared {
	return [super hasOhared] ;
}

- (Stark*)fosterParentForStark:(Stark*)stark {
    Stark* answer = nil ;
    Sharype defaultParentSharype = [[self preferredCatchype] shortValue] ;
    if ([self canHaveParentSharype:defaultParentSharype
                             stark:stark]) {
        answer = [[[self extore] starker] hartainerOfSharype:defaultParentSharype
                                                    quickly:YES] ;
    }
    
    if (!answer) {
        answer = [[self extore] fosterParentForStark:stark] ;
    }
    
    return answer ;
}

- (BOOL)parentSharype:(Sharype)parentSharype
  canHaveChildSharype:(Sharype)childSharype {
    return [[self extore] parentSharype:parentSharype
                    canHaveChildSharype:childSharype] ;
}

@end
