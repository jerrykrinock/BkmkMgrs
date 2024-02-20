#import <Bkmxwork/Bkmxwork-Swift.h>
#import "ExtoreICab.h"
#import "Stark.h"
#import "SSYTreeTransformer.h"
#import "Starker.h"
#import "Client.h"
#import "SSYUuid.h"
#import "NSString+SSYExtraUtils.h"
#import "StarkLocation.h"
#import "NSString+BkmxURLHelp.h"
#import "NSDictionary+Treedom.h"
#import "NSDictionary+ToStark.h"
#import "Stark+ConvertToICab.h"
#import "StarkTyper.h"
#import "NSNumber+Sharype.h"

NSString* const constKeyIcabName = @"Title" ;
NSString* const constKeyIcabComments = @"Description" ;
NSString* const constKeyIcabType = @"BookmarkType" ;
NSString* const constKeyIcabUrl = @"URL" ;
NSString* const constKeyIcabUuid = @"UID" ;
NSString* const constKeyIcabAddDate = @"CreationDate" ;
NSString* const constKeyIcabTags = @"Tags" ;
NSString* const constKeyIcabFavicon = @"FavIcon" ;
NSString* const constKeyIcabClosed = @"Closed" ;
NSString* const constKeyIcabChildren = @"Children" ;
NSString* const constKeyIcabFolderType = @"FolderType" ;

// Client Proprietary
NSString* const constKeyIcabTopTen = @"TopTen" ;
NSString* const constKeyIcabCheckFlags = @"CheckFlags" ;
NSString* const constKeyIcabFBOpen = @"FBOpen" ;
NSString* const constKeyIcabRules = @"Rules" ;

// Basic Types
NSString* const constKeyIcabTypeBookmark = @"Bookmark" ;
NSString* const constKeyIcabTypeFolder = @"Folder" ;
NSString* const constKeyIcabTypeSeparator = @"Separator" ;
NSString* const constKeyIcabTypeSmartFolder = @"SmartFolder" ;

// Folder Types
NSString* const constKeyIcabTypeBar = @"Favorites" ;

// File properties
NSString* const constKeyBarStark = @"bar" ;
NSString* const constKeyBarStarkLocation = @"barLoc" ;
NSString* const constKeyBarAttributes = @"barAtts" ;

static const ExtoreConstants extoreConstants = {
	/* canEditAddDate */                  YES,
	/* canEditComments */                 BkmxCanEditInStyleEither,
	/* canEditFavicon */                  YES,  // But I don't read it at this time.
	/* canEditFaviconUrl */               NO,
	/* canEditIsAutoTab */                NO,
	/* canEditIsExpanded */               YES,
	/* canEditIsShared */                 NO,
	/* canEditLastChengDate */            NO,
	/* canEditLastModifiedDate */         NO,
	/* canEditLastVisitedDate */          NO,
	/* canEditName */                     YES,
	/* canEditRating */                   NO,
	/* canEditRssArticles */              NO,
    /* canEditSeparators */               BkmxCanEditInStyleEither,
	/* canEditShortcut */                 BkmxCanEditInStyleNeither,
	/* canEditTags */                     BkmxCanEditInStyleEither,
	/* canEditUrl */			          YES,
	/* canEditVisitCount */               NO,
	/* canCreateNewDocuments */           YES,
	/* ownerAppDisplayName */             @"iCab",
	/* webHostName */                     nil,
	/* authorizationMethod */             BkmxAuthorizationMethodNone,
	/* accountNameHint */                 nil,
	/* oAuthConsumerKey */                nil,
	/* oAuthConsumerSecret */             nil,
	/* oAuthRequestTokenUrl */            nil,
	/* oAuthRequestAccessUrl */           nil,
	/* oAuthRealm */                      nil,
	/* appSupportRelativePath */          nil,
	/* defaultFilename */                 @"iCab 6 Bookmarks",
	/* defaultProfileName */              nil,
	/* iconResourceFilename */            nil,
	/* iconInternetURL */                 nil,
	/* fileType */                        @"",  // Actually, it's a plist, but no file extension
	/* ownerAppObservability */           OwnerAppObservabilityOnQuit,
	/* canPublicize */                    NO,
	/* silentlyRemovesDuplicates */       NO,
	/* normalizesURLs */                  NO,
	/* catchesChangesDuringSave */        NO,
	/* telltaleString */                  @"Bookmarks Root Folder",
	/* hasBar */                          YES,
	/* hasMenu */                         NO,
	/* hasUnfiled */                      NO,
	/* hasOhared */                       NO,
	/* tagDelimiter */                    @",",
	/* dateRef1970Not2001 */              NO, // Does not use any dates
	/* hasOrder */                        YES,
	/* hasFolders */                      YES,
	/* ownerAppIsLocalApp */              YES,
	/* defaultSpecialOptions */           0x0000000000000000LL,
	/* extensionInstallDirectory */       nil,
	/* minBrowserVersionMajor */          4,
	/* minBrowserVersionMinor */          0,
	/* minBrowserVersionBugFix */         0,
	/* minSystemVersionForBrowsMajor */   0,
	/* minSystemVersionForBrowMinor */    0,
	/* minSystemVersionForBrowBugFix */   0
} ;


@implementation ExtoreICab

/*
 This implementation is the same in all subclasses, but we define it
 in each subclass in order to pick up the static const extoreConstants
 struct which is different in each Extore subclass' implementation file.
 */
+ (const ExtoreConstants *)constants_p {
	return &extoreConstants ;
}

+ (NSArray*)browserBundleIdentifiers {
    return [NSArray arrayWithObject:@"de.icab.iCab"] ;
}

+ (NSString*)labelUnfiled {
    return constDisplayNameNotUsed ;
}

+ (NSString*)labelOhared {
    return constDisplayNameNotUsed ;
}

+ (BOOL)parentSharype:(Sharype)parentSharype
  canHaveChildSharype:(Sharype)childSharype {
	BOOL answer ;
	if (parentSharype == SharypeRoot) {
		answer = ((childSharype & (SharypeCoarseHartainer + SharypeCoarseSoftainer + SharypeCoarseLeaf)) > 0) ;
	}
	else {
		answer = ((parentSharype & (SharypeGeneralContainer)) > 0) ;
	}

	return answer ;
}

+ (BkmxIxportTolerance)toleranceForIxportStyle:(NSInteger)ixportStyle {
	BkmxIxportTolerance tolerance = BkmxIxportToleranceAllowsNone ;
	if (ixportStyle == 1) {
		tolerance = BkmxIxportToleranceAllowsReading ;
	}
#if 0
#warning testing to see if Clauss fixed iCab
    tolerance = BkmxIxportToleranceAllowsReading | BkmxIxportToleranceAllowsWriting ;
#endif
	return tolerance ;
}

- (Stark*)fosterParentForStark:(Stark *)stark {
    return [[self starker] root] ;
}

+ (PathRelativeTo)fileParentPathRelativeTo {
	return PathRelativeToPreferences ;
}

+ (NSString*)fileParentRelativePath {
	return @"iCab" ;
}

#if 0
#warning Logging when unique IDs
- (BOOL)supportsUniqueExids {
	return m_supportsUniqueExids ;
}

- (void)setSupportsUniqueExids:(BOOL)yn {
	m_supportsUniqueExids = yn ;
}
#endif

@synthesize supportsUniqueExids = m_supportsUniqueExids ;

- (BOOL)isExportableStark:(Stark*)stark
			   withChange:(NSDictionary*)change {
#if IS_EXPORTABLE_STARK_WILL_ALWAYS_RETURN_YES
	return YES  ;
#endif

	if ([stark sharypeValue] == SharypeSmart) {
		// It is a Smart Bookmark
		if ([stark ownerValueForKey:constKeyIcabRules] == nil) {
			// But it's not an iCab Smart Bookmark
			// (Could be a Firefox Smart Bookmark)
			// Note: The above test is sufficient because, in the iCab GUI,
			// it is impossible to set a Smart Bookmark with no Rules.
			return NO ;
		}
	}
	
    if ([[stark url] isSmartSearchUrl]) {
        return NO ;
    }
	
	if ([stark sharypeValue] == SharypeSeparator) {
		return YES ;
	}
	else if ([stark is1PasswordBookmarklet]) {
		return NO ;
	}		
	
	return YES ;
}

- (NSString*)cheesyExidForStark:(Stark*)stark {
	NSString* signature = [[stark lineageNamesDoSelf:YES
											 doOwner:NO] componentsJoinedByString:@""] ;
	NSString* exid = [signature md5HashAsLowercaseHex] ;
	// The above means that if you have two different bookmarks with
	// the same name in the same folder, they will be indistinguishable;
	// one of them will be deleted during an export, for example.
	// This would be less likely if url was appended to the signature,
	// but then that would cause a disconnect if the url was changed.
	// So, I left it like this.  Until iCab decides to give us UUIDs,
	// it's going to be cheesy one way or cheesy the other way.
	return exid ;
}

- (void)getFreshExid_p:(NSString**)exid_p
            higherThan:(NSInteger)higherThan
              forStark:(Stark*)stark
               tryHard:(BOOL)tryHard {
	if ([self supportsUniqueExids]) {
		*exid_p = [SSYUuid uuid] ;
	}
	else {
		*exid_p = [self cheesyExidForStark:stark] ;
	}
}

- (SEL)reformatStarkToExtore {
	return @selector(extoreItemForICab:) ;
}

- (Stark*)starkFromExtoreNode:(NSDictionary*)dic {	
	id value ;
	Stark*	stark = [[self starker] freshStark] ;
	
	// Attributes common to both containers,  nodes, and notches

	value = [dic objectForKey:constKeyIcabName] ;
	if ([value isKindOfClass:[NSString class]]) {
		[stark setName:value] ;
	}

	value = [dic objectForKey:constKeyIcabComments] ;
	if ([value isKindOfClass:[NSString class]]) {
		[stark setComments:value] ;
	}
	
	value = [dic objectForKey:constKeyIcabUuid] ;
	if ([value isKindOfClass:[NSString class]]) {
		[self setSupportsUniqueExids:YES] ;
		[stark setExid:value
		  forClientoid:[self clientoid]] ;
	}
	
	NSString* typeName = [dic objectForKey:constKeyIcabType] ;
	if (![typeName isKindOfClass:[NSString class]]) {
		NSLog(@"Warning 133-8573 Typeless: %@", dic) ;
		return nil ;
	}

	Sharype sharype = SharypeUndefined ;
	if ([typeName isEqualToString:constKeyIcabTypeBookmark]) {
		sharype = SharypeBookmark ;

		value = [dic objectForKey:constKeyIcabUrl] ;
		if ([value isKindOfClass:[NSString class]]) {
			[stark setUrl:value] ;
		}

		value = [dic objectForKey:constKeyIcabAddDate] ;
		if ([value isKindOfClass:[NSDate class]]) {
			[stark setAddDate:value] ;
		}
		
		value = [dic objectForKey:constKeyIcabTags] ;
		if ([value isKindOfClass:[NSString class]]) {
			value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ;
            if (((NSString*)value).length > 0) {
                NSMutableString* tagsString = [value mutableCopy] ;
                NSInteger nReplacements = 1 ;
                while (nReplacements > 0) {
                    nReplacements = [tagsString replaceOccurrencesOfString:@"  "
                                                                withString:@" "] ;
                }
                NSArray* tagStrings = [tagsString componentsSeparatedByString:@" "] ;
                [tagsString release] ;
                
                for (NSString* tagString in tagStrings) {
                    Tag* tag = [[self tagger] tagWithString:tagString];
                    [stark addTagsObject:tag];
                }
            }
		}

		value = [dic objectForKey:constKeyIcabTopTen] ;
		[stark setOwnerValue:value
							 forKey:constKeyIcabTopTen] ;
		
		value = [dic objectForKey:constKeyIcabCheckFlags] ;
		[stark setOwnerValue:value
							 forKey:constKeyIcabCheckFlags] ;
	}
    else if ([typeName isEqualToString:constKeyIcabTypeSeparator]) {
        sharype = SharypeSeparator;
    }
	else {
		if ([typeName isEqualToString:constKeyIcabTypeFolder]) {
			sharype = SharypeSoftFolder ;
			// This may be overridden below if Folder Type is Bar.
		}
		else if ([typeName isEqualToString:constKeyIcabTypeSmartFolder]) {
			sharype = SharypeSmart ;

			value = [dic objectForKey:constKeyIcabRules] ;
			[stark setOwnerValue:value
								 forKey:constKeyIcabRules] ;			
		}
		else {
			NSLog(@"Internal Error 523-9801 %@", typeName) ;
		}
		
		BOOL isExpanded = YES ;
		value = [dic objectForKey:constKeyIcabClosed] ;
		if ([value isKindOfClass:[NSNumber class]]) {
			isExpanded = ([value boolValue] == NO) ;
		}
		if (isExpanded) {
			[stark setIsExpanded:[NSNumber numberWithBool:YES]] ;
		}
		
		value = [dic objectForKey:constKeyIcabFBOpen] ;
		[stark setOwnerValue:value
							 forKey:constKeyIcabFBOpen] ;
		
		NSString* folderTypeName = [dic objectForKey:constKeyIcabFolderType] ;
		if ([folderTypeName isEqualToString:constKeyIcabTypeBar]) {
			[[self fileProperties] setObject:stark
									  forKey:constKeyBarStark] ;

			NSMutableDictionary* barAttributes = [[NSMutableDictionary alloc] init] ;
			// Removed in BookMacster 1.11
			//			[barAttributes setValue:[stark ownerValues]
			//							 forKey:constKeyOwnerValues] ;
			[barAttributes setValue:[stark isExpanded]
							 forKey:constKeyIsExpanded] ;
			[barAttributes setValue:[stark name]
							 forKey:constKeyName] ;
			[barAttributes setValue:[stark comments]
							 forKey:constKeyComments] ;
			
			[[self fileProperties] setObject:barAttributes
									  forKey:constKeyBarAttributes] ;
			[barAttributes release] ;
			
			sharype = SharypeBar ;
		}

	}
	[stark setSharypeValue:sharype] ;

	return stark ;
}

- (BOOL)makeStarksFromExtoreTree:(NSDictionary*)treeIn
                         error_p:(NSError**)error_p {
	NSMutableDictionary* fileProperties = [self fileProperties] ;
	
	// Remember attributes of root which we don't use but will need to replace when we write bookmarks file back out
	// In iCab, these are: FolderType=2, Title="Bookmarks", UUID=string
	NSMutableDictionary* rootAttributes = [treeIn mutableCopy] ;
	if (rootAttributes) {
		[rootAttributes removeObjectForKey:constKeyIcabChildren] ;
		[fileProperties setObject:rootAttributes
						   forKey:constKeyRootAttributes] ;
	}
	[rootAttributes release] ;
	
	// Create a transformer which we will use to create our collections from iCab's
	SSYTreeTransformer* transformer = [SSYTreeTransformer
									   treeTransformerWithReformatter:@selector(modelAsStarkInStartainer:)
									   childrenInExtractor:@selector(childrenWithUppercaseC)
									   newParentMover:@selector(moveToBkmxParent:)
									   contextObject:self] ;
	
	Stark* rootOut = [[self starker] freshStark] ;
	[rootOut setName:@"Ext-Plist-Root"] ;
	for (Stark* rootChildIn in [treeIn objectForKey:constKeyIcabChildren]) {
		Stark* rootChildOut = [transformer copyDeepTransformOf:rootChildIn] ;
		[rootChildOut moveToBkmxParent:rootOut] ;
		[rootChildOut release] ;
	}
	
	// Ivar 'bar' will have been assigned during -copyDeepTransformOf.
	// If iCab user has not assiged a bar, but user still has any
	// bookmarks, bar will be root itself.
	// Also, bar could be an interior folder, not a child of root.
	// Neither of those are compatible with BookMacster.
	// So, we test for these cases and if found, record the current
	// location for restoration during writing, and move the bar.
	Stark* bar = [fileProperties objectForKey:constKeyBarStark] ;
	if (bar) {
		if ([bar parent] != rootOut) {
			StarkLocation* barStarkLocation = [StarkLocation starkLocationWithParent:[bar parent]
																			   index:[[bar index] integerValue]] ;
			[fileProperties setObject:barStarkLocation
							   forKey:constKeyBarStarkLocation] ;
			[bar moveToBkmxParent:rootOut
						  atIndex:0
						  restack:YES] ;
		}
	}
	else {
		// This is for the odd case if there was no bookmarks bar
		// in iCab.  We need to create one.
		bar = [[self starker] freshStark] ;
		[bar setSharypeValue:SharypeBar] ;
	}
	
	// Set instance variables
	[rootOut assembleAsTreeWithBar:bar
							  menu:nil
						   unfiled:nil
							ohared:nil] ;
	
	if (![self supportsUniqueExids]) {
		[rootOut recursivelyPerformSelector:@selector(makeCheesyMissingExidsForExtore:)
								 withObject:self] ;
	}
	
	return YES ;
}

- (NSArray*)extoreRootsForExport {
	Stark* root = [[self starker] root] ;

	if (![self supportsUniqueExids]) {
		// (Mirroring action in -makeStarksFromExtoreTree:error_p:)
		[root recursivelyPerformSelector:@selector(makeCheesyMissingExidsForExtore:)
							  withObject:self] ;
	}
	
	// Restore Bookmarks Bar, if any
	// (Mirroring action in -makeStarksFromExtoreTree:error_p:)
	Stark* bar = [[self starker] bar] ;
	StarkLocation* barLocation = [[self fileProperties] objectForKey:constKeyBarStarkLocation] ;
	if (barLocation) {
		Stark* barParent = [barLocation parent] ;
		// The following qualification was added in BookMacster 1.8, to fix a bug
		// reported by Andy Fletcher.  If iCab's designated Bookmarks Bar as itself
		// the subfolder of a folder which was deleted during an Export, then its
		// representation here, barParent, will be a deleted object with no managed
		// object context.  Note that we check for the managed object context instead
		// of -isDeleted, because -isDeleted is documented to (and does, in this case),
		// return NO when the correct answer is YES.
		if (![barParent isAvailable]) {
			barParent = root ;
		}
		[bar moveToBkmxParent:barParent
					  atIndex:[barLocation index]
					  restack:YES] ;
	}
	NSDictionary* barAttributes = [[self fileProperties] objectForKey:constKeyBarAttributes] ;
	// Removed in BookMacster 1.11
	//[bar setLocalValues:[barAttributes valueForKey:constKeyOwnerValues]
	//		  forClient:[self client]] ;
	// Prior to BookMacster 1.11, just setLocalValues for no client in particular
	[bar setIsExpanded:[barAttributes valueForKey:constKeyIsExpanded]] ;
	[bar setName:[barAttributes valueForKey:constKeyName]] ;
	[bar setComments:[barAttributes valueForKey:constKeyComments]] ;
	
	
	// Transform
	
	SEL reformatter = [self reformatStarkToExtore] ;
	
	SSYTreeTransformer* transformer = [SSYTreeTransformer
									   treeTransformerWithReformatter:reformatter
									   childrenInExtractor:@selector(childrenOrdered)
									   newParentMover:@selector(moveToChildrenUpperOfNewParent:)
									   contextObject:self] ;
	
	NSDictionary* browserRoot = [transformer copyDeepTransformOf:root] ;
    NSArray* answer = [browserRoot objectForKey:constKeyIcabChildren] ;
	[browserRoot release] ;
	
	return answer ;
}

@end
