#import <Cocoa/Cocoa.h>
#import "SSYModelChangeTypes.h"

@class BkmxDoc ;
@class Stark ;
@class Extore ;
@class Ixporter ;
@class IxportLog ;

/*!
 @brief    The Change Tracker for Starks during an Import or Export
*/
@interface Chaker : NSObject {
	BkmxDoc* m_bkmxDoc ; // weak
	NSString* m_fromDisplayName ;
	NSMutableDictionary* m_stanges ;
	BOOL m_isActive ;
    NSMutableSet* extoresWithAffectedTags;
}

- (id)initWithBkmxDoc:(BkmxDoc*)bkmxDoc ;

/*!
 @brief    Removes all existing Add, Update and Delete
 records from the receiver and sets the receiver active
 so that subsequent -addStark:, -updateStark::::,
 and -deleteStark: messages will create Starkoids
 when -endForImporters:exporter:isTestRun: is received.

 @details  Typically, send this at the beginning of an
 Import or Export operation.
*/
- (void)begin ;

/*!
 @brief    Send this message to change the fromDisplayName
 attribute of Starkoids which are created by subsequent
 -addStark:, -updateStark::::, and -deleteStark:
 messages.

 @details  Typically, you send this message when beginning
 to import from the next importer.  If the 'from'
 parameter is an importer, the fromDisplayName attribute
 of Starkoids subsequently created will be set to the 
 importer's client's display name.  If the 'from'
 parameter is an exporter, the fromDisplayName attribute
 of starkoids subsequently created will be set to nil,
 signifying the Collection.  If the 'from' parameter is
 a string, the fromDisplayName will be set to it.
 
 This method is provided in lieu of adding an ixporter
 parameter to -addStark:, -updateStark::::, and
 -deleteStark:, because these methods may be invoked from
 within KVO observer implementations where the ixporter
 is not known.  Also, this way is probably more efficient.
*/
- (void)setFrom:(id)from ;

- (void)addStark:(Stark*)stark ;

- (void)updateStark:(Stark*)stark
				key:(NSString*)key
		   oldValue:(id)oldValue
		   newValue:(id)newValue ;

- (void)deleteStark:(Stark*)stark ;

- (void)tagsHaveBeenAffectedInExtore:(Extore*)extore;

/*!
 @brief    If this property is YES, methods -addStark:,
 -updateStark:::: and -deleteStark: are no-ops.
 
 @details  This property is internally set to YES during -begin and 
 NO at the end of -endForImporters:exporter:isTestRun.  You may
 temporarily set it to NO if certain operations should not be logged.
*/
@property (assign) BOOL isActive ;


/*!
 @brief    Returns the count of all items (not only bookmarks) added,
 updated or deleted since the count was last reset.
 
 @details  The count of items updated does not include counts for
 items which were also deleted or added.
 */
- (SSYModelChangeCounts)changeCounts ;

/*!
 @brief    Returns an abbreviated human-readable string showing receiver's
 ixport added|updated|deleted change counts since the last time
 -clear was executed.
 */
- (NSString*)displayStatistics ;

/*!
 @brief    Returns whether or not there were more than 0 starks,
 owned by a given extore, that were changed (received as the 
 parameter in an addStark:, updateStark:::, or deleteStark: message)
 since the last time -clear was executed.
 
 @details  This method sends -[NSManagedObject managedObjectContext].
 This is probably not accessing the sqlite database and is therefore
 probably safe to invoke from any thread.  But I'm not sure.
 Therefore, it is recommended to invoke this method only from the
 main thread.
 */
- (BOOL)hasChangesForExtore:(Extore*)extore ;

/*!
 @brief    Sets the receiver inactive, so that it is no longer
 affected by subsequent -addStark:, -updateStark::::, and
 -deleteStark: messages, inserts a new IxportLog with 
 related Starkoids into the receiver's bkmxDoc's managed object
 context.

 @details  Typically, you send this at the conclusion of an
 Import or Export operation.
 
 @param    importer  The importers which will be added
 to the display name of the produced IxportLog.
 @param    exporter  The Ixporter which will be added
 to the display name of the produced IxportLog.
 @param    isTestRun  The value of isTestRun which will be set
 into the produced IxportLog.
 @result   The produced IxportLog
*/
- (IxportLog*)endForImporters:(NSArray*)importers
                     exporter:(Ixporter*)exporter
                    isTestRun:(NSNumber*)isTestRun ;


/*!
 @brief    The dictionary of Stanges (Stark Changes) which the receiver builds
 up during an Import or Export.

 @details  All changes for any given stark are represented in one change.
 No two stanges in the returned result will have the same -stark.
 
 The dictionary keys are NSPointers whose values give the pointer to
 the Stark whose changes are represented in the value.
*/
- (NSMutableDictionary*)stanges ;

@end
