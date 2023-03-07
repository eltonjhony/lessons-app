//
//  LessonsPresenterTests.swift
//  LessonsAppTests
//
//  Created by Elton Jhony on 06/03/23.
//

import XCTest
import Nimble
import Combine

@testable import LessonsApp

final class LessonsPresenterTests: XCTestCase {

    private let interactorMock = LessonInteractorMock()
    private let routerMock = MainRoutableMock()

    private var presenter: LessonsPresenter!

    private var cancellables = [AnyCancellable]()

    override func setUp() {
        super.setUp()
        presenter = LessonsPresenter(
            interactor: interactorMock,
            router: routerMock
        )
    }

    func test_onAppear_shouldFetchLessons() {
        // Arrange
        let models: [LessonModel] = [
            .mock(with: 950),
            .mock(with: 323),
            .mock(with: 112)
        ]
        interactorMock.models = models

        // Act
        presenter.onAppear()

        let data: LessonsData = .success(models)

        // Observe
        expect(self.interactorMock.fetchCalled).toEventually(beTrue())
        expect(self.presenter.data).toEventually(equal(data))
    }

    func test_detailsTapped_shouldCoordinateToDetails() {

        // Act
        presenter.detailsTapped(id: 99)

        // Observe
        expect(self.routerMock.coordinateToDetailsCalled).toEventually(beTrue())
    }

}
