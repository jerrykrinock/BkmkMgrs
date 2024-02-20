#import "TalderMapsController.h"
#import "SSYMH.AppAnchors.h"
#import "BkmxAppDel.h"
#import "Client.h"
#import "Importer.h"
#import "Exporter.h"
#import "SSYMojo.h"
#import "FolderMap.h"
#import "Macster.h"
#import "BkmxDoc.h"
#import "SSYAlert.h"
#import "TalderMapProto.h"
#import "NSError+MoreDescriptions.h"

@interface TalderMapsController ()

@end

@implementation TalderMapsController

@synthesize client = m_client ;
@synthesize tagMapProtos = m_tagMapProtos ;
@synthesize folderMapProtos = m_folderMapProtos ;

- (NSArray*)protosFromTalderMaps:(NSArray*)talderMaps {
    NSSortDescriptor* descriptor = [NSSortDescriptor sortDescriptorWithKey:constKeyIndex
                                                                 ascending:YES] ;
    NSArray* descriptors = [NSArray arrayWithObject:descriptor] ;
    talderMaps = [talderMaps sortedArrayUsingDescriptors:descriptors] ;
    
    Starker* starker = [[[[self client] macster] bkmxDoc] starker] ;
    NSMutableArray* array = [[NSMutableArray alloc] init] ;
    for (TalderMap* talderMap in talderMaps) {
        TalderMapProto* proto = [[TalderMapProto alloc] init] ;
        [proto setTag:[talderMap tag]] ;
        NSExpression* lhs = [NSExpression expressionForKeyPath:constKeyStarkid] ;
		NSExpression* rhs = [NSExpression expressionForConstantValue:[talderMap folderId]] ;
		NSError* error = nil ;
		Stark* folder = (Stark*)[starker objectWithDirectPredicateLeftExpression:lhs
                                                                 rightExpression:rhs
                                                                    operatorType:NSEqualToPredicateOperatorType
                                                                         error_p:&error] ;
		[SSYAlert alertError:error] ;
        [proto setFolder:folder] ;
        Ixporter* ixporter = [talderMap ixporter] ;
        BkmxIxportPolarity polarity ;
        if ([ixporter isKindOfClass:[Importer class]]) {
            polarity = BkmxIxportPolarityImport ;
        }
        else if ([ixporter isKindOfClass:[Exporter class]]) {
            polarity = BkmxIxportPolarityExport ;
        }
        else {
            NSLog(@"Internal Error 295-0549 %@ %p", [ixporter className], ixporter) ;
            polarity = BkmxIxportPolarityExport ;
        }
        NSNumber* polarityNumber = [NSNumber numberWithInteger:polarity] ;
        [proto setPolarity:polarityNumber] ;
        
        [array addObject:proto] ;
        [proto release] ;
    }
    
    NSArray* answer = [NSArray arrayWithArray:array] ;
    [array release] ;
    return answer;
}

- (id)initWithClient:(Client*)client {
	self = [super initWithWindowNibName:@"ClientTalderMaps"] ;
	if (self) {
		[self setClient:client] ;

        NSArray* talderMaps ;

        // Set tagMapProtos from data model's tagMaps
        talderMaps = [[[client importer] tagMapsOrdered] arrayByAddingObjectsFromArray:[[client exporter] tagMapsOrdered]] ;
        [self setTagMapProtos:[self protosFromTalderMaps:talderMaps]] ;

        // Set folderMapProtos from data model's folderMaps
        talderMaps = [[[client importer] folderMapsOrdered] arrayByAddingObjectsFromArray:[[client exporter] folderMapsOrdered]] ;
        [self setFolderMapProtos:[self protosFromTalderMaps:talderMaps]] ;
}
	
	return self ;
}

- (void)dealloc {
    [m_tagMapProtos release] ;
    [m_folderMapProtos release] ;
    
	[super dealloc] ;
}

- (void)removeOurTalderMapsForEntityName:(NSString *)entityName {
    Client* client = [self client] ;
    Importer* importer = [client importer] ;
    Exporter* exporter = [client exporter] ;
    
    NSManagedObjectContext* managedObjectContext = [client managedObjectContext] ;
    SSYMojo* mapMojo = [[SSYMojo alloc] initWithManagedObjectContext:managedObjectContext
                                                          entityName:entityName] ;
    
    NSExpression* lhs = [NSExpression expressionForKeyPath:constKeyIxporter] ;
    NSExpression* rhs ;
    rhs = [NSExpression expressionForConstantValue:importer] ;
    NSPredicate* isOurImporter = [NSComparisonPredicate predicateWithLeftExpression:lhs
                                                                    rightExpression:rhs
                                                                           modifier:NSDirectPredicateModifier
                                                                               type:NSEqualToPredicateOperatorType
                                                                            options:0] ;
    rhs = [NSExpression expressionForConstantValue:exporter] ;
    NSPredicate* isOurExporter = [NSComparisonPredicate predicateWithLeftExpression:lhs
                                                                    rightExpression:rhs
                                                                           modifier:NSDirectPredicateModifier
                                                                               type:NSEqualToPredicateOperatorType
                                                                            options:0] ;
    NSPredicate* predicate = [NSCompoundPredicate orPredicateWithSubpredicates:
                              [NSArray arrayWithObjects:
                               isOurImporter,
                               isOurExporter,
                               nil]] ;
    NSError* error = nil ;
    NSArray* ourMaps = [mapMojo objectsWithPredicate:predicate
                                             error_p:&error] ;
    if (error) {
        NSLog(@"Internal Error 962-0926 %@", [error longDescription]) ;
    }
    for (TalderMap* map in ourMaps) {
        [mapMojo deleteObject:map] ;
    }
    [mapMojo release] ;
}

- (void)modelEntityName:(NSString *)entityName
    fromTalderMapProtos:(NSArray *)talderMaps {
    Client* client = [self client] ;
    NSManagedObjectContext* managedObjectContext = [client managedObjectContext] ;
    Importer* importer = [client importer] ;
    Exporter* exporter = [client exporter] ;
    NSInteger index = 0 ;
    for (TalderMapProto* proto in talderMaps) {
        TalderMap* talderMap = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                             inManagedObjectContext:managedObjectContext] ;
        Ixporter* ixporter ;
        NSNumber* polarity = [proto polarity] ;
        if (polarity) {
            BkmxIxportPolarity polarityValue = [polarity integerValue] ;
            if (polarityValue == BkmxIxportPolarityImport) {
                ixporter = importer ;
            }
            else {
                ixporter = exporter ;
            }
        }
        else {
            NSLog(@"Internal Error 495-3980") ;
            ixporter = exporter ;
        }
        [talderMap setIxporter:ixporter] ;
        [talderMap setAttributesFromProto:proto] ;
        [talderMap setIndex:[NSNumber numberWithInteger:index++]] ;
    }
}

/* 
 @details   The implementation of this method, which removes all existing
 tag maps and folder maps and creates new ones from scratch, is inefficient,
 not only in its own actions, but also it causes unnecessary invocations
 of -[Ixporter removeTagMapsObject:] and -[Ixporter addTagMapsObject:] which
 in turn invoke -[BkmxDoc forgetLast(Im|Ex)portedHashForClient:], which
 causes unnecessary imports and exports.  But the sheet controlled by this
 controller will be used so infrequently that this is not significant, whereas
 writing the code to do this efficiently would be very significant.
 
 Do not make the mistake of setting this method as the didEndSelector for
 the sheet *and* wiring the *Done* button to it.  That would cause it to
 be invoked twice, which will invoke [self release] twice, which will crash. */
- (IBAction)done:(id)sender {
    [self retain] ;
    [[[self window] sheetParent] endSheet:[self window]
                               returnCode:NSAlertFirstButtonReturn] ;
	[[self window] close] ;
	// Window is set to "Release when closed" in xib
    
    // Remove all existing tag maps and folder maps
    [self removeOurTalderMapsForEntityName:constEntityNameFolderMap];
    [self removeOurTalderMapsForEntityName:constEntityNameTagMap];
    
    // Create all new tag maps and folder maps
    [self modelEntityName:constEntityNameFolderMap
      fromTalderMapProtos:[self folderMapProtos]] ;
    [self modelEntityName:constEntityNameTagMap
      fromTalderMapProtos:[self tagMapProtos]] ;
    
    [[[[self client] macster] bkmxDoc] clearTalderMapper] ;
    
    [[[self client] macster] save] ;

	[self release] ;
}

- (IBAction)help:(id)sender {
    [(BkmxAppDel*)[NSApp delegate] openHelpAnchor:constHelpAnchorTabFolderMaps] ;
}

- (NSArray*)folders {
    BkmxDoc* bkmxDoc = [[[self client] macster] bkmxDoc] ;
	NSArray* folders = [bkmxDoc bookmarkContainers] ;

    return folders ;
}

- (NSArray*)availablePolaritiesForFolderMaps {
    return [[self client] availablePolaritiesForFolderMaps] ;
}

- (NSArray*)availablePolaritiesForTagMaps {
    return [[self client] availablePolaritiesForTagMaps] ;
}



@end
