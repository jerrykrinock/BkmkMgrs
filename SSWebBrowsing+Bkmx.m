#import "SSWebBrowsing+Bkmx.h"
#import "Clientoid.h"
#import "Extore.h"
#import "BkmxAppDel+Capabilities.h"
#import "BkmxBasis.h"

@implementation SSWebBrowsing (Bkmx)

+ (void)getFromBundleIdentifier:(NSString*)bundleIdentifier
				  extoreClass_p:(Class*)extoreClass_p
					 exformat_p:(NSString**)exformat_p {
	/* Prior to BookMacster 1.13.6, I iterated through clientoids obtained by…
     NSArray* candidateClientoids = [Clientoid allClientoidsForLocalAppsThisUserByPopularity:YES includeUninitialized:YES includeNonClientable:N/A] ;
	 That was causing the app to take 250 msec to activate.  Call stack was:
     * ExtoreChromy.m +[ExtoreChromy profileNames]
     * ExtoreChromy.m +[ExtoreChromy profileDicForHomePath:timeout:]
     * ExtoreChromy.m +[ExtoreChromy infoCacheForHomePath:]
     * ExtoreChromy.m +[ExtoreChromy profileNames]
     * Clientoid.m +[Clientoid allClientoidsForLocalAppsThisUserByPopularity:::]
     Now I also reorganized those methods in ExtoreChromy to not take so long,
     but decided to improve this anyhow.  Iterating through
     supportedLocalAppExformatsIncludeNonClientable: makes more sense since
     we're not getting extra information (profiles) which we don't need. */
    Class extoreClass = NULL ;
	NSString* exformat = nil ;
	for (NSString* anExformat in [[BkmxBasis sharedBasis] supportedLocalAppExformatsIncludeNonClientable:YES]) {
        extoreClass = [Extore extoreClassForExformat:anExformat] ;
        for (NSString* aBundleIdentifier in [extoreClass browserBundleIdentifiers]) {
            if ([bundleIdentifier isEqualToString:aBundleIdentifier]) {
                exformat = anExformat ;
                break ;
            }
        }
        
        if (exformat) {
            break ;
        }
		
		// In case this is the last anExformat and we are
		// about to exit this loop…
		extoreClass = NULL ;
	}	

	if (extoreClass_p) {
		*extoreClass_p = extoreClass ;
	}
	if (exformat_p) {
		*exformat_p = exformat ;
	}
}

+ (void)getActiveBrowserExtoreClass:(Class*)extoreClass_p
						 exformat_p:(NSString**)exformat_p
				 bundleIdentifier_p:(NSString**)bundleIdentifier_p
							 path_p:(NSString**)path_p {
	NSRunningApplication* frontmostApp = [[NSWorkspace sharedWorkspace] frontmostApplication] ;
	NSString* activeBundleIdentifier = frontmostApp.bundleIdentifier ;
	NSString* activePath = frontmostApp.bundleURL.path ;
	
	Class extoreClass = NULL ;
	NSString* exformat = nil ;
	
	[self getFromBundleIdentifier:activeBundleIdentifier
					extoreClass_p:&extoreClass
					   exformat_p:&exformat] ;
	
	if (extoreClass_p) {
		*extoreClass_p = extoreClass ;
	}
	if (exformat_p) {
		*exformat_p = exformat ;
	}
	if (bundleIdentifier_p) {
		*bundleIdentifier_p = exformat ? activeBundleIdentifier : nil ;
	}
	if (path_p) {
		*path_p = exformat ? activePath : nil ;
	}
}

@end
