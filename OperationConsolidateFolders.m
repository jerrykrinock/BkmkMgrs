#import "OperationConsolidateFolders.h"
#import "Stark.h"
#import "BkmxArrayCategories.h"
#import "BkmxDoc.h"
#import "SSYProgressView.h"
#import "Starker.h"
#import "BkmxBasis+Strings.h"
#import "NSArray+Stringing.h"
#import "NSString+LocalizeSSY.h"
#import "SSYSheetEnder.h"
#import "NSInvocation+Quick.h"
#import "NS(Attributed)String+Geometrics.h"


@implementation SSYOperation (OperationConsolidateFolders)

- (BOOL)anythingWasDone {
	return (
			[[[self info] objectForKey:constKeyMergedFolderLineages] count]
			+
			[[[self info] objectForKey:constKeyDeletedFolderLineages] count]
			> 0
			) ;
}

- (void)consolidateFolders {
	[self doSafely:_cmd] ;
}

- (void)consolidateFolders_unsafe {
    BkmxDoc* bkmxDoc = [self.info objectForKey:constKeyDocument];

	[[BkmxBasis sharedBasis] logFormat:@"Consolidating Folders"] ;
	[[bkmxDoc progressView] setIndeterminate:YES
                         withLocalizableVerb:@"merging"
                                    priority:SSYProgressPriorityRegular] ;
	// Note: In BkmxAgent, progressView will be nil
	
	[[[bkmxDoc starker] root] recursivelyPerformSelector:@selector(mergeFoldersWithInfo:)
											 withObject:[self info]] ;
	
	if ([self anythingWasDone]) {
        [bkmxDoc postTouchedStark:[[bkmxDoc starker] root]] ;
		[bkmxDoc postSortMaybeNot] ;
	}
}

- (void)displayConsolidatedFolders {
	[self doSafely:_cmd] ;
}

- (void)displayConsolidatedFolders_unsafe {
	if ([[BkmxBasis sharedBasis] isBkmxAgent]) {
		return ;
	}
	
    NSString* sayMergedFolders = [NSString localizeFormat:
                                  @"mergedX",
                                  [NSString localize:@"folders"]] ;
    NSString* sayDeletedFolders = [NSString localizeFormat:
                                   @"deleted%0",
                                   [NSString localize:@"folders"]] ;
    NSString* mergedFoldersList = [[[self info] objectForKey:constKeyMergedFolderLineages] listValuesOnePerLineForKeyPath:nil
                                                                                                                   bullet:@"    \xe2\x80\xa2  "] ;
    NSString* deletedFoldersList = [[[self info] objectForKey:constKeyDeletedFolderLineages] listValuesOnePerLineForKeyPath:nil
                                                                                                                     bullet:@"    \xe2\x80\xa2  "] ;
	NSInteger nMerged = [[[self info] objectForKey:constKeyMergedFolderLineages] count] ;
    NSInteger nDeleted = [[[self info] objectForKey:constKeyDeletedFolderLineages] count] ;
    NSString* summary = [NSString stringWithFormat:
                         @"%ld %@ %@ %ld %@",
                         (long)nMerged,
                         sayMergedFolders,
                         [NSString localize:@"andEndList" ],
                         (long)nDeleted,
                         sayDeletedFolders] ;
    NSString* msg = [NSString stringWithFormat:
					 @"\n  %@%@\n\n  %ld %@:\n%@\n\n  %ld %@:\n%@\n",
                     summary,
                     constEllipsis,
					 (long)nMerged,
					 [sayMergedFolders uppercaseString],
					 mergedFoldersList,
					 (long)nDeleted,
					 [sayDeletedFolders uppercaseString],
					 deletedFoldersList] ;
    NSRect frame = NSZeroRect ;  // will be set later
    NSTextView* textView = [[NSTextView alloc] initWithFrame:frame] ;
    [textView setEditable:NO] ;
    [textView setString:msg] ;
    
    NSAttributedString* attributedString = [textView attributedString] ;
    CGFloat textRequiredWidth = [attributedString widthForHeight:CGFLOAT_MAX] ;
    CGFloat textRequiredHeight = [attributedString heightForWidth:CGFLOAT_MAX] ;
    
    // Enclose the text view into a scroll view
    CGFloat maxHeightForCosmetics = 600.0 ;
    frame.size.height = MIN(textRequiredHeight, maxHeightForCosmetics) ;
    NSScrollView* scrollView = [[NSScrollView alloc] initWithFrame:frame] ;
    [scrollView setDocumentView:textView] ;
    [textView release] ;
    [scrollView setHasVerticalScroller:YES] ;
    [scrollView setHasHorizontalScroller:YES] ;

 	SSYAlert* alert = [SSYAlert alert] ;
    [alert addOtherSubview:scrollView
                   atIndex:0] ;
    [scrollView release] ;
    
    // Require the text view to be at least as big as its enclosing scroll view.
    // The scroll view will be resized when the SSYAlert is laid out prior to
    // display.  So, we first need to do a pre-layout, in order to find out
    // how wide the scroll view is going to be.
    CGFloat minWidthForCosmetics = 350.0 ;
    CGFloat maxWidthForCosmetics = 600.0 ;
    [alert setRightColumnMinimumWidth:MIN(MAX(textRequiredWidth, minWidthForCosmetics), maxWidthForCosmetics)] ;
    [alert doooLayout] ;
    scrollView.autoresizingMask |= (NSViewWidthSizable + NSViewHeightSizable);
    // This is probably not necessary:
    scrollView.superview.autoresizingMask |= (NSViewWidthSizable + NSViewHeightSizable);
    CGFloat laidOutScrollViewWidth = [scrollView frame].size.width ;
    CGFloat laidOutScrollViewHeight = [scrollView frame].size.height ;
    CGFloat margin = 10.0 ;  // Added when I found that some lines still wrap.
    CGFloat textViewWidth = MAX(textRequiredWidth + margin, laidOutScrollViewWidth) ;
    CGFloat textViewHeight = MAX(textRequiredHeight, laidOutScrollViewHeight) ;
    NSRect textFrame = [textView frame] ;
    textFrame.size.width = textViewWidth ;
    textFrame.size.height = textViewHeight ;
    [textView setFrame:textFrame] ;

	NSArray* invocations = nil ;
	BkmxDoc* bkmxDoc = [[self info] objectForKey:constKeyDocument] ;
	
	if ([self anythingWasDone]) {
		[alert setButton2Title:[NSString localize:@"undo"]] ;
		NSInvocation* doUndo = [NSInvocation invocationWithTarget:[bkmxDoc undoManager]
														 selector:@selector(undo)
												  retainArguments:NO
												argumentAddresses:NULL] ;
		invocations = [[NSArray arrayWithObjects:
						[NSNull null],
						doUndo,
						nil] retain] ;
	}
    [[[self info] objectForKey:constKeyDocument] runModalSheetAlert:alert
                                                         resizeable:YES
                                                          iconStyle:SSYAlertIconInformational
                                                      modalDelegate:[SSYSheetEnder class]
                                                     didEndSelector:@selector(didEndGenericSheet:returnCode:retainedInvocations:)
                                                        contextInfo:invocations] ;
}

// Cannot run in arbitrary thread since NSUndoManager is not thread safe.
- (void)showCompletionConsolidateFolders {
	[self doSafely:_cmd] ;
}

- (void)showCompletionConsolidateFolders_unsafe {
    BkmxDoc* bkmxDoc = [self.info objectForKey:constKeyDocument];
	SSYProgressView* progressView = [bkmxDoc progressView] ;
	if (progressView) {
		// Must be in MainApp
		if ([self anythingWasDone]) {
			NSString* verb = [NSString stringWithFormat:
							  @"%@ (%ld) %@ (%ld)",
							  [[BkmxBasis sharedBasis] labelMergeFolders],
							  (long)[[[self info] objectForKey:constKeyMergedFolderLineages] count],
							  [[BkmxBasis sharedBasis] labelDeleteFolders],
							  (long)[[[self info] objectForKey:constKeyDeletedFolderLineages] count]
							  ] ;
			[progressView showCompletionVerb:verb
                                      result:nil
                                    priority:SSYProgressPriorityRegular] ;
		}
		else {
			[progressView clearAll] ;
		}
	}
}	


@end
