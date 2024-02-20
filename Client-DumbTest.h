#import <Cocoa/Cocoa.h>


@interface Client : NSObject {

NSString* m_profileName ;
NSString* m_webHostName ;
NSString* m_serverPassword ;

}

@property (copy) NSString* profileName ;
@property (readonly) NSString* webHostName ;
@property (copy) NSString* serverPassword ;


@end
