#import "Extore.h"

@class ProfileInfoCache;
@class SSYTreeTransformer;
@class Stark;

extern NSString* const constKeyLastUsed ;
extern NSString* const constReadingUnsortedDisplayName ;

@interface ExtoreChromy : Extore {
    NSDictionary* m_ignoredBranchesInRoot ;
    NSInteger m_highestUsedId ;
}

@property BOOL menuWasOnDisk;

+ (NSDictionary*)infoCacheForHomePath:(NSString*)homePath;

+ (NSString*)pathForThisHomeProfileName:(NSString*)profileName;

+ (NSString*)browserSupportPathForHomePath:(NSString*)homePath ;

+ (NSString*)displayProfileNameFromDictionary:(NSDictionary*)dic ;

- (NSDictionary*)prefsError_p:(NSError**)error_p ;

- (NSArray*)keyPathsInChecksum ;

/* Hook which allows a subclass to graft bookmarks that live at the root level,
 outside the hard folders, directly under the collection root.  The default
 implementation (in ExtoreChromy) is a no-op.  Overridden by ExtoreOrion, the
 only Chromish browser which supports root-level bookmarks.  Invoked by
 -makeStarksFromExtoreTree:error_p: after the bar/menu hard folders have been
 assembled under rootOut, using the same 'transformer' it used for those. */
- (void)graftRootLevelStarksFromExtoreTree:(NSDictionary*)treeIn
                                   rootOut:(Stark*)rootOut
                               transformer:(SSYTreeTransformer*)transformer ;

+ (ProfileInfoCache*)profileInfoCache;

/* Need to declare this so it will appear as a code completion for
 subclasses that implement it in Swift. */
+ (void)refreshFromDiskOurInMemoryProfileInfoCache:(ProfileInfoCache*)cache;

@end
