#import "Stark+Attributability.h"
#import "BkmxDoc.h"
#import "Bookshig.h"

@implementation Stark (Attributability)

+ (NSSet*)genericAttributes {
	return [NSSet setWithObjects:
			constKeyAddDate,
			constKeyComments,
			constKeyFavicon,
			constKeyFaviconUrl,
			constKeyIsAllowedDupe,
			constKeyIsAutoTab,
			constKeyIsExpanded,
			constKeyDontVerify,
			constKeyIsShared,
			constKeyLastChengDate,
			constKeyLastModifiedDate,
			constKeyLastVisitedDate,
			constKeyName,
			constKeyRating,
			constKeyRssArticles,
			constKeyShortcut,
			constKeySortable,
			constKeyTags,
			constKeyUrl,
			constKeyVerifierCode,
			constKeyVerifierDetails,
			constKeyVerifierDisposition,
			constKeyVerifierLastDate,
			constKeyVisitCount,
			constKeyVisitor,
			nil] ;
}

+ (NSSet*)uneditableAttributes {
	return [NSSet setWithObjects:
			constKeyAddDate,
			constKeyLastChengDate,
			constKeyLastModifiedDate,
			constKeyLastVisitedDate,
			constKeyVerifierAdviceOneLiner,
			constKeyVerifierAdviceMultiLiner,
			constKeyVerifierCode,
			constKeyVerifierDetails,
			constKeyVerifierDisposition,
			constKeyVerifierLastDate,
			nil] ;
}

+ (NSArray*)thirdAttributePriority {
	return [NSArray arrayWithObjects:
			constKeyTags,
			constKeyVisitCount,  // constKeyVisitCountString
			constKeyLastVisitedDate,
			constKeyIsShared,
			constKeyComments,
			constKeyShortcut,
			nil] ;
}

+ (BOOL)isEditableAttribute:(NSString*)attribute {
	return ([[self uneditableAttributes] member:attribute] == nil) ;
}

- (BOOL)canEditName {
	Sharype sharypeValue = [self sharypeValue] ;
	if ([StarkTyper isHartainerCoarseSharype:sharypeValue]) {
		return NO ;
	}
	if ([StarkTyper isNotchCoarseSharype:sharypeValue]) {
		return NO ;
	}
	return YES ;
}

- (BOOL)canHaveUrl {
	return ([StarkTyper canHaveUrlSharype:[self sharypeValue]]) ;
}

- (BOOL)canHaveTags {
	return ([StarkTyper canHaveTagsSharype:[self sharypeValue]]) ;
}

- (BOOL)canHaveShortcut {
	return ([StarkTyper canHaveShortcutSharype:[self sharypeValue]]) ;
}

- (BOOL)canBeShared {
	return ([StarkTyper canBeSharedSharype:[self sharypeValue]]) ;
}

- (BOOL)canHaveChildren {
	return ([StarkTyper canHaveChildrenSharype:[self sharypeValue]]) ;
}

- (BOOL)canHaveRSSArticles {
	return ([StarkTyper canHaveRssArticlesSharype:[self sharypeValue]]) ;
}

- (BOOL)isMoveable {
	return ([StarkTyper isMoveableSharype:[self sharypeValue]]) ;
}

- (BOOL)isEditable {
	return ([StarkTyper isEditableSharype:[self sharypeValue]]) ;
}

- (BOOL)canHaveSortDirective {
    BOOL answer = NO;
    id owner = [self owner];
    if ([owner isKindOfClass:[BkmxDoc class]]) {
        BkmxDoc* bkmxDoc = (BkmxDoc*)owner;
        BkmxSortBy sortBy = (BkmxSortBy)[[bkmxDoc shig] sortByValue] ;
        if (sortBy == BkmxSortByName) {
            Sharype sharype = [self sharypeValue] ;
            if ((sharype == SharypeSoftFolder)  || (sharype == SharypeBookmark)) {
                if ([[self parent] shouldSort]) {
                    answer = YES ;
                }
            }
        }
    }

    return answer;
}

- (NSArray*)sortDirectiveChoices {
	NSArray* choices ;
	
	if ([self canHaveSortDirective]) {
		choices = [NSArray arrayWithObjects:
				   [NSNumber numberWithInteger:BkmxSortDirectiveTop],
				   [NSNumber numberWithInteger:BkmxSortDirectiveNormal],
				   [NSNumber numberWithInteger:BkmxSortDirectiveBottom],
				   nil] ;
	}
	else {
        choices = [NSArray arrayWithObjects:
                   [NSNumber numberWithInteger:BkmxSortDirectiveNotApplicable],
                   [NSNumber numberWithInteger:BkmxSortDirectiveTop],
                   [NSNumber numberWithInteger:BkmxSortDirectiveNormal],
                   [NSNumber numberWithInteger:BkmxSortDirectiveBottom],
                   nil] ;
	}

	return choices ;
}

- (BOOL)isEditableAttribute:(NSString*)attribute {
	Sharype sharypeValue = [self sharypeValue] ;
	
	// First, return NO if the sharype itself is uneditable
	// (meaning that no attributes are editable)
	if (![StarkTyper isEditableSharype:sharypeValue]) {
		return NO ;
	}
	
	// If we got here, it ^may^ be editable, depending on attribute
	if ([attribute isEqualToString:constKeyName]) {
		return [self canEditName] ;
	}
	if ([attribute isEqualToString:constKeyUrl]) {
		return [StarkTyper canHaveUrlSharype:sharypeValue] ;
	}
	else if ([attribute isEqualToString:constKeyUrlOrStats]) {
		return [StarkTyper canHaveUrlSharype:sharypeValue] ;
	}
	else if ([attribute isEqualToString:constKeyAddDate]) {
		return NO ;
	}
	else if ([attribute isEqualToString:constKeyIsAllowedDupe]) {
		return [StarkTyper canHaveUrlSharype:sharypeValue] ;
	}
	else if ([attribute isEqualToString:constKeyIsAutoTab]) {
		return [StarkTyper canHaveChildrenSharype:sharypeValue] ;
	}
	else if ([attribute isEqualToString:constKeyDontVerify]) {
		return [StarkTyper canHaveUrlSharype:sharypeValue] ;
	}
	else if ([attribute isEqualToString:constKeyIsShared]) {
		return [StarkTyper canBeSharedSharype:sharypeValue] ;
	}
	else if ([attribute isEqualToString:constKeyLastModifiedDate]) {
		return NO ;
	}
	else if ([attribute isEqualToString:constKeyLastVisitedDate]) {
		return NO ;
	}
	else if ([attribute isEqualToString:constKeyShortcut]) {
		return [StarkTyper canHaveShortcutSharype:sharypeValue] ;
	}
	else if ([attribute isEqualToString:constKeyTags]) {
		return [StarkTyper canHaveTagsSharype:sharypeValue] ;
	}
	else if ([attribute isEqualToString:constKeyVerifierLastResult]) {
		return NO ;
	}
	else if ([attribute isEqualToString:constKeyVisitCount]) {
		return [StarkTyper canHaveUrlSharype:sharypeValue] ;
	}
	else if ([attribute isEqualToString:constKeyVisitCountString]) {
		return [StarkTyper canHaveUrlSharype:sharypeValue] ;
	}
	else if ([attribute isEqualToString:constKeyClients]) {
		return NO ;
	}
	// Tbd when needed: Add branches for other attributes
	// Note that if an attribute is always editable,
	// don't branch on it and the default YES will be returned.
	// This is the case with: comments.
	
	// For now, just 
	return YES ;
}

@end
