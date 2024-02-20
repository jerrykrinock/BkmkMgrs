#import "Bkmslf.h"
#import "BkmxDocumentController.h"
#import "NSDocumentController+DisambiguateForUTI.h"
#import "BSManagedDocument.h"
#import "NSSet+SimpleMutations.h"
#import "SSYAlert.h"
#import "NSError+MyDomain.h"
#import "NSError+InfoAccess.h"

@implementation Bkmslf

- (NSString *)windowNibName {
    return  nil ;
}

- (NSData *)dataOfType:(NSString*)typeName
                 error:(NSError**)error_p {
    return nil ;
}

/* This method, in fact, does not read any data.  Instead, it gets the
 URL, converts the file at that URL to a .bmco package, moves it if it
 is in *Bookmarkshelf Documents* to a new *Collections* folder,
 creating if needed, and finally opens the new converted .bmco file.  */

- (BOOL)readFromData:(NSData*)data
              ofType:(NSString*)typeName
               error:(NSError**)error_p {
    NSError* error = nil ;
    BOOL ok = YES ;

    NSString* bkmslfPath = [[self fileURL] path];

    NSString* bkmxPath;
    if ([bkmslfPath hasPrefix:[Bkmslf legacyDefaultDocumentFolderPath]]) {
        NSString* defaultDocumentFolder = [(BkmxDocumentController*)[NSDocumentController sharedDocumentController] defaultDocumentFolderError_p:NULL];
        bkmxPath = [defaultDocumentFolder stringByAppendingPathComponent:[bkmslfPath lastPathComponent]];
    } else {
        bkmxPath = bkmslfPath;
    }
    bkmxPath = [bkmxPath stringByDeletingPathExtension];
    bkmxPath = [bkmxPath stringByAppendingPathExtension:[(BkmxDocumentController*)[NSDocumentController sharedDocumentController] defaultDocumentFilenameExtension]];

    NSString* storeContentsFolder = [bkmxPath stringByAppendingPathComponent:[BSManagedDocument storeContentName]];
    [[NSFileManager defaultManager] createDirectoryAtPath:storeContentsFolder
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
    if (error) {
        error = [SSYMakeError(289575, [Bkmslf errorPrefix]) errorByAddingUnderlyingError:error];
        ok = NO;
    }

    if (ok) {
        NSString* storePath = [storeContentsFolder stringByAppendingPathComponent:[BSManagedDocument persistentStoreName]];
        [[NSFileManager defaultManager] copyItemAtPath:bkmslfPath
                                                toPath:storePath
                                                 error:&error];
        if (error) {
            error = [SSYMakeError(289576, [Bkmslf errorPrefix]) errorByAddingUnderlyingError:error];
            ok = NO;
        }
    }

    if (ok) {
        [[NSDocumentController sharedDocumentController] openDocumentWithContentsOfURL:[NSURL fileURLWithPath:bkmxPath]
                                                                               display:YES
                                                                     completionHandler:^(NSDocument* bkmxDoc,
                                                                                         BOOL documentWasAlreadyOpen,
                                                                                         NSError* error) {
                                                                         if (bkmxDoc) {
                                                                             /* The following delay is because, if we delete the old bkmslf
                                                                              file synchronously here, Cocoa will log a half dozen stupid
                                                                              messages to the console indicating that the file could not be
                                                                              found. */
                                                                             [[Bkmslf class] performSelector:@selector(cleanUpDocumentAtPath:)
                                                                                                  withObject:bkmslfPath
                                                                                                  afterDelay:0.0];
                                                                         } else if (error) {
                                                                             error = [SSYMakeError(289577, [Bkmslf errorPrefix]) errorByAddingUnderlyingError:error];
                                                                             error = [error errorByAddingUserInfoObject:bkmslfPath
                                                                                                                 forKey:@"Old .bkmslf path"];
                                                                             [SSYAlert alertError:error];
                                                                         }
                                                                     }];
    }

    if (!ok && error_p) {
        error = [error errorByAddingUserInfoObject:bkmslfPath
                                            forKey:@"Old .bkmslf path"];
        *error_p = error ;
    }

    return ok ;
}

+ (NSString*)legacyDefaultDocumentFolderPath {
    NSString* defaultDocumentFolder = [(BkmxDocumentController*)[NSDocumentController sharedDocumentController] defaultDocumentFolderError_p:NULL];
    NSString* legacyDefaultDocumentFolder = [defaultDocumentFolder stringByDeletingLastPathComponent];
    return [legacyDefaultDocumentFolder stringByAppendingPathComponent:@"Bookmarkshelf Documents"];
}

+ (void)cleanUpDocumentAtPath:(NSString*)path {
    /* Any errors produced in this method are ignored because it's all just
     for clean-up and/or convenience and/or back-up functions, so any warnings
     we'd present would be more annoying to the user than whatever didn't
     happen. */
    [[NSFileManager defaultManager] removeItemAtPath:path
                                               error:NULL];

    NSString* legacyDefaultDocumentFolder = [Bkmslf legacyDefaultDocumentFolderPath];

    BOOL bkmslfFilesRemainInBookmarkshelfDocuments = NO;
    NSArray* remainingFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:legacyDefaultDocumentFolder
                                                                                  error:NULL];
    for (NSString* filename in remainingFiles) {
        if ([[filename pathExtension] isEqualToString:@"bkmslf"]) {
            bkmslfFilesRemainInBookmarkshelfDocuments = YES;
            break;
        }
    }

    if (!bkmslfFilesRemainInBookmarkshelfDocuments) {
        /* No more old .bkmslf files remain in the "Bookmarkshelf Documents"
         folder, so remove it. */
        [[NSFileManager defaultManager] removeItemAtPath:legacyDefaultDocumentFolder
                                                   error:NULL];
    }
    else {
        /* For the convenience of users who have more than one .bkmslf, since
         NSNavLastRootDirectory will no longer prompt "Bookmarkshelf Documents",
         ensure that a symlink to "Bookmarkshelf Documents" exists in
         "Collections", so that users can still find their old documents
         in case "Recent Documents" does not work for some reason. */
        NSString* symlinkName = @"Bookmarkshelf Documents (legacy .bkmslf files)";
        NSString* collectionsPath = [(BkmxDocumentController*)[NSDocumentController sharedDocumentController] defaultDocumentFolderError_p:NULL];
        NSString* symlinkPath = [collectionsPath stringByAppendingPathComponent:symlinkName];
        if (![[NSFileManager defaultManager] fileExistsAtPath:symlinkPath
                                                  isDirectory:NULL]) {
            [[NSFileManager defaultManager] createSymbolicLinkAtPath:symlinkPath
                                                 withDestinationPath:[Bkmslf legacyDefaultDocumentFolderPath]
                                                               error:NULL];
        }
    }
}

+ (NSString*)errorPrefix {
    return @"Error converting old .bkmslf file to new .bmco file package";
}

@end
