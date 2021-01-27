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

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAnalytics() {
        let app = XCUIApplication()
        app.launchEnvironment = ["animations": "0"]
        setupSnapshot(app)
        app.launch()

        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["[Demo] PXLGridView -> PXLPhotoProductView"].tap()

        let format = "label CONTAINS[c] %@"

        let label = app.staticTexts.element(matching: .any, identifier: PXLAnalyticsService.TAG)
        expectation(for: NSPredicate(format: format, "openedWidget"), evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: 3) { error in
            if error != nil {
                assertionFailure("no openedWidget received")
            } else{
                XCTAssertTrue(true)
            }

        }
        //XCTAssertTrue(app.staticTexts.containing(NSPredicate(format: format, "openedWidget")).count>0)
        XCTAssertTrue(app.staticTexts.containing(NSPredicate(format: format, "widgetVisible")).count>0)

        app.collectionViews.children(matching: .cell).element(boundBy: 0).buttons["PXLPhotoProductView"].tap()
        XCTAssertTrue(app.staticTexts.containing(NSPredicate(format: format, "openedLightbox")).count>0)
        app.terminate()
    }
    
    func atestOpenedWidget() {
        let app = XCUIApplication()
        app.launchEnvironment = ["animations": "0"]
        setupSnapshot(app)
        app.launch()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["[Demo] PXLGridView -> PXLPhotoProductView"].tap()
        
        let format = "label CONTAINS[c] %@"
        
        let label = app.staticTexts.element(matching: .any, identifier: PXLAnalyticsService.TAG)
        expectation(for: NSPredicate(format: format, "openedWidget"), evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: 3) { error in
            if error != nil {
                assertionFailure("no openedWidget received")
            } else{
                XCTAssertTrue(true)
            }
            
        }
        app.terminate()
    }
    
    func atestWidgetVisible() {
        let app = XCUIApplication()
        app.launchEnvironment = ["animations": "0"]
        setupSnapshot(app)
        app.launch()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["[Demo] PXLGridView -> PXLPhotoProductView"].tap()
        
        let format = "label CONTAINS[c] %@"
        
        let label = app.staticTexts.element(matching: .any, identifier: PXLAnalyticsService.TAG)
        expectation(for: NSPredicate(format: format, "widgetVisible"), evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: 3) { error in
            if error != nil {
                assertionFailure("no openedWidget received")
            } else{
                XCTAssertTrue(true)
            }
            
        }
        app.terminate()
    }
    
    func atestOpenedLightbox() {
        let app = XCUIApplication()
        app.launchEnvironment = ["animations": "0"]
        setupSnapshot(app)
        app.launch()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["[Demo] PXLGridView -> PXLPhotoProductView"].tap()
        
        let format = "label CONTAINS[c] %@"
        
        let label = app.staticTexts.element(matching: .any, identifier: PXLAnalyticsService.TAG)
        expectation(for: NSPredicate(format: format, "openedWidget"), evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: 3) { error in
            if error != nil {
                assertionFailure("no openedWidget received")
            } else{
                XCTAssertTrue(true)
            }
            
        }
        app.collectionViews.children(matching: .cell).element(boundBy: 0).buttons["PXLPhotoProductView"].tap()
        XCTAssertTrue(app.staticTexts.containing(NSPredicate(format: format, "openedLightbox")).count>0)
        app.terminate()
    }
}
