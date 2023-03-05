//
//  LessonsTests.swift
//  LessonsAppUITests
//
//  Created by Elton Jhony on 04/03/23.
//

import Foundation
import XCTest

final class LessonsTests: XCTestCase, LessonsBehaviours {

    private lazy var stubs: [String: String] = {
        stub(endpoint: "/test-api/lessons", with: "data")
    }()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testLessons() {
        let testCase = UITestCase()
            .launchApp(withStubs: stubs)
            .given(theUserIsOnTheLessonsView)
            .when(theUserSeesTheTitle("Lessons"))

        testCase
            .then(theLessonTitleIs("The Key To Success In iPhone Photography", id: 950))

        testCase
            .and(theUserTapsTheFirstLessonCell)
            .then(theUserCanSeeDetailsScreen)
    }

}
