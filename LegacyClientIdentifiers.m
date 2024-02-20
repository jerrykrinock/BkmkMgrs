#import "LegacyClientIdentifiers.h"
#import "Clientoid.h"
#import "BkmxAppDel+Capabilities.h"
#import "NSString+LocalizeSSY.h"
#import "NSData+FileAlias.h"
#import "BkmxBasis.h"

@implementation LegacyClientIdentifiers

+ (NSString*)extoreMediaWithIdentifier:(NSString*)legacyIdentifier
                              reason_p:(NSString**)reason_p {
	NSString* extoreMedia = constBkmxExtoreMediaUnknown ;
	
	if ([legacyIdentifier length] == 5) {
		NSInteger i ;
		for (i=0; i<5; i++) {
			unichar aChar = [legacyIdentifier characterAtIndex:i] ;
			if (![[NSCharacterSet decimalDigitCharacterSet] characterIsMember:aChar]) {
				// Found a character which is not a decimal digit
				break ; 
			}
			
			// All 5 characters were decimal digits
			extoreMedia = constBkmxExtoreMediaLoose ;
		}
	}
	
	if ([extoreMedia isEqualToString:constBkmxExtoreMediaUnknown]) {
		if ([legacyIdentifier hasPrefix:@":"]) {
            // This was constBkmxExtoreMediaOtherUser, which is no longer
            // supported.
            if (reason_p) {
                *reason_p = @"You had a Client on another Macintosh account will be deleted because this version no longer supports that client type." ;
                extoreMedia = nil ;
            }
		}
		else {
			extoreMedia = constBkmxExtoreMediaThisUser ;
		}
	}
	
	return extoreMedia ;
}

+ (void)dissectExformatDotProfileName:(NSString*)string
							 toClientoid:(Clientoid*)clientoid {
	// We use -rangeOfString instead of -componentsSeparatedByString because the 
	// profileName may itself include a dot ".", and indeed did for Google Bookmarks.
	NSInteger index = [string rangeOfString:@"."].location ;
	NSInteger length = [string length] ;
	index = MIN(index, length) ;
	
	if (index > 0) {
		[clientoid setExformat:[string substringToIndex:index]] ;
	}
	
	index++ ; // Step over the dot
	if (index < length) {
		[clientoid setProfileName:[string substringFromIndex:index]] ;	
	}
}

+ (Clientoid*)clientoidFromLegacyClientIdentifier:(NSString*)legacyIdentifier
                                         moreInfo:(NSDictionary*)moreInfo
                             localizedErrorReason:(NSString**)reason_p {
	NSString* dummy ;
	if (!reason_p) {
		reason_p = &dummy ;
	}
	
	Clientoid* clientoid = [[Clientoid alloc] init] ;
    BOOL ok = YES ; // Will be used for various sanity tests

    NSString* extoreMedia = [self extoreMediaWithIdentifier:legacyIdentifier
                                                   reason_p:reason_p] ;
    if (extoreMedia) {
        [clientoid setExtoreMedia:extoreMedia] ;
        
        NSString* exformatDotProfileString = nil ;
        
        if ([extoreMedia isEqualToString:constBkmxExtoreMediaThisUser]) {
            //  Example: "Firefox.default" will have only one component:
            //      {"Firefox.default"}
            // but we just use the raw legacyIdentifier since this is the same
            exformatDotProfileString = legacyIdentifier ;
        }
        else if ([extoreMedia isEqualToString:constBkmxExtoreMediaLoose]) {
            [clientoid setExformat:[moreInfo objectForKey:@"browserName"]] ;
            
            // First, see if there is an explicit alias record and copy that
            [clientoid setExtorageAlias:[moreInfo objectForKey:@"aliasData"]] ;
            // If not, see if there is a file path and make an alias from that
            if (!clientoid.extorageAlias) {
                [clientoid setExtorageAlias:[NSData aliasRecordFromPath:[moreInfo objectForKey:@"filePath"]]] ;
            }
            
            if (!clientoid.extorageAlias) {
                ok = NO ;
                *reason_p = [NSString localize:@"fileNotFound"] ;
            }
        }
        
        // Recover exformat, profileName from exformatDotProfileString
        [self dissectExformatDotProfileName:exformatDotProfileString
                                toClientoid:clientoid] ;
        
        // Trash if exformat is Firefox 2, translate if Firefox 3
        if ([clientoid.exformat hasPrefix:@"Firefox"]) {
            if ([clientoid.exformat hasSuffix:@"3"]) {
                // Firefox3, change to simply "Firefox"
                clientoid.exformat = constExformatFirefox ;
            }
            else {
                // Firefox 2, not supported
                *reason_p = [NSString localizeFormat:@"supportedNot", @"Firefox 2"] ;
                ok = NO ;
                
            }
        }
        
        
        // All clientoids must have a supported exformat
        if (!clientoid.exformat || (clientoid.exformat.length == 0)) {
            *reason_p = @"External File Format (exformat) could not be decoded." ;
            ok = NO ;
        }
        else if ([[[BkmxBasis sharedBasis] supportedExformatsOrderedByPopularity] indexOfObject:clientoid.exformat] == NSNotFound) {
            *reason_p = [NSString localizeFormat:@"supportedNot", @"Firefox 2"] ;
            ok = NO ;
        }
        
        // Discard result if anything was not ok
        if (!ok) {
            [clientoid release] ;
            clientoid = nil ;
        }
    }
    else {
        [clientoid release] ;
        clientoid = nil ;
    }
	
	return [clientoid autorelease] ;
}

@end