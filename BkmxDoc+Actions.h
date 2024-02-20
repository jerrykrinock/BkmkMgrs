#import <Cocoa/Cocoa.h>
#import "BkmxDoc.h"

/*!
 @brief    A category of IBAction methods.&nbsp; Most of those
 which involve the stark Selection invoke StarkEditor class methods
 to do the actual work.&nbsp; Most of the Document methods
 invoke other methods in BkmxDoc.m to do the actual work.
*/
@interface BkmxDoc (Actions)

- (IBAction)closeAndTrash:(id)sender ;

- (IBAction)copy:(id)sender ;
- (IBAction)cut:(id)sender ;

- (IBAction)clearDontVerify:(id)sender ;

- (IBAction)visitItems:(id)sender ;
- (IBAction)visitPriorUrlItems:(id)sender ;
- (IBAction)visitSuggestedUrlItems:(id)sender ;

- (IBAction)deleteItems:(id)sender ;

- (IBAction)setSortable:(id)sender ;
- (IBAction)setSortableYes:(id)sender ;
- (IBAction)setSortableNo:(id)sender ;
/* Needed to fulfill main menu > Edit > Will be sorted: action*/
- (void)setSelectedSortable:(id)sender;

- (IBAction)nudgeSelectionDown:(id)sender ;
- (IBAction)nudgeSelectionUp:(id)sender ;

- (IBAction)swapPriorAndCurrentUrls:(id)sender ;
- (IBAction)swapSuggestedAndCurrentUrls:(id)sender ;

- (IBAction)setSortDirectiveTop:(id)sender ;
- (IBAction)setSortDirectiveBottom:(id)sender ;
- (IBAction)setSortDirectiveNormal:(id)sender ;

- (IBAction)documentInfo:(id)sender ;

- (IBAction)exportBookMacsterizer:(NSMenuItem*)menuItem ;

- (IBAction)importOnly:(NSMenuItem*)menuItem ;

- (IBAction)exportOnly:(NSMenuItem*)menuItem ;

/*!
 @brief    Performs the Import command
 
 @details  Imports bookmark items from the external stores by
 performing all importers arrayed in the receiver's shig
 */
- (IBAction)import:(id)sender ;

/*!
 @brief    Performs the Export command
 
 @details  Exports bookmark items to the external stores by
 performing all exporters arrayed in the receiver's shig
 */
- (IBAction)export:(id)sender ;

/*!
 @brief    Performs a One-Time Import or One-Time Export, creating a
 and then destroying a temporary Client
 
 @details  Provided for AppleScriptability
 @param    path  If given, the temporary Client created will
 be a Loose File client.  Otherwise, the temporary Client
 created will be a This User client.
*/
- (void)performForUserQuickIxportPolarity:(BkmxIxportPolarity)ixportPolarity
                                 exformat:(NSString*)exformat
                                     path:(NSString*)path
                                extraInfo:(NSDictionary*)extraInfo;

- (void)performForUserQuickIxportPolarity:(BkmxIxportPolarity)ixportPolarity
                                   object:(id)object
                                     info:(NSDictionary*)extraInfo ;

- (IBAction)sort:(id)sender;

- (IBAction)consolidateFolders:(id)sender;

- (IBAction)findDupes:(id)sender ;

/*!
 @brief    Deletes all but one of the starks in each Dupe, so that
 the Dupe itself will be deleted
 
 @details  Runs in a separate thread
 */
- (IBAction)deleteAllDupes:(id)sender ;

- (IBAction)expandRoots:(id)sender ;

- (IBAction)collapseRoots:(id)sender ;

- (IBAction)deleteAllContent:(id)sender;

- (IBAction)verify:(id)sender;

- (IBAction)verifyAllNeverVerified:(id)sender ;

- (IBAction)upgradeInsecureBookmarks:(id)sender ;

- (IBAction)removeCruft:(id)sender ;

- (IBAction)removeLegacyArtifacts:(id)sender ;

- (IBAction)clearProgressView:(id)sender ;

@end
