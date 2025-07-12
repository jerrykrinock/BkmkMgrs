#import "ExtoreGooChromy.h"
#import "NSArray+SSYMutations.h"
#import "NSString+LocalizeSSY.h"
#import "Client+SpecialOptions.h"
#import "GulperImportDelegate.h"
#import "Exporter.h"
#import "Starker.h"
#import "Stark.h"
#import "BkmxDoc.h"
#import "Chaker.h"
#import "NSError+MyDomain.h"
#import "NSError+InfoAccess.h"
#import "NSObject+SSYCheckType.h"
#import "NSString+MorePaths.h"
#import "BkmxBasis.h"

NSString* const folderTypeKey = @"folderType";
NSString* const folderTypeBar = @"bookmarks-bar";
NSString* const folderTypeOther = @"other";


@implementation ExtoreGooChromy

+ (NSString*)labelMenu {
    return [NSString localize:@"004_Chrome_otherBookmarks"] ;
}

+ (NSString*)labelUnfiled {
    return constDisplayNameNotUsed ;
}

- (NSString*)labelUnfiled {
    NSString* answer ;
    if ([[self client] fakeUnfiled]) {
        answer = constReadingUnsortedDisplayName ;
    }
    else {
        answer = [[self class] labelUnfiled] ;
    }
    return answer ;
}

+ (NSString*)labelOhared {
    return constDisplayNameNotUsed ;
}

+ (BOOL)style1Available {
    /* Support for Style 1 was removed from GooChromy in BkmkMgrs 3.2
     because items with the "synced" attribute no longer appear in the
     Bookmarks file in the profile folder, for those Chrome users who
     have upgraded to Chrome's new bookmark syncing.  They are
     only stored in the Cloud! */
    return NO;
}

- (BOOL)style1Available {
    return [[self class] style1Available];
}

- (BOOL)hasUnfiled {
    return [[self client] fakeUnfiled] ;
}

- (NSSet*)hartainersWeEdit {
    return [NSSet setWithObjects:
            @"bookmark_bar",
            @"other",
            nil] ;
}

- (void)doSpecialMappingBeforeExportForExporter:(Exporter*)exporter
                                        bkmxDoc:(BkmxDoc*) bkmxDoc {
    if ([[self client] fakeUnfiled]) {
        // Arm the relevant Chaker in case this is a Style 2 export which will
        // build its JSON from the chaker.
        [exporter setBkmxDoc:bkmxDoc] ;  // Observer will need this
        [[NSNotificationCenter defaultCenter] addObserver:exporter
                                                 selector:@selector(objectWillChangeNote:)
                                                     name:SSYManagedObjectWillUpdateNotification
                                                   object:nil] ; // Nil because must observe any stark
        
        Stark* unfiled = [[self starker] unfiled] ;
        /*
         Tweak the 'unfiled' hartainer, depending on state of 'unfiled'
         -------------------------------------------------------------------------------------------
         State of 'unfiled'     Tweaks we do in the code below:
         ---------------------- --------------------------------------------------------------------
         new with children:     add while chaker active, name, set exid, move to menu, make soft folder
         old with children:     no messages sent to chaker               move to menu, make soft folder
         old without children:  delete normally, via chaker
         new without children:  delete direcly, bypassing chaker
         
         The reason for the difference in the last two is that, in the third
         case, the 'unfiled' folder exists in the browser and must be deleted
         from there, which must be done via the Chaker in case of a Style 2
         export; also, we want this deletion to appear in the sync log.  In the
         fourth case, the 'unfiled' folder was added to the extore at the
         beginning of the export and does not exist in the browser, so we
         don't want to send a command to delete the nonexistent item in case of
         Style 2.  Also, we do not want this deletion to appear in the Sync Log.
         */
        BOOL hasChildren = [[unfiled children] count] > 0 ;
        BOOL isNew = ([unfiled exidForClientoid:([self clientoid])] == nil) ;
        if (hasChildren) {
            if (isNew) {
                [[bkmxDoc chaker] addStark:unfiled] ;
                
                [unfiled setName:constReadingUnsortedDisplayName] ;
                
                NSString* exid = nil ;
                [self getFreshExid_p:&exid
                          higherThan:0
                            forStark:unfiled
                             tryHard:YES] ;
                [unfiled setExid:exid
                    forClientoid:[self clientoid]] ;
            }
            
            Stark* destin = [[self starker] menu];
            if (!destin) {
                // This will happen for Vivaldi
                destin = [[self starker] root];
            }
            [unfiled moveToBkmxParent:destin] ;
            [unfiled setSharypeValue:SharypeSoftFolder] ;
        }
        
        if (!isNew && !hasChildren) {
            [[bkmxDoc chaker] deleteStark:unfiled] ;
            /* The above will also trigger deletion from managed object context
             to occur in -[SSYOperation (Operation_Common) actuallyDelete].
             Deleting now would cause trouble because that would fault its
             attributes which will be needed soon to construct the JSON. */
        }
        
        // Disarm the chaker
        [[NSNotificationCenter defaultCenter] removeObserver:exporter
                                                        name:SSYManagedObjectWillUpdateNotification
                                                      object:nil] ;
        // Back in the beginning of this method, we setBkmxDoc: which
        // was needed by our observer method.  It is not needed any more.
        // It is a weak property.  The following may be defensive programming.
        // We don't want to be hanging on to it, in case it closes later.
        [exporter setBkmxDoc:nil] ;
        
        if (isNew && !hasChildren) {
            [[self starker] deleteObject:unfiled] ;
            /* The above will also trigger deletion from managed object context
             to occur in -[SSYOperation (Operation_Common) actuallyDelete].
             Deleting now would cause trouble because that would fault its
             attributes which will be needed soon to construct the JSON. */
        }
    }
}

// This method is only used when writing bookmarks in Style 1
- (NSMutableDictionary*)newJsonRootsFromBar:(NSDictionary*)bar
                                       menu:(NSDictionary*)menu
                                    unfiled:(NSDictionary*)unfiled
                                     ohared:(NSDictionary*)ohared {
    return [[NSMutableDictionary alloc] initWithObjectsAndKeys:
            bar, @"bookmark_bar",
            menu, @"other",
            nil] ;
    /* Vivaldi does have a "other" folder, but it appears to be an unused
     artifact of the Chromium source.  I can't see any way to put
     anything into it in Vivaldi's user interface.  And if I export something
     into it, I cannot find that something anywhere in Vivaldi's user
     interface. */
}

/* Note that the Extore base class implementation does not
 work for this, because the actual class name is going to
 be "ExtoreChrome" or "ExtoreChromium", etc.. */
+ (NSString*)specialNibName {
    return @"SpecialGooChromy" ;
}

+ (BkmxGrabPageIdiom)peekPageIdiom {
    return BkmxGrabPageIdiomAppleScript ;
}

+ (NSString*)localStateFilePathForHomePath:(NSString*)homePath {
    return [[self browserSupportPathForHomePath:homePath] stringByAppendingPathComponent:@"Local State"] ;
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
    id whatever = nil ;  // Will be dictionary for style1, array for style2
    NSInteger errorCode = 0 ;
    NSString* errorMoreInfo = nil ;
    if ([treeIn isKindOfClass:[NSDictionary class]]) {
        if ((whatever = [treeIn objectForKey:@"roots"])) {
            // Must be Style 1, invoked from -readExternalStyle1ForPolarity::
            if ([whatever respondsToSelector:@selector(objectForKey:)]) {
                extoreBar = [whatever objectForKey:@"bookmark_bar"] ;
                extoreMenu = [whatever objectForKey:@"other"] ;
            }
            else {
                errorCode = 164870 ;
                errorMoreInfo = [NSString stringWithFormat:@"Expected dictionary, got %@", [whatever className]] ;
            }
        }
        else if ((whatever = [treeIn objectForKey:@"children"])) {
            // Must be Style 2 invoked from -readExternalStyle2WithCompletionHandler:
            if ([whatever isKindOfClass:[NSArray class]]) {
                if ([whatever count] >= 1) {
                    NSInteger countOfBars = 0;
                    NSInteger countOfOthers = 0;
                    
                    // Test for dual trees (synced, unsynced) introduced by Google in July 2025
                    for (NSDictionary* hardFolder in whatever) {
                        if ([[hardFolder objectForKey:folderTypeKey] isEqualToString:folderTypeBar]) {
                            countOfBars++;
                        }
                        if ([[hardFolder objectForKey:folderTypeKey] isEqualToString:folderTypeOther]) {
                            countOfOthers++;
                        }
                    }
                    if ((countOfBars > 1) || (countOfOthers > 1)) {
                        self.hasDualTrees = YES;
                        whatever = [self mergeDualTreesInArray:whatever];
                    }
                    extoreBar = [whatever objectAtIndex:0] ;
                    /* Not all browsers have the menu (Brave, Vivaldi) */
                    if ([whatever count] >= 2) {
                        extoreMenu = [whatever objectAtIndex:1] ;
                    }
                    else if ([self hasMenu]) {
                        errorCode = 164876 ;
                        errorMoreInfo = [NSString stringWithFormat:@"Expected menu, but only %ld hartainers", (long)[whatever count]] ;
                    }
                }
                else if ([self hasBar]) {
                    errorCode = 164875 ;
                    errorMoreInfo = [NSString stringWithFormat:@"Expected bar, but only %ld hartainers", (long)[whatever count]] ;
                } else {
                    NSAssert(NO, @"Bar is needed for Limbo in BookMacster Sync extension");
                }
            }
            else {
                errorCode = 164872 ;
                errorMoreInfo = [NSString stringWithFormat:@"Expected array, got %@", [whatever className]] ;
            }
        }
        else {
            errorCode = 164873 ;
            errorMoreInfo = [NSString stringWithFormat:@"Expected 'roots' or 'children', got %@", [whatever allKeys]] ;
        }
    }
    else {
        errorCode = 164874 ;
        errorMoreInfo = [NSString stringWithFormat:@"Expected dictionary, got %@", [treeIn className]] ;
    }
    
    if (errorCode != 0) {
        ok = NO ;
        error = SSYMakeError(errorCode, @"Decoded JSON does not meet expectation") ;
        error = [error errorByAddingUserInfoObject:errorMoreInfo
                                            forKey:@"Details"] ;
    }
    
    if (ok) {
        // More checks for corrupt file.
        error = [extoreBar errorIfNotClass:[NSDictionary class]
                                      code:164800
                                     label:@"Bar"
                                priorError:error] ;
        error = [extoreMenu errorIfNotClass:[NSDictionary class]
                                       code:164801
                                      label:@"Menu"
                                 priorError:error] ;
        if (error) {
            ok = NO ;
        }
    }
    
    *bar_p = extoreBar ;
    *menu_p = extoreMenu ;
    *unfiled_p = nil ;
    *ohared_p = nil ;
    
    if (error && error_p) {
        *error_p = error ;
    }
    
    return ok ;
}

/* Override for the Google Chromes, because if has entered a different name
 in Chrome/Canary's menu > People > Edit…, and/or using Chrome Sync, a
 different name may appear in the menu: People.  I'm not sure if I reverse-
 engineered the algorithm below 100% correctly.

 This does not apply to Chromium, which could just as well use the base class
 implementation, but oh well… */
+ (NSString*)displayProfileNameFromDictionary:(NSDictionary*)dic {
    /* There are three names to choose from, the values for these keys:
     • name
     • gaia_given_name
     • gaia_name
      "gaia" is an acronym for Google Accounts and ID Administration.
     After spending 45 minutes, I gave up trying to determine which name is
     used in Chrome's menu: People.  Seems it should depend on whether or not
     the user is using Chrome Sync, but when user is using Chrome Sync I
     have seen it go with either `name` or `gaia_given_name` in this case.
     For a while, I thought it depended oh the presence `gaia_id`.  All I can
     say for sure is that gaia_name never appears.  So, I give up and show
     both of the others if they are different.
    */
    NSString* name1 = [dic objectForKey:@"gaia_given_name"];
    NSString* name2 = [dic objectForKey:@"name"];
    NSString* name3 = [dic objectForKey:@"gaia_name"];

    NSString* answer;
    if (name1.length > 1) {
        if (name2.length > 1) {
            if ([name1 isEqualToString:name2]) {
                // Case 1.  Has both name1 and name2, and they are the same
                answer = name1;

            } else {
                // Case 2.  Has both name1 and name2, and they are the different
                answer = [NSString stringWithFormat:@"%@ | %@", name1, name2];
            }
        }
        else {
            // Case 3, has name1 but not name2
            answer = name1;
        }
    } else if (name2.length > 1) {
        // Case 4.  has name2 but not name1
        answer = name2;
    } else if (name3.length > 1) {
        // Case 5.  Has neither name1 or name2, but has name3.  Never seen this!
        answer = name3;
    } else {
        // Case 6.  Has none of the tree.  Never seen this!
        answer = @"";
    }

    return answer ;
}

+ (NSString*)pathForThisHomeProfileName:(NSString*)profileName {
    Class class = [self class] ;
    NSString* path = [NSString applicationSupportPathForHomePath:nil] ;
    path = [path stringByAppendingPathComponent:[class constants_p]->appSupportRelativePath] ;
    path = [path stringByAppendingPathComponent:profileName] ;
    
    return path ;
}

/* Another override because Opera does not support multiple user profiles: */
- (OwnerAppRunningState)ownerAppRunningStateError_p:(NSError**)error_p {
    // THIS IS A KLUDGE THAT SHOULD BE HANDLED LOWER IN THE CALL STACK
    // If in Smarky, we want to force the "worst case" of
    // OwnerAppRunningStateRunningProfileAvailable.  The effect of this is to
    // require that, in Smarky, Opera must always be quit during an Import
    // from only > Chrome or Export to only > Chrome.
    if ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppSmarky) {
        return OwnerAppRunningStateRunningProfileAvailable ;
    }
    
    NSError* error = nil ;
    /* When super returns OwnerAppRunningStateRunningProfileAvailable, it only
     means that the app is running.  But that is sufficient for Opera because
     Opera does not suppor muliple user  profiles. */
    OwnerAppRunningState answer = [super ownerAppRunningStateError_p:&error] ;
    
    if (error && error_p) {
        *error_p = error ;
    }
    
    return answer ;
}

- (BOOL)canHaveProfileCrosstalk {
    return YES ;
}

- (NSString*)uninstallInstructionsForExtensionIndex:(NSInteger)extensionIndex {
    NSString* answer = nil;
    if ([[[self class] profileNames] count] > 1) {
        NSString* displayProfileName = [[self class] displayProfileNameForProfileName:[[self clientoid] profileName]];
        answer = [NSString stringWithFormat:
                  @"To uninstall the %@ extension for Person '%@':\n\n"
                  @"• Run %@ and activate a browser window labelled '%@' in the upper right corner.  (Use menu > People if necessary.)\n\n"
                  @"• Click in the menu: Window > Extensions.  A tab with a list of extensions will appear.\n\n"
                  @"• Click the trash can button adjacent '%@' and affirm the removal.",
                  [self extensionDisplayNameForExtensionIndex:extensionIndex],
                  displayProfileName,
                  [self ownerAppDisplayName],
                  displayProfileName,
                  [self extensionDisplayNameForExtensionIndex:extensionIndex]];
    } else {
        answer = [NSString stringWithFormat:
                  @"To uninstall the %@ extension:\n\n"
                  @"• Run %@.\n\n"
                  @"• Click in the menu: Window > Extensions.  A tab with a list of extensions will appear.\n\n"
                  @"• Click the trash can button adjacent '%@' and affirm the removal.\n\n"
                  @"• If you want the extension to be fully removed immediately, you must quit and then relaunch %@.",
                  [self extensionDisplayNameForExtensionIndex:extensionIndex],
                  [self ownerAppDisplayName],
                  [self extensionDisplayNameForExtensionIndex:extensionIndex],
                  [self ownerAppDisplayName]];

    }

    return answer;
}

- (NSArray*)mergeDualTreesInArray:(NSArray*)arrayIn {
    
    NSMutableArray* barChildren = [NSMutableArray new];
    NSMutableArray* otherChildren = [NSMutableArray new];
    
    /* Defensive programming in case this method gets re-run during the lifetime of this extore */
    self.syncedBarId = nil;
    self.syncedOtherId = nil;
    self.localBarId = nil;
    self.localOtherId = nil;
    self.syncedBarChildExids = nil;
    self.syncedOtherChildExids = nil;
    self.localBarChildExids = nil;
    self.localOtherChildExids = nil;
    
    NSDictionary* barSynced = nil;
    NSDictionary* barLocal = nil;
    NSDictionary* otherSynced = nil;
    NSDictionary* otherLocal = nil;

    NSArray* children;
    for (NSDictionary* hardFolder in arrayIn) {
        if (([[hardFolder objectForKey:folderTypeKey] isEqualToString:folderTypeBar])
            && ([[hardFolder objectForKey:constKeySyncing] integerValue] == 1)) {
            barSynced = hardFolder;
            self.syncedBarId = [hardFolder objectForKey:@"id"];
            children = [hardFolder objectForKey:constKeyChildren];
            self.syncedBarChildExids = [[[children valueForKey:@"id"] mutableCopy] autorelease];
        }
        else if (([[hardFolder objectForKey:folderTypeKey] isEqualToString:folderTypeBar])
                 && ([[hardFolder objectForKey:constKeySyncing] integerValue] == 0)) {
            barLocal = hardFolder;
            self.localBarId = [hardFolder objectForKey:@"id"];
            children = [hardFolder objectForKey:constKeyChildren];
            self.localBarChildExids = [[[children valueForKey:@"id"] mutableCopy] autorelease];
        }
        else if (([[hardFolder objectForKey:folderTypeKey] isEqualToString:folderTypeOther])
                 && ([[hardFolder objectForKey:constKeySyncing] integerValue] == 1)) {
            otherSynced = hardFolder;
            self.syncedOtherId = [hardFolder objectForKey:@"id"];
            children = [hardFolder objectForKey:constKeyChildren];
            self.syncedOtherChildExids = [[[children valueForKey:@"id"] mutableCopy] autorelease];
        }
        else if (([[hardFolder objectForKey:folderTypeKey] isEqualToString:folderTypeOther])
                 && ([[hardFolder objectForKey:constKeySyncing] integerValue] == 0)) {
            otherLocal = hardFolder;
            self.localOtherId = [hardFolder objectForKey:@"id"];
            children = [hardFolder objectForKey:constKeyChildren];
            self.localOtherChildExids = [[[children valueForKey:@"id"] mutableCopy] autorelease];
        }
    }
        
    children = [barSynced objectForKey:constKeyChildren];
    if (children.count > 0) {
        [barChildren addObjectsFromArray:children];
    }
    
    children = [barLocal objectForKey:constKeyChildren];
    if (children.count > 0) {
        [barChildren addObjectsFromArray:children];
    }
    
    children = [otherSynced objectForKey:constKeyChildren];
    if (children.count > 0) {
        [otherChildren addObjectsFromArray:children];
    }
    
    children = [otherLocal objectForKey:constKeyChildren];
    if (children.count > 0) {
        [otherChildren addObjectsFromArray:children];
    }
    
    NSNumber* barId = self.syncedBarId ? self.syncedBarId : self.localBarId;
    NSNumber* otherId = self.syncedOtherId ? self.syncedOtherId : self.localOtherId;

    NSMutableArray* mergedArray = [NSMutableArray new];

    NSMutableDictionary* bar = [NSMutableDictionary new];
    if (barChildren.count > 0) {
        [bar setObject:barChildren
                forKey:constKeyChildren];
    }
    [barChildren release];
    [bar setValue:barId
           forKey:@"id"];
    [mergedArray addObject:bar];
    [bar release];
    
    NSMutableDictionary* other = [NSMutableDictionary new];
    if (otherChildren.count > 0) {
        [other setObject:otherChildren
                  forKey:constKeyChildren];
    }
    [otherChildren release];
    [other setValue:otherId
             forKey:@"id"];
    [mergedArray addObject:other];
    [other release];
    
    NSArray* answer = [mergedArray copy];
    [mergedArray release];
    [answer autorelease];
    
    return answer;
}

- (void)restackIndexesInPuts:(NSDictionary*)putsDic
                    perArray:(NSArray*)exidsArray {
    NSInteger index = 0;
    for (NSString* exid in exidsArray) {
        NSMutableDictionary* dic = [putsDic objectForKey:exid];
        [dic setObject:@(index)
                forKey:constKeyIndex];
        index++;
    }
}

- (void)removeFromHardFolderExidArraysExid:(NSString*)exid {
    /* This method could maybe be more efficient if we
     used -indexOfObject and bail out when found.  Or maybe
     that would be less efficient.  Anyhow, since this method
     is only used in the edge case of dual trees, I don't
     care enough to test it. */
    if (exid) {
        /* Onlye one of the following will have any effect. */
        [self.syncedBarChildExids removeObject:exid];
        [self.syncedOtherChildExids removeObject:exid];
        [self.localBarChildExids removeObject:exid];
        [self.localOtherChildExids removeObject:exid];
    }
}

/*!
 @brief     Does the opposite of -mergeDualTreesInArray:
 
 @details   when reading the extore, if there was a dual tree, items from the "local" tree
 were moved into the "synced" tree, and the changes were constructed assuming that there
 is only one tree.  This method is called just before writing, to move the local items back
 into the local tree.
  */
- (NSDictionary*)relocateLocalItemsToLocalHardFoldersInChangesDic:(NSDictionary*)changesDic {
    if (!self.hasDualTrees) {
        return changesDic;
    }
    NSAssert((self.syncedBarId && self.syncedOtherId && self.localBarId && self.localOtherId), @"Assert 485948");
    
    // Update the child counts due to any deletions (cuts)
    NSDictionary* cuts = [changesDic objectForKey:constKeyCuts];
    for (NSDictionary* cut in cuts) {
        NSString* exid = [cut valueForKey:@"id"];
        [self removeFromHardFolderExidArraysExid:exid];
    }

    NSDictionary* puts = [changesDic objectForKey:constKeyPuts];
    NSMutableArray* correctedPutsArray = [NSMutableArray new];
    NSMutableDictionary* correctedPutsDic = [NSMutableDictionary new];
    BOOL didCorrectAny = NO;
    for (NSDictionary* put in puts) {
        NSNumber* parentExid = [put objectForKey:constKeyParentExid];
        
        NSString* exid = [put objectForKey:constKeyExid];
        NSInteger synced = 1;
        for (Stark* stark in [[self starker] allStarks]) {
            NSString* aExid = [stark exidForClientoid:[self clientoid]];
            if ([aExid isEqualToString: exid]) {
                synced = [[stark ownerValueForKey:constKeySyncing] integerValue];
                break;
            }
        }
        
        NSMutableDictionary* correctedPut = nil;

        /* Start out by removing the subject item's exid from the child exid arrays
         of all four hard folders.  If in fact this 'put' is only a 'slide',that exid
         will be restored subsequently. */
        [self removeFromHardFolderExidArraysExid:exid];
        
        NSNumber* correctedParentId = nil;
        if ([parentExid isEqual:self.syncedBarId]) {
            if (synced < 1) {
                correctedParentId = self.localBarId;
                [self.localBarChildExids addObject:exid];
                didCorrectAny = YES;
            } else {
                [self.syncedBarChildExids addObject:exid];
            }
        } else if ([parentExid isEqual:self.syncedOtherId]) {
            if (synced < 1) {
                correctedParentId = self.localOtherId;
                [self.localOtherChildExids addObject:exid];
                didCorrectAny = YES;
            } else {
                [self.syncedOtherChildExids addObject:exid];
            }
        }
        
        correctedPut = [put mutableCopy];
        if (correctedParentId) {
            [correctedPut setObject:correctedParentId
                             forKey:constKeyParentExid];
        }

        [correctedPutsArray addObject:correctedPut];
        [correctedPutsDic setObject:correctedPut
                             forKey:exid];
        [correctedPut release];
    }
    
    if (didCorrectAny) {
        [self restackIndexesInPuts:correctedPutsDic
                          perArray:self.syncedBarChildExids];
        [self restackIndexesInPuts:correctedPutsDic
                          perArray:self.syncedOtherChildExids];
        [self restackIndexesInPuts:correctedPutsDic
                          perArray:self.localBarChildExids];
        [self restackIndexesInPuts:correctedPutsDic
                          perArray:self.localOtherChildExids];
    }

    NSDictionary* answer;
    if (didCorrectAny) {
        NSMutableDictionary* fixedChangesDic = [changesDic mutableCopy];
        [fixedChangesDic setObject:correctedPutsArray
                            forKey:constKeyPuts];
        answer = [fixedChangesDic copy];
        [answer autorelease];
        [fixedChangesDic release];
    } else {
        answer = changesDic;
    }
    
    [correctedPutsArray release];
    [correctedPutsDic release];
    
    return answer;
}

- (void)dealloc {
    [_syncedBarId release];
    [_syncedOtherId release];
    [_localBarId release];
    [_localOtherId release];
    
    [_syncedBarChildExids release];
    [_syncedOtherChildExids release];
    [_localBarChildExids release];
    [_localOtherChildExids release];

    
    [super dealloc];
}

@end
