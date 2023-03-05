//
//  UITestsHelpers.swift
//  LessonsAppUITests
//
//  Created by Elton Jhony on 04/03/23.
//

import Foundation
import XCTest

public enum ElementVisibility {
    case fully
    case center
}

func retryUntilSuccess(timeout: TimeInterval = 5, _ condition: @escaping (XCUIApplication) -> Bool) -> AppPredicate {
    { app in
        if condition(app) {
            return true
        }
        let test = XCTestCase()
        test.continueAfterFailure = true
        let predicate = NSPredicate(block: { _, _ in
            condition(app)
        })
        let exp = test.expectation(for: predicate, evaluatedWith: nil, handler: nil)
        XCTWaiter().wait(for: [exp], timeout: timeout)
        return condition(app)
    }
}

public extension XCUIElement {

    @discardableResult
    func waitUntilExists(_ timeout: TimeInterval = 5) -> XCUIElement {
        if exists {
            return self
        }
        let test = XCTestCase()
        test.continueAfterFailure = true
        let predicate = NSPredicate(format: "exists == true")
        let exp = test.expectation(for: predicate, evaluatedWith: self, handler: nil)
        XCTWaiter().wait(for: [exp], timeout: timeout)
        return self
    }

    @discardableResult
    func waitUntilIsTappable(_ timeout: TimeInterval = 5) -> XCUIElement {
        if exists, isHittable {
            return self
        }
        let test = XCTestCase()
        test.continueAfterFailure = true
        let predicate = NSPredicate(format: "exists == true && isHittable == true")
        let exp = test.expectation(for: predicate, evaluatedWith: self, handler: nil)
        XCTWaiter().wait(for: [exp], timeout: timeout)
        return self
    }

    @discardableResult
    func waitUntilDisappears(_ timeout: TimeInterval = 5) -> XCUIElement {
        if !exists {
            return self
        }
        let test = XCTestCase()
        test.continueAfterFailure = true
        let predicate = NSPredicate(format: "exists == false")
        let exp = test.expectation(for: predicate, evaluatedWith: self, handler: nil)
        XCTWaiter().wait(for: [exp], timeout: timeout)
        return self
    }

    func tapAfterExists(_ timeout: TimeInterval = 5) {
        waitUntilExists(timeout).tap()
    }

    // TODO: MOVE-28169 - Remove workaround when upgrading to future Xcode version
    @available(iOS, deprecated: 16.1, message: "Workaround needed for Xcode 14. Please check if it's still needed.")
    func tapWorkaroundXcode14() {
        coordinate(withNormalizedOffset: .zero)
            .withOffset(CGVector(dx: frame.width * 0.5, dy: frame.height * 0.5))
            .tap()
    }

    @discardableResult
    func or(_ element: XCUIElement, _ timeout: Int = 5) -> XCUIElement {
        for _ in 1...timeout {
            if self.exists {
                return self
            }
            if element.exists {
                return element
            }
            let exists = NSPredicate(format: "exists == 1")
            let test = XCTestCase()
            test.expectation(for: exists, evaluatedWith: self, handler: nil)
            test.waitForExpectations(timeout: TimeInterval(1), handler: nil)

        }
        if exists {
            return self
        }
        if element.exists {
            return element
        }
        return self
    }

    func ifExists(_ timeout: TimeInterval = 10, _ callback: (_ element: XCUIElement) -> Void) {
        waitUntilExists(timeout)
        if exists {
            callback(self)
        }
    }

    @discardableResult
    func ifNotExist(_ timeout: TimeInterval = 10, _ callback: () -> Void) -> XCUIElement? {
        waitUntilExists(timeout)
        if !exists {
            callback()
            return nil
        }
        return self
    }

    @discardableResult
    func tapAndType(_ text: String, _ timeout: TimeInterval = 10) -> XCUIElement {
        waitUntilExists(timeout).tap()
        typeText(text)
        return self
    }

    enum Direction: Int {
        case up, down, left, right
    }

    func gentleSwipe(direction: Direction, adjustment: CGFloat = 0.5, velocity: XCUIGestureVelocity = .default) {
        let half: CGFloat = 0.5
        let pressDuration: TimeInterval = 0.05
        let endHoldDuration: TimeInterval = 0.15

        let lessThanHalf = half - adjustment
        let moreThanHalf = half + adjustment

        let center = coordinate(withNormalizedOffset: CGVector(dx: half, dy: half))
        let aboveCentre = coordinate(withNormalizedOffset: CGVector(dx: half, dy: lessThanHalf))
        let belowCentre = coordinate(withNormalizedOffset: CGVector(dx: half, dy: moreThanHalf))
        let leftOfCentre = coordinate(withNormalizedOffset: CGVector(dx: lessThanHalf, dy: half))
        let rightOfCentre = coordinate(withNormalizedOffset: CGVector(dx: moreThanHalf, dy: half))

        switch direction {
        case .up:
            center.press(forDuration: pressDuration, thenDragTo: aboveCentre, withVelocity: velocity, thenHoldForDuration: endHoldDuration)
        case .down:
            center.press(forDuration: pressDuration, thenDragTo: belowCentre, withVelocity: velocity, thenHoldForDuration: endHoldDuration)
        case .left:
            center.press(forDuration: pressDuration, thenDragTo: leftOfCentre, withVelocity: velocity, thenHoldForDuration: endHoldDuration)
        case .right:
            center.press(forDuration: pressDuration, thenDragTo: rightOfCentre, withVelocity: velocity, thenHoldForDuration: endHoldDuration)
        }
    }

    func scrollUpUntilVisible(element: XCUIElement, visibility: ElementVisibility = .center) {
        scrollUntilVisible(element: element, visibility: visibility, direction: .down)
    }

    func scrollDownUntilVisible(element: XCUIElement, visibility: ElementVisibility = .center) {
        scrollUntilVisible(element: element, visibility: visibility, direction: .up)
    }

    func scrollUntilVisible(element: XCUIElement, visibility: ElementVisibility = .center, direction: Direction) {
        var tries = 15

        while !(visibility == .fully ? element.firstMatch.isVisible : element.firstMatch.isCenterVisible), tries > 0 {
            tries -= 1
            gentleSwipe(direction: direction)
        }
        scrollToCenterElement(element: element.firstMatch)
    }

    func scrollToCenterElement(element: XCUIElement) {
        let containerHeight = frame.height
        let containerCenter = frame.midY
        let elemY = element.frame.midY
        let diffY = Float((elemY - containerCenter) / containerHeight) + 0.15
        if diffY > 0.1 {
            gentleSwipe(direction: .up, adjustment: CGFloat(diffY), velocity: .slow)
        } else if diffY < -0.1 {
            gentleSwipe(direction: .down, adjustment: CGFloat(-diffY), velocity: .slow)
        }
    }

    var isVisible: Bool {
        exists && !frame.isEmpty && XCUIApplication().windows.element(boundBy: 0).frame.contains(frame)
    }

    var isCenterVisible: Bool {
        exists && !frame.isEmpty && XCUIApplication().windows.element(boundBy: 0).frame.contains(CGPoint(x: frame.midX, y: frame.midY))
    }
}

public extension XCUIApplication {

    func scrollToTop() {
        let statusbar = statusBars.element
        if statusbar.waitUntilExists(2).exists {
            statusbar.tap()
        } else {
            coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.02)).tap()
        }
    }
}
