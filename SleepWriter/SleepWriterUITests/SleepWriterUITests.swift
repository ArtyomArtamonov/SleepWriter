//
//  SleepWriterUITests.swift
//  SleepWriterUITests
//
//  Created by Artyom Artamonov on 08.10.2021.
//  Copyright © 2021 Artyom Artamonov. All rights reserved.
//

import XCTest

class SleepWriterUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDreamWorkflow() throws {
        let app = XCUIApplication()
        app.launch()
        
        try createDream(app)
        try readDream(app)
        try deleteDream(app)
        
    }
    
    private func createDream(_ app: XCUIApplication) throws {
        let sampleTitle = "Test title"
        let sampleDescription = "Test description"
        
        let titleTextField = app.scrollViews.otherElements.textFields["Title"]
        let descriptionTextField = app.scrollViews.children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element
        
        titleTextField.tap()
        titleTextField.typeText(sampleTitle)
        
        descriptionTextField.tap()
        descriptionTextField.typeText(sampleDescription)
        
        
        app.buttons["Save"].tap()
        app.buttons["Save"].tap()
    }
    
    private func readDream(_ app: XCUIApplication) throws {
        let dreamTitle = "Test title"
        
        app.swipeLeft()
        
        app.scrollViews.otherElements.tables.staticTexts[dreamTitle].tap()
        XCTAssertTrue(app.staticTexts[dreamTitle].exists)
        // Asserts for information inside dream
        app.scrollViews.containing(.other, identifier:"Vertical scroll bar, 1 page").element.swipeDown(velocity: XCUIGestureVelocity.fast)
    }
    
    private func deleteDream(_ app: XCUIApplication) throws {
        let dreamTitle = "Test title"
        
        app.scrollViews.otherElements.tables.staticTexts[dreamTitle].press(forDuration: 1)
        
        app.buttons["Delete"].tap()
    }
    
//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
