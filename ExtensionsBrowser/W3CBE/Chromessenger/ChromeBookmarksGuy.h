#import <Cocoa/Cocoa.h>
#import "SSYInterappServerDelegate.h"

@class SSYInterappServer ;

__attribute__((visibility("default"))) @interface ChromeBookmarksGuy : NSObject <SSYInterappServerDelegate> {
	SSYInterappServer* __unsafe_unretained m_server ;
	NSString* m_extoreName ;
    NSString* m_profileName ;
    NSInteger m_extensionVersion ;
	char m_responseHeaderByte ;
	NSData* m_responsePayload ;
}

@property (nonatomic, copy) NSString* extoreName ;
@property (nonatomic, copy) NSString* profileName ;
@property (nonatomic, copy) NSString* extensionName ;
@property (nonatomic, assign) NSInteger extensionVersion ;
@property (assign, nonatomic) char responseHeaderByte ;
@property (retain, nonatomic) NSData* responsePayload ;

+ (ChromeBookmarksGuy*)sharedBookmarksGuy ;

- (BOOL)startServerWithExtoreName:(NSString*)extoreName
                      profileName:(NSString*)profileName ;

- (NSString*)outgoingPortName ;

- (void)clearSemaphore;

@end
