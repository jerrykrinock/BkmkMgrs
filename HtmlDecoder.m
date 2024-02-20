#import "HtmlDecoder.h"
#import <Bkmxwork/Bkmxwork-Swift.h>

#import "Stark.h"
#import "NSString+SSYExtraUtils.h"
#import "Starker.h"
#import "NSError+InfoAccess.h"
#import "NSError+MyDomain.h"
#import "NSString+BkmxURLHelp.h"
#import "BkmxBasis+Strings.h"
#import "NSString+LocalizeSSY.h"
#import "NSArray+Whitespace.h"

@interface NSCharacterSet (SSYHtmlDecoder)

+ (NSCharacterSet*)attributeNameCharacterSet;

@end

@implementation NSCharacterSet (SSYHtmlDecoder)

+ (NSCharacterSet*)attributeNameCharacterSet {
    /* The following assumes that attribute names in HTML must be ASCII
     characters.  I'm not sure about that, but I've never seen any that
     were not ASCII. */
    return [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_"];
}

@end

@interface HtmlDecoder ()

/*!
 @brief    The current string being parsed inside an element.
 */
@property (nonatomic, retain) NSMutableString* currentString;

/*!
 @brief    The current lineage of starks.

 @details  The first element in this array is the receiver's
 extore's starker's root stark.
 */
@property (nonatomic, retain) NSMutableArray* currentStarks;

/*!
 @brief    The attributes of the element currently being parsed
 
 @details  NSXMLParser only gives these when the element begins.
 But sometimes you need to save them for when the element ends.
 */
@property (nonatomic, retain) NSDictionary* currentAttributes;

@end


@implementation HtmlDecoder

@synthesize currentString = m_currentString;
@synthesize currentStarks = m_currentStarks;
@synthesize currentAttributes = m_currentAttributes;


- (void) dealloc {
    [m_parser release];
    [m_currentString release];
    [m_currentStarks release];
    [m_currentAttributes release];

    [super dealloc];
}

+ (NSSet*)starkElements {
    return [NSSet setWithObjects:
            constHtmlElementNameFolder,
            constHtmlElementNameBookmark,
            constHtmlElementNameSeparator,
            nil];
}

- (BOOL)setAttributeOfStark:(Stark*)stark
                fromHtmlKey:(NSString*)key
                  htmlValue:value {
    if ([key hasSuffix:@"HREF"]) {
        [stark setUrl:value];
    } else if ([key hasSuffix:@"FEEDURL"] && (stark.url == nil)) {
        [stark setUrl:value];
    } else if ([key hasSuffix:@"ADD_DATE"]) {
        [stark setAddDate:[NSDate dateWithTimeIntervalSince1970:[value intValue]]];
    } else if ([key hasSuffix:@"LAST_VISIT"]) {
        [stark setLastVisitedDate:[NSDate dateWithTimeIntervalSince1970:[value intValue]]];
    } else if ([key hasSuffix:@"LAST_MODIFIED"]) {
        [stark setLastModifiedDate:[NSDate dateWithTimeIntervalSince1970:[value intValue]]];
    } else if ([key hasSuffix:@"TAGS"]) {
        NSArray* array = [value componentsSeparatedByString:@","];
        NSArray* tagStrings = [array arrayByTrimmingWhitespaceFromStringsAndRemovingEmptyStrings];
        [[(Extore*)[stark owner] tagger] addTagStrings:[NSSet setWithArray:tagStrings]
                                                    to:stark];
    } else if ([key hasSuffix:@"SHORTCUTURL"]) {
        [stark setShortcut:value];
    } else if ([key hasSuffix:@"ICON_URI"]) {
        [stark setFaviconUrl:value];
    } else if ([key hasSuffix:@"FOLDED"]) {
        [stark setIsExpanded:@YES];
    } else {
        return NO;
    }

    return YES;
}

- (BOOL)decodeData:(NSData*)data
           error_p:(NSError**)error_p {
    BOOL ok = YES;
    NSError* error = nil;

    NSString* fileAsString = nil;
    if (ok) {
        fileAsString = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
        if (!fileAsString) {
            ok = NO;
            error = SSYMakeError(983478, NSLocalizedString(@"Could not decode HTML file as UTF-8", nil));
        }
    }

    NSScanner *scanWhole = nil;
    if (ok) {

        // Set up to scan the bookmark file
        scanWhole = [[NSScanner alloc] initWithString:fileAsString];

        /* The next line was inherited from Bookdog code.  I don't like it,
         but there are apparently some things that rely on it, because results
         are incorrect if this next line is commented out.  The code could
         probably be modified to not require it, and would probably scan HTML
         more robustly. */
        [scanWhole setCharactersToBeSkipped:nil];

        // Scan and store the file header
        NSString* fileHeader = nil;
        // Firefox
        [scanWhole scanUpToString:@"</TITLE>" intoString:&fileHeader];
        if ([scanWhole isAtEnd]) {
            /* Header is missing.  That's OK, we don't need the header.  But
             we've just scanned the whole file, so we need to rewind: */
            [scanWhole setScanLocation:0];
        }
    }

    // Try and recover if no header was found (scanner will be at end)
    if (!ok) {
        [scanWhole setScanLocation:0];
    }


    if (ok) {
        Stark* stark = [[self starker] root];
        Stark* container = stark;

        NSScanner* scanToken = nil;
        NSString* tokenPrefix = nil;
        NSString* tempString1 = nil;
        NSString* tempString2 = nil;
        unsigned long scanIndex = 0;
        BOOL rootIsMenu = NO;
        Stark* bar = nil;
        Stark* unfiled = nil;

        // Parse the file, one token at a time.
        while (![scanWhole isAtEnd]) {
            [scanWhole scanUpToString:@"<" intoString:NULL];
            scanIndex = [scanWhole scanLocation];
            if ((scanIndex+3) < [fileAsString length]) // This condition is to make sure a malformed file does not cause an out-of-range except in the next line.
            {
                tokenPrefix = [[NSString alloc] initWithString:[[fileAsString substringWithRange:NSMakeRange(scanIndex,3)] uppercaseString]];

                /* To distinguish between Bookmarks, Containers and Separators in OmniWeb, we
                 next implement, in the first several branches below, this algorithm:
                 if (tagPrefix is <dd)
                 It's a Comment
                 else if (nextTagIsDL)
                 It's a Container (*)
                 else if (tag has an href)
                 It's a Bookmark
                 else if (tag has a name, not the empty string "")
                 It's a Container
                 else
                 It's a Separator
                 (*) Furthermore, if it has an href attribute, it's an RSS container
                 but that does not matter for present purposes.
                 Note: The above algorithm implies that if you delete the name of
                 an empty container (one without a <dl> following) in OmniWeb,
                 it will become a separator.  Also, deleting the name of a
                 non-empty container is OK; it just leaves a nameless folder.
                 That's exactly what happens!!
                 (tested in OmniWeb5.5) */

                if ([tokenPrefix isEqualToString:@"<A "])  {
                    // Found a bookmark (a leaf node, not a container)

                    stark = [[self starker] freshStark];
                    stark.sharypeValue = SharypeBookmark;
                    [stark moveToBkmxParent:container];

                    [scanWhole scanString:@"<A"
                               intoString:NULL];
                    /* At this point, the substring after scanWhole's
                     scanLocation will be something like this:
                     HREF="http://what.ever.com/something" ADD_DATE="1521670031" ATTRIBUTE="VALUE">Some Site</A> ...

                     The following loop will execute once for each
                     ATTRIBUTE="VALUE" pair in the anchor tag. */
                    do {
                        NSString* attributeName = @"";
                        [scanWhole scanUpToString:@"="
                                       intoString:&attributeName];

                        [scanWhole scanString:@"="
                                   intoString:NULL];
                        [scanWhole scanUpToString:@"\""
                                       intoString:NULL];
                        [scanWhole scanString:@"\""
                                   intoString:NULL];

                        NSString* value = @"";
                        [scanWhole scanUpToString:@"\""
                                       intoString:&value];
                        [scanWhole scanString:@"\""
                                   intoString:NULL];

                        [self setAttributeOfStark:stark
                                      fromHtmlKey:attributeName
                                        htmlValue:value];
                    } while (![scanWhole scanString:@">"
                                         intoString:NULL]);

                    [scanWhole scanUpToString:@"</A>"
                                   intoString:&tempString1];
                    [stark setName:[tempString1 stringByDecodingAmpEscapes]];
                    [scanWhole scanString:@"</A>"
                               intoString:NULL];
                } else if ([tokenPrefix isEqualToString:@"<DD"]) {
                    // Found comments of the current item
                    [scanWhole scanUpToString:@">" intoString:NULL];
                    [scanWhole setScanLocation:([scanWhole scanLocation]+1)];
                    // Firefox always ends comments with a \n, but there could also be \n within the comment
                    // So, we parse up to the next opening <, which will probably be a <DT> into tempString1
                    [scanWhole scanUpToString:@"<" intoString:&tempString1];
                    // But now we have to remove the spaces which are the indents in the next line
                    while ([tempString1 hasSuffix:@" "]) {
                        tempString1 = [tempString1 stringByRemovingLastCharacters:1];
                    }
                    // Finally, we check for and then remove the \n which delimits the end of the comment
                    if (![tempString1 hasSuffix:@"\n"]) {
                        NSLog(@"Internal Error 955-3838: Description not ending in line ending:\n%@", tempString1);
                    }
                    else {
                        tempString1 = [tempString1 stringByRemovingLastCharacters:[@"\n" length]]; // Usually 1, but 2 for DOS/Windows
                    }
                    [stark setComments:[tempString1 stringByDecodingAmpEscapes]];
                } else if ([tokenPrefix isEqualToString:@"<H3"]) {
                    // Found a container (as opposed to a bookmark)

                    stark = [[self starker] freshStark];
                    stark.sharypeValue = SharypeSoftFolder;
                    [stark moveToBkmxParent:container];

                    [scanWhole scanString:@"<H3"
                               intoString:NULL];
                    /* At this point, the substring after scanWhole's
                     scanLocation will be something like this:
                     ADD_DATE="1521521226" LAST_MODIFIED="1522156067" ATTRIBUTE="VALUE">Some Folder Name</H3> ...

                     The following loop will execute once for each
                     ATTRIBUTE="VALUE" or ATTRIBUTE pair in the anchor tag. */
                    do {
                        [scanWhole setCharactersToBeSkipped:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        NSString* attributeName = @"";
                        [scanWhole scanCharactersFromSet:[NSCharacterSet attributeNameCharacterSet]
                                              intoString:&attributeName];
                        [scanWhole setCharactersToBeSkipped:nil];

                        NSString* value = @"";
                        if ([scanWhole scanString:@"="
                                       intoString:NULL]) {
                            /* The next character is an equals sign.  This
                             pair must be of the form ATTRIBUTE="VALUE". */
                            [scanWhole scanUpToString:@"\""
                                           intoString:NULL];
                            [scanWhole scanString:@"\""
                                       intoString:NULL];

                            [scanWhole scanUpToString:@"\""
                                           intoString:&value];
                            [scanWhole scanString:@"\""
                                       intoString:NULL];
                        } else {
                            /* The next character is not an equals sign.  This
                             will occur if this attribute's string is simply
                             one word (attribute only), such as "FOLDED",
                             which is output by Safari to indicate that a
                             folder is collapsed.  This value-less attribute
                             implies the following line: */
                            value = @"true";
                        }

                        BOOL didProcessAttribute = [self setAttributeOfStark:stark
                                                                 fromHtmlKey:attributeName
                                                                   htmlValue:value];
                        if (rootIsMenu && !didProcessAttribute) {
                            /* Possibilities for .html files exported from Firefox: */
                            if ([attributeName isEqualToString:@"PERSONAL_TOOLBAR_FOLDER"] && [value isEqualToString:@"true"]) {
                                [stark setSharypeValue:SharypeBar];
                                bar = stark;
                            } else if ([attributeName isEqualToString:@"UNFILED_BOOKMARKS_FOLDER"] && [value isEqualToString:@"true"]) {
                                [stark setSharypeValue:SharypeUnfiled];
                                unfiled = stark;
                            }
                        }
                    } while (![scanWhole scanString:@">"
                                         intoString:NULL]);

                    [scanWhole scanUpToString:@"</H3>"
                                   intoString:&tempString1];
                    [stark setName:[tempString1 stringByDecodingAmpEscapes]];
                    [scanWhole scanString:@"</H3>"
                               intoString:NULL];

                    /* Try to find hartainer descendants of root.  This may
                     or may not work, but there is no guaranteed way to
                     do it.  If it misses for a given hartainer descendant,
                     user will have a soft one whose contents should be in the
                     hard one which is probably empty.  Less likely would be a
                     false alarm, causing contents which should have been
                     in a soft folder to be in a hartainer. */
                    if ([[stark parent] isRoot] || (([[stark parent] sharypeValue] == SharypeMenu) && rootIsMenu)) {
                        if (![[self starker] bar]) {
                            if (
                                /* For .html files exported from Safari: */
                                [stark.name isEqualToString:@"Favorites"]
                                ||
                                /* This might work for some non-English users. */
                                [stark.name isEqualToString:[NSString localize:@"000_Safari_bookmarksBar"]]
                                ) {
                                [stark setSharypeValue:SharypeBar];
                                bar = stark;
                            }
                        }

                        if (![[self starker] menu]) {
                            if (
                                /* This is for English users of Safari, and for
                                 exports from old versions of Firefox which did
                                 not use "Menu is Root". */
                                [stark.name isEqualToString:@"Bookmarks Menu"]
                                ) {
                                [stark setSharypeValue:SharypeMenu];
                            }
                        }

                        if (![[self starker] unfiled]) {
                            if (
                                /* For .html files exported from Safari: */
                                [stark.name isEqualToString:@"Reading List"]
                                ||
                                /* This might work for some non-English users. */
                                [stark.name isEqualToString:[NSString localize:@"000_Safari_bookmarksBar"]]
                                ) {
                                [stark setSharypeValue:SharypeUnfiled];
                                unfiled = stark;
                            }
                        }
                    }
                } else if ([tokenPrefix isEqualToString:@"<DL"]) {
                    // Entered definition list (DL), so recurse down to get children
                    container = stark;

                    [scanWhole setScanLocation:(scanIndex+1)];
                } else if ([tokenPrefix isEqualToString:@"</D"]) {
                    // We found a </DL>{
                    // note that we only scan for the first two characters of a tag
                    // that is why this tag is "</D" but it must in fact be "</DL"

                    // Exitted definition list (DL), so pop up back to the parent
                    Stark* parent = [container parent];
                    container = parent;
                    [scanWhole setScanLocation:(scanIndex+1)];
                } else if ([tokenPrefix isEqualToString:@"<H1"]) {
                    // Found the file header
                    [scanWhole scanUpToString:@">" intoString:&tempString1];
                    scanToken = [[NSScanner alloc] initWithString:tempString1];
                    [scanToken scanUpToString:@">" intoString:&tempString2];
                    [scanToken release];
                    [scanWhole setScanLocation:([scanWhole scanLocation]+1)];
                    NSString* rootTitle = nil;
                    [scanWhole scanUpToString:@"</H1>" intoString:&rootTitle];
                    if (
                        [rootTitle isEqualToString:@"Bookmarks Menu"]
                        ) {
                        rootIsMenu = YES;
                        stark = [[self starker] freshStark];
                        [stark setSharypeValue:SharypeMenu];
                        [stark moveToBkmxParent:[[self starker] root]];
                    }
                    [scanWhole setScanLocation:([scanWhole scanLocation]+1)];
                } else if ([tokenPrefix isEqualToString:@"<HR"]) {
                    // Found a separator
                    stark = [[self starker] freshStark];
                    [stark setSharypeValue:SharypeSeparator];
                    [stark moveToBkmxParent:container];
                    // Name of a separator is not seen in outline but is seen in Undo/Redo menu and Inspector
                    // So, we give it a name...
                    [stark setName:[[BkmxBasis sharedBasis] labelSeparator]];

                    [scanWhole scanUpToString:@">"
                                   intoString:NULL];
                    [scanWhole scanString:@">"
                               intoString:NULL];
                } else {
#if 0
                    // Peek at the whole token
                    NSString* token = @"?!?";
                    NSInteger startingLocation = [scanWhole scanLocation];
                    NSCharacterSet* tokenEndCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@" >"];
                    [scanWhole scanString:@"<"
                               intoString:NULL];
                    [scanWhole scanUpToCharactersFromSet:tokenEndCharacterSet
                                              intoString:&token];
                    [scanWhole setScanLocation:startingLocation];

                    NSSet* knownIgnorableTokens = [NSSet setWithObjects:
                                                   @"DT", @"P", @"HTML", @"TITLE", @"/HTML", @"/TITLE", nil];
                    NSString* uppercaseToken = [token uppercaseString];
                    if (![knownIgnorableTokens member:uppercaseToken]) {
                        NSLog(@"Internal Error 932-5891 Unknown token: %@", token);
                    }
#endif
                    [scanWhole scanUpToString:@">" intoString:NULL];
                }

                [tokenPrefix release];
            }
            else {
                break;  // Needed in case of no line feed or incomplete tag at end of last line.  Otherwise, will get
                // stuck in an infinite loop when scan location is somewhere in the last three characters.
            }
        }

        [fileAsString release];
        [scanWhole release];

        if (rootIsMenu) {
            /* Bar and Unfiled are children of Menu.  Fix this. */
            if (bar) {
                [bar moveToBkmxParent:[[self starker] root]
                              atIndex:0
                              restack:YES];
            }
            if (unfiled) {
                [unfiled moveToBkmxParent:[[self starker] root]
                                  atIndex:2
                                  restack:YES];
            }
        }
    }

    if (error && error_p) {
        *error_p = error ;
    }

    return ok;
}

+ (BOOL) decodeData:(NSData*)data
             extore:(Extore*)extore
            error_p:(NSError**)error_p {
    BOOL ok = YES;
    NSError* error = nil;
    HtmlDecoder* instance = [[HtmlDecoder alloc] initWithExtore:extore];
    
    ok = [instance decodeData:data
                      error_p:&error];

    [instance release];

    if (error && error_p) {
        *error_p = error ;
    }

    return ok;
}


@end
