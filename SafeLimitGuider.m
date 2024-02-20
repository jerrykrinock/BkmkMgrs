#import "SafeLimitGuider.h"
#import "ClientInfoController.h"
#import "ImportPostprocController.h"
#import "SSYHintArrow.h"
#import "ClientListView.h"
#import "Client.h"

#define OVERLIMIT_IXPORT_INDEX_IMPORT -1

static NSMutableSet* static_safeLimitGuiders = nil ;


@interface SafeLimitGuider ()

@property (assign) NSWindowController* windowController ;
@property (assign) NSObject <BkmxDocumentProvider> * documentProvider ;

@end


@implementation SafeLimitGuider

@synthesize windowController = m_windowController ;
@synthesize documentProvider = m_documentProvider ;

- (void)forget {
    [static_safeLimitGuiders removeObject:self] ;
}

- (void)attachHelpArrowToImportLimit {
	NSWindow* sheet = [[[self windowController] window] attachedSheet] ;
    ImportPostprocController* ippc = (ImportPostprocController*)[sheet windowController] ;
    if ([ippc respondsToSelector:@selector(importSafeLimitPopup)]) {
        NSView* controlView = [ippc importSafeLimitPopup] ;
        [[SSYHintArrow class] showHelpArrowRightOfView:controlView] ;
    }
    else {
        /* This can happen if the user commands to show the Import Safe Limit,
         then an Export Safe Limit.  The [sheet windowController] will be a
         ClientInfoController, not an ImportPostprocController, so it does not
         respond to importSafeLimitPopup. */
    }
}

- (void)attachHelpArrowToImportLimitNote:(NSNotification*)note {
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:NSWindowWillBeginSheetNotification
												  object:[[self windowController] window]] ;
    
	[self performSelector:@selector(attachHelpArrowToImportLimit)
			   withObject:nil
			   afterDelay:1.0] ;
}

- (void)attachHelpArrowToExportLimit {
	ClientInfoController* clientInfoController = [[[[self windowController] window] attachedSheet] windowController] ;
	NSButton* exportSafeLimitPopup = [clientInfoController exportSafeLimitPopup] ;
	[[SSYHintArrow class] showHelpArrowRightOfView:exportSafeLimitPopup] ;
}

- (void)attachHelpArrowToExportLimitNote:(NSNotification*)note {
	//  Note:    [note object] == [self window]
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:NSWindowWillBeginSheetNotification
												  object:[[self windowController] window]] ;
	
	[self performSelector:@selector(attachHelpArrowToExportLimit)
			   withObject:nil
			   afterDelay:1.0] ;
}

- (void)timeOutHelpArrow {
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:NSWindowWillBeginSheetNotification
												  object:[[self windowController] window]] ;
    [self forget] ;
}

- (NSControl*)getControlAndSelector_p:(SEL*)selector_p
                     forClientAtIndex:(NSInteger)index {
    NSControl* control = nil ;
	
	if (index == OVERLIMIT_IXPORT_INDEX_IMPORT) {
		control = [[self documentProvider] importPostprocButton] ;
		*selector_p = @selector(attachHelpArrowToImportLimitNote:) ;
	}
	else if ((control = [[[self documentProvider] clientListView] gearButtonForClientAtIndex:index])) {
		*selector_p = @selector(attachHelpArrowToExportLimitNote:) ;
	}
    return control ;
}

#define ARROW_DWELL_TIME 20.0

- (void)guideUserToSafeLimitControlIndex:(NSInteger)index {
	// Revealing the tab view will cause autosizing, so we need
	// to do this before measuring the location for the hint.
	[[self documentProvider] revealTabViewClients] ;
	
	NSControl *control;
    SEL selector;
    control = [self getControlAndSelector_p:&selector
                           forClientAtIndex:index] ;
	
	if (control) {
		[[SSYHintArrow class] showHelpArrowRightOfView:control] ;
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:selector
													 name:NSWindowWillBeginSheetNotification
												   object:[[self windowController] window]] ;
		[self performSelector:@selector(timeOutHelpArrow)
				   withObject:nil
				   afterDelay:ARROW_DWELL_TIME] ;
	}
}

- (IBAction)guideUserToSafeLimitMenuItem:(NSMenuItem*)menuItem {
	Client* exportClient = [menuItem representedObject] ;
	NSInteger index ;
	if (!exportClient) {
		index = OVERLIMIT_IXPORT_INDEX_IMPORT ;
	}
	else {
		index = [[exportClient index] integerValue] ;
	}
	
	[self guideUserToSafeLimitControlIndex:index] ;
}

+ (void)guideUserFromMenuItem:(NSMenuItem*)menuItem
             windowController:(NSWindowController*)windowController
             documentProvider:(NSObject <BkmxDocumentProvider> *)documentProvider {
    SafeLimitGuider* instance = [[SafeLimitGuider alloc] init] ;
    [instance setWindowController:windowController] ;
    [instance setDocumentProvider:documentProvider] ;
    [instance guideUserToSafeLimitMenuItem:menuItem] ;
    
    if (!static_safeLimitGuiders) {
        static_safeLimitGuiders = [[NSMutableSet alloc] init] ;
    }
    [static_safeLimitGuiders addObject:instance] ;
    
    [instance release] ;
}

+ (void)removeWindowController:(NSWindowController*)windowController
              documentProvider:(NSObject <BkmxDocumentProvider> *)documentProvider {
    for (SafeLimitGuider* safeLimitGuider in static_safeLimitGuiders) {
        NSWindowController* aWindowController = [safeLimitGuider windowController] ;
        if (aWindowController == windowController) {
            [safeLimitGuider setWindowController:nil] ;
        }
        NSObject <BkmxDocumentProvider> * aDocumentProvider = [safeLimitGuider documentProvider] ;
        if (aDocumentProvider == documentProvider) {
            [safeLimitGuider setDocumentProvider:nil] ;
        }
    }
}

@end
