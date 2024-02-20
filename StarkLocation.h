#import <Cocoa/Cocoa.h>

@class Stark ;
@class ContentOutlineView ;

enum StarkCanParent_enum {
    StarkCanParentNopeItemNotMoveable = -5,
    StarkCanParentNopeDestinationCannotHaveChildren = -4,
    StarkCanParentNopeIncest = -3,
    StarkCanParentNopeParentProbablyRetargettedNotShowingInFlatMode = -2,
    StarkCanParentNopeStructureDoesNotAllowGivenChildInGivenParent = -1,
    StarkCanParentNopeDemarcation = 0,
    StarkCanParentOkDidFixToCurrentFolder = 1,
    StarkCanParentOkDidFixToDifferentFolder = 2,
    StarkCanParentOkAsRequested = 3
} ;
typedef enum StarkCanParent_enum StarkCanParent ;

enum StarkLocationFix_enum {
    StarkLocationFixNone,
    StarkLocationFixParentOnly,
    StarkLocationFixParentAndIndex
} ;
typedef enum StarkLocationFix_enum StarkLocationFix ;

@interface StarkLocation : NSObject {
	NSInteger index ;
	Stark* parent ;
}

@property (assign) NSInteger index ;
@property (retain) Stark* parent ;

/*!
 @brief    Checks if it is OK to insert all of items in [receiver parent],
 and, optionally, if it is not OK, resets, or in this context, "retargets"
 the parent and/or index of receiver to an appropriate insertion location.

 @details  Tests and retargetting are performed in the following order:
 
 * Checks that all of items are moveable.  If not, retargets receiver to
 {nil, 0} and jumps to end immediately, skipping any further tests.
 
 * Checks that so-far-proposed parent is a container.  See below [1].
 If not, retargets by resetting receiver's parent and index to indicate a
 location just below that of itself.  Thus, if user drops Bookmark A onto
 Bookmark B which is a child of Folder C, Bookmark A will become also a child
 of Folder C and the next sibling to Bookmark B. 
 (Note that, up until this point, items has not been considered.)
 
 * Checks that so-far-proposed parent is not a child of any of items (incest).
 See below [1].  If incest is found, retargets up the ancestry until cleared of
 incest, setting parent of receiver to an incest-free ancestor, and setting
 index of receiver to be just below the child which was previously targetted.
 
 * If outlineView was provided and so-far-proposed parent is not already root,
 checks that so-far-proposed parent is in the outlineView.  See below [1].  
 If not, retargets to the root of the given outlineView.  Thus, if, while
 viewing outline in flat mode, user drops Bookmark A onto Bookmark B which is a
 child of Folder C, instead of also becoming a child of Folder C (which is not
 visible and therefore cannot be what the user intended), Bookmark A will
 become a child of root.
 
 * If the so-far-proposed parent is root, and if it has an owner (is not an
 orphan), then, chooses a parent by invoking it's owner's
 -fosterParentForStark:.&nbsp; If any are not allowed,
 retargets to the container which has been designated by that extore class
 to accept default items, as indicated by the -defaultCollectonSharype
 for the Extore which owns the proposed parent, then retests all items. 
 (Because the index is not tested but only fixed, the remaining tests
 are only done if fixIndex is YES.)
 
 * If index is -1, changes it to 0.  Index = -1 is produced by dropping an item
 onto the bottom of an NSOutlineView.  However, I prefer that these items go to
 the top, so I change it to 0.
 
 * If the (possibly retargetted) parent is root, increases index if needed to
 to step over any permanent hartainers for this root's startainer.
 
 * If inserting at the index would overrun the children array of the (possibly
 retargetted) parent, that is, if it is > the number of children, it is now
 changed to equal this maximum allowable value.
 
 [1]  At this point, if fixParent is NO and the test has failed, no retargetting
 is done and instead the method jumps to its end immediately and returns NO.
 @param    items  array of Starks proposed to be inserted.
 If you simply want to see if it is OK to place ^any^ item at the receiver,
 pass an empty array or nil.
 If fixParent is YES, and the proposed location is no good, [location parent] 
 will be retargetted to a new location.
 If [location parent] is nil, it is interpreted to be the root of the bkmxDoc
 displayed in the outlineView.  If [location parent] is nil, and this implied root
 location is OK, [location parent] will be nil upon return.  (If outlineView is also nil,
 [location parent] will be nil and [location index] will be 0.  This is a fruitless case.)
 @param    fix  If StarkLocationFixParentOnly or StarkLocationFixParentAndIndex,
 and the current _parent of the receiver is found unable to accept items, then
 upon return, if possible, the _parent of the receiver will be modified to that
 of an appropriate retargetted location which can accept items.  If
 StarkLocationFixParentAndIndex, and after any retargetting due to
 unacceptability of parent, the current _parent of the receiver is found unable
 to accept items at the current _index, then upon return, the _index of the
 receiver will be modified to an appropriate index at which items can be
 accepted.
 @param    outlineView  the content outline view into which a drag and drop is proposed,
 or nil if this is not a drag and drop into an outline view.  This is used to make
 sure that the outlineView is currently displaying the proposed parent.
 */
- (StarkCanParent)canInsertItems:(NSArray*)items
                             fix:(StarkLocationFix)fix
                     outlineView:(ContentOutlineView*)outlineView ;

/*!
 @brief    Same as canInsertItem:fix:outlineView: except first parameter is only
 one item instead of an array.
 */
- (StarkCanParent)canInsertItem:(Stark*)item
                            fix:(StarkLocationFix)fix
                    outlineView:(ContentOutlineView*)outlineView ;

- (id)initWithParent:(id)parent index:(NSInteger)index ;
+ (StarkLocation*)starkLocationWithParent:(id)parent index:(NSInteger)index ;

@end
