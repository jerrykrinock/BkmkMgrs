#import "Stark+Sorting.h"

@implementation NSArray (Starks) 

- (NSArray*)arrayOfStarksByPromotingChildrenOfImmoveableContainers {
	NSMutableArray* orphanedItems = [[NSMutableArray alloc] init] ;
	for (Stark* item in self) {
		NSMutableArray* immoveableContainers = [[NSMutableArray alloc] initWithCapacity:4] ;
		
		[item classifyBySharypeDeeply:YES
							 hartainers:immoveableContainers
						  softFolders:nil
							   leaves:nil
							  notches:nil] ;
		if ([immoveableContainers count] > 0) {
			for (Stark* immoveableContainer in immoveableContainers) {
				// Add the immoveableContainer's children as orphaned items
				[orphanedItems addObjectsFromArray:[immoveableContainer childrenOrdered]] ;
			}
		}
		
		[immoveableContainers release] ;
	}
	
	NSArray* newArray ;
	if ([orphanedItems count] > 0) {
		newArray = [self arrayByAddingObjectsFromArray:orphanedItems] ;
	}
	else {
		newArray = self ;
	}
	
	[orphanedItems release] ;
	
	return newArray ;			
}

- (BOOL)canMoveAnyMemberDescendant {
	BOOL answer = NO ;
	for (Stark* item in self) {
		NSMutableArray* moveableItems = [[NSMutableArray alloc] init] ;
		
		[item classifyBySharypeDeeply:YES
							 hartainers:nil
						  softFolders:moveableItems
							   leaves:moveableItems
							  notches:moveableItems] ;
		if ([moveableItems count] > 0) {
			[moveableItems release] ;	
			answer = YES ;
			break ;
		}

		[moveableItems release] ;	
	}
		
	return answer ;			
}

@end

