#import <Foundation/Foundation.h>

@class Stark ;

@interface StarkCruft : NSObject

@property (retain) Stark* stark ;
@property (retain) NSArray <NSString*> * cruftRanges ;

@property (readonly) NSAttributedString* urlAttributedAndHighlighted ;
@property (readonly) NSAttributedString* nameAttributed ;

@end
