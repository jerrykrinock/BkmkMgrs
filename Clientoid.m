#import "Clientoid.h"
#import "NSError+DecodeCodes.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import "NSString+SSYExtraUtils.h"
#import "NSData+FileAlias.h"
#import "BkmxAppDel+Capabilities.h"
#import "NSObject+MoreDescriptions.h"
#import "ExtoreWebFlat.h"
#import "SSYKeychain.h"
#import "SSYCachyAliasResolver.h"
#import "NSString+MorePaths.h"
#import "NSString+LocalizeSSY.h"
#import "SSYMOCManager.h"
#import "NSString+VarArgs.h"
#import "NSObject+DoNil.h"
#import "NSManagedObjectContext+Cheats.h"
#import "BkmxBasis.h"
#import "NSBundle+SSYMotherApp.h"
#import "NSBundle+MainApp.h"
#import "Trigger.h"

static NSArray* staticAllClientoidsForWebAppsThisUser = nil ;

NSString* const constKeyIdentifierExformat = @"exformat" ;
NSString* const constKeyIdentifierProfileName = @"profileName" ;
NSString* const constKeyIdentifierExtoreMedia = @"extoreMedia" ;
NSString* const constKeyIdentifierExtorageAlias = @"extorageAlias" ;
NSString* const constKeyIdentifierPath = @"path" ;

NSString* const constClientoidDelimiter = @"|" ;
NSString* const constClientoidDelimiterEscaped = @"<ESC_PIPE>" ;
#define NUMBER_OF_DELIMITERS_IN_CLIDENTIFIER 5

@interface NSString (ClientoidClidentifiers)

- (BOOL)isWellFormedClidentifier ;
- (NSString*)escapeClidentifierDelimiters ;
- (NSString*)unescapeClidentifierDelimiters ;
- (void)extractFromClidentifierExformat_p:(NSString**)exformat_p
							profileName_p:(NSString**)profileName_p ;
- (NSString*)exformat;

@end

@implementation NSString (ClientoidClidentifiers)

- (BOOL)isWellFormedClidentifier {
	return ([self countOccurrencesOfSubstring:constClientoidDelimiter] == NUMBER_OF_DELIMITERS_IN_CLIDENTIFIER) ;
}

- (NSString*)escapeClidentifierDelimiters {
	return [self stringByReplacingAllOccurrencesOfString:constClientoidDelimiter
											  withString:constClientoidDelimiterEscaped] ;
}

- (NSString*)unescapeClidentifierDelimiters {
	return [self stringByReplacingAllOccurrencesOfString:constClientoidDelimiterEscaped
											  withString:constClientoidDelimiter] ;
}

- (NSString*)exformat {
    NSString* exformat = nil;
    if ([self isWellFormedClidentifier]) {
        NSScanner* scanner = [[NSScanner alloc] initWithString:self] ;
        [scanner scanUpToString:constClientoidDelimiter
                     intoString:&exformat];
        [scanner release];
    }
    
    return exformat;
}

- (void)extractFromClidentifierExformat_p:(NSString**)exformat_p
							profileName_p:(NSString**)profileName_p {	
	NSString* exformat = nil ;
	NSString* profileName = nil ;
	
	if ([self isWellFormedClidentifier]) {
		NSScanner* scanner = [[NSScanner alloc] initWithString:self] ;
		BOOL ok = [scanner scanUpToString:constClientoidDelimiter
							   intoString:&exformat] ;
		if (ok) {
			[scanner scanString:constClientoidDelimiter
					 intoString:NULL] ;
			[scanner scanUpToString:constClientoidDelimiter
						 intoString:&profileName] ;
		}
		[scanner release] ;
	}
	
	if (exformat_p) {
		*exformat_p = exformat ;
	}
	if (profileName_p) {
		*profileName_p = profileName ;
	}
}

@end


/*!
 @brief    Codec for a modified base64 encoding which uses 
 "-" character is used in its alphabet instead of the "/".
 
 @details  This is for representing data in a filename.&nbsp;   Although the
 Finder allows you to use a slash in filenames, it converts them to a 
 colon since unix does not allow slashes.&nbsp;  But Finder does not
 allow colons.&nbsp; This could get very confusing, so I'd rather
 not use slashes in filenames.
 */
@interface NSData (Base64Minus)

/*!
 @brief    Encodes the receiver into a base64Minus-encoded string.
*/
- (NSString*)stringBase64MinusEncoded ;

/*!
 @brief    Decodes a given base64Minus-encoded string into its data
 .&nbsp; This method has never been tested.
*/
+ (NSData*)base64MinusDecodedString:(NSString*)string ;


@end

@implementation NSData (Base64Minus)

- (NSString*)stringBase64MinusEncoded {
	NSMutableString* mutant = [[self stringBase64Encoded] mutableCopy] ;
	[mutant replaceOccurrencesOfString:@"/"
							withString:@"-"] ;
	NSString* answer = [NSString stringWithString:mutant] ;
	[mutant release] ;
	return answer ;
}

+ (NSData*)base64MinusDecodedString:(NSString*)string {
	NSMutableString* mutant = [string mutableCopy] ;
	[mutant replaceOccurrencesOfString:@"-"
							withString:@"/"] ;
	NSData* answer = [mutant dataBase64Decoded] ;
	[mutant release] ;
	return answer ;
}

@end


@implementation Clientoid

#pragma mark * Accessors

// Defining attributes
@synthesize exformat = m_exformat;
@synthesize profileName = m_profileName ;
@synthesize extoreMedia = m_extoreMedia ;
@synthesize extorageAlias = m_extorageAlias ;
@synthesize path = m_path ;

#pragma mark * Basic Infrastructure

- (void)dealloc {
	[m_exformat release] ;
	[m_profileName release] ;
	[m_extoreMedia release] ;
	[m_extorageAlias release] ;
    [m_path release] ;
	
	[super dealloc] ;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (NSString*)ownerAppFullPathError_p:(NSError**)error_p {
	Class extoreClass = [self extoreClass] ;
	
	NSString* ownerAppFullPath ;
	if ([extoreClass constants_p]->ownerAppIsLocalApp) {
		ownerAppFullPath = [extoreClass ownerAppLocalPath] ;
	}
	else {
		ownerAppFullPath = [self filePathError_p:error_p] ;
	}
	
	return ownerAppFullPath ;
}

- (NSString*)pathFromResolvedAlias {
	return [[SSYCachyAliasResolver sharedResolver] pathFromAlias:[self extorageAlias]
														useCache:YES
														 timeout:3.0
														lifetime:20.0
														 error_p:NULL] ;
}

- (NSString*)pathPrefixRelativeTo:(PathRelativeTo)relativeTo
						  error_p:(NSError**)error_p {
	NSString* answer ;
	NSString* profile ;
	Class extoreClass = [self extoreClass] ;
	switch (relativeTo) {
		case PathRelativeToNone:
			answer = @"" ;
			break ;
		case PathRelativeToHome:
			answer = [self homePath] ;
			break ;
		case PathRelativeToLibrary:
			answer = [NSString libraryPathForHomePath:[self homePath]] ;
			break ;
		case PathRelativeToApplicationSupport:
			answer = [NSString applicationSupportPathForHomePath:[self homePath]] ;
			break ;
		case PathRelativeToPreferences:
			answer = [NSString preferencesPathForHomePath:[self homePath]] ;
			break ;
		case PathRelativeToProfile:
			profile = [self profileName] ;
			if (!profile) {
				profile = [extoreClass constants_p]->defaultProfileName ;
			}
			answer = [extoreClass pathForProfileName:profile
                                            homePath:[self homePath]
                                             error_p:error_p] ;
			break ;
		case PathRelativeToRoot:
        default:
            answer = @"/" ;
			break ;
	}
	
	return answer ;
}

- (NSString*)defaultFilename {
	NSString* defaultFilename = [[self extoreClass] defaultFilename] ;
	
	if (!defaultFilename) {
		defaultFilename = [NSString localize:@"untitled"] ;
	}
	
	return defaultFilename ;
}


- (NSString*)filePathError_p:(NSError**)error_p {
	NSString* filename = [self defaultFilename] ;
	NSError* error = nil ;
	NSString* answer = nil ;
	
	Class extoreClass = [self extoreClass] ;
	
	if (extoreClass && ([extoreClass constants_p]->ownerAppIsLocalApp)) {
		answer = [self pathFromResolvedAlias] ;
		if (!answer) {
			if (
				[[self extoreMedia] isEqualToString:constBkmxExtoreMediaThisUser]
				) {
				NSString* filePathParent = [self filePathParentError_p:&error] ;
				if (error) {
					goto end ;
				}
				answer = [filePathParent stringByAppendingPathComponent:filename] ;
                // Kosuke Komeda Possible Case 1, if filePathParent is nil, answer will be nil
				// Oddly, -stringByAppendingPathComponent drops the slash, if any,
				// from filename.  The slash is important for OmniWeb, where filename
				// ends in a slash.
				// So we need to fix that now.
				NSString* const slash = @"/" ;
				if ([filename hasSuffix:slash] && ![answer hasSuffix:slash]) {
					answer = [answer stringByAppendingString:slash] ;
				}
			}
			else {
				// This can happen during creation of a Loose Client with a New file,
				// just after the Choose File sheet ends.  It happens several times
				// but is only momentary and the nil file path is never displayed.
                // Kosuke Komeda Possible Case 2.  This will happen if he's treating Firefox as a loose file.
			}
		}
	}
	else if ([self path]) {
        // "Choose File" with new file
        answer = [self path] ;
    }
    else {
		// web app
		answer = filename ;
	}

end:
	if (error && error_p) {
		*error_p = error ;
	}

	return answer ;
}

- (NSString*)filePathParentError_p:(NSError**)error_p {	
	NSString* answer = nil ;
	
	Class extoreClass = [self extoreClass] ;
	
	NSString* looseFilePath = [self pathFromResolvedAlias] ;
	
	if (looseFilePath) {
		answer = [looseFilePath stringByDeletingLastPathComponent] ;
	}
	
	if (!answer) {
		NSString* fileParentRelativePath = [extoreClass fileParentRelativePath] ;
		
		if (fileParentRelativePath) {
			// First, get the part that it is "relative to"
			PathRelativeTo relativeTo = [extoreClass fileParentPathRelativeTo] ;
			answer = [self pathPrefixRelativeTo:relativeTo
										error_p:error_p] ;
			
			// Then, append the parent's relative path.
			answer = [answer stringByAppendingPathComponent:fileParentRelativePath] ;
		}
	}
	
	return answer ;
}

- (NSString*)sawChangeTriggerPath {
	Class extoreClass = [self extoreClass] ;
	
	NSString* path = nil;
    if (extoreClass) { // defensive programming
        OwnerAppObservability observability = [extoreClass ownerAppObservability];

        /* observability should only be one of the these two if(), not both */
        if ((observability & OwnerAppObservabilitySpecialFile) != 0) {
            // Firefox, or any Chromy
            path = [Trigger specialWatchFilePathForExformat:[self exformat]
                                                profileName:[self profileName]] ;
        }
        else if ((observability & OwnerAppObservabilityBookmarksFile) != 0) {
            // Safari
            path = [self filePathError_p:NULL];
        }
    }

	return path ;
}

- (Class)extoreClass {
	NSString* exformat = [self exformat] ;
	Class class = [Extore extoreClassForExformat:exformat] ;
	return class ;
}

- (NSString*)profileNameAsDisplayedSuffix {
    Class extoreClass = [self extoreClass] ;
    NSString* profileName = [self profileName] ;
	NSString* displayedSuffix = [extoreClass displayedSuffixForProfileName:profileName
                                                                  homePath:[self homePath]] ;    
	return displayedSuffix ;
}

- (NSString*)displayNameWithProfile:(BOOL)withProfile {
	NSString* name ;
	
	if ([[self extoreMedia] isEqualToString:constBkmxExtoreMediaLoose]) {
		NSError* error = nil ;
		name = [[self filePathError_p:&error] lastPathComponent] ;
		if (!name) {
			if (error) {
				NSString* msg = @"Internal Error 325-1127" ;
				NSLog(@"%@ self: %@ error: %@", msg, self, [error longDescription]) ;
				name = msg ;
			}
			else {
				/* This can happen during creation of a Loose Client with a New
                 file, just after the Choose File sheet ends.  It happens
                 several times.  These are only momentary and the name assigned
                 here is never displayed.  However, it *is* needed after a
                 Choose File (Advanced) export to a New file. */
                name = [[self path] lastPathComponent] ;
			}
		}
	}
	else {
		Class extoreClass = [self extoreClass] ;
		
		NSString* clientoidPrefix = @"" ;
		
		NSString* ownerAppDisplayName = [extoreClass ownerAppDisplayName] ;
		if (!ownerAppDisplayName) {
			/* This happens if self.exformat and consequently self.extoreClass
             is nil, in particular, immediately after clicking
             "Choose File (Advanced)".  It can also occur if there was a
             crash leaving an incompleted Client in Settings-X.sqlite.  */
			ownerAppDisplayName = [@"Click to choose" ellipsize] ;
            withProfile = NO ;
		}
		
        NSString* profileSuffix =
        withProfile
        ? [self profileNameAsDisplayedSuffix]
        : @"" ;
        
        name = [NSString stringWithFormat:@"%@%@%@",
				clientoidPrefix,
				ownerAppDisplayName,
				profileSuffix] ;
	}
	
	return name ;
}

- (NSString*)displayName {
    return [self displayNameWithProfile:YES] ;
}

- (NSString*)displayNameWithoutProfile {
    return [self displayNameWithProfile:NO] ;
}

- (NSString*)stringificationExceptForExtorageAliasAndPath {
	NSMutableString* string = [[NSMutableString alloc] init] ;
	NSString* subString ;
	
	subString = [self exformat] ;
	if (subString) {
		// No escaping needed, because my exformats don't have any
		// clidentifier delimiters (pipe characters) in them.
		[string appendString:subString] ;
	}

	[string appendString:constClientoidDelimiter] ;

	subString = [self profileName] ;
    /* The following respondsToSelector: test was added in BkmkMgrs 2.2.16
     after user Guido Malce submitted Exception report which he says happens
     repeatedly for him, at random times.  His clients were ordinary: Chrome
     Safari and Opera.  He said deleting clients did not help. */
	if ([subString respondsToSelector:@selector(escapeClidentifierDelimiters)]) {
		[string appendString:[subString escapeClidentifierDelimiters]] ;
	}
#if DEBUG
    else if (subString) {
        NSLog(@"Warning 523-4277 profileName is %@", subString) ;
    }
#endif
    
	[string appendString:constClientoidDelimiter] ;
	
	subString = [self extoreMedia] ;
	if (subString) {
		// No escaping needed, because my extoreMedia don't have any
		// clidentifier delimiters (pipe characters) in them.
		[string appendString:subString] ;
	}
	
	[string appendString:constClientoidDelimiter] ;
	
	[string appendString:constClientoidDelimiter] ;
	
	[string appendString:constClientoidDelimiter] ;
	
	NSString* answer = [string copy] ;
	[string release] ;
	
	return [answer autorelease] ;
}

- (NSString*)description {
	NSString* description = [self stringificationExceptForExtorageAliasAndPath] ;

	description = [description stringByAppendingString:@"+ALIAS="] ;
	
	NSData* alias = [self extorageAlias] ;
	if (alias) {
		NSError* error = nil ;
		NSString* path =  [[SSYCachyAliasResolver sharedResolver] pathFromAlias:alias
																	   useCache:YES
																		timeout:4.9
																	   lifetime:19.9
																		error_p:&error] ;
		
		if (!path) {
			path = @"Could not get path" ;
			NSLog(@"Could not get path for %@.  Error:\n%@",
				  description,
				  [error longDescription]) ;
		}
		
		description = [description stringByAppendingString:path] ;
	}
	
	return description ;
}

- (NSString*)clidentifier {
	NSString* clidentifier = [self stringificationExceptForExtorageAliasAndPath] ;
	NSString* subString = [[self extorageAlias] stringBase64MinusEncoded] ;
	if (subString) {
		clidentifier = [clidentifier stringByAppendingString:subString] ;
	}
	
	return clidentifier ;
}

#pragma mark * Value-Added Getters

- (NSString*)homePath {
	return NSHomeDirectory() ;
}

- (NSMutableDictionary*)attributesDictionary {
	NSArray* attributes = [NSArray arrayWithObjects:
						   constKeyIdentifierExformat,
						   constKeyIdentifierProfileName,
						   constKeyIdentifierExtoreMedia,
						   constKeyIdentifierExtorageAlias,
                           constKeyIdentifierPath,
						   nil] ;
	NSMutableDictionary* attributesDic = [[NSMutableDictionary alloc] init] ;
	for (id attributeName in attributes) {
		id value = [self valueForKey:attributeName] ;
		if (!value) {
			value = [NSNull null] ;
		}
			
		[attributesDic setValue:value
						 forKey:attributeName] ;			
	}
	
	return [attributesDic autorelease] ;
}


#pragma mark * Comparing Clientoids

- (BOOL)isEqual:(id)otherClientoid {
    if (otherClientoid == nil) {
        return NO ;
    }
    
	BOOL equal ;
	
	equal = [NSObject isEqualHandlesNilObject1:[self exformat]
									   object2:[otherClientoid exformat]] ;
	if (!equal) {
		return NO ;
	}	
	
	equal = [NSObject isEqualHandlesNilObject1:[self profileName]
									   object2:[otherClientoid profileName]] ;
	if (!equal) {
		return NO ;
	}
	
	equal = [NSObject isEqualHandlesNilObject1:[self extoreMedia]
									   object2:[otherClientoid extoreMedia]] ;
	if (!equal) {
		return NO ;
	}
	
	equal = [NSObject isEqualHandlesNilObject1:[self extorageAlias]
									   object2:[otherClientoid extorageAlias]] ;
	if (!equal) {
		return NO ;
	}
	
    equal = [NSObject isEqualHandlesNilObject1:[self path]
                                       object2:[otherClientoid path]] ;
    if (!equal) {
        return NO ;
    }
    
	return YES ;
}

// Documentation says to override -hash if you override -isEqual:
- (NSUInteger)hash {
	// Until BookMacster 1.3.21, I had been doing this:
	// NSDictionary* attributes = [self attributesDictionary] ;
	// return [attributes hash] ;
	// Then I found that the hash of a dictionary is equal to its number of keys

	NSMutableString* valueString = [[NSMutableString alloc] init] ;
	NSString* appendix = [self exformat] ;
    if (appendix) {
		[valueString appendString:appendix] ;
	}
	appendix = [self profileName] ;
	if (appendix) {
		[valueString appendString:appendix] ;
	}
	appendix = [self extoreMedia] ;
	if (appendix) {
		[valueString appendString:appendix] ;
	}
	
	NSUInteger hash = [valueString hash] ;
	[valueString release] ;

    /* Use bitwise XOR instead of addition because overflowed integer addition
     is undefined in C. */
	hash ^= [[self extorageAlias] hash] ;
    hash ^= [[self path] hash] ;
	
	return hash ;
}

#pragma mark * NSCoding Protocol Conformance

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:m_exformat forKey:constKeyIdentifierExformat] ;
	[encoder encodeObject:m_profileName forKey:constKeyIdentifierProfileName] ;
	[encoder encodeObject:m_extoreMedia forKey:constKeyIdentifierExtoreMedia] ;
	[encoder encodeObject:m_extorageAlias forKey:constKeyIdentifierExtorageAlias] ;
    [encoder encodeObject:m_path forKey:constKeyIdentifierPath] ;
}

- (id)initWithCoder:(NSCoder *)decoder {
	self = [super init] ;
    
    if (self) {
        m_exformat = [[decoder decodeObjectOfClass:[NSString class]
                                            forKey:constKeyIdentifierExformat] retain] ;
        m_profileName = [[decoder decodeObjectOfClass:[NSString class]
                                               forKey:constKeyIdentifierProfileName] retain] ;
        m_extoreMedia = [[decoder decodeObjectOfClass:[NSString class]
                                               forKey:constKeyIdentifierExtoreMedia] retain] ;
        m_extorageAlias = [[decoder decodeObjectOfClass:[NSString class]
                                                 forKey:constKeyIdentifierExtorageAlias] retain] ;
        m_path = [[decoder decodeObjectOfClass:[NSString class]
                                        forKey:constKeyIdentifierPath] retain] ;
	}
	
	return self ;
}


#pragma mark * NSCopying Protocol Conformance

- (id)copyWithZone:(NSZone *)zone {
    Clientoid* copy = [[Clientoid allocWithZone: zone] init] ;
	[copy setExformat:[self exformat]] ;
	[copy setProfileName:[self profileName]] ;
	[copy setExtoreMedia:[self extoreMedia]] ;
	[copy setExtorageAlias:[self extorageAlias]] ;
    [copy setPath:[self path]] ;
	
    return copy ;
}


#pragma mark * Convenience Creators

+ (Clientoid*)clientoidWithExformat:(NSString*)exformat
						profileName:(NSString*)profileName
						extoreMedia:(NSString*)extoreMedia
					  extorageAlias:(NSData*)extorageAlias
                               path:(NSString*)path {
	Clientoid* clientoid = [[Clientoid alloc] init] ;
	[clientoid setExformat:exformat] ;
	[clientoid setProfileName:profileName] ;
	[clientoid setExtoreMedia:extoreMedia] ;
	[clientoid setExtorageAlias:extorageAlias] ;  // Anchor 195837.  enables undo registration for document if extorageAlias is non-nil.  Very Weird.
    [clientoid setPath:path] ;
	return [clientoid autorelease] ;
}

+ (Clientoid*)clientoidWithClidentifier:(NSString*)clidentifier {
	NSScanner* scanner = [[NSScanner alloc] initWithString:clidentifier] ;
	NSString* piece ;
	BOOL ok ;
	Clientoid* clientoid = [[[Clientoid alloc] init] autorelease] ;
	
	piece = nil ;
	[scanner scanUpToString:constClientoidDelimiter
				 intoString:&piece] ;
	piece = [piece unescapeClidentifierDelimiters] ;
	[clientoid setExformat:piece] ;
	ok = [scanner scanString:constClientoidDelimiter
					   intoString:NULL] ;
	// First delimiter is required
	if (!ok) {
		goto end ;
	}
	
	piece = nil ;
	[scanner scanUpToString:constClientoidDelimiter
				 intoString:&piece] ;
	piece = [piece unescapeClidentifierDelimiters] ;
	[clientoid setProfileName:piece] ;
	ok = [scanner scanString:constClientoidDelimiter
					   intoString:NULL] ;
	// Second delimiter is required
	if (!ok) {
		goto end ;
	}
	
	piece = nil ;
	[scanner scanUpToString:constClientoidDelimiter
				 intoString:&piece] ;
	piece = [piece unescapeClidentifierDelimiters] ;
	[clientoid setExtoreMedia:piece] ;
	ok = [scanner scanString:constClientoidDelimiter
					   intoString:NULL] ;
	// Third delimiter is required
	if (!ok) {
		goto end ;
	}
	
	piece = nil ;
	[scanner scanUpToString:constClientoidDelimiter
				 intoString:&piece] ;
	ok = [scanner scanString:constClientoidDelimiter
					   intoString:NULL] ;
	// Fourth delimiter is required
	if (!ok) {
		goto end ;
	}
	
	piece = nil ;
	[scanner scanUpToString:constClientoidDelimiter
				 intoString:&piece] ;
	ok = [scanner scanString:constClientoidDelimiter
					   intoString:NULL] ;
	// Fifth delimiter is required
	if (!ok) {
		goto end ;
	}
	
	piece = nil ;
	[scanner scanUpToString:constClientoidDelimiter
				 intoString:&piece] ;
	piece = [piece unescapeClidentifierDelimiters] ;
	if ([piece length] > 0) {
		[clientoid setExtorageAlias:[NSData base64MinusDecodedString:piece]] ;
	}

	// We must be at the end now HUHHHHHH
	if (![scanner isAtEnd]) {
		ok = NO ;
		goto end ;
	}
	
end:
	[scanner release] ;
	
	if (!ok) {
		clientoid = nil ;
	}
		
	return clientoid ;	
}

+ (NSString*)displayNameForClidentifier:(NSString*)clidentifier {
	return [[self clientoidWithClidentifier:clidentifier] displayName] ;
}

+ (NSString*)exformatInClidentifier:(NSString*)clidentifier {
    return [clidentifier exformat];
}

+ (NSString*)clidentifier:(NSString*)clidentifier
          withNewExformat:(NSString*)exformat {
    NSString* oldExformat = [clidentifier exformat];
    clidentifier = [exformat stringByAppendingString:[clidentifier substringFromIndex:oldExformat.length]];
    return clidentifier;
}

+ (Clientoid*)clientoidThisUserWithExformat:(NSString*)exformat
								profileName:(NSString*)profileName {
	return [self clientoidWithExformat:exformat
						   profileName:profileName
						   extoreMedia:constBkmxExtoreMediaThisUser
						 extorageAlias:nil
                                  path:nil] ;
}

+ (Clientoid*)clientoidLooseWithExformat:(NSString*)exformat
									path:(NSString*)path {
	NSData* aliasRecord = [NSData aliasRecordFromPath:path] ;
    return [self clientoidWithExformat:exformat
						   profileName:nil
						   extoreMedia:constBkmxExtoreMediaLoose
						 extorageAlias:aliasRecord
                                  path:path] ;
}

+ (Clientoid*)clientoidPlaceholder {
	return [self clientoidWithExformat:nil
						   profileName:nil
						   extoreMedia:nil
						 extorageAlias:nil
                                  path:nil] ;
}

- (BOOL)isPlaceholder {
    return (
            ([self exformat] == nil)
            &&
            ([self extoreMedia] == nil)
            ) ;
}

//  set from this method
+ (NSArray*)allClientoidsForLocalAppsThisUserByPopularity:(BOOL)byPopularity
                                     includeUninitialized:(BOOL)includeUninitialized
                                      includeNonClientable:(BOOL)includeNonClientable {
	NSMutableArray* clientoids = [[NSMutableArray alloc] init] ;
	
	// Some utility variables
	Clientoid* clientoid ;
	NSString* profileName ;
	NSInteger i ;
	
	NSArray* candidates = byPopularity ?
	[[BkmxBasis sharedBasis] supportedLocalAppExformatsOrderedByPopularityIncludeNonClientable:includeNonClientable] :
	[[BkmxBasis sharedBasis] supportedLocalAppExformatsIncludeNonClientable:includeNonClientable] ;
	
	// Find candidates among local browser applications
	for (NSString* exformat in candidates) {
		// We don't want to create an extore, but we can use its constants
		Class extoreClass = [Extore extoreClassForExformat:exformat] ;
		if ([extoreClass fileParentPathRelativeTo] == PathRelativeToProfile) {
			// Possible multi-profile exformat --> add multiple clients
			NSArray* profileNames = [extoreClass profileNames] ;
            if ([profileNames count] == 0) {
                profileNames = [NSArray arrayWithObject:[extoreClass constants_p]->defaultProfileName] ;
            }
            for (profileName in profileNames) {
                clientoid = [self clientoidThisUserWithExformat:exformat
                                                    profileName:profileName] ;
                [clientoids addObject:clientoid] ;
            }
		}
		else {
			// Single-profile exformat --> add single client
			clientoid = [self clientoidThisUserWithExformat:exformat
												profileName:nil] ;
			[clientoids addObject:clientoid] ;
		}
	}
	
	// Now we eliminate the clientoids for which browsers cannot be found
	// Since we can't eliminate objects while using an Obj-C enumeration, we use a C loop
	for (i=[clientoids count]-1; i >= 0 ; i--) {
		clientoid = [clientoids objectAtIndex:i] ;
		NSString* ownerAppFullPath = [clientoid ownerAppFullPathError_p:NULL] ;
		
		if (!ownerAppFullPath) {
			[clientoids removeObjectAtIndex:i] ;
		}
	}

    if (!includeUninitialized) {
        // This section was eliminated in BookMacster 1.13.2, then re-added with the
        // above qualifier in BookMacster 1.16.4.
        // Eliminate the clients for which bookmarks files cannot be found
        // Since we can't eliminate objects while using an Obj-C enumeration, we use a C loop
        NSFileManager* fileManager = [NSFileManager defaultManager] ;
        for (i=[clientoids count]-1; i >= 0 ; i--) {
            clientoid = [clientoids objectAtIndex:i] ;
            NSString* filePath = [clientoid filePathError_p:NULL] ;
            if (filePath) {
                if (![fileManager fileExistsAtPath:filePath])  {
                    [clientoids removeObjectAtIndex:i] ;
                }
            }
            else {
                [clientoids removeObjectAtIndex:i] ;
            }		
        }
    }
    
	NSArray* answer = [clientoids copy] ;
	[clientoids release] ;
	
	return [answer autorelease] ;
}

+ (NSArray*)allClientoidsForWebAppThisUserExformat:(NSString*)exformat {	
	Class extoreClass = [Extore extoreClassForExformat:exformat] ;
	NSString* webHostName = [extoreClass webHostName] ;
	
	NSString* name ;
	NSMutableSet* accountNamesSet = [[NSMutableSet alloc] init] ;
	
	// Step 1.  Look in Keychain for "internet" items (using Basic HTTP Authentication)
	NSArray* trySubhosts = [ExtoreWebFlat trySubhosts] ;
    for (name in [SSYKeychain accountNamesForServost:webHostName
                                         trySubhosts:trySubhosts
                                               clase:(NSString*)kSecClassInternetPassword
                                             error_p:NULL]) {
        [accountNamesSet addObject:name] ;
    }

	// Step 2.  Look in Keychain for "generic" Keychain entries created by SSYOAuth
	Clientoid* oAuthClientoid = [self clientoidThisUserWithExformat:exformat
														profileName:nil] ;
	NSString* serviceName = [SSYOAuthTalker keychainServiceNameForAccounter:oAuthClientoid] ;
    
    NSArray* accountNamesFromKeychain = [SSYKeychain accountNamesForServost:serviceName
                                                                trySubhosts:nil
                                                                      clase:(NSString*)kSecClassGenericPassword
                                                                    error_p:NULL] ;
    [accountNamesSet addObjectsFromArray:accountNamesFromKeychain] ;

	// Step 3.  Look in Application Support for other local caches which,
	// for some reason, might not have a Keychain entry.
	// Note: One reason why we do this is for the benefit of 
	// -[BkmxAppDel migrateAppDataToCurrentVersion], so that it
	// does a good job of cleaning out all the old files.
	NSError* error = nil ;
	NSArray* filenames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[NSBundle mainAppBundle] applicationSupportPathForMotherApp]
																			 error:&error] ;
	if ([error isNotFileNotFoundError]) {
		NSLog(@"Internal Error 502-8283 %@", error) ;
	}
	
	for (NSString* filename in filenames) {
		if ([[filename pathExtension] isEqualToString:SSYManagedObjectContextPathExtensionForSqliteStores]) {
			NSString* possibleClidentifier = [filename stringByDeletingPathExtension] ;
			NSString* anExformat = nil ;
			NSString* accountName = nil ;
			[possibleClidentifier extractFromClidentifierExformat_p:&anExformat
													  profileName_p:&accountName] ;
			if ([anExformat isEqualToString:exformat]) {
				if (accountName) {
					[accountNamesSet addObject:accountName] ;
				}
			}
		}
	}	
	// Step 4.  We need the order of account names to be predictable because we use the tags
	// set in -[ApplicationController ] in -[ApplicationController open:].  They can
	// change as keychain items are written, which will cause the
	// wrong client to open.  Also, it looks better to the user if these are always
	// in the same order.  So, we copy to an array and alphabetize them.
	NSMutableArray* accountNames = [[NSMutableArray alloc] initWithArray:[accountNamesSet allObjects]] ;
	[accountNamesSet release] ;
	NSSortDescriptor* descriptor = [[NSSortDescriptor alloc] initWithKey:@"description"
															   ascending:YES
																selector:@selector(localizedCompare:)] ;
	[accountNames sortUsingDescriptors:[NSArray arrayWithObject:descriptor]] ;
	[descriptor release] ;
	
	// Step 5.  Create clientoids and add to clientoids for each name in the
	// combined array accountNames
	NSMutableArray* clientoids = [[NSMutableArray alloc] init] ;
	if ([accountNames count] > 0) {
		for (name in accountNames) {
            Clientoid* clientoid = [self clientoidThisUserWithExformat:exformat
														   profileName:name] ;
			[clientoids addObject:clientoid] ;
		}
	}
	[accountNames release] ;
	
	return [clientoids autorelease] ;
}

+ (void)trashWebAppsCache:(NSTimer*)notUsed {
	[staticAllClientoidsForWebAppsThisUser release] ;
	staticAllClientoidsForWebAppsThisUser = nil ;
}

+ (NSArray*)allClientoidsForWebAppsThisUser {
	// Since this takes a couple seconds to execute and may be executed repeatedly
	// to populate the menu itemss in the Clients window, we cache it on each cycle
	// through the run loop
	if (!staticAllClientoidsForWebAppsThisUser) {
		NSMutableArray* clientoids = [[NSMutableArray alloc] init] ;
		
		for (NSString* exformat in [[BkmxBasis sharedBasis] supportedWebAppExformats]) {
			[clientoids addObjectsFromArray:[self allClientoidsForWebAppThisUserExformat:exformat]] ;
		}	
		
		staticAllClientoidsForWebAppsThisUser = [clientoids copy] ;
		// ... This allocation is released in -trashWebAppsCache:
		[clientoids release] ;
		
		// Trash the cache at the end of this run loop cycle
		[NSTimer scheduledTimerWithTimeInterval:0.0
										 target:self
									   selector:@selector(trashWebAppsCache:)
									   userInfo:nil
										repeats:NO] ;
	}
	
	return staticAllClientoidsForWebAppsThisUser ;
}

+ (NSArray*)availableClientoidsIncludeUninitialized:(BOOL)includeUninitialized
                               includeNonClientable:(BOOL)includeNonClientable {
	NSArray* localApps = [self allClientoidsForLocalAppsThisUserByPopularity:NO
                                                        includeUninitialized:includeUninitialized
                                                        includeNonClientable:includeNonClientable] ;
	NSArray* answer = [localApps arrayByAddingObjectsFromArray:[self allClientoidsForWebAppsThisUser]] ;	
	return answer ;
}

+ (NSArray*)allClientoidsWithSqliteStores {
	NSMutableArray* clientoids = [[NSMutableArray alloc] init] ;
	for (Clientoid* clientoid in [self availableClientoidsIncludeUninitialized:YES
                                                          includeNonClientable:YES]) {
		NSString* clidentifier = [clientoid clidentifier] ;
		if ([SSYMOCManager sqliteStoreExistsForIdentifier:clidentifier]) {
			[clientoids addObject:clientoid] ;
		}	
	}
	
	NSArray* output = [clientoids copy] ;
	[clientoids release] ;
	
	return [output autorelease] ;
}


#pragma mark * SSYOAuthAccounter Support

- (NSString*)serviceName {
	return NSStringFromClass([self extoreClass]) ;
}

- (NSString*)accountName {
	return [self profileName] ;
}


@end
