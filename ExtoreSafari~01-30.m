#import "ExtoreSafari.h"
#import "Stark+Sorting.h"
#import "SSYTreeTransformer.h"
#import "Starker.h"
#import "Client.h"
#import "BkmxAppDel+Capabilities.h"
#import "SSYOtherApper.h"
#import "SSYOperationQueue.h"
#import "BkmxBasis+Strings.h"
#import "NSString+LocalizeSSY.h"
#import "NSError+SSYAdds.h"
#import "NSArray+SSYMutations.h"
#import "NSDictionary+SimpleMutations.h"
#import "Bkmslf.h"
#import "SSYVersionTriplet.h"
#import "NSNumber+Sharype.h"
#import "SSYUuid.h"
#import "SSYOperation.h"
#import "Stange.h"
#import "Chaker.h"
#import "NSBundle+HelperPaths.h"
#import "SSYShellTasker.h"
#import "SafariSyncGuardian.h"
#import "NSObject+MoreDescriptions.h"
#import "SSYProgressView.h"
#import "NSError+SSYAdds.h"

NSString* const constKeySafariSyncInfo = @"SyncInfo" ;

NSString* const constKeySafariWebBookmarkIdentifier = @"WebBookmarkIdentifier" ;
NSString* const constKeySafariReadingListDic = @"ReadingList" ;
NSString* const constKeySafariReadingListNonSyncDic = @"ReadingListNonSync" ;
NSString* const constKeySafariReadingListIdentifier = @"com.apple.ReadingList" ;
NSString* const constKeySafariUriDictionary = @"URIDictionary" ;
NSString* const constKeySafariSync_Root = @"Sync" ;  // Apple uses the same key in two different dics
NSString* const constKeySafariSync_Item = @"Sync" ;  // but I'd like to keep the separate for clarity
NSString* const constKeySafariServerData = @"ServerData" ;

NSString* const constKeySafariDavServerID = @"ServerID" ;

NSString* const constKeySafariDavChanges = @"Changes" ;
NSString* const constKeySafariDavChangeType = @"Type" ;
NSString* const constKeySafariDavChangeTypeAdd = @"Add" ;
NSString* const constKeySafariDavChangeTypeModify = @"Modify" ;
NSString* const constKeySafariDavChangeTypeDelete = @"Delete" ;
NSString* const constKeySafariDavChangeToken = @"Token" ;
NSString* const constKeySafariDavChangedBookmarkType = @"BookmarkType" ;
NSString* const constKeySafariDavChangedBookmarkTypeFolder = @"Folder" ;
NSString* const constKeySafariDavChangedBookmarkTypeBookmark = @"Leaf" ;
NSString* const constKeySafariDavChangedBookmarkServerID = @"BookmarkServerID" ;
NSString* const constKeySafariDavChangedBookmarkUuid = @"BookmarkUUID" ;

// Key used in my change records dictionary, used for culling unnecessary slides
NSString* const constKeyStangesIndex = @"stangesIndex" ;
NSString* const constKeyInOrOut = @"inOrOut" ;

#define ExtoreSafariMoveIn YES
#define ExtoreSafariMoveOut NO
typedef BOOL ExtoreSafariMoveInOrOut ;

NSString* const constScriptSafariGetFrontUrl = @"tell application \"Safari\" to get URL of front document" ;
NSString* const constScriptSafariWipeFrontTab = @"tell application \"Safari\" to set URL of front document to \"\"" ;
//NSString* const constScriptSafariRestoreShowingBookmarks = @"tell application \"Safari\" to set URL of front document to \"bookmarks://\"" ;
NSString* const constScriptSafariGetFrontTab = @"tell application \"Safari\" to get current tab of front window" ;
NSString* const constAboutBlankUrl = @"about:blank" ;

static const ExtoreConstants extoreConstants = {
	/* canEditAddDate */                  NO,
	/* canEditComments */                 NO,
	/* canEditFavicon */                  NO,
	/* canEditFaviconUrl */               NO,
	/* canEditIsAutoTab */                YES,
	/* canEditIsExpanded */               NO,
	/* canEditIsShared */                 NO,
	/* canEditLastChengDate */            NO,
	/* canEditLastModifiedDate */         NO,
	/* canEditLastVisitedDate */          NO,
	/* canEditName */                     YES,
	/* canEditRating */                   NO,
	/* canEditRssArticles */              NO,
	/* canEditShortcut */                 NO,
	/* canEditTags */                     NO,
	/* canEditUrl */			          YES,
	/* canEditVisitCount */               NO,
	/* canCreateNewDocuments */           YES,
	/* ownerAppDisplayName */             @"Safari",
	/* webHostName */                     nil,
	/* authorizationMethod */             BkmxAuthorizationMethodNone,
	/* accountNameHint */                 nil,
	/* oAuthConsumerKey */                nil,
	/* oAuthConsumerSecret */             nil,
	/* oAuthRequestTokenUrl */            nil,
	/* oAuthRequestAccessUrl */           nil,
	/* oAuthRealm */                      nil,
	/* appSupportRelativePath */          nil,  // Safari bookmarks are in ~/Library, not in ~/Library/Application Support
	/* defaultFilename */                 @"Bookmarks.plist",
	/* defaultProfileName */              nil,
	/* browserBundleIdentifier1 */        @"com.apple.Safari",
	/* browserBundleIdentifier2 */        nil,
	/* iconResourceFilename */            nil,
	/* iconInternetURL */                 nil,
	/* fileType */                        @"plist",
	/* ownerAppObservability */           OwnerAppObservabilityBookmarksFile,
	/* canPublicize */                    NO,
	/* silentlyRemovesDuplicates */       NO,
	/* normalizesURLs */                  NO,
	/* catchesChangesDuringSave */        NO,
	/* telltaleString */                  @"WebBookmarkType",
	/* hasBar */                          YES,
	/* hasMenu */                         YES,
	/* hasUnfiled */                      YES, // Note 219809
	/* hasOhared */                       NO,
	/* defaultPreferredCatchype */        SharypeRoot,
	/* hartainersTakingAnyStarkBitmap */  SharypeRoot + (SharypeMenu << 4) + (SharypeBar << 8),
	/* tagDelimiter */                    nil,
	/* dateRef1970Not2001 */              NO, // Actually does not apply, since dates are stored as NSDates
	/* betterCheckDupeExids */            NO,
	/* hasOrder */                        YES,
	/* hasFolders */                      YES,
	/* ownerAppIsLocalApp */              YES,
	/* allowsSeparators */                YES,  // using the special BookMacster Hack, or Glims Hack
	/* defaultSpecialOptions */           0x0000000000000000LL,
	/* extensionInstallDirectory */       nil,
	/* minBrowserExtensionVersion */      1,
	/* minBrowserPluginVersion */         0,  // Internet Plugin is not used
	/* minBrowserVersionMajor */          0,
	/* minBrowserVersionMinor */          0,
	/* minBrowserVersionBugFix */         0,
	/* minSystemVersionForBrowsMajor */   0,
	/* minSystemVersionForBrowMinor */    0,
	/* minSystemVersionForBrowBugFix */   0
} ;

/*
 Note 219809.  This is mostly ignored because -hasUnfiled has been overridden.
 It is used in -[BkmxAppDel(Capabilities) exformatsThatHaveSharype:].
 For that reason, it was changed from NO to YES in BookMacster 1.11.
 */

@implementation ExtoreSafari

/* 
 This implementation is the same in all subclasses, but we define it
 in each subclass in order to pick up the static const extoreConstants
 struct which is different in each Extore subclass' implementation file.
*/
+ (const ExtoreConstants *)constants_p {
	return &extoreConstants ;
}

+ (BOOL)parentSharype:(Sharype)parentSharype
  canHaveChildSharype:(Sharype)childSharype {
	BOOL answer ;
	if (parentSharype == SharypeRoot) {
		answer = ((childSharype & (SharypeCoarseHartainer + SharypeCoarseSoftainer + SharypeCoarseLeaf)) > 0) ;
	}
	else if (parentSharype == SharypeUnfiled) {
		answer = ((childSharype & (SharypeCoarseLeaf)) > 0) ;
	}
	else {
		answer = ((parentSharype & (SharypeGeneralContainer)) > 0) ;
	}
	
	return answer ;
}

+ (BkmxIxportTolerance)toleranceForIxportStyle:(NSInteger)ixportStyle {
	BkmxIxportTolerance tolerance = BkmxIxportToleranceAllowsNone ;
	if (ixportStyle == 1) {
		tolerance = BkmxIxportToleranceAllowsReading + BkmxIxportToleranceAllowsWriting ;
	}
	
	return tolerance ;
}

+ (BkmxGrabPageIdiom)peekPageIdiom {
	return BkmxGrabPageIdiomAppleScript ;
}

+ (PathRelativeTo)fileParentPathRelativeTo {
	return PathRelativeToLibrary ;
}

+ (NSString*)fileParentRelativePath {
	return @"Safari" ;
}

- (BOOL)shouldBlindSawChangeTriggerDuringExport:(NSInteger)writeStyle {
	/*
	 Because of the file locking by SafariSyncGuardian, user
	 cannot change Safari bookmarks while we are exporting.
	 Blinding the trigger will eliminate re-importing, unless
	 iCloud Bookmarks Syncing is on.  In that case, re-importing
	 will be required after SafariDAVClient touches the file.
	*/
	
	return YES ;
}

- (BOOL)shouldActuallyDeleteBeforeWriteStyle:(NSInteger)writeStyle {
	return NO ;
}

- (BOOL)isExportableStark:(Stark*)stark
			   withChange:(NSDictionary*)change {
#if IS_EXPORTABLE_STARK_WILL_ALWAYS_RETURN_YES
	return YES  ;
#endif

	if ([stark sharypeValue] == SharypeSmart) {
		return NO ;
	}
	
	// Note: This is the only Extore subclass which does not
	// return NO for -is1PasswordBookmarklet
	
	return YES ;
}

- (BOOL)hasUnfiled {
	/* States of m_hasUntiledTernary:
	  0 = unknown
	 -1 = no
	 +1 = yes
	 */
	if (m_hasUnfiledTernary == 0) {
		if ([[[self client] extoreMedia] isEqualToString:constBkmxExtoreMediaThisUser]) {
			// Use the more reliable method, which looks at the Safari version.
			ExtoreConstants const * extoreConstants_p = [self extoreConstants_p] ;
			if (extoreConstants_p) {
				NSString* bundleIdentifier = extoreConstants_p->browserBundleIdentifier1 ;
				if (bundleIdentifier) {
					NSString* safariVersionString = [SSYVersionTriplet rawVersionStringFromBundleIdentifier:bundleIdentifier] ;
					SSYVersionTriplet* versionTriplet = [SSYVersionTriplet versionTripletFromString:safariVersionString] ;
					if ((([versionTriplet major] >= 5) && ([versionTriplet minor] >=1)) || ([versionTriplet major] > 5)) {
						m_hasUnfiledTernary = 1 ;
					}
				}
			}
		}
		else {
			// Use the less reliable version, which looks at whether or not a
			// Reading List currently exists in the file.  The reason this is
			// not reliable is because a new Safari 5.1+ bookmarks file with
			// no bookmarks in the Reading List will not have a Reading List.
			m_hasUnfiledTernary = -1 ;
			NSError* error = nil ;
			NSDictionary* extoreTree = [self extoreTreeError_p:&error] ;
			if (extoreTree) {		
				for (NSDictionary* rootChild in [extoreTree objectForKey:@"Children"]) {
					NSString* name = [rootChild objectForKey:@"Title"] ;
					if ([name isEqualToString:constKeySafariReadingListIdentifier]) {
						NSString* type = [rootChild objectForKey:@"WebBookmarkType"] ;
						if ([type isEqualToString:@"WebBookmarkTypeList"]) {
							m_hasUnfiledTernary = +1 ;
						}
					}
				}
			}
			else {
				// This will happen if Bkmslf has an Other Mac Account
				// Safari client which is currently not on the LAN.
				// In BookMacster 1.5.6 it logged Internal Error 202-8540.
				m_hasUnfiledTernary = 0 ;
			}			
		}
	}
	
	BOOL answer = (m_hasUnfiledTernary == +1) ;
	return answer ;
}

- (SEL)reformatStarkToExtore {
	return @selector(extoreItemForSafari:) ;
}

//- (SEL)reformatExtoreToBookdog {
//	return @selector(reformatSafariToBkmxForStore:) ;
//}

+ (Stark*)starkFromExtoreNode:(NSDictionary*)dic
					  starker:(Starker*)starker
					clientoid:(Clientoid*)clientoid {
	Stark* stark = nil ;  // We'll return nil if things go wrong
	
    NSString* webBookmarkType = [dic objectForKey:@"WebBookmarkType"] ;
	
	NSString* name = nil;
	NSString* url = nil ;
	NSString* uuid = nil ;
	BOOL isAutoTab = NO ;
	
    if ([webBookmarkType isEqualToString:@"WebBookmarkTypeLeaf"]) {
    	// is a bookmark or separator
		stark = [starker freshStark] ;
		
		// get values from input
    	NSDictionary* uriDic = [dic objectForKey:constKeySafariUriDictionary] ;
		name = [uriDic objectForKey:@"title"] ; // Safari uses "Title" in the outer dic, but "title" in the inner dic
		// Added in BookMacster 1.11.9, after constKeySafariReadingListNonSyncDic was noticed in Safari 6.0.0 (Mac OS X 10.8)
		NSDictionary* readingListDic = [dic objectForKey:constKeySafariReadingListDic] ;
		// Note 652409.  The readingListDic contains three key/value pairs:
		// • DateLastFetched, which is pretty much my lastChengDate
		// • PreviewText, which could be considered my 'comments'
		// • DateAdded (first noticed in Safari 6.0 in Mac OS X 10.8)
		// At one point, I considered decoding these and setting them
		// into stark as such.  But this wouldn't make it through importing
		// unless I also set the values of canEditLastChengDate and 
		// canEditComments in the extoreConstants struct for ExtoreSafari
		// to YES, which means that, when reading a regular bookmark which
		// can *not* have these attributes, they would be treated as
		// intentionally nil when merging bookmarks, thus wiping out 
		// lastChengDate and comment values which had either been imported
		// from other clients or manually entered by the user.  So I
		// decided instead to pass readingListDic as an owner value.
		NSDictionary* readingListNonSyncDic = [dic objectForKey:constKeySafariReadingListNonSyncDic] ;
    	uuid = [dic objectForKey:@"WebBookmarkUUID"] ;
    	url = [dic objectForKey:@"URLString"] ;
		
		// set values in output
    	[stark setExid:uuid
		  forClientoid:clientoid] ;
    	Sharype sharype ;
		if (
			// We're very liberal on detecting separators in Safari; i.e.
			// we don't get -glimsInstalled and match it with the correct
			// separator type.  We feel that this is more robust, since
			// people may install and uninstall Glims, probably quite
			// often since Glims' Safari hacks are so fragile.
			[name isEqualToString:constSeparatorLineForGlims]
			||
			[name isEqualToString:constSeparatorLineForSafariHorizontal]
			||
			[name isEqualToString:constSeparatorLineForSafariVertical]
			) {
			sharype = SharypeSeparator ;
			[stark setName:[[BkmxBasis sharedBasis] labelSeparator]] ;
		}
		else {
			sharype = SharypeBookmark ;
			if (!name) {
				// Nil names cause an exception during export:
				//   NSDictionary: attempt to set object with nil key.
				// I have seen this happen if, for example, Glims is installed,
				// but a non-Glims separator is imported.  The separator detector
				// above will 'else' us to this branch, and name will be nil.
				// This is also defensive programming against corrupt plist files.
				name = [[BkmxBasis sharedBasis] labelNoName] ;
			}
			[stark setName:name] ;
			[stark setUrl:url] ;
		}
		
		if (readingListDic) {
			[stark setOwnerValue:readingListDic
						  forKey:constKeySafariReadingListDic] ;
		}
		
		if (readingListNonSyncDic) {
			[stark setOwnerValue:readingListDic
						  forKey:constKeySafariReadingListNonSyncDic] ;
		}
		
		
		[stark setSharypeValue:sharype] ;
    }
    else if ([webBookmarkType isEqualToString:@"WebBookmarkTypeList"]) {
		// is a container (folder, collection, etc.)
		stark = [starker freshStark] ;
		
        // get values from input
        name = [dic objectForKey:@"Title"] ;  // Safari uses "Title" in the outer dic, but "title" in the inner dic
    	uuid = [dic objectForKey:@"WebBookmarkUUID"] ;
    	if ([dic objectForKey:@"WebBookmarkAutoTab"])
    		isAutoTab = YES ;
		
		// set values in output
    	[stark setName:name] ;
    	[stark setExid:uuid
			   forClientoid:clientoid] ;
    	[stark setIsAutoTab:[NSNumber numberWithBool:isAutoTab]] ;
		// Note that we do not copy children here since we need copies
		// of the children.  This will be done by the deep copier.
		
    	[stark setSharypeValue:SharypeSoftFolder] ;
		// may actually be Root, Bar or Menu but we detect and fix that elsewhere
    }
	
	// So far, I have only seen "WebBookmarkIdentifier" keys in the proxy collections
	// but the name implies they may become more general, so I always check for them.
	NSString* webBookmarkIdentifier = [dic objectForKey:@"WebBookmarkIdentifier"] ;	
	if (webBookmarkIdentifier) {
		[stark setOwnerValue:webBookmarkIdentifier
							 forKey:constKeySafariWebBookmarkIdentifier] ;
	}

	NSDictionary* syncDic = [dic objectForKey:constKeySafariSync_Item] ;
	if (syncDic) {
		[stark setOwnerValue:syncDic
					  forKey:constKeySafariSyncInfo] ;
	}	
	// Note that if dic does not have a "WebBookmarkType", this method will return nil.
	// The sender should omit such a node in constructing the output tree.
	return stark ;
}

- (Stark*)starkFromExtoreNode:(NSDictionary*)dic {
	return [ExtoreSafari starkFromExtoreNode:dic
									 starker:[self starker]
								   clientoid:[[self client] clientoid]] ;
}

- (BOOL)makeStarksFromExtoreTree:(NSDictionary*)treeIn
                         error_p:(NSError**)error_p {
	BOOL ok = YES ;
    NSError* error = nil ;
	
	// The following is necessary to handle a corrupt bookmarks file which has more than
	// BookmarksBar or more than one BookmarkMenu.  We now handle it the way
	// Safari does, which is to interpret the first Bar/Menu read as the real one, and
	// any additional Bar/Menus as Other Collections
	BOOL gotBar = NO ;
	BOOL gotMenu = NO ;
	BOOL gotUnfiled = NO ;
	
	if (![treeIn respondsToSelector:@selector(objectForKey:)]) {
		return NO ;
	}
	NSMutableDictionary* rootAttributes = [treeIn mutableCopy] ;
	if (rootAttributes) {
		[rootAttributes removeObjectForKey:@"Children"] ;
		[[self fileProperties] setObject:rootAttributes
								  forKey:constKeyRootAttributes] ;
		
		NSDictionary* syncInfo = [rootAttributes valueForKey:constKeySafariSync_Root] ;
		if ([syncInfo respondsToSelector:@selector(objectForKey:)]) {
			NSData* data = [syncInfo objectForKey:constKeySafariServerData] ;
			if (data) {
				[[self fileProperties] setObject:data
										  forKey:constKeySafariServerData] ;
			}
		}
	}
	[rootAttributes release] ;
	
	// Stepping through Safari root's children, set aside proxy collections, identify bookmarksBar, bookmarksMenu and other collections
	NSArray* safariAllCollections = [treeIn objectForKey:@"Children"] ;
	NSMutableArray* proxyCollections__ = [NSMutableArray array] ;  // a new, empty, temporary array
	NSDictionary* safariBookmarksBar = nil ;
	NSDictionary* safariBookmarksMenu = nil ;
	NSDictionary* safariBookmarksUnfiled = nil ;
	NSMutableArray* safariOtherRootItems = [NSMutableArray array] ;
	
	NSEnumerator* enu1 = [safariAllCollections objectEnumerator] ;
	NSDictionary* itemAtRoot ;
	
	NSMutableDictionary* fileProperties_ = [self fileProperties] ;
	while ((itemAtRoot = [enu1 nextObject])) {
		NSString* webBookmarkType = [itemAtRoot objectForKey:@"WebBookmarkType"] ;
		if ([webBookmarkType isEqualToString:@"WebBookmarkTypeProxy"]) {
			[proxyCollections__ addObject:itemAtRoot] ;  // stash aside.  atIndex:0 is so they get restored in the same order as we found them.
		}
		else {
			// as of Bookdog 4.2.6 we allow bookmarks at root to support Safari 3.0. 
			NSString* name = [itemAtRoot objectForKey:@"Title"]  ;  // Safari uses "Title" in the outer dic, but "title" in the inner dic 
			if ([name isEqualToString:@"BookmarksBar"]  && !gotBar)
			{
				safariBookmarksBar = itemAtRoot ;
				gotBar = YES ;
				// The following if() guards against a corrupt file
				if (name) {
					[fileProperties_ setObject:name
										forKey:constKeyExtoreDisplayNameOfBar] ;
				}
			}
			else if ([name isEqualToString:@"BookmarksMenu"] && !gotMenu)
			{
				safariBookmarksMenu = itemAtRoot ;
				gotMenu = YES ;
				// The following if() guards against a corrupt file
				if (name) {
					[fileProperties_ setObject:name
										forKey:constKeyExtoreDisplayNameOfMenu] ;
				}
			}
			else if ([name isEqualToString:constKeySafariReadingListIdentifier] && !gotUnfiled)
			{
				safariBookmarksUnfiled = itemAtRoot ;
				gotUnfiled = YES ;
				// The following if() guards against a corrupt file
				if (name) {
					[fileProperties_ setObject:name
										forKey:constKeyExtoreDisplayNameOfUnfiled] ;
				}
			}
			else
			{
				[safariOtherRootItems addObject:itemAtRoot] ;
			}
		}
	}
	
	// Copy the extracted proxy collections into a retained instance variable
	NSArray* proxyCollections_ = [NSArray arrayWithArray:proxyCollections__] ; // make immutable copy
	[fileProperties_ setObject:proxyCollections_ forKey:constKeyProxyCollections] ;
	
	// Data integrity test.  Safari files must have a bar and a menu.
	// Only files from Safari 5.1+, however, will have unfiled aka Reading List
	ok = safariBookmarksBar && safariBookmarksMenu ;
	
	if (!safariBookmarksBar) {
        ok = NO ;
        error = SSYMakeError(267563, @"Safari bookmarks missing bar") ;
        goto end ;
    }

	if (!safariBookmarksMenu) {
        ok = NO ;
        error = SSYMakeError(267564, @"Safari bookmarks missing menu") ;
        goto end ;
    }
    
    // Create a transformer which we will use to create our collections from Safari's
    SSYTreeTransformer* transformer = [SSYTreeTransformer
                                       treeTransformerWithReformatter:@selector(modelAsStarkInStartainer:)
                                       childrenInExtractor:@selector(childrenWithUppercaseC)
                                       newParentMover:@selector(moveToBkmxParent:)
                                       contextObject:self] ;
    
    Stark* rootOut = [[self starker] freshStark] ;
    [rootOut setSharypeValue:SharypeRoot] ;
    Stark* barOut = [transformer copyDeepTransformOf:safariBookmarksBar] ;
    Stark* menuOut = [transformer copyDeepTransformOf:safariBookmarksMenu] ;
    Stark* unfiledOut = [transformer copyDeepTransformOf:safariBookmarksUnfiled] ;
    
    // Added in BookMacster 1.7.3
    BOOL shouldHaveUnfiled = [self hasUnfiled] ;
    NSNumber* unfiledSharype = [NSNumber numberWithSharype:SharypeUnfiled] ;
    BOOL doesHaveUnfiled = (unfiledOut != nil) ;
    if (shouldHaveUnfiled && !doesHaveUnfiled) {
        unfiledOut = [[self starker] freshStark] ;
        [unfiledOut setSharype:unfiledSharype] ;
        [unfiledOut moveToBkmxParent:rootOut] ;
        [unfiledOut setExid:[SSYUuid uuid]
               forClientoid:[[self client] clientoid]] ;
        [unfiledOut retain] ;
    }
    
    for (Stark* otherIn in safariOtherRootItems) {
        Stark* otherOut = [transformer copyDeepTransformOf:otherIn] ;
        [otherOut moveToBkmxParent:rootOut] ;
        [otherOut release] ;
    }
    
    // Set instance variables
    [rootOut assembleAsTreeWithBar:barOut
                              menu:menuOut
                           unfiled:unfiledOut
                            ohared:nil] ;
    [barOut release] ;
    [menuOut release] ;
    [unfiledOut release] ;

end:
    if (error_p && error) {
        *error_p = error ;
    }

	return ok ;
}

- (NSTimeInterval)timeoutForIcloudWithBkmslf:bkmslf {
#if 0
#warning iCloud timeout is set to special value for testing
	return 200.0 ;
#endif
	NSTimeInterval timeout ;
	if ([bkmslf currentPerformanceType] == BkmxPerformanceTypeUser) {
		// We are in Main App, not scripted.  The user has commanded an
		// export and is sitting and wondering why it's taking so long.
		timeout = 15.0 ;
	}
	else {
		// We are either in Worker, or in Main App but scripted.
		
		// On 20100129, Greta Søderlund <ovre.frydendal@gmail.com> reported
		// that this error occurred with an Agent timeout of 20.0 seconds.
		// (Note that this was before iCloud, so the error must have been
		// SafariSyncGuardianResultFailedLockInUseByOther.
		// On 20111129, I noted that iCloud took 420 seconds to upload my
		// 1500 bookmarks.
		timeout = 1200.0 ;
	}
	
	return timeout ;
}

/*!
 @details  Warning.  This method runs in a secondary thread.
 */
- (BOOL)processGuardianResult:(SafariSyncGuardianResult)result
					 polarity:(BkmxIxportPolarity)polarity
				  yieldeeName:(NSString*)yieldeeName
					  timeout:(NSTimeInterval)timeout
						 info:(NSMutableDictionary*)info {
	BOOL ok ;
	NSInteger errorCode ;
	NSString* reason ;
	NSString* suggestion ;
	switch (result) {
		case SafariSyncGuardianResultSucceeded:
			ok = YES ;
			errorCode = 0 ;
			break;
		case SafariSyncGuardianResultFailedLockInUseByOther:
			ok = NO ;
			errorCode = 613901 ;
			reason = [NSString localizeFormat:
					  @"bookmarksBusyX",
					  yieldeeName] ;
			suggestion = [NSString localizeFormat:
						  @"retryInX",
						  10]  ;
			break ;
		case SafariSyncGuardianResultFailedIcloudIsSyncing:
			ok = NO ;
			errorCode = 613902 ;
			NSString* importOrExport = (polarity == BkmxIxportPolarityImport) ? [[BkmxBasis sharedBasis] labelImport] : [[BkmxBasis sharedBasis] labelExport] ;
			reason = [NSString localize:@"bookmarksBusyIcloud"] ;
			suggestion = [NSString stringWithFormat:
						  @"Wait a minute, then retry the operation by clicking in the menu: File > %@ to one Client > Safari.",
						  importOrExport] ;
			break ;
		default:
			ok = NO ;
			errorCode = 613903 ;
			reason = nil ;
			suggestion = nil ;
			NSLog(@"Internal Error 238-3785") ;
			break ;
	}
	
	if (errorCode != 0) {
		NSError* error = SSYMakeError(errorCode, [NSString localize:@"couldNotWriteFile"]) ;
		error = [error errorByAddingLocalizedFailureReason:reason] ;
		error = [error errorByAddingUserInfoObject:[NSNumber numberWithDouble:timeout]
											forKey:@"Waited for seconds"] ;
		error = [error errorByAddingUserInfoObject:[[BkmxBasis sharedBasis] labelImport]
											forKey:@"Polarity"] ;
		Bkmslf* bkmslf = [info objectForKey:constKeyDocument] ;
		if (NSApp && ![[bkmslf operationQueue] scriptCommand]) {
			error = [error errorByAddingLocalizedRecoverySuggestion:suggestion] ;
		}
		
		[info setValue:error
				forKey:constKeyError] ;
	}
	
	[info setObject:[NSNumber numberWithBool:ok]
			 forKey:constKeySucceeded] ;
	
	return (errorCode == 0) ;
}

- (void)displayProgressWithYieldee:(NSString*)yieldee
						  userInfo:(NSDictionary*)userInfo {
	if (!NSApp) {
		return ;
	}
	
	NSString* readingOrWriting = [userInfo objectForKey:constKeyActionName] ;
	Bkmslf* bkmslf = [userInfo objectForKey:constKeyDocument] ;
	NSString* message = [NSString stringWithFormat:
						 @"%@ Safari : Waiting for updates by %@",
						 [readingOrWriting capitalizedString],
						 yieldee] ;
	SSYProgressView* progressView = [bkmslf progressView] ;
		[progressView setIndeterminate:YES
					 withLocalizedVerb:message] ;
}

- (void)prepareBrowserForImportWithInfo:(NSMutableDictionary*)info {
	// We want the "An Agent's Worker is currently syncing possible changes…"
	// sheet to block the document window, but we don't need to block the main
	// thread, which we are now on.  This operation has a handy callback,
	// which we laboriously designed for Google Bookmarks login.  So, we
	// take advantage of that now by running this on a secondary thread…
	[NSThread detachNewThreadSelector:@selector(prepareBrowserForImportThreadedWithInfo:)
							 toTarget:self
						   withObject:info] ;
}

/*!
 @details  Warning.  This method runs in a secondary thread.
*/
- (void)prepareBrowserForImportThreadedWithInfo:(NSMutableDictionary*)info {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
	// Since this branch only executes if extoreMedia is constBkmxExtoreMediaThisUser,
	// we use this:
	NSString* directory = [[self client] filePathParentError_p:NULL] ;
	// instead of this:
	// NSString* path = [[self workingFilePathError_p:NULL] stringByDeletingLastPathComponent] ;
	// although both should give the same answer
	
	Bkmslf* bkmslf = [info objectForKey:constKeyDocument] ;

	NSTimeInterval timeout = [self timeoutForIcloudWithBkmslf:bkmslf] ;
	NSString* yieldeeName = nil ;
	NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
							  @"reading", constKeyActionName,
							  bkmslf, constKeyDocument,
							  nil] ;
	SafariSyncGuardianResult result = [SafariSyncGuardian blockUntilSafeToWriteInDirectory:directory
																				   timeout:timeout
																			 yieldeeName_p:&yieldeeName
																	  progressUpdateTarget:self
																				  selector:@selector(displayProgressWithYieldee:userInfo:)
																				  userInfo:userInfo
																		progressDoneTarget:[bkmslf progressView]
																				  selector:@selector(clearAll)] ;
	
	[self processGuardianResult:result
					   polarity:BkmxIxportPolarityImport
					yieldeeName:yieldeeName
						timeout:timeout
						   info:info] ;
	
	// Because the lock was locked on the main thread, we must
	// unlock it on the main thread.
	[self performSelectorOnMainThread:@selector(sendIsDoneMessageFromInfo:)
						   withObject:info
						waitUntilDone:NO] ;
	
	[pool release] ;
}

/*
 Prior to BookMacster 1.9.8, this method was named -prepareBrowserForWritingWithInfo:error_p,
 and it was invoked by operation selector -prepareBrowserForWriting which was queued to
 run *after* merging.  That was bad because iCloud or Safari could write changes to bookmarks
 between -readExternal and -prepareBrowserForWritingWithInfo:error_p and these changes would
 be overwritten.  By making this -prepareBrowserForExportWithInfo:error_p: instead, it is
 invoked by the operation selector -prepareBrowserForExport, which runs *before* readExternal.
 The disadvantage of this is that we are now locking the Bookmarks.plist file for a longer
 time, in fact, for our entire import, merge, and export.  But that's the way it goes if
 you want to do things correctly.  When you're working on data as though it is constant, you
 need to keep others from touching it.   However, an advantage of this, besides the fact that
 it is leakproof, is that we can now blind the trigger so that we are not retriggered by our
 own touching of the file.  Here's how it works:
 
 Lock the file
 Read the file (readExternal)
 Merge, sort, whatever
 Blind the trigger, in -[OperationExport prepareTriggersForExportStyle:]
 Write the file
 Wait 2.5 seconds due to launchd bug
 Unblind the trigger, in -[OperationExport writeAndDeleteDidSucceed_unsafe]
 Remove the lock
 
 See, no leaks and no false self-triggering
 */
 - (BOOL)prepareBrowserForExportWithInfo:(NSMutableDictionary*)info
								 error_p:(NSError**)error_p {
	if (![[[self client]  extoreMedia] isEqualToString:constBkmxExtoreMediaThisUser]) {
		[self sendIsDoneMessageFromInfo:info] ;
		
		return YES ;
	}
	 
     NSError* error = nil ;
     OwnerAppRunningState runningState = [self ownerAppRunningStateError_p:&error] ;
     if (runningState == OwnerAppRunningStateError) {
         if (error_p && error) {
             *error_p = error ;
         }
         
         return NO ;
     }
	 else if (runningState != OwnerAppRunningStateNotRunning) {
         // Safari is running
		 NSString* source = @"tell application \"Safari\" to get url of front document" ;
		 NSAppleScript* script = [[NSAppleScript alloc] initWithSource:source] ;
		 NSString* frontUrl = [[script executeAndReturnError:NULL] stringValue] ;
		 [script release] ;
		 BOOL blankIt = [frontUrl hasPrefix:@"bookmarks://"] ;
		 if (blankIt) {
			 source = [NSString stringWithFormat:
					   @"tell application \"Safari\" to set URL of front document to \"%@\"",
					   constAboutBlankUrl] ;
			 script = [[NSAppleScript alloc] initWithSource:source] ;
			 [script executeAndReturnError:NULL] ;
			 [script release] ;
			 
			 [info setObject:[NSNumber numberWithBool:YES]
					  forKey:constKeyDidUnshowAllBookmarks] ;
		 }			
	 }
	 
	 // We want the "An Agent's Worker is currently syncing possible changes…"
	 // sheet to block the document window, but we don't need to block the main
	 // thread, which we are now on.  This operation has a handy callback, so, we
	 // take advantage of that now by running this on a secondary thread…
	 [NSThread detachNewThreadSelector:@selector(prepareBrowserForExportThreadedWithInfo:)
							  toTarget:self
							withObject:info] ;
	 
	 return YES ;
 }
	 
/*!
 @details  Warning.  This method runs in a secondary thread.
 */
- (void)prepareBrowserForExportThreadedWithInfo:(NSMutableDictionary*)info {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init] ;
	
	BOOL ok = YES ;
	 
	 // Prior to BookMacster 1.9.8, the following code was inside the above "Safari is running"
	 // branch, so that SafariSyncGuardian was only consulted in Safari was running.  This
	 // was incorrect, for SafariDAVClient in particular, because SafariDAVClient can keep
	 // running long after Safari as been quit.
	 
	 // Since this branch only executes if extoreMedia is constBkmxExtoreMediaThisUser,
	 // we use this:
	 NSString* directory = [[self client] filePathParentError_p:NULL] ;
	 // instead of this:
	 // NSString* path = [[self workingFilePathError_p:NULL] stringByDeletingLastPathComponent] ;
	 // although both should give the same answer
	 // Now we apply a file lock.
	 // See "STUDY OF SAFARI FILE LOCKS", below for more info
	 
	Bkmslf* bkmslf = [info objectForKey:constKeyDocument] ;
	SSYProgressView* progressView = [bkmslf progressView] ;
	// Yes, SSYProgressView is thread-safe.
	if (NSApp) {
		[progressView setIndeterminate:YES
					 withLocalizedVerb:@"Waiting for iCloud to finish before writing Safari"] ;
	}
	
	NSTimeInterval timeout = [self timeoutForIcloudWithBkmslf:bkmslf] ;
	
	NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
							  @"writing", constKeyActionName,
							  bkmslf, constKeyDocument,
							  nil] ;
	NSString* yieldeeName = nil ;

	SafariSyncGuardianResult result = [SafariSyncGuardian blockUntilSafeToWriteInDirectory:directory
																				   timeout:timeout
																			 yieldeeName_p:&yieldeeName
																			progressUpdateTarget:self
																				  selector:@selector(displayProgressWithYieldee:userInfo:)
																				  userInfo:userInfo
																		progressDoneTarget:[bkmslf progressView]
																				  selector:@selector(clearAll)] ;
	ok = [self processGuardianResult:result
							polarity:BkmxIxportPolarityExport
						 yieldeeName:yieldeeName
							 timeout:timeout
								info:info] ;
	
	if (ok) {
		BOOL acquireLockThisTime = [[info objectForKey:constKeySecondPrep] boolValue] ;
		if (acquireLockThisTime) {
			[SafariSyncGuardian abscondLockForDirectory:directory] ;
			NSMutableArray* directories = [info objectForKey:constKeySafariLockDirectories] ;
			if (!directories) {
				directories = [NSMutableArray array] ;
				[info setObject:directories
						 forKey:constKeySafariLockDirectories] ;
			}
			[directories addObject:directory] ;
		}
	}
	
	// Because the lock was locked on the main thread, we must
	// unlock it on the main thread.
	[self performSelectorOnMainThread:@selector(sendIsDoneMessageFromInfo:)
						   withObject:info
						waitUntilDone:NO] ;
	
	[pool release] ;
}

- (void)restoreBrowserStateInfo:(NSMutableDictionary*)info {
	if ([[info objectForKey:constKeyDidUnshowAllBookmarks] boolValue]) {
		/* The timeout of 5 seconds in the following script was added in BookMacster 1.9.8.
		 The problem was that if, at the beginning of the export, the user was showing
		 "Show All Bookmarks" in Safari, 
		 */
		NSString* source = [NSString stringWithFormat:
							/**/  @"with timeout 5 seconds\n"
							/**/     @"tell application \"Safari\"\n"
							/**/        @"repeat with aTab in every tab of front window\n"
							/**/           @"set aUrl to (URL of aTab) as string\n"
							/**/           @"if aUrl is \"%@\" then\n"
							/**/              @"set URL of aTab to \"bookmarks://all\"\n"
							/**/              @"exit repeat\n"
							/**/           @"end if\n"
							/**/        @"end repeat\n"
							/**/     @"end tell\n"
							/**/  @"end timeout\n",
							constAboutBlankUrl] ;
		// There seems to be a bug in Safari, that if you set the URL of a tab
		// to "bookmarks://", the bookmarks are shown but the address bar
		// still shows whatever the page was before, which is constAboutBlankUrl
		// in this case.  By appending anything to "bookmarks://", this
		// will appear in the address bar.  I append the word "all" because
		// it's short and kind of makes sense.  Fixed in BookMacster 1.9.8.
		NSAppleScript* script = [[NSAppleScript alloc] initWithSource:source];
		NSDictionary* errorInfo = nil ;
		[script executeAndReturnError:&errorInfo] ;
		if (errorInfo != nil) {
			NSLog(@"Warning 199-3847 %@", errorInfo) ;
		}
		[script release] ;
	}
}


- (void)processExportChangesForOperation:(SSYOperation*)operation {
	if (NSAppKitVersionNumber < 1100) {
		// SafariDAVClient is only available in Lion+
		return ;
	}
	
	NSMutableDictionary* rootAttributes = [[self fileProperties] objectForKey:constKeyRootAttributes] ;
	NSMutableDictionary* syncInfo = [[[rootAttributes valueForKey:constKeySafariSync_Root] mutableCopy] autorelease] ;
	
	if (!syncInfo) {
		// iCloud is not enabled.  (When you enable iCloud, "Sync" key gets added to
		// Bookmarks.plist.  When you disable iCloud, "Sync" key is removed.
		return ;
	}

	NSString* const constOldExid = @"Old-Exid" ;
	Chaker* chaker = [(Bkmslf*)[[operation info] objectForKey:constKeyDocument] chaker] ;
	NSMutableArray* deletingStarks = [[NSMutableArray alloc] init] ;
	NSMutableArray* addAndModifyChanges = [[NSMutableArray alloc] init] ;
	Clientoid* actualClientoid = [[self client] clientoid] ;
	// This is used to stash the old exid for a "Delete" change…
	Clientoid* dummyClientoid = [Clientoid clientoidThisUserWithExformat:constExformatSafari
															 profileName:constOldExid] ;
	NSString* bookmarkServerId ;
	NSString* bookmarkType ;

	NSMutableArray* stangesArray = [[[chaker stanges] allValues] mutableCopy] ;
	[stangesArray sortUsingSelector:@selector(compareStarkPositions:)] ;
		
#if 0
#warning Culling redundant slides…
#define CULLING_REDUNDANT_SLIDES 1
#endif
	
#if CULLING_REDUNDANT_SLIDES
	/* In BookMacster 1.11, I noticed a problem with iCloud, which is that
	 if we put moves which are not necessary into the addAndModifyChanges,
	 (which get added into 'changes'), iCloud will apparently reject our change
	 and overwrite whatever we did, restoring from the cloud.  Here's a
	 simple example of what I mean by "not necessary".  Say that we start
	 with three bookmarks in a folder: B, C, A, in that order.  Now we 
	 sort, so that the order is A, B, C.  Our stangesArray will have 3
	 entries, one for the index change of each bookmark.  But iCloud will
	 reject it if we put three entries in the Changes dictionary.
	 Note that this change can be described with only one change, moving
	 A to index 0, assuming that iCloud is smart enough to displace B
	 and C as required to make room.  This is what iCloud wants.  Let's
	 consider a more complicated example.  We start out with 10 bookmarks
	 named a-j in a folder, then make some changes
	    INDEX  BEFORE  AFTER
	      0      a       a  
	      1      b       b  
	      2      c       r  
	      3      d       c  
	      4      e       d  
	      5      f       f  
	      6      g       e  
	      7      h       s  
	      8      i       g  
	      9      j       h  
	     10              j
	 (Note that we ended up with 11 bookmarks, 1 more than we started with).
	 Now there are only 3 bookmarks which did not change their indexes:
	 a, b and f.  So we will have 11-3=8 stanges with index changes.
	 However, we didn't make 8 changes.  We only made 4:
	 • Moved or moshed in bookmark r from another folder, at index 2
	 • Slid or sloshed bookmark d from index 3 to index 4
	 • Inserted a new bookmark s at index 7
	 • Deleted, moved out, or moshed out bookmark i.
	 These 4 changes will exist in stangesArray.  However, there
	 will also be a number of subordinate slides…
	 • Slid c from 2 to 3
	 • Slid e from 4 to 6
	 • Slid g from 6 to 8
	 • Slid h from 7 to 9
	 • Slid j from 9 to 10
	 We must either not add these subordinate slides, or else add them
	 and then cull them out.  I think that the former is impossible
	 */
	
	// Find redundant slide stanges which would create redundant changes
	// in our output, which would cause SafariDAVClient to reject our work
	// Find Redundant Slide Stanges Step 1.  Build a dictionary of families whose children may be
	// referenced by stanges of type slide that should be ignored.
	NSMutableDictionary* slipInsForFindingRedundantSlides = [[NSMutableDictionary alloc] init] ;
	NSMutableDictionary* slipOutsForFindingRedundantSlides = [[NSMutableDictionary alloc] init] ;
	NSMutableDictionary* slideInsForFindingRedundantSlides = [[NSMutableDictionary alloc] init] ;
	/*
	   move(In|Out)sForFindingRedundantSlides looks like this:
	     key: parentId, starkid of parent
	     value: familyDic
	       key: index, the (new) index of the stark of the stange
	       value: stange index, the relevant index in stanges
	 */
	NSInteger stangeIndex = 0 ;
	NSMutableSet* parentsWithSlides = [[NSMutableSet alloc] init] ;
	for (Stange* stange in stangesArray) {
		SSYModelChangeAction changeType = [stange changeType] ;
		BOOL doesSlipIn = (
						   (changeType == SSYModelChangeActionInsert)
						   || (changeType == SSYModelChangeActionMove)
						   || (changeType == SSYModelChangeActionMosh)
						   ) ;
		BOOL doesSlipOut = (
							(changeType == SSYModelChangeActionRemove)
							|| (changeType == SSYModelChangeActionMove)
							|| (changeType == SSYModelChangeActionMosh)
							) ;
		BOOL doesSlide = (
						  (changeType == SSYModelChangeActionSlide)
						  || (changeType == SSYModelChangeActionSlosh)
							) ;
		
		if (doesSlipIn || doesSlipOut || doesSlide) {
			Stark* stark = [stange stark] ;
			
			if (doesSlipIn) {
				NSString* parentId = [[stark parent] starkid] ;
				NSMutableIndexSet* slipIns = [slipInsForFindingRedundantSlides objectForKey:parentId] ;
				if (!slipIns) {
					slipIns = [[NSMutableIndexSet alloc] init] ;
					[slipInsForFindingRedundantSlides setObject:slipIns
														  forKey:parentId] ;
					[slipIns release] ;
				}
				
				[slipIns addIndex:[[stark index] integerValue]] ;
			}
		
			if (doesSlipOut) {
				NSString* oldParentId = [[stange oldParent] starkid] ;
				if (oldParentId) {
					NSMutableIndexSet* slipOuts = [slipOutsForFindingRedundantSlides objectForKey:oldParentId] ;
					if (!slipOuts) {
						slipOuts = [[NSMutableIndexSet alloc] init] ;
						[slipOutsForFindingRedundantSlides setObject:slipOuts
															  forKey:oldParentId] ;
						[slipOuts release] ;
					}
					
					NSNumber* oldIndex = [stange oldIndex] ;
					if (oldIndex) {
						[slipOuts addIndex:[oldIndex integerValue]] ;
					}
				}
				else {
					NSLog(@"Internal Error 624-2934 %@", stange) ;
				}
			}

			if (doesSlide) {
//				// Slide implies a slipOut for this parent
				NSString* parentId = [[stark parent] starkid] ;
//				NSString* oldParentId = [[stange oldParent] starkid] ;
//
//				NSMutableIndexSet* slipOuts = [slipOutsForFindingRedundantSlides objectForKey:parentId] ;
//				if (!slipOuts) {
//					slipOuts = [[NSMutableIndexSet alloc] init] ;
//					[slipOutsForFindingRedundantSlides setObject:slipOuts
//														  forKey:oldParentId] ;
//					[slipOuts release] ;
//				}
//				
//				NSNumber* oldIndex = [stange oldIndex] ;
//				if (oldIndex) {
//					[slipOuts addIndex:[oldIndex integerValue]] ;
//				}
//				
//				// And a slipIn
//				NSMutableIndexSet* slipIns = [slipInsForFindingRedundantSlides objectForKey:parentId] ;
//				if (!slipIns) {
//					slipIns = [[NSMutableIndexSet alloc] init] ;
//					[slipInsForFindingRedundantSlides setObject:slipIns
//														 forKey:parentId] ;
//					[slipIns release] ;
//				}
//				
//				[slipIns addIndex:[[stark index] integerValue]] ;
				
				// Slide also implies a slideIn for this parent
				NSMutableDictionary* familyDic = [slideInsForFindingRedundantSlides objectForKey:parentId] ;
				if (!familyDic) {
					familyDic = [[NSMutableDictionary alloc] init] ;
					[slideInsForFindingRedundantSlides setObject:familyDic
														  forKey:parentId] ;
					[familyDic release] ;
				}
				
				[familyDic setObject:[NSNumber numberWithInteger:stangeIndex]
							  forKey:[stange oldIndex]] ;
			}

		}
		stangeIndex++ ;
	}

	// Finding Redundant Slides Step 2.  Build an index set of stanges which should be ignored
	NSIndexSet* allIndexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, NSIntegerMax)] ;
	NSMutableIndexSet* indexesOfRedundantSlideStanges = [[NSMutableIndexSet alloc] init] ;
	for (NSString* parentId in slideInsForFindingRedundantSlides) {
		NSDictionary* slideIns = [slideInsForFindingRedundantSlides objectForKey:parentId] ;
		NSIndexSet* slipIns = [slipInsForFindingRedundantSlides objectForKey:parentId] ;
		NSIndexSet* slipOuts = [slipOutsForFindingRedundantSlides objectForKey:parentId] ;
		NSInteger maxIndexOfConcern = 0 ;
		for (NSNumber* index in [slideIns allKeys]) {
			maxIndexOfConcern = MAX(maxIndexOfConcern, [index integerValue]) ;
		}
		NSMutableIndexSet* availableIndexes = [allIndexSet mutableCopy] ;
		[availableIndexes removeIndexes:slipIns] ;
		for (NSInteger i=0; i<=maxIndexOfConcern; i++) {
			
			/* At any index, we can have a slipOut, or not, and either 
			 a slipIn, or a slideIn, or neither 'in'.  2*3=6 cases…
			   Case  slipOut  slipIn  slideIn
			     1       Y       Y             Let nextIndex++
			     2       Y               Y     Let nextIndex++
			     3       Y                     Cancel nextIndex++ with nextIndex--
			     4               Y             Let nextIndex++
			     5                       Y     Let nextIndex++
			     6                             Normal case, no change.  Let nextIndex++
			 */
//			if ([slipIns containsIndex:i]) {
//				offsetDueToChangesAbove++ ;
//			}
//			if ([slipOuts containsIndex:i]) {
//				offsetDueToChangesAbove-- ;
//			}
			
			NSNumber* candidateSlideIndexObject = [slideIns objectForKey:[NSNumber numberWithInteger:i]] ;
			NSInteger candidateStangeIndex ;
			if (candidateSlideIndexObject) {
				Stange* slideInStange = nil ;
				if (candidateSlideIndexObject) {
					candidateStangeIndex = [candidateSlideIndexObject integerValue] ;
					slideInStange = [stangesArray objectAtIndex:candidateStangeIndex] ;
				}
				if (slideInStange) {
					SSYModelChangeAction changeType = [slideInStange changeType] ;
					// Make sure we've got a slide and not a slosh.
					// (Only changes of type slide can be redundant.)
					if (changeType == SSYModelChangeActionSlide) {
						// It is possible that this change may be redundant.
						
//						NSDictionary* indexUpdate = [[slideInStange updates] objectForKey:constKeyIndex] ;
//						NSInteger oldIndex = [[indexUpdate objectForKey:NSKeyValueChangeOldKey] integerValue] ;
//						// predictedIndex is the index that could be inferred if this stange was ignored
//						NSRange uppers = NSMakeRange(0, oldIndex) ;
//						NSInteger adjustmentDueToUpperSiblings = [slipIns countOfIndexesInRange:uppers] - [slipOuts countOfIndexesInRange:uppers] ;
//						NSInteger predictedIndex = oldIndex + adjustmentDueToUpperSiblings ;
						NSInteger predictedIndex = [availableIndexes firstIndex] ;
						NSInteger actualIndex = [[[slideInStange stark] index] integerValue] ;
						if (predictedIndex == actualIndex) {
							[indexesOfRedundantSlideStanges addIndex:candidateStangeIndex] ;
						}
						else {
						}
					}
				}
			}
			[availableIndexes removeIndex:i] ;
		}
		[availableIndexes release] ;
	}
	[slipInsForFindingRedundantSlides release] ;
	[slipOutsForFindingRedundantSlides release] ;
	[slideInsForFindingRedundantSlides release] ;
	[parentsWithSlides release] ;
	[allIndexSet release] ;							

	stangeIndex = 0 ;
#endif
	for (Stange* stange in stangesArray) {
#if CULLING_REDUNDANT_SLIDES
		if (![indexesOfRedundantSlideStanges containsIndex:stangeIndex]) {
#endif
			Stark* stark = [stange stark] ;
			// Translate from the 7 possible SSYModelAction types to
			// the 4 changes recognized by SafariDAVClient.
			switch ([stange changeType]) {
				case SSYModelChangeActionRemove:
					// This is SafariDAVClient Change Case 1.  Requires a *Delete* change.
					
					// So it will be omitted when constructing the tree…
					[stark setIsDeletedThisIxport] ;
					
					[deletingStarks addObject:stark] ;
					
					break ;
				case SSYModelChangeActionMosh: // (modified and moved)
				case SSYModelChangeActionMove:
					// This is SafariDAVClient Change Case 2.  Requires a *Delete* change **and** an *Add* change.
					
					// To signal a move to SafariDAVClient, we need two changes:
					// "Delete" the existing item and "Add" a new one at the new
					// location.  For our purposes here, a Mosh is the same as a
					// Move because the "Add" change will have all the changed
					// attributes.
					[deletingStarks addObject:stark] ;
					
					// SafariDAVClient requires a new exid for the "Add" change,
					// but we'll need the old one after we cull children for the
					// "Delete" change.  Stash the old exid in a dummy clientoid.
					NSString* oldExid = [stark exidForClientoid:actualClientoid] ;
					[stark setExid:oldExid
					  forClientoid:dummyClientoid] ;
					
					// Now set a new exid
					[stark setExid:[SSYUuid uuid]
					  forClientoid:actualClientoid] ;
					// The new exid we just set will be detected and fed back to
					// the mating stark in the Bkmslf by -feedbackPostWrite.
					
					// To get the "Add" change, there is no 'break' here
				case SSYModelChangeActionInsert:;
					// This is SafariDAVClient Change Case 1.  Requires an *Add* change.
					
					bookmarkType = ([StarkTyper isContainerGeneralSharype:[stark sharypeValue]]) 
					? constKeySafariDavChangedBookmarkTypeFolder
					: constKeySafariDavChangedBookmarkTypeBookmark ;
					NSDictionary* changeDic = [NSDictionary dictionaryWithObjectsAndKeys:
											   [SSYUuid uuid], constKeySafariDavChangeToken,
											   constKeySafariDavChangeTypeAdd, constKeySafariDavChangeType,
											   bookmarkType, constKeySafariDavChangedBookmarkType,
											   [stark exidForClientoid:actualClientoid], constKeySafariDavChangedBookmarkUuid,
											   nil] ;
					// It's pretty easy to make SafariDAVClient crash.  One way is by not
					// giving it a BookmarkUUID (exid).  So we have defensive programming
					// to ensure that changeDic is fully populated before adding it…
					if ([changeDic count] > 3) {
						[addAndModifyChanges addObject:changeDic] ;
					}
					else {
						NSLog(@"Internal Error 624-1814  No exid for %@ in %@", [stark shortDescription], changeDic) ;
					}
					
					break ;				
				case SSYModelChangeActionSlosh:  // (modified and slid)
				case SSYModelChangeActionSlide:
				case SSYModelChangeActionModify:
					// This is SafariDAVClient Change Case 4.  Requires a *Modify* change.
					
					if ([[stange updates] count] > 0) {
						bookmarkServerId = [[stark ownerValueForKey:constKeySafariSyncInfo] objectForKey:constKeySafariDavServerID] ;
						bookmarkType = ([StarkTyper isContainerGeneralSharype:[stark sharypeValue]]) 
						? constKeySafariDavChangedBookmarkTypeFolder
						: constKeySafariDavChangedBookmarkTypeBookmark ;
						NSDictionary* changeDic = [NSDictionary dictionaryWithObjectsAndKeys:
												   [SSYUuid uuid], constKeySafariDavChangeToken,
												   constKeySafariDavChangeTypeModify, constKeySafariDavChangeType,
												   bookmarkType, constKeySafariDavChangedBookmarkType,
												   [stark exidForClientoid:actualClientoid], constKeySafariDavChangedBookmarkUuid,
												   bookmarkServerId, constKeySafariDavChangedBookmarkServerID,
												   nil] ;
						// It's pretty easy to make SafariDAVClient crash.  One way is by not
						// giving it a BookmarkUUID (exid).  So we use some defensive
						// programming here…
						if ([changeDic count] > 3) {
							[addAndModifyChanges addObject:changeDic] ;
						}
						else {
							NSLog(@"Internal Error 624-1815  No exid for %@ in %@", [stark shortDescription], changeDic) ;
						}
					}
					else {
						// Apparently, the only modification(s) in this item is in
						// one or more of these collections:
						// • addedChildren
						// • deletedChildren
						// SafariDAVClient is not interested in any of these.  Of course it does
						// not need these, because these are implied by the Adds and Deletes.
					}
					break;
				default:
					break;
			}			
#if CULLING_REDUNDANT_SLIDES
		}
		
		stangeIndex++ ;
#endif
	}
	
#if CULLING_REDUNDANT_SLIDES
	[indexesOfRedundantSlideStanges release] ;
#endif
	[stangesArray release] ;
		
	// If an entire branch is being deleted, SafariDAVClient just wants one
	// change, to delete the root.  (At least, that's how Safari does it.)
	// We're therefore going to cull descendants, in two steps.	
	
	// Culling Deletions Step 1.  Sort the raw deletions so that the rootmost are first.
	// I may be wrong, but I suspect that, this way we'll recursively eliminate
	// children as quickly as possible and this will be more efficient.  If I'm
	// wrong, well, I don't think it will be any worse than any other algorithm.
	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lineageDepthObject"
																   ascending:YES
																	selector:@selector(compare:)] ;
	NSArray* descriptors = [NSArray arrayWithObjects:sortDescriptor, nil] ;
	[sortDescriptor release] ;
	[deletingStarks sortUsingDescriptors:descriptors] ;
	
	// Culling Deletions Step 2.  Do the actual culling.
	// Don't use a fast enumeration because we're going to modify deletingStarks
	// as we enumerate through it.  However, except in a very weird corner case
	// where someone has manually deleted many leaves or small folders instead
	// of deleting populous folders, this should be quick…
	for (NSUInteger i=0; i<[deletingStarks count]; i++) {
		Stark* stark = [deletingStarks objectAtIndex:i] ;
		NSArray* descendants = [stark descendantsWithSelf:NO] ;
		[deletingStarks removeObjectsInArray:descendants] ;
	}
	
	// If iCloud is currently not available, there may be prior changes already
	// in Bookmarks.plist ▸ Sync ▸ Changes.  We need to get that array out and
	// make it mutable so we can *append* our changes.
	NSMutableArray* changes = [[syncInfo valueForKey:constKeySafariDavChanges] mutableCopy] ;
	if (!changes) {
		changes = [[NSMutableArray alloc] init] ;
	}
	// Set back either the mutable copy of existing 'changes', or the new empty mutable 'changes'
	[syncInfo setObject:changes
				 forKey:constKeySafariDavChanges] ;
	[changes release] ;
	[rootAttributes setObject:syncInfo
					   forKey:constKeySafariSync_Root] ;

	// What it says…
	[changes addObjectsFromArray:addAndModifyChanges] ;
	[addAndModifyChanges release] ;

	// Process the culled deletingStarks, adding entries to 'changes'
	for (Stark* stark in deletingStarks) {
		bookmarkType = ([StarkTyper isContainerGeneralSharype:[stark sharypeValue]]) 
		? constKeySafariDavChangedBookmarkTypeFolder
		: constKeySafariDavChangedBookmarkTypeBookmark ;
		// Get the old exid, which was set for a Move or Mosh
		NSString* exid = [stark exidForClientoid:dummyClientoid] ;
		if (!exid) {
			// Apparently this was a Delete.  The old exid
			// is still the current exid
			exid = [stark exidForClientoid:actualClientoid] ;
		}
		// Note that, in either case above, whether exid is that of dummy
		// or actual clientoid, it is the exid that was entered into the
		// starkSyncDics dictionary in +starkFromExtoreNode:::.  Hence,
		// we can do this…
		bookmarkServerId = [[stark ownerValueForKey:constKeySafariSyncInfo] objectForKey:constKeySafariDavServerID] ;
		NSDictionary* changeDic = [NSDictionary dictionaryWithObjectsAndKeys:
								   [SSYUuid uuid], constKeySafariDavChangeToken,
								   constKeySafariDavChangeTypeDelete, constKeySafariDavChangeType,
								   bookmarkType, constKeySafariDavChangedBookmarkType,
								   exid, constKeySafariDavChangedBookmarkUuid,
								   bookmarkServerId, constKeySafariDavChangedBookmarkServerID,
								   nil] ;
		// It's pretty easy to make SafariDAVClient crash.  One way is by not
		// giving it a BookmarkUUID (exid).  So we make sure of that…
		if ([changeDic count] > 3) {
			[changes addObject:changeDic] ;
		}
		else {
			NSLog(@"Internal Error 624-1817  No exid for %@ in %@", [stark shortDescription], changeDic) ;
		}
		
		// Although I am 99% sure that 'stark' is going to be deleted and 
		// and then likewise its in-memory managed object context will be
		// deleted, and therefore the following clean up will have no
		// effect, I do it for defensive programming…
		[stark setExid:nil
		  forClientoid:dummyClientoid] ;
	}
	[deletingStarks release] ;
	
	// We have previously set 'changes' into 'syncInfo' which has in
	// turn been set into 'rootAttributes'.  So, we're done.
}

- (NSArray*)extoreRootsForExport {
	SEL reformatter = [self reformatStarkToExtore] ;
	
	SSYTreeTransformer* transformer = [SSYTreeTransformer
									   treeTransformerWithReformatter:reformatter
									   childrenInExtractor:@selector(childrenOrdered)
									   newParentMover:@selector(moveToChildrenUpperOfNewParent:)
									   contextObject:self] ;
	
	// Transform root items, but keep the bar and menu off to the side for now
	NSArray* bkmslfRootChildren = [[[self starker] root] childrenOrdered] ;
	
	NSDictionary* safariRootItem = nil ;
	NSDictionary* safariBar = nil ;
	NSDictionary* safariMenu = nil ;	
	NSDictionary* safariUnfiled = nil ;	
	NSMutableArray* usersRootChildren = [[NSMutableArray alloc] init] ;
	for (Stark* bkmslfRootChild in bkmslfRootChildren) {
		safariRootItem = [transformer copyDeepTransformOf:bkmslfRootChild] ;
		[safariRootItem autorelease] ;
		if ([bkmslfRootChild sharypeValue] == SharypeBar) {
			safariBar = safariRootItem ;
		}
		else if ([bkmslfRootChild sharypeValue] == SharypeMenu) {
			safariMenu = safariRootItem ;
		}
		else if ([bkmslfRootChild sharypeValue] == SharypeUnfiled) {
			NSMutableDictionary* unfiledMutant = [NSMutableDictionary dictionaryWithDictionary:safariRootItem] ;
			// Until BookMacster 1.9.9, I had a couple dozen lines of code here which
			// moved any folders in the Reading/Unsorted collection into Root.
			// TOO LATE!  At this point, Chaker's stanges have already been recorded,
			// so any change made here will be behind the back of Chaker.  More importantly,
			// the correction will not cancel out the previous move of the disallowed
			// folder into Reading/Unsorted by the Gulper.  Say that we have a folder in
			// Firefox' Unsorted Bookmarks and import that into BookMacster.  Or maybe
			// the user creates a folder in, or moves a folder to Reading/Unsorted.
			// Now we export to Safari.  Chaker will find that a change was made, and
			// thus we will export, when in fact during the export the folder will have
			// been moved back, here to Root, so in fact what we're exporting was exactly
			// the same as the previous export.  Then if iCloud is in use, and an Agent
			// is watching Safari, when SafariDAVClient touches the file, we'll re-import,
			// Gulper will move it back into Reading/Unsorted, Chaker will have a change,
			// export will occur, at this point we'll again move it back into Root, and
			// there you go – an infinite loop of Agent operations.  Yikes!!
			[unfiledMutant setObject:[NSNumber numberWithBool:YES]
							  forKey:@"ShouldOmitFromUI"] ;
			[unfiledMutant setObject:constKeySafariReadingListIdentifier
							  forKey:@"Title"] ;
			
			safariUnfiled = unfiledMutant ;
		}
		else {
			[usersRootChildren addObject:safariRootItem] ;
		}
	}
	
	NSArray* proxyCollections = [[self fileProperties] objectForKey:constKeyProxyCollections] ;
	// Now we've got our bar, menu, unfiled, and other items (safariOtherRootItems) copied for Safari.
	
	/* The order that Safari puts root children in is:
	 History (a Proxy Collection)
	 Bar
	 Menu
	 Address Book (a Proxy Collection)
	 Bonjour (a Proxy Collection)
	 All RSS Feeds (a Proxy Collection)
	 com.apple.ReadingList (Safari 5.1+ only)
	 Other Collections added by user
	 
	 The Other Collections are already in rootChildren.
	 */
	
	NSMutableArray* rootChildren = [[NSMutableArray alloc] init] ;
	NSInteger iProxy = 0 ;
	// Insert History, which should be the first item in proxyCollections
	if ([proxyCollections count] > iProxy) {
		[rootChildren addObject:[proxyCollections objectAtIndex:iProxy++]] ;
	}	
	if (safariBar) {
		[rootChildren addObject:safariBar] ;
	}
	if (safariMenu) {
		[rootChildren addObject:safariMenu] ;
	}
	while (iProxy < [proxyCollections count]) {
		[rootChildren addObject:[proxyCollections objectAtIndex:iProxy++]] ;
	}
	// Oddly, Reading List *follows* the proxy collections
	if (safariUnfiled) {
		[rootChildren addObject:safariUnfiled] ;
	}
	[rootChildren addObjectsFromArray:usersRootChildren] ;
	[usersRootChildren release] ;
	
	NSArray* answer = [NSArray arrayWithArray:rootChildren] ;
	[rootChildren release] ;
	
	return answer ;
}

- (BOOL)pushToCloudError_p:(NSError**)error_p {
#if 0
#warning Skipping Push to iCloud.  (Can push manually by using launchctl…)
	// To push manually, see comment below
	return YES ;
#endif
	
	if (NSAppKitVersionNumber < 1100) {
		// iCloud is only an issue with Lion+
		return YES ;
	}
	
	/*
	 Note: Thomas is my code word for Thomas the Tank Engine which can Push to iCloud.
	 I use the code word since I'd rather no one know about my SafariDAVClient trick.
	 
	 Thomas operates by creating an XPC connection to SafariDAVClient and then sending
	 a message to it.  I don't know why it works, but I chose Thomas because it seems
	 less invasive than unloading and reloading the agent, and is probably the way
	 that Safari does it.  
	 
	 In case Thomas ever fails me, another way to do this would be to unload and
	 reload the safaridavclient agent.  Something like this…
	 
	 launchctl unload /System/Library/LaunchAgents/com.apple.safaridavclient.plist
	 launchctl load /System/Library/LaunchAgents/com.apple.safaridavclient.plist
	 
	 I can do the above in Terminal on my Mac account.  But will it work on a
	 non-administrator account ??
	 
	 That worked in Mac OS X 10.7.2 because the agent had a RunAtLoad key.
	 The reason it has RunAtLoad is probably because, when a Mac account logs in,
	 it should immediately check with iCloud and pull in any bookmarks changes
	 it missed.
	 
	 The agent /System/Library/LaunchAgents/com.apple.safaridavclient.plist
	 has three versions today (20120321) in Time Machine.
	 • file modified 2011-07-21 does *not* have a RunAtLoad key
	 • file modified 2011-10-16 *does* have a RunAtLoad key
	 • file modified 2012-02-10 does *not* have a RunAtLoad key
	 (The last one is the current version today, 2012-03-21)
	 
	 According to System Preferences ▸ Software Update ▸ Installed Software, 
	 • I updated to Mac OS X 10.7.1 on 2011-08-17
	 • I updated to Mac OS X 10.7.2 on 2011-10-16
	 • I updated to Mac OS X 10.7.3 on 2012-02-10

	 Conclusions:
	 • That agent did *not* have a RunAtLoad key in Mac OS X 10.7 or 10.7.1.
	 • Apple added it for some reason in 10.7.2
	 • then removed it for some reason in 10.7.3.
	 
	 Eeeeek!!!  What are they doing???
	 
	 Another observation: Since there are only these 3 versions in Time Machine,
	 obviously this file is not changed in any way depending on whether
	 it does not matter whether iCloud Bookmarks is switched ON or OFF.
	 */
	
	/* 
	 2012-04-20  Well now it seems that SafariDAVClient cancels the connection 
	 (Thomas gets a "connection interrupted" error) within a few seconds after
	 Thomas sends SafariDAVClient its "pretty please" message, even though
	 SafariDAVClient may run for several minutes after that doing the actual
	 upload.  I don't know if this is new in Mac OS X 10.7.3 or not.  So I adjusted
	 both numbers downward, and added the _MAX
	 
	 2012-03-21  It took 535 seconds to upload 4336 bookmarks on our residential
	 DSL line, with no other activity.  That's .12 seconds per bookmark.  No Netflix.
	 
	 ?Maybe 2012-01?  It took 430 seconds to upload 1500 bookmarks on our residential DSL line, while
	 Colette was watching Netflix, although that shouldn't matter.  That's .29 seconds
	 per bookmark.
	 
	 OK, we've got 130 Kb/sec upload speed.  A dial-up line may get 30
	 Kb/sec.  So let's derate to .29*130/30 = 1.26 seconds per bookmark.  Derate by
	 another factor of 2 for safetly, and we get…   */
#define SAFARI_DAV_CLIENT_SECONDS_PER_CHANGE 2.0
#define SAFARI_DAV_CLIENT_SECONDS_MIN 60.0
#define SAFARI_DAV_CLIENT_SECONDS_MAX 900.0
	
	NSDictionary* rootAttributes = [[self fileProperties] objectForKey:constKeyRootAttributes] ;
	NSDictionary* syncInfo = [rootAttributes valueForKey:constKeySafariSync_Root] ;
	
	if (!syncInfo) {
		// iCloud is not enabled.  (When you enable iCloud, "Sync" key gets added to
		// Bookmarks.plist.  When you disable iCloud, "Sync" key is removed.
		return YES ;
	}
	
	NSInteger nChanges = [[syncInfo objectForKey:constKeySafariDavChanges] count] ;
	NSInteger timeoutSeconds = ceil(nChanges * SAFARI_DAV_CLIENT_SECONDS_PER_CHANGE) ;
	timeoutSeconds = MAX(timeoutSeconds, SAFARI_DAV_CLIENT_SECONDS_MIN) ;
	timeoutSeconds = MIN(timeoutSeconds, SAFARI_DAV_CLIENT_SECONDS_MAX) ;
	
	NSString* helperName = [[[BkmxBasis sharedBasis] appFamilyName] stringByAppendingString:@"-Thomas"] ;
    NSString* path = [[NSBundle mainBundle] pathForHelper:helperName] ;
	NSArray* arguments = [NSArray arrayWithObjects:
						  @"com.apple.safaridavclient.push",
						  [NSString stringWithFormat:@"%ld", (long)timeoutSeconds],
						  nil] ;
	NSError* error = nil ;
	NSInteger result = [SSYShellTasker doShellTaskCommand:path
												arguments:arguments
											  inDirectory:nil
												stdinData:nil
											 stdoutData_p:NULL
											 stderrData_p:NULL
												  timeout:0.0 // return immediately, don't want for SafariDAVClient
												  error_p:&error] ;
	BOOL ok = (result == 0) ;
	if (!ok && error_p) {
		*error_p = SSYMakeError(613098, @"An error occurred when BookMacster signalled Mac OS X to push this export "
								@"up to iCloud.  Your changes were probably not pushed to iCloud.") ;
		*error_p = [*error_p errorByAddingUnderlyingError:error] ;
		[self setError:error] ;
	}
	
	return ok ;
}

@end

/*
 ** STUDY OF SAFARI FILE LOCKS **
 
 TESTING ON QUAD CORE 2009 MAC PRO
 
 At first, after Bookwatchdog wrote bookmarks, bookmarks changes did not show immediately in an existing window, and did not show even in a new window.  Then when I moved a bookmark in Safari, it crashed.  Then after re-launching, I noted that I still had the problem where changes did not show.  But then after that, things started working.  Very strange.
 
 THE MYSTERIOUS ~/Library/Safari/lock
 
 When Safari 4 writes a bookmarks file, in either Leopard or Snow Leopard, it momentarily creates a directory ~/Library/Safari/lock.
 
 By using flock, or maybe just because I was lucky, I was once able to get Safari to display the "Your bookmarks can't be changed now" warning and, when this happened, the ~/Library/Safari/lock folder remained until I dismissed the dialog.  Aha!!  Looking inside, I found a single file named "details.plist".  It was in XML format and contained the following plist:
 <?xml version="1.0" encoding="UTF-8"?>
 <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
 <plist version="1.0">
 <dict>
 <key>LockFileDate</key>
 <date>2009-08-14T22:41:50Z</date>
 <key>LockFileHostname</key>
 <string>localhost</string>
 <key>LockFileProcessID</key>
 <integer>2983</integer>
 <key>LockFileProcessName</key>
 <string>Safari</string>
 <key>LockFileUsername</key>
 <string>Jerry</string>
 </dict>
 </plist>
 
 The time was probably the time that Safari tried to write the file, and pid=2983 is the pid of Safari (not the pid of my tool which did the flock()).
 
 WHAT IS ~/Library/Safari/lock?
 
 In the following post,
 
 http://lists.apple.com/archives/Syncservices-dev/2008/Apr/msg00004.html
 
 the writer reports the following console output:
 
 4/7/08 4:35:16 PM SystemUIServer[177] Couldn't write file lock dictionary for /Users/randyh/Library/Application Support/SyncServices/ Local/conflicts/lock - possible bad dictionary format? Dictionary is {
 LockFileDate = 2008-04-07 16:35:14 -0700;
 LockFileHostUUIDKey = "00000000-0000-1000-8000-0016CBA076C3";
 LockFileHostname = localhost;
 LockFileProcessID = 177;
 LockFileProcessName = SystemUIServer;
 LockFileUsername = "randyh";
 }
 4/7/08 4:35:16 PM SystemUIServer[177] Ignoring exception NSObjectNotAvailableException trying to remove lock after failing to write file: Can't remove existing lock for /Users/randyh/Library/ Application Support/SyncServices/Local/conflicts
 
 Thus, I conclude that ~/Library/Safari/lock is produced by Sync Services.
 
 FILE LOCKS
 
 Safari 4.0 ignores the advisory locks set by flock(2).  Use my project flock_wrapper.  However, if a "Finder" lock is put on, it will obey it silently -- not writing any changes.  Any bookmarks changes are silently lost.
*/


/*
 TIPS ON REVERSE-ENGINEERING SafariDAVClient

 Here's a little trick which will help you see what's going on.  Launch Activity Monitor
 and filter for a process named "SafariDAVClient".  Whenever it's running, bookmarks
 are being pushed to or pulled from the server.
 
 Another little trick, not as useful, will write details of each push and pull to your
 console.  It tends to be a fire hose, though.
 
 #Enable SafariDAVClient logging
 defaults write com.apple.SafariDAVClient SDAVLogLevel 6
 defaults write com.apple.Safari BookmarkAccessAPILoggingEnabled -bool yes
 
 Presumably a lower SDAVLogLevel would be better.  Anyhow, when you get tired of it,
 
 #Disable SafariDAVClient logging
 defaults delete com.apple.SafariDAVClient SDAVLogLevel
 defaults delete com.apple.Safari BookmarkAccessAPILoggingEnabled
*/ 