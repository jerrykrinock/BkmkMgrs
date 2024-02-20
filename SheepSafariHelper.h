#import <Foundation/Foundation.h>
#import "SheepSafariHelperProtocol.h"
#import "SafariPrivateFramework.h"

@interface SheepSafariHelper : NSObject <SheepSafariHelperProtocol> {
    /* Because I don't know whether or not some of the methods I use to
     get these objects return the same objects every time or not, I get
     them once and cache them as instance variables for all later uses. */
    BookmarksController* _bmc;
    WebBookmarkGroup* _wbg;
    BookmarksUndoController* _buc;
    SAFARI_FOLDER_CLASS* _root;
    SAFARI_FOLDER_CLASS* _bar;
    SAFARI_FOLDER_CLASS* _menu;
    SAFARI_FOLDER_CLASS* _readingList;
    NSInteger _indexOfFirstSoftItemInRoot;
    dispatch_queue_t _serialQueue;
    NSData* _myLockFileData;

    NSMutableDictionary* _stash;
    /* The `stash` was added in BkmkMgrs 2.5.5 as a fix for some users of
     macOS 10.12 who were getting Error 772031, 772032 or 772040  when SheepSafariHelper
     attempted to make further changes to an item which had itself been moved
     earlier in the same -[SheepSafariHelper processChanges:::] execution.  For some
     reason, such folders were no longer returned by -bookmarkForUUID:.  So
     now, we stash everything we move in the `stash`, and if -bookmarkForUUID:
     fails, we try our stash

     It seems to work.  Using Trouble Zipper data from two users who were
     having, respectively, Errors 772031 and 772032, I was able to reproduce
     their issues each twice before this fix, then verify after this fix that
     it was fixed

     Although I have only seen for sure this happen in macOS 10.12, weeks ago
     I saw, but did not trace in detail, these errors happening 1% of the time
     in macOS 10.13.  I fixed this in ExtoreSafari, by allowing two retrials
     after a SheepSafariHelper import or export failed.  So maybe this will fix it for
     macOS 10.13 too, making those retrials happen 0% of time instead of 1%. */
}

+ (void)beginLogging;
+ (NSString*)niceDateTimeString;
+ (void)logString:(NSString*)string;

/* Needed for Swift extension */
- (SAFARI_FOLDER_CLASS*)root;
- (SAFARI_FOLDER_CLASS*)bar;
- (SAFARI_FOLDER_CLASS*)menu;
- (SAFARI_FOLDER_CLASS*)readingList;
- (void)reportIssue:(NSString*)issue;
- (void)logIfLevel:(NSInteger)level
            string:(NSString*)string;

- (void)recursivelyGetExids:(NSMutableSet*)exids
                    nodeDic:(NSDictionary*)node
                      depth:(NSInteger)depth;

@end
