//
//  LessonsBehaviours.swift
//  LessonsAppUITests
//
//  Created by Elton Jhony on 04/03/23.
//

import Foundation
import XCTest

protocol LessonsBehaviours: GeneralBehaviours {}

extension LessonsBehaviours {
    func theUserIsOnTheLessonsView(app: XCUIApplication) -> Bool {
        app.scrollViews[Accessibility.Views.lessonsIdentifier].waitUntilExists().exists
    }

    func theUserSeesTheTitle(_ title: String) -> AppPredicate {
        retryUntilSuccess { app in
            app.staticTexts[title].exists
        }
    }

    func theLessonTitleIs(_ title: String, id: Int) -> AppPredicate {
        { app in
            let elem = app.staticTexts["\(Accessibility.Views.lessonCellIdentifier)\(id)"]
            return elem.label == title
        }
    }

    func theUserTapsTheFirstLessonCell(app: XCUIApplication) {
        app.staticTexts["\(Accessibility.Views.lessonCellIdentifier)\(950)"].firstMatch.tap()
    }

    func theUserTapsTheLastLessonCell(app: XCUIApplication) {
        app.staticTexts["\(Accessibility.Views.lessonCellIdentifier)\(5630)"].firstMatch.tap()
    }

    func theUserCanSeeDetailsScreen(app: XCUIApplication) -> Bool {
        app.otherElements[Accessibility.Views.lessonDetailsViewIdentifier].waitUntilExists().exists
    }
}
