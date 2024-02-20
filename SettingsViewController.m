#import "SettingsViewController.h"
#import "BkmxDoc+GuiStuff.h"
#import "BkmxAppDel.h"
#import "BkmxDocWinCon+Autosaving.h"
#import "Macster.h"
#import "SSYSizability.h"
#import "ClientListView.h"
#import "BkmxBasis+Strings.h"
#import "SSYTabView.h"
#import "SSYSheetEnder.h"
#import "NSInvocation+Quick.h"
#import "Bookshig.h"
#import "SSYDynamicMenu.h"
#import "SSYVectorImages.h"
#import "NSObject+SuperUtils.h"
#import "NSImage+Transform.h"
#import "StarkContainersFlatMenu.h"
#import "SSYIndexee.h"
#import "NSString+LocalizeSSY.h"
#import "NSDocumentController+DisambiguateForUTI.h"
#import "SSYMH.AppAnchors.h"
#import "NSArray+SafeGetters.h"
#import "Syncer.h"
#import "AgentPerformer.h"
#import "Trigger.h"
#import "Client.h"
#import "ImportPostprocController.h"
#import "ClientInfoController.h"
#import "SSYHintArrow.h"
#import "NSDocument+SSYAutosaveBetter.h"
#import "SyncStatusTextField.h"
#import "SafeLimitGuider.h"
#import "NSUserDefaults+Bkmx.h"
#import "Job.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

#pragma mark Accessor Methods

- (SSYTabView*)settingsTabView {
    return settingsTabView ;
}

#pragma mark Other Methods

- (BOOL)shouldAutosaveStateOfTabView:(NSTabView*)tabView {
    return (tabView != syncingTabView) ;
}

#define TOTAL_SIDE_MARGINS 40.0

- (CGFloat)minimumWidth {
    return [switchSettingsTab frame].size.width + TOTAL_SIDE_MARGINS ;
}

#define CLIENT_TAB_VIEW_HEIGHT_NOT_INCLUDING_CLIENT_LIST 202.0

- (CGFloat)clientTabMinimumHeight {
	return (CLIENT_TAB_VIEW_HEIGHT_NOT_INCLUDING_CLIENT_LIST + [clientListView currentHeight]) ;
}

- (SSYSizability)sizabilityForTabViewItem:(NSTabViewItem*)tabViewItem {
    SSYSizability sizability ;
    
	if (tabViewItem == tabGeneral) {
		sizability = SSYSizabilityUserSizable ;
	}
	else if (tabViewItem == tabOpenSave) {
		sizability = SSYSizabilityFixed ;
	}
	else if (tabViewItem == tabSorting) {
		sizability = SSYSizabilityFixed ;
	}
	else if (tabViewItem == tabStructure) {
		sizability = SSYSizabilityFixed ;
	}
	else if (tabViewItem == tabClients) {
		sizability = SSYSizabilityCalculated ;
	}
	else if (tabViewItem == tabSimple) {
		sizability = SSYSizabilityFixed ;
	}
	else if (tabViewItem == tabAdvanced) {
		sizability = SSYSizabilityUserSizable ;
	}
    else {
        sizability = SSYSizabilityUnknown ;
    }
    
    return sizability ;
}

- (NSString*)labelForSettingsTabIndex:(NSInteger)index {
	SEL selector ;
    BkmxWhich1App iAm = [[BkmxBasis sharedBasis] iAm] ;
	switch (iAm) {
        case BkmxWhich1AppSmarky:
            switch (index) {
                case 0:
                    selector = @selector(labelGeneral) ;
                    break ;
                case 1:
                    selector = @selector(labelSorting) ;
                    break ;
                default:
                    selector = @selector(labelUnknown) ;
                    break ;
            }
            break ;
        case BkmxWhich1AppSynkmark:
            switch (index) {
                case 0:
                    selector = @selector(labelGeneral) ;
                    break ;
                case 1:
                    selector = @selector(labelSorting) ;
                    break ;
                case 2:
                    selector = @selector(labelClients) ;
                    break ;
                default:
                    selector = @selector(labelUnknown) ;
                    break ;
            }
            break ;
        case BkmxWhich1AppMarkster:
            switch (index) {
                case 0:
                    selector = @selector(labelGeneral) ;
                    break ;
                case 1:
                    selector = @selector(labelSorting) ;
                    break ;
                default:
                    selector = @selector(labelUnknown) ;
                    break ;
            }
            break ;
        case BkmxWhich1AppBookMacster:
            switch (index) {
                case 0:
                    selector = @selector(labelGeneral) ;
                    break ;
                case 1:
                    selector = @selector(labelSorting) ;
                    break ;
                case 2:
                    selector = @selector(labelStructure) ;
                    break ;
                case 3:
                    selector = @selector(labelOpenSave) ;
                    break ;
                case 4:
                    selector = @selector(labelClients) ;
                    break ;
                case 5:
                    selector = @selector(labelSyncing) ;
                    break ;
                default:
                    selector = @selector(labelUnknown) ;
                    break ;
            }
            break ;
	}
	
	return [[BkmxBasis sharedBasis] performSelector:selector] ;
}

- (NSString*)nameOfTabDisallowedInViewingModeForTabViewItem:(NSTabViewItem*)tabViewItem {
    NSString* tabName = nil ;
    if (
        (tabViewItem == tabOpenSave)
        ||
        (tabViewItem == tabClients)
        ||
        (tabViewItem == tabSyncing)
        ) {
        NSInteger selectedIndex = [settingsTabView indexOfTabViewItem:tabViewItem] ;
        tabName = [self labelForSettingsTabIndex:selectedIndex] ;
    }
    
    return tabName ;
}

- (void)changeToSubtabAllowedInViewingMode {
    NSInteger selectedIndex = [settingsTabView selectedTabIndex] ;
    // Disallow Open/Save (index 3), Clients (index 4), Syncing (index 5)
    NSIndexSet* disallowedIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(3,3)] ;
    if ([disallowedIndexes containsIndex:selectedIndex]) {
        [settingsTabView selectTabViewItem:tabGeneral] ;
    }
}

- (BOOL)        rawTabView:(NSTabView*)tabView
   shouldSelectTabViewItem:(NSTabViewItem*)tabViewItem {
	BOOL answer ;
	
	if (tabView == syncingTabView) {
		if (tabViewItem == tabAdvanced) {
			// Switching from Simple to Advanced
			// In this case, we're not going to remove any agents, so "just do it"
			// And so that we don't return here in an infinite loop,
			m_isSelectingSyncingTabView = YES ;
			[self syncersSetExpertise:YES] ;
			answer = YES ;
		}
		else if ([[[[[self windowController]  document] macster] syncers] count] == 0) {
			// There are no agents to worry about removing, so "just do it"
			// And so that we don't return here in an infinite loop,
			m_isSelectingSyncingTabView = YES ;
			[self syncersSetExpertise:NO] ;
			answer = YES ;
		}
		else {
			// Switching from Advanced to Simple
			
			if (m_okToSwitchTabViewExpertise) {
				// Warning sheet has already been shown
				m_isSelectingSyncingTabView = NO ;
				answer = YES ;
			}
			else {
				// Show a warning sheet first
				answer = NO ;
				
				m_isSelectingSyncingTabView = NO ;
				
				BOOL no = NO ;
				NSInvocation* invocationDoIt = [NSInvocation invocationWithTarget:self
																		 selector:@selector(syncersSetExpertise:)
																  retainArguments:YES
																argumentAddresses:&no] ;
				NSInvocation* invocationCancel = [NSInvocation invocationWithTarget:self
																		   selector:@selector(justResetIsSelectingSyncingTabView)
																	retainArguments:YES
																  argumentAddresses:NULL] ;
				
				SSYAlert* alert = [SSYAlert alert] ;
				NSString* msg = [[BkmxBasis sharedBasis] stringSyncersSimplify] ;
				[alert setSmallText:msg] ;
				[alert setButton1Title:[[BkmxBasis sharedBasis] labelOk]] ;
				[alert setButton2Title:[[BkmxBasis sharedBasis] labelCancel]] ;
				[alert setIconStyle:SSYAlertIconCritical] ;
				[alert runModalSheetOnWindow:[[self windowController]  window]
                                  resizeable:NO
							   modalDelegate:[SSYSheetEnder class]
							  didEndSelector:@selector(didEndGenericSheet:returnCode:retainedInvocations:)
								 contextInfo:[[NSArray arrayWithObjects:
											   invocationDoIt,
											   invocationCancel,
											   nil] retain]] ;
			}
		}
	}
	else {
		answer = YES ;
	}
	
	if (
		([[self windowController]  activeTabViewItem] == tabClients)
		&&
		(tabViewItem != tabClients)
		) {
		// User is moving OUT of Clients tab view
		[[[[self windowController]  document] shig] userDidEndFussingWithClients] ;
	}
	
	return answer ;
}

- (void)exposeUIForUserToFixBadAgentIndex:(NSInteger)badAgentIndex
                          badCommandIndex:(NSInteger)badCommandIndex {
	[syncersArrayController setSelectionIndex:badAgentIndex] ;
	if (badCommandIndex != NSNotFound) {
		[commandsArrayController setSelectionIndex:badCommandIndex] ;
	}
}


- (void)selectSyncingTabPerCurrentExpertise {
	if (!m_isSelectingSyncingTabView) {
        long long syncerConfigValue = [[[[self windowController]  document] macster] syncerConfigValue] ;
		BOOL advanced = (syncerConfigValue == constBkmxSyncerConfigIsAdvanced) ;
		NSTabViewItem* tabViewItem = advanced ? tabAdvanced : tabSimple ;
		m_isSelectingSyncingTabView = YES ;  // Added in BookMacster 1.5
		[syncingTabView selectTabViewItem:tabViewItem] ;
		m_isSelectingSyncingTabView = NO ;
	}
}

- (void)syncersSetExpertise:(BOOL)expertise {
	// Change the data model
	[[[[self windowController]  document] macster] syncersSetExpertise:expertise] ;
	
	// Change the view
	m_okToSwitchTabViewExpertise = YES ;
	[self selectSyncingTabPerCurrentExpertise] ;
	m_okToSwitchTabViewExpertise = NO ;
}

- (void)justResetIsSelectingSyncingTabView {
	m_isSelectingSyncingTabView = NO ;
}


- (void)reloadNewBookmarkLandingMenu {
	BkmxDoc* bkmxDoc = [[self windowController]  document] ;
	SSYDynamicMenu* menu = (SSYDynamicMenu*)[landingPopup menu] ;
	[menu setRepresentedObjects:[bkmxDoc bookmarkContainers]] ;
	[menu setSelectedRepresentedObject:[[bkmxDoc shig] landing]] ;
	[menu reload] ;
}

- (IBAction)helpLocalSettings:(id)sender {
	NSInteger settingsTabSelectedIndex = [settingsTabView indexOfTabViewItem:[settingsTabView selectedTabViewItem]] ;
	NSString* currentTabName = [self labelForSettingsTabIndex:settingsTabSelectedIndex] ;
	NSString* msg = [[self windowController]  explainNotAvailableTabName:currentTabName] ;
	SSYAlert* alert = [SSYAlert alert] ;
	[alert setSmallText:msg] ;
	[alert setTitleText:[[BkmxBasis sharedBasis] labelLocalSettings]] ;
	[alert setButton1Title:[NSString localize:@"close"]] ;
	[alert setHelpAddress:constHelpAnchorLocalSettings] ;
    [[[self windowController]  document] runModalSheetAlert:alert
                                                 resizeable:NO
                                                  iconStyle:SSYAlertIconInformational
                                              modalDelegate:nil
                                             didEndSelector:NULL
                                                contextInfo:NULL] ;
}

- (void)agentDidChangeNote:(NSNotification*)note {
	// I don't understand why the following is needed, because the array controller has
	// autorearrangesObjects switched on (in Interface Builder).  However, without this,
	// the following test case fails...
	// *  Add an syncer by clicking the [+] button adjacent the table view.
	//       Result: Works OK
	// *  Add another syncer.  Result: 2nd syncer does not appear in table view
	//       and although NSLog says that the array controller's 'content'
	//       contains 2 agents, array controller's 'arrangedObjects' only
	//       contains 1 syncer.
	// *  Add a third syncer.  Result:  Now there are three agents in the table
	//       view, but the second syncer is last.  Both 'content' and
	//       'arrangedObjects' contain 3 agents.
	[syncersArrayController rearrangeObjects] ;
}

- (void)clientDidChangeNote:(NSNotification*)note {
	// The notification object of constNoteBkmxClientDidChange is a Macster
	// instance, but when we registered for constNoteBkmxClientDidChange,
	// we did not specify an object.  So we need to filter out other
	// Macsters.
	if ([[note name] isEqualToString:constNoteBkmxClientDidChange]) {
		if ([note object] != [[[self windowController]  document] macster]) {
			return ;
		}
	}
	// (The alternative to the above is to specify a Macster object when
	// adding the observer, but then we'd have to observe for a Save As,
	// then unregister that observer and add a new observer with the
	// new Macster.  I think this way is easier.)
	
	if ([[note name] isEqualToString:BkmxDocDidSaveNotification]) {
		// We are only interested if this was a Save As operation, because
		// in that case our document's Macster will have changed, which
		// means our Clients will have changed (to 0 clients).
		NSSaveOperationType saveOperationType = [[[note userInfo] objectForKey:BkmxDocKeySaveOperation] integerValue] ;
		if (saveOperationType != NSSaveAsOperation) {
			return ;
		}
	}
}

- (void)clientsDidReheightNote:(NSNotification*)note {
	if ([[self windowController]  activeTabViewItem] == tabClients) {
        [[self windowController]  resizeWindowForLeafTabViewItem:tabClients] ;
	}

    BOOL canReorder = [self.clientListView itemCount] > 1;
    if (canReorder) {
        labelReorder.hidden = NO;
    } else {
        labelReorder.hidden = YES;
    }
}

/*!
 @brief    Restores the autosaved tab view selections
 for the 'agents' tab view.
 
 @details  Note that, for robustness and data consistency,
 the 'agents' tab view selection is restored in accordance with the
 'syncerConfig' attribute of the Macster, stored in the settingsMoc,
 and not autosaved in user defaults.
 */
- (void)restoreSyncingTabViewSelection {
	long long syncerConfig = [[(BkmxDoc*)[[self windowController]  document] macster] syncerConfigValue] ;
	NSTabViewItem* item = ((syncerConfig & constBkmxSyncerConfigIsAdvanced) != 0) ? tabAdvanced : tabSimple ;
	[syncingTabView selectTabViewItem:item] ;
}

- (BOOL)disallowInVersionsBrowserTabViewItem:(NSTabViewItem*)tabViewItem {
    return (
            (tabViewItem == tabOpenSave)
            ||
            (tabViewItem == tabClients)
            ||
            (tabViewItem == tabSyncing)
            ) ;
}

- (Syncer*)selectedAgent {
	// Note that I don't use -[NSObjectController selection] because
	// that method returns a stupid proxy object that may or may not
	// respond as expected.
	Syncer* selectedAgent = [[syncersArrayController selectedObjects] firstObjectSafely] ;
	return selectedAgent ;
}

- (Trigger*)selectedTrigger {
	// Note that I don't use -[NSObjectController selection] because
	// that method returns a stupid proxy object that may or may not
	// respond as expected.
	Trigger* selectedTrigger = [[triggersArrayController selectedObjects] firstObjectSafely] ;
	return selectedTrigger ;
}

- (IBAction)performSelectedSyncer:(id)sender {
	Trigger* trigger = [self selectedTrigger] ;
	Syncer* selectedSyncer = [self selectedAgent] ;
	NSString* msg = [NSString localize:@"commandPerfWarnBookmarks"] ;
	if ([selectedSyncer anyCommandDoes1Import]) {
		msg = [msg stringByAppendingFormat:
			   @"\n\n(%@)",
			   [NSString localizeFormat:
				@"willX",
				[NSString localizeFormat:
				 @"imex_importFromX",
				 [[trigger client] displayName]]]] ;
	}
	if ([selectedSyncer anyCommandDoes1Export]) {
		msg = [msg stringByAppendingFormat:
			   @"\n\n(%@)",
			   [NSString localizeFormat:
				@"willX",
				[NSString localizeFormat:
				 @"imex_exportToX",
				 [[trigger client] displayName]]]] ;
	}
	
	SSYAlert* alert = [SSYAlert alert] ;
	[alert setSmallText:msg] ;
	[alert setButton1Title:[[BkmxBasis sharedBasis] labelDoIt]] ;
	[alert setButton2Title:[[BkmxBasis sharedBasis] labelCancel]] ;
	[alert setIconStyle:SSYAlertIconCritical] ;
	
    SEL selector = @selector(performOverrideDeference:ignoreLimit:job:performanceType:errorAlertee:) ;
	BkmxDeference deference = BkmxDeferenceAsk ;
	BkmxPerformanceType performanceType = BkmxPerformanceTypeUser ;
	BOOL no = NO ; // don't ignore limit
	BkmxDoc* bkmxDoc = (BkmxDoc*)[[self windowController]  document] ;
    Job* job = [Job new];
    job.serial = [[NSUserDefaults standardUserDefaults] nextJobSerialforCreator:@"Manual Command"];
    job.syncerUri = selectedSyncer.objectID.URIRepresentation.absoluteString;
    job.syncerIndex = selectedSyncer.index.integerValue;
    job.docUuid = bkmxDoc.uuid;
    job.triggerUri = trigger.objectID.URIRepresentation.absoluteString;
 	NSInvocation* invocation = [NSInvocation invocationWithTarget:[AgentPerformer sharedPerformer]
														 selector:selector
												  retainArguments:YES
												argumentAddresses:&deference, &no, &job, &performanceType, &bkmxDoc] ;
    [job release];

	[alert runModalSheetOnWindow:[[self windowController]  window]
                      resizeable:NO
                   modalDelegate:[SSYSheetEnder class]
				  didEndSelector:@selector(didEndGenericSheet:returnCode:retainedInvocations:)
					 contextInfo:[[NSArray arrayWithObject:invocation] retain]] ;
}

- (IBAction)showImportPostprocSheet:(id)sender {
	[ImportPostprocController showSheetOnWindow:[[self windowController]  window]
                                       document:[[self windowController]  document]] ;
}

- (IBAction)helpSimpleSyncers:(id)sender {
    [(BkmxAppDel*)[NSApp delegate] openHelpAnchor:constHelpAnchorSyncersSimple] ;
}


- (BOOL)simpleSyncersIsHalfFull {
    long long syncerConfigValue = [[[[self windowController]  document] macster] syncerConfigActiveValue] ;
    NSInteger countOfSyncerConfigs = 0 ;
    if ((syncerConfigValue & constBkmxSyncerConfigImportChanges) > 0) {
        countOfSyncerConfigs++ ;
    }
    if ((syncerConfigValue & constBkmxSyncerConfigSort) > 0) {
        countOfSyncerConfigs++ ;
    }
    if ((syncerConfigValue & constBkmxSyncerConfigExportToClients) > 0) {
        countOfSyncerConfigs++ ;
    }
    if ((syncerConfigValue & constBkmxSyncerConfigExportFromCloud) > 0) {
        countOfSyncerConfigs++ ;
    }
    if ((syncerConfigValue & constBkmxSyncerConfigExportLanding) > 0) {
        countOfSyncerConfigs++ ;
    }
    
    BOOL answer = (countOfSyncerConfigs > 2) ;
    return answer ;
}

+ (NSSet*)keyPathsForValuesAffectingsimpleSyncersIsHalfFull {
    return [NSSet setWithObjects:
            @"windowController.document.macster.syncerConfigActiveValue",
            nil] ;
}


- (IBAction)simpleAllOrNone:(id)sender {
    if ([self simpleSyncersIsHalfFull]) {
        [[[[self windowController]  document] macster] setSyncerConfigActiveValueNone] ;
    }
    else {
        [[[[self windowController]  document] macster] setSyncerConfigFullSync] ;
    }
}

- (NSString*)simpleAllOrNoneTitle {
    NSString* title ;
    if ([self simpleSyncersIsHalfFull]) {
        title = NSLocalizedString(@"No Syncing", nil);
    }
    else {
        title = NSLocalizedString(@"Full Syncing", nil);
    }
    
    return title ;
}

+ (NSSet*)keyPathsForValuesAffectingSimpleAllOrNoneTitle {
    return [NSSet setWithObjects:
            @"simpleSyncersIsHalfFull",
            nil] ;
}

#pragma mark Infrastructure

- (void)tearDown {
    // Must unbind the things that we bound, bad things from happening as the window closes.
	// The table columns have been seen to get Core Data Console Burps like this:
	// "The NSManagedObject with ID:0x16f7f2f0 <x-coredata://A_UUID/Stark_entity/p20> has been invalidated."

	[clientListView removeObservers] ;
	[switchSettingsTab unbind:@"selectedIndex"] ;
	[settingsTabView unbind:@"selectedTabIndex"] ;
    [syncStatusTextField unbind:@"syncStatus"] ;
    [simpleAllOrNoneButton unbind:@"title"] ;
    [bookshigController unbind:@"managedObjectContext"] ;

    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
	[[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self] ;

    [super tearDown] ;
}

- (void)reload {
    // In case someone changes the name of their New Bookmark Landing folder...
	[self reloadNewBookmarkLandingMenu] ;
    
    BOOL canReorder = [self.clientListView itemCount] > 1;
    if (canReorder) {
        labelReorder.hidden = NO;
    } else {
        labelReorder.hidden = YES;
    }
}

- (void)updateWindow {
	[self reload] ;
}

- (void)autosaveAllCurrentValues {
	[[self windowController]  autosaveSelectedTabViewItem:[[self settingsTabView] selectedTabViewItem]
                                        inTabView:[self settingsTabView]] ;
	// This method does not store the tab view selection
	// for the 'agents' tab view, 'simple' vs. 'advanced'.
	// For robustness and data consistency, that tab view
	// is restored in accordance with the 'syncerConfig'
	// attribute of the Macster, stored in the settingsMoc.
	// So we ignore it here.  See -restoreSyncingTabViewSelection.
}

- (void)awakeFromNib {
	// Safely invoke super
	[self safelySendSuperSelector:_cmd
                   prettyFunction:__PRETTY_FUNCTION__
						arguments:nil] ;

    if ([self awakened]) {
        return ;
    }
    [self setAwakened:YES] ;

    // Arrow images in Clients tab
    NSImage* arrowImage = [SSYVectorImages imageStyle:SSYVectorImageStyleTriangle53
                                               wength:[clientUpArrow frame].size.width
                                                color:nil
                                         darkModeView:nil // For this template image, Cocoa will handle luminance inversion when in Dark Mode
                                        rotateDegrees:0.0
                                                inset:0.0] ;
    [clientUpArrow setImage:arrowImage] ;
    arrowImage = [arrowImage imageRotatedByDegrees:180.0] ;
    [clientDownArrow setImage:arrowImage] ;
    
    [clientListView setHasAdvancedButton:YES] ;
    
    // NSImageView does not support a binding on its 'image', so we must
    // do it the old fashioned way.  Set the image with what we know now,
    // then observe for changes.  See -clientDidChangeNote:.
	[self clientDidChangeNote:nil];
    
	StarkContainersFlatMenu* newBookmarkLandingMenu = (StarkContainersFlatMenu*)[landingPopup menu] ;
	[newBookmarkLandingMenu setTarget:[[[self windowController]  document] shig]] ;
	[newBookmarkLandingMenu setSelector:@selector(setNewBookmarkLandingFromMenuItem:)] ;
	[newBookmarkLandingMenu setOwningPopUpButton:landingPopup] ;
	[self reloadNewBookmarkLandingMenu] ;
    
	for (NSInteger i=0; i<[switchSettingsTab segmentCount]; i++) {
		[switchSettingsTab setLabel:[self labelForSettingsTabIndex:i]
						 forSegment:i] ;
	}
    
    // Bind "Settings" Tab View to its Segmented Control
    // Bind so that changes will propagate from toolbarItemSettings to switchSettingsTab
    [switchSettingsTab bind:@"selectedIndex"
                   toObject:settingsTabView
                withKeyPath:@"selectedTabIndex"
                    options:0] ;
    // Bind so that changes will propagate from switchSettingsTab to toolbarItemSettings
    [settingsTabView bind:@"selectedTabIndex"
                 toObject:switchSettingsTab
              withKeyPath:@"selectedSegment"
                  options:0] ;
    
    /* For explanation of why I do this binding "manually" instead of in the 
     nib, see Note 20131204 below. */
    [simpleAllOrNoneButton bind:@"title"
                       toObject:self
                    withKeyPath:@"simpleAllOrNoneTitle"
                        options:0] ;
    
    NSFont* boldControlFont = [[NSFontManager sharedFontManager] convertFont:[labelWhich font]
																 toHaveTrait:NSBoldFontMask] ;
	[labelHow setFont:boldControlFont] ;
	[labelWhich setFont:boldControlFont] ;
    
    [syncersArrayController setParentObject:[[[self windowController]  document] macster]] ;
	[syncersArrayController setContentKey:constKeySyncers] ;
	[triggersArrayController setParentObjectKey:constKeySyncer] ;
	[triggersArrayController setContentKey:constKeyTriggers] ;
	[commandsArrayController setParentObjectKey:constKeySyncer] ;
	[commandsArrayController setContentKey:constKeyCommands] ;
	
	NSSortDescriptor* byIndexSortDescriptor = [[NSSortDescriptor alloc] initWithKey:constKeyIndex
                                                                          ascending:YES
                                                                           selector:@selector(compare:)] ;
	NSArray* byIndexSortDescriptors = [NSArray arrayWithObject:byIndexSortDescriptor] ;
	[byIndexSortDescriptor release] ;
	[syncersArrayController setSortDescriptors:byIndexSortDescriptors] ;
	[triggersArrayController setSortDescriptors:byIndexSortDescriptors] ;
	[commandsArrayController setSortDescriptors:byIndexSortDescriptors] ;
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(agentDidChangeNote:)
												 name:constNoteBkmxSyncerDidChange
											   object:nil] ;
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(clientDidChangeNote:)
												 name:constNoteBkmxClientDidChange
											   object:nil] ;
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(clientDidChangeNote:)
												 name:BkmxDocDidSaveNotification
											   object:nil] ;	
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(clientsDidReheightNote:)
												 name:constNoteClientListViewDidReheight
											   object:clientListView] ;
    
    // Restore the Settings tab selection to autosaved value, if it works
    NSDictionary* autosaves = [[self windowController]  tabAutosaves] ;
    NSString* tabIdentifier = [autosaves objectForKey:constIdentifierTabViewSettings] ;
    if (!tabIdentifier) {
        tabIdentifier = constIdentifierTabViewGeneral ;
    }
	// Make sure that setting is not t a Local Setting if we're in Viewing Mode
    if ([(BkmxDoc*)[[self windowController]  document] ssy_isInViewingMode]) {
        if (
            ([tabIdentifier isEqualToString:constIdentifierTabViewOpenSave])
            ||
            ([tabIdentifier isEqualToString:constIdentifierTabViewClients])
            ||
            ([tabIdentifier isEqualToString:constIdentifierTabViewSyncing])
            ||
            ([tabIdentifier isEqualToString:constIdentifierTabViewDiaries])
            ) {
            // Set to default.
            tabIdentifier = constIdentifierTabViewGeneral ;
        }
    }
    [settingsTabView selectTabViewItemWithIdentifier:tabIdentifier] ;
    
	// Bind so that data will flow from us to toolbarItem
	[syncStatusTextField bind:@"syncStatus"
                     toObject:[self windowController]
                  withKeyPath:@"agentsPausitivity"
                      options:0] ;
	// Propagate initial value
    NSInteger pausitivity = [[self windowController]  agentsPausitivity];
	[syncStatusTextField setSyncStatus:pausitivity] ;
	[syncStatusTextField setTarget:self] ;
    
    
    
    [self restoreSyncingTabViewSelection] ;

    // Now that we've got the autosaves (window size, tab selection, split view
	// sizes, user-defined columns, and columns widths) we can safely populate
	// the views with data and not have to worry about, for example,
	// sending -sizeToFit messages to subviews that will later be resized.
	[self updateWindow] ;
}

- (void)dealloc {
    [super dealloc] ;
}

#pragma mark BkmxDocumentProvider Protocol Support (for ClientsListView)

- (BkmxDoc*)theDocument {
    return [[self windowController] document] ;
}

- (NSImage*)documentImage {
    return [[NSDocumentController sharedDocumentController] defaultDocumentImage] ;
}

- (NSButton*)importPostprocButton {
    return importPostprocButton ;
}

- (ClientListView*)clientListView {
    return clientListView ;
}

- (IBAction)revealTabViewClients {
    [[self windowController] revealTabViewClients:nil] ;
}

- (void)guideUserToSafeLimitMenuItem:(NSMenuItem*)menuItem {
    [SafeLimitGuider guideUserFromMenuItem:menuItem
                          windowController:[self windowController]
                          documentProvider:self] ;
}




/* Note 20131204

** To cocoa-dev@lists.apple.com from Jerry
 
 After binding the title of a button in a nib, I started getting the following burps today, whenever its window was closed.
 
 An instance 0x100c598c0 of class MyWindowController was deallocated while key value observers were still registered ... [You know the drill] ... Key path: document.foo.bar ...
 
 Thanks to some of the nice -description implementations given by Apple to their proxy things, I found the cause which was that, while this button’s title was bound to a different key path, ‘buttonTitle’ of MyViewController, MyViewController has an implementation of +keyPathsForValuesAffectingButtonTitle which returns windowController.document.foo.bar.  The window controller is being deallocced before the view controller.  So, although the “base” part of the binding was still intact, this keyPathForValuesAffecting was still in use when it was broken.
 
 The view controller is instantiated in the nib.  The File’s Owner is the window controller, which is wired in the nib to a ‘windowController’ *outlet* of the view controller.  I do this because this window contains three tabs, some of which can take a long time to load, and to improve performance I put each tab in a separate nib and load it only when the user wants to see it.  Each nib contains its own view controller.  In order to access the data model and document, the view controller uses key path ‘windowController.document', via this outlet.  It was an architecture that I arrived at after "trying everything else", and I’ve been happy with it.
 
 Well, each of my view controller’s, and my window controller, has a -tearDown method in which I remove all the bindings and observers that would other cause this kind of burp.  So I solved the problem by deleting the binding of the button’s title from the xib, and instead implementing the *exact* same binding “manually” in the view controller’s -awakeFromNib, using -bind:toObject:withKeyPath:options:, so that I could -unbind: it in my view controller’s -tearDown method.
 
 I’m wondering what went wrong here.  Possible explanations:
 
 (A)  My architecture is all wrong.
 (B)  You should never put an outlet in a key path.  Why not, and what alternative is there?
 (C)  This is a very rare corner case.  Forget it and move on.
 (D)  Cocoa Bindings should be smart enough to stop observing keyPathsForValueAffecting after being notified that a window is closing.  This is a bug which I should report to Apple.

 ** Reply from Quincey Morris
 
 I ran into the same error recently, with an existing project which hadn’t previously been debugged under Mavericks. I believe the error is now appearing because Mavericks is checking for dangling observers more accurately.
 
 The implication of your description, quoted above, is that the outlet is a ‘weak' (or 'assign’) property. If it was strong, the window controller wouldn’t be deallocated before the view controller.
 
 The problem is that such a windowController property isn’t KVO compliant. What you need is for the value to change to nil, KVO compliantly, when the nib is being discarded. That (the KVO compliance) will cause the automatic observers to stop observing the window controller, and then all will be well. If the property is weak, it’s changing to nil, but not KVO-compliantly. If it’s assign, then it’s not changing at all, even though the object it’s pointing to has been deallocated.
 
 It seems likely that changing the outlet to strong will cause a reference cycle, so you'll have to find a way of breaking the cycle manually at suitable times.
 
 ** Reply from Jerry
 
 Thank you, Quincey.  Yes, it makes sense that an outlet would not be KVO compliant, and I don’t want to mess around with their magic memory management, so I’ll just stick with the solution I have (using manual bindings).
 
 I’d never worried about requiring the path components returned in +keyPathsForValuesAffecting<Foo> to be KVO compliant, but thinking about it for a minute, this requirement makes sense.
 
 */


@end
