#import "SpecifyCruftController.h"
#import "NSString+SSYHttpQueryCruft.h"
#import "BkmxGlobals.h"
#import "SSYAlert.h"
#import "BkmxBasis.h"
#import "BkmxAppDel.h"
#import "SSYMH.AppAnchors.h"

@interface SpecifyCruftController ()

@end

@implementation SpecifyCruftController

- (NSString *)windowNibName {
    return  @"SpecifyCruft" ;
}

- (void)windowDidLoad {
    [super windowDidLoad];

    /* See Note: Why Not Cocoa Bindings? at end of file */
    /* In order to avoid exceptions when user inserts, adds, or updates items
     in the table (not always, but sometimes) I found that the array controller
     'content' must be set to a deeply mutable value.  For a lot more reading
     on this subject, in cocoa-dev@lists.apple.com, dated 2004 Oct 21-23, there
     is a thread with subject "Bug in NSArrayController? (immutable instead of
     mutable dictionaries)".  Anyhow, we now make a deeply mutable copy: */
    NSMutableArray* cruftSpecs = [NSMutableArray new] ;
    for (NSDictionary* dictionary in [[NSUserDefaults standardUserDefaults] objectForKey:@"queryCruftSpecs"]) {
        NSMutableDictionary* mutableDic = [dictionary mutableCopy] ;
        [cruftSpecs addObject:mutableDic] ;
        [mutableDic release] ;
    }
    self.cruftSpecArrayController.content = cruftSpecs  ;
    [cruftSpecs release] ;

    NSArray* sortDescriptors = @[
                                 [[[NSSortDescriptor alloc] initWithKey:@"deskription" ascending:YES] autorelease],
                                 [[[NSSortDescriptor alloc] initWithKey:@"domain" ascending:YES] autorelease]
    ] ;
    self.cruftSpecArrayController.sortDescriptors = sortDescriptors ;
}

- (IBAction)addDefaultItems:(id)sender {
    NSMutableArray* missingDefaultItems = [NSMutableArray new] ;
    for (NSDictionary* cruftSpec in [[NSUserDefaults standardUserDefaults] objectForKey:constKeyDefaultCruftSpecs]) {
        if ([self.cruftSpecArrayController.content indexOfObject:cruftSpec] == NSNotFound) {
            [missingDefaultItems addObject: cruftSpec] ;
        }
    }
    
    if ([missingDefaultItems count] > 0) {
        for (NSDictionary* cruftSpec in missingDefaultItems) {
            [self.cruftSpecArrayController insertObject:cruftSpec
                                  atArrangedObjectIndex:0] ;
        }
        [self.cruftSpecArrayController rearrangeObjects] ;
    }
    else {
        SSYAlert* alert = [SSYAlert new] ;
        NSString* format = NSLocalizedString(@"The %ld Default Items provided by %@ are already present in this list.", nil) ;
        NSString* msg = [[NSString alloc] initWithFormat:
                         format,
                         ((NSArray*)[[NSUserDefaults standardUserDefaults] objectForKey:constKeyDefaultCruftSpecs]).count,
                         [[BkmxBasis sharedBasis] appNameLocalized]] ;
        [alert setSmallText:msg] ;
        [msg release] ;
        [alert setIconStyle:SSYAlertIconInformational] ;
        [alert setButton1Title:NSLocalizedString(@"OK", nil)] ;
        [alert doooLayout] ;
        [self.window beginSheet:[alert window]
              completionHandler:^void(NSModalResponse modalResponse) {
                  [alert release] ;
              }] ;
    }
    
    [missingDefaultItems release] ;
}

- (IBAction)help:(id)sender {
    [(BkmxAppDel*)[NSApp delegate] openHelpAnchor:constHelpAnchorCruft] ;
}

- (void)endWithReturnCode:(NSInteger)returnCode {
    [[[self window] sheetParent] endSheet:[self window]
                               returnCode:returnCode] ;
    
    // Window is set to "Release when closed" in xib
    // The windowController (self) is released in the completion handler
    // inside -[BkmxDoc(Actions) removeCruft:].
}

- (IBAction)cancel:(id)sender {
    [self endWithReturnCode:NSAlertSecondButtonReturn] ;
}

- (void)endEditing {
    /*
     The following code, though rather strange, is copied out of the
     documentation of -[NSWindow endEditingFor]
     */
    if ([[self window] makeFirstResponder:[self window]]) {
        // Apparently, we're done because it worked.
    }
    else {
        // Last resort
        [[self window] endEditingFor:nil];
    }
}

- (IBAction)search:(id)sender {
    /* See Note: Why Not Cocoa Bindings? at end of file */
    
    /* Necessary in case a text field in table is still being edited: */
    [self endEditing] ;
    
    NSArray* cruftSpecs = self.cruftSpecArrayController.content ;
    [[NSUserDefaults standardUserDefaults] setObject:cruftSpecs
                                              forKey:@"queryCruftSpecs"]  ;

    [self endWithReturnCode:NSAlertFirstButtonReturn] ;
}

@end

/* Note: Why Not Cocoa Bindings?

 I tried binding the  Content Array of the array controller to the 'values'
 of the shared user defaults controller with key path queryCruftSpecs.  The
 table is populated as expected from user defaults when its window opens, and
 all works and persists as expected if user does one of
 
 • Add an object (table row) with all nil attributes
 • Delete an object
 • Add an object, sets attributes and then adds another row with all nil
 attributes
 
 But if instead user edits the attributes of a row without later adding a
 row, although the object attribute in the array controller's content
 changes as expected, attribute edits will not persist.  I think the reason
 for this is that, as always, Key Value Observing does not go "deep".

 Therefore, we give Cocoa Bindings some "help", setting user defaults the
 old-fashioned way, when user clicks the "Search" button.
 */
