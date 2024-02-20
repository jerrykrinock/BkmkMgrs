#import <Cocoa/Cocoa.h>
#import "NSError+InfoAccess.h"
#import "NSError+LowLevel.h"
#import "NSError+MyDomain.h"
#import "NSData+FileAlias.h"
#import "NSData+Stream.h"

/*
 Implements a tool.  Invoke tool with stdin as an archive created by NSKeyedArchiver
 of an NSDictionary containing a single key NSDataFileAliasDataKey to an alias
 record in an NSData object.  The tool returns stdout consisting of an archive
 which you can unarchive with NSKeyedUnarchiver, containing an NSDictionary
 containing either key NSDataFileAliasPathKey whose object is an NSString, or
 NSDataFileAliasErrorKey, whose object is an NSError.
 */
int main (int argc, const char * argv[]) {
    NSError* error = nil ;
    NSString* path = nil ;
    NSDataFileAliasModernity modernity = NSDataFileAliasModernityNone ;
    NSInteger bookmarkDataStaleness = NSControlStateValueMixed ;
    
    // Remember that the first arg is the command line
    if (argc != 1) {
        NSString* msg = [NSString stringWithFormat:@"Requires 1 arg, got %ld", (long)argc] ;
        error = SSYMakeError(11580, msg) ;
    }
    
    NSData* requestData = nil;
    NSDictionary* requestInfo = nil;
    if (!error) {
        requestData = [NSData dataWithStream:stdin] ;
        if (requestData) {
            /* We are expecting an NSDictionary containing a NSData value
             under a NSString ke*/
            NSSet* classes = [NSSet setWithObjects:
                              [NSDictionary class],
                              [NSString class],
                              [NSData class],
                              nil];
            requestInfo = [NSKeyedUnarchiver unarchivedObjectOfClasses:classes
                                                              fromData:requestData
                                                                 error:&error];
        }
    }
    
    if(!requestInfo) {
        error = [SSYMakeError(12608, @"Could not unarchive request") errorByAddingUnderlyingError:error] ;
    }
    
    NSData* aliasRecord = nil;
    if (!error) {
        aliasRecord = [requestInfo objectForKey:NSDataFileAliasDataKey] ;
        if(!aliasRecord) {
            error = SSYMakeError(15838, @"No aliasRecord in request") ;
        }
    }
    
    if (!error) {
        if ([[NSURL class] respondsToSelector:@selector(URLByResolvingBookmarkData:options:relativeToURL:bookmarkDataIsStale:error:)]) {
            // macOS 10.6 or later
            BOOL bookmarkDataIsStale ;
            NSURL* url = [NSURL URLByResolvingBookmarkData:aliasRecord
                                                   options:0
                                             relativeToURL:nil
                                       bookmarkDataIsStale:&bookmarkDataIsStale
                                                     error:&error] ;
            path = [url path] ;
            if (path) {
                modernity = NSDataFileAliasModernityNSURLFileBookmark ;
            }
            
            bookmarkDataStaleness = bookmarkDataIsStale ? NSControlStateValueOn : NSControlStateValueOff ;
        }
    }

    NSMutableDictionary* returnInfo = [[NSMutableDictionary alloc] initWithCapacity:3] ;
    [returnInfo setObject:[NSNumber numberWithInteger:modernity]
                   forKey:NSDataFileAliasModernityKey] ;
    [returnInfo setValue:path
                  forKey:NSDataFileAliasPathKey] ;
    [returnInfo setValue:error
                  forKey:NSDataFileAliasErrorKey] ;
    [returnInfo setObject:[NSNumber numberWithInteger:bookmarkDataStaleness]
                   forKey:NSDataFileAliasStalenessKey] ;
    
    // Note: It is important that returnInfo and all of its keys and all
    // of its values be encodeable.  The only objects we put in there were
    // NSString, and NSError whose userInfo dictionary contains only NSString
    // keys and values.  Thus, we should be OK to do the following:
    NSError* codingError = nil;
    NSData* returnData = [NSKeyedArchiver archivedDataWithRootObject:returnInfo
                                               requiringSecureCoding:YES
                                                               error:&codingError] ;
    int returnValue = (int)[error code];
    if (codingError) {
        NSLog(@"Error encoding result: %@", error);
        returnValue = 147;
    }
    [returnData writeToStream:stdout] ;

#if !__has_feature(objc_arc)
    [returnData release];
    [returnInfo release];
#endif
    
    return returnValue ;
}
