#import <Cocoa/Cocoa.h>
#import "Ixporter.h"

@class Client ;

@interface Importer : Ixporter {

}

// I make this readonly here since I should never be setting
// an Ixporter's client.  Only Core Data should set the client
// to fulfill the inverse relationship, when an Ixporter is created
// and set to a Client
@property (readonly, retain) Client* client ;

@end
