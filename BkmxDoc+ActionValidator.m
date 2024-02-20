#import "BkmxDoc+ActionValidator.h"
#import "BkmxBasis+Strings.h"
#import "Stark+Sorting.h"
#import "Stark+Attributability.h"
#import "Starker.h"
#import "Bookshig.h"
#import "Dupetainer.h"
#import "NSArray+Starks.h"
#import "Stark+LegacyArtifacts.h"
#import "BkmxDocWinCon.h"
#import "Macster.h"
#import "BkmxDoc+Actions.h"
#import "BkmxDocumentController.h"

@implementation BkmxDoc (ActionValidator)

- (BOOL)visitMenuItemParametersForUrlTemporality:(BkmxUrlTemporality)urlTemporality
										target_p:(id*)target_p
										action_p:(SEL*)action_p
										 title_p:(NSString**)title_p {
	SEL actualWorker ;
	SEL menuAction = NULL ;
	
	switch (urlTemporality) {
		case BkmxUrlTemporalityCurrent:
			actualWorker = @selector(url) ;
			menuAction = @selector(visitItems:) ;
			break;
		case BkmxUrlTemporalityPrior:
			actualWorker = @selector(verifierPriorUrl) ;
			menuAction = @selector(visitPriorUrlItems:) ;
			break;
		case BkmxUrlTemporalitySuggested:
			actualWorker = @selector(verifierSuggestedUrl) ;
			menuAction = @selector(visitSuggestedUrlItems:) ;
			break;
	}
    
    NSMutableArray* hartainers = [[NSMutableArray alloc] init] ;
    NSMutableArray* softFolders = [[NSMutableArray alloc] init] ;
    NSMutableArray* bookmarks = [[NSMutableArray alloc] init] ;
    NSMutableSet* allBookmarks = [[NSMutableSet alloc] init] ;
    NSArray* starks = [[self bkmxDocWinCon] selectedStarks] ;
    for (Stark* stark in starks) {
            [stark classifyBySharypeDeeply:NO
                                hartainers:hartainers
                               softFolders:softFolders
                                    leaves:bookmarks
                                   notches:NULL] ;
        NSArray* moreBookmarks = [Stark immediateBookmarksInHartainers:hartainers
                                                           softFolders:softFolders
                                                             bookmarks:bookmarks] ;
        [allBookmarks addObjectsFromArray:moreBookmarks] ;
    }
    
	NSInteger nBookmarks = 0 ;
	for (Stark* bookmark in allBookmarks) {
		if ([bookmark performSelector:actualWorker] != nil) {
			nBookmarks++ ;
		}
	}
    
    [hartainers release] ;
    [softFolders release] ;
    [bookmarks release] ;
    [allBookmarks release] ;
    
	if (title_p) {
		*title_p = [[BkmxBasis sharedBasis] labelVisitForBookmarksCount:nBookmarks
														 urlTemporality:urlTemporality] ;
	}
	if (action_p) {
		*action_p = menuAction ;
	}
	if (target_p) {
		*target_p = (nBookmarks > 0) ? [[NSDocumentController sharedDocumentController] frontmostDocument] : nil ;
	}
    // See Note NilTargetDisMenu in NSMenu+StartContextual.m
	
	return (nBookmarks > 0) ;
}

- (NSInteger )countOfBookmarksInSelectedObjects {
	NSEnumerator* e = [[self selectedStarks] objectEnumerator] ;
	NSMutableArray* bookmarks = [[NSMutableArray alloc] init] ;
	Stark* item ;
	while ((item = [e nextObject])) {
		[item classifyBySharypeDeeply:YES
							 hartainers:nil
						  softFolders:nil
							   leaves:bookmarks
							  notches:nil] ;
	}
	
	NSInteger countOfBookmarksInSelection = [bookmarks count] ;
    [bookmarks release] ;
	
	return countOfBookmarksInSelection ;
}

- (BOOL)canSetSorted {
	BOOL gotAFolder = NO ;
	for (Stark* stark in [self selectedStarks]) {
		if ([stark canHaveChildren]) {
			gotAFolder = YES ;
			break ;
		}
	}
	
	return gotAFolder ;
}

- (BOOL)canNudgeUp {
	NSArray* items = [self selectedStarks] ;
	BOOL canDo ;
	
	if ([items count] != 1) {
		canDo = NO ;
	}
	else {
		Stark* item = [items objectAtIndex:0] ;
		BOOL unsortedParent = (([[item parent] shouldSort]) == NO) ;
		canDo = ([[item locationUp1] parent] != nil) && unsortedParent ;
	}
	
	return canDo ;
}

- (BOOL)canNudgeDown {
	NSArray* items = [self selectedStarks] ;
	BOOL canDo ;
	
	if ([items count] != 1) {
		canDo = NO ;
	}
	else {
		Stark* item = [items objectAtIndex:0] ;
		BOOL unsortedParent = (([[item parent] shouldSort]) == NO) ;
		canDo = ([[item locationDown1] parent] != nil) && unsortedParent ;
	}
	
	return canDo ;
}

- (BOOL)canSetSortDirective {
	NSArray* items = [self selectedStarks] ;

    Stark* stark = [items firstObject];

	return [stark canHaveSortDirective] ;
}

- (BOOL)validateMenuItem:(NSMenuItem*)item {
	BOOL answer ;
	SEL action = [item action] ;
	
	if (
		(action == @selector(copy:))
		 ||
		(action == @selector(cut:))
		||
		([item submenu] != nil)  // must be Copy To or Move To hierarchical item
		||
		(action == @selector(deleteItems:))
		 ) {
		answer = [[self selectedStarks] canMoveAnyMemberDescendant] ;
    }
    else if (action == @selector(visitItems:)) {
		answer = ([self visitMenuItemParametersForUrlTemporality:BkmxUrlTemporalityCurrent
														target_p:NULL
														action_p:NULL
														 title_p:NULL]) ;
	}    
    else if (action == @selector(visitPriorUrlItems:)) {
		answer = ([self visitMenuItemParametersForUrlTemporality:BkmxUrlTemporalityPrior
														target_p:NULL
														action_p:NULL
														 title_p:NULL]) ;
	}    
    else if (action == @selector(visitSuggestedUrlItems:)) {
		answer = ([self visitMenuItemParametersForUrlTemporality:BkmxUrlTemporalitySuggested
														target_p:NULL
														action_p:NULL
														 title_p:NULL]) ;
	}    
    else if (action == @selector(setSortable:)) {
		answer = [self canSetSorted] ;
	}
    else if (action == @selector(setSortableYes:)) {
		answer = [self canSetSorted] ;
	}
    else if (action == @selector(setSortableNo:)) {
		answer = [self canSetSorted] ;
	}
	else if (action == @selector(nudgeSelectionUp:)) {
		if ([[self bkmxDocWinCon] outlineMode]) {
			answer = [self canNudgeUp] ;
		}
		else {
			answer = NO ;
		}
    }
    else if (action == @selector(nudgeSelectionDown:)) {
		if ([[self bkmxDocWinCon] outlineMode]) {
			answer = [self canNudgeDown] ;
		}
		else {
			answer = NO ;
		}
    }
	else if (action == @selector(swapPriorAndCurrentUrls:)) {
		answer = YES ;
		for (Stark* stark in [self selectedStarks]) {
			if ([stark verifierPriorUrl] == nil) {
				answer = NO ;
				break ;
			}
		}
    }
	else if (action == @selector(swapSuggestedAndCurrentUrls:)) {
		answer = YES ;
		for (Stark* stark in [self selectedStarks]) {
			if ([stark verifierSuggestedUrl] == nil) {
				answer = NO ;
				break ;
			}
		}
    }
    else if (action == @selector(setSortDirectiveTop:)) {
		answer = [self canSetSortDirective] ;
		if (answer) {
			answer = ([[[self selectedStarks] objectAtIndex:0] sortDirectiveValue] != BkmxSortDirectiveTop)  ;
		}
    }
    else if (action == @selector(setSortDirectiveBottom:)) {
		answer = [self canSetSortDirective] ;
		if (answer) {
			answer = ([[[self selectedStarks] firstObject] sortDirectiveValue] != BkmxSortDirectiveBottom)  ;
		}
	}
    else if (action == @selector(setSortDirectiveNormal:)) {
		answer = [self canSetSortDirective] ;
		if (answer) {
			answer = ([[[self selectedStarks] firstObject] sortDirectiveValue] != BkmxSortDirectiveNormal)  ;
		}
    }
	else if (action == @selector(sort:)) {
		answer = [self needsSort] ;
	}    
	else if (action == @selector(findDupes:)) {
        answer = [self needsDupeFind] ;
	}
	else if (action == @selector(import:)) {
		answer = ([[[self macster] activeImportersOrdered] count] > 0) ;
	}
	else if (action == @selector(export:)) {
		answer = ([[[self macster] activeExportersOrdered] count] > 0) ;
	}
	else if (action == @selector(deleteAllDupes:)) {
		answer = (
				  // Must have one or more dupe
				  [[self dupetainer] hasOneOrMore]
				  &&
				  // No undiscovered dupes; otherwise wouldn't delete "All"
				  // ![[self shig] dupesMaybeMore]
				  // The above is commented out because, if Find Duplicates was aborted
				  // due to too many duplicates, dupesMaybeMore will be YES, but we still
				  // want the user to be able to Delete All Duplicates
				  // &&
				  // No operations in progress
				  ([[[[BkmxBasis sharedBasis] operationQueue] operations] count] == 0)) ;
	}
	else if (action == @selector(deleteAllContent:)) {
		answer = ([[[self starker] allSoftStarksQuickly:YES] count] > 0) ;
	}
	else if (action == @selector(verify:)) {
		answer = [self canVerify] ;
	}
	else if (action == @selector(removeLegacyArtifacts:)) {
		answer = NO ;
		for (Stark* stark in [[self starker] allSoftStarksQuickly:YES]) {
			if ([stark hasLegacyArtifacts]) {
				answer = YES ;
				break ;
			}
		}
	}			
	else if (action == @selector(moveDocument:)) {
		return YES ;
	}
	else {
		answer = [super validateMenuItem:(NSMenuItem*)item] ;
	}
	
	return answer ; 
} 

@end
