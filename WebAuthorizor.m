#import "WebAuthorizor.h"
#import "NSString+LocalizeSSY.h"
#import "SSYProgressView.h"
#import "BkmxDoc.h"
#import "SSYOAuthTalker.h"
#import "ExtoreWebFlat.h"
#import "BkmxBasis+Strings.h"
#import "SSYLabelledTextField.h"
#import "SSYSynchronousHttp.h"
#import "Client.h"
#import "Macster.h"
#import "SSYKeychain.h"
#import "SSYWrappingCheckbox.h"
#import "SSWebBrowsing.h"
#import "NSInvocation+Quick.h"


NSString* const constKeyExtoreWebFlatInfo = @"info" ;
NSString* const constKeyExtoreWebFlatAuthInfo = @"authInfo" ;


@interface WebAuthorizor ()

@property NSError* error;
@property SSYOAuthTalker* talker;

@end


@implementation WebAuthorizor


- (NSString*)linkServiceMessage {
    return nil ;
}

- (BkmxDoc*)bkmxDoc {
    return self.client.bkmxDoc;
}

- (BkmxAuthorizationMethod)authorizationMethod {
    return [self.client.extoreClass constants_p]->authorizationMethod;
}

- (void)getOAuthAuthorizationWithInfo:(NSMutableDictionary*)info {
    NSString* verb = [NSString stringWithFormat:
                      @"%@ (%@)",
                      [NSString localizeFormat:
                       @"contacting%0",
                       self.client.displayName],
                      @"for authorization info"] ;
    SSYProgressView* progressView = [[[self bkmxDoc] progressView] setIndeterminate:YES
                                                                  withLocalizedVerb:verb
                                                                           priority:SSYProgressPriorityRegular] ;
    NSDictionary* authInfo = nil ;
    NSError* error = nil ;
    
    // Create a talker and set the necessary instance variables
    SSYOAuthTalker* talker = [self talker] ;
    
    // Get authInfo from server
    BOOL ok = [talker getAuthorizationInfoFromRequestUrl:[self.client.extoreClass constants_p]->oAuthRequestTokenUrl
                                     authorizationInfo_p:&authInfo
                                                 error_p:&error] ;
    [progressView clearAll] ;
    if (ok) {
        // Add authInfo to infos and run an alert
        [info setObject:[NSNumber numberWithBool:YES]
                 forKey:constKeyShouldAddToKeychain] ;
        
        SSYAlert* alert = [SSYAlert alert] ;
        NSString* msg = [self linkServiceMessage] ;
        [alert setSmallText:msg] ;
        [alert setButton2Title:[[BkmxBasis sharedBasis] labelCancel]] ;
        NSDictionary* infos = [[NSDictionary alloc] initWithObjectsAndKeys:
                               info, constKeyExtoreWebFlatInfo,
                               authInfo, constKeyExtoreWebFlatAuthInfo,
                               nil] ;
        // infos will be released in the callback
        [self.bkmxDoc runModalSheetAlert:alert
                              resizeable:NO
                               iconStyle:SSYAlertIconInformational
                           modalDelegate:self
                          didEndSelector:@selector(didEndOAuthInfoSheet:returnCode:infos:)
                             contextInfo:(void*)CFBridgingRetain(infos)] ;
    }
    else {
        [info setObject:[NSNumber numberWithBool:NO]
                 forKey:constKeySucceeded] ;
        [info setObject:error
                 forKey:constKeyError] ;
        [self endLoginTestInfo:info] ;
    }
    
}

- (void)sendIsDoneMessageFromInfo:(NSMutableDictionary*)info {
    [self.client.extoreClass sendIsDoneMessageFromInfo:info
                                            error:self.error];
}


#define ACCOUNT_NAME_FIELD_TAG 1
#define PASSWORD_FIELD_TAG 2
#define KEEP_IN_KEYCHAIN_FIELD_TAG 3

- (void)askUserAccountInfoForIxporter:(Ixporter*)ixporter
                                 info:(NSMutableDictionary*)info {
    if (!info) {
        info = [NSMutableDictionary dictionary] ;
    }
    
    [info setObject:ixporter
             forKey:constKeyIxporter] ;
    
    SSYAlert* alert ;
    NSString* key ;
    NSString* username ;
    SSYLabelledTextField* usernameField ;
    switch (self.authorizationMethod) {
        case BkmxAuthorizationMethodHttpAuth:;
        {
            alert = [SSYAlert alert] ;
            [alert setButton1Title:[NSString localize:@"logInCommand"]] ;
            [alert setButton2Title:[NSString localize:@"cancel"]] ;
            [alert setButton3Title:[NSString localize:@"new"]] ;
            NSString* displayName = self.client.displayName;
            [alert setTitleText:[NSString localizeFormat:@"loginRequired%0", displayName]] ;
            NSString* bookmarks = [NSString localize:@"000_Safari_Bookmarks"] ;
            [alert setSmallText:[NSString localizeFormat:@"loginRequiredToAccess%0%1",
                                 displayName,
                                 bookmarks]] ;
            
            // Add Account (Username) Field
            key = [NSString stringWithFormat:@"%@ (%@)",
                   [NSString localize:@"account"],
                   [self.client.extoreClass constants_p]->accountNameHint] ;
            username = self.client.profileName;
            usernameField = [SSYLabelledTextField labelledTextFieldSecure:NO
                                                       validationSelector:NULL
                                                         validationObject:nil
                                                         windowController:alert
                                                             displayedKey:key
                                                           displayedValue:username
                                                                 editable:YES
                                                                      tag:ACCOUNT_NAME_FIELD_TAG
                                                             errorMessage:nil] ;
            [alert addOtherSubview:usernameField atIndex:0] ;
            
            // Add Password Field
            key = [NSString localize:@"accountPassword"] ;
            SSYLabelledTextField* passwordField ;
            passwordField = [SSYLabelledTextField labelledTextFieldSecure:YES
                                                       validationSelector:NULL
                                                         validationObject:nil
                                                         windowController:alert
                                                             displayedKey:key
                                                           displayedValue:nil
                                                                 editable:YES
                                                                      tag:PASSWORD_FIELD_TAG
                                                             errorMessage:nil] ;
            [alert addOtherSubview:passwordField atIndex:1] ;
            
            [alert setCheckboxTitle:[NSString localize:@"keychainKeep"]] ;
            [alert setCheckboxState:NSControlStateValueOn] ;
            
            // Added in BookMacster 1.19.7, so that an import or export
            // operation does not start running away before profile is assigned
            [[self bkmxDoc] lockWaitingForClientProfile] ;
            
            [[self bkmxDoc] runModalSheetAlert:alert
                                    resizeable:NO
                                     iconStyle:SSYAlertIconInformational
                                 modalDelegate:self
                                didEndSelector:@selector(didEndAccountInfoSheet:returnCode:info:)
                                   contextInfo:(void*)CFBridgingRetain(info)] ;
            break ;
        }
        case BkmxAuthorizationMethodManual:
        {
            alert = [SSYAlert alert] ;
            [alert setButton1Title:[[BkmxBasis sharedBasis] labelOk]] ;
            [alert setButton2Title:[NSString localize:@"cancel"]] ;
            [alert setButton3Title:[NSString localize:@"new"]] ;
            [alert setSmallText:@"Enter how you personally identify this account, such as account name or email."] ;
            
            // Add Account (Username) Field
            key = [NSString stringWithFormat:@"%@ (%@)",
                   [NSString localize:@"account"],
                   [self.client.extoreClass constants_p]->accountNameHint] ;
            username = self.client.profileName;
            usernameField = [SSYLabelledTextField labelledTextFieldSecure:NO
                                                       validationSelector:NULL
                                                         validationObject:nil
                                                         windowController:alert
                                                             displayedKey:key
                                                           displayedValue:username
                                                                 editable:YES
                                                                      tag:ACCOUNT_NAME_FIELD_TAG
                                                             errorMessage:nil] ;
            [alert addOtherSubview:usernameField atIndex:0] ;
            
            // Added in BookMacster 1.19.7, so that an import or export
            // operation does not start running away before profile is assigned
            [[self bkmxDoc] lockWaitingForClientProfile] ;
            
            [[self bkmxDoc] runModalSheetAlert:alert
                                    resizeable:NO
                                     iconStyle:SSYAlertIconInformational
                                 modalDelegate:self
                                didEndSelector:@selector(didEndAccountInfoSheet:returnCode:info:)
                                   contextInfo:(void*)CFBridgingRetain(info)] ;
            break ;
        }
        case BkmxAuthorizationMethodOAuth:
        {
            [self getOAuthAuthorizationWithInfo:info] ;
            break ;
        }
        case BkmxAuthorizationMethodNone:
        {
            NSLog(@"Internal Error 592-9293") ;
            [self sendIsDoneMessageFromInfo:info] ;
            break ;
        }
    }
}

- (void)beginLoginTestInfo:(NSMutableDictionary*)info {
    [[[self bkmxDoc] progressView] setIndeterminate:YES
                                  withLocalizedVerb:[NSString localize:@"testing"]
                                           priority:SSYProgressPriorityRegular] ;
    
    [self testLoginWithInfo:info] ;
}

- (void)endLoginTestInfo:(NSMutableDictionary*)info {
    SSYProgressView* progressView = [[self bkmxDoc] progressView] ;
    [progressView clearAll] ;
    
    BOOL ok = [[info objectForKey:constKeySucceeded] boolValue] ;
    if (ok) {
        [[WebAuthorizor didSucceedEnteringAccountInfoInvocation] invoke];
    } else {
        NSError* error = [info objectForKey:constKeyError] ;
        [[self bkmxDoc] alertError:error] ;
        if (
            ([[error domain] isEqualToString:SSYSynchronousHttpErrorDomain])
            &&
            ([error code] == SSYSynchronousHttpStateCredentialNotAccepted)
            ) {
            // Username or password entered was no good.
            [[self client] setServerPassword:nil] ;
            [[self client] setProfileName:nil] ;
            [[self client] setProfileNameAlternate:nil] ;
        }
        else {
            // Some other error.
            // One possibility is that user cancelled
            //     (domain=BkmxExtoreWebFlatErrorDomain,
            //      code=constNonhierarchicalWebAppErrorCodeUserCancelled)
        }
        [[[self client] macster] deleteClient:[self client]] ;
        // The above line is weird.  Why not:
        // Client* client = self.ixporter.client;
        // [client.macster deleteClient:client];
    }
}

- (void)testLoginWithInfo:(NSMutableDictionary*)info {
    /* Note 20230502.  Obviously, contrary to its name, this method does not
     test anything!  Neither do the above methods beginLoginTestInfo: or
     -endLoginTestInfo:.  Possibly one of these methods did actually try to
     log in to the server and indicate if successful, but that must have been
     a really long time ago because I looked back in the commit history and
     these three methods have been essentially unchanged since the first
     commit 2013-05-09.  (Back then, and until refactoring last week, these
     three methods were members of ExtoreWebFlat.)
     
     The code now tells the user to "Please retry the operation you were
     attempting" after the user enters or re-enters credentials.  So in other
     words, the "test" is done manually by the user retrying an import or
     export.  Not a great user experience, but good enough for an edge case.*/
    
    // Add a key/value indicating success/not which will be needed
    // by -[OperationImport prepareBrowserForImportIsDoneInfo:]
    // or -[OperationExport prepareBrowserForExportIsDoneInfo:]
    [info setObject:[NSNumber numberWithBool:YES]
             forKey:constKeySucceeded] ;
    
    [self endLoginTestInfo:info] ;
}

- (NSString*)urlToCreateNewAccount {
    NSLog(@"Internal Error 654-0716") ;
    return nil ;
}

- (void)updateKeychainFromInfo:(NSMutableDictionary*)info {
    // Add to keychain if user desired
    if ([[info objectForKey:constKeyShouldAddToKeychain] boolValue]) {
        switch ([self authorizationMethod]) {
            case BkmxAuthorizationMethodHttpAuth:
            {
                NSError* error ;
                BOOL ok = [SSYKeychain setPassword:[[self client] serverPassword]
                                        forServost:[self.client.extoreClass webHostName]
                                           account:[[self client] profileName]
                                             clase:(NSString*)kSecClassInternetPassword
                                           error_p:&error] ;
                if (!ok) {
                    NSLog(@"Internal Error 283-8178 %@", error) ;
                }
                break ;
            }
            case BkmxAuthorizationMethodOAuth:;
            {
                [[self talker] setPasswordToKeychain] ;
                break ;
            }
            case BkmxAuthorizationMethodManual:
            {
            }
            case BkmxAuthorizationMethodNone:
            {
                break ;
            }
        }
    }
}

- (void)didAlertLoginSuccessSheet:(NSWindow*)sheet
                       returnCode:(NSInteger)returnCode
                             info:(NSMutableDictionary*)info  {
    // Housekeeping
    // We [self autorelease] here instead of [self release] because the
    // "main" retain on the extore was released in -[BkmxDoc finishGroupOfOperationsWithInfo]
    // when it invoked -releaseExtore.  So at this point we are the only retainer,
    // and having just entered a new run loop cycle here, it's time to make sure
    // that self sticks around for -updateKeychainFromInfo: and -sendIsDoneMessageFromInfo:
    [sheet orderOut:self] ;

    [self updateKeychainFromInfo:info] ;

    NSInvocation* didSucceedInvocation = [info objectForKey:constKeyDidSucceedInvocation] ;
    
    if (didSucceedInvocation) {
        // There was some code in here prior to BookMacster 1.1 which generated infoArg.
        // Later, somewhere in BookMacster 1.1-1.1.5, infoArg was changed to restoredDictionary
        // and was generated by even more code to check validity of assumptions.
        // But then in BookMacster 1.1.6 I realized that infoArg/restoredDictionary was
        // not used for anything in BookMacster 1.0.5, not used for anything currently,
        // and was probably not used for a long time.  So all that code is now gone.
        [didSucceedInvocation invoke] ;
    }
    else {
        // User has just selected a nonhierarchical web app in the
        // Client popup menu, and we are just testing the login
        // credentials
        [self sendIsDoneMessageFromInfo:info] ;
    }
}

- (NSMutableDictionary*)addUserCancellationToInfo:(NSDictionary*)info {
    NSError* error = [NSError errorWithDomain:BkmxExtoreWebFlatErrorDomain
                                         code:constNonhierarchicalWebAppErrorCodeUserCancelled
                                     userInfo:nil] ;
    Ixporter* ixporter = [info objectForKey:constKeyIxporter] ;
    
    NSMutableDictionary* newInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:NO], constKeySucceeded,
                                    ixporter, constKeyIxporter,
                                    error, constKeyError,
                                    nil] ;
    return newInfo ;
}

- (void)didEndAccountInfoSheet:(NSWindow*)sheet
                    returnCode:(NSInteger)returnCode
                          info:(NSMutableDictionary*)info {
    [sheet orderOut:self] ;
    
    switch (returnCode) {
        case NSAlertFirstButtonReturn:;
            // "Log In" or "OK"
            BkmxAuthorizationMethod method = [self authorizationMethod] ;
            switch (method) {
                case BkmxAuthorizationMethodHttpAuth:
                case BkmxAuthorizationMethodManual:
                    // Extract user input and set in Client
                    for (NSView* view in [[sheet contentView] subviews]) {
                        if ([view isKindOfClass:[SSYLabelledTextField class]]) {
                            SSYLabelledTextField* textField = (SSYLabelledTextField*)view ;
                            switch ([textField tag]) {
                                case ACCOUNT_NAME_FIELD_TAG:
                                    [[self client] setProfileName:[textField stringValue]] ;
                                    break ;
                                case PASSWORD_FIELD_TAG:
                                    // Remember it in the client, because we are only transient, and
                                    // in case the user chooses to not store it in Keychain, we at
                                    // least want it to be persistent as long during this app launch
                                    [[self client] setServerPassword:[textField stringValue]] ;
                                    break ;
                                default:
                                    break ;
                            }
                        }
                        else if ([view isKindOfClass:[SSYWrappingCheckbox class]]) {
                            SSYWrappingCheckbox* keepInKeychainCheckbox = (SSYWrappingCheckbox*)view ;
                            [info setObject:[NSNumber numberWithBool:([keepInKeychainCheckbox state] == NSControlStateValueOn)]
                                     forKey:constKeyShouldAddToKeychain] ;
                        }
                    }
                
                    if (method == BkmxAuthorizationMethodHttpAuth) {
                        [self beginLoginTestInfo:info] ;
                    }
                    else {
                        [self sendIsDoneMessageFromInfo:info] ;
                    }

                    break ;
                case BkmxAuthorizationMethodOAuth:
                    [self getOAuthAuthorizationWithInfo:info] ;
                    break ;
                case BkmxAuthorizationMethodNone:
                    NSLog(@"Internal Error 192-2443") ;
                    [self sendIsDoneMessageFromInfo:info] ;
                    break ;
            }
            // Internal Error 192-2444 was here until BookMacster 1.21
            
            break ;
            
        case NSAlertThirdButtonReturn:
            // User wants a "New" Account
            [SSWebBrowsing browseToURLString:[self urlToCreateNewAccount]
                     browserBundleIdentifier:nil
                                    activate:YES] ;
            // no break, because in this case, it's cancelled as far as we're concerened…
        case NSAlertSecondButtonReturn:;
            // User said to "Cancel"
            NSMutableDictionary* newInfo = [self addUserCancellationToInfo:info] ;
            [self endLoginTestInfo:newInfo] ;
            NSError* error = [newInfo objectForKey:constKeyError] ;
            if (error) {
                [self setError:error] ;
            }
            
            [[self client] abandon] ;
    }
    
    // Added in BookMacster 1.19.7, to unlock the lock which was set in
    // -askUserAccountInfoForIxporter:info:
    [[self bkmxDoc] unlockWaitingForClientProfile] ;
    CFBridgingRelease((__bridge CFTypeRef _Nullable)(info));
}

- (void)didEndOAuthInfoSheet:(NSWindow*)sheet
                  returnCode:(NSInteger)returnCode
                       infos:(NSDictionary*)infos {
    [sheet orderOut:self] ;
    
    NSMutableDictionary* info = [infos objectForKey:constKeyExtoreWebFlatInfo];
    NSDictionary* authInfo = [infos objectForKey:constKeyExtoreWebFlatAuthInfo];
    // Release context info which was retained earlier

    if (returnCode == NSAlertFirstButtonReturn) {
        NSString* requestAuthorizationUrl = [authInfo objectForKey:constKeyOAuthRequestUrl] ;
        
        // Set authInfo we received into our talker.
        SSYOAuthTalker* talker = [self talker] ;
        [talker setOAuthToken:[authInfo objectForKey:constKeyOAuthToken]] ;
        [talker setOAuthTokenSecret:[authInfo objectForKey:constKeyOAuthTokenSecret]] ;
        
        // Tell our talker what to do *after* it receives the verifier
        // info should never be nil, but if they were
        // we'd probably have a nasty crash.  Thus, the following
        // line of defensive programming:
        void* addressOfInfo = info ? &info : NULL ;
        NSInvocation* invocation = [NSInvocation invocationWithTarget:self
                                                             selector:@selector(beginLoginTestInfo:)
                                                      retainArguments:YES
                                                    argumentAddresses:addressOfInfo] ;
        [talker setGotAccessInvocation:invocation] ;
        
        // Activate web browser
        [SSWebBrowsing browseToURLString:requestAuthorizationUrl
                 browserBundleIdentifier:nil
                                activate:YES] ;
        
        SSYAlert* alert = [SSYAlert alert] ;
        [alert setButton1Title:[NSString localize:@"done"]] ;
        [alert setButton2Title:[NSString localize:@"cancel"]] ;
        NSString* key = [NSString localizeFormat:@"oAuthLinkBkmxDeliX2",
                         [NSString localizeFormat:@"code"],
                         @"Yahoo!"] ;
        SSYLabelledTextField* verifierField = [SSYLabelledTextField labelledTextFieldSecure:NO
                                                                         validationSelector:NULL
                                                                           validationObject:nil
                                                                           windowController:alert
                                                                               displayedKey:key
                                                                             displayedValue:nil
                                                                                   editable:YES
                                                                                        tag:0  // not used
                                                                               errorMessage:nil] ;
        [alert addOtherSubview:verifierField atIndex:0] ;
        
        [[self bkmxDoc] runModalSheetAlert:alert
                                resizeable:NO
                                iconStyle:SSYAlertIconInformational
                            modalDelegate:self
                           didEndSelector:@selector(didEndEnterVerifierSheet:returnCode:info:)
                               contextInfo:(void*)CFBridgingRetain(info)];
    }
    else {
        // "Cancel"
        NSMutableDictionary* newInfo = [self addUserCancellationToInfo:info] ;
        [self endLoginTestInfo:newInfo] ;
    }

    CFBridgingRelease((__bridge CFTypeRef _Nullable)(infos));
}

- (void)didEndEnterVerifierSheet:(NSWindow*)sheet
                      returnCode:(NSInteger)returnCode
                            info:(NSMutableDictionary*)info {
    [sheet orderOut:self] ;
    
    SSYAlert* alert = [sheet windowController] ;
    switch (returnCode) {
        case NSAlertFirstButtonReturn:;
        {
            // "Done"
            SSYLabelledTextField*    labelledTextField = [[alert otherSubviews] objectAtIndex:0] ;
            if (labelledTextField) {
                // Create a trimSet for trimming whitespace or quotes inadvertantly copied by user
                NSMutableCharacterSet* trimSet = [[NSMutableCharacterSet alloc] init] ;
                [trimSet formUnionWithCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] ;
                [trimSet addCharactersInString:@"\""] ;
                
                // Trim and process the user's input
                NSString* verifier = [[labelledTextField stringValue] stringByTrimmingCharactersInSet:trimSet] ;
                [[self talker] processOAuthVerifier:verifier] ;
            }
            break ;
        }
        default:
        {
            // "Cancel"
            NSMutableDictionary* newInfo = [self addUserCancellationToInfo:info] ;
            [self endLoginTestInfo:newInfo] ;
        }
    }
    
    CFBridgingRelease((__bridge CFTypeRef _Nullable)(info));
}

+ (NSSet*)ssySyncCredentialErrorCodesSet {
    return [NSSet setWithObjects:
            [NSNumber numberWithInteger:SSYSynchronousHttpStateCredentialNotAccepted],
            [NSNumber numberWithInteger:SSYSynchronousHttpStateNeedUsernamePasswordToMakeCredential],
            [NSNumber numberWithInteger:401],
            nil] ;
}

+ (NSInvocation*)didSucceedEnteringAccountInfoInvocation {
    // Transfer error's didRecoverInvocation back to info's didSucceedInvocation.
    // (Previous transfer from info to error was in -[BkmxDoc finishGroupOfOperationsWithInfo:]
    // This is used in case bad credentials are discovered during Import or Export.
    NSArray* buttonsArray = nil;
    NSString* title = nil;
    NSString* message = NSLocalizedString(@"Please retry the operation you were attempting.", nil);
    NSInvocation* invocation = [NSInvocation invocationWithTarget:[SSYAlert class]
                                                         selector:@selector(runModalDialogTitle:message:buttonsArray:)
                                                  retainArguments:YES
                                                argumentAddresses:&title, &message, &buttonsArray];
    NSAssert(invocation != nil, @"Unexpected nil in %s", __PRETTY_FUNCTION__);
    return invocation;
}

@end
