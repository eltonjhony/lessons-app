//
//  LessonLocalStorageTests.swift
//  LessonsAppTests
//
//  Created by Elton Jhony on 06/03/23.
//

import XCTest
import Nimble
import Combine

@testable import LessonsApp

final class LessonLocalStorageTests: XCTestCase {

    private let dbMock = DBManagerMock()
    private var provider: LessonLocalStorable?

    private var cancellables = [AnyCancellable]()

    override func setUp() {
        super.setUp()
        provider = LessonLocalStorage(dbManager: dbMock)
    }

    func test_fetchAllLessons_shouldReturnIt() {
        // Arrange
        let entity = LessonEntity()
        entity.id = 950
        entity.name = "The Key To Success In iPhone Photography"
        dbMock.entities = [
            entity
        ]

        // Act
        waitUntil { action in
            self.provider?.getAll()
                .sink(receiveCompletion: { completion in
                    guard case .finished = completion else {
                        fail("Test should not fail")
                        return
                    }
                    action()
                }, receiveValue: { models in
                    expect(models.isEmpty).to(beFalse())
                    expect(models.first?.id).to(equal(950))
                    expect(models.first?.name).to(equal("The Key To Success In iPhone Photography"))
                }).store(in: &self.cancellables)
        }
    }

    func test_updateLesson_shouldCallDb() {
        // Arrange
        let model = LessonModel(
            id: 950,
            name: "The Key To Success In iPhone Photography",
            description: "",
            thumbnail: "",
            videoUrl: ""
        )

        // Act
        provider?.update(with: model)

        // Assert
        expect(self.dbMock.updateCalled).toEventually(beTrue(), timeout: .seconds(3))
        expect(self.dbMock.updatedEntity).toEventuallyNot(beNil(), timeout: .seconds(3))
    }

}

