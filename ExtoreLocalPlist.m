#import "ExtoreLocalPlist.h"
NSString* const constKeyPlistExformat = @"plistFormat" ; 
NSString* const constKeyProxyCollections = @"proxyCollections" ;
NSString* const constKeyRootAttributes = @"rootAttributes" ;


@implementation ExtoreLocalPlist

- (SEL)reformatStarkToExtore {
	NSLog(@"Internal Error 828-2815.  Forgot to override reformatStarkToExtore?") ;
	return NULL ;
}

- (NSData*)extoreDataFromTree {
	// Now, we assemble a root "from scratch"
	NSMutableDictionary* browserRoot = [[NSMutableDictionary alloc] init] ;
	[browserRoot addEntriesFromDictionary:[[self fileProperties] objectForKey:constKeyRootAttributes]] ;
	// Fortunately, Safari, iCab and Camino all use the same key, "Children".
	[browserRoot setObject:[self extoreRootsForExport]
					forKey:@"Children"] ;
	
	// and serialize it into an NSData property list
    NSData* browserData = [NSPropertyListSerialization dataWithPropertyList:browserRoot
                                                                     format:[[[self fileProperties] objectForKey:constKeyPlistExformat] integerValue]
                                                                    options:0
                                                                      error:NULL] ;
	[browserRoot release] ;
	return browserData ;
}

- (NSDictionary*)extoreTreeError_p:(NSError**)error_p {
	NSError* error = nil ;
	NSMutableDictionary* treeIn = nil ;
	NSData* dataIn = nil ;
	
	NSString* path = [self workingFilePathError_p:&error] ;
	if (!path) {
		goto end ;
	}
	else {
		dataIn = [NSData dataWithContentsOfFile:path
										options:0
										  error:&error] ;
	}
	
	if (dataIn) {
		NSPropertyListFormat plistFormat ;
        treeIn = [NSPropertyListSerialization propertyListWithData:dataIn
                                                           options:NSPropertyListImmutable
                                                            format:&plistFormat
                                                             error:&error] ;
        [[self fileProperties] setObject:[NSNumber numberWithInteger:plistFormat] forKey:constKeyPlistExformat] ;
	}
	
end:;
	if (error && error_p) {
		*error_p = error ;
	}
	
	return treeIn ;	
}


+ (BOOL)canProbablyImportFileType:type
                             data:data {
	if (![type isEqualToString:@"plist"]) {
		return NO ;
	}
    if (!data) {
        return NO ;
    }
	
    NSDictionary* root = [NSPropertyListSerialization propertyListWithData:data
                                                                   options:NSPropertyListImmutable
                                                                    format:NULL
                                                                     error:NULL] ;
	if ([root objectForKey:[self constants_p]->telltaleString]) {
		return YES ;
	}
	
	return NO ;
}

@end
