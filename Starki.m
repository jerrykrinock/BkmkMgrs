#import "Starki.h"
#import "Stark+Attributability.h"
#import "NSInvocation+Quick.h"
#import "NSString+BkmxDisplayNames.h"
#import "StarkEditor.h"
#import "BkmxBasis+Strings.h"
#import "NSArray+Stringing.h"
#import "NSObject+MoreDescriptions.h"
#import "Stark.h"
#import "SSYProgressView.h"
#import "NSString+LocalizeSSY.h"

@interface Starki ()

@property (retain) NSArray* starks ;

@end


@implementation Starki

@synthesize starks = m_starks ;

- (id)initWithStarks:(NSArray*)starks {
	self = [super init] ;
	if (self) {
		[self setStarks:starks] ;
	}
	
	return self ;
}

- (void)dealloc {
	[m_starks release] ;
	
	[super dealloc] ;
}

- (NSString*)description {
    return [NSString stringWithFormat:
            @"%@ with starks: %@",
            [super description],
            [[self starks] shortDescription]] ;
}

+ (Starki*)starkiWithStarks:(NSArray*)starks {
	Starki* starki = [[self alloc] initWithStarks:starks] ;
	[starki autorelease] ;
	
	return starki ;
}

- (Stark*)stark {
    return [[self starks] firstObject] ;
}

+ (NSSet*)keyPathsForValuesAffectingStark {
    return [NSSet setWithObject:@"starks"] ;
}

- (NSDictionary*)lineageStatus {
    NSDictionary* lineageStatus ;
    Stark* stark = [self stark] ;
    if (stark) {
        lineageStatus = [[self stark] lineageStatus] ;
    }
    else {
        lineageStatus = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSString localizeFormat:@"no%0", [NSString localize:@"selection"]], constKeyPlainText,
                         nil] ;
    }

    return lineageStatus ;
}

+ (NSSet*)keyPathsForValuesAffectingLineageStatus {
    NSMutableSet* paths = [[NSMutableSet alloc] init] ;
    [paths addObject:@"stark"] ;
    for (NSString* path in [Stark keyPathsForValuesAffectingLineageStatus]) {
        [paths addObject:[NSString stringWithFormat:@"stark.%@", path]] ;
    }
    NSSet* answer = [paths copy] ;
    [answer autorelease] ;
    [paths release] ;

    return answer ;
}

- (BOOL)allStarksAreTaggable {
	if ([[self starks] count] == 0) {
		return NO ;
	}
	
	for (Stark* stark in [self starks]) {
		if (![stark canHaveTags]) {
			return NO ;
		}
		if (![stark isAStark]) {
			return NO ;
		}
	}

	return YES ;
}
+ (NSSet*)keyPathsForValuesAffectingAllStarksAreTaggable {
	return [NSSet setWithObjects:
			@"starks",
			nil] ;
}

/*!
 @details  This method was found to be needed in +[StarkEditor parentingAction:::::],
 after clicking the 'Move' hyperlink in the Inspector.
 It may be needed in other places too.
*/
- (id)owner {
	return [[[self starks] objectAtIndex:0] owner] ;
}

- (BOOL)isEqual:(Starki*)other {
    return [[self starks] isEqualToArray:[other starks]];
}

- (id)valueForUndefinedKey:(NSString*)key {
	id concensusValue = NSBindingSelectionMarker.noSelectionMarker ;
	
	for (Stark* stark in [self starks]) {
		// If *any* stark cannot have the given key, break and return NSNotApplicableMarker
		SEL canHaveSelector = NSSelectorFromString([NSString stringWithFormat:
													@"canHave%@",
													[key capitalizedString]]) ;
		if ([stark respondsToSelector:canHaveSelector]) {
			NSInvocation* invocation = [NSInvocation invocationWithTarget:stark
																 selector:canHaveSelector
														  retainArguments:NO
														argumentAddresses:NULL] ;
			[invocation invoke] ;
			BOOL canHave ;
			[invocation getReturnValue:&canHave] ;
			if (!canHave) {
				concensusValue = NSBindingSelectionMarker.notApplicableSelectionMarker ;
				break ;
			}
		}
		
		id thisStarkValue = [stark valueForKey:key] ;
		id thisStarkContribution = [stark valueForKey:key] ;
		if ([thisStarkContribution isKindOfClass:[NSArray class]]) {
			thisStarkValue = [NSCountedSet set] ;
			[thisStarkValue addObjectsFromArray:thisStarkContribution] ;
		}
		else if ([thisStarkContribution isKindOfClass:[NSSet class]]) {
			// This branch will probably never execute
			thisStarkValue = [NSCountedSet set] ;
			for (id object in thisStarkContribution) {
				[thisStarkValue addObject:object] ;
			}
		}

		Class collectionClass = [Stark collectionClassForAttribute:key] ;
		if (!thisStarkValue) {
			if (collectionClass != nil) {
				thisStarkValue = [NSCountedSet set] ;
			}
		}
		
		if (concensusValue == NSBindingSelectionMarker.noSelectionMarker) {
			concensusValue = thisStarkValue ;
		}
		else if (![thisStarkValue isEqual:concensusValue]) {
			if (collectionClass != nil) {
				for (id object in thisStarkValue) {
					[concensusValue addObject:object] ;
				}
			}
			else {
				concensusValue = NSBindingSelectionMarker.multipleValuesSelectionMarker ;
				break ;
			}
		}
	}

	if ([concensusValue respondsToSelector:@selector(count)]) {
        // Replace empty set with nil.
		if ([(NSSet*)concensusValue count] == 0) {
			concensusValue = nil ;
		}
        
        // Replace counted set with array
        concensusValue = [concensusValue allObjects];
	}

	return concensusValue ;
}

+ (void)didApproveChangesSheet:(NSWindow*)sheet
					returnCode:(NSInteger)returnCode
                   contextInfo:(void*)contextInfo {
   NSDictionary* changes = (NSDictionary*)contextInfo ;
	if (returnCode == NSAlertFirstButtonReturn) {
		NSArray* starks = [changes objectForKey:constKeyStarks] ;
		
		NSString* key = [changes objectForKey:constKeyKey] ;
		if (key) {
			id value = [changes objectForKey:NSKeyValueChangeNewKey] ;
			for (Stark* stark in starks) {
				[stark setValue:value
						 forKey:key] ;
			}
		}
		else {
			[StarkEditor addTags:[changes objectForKey:constKeyTagsAdded]
					 toBookmarks:starks] ;
			[StarkEditor removeTags:[changes objectForKey:constKeyTagsDeleted]
					  fromBookmarks:starks] ;
		}
	}
	
	[changes release] ;
}

#define STARKS_CHANGE_WARNING_LIMIT 2

- (void)setValue:(id)value
 forUndefinedKey:(NSString*)key {
    NSString* msg = nil ;
	NSDictionary* changes = nil ;
	if ([key isEqualToString:constKeyTags]) {
		NSCountedSet* allExistingTags = [[NSCountedSet alloc] init] ;
		for (Stark* stark in [self starks]) {
            NSArray* moreTags = [stark tags];
			NSSet* set = [[NSSet alloc] initWithArray:moreTags] ;
			[allExistingTags unionSet:set] ;
			[set release] ;
		}
		NSMutableSet* addedTags = [[NSMutableSet alloc] initWithArray:(NSArray*)value] ;
		[addedTags minusSet:allExistingTags] ;
		
		NSMutableSet* commonExistingTags = [allExistingTags mutableCopy] ;
		for (Tag* tag in allExistingTags) {
			for (Stark* stark in [self starks]) {
				if ([[stark tags] indexOfObject:tag] == NSNotFound) {
					[commonExistingTags removeObject:tag] ;
					break ;
				}
			}
		}
		
		NSMutableSet* deletedTags = [[NSMutableSet alloc] init] ;
		for (NSString* tag in commonExistingTags) {
			if ([(NSArray*)value indexOfObject:tag] == NSNotFound) {
				[deletedTags addObject:tag] ;
			}
		}
		
		
		changes = [[NSMutableDictionary alloc] init] ;
		[changes setValue:[self starks]
				   forKey:constKeyStarks] ;
		[changes setValue:[addedTags allObjects]
				   forKey:constKeyTagsAdded] ;
		[changes setValue:[deletedTags allObjects]
				   forKey:constKeyTagsDeleted] ;
		
		if ([[self starks] count] > STARKS_CHANGE_WARNING_LIMIT) {
			if (([addedTags count] > 0) && ([deletedTags count] > 0)) {
				msg = [NSString stringWithFormat:
					   @"Please confirm adding %@ (%@); and also deleting %@ (%@) in %ld items.",
					   [key bkmxAttributeDisplayName],
					   [[addedTags allObjects] listNames],
					   [key bkmxAttributeDisplayName],
					   [[deletedTags allObjects] listNames],
					   (long)[[self starks] count]] ;
			}
			else if ([addedTags count] > 0) {
				msg = [NSString stringWithFormat:
					   @"Please confirm adding %@ (%@) to %ld items.",
					   [key bkmxAttributeDisplayName],
					   [[addedTags allObjects] listNames],
					   (long)[[self starks] count]] ;
			}
			else if ([deletedTags count] > 0) {
				msg = [NSString stringWithFormat:
					   @"Please confirm deleting %@ (%@) from %ld items.",
					   [key bkmxAttributeDisplayName],
					   [[deletedTags allObjects] listNames],
					   (long)[[self starks] count]] ;
			}
		}
		
		[allExistingTags release] ;
		[commonExistingTags release] ;
		[addedTags release] ;
		[deletedTags release] ;
		// We do not need to remove duplicates nor alphabetize
		// because -[Stark setTags:] will do that for us.
	}
	else {
		if ([[self starks] count] > STARKS_CHANGE_WARNING_LIMIT) {
			msg = [NSString stringWithFormat:
				   @"Please confirm changing %@ for %ld items to '%@'.",
				   [key bkmxAttributeDisplayName],
				   (long)[[self starks] count],
                   [key bkmxDisplayNameForValue:value]] ;
		}
		
		changes = [[NSMutableDictionary alloc] init] ;
		[changes setValue:[self starks]
				   forKey:constKeyStarks] ;
		[changes setValue:value
				   forKey:NSKeyValueChangeNewKey] ;
		[changes setValue:key
				   forKey:constKeyKey] ;		
	}
	
	if (msg) {
		SSYAlert* alert = [SSYAlert alert] ;
		NSWindow* window = [NSApp keyWindow] ;
		if (!window) {
			NSLog(@"Internal Error 493-2468 %@", alert) ;
		}
		[alert setIconStyle:SSYAlertIconInformational] ;
		[alert setSmallText:msg] ;
		[alert setButton1Title:[[BkmxBasis sharedBasis] labelOk]] ;
		[alert setButton2Title:[[BkmxBasis sharedBasis] labelCancel]] ;
        /* We direct the sheet callback to a class method, in case of the rare
         but possible (if the user has two documents open) case in which the
         selected starks change before the callback is invoked.  This instance
         will have been released, causing a crash. */
        Class class = [self class] ;
        /* Instead of showing the sheet immediately, we package as an invocation
         and show with a 0.0 second delay.  The reason for that is because,
         otherwise, when the sheet shows, the Inspector is forced to resign key,
         invoking -endEditing on the token field, which causes this method to be
         invoked by Cocoa Bindings again.  In other words, we kind of reach
         around, kick ourselves in the pants, and re-burp.  With the delay, the
         second invocation of this method does not occur.  I'm not sure why.
         Maybe it's because we've already resigned key or something. */
        BOOL no = NO;
        NSInvocation* invo = [NSInvocation invocationWithTarget:alert
                                                       selector:@selector(runModalSheetOnWindow:resizeable:modalDelegate:didEndSelector:contextInfo:)
                                                retainArguments:YES
                                              argumentAddresses:&window, &no, &class, &@selector(didApproveChangesSheet:returnCode:contextInfo:), &changes] ;
        [invo performSelector:@selector(invoke)
                   withObject:nil
                   afterDelay:0.0] ;
	}
	else {
		// Invoke the callback immediately
#if 0
#warning  Starting in Xcode 4.6.2, clang analyzer thinks that I'm leaking 'changes' when I do this.
#warning  Another alternative would be to use #ifndef __clang_analyzer__
        [[self class] didApproveChangesSheet:nil
								  returnCode:NSAlertFirstButtonReturn
                                 contextInfo:changes] ;
#else
        // Added to satisfy Clang in Xcode 4.6.2, BookMacster 1.14.9
        NSObject* aNil = nil ;
        NSInteger alertReturn = NSAlertFirstButtonReturn ;
		NSInvocation* invocation = [NSInvocation invocationWithTarget:[self class]
                                                              selector:@selector(didApproveChangesSheet:returnCode:contextInfo:)
                                                       retainArguments:NO  // Only object argument is changes, which is already retained
                                                     argumentAddresses:&aNil, &alertReturn, &changes] ;
        [invocation invoke] ;
#endif
	}
	
	// Note that we own an extra retain of 'changes' here.
	// It is released in the callback.
}

/* The following two methods became necessary after I fixed the
 NSTokenField completion issue (See Note 20120717) by binding
 to a "helper property" in InspectorController class instead of
 via the Stark Controller (NSObjectController) in Inspector.xib. */

- (NSArray*)tags {
    NSArray* tags = [self valueForUndefinedKey:constKeyTags] ;
	return tags ;
}

- (void)setTags:(NSArray*)tags {
	[self setValue:tags
   forUndefinedKey:constKeyTags] ;
}

@end
