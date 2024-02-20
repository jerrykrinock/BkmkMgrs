#import "Bkmxwork/Bkmxwork-Swift.h"
#import "TagsPopoverViewController.h"
#import "ContentOutlineView.h"
#import "BkmxDocWinCon.h"
#import "BkmxBasis+Strings.h"
#import "Starki.h"
#import "BkmxGlobals.h"
#import "NSString+LocalizeSSY.h"
#import "NSString+SSYExtraUtils.h"
#import "CntntViewController.h"
#import "BkmxDoc+GuiStuff.h"
#import "BkmxAppDel.h"

@interface TagsPopoverViewController ()

@end

@implementation TagsPopoverViewController

+ (void)initialize {
    [self exposeBinding:@"selectedStarkiTags"] ;
    [self exposeBinding:@"labelString"] ;
}

- (void)viewDidLoad {
    /* Binding to NSTokenField is done by trial and error, often silent.
     The "no longer being updated" Token Field Programming Guide" states [1]:
     
     "To retrieve the objects represented by the tokens in a token field, send
     the token field an objectValue message. Although this method is declared
     by NSControl, NSTokenField implements it to return an array of
     represented objects. If the token field simply contains a series of
     strings, objectValue returns an array of strings. To set the represented
     objects of a token field, use the setObjectValue: method, passing in an
     array of represented objects."
     
     Before reading that, I tried to bind to "representedObject".  There *is*
     such a binding, because if you try and bind to it programatically, you
     get no runtime error, and you do get a runtime error if you try and bind
     to, for example "representedObjectx".  But binding to "representedObject"
     has no effect.  It just silently fails.
     
     But there is no `objectValue` binding either.  From the Cocoa Bindings
     Reference [2], the correct binding seems to be:
     
     value: "An array of NSString or NSNumber objects that are displayed as the content of the NSTokenField."
     
     So when binding the token field, we use "value", but when binding to
     the token field, we use "objectValue".
     
     But there is more in that little sentence.  Experiments show that, indeed,
     the "value" must be bound to an *array*, NSArray.  However, it does not
     need to be an array of NSString and NSNumber objects.  From other
     sources, I lean that you can put other objects in there, and also
     you can (which I do) implement the delegate methods
     tokenField:displayStringForRepresentedObject: and
     tokenField:representedObjectForEditingString
     to tell it how to display the arbitrary represented object, and to create
     new represented objeccts from strings typed in by the user.
     
     [1] https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/TokenField_Guide/GetSetTokenFields/GetSetTokenFields.html#//apple_ref/doc/uid/TP40006555-CH9-SW2
     [2] https://developer.apple.com/library/archive/documentation/Cocoa/Reference/CocoaBindingsRef/BindingsText/NSTokenField.html
     */
    
    [super viewDidLoad] ;
    [tokenField bind:@"value"
            toObject:self
         withKeyPath:@"selectedStarkiTags"
             options:[[BkmxBasis sharedBasis] bindingOptionsForTags]] ;
    [self bind:@"selectedStarkiTags"
      toObject:tokenField
   withKeyPath:@"objectValue"
       options:0] ;
    // In the above two, note that, in SSYTokenField, and NSTokenField,
    // the property is 'objectValue' and its equivalent binding is 'value'.
    // Hence the illusion of assymmetry in this symmetric two-way binding.
    
    Bookshig* shig = [(BkmxDoc*)[contentViewController document] shig] ;
    if (shig) {
        [tokenField bind:@"tokenizingCharacter"
                toObject:shig
             withKeyPath:constKeyTagDelimiterActual
                 options:0] ;
    }
    else {
        NSLog(@"Internal Error 624-2828 for %@", [contentViewController document]) ;
    }
    
}

- (void)tearDown {
    [self unbind:@"selectedStarkiTags"] ;
    [tokenField unbind:@"tokenizingCharacter"] ;
    [tokenField unbind:@"value"] ;
}

- (NSArray*)selectedStarkiTags {
    Starki* starki = [contentOutlineView selectedStarki] ;
    NSArray* answer = [starki valueForKey:constKeyTags] ;
    return answer ;
}

// This method is invoked by Cocoa Bindings when user enters
// tags into the token field in the tags popover.
- (void)setSelectedStarkiTags:(NSArray*)tags {
    Starki* starki = [contentOutlineView selectedStarki] ;
    if ([tags respondsToSelector:@selector(objectAtIndex:)]) {
        [starki setValue:tags
                  forKey:constKeyTags];
        }
}

+ (NSSet*)keyPathsForValuesAffectingSelectedStarkiTags {
    NSSet* set = [NSSet setWithObjects:
                  // The selection could change
                  @"contentOutlineView.selectedStarki",
                  // Attributes of selected item(s) could change.  The following
                  // is overly broad, will fire on *any* change of *any* item.
                  [@"contentOutlineView.delegate.windowController.document." stringByAppendingString:constKeyLastContentTouchDate],
                  nil] ;
    return set ;
}

- (NSString*)labelString {
    NSArray* starks = [[contentOutlineView selectedStarki] starks] ;
    NSInteger count = [starks count] ;
    NSString* answer = nil ;
    // Initialization to nil is not necessary, but clang in Xcode 6.1 is not
    // smart enough to see that object and answer cannot both be nil.
    id object = nil ;
    if (count == 0) {
        answer = @"Select an item, then click this button to edit its tags" ;
    }
    else if (count == 1) {
        object = [[(Stark*)[starks firstObject] name] doublequote];
    }
    else {
        object = [NSString stringWithFormat:
                  @"%ld items",
                  (long)count] ;
    }
    
    if (object) {
        answer = [NSString stringWithFormat:
                  @"Edit tags for %@",
                  object] ;
    }
    
    return answer ;
}

+ (NSSet*)keyPathsForValuesAffectingShowTagsButtonToolTip {
    return [NSSet setWithObject:@"contentOutlineView.selectedStarki"] ;
}

+ (NSSet*)keyPathsForValuesAffectingLabelString {
    return [NSSet setWithObject:@"contentOutlineView.selectedStarki"] ;
}

- (IBAction)dismiss:(id)sender {
    [popover performClose:sender] ;
}

#pragma mark * NSControlTextEditingDelegate Delegate Methods

- (NSArray*)   tokenField:(SSYTokenField*)aTokenField
  completionsForSubstring:(NSString*)substring
             indexOfToken:(NSInteger)tokenIndex
      indexOfSelectedItem:(NSInteger*)index_p {
    NSArray* answer = nil ;
    if (aTokenField == tokenField) {
        answer = [(BkmxAppDel*)[NSApp delegate] tagCompletionsForTagPrefix:substring
                                                             selectIndex_p:index_p] ;
    }
    
    return answer ;
}

#pragma mark * NSTokenFieldDelegate Methods

- (NSString*)            tokenField:(NSTokenField *)tokenField
  displayStringForRepresentedObject:(id)representedObject {
    return [representedObject string];
}

- (id)                  tokenField:(NSTokenField*)tokenField
 representedObjectForEditingString:(NSString*)editingString {
    Tagger* tagger = [[[[[tokenField window] parentWindow] windowController] document] tagger];
    Tag* newTag = [tagger addTagString:editingString
                                    to:[[contentOutlineView selectedStarki] stark]];
    return newTag;
}

@end
