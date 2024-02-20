#import <Bkmxwork/Bkmxwork-Swift.h>

#import "BkmxApp.h"
#import "BkmxDoc.h"
#import "BkmxDocWinCon.h"
#import "BkmxDoc.h"
#import "BkmxDocumentController.h"
#import "SSYVectorImages.h"

@implementation BkmxApp

@synthesize beQuiet = m_beQuiet ;

- (id)init {
    self = [super init];
    if (self) {
        [SSYSecureColorTransformer register];
     }
    return self;
}

- (NSInteger)requestUserAttention:(NSRequestUserAttentionType)requestType {
	
	NSInteger identifier ;
	
	if ([self beQuiet]) {
		// Super always returns 0.  So I do the same.
		identifier = 0 ;
	}
	else {
		identifier = [super requestUserAttention:requestType] ;
	}

	return identifier ;
}

// The reason for this method is stated in Note 20131214.
- (NSString*)lastSaveTokenOfFrontDoc {
    NSString* answer = nil ;
    BkmxDoc* bkmxDoc = [[NSDocumentController sharedDocumentController] frontmostDocument] ;
    if ([bkmxDoc respondsToSelector:@selector(lastSaveToken)]) {
        answer = [bkmxDoc lastSaveToken] ;
    }

    return answer ;
}

/*
 Note 20131214.  The reason for this method is stated inSheepSysBkmkMgrs.sdef >
 Bookmarks Management Suite > Classes > application > Properties >
 last save token of front document > description.
 */

#if 0
#warning Accessibility Hacks
- (NSArray *)accessibilityAttributeNames {
    NSArray* supers = [super accessibilityAttributeNames] ;
    return [supers arrayByAddingObject:NSAccessibilitySubroleAttribute] ;
}

- (id)accessibilityAttributeValue:(NSString *)attribute {
    id value = nil ;
    if ([attribute isEqualToString:NSAccessibilitySubroleAttribute]) {
        value = NSAccessibilityUnknownSubrole ;
    }
    else if ([attribute isEqualToString:NSAccessibilityPositionAttribute]) {
        value = [NSValue valueWithPoint:NSZeroPoint] ;
    }
    else if ([attribute isEqualToString:NSAccessibilitySizeAttribute]) {
        value = [NSValue valueWithSize:NSZeroSize] ;
    }
    else if ([attribute isEqualToString:NSAccessibilityDescriptionAttribute]) {
        value = @"Sorry about that" ;
    }
    else {
        value = [super accessibilityAttributeValue:attribute] ;
    }

    return value ;
}
#endif


@end
