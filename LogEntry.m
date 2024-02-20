#import "LogEntry.h"
#import "NSDate+NiceFormats.h"
#import "BkmxBasis.h"
#import "BkmxAppDel.h"
#import "BkmxBasis.h"

NSString* const constKeyMessage = @"message" ;
NSString* const constKeyTimestamp = @"timestamp" ;

@interface LogEntry (CoreDataGeneratedPrimitiveAccessors)


@end

@implementation LogEntry

- (void)awakeFromInsert {
	[super awakeFromInsert] ;
	
	short processType = BkmxLogProcessTypeNone ;
	NSString* processName = [[NSProcessInfo processInfo] processName] ;
    if ([processName hasSuffix:constAppNameBkmxAgent]) {
        processType = BkmxLogProcessTypeBkmxAgent ;
    } else if ([[BkmxBasis sharedBasis] isScripted]) {
        switch ([[BkmxBasis sharedBasis] iAm]) {
            case BkmxWhich1AppMarkster:
                processType = BkmxLogProcessTypeMarksterScripted ;
                break ;
            case BkmxWhich1AppSmarky:
                processType = BkmxLogProcessTypeSmarkyScripted ;
                break ;
            case BkmxWhich1AppSynkmark:
                processType = BkmxLogProcessTypeSynkmarkScripted ;
                break ;
            case BkmxWhich1AppBookMacster:
                processType = BkmxLogProcessTypeBookMacsterScripted ;
                break ;
        }
    }
    else {
        switch ([[BkmxBasis sharedBasis] iAm]) {
            case BkmxWhich1AppMarkster:
                processType = BkmxLogProcessTypeMarkster ;
                break ;
            case BkmxWhich1AppSmarky:
                processType = BkmxLogProcessTypeSmarky ;
                break ;
            case BkmxWhich1AppSynkmark:
                processType = BkmxLogProcessTypeSynkmark ;
                break ;
            case BkmxWhich1AppBookMacster:
                processType = BkmxLogProcessTypeBookMacster ;
                break ;
        }
    }
	[self setProcessType:[NSNumber numberWithShort:processType]] ;
	[self setProcessId:[NSNumber numberWithInteger:[[NSProcessInfo processInfo] processIdentifier]]] ;
	NSDate* date = [NSDate date] ;

	[self setTimestamp:date] ;
    // Starting with BookMacster 1.12.6, timestamp may be overwritten later.
    // Someday, it may always be overwritten, and on that day the preceding
    // statement may be removed.
}

@dynamic processType ;
@dynamic processId ;
@dynamic timestamp ;

- (NSString*)formattedDate {
	NSDate* timestamp = [self timestamp] ;
	NSString* answer = [timestamp geekDateTimeString] ; 
	return answer ;
}

+ (NSSet*)keyPathsForValuesAffectingFormattedDate {
	return [NSSet setWithObjects:
			@"timestamp",
			nil] ;
}

- (NSString*)processDisplayType {
    return [[BkmxBasis sharedBasis] processDisplayTypeForProcessType:(BkmxLogProcessType)[[self processType] integerValue]] ;
}

- (NSString*)shortDescription {
	return [NSString stringWithFormat:
			@"<%@ %p> %@ %@ pid=%@",
			[self className],
			self,
			[[self timestamp] geekDateTimeString],
			[self processDisplayType],
			[self processId]] ;
}

@end
