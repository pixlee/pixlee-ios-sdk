//
//  ExampleUITests.swift
//  ExampleUITests
//
//  Created by Csaba Toth on 2020. 01. 08..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import XCTest
import PixleeSDK

class ExampleUITests: XCTestCase {
    let buttonOfEnabledAnalytics = "[ON] PXLGridView -> PXLPhotoProductView"
    let buttonOfDisabledAnalytics = "[OFF] PXLGridView -> PXLPhotoProductView"
    let noEventsMessage = "no events yet"
    let format = "label CONTAINS[c] %@"
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func createApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchEnvironment = ["animations": "0"]
        app.launchArguments = ["IS_UI_TESTING"]
        setupSnapshot(app)
        app.launch()
        return app
    }
    
    func testAllAnalyticsWhenTurnedOff() {
        let app = createApp()

        PXLClient.sharedClient.autoAnalyticsEnabled = false
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons[buttonOfDisabledAnalytics].tap()
        
        
        
        let label = app.staticTexts.element(matching: .any, identifier: PXLAnalyticsService.TAG)
        expectation(for: NSPredicate(format: format, noEventsMessage), evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: 3, handler: nil)
        snapshot("openedWidget_widgetVisible")
        XCTAssertTrue(app.staticTexts.containing(NSPredicate(format: format, noEventsMessage)).count>0)
        
        app.collectionViews.children(matching: .cell).element(boundBy: 0).buttons["PXLPhotoProductView"].tap()
        XCTAssertTrue(app.staticTexts.containing(NSPredicate(format: format, noEventsMessage)).count>0)
        snapshot("openedLightbox")
        app.terminate()
    }

    
    func testAllAnalytics() {
        let app = createApp()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons[buttonOfEnabledAnalytics].tap()

        let label = app.staticTexts.element(matching: .any, identifier: PXLAnalyticsService.TAG)
        expectation(for: NSPredicate(format: format, "openedWidget"), evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: 3, handler: nil)
        snapshot("openedWidget_widgetVisible")
        XCTAssertTrue(app.staticTexts.containing(NSPredicate(format: format, "widgetVisible")).count>0)

        app.collectionViews.children(matching: .cell).element(boundBy: 0).buttons["PXLPhotoProductView"].tap()
        XCTAssertTrue(app.staticTexts.containing(NSPredicate(format: format, "openedLightbox")).count>0)
        snapshot("openedLightbox")
        app.terminate()
    }
    
    func testOpenedWidget() {
        let app = createApp()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons[buttonOfEnabledAnalytics].tap()
        
        let label = app.staticTexts.element(matching: .any, identifier: PXLAnalyticsService.TAG)
        expectation(for: NSPredicate(format: format, "openedWidget"), evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        app.terminate()
    }
    
    func testWidgetVisible() {
        let app = createApp()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons[buttonOfEnabledAnalytics].tap()
        
        let label = app.staticTexts.element(matching: .any, identifier: PXLAnalyticsService.TAG)
        expectation(for: NSPredicate(format: format, "widgetVisible"), evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        app.terminate()
    }
    
    func testOpenedLightbox() {
        let app = createApp()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons[buttonOfEnabledAnalytics].tap()
        
        let label = app.staticTexts.element(matching: .any, identifier: PXLAnalyticsService.TAG)
        expectation(for: NSPredicate(format: format, "openedWidget"), evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        app.collectionViews.children(matching: .cell).element(boundBy: 0).buttons["PXLPhotoProductView"].tap()
        XCTAssertTrue(app.staticTexts.containing(NSPredicate(format: format, "openedLightbox")).count>0)
        app.terminate()
    }
}
