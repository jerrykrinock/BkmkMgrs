#import "StarkCruft.h"
#import "Stark.h"
#import "BkmxAppDel.h"

@implementation StarkCruft

- (void)dealloc {
    [_stark release] ;
    [_cruftRanges release] ;
    
    [super dealloc] ;
}

+ (NSDictionary*)basicAttributes {
    return @{
             NSParagraphStyleAttributeName : [NSParagraphStyle defaultParagraphStyle],
             NSFontAttributeName : [(BkmxAppDel*)[NSApp delegate] fontTable]
             } ;
}

- (NSAttributedString*)nameAttributed {
    NSAttributedString* answer = nil ;
    if (self.stark) {
        answer = [[NSAttributedString alloc] initWithString:self.stark.nameNoNil
                                                 attributes:[[self class] basicAttributes]] ;
        [answer autorelease] ;
    }
    
    return answer ;
}

- (NSAttributedString*)urlAttributedAndHighlighted {
    NSAttributedString* answer = nil ;
    if (self.stark.url) {
        NSMutableAttributedString* as = [[NSMutableAttributedString alloc] initWithString:self.stark.url] ;

        [as setAttributes:[[self class] basicAttributes]
                    range:NSMakeRange(0, as.length)] ;

        NSDictionary* pink = @{
                               /* This background color must be bright enough so
                                that black text is legible (which will occur
                                when the row is not selected in the table) but
                                dark enough so that white text is legible (which
                                will occur when the row is ot selected in the
                                table). */
                               NSBackgroundColorAttributeName : [NSColor colorWithRed:1.0
                                                                                green:0.75
                                                                                 blue:0.75
                                                                                alpha:1.0],
                               } ;
        for (NSString* rangeString in self.cruftRanges) {
            [as addAttributes:pink
                        range:NSRangeFromString(rangeString)] ;
        }

        answer = [as copy] ;
        [answer autorelease] ;
        [as release] ;
    }

    return answer ;
}

@end
