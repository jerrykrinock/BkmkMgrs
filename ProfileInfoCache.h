#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileInfoCache : NSObject {
    NSMutableDictionary* m_displayProfileNames ;
    BOOL m_shouldSuffix ;
    NSTimeInterval m_lastUpdate ;
}

@property (retain) NSMutableDictionary* displayProfileNames ;
@property (assign) BOOL shouldSuffix ;
@property (assign) NSTimeInterval lastUpdate ;

@end

NS_ASSUME_NONNULL_END
