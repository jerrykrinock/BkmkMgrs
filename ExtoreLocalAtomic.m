#import "ExtoreLocalAtomic.h"
#import "OperationExport.h"
#import "NSError+InfoAccess.h"
#import "Client.h"
#import "NSString+BkmxDisplayNames.h"
#import "NSError+MyDomain.h"

@implementation ExtoreLocalAtomic

- (BOOL)processExportChangesForOperation:(SSYOperation*)operation
                                 error_p:(NSError**)error_p {
    return YES;
}

- (NSData*)extoreDataFromTree {
	NSLog(@"Internal Error 828-9783.  Forgot to override %s?", __PRETTY_FUNCTION__) ;
	return nil ;
}

- (NSDictionary*)extoreTreeError_p:(NSError**)error_p {
	NSLog(@"Internal Error 828-2358.  Forgot to override %s?", __PRETTY_FUNCTION__) ;
	return nil ;
}

- (void)writeUsingStyle1InOperation:(SSYOperation*)operation {
    BOOL ok;
    NSError* error = nil ;
	ok = [self processExportChangesForOperation:operation
                                        error_p:&error] ;
    NSData* data = nil;
    NSString* path = nil;
    if (ok) {
        data = [self extoreDataFromTree] ;
        path = [self workingFilePathError_p:&error] ;
        ok = (path != nil) ;
    }
    if (ok) {
		ok = [self writeData:data
                      toFile:path] ;
	}
	if (error) {
		[self setError:error] ;
	}
	
	[operation writeAndDeleteDidSucceed:ok] ;
}

- (void)readExternalStyle1ForPolarity:(BkmxIxportPolarity)polarity
                    completionHandler:(void(^)(void))completionHandler {
	[self setError:nil] ;
	
	NSError* error = nil ;
	NSDictionary* treeIn = [self extoreTreeError_p:&error] ;
	if (!treeIn) {
		[self setError:error] ;
		goto end ;
	}
    
	if (treeIn)	{
		if (![self makeStarksFromExtoreTree:treeIn
                                    error_p:&error]) {
			error = [SSYMakeError(59750, @"Could not decode bookmarks file.  Corrupt bookmarks?") errorByAddingUnderlyingError:error] ;
		}
	}
    
end:;
	if (error) {
		NSError* error1 = SSYMakeError(constBkmxErrorCouldNotAccessBookmarksData, @"Error reading bookmarks file") ;
		error1 = [error1 errorByAddingUnderlyingError:error] ;
		error1 = [error1 errorByAddingUserInfoObject:[self clientoid]
                                              forKey:@"Clientoid"] ;
		error1 = [error1 errorByAddingUserInfoObject:[self filePathError_p:NULL]
											  forKey:@"filePath"] ;
		NSString* path = [self workingFilePathError_p:NULL] ;
		if (path) {
			NSString* msg = [NSString stringWithFormat:
							 @"* Launch or activate %@.\n"
							 @"* Show All Bookmarks or Edit Bookmarks.\n"
							 @"* Add, move or rename any bookmark.\n"
							 @"* Quit %@.\n"
							 @"* Retry the failed operation.",
							 [[[self clientoid] exformat] exformatDisplayName],
							 [[[self clientoid] exformat] exformatDisplayName]] ;
			error1 = [error1 errorByAddingLocalizedRecoverySuggestion:msg] ;
		}
		
        [self processFileReadingError:error1];
	}
	
	completionHandler();
}

- (void)processFileReadingError:(NSError*)error {
    self.error = error;
}

- (NSArray*)extoreRootsForExport {
	NSLog(@"Internal Error 615-0567.  No override of -extoreRootsForExport") ;
	return nil ;
}

@end
