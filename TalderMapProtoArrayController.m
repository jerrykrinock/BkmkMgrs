#import "TalderMapProtoArrayController.h"
#import "TalderMapsController.h"
#import "TalderMapProto.h"
#import "Client.h"
#import "Macster.h"
#import "BkmxDoc.h"
#import "Starker.h"

@implementation TalderMapProtoArrayController

- (id)newObject {
    // Get info about aur mission
    NSDictionary* info = [self infoForBinding:@"contentArray"] ;
    NSString* bindingKey = [info objectForKey:NSObservedKeyPathKey] ;
    TalderMapsController* controller = [info objectForKey:NSObservedObjectKey] ;
    Client* client = [controller client] ;
    Starker* starker = [[[client macster] bkmxDoc] starker] ;
    
    // Set initial value for 'polarity"
    NSArray* availablePolarities = nil ;
    if ([bindingKey isEqualToString:@"folderMapProtos"]) {
        availablePolarities = [client availablePolaritiesForFolderMaps] ;
    }
    else {
        // bindingKey isEqualToString:@"tagMapProtos"
        availablePolarities = [client availablePolaritiesForTagMaps] ;
    }

    TalderMapProto* proto = (TalderMapProto*)[super newObject] ;
    
    // But bail out if this Client supports neither tags nor folders!
    if ([availablePolarities count] < 1) {
        /* Defensive programming, because the Tag ↔ Folder Mappings button
         should be hidden.  But in case that fails, return an empty
         prototype… */
        return proto ;
    }

    NSNumber* polarity = [availablePolarities objectAtIndex:0] ;
    [proto setPolarity:polarity] ;

    // Set initial value for 'tag'
    [proto setTag:@"to-read"] ;
    
    
    // Set initial value for 'folder'
    Stark* folder =  [starker hartainerOfSharype:SharypeUnfiled
                                         quickly:NO] ;
    if (!folder) {
        folder =  [starker hartainerOfSharype:SharypeBar
                                      quickly:NO] ;
    }
    if (!folder) {
        folder =  [starker hartainerOfSharype:SharypeMenu
                                      quickly:NO] ;
    }
    if (!folder) {
        folder =  [starker hartainerOfSharype:SharypeRoot
                                      quickly:NO] ;
    }
    if (!folder) {
        NSLog(@"Internal Error 282-5439 %@ %@", starker, folder) ;
    }
    [proto setFolder:folder] ;

    return proto ;
}


@end
