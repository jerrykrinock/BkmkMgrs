#import "BkmxDoc.h"
#import "Bookshig.h"
#import "Starker.h"
#import "BkmxDocWinCon.h"
#import "BkmxBasis+Strings.h"
#import "NSNumber+CharacterDisplay.h"
#import "MAKVONotificationCenter.h"
#import "NSString+LocalizeSSY.h"
#import "SSYProgressView.h"
#import "NSNumber+Sharype.h"
#import "NSInvocation+Quick.h"
#import "NSObject+MoreDescriptions.h"
#import "SSYDooDooUndoManager.h"
#import "Importer.h"
#import "Extore.h"
#import "Macster.h"
#import "Stark+Sorting.h"
#import "Client.h"
#import "ExtoreSafari.h"
#import "ExtoreFirefox.h"
#import "ExtoreChrome.h"
#import "BkmxAppDel.h"

// Debugging

// Properties
NSString* const constKeyDefaultSortable = @"defaultSortable" ;
NSString* const constKeyFilterIgnoredPrefixes = @"filterIgnoredPrefixes" ;
NSString* const constKeyIgnoreDisparateDupes = @"ignoreDisparateDupes" ;
NSString* const constKeyImportCount = @"importCount" ;
NSString* const constKeyIxportDoneDummyForKVO = @"ixportDoneDummyForKVO" ;
NSString* const constKeyLastDupesDone = @"lastDupesDone" ;
NSString* const constKeyLastDupesMaybeLess = @"lastDupesMaybeLess" ;
NSString* const constKeyLastDupesMaybeMore = @"lastDupesMaybeMore" ;
NSString* const constKeyLastSortDone = @"lastSortDone" ;
NSString* const constKeyLastSortMaybeNot = @"lastSortMaybeNot" ;
NSString* const constKeyLastTouched = @"lastTouched" ;
NSString* const constKeyLastVerifyDone = @"lastVerifyDone" ;
NSString* const constKeyLastVerifyMaybeNot = @"lastVerifyMaybeNot" ;
NSString* const constKeyLanding = @"landing" ;
NSString* const constKeyNotes = @"notes" ;
NSString* const constKeyRootLeavesOk = @"rootLeavesOk" ;
NSString* const constKeyRootNotchesOk = @"rootNotchesOk" ;
NSString* const constKeyRootSoftainersOk = @"rootSoftainersOk" ;
NSString* const constKeyRootSortable = @"rootSortable" ;
NSString* const constKeySortBy = @"sortBy" ;
NSString* const constKeySortingSegmentation = @"sortingSegmentation" ;
NSString* const constKeyTagDelimiter = @"tagDelimiter" ;



// Notification Names
NSString* const constNoteDupesDone = @"dupes" ;
NSString* const constNoteDupesMaybeMore = @"dupesMore" ;
NSString* const constNoteSortDone = @"sort" ;
NSString* const constNoteSortMaybeNot = @"sortNot" ;
NSString* const constNoteVerifyDone = @"verify" ;
NSString* const constNoteVerifyMaybeNot = @"verifyNot" ;


NSString* const constKeyCommands = @"commands" ;

enum BkmxStructureBit_enum 
{
	BkmxStructureBitHasBar,
	BkmxStructureBitHasMenu,
	BkmxStructureBitHasUnfiled,
	BkmxStructureBitHasOhared,
	BkmxStructureBitRootHartainersOk,
	BkmxStructureBitRootSoftainersOk,
	BkmxStructureBitRootLeavesOk,
	BkmxStructureBitRootNotchesOk
} ;
typedef enum BkmxStructureBit_enum BkmxStructureBit ;


@interface Bookshig ()

@end


@interface Bookshig (CoreDataGeneratedPrimitiveAccessors)

- (id)primitiveDefaultSortable ;
- (void)setPrimitiveDefaultSortable:(id)value ;
- (id)primitiveFilterIgnoredPrefixes ;
- (void)setPrimitiveFilterIgnoredPrefixes:(id)value ;
- (id)primitiveIgnoreDisparateDupes ;
- (void)setPrimitiveIgnoreDisparateDupes:(id)value ;
- (id)primitiveLastDupesDone ;
- (void)setPrimitiveLastDupesDone:(id)value ;
- (id)primitiveLastDupesMaybeLess ;
- (void)setPrimitiveLastDupesMaybeLess:(id)value ;
- (id)primitiveLastDupesMaybeMore ;
- (void)setPrimitiveLastDupesMaybeMore:(id)value ;
- (id)primitiveLastSortDone ;
- (void)setPrimitiveLastSortDone:(id)value ;
- (id)primitiveLastSortMaybeNot ;
- (void)setPrimitiveLastSortMaybeNot:(id)value ;
- (id)primitiveLastTouched ;
- (void)setPrimitiveLastTouched:(id)value ;
- (id)primitiveLastVerifyDone ;
- (void)setPrimitiveLastVerifyDone:(id)value ;
- (id)primitiveLastVerifyMaybeNot ;
- (void)setPrimitiveLastVerifyMaybeNot:(id)value ;
- (id)primitiveLanding ;
- (void)setPrimitiveLanding:(id)value ;
- (id)primitiveNotes ;
- (void)setPrimitiveNotes:(id)value ;
- (id)primitiveRootLeavesOk ;
- (void)setPrimitiveRootLeavesOk:(id)value ;
- (id)primitiveRootNotchesOk ;
- (void)setPrimitiveRootNotchesOk:(id)value ;
- (id)primitiveRootSoftainersOk ;
- (void)setPrimitiveRootSoftainersOk:(id)value ;
- (id)primitiveRootSortable ;
- (void)setPrimitiveRootSortable:(id)value ;
- (id)primitiveSortBy ;
- (void)setPrimitiveSortBy:(id)value ;
- (id)primitiveSortingSegmentation ;
- (void)setPrimitiveSortingSegmentation:(id)value ;
- (id)primitiveTagDelimiter ;
- (void)setPrimitiveTagDelimiter:(id)value ;
- (id)primitiveUuid ;
- (id)visitor ;
- (void)setPrimitiveVisitor:(id)value ;

- (void)setPrimitiveImportCount:(id)value ;

@end


@implementation Bookshig

#pragma mark * Accessors for non-managed object properties

@synthesize ixportDoneDummyForKVO = m_ixportDoneDummyForKVO ;
@synthesize userIsFussingWithClients = m_userIsFussingWithClients ;

#pragma mark * Core Data Generated Accessors for managed object properties

// Attributes

@dynamic defaultSortable ;
@dynamic filterIgnoredPrefixes ;
@dynamic ignoreDisparateDupes ;
@dynamic importCount ;
@dynamic rootSortable ;
@dynamic lastDupesDone ;
@dynamic lastDupesMaybeLess ;
@dynamic lastDupesMaybeMore ;
@dynamic lastSortDone ;
@dynamic lastSortMaybeNot ;
@dynamic lastTouched ;
@dynamic lastVerifyDone ;
@dynamic lastVerifyMaybeNot ;
@dynamic notes ;
@dynamic rootLeavesOk ;
@dynamic rootSoftainersOk ;
@dynamic rootNotchesOk ;
@dynamic sortBy ;
@dynamic sortingSegmentation ;
@dynamic tagDelimiter ;
@dynamic uuid ;
@dynamic visitor ;

// Relationships


#pragma mark * Custom Accessors

- (Macster*)macster {
	return [[self owner] macster] ;
}



+ (NSSet*)keyPathsForValuesAffectingSafeLimitImportEff {
	return [NSSet setWithObjects:
			constKeySafeLimitImport,
			// The following screwball path causes a crash when the new document is opened
			// after a 'Save As' operation.
			//	[NSString stringWithFormat:@"%@.%@", @"macster", constKeyClientsDummyForKVO],
			/* Here's the crash:
			 2010-07-29 05:30:11.409 BookMacster[7529:80f] Exception detected while handling key input.
			 2010-07-29 05:30:11.447 BookMacster[7529:80f] <_NSModelObservingTracker: 0x14e69650>: An -observeValueForKeyPath:ofObject:change:context: message was received but not handled.
			 Key path: clientsDummyForKVO
			 Observed object: <Macster: 0x11c53b0> (entity: Macster_entity; id: 0x11bb410 <x-coredata://585B2084-1283-4EB0-BC3C-8689BA744EFA/Macster_entity/p46>)
			 Change: {
			    kind = 1;
				notificationIsPrior = 1;
			    originalObservable = <Bookshig: from_closed_bkmxDoc> (entity: Bookshig_entity; id: 0x14d285d0 <x-coredata://B3386B1B-B3BB-40D8-BFA2-CD66D4A7588F/Bookshig_entity/p1>)}
			 Context: 0x14e69550 */
			 constKeyIxportDoneDummyForKVO,  
			nil] ;
}

- (void)setDefaultSortable:(NSNumber*)value {
	[self postWillSetNewValue:value
					   forKey:constKeyDefaultSortable] ;
	
    [self willChangeValueForKey:constKeyDefaultSortable] ;
    [self setPrimitiveDefaultSortable:value];
    [self didChangeValueForKey:constKeyDefaultSortable] ;
}

- (void)setFilterIgnoredPrefixes:(NSNumber*)value {
	[self postWillSetNewValue:value
					   forKey:constKeyFilterIgnoredPrefixes] ;
	
    [self willChangeValueForKey:constKeyFilterIgnoredPrefixes] ;
    [self setPrimitiveFilterIgnoredPrefixes:value];
    [self didChangeValueForKey:constKeyFilterIgnoredPrefixes] ;
}

- (BOOL)canFilterIgnoredPrefixes {
	return ([self sortByValue] == BkmxSortByName) ;
}

+ (NSSet*)keyPathsForValuesAffectingCanFilterIgnoredPrefixes {
	return [NSSet setWithObjects:
			constKeySortBy,
			nil] ;
}

- (void)setIgnoreDisparateDupes:(NSNumber*)value {
	[self postWillSetNewValue:value
					   forKey:constKeyIgnoreDisparateDupes] ;
	
    [self willChangeValueForKey:constKeyIgnoreDisparateDupes] ;
    [self setPrimitiveIgnoreDisparateDupes:value];
    [self didChangeValueForKey:constKeyIgnoreDisparateDupes] ;
}

- (void)setLastDupesDone:(NSDate*)value {
    [self postWillSetNewValue:value
                       forKey:constKeyLastDupesDone] ;
    
    [self willChangeValueForKey:constKeyLastDupesDone] ;
    [self setPrimitiveLastDupesDone:value];
    [self didChangeValueForKey:constKeyLastDupesDone] ;
}

- (void)setLastDupesMaybeLess:(NSDate*)value {
	[self postWillSetNewValue:value
					   forKey:constKeyLastDupesMaybeLess] ;
	
    [self willChangeValueForKey:constKeyLastDupesMaybeLess] ;
    [self setPrimitiveLastDupesMaybeLess:value];
    [self didChangeValueForKey:constKeyLastDupesMaybeLess] ;
}

- (void)setLastDupesMaybeMore:(NSDate*)value {
	[self postWillSetNewValue:value
					   forKey:constKeyLastDupesMaybeMore] ;
	
    [self willChangeValueForKey:constKeyLastDupesMaybeMore] ;
    [self setPrimitiveLastDupesMaybeMore:value];
    [self didChangeValueForKey:constKeyLastDupesMaybeMore] ;
}

- (void)setLastSortDone:(NSDate*)value {
	[self postWillSetNewValue:value
					   forKey:constKeyLastSortDone] ;
	
    [self willChangeValueForKey:constKeyLastSortDone] ;
    [self setPrimitiveLastSortDone:value];
    [self didChangeValueForKey:constKeyLastSortDone] ;
}

- (void)setLastSortMaybeNot:(NSDate*)value {
	[self postWillSetNewValue:value
					   forKey:constKeyLastSortMaybeNot] ;
	
    [self willChangeValueForKey:constKeyLastSortMaybeNot] ;
    [self setPrimitiveLastSortMaybeNot:value];
    [self didChangeValueForKey:constKeyLastSortMaybeNot] ;
}

- (void)setLastTouched:(NSDate*)value {
	[self postWillSetNewValue:value
					   forKey:constKeyLastTouched] ;
	
    [self willChangeValueForKey:constKeyLastTouched] ;
    [self setPrimitiveLastTouched:value];
    [self didChangeValueForKey:constKeyLastTouched] ;
}

- (void)setLastVerifyDone:(NSDate*)value {
	[self postWillSetNewValue:value
					   forKey:constKeyLastVerifyDone] ;
	
    [self willChangeValueForKey:constKeyLastVerifyDone] ;
    [self setPrimitiveLastVerifyDone:value] ;
    [self didChangeValueForKey:constKeyLastVerifyDone] ;
	
	[[self owner] showVerifyResults] ;
}

- (void)setLastVerifyMaybeNot:(NSDate*)value {
	[self postWillSetNewValue:value
					   forKey:constKeyLastVerifyMaybeNot] ;
	
    [self willChangeValueForKey:constKeyLastVerifyMaybeNot] ;
    [self setPrimitiveLastVerifyMaybeNot:value];
    [self didChangeValueForKey:constKeyLastVerifyMaybeNot] ;
    
    [[self owner] updateVerifyResultsIfAnyAreShowing] ;
}

- (void)setLanding:(Stark*)value {
	[self postWillSetNewValue:value
					   forKey:constKeyLanding] ;
	
    [self willChangeValueForKey:constKeyLanding] ;
    [self setPrimitiveLanding:value];
    [self didChangeValueForKey:constKeyLanding] ;
}

- (Stark *)landing {
    Stark* landing ;
    
    [self willAccessValueForKey:constKeyLanding];
    landing = [self primitiveLanding];
    [self didAccessValueForKey:constKeyLanding];
    
	if (
		!landing
		||
		([landing isRoot] && ![[self rootLeavesOk] boolValue])
		) {
		landing = [(BkmxDoc*)[self owner] fosterParentForSharype:SharypeBookmark] ;
        // Starting with BookMacster 1.19.7, the above cannot return nil
	}

    return landing ;
}

- (void)setNewBookmarkLandingFromMenuItem:(NSMenuItem*)sender {
	Stark* stark = [sender representedObject] ;
	[self setLanding:stark] ;
}

- (void)setNotes:(NSString*)value {
	[self postWillSetNewValue:value
					   forKey:constKeyNotes] ;
	
    [self willChangeValueForKey:constKeyNotes] ;
    [self setPrimitiveNotes:value];
    [self didChangeValueForKey:constKeyNotes] ;
}

- (void)setRootLeavesOk:(NSNumber*)value {
	[self postWillSetNewValue:value
					   forKey:constKeyRootLeavesOk] ;
	
    [self willChangeValueForKey:constKeyRootLeavesOk] ;
    [self setPrimitiveRootLeavesOk:value];
    [self didChangeValueForKey:constKeyRootLeavesOk] ;
}

- (void)setRootNotchesOk:(NSNumber*)value {
	[self postWillSetNewValue:value
					   forKey:constKeyRootNotchesOk] ;
	
    [self willChangeValueForKey:constKeyRootNotchesOk] ;
    [self setPrimitiveRootNotchesOk:value];
    [self didChangeValueForKey:constKeyRootNotchesOk] ;
}

- (void)setRootSoftainersOk:(NSNumber*)value {
	[self postWillSetNewValue:value
					   forKey:constKeyRootSoftainersOk] ;
	
    [self willChangeValueForKey:constKeyRootSoftainersOk] ;
    [self setPrimitiveRootSoftainersOk:value];
    [self didChangeValueForKey:constKeyRootSoftainersOk] ;
}

- (void)setRootSortable:(NSNumber*)value {
	[self postWillSetNewValue:value
					   forKey:constKeyRootSortable] ;
	
    [self willChangeValueForKey:constKeyRootSortable] ;
    [self setPrimitiveRootSortable:value];
    [self didChangeValueForKey:constKeyRootSortable] ;
}

- (void)setSortBy:(NSNumber*)value {
	[self postWillSetNewValue:value
					   forKey:constKeySortBy] ;
	
    [self willChangeValueForKey:constKeySortBy] ;
    [self setPrimitiveSortBy:value];
    [self didChangeValueForKey:constKeySortBy] ;
}

- (void)setSortingSegmentation:(NSNumber*)value {
	[self postWillSetNewValue:value
					   forKey:constKeySortingSegmentation] ;
	
    [self willChangeValueForKey:constKeySortingSegmentation] ;
    [self setPrimitiveSortingSegmentation:value];
    [self didChangeValueForKey:constKeySortingSegmentation] ;
}

- (void)setSegmentConfiguration:(NSInteger)segmentConfiguration {
    if (segmentConfiguration == 0) {
        self.sortWhichSegments = 0;
    }
    [self updateSortingSegmentationFromSegmentConfiguration:segmentConfiguration
                                          sortWhichSegments:self.sortWhichSegments];
}

- (void)setSortWhichSegments:(NSInteger)sortWhichSegments {
    [self updateSortingSegmentationFromSegmentConfiguration:self.segmentConfiguration
                                          sortWhichSegments:sortWhichSegments];
}

- (void)updateSortingSegmentationFromSegmentConfiguration:(NSInteger)segmentConfiguration
                                        sortWhichSegments:(NSInteger)sortWhichSegments {
    BkmxSortingSegmentation value;
    switch (sortWhichSegments) {
        case 0:  // sort both segments
            switch (segmentConfiguration) {
                case 0:  // mixed folders and bookmarks
                    value = BkmxSortingSegmentationMixAndSortAll;
                    break;
                case 1:  // folders above bookmarks
                    value = BkmxSortingSegmentationFoldersAtTopSortingBoth;
                    break;
                case 2:  // bookmarks above folders
                    value = BkmxSortingSegmentationFoldersAtBottomSortingBoth;
                    break;
                default:
                    value = BkmxSortingSegmentationDontKnow;
                    NSAssert(NO, @"Internal Error 327-2832");

            }
            break;
        case 1:  // sort folders segment only
            switch (segmentConfiguration) {
                case 0:  // mixed folders and bookmarks
                    value = BkmxSortingSegmentationIllegalValue;
                    break;
                case 1:  // folders above bookmarks
                    value = BkmxSortingSegmentationFoldersAtTopSortingFoldersOnly;
                    break;
                case 2:  // bookmarks above folders
                    value = BkmxSortingSegmentationFoldersAtBottomSortingFoldersOnly;
                    break;
                default:
                    value = BkmxSortingSegmentationDontKnow;
                    NSAssert(NO, @"Internal Error 327-2833");
            }
            break;
        case 2:  // sort bookmarks segment only
            switch (segmentConfiguration) {
                case 0:  // mixed folders and bookmarks
                    value = BkmxSortingSegmentationIllegalValue;
                    break;
                case 1:  // folders above bookmarks
                    value = BkmxSortingSegmentationFoldersAtTopSortingBookmarksOnly;
                    break;
                case 2:  // bookmarks above folders
                    value = BkmxSortingSegmentationFoldersAtBottomSortingBookmarksOnly;
                    break;
                default:
                    value = BkmxSortingSegmentationDontKnow;
                    NSAssert(NO, @"Internal Error 327-2834");
            }
            break;
        default:
            value = BkmxSortingSegmentationDontKnow;
            NSAssert(NO, @"Internal Error 327-2835");
            break;
    }

    NSAssert(value != BkmxSortingSegmentationIllegalValue, @"Internal Error 327-2836");
    [self setSortingSegmentation:[NSNumber numberWithInt:value]];
}

- (NSInteger)segmentConfiguration {
    NSInteger segmentConfiguration;
    switch (self.sortingSegmentation.integerValue) {
        case BkmxSortingSegmentationMixAndSortAll:
            segmentConfiguration = 0;
            break;
        case BkmxSortingSegmentationFoldersAtTopSortingBoth:
            segmentConfiguration = 1;
            break;
        case BkmxSortingSegmentationFoldersAtBottomSortingBoth:
            segmentConfiguration = 2;
            break;
        case BkmxSortingSegmentationFoldersAtTopSortingFoldersOnly:
            segmentConfiguration = 1;
            break;
        case BkmxSortingSegmentationFoldersAtBottomSortingFoldersOnly:
            segmentConfiguration = 2;
            break;
        case BkmxSortingSegmentationFoldersAtTopSortingBookmarksOnly:
            segmentConfiguration = 1;
            break;
        case BkmxSortingSegmentationFoldersAtBottomSortingBookmarksOnly:
            segmentConfiguration = 2;
            break;
        case BkmxSortingSegmentationIllegalValue:
            NSAssert(NO, @"Internal Error 327-2847");
            segmentConfiguration = 0;
            break;
        case BkmxSortingSegmentationDontKnow:
            NSAssert(NO, @"Internal Error 327-2848");
            segmentConfiguration = 0;
            break;
        default:
            NSAssert(NO, @"Internal Error 327-2849");
            segmentConfiguration = 0;
            break;
    }
    
    return segmentConfiguration;
}

- (NSInteger)sortWhichSegments {
    NSInteger sortWhichSegment;
    switch (self.sortingSegmentation.integerValue) {
        case BkmxSortingSegmentationMixAndSortAll:
            sortWhichSegment = 0;
            break;
        case BkmxSortingSegmentationFoldersAtTopSortingBoth:
            sortWhichSegment = 0;
            break;
        case BkmxSortingSegmentationFoldersAtBottomSortingBoth:
            sortWhichSegment = 0;
            break;
        case BkmxSortingSegmentationFoldersAtTopSortingFoldersOnly:
            sortWhichSegment = 1;
            break;
        case BkmxSortingSegmentationFoldersAtBottomSortingFoldersOnly:
            sortWhichSegment = 1;
            break;
        case BkmxSortingSegmentationFoldersAtTopSortingBookmarksOnly:
            sortWhichSegment = 2;
            break;
        case BkmxSortingSegmentationFoldersAtBottomSortingBookmarksOnly:
            sortWhichSegment = 2;
            break;
        case BkmxSortingSegmentationIllegalValue:
            NSAssert(NO, @"Internal Error 327-2857");
            sortWhichSegment = 0;
            break;
        case BkmxSortingSegmentationDontKnow:
            NSAssert(NO, @"Internal Error 327-2858");
            sortWhichSegment = 0;
            break;
        default:
            NSAssert(NO, @"Internal Error 327-2859");
            sortWhichSegment = 0;
            break;
    }
    
    return sortWhichSegment;
}

- (BOOL)canPickSortWhichSegments {
    return self.segmentConfiguration != 0;
}

+ (NSSet*)keyPathsForValuesAffectingSortWhichSegments {
    return [NSSet setWithObjects:
            @"sortingSegmentation",
            nil] ;
}

+ (NSSet*)keyPathsForValuesAffectingSegmentConfiguration {
    return [NSSet setWithObjects:
            @"sortingSegmentation",
            nil] ;
}

/* This is necessary because the data model stores it as
 a signed 16-bit integer, but we need unsigned, which is 
 significant for the default value of 61441, because as
 a signed number this is -4095.  It didn't seem to
 matter until Mac OS 10.7.  */
- (NSNumber*)tagDelimiter {
    NSNumber* number ;
    
    [self willAccessValueForKey:constKeyTagDelimiter] ;
    number = [self primitiveTagDelimiter];
    [self didAccessValueForKey:constKeyTagDelimiter] ;
    
	unsigned short value = [number unsignedShortValue] ;
	number = [NSNumber numberWithUnsignedShort:value] ;
	return number ;
}

- (void)setTagDelimiter:(NSNumber*)value {
	[self postWillSetNewValue:value
					   forKey:constKeyTagDelimiter] ;
	
    [self willChangeValueForKey:constKeyTagDelimiter] ;
    [self setPrimitiveTagDelimiter:value];
    [self didChangeValueForKey:constKeyTagDelimiter] ;
}

- (void)setVisitor:(NSString*)value {
	[self postWillSetNewValue:value
					   forKey:constKeyVisitor] ;
	
    [self willChangeValueForKey:constKeyVisitor] ;
    [self setPrimitiveVisitor:value];
    [self didChangeValueForKey:constKeyVisitor] ;
}

- (NSString *)uuid {
    NSString* __block tmpValue;
    
    if ([[NSThread currentThread] isMainThread]) {
        [self willAccessValueForKey:@"uuid"];
        tmpValue = [self primitiveUuid];
        [self didAccessValueForKey:@"uuid"];
        [tmpValue retain];
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self willAccessValueForKey:@"uuid"];
            tmpValue = [self primitiveUuid];
            [self didAccessValueForKey:@"uuid"];
            [tmpValue retain];
        });
    }
	
	return [tmpValue autorelease];
}

#pragma mark * Shallow Value-Added Getters

- (BOOL)rootCanTakeAnySharype {
	return (
			[[self rootSoftainersOk] boolValue] 
			&&
			[[self rootLeavesOk] boolValue] 
			&&
			[[self rootNotchesOk] boolValue] 
			) ;
}

- (NSNumber*)tagDelimiterActual {
	NSNumber* tagDelimiterActual = [self tagDelimiter] ;
	if ([tagDelimiterActual unsignedShortValue] == YOUR_DEFAULT_TAG_DELIMITER) {
		tagDelimiterActual = [[NSUserDefaults standardUserDefaults] objectForKey:constKeyTagDelimiterDefault] ;
	}
	
	return tagDelimiterActual ;
}
+ (NSSet*)keyPathsForValuesAffectingTagDelimiterActual {
	return [NSSet setWithObjects:
			constKeyTagDelimiter,
			@"appDelegate.tagDelimiterDefault",
			nil] ;
}

- (BkmxAppDel*)appDelegate {
	return (BkmxAppDel*)[NSApp delegate] ;
}

- (BkmxSortBy)sortByValue {
	return (BkmxSortBy)[[self sortBy] integerValue] ;
}

- (BOOL)dupesMaybeMore {
	NSDate* lastDupesDone_ = [self lastDupesDone] ;
	NSDate* lastDupesMaybeMore_ = [self lastDupesMaybeMore] ;
	
	BOOL maybeMore = YES ;
	if (lastDupesDone_ && lastDupesMaybeMore_) {
		maybeMore = [lastDupesMaybeMore_ compare:lastDupesDone_] == NSOrderedDescending ;
	}
	else if (lastDupesDone_) {
		// Dupes were found, and maybeMore has never happened.
		maybeMore = NO ;
	}
	
	return maybeMore ;
}
 + (NSSet *)keyPathsForValuesAffectingDupesMaybeMore {
	return [NSSet setWithObjects:
//			constKeyLastDupesDone,      // for findDupes execution
			constKeyLastDupesMaybeMore, // in case ignoreDisparateDupes is switched OFF, also maybe for added starks  // Note: lastDupesMaybeMore, not dupesMaybeMore
//			@"owner.dupetainer.dupes",  // for adding dupes
			nil] ;	
}

#pragma mark * Infrastructure

// From NSManagedObject documentation: "You are discouraged from overriding
// description ... if this method fires a fault during a debugging
// operation, the results may be unpredictable.
- (NSString*)shortDescription {
	return [NSString stringWithFormat:
			@"Bookshig %p owned by %@",
			self,
			[self owner]] ;
}


- (NSString*)keyForStructureBit:(NSInteger)bit {
	NSString* key = nil ;
	switch (bit) {
		case BkmxStructureBitHasBar:
			key = constKeyHasBar ;
		break;
		case BkmxStructureBitHasMenu:
			key = constKeyHasMenu ;
			break;
		case BkmxStructureBitHasUnfiled:
			key = constKeyHasUnfiled ;
			break;
		case BkmxStructureBitHasOhared:
			key = constKeyHasOhared ;
			break;
		case BkmxStructureBitRootHartainersOk:
			// nil
			break;
		case BkmxStructureBitRootSoftainersOk:
			key = constKeyRootSoftainersOk ;
			break;
		case BkmxStructureBitRootLeavesOk:
			key = constKeyRootLeavesOk ;
			break;
		case BkmxStructureBitRootNotchesOk:
			key = constKeyRootNotchesOk ;
			break;
		default:
			NSLog(@"Internal Error 151-9534") ;
			break;
	}
	
	return key ;
}


#if 0
#warning Compiling -[Bookshig structure].  This is useful for debugging.
/*!
 @brief    Returns an integer whose bit values represent
 the boolean attributes defining the current structure of
 the receiver, as given in the Settings ▸ Structure tab.
*/
- (NSInteger)structure {
	NSInteger structure = 0x0 ;
	
	if ([(BkmxDoc*)[self owner] hasBar]) {
		structure += (1 << BkmxStructureBitHasBar) ;
	}
	if ([(BkmxDoc*)[self owner] hasMenu]) {
		structure += (1 << BkmxStructureBitHasMenu) ;
	}
	if ([(BkmxDoc*)[self owner] hasUnfiled]) {
		structure += (1 << BkmxStructureBitHasUnfiled) ;
	}
	if ([(BkmxDoc*)[self owner] hasOhared]) {
		structure += (1 << BkmxStructureBitHasOhared) ;
	}
	if (YES) /* hard folders are always OK */ {
		structure += (1 << BkmxStructureBitRootHartainersOk) ;
	}
	if ([[self rootSoftainersOk] boolValue]) {
		structure += (1 << BkmxStructureBitRootSoftainersOk) ;
	}
	if ([[self rootLeavesOk] boolValue]) {
		structure += (1 << BkmxStructureBitRootLeavesOk) ;
	}
	if ([[self rootNotchesOk] boolValue]) {
		structure += (1 << BkmxStructureBitRootNotchesOk) ;
	}
	
	return structure ;
}
#endif

- (BOOL)setAsAllowedStructure:(NSInteger)structure {
 	NSMutableArray* softainers = [[NSMutableArray alloc] init] ;
	NSMutableArray* leaves = [[NSMutableArray alloc] init] ;
	NSMutableArray* notches = [[NSMutableArray alloc] init] ;
	BkmxDoc* bkmxDoc = (BkmxDoc*)[self owner] ;
	Stark* root = [[bkmxDoc starker] root] ;
	[root classifyBySharypeDeeply:NO
					   hartainers:nil
					  softFolders:softainers
						   leaves:leaves
						  notches:notches] ;
	
    NSInteger keyIndex ;
	BOOL changedHaveTheseHardFolders = NO ;
	BOOL changedItemsAllowedAtRoot = NO ;
	for (keyIndex=0; keyIndex<8; keyIndex++) {
		// Set to NSControlStateValueMixed to signify "change not allowed"
		NSInteger ternaryNewValue = NSControlStateValueMixed ;

		// Pick out the next proposed value using a bit mask
		BOOL proposedValue = ((structure & (1 << keyIndex)) > 0) ;
		
		if (proposedValue == YES) {
			// It's always OK to add a hartainer, or to allow a sharype at root
			ternaryNewValue = NSControlStateValueOn ;
		}
		else {
			switch (keyIndex) {
				case BkmxStructureBitHasBar:
					if ([[[(BkmxDoc*)[self owner] starker] bar] numberOfChildren] == 0) {
						ternaryNewValue = NSControlStateValueOff ;
					}
					break ;
				case BkmxStructureBitHasMenu:
					if ([[[(BkmxDoc*)[self owner] starker] menu] numberOfChildren] == 0) {
						ternaryNewValue = NSControlStateValueOff ;
					}
					break ;
				case BkmxStructureBitHasUnfiled:
					if ([[[(BkmxDoc*)[self owner] starker] unfiled] numberOfChildren] == 0) {
						ternaryNewValue = NSControlStateValueOff ;
					}
					break ;
				case BkmxStructureBitHasOhared:
					if ([[[(BkmxDoc*)[self owner] starker] ohared] numberOfChildren] == 0) {
						ternaryNewValue = NSControlStateValueOff ;
					}
					break ;
				case BkmxStructureBitRootHartainersOk:
					// rootHartainersOk cannot be turned off
					// It's not even an attribute.
					break ;
				case BkmxStructureBitRootSoftainersOk:
					if ([softainers count] == 0) {
						ternaryNewValue = NSControlStateValueOff ;
					}
					break ;
				case BkmxStructureBitRootLeavesOk:
					if ([leaves count] == 0) {
						ternaryNewValue = NSControlStateValueOff ;
					}
					break ;
				case BkmxStructureBitRootNotchesOk:
					if ([notches count] == 0) {
						ternaryNewValue = NSControlStateValueOff ;
					}
					break ;
				default:
					NSLog(@"Internal error 513-9518") ;
			}
		}
		
		NSString* key = [self keyForStructureBit:keyIndex] ;

		if (key && (ternaryNewValue != NSControlStateValueMixed)) {
			// Get old value
			BOOL oldValue ;
			SEL getter = NSSelectorFromString(key) ;
			if (keyIndex < 4) {
				NSInvocation* invocation = [NSInvocation invocationWithTarget:[self owner]
																	 selector:getter
															  retainArguments:YES
															argumentAddresses:NULL] ;
				[invocation invoke] ;
				[invocation getReturnValue:&oldValue] ;
			}
			else {
				oldValue = [[self valueForKey:key] boolValue] ;
			}

			BOOL newValue = ternaryNewValue == NSControlStateValueOn ? YES : NO ;
			if (oldValue != newValue) {
				id target  ;
				
				if (keyIndex < 4) {
					changedHaveTheseHardFolders = YES ;
					target = [self owner] ;
				}
				else {
					target = self ;
					changedItemsAllowedAtRoot = YES ;
				}

				NSNumber* newNumber = [NSNumber numberWithBool:(newValue ? YES : NO)] ;
				[target setValue:newNumber
						  forKey:key] ;
			}
		}
	}
	
	SSYProgressView* progressView = [bkmxDoc progressView] ;
	NSString* msg = [NSString localizeFormat:
					 @"structureChangedForX",
					 [[BkmxBasis sharedBasis] labelClients]] ;
	// Clear out any similar old text in progress view, to make sure it flashes
	NSString* currentText = [progressView text] ;
	if ([currentText hasPrefix:msg]) {
		[progressView clearAll] ;
	}

	BOOL anyChangesMade = (changedHaveTheseHardFolders || changedItemsAllowedAtRoot) ;
	
	if (anyChangesMade) {
		NSString* what ;
		if (changedHaveTheseHardFolders && changedItemsAllowedAtRoot) {
			what = [NSString localizeFormat:
					@"multiple%0",
					[NSString localize:@"changes"]] ;
		}
		else if (changedHaveTheseHardFolders) {
			what = [[BkmxBasis sharedBasis] labelHartainersHave] ;
		}
		else {
			what = [[BkmxBasis sharedBasis] labelItemsAllowedAtRoot] ;
		}
					
		msg = [NSString stringWithFormat:
			   @"%@  (%@)",
			   msg,
			   what] ;
		[progressView setText:msg
					hyperText:nil
					   target:nil
					   action:NULL] ;
#if 0
		[(BkmxDoc*)[self owner] setUndoActionNameForAction:SSYModelChangeActionSort
												   object:self
												objectKey:nil
											   updatedKey:what
													count:0] ;
#endif
	}
	
	[softainers release] ;
	[leaves release] ;
	[notches release] ;
    
    [(BkmxDoc*)[self owner] checkAllProxies:nil] ;
	
	return anyChangesMade ;
}

- (BOOL)userDidEndFussingWithClients {
	BOOL didDo = NO ;
	if ([self userIsFussingWithClients]) {
		didDo = [self configureStructureForClients] ;
	}
	
	[self setUserIsFussingWithClients:NO] ;
	
	return didDo ;
}

- (BOOL)configureStructureForClients {
#if 0
#warning Not configuring structure
	return NO ;
#endif
	
	// Initialize a structure.
    // At first, I tried by wiping the slate clean, setting all attributes to
	// minimum values, for example, [self setBar:[NSNumber numberWithInt:NO]], etc.
	// But that caused, for example, the bookmarks bar in my content to be
	// wiped out too.  Not a good idea!
	// So now, I use a local variable...
	NSInteger structure = 0x0 ;
    
    if ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppBookMacster) {
        // Affected attributes should be configured automatically based
        // on the current importers
        
        // Get an array of extores, one for each current importer.
        NSMutableArray* extores = [[NSMutableArray alloc] init] ;
        for (Importer* importer in [[self macster] importers]) {
            // I don't think that the following should ever happen, but
            // probably it did - otherwise I wouldn't have added if :(
            // Maybe it's just defensive programming?
            if ([[importer client] willSelfDestruct]) {
                // The following warning added in BookMacster 1.11
                NSLog(@"Warning 512-9192 %@", [[importer client] shortDescription]) ;
                continue ;
            }
            
            Class extoreClass = [Extore extoreClassForExformat:[[importer client] exformat]] ;
            // Note that extoreClass may be nil if importer's client has not been
            // set yet. If we let go here it will cause a crash.
            
            // Beginning with BookMacster 1.5.6, for Safari 5.1, the extoreClass
            // is no longer good enough here, because [extore hasUnfiled] depends
            // on the particular Safari bookmarks file.  We need to read it and
            // see if it is Safari 5.1+.
            Extore* extore = [[extoreClass alloc] initWithIxporter:importer
                                                         clientoid:nil
                                                         jobSerial:0];
            
            if (extore) {
                [extores addObject:extore] ;
            }
            [extore release];
        }
        
        // Add the Has<Hartainer> bits to the structure
        for (Extore* extore in extores) {
            if ([extore hasBar]) {
                structure |= (1 << BkmxStructureBitHasBar) ;
            }
            if ([extore hasMenu]) {
                structure |= (1 << BkmxStructureBitHasMenu) ;
            }
            if ([extore hasUnfiled]) {
                structure |= (1 << BkmxStructureBitHasUnfiled) ;
            }
            if ([extore hasOhared]) {
                structure |= (1 << BkmxStructureBitHasOhared) ;
            }
        }
        
        // Add the Root<Sharype>Ok bits to the structure.
        // Start with Root hartainers whichare always OK …
        structure |= (1 << BkmxStructureBitRootHartainersOk) ;
        BOOL anyClientHasAnyHartainer = ( NO
                                         || ((structure & (1 << BkmxStructureBitHasBar)) > 0)
                                         || ((structure & (1 << BkmxStructureBitHasMenu)) > 0)
                                         || ((structure & (1 << BkmxStructureBitHasUnfiled)) > 0)
                                         || ((structure & (1 << BkmxStructureBitHasOhared)) > 0)
                                         ) ;
        if (anyClientHasAnyHartainer) {
            for (Extore* extore in extores) {
                Class extoreClass = [extore class] ;
                
                // extoreClass may be nil if importer's client has not been set yet.
                // If we let go here it will cause a crash.
                // So we check first
                if (!extoreClass) {
                    continue ;
                }
                
                if ([extoreClass rootSoftainersOk]) {
                    structure |= (1 << BkmxStructureBitRootSoftainersOk) ;
                }
                if ([extoreClass rootLeavesOk]) {
                    structure |= (1 << BkmxStructureBitRootLeavesOk) ;
                }
                if ([extoreClass rootNotchesOk]) {
                    structure |= (1 << BkmxStructureBitRootNotchesOk) ;
                }
            }
        }
        else {
            // No client has any hartainer.
            // Either there are no clients, or all clients must be nonhierarchical.
            // Be liberal and allow everything.  The idea is to not be annoyingly
            // restrictive.  Since hard folders, soft folders and separators
            // will not be exported anyhow, we allow them at root.
            
            structure |= (1 << BkmxStructureBitRootSoftainersOk) ;
            structure |= (1 << BkmxStructureBitRootLeavesOk) ;
            structure |= (1 << BkmxStructureBitRootNotchesOk) ;
        }		
        
        [extores release] ;
    }
    else {
        NSSet* extoreClasses ;
        switch ([[BkmxBasis sharedBasis] iAm]) {
            case BkmxWhich1AppSmarky:
                extoreClasses = [NSSet setWithObjects:
                                 [ExtoreSafari class],
                                 nil] ;
                break ;
            case BkmxWhich1AppSynkmark:
                // A Synkmark user may originally create her shoebox without all of
                // Safari, Firefox and Chrome.  But we want it to be structured with
                // for them, in case they are added later.  Note that Synkmark users
                // have no Settings > Structure controls.
                extoreClasses = [NSSet setWithObjects:
                                 [ExtoreSafari class],
                                 [ExtoreFirefox class],
                                 [ExtoreChrome class],
                                 nil] ;
                break ;
            case BkmxWhich1AppBookMacster:
                // This cannot happen.  Just supress compiler warnings.
            case BkmxWhich1AppMarkster:
                extoreClasses = [NSSet set] ;
                break ;
        }

        // Add the Has<Hartainer> bits to the structure
        for (Class extoreClass in extoreClasses) {
            if ([extoreClass constants_p]->hasBar == YES) {
                structure |= (1 << BkmxStructureBitHasBar) ;
            }
            // hasUnfiled must be handled a little differently because, for
            // Safari, it depends on whether user had Bookmarks Menu when
            // from an earlier macOS version (10.8??).  Fortunately,
            // our shoebox apps only deal with thisUser.
            if ([extoreClass thisUserHasMenu]) {
                structure |= (1 << BkmxStructureBitHasMenu) ;
            }
            // hasUnfiled must be handled a little differently because, for
            // Safari, it depends on the Safari version installed.  Fortunately,
            // our shoebox apps only deal with thisUser.
            if ([extoreClass thisUserHasUnfiled]) {
                structure |= (1 << BkmxStructureBitHasUnfiled) ;
            }
            if ([extoreClass constants_p]->hasOhared == YES) {
                structure |= (1 << BkmxStructureBitHasOhared) ;
            }
        }
        
        // Add the Root<Sharype>Ok bits to the structure.
        // Start with Root hartainers whichare always OK …
        structure |= (1 << BkmxStructureBitRootHartainersOk) ;
        BOOL anyClientHasAnyHartainer = ( NO
                                         || ((structure & (1 << BkmxStructureBitHasBar)) > 0)
                                         || ((structure & (1 << BkmxStructureBitHasMenu)) > 0)
                                         || ((structure & (1 << BkmxStructureBitHasUnfiled)) > 0)
                                         || ((structure & (1 << BkmxStructureBitHasOhared)) > 0)
                                         ) ;
        if (anyClientHasAnyHartainer) {
            for (Class extoreClass in extoreClasses) {
                if ([extoreClass rootSoftainersOk]) {
                    structure |= (1 << BkmxStructureBitRootSoftainersOk) ;
                }
                if ([extoreClass rootLeavesOk]) {
                    structure |= (1 << BkmxStructureBitRootLeavesOk) ;
                }
                if ([extoreClass rootNotchesOk]) {
                    structure |= (1 << BkmxStructureBitRootNotchesOk) ;
                }
            }
        }
        else {
            // No client has any hartainer.
            // Either there are no clients, or all clients must be nonhierarchical.
            // Be liberal and allow everything.  The idea is to not be annoyingly
            // restrictive.  Since hard folders, soft folders and separators
            // will not be exported anyhow, we allow them at root.
            
            structure |= (1 << BkmxStructureBitRootSoftainersOk) ;
            structure |= (1 << BkmxStructureBitRootLeavesOk) ;
            structure |= (1 << BkmxStructureBitRootNotchesOk) ;
        }
    }
    
	return [self setAsAllowedStructure:structure] ;
}

- (void)configurePreferredCatchype {
	NSCountedSet* preferredCatchypeCandidates = [NSCountedSet setWithCapacity:4] ;
	
	for (Importer* importer in [[self macster] activeImportersOrdered]) {
		// We don't need an extore since all the info we need is available
		// from the extore's class
		Class extoreClass = [Extore extoreClassForExformat:[[importer client] exformat]] ;
		
		// extoreClass may be nil if importer's client has not been set yet.
		// If we let go here it will cause a crash.
		// So we check first
		if (!extoreClass) {
			continue ;
		}
		
        [preferredCatchypeCandidates addObject:[NSNumber numberWithSharype:[extoreClass fosterSharypeForSharype:SharypeBookmark]]] ;
	}
	
	NSNumber* winner = nil ;
	NSInteger winningCount = 0 ;
	for (NSNumber* sharypeNumber in preferredCatchypeCandidates) {
		NSInteger count = [preferredCatchypeCandidates countForObject:sharypeNumber] ;
		if (count > winningCount) {
			winner = sharypeNumber ;
			winningCount = count ;
		}
	}
	if (winner) {
		[[self macster] setPreferredCatchype:winner] ;
	}
}

- (void)removeObservers:(NSNotification*)note {
	[[MAKVONotificationCenter defaultCenter] removeObserver:self];
	[[NSNotificationCenter defaultCenter] removeObserver:self] ;
}

- (void)willTurnIntoFault {
	[self removeObservers:nil] ;
}

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
	
	// The Bookshig removes its own observers.  This is particularly
	// important in case the user has executed a Save As and we're using
	// the Apple implementation of Save As, because after doing so the
	// BkmxDocWinCon and BkmxDoc will have a different Bookshig.
	[self removeObservers:nil] ;
	
	[super didTurnIntoFault] ;
}

- (void)mikeAshObserveValueForKeyPath:(NSString*)keyPath
							 ofObject:(id)object
							   change:(NSDictionary*)change
							 userInfo:(id)userInfo {
	BOOL ok = YES ;
	if (object == self) {
		if ([keyPath isEqualToString:constKeyLanding]) {
			// The reason I do this here instead of in a custom setter is that
			// when Core Data changes properties such as 'landing'
			// in an undo or redo operation, it does not invoke the setter.
			// (To verify, I created an Employee class in a version of
			// DepartmentAndEmployees, added a custom setter for 'salary'.
			// When I changed the salary in the user interface, the custom
			// setter was invoked.  When I then clicked Undo, although the
			// salary changed back to the original value, the custom setter
			// was not invoked.
			[[[self owner] bkmxDocWinCon] reloadNewBookmarkLandingMenu] ;
		}
		else {
			ok = NO ;
		}
	}
	else if (object == [NSUserDefaults standardUserDefaults]) {
		if (
			[keyPath isEqualToString:constKeyDispose302Perm]
			||
			[keyPath isEqualToString:constKeyDispose302Unsure]			
			) {
            /* Some behavior showed up in macOS 10.12, or maybe before, which
             is that, when the Bkmslf window opens, this observer gets invoked
             twice, once for dispose302Perm and once for dispose302Unsure,
             indicating that values were changed from old = a NSNull to new =
             whatever.  I thought this was because I was using the depreacted
             NSMatrix in Reports.xib, but removing those controls did not help.
             The symptom of this is that user Markster Mark S. reported that,
             because he had in System Preferences > General, switched on
             “Ask to keep changes when closing documents”, whenever he opened
             his Markster document, it was immediately dirty.
             
             To ignore these spurious changes, we use the following if().  This
             does NOT cause the first actual change for a new user to be
             ignored.  The first time that a new user clicks a radio button,
             the oldValue is apparently the value from the default defaults. */
            id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
            if (![oldValue isKindOfClass:[NSNull class]]) {
                [[self owner] postVerifyMaybeNot] ;
            }
		}
		else {
			ok = NO ;
		}
	}
	
	if (!ok) {
		NSString* msg = [NSString stringWithFormat:
						 @"No know keyPath: %@; object: %@; change: %@; userInfo: %@",
						 keyPath,
						 object,
						 change,
						 userInfo] ;
		NSLog(@"%@", msg) ;
		NSAssert(NO, msg) ;
	}
}

- (void)initializeObservers {
	[self addObserver:self
		   forKeyPath:constKeyLanding
			 selector:@selector(mikeAshObserveValueForKeyPath:ofObject:change:userInfo:)
			 userInfo:nil
			  options:0] ;
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(removeObservers:)
												 name:SSYUndoManagerDocumentWillCloseNotification
											   object:[self owner]] ;
	
	[[NSUserDefaults standardUserDefaults] addObserver:self
											forKeyPath:constKeyDispose302Perm
											  selector:@selector(mikeAshObserveValueForKeyPath:ofObject:change:userInfo:)
											  userInfo:nil
											   options:NSKeyValueObservingOptionOld + NSKeyValueObservingOptionNew] ;
	
	[[NSUserDefaults standardUserDefaults] addObserver:self
											forKeyPath:constKeyDispose302Unsure
											  selector:@selector(mikeAshObserveValueForKeyPath:ofObject:change:userInfo:)
											  userInfo:nil
                                               options:NSKeyValueObservingOptionOld + NSKeyValueObservingOptionNew] ;

	// Whenever I post one of the following notifications, object will be me
	// to indicate which document needs a timestamp updated.  So, here, object:self.
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateTimestamp:)
												 name:constNoteDupesDone
											   object:self] ;		

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateTimestamp:)
												 name:constNoteDupesMaybeMore
											   object:self] ;		
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateTimestamp:)
												 name:constNoteDupesMayContainDisparagees
											   object:self] ;		
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateTimestamp:)
												 name:constNoteDupesMayContainVestiges
											   object:self] ;		
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateTimestamp:)
												 name:constNoteSortDone
											   object:self] ;		
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateTimestamp:)
												 name:constNoteSortMaybeNot
											   object:self] ;		

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateTimestamp:)
												 name:constNoteVerifyDone
											   object:self] ;		
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateTimestamp:)
												 name:constNoteVerifyMaybeNot
											   object:self] ;		
}

- (void)awakeFromInsert {
	[super awakeFromInsert] ;
    [self initializeObservers] ;
}

- (void)awakeFromFetch {
	[super awakeFromFetch] ;
	[self initializeObservers] ;
}

- (void)updateTimestamp:(NSNotification*)notification {
	NSString* name = [notification name] ;
	NSString* key = nil ;
	
	if ([name isEqualToString:constNoteDupesDone]) {
		key = constKeyLastDupesDone ;
	}
	else if ([name isEqualToString:constNoteDupesMaybeMore]) {
		key = constKeyLastDupesMaybeMore ;
	}
	else if ([name isEqualToString:constNoteDupesMayContainDisparagees]) {
		key = constKeyLastDupesMaybeLess ;
	}
	else if ([name isEqualToString:constNoteDupesMayContainVestiges]) {
		key = constKeyLastDupesMaybeLess ;
	}
	else if ([name isEqualToString:constNoteSortDone]) {
		key = constKeyLastSortDone ;
	}
	else if ([name isEqualToString:constNoteSortMaybeNot]) {
		key = constKeyLastSortMaybeNot ;
	}
	else if ([name isEqualToString:constNoteVerifyDone]) {
		key = constKeyLastVerifyDone ;
	}
	else if ([name isEqualToString:constNoteVerifyMaybeNot]) {
		key = constKeyLastVerifyMaybeNot ;
	}
	
	NSDate* now = [NSDate date] ;
	
    [self setValue:now
            forKey:key] ;
}

- (void)mocModelChanged:(NSNotification*)notification {
	// This method handles object insertions and deletions
	
	// See also  -[Ixporter objectWillChangeNote:]
	// and -[Bookshig mocModelChanged]
	
	// At first, I wanted to use this method to update everything, and had
	// been using -[NSManagedObject changedValues] to determine
	// which keys had changed.  But then I found that -changedValues
	// continues to include changed keys that had already been
	// noted in previous notifications, until the document is saved.
	// Arghhhh.  This leads to extraneous results.  For example, when
	// a new bookmark is added, you get a notification that its
	// 'url' has changed (from nil).  If it is also a duplicate of
	// another bookmark, then after findDupes, its 'dupe' property
	// will have a relationship added, which will invoke this method
	// again, but in its -changedValues, along with 'dupe', unless
	// there was an intervening Save operation, 'url' will still be
	// there, and with a changed 'url' we will ^again^ invoke
	// postDupesMaybeMore, which is extraneous.
	
	// Be careful not to do anything in this method, or any method invoked by this method,
	// which will cause an additional change to any object in this document's managed
	// object context more than once.  So doing will create an infinite loop!
	
	NSSet* insertedObjects = [[notification userInfo] objectForKey:NSInsertedObjectsKey] ;
	NSSet* deletedObjects = [[notification userInfo] objectForKey:NSDeletedObjectsKey] ;
	// Not used, since the info it provides is so lame:
	// NSSet* updatedObjects = [[notification userInfo] objectForKey:NSUpdatedObjectsKey] ;
	
	NSManagedObject* object ;

#if 0
#warning Logging mocModelChanged
	NSMutableString* msg = [[NSMutableString alloc] init] ;
	[msg appendFormat: @"%s", __PRETTY_FUNCTION__] ;
	
	for (object in insertedObjects) {
		[msg appendFormat:@"\n   INSERTED: %@", [object shortDescription]] ;
	}
	for (object in deletedObjects) {
		[msg appendFormat:@"\n    DELETED: %@", [object shortDescription]] ;
	}
	NSLog(msg) ;
	[msg release] ;
#endif	
	
	if (
		([insertedObjects count] == 0)
		&&
		([deletedObjects count] == 0)
		) {
		// This current notification must be regarding updated object(s).
		// We're not interested in updated object(s).
		return ;
	}
	
	//NSMutableDictionary* objectsByClass = [[NSMutableDictionary alloc] init] ;
	//[insertedObjects classifyByClassIntoSetsInDictionary:objectsByClass] ;
	//[deletedObjects classifyByClassIntoSetsInDictionary:objectsByClass] ;
	
	BOOL someoneInsertedStarks = NO ;
	BOOL someoneDeletedStarks = NO ;
	
	
	for (object in insertedObjects) {
		if ([object isKindOfClass:[Stark class]]) {
			someoneInsertedStarks = YES ;
			break ;
		}
	}

	
	for (object in deletedObjects) {
		if ([object isKindOfClass:[Stark class]]) {
			someoneDeletedStarks = YES ;
			break ;
		}
	}

	
	if (someoneInsertedStarks) {
		[[self owner] postSortMaybeNot] ;
		[[self owner] postDupesMaybeMore] ;
	}
	
	if (someoneDeletedStarks) {
		[[self owner] postDupesMayContainVestiges] ;
	}
}


#pragma mark * Other Methods

+ (NSSet*)keyPathsForValuesAffectingToolTipTags {
	return [NSSet setWithObjects:
			constKeyTagDelimiterActual,
			nil] ;
}

@end
