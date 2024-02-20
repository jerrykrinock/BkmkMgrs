#import "ExtoreGooChromy.h"
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


@end
