#import "ErrorLog.h"
#import "Clientoid.h"
#import "NSError+InfoAccess.h"
#import "NSString+LocalizeSSY.h"
#import "NSObject+MoreDescriptions.h"
#import "NSError+MoreDescriptions.h"
#import "NSError+MyDomain.h"
#import "NSObject+DeepCopy.h"
#import "NSError+SSYInfo.h"
#import "BkmxBasis.h"
#import "NSString+Truncate.h"

NSString* const constKeyPresented = @"presented" ;

@interface ErrorLog (CoreDataGeneratedPrimitiveAccessors)

@end


@interface ErrorLog ()

@property (retain) NSData* archive ;
@property (retain) NSNumber* presented ;

@end



@implementation ErrorLog

@dynamic archive ;
@dynamic presented ;

- (void)didTurnIntoFault {
	/* cocoa-dev@lists.apple.com
	 
	 On 20090812 20:41, Jerry Krinock said:
	 
	 Now I understand that if nilling an instance variable after releasing
	 it is done in -dealloc, it is papering over other memory management
	 problems and is therefore bad programming practice.  But I believe
	 that this practice is OK in -didTurnIntoFault because, particularly
	 when Undo is involved, -didTurnIntoFault may be invoked more than once
	 on an object.  Therefore nilling after releasing in -didTurnIntoFault
	 is recommended.
	 
	 On 20090812 22:06, Sean McBride said
	 
	 I made that discovery a few months back too, and I agree with your
	 reasoning and conclusions.  I also asked an Apple guy at WWDC and he
	 concurred too.
	 */
	[m_error release] ;  m_error = nil ;
	
	[super didTurnIntoFault] ;
}

/*!
 @brief    Returns a set of classes which, I hope, includes everything you
 might find in an NSError and its userInfo
 
 @details  This is useful for throwing the kitchen sink at NSkeyedUnarchiver
 so it will be less likely to bitch and/or raise exceptions about insecure
 unarchiving
 */
- (NSSet*)errorClasses {
    return [NSSet setWithObjects:
            [NSError class],
            [NSDictionary class],
            [NSSet class],
            [NSOrderedSet class],
            [NSArray class],
            [NSString class],
            [NSString class],
            [NSAttributedString class],
            [NSNumber class],
            [NSDate class],
            [NSURL class],
            [NSDecimalNumber class],
            [NSNull class],
            [Clientoid class],
            [NSData class],
            nil];
}

- (NSError*)error {
	if (!m_error) {
		NSData* archiveData = [self archive] ;
		NSError* error = nil ;
        if (archiveData) {
            NSError* unarchivingError = nil;
            m_error = [NSKeyedUnarchiver unarchivedObjectOfClasses:[self errorClasses]
                                                          fromData:archiveData
                                                             error:&unarchivingError];
            if (unarchivingError) {
                NSInteger errorCode = 284980;
                NSString* exceptionName = nil;
                NSString* exceptionReason = nil;
                /* Even after migrating data from BkmkMgrs version 2 to 3,
                 here in 2022 Oct, and adding everything except the kitchen
                 sink to +errorClasses, I'm not sure, I still may have seen
                 unarchiving errors in some users' data I have received.  To
                 make sure that any improperly archived errors I may still be
                 generating get caught so I can fix them… */
                NSString* deprecatedlyUnarchivedErrorString = nil;
                /* Try to unarchive using the less restrictive, depracated method… */
                SEL selector = @selector(unarchiveObjectWithData:);
                if ([[NSKeyedUnarchiver class] respondsToSelector:selector]) {
                    errorCode = 284981;
                    NSError* deprecatedlyUnarchivedError = nil;
                    @try {
                        deprecatedlyUnarchivedError = [NSKeyedUnarchiver performSelector:selector withObject:archiveData];
#if DEBUG
                        NSLog(@"Warning 582-4838 depracatedly unacrhived error:\n%@", deprecatedlyUnarchivedError);
                        NSLog(@"Warning 582-4838 continued … Long Description of error:\n%@", deprecatedlyUnarchivedError.longDescription);
#endif
                        if ([deprecatedlyUnarchivedError isKindOfClass:[NSError class]]) {
                            m_error = deprecatedlyUnarchivedError;
                        }
                        deprecatedlyUnarchivedErrorString = [deprecatedlyUnarchivedError longDescription];
                        deprecatedlyUnarchivedErrorString = [deprecatedlyUnarchivedErrorString stringByTruncatingMiddleToLength:1024
                                                                                                                     wholeWords:NO];
                    } @catch (NSException* exception) {
                        errorCode = 284982;
                        exceptionName = exception.name;
                        exceptionReason = exception.reason;
                    }
                } else {
                    /* Apparently, we are in some future macOS where the old
                     deprecated method no longer exists. */
                    errorCode = 284983;
                }
                
                NSMutableDictionary* userInfo = [NSMutableDictionary new];
                [userInfo setObject:@"Trouble unarchiving ErrorLog"
                             forKey:NSLocalizedDescriptionKey];
                [userInfo setValue:[[[self objectID] URIRepresentation] absoluteString]
                            forKey:@"Object ID (in Logs.sql??)"];
                [userInfo setValue:archiveData
                            forKey:@"Archive Data"];
                [userInfo setValue:exceptionName
                            forKey:@"Exception Name"];
                [userInfo setValue:exceptionReason
                            forKey:@"Exception Reason"];
                [userInfo setValue:deprecatedlyUnarchivedErrorString
                            forKey:@"Deprecatedly Unarchived Error"];
                [userInfo setObject:@YES
                             forKey:SSYIsOnlyInformationalErrorKey];
                NSError* error = [NSError errorWithDomain:[NSError myDomain]
                                                     code:errorCode
                                                 userInfo:userInfo];
                [userInfo release];
                [[BkmxBasis sharedBasis] logError:error
                                  markAsPresented:NO];
#if DEBUG
                NSLog(@"%@", [error longDescription]);
#endif
            }
        }
        
		if (!m_error) {
			NSString* msg = [NSString stringWithFormat:@"Sorry, could not unarchive error."] ;
			m_error = SSYMakeError(68458, msg) ;
			m_error = [m_error errorByAddingUnderlyingError:error] ;
			m_error = [m_error errorByAddingUserInfoObject:((id)archiveData ? (id)archiveData : @"nil")
													forKey:@"Archive Data"] ;
			m_error = [m_error errorByAddingUserInfoObject:[self timestamp]
													forKey:@"Time of Original Error"] ;
			[[self managedObjectContext] deleteObject:self] ;
			
			// Please do not drive the user crazy by trying to unarchive
			// this error again next time!
			[self markAsPresented] ;
		}
		
		[m_error retain] ;
	}	
	
	return m_error ;
}

- (void)setError:(NSError*)error {
    error = [error encodingFriendlyError];

    if (m_error != error) {
        [m_error release] ;
        m_error = [error retain] ;

        NSDictionary* encodeableUserInfo = [error.userInfo mutableCopyDeepStyle:SSYDeepCopyStyleBitmaskEncodeable] ;
        NSError* encodeableError = [NSError errorWithDomain:error.domain
                                                       code:error.code
                                                   userInfo:encodeableUserInfo] ;
        [encodeableUserInfo release] ;
        NSError* archivingError = nil;
        NSData* archive = [NSKeyedArchiver archivedDataWithRootObject:encodeableError
                                                requiringSecureCoding:YES
                                                                error:&archivingError] ;
        if (archivingError) {
            NSLog(@"Internal Error 939-3383 %@", archivingError);
        }

        /* Verify that the error can be unarchived, and if not, archive a
         bonehead error instead.  This section should no longer be necessary
         since I put a more general fix in CategoriesObjC commit 8f5337750.
         But I leave it in for defensive programming. */
        NSError* unarchivingError = nil;
        NSError* unarchivedError = [NSKeyedUnarchiver unarchivedObjectOfClasses:[self errorClasses]
                                                                       fromData:archive
                                                                          error:&unarchivingError];
        if (!unarchivedError) {
            encodeableError = [NSError errorWithDomain:error.domain
                                                           code:error.code
                                              userInfo:@{NSLocalizedDescriptionKey : @"Internal Error.  We have stripped the info of this error because, after archiving, it was not unarchivable."}] ;
            archive = [NSKeyedArchiver archivedDataWithRootObject:encodeableError
                                            requiringSecureCoding:YES
                                                            error:&archivingError] ;
            if (archivingError) {
                NSLog(@"Internal Error 939-3385 %@", archivingError);
            }
            
            /* Verify that the bonehead error can be unarchived, and if not,
                give up. */
            unarchivedError = [NSKeyedUnarchiver unarchivedObjectOfClasses:[self errorClasses]
                                                                           fromData:archive
                                                                              error:&unarchivingError];
            if (unarchivedError == nil) {
                NSLog(@"Internal Error 939-3387");
                archive = nil;
            }
        }

        [self setArchive:archive];
    }
}

- (BOOL)wasPresented {
	return [[self presented] boolValue] ;
}

- (void)markAsPresented {
	[self setPresented:[NSNumber numberWithBool:YES]] ;
}

- (NSString*)header {
	return [NSString stringWithFormat:
			@"%@ %@ Error %ld",
			[self formattedDate],
			[self processDisplayType],
			(long)[[self error] code]] ;
}

- (NSString*)abstraction {
	NSString* maybeNew ;
	if ([self wasPresented]) {
		maybeNew = @"" ;
	}
	else {
		maybeNew = [NSString stringWithFormat:
					@"(* %@! *) ",
					[[NSString localize:@"new"] uppercaseString]] ;
	}
	NSString* shortyDescription = @"" ;
	NSString* descr = [[self error] localizedDescription] ;
	if (descr) {
		NSScanner* scanner = [[NSScanner alloc] initWithString:descr] ;
		[scanner setCharactersToBeSkipped:nil] ;
		[scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet]
								intoString:&shortyDescription] ;
		[scanner release] ;
	}
	
	return [NSString stringWithFormat:
			@"%@ %@%@",
			[self header],
			maybeNew,
			shortyDescription] ;
}

- (NSAttributedString*)summary {
	NSError* error = [self error] ;
	NSString* localizedDeepDescription = [error localizedDeepDescription] ;
	NSString* string = [NSString stringWithFormat:
						@"%@\n%@",
						[self header],
						localizedDeepDescription] ;
    NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSFont systemFontOfSize:11.0], NSFontAttributeName,
                                [NSColor controlTextColor], NSForegroundColorAttributeName,
                                nil] ;
    NSAttributedString* answer = [[NSAttributedString alloc] initWithString:string
                                                                 attributes:attributes];
    [answer autorelease];
    return answer ;
}

- (NSAttributedString*)details {
	NSString* string = [NSString stringWithFormat:@"Error in %@ pid=%@ at %@\n%@\n\n",
                        [self processDisplayType],
                        [self processId],
                        [self formattedDate],
                        [[self error] longDescription]] ;
    NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSFont systemFontOfSize:11.0], NSFontAttributeName,
                                [NSColor controlTextColor], NSForegroundColorAttributeName,
                                nil] ;
    NSAttributedString* answer = [[NSAttributedString alloc] initWithString:string
                                                                 attributes:attributes];
    [answer autorelease];
    return answer ;
}

- (NSString*)shortDescription {
	return [[super shortDescription] stringByAppendingFormat:@" prsntd=%ld", (long)[self wasPresented]] ;
}

@end
