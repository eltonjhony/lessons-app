//
//  GeneralBehaviours.swift
//  LessonsAppUITests
//
//  Created by Elton Jhony on 04/03/23.
//

import XCTest

typealias AppClosure = (XCUIApplication) -> Void
typealias AppPredicate = (XCUIApplication) -> Bool

protocol GeneralBehaviours {}

extension GeneralBehaviours {

    func alertViewWithButtonsIsShown(_ buttons: String...) -> AppPredicate {
        { app in
            let alert = app.alerts
            for button in buttons {
                if !alert.buttons[button].waitUntilExists().exists {
                    return false
                }
            }
            return true
        }
    }

    func theUserTapsAlertViewButton(_ button: String) -> AppClosure {
        { app in
            app.alerts.buttons[button].tap()
        }
    }

    func theUserScrollsAllTheWayUp(app: XCUIApplication) {
        app.scrollToTop()
    }

    func theUserScrollsUp(app: XCUIApplication) {
        app.swipeDown()
    }

    func theUserScrollsDown(app: XCUIApplication) {
        app.swipeUp()
    }

    func theUserPressesTheBackButton(app: XCUIApplication) {
        app.navigationBars.buttons.firstMatch.waitUntilExists().tap()
    }

    func theNavigationBarTitleIs(_ title: String) -> AppPredicate {
        { app in
            app.navigationBars.element.waitUntilExists().identifier == title
        }
    }

    func theUserTapsOnButton(_ text: String) -> AppClosure {
        { app in
            app.buttons[text].waitUntilExists().tap()
        }
    }

    func element(by id: String, app: XCUIApplication) -> XCUIElement {
        app.descendants(matching: .any)[id].firstMatch
    }

    func theElementExists(withText: String) -> AppPredicate {
        retryUntilSuccess { app in
            app.staticTexts[withText].waitUntilExists().exists
        }
    }

    func theElementNotExists(withText: String) -> AppPredicate {
        retryUntilSuccess { app in
            !app.staticTexts[withText].waitUntilExists().exists
        }
    }

}
