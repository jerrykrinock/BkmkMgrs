#import "ExtoreChromy.h"
#import "Stark.h"
#import "SSYTreeTransformer.h"
#import "NSString+LocalizeSSY.h"
#import "Starker.h"
#import "Client.h"
#import "Client+SpecialOptions.h"
#import "BkmxBasis.h"
#import "BkmxBasis+Strings.h"
#import "SSYUuid.h"
#import "NSDate+Microsoft1601Epoch.h"
#import "NSDictionary+SSYJsonFile.h"
#import "NSError+SSYAdds.h"
#import "NSDictionary+SimpleMutations.h"
#import "Stark+Attributability.h"
#import "NSAppleScript+ThreadSafe.h"
#import "NSDictionary+BSJSONAdditions.h"
#import "NSInvocation+Quick.h"
#import "NSDictionary+KeyPaths.h"
#import "NSString+SSYExtraUtils.h"
#import "NSDictionary+KeyPaths.h"
#import "SSYMH.AppAnchors.h"
#import "NSObject+DeepCopy.h"
#import "NSDictionary+BSJSONAdditions.h"
#import "SSYShellTasker.h"
#import "NSData+MBBase64.h"
#import "NSArray+SSYMutations.h"
#import "NSFileManager+SomeMore.h"
#import "SSYOtherApper.h"
#import "NSString+MorePaths.h"
#import "SSYInterappClient.h"
#import "SSYSqliter.h"

static NSMutableDictionary* static_displayProfileNames = nil ;
static NSTimeInterval static_displayProfileNamesLastUpdated = 0.0 ;

NSString* const constChromeExtensionUuid = @"gielihnpdhkbdcnlcdnpnkidbomiccip" ;
// I think I remember generating the above number using a uuid generator
// But now I can't find how it gets compiled into my Chrome extension.
// Maybe crxmake.sh generates it from the key in SheepSystemsChromeExtension.pem.

NSString* const constKeyBrowserAction = @"browser_action" ;

/*
 Note 190351.  Chrome supports lastModifiedDate for folders only, although for most
 folders this value is 0, and I don't know what triggers it to get set to the
 current date.  Now one would think that setting canEditLastModifiedDate in
 the extore constants to YES would cause changes to be written to the Sync Logs on
 round trip Import-Exports (churning), because, during Export, all starks will have
 a value from BookMacster, but the corresponding bookmark read from the Chrome
 bookmarks file will be nil.  However that doesn't happen because lastModifiedDate
 is a trivial attribute.  See -[Bkmslf objectWillChangeNote:].
 
 So, until BookMacster 1.11, I set canEditLastModifiedDate in the extore
 constants to YES because it did not cause churn during round trips, and I thought
 it would be good to have if Google ever fixed Chrome to support this attribute
 the way it may have been intended.  But in BookMacster 1.11, I noticed that it
 was causing a different kind of churn.  Say that we have two Agents, one watching
 for changes in Chrome and the other watching the .bkmslf file for changes from
 another Mac via Dropbox.  Also say that Chrome is a client and is running.
 • Change the file on the remote Mac.
 • Changes are exported to Chrome on this Mac.
 • Changes detected in Chrome.
 • BookMacster imports from Chrome.
 • BookMacster sees no changes in Chrome (because lastModifiedDate is trivial)
     and therefore does not export to Chrome.  Good, but…
 • When saving, NSPersistenDocument will see this as a change and save, which
 • Causes the change to propagate back through Dropbox which
 • Causes the remote Mac to waste time reading in the .bkmslf file.  No
     exportable changes will be found.  It's just a waste of resources.
 • Incidentally, when -[Bkmslf doHousekeepingBeforeSaveSaveAs:] runs, it invokes
     -[Starker finalizeStarkUpdates], which invokes -[Stark finalizeUpdates]
     on each stark, which doesn't filter or trivial attributes because it needs
     to save if there are *any* changes*.  So it will also add such stark to
     the total of 'updated' starks in the string it sends to -logMessage:
 So, in BookMacster 1.11 I made lastModifiedDate an owner value.
 
 Note 190352  In BookMacster 1.11, when importing from or exporting to Chromium
 or Google Chrome, the bookmark attribute and addDate is no longer mapped into the
 corresponding fields in BookMacster.  Instead, this attribute is passed in an
 opaque manner, and only emerge when Chromium or Google Chrome.  (We did this
 because the Chrome/Chromium API does not allow us to update *Date Added*, but
 instead updates it uncontrollably whenever we merely change any other attribute.
 Properly handling these two quirks would require complexity which is obviously
 unwarranted.)
 */

NSString* const constFilenameChromePreferences = @"Preferences" ;
NSString* const constKeyProfile = @"profile" ;
NSString* const constKeyLastUsed = @"last_used" ;
NSString* const constKeyLastActiveProfiles = @"last_active_profiles" ;
NSString* const constKeyState = @"state" ;

@implementation ExtoreChromy

- (NSString*)pluginName {
	return @"SheepSystemsNPAPIPlugin" ;
}

- (NSTimeInterval)quitHoldTime {
    return 10.0 ;
}

/*
 The returned string constant in this method generates a warning, 
 "Input conversion stopped due to an input byte that does not belong to the input codeset UTF-8",
 which seems to be due to any of the code points \x80 and above.
 This warning happens only when compiling for ppc (PowerPC) (on LLVM 1.6)
 But then I found that I don't ewven nee the metbod.
 // When normalizing URLs, decode only the following
 // HTML entities in the 'path' portion:
 (hexadecimal):
 2d, 2e (- and .)
 30-39 (decimal digits)
 41-5A (uppercase Roman letters)
 5F (_)
 61-7A (lowercase Roman letters)
 7E (~)
-(NSString*)leaveEscapedInPath {	
	// The following string contains all 1-byte characters except those noted above
	return @"\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0A\x0B\x0C\x0D\x0E\x0F\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1A\x1B\x1C\x1D\x1E\x1F\x20\x21\x22\x23\x24\x25\x26\x27\x28\x29\x2A\x2B\x2C\x2F\x3A\x3B\x3C\x3D\x3E\x3F\x40\x5B\x5C\x5D\x5E\x60\x7B\x7C\x7D\x7F\x80\x81\x82\x83\x84\x85\x86\x87\x88\x89\x8A\x8B\x8C\x8D\x8E\x8F\x90\x91\x92\x93\x94\x95\x96\x97\x98\x99\x9A\x9B\x9C\x9D\x9E\x9F\xA0\xA1\xA2\xA3\xA4\xA5\xA6\xA7\xA8\xA9\xAA\xAB\xAC\xAD\xAE\xAF\xB0\xB1\xB2\xB3\xB4\xB5\xB6\xB7\xB8\xB9\xBA\xBB\xBC\xBD\xBE\xBF\xC0\xC1\xC2\xC3\xC4\xC5\xC6\xC7\xC8\xC9\xCA\xCB\xCC\xCD\xCE\xCF\xD0\xD1\xD2\xD3\xD4\xD5\xD6\xD7\xD8\xD9\xDA\xDB\xDC\xDD\xDE\xDF\xE0\xE1\xE2\xE3\xE4\xE5\xE6\xE7\xE8\xE9\xEA\xEB\xEC\xED\xEE\xEF\xF0\xF1\xF2\xF3\xF4\xF5\xF6\xF7\xF8\xF9\xFA\xFB\xFC\xFD\xFE\xFF" ;
}
*/

/* Note that the Extore base class implementation does not
 work for this, because the actual class name is going to
 be either "ExtoreChrome" or "ExtoreChromium". */
+ (NSString*)specialNibName {
	return @"SpecialChromy" ;						
}

+ (BOOL)canDetectOurChanges {
	return YES ;
}

+ (BOOL)addonAvailable {
	return YES ;
}

+ (BkmxIxportTolerance)toleranceForIxportStyle:(NSInteger)ixportStyle {
	BkmxIxportTolerance tolerance = BkmxIxportToleranceAllowsNone ;
	if (ixportStyle == 2) {
		tolerance = BkmxIxportToleranceAllowsReading + BkmxIxportToleranceAllowsWriting ;
	}
	
	return tolerance ;
}

+ (BkmxGrabPageIdiom)peekPageIdiom {
	return BkmxGrabPageIdiomAppleScript ;
}

+ (BOOL)addonSupportsPurpose:(NSInteger)purpose {
	return YES ;
}

+ (PathRelativeTo)fileParentPathRelativeTo {
	return PathRelativeToProfile ;
}

+ (NSString*)browserSupportPathForHomePath:(NSString*)homePath {
    if (!homePath) {
        // Default to the current user's Mac account
        homePath = NSHomeDirectory() ;
    }
    NSString* appSupportRelativePath = [self constants_p]->appSupportRelativePath ;
	return [[NSString applicationSupportPathForHomePath:homePath] stringByAppendingPathComponent:appSupportRelativePath] ;
}

+ (NSString*)localStateFilePathForHomePath:(NSString*)homePath {
	return [[self browserSupportPathForHomePath:homePath] stringByAppendingPathComponent:@"Local State"] ;
}

+ (NSDictionary*)localStateDicOnceForHomePath:(NSString*)homePath {
    NSString* path = [self localStateFilePathForHomePath:homePath] ;
    NSString* string = [[NSString alloc] initWithContentsOfFile:path
                                                   usedEncoding:NULL
                                                          error:NULL] ;
    NSDictionary* answer = nil ;
    if (string) {
        answer = [NSDictionary dictionaryWithJSONString:string
                                             accurately:NO] ;
        if (![answer isKindOfClass:[NSDictionary class]]) {
            answer = nil ;
        }
    }
    [string release] ;
    
    return answer ;
}

+ (NSDictionary*)profileDicOnceForHomePath:(NSString*)homePath {
    NSDictionary* localStateDic = [self localStateDicOnceForHomePath:homePath] ;
    NSDictionary* answer = [localStateDic objectForKey:constKeyProfile] ;
    if (![answer isKindOfClass:[NSDictionary class]]) {
        answer = nil ;
    }
    
    return answer ;
}

+ (NSDictionary *)profileDicForHomePath:(NSString *)homePath
                                timeout:(NSTimeInterval)timeout {
    // At one time, I saw that profileDic was nil here.  I suppose that is
    // possible, if Chrome had just been launched for the first time and had
    // not created a profileDic first.  So I put this in a loop to keep
    // trying.
    NSDate* startDate = [NSDate date] ;
    NSDictionary* profileDic = nil ;
    while (!profileDic) {
        profileDic = [[self class] profileDicOnceForHomePath:homePath] ;
        NSTimeInterval elapsed = 0.0 ;
        if (profileDic) {
            break ;
        }

        usleep(250000) ;
        elapsed = -[startDate timeIntervalSinceNow] ;
        if (elapsed > timeout) {
            break ;
        }
    }
    
    return profileDic ;
}

+ (NSDictionary*)infoCacheForHomePath:(NSString*)homePath {
	NSDictionary* profileDic = [self profileDicForHomePath:homePath
                                                   timeout:0.0] ;
    NSDictionary* infoCache = [profileDic objectForKey:@"info_cache"] ;
    if (![infoCache respondsToSelector:@selector(allKeys)]) {
        infoCache = nil ;
    }
    return infoCache ;
}

+ (NSArray*)profileNamesForHomePath:(NSString*)homePath {
    NSArray* names ;
    NSDictionary* infoCache = [self infoCacheForHomePath:homePath] ;
    if (infoCache) {
        names = [infoCache allKeys] ;
    }
    else {
        names = [NSArray array] ;
    }
    
	return names ;
}

#define DISPLAY_PROFILE_NAMES_SHELF_LIFE_SECONDS 10.0
/* displayProfileNames is performance optimization added in BookMacster 1.13.4,
 so that, if the 'Clients' column is displayed in Content View, we don't need
 to access the disk with each bookmark displayed in the Content Outline, as in
 this call stack fragment…
    -[NSTableView _dirtyVisibleCellsForKeyStateChange]
       -[NSOutlineView preparedCellAtColumn:row:]
          -[NSTableView preparedCellAtColumn:row:]
           -[ContentDataSource outlineView:objectValueForTableColumn:byItem:]
             -[Stark clients]
               -[Clientoid displayName]
                 -[Clientoid displayNameWithProfile:]
                   -[Clientoid profileNameAsDisplayedSuffix]
                     +[ExtoreChromy displayNameForProfileName:homePath:]
 The tradeoff is that, in the once-in-a-lifetime event when user changes
 the display name for a user profile in Chrome's preferences, we'll continue
 to display the old name for DISPLAY_PROFILE_NAMES_SHELF_LIFE_SECONDS seconds.
*/
+ (NSMutableDictionary*)displayProfileNames {
    NSTimeInterval age = [NSDate timeIntervalSinceReferenceDate] - static_displayProfileNamesLastUpdated ;
    if (age > DISPLAY_PROFILE_NAMES_SHELF_LIFE_SECONDS) {
        [self setDisplayProfileNames:nil] ;
    }
    
    return static_displayProfileNames ;
}

+ (void)setDisplayProfileNames:(NSMutableDictionary*)displayProfileNames {
    [static_displayProfileNames release] ;
    [displayProfileNames retain] ;
    static_displayProfileNames = displayProfileNames ;
    static_displayProfileNamesLastUpdated = [NSDate timeIntervalSinceReferenceDate] ;
}

+ (NSString*)displayNameForProfileName:(NSString*)profileName
                              homePath:(NSString*)homePath {
    if (!profileName) {
        // Client was created prior to BookMacster 1.13.2.
        // This is probably defensive programming now that we have
        // -[Bkmslf upgradePriorTo1_13_3]
        profileName = [self constants_p]->defaultProfileName ;
    }
    
    NSMutableDictionary* topDic = [self displayProfileNames] ;
    if (!topDic) {
        topDic = [NSMutableDictionary dictionaryWithCapacity:2] ;
        [self setDisplayProfileNames:topDic] ;
    }
    NSMutableDictionary* thisHomeDic = [topDic objectForKey:homePath] ;
    if (!thisHomeDic) {
        thisHomeDic = [NSMutableDictionary dictionaryWithCapacity:4] ;
        [topDic setObject:thisHomeDic
                   forKey:homePath] ;
    }
    NSString* displayName = [thisHomeDic objectForKey:profileName] ;
    if (!displayName) {
        NSDictionary* infoCache = [self infoCacheForHomePath:homePath] ; // Accesses disk
        if ([infoCache count] > 1) {
            // User has multiple profiles
            NSDictionary* profileDic = [infoCache objectForKey:profileName] ;
            if ([profileDic respondsToSelector:@selector(objectForKey:)]) {
                displayName = [profileDic objectForKey:@"name"] ;
            }
        }
        
        if (!displayName) {
            // I'm not sure if this could ever happen.  Maybe an old version
            // of Chrome?
            displayName = @"First user" ;
        }
        
        [thisHomeDic setObject:displayName
                        forKey:profileName] ;
    }
    
    return displayName ;
}

+ (NSString*)pathForProfileName:(NSString*)profileName
                       homePath:(NSString*)homePath
                        error_p:(NSError**)error_p {
    return [[self browserSupportPathForHomePath:homePath] stringByAppendingPathComponent:profileName] ;
}

+ (void)addExidsFromArray:(NSArray*)array
					toSet:(NSMutableIndexSet*)set {
	for (NSDictionary* change in array) {
		if ([change respondsToSelector:@selector(objectForKey:)]) {  // Defensive programming because this comes from a file
			NSString* exid = [change objectForKey:@"exid"] ;
			if (exid) {  // Defensive programming because this comes from a file
				// My exids are strings, but Chrome's ids are integers,
				// We convert them here.
				[set addIndex:[exid integerValue]] ;
			}
		}
	}
}

- (NSString*)pluginsCurrentProfileError_p:(NSError**)error_p {
    NSString* profileName = nil ;
    BOOL ok ;
    NSInteger errorCode = 0 ;
    NSString* errorDescrip = nil ;
    NSError* error = nil ;
    
    char rxHeaderByte = 0 ;
    NSData* rxData ;
	ok = [SSYInterappClient sendHeaderByte:constInterappHeaderByteForProfileRequest
								 txPayload:nil
								  portName:[[self browserAddonPortName] stringByAppendingString:@".ToClient"]
									  wait:YES
							rxHeaderByte_p:&rxHeaderByte
							   rxPayload_p:&rxData
								 txTimeout:0.5
								 rxTimeout:3.0
								   error_p:&error] ;
	if (!ok) {
        errorDescrip = @"No response" ;
		errorCode = 450894 ;
	}
    
    if (ok) {
        if (rxHeaderByte != constInterappHeaderByteForProfileResponse) {
            errorDescrip = [NSString stringWithFormat:
                             @"Wrong ack '%c'",
                             rxHeaderByte] ;
            errorCode = 450895 ;
            ok = NO ;
        }
    }
    
    if (ok) {
        if (rxData == nil) {
            ok = NO ;
            errorDescrip = @"Nil data received" ;
            errorCode = 450896 ;
        }
    }
    
    if (ok) {
        if ([rxData length] == 0) {
            ok = NO ;
            errorDescrip = @"0 bytes received" ;
            errorCode = 450897 ;
        }
    }
    
    if (ok) {
        profileName = [[NSString alloc] initWithData:rxData
                                            encoding:NSUTF8StringEncoding] ;
    }
    
    if (!ok && error_p) {
        error = [SSYMakeError(errorCode, errorDescrip) errorByAddingUnderlyingError:error] ;
        error = [SSYMakeError(450890, @"Plugin failed to give its current profile") errorByAddingUnderlyingError:error] ;
        *error_p = error ;
    }
    
    return [profileName autorelease] ;
}

+ (BOOL)detectedChanges:(NSArray*)detectedChanges
  notInExportedChanges:(NSDictionary*)exportedChanges {
	NSMutableIndexSet* cutIds = [[NSMutableIndexSet alloc] init] ;
	[self addExidsFromArray:[exportedChanges objectForKey:@"cuts"]
					  toSet:cutIds] ;
	NSMutableIndexSet* putIds = [[NSMutableIndexSet alloc] init] ;
	[self addExidsFromArray:[exportedChanges objectForKey:@"puts"]
					  toSet:putIds] ;
	NSMutableIndexSet* repairIds = [[NSMutableIndexSet alloc] init] ;
	[self addExidsFromArray:[exportedChanges objectForKey:@"repairs"]
					  toSet:repairIds] ;
	
	NSString* limboExid = nil ;
	NSInteger i = 0 ;
	BOOL answer = NO ;
	NSInteger lastIndex = [detectedChanges count] ;
	for (NSDictionary* change in detectedChanges) {
		++i ;  // In case I put in more 'continue ;' statements
		
		// Defensive programming
		if (![change respondsToSelector:@selector(objectForKey:)]) {
			NSLog(@"Internal Error 194-3921 %@ %@", [change className], change) ;
			answer = YES ;
			break ;
		}

		if (i == 1) {
			// First change could be adding Limbo
			NSString* title = [change objectForKey:@"title"] ;
			if (title) {  // Most change dics do not have titles
				if ([title respondsToSelector:@selector(isEqualToString:)]) {
					if ([title isEqualToString:@"Limbo (Sheep Systems)"]) {
						limboExid = [change objectForKey:@"affectedId"] ;
						if (![limboExid respondsToSelector:@selector(isEqualToString:)]) {
							NSLog(@"Internal Error 194-0077 %@ %@", [limboExid className], limboExid) ;
							answer = YES ;
							break ;
						}
						// Ignore Limbo creation
						continue ;
					}
				}
				else {
					NSLog(@"Internal Error 194-0990 %@ %@", [title className], title) ;
					answer = YES ;
					break ;
				}
			}
		}
		else if (i == lastIndex) {
			// Last change could be removing Limbo
			// Limbo destruction will always be lastIndex, or there are no
			// changes in Chrome, because we will get a 
			// change from Chrome every 10 seconds, and no case
			// could a user export from BookMacster,
			// make a change in Chrome during the export,
			// make another change in BookMacster and then
			// export again, all in 10 seconds.
			if (limboExid) {
				NSString* exid = [change objectForKey:@"affectedId"] ;
				if ([exid respondsToSelector:@selector(isEqualToString:)]) {
					if ([exid isEqualToString:limboExid]) {
						// Ignore Limbo destruction
						continue ;
					}
				}
				else {
					NSLog(@"Internal Error 194-5660 %@ %@", [exid className], exid) ;
					answer = YES ;
					break ;
				}
			}						 
		}

		NSNumber* idObject = [change objectForKey:@"affectedId"] ;
		if ([idObject respondsToSelector:@selector(integerValue)]) {
			NSInteger affectedId = [idObject integerValue] ;
			NSString* changeType = [change objectForKey:@"changeType"] ;
			if ([changeType respondsToSelector:@selector(isEqualToString:)]) {
				if (
					[changeType isEqualToString:@"moved"] ||
					[changeType isEqualToString:@"changed"]
					) {
					if (![repairIds containsIndex:affectedId]) {
						answer = YES ;
						break ;
					}
				}
				else if (
					[changeType isEqualToString:@"created"]
					) {
					if (![putIds containsIndex:affectedId]) {
						answer = YES ;
						break ;
					}
				}
				else if (
					[changeType isEqualToString:@"removed"]
					) {
					if (![cutIds containsIndex:affectedId]) {
						answer = YES ;
						break ;
					}
				}
				else if (
					[changeType isEqualToString:@"importBegan"] ||
					[changeType isEqualToString:@"importEnded"]
					) {
					answer = YES ;
					break ;
				}
			}
			else {
				NSLog(@"Internal Error 194-0441 %@ %@", [changeType className], changeType) ;
				answer = YES ;
				break ;
			}
		}
		else {
			NSLog(@"Internal Error 194-4868 %@ %@", [idObject className], idObject) ;
			answer = YES ;
			break ;
		}
	}

	[cutIds release] ;
	[putIds release] ;
	[repairIds release] ;
	
    return answer ;
}

- (OwnerAppRunningState)ownerAppRunningStateError_p:(NSError**)error_p {
    // Invoke super
    NSError* error = nil ;
    OwnerAppRunningState ownerAppRunningState = [super ownerAppRunningStateError_p:&error] ;
    if (ownerAppRunningState == OwnerAppRunningStateError) {
        if (error_p) {
            *error_p = error ;
        }
        return OwnerAppRunningStateError ;
    }
    if (ownerAppRunningState == OwnerAppRunningStateNotRunning) {
        return ownerAppRunningState ;
    }
    
    NSString* pluginCurrentProfile = [self pluginsCurrentProfileError_p:&error] ;
    if (!pluginCurrentProfile) {
        // This error is expected during extension installation, when invoked
        // from -[Extore insquillIfNeededForOperation:] and then again from
        // -[Extore addonMayInstall:error_p:].
        return OwnerAppRunningStateRunningProfileFront ;
    }
    
    NSString* profile = [[[self client] clientoid] profileName] ;
    
    if ([pluginCurrentProfile isEqualToString:profile]) {
        return OwnerAppRunningStateRunningProfileFront ;
    }

#if 0
#warning always doing it
    return OwnerAppRunningStateRunningProfileFront ;
#endif
    return OwnerAppRunningStateRunningProfileWrong ;
}

- (BkmxReadWriteStyles)readWriteStylesError_p:(NSError**)error_p {
    NSInteger readStyle = 1 ;
    NSInteger writeStyle = 1 ;
    NSError* error = nil ;
    BOOL syncIsActive = [self isSyncActiveError_p:&error] ;
    if (error) {
        goto end ;
    }
    OwnerAppRunningState runningState = [self ownerAppRunningStateError_p:&error] ;
    if (runningState == OwnerAppRunningStateError) {
        goto end ;
    }
    
	// Compute readStyle
    if (
        ([[[self client] extoreMedia] isEqualToString:constBkmxExtoreMediaThisUser])
        &&
        (runningState != OwnerAppRunningStateNotRunning)
        &&
        ([self addonSupportsPurpose:constAddonabilityImport])
        ) {
		readStyle = 2 ;
	}

	// Compute writeStyle
    if (syncIsActive) {
        // Added in BookMacster 1.13.1.  If sync is active, we must use the
        // Chrome extension and Chrome must be running, so that bookmarks will
        // be pushed into the Chrome Sync cloud and not overwritten the next
        // time that Chrome launches.
        writeStyle = 2 ;
    }
    else if (
             ([[[self client] extoreMedia] isEqualToString:constBkmxExtoreMediaThisUser])
             &&
              (runningState != OwnerAppRunningStateNotRunning)
             &&
             ([self addonSupportsPurpose:constAddonabilityExport])
             ) {
		writeStyle = 2 ;
	}
	
end:;
    BkmxReadWriteStyles readWriteStyles = BkmxReadWriteStylesFromComponents(readStyle, writeStyle) ;
    
    if (error && error_p) {
        *error_p = error ;
    }
    
	return readWriteStyles ;
}

- (BOOL)shouldBlindSawChangeTriggerDuringExport:(NSInteger)writeStyle {
	// Because of the 10-second delay in the extension before the
	// Changes/Detected/*.json file is touched, it wouldn't do any good.
	// Also, since Chrome is multithreaded, user may be able to
	// change bookmarks during an export operation.
	// Also, user could change bookmarks during that 10 seconds.
	return NO ;
}

- (SEL)reformatStarkToExtore {
	return @selector(extoreItemForChrome:) ;
}

- (void)writeUsingStyle2InOperation:(SSYOperation*)operation {
 	[self exportJsonViaIpcForOperation:operation] ;
}

// The following was added in BookMacster 1.11
 - (id)tweakedValueFromStark:(Stark*)stark
					 forKey:(NSString*)key {
	id tweakedValue = [stark valueForKey:key] ;
	
	if ([key isEqualToString:constKeyName]) {
		tweakedValue = [stark name] ;
		if ([tweakedValue containsString:constNonbreakingSpace]) {
			NSMutableString* mutant = [tweakedValue mutableCopy] ;
			[mutant replaceOccurrencesOfString:constNonbreakingSpace
									withString:@" "] ;
			tweakedValue = [NSString stringWithString:mutant] ;
			[mutant release] ;
		}

		tweakedValue = [tweakedValue stringByCollapsingConsecutiveSpaces] ;
	}

	return tweakedValue ;
}

- (Stark*)starkFromExtoreNode:(NSDictionary*)dic {
	Stark* stark = nil;  // We'll return nil if things go wrong
	
	NSString* dateString ;

	NSString* name = nil;
	NSString* url = nil ;
	NSString* exid = nil ;
	NSDate* addDate = nil ;
	NSDate* lastModifiedDate = nil ;
	
	// Attributes common to both containers and nodes

	stark = [[self starker] freshStark] ;

	// When the JSON is read from the Chrome Bookmarks file, name's key is "name", but when
	// it's read from the Chrome Extension Bookmarks API, this key is "title".
	// We handle either case here:
	name = [dic objectForKey:@"name"] ;
	if (!name) {
		name = [dic objectForKey:@"title"] ;
	}

	exid = [dic objectForKey:@"id"] ;
	
	// When the JSON is read from the Chrome Bookmarks file, addDate's key is "date_added", but when
	// it's read from the Chrome Extension Bookmarks API, this key is "dateAdded".
	// We handle either case here:
	dateString = [dic objectForKey:@"date_added"] ;
	if (dateString) {
		// Style 1
		addDate = [NSDate dateWithMicrosecondsSince1601:[dateString longLongValue]] ;
	}
	else {
		// Style 2
		dateString = [dic objectForKey:@"dateAdded"] ;
		addDate = [NSDate dateWithTimeIntervalSince1970:[dateString doubleValue]/1000] ;
	}
	// Starting in BookMacster 1.11, I pass this as a local value
	// instead of mapping to Stark's addDate property.
	// See Note 190351.
	[stark setOwnerValue:addDate
						 forKey:constKeyAddDate] ;

	if (!name) {
		// Defensive programming against corrupt json files.
		name = [[BkmxBasis sharedBasis] labelNoName] ;
	}
	[stark setName:name] ;
	[stark setExid:exid
	  forClientoid:[[self client] clientoid]] ;
	
	if (
		// Identify folders read from the big hose Chrome Bookmarks file:
		[[dic objectForKey:@"type"] isEqualToString:BkmxConstTypeFolder]
		||
		// Identify folders read from the Chrome Extension Bookmarks API:
		([dic objectForKey:constKeyChildren] != nil)
		)  {
		// is a container (folder, collection, etc.)

		// When the JSON is read from the Chrome Bookmarks file, lastModifiedDate's key is "date_modified", but when
		// it's read from the Chrome Extension Bookmarks API, this key is "dateGroupModified".
		// We handle either case here:
		dateString = [dic objectForKey:@"date_modified"] ;
		if (dateString) {
			// Big Hose
			lastModifiedDate = [NSDate dateWithMicrosecondsSince1601:[dateString longLongValue]] ;
		}
		else {
			// Addon
			dateString = [dic objectForKey:@"dateGroupModified"] ;
			lastModifiedDate = [NSDate dateWithTimeIntervalSince1970:[dateString doubleValue]/1000] ;
		}
		// Starting in BookMacster 1.11, I pass this as a local value
		// instead of mapping to Stark's lastModifiedDate property.
		// See Note 190351.
		[stark setOwnerValue:lastModifiedDate
							 forKey:constKeyLastModifiedDate] ;

		// Note that we do not copy children here since we need copies
		// of the children.  This will be done by the deep copier.
    	
    	[stark setSharypeValue:SharypeSoftFolder] ;
		// may actually be Root, Bar or Menu but we detect that in
        // -makeStarksFromExtoreTree:error_p, and fix the sharype value in
		// -[Stark assembleAsTreeWithRoot:::] 
    }
    else {
    	// is a bookmark
    	url = [dic objectForKey:@"url"] ;
 		
#if DEBUG_WRITE_IMPORTED_URLS_TO_FILES
		[self appendBookmarkSSYLinearFileWriterName:name
												url:url] ;
#endif
		// set values in output
    	[stark setUrl:url] ;		
		[stark setSharypeValue:SharypeBookmark] ;
    }
	
	// As we create starks, bump up the highestUsedId when we find a higher one
	m_highestUsedId = MAX(m_highestUsedId, [exid integerValue]) ;
	
	return stark ;
}

- (BOOL)makeStarksFromExtoreTree:(NSDictionary*)treeIn
                         error_p:(NSError **)error_p {
	BOOL ok = YES ;
    NSError* error = nil ;
	
	NSDictionary* chromyBookmarksBar = nil ;
	NSDictionary* chromyBookmarksMenu = nil ;
	id whatever = nil ;  // Will be dictionary for style1, array for style2
	NSInteger errorCode = 0 ;
	NSString* errorMoreInfo = nil ;
	if ([treeIn isKindOfClass:[NSDictionary class]]) {	
		if ((whatever = [treeIn objectForKey:@"roots"])) {
			// This will happen normally if we are invoked from -readExternalStyle1ForPolarity:
			if ([whatever respondsToSelector:@selector(objectForKey:)]) {
				chromyBookmarksBar = [whatever objectForKey:@"bookmark_bar"] ;
				chromyBookmarksMenu = [whatever objectForKey:@"other"] ;
			}
			else {
				errorCode = 164870 ;
				errorMoreInfo = [NSString stringWithFormat:@"Expected dictionary, got %@", [whatever className]] ;
			}
		}
		else if ((whatever = [treeIn objectForKey:@"children"])) {
			// This will happen normally if we are invoked from -readExternalStyle2ForOperation:
			if ([whatever isKindOfClass:[NSArray class]]) {
				if ([whatever count] >= 2) {
					chromyBookmarksBar = [whatever objectAtIndex:0] ;
					chromyBookmarksMenu = [whatever objectAtIndex:1] ;
				}
				else {
					errorCode = 164871 ;
					errorMoreInfo = [NSString stringWithFormat:@"Expected 2 hartainers, got %ld", (long)[whatever count]] ;
				}
			}
			else {
				errorCode = 164872 ;
				errorMoreInfo = [NSString stringWithFormat:@"Expected array, got %@", [whatever className]] ;
			}			 
		}
		else {
			errorCode = 164873 ;
			errorMoreInfo = [NSString stringWithFormat:@"Expected 'roots' or 'children', got %@", [whatever allKeys]] ;
		}			 
	}
	else {
		errorCode = 164874 ;
		errorMoreInfo = [NSString stringWithFormat:@"Expected dictionary, got %@", [whatever className]] ;
	}
	
	if (errorCode != 0) {
		ok = NO ;
        error = SSYMakeError(errorCode, @"Decoded JSON does not meet expectation") ;
        error = [error errorByAddingUserInfoObject:errorMoreInfo
                                            forKey:@"Details"] ;
		goto end ;
	}
	
	// More checks for corrupt file.
	if (!chromyBookmarksBar) {
		ok = NO ;
		error = SSYMakeError(15910, @"No bar in JSON") ;
		goto end ;
	}
	if (!chromyBookmarksMenu) {
		ok = NO ;
		error = SSYMakeError(95705, @"No menu in JSON") ;
		goto end ;
	}
	if (![chromyBookmarksBar respondsToSelector:@selector(objectForKey:)]) {
		ok = NO ;
		error = SSYMakeError(46558, @"JSON bar not a dict") ;
		goto end ;
	}
	if (![chromyBookmarksMenu respondsToSelector:@selector(objectForKey:)]) {
		ok = NO ;
		error = SSYMakeError(65490, @"JSON menu not a dict") ;
		goto end ;
	}
	
	NSString* name ;

	// Get name of Bookmarks Bar
	// When the JSON is read from the Chrome Bookmarks file, name's key is "name", but when
	// it's read from the Chrome Extension Bookmarks API, this key is "title".
	// We handle either case here:
	name = [chromyBookmarksBar objectForKey:@"name"] ;
	if (!name) {
		name = [chromyBookmarksBar objectForKey:@"title"] ;
	}
	// Guard against corrupt Bookmarks file
	if (!name) {
		name = [[BkmxBasis sharedBasis] labelBar] ;
	}
	[[self fileProperties] setObject:name
							  forKey:constKeyExtoreDisplayNameOfBar] ;

	// Get name of Other Bookmarks
	// When the JSON is read from the Chrome Bookmarks file, name's key is "name", but when
	// it's read from the Chrome Extension Bookmarks API, this key is "title".
	// We handle either case here:
	name = [chromyBookmarksMenu objectForKey:@"name"] ;
	if (!name) {
		name = [chromyBookmarksMenu objectForKey:@"title"] ;
	}
	// Guard against corrupt Bookmarks file
	if (!name) {
		name = [[BkmxBasis sharedBasis] labelMenu] ;
	}
	[[self fileProperties] setObject:name
							  forKey:constKeyExtoreDisplayNameOfMenu] ;
	
	// Create a transformer which we will use to create our collections from Chrome/ium's
	SSYTreeTransformer* transformer = [SSYTreeTransformer
									   treeTransformerWithReformatter:@selector(modelAsStarkInStartainer:)
									   childrenInExtractor:@selector(childrenWithLowercaseC)
									   newParentMover:@selector(moveToBkmxParent:)
									   contextObject:self] ;
	
	Stark* rootOut = [[self starker] freshStark] ;
	[rootOut setName:@"Ext-Json-Root"] ;
	Stark* barOut = [transformer copyDeepTransformOf:chromyBookmarksBar] ;
	Stark* menuOut = [transformer copyDeepTransformOf:chromyBookmarksMenu] ;

	if ([[self client] dontUseOtherBookmarks]) {
		NSArray* barChildren = [barOut childrenOrdered] ;
		// In order to get the bar items at the top, we start from the
		// bottom of the bar and move each item to index 0 in the menu.
		for (Stark* barChild in [barChildren reverseObjectEnumerator]) {
			[barChild moveToBkmxParent:menuOut
							   atIndex:0
							   restack:YES] ;
		}	
	}
	
	// Set instance variables
	[rootOut assembleAsTreeWithBar:barOut
							  menu:menuOut
						   unfiled:nil
							ohared:nil];
	
	[barOut release] ;
	[menuOut release] ;

end:
    if (error && error_p) {
        *error_p = error ;
    }
	return ok ;
}

- (BOOL)getFreshExid_p:(NSString**)exid_p
			higherThan:(NSInteger)higherThan
			  forStark:(Stark*)stark
			   tryHard:(BOOL)tryHard
			   error_p:(NSError**)error_p {
	NSInteger nextValue = MAX(m_highestUsedId, higherThan) + 1 ;
	m_highestUsedId = nextValue ;
	*exid_p = [NSString stringWithFormat:@"%ld", (long)nextValue] ;
	
	return YES ;
}

- (BOOL)isExportableStark:(Stark*)stark
			   withChange:(NSDictionary*)change {
#if IS_EXPORTABLE_STARK_WILL_ALWAYS_RETURN_YES
	return YES  ;
#endif

	if (![super isExportableStark:stark
					   withChange:change]) {
		return NO ;
	}
	
	// Any sharype which cannot have a URL, such as folders, are OK.
	if (![stark canHaveUrl]) {
		return YES ;
	}
	
	// Chrome does not support Smart Bookmarks.
	if ([stark sharypeValue] == SharypeSmart) {
		return NO ;
	}
	
	if ([stark is1PasswordBookmarklet]) {
		return NO ;
	}		

	return YES ;
}

- (void)ensureAddonInstallWindowSize {
	// Experimentally, I find that the minimum width needed to show the "Continue"
	// button in Google Chrome's status bar for installing extensions is somewhere
	// between 600 and 620 px.  It may require more for German, so…
	NSString* source = 
	/**/  @"set minWidth to 680\n"
	/**/  @"tell application id \"%@\"\n"
	/**/     @"set rect to bounds of window 1\n"
	/**/     @"set width to (item 3 of rect) - (item 1 of rect)\n"
	/**/     @"if width is less than minWidth then\n"
	/**/        @"set bounds of window 1 to {item 1 of rect, item 2 of rect, (item 1 of rect) + minWidth, item 4 of rect}\n"
	/**/     @"end if\n"
	/**/  @"end tell\n" ;
	source = [NSString stringWithFormat:
			  source,
			  [self extoreConstants_p]->browserBundleIdentifier1] ;

	NSError* error = nil ;
	BOOL ok = ([NSAppleScript threadSafelyExecuteSource:source
											   error_p:&error] != nil) ;
	if (!ok) {
		// Not a big deal; just log it.
		NSLog(@"Internal Error 650-9057: %@", [error longDescription]) ;
	}
}

- (NSString*)extensionResourcePathForOwnerAppBundlePath:(NSString*)bundlePath
											   widgetYN:(BOOL)widgetYN
												error_p:(NSError**)error_p {
	NSError* error = nil ;
	NSString* resourceName = @"SheepSystemsChromeExtension-Widget" ;
	NSString* suffix = widgetYN ? @"In" : @"Out" ;
	resourceName = [resourceName stringByAppendingString:suffix] ;
	NSString* const resourceExtension = @"crx" ;
	NSString* path = [[NSBundle mainBundle] pathForResource:resourceName
													 ofType:resourceExtension] ;
	if (!path) {
		NSString* msg = [NSString stringWithFormat:
						 @"Missing Resource %@.%@",
						 resourceName,
						 resourceExtension] ;
		error = SSYMakeError(904517, msg) ;
		goto end ;
	}
	
end:
	if (error && error_p) {
		*error_p = error ;
	}
	
	return path ;
}

- (NSTimeInterval)exportFeedbackTimeoutPerChange {
	// 2820 changes on my 2009 Mac Mini took 15 seconds from Google Chrome
	// That would be 15/2820 = .005.  So far, I've received only one error
	// report with the setting .05, user Michael Scotti on 20081112.  At
	// the time, error reports were not showing the timer's time interval,
	// so I don't know what that is.  He never followed up with more info.
	// May have been a fluke, Chrome crash.  Just leave it at .05 for now.
	return .05 ;
}

- (NSString*)extensionFullPath {
	NSString* path = [[[self client] clientoid] filePathParentError_p:NULL] ;
	path = [path stringByAppendingPathComponent:@"Extensions"] ;
	path = [path stringByAppendingPathComponent:constChromeExtensionUuid] ;
	
	return path ;
}

- (NSString*)thisProfilePrefsPathError_p:(NSError**)error_p {
	BOOL ok = YES ;
	NSError* error = nil ;
	NSString* filePathParent = [[self client] filePathParentError_p:&error] ;
	
	NSString* path = [filePathParent stringByAppendingPathComponent:constFilenameChromePreferences] ;
	
	if (!path) {
		ok = NO ;
		NSString* msg = [NSString stringWithFormat:
						 @"Could not get preferences path for %@",
						 [[self client] displayName]]  ;
		error = SSYMakeError(252541, msg) ;
		goto end ;
	}
	
end:
	if (!ok && error_p) {
		*error_p = error ;
	}
	
	return path ;
}

- (NSString*)extensionManifestPath {
	NSString* path = [[[self client] clientoid] filePathParentError_p:NULL] ;
	// ~/Library/Application Support/Google/Chrome/Default
	path = [path stringByAppendingPathComponent:@"Extensions"] ;
	// ~/Library/Application Support/Google/Chrome/Default/Extensions
	path = [path stringByAppendingPathComponent:constChromeExtensionUuid] ;
	// ~/Library/Application Support/Google/Chrome/Default/Extensions/gielihnpdhkbdcnlcdnpnkidbomiccip
	path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld_0", (long)CHROME_EXTENSION_LATEST_VERSION]] ;
	// ~/Library/Application Support/Google/Chrome/Default/Extensions/gielihnpdhkbdcnlcdnpnkidbomiccip/103_0
	path = [path stringByAppendingPathComponent:@"manifest"] ;
	// ~/Library/Application Support/Google/Chrome/Default/Extensions/gielihnpdhkbdcnlcdnpnkidbomiccip/103_0/manifest
	path = [path stringByAppendingPathExtension:@"json"] ;
	// ~/Library/Application Support/Google/Chrome/Default/Extensions/gielihnpdhkbdcnlcdnpnkidbomiccip/103_0/manifest.json

	return path ;
}

/*!
 @brief    Returns the dictionary represented in the JSON file
 ~/Library/Application Support/Google/Chrome/Default/Preferences.
 
 @result   If the preferences file could not be found, returns
 nil, and by reference, an error.
 */
- (NSDictionary*)thisProfilePrefsError_p:(NSError**)error_p {
	BOOL ok = YES ;
	NSError* error = nil ;
    NSString* errMsg ;
    NSDictionary* dic = nil ;
	
	NSString* path = [self thisProfilePrefsPathError_p:&error] ;
	if (!path) {
		ok = NO ;
		goto end ;
	}
	
    dic = [NSDictionary dictionaryFromJsonAtPath:path
                                         error_p:&error] ;
    
    if (!dic) {
        ok = NO ;
        errMsg = [NSString stringWithFormat:
                  @"Could not read preferences for %@ profile %@",
                  [[self client] displayName],
                  [[self client] profileName]] ;
        error = [SSYMakeError(253005, errMsg) errorByAddingUnderlyingError:error] ;
        NSString* sugg = [NSString stringWithFormat:
                          @"Launch %@.  If you see a 'Users' menu, activate user %@.",
                          [self ownerAppDisplayName],
                          [[self class] displayNameForProfileName:[[self client] profileName]
                                                         homePath:[[self client] homePath]]] ;
        error = [error errorByAddingLocalizedRecoverySuggestion:sugg] ;
        goto end ;
    }
	
end:
	if (!ok && error_p) {
		*error_p = error ;
	}

	return dic ;
}

- (BOOL)isSyncActiveError_p:(NSError**)error_p {
    NSError* error = nil ;
    NSInteger errorCode = 0 ;
    NSDictionary* errorInfo = nil ;
    
    BOOL syncActive = NO ;
    
    NSDictionary* prefs = [self thisProfilePrefsError_p:&error] ;
    
    if (!prefs) {
        errorCode = 928093 ;
        goto end ;
    }
    
    NSDictionary* syncPrefs = [prefs objectForKey:@"sync"] ;
    if (!syncPrefs) {
        // This branch added in BookMacster 1.9.5.
        // This seems to happen if Google account has never been activated in Google Chrome.
        // For our purposes, it means that Google Chrome bookmarks sync is off.
        goto end ;
    }
    if (![syncPrefs isKindOfClass:[NSDictionary class]]) {
        errorCode = 156612 ;
        goto end ;
    }
    
    /* The JSON "sync" prefs text being analyzed here looks e.g. like this:
     "sync": {
     "autofill": false,
     "bookmarks": false,
     "extensions": false,
     "has_setup_completed": true,
     "keep_everything_synced": false,
     "preferences": false,
     "suppress_start": false,
     "themes": false
     },
     */
    
    NSNumber* sync_hasSetupCompleted_object = [syncPrefs objectForKey:@"has_setup_completed"] ;
    NSNumber* sync_bookmarks_object = [syncPrefs objectForKey:@"bookmarks"] ;
    NSNumber* sync_keepEverythingSynced_object = [syncPrefs objectForKey:@"keep_everything_synced"] ;
    if (sync_hasSetupCompleted_object) {
        if (![sync_hasSetupCompleted_object respondsToSelector:@selector(boolValue)]) {
            errorCode = 156412 ;
            errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                         [sync_hasSetupCompleted_object className], @"Object Class",
                         sync_hasSetupCompleted_object, @"Object",
                         nil] ;
            goto end ;
        }
    }
    if (sync_bookmarks_object) {
        if (![sync_bookmarks_object respondsToSelector:@selector(boolValue)]) {
            errorCode = 156512 ;
            errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                         [sync_bookmarks_object className], @"Object Class",
                         sync_bookmarks_object, @"Object",
                         nil] ;
            goto end ;
        }
    }
    if (sync_keepEverythingSynced_object) {
        if (![sync_keepEverythingSynced_object respondsToSelector:@selector(boolValue)]) {
            errorCode = 156612 ;
            errorInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                         [sync_keepEverythingSynced_object className], @"Object Class",
                         sync_keepEverythingSynced_object, @"Object",
                         nil] ;
            goto end ;
        }
    }
    BOOL sync_hsc = [sync_hasSetupCompleted_object boolValue] ;
    BOOL sync_b = [sync_bookmarks_object boolValue] ;
    BOOL sync_kes = [sync_keepEverythingSynced_object boolValue] ;
    // The rather redundant logic here *is* necessary to properly decode all
    // possible cases.  Ask the Chrome Team why they made it so complicated…
    syncActive = sync_hsc && (sync_b || sync_kes) ;
    
end:
    if ((errorCode != 0) && error_p) {
        NSString* genericErrorDescription = @"Error trying to determine whether or not Chrome Sync is active" ;
        if (errorInfo) {
            errorInfo = [errorInfo dictionaryBySettingValue:genericErrorDescription
                                                     forKey:NSLocalizedDescriptionKey] ;
        }
        else {
            errorInfo = [NSDictionary dictionaryWithObject:genericErrorDescription
                                                    forKey:NSLocalizedDescriptionKey] ;
        }
        error = [[NSError errorWithDomain:[NSError myDomain]
                                     code:errorCode
                                 userInfo:errorInfo] errorByAddingUnderlyingError:error] ;
        *error_p = error ;
    }
    
    return syncActive ;
}

+ (NSArray*)keyPathInPrefsToExtension {
	return [NSArray arrayWithObjects:
			@"extensions",
			@"settings",
			constChromeExtensionUuid,
			nil] ;
}

- (BOOL)setThisUserPrefs:(NSDictionary*)prefs
				 error_p:(NSError**)error_p {
	BOOL ok = YES ;
	NSError* error = nil ;
	
	NSString* prefsString = [prefs jsonStringValue] ;
	
	if (!prefsString) {
		ok = NO ;
		NSString* msg = [NSString stringWithFormat:
						 @"Could not jsonify prefs for %@",
						 [[self client] displayName]]  ;
		error = [SSYMakeError(687564, msg) errorByAddingUnderlyingError:error]  ;
		error = [error errorByAddingUserInfoObject:prefs
											forKey:@"Dictionary"] ;
		goto end ;
	}
	
	NSString* path = [self thisProfilePrefsPathError_p:&error] ;
	if (!path) {
		ok = NO ;
		NSString* msg = [NSString stringWithFormat:
						 @"No prefs path for %@",
						 [[self client] displayName]]  ;
		error = [SSYMakeError(203694, msg) errorByAddingUnderlyingError:error]  ;
		goto end ;
	}
		
	ok = [prefsString writeToFile:path
					   atomically:YES
						 encoding:NSUTF8StringEncoding
							error:&error] ;
	if (!ok) {
		goto end ;
	}

end:
	if (!ok && error_p) {
		*error_p = error ;
	}
	
	return ok ;
}

/*!
 @details  	I think that this implementation is probably no longer needed now
 that I'm installing as an External Extension, but I don't remember why I
 wrote it to begin with.  At worst, it's effectively a no-op. 
*/
#if 0
//Removed in BookMacster 1.13.2
- (BOOL)addonInstallPostflightForBundlePath:(NSString*)bundlePath
									error_p:(NSError**)error_p {
	NSError* error = nil ;
	
	NSDictionary* prefs = [self thisProfilePrefsError_p:&error] ;
	if (!prefs) {
		error = [SSYMakeError(846586, @"Could not get prefs to ensure enablement of extension") errorByAddingUnderlyingError:error] ;
		goto end ;
	}
	
	NSArray* keyPathArray = [[[self class] keyPathInPrefsToExtension] arrayByAddingObject:constKeyState] ;
	
	BOOL enabled = [[prefs valueForKeyPathArray:keyPathArray] integerValue] == 1 ;
    // See Note 20130130
	if (!enabled) {
		NSMutableDictionary* copy = (NSMutableDictionary*)[prefs mutableCopyDeepPropertyList] ;
		if (!copy) {
			error = [SSYMakeError(414677, @"Could not copy prefs to enable extension.  Expected since we migrated to using an external extension?") errorByAddingUnderlyingError:error] ;
			goto end ;
		}
		
		[copy setValue:[NSNumber numberWithInteger:1]
	   forKeyPathArray:keyPathArray] ;
		
		BOOL ok = [self setThisUserPrefs:copy
								 error_p:&error] ;
		[copy release] ;
		
		if (!ok) {
			error = [SSYMakeError(122566, @"Could not write prefs to ensure enablement of extension") errorByAddingUnderlyingError:error] ;
			goto end ;
		}
	}
	
end:
	if (error) {
		// Since this method is rarely needed, just log it
		NSLog(@"Internal Error 849-2468 ensuring enablement of %@ extension: %@",
			  [[self client] displayName],
			   error) ;
	}	

	return YES ;
}
#endif

- (NSString*)externalExtensionsDirectoryPath {
	NSString* path = [[[self client] clientoid] filePathParentError_p:NULL] ;
	// ~/Library/Application Support/Google/Chrome/Default
	path = [path stringByDeletingLastPathComponent] ;
	// ~/Library/Application Support/Google/Chrome
	path = [path stringByAppendingPathComponent:@"External Extensions"] ;
	// ~/Library/Application Support/Google/Chrome/External Extensions
	
	return path ;
}

- (NSString*)externalExtensionFilePath {
	NSString* path = [[self externalExtensionsDirectoryPath] stringByAppendingPathComponent:constChromeExtensionUuid] ;
	path = [path stringByAppendingPathExtension:@"json"] ;
	
	return path ;
}

- (NSDictionary *) externalExtensionDicFromDisk {
	// We get our extension version from our External Extensions file, because this
	// is available immediately after installation.  A more conservative indication would
	// be to read if from the Preferences file, but it does not appear there until
	// after Chrome has launched once after the installation, and enters it.
	NSString* externalExtensionFilePath = [self externalExtensionFilePath] ;
	NSString* externalExtensionString = [NSString stringWithContentsOfFile:externalExtensionFilePath
																  encoding:NSUTF8StringEncoding
																	 error:NULL] ;
	
	NSDictionary* extensionDic = nil ;
	if (externalExtensionString) {
		extensionDic = [NSDictionary dictionaryWithJSONString:externalExtensionString
												   accurately:NO] ;
	}
	return extensionDic ;
}

- (NSInteger)hasWidget {
	NSInteger hasWidget = NSMixedState ;  // unknown
	
	// We take the fastest and most optimistic test possible, which is
	// to see if the path in the external extensions json file is 
	// pointing to the -WidgetIn.crx file or the -WidgetOut.crx file.
	// A slower, less optimistic test would be to check the manifest in
	// the Preferences file and see if it has the browser_action key.
	// That will not change until after the extension is installed and
	// the widget is switched on or off, *and* Chrome is relaunched.
	// We use this faster test because we want our Widget checkbox in 
	// Preferences ▸ Adding to update immediately.
	
	NSDictionary* externalExtensionDic = [self externalExtensionDicFromDisk] ;
	
	if (externalExtensionDic) {
		NSString* crxResourcePath = [externalExtensionDic objectForKey:@"external_crx"] ;
		NSString* crxFileBasename = [[crxResourcePath lastPathComponent] stringByDeletingPathExtension] ;
		if ([crxFileBasename hasSuffix:@"In"]) {
			hasWidget = NSOnState ;
		}
		else if ([crxFileBasename hasSuffix:@"Out"]) {
			hasWidget = NSOffState ;
		}
		else {
			NSLog(@"Internal Error 620-4850  Unexpected crxResourcePath %@", crxResourcePath) ;
		}
	}
	
	return hasWidget ;
}

- (NSDictionary*)peekAddon {
	NSDictionary* extensionDic = [self externalExtensionDicFromDisk];
	
    NSInteger extensionVersion = 0 ;
	if (extensionDic) {
		NSString* versionString = [extensionDic valueForKey:@"external_version"] ;
		extensionVersion = [versionString integerValue] ;

		// Make sure the extension is enabled for this profile
        if (extensionVersion > 0) {
            AddOnInstallStatus status = [[self class] addOnInstallStatusForProfile:[[self client] profileName]] ;
            if (
                (status != AddOnInstallStatusInstalledEnabled)
                &&
                (status != AddOnInstallStatusNoObjection)
                )
            {
                extensionVersion = 0 ;
            }
        }

    }
								
	// Find whether or not the widget is installed
	NSInteger hasWidget = [self hasWidget] ;
	
	/* Read the NPAPI plugin's version from the file system.
	 At first, I thought it would be cool to read it from its bundle like this:
	 NSBundle* pluginBundle = [NSBundle bundleWithPath:[self pluginFullPath]] ;
	 NSInteger pluginVersion = [[[pluginBundle infoDictionary] objectForKey:@"CFBundleVersion"] integerValue] ;
	 Unfortunately, -bundleWithPath: "allocates and initializes the returned object if there is no existing
	 NSBundle associated with fullPath, in which case it returns the existing object."  Well, that
	 means that if I read the version of the plugin bundle, see that it is downrev, then
	 user reinstalls the current version plugin on the disk, and then re-invoke this
	 method to re-read the version, it will still have the old version.  Arghh!
	 So, do it this way instead: */
	NSString* path = [[self pluginFullPath] stringByAppendingPathComponent:@"Contents"] ;
	path = [path stringByAppendingPathComponent:@"Info.plist"] ;
	NSData* data = [NSData dataWithContentsOfFile:path] ;
	NSDictionary* plistInfo = nil ;
	if (data) {
		if ([[NSPropertyListSerialization class] respondsToSelector:@selector(propertyListWithData:options:format:error:)]) {
			// Mac OS X 10.6 or later
			NSPropertyListMutabilityOptions options = NSPropertyListImmutable ;
			NSError* error = nil ;
			NSInvocation* invoc = [NSInvocation invocationWithTarget:[NSPropertyListSerialization class]
															selector:@selector(propertyListWithData:options:format:error:)
													 retainArguments:YES
												   argumentAddresses:&data, &options, NULL, &error] ;
			[invoc invoke] ;
			[invoc getReturnValue:&plistInfo] ;
		}
		else {
			// Mac OS X 10.5
			NSString* errorDescription = nil ;
			plistInfo = [NSPropertyListSerialization propertyListFromData:data
														 mutabilityOption:NSPropertyListImmutable
																   format:NULL
														 errorDescription:&errorDescription] ;
		}
	}

	NSInteger pluginVersion = [[plistInfo objectForKey:@"CFBundleVersion"] integerValue] ;

	NSDictionary* result = [self testResultForExtensionVersion:extensionVersion
												pluginVersion:pluginVersion
                                                 pluginProfile:nil
													hasWidget:hasWidget
														error:nil] ;
	// In the above, testResultForExtensionVersion:::: will compute the error
	// if one or both of the versions are downrev.
	
	return result ;
}

/*
 @details   It is assumed that this method is performing a non-critical
 operation such as preventing future errors which may or may not occur, or
 improving the user experience.  Therefore, to optimize overall user experience,
 if an error occurs, we log it and fail silently.
 */
- (void)removeExtensionFromPrefsWithProgressView:(SSYProgressView *)progressView {
    BOOL ok = YES ;
    NSError* error = nil ;

    [self quitOwnerAppCleanlyWithProgressView:progressView
									  error_p:&error] ;
	if (ok) {
        if (error) {
		// Because this code is not really necessary in most cases, we simply
		// log the error and bail out.
		NSLog(@"Internal Error 135-8829, Could not get to clean preferences for %@.  %@", [[[self client] clientoid] clidentifier], error) ;
        ok = NO ;
        }
    }
	
	NSDictionary* prefsIn = nil ;
    if (ok) {
        prefsIn = [self thisProfilePrefsError_p:&error] ;
        if (!prefsIn) {
            // Because this code is not really necessary in most cases, we simply
            // log the error and bail out.
            NSLog(@"Internal Error 135-8826, Could not decode to clean preferences for %@.  %@", [[[self client] clientoid] clidentifier], error) ;
            ok = NO ;
        }
	}
    
    NSMutableDictionary *prefs = nil ;
    if (ok) {
        prefs = [prefsIn mutableCopy] ;
        NSArray* keyPath = [[self class] keyPathInPrefsToExtension] ;
            [prefs setValue:nil
            forKeyPathArray:keyPath] ;
        ok = [self setThisUserPrefs:prefs
                            error_p:&error] ;
        if (!ok) {
            // Because this code is not really necessary in most cases, we simply
            // log the error and bail out.
            NSLog(@"Internal Error 156-3016, Could not write clean preferences for %@.  %@", [[[self client] clientoid] clidentifier], error) ;
        }
    }
	
	[prefs release] ;
}

- (BOOL)installExtensionInfo:(NSDictionary*)info
				   widgetize:(NSInteger)widgetize
					 error_p:(NSError**)error_p {
    /*
     We install our extension as so-called "External Extension" in Chrome.
     What we must do is (1) in the instant profile's Preferences, remove any
     prior knowledge of our extension and (2) install a file in the
     "External Extensions" folder pointing it to the .crx in our Resources.
     Note that we do *not* install our extension in the instant
     <profile>/Extensions subfolder.  Chrome will do that the next time that
     it launches.  Weird, but this is the way you install an External Extension.
     Finally (3), we pre-write a reverse-engineered .localstorage file for our
     extension which contains its profile name.
     
     The reason for (3) is that
     NPAPI plugin needs to know to identify which User Profile it is operating
     in, so it can tell us when we ask which profile's bookmarks it will access,
     before we access them.  This is usually the single profile into which
     Chrome launches, and is indicated by the "last_used" key in the Local State
     file at the time Chrome launches, but not always.  Certainly there could be
     a race condition with Local State.  So instead of doing that, I put the
     profileName in the extension's local storage for each profile.  (I am using
     regular HTML5 localStorage, not chrome.storage which apparently requires
     permissions and messaging through hoops in order to make it work from a
     background page.  Regular HTML5 localStorage appears to be sufficient for
     this purpose and just works.)  The extension can read the profileName from
     localStorage and pass it to my NPAPI plugin.
     
     Writing the profileName during installation is more complicated.  The
     extension cannot do it because, wit does not know what profile it's in.
     And this External Extension itself is common to all profiles.  So we write
     the profileName, under the hood.  After installing the External Extension,
     we install an empty localstorage sqlite file for my extension into the
     profile folder, then insert a record with the profileName encoded as
     Chrome's implementation of localStorage does.
     
     For more info with links, see https://groups.google.com/a/chromium.org/forum/?fromgroups=#!topic/chromium-extensions/D5Kl-RISuUI
     */
    
	BOOL ok = YES ;
	NSError* error = nil ;	
    SSYSqliter* sqliter = nil ;
    
	// Step (1)
	
	// Here's why.  Near the bottom of documentation…
	// http://code.google.com/chrome/extensions/external_extensions.html,
	// it says: "To uninstall your extension (for example, if your software is uninstalled),
	// remove your preference file (aaaaaaaaaabbbbbbbbbbcccccccccc.json)…".  That works fine.
	// If user then wants to re-install the extension, we restore that file and Chrome works.
	// But if instead user trashes the extension in the user interface, and we reinstall
	// that file, Chrome ignores it.  That is explained in the documentation like this:
	// "If the user uninstalls the extension through the UI, it will no longer be installed
	// or updated on each startup. In other words, the external extension is blacklisted. …
	// If the user uninstalls your extension, you should respect that decision. However, if
	// you (the developer) accidentally uninstalled your extension through the UI, you can
	// remove the blacklist tag by installing the extension normally through the UI, and then
	// uninstalling it."  Well, of course I can't do that.  Further more, if the user
	// clicks "Install" or attempts to export to Chrome while Chrome is running, they are
	// indicating that they want the extension re-installed.  Therefore, I *am* respecting
	// their *later revised* decision.  I've found that a workaround for the blacklist issue is to
	// remove my entry from the Preferences file *before* reinstalling the .json file and
	// relaunching Chrome.  So hence…
	[self removeExtensionFromPrefsWithProgressView:[[info objectForKey:constKeyDocument] progressView]];

	// Step (2)
	
	NSString* destinDir = [self externalExtensionsDirectoryPath] ;
	
	if (destinDir) {
		BOOL widgetYN = NO ;
		if (widgetize == NSOnState) {
			widgetYN = YES ;
		}
		else if (widgetize == NSOffState) {
			widgetYN = NO ;
		}
		else {
			// widgetize == NSMixedState
			// If there is an existing extension installation with widget, we should
			// install the new one with widget.
			NSInteger existingWidgetState = [self hasWidget] ;
			widgetYN = (existingWidgetState == NSOnState) ;
		}
		
		NSString* ownerPath = [info objectForKey:constKeyRunningBrowserPath] ;
		// Actually, ownerPath is not necessary because the message implementation 
		// targetted in the next line, in ExtoreChromy, ignores that parameter, but
		// it would be bad programming practice to pass nil for that reason.
		NSString* extensionResourcePath = [self extensionResourcePathForOwnerAppBundlePath:ownerPath
																				  widgetYN:widgetYN
																				   error_p:&(*error_p)] ;
		if (!extensionResourcePath) {
			ok = NO ;
			goto end ;
		}	
		
		// See if the "External Extensions" directory exists
		BOOL isDirectory ;
		BOOL directoryExists = [[NSFileManager defaultManager] fileExistsAtPath:destinDir
																	isDirectory:&isDirectory] ;
		if (directoryExists && !isDirectory) {
			error = SSYMakeError(119253, @"File exists where Chrome's External Extensions directory should be") ;
			error = [error errorByAddingUserInfoObject:destinDir
												forKey:@"Path"] ;
			goto end ;
		}
		
		NSError* createDirectoryError = nil ;
		if (!directoryExists) {
			NSNumber* octal755 = [NSNumber numberWithUnsignedLong:0755] ;
			// Note that, in 0755, the 0 is a prefix which says to interpret the
			// remainder of the digits as octal, just as 0x is a prefix which says to
			// interpret the remainder of the digits as hexadecimal.  It's in the C
			// language standard!
			NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:
										octal755, NSFilePosixPermissions,
										nil] ;
			
			// We ignore any error in case it's a false alarm.  We will report
			// it at the end if our writing a file within destinDir fails.
			[[NSFileManager defaultManager] createDirectoryAtPath:destinDir
									  withIntermediateDirectories:YES
													   attributes:attributes
															error:&createDirectoryError] ;
		}
		
		// Generate the JSON for our external extensions file
		NSDictionary* jsonDic = [NSDictionary dictionaryWithObjectsAndKeys:
								 extensionResourcePath, @"external_crx",
								 [NSString stringWithFormat:@"%ld", (long)CHROME_EXTENSION_LATEST_VERSION], @"external_version",
								 nil] ;
		// Note that, because extensionResourcePath is in the BookMacster application
		// package, the Chrome extension may fail to load, fail to operate, and thus
		// need to be reinstalled if the BookMacster application package is moved.
		// I don't see any problem with that.  More likely it will continue working,
        // because it uses the copy <profile>/Extensions and doesn't really need
        // the original!
		NSString* jsonString = [jsonDic jsonStringValue] ;
				
		// Write it to the file		
		NSString* destinPath = [self externalExtensionFilePath] ;
		ok = [jsonString writeToFile:destinPath
						  atomically:YES
							encoding:NSUTF8StringEncoding
							   error:&error] ;
		if (!ok) {
			error = [SSYMakeError(613069, @"Could not write External Extension file to Chrome") errorByAddingUnderlyingError:error] ;
			error = [error errorByAddingUserInfoObject:createDirectoryError
												forKey:@"Error Creating External Extensions Directory"] ;
			goto end ;
		}
	}
    
    // Step (3a)  Calculate the path to the .localstorage file we need to make
    NSString* profileName = [[self client] profileName] ;
    NSString* localStoragePath = [[self class] browserSupportPathForHomePath:nil] ;
    // e.g. /Users/jk/Library/Application Support/Google/Chrome/
    localStoragePath = [localStoragePath stringByAppendingPathComponent:profileName] ;
    // e.g. /Users/jk/Library/Application Support/Google/Chrome/Profile 2
    localStoragePath = [localStoragePath stringByAppendingPathComponent:@"Local Storage"] ;
    // e.g. /Users/jk/Library/Application Support/Google/Chrome/Profile 2/Local Storage
    NSString* filename = [NSString stringWithFormat:
                          @"chrome-extension_%@_0.localstorage",
                          constChromeExtensionUuid] ;
    localStoragePath = [localStoragePath stringByAppendingPathComponent:filename] ;

    // Step (3b)  Copy the prepared .localstorage file from Resources	
    if (localStoragePath) {
        NSString* resourceName = @"ChromeLocalStoragePrimer" ;
        NSString* resourceType = @"sql" ;
		NSString* sourcePath = [[NSBundle mainBundle] pathForResource:resourceName
                                                               ofType:resourceType] ;
        if (!sourcePath) {
            ok = NO ;
            error = SSYMakeError(513075, @"Missing resource") ;
            error = [error errorByAddingUserInfoObject:[NSString stringWithFormat:
                                                        @"%@.%@",
                                                        resourceName,
                                                        resourceType]
                                                forKey:@"Name"] ;
            goto end ;
        }
		
        
        NSError* removeError = nil ;
		// -copyItemAtPath:toPath:error: requires that there be no existing item at
		// destinPath.  There may or may not be.  So we first
		// -removeItemAtPath:error:, ignoring the result, but
		// remembering the removeError which we shall report in the
		// event that the copy fails.
		[[NSFileManager defaultManager] removeItemAtPath:localStoragePath
												   error:&removeError] ;
        
		// Create the "Local Storage" directory if it does not exist,
        // which is unlikely because Chrome seems to come with some extensions
        // that apparently use localStorage.  But that could change.
		NSNumber* octal755 = [NSNumber numberWithUnsignedLong:0755] ;
		// Note that, in 0755, the 0 is a prefix which says to interpret the
		// remainder of the digits as octal, just as 0x is a prefix which says 
		// to interpret the remainder of the digits as hexadecimal.  It's in the
        // C language standard!
		NSError* createDirectoryError = nil ;
		NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:
									octal755, NSFilePosixPermissions,
									nil] ;
		// Although this method should succeed even in the normal case, when
		// "Local Storage" already exists, we ignore its return BOOL, just
		// in case it's a false alarm.  We will, however, report the error if
		// copying the file, the important step, fails.
		[[NSFileManager defaultManager] createDirectoryAtPath:[localStoragePath stringByDeletingLastPathComponent]
								  withIntermediateDirectories:YES
												   attributes:attributes
														error:&createDirectoryError] ;
        // I suppose that YES might be needed if we were installing this
        // extension before Chrome had ever been run and therefore the Default
        // profile directory might not exist yet
        
		// then do the copy…
		ok = [[NSFileManager defaultManager] copyItemAtPath:sourcePath
													 toPath:localStoragePath
													  error:&error] ;
		if (!ok) {
			error = [SSYMakeError(513059, @"Could not copy plugin") errorByAddingUnderlyingError:error] ;
			error = [error errorByAddingUserInfoObject:removeError
												forKey:@"Error Removing Existing File"] ;
			error = [error errorByAddingUserInfoObject:createDirectoryError
												forKey:@"Error Creating Internet Plug-Ins Directory"] ;
			error = [error errorByAddingUserInfoObject:sourcePath
												forKey:@"Source Path"] ;
			error = [error errorByAddingUserInfoObject:localStoragePath
												forKey:@"Destin Path"] ;
			goto end ;
		}
	}    
    
    // Step (3c)  The prepared .localstorage file has the default profile name
    // "Default" in it already.  So we skip this step if that's our name.  We
    // skip it not so much for efficiency but for robustness, since this step
    // is reverse-engineered and unsupported.  If it breaks, it will only break
    // for users of multiple profiles.
    if (![[self defaultProfileName] isEqualToString:profileName]) {
        // e.g. /Users/jk/Library/Application Support/Google/Chrome/Profile 2/Local Storage/chrome-extension_gielihnpdhkbdcnlcdnpnkidbomiccip_0.localstorage" ;
        sqliter = [[SSYSqliter alloc] initWithPath:localStoragePath
                                                       error_p:&error] ;
        if (!sqliter) {
            ok = NO ;
            error = [SSYMakeError(613070, @"Could not open Local Storage database") errorByAddingUnderlyingError:error] ;
            goto end ;
        }
        NSData* profileNameData = [profileName dataUsingEncoding:NSUTF16LittleEndianStringEncoding] ;
        // Maybe it would be BigEndian on PowerPC Macs but Chrome does not
        // run on PowerPC Macs
        ok = [sqliter setBlobData:(NSData*)profileNameData
                           forKey:@"value"
                            where:@"key"
                               is:@"profileName"
                          inTable:@"itemTable"
                            error:&error] ;
        if (!ok) {
            ok = NO ;
            error = [SSYMakeError(613071, @"Could not set profile name into Local Storage database") errorByAddingUnderlyingError:error] ;
            error = [error errorByAddingUserInfoObject:profileName
                                                forKey:@"Profile Name"] ;
            goto end ;
        }
    }


end:
	[sqliter release] ;
    if (error && error_p) {
		error = [error errorByAddingUserInfoObject:[[[self client] clientoid] clidentifier]
											forKey:@"Clidentifier"] ;
		*error_p = error ;
	}
		
	return ok ;
}

+ (NSSet*)allProfiles {
    NSDictionary* infoCache = [self infoCacheForHomePath:NSHomeDirectory()] ;
    NSArray* profiles = [infoCache allKeys] ;
    NSMutableSet* checkedProfiles = [[NSMutableSet alloc] init] ;
    for (NSString* profile in profiles) {
        if ([profile isKindOfClass:[NSString class]]) {
            [checkedProfiles addObject:profile] ;
        }
    }
    
    NSSet* answer = [[checkedProfiles copy] autorelease] ;
    [checkedProfiles release] ;
    
    return answer ;
}

+ (AddOnInstallStatus)addOnInstallStatusForProfile:(NSString*)profile {
    NSString* path = [self browserSupportPathForHomePath:NSHomeDirectory()] ;
    // path is now ~/Library/Application Support/Google/Chrome
    path = [path stringByAppendingPathComponent:profile] ;
    path = [path stringByAppendingPathComponent:constFilenameChromePreferences] ;
    NSDictionary* dic = [NSDictionary dictionaryFromJsonAtPath:path
                                                       error_p:NULL] ;
    // Start by assuming YES.
    AddOnInstallStatus status ;
    NSDictionary* ourExtensionDic = [dic valueForKeyPathArray:[[self class] keyPathInPrefsToExtension]] ;
    if (ourExtensionDic == nil) {
        status = AddOnInstallStatusNoObjection ;
    }
    else if ([ourExtensionDic respondsToSelector:@selector(objectForKey:)]) {
        status = AddOnInstallStatusInstalledEnabled ;
        NSNumber*  blacklistObject = [ourExtensionDic objectForKey:@"blacklist"] ;
        if (blacklistObject) {
            if ([blacklistObject respondsToSelector:@selector(boolValue)]) {
                if ([blacklistObject boolValue] == YES) {
                    status = AddOnInstallStatusBlacklisted ;
                }
            }
        }
        
        if (status == AddOnInstallStatusInstalledEnabled) {
            NSNumber*  stateObject = [ourExtensionDic objectForKey:constKeyState] ;
            if (stateObject) {
                if ([stateObject respondsToSelector:@selector(integerValue)]) {
                    NSInteger state = [stateObject integerValue] ;
                    // See note 20130130 below
                    switch (state) {
                        case 0:
                            status = AddOnInstallStatusInstalledDisabled ;
                            break ;
                        case 1:
                            status = AddOnInstallStatusInstalledEnabled ;
                            break ;
                        case 2:
                        default:
                            status = AddOnInstallStatusTrashed ;
                            break ;
                    }
                }
            }
            else {
                NSLog(@"Internal Error 624-4955 %@ %@", [self className], profile) ;
                status = AddOnInstallStatusUnknown ;
            }
        }
    }
    else {
        status = AddOnInstallStatusUnheardOf ;
    }
    
    return status ;
}

+ (NSSet*)profilesWithOurExtensionInstalled {
    NSSet* profiles = [self allProfiles] ;
    NSMutableSet* filteredProfiles = [[NSMutableSet alloc] init] ;
    for (NSString* profile in profiles) {
        AddOnInstallStatus status = [self addOnInstallStatusForProfile:profile] ;
        if (status == AddOnInstallStatusInstalledEnabled) {
            [filteredProfiles addObject:profile] ;            
        }
    }
    
    NSSet* answer = [[filteredProfiles copy] autorelease] ;
    [filteredProfiles release] ;
    
    return answer ;
}

/*
 Note 20130130
 From reverse engineering, the values of 'state' are:
 0 = installed but disabled
 1 = installed and enabled
 2 = trashed, no longer listed in Window > Extensions
 The last one seems kind of weird.  I wonder why they just don't remove
 the whole subdictionary?
 This was tested with another profile actively holding
 the extension.
*/

- (BOOL)uninstallExtensionError_p:(NSError**)error_p {
	BOOL ok = YES ;
	NSError* error = nil ;
	
    NSSet* profilesWithOurExtension = [[self class] profilesWithOurExtensionInstalled] ;
    NSInteger oneForUs = [profilesWithOurExtension member:[[self client] profileName]] != nil ? 1 : 0 ;
    if ([profilesWithOurExtension count] > oneForUs) {
        // Another profile is using our extension.  So we cannot remove our
        // extension's directory from the "External Extensions" subdirectory.
        // What we need to do is to set the 'state' in our extension's
        // subdictionary in this profile's Preferenes to 2.  Weird, but
        // see Note 20130130.  Note that if we were to completely remove our
        // extension's subdictionary, but leave the External Extension, Chrome
        // would restore it on the next launch, because that's how External
        // Extensions are in fact installed.
        
        ok = [self quitOwnerAppWithTimeout:10.0
                          killAfterTimeout:YES
                              wasRunning_p:NULL
                                   error_p:&error] ;
        if (!ok) {
            error = [SSYMakeError(849901, @"Could not quit browser") errorByAddingUnderlyingError:error] ;
            goto end ;
        }
        
        NSDictionary* prefs = [self thisProfilePrefsError_p:&error] ;
        if (!prefs) {
            error = [SSYMakeError(849338, @"Could not get prefs to trash extension") errorByAddingUnderlyingError:error] ;
            goto end ;
        }
        
        NSArray* keyPathArray = [[[self class] keyPathInPrefsToExtension] arrayByAddingObject:constKeyState] ;
        
        NSMutableDictionary* copy = (NSMutableDictionary*)[prefs mutableCopyDeepPropertyList] ;
        if (!copy) {
            ok = NO ;
            error = [SSYMakeError(442007, @"Could not copy prefs to trash extension.") errorByAddingUnderlyingError:error] ;
            goto end ;
        }
        
        [copy setValue:[NSNumber numberWithInteger:2]
       forKeyPathArray:keyPathArray] ;
        
        ok = [self setThisUserPrefs:copy
                            error_p:&error] ;
        [copy release] ;
        
        if (!ok) {
            error = [SSYMakeError(180936, @"Could not write prefs to trash extension") errorByAddingUnderlyingError:error] ;
            goto end ;
        }
    }
    else {
       // No other profile is currently using our extension.  In other words,
        // this profile is the last holdout.  So we wipe it out in both this
        // profile's Preferences, and in External Extensions.
        
        [self removeExtensionFromPrefsWithProgressView:nil] ;
        
        ok = [[NSFileManager defaultManager] removeThoughtfullyPath:[self externalExtensionFilePath]
                                                            error_p:&error] ;
        if (!ok) {
            error = [SSYMakeError(844951, @"Could not remove our External Extension") errorByAddingUnderlyingError:error] ;
            goto end ;
        }
    }

    // Finally, because the extension is currently loaded,
    [self quitOwnerAppCleanlyWithProgressView:nil
                                      error_p:&error] ;
    // Since error in that will fix itself when browser is quit, just log it.
    if (error) {
        NSLog(@"Internal Error 724-9494 %@", error) ;
    }
    
end:;
	if (error && error_p) {
		*error_p = error ;
	}

	
	 return ok ;
}

- (NSString*)launchOwnerAppPath:(NSString*)path
					   activate:(BOOL)activate
                        error_p:(NSError**)error_p {
    
    BOOL ok ;
    NSError* error = nil ;
    NSString* homePath = [[self client] homePath] ;
    NSString* errDesc ;
    
	if (!path) {
		path = [self ownerAppLocalPath] ;
	}
	
    ok = [self quitOwnerAppWithTimeout:10.0
                      killAfterTimeout:YES
                          wasRunning_p:NULL
                               error_p:&error] ;
    if (!ok) {
        errDesc = [NSString stringWithFormat:
                   @"Could not quit %@",
                   [[self client] displayName]] ;
        error = [SSYMakeError(883413, errDesc) errorByAddingUnderlyingError:error] ;
        goto end ;
    }
    
    // Set the preference to the relevant profile
    NSDictionary* localStateDic = [[self class] localStateDicOnceForHomePath:homePath] ;
    if (!localStateDic) {
        // No error, because this might be expected if the owner app client
        // had never been used
        localStateDic = [NSDictionary dictionary] ;
    }

    NSDictionary* profileDic = [localStateDic objectForKey:constKeyProfile] ;
    if (!profileDic) {
        // No error, because this might be expected if the owner app client
        // had never been used
        profileDic = [NSDictionary dictionary] ;
    }
    
    BOOL didFixDic = NO ;
    
    NSString* lastUsedProfile = [profileDic objectForKey:constKeyLastUsed] ;
    if (![lastUsedProfile isKindOfClass:[NSString class]]) {
        errDesc = [NSString stringWithFormat:@"%@ in %@ not a string",
                   constKeyLastUsed,
                   [[self client] displayName]] ;
        error = SSYMakeError(883553, errDesc) ;
        goto end ;
    }
    NSString* profile = [[[self client] clientoid] profileName] ;
    if (![profile isEqualToString:lastUsedProfile]) {
        profileDic = [profileDic dictionaryBySettingValue:profile
                                                   forKey:constKeyLastUsed] ;
        didFixDic = YES ;
    }
    
    NSArray* lastActiveProfiles = [profileDic objectForKey:constKeyLastActiveProfiles] ;
    if (lastActiveProfiles) {
        if (![lastActiveProfiles isKindOfClass:[NSArray class]]) {
            errDesc = [NSString stringWithFormat:@"%@ in %@ not an array",
                       constKeyLastActiveProfiles,
                       [[self client] displayName]] ;
            error = SSYMakeError(883555, errDesc) ;
            goto end ;
        }
    }
    else {
        lastActiveProfiles = [NSArray array] ;
    }
	if ([lastActiveProfiles indexOfObject:profile] == NSNotFound) {
        lastActiveProfiles = [lastActiveProfiles arrayByAddingObject:profile] ;
        profileDic = [profileDic dictionaryBySettingValue:lastActiveProfiles
                                                   forKey:constKeyLastActiveProfiles] ;
        didFixDic = YES ;
    }
    
    if (didFixDic) {
        localStateDic = [localStateDic dictionaryBySettingValue:profileDic
                                                         forKey:constKeyProfile] ;
        NSString* jsonString = [localStateDic jsonStringValue] ;
        NSString* localStateFilePath = [[self class] localStateFilePathForHomePath:homePath] ;
        BOOL ok = [[NSFileManager defaultManager] createDirectoryAtPath:[localStateFilePath stringByDeletingLastPathComponent]
                                            withIntermediateDirectories:YES
                                                             attributes:nil
                                                                  error:&error] ;
        if (!ok) {
            errDesc = [NSString stringWithFormat:@"Could not switch %@ into profile %@",
                       [[self client] displayName],
                       profile] ;
            error = [SSYMakeError(883556, errDesc) errorByAddingUnderlyingError:error] ;
            goto end ;
        }
        
        ok = [jsonString writeToFile:localStateFilePath
                          atomically:YES
                            encoding:NSUTF8StringEncoding
                               error:&error] ;
        if (!ok) {
            errDesc = [NSString stringWithFormat:@"Could not rewrite profile for %@ as %@",
                       [[self client] displayName],
                       profile] ;
            error = [SSYMakeError(883557, errDesc) errorByAddingUnderlyingError:error] ;
            goto end ;
        }
        
    }

	ok = [SSYOtherApper launchApplicationPath:path
                                     activate:activate
                                      error_p:&error] ;
    if (!ok) {
        errDesc = [NSString stringWithFormat:@"Could not launch %@ into profile %@ at path %@",
                   [[self client] displayName],
                   profile,
                   path] ;
        error = [SSYMakeError(883558, errDesc) errorByAddingUnderlyingError:error] ;
        goto end ;
    }
    
end:
    if (error && error_p) {
        *error_p = error ;
    }
    
    return path ;
}

- (BOOL)prepareBrowserForExportWithInfo:(NSMutableDictionary*)info
								error_p:(NSError**)error_p {
    BOOL ok = YES ;
	NSError* error = nil ;
    
    BOOL syncActive = [self isSyncActiveError_p:&error] ;
	if (syncActive) {
        // We have two more tasks to do if browser's sync is active
        
        // Task 1.  Maybe warn the user about conficts with browser's sync
 		BOOL secondPrep = [[info objectForKey:constKeySecondPrep] boolValue] ;
		if (secondPrep) {
            if ([[[self client]  extoreMedia] isEqualToString:constBkmxExtoreMediaThisUser]) {
                if (![[self client] dontWarnOwnerSync]) {
                    SEL dontWarnOwnerSyncSelector = @selector(didEndDontWarnOwnerSyncSheet:returnCode:contextInfo:) ;
                    SEL runSheetSelector = @selector(runModalSheetAlert:iconStyle:modalDelegate:didEndSelector:contextInfo:) ;
                    
                    if (!error) {
                        if (syncActive) {
                            SSYAlert* alert = [SSYAlert alert] ;
                            NSString* displayName = [(Client*)[(Extore*)[info objectForKey:constKeyExtore] client] displayName] ;
                            // displayName may be either "Chrome" or "Chromium"
                            NSString* title = [NSString stringWithFormat:
                                               @"Warning : %@ Syncing",
                                               displayName] ;
                            [alert setTitleText:title] ;
                            NSString* msg = [NSString stringWithFormat:
                                             @"It appears that you have %@'s built-in Sync syncing your bookmarks.\n\n"
                                             @"Please make sure that you have not created a Sync Loop.  Click the '?' Help button below to learn more.",
                                             displayName] ;
                            
                            Client* client = [self client] ;
                            // Next lines to fix crash in BookMacster 1.13.2
                            // If this is a One Time Export, the checkbox for future is
                            // not applicable.  Furthermore, it will case a Core Data
                            // Could Not Fulfill a Fault error because it will be
                            // celeted by the time the checkbox result is known
                            // and attempted to be set into the data model.
                            if ([[info objectForKey:constKeyClientShouldSelfDestruct] boolValue] != YES) {
                                // Client is permanent
                                [alert setCheckboxTitle:[@"I know I don't have a Sync Loop.  " stringByAppendingString:[NSString localize:@"dontShowAdvisoryAgain"]]] ;
                            }
                            else {
                                // Client is temporary, for One Time Export
                                // No isDoneSelector needed in Chrome Sync warning sheet
                                client = nil ;
                                dontWarnOwnerSyncSelector = NULL ;
                            }
                            
                            [alert setSmallText:msg] ;
                            [alert setHelpAnchor:constHelpAnchorChromyBuiltInSync] ;
                            NSInteger iconStyle = SSYAlertIconInformational ;
                            NSInvocation* invocation = [NSInvocation invocationWithTarget:[info objectForKey:constKeyDocument]
                                                                                 selector:runSheetSelector
                                                                          retainArguments:YES
                                                                        argumentAddresses:
                                                        &alert,
                                                        &iconStyle,
                                                        &client,
                                                        &dontWarnOwnerSyncSelector,
                                                        NULL] ; // contextInfo
                            [info addObject:invocation
                               toArrayAtKey:constKeyMoreDoneInvocations] ;
                            
                        }
                    }
                    else {
                        ok = NO ;
                    }
                }
            }
        }
        
        // Task 2.  Launch the application if it is not running (Added in BookMacster 1.13.1)
        OwnerAppRunningState runningState = [self ownerAppRunningStateError_p:&error] ;
        switch (runningState) {
            case OwnerAppRunningStateNotRunning:
                ok = ([self launchOwnerAppPath:nil
                                      activate:NO
                                       error_p:&error] != nil) ;

               if (ok) {
                    [self setOwnerAppQuinchState:OwnerAppQuinchStateDidLaunch] ;
                }
                else {
                    NSString* msg = [NSString stringWithFormat:
                                     @"Need to launch %@, because you are using its built-in Sync, but could not launch %@.",
                                     [self ownerAppDisplayName],
                                     [self ownerAppDisplayName],
                                     nil] ;
                    error = [SSYMakeError(502938, msg) errorByAddingUnderlyingError:error] ;
                }
                break ;
            case OwnerAppRunningStateRunningProfileFront:
                break ;
            case OwnerAppRunningStateRunningProfileWrong:
                NSLog(@"Internal") ;
                break ;
            case OwnerAppRunningStateError:
                ok = NO ;
                break ;
        }
	}
	
	[info setObject:[NSNumber numberWithBool:ok]
			 forKey:constKeySucceeded] ;
	[self sendIsDoneMessageFromInfo:info] ;
    
    if (error_p && error) {
        *error_p = error ;
    }
	
	return ok ;
}

/*
 *  EXPORT TRUTH TABLE FOR CLIENTS WITH BUILT-IN SYNC (FIREFOX, CHROMY)
 *

 * "prepare tasks" are performed in -[Extore prepareBrowserForExportWithInfo:]

 *             profile    is        |
 *  is         is         built-in  |
 *  browser    current    sync      |  prepare
 *  running    profile    active    |  tasks
 *  -------    -------    ------    -  --------
 *  NO         NO         NO        |  noop
 *  NO         NO         YES       |  setProfile, launch
 *  NO         YES        NO        |  noop
 *  NO         YES        YES       |  launch
 *  YES        NO         NO        |  warnQuitThenQuit
 *  YES        NO         YES       |  warnQuitThenQuit, setProfile, launch
 *  YES        YES        NO        |  noop
 *  YES        YES        YES       |  noop
 *
 *
 *             profile    is        |
 *  is         is         built-in  |
 *  browser    current    sync      |
 *  running    profile    active    |  export
 *  -------    -------    ------    -  --------
 *  NO         NO         NO        |  style1
 *  NO         NO         YES       |  style2
 *  NO         YES        NO        |  style1
 *  NO         YES        YES       |  style2
 *  YES        NO         NO        |  style1
 *  YES        NO         YES       |  style2
 *  YES        YES        NO        |  style2
 *  YES        YES        YES       |  style2
 */

- (NSDictionary*)extensionManifest {
	NSString* manifestPath = [self extensionManifestPath] ;
	NSString* manifestString = [NSString stringWithContentsOfFile:manifestPath
														 encoding:NSUTF8StringEncoding
															error:NULL] ;
	NSDictionary* extensionManifest = [NSDictionary dictionaryWithJSONString:manifestString
																  accurately:NO] ;
	return extensionManifest ;
}

- (BOOL)setExtensionManifest:(NSDictionary*)manifest
					 error_p:(NSError**)error_p {
	BOOL ok = YES ;
	NSError* error = nil ;
	
	NSString* manifestString = [manifest jsonStringValue] ;
	
	NSString* path = [self extensionManifestPath] ;
	
	ok = [manifestString writeToFile:path
						  atomically:YES
							encoding:NSUTF8StringEncoding
							   error:&error] ;
	if (!ok) {
		goto end ;
	}
	
end:
	if (!ok && error_p) {
		*error_p = error ;
	}
	
	return ok ;
}



- (BOOL)widgetize:(BOOL)yn
		  error_p:(NSError**)error_p {
	NSInteger hasWidget = [self hasWidget] ;
	if (yn && (hasWidget == NSOnState)) {
		// No change needed
		return YES ;
	}
	if (!yn && (hasWidget == NSOffState)) {
		// No change needed
		return YES ;
	}
	
	NSError* error = nil ;
	BOOL ok = YES ;
	
	ok = [self uninstallExtensionError_p:&error] ;
	if (!ok) {
		goto end ;
	}

	ok = [self installExtensionInfo:nil
						  widgetize:(yn ? NSOnState : NSOffState)
							error_p:&error] ;
	if (!ok) {
		goto end ;
	}
	
	ok = [self quitOwnerAppCleanlyWithProgressView:nil
										   error_p:&error] ;
	if (!ok) {
		goto end ;
	}
	
end:;
	if (error && error_p) {
		*error_p = error ;
	}
	
	return ok ;
}

@end