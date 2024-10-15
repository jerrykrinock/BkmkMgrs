#import <Foundation/Foundation.h>
#import "NSDictionary+BSJSONAdditions.h"
#import "ScrubChromy.h"
#import "NSData+HexString.h"
#import "NSData_AMDigest.h"


void processFile(NSString* path) {
    NSLog(@"Processing file: %@", path) ;
    NSLog(@"Please wait...") ;
    NSError* error = nil ;
    NSString* s = [NSString stringWithContentsOfFile:path
                                            encoding:NSUTF8StringEncoding
                                               error:&error] ;
    NSMutableDictionary* findings = [NSMutableDictionary new] ;
    if (error) {
        NSLog(@"error = %@", error) ;
    }
    else {
        [gScannerFindings release] ;
        gScannerFindings = [NSMutableDictionary new] ;
        NSMutableArray* locs = [[NSMutableArray alloc] init] ;
        [locs addObjectsFromArray:[gScannerFindings allKeys]] ;
        [locs sortUsingSelector:@selector(compare:)] ;
        NSMutableString* ms = [s mutableCopy] ;
        for (NSNumber* loc in [locs reverseObjectEnumerator]) {
            NSNumber* len = [gScannerFindings objectForKey:loc] ;
            NSRange range ;
            range.location = [loc integerValue] ;
            range.length = [len integerValue] ;
            NSString* value = [s substringWithRange:range] ;
            NSData* valueData = [value dataUsingEncoding:NSUTF8StringEncoding] ;
            NSData* data = [valueData md5Digest] ;
            NSString* hash = [data lowercaseHexString] ;
           [ms replaceCharactersInRange:range
                              withString:hash] ;
        }
        NSString* pathOut = [path stringByAppendingString:@"-Hashed"] ;
        [ms writeToFile:pathOut
             atomically:YES
               encoding:NSUTF8StringEncoding
                  error:&error] ;
        if (error) {
            NSLog(@"writing error: %@", error) ;
        }
        else {
            NSLog(@"Created file: %@", pathOut) ;
        }

        [ms release] ;
    }
    [findings release] ;
    NSLog(@"This program is done.  You may close the window now.") ;
}


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString* parentPath = [[[[NSHomeDirectory()
                                   stringByAppendingPathComponent:@"Library"]
                                  stringByAppendingPathComponent:@"Application Support"]
                                 stringByAppendingPathComponent:@"Chromium"]
                                stringByAppendingPathComponent:@"Default"] ;
        gScannerFindings = nil ;
        
        NSString* path ;
        path = [parentPath stringByAppendingPathComponent:@"Bookmarks-B"] ;
        processFile(path) ;
        path = [parentPath stringByAppendingPathComponent:@"Bookmarks-C"] ;
        processFile(path) ;
    }
    return 0 ;
}
