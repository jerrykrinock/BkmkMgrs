//
//  BookMacsterUITests.m
//  BookMacsterUITests
//
//  Created by Jerry on 16/07/23.
//
//

#import <XCTest/XCTest.h>

@interface BookMacsterUITests : XCTestCase

@end

@implementation BookMacsterUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    XCUIApplication* app = [[XCUIApplication alloc] init] ;
     
     [app launch];

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNewDocument {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElementQuery *menuBarsQuery = app.menuBars;
    [menuBarsQuery.menuBarItems[@"File"] click];
    [menuBarsQuery.menuItems[@"New Collection"] click];
    [[[app.dialogs[@"Save"] childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:0] typeText:@"\r"];
    
    NSLog(@"Windows are: %@", app.windows) ;
#if 0
    XCUIElement *jk14BkmslfWindow = app.windows[@"jk-14.bkmslf"];
    XCUIElementQuery *sheetsQuery = jk14BkmslfWindow.sheets;
    [sheetsQuery.buttons[@"Done"] click];
    [sheetsQuery.buttons[@"Yes"] typeText:@"\r"];
    [jk14BkmslfWindow typeKey:@"q" modifierFlags:XCUIKeyModifierCommand];
#endif
}

@end
