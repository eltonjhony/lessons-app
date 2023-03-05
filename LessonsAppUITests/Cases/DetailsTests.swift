//
//  DetailsTests.swift
//  LessonsAppUITests
//
//  Created by Elton Jhony on 04/03/23.
//

import Foundation
import XCTest

final class DetailsTests: XCTestCase, LessonsBehaviours, DetailsBehaviours {

    private lazy var stubs: [String: String] = {
        stub(endpoint: "/test-api/lessons", with: "data")
    }()

    override func setUp() {
        super.setUp()
        XCUIDevice.shared.orientation = .portrait
        continueAfterFailure = false
    }

    func testDetails() {
        let testCase = UITestCase()
            .launchApp(withStubs: stubs)
            .given(theUserIsOnTheLessonsView)
            .and(theUserTapsTheFirstLessonCell)

        testCase
            .when(theUserCanSeeDetailsScreen)
            .then(theLessonTitleIs("The Key To Success In iPhone Photography"))
            .and(theLessonDescriptionExists())
            .and(theThumbnailImageExists())
            .and(theElementExists(withText: "Download"))
            .and(theElementExists(withText: "Next lesson"))

        testCase
            .and(theUserTapsNextLesson)
            .when(theUserCanSeeDetailsScreen)
            .then(theLessonTitleIs("How To Choose The Correct iPhone Camera Lens"))

        testCase
            .and(theUserTapsTheDownloadButton)
            .when(alertViewWithButtonsIsShown("Cancel"))
            .and(theUserCancelDownload(after: 5))
            .then(theVideoDownloadIsTerminated())

        testCase
            .and(theUserPressesTheBackButton)
            .when(theUserIsOnTheLessonsView)
            .and(theUserScrollsDown)
            .and(theUserTapsTheLastLessonCell)
            .then(theElementNotExists(withText: "Next lesson"))

        testCase
            .and(theUserPlayTheVideo)
            .when(theUserSeesTheVideoPlaying)
            .and(theUserRotatesTheDeviceToLandscape)
            .then(theVideoPlaysInFullScreen())
    }

}
