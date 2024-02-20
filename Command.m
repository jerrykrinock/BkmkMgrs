#import "Command.h"
#import "Syncer.h"
#import "Macster.h"

NSString* const constKeyMethod = @"method" ;
NSString* const constKeyArgument = @"argument" ;

@interface Command (CoreDataGeneratedPrimitiveAccessors)

- (void)setPrimitiveSyncer:(Syncer*)value;
- (void)setPrimitiveIndex:(NSNumber*)value;
- (NSString *)primitiveMethod;
- (void)setPrimitiveMethod:(NSString *)value;
- (id)primitiveArgument;
- (void)setPrimitiveArgument:(id)value;

@end

@implementation Command

+ (BOOL)doesImportMethodName:(NSString*)methodName {
	return [methodName hasPrefix:@"import"] ;
}

+ (BOOL)doesExportMethodName:(NSString*)methodName {
	return [methodName hasPrefix:@"export"] ;
}

+ (BOOL)does1MethodName:(NSString*)methodName {
	return [methodName hasSuffix:@"1"] ;
}

+ (NSInteger)severityWhenSettingMethodName:(NSString*)methodName {
    NSInteger severity = 4 ;
	if (methodName != nil) {
		if ([Command doesImportMethodName:methodName]) {
			severity = 7 ;
		}
		else {
			severity = 5 ;
		}
	}
	
	return severity ;
}

#pragma mark * Accessors for non-managed object properties


#pragma mark * Core Data Generated Accessors for managed object properties

// Attributes
@dynamic method ;
@dynamic argument ;
@dynamic index ;

// Relationships
@dynamic syncer ;


- (NSString*)shortDescription {
	return [NSString stringWithFormat:
			@"<Command %p idx=%ld meth=%@ arg=%@",
			self,
			(long)[[self index] integerValue],
			[self method],
			[[self argument] shortDescription]] ;
}

- (NSArray*)deferenceChoices {
	return [NSArray arrayWithObjects:
			[NSNumber numberWithInteger:BkmxDeferenceYield],
			[NSNumber numberWithInteger:BkmxDeferenceQuit],
			[NSNumber numberWithInteger:BkmxDeferenceKill],
			nil] ;
}

- (NSArray*)argumentChoices {
	NSArray* choices ;
	
	NSString* method = [self method] ;
	
	choices = nil ;
	Syncer* syncer = [self syncer] ;
	if (
		(
		 [Command doesImportMethodName:method]
		 ||
		 [Command doesExportMethodName:method]
		 )
		&&
		[syncer anyTriggerNeedsDeference]
		) {
		choices = [self deferenceChoices] ;
	}
	
	return choices ;
}
+ (NSSet*)keyPathsForValuesAffectingArgumentChoices {
	return [NSSet setWithObjects:
			@"method",
			// @"syncer.triggers", 
			/* The above was removed in BookMacster 1.1.10 because it was causing 
			 "Cannot remove an observer <NSTableBinder 0x17098ee0> for the key path
			 "syncer.triggers" from <Command 0x19954740>, most likely because the
			 value for the key "syncer" has changed without an appropriate KVO
			 notification being sent. Check the KVO-compliance of the Command class."
			 when a document had the two default Simple Syncers, and when I clicked
			 "Advanced", and then changed the selected Syncer from the first to the
			 second.  When I removed this, to my surprise, the Command details
			 (argument) choices still update appropriately when I change the trigger.
			 I don't see how, but apparently my recently-added syncersDummyForKVO or
			 clientsDummyForKVO notifications are doing the job that the above
			 formerly did, and doing it again here results in "over-notification"
			 which causes the problem.  See the last message in this thread:
			 http://www.cocoabuilder.com/archive/cocoa/205845-cannot-remove-an-observer-because-it-is-not-registered-as-an-observer.html?q=%22Check+the+KVO-compliance%22#205845
			 But he doesn't get it either.  Some further study is needed!
			 Later, in BookMacster 1.1.24, I tried this.  Didn't say why:
			 @"syncer.macster.syncersDummyForKVO",
			 @"syncer.macster.clientsDummyForKVO",
			 Still later, in BookMacster 1.2.8, I found that this was causing the
			 problem again.  For steps to reproduce see +[Trigger keyPathsForValuesAffectingDetailChoices].
			 The log message would complain about either "syncer.macster.clientsDummyForKVO"
			 or "syncer.macster.syncersDummyForKVO", depending on which of the above
			 two lines was uncommented. */
			nil] ;
}

- (BOOL)hasArgumentChoices {
	return ([self argumentChoices] != nil) ;
}
+ (NSSet*)keyPathsForValuesAffectingHasArgumentChoices {
	return [NSSet setWithObjects:
			@"argumentChoices",
			nil] ;
}

- (void)refreshArgument {
	if ([self hasArgumentChoices]) {
		if (![self argument]) {
			[self setArgument:[NSNumber numberWithInteger:BkmxDeferenceYield]] ;
		}
	}
	else {
		[self setArgument:nil] ;
		// The above causes the associated popup menu to go blank
		// and not pop up any selections when clicked.  That's what we want
        // if there are no argument choices.
	}
}

- (void)setSyncer:(Syncer*)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeySyncer] ;
	[self willChangeValueForKey:constKeySyncer] ;
    [self setPrimitiveSyncer:newValue] ;
    [self didChangeValueForKey:constKeySyncer] ;
}

- (void)setArgument:(id)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeyArgument] ;
	[self willChangeValueForKey:constKeyArgument] ;
    [self setPrimitiveArgument:newValue] ;
    [self didChangeValueForKey:constKeyArgument] ;
	
	[[[self syncer] macster] postTouchedSyncer:[self syncer]
                                     severity:4] ;
}

+ (NSSet *)keyPathsForValuesAffectingHasArgument {
	return [NSSet setWithObject:constKeyMethod] ;	
}

- (void)setIndex:(NSNumber*)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeyIndex] ;
	[self willChangeValueForKey:constKeyIndex] ;
    [self setPrimitiveIndex:newValue] ;
    [self didChangeValueForKey:constKeyIndex] ;
	
	[[[self syncer] macster] postTouchedSyncer:[self syncer]
                                     severity:3] ;
}

- (void)setMethod:(NSString*)newValue  {
	[self postWillSetNewValue:newValue
					   forKey:constKeyMethod] ;
	[self willChangeValueForKey:constKeyMethod] ;
    [self setPrimitiveMethod:newValue] ;
    [self didChangeValueForKey:constKeyMethod] ;
	
	[self refreshArgument] ;
	
	NSInteger severity = [Command severityWhenSettingMethodName:newValue] ;
	
	[[[self syncer] macster] postTouchedSyncer:[self syncer]
                                     severity:severity] ;
}

- (void)awakeFromInsert {
	[super awakeFromInsert] ;
	
    [self setMethod:@"No-Method-Yet"] ;
    // Was importAll until BookMacster 1.20.2.
    // Changed it because that would cause high "severity" of change.
	[self setArgument:[NSNumber numberWithInteger:BkmxDeferenceYield]] ;
}

@end
