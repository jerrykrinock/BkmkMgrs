#import "BkmxLazyView.h"
#import "SSYAlert.h"
#import "BkmxDocViewController.h"


NSString* BkmxLazyViewErrorDomain = @"BkmxLazyViewErrorDomain" ;


@implementation NSTabViewItem (SSYLazyPayload)

- (BOOL)isViewPayloaded {
    NSView* view = [self view] ;
    BOOL answer = YES ;
    if ([view respondsToSelector:@selector(isPayloaded)]) {
        if (![(BkmxLazyView*)view isPayloaded]) {
            answer = NO ;
        }
    }
    
    return answer ;
}


@end


NSString* BkmxLazyViewWillLoadPayloadNotification = @"BkmxLazyViewWillLoadPayloadNotification" ;
NSString* BkmxLazyViewDidLoadPayloadNotification = @"BkmxLazyViewDidLoadPayloadNotification" ;


@interface BkmxLazyView ()

@property (retain) NSArray* topLevelObjects ;

@end

@implementation BkmxLazyView

@synthesize isPayloaded = m_isPayloaded ;
@synthesize topLevelObjects = m_topLevelObjects ;

#if 0
- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame] ;
    if (self) {
        // Initialization code here.
    }
    
    return self ;
}
#endif

+ (Class)lazyViewControllerClass {
    return [NSViewController class] ;
}

+ (NSString*)lazyNibName {
    return @"Internal Error 939-7834" ;
}

- (void)load {
    // Only do this once
    if ([self isPayloaded]) {
		return ;
	}

    [[NSNotificationCenter defaultCenter] postNotificationName:BkmxLazyViewWillLoadPayloadNotification
                                                        object:[self window]
                                                      userInfo:nil] ;

    NSBundle* bundle = [NSBundle mainBundle] ;
    NSInteger errorCode = 0 ;
    NSString* errorDesc = nil ;
    BOOL ok ;

    NSArray* topLevelObjects = nil ;

    Class controllerClass = [[self class] lazyViewControllerClass] ;
    NSString* nibName = [[self class] lazyNibName] ;
    NSViewController* viewController = [[controllerClass alloc] initWithNibName:nibName
                                                                         bundle:nil] ;
    [(BkmxDocViewController*)viewController setWindowController:(BkmxDocWinCon*)[[self window] windowController]] ;
    [(BkmxDocViewController*)viewController defensiveProgramming] ;

    BkmxDocWinCon* windowController = (BkmxDocWinCon*)[[self window] windowController] ;
    if ([windowController conformsToProtocol:@protocol(BkmxLazyViewWindowController)]) {
        [windowController setAViewController:viewController] ;
        
        ok = [bundle loadNibNamed:nibName
                            owner:viewController
                  topLevelObjects:&topLevelObjects] ;
        if (ok) {
            // See details of doc for -loadNibNamed:owner:topLevelObjects:,
            // https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/LoadingResources/CocoaNibs/CocoaNibs.html#//apple_ref/doc/uid/10000051i-CH4-SW6
            [self setTopLevelObjects:topLevelObjects] ;
        }
        else {
            errorCode = SSY_LAZY_VIEW_ERROR_CODE_COULD_NOT_LOAD_NIB ;
            errorDesc = [NSString stringWithFormat:
                         @"Could not load %@.nib",
                         nibName] ;
        }
        
        NSView* payloadView = nil ;
        if (ok) {
            // Remove any placeholder subviews.
            // In BookMacster et al,  there are two such placeholders…
            // (0) An SSYSizeFixxerSubview.
            // (1) A text field with a string that says "Loading <Something>…"
            NSInteger nSubviews = [[self subviews] count] ;
            for (NSInteger i=(nSubviews-1); i>=0; i--) {
                NSView* subview = [[self subviews] objectAtIndex:i] ;
                [subview removeFromSuperviewWithoutNeedingDisplay] ;
            }
            
            // Ferret out the new top-level view
            for (NSObject* object in topLevelObjects) {
                if ([object isKindOfClass:[NSView class]]) {
                    payloadView = (NSView*)object ;
                    break ;
                }
            }
        }
        
        if (!payloadView) {
            ok = NO ;
            errorCode = SSY_LAZY_VIEW_ERROR_CODE_NO_PAYLOAD ;
            errorDesc = [NSString stringWithFormat:
                         @"No payload in %@.nib",
                         nibName] ;
        }
        
        if (ok) {
            // Resize the incoming new view to match the current size of
            // the placeholder view
            NSRect frame = NSMakeRect(
                                      [payloadView frame].origin.x,
                                      [payloadView frame].origin.y,
                                      [self frame].size.width,
                                      [self frame].size.height
                                      ) ;
            [payloadView setFrame:frame] ;
            
            // Place the incoming new view.
            [self addSubview:payloadView] ;
            [self display] ;
            
            // So we don't do this again…
            [self setIsPayloaded:YES] ;
            
            /*
             Note that we setIsPayloaded:YES *before* posting
             BkmxLazyViewDidLoadPayloadNotification.  Otherwise,
             -[BkmxDocWinCon tabDidPayloadNote:] is invoked
             which invokes -[BkmxDocWinCon resizeWindowAndConstrainSizeForActiveTabViewItem]
             which invokes -[BkmxDocWinCon resizeWindowForTabViewItem:size:]
             That last method will find [tabViewItem isViewPayloaded] == NO and
             thus not resize the window
             */
            [[NSNotificationCenter defaultCenter] postNotificationName:BkmxLazyViewDidLoadPayloadNotification
                                                                object:[self window]
                                                              userInfo:nil] ;
        }
        else {
            /* One day, something weird happened.  Upon launching Synkmark,
             the autosaved tab in the BkmxDoc window of Synkmark was
             'settings'.  It caused this error because Synkmark.bmco does not
             have a 'settings' tab. */
            NSString* suggestion = @"Reinstall this app, or maybe trash preferences." ;
            NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                      errorDesc, NSLocalizedDescriptionKey,
                                      suggestion, NSLocalizedRecoverySuggestionErrorKey,
                                      nil] ;
            NSError* error = [NSError errorWithDomain:BkmxLazyViewErrorDomain
                                                 code:errorCode
                                             userInfo:userInfo] ;
            [SSYAlert alertError:error] ;
        }
    }
    else {
        NSLog(@"Internal Error 101-3849 loading %@", [[self class] lazyNibName]) ;
    }
    [viewController release] ;
}

- (void)viewDidMoveToWindow {
    [self load] ;
}

- (void)dealloc {
    [m_topLevelObjects release] ;
    
    [super dealloc] ;
}

@end
