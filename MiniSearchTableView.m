#import "MiniSearchTableView.h"

@implementation MiniSearchTableView

- (void)keyDown:(NSEvent *)event {
    NSString* s = [event charactersIgnoringModifiers] ;
	unichar keyChar = 0 ;
	BOOL didDo = NO ;
	if ([s length] == 1) {
		keyChar = [s characterAtIndex:0] ;
		if (
            (keyChar == NSCarriageReturnCharacter)
            ||
            (keyChar == NSEnterCharacter)
            ||
            (keyChar == ' ')
            ) {
            NSNumber* object = [NSNumber numberWithInteger:[self selectedRow]] ;
            [[self target] performSelector:[self action]
                                withObject:object] ;
            didDo = YES ;
        }
    }

    if (!didDo) {
        [super keyDown:event];
    }
}

- (BOOL)becomeFirstResponder {
    if ([self numberOfRows] > 0) {
        [self selectRowIndexes:[NSIndexSet indexSetWithIndex:0]
          byExtendingSelection:NO] ;
    }
    
    return YES ;
}

@end
