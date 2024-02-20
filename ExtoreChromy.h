#import "Extore.h"

@class ProfileInfoCache;

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

+ (ProfileInfoCache*)profileInfoCache;

/* Need to declare this so it will appear as a code completion for
 subclasses that implement it in Swift. */
+ (void)refreshFromDiskOurInMemoryProfileInfoCache:(ProfileInfoCache*)cache;

@end
