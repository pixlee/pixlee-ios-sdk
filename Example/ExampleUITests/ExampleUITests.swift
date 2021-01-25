//
//  ExampleUITests.swift
//  ExampleUITests
//
//  Created by Csaba Toth on 2020. 01. 08..
//  Copyright © 2020. Pixlee. All rights reserved.
//

import XCTest

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

    func testExample() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testAnalytics() {
        
        let app = XCUIApplication()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["[Demo] PXLGridView -> PXLPhotoProductView"].tap()
        
        //elementsQuery.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.tap()
        
        let format = "label CONTAINS[c] %@"

        XCTAssertTrue(app.staticTexts.containing(NSPredicate(format: format, "openedWidget")).count>0)
        XCTAssertTrue(app.staticTexts.containing(NSPredicate(format: format, "widgetVisible")).count>0)

        app.collectionViews.children(matching: .cell).element(boundBy: 0).buttons["PXLPhotoProductView"].tap()
        XCTAssertTrue(app.staticTexts.containing(NSPredicate(format: format, "openedLightbox")).count>0)
    }
}
