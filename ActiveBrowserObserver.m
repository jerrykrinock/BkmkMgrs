#import "ActiveBrowserObserver.h"
#import "SSWebBrowsing+Bkmx.h"
#import "Extore.h"
#import "SSYShortcutActuator.h"

static ActiveBrowserObserver* sharedObserver = nil ;


@interface ActiveBrowserObserver ()

@property (assign) BOOL isObserving ;

@end


@implementation ActiveBrowserObserver

+ (ActiveBrowserObserver*)sharedObserver {
	@synchronized(self) {
        if (!sharedObserver) {
            sharedObserver = [[self alloc] init] ;
        }
    }
	
	// No autorelease.  This sticks around forever.
    return sharedObserver ;
}

@synthesize isObserving = m_isObserving ;

- (void)startObserving:(NSNotification*)note {
	[[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
														   selector:@selector(appActivateNote:)
															   name:NSWorkspaceDidActivateApplicationNotification
															 object:[NSWorkspace sharedWorkspace]] ;
	[self setIsObserving:YES] ;
}

- (void)startObserving {
    [self startObserving:nil] ;
}

- (void)stopObserving:(NSNotification*)note {
	[[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self
																  name:NSWorkspaceDidActivateApplicationNotification
																object:[NSWorkspace sharedWorkspace]] ;
	[self setIsObserving:NO] ;
}

- (void)stopObserving {
    [self stopObserving:nil] ;
}

- (void)processActiveRunningApplication:(NSRunningApplication *)runningApp {
    NSString* bundleIdentifier = [runningApp bundleIdentifier] ;
    Class extoreClass ;
    [SSWebBrowsing getFromBundleIdentifier:bundleIdentifier
                             extoreClass_p:&extoreClass
                                exformat_p:NULL] ;

    BOOL newlyActivatedAppIsAPeekableWebBrowser = NO ;
    if (extoreClass) {
        if ([extoreClass peekPageIdiom] != BkmxGrabPageIdiomNone) {
            newlyActivatedAppIsAPeekableWebBrowser = YES ;
        }
    }

    if (newlyActivatedAppIsAPeekableWebBrowser) {
        [[SSYShortcutActuator sharedActuator] enableAllShortcuts] ;
    }
    else {
        [[SSYShortcutActuator sharedActuator] disableAllShortcuts] ;
    }
}

- (void)appActivateNote:(NSNotification*)note {
	NSRunningApplication* app = [[note userInfo] objectForKey:NSWorkspaceApplicationKey] ;
    [self processActiveRunningApplication:app];
}

- (void)observeNow {
    for (NSRunningApplication* app in[[NSWorkspace sharedWorkspace] runningApplications]) {
        if ([app isActive]) {
            [self processActiveRunningApplication:app];
            break;
        }
    }
}

- (id)init {
	self = [super init] ;
	
	if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(startObserving:)
													 name:SSYShortcutActuatorDidNonemptyNotification
												   object:nil] ;
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(stopObserving:)
													 name:SSYShortcutActuatorDidEmptyNotification
												   object:nil] ;
	}
	
	return self ;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self] ;
	
	[super dealloc] ;
}


@end
