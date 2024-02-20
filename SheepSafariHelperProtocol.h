#import <Foundation/Foundation.h>

/* The protocol that this service will vend as its API. This header file will
 also need to be visible to the process hosting the service. */
@protocol SheepSafariHelperProtocol

- (void)importForKlientAppDescription:(NSString*)processDescription
                    completionHandler:(void (^)(NSDictionary* tree, NSDictionary* results, NSError* error))completionHandler;

- (void)exportForKlientAppDescription:(NSString*)processDescription
                              changes:(NSDictionary*)changes
                    completionHandler:(void (^)(NSString* indexPathsForProposedExids, NSDictionary* results, NSError* error))completionHandler;

@end
