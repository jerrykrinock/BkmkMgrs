#import "ClientChoice.h"
#import "Clientoid.h"
#import "NSString+LocalizeSSY.h"
#import "BkmxBasis+Strings.h"
#import "Extore.h"
#import "BkmxAppDel+Capabilities.h"
#import "Client.h"

NSString* const constKeyEncodeClientoid = @"clientoid" ;
NSString* const constKeyEncodeSelector = @"selector" ;
NSString* const constKeyEncodeObject = @"object" ;

@implementation ClientChoice

@synthesize clientoid = m_clientoid ;
@synthesize selector = m_selector ;
@synthesize object = m_object ;
@synthesize isInUse = m_isInUse ;

- (NSString*)displayName {
	NSString* displayName = nil ;

	Clientoid* clientoid = [self clientoid] ;
	if (clientoid) {
		displayName = [clientoid displayName] ;
	}
	else {
		SEL selector = [self selector] ;
		if (selector) {
			NSString* targetString = NSStringFromSelector(selector) ;
			
            if ([targetString isEqualToString:@"chooseClientFromFile"]) {
				displayName = [NSString stringWithFormat:@"%C %@ %@",
							   (unsigned short)0x27a4,
							   [NSString localizeFormat:
								@"choose%0",
								[NSString localize:@"file"]],
							   [[BkmxBasis sharedBasis] labelAdvancedParen]] ;
			}
			else if ([targetString isEqualToString:@"setClientWithNilProfileForWebAppExformat:"]) {
				NSString* newSlashOther = [NSString stringWithFormat:
										   @"%@/%@",
										   [[BkmxBasis sharedBasis] labelNew],
										   [NSString localize:@"other"]] ;
				displayName = [NSString stringWithFormat:
							   @"%@ - %@",
							   [[Extore extoreClassForExformat:[self object]] ownerAppDisplayName],
							   newSlashOther] ;
			}
			else {
				NSLog(@"Internal error 510-5918.  sel=%@", targetString) ;
			}
		}
	}
	
	if (!displayName) {
		displayName = [NSString localizeFormat:@"no%0",
					   [NSString localize:@"selection"]] ;
	}		

	return displayName ;
}

+ (ClientChoice*)clientChoice {
	ClientChoice* clientChoice = [[ClientChoice alloc] init] ;
	return [clientChoice autorelease] ;
}

+ (ClientChoice*)clientChoiceWithClientoid:(Clientoid*)clientoid {
	ClientChoice* clientChoice = [ClientChoice clientChoice] ;
	[clientChoice setClientoid:clientoid] ;
	return clientChoice ;
}

+ (ClientChoice*)clientChoiceInvolvingLooseFile {
	ClientChoice* clientChoice = [ClientChoice clientChoice] ;
	[clientChoice setSelector:@selector(chooseClientFromFile)] ;
	return clientChoice ;
}

+ (ClientChoice*)clientChoiceNewOtherAccountForWebAppExformat:(NSString*)exformat {
	ClientChoice* clientChoice = [ClientChoice clientChoice] ;
	[clientChoice setSelector:@selector(setClientWithNilProfileForWebAppExformat:)] ;
	[clientChoice setObject:exformat] ;
	return clientChoice ;
}

/*
 NSPopupMenuCell apparently uses isEqual: to match to an existing
 menu item when it gets the currently-selected value from the
 model.  Evidence: If this method is not implemented, when
 the user clicks the menu, it adds this value as an additional
 item, (and also it displays its -description instead of using
 the model key path in the Content Values binding, which in our
 case is displayName).  So you temporarily have this funky-looking
 extra item in the menu.  Hypothesis: Cocoa uses pointer equality if
 -isEqual: is not implemented, and doesn't find equality since
 we generate ClientChoice wrappers as needed, on the fly.
 Anyhow, I haven't seen this documented anywhere - I just took a
 wild guess to fix the problem when I saw the extra/funky menu
 item showing up when I clicked the popup menu in my Import and
 and Export Client table views, and this fixed it.
 */
- (BOOL)isEqual:(id)otherChoice {
    // In the next line, the && clause was added in BookMacster 1.15 to
    // support the "Click to Choose…" client choice which has nil clientoid
	if ([[self clientoid] isEqual:[otherChoice clientoid]] && ([otherChoice clientoid] != nil)) {
		return YES ;
	}
	else if (([(ClientChoice*)self selector] != NULL) || ([(ClientChoice*)otherChoice selector] != NULL)) {
		// After a little testing I convinced myself that selectors
		// are system-wide constants.  That is, the value of
		// @selector(anyMethod:someArg:) is the same pointer address
		// at any point in the program.  So, since the selector ivars
		// are generated using the @selector() thing, I can just
		// compare their pointer values directly...
		return ([(ClientChoice*)self selector] == [(ClientChoice*)otherChoice selector]) ;
	}
	
	return NO ;
}

// Documentation says to override -hash if you override -isEqual:
- (NSUInteger)hash {
	if ([self clientoid]) {
		return [[self clientoid] hash] ;
	}
	else if ([(ClientChoice*)self selector] != NULL) {
		return [NSStringFromSelector([(ClientChoice*)self selector]) hash] ;
	}

	return 0 ;
}

- (NSString*)description {
	NSString* answer = [NSString stringWithFormat:@"ClientChoice %p with ", self] ;
	
	if ([self clientoid]) {
		answer = [answer stringByAppendingFormat:@"clientoid %@", [self clientoid]] ;
	}
	else if (self.selector) {
		answer = [answer stringByAppendingFormat:@"selector %@", NSStringFromSelector([self selector])] ;
	}
	else {
		// At one time, I saw this displayed when the user clicks the popup.
		// Doesn't make sense.  I quick-fixed it by mimicking
		// the -displayName output in this case.  Probably this
		// patch is no longer needed.
		answer = [NSString localizeFormat:@"no%0",
					   [NSString localize:@"selection"]] ;
	}
	
	return answer ;
}
	
- (void)dealloc {
	[m_clientoid release] ;
    [m_object release] ;
	
	[super dealloc] ;
}

- (NSComparisonResult)comparePopularity:(ClientChoice*)otherClientChoice {
	NSString* selfExformat = [[self clientoid] exformat] ;
	NSString* otherExformat = [[otherClientChoice clientoid] exformat] ;
	for (NSString* exformat in [[BkmxBasis sharedBasis] supportedExformatsOrderedByPopularity]) {
		if ([exformat isEqualToString:selfExformat]) {
			return NSOrderedDescending ;
		}
		else if ([exformat isEqualToString:otherExformat]) {
			return NSOrderedAscending ;
		}
	}
	
	return NSOrderedSame ;
}

- (BOOL)isLocalThisUserNotInChoices:(NSArray*)choices {
    BOOL answer = NO ;
    if ([choices indexOfObject:self] == NSNotFound) {
        // self is not available as a local, thisUser client.
        // Before declaring it unavailable, we need to make sure that it is
        // such a local, thisUser client.
        if ([[[self clientoid] extoreMedia] isEqualToString:constBkmxExtoreMediaThisUser]) {
            // currentChoice is a thisUser client
            if ([[[self clientoid] extoreClass] ownerAppLocalPath] != nil) {
                // owner app of currentChoice is installed
                answer = YES ;
            }
        }
    }
    
    return answer ;
}

@end
