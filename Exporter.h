#import <Cocoa/Cocoa.h>
#import "Ixporter.h"
#import "StarCatcher.h"

extern NSString* const constKeySafeLimit ;

@class Client ;

@interface Exporter : Ixporter <StarCatcher> {

}

// I make this readonly here since I should never be setting
// an Ixporter's client.  Only Core Data should set the client
// to fulfill the inverse relationship, when an Ixporter is created
// and set to a Client
@property (readonly, retain) Client* client ;

@property (retain) NSNumber* safeLimit ;

- (Stark*)fosterParentForStark:(Stark*)stark ;

#if CONFIGURE_PREFERRED_CATCHYPE_BASED_ON_CLIENT
- (void)configurePreferredCatchypeForExtoreClass:(Class)extoreClass;
#endif

@end
