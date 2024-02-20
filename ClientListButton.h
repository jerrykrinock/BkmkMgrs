#import <Cocoa/Cocoa.h>

@interface ClientListButton : NSButton

+ (CGFloat)buttonMargin ;

+ (NSButton*)buttonAtPoint:(NSPoint)point
                    height:(CGFloat)height
                      type:(NSButtonType)type ;

@end
