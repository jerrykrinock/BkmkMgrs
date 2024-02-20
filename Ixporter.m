#import <Bkmxwork/Bkmxwork-Swift.h>
#import "Ixporter.h"
#import "BkmxBasis+Strings.h"
#import "NSError+MyDomain.h"
#import "BkmxDoc.h"
#import "Chaker.h"
#import "Extore.h"
#import "Stark+Sorting.h"
#import "Stark+Attributability.h"
#import "Starker.h"
#import "Client.h"
#import "Importer.h"
#import "Exporter.h"
#import "SSYBetterHashCategories.h"
#import "TagMap.h"
#import "FolderMap.h"
#import "NSError+InfoAccess.h"
#import "NSObject+DoNil.h"
#import "SSYOperationQueue.h"
#import "NSArray+SafeGetters.h"
#import "NSArray+SSYMutations.h"
#import "NSObject+MoreDescriptions.h"
#import "SSYProgressView.h"
#import "NSNumber+Sharype.h"
#import "SSYMocManager.h"
#import "NSManagedObject+Debug.h"
#import "Macster.h"
#import "NSDictionary+Subdictionary.h"
#import "NSNumber+SomeMore.h"
#import "NSSet+Indexing.h"
#import "NSEntityDescription+SSYMavericksBugFix.h"
#import "StarkMatch.h"

#if DEBUG
extern BOOL gDoLog ;
#endif

static NSArray* static_hashableKeyPaths = nil ;

// During development of BookMacster 1.7.3, I considered setting the following to 1:
#define ONLY_PRIMARY_SOURCE_CAN_IMPORT_DELETIONS 0
// But ultimately decided that this was not needed, because the only situation I
// could think of in which an item would be *inadvertantly* deleted would be if
// it was not exportable to Client C, and then an import occurred from Client C
// only.  But this problem has already been solved – See Note 520349 below.
// By defining the above to 1 (although I did not test it), users would no
// longer be able to make deletions that "stick" in the non-primary Client.
// Therefore, users still have the capability of deleting bookmarks and having
// their deletions imported from *any* client.
// Of course, code within #if ONLY_PRIMARY_SOURCE_CAN_IMPORT_DELETIONS has not
// been tested very much.

NSString* const constKeyDeleteUnmatched = @"deleteUnmatched" ;
NSString* const constKeyFabricateFolders = @"fabricateFolders" ;
NSString* const constKeyFabricateTags = @"fabricateTags" ;
NSString* const constKeyFolderMaps = @"folderMaps" ;
NSString* const constKeyIxportCount = @"ixportCount" ;
NSString* const constKeyMergeBias = @"mergeBias" ;
NSString* const constKeyMergeBy = @"mergeBy" ;
NSString* const constKeyShareNewItems = @"shareNewItems" ;
NSString* const constKeySkipFileUrls = @"skipFileUrls" ;
NSString* const constKeySkipJavaScript = @"skipJavaScript" ;
NSString* const constKeySkipRssFeeds = @"skipRssFeeds" ;
NSString* const constKeySkipSeparators = @"skipSeparators" ;
NSString* const constKeyTagMaps = @"tagMaps" ;
NSString* const constKeySponsoredChildren = @"sponsoredChildren" ;

NSString* const constKeyOrphanStark = @"orphStrk" ;
NSString* const constKeySourceParentObjectID = @"srcPrtOID" ;


@interface Ixporter (CoreDataGeneratedPrimitiveAccessors)

- (void)setPrimitiveDeleteUnmatched:(NSNumber*)value;
- (void)setPrimitiveFabricateFolders:(NSNumber*)value;
- (void)setPrimitiveFabricateTags:(NSNumber*)value;
- (void)setPrimitiveFolderMaps:(NSSet*)value;
- (void)setPrimitiveIsActive:(NSNumber*)value;
- (void)setPrimitiveMergeBy:(NSNumber*)value;
- (void)setPrimitiveMergeBias:(NSNumber*)value;
- (void)setPrimitiveShareNewItems:(NSNumber*)value;
- (void)setPrimitiveSkipFileUrls:(NSNumber*)value;
- (void)setPrimitiveSkipJavaScript:(NSNumber*)value;
- (void)setPrimitiveSkipRssFeeds:(NSNumber*)value;
- (void)setPrimitiveSkipSeparators:(NSNumber*)value;
- (void)setPrimitiveTagMaps:(NSSet*)value;
- (NSMutableSet*)primitiveFolderMaps ;
- (NSMutableSet*)primitiveTagMaps ;

@end

@interface Ixporter ()

@end


@implementation Ixporter

/*!
 @brief    Returns an sorted array of all of the receiving class's
 key paths whose values which should be used when calculating a hash
 representing the attributes seen by the user.
 
 @details  The returned array is sorted and stored in a static
 variable, so that this is fast, and will give identical results in
 every application run.
 */
+ (NSArray*)hashableKeyPaths {
    if (!static_hashableKeyPaths) {
        NSEntityDescription* entityDescription = [self entityDescription] ;
        NSArray* keyPaths = [[entityDescription attributesByName] allKeys] ;
        keyPaths = [keyPaths arrayByRemovingObject:constKeyIxportCount] ;
        // clidentifier is also important, because if you're importing from
        // or exporting to a different client, obviously that should affect
        // the hash of the last import or export.  However, since 'client' is
        // a relationship and not an attribute, clidentifier must be added
        // separately…
        keyPaths = [keyPaths arrayByAddingObject:@"client.clientoid.clidentifier"] ;
        static_hashableKeyPaths = [keyPaths sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] ;
        [static_hashableKeyPaths retain] ;
    }
    
    return static_hashableKeyPaths ;
}

/* // These are useless because, when uncommented, I get in the document, 
 // during save, after specifying path, a sheet which says:
 //    The document "Untitled" could not be saved as "Untitled."  OK
 // or
 //    The document “Untitled.bkmaster” could not be saved. Multiple validation errors occurred.
 // It does not display the info I give in the error
 - (BOOL)validateForUpdate:(NSError **)error {
 [super validateForInsert:error] ;
 NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
 @"Update validation failed", NSLocalizedDescriptionKey,
 @"Bad update", NSLocalizedFailureReasonErrorKey,
 @"Read da manual", NSLocalizedRecoverySuggestionErrorKey,
 nil] ;
 *error = [NSError errorWithDomain:@"My Domain"
 code:97
 userInfo:info] ;
 return NO ;
 }
 
 - (BOOL)validateForInsert:(NSError **)error {
 [super validateForInsert:error] ;
 NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
 @"Insert validation failed", NSLocalizedDescriptionKey,
 @"Bad update", NSLocalizedFailureReasonErrorKey,
 @"Read da manual", NSLocalizedRecoverySuggestionErrorKey,
 nil] ;
 *error = [NSError errorWithDomain:@"My Domain"
 code:98
 userInfo:info] ;
 return NO ;
 }
 */

#pragma mark * Accessors for non-managed object properties


#pragma mark * Core Data Generated Accessors for managed object properties

@dynamic deleteUnmatched ;
@dynamic client ;
@dynamic fabricateFolders ;
@dynamic fabricateTags ;
@dynamic folderMaps ;
@dynamic isActive ;
@dynamic ixportCount ;
@dynamic mergeBias ;
@dynamic mergeBy ;
@dynamic preferredCatchype ;
@dynamic shareNewItems ;
@dynamic skipSeparators ;
@dynamic skipFileUrls ;
@dynamic skipJavaScript ;
@dynamic skipRssFeeds ;
@dynamic tagMaps ;

@synthesize extore = m_extore ;
@synthesize bkmxDoc = m_bkmxDoc ;

#pragma mark * Custom Accessors for specially managed object properties

- (void)setDeleteUnmatched:(NSNumber*)value {
    [self postWillSetNewValue:value
                       forKey:constKeyDeleteUnmatched] ;
    [self willChangeValueForKey:constKeyDeleteUnmatched] ;
    [self setPrimitiveDeleteUnmatched:value];
    [self didChangeValueForKey:constKeyDeleteUnmatched] ;
    
    [self doMergeByBusinessLogic] ;
    
    [[[self client] macster] postTouchedClient:[self client]
                                      severity:4] ;
}

- (void)setFabricateFolders:(NSNumber*)newValue  {
    [self postWillSetNewValue:newValue
                       forKey:constKeyFabricateFolders] ;
    [self willChangeValueForKey:constKeyFabricateFolders] ;
    [self setPrimitiveFabricateFolders:newValue] ;
    [self didChangeValueForKey:constKeyFabricateFolders] ;
    
    [[[self client] macster] postTouchedClient:[self client]
                                      severity:4] ;
}

- (void)setFabricateTags:(NSNumber*)newValue  {
    [self postWillSetNewValue:newValue
                       forKey:constKeyFabricateTags] ;
    [self willChangeValueForKey:constKeyFabricateTags] ;
    [self setPrimitiveFabricateTags:newValue] ;
    [self didChangeValueForKey:constKeyFabricateTags] ;
    
    [[[self client] macster] postTouchedClient:[self client]
                                      severity:4] ;
}

- (void)removeFolderMapsObject:(id)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:constKeyFolderMaps withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveFolderMaps] removeObject:value] ;
    [self didChangeValueForKey:constKeyFolderMaps withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
    
    [[[self client] macster] postTouchedClient:[self client]
                                      severity:4] ;
}

- (void)addFolderMapsObject:(id)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:constKeyFolderMaps withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveFolderMaps] addObject:value];
    [self didChangeValueForKey:constKeyFolderMaps withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
    
    [[[self client] macster] postTouchedClient:[self client]
                                      severity:4] ;
}

- (void)removeTagMapsObject:(id)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:constKeyTagMaps withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveTagMaps] removeObject:value] ;
    [self didChangeValueForKey:constKeyTagMaps withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
    
    [[[self client] macster] postTouchedClient:[self client]
                                      severity:4] ;
}

- (void)addTagMapsObject:(id)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:constKeyTagMaps withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveTagMaps] addObject:value];
    [self didChangeValueForKey:constKeyTagMaps withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
    
    [[[self client] macster] postTouchedClient:[self client]
                                      severity:4] ;
}

#if 0
// I suppose I should implement this too?
- (void)intersectFolderMaps:(NSSet *)objects {
    
    ???
    [[[self client] macster] postTouchedClient:[self client]
                                      severity:4] ;
}
#endif

// This method seems to be never invoked, but I left it in here because
// its never-invokedness is probably a Cocoa implementation detail.
- (void)setFolderMaps:(NSSet*)newValue  {
    [self postWillSetNewValue:newValue
                       forKey:constKeyFolderMaps] ;
    [self willChangeValueForKey:constKeyFolderMaps] ;
    [self setPrimitiveFolderMaps:newValue] ;
    [self didChangeValueForKey:constKeyFolderMaps] ;
    
    [[[self client] macster] postTouchedClient:[self client]
                                      severity:4] ;
}

// This method seems to be never invoked, but I left it in here because
// its never-invokedness is probably a Cocoa implementation detail.
- (void)setTagMaps:(NSSet*)newValue  {
    [self postWillSetNewValue:newValue
                       forKey:constKeyTagMaps] ;
    [self willChangeValueForKey:constKeyTagMaps] ;
    [self setPrimitiveTagMaps:newValue] ;
    [self didChangeValueForKey:constKeyTagMaps] ;
    
    [[[self client] macster] postTouchedClient:[self client]
                                      severity:4] ;
}

- (void)setIsActive:(NSNumber*)newValue  {
    [self postWillSetNewValue:newValue
                       forKey:constKeyIsActive] ;
    [self willChangeValueForKey:constKeyIsActive] ;
    [self setPrimitiveIsActive:newValue] ;
    [self didChangeValueForKey:constKeyIsActive] ;
    
    /* If .active is being set to YES, we want to prompt the user to export,
     and this will happeen if severity > 4. */
    NSInteger severity = newValue.boolValue ? 5 : 4;
    [[[self client] macster] postTouchedClient:[self client]
                                      severity:severity];
}

- (void)setSkipFileUrls:(NSNumber*)newValue  {
    [self postWillSetNewValue:newValue
                       forKey:constKeySkipFileUrls] ;
    [self willChangeValueForKey:constKeySkipFileUrls] ;
    [self setPrimitiveSkipFileUrls:newValue] ;
    [self didChangeValueForKey:constKeySkipFileUrls] ;
    
    [[[self client] macster] postTouchedClient:[self client]
                                      severity:4] ;
}

- (void)setSkipJavaScript:(NSNumber*)newValue  {
    [self postWillSetNewValue:newValue
                       forKey:constKeySkipJavaScript] ;
    [self willChangeValueForKey:constKeySkipJavaScript] ;
    [self setPrimitiveSkipJavaScript:newValue] ;
    [self didChangeValueForKey:constKeySkipJavaScript] ;
    
    [[[self client] macster] postTouchedClient:[self client]
                                      severity:4] ;
}

- (void)setSkipRssFeeds:(NSNumber*)newValue  {
    [self postWillSetNewValue:newValue
                       forKey:constKeySkipRssFeeds] ;
    [self willChangeValueForKey:constKeySkipRssFeeds] ;
    [self setPrimitiveSkipRssFeeds:newValue] ;
    [self didChangeValueForKey:constKeySkipRssFeeds] ;
    
    [[[self client] macster] postTouchedClient:[self client]
                                      severity:4] ;
}

- (void)setSkipSeparators:(NSNumber*)newValue  {
    [self postWillSetNewValue:newValue
                       forKey:constKeySkipSeparators] ;
    [self willChangeValueForKey:constKeySkipSeparators] ;
    [self setPrimitiveSkipSeparators:newValue] ;
    [self didChangeValueForKey:constKeySkipSeparators] ;
    
    [[[self client] macster] postTouchedClient:[self client]
                                      severity:4] ;
}

- (void)setMergeBias:(NSNumber*)newValue  {
    [self postWillSetNewValue:newValue
                       forKey:constKeyMergeBias] ;
    [self willChangeValueForKey:constKeyMergeBias] ;
    [self setPrimitiveMergeBias:newValue] ;
    [self didChangeValueForKey:constKeyMergeBias] ;
    
    [self doMergeByBusinessLogic] ;
    
    [[[self client] macster] postTouchedClient:[self client]
                                      severity:4] ;
}

- (void)setMergeBy:(NSNumber*)newValue  {
    [self postWillSetNewValue:newValue
                       forKey:constKeyMergeBy] ;
    [self willChangeValueForKey:constKeyMergeBy] ;
    [self setPrimitiveMergeBy:newValue] ;
    [self didChangeValueForKey:constKeyMergeBy] ;
    
    [[[self client] macster] postTouchedClient:[self client]
                                      severity:4] ;
}

- (void)setShareNewItems:(NSNumber*)newValue  {
    [self postWillSetNewValue:newValue
                       forKey:constKeyShareNewItems] ;
    [self willChangeValueForKey:constKeyShareNewItems] ;
    [self setPrimitiveShareNewItems:newValue] ;
    [self didChangeValueForKey:constKeyShareNewItems] ;
    
    [[[self client] macster] postTouchedClient:[self client]
                                      severity:4] ;
}


#pragma mark * Value-Added Accessors

/* Accessed by checkbox in Advanced Client Settings sheet. */
- (BOOL)fabricateFoldersAny {
    BOOL answer = ([[self fabricateFolders] integerValue] != BkmxFabricateFoldersOff) ;
    return answer ;
}

/* Accessed by checkbox in Advanced Client Settings sheet. */
- (void)setFabricateFoldersAny:(BOOL)yn {
    NSInteger value = yn ? BkmxFabricateFoldersOne : BkmxFabricateFoldersOff ;
    [self setFabricateFolders:[NSNumber numberWithInteger:value]] ;
}

/* Accessed by checkbox in Advanced Client Settings sheet. */
- (BOOL)fabricateFoldersMany {
    BOOL answer = ([[self fabricateFolders] integerValue] == BkmxFabricateFoldersAll) ;
    return answer ;
}

/* Accessed by checkbox in Advanced Client Settings sheet. */
- (void)setFabricateFoldersMany:(BOOL)yn {
    NSInteger value = yn ? BkmxFabricateFoldersAll : BkmxFabricateFoldersOne ;
    [self setFabricateFolders:[NSNumber numberWithInteger:value]] ;
}

+ (NSSet*)keyPathsForValuesAffectingFabricateFoldersAny {
    return [NSSet setWithObject:constKeyFabricateFolders] ;
}

+ (NSSet*)keyPathsForValuesAffectingFabricateFoldersMany {
    return [NSSet setWithObject:constKeyFabricateFolders] ;
}

+ (NSSet*)keyPathsForValuesAffectingClientChoice {
    return [NSSet setWithObjects:
            constKeyClient,
            nil] ;
}

- (BOOL)isAnImporter {
    return ([self isKindOfClass:[Importer class]]) ;
}

- (BOOL)isAnExporter {
    return ([self isKindOfClass:[Exporter class]]) ;
}

- (BOOL)isFirstActiveImporter {
    NSArray* activeImportersOrdered = [[[self client] macster] activeImportersOrdered] ;
    
    return (self == [activeImportersOrdered firstObjectSafely]) ;
}

- (BOOL)isLastActiveImporter {
    NSArray* activeImportersOrdered = [[[self client] macster] activeImportersOrdered] ;
    
    return (self == [activeImportersOrdered lastObjectSafely]) ;
}

- (BOOL)isFirstActiveExporter {
    NSArray* activeExportersOrdered = [[[self client] macster] activeExportersOrdered] ;
    
    return (self == [activeExportersOrdered firstObjectSafely]) ;
}

- (BOOL)isLastActiveExporter {
    NSArray* activeExportersOrdered = [[[self client] macster] activeExportersOrdered] ;
    
    return (self == [activeExportersOrdered lastObjectSafely]) ;
}

#if ONLY_PRIMARY_SOURCE_CAN_IMPORT_DELETIONS
- (BOOL)isPrimarySource {
    BOOL isPrimarySource ;
    if ([self isAnImporter]) {
        isPrimarySource = ([self isFirstActiveImporter]) ;
    }
    else {
        isPrimarySource = YES ;
    }
    
    return isPrimarySource ;
}
#endif

/*
 @details  A similar method, applicable for imports only,
 is implemented in GulperImportDelegate.
 
 @result   Truth table…
     client    info        ixporter   ixporter    macster     ixporter   info       result:
                                                              is                    should
     is        do          importer               delete      Last       is         Delete
     A         BkMxtrizr   or         delete      Unmatched   Active     Single     Unmatched
     Quickie   Only        exporter   unmatched   Mxtr        Importer   Ixporter   Items
     -------   ---------   --------   ---------   ---------   --------   --------   ---------
     1          X           X         X           X           X          X          0
     X          1           X         X           X           X          X          0
     0          0           E         0           X           X          X          0
     0          0           E         1           X           X          X          1
     0          0           I         X           X           0          0          0
     0          0           I         X           1           1          X          1
     0          0           I         X           1           X          1          1
 */
- (BOOL)shouldDeleteUnmatchedItemsWithInfo:(NSDictionary*)info {
    if ([[self client] willIgnoreLimit]) {
        return NO ;
    }
    
    if ([[info objectForKey:constKeyIxportBookmacsterizerOnly] boolValue]) {
        return NO ;
    }
    
#if ONLY_PRIMARY_SOURCE_CAN_IMPORT_DELETIONS
    if (![self isPrimarySource]  && ![bkmxDoc didImportPrimarySource]) {
        return NO ;
    }
#endif
    
    if ([self isAnExporter]) {
        // Look at individual switch for this Exporter
        return [[self deleteUnmatched] boolValue] ;
    }
    
    // We are an importer
    if (
        ([self isLastActiveImporter])
        ||
        ([[info objectForKey:constKeyDoOnlyImportersArray] lastObject] == self)
        ) {
            // We are the last Importer, or the only importer.  Look at document-wide switch.
            // Delete Unmatched Items if Import Delete Unmatched Items checkbox is ON
            return [[[[self client] macster] deleteUnmatchedMxtr] boolValue] ;
        }
    
    return NO ;
}

- (BOOL)isBeginningProductForBkmxDoc:(BkmxDoc*)bkmxDoc {
    return (
            [self isAnExporter]
            ||
            /* The following is smarter than looking at the index
             of this job, because it ignores any previous imports
             which were skipped due to, for example, no change
             in import hash.  In other words, it is YES if this
             is the first *executed* import. */
            ([[bkmxDoc starker] destinees] ==  nil)
            ) ;
}

#pragma mark * Basic Infrastructure

/*
 Not used but needed to satisfy Startainer protocol
 */
- (uint32_t)contentHash {
    return [[self extore] contentHash] ;
}

- (NSSet*)unsupportedAttributesForSeparators {
    return [[self extore] unsupportedAttributesForSeparators];
}

- (Chaker*)chaker {
    return [[self extore] chaker];
}

- (BOOL)canEditSeparatorsInAnyStyle {
    return [[self extore] canEditSeparatorsInAnyStyle];
}

- (NSString*)displayName {
    return [[self client] displayName] ;
}

- (NSString*)shortDescription {
    return [NSString stringWithFormat:
            @"<%@ %p %@ isF=%hhd isD=%hhd for %@>",
            [self className],
            self,
            [self truncatedID],
            [self isFault],
            [self isDeleted],
            [[self client] clientoid]] ;
}

#if 0
#warning Logging retain, release for Ixporter
/*- (id)retain {
 id x = [super retain] ;
 NSLog(@"113033: After retain, rc=%d", [self retainCount]) ;
 return x ;
 }
 - (id)autorelease {
 id x = [super autorelease] ;
 NSLog(@"111008: After autorelease, rc=%d", [self retainCount]) ;
 return x ;
 }
 - (oneway void)release {
 NSInteger rc = [self retainCount] ;
 [super release] ;
 NSLog(@"113300: After release, rc=%d", rc-1) ;
 return ;
 }
 - (void)dealloc {
 NSLog(@"%s", __PRETTY_FUNCTION__) ;
 [super dealloc] ;
 }
 */
#endif

- (void)didTurnIntoFault {
    /* cocoa-dev@lists.apple.com
     
     On 20090812 20:41, Jerry Krinock said:
     
     Now I understand that if nilling an instance variable after releasing
     it is done in -dealloc, it is papering over other memory management
     problems and is therefore bad programming practice.  But I believe
     that this practice is OK in -didTurnIntoFault because, particularly
     when Undo is involved, -didTurnIntoFault may be invoked more than once
     on an object.  Therefore nilling after releasing in -didTurnIntoFault
     is recommended.
     
     On 20090812 22:06, Sean McBride said
     
     I made that discovery a few months back too, and I agree with your
     reasoning and conclusions.  I also asked an Apple guy at WWDC and he
     concurred too.
     */
    [m_extore release] ;  m_extore = nil ;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
    
    [super didTurnIntoFault] ;
}

/* This method should have no effect because m_extore will already have been
 released and had nil assigned to it in -didTurnIntoFault. */
- (void)dealloc {
    [m_extore release] ;
    
    [super dealloc] ;
}

/*
 Description of this method
 
 TheConditions are defined as ALL of the following are true:
 *  we are an exporter
 *  changed object is in the transMoc
 *  changed object is a Stark
 *  value really changed
 *  if URL change, will be written to external
 *  this is not just nulling a property
 *  the keyPath being changed is not trivial
 
 if TheConditions are true then stark's lastModifiedDate is set
 to the current date.
 
 if, in addition, the object is exportable, report the stark
 as updated to the chaker
 */
- (void)objectWillChangeNote:(NSNotification*)notification {
    if ([self isAnImporter]) {
        // We only mark changes during exports
        // In BookMacster 1.11, discovered that this is defensive programming
        // because we only add this observation (in -mergeFromStartainer:::  01.  Prepare)
        // when [self isAnExporter].  So, added this:
        NSLog(@"Warning 593-9381") ;
        return ;
    }
    
    id object = [notification object] ;
    if ([object managedObjectContext] != [[self extore] transMoc]) {
        // Not one of ours
        return ;
    }
    
    /* Defensive programming.  This method should only get, and can only
     handle, objects of type Stark. */
    if (![object isKindOfClass:[Stark class]]) {
        return;
    }

    NSString* keyPath = [[notification userInfo] objectForKey:constKeySSYChangedKey] ;
    id newValue = [[notification userInfo] objectForKey:constKeyNewValue] ;
    id oldValue = [object valueForKeyPath:keyPath] ;
    
    // Apple's KVO sends out notifications even when there has not been any substantial
    // change because, as Quincey Morris says, "Properties are behavior".
    // However, I disagree, so I filter those out
    if ([NSObject isEqualHandlesNilObject1:newValue
                                   object2:oldValue]) {
        // Value did not really change.
        return ;
    }
    
    // When objects are deallocced or deleted, values of their properties
    // are set to nil, signified by newValue being an NSNull, so we'll get
    // a flood of such observations, for example, when a document is closed.
    // The following if() makes us ignore such observations.
    // I can't think of anything we'd need to do when a value
    // is set to nil.
    if ([newValue isKindOfClass:[NSNull class]]) {
        return ;
    }
    
    if ([[[BkmxBasis sharedBasis] trivialAttributes] member:keyPath]) {
        return ;
    }
    
#if 0
#warning Logging when ixporter observes changes
#define LOG_IXPORTER_OBSERVING_CHANGES 1
#endif
    
#if LOG_IXPORTER_OBSERVING_CHANGES
    NSString* abbreviatedForLoggingOldValue ;
    NSString* abbreviatedForLoggingNewValue ;
    if (NO) {
    }
    else if ([keyPath isEqualToString:constKeyChildren]) {
        abbreviatedForLoggingOldValue = [oldValue shortDescription] ;
        abbreviatedForLoggingNewValue = [newValue shortDescription] ;
    }
    else if ([keyPath isEqualToString:constKeyParent]) {
        abbreviatedForLoggingOldValue = [oldValue shortDescription] ;
        abbreviatedForLoggingNewValue = [newValue shortDescription] ;
    }
    else {
        abbreviatedForLoggingOldValue = [oldValue description] ;
        abbreviatedForLoggingNewValue = [newValue description] ;
    }
    NSLog(@"Ixporter notes %@ changed\n   from: '%@'\n     to: '%@'\n  stark: %@ %p '%@'\n  owner: %@",
          keyPath,
          abbreviatedForLoggingOldValue,
          abbreviatedForLoggingNewValue,
          [StarkTyper readableSharype:[(Stark*)object sharypeValue]],
          object,
          [(Stark*)object name],
          [(Stark*)object owner]) ;
#endif
    
    Chaker* chaker = [[self bkmxDoc] chaker] ;
    // Although -[Chaker updateStark::::] will check to see if
    // chaker is active, we pre-test -isActive, so that we can
    // avoid running the more expensive -shouldExportStark:withChange:
    // if -updateStark::: is going to no-op anyhow.
    if ([chaker isActive]) {
        if ([self isAnExporter]) {
            if ([[self extore] shouldExportStark:(Stark*)object
                                      withChange:[notification userInfo]]) {
#if 0
#warning Logging ixporter messages to chaker
#define LOG_IXPORTER_MESSAGES_TO_CHAKER 1
#endif
                
#if LOG_IXPORTER_MESSAGES_TO_CHAKER
                NSString* oldDesc = [oldValue shortDescription] ;
                NSString* newDesc = [newValue shortDescription] ;
                if ([keyPath isEqualToString:constKeyChildren]) {
                    NSMutableArray* oldChildren = [[(NSSet*)oldValue allObjects] mutableCopy] ;
                    [oldChildren sortUsingComparator:^NSComparisonResult(Stark* s1, Stark* s2) {
                        return [[s1 index] compare:[s2 index]] ;
                    }] ;
                    NSMutableArray* newChildren = [[(NSSet*)newValue allObjects] mutableCopy] ;
                    [newChildren sortUsingComparator:^NSComparisonResult(Stark* s1, Stark* s2) {
                        return [[s1 index] compare:[s2 index]] ;
                    }] ;
                    oldDesc = [oldChildren valueForKeyPath:constKeyName] ;
                    newDesc = [newChildren valueForKeyPath:constKeyName] ;
                    [oldChildren release] ;
                    [newChildren release] ;
                }
                else if ([keyPath isEqualToString:constKeyParent]) {
                    oldDesc = [(Stark*)oldValue name] ;
                    newDesc = [(Stark*)newValue name] ;
                }
                
                NSLog(@"Chaking %@ of %@ from %@ to %@", keyPath, [object name], oldDesc, newDesc) ;
#endif
                [chaker updateStark:object
                                key:keyPath
                           oldValue:oldValue
                           newValue:newValue] ;
            }
        }
    }
    else {
    }
}

- (void)objectDidChangeNote:(NSNotification*)notification {
    if ([self isAnImporter]) {
        // We only mark changes during exports
        // In BookMacster 1.11, discovered that this is defensive programming
        // because we only add this observation (in -mergeFromStartainer:::  01.  Prepare)
        // when [self isAnExporter].  So, added this:
        NSLog(@"Warning 593-9382") ;
        return ;
    }
    
    id object = [notification object] ;
    if ([object managedObjectContext] != [[self extore] transMoc]) {
        // Not one of ours
        return ;
    }
    
    /* We are only interested in Tag changes. */
    if (![object isKindOfClass:[Tag class]]) {
        return;
    }
        
    NSString* keyPath = [[notification userInfo] objectForKey:constKeySSYChangedKey] ;
    id newValue = [object valueForKeyPath:keyPath] ;
    id oldValue = [[notification userInfo] objectForKey:constKeyOldValue] ;
    
    // Apple's KVO sends out notifications even when there has not been any substantial
    // change because, as Quincey Morris says, "Properties are behavior".
    // However, I disagree, so I filter those out
    if ([NSObject isEqualHandlesNilObject1:newValue
                                   object2:oldValue]) {
        // Value did not really change.
        return ;
    }
    
    // When objects are deallocced or deleted, values of their properties
    // are set to nil, signified by newValue being an NSNull, so we'll get
    // a flood of such observations, for example, when a document is closed.
    // The following if() makes us ignore such observations.
    // I can't think of anything we'd need to do when a value
    // is set to nil.
    if ([newValue isKindOfClass:[NSNull class]]) {
        return ;
    }
    
    Chaker* chaker = [[self bkmxDoc] chaker] ;
    // Although -[Chaker updateStark::::] will check to see if
    // chaker is active, we pre-test -isActive, so that we can
    // avoid running the more expensive -shouldExportStark:withChange:
    // if -updateStark::: is going to no-op anyhow.
    if ([chaker isActive]) {
        if ([self isAnExporter]) {
            // NSLog(@"Tag %@\nDID CHANGE %@ FROM %@ IN\n   String: %@\n   Starks: %@", [tag objectID], keyPath, [oldValue shortDescription], tag.string, [tag.starks shortDescription]);
            
            [chaker tagsHaveBeenAffectedInExtore:[self extore]];

// Or something fancier……???
//            Tag* tag = (Tag*)object;
//            if ([keyPath isEqualToString:constKeyStarks]) {
//                NSSet* oldStarks = oldValue;
//                if (![oldStarks isKindOfClass:[NSSet class]]) {
//                    oldStarks = [NSSet set];
//                }
//                NSSet* newStarks = tag.starks;
//                if (![newStarks isKindOfClass:[NSSet class]]) {
//                    newStarks = [NSSet set];
//                }
//                NSMutableSet* addedStarks = [newStarks mutableCopy];
//                [addedStarks minusSet:oldStarks];
//                NSMutableSet* removedStarks = [oldStarks mutableCopy];
//                [removedStarks minusSet:newStarks];
//                NSString* tagString = tag.string;
//                NSLog(@"--------------------------------");
//                if (addedStarks.count > 0) {
//                    for (Stark* stark in addedStarks) {
//                        NSLog(@"%@: +++++ %@", tagString, stark.name);
//                    }
//                }
//                if (removedStarks.count > 0) {
//                    for (Stark* stark in removedStarks) {
//                        NSLog(@"%@: ----- %@", tagString, stark.name);
//                    }
//                }
        }
    }
}





#pragma mark * Custom Methods

// In BkmxDoc.nib, table column "Create Folders From Tags" 'enabled' is bound to this
- (BOOL)canEditTags {
    return [[self client] canEditTagsInAnyStyle] ;
}

#if 0
// In BookMacster 1.19.9, I noticed that this method is never used
- (void)catchUnmappedDeepOrphanedCopyOfUnmappableStark:(Stark*)stark
                                                destin:(NSObject <Startainer, StarCatcher, StarkReplicator> *)destin
                                        rootCollection:(NSMutableArray*)rootUnderConstruction
                                         barCollection:(NSMutableArray*)barUnderConstruction
                                        menuCollection:(NSMutableArray*)menuUnderConstruction
                                      oharedCollection:(NSMutableArray*)oharedUnderConstruction
                                     unfiledCollection:(NSMutableArray*)unfiledUnderConstruction {
    Stark* copy = [stark copyDeepOrphanedFreshened:NO
                                        replicator:destin] ;
    NSArray* copies ;
    if ([StarkTyper isHartainerCoarseSharype:[[copy sharype] shortValue]]) {
        // Hartainer.  If the destination does not have, for example, a Bookmarks
        // Menu, we don't want a "Bookmarks Menu" copied to it.  Instead, we
        // bring in its children and forget the hartainer itself.
        copies = [copy childrenOrdered] ;
    }
    else {
        // Soft item.  Add it intact.
        copies = [NSArray arrayWithObject:copy] ;
    }
    
    Sharype sharypeAccepting = [destin preferredCatchypeValue] ;
    if (![destin canHaveParentSharype:sharypeAccepting
                                stark:copy]) {
        sharypeAccepting = [destin anyStarkCatchypeValue] ;
    }
    
    [copy release] ;
    
    NSMutableArray* collection = nil ;
    switch (sharypeAccepting) {
        case SharypeRoot:
            collection = rootUnderConstruction ;
            break ;
        case SharypeMenu:
            collection = menuUnderConstruction ;
            break ;
        case SharypeUnfiled:
            collection = unfiledUnderConstruction ;
            break ;
        case SharypeBar:
            collection = barUnderConstruction ;
            break ;
        case SharypeOhared:
            collection = oharedUnderConstruction ;
            break ;
        default:
            NSLog(@"Internal Error 447-5652") ;
    }
    
    [collection addObjectsFromArray:copies] ;
}
#endif

/*!
 @brief    Index value of self among clients
 
 @details  Answer does not ignore non-ixporting clients
 */
- (NSInteger)gappyIndexValue {
    return [[self client] indexValue] ;
}

#if 0
#warning Compiling debug method -logMacsterizers
- (void)logMacsterizers:(NSArray*)starks
                  label:(NSString*)label {
    NSMutableArray* exids = [NSMutableArray array] ;
    for (Stark* stark in starks) {
        if ([[stark name] isEqualToString:@"BookMacsterize"]) {
            NSString* exid = [stark exidForClientoid:[[self client] clientoid]] ;
            if (!exid) {
                exid = [[stark objectID] description] ;
            }
            [exids addObject:exid] ;
        }
    }
    [exids sortUsingSelector:@selector(compare:)] ;
    NSLog(@"%@: %@", label, exids) ;
}
#endif

- (BOOL)shouldIxportDueToIxportabilitySourceStark:(Stark*)sourceStark
                                      destinStark:(Stark*)destinStark
                                        clientoid:(Clientoid*)clientoid
                                           extore:(Extore*)extore
                       shouldDeleteUnmatchedItems:(BOOL)shouldDeleteUnmatchedItems
                                       traceLevel:(NSInteger)traceLevel
                                            basis:(BkmxBasis*)basis {
    NSString* logEntry ;
    BOOL shouldIxport = YES ;
    
    if ([self isAnExporter]) {
        // The above condition was added in BookMacster 1.1.27
        
        // If the sourceStark is not exportable, any
        // *destinStark_p which we would create from it
        // would not be exportable either
        if (![extore shouldExportStark:sourceStark
                            withChange:nil]
            &&
            (!destinStark || shouldDeleteUnmatchedItems)
            ) {
            /*
             source is    destinStark      shouldDelete     "if"
             exportable   is not nil       UnmatchedItems   result   shouldIxport
             ----------   --------------   --------------   ------   ------
             0            0                X                YES      NO
             0            1                0                NO       YES
             0            1                1                YES      NO
             1            X                X                NO       YES
             Note 1.   Could process, but this is for efficiency since no sense processing a
             stark which is going to be deleted later
             */
            if (traceLevel > 3) {
                logEntry = [[NSString alloc] initWithFormat:
                            @"34596:    Ignoring unexportable cuz %hhd%hhd%hhd.\n",
                            (BOOL)[extore shouldExportStark:sourceStark withChange:nil],
                            (BOOL)(destinStark != nil),
                            (BOOL)shouldDeleteUnmatchedItems] ;
#if LOG_TO_CONSOLE_TOO
                NSLog(@"%@", logEntry) ;
#endif
                [basis trace:logEntry] ;
                [logEntry release] ;
            }
            shouldIxport = NO ;
        }
    }
    
    return shouldIxport ;
}

- (BOOL)shouldIxportDueToSeparatornessSourceStark:(Stark*)sourceStark
                                      destinStark:(Stark*)destinStark
                                       mergeBias:(BkmxMergeBias)mergeBias
                                       traceLevel:(NSInteger)traceLevel
                                            basis:(BkmxBasis*)basis {
    NSString* logEntry ;
    BOOL shouldIxport = YES ;
    if ([sourceStark sharypeValue] == SharypeSeparator) {
        if (!destinStark) {
            if (
                (
                 // For either importing or exporting, we try to
                 // "do what you probably want"
                 (mergeBias != BkmxMergeBiasKeepSource)
                 ||
                 (
                  // In addition, for exporting only, we obey the value
                  // of a checkbox which may unconditionally preclude
                  // importing of separators
                  [self isAnExporter]
                  &&
                  ([[self skipSeparators] boolValue])
                  )
                 )
                ) {
                    if (traceLevel > 3) {
                        logEntry = [[NSString alloc] initWithFormat:@"34268:    Ignoring unwanted separator\n"] ;
#if LOG_TO_CONSOLE_TOO
                        NSLog(@"%@", logEntry) ;
#endif
                        [basis trace:logEntry] ;
                        [logEntry release] ;
                    }
                    
                    shouldIxport = NO ;
                }
        }
    }
    
    return shouldIxport ;
}

- (void)setMirroringInDestinStark:(Stark*)destinStark
                        mergeBias:(BkmxMergeBias)mergeBias
                      sourceStark:(Stark *)sourceStark
                       traceLevel:(NSInteger)traceLevel {
    BkmxBasis* basis = [BkmxBasis sharedBasis];
    NSString* logEntry = nil;
    if (
        (mergeBias == BkmxMergeBiasKeepSource)
        &&
        ([destinStark sponsorIndex] == nil))  // Has not been sponsored by previous Client.
    {
        [destinStark setShouldMirrorSourceMate] ;
        if (traceLevel > 3) {
            logEntry = [[NSString alloc] initWithFormat:
                        @"33080:       Set shouldMirrorSourceMate (%@: %@)\n",
                        [StarkTyper readableSharype:[destinStark sharypeValue]],
                        [destinStark name]];
#if LOG_TO_CONSOLE_TOO
            NSLog(@"%@", logEntry) ;
#endif
            [basis trace:logEntry] ;
            [logEntry release] ;
        }
    }
}

- (Stark *)freshStarkInStarker:(Starker*)destinStarker
                       sharype:(Sharype)sharype {
    Stark* destinStark = [destinStarker freshStark] ;
    [destinStark setSharype:[NSNumber numberWithSharype:sharype]] ;
    [destinStark setIsNewItem] ;
    
    // By default, we expand all new imported folders.
    // Note that this may be overwritten by the
    // subsequent -overwriteAttributes:mergeTags:fabricateTags:fromStark:
    if ([destinStark canHaveChildren]) {
        [destinStark setIsExpanded:[NSNumber numberWithBool:YES]] ;
    }
    [destinStark setIsShared:[self shareNewItems]];
    return destinStark;
}

- (void)finishMatchingDestinStark_p:(Stark*)destinStark
                            bkmxDoc:(BkmxDoc *)bkmxDoc
                          clientoid:(Clientoid *)clientoid
                   commonAttributes:(NSArray *)commonAttributes
                        countOfJobs:(NSInteger)countOfJobs
              doBookMacsterizerOnly:(BOOL)doBookMacsterizerOnly
                  exportFeedbackDic:(NSMutableDictionary *)exportFeedbackDic
                             extore:(Extore *)extore
                         mergeBias:(BkmxMergeBias)mergeBias
                      mergeTagsParm:(BkmxMergeResolutionTags)mergeTagsParm
                             source:(NSObject<Startainer,StarkReplicator> *)source
                        sourceStark:(Stark *)sourceStark
                         traceLevel:(NSInteger)traceLevel {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
    BkmxBasis* basis = [BkmxBasis sharedBasis];
    NSString* logEntry = nil;
    if (![destinStark sponsorIndex]) {
        // *destinStark_p has not already been sponsored.
        // Note that this branch will always execute for the first Import
        // Client, always for Export, and always for a new stark.
        // (The above test was added in BookMacster 0.9.29.  Prior to that,
        // this branch always executed, which caused the Guy Kawasaki bug.)
        // Was further changed in BookMacster 1.1.  Since 0.9.29, had been
        // if ([[*destinStark_p sponsorIndex] intValue] == 0) {
        
        NSInteger sponsorIndex = (mergeBias==BkmxMergeBiasKeepDestin) ? SPONSORED_BY_DESTIN : [self gappyIndexValue] ;
        NSInteger sponsoredIndex = [[sourceStark index] integerValue] ;
        NSInteger ixportingIndex = -1 ;
        
        // The following added section is 2 of 2 changes in BookMacster 1.12.7
        // to fix undesired movement of separators in corner case imports.
        
        if ([sourceStark sharypeValue] == SharypeSeparator) {
            if ([self isAnImporter] && (countOfJobs > 1)) {
                NSInteger indexOfPriorImporterWhichSkippedSeparators = -1 ;
                NSArray* siblings = [[[self client] macster] activeImportersOrdered] ;
                NSInteger indexOfSelf = [siblings indexOfObject:self] ;
                Class priorExtoreClass = NULL ;
                // The following test was added in BookMacster 1.14.4, is
                // probably defensive programming, because I think the only way
                // that self would not be in activeImportersOrdered would be
                // if this were a One-Time Import, not in macster's
                // clients, which means that we won't be here due to the
                // isSingleIxporter being YES several lines above.
                if (indexOfSelf != NSNotFound) {
                    NSInteger startingIndex = indexOfSelf - 1 ;
                    if (startingIndex >=0) {
                        for (NSInteger i=startingIndex; i>=0; i--) {
                            Importer* sibling = [siblings objectAtIndex:i] ;
                            priorExtoreClass = [[sibling client] extoreClass] ;
                            if ([priorExtoreClass canEditSeparatorsInStyle:extore.ixportStyle] == NO) {
                                indexOfPriorImporterWhichSkippedSeparators = i ;
                                break ;
                            }
                        }
                    }
                }
                if (indexOfPriorImporterWhichSkippedSeparators > -1) {
                    sponsorIndex = indexOfPriorImporterWhichSkippedSeparators ;
                    sponsoredIndex = [sourceStark indexValue] ;
                    ixportingIndex = 0 ;
                    
                    if (traceLevel > 3) {
                        logEntry = [[NSString alloc] initWithFormat:@"36300:    Faked sponsorIndex to %ld=%@ for separator %@\n",
                                    (long)indexOfPriorImporterWhichSkippedSeparators,
                                    NSStringFromClass(priorExtoreClass),
                                    [sourceStark shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
                        NSLog(@"%@", logEntry) ;
#endif
                        [basis trace:logEntry] ;
                        [logEntry release] ;
                    }
                }
            }
        }
        
        [destinStark setSponsorIndex:[NSNumber numberWithInteger:sponsorIndex]] ;
        if (traceLevel > 3) {
            logEntry = [[NSString alloc] initWithFormat:@"36406:    Set sponsor index for: %@\n", [destinStark shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
            NSLog(@"%@", logEntry) ;
#endif
            [basis trace:logEntry] ;
            [logEntry release] ;
        }
        
        // The condition 'shouldIndexize' was added in BookMacster 1.11.3
        BOOL shouldIndexize = [source hasOrder] ;
        if (shouldIndexize) {
            [destinStark setSponsoredIndex:[NSNumber numberWithInteger:sponsoredIndex]] ;
            if (ixportingIndex > -1) {
                /* We set the ixportingIndex for this item to 0.  This is so
                 that this separator slides in ahead of the existing item at
                 sponsoredIndex, and does so deterministically.  I don't think
                 there is any side effect to doing this, because the only
                 purpose of the ixportingIndex is to guarantee that imports and
                 exports are deterministic; that is, that there is no churn due
                 to the random reading or writing of set elements. */
                [destinStark clearIxportingIndex] ;
                [destinStark setIxportingIndex:0] ;
            }
        }
        if (traceLevel > 3) {
            // Moved from above in BookMacster 1.11, was 36400…
            logEntry = [[NSString alloc] initWithFormat:@"36500:    Sponsorized %@: %@\n",
                        shouldIndexize ? @"and Indexized" : @"only", // was flipped, fixed in BookMacster 1.22.5
                        [destinStark shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
            NSLog(@"%@", logEntry) ;
#endif
            [basis trace:logEntry] ;
            [logEntry release] ;
        }
        
        if (doBookMacsterizerOnly) {
            // Force the new bookmacsterizer to the bottom.
            if ([sourceStark isBookmacsterizer]) {
                [destinStark setSponsorIndex:[NSNumber numberWithInteger:PUT_AT_BOTTOM]] ;
                [destinStark setSponsoredIndex:[NSNumber numberWithInteger:PUT_AT_BOTTOM]] ;
            }
        }
    }
    
    BOOL conditionOr1 = [destinStark isNewItemThisClient];
    BOOL conditionOr2 = (mergeBias == BkmxMergeBiasKeepSource);
    BOOL conditionAnd = ![destinStark isUpdatedThisIxport];
    BOOL couldUpdate = (conditionOr1 || conditionOr2) && conditionAnd;
    /* Note that conditionAnd prevents updating attributes of the same stark
     from different Clients during the same import operation, so that the
     first Client wins.  If we wanted to loosen this restriction so that
     different Clients could modify different attributes of the same stark, we
     we would need to replace BOOL Stark.isUpdatedThisIxport with something
     like NSSet* Stark.attributesUpdatedThisIxport.  Or maybe just
     eliminate the isUpdatedThisIxport and the conditionAnd althogether
     and let the last Client win. */
    if (traceLevel > 3) {
        logEntry = [[NSString alloc] initWithFormat:@"36404:    Could update ? %hhd = (%hhd || %hhd) && %hhd for %@\n",
                    couldUpdate,
                    conditionOr1,
                    conditionOr2,
                    conditionAnd,
                    [destinStark name]] ;
#if LOG_TO_CONSOLE_TOO
        NSLog(@"%@", logEntry) ;
#endif
        [basis trace:logEntry] ;
        [logEntry release] ;
    }
    
    if (couldUpdate) {
        // The following if() was moved from -[ExtoreWebFlat writeUsingStyle1InOperation:]
        // in BookMacster 1.1.5
        if (
            ![extore supportedAttributesAreEqualComparingStark:destinStark
                                                    otherStark:sourceStark
                                                   ixportStyle:extore.ixportStyle]
            ||
            [[self fabricateTags] boolValue]
            ||
            [self fabricateFoldersAny]
            ) {
                
                // Added in BookMacster version 1.3.19…  When we add a new item,
                // chaker will be notified for each attribute.  That's wasteful,
                // because these notes will be superceded by the *insert* note.
                // So we deactivate it temporarily.
                if ([destinStark isNewItemThisClient]) {
                    [[bkmxDoc chaker] setIsActive:NO] ;
                }
                
                // commonAttributes is just from the extore class, with a few adjustments.
                // Notably, it never includes 'index'.
                [destinStark overwriteAttributes:commonAttributes
                                       mergeTags:mergeTagsParm
                                   fabricateTags:[[self fabricateTags] boolValue]
                                       fromStark:sourceStark] ;
                [destinStark setIsUpdatedThisIxport];
                
                // Reactivate what we just did 3 lines up, if we did.  Otherwise, we
                // just re-set chaker's isActive to YES, which it already is.
                [[bkmxDoc chaker] setIsActive:YES] ;
                
                if (traceLevel > 3) {
                    logEntry = [[NSString alloc] initWithFormat:@"36407:    Updated attrs of %@\n", [destinStark shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
                    NSLog(@"%@", logEntry) ;
#endif
                    [basis trace:logEntry] ;
                    [logEntry release] ;
                }
            }
    }
    
    // Added warnings in BookMacster 1.11, because if indeed this branch overwrites owner values
    // only, we don't need it.  But I see that it is also overwriting exids and tags, so
    // I'm not sure
    // Added in BookMacster version 1.3.19
    else if ([destinStark isNewItemThisClient] || (mergeBias == BkmxMergeBiasKeepSource)) {
        // Importing an existing stark from a non-first import client
        
        BOOL overwriteWillHaveAnyAffect = NO ;
        if (![NSObject isEqualHandlesNilObject1:[sourceStark tags]
                                        object2:[destinStark tags]]) {
            overwriteWillHaveAnyAffect = YES ;
        }
        
        // Added in BookMacster 1.20.5
        NSMutableArray* attributesWeCanFill = [[NSMutableArray alloc] init] ;
        for (NSString* attribute in commonAttributes) {
            if (
                ([destinStark valueForKey:attribute] == nil)
                &&
                ([sourceStark valueForKey:attribute] != nil)
                &&
                (![attribute isEqualToString:constKeyTags])
                ) {
                    [attributesWeCanFill addObject:attribute] ;
                }
        }
        if ([attributesWeCanFill count] > 0) {
            overwriteWillHaveAnyAffect = YES ;
        }
        
        if (!overwriteWillHaveAnyAffect) {
            NSArray* relevantKeys = [[sourceStark exids] allKeys] ;
            NSDictionary* relevantDestinExids = [[destinStark exids] subdictionaryWithKeys:relevantKeys] ;
            if (![NSDictionary isEqualHandlesNilObject1:[sourceStark exids]
                                                object2:relevantDestinExids]) {
                /* I've seen this happen if you sync to Safari, Firefox and Chrome,
                 duplicate folders of bookmarks in Safari, then import.
                 The Chrome exids will be different, and the Firefox exids
                 in the destination (Collection) will be duplicated.  Eeek.
                 Needs further investigation.
                 It also happens when importing from Safari, if things get
                 moved around. */
                overwriteWillHaveAnyAffect = YES ;
            }
        }
        
        if (overwriteWillHaveAnyAffect) {
            NSDictionary* sourceOwnerValues = [sourceStark ownerValues] ;
            if (sourceOwnerValues) {
                [destinStark overwriteAttributes:attributesWeCanFill
                                       mergeTags:mergeTagsParm
                                   fabricateTags:[[self fabricateTags] boolValue]
                                       fromStark:sourceStark] ;
            }
        }
        [attributesWeCanFill release] ;
    }
    // We note in passing that we need not copy
    // exids related to other browsers or files.  This is because, when
    // importing, the only exid we want from the external store, indeed
    // the only one it has, is its own.  Similarly, when exporting, the
    // external store is interested only in its own exid.
    if ([self isAnImporter]) {
        NSString* exid = [sourceStark exidForClientoid:clientoid] ;
        if (exid) {
            // In order to avoid registering undo and unnecessarily dirtying the dot,
            // we only do the overwrite if there was a substantive change.
            if (![exid isEqualToString:[destinStark exidForClientoid:clientoid]]) {
                [destinStark setExid:exid
                        forClientoid:clientoid] ;
            }
        }
        else if ([[BkmxBasis sharedBasis] isTracing]) {
            logEntry = [[NSString alloc] initWithFormat:@"Internal Error 684-5459.  No exid for %@ in item %@ imported from %@.  Exids are: %@\n",
                        clientoid,
                        [sourceStark shortDescription],
                        [source shortDescription],
                        [sourceStark exids]] ;
#if LOG_TO_CONSOLE_TOO
            NSLog(@"%@", logEntry) ;
#endif
            [basis trace:logEntry] ;
            [logEntry release] ;
        }
    }
    else if (destinStark) {
        // The above condition is just defensive programming
        [exportFeedbackDic setObject:sourceStark                // BkmxDoc
                              forKey:[destinStark objectID]] ;  // Client
    }
    
    [pool drain];
}

- (Stark*)folderForTalderMap:(TalderMap*)talderMap
             starksKeyedById:(NSDictionary*)starksKeyedById
                     starker:(Starker*)starker {
    Stark* folder = nil ;
    if ([self isAnImporter]) {
        NSString* starkid = [talderMap folderId] ;
        NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init] ;
        NSManagedObjectContext* managedObjectContext = [starker managedObjectContext] ;
        NSArray* fetches = nil ;
        [fetchRequest setEntity:[NSEntityDescription SSY_entityForName:constEntityNameStark
                                                inManagedObjectContext:managedObjectContext]] ;
        NSExpression* lhs = [NSExpression expressionForKeyPath:constKeyStarkid] ;
        NSExpression* rhs = [NSExpression expressionForConstantValue:starkid] ;
        NSError* fetchError = nil ;
        NSPredicate *predicate = [NSComparisonPredicate predicateWithLeftExpression:lhs
                                                                    rightExpression:rhs
                                                                           modifier:NSDirectPredicateModifier
                                                                               type:NSEqualToPredicateOperatorType
                                                                            options:0] ;
        [fetchRequest setPredicate:predicate] ;
        fetches = [managedObjectContext executeFetchRequest:fetchRequest
                                                      error:&fetchError] ;
        if (fetchError) {
            NSLog(@"Internal Error 684-2549: %@", [fetchError longDescription]) ;
        }
        [fetchRequest release] ;
        folder = [fetches firstObjectSafely] ;
    }
    else {
        // This is an export
        NSString* folderId = [talderMap folderId] ;
        if ([folderId hasPrefix:@"HARTAINER_SHARYPE_"]) {
            NSString* suffix = [folderId substringFromIndex:18] ;
            Sharype sharype = [suffix integerValue] ;
            folder = [starker rootChildOfSharype:sharype] ;
        }
        else {
            folder = [starksKeyedById objectForKey:folderId] ;
        }
    }
    
    return folder ;
}

- (NSArray*)folderMapsOrdered {
    return [[self folderMaps] arraySortedByKeyPath:constKeyIndex] ;
}

- (NSArray*)tagMapsOrdered {
    return [[self tagMaps] arraySortedByKeyPath:constKeyIndex] ;
}

- (void)logMatesKeyedBySource:(NSDictionary*)matesKeyedBySource
                        basis:(BkmxBasis*)basis {
    NSString *logEntry;
    logEntry = [[NSString alloc] initWithFormat:@"18241: matesKeyedBySource:\n"] ;
#if LOG_TO_CONSOLE_TOO
    NSLog(@"%@", logEntry) ;
#endif
    [basis trace:logEntry] ;
    [logEntry release] ;
    logEntry = [[NSString alloc] initWithFormat:@"     source      destin\n"] ;
#if LOG_TO_CONSOLE_TOO
    NSLog(@"%@", logEntry) ;
#endif
    [basis trace:logEntry] ;
    [logEntry release] ;
    for (NSValue* p in matesKeyedBySource) {
        logEntry = [[NSString alloc] initWithFormat:@"   %p  %p\n",
                    [p pointerValue],
                    [matesKeyedBySource objectForKey:p]] ;
#if LOG_TO_CONSOLE_TOO
        NSLog(@"%@", logEntry) ;
#endif
        [basis trace:logEntry] ;
        [logEntry release] ;
    }
}

- (void)logMatesKeyedByDestin:(NSDictionary*)matesKeyedByDestin
                        basis:(BkmxBasis*)basis {
    NSString *logEntry;
    logEntry = [[NSString alloc] initWithFormat:@"18141: matesKeyedByDestin:\n"] ;
#if LOG_TO_CONSOLE_TOO
    NSLog(@"%@", logEntry) ;
#endif
    [basis trace:logEntry] ;
    [logEntry release] ;
    logEntry = [[NSString alloc] initWithFormat:@"     destin      source\n"] ;
#if LOG_TO_CONSOLE_TOO
    NSLog(@"%@", logEntry) ;
#endif
    [basis trace:logEntry] ;
    [logEntry release] ;
    for (NSValue* p in matesKeyedByDestin) {
        logEntry = [[NSString alloc] initWithFormat:@"   0x%p  %p\n", [p pointerValue], [matesKeyedByDestin objectForKey:p]] ;
#if LOG_TO_CONSOLE_TOO
        NSLog(@"%@", logEntry) ;
#endif
        [basis trace:logEntry] ;
        [logEntry release] ;
    }
}

- (void)markToMoveStark:(Stark*)destinStark
          correctParent:(Stark*)correctParent
      sponsoredChildren:(NSMutableDictionary*)sponsoredChildrenDic
             destinRoot:(Stark*)destinRoot {
    if ([correctParent managedObjectContext] != [destinStark managedObjectContext]) {
        NSString* logEntry = [[NSString alloc] initWithFormat:@"Attempt to do cross-moc relationship!\n   correctParent:%@ moc:%@ ownerOfMoc:%@\n   attempted sponsoredChildObject:%@ moc:%@ ownerOfMoc:%@\n",
                              [correctParent shortDescription],
                              [correctParent managedObjectContext],
                              [SSYMOCManager ownerOfManagedObjectContext:[correctParent managedObjectContext]],
                              [destinStark shortDescription],
                              [destinStark managedObjectContext],
                              [SSYMOCManager ownerOfManagedObjectContext:[destinStark managedObjectContext]]] ;
#if LOG_TO_CONSOLE_TOO
        NSLog(@"%@", logEntry) ;
#endif
        [[BkmxBasis sharedBasis] trace:logEntry] ;
        [logEntry release] ;
    }
    else {
        if ([self isAnExporter]) {
            if (![[self extore] parentSharype:[correctParent sharypeValue]
                          canHaveChildSharype:[destinStark sharypeValue]]) {
                correctParent = [(Exporter*)self fosterParentForStark:destinStark] ;
            }
        }
        
        // Mark this in case we are not the last ixport of
        // a multiple-source ixport
        [destinStark setCorrectParentHasMe:YES] ;
        
        // First, remove from current parent, lest it may still be in the
        // correctChildrenSet of the old parent, and thus Connect Families
        // might put it in the old parent if it happens to be processed
        // after the correctParent -- behavior is random -- Yikes!!
        Stark* currentParent = [destinStark parent] ;
        BOOL foundSponsor = NO ;
        if (currentParent) {
            [[currentParent childrenTemp] removeObject:destinStark] ;
            if (currentParent != correctParent) {
                NSMutableSet* sponsorRecord = [sponsoredChildrenDic objectForKey:[currentParent starkid]] ;
                if ([sponsorRecord member:destinStark] != nil) {
                    [sponsorRecord removeObject:destinStark] ;
                    foundSponsor = YES ;
                }
            }
        }
        else {
            // It could be in destinRoot...
            NSMutableArray* destinRootChildrenTemp = [destinRoot childrenTemp] ;
            if ([destinRootChildrenTemp indexOfObject:destinStark] != NSNotFound) {
                [destinRootChildrenTemp removeObject:destinStark] ;
            }
            if (correctParent != destinRoot) {
                if (correctParent) {
                    NSMutableSet* sponsorRecord = [sponsoredChildrenDic objectForKey:[destinRoot starkid]] ;
                    if ([sponsorRecord member:destinStark] != nil) {
                        [sponsorRecord removeObject:destinStark] ;
                        foundSponsor = YES ;
                    }
                }
            }
        }
        
        if (!foundSponsor) {
            NSMutableSet* sponsorRecord = nil ;
            for (NSString* sponsorStarkId in [sponsoredChildrenDic allKeys]) {
                sponsorRecord = [sponsoredChildrenDic objectForKey:sponsorStarkId] ;
                if ([sponsorRecord member:destinStark] != nil) {
                    foundSponsor = YES ;
                    break ;
                }
            }
            
            if (foundSponsor) {
                [sponsorRecord removeObject:destinStark] ;
            }
            else {
            }
        }
        
        // Now add to sponsored children of correct parent
        NSMutableSet* sponsoredChildren = [sponsoredChildrenDic objectForKey:[correctParent starkid]] ;
        NSString* starkid = [correctParent starkid] ;
        if (!sponsoredChildren && starkid) {
            sponsoredChildren = [[NSMutableSet alloc] init] ;
            [sponsoredChildrenDic setObject:sponsoredChildren
                                     forKey:starkid] ;
            [sponsoredChildren release] ;
        }
        [sponsoredChildren addObject:destinStark] ;
    }
}

/* This method wraps caches around -shouldExportStark:withChange: for
 performance optimization.  Without the caches, the costly
 -[Extore shouldEportStark:withChange:] is invoked too much, ~N^2, where
 N is the number of bookmarks in a folder, because each 'sibling' must
 invoke it for each sibling.  It would take a half hour or more for a folder
 with 13,000 bookmarks in Finding Parents.  */
- (BOOL)shouldExportStark:(Stark*)stark
            positiveCache:(NSMutableSet*)positiveCache
            negativeCache:(NSMutableSet*)negativeCache
                   extore:(Extore*)extore {
    // Because -[Extore shouldExportStark:withChange: is expensive,
    // we cache its result…
    BOOL isExportable ;
    if ([positiveCache member:stark] != nil) {
        isExportable = YES ;
    }
    else if ([negativeCache member:stark] != nil) {
        isExportable = NO ;
    }
    else if ([extore shouldExportStark:stark
                            withChange:nil]) {
        isExportable = YES ;
        [positiveCache addObject:stark] ;
    }
    else {
        isExportable = NO ;
        [negativeCache addObject:stark] ;
    }
    
    return isExportable ;
}

- (void)configureForExportHartainer:(Stark*)hartainer
                            atIndex:(NSInteger)index {
    [hartainer setIsNewItem];
    [hartainer setSponsorIndex:@(SPONSORED_BY_IS_HARTAINER)];
    [hartainer setSponsoredIndex:@(index)];
    [hartainer setIxportingIndex:index];
    [hartainer setIndexValue:index];
}

- (BOOL)mergeFromStartainer:(NSObject <Startainer, StarkReplicator> *)source
               toStartainer:(NSObject <Startainer, StarCatcher, StarkReplicator> *)destin
                       info:(NSMutableDictionary*)info
                    error_p:(NSError**)error_p {
    BkmxBasis* basis = [BkmxBasis sharedBasis] ;
    NSInteger traceLevel = [basis traceLevel] ;
#if 0
#warning Tracing ixport to console too
#define LOG_TO_CONSOLE_TOO 1
#endif
    
    NSString* logEntry ;
    NSString* what = [self isAnImporter] ? @"import" : @"export" ;
    NSArray* doOnlyImporters = [info objectForKey:constKeyDoOnlyImportersArray];
    Exporter* doOnlyExporter = [info objectForKey:constKeyDoOnlyExporter];
    
    NSInteger indexOfThisJob;
    NSInteger countOfJobs;
    if (doOnlyExporter) {
        indexOfThisJob = 0;
        countOfJobs = 1;
    } else if (doOnlyImporters) {
        indexOfThisJob = [doOnlyImporters indexOfObject:self];
        countOfJobs = doOnlyImporters.count;
    } else {
        NSArray* allIxporters;
        Client* client = [self client] ;
        Macster* macster = [client macster] ;
        if ([self isAnImporter]) {
            allIxporters = [macster activeImportersOrdered] ;
        }
        else {
            allIxporters = [macster activeExportersOrdered] ;
        }
        
        indexOfThisJob = [allIxporters indexOfObject:self];
        countOfJobs = allIxporters.count;
    }
    
    NSString* displayNameGivingIndex = [NSString stringWithFormat:
                                            @"%@ (%ld/%ld)",
                                        [self displayName],
                                        (long)(indexOfThisJob + 1),  // +1 to change from starting index from 0 to 1
                                        (long)countOfJobs
    ] ;
    NSInteger ixportingIndex = 1 ;
    
    if (traceLevel > 0) {
        logEntry = [[NSString alloc] initWithFormat:@"-------> Beginning %@ Merge for %@ <------\n", what, displayNameGivingIndex] ;
#if LOG_TO_CONSOLE_TOO
        NSLog(@"%@", logEntry) ;
#endif
        [basis trace:logEntry] ;
        [logEntry release] ;
    }
    
    BOOL ok = YES ;
    
    // Initialize any variable which might be released if we jump to label end:
    // so that we can release it without crashing
    NSCountedSet* sourceExids = nil ;
    NSMutableSet* duplicatedExids = nil ;
    NSMutableArray* newDestinStarks = nil ;
    NSMutableArray* sourceStarksNotMatched = nil;
    NSArray* sourceStarksNotMatchedCopy = nil;
    /* See other comments marked by NoteRareMissingSafariHartainer … */
    NSMutableArray* standinHartainersWhichShouldBeExported = [[NSMutableArray alloc] init];
    NSMutableDictionary* starkMatches = nil ;
    NSMutableDictionary* matesKeyedBySource = [[NSMutableDictionary alloc] init] ;
    NSMutableDictionary* matesKeyedByDestin = [[NSMutableDictionary alloc] init] ;
    NSMutableDictionary* destinStarketsKeyedByExid = [[NSMutableDictionary alloc] init] ;
    
    // Some basic stuff we'll be using..
    BkmxDoc* bkmxDoc = [info objectForKey:constKeyDocument] ;
    Extore* extore = [info objectForKey:constKeyExtore] ;
    SSYProgressView* progressView = nil ;
    Clientoid* clientoid = [[self client] clientoid] ;
    NSString* verb ;
    
    NSMutableDictionary* sponsoredChildrenDic ;
    sponsoredChildrenDic = [info objectForKey:constKeySponsoredChildren] ;
    if ([self isAnImporter]) {
        NSAssert(sponsoredChildrenDic != nil, @"Interal Error 285-3938") ;
    }
    else {
        NSAssert(sponsoredChildrenDic == nil, @"Interal Error 285-3336") ;
        sponsoredChildrenDic = [NSMutableDictionary dictionary] ;
        [info setObject:sponsoredChildrenDic
                 forKey:constKeySponsoredChildren] ;
    }
    
    logEntry = [NSString stringWithFormat:
                @"%@ %@: Merging content",
                [self displayName],
                [self isAnImporter] ? @"Import" : @"Export"] ;
    [[BkmxBasis sharedBasis] logFormat:logEntry] ;
#if LOG_TO_CONSOLE_TOO
    NSLog(@"%@", logEntry) ;
#endif
    
    
#pragma mark mergeFromStartainer:::  01.  Prepare  **********************
    
    if (traceLevel > 0) {
        logEntry = [[NSString alloc] initWithFormat:@"   01.  Prepare\n"] ;
#if LOG_TO_CONSOLE_TOO
        NSLog(@"%@", logEntry) ;
#endif
        [basis trace:logEntry] ;
        [logEntry release] ;
    }
    
    verb = [NSString stringWithFormat:@"%@ : Fetching (1/8)", displayNameGivingIndex] ;
    progressView = [[bkmxDoc progressView] setIndeterminate:YES
                                          withLocalizedVerb:verb
                                                   priority:SSYProgressPriorityRegular] ;
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;
    
    // Get starkers
    Starker* destinStarker = [destin starker] ;
    
    // Since the BkmxDoc end of the process supports all attributes,
    // the common attrbutes are simply those of the extore.
    NSArray* commonAttributes = [[[self client] extoreClass] editableAttributesInStyle:extore.ixportStyle] ;
    commonAttributes = [commonAttributes arrayByRemovingObject:constKeyIndex] ;
    if ([[self fabricateTags] boolValue] || [self fabricateFoldersAny]) {
        // If importing, our bookmarks will be getting tagged
        // before merging, so we'll need 'tags' in commonAttributes.
        // Likewise if exporting, our bookmarks will need to have
        // tags copied to them so we can create folders from them
        // after merging, so we'll need 'tags' in commonAttributes.
        // However, 'tags' may not be in extore's supportAttributes, so
        // we add it now.
        // Note that we do *not* add ownerValues, since those are
        // always private to the owner (Extore) and should *never*
        // be overwritten.
        commonAttributes = [commonAttributes arrayByAddingObject:constKeyTags] ;
    }
    
    // Local variables we'll be re-using
    Stark* sourceStark ;
    Stark* destinStark ;
    NSInteger i ;
    
    BOOL beginningProduct = [self isBeginningProductForBkmxDoc:bkmxDoc] ;
    /* Do two fetches to get the two sets of starks that we shall use
    throughout this method.  We do this to avoid the inefficiency of fetches.
    Also, at one time I thought that the pointer values might be different if
    starks were re-fetched, and this would foul up the because the matesXXXX
    dictionary which is keyed by pointer values.  But then Ben Trumbull iirc
    said that you'll always get the same pointer.  A third reason is that
    Pointer values are also much more compact than managed object identifiers
    (-objectID), and not subject to change from temporary to permanent if
    fetches or saves are done.

    Starting with BookMacster 1.1, sourceStarks is an array instead of a set,
    so that -descendants gives deterministic results.  We want this because,
    say, for example, you do an Import with Delete Unmatched Items OFF and
    mergeBias set to take the client, and mergeBy = BkmxMergeByExidOrUrl, and
    some starks in the source/Client with duplicate URLs.  When we used a set,
    the first one that showed up when enumerating for (Stark* stark in
    sourceStarksSet) would match a destin stark, possibly moving it or changing
    its attributes.  And since the first one that shows up is not
    deterministic, this Import operation becomes nondeterministic, and you see
    this dithering Updates in the log. Cost is negligible; for 1500 bookmarks
    on my Mac Mini, -allObjects clocks 8 milliseconds while -descendants clocks
    20 milliseconds. */
    NSArray* sourceStarks = [[[source starker] root] descendantsWithSelf:YES] ;
    
    NSMutableArray* destinStarks ;
    if (beginningProduct) {
        // This will always execute during an export, and will execute
        // for the first Client during an Import
        destinStarks = [[destinStarker root] descendantsWithSelf:YES] ;
        [[destin starker] setDestinees:destinStarks] ;
        if ([self isAnImporter]) {
            [bkmxDoc setImportedExtores:nil] ;
        }
    }
    else {
        // This will execute for non-first Clients during an Import
        destinStarks = [[destin starker] destinees] ;
    }
    
    // The -isAnImporter qualification was added in BookMacster 1.10,
    // not to fix any problem but just as a "don't lie to yourself"
    // good practice.
    if ([self isAnImporter]) {
        [bkmxDoc addImportedExtore:extore] ;
    }
    
    BOOL doBookMacsterizerOnly = [[info objectForKey:constKeyIxportBookmacsterizerOnly] boolValue] == YES ;
    if (doBookMacsterizerOnly) {
        Stark* bookmacsterizer = nil ;
        for (Stark* stark in sourceStarks) {
            if ([stark isBookmacsterizer]) {
                bookmacsterizer = stark ;
            }
        }
        if (!bookmacsterizer) {
            if ([source respondsToSelector:@selector(insertFreshBookMacsterizer)]) {
                [[bkmxDoc chaker] setIsActive:NO] ;
                bookmacsterizer = [source insertFreshBookMacsterizer] ;
                [[bkmxDoc chaker] setIsActive:YES] ;
            }
            else {
                // constKeyIxportBookMacstrizerOnly should only have occurred
                // if source is a BkmxDoc; i.e. this is supposed to be an export
                NSLog(@"Internal Error 452-0581") ;
            }
        }
        
        // All we need to consider exporting is the bookmacsterizer and all of
        // its ancestors, if any.
        sourceStarks = [bookmacsterizer lineageSharypeMaskOut:0
                                                  includeSelf:YES] ;
    }
    
    if (traceLevel > 3) {
        logEntry = [[NSString alloc] initWithFormat:@"00001: exids for %ld sourceStarks:\n", (long)[sourceStarks count]] ;
#if LOG_TO_CONSOLE_TOO
        NSLog(@"%@", logEntry) ;
#endif
        [basis trace:logEntry] ;
        [logEntry release] ;
        for (sourceStark in sourceStarks) {
            logEntry = [[NSString alloc] initWithFormat:@"%@ %@\n", [sourceStark exidForClientoid:clientoid], [sourceStark shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
            NSLog(@"%@", logEntry) ;
#endif
            [basis trace:logEntry] ;
            [logEntry release] ;
        }
        logEntry = [[NSString alloc] initWithFormat:@"00002: %ld destinStarks: %@\n", (long)[destinStarks count], [destinStarks shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
        NSLog(@"%@", logEntry) ;
#endif
        [basis trace:logEntry] ;
        [logEntry release] ;
    }
    
    // It looks like the following if(beginningProduct) section can be moved up to
    // Marker 502494 above.  Then it, and the if(beginningProduct)/else section which
    // precedes it, could be combined into a "prepareDestinStarks" method
    if (beginningProduct) {
        for (destinStark in destinStarks) {
            [destinStark setSponsorIndex:nil] ;
            
            // For years I thought the following was not necessary, because
            //  (a) Objective-C sets all instance variables to zero when an object is created
            //  (b) -clearIxportFlags is sent to all destinStarks at the end of -gulpStartainer:::, when ending product
            // However, on 20110714 I discovered that it is necessary due to the following corner case…
            //   * Perform import with Delete Unmatched Items checkbox ON
            //   * Unmatched items will be deleted and isDeletedThisIxport bit will be 1
            //   * In Delete Unmatched Items phase, unmatched items will also be deleted from
            //     destinStarks; therefore they will *not* have their flags cleared
            //   * Undo
            //   * Change Delete Unmatched Items checkbox to OFF
            //   * Import again.
            //   * Eeek! Import begins with isDeletedThisIxport flag bit = 1.
            // This will cause the item to be re-deleted during this second import, when
            // it should be.  Fixed in BookMacster 1.6.2.
            [destinStark clearIxportFlags] ;
            
            if ([destinStark canHaveChildren]) {
                NSArray* originalChildren = [destinStark childrenOrdered] ;
                [destinStark setChildrenTemp:[NSMutableArray arrayWithArray:originalChildren]] ;
            }
        }
        
        // Probably defensive programming…
        [destinStarker forgetHartainersCache] ;
        
        for (destinStark in destinStarks) {
            [destinStark setIxportingIndex:ixportingIndex++] ;
        }
        
        // We add standin hartainers before adding ourself
        // as an observer.  However, bkmxDoc is still observing.  So we
        // we temporarily remove that, then re-add when done.
        [[NSNotificationCenter defaultCenter] removeObserver:bkmxDoc
                                                        name:SSYManagedObjectWillUpdateNotification
                                                      object:nil] ;
        
        NSInteger offsetForBar = destinStarker.bar != nil ? 1 : 0;
        NSInteger offsetForMenu = destinStarker.menu != nil ? 1 : 0;
        NSInteger offsetForUnfiled = destinStarker.unfiled != nil ? 1 : 0;
        Stark* standinBar = nil;
        Stark* standinMenu = nil;
        Stark* standinUnfiled = nil;
        Stark* standinOhared = nil;
        /* Standin hartainers are probably inserted in backwards order
         (ohared, unfiled, menu, bar) so that they appeaar in the opposite,
         usual order in the destinStarks array.  I'm not sure why this was
         thought to be important. */
        destinStark = [destinStarker makeStandinSharype:SharypeOhared] ;
        if (destinStark) {
            [destinStarks insertObject:destinStark
                               atIndex:1] ;
            if ([self isAnExporter] && [extore mustHaveOharedInFile]) {
                [standinHartainersWhichShouldBeExported addObject:destinStark];
                standinOhared = destinStark;
            }
        }
        destinStark = [destinStarker makeStandinSharype:SharypeUnfiled] ;
        if (destinStark) {
            [destinStarks insertObject:destinStark
                               atIndex:1] ;
            if ([self isAnExporter] && [extore mustHaveUnfiledInFile]) {
                [standinHartainersWhichShouldBeExported addObject:destinStark];
                standinUnfiled = destinStark;
                offsetForUnfiled = 1;
            }
        }
        destinStark = [destinStarker makeStandinSharype:SharypeMenu] ;
        if (destinStark) {
            [destinStarks insertObject:destinStark
                               atIndex:1] ;
            if ([self isAnExporter] && [extore mustHaveMenuInFile]) {
                [standinHartainersWhichShouldBeExported addObject:destinStark];
                standinMenu = destinStark;
                offsetForMenu = 1;
            }
        }
        destinStark = [destinStarker makeStandinSharype:SharypeBar] ;
        if (destinStark) {
            [destinStarks insertObject:destinStark
                               atIndex:1] ;
            if ([self isAnExporter] && [extore mustHaveBarInFile]) {
                [standinHartainersWhichShouldBeExported addObject:destinStark];
                standinBar = destinStark;
                offsetForBar = 1;
            }
        }
        [self configureForExportHartainer:standinBar
                                  atIndex:0];
        [self configureForExportHartainer:standinMenu
                                  atIndex:offsetForBar];
        [self configureForExportHartainer:standinUnfiled
                                  atIndex:(offsetForBar + offsetForMenu)];
        [self configureForExportHartainer:standinOhared
                                  atIndex:(offsetForBar + offsetForMenu + offsetForUnfiled)];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:bkmxDoc
                                                 selector:@selector(objectWillChangeNote:)
                                                     name:SSYManagedObjectWillUpdateNotification
                                                   object:nil] ;
    }
    [[bkmxDoc chaker] setFrom:self] ;
    
    // Add a KVO observer to observe when attributes of starks in the
    // transMoc are updated,
    
    // * We need this when importing; otherwise changes of stark
    // attributes such as 'index' will not run postSortMaybeNot, and
    // -needsSort will return NO when in fact sorting is needed.
    // However, we do not need to addObserver here, because this
    // observation is already added in -[BkmxDoc initializeCommon].
    
    // * We need this when exporting, for adding to our SSYModelChangeCounts
    // result, and we need to add it explicitly here.
    
    // Note that we have waited until after the empty transMoc is populated by
    // -[SSYOperation(Operation_Common) readExternal] before doing this, to avoid all
    // the noise which that would generate.
    
    // Important Note: If added, this observation is removed at the end of this method,
    // so it had better still be active when we get there!
    if ([self isAnExporter]) {
        [self setBkmxDoc:bkmxDoc] ;  // Observer will need this
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(objectWillChangeNote:)
                                                     name:SSYManagedObjectWillUpdateNotification
                                                   object:nil] ; // Nil because must observe any stark
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(objectDidChangeNote:)
                                                     name:SSYManagedObjectDidUpdateNotification
                                                   object:nil] ; // Nil because must observe any stark
    }
    
    BkmxMergeBy mergeBy;
    if ([[extore class] supportsExids]) {
        mergeBy = [[self mergeBy] shortValue];
    } else {
        // ExtoreHtml
        mergeBy = BkmxMergeByNone;
    }
    BkmxMergeBias mergeBias = [[self mergeBias] shortValue] ;
    /* Next line is needed by Gulper. */
    [info setObject:[self mergeBias]
             forKey:constKeyMergeBias];
    
#if ONLY_PRIMARY_SOURCE_CAN_IMPORT_DELETIONS
    BOOL isPrimarySource = [self isPrimarySource] ;
#endif
    BOOL shouldDeleteUnmatchedItems = [self shouldDeleteUnmatchedItemsWithInfo:info] ;
    
    NSMutableDictionary* exportFeedbackDic = nil ;
    if ([self isAnExporter]) {
        // Prepare an empty dictionary to feed back exids from extore to bkmxDoc
        exportFeedbackDic = [NSMutableDictionary dictionary] ;
        [info setObject:exportFeedbackDic
                 forKey:constKeyExportFeedbackDic] ;
    }
    
    // Get ready to maybe ignore unexported deletions
    NSSet* unexportedDeletions ;
    if (YES
        && [self isAnImporter]
#if ONLY_PRIMARY_SOURCE_CAN_IMPORT_DELETIONS
        && (isPrimarySource  || [bkmxDoc didImportPrimarySource])
#endif
        && [[[self client] failedLastExport] boolValue]
        && [[[[self client] exporter] deleteUnmatched] boolValue]
        &&     ((BkmxPerformanceType)[[info objectForKey:constKeyPerformanceType] integerValue] != BkmxPerformanceTypeUser)
        ) {
        unexportedDeletions = [[self client] unexportedDeletions] ;
    }
    else {
        unexportedDeletions = nil ;
    }
    
    // Note that the value of mergeResolutionTags is ignored.  The
    // behavior is hard-wired by the following code to do what most users want:
    BkmxMergeResolutionTags mergeTagsParm ;
    if ([self isAnImporter]) {
        // We're importing
        mergeTagsParm = BkmxMergeResolutionKeepBothTags ;
    }
    else if ([[extore class] canEditTagsInStyle:extore.ixportStyle] || ([[self fabricateFolders] shortValue] > BkmxFabricateFoldersOff)) {
        // We're exporting to a client that supports tags,
        // or we're fabricating folders from tags
        // (2nd condition was added to fix bug in BookMacster 1.1.)
        mergeTagsParm = BkmxMergeResolutionKeepSourceTags ;
    }
    else {
        // We're exporting to a client that does not support tags
        mergeTagsParm = BkmxMergeResolutionKeepDestinTags ;
        // The reason for the above is so that the adding of tags
        // which will ultimately not be exported does not cause
        // otherwise-unchanged starks to be counted in
        // Chaker's updates.
    }
    
    if (traceLevel > 0) {
        NSString* readableMergeBias ;
        switch (mergeBias) {
            case BkmxMergeBiasKeepSource:
                readableMergeBias = @"Keep Source" ;
                break;
            case BkmxMergeBiasKeepDestin:
                readableMergeBias = @"Keep Destin" ;
                break;
            case BkmxMergeBiasKeepBoth:
                readableMergeBias = @"Keep Both" ;
                break;
            default:
                readableMergeBias = @"@@@!!!%%% ERROR %%%!!!@@@" ;
                break;
        }
        
        NSString* readableMergeByValue;
        switch (mergeBy) {
            case BkmxMergeByNone:
                readableMergeByValue = @"merge by NONE";
                break;
            case BkmxMergeByExid:
                readableMergeByValue = @"merge by exid";
                break;
            case BkmxMergeByExidOrUrl:
                readableMergeByValue = @"merge by exid or url";
                break;
        }
        
        logEntry = [[NSString alloc] initWithFormat:@"\n"
                    @"               ixporterIndex = %ld\n"
                    @"            beginningProduct = %hhd\n"
                    @"      clientWillSelfDestruct = %hhd\n"
                    @"       clientDoesIgnoreLimit = %hhd\n"
                    @"             clientIsOverlay = %hhd\n"
                    @"       doUnexportedDeletions = %hhd\n"
                    @"       doBookMacsterizerOnly = %hhd\n"
                    @"  shouldDeleteUnmatchedItems = %hhd\n"
                    @"                     mergeBy = %ld (%@)\n"
                    @"                   mergeBias = %ld (%@)\n"
                    @"               mergeTagsParm = %ld\n",
                    (long)indexOfThisJob,
                    beginningProduct,
                    [[self client] willSelfDestruct],
                    [[self client] willIgnoreLimit],
                    [[self client] willOverlay],
                    (BOOL)(unexportedDeletions != nil),
                    doBookMacsterizerOnly,
                    shouldDeleteUnmatchedItems,
                    (long)mergeBy,
                    readableMergeByValue,
                    (long)mergeBias, readableMergeBias,
                    (long)mergeTagsParm] ;
#if LOG_TO_CONSOLE_TOO
        NSLog(@"%@", logEntry) ;
#endif
        [basis trace:logEntry] ;
        [logEntry release] ;
        
        logEntry = [[NSString alloc] initWithFormat:@"       %ld source and %ld destin starks\n", (long)[sourceStarks count], (long)[destinStarks count]] ;
#if LOG_TO_CONSOLE_TOO
        NSLog(@"%@", logEntry) ;
#endif
        [basis trace:logEntry] ;
        [logEntry release] ;
    }
    
    // Preparation of source starks
    //   (1) Mark those which begin the ixport being childless
    //   (2) Check and make sure that no source starks have same exids and fix any that do.
    sourceExids = [[NSCountedSet alloc] initWithCapacity:[sourceStarks count]] ;
    for (sourceStark in sourceStarks) {
        NSString* exid = [sourceStark exidForClientoid:clientoid] ;
        if (exid) {
            [sourceExids addObject:exid] ;
        }
    }
    duplicatedExids = [[NSMutableSet alloc] init] ;
    for (NSString* exid in sourceExids) {
        NSInteger count = [sourceExids countForObject:exid] ;
        if (count > 1) {
            [duplicatedExids addObject:exid] ;
        }
    }
#if 0
#warning Logging Duplicated exids
#define LOGGING_DUPLICATED_EXIDS 1
    if ([duplicatedExids count] > 0) {
        NSString* what = [self isAnImporter] ? @"import" : @"export" ;
        NSLog(
              @"During %@ with %@, %ld src items with same exid: %@",
              what,
              displayNameGivingIndex,
              (long)count,
              exid
              ) ;
    }
#endif
    for (NSString* duplicatedExid in duplicatedExids) {
        BOOL firstOne = YES ;
        for (Stark* stark in sourceStarks) {
            NSString* exid = [stark exidForClientoid:clientoid] ;
            if ([exid isEqualToString:duplicatedExid]) {
                if (firstOne) {
                    firstOne = NO ;
#if LOGGING_DUPLICATED_EXIDS
                    NSLog(@"Keep exid %@ for %@ in %@", exid, [clientoid displayName], [stark shortDescription]) ;
#endif
                }
                else {
                    NSString* newExid = nil ;
                    NSError* getExidError = nil ;
                    [extore getFreshExid_p:&newExid
                                higherThan:0
                                  forStark:stark
                                   tryHard:NO] ;
                    if (newExid) {
                        [stark setExid:newExid
                          forClientoid:clientoid] ;
                        // We assume that the above change will be saved later,
                        // when -saveExidsMoc runs.  It won't be saved if another
                        // error occurs and cancels all operations, but that's OK.
#if LOGGING_DUPLICATED_EXIDS
                        NSLog(@"Anew exid %@ for %@ in %@", newExid, [clientoid displayName], [stark shortDescription]) ;
#endif
                    }
                    else {
                        if (error_p) {
                            *error_p = SSYMakeError(548210, @"Could not create new exid") ;
                            *error_p = [*error_p errorByAddingUserInfoObject:[stark shortDescription]
                                                                      forKey:@"Stark"] ;
                            *error_p = [*error_p errorByAddingUserInfoObject:[stark url]
                                                                      forKey:@"URL"] ;
                            *error_p = [*error_p errorByAddingUserInfoObject:duplicatedExid
                                                                      forKey:@"Same Exid"] ;
                            *error_p = [*error_p errorByAddingUserInfoObject:[NSNumber numberWithInteger:[sourceExids countForObject:duplicatedExid]]
                                                                      forKey:@"Same Exid Count"] ;
                            *error_p = [*error_p errorByAddingUnderlyingError:getExidError] ;
                        }
                        
                        ok = NO ;
                        goto end ;
                    }
                }
            }
        }
    }
    
    sourceStarksNotMatched = [[[source starker] allStarks] mutableCopy];

    /* Match hartainers.  (In BkmkMgrs v2, matesKeyedByDestin did not contain
     the hartainers.  But, apparently due to changes in the Merge By Exid,
     Merge By URL and Make New Items sections, it is necessary in v3. */
    for (Stark* sourceStark in [[source starker] allHartainers]) {
        Stark* destinStark = [[destin starker] hartainerOfSharype:[sourceStark sharypeValue]
                              quickly:YES];
        if (destinStark) {
            [matesKeyedByDestin setObject:sourceStark
                                   forKey:[NSValue valueWithPointer:destinStark]];
            [matesKeyedBySource setObject:destinStark
                                   forKey:[NSValue valueWithPointer:sourceStark]];
        }
        [sourceStarksNotMatched removeObject:sourceStark];
    }
    
    // We can pre-compute this for efficiency
    [Starker populateStarkets:destinStarketsKeyedByExid
      keyedByExidForClientoid:clientoid
                    fromArray:destinStarks] ;
        
    
#pragma mark mergeFromStartainer:::  02.  Merge by Exid **********************
    
    if (mergeBy >= BkmxMergeByExid) {
        if (traceLevel > 0) {
            logEntry = [[NSString alloc] initWithFormat:@"   02.  Merge By Exid\n"] ;
#if LOG_TO_CONSOLE_TOO
            NSLog(@"%@", logEntry) ;
#endif
            [basis trace:logEntry] ;
            [logEntry release] ;
        }
        
        if (traceLevel > 3) {
            logEntry = [[NSString alloc] initWithFormat:@"      %ld destinStarketsKeyedByExid:\n", (long)[destinStarketsKeyedByExid count]] ;
#if LOG_TO_CONSOLE_TOO
            NSLog(@"%@", logEntry) ;
#endif
            [basis trace:logEntry] ;
            [logEntry release] ;
            for (NSString* someExid in destinStarketsKeyedByExid) {
                Stark* someStark = [destinStarketsKeyedByExid objectForKey:someExid] ;
                logEntry = [[NSString alloc] initWithFormat:@"            %@: %@\n", someExid, [someStark shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
                NSLog(@"%@", logEntry) ;
#endif
                [basis trace:logEntry] ;
                [logEntry release] ;
            }
        }
        
        if (traceLevel > 3) {
            logEntry = [[NSString alloc] initWithFormat:@"22999: Will try merge %ld sourceStarks by exid\n", (long)[sourceStarks count]] ;
#if LOG_TO_CONSOLE_TOO
            NSLog(@"%@", logEntry) ;
#endif
            [basis trace:logEntry] ;
            [logEntry release] ;
        }
        
        verb = [NSString stringWithFormat:@"%@ : Merging by ID (2/8)", displayNameGivingIndex] ;
        [progressView setIndeterminate:NO
                     withLocalizedVerb:verb
                              priority:SSYProgressPriorityRegular] ;
        // We are going to loop through sourceStarks twice…
        [progressView setMaxValue:[sourceStarks count]*2] ;
        i = 0 ;
        [progressView setDoubleValue:i] ;
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;
        starkMatches= [[NSMutableDictionary alloc] init] ;
        [sourceStarksNotMatchedCopy release];
        sourceStarksNotMatchedCopy = [sourceStarksNotMatched copy];
        for (sourceStark in sourceStarksNotMatchedCopy) {
            NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
            i++ ;
            [progressView incrementAndRunDoubleValueBy:1] ;
            [sourceStark setIxportingIndex:ixportingIndex++] ;

            if (traceLevel > 3) {
                logEntry = [[NSString alloc] initWithFormat:@"33000: Merging by exid source: %@\n", [sourceStark shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
                NSLog(@"%@", logEntry) ;
#endif
                [basis trace:logEntry] ;
                [logEntry release] ;
            }
            
            if (traceLevel > 3) {
                logEntry = [[NSString alloc] initWithFormat:@"33005:    canHaveChildren=%hhd, children=%p (%ld), isUpdatedThisIxport=%hhd\n",
                            [sourceStark canHaveChildren],
                            [sourceStark children],
                            (long)[[sourceStark children] count],
                            [sourceStark isUpdatedThisIxport]] ;
#if LOG_TO_CONSOLE_TOO
                NSLog(@"%@", logEntry) ;
#endif
                [basis trace:logEntry] ;
                [logEntry release] ;
            }
            
            NSString* exid = [sourceStark exidForClientoid:clientoid] ;
            
            // Ignore if this is an unexported deletion
            if ([unexportedDeletions member:exid]) {
                [pool drain] ;
                continue ;
            }
            
            if (![sourceStark isHartainer]) {
                // It's a soft Stark of some kind
                
                switch (mergeBias) {
                    case BkmxMergeBiasKeepBoth:
                        destinStark = nil ;
                        break ;
                    case BkmxMergeBiasKeepSource:
                    case BkmxMergeBiasKeepDestin:;
                        // First, try to find a destinStark with the same exid
                        id destinStarket = [destinStarketsKeyedByExid objectForKey:exid] ;
                        if ([destinStarket isKindOfClass:[Stark class]]) {
                            destinStark = destinStarket ;
                        }
                        else {
                            destinStark = [sourceStark bestMatchFromSet:destinStarket] ;
                        }
                        
                        // Sanity Test (added in BookMacster 1.0.4).  We reject only coarse
                        // mismatches, because fine types may be different in some clients
                        // that do no support the actual fine type.  For example, although we
                        // don't do this any more, in earlier versions a SharypeSmart item would
                        // have been exported to Safari as a SharypeBookmark, and then during
                        // the next export would appear to be a destinStark of SharypeBookmark.
                        // But it must be allowed to match to its mating sourceStark which is
                        // SharypeSmart.
                        if ([destinStark sharypeCoarseValue] != [sourceStark sharypeCoarseValue]) {
                            if (traceLevel > 3) {
                                if (destinStark) {
                                    logEntry = [[NSString alloc] initWithFormat:@"33025     Insane coarse sharypes source:%hx destin:%hx\n",
                                                [sourceStark sharypeValue],
                                                [destinStark sharypeValue]] ;
#if LOG_TO_CONSOLE_TOO
                                    NSLog(@"%@", logEntry) ;
#endif
                                    [basis trace:logEntry] ;
                                    [logEntry release] ;
                                }
                            }
                            destinStark = nil ;
                        }
                        
                        if (traceLevel > 3) {
                            if (destinStark) {
                                logEntry = [[NSString alloc] initWithFormat:@"33010     Found destin with same exid (%@ = %@):\n                    %@\n",
                                            exid,
                                            [destinStark exidForClientoid:clientoid],
                                            [destinStark shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
                                NSLog(@"%@", logEntry) ;
#endif
                                [basis trace:logEntry] ;
                                [logEntry release] ;
                            }
                        }
                }
                
                if (![self shouldIxportDueToIxportabilitySourceStark:sourceStark
                                                         destinStark:destinStark
                                                           clientoid:clientoid
                                                              extore:extore
                                          shouldDeleteUnmatchedItems:shouldDeleteUnmatchedItems
                                                          traceLevel:traceLevel
                                                               basis:basis]) {
                    [pool drain] ;
                    continue ;
                }

                if (![self shouldIxportDueToSeparatornessSourceStark:sourceStark
                                                         destinStark:destinStark
                                                           mergeBias:mergeBias
                                                          traceLevel:traceLevel
                                                               basis:basis]) {
                    [pool drain] ;
                    continue ;
                }
                
            }
            
            StarkMatch* starkMatch = [starkMatches objectForKey:exid] ;
            if (starkMatch) {
                [starkMatch considerSourceStark:sourceStark] ;
                [starkMatch considerDestinStark:destinStark] ;
            }
            else {
                if (!exid) {
                    /* This sourceStark does not have a exid for this client.
                     Presumably, it is either
                     (a) new,
                     (b) not exportable to this client, or
                     (c) a duplicate in the BkmxDoc, and the destination extore
                     does not allow duplicates.
                     In cases (b) and (c), it will not have been exported
                     previously, hence no exid for this client
                     
                     We shall still create a StarkMatch for this sourceStark,
                     however, so that it can be added to sourceStarksNotMatchedByExid
                     at the end of this section "Merge by Exid".  So we need a
                     phony exid to use as a key.  We create one with the current
                     index `i` because this might be handy for debugging.
                     
                     It seems like it would be more efficient to, right here
                     and now, just add the sourceStark to sourceStarksNotMatchedByExid
                     instead of creating a StarkMatch with a phony exid.  But this
                     very sensitive code has been working for years and I don't
                     have time to verify that right now. */
                    if ([sourceStark sharypeCoarseValue] == SharypeCoarseHartainer) {
                        exid = [StarkTyper readableSharype:[sourceStark sharypeValue]] ;
                    }
                    else {
                        exid = [NSString stringWithFormat:@"BkmxPhony-%ld", (long)i] ;
                    }
                }
                starkMatch = [[StarkMatch alloc] initWithSourceStark:sourceStark
                                                         destinStark:destinStark] ;
                [starkMatches setObject:starkMatch
                                 forKey:exid] ;
                [starkMatch release] ;
            }
            
            [pool drain] ;
        }
        
        for (StarkMatch* starkMatch in [starkMatches allValues]) {
            NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
            
            [progressView incrementAndRunDoubleValueBy:1] ;
            sourceStark = [starkMatch sourceStark] ;
            destinStark = [starkMatch destinStark] ;
            if (destinStark) {
                if (![sourceStark isHartainer]) {
                    
                    [self  setMirroringInDestinStark:destinStark
                                          mergeBias:mergeBias
                                         sourceStark:sourceStark
                                          traceLevel:traceLevel];
                    
                    [self finishMatchingDestinStark_p:destinStark
                                              bkmxDoc:bkmxDoc
                                            clientoid:clientoid
                                     commonAttributes:commonAttributes
                                          countOfJobs:countOfJobs
                                doBookMacsterizerOnly:doBookMacsterizerOnly
                                    exportFeedbackDic:exportFeedbackDic
                                               extore:extore
                                           mergeBias:mergeBias
                                        mergeTagsParm:mergeTagsParm
                                               source:source
                                          sourceStark:sourceStark
                                           traceLevel:traceLevel] ;
                    
                    [matesKeyedByDestin setObject:sourceStark
                                           forKey:[NSValue valueWithPointer:destinStark]];
                    [matesKeyedBySource setObject:destinStark
                                           forKey:[NSValue valueWithPointer:sourceStark]];
                    [sourceStarksNotMatched removeObject:sourceStark];
                }
            }
            [pool drain] ;
        }
        
        [starkMatches release] ;
        
        [progressView clearAll] ;
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;
    }
    
    if (traceLevel > 3) {
        logEntry = [[NSString alloc] initWithFormat:@"33400: %ld sourceStarksNotMatched (by exid): %@\n", (long)[sourceStarksNotMatched count], [sourceStarksNotMatched shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
        NSLog(@"%@", logEntry) ;
#endif
        [basis trace:logEntry] ;
        [logEntry release] ;
    }
    
    
    
#pragma mark mergeFromStartainer:::  03.  Merge by URL **********************
    
    if (mergeBy >= BkmxMergeByExidOrUrl) {
        if (traceLevel > 0) {
            logEntry = [[NSString alloc] initWithFormat:@"   03.  Merge By URL\n"] ;
#if LOG_TO_CONSOLE_TOO
            NSLog(@"%@", logEntry) ;
#endif
            [basis trace:logEntry] ;
            [logEntry release] ;
        }
        
        verb = [NSString stringWithFormat:@"%@ : Merging by URL (3/8)", displayNameGivingIndex] ;
        [progressView setIndeterminate:NO
                     withLocalizedVerb:verb
                              priority:SSYProgressPriorityRegular] ;
        [progressView setMaxValue:(sourceStarksNotMatched.count)] ;
        i = 0 ;
        [progressView setDoubleValue:i] ;
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;
        [sourceStarksNotMatchedCopy release];
        sourceStarksNotMatchedCopy = [sourceStarksNotMatched copy];
        for (sourceStark in sourceStarksNotMatchedCopy) {
            NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
            i++ ;
            [progressView incrementAndRunDoubleValueBy:1] ;
            [sourceStark setIxportingIndex:ixportingIndex++] ;

            if (traceLevel > 3) {
                logEntry = [[NSString alloc] initWithFormat:@"43000: Merging by URL source: %@\n", [sourceStark shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
                NSLog(@"%@", logEntry) ;
#endif
                [basis trace:logEntry] ;
                [logEntry release] ;
            }
            
            if (traceLevel > 3) {
                logEntry = [[NSString alloc] initWithFormat:@"43005:    canHaveChildren=%hhd, children=%p (%ld), isUpdatedThisIxport=%hhd\n",
                            [sourceStark canHaveChildren],
                            [sourceStark children],
                            (long)[[sourceStark children] count],
                            [sourceStark isUpdatedThisIxport]] ;
#if LOG_TO_CONSOLE_TOO
                NSLog(@"%@", logEntry) ;
#endif
                [basis trace:logEntry] ;
                [logEntry release] ;
            }
            
            NSString* exid = [sourceStark exidForClientoid:clientoid] ;
            
            // Ignore if this is an unexported deletion
            if ([unexportedDeletions member:exid]) {
                [pool drain] ;
                continue ;
            }
            
            // Try to get destin stark with same url as source stark
            destinStark = nil ;
            
            switch (mergeBias) {
                case BkmxMergeBiasKeepBoth:
                    // Leave destinStark = nil ;
                    break ;
                case BkmxMergeBiasKeepSource:
                case BkmxMergeBiasKeepDestin:
                    if (!destinStark) {
                        NSMutableArray* candidates = [[NSMutableArray alloc] init] ;
                        Stark* chosenCandidate = nil ;
                        for (Stark* candidate in destinStarks) {
                            if (
                                [candidate marksSameSiteAs:sourceStark]
                                &&
                                (
                                 // Clause 1. If the candidate does not have a sponsor index, it was not matched by a prior source stark
                                 (![candidate sponsorIndex])
                                 ||
                                 // Clause 2. If the candidate has a sponsor
                                 ([[candidate sponsorIndex] integerValue] != [self gappyIndexValue])
                                 )
                                // In BookMacster 1.5, Clause 1 and Clause 2 was only one clause, "&& ![candidate sponsorIndex]",
                                // thinking that a non-nil sponsor index meant that it had "already been matched to a prior source stark"
                                // and therefore should not be matched again.  This broke Merge by URL on imports for new BkmxDocs
                                // which were being imported from multiple Clients that had much the same content, because after the
                                // first client was imported, all candidates (destin starks, in the bkmxDoc) would have a sponsorIndex
                                // of number object 0, so that for subsequent clients they would not be merged and additional new
                                // starks would be created.
                                // In BookMacster 1.5.3, I only had clause 2, which was better, because if all clients contained the
                                // same items, now the sponsor index would be 0 and Clause 2 would be YES for the other clients.
                                // But this did not allow matching to occur on the first client because ([nil integerValue] != 0)
                                // was false.
                                ) {
                                    [candidates addObject:candidate] ;
                                }
                        }
                        
                        if (traceLevel > 3) {
                            logEntry = [[NSString alloc] initWithFormat:@"43006:    Found %ld candidates.  Their starkids: %@\n",
                                        (long)[candidates count],
                                        [candidates valueForKey:constKeyStarkid]] ;
#if LOG_TO_CONSOLE_TOO
                            NSLog(@"%@", logEntry) ;
#endif
                            [basis trace:logEntry] ;
                            [logEntry release] ;
                        }
                        
                        if ([candidates count] == 1) {
                            chosenCandidate = [candidates objectAtIndex:0] ;
                            
                            if (traceLevel > 3) {
                                logEntry = [[NSString alloc] initWithFormat:@"33016      %@ %@ : %@\n",
                                            exid,
                                            [destinStark exidForClientoid:clientoid],
                                            [destinStark shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
                                NSLog(@"%@", logEntry) ;
#endif
                                [basis trace:logEntry] ;
                                [logEntry release] ;
                            }
                        }
                        else if ([candidates count] > 1) {
                            // Eliminate those with different parents, identified by exid
                            NSString* targetParentExid = [[sourceStark parent] exidForClientoid:clientoid] ;
                            NSArray* candidates1 = [candidates copy] ;
                            for (Stark* candidate in candidates1) {
                                if (![NSObject isEqualHandlesNilObject1:targetParentExid
                                                                object2:[[candidate parent] exidForClientoid:clientoid]]) {
                                    [candidates removeObject:candidate] ;
                                }
                            }
                            
                            if ([candidates count] == 1) {
                                chosenCandidate = [candidates objectAtIndex:0] ;
                                
                                if (traceLevel > 3) {
                                    logEntry = [[NSString alloc] initWithFormat:@"33017      %@ %@ %@\n",
                                                exid,
                                                [destinStark exidForClientoid:clientoid],
                                                [destinStark shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
                                    NSLog(@"%@", logEntry) ;
#endif
                                    [basis trace:logEntry] ;
                                    [logEntry release] ;
                                }
                            }
                            else {
                                if ([candidates count] < 1) {
                                    // Retreat to previous copy
                                    [candidates release] ;
                                    candidates = [candidates1 mutableCopy] ;
                                }
                                
                                // Eliminate those with different names
                                NSString* targetName = [sourceStark name] ;
                                NSArray* candidates2 = [candidates copy] ;
                                for (Stark* candidate in candidates2) {
                                    if (![NSObject isEqualHandlesNilObject1:targetName
                                                                    object2:[candidate name]]) {
                                        [candidates removeObject:candidate] ;
                                    }
                                }
                                
                                if ([candidates count] >= 1) {
                                    // That was our last chance.  If still > 1, just take the first
                                    chosenCandidate = [candidates objectAtIndex:0] ;
                                    
                                    if (traceLevel > 3) {
                                        logEntry = [[NSString alloc] initWithFormat:@"33018      %@ %@ %@\n",
                                                    exid,
                                                    [destinStark exidForClientoid:clientoid],
                                                    [destinStark shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
                                        NSLog(@"%@", logEntry) ;
#endif
                                        [basis trace:logEntry] ;
                                        [logEntry release] ;
                                    }
                                }
                                else  {
                                    // Retreat to previous copy and take first item
                                    chosenCandidate = [candidates2 objectAtIndex:0] ;
                                    
                                    if (traceLevel > 3) {
                                        logEntry = [[NSString alloc] initWithFormat:@"33019      %@ %@ %@\n",
                                                    exid,
                                                    [destinStark exidForClientoid:clientoid],
                                                    [destinStark shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
                                        NSLog(@"%@", logEntry) ;
#endif
                                        [basis trace:logEntry] ;
                                        [logEntry release] ;
                                    }
                                }
                                [candidates2 release] ;
                            }
                            [candidates1 release] ;
                        }
                        [candidates release] ;
                        
                        destinStark = chosenCandidate ;
                        if (![destinStark exidForClientoid:clientoid]) {
                            [destinStark setExid:exid
                                    forClientoid:clientoid] ;
                        }
                        
                        if (traceLevel > 3) {
                            if (chosenCandidate) {
                                if (traceLevel > 3) {
                                    logEntry = [[NSString alloc] initWithFormat:@"33020      Found destin with same url:\n            source: %@\n            destin: %@\n       destinStark: %@\n",
                                                [sourceStark url],
                                                [destinStark url],
                                                [destinStark shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
                                    NSLog(@"%@", logEntry) ;
#endif
                                    [basis trace:logEntry] ;
                                    [logEntry release] ;
                                }
                            }
                        }
                    }
                }
                
                if (![self shouldIxportDueToIxportabilitySourceStark:sourceStark
                                                         destinStark:destinStark
                                                           clientoid:clientoid
                                                              extore:extore
                                          shouldDeleteUnmatchedItems:shouldDeleteUnmatchedItems
                                                          traceLevel:traceLevel
                                                               basis:basis]) {
                    [pool drain] ;
                    continue ;
                }
                
                if (![self shouldIxportDueToSeparatornessSourceStark:sourceStark
                                                         destinStark:destinStark
                                                           mergeBias:mergeBias
                                                          traceLevel:traceLevel
                                                               basis:basis]) {
                    [pool drain] ;
                    continue ;
                }
                
                if (destinStark) {
                    [self setMirroringInDestinStark:destinStark
                                         mergeBias:mergeBias
                                        sourceStark:sourceStark
                                         traceLevel:traceLevel];
                    
                    [self finishMatchingDestinStark_p:destinStark
                                              bkmxDoc:bkmxDoc
                                            clientoid:clientoid
                                     commonAttributes:commonAttributes
                                          countOfJobs:countOfJobs
                                doBookMacsterizerOnly:doBookMacsterizerOnly
                                    exportFeedbackDic:exportFeedbackDic
                                               extore:extore
                                           mergeBias:mergeBias
                                        mergeTagsParm:mergeTagsParm
                                               source:source
                                          sourceStark:sourceStark
                                           traceLevel:traceLevel] ;
                    
                    [matesKeyedByDestin setObject:sourceStark
                                           forKey:[NSValue valueWithPointer:destinStark]] ;
                    [matesKeyedBySource setObject:destinStark
                                           forKey:[NSValue valueWithPointer:sourceStark]] ;
                    [sourceStarksNotMatched removeObject:sourceStark];
                }
                
                [pool drain] ;
            
        }
        [progressView clearAll] ;
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;
    }
    
#pragma mark mergeFromStartainer:::  04.  Make New Items (for unmatched)  **********************
    if (traceLevel > 0) {
        logEntry = [[NSString alloc] initWithFormat:@"   04.  Make New Items (for unmatched)\n"] ;
#if LOG_TO_CONSOLE_TOO
        NSLog(@"%@", logEntry) ;
#endif
        [basis trace:logEntry] ;
        [logEntry release] ;
    }
    
    // Was [NSMutableSet set] prior to BookMacster 1.1.  Changed it to an array
    // to make Ixport results more deterministic.  See declaration of sourceStarks above.
    newDestinStarks = [[NSMutableArray alloc] init] ;
    
    verb = [NSString stringWithFormat:@"%@ : Creating new items (4/8)", displayNameGivingIndex] ;
    [progressView setIndeterminate:NO
                 withLocalizedVerb:verb
                          priority:SSYProgressPriorityRegular] ;
    [progressView setMaxValue:[sourceStarks count]] ;
    i = 0 ;
    [progressView setDoubleValue:i] ;
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;
    for (sourceStark in sourceStarksNotMatched) {
        if ([sourceStark isHartainer]) {
            continue;
        }
        if (![self shouldIxportDueToIxportabilitySourceStark:sourceStark
                                                 destinStark:nil
                                                   clientoid:clientoid
                                                      extore:extore
                                  shouldDeleteUnmatchedItems:shouldDeleteUnmatchedItems
                                                  traceLevel:traceLevel
                                                       basis:basis]) {
            continue;
        }
        if (![self shouldIxportDueToSeparatornessSourceStark:sourceStark
                                                 destinStark:nil
                                                  mergeBias:mergeBias
                                                  traceLevel:traceLevel
                                                       basis:basis]) {
            continue ;
        }
        destinStark = [self freshStarkInStarker:destinStarker
                                        sharype:sourceStark.sharypeValue];
        if ([sourceStark isHartainer]) {
            // Hartainers should have already been processed during the previous loop, Merge By ID
            NSLog(@"Warning 524-8384 %@", [sourceStark shortDescription]) ;
        }
        else {
            if (traceLevel > 3) {
                logEntry = [[NSString alloc] initWithFormat:@"33589:    Creating new stark for source exid: %@\n", [sourceStark exidForClientoid:[[self client] clientoid]]];
#if LOG_TO_CONSOLE_TOO
                NSLog(@"%@", logEntry) ;
#endif
                [basis trace:logEntry] ;
                [logEntry release] ;
            }
            
            [self finishMatchingDestinStark_p:destinStark
                                      bkmxDoc:bkmxDoc
                                    clientoid:clientoid
                             commonAttributes:commonAttributes
                                  countOfJobs:countOfJobs
                        doBookMacsterizerOnly:doBookMacsterizerOnly
                            exportFeedbackDic:exportFeedbackDic
                                       extore:extore
                                    mergeBias:mergeBias
                                mergeTagsParm:mergeTagsParm
                                       source:source
                                  sourceStark:sourceStark
                                   traceLevel:traceLevel];
            [matesKeyedByDestin setObject:sourceStark
                                   forKey:[NSValue valueWithPointer:destinStark]];
            [matesKeyedBySource setObject:destinStark
                                   forKey:[NSValue valueWithPointer:sourceStark]];
            [newDestinStarks addObject:destinStark];
        }
    }

    [progressView clearAll] ;
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;

    [destinStarks addObjectsFromArray:newDestinStarks] ;
    
    if (traceLevel > 3) {
        logEntry = [[NSString alloc] initWithFormat:@"10400: %ld newDestinStarks after Merge: %@\n", (long)[newDestinStarks count], [newDestinStarks shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
        NSLog(@"%@", logEntry) ;
#endif
        [basis trace:logEntry] ;
        [logEntry release] ;
    }
    
    if (traceLevel > 0) {
        logEntry = [[NSString alloc] initWithFormat:@"       %ld source and %ld destin starks after Merge\n", (long)[sourceStarks count], (long)[destinStarks count]] ;
#if LOG_TO_CONSOLE_TOO
        NSLog(@"%@", logEntry) ;
#endif
        [basis trace:logEntry] ;
        [logEntry release] ;
    }
    else if (traceLevel > 3) {
        logEntry = [[NSString alloc] initWithFormat:@"11400: destinStarks after Merge: %@\n", [destinStarks shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
        NSLog(@"%@", logEntry) ;
#endif
        [basis trace:logEntry] ;
        [logEntry release] ;
    }
    
    if (traceLevel > 3) {
        [self logMatesKeyedByDestin:matesKeyedByDestin
                              basis:basis];
    }
    
#pragma mark mergeFromStartainer:::  05.  Finding Parents  **********************
    
    /* This "Finding Parents" section does the following:
     for each destinStark
     *   If destinStark is already had by its correct parent, continue
     *   If destinStark is going to be deleted during this ixport, continue
     *   Let sourceStark = mate of destinStark
     *   If sourceStark is root, continue
     *   Let sourceParent be the parent of sourceStark
     *   Let correctParent be nil
     *   Let proposedNewParentSharype by SharypeUndefined
     *   If sourceParent exists and if destinStark should mirror source mate
     *      Let sourceParentPointerValue be an NSValue pointing to sourceParent
     *      Let correctParent = mate of source parent
     *         If correctParent is nil, let correctParent = default parent for destinStark
     *      Let proposedNewParentSharype be sharypeValue of correctParent
     *   Else if destinStark is currently parentless, is not itself root and is a new item for this client,
     *      Add destinStark to childrenTemp of destinRoot
     *      Mark destinStark as correct parent has me
     *      Let proposedNewParentSharype be SharypeRoot
     *   If destinStark is not itself root but correctParent is root,
     *      Let proposedNewParentSharype be SharypeRoot
     *   If proposedNewParentSharype has been changed from SharypeUndefined and destinStark cannot have a parent whose sharype is the value
     *      Let correctParent = destin stark's default parent
     *      Increase destinStark's sponsoredIndex by ORPHAN_OFFSET
     *   If correctParent is nil,
     *      continue
     *   Let currentParent be destinStark's parent
     *   Let needsCorrection = 0
     *   If currentParent's objectID is not equal to correctParent's objectID,
     *      Let needsCorrection = 1
     *   Else if destinStark's sponsoredIndex is not zero and destinStark's index is not equal to its sponsoredIndex
     *      Let needsCorrection = 2
     *   If needsCorrection > 0
     *      Add destinStark as a sponsored children object of correctParent, checking for correct MOC
     *      Set destinStark's correctParentHasMe to YES
     *      If currentParent is not nil
     *         Remove destinStark from childrenTemp of currentParent
     *      Else
     *         Remove destinStark from childrenTemp of destinRoot
     */
    if (traceLevel > 0) {
        logEntry = [[NSString alloc] initWithFormat:@"   05.  Finding Parents\n"] ;
#if LOG_TO_CONSOLE_TOO
        NSLog(@"%@", logEntry) ;
#endif
        [basis trace:logEntry] ;
        [logEntry release] ;
    }
    
    verb = [NSString stringWithFormat:@"%@ : Finding Parents (5/8)", displayNameGivingIndex] ;
    [progressView setIndeterminate:NO
                 withLocalizedVerb:verb
                          priority:SSYProgressPriorityRegular] ;
    [progressView setMaxValue:[destinStarks count]] ;
    i = 0 ;
    [progressView setDoubleValue:i] ;
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;
    Stark* destinRoot = [destinStarker hartainerOfSharype:SharypeRoot
                                                  quickly:YES] ;
    
    NSMutableDictionary* foldersMappedDuringPriorExportKeyedByTag = nil ;
    if ([self isAnImporter]) {
        foldersMappedDuringPriorExportKeyedByTag = [[NSMutableDictionary<NSString*, Stark*> alloc] init];
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
        // The self is an Importer We are interested in the tag maps of this
        // Importer's companion Exporter.  We get it via the common Client.
        NSSet* relevantTagMaps = [[[self client] exporter] tagMaps] ;
        for (TagMap* tagMap in relevantTagMaps) {
            Stark* mappedFolder = [self folderForTalderMap:tagMap
                                           starksKeyedById:nil  // Ignored when self isAnImporter
                                                   starker:[destin starker]] ;
            NSString* tag = [tagMap tag] ;
            if (mappedFolder && tag) {  // Defensive programming
                [foldersMappedDuringPriorExportKeyedByTag setObject:mappedFolder
                                                             forKey:tag] ;
            }
        }
        [pool release] ;
    }
    
    NSMutableSet* shouldExportDestinStarks = [[NSMutableSet alloc] init] ;
    NSMutableSet* shouldNotExportDestinStarks = [[NSMutableSet alloc] init] ;
    
    for (destinStark in destinStarks) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
        if (traceLevel > 3) {
            logEntry = [[NSString alloc] initWithFormat:@"   FindPar %ld/%ld destin %@\n", (long)i, (long)[destinStarks count], [destinStark shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
            NSLog(@"%@", logEntry) ;
#endif
            [basis trace:logEntry] ;
            [logEntry release] ;
        }
        i++ ;
        [progressView incrementAndRunDoubleValueBy:1] ;
        
        if ([destinStark correctParentHasMe]) {
            // This must be an ixport consisting of multiple sources, and this
            // destinStark is from a previous source.  Its correctParent has
            // already been assigned, so we just...
            if (traceLevel > 3) {
                logEntry = [[NSString alloc] initWithFormat:@"      correct parent already has: continuing\n"] ;
#if LOG_TO_CONSOLE_TOO
                NSLog(@"%@", logEntry) ;
#endif
                [basis trace:logEntry] ;
                [logEntry release] ;
            }
            [pool drain] ;
            continue ;
        }
        
        // Added in BookMacster 1.0.4.  If I recall correctly, this is an optimization, to avoid processing
        // items which are alreadly known to be deleted soon.  Should still work OK if omitted.  But this
        // optimization does help very much in some cases.
        if ([destinStark isDeletedThisIxport]) {
            if (traceLevel > 3) {
                logEntry = [[NSString alloc] initWithFormat:@"      has been deleted: continuing\n"] ;
#if LOG_TO_CONSOLE_TOO
                NSLog(@"%@", logEntry) ;
#endif
                [basis trace:logEntry] ;
                [logEntry release] ;
            }
            [pool drain] ;
            continue ;
        }
        
        // Added in BookMacster 1.11.3 so that importing from a flat
        // Import Client will not flatten a Collection
        if (![destinStark isNewItemThisClient]) {
            /*
             *  source      source                                   'continue;' so
             * hasOrder   hasFolders   isAtRoot   Example            it's not moved  Case
             *    0           0          0        Deli, Pinb, Digg,       1            1
             *    0           0          1        Deli, Pinb, Digg,       1            1
             *    0           1          0        no such client          0
             *    0           1          1        no such client          0
             *    1           0          0        none – was for Roccat   1            2
             *    1           0          1        none - was for Roccat   0
             *    1           1          0        Safari, FFox, Chr,      0
             *    1           1          1        Safari, FFox, Chr,      0
             */
            if (![source hasOrder]) {
                if (![source hasFolders]) {
                    // Case 1
                    if (traceLevel > 3) {
                        logEntry = [[NSString alloc] initWithFormat:@"      existing item, source has not order nor folders: continuing\n"] ;
#if LOG_TO_CONSOLE_TOO
                        NSLog(@"%@", logEntry) ;
#endif
                        [basis trace:logEntry] ;
                        [logEntry release] ;
                    }
                    [pool drain] ;
                    continue ;
                }
            }
            else {
                if (![source hasFolders] && [self isAnImporter]) {
                    if ([[destinStark parent] sharypeValue] != SharypeRoot) {
                        // Case 2
                        if (traceLevel > 3) {
                            logEntry = [[NSString alloc] initWithFormat:@"      existing item, source has order but not folders, and item not at root: continuing\n"] ;
#if LOG_TO_CONSOLE_TOO
                            NSLog(@"%@", logEntry) ;
#endif
                            [basis trace:logEntry] ;
                            [logEntry release] ;
                        }
                        [pool drain] ;
                        continue ;
                    }
                }
            }
        }
        
        /* This section added in BookMacster 1.10, to fix bug that:
         During Import operations from a single Client, items which are not
         exportable to this Client, and thus were not exported to it, and thus
         absent from the Import, would move to the top of their folder.  What
         would happen is that such items would be sponsored by destin, with
         sponsorIndex -1, which would cause them to be sorted to the bottom of
         root when sorted by the trio of sort descriptors in the Gulp-02
         section of -[Gulper gulpStartainer:info:error_p:], because
         sponsorIndex is first in the trio of sort descriptors, and the other
         exportable starks had the sponsorIndex of the client, which is > -1.
         
         HOW TO TEST THIS SECTION
         
         * Copy …Test/Data/BkmxDocs/UnexportedChurn.bkmxDoc to somewhere
         • Open the copy
         * BookMacster ▸ Stop all Syncing now.
         * Set Clients, in order: Safari, Firefox, Chrome
         * Make sure that all bookmarks are in name order, 00 thru 11
         * Export
         * Reverse order of first two bookmarks, so you have 01 All, then 00 All
         * Import (Safari, Firefox, Chrome)
         * Expected Result: No changes other than 00 All and 01 All moving back
         * Undo, to get the reversed order again.
         * One-Time Import ▸ Chrome ▸ Normal Import
         * Expected Result: No changes other than 00 All and 01 All moving back.
              Status bar should indicate only 2 slides.
         * Repeat the above three steps two more times, importing from Firefox and Safari instead.
         * Change the order of the Clients to one of the other 5/6 possible orderings
              and repeat those three steps again, importing all with File ▸ Import.
         * Repeat the above step with the 4 remaining Client orderings.
         */
        if ([self isAnImporter]) {
            if (![self shouldExportStark:destinStark
                           positiveCache:shouldExportDestinStarks
                           negativeCache:shouldNotExportDestinStarks
                                  extore:extore]) {
                // The following test was added in BookMacster 1.12.3, when
                // I found that, when importing from Safari and Roccat, in that
                // order, the hartainers are exportable to Safari, and
                // thus this code would *not* execute during the Safari import,
                // but they are not exportable to Roccat, and thus this code
                // *would* execute during the Roccat import, which would change
                // the sponsorIndex of the hartainers from nil to +1, which
                // which would cause them to be sorted to the bottom of root
                // when sorted by the trio of sort descriptors in the Gulp-02
                // section of -[Gulper gulpStartainer:info:error_p:], because
                // sponsorIndex is first in the trio of sort descriptors.
                if (![destinStark isHartainer]) {
                    if ([destinStark sponsorIndex] == nil) {
                        if (traceLevel > 3) {
                            logEntry = [[NSString alloc] initWithFormat:@"      Unexportable: Faking sponsor.\n"] ;
#if LOG_TO_CONSOLE_TOO
                            NSLog(@"%@", logEntry) ;
#endif
                            [basis trace:logEntry] ;
                            [logEntry release] ;
                        }
                        [destinStark setSponsorIndex:[NSNumber numberWithInteger:[self gappyIndexValue]]] ;
                        [destinStark setSponsoredIndex:[destinStark index]] ;
                        
                        // The following further refinement was added in BookMacster 1.11.
                        // Now we need to increment the sponsoredIndex of any exportable
                        // sibling of this destinStark, if it currently has a sponsoredIndex
                        // equal to or greater than the sponsoredIndex we just set.
                        NSArray* siblings = [[destinStark parent] childrenOrdered] ;
                        for (Stark* sibling in siblings) {
                            if ([self shouldExportStark:sibling
                                          positiveCache:shouldExportDestinStarks
                                          negativeCache:shouldNotExportDestinStarks
                                                 extore:extore]) {
                                NSNumber* sponsoredIndex = [sibling sponsoredIndex] ;
                                if (sponsoredIndex) {
                                    if ([[destinStark sponsoredIndex] compare:sponsoredIndex] != NSOrderedDescending) {
                                        sponsoredIndex = [sponsoredIndex plus1] ;
                                        [sibling setSponsoredIndex:sponsoredIndex] ;
                                    }
                                }
                                else {
                                    /* Prior to BookMacster 1.15.1, I logged
                                     Internal Error 855-9207 at this point.
                                     However, this branch is expected if the
                                     sibling does not exist in the source; that
                                     is, if it is going to be deleted later. */
                                }
                            }
                        }
                    }
                }
            }
        }
        
        sourceStark = [matesKeyedByDestin objectForKey:[NSValue valueWithPointer:destinStark]] ;
        if (traceLevel > 3) {
            logEntry = [[NSString alloc] initWithFormat:@"         mating sourceStark: %@\n", [sourceStark shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
            NSLog(@"%@", logEntry) ;
#endif
            [basis trace:logEntry] ;
            [logEntry release] ;
        }
        if ([sourceStark sharypeValue] == SharypeRoot) {
            // Root does not have a parent
            if (traceLevel > 3) {
                logEntry = [[NSString alloc] initWithFormat:@"         mating sourceStark is root: continuing\n"] ;
#if LOG_TO_CONSOLE_TOO
                NSLog(@"%@", logEntry) ;
#endif
                [basis trace:logEntry] ;
                [logEntry release] ;
            }
            [pool drain] ;
            continue ;
        }
        
        Stark* sourceParent = [sourceStark parent] ;
        
        /* In the following condition, excluding hartainers is done only
         for efficiency and to reduce noise during debugging. */
        if (![destinStark isNewItemThisIxport]  && ![destinStark isHartainer]) {
            BOOL mayHaveBeenMappedDuringAPriorExport = NO ;
            /* Consider moves which are apparent when importing from all Clients
             equally, and ignore any such move which could be accounted for
             as the result of an automatic mapping during a prior export.  There
             are three such cases of these automatic mappings.  All of them are
             rare…
             * Auto-mapping Case 1.  The current location in the Collection
             document is a hartainer which does not exist in the Client,
             and the moved-to folder is the foster parent of the item.
             * Auto-mapping Case 2.  The Client would not have allowed the item
             to have been exported to its current location in the Collection
             document, and the moved-to folder is the default parent
             of the item.
             * Auto-mapping Case 3.  The Client in which the move is apparent
             has a Tag Mapping whose target folder is the apparent moved-to
             folder, and whose tag is one of the item's tags.  */
            if ([self isAnImporter] && sourceParent) {
                // Variables which will be needed for Case 1 and Case 2 determinations
                Exporter* sourceExporter = [[(Importer*)source client] exporter];
                /* A freshly fetched exporter like that will not have an
                 an extore assigned.  So we must temporarily give it one. */
                sourceExporter.extore = self.extore;
                NSNumber* sourceFosterSharype = [[sourceExporter fosterParentForStark:destinStark] sharype];
                /* We are done with sourceExporter.  Remove its extore, as
                 defensive programming against retain cycles. */
                sourceExporter.extore = nil;
                NSNumber* sourceParentSharype = [sourceParent sharype];
                NSString* readableDefaultSharype = [StarkTyper readableSharype:[sourceFosterSharype sharypeValue]];
                BOOL movedToFolderIsTheDefaultParent = [sourceFosterSharype isEqualToNumber:sourceParentSharype];
                Stark* currentParent = [destinStark parent];
                Sharype currentParentSharypeValue = [currentParent sharypeValue];
                
                // Check for Auto-mapping Case 1
                
                if (![[[self extore] class] canHaveSharype:[currentParent sharypeValue]]) {
                    mayHaveBeenMappedDuringAPriorExport = movedToFolderIsTheDefaultParent;
                    
                    if (traceLevel > 3) {
                        if (mayHaveBeenMappedDuringAPriorExport) {
                            logEntry = [[NSString alloc] initWithFormat:
                                        @"      Whoa! mayHaveBeenMappedDuringAPriorExport-case1 (%@ does not have a %@ and default parent sharype=%@)\n",
                                        [[self extore] className],
                                        [StarkTyper readableSharype:currentParentSharypeValue],
                                        readableDefaultSharype] ;
#if LOG_TO_CONSOLE_TOO
                            NSLog(@"%@", logEntry) ;
#endif
                            [basis trace:logEntry] ;
                            [logEntry release] ;
                        }
                    }
                }
                
                // If we didn't find Auto-mapping Case 1, check for Case 2
                if (!mayHaveBeenMappedDuringAPriorExport) {
                    if (![[[self extore] class] parentSharype:currentParentSharypeValue
                                          canHaveChildSharype:[destinStark sharypeValue]]) {
                        mayHaveBeenMappedDuringAPriorExport = movedToFolderIsTheDefaultParent;
                        
                        if (traceLevel > 3) {
                            if (mayHaveBeenMappedDuringAPriorExport) {
                                logEntry = [[NSString alloc] initWithFormat:
                                            @"      Whoa! mayHaveBeenMappedDuringAPriorExport-case2 (default parent sharype=%@)\n",
                                            readableDefaultSharype] ;
#if LOG_TO_CONSOLE_TOO
                                NSLog(@"%@", logEntry) ;
#endif
                                [basis trace:logEntry] ;
                                [logEntry release] ;
                            }
                        }
                    }
                }
                
                // If we didn't find Auto-mapping Case 1 or 2, check for Case 3
                if ([foldersMappedDuringPriorExportKeyedByTag count] > 0) {
                    if (!mayHaveBeenMappedDuringAPriorExport) {
                        Stark* destinParent ;
                        if ([sourceParent sharypeCoarseValue] == SharypeCoarseHartainer) {
                            // Robustness and efficiency of the following code was
                            // mentally compared with pre-computing an index of
                            // hartainers in destinStarks outside of the outer loop,
                            // "for (destinStark in destinStarks) {", which we are now
                            // in.  The following was deemed to be the best choice.
                            for (Stark* stark in destinStarks) {
                                Sharype sharype = [sourceParent sharypeValue] ;
                                if ([stark sharypeValue] == sharype) {
                                    destinParent = stark ;
                                    break ;
                                }
                            }
                            if (!destinParent) {
                                NSLog(@"Internal Error 624-0236 %@", [sourceParent shortDescription]) ;
                            }
                        }
                        else {
                            id destinParentet = [destinStarketsKeyedByExid objectForKey:[sourceParent exid]] ;
                            if ([destinParentet isKindOfClass:[Stark class]]) {
                                destinParent = destinParentet ;
                            }
                            else {
                                destinParent = [sourceParent bestMatchFromSet:destinParentet] ;
                            }
                        }
                        
                        if (destinParent) {
                            for (NSString* tag in [destinStark tags]) {
                                Stark* tagMapTarget = [foldersMappedDuringPriorExportKeyedByTag objectForKey:tag] ;
                                if (tagMapTarget == destinParent){
                                    mayHaveBeenMappedDuringAPriorExport = YES ;
                                    if (traceLevel > 3) {
                                        if (mayHaveBeenMappedDuringAPriorExport) {
                                            logEntry = [[NSString alloc] initWithFormat:
                                                        @"      Whoa! mayHaveBeenMappedDuringAPriorExport-case3 (tag=%@ folder=%@)\n",
                                                        tag,
                                                        [destinParent name]] ;
#if LOG_TO_CONSOLE_TOO
                                            NSLog(@"%@", logEntry) ;
#endif
                                            [basis trace:logEntry] ;
                                            [logEntry release] ;
                                        }
                                    }
                                    break ;
                                }
                            }
                        }
                    }
                }
            }
            
            // Added in BookMacster 1.7.3, changed in BookMacster 1.17
            if (mayHaveBeenMappedDuringAPriorExport) {
                if (traceLevel > 3) {
                    logEntry = [[NSString alloc] initWithFormat:@"        ==> will *not* move this item, continuing\n"] ;
#if LOG_TO_CONSOLE_TOO
                    NSLog(@"%@", logEntry) ;
#endif
                    [basis trace:logEntry] ;
                    [logEntry release] ;
                }
                [pool drain] ;
                continue ;
            }
        }
        
        Stark* correctParent = nil ;
        Sharype proposedNewParentSharype = SharypeUndefined ;
        
        /*
         *** How to reproduce the "Location Oscillate" bug (which was fixed in 0.9.13)
         * Create a Collection using New Collection wizard, Usage Style 2, for Camino and Firefox, with Camino first.
         * Note that this gives the default Import Merging Keep settings of:
         *     Keep Client for Camino
         *     Keep BkmxDoc for Firefox
         * Create a soft folder named "My Folder" in the Bookmarks Bar.
         * Export
         * Export (Should be no changes on this second export.)
         * Launch Firefox
         * Move "My Folder" from Bar to Menu
         * Quit Firefox
         * In Bkmx, Import
         
         Expected Result: "My Folder" should stay in Bar, because that's where it is in Camino,
         where Merging Keep is set to Keep Client, and ignoring the location in Firefox,
         which is set to Keep BkmxDoc.  Also, there should be 0 changes.  Note: If you do this
         with OmniWeb instead of Firefox, then you will find 1 addition + 1 deletion because of
         the problem that OmniWeb identifiers are not unique across Bar and Menu; a new item
         must be created.
         
         Actual Result: Moves to Menu.  Import again and again.  Each time, it flips from Bar to Menu or vice versa.
         
         * Close the Collection, but don't save, if you want to modify and repeat the test.
         
         *** How to reproduce the "No Follow Source Moves" bug (which was fixed in 0.9.21)
         * Create a Collection using New Collection wizard, Usage Style 1, for Firefox.
         * Note that this gives the default Import Merging Keep settings of:
         *     Keep Client for Firefox
         * Create a soft folder named "My Folder" in the Bookmarks Bar.
         * Export
         * Launch Firefox
         * Move "My Folder" from Bar to Menu
         * Quit Firefox
         * In Bkmx, Import
         
         Expected Result: "My Folder" should move to Menu, as it is in Firefox
         
         Actual Result: Stays in Bar.
         
         * Close the Collection, but don't save, if you want to modify and repeat the test.
         
         */
        
        // Possibly assign a correctParent to source location.
        
        // * If the next line is:
        // if (sourceParent) {
        // Moves too much.  You get the "Location Oscillate" bug, described above.
        // This was the original design.
        
        // * If the next line is:
        // if (sourceParent && [destinStark isNewItemThisClient]) {
        // Moves too little.  You get the "No Follow Source Moves" bug, described above.
        // This was the design as of 0.9.13.
        
        // The correct next line moves not too little, not too much, avoiding both bugs
        // This is the design as of 0.9.21.
        if (sourceParent && [destinStark shouldMirrorSourceMate]) {
            NSValue* sourceParentPointerValue = [NSValue valueWithPointer:sourceParent] ;
            correctParent = [matesKeyedBySource objectForKey:sourceParentPointerValue] ;
            if (!correctParent) {
                // Added in BookMacster 1.2.8.  Later on down in this loop, !correctParent
                // will cause us to think that destinStark is a pre-existing item in the destin
                // which does not need to be touched, and we will 'continue ;'.
                // Still later, destinStark will be exported with a nil parent
                // (See comment "Or else, it is a parentlessDestinStark").  Of course,
                // that's not what we want.
                correctParent = [destin fosterParentForStark:destinStark] ;
                // There are at least two situations in which we arrive here.
                // 1.  doBookMacsterizerOnly is YES.
                // 2.  Exporting to a Client which does not support containers, such as the
                //     web apps, if destinStark is *in* a soft folder.  It will have a sourceParent,
                //     but that sourceParent will not have a mate in matesKeyedBySource because,
                //     in the Merge phase above, this parent soft folder it will have been deemed
                //     !exportable and the loop will have encountered a continue; statement
                //     before it was added to matesKeyedBySource.
                if (traceLevel > 3) {
                    logEntry = @"         correctParent is nil, using -fosterParentForStark:\n" ;
#if LOG_TO_CONSOLE_TOO
                    NSLog(@"%@", logEntry) ;
#endif
                    [basis trace:logEntry] ;
                }
            }
            if (traceLevel > 3) {
                logEntry = [[NSString alloc] initWithFormat:@"         reflected correctParent to %@\n", [correctParent shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
                NSLog(@"%@", logEntry) ;
#endif
                [basis trace:logEntry] ;
                [logEntry release] ;
            }
            proposedNewParentSharype = [correctParent sharypeValue] ;
        }
        else if (
                 // currently has no parent
                 ![destinStark parent]
                 &&
                 // is not itself root
                 ([destinStark sharypeValue] != SharypeRoot)
                 &&
                 [destinStark isNewItemThisClient]  // Note CanSwapSecs4&5-404
                 ) {
                     // This stark is headed for root.
                     [[destinRoot childrenTemp] addObject:destinStark] ;
                     // Mark this in case we are not the last ixport of
                     // a multiple-source ixport
                     [destinStark setCorrectParentHasMe:YES] ;  // Note CanSwapSecs4&5-302
                     proposedNewParentSharype = SharypeRoot ;
                     if (traceLevel > 3) {
                         logEntry = [[NSString alloc] initWithFormat:@"         added to root\n"] ;
#if LOG_TO_CONSOLE_TOO
                         NSLog(@"%@", logEntry) ;
#endif
                         [basis trace:logEntry] ;
                         [logEntry release] ;
                     }
                 }
        
        if ([destinStark sharypeValue] != SharypeRoot) {
            if ([correctParent isRoot]) {
                // The following if() is important to filter out starks that
                // are already in the destination.
                // This stark is headed for root directly.
                proposedNewParentSharype = SharypeRoot ;
                if (traceLevel > 3) {
                    logEntry = [[NSString alloc] initWithFormat:@"         will add to root\n"] ;
#if LOG_TO_CONSOLE_TOO
                    NSLog(@"%@", logEntry) ;
#endif
                    [basis trace:logEntry] ;
                    [logEntry release] ;
                }
            }
        }
        
        if (proposedNewParentSharype != SharypeUndefined) {
            // A new parent has been proposed.  Make sure it's allowed.
            if (![destin canHaveParentSharype:proposedNewParentSharype
                                        stark:destinStark]) {
                // It's not allowed!
                correctParent = [destin fosterParentForStark:destinStark] ;
                if (traceLevel > 3) {
                    logEntry = [[NSString alloc] initWithFormat:
                                @"         Can't go to %@, changed correctParent to %@\n",
                                [StarkTyper readableSharype:proposedNewParentSharype],
                                [correctParent shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
                    NSLog(@"%@", logEntry) ;
#endif
                    [basis trace:logEntry] ;
                    [logEntry release] ;
                }
                [destinStark setSponsoredIndex:[NSNumber numberWithInteger:([[destinStark sponsoredIndex] integerValue] + ORPHAN_OFFSET)]] ;  // Note CanSwapSecs4&5-310
            }
        }
        
        if (!correctParent) {
            if (traceLevel > 3) {
                logEntry = [[NSString alloc] initWithFormat:@"         was in destin, not matched, not deleted, current parent is correct; or is parentlessDestinStark: continuing\n"] ;
#if LOG_TO_CONSOLE_TOO
                NSLog(@"%@", logEntry) ;
#endif
                [basis trace:logEntry] ;
                [logEntry release] ;
            }
            // This is an item that was in the destination to begin with,
            // and not matched/sponsored during Merge, and not deleted
            // during Delete Unmatched Items, and its correctParent is its current
            // parent.
            // Or else, it is a parentlessDestinStark
            [pool drain] ;
            continue ;
        }
        
        Stark* currentParent = [destinStark parent] ;
        if (traceLevel > 3) {
            logEntry = [[NSString alloc] initWithFormat:@"         currentParent  = %@\n", [currentParent shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
            NSLog(@"%@", logEntry) ;
#endif
            [basis trace:logEntry] ;
            [logEntry release] ;
            logEntry = [[NSString alloc] initWithFormat:@"         correctParent  = %@\n", [correctParent shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
            NSLog(@"%@", logEntry) ;
#endif
            [basis trace:logEntry] ;
            [logEntry release] ;
            logEntry = [[NSString alloc] initWithFormat:@"         currentIndex   = %@\n", [destinStark index]] ;
#if LOG_TO_CONSOLE_TOO
            NSLog(@"%@", logEntry) ;
#endif
            [basis trace:logEntry] ;
            [logEntry release] ;
            logEntry = [[NSString alloc] initWithFormat:@"         sponsoredIndex = %@\n", [destinStark sponsoredIndex]] ;
#if LOG_TO_CONSOLE_TOO
            NSLog(@"%@", logEntry) ;
#endif
            [basis trace:logEntry] ;
            [logEntry release] ;
        }
        short needsCorrection = 0 ;
        if (![[currentParent objectID] isEqual:[correctParent objectID]]) {
            if (traceLevel > 3) {
                logEntry = [[NSString alloc] initWithFormat:@"            %@ needs parent correction due to parent\n", [destinStark name]] ;
#if LOG_TO_CONSOLE_TOO
                NSLog(@"%@", logEntry) ;
#endif
                [basis trace:logEntry] ;
                [logEntry release] ;
            }
            needsCorrection = 1 ;
        }
        else if ([destinStark sponsoredIndex]) {
            if (![[destinStark index] isEqual:[destinStark sponsoredIndex]]) {  // Note CanSwapSecs4&5-406
                if (traceLevel > 3) {
                    logEntry = [[NSString alloc] initWithFormat:@"            %@ needs parent correction due to index\n", [destinStark name]] ;
#if LOG_TO_CONSOLE_TOO
                    NSLog(@"%@", logEntry) ;
#endif
                    [basis trace:logEntry] ;
                    [logEntry release] ;
                }
                needsCorrection = 2 ;
            }
        }
        
        // different values of needsCorrection > 0 were used for troubleshooting
        // but are not used now.
        if (needsCorrection > 0) {
            [self markToMoveStark:destinStark
                    correctParent:correctParent
                sponsoredChildren:sponsoredChildrenDic
                       destinRoot:destinRoot];
        }
        
        [pool drain] ;
    }
    
    [shouldExportDestinStarks release] ;
    [shouldNotExportDestinStarks release] ;
    
    [foldersMappedDuringPriorExportKeyedByTag release] ;
    
#pragma mark mergeFromStartainer::::  06.  Move Items per Tag Mappings  **********************
    
    /*
     For each of this instance's tag maps, for each destin stark, if the stark's
     tags include the tag map's tag, move the stark to the tag map's folder.
     
     For example, all starks tagged "toRead" may be moved to the Reading List.
     */
    if ([[self tagMaps] count] > 0) {
        if (traceLevel > 0) {
            logEntry = [[NSString alloc] initWithFormat:@"   05.  Moving items for Tag Mappings\n"] ;
#if LOG_TO_CONSOLE_TOO
            NSLog(@"%@", logEntry) ;
#endif
            [basis trace:logEntry] ;
            [logEntry release] ;
        }
        
        verb = [NSString stringWithFormat:@"%@ : Moving items per tagMaps (6/8)", displayNameGivingIndex] ;
        [progressView setIndeterminate:YES
                     withLocalizedVerb:verb
                              priority:SSYProgressPriorityRegular] ;
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;
        NSDictionary* starksKeyedById ;
        if ([self isAnImporter]) {
            starksKeyedById = nil ;
        }
        else {
            starksKeyedById = [[source starker] starksKeyedByKey:constKeyStarkid] ;
        }
        /* Although it would be nice if TalderMap objects had a relation to
         Tag objects, they have strings instead because Tag objects are in the
         .bmco document store, and TalderMap objects are in the Settings store,
         so such a relation would be a cross-store relationship, not allowed in
         Core Data or probably any database thing. */
        for (TagMap* tagMap in [self tagMapsOrdered]) {
            NSString* tagString = [tagMap tag] ;
            Stark* moveToFolder = [self folderForTalderMap:tagMap
                                           starksKeyedById:starksKeyedById
                                                   starker:destinStarker] ;
            if ([self isAnExporter]) {
                moveToFolder = [matesKeyedBySource objectForKey:[NSValue valueWithPointer:moveToFolder]] ;
            }
            if (moveToFolder) {
                for (destinStark in destinStarks) {
                    Stark* sourceMateWithRelevantTags = [matesKeyedByDestin objectForKey:[NSValue valueWithPointer:destinStark]] ;
                    NSArray* tagStrings = [[sourceMateWithRelevantTags tags] valueForKey:constKeyString];
                    if (tagStrings.count > 0) {
                        NSInteger index = [tagStrings indexOfObject:tagString] ;
                        if (index != NSNotFound) {
                            if (traceLevel > 0) {
                                logEntry = [[NSString alloc] initWithFormat:@"    Marking '%@' into '%@'\n", [destinStark name], [moveToFolder name]] ;
#if LOG_TO_CONSOLE_TOO
                                NSLog(@"%@", logEntry) ;
#endif
                                [basis trace:logEntry] ;
                                [logEntry release] ;
                            }
                            [self markToMoveStark:destinStark
                                    correctParent:moveToFolder
                                sponsoredChildren:sponsoredChildrenDic
                                       destinRoot:destinRoot];
                        }
                    }
                }
            }
        }
        [progressView clearAll] ;
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;
    }
    
    
#pragma mark mergeFromStartainer::::  07.  Tag Items per Folder Mappings  **********************
    
    /*
     For each destin stark, if the stark's source parent's identifier matches
     an identifier in one of the receiver's folder maps, tag it with the tag of
     the relevant tag map.
     
     For example, if there is a folder map relating the Reading List to the tag
     "toRead", all bookmarks in the Reading List in the source will be tagged
     with "toRead".
     
     During exports, we do it in -[Ixporter mergeFromStartainer::::]-06, because
     we need to consider each item's parent as it is in the BkmxDoc, before any
     moves.  During exports, we do it in -[Gulper gulpStartainer:::]-09,
     because need to consider each item's parent *after* any moves, and also
     pick up any new items.
     */
    
    if ([[self folderMaps] count] > 0) {
        if (traceLevel > 0) {
            logEntry = [[NSString alloc] initWithFormat:@"   07.  Tagging items per Folder-to-Tag Mappings\n"] ;
#if LOG_TO_CONSOLE_TOO
            NSLog(@"%@", logEntry) ;
#endif
            [basis trace:logEntry] ;
            [logEntry release] ;
        }
        
        
        NSDictionary* starksKeyedById ;
        Starker* aStarker ;
        if ([self isAnImporter]) {
            starksKeyedById = nil ;   // matesKeyedByDestin
            aStarker = [destin starker] ;
        }
        else {
            starksKeyedById = [[source starker] starksKeyedByKey:constKeyStarkid] ;
            aStarker = [source starker] ;
        }
        
        NSMutableDictionary* tagsForParentIds = [[NSMutableDictionary alloc] init] ;
        for (FolderMap* folderMap in [self folderMapsOrdered]) {
            Stark* targetParent = [self folderForTalderMap:folderMap
                                           starksKeyedById:starksKeyedById
                                                   starker:aStarker] ;
            if (targetParent) {
                NSString* parentId = [targetParent starkid] ;
                [tagsForParentIds setObject:[folderMap tag]
                                     forKey:parentId] ;
            }
        }
        
        verb = [NSString stringWithFormat:@"%@ : Tagging items per folderMaps (7/8)", displayNameGivingIndex] ;
        [progressView setIndeterminate:NO
                     withLocalizedVerb:verb
                              priority:SSYProgressPriorityRegular] ;
        [progressView setMaxValue:[destinStarks count]] ;
        [progressView setDoubleValue:0] ;
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;
        Tagger* destinTagger = [destin tagger];
        for (destinStark in destinStarks) {
            if ([destinStark canHaveTags]) {
                [progressView incrementAndRunDoubleValueBy:1] ;
                Stark* bkmxDocParent ;
                if ([self isAnImporter]) {
                    // In the following three lines, we go around in a little
                    // circle.  You see we start in the destin, find a mate in the
                    // source, and then find the mate of that mate which is back
                    // in the destin.  However, this circle is necessary in order
                    // to behave as expected, tagging bookmarks which are in the
                    // source (client) folder reflected from the folder-mappend
                    // folder in the destin (bkmxDoc), for bookmarks that are either
                    // (a) new or (b) moved.
                    Stark* sourceMate = [matesKeyedByDestin objectForKey:[NSValue valueWithPointer:destinStark]] ;
                    Stark* sourceParent = [sourceMate parent] ;
                    bkmxDocParent = [matesKeyedBySource objectForKey:[NSValue valueWithPointer:sourceParent]] ;
                }
                else {
                    Stark* sourceMate = [matesKeyedByDestin objectForKey:[NSValue valueWithPointer:destinStark]] ;
                    bkmxDocParent = [sourceMate parent] ;
                }
                if (bkmxDocParent) {
                    NSString* parentId = [bkmxDocParent starkid] ;
                    NSString* tag = [tagsForParentIds objectForKey:parentId] ;
                    if (tag) {
                        [destinTagger addTagString:tag
                                                to:destinStark];
                    }
                }
            }
        }
        [tagsForParentIds release] ;
        [progressView clearAll] ;
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;
    }
    
    
#pragma mark mergeFromStartainer::::  08.  Summarize Merge **********************
    
    if (traceLevel > 0) {
        logEntry = [[NSString alloc] initWithFormat:@"   08.  Summarize Merge\n"] ;
#if LOG_TO_CONSOLE_TOO
        NSLog(@"%@", logEntry) ;
#endif
        [basis trace:logEntry] ;
        [logEntry release] ;
    }
    
    if (traceLevel > 3) {
        [self logMatesKeyedBySource:matesKeyedBySource
                              basis:basis] ;
    }
    
    if (traceLevel > 3) {
        logEntry = [[NSString alloc] initWithFormat:@"18200: Adding %ld standinHartainersWhichShouldBeExported to newDestinStarks: %@\n", (long)[standinHartainersWhichShouldBeExported count], [standinHartainersWhichShouldBeExported shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
        NSLog(@"%@", logEntry) ;
#endif
        [basis trace:logEntry] ;
        [logEntry release] ;
    }
    [newDestinStarks addObjectsFromArray:standinHartainersWhichShouldBeExported];
    
    /* Note that we could not have done this immediately upon creating the
     new stark, because it might not yet have had all of its attributes
     (url in particular, for Pinboard) that are necessary to pass the test
     shouldExportStark:withChange:.  Also, we needed to wait until
     any new destin starks which happened to be in one of the temporary
     hartainers in destinHartainers was moved to its final parent. */
    for (destinStark in newDestinStarks) {
        if (([self isAnExporter] && [extore shouldExportStark:destinStark
                                                   withChange:nil])
            ||
            [self isAnImporter]
            ) {
            [[bkmxDoc chaker] addStark:destinStark] ;
        }
    }
    
    
    verb = [NSString stringWithFormat:@"%@ : Summarizing Merge of %@ (8/8)", displayNameGivingIndex, what] ;
    [progressView setIndeterminate:YES
                 withLocalizedVerb:verb
                          priority:SSYProgressPriorityRegular] ;
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;
    for (destinStark in destinStarks) {
#if ONLY_PRIMARY_SOURCE_CAN_IMPORT_DELETIONS
        // Added in BookMacster 1.7.3
        if (![destinStark isNewItemThisClient] && !isPrimarySource) {
            // Leave as is
            if (traceLevel > 3) {
                logEntry = [[NSString alloc] initWithFormat:@"   Sponsored by source: %@\n", [destinStark shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
                NSLog(@"%@", logEntry) ;
#endif
                [basis trace:logEntry] ;
                [logEntry release] ;
            }
            [destinStark setSponsorIndex:[NSNumber numberWithInteger:SPONSORED_BY_DESTIN]] ;
            [destinStark setSponsoredIndex:[destinStark index]] ;
        }
#endif
        
        // Special treatment for separators…
        if ([destinStark sharypeValue] == SharypeSeparator) {
            if (traceLevel > 3) {
                logEntry = [[NSString alloc] initWithFormat:@"   special treatment if %hhd%hhd%hhd for: %@\n",
                            (BOOL)([destinStark sponsorIndex] == nil),
                            (BOOL)(mergeBias != BkmxMergeBiasKeepDestin),
                            (BOOL)[extore shouldExportStark:destinStark
                                                 withChange:nil],
                            [destinStark shortDescription]
                ] ;
#if LOG_TO_CONSOLE_TOO
                NSLog(@"%@", logEntry) ;
#endif
                [basis trace:logEntry] ;
                [logEntry release] ;
            }
            if ([destinStark sponsorIndex] == nil) {
                if (
                    (mergeBias != BkmxMergeBiasKeepDestin)
                    // I think the idea behind the next two && is that we want
                    // to mark this separator for deletion if (1) it will
                    // not be exported but (2) it would "normally" be exported
                    // because this exporter does accept separators
                    &&
                    [extore shouldExportStark:destinStark
                                   withChange:nil]
                    ) {
                        [destinStark setIsDeletedThisIxport] ;
                        if (traceLevel > 3) {
                            logEntry = [[NSString alloc] initWithFormat:@"         setIsDeleted: %@\n", [destinStark name]] ;
#if LOG_TO_CONSOLE_TOO
                            NSLog(@"%@", logEntry) ;
#endif
                            [basis trace:logEntry] ;
                            [logEntry release] ;
                        }
                    }
                else if (
                         ([[extore class] canEditSeparatorsInStyle:extore.ixportStyle] == YES)
                         ||
                         (indexOfThisJob == countOfJobs - 1)
                         ) {
                             /* The following is 1 of 2 changes in BookMacster 1.12.7 to fix
                              undesired movement of separators in corner case imports.
                              Prior to BookMacster 1.12.7, the above was simply "else {"
                              The qualification was added so that a separator would
                              not resort to being self-sponsored during an import from
                              a client which does not support separators, until this
                              was the last client.  Otherwise, its sponsorIndex -1 will
                              cause it to be moved to the top among its siblings. */
                             [destinStark setSponsorIndex:[NSNumber numberWithInteger:SPONSORED_BY_DESTIN]] ;
                             [destinStark setSponsoredIndex:[destinStark index]] ;
                             if (traceLevel > 3) {
                                 logEntry = [[NSString alloc] initWithFormat:@"   Self-sponsored: %@\n", [destinStark shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
                                 NSLog(@"%@", logEntry) ;
#endif
                                 [basis trace:logEntry] ;
                                 [logEntry release] ;
                             }
                         }
                else {
                    if (traceLevel > 3) {
                        logEntry = [[NSString alloc] initWithFormat:@"   Don't self-sponsor yet: %@\n", [destinStark shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
                        NSLog(@"%@", logEntry) ;
#endif
                        [basis trace:logEntry] ;
                        [logEntry release] ;
                    }
                }
            }
        }
    }
    [progressView clearAll] ;
    
end:
    
    [progressView setIndeterminate:YES
                 withLocalizedVerb:@"Clearing Temporary Flags for Client"
                          priority:SSYProgressPriorityRegular] ;
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;
    for (destinStark in destinStarks) {
        // Re-set transient attributes that we don't
        // want to affect any subsequent client, or ixport.
        [destinStark clearThisClientFlags] ;
    }
    [progressView clearAll] ;
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate date]] ;
    
    if ([self isAnExporter]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:SSYManagedObjectWillUpdateNotification
                                                      object:nil] ;
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:SSYManagedObjectDidUpdateNotification
                                                      object:nil] ;
        // Back in the beginning of this method, we setBkmxDoc: which
        // was needed by our observer method.  It is not needed any more.
        // It is a weak property.  The following may be defensive programming.
        // We don't want to be hanging on to it, in case it closes later.
        [self setBkmxDoc:nil] ;
    }
    
    if (traceLevel > 0) {
        logEntry = [[NSString alloc] initWithFormat:@"15000 destinStarks after %s:\n%@\n", __PRETTY_FUNCTION__, [destinStarks shortDescription]] ;
#if LOG_TO_CONSOLE_TOO
        NSLog(@"%@", logEntry) ;
#endif
        [basis trace:logEntry] ;
        [logEntry release] ;
        
        logEntry = [[NSString alloc] initWithFormat:@"-------> Ended %@ Merge for %@ <------\n\n", what, displayNameGivingIndex] ;
#if LOG_TO_CONSOLE_TOO
        NSLog(@"%@", logEntry) ;
#endif
        [basis trace:logEntry] ;
        [logEntry release] ;
    }
    
    [sourceExids release] ;
    [duplicatedExids release] ;
    [newDestinStarks release] ;
    [sourceStarksNotMatched release];
    [sourceStarksNotMatchedCopy release];
    [matesKeyedBySource release] ;
    [matesKeyedByDestin release] ;
    [destinStarketsKeyedByExid release] ;
    [standinHartainersWhichShouldBeExported release];
    
    return ok ;
}

- (Extore*)renewExtoreForJobSerial:(NSInteger)jobSerial
                           error_p:(NSError**)error_p {
    Extore* extore = [Extore extoreForIxporter:self
                                     clientoid:nil
                                     jobSerial:jobSerial
                                       error_p:(NSError**)error_p] ;
    [self setExtore:extore] ;
    
    return extore ;
}

- (void)importGroup:(NSString*)group
               info:(NSMutableDictionary*)info {
    BkmxDoc* bkmxDoc = [info objectForKey:constKeyDocument] ;
    if ([bkmxDoc isZombie]) {
        // Added in BookMacster 1.19.9
        [[BkmxBasis sharedBasis] logFormat:@"Aborting import cuz %@ is zombie", [bkmxDoc displayName]] ;
        return ;
    }
    
    if (!bkmxDoc) {
        // This could happen if we were invoked by an invocation or timer which was
        // created and then the bkmxDoc was closed.  Actually, this will fail
        // gracefully with code 21618 in mergeFromStartainer:toStartainer:info:,
        // but it's safer to just end it immediately...
        NSLog(@"Warning 295-0281.  No bkmxDoc, maybe stale invoc") ;
        return ;
    }
    
    NSDictionary* moreInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              self, constKeyIxporter,
                              bkmxDoc, constKeyDocument,
                              nil] ;
    [info addEntriesFromDictionary:moreInfo] ;
    if ([bkmxDoc isDocumentEdited]) {
        [info setObject:[NSNumber numberWithBool:YES]
                 forKey:constKeyDocumentWasDirty] ;
    }
    
    BOOL isLastClient = [self isLastActiveImporter] || ([[info objectForKey:constKeyDoOnlyImportersArray] lastObject] == self) ;
    
    if (isLastClient) {
        [info setObject:[NSNumber numberWithBool:YES]
                 forKey:constKeyIsLastIxporter] ;
    }
    
    NSMutableArray* selectorNames = [NSMutableArray array] ;
    [selectorNames addObject:@"renewExtore"] ;
    [selectorNames addObject:@"checkClientAvailability"] ;
    [selectorNames addObject:@"getIxportStyle"] ;
    [selectorNames addObject:@"prepareInfoForReading"] ;
    [selectorNames addObject:@"quillBrowser"] ;
    [selectorNames addObject:@"ensureFiles"] ;
    [selectorNames addObject:@"prepareBrowserForImport"] ;
    [selectorNames addObject:@"launchBrowserIfNeeded"];
    [selectorNames addObject:@"checkIfExternalChanged"] ;  // may SET constKeySkipImportNoChanges, based on file mod dates
    [selectorNames addObject:@"claimBaton"] ;              // noop if constKeySkipImportNoChanges
    [selectorNames addObject:@"readExternal"] ;            // noop if constKeySkipImportNoChanges
    [selectorNames addObject:@"checkImportHashIsDiff"] ;   // may SET constKeySkipImportNoChanges, based on hashes
    [selectorNames addObject:@"rememberImportHash"] ;      // noop if !constKeyDidReadExternal
    [selectorNames addObject:@"tweakImportForClient"] ;    // noop if constKeySkipImportNoChanges or !constKeyDidReadExternal
    [selectorNames addObject:@"mergeImport"] ;             // noop if constKeySkipImportNoChanges or !constKeyDidReadExternal
    [selectorNames addObject:@"saveExidsMoc"] ;
    [selectorNames addObject:@"timestampImported"];
    [selectorNames addObject:@"removeNeedsImportFlag"] ;
    [selectorNames addObject:@"cleanUpServer"] ;
    
    [[bkmxDoc operationQueue] queueGroup:group
                                   addon:NO
                           selectorNames:selectorNames
                                    info:info
                                   block:NO
                              doneThread:[NSThread mainThread]
                              doneTarget:bkmxDoc
                            doneSelector:@selector(finishGroupOfOperationsWithInfo:)
                            keepWithNext:YES] ;
}

- (void)exportGroup:(NSString*)group
               info:(NSMutableDictionary*)info {
    BkmxDoc* bkmxDoc = [info objectForKey:constKeyDocument] ;
    if ([bkmxDoc isZombie]) {
        // Added in BookMacster 1.19.9
        [[BkmxBasis sharedBasis] logFormat:@"Aborting export cuz %@ is zombie", [bkmxDoc displayName]] ;
        return ;
    }
    
    NSDictionary* moreInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              self, constKeyIxporter,
                              nil] ;
    [info addEntriesFromDictionary:moreInfo] ;
    
    NSMutableArray* selectorNames = [NSMutableArray arrayWithObjects:
                                     @"checkBreath",
                                     @"beginDebugTrace",
                                     @"waitForClientProfile",
                                     @"renewExtore",
                                     @"checkClientAvailability",
                                     @"getIxportStyle",
                                     @"prepareInfoForReading",
                                     @"quillBrowser",
                                     @"ensureFiles",
                                     @"prepareBrowserForExport1",
                                     @"launchBrowserIfNeeded",
                                     @"clearForIxport",
                                     @"claimBaton",
                                     @"readExternal",
                                     @"recordHartainersRead",
                                     @"checkImportHashIsSame",  // Verify no changes since the few seconds ago when we just imported, *if* we just imported (the latter as of BookMacster 1.9.6)
                                     @"checkExportHashIsDiff",
                                     @"rememberLastPreExportedHashPayload",
                                     @"tweakImportForClient",
                                     @"mergeExport",
                                     @"exportCheckStuffMidway",
                                     @"recordHartainersRemoved",
                                     @"rememberLastPreExportedHashChangeBit",
                                     @"tweakExportForClient", // Must do this before limitSafe, so that final tags are in place for Firefox before counting changes.  (Added in BookMacster 1.11)
                                     @"limitSafe",
                                     @"warnSlow",
                                     @"getIxportStyle",  // Added in BookMacster 1.11, in case Firefox or Chrome had been running when this operation was run for reading a few seconds ago, but has since been quit.
                                     @"restoreRssArticlesInsertAsChildStarks",  // SDTR
                                     @"doSpecialMappingBeforeExport",  // SDTR
                                     @"checkAggregateExids",  // SDTR
                                     @"feedbackPreWrite",  // SDTR.  Do after any new starks set from RSS Articles, Special Mapping, etc.
                                     @"syncLog",
                                     @"prepareInfoForWriting",
                                     @"quillBrowser",  // SDTR  // Moved in BookMacster 1.13.2.  Was: just after getIxportStyle
                                     @"prepareBrowserForExport2",  // Added in BookMacster 1.11
                                     @"writeAndDelete",  // SDTR DICF
                                     @"feedbackPostWrite",  // SDTR
                                     @"saveExidsMoc",  // SDTR
                                     @"persistLastPostExportedHash", // Will destroy the extore's transMOC if constKeyDebugIxportHashes = YES
                                     @"timestampExported",  // SDTR
                                     @"removeNeedsImportFlag",  // SDTR
                                     @"showCompletionExported", // SDTR
                                     @"pushToCloud", // SDTR
                                     @"showTestRunDiary",
                                     @"checkFight", // SDTR.  Also, we do this last so that the export will execute
                                     @"cleanUpServer",
                                     nil] ;
    
    // SDTR = skipped during a test run
    // DICF = If this method fails, shall delete the IxportLog which was produced by syncLog.
    
    if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
        [selectorNames insertObject:@"beginUndoGrouping"
                            atIndex:0] ;
    }
    
    if ([self isLastActiveExporter]) {
        // The following is probably longer used ??
        [info setObject:[NSNumber numberWithBool:YES]
                 forKey:constKeyIsLastIxporter] ;
    }
    
    /*  If we are running under AppleScript then tell operationQueue to block this thread.
     If we did not do this, either AppleScript would return to the scripter before
     all operations were complete. */
    [[bkmxDoc operationQueue] queueGroup:group
                                   addon:NO
                           selectorNames:selectorNames
                                    info:info
                                   block:NO
                              doneThread:[NSThread mainThread]
                              doneTarget:bkmxDoc
                            doneSelector:@selector(finishGroupOfOperationsWithInfo:)
                            keepWithNext:NO] ;
}

- (NSArray*)availableFabricateFolders {
    NSArray* a = [NSArray arrayWithObjects:
                  [NSNumber numberWithShort:BkmxFabricateFoldersOff],
                  [NSNumber numberWithShort:BkmxFabricateFoldersOne],
                  [NSNumber numberWithShort:BkmxFabricateFoldersAll],
                  nil] ;
    return a ;
}

- (NSArray*)availableHartainers {
    return [[[self client] extoreClass] availableHartainers] ;
}

- (NSString*)displayNameForHartainer:(NSNumber*)hartainer {
    Sharype sharypeValue = [hartainer shortValue] ;
    NSString* string ;
    
    switch (sharypeValue) {
        case SharypeRoot:
            string = [[BkmxBasis sharedBasis] labelRoot] ;
            break ;
        case SharypeBar:
            string = [[[self client] extoreClass] labelBar] ;
            break ;
        case SharypeMenu:
            string = [[[self client] extoreClass] labelMenu] ;
            break ;
        case SharypeUnfiled:
            string = [[[self client] extoreClass] labelUnfiled] ;
            break ;
        case SharypeOhared:
            string = [[[self client] extoreClass] labelOhared] ;
            break ;
        default:
            string = @"345-0091: See Console" ;
            NSLog(@"Internal Error 345-0091.  No display name for sharype %@", self) ;
    }
    
    return string ;
}


// Commented out in BookMacster version 1.3.10
//- (BOOL)deleteUnmatchedItemsValueRelevantToGui {
//    BOOL answer ;
//    if ([self isAnImporter]) {
//        if ([self jobIndexValueIsSingleIxporter:NO] == 0) {
//            answer = [[[[self client] macster] deleteUnmatchedMxtr] boolValue] ;
//        }
//        else {
//            answer = NO ;
//        }
//    }
//    else {
//        answer = [[self deleteUnmatched] boolValue] ;
//    }
//
//    return answer ;
//}

- (void)doMergeByBusinessLogic {
    Client* client_ = [self client] ;
    
    if ([self isAnExporter]) {
        // Defensive programming added in BookMacster version 1.3.15.  If a client
        // is still "Under Construction", its extoreClass will be nil.
        Class class = [client_ extoreClass] ;
        BOOL silentlyRemovesDuplicates ;
        if (class) {
            silentlyRemovesDuplicates = [class constants_p]->silentlyRemovesDuplicates ;
        }
        else {
            silentlyRemovesDuplicates = NO ;
        }
        
        if (silentlyRemovesDuplicates) {
            [self setMergeBy:[NSNumber numberWithInt:BkmxMergeByExidOrUrl]] ;
        }
    }
}

- (BOOL)canChangeMergeUrl {
    BOOL answer = YES ;
    
    // Commented out in BookMacster version 1.3.10
    //    if ([self deleteUnmatchedItemsValueRelevantToGui]) {
    //        //  If Delete Unmatched Items is on, destin items will be wiped out
    //        //  and you can't Merge By URL
    //        answer = NO ;
    //    }
    //    else
    if ([[self mergeBias] shortValue] == BkmxMergeBiasKeepBoth) {
        //  If both are being kept, no merging will be done
        answer = NO ;
    }
    else if ([self isAnExporter]) {
        // The following was screwed up in BookMacster verison 1.3.15
        // It was fixed in BookMacster version 1.3.19
        
        // Defensive programming added in BookMacster version 1.3.15.  If a client
        // is still "Under Construction", its extoreClass will be nil.
        Class extoreClass = [[self client] extoreClass] ;
        BOOL silentlyRemovesDuplicates = NO ;
        if (extoreClass) {
            silentlyRemovesDuplicates = [extoreClass constants_p]->silentlyRemovesDuplicates ;
        }
        
        if (silentlyRemovesDuplicates) {
            answer = NO ;
        }
    }
    
    return answer ;
}

+ (NSSet*)keyPathsForValuesAffectingCanChangeMergeUrl {
    return [NSSet setWithObjects:
            constKeyClient,
            constKeyDeleteUnmatched,
            constKeyMergeBias,
            @"client.macster.deleteUnmatchedMxtr",
            nil] ;
}

- (BOOL)canChangeMergeBias {
    BOOL answer = YES ;
    
    // Commented out in BookMacster version 1.3.10
    //    if ([self deleteUnmatchedItemsValueRelevantToGui]) {
    //        //  If Delete Unmatched Items is on, destin items will be wiped out
    //        //  and you can't Merge By URL
    //        answer = NO ;
    //    }
    
    return answer ;
}

+ (NSSet*)keyPathsForValuesAffectingCanChangeMergeBias {
    return [NSSet setWithObjects:
            constKeyDeleteUnmatched,
            @"client.macster.deleteUnmatchedMxtr",
            nil] ;
}

- (Starker*)starker {
    return [[self extore] starker] ;
}

- (Tagger *)tagger {
    return [[self extore] tagger] ;
}

- (BOOL)hasOrder {
    // If a client is still "Under Construction", its extoreClass will be nil.
    Class class = [[self client] extoreClass] ;
    BOOL answer ;
    if (class) {
        answer = [class constants_p]->hasOrder ;
    }
    else {
        answer = NO ;
    }
    
    return answer ;
}

- (BOOL)hasFolders {
    // If a client is still "Under Construction", its extoreClass will be nil.
    Class class = [[self client] extoreClass] ;
    BOOL answer ;
    if (class) {
        answer = [class constants_p]->hasFolders ;
    }
    else {
        answer = NO ;
    }
    
    return answer ;
}

- (BOOL)canPublicize {
    // Defensive programming added in BookMacster version 1.3.15.  If a client
    // is still "Under Construction", its extoreClass will be nil.
    Class class = [[self client] extoreClass] ;
    BOOL answer ;
    if (class) {
        answer = [class constants_p]->canPublicize ;
    }
    else {
        answer = NO ;
    }
    
    return answer ;
}

- (BOOL)hasBar {
    return [[self extore] hasBar] ;
}

- (BOOL)hasMenu {
    return [[self extore] hasMenu] ;
}

- (BOOL)hasUnfiled {
    return [[self extore] hasUnfiled] ;
}

- (BOOL)hasOhared {
    return [[self extore] hasOhared] ;
}

- (BOOL)canEditAttribute:(NSString*)key
                 inStyle:(BkmxIxportStyle)style {
    NSArray* editableAttributes = [[[self client] extoreClass] editableAttributesInStyle:style] ;
    BOOL answer = ([editableAttributes indexOfObject:key] != NSNotFound) ;
    return answer ;
}

- (Stark*)starkFromExtoreNode:(NSDictionary*)item {
    return [[self extore] starkFromExtoreNode:item] ;
}

- (BOOL)rootSoftainersOk {
    return [[self extore] rootSoftainersOk] ;
}

- (BOOL)rootLeavesOk {
    return [[self extore] rootLeavesOk] ;
}

- (BOOL)rootNotchesOk {
    return [[self extore] rootNotchesOk] ;
}

- (BOOL)canHaveParentSharype:(Sharype)sharype
                       stark:(Stark*)stark {
    return [[self extore] canHaveParentSharype:(Sharype)sharype
                                         stark:stark] ;
}

- (void)releaseExtore {
    /* For a time, I did [self.extore tearDown] in here, and this method was
     named -tearDownAndReleaseExtore, until I found a case wherein extore was
     already nil, but there still was an associated extore, and therefore it
     did not get torn down as expected. */
    [self setExtore:nil] ;
}

- (NSString*)longDisplayName {
    return [[self client] longDisplayName] ;
}

- (uint32_t)settingsHash {
    NSMutableArray* hashableValues = [[NSMutableArray alloc] init] ;
    id aValue ;
    
    for (NSString* key in [Ixporter hashableKeyPaths]) {
        aValue = [self valueForKeyPath:key] ;
        
        if (aValue) {
            [hashableValues addObject:aValue] ;
        }
    }
    
    uint32_t hash = [hashableValues hashBetter32] ;
    [hashableValues release] ;
    
    return hash ;
}


@end
