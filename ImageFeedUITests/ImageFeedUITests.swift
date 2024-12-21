import XCTest

final class ImageFeedUITests: XCTestCase {
    private var app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--disable-pagination")
        app.launch()
    }
    
    func testAuth() throws {
        let button = app.buttons["Войти"]
        XCTAssertTrue(button.waitForExistence(timeout: 5))
        button.tap()
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("symbatsalin@gmail.com")
        webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText("523447Qwe")
        
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables["table View"]
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 20))
        sleep(5)
        app.swipeUp()
        
        sleep(5)
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        XCTAssertTrue(cellToLike.waitForExistence(timeout: 5), "Cell does not exist")
        
        cellToLike.buttons["No Active"].tap()
        sleep(5)
        cellToLike.buttons["Active"].tap()
        
        sleep(5)
        
        cellToLike.tap()
        
        sleep(10)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["nav back button white"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["Symbat Salin"].exists)
        XCTAssertTrue(app.staticTexts["@symbats"].exists)
        
        app.buttons["Logout"].tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
    }
}
