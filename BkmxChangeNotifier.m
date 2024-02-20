#import "BkmxChangeNotifier.h"
#import "BkmxGlobals.h"
#import "Stager.h"
#import "NSString+SSYDotSuffix.h"
#import "Extore.h"

#if MAC_OS_X_VERSION_MAX_ALLOWED < 1070
#define NO_ARC 1
#else
#if __has_feature(objc_arc)
#define NO_ARC 0
#else
#define NO_ARC 1
#endif
#endif

@interface BkmxChangeNotifier ()

@property (nonatomic, copy) NSString* extoreName ;
@property (readonly, retain) NSMutableString* jsonBuffer ;

@end



@implementation BkmxChangeNotifier

@synthesize extoreName = m_extoreName ;
@synthesize jsonBuffer = m_jsonBuffer ;
@synthesize muted = m_muted ;

- (id)initWithExtoreName:(NSString*)extoreName {
	self = [super init] ;
	if (self) {
		[self setExtoreName:extoreName] ;
		// Begin JSON array
		[[self jsonBuffer] setString:@"[\n"] ;
	}
	else {
#if !__has_feature(objc_arc)
		// See http://lists.apple.com/archives/Objc-language/2008/Sep/msg00133.html ...
		[super dealloc] ;
#endif
		self = nil ;
	}
	
	return self ;
}

#if !__has_feature(objc_arc)
- (void)dealloc {
	[m_extoreName release] ;
	[m_jsonBuffer release] ;
	
	[super dealloc] ;
}
#endif

- (NSMutableString*)jsonBuffer {
	if (!m_jsonBuffer) {
		m_jsonBuffer = [[NSMutableString alloc] init] ;
	}
	
	return m_jsonBuffer ;
}

- (void)fireTimer:(NSTimer*)timer {
	// Re-arm
	m_timer = nil ;
	
	// Construct base path
	NSString* profileName = [timer userInfo] ;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(
														 NSApplicationSupportDirectory,  
														 NSUserDomainMask,
														 YES
														 ) ;
	NSString* appSupportPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil ;
	// Append "/BookMacster"
	appSupportPath = [appSupportPath stringByAppendingPathComponent:@"BookMacster"] ;

	BOOL ok ;
	NSError* error = nil ;
	NSString* path ;
	
	// Close out the JSON array
	if ([[self jsonBuffer] hasSuffix:@",\n"]) {
		[[self jsonBuffer] deleteCharactersInRange:NSMakeRange(([[self jsonBuffer] length] - 2), 1)] ;
	}
	[[self jsonBuffer] appendString:@"]"] ;
	
	path = [appSupportPath stringByAppendingPathComponent:@"Changes"] ;
	path = [path stringByAppendingPathComponent:@"Detected"] ;
    NSString* extoreBaseName = [Extore baseNameFromClassName:[self extoreName]];
	if (extoreBaseName) {
        path = [path stringByAppendingPathComponent:extoreBaseName] ;
		// Append ".profilename"
		if (profileName) {
            path = [path stringByAppendingDotSuffix:profileName] ;
		}
		
		/* The `path` we have so far constructed is a directory, so it should
         end in a slash.  Actually, it must end in a slash for the following
         comparison to work because the paths which are the subjects of
         the watches end in a slash, because the slash is necessary for the
         kqueue registration. */
        path = [path stringByAppendingString:@"/"];

        /* To be economical, we only write the Change file if one of our apps
         is watching for changes. */
		if ([Stager anyAppIsWatchingPath:path]) {
			// Ensure existence of "Changes/Extore.profile" directory
			ok = [[NSFileManager defaultManager] createDirectoryAtPath:path
										   withIntermediateDirectories:YES
															attributes:nil
																 error:&error] ;
			if (!ok) {
				NSLog(@"Error 513-9272 : %@", error) ;
			}
			
			// Write changes file
			NSString* timeString = [NSString stringWithFormat:
									@"%09ld",
									(long)floor([NSDate timeIntervalSinceReferenceDate])] ;
			NSString* filename = [timeString stringByAppendingPathExtension:@"json"] ;
			path = [path stringByAppendingPathComponent:filename] ;
			ok = [[self jsonBuffer] writeToFile:path
									 atomically:YES
									   encoding:NSUTF8StringEncoding
										  error:&error] ;
			if (!ok) {
				NSLog(@"Error 513-9273 : %@", error) ;
			}
		}
	}
	
	// Clear the buffer, start new JSON array
	[[self jsonBuffer] setString:@"[\n"] ;
}

- (void)handleRawChange:(NSString*)jsonString
				profile:(NSString*)profileName {
	if ([self muted]) {
		return ;
	}
	
	if (jsonString) {
		NSString* newLine = [[NSString alloc] initWithFormat:
							 @"%@,\n",
							 jsonString] ;
		// For some stupid reason, Firefox seems to give me every 
		// change twice.  So we check for that before appending
		if (![[self jsonBuffer] hasSuffix:newLine]) {
			[[self jsonBuffer] appendString:newLine] ;
		}
#if !__has_feature(objc_arc)
		[newLine release] ;
#endif
	}
	
	// Note that we don't need one timer for each profile, because the user
	// will only run profile at a time.  Sigh!
	if (m_timer) {
		// Firing to write a new file is already scheduled
		return ;
	}
	
	// Note that constKeyBookmarksChangeDelay1 is not the big delay during which we should
	// defer BkmxAgent actions to coalesce groups of bookmarks changes; it's a short delay
	// whose purpose is to filter out the noise that you get from the ripples of
	// an individual change (deletion causes parent to be changed, siblings
	// to be displaced, etc.)
	
	NSNumber* laziness = [[NSUserDefaults standardUserDefaults] objectForKey:constKeyBookmarksChangeDelay1] ;

    NSTimeInterval delay ;
	// Use defensive programming whenever getting values from user defaults
	if ([laziness respondsToSelector:@selector(doubleValue)]) {
		delay = [laziness doubleValue] ;
	}
	else {
		delay = 10.0 ;
	}

	m_timer = [NSTimer scheduledTimerWithTimeInterval:delay
											   target:self
											 selector:@selector(fireTimer:)
											 userInfo:profileName
											  repeats:NO] ;
	// A timer retains itself while it is valid (timing), so no -retain here
}

@end
