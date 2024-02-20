#import "BkmxDoc.h"

/*!
 @details  This stuff was in BkmxDocWinCon(Autosaving) until BookMacster 1.12.3.
 It was moved here to fix the bug that Recent Landings did not work when
 BookMacster was launched in the background.
 */
@interface BkmxDoc (Autosaving)

// Utility Methods

- (NSArray*)autosaveKeyPathArrayWithLastKeys:(id)lastKeys ;


// Setters

- (void)autosaveRecentLandings:(NSArray*)recentLandings ;


// Getters

- (NSArray*)autosavedRecentLandings ;

@end
