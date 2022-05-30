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
    let buttonOfPXLWidgetViewWithAnalytics = "PXLWidgetView"
    let buttonOfPXLGridViewWithAnalytics = "[ON] PXLGridView -> PXLPhotoProductView"
    let buttonOfPXLGridViewWithoutAnalytics = "[OFF] PXLGridView -> PXLPhotoProductView"
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
    
    func createApp(_ viewMode: String? = nil) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchEnvironment = ["animations": "0"]
        app.launchArguments = {
            if let viewMode = viewMode {
                return ["IS_UI_TESTING", viewMode]
            } else {
                return ["IS_UI_TESTING"]
            }
        }()
        setupSnapshot(app)
        app.launch()
        return app
    }
    
    func testPXLGridViewWithNoAnalytics() {
        let app = createApp()

        PXLClient.sharedClient.autoAnalyticsEnabled = false
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons[buttonOfPXLGridViewWithoutAnalytics].tap()

        
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
    
    func testUIViewWithAnalytics(menuName: String, viewMode: String?, button: String) {
        let app = createApp(viewMode)
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons[menuName].tap()
        
        let label = app.staticTexts.element(matching: .any, identifier: PXLAnalyticsService.TAG)
        expectation(for: NSPredicate(format: format, "openedWidget"), evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: 3, handler: nil)
        snapshot("openedWidget_widgetVisible")
        XCTAssertTrue(app.staticTexts.containing(NSPredicate(format: format, "widgetVisible")).count>0)
        
        app.collectionViews.children(matching: .cell).element(boundBy: 0).buttons[button].tap()
        XCTAssertTrue(app.staticTexts.containing(NSPredicate(format: format, "openedLightbox")).count>0)
        snapshot("openedLightbox")
        app.terminate()
    }

    func testPXLGridViewAnalytics() {
        testUIViewWithAnalytics(menuName: buttonOfPXLGridViewWithAnalytics, viewMode: nil, button: "LightBox")
    }
    
    func generatePXLWidetViewTesting(_ viewMode: String) {
        testUIViewWithAnalytics(menuName: buttonOfPXLWidgetViewWithAnalytics, viewMode: viewMode, button: "Detail")
    }
    
    func testAnalyticsOfPXLWidetViewInList() {
        generatePXLWidetViewTesting("UI_TESTING_LIST_WIDGET")
    }
    
    func testAnalyticsOfPXLWidetViewInGrid() {
        generatePXLWidetViewTesting("UI_TESTING_GRID_WIDGET")
    }
    
    func testAnalyticsOfPXLWidetViewIn3spansMosaic() {
        generatePXLWidetViewTesting("UI_TESTING_3SPANS_MOSAIC_WIDGET")
    }
    
    func testAnalyticsOfPXLWidetViewIn4spansMosaic() {
        generatePXLWidetViewTesting("UI_TESTING_4SPANS_MOSAIC_WIDGET")
    }
    
    func testAnalyticsOfPXLWidetViewIn5spansMosaic() {
        generatePXLWidetViewTesting("UI_TESTING_5SPANS_MOSAIC_WIDGET")
    }
    
    func testAnalyticsOfPXLWidetViewInHorizontalMosaic() {
        generatePXLWidetViewTesting("UI_TESTING_HORIZONTAL_WIDGET")
    }
    

    
    func testOpenedWidget() {
        let app = createApp()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons[buttonOfPXLGridViewWithAnalytics].tap()
        
        let label = app.staticTexts.element(matching: .any, identifier: PXLAnalyticsService.TAG)
        expectation(for: NSPredicate(format: format, "openedWidget"), evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        app.terminate()
    }
    
    func testWidgetVisible() {
        let app = createApp()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons[buttonOfPXLGridViewWithAnalytics].tap()
        
        let label = app.staticTexts.element(matching: .any, identifier: PXLAnalyticsService.TAG)
        expectation(for: NSPredicate(format: format, "widgetVisible"), evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        app.terminate()
    }
}
