#import "ExtoreOmniWeb.h"
#import "NSError+MyDomain.h"
#import "Client.h"
#import "NSString+BkmxURLHelp.h"
#import "NSError+InfoAccess.h"
#import "NSScanner+GeeWhiz.h"
#import "Stark.h"
#import "Starker.h"
#import "SSYTextCodec.h"
#import "NSString+SSYExtraUtils.h"
//#import "NSString+MorePaths.h"
#import "NSFileManager+SomeMore.h"
#import "BkmxBasis+Strings.h"
#import "OperationExport.h"
#import "NSBundle+MainApp.h"

#define KEY_ARCHIVE_DICTIONARY @"archiveDictionary" // used in <dl tags of OmniWeb RSS containers
#define KEY_DELEGATE_CLASS @"delegateClass" // used in <dl tags of OmniWeb RSS containers
#define KEY_OMNIWEB_CHECK_FREQUENCY @"omniWebCheckFrequency"
#define KEY_OMNIWEB_FORMS @"omniwebForms" // seen onbookmarks only, looks like maybe encrypted values for filling out a form?
#define KEY_OMNIWEB_STATUS @"omniwebStatus"  // seen on bookmarks and, rarely, folders.
#define KEY_WORD_COUNT @"wordCount" // Used in both bookmarks (common) and folders (rarely, only as RSS feeds)
#define KEY_VALIDATOR @"validator"
#define KEY_NO_H3_TAGS @"noH3Tags"

@interface NSString (RemoveNonDecimalDigitPrefix)

- (NSString*)removeNonDecimalDigitPrefix ;

@end

@implementation NSString (RemoveNonDecimalDigitPrefix)

- (NSString*)removeNonDecimalDigitPrefix {
	NSInteger length = [self length] ;
	unichar* chars = malloc(length*sizeof(unichar)) ;
	NSCharacterSet* ddcs = [NSCharacterSet decimalDigitCharacterSet] ;
	NSInteger i, j=0 ;
	for (i = length - 1 ; i>=0; i--) {
		unichar c = [self characterAtIndex:i] ;
		if ([ddcs characterIsMember:c]) {
			chars[i] = c ;
			j++ ;
		}
		else {
			break ;
		}
	}
	NSString* s = [NSString stringWithCharacters:&chars[i+1]
										  length:j] ;
	free(chars) ;
	return s ;
}

@end

static const ExtoreConstants extoreConstants = {
	/* canEditAddDate */                  NO,
	/* canEditComments */                 BkmxCanEditInStyleEither,
	/* canEditFavicon */                  NO,
	/* canEditFaviconUrl */               NO,
	/* canEditIsAutoTab */                NO,
	/* canEditIsExpanded */               NO,
	/* canEditIsShared */                 NO,
	/* canEditLastChengDate */            YES,
	/* canEditLastModifiedDate */         NO,
	/* canEditLastVisitedDate */          YES,
	/* canEditName */                     YES,
	/* canEditRating */                   NO,
	/* canEditRssArticles */              YES,
    /* canEditSeparators */               BkmxCanEditInStyleEither,
	/* canEditShortcut */                 BkmxCanEditInStyleEither,
	/* canEditTags */                     BkmxCanEditInStyleNeither,
	/* canEditUrl */			          YES,
	/* canEditVisitCount */               YES,
	/* canCreateNewDocuments */           YES,
	/* ownerAppDisplayName */             @"OmniWeb",
	/* webHostName */                     nil,
	/* authorizationMethod */             BkmxAuthorizationMethodNone,
	/* accountNameHint */                 nil,
	/* oAuthConsumerKey */                nil,
	/* oAuthConsumerSecret */             nil,
	/* oAuthRequestTokenUrl */            nil,
	/* oAuthRequestAccessUrl */           nil,
	/* oAuthRealm */                      nil,
	/* appSupportRelativePath */          nil,
	/* defaultFilename */                 @"OmniWeb/",
	/* defaultProfileName */              nil,
	/* iconResourceFilename */            nil,
	/* iconInternetURL */                 nil,
	/* fileType */                        nil,  // Even though three files are .html, singular "fileType" is a directory
	/* ownerAppObservability */           OwnerAppObservabilityOnQuit,
	/* canPublicize */                    NO,
	/* silentlyRemovesDuplicates */       NO,
	/* normalizesURLs */                  NO,
	/* catchesChangesDuringSave */        NO,
	/* telltaleString */                  @"bookmarkInfo",
	/* hasBar */                          YES,
	/* hasMenu */                         YES,  // I interpret "Personal Bookmarks" to be a bookmarks menu
	/* hasUnfiled */                      NO,
	/* hasOhared */                       YES,
	/* tagDelimiter */                    nil,
	/* dateRef1970Not2001 */              NO, // reverse-engineered from lastCheckedTime=178591549
	/* hasOrder */                        YES,
	/* hasFolders */                      YES,
	/* ownerAppIsLocalApp */              YES,
	/* defaultSpecialOptions */           0x0000000000000000LL,
	/* extensionInstallDirectory */       nil,
	/* minBrowserVersionMajor */          5,
	/* minBrowserVersionMinor */          0,
	/* minBrowserVersionBugFix */         0,
	/* minSystemVersionForBrowsMajor */   10,
	/* minSystemVersionForBrowMinor */    4,
	/* minSystemVersionForBrowBugFix */   0
} ;

@interface ExtoreOmniWeb ()

@property (retain) NSMutableDictionary* filePropertiesBar ;
@property (retain) NSMutableDictionary* filePropertiesMenu ;
@property (retain) NSMutableDictionary* filePropertiesOhared ;
@property (retain) NSNumber* omniWebHistoryVersion ;
@property (assign) NSUInteger nextOmniWebBarID ;
@property (assign) NSUInteger nextOmniWebMenuID ;
@property (assign) NSUInteger nextOmniWebOharedID ;
@property (assign) NSInteger omniWebHistoryFormat ;

- (NSArray*)omniWebHistoriesFromDiskError_p:(NSError**)error_p ;

- (NSData*)browserXMLDataFromRoot:(Stark*)root
				   fileProperties:(NSDictionary*)fileProperties
						hartainer:(BkmxHartainer)hartainer ;

@end

@implementation ExtoreOmniWeb

#pragma mark * Class Methods

/* 
 This implementation is the same in all subclasses, but we define it
 in each subclass in order to pick up the static const extoreConstants
 struct which is different in each Extore subclass' implementation file.
 */
+ (const ExtoreConstants *)constants_p {
	return &extoreConstants ;
}

+ (NSArray*)browserBundleIdentifiers {
    return [NSArray arrayWithObjects:
            @"com.omnigroup.OmniWeb6",
            @"com.omnigroup.OmniWeb5",
            nil] ;
}

+ (NSString*)labelBar {
    return @"Favorites" ;
}

+ (NSString*)labelMenu {
    return @"Personal Bookmarks" ;
}

+ (NSString*)labelUnfiled {
    return constDisplayNameNotUsed ;
}

+ (NSString*)labelOhared {
    return constDisplayNameNotUsed ;
}

+ (BkmxIxportTolerance)toleranceForIxportStyle:(NSInteger)ixportStyle {
	BkmxIxportTolerance tolerance = BkmxIxportToleranceAllowsNone ;
	if (ixportStyle == 1) {
		tolerance = BkmxIxportToleranceAllowsReading ;
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
	return @"Containers/com.omnigroup.OmniWeb6/Data/Library/Application Support" ;
}

#pragma mark * Accessors

@synthesize filePropertiesBar ;
@synthesize filePropertiesMenu ;
@synthesize filePropertiesOhared ;
@synthesize omniWebHistoryVersion ;
@synthesize nextOmniWebBarID ;
@synthesize nextOmniWebMenuID ;
@synthesize nextOmniWebOharedID ;
@synthesize omniWebHistoryFormat ;

- (BOOL)shouldCheckAggregateExids {
    return YES ;
}

- (NSString*)omniWebFilePathForName:(NSString*)name
							error_p:(NSError**)error_p {
	NSString* omniWebPath = [self workingFilePathError_p:error_p] ;
	
	NSString* regularFilePath = [omniWebPath stringByAppendingPathComponent:name] ;
	NSDate *regularFileModDate = [[NSFileManager defaultManager] modificationDateForPath:regularFilePath] ;
	// Note: We ignored any error since Error 513560 is expected if file does not exist and stat returns errno = 2
	
	NSString* serverBookmarksFolderPath = [omniWebPath stringByAppendingPathComponent:@"ServerBookmarks"] ;
	NSString* serverFilePath = [serverBookmarksFolderPath stringByAppendingPathComponent:name] ;
	NSDate *serverFileModDate = [[NSFileManager defaultManager] modificationDateForPath:serverFilePath] ;
	// Note: We ignored any error since Error 513560 is expected if file does not exist and stat returns errno = 2
	
	NSString* answer ;
	
	if (regularFileModDate && serverFileModDate) {
		answer = ([serverFileModDate compare:regularFileModDate] == NSOrderedDescending) ? serverFilePath : regularFilePath ;
	}
	else if (regularFileModDate) {
		answer = regularFilePath ;
	}
	else if (serverFileModDate) {
		answer = serverFilePath ;
	}
	else {
		// This will happen for saving a new loose file
		answer = regularFilePath ;
	}
	
	return answer ;
}

- (NSString*)filePathBarError_p:(NSError**)error_p {
	return [self omniWebFilePathForName:@"Favorites.html"
								error_p:error_p] ;
}

- (NSString*)filePathMenuError_p:(NSError**)error_p {
	return [self omniWebFilePathForName:@"Bookmarks.html"
								error_p:error_p] ;
}

- (NSString*)filePathOharedError_p:(NSError**)error_p {
	return [self omniWebFilePathForName:@"Published.html"
								error_p:error_p] ;
}

- (NSString*)nextIDStringForHartainer:(BkmxHartainer)hartainer {
	NSUInteger nextID ;
	switch (hartainer) {
		case BkmxHartainerBar:
			nextID = [self nextOmniWebBarID] ;
			break ;
		case BkmxHartainerMenu:
			nextID = [self nextOmniWebMenuID] ;
			break ;
		case BkmxHartainerOhared:
			nextID = [self nextOmniWebOharedID] ;
			break ;
		case BkmxHartainerRoot:
        default:
            nextID = 0 ;
			break ;
	}
	
	return [NSString stringWithFormat:@"%ld", (long)nextID] ;
}

- (void)setNextID:(NSInteger)nextID 
			forHartainer:(BkmxHartainer)hartainer {
	switch (hartainer) {
		case BkmxHartainerBar:
			[self setNextOmniWebBarID:nextID] ;
			break ;
		case BkmxHartainerMenu:
			[self setNextOmniWebMenuID:nextID] ;
			break ;
		case BkmxHartainerOhared:
			[self setNextOmniWebOharedID:nextID] ;
			break ;
		case BkmxHartainerRoot:
			break ;
	}
}

- (BOOL)isExportableStark:(Stark*)stark
			   withChange:(NSDictionary*)change {
#if IS_EXPORTABLE_STARK_WILL_ALWAYS_RETURN_YES
	return YES  ;
#endif

	if ([stark is1PasswordBookmarklet]) {
		return NO ;
	}		

	Sharype sharype = [stark sharypeValue] ;
	return (
			(sharype == SharypeBookmark)
			||
			(sharype == SharypeLiveRSS)
			||
			(sharype == SharypeSeparator)  // Added, bug fix, BookMacster 1.14.7
			||
			(sharype == SharypeSoftFolder)
			||
			(sharype == SharypeBar)
			||
			(sharype == SharypeMenu)
			) ;
}


#pragma mark * Status Accounting

- (BOOL)getExternallyDerivedLastKnownTouch:(NSDate**)date_p {
	
	NSString* path ;
	NSDate* edlkt = nil;
	
	// Start by assuming best case, because these files may not exist
	// and in that case their modification date never happened
	NSDate* result1 = [NSDate distantPast] ;
	NSDate* result2 = [NSDate distantPast] ;
	// Could be either Omniweb, or else an empty document (all 0)
	path = [self filePathBarError_p:NULL] ;
	if (path) {
		result1 = [[NSFileManager defaultManager] modificationDateForPath:path] ;
	}
	path = [self filePathMenuError_p:NULL] ;
	if (path) {
		result2 = [[NSFileManager defaultManager] modificationDateForPath:path] ;
	}
	edlkt = [result1 laterDate:result2] ;
	path = [self filePathOharedError_p:NULL] ;
	if (path) {
		result1 = [[NSFileManager defaultManager] modificationDateForPath:path] ;
	}
	edlkt = [edlkt laterDate:result1] ;
	
	if (!edlkt) {
		// No files exist.  Give the "worst case" answer, forcing data to be re-read.
		edlkt = [NSDate date] ;
	}
	
	if (date_p) {
		*date_p = edlkt ;
	}
	return YES ;
}


#pragma mark * Writing Bookmarks Data to Auxiliary Files

- (void)addOmniWebShortcutFromStark:(id)stark
					   toDictionary:(NSMutableDictionary*)dic {
	NSString* shortcut = [stark shortcut] ;
	NSString* url = [(Stark*)stark url] ;
	if (shortcut && url) {
		[dic setObject:shortcut
				forKey:url] ;
	}
}

- (void)addOmniWebVisitHistoryFromStark:(id)stark
						   toDictionary:(NSMutableDictionary*)dic {
	NSDate* lastVisitedDate = [stark lastVisitedDate] ;
	NSNumber* visitCount = [stark visitCount] ;
	NSString* url = [(Stark*)stark url] ;
	if (url && (lastVisitedDate || visitCount)) {
		NSMutableDictionary* itemDic = [[NSMutableDictionary alloc] init] ;
		if (lastVisitedDate) {
			//NSTimeInterval timeInterval = [lastVisitedDate timeIntervalSinceReferenceDate] ;
			//NSString* dateString = [NSString stringWithInt:(NSUInteger)timeInterval] ;
			[itemDic setObject:lastVisitedDate forKey:constKeyLastVisitedDate] ;
		}
		if (visitCount) {
			[itemDic setObject:visitCount forKey:constKeyVisitCount] ;
		}
		
		NSDictionary* itemDicOut = [itemDic copy] ;
		[itemDic release] ;
		[dic setObject:itemDicOut forKey:url] ;
		[itemDicOut release] ;
	}
}

- (void)writeOmniWebShortcutDictionary:(NSDictionary*)dicBookdog {
	
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults] ;
	id omniWebPrefs = [userDefaults persistentDomainForName:@"com.omnigroup.OmniWeb5"] ;
	NSDictionary* dicIn = [omniWebPrefs objectForKey:@"OW5AddressShortcuts"] ;
	
	NSMutableDictionary* dicOut = [[NSMutableDictionary alloc] init] ;
	// We begin by writing to dicOut all existing "fixed" entries, 
	// those which seem to be built into OmniWeb and are not associated
	// with any user bookmark.  The only distinguising thing I can
	// see about these is that they have a "name" key, while entries
	// associated with bookmarks do not have a "name" key.
	if (dicIn) {
		NSEnumerator* d = [dicIn keyEnumerator] ;
		NSString* key ;
		while ((key = [d nextObject])) {
			NSDictionary* item = [dicIn objectForKey:key] ;
			if ([item objectForKey:@"name"]) {
				[dicOut setObject:item forKey:key] ;
			}
		}
	}
	
	// If dicIn is nil (no existing shortcuts), then the enumerator f
	// will be nil, and the inner loop below will never execute.  But
	// we should still create a dicOut which will have all our entries	
	
	// Now, we consider each of the shortcuts from Bookmarksman
	NSEnumerator* e = [dicBookdog keyEnumerator] ;
	NSString* key ;
	while ((key = [e nextObject])) {
		NSString* shortcut = [dicBookdog objectForKey:key] ;
		BOOL bookdogItemDone = NO ;
		NSEnumerator* f = [dicIn objectEnumerator] ;
		NSDictionary* itemDicIn ;
		while ((itemDicIn = [f nextObject])) {
			NSString* url = [itemDicIn objectForKey:@"format"] ;
			if ([url isEqualToString:key]) {
				// Found a match
				// Because, in OmniWeb, the key is the shortcut, we change only the key
				[dicOut setObject:itemDicIn forKey:shortcut] ;
				bookdogItemDone = YES ;
				break ;					
			}
		}
		
		if (!bookdogItemDone) {
			// The item did not exist, so we must add it
			NSDictionary* newItemDic = [NSDictionary dictionaryWithObjectsAndKeys:
										key, @"format",  // the BookMacster key is the url.  OmniWeb uses "format" to mean "url"  WHY???
										@"GET", @"method", // just copying OmniWeb
										nil] ;
			[dicOut setObject:newItemDic forKey:shortcut] ;
		}
	}
	
	// Finally, write out the revised dictionary
	NSMutableDictionary* newOmniWebPrefs = [omniWebPrefs mutableCopy] ;
	[newOmniWebPrefs setObject:dicOut forKey:@"OW5AddressShortcuts"] ;
	[dicOut release] ;
	[userDefaults setPersistentDomain:newOmniWebPrefs forName:@"com.omnigroup.OmniWeb5"] ;
	[newOmniWebPrefs release] ;
	[userDefaults synchronize] ;
	
	//	CFPreferencesSetValue (
	//						   (CFStringRef)@"OW5AddressShortcuts",
	//						   (CFDictionaryRef)dicOut,
	//						   (CFStringRef)@"com.omnigroup.OmniWeb5",
	//						   kCFPreferencesCurrentUser,
	//						   kCFPreferencesCurrentHost
	//						   ) ;	
	//	CFPreferencesSynchronize(
	//							 (CFStringRef)@"com.omnigroup.OmniWeb5",
	//							 kCFPreferencesCurrentUser,
	//							 kCFPreferencesCurrentHost
	//							 ) ;	
}

- (BOOL)writeOmniWebVisitHistoryDictionary:(NSDictionary*)bookdogHistories
								   error_p:(NSError**)error_p {
	NSArray* historiesIn = [self omniWebHistoriesFromDiskError_p:error_p] ;
	
	// OmniWeb seems to ^not^ delete a bookmark's history entry
	// when a bookmark is deleted, so we keep everything in there
	NSMutableArray* historiesOut = [historiesIn mutableCopy] ;
	
	NSEnumerator* f = [bookdogHistories keyEnumerator] ;
	NSString* bookdogURL ;
	while ((bookdogURL = [f nextObject])) {
		NSDictionary* bookdogItem = [bookdogHistories objectForKey:bookdogURL] ;
		NSNumber* newVisitCount = [bookdogItem objectForKey:constKeyVisitCount] ;
		NSDate* newLastVisitedDate = [bookdogItem objectForKey:constKeyLastVisitedDate] ;
		// I thought OmniGroup was supposed to be smart.  Why don't they simply
		// store this as an NSDate??  Why a string of an integer of an NSDate??
		NSTimeInterval newLastVisitedTimeInterval ;
		NSString* newLastVisitedString = nil ;
		if (newLastVisitedDate) {
			newLastVisitedTimeInterval = [newLastVisitedDate timeIntervalSinceReferenceDate] ;
			newLastVisitedString = [[NSString alloc] initWithFormat:@"%ld", (long)(newLastVisitedTimeInterval + 0.5)] ;
		}
		BOOL existingItemUpdated = NO ;
		NSInteger nHistoriesOut = [historiesOut count] ;
		NSInteger i ;
		for (i=0; i<nHistoriesOut; i++) {
			NSDictionary* existingItem = [historiesOut objectAtIndex:i] ;
			if ([[existingItem objectForKey:@"url"] isEqualToString:bookdogURL] ) {
				NSMutableDictionary* existingItemRevised = [existingItem mutableCopy] ;
				if (newVisitCount) {
					[existingItemRevised setObject:newVisitCount forKey:@"numberOfVisits"] ;
				}
				if (newLastVisitedString) {
					[existingItemRevised setObject:newLastVisitedString forKey:@"timeInterval"] ;
				}
				[historiesOut replaceObjectAtIndex:i withObject:existingItemRevised] ;
				// We don't care that it's mutable; in the end, will write it to a file anyhow.
				// I assume that replaceObjectAtIndex -retains the new object and
				// replaces the old object, but docs don't say so
				[existingItemRevised release] ;
				existingItemUpdated = YES ;
				break ;
			}
		}
		
		if (!existingItemUpdated) {
			// Create a new item...
			NSMutableDictionary* itemDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
											bookdogURL, @"url",
											nil] ;
			if (newLastVisitedDate) {
				[itemDic setObject:newLastVisitedString forKey:@"timeInterval"] ;
			}
			if (newVisitCount) {
				[itemDic setObject:newVisitCount forKey:@"numberOfVisits"] ;
			}
			[itemDic setObject:@"unknownName" forKey:@"title"] ;
			// OmniWeb usually names these after the original title attribute that came
			// from the http.  But I don't have that, so I do not add any "title" key.			
			
			[historiesOut insertObject:itemDic atIndex:0] ;
			// We don't care that it's mutable; in the end, will write it to a file anyhow.
			// Also, OmniWeb seems to not notice entries that are written at the end of
			// the array, so that's why I write it at index 0.  This is even after I tried
			// deleting preferences com.omnigroup.OmniWeb.plist, also deleting the HistoryIndex.ox
			// files, etc.  By the way, those .ox files seem to be an Omni Group proprietary
			// database of some kind.  See project oxtool.  Haven't built it yet because it requires
			// several Omni Group frameworks that I haven't built either.  It looks like oxtool
			// is some kind of command-line utility for reading .ox files.
			[itemDic release] ;
		}
		[newLastVisitedString release] ;
	}
	
	// Finally, write the stupid thing back out to the file
	NSDictionary* root = [NSDictionary dictionaryWithObjectsAndKeys:
						  [self omniWebHistoryVersion], @"historyVersion",
						  historiesOut, @"entries",
						  nil] ;
	[historiesOut release] ;
    
    NSData* dataOut = [NSPropertyListSerialization dataWithPropertyList:root
                                                                 format:[self omniWebHistoryFormat]
                                                                options:0
                                                                  error:NULL] ;
	
	NSString* historyPath = [[[self clientoid] filePathParentError_p:error_p] stringByAppendingPathComponent:@"History.plist"] ;
	[dataOut writeToFile:historyPath atomically:YES] ;
    
    return YES ;
}

- (BOOL)writeInfoToAuxiliaryFilesFromTree:(Stark*)tree
								  error_p:(NSError**)error_p {
	NSMutableDictionary* dic ;
	dic = [[NSMutableDictionary alloc] init] ;
	[self recursivelyPerformSelector:@selector(addOmniWebShortcutFromStark:toDictionary:)
						 onRootStark:tree
						  withObject:dic] ;
	[self writeOmniWebShortcutDictionary:dic] ;
	[dic release] ;
	dic = [[NSMutableDictionary alloc] init] ;
	[self recursivelyPerformSelector:@selector(addOmniWebVisitHistoryFromStark:toDictionary:)
						 onRootStark:tree
						  withObject:dic] ;
	[self writeOmniWebVisitHistoryDictionary:dic
									 error_p:(NSError**)error_p] ;
	[dic release] ;
    
    return YES ;
}


#pragma mark * Writing the 3 Main Files

- (void)appendDLAttributesFromStark:(Stark*)stark toString:(NSMutableString*)html
{
	id value ;
	
	if ((value = [stark ownerValueForKey:KEY_DELEGATE_CLASS])) {
		[html appendFormat:@" delegateClass=%@", value] ;
	}
	if ((value = [stark ownerValueForKey:KEY_ARCHIVE_DICTIONARY])) {
		[html appendFormat:@" archiveDictionary=%@", value];
	}
}

- (void)appendAllAvailableOptionalAttributesFromStark:(Stark*)stark toString:(NSMutableString*)html {
	id value ;
	
	if ((value = [stark lastChengDate])) {
		NSTimeInterval timeInterval = [value timeIntervalSinceReferenceDate] ;
		value = [NSString stringWithFormat:@"%ld", (long)timeInterval] ;
		[html appendFormat:@" lastCheckedTime=%@", value];
	} 
	if ((value = [stark ownerValueForKey:KEY_WORD_COUNT])) 
		[html appendFormat:@" wordCount=%@", value];
	
	if ((value = [stark ownerValueForKey:KEY_OMNIWEB_CHECK_FREQUENCY])) 
		[html appendFormat:@" checkFrequency=%@", value] ;
	// Values seen: 'daily', 'weekly'
	
	if ((value = [stark ownerValueForKey:KEY_OMNIWEB_STATUS])) 
	// Values seen: 'unviewed'
		[html appendFormat:@" status=%@", value];
	
	if ((value = [stark ownerValueForKey:KEY_OMNIWEB_FORMS])) 
		[html appendFormat:@" forms=%@", value];
	
	if ((value = [stark exidForClientoid:self.clientoid])) {
		[html appendFormat:@" bookmarkid=%@", [value removeNonDecimalDigitPrefix]] ;
	}
	if ((value = [stark ownerValueForKey:KEY_VALIDATOR])) 
		[html appendFormat:@" validator=\"%@\"", value];
	
}

- (NSMutableString*)browserXMLClauseFromStark:(Stark*)stark
                                  indentLevel:(NSUInteger)nIndents
                               fileProperties:(NSDictionary*)fileProperties_
                                    hartainer:(BkmxHartainer)hartainer
                                  browserRoot:(Stark*)browserRoot {
	id value ;
	NSString* tag ; // formerly used to switch between Firefox and OmniWeb tags
	
	NSMutableString* html = [[NSMutableString alloc] init] ;
	
	NSMutableString *someWhitespace = [[NSMutableString alloc] init] ;
	// someWhitespace is an empty string for OmniWeb
	
	NSString* endLine = @"\n" ;
	
	Sharype sharype = [stark sharypeValue] ;
	
	if (
		(sharype == SharypeBookmark)
		||
		(sharype == SharypeLiveRSS)
		) {
		tag = @"<dt><a" ;
		
		[html appendFormat:@"%@%@", someWhitespace, tag] ;
		
		value = [stark url] ;
		
		if (value) {
			tag = @"href" ;
			NSString* encodedURL = [value  stringByEncodingWithAmpEscapesLevel:2] ;
			[html appendFormat:@" %@=\"%@\"", tag, encodedURL] ;
		}
		
		[self appendAllAvailableOptionalAttributesFromStark:stark toString:html] ;
		
		
		// Close up the attributes, insert the name, close the A tag
		tag = @"a" ;
		[html appendFormat:@">%@</%@>%@", [[stark name] stringByEncodingWithAmpEscapesLevel:1], tag, endLine];
		
		// Comments are added in their own "<DD>" tag
		if ((value = [stark comments]))
		{
			tag = @"dd" ;
			[html appendFormat:@"<%@>%@%@", tag, [value stringByEncodingWithAmpEscapesLevel:2], endLine] ;
		}
		
	}
	else if ([StarkTyper canHaveChildrenSharype:sharype]) {
		if (stark == browserRoot)  {
			NSString* fileHeader = [fileProperties_ objectForKey:constKeyFileHeader] ;
			if (fileHeader!=nil) {
				NSString* nextIDString = [self nextIDStringForHartainer:hartainer] ;
				
				NSMutableString* mutableHeader = [[NSMutableString alloc] initWithString:fileHeader] ;
				if (nextIDString) {
					// This should always execute for OmniWeb
					[mutableHeader replaceOccurrencesOfString:@"NEXT_ID_PLACEHOLDER"
												   withString:nextIDString] ;
				}
				[html appendString:mutableHeader] ;
				[mutableHeader release] ;
			}
		}
		else {
			// It's a container but not root
			BOOL h3Tags = ![[stark ownerValueForKey:KEY_NO_H3_TAGS] boolValue] ;
			[html appendString:@"<dt>"] ;
			if (h3Tags) {
				[html appendString:@"<h3>"] ;
			}
			[html appendString:@"<a"] ;
			
			// OmniWeb RSS feeds are folders that have URLs...
			if ((value = [stark url])) {
				[html appendFormat:@" href=\"%@\"", [value stringByEncodingWithAmpEscapesLevel:2]] ;
			}
			
			[self appendAllAvailableOptionalAttributesFromStark:stark toString:html] ;	
			NSMutableString* tag1 = [[NSMutableString alloc] init] ;
			[tag1 appendString:@"</a>"] ;
			if (h3Tags) {
				[tag1 appendString:@"</h3>"] ;
			}
			[html appendFormat:@">%@%@%@", [[stark name] stringByEncodingWithAmpEscapesLevel:1], tag1, endLine] ;
			[tag1 release] ;
			
			// Comments are added in their own "<DD>" tag immediately following the name
			if ((value = [stark comments])) {
				tag = @"dd" ;
				[html appendFormat:@"<%@>%@%@", tag, [value stringByEncodingWithAmpEscapesLevel:2], endLine] ;
			}
		}
		
		// Handle children.  Note that -restoreRssArticlesInsertAsChildStarks should
		// have already run and converted rss articles back in to regular children. 
		NSArray* children = [stark childrenOrdered] ;
		
		BOOL needs_dl_tags = ( NO 
							  || ([children count] > 0)
							  || ([stark ownerValueForKey:KEY_ARCHIVE_DICTIONARY])
		) ;
		
		if (needs_dl_tags) {
			[html appendString:@"<dl"] ;
			// For RSS containers:
			[self appendDLAttributesFromStark:stark toString:html] ;
			[html appendFormat:@">%@", endLine] ;
		}
		
		for (Stark* nextChild in children) {
			[html appendString:[self browserXMLClauseFromStark:nextChild
												   indentLevel:nIndents+1
												fileProperties:fileProperties_
													   hartainer:(BkmxHartainer)hartainer
												   browserRoot:browserRoot]] ;
		}
		
		if (needs_dl_tags) {
			[html appendFormat:@"</dl>%@", endLine] ;
		}
	}
	else if (sharype == SharypeSeparator) {
		// Append opening tag(s)
		[html appendString:@"<dt><a"] ;
		
		// Append attributes for bookmarkid=
		[self appendAllAvailableOptionalAttributesFromStark:stark toString:html] ;
		
		// Append closing
		NSString* closing = @"></a>" ;
		[html appendString:closing] ;
		[html appendString:endLine] ;
		
	}
	
	[someWhitespace release] ;
	
	return [html autorelease] ;
}

//- (NSData*)browserXMLDataFromCollections:(NSArray*)browserCollections
- (NSData*)browserXMLDataFromRoot:(Stark*)root
				   fileProperties:(NSDictionary*)fileProperties_
						  hartainer:(BkmxHartainer)hartainer {	
	// Call a recursive method to create a string from the root
    NSMutableString* stringOut = [self browserXMLClauseFromStark:root
                                                     indentLevel:0
                                                  fileProperties:fileProperties_
                                                       hartainer:hartainer
                                                     browserRoot:root] ;
	NSString* fileFooter = [fileProperties_ objectForKey:constKeyFileTrailer] ;
	if (fileFooter) {
		[stringOut appendString:fileFooter] ;
	}
	else {
		// OmniWeb always uses Unix endLines
		[stringOut appendString:@"</bookmarkInfo>\n</body>\n</html>\n"] ;
	}
	
	NSStringEncoding encoding ;
	encoding = NSUTF8StringEncoding ;
	
	NSData* dataOut = [stringOut dataUsingEncoding:encoding] ;
	
	return [[dataOut retain] autorelease] ;
}

- (void)writeUsingStyle1InOperation:(SSYOperation*)operation {
	NSError* error_ = nil ;
	[self setError:error_] ;
	
	NSData* dataBar = nil ;
	NSData* dataMenu = nil ;
	NSData* dataShared = nil ;
	Stark* subroot ;
	NSDictionary* fileProperties_ ;
	
	fileProperties_ = [self filePropertiesBar] ;
	if (![fileProperties_ count]) {
		// Must be a Newly-Created Empty Bookmarks.  Use generics:
		fileProperties_ = [self fileProperties] ;
	}
	subroot = [self.starker bar] ;
	if (subroot) {
		dataBar = [self browserXMLDataFromRoot:subroot
								fileProperties:fileProperties_
									 hartainer:BkmxHartainerBar] ;
	}
	
	fileProperties_ = [self filePropertiesMenu] ;
	if (![fileProperties_ count]) {
		// Must be a Newly-Created Empty Bookmarks.  Use generics:
		fileProperties_ = [self fileProperties] ;
	}
	subroot = [self.starker menu] ;
	if (subroot) {
		dataMenu = [self browserXMLDataFromRoot:subroot
								 fileProperties:fileProperties_
									  hartainer:BkmxHartainerMenu] ;
	}
	
	fileProperties_ = [self filePropertiesOhared] ;
	if (![fileProperties_ count]) {
		// Must be a Newly-Created Empty Bookmarks.  Use generics:
		fileProperties_ = [self fileProperties] ;
	}
	subroot = [self.starker ohared] ;
	if (subroot) {
		dataShared = [self browserXMLDataFromRoot:subroot
								   fileProperties:fileProperties_
										hartainer:BkmxHartainerOhared] ;
	}
	
	// Create folder if necessary
	NSFileManager* fm = [NSFileManager defaultManager] ;
	NSString* filePathParent = [[self clientoid] filePathParentError_p:&error_] ;
	if (error_) {
		[self setError:error_] ;
	}
	BOOL success = ![self error] ;
	
	if (![fm fileExistsAtPath:filePathParent] && success) {
		if (![fm createDirectoryAtPath:filePathParent
		   withIntermediateDirectories:YES
							attributes:nil
								 error:&error_]) {
			NSString* msg = @"Can't create directory to write OmniWeb output" ;
			NSLog(@"%@", msg) ;
			error_ = [SSYMakeError(constBkmxErrorCantCreateDirectory, msg) errorByAddingUnderlyingError:error_];
			[self setError:error_] ;
		}
	}
	success = ![self error] ;
	NSString* path ;
	
	path = nil;
	if (dataBar && success) {
		path = [self filePathBarError_p:&error_] ;
		success = (error_ == nil) ;
	}
	if (path && success) {
		success = [self writeData:dataBar
						   toFile:path] ;
	}

	path = nil;
	if (dataMenu && success) {
		path = [self filePathMenuError_p:&error_] ;
		success = (error_ == nil) ;
	}
	if (path && success) {
		success = [self writeData:dataMenu
						   toFile:path] ;
	}
	
	path = nil;
	if (dataShared && success) {
		path = [self filePathOharedError_p:&error_] ;
		success = (error_ == nil) ;
	}
	if (path && success) {
		success = [self writeData:dataShared
						   toFile:path] ;
	}
	
	if (success) {
		// Stupid OmniWeb put its shortcut and lastVisitedDate in different files
		[self writeInfoToAuxiliaryFilesFromTree:[self.starker root]
										error_p:&error_] ;
		if (error_) {
			[self setError:error_] ;
		}
	}
	
	[operation writeAndDeleteDidSucceed:(![self error])] ;
}


#pragma mark * Reading Bookmarks data from Auxiliary Files

- (void)addShortcutToStark:(id)stark
			fromDictionary:(NSDictionary*)dic {
	NSString* url = [(Stark*)stark url] ;
	if (url) {
		NSString* shortcut = [dic objectForKey:url] ;
		if (shortcut) {
			[stark setShortcut:shortcut] ;
		}
	}
}

- (void)addVisitHistoryToStark:(id)stark
				fromDictionary:(NSDictionary*)dic {
	NSString* url = [(Stark*)stark url] ;
	if (url && dic) {
		NSDictionary* entry = [dic objectForKey:url] ;
		[stark setLastVisitedDate:[entry objectForKey:constKeyLastVisitedDate]] ;
		[stark setVisitCount:[entry objectForKey:constKeyVisitCount]] ;
	}
}

- (NSDictionary*)omniWebShortcutsFromDisk {
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults] ;
	id omniWebPrefs = [userDefaults persistentDomainForName:@"com.omnigroup.OmniWeb5"] ;
	NSDictionary* dicIn = [omniWebPrefs objectForKey:@"OW5AddressShortcuts"] ;
	
	NSMutableDictionary* dicOut = [[NSMutableDictionary alloc] init] ;
	if ([dicIn respondsToSelector:@selector(objectForKey:)]) {
		NSEnumerator* e = [dicIn keyEnumerator] ;
		NSString* key ;
		while ((key = [e nextObject])) {
			NSDictionary* innerDic = [dicIn objectForKey:key] ;
			if ([innerDic respondsToSelector:@selector(objectForKey:)]) {
				NSString* url = [innerDic objectForKey:@"format"] ;
				[dicOut setObject:key forKey:url] ;
			}
			else if (innerDic) {
				NSLog(@"624-9523 Ignoring corrupt OmniWeb pref") ;
			}
		}
	}
	else if (dicIn) {
		NSLog(@"624-9524 Ignoring corrupt OmniWeb pref") ;
	}
	
	NSDictionary* output = [NSDictionary dictionaryWithDictionary:dicOut] ;
	[dicOut release] ;
	
	return output ;			
}

- (NSArray*)omniWebHistoriesFromDiskError_p:(NSError**)error_p {
	NSString* historyPath = [[[[self clientoid] filePathParentError_p:error_p] stringByAppendingPathComponent:[self extoreConstants_p]->defaultFilename] stringByAppendingPathComponent:@"History.plist"] ;
	
	NSData* historyData = nil ;
	if (historyPath) {
		historyData = [NSData dataWithContentsOfFile:historyPath] ;
	}
	
	NSDictionary* rootDic = nil ;
	NSPropertyListFormat format = NSPropertyListXMLFormat_v1_0 ;
	if (historyData) {
        rootDic = [NSPropertyListSerialization propertyListWithData:historyData
                                                            options:NSPropertyListImmutable
                                                             format:&format
                                                              error:NULL] ;
	}
	[self setOmniWebHistoryFormat:format] ;
	
	NSArray* histories = nil ;
	if ([rootDic respondsToSelector:@selector(objectForKey:)]) {
		histories = [rootDic objectForKey:@"entries"] ;
		NSNumber* version = [rootDic objectForKey:@"historyVersion"] ;
		[self setOmniWebHistoryVersion:version] ;
	}
	else if (rootDic) {
		NSLog(@"624-9520 Ignoring corrupt OmniWeb history") ;
	}
	
	return histories ;
}	

- (NSDictionary*)omniWebVisitHistoryFromDiskError_p:(NSError**)error_p {
	NSArray* histories = [self omniWebHistoriesFromDiskError_p:error_p] ;
	
	NSMutableDictionary* dicOut = [[NSMutableDictionary alloc] init]  ;
	if (histories) {
		NSEnumerator* e = [histories objectEnumerator] ;
		NSDictionary* history ;
		while ((history = [e nextObject])) {
			if ([history respondsToSelector:@selector(objectForKey:)]) {
				NSString* url = [history objectForKey:@"url"] ;
				// The next qualification is because a url of empty string would match
				// to the bookmarks bar and bookmarks menu which also have an empty string
				if ([url length] > 0) {
					NSNumber* visitCount = [history objectForKey:@"numberOfVisits"] ;
					NSString* timeIntervalString = [history objectForKey:@"timeInterval"] ;
					NSMutableDictionary* itemDic = [[NSMutableDictionary alloc] init] ;
					if (timeIntervalString) {
						NSDate* lastVisitedDate = [NSDate dateWithTimeIntervalSinceReferenceDate:[timeIntervalString integerValue]] ;
						[itemDic setObject:lastVisitedDate forKey:constKeyLastVisitedDate] ;
					}
					if (visitCount) {
						[itemDic setObject:visitCount forKey:constKeyVisitCount] ;
					}
					NSDictionary* itemDicOut = [itemDic copy] ;
					[itemDic release] ;
					[dicOut setObject:itemDicOut forKey:url] ;
					[itemDicOut release] ;
				}
			}
			else if (history) {
				NSLog(@"624-9521 Ignoring corrupt OmniWeb history") ;
			}
		}
	}
	
	NSDictionary* output = [dicOut copy] ;
	[dicOut release] ;
	
	return [output autorelease] ;
}

#pragma mark * Creating new External Identifiers

- (BOOL)validateExid:(NSString*)exid
	   isAfterExport:(BOOL)isAfterExport
			forStark:(Stark*)stark {
	unichar collectionIndicator = [exid characterAtIndex:2] ;
	switch (collectionIndicator) {
		case 'B':
			return [stark isInBar] ;
		case 'M':
			return [stark isInMenu] ;
		case 'S':
			return [stark isInOhared] ;
	}
	
	return NO ;
}

- (void)getFreshExid_p:(NSString**)exid_p
            higherThan:(NSInteger)higherThan
              forStark:(Stark*)stark
               tryHard:(BOOL)tryHard {
	NSUInteger idInt  = 1 ;
	higherThan++ ;
	NSString* prefix ;
	if ([stark isInBar]) {
		idInt = MAX([self nextOmniWebBarID], higherThan) ;
		prefix = @"OWB:" ;
		[self setNextOmniWebBarID:(idInt + 1)] ;
	}
	else if ([stark isInMenu]) {
		idInt = MAX([self nextOmniWebMenuID], higherThan) ;
		prefix = @"OWM:" ;
		[self setNextOmniWebMenuID:(idInt + 1)] ;
	}
	else if ([stark sharypeValue] == SharypeBar) {
		prefix = @"OXB:" ;
	}
	else if ([stark sharypeValue] == SharypeMenu) {
		prefix = @"OXM:" ;
	}
	else if ([stark sharypeValue] == SharypeOhared) {
		prefix = @"OXS:" ;
	}
	else  {
		idInt = MAX([self nextOmniWebOharedID], higherThan) ;
		prefix = @"OWS:" ;
		[self setNextOmniWebOharedID:(idInt + 1)] ;
	}
	
	*exid_p = [NSString stringWithFormat:@"%@%ld", prefix, (long)idInt] ;
}

#pragma mark * Reading the 3 Main Files

- (void)setValuesInStark:(Stark*)stark
	fromParsingXMLString:(NSString*)xml
			  collection:(unichar)collection {
	NSString* value ;
	
	if ((value = [xml quotedAttributeValueForKey:@"href"])) {
		// Crash Here!  See Note 20110830-01 at end of file
		[stark setUrl:[value stringByDecodingAmpEscapes]] ;
	}
	if ((value = [xml unquotedAttributeValueForKey:@"lastCheckedTime"])) {
		[stark setLastChengDate:[NSDate dateWithTimeIntervalSinceReferenceDate:[value integerValue]]] ;
	}
	if ((value = [xml unquotedAttributeValueForKey:@"wordCount"])) {
		[stark setOwnerValue:value forKey:KEY_WORD_COUNT] ;
	}
	if ((value = [xml unquotedAttributeValueForKey:@"checkFrequency"])) {
		[stark setOwnerValue:value forKey:KEY_OMNIWEB_CHECK_FREQUENCY] ;
	}
	if ((value = [xml unquotedAttributeValueForKey:@"status"])) {
		[stark setOwnerValue:value forKey:KEY_OMNIWEB_STATUS] ;
	}
	if ((value = [xml unquotedAttributeValueForKey:@"forms"])) {
		[stark setOwnerValue:value forKey:KEY_OMNIWEB_FORMS] ;
	}
	if ((value = [xml unquotedAttributeValueForKey:@"bookmarkid"])) {
		NSString* exid ;
		switch (collection) {
			case 'F': // from "Favorites.html"
				exid =  @"OWB:" ; // bar
				break ;
			case 'B': // from "Bookmarks.html"
				exid = @"OWM:" ; // menu
				break ;
			case 'P': // from "Public.html"
				exid = @"OWS:" ; // ohared
				break ;
			default:
				exid = @"???:" ; // keep from crashing
		}
		exid = [exid stringByAppendingString:value] ;
		[stark setExid:exid
			 forClientoid:self.clientoid] ;
	}
	if ((value = [xml quotedAttributeValueForKey:@"validator"])) {
		[stark setOwnerValue:value forKey:KEY_VALIDATOR] ;
	}
	if ((value = [xml unquotedAttributeValueForKey:@"delegateClass"])) {
		[stark setOwnerValue:value
							 forKey:KEY_DELEGATE_CLASS] ;
		if ([value isEqualToString:@"OWRSSBookmarks"]) {
			[stark setSharypeValue:SharypeLiveRSS] ;
		}
	}
	if ((value = [xml unquotedAttributeValueForKey:@"archiveDictionary"])) {
		[stark setOwnerValue:value
							 forKey:KEY_ARCHIVE_DICTIONARY] ;
	}
}


- (BOOL)parseData:(NSData*)dataIn
		shortcuts:(NSDictionary*)shortcuts
	 visitHistory:(NSDictionary*)visitHistory
	returningRoot:(Stark**)root_p
			  bar:(Stark**)bookBar_p
		  hartainer:(BkmxHartainer)hartainer
addingFilePropertiesTo:(NSMutableDictionary*)fileProperties_
reportTroubleWithPath:(NSString*)path {
	NSError* error_ = nil ;
	NSString* msg ;
	
	unichar collection = ([[path lastPathComponent] characterAtIndex:0]) ;
	
	*root_p = [[self starker] freshStark] ;
	[*root_p setSharypeValue:SharypeRoot] ;
	if (bookBar_p) {
		*bookBar_p = nil ;
	}
	
	if (!dataIn) {
		msg = @"No data" ;
		error_ = SSYMakeError(constBkmxErrorNoData, msg) ;
	}
	
	NSString* fileAsString = nil ;
	
	NSStringEncoding stringEncodingStated ;
	NSStringEncoding stringEncodingUsed ;
	NSString* endLine ;
	BOOL success = YES;
	
	if (!error_) {
		success = [SSYTextCodec decodeTextData:dataIn
							   decodedString_p:&fileAsString
						stringEncodingStated_p:&stringEncodingStated
						  stringEncodingUsed_p:&stringEncodingUsed
							   newLinesFound_p:&endLine 
									   error_p:&error_] ;
	}
	
	if (success && !error_) {
		// Set up to scan the bookmark file
		NSScanner *scanWhole = [[NSScanner alloc] initWithString:fileAsString] ;
		[scanWhole setCharactersToBeSkipped:nil];
		
		NS_DURING
		
		// Scan and store the file header 
		NSString* fileHeader = nil ;
		BOOL ok = YES ;
		
		NSString* fileHeaderPart0 = @"" ; // initialized for safety in case of corrupt file
		NSString* fileHeaderPart1 = @"" ; // initialized for safety in case of corrupt file
		NSString* fileHeaderPart2 = @"" ; // initialized for safety in case of corrupt file
		NSInteger nextID = 24999 ;  // More items than most people have, but < 32768
		
		if (ok) {
			ok = [scanWhole scanUpToString:@"<bookmarkInfo " intoString:&fileHeaderPart0] ;
		}
		if (ok) {
			ok = [scanWhole scanUpToAndThenLeapOverString:@"nextId=" intoString:&fileHeaderPart1] ;
		}
		if (ok) {
			ok = [scanWhole scanInteger:&nextID] ;
		}
		if (ok) {
			ok = [scanWhole scanUpToString:endLine intoString:&fileHeaderPart2] ;
		}
		if (ok) {
			fileHeader = [NSString stringWithFormat:@"%@%@nextId=NEXT_ID_PLACEHOLDER%@%@",
						  fileHeaderPart0,
						  fileHeaderPart1,
						  fileHeaderPart2,
						  endLine] ;
		}
		
		[self setNextID:nextID
			 forHartainer:hartainer] ;
		
		// Try and recover if no header was found (scanner will be at end)
		if (!ok) {
			[scanWhole setScanLocation:0] ;
		}
		
		if (fileHeader != nil) {
			[fileProperties_ setObject:fileHeader forKey:constKeyFileHeader] ;
				}
		else {
			NSLog(@"No file header found in %@", path) ;
		}
		
		NS_HANDLER
		NSString* msg = @"Error parsing file header" ;
		error_ = SSYMakeError(constBkmxErrorFileParsingError, msg) ;
		error_ = [error_ errorByAddingUnderlyingException:localException] ;
		NS_ENDHANDLER
		
		if (!error_)
		{
			NS_DURING
			NSString* tokenEndMark = [@"</A>" stringByAppendingString:endLine] ;
			
			// Prior to Bookdog 3.0.7, tokenEndMark was the constant @"</A>".  In Bookdog 3.0.7,
			// I added the endline to handle the case of javascript bookmarklets which
			// can contain </A> tags inside their URL, like this
			//               HREF=".....</A>...."
			// Probably a better way would be to search for the closing quote when parsing an HREF,
			// but I think that might require re-thinking much of this parsing method.  
			
			Stark* stark =  *root_p ;
			
			NSScanner *scanToken = nil ;
			NSString* tokenPrefix = nil ;
			NSString* tempString1 = nil ;
			NSString* tempString2 = nil ;
			NSString* tempString3 = nil ;
			unsigned long scanIndex = 0;
			NSMutableArray* currentFeedRssArticles = [NSMutableArray array] ;
			
			// Parse the file, one token at a time.
			while (![scanWhole isAtEnd]) {
				[scanWhole scanUpToString:@"<" intoString:NULL] ;
				scanIndex = [scanWhole scanLocation];
				if ((scanIndex+3) < [fileAsString length]) // This condition is to make sure a malformed file does not cause an out-of-range except in the next line.
				{
					tokenPrefix = [[NSString alloc] initWithString:[[fileAsString substringWithRange:NSMakeRange(scanIndex,3)] uppercaseString]];
					
					// Remember where we are, needed for some OmniWeb look-ahead scans
					NSUInteger itemLoc = [scanWhole scanLocation] ;
					
					// You can't tell by reading the opening tag alone whether an OmniWeb
					// item is a folder, bookmark or separator.  Instead, we have to peek ahead
					// to see and assign these three BOOLs...
					BOOL omniWebNextLineIsDL = NO ;  // (Must initialize in case not OmniWeb)
					BOOL omniWebNoHREF = NO ;        // (Must initialize in case not OmniWeb)
					BOOL omniWebEmptyName = NO ;     // (Must initialize in case not OmniWeb)
					
					// Scan this line
					tempString1 = @"" ;
					[scanWhole scanUpToAndThenLeapOverString:endLine intoString:&tempString1] ;
					
					// Determine if omniWebNoHREF
					scanToken = [[NSScanner alloc] initWithString:tempString1];
					[scanToken scanUpToAndThenLeapOverString:@"<a " intoString:NULL] ;
					omniWebNoHREF = ![scanToken scanString:@"href=" intoString:NULL] ;
					[scanToken release] ;
					
					// Determine if omniWebEmptyName
					omniWebEmptyName = [tempString1 locationOfUnquotedSubstring:@"></a>"] != NSNotFound ;
					
					// Determine if omniWebNextLineIsDL
					NSUInteger beginNextLine = [scanWhole scanLocation] ;
					[scanWhole scanString:@"<dl" intoString:NULL] ;
					omniWebNextLineIsDL = ([scanWhole scanLocation] - beginNextLine) == 3 ;
					
					
					
					// set scanner location back to where we were
					[scanWhole setScanLocation:itemLoc] ;
					
					/* To distinguish between Bookmarks, Containers and Separators in OmniWeb, we
					 next implement, in the first several branches below, this algorithm:
					 if (tag has an href)
					 >   It's a Bookmark
					 else if (tagPrefix is <dd)
					 >   It's a Comment
					 else if (nextTagIsDL)
					 >   It's a Container (*)
					 else if (tag has a name, not the empty string "")
					 >   It's a Container
					 else
					 >   It's a Separator
					 (*) Furthermore, if it has an href attribute, it's an RSS container
					 but that does not matter for present purposes.
					 Note: The above algorithm implies that if you delete the name of
					 an empty container (one without a <dl> following) in OmniWeb,
					 it will become a separator.  Also, deleting the name of a 
					 non-empty container is OK; it just leaves a nameless folder.
					 That's exactly what happens!!
					 (tested in OmniWeb5.5) */
					
					Stark* container = nil;
					
					if ([tokenPrefix isEqualToString:@"<A "] && !omniWebNextLineIsDL && !omniWebNoHREF)  {
						// Found a bookmark or RSS Article (not a container)
						[scanWhole scanUpToString:tokenEndMark intoString:&tempString1];

						stark = [[self starker] freshStark] ;
						NSInteger tagEnd = [tempString1 locationOfUnquotedSubstring:@">"] ;							
						if (tagEnd <= [tempString1 length]) {
							tempString2 = [tempString1 substringWithRange:NSMakeRange(0, tagEnd)] ;
							NSString* name = [tempString1 substringFromIndex:(tagEnd+1)] ;
							[stark setName:[name stringByDecodingAmpEscapes]] ;
							
							[self setValuesInStark:stark
							  fromParsingXMLString:tempString2
										collection:collection] ;								
						}
						else {
							NSException* exception = [NSException
													  exceptionWithName:@"Can't find closing > on token"
													  reason:[NSString stringWithFormat:@"Corrupt file.  tagEnd=%ld.  Maybe the following item has a name which begins with an invalid UTF-8 sequence or a stray (unpaired) double-quote?\n\n%@", (long)tagEnd, [tempString1 substringToIndex:MIN(1024, [tempString1 length])]]
													  userInfo:nil] ;
							[exception raise] ;
						}
						
						// Note that, since visitHistory and shortcuts dics are keyed by
						// url, we waited until after url has been set by setValuesInStark:::
						// before doing this.  (Bug fixed in BookMacster 1.1).
						[self addVisitHistoryToStark:stark
									  fromDictionary:visitHistory] ;
						[self addShortcutToStark:stark
								  fromDictionary:shortcuts] ;
						
						[scanWhole setScanLocation:([scanWhole scanLocation]+1)];
						if ([container sharypeValue] == SharypeLiveRSS) {
							// It's an RSS article
							[currentFeedRssArticles addObject:stark] ;
						}
						else {
							// Its a regular bookmark
							[stark setSharypeValue:SharypeBookmark] ;
							[stark moveToBkmxParent:container] ;
						}						
					}
					// We have to check for comments before containers, because comments can also have omniWebNextLineIsDL
					else if ([tokenPrefix isEqualToString:@"<DD"]) {
						// Found comments of the current item
						[scanWhole scanUpToString:@">" intoString:NULL];
						[scanWhole setScanLocation:([scanWhole scanLocation]+1)];
						// Firefox 2 always ends comments with a \n, but there could also be \n within the comment
						// So, we parse up to the next opening <, which will probably be a <DT> into tempString1
						[scanWhole scanUpToString:@"<" intoString:&tempString1];
						// But now we have to remove the spaces which are the indents in the next line
						while ([tempString1 hasSuffix:@" "]) {
							tempString1 = [tempString1 stringByRemovingLastCharacters:1] ;
						}
						// Finally, we check for and then remove the \n which delimits the end of the comment
						if (![tempString1 hasSuffix:endLine]) {
							NSLog(@"Error: Description not ending in line ending:\n%@", tempString1) ;
						}
						else {
							tempString1 = [tempString1 stringByRemovingLastCharacters:[endLine length]] ; // Usually 1, but 2 for DOS/Windows
						}
						[stark setComments:[tempString1 stringByDecodingAmpEscapes]];
					}
					else if (
							 // If folder line is followed by its <dd> comment:
							 [tokenPrefix isEqualToString:@"<H3"]
							 ||
							 omniWebNextLineIsDL
							 ||
							 ([tokenPrefix isEqualToString:@"<A "] && omniWebNoHREF && !omniWebEmptyName)
							 ) {
						// Found a container (as opposed to a bookmark)
						
						NSString* tokenEnd =  [tokenPrefix isEqualToString:@"<H3"] ? @"</H3>" : endLine ;
						[scanWhole scanUpToString:tokenEnd intoString:&tempString1];
						
						
						stark = [self.starker freshStark] ;
						[stark setSharypeValue:SharypeSoftFolder] ;
						[stark moveToBkmxParent:container] ;
						[stark setParent:container] ;
						
						scanToken = [[NSScanner alloc] initWithString:tempString1];
						
						tempString3 = @"" ;
						[scanToken scanUpToString:@"<a" intoString:&tempString3] ;
						tempString2 = @"" ;
						[scanToken scanUpToString:@">" intoString:&tempString2] ;
						
						// Read other attributes, such as bookmarkid
						[self setValuesInStark:stark
						  fromParsingXMLString:tempString2
									collection:collection] ;
						
						// Scan, decode and set item name
						[scanToken setScanLocation:([scanToken scanLocation]+1)] ;
						// Next line is for bug fix in 3.11.5: Space at beginning of folder name was skipped
						[scanToken setCharactersToBeSkipped:[NSCharacterSet characterSetWithRange:NSMakeRange(0,0)]] ;
						tempString2 = @"" ;  // Bug fix in 4.2.8, in case name is @"" and nothing is scanned.
						[scanToken scanUpToString:@"</a>" intoString:&tempString2] ;
						tempString2 = [tempString2 stringByDecodingAmpEscapes] ;
						[stark setName:tempString2] ;
						
						// Some OmniWeb containers don't have <H3> tags (Bookit???)
						// Ordinarily, in OmniWeb and Firefox, folders have <H3> tags.  However, in OmniWeb, an item which does not have a href= attribute is always a folder
						// whether or not it has H3 tags.  You can create such a funny "fookmark" in OmniWeb Manage Bookmarks by
						// (1) create a new bookmark (2) delete all characters in its URL and (3) watch closely.  You'll see that its
						// icon suddenly turns from a bookmark into a folder.  Re-verified this in OmniWeb 5.7.
						if (![tempString3 hasSuffix:@"<h3>"]) {
							[stark setOwnerValue:[NSNumber numberWithBool:YES]
												 forKey:KEY_NO_H3_TAGS] ;
						}
						
						[scanToken release];
						[scanWhole setScanLocation:([scanWhole scanLocation]+1)] ;
					}
					else if ([tokenPrefix isEqualToString:@"<DL"]) {
						// Entered definition list (DL), so recurse down:
						
						// OmniWeb RSS feeds are followed by definition lists
						// which contain a couple attributes.  These will be
						// added to the current stark.
						[scanWhole scanUpToString:@"<dl" intoString:NULL];
						[scanWhole scanUpToString:@">" intoString:&tempString1];
						scanToken = [[NSScanner alloc] initWithString:tempString1];
						[scanToken scanUpToString:@">" intoString:&tempString2];
						[self setValuesInStark:stark
					  fromParsingXMLString:tempString2
								   collection:collection] ;
						[scanToken release] ;
						
						
						[scanWhole setScanLocation:(scanIndex+1)];
					}
					else if ([tokenPrefix isEqualToString:@"</D"]) {
						// Exitted definition list (DL)
						// note that we only scan for the first two characters of a tag
						// that is why this tag is "</D" but it must in fact be "</DL"
						
						// If this container is an RSS feed, pack its articles into it
						if ([container sharypeValue] == SharypeLiveRSS) {
							[container setRssArticlesFromAndRemoveStarks:currentFeedRssArticles] ;
							[currentFeedRssArticles removeAllObjects] ;
						}
						
						[scanWhole setScanLocation:(scanIndex+1)] ;
					}
					else if ([tokenPrefix isEqualToString:@"<H1"]) {
						// Scanning file header
						[scanWhole scanUpToString:@">" intoString:&tempString1];
						scanToken = [[NSScanner alloc] initWithString:tempString1] ;
						[scanToken scanUpToString:@">" intoString:&tempString2] ;
						
						[scanToken release] ;
						[scanWhole setScanLocation:([scanWhole scanLocation]+1)];
						[scanWhole scanUpToString:@"</H1>" intoString:&tempString2];
						// Make a copy in case tempString2 changes:
						[fileProperties_ setObject:[[tempString2 copy] autorelease] forKey:constKeyFileSubheader] ;
						
						[scanWhole setScanLocation:([scanWhole scanLocation]+1)];
						[*root_p setName:tempString2] ;
					} 
					else if ([tokenPrefix isEqualToString:@"<BO"]) {
											[scanWhole scanUpToString:@">" intoString:NULL];
						[scanWhole setScanLocation:([scanWhole scanLocation]+1)];
					}
					else if (
							  (	[tokenPrefix isEqualToString:@"<A "]     // Normal case, i.e. <a bookmarkid=nn...
							   || [tokenPrefix isEqualToString:@"<A>"]  // In case no bookmarkid (fixed Bookdog 4.1)
							   )
							  && !omniWebNextLineIsDL
							  && omniWebNoHREF
						) {
						// Found a menu separator
						
						stark = [self.starker freshStark] ;
						[stark setSharypeValue:SharypeSeparator] ;
						[stark moveToBkmxParent:container];
						// Name of a separator is not seen in outline but is seen in Undo/Redo menu and Inspector
						// So, we give it a name...
						[stark setName:[[BkmxBasis sharedBasis] labelSeparator]] ;  // This may be overwritten if we now find a NAME= attribute...
						
						NSString* delimiter = @"></a>" ; 
						
						[scanWhole scanUpToAndThenLeapOverString:delimiter intoString:&tempString2] ;
						
						// This is to find the NAME= attribute in a separator written by Foxmarks, as in:
						//  <HR NAME="Items Merged by Foxmarks">
						// In OmniWeb, it will find the bookmarkid=
						[self setValuesInStark:stark
					  fromParsingXMLString:tempString2
								   collection:collection] ;								
					}
					else if ([tokenPrefix isEqualToString:@"</B"]) {
						// Found the </bookmarkInfo> tag which begins the file footer (end of file)
						NSString* fileFooter = @"" ; // initialized for safety in case of corrupt file
						[scanWhole scanUpToString:@"You won't find this!!" intoString:&fileFooter] ;
						// Do not worry about line endings since cross-platform Firefox does not have a file footer
						// This is only for OmniWeb, which is OSX (Unix) only.
						[fileProperties_ setObject:fileFooter forKey:constKeyFileTrailer] ;
					}
					else {
						// This will execute to scan by the information-less <DT> tag
						if (![tokenPrefix isEqualToString:@"<DT"] && ![tokenPrefix isEqualToString:@"<P>"]) {
							NSLog(@"Unknown tokenPrefix: %@", tokenPrefix) ;
						}
						[scanWhole scanUpToString:@">" intoString:NULL];
					}
					
					[tokenPrefix release] ;
				}
				else {
					break ;  // Needed in case of no line feed or incomplete tag at end of last line.  Otherwise, will get
					// stuck in an infinite loop when scan location is somewhere in the last three characters.
				}
			}
			NS_HANDLER
			NSString* msg = @"Error parsing file body" ;
			error_ = SSYMakeError(constBkmxErrorFileParsingError, msg) ;
			error_ = [error_ errorByAddingUnderlyingException:localException] ;
			NS_ENDHANDLER
			
					[scanWhole release];
			
		}
	}
	
	if (error_) {
		NSError* error1 = SSYMakeError(65583, @"Error reading OmniWeb file") ;
		error1 = [error1 errorByAddingUnderlyingError:error_] ;
		error1 = [error1 errorByAddingUserInfoObject:[[self clientoid] exformat]
											  forKey:@"Exformat"] ;
		error1 = [error1 errorByAddingUserInfoObject:path
											  forKey:@"Path"] ;
		error1 = [error1 errorByAddingUserInfoObject:[[[NSFileManager defaultManager] modificationDateForPath:path] description]
											  forKey:@"File Modification Date"] ;
		
		[self setError:error1] ;
	}
	
	return (error_ == nil) ;
}

- (void)readExternalStyle1ForPolarity:(BkmxIxportPolarity)polarity
                    completionHandler:(void(^)(void))completionHandler {
	[self setError:nil] ;			
	
	NSData* dataInBar = nil ;
	NSData* dataInMenu = nil ;
	NSData* dataInOhared = nil ;
	
	[self setFilePropertiesBar:[NSMutableDictionary dictionary]] ;
	[self setFilePropertiesMenu:[NSMutableDictionary dictionary]] ;
	[self setFilePropertiesOhared:[NSMutableDictionary dictionary]] ;
	
	NSString* filePathBar = nil ;
	NSString* filePathMenu = nil ;
	NSString* filePathOhared = nil ;

	filePathBar = [self filePathBarError_p:NULL] ;
	// Note 293025: The above method will not generate an error for OmniWeb,
	// although it might for Firefox.  If the file does not exist, it
	// will still return the path ...
	if (filePathBar) {
		// ... and then this method will return nil, with an error ...
		dataInBar = [NSData dataWithContentsOfFile:filePathBar
										   options:NSMappedRead
											 error:NULL] ; 
	}
	
	filePathMenu = [self filePathMenuError_p:NULL] ;
	// See Note 293025 above.
	if (filePathMenu) {
		dataInMenu = [NSData dataWithContentsOfFile:filePathMenu
											options:NSMappedRead
											  error:NULL] ; 
	}
	
	filePathOhared = [self filePathOharedError_p:NULL] ;
	// See Note 293025 above.
	if (filePathOhared) {
		dataInOhared = [NSData dataWithContentsOfFile:filePathOhared
											  options:NSMappedRead
												error:NULL] ; 	
	}

	NSError* error = nil ;
	BOOL ok = YES ;
		
	NSDictionary* shortcuts = [self omniWebShortcutsFromDisk] ;
	NSDictionary* visitHistory = [self omniWebVisitHistoryFromDiskError_p:NULL] ;	

	Stark* bookBar = nil ;
	if (ok && dataInBar) {
		ok = [self parseData:dataInBar
				   shortcuts:shortcuts
				visitHistory:visitHistory
			   returningRoot:&bookBar
						 bar:NULL
					 hartainer:BkmxHartainerBar
	  addingFilePropertiesTo:[self filePropertiesBar]
	   reportTroubleWithPath:filePathBar] ;
	}
    if (!bookBar) {
        bookBar = [[self starker] freshStark] ;
    }
	
	Stark* bookMenu = nil ;
	if (ok && dataInMenu) {
		ok = [self parseData:dataInMenu
				   shortcuts:shortcuts
				visitHistory:visitHistory
			   returningRoot:&bookMenu
						 bar:NULL
				   hartainer:BkmxHartainerMenu
	  addingFilePropertiesTo:[self filePropertiesMenu]
	   reportTroubleWithPath:filePathMenu] ;
	}
    if (!bookMenu) {
        bookMenu = [[self starker] freshStark] ;
    }
	
	Stark* bookOhared = nil ;
	if (ok && dataInOhared) {
		ok = [self parseData:dataInOhared
				   shortcuts:shortcuts
				visitHistory:visitHistory
			   returningRoot:&bookOhared
						 bar:NULL
				   hartainer:BkmxHartainerOhared
	  addingFilePropertiesTo:[self filePropertiesOhared]
	   reportTroubleWithPath:filePathOhared] ;
	}
    if (!bookOhared) {
        bookOhared = [[self starker] freshStark] ;
    }
	
	if (ok) {
		// Since these are the root
		// levels in the three files and do not have any OmniWeb bookmarkid strings,
		// we hard-code some special exid strings for them:
		[bookBar setExid:@"OXB:1"
			   forClientoid:self.clientoid] ;
		[bookMenu setExid:@"OXM:1"
				forClientoid:self.clientoid] ;
		[bookOhared setExid:@"OXS:1"
				  forClientoid:self.clientoid] ; 
		
		Stark* root = [self.starker freshStark] ;
		[root assembleAsTreeWithBar:bookBar
							   menu:bookMenu
							unfiled:nil
							 ohared:bookOhared] ;	
	}
	
end:
	[self setError:error] ;
	
	completionHandler() ;
}

#pragma mark * Basic Infrastructure

- (id) initWithIxporter:(Ixporter*)ixporter
              clientoid:(Clientoid*)clientoid
              jobSerial:(NSInteger)jobSerial {
	self = [super initWithIxporter:ixporter
                         clientoid:clientoid
                         jobSerial:jobSerial] ;
	if (self != nil) {
		[self setNextOmniWebBarID:1] ;
		[self setNextOmniWebMenuID:1] ;
		[self setNextOmniWebOharedID:1] ;
	}
	return self;
}

- (void) dealloc {
	[filePropertiesBar release] ;
	[filePropertiesMenu release] ;
	[filePropertiesOhared release] ;
	[omniWebHistoryVersion release] ;
	
	[super dealloc] ;
}

+ (BOOL)parentSharype:(Sharype)parentSharype
  canHaveChildSharype:(Sharype)childSharype {
    BOOL ok = [super parentSharype:parentSharype
               canHaveChildSharype:childSharype] ;
    if (ok) {
        // Only other hartainers are allowed in Root
        if (parentSharype == SharypeRoot) {
            if ([StarkTyper coarseTypeSharype:childSharype] != SharypeCoarseHartainer) {
                ok = NO ;
            }
        }
    }
    
    return ok ;
}

+ (BOOL)canProbablyImportFileType:type
								  data:data {
	if (![type isEqualToString:@"html"]) {
		return NO ;
	}
	
	NSString* wholeFile = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] ;
	// We use ASCII encoding in case there are non-UTF8 charaacters in the file
	// What we're looking for is only ASCII anyhow.
	NSString* prefix = [wholeFile substringToIndex:MIN([wholeFile length], 256)] ;
	[wholeFile release] ;
	if ([prefix containsString:[self constants_p]->telltaleString]) {
		return YES ;
	}
		
	return NO ;
}

@end

// Note 20110830-01.  Today I analyzed a crash report from Dennis Mellein which crashed in
// stringByDecodingAmpEscapes:, when invoking -[NSScanner scanner scanUpToString:intoString:]
// Unfortunately I cannot for the life of me find any input which would make that crash.
// Here is the test code I used.  Note that stringByDecodingAmpEscapes: already tests for nil.
#if 0
ExtoreOmniWeb* extore = [[ExtoreOmniWeb alloc] initWithIxporter:nil
                                                      clientoid:nil
                                                      jobSerial:0] ;

NSArray* expectedResults = [NSArray arrayWithObjects:
							@"http://b01.com/%01%02%20%21%22%23%24%25%26%27%28%29%2A%2B%2C-./0129%3A%3B%3C%3D%3E%3F%40AZ%5B%5C%5D%5E_%60az%7B%7C%7D~%7F%E2%8C%98%E2%87%A7%C2%B5",
							@"http://b02.com/path?parm=%01%02%20%21%22%23%24%25%26%27%28%29%2A%2B%2C%2D%2E%2F%30%31%32%39%3A%3B%3C%3D%3E%3F%40%41%5A%5B%5C%5D%5E%5F%60%61%7A%7B%7C%7D%7E%7F%E2%8C%98%E2%87%A7%C2%B5",
							// Note: Next entry contains an escaped double-quote and an double backslash, which are actually a double-quote and a backslash, respectively
							@"http://b03.%01%02%20!\"#$%&'()*+,-./0129:;<=>?@az[\\]^_`az{|}~%7F%E2%8C%98%E2%87%A7%C2%B5.com/",
							@"http://b04/aPath#%01%02%20%21%22%23%24%25%26%27%28%29%2A%2B%2C%2D%2E%2F%30%31%32%39%3A%3B%3C%3D%3E%3F%40%41%5A%5B%5C%5D%5E%5F%60%61%7A%7B%7C%7D%7E%7F%E2%8C%98%E2%87%A7%C2%B5",
							@"http://b05.com/index.html",
							@"http://b06.com/index.htm",
							@"http://b07.com//slash//one",
							@"file:///bo8/doc.txt",
							@"http://b09/doc.txt",
							@"http://b10.com/Spaces%20In%20Da/Path",
							@"http://b11.com/Plusses%20In%20Da/Path",
							@"javascript:b12.href='http://a.b.c/j?v=3&url='+e(lo.href)+'&t='+e(do.ti)",
							@"http://b13.org/",
							@"http://b14/aPath",
							@"http://b15/aPath",
							@"http://b16/",
							@"http://localhost/b17",
							@"http://localhost:1230/b18",
							@"http://b19.com/",
							@"http://b20.com:1230/",
							@"http://b21.com:443/",
							@"http://⌘⇧µ.b22.com/",
							@"http://b23.com/%E2%8C%98%E2%87%A7%C2%B5/h.mov",
							@"http://b24.com/src?search=%E2%8C%98%E2%87%A7%C2%B5",
							@"http://b25.com./",
							@"http://b26.com/",
							@"http://b27.com/#/",
							@"http://b28.com/?/",
							@"feed://b29.com/",
							@"http://b30.com/",
							@"http://b31.com/",
							@"file:///path/to/aFile",
							@"place:type=⌘⇧µ&sort=14&maxResults=10",
							@"http://",
							nil] ;

NSInteger i = 0 ;
for (NSString* s in expectedResults) {
	NSString* t ;
	
	NSLog(@"i=%ld", (long)i++) ;
	NSLog(@"s: %@", s) ;
	t = [s stringByDecodingAmpEscapes] ;
	NSLog(@"t: %@", t) ;
	
	s = [s encodePercentEscapesPerStandard:SSYPercentEscapeStandardRFC2396] ;
	NSLog(@"s: %@", s) ;
	t = [s stringByDecodingAmpEscapes] ;
	NSLog(@"t: %@", t) ;
	
	s = [s encodePercentEscapesPerStandard:SSYPercentEscapeStandardRFC3986] ;
	NSLog(@"s: %@", s) ;
	t = [s stringByDecodingAmpEscapes] ;
	NSLog(@"t: %@", t) ;
}

exit(0) ;

#endif
