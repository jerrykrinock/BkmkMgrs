#import <Cocoa/Cocoa.h>
#import "StarkTyper.h"
#import "SSYModelChangeTypes.h"

@class Stark ;

/*!
 @brief    A record of a single Stark's change(s).
 */
@interface Stange : NSObject {
	SSYModelChangeAction m_changeType ;
	Sharype m_sharypeCoarse ;
	NSArray* m_lineage ;
	NSMutableDictionary* m_updates ;
	NSMutableArray* m_addedChildren ; 
	NSMutableArray* m_addedTags ;
	NSMutableArray* m_deletedChildren ; 
	NSMutableArray* m_deletedTags ;
	NSString* m_fromDisplayName ;
	Stark* m_stark ;
	NSNumber* m_oldIndex ;
}

@property (assign) SSYModelChangeAction changeType ;
@property (assign) Sharype sharypeCoarse ;
@property (copy) NSArray* lineage ;
@property (retain) NSMutableDictionary* updates ;
// The following four collections are used to track changes to
// the children and tags, in order that we can
// cancel out additions and deletions of the same items,
// instead of having them appear in the log.  We use
// arrays instead of sets so that the order will reflect
// the order of the changes from different Import Clients.
// adpated = "added or updated"
@property (retain) NSMutableArray* addedChildren ;
@property (retain) NSMutableArray* addedTags ;
@property (retain) NSMutableArray* deletedChildren ;
@property (retain) NSMutableArray* deletedTags ;
@property (copy) NSString* fromDisplayName ;

/*!
 @details  Remember that this may be deleted.  Check -isAvailable before
 accessing properties.
*/
@property (retain) Stark* stark ;

/*!
 @details  Remember that these may be deleted.  Check -isAvailable before
 accessing properties.
 */
@property (retain) NSNumber* oldIndex ;

- (NSComparisonResult)compareStarkPositions:(Stange*)otherStange ;
- (void)registerAdd ;
- (void)registerDelete ;
- (BOOL)registerUpdateKey:(NSString*)key
				 oldValue:(id)oldValue
				 newValue:(id)newValue ;
- (void)registerBasicsFromStark:(Stark*)stark ;

@end

