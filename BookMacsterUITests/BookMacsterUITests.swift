import XCTest

class BookMacsterUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func newDocument() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        let menuBarsQuery = app.menuBars
        menuBarsQuery.menuBarItems["File"].click()
        menuBarsQuery.menuItems["New Bookmarkshelf"].click()
        app.buttons["Save"].click()
        
        let jk13BkmslfWindow = app.windows["jk-13.bkmslf"]
        let sheetsQuery = jk13BkmslfWindow.sheets
        sheetsQuery.buttons["Done"].click()
        sheetsQuery.buttons["No"].click()
        jk13BkmslfWindow.typeKey("q", modifierFlags:.command)
    }
    
}
