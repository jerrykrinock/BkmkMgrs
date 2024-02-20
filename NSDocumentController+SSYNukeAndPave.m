#import "NSDocumentController+SSYNukeAndPave.h"
#import "NSFileManager+TempFile.h"
#import "NSString+MorePaths.h"
#import "BSManagedDocument.h"
/* BSManagedDocument is a open source replacement for NSPersistentDocument.
 It is recommended for any Core Data document-based app.
 https://github.com/jerrykrinock/BSManagedDocument
 */

#ifndef SQLITE_CORRUPT
// This is defined in sqlite3.c, which we do not require.
#define SQLITE_CORRUPT 11
#endif

@implementation NSDocumentController (SSYNukeAndPave)

- (void)tryNukeAndPaveURL:(NSURL*)url
                  errorIn:(NSError*)errorIn
             storeOptions:(NSDictionary*)storeOptions
       modelConfiguration:(NSString*)modelConfiguration
                  display:(BOOL)display
        completionHandler:(void(^)(
                                   SSYNukeAndPaveResult result,
                                   NSString* movedToPath,
                                   NSDocument* documentOut
                                   ))completionHandler  {
    BOOL isCorruptSQLiteDatabase = NO ;
    NSDictionary* errorInfo = [errorIn userInfo] ;
 
    // Sadly, the constant NSUnderlyingException is not in the public API.
    // So we grub through the error's info on our hands and knees,
    // as we pray for one of several indications
    for (NSString* key in errorInfo) {
        id object = [errorInfo objectForKey:key] ;
        if ([key isEqualToString:NSSQLiteErrorDomain]) {
            if ([object respondsToSelector:@selector(integerValue)]) {
                if ([object integerValue] == SQLITE_CORRUPT) {
                    isCorruptSQLiteDatabase = YES ;
                    break ;
                }
            }
        }
        if ([object respondsToSelector:@selector(userInfo)]) {
            // In 10.9, another telltale object I've seen is a
            // _NSCoreDataException.  This is a subclass of NSException.
            NSDictionary* underlyingInfo = [object userInfo] ;
            NSNumber* weirdPlaceApplePutsErrorCode = [underlyingInfo objectForKey:NSSQLiteErrorDomain] ;
            if ([weirdPlaceApplePutsErrorCode respondsToSelector:@selector(integerValue)]) {
                if ([weirdPlaceApplePutsErrorCode integerValue] == SQLITE_CORRUPT) {
                    isCorruptSQLiteDatabase = YES ;
                    break ;
                }
            }
            // Maybe someday they'll decide to give us an underlying NSError?
            for (NSError* maybeUnderlyingError in underlyingInfo) {
                if ([maybeUnderlyingError isKindOfClass:[NSError class]]) {
                    if ([[maybeUnderlyingError domain] isEqualToString:NSSQLiteErrorDomain] && ([maybeUnderlyingError code] == SQLITE_CORRUPT)) {
                        isCorruptSQLiteDatabase = YES ;
                        break ;
                    }
                }
            }
        }
    }
    NSError* repairror = nil ;
    BOOL ok = YES ;
    if (isCorruptSQLiteDatabase) {
        NSString* temporaryPath = [[NSFileManager defaultManager] temporaryFilePath] ;
        NSDocument* newEmptyDocument = [self openUntitledDocumentAndDisplay:NO
                                                                      error:&repairror] ;
        if (newEmptyDocument) {
            NSURL* newEmptyDocumentUrl = [NSURL fileURLWithPath:temporaryPath] ;
            [newEmptyDocument setFileURL:newEmptyDocumentUrl] ;
            if ([newEmptyDocument respondsToSelector:@selector(managedObjectContext)]) {
                ok = [(BSManagedDocument*)newEmptyDocument configurePersistentStoreCoordinatorForURL:newEmptyDocumentUrl
                                                                                              ofType:[self defaultType]
                                                                                  modelConfiguration:modelConfiguration
                                                                                        storeOptions:storeOptions
                                                                                               error:&repairror] ;
                NSManagedObjectContext* newDocMoc = [(BSManagedDocument*)newEmptyDocument managedObjectContext] ;
                [newDocMoc save:&repairror] ;
            }
            else {
                // Insert code to save regular NSDocument here.  -writeToURL:: ??
                
                // Placeholder code:
                ok = NO ;
                NSLog(@"Internal Error 622-0011.  Code not implemented!") ;
            }
            
            if (ok) {
                NSString* path = [url path] ;
                NSString* hashifiedPath = [path hashifiedPath] ;
                ok = [[NSFileManager defaultManager] copyItemAtPath:path
                                                             toPath:hashifiedPath
                                                              error:&repairror] ;
                if (ok) {
                    NSData* newEmptyDocumentData = [[NSData alloc] initWithContentsOfURL:newEmptyDocumentUrl] ;
                    ok = [newEmptyDocumentData writeToURL:url
                                               atomically:NO] ;
                    [newEmptyDocumentData release] ;
                    if (ok) {
                        [self openDocumentWithContentsOfURL:url
                                                    display:YES
                                          completionHandler:^(NSDocument* documentOut,
                                                              BOOL documentWasAlreadyOpen,
                                                              NSError* repairror) {
                                              SSYNukeAndPaveResult result = documentOut ? SSYNukeAndPaveResultTriedAndSucceeded : SSYNukeAndPaveResultTriedAndFailed ;
                                              if (!documentOut) {
                                                  NSLog(@"Internal Error 622-0012.  Tried to move corrupt doc, but %@", repairror) ;
                                              }
                                              
                                              if (completionHandler) {
                                                  completionHandler(result, hashifiedPath, documentOut) ;
                                              }
                                          }] ;
                    }
                    else {
                        NSLog(@"Internal Error 622-0013.  Tried to pave new empty doc, but %@", repairror) ;
                    }
                }
                else {
                    NSLog(@"Internal Error 622-0014.  Tried to make new empty doc, but %@", repairror) ;
                }
            }
            else {
                NSLog(@"Internal Error 622-0015.  Tried to make new empty doc, but %@", repairror) ;
            }
        }
        else {
            NSLog(@"Internal Error 622-0016.  Tried to make new empty doc, but %@", repairror) ;
        }
    }
    
    if (completionHandler) {
        completionHandler(SSYNukeAndPaveResultTriedAndFailed, nil, nil) ;
    }
}


@end
