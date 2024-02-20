#import "ExtoreCustomChromy.h"
#import "NSError+MyDomain.h"
#import "NSError+InfoAccess.h"
#import "NSObject+SSYCheckType.h"
#import "NSString+MorePaths.h"
#import "BkmxBasis.h"
#import "NSDictionary+Treedom.h"

@interface NSDictionary (Opera)

- (void)addIndexOfIdToIndexSet:(NSMutableIndexSet*)set ;

@end

@implementation NSDictionary (Opera)

- (void)addIndexOfIdToIndexSet:(NSMutableIndexSet*)set {
    NSString* exid = [self objectForKey:@"id"] ;
    if (exid) {
        [set addIndex:[exid integerValue]] ;
    }
}

@end


@interface ExtoreCustomChromy ()

@property (retain) NSDictionary* ignoredBranchesInCustomRoot ;
@property (retain) NSMutableDictionary* motherOfSpeedDials ;
@property (retain) NSArray* otherSpeedDials ;
@property (retain) NSString* valueOfNameKeyInLocalSpeedDial ;
@property (assign) NSInteger indexOfLocalSpeedDial ;

@end


@implementation ExtoreCustomChromy

- (void)dealloc {
    [_ignoredBranchesInCustomRoot release] ;
    [_motherOfSpeedDials release] ;
    [_otherSpeedDials release] ;
    [_valueOfNameKeyInLocalSpeedDial release] ;
    
    [super dealloc] ;
}

- (BOOL)canRemoveHartainers {
    return NO ;
}

+ (NSString*)labelMenu {
    return @"My Folders" ;
}

+ (NSString*)labelUnfiled {
    return @"Unsorted Bookmarks" ;
}

- (NSString*)labelUnfiled {
    return  [[self class] labelUnfiled] ;
}

+ (NSString*)labelOhared {
    return @"Speed Dial" ;
}

- (BOOL)hasUnfiled {
    return YES ;
}

- (NSSet*)hartainersWeEdit {
    return [NSSet setWithObjects:
            @"bookmark_bar",
            @"custom_root",
            nil] ;
}

// This method is only used when writing bookmarks in Style 1
- (NSMutableDictionary*)newJsonRootsFromBar:(NSDictionary*)bar
                                       menu:(NSDictionary*)menu
                                    unfiled:(NSDictionary*)unfiled
                                     ohared:(NSDictionary*)ohared {
    NSMutableArray* speedDials = [self.otherSpeedDials mutableCopy] ;
    NSMutableDictionary* oharedWithRestoredName = [ohared mutableCopy] ;
    [oharedWithRestoredName setObject:self.valueOfNameKeyInLocalSpeedDial
                               forKey:@"name"] ;
    NSDictionary* oharedWithRestoreNameCopy = [oharedWithRestoredName copy] ;
    [oharedWithRestoredName release] ;
    [speedDials insertObject:oharedWithRestoreNameCopy
                     atIndex:self.indexOfLocalSpeedDial] ;
    [oharedWithRestoreNameCopy release] ;
    NSArray* speedDialsCopy = [speedDials copy] ;
    [speedDials release] ;
    [self.motherOfSpeedDials setObject:speedDialsCopy
                                forKey:@"children"] ;
    [speedDialsCopy release] ;
    NSArray* motherOfSpeedDialsCopy = [self.motherOfSpeedDials copy] ;
    // See Note SpeedDialsMisnomer below
    NSMutableDictionary* customRootMute = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                           menu, @"userRoot",
                                           unfiled, @"unsorted",
                                           motherOfSpeedDialsCopy, @"speedDial",
                                           nil] ;
    [motherOfSpeedDialsCopy release] ;
    [customRootMute addEntriesFromDictionary:self.ignoredBranchesInCustomRoot] ;
    NSDictionary* customRoot = [customRootMute copy] ;
    [customRootMute release] ;
    
    NSMutableDictionary* answer = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   bar, @"bookmark_bar",
                                   customRoot, @"custom_root",
                                   nil] ;
    [customRoot release] ;
    return answer ;
}

+ (BkmxGrabPageIdiom)peekPageIdiom {
    return BkmxGrabPageIdiomSSYInterappServer ;
}

+ (NSString*)localStateFilePathForHomePath:(NSString*)homePath {
    return [[self browserSupportPathForHomePath:homePath] stringByAppendingPathComponent:@"Local State"] ;
}

- (NSDictionary*)extractDictionaryFromArray:(NSArray*)array
                                    atIndex:(NSInteger)index
                     expectedIndexAttribute:(NSInteger)expectedIndexAttribute
                                 errorCode1:(NSInteger)errorCode1
                                 errorCode2:(NSInteger)errorCode2
                                errorCode_p:(NSInteger* _Nonnull)errorCode_p
                            errorDesription:(NSString * _Nonnull * _Nonnull)errorDescription_p {
    NSDictionary* extraction = nil ;
    if (*errorCode_p == 0) {
        extraction = [array objectAtIndex:index] ;
        if ([extraction respondsToSelector:@selector(objectForKey:)]) {
            NSInteger indexAttributeValue = [[extraction objectForKey:@"index"] integerValue] ;
            if (indexAttributeValue != expectedIndexAttribute) {
                *errorCode_p = errorCode1 ;
                *errorDescription_p = [NSString stringWithFormat:
                                       @"Expected index attribute %ld, got %ld",
                                       (long)expectedIndexAttribute,
                                       (long)indexAttributeValue] ;
            }
        }
        else {
            *errorCode_p = errorCode2 ;
            *errorDescription_p = [NSString stringWithFormat:
                                   @"Expected dictionary, got %@",
                                   extraction.className] ;
        }
    }

    return extraction ;
}

- (nullable NSString*)speedDialGuidFromPrefs {
    NSDictionary* prefs = [self prefsError_p:NULL] ;
    NSString* guid = [[prefs objectForKey:@"speeddial"] objectForKey:@"bookmarks_folder_guid"] ;
    return guid ;
}

- (BOOL)extractHartainersFromExtoreTree:(NSDictionary*)treeIn
                                  bar_p:(NSDictionary* _Nonnull * _Nonnull)bar_p
                                 menu_p:(NSDictionary* _Nonnull * _Nonnull)menu_p
                              unfiled_p:(NSDictionary* _Nonnull * _Nonnull)unfiled_p
                               ohared_p:(NSDictionary* _Nonnull * _Nonnull)ohared_p
                                error_p:(NSError**)error_p {
    BOOL ok = YES ;
    NSError* error = nil ;
    
    NSDictionary* extoreBar = nil ;
    NSDictionary* extoreMenu = nil ;
    NSDictionary* extoreUnfiled = nil ;
    NSDictionary* extoreOhared = nil ;
    NSDictionary* extoreTrash = nil ;
    NSInteger errorCode = 0 ;
    NSString* errorMoreInfo = nil ;
    NSMutableIndexSet* hiddenExids = [NSMutableIndexSet new] ;

    if ([treeIn isKindOfClass:[NSDictionary class]]) {
        /* That 'whatever' will be non-nil if we were invoked from
         -readExternalStyle1ForPolarity:: */

        NSDictionary* roots = [treeIn objectForKey:@"roots"] ;
        NSArray* children = [treeIn objectForKey:@"children"] ;
        if (roots) {
            if ([roots respondsToSelector:@selector(objectForKey:)]) {
                /* This will happen normally if we were invoked from
                 -readExternalStyle1ForPolarity:: */
                extoreBar = [roots objectForKey:@"bookmark_bar"] ;
                NSDictionary* customRoot = [roots objectForKey:@"custom_root"] ;
                if ([customRoot respondsToSelector:@selector(objectForKey:)]) {
                    NSMutableDictionary* ignoredBranchesInCustomRoot = [[NSMutableDictionary alloc] init] ;
                    for (NSString* customRootKey in [customRoot allKeys]) {
                        id customRootValue = [customRoot objectForKey:customRootKey] ;
                        if ([customRootKey isEqualToString:@"userRoot"]) {
                            extoreMenu = customRootValue ;
                        }
                        else if ([customRootKey isEqualToString:@"unsorted"] ) {
                            extoreUnfiled = customRootValue ;
                        }
                        else if ([customRootKey isEqualToString:@"speedDial"]) {
                            /* See Note SpeedDialsMisnomer below for explanation
                             of the following confusion. */
                            [customRootValue addIndexOfIdToIndexSet:hiddenExids] ;
                            NSDictionary* motherOfSpeedDialsIn = customRootValue ;
                            NSMutableDictionary* motherOfSpeedDials = [[NSMutableDictionary alloc] init] ;
                            NSMutableArray* otherSpeedDials = [[NSMutableArray alloc] init] ;
                            for (NSString* key in [motherOfSpeedDialsIn allKeys]) {
                                id value = [motherOfSpeedDialsIn objectForKey:key] ;
                                if ([key isEqualToString:@"children"]) {
                                    NSInteger i = 0 ;
                                    /* Initialize to -1 so we can later tell if
                                     we found one. */
                                    self.indexOfLocalSpeedDial = -1 ;
                                    NSString* targetSpeedDialGuid = [self speedDialGuidFromPrefs] ;
                                    NSArray* childSpeedDials = [motherOfSpeedDialsIn objectForKey:@"children"] ;
                                    for (NSDictionary* aSpeedDial in childSpeedDials) {
                                        NSString* thisGuid = [[aSpeedDial objectForKey:constKeyMetaInfo] objectForKey:@"speed_dial_root_folder_guid"] ;

                                        if ([thisGuid isEqualToString:targetSpeedDialGuid]) {
                                            extoreOhared = aSpeedDial ;
                                            self.indexOfLocalSpeedDial = i ;
                                            self.valueOfNameKeyInLocalSpeedDial = [aSpeedDial objectForKey:@"name"] ;
                                        }
                                        else {
                                            [otherSpeedDials addObject:aSpeedDial] ;
                                            [aSpeedDial addIndexOfIdToIndexSet:hiddenExids] ;
                                        }
                                        i++ ;
                                    }
                                    if (self.indexOfLocalSpeedDial == -1) {
                                        /* Opera must have changed something. */
                                        NSLog(@"Warning 382-3890") ;
                                        /* Take a guess.  Most people only have
                                         one, which will be at index 0. */
                                        i = 0 ;
                                        self.indexOfLocalSpeedDial = i ;
                                        extoreOhared = [childSpeedDials objectAtIndex:i] ;
                                        self.valueOfNameKeyInLocalSpeedDial = [extoreOhared objectForKey:@"name"] ;
                                    }
                                }
                                else {
                                    [motherOfSpeedDials setObject:value
                                                           forKey:key] ;
                                }
                            }
                            self.motherOfSpeedDials = motherOfSpeedDials ;
                            [motherOfSpeedDials release] ;
                            NSArray* otherSpeedDialsCopy = [otherSpeedDials mutableCopy] ;
                            self.otherSpeedDials = otherSpeedDialsCopy ;
                            [otherSpeedDialsCopy release] ;
                            [otherSpeedDials release] ;
                        }
                        else {
                            /* "trash" will go here, because we only need to
                             get out its exids. */
                            [ignoredBranchesInCustomRoot setObject:customRootValue
                                                            forKey:customRootKey] ;
                        }
                        
                        if ([customRootKey isEqualToString:@"trash"]) {
                            extoreTrash = customRootValue ;
                            [extoreTrash recursivelyPerformOnChildrenLowerSelector:@selector(addIndexOfIdToIndexSet:)
                                                                        withObject:hiddenExids] ;
                        }
                    }
                    NSDictionary* ignoredBranchesInCustomRootCopy = [ignoredBranchesInCustomRoot copy] ;
                    self.ignoredBranchesInCustomRoot = ignoredBranchesInCustomRootCopy ;
                    [ignoredBranchesInCustomRoot release] ;
                    [ignoredBranchesInCustomRootCopy release] ;
                }
                else {
                    errorCode = 174870 ;
                    errorMoreInfo = [NSString stringWithFormat:@"Expected custom_root dictionary, got %@", [customRoot className]] ;
                }
                
                NSDictionary* branchWeIgnore ;
                
                branchWeIgnore = [roots objectForKey:@"other"] ;
                if ([branchWeIgnore respondsToSelector:@selector(objectForKey:)]) {
                    [branchWeIgnore recursivelyPerformOnChildrenLowerSelector:@selector(addIndexOfIdToIndexSet:)
                                                                   withObject:hiddenExids] ;
                }
                branchWeIgnore = [roots objectForKey:@"synced"] ;
                if ([branchWeIgnore respondsToSelector:@selector(objectForKey:)]) {
                    [branchWeIgnore recursivelyPerformOnChildrenLowerSelector:@selector(addIndexOfIdToIndexSet:)
                                                                   withObject:hiddenExids] ;
                }

            }
            else {
                errorCode = 174873 ;
                errorMoreInfo = [NSString stringWithFormat:@"Expected roots dictionary, got %@", [roots className]] ;
            }
        }
        else if (children) {
            if ([children respondsToSelector:@selector(objectAtIndex:)]) {
                /* This will happen normally if we are invoked from
                 -readExternalStyle2WithCompletionHandler: */
                /* My reverse-engineering:
                 actual index    value of 'index'
                 in the array    attribute           What is it
                 ------------    ----------------    ----------------------------------------------
                 .    0                0             Bookmarks Bar
                 .    1                1             "Other Bookmarks", always empty and not used in Opera
                 .    2                3             Speed Dial.  (Bkmx Ohared) This is actually the "Mother of Speed Dials", a dictionary which contains, in its 'children' key, Speed Dials from different devices.  The local computer's speed dial is the one at index 0, I hope!!
                 .    3                4             Trash
                 .    4                5             Unsorted Bookmarks
                 .    5                6             My Folders (Bkmx Menu)
                 */
                if (children.count >= 6) {
                     extoreBar = [self extractDictionaryFromArray:children
                                                          atIndex:0
                                           expectedIndexAttribute:0
                                                       errorCode1:180610
                                                       errorCode2:180611
                                                      errorCode_p:&errorCode
                                                  errorDesription:&errorMoreInfo] ;
                     extoreMenu = [self extractDictionaryFromArray:children
                                                           atIndex:5
                                            expectedIndexAttribute:6
                                                        errorCode1:180620
                                                        errorCode2:180621
                                                       errorCode_p:&errorCode
                                                   errorDesription:&errorMoreInfo] ;
                     extoreUnfiled = [self extractDictionaryFromArray:children
                                                              atIndex:4
                                               expectedIndexAttribute:5
                                                           errorCode1:180630
                                                           errorCode2:180631
                                                          errorCode_p:&errorCode
                                                      errorDesription:&errorMoreInfo] ;
                     NSDictionary* speedMom = [self extractDictionaryFromArray:children
                                                                       atIndex:2
                                                        expectedIndexAttribute:3
                                                                    errorCode1:180640
                                                                    errorCode2:180641
                                                                   errorCode_p:&errorCode
                                                               errorDesription:&errorMoreInfo] ;
                     if ([speedMom respondsToSelector:@selector(objectForKey:)]) {
                         [speedMom addIndexOfIdToIndexSet:hiddenExids] ;
                         NSArray* speedDials = [speedMom objectForKey:@"children"] ;
                         if (speedDials.count > 0) {
                             extoreOhared = [speedDials objectAtIndex:0] ;
                             for (NSInteger i=1; i<speedDials.count; i++) {
                                 [[speedDials objectAtIndex:i] recursivelyPerformOnChildrenLowerSelector:@selector(addIndexOfIdToIndexSet:)
                                                                                              withObject:hiddenExids] ;
                             }
                         }
                     }
                     else {
                         errorCode = 174879 ;
                         errorMoreInfo = [NSString stringWithFormat:@"Expected speed dials dictionary, got %@", [speedMom className]] ;
                     }
                     extoreTrash = [self extractDictionaryFromArray:children
                                                            atIndex:3
                                             expectedIndexAttribute:4
                                                         errorCode1:180650
                                                         errorCode2:180651
                                                        errorCode_p:&errorCode
                                                    errorDesription:&errorMoreInfo] ;
                     [extoreTrash recursivelyPerformOnChildrenLowerSelector:@selector(addIndexOfIdToIndexSet:)
                                                                 withObject:hiddenExids] ;
                }
                /* This is what happens for user Ulysese B., Opera 63, on
                 20190930.  I do not understand why or how this happens
                 because when I install Ulysese's Opera bookmarks and do an
                 import/export, I get six children, the above branch executes
                 instead of this one, and all is nice.  I even installed the
                 five Opera extensions Ulysese reportedly has.  */
                /* My reverse-engineering:
                 actual index    value of 'index'
                 in the array    attribute           What is it
                 ------------    ----------------    ----------------------------------------------
                 .    0                0             Bookmarks Bar
                 .    1                1             "Other Bookmarks", always empty and not used in Opera
                 .    2                2             Mobile Bookmarks
                 */
                else if (children.count >= 3) {
                    extoreBar = [self extractDictionaryFromArray:children
                                                         atIndex:0
                                          expectedIndexAttribute:0
                                                      errorCode1:180660
                                                      errorCode2:180661
                                                     errorCode_p:&errorCode
                                                 errorDesription:&errorMoreInfo] ;
                    extoreMenu = [self extractDictionaryFromArray:children
                                                          atIndex:5
                                           expectedIndexAttribute:6
                                                       errorCode1:180670
                                                       errorCode2:180671
                                                      errorCode_p:&errorCode
                                  
                                                  errorDesription:&errorMoreInfo] ;
                }
                else {
                    errorCode = 174876 ;
                    errorMoreInfo = [NSString stringWithFormat:@"%ld children, expected more", children.count] ;
                }
            }
            else {
                errorCode = 174875 ;
                errorMoreInfo = [NSString stringWithFormat:@"Expected children array, got %@", [children className]] ;
            }
        }
        else {
            errorCode = 174869 ;
            errorMoreInfo = [NSString stringWithFormat:@"Neither roots nor children in %@", [roots allKeys]] ;
        }

    }
    else {
        errorCode = 164874 ;
        errorMoreInfo = [NSString stringWithFormat:@"Expected tree, got %@", [treeIn className]] ;
    }
    
    if (errorCode != 0) {
        ok = NO ;
        error = SSYMakeError(errorCode, @"Decoded JSON does not meet expectation") ;
        error = [error errorByAddingUserInfoObject:errorMoreInfo
                                            forKey:@"Details"] ;
        error = [error errorByAddingUserInfoObject:treeIn
                                            forKey:@"treeIn"] ;
    }
    
    // More checks for corrupt file.
    if (!error) {
        error = [extoreBar errorIfNotClass:[NSDictionary class]
                                      code:174800
                                     label:@"Bar"
                                priorError:error] ;
    }
    if (!error) {
        error = [extoreMenu errorIfNotClass:[NSDictionary class]
                                       code:174801
                                      label:@"Menu"
                                 priorError:error] ;
    }
    if (!error) {
        error = [extoreUnfiled errorIfNotClass:[NSDictionary class]
                                          code:174802
                                         label:@"Unfiled"
                                    priorError:error] ;
    }
    if (!error) {
        error = [extoreOhared errorIfNotClass:[NSDictionary class]
                                         code:174803
                                        label:@"Ohared"
                                   priorError:error] ;
    }
    
    if (error) {
        ok = NO ;
    }
    
    if (ok) {
        NSIndexSet* hiddenExidsCopy = [hiddenExids copy] ;
        self.exidAssignmentsToAvoid = hiddenExidsCopy ;
        [hiddenExidsCopy release] ;
    }
    [hiddenExids release] ;
    
    *bar_p = extoreBar ;
    *menu_p = extoreMenu ;
    *unfiled_p = extoreUnfiled ;
    *ohared_p = extoreOhared ;
    
    if (error && error_p) {
        *error_p = error ;
    }
    
    return ok ;
}

+ (NSString*)pathForThisHomeProfileName:(NSString*)profileName {
    Class class = [self class] ;
    NSString* path = [NSString applicationSupportPathForHomePath:nil] ;
    path = [path stringByAppendingPathComponent:[class constants_p]->appSupportRelativePath] ;
    path = [path stringByAppendingPathComponent:profileName] ;

    return path ;
}

/* I reverse-engineered the following by using the Twiddle project to test
 all 511 possible combinations of the 9 sensible candidate key paths which I
 thought Opera might be including in its checksum.  These 511 combinations were:
 
 9 candidates containing only 1 of the 9 key paths
 72 candidates containing 2 of the 9 key paths
 candidates containing 3 of the 9 key paths
 candidates containing 4 of the 9 key paths
 candidates containing 5 of the 9 key paths
 candidates containing 6 of the 9 key paths
 candidates containing 7 of the 9 key paths
 candidates containing 8 of the 9 key paths
 1 candidate containing all 9 of the 9 key paths
 
 This test yielded two solutions which gave the same checksum as Opera on the
 same data.  One solution was the following 7 key paths, plus @"custom_root".
 The other solution was the following 7 key paths only.  Of course, I chose the
 latter, simpler one.  The ninth key path, which was always unwanted, is
 @"custom_root.speedDial.children.firstObject".  (In my test case, speedDial
 had only one child.)
 
 I don't understand how the checksum also worked if you included
 @"custom_root".  Although custom_root itself has no checksummed attributes,
 only its children, it seems to me that this would have checksummed in each of
 its four children (custom_root.xxxx) twice, which should have made a different
 checksum.
 */
- (NSArray*)keyPathsInChecksum {
    return  @[
              @"bookmark_bar",
              @"other",
              @"synced",
              @"custom_root.speedDial",
              @"custom_root.trash",
              @"custom_root.unsorted",
              @"custom_root.userRoot",
              ] ;
}

@end

/*
 Note SpeedDialsMisnomer

 The key "speedDials" in the Opera bookmarks file is a misnomer.  It should
 be called, as we do it, the "mother of all speed dials".. This "mother" is
 a JSON object which contains, among its keys, a "childen" object which contains
 the Speed Dial objects for the user's various devices, one of which is for the
 current device, which we call the "local speed dial".
 
 To add to the confusion, the value of the 'name' key in the "mother" is
 typically "Speed Dial", while the value of the 'name' key in the local speed
 dial is the name of the local computer, for example "Air2" or "Jerry's Air".
 However, in Opera, "Speed Dial" is what appears in the user interface as the
 outline root of the local speed dial.
 
 Are they way smarter than me?
 */
