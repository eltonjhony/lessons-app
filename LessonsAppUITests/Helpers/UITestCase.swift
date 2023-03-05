//
//  UITestCase.swift
//  LessonsAppUITests
//
//  Created by Elton Jhony on 04/03/23.
//

import Foundation
import XCTest

class UITestCase {
    private var app: XCUIApplication

    init() {
        app = XCUIApplication()
        app.launchEnvironment[ProcessInfo.Environment.uiTestsAreRunning.rawValue] = "true"
    }

    func launchApp(withStubs: [String: String] = [:]) -> BaseUITestCase.GivenUITestCase {
        for stub in withStubs {
            app.launchEnvironment[stub.key] = stub.value
        }
        app.launch()
        return BaseUITestCase.GivenUITestCase(app: app)
    }
}

class BaseUITestCase {
    private let app: XCUIApplication

    var debugDescription: String {
        app.debugDescription
    }

    init(app: XCUIApplication = XCUIApplication()) {
        self.app = app
    }

    class GivenUITestCase: BaseUITestCase {
        func given(_ predicate: AppPredicate, function: String = #function, file: StaticString = #file, line: UInt = #line) -> WhenUITestCase {
            XCTAssertTrue(predicate(app), function, file: file, line: line)
            return WhenUITestCase(app: app, file: file, line: line)
        }
    }

    class WhenUITestCase: BaseUITestCase {
        let file: StaticString
        let line: UInt

        init(app: XCUIApplication, file: StaticString = #file, line: UInt = #line) {
            self.file = file
            self.line = line
            super.init(app: app)
        }

        @discardableResult
        func and(_ function: AppClosure) -> WhenUITestCase {
            function(app)
            return self
        }

        @discardableResult
        func when(_ predicate: AppPredicate, function: String = #function, file: StaticString = #file, line: UInt = #line) -> ThenUITestCase {
            XCTAssertTrue(predicate(app), function, file: file, line: line)
            return ThenUITestCase(app: app)
        }
    }

    class ThenUITestCase: BaseUITestCase {
        @discardableResult
        func and(_ function: AppClosure) -> ThenUITestCase {
            function(app)
            return self
        }

        @discardableResult
        func then(_ predicate: AppPredicate, function: String = #function, file: StaticString = #file, line: UInt = #line) -> AndThenUITestCase {
            XCTAssertTrue(predicate(app), function, file: file, line: line)
            return AndThenUITestCase(app: app)
        }
    }

    class AndThenUITestCase: BaseUITestCase {

        @discardableResult
        func and(_ predicate: AppPredicate, function: String = #function, file: StaticString = #file, line: UInt = #line) -> AndThenUITestCase {
            XCTAssertTrue(predicate(app), function, file: file, line: line)
            return self
        }
    }
}
