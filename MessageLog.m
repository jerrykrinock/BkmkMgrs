#import "MessageLog.h"
#import "NSDate+NiceFormats.h"

@interface MessageLog (CoreDataGeneratedPrimitiveAccessors)

@end


@implementation MessageLog

@dynamic message ;

- (NSString*)stringRepresentation {
	return [NSString stringWithFormat:
			@"%@\t%@\t%ld\t%@",
			[[self timestamp] geekDateTimeString],
			[self processDisplayType],
			(long)[[self processId] integerValue],
			[self message]] ;
}


#if 0
#warning Testing snapshot events

- (NSString*)essentialInfo {
    return [[NSString alloc] initWithFormat:
            @"%p oid=%@",
            self,
            [[self objectID] URIRepresentation]] ;
}

- (void)awakeFromInsert {
    NSLog(@"awakeInsert %@",
          [self essentialInfo]) ;
	[super awakeFromInsert] ;
}

- (void)awakeFromFetch {
    NSLog(@"awakeFetch %@",
          [self essentialInfo]) ;
	[super awakeFromFetch] ;
}

- (void)awakeFromSnapshotEvents:(NSSnapshotEventType)flags {
    NSLog(@"awakeSSEvt %@ flags=0x%lx",
                     [self essentialInfo],
                     (long)flags) ;
    [super awakeFromSnapshotEvents:flags ] ;
}

- (void)willTurnIntoFault {
    NSLog(@"willFault %@",
          [self essentialInfo]) ;
	[super willTurnIntoFault] ;
}

#endif

@end
