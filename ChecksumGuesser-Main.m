#import <Foundation/Foundation.h>
#import "SSYDigester.h"
#import "NSDictionary+Treedom.h"
#import "NSData+HexString.h"
#import "ChromeDigesterHelpers.h"

int twiddle(int *x, int *y, int *z, int *p);
void inittwiddle(int m, int n, int *p);

int twiddle(int *x, int *y, int *z, int *p)
{
    register int i, j, k;
    j = 1;
    while(p[j] <= 0)
        j++;
    if(p[j-1] == 0)
    {
        for(i = j-1; i != 1; i--)
            p[i] = -1;
        p[j] = 0;
        *x = *z = 0;
        p[1] = 1;
        *y = j-1;
    }
    else
    {
        if(j > 1)
            p[j-1] = 0;
        do
            j++;
        while(p[j] > 0);
        k = j-1;
        i = j;
        while(p[i] == 0)
            p[i++] = -1;
        if(p[i] == -1)
        {
            p[i] = p[k];
            *z = p[k]-1;
            *x = i-1;
            *y = k-1;
            p[k] = -1;
        }
        else
        {
            if(i == p[0])
                return(1);
            else
            {
                p[j] = p[i];
                *z = p[i]-1;
                p[i] = 0;
                *x = j-1;
                *y = i-1;
            }
        }
    }
    return(0);
}

void inittwiddle(int m, int n, int *p)
{
    int i;
    p[0] = n+1;
    for(i = 1; i != n-m+1; i++)
        p[i] = 0;
    while(i != n+1)
    {
        p[i] = i+m-n;
        i++;
    }
    p[n+1] = -2;
    if(m == 0)
        p[1] = 1;
}

BOOL checkChecksumWithExtras(NSArray* roots, NSMutableArray* keyPathsInChecksum, NSString* targetChecksum) {
    BOOL anySucceeded = NO;
    NSArray* extras = @[
                        @"2",
                        @"6A577B84D932181163CF4BC2AACB970E2A2188C476D81A37039878D03AF58A60",
                        @"0a39acb0",
                        @"2",
                        @"meta-info",
                        @"imageDataType",
                        @"imageID",
                        @"imageIdentifier",
                        @"imageType",
                        ];
    NSInteger nPossibilities = pow(2, extras.count);
    for (NSInteger i=0; i<nPossibilities; i++) {
        SSYDigester* digester = [[SSYDigester alloc] initWithAlgorithm:SSYDigesterAlgorithmMd5] ;
        for (NSString* keyPath in keyPathsInChecksum) {
            NSDictionary* branch = [roots valueForKeyPath:keyPath] ;
            [branch recursivelyPerformOnChildrenLowerSelector:@selector(updateChromeDigester:)
                                                   withObject:digester] ;
        }

        for (NSInteger j=0; j<extras.count; j++) {
            if (((i >> j) & 0x1) == 1) {
                [digester updateWithString:extras[j]
                                  encoding:NSUTF8StringEncoding] ;

            }
        }


        NSData* digest = [digester finalizeDigest] ;
        NSString* checksum = [digest lowercaseHexString] ;

        if ([checksum isEqualToString:targetChecksum]) {
            anySucceeded = YES;
            printf("Succeeded with i=%03ld\n", i);
        }
    }
    [keyPathsInChecksum removeAllObjects];

    return anySucceeded;
}

BOOL checkChecksum(NSArray* roots, NSMutableArray* keyPathsInChecksum, NSString* targetChecksum) {
    SSYDigester* digester = [[SSYDigester alloc] initWithAlgorithm:SSYDigesterAlgorithmMd5] ;
    // NSLog(@"Checking case %@", keyPathsInChecksum) ;
    for (NSString* keyPath in keyPathsInChecksum) {
        NSDictionary* branch = [roots valueForKeyPath:keyPath] ;
        if ([branch respondsToSelector:@selector(recursivelyPerformOnChildrenLowerSelector:withObject:)]) {
            [branch recursivelyPerformOnChildrenLowerSelector:@selector(updateChromeDigester:)
                                                   withObject:digester] ;
        } else if ([branch respondsToSelector:@selector(updateChromeDigester:)]) {
            // This branch only for sync_transaction_version
            [branch updateChromeDigester:digester];
        }
    }
    NSData* digest = [digester finalizeDigest] ;
    NSString* checksum = [digest lowercaseHexString] ;

    BOOL succeeded = NO;
    if ([checksum isEqualToString:targetChecksum]) {
        succeeded = YES;
        printf("Succeeded: %s\n", keyPathsInChecksum.description.UTF8String);
    }

    [keyPathsInChecksum removeAllObjects];

    return succeeded;
}


#define N 8
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSArray* paths = @[
//                          @"/Users/jk/Documents/Programming/Projects/BkmkMgrs/Resources/EmptyExtores/ExtoreOpera",
//                          @"/Users/jk/Library/Application Support/com.operasoftware.Opera/Bookmarks-0-Opera-40",
//                          @"/Users/jk/Library/Application Support/com.operasoftware.Opera/Bookmarks-1-Opera-40",
//                          @"/Users/jk/Library/Application Support/com.operasoftware.Opera/Bookmarks-1-Opera-40-a",
//                          @"/Users/jk/Library/Application Support/com.operasoftware.Opera/Bookmarks-1-Opera-40-b",
//                          @"/Users/jk/Library/Application Support/com.operasoftware.Opera/Bookmarks-1-Opera-40-c",
//                          @"/Users/jk/Library/Application Support/Google/Chrome/Default/Bookmarks-4-Chrome-63",
//                          @"/Users/jk/Library/Application Support/Google/Chrome/Default/Bookmarks-afterChrome",
//                          @"/Users/jk/Library/Application Support/Google/Chrome/Default/Bookmarks-Robert",
//                          @"/Users/jk/Library/Application Support/Google/Chrome Canary/Default/Bookmarks-Chrome-65",
//                          @"/Users/jk/Library/Application Support/Vivaldi/Default/Bookmarks-small-Vivaldi-1.13.1008",
//                          @"/Users/jk/Library/Application Support/Vivaldi/Default/Bookmarks-large-Vivaldi-old",
//                          @"/Users/jk/Library/Application Support/Vivaldi/Default/Bookmarks-large-Vivaldi-1.14",
//                          @"/Users/jk/Library/Application Support/Vivaldi/Default/Bookmarks-0-Vivaldi-1.14",
//                          @"/Users/jk/Library/Application Support/com.operasoftware.Opera/Bookmarks-4-Opera-40",
//                          @"/Users/jk/Library/Application Support/com.operasoftware.Opera/Bookmarks-0-Opera-49",
//                          @"/Users/jk/Library/Application Support/com.operasoftware.Opera/Bookmarks-4-Opera-49",
//                          @"/Users/jk/Library/Application Support/com.operasoftware.Opera/Bookmarks-0-Opera-50",
//                          @"/Users/jk/Library/Application Support/com.operasoftware.Opera/Bookmarks-4-Opera-50-a",
//                          @"/Users/jk/Library/Application Support/com.operasoftware.Opera/Bookmarks-4-Opera-50-b",
//                          @"/Users/jk/Library/Application Support/com.operasoftware.Opera/Bookmarks-4-Opera-50-c",
                          @"/Users/jk/Library/Application Support/com.operasoftware.Opera/Bookmarks-0-Opera-40-d",
                          @"/Users/jk/Library/Application Support/com.operasoftware.Opera/Bookmarks-0-Opera-47",
                          @"/Users/jk/Library/Application Support/com.operasoftware.Opera/Bookmarks-4-Opera-47-e",
                          @"/Users/jk/Library/Application Support/com.operasoftware.Opera/Bookmarks-0-Opera-48",
                          @"/Users/jk/Library/Application Support/com.operasoftware.Opera/Bookmarks-4-Opera-48-e",
                          @"/Users/jk/Library/Application Support/com.operasoftware.Opera/Bookmarks-0-Opera-49",
                          @"/Users/jk/Library/Application Support/com.operasoftware.Opera/Bookmarks-0-Opera-50-d",
                          @"/Users/jk/Library/Application Support/com.operasoftware.Opera/Bookmarks-4-Opera-50-e",
                         ];

        for (NSString* path in paths) {
            NSData* data = [NSData dataWithContentsOfFile:path];
            NSError* error = nil;
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0
                                                                   error:&error];
            NSString* targetChecksum = [json objectForKey:@"checksum"];
            printf("\n%s\n", path.UTF8String);
            printf("Target checksum: %s\n", targetChecksum.UTF8String);
            NSArray* roots = [json objectForKey:@"roots"];
            if (error) {
                NSLog(@"Error parsing file: %@", error);
            }

#if 0
            NSMutableArray* keyPathsInChecksum = [@[
                                                    @"bookmark_bar",
                                                    @"other",
                                                    @"synced",
                                                    @"trash",
                                                    @"custom_root.speedDial",
                                                    @"custom_root.trash",
                                                    @"custom_root.unsorted",
                                                    @"custom_root.userRoot"
                                                    ] mutableCopy];

            BOOL succeeded = checkChecksumWithExtras(roots, keyPathsInChecksum, targetChecksum);
            if (succeeded) {
                printf("succeeded\n");
            } else {
                printf("failed\n");
            }
#else
            NSArray* candidates = @[
                                    @"bookmark_bar",
                                    @"other",
                                    @"sync_transaction_version",
                                    @"synced",
                                    @"trash",
                                    @"custom_root",
                                    @"custom_root.speedDial",
                                    @"custom_root.trash",
                                    @"custom_root.unsorted",
                                    @"custom_root.userRoot"
                                    ];

            NSMutableArray* keyPathsInChecksum = [NSMutableArray new];
            NSInteger solutionsCount = 0;
            BOOL succeeded = NO;

            NSInteger nPossibilities = pow(2, candidates.count);
            for (NSInteger i=0; i<nPossibilities; i++) {
                [keyPathsInChecksum removeAllObjects];
                for (NSInteger j=0; j<candidates.count; j++) {
                    if (((i >> j) & 0x1) == 1) {
                        [keyPathsInChecksum addObject:candidates[j]];
                    }
                }

                succeeded = checkChecksum(roots, keyPathsInChecksum, targetChecksum);
                if (succeeded) {
                    solutionsCount++;
                }
            }
            printf("solutionsCount: %ld\n", solutionsCount);
#endif
        }
    }
    return 0;
}
