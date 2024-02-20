#import <Bkmxwork/Bkmxwork-Swift.h>
//#import <BkmxAgentRunner/BkmxAgentRunner-Swift.h>
//#import <BkmxAgentRunner-Swift.h>
//#import "/Users/jk/Library/Developer/Xcode/DerivedData/BkmkMgrs-dgajrgxroulefweqxsvazigfeucy/Build/Intermediates.noindex/BkmkMgrs.build/Debug/BkmxAgentRunner.build/Objects-normal/arm64/BkmxAgentRunner-Swift.h"
#import <ServiceManagement/ServiceManagement.h>
#import "NSError+MyDomain.h"
#import "NSError+DecodeCodes.h"
#import "NSError+SSYInfo.h"
#import "NSString+LocalizeSSY.h"
#import "NSArray+SafeGetters.h"
#import "NSString+SSYDotSuffix.h"
#import "NSArray+SortDescriptorsHelp.h"
#import "SSYOtherApper.h"
#import "NSArray+SSYMutations.h"
#import "BkmxBasis.h"
#import "NSError+InfoAccess.h"
#import "BkmxAppDel.h"
#import "SUUpdater.h"
#import "NSBundle+SSYMotherApp.h"
#import "SSYMH.AppAnchors.h"
#import "SSYLicensingParms.h"
#import "BkmxBasis+Strings.h"
#import "ExtoreWebFlat.h"
#import "SSYMOCManager.h"
#import "SSYMojo.h"
#import "IxportLog.h"
#import "SSYLicense.h"
#import "SSWebBrowsing.h"
#import "Macster.h"
#import "NSObject+MoreDescriptions.h"
#import "NSString+VarArgs.h"
#import "MessageLog.h"
#import "ErrorLog.h"
#import "NSDate+NiceFormats.h"
#import "NSManagedObjectContext+Cheats.h"
#import "NSString+SSYExtraUtils.h"
#import "SSYShellTasker.h"
#import "SSYUuid.h"
#import "BkmxDoc.h"
#import "NSError+LowLevel.h"
#import "SSYXugradeApp.h"
#import "NSBundle+MainApp.h"
#import "SUConstants.h"
#import "NSDictionary+SimpleMutations.h"
#import "NSUserDefaults+MainApp.h"
#import "SSYUserInfo.h"
#import "NSFileManager+SomeMore.h"
#import "SSYSystemUptimer.h"
#import "Job.h"
#import "AgentPerformer.h"
#import "NSUserDefaults+Bkmx.h"
#import "Stager.h"
#import "SSYInterappClient.h"
#import "NSWorkspace+AppleShoulda.h"
#import "SSYAppInfo.h"
#import "NSError+Recovery.h"
#import "BkmxNotifierCaller.h"
#import "BkmxBasis+OSLog.h"
#import "NSBundle+HelperPaths.h"


NSString* const constNoteBkmxAutosaveMocIsDirty = @"BkmxAutosaveMocIsDirty" ;

static BkmxBasis* sharedBasis = nil ;

NSString* const constKeyMarkAsPresented = @"presented" ;

NSString* const constBaseNameLogs = @"Logs" ;
NSString* const constBaseNameExids = @"Exids" ;
NSString* const constBaseNameSettings = @"Settings" ;
NSString* const constBaseNameDiaries = @"Diaries" ;

@interface BkmxBasis () 

@property (retain) NSDictionary* starkAttributeTypes ;
@property (retain) NSMutableString* trace ;
@property (assign) NSInteger traceLevel ;

@end

@implementation BkmxBasis

@synthesize starkAttributeTypes = m_starkAttributeTypes ;
@synthesize currentAppleScriptCommand = m_currentAppleScriptCommand ;

+ (NSString*)companyIdentifier {
    NSString* identifier = [[NSBundle mainAppBundle] bundleIdentifier] ;
    identifier = [identifier stringByDeletingDotSuffix] ;
    return identifier ;
}

+ (NSString*)appIdentifierForAppName:(NSString*)appName {
    NSString* identifier = [self companyIdentifier] ;
    identifier = [identifier stringByAppendingDotSuffix:appName] ;
	return identifier ;
}

+ (NSString*)appIdentifierForThisApp {
	return [[NSBundle mainAppBundle] bundleIdentifier] ;
}

+ (BkmxWhichApps)whichAppsFromWhich1App:(BkmxWhich1App)which1App {
    BkmxWhichApps whichApps;
    switch (which1App) {
        case BkmxWhich1AppSmarky:
            whichApps = BkmxWhichAppsSmarky;
            break;
        case BkmxWhich1AppSynkmark:
            whichApps = BkmxWhichAppsSynkmark;
            break;
        case BkmxWhich1AppMarkster:
            whichApps = BkmxWhichAppsMarkster;
            break;
        case BkmxWhich1AppBookMacster:
            whichApps = BkmxWhichAppsBookMacster;
            break;
    }

    return whichApps;
}

- (BOOL)isScripted {
	return ([self currentAppleScriptCommand] != nil) ;
}

- (NSManagedObjectContext*)mocWithFilename:(NSString*)identifier
                         recreateIfCorrupt:(BOOL)recreateIfCorrupt
                                   error_p:(NSError**)error_p {
	if (!identifier) {
		return nil ;
	}
	
	NSError* error = nil ;
	NSManagedObjectContext* moc = [SSYMOCManager managedObjectContextType:NSSQLiteStoreType
																	owner:nil
															   identifier:identifier
																 momdName:constNameMomd
                                                        recreateIfCorrupt:recreateIfCorrupt
																  error_p:&error] ;
    /* In BkmkMgrs 3.1, when  I replaced calls to deprecated
     SMLoginItemSetEnabled() with  calls to the new SMAppService methods
     when @available(macOS 13,  I found that when SMAppService was called upon
     to switch BkmxAgent ON (or maybe it was off), a crash would occur in this
     method when calling either -setMergePolicy: or setUndoManager:.
     
     Before the crash, execution would apparently pause because you could
     see this function running succesfully to return other mocs, apparently
     on other threads.  So it looks like the thread of the crashed call
     got pre-empted by the running of  SMAppService.  The crash would occur
     because, whe execution resumed after the pre-emption, `moc` had been
     deallocced.  Very strange, but reproducible.  It seemed to be random
     which of the several calls to this function areound the time of
     SMAppService action would get pre-empted and crash.  Sometimes it was
     getting an Exids moc, sometimes a Settings moc, and if I remember
     correctlly somtimes a Logs moc.
     
     David Philip Oster suggested that this might be because the SMAppService
     function is spinning the run loop, releasing all autorelease pools.
     
     Anyhow, to fix this, I added the following retain, and the autorelease
     at the end. */
    [moc retain];

	[moc setMergePolicy:NSOverwriteMergePolicy] ;

	// Since appPersistentMoc objects do not support undo.
	[moc setUndoManager:nil] ;

    if (error && error_p) {
        *error_p = error ;
    }

    return [moc autorelease];
}

- (NSManagedObjectContext*)mocWithFilename:(NSString*)filename
                                   error_p:(NSError**)error_p {
    NSError* error = nil;
    NSManagedObjectContext* moc = [self mocWithFilename:filename
                                      recreateIfCorrupt:NO
                                                error_p:&error];
    if (error && error_p) {
        *error_p = error ;
    }
    
    return moc;
}

- (void)saveAppPersistentMocIdentifier:(NSString*)identifier {
	if (!identifier) {
		return ;
	}
	
	NSError* error = nil;
    NSManagedObjectContext* moc = [self mocWithFilename:identifier
                                                error_p:&error];
    BOOL ok = (moc != nil);
    if (ok) {
        ok = [moc save:&error];
    }
    
    if (!ok) {
        NSString* msg = [NSString stringWithFormat:
                         @"Could not save managed object context \"%@\"",
                         identifier] ;
        error = [SSYMakeError(513560, msg) errorByAddingUnderlyingError:error] ;
        // Until BookMacster 1.11, I alerted the user here.  I have received a
        // few of them from users recently, and if I recall correctly they all
        // were due to Logs.sql.  Definitely *not* a show-stopper for the user!
        
        // I suppose that maybe I should delete the file, so a new one will be
        // created?  But I don't know.  We'll leave it like this for a while
        // and see how it works.
        error = [error errorByAddingBacktrace] ;
        [self logError:error
       markAsPresented:NO];
    }
        
}

- (NSString*)filenameForMocName:(NSString*)mocName
					 identifier:(NSString*)identifier {
	if (!identifier) {
		return nil ;
	}
	
	return [NSString stringWithFormat:
			@"%@-%@",
			mocName,
			identifier] ;
}

- (NSString*)identifierFromFilename:(NSString*)filename
							mocName:(NSString*)mocName {
	// +1 for the dash…
	NSInteger prefixLength = [mocName length] + 1 ;
	NSString* identifier ;
	if ([filename length] > prefixLength) {
		identifier = [filename substringFromIndex:prefixLength] ;
	}
	else {
		identifier = nil ;
	}
	
	return identifier ;
}

- (NSString*)exidsMocFilenameForIdentifier:(NSString*)identifier {
    NSString* filename = [self filenameForMocName:constBaseNameExids
                                       identifier:identifier] ;
    return filename ;
}

- (NSManagedObjectContext*)exidsMocIgnoringError:(BOOL)ignoreError
									  identifier:(NSString*)identifier {
    NSError* error = nil;
    NSManagedObjectContext* moc = [self mocWithFilename:[self exidsMocFilenameForIdentifier:identifier]
                                      recreateIfCorrupt:!ignoreError
                                                error_p:&error];
    if (error) {
        [self logError:error
       markAsPresented:NO];
    }
    
    return moc;
}

- (NSManagedObjectContext*)exidsMocForIdentifier:(NSString*)identifier {
    NSError* error = nil;
    NSManagedObjectContext* moc = [self mocWithFilename:[self exidsMocFilenameForIdentifier:identifier]
                                                error_p:&error  ];
    if (error) {
        [self logError:error
       markAsPresented:NO];
    }
    
    return moc;
}

#if 0
// This method is not used, because we have -[[BkmxDoc starxider] save:]
- (void)saveExidsMocForIdentifier:(NSString*)identifier {
	[self saveAppPersistentMocIdentifier:[self nameForMoc:constBaseNameExids
											   identifier:identifier]] ;
}
#endif

- (NSString*)settingsMocFilenameForIdentifier:(NSString*)identifier {
    NSString* filename = [self filenameForMocName:constBaseNameSettings
                                       identifier:identifier] ;
    return filename ;
}

- (NSManagedObjectContext*)settingsMocIgnoringError:(BOOL)ignoreError
										 identifier:(NSString*)identifier {
    NSError* error = nil;
    NSManagedObjectContext* moc = [self mocWithFilename:[self settingsMocFilenameForIdentifier:identifier]
                                      recreateIfCorrupt:!ignoreError
                                                error_p:&error];
    if (error) {
        [self logError:error
       markAsPresented:NO];
    }
    
    return moc;
}

- (NSManagedObjectContext*)settingsMocForIdentifier:(NSString*)identifier
                                            error_p:(NSError**)error_p {
    NSError* error = nil;
    NSManagedObjectContext* moc = [self mocWithFilename:[self settingsMocFilenameForIdentifier:identifier]
                                                error_p:&error];
    if (error && error_p) {
        *error_p = error ;
    }

    return moc;
}

- (NSArray*)allSettingsMocsOnDisk {
    NSError* error = nil ;
    
    NSString* path = [SSYMOCManager directoryOfSqliteMOCs] ;
    NSArray* candidates = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path
                                                                              error:&error] ;
    NSMutableArray* mocs = [[NSMutableArray alloc] init] ;
    for (NSString* candidate in candidates) {
        if ([candidate hasPrefix:constBaseNameSettings]) {
            // Next line is to ignore -shm and -wal files
            if ([candidate hasSuffix:SSYManagedObjectContextPathExtensionForSqliteStores]) {
                NSString* candidateName = [candidate stringByDeletingPathExtension] ;
                if (![candidateName hasSuffix:@"~"]) {
                    NSRange range = [candidateName rangeOfString:constBaseNameSettings] ;
                    NSInteger location = range.location + range.length + 1 ;  // + 1 for "-"
                    if (location < [candidateName length]) {
                        NSString* identifier = [candidateName substringFromIndex:location];
                        NSError* error = nil;
                        NSManagedObjectContext* moc = [self settingsMocForIdentifier:identifier
                                                                             error_p:&error];
                        if (moc) {
                            [mocs addObject:moc];
                        }
                        if (error) {
                            [self logError:error
                           markAsPresented:NO];
                        }
                    }
                }
            }
        }
    }
    
    NSArray* answer = [mocs copy] ;
    [mocs release] ;
    
    return [answer autorelease] ;
}

- (void)saveSettingsMocForIdentifier:(NSString*)identifier {
	[self saveAppPersistentMocIdentifier:[self filenameForMocName:constBaseNameSettings
													   identifier:identifier]] ;
}

- (NSManagedObjectContext*)logsMoc {
    if (m_loggingDisabled) {
        return nil;
    }

    NSError* error = nil;
    NSManagedObjectContext* moc = [self mocWithFilename:constBaseNameLogs
                                      recreateIfCorrupt:YES
                                                error_p:&error];
    if (error) {
        /* Logging here with -[BkmxBasis logError:markAsPresented:] would
         result in an infinite loop, don't do that! */
        NSLog(@"Internal Error 383-9427 %@", error);
    }
    
    return moc;
}

- (void)disableLogging {
	[SSYMOCManager destroyManagedObjectContext:[self logsMoc]] ;
	m_loggingDisabled = YES ;
}

- (void)saveLogsMoc {
	[self saveAppPersistentMocIdentifier:constBaseNameLogs] ;
}

- (NSManagedObjectContext*)diariesMocForIdentifier:(NSString*)identifier
									 ignoringError:(BOOL)ignoreError {
    NSError* error = nil;
    NSManagedObjectContext* moc = [self mocWithFilename:[self filenameForMocName:constBaseNameDiaries
                                                                      identifier:identifier]
                                      recreateIfCorrupt:!ignoreError
                                                error_p:&error];
    if (error) {
        [self logError:error
       markAsPresented:NO];
    }
    
    return moc;
}

- (NSManagedObjectContext*)diariesMocForIdentifier:(NSString*)identifier {
    NSError* error = nil;
    NSString* wholeIdentifier = [self filenameForMocName:constBaseNameDiaries
                                              identifier:identifier];
    NSManagedObjectContext* moc = [self mocWithFilename:wholeIdentifier
                                                error_p:&error  ];
    if (error) {
        [self logError:error
       markAsPresented:NO];
    }
    
    return moc;
}

- (void)saveDiariesMocForIdentifier:(NSString*)identifier {
	[self saveAppPersistentMocIdentifier:[self filenameForMocName:constBaseNameDiaries
													   identifier:identifier]] ;
}

- (BOOL)hasUnpresentedErrors {
	NSManagedObjectContext* logsMoc = [self logsMoc] ;
	SSYMojo* mojo = [[SSYMojo alloc] initWithManagedObjectContext:logsMoc
													   entityName:constEntityNameErrorLog] ;
	
	NSExpression* lhs = [NSExpression expressionForKeyPath:constKeyPresented] ;
	NSExpression* rhs = [NSExpression expressionForConstantValue:[NSNumber numberWithBool:YES]] ;
	NSPredicate *deadLogPred = [NSComparisonPredicate predicateWithLeftExpression:lhs
																  rightExpression:rhs
																		 modifier:NSDirectPredicateModifier
																			 type:NSNotEqualToPredicateOperatorType
																		  options:0] ;
	
	NSError* error = nil ;
	NSArray* unpresentedErrors = [mojo objectsWithPredicate:deadLogPred
													error_p:&error] ;
	if (error) {
		error = [SSYMakeError(138570, @"Error fetching unpresented errors") errorByAddingUnderlyingError:error] ;
		[SSYAlert alertError:error] ;
	}
	
	[mojo release] ;
	
	return ([unpresentedErrors count] > 0) ;
}

- (void)unsafe_logFormat:(NSDictionary*)info {
	NSManagedObjectContext* logsMoc = [self logsMoc] ;
	if (logsMoc) {
        NSString* message = [info objectForKey:constKeyMessage] ;
        NSDate* timestamp = [info objectForKey:constKeyTimestamp] ;
		MessageLog* messageLog = [NSEntityDescription insertNewObjectForEntityForName:constEntityNameMessageLog
															   inManagedObjectContext:logsMoc] ;
		
		[messageLog setMessage:message] ;
        [messageLog setTimestamp:timestamp] ;
		[self saveLogsMoc] ;

#if 0
#warning Logging Messages to Console Too
        if ([self isBkmxAgent]) {
            [self consoleLogAsError:NO format:message];
        } else {
            NSLog(@"%@", message) ;
        }
#endif
    }
	
#if DEBUG
	// This makes BkmxAgent log entries display immediately in menu ▸ BookMacster ▸ Logs…
	// No need to push the "Refresh" button.
	// The price is using additional system overhead.
	if ([[BkmxBasis sharedBasis] isBkmxAgent]) {
		NSDistributedNotificationCenter* nc = [NSDistributedNotificationCenter defaultCenter] ;
		[nc postNotificationName:[self messageLoggedNotificationName]
						  object:constNameBkmxDistributedNote] ;
	}
#endif
}

- (void)logFormat:(NSString*)formatString, ... {
	if ([[NSUserDefaults standardUserDefaults] syncAndGetMainAppIntegerForKey:constKeyDaysLog] == 0) {
		return ;
	}
	
	NSString* processedString ;

    if ([formatString length] == 0) {
        processedString = [NSString stringWithFormat:@"No log entry from %@", SSYDebugCaller()];
	} else {
		va_list argPtr ;
		va_list* argPtr_p = &argPtr ;
		
		va_start(argPtr, formatString) ;
		processedString = [NSString replacePlaceholdersInString:formatString
													   argPtr_p:argPtr_p];
		va_end(argPtr) ;

        if ([processedString length] == 0) {
            processedString = [NSString stringWithFormat:
                               @"Failed processing log entry from %@ beginning with %@",
                               SSYDebugCaller(),
                               formatString];
        }
	}

    [self logString:processedString];
}

- (void)logString:(NSString*)message {
    if ([[NSUserDefaults standardUserDefaults] syncAndGetMainAppIntegerForKey:constKeyDaysLog] == 0) {
        return ;
    }

    if ([message length] == 0) {
        message = [NSString stringWithFormat:@"No log entry from %@", SSYDebugCaller()];
    }

    NSInteger jobSerial = [[AgentPerformer sharedPerformer] nowWorkingJobSerial];
    if (jobSerial > 0) {
        message = [NSString stringWithFormat:
                           @"?J%@: %@",
                           [Job serialStringForSerial:jobSerial],
                           message];
    }

    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
                          message, constKeyMessage,
                          [NSDate date], constKeyTimestamp,
                          nil];
    /* We got timestamp now because after this things get asynchronous. */

    [self performSelectorOnMainThread:@selector(unsafe_logFormat:)
                           withObject:info
                        waitUntilDone:NO] ;  // See OkToWait
}

- (void)forJobSerial:(NSInteger)jobSerial
           logFormat:(NSString*)formatString, ... {
    if ([[NSUserDefaults standardUserDefaults] syncAndGetMainAppIntegerForKey:constKeyDaysLog] == 0) {
        return ;
    }

    NSString* processedString ;
    BOOL canDo = YES ;

    if (formatString == nil) {
        processedString = nil ;
        canDo = NO ;
    }

    if ([formatString length] == 0) {
        processedString = formatString ;
        canDo = NO ;
    }

    if (canDo) {
        va_list argPtr ;
        va_list* argPtr_p = &argPtr ;

        va_start(argPtr, formatString) ;
        processedString = [NSString replacePlaceholdersInString:formatString
                                                       argPtr_p:argPtr_p];
        va_end(argPtr) ;
    }

    [self forJobSerial:jobSerial
             logString:processedString];
}

- (void)forJobSerial:(NSInteger)jobSerial
           logString:(NSString*)string {
    if ([[NSUserDefaults standardUserDefaults] syncAndGetMainAppIntegerForKey:constKeyDaysLog] == 0) {
        return ;
    }

    if (jobSerial > 0) {
        string = [NSString stringWithFormat:
                           @"!J%@: %@",
                           [Job serialStringForSerial:jobSerial],
                           string];
    }

    if (string.length > 0) {
        NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
                              string, constKeyMessage,
                              [NSDate date], constKeyTimestamp,
                              nil] ;
        /* We got timestamp now because after this things get asynchronous. */

        [self performSelectorOnMainThread:@selector(unsafe_logFormat:)
                               withObject:info
                            waitUntilDone:NO]; // See OkToWait
    }
}


- (void)unsafe_logErrorInfo:(NSDictionary*)info {
	BOOL markAsPresented = [[info objectForKey:constKeyMarkAsPresented] boolValue] ;
	NSError* error = [info objectForKey:constKeyError] ;
	NSManagedObjectContext* managedObjectContext = [self logsMoc] ;
	if (!managedObjectContext) {
		NSLog(@"Internal Error 153-0581 Could not log error: %@", error) ;
		return ;
	}
	ErrorLog* errorLog = [NSEntityDescription insertNewObjectForEntityForName:constEntityNameErrorLog
													   inManagedObjectContext:managedObjectContext] ;
	
	[errorLog setError:error] ;
    if (markAsPresented) {
		[errorLog markAsPresented] ;
	}
    NSError* savingError = nil;
	if (![managedObjectContext save:&savingError]) {
		NSLog(@"Internal Error 541-2750 Could not save moc at %@ due to %@", [managedObjectContext path1], savingError) ;
		return ;
	}
}

- (BOOL)checkIfLicensed {
	NSString* appName = [self appNameUnlocalized] ;
	NSData* data = [appName dataUsingEncoding:NSWindowsCP1252StringEncoding] ;
	char* bytes ;
    [data getBytes:&bytes
            length:[data length]] ;
	for (NSInteger i=0; i<[data length]; i++) {
		bytes[i] = bytes[i] * bytes[i+1] ;
	}
	return bytes[[data length]] * bytes[[data length]-1]== 28393 ;
}

- (void)logError:(NSError*)error
 markAsPresented:(BOOL)markAsPresented {
    if (!error) {
        return;
    }

	// Defensive programming
    NSInteger daysLog = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppIntegerForKey:constKeyDaysLog] ;
	if (daysLog == 0) {
		return ;
	}
	
	if ([error involvesCode:NSUserCancelledError
				     domain:NSCocoaErrorDomain]) {
		return ;
	}
    
    if ([error involvesCode:constBkmxErrorNoChangesToExport
                     domain:[NSError myDomain]]) {
        return ;
    }
	
	// To confuse crackers, change the Method Name 'checkBreath', which occurs
	// when exporting or saving fails due to lack of valid License Information,
	// to 'checkIfLicensed', which doesn't really exist, in order to send them
	// on a wild goose chase.
	NSString* methodName = [[error userInfo] objectForKey:SSYMethodNameErrorKey] ;
	if ([methodName containsString:@"checkBreath"]) {
		error = [error errorByOverwritingUserInfoObject:@"checkIfLicensed"
												 forKey:SSYMethodNameErrorKey] ;
		// Method -checkIfLicensed is an unused nonsense method, so this might
		// cause the crackers to waste some time scratching their heads.
	}
	

	NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
						  [NSNumber numberWithBool:markAsPresented], constKeyMarkAsPresented,
						  error, constKeyError,
						  nil];
    if ([[NSThread currentThread] isMainThread]) {
        /* This branch was added for Agent wherein I think we are on the main
         thread, and because the 'else' branch below will only log the error
         after the main thread is idle, and when we are called from
         -[AgentPerformer alertError:], that will not be until after the
         CFAlert dialog is dismissed by the user.  If the user clicked
         "View", the new error will not be in the Logs.sql database yet,
         and the previous error will be displayed instead. */
        [self unsafe_logErrorInfo:info];
    } else {
        /* We use waitUntilDone:NO in the following call to prevent a
         deadlock which would otherwise occur during asynchronous saving.
         I don't think that there is any hurry to write  this log entry
         before proceeding. */
        [self performSelectorOnMainThread:@selector(unsafe_logErrorInfo:)
                               withObject:info
                            waitUntilDone:NO];
    }
}

- (void)deleteObjectsOfEntity:(NSString*)entityName
					olderThan:(NSDate*)cutoffDate
		 managedObjectContext:(NSManagedObjectContext*)managedObjectContext {
	NSExpression* lhs = [NSExpression expressionForKeyPath:constKeyTimestamp] ;
	NSExpression* rhs = [NSExpression expressionForConstantValue:cutoffDate];
	NSPredicate *deadLogPred = [NSComparisonPredicate predicateWithLeftExpression:lhs
																  rightExpression:rhs
																		 modifier:NSDirectPredicateModifier
																			 type:NSLessThanPredicateOperatorType
																		  options:0] ;
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.predicate = deadLogPred;

    [managedObjectContext performBlock:^{
        NSError* error = nil;
        NSArray* condemnees = [managedObjectContext executeFetchRequest:request
                                                               error:&error];
        if (error) {
            error = [error errorByAddingIsOnlyInformational];
            [self logError:error
           markAsPresented:NO];
        }
        
        for (LogEntry* condemnee in condemnees) {
            [managedObjectContext deleteObject:condemnee] ;
        }

        @try {
            /* An error is expcted in the next line if  user clicks
             "Reset and Start Over", and in any case it is not a big deal.
             So we ignore any error*/
            [managedObjectContext save:NULL];
        }
        @catch (NSException* exception) {
            // User does not want to be annoyed with this.  Just log it.
            NSLog(@"Internal Error 192-0129 %@", exception) ;
        }
        @finally{
        }
    }];
}

- (void)cleanDefunctLogEntries {
	NSInteger daysLimit ;
	NSDate* cutoffDate ;
	
	daysLimit = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppIntegerForKey:constKeyDaysLog] ;
	cutoffDate = [NSDate dateWithTimeIntervalSinceNow:-(daysLimit*[BkmxBasis secondsPerDay])] ;
	
	[self deleteObjectsOfEntity:constEntityNameErrorLog
					  olderThan:cutoffDate
		   managedObjectContext:[self logsMoc]] ;
	
	[self deleteObjectsOfEntity:constEntityNameMessageLog
					  olderThan:cutoffDate
		   managedObjectContext:[self logsMoc]] ;
}

- (NSInteger)lastIxportSerialValueForBkmxDocUuid:(NSString*)bkmxDocUuid {
	SSYMojo* mojo = [[SSYMojo alloc] initWithManagedObjectContext:[self diariesMocForIdentifier:bkmxDocUuid]
													   entityName:constEntityNameIxportLog] ;
	NSError* error = nil ;
	NSMutableArray* ixportDiaries = [[mojo allObjectsError_p:&error] mutableCopy] ;
	[mojo release] ;
	[SSYAlert alertError:error] ;
	NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:constKeySerialNumber
																   ascending:YES] ;
	[ixportDiaries sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] ;
	[sortDescriptor release] ;
	NSInteger count = [ixportDiaries count] ;
	NSInteger lastSerialValue ;
	if (count > 0) {
		IxportLog* lastIxportLog = [ixportDiaries objectAtIndex:(count -1)] ;
		lastSerialValue = [[lastIxportLog serialNumber] integerValue] ;
	}
	else {
		lastSerialValue = 0 ;
		// So the "first", next serial value will be #1.
	}
	[ixportDiaries release] ;
    
	return lastSerialValue ;
}

- (void)deleteAllObjectsOfEntities:(NSArray*)entityNames
					   mocBaseName:(NSString*)mocBaseName
						identifier:(NSString*)identifier {
    NSError* error = nil;
	NSManagedObjectContext* moc = [self mocWithFilename:[self filenameForMocName:mocBaseName
                                                                      identifier:identifier]
                                                error_p:&error];

    if (moc != nil) {
        for (NSString* entityName in entityNames) {
            SSYMojo* mojo = [[SSYMojo alloc] initWithManagedObjectContext:moc
                                                               entityName:entityName] ;
            BOOL ok = [mojo deleteAllObjectsError_p:&error] ;
            if (!ok) {
                NSLog(@"Error 654231 cleaning up %@ in %@-%@:\n%@",
                      entityName,
                      mocBaseName,
                      identifier,
                      [error longDescription]) ;
            }
            [mojo release] ;
        }
        
        [moc save:&error] ;
    }
    
    if (error) {
        [self logError:error
       markAsPresented:NO];
    }
}

- (BOOL)shouldHideError:(NSError*)error {
	if (!error) {
		return YES ;
	}
	while ([error isKindOfClass:[NSError class]]) {
		NSString* domain = [error domain];
        /* We must run the BkmxAgent branch first, because in BkmxAgent,
         [NSError myDomain] is the same as the bundle identifier we compare
         it to in the next line.  Thus, BkmxAgent will satisfy the condition
         in either branch. */
        if ([domain isEqualToString:[self bundleIdentifierForLoginItemName:constAppNameBkmxAgent
                                                               inWhich1App:[[BkmxBasis sharedBasis] iAm]
                                                                   error_p:&error]]) {
            /* Error was generated by BkmxAgent. */
            switch ([error code]) {
                    // Note: Anything you add to this domain should be added
                    // maybe to the above if(){...} branch also.
                case constBkmxErrorAppIsExpiredButSparkleDidNotFindUpdate:
                case constBkmxErrorBrowserRunningQuitCancelled:
                case constBkmxErrorBrowserRunningJustYielded:
                case constBkmxErrorNoChangesToExport:
                case constBkmxErrorNoChangesToImport:
                case constBkmxErrorBrowserBookmarksWereChangedDuringSync:
                case constBkmxErrorUserCancelled:
                case constBkmxErrorCouldNotWriteLockedFileWorker:
                case constBkmxErrorMainAppHasDocOpenSoWontSync:
                case constBkmxErrorEncodingJobForStaging:
                case constBkmxErrorEncodingJobForStagingUnknown:
                case constBkmxErrorDecodingStagedJob:
                case constBkmxErrorDecodingAStagedJob:
                case constBkmxErrorNotLicensedToWrite:
                case constBkmxErrorRequestedAgentNotAvailable:
                case constBkmxErrorTriggerNoUri:
                case constBkmxErrorTriggerNotFound:
                case constBkmxErrorTriggerWrongClass:
                case constBkmxErrorTriggerUnavailable:
                case constBkmxErrorTriggersAgentNotFound:
                case constBkmxErrorTriggersAgentNotAvailable:
                case constBkmxErrorWorkerGotBadArguments:
                case constBkmsErrorSheepSafariHelperHadIssuesReading:
                case constBkmsErrorSheepSafariHelperHadIssuesWriting:
                case constBkmxErrorTimedOutGettingExidsFromClient:
                case constBkmxErrorImportTimedOut:
                case constBkmxErrorExtensionDidNotRespond:
                case constBkmxErrorImportCommandBut0ClientsNeedIt:
                case constBkmxErrorCancellingStagedAndQueuedJobsInAgent:
                case constBkmxErrorMultipleAgentsRunning:
                    return YES;
                default:
                    return NO;
            }
        }
		else if (
			[domain isEqualToString:[NSError myDomain]]
			||
			[domain isEqualToString:SSYAppleScriptErrorDomain]
			) {
            /* Error was generated by main app, or main app scripted. */
			switch ([error code]) {
					// Note: Anything you add to this domain should be added
                    // maybe to the next else if(){...} branch also.
                case constBkmxErrorAppIsExpiredButSparkleDidNotFindUpdate:
				case constBkmxErrorBrowserRunningQuitCancelled:
				case constBkmxErrorBrowserRunningJustYielded:
				case constBkmxErrorNoChangesToExport:
				case constBkmxErrorNoChangesToImport:
				case constBkmxErrorBrowserBookmarksWereChangedDuringSync:
				case constBkmxErrorUserCancelled:
				case constBkmxErrorCouldNotWriteLockedFileMainApp:
                case constBkmxErrorEncodingJobForStaging:
                case constBkmxErrorEncodingJobForStagingUnknown:
                case constBkmxErrorDecodingStagedJob:
                case constBkmxErrorDecodingAStagedJob:
				case constBkmxErrorNotLicensedToWrite:
				case constBkmxErrorRequestedAgentNotAvailable:
                case constBkmsErrorSheepSafariHelperHadIssuesReading:
                case constBkmsErrorSheepSafariHelperHadIssuesWriting:
                case constBkmxErrorImportCommandBut0ClientsNeedIt:
                case constBkmxErrorCancellingStagedAndQueuedJobsInAgent:
                case constBkmxErrorMultipleAgentsRunning:
                    return YES;
				default:
					return NO;
			}			
		}
        else if ([domain isEqualToString:BkmxExtoreWebFlatErrorDomain]) {
            switch ([error code]) {
                case constNonhierarchicalWebAppErrorCodeUserCancelled:
                    return YES ;
                default:
					;
			}
		}
		else if ([domain isEqualToString:NSOSStatusErrorDomain]) {
			switch ([error code]) {
				case userCanceledErr:
					return YES ;
				default:
					;
			}
        }
        else if ([domain isEqualToString:SSYUserInfoErrorDomain]) {
            if ([error code] == SSYUserInfoCouldNotGetLoginTimeError) {
                /* This is not a big deal.  The only effect is that we might
                 run a sync operation within 5 minutes of login, in the
                 unlikely event that this error occurs during that time. */
                return YES ;
            }
        }
        else if ([domain isEqualToString:SSYSystemUptimerErrorDomain]) {
            if (
                ([error code] == SSYSystemUptimerSystemCommandFailedErrorCode)
                ||
                ([error code] == SSYSystemUptimerSystemCommandFailedErrorCode)
                ) {
                /* This is not a big deal.  The only effect is that we might
                 run a sync operation within 5 minutes of wake, in the
                 unlikely event that this error occurs during that time. */
                return YES ;
            }
        }
        else if ([error isUserCancelledCocoaError]) {
            return YES ;
        }

        // Finally, hide errors which are excluded by a hidden preference
		NSDictionary* hideErrorsDic = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppValueForKey:constKeyHideErrors] ;
		if ([hideErrorsDic respondsToSelector:@selector(objectForKey:)]) {
			NSArray* hideErrorsArray = [hideErrorsDic objectForKey:[error domain]] ;
			if ([hideErrorsArray respondsToSelector:@selector(objectAtIndex:)]) {
				for (id hideErrorCode in hideErrorsArray) {
					// hideErrorCode may be either an NSNumber* or NSString*.  Either way,
					if ([hideErrorCode respondsToSelector:@selector(integerValue)]) {
						if ([hideErrorCode integerValue] == [error code]) {
							return YES ;
						}
					}
				}
			}
		}
		
		error = [[error userInfo] objectForKey:NSUnderlyingErrorKey] ;
	}

	return NO ;
}

- (NSOperationQueue*)operationQueue {
	if (!operationQueue) {
		operationQueue = [[NSOperationQueue alloc] init] ;
	}
	
	return operationQueue ;
}

- (NSString*)executablePath {
	NSString* path = [[[NSProcessInfo processInfo] arguments] objectAtIndex:0] ;
	return path ;
}

- (NSString*)appNameLocalized {
	if (!_appNameLocalized) {
		_appNameLocalized = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"] ;
		if (!_appNameLocalized) {
			// Probably this executable is a tool, not in a bundle
			// We don't really have a localized app name for this case
			_appNameLocalized = [[self executablePath] lastPathComponent] ;
		}
		
		[_appNameLocalized retain] ;
	}
	
	return _appNameLocalized ;
}

- (NSString*)appNameUnlocalized {
	if (!_appNameUnlocalized) {
		_appNameUnlocalized = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"] ;
		if (!_appNameUnlocalized) {
			// Probably this executable is a tool, not in a bundle
			_appNameUnlocalized = [[self executablePath] lastPathComponent] ;
		}
		
		[_appNameUnlocalized retain] ;
	}
	
	return _appNameUnlocalized ;
}

- (NSString*)mainAppNameUnlocalized {
    if (!_mainAppNameUnlocalized) {
        _mainAppNameUnlocalized = [[NSBundle mainAppBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"] ;
        if (!_mainAppNameUnlocalized) {
            // Probably this executable is a tool, not in a bundle
            _mainAppNameUnlocalized = [[self executablePath] lastPathComponent] ;
        }

        [_mainAppNameUnlocalized retain] ;
    }

    return _mainAppNameUnlocalized ;
}

- (NSString*)appUrlScheme {
	NSString* scheme = nil ;
	NSArray* urlTypes = [[NSBundle mainAppBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"] ;
	if ([urlTypes respondsToSelector:@selector(firstObjectSafely)]) {
		NSDictionary* type0 = [urlTypes firstObjectSafely] ;
		if ([type0 respondsToSelector:@selector(objectForKey:)]) {
			NSArray* schemes = [type0 objectForKey:@"CFBundleURLSchemes"] ;
			if ([schemes respondsToSelector:@selector(firstObjectSafely)]) {
				scheme = [schemes firstObjectSafely] ;
			}
		}
	}
	
	return scheme ;
}


- (NSString*)mainAppNameLocalized {
	NSBundle* bundle = [NSBundle mainAppBundle] ;
	NSString* name = [bundle objectForInfoDictionaryKey:@"CFBundleName"] ;
	return name ;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self] ;
	
	[operationQueue release] ;
	[_appNameLocalized release] ;
	[_appNameUnlocalized release] ;
    [_coreDataMigrationDelegate release];
	[m_starkAttributeTypes release] ;
	[m_macster release] ;
	[m_trace release] ;
	[m_currentAppleScriptCommand release] ;
	
	[super dealloc] ;
}

- (void)seedRandomNumberGenerator {
	double fseed = [[NSDate date] timeIntervalSinceReferenceDate] ;
	//    Remove integer part to base it on the current fraction of a second
	fseed -= (NSInteger)fseed ;
	//    0 <= fseed < 1.0
	fseed *= 0x7fffffff ;
	NSInteger seed = (NSInteger)fseed ;
	//    0 <= seed <= 2^31-1
	srandom((unsigned int)seed) ;
}	

- (void)autosaveMocNote:(NSNotification*)note {
	NSManagedObjectContext* moc = [note object] ;
	NSError* error = nil ;
	[moc save:&error] ;
	[SSYAlert alertError:error] ;
}

- (id)init {	
	self = [super init] ;
	
	if (self) {
		[self seedRandomNumberGenerator] ;
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(autosaveMocNote:)
													 name:constNoteBkmxAutosaveMocIsDirty
												   object:nil] ;
	}
	
	return self ;
}

+ (BkmxBasis*)sharedBasis {
	@synchronized(self) {
        if (!sharedBasis) {
            sharedBasis = [[self alloc] init] ;
			gSSYAlertErrorHideManager = sharedBasis ;
        }
    }
	
	// No autorelease.  This sticks around forever.
    return sharedBasis ;
}

- (NSData*)iconData {
	NSString* name = [self appNameUnlocalized]	;
	
	NSImage* image = [NSImage imageNamed:name] ;
	if (!image) {
		// Must be in a tool, not MainApp
		NSString* path = [[[NSProcessInfo processInfo] arguments] objectAtIndex:0] ;
		path = [path stringByDeletingLastPathComponent] ;  // MacOS
		path = [path stringByDeletingLastPathComponent] ;  // Contents
		path = [path stringByAppendingPathComponent:@"Resources"] ;
		path = [path stringByAppendingPathComponent:@"BookMacster.png"] ;
		image = [[[NSImage alloc] initWithContentsOfFile:path] autorelease] ;
	}
	
	NSData* data = [image TIFFRepresentation] ;
	return data ;
}

- (NSArray*)supportedWebAppExformatsOrderedByPopularity {
    NSArray* exformats ;
    switch ([[BkmxBasis sharedBasis] iAm]) {
        case BkmxWhich1AppBookMacster:
            exformats = [NSArray arrayWithObjects:
                         constExformatDiigo,
                         constExformatPinboard,
                         nil] ;
            break ;
        default:
            exformats = [NSArray array] ;
            break ;
    }
    
    return exformats ;
}

- (NSArray*)supportedWebAppExformats {
	return [[self supportedWebAppExformatsOrderedByPopularity] arraySortedByKeyPath:nil] ;
}

- (NSArray*)supportedLocalAppBundleIdentifiers {
	NSMutableArray* bundleIdentifiers = [[NSMutableArray alloc] init] ;
	
	// Find candidates among local browser applications
	for (NSString* exformat in [[BkmxBasis sharedBasis] supportedLocalAppExformatsIncludeNonClientable:YES]) {
		Class extoreClass = [Extore extoreClassForExformat:exformat] ;
		NSString* bundleIdentifier = [[extoreClass browserBundleIdentifiers] firstObjectSafely] ;
		if (bundleIdentifier) {
			[bundleIdentifiers addObject:bundleIdentifier] ;
		}
	}
	
	NSArray* answer = [bundleIdentifiers copy] ;
	[bundleIdentifiers release] ;
	return [answer autorelease] ;
}

- (NSArray*)supportedOwnerApps {
	return [[[BkmxBasis sharedBasis] supportedLocalAppExformatsIncludeNonClientable:YES] arrayByAddingObjectsFromArray:[self supportedWebAppExformats]] ;
}

- (NSArray*)supportedLocalAppExformatsOrderedByPopularityIncludeNonClientable:(BOOL)includeNonClientable {
    NSArray* smarkyExformats = [NSArray arrayWithObject:constExformatSafari] ;
    
    NSArray* synkmarkAndMarksterAdditions = [NSArray arrayWithObjects:
                                             constExformatFirefox,
                                             constExformatChrome,
                                             constExformatVivaldi,
                                             constExformatBraveBeta,
                                             constExformatBravePublic,
                                             constExformatEdge,
                                             constExformatEdgeBeta,
                                             constExformatEdgeDev,
                                             constExformatCanary,
                                             constExformatChromium,
                                             constExformatOpera,
                                             constExformatOrion,
                                             constExformatICab,
                                             constExformatOmniweb,
                                             nil] ;
    
    NSArray* bookMacsterAdditions = [NSArray arrayWithObjects:
                                     constExformatEpic,
                                     constExformatXbel,
                                     constExformatHtml,
                                     nil] ;
    
    NSMutableArray* exformats = [[NSMutableArray alloc] init] ;
    
    switch([[BkmxBasis sharedBasis] iAm]) {
        case BkmxWhich1AppSmarky:
            [exformats addObjectsFromArray:smarkyExformats] ;
            if (includeNonClientable) {
                [exformats addObjectsFromArray:synkmarkAndMarksterAdditions] ;
                [exformats addObjectsFromArray:bookMacsterAdditions] ;
            }
            break ;
        case BkmxWhich1AppSynkmark:
            [exformats addObjectsFromArray:smarkyExformats] ;
            [exformats addObjectsFromArray:synkmarkAndMarksterAdditions] ;
            if (includeNonClientable) {
                [exformats addObjectsFromArray:bookMacsterAdditions] ;
            }
            break ;
        case BkmxWhich1AppMarkster:
            [exformats addObjectsFromArray:smarkyExformats] ;
            [exformats addObjectsFromArray:synkmarkAndMarksterAdditions] ;
            if (includeNonClientable) {
                [exformats addObjectsFromArray:bookMacsterAdditions] ;
            }
            break ;
        case BkmxWhich1AppBookMacster:
            [exformats addObjectsFromArray:smarkyExformats] ;
            [exformats addObjectsFromArray:synkmarkAndMarksterAdditions] ;
            [exformats addObjectsFromArray:bookMacsterAdditions] ;
            break ;
    }
    
	// Determine if the user's default web browser is in the supported exformats
	NSString* defaultBrowserBundleIdentifier = [SSWebBrowsing defaultBrowserBundleIdentifier] ;
	NSInteger defaultBrowserIndex = NSNotFound ;
	NSInteger i = 0 ;
	for (NSString* exformat in exformats) {
		Class extoreClass = [Extore extoreClassForExformat:exformat] ;
		NSString* bundleIdentifier = [[extoreClass browserBundleIdentifiers] firstObjectSafely] ;
		if ([bundleIdentifier isEqualToString:defaultBrowserBundleIdentifier]) {
			defaultBrowserIndex = i ;
		}
		i++ ;
	}
	
	// If it is, move it to be the first item
	if (defaultBrowserIndex != NSNotFound) {
        NSString* defaultBrowserObject = [exformats objectAtIndex:defaultBrowserIndex] ;
        [exformats removeObjectAtIndex:defaultBrowserIndex] ;
        [exformats insertObject:defaultBrowserObject
                        atIndex:0] ;
	}
	
    NSArray* answer = [NSArray arrayWithArray:exformats] ;
    [exformats release] ;
	
    return answer ;
}

- (NSArray*)supportedLocalAppExformatsIncludeNonClientable:(BOOL)includeNonClientable {
	NSArray* array = [self supportedLocalAppExformatsOrderedByPopularityIncludeNonClientable:includeNonClientable] ;
    array = [array arraySortedByKeyPath:nil] ;
	return array ;
}

- (NSArray*)supportedExformatsOrderedByPopularity {
	return [[self supportedLocalAppExformatsOrderedByPopularityIncludeNonClientable:YES] arrayByAddingObjectsFromArray:[self supportedWebAppExformatsOrderedByPopularity]] ;
}

- (NSArray*)supportedExformatsOrderedByName {
    NSArray* array = [self supportedExformatsOrderedByPopularity];
    return [array sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (NSString*)messageLoggedNotificationName {
    return [[[NSBundle mainAppBundle] bundleIdentifier] stringByAppendingString:@".messageWasLogged"] ;
}

- (NSString*)appFamilyName {
    return @"Sheep-Sys" ;
}

- (NSString*)toAgentPortName {
    NSString* string = [[NSBundle mainBundle] bundleIdentifier];
    // string = "com.sheepsystems.<someting>"
    string = [string stringByDeletingDotSuffix];
    // string = "com.sheepsystems"
    string = [string stringByAppendingDotSuffix:constAppNameBkmxAgent];
    // string = "com.sheepsystems.BkmxAgent"
    string = [string stringByAppendingDotSuffix:@"toAgent"] ;
    // string = "com.sheepsystems.BkmxAgent.toAgent"

    return string;
}

// Might use this in the future
- (NSString*)toMainAppPortName {
    NSString* string = [[NSBundle mainBundle] bundleIdentifier];
    // string = "com.sheepsystems.<someting>"
    string = [string stringByDeletingDotSuffix];
    // string = "com.sheepsystems"
    string = [string stringByAppendingDotSuffix:@"MainApp"];
    // string = "com.sheepsystems.MainApp"
    string = [string stringByAppendingDotSuffix:@"toMainApp"] ;
    // string = "com.sheepsystems.BkmxAgent.toMainApp"

    return string;
}

- (NSString*)urlHandlerBundleIdentifier {
    NSString* urlHandlerBundleIdentifier = [[NSBundle mainBundle] bundleIdentifier] ;
    // urlHandlerBundleIdentifier = "com.sheepsystems.BookMacster"
    urlHandlerBundleIdentifier = [urlHandlerBundleIdentifier stringByDeletingDotSuffix] ;
    // urlHandlerBundleIdentifier = "com.sheepsystems"
    urlHandlerBundleIdentifier = [urlHandlerBundleIdentifier stringByAppendingDotSuffix:[[BkmxBasis sharedBasis] appFamilyName]] ;
    // urlHandlerBundleIdentifier = "com.sheepsystems.Sheep-Sys-"
    urlHandlerBundleIdentifier = [urlHandlerBundleIdentifier stringByAppendingString:@"-UrlHandler"] ;
    // urlHandlerBundleIdentifier = "com.sheepsystems.Sheep-Sys-UrlHandler.app"

    return urlHandlerBundleIdentifier ;
}

#define WAS_NOT_RUNNING 0
#define QUIT_IT 1
#define KILLED_IT 2

- (NSSet*)trivialAttributes {
	// In the following set of exclusions, note that I must only exclude
	// keys that I have registered to observe.  That is why some trivial
	// keys such as effectiveIndex are not mentioned.
	
	// Note that this set can be important for -[IxportLogger changeCounts].
	// For example, if a bookmark owned by the BkmxDoc obtains an exid in
	// the second round of an export, we don't want this "change" to 
	// cause updateStark:::: to be sent.  (However, I could set up 
	// another line of defense against this particular issue.  See note
	// 2968189.
	
	// Note that an item's *index*, that is, its position among its
	// siblings, is not a trivial attribute.  If it were, then we would
	// not detect any changes when bookmarks are simply sorted.
	
	return [NSSet setWithObjects:
			constKeyAddDate,
			constKeyExids,
			constKeyLastVisitedDate,
			constKeyLastModifiedDate,
			constKeyLastChengDate,
			// constKeyParent, Removed in BookMacster 1.3.5, when ChangeLogger became Chaker
			constKeyRssArticles,
			constKeyVisitCount,
			nil] ;
	/* In BookMacster version 1.3.19, I considered removing visitCount from the above, and did
	 for several weeks, but there were too many issues with it.  First of all, when I reported
	 a bug to Firefox that I couldn't change visitCount, I got a nasty warning:
	 https://bugzilla.mozilla.org/show_bug.cgi?id=635576
	 Also, in my own usage I found it annoying that "Change Visit Count" was listed in diaries,
	 and, most importantly, visit count changes were now counted toward the Safe Limit
	 which is defaulted to only 25.  The *correct* way to solve this would have been to
	 split the .updates member of Chaker into minorKeyUpdates and majorKeyUpdates, with
	 visitCount being minor.  But that would have unnecessarily complicated things for
	 a very small gain.  Another alternative considered was to not count updates that
	 were visitCount only in -[Chaker changeCounts], but that would look inconsistent in
	 Diaries because these visitCount updates would then show in the list but not in the
	 statistics at the top. */
}

- (NSSet*)agentableAppNames {
    return [NSSet setWithObjects:
            constAppNameSmarky,
            constAppNameSynkmark,
            constAppNameBookMacster,
            nil] ;
}

- (NSSet<NSNumber*>*)agentableAppWhichApps {
    return [NSSet setWithObjects:
           @(BkmxWhichAppsBookMacster),
            @(BkmxWhichAppsSynkmark),
            @(BkmxWhichAppsSmarky),
            nil
            ];
}

- (NSSet*)allAppNames {
    return [NSSet setWithObjects:
            constAppNameSmarky,
            constAppNameSynkmark,
            constAppNameMarkster,
            constAppNameBookMacster,
            nil] ;
}

- (NSString*)appNameForWhich1App:(BkmxWhich1App)which1App {
    NSString* appName;
    switch (which1App) {
        case BkmxWhich1AppSmarky:
            appName = constAppNameSmarky;
            break;
        case BkmxWhich1AppSynkmark:
            appName = constAppNameSynkmark;
            break;
        case BkmxWhich1AppMarkster:
            appName = constAppNameMarkster;
            break;
        case BkmxWhich1AppBookMacster:
            appName = constAppNameBookMacster;
            break;
    }

    return appName;
}

- (NSString*)appNameForApps:(BkmxWhichApps)whichApps {
    switch (whichApps) {
        case BkmxWhichAppsMain:
            return [[NSBundle mainAppBundle]  objectForInfoDictionaryKey:@"CFBundleExecutable"];
        case BkmxWhichAppsThis:
            return [self appNameUnlocalized];
        case BkmxWhichAppsNone:
            return @"None";
        case BkmxWhichAppsSmarky:
            return constAppNameSmarky;
        case BkmxWhichAppsSynkmark:
            return constAppNameSynkmark;
        case BkmxWhichAppsMarkster:
            return constAppNameMarkster;
        case BkmxWhichAppsBookMacster:
            return constAppNameBookMacster;
        case BkmxWhichAppsAny:
            return @"Any App";
    }
}

- (NSSet*)appNamesForApps:(BkmxWhichApps)whichApps {
    NSSet* appNames;
    switch (whichApps) {
        case BkmxWhichAppsMain:
            appNames = [NSSet setWithObject:[[NSBundle mainAppBundle]  objectForInfoDictionaryKey:@"CFBundleExecutable"]];
            break;
        case BkmxWhichAppsThis:
            appNames = [NSSet setWithObject:[[BkmxBasis sharedBasis] appNameUnlocalized]];
            break;
        case BkmxWhichAppsNone:
            appNames = [NSSet set];
            break;
        case BkmxWhichAppsSmarky:
            appNames = [NSSet setWithObject:constAppNameSmarky];
            break;
        case BkmxWhichAppsSynkmark:
            appNames = [NSSet setWithObject:constAppNameSynkmark];
            break;
        case BkmxWhichAppsMarkster:
            appNames = [NSSet setWithObject:constAppNameMarkster];
            // Markster cannot have watches, but just for the hell of it
            break;
        case BkmxWhichAppsBookMacster:
            appNames = [NSSet setWithObject:constAppNameBookMacster];
            break;
        case BkmxWhichAppsAny:
            appNames = [NSSet setWithObjects:
                        constAppNameBookMacster,
                        constAppNameMarkster,
                        constAppNameSynkmark,
                        constAppNameSmarky,
                        nil];
            break;
    }

    return appNames;
}

- (NSSet*)bundleIdentifiersForApps:(BkmxWhichApps)whichApps {
    NSMutableSet* names = [NSMutableSet new];
    switch(whichApps) {
        case BkmxWhichAppsMain:
            [names addObject:[self mainAppNameUnlocalized]];
            break;
        case BkmxWhichAppsThis:
            [names addObject:[self appNameUnlocalized]];
            break;
        case BkmxWhichAppsNone:
            break;
        case BkmxWhichAppsSmarky:
            [names addObject:constAppNameSmarky];
            break;
        case BkmxWhichAppsSynkmark:
            [names addObject:constAppNameSynkmark];
            break;
        case BkmxWhichAppsMarkster:
            break;
        case BkmxWhichAppsBookMacster:
            [names addObject:constAppNameBookMacster];
            break;
        case BkmxWhichAppsAny:
            [names addObject:constAppNameSmarky];
            [names addObject:constAppNameSynkmark];
            [names addObject:constAppNameBookMacster];
            break;
    }

    NSMutableSet* bundleIdentifiers = [NSMutableSet new];
    for (NSString* name in names) {
        [bundleIdentifiers addObject:[@"com.sheepsystems." stringByAppendingString:name]];
    }
    [names release];
    
    NSSet* answer = [bundleIdentifiers copy];
    [answer autorelease];
    [bundleIdentifiers release];
    
    return answer;
}

- (BOOL)checkNoSiblingAppsRunningError_p:(NSError**)error_p {
	BOOL okToRun = YES ;
    NSError* error = nil ;
    NSString* msg ;

    if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
        NSString* thisAppName = [self appNameUnlocalized] ;
        for (NSString* appName in [self allAppNames]) {
            if (![appName isEqualToString:thisAppName]) {
                NSString* appIdentifier = [BkmxBasis appIdentifierForAppName:appName];
                if (appIdentifier) {
                    NSArray* runningApps = [NSRunningApplication runningApplicationsWithBundleIdentifier:appIdentifier] ;
                    if ([runningApps count] > 0) {
                        okToRun = NO ;
                        if (![[BkmxBasis sharedBasis] isBkmxAgent]) {
                            msg = [NSString stringWithFormat:
                                   @"%@ is running.  To avoid conflicts, %@ cannot run and will now quit.",
                                   appName,
                                   thisAppName] ;
                            error = SSYMakeError(193834, msg) ;
                            msg = [NSString stringWithFormat:
                                   @"Quit %@ and then relaunch %@.",
                                   appName,
                                   thisAppName] ;
                        }
                        else {
                            msg = [NSString stringWithFormat:
                                   @"To avoid conflicts, %@ Workers cannot sort or sync your bookmarks while %@ is running.",
                                   thisAppName,
                                   appName] ;
                            error = SSYMakeError(193835, msg) ;
                            msg = [NSString stringWithFormat:
                                   @"Using both %@ and %@ is not recommended, "
                                   @"particularly with Syncers, as you have.  "
                                   @"You should choose one and trash the other.",
                                   appName,
                                   thisAppName] ;
                        }
                        error = [error errorByAddingLocalizedRecoverySuggestion:msg] ;
                        error = [error errorByAddingIsOnlyInformational] ;
                        error = [error errorByAddingHelpAddress:constHelpAnchorGettingStarted];
                        break ;
                    }
                }
            }
        }
    }
    
    if (error && error_p) {
        *error_p = error ;
    }
	return okToRun;
}

- (NSAttributeType)attributeTypeForStarkKey:(NSString*)key {
	if (!key) {
		return NSUndefinedAttributeType ;
	}
	
	// Most keys are of a managed object, so we look for one of those first.
	
	NSDictionary* starkAttributeTypes = [self starkAttributeTypes] ;
	if (!starkAttributeTypes) {
		// Get the merged managed object model from the main bundle (signified by nil)
		// The following is an expensive operation.
		NSManagedObjectModel* model = [NSManagedObjectModel mergedModelFromBundles:nil] ;
		NSDictionary* entitiesByName = [[NSDictionary alloc] initWithDictionary:[model entitiesByName]] ;
        // The -initWithDictionary wrapper was added in BookMacster 1.19.2.  See
        // http://stackoverflow.com/questions/19626858/over-optimization-bug-in-10-9-core-data-entity-description-methods
		NSEntityDescription* entityDescription = [entitiesByName objectForKey:constEntityNameStark] ;
        [entitiesByName release] ;
		NSDictionary* attributesByName = [entityDescription attributesByName] ;
		
		// Extract the attribute types into a new a dictionary
		NSMutableDictionary* workingStarkAttributeTypes = [[NSMutableDictionary alloc] init] ;
		for (NSString* attributeName in attributesByName) {
			NSAttributeDescription* attributeDescription = [attributesByName objectForKey:attributeName] ;
			if (attributeDescription) {
				NSAttributeType attributeType = [attributeDescription attributeType] ;
				[workingStarkAttributeTypes setObject:[NSNumber numberWithInteger:attributeType]
											   forKey:attributeName] ;
			}
		}
		
		// Cache the dictionary for quick reference in the future.
		starkAttributeTypes = [NSDictionary dictionaryWithDictionary:workingStarkAttributeTypes] ;
		[workingStarkAttributeTypes release] ;
		[self setStarkAttributeTypes:starkAttributeTypes] ;
	}
	
	NSAttributeType attributeType = NSUndefinedAttributeType ; // Our default answer
	NSNumber* attributeTypeNumber = [starkAttributeTypes objectForKey:key] ;
	if (attributeTypeNumber) {
		attributeType = [attributeTypeNumber integerValue] ;
	}
	else if ([key isEqualToString:constKeySharypeCoarse]) {
		attributeType = NSInteger16AttributeType ;
	}
	
	return attributeType ;
}

- (Macster*)macsterWithDocUuid:(NSString*)docUuid
				  createIfNone:(BOOL)createIfNone {
    NSError* error = nil;
    Macster* macster = nil;
    NSManagedObjectContext* moc = [self settingsMocForIdentifier:docUuid
                                                         error_p:&error] ;
    if (!moc && createIfNone) {
        NSString* errorDesc = [NSString stringWithFormat:
                               @"Could not create settings moc for document %@",
                               docUuid] ;
        error = [SSYMakeError(728737, errorDesc) errorByAddingUnderlyingError:error];
    } else {
        SSYMojo* macsterMojo = [[SSYMojo alloc] initWithManagedObjectContext:moc
                                                                  entityName:constEntityNameMacster];
        
        macster = (Macster*)[macsterMojo objectWithPredicate:nil
                                                     error_p:&error];
        [macsterMojo release];
        if (!macster && !error && createIfNone) {
            // Must be a new BkmxDoc.  Create one.
            
            /* When running my automated test on BookMacster 1.12.8, I got a crash in
             -insertNewObjectForEntityForName:inManagedObjectContext: because, according
             to the crash report, moc was nil.  This happened after one of the local
             settings files failed to open, which, of course, is possible.  So I added
             the following if().  */
            if (moc) {
                macster = [NSEntityDescription insertNewObjectForEntityForName:constEntityNameMacster
                                                        inManagedObjectContext:moc] ;
                [moc save:&error] ;
            }
            else {
                NSString* errorDesc = [NSString stringWithFormat:
                                       @"Could not create settings moc for supposedly new document %@",
                                       docUuid] ;
                error = SSYMakeError(728739, errorDesc) ;
            }
        }
    }
	[SSYAlert alertError:error] ;
	
	
	return macster ;
}

- (void)destroyAnyExistingDocSupportMocForMocName:(NSString*)mocName
                                            uuid:(NSString*)uuid {
    NSString* identifier = [self filenameForMocName:mocName
                                         identifier:uuid] ;
    [SSYMOCManager destroyManagedObjectContextWithIdentifier:identifier
                                                      ofType:NSSQLiteStoreType] ;
}

- (NSString*)docUuidOfSettingsObject:(NSManagedObject*)object {
	NSManagedObjectContext* moc = [object managedObjectContext] ;
	NSPersistentStore* store = [moc store1] ;
	NSURL* url = [store URL] ;
	NSString* path = [url path] ;
	NSString* filename = [[path lastPathComponent] stringByDeletingPathExtension] ;
	NSString* uuid = [self identifierFromFilename:filename
										  mocName:constBaseNameSettings] ;
	return uuid ;
}

@synthesize trace = m_trace ;
@synthesize traceLevel = m_traceLevel ;

- (void)beginDebugTraceWithHeader:(NSString*)header  {
    [[NSSound soundNamed:@"Submarine"] play];
	NSMutableString* trace = [[NSMutableString alloc] initWithString:header] ;
	[self setTrace:trace] ;
	[trace release] ;
}

- (void)trace:(NSString*)string  {
	[[self trace] appendString:string] ;
}

#if 0
/* For a couple months, I used the following implementation,
 but then I found that this is inherently buggy, because if
 we log, for example, a simple string which just so happens
 to contain a format placeholder, we will crash.  For example:
 s = @"Hello %@" ;
 [basis trace:s] ; // crash
 NSLog has the same problem…
 NSLog(s) ; // crash
 However, NSLog() gives you a compiler warning.  -trace: doesn't. */
- (void)trace:(NSString*)formatString, ...  {
	NSString* processedString ;
	BOOL canDo = YES ;
		
	if (formatString == nil) {
		processedString = nil ;
		canDo = NO ;
	}	
	
	if ([formatString length] == 0) {
		processedString = formatString ;
		canDo = NO ;
	}
	
	if (canDo) {
		va_list argPtr ;
		va_list* argPtr_p = &argPtr ;
		
		va_start(argPtr, formatString) ;
		processedString = [NSString replacePlaceholdersInString:formatString
													   argPtr_p:argPtr_p] ;
		va_end(argPtr) ;
		
		[[self trace] appendString:processedString] ;
	}	
}
#endif

- (void)endAndWriteDebugTrace {
    BOOL ok = YES;
    NSError* error = nil;

    if (![self trace]) {
		ok = NO;
	}

    NSString* path;
    if (ok) {
        path = [[NSFileManager defaultManager] ensureDesktopDirectoryNamed:@"Bkmx-Ixport-Traces"
                                                                   error_p:&error];
        if (!path) {
            ok = NO;
        }
    }

    if (ok) {
        NSString* filename = [NSString stringWithFormat:
                                       @"%@-Trace-%@",
                                       [self appNameLocalized],
                                       [[NSDate date] compactDateTimeString]] ;
        filename = [filename stringByAppendingPathExtension:@"txt"] ;
        path = [path stringByAppendingPathComponent:filename];
        ok = [[self trace] writeToFile:path
                            atomically:NO
                              encoding:NSUTF8StringEncoding
                                 error:&error] ;
        if ((error.code == 517) && ([error.localizedDescription rangeOfString:@"UTF"].location != NSNotFound)) {
            NSString* sorry = [NSString stringWithFormat:
                               @"The debug trace could not be written due to error: %@.\n\nThis is probably due to to a known misbehavior of -[NSString substringToIndex:] or -[NSString substringFromIndex:] when receiver contains characters of more than 2 bytes.  It only affects writing of the debug trace and should **not** be taken as an indication of corrupt data.  To work around this, remove such characters in Stark attributes.  To avoid wasting hours re-discovering this bug, ignore this error.  See my Simplenote \"NSString Substring Bug\"",
                               error.localizedDescription];
            [sorry writeToFile:path
                    atomically:NO
                      encoding:NSUTF8StringEncoding
                         error:NULL];
            error = nil;
        }
#if DEBUG
        [[BkmxBasis sharedBasis] logFormat:@"Traced to %@", path];
#endif
    }

    [self setTrace:nil] ;

    if (!ok) {
        [SSYAlert alertError:error] ;
    }
}

- (BOOL)isTracing {
	return ([self trace] != nil) ;
}

- (BkmxWhich1App)iAm {
    NSString* name = [self mainAppNameUnlocalized] ;
    BkmxWhich1App iAm;
    if ([name isEqualToString:constAppNameSmarky]) {
        iAm = BkmxWhich1AppSmarky ;
    }
    else if ([name isEqualToString:constAppNameSynkmark]) {
        iAm = BkmxWhich1AppSynkmark ;
    }
    else if ([name isEqualToString:constAppNameMarkster]) {
        iAm = BkmxWhich1AppMarkster ;
    }
    else if ([name isEqualToString:constAppNameBookMacster]) {
        iAm = BkmxWhich1AppBookMacster ;
    } else {
        NSLog(@"Internal Error 293-8826: %@", name);
        iAm = BkmxWhich1AppBookMacster ;
    }
    
    return iAm ;
}

- (BOOL)isShoeboxApp {
    BOOL answer ;
    switch ([self iAm]) {
        case BkmxWhich1AppSmarky:
        case BkmxWhich1AppSynkmark:
        case BkmxWhich1AppMarkster:
            answer = YES ;
            break ;
        case BkmxWhich1AppBookMacster:
            answer = NO ;
            break ;
    }
    
    return answer ;
}

- (BOOL)isBkmxAgent {
    BOOL answer = NO;
    NSString* name = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"];
    /* We purposely used the mainBundle here, not the mainAppBundle.  When
     we are in BkmxAgent, the latter will be, for example, "BookMacster". */
    if ([name isEqualToString:constAppNameBkmxAgent]) {
        answer = YES;
    }

    return answer;
}

+ (NSSet*)syncableWhich1Apps {
    return [NSSet setWithObjects:
            @(BkmxWhich1AppBookMacster),
            @(BkmxWhich1AppSynkmark),
            @(BkmxWhich1AppSmarky),
            nil
            ];
}

- (BOOL)isAMainAppWhichCanSync {
    BOOL answer ;
    if ([self isBkmxAgent]) {
        answer = NO;
    } else {
        switch ([self iAm]) {
            case BkmxWhich1AppSmarky:
            case BkmxWhich1AppSynkmark:
            case BkmxWhich1AppBookMacster:
                answer = YES ;
                break ;
            case BkmxWhich1AppMarkster:
                answer = NO ;
                break ;
        }
    }
    
    return answer ;
}

- (NSString*)processDisplayTypeForProcessType:(BkmxLogProcessType)processType {
	NSString* answer ;
    
	switch (processType) {
        case BkmxLogProcessTypeBkmxAgent:
            answer = @"Agent" ;
            break ;
        case BkmxLogProcessTypeSmarkyScripted:
            answer = @"SmrkS" ;
            break ;
        case BkmxLogProcessTypeSynkmarkScripted:
            answer = @"SymkS" ;
            break ;
        case BkmxLogProcessTypeMarksterScripted:
            answer = @"MktrS" ;
            break ;
        case BkmxLogProcessTypeBookMacsterScripted:
            answer = @"BkMtS" ;
            break ;
        case BkmxLogProcessTypeSmarky:
            answer = @"Smrky" ;
            break ;
        case BkmxLogProcessTypeSynkmark:
            answer = @"Snkmk" ;
            break ;
        case BkmxLogProcessTypeMarkster:
            answer = @"Mkstr" ;
            break ;
        case BkmxLogProcessTypeBookMacster:
            answer = @"BkMtr" ;
            break ;
		case BkmxLogProcessTypeMainAppScripted:
            // BkmxLogProcessTypeMainApp was deprecated in BookMacster 1.20.3,
            // so this branch should only be used when reading old logs.
			answer = @"BkMrS" ;
			break ;
        case BkmxLogProcessTypeNone:
        case BkmxLogProcessTypeWorker:  // deprecaated
        case BkmxLogProcessTypeQuatch:  // deprecaated
            answer = @"-None-" ;
            break ;
    }
	
	return answer ;
}

- (NSDictionary*)defaultDefaults {
    NSString* ddPath = [[NSBundle mainAppBundle] pathForResource:@"DefaultDefaults"
                                                          ofType:@"plist"] ;
    if (!ddPath) {
        NSLog(@"Internal Error 624-0003") ;
    }
    NSDictionary* defaults = [NSDictionary dictionaryWithContentsOfFile:ddPath] ;
    if (!defaults) {
        NSLog(@"Internal Error 624-0005") ;
    }
    NSString* defaultSparkleFeed = [NSString stringWithFormat:
            @"%@/%@/%@",
            constSparkleFeedPrefix,
            [[self appNameUnlocalized] lowercaseString],
            constSparkleFeedSuffix] ;
    defaults = [defaults dictionaryBySettingValue:defaultSparkleFeed
                                           forKey:SUFeedURLKey] ;
    /*
     
     From the Sparkle documentation:
     
     "Sparkle is built with `-fvisibility=hidden -fvisibility-inlines-hidden`
     which means no symbols are exported by default.  If you are adding a symbol
     to the public API you must decorate the declaration with the `SU_EXPORT`
     macro."
     
     and also we find, in SUExport.h,
     
     #define SU_EXPORT __attribute__((visibility("default")))
     
     However, the -fvisibility-inlines-hidden` only applies to Release build.
     Debug builds don't have that. (You can seen this in Sparkle's Build
     Settings.  In the Sparkle project, target Sparkle (framework) the setting
     "Symbols Hidden by default" is No for Debug, Yes for Release.
     
     When building Sparkle for release, because symbols are stripped by default
     as explained above, the build will fail unless we make the two symbols
     we need visible.  To do that, hack in to SUConstants.h and add the
     decoration __attribute__((visibility("default"))) to the declarations
     of SUFeedURLKey and SUEnableAutomaticChecksKey, like this:
     
     << extern NSString *const SUFeedURLKey;
     << extern NSString *const SUEnableAutomaticChecksKey;
     >> __attribute__((visibility("default"))) extern NSString *const SUFeedURLKey;
     >> __attribute__((visibility("default"))) extern NSString *const SUEnableAutomaticChecksKey;
     
     In Sparle 1, you could use SU_EXPORT as suggested in the documentation
     quoted above, but SU_EXPORT does not seem to be defined in SUConstants.h
     in Sparkle 2.
     */
     
    return defaults ;
}

- (NSString*)displayTextForPurpose:(NSInteger)purpose {
    NSString* answer ;
    switch (purpose) {
        case constExtensibilityNone:
            answer = @"none" ;
            break ;
        case constExtensibilitySawChange:
            answer = @"saw-change" ;
            break ;
        case constExtensibilityImport:
            answer = @"read" ;
            break ;
        case constExtensibilityExport:
            answer = @"write" ;
            break ;
        default:
            answer = @"?!?" ;
            break ;
    }
    
    return answer ;
}

- (NSString*)detectedChangesPath {
    NSString* path = [[NSBundle mainAppBundle] applicationSupportPathForMotherApp] ;
    path = [path stringByAppendingPathComponent:@"Changes"] ;
    path = [path stringByAppendingPathComponent:@"Detected"] ;
    return path ;
}

- (NSTimeInterval)timeoutForAppToLaunch {
    /* We not only *have* a longer time available in BkmxAgent, we may *need* a
     longer time, particularly when triggered to run when the user logs
     in and the CPU is busy launching processes.  I got at least one trouble
     report from a user whose system took longer than 10 seconds. */
    return (NSApp ? 10.26 : 60.26) ;
}


- (NSArray<NSRunningApplication*>*)runningAgents {
    NSError* error = nil;
    NSString* bundleIdentifier = [self bundleIdentifierForLoginItemName:constAppNameBkmxAgent
                                                            inWhich1App:[[BkmxBasis sharedBasis] iAm]
                                                                error_p:&error];
    if (error) {
        error = [SSYMakeError(623937, @"Error when searching for bundle identifier of our BkmxAgent") errorByAddingUnderlyingError:error];
    }

    NSArray* agentApps = nil;
    if (bundleIdentifier) {
        agentApps = [NSRunningApplication runningApplicationsWithBundleIdentifier:bundleIdentifier];
        if (agentApps.count > 1) {
            NSString* msg = [NSString stringWithFormat:
                             @"Eeek, found %ld BkmxAgent processes running.",
                             (long)agentApps.count];
            error = SSYMakeError(constBkmxErrorMultipleAgentsRunning, msg);
        }
    }
    
    if (error) {
        [self logError:error
       markAsPresented:NO];
        /* The following will display Error 623937, but not display
         constBkmxErrorMultipleAgentsRunning, because the latter returns
         YES in -[BkmxBasis shouldHideError:]. */
        if ([self isBkmxAgent]) {
            [BkmxNotifierCaller presentUserNotificationOfError:error
                                                         title:@"Trouble with bookmarks agent"
                                                alertNotBanner:YES
                                                      subtitle:error.localizedDescription
                                                          body:error.underlyingError.localizedDescription
                                                     soundName:nil
                                               targetErrorCode:error.code
                                                       error_p:NULL];
        } else {
            dispatch_queue_t mainQueue = dispatch_get_main_queue();
            dispatch_async(mainQueue, ^{
                [SSYAlert alertError:error];
            });
        }
    }
    
    return agentApps;
}

- (NSString*)appNameContainingAgentWithBundleIdentifier:(NSString*)bundleIdentifier {
    NSString* name = nil;
    for (NSNumber* which1AppNumber in [BkmxBasis syncableWhich1Apps]) {
        BkmxWhich1App which1App = (BkmxWhich1App)which1AppNumber.integerValue;
        NSString* aBundleIdentifier = [[BkmxBasis sharedBasis] bundleIdentifierForLoginItemName:constAppNameBkmxAgent
                                                                                    inWhich1App:which1App
                                                                                        error_p:NULL];
        BkmxWhichApps whichApps = [BkmxBasis whichAppsFromWhich1App:which1App];
        if ([aBundleIdentifier isEqualToString:bundleIdentifier]) {
            name = [[BkmxBasis sharedBasis] appNameForApps:whichApps];
            break;
        }
    }

    return name;
}

- (NSString*)runningAgentDescription {

    NSMutableArray* agentDescriptions = [NSMutableArray new];
    for (NSRunningApplication* runningAgent in [self runningAgents]) {
        /* NSRunningAgent.launchDate does not work for processes which are "not
         launched by launchd".  I thought BkmxAgent *was* launched by launchd,
         but apparently not, because .launchDate does not work.  So we do this
         instead… */
        NSString* elapsedTimeString = [SSYOtherApper humanReadableElapsedRunningTimeOfPid:runningAgent.processIdentifier];
        
        [agentDescriptions addObject:[NSString stringWithFormat:
                                      NSLocalizedString(@"A BkmxAgent process with these attributes is running:\n    Name: %@\n    Bundle Identifier: %@\n    Found in app package: %@\n    Process Identifier (pid): %d\n    Was launched %@ ago", nil),
                                      constAppNameBkmxAgent,
                                      runningAgent.bundleIdentifier,
                                      [self appNameContainingAgentWithBundleIdentifier:runningAgent.bundleIdentifier],
                                      runningAgent.processIdentifier,
                                      elapsedTimeString]];
    }
    
    NSString* answer;
    if (agentDescriptions.count > 0) {
        answer = [agentDescriptions componentsJoinedByString:@"\n"];
    } else {
        answer = [NSString stringWithFormat:
                  NSLocalizedString(@"Agent (%@ : %@) is not running.", nil),
                  constAppNameBkmxAgent,
                  [self bundleIdentifierForLoginItemName:constAppNameBkmxAgent
                                             inWhich1App:[[BkmxBasis sharedBasis] iAm]
                                                 error_p:NULL]];
    }
    [agentDescriptions release];
    
    return answer;
}

- (BOOL)quillBkmxAgentPids_p:(NSString**)pids_p
                    error_p:(NSError**)error_p {
    NSError* error = nil;
    NSMutableArray* killedPids = [NSMutableArray new];
    BOOL ok = YES;
    NSArray<NSNumber*>* pids = [[self runningAgents] valueForKey:@"processIdentifier"];
    [self kickBkmxAgentWithKickType:KickType_Stop
                              error:&error];
    for (NSNumber* pid in pids) {
        [killedPids addObject:[NSString stringWithFormat:@"%@", pid]];
    }

    if (!ok || pids.count > 1) {
        for (NSNumber* pid in pids) {
            [self logFormat:@"Something fishy.  Killing pid %@", pid];
            /* Sometimes, I'm not sure why, SMLoginItemSetEnabled returns NO, and
             in one case, telling it to "Quit" (not Force) in Activity Monitor
             did work.  As I now understand it, "Quit" in Activity Monitor is
             equivalent to SIGTERM.  So we now try that: */
            ok = [SSYOtherApper killThisUsersProcessWithPid:pid.unsignedShortValue
                                                        sig:SIGTERM
                                                    timeout:5.0];
            /*  Oddly, even after the process has been successfully terminated
             by Activity Monitor, if you then try again to "disable" it with
             SMLoginItemSetEnabled, it will SMLoginItemSetEnabled will still return NO.
             So that is why we take our OK from the above call. */
            [self logFormat:@"then, using SIGTERM returned %@", ok?@"YES":@"NO"];
        }
    }
    
    if (error && error_p) {
        *error_p = error ;
    }
    
    if (pids_p) {
        if (killedPids.count > 0) {
            *pids_p = [killedPids componentsJoinedByString:@", "];
        } else {
            *pids_p = nil;
        }
    }
    [killedPids release];
    
    return ok;
}

- (BOOL)rebootSyncAgentReport_p:(NSString**)report_p
                        title_p:(NSString**)title_p
                        error_p:(NSError**)error_p {
	/* I'm 95% sure that BkmxAgent will never call this method.  But the Call
     Hierarchy was quite long, so to avoid the half hour it would take to make
     that 100%, I do defensive programming with this if(). */
    if ([[NSApp delegate] respondsToSelector:@selector(killAnyOldieLoginItemsWithBasename:)]) {
        [(BkmxAppDel*)[NSApp delegate] killAnyOldieLoginItemsWithBasename:constAppNameBkmxAgent];
    }
    
    BOOL ok = NO;
    NSError* error = nil;
    NSString* report = nil;
    NSString* title = nil;
    NSString* const nilReport = NSLocalizedString(@"No report", nil);
    NSString* const rebootFailed = NSLocalizedString(@"Reboot Failed", nil);
    
    /* Fixed in BkmkMgrs 2.9.3:  Because each app has its own BkmxAgent
     with its own bundle identifier, we only consider watches for this
     app. */
    NSSet* watches = [[NSUserDefaults standardUserDefaults] watchesForApps:BkmxWhichAppsMain];
    NSInteger watchesCount = watches.count;
    if (watchesCount > 0) {
        pid_t oldPid = [self runningAgents].firstObject.processIdentifier;
        NSString* oldPidString = [NSString stringWithFormat:@"%d", oldPid];
        NSDictionary* result = [self kickBkmxAgentWithKickType:KickType_Reboot
                                                         error:&error];
        id statusId = [result objectForKey:constKeyStatus];
        if ([statusId respondsToSelector:@selector(integerValue)]) {
            NSInteger status = [(NSNumber*)statusId integerValue];
            if (status == BkmxAgentStatusRequiresApproval) {
                report = NSLocalizedString(@"mustEnableAgentRunner", nil);
            } else if (!error) {
                pid_t newPid;
                /* My sample of 5 on my 2013 MacBook Air says that newPid
                 will be 0 for some duration between 38 and 511 milliseconds.
                 So we allow 94 * 0.1 = 9.4 seconds
                 */
                NSInteger i = 0;
                do {
                    newPid = [self runningAgents].firstObject.processIdentifier;
                    [NSThread sleepForTimeInterval:0.1];
                    i++;
                } while ((newPid == 0) && (i < 94));
                if (newPid > 0) {
                    NSString* newPidString = [NSString stringWithFormat:@"%d", newPid];
                    if (![newPidString isEqualToString:oldPidString]) {
                        ok = YES;
                        title = NSLocalizedString(@"Reboot Succeeded", nil);
                        report = [NSString stringWithFormat:
                                  @"BkmxAgent Process Identifier:\n"
                                  @"     Before reboot: %@\n"
                                  @"     After reboot: %@",
                                  oldPidString,
                                  newPidString];
                        error = nil;
                    } else {
                        ok = NO;
                        title = rebootFailed;
                        report = [NSString stringWithFormat:
                                  NSLocalizedString(@"Same process identifier, %d, before and after rebooting of BkmxAgent.", nil),
                                  newPid];
                        error = SSYMakeError(663845, report);
                    }
                } else {
                    ok = NO;
                    title = rebootFailed;
                    report = NSLocalizedString(@"BkmxAgentRunner says reboot succeeded, but the BkmxAgent process is not running.", nil);
                    error = SSYMakeError(663895, report);
                }
            } else {
                title = rebootFailed;
                report = NSLocalizedString(@"BkmxAgent could not be rebooted because an error occurred.", nil);
                error = [SSYMakeError(663904, report) errorByAddingUnderlyingError:error];
            }
        } else {
            title = rebootFailed;
            report = nilReport;
            error = [SSYMakeError(662712, @"Failed to reboot BkmxAgent") errorByAddingUnderlyingError:error];
        }
    } else {
        ok = YES;
        title = NSLocalizedString(@"Reboot Unnecessary", nil);
        report = @"BkmxAgent was not relaunched because you have no active Syncers configured for this app.";
        error = nil;
    }

    if (report && report_p) {
        *report_p = report;
    }
    if (title && title_p) {
        *title_p = title;
    }
    if (error && error_p) {
        *error_p = error;
    }

    return ok;
}

- (NSBundle*)bundleForAgentRunnerLoginItemName:(NSString*)name
                                    inWhichApp:(BkmxWhich1App)which1App {
    NSURL* url = nil;
    if (![[BkmxBasis sharedBasis] isBkmxAgent] && (which1App == [self iAm])) {
        /* We are a main app, and the target app is us */
        url = [[NSBundle mainAppBundle] bundleURL];
        if (!url) {
            NSString* desc = [NSString stringWithFormat:
                              @"Main failed get mainAppBundle for %@ in %@",
                              name,
                              [self appNameForWhich1App:which1App]];
            NSError* error = SSYMakeError(constBkmxErrorCouldNotGetBundleInMain, desc);
            error = [error errorByAddingIsOnlyInformational];
            [[BkmxBasis sharedBasis] logError:error
                              markAsPresented:NO];
        }
    } else {
        if ([[BkmxBasis sharedBasis] isBkmxAgent]) {
            NSString* myMainAppName = [self mainAppNameUnlocalized];
            NSString* targetAppName = [self appNameForWhich1App:which1App];
            if ([myMainAppName isEqualToString:targetAppName]) {
                /* We are BkmxAgent, and the target app is our main app */
                url = [[NSBundle mainAppBundle] bundleURL];
                if (!url) {
                    NSString* desc = [NSString stringWithFormat:
                                      @"Agent failed get mainAppBundlefor %@ in %@",
                                      name,
                                      [self appNameForWhich1App:which1App]];
                    NSError* error = SSYMakeError(constBkmxErrorCouldNotGetBundleInAgent, desc);
                    error = [error errorByAddingIsOnlyInformational];
                    error = [error errorByAddingUserInfoObject:myMainAppName
                                                        forKey:@"main app name"];
                    error = [error errorByAddingUserInfoObject:targetAppName
                                                        forKey:@"target app name"];
                    [[BkmxBasis sharedBasis] logError:error
                                      markAsPresented:NO];
                }
            } else {
                /* This is expected when we are called by
                 -[BkmxBasis bundleIdentifierForLoginItemName:inWhich1App:error_p:]
                 in Agent.  Leave `url` as nil and return nil. */
            }
        } else {
            NSString* desc = [NSString stringWithFormat:
                              @"??? failed get mainAppBundle for %@ in %@",
                              name,
                              [self appNameForWhich1App:which1App]];
            NSError* error = SSYMakeError(constBkmxErrorCouldNotGetBundleInUnknown, desc);
            error = [error errorByAddingIsOnlyInformational];
            error = [error errorByAddingUserInfoObject:SSYDebugCaller()
                                                forKey:@"caller"];
            [[BkmxBasis sharedBasis] logError:error
                              markAsPresented:NO];
        }
    }
    url = [url URLByAppendingPathComponent:@"Contents"];
    url = [url URLByAppendingPathComponent:@"Helpers"];
    url = [url URLByAppendingPathComponent:@"BkmxAgentRunner.app"];
    url = [url URLByAppendingPathComponent:@"Contents"];
    url = [url URLByAppendingPathComponent:@"Library"];
    url = [url URLByAppendingPathComponent:@"LoginItems"];
    url = [url URLByAppendingPathComponent:name];
    url = [url URLByAppendingPathExtension:@"app"];

    NSBundle* bundle = nil;
    if(url) {
        bundle = [NSBundle bundleWithURL:url];
    }

    return bundle;
}

- (NSString*)bundleIdentifierForLoginItemName:(NSString*)appName
                                  inWhich1App:(BkmxWhich1App)which1App
                                      error_p:(NSError**)error_p {
    NSError* error = nil;

    NSBundle* agentBundle = [self bundleForAgentRunnerLoginItemName:appName
                                                         inWhichApp:which1App];

    NSString* bundleIdentifier = nil;
    if (agentBundle) {
        bundleIdentifier = [agentBundle bundleIdentifier];
        if (!bundleIdentifier) {
            error = SSYMakeError(208344, @"No bundle ID in login item bundle ?");
        }
    }

    if (error && error_p) {
        *error_p = error ;
    }

    return bundleIdentifier;
}


#if 0
#warning Testing local file cruft cleaning
#define FILE_CRUFT_CLEANING_DELAY_FOR_MAIN_APP 10
#define FILE_CRUFT_CLEANING_DELAY_FOR_AGENT 30
#define FILE_CRUFT_CLEANING_INTERVAL 120
#else
/*  We want to do the cleaning after launch business has ended, and then
 thereafter every 24 hours.  What I mean by "launch business":
 
 1.  When running in main app, in the likely event that the user wants to get
 wbusy immediately upon launching, we want to be responsive.
 2.  When running in Agent, we want to conserve resources for any syncing,
 although this is probably not necessary since agent is launched *after* any
 necessary syncing.   But in case of some edge case I have not thought of,
 and since Agent runs constantly, I wait an even longer time.
 3.  When I run my ReproUserTrouble AppleScript, it needs time to open
 whatever document the user has sent, which will add it to open recents.
 */
#define FILE_CRUFT_CLEANING_DELAY_FOR_MAIN_APP 120
#define FILE_CRUFT_CLEANING_DELAY_FOR_AGENT 1200
#define FILE_CRUFT_CLEANING_INTERVAL 24*60*60
#endif

- (NSTimeInterval)fileCruftCleaningDelay {
    if ([self isBkmxAgent]) {
        return FILE_CRUFT_CLEANING_DELAY_FOR_AGENT;
    } else {
        return FILE_CRUFT_CLEANING_DELAY_FOR_MAIN_APP;
    }
}

- (void)scheduleFileCruftCleaning {
    dispatch_queue_t aSerialQueue = dispatch_queue_create(
                                                          "CleanLocalFileCruft",
                                                          DISPATCH_QUEUE_SERIAL
                                                          ) ;

    dispatch_async(aSerialQueue, ^{
        // We're on a secondary thread, so we just sleep.
        sleep([self fileCruftCleaningDelay]);
        
        BOOL needsCleaning = YES;
        NSDate* lastCleanedDate = [[NSUserDefaults standardUserDefaults] syncAndGetMainAppValueForKey:constKeyLastLocalFileCruftCleaning];
        if ([lastCleanedDate respondsToSelector:@selector(timeIntervalSinceNow)]) {
            needsCleaning = ([lastCleanedDate timeIntervalSinceNow] < -FILE_CRUFT_CLEANING_INTERVAL);
        }
        
        if (needsCleaning) {
            [self logString:@"Will do periodic cleaning of local file cruft"];
            [self cleanOrphanedLocalData] ;
            [Extore cleanExcessSyncSnapshots] ;
            [[NSUserDefaults standardUserDefaults] setAndSyncMainAppValue:[NSDate date]
                                                                   forKey:constKeyLastLocalFileCruftCleaning];
            [self logString:@"Did do periodic cleaning of local file cruft"];
        }
    });

    /* Schedule the next run. */
    [NSTimer scheduledTimerWithTimeInterval:FILE_CRUFT_CLEANING_INTERVAL
                                     target:self
                                   selector:@selector(scheduleFileCruftCleaning)
                                   userInfo:nil
                                    repeats:NO];
}

#define TOO_OLD_SECONDS 62*24*60*60  // 62 days

- (void)cleanOrphanedLocalData {
    NSString* appSupportPath = [[NSBundle mainBundle] applicationSupportPathForMotherApp] ;
    
    NSError* error = nil ;
    NSArray* filenames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:appSupportPath
                                                                             error:&error] ;
    if (error) {
        // Removed logging in BookMacster 1.18 because this error is expected
        // if user clicks "Reset and Start Over" before this method runs.

        // NSLog(@"Internal Error 757-8165 %@", error) ;
    }
    
    // Look at constKeyDocRecentDisplayNames in our prefs to get uuids in use
    NSSet* uuidsInUse = [NSSet setWithArray:[[[NSUserDefaults standardUserDefaults] dictionaryForKey:constKeyDocRecentDisplayNames] allKeys]] ;
    
    /* We trash a file if it passes all of these tests…
     • has a .sql extension
     • has a name length > 36 characters
     • name begins with "Exids", "Settings" or "Diaries"
     • the uuid in its name is not in uuidsInUse
     • neither it nor have any of its siblings (Exids, Settings, Diaries) in the same uuid family been modified for 62 days (added in BookMacster 1.12.2)
     */
    // First, find the last modification date for each uuid family
    NSMutableDictionary* lastModDates = [NSMutableDictionary dictionary] ;
    for (NSString* filename in filenames) {
        if ([filename hasSuffix:SSYManagedObjectContextPathExtensionForSqliteStores]) {
            if ([filename length] > 36) {
                if (
                    [filename hasPrefix:constBaseNameExids]
                    ||
                    [filename hasPrefix:constBaseNameSettings]
                    ||
                    [filename hasPrefix:constBaseNameDiaries]
                    ) {
                    NSString* basename = [filename stringByDeletingPathExtension] ;
                    NSString* uuid = [basename substringFromIndex:([basename length] - 36)] ;
                    NSString* path = [appSupportPath stringByAppendingPathComponent:filename] ;
                    NSDate* modificationDate = [[NSFileManager defaultManager] modificationDateForPath:path] ;
                    if (modificationDate) {
                        NSDate* priorDate = [lastModDates objectForKey:uuid] ;
                        if (priorDate) {
                            NSDate* newestDateForThisUuid = [priorDate laterDate:modificationDate] ;
                            [lastModDates setObject:newestDateForThisUuid
                                             forKey:uuid] ;
                        }
                        else {
                            [lastModDates setObject:modificationDate
                                             forKey:uuid] ;
                        }
                    }
                }
            }
        }
    }
    for (NSString* filename in filenames) {
        if ([filename hasSuffix:SSYManagedObjectContextPathExtensionForSqliteStores]) {
            if ([filename length] > 36) {
                if (
                    [filename hasPrefix:constBaseNameExids]
                    ||
                    [filename hasPrefix:constBaseNameSettings]
                    ||
                    [filename hasPrefix:constBaseNameDiaries]
                    ) {
                    NSString* basename = [filename stringByDeletingPathExtension] ;
                    NSString* uuid = [basename substringFromIndex:([basename length] - 36)] ;
                    if (![uuidsInUse member:uuid]) {
                        NSError* error = nil ;
                        NSDate* modificationDate = [lastModDates objectForKey:uuid] ;
                        NSTimeInterval fileAge = -[modificationDate timeIntervalSinceNow] ;
                        if (fileAge > TOO_OLD_SECONDS) {
                            NSString* path = [appSupportPath stringByAppendingPathComponent:filename] ;
                            BOOL ok = [[NSFileManager defaultManager] trashPath:path
                                                                scriptFinder:NO
                                                                     error_p:&error] ;
                            if (ok) {
                                NSLog(@"Trashed orphaned local data file last modified %@ : %@", [modificationDate geekDateTimeString], path) ;
                            }
                            else {
                                NSLog(@"Internal Error 723-9728 %@", error) ;
                            }
                        }
                    }
                }
            }
        }
    }
}

- (NSString*)versionInadequateDescription {
    return [NSString stringWithFormat:
            @"This version of %@ cannot access bookmarks of Safari 16 or later.  (Safari 16 is part of macOS 13.)",
            [self mainAppNameLocalized]];
}

- (NSString*)versionInadequateRecoverySuggestion {
    return [NSString stringWithFormat:
            @"If you want to import or export bookmarks of Safari 16 or later, you must upgrade to %@ version 3 or later.",
            [self mainAppNameLocalized]];
}

- (NSError*)versionInadequateError {
    NSError* error = SSYMakeError (constBkmxErrorNeedVersion3, [self versionInadequateDescription]);
    error = [error errorByAddingLocalizedRecoverySuggestion:[self versionInadequateRecoverySuggestion]];
    NSArray* options = [NSArray arrayWithObjects:
                        [NSString localize:@"checkForUpdate"],
                        @"Later",
                        nil] ;
    error = [error errorByAddingLocalizedRecoveryOptions:options];
    if ([self isBkmxAgent]) {
        error = [error errorByAddingRecoveryAttempterIsAppDelegate];
    } else {
        error = [error errorByAddingRecoveryAttempter:self];
    }
    /* Sorry, I don't want to be fielding peoples' complaints about this, so… */
    error = [error errorByAddingDontShowSupportEmailButton];
    
    return error;
}

- (BOOL)verifyVersionIsAdequate {
    SSYVersionTriplet* currentVersion  = [SSYAppInfo currentVersionTriplet] ;
    SSYVersionTriplet* requiredVersion = [SSYVersionTriplet versionTripletWithMajor:3
                                                                              minor:0
                                                                             bugFix:0] ;
    if ([currentVersion isEarlierThan:requiredVersion]) {
        /* One could argue whether it is better to use NSAppKitVersion or the
         Safari major version as a criterion here, but the latter is more
         straighforward due to Apple's two-year delay in updating the
         NSAppKitVersion constants, and their lack of documentation. */
        NSInteger safariMajorVersion = [OtherAppVersionGetter majorVersionOf:@"com.apple.Safari" ];
        if (safariMajorVersion >= 16) {
            return NO;
        }
    }
    
    return YES;
}

+ (NSInteger)secondsPerDay {
    return 60*60*24;
}


@end

/*  Note OkToWait
 
 In BkmkMgrs 2.10.4, I changed waitUntilDone when invoking
 the main thread in these two methods from YES to NO,
 because I saw a deadlock after clicking the "Syncing" button
 in Synkmark to resume syncing.  This method was running on a
 secondary thread, and the main thread stack was as shown
 below – apparently it was trying to do an auto save.  I don't
 see what caused the deadlock, but of course the inner workings
 of asychronous saving is way beyond my pay grade.  On the other
 hand, I don't see why we cannot wait here, because the
 timestamp has already been set, and the Logs window should be
 sorting by timestamp.  Also it has been done that way for years
 in -logError:markAsPresented:.
 
 #0    0x00007fff6d5a7156 in semaphore_wait_trap ()
 #1    0x000000010096be1e in _dispatch_sema4_wait ()
 #2    0x000000010096c2f0 in _dispatch_semaphore_wait_slow ()
 #3    0x00007fff2fa32a8b in -[NSDocument(NSDocumentSerializationAPIs) _performFileAccess:] ()
 #4    0x00007fff2f7f15d4 in -[NSDocument performSynchronousFileAccessUsingBlock:] ()
 #5    0x00007fff2f84b54e in -[NSDocument _checkAutosavingThenContinue:] ()
 #6    0x00007fff2f84b442 in __52-[NSDocument _checkAutosavingThenUpdateChangeCount:]_block_invoke_2 ()
 #7    0x00007fff2f9b13fb in ___NSMainRunLoopPerformBlockInModes_block_invoke ()
 #8    0x00007fff32169fdc in __CFRUNLOOP_IS_CALLING_OUT_TO_A_BLOCK__ ()
 #9    0x00007fff32169f24 in __CFRunLoopDoBlocks ()
 #10    0x00007fff32168e1b in __CFRunLoopRun ()
 #11    0x00007fff3216842e in CFRunLoopRunSpecific ()
 #12    0x00007fff30dafc0d in RunCurrentEventLoopInMode ()
 #13    0x00007fff30daf925 in ReceiveNextEventCommon ()
 #14    0x00007fff30daf6c9 in _BlockUntilNextEventMatchingListInModeWithFilter ()
 #15    0x00007fff2f40d509 in _DPSNextEvent ()
 #16    0x00007fff2f40bd50 in -[NSApplication(NSEvent) _nextEventMatchingEventMask:untilDate:inMode:dequeue:] ()
 #17    0x00007fff2f3fda5e in -[NSApplication run] ()
 #18    0x00007fff2f3cf876 in NSApplicationMain ()
 #19    0x000000010000175e in main at /Users/jk/Documents/Programming/Projects/BkmkMgrs/Bkmx-Main.m:52
 #20    0x00007fff6d465cc9 in start ()
 #21    0x00007fff6d465cc9 in start () */
