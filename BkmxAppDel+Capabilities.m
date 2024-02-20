#import "BkmxAppDel+Capabilities.h"
#import "Extore.h"
#import "StarkTyper.h"
#import "NSNumber+Sharype.h"
#import "NSArray+SortDescriptorsHelp.h"
#import "NSArray+SSYMutations.h"
#import "SSWebBrowsing.h"
#import "NSWorkspace+AppleShoulda.h"
#import "NSNumber+NoLimit.h"
#import "BkmxBasis.h"

// These two constants will appear in documents, so don't change them
NSString* const constKeyVisitorDefaultDocument = @"visitDD" ;
NSString* const constKeyVisitorDefaultBrowser = @"visitDB"  ;


@implementation BkmxAppDel (Capabilities)

- (NSArray*)availableMergeBiasValues {
	NSArray* a = [NSArray arrayWithObjects:
				  [NSNumber numberWithShort:BkmxMergeBiasKeepSource],
				  [NSNumber numberWithShort:BkmxMergeBiasKeepDestin],
				  // The following is commented out since it seems to be useless
				  // and cause havoc.  For example, you can get more than one
				  // item with the same exid.
				  // [NSNumber numberWithShort:BkmxMergeBiasKeepBoth],
				  nil] ;
	return a ;
}

- (NSArray*)availableLimits {
	NSArray* a = [NSArray arrayWithObjects:
				  [NSNumber numberWithInteger:0],
				  [NSNumber numberWithInteger:1],
				  [NSNumber numberWithInteger:2],
				  [NSNumber numberWithInteger:5],
				  [NSNumber numberWithInteger:10],
				  [NSNumber numberWithInteger:20],
				  [NSNumber numberWithInteger:50],
				  [NSNumber numberWithInteger:100],
				  [NSNumber numberWithInteger:200],
				  [NSNumber numberWithInteger:500],
				  [NSNumber numberWithInteger:BKMX_NO_LIMIT],
				  nil] ;
	return a ;
}

- (NSArray*)availableMergeBys {
    NSArray* a = [NSArray arrayWithObjects:
                  [NSNumber numberWithInteger:0],
                  [NSNumber numberWithInteger:1],
                  [NSNumber numberWithInteger:2],
                  nil] ;
    return a ;
}

- (NSArray*)exformatsThatHaveSharype:(Sharype)sharype {
	NSMutableSet* set = [[NSMutableSet alloc] init] ;
	for (NSString* exformat in [[BkmxBasis sharedBasis] supportedLocalAppExformatsIncludeNonClientable:YES]) {
		Class extoreClass = [Extore extoreClassForExformat:exformat] ;
		BOOL doesHave = NO ;
		switch (sharype) {
			case SharypeBar:
				doesHave = ([extoreClass constants_p]->hasBar == YES) ;
				break ;
			case SharypeMenu:
				doesHave = ([extoreClass constants_p]->hasMenu == YES) ;
				break ;
			case SharypeUnfiled:
				doesHave = ([extoreClass constants_p]->hasUnfiled == YES) ;
				break ;
			case SharypeOhared:
				doesHave = ([extoreClass constants_p]->hasOhared == YES) ;
				break ;
		}
		
		if (doesHave) {
			[set addObject:exformat] ;
		}
	}
	
	NSArray* answer = [set allObjects] ;
	[set release] ;
	
	return answer ;
}

- (NSArray*)ownerAppsForWhichICanCreateNewDocumuments {
	NSMutableArray* ownerApps = [[NSMutableArray alloc] init] ;
	for (NSString* exformat in [[BkmxBasis sharedBasis] supportedLocalAppExformatsIncludeNonClientable:YES]) {
		Class extoreClass = [Extore extoreClassForExformat:exformat] ;
		if ([extoreClass constants_p]->canCreateNewDocuments) {
			[ownerApps addObject:exformat] ;
		}
	}
	
	NSArray* answer = [ownerApps copy] ;
	[ownerApps release] ;
	
	return [answer autorelease] ;
}

- (NSArray*)tagDelimiterChoices {
	return [NSArray arrayWithObjects:
			[NSNumber numberWithChar:','],
			[NSNumber numberWithChar:';'],
			[NSNumber numberWithChar:' '],
			nil] ;
}

- (NSArray*)tagDelimiterChoicesDoc {
	// Because tagDelimiter is a unichar, which is unsigned short...
	NSArray* choices = [[self tagDelimiterChoices] arrayByAddingObject:[NSNumber numberWithUnsignedShort:YOUR_DEFAULT_TAG_DELIMITER]] ;
	return choices ;
}

- (NSArray*)tagReplacementChoices {
	return [NSArray arrayWithObjects:
			[NSNumber numberWithInteger:95],    // underscore
			[NSNumber numberWithInteger:45],    // hyphen, dash, minus
			[NSNumber numberWithInteger:8212],  // em dash
			[NSNumber numberWithInteger:160],   // nonbreaking space
			nil] ;
}

// <kludge>
// In PrefsWindow, tagDelimiterDefault is bound through the following
// accessors instead of directly to user defaults, so that, when it is changed, 
// tagDelimiterChoicesDoc.characterDisplayName will be updated.
- (NSNumber *)tagDelimiterDefault {
    return [[NSUserDefaults standardUserDefaults] objectForKey:constKeyTagDelimiterDefault] ;
}

- (void)setTagDelimiterDefault:(NSNumber *)value {
	[[NSUserDefaults standardUserDefaults] setObject:value
											  forKey:constKeyTagDelimiterDefault] ;
}

+ (NSSet*)keyPathsForValuesAffectingTagDelimiterChoicesDoc {
	return [NSSet setWithObject:constKeyTagDelimiterDefault] ;
}
// </kludge>

- (NSArray*)sortableChoicesDocument {
	NSArray* choices = [NSArray arrayWithObjects:
						[NSNumber numberWithShort:BkmxSortableYes],
						[NSNumber numberWithShort:BkmxSortableNo],
						[NSNumber numberWithShort:BkmxSortableAsParent],
						nil] ;	
	return choices ;
}

- (NSArray*)sortableChoicesStark {
	NSArray* choices = [[self sortableChoicesDocument] arrayByAddingObject:[NSNumber numberWithShort:BkmxSortableAsDefault]] ;
	return choices ;
}

- (NSArray*)sharypeCoarseChoicesStark {
	NSArray* choices = [NSArray arrayWithObjects:
						[NSNumber numberWithSharype:SharypeCoarseLeaf],
						[NSNumber numberWithSharype:SharypeCoarseSoftainer],
						[NSNumber numberWithSharype:SharypeCoarseHartainer],
						[NSNumber numberWithSharype:SharypeCoarseNotch],
						nil] ;	
	return choices ;
}

- (NSArray*)verifierDispositionChoicesStark {
	NSArray* choices = [NSArray arrayWithObjects:
						[NSNumber numberWithInteger:BkmxFixDispoToBeDetermined],
						[NSNumber numberWithInteger:BkmxFixDispoLeaveAsIs],
						[NSNumber numberWithInteger:BkmxFixDispoDoUpdate],
                        [NSNumber numberWithInteger:BkmxFixDispoDoUpgradeInsecure],
						[NSNumber numberWithInteger:BkmxFixDispoLeaveBroken],
						nil] ;	
	return choices ;
}

- (NSArray*)verifierSubtype302ChoicesStark {
	NSArray* choices = [NSArray arrayWithObjects:
						[NSNumber numberWithInteger:BkmxHttp302Agree],
						[NSNumber numberWithInteger:BkmxHttp302Unsure],
						[NSNumber numberWithInteger:BkmxHttp302Disagree],
						[NSNumber numberWithInteger:BkmxHttp302NotApplicable],
						nil] ;	
	return choices ;
}

- (NSArray*)visitorChoicesDocument {
	NSArray* bundleIdentifiers = [[BkmxBasis sharedBasis] supportedLocalAppBundleIdentifiers] ;
	NSMutableArray* choices = [[NSMutableArray alloc] initWithCapacity:8] ;
	for (NSString* bundleIdentifier in bundleIdentifiers) {
		if ([NSWorkspace appNameForBundleIdentifier:bundleIdentifier] != nil ) {
			[choices addObject:bundleIdentifier] ;
		}
	}

	[choices addObject:constKeyVisitorDefaultBrowser] ;

	NSArray* answer = [NSArray arrayWithArray:choices] ;
	[choices release] ;
	
	return answer ;
}

- (NSArray*)visitorChoicesStark {
	NSArray* choices = [self visitorChoicesDocument] ;
	choices = [choices arrayByAddingObject:constKeyVisitorDefaultDocument] ;
	return choices ;
}

- (NSArray*)starkChoicesForKey:(NSString*)key {
	NSString* methodName = [key stringByAppendingString:@"ChoicesStark"] ;
	SEL selector = NSSelectorFromString(methodName) ;
	if ([self respondsToSelector:selector]) {
		return [self performSelector:selector] ;
	}
	else {
		return nil ;
	}
}

- (NSArray*)booleanChoices {
	return [NSArray arrayWithObjects:
			[NSNumber numberWithBool:YES],
			[NSNumber numberWithBool:NO],
			nil] ;
}

@end
