#import "BkmxGlobals.h"
#import "NSNumber+Sharype.h"

/*!
 @brief    Slarype: A stark's "long long" type
 
 @details  I use a 64-bit "long long" to represent this so that there
 is plenty of bits to define lots of bit-masked attributes.&nbsp; 
 Since this type is accessed at megaHertz rates, I don't want the
 overhead of a full-blown class which would not be necessary.&nbsp; 
 32 bits would have been enough, but 64 will allow for the unforseen.
 */
typedef long long Slarype ;

// Since simple integers take up the same number of bytes as a pointer,
// and since it can be painful to maintain synchronization between the
// extern declarations in the .h file and the assignments in the .m
// file, I use #define for integer constants.  Actually, it's more efficient
// since I don't need the definition for each value -- A constant used
// in N places takes up only N integer-sized chunks instead of N+1.


// 1-bit attributes of Slarype
#define SlarypeMaskCanBeShared					  0x0000000000100000LL
#define SlarypeMaskCanHaveShortcut				  0x0000000000200000LL
#define SlarypeMaskCanHaveTags					  0x0000000000400000LL
#define SlarypeMaskCanHaveUrl					  0x0000000000800000LL
#define SlarypeMaskCanHaveChildren      		  0x0000000001000000LL
#define SlarypeMaskCanHaveRssArticles      	      0x0000000002000000LL
#define SlarypeMaskIsHartainer				      0x0000000004000000LL
#define SlarypeMaskIsMoveable				      0x0000000008000000LL
#define SlarypeMaskIsEditable					  0x0000000010000000LL
#define SlarypeMaskIsHidden                       0x0000000020000000LL
#define SlarypeMaskDisplayInNoFoldersView         0x0000000040000000LL
#define SlarypeMaskCountAsBookmark                0x0000000080000000LL

// Extended (64-bit) Shark Types, Short Type + Attributes
/*
 Don't use an enum here since an enum member constant is of type int, may be
 only 32 bits.  From the C Standard (C99):
     http://www.open-std.org/JTC1/SC22/WG14/www/docs/n1256.pdf
 6.7.2.2 Enumeration specifiers
 [...]
 Each enumerated type shall be compatible with char, a signed integer type, or
 an unsigned integer type. The choice of type is implementation-defined, but
 shall be capable of representing the values of all the members of the enumeration.
 
 I suppose that by "integer" they mean "int".  According to Apple's "64-bit
 Transition Guide", ints are only 4 bytes, even in __LP64__.
 */
#define SlarypeUndefined	    SharypeUndefined
#define SlarypeRoot			    SharypeRoot + SlarypeMaskCanHaveChildren + SlarypeMaskIsHartainer     
#define SlarypeBar			    SharypeBar + SlarypeMaskCanHaveChildren + SlarypeMaskIsHartainer     
#define SlarypeMenu			    SharypeMenu + SlarypeMaskCanHaveChildren + SlarypeMaskIsHartainer    
#define SlarypeUnfiled		    SharypeUnfiled + SlarypeMaskCanHaveChildren + SlarypeMaskIsHartainer 
#define SlarypeOhared		    SharypeOhared + SlarypeMaskCanHaveChildren + SlarypeMaskIsHartainer
//#define SlarypeBookmacsterizer  SharypeBookmacsterizer + SlarypeMaskCanHaveUrl + SlarypeMaskIsMoveable  + SlarypeMaskIsEditable + SlarypeMaskDisplayInNoFoldersView + SlarypeMaskCountAsBookmark
#define SlarypeSoftFolder	    SharypeSoftFolder + SlarypeMaskCanHaveChildren + SlarypeMaskIsMoveable + SlarypeMaskIsEditable 
#define SlarypeSmart            SharypeSmart + SlarypeMaskCanHaveUrl + SlarypeMaskIsMoveable + SlarypeMaskIsEditable + SlarypeMaskCanHaveShortcut // last term added in BookMacster 1.14.9
#define SlarypeLiveRSS		    SharypeLiveRSS + SlarypeMaskCanHaveRssArticles + SlarypeMaskCanBeShared + SlarypeMaskCanHaveShortcut + SlarypeMaskCanHaveTags + SlarypeMaskCanHaveUrl + SlarypeMaskIsMoveable + SlarypeMaskIsEditable + SlarypeMaskDisplayInNoFoldersView + SlarypeMaskCountAsBookmark
#define SlarypeBookmark		    SharypeBookmark + SlarypeMaskCanHaveUrl + SlarypeMaskIsMoveable + SlarypeMaskCanBeShared + SlarypeMaskCanHaveShortcut + SlarypeMaskCanHaveTags + SlarypeMaskIsEditable + SlarypeMaskDisplayInNoFoldersView + SlarypeMaskCountAsBookmark
#define SlarypeRSSArticle	    SharypeRSSArticle + SlarypeMaskCanHaveUrl
#define SlarypeSeparator	    SharypeSeparator + SlarypeMaskIsMoveable + SlarypeMaskIsEditable	

@implementation StarkTyper

/*!
 @brief    Given the lower 16 bits of a slarype, returns
 the complete 64-but slarype which it represents.
 
 @details  A slarype is defined by its lower 16 bits, which
 give its 'Fine'(-grained) type.&nbsp; The other 48 bits
 give constant attributes which can be found quickly using
 bit masks.  However, the abbreviated 16 bits are used,
 where a 64-bit storage is not available, for example,
 in the 'tag' of an NSMenuItem.  This method allows the
 abbreviated 16 bits to be used in those places.
 */
+ (Slarype)slarypeFromSharype:(Sharype)shortSlarype {
	switch (shortSlarype) {
		case SharypeUndefined:
			return SlarypeUndefined ;
		case SharypeRoot:
			return SlarypeRoot ;
		case SharypeBar:
			return SlarypeBar ;
		case SharypeMenu:
			return SlarypeMenu ;
		case SharypeUnfiled:
			return SlarypeUnfiled ;
		case SharypeOhared:
			return SlarypeOhared ;
		case SharypeSoftFolder:
			return SlarypeSoftFolder ;
		case SharypeLiveRSS:
			return SlarypeLiveRSS ;
		case SharypeSmart:
			return SlarypeSmart ;
		case SharypeBookmark:
			return SlarypeBookmark ;
		case SharypeRSSArticle:
			return SlarypeRSSArticle ;
		case SharypeSeparator:
			return SlarypeSeparator ;
	}
	
	return SlarypeUndefined ;
}


// Note parantheses needed in the following methods.
// C Precedence Rules say > precedes &.

+ (BOOL)isContainerGeneralSharype:(Sharype)sharype {
	return ((sharype & SharypeGeneralContainer) != 0) ;
}

+ (BOOL)isRootSharype:(Sharype)sharype {
	return ((sharype & SharypeRoot) != 0) ;
}

+ (BOOL)isHartainerCoarseSharype:(Sharype)sharype {
	return ((sharype & SharypeCoarseHartainer) != 0) ;
}

+ (BOOL)isSoftainerCoarseSharype:(Sharype)sharype {
	return ((sharype & SharypeCoarseSoftainer) != 0) ;
}

+ (BOOL)isLeafCoarseSharype:(Sharype)sharype {
	return ((sharype & SharypeCoarseLeaf) != 0) ;
}

+ (BOOL)isNotchCoarseSharype:(Sharype)sharype {
	return ((sharype & SharypeCoarseNotch) != 0) ;
}

+ (Sharype)coarseTypeSharype:(Sharype)sharype {
	if ([self isHartainerCoarseSharype:sharype]) {
		return SharypeCoarseHartainer ;
	}
	if ([self isSoftainerCoarseSharype:sharype]) {
		return SharypeCoarseSoftainer ;
	}
	if ([self isLeafCoarseSharype:sharype]) {
		return SharypeCoarseLeaf ;
	}
	if ([self isNotchCoarseSharype:sharype]) {
		return SharypeCoarseNotch ;
	}
	
	// The following was commented out in BookMacster 1.6
	// because there are several instances, usually during imports
	// to various extores, wherein the name of a stark is set
	// before the sharype, and -setName: checks the sharype,
	// just to make sure that it is not a separator.
	// Example 1: -[Stark replicatedOrphanStarkFreshened:], because
	//   -setAttributes: sets attributes in nondeterministic order
	// Example 2: -[ExtoreCamino makeStarksFromExtoreTree:error_p:], when setting name of the root

	// NSLog(@"Internal Error 098-8274, 0x%x", sharype) ;
	return SharypeUndefined ;
}

// Note parentheses needed in the following methods.
// C Precedence Rules say > precedes &.

+ (BOOL)canBeSharedSharype:(Sharype)sharype {
	return (([self slarypeFromSharype:sharype] & SlarypeMaskCanBeShared) != 0) ;
}

+ (BOOL)canHaveShortcutSharype:(Sharype)sharype {
	return (([self slarypeFromSharype:sharype] & SlarypeMaskCanHaveShortcut) != 0) ;
}

+ (BOOL)canHaveTagsSharype:(Sharype)sharype {
	return (([self slarypeFromSharype:sharype] & SlarypeMaskCanHaveTags) != 0) ;
}

+ (BOOL)canHaveUrlSharype:(Sharype)sharype {
	return (([self slarypeFromSharype:sharype] & SlarypeMaskCanHaveUrl) != 0) ;
}

+ (BOOL)canHaveChildrenSharype:(Sharype)sharype {
	return (([self slarypeFromSharype:sharype] & SlarypeMaskCanHaveChildren) != 0) ;
}

+ (BOOL)canHaveRssArticlesSharype:(Sharype)sharype {
	return (([self slarypeFromSharype:sharype] & SlarypeMaskCanHaveRssArticles) != 0) ;
}

+ (BOOL)isMoveableSharype:(Sharype)sharype {
	return (([self slarypeFromSharype:sharype] & SlarypeMaskIsMoveable) != 0) ;
}

+ (BOOL)isEditableSharype:(Sharype)sharype {
	return (([self slarypeFromSharype:sharype] & SlarypeMaskIsEditable) != 0) ;
}

+ (BOOL)isHiddenSharype:(Sharype)sharype {
	return (([self slarypeFromSharype:sharype] & SlarypeMaskIsHidden) != 0) ;
}

+ (BOOL)doesDisplayInNoFoldersViewSharype:(Sharype)sharype {
	return (([self slarypeFromSharype:sharype] & SlarypeMaskDisplayInNoFoldersView) != 0) ;
}

+ (BOOL)doesCountAsBookmarkSharype:(Sharype)sharype {
	return (([self slarypeFromSharype:sharype] & SlarypeMaskCountAsBookmark) != 0) ;
}

+ (NSString*)readableSharype:(Sharype)sharype {
	switch (sharype) {
		case SharypeUndefined:
			return @"ShypUndf" ;
		case SharypeRoot:
			return @"ShypRoot" ;
		case SharypeBar:
			return @"Shyp-Bar" ;
		case SharypeMenu:
			return @"ShypMenu" ;
		case SharypeUnfiled:
			return @"ShypUnfl" ;
		case SharypeOhared:
			return @"ShypOhar" ;
		//case SharypeBookmacsterizer:
		//	return @"ShypBmxz" ;
		case SharypeSoftFolder:
			return @"ShypSofF" ;
		case SharypeSmart:
			return @"ShypSmrt" ;
		case SharypeLiveRSS:
			return @"ShypLRSS" ;
		case SharypeBookmark:
			return @"ShypBkmk" ;
		case SharypeRSSArticle:
			return @"ShypRSSA" ;
		case SharypeSeparator:
			return @"ShypSepr" ;
        case SharypeCoarseNotch:
            return @"ShypNoch" ;
        case SharypeCoarseLeaf:
            return @"ShypLeaf" ;
        case SharypeCoarseSoftainer:
            return @"ShypCSof" ;
        case SharypeCoarseHartainer:
            return @"ShypCHar" ;
		default:
			return [NSString stringWithFormat:@"sharype = 0x%hx, unknown (not set yet?)", sharype] ;
	}
}

+ (Sharype)sharypesMaskForSearchForSharypesSet:(NSSet*)searchForSharypes {
    Sharype mask = 0 ;
	if([searchForSharypes member:[NSNumber numberWithSharype:SharypeCoarseLeaf]] != nil) {
		mask += SharypeCoarseLeaf ;
	}
	if([searchForSharypes member:[NSNumber numberWithSharype:SharypeGeneralContainer]] != nil) {
		mask += SharypeGeneralContainer ;
	}
    return mask;
}

@end