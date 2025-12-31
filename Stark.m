#import "Bkmxwork/Bkmxwork-Swift.h"
#import "Stark.h"
#import "Stark+Sorting.h"
#import "Stark+Attributability.h"
#import "Starker.h"
#import "Extore.h"
#import "NSString+BkmxURLHelp.h"
#import "NSDictionary+SimpleMutations.h"
#import "NSString+MoreComparisons.h"
#import "Client.h"
#import "BkmxDoc.h"
#import "Chaker.h"
#import "NSArray+Reversing.h"
#import "NSArray+SSYMutations.h"
#import "SSYTreeTransformer.h"
#import "NSSet+Indexing.h"
#import "Bookshig.h"
#import "NSString+SSYExtraUtils.h"
#import "TalderMapper.h"
#import "BkmxBasis+Strings.h"
#import "NSString+LocalizeSSY.h"
#import "Hartainertainer.h"
#import "SSYMOCManager.h"
#import "StarkTableColumn.h"
#import "NSDictionary+Readable.h"
#import "NSObject+DoNil.h"
#import "NSDate+NiceFormats.h"
#import "NSNumber+VerifierDispositionDisplay.h"
#import "BkmxDocWinCon.h"
#import "NSNumber+Sharype.h"
#import "NSArray+Stringing.h"
#import "NSObject+MoreDescriptions.h"
#import "SSYProgressView.h"
#import "BkmxAppDel.h"
#import "NSString+Truncate.h"
#import "NSManagedObject+Attributes.h"
#import "NSManagedObject+Debug.h"
#import "Starxider.h"
#import "SSYUuid.h"
#import "Exporter.h"
#import "Starlobuter.h"
#import "SSYBetterHashCategories.h"
#import "Gulper.h"
#import "NSString+SSYCaseness.h"
#import "InspectorController.h"
#import "ContentDataSource.h"
#import "ContentOutlineView.h"
#import "NSUserDefaults+MainApp.h"

#if 0
#warning Compiling with Stark/exid Assertions
#define USE_STARK_EXID_ASSERTIONS 1
#endif

static NSMutableArray* static_debug_contentHashComponents ;

@interface NSString (Bkmx_Debug_Hash)
/*!
 @details  On 20180927, I changed this method to return an allocced value
 instead of an autoreleased value, because I was looking in Instruments
 and there appeared to be a lot of strngs from this method hanging around.
 */

+ (NSString*)newBkmxDebugReadableKey:(NSString*)key
                         	   value:(NSString*)value ;
@end

@implementation NSString (Bkmx_Debug_Hash)

+ (NSString*)newBkmxDebugReadableKey:(NSString*)key
                               value:(NSString*)value {
    NSString* answer = [[NSString alloc] initWithFormat:
                        @"%@ %@",
                        [key stringByPaddingToLength:16
                                          withString:@" "
                                     startingAtIndex:0],
                        [value shortDescription]] ;
    return answer;
}

@end

static NSArray* static_hashableAttributes = nil ;

#define IMPORT_FLAG_MASK_CORRECT_PARENT_HAS_ME   0x00000001
#define IMPORT_FLAG_MASK_NO_LONGER_USED          0x00000002  // Available for future expansion
#define IMPORT_FLAG_MASK_MIRROR_SOURCE_MATE      0x00000004
#define IMPORT_FLAG_MASK_IS_NEW_ITEM_THIS_CLIENT 0x00000008
#define IMPORT_FLAG_MASK_IS_NEW_ITEM_THIS_IXPORT 0x00000010
#define IMPORT_FLAG_MASK_IS_UPDATED_THIS_IXPORT  0x00000020
#define IMPORT_FLAG_MASK_IS_DELETED_THIS_IXPORT  0x00000040
#define IMPORT_FLAG_MASK_IXPORTING_INDEX         0xffff0000  // See -ixportingIndex, -setIxportingIndex:
#define IXPORT_FLAG_SHIFT_IXPORTING_INDEX                16  // See -ixportingIndex, -setIxportingIndex:

NSString* const constKeyDonkey = @"donkey" ;
NSString* const constKeyFoldersDeletedDuringConsolidation = @"foldersDeletedDuringConsolidation";

@implementation NSArray (BookMacstrifyTags)

- (NSArray*)bookMacstrifiedTags {
	NSArray* answer = nil ;
	
	if ([self count] > 0) {
		// Remove duplicate tags.  There are two ways you can get duplicates
		// in newValue here, that I know of:
		// 1.  User creates them in the Content Tab.
		// 2.  Firefox will not delete duplicate tags if you export them as such.
		NSMutableArray* bookMacstrifiedTags = [[NSMutableArray alloc] init] ;
		for (Tag* proposedTag in self) {
			BOOL isUnique = YES ;
			Tag* acceptedTag ;
			for (acceptedTag in bookMacstrifiedTags) {
				if ([proposedTag.string localizedCaseInsensitiveCompare:acceptedTag.string] == NSOrderedSame) {
					// See Note 432897 ▸ Localized?
					isUnique = NO ;
					break ;
				}
			}
			
			if (isUnique) {
				[bookMacstrifiedTags addObject:proposedTag] ;
			}
			else if ([acceptedTag.string compareCase:proposedTag.string] != NSOrderedAscending) {
				// proposedTag matches an acceptedTag, and 
				// the acceptedTag is more upper case.
				// We want the the more lowercase.  Replace it.
				[bookMacstrifiedTags removeObject:acceptedTag] ;
				[bookMacstrifiedTags addObject:proposedTag] ;
			}
			else {
				// The existing acceptedTag is of lower case and is 
				// already in bookMacstrifiedTags.  Don't add the
				// proposedTag.  Don't do anything.
			}
		}
		
		// This section added in BookMacster 1.11
		// Sort alphabetically, to match behavior of the most popular
		// client supporting tags, Firefox.
		// See Note 432897 ▸ Localized?
		[bookMacstrifiedTags sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)] ;

		answer = [NSArray arrayWithArray:bookMacstrifiedTags] ;
		[bookMacstrifiedTags release] ;		
	}
	else {
		// No tags.  Our standard is "no tags" means "nil"
		// We don't want empty arrays.
		// Leave bookMacstrifiedTags = nil.
	}
	
	return answer ;
}

@end



@interface Stark (CoreDataGeneratedPrimitiveAccessors)

/*
 These accessors are dynamically generated at runtime by Core Data.  They 
 must be declared in a category with no implementation. If declared in, for
 example, the subclass @interface, or in an anonymous category ("()"),
 you get compiler warnings that their implementations
 are missing.
 http://www.cocoabuilder.com/archive/message/cocoa/2008/8/10/215317
 */

- (void)setPrimitive:()value ;

- (void)setPrimitiveAddDate:(NSDate*)value ;
- (NSColor*)primitiveColor ;
- (void)setPrimitiveColor:(NSColor *)value ;
- (void)setPrimitiveComments:(NSString *)value ;
- (void)setPrimitiveDontExportExformats:(NSArray *)value ;
- (void)setPrimitiveDontVerify:(NSNumber *)value ;
- (void)setPrimitiveDupe:(Dupe *)value;
- (void)setPrimitiveFavicon:(NSData *)value ;
- (void)setPrimitiveFaviconUrl:(NSString *)value ;
- (void)setPrimitiveIndex:(NSNumber *)value ;
- (void)setPrimitiveIsAutotab:(NSNumber *)value ;
- (id)primitiveIsShared ;
- (void)setPrimitiveIsShared:(NSNumber *)value ;
- (void)setPrimitiveIsAllowedDupe:(NSNumber*)value ;
- (void)setPrimitiveLastChengDate:(NSDate*)value ;
- (NSDate*)primitiveLastModifiedDate ;
- (void)setPrimitiveLastModifiedDate:(NSDate*)value ;
- (void)setPrimitiveLastVisitedDate:(NSDate*)value ;
- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value ;
- (void)setPrimitiveParent:(Stark *)value ;
- (NSNumber*)primitiveRating;
- (void)setPrimitiveRating:(NSNumber *)value ;
- (NSArray*)primitiveRssArticles;
- (void)setPrimitiveRssArticles:(NSArray*)value;
- (NSNumber*)primitiveSharype;
- (void)setPrimitiveSharype:(NSNumber*)value;
- (NSNumber*)primitiveSharypeCoarse;
- (void)setPrimitiveSharypeCoarse:(NSNumber*)value;
- (void)setPrimitiveShortcut:(NSString *)value ;
- (void)setPrimitiveSortable:(NSNumber*)value ;
- (void)setPrimitiveSortDirective:(NSNumber*)value ;
- (NSArray*)primitiveTags;
- (void)setPrimitiveTags:(id)value;
- (id)primitiveToRead ;
- (void)setPrimitiveToRead:(NSNumber *)value ;
- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;
- (void)setPrimitiveVerifierCode:(NSNumber*)value ;
- (void)setPrimitiveVerifierDetails:(NSDictionary*)value ;
- (id)primitiveVerifierDisposition ;
- (void)setPrimitiveVerifierDisposition:(NSNumber*)value ;
- (void)setPrimitiveVerifierLastDate:(NSDate*)value ;
- (void)setPrimitiveVerifierSubtype302:(NSNumber*)value ;
- (NSNumber*)primitiveVisitCount;
- (void)setPrimitiveVisitCount:(NSNumber*)value;
- (void)setPrimitiveVisitor:(NSString *)value ;
- (void)setPrimitiveVisitorWindowFrame:(NSString*)value ;

@end



@interface Stark ()

/*!
 @brief    Sets only the ivar, not the persistent
 store
 
 @details  Use this for efficiency instead of -setExids:
 when you have just read the new 'exids' out of the store
 and know there is no need to re-set its value.
 
 @result   YES if the new value did not equal the
 current ivar value, and it was set.  NO if the ivar
 value already isEqual: the new value.
 */
- (BOOL)setIvarOnlyExids:(NSDictionary*)exids ;


// Transient properties which are publicly read-only, privately read/write
@property (assign) NSInteger ixportFlags ;

#if LOGGING_STARK_DEALLOCATION
@property (copy) NSString* debugOwnerString ;
@property (copy) NSString* debugName ;
#endif

@end


@implementation Stark

+ (NSArray*)immediateBookmarksInHartainers:(NSArray*)hartainers
                               softFolders:(NSArray*)softFolders
                                 bookmarks:(NSArray*)bookmarks {
    NSMutableArray* allBookmarks = [bookmarks mutableCopy] ;
    NSArray* containers = [softFolders arrayByAddingObjectsFromArray:hartainers] ;
    for (Stark* container in containers) {
        for (Stark* bookmark in [container childrenOrdered]) {
            if ([bookmark sharypeValue] == SharypeBookmark) {
                [allBookmarks addObject:bookmark] ;
            }
        }
    }
    
    NSArray* answer = [NSArray arrayWithArray:allBookmarks] ;
    [allBookmarks release] ;
    
    return answer ;
}

+ (NSSet*)attributesYouDontWantInHash {
    return [NSSet setWithObjects:
            constKeyAddDate,
            constKeyLastModifiedDate,
            constKeyVisitCount,         // This line dded in BookMacster 1.15.1
            constKeyStarkid,
            nil] ;
    /*
     We omit starkid because
     (1) The starkid is not a property that the user is concerned with
     (2) A Stark owned by an extore will get a different starkid on each import
     */
}

+ (NSArray*)hashableAttributes {
	if (!static_hashableAttributes) {
		NSEntityDescription* entityDescription = [self entityDescription] ;
        NSMutableSet* attributeKeys = [[NSMutableSet alloc] initWithArray:[[entityDescription attributesByName] allKeys]];
        [attributeKeys minusSet:[self attributesYouDontWantInHash]];
        [attributeKeys addObject:@"tagStringForHash"];
        
        NSArray* attributeKeysArray = [attributeKeys allObjects];
        [attributeKeys release];
		static_hashableAttributes = [attributeKeysArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] ;
		[static_hashableAttributes retain] ;
	}
	
	return static_hashableAttributes ;
}

+ (Class)collectionClassForAttribute:(NSString*)attribute {
	if ([attribute isEqualToString:constKeyTags]) {
		return [NSArray class] ;
	}
	if ([attribute isEqualToString:constKeyRssArticles]) {
		return [NSArray class] ;
	}
	
	return NULL ;
}
												
												
#pragma mark * Core Data Generated Accessors for Managed Objects

// Attributes
@dynamic addDate ;
@dynamic color ;
@dynamic comments ;
@dynamic dontExportExformats ;
@dynamic favicon ;  
@dynamic faviconUrl ;
@dynamic isAllowedDupe ;
@dynamic isAutoTab ;
@dynamic exid ;
@dynamic dontVerify ;
@dynamic isShared ; 
@dynamic sortable ;
@dynamic sortDirective ;
@dynamic lastChengDate ;
@dynamic lastModifiedDate ;
@dynamic lastVisitedDate ;
@dynamic name ;
@dynamic rating ;
@dynamic rssArticles ;
@dynamic shortcut ;
@dynamic sharype ;
@dynamic starkid ;
@dynamic tags ;
@dynamic toRead ;
@dynamic url ; // custom setter, below
@dynamic verifierCode ;
@dynamic verifierDetails ;
@dynamic verifierDisposition ;
@dynamic verifierLastDate ;
@dynamic verifierSubtype302 ;
@dynamic visitCount ;
@dynamic visitor ;

@synthesize donkey = m_donkey ;


// Relationships
@dynamic dupe ;

#pragma mark * Infrastructure


- (Starxider*)starxider {
	Starxider* starxider = nil ;
    NSObject <Hartainertainer, StarkReplicator, Startainer>* owner = [self allocOwner];
	if ([owner respondsToSelector:@selector(starxider)]) {
		starxider = [(BkmxDoc*)owner starxider] ;
	}
	else {
		// owner must be an Extore.  Return nil.
	}
    [owner release];
    
	return starxider ;
}

- (Starlobuter*)starlobuter {
	Starlobuter* starlobuter = nil ;
    NSObject <Hartainertainer, StarkReplicator, Startainer>* owner = [self allocOwner];
	if ([owner respondsToSelector:@selector(starlobuter)]) {
		starlobuter = [(BkmxDoc*)owner starlobuter] ;
	}
	else {
		// owner must be an Extore.  Return nil.
	}
    [owner release];

	return starlobuter ;
}

- (TalderMapper*)talderMapper {
	TalderMapper* talderMapper = nil ;
    NSObject <Hartainertainer, StarkReplicator, Startainer>* owner = [self allocOwner];
	if ([owner respondsToSelector:@selector(talderMapper)]) {
		talderMapper = [(BkmxDoc*)owner talderMapper] ;
	}
	else {
		// owner must be an Extore.  Return nil.
	}
    [owner release];

	return talderMapper ;
}

#if LOGGING_STARK_DEALLOCATION
- (void)rememberDebugOwner {
    NSObject <Hartainertainer, StarkReplicator, Startainer>* owner = [self allocOwner];
	NSString* ownerString ;
	if (!owner) {
		ownerString = @"<No-Owner>" ;
	}
	if ([owner respondsToSelector:@selector(displayNameShort)]) {
		ownerString = [owner displayNameShort] ;
	}
	else if ([owner respondsToSelector:@selector(shortDescription)]) {
		ownerString = [owner shortDescription] ;
	}
	else {
		ownerString = [owner description] ;
	}
    [owner release];

	[self setDebugOwnerString:ownerString] ;
}
#endif

- (void)awakeFromInsert {
	[super awakeFromInsert] ;
	
#if LOGGING_STARK_DEALLOCATION
	[self rememberDebugOwner] ;
#endif
	
	[self setStarkid:[SSYUuid compactUuid]] ;
}

- (void)awakeFromFetch {
	[super awakeFromFetch] ;

#if LOGGING_STARK_DEALLOCATION
	[self rememberDebugOwner] ;
#endif
	
	NSDictionary* exids = [[self starxider] exidsForStark:self] ;
	[self setIvarOnlyExids:exids] ;
}

/* End of overrides providing exids in separate store */

- (void)dealloc {
#if LOGGING_STARK_DEALLOCATION
    NSLog(@"Will dealloc stark %@", [self debugName]) ;
#endif

    [m_exids release] ;
    [childrenTemp release] ;
    [m_sponsorIndex release] ;
    [m_sponsoredIndex release] ;
    [m_oldParent release] ;
    [m_oldChildrenExids release] ;
    [m_ownerValues release] ;

#if LOGGING_STARK_DEALLOCATION
    [m_debugOwnerString release] ;
    [m_debugName release] ;
#endif

    [super dealloc] ;

#if LOGGING_STARK_DEALLOCATION
    NSLog(@"Did dealloc stark %p", self) ;
#endif
}

- (id)valueForUndefinedKey:(NSString*)key {
    id value ;
    if ([key hasPrefix:@"shouldExportTo"]) {
        NSString* exformat = [key substringFromIndex:[@"shouldExportTo" length]] ;
        BOOL shouldExport ;
        NSArray* dontExportExformats = [self dontExportExformats] ;
        if (dontExportExformats) {
            shouldExport = [dontExportExformats indexOfObject:exformat] == NSNotFound ;
        }
        else {
            shouldExport = YES ;
        }
        value = [NSNumber numberWithBool:shouldExport] ;
    }
    
    else {
        value = [super valueForUndefinedKey:key] ;
    }
    
    return value ;
}

- (void)setValue:(id)value
 forUndefinedKey:(NSString*)key {
    if ([key hasPrefix:@"shouldExportTo"]) {
        NSString* exformat = [key substringFromIndex:[@"shouldExportTo" length]] ;
        NSArray* dontExportExformats = [self dontExportExformats] ;
        
        if ([value boolValue]) {
            // Remove this item if it exists in dontExportExformats
            if (dontExportExformats) {
                dontExportExformats = [dontExportExformats arrayByRemovingObject:exformat] ;
            }
            else {
                dontExportExformats = nil ;
            }
            [self setDontExportExformats:dontExportExformats] ;
        }
        else {
            // Add this item if it dos not exist in dontExportExformats
            if (dontExportExformats) {
                dontExportExformats = [dontExportExformats arrayByAddingUniqueObject:exformat] ;
            }
            else {
                dontExportExformats = [NSArray arrayWithObject:exformat] ;
            }
            [self setDontExportExformats:dontExportExformats] ;
        }
    }
    
    else {
        [super setValue:value
         forUndefinedKey:key] ;
    }
}


#pragma mark * Accessors for Non-Managed Properties

@synthesize childrenTemp ;
@synthesize ixportFlags ;
@synthesize sponsorIndex = m_sponsorIndex ;
@synthesize sponsoredIndex = m_sponsoredIndex ;
@synthesize oldParent = m_oldParent ;
@synthesize oldChildrenExids = m_oldChildrenExids;

- (BOOL)shouldMirrorSourceMate {
	return (([self ixportFlags] & IMPORT_FLAG_MASK_MIRROR_SOURCE_MATE) > 0) ;
}

/*!
 @details  An instance of NoStark returns NO.
*/
- (BOOL)isAStark {
	return YES ;
}

- (BOOL)isNewItemThisClient {
	return (([self ixportFlags] & IMPORT_FLAG_MASK_IS_NEW_ITEM_THIS_CLIENT) > 0) ;
}

- (BOOL)isNewItemThisIxport {
	return (([self ixportFlags] & IMPORT_FLAG_MASK_IS_NEW_ITEM_THIS_IXPORT) > 0) ;
}

- (BOOL)isDeletedThisIxport {
	return (([self ixportFlags] & IMPORT_FLAG_MASK_IS_DELETED_THIS_IXPORT) > 0) ;
}

- (void)setShouldMirrorSourceMate {
	NSInteger flags = [self ixportFlags] ;
	flags = flags | IMPORT_FLAG_MASK_MIRROR_SOURCE_MATE ;
	[self setIxportFlags:flags] ;
}

- (void)setIsNewItem {
	NSInteger flags = [self ixportFlags] ;
	flags = flags | IMPORT_FLAG_MASK_MIRROR_SOURCE_MATE | IMPORT_FLAG_MASK_IS_NEW_ITEM_THIS_CLIENT | IMPORT_FLAG_MASK_IS_NEW_ITEM_THIS_IXPORT ;
	[self setIxportFlags:flags] ;
}

- (void)setIsDeletedThisIxport {
	NSInteger flags = [self ixportFlags] ;
	flags = flags | IMPORT_FLAG_MASK_IS_DELETED_THIS_IXPORT ;
	[self setIxportFlags:flags] ;
}

- (void)clearThisClientFlags {
	NSInteger flags = [self ixportFlags] ;
	flags = flags & ~(IMPORT_FLAG_MASK_IS_NEW_ITEM_THIS_CLIENT | IMPORT_FLAG_MASK_MIRROR_SOURCE_MATE) ;
	[self setIxportFlags:flags] ;
}

- (BOOL)correctParentHasMe {
	return (([self ixportFlags] & IMPORT_FLAG_MASK_CORRECT_PARENT_HAS_ME) > 0) ;
}

- (NSInteger)ixportingIndex {
	NSInteger index = ([self ixportFlags] >> IXPORT_FLAG_SHIFT_IXPORTING_INDEX) ;
	return index ;
}

- (void)clearIxportingIndex {
	NSInteger flags = [self ixportFlags] ;
	flags = flags & ~IMPORT_FLAG_MASK_IXPORTING_INDEX ;
	[self setIxportFlags:flags] ;
}

- (void)setIxportingIndex:(NSInteger)index {
	NSInteger flags = [self ixportFlags] ;
	flags = flags | (index << IXPORT_FLAG_SHIFT_IXPORTING_INDEX) ;
	[self setIxportFlags:flags] ;
}

- (void)setCorrectParentHasMe:(BOOL)value {
	NSInteger flags = [self ixportFlags] ;
	if (value) {
		flags = flags | IMPORT_FLAG_MASK_CORRECT_PARENT_HAS_ME ;
	}
	else {
		flags = flags & ~IMPORT_FLAG_MASK_CORRECT_PARENT_HAS_ME ;
	}
	[self setIxportFlags:flags] ;
}

- (BOOL)isUpdatedThisIxport {
	return (([self ixportFlags] & IMPORT_FLAG_MASK_IS_UPDATED_THIS_IXPORT) > 0) ;
}

- (void)setIsUpdatedThisIxport {
	NSInteger flags = [self ixportFlags] ;
	flags = flags | IMPORT_FLAG_MASK_IS_UPDATED_THIS_IXPORT ;
	[self setIxportFlags:flags] ;
}

- (void)clearIxportFlags {
	[self setIxportFlags:0] ;
}


#pragma mark * Custom Accessors for Specially Managed Properties

/*!
 @brief    Override to fix the 1Password bug in BookMacster, added in
 BookMacster 1.1.17, removed and supplanted in BookMacster 1.3.0 by
 -[Bkmx009_010MigrationPolicy xform1PasswordToRegularBookmarkSharype:].

 @details  In 1.1.17, this definition was deleted from StarkTyper.h:
 
 #define Sharype1Password          0x0800  
 
 and instead 1Password bookmarklets are treated as regular bookmarks.
 (This was done because the former method, typing them when they were
 imported in from Safari, is not fixable if, as I found, a new
 1Password bookmarklet type is put in use by Agile Web Solutions.  
 Therefore, I now need to recognize them when they are exported
 (and do so in -isExportableStark:withChange:).  However, existing users have
 1Password bookmarklets which have sharypeValue = 0x0800.
  - (NSNumber*)sharype {
    NSNumber * tmpValue;

    [self willAccessValueForKey:constKeySharype];
    tmpValue = [self primitiveSharype];
    [self didAccessValueForKey:constKeySharype];
	
	if ([tmpValue sharypeValue] == 0x0800) {
		tmpValue = [NSNumber numberWithSharype:SharypeBookmark] ;
	}
	
	return tmpValue ;
}
 */

- (NSNumber *)visitCount  {
    NSNumber * tmpValue;
    
    [self willAccessValueForKey:@"visitCount"];
    tmpValue = [self primitiveVisitCount];
    [self didAccessValueForKey:@"visitCount"];
    
	if (![self canHaveUrl]) {
		tmpValue = nil ;
	}
	else if (!tmpValue) {
		tmpValue = [NSNumber numberWithInteger:0] ;
	}	
    
	return tmpValue;
}

- (void)setAddDate:(NSDate*)newValue {
	[self postWillSetNewValue:newValue
					   forKey:constKeyAddDate] ;
	[self willChangeValueForKey:constKeyAddDate] ;
    [self setPrimitiveAddDate:newValue] ;
    [self didChangeValueForKey:constKeyAddDate] ;
}

// This is required to trigger -[BkmxDoc objectWillChangeNote:]
- (void)setColor:(NSColor*)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeyColor] ;
	[self willChangeValueForKey:constKeyColor] ;
    [self setPrimitiveColor:newValue] ;
    [self didChangeValueForKey:constKeyColor] ;
}

// This is required to trigger -[BkmxDoc objectWillChangeNote:]
- (void)setComments:(NSString*)newValue  {
	if ([newValue length] == 0) {
		newValue = nil ;
	}
	
	[self postWillSetNewValue:newValue
					   forKey:constKeyComments] ;
	[self willChangeValueForKey:constKeyComments] ;
    [self setPrimitiveComments:newValue] ;
    [self didChangeValueForKey:constKeyComments] ;
}

// This is required to trigger -[BkmxDoc objectWillChangeNote:]
- (void)setDontExportExformats:(NSArray*)newValue {
	[self postWillSetNewValue:newValue
					   forKey:constKeyDontExportExformats] ;
	[self willChangeValueForKey:constKeyDontExportExformats] ;
    [self setPrimitiveDontExportExformats:newValue] ;
    [self didChangeValueForKey:constKeyDontExportExformats] ;
}

// This is required to trigger -[BkmxDoc objectWillChangeNote:]
- (void)setDontVerify:(NSNumber*)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeyDontVerify] ;
	[self willChangeValueForKey:constKeyDontVerify] ;
    [self setPrimitiveDontVerify:newValue] ;
    [self didChangeValueForKey:constKeyDontVerify] ;
}

// This is required to trigger -[BkmxDoc objectWillChangeNote:]
// In this case, however, it may be redundant.  I put it in
// so that when, in -[BkmxDoc objectWillChangeNote:], when
// -[Stark setDupe:nil] is sent, this would re-invoke
// -[BkmxDoc objectWillChangeNote:] with the dupe as the object.
// It does, however the dupe gets deleted anyhow, probably
// because the Delete rule starks<->>dupe is set to Nullify.
// Here are the notifications received by -[BkmxDoc objectWillChangeNote:]
// when a stark which is one of two starks in a dupe is set
// isAllowedDupe = YES:
//       OBJECT     KEY                     VALUE CHANGE
//       Stark      isAllowedDupe           NO->YES
//       Stark (*)  dupe                    a Dupe -> nil
//       Dupe       starks                  2 starks -> 1 stark
//       Dupetainer dupes                   Remove 1 dupe
//       Dupe       dupetainer              Set to nil
// 2x:   Bookshig   lastDupesMaybeLess      current date
// If I remove the following implementation, then the
// notification marked (*) does not occur, but the Dupe
// still is removed from the Duplicates Report OK.
- (void)setDupe:(Dupe*)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeyDupe] ;
	[self willChangeValueForKey:constKeyDupe] ;
    [self setPrimitiveDupe:newValue] ;
    [self didChangeValueForKey:constKeyDupe] ;
}

// This is required to trigger -[BkmxDoc objectWillChangeNote:]
- (void)setFavicon:(NSData*)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeyFavicon] ;
	[self willChangeValueForKey:constKeyFavicon] ;
    [self setPrimitiveFavicon:newValue] ;
    [self didChangeValueForKey:constKeyFavicon] ;
}

// This is required to trigger -[BkmxDoc objectWillChangeNote:]
- (void)setFaviconUrl:(NSString*)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeyFaviconUrl] ;
	[self willChangeValueForKey:constKeyFaviconUrl] ;
    [self setPrimitiveFaviconUrl:newValue] ;
    [self didChangeValueForKey:constKeyFaviconUrl] ;	
}

- (void)setIsAllowedDupe:(NSNumber*)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeyIsAllowedDupe] ;
	[self willChangeValueForKey:constKeyIsAllowedDupe] ;
    [self setPrimitiveIsAllowedDupe:newValue] ;
    [self didChangeValueForKey:constKeyIsAllowedDupe] ;
}

// This is required to trigger -[BkmxDoc objectWillChangeNote:]
- (void)setIsAutotab:(id)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeyIsAutoTab] ;
	[self willChangeValueForKey:constKeyIsAutoTab] ;
    [self setPrimitiveIsAutotab:newValue] ;
    [self didChangeValueForKey:constKeyIsAutoTab] ;
}

// This is required to trigger -[BkmxDoc objectWillChangeNote:]
- (void)setIsShared:(NSNumber*)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeyIsShared] ;
	[self willChangeValueForKey:constKeyIsShared] ;
    [self setPrimitiveIsShared:newValue] ;
    [self didChangeValueForKey:constKeyIsShared] ;
}

- (void)setLastChengDate:(NSDate*)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeyLastChengDate] ;
	[self willChangeValueForKey:constKeyLastChengDate] ;
    [self setPrimitiveLastChengDate:newValue] ;
    [self didChangeValueForKey:constKeyLastChengDate] ;
}

- (void)setLastModifiedDate:(NSDate*)newValue  {
	[self willChangeValueForKey:constKeyLastModifiedDate] ;
    [self setPrimitiveLastModifiedDate:newValue] ;
    [self didChangeValueForKey:constKeyLastModifiedDate] ;
}

- (void)setLastVisitedDate:(NSDate*)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeyLastVisitedDate] ;
	[self willChangeValueForKey:constKeyLastVisitedDate] ;
    [self setPrimitiveLastVisitedDate:newValue] ;
    [self didChangeValueForKey:constKeyLastVisitedDate] ;
}

// This is required to trigger -[BkmxDoc objectWillChangeNote:]
- (void)setName:(NSString*)newValue  {
    NSInteger originalLength = newValue.length;
    newValue = [newValue stringByReplacingNewlinesWithSpaces] ;
    newValue = [newValue stringByReplacingCharactersInSet:[NSCharacterSet controlCharacterSet] withString:@""];
    if (originalLength != newValue.length) {
        [[BkmxBasis sharedBasis] logFormat:@"Removed bad chars in \"%@\"", newValue];
    }
    if (newValue.length == 0) {
        newValue = nil;
    }
        
	// Don't notice name changes for separators...
	if ([self sharypeCoarseValue] != SharypeCoarseNotch) {
		[self postWillSetNewValue:newValue
						   forKey:constKeyName] ;
	}
    
	[self willChangeValueForKey:constKeyName] ;
    [self setPrimitiveName:newValue] ;
    [self didChangeValueForKey:constKeyName] ;
}

// This is required to trigger -[BkmxDoc objectWillChangeNote:]
- (void)setRating:(NSNumber*)newValue {
	[self postWillSetNewValue:newValue
					   forKey:constKeyRating] ;
	[self willChangeValueForKey:constKeyRating] ;
    [self setPrimitiveRating:newValue] ;
    [self didChangeValueForKey:constKeyRating] ;
}

/*!
 @details  During testing of BookMacster 1.11.1, I got a few bookmarks
 with a rating of NSNumber with value zero (0).  I'm not sure how.
 Maybe something in my initial use of EDStarRating before I made it
 into SSYStarRatingView.  Also, and more importantly, -[Stark(Sorting) compare:]
 will raise an exception when sorting by rating when nil is passed to 
 -[NSNumber compare:].  
*/
- (NSNumber*)rating  {
	[self willAccessValueForKey:constKeyRating] ;
	NSNumber* rating = [self primitiveRating] ;
	[self didAccessValueForKey:constKeyRating] ;
	if (!rating) {
		rating = [NSNumber numberWithInteger:0] ;
	}
	
	return rating ;
}

- (void)setSharype:(NSNumber *)value {
	[self postWillSetNewValue:value
					   forKey:constKeySharype] ;

    [self willChangeValueForKey:@"sharype"] ;
    [self setPrimitiveSharype:value] ;
    [self didChangeValueForKey:@"sharype"] ;
	
	if (([value sharypeValue] == SharypeSeparator) || [self isHartainer]) {
		[self setSortDirective:[NSNumber numberWithInteger:BkmxSortDirectiveNotApplicable]] ;
	}
}

// This is required to trigger -[BkmxDoc objectWillChangeNote:]
- (void)setShortcut:(NSString*)newValue  {
	if ([newValue length] == 0) {
		newValue = nil ;
	}

	[self postWillSetNewValue:newValue
					   forKey:constKeyShortcut] ;
	[self willChangeValueForKey:constKeyShortcut] ;
    [self setPrimitiveShortcut:newValue] ;
    [self didChangeValueForKey:constKeyShortcut] ;
}

// This is required to trigger -[BkmxDoc objectWillChangeNote:]
- (void)setSortable:(NSNumber*)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeySortable] ;
	[self willChangeValueForKey:constKeySortable] ;
    [self setPrimitiveSortable:newValue] ;
    [self didChangeValueForKey:constKeySortable] ;
}

// This is required to trigger -[BkmxDoc objectWillChangeNote:]
- (void)setSortDirective:(NSNumber*)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeySortDirective] ;
	[self willChangeValueForKey:constKeySortDirective] ;
    [self setPrimitiveSortDirective:newValue] ;
    [self didChangeValueForKey:constKeySortDirective] ;
}

// The following accessor customizations are not needed to postWillSetNewValue:forKey:
// because they are really just transient attributes.
// - (void)setSponsoredIndex:()newValue  {
// - (void)setSponsorIndex:()newValue  {

// Custom setters for setTags: are required to trigger -[BkmxDoc objectWillChangeNote:],
// in addition to removing duplicate tags and sorting them alphabetically.
- (void)setRawTags:(NSArray*)newTags {
	[self postWillSetNewValue:newTags
					   forKey:constKeyTags] ;
	[self willChangeValueForKey:constKeyTags];
	[self setPrimitiveTags:[NSOrderedSet orderedSetWithArray:newTags]];
	[self didChangeValueForKey:constKeyTags];
}
- (void)setTags:(NSArray*)newTags {
	NSArray* bookMacstrifiedTags = [newTags bookMacstrifiedTags] ;
    
    /*
     The following if() was added in BookMacster 1.17 when I found that, 
     54% of the time, when the Content View loaded, when bindings were being
     initialized, the selected stark (the first one in the outline view)
     would have its tags re-set to the same value which they were.  This
     would dirty the document (-setChangeType:NSChangeDone, -isDocumentEdited
     became YES, which would cause Dropbox pingponging on the next autosave.
     The pingponging was never infinite; possibly it was ended at any iteration
     with 54% probability.  I assume the 54% came from the randomness of
     nib unarchiving, although it was not correlated to whether the outline
     view or the detail view got -awakeFromNib first.  The call stack of this
     strange tag setting is shown at the end of this file, see Note WeirdyTabSet
     */
    if (![NSArray isEqualHandlesNilObject1:[self tags]
                                   object2:bookMacstrifiedTags]) {
        [self setRawTags:bookMacstrifiedTags] ;
    }
}

- (NSArray*)tags {
    return [(NSOrderedSet*)[self primitiveTags] array];
}

- (NSString*)tagStringForHash {
    return [[[self tags] valueForKey:constKeyString] componentsJoinedByString:@""];
}

- (BOOL)separatorify {
    NSObject <Hartainertainer, StarkReplicator, Startainer>* owner = [self owner];
    BOOL didDoUrl = NO;
    if ([owner canEditSeparatorsInAnyStyle]) {
        if (![[owner unsupportedAttributesForSeparators] member:constKeyName]) {
            NSString* expectedName = [[BkmxBasis sharedBasis] labelSeparator];
            if (![self.name isEqualToString:expectedName]) {
                self.name = expectedName;
            }
        }
        
        if (![[owner unsupportedAttributesForSeparators] member:constKeyUrl]) {
            if (self.url.length == 0) {
                /* Add a dot near the end to mimic a domain with a top level domain at
                 the end.  This is in case Safari ever starts implementing more
                 rigorous URL validation or normalization. */
                NSString* uuid = [SSYUuid compactUuid];
                NSInteger divider = uuid.length - 3;
                if (divider > 1) {
                    uuid = [NSString stringWithFormat:
                            @"%@.%@",
                            [uuid substringToIndex:divider],
                            [uuid substringFromIndex:divider]
                            ];
                }
                NSString* url = [[NSString alloc] initWithFormat:
                                 @"%@%@",
                                 constSeparatorUrlScheme,
                                 uuid];
                
                [owner chaker].isActive = NO;
                self.url = url;
                [owner chaker].isActive = YES;
                
                [url release];
            }
        
            didDoUrl = YES;
        }
    }

    return didDoUrl;
}

// This is required to trigger -[BkmxDoc objectWillChangeNote:]
- (void)setToRead:(NSNumber*)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeyToRead] ;
	[self willChangeValueForKey:constKeyToRead] ;
    [self setPrimitiveToRead:newValue] ;
    [self didChangeValueForKey:constKeyToRead] ;
}

- (void)setUrl:(NSString *)newValue  {
    newValue = [newValue normalizedUrl] ;
	
	[self postWillSetNewValue:newValue
					   forKey:constKeyUrl] ;

	[self willChangeValueForKey:constKeyUrl] ;
    [self setPrimitiveUrl:newValue] ;
    [self didChangeValueForKey:constKeyUrl] ;
}

- (void)setVerifierCode:(NSNumber*)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeyVerifierCode] ;
	[self willChangeValueForKey:constKeyVerifierCode] ;
    [self setPrimitiveVerifierCode:newValue] ;
    [self didChangeValueForKey:constKeyVerifierCode] ;
}

- (void)setVerifierDisposition:(NSNumber*)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeyVerifierDisposition] ;
	[self willChangeValueForKey:constKeyVerifierDisposition] ;
    [self setPrimitiveVerifierDisposition:newValue] ;
    [self didChangeValueForKey:constKeyVerifierDisposition] ;
}

- (void)setVerifierLastDate:(NSDate*)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeyVerifierLastDate] ;
	[self willChangeValueForKey:constKeyVerifierLastDate] ;
    [self setPrimitiveVerifierLastDate:newValue] ;
    [self didChangeValueForKey:constKeyVerifierLastDate] ;
}

- (void)setVerifierSubtype302:(NSNumber*)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeyVerifierSubtype302] ;
	[self willChangeValueForKey:constKeyVerifierSubtype302] ;
    [self setPrimitiveVerifierSubtype302:newValue] ;
    [self didChangeValueForKey:constKeyVerifierSubtype302] ;
}

// This is required to trigger -[BkmxDoc objectWillChangeNote:]
- (void)setVisitor:(NSString*)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeyVisitor] ;
	[self willChangeValueForKey:constKeyVisitor] ;
    [self setPrimitiveVisitor:newValue] ;
    [self didChangeValueForKey:constKeyVisitor] ;
}

@dynamic visitorWindowFrame ;

- (void)setVisitorWindowFrame:(NSString*)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeyVisitorWindowFrame] ;
	[self willChangeValueForKey:constKeyVisitorWindowFrame] ;
    [self setPrimitiveVisitorWindowFrame:newValue] ;
    [self didChangeValueForKey:constKeyVisitorWindowFrame] ;
}


#pragma mark * Accessors for Owner Values (Extore-owned Starks only)

@synthesize ownerValues = m_ownerValues ;

- (NSDictionary*)ownerValues {
	// I'm not sure if the @synthesize getter will do this or not…
	return [NSDictionary dictionaryWithDictionary:m_ownerValues] ;
}

- (void)setOwnerValues:(NSDictionary*)newValues {
	// The next if() is to avoid extraneous change notifications and/or undo registrations.
	if (![NSDictionary isEqualHandlesNilObject1:m_ownerValues
										object2:newValues]) {
		[m_ownerValues release] ;
		m_ownerValues = [newValues mutableCopy] ;
	}
}

- (id)ownerValueForKey:(id)key {
	return [[self ownerValues] objectForKey:key] ;
}

- (void)setOwnerValue:(id)newValue
			   forKey:(id)key {
	if (!key) {
		return ;
	}

	NSObject* oldValue = [[self ownerValues] objectForKey:key] ;
	// The next if() is to avoid extraneous change notifications and/or undo registrations.
	if (![NSObject isEqualHandlesNilObject1:oldValue
									object2:newValue]) {
		NSDictionary* oldValues = [self ownerValues] ;
		if (!oldValues) {
			oldValues = [[NSMutableDictionary alloc] init] ;
			[self setOwnerValues:oldValues] ;
			[oldValues release] ;
		}
		
		[self setOwnerValues:[oldValues dictionaryBySettingValue:newValue
														  forKey:key]] ;
	}
}				


#pragma mark * Accessors for Sub-Attribs Stored in Dics

- (void)setVerifierDetails:(NSDictionary*)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeyVerifierDetails] ;
	[self willChangeValueForKey:constKeyVerifierDetails] ;
    [self setPrimitiveVerifierDetails:newValue] ;
    [self didChangeValueForKey:constKeyVerifierDetails] ;
}

- (void)setVerifierDetail:(id)value
				   forKey:(id)key {
    if (![self isAvailable]) {
        return ;
    }
    
	// Need key and value
	if (key) {
		NSDictionary* dic = [self verifierDetails] ;
		
		if (dic) {
			dic = [dic dictionaryBySettingValue:value
										  forKey:key] ;
		}
		else if (value) {
			dic = [NSDictionary dictionaryWithObject:value
											  forKey:key] ;
		}
		
		[self setVerifierDetails:dic] ;
	}
}				

/*!
 @details  Used for binding to in -[StarkTableColumn setUserDefinedAttribute:]
*/
- (NSString*)verifierDispositionDisplayName {
	NSNumber* n = [self verifierDisposition] ;
	NSString* s = [n verifierDispositionDisplayName] ;
	return s ;
}
+ (NSSet*)keyPathsForValuesAffectingVerifierDispositionDisplayName {
	return [NSSet setWithObjects:
			@"verifierDisposition",
			nil] ;
}

/*!
 @details  Used for binding to in -[StarkTableColumn setUserDefinedAttribute:]
 */
- (NSString*)addDateDisplayName {
	return [[self addDate] medDateShortTimeString] ;
}
+ (NSSet*)keyPathsForValuesAffectingAddDateDisplayName {
	return [NSSet setWithObjects:
			constKeyAddDate,
			nil] ;
}

/*!
 @details  Used for binding to in -[StarkTableColumn setUserDefinedAttribute:]
 */
- (NSString*)lastModifiedDateDisplayName {
	return [[self lastModifiedDate] medDateShortTimeString] ;
}
+ (NSSet*)keyPathsForValuesAffectingLastModifiedDateDisplayName {
	return [NSSet setWithObjects:
			constKeyLastModifiedDate,
			nil] ;
}

/*!
 @details  Used for binding to in -[StarkTableColumn setUserDefinedAttribute:]
 */
- (NSString*)lastVisitedDisplayName {
	return [[self lastVisitedDate] medDateShortTimeString] ;
}
+ (NSSet*)keyPathsForValuesAffectingLastVisitedDisplayName {
	return [NSSet setWithObjects:
			constKeyLastVisitedDate,
			nil] ;
}

- (NSArray*)verifierAdviceArray {
	return [[self verifierDetails] objectForKey:constKeyVerifierAdviceArray] ;
} 
+ (NSSet*)keyPathsForValuesAffectingVerifierAdviceArray {
	return [NSSet setWithObjects:
			@"verifierDetails",
			nil] ;
}

- (void)setVerifierAdviceArray:(NSString*)value {
	[self setVerifierDetail:value
					 forKey:constKeyVerifierAdviceArray] ;
}

// Read-only:
- (NSString*)verifierAdviceWithDelimiter:(NSString*)delimiter {
	NSMutableString* string = [[NSMutableString alloc] init] ;
	
	for (NSNumber* nextAdvice in [self verifierAdviceArray]) {
		if ([string length] > 0) {
			[string appendString:delimiter] ;
		}

		NSInteger iAdvice = [nextAdvice integerValue] ;
		switch (iAdvice) {
			case advUpdated:
				[string appendString:[NSString localizeFormat:@"advUpdated", [[BkmxBasis sharedBasis] appNameLocalized]]] ;
				break ;
			case advTooManyRedirects:
				[string appendString:[NSString localize:@"advTooManyRedirects"]] ;
				break ;
			case advFileGone:
				[string appendString:[NSString localize:@"advFileGone"]] ;
				break ;
			case advUntrusted:
				[string appendString:[NSString localize:@"advUntrusted"]] ;
				break ;
			case advBadRedirect:
				[string appendString:[NSString localizeFormat:@"advBadRedirect", [[BkmxBasis sharedBasis] appNameLocalized]]] ;
				break ;
			case advTryAgain:
				[string appendString:[NSString localize:@"advTryAgain"]] ;
				break ;
			case advHostGone:
				[string appendString:[NSString localize:@"advHostGone"]] ;
				break ;
			case advBadURL:
				[string appendString:[NSString localizeFormat:
									  @"advBadURL",
									  [NSString localize:@"080_falseAlarm"]]] ;
				break ;
			case advPageGone:
				[string appendString:[NSString localize:@"advPageGone"]] ;
				break ;
			case advNewPageSameDomainBkmx:
				[string appendString:[NSString localize:@"advNewPageSameDomainBkmx"]] ;
				break ;
			case adv400to403:
				[string appendString:[NSString localize:@"adv400to403"]] ;
				break ;
			case advVacuumCleaner:
				[string appendString:[NSString localize:@"advVacuumCleaner"]] ;
				break ;
			case adv302:
				[string appendString:[NSString localize:@"adv302"]] ;
				break ;
			case advFalseAlarm:
				[string appendString:[NSString localize:@"advFalseAlarm"]] ;
				break ;
			case advRSS:
				[string appendString:[NSString localize:@"advRSS"]] ;
				break ;
			case advIfOK:
				[string appendString:[NSString localize:@"advIfOK"]] ;
				break ;
			default:
				break ;
		}
	}
	
	NSString* answer = [string copy] ;
	[string release] ;
	
	return [answer autorelease] ;
}

// Read-only:
- (NSString*)verifierAdviceOneLiner {
	return [self verifierAdviceWithDelimiter:@"  "] ;
}

+ (NSSet*)keyPathsForValuesAffectingVerifierAdviceOneLiner {
	return [NSSet setWithObjects:
			@"verifierDetails",
			nil] ;
}

// Read-only:
- (NSString*)verifierAdviceMultiLiner {
	return [self verifierAdviceWithDelimiter:@"\n\n"] ;
}

+ (NSSet*)keyPathsForValuesAffectingVerifierAdviceMultiLiner {
	return [NSSet setWithObjects:
			@"verifierDetails",
			nil] ;
}

// Added in BookMacster 1.6.3 
// Bound to in Inspector
- (NSString*)verifierLastDateString {
	return [[self verifierLastDate] medDateShortTimeString] ;
}
+ (NSSet*)keyPathsForValuesAffectingVerifierLastDateString {
	return [NSSet setWithObjects:
			@"verifierLastDate",
			nil] ;
}



// Read-only:
- (NSString*)verifierByline {
	NSString* byline ;
	if ([self verifierCodeValue] > 0) {
		byline = @"websiteSays" ;
	}
	else if ([self verifierCodeValue] < 0) {
		byline = @"yourMacSays" ;
	}
	else {
		// verifierCodeValue is 0
		byline = nil ;
	}
	
	return [[NSString localize:byline] colonize] ;
}

+ (NSSet*)keyPathsForValuesAffectingVerifierByLine {
	return [NSSet setWithObjects:
			@"verifierCode",
			nil] ;
}

// Read-only:
- (NSString*)verifierCodeAndReason {
	NSString* string = nil ;
	NSInteger codeValue = [self verifierCodeValue] ;
	if (codeValue != 0) {
		string = [NSString stringWithFormat:@"%ld", (long)codeValue] ;
		NSString* reason = [self verifierReason] ;
		if (reason) {
			string = [string stringByAppendingFormat:@" \"%@\"", reason] ;
		}
	}
	
	return string ;
}

+ (NSSet*)keyPathsForValuesAffectingVerifierCodeAndReason {
	return [NSSet setWithObjects:
			@"verifierCode",
			@"verifierDetails",
			nil] ;
}

// Read-only:
- (NSString*)verifierLastResult {	
	NSString* string = [self verifierCodeAndReason] ;
	
	// Compute date appendage
	NSString* dateString = @"" ;
	NSDate* date = [self verifierLastDate] ;
	if (date) {
		dateString = [NSString stringWithFormat:
					  @"  [%@]",
					  [date medDateShortTimeString]] ;
	}

	// Compute, if needed, the "was verified with different url" appendage.
	NSString* urlString = @"" ;
	NSString* verifierUrl = [self verifierUrl] ;
	if (![NSString isEqualHandlesNilString1:[self url]
									string2:verifierUrl]) {
		urlString = [NSString stringWithFormat:
					 @"  (%@)",
					 [NSString localizeFormat:
					  @"080_verifyPriorX",
					  verifierUrl]] ;
	}
	
	return [[string stringByAppendingString:dateString] stringByAppendingString:urlString] ;
} 

+ (NSSet*)keyPathsForValuesAffectingVerifierLastResult {
	return [NSSet setWithObjects:
			@"verifierCode",
			@"verifierDetails",
			@"verifierDisposition",
			@"verifierLastDate",
			nil] ;
}

- (NSString*)verifierNSErrorDomain {
	return [[self verifierDetails] objectForKey:constKeyVerifierNsErrorDomain] ;
} 

+ (NSSet*)keyPathsForValuesAffectingVerifierNSErrorDomain {
	return [NSSet setWithObjects:
			@"verifierDetails",
			nil] ;
}

- (void)setVerifierNSErrorDomain:(NSString*)value {
	[self setVerifierDetail:value
					 forKey:constKeyVerifierNsErrorDomain] ;
}

- (NSString*)verifierPriorUrl {
	return [[self verifierDetails] objectForKey:constKeyVerifierPriorUrl] ;
} 

+ (NSSet*)keyPathsForValuesAffectingVerifierPriorUrl {
	return [NSSet setWithObjects:
			@"verifierDetails",
			nil] ;
}

- (void)setVerifierPriorUrl:(NSString*)value {
	[self setVerifierDetail:value
					 forKey:constKeyVerifierPriorUrl] ;
}

- (NSString*)verifierReason {
	return [[self verifierDetails] objectForKey:constKeyVerifierReason] ;
} 

+ (NSSet*)keyPathsForValuesAffectingVerifierReason {
	return [NSSet setWithObjects:
			@"verifierDetails",
			nil] ;
}

- (void)setVerifierReason:(NSString*)value {
	[self setVerifierDetail:value
					 forKey:constKeyVerifierReason] ;
}

- (NSString*)verifierSuggestedUrl {
	return [[self verifierDetails] objectForKey:constKeyVerifierSuggestedUrl] ;
} 

+ (NSSet*)keyPathsForValuesAffectingVerifierSuggestedUrl {
	return [NSSet setWithObjects:
			@"verifierDetails",
			nil] ;
}

- (void)setVerifierSuggestedUrl:(NSString*)value {
	[self setVerifierDetail:value
					 forKey:constKeyVerifierSuggestedUrl] ;
}

- (NSString*)verifierUrl {
	return [[self verifierDetails] objectForKey:constKeyVerifierUrl] ;
} 

+ (NSSet*)keyPathsForValuesAffectingVerifierUrl {
	return [NSSet setWithObjects:
			@"verifierDetails",
			nil] ;
}

- (void)setVerifierUrl:(NSString*)value {
	[self setVerifierDetail:value
					 forKey:constKeyVerifierUrl] ;
}

- (NSString*)verifierCodeUsingHttps {
    return [[self verifierDetails] objectForKey:constKeyVerifierCodeUsingHttps] ;
}

+ (NSSet*)keyPathsForValuesAffectingVerifierCodeUsingHttps {
    return [NSSet setWithObjects:
            @"verifierDetails",
            nil] ;
}

- (void)setVerifierCodeUsingHttps:(NSString*)value {
    [self setVerifierDetail:value
                     forKey:constKeyVerifierCodeUsingHttps] ;
}

- (short)verifierCodeUsingHttpsValue {
    return [[self verifierCodeUsingHttps] shortValue] ;
}

- (void)setVerifierCodeUsingHttpsValue:(short)newValue {
    [self setVerifierCodeUsingHttps:[NSNumber numberWithShort:newValue]] ;
}

#pragma mark * Exid Accessors


/*!
 @brief    Sets only the ivar, not the persistent store

 @details  Use this for efficiency instead of -setExids:
 when you have just read the new 'exids' out of Exids-*.sql
 store and know there is no need to re-set its value.
*/
- (BOOL)setIvarOnlyExids:(NSDictionary*)exids {
	BOOL result = NO ;
	@synchronized(self) {
		if (![NSObject isEqualHandlesNilObject1:m_exids
										object2:exids]) {
			[m_exids release] ;
			m_exids = exids ;
			[m_exids retain] ;

			result = YES ;
		}
	}
	
	return result ;
}

- (NSDictionary*)exids {
	NSDictionary* exids ;
	@synchronized(self) {
		exids = [[m_exids retain] autorelease] ;
	}
	return exids ;
}

- (void)setExids:(NSDictionary*)exids {
	BOOL anyDifference = [self setIvarOnlyExids:exids] ;
	
	if (anyDifference) {
		// If owner is an Extore, [self starxider] will be nil, and
		// the following is a no-op.  We only setAllExids:forStark:
		// if the stark is owned by a BkmxDoc.
        Starxider* starxider = [self starxider] ;
		[starxider setAllExids:exids
                      forStark:self] ;
    }
}

- (void)appendExids:(NSDictionary*)newExids {
	if (![newExids count]) {
		return ;
	}
	
	NSDictionary* exids = [self exids] ;
	if (exids) {
		exids = [exids dictionaryByAppendingEntriesFromDictionary:newExids] ;
	}
	else {
		exids = newExids ;
	}
	[self setExids:exids] ;
}


- (NSString*)exidForClientoid:(Clientoid*)clientoid {
	NSDictionary* exids = [self exids] ;
	NSString* exid = [exids objectForKey:clientoid] ;
	return exid ;
}

- (void)setExid:(NSString*)exid
   forClientoid:(Clientoid*)clientoid {
	if (!clientoid) {
		// This will happen, for example, if a Safari bookmark item is dragged and
		// dropped onto our Content Outline View, which invokes
		// +[ExtoreSafari starkFromExtoreNode:::] with nil clientoid.
		return ;
	}
	
	// Note that if exid parameter is nil, we must remove it from exids
	NSDictionary* exids = [self exids] ;
	NSString* existingExid = [exids objectForKey:clientoid] ;
	if (exid) {
		// New value is non-nil
		if (![existingExid isEqualToString:exid]) {
			// Existing value is either nil, or needs updating
			if (exids) {
				exids = [exids dictionaryBySettingValue:exid
												 forKey:clientoid] ;
			}
			else {
				exids = [NSDictionary dictionaryWithObject:exid
													forKey:clientoid] ;
			}
			[self setExids:exids] ;
		}
	}
	else {
		// New value is nil
		if (existingExid) {
			// Old value is non-nil

			exids = [exids dictionaryByRemovingObjectForKey:clientoid] ;
			[self setExids:exids] ;
		}
	}
}

- (void)makeCheesyMissingExidsForExtore:(Extore*)extore {
	Clientoid* clientoid = [[extore client] clientoid] ;
	if (![self exidForClientoid:clientoid]) {
		NSString* exid = [extore cheesyExidForStark:self] ;
		[self setExid:exid
		 forClientoid:clientoid] ;
	}
}

- (void)setFreshExidForClientoid:(Clientoid*)clientoid
						  extore:(Extore*)extore
						 tryHard:(BOOL)tryHard {
    NSString* exid = nil ;
    [extore getFreshExid_p:&exid
                higherThan:0
                  forStark:self
                   tryHard:tryHard] ;
    
    // Note that we may be setting the exid to nil if the above failed.
    [self setExid:exid
     forClientoid:clientoid] ;
#if USE_STARK_EXID_ASSERTIONS
    NSAssert1(![self mocIsLocal], @"Adding fresh per-client exid to local moc for %@", [self shortDescription]) ;
#endif
}

- (void)setFreshExidForExtore:(Extore*)extore
                      tryHard:(BOOL)tryHard {
    NSString* exid = nil ;
    [extore getFreshExid_p:&exid
                higherThan:0
                  forStark:self
                   tryHard:tryHard] ;
    
    // Note that we may be setting the exid to nil if the above failed.
    [self setExid:exid] ;
#if USE_STARK_EXID_ASSERTIONS
    NSAssert1([self mocIsLocal], @"Adding fresh singlular exid to non-local moc for %@", [self shortDescription]) ;
#endif
}

- (void)getOrMakeValidExid_p:(NSString**)exid_p
					  extore:(Extore*)extore
			   isAfterExport:(BOOL)isAfterExport
					 tryHard:(BOOL)tryHard {
	Clientoid* clientoid = [[extore client] clientoid] ;
	*exid_p = [self exidForClientoid:clientoid] ;
	if (![extore validateExid:*exid_p
				isAfterExport:isAfterExport
					 forStark:self]) {
		*exid_p = nil ;
	}
	
#if USE_STARK_EXID_ASSERTIONS
	NSAssert1(![self mocIsLocal], @"Adding fresh per-client exid to local moc for %@", [self shortDescription]) ;
#endif
	if (!*exid_p) {
        [self setFreshExidForClientoid:clientoid
                                extore:extore
                               tryHard:tryHard] ;
        // Get the new exid (or nil) which has just been set
        *exid_p = [self exidForClientoid:clientoid] ;
	}
}

#pragma mark * Shallow Value-Added Getters 

- (NSNumber*)isExpanded {
	Starlobuter* starlobuter = [self starlobuter] ;
	NSNumber* isExpanded ;
	if (starlobuter) {
		// This stark is owned by a BkmxDoc.
		isExpanded = [starlobuter isExpandedStark:self] ;
	}
	else {
		isExpanded = [NSNumber numberWithBool:m_isExpanded] ;
	}
	
	return isExpanded ;
}

- (void)setIsExpanded:(NSNumber*)isExpanded {
	Starlobuter* starlobuter = [self starlobuter] ;
	if (starlobuter) {
		// This stark is owned by a BkmxDoc.
		[starlobuter setIsExpanded:isExpanded
						  forStark:self] ;
	}
	else {
		m_isExpanded = [isExpanded boolValue] ;
	}	
}

- (BOOL)is1PasswordBookmarklet {
	// Actually, in the only usage of this method, there will be only
	// one Clientoid and the following loop will only execute once.
	// In other words, this method is overly "smart", but oh, well.
	for (Clientoid* clientoid in [self exids]) {
		// Since UUIDs are unique, I do not bother to see if the
		// clientoid's extore is Safari.  I believe it may be more
		// efficient to just check the uuid:
		NSString* uuid = [[self exids] objectForKey:clientoid] ;
		if ([uuid isEqualToString:@"712DEBA5-C732-4F24-8CBF-AF10705DC06C"]) {
			return YES ;
		}
		if ([uuid isEqualToString:@"6E4D0FC0-93EC-407A-A702-CC6176952D96"]) {
			return YES ;
		}
		// Added in BookMacster 1.1.17…
		// The new "Safari Logins Bookmarklet" for the 1Password iPhone app,
		// described here, http://help.agile.ws/1Password3/logins_bookmarklet.html
		// does not produce a unique UUID.  However, it produces a UUID which,
		// unlike Safari's UUIDs, has no dashes in it, so it is only 32 characters.
		// and also it has ~60 occurrences of the string "my1Password", but
		// I thought it best to just do the UUID in case they change that
		if (
			[[clientoid exformat] isEqualToString:constExformatSafari] 
			&&
			([uuid length] == 32)
			) {
			return YES ;
		}
	}
	
	return NO ;
}

- (NSNumber*)effectiveIndex {
	if ([self sponsorIndex] && ([[self sponsorIndex] shortValue] != -1)) {
		return [self sponsoredIndex] ;
	}
	else {
		return [self index] ;
	}
}

- (NSString*)textSummaryWithTemplate:(NSString*)aTemplate {
    NSScanner* scanner = [[NSScanner alloc] initWithString:aTemplate];
    NSMutableString* result = [NSMutableString new];
    while (![scanner isAtEnd]) {
        NSString* substring;
        if ([scanner scanUpToString:@"{"
                         intoString:&substring]) {
            [result appendString:substring];
        }
        [scanner scanString:@"{"
                 intoString:NULL];

        if ([scanner scanUpToString:@"}"
                         intoString:&substring]) {
            NSObject* attributeValue = [self valueForKey:substring];
            NSString* attributeString;
            if ([attributeValue isKindOfClass:[NSString class]]) {
                attributeString = (NSString*)attributeValue;
            } else if (attributeValue) {
                attributeString = [attributeValue description];
            } else {
                attributeString = @"null";
            }
            [result appendString:attributeString];
        }
        [scanner scanString:@"}"
                 intoString:NULL];
    }

    unichar tabChar = 0x09 ;
	NSString* tab = [NSString stringWithCharacters:&tabChar
                                            length:1];
    [result replaceOccurrencesOfString:@"\\t"
                            withString:tab];

    [scanner release];
    NSString* answer = [result copy];
    [result release];
    [answer autorelease];

    return answer;
}

- (NSString*)identifiersList {
	NSManagedObjectID* myID = [self objectID] ;
	NSString* uriStringRep = [[myID URIRepresentation] absoluteString] ;
	NSString* tempOrPerm = [myID isTemporaryID] ? @"temporary" : @"permanent" ;
	NSDictionary* exidsByClientoid = [self exids] ;
	NSMutableDictionary* exidsByDisplayName = [[NSMutableDictionary alloc] initWithCapacity:[exidsByClientoid count]] ;
	for (Clientoid* clientoid in exidsByClientoid) {
		NSString* displayName = [clientoid displayName] ;
		NSString* exid = [exidsByClientoid objectForKey:clientoid] ;
		[exidsByDisplayName setObject:exid
							   forKey:displayName] ;
	}
	NSMutableString* exidListMutable = [[exidsByDisplayName readable] mutableCopy] ;
	[exidsByDisplayName release] ;
	if (exidListMutable) {
		// The above test is because CF functions often crash if nil parameters.
		CFStringTrimWhitespace ((CFMutableStringRef)exidListMutable) ;
	}
	NSString* exidList ;
	if (exidListMutable) {
		exidList = [NSString stringWithString:exidListMutable] ;
		[exidListMutable release] ;
	}
	else {
		exidList = @"" ;
	}
	
	return [NSString stringWithFormat:
			@"## Internal:\nPersistent: %@\nPointer: %p\nCore Data (%@): %@\n## Clients\n%@",
			[self starkid],
            self,
			tempOrPerm,
			uriStringRep,
			exidList] ;
}

+ (NSSet*)keyPathsForValuesAffectingIdentifiersList {
	return [NSSet setWithObjects:
			constKeyExids,
			nil] ;
}

- (NSString*)nameNoNil {
	NSString* name = [self name] ;
    if (!name) {
    	name = [NSString stringWithFormat:@"(%@ %@)",
				[[NSString localize:@"no"] lowercaseString],
				[[NSString localize:@"name"] lowercaseString]] ;
    }
    
    return name ;
    
}

/*!
 @details  This implementation was added in BookMacster 1.5.7, after I
 measured its affect on performance when invoked 660,000 times and found
 that it took 12.3 seconds, same as the Core Data default implementation.
*/
- (NSString*)name {
    NSString* name ;
    /* We only want a default name if the receiver is in a BkmxDoc.  It is
     used for displaying in the Content View.  If otoh the receiver is in a
     Extore, returning a default name here will screw up hash checks,
     because, when calculating the export hash for persisting it,  the
     hartainers will return YES from -isHartainer (or will already have their
     default name, but when reading data back from the browser to verify
     later, the hartainers will return NO for -isHartainer, and/or have a non-
     nil name. */
    NSObject <Hartainertainer, StarkReplicator, Startainer>* owner = [self allocOwner];
    if ([owner isKindOfClass:[BkmxDoc class]] && [self isHartainer]) {
        name = [owner displayNameForHartainerSharype:[self sharypeValue]] ;
    }
    else {
        [self willAccessValueForKey:constKeyName] ;
        name = [self primitiveName] ;
        [self didAccessValueForKey:constKeyName] ;
	}
    [owner release];
	
	return name ;
}

- (BOOL)shouldSort {
    BkmxSortable value ;
    BOOL answer;
    switch ([[self sortable] integerValue]) {
        case BkmxSortableNo:
            answer = NO ;
            break;
        case BkmxSortableYes:
            answer = YES ;
            break;
        case BkmxSortableAsParent:
            answer = [[self parent] shouldSort] ;
            break;
        case BkmxSortableAsDefault: {
            NSObject <StarkReplicator> * owner_ = [self allocOwner];
            if ([owner_ respondsToSelector:@selector(shig)]) {
                value = (BkmxSortable)[[[(BkmxDoc*)owner_ shig] defaultSortable] integerValue] ;
                switch ((BkmxSortable)value) {
                    case BkmxSortableNo:
                        answer = NO ;
                        break;
                    case BkmxSortableYes:
                        answer = YES ;
                        break;
                    case BkmxSortableAsParent:;
                        Stark* parent = [self parent] ;
                        if (parent) {
                            answer = [parent shouldSort] ;
                            break;
                        }
                        else {
                            answer = [[[(BkmxDoc*)owner_ shig] rootSortable] boolValue] ;
                            break;
                        }
                    case BkmxSortableAsDefault:
                        answer = YES;
                        break ;
                }
            }
            else {
                NSLog(@"Internal Error 547-5539.  nil owner for %@", [self shortDescription]) ;
                answer = YES;
            }
            [owner_ release];
            break;
        }
        default:
            answer = YES;
    }

    return answer ;
}

- (NSString*)urlNoNil {
    NSString* url = [self url] ;
    return url ? url : @"" ;
}

- (NSString*)urlOrStats {
	NSString* answer = nil ;
	
	if ([self canHaveUrl]) {
		answer = [self url] ;
	}
	else if ([self canHaveChildren]) {
		NSString* stats = [self displayStatsShort] ;
		if ([stats length] > 0) {
			answer = [NSString stringWithFormat:
					  @"(%@)",
					  stats] ;
		}
	}
	
	return answer ;
}

- (void)setUrlOrStats:(NSString*)newValue {
	if ([self canHaveUrl]) {
		[self setUrl:newValue] ;
	}
	else {
		// Do nothing because stats are readonly
	}
}

// The following accessor pair are used by the user-defined columns

- (void)setVisitCount:(NSNumber*)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeyVisitCount] ;
	[self willChangeValueForKey:constKeyVisitCount] ;
    [self setPrimitiveVisitCount:newValue] ;
    [self didChangeValueForKey:constKeyVisitCount] ;
}

- (NSString*)visitCountString {
	NSNumber* visitCountNumber = [self visitCount] ;
	NSString* s ;
	if (visitCountNumber) {
		s = [NSString stringWithFormat:@"%ld", (long)[visitCountNumber integerValue]] ;
	}
	else {
		// "Not applicable"
		s = constEmDash ;
	}
	
	return s ;
}

- (void)setVisitCountString:(NSString*)string {
	[self setVisitCount:[NSNumber numberWithInteger:[string integerValue]]] ;
}


- (Sharype)sharypeValue {
	return (Sharype)[[self sharype] shortValue] ;
}

- (void)setSortDirectiveValue:(BkmxSortDirective)newValue {
	[self setSortDirective:[NSNumber numberWithShort:newValue]] ;
}

- (BkmxSortDirective)sortDirectiveValue {
	return (BkmxSortDirective)[[self sortDirective] shortValue] ;
}

- (BOOL)isHartainer {
	return ([StarkTyper isHartainerCoarseSharype:[self sharypeValue]]) ;
}

- (BOOL)isBookmacsterizer {
	return ([[self url] hasPrefix:constUrlBookmacsterizerSignaturePrefix]) ;
}

- (BOOL)isRoot {
	return ([self sharypeValue] == SharypeRoot) ;
}

- (BOOL)isInBar
{
	Stark* item = self ;
	Stark* parent = nil ;
	
	do
	{
		parent = [item parent] ;
		if ([parent sharypeValue] == SharypeBar) {
			return YES ;
		}
		if (parent) {
			item = parent ;
		}
	}
	while (parent) ;
	
	return NO ;	
}

- (BOOL)isInMenu
{
	Stark* item = self ;
	Stark* parent = nil ;
	
	do
	{
		parent = [item parent] ;
		if ([parent sharypeValue] == SharypeMenu) {
			return YES ;
		}
		if (parent) {
			item = parent ;
		}
	}
	while (parent) ;
	
	return NO ;	
}

- (BOOL)isInOhared
{
	Stark* item = self ;
	Stark* parent = nil ;
	
	do
	{
		parent = [item parent] ;
		if ([parent sharypeValue] == SharypeOhared) {
			return YES ;
		}
		if (parent) {
			item = parent ;
		}
	}
	while (parent) ;
	
	return NO ;	
}

- (BOOL)canAdoptChild:(Stark*)item {
	StarkLocation* location_ = [StarkLocation starkLocationWithParent:self
																index:NSNotFound] ;
	return ([location_ canInsertItems:[NSArray arrayWithObject:item]
                                  fix:StarkLocationFixNone
                          outlineView:nil] > StarkCanParentNopeDemarcation) ;
}

- (NSArray*)subfoldersOrdered {
    NSMutableArray* subfolders = [[NSMutableArray alloc] init] ;
	for (Stark* child in [self childrenOrdered]) {
		if ([child canHaveChildren]) {
        	[subfolders addObject:child] ;
        }
    }
    
	NSArray* output = [subfolders copy] ;
	[subfolders release] ;
	return [output autorelease] ;
}

- (NSInteger)numberOfSubfolders {
	NSInteger count = 0 ;
	
	for (Stark* child in [self children]) {
		if ([child canHaveChildren]) {
        	count++ ;
        }
    }
	
	return count ;
}

- (NSInteger)numberOfBookmarks {
	NSInteger count = 0 ;
	
	for (Stark* child in [self children]) {
		if ([child sharypeValue] == SharypeBookmark) {
        	count++ ;
        }
    }
	
	return count ;
}

- (NSNumber*)restatedSponsorIndex {
	NSNumber* restatedSponsorIndex = [self sponsorIndex] ;
	if (!restatedSponsorIndex) {
		restatedSponsorIndex = [NSNumber numberWithShort:-1] ;
	}

	return restatedSponsorIndex ;
}

- (NSInteger)indexOfStarkWithSameUrlInArray:(NSArray*)array {
	NSInteger nItems = [array count] ;
	NSString* targetUrl = [self url] ;
	Stark* testee ;
	NSInteger i ;
	for (i=0; i<nItems; i++) {
		testee = [array objectAtIndex:i] ;
		NSString* testUrl = [testee url] ;
		if ([testUrl isEqualToString:targetUrl]) {
			break ;
		}
	}
	
	if (i >= nItems) {
		i = NSNotFound ;
	}
	
	return i ;
}

- (Stark*)starkWithSameUrlInArray:(NSArray*)array {
	NSInteger i = [self indexOfStarkWithSameUrlInArray:array] ;	
	Stark* answer = nil ;
	if (i < NSNotFound) {
		answer = [array objectAtIndex:i] ;
	}
	
	return answer ;
}

- (Stark*)firstChildOfSharype:(Sharype)sharype {
	for (Stark* child in [self childrenOrdered]) {
		if ([child sharypeValue] == sharype) {
			return child ;
		}
	}
	return nil ;
}

- (short)verifierCodeValue {
	return [[self verifierCode] integerValue] ;
}

- (void)setVerifierCodeValue:(short)newValue {
	[self setVerifierCode:[NSNumber numberWithInteger:newValue]] ;
}

/* This method is really bad.  Instead of this custom getter, I should have
 defined a method -jiggeredDisposition. */
- (NSNumber*)verifierDisposition {
	NSNumber* jiggeredDisposition = nil ;
	
	if ([self canHaveUrl]) {
		NSNumber* oCode = [self verifierCode] ;
		if (oCode) {
            [self willAccessValueForKey:constKeyVerifierDisposition] ;
            NSNumber* currentDisposition = [self primitiveVerifierDisposition] ;
            [self didAccessValueForKey:constKeyVerifierDisposition] ;
            
            // I believe that jiggeredDisposition might be nil at this point
            // if a previous Verify All command was cancelled during execution.
            NSInteger code = [oCode integerValue] ;
			if (code == 302) {
				// We have a primitive value for verifierDisposition, and
				// the http code is 302.
				// See whether we agreed, disagreed, or were unsure about the 302
				NSNumber* ost = [self verifierSubtype302] ;
                if (ost == nil) {
                    NSLog(@"Warning 699-3351 Expected verifierSubtype302 != nil when code=302 : %@", [self shortDescription]) ;
                }
				switch ([ost integerValue]) {
					case BkmxHttp302Agree:
						// Leave verifierDisposition at default value of BkmxFixDispoLeaveAsIs
						break ;
					case BkmxHttp302Disagree:
						// Assign from user's default value for 302 disagrees
						jiggeredDisposition = [[NSUserDefaults standardUserDefaults] objectForKey:constKeyDispose302Perm] ;
						break ;
					case BkmxHttp302Unsure:
						// Assign from user's default value for 302 disagrees
						jiggeredDisposition = [[NSUserDefaults standardUserDefaults] objectForKey:constKeyDispose302Unsure] ;
                        break ;
                    default:
                        break ;
				}
			}
			else if (code==200){
				jiggeredDisposition = [NSNumber numberWithInteger:BkmxFixDispoLeaveAsIs] ;
			}
			else {
                jiggeredDisposition = currentDisposition ;
			}
		}
		
		if (!jiggeredDisposition) {
			jiggeredDisposition = [NSNumber numberWithInteger:BkmxFixDispoToBeDetermined] ;
		}
	}
	else {
		jiggeredDisposition = [NSNumber numberWithInteger:BkmxFixDispoNotApplicable] ;
	}
		
	return jiggeredDisposition ;
}

- (BkmxFixDispo)verifierDispositionValue {
	return (BkmxFixDispo)[[self verifierDisposition] integerValue] ;
}

- (void)setVerifierDispositionValue:(BkmxFixDispo)newValue {
	[self setVerifierDisposition:[NSNumber numberWithInteger:newValue]] ;
}

- (StarkLocation*)location {
	return [[[StarkLocation alloc] initWithParent:[self parent]
											index:[self indexValue]] autorelease] ;
}

- (StarkLocation*)locationUp1 {
    NSObject <Hartainertainer, StarkReplicator, Startainer>* owner = [self allocOwner];
	ContentOutlineView* outline = [[(BkmxDoc*)owner bkmxDocWinCon] contentOutlineView];
    [owner release];
    ContentProxy* proxyForSelf = [[outline dataSource] proxyForStark:self];
	NSInteger row = [outline rowForItem:proxyForSelf] ;
	NSInteger index = [[self index] integerValue] ;
	Stark* myParent = [self parent] ;
	Stark* parent ;
	Stark* prevItem ;
	
	while (true) {
		// Move up one row and try again
		row-- ;
		parent = nil ;
		if (row < 0)
			// Reached top of outline, fail with parent = nil
			break ;
		prevItem = [outline starkAtRow:row] ;
		// NSLog(@"Checking previous item %@ at row %i", [prevItem name], row) ;
		if ([prevItem parent] == myParent) {
			// Found new parent which can adopt, succeed
			//NSLog(@"Can keep same parent and move up") ;
			index -- ;
			parent = myParent ;
			break ;
		}
		else if (prevItem == myParent) {
			//NSLog(@"At my parent, move up again") ;
		}
		else if ([prevItem canAdoptChild:self]) {
			// Found parent which can adopt, succeed
			// NSLog(@"prevItem %@ can adopt me", [prevItem name]) ;
			parent = prevItem ;
			index = 0 ;
			break ;
		}
		else if ([[prevItem parent] canAdoptChild:self]) {
			// NSLog(@"prevItem's parent can adopt me") ;
			parent = [prevItem parent] ;
			index = [prevItem indexValue] + 1 ;
			break ;
		}
	}
	
	return [[[StarkLocation alloc] initWithParent:parent index:index] autorelease] ;
}

- (StarkLocation*)locationDown1 {
    NSObject <Hartainertainer, StarkReplicator, Startainer>* owner = [self allocOwner];
	ContentOutlineView* outline = [[(BkmxDoc*)owner bkmxDocWinCon] contentOutlineView];
    [owner release];
    ContentProxy* proxyForSelf = [[outline dataSource] proxyForStark:self];
    NSInteger row = [outline rowForItem:proxyForSelf] ;
	NSInteger index = [self indexValue] ;
	Stark* parent ;
	
	NSInteger bottomRow = [outline numberOfRows] - 1 ;
	while (true) {
		// Move down one row and try again
		row++ ;
		parent = nil ;
		if (row > bottomRow)
			// Reached bottom of outline, fail with parent = nil
			break ;
		parent = [outline starkAtRow:row] ;
		// NSLog(@"will check new parent %@ at row %i", [parent name], row) ;
		if ([parent canAdoptChild:self]) {
			// Found parent which can adopt, succeed
			index = 0 ;
			break ;
		}
		// NSLog(@"Parent %@ is no good.", [parent name]) ;
		// Probably parent is now a bookmark, so try its parent
		index = [parent indexValue] ;
		parent = [parent parent] ;
		if (parent == nil)
			// Must have reached up to root, fail with parent = nil 
			break ;
		if ([parent canAdoptChild:self]) {
			// Found parent which can adopt, succeed
			break ;
		}
	}

	return [[[StarkLocation alloc] initWithParent:parent index:index] autorelease] ;
}


#pragma mark * Shallow Value-Added Setters 

- (Sharype)sharypeCoarseValue {
	return [StarkTyper coarseTypeSharype:[self sharypeValue]] ;
}

- (NSNumber*)sharypeCoarse {
	return [NSNumber numberWithSharype:[self sharypeCoarseValue]] ;
}
	
- (void)addTagString:(NSString*)string {
    Tagger* tagger = [[self owner] tagger];
    [tagger addTagString:string
                      to:self];
}

- (NSString*)tagsString  {
	NSString* string = [[self tags] componentsJoinedByString:@" "] ;
	return string ;
}

- (NSString*)clients  {
#if 0
#warning Clients Column Hijacked
	// return [[[self exids] allValues] firstObjectSafely] ;
    NSString* exid = @"Sorry";
    for (Clientoid* clientoid in [[self exids] allKeys]) {
        if ([clientoid.exformat hasPrefix:@"Viv"]) {
            exid = [[self exids] objectForKey:clientoid];
        }
    }
    return exid;
#else
	if ([self isHartainer]) {
		return [[BkmxBasis sharedBasis] labelNotApplicable] ;
	}
	
	NSMutableArray* displayNames = [[NSMutableArray alloc] init] ;
	for (Clientoid* clientoid in [[self exids] allKeys]) {
		NSString* displayName = [clientoid displayName] ;
		// Display name could be nil if, as I have seen, the Client is a 
		// Loose File which has been deleted, for which the alias could
		// not be resolved.  Test added in BookMacster version 1.3.19.
		if (displayName) {
			[displayNames addObject:displayName] ;
		}
	}
    // Added in BookMacster 1.13.6…
    [displayNames sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)] ;
    
	NSString* string ;
	if ([displayNames count] > 0) {
		string = [displayNames listValuesForKey:nil
								   conjunction:nil
									 truncateTo:0] ;
	}
	else {
		string = @"None" ;
	}
	[displayNames release] ;
	
	return string ;
#endif
}

+ (NSSet*)keyPathsForValuesAffectingClients {
	return [NSSet setWithObject:constKeyExids] ;
}

- (NSString*)clientsWithLabel {
	return [NSString stringWithFormat:
			@"%@: %@",
			[[BkmxBasis sharedBasis] labelClients],
			[self clients]] ;
}

+ (NSSet*)keyPathsForValuesAffectingTagsArray {
	return [NSSet setWithObject:constKeyTags] ;
}

- (void)setSharypeValue:(Sharype)value {
	[self setSharype:[NSNumber numberWithSharype:value]] ;
}

- (void)removeLegacySortedUnsortedAndAllowedDupeNameTags {
	NSString* name = [self name] ;
	
	if ([name hasSuffix:@" (&)"])
		name = [name stringByRemovingLastCharacters:4] ;
	else if ([name hasSuffix:@"(&)"])
		name = [name stringByRemovingLastCharacters:3] ;
	else if ([name hasSuffix:@" (*)"])
		name = [name stringByRemovingLastCharacters:4] ;
	else if ([name hasSuffix:@"(*)"])
		name = [name stringByRemovingLastCharacters:3] ;
	else if ([name hasSuffix:@" (+)"])
		name = [name stringByRemovingLastCharacters:4] ;
	else if ([name hasSuffix:@"(+)"])
		name = [name stringByRemovingLastCharacters:3] ;
	
	[self setName:name] ;
}

- (BOOL)mocIsLocal {
	NSManagedObjectContext* managedObjectContext = [self managedObjectContext] ;
	
    // The following line of code might be a more robust, but slower
    // alternative to the next one.  Never used it.
    // if ([[[managedObjectContext path1] pathExtension] isEqualToString:[[NSDocumentController sharedDocumentController] defaultDocumentFilenameExtension]]) {
    if ([SSYMOCManager isDocMOC:managedObjectContext]) {
		// Stark is in BkmxDoc's moc
		return NO ;
	}
    
	if ([SSYMOCManager isInMemoryMOC:managedObjectContext]) {
		// The only in-memory moc in this app is the trans ("transfer") moc
        // which is temporarily created for extores during ixports.
		return NO ;
	}
	
	// The only other possibility is the local moc, the local sqlite moc
    // which is used to represent the extores of web app clients.

	return YES ;
}

- (void)copyExidsFromStark:(Stark*)sourceStark {
	// Cases 1-4 are explained in header documentation for
	// -overwriteAttributes::::
	
	// Determine whether source is bk/tr or local
	BOOL sourceIsLocal = [sourceStark mocIsLocal] ;
	BOOL destinIsLocal = [self mocIsLocal] ;
	
	NSString* exid ;
	Extore* extore ;
	if (sourceIsLocal) {
		exid = [sourceStark exid] ;
		if (destinIsLocal) {
			// Case 1.  Copy from exid to exid
			[self setExid:exid] ;
		}
		else {
			// Case 2.  Copy from exid to exids.
			// In this case, the source is local, and
			// its owner should be an extore, whose
			// clidentifier is the key into which we
			// should copy the source's single exid.
			extore = (Extore*)[sourceStark owner] ;

			if ([extore isKindOfClass:[Extore class]]) {
                Clientoid* clientoid = [[extore client] clientoid] ;
                [self setExid:exid
                 forClientoid:clientoid] ;
            }
            else {
                NSLog(@"Internal Error 514-1984 extore=%@ %@", extore, [self shortDescription]) ;
			}
		}
	}
	else {
		if (destinIsLocal) {
			// Case 3.  Copy from exids to exid
			// In this case, we need the destin's extore
			// in order to know which exid to extract from
			// the source's exids.  Destin is self.
			extore = (Extore*)[self allocOwner] ;

			if (![extore isKindOfClass:[Extore class]]) {
				NSLog(@"Internal Error 514-1986 extore=%@", extore) ;
			}

			Clientoid* clientoid = [[extore client] clientoid];
            [extore release];
			exid = [sourceStark exidForClientoid:clientoid] ;
			[self setExid:exid];
		}
		else {
			// Case 4.  Copy from exids to exids
			[self appendExids:[sourceStark exids]] ;
			// Until BookMacster 1.7/1.6.8, the above was -addExids:
		}
	}	
}

- (void)overwriteAttributes:(NSArray*)overwritees
				  mergeTags:(BkmxMergeResolutionTags)mergeTags
			  fabricateTags:(BOOL)fabricateTags
                  fromStark:(Stark*)stark {
    Extore* extore = (Extore*)[self allocOwner];
    if (![extore isKindOfClass:[Extore class]]) {
        [extore release];
        extore = nil;
    }
    
    // Part 1.  Copy Exids
    
    [self copyExidsFromStark:stark] ;
    
    
    // Part 2.  Copy requested Overwritees
    
    for (id key in overwritees) {
        if ([key isEqualToString:constKeyTags]) {
            // This case will be handled separately, below.
            continue ;
        }
        // Defensive programming since 'exids' should never be among overwritees anyhow.
        else if ([key isEqualToString:constKeyExids]) {
            NSLog(@"Internal Error 153-0938") ;
            continue ;
        }
        
        id value ;
        if (extore) {
            /* Owner of self is a Extore.  Because this method reads the value
             of the fromStark and modifies self, self is the destination stark.
             Therefore, the destination is owned by a extore.  Therefore, we
             are running as part of an *export* operation. */
            value = [extore tweakedValueFromStark:stark
                                           forKey:key] ;
        }
        else {
            /* Owner of self is a Bkmxoc.  Because this method reads the value
             of the fromStark and modifies self, self is the destination stark.
             Therefore, the destination is owned by aa Bkmxoc.  Therefore, we
             are running as part of an *import* operation. */
            value = [stark valueForKey:key] ;
        }
        
        /* The following two kludgey workarounds were added  BkmkMgrs 2.8.2
         and 2.8.3, respective, to fix a bug that, sometimes, when importing
         Firefox bookmarks of user Lew Rafsky or Jim Mc., probably only in
         Style 1, some URLs are nil.  I have seen this bug when importing from
         their Firefox data which they sent me, but the step to reproduce are
         not known, or the bug is "not always" reproducible.  Actually, it
         is reproducible for several tries, but then goes away inexplicably. */
        if (value == nil) {
            if ([key isEqualToString:constKeyName] || [key isEqualToString:constKeyUrl]) {
                id sourceOwner = [stark allocOwner] ;
                if ([sourceOwner isKindOfClass:[Extore class]]) {
                    [sourceOwner release];
                    continue;
                }
                [sourceOwner release];
            }
        }
        
        if (self.sharypeValue == SharypeSeparator) {
            NSObject <Startainer> * ownerOfSeparator = [self allocOwner];
            if ([[ownerOfSeparator unsupportedAttributesForSeparators] member:key]) {
                [ownerOfSeparator release];
                continue;
            }
            [ownerOfSeparator release];
        }
        
        /* Thoughts from Ben Trumbull, cocoa-dev@lists.apple.com, 20090728:
         Well, in your copy & paste code, what happens if the object already exists
         in the destination MOC ?  Or, say, a paste operation occurs, some edits
         happen to the new object, and then the user pastes again ?  For some
         applications, pasting should always create a new object, but for others,
         the value on the pasteboard includes an objectID.  If the paste refers to
         a specific object, then that will be applied over existing edits.  If the
         pasteboard does not represent nils (e.g. those keys are absent) then
         edited values won't be set to nil on the second paste operation. */
        
        // In order to avoid registering undo and unnecessarily dirtying the dot,
        // we only do the overwrite if there was a substantive change.
        // Note that either current or new value or both can be nil, and if they
        // are both nil, they are equal for our purposes.
        BOOL isEqual = NO ;
        id currentValue = [self valueForKey:key] ;
        if ([currentValue respondsToSelector:@selector(isEqualToDictionary:)]) {
            if ([value respondsToSelector:@selector(isEqualToDictionary:)]) {
                // Both currentValue and value are dictionaries.
                isEqual = [currentValue isEqualToDictionary:value] ;
            }
            else {
                // currentValue is a dictionary and value is nil.  Leave isEqual = NO.
            }
        }
        else {
            // currentValue is not a dictionary.  It may be nil, or it may be a number,
            // date, set, array or string.  In any case of these cases, the following
            // method will give the correct answer
            isEqual = [NSObject isEqualHandlesNilObject1:[self valueForKey:key]
                                                 object2:value] ;
        }
        
        if (!isEqual) {
            if ([key isEqualToString:constKeySharype]) {
                // This section was added in BookMacster 1.2.6, and moved from
                // -[Ixporter mergeFromStartainer:toStartainer:info:error_p:] in BookMacster 1.9.8
                
                // There should rarely be any difference in sharype, except in two
                // Special Cases.
                
                // Special Case 1.  A SharypeLiveRSS will be a live bookmark in
                // Firefox but a regular bookmark in Safari.  Say we do a single
                // import from Safari.  It will be imported as a SharypeBookmark.
                // We want it to remain SharypeLiveRSS.
                
                // Special Case 2.  Prior to BookMacster 1.9.8, Smart Search Bookmarks
                // in Firefox were not recognized as SharypeSmart during the import
                // and will exist for updaters as SharypeBookmark.  Those need to be
                // fixed; that is, changed to SharypeSmart
                
                // Prior to BookMacster 1.9.8, we always overwrote sharype unless
                // the ixporter was a single importer, then to accomodate Special Case
                // 1, we did not.
                
                // In BookMacster 1.9.8, it was found that this special case was too
                // broad, causing overwriting to not occur when we did want it to
                // occur, in the newly-discovered Special Case 2.
                
                // Solution: Here, skip overwriting only in a more restrictive special case 1…
                Sharype existingSharype = [self sharypeValue] ;
                Sharype proposedSharype = [stark sharypeValue] ;
                if ((existingSharype == SharypeLiveRSS) && (proposedSharype == SharypeBookmark)) {
                    continue ;
                }
            }
            
            [self setValue:value
                    forKey:key] ;
        }
    }
    
    // Part 3.  If separator, add placeholder url
    
    if (self.sharypeValue == SharypeSeparator) {
        [self separatorify];
    }
    
    // Part 4.  Fix Tags
    
    if ([self canHaveTags]) {
        /* This is done whether or not constKeyTags is in overwritees. */
        
        NSSet<Tag*>* existingTags = [NSSet setWithArray:[self tags]];
        NSSet<Tag*>* mentorTags = [NSSet setWithArray:[stark tags]];
        [extore despoofTags:mentorTags];
        
        /* We compare tags in different mocs by their string values. */
        NSSet<NSString*>* existingTagStrings = [existingTags valueForKey:constKeyString];
        NSSet<NSString*>* mentorTagStrings = [mentorTags valueForKey:constKeyString];
        NSMutableSet<Tag*>* tagsToRemove = [NSMutableSet new];
        NSMutableSet<NSString*>* tagStringsToAdd = [NSMutableSet new];

        switch (mergeTags) {
            case BkmxMergeResolutionKeepDestinTags:
                break ;
            case BkmxMergeResolutionKeepSourceTags:
                for (NSString* string in existingTagStrings) {
                    if (![mentorTagStrings member:string]) {
                        /* Because the tag is in existingTagStrings, there
                         must be an existing tag with `string`.  The
                         following method will fetch it. */
                        Tag* tag = [[[self owner] tagger] tagWithString:string];
                        [tagsToRemove addObject:tag];
                    }
                }
                /* no break here because BkmxMergeResolutionKeepSourceTags
                means to both delete and add tags as required to match mentor */
            case BkmxMergeResolutionKeepBothTags:;
                for (NSString* string in mentorTagStrings) {
                    if (![existingTagStrings member:string]) {
                        [tagStringsToAdd addObject:string];
                    }
                }
                break ;
        }
        
        if (fabricateTags) {
            NSSet* fabricatedTags = [NSSet setWithArray:[stark lineageNamesSharypeMaskOut:SharypeCoarseHartainer
                                                                              includeSelf:NO]];
            [extore despoofTags:fabricatedTags];
            BOOL didFab = ([fabricatedTags count] > 0) ;
            if (didFab) {
                [tagStringsToAdd unionSet:fabricatedTags];
            }
        }
        
        if ([tagsToRemove count] > 0) {
            [self removeTags:tagsToRemove];
        }
        if ([tagStringsToAdd count] > 0) {
            /* The members ot tagsToAdd and self may be in different stores;
             depending on whether this is for import or export, the store
             of a BkmxDoc and that of an Extore, or vice versa.  So we must
             relate to a Tag object into the destination store for each
             tagToAdd.  We shall call upon the destination's Tagger to do that,
             so we can use its -tagWithString: method to either return an
             existing tag or insert a new tag if there is no existing tag.
             
             Note that, in either case, the destination is self. */
            
            Tagger* tagger = [[Tagger alloc] initWithManagedObjectContext:[self managedObjectContext]];
            /* I considered accessing -{Extore tagger], -[Extore localTagger],
             or -[BkmxDoc tagger].  It actually could be any of three.  I
             wrote code to figure out which one it would be, but it was
             a kludge.  The above line is straightforward and robust. */
            
            [tagger addTagStrings:tagStringsToAdd
                               to:self];
            [tagger release];
        }
        
        [tagsToRemove release];
        [tagStringsToAdd release];
    }
    // End of Part 4
    
    [extore release];
}

- (void)overwriteAttributesFromStark:(Stark*)stark {
	
	NSArray* allAttributes = [self allAttributes] ;
	// allAttributes includes all of the attributes declared in the
	// entity description in the managed object model.
	[self overwriteAttributes:allAttributes
					mergeTags:BkmxMergeResolutionKeepSourceTags
				fabricateTags:NO
					fromStark:stark] ;
}

- (Stark*)bestMatchBetweenStark1:(Stark*)stark1
                          stark2:(Stark*)stark2 {
    Stark* answer ;
    
    if (!stark2) {
        answer = stark1 ;
    }
    else if (!stark1) {
        answer = stark2 ;
    }
    else {
        uint32_t myHash = [self valuesHash] ;

        if ([stark1 valuesHash] == myHash) {
            answer = stark1 ;
        }
        else if ([stark2 valuesHash] == myHash) {
            answer = stark2 ;
        }
        else if ([[stark1 name] isEqualToString:[self name]]) {
            answer = stark1 ;
        }
        else if ([[stark2 name] isEqualToString:[self name]]) {
            answer = stark2 ;
        }
        else if ([[stark1 tags] isEqualToArray:[self tags]]) {
            answer = stark1 ;
        }
        else if ([[stark2 tags] isEqualToArray:[self tags]]) {
            answer = stark2 ;
        }
        else {
            /* We could do even more comparisons here, for example, see which
             one matched more attributes, weighted by importance.  And, I was
             thinking, compare exids for the pertinent Client.  However, it
             looks like, as this method is used, exids have already been
             compared and this branch should never execute.  Well, let's add
             a test in debugging for that… */
#if DEBUG
            NSLog(
                  @"Warning 498-3822 Should never execute here?\n%@\n%@\n%@",
                  self.shortDescription,
                  stark1.shortDescription,
                  stark2.shortDescription);
#endif
            
            /* And then just give up and choose 1 arbitrarily */
            answer = stark1 ;
        }
    }

    return answer ;
}

- (Stark*)bestMatchFromSet:(NSSet*)set {
    Stark* bestMatch = nil ;
    for (Stark* stark in set) {
        bestMatch = [self bestMatchBetweenStark1:stark
                                          stark2:bestMatch] ;
    }
    
    return bestMatch ;
}

- (void)setRssArticles:(NSArray*)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeyRssArticles] ;
	[self willChangeValueForKey:constKeyRssArticles] ;
    [self setPrimitiveRssArticles:newValue] ;
    [self didChangeValueForKey:constKeyRssArticles] ;
}

/*
 The inverse of this method is -[SSYOperation(OperationExport) restoreRssArticlesInsertAsChildStarks_unsafe]
 */
- (void)setRssArticlesFromAndRemoveStarks:(NSArray*)starks {
	NSManagedObjectContext* moc = [self managedObjectContext] ;
    NSMutableArray* articles = [[NSMutableArray alloc] init] ;
	
	for (Stark* stark in starks) {
		NSMutableDictionary* dic = [[NSMutableDictionary alloc] init] ;
		
		// Firefox, OmniWeb:
		[dic setValue:[stark name] forKey:constKeyName] ;
		// Firefox, OmniWeb:
		[dic setValue:[stark url] forKey:constKeyUrl] ;
		// Firefox:
		[dic setValue:[stark addDate] forKey:constKeyAddDate] ;
		// Firefox:
		[dic setValue:[stark lastModifiedDate] forKey:constKeyLastModifiedDate] ;
		// OmniWeb:
		[dic setValue:[stark shortcut] forKey:constKeyShortcut] ;
		// Firefox:
		[dic setValue:[stark comments] forKey:constKeyComments] ;

		// Needed so that they are not treated as additions when matched
		// into Firefox during export.
		// Before BookMacster 1.2.5, this was …[self exids]… !!!
		[dic setValue:[stark exids]
			   forKey:constKeyExids] ;
		// Needed for omniwebCheckFrequency, omniWebStatus:
		[dic setValue:[stark ownerValues]
			   forKey:constKeyOwnerValues] ;

		[articles addObject:dic] ;
        [dic release] ;
		[moc deleteObject:stark] ;
	}
	
	[self setRssArticles:articles];
	
	[articles release] ;
}


- (NSString*)describeIxportingIndexes {
	NSString* sponsorIndex = ([self sponsorIndex] ? [[self sponsorIndex] description] : @"N");
	NSString* sponsoredIndex = ([self sponsoredIndex] ? [[self sponsoredIndex] description] : @"N");
	return [NSString stringWithFormat:
			@"%@.%@.%ld",
			sponsorIndex,
			sponsoredIndex,
			(long)[self ixportingIndex]] ;
}

- (NSString*)nameAndUrl {
    return [NSString stringWithFormat:
            @"name: %@  url: %@",  // was @"%@ :: %@" until BookMacster 1.19.9
            [self name],
            [self url]] ;
}


#pragma mark * Deep Value-Added Getters

- (NSString*)parentName {
	return [[self parent] name] ;
}

- (BOOL)hasIncestWithProposedChild:(Stark*)child {
	// Note that this method calls itself recursively to check the parent, grandparent, greatgrand...., , root
	if ((child == self) && ([self canHaveChildren])) {
		//  Added the "&& ([self canHaveChildren])" in Bookdog 3.10, so
		//  that you could select an item, then hold down cmd and type c, then v
		//  to make a duplicate.  Without that clause, this was incest.
		return YES ;
	}
	Stark* parent = [self parent] ;
	if (parent) {
		return [parent hasIncestWithProposedChild:child] ;
	}
	return NO ;
}

- (BOOL)hasIncestWithAnyOfProposedChildren:(NSArray*)children {
	for(Stark* child in [self children]) {
		if ([self hasIncestWithProposedChild:child]) {
			return YES ;
		}
	}
	return NO ;
}

- (NSInteger)lineageDepth {
#if DEBUG
	if (self == [self parent]) {
		NSLog(@"Internal Error 601-0995: Is own parent: %@", [self shortDescription]) ;
		return 0 ;
	}
#endif
	
	Stark* item = self ;
	NSInteger count = -1 ;
	
	while (item) {
		count++ ;
		item = [item parent] ;
	}
	
	return count ;
}

- (NSNumber*)lineageDepthObject {
	return [NSNumber numberWithInteger:[self lineageDepth]] ;
}

- (NSArray*)lineageSharypeMaskOut:(Sharype)mask
					  includeSelf:(BOOL)includeSelf {
#if DEBUG
	if (self == [self parent]) {
		NSLog(@"Internal Error 601-5778: Is own parent: %@", [self shortDescription]) ;
		return [NSArray arrayWithObject:@"Error: is own parent"] ;
	}
#endif
	
	NSMutableArray* lineage = [[NSMutableArray alloc] init] ;
	Stark* item = includeSelf ? self : [self parent] ;
	
	while (item && (([item sharypeValue] & mask) == 0)) {
		[lineage addObject:item] ;
		item = [item parent] ;
	}

	// Crash 20101120 here:
	NSArray* output = [[NSArray alloc] initWithArray:lineage] ;
	[lineage release] ;
	
	return [output autorelease] ;
} 

- (NSArray*)lineageNamesSharypeMaskOut:(Sharype)mask
						  includeSelf:(BOOL)includeSelf {
	return [[self lineageSharypeMaskOut:mask
						   includeSelf:includeSelf] valueForKey:@"nameNoNil"] ;
} 

- (NSArray*)lineageNamesDoSelf:(BOOL)doSelf
					   doOwner:(BOOL)doOwner  {
	NSArray* lineageNames = [self lineageNamesSharypeMaskOut:SharypeRoot
												 includeSelf:doSelf] ;
	if (doOwner) {
		NSObject <StarkReplicator> * owner = [self allocOwner] ;
		/* The following condition was added in BookMacster version 1.3.12 when it was found to
		 raise an exception when owner was nil, which occurred if -[BkmxAppDel updateSelectedStarkFromWindowNote:]
		 was invoked with the 'selectedStark' parameter equal to <NO SELECTION MARKER>, which
		 caused the binding on the Inspector's status line to invoke -lineageStatus on an
		 empty, uninserted stark, i.e.
		 (gdb) po 0x1bb40cb0
		 <Stark: 0x1bb40cb0> (entity: Stark_entity; id: 0x802a60 <x-coredata:///Stark_entity/t10910957-948D-40EE-BA2F-1E8FD2FB1E185> ; data: {
		 addDate = nil;
		 actionDate = 3000-01-01 12:00:00 +0000;
		 children =     (
		 );
		 color = nil;
		 comments = nil;
		 dontExportExformats = nil;
		 dontVerify = 0;
		 dupe = nil;
		 exid = nil;
		 favicon = nil;
		 faviconUrl = nil;
		 index = 0;
		 isAllowedDupe = 0;
		 isAutoTab = 0;
		 isShared = 0;
		 lastChengDate = nil;
		 lastModifiedDate = nil;
		 lastVisitedDate = nil;
		 name = nil;
		 parent = nil;
		 rating = nil;
		 rssArticles = nil;
		 sharype = 3567;
		 shigForLanding = nil;
		 shortcut = nil;
		 sortDirective = 0;
		 sortable = 127;
		 starkid = nil;
		 tags = nil;
		 toRead = 0;
		 url = nil;
		 verifierCode = nil;
		 verifierDetails = nil;
		 verifierDisposition = -1;
		 verifierLastDate = nil;
		 verifierSubtype302 = nil;
		 visitCount = nil;
		 visitor = visitDD;
		 visitorWindowFrame = nil;
		 })
		 Now, I can't figure out where this stark comes from.  I say that it is
		 uninserted, because it does not even have a starkid, which it would
		 have been given in -awakeFromInsert.
*/		 
		if ([owner isKindOfClass:[BkmxDoc class]]) {
			lineageNames = [lineageNames arrayByAddingObject:[(BkmxDoc*)owner displayNameShort]] ;
		}
        [owner release];
	}
	lineageNames = [lineageNames arrayByReversingOrder] ;

	return lineageNames ;
}

+ (NSString*)lineageLineWithLineageNames:(NSArray*)lineageNames {
	NSString* joiner = [[NSString alloc] initWithFormat:
                        @" %C ",
                        (unsigned short)0x2192] ;
	NSString* lineageLine = [lineageNames componentsJoinedByString:joiner] ;
	// Note that lineageLine will be an empty string if lineageNames ie empty
	[joiner release] ;
	
	return lineageLine ;
}

- (NSString*)lineageLineDoSelf:(BOOL)doSelf
					   doOwner:(BOOL)doOwner {
	NSArray* lineageNames = [self lineageNamesDoSelf:doSelf
											 doOwner:doOwner] ;
	NSString* answer = [Stark lineageLineWithLineageNames:lineageNames] ;
	return answer ;
}

- (NSString*)lineageLineSelfNoOwnerYes {
	return [self lineageLineDoSelf:NO
						   doOwner:YES] ;
}

+ (NSSet *)keyPathsForValuesAffectingLineageLineNoSelf {
	return [NSSet setWithObjects:
			constKeyParent,
			@"parent.lineageLineSelfNoOwnerYes",
			// Note that the above operates recursively, thru
			// the parent, grandparent, etc.  Kind of nitpicky,
			// because there are few ways you could actually
			// see the effect were this not recursive.  Example:
			// Move a folder, select one of its descendants, 
			// view its lineage in the Inspector, then Undo (the
			// move of its parent).  Hey, we try to be perfect.
			nil] ;	
}

- (NSDictionary*)lineageStatus {
	/* For some reason which I don't quite understand, it appears that, when there
	 is no selection, Cocoa Bindings will invoke this method with an orphaned, 
	 uninserted Stark which has default/nil attributes.  (See comment in
	 -lineageNamesDoSelf:doOwner:.)  So, starting in BookMacster version 1.1.12,
	 I filter those out and return nil. */
	NSDictionary* answer ;
	if ([self name] != nil) {
		answer = [NSDictionary dictionaryWithObjectsAndKeys:
				  [self lineageLineSelfNoOwnerYes], constKeyPlainText,
				  [NSString localize:@"move"], constKeyHyperText,
				  [(BkmxAppDel*)[NSApp delegate] inspectorController], constKeyTarget,
				  [NSValue valueWithPointer:@selector(popMoveMenuOntoLineageField:)], constKeyActionValue,
				  nil] ;
	}
	else {
		answer = nil ;
	}

	return answer ;
}

+ (NSSet *)keyPathsForValuesAffectingLineageStatus {
	return [self keyPathsForValuesAffectingLineageLineNoSelf] ;	
}

- (Stark*)collection {
	if ([self isHartainer]) {
		// Case 0
		return self ;
	}

	Stark* lineage[4] ; // C array of 4 elements
	NSInteger i = 0 ; // i always points to the greatest ancestor found so far
	NSInteger j = 3 ;
	lineage[0] = nil ;
	lineage[1] = nil ;
	lineage[2] = nil ;
	lineage[3] = self ;
	
#define LOG_COLLECTIONS 0
	// What will happen if self has no parent
	//  i   j   lineage[0]   lineage[1]   lineage[2]   lineage[3]
	//  0   3      nil          nil          nil         self
	//  1   0      nil          nil          nil         self
	//  Stop because lineage[j] = lineage[0] = nil
	//  k=2
	//  lineage[k] = nil
	//  Branch to Case 0
	//  answer = nil
	
	// What will happen if self is an immediate child of root
	//  i   j   lineage[0]   lineage[1]   lineage[2]   lineage[3]
	//  0   3      nil          nil          nil       BkmkAtRoot
	//  1   0      root         nil          nil       BkmkAtRoot
	//  2   1      root         nil          nil       BkmkAtRoot
	//  Stop because lineage[j] = lineage[1] = nil
	//  k=3
	//  lineage[k] = BkmkAtRoot, which == self
	//  Branch to Case 1
	//  (k+1)%4 = 0
	//  answer = lineage[0] = root

	// What will happen if self is grandchild of root and parent is a soft folder
	//  i   j   lineage[0]   lineage[1]   lineage[2]   lineage[3]
	//  0   3     nil          nil          nil         theBkmrk
	//  1   0   aSoftFldr      nil          nil         theBkmrk
	//  2   1   aSoftFldr     root          nil         theBkmrk
	//  3   2   aSoftFldr     root          nil         theBkmrk
	//  Stop because lineage[j] = lineage[2] = nil
	//  k=0
	//  lineage[k] = aSoftFldr, which != self
	//  Branch to Case 2
	//  And this is not a hartainer, so 
	//  Branch to Case 2b
	//  answer = lineage[(k+1)%4] = lineage[1] = root
	
	// What will happen if self is an immediate child of Bookmarks Menu
	//  i   j   lineage[0]   lineage[1]   lineage[2]   lineage[3]
	//  0   3      nil          nil          nil       BkmkInMenu
	//  1   0     BkMenu        nil          nil       BkmkInMenu
	//  2   1     BkMenu       root          nil       BkmkInMenu
	//  3   2     BkMenu       root          nil       BkmkInMenu
	//  Stop because lineage[j] = lineage[2] = nil
	//  k=0
	//  lineage[k] = BkMenu, which != self
	//  Branch to Case 2
	//  And this is a hartainer, so
	//  Branch to Case 2a
	//  answer = BkMenu
	
	// What will happen if self is buried deep down somewhere but not orphaned
	//  i   j   lineage[0]   lineage[1]   lineage[2]   lineage[3]
	//  0   3      nil          nil          nil       Easyracers
	//  1   0     Ea-Em         nil          nil       Easyracers
	//  2   1     Ea-Em       EntityOr       nil       Easyracers
	//  3   2     Ea-Em       EntityOr     BkMenu      Easyracers
	//  0   3     Ea-Em       EntityOr     BkMenu        root
	//  1   0      nil        EntityOr     BkMenu        root
	//  Stop because lineage[j] = lineage[0] = nil
	//  k=2
	//  lineage[k] = BkMenu, which != self
	//  Branch to Case 2
	//  And this is a hartainer, so
	//  Branch to Case 2a
	//  answer = BkMenu
	
	// What will happen if self is buried deep down somewhere, and is orphaned
	//  i   j   lineage[0]   lineage[1]   lineage[2]   lineage[3]
	//  0   3      nil          nil          nil          me
	//  1   0     anc1          nil          nil          me
	//  2   1     anc1          anc2         nil          me
	//  3   2     anc1          anc2         anc3         me
	//  0   3     anc1          anc2         anc3         anc4
	//  1   0     anc5          anc2         anc3         anc4
	//  2   1     anc5          anc6         anc3         anc4
	//  2   2     anc5          anc6         nil          anc4
	//  Stop because lineage[j] = lineage[2] = nil
    //  k=3
	//  lineage[k] = anc4, which != self
    //  Branch to Case 2
    //  And this is not a hartainer so
    //  Branch to case 2b
    //  answer = lineage[(k+1)%4] = lineage[(3+1)%4] = lineage[0] = anc5
    //  which is not root, so we get Internal Error 624-9569.

    // What will happen if self's grandparent is orphaned
	//  i   j   lineage[0]   lineage[1]   lineage[2]   lineage[3]
	//  0   3      nil          nil          nil          me
	//  1   0    parent         nil          nil          me
	//  2   1    parent      grandparent     nil          me
	//  3   2    parent      grandparent     nil          me
	//  Stop because lineage[j] = lineage[2] = nil
    //  k=3
	//  lineage[k] = me, which == self
    //  Branch to Case 1
    //  answer = lineage[(k+1)%4] = lineage[(3+1)%4] = lineage[0] = parent
    //  And this is not a hartainer so
    //  Branch to case 2b
    //  answer = lineage[(k+1)%4] = lineage[(3+1)%4] = lineage[0] = anc5
    //  which is not root, so we get Internal Error 624-9569.
    do {
		lineage[i] = [lineage[j] parent] ;
		i = (i+1)%4 ;
		j = (j+1)%4 ;
	}
	while (lineage[j]) ;
	
	NSInteger k = (i+1)%4 ;
	Stark* answer ;
	if (lineage[k] == nil) {
		// Case 0
		answer = nil ;
	}
	else if (lineage[k] == self) {
		// Case 1
		answer = lineage[(k+1)%4] ;
	}
	else {
		// Case 2
		if ([lineage[k] isHartainer]) {
			// Case 2a
			answer = lineage[k] ;
		}
		else {
			// Case 2b
			answer = lineage[(k+1)%4] ;
			// Defensive programming…
			// Prior to BookMacster 1.3.12, this was tested at the end and returned nil
			if (![answer isRoot]) {
				// Removed in BookMacster 1.12 … NSLog(@"Internal Error 624-9569.  Expected root, got %@ for %@", [answer shortDescription], [self shortDescription]) ;
                NSObject <Hartainertainer, StarkReplicator, Startainer>* owner = [self allocOwner];
				answer = [[owner starker] root];
                [owner release];
			}
		}
	}
	
	if (answer && ![answer isHartainer]) {
		// The receiver or its lineage is currently orphaned, which will happen
		// if it or its lineage has just been deleted, but it's still in a Dupe.
		answer = nil ;
	}
	
	return answer ;
}

- (FolderStatistics)addFolderStatistics {
    FolderStatistics myStats, childStats ;
    NSInteger nSubfolders = 0 ;
    NSInteger nBookmarks = 0 ;
	for (Stark* nextChild in [self children]) {
#if DEBUG
		if (nextChild == self) {
			NSLog(@"Internal Error 601-5778: Is own child: %@", [self shortDescription]) ;
			myStats.nSubfolders = 0 ;
			myStats.nBookmarks = 0 ;
			return myStats ;
		}
#endif		
        Sharype sharype = [nextChild sharypeValue] ;
		
        if ([StarkTyper canHaveChildrenSharype:sharype]) {
        	// Recurse
			childStats = [nextChild addFolderStatistics] ;
        	
			nSubfolders += childStats.nSubfolders + 1 ;
        	nBookmarks += childStats.nBookmarks ;
        }
        else if ([StarkTyper doesCountAsBookmarkSharype:sharype]) {
            nBookmarks++ ;
        }
        else {
        	// Do not count separators or rss articles. 
			//(RSS Articles won't show up anyhow since they are not in the children array)
		}
	}
    myStats.nSubfolders = nSubfolders ;
    myStats.nBookmarks = nBookmarks ;
    
    return myStats ;
}


- (NSString*)displayStatsShort {
	FolderStatistics fStats = [self addFolderStatistics] ;
	NSMutableString* string = [[NSMutableString alloc] init] ;
	if (fStats.nSubfolders > 0) {
		[string appendFormat:@"%ld %C",
		 (long)(fStats.nSubfolders),
		 (unsigned short)0x00A7] ; // was 25BE, was 25B7
	}
	
	if (fStats.nBookmarks > 0) {
		if ([string length] > 0) {
			[string appendString:@"   "] ;
		}
		
		[string appendFormat:@"%ld %C",
		 (long)(fStats.nBookmarks),
		 (unsigned short)0x25AE] ;  // was 2604 comet, 26A1 lightning, 25AE, 0040
	}
	
	NSString* output = [string copy] ;
	[string release] ;
	
	return [output autorelease] ;
}

- (NSString*)displayStatsLong {
	NSString* container = nil ;
	NSString* stats = nil ;
	
	if ([self isRoot]) {
		container = @"document" ;
	}
	else if ([self isHartainer]) {
		container = @"080_folderHard" ;
	}
	else if ([self canHaveChildren]) {
		container = @"080_folderSoft" ;
	}
	
	if (container) {
		container = [NSString localize:container] ;
		
		FolderStatistics fStats = [self addFolderStatistics] ;
		
		NSString* contents1 = nil ;
		if (fStats.nSubfolders > 0) {
			contents1 = [NSString stringWithFormat:@"%ld %@",
						 (long)(fStats.nSubfolders),
						 [NSString localize:@"subfolders"]] ;
		}
		
		NSString* contents2 = nil ;
		if (fStats.nBookmarks > 0) {
			contents2 = [NSString stringWithFormat:@"%ld %@",
						 (long)(fStats.nBookmarks),
						 [NSString localize:@"000_Safari_Bookmarks"]] ;
		}
		
		NSString* contents ;
		if (contents1 && contents2) {
			contents = [NSString stringWithFormat:
						@"%@ %@ %@",
						contents1,
						[NSString localize:@"andEndList"],
						contents2] ;
		}
		else if (contents1) {
			contents = contents1 ;
		}
		else if (contents2) {
			contents = contents2 ;
		}
		else {
			contents = [NSString localize:@"nothing"] ;
		}
		
		stats = [NSString localizeFormat:
				 @"containsXX",
				 container,
				 contents] ;

	}
	
	return stats ;
}

- (NSString*)toolTipForTableColumn:(NSTableColumn*)tableColumn {
	// Get the relevant attribute
	NSString* attribute = nil ;
	NSString* identifier = [tableColumn identifier] ;
	if ([identifier hasPrefix:@"userDefined"]) {
		if ([tableColumn respondsToSelector:@selector(userDefinedAttribute)]) {
			attribute = [(StarkTableColumn*)tableColumn userDefinedAttribute] ;
		}
	}
	else {
		attribute = identifier ;
	}
	
	// Compute advice on editing, if applicable
	NSString* toolTip = nil ;
	NSString* moreTip = nil ;
    
    if ([self isAvailable]) {  //  <-- This test added in BookMacster 1.16
        if (![Stark isEditableAttribute:attribute]) {
            toolTip = [NSString localizeFormat:
                       @"editableNoX",
                       [[BkmxBasis sharedBasis] labelNoNilForKey:attribute],
                       [[BkmxBasis sharedBasis] labelInspector]] ;
        }
        
        // Compute additional advice, if applicable
        if ([attribute isEqualToString:constKeyUrlOrStats] && [self canHaveChildren]) {
            moreTip = [self displayStatsLong] ;
        }
        else if ([attribute isEqualToString:constKeyVerifierLastResult]) {
            moreTip = [self verifierAdviceMultiLiner] ;
        }
        else if ([[self rssArticles] count] > 0) {
            moreTip = [[self rssArticles] listValuesOnePerLineForKeyPath:constKeyName] ;
        }
        else if ([[self comments] length] > 0) {
            moreTip = [NSString stringWithFormat:
                       @"%@: %@",
                       [[BkmxBasis sharedBasis] labelComments],
                       [self comments]] ;
        }
    }
	
	// Concatenate
	if (toolTip && moreTip) {
		toolTip = [toolTip stringByAppendingFormat:
				   @"\n\n%@", moreTip] ;
	}
	else if (moreTip) {
		toolTip = moreTip ;
	}


	return toolTip ;
}

- (Stark*)replicatedOrphanStarkFreshened:(BOOL)freshened
							  replicator:(NSObject <StarkReplicator> *)replicator {
	// We invoke the starker of the destination to create a new stark,
	// and then copy attributes from the old stark to it.
	// This is how we bridge across persistent stores, if indeed the
	// destination replicator is different than the receiver's replicator.
	
	Stark* stark = [[replicator starker] freshStark] ;

	NSMutableDictionary* attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesDictionaryWithNulls:NO]] ;
	// Note that attributesDictionary does not include relationships
	// such as parent, children, etc.
	// Also, it does not include the ivar 'exids', which 
	// is good because we don't want that if not freshened.
	
	if (freshened) {
        [attributes removeObjectForKey:constKeyExid] ;
        [attributes removeObjectForKey:constKeyStarkid] ;
		[attributes setObject:[NSDate date]
					   forKey:constKeyAddDate] ;
		[attributes setObject:[NSDate date]
					   forKey:constKeyLastModifiedDate] ;
	}
	else {
		[stark copyExidsFromStark:self] ;
	}
	
	[stark setAttributes:attributes] ;
	
	return stark ;
}

- (Stark*)replicatedOrphanStarkNotFreshenedInReplicator:(NSObject <StarkReplicator> *)replicator {
	return [self replicatedOrphanStarkFreshened:NO
									 replicator:replicator] ;
}

- (Stark*)replicatedOrphanStarkFreshenedInReplicator:(NSObject <StarkReplicator> *)replicator {
	return [self replicatedOrphanStarkFreshened:YES
									 replicator:replicator] ;
}

- (NSString*)pathIndentedIncludingSelf:(BOOL)includeSelf {
	NSArray* namePath = [self lineageNamesSharypeMaskOut:0
											 includeSelf:YES] ;
	
	NSMutableString* bookmarkFormatted = [[NSMutableString alloc] init] ;
	
	NSInteger nIndents=0 ;
	NSInteger nLines = [namePath count] ;
	NSInteger iTopLevel = nLines-1 ; 
	NSInteger i ;
	NSInteger lastLine = includeSelf ? 0 : 1 ;
	for (i=iTopLevel; i>=lastLine; i--)
	{
		if(i != iTopLevel) {
			[bookmarkFormatted appendString:@"\n"] ;
			NSInteger j ;
			for (j=0; j<nIndents; j++)
				[bookmarkFormatted appendString:@"     "] ;
			[bookmarkFormatted appendString:[NSString stringWithFormat:@"%C", (unsigned short)0x21B3]] ;  // 0x21B3 is unicode for the down-turn-right 90-degree bent arrow
		}
		[bookmarkFormatted appendString:[namePath objectAtIndex:i]] ;
		nIndents++ ;
	}
	
	NSString* output = [bookmarkFormatted copy] ;
	[bookmarkFormatted release] ;
	
	return [output autorelease] ;
}

- (NSArray*)extractLeavesOnly {
	NSMutableArray* leaves = [[NSMutableArray alloc] init] ;
    [self classifyBySharypeDeeply:YES
                       hartainers:nil
                      softFolders:nil
                           leaves:leaves
                          notches:nil] ;
	NSArray* output = [leaves copy] ;
	[leaves release] ;
	return [output autorelease] ;
}

- (BOOL)aggresivelyNormalizeUrl {
    BOOL didDo = NO ;
    NSString* url = [self url] ;
    if (url) {
        NSString* aggressivelyNormalizedUrl = [url aggressivelyNormalizedUrl] ;
        if (![aggressivelyNormalizedUrl isEqualToString:url]) {
            [self setUrl:aggressivelyNormalizedUrl] ;
            didDo = YES ;
        }
    }
    
    return didDo ;
}

- (Stark*)copyDeepOrphanedFreshened:(BOOL)freshened
                         replicator:(id <StarkReplicator>)replicator {
	SEL reformatter ;
	
	if (freshened) {
		reformatter = @selector(replicatedOrphanStarkFreshenedInReplicator:) ;
	}
	else {
		reformatter = @selector(replicatedOrphanStarkNotFreshenedInReplicator:) ;
	}
	// Note that, although reformatter will return orphaned starks,
	// transformer will wire up the new parent/child relationsips.
	
	SSYTreeTransformer* transformer = [SSYTreeTransformer treeTransformerWithReformatter:reformatter
																	 childrenInExtractor:@selector(childrenOrdered)
																		  newParentMover:@selector(moveToBkmxParent:)
																		   contextObject:replicator] ;
	// We use moveToBkmxParent: instead of moveToNewBkmxParent: because an orphan
	// has no previous parent either
	
	Stark* copy = [transformer copyDeepTransformOf:self] ;
	
	return copy ;
}


#pragma mark * Movers and Removers


- (void)appendChildren:(NSArray*)children {
	// BookMacster 1.11 changed to this…
	NSInteger i = [self numberOfChildren] ;
	for (Stark* child in children) {
		[child moveToBkmxParent:self
						atIndex:i++
						restack:NO] ;
	}
	
	// if() is an optimization, also avoids churn during export to flat extores.
    NSObject <Hartainertainer, StarkReplicator, Startainer>* owner = [self allocOwner];
    if ([owner hasOrder]) {
        [self restackChildrenStealthily:NO] ;
	}
    [owner release];
}

- (Stark*)moveMeToOtherMoc:(NSManagedObjectContext*)newMoc {
	[self deleteMe] ;
	Stark* freshStark = [NSEntityDescription insertNewObjectForEntityForName:constEntityNameStark
													inManagedObjectContext:newMoc] ;	
	[freshStark overwriteAttributesFromStark:self] ;
	return freshStark ;
}

/*!
 @brief    Override of superclass method, for optimization

 @details  Added in BookMacster 1.11
*/
- (Stark*)childAtIndex:(NSInteger)index {
	if (![self canHaveChildren]) {
		return nil ;
	}
	
	return (Stark*)[super childAtIndex:index] ;
}

- (void)restackChildrenStealthily:(BOOL)stealthily {
	NSSet* children = [self children] ;

	// Optimization
	if ([children count] < 1) {
		return ;
	}
		
	NSMutableArray* array = [[children allObjects] mutableCopy] ;
#if (MAC_OS_X_VERSION_MIN_REQUIRED < 1060) 
	NSSortDescriptor* sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:constKeyIndex
																	ascending:YES] autorelease] ;
#else
	NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:constKeyIndex
																	 ascending:YES] ;
#endif
	[array sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] ;
	NSInteger i = 0 ;
#if USE_OPTIMIZED_RESTACK_CHILDREN
	if (stealthily) {
		for (Stark* child in array) {
			[child setIndex:[NSNumber numberWithInteger:i++]] ;
		}
	}
	else {
		for (Stark* child in array) {	
			[child setIndex:[NSNumber numberWithInteger:i++]] ;
		}
	}
#else
	for (Stark* child in array) {	
		[child setIndex:[NSNumber numberWithInteger:i++]] ;
	}
#endif
	
	[array release] ;
	
#if USE_OPTIMIZED_RESTACK_CHILDREN
    NSObject <Hartainertainer, StarkReplicator, Startainer>* owner = [self allocOwner];
    if ([owner respondsToSelector:@selector(postSortMaybeNot)]) {
		BkmxDoc* bkmxDoc = (BkmxDoc*)owner;
		[bkmxDoc postSortMaybeNot] ;
	}
	else {
		// owner must be an Extore instance
	}
    [owner release];
#endif
}

- (void)restackChildrenOfHartainerForGulp {
	NSSet* children = [self children] ;
	
	// Optimization
	if ([children count] < 1) {
		return ;
	}
	
	NSMutableArray* array = [[children allObjects] mutableCopy] ;
	[array sortUsingDescriptors:[Gulper sortDescriptorsForMergingHartainers]] ;
	NSInteger i = 0 ;

	for (Stark* child in array) {
		// Note that we do this un-stealthily
		[child setIndex:[NSNumber numberWithInteger:i++]] ;
	}
	
	[array release] ;
	
    NSObject <Hartainertainer, StarkReplicator, Startainer>* owner = [self allocOwner];
	if ([owner respondsToSelector:@selector(postSortMaybeNot)]) {
		BkmxDoc* bkmxDoc = (BkmxDoc*)owner ;
		[bkmxDoc postSortMaybeNot] ;
	}
	else {
		// owner must be an Extore instance
	}
    [owner release];
}

#if 0
- (id)initWithEntity:(NSEntityDescription*)entity insertIntoManagedObjectContext:(NSManagedObjectContext*)context
{
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    NSLog(@"Created stark %p on thread %@", self, [[NSThread currentThread] isMainThread] ? @"main" : @"non-main") ;
    return self ;
}
#endif

#if LOGGING_STARK_DEALLOCATION
@synthesize debugOwnerString = m_debugOwnerString ;
@synthesize debugName = m_debugName ;

- (void)willTurnIntoFault {
	NSString* debugName = [[NSString alloc] initWithFormat:
						   @"%@: %@: %@",
						   [self debugOwnerString],
						   [self truncatedID],
						   [self name]] ;
	[self setDebugName:debugName] ;
	[debugName release] ;
	
	[super willTurnIntoFault] ;
}
#endif

- (void)deleteMe {
    /* Remove starxid, starlobute and any talderMaps.  Unfortunately,
     we cannot do this with a Cascade Delete Rule because Starxid objects
     are stored in the Exids moc, and Starlobute and TalderMap objects
     are stored in the Settings moc, but Starks are of course in the
     document moc, and cross-store relationships are not a thing. */
    [[self starxider] deleteStarxidForStark:self] ;
    [[self starlobuter] deleteStarlobuteForStark:self] ;
    [[self talderMapper] deleteTalderMapsRelatedToStark:self] ;
    
    BkmxDoc* owner = (BkmxDoc*)[self allocOwner];
    
    // Add unexported deletion to any interested clients
    // Actually owner might be an extore, so we check that…
    if ([owner respondsToSelector:@selector(macster)]) {
        Macster* macster = [owner macster] ;
        for (Client* client in (NSSet*)[macster clients]) {
            Exporter* exporter = [client exporter] ;
            if (
                [[exporter isActive] boolValue]
                &&
                [[exporter deleteUnmatched] boolValue]
                ) {
                    NSString* exid = [self exidForClientoid:[client clientoid]] ;
                    if (exid) {
                        [client addUnexportedDeletion:exid] ;
                    }
                }
        }
    }
    [owner release];
    
    // Remove from moc
    NSManagedObjectContext* moc = [self managedObjectContext] ;
    // The following will also delete self's children, since
    // we have set Cascade Delete Rule for Stark's parent -> child
    // relationship, and we don't have any array controllers
    // (arghhh!!) nulling out the relationship first.  (See
    // header for -[Syncer -removeOwnees].)
    [moc deleteObject:self] ;
    
    /* Added in BookMacster 1.7.3 to fix Core Data could not fulfill a fault
     when undoing deletions via the following Steps to Reproduce:
     • Open a particular document containing only 4 hartainers
     • Insert 3 new objects, (by doing an import) so the tree is now
     • Root1
     •   OldObject2
     •   OldObject3
     •     NewObject5
     •     NewObject6
     •       NewObject7
     •   OldObject4
     • Save
     • Delete the 3 new objects (by removing objects from clients and importing again)
         • Save
         • Undo
         Note that the order of deletions is whatever order they come out of
         fast enumerating the stanges dictionary, below.  If the parent
         NewObject6 happens to get deleted before its child NewObject7,
         the Undo will cause a Core Data could not fulfill a fault exception. */
        [moc processPendingChanges];
}

- (Stark*)moveToBkmxParent:(Stark*)newParent
				   atIndex:(NSInteger)newIndex
				   restack:(BOOL)restack {
	// Local autorelease pool added to improve performance in BookMacster 1.3.19
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
	
	// To ensure original does not go away when previous parent or moc releases:
	[self retain] ;
		
	// Remove from previous parent
	Stark* oldParent = [self parent] ;
	NSMutableSet* oldSiblings = [oldParent mutableSetValueForKey:constKeyChildren] ;
	if (restack) {
		// 1. Causes unacceptable performance if a single folder has thousands of items:
		[oldSiblings removeIndexedObject:self] ;
	}
	else {
		[oldSiblings removeObject:self] ;
	}
		
	/* If receiver is in wrong moc for new parent, delete it and copy to
	 the parent's moc. */
	Stark* freshStark = self ;
	if (newParent) {
		NSManagedObjectContext* newMoc = [newParent managedObjectContext] ;
		NSManagedObjectContext* oldMoc = [self managedObjectContext] ;
		if (newMoc != oldMoc) {
			SSYTreeTransformer* transformer = [SSYTreeTransformer treeTransformerWithReformatter:@selector(moveMeToOtherMoc:)
																			 childrenInExtractor:@selector(childrenOrdered)
																				  newParentMover:@selector(moveToBkmxParent:)
																				   contextObject:newMoc] ;
			freshStark = [transformer copyDeepTransformOf:self] ;
			// To balance the retain, above
			[self release] ;
			
			// To make sure that freshStark is in the current autorelease pool
			// (probably this is not necessary)
			[[freshStark retain] autorelease] ;
		}
	}
	
	// Create the new child-to-parent relationship and set index
	// (No-op if newParent is nil)
	NSMutableSet* newSiblings = [newParent mutableSetValueForKey:constKeyChildren] ;
	if (restack) {
		[newSiblings addObject:freshStark
					   atIndex:newIndex] ;
	}
	else if (newParent) {
		// This branch was added in BookMacster 1.11, so that now when we
		// are invoked with restack:NO, we mean NO for both removing and adding.
		// If the above conditiion is simply "else {", then you get a bug which 
		// took me several hours to find, see Note 593820, below.
		[newSiblings addObject:freshStark] ;
		if ((newIndex >= 0) && (newIndex != DONT_SET_THE_INDEX)) {
			[freshStark setIndexValue:newIndex] ;
		}
	}
		
	// Create the new parent-to-child relationship
	// or remove from moc if new parent is nil
	if (newParent) {
		[freshStark setParent:newParent] ;
	}
	else {
        [self deleteMe] ;
	}
	
	// To balance either the -retain: or the -copyDeepTransformOf:, above
	[freshStark release] ;
	
	[freshStark retain] ;
	[pool drain] ;
	[freshStark autorelease] ;
	
	return freshStark ;
}

/*
 Note 593820
 
 To: cocoa-dev@lists.apple.com 20120503
 Subject: 	Core Data: Setting attribute of deleted object causes it to remain in store
 
 I use Core Data to model an ordered tree of objects.  Delete Rule from parent to children
 is Cascade.  Because this is pre-Lion, ordering is done by my own 'index' attribute.
 Store type is In Memory.
 
 Deleting children with many siblings was expensive because, as each child was deleted,
 business logic would require all of its siblings to be re-indexed to fill the gap,
 maybe triggering KVO in user interface, etc., etc.
 
 To improve performance, I implemented a bulk "deleteObjects:" method, which does this…
 
 • Loop 1.  For each deletedObject,
  	Add parent to set of affectedParents
  	If deletedObject is itself in affectedParents, remove it
  	Remove from parent with this:
  		NSMutableSet* oldSiblings = [oldParent mutableSetValueForKey:@"children"] ;
  		[oldSiblings removeObject:deletedObject] ;
  	Inadvertently (needed in other cases) set an attribute in deletedObject,
  		[deletedObject setIndex:[NSNumber numberWithInteger:0] ;
  	Delete from managed object context with this:
  		[managedObjectContext deleteObject:object] ;
  		[managedObjectContext processPendingChanges] ;
 • Loop 2.  For each affectedParent,
  		Re-index its children to remove gaps
 
 This improved the performance nicely, but led to the unexpected result that any objects
 which happened to have been deleted (in Loop 1) after their parent had been deleted
 remain in the store, with all attributes nil.  In other words, a bunch of "nil" objects.
 
 Branching around the inadvertent setIndex: fixed the problem.
 
 I've seen the nilling of attributes happen before, upon re-inserting a deleted object [1].
 This behavior is obviously related, but different.  If anyone can think of a good reason
 for this behavior, it would be interesting to read.
 
 Jerry Krinock
 
 1.  http://www.cocoabuilder.com/archive/cocoa/236009-nsmanagedobjectcontext-insertobject-cancels-prior-deletion.html?q=cancels+prior+deletion#236009
 */		 

- (Stark*)moveToBkmxParent:(Stark*)newParent {
	return [self moveToBkmxParent:newParent
						  atIndex:NSNotFound
						  restack:YES] ;	
}

- (void)remove {
	// removes the item from parent, which will cause it to be deallocced
	// if no one is holding on to it
	[self moveToBkmxParent:nil] ;
}

- (NSInteger)removeAndRemoveChildlessAncestors {
	// Before removing it from its parent, we remember what the parent was.
	Stark* parent = [self parent] ;
	[self remove] ;
	NSInteger nAncestorsRemoved = 0 ;
	while (parent && ([parent numberOfChildren] < 1) && ([parent isMoveable])) {
		Stark* grandparent = [parent parent] ;
		[parent remove] ;
		nAncestorsRemoved++ ;
		parent = grandparent ;
	}
	
	return nAncestorsRemoved ;
}	

- (void)removeIfIsSeparator {
	if ([self sharypeValue] == SharypeSeparator) {
		[self remove] ;
	}
}

- (void)removeIfIsEmptyFolder {
	if (([self sharypeValue] == SharypeSoftFolder)  && ([self numberOfChildren] == 0)) {
		[self remove] ;
	}
}

- (void)mergeFoldersWithInfo:(NSDictionary*)info {
	// This is one of *four* levels of local autorelease pools that are in
	// this method.  These were added to improve performance with Glenda
	// Carl's massively duplicated bookmarkshelf in BookMacster Version 1.3.19.
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;

	Stark* iChild ;
	Stark* jChild ;
	NSString* iName ;
	NSString* jName ;
	NSInteger i, j;
	
	if ([self canHaveChildren]) {
		BOOL keepSourceValue = [[info objectForKey:constKeyKeepSourceNotDestin] boolValue] ;
		NSInteger nChildren = [self numberOfChildren] ;
		
		BkmxDoc* bkmxDoc = [info objectForKey:constKeyDocument] ;
		BOOL consolidateAndRemoveNow = [[info objectForKey:constKeyConsolidateAndRemoveNow] boolValue] ;
		SSYProgressView* progressView = [bkmxDoc progressView] ;
		NSInteger logLevel = [[BkmxBasis sharedBasis] traceLevel] ;
		NSString* logEntry ;
		if (![self isHartainer] && (nChildren == 0)) {
			if (consolidateAndRemoveNow) {
				[[info objectForKey:constKeyDeletedFolderLineages] addObject:[self lineageLineDoSelf:YES
																							 doOwner:NO]] ;
				[self remove] ;
			}
		}
		else {
            // The local variable 'children' was added in BookMacster 1.12.7
            // to improve performance.  Prior to this, I assigned iChild and
            // jChild within the loop, repeatedly, by sending [self childrenOrdered],
            // which caused the Merge Folders step to take a long time, especially
            // if a user had a large flat folder of thousands of bookmarks,
            // because it -childrenOrdered needs to get all the indexes and sort
            // each time it is invoked.  I think that this may have been
            // necessary in earlier versions because this method may have deleted
            // children which were found to be empty folders.  But now it just
            // sets them to be deleted later (see Note 1212081, below), and
            // also the children that do get moved are actually grandchildren
            // (see Note 1212082, below).
            NSArray* children = [self childrenOrdered] ;
            NSMutableSet* foldersDeletedDueToConsolidation = [info objectForKey:constKeyFoldersDeletedDuringConsolidation];
            // In the next line, nChildren was changed to [children count] in
            // BookMacster 1.12.8, because deleted children need to be reflected
            // lest we overrun the new children array.
			for (i=[children count]-1; i>=0; i--) {
				NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
				iChild = [children objectAtIndex:i] ;
				[progressView incrementDoubleValueBy:1] ;
				// if() since we don't want to merge permanent hartainers:
				if ([iChild sharypeValue] == SharypeSoftFolder) {
                    // In the next line, nChildren was changed to [children count] in
                    // BookMacster 1.12.8, because deleted children need to be reflected
                    // lest we overrun the new children array.
					for (j=[children count]-1; j>i; j--) {
						NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
						jChild = [children objectAtIndex:j] ;
						if (([iChild sponsorIndex] != [jChild sponsorIndex]) || consolidateAndRemoveNow) {
							if ([jChild sharypeValue] == SharypeSoftFolder) { // == since we don't want to merge permanent hartainers
								iName = [iChild name] ;
								jName = [jChild name] ;
								//NSLog(@"Considering: %@ <-> %@", [iChild name], [jChild name]) ;
								if ([iName localizedCaseInsensitiveCompare:jName] == NSOrderedSame) {
									if (
										// In case consolidateAndRemoveNow is YES…
										([iChild parent] != nil) && ([jChild parent] != nil)
										&&
										// In case consolidateAndRemoveNow is NO…
										(![iChild isDeletedThisIxport] && ![jChild isDeletedThisIxport])										
										) {
										// The above makes sure that one of them has not already
										// been removed during a previous i-- or j-- iteration
										// herein, which can occur if there are more than two
										// subfolders with the same name.
																				
										// See BookMacster Help Book section…
										// More About Import/Export ▸ Merge Folders ▸ Which one is Kept?
										BOOL keepI ;
										if ([iChild isNewItemThisIxport] == [jChild isNewItemThisIxport]) {
											// Both folders are from source, or both are from destin.
											if ([iChild isNewItemThisIxport]) {
												// Added in BookMacster version 1.3.22 for one of the Carol Kino fixes:
												// If the two folders are from different sources, keep the one
												// that has the lower sponsorIndex
												NSNumber* iSponsorIndex = [iChild sponsorIndex] ;
												NSNumber* jSponsorIndex = [jChild sponsorIndex] ;
												NSComparisonResult sponsorComparison = [iSponsorIndex compare:jSponsorIndex] ;
												if (iSponsorIndex && jSponsorIndex && (sponsorComparison != NSOrderedSame)) {
													keepI = (sponsorComparison == NSOrderedAscending) ;
												}
												else {
													/* If both folders are new (not previously in the destination), and are
													 from the same source, the
													 one with the earlier Date Added is kept.  This is important for the
													 following reason.  If you are merging from two or more Import Clients
													 which have similar but not identical hierarchies, for folders which
													 exist in multiple Clients but not in the Collection, if these
													 clients do not themselves provide an Date Added, Date Added is
													 assigned as the time of their import.  Therefore, the folder from
													 the client which is first in the Import Clients table will have an
													 older Date Added, typically by a few seconds, and therefore will be
													 the one that is kept. */
													keepI = ([[iChild addDate] compare:[jChild addDate]] == NSOrderedAscending) ;
												}
											}
											else {
												/* If both folders were in the Destination before the Import or
												 Export, then the one which has higher [item quality]() is kept.
												 
												 Note that this branch is always taken if the Collection ▸
												 Consolidate Folders menu item is clicked. */
												keepI = [iChild overallQualityCompare:jChild] != NSOrderedAscending ;
											}
										}
										else {
											/* The following is from our Help Book…
                                             If one folder is from the source and the other is from the destination,
											 which one is kept depends on the *[Merging Keep]()* setting: If *Merging
											 Keep* is set to *[Client]()*, the folder from the Client is kept.  If set
											 to *[Collection]()*, ... Collection. */
                                            // The above causes Bug 20130308
											 if (keepSourceValue) {
												keepI = [iChild isNewItemThisIxport] ;
                                                 // BOOL keepJ = [jChild isNewItemThisIxport] ;
											}
											else {
												// Keep whichever is from the destination
												// If jChild is new (from source) then iChild
												// must be from destination so set keepI to YES.
												// If jChild is not new (from destin) then iChild
												// must be from source so set keepI to NO.
												keepI = [jChild isNewItemThisIxport] ;
											}
										}
										
										Stark* master = keepI ? iChild : jChild ;
										Stark* contributor = keepI ? jChild : iChild ;							
										
										if (logLevel > 3) {
											logEntry = [[NSString alloc] initWithFormat:@"13820:    Merging folders:\n      Keep: %@\n      Dump: %@\n",
														[master shortDescription],
														[contributor shortDescription]] ;
											[[BkmxBasis sharedBasis] trace:logEntry] ;
											[logEntry release] ;
										}

										// Append exids from the contributor to the master.
										// Note that, for keys existing in both folders,
										// the following method does not overwrite, so that
										// the master's exid entry takes precedence.
										NSDictionary* exids = [master exids] ;
										if (exids) {
											exids = [exids dictionaryByAppendingEntriesFromDictionary:[contributor exids]] ;
										}
										else {
											exids = [contributor exids] ;
										}
										[master setExids:exids] ;
										
										// Move contributor's children (contributions) to master
										// Note: If master and contributor are nil, the following will do nothing
                                        NSArray* contributions = [contributor childrenOrdered] ;
										for (Stark* contribution in contributions) {
											NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
                                            // Note 1212082.  This will remove a child from contributor, which is iChild or jChild,
                                            // and it will add a child to master, which is jChild or iChild.
                                            // But iChild and jChild are two children of self.  Therefore, it
                                            // will not change children of self, so we do not need to readjust
                                            // the 'children' local variable.
											[contribution moveToBkmxParent:master] ;
											[pool release] ;
										}
										
										[bkmxDoc setIgnoreChanges:YES] ;
										
										if (consolidateAndRemoveNow) {
											[[info objectForKey:constKeyMergedFolderLineages] addObject:[contributor lineageLineDoSelf:YES
																															   doOwner:NO]] ;
											[contributor remove] ;  // Note 1212081
											nChildren-- ;
											// The nChildren-- is needed because, even though we are counting down,
											// the inner j-- loop starts at the top each time.  When we
											// removed an item, the top is now one less!											
										}
										else {
											// Until BookMacster version 1.3.5, we did this here…
											// [contributor remove] ;
											// nChildren-- ;
											// But now we do this instead in the 'actuallyDelete' (for
											// import) or 'writeAndDelete' operation
											// because at this point we might still need its attributes in
											// 'syncLog', and for addon exports, when doing the export.
											// (Recall that managed objects' attributes all get
											// set to nil when the managed object is deleted.) 
											[contributor setIsDeletedThisIxport] ;
                                            [foldersDeletedDueToConsolidation addObject:contributor];
										}
									}
								}
							}
						}
						[pool release] ;
					}
				}
				[pool release] ;
			}
		}
		[bkmxDoc setIgnoreChanges:NO] ;
	}
	[pool release] ;
}

#pragma mark * Deep Value-Added Mutators 

/*
 The following six methods do not use Fast Enumeration because 
 Fast Enumeration will raise exceptions if their collection
 object is altered during the enumeration, and I sometimes do that.
 
 Note: Reverse order is not a problem; that is supported.
 See http://developer.apple.com/documentation/Cocoa/Conceptual/ObjectiveC/Articles/chapter_8_section_1.html#//apple_ref/doc/uid/TP30001163-CH18-SW1
 */

- (void)recursivelyPerformSelector:(SEL)selector {
	[self performSelector:selector] ;
    
    if ([self canHaveChildren]) {
        // Call this method recursively to perform selector on each of this object's children's...children
        NSArray* children = [self childrenOrdered] ;
        NSInteger i ; // Don't use unsigned here since we're testing i>=0
        // In case we're moving items out, we start at the last and work down
		// For example, this is the case if selector is ifPersonalBarPositionMovetoBar
		// It is also the case if selector is removeIfSeparator
		for (i=[children count]-1; i>=0 ; i--) {
            [[children objectAtIndex:i] recursivelyPerformSelector:selector] ;
        }
    }
}

- (void)recursivelyPostorderPerformSelector:(SEL)selector
{
    if ([self canHaveChildren]) {
        // Call this method recursively to perform selector on each of this object's children's...children
        NSArray* children = [self childrenOrdered] ;
        NSInteger i ; // Don't use unsigned here since we're testing i>=0
		// In case we're moving items out, we start at the last and work down
		// For example, this is the case if selector is ifPersonalBarPositionMovetoBar
		// It is also the case if selector is removeIfSeparator
		for (i=[children count]-1; i>=0 ; i--) {
            [[children objectAtIndex:i] recursivelyPostorderPerformSelector:selector] ;
        }
    }
	
	[self performSelector:selector] ;
}

- (void)recursivelyPostorderPerformSelector:(SEL)selector
								  withObject:(id)object {
    if ([self canHaveChildren]) {
        // Call this method recursively to perform selector on each of this object's children's...children
        NSArray* children = [self childrenOrdered] ;
        NSInteger i ; // Don't use unsigned here since we're testing i>=0
		// In case we're moving items out, we start at the last and work down
		// For example, this is the case if selector is ifPersonalBarPositionMovetoBar
		// It is also the case if selector is removeIfSeparator
		for (i=[children count]-1; i>=0 ; i--) {
            [[children objectAtIndex:i] recursivelyPostorderPerformSelector:selector
																  withObject:object] ;
        }
    }
	
	[self performSelector:selector
			   withObject:object] ;
}

- (void)recursivelyPerformSelector:(SEL)selector
						withObject:(id)object {
    [self performSelector:selector
			   withObject:object] ;
    
    if ([self canHaveChildren]) {
        // Call this method recursively to perform selector on each of this object's children's...children
        NSArray* children = [self childrenOrdered] ;
        NSInteger i ; // Don't use unsigned here since we're testing i>=0
        // In case we're moving items out, we start at the last and work down
		// For example, this is the case if selector is ifPersonalBarPositionMovetoBar
		for (i=[children count]-1; i>=0; i--) {
			Stark* child = [children objectAtIndex:i] ;
            [child recursivelyPerformSelector:selector
                                   withObject:object] ;
        }
    }
}

- (void)recursivelyPerformSelector:(SEL)selector withObject:(id)object1 withObject:(id)object2
{
	[self performSelector:selector withObject:object1 withObject:object2] ;
	
    if ([self canHaveChildren]) {
        // Call this method recursively to perform selector on each of this object's children's...children
        NSArray* children = [self childrenOrdered] ;
        NSInteger i ; // Don't use unsigned here since we're testing i>=0
		// In case we're moving items out, we start at the last and work down
		// For example, this is the case if selector is ifPersonalBarPositionMovetoBar
		for (i=[children count]-1; i>=0; i--)
        {
            [[children objectAtIndex:i] recursivelyPerformSelector:selector withObject:object1 withObject:(id)object2] ;
        }
    }
}

- (void)recursivelyPerformSelector:(SEL)selector withObject:(id)object toDepth:(NSInteger)maxDepth currentDepth:(NSInteger)currentDepth
{
	[self performSelector:selector withObject:object] ;
    
    if ([self canHaveChildren]) {
        // Call this method recursively to perform selector on each of this object's children's...children
        NSArray* children = [self childrenOrdered] ;
        NSInteger i ; // Don't use unsigned here since we're testing i>=0
		// In case we're moving items out, we start at the last and work down
		// For example, this is the case if selector is ifPersonalBarPositionMovetoBar
		// It is also the case if selector is removeIfSeparator
		NSInteger newDepth = currentDepth + 1 ;
		if (newDepth + 1 < maxDepth) {
			for (i=[children count]-1; i>=0 ; i--) {
				[[children objectAtIndex:i] recursivelyPerformSelector:selector withObject:object toDepth:maxDepth currentDepth:newDepth] ;
			}
		}
    }
}

- (void)fabricateFolders:(NSNumber*)fabricateFolders
          ixportingIndex:(NSInteger)ixportingIndex
              newFolders:(NSMutableSet**)newFolders_p {
	BkmxFabricateFolders fabricateFoldersValue = (BkmxFabricateFolders)[fabricateFolders integerValue] ;
	
	if (fabricateFoldersValue == BkmxFabricateFoldersOff) {
		return ;
	}
	
	if (![self canHaveChildren]) {
		return ;
	}
	
	
	/* We need to make a copy of our children here, lest we modify the set while
     enumerating through it as we send [folder moveToBkmxParent:self]
     in the loop below. */
	NSSet* copyOfOriginalChildren = [[self children] copy] ;
	
    Stark* child ;
	Stark* folder ;
	NSString* tag ;
    NSObject <Hartainertainer, StarkReplicator, Startainer>* startainer = [self allocOwner];

	
	// Create set of new folders
	NSMutableSet* namesAlreadyAdded = [[NSMutableSet alloc] init] ;
    if (self.name) {
        [namesAlreadyAdded addObject:self.name] ;
    }
    for (child in copyOfOriginalChildren) {
		NSArray* tags = [child tags] ;
		if ([tags count] > 0) {
			for (tag in tags) {
				if (![namesAlreadyAdded member:tag]) {
					folder = [[startainer starker] freshDatedStark] ;
					[folder setSharypeValue:SharypeSoftFolder] ;
					[folder setName:tag] ;
					[folder moveToBkmxParent:self] ;
                    [folder setIsNewItem];
                    [folder setSponsorIndex:@(SPONSORED_BY_DESTIN)];
                    [folder setSponsoredIndex:@(PUT_AT_BOTTOM)];
                    [folder setIxportingIndex:ixportingIndex];
					[*newFolders_p addObject:folder];
					[namesAlreadyAdded addObject:tag];
				}
				
				if (fabricateFoldersValue == BkmxFabricateFoldersOne) {
					break ;
				}
			}
		}
	}
	[namesAlreadyAdded release];
    [startainer release];
	
	// Move children that have tags into one of the new folders
	[copyOfOriginalChildren release] ;
	copyOfOriginalChildren = [[self children] copy] ;
	for (child in copyOfOriginalChildren) {
		NSArray* tags = [child tags] ;
		if ([tags count] > 0) {
			// Must be moved/copied into folder(s).
			// The first tag will be a move,
			// the remainder will be copies.
			BOOL hasBeenMoved = NO ;
			for (tag in tags) {
				// Find the folder whose name is this tag and either move,
				// or copy a fresh copy of, the current bookmark into it
                NSObject <Hartainertainer, StarkReplicator, Startainer>* owner = [self allocOwner];
				for (folder in *newFolders_p) {
					if ([tag isEqualToString:[folder name]]) {
						Stark* movee = hasBeenMoved
						? [child replicatedOrphanStarkFreshenedInReplicator:owner]
						: child ;
						[movee moveToBkmxParent:folder] ;
						hasBeenMoved = YES ;
						
						break ;
					}
				}
                [owner release];

				if (fabricateFoldersValue == BkmxFabricateFoldersOne) {
					break ;
				}				
			}
		}
	}
	
	[copyOfOriginalChildren release] ;
}

- (void)createRequiredDatesIfMissing {
	if (![self addDate]) {
		[self setAddDate:[NSDate date]] ;
	}
	if (![self lastModifiedDate]) {
		[self setLastModifiedDate:[NSDate date]] ;
	}
}

- (NSObject <Hartainertainer, StarkReplicator, Startainer>*)owner {
    return [super owner] ;
}

- (NSObject <Hartainertainer, StarkReplicator, Startainer>*)allocOwner {
    return [super allocOwner] ;
}

- (void)assembleAsTreeWithBar:(Stark*)bar
						 menu:(Stark*)menu
					  unfiled:(Stark*)unfiled
					   ohared:(Stark*)ohared {
	// If bar, menu, unfiled and shared were not provided,
	// see if they are already in the self.  (I was not
	// consistent.  Some extores invoke this method with
	// the following already done, some don't.)
	if (!bar) {
		bar = [self firstChildOfSharype:SharypeBar] ;
	}
	if (!menu) {
		menu = [self firstChildOfSharype:SharypeMenu] ;
	}
	if (!unfiled) {
		unfiled = [self firstChildOfSharype:SharypeUnfiled] ;
	}
	if (!ohared) {
		ohared = [self firstChildOfSharype:SharypeOhared] ;
	}
	
	/* Set names, because they will show in the Sync Log. */
    NSObject <Hartainertainer, StarkReplicator, Startainer>* owner = [self allocOwner] ;
    
	[(Stark*)bar setName:[owner displayNameForHartainerSharype:SharypeBar]] ;
	[(Stark*)menu setName:[owner displayNameForHartainerSharype:SharypeMenu]] ;
	[(Stark*)unfiled setName:[owner displayNameForHartainerSharype:SharypeUnfiled]] ;
	[(Stark*)ohared setName:[owner displayNameForHartainerSharype:SharypeOhared]] ;
    [owner release];
	
	// Set Sharypes
	[self setSharypeValue:SharypeRoot] ;
    [bar setSharypeValue:SharypeBar] ;
    [menu setSharypeValue:SharypeMenu] ;
	[unfiled setSharypeValue:SharypeUnfiled] ;
	[ohared setSharypeValue:SharypeOhared] ;		
	
	// Cut if necessary and graft at correct positions.
	// (Note that existing children of self, if any, will
	//  be pushed down, to higher indexes.)
	NSInteger nextIndex = 0 ;
	if (bar) {
		[bar moveToBkmxParent:self
					  atIndex:nextIndex
					  restack:YES] ;
		nextIndex++ ;
	}
	if (menu) {
		[menu moveToBkmxParent:self
					   atIndex:nextIndex
					   restack:YES] ;
		nextIndex++ ;
	}
	if (unfiled) {
		[unfiled moveToBkmxParent:self
						  atIndex:nextIndex
						  restack:YES] ;
		nextIndex++ ;
	}
	[ohared moveToBkmxParent:self
					 atIndex:nextIndex	 
					 restack:YES] ;
}


#pragma mark * Viewing

/* 
 See Note 20120313 below.
 
 This method is invoked when
 1.  The Content Outline is initially loaded.
 2.  User clicks menu > Bookmarks[helf] > Expand Roots or Collapse Roots. */
- (void)realizeIsExpandedIntoOutline:(ContentOutlineView*)outlineView {
    if ([self canHaveChildren]) {
        if ([[self isExpanded] boolValue]) {
            [outlineView expandStark:self] ;
        }
        else {
            [outlineView collapseStark:self] ;
        }
    }
}

#pragma mark * Debugging

- (void)appendIndentedNameToString:(NSMutableString*)string {
    NSMutableString* indent = [[NSMutableString alloc] init] ;
    for (NSInteger i=0; i<[self lineageDepth]; i++) {
        [indent appendString:@"   "] ;
    }
    [string appendFormat:@"%@%@\n", indent, [self name]] ;
    [indent release] ;
}

- (void)debugLogTree {
    NSMutableString* tree = [[NSMutableString alloc] init] ;
    [self recursivelyPerformSelector:@selector(appendIndentedNameToString:)
                          withObject:tree] ;
    NSObject <Hartainertainer, StarkReplicator, Startainer>* owner = [self allocOwner];
    NSLog(@"Tree from %@:\n%@", owner, tree);
    [owner release];
    [tree release] ;
}

// From NSManagedObject documentation: "You are discouraged from overriding
// description ... if this method fires a fault during a debugging
// operation, the results may be unpredictable.
- (NSString*)shortDescription {
#if 0
#warning Stark's -shortDescripition is shortcut and lineage only.
	return [NSString stringWithFormat:@"%@ sc=%@ %@", 
			[self starkid],
			[self shortcut],
			[self lineageLineDoSelf:YES doOwner:YES]] ;
#else
	NSString* truncatedID =	[self truncatedID];
	NSString* starkid =	[self starkid];
	NSString* readableSharype = [StarkTyper readableSharype:[self sharypeValue]];
	NSString* name = [[self name] stringByTruncatingMiddleToLength:30
														wholeWords:NO];
	Stark* parent = [self parent] ;
	NSString* parentName ;
	if ([parent isFault]) {
		parentName = @"<FAULT>" ;
	}
	else {
		parentName = [[[self parent] name] stringByTruncatingMiddleToLength:8
																 wholeWords:NO] ;
	}
    NSObject <Hartainertainer, StarkReplicator, Startainer>* owner = [self allocOwner];
	NSString* ownerClassName = [owner className];
	BOOL isOwnedByExtore = [owner respondsToSelector:@selector(client)] ;
	NSString* ownerExid ;
	if (isOwnedByExtore) {
		Clientoid* clientoid = [[(Extore*)owner client] clientoid] ;
		NSString* suffix = [self exidForClientoid:clientoid] ;
		ownerExid = [NSString stringWithFormat:@" owrExid: %@", suffix] ;
	}
	else {
		ownerExid = @"" ;
	}
    [owner release];
    NSString* sd = [NSString stringWithFormat:@"<Stk %p %@ %@> %@, %@ par:(%@ %p) ix=%ld isS=%@ toR=%@ iI=%@ nC=%ld nT=%ld nOV=%ld flg=0x%lx isF=%hhd isD=%hhd owr=%@%@",
					self,
					truncatedID,
					starkid,
					readableSharype,
					name,
					parentName,
					[self parent],
					(long)[self indexValue],
					[self isShared],
					[self toRead],
					[self describeIxportingIndexes],
					(long)[[self children] count],
					(long)[[self tags] count],
					(long)[[self ownerValues] count],
					(long)[self ixportFlags],
					[self isFault],
					[self isDeleted],
					ownerClassName,
					ownerExid
					] ;
	return sd ;
#endif
}

// Very strange.  If I rename this method, thus making it use the @dynamic,
// then when I check a "Shared" box in the content outline view or Inspector,
// it immediately un-checks itself.  Very strange.
- (NSNumber *)isShared 
{
    NSNumber * tmpValue;
    
    [self willAccessValueForKey:@"isShared"];
    tmpValue = [self primitiveIsShared];
    [self didAccessValueForKey:@"isShared"];
    
    return tmpValue;
}

/*- (void)correctExidsFromFeedbacks:(NSDictionary*)feedbacks
							 info:(NSDictionary*)info {
	if (![self isHartainer]) {
		Clientoid* clientoid = 	[(Client*)[[info objectForKey:constKeyExtore] client] clientoid] ;
		NSString* parentExid = [[self parent] exidForClientoid:clientoid] ;
		NSString* indexString = [NSString stringWithFormat:@"%d", [[self index ] integerValue]] ;
		NSString* correctExid = [[feedbacks objectForKey:parentExid] objectForKey:indexString] ;
		
		if (correctExid) {
			Stark* mateInBkmxDoc = [[info objectForKey:constKeyExportFeedbackDic] objectForKey:[self objectID]] ;
			if (mateInBkmxDoc) {
				// The following 'if' should not be needed but is defensive programming
				// against "Core Data could not fulfill a fault…" errors
				if (![mateInBkmxDoc isDeleted]) {
					// We first check to see if there has been any change, to avoid
					// unnecessarily dirtying the dot
					NSString* currentExid = [mateInBkmxDoc exidForClientoid:clientoid] ;
					if (![NSString isEqualHandlesNilString1:currentExid
													string2:correctExid]) {
						[mateInBkmxDoc setExid:correctExid
								 forClientoid:clientoid] ;
					}
				}
			}
		}
	}
}
*/

- (BOOL)descendsFromAnyOf:(NSArray*)parents {
	// Guard against infinite loops
	if (self == [self parent]) {
		NSLog(@"Internal Error 647-5778: Is own parent: %@", [self shortDescription]) ;
		return NO ;
	}
	
    Stark* stark = self ;
    NSInteger indexOfMe = [parents indexOfObject:self] ;

	while (stark && ![stark isRoot]) {
        NSInteger foundIndex = [parents indexOfObject:stark] ;
		if ((foundIndex != NSNotFound) && (foundIndex != indexOfMe)) {
            return YES ;
        }
		// The following was moved in BookMacster 1.3.15.  Prior to that, this
		// line was before the while() above, which caused infinite loop.
		// But it's been this way for at least a month.  Why are users not reporting
		// infinite loops???
		stark = [stark parent] ;
    }
    
    return NO ;
}

- (BOOL)finalizeLastModifiedDate {
	BOOL isChanged = NO ;
    NSDictionary* newValuesDic = [self changedValues] ;
    NSDictionary* oldValuesDic = [self committedValuesForKeys:[newValuesDic allKeys]] ;
    for (NSString* key in newValuesDic) {
        if ([key isEqualToString:constKeyLastModifiedDate]) {
            continue ;
        }
			
        isChanged = ![NSObject isEqualHandlesNilObject1:[newValuesDic objectForKey:key]
                                                object2:[oldValuesDic objectForKey:key]] ;
        if (isChanged) {
            break ;
        }
    }
    
    if (isChanged) {
        [self setLastModifiedDate:[NSDate date]] ;
	}
	
	return isChanged;
}

NSString* const constKeyDebugHashValue = @"HASH";

+ (NSMutableArray*)debug_contentHashComponents {
    if (!static_debug_contentHashComponents) {
        static_debug_contentHashComponents = [[NSMutableArray alloc] init] ;
    }
    
    return static_debug_contentHashComponents ;
}

+ (void)debug_clearHashComponents {
    [[self debug_contentHashComponents] removeAllObjects] ;
}

+ (void)debug_writeHashComponentsToDesktopWithPhaseName:(NSString*)phaseName
                                             clientName:(NSString*)clientName {
    NSArray* hashComponents = [self debug_contentHashComponents];
    NSString* text = [hashComponents description];
    NSString* finalHashString = [[hashComponents lastObject] lastObject];
    NSArray* finalHashStringComps = [finalHashString componentsSeparatedByString:@" "];
    NSString* finalHashValueString = [finalHashStringComps lastObject];
    NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:@"Desktop"];
    path = [path stringByAppendingPathComponent:@"Bkmx-Hash-Components"];
    [[NSFileManager defaultManager] createDirectoryAtPath:path
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:NULL];
    NSMutableString* dateTimeString = [[[NSDate date] compactDateTimeString] mutableCopy];
    [dateTimeString insertString:@"-"
                         atIndex:8];
    NSString* filename = [NSString stringWithFormat:
                          @"%@-%@-%@-pid%05ld-0x%@",
                          [clientName substringToIndex:3],
                          dateTimeString,
                          phaseName,
                          (long)getpid(),
                          finalHashValueString
                          ];
    [dateTimeString release];
    path = [path stringByAppendingPathComponent:filename] ;
    path = [path stringByAppendingPathExtension:@"txt"] ;
    [text writeToFile:path
           atomically:YES
             encoding:NSUTF8StringEncoding
                error:NULL] ;
}

- (uint32_t)valuesHashOfAttributes:(NSArray*)attributes {
	unsigned long childrenHash = 0x0 ;
	for (Stark* child in [self childrenOrdered]) {
		// At first I was going to add these, until I learned that the
		// result of an integer addition which overflows is undefined
		// in C.  Bitwise xor can't overflow.
        uint32_t childHash = [child valuesHashOfAttributes:attributes] ;
        childrenHash ^= childHash ;
		
		// Note that I am using the more economical xor operator rather
		// than Robert Jenkins' nonlinear mix() function for mixing in 
		// the hashes of children.  This might mean that sorting the
		// children would not change the value of childrenHash,
		// because of reordering the inputs will not change the result
		// of a linear function.  However, because each child has an
		// -index value which is included in its own hash, and because
		// its own hash is calculated using Robert Jenkins' mix()
		// function, the different indexes cause each child's hash
		// to be different in such a way that it is not cancelled out
		// by differences in other children, provided that other attributes
		// are also different.  If other attributes are the same, well,
		// then these are duplicate bookmarks, and swapping them around
		// should result in the same childrenHash value anyhow.
	}

	NSMutableArray* hashableValues = [[NSMutableArray alloc] init] ;
    BOOL debugIxportHashes = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppBoolForKey:constKeyDebugIxportHashes];
    NSMutableArray* starkHashComponents = nil;
    if (debugIxportHashes) {
        starkHashComponents = [[NSMutableArray alloc] init] ;
        [[[self class] debug_contentHashComponents] addObject:starkHashComponents] ;
        [starkHashComponents release] ;
    }
    for (NSString* key in attributes) {
		id aValue = [self valueForKey:key] ;
		
		if (aValue) {
			[hashableValues addObject:aValue] ;
            if (debugIxportHashes) {
                NSString* keyValuePair = [NSString newBkmxDebugReadableKey:key
                                                                     value:aValue];
                [starkHashComponents addObject:keyValuePair];
                [keyValuePair release];
            }
        }
	}
	
	uint32_t hash = [hashableValues mixHash:(uint32_t)childrenHash] ;
	// Note that we combine the children into the receiver's hash using
	// mixHash rather than just xor which would be more economical.
	// The reason is so that we get different hash values from two
	// trees which are the same except for all children of one
	// folder being swapped for all children of another folder.
	[hashableValues release] ;

    if (debugIxportHashes) {
        [starkHashComponents sortUsingSelector:@selector(caseInsensitiveCompare:)];
        [starkHashComponents insertObject:[NSString stringWithFormat:@"exid=%@:", self.exid]
                                  atIndex:0];
        if (childrenHash != 0) {
            NSString* childrenHashString = [NSString stringWithFormat:@"%08lx", (long)childrenHash] ;
            NSString* keyValuePair = [NSString newBkmxDebugReadableKey:@"From Children"
                                                                 value:childrenHashString];
            [starkHashComponents addObject:keyValuePair];
            [keyValuePair release];
        }
        NSString* result = [NSString stringWithFormat:@"%08lx", (long)hash] ;
        NSString* keyValuePair = [NSString newBkmxDebugReadableKey:constKeyDebugHashValue
                                                             value:result];
        [starkHashComponents addObject:keyValuePair] ;
        [keyValuePair release];
    }

	return hash ;
}

@end


/*
 Note 20120313

 Core Data document, displays its tree of objects in an NSOutlineView, 
 macOS 10.7.  As I believe is standard practice, I store the 
 expanded/collapsed state of nodes in an auxiliary store.  During
 -[NSOutlineView reloadData], each object in the tree gets this message

- (void)realizeIsExpandedIntoOutline:(NSOutlineView*)outlineView {
     if ([self canHaveChildren]) {
         if ([[self isExpanded] boolValue]) {
             [outlineView expandStark:self] ;
         }
         else {
             [outlineView  collapseStark:self] ;
         }
     }        
}

(Actually, each one gets that message 4 times, but I think this is typical of
 Cocoa.)

The issue was that documents with large, flat folders take a long time to open.
Test document having of a single root node containing 8000 leaves is terrible…

Time to open document: 160 seconds
Peak memory usage: about 2 GB

The 4 times that the root node is expanded, it takes about 10 seconds,
2 milliseconds, 40 seconds, and 10 seconds.  Weird.  The rest of the time was
 mostly popping autorelease pools.

So I did something really boneheaded: Don't expand items that are already
 expanded, and don't collapse items that are already collapsed…

- (void)realizeIsExpandedIntoOutline:(NSOutlineView*)outlineView {
     if ([self canHaveChildren]) {
         if ([[self isExpanded] boolValue]) {
             if (![outlineView isItemExpanded:self]) {
                 [outlineView expandStark:self] ;
             }
         }
         else if ([outlineView isItemExpanded:self]) {
             [outlineView  collapseStark:self] ;
         }
     }        
}

Documentation for -expandItem and -collapseItem say, respectively, that "If item
is not expandable or is already expanded, does nothing" and "If item is not
 expanded or not expandable, does nothing".  So my improved code is eliminating
 "nothing".  But "nothing" must be an understatement because now…

Time to open document: 4 seconds
Peak memory usage: Not noticeable to 100 MB

I've tested this back and forth 3 times and am convinced that it's real.  One of
the things that happens when expand/collapsing the root is that each of the 8000
 children is asked for its -numberOfChildren.  Why?  -expandItem and
 -collapseItem are not recursive.

Here is some a sample, taken with the old code.  2216 was the total number of
samples…

……<snip />……
+ 2216 -[ContentOutlineView reloadData]  (in Bkmxwork) ContentOutlineView.m:311
+   2216 -[ContentOutlineView realizeIsExpandedValuesFromModelFromRoot:]  (in Bkmxwork) ContentOutlineView.m:545
+     2216 -[Stark recursivelyPerformSelector:withObject:]  (in Bkmxwork) Stark.m:3778
+       2216 -[NSObject performSelector:withObject:]  (in CoreFoundation) 
+         2216 -[Stark realizeIsExpandedIntoOutline:]  (in Bkmxwork) Stark.m:3993
+           2216 -[NSOutlineView collapseItem:]  (in AppKit) 
+             2216 -[NSOutlineView collapseItem:collapseChildren:]  (in AppKit)
+               2216 -[NSOutlineView _collapseItem:collapseChildren:clearExpandState:]
+                 2216 -[NSOutlineView _rowEntryForItem:requiredRowEntryLoadMask:]  (in AppKit) 
+                   2216 findAndLoadRowEntryForUnloadedLazyItem  (in AppKit)
+                     2209 loadItemEntryLazyInfoIfNecessary  (in AppKit)
+                     ! 2208 -[NSOutlineView _dataSourceChild:ofItem:isShowMoreRow:]
+                     ! : 2204 -[ContentDataSource outlineView:child:ofItem:] (in Bkmxwork) ContentDataSource.m:334
+                     ! : | 2016 -[SSYManagedTreeObject childAtIndex:]  (in Bkmxwork)  SSYManagedTreeObject.m:158
+                     ! : | + 1492 -[SSYManagedTreeObject indexValue]  (in Bkmxwork) SSYManagedTreeObject.m:144
+                     ! : | + ! 1409 _pvfk_10  (in CoreData)
+                     ! : | + ! : 1169 _sharedIMPL_pvfk_core  (in CoreData)
+                     ! : | + ! : | 1014 snapshot_get_value_as_object  (in CoreData)
+                     ! : | + ! : | + 810 +[NSNumber numberWithInt:]  (in Foundation)
+                     ! : | + ! : | + ! 625 -[NSPlaceholderNumber initWithInt:]  (in Foundation)
+                     ! : | + ! : | + ! : 453 CFNumberCreate  (in CoreFoundation)
+                     ! : | + ! : | + ! : | 309 _CFRuntimeCreateInstance  (in CoreFoundation)
+                     ! : | + ! : | + ! : | + 282 CFAllocatorAllocate  (in CoreFoundation) 
+                     ! : | + ! : | + ! : | + ! 275 __CFAllocatorSystemAllocate  (in CoreFoundation)
+                     ! : | + ! : | + ! : | + ! : 257 malloc_zone_malloc  (in libsystem_c.dylib)
+                     ! : | + ! : | + ! : | + ! : | 247 szone_malloc  (in libsystem_c.dylib) 
+                     ! : | + ! : | + ! : | + ! : | + 91 szone_malloc_should_clear  (in libsystem_c.dylib)
+                     ! : | + ! : | + ! : | + ! : | + 81 szone_malloc_should_clear  (in libsystem_c.dylib)
+                     ! : | + ! : | + ! : | + ! : | + ! 81 tiny_malloc_from_free_list  (in libsystem_c.dylib)
……<snip />……
+                     ! : | + ! : | + ! : 99 CFNumberCreate  (in CoreFoundation)
……<snip />……
+                     ! : | + ! : | + ! 98 objc_msgSend  (in libobjc.A.dylib)
……<snip />……
+                     ! : | + ! : | + 99 +[NSNumber numberWithInt:]  (in Foundation) 
……<snip />……
+                     ! : | + ! : 180 _sharedIMPL_pvfk_core  (in CoreData) 
……<snip />……
+                     ! : | + 368 objc_msgSend  (in libobjc.A.dylib)
+                     ! : | + 136 -[SSYManagedTreeObject indexValue]  (in Bkmxwork) SSYManagedTreeObject.m:144
……<snip />……
+                     ! : | 158 -[SSYManagedTreeObject childAtIndex:]  (in Bkmxwork) SSYManagedTreeObject.m:162
+                     ! : | + 152 -[_NSFaultingMutableSet countByEnumeratingWithState:objects:count:]  (in CoreData)
+                     ! : | + ! 147 -[__NSCFSet countByEnumeratingWithState:objects:count:]  (in CoreFoundation)
+                     ! : | + ! : 96 __CFBasicHashFastEnumeration  (in CoreFoundation)
+                     ! : | + ! : | 96 CFBasicHashGetBucket  (in CoreFoundation)

*/

/*
Note WeirdyTabSet
 
 #0	0x000000010011bb02 in -[SSYManagedObject postWillSetNewValue:forKey:] at /Users/jk/Documents/Programming/ClassesObjC/SSYManagedObject.m:319
 #1	0x00000001000e62ec in -[Stark setRawTags:] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/Stark.m:935
 #2	0x00000001000e6382 in -[Stark setTags:] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/Stark.m:944
 #3	0x00000001001867fa in +[StarkEditor addTags:toBookmarks:] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/StarkEditor.m:595
 #4	0x0000000100298419 in +[Starki didApproveChangesSheet:returnCode:contextInfo:] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/Starki.m:166
 #5	0x00007fff9348909c in __invoking___ ()
 #6	0x00007fff93488f37 in -[NSInvocation invoke] ()
 #7	0x0000000100299899 in -[Starki setValue:forUndefinedKey:] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/Starki.m:305
 #8	0x0000000100299940 in -[Starki setTags:] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/Starki.m:324
 #9	0x00007fff94662165 in -[NSObject(NSKeyValueCoding) setValue:forKey:] ()
 #10	0x000000010004ca2d in -[ContentOutlineView setSelectedStarkiTags:] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/ContentOutlineView.m:105
 #11	0x00007fff94686558 in _NSSetObjectValueAndNotify ()
 #12	0x00007fff94662165 in -[NSObject(NSKeyValueCoding) setValue:forKey:] ()
 #13	0x00007fff9608ab1c in -[NSObjectParameterBinder _updateObject:observedController:observedKeyPath:context:] ()
 #14	0x00007fff96074699 in -[NSObject(NSKeyValueBindingCreation) bind:toObject:withKeyPath:options:] ()
 #15	0x000000010004d630 in -[ContentOutlineView bindColorForKey:] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/ContentOutlineView.m:250
 #16	0x000000010004d809 in -[ContentOutlineView awakeFromNib] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/ContentOutlineView.m:280
 #17	0x00007fff9348d8e9 in -[NSSet makeObjectsPerformSelector:] ()
 #18	0x00007fff95efd136 in -[NSIBObjectData nibInstantiateWithOwner:topLevelObjects:] ()
 #19	0x00007fff95edc11d in loadNib ()
 #20	0x00007fff95edb649 in +[NSBundle(NSNibLoading) _loadNibFile:nameTable:withZone:ownerBundle:] ()
 #21	0x00007fff95edb47e in -[NSBundle(NSNibLoading) loadNibNamed:owner:topLevelObjects:] ()
 #22	0x00000001002c36d3 in -[BkmxLazyView loadWithOwner:] at /Users/jk/Documents/Programming/ClassesObjC/BkmxLazyView.m:80
 #23	0x00000001002c417b in -[BkmxLazyView viewDidMoveToWindow] at /Users/jk/Documents/Programming/ClassesObjC/BkmxLazyView.m:203
 #24	0x00007fff95f062e7 in -[NSView _setWindow:] ()
 #25	0x00007fff95f0fa77 in -[NSView addSubview:] ()
 #26	0x00007fff95f205af in -[NSView replaceSubview:with:] ()
 #27	0x00007fff9605d49f in -[NSTabView _switchTabViewItem:oldView:withTabViewItem:newView:initialFirstResponder:lastKeyView:] ()
 #28	0x00007fff9605cd14 in -[NSTabView selectTabViewItem:] ()
 #29	0x00000001001ee320 in -[SSYTabView selectTabViewItem:] at /Users/jk/Documents/Programming/ClassesObjC/SSYTabView.m:66
 #30	0x00000001001ee230 in -[SSYTabView setSelectedTabIndex:] at /Users/jk/Documents/Programming/ClassesObjC/SSYTabView.m:53
 #31	0x00000001001ee4e0 in -[SSYTabView selectTabViewItemWithIdentifier:] at /Users/jk/Documents/Programming/ClassesObjC/SSYTabView.m:92
 #32	0x00000001000da0e2 in -[BkmxDocWinCon awakeFromNib] at /Users/jk/Documents/Programming/Projects/BkmkMgrs/BkmxDocWinCon.m:1936

*/
