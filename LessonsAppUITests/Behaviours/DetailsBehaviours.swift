//
//  DetailsBehaviours.swift
//  LessonsAppUITests
//
//  Created by Elton Jhony on 04/03/23.
//

import Foundation
import XCTest

protocol DetailsBehaviours: GeneralBehaviours {}

extension DetailsBehaviours {
    
    func theLessonTitleIs(_ title: String) -> AppPredicate {
        { app in
            let elem = app.staticTexts[Accessibility.Labels.lessonTitleIdentifier]
            return elem.label == title
        }
    }

    func theLessonDescriptionExists() -> AppPredicate {
        retryUntilSuccess { app in
            app.staticTexts[Accessibility.Labels.lessonDescriptionIdentifier].waitUntilExists().exists
        }
    }

    func theThumbnailImageExists() -> AppPredicate {
        retryUntilSuccess { app in
            app.images[Accessibility.Images.thumbnailImageIdentifier].waitUntilExists().exists
        }
    }

    func theUserTapsNextLesson(app: XCUIApplication) {
        app.buttons[Accessibility.Buttons.nextLessonButtonIdentifier].tap()
    }
    
    func theUserTapsTheDownloadButton(app: XCUIApplication) {
        app.buttons["Download"].tap()
    }

    func theUserCancelDownload(after seconds: TimeInterval) -> AppClosure {
        { app in
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                app.alerts.buttons["Cancel"].waitUntilExists().tap()
            }
        }
    }

    func theVideoDownloadIsTerminated() -> AppPredicate {
        retryUntilSuccess(timeout: .init(Int.max)) { app in
            !app.alerts.buttons["Cancel"].isVisible
        }
    }

    func theUserPlayTheVideo(app: XCUIApplication) {
        app.otherElements[Accessibility.Views.thumbPlayerViewIdentifier].tap()
    }

    func theUserSeesTheVideoPlaying(app: XCUIApplication) -> Bool {
        app.otherElements["Video"].waitUntilExists().isVisible
    }

    func theUserRotatesTheDeviceToLandscape(app: XCUIApplication) {
        XCUIDevice.shared.orientation = .landscapeRight
    }

    func theVideoPlaysInFullScreen() -> AppPredicate {
        retryUntilSuccess { app in
            app.otherElements["Video"].firstMatch.frame.height == app.windows.firstMatch.frame.height
        }
    }

}
