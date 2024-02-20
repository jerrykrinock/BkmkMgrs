#import "BkmxDoc+Autosaving.h"
#import "NSUserDefaults+KeyPaths.h"

@implementation BkmxDoc (Autosaving)

// Autosave Utility method

/*!
 @brief    Returns a key path array which may be used to access an
 autosaved value relative to the receiver's document in user defaults.
 
 @details  The answer is the array {constKeyDocAutosaves, [document uuid],
 appendage}, where appendage is derived from the lastKeys parameter.
 @param    lastKeys  If lastKeys is a string, appendage is this single
 object.  If lastKeys is an array, appends the array as multiple
 objects.
 */
- (NSArray*)autosaveKeyPathArrayWithLastKeys:(id)lastKeys {
	NSString* uuid = [self uuid] ;
	NSArray* kpa = nil ;
	if (uuid) {
		kpa = [NSArray arrayWithObjects:
			   constKeyDocAutosaves,
			   uuid,
			   nil] ;
		if ([lastKeys respondsToSelector:@selector(objectAtIndex:)]) {
			// lastKeys is an array
			kpa = [kpa arrayByAddingObjectsFromArray:lastKeys] ;
		}
		else {
			// lastKeys is a string
			kpa = [kpa arrayByAddingObject:lastKeys] ;
		}
	}
	
	return kpa ;
}

- (NSArray*)autosavedRecentLandings {
	NSArray* keyPathArray = [self autosaveKeyPathArrayWithLastKeys:constAutosaveRecentLandings] ;
	NSArray* answer = nil ;
	if (keyPathArray) {
		answer = [[NSUserDefaults standardUserDefaults] valueForKeyPathArray:keyPathArray] ;
	}
	
	// Check in case of corrupt prefs
	if (answer && ![answer isKindOfClass:[NSArray class]]) {
		NSLog(@"Warning 697-1357 Ignoring corrupt Recent Landings pref: %@", answer) ;
		answer = nil ;
	}
	
	return answer ;
}

- (void)autosaveRecentLandings:(NSArray*)recentLandings {
	NSArray* keyPathArray = [self autosaveKeyPathArrayWithLastKeys:constAutosaveRecentLandings] ;
	if (keyPathArray) {
		[[NSUserDefaults standardUserDefaults] setValue:recentLandings
										forKeyPathArray:keyPathArray] ;
        // Added the following in BookMacster 1.12 because user Gregory
        // Ventana (MrX on forum) reported is losing recent landings.
        [[NSUserDefaults standardUserDefaults] synchronize] ;
	}
}

@end
