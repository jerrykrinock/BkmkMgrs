#import <Foundation/Foundation.h>
#import "SheepSafariHelper.h"
#import "SSYLinearFileWriter.h"
#import "BkmxGlobals.h"
#import "SSYIndexee.h"




/* Stuff defined in SheepSafariHelper.m which is not declared in SheepSafariHelper.h @interfaace */
@interface SheepSafariHelper ()

@property (readonly) SAFARI_FOLDER_CLASS* root;
@property (readonly) SAFARI_FOLDER_CLASS* bar;
@property (readonly) SAFARI_FOLDER_CLASS* menu;
@property (readonly) SAFARI_FOLDER_CLASS* readingList;
@property (retain) NSDictionary* assignedVsProposedExids;
@property (retain) NSMutableDictionary* returnResults;
/* indexPathsForProposedExids contains index paths as WebBookmark items
 appear in the WebBookmarkGroup; that is, the data in the Safari Safari
 private framework.  The indexes in the index path go in order from leafmost
 to rootmost.  Thusm the last index in the index path is the index of the
 greatest ancestor in root.  This last index may be different when when
 traversing the Bookmarks.plist file, due to the presence vs. absence of the
 hard or placeholder folders such as History and Tab Group Bookmarks in the
 Bookmarks.plist file vs. the WebBookmarkGroup. */
@property (retain) NSDictionary* indexPathsForProposedExids;
@property (readonly) dispatch_queue_t serialQueue;
@property  id buc;

- (void)load;
- (void)save;
- (void)requestSync;
- (void)clear;
- (void)acquireLockFile;
- (BOOL)doCut:(NSDictionary*)changeDic
      error_p:(NSError**)error_p;
- (BOOL)doPut:(NSDictionary*)changeDic
      error_p:(NSError**)error_p;
- (BOOL)doRepair:(NSDictionary*)changeDic
         error_p:(NSError**)error_p;
- (BOOL)fixAssignedVsProposedExidsFromDiskError_p:(NSError **)error_p;
- (NSDictionary*)recursivelyBuildTreeByAppendingChild:(WebBookmark*)child
                                             toParent:(NSMutableDictionary*)parent;
- (void)doChanges:(NSDictionary*)changes
            depth:(NSInteger)depth // for debugging
           finale:(void (^)(NSString* assignedVsProposedExids, NSDictionary* returnResults, NSError* error))finale;
- (void)processChanges:(NSDictionary*)changes
     completionHandler:(void (^)(NSString* assignedVsProposedExids, NSDictionary* returnResults, NSError* error))completionHandler;

@end

@implementation SheepSafariHelper (Test)

- (void)doCuts:(NSArray*)changes {
    NSError* error = nil;
    for (NSDictionary* change in changes) {
        [self doCut:change
            error_p:&error];
        if (error) {
            NSLog(@"Error cutting: %@", error);
        }
    }
}

- (void)doPuts:(NSArray*)changes {
    NSError* error = nil;
    for (NSDictionary* change in changes) {
        [self doPut:change
            error_p:&error];
        if (error) {
            NSLog(@"Error putting: %@", error);
        }
    }
}

- (void)doRepairs:(NSArray*)changes {
    NSError* error = nil;
    for (NSDictionary* change in changes) {
        [self doRepair:change
               error_p:&error];
        if (error) {
            NSLog(@"Error repairing: %@", error);
        }
    }
}


@end

@interface SheepSafariHelperTester : NSObject

@property (copy) NSString* thisTestLabel;
@property (assign) NSInteger serial;

@end

@implementation SheepSafariHelperTester

- (instancetype)init {
    self = [super init];
    if (self) {
        NSDate* date = [NSDate date];
        NSString* s = [date description] ;
        NSInteger tzSign = [[s substringWithRange:NSMakeRange(20,1)] isEqualToString:@"+"] ? +1 : -1 ;
        NSInteger tzHours = [[s substringWithRange:NSMakeRange(21,2)] integerValue] ;
        NSInteger tzMinutes = [[s substringWithRange:NSMakeRange(23,2)] integerValue] ;
        NSInteger tzSeconds = tzSign * (3600*tzHours + 60*tzMinutes) ;
        NSInteger localTzSeconds = [[NSTimeZone localTimeZone] secondsFromGMT] ;
        NSTimeInterval adjustment = localTzSeconds - tzSeconds ;
        NSDate* localDate = [date dateByAddingTimeInterval:adjustment] ;
        NSString* thisTestLabel = [localDate description] ;
        thisTestLabel = [thisTestLabel substringToIndex:19];
        thisTestLabel = [thisTestLabel substringFromIndex:5];

        self.thisTestLabel = thisTestLabel;
    }

    return self;
}

- (NSString*)uuid {
    CFUUIDRef cfUUID = CFUUIDCreate(kCFAllocatorDefault) ;
    NSString* uuid = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfUUID)) ;
    CFRelease(cfUUID) ;
    return uuid ;
}

/*!
 @details  Note that this method adds UUIDs to the uuids array depth first.
 This is the way that the main apps do it, because it is obviously less
 problematic because it eliminates one effect of whatever Cascade Rule the
 browser follows by deleting children before deleting parent.  (The other
 aspect – what happens if you move a child and delete its parent – is still
 problematic.)
 */
- (void)addAllSoftDescendantsOf:(WebBookmark*)node
                        uuidsTo:(NSMutableArray*)uuids
                       inSheepSafariHelper:(SheepSafariHelper*)sheepSafariHelper {
    if ([node respondsToSelector:@selector(folderAndLeafChildren)]) { // See Note F&LC
        for (WebBookmark* child in [(SAFARI_FOLDER_CLASS*)node folderAndLeafChildren]) {
            [self addAllSoftDescendantsOf:child
                                  uuidsTo:uuids
                                 inSheepSafariHelper:sheepSafariHelper];
        }
    }

    if ((node != sheepSafariHelper.root) && (node != sheepSafariHelper.bar) && (node != sheepSafariHelper.menu)  && (node != sheepSafariHelper.readingList)) {
        [uuids addObject:node.UUID];
    }
}



- (NSDictionary*)changeDicToAddBookmarkWithLabel:(NSString*)label
                                          serial:(NSInteger)serial
                                            exid:(NSString*)exid
                                    toParentExid:(NSString*)parentExid
                                           depth:(NSInteger)depth
                                           index:(NSInteger)index {
    NSString* name = [[NSString alloc] initWithFormat:
                      @"B-%02ld-%@", serial, label];
    NSString* comment = [[NSString alloc] initWithFormat:
                         @"Comment on %@", label];
    NSMutableString* labelM = [label mutableCopy];
    [labelM replaceOccurrencesOfString:@":"
                            withString:@"-"
                               options:0
                                 range:NSMakeRange(0, labelM.length)];
    [labelM replaceOccurrencesOfString:@" "
                            withString:@"-"
                               options:0
                                 range:NSMakeRange(0, labelM.length)];
    NSMutableString* url = [[NSMutableString alloc] initWithFormat:
                            @"https://example.com/%@", labelM];

    NSMutableDictionary* change = [NSMutableDictionary new];

    [change setObject:@YES
               forKey:constKeyIsNew];
    [change setObject:BkmxConstTypeBookmark
               forKey:constKeyType];
    [change setObject:parentExid
               forKey:constKeyParentExid];
    [change setObject:@(depth)
               forKey:constKeyDepth];
    [change setObject:exid
               forKey:constKeyExid];
    [change setObject:@(index)
               forKey:constKeyIndex];
    [change setObject:name
               forKey:constKeyName];
    [change setObject:url
               forKey:constKeyUrl];
    [change setObject:comment
               forKey:constKeyComments];
    NSDictionary* aChange = [change copy];

    return aChange;
}

- (NSDictionary*)changeDicToAddFolderWithLabel:(NSString*)label
                                        serial:(NSInteger)serial
                                          exid:(NSString*)exid
                                  toParentExid:(NSString*)parentExid
                                         depth:(NSInteger)depth
                                         index:(NSInteger)index {
    NSString* name = [[NSString alloc] initWithFormat:
                      @"F-%02ld-%@", serial, label];

    NSMutableDictionary* change = [NSMutableDictionary new];

    [change setObject:@YES
               forKey:constKeyIsNew];
    [change setObject:BkmxConstTypeFolder
               forKey:constKeyType];
    if (parentExid) {
        [change setObject:parentExid
                   forKey:constKeyParentExid];
    }
    [change setObject:@(depth)
               forKey:constKeyDepth];
    [change setObject:exid
               forKey:constKeyExid];
    [change setObject:@(index)
               forKey:constKeyIndex];
    [change setObject:name
               forKey:constKeyName];
    NSDictionary* aChange = [change copy];

    return aChange;
}

- (NSArray*)changesToDeleteAllItemsFromSheepSafariHelper:(SheepSafariHelper*)sheepSafariHelper {
    NSMutableArray* uuidsToRemove = [NSMutableArray new];

    [self addAllSoftDescendantsOf:sheepSafariHelper.root
                          uuidsTo:uuidsToRemove
                         inSheepSafariHelper:sheepSafariHelper];
    NSLog(@"Will remove %ld existing items", (long)uuidsToRemove.count);

    NSMutableArray* cuts = [NSMutableArray new];
    for (NSString* uuid in uuidsToRemove) {
        NSDictionary* cut = @{
                              constKeyExid : uuid
                              };
        [cuts addObject:cut];
    }

    return [cuts copy];
}

- (NSArray*)changesToAddFoldersHowMany:(NSInteger)howMany
                                 label:(NSString*)label
                            parentExid:(NSString*)parentExid
                                 depth:(NSInteger)depth
                          newItemExids:(NSMutableArray*)newItemExids {
    NSString* exid;
    NSMutableArray* puts = [NSMutableArray new];
    for (NSInteger i=0; i<howMany; i++) {
        exid = [self uuid];
        [newItemExids addObject:exid];
        [puts addObject:[self changeDicToAddFolderWithLabel:label
                                                     serial:self.serial
                                                       exid:exid
                                               toParentExid:parentExid
                                                      depth:depth
                                                      index:i]];
        self.serial = self.serial + 1;
    }

    return [puts copy];
}

- (NSArray*)changesToAdd1BookmarkToEachOfParentExids:(NSArray*)parentExids
                                               depth:(NSInteger)depth
                                              sheepSafariHelper:(SheepSafariHelper*)sheepSafariHelper {
    NSMutableArray* changes = [NSMutableArray new];
    for (NSString* parentExid in parentExids) {
        [changes addObject:[self changeDicToAddBookmarkWithLabel:self.thisTestLabel
                                                          serial:self.serial
                                                            exid:[self uuid]
                                                    toParentExid:parentExid
                                                           depth:depth
                                                           index:0]];
        self.serial = self.serial + 1;
    }

    return [changes copy];
}

#define DEEP_NOT_WIDE YES

- (void)testSheepSafariHelper:(SheepSafariHelper*)sheepSafariHelper {
    [sheepSafariHelper clear];
    [sheepSafariHelper load];
    dispatch_async(sheepSafariHelper.serialQueue, ^{
        sleep(1);
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSError* error = nil;
            [sheepSafariHelper fixAssignedVsProposedExidsFromDiskError_p:&error];
            if (error) {
                NSLog(@"fixing error: %@", error);
            }
            NSArray* cuts = [self changesToDeleteAllItemsFromSheepSafariHelper:sheepSafariHelper];

            NSMutableArray* puts = [[NSMutableArray alloc] init];
            NSMutableArray* newRootFolderExids = [NSMutableArray new];
            // Remember that iCloud will screw up if > 500 items in any folder
            [puts addObjectsFromArray:[self changesToAddFoldersHowMany:(DEEP_NOT_WIDE ? 20 : 400)
                                                                 label:[[NSString alloc] initWithFormat:@"ROT-%@", self.thisTestLabel]
                                                            parentExid:0
                                                                 depth:0
                                                          newItemExids:newRootFolderExids]];
            NSMutableArray* newBarFolderExids = [NSMutableArray new];
            // Remember that iCloud will screw up if > 500 items in any folder
            [puts addObjectsFromArray:[self changesToAddFoldersHowMany:(DEEP_NOT_WIDE ? 50 : 500)
                                                                 label:[[NSString alloc] initWithFormat:@"BAR-%@", self.thisTestLabel]
                                                            parentExid:sheepSafariHelper.bar.UUID
                                                                 depth:1
                                                          newItemExids:newBarFolderExids]];
            [puts addObjectsFromArray:[self changesToAdd1BookmarkToEachOfParentExids:newRootFolderExids
                                                                               depth:1
                                                                              sheepSafariHelper:sheepSafariHelper]];
            [puts addObjectsFromArray:[self changesToAdd1BookmarkToEachOfParentExids:newBarFolderExids
                                                                               depth:2
                                                                              sheepSafariHelper:sheepSafariHelper]];
            if (DEEP_NOT_WIDE) {
                NSMutableArray* newBarInFolderExids = [NSMutableArray new];
                for (NSString* parentExid in newBarFolderExids) {
                    [puts addObjectsFromArray:[self changesToAddFoldersHowMany:10
                                                                         label:[[NSString alloc] initWithFormat:@"BAR-IN-%@", self.thisTestLabel]
                                                                    parentExid:parentExid
                                                                         depth:2
                                                                  newItemExids:newBarInFolderExids]];
                }
                [puts addObjectsFromArray:[self changesToAdd1BookmarkToEachOfParentExids:newBarInFolderExids
                                                                                   depth:3
                                                                                  sheepSafariHelper:sheepSafariHelper]];
            }

            NSDictionary* changes = @{
                                      constKeyCuts: cuts.copy,
                                      constKeyPuts: puts.copy
                                      };
            NSLog(@"last serial number: %ld", (long)self.serial);

            [sheepSafariHelper exportForKlientAppDescription:[[NSProcessInfo processInfo] processName]
                                          changes:changes
                               completionHandler:^void(NSString* assignedVsProposedExids, NSDictionary* returnResults, NSError* error){
                                   NSData* jsonData = [assignedVsProposedExids dataUsingEncoding:NSUTF8StringEncoding];
                                   if (jsonData) {
                                       NSError* jsonDecodingError = nil;
                                       NSDictionary* exidFeedbackDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                                                       options:0
                                                                                                         error:&jsonDecodingError];
                                       if (jsonDecodingError) {
                                           NSLog(@"error decoding assignedVsProposedExids JSON: %@", jsonDecodingError );
                                       }
                                       NSLog(@"Got %ld assignedVsProposedExids", exidFeedbackDic.count);
                                   }
                                   NSLog(@"returnResults: %@\nerror: %@", returnResults, error);
                               }];
        });
    });
}


@end


int main(int argc, const char *argv[]) {
    SheepSafariHelperTester* sheepSafariHelperTester = [SheepSafariHelperTester new];
    SheepSafariHelper* sheepSafariHelper = [SheepSafariHelper new];

    [SheepSafariHelper beginLogging];
    [sheepSafariHelperTester testSheepSafariHelper:sheepSafariHelper];

    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    [runLoop runUntilDate:[NSDate distantFuture]] ;
}
