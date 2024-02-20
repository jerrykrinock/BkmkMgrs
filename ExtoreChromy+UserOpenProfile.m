#import "ExtoreChromy+UserOpenProfile.h"
#import "AgentPerformer.h"
#import "NSString+LocalizeSSY.h"
#import "BkmxDoc.h"
#import "SSYOperation.h"
#import "SSYProgressView.h"
#import "NSError+InfoAccess.h"
#import "Operation_Common.h"
#import "Client.h"
#import "Clientoid.h"
#import "BkmxBasis.h"
#import "NSString+BkmxDisplayNames.h"
#import "OperationQuill.h"
#import "NSError+MyDomain.h"
#import "BkmxAppDel+Actions.h"
#import "BkmxDocWinCon.h"
#import "NSBundle+MainApp.h"

@implementation ExtoreChromy (UserOpenProfile)

- (void)retryQuillForOperation:(SSYOperation*)operation {
    // Change styles
    self.ixportStyle = 2;

    // Re-invoke the method which ultimately brought us here.
    // If the user *did* just load the required profile in Chrome as
    // requested, the following method will conclude successfully
    // without involving us this time.
    [operation quillBrowser] ;
}

- (void)cancelUserOpenProfileForOperation:(SSYOperation*)operation {
    NSString* desc = [NSString localize:@"cancelledOperation"] ;
    BkmxDoc* bkmxDoc = [[operation info] objectForKey:constKeyDocument] ;
    [[bkmxDoc progressView] clearAll] ;
    
    NSError* error = SSYMakeError(constBkmxErrorBrowserRunningQuitCancelled, desc) ;
    [self setError:error] ;
    [operation setError:error] ;
    
    [operation finishQuill] ;
}

- (NSString*)verbForNSAlertReturn:(NSInteger)value {
    NSString* verb ;
    switch (value) {
		case NSAlertFirstButtonReturn:
            verb = @"Retry" ;
            break ;
        case NSAlertSecondButtonReturn:;
            verb = @"Leave unsynced" ;
            break ;
        default:
            NSLog(@"Internal Error 624-8934") ;
            verb = @"???" ;
            break ;
    }
    
    return verb ;
}

- (NSString*)verbForCFAlertReturn:(NSInteger)value {
    NSInteger translatedValue ;
    switch (value) {
        case kCFUserNotificationDefaultResponse:
            translatedValue = NSAlertFirstButtonReturn ;
            break ;
        case kCFUserNotificationAlternateResponse:
            translatedValue = NSAlertSecondButtonReturn ;
            break ;
        default:
            NSLog(@"Internal Error 624-9382") ;
            translatedValue = NSAlertThirdButtonReturn ;
    }
    
    return [self verbForNSAlertReturn:translatedValue] ;
}

- (void)logUserClickedVerb:(NSString*)verb {
    [[BkmxBasis sharedBasis] logFormat:
     @"User clicked \"%@\" for %@",
     verb,
     self.clientoid.displayName] ;
}


- (void)logUserClicked_NS:(NSInteger)clicked {
    [self logUserClickedVerb:[self verbForNSAlertReturn:clicked]] ;
}

- (void)logUserClicked_CF:(NSInteger)clicked {
    [self logUserClickedVerb:[self verbForCFAlertReturn:clicked]] ;
}


- (void)didEndAskUserOpenProfileSheet:(NSWindow*)sheet
                           returnCode:(NSInteger)returnCode
                            operation:(SSYOperation*)operation {
	// Balance the retains for these in askUserOpenProfileForOperation:
	[self autorelease] ;
	[operation autorelease] ;
    
	[sheet orderOut:self] ;
	
    [self logUserClicked_NS:returnCode] ;

    switch (returnCode) {
		case NSAlertFirstButtonReturn:
            [self retryQuillForOperation:operation] ;
			break ;
		case NSAlertSecondButtonReturn:;
			[self cancelUserOpenProfileForOperation:operation] ;
            [operation finishQuill] ;
			break ;
	}    
}

- (NSString*)alertTitle {
	return constAppNameBkmxAgent;
}

- (CFURLRef)iconUrl {
	NSString* appName = constAppNameBkmxAgent;
	// appName will be "BkmxAgent"
	NSBundle* bundle = [NSBundle mainAppBundle] ;
	NSString* iconPath = [bundle pathForImageResource:appName] ;
	CFURLRef iconUrl = NULL ;
	if (iconPath) {
		iconUrl = (CFURLRef)[NSURL fileURLWithPath:iconPath] ;
	}
	else {
		NSLog(@"Internal Error 235-2724 No resource for appName=%@, bundlePath=%@, iconPath=%@", appName, [bundle bundlePath], iconPath) ;
	}
	
	return iconUrl ;
}

- (void)askUserOpenProfileForOperation:(SSYOperation*)operation {
	[self setError:nil] ;
    
    NSString* defaultOption = [self verbForNSAlertReturn:NSAlertFirstButtonReturn]  ;
    NSString* alternateOption = [self verbForNSAlertReturn:NSAlertSecondButtonReturn] ;
    NSString* profileDisplayName = [[self class] displayProfileNameForProfileName:self.clientoid.profileName] ;
	NSString* msg = [NSString stringWithFormat:
                     @"Our %@ extension is not responding in profile \"%@\".  A response is now required to keep those bookmarks in sync.\n\n"
                     @"To fix this, try to quit %@, then return here and click \"%@\"",
                     [self ownerAppDisplayName],
                     profileDisplayName,
                     [self ownerAppDisplayName],
                     defaultOption] ;
    
    if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
        NSMutableDictionary* info = [operation info] ;
        BkmxDoc* bkmxDoc = [[[self client] macster] bkmxDoc] ;
        if (!bkmxDoc) {
            bkmxDoc = [info objectForKey:constKeyDocument] ;
        }
        NSWindow* window = [(NSWindowController*)[bkmxDoc bkmxDocWinCon] window] ;
        
        SSYAlert* alert = [SSYAlert alert] ;
        [alert setSmallText:msg] ;
        [alert setButton1Title:defaultOption] ;
        [alert setButton2Title:alternateOption] ;
        
        [alert setIconStyle:SSYAlertIconInformational] ;
        
        // Bug fix added in BookMacster 1.11, to eliminate crashes which could occur
        // if, for example, Firefox failed to respond because it was waiting for user
        // to dismiss a print dialog, and user clicked 'Cancel' in the following sheet.
        [self retain] ;
        [operation retain] ;
        // The above two are released in didEndAskUserOpenProfileSheet:returnCode:operation:
        
        [alert runModalSheetOnWindow:window
                          resizeable:NO
                       modalDelegate:self
                      didEndSelector:@selector(didEndAskUserOpenProfileSheet:returnCode:operation:)
                         contextInfo:operation] ;

    }
    else {
		CFOptionFlags response ;
		// The following returns whether it "cancelled OK".
		// I'm not sure that means.  But I don't need it now, anyhow.
		CFUserNotificationDisplayAlert (
										0,  // no timeout
										0,
										[self iconUrl],
										NULL,
										NULL,
										(CFStringRef)[self alertTitle],
										(CFStringRef)msg,
										(CFStringRef)defaultOption,
										(CFStringRef)alternateOption,
										NULL,
										&response) ;
		// Bitwise & with 0x3 per the fine print in document
		//     CFUserNotification > Response Codes > Discussion
		response = response & 0x3 ;
        [self logUserClicked_CF:response] ;

		if (response == kCFUserNotificationDefaultResponse) {
            // User clicked: Done
            [self retryQuillForOperation:operation] ;
		}
        else {
            // User clicked: @"Leave unsynced"
			[self cancelUserOpenProfileForOperation:operation] ;
            [operation finishQuill] ;
        }
    }
}

@end
