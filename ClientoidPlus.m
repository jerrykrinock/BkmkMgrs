#import "ClientoidPlus.h"
#import "Clientoid.h"
#import "BkmxBasis.h"

@implementation ClientoidPlus

@synthesize clientoid = m_clientoid ;
@synthesize doImport = m_doImport ;
@synthesize doExport = m_doExport ;
@synthesize index = m_index ;

- (id)init {
	self = [super init] ;
	if (self) {
		[self setDoImport:YES] ;
		[self setDoExport:YES] ;
		[self setIndex:NSNotFound] ;
	}
	
	return self ;
}

- (void)dealloc {
	[m_clientoid release] ;
	
	[super dealloc] ;
}

+ (NSArray*)availableClientableClientoidsPlus {
	NSMutableArray* clientoidsPlus = [[NSMutableArray alloc] init] ;
    
    /*
     For BookMacster, because the list of candidate clients
     can be so long, we do *not* include those which the user
     has not initialized.  For Synkmark, because there are
     only 3, we *do* include all 3, whether initialized or not
     */
    BOOL includeUninitialized = ([[BkmxBasis sharedBasis] iAm] == BkmxWhich1AppBookMacster) ;
    
	for (Clientoid* clientoid in [Clientoid availableClientoidsIncludeUninitialized:includeUninitialized
                                                               includeNonClientable:NO]) {
		ClientoidPlus* clientoidPlus = [[ClientoidPlus alloc] init] ;
		[clientoidsPlus addObject:clientoidPlus] ;
		[clientoidPlus setClientoid:clientoid] ;
		[clientoidPlus release] ;
	}
	
	NSArray* answer = [NSArray arrayWithArray:clientoidsPlus] ;
	[clientoidsPlus release] ;
	
	return answer ;
}

- (NSString*)displayName {
	return [[self clientoid] displayName] ;
}

- (NSString*)description {
	return [NSString stringWithFormat:
			@"<Clientoid+ %p> im=%ld ex=%ld for %@",
			self,
			(long)[self doImport],
			(long)[self doExport],
			[self clientoid]] ;
}

@end
