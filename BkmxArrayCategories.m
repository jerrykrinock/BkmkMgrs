#import "BkmxDoc.h"
#import "Bookshig.h"
#import "NSString+LocalizeSSY.h"
#import "Stark+Sorting.h"
#import "NSArray+Stringing.h"
#import "NSArray+SSYMutations.h"

@implementation NSArray (BkmxArray)

- (NSString*)readableName {
	NSString* readableName = nil ;
	if ([self count] == 1) {
		readableName = [(Stark*)[self objectAtIndex:0] name] ;
	}
	else {
		readableName = [NSString localize:@"items"] ;
	}

	return readableName ;
}
		
- (BOOL)allCanAcceptSortDirective {
	for (Stark* stark in self) {
		if (![[stark parent] shouldSort]) {
			// Parent is not sorted
			return NO ;
		}
		
		if ([[(BkmxDoc*)[stark owner] shig] sortByValue] != BkmxSortByName) {
			// This bkmxDoc is not sorted by name
			return NO ;
		}
		
		Sharype sharype = [stark sharypeValue] ;
		if (sharype == SharypeSeparator) {
			// item is a separator.
			return NO ;
		}
		
		if (![StarkTyper isEditableSharype:sharype]) {
			// item is a permanent hartainer (root, bar or menu)
			return NO ;
		}
	}
	
	return YES ;
}
		
- (NSInteger)allShouldSort {
	NSInteger allShouldSort = NSControlStateValueMixed ;
	BOOL firstItem = YES ;
	for (Stark* item in self) {
		NSInteger itemSortable = [item shouldSort] ;
		if (firstItem) {
			allShouldSort = itemSortable ;
			firstItem = NO ;
		}
		else {
			if (itemSortable != allShouldSort) {
				return NSControlStateValueMixed ;
			}
		}
	}

	return allShouldSort ;
}

- (NSInteger)allHaveSortDirectiveValue:(BkmxSortDirective)sortDirectiveValue {
	NSInteger allHave = NSControlStateValueMixed ;
	BOOL firstItem = YES ;
	for (Stark* item in self) {
		BkmxSortDirective itemHas = (([item sortDirectiveValue] == sortDirectiveValue) ? NSControlStateValueOn : NSControlStateValueOff) ;
		if (firstItem) {
			allHave = itemHas ;
			firstItem = NO ;
		}
		else {
			if (itemHas != allHave) {
				return NSControlStateValueMixed ;
			}
		}
	}
	return allHave ;
}

- (NSString*)tabReturnLeavesSummary {
	NSMutableArray* leaves = [NSMutableArray array] ;
	for (Stark* item in self) {
		[item classifyBySharypeDeeply:YES
						   hartainers:nil
						  softFolders:nil
							   leaves:leaves
							  notches:nil] ;
	}
    NSArray* leavesI = [leaves arrayByRemovingEqualObjects] ;

    NSString* template = [[NSUserDefaults standardUserDefaults] stringForKey:constKeyTextCopyTemplate];

    NSMutableString* string = [NSMutableString new];
    NSInteger n = 0;
    for (Stark* stark in leavesI) {
        [string appendString:[stark textSummaryWithTemplate:template]];
        n++;
        if (n < leavesI.count) {
            [string appendString:@"\n"];
        }
    }

    NSString* answer = [string copy];
    [string release];
    [answer autorelease];
    return answer;
}

- (NSArray*)chopAtSeparators {
	NSMutableArray* pieces = [[NSMutableArray alloc] init] ;
	NSMutableArray* piece = nil ;
	for (id element in self) {
		if ([element sharypeValue] == SharypeSeparator) {
			// End of current piece.  Add it to pieces and then destroy it.
			if (piece) {
				// add the current piece
				[pieces addObject:piece] ;
			} 
			[piece release] ; // release the current division of bookmarks
			piece = nil ;
			
			// Add the separator
			[pieces addObject:element] ;
		}
		else {
			// element must be a bookmark or a (sub)folder, continue
			if (piece) {
				// A piece is now in progress, already started
				[piece addObject:element] ;				
			}
			else {
				// Must start a new piece
				piece = [[NSMutableArray alloc] initWithObjects:element, nil] ;
			}
		}
	}
	
	// Add the last piece (I assume, reading this code later)
	if (piece) {
		[pieces addObject:piece] ;
		[piece release] ;
	}
	
	NSArray* answer = [pieces copy] ;
	[pieces release] ;
	return [answer autorelease] ;
}


@end
