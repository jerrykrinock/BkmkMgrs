#import "HtmlEncoder.h"
#import "Stark.h"
#import "Starker.h"
#import "StarkTyper.h"
#import "NSString+BkmxURLHelp.h"
#import "NSString+LocalizeSSY.h"
#import "NSError+MyDomain.h"
#import "ExtoreFirefox.h"


@implementation HtmlEncoder

- (void)appendAllAvailableOptionalAttributesFromStark:(Stark*)stark toString:(NSMutableString*)html
{
    id value ;

    if ((value = [stark addDate]))
        [html appendFormat:@" ADD_DATE=\"%d\"", (int)[value timeIntervalSince1970]];

    if ((value = [stark lastVisitedDate]))
        [html appendFormat:@" LAST_VISIT=\"%d\"", (int)[value timeIntervalSince1970]];

    if ((value = [stark lastModifiedDate]))
        [html appendFormat:@" LAST_MODIFIED=\"%d\"", (int)[value timeIntervalSince1970]];

    if ((value = [stark shortcut]))
        [html appendFormat:@" SHORTCUTURL=\"%@\"", value];

    if ((value = [stark faviconUrl]))
        [html appendFormat:@" ICON=\"%@\"", value];

    if ([stark sharypeValue] == SharypeBar)
        [html appendString:@" PERSONAL_TOOLBAR_FOLDER=\"true\""] ;

    if (stark.tags.count > 0) {
        NSString* tagDelimiter = [ExtoreFirefox constants_p]->tagDelimiter;
        NSString* tagsString = [[stark.tags valueForKey:constKeyString] componentsJoinedByString:tagDelimiter];
        [html appendFormat:@" TAGS=\"%@\"", tagsString];
    }

}

- (NSString*)browserXMLClauseFromStark:(Stark*)stark
                           indentLevel:(unsigned)nIndents {
    id value ;
    BOOL isOmniWeb = NO;
    NSString* tag ; // used to switch between Firefox and OmniWeb tags

    NSMutableString* html = [[NSMutableString alloc] init] ;

    NSMutableString *someWhitespace = [[NSMutableString alloc] init] ;
    if (!isOmniWeb) {
        unsigned i ;
        for (i = 0; i < nIndents;i++)
            [someWhitespace insertString:@"    " atIndex:0];
    }
    else {
        ; // someWhitespace is an empty string for OmniWeb
    }

    NSString* endLine = @"\n" ;

    Sharype sharypeValue = [stark sharypeValue] ;

    if (sharypeValue == SharypeBookmark) {
        tag = isOmniWeb ? @"<dt><a" : @"<DT><A" ;

        [html appendFormat:@"%@%@", someWhitespace, tag] ;

        // Firefox does not like empty-string URLs; such a bookmarks will be deleted the second time
        // you launch Firefox with it, unless the bookmark is a "live" bookmark (has a FEEDURL).
        // However, to eliminate a dribble of fetchback errs, as of Bookdog 3.9 we now support both:
        if ((value = [stark url])) {
            [html appendFormat:@" HREF=\"%@\"", value] ;
        }

        [self appendAllAvailableOptionalAttributesFromStark:stark toString:html] ;

        // Close up the attributes, insert the name, close the A tag
        [html appendFormat:@">%@</A>%@", [[stark name] stringByEncodingWithAmpEscapesLevel:1], endLine];

        // Comments are added in their own "<DD>" tag
        if ((value = [stark comments])) {
            [html appendFormat:@"<DD>%@%@", [value stringByEncodingWithAmpEscapesLevel:2], endLine] ;
        }
    } else if ((sharypeValue & SharypeGeneralContainer) > 0) {
        if ([stark isRoot]) {
            [html appendFormat:@"%@<H1>%@</H1>%@%@<DL><p>%@",
             endLine,
             [NSString localize:@"000_Safari_Bookmarks"],
             endLine,
             endLine,
             endLine] ;
        } else {
            // It's a container but not root
            [html appendFormat:@"%@<DT><H3", someWhitespace] ;

            [self appendAllAvailableOptionalAttributesFromStark:stark toString:html] ;
            [html appendFormat:@">%@</H3>%@", [[stark name] stringByEncodingWithAmpEscapesLevel:1], endLine] ;

            // Comments are added in their own "<DD>" tag immediately following the name
            if ((value = [stark comments])) {
                [html appendFormat:@"<DD>%@%@", [value stringByEncodingWithAmpEscapesLevel:2], endLine] ;
            }

            [html appendFormat:@"%@<DL><p>%@", someWhitespace, endLine] ;
        }

        // Handle children, if any
        NSArray* children = [stark childrenOrdered] ;

        BOOL needs_dl_tags = ((([children count] > 0)) && isOmniWeb) ;

        if (needs_dl_tags) {
            NSAssert(NO, @"SSS");
            [html appendString:@"<dl"] ;
            // For RSS containers:
            //            [self appendDLAttributesFromStark:stark toString:html] ;
            [html appendFormat:@">%@", endLine] ;
        }

        NSEnumerator* enumerator = [children objectEnumerator];
        Stark* nextChild = nil ;
        while ((nextChild = [enumerator nextObject])) {
            [html appendString:[self browserXMLClauseFromStark:nextChild
                                                   indentLevel:nIndents+1]] ;
        }

        if (needs_dl_tags) {
            [html appendFormat:@"</dl>%@", endLine] ;
        }

        // Append generic closing tag for all Firefox containers
        [html appendFormat:@"%@</DL><p>%@", someWhitespace, endLine] ;
    } else if (sharypeValue == SharypeSeparator) {
        // Append opening tag(s)
        if (isOmniWeb) {
            [html appendString:@"<dt><a"] ;
        }
        else {
            [html appendFormat:@"%@<HR", someWhitespace];
        }

        // Append attributes
        // In Firefox, the following is for Foxmarks, which puts a NAME= attribute on its separator
        // In OmniWeb, it is for bookmarkid=
        [self appendAllAvailableOptionalAttributesFromStark:stark toString:html] ;

        // Append closing
        NSString* closing = isOmniWeb ? @"></a>" : @">" ;
        [html appendString:closing] ;
        [html appendString:endLine] ;
    } else {
        NSLog(@"Internal Error 623-9455 Unknown sharype 0x%lx", (long)sharypeValue) ;
    }

    [someWhitespace release];
    NSString* answer = [html copy];
    [html release];
    [answer autorelease];
    return answer;
}

- (BOOL)getData:(NSData**)data_p
        error_p:(NSError**)error_p {
    BOOL ok = YES;
    NSError* error = nil;
    NSString* preamble =
     @"<!DOCTYPE NETSCAPE-Bookmark-file-1>\n"
     @"  <HTML>\n"
     @"  <META HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=UTF-8\">\n"
     @"  <Title>Bookmarks</Title>\n";
    NSString* postamble = @"</HTML>\n";

    // Call a recursive method to create a string from the root
    NSString* guts = [self browserXMLClauseFromStark:[[self starker] root]
                                         indentLevel:0];

    NSMutableString* html = [[NSMutableString alloc] init];
    [html appendString:preamble];
    [html appendString:guts];
    [html appendString:postamble];
    NSData* data = [html dataUsingEncoding:NSUTF8StringEncoding];
    [html release];

    if (data && data_p) {
        *data_p = data;
    } else {
        ok = NO;
        error = SSYMakeError(984728, @"Could not encode html data to UFT-8");
    }

    if (error && error_p) {
        *error_p = error ;
    }

    return ok;
}

+ (BOOL)generateHtmlExportData_p:(NSData**)data_p
                          extore:(Extore*)extore
                         error_p:(NSError**)error_p {
    BOOL ok = YES;
    NSError* error = nil;
    HtmlEncoder* instance = [[HtmlEncoder alloc] initWithExtore:extore] ;
    
    ok = [instance getData:data_p
                   error_p:&error] ;

    [instance release] ;

    if (error && error_p) {
        *error_p = error ;
    }

    return ok ;
}

@end
