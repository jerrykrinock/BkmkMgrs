#import "NSString+MorePaths.h"


@implementation NSString (BookmarkPaths)

- (NSString*)omniWebFileFullPathContainedInDirectoryPath {
	NSArray* directoryContents = [self directoryContents] ;
	NSString* omniWebFilename = nil ;
	NSString* candidate = @"Favorites.html" ;
	if ([directoryContents containsObject:candidate]) {
		omniWebFilename = candidate ;
		goto end ;
	}
	candidate = @"Bookmarks.html" ;
	if ([directoryContents containsObject:candidate]) {
		omniWebFilename = candidate ;
		goto end ;
	}
	candidate = @"Published.html" ;
	if ([directoryContents containsObject:candidate]) {
		omniWebFilename = candidate ;
		goto end ;
	}
	
end:;
	NSString* answer = nil ;
	if (omniWebFilename != nil) {
		answer = [self stringByAppendingPathComponent:omniWebFilename] ;
	}
	
	return answer ;
}

@end
