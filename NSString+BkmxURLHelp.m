#import "NSString+BkmxURLHelp.h"
#import "NSData+SSYCryptoDigest.h"
#import "NSString+URIQuery.h"
#import "NSString+SSYExtraUtils.h"
#import "NSData+HexString.h"
#import "NSBundle+MainApp.h"

NSCharacterSet* static_ampEscapeSet = nil;
NSDictionary* static_ampEscapeNumbersFromSequences;
NSDictionary* static_ampEscapeSequencesFromNumbers;
NSDictionary* static_ampEscapeDisallowedCharacterSets;

@implementation NSString (NSStringBkmxBkmxURLHelp)

+ (void)createAmpEscapeDics {
    /*
     The file to be loaded here has the 128 entries from the "character"
     dictionary found in

     /Users/jk/Documents/Programming/Projects/OmniGroup/Frameworks/OWF/Processors.subproj/SGML.subproj/entities.plist

     This seems to be the set which OmniWeb encodes in mnemonic style, for example &nbsp;
     The entries from the "extendedCharacter" dictionary are encoded in number style, for example #946;
     The entries from "nonstandardCharacers" and "nonstandardStrings" are not encoded. */
    NSString* pathToSequenceDic = [[NSBundle mainAppBundle] pathForResource:@"AmpEscapes" ofType:@"plist"];
    static_ampEscapeNumbersFromSequences = [[NSDictionary alloc] initWithContentsOfFile:pathToSequenceDic];
    NSMutableDictionary* bucket = [[NSMutableDictionary alloc] init] ;
    for (NSString* key in static_ampEscapeNumbersFromSequences) {
        id value = [static_ampEscapeNumbersFromSequences objectForKey:key] ;
        NSString* newKey = [[NSString alloc] initWithFormat:@"%ld", (long)[value intValue]] ;
        [bucket setObject:key
                   forKey:newKey] ;
        [newKey release] ;
    }

    static_ampEscapeSequencesFromNumbers = [bucket copy];
    [bucket release];
}

+ (NSDictionary*)ampEscapeNumbersFromSequences {
    if (!static_ampEscapeNumbersFromSequences) {
        [self createAmpEscapeDics];
    }

    return static_ampEscapeNumbersFromSequences;
}

+ (NSDictionary*)ampEscapeSequencesFromNumbers {
    if (!static_ampEscapeSequencesFromNumbers) {
        [self createAmpEscapeDics];
    }

    return static_ampEscapeSequencesFromNumbers;
}

+ (NSCharacterSet*)ampEscapeDisallowedCharacterSetLevel:(NSInteger)level {
    NSString* levelKey = [NSString stringWithFormat:@"%ld", level];
    if ([static_ampEscapeDisallowedCharacterSets objectForKey:levelKey] == nil) {
        NSMutableCharacterSet* allowedCharSet = [[NSMutableCharacterSet alloc] init] ;
        NSRange range;
        range.location = 0x00;
        range.length = (level > 1) ? 0x7f : 0xffff;
        [allowedCharSet addCharactersInRange:range];
        // Remove the four ASCII characters not allowed in html
        // (Firefox encodes the single-quote ' too but OmniWeb does not.)
        [allowedCharSet removeCharactersInString:@"<>&\""];

        NSCharacterSet* answer = [allowedCharSet invertedSet];
        [allowedCharSet release];
        if (!static_ampEscapeDisallowedCharacterSets) {
            static_ampEscapeDisallowedCharacterSets = [[NSDictionary alloc] initWithObjects:@[answer]
                                                                                    forKeys:@[levelKey]];
        } else {
            NSMutableDictionary* dic = [static_ampEscapeDisallowedCharacterSets mutableCopy];
            [dic setValue:answer
                   forKey:levelKey];
            static_ampEscapeDisallowedCharacterSets = [dic copy];
            [dic release];
        }
    }

    return [static_ampEscapeDisallowedCharacterSets objectForKey:levelKey];
}

+ (NSString*)ampEscapeSequenceForChar:(unichar)character {
    NSString* key = [[NSString alloc] initWithFormat:@"%hd", (short)character] ;
    NSString* sequence = [[NSString ampEscapeSequencesFromNumbers] objectForKey:key] ;
    if (!sequence) {
        // mnemonic found in table; encode as a &#nn; number style, for example #39;
        sequence = [@"#" stringByAppendingString:key] ;
    }

    // Add & prefix and ; suffix
    sequence = [[@"&" stringByAppendingString:sequence] stringByAppendingString:@";"] ;
    [key release] ;
    return sequence ;
}

+ (BOOL)isValidUnicodeUnichar:(unichar)charCode {
    NSCharacterSet* cs = [NSCharacterSet characterSetWithRange:NSMakeRange(charCode,1)] ;
    NSString* s = [[NSString alloc] initWithFormat:@"%C", charCode] ;
    NSRange r = [s rangeOfCharacterFromSet:cs
                                   options:0
                                     range:NSMakeRange(0,1)] ;
    [s release] ;
    return (r.location != NSNotFound) ;
}

- (BOOL)isSmartSearchUrl {
    /*
     The following section was added in BookMacster 1.9.8, after user
     Scott Huchton <shuchton@gmail.com> pointed out to me at MacWorld|iWorld
     that BookMacster was not exporting Firefox' Smart Search Bookmarks
     to Firefox.  A typical Smart Search Bookmark's URL is:
     http://www.bing.com/search?q=%s&=&qs=bs&form=QBLH
     This is not a valid URL, because of the "q=%s" key/value pair in
     the query.  In a URL, % denotes the start of a percent-escape
     sequence and is expected to be followed by hexadecimal digits,
     which s is not; therefore this is invalid.  Firefox
     uses %s as a format placeholder and substitutes in the search
     string in place of %s in order to create a valid URL.
     
     The problem is manifested in +[Extore isExportableStark:withChange:]
     wherein a bookmark must pass one of these tests to be exportable:
     • URL is a file:// URL
     • URL is a javascript: URL
     • sharype value is SharypeSmart
     
     The Smart Search Bookmark passed none of these, until we added the
     following section, so that it can be Smart URL.  It does seem
     */
    BOOL isSmartSearchUrl = NO ;
    // In the next line, resource:// was added in BookMacster 1.11.4 to support, for example, this one from user Neil Lee
    // resource://recallmonkey-at-prospector-dot-labs-dot-mozilla-recallmonkey-data/dashboard.html?s=%s
    if ([self hasPrefix:@"http://"] || [self hasPrefix:@"https://"] || [self hasPrefix:@"resource://"]) {
        NSURL* uurl = [[NSURL alloc] initWithString:self] ;
        if (!uurl) {
            // url is an invalid URL, possibly because it contains something
            // like "q=%s" in its query portion
            NSMutableString* fixedUrl = [self mutableCopy] ;
            [fixedUrl replaceOccurrencesOfString:@"=%s"
                                      withString:@"=%ff"] ;
            NSURL* uuurl = [[NSURL alloc] initWithString:fixedUrl] ;
            [fixedUrl release] ;
            if (uuurl) {
                // Ah, fixedUrl is valid.  Therefore, url *did* contain =%s
                // in its query portion
                isSmartSearchUrl = YES ;
            }
            [uuurl release] ;
        }
        [uurl release] ;

        // The following was added in BookMacster 1.11.4 to support,
        // for examples, these two from user Neil Lee…
        // http://canada411.yellowpages.ca/search/si-bn/1/%s/toronto
        // http://www.clicker.com/find/%s
        // These cases are *not* caught by the previous test.
        
        if (!isSmartSearchUrl) {
            if ([self containsString:@"/%s"]) {
                isSmartSearchUrl = YES ;
            }
        }
    }

    return isSmartSearchUrl;
}

- (NSString*)md5HashAsLowercaseHex {
    NSData* urlData = [self dataUsingEncoding:NSUTF8StringEncoding] ;
    NSData* data = [urlData md5Digest] ;

    return [data lowercaseHexString] ;
}

- (NSString*)normalizedUrlStripTrailingPathSlashes:(BOOL)stripTrailingPathSlashes {
    NSString* url = self ;
    NSInteger iLoopWatcher = 0 ;
    NSString* priorRoundUrl ;
    do {
        priorRoundUrl = url ;

        // First of all, the only URLs we know how to normalize are those
        // whose schemes are "http" or "feed".  We don't normalize
        // javascript (bookmarklet), place (Firefox Smart Bookmark), chrome,
        // or any other scheme which anyone might invent.  Note that
        // we need to do this before invoking -[NSURL urlWithString],
        // because before doing that we need to encode the string, which
        // would change the string for other schemes.  So, we check two
        // things.  First of all, a "http" or "feed" url must be at least
        // 6 characters long, as in "http://".  Then we can check for
        // "http" or "feed" without worry of underrunning -substringToIndex:4.
        if ([url length] > 6) {
            BOOL isFirefoxSmartSearch = NO ;
            if ([url hasPrefix:@"resource"]) {
                NSURL* testUrl = [[NSURL alloc] initWithString:url] ;
                if (!testUrl) {
                    if ([url containsString:@"%s"]) {
                        url = [url stringByReplacingOccurrencesOfString:@"%s"
                                                             withString:@"%DEAD"] ;
                        isFirefoxSmartSearch = YES ;
                    }
                }
                
                [testUrl release] ;
            }
            
            NSString* prefix = [url substringToIndex:4] ;
            if ([prefix isEqualToString:@"http"] || [prefix isEqualToString:@"feed"] || [url hasPrefix:@"resource"]) {
                url = [url encodePercentEscapesPerStandard:SSYPercentEscapeStandardRFC2396
                                                    butNot:@"`#%^[]{}|\"<>\\"
                                                   butAlso:@" "] ;  // Spaces are not allowed in any part of a URL

                if (url) {
                    NSURL* daUrl = [[NSURL alloc] initWithString:url] ;
                    
                    if (daUrl) {
                        if (![daUrl isFileURL]) {
                            // Take it apart and normalize each part
                            
                            NSString* scheme = [daUrl scheme] ;
                            BOOL hadScheme = (scheme != nil) ;
                            
                            // This is so that if a user types in url = "Foo.com", it will
                            // be normalized to "http://foo.com/"
                            if (!scheme) {
                                scheme = @"http" ;
                            }
                            
                            // *  Scheme part

                            //   This is to un-do the change done by Safari: Whenever if
                            //   visits a live bookmark, it changes its scheme to "feed"
                            // This needs further study!  Chrome does not do this.
                            //20110301				if ([scheme isEqualToString:@"feed"]) {
                            //20110301					scheme = @"http" ;
                            //20110301				}
                            
                            // *  Path part

                            /* Starting with BookMacster 1.16.4, we eliminate a
                             bunch of code and use CFURL *exclusively* instead
                             of -[NSURL path].  Note 20130714.
                             This was to fix this bug:
                             https://sheepsystems.com/discuss/YaBB.pl?num=1373727902/0#1
                             REMEMBER THIS: -[NSURL path] decodes percent
                             escapes and strips trailing slashes, while
                             CFURLCopyPath() does neither. */
                            NSString* path = [(NSString*)CFURLCopyPath((CFURLRef)daUrl) autorelease] ;

                            /*  Fix added in BookMacster 1.19.8, to restore the
                             stripTrailingPathSlashes feature which was
                             broken in BookMacster 1.16.4. */
                            if (stripTrailingPathSlashes) {
                                if ([path hasSuffix:@"/"] && ([path length] > 1)) {
                                    path = [path substringToIndex:([path length] - 1)] ;
                                }
                            }
                            
                            // *  Host part

                            NSString* host = [[daUrl host] lowercaseString] ;
                            /* If host is comprised of decimal digits only,
                             convert it to dotted quad format.  Chrome 60 and
                             Firefox 55 do this.  Safari 11 does not. */
                            NSString* decimalDigitsInHost = [host stringByRemovingCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
                            if ([decimalDigitsInHost isEqualToString:host]) {
                                NSInteger value = [host integerValue];
                                if ((value >=0) && (value < pow(256,4))) {
                                    NSInteger quad3 = 0;
                                    if (value >= pow(256,3)) {
                                        quad3 = value/pow(256,3);
                                        value = value - quad3*pow(256,3);
                                    }
                                    NSInteger quad2 = 0;
                                    if (value >= pow(256,2)) {
                                        quad2 = value/pow(256,2);
                                        value = value - quad2*pow(256,2);
                                    }
                                    NSInteger quad1 = 0;
                                    if (value >= pow(256,1)) {
                                        quad1 = value/pow(256,1);
                                        value = value - quad1*pow(256,1);
                                    }
                                    NSInteger quad0 = 0;
                                    if (value >= pow(256,0)) {
                                        quad0 = value/pow(256,0);
                                    }
                                    host = [NSString stringWithFormat:
                                            @"%ld.%ld.%ld.%ld",
                                            quad3, quad2, quad1, quad0];
                                }
                            }
                            if (!host && path  && ![scheme isEqualToString:@"file"]) {
                                NSArray* comps = [path pathComponents] ;
                                if ([comps count] > 1) {
                                    if ([[comps objectAtIndex:0] isEqualToString:@"/"]) {
                                        host = [comps objectAtIndex:1] ;
                                        if ([comps count] > 2) {
                                            NSRange range = NSMakeRange(2, [comps count] - 2) ;
                                            NSString* prefix = [[comps objectAtIndex:2] isEqualToString:@"/"] ? @"" : @"/" ;
                                            path = [prefix stringByAppendingString:[NSString pathWithComponents:[comps subarrayWithRange:range]]] ;
                                        }
                                        else {
                                            path = nil ;
                                        }
                                    }
                                }
                            }
                            
                            // *  Authentication (User and Password) parts

                            // Added in BookMacster 1.12.2
                            NSString* user = [daUrl user] ;
                            NSString* authentication = @"" ;
                            if (user) {
                                NSString* password = [daUrl password] ;
                                if (password) {
                                    // Bug fix in BookMacster 1.14.4.  Prior to this the following
                                    // line executed without the password because I'd put a semicolon
                                    // ending the previous line instead of curly brackets.
                                    authentication = [NSString stringWithFormat:@"%@:%@@", user, password] ;
                                }
                            }
                            
                            // This is so that if a user types in url = "Foo.com", it will
                            // be normalized to "http://foo.com/"
                            if (!host) {
                                if (hadScheme) {
                                    host = @"" ;
                                    path = @"" ;
                                }
                                else {
                                    host = self ;
                                    path = @"/" ;
                                }
                            }
                            
                            // *  Fragment part

                            NSString* fragment = [daUrl fragment] ;
                            
                            // *  Path part

                            // Percent Escape encoding was removed here, as a companion to
                            // the bug fix noted above in Note 20130714, in
                            // BookMacster 1.16.4.
                            if (([path length] == 0)  && ([host length] > 1)) {
                                path = @"/" ;
                            }
                            
                            // *  Port part (rare)

                            NSNumber* oPort = [daUrl port] ;
                            NSString* port = nil ;
                            if (oPort) {
                                NSInteger portValue = [oPort integerValue] ;
                                // Port 80 is the default port and should not be stated
                                if (portValue != 80) {
                                    port = [NSString stringWithFormat:@"%ld", (long)portValue] ;
                                }
                                // Added in BookMacster 1.14.1…
                                // If scheme is https, to state port 443 is redundant.
                                // Google Chrome eliminates the port.
                                if ([scheme isEqualToString:@"https"] && portValue == 443) {
                                    port = nil ;
                                }
                            }
                            
                            // *  Query part

                            NSString* query = [daUrl query] ;
                            
                            
                            // Now put back together the normalized parts

                            /* IPv6 Literal (numeric) URLs have their host
                             portion wrapped in square brackets, as explained
                             here:
                             http://www.gestioip.net/docu/ipv6_address_examples.html
                             -[NSURL initWithString:] knows about that and
                             ignores the square brackets.  But -[NSURL host]
                             gives us the host, of, course, without the square
                             brackets.  So we must re-wrap such a host in
                             square brackets. */
                            BOOL isIPv6Literal = [url rangeOfString:@"://["].location < 7;

                            NSString* wrappedHost = isIPv6Literal ? [NSString stringWithFormat:@"[%@]", host] : host;
                            NSMutableString* urlMute = [[NSMutableString alloc] initWithFormat:@"%@://%@%@",
                                                        scheme,
                                                        authentication, // Added in BookMacster 1.12.2
                                                        wrappedHost] ;
                            if ([port length] > 0) {
                                [urlMute appendString:@":"] ;
                                [urlMute appendString:port] ;
                            }
                            [urlMute appendString:path] ;
                            if ([query length] > 0) {
                                [urlMute appendString:@"?"] ;
                                [urlMute appendString:query] ;
                            }
                            if ([fragment length] > 0) {
                                [urlMute appendString:@"#"] ;
                                [urlMute appendString:fragment] ;
                            }
                            
                            url = [NSString stringWithString:urlMute] ;
                            [urlMute release] ;
                            
                        }
                    }
                    [daUrl release] ;
                }
                else {
                    /*
                     The 'if() test and this branch added in BookMacster 1.17.
                     It is to handle the case of URLs which contain "%EF%BF%BD",
                     for example:
                     http://forums.oracle.com/forums/thread.jspa?messageID=2288035%EF%BF%BD
                     which came in a Trouble Zipper from the Delicious
                     bookmarks of user Tim Jones. The Unicode sequence EF BF BF
                     is the "Unicode replacement character.  Don't try to NSLog
                     that URL.  It won't log!!
                     */
                    url = self ;
                }
            }
            else if ([url hasPrefix:@"file://localhost/"]) {
                // Firefox does this.  (Chrome does not, but, oh, well.)
                url = [@"file:///" stringByAppendingString:[url substringFromIndex:17]] ;
            }
            
            if (isFirefoxSmartSearch) {
                url = [url stringByReplacingOccurrencesOfString:@"%DEAD"
                                                     withString:@"%s"] ;
            }

        }

        iLoopWatcher++ ;
    } while (![priorRoundUrl isEqualToString:url] && iLoopWatcher < 3) ;

    if (iLoopWatcher > 3) {
        NSLog(@"Warning 614-0576 %s %@", __PRETTY_FUNCTION__, self) ;
    }

    return url ;
}

- (NSString*)normalizedUrl {
    return [self normalizedUrlStripTrailingPathSlashes:NO] ;
}

- (NSString*)aggressivelyNormalizedUrl {
    return [self normalizedUrlStripTrailingPathSlashes:YES] ;
}	

// This method is not used since I've now embedded into parsing of html for better efficiency I hope
- (BOOL)containsUnquotedUnescapedApostrophe
{
    NSScanner* scanner = [[NSScanner alloc] initWithString:self] ;
    BOOL insideQuote = NO ;
    BOOL foundOne = NO ;
    NSString* fragment ;
    while (![scanner isAtEnd]) {
        [scanner scanUpToString:@"\""intoString:&fragment] ;

        // NSLog(@"insideQuote = %i. Scanning:%@", insideQuote, fragment) ;
        if (!insideQuote) {
            if ([fragment containsString:@"'"]) {
                NSLog(@"Found illegal unescaped apostrophe in \"%@\"", fragment) ;
                foundOne = YES ;
                break ;
            }
        }

        [scanner scanString:@"\"" intoString:NULL] ;
        insideQuote = !insideQuote ;
    }

    [scanner release] ;
    return foundOne ;
}

- (NSDictionary*)queries {
    NSString* s = [self decodePercentEscapes] ;
    NSArray* kvStrings = [s componentsSeparatedByString:@"&"] ;
    NSMutableDictionary* queries = [[NSMutableDictionary alloc] initWithCapacity:16] ;
    NSEnumerator* e = [kvStrings objectEnumerator] ;
    NSString* kvString ;
    while ((kvString = [e nextObject])) {
        NSArray* kv = [kvString componentsSeparatedByString:@"="] ;
        if ([kv count] > 1) {
            NSString* key = [kv objectAtIndex:0] ;
            NSString* value = [kv objectAtIndex:1] ;
            [queries setObject:value forKey:key] ;
        }
    }

    NSDictionary* output = [queries copy] ;
    [queries release] ;

    return [output autorelease] ;
}

- (NSInteger)locationOfUnquotedSubstring:(NSString*)tc {
    NSInteger locFound = NSNotFound ;
    NSInteger locStart = 0 ;
    NSInteger lenWhole = [self length] ;
    BOOL done = NO ;
    while (!done) {
        NSInteger lenAfter = lenWhole - locStart ;
        locFound = [self rangeOfString:tc
                               options:NSCaseInsensitiveSearch
                                 range:NSMakeRange(locStart, lenAfter)].location ;
        if (locFound == NSNotFound) {
            // Target not found
            done = YES ;
        }
        else if ([self occurrencesOfSubstring:@"\"" inRange:NSMakeRange(0, locFound)] % 2) {
            // Target found but it is within a pair of quotes, move on and keep looking
            locStart = locFound + 1 ;

        }
        else {
            // Target found and it is not within a pair of quotes
            done = YES ;
        }
    }

    return locFound ;
}

- (NSString*)quotedAttributeValueForKey:(NSString*)key {
    NSRange closingQuote ;
    NSRange keyEqualsQuote ;
    keyEqualsQuote.location = [self locationOfUnquotedSubstring:[NSString stringWithFormat:@"%@=\"", key]] ;
    keyEqualsQuote.length = [key length] + 2 ; // 1 for equals + 1 for quote = 2
    if (keyEqualsQuote.location != NSNotFound) {
        // return everything up to the next " . A malformed bookmark might not have a closing " which
        // will throw things out of whack slightly, but it's better than crashing.
        NSInteger valueLocation = (keyEqualsQuote.location+keyEqualsQuote.length) ;
        closingQuote = [self rangeOfString:@"\"" options:0 range:NSMakeRange(valueLocation, [self length]-valueLocation)];
        if (closingQuote.location != NSNotFound)
            return [self substringWithRange:NSMakeRange(valueLocation, closingQuote.location - valueLocation)] ;
    }
    return nil ;
}

- (NSString*)unquotedAttributeValueForKey:(NSString*)key {
    NSRange delimiter ;
    // We look for the first ^unquoted^ char because "key=" might
    // also appear in a quoted part of the string.  For example, a javascript
    // bookmarklet to Yahoo's "Save To My Bookmarks" has a status=something inside
    // of it, which can be mistaken for a status= bookmark attribute.
    NSInteger keyLocation = [self locationOfUnquotedSubstring:[NSString stringWithFormat:@"%@=", key]] ; //

    if (keyLocation != NSNotFound)
    {
        NSInteger valueLocation = keyLocation  + [key length] + 1 ; // +1 is for the equals sign.
        // There are two possible delimiters:
        //    a space character (if another attribute follows), or
        //    end of string (if this is the last attribute)
        // NSInteger valueLocation = (keyEquals.location+keyEquals.length) ;
        delimiter = [self rangeOfString:@" " options:0 range:NSMakeRange(valueLocation, [self length]-valueLocation)];
        if (delimiter.location == NSNotFound) {
            delimiter.location = [self length] ;
        }
        if (delimiter.location != NSNotFound) {
            return [self substringWithRange:NSMakeRange(valueLocation, delimiter.location - valueLocation)] ;
        }
    }
    return nil ;
}

- (NSComparisonResult)compareByDomainHostPathWith:(NSString*)otherString
{
    NSComparisonResult result ;
    NSURL *url1, *url2 ;

    url1 = [[NSURL alloc] initWithString:self] ;
    url2 = [[NSURL alloc] initWithString:otherString] ;

    if (url1 && url2)
    {
        NSString *host1, *host2 ;
        host1 = [url1 host] ;
        host2 = [url2 host] ;

        if (host1 && host2)
        {
            NSArray  *dots1, *dots2 ;
            dots1 = [host1 componentsSeparatedByString:@"."] ;
            dots2 = [host2 componentsSeparatedByString:@"."] ;
            NSUInteger i1, i2 ;

            i1 = [dots1 count];
            i2 = [dots2 count];

            /* First, compare by each "dot", beginning with the last (which is the
             top-level domain com org biz etc., then the hostname, etc., etc.,
             and return if a difference is found */
            while ((i1>=1) && (i2>=1))
            {
                result = [[dots1 objectAtIndex:(--i1)]  localizedCaseInsensitiveCompare:[dots2 objectAtIndex:(--i2)]] ;
                if (result != NSOrderedSame)
                {
                    [url1 release] ; //leakFix3
                    [url2 release] ; //leakFix3
                    return result ;
                }
            }

            if (i1)
                // host1 and host2 were equal as far as they went, but host1 has more dots
            {
                [url1 release] ; //leakFix3
                [url2 release] ; //leakFix3
                return NSOrderedDescending ; // so otherString will go above self
            }
            if (i2)
                // host1 and host2 were equal as far as they went, but host1 has more dots
            {
                [url1 release] ; //leakFix3
                [url2 release] ; //leakFix3
                return NSOrderedAscending ; // so self will go above otherString
            }
        }
        else
        {
            if (!host1)
            {
                // self may be a local ///file url
                [url1 release] ; //leakFix7
                [url2 release] ; //leakFix7
                return NSOrderedAscending ; // so self will go above otherString
            }
            if (!host2)
            {
                // otherString may be a local ///file url
                [url1 release] ; //leakFix7
                [url2 release] ; //leakFix7
                return NSOrderedDescending ; // so otherString will go above self
            }
            [url1 release] ; //leakFix7
            [url2 release] ; //leakFix7
            return NSOrderedSame ;
        }

        /* If we got this far without returning, it means that the "host" parts of the two
         url were found OK, but were identical.  So, now we must extract and compare the
         "path" parts. */
        NSString *path1, *path2 ;
        path1 = [url1 path] ;
        path2 = [url2 path] ;
        [url1 release] ; //leakFix3
        [url2 release] ; //leakFix3

        if (path1 && path2)
            return [path1  localizedCaseInsensitiveCompare:path2] ;
        else
        {
            if (!path1)
            {
                return NSOrderedAscending ; // so self will go above otherString
            }
            if (!path2)
            {
                return NSOrderedDescending ; // so otherString will go above self
            }
            return NSOrderedSame ;
        }

    }
    else
    {
        if (!url1)
        {
            [url2 release] ;
            return NSOrderedAscending ; // so self will go above otherString
        }
        if (!url2)
        {
            [url1 release] ;
            return NSOrderedDescending ; // so otherString will go above self
        }
        return NSOrderedSame ;
    }
}

- (NSString*)domainOfURL
{
    NSURL* aURL = [NSURL URLWithString:self] ;

    if (aURL)
    {
        NSString* aHost = [aURL host] ;
        if(aHost)
        {
            NSMutableString* str = [NSMutableString stringWithString:aHost] ;
            NSMutableString* str1 ;
            NSInteger firstDot ;

            str1 = [NSMutableString stringWithString:str] ;  // needed in case loop doesn't execute
            while ((firstDot = [str rangeOfString:@"."].location) != NSNotFound)
            {
                str1 = [NSMutableString stringWithString:str] ;
                str = [NSMutableString stringWithString:[str substringFromIndex:firstDot+1]] ;
            }

            return str1 ;
        }
        else
            return nil ;
    }
    else
        return nil ;
}

- (BOOL)urlHasSameDomainAs:(NSString*)otherURL
{
    BOOL answer ;

    NSString* domMe ;
    NSString* domOther ;
    if ((domMe = [self domainOfURL]) && (domOther = [otherURL domainOfURL]))
        answer = [domMe isEqualToString:domOther] ;
    else
        answer = NO ;

    return answer ;
}

- (BOOL)has_NotFound_Keyword
{
    NSString* path = [(NSURL*)[NSURL URLWithString:self] path] ;
    if ([path rangeOfString:@"error" options:NSCaseInsensitiveSearch].location != NSNotFound)
        return YES ;
    if ([path rangeOfString:@"moved" options:NSCaseInsensitiveSearch].location != NSNotFound)
        return YES ;
    if ([path rangeOfString:@"404" options:NSCaseInsensitiveSearch].location != NSNotFound)
        return YES ;
    if	(
         (([path rangeOfString:@"found" options:NSCaseInsensitiveSearch].location) != NSNotFound)
         &&	(([path rangeOfString:@"not" options:NSCaseInsensitiveSearch].location) != NSNotFound)
         )
    {
        return YES ;
    }
    return NO ;
}

- (BOOL)startsWithScheme
{
    if	(
         [self hasPrefix:@"http://"]
         ||	[self hasPrefix:@"https://"]
         ||	[self hasPrefix:@"feed://"]
         ||	[self hasPrefix:@"ftp://"]
         )
        return YES ;
    return NO ;
}

- (BOOL)looksLikeVacuumCleaner
{
    if	(
         ([self rangeOfString:@"seeq.com"].location != NSNotFound)
         ||
         ([self rangeOfString:@"searchportal.information.com"].location != NSNotFound)
         ||
         ([self rangeOfString:@"domainpark"].location != NSNotFound)
         ||
         ([self rangeOfString:@"find.fm"].location != NSNotFound)
         ||
         ([self rangeOfString:@"thesphere.com"].location != NSNotFound)
         ||
         ([self rangeOfString:@"dm.search.earthlink.net"].location != NSNotFound)
         ||
         ([self rangeOfString:@"park-your-domain.com"].location != NSNotFound)
         ||
         ([self rangeOfString:@"earthlink-help.com/main?InterceptSource="].location != NSNotFound)
         )
    {
        return YES ;
    }

    return NO ;
}

- (BOOL)isKnownUnnecessaryRedirect
{
    if	(
         ([self rangeOfString:@"feeds.feedburner.com"].location != NSNotFound)
         ||	([self rangeOfString:@"URLCheck" options:NSCaseInsensitiveSearch].location != NSNotFound)
         ) {
        return YES ;
    }

    NSString* query = [[NSURL URLWithString:self] query] ;

    if (query) {
        if (
            ([query rangeOfString:@"sessionid=" options:NSCaseInsensitiveSearch].location != NSNotFound)
            ||  ([query rangeOfString:@"requestid=" options:NSCaseInsensitiveSearch].location != NSNotFound)
            ) {
            return YES ;
        }
    }

    return NO ;
}

- (BOOL)isProbablyOK
{
    if	(
         ([self rangeOfString:@"topnews" options:NSCaseInsensitiveSearch].location != NSNotFound)
         ||	([self rangeOfString:@"headlines" options:NSCaseInsensitiveSearch].location != NSNotFound)
         ||	([self rangeOfString:@"today" options:NSCaseInsensitiveSearch].location != NSNotFound)
         ) {
        return YES ;
    }



    return NO ;
}

- (BOOL)stupidWebmaster404
{
    if	(
         ([self rangeOfString:@"del.icio.us"].location != NSNotFound)
         //	||	([self rangeOfString:@"" options:NSCaseInsensitiveSearch].location != NSNotFound)
         )
    {
        return YES ;
    }

    return NO ;
}

- (BOOL)isEqualExceptForQueryToString:(NSString*)orig
// Not used any more
{
    BOOL output = NO ;

    NSURL* url1 = [NSURL URLWithString:orig] ;
    NSURL* url2 = [NSURL URLWithString:self] ;
    if (url1 && url2)
    {
        NSString* query1 = [url1 query] ;
        NSString* query2 = [url2 query] ;
        if (query1 && query2)
        {
            NSRange rangeQuery1 = [orig rangeOfString:query1] ;
            NSRange rangeQuery2 = [self rangeOfString:query2] ;
            if ((rangeQuery1.location != NSNotFound) && (rangeQuery2.location != NSNotFound))
            {
                NSRange rangeUpToQuery1 = NSMakeRange(0, rangeQuery1.location) ;
                NSRange rangeUpToQuery2 = NSMakeRange(0, rangeQuery2.location) ;
                NSString* url1WithoutQuery = [orig substringWithRange:rangeUpToQuery1] ;
                NSString* url2WithoutQuery = [self substringWithRange:rangeUpToQuery2] ;
                if ([url1WithoutQuery isEqualToString:url2WithoutQuery])
                    output = YES ;
            }
        }
    }
    return output ;
}

- (BOOL)pathAndQueryTooLong
{
    NSURL* url = [NSURL URLWithString:self] ;
    NSUInteger lengthPath = [[url path] length] ;
    NSUInteger lengthQuery = [[url query] length] ;
    return (lengthPath + lengthQuery > 55) ;
}

- (BOOL)schemeIs_feed
{
    NSURL* url = [NSURL URLWithString:self] ;
    return ([[url scheme] isEqualToString:@"feed"]) ;
}

- (BOOL)looksLikeParallelLoadedHostTo:(NSString*)strURLOld
{
    NSURL* urlOld = [NSURL URLWithString:strURLOld] ;
    NSURL* urlNew = [NSURL URLWithString:self] ;
    NSString* oldHost = [urlOld host] ;
    NSString* newHost = [urlNew host] ;
    //NSLog(@"   comparing hosts: \"%@\" with \"%@\"", newHost, oldHost) ;
    NSRange firstPart = NSMakeRange(0, 1) ;
    NSUInteger oldHostLength = [oldHost length] ;
    NSUInteger newHostLength = [newHost length] ;
    BOOL stillTheSame = YES ;
    BOOL foundDot = NO ;

    // First, check and see if the least-significant subdomains are
    // similar except for a digit at the end.
    // Example: oldHost = xxx.yyy.zzz and newHost = xx2.yyy.zzz
    if(oldHostLength && newHostLength)
    {
        while
            (
             (stillTheSame)
             &&	(!foundDot)
             &&	(oldHostLength > firstPart.length)
             &&  (newHostLength > firstPart.length)
             )
        {
            NSString* firstPartOld = [oldHost substringWithRange:firstPart] ;
            NSString* firstPartNew = [newHost substringWithRange:firstPart] ;
            stillTheSame = [firstPartOld isEqualToString:firstPartNew] ;
            //NSLog(@"   compared \"%@\" with \"%@\"", firstPartNew, firstPartOld) ;
            foundDot =
            (
             ([firstPartOld rangeOfString:@"."].location != NSNotFound)
             ||  ([firstPartOld rangeOfString:@"."].location != NSNotFound)
             ) ;
            firstPart.length++ ;
        }

        firstPart.length-=2 ;
        //if( (oldHostLength>firstPart.length) && (newHostLength>firstPart.length) )
        {
            NSRange maybeDigit = NSMakeRange(firstPart.length, 1) ;
            NSInteger notUsed ;
            NSString* strMaybeDigit = [newHost substringWithRange:maybeDigit] ;
            //NSLog(@"looking for digit in \"%@\"", strMaybeDigit) ;
            // Now, return yes if the remaining part is a digit
            if ([[NSScanner scannerWithString:strMaybeDigit] scanInteger:&notUsed]) {
                return YES ;
            }
        }
    }

    // Check to see if new is a subdomain of old
    NSArray* oldHostComponents = [oldHost componentsSeparatedByString:@"."] ;
    NSArray* newHostComponents = [newHost componentsSeparatedByString:@"."] ;
    NSEnumerator* e = [oldHostComponents reverseObjectEnumerator] ;
    NSEnumerator* f = [newHostComponents reverseObjectEnumerator] ;
    NSString* newComponent ;
    NSString* oldComponent ;
    BOOL done = NO ;
    BOOL same = YES ;
    do {
        oldComponent = [e nextObject] ;
        newComponent = [f nextObject] ;
        if (!newComponent  || !oldComponent) {
            done = YES ;
        }
        else {
            if (![newComponent isEqualToString:oldComponent]) {
                done = YES ;
                same = NO ;
            }
        }
    } while (!done) ;

    if (same && newComponent) {  // If components so far are same, AND new has a subdomain where old did not
        return YES ;
    }

    return NO ;
}

- (BOOL)sameHostAs:(NSString*)otherURL
{
    NSURL* urlOld = [NSURL URLWithString:otherURL] ;
    NSURL* urlNew = [NSURL URLWithString:self] ;
    NSString* oldHost = [urlOld host] ;
    NSString* newHost = [urlNew host] ;
    return [newHost isEqualToString:oldHost] ;
}

- (BOOL)sameSchemeAs:(NSString*)otherURL
{
    NSURL* urlOld = [NSURL URLWithString:otherURL] ;
    NSURL* urlNew = [NSURL URLWithString:self] ;
    NSString* oldScheme = [urlOld scheme] ;
    NSString* newScheme = [urlNew scheme] ;
    return [newScheme isEqualToString:oldScheme] ;
}

- (BOOL)hasPath
{
    NSURL* url = [NSURL URLWithString:self] ;
    //NSLog(@"   Found URL = \"%@\" and path \"%@\"", url, [url path]) ;
    if (url)
        return ([[url path] length] > 1) ;
    return NO ;
}

- (NSString*)https_from_http {
    NSString* answer ;
    if ([self hasPrefix:@"http:"]) {
        NSString* end = [self substringFromIndex:4] ;
        answer = [@"https" stringByAppendingString:end] ;
    }
    else {
        answer = nil ;
    }
    
    return answer ;
}

- (NSString*)http_from_https {
    NSString* answer ;
    if ([self hasPrefix:@"https:"]) {
        NSString* end = [self substringFromIndex:5] ;
        answer = [@"http" stringByAppendingString:end] ;
    }
    else {
        answer = nil ;
    }
    
    return answer ;
}

/*
 @brief    Returns YES if the receiver is the same as another given string
 except that the receiver begins with prefix http: and the other one begins
 with prefix https:, otherwise returns NO
 */
- (BOOL)sameAllButHTTPvsHTTPSComparedTo:(NSString*)url2 {
    BOOL answer = NO ;
    if (([url2 length] - [self length]) == 1) {
        if ([self hasPrefix:@"http:"]) {
            if ([url2 hasPrefix:@"https:"]) {
                if ([self length] > 5) {
                    if ([url2 length] > 6) {
                        NSString* end1 = [self substringFromIndex:5] ;
                        NSString* end2 = [url2 substringFromIndex:6] ;
                        if ([end1 isEqualToString:end2]) {
                            answer = YES ;
                        }
                    }
                }
            }
        }
    }
    
    return answer ;
}

- (BOOL)sameAllButHTTPvsHTTPS:(NSString*)otherURL {
    if ([self sameAllButHTTPvsHTTPSComparedTo:otherURL]) {
        return YES ;
    }
    if ([otherURL sameAllButHTTPvsHTTPSComparedTo:self]) {
        return YES ;
    }
    
    return NO ;
}

- (BOOL)sameHostPathButHTTPvsHTTPS:(NSString*)otherURL
{
    NSURL* urlOther = [NSURL URLWithString:otherURL] ;
    NSURL* urlSelf = [NSURL URLWithString:self] ;
    if ([[urlSelf host] isEqualToString:[urlOther host]])
    {
        if ([[urlSelf path] isEqualToString:[urlOther path]])
        {
            NSString* scheme1 = [urlSelf scheme] ;
            NSString* scheme2 = [urlOther scheme] ;

            return
            (
             (
              [scheme1 isEqualToString:@"http"]
              &&	[scheme2 isEqualToString:@"https"]
              )
             ||	(
                 [scheme1 isEqualToString:@"https"]
                 &&	[scheme2 isEqualToString:@"http"]
                 )
             ) ;
        }
    }
    return NO ;
}

- (BOOL)marksSameSiteAs:(NSString*)otherUrl {
    BOOL answer = NO ;

    if (([self length] > 0) && ([self isEqualToString:otherUrl])) {
        answer = YES ;
    }
    // Added in BookMacster 1.22.5
    else if ([self sameAllButHTTPvsHTTPS:otherUrl]) {
        answer = YES ;
    }

    // The following code breaks ixporting by saying that
    // bookmarks or FOLDERS with nil URL should be matched.  EEK!:
    /*
     if (url1 && url2) {
     answer = [url1 isEqualToString:url2] ;
     }
     else if (!url1 && !url2) {
     answer = YES ;
     }
     */
    return answer ;
}

+ (NSCharacterSet*)ampEscapeSet {
    if (static_ampEscapeSet == nil) {
        NSMutableCharacterSet* set = [[NSMutableCharacterSet alloc] init] ;
        [set addCharactersInRange:NSMakeRange(0x61, 26)] ;  // lower-case Roman letters
        [set addCharactersInRange:NSMakeRange(0x41, 26)] ;  // upper-case Roman letters (*)
        [set addCharactersInRange:NSMakeRange(0x30, 10)] ;  // digits 0-9
        [set addCharactersInRange:NSMakeRange(0x23, 1)] ;   // hash #
        [set addCharactersInRange:NSMakeRange(0x26, 1)] ;   // ampersand &
        // (*) Not seen very often, but do appear for example in &Eacute;
        //     which is an upper-case E with acute accent.
        static_ampEscapeSet = [set copy];
        [set release];
    }

    return static_ampEscapeSet;
}

- (NSString*)stringByConvertingAmpEscapeSequence {
    // innerPart comes from chopping the & from beginning and also chopping ; from end
    NSRange innerRange = NSMakeRange(1, [self length] - 2) ;
    NSString* innerPart = [self substringWithRange:innerRange] ;

    // Find the represented unichar
    unichar charCode = 0 ;
    // We use 0 as our invalid-character indicator.  Besides being convenient,
    // this also serves a practical purpose because the NUL is viewed as a null
    // termination and causes some NSString methods to not work.  For example,
    // -[NSString stringByAppendingString]
    if ([innerPart hasPrefix:@"#"]) {
        // Must be a &#nn; style sequence, for example &#39;
        // innerSequence will be the #nn, for example #39
        // Strip off the #
        if ([innerPart length] > 0) {
            innerPart = [innerPart substringFromIndex:1] ;
            charCode = (unichar)[innerPart integerValue] ;
        }
    }
    else {
        // See if it is a mnemonic style sequence, for example &nbsp;
        // innerSequence will be something, for example nbsp
        NSDictionary* sequenceDic = [NSString ampEscapeNumbersFromSequences] ;
        NSNumber* number = [sequenceDic objectForKey:innerPart] ;
        if (number != nil) {
            charCode = (unichar)[number integerValue] ;
        }
        else {
            NSLog(@"Warning 343-0298 Not found amp escape innerPart %@ in %@", innerPart, self) ;
        }
    }

    NSString* output = nil ;

    if ((charCode != 0) && [NSString isValidUnicodeUnichar:charCode]) {
        // We were able to decode it.  Now convert the unichar to a string
        output = [NSString stringWithCharacters:&charCode length:1] ;
        // Note: If there is more than 1 character you'd use length:(sizeof(characters)/sizeof(unichar)
        // See http://www.cocoabuilder.com/archive/message/cocoa/2004/9/19/11779  Ali Ozer, Re: Unicode replaceOccuranceOfString
    }


    if (output == nil) {
        // We couldn't decode the sequence, so give up and replace with empty string
        // This is what OmniWeb does, so at least we won't crash
        output = @"" ;
    }

    return output ;
}

- (NSString*)stringByDecodingAmpEscapes {
    NSString* answer = @"" ;

    NSMutableString* workingCopy = [self mutableCopy] ;
    NSInteger alreadyDecodedUpTo = 0 ;

    // We need a loop in case there is > 1 amp escape sequence
    do {
        NSScanner* scanner = [[NSScanner alloc] initWithString:workingCopy] ;
        // By default, NSScanner skips whitespace and newlines.  We don't
        // want that because, for example, the default bookmarks shipped with
        // OmniWeb have some tabs and newlines in some of their comments (descriptions).
        [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithRange:NSMakeRange(0,0)]] ;
        [scanner setScanLocation:alreadyDecodedUpTo] ;

        [scanner scanUpToString:@"&"
                     intoString:NULL] ;
        // Crash Here!  See Note 20110830-01 at end of file
        NSRange replacementRange ;
        replacementRange.location = [scanner scanLocation] ;
        if ([scanner isAtEnd]) {
            [scanner release] ;
            break ;
        }

        NSString* target = @"" ;
        [scanner scanCharactersFromSet:[NSString ampEscapeSet]
                            intoString:&target] ;
        if ([scanner isAtEnd]) {
            [scanner release] ;
            break ;
        }
        NSString* semicolon ;
        BOOL didDo = [scanner scanString:@";"
                              intoString:&semicolon] ;
        if (!didDo) {
            NSLog(@"Could not find semicolon at end of amp escape beginning with '%@' at character %ld in html substring:\n%@", target, (long)(replacementRange.location), self) ;
            [scanner release] ;
            break ;
        }
        replacementRange.length = [scanner scanLocation] - replacementRange.location ;

        NSString* aeSequence = [target stringByAppendingString:semicolon] ;
        NSString* replacement = [aeSequence stringByConvertingAmpEscapeSequence] ;

        // If decoding of a sequence fails, an earlier version of
        // stringByConvertingAmpEscapeSequence: return a replacement the same as the
        // aeSequence, working copy will be unchanged, and therefore if we scan again
        // from the beginning we'll attempt it again and get into an infinite loop.
        // So, we remember how far we've already decoded.
        alreadyDecodedUpTo = replacementRange.location + [replacement length] ;
        [scanner release] ;

        [workingCopy replaceCharactersInRange:replacementRange
                                   withString:replacement] ;
    } while (YES) ;

    answer = [workingCopy copy];
    [workingCopy release];
    [answer autorelease];

    return answer ;
}

- (NSString*)stringByEncodingWithAmpEscapesLevel:(NSInteger)level {
    //  Maybe we can be more efficient by returning the input if it's OK...
    //    if ([input rangeOfCharacterFromSet:[NSString ampEscapesDisallowedCharacterSet]] == NSNotFound) {
    //        return input ;
    //    }

    NSString* workingCopy = [[self copy] autorelease];
    NSRange rangeStillToSearch = NSMakeRange( 0, [workingCopy length]) ;
    // We need a loop in case there is > 1 character that needs to be encoded
    NSCharacterSet* disallowedCharacterSet = [NSString ampEscapeDisallowedCharacterSetLevel:level] ;
    do {
        // Note that we search backwards
        NSRange badCharRange = [workingCopy rangeOfCharacterFromSet:disallowedCharacterSet
                                                            options:NSBackwardsSearch
                                                              range:rangeStillToSearch] ;
        if (badCharRange.location != NSNotFound) {
            NSString* ampEscapeSequence = [NSString ampEscapeSequenceForChar:[workingCopy characterAtIndex:badCharRange.location]] ;
            // Tried making workingCopy mutable and using replaceCharactersInRange, but this seems to give
            // inexplicable results if the length of the replacement != length of the replaced
            // So, I do it this way instead:
            NSString* partBefore = [workingCopy substringToIndex:badCharRange.location] ;
            NSString* partAfter = [workingCopy substringFromIndex:(badCharRange.location + badCharRange.length)] ;
            workingCopy = [partBefore stringByAppendingString:ampEscapeSequence] ;
            workingCopy = [workingCopy stringByAppendingString:partAfter] ;
            // Reduce the search range to the part before badCharRange
            rangeStillToSearch.length = badCharRange.location ;
        }
        else {
            break ;
        }
    } while (YES) ;

    NSString* output = [workingCopy copy];

    return [output autorelease] ;
}


/* Test code for some of the above


 NSString* u[13] ;

 u[0] = @"http://url1/" ;
 u[1] = @"ftp://xxx.yyy.zzz/nobody/likes" ;
 u[2] = @"feed://are.zzz/you.htm" ;
 u[3] = @"bonehead" ;
 u[4] = @"http://junk.com" ;
 u[5] = @"junker.com/yourJunk/here.html" ;
 u[6] = @"https://junker.com/yourJunk/here.html" ;
 u[7] = @"http://ww2.xxx.yyy.zzz:ourPort/useless.html" ;
 u[8] = @"http://www.amazon.com/books" ;
 u[9] = @"http://www.amazon.com:80/books" ;
 u[10] = @"http://store05.amazon.com:80/books" ;
 u[11] = @"" ;
 u[12] = nil ;
 u[13] = @"https://www.amazon.com:80/books" ;
 u[14] = @"http://junker.com/yourJunk/here.html" ;


 NSString* wwwURL = @"http://www.amazon.com" ;
 NSString* storeURL = @"http://store.amazon.com" ;

 for (int i=0; i<15; i++)
 {
 NSLog(@"**** %@ ****", u[i]) ;
 NSString* domain = [u[i] domainOfURL] ;
 if(domain)
 NSLog(@"domain = %@", domain) ;
 else
 NSLog(@"domainOfURL says: BAD URL!!") ;

 NSLog(@"schemeIs_feed = %i", [u[i] schemeIs_feed]) ;

 NSLog(@"looks like parallel host to www = %i", [u[i] looksLikeParallelLoadedHostTo:wwwURL]) ;

 NSLog(@"looks like parallel host to extore = %i", [u[i] looksLikeParallelLoadedHostTo:storeURL]) ;

 NSLog(@"sameHostHas amazon = %i", [u[i] sameHostAs:u[8]]) ;

 NSLog(@"sameScheme as http://www.amazon = %i", [u[i] sameSchemeAs:u[8]]) ;

 NSLog(@"hasPath = %i", [u[i] hasPath]) ;

 NSLog(@"sameHostPathButHTTPvsHTTPS as https://www.amazon.com/books = %i", [u[i] sameHostPathButHTTPvsHTTPS:u[13]]) ;

 NSLog(@"sameHostPathButHTTPvsHTTPS as http://junker.com/yourJunk/here.html = %i", [u[i] sameHostPathButHTTPvsHTTPS:u[14]]) ;
 }

 [(BkmxAppDel*)[NSApp delegate] terminate:self] ;

 */
@end
