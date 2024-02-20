#import "Stark+LegacyArtifacts.h"

NSString* const constBookdogUuidHeader = @"BOOKDOG_UUID=" ;
NSString* const constBookdogUuidBrowprietaryKey = @"BOOKDOG_UUID" ;


#define BOOKDOG_UUID_LENGTH 49  // 13 characters of header + 32 hex characters + 4 dashes

@implementation Stark (LegacyArtifacts)

- (BOOL)hasLegacyUuidInComments {
	if (![self comments]) {
		return NO ;
	}
	NSRange uuidRange = [[self comments] rangeOfString:constBookdogUuidHeader] ;
	return (uuidRange.location != NSNotFound) ;
}

- (BOOL)hasLegacyUuidInBrowprietaries {
	return [self ownerValueForKey:constBookdogUuidBrowprietaryKey] != nil ;
}

- (BOOL)hasLegacySortDirectivePrefixes {
	if ([[self name] hasPrefix:@" "]) {
		return YES ;
	}
	
	return [[self name] hasPrefix:@"~"] ;
}

- (BOOL)hasLegacyArtifacts {
	if ([self hasLegacyUuidInComments]) {
		return YES ;
	}
	
	if ([self hasLegacyUuidInBrowprietaries]) {
		return YES ;
	}
	
	if ([self hasLegacySortDirectivePrefixes]) {
		return YES ;
	}
	
	return NO ;
}

- (BOOL)removeLegacyUUIDFromBrowprietaries {
	if ([self hasLegacyUuidInBrowprietaries]) {
		[self setOwnerValue:nil
							forKey:constBookdogUuidBrowprietaryKey] ;
		return YES ;
	}
	
	return NO ;
}

- (BOOL)removeLegacyUUIDFromComments {
	if (![self comments]) {
		return NO ;
	}

	BOOL didFind = NO ;
	// Use 'while' in case there is more than one BOOKDOG_UUID=,
	while (YES) {
		NSString* comments = [self comments] ;
		NSRange uuidRange = [comments rangeOfString:constBookdogUuidHeader] ;
		
		if ((uuidRange.location == NSNotFound) || !comments) {
			// Added !comments to fix bug in BookMacster 1.5.  In recent versions,
			// setting comments to an empty string sets comments to nil.  So we could
			// set it to any empty string at the end of this loop, which causes it to
			// be nil here, which will cause CFStringTrimWhitespace to crash
			break ;
		}
		
		didFind = YES ;
		
		// Delete UUID
		NSInteger commentsLength = [[self comments] length] ;
		uuidRange.length = MIN(BOOKDOG_UUID_LENGTH, (commentsLength - uuidRange.location)) ;
		NSMutableString* mutableComments = [[self comments] mutableCopy] ;
		[mutableComments deleteCharactersInRange:uuidRange] ;
		
		// Delete endLines at end
		CFStringTrimWhitespace ((CFMutableStringRef) mutableComments) ;
		[self setComments:mutableComments] ;
		[mutableComments release] ;
	}
	
	return didFind ;
}

- (BOOL)updateSortDirectivesRemoveLegacy:(BOOL)doRemove {
	BOOL didFind = NO ;
	if ([[self name] hasPrefix:@" "]) {
		[self setSortDirectiveValue:BkmxSortDirectiveTop] ;
		didFind = YES ;
	}
	else if ([[self name] hasPrefix:@"~"]) {
		[self setSortDirectiveValue:BkmxSortDirectiveBottom] ;
		didFind = YES ;
	}
	
	if (didFind && doRemove) {
		[self setName:[[self name] substringFromIndex:1]] ;
	}
	
	return didFind ;
}


@end