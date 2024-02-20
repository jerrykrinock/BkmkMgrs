#import "ClientListButton.h"

@implementation ClientListButton

+ (CGFloat)buttonMargin {
    return 1.0 ;
}

+ (NSButton*)buttonAtPoint:(NSPoint)point
                    height:(CGFloat)height
                      type:(NSButtonType)type {
    CGFloat margin = [self buttonMargin] ;
    CGFloat buttonDiameter = height - 2 * margin ;
    NSRect frame = NSMakeRect(
                              point.x + margin,
                              point.y + margin,
                              buttonDiameter,
                              buttonDiameter
                              ) ;
    NSButton* button = [[NSButton alloc] initWithFrame:frame] ;
    [button setButtonType:type] ;
    [button setBezelStyle:NSBezelStyleRegularSquare] ;
    [[button cell] setImageScaling:NSImageScaleProportionallyDown] ;
    [button setTitle:@""] ;
    [button setImagePosition:NSImageOnly] ;
    
    [button autorelease] ;
    return button ;
}

@end
