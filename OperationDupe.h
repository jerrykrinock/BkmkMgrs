#import <Cocoa/Cocoa.h>
#import "SSYOperation.h"

@interface SSYOperation (OperationDupe) 

/*!
 @brief    Finds duplicate groups in a root of bookmarks
 @details  This is a class method because it is invoked to find duplicates
 in Extore as well as BkmxDoc objects.
 @param    info  A dictionary consisting of some of the keys in
 FindDupesInfoKeyConstants.  All arguments and return values are
 passed via info.  Keys used are:
 <li><i>constKeyRootStark</i>&nbsp; Input.  Root stark from which duplicates will
 be searched for.</li>
 <li><i>constKeyExceptAllowed</i>&nbsp; Input.  If an NSNumber YES, excepts
 allowed duplicates from output.  May be nil to indicate NO.</li>
 <li><i>constKeyDoIgnoreDisparateDupes</i>&nbsp; Input.  If an NSNumber
 YES, ignores duplicates in different collections.  May be nil to indicate NO.</li>
 <li><i>constKeyDupeDic</i>&nbsp; Output.  An NSMutableDictionary of
 duplicate groups.&nbsp; Keys are the common url] of each group.&nbsp;
 Value is an array of starks having this common url].</li>
 <li><i>constKeyProgressView</i>&nbsp; Input.  An object which can accept
 progress messages that will be sent during the execution.</li>
 */
- (void)findDupes ;

/*!
 @brief    Deletes one of each bookmark in each duplicate pair of Stark bookmarks
 in a given array of DupedBookmarkPair objects.
 @details  This is a class method because it is invoked to delete duplicates
 in Extore as well as BkmxDoc objects.
 @param    info  A dictionary consisting of some of the keys in
 FindDupesInfoKeyConstants.  All arguments and return values are
 passed via info.  Keys used are:
 <ul>
 <li><i>constKeyDupeDic</i>&nbsp; Input.  An NSMutableDictionary of
 dupes.&nbsp; Keys are the common url] of each group.&nbsp;
 Value is an array of starks having this common url].&nbsp; All but one
 stark from the array in each group will be deleted from its managed object context.</li>
 <li><i>constKeyUndoManager</i>&nbsp; Input.  An undo manager which will be messaged
 to keep all deletions done by this method within one undo group.</li>
 <li><i>constKeyProgressView</i>&nbsp; Input.  An object which can accept
 progress messages that will be sent during the execution.</li>
 </ul>
  */
- (void)deleteDupes ;

@end