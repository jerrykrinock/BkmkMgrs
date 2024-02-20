#import <Cocoa/Cocoa.h>

/*!
 @brief    An abbreviated but canonical representation of the type
 of a stark
*/
typedef short unsigned Sharype ;

#pragma mark * Sharype definitions

// Since simple integers take up the same number of bytes as a pointer,
// and since it can be painful to maintain synchronization between the
// extern declarations in the .h file and the assignments in the .m
// file, I use #define for integer constants.  Actually, it's more efficient
// since I don't need the definition for each value -- A constant used
// in N places takes up only N integer-sized chunks instead of N+1.

// Keywords in definitions denote the hierarchical place:
//    General      -- very coarse
//    Coarse       -- coarse
//    [not noted]  -- fine

#define SharypeAll                0xffff
#define SharypeUndefined          0x0000  

#define SharypeGeneralContainer   0x00ff

#define SharypeCoarseBitSize           4  // Note 4

#define SharypeCoarseHartainer    0x000f
#define SharypeRoot		          0x0001  // Note 3
#define SharypeBar		          0x0002  // Note 3  
#define SharypeMenu		          0x0004  // Note 3
#define SharypeUnfiled	          0x0008  // Note 3
#define SharypeOhared	          0x000a  // Note 3

#define SharypeCoarseSoftainer    0x00f0  // Note 5
#define SharypeSoftFolder         0x0010

#define SharypeCoarseLeaf         0x0f00  // Note 5
#define SharypeBookmark	          0x0100
#define SharypeLiveRSS            0x0200
#define SharypeRSSArticle         0x0300  // Note 2
#define SharypeSmart              0x0400  // Note 6

#define SharypeCoarseNotch        0xf000
#define SharypeSeparator          0x1000

// Note 2.  This type never appears in a BkmxDoc moc, because in a BkmxDoc moc
//        RSS Articles are encoded as an array and stored in attribute
//        rssArticles of their parent SharypeLiveRSS.  SharypeRSSArticle
//        is only used TransMocs of those few extores which store RSS
//        articles (Firefox and OmniWeb), and… 
//           during reading, only until we setRssArticlesFromAndRemoveStarks:
//           during writing, only after restoreRssArticlesInsertAsChildStarks

// Note 3.  This value is used in Default User Defaults, in keys anyStarkCatchypeOrder
//        and maybe preferredCatchype.  It is not used in regular user defaults,
//        because this is a "hidden preference" not available to the user.  So
//        you can change the values by simply changing DefaultDefaults.plist,
//        and changing the user documentation of the hidden preference in
//        documentation anchor mapDefPar.

// Note 4.  The number of bits required to represent SharypeCoarseHartainer.

// Note 5.  These relative values are used in
//       -[NSArray segmentIntoFolders:bookmarks:] to distinguish
//       beteen leaves and nodes.

// Note 6.  Smart Bookmark from some extore.  Note that further examination must
//        be done to determine if this Smart Bookmark is exportable to any given
//        extore.  For example, Firefox' Smart Bookmarks are useless in iCab,
//        and vice versa.


@interface StarkTyper : NSObject

+ (BOOL)isContainerGeneralSharype:(Sharype)sharype ;

+ (BOOL)isRootSharype:(Sharype)sharype ;

+ (BOOL)isHartainerCoarseSharype:(Sharype)sharype ;
+ (BOOL)isSoftainerCoarseSharype:(Sharype)sharype ;
+ (BOOL)isLeafCoarseSharype:(Sharype)sharype ;
+ (BOOL)isNotchCoarseSharype:(Sharype)sharype ;

/*!
 @brief    Classifies a given sharype into one of the
 four coarse types and returns the coarse type.
*/
+ (Sharype)coarseTypeSharype:(Sharype)sharype ;
+ (BOOL)canBeSharedSharype:(Sharype)sharype ;
+ (BOOL)canHaveShortcutSharype:(Sharype)sharype ;
+ (BOOL)canHaveTagsSharype:(Sharype)sharype ;
+ (BOOL)canHaveUrlSharype:(Sharype)sharype ;
+ (BOOL)canHaveChildrenSharype:(Sharype)sharype ;
+ (BOOL)canHaveRssArticlesSharype:(Sharype)sharype ;
+ (BOOL)isMoveableSharype:(Sharype)sharype ;
/*!
 @brief    Returns YES if at least one attribute of the given
 sharype is editable.
*/
+ (BOOL)isEditableSharype:(Sharype)sharype ;
+ (BOOL)isHiddenSharype:(Sharype)sharype ;
+ (BOOL)doesDisplayInNoFoldersViewSharype:(Sharype)sharype ;
+ (BOOL)doesCountAsBookmarkSharype:(Sharype)sharype ;
	
/*!
 @brief    Returns a human-readable name of a given sharype

 @details  For debugging
*/
+ (NSString*)readableSharype:(Sharype)sharype ;

+ (Sharype)sharypesMaskForSearchForSharypesSet:(NSSet*)searchForSharypes ;

@end
