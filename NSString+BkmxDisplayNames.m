#import "NSString+BkmxDisplayNames.h"
#import "Extore.h"
#import "NSString+SSYExtraUtils.h"
#import "BkmxBasis+Strings.h"
#import "NSString+LocalizeSSY.h"
#import "BkmxAppDel+Capabilities.h"
#import "NSWorkspace+AppleShoulda.h"
#import "BkmxDoc+Actions.h"
#import "OperationRevert.h"

@implementation NSString (BkmxDisplayNames)

- (NSString*)bkmxAttributeDisplayName {
	NSString* answer ;
    if ([self isEqualToString:constKeyClients]) {
        answer = [NSString stringWithFormat:
                  @"%@ Associations",
                  [[BkmxBasis sharedBasis] labelClient]] ;
    }
    else {
        NSString* string = [NSString stringWithFormat:
                            @"label%@",
                            [self capitalize]] ;
        SEL selector = NSSelectorFromString(string) ;
        BkmxBasis* basis = [BkmxBasis sharedBasis] ;
        if ([basis respondsToSelector:selector]) {
            answer = [basis performSelector:selector] ;
        }
        else {
            answer = nil ;
        }
    }
    
	return answer ;
}

- (NSString*)exformatDisplayName {
	Class extoreClass = [Extore extoreClassForExformat:self] ;
	NSString* displayName = [extoreClass ownerAppDisplayName] ;

	return displayName ;
}

- (NSString*)methodDisplayName {
	NSString* displayValue ;
	if ([self isEqualToString:NSStringFromSelector(@selector(deleteAllContent))]) {
		displayValue = [[BkmxBasis sharedBasis] labelDeleteAllContent] ;
	}
	else if ([self isEqualToString:constMethodPlaceholderImportAll]) {
		displayValue = [[BkmxBasis sharedBasis] labelImportFromAll] ;
	}
	else if ([self isEqualToString:@"import1"]) {
		displayValue = [NSString stringWithFormat:
						@"%@ : %@",
						[[BkmxBasis sharedBasis] labelImport],
						[NSString localizeFormat:
						 @"syncerzTrigngX",
						 [[BkmxBasis sharedBasis] labelClient]]] ;
	}
	else if ([self isEqualToString:NSStringFromSelector(@selector(sort))]) {
		displayValue = [[BkmxBasis sharedBasis] labelSort] ;
	}
	else if ([self isEqualToString:NSStringFromSelector(@selector(findDupes))]) {
		displayValue = [[BkmxBasis sharedBasis] labelFindDupes] ;
	}
	else if ([self isEqualToString:NSStringFromSelector(@selector(verifyAll))]) {
		displayValue = [NSString localize:@"080_verify"] ;
	}
	else if ([self isEqualToString:NSStringFromSelector(@selector(revert))]) {
		displayValue = [NSString localize:@"revert"] ;
	}
	else if ([self isEqualToString:NSStringFromSelector(@selector(saveDocument))]) {
		displayValue = [NSString localizeFormat:
						@"saveThing",
						[NSString localize:@"document"]
						] ;
	}
	else if ([self isEqualToString:constMethodPlaceholderExportAll]) {
		displayValue = [[BkmxBasis sharedBasis] labelExportToAll] ;
	}
	else if ([self isEqualToString:@"export1"]) {
		displayValue = [NSString stringWithFormat:
						@"%@ : %@",
						[[BkmxBasis sharedBasis] labelExport],
						[NSString localizeFormat:
						 @"syncerzTrigngX",
						 [[BkmxBasis sharedBasis] labelClient]]] ;
	}
	else {
		displayValue = nil ;
	}
	
	return displayValue ;
}

- (NSString*)displayNameForVisitor {
	NSString* displayValue ;
	if ([self isEqualToString:constKeyVisitorDefaultDocument]) {
        if ([[BkmxBasis sharedBasis] isShoeboxApp]) {
            displayValue = [[BkmxBasis sharedBasis] labelSettingsPrefsUse] ;
        }
        else {
            displayValue = [[BkmxBasis sharedBasis] labelSettingsDocumentUse] ;
        }
	}
	else if ([self isEqualToString:constKeyVisitorDefaultBrowser]) {
		displayValue = [[BkmxBasis sharedBasis] labelDefaultWebBrowser] ;
	}
	else {
		// Visitor should be the bundle identifier of a 
		// web browser app
		displayValue = [NSWorkspace appNameForBundleIdentifier:self] ;
	}
	
	return displayValue ;
}

- (NSString*)bkmxDisplayNameForValue:(NSString*)value {
    // Most values are displayed as themselves
    NSString* answer = value ;
    
    if ([self isEqualToString:constKeyVisitor]) {
        answer = [value displayNameForVisitor] ;
    }
    
    return answer ;
}

@end
