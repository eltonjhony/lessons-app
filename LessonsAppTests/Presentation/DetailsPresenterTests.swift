//
//  DetailsPresenterTests.swift
//  LessonsAppTests
//
//  Created by Elton Jhony on 06/03/23.
//

import XCTest
import Nimble
import Combine

@testable import LessonsApp

final class DetailsPresenterTests: XCTestCase {

    private let interactorMock = LessonInteractorMock()
    private let downloadInteractorMock = DownloadInteractorMock()

    private var presenter: DetailsPresenter!

    private var cancellables = [AnyCancellable]()

    override func setUp() {
        super.setUp()
        presenter = DetailsPresenter(
            lessonId: 950,
            interactor: interactorMock,
            downloadInteractor: downloadInteractorMock
        )
    }

    func test_onAppear_shouldLoadTheData() {
        // Arrange
        let models: [LessonModel] = [
            .mock(with: 950),
            .mock(with: 323),
            .mock(with: 112)
        ]
        interactorMock.models = models

        // Act
        presenter.onAppear()

        // Observer
        var detailsModel: DetailsViewModel?
        presenter.data.sink { model in
            detailsModel = model
        }.store(in: &cancellables)

        // Observe
        expect(self.interactorMock.getByIdCalled).toEventually(beTrue())
        expect(detailsModel?.id).toEventually(equal(950))
        expect(detailsModel?.nextLessonAction).toEventuallyNot(beNil())
    }

    func test_onAppear_shouldLoadDownloadOption() {
        // Arrange
        let models: [LessonModel] = [
            .mock(with: 950),
            .mock(with: 323),
            .mock(with: 112)
        ]
        interactorMock.models = models

        // Observer
        var navOptions: [ButtonModel] = []
        presenter.rightBarButtons?.sink { model in
            navOptions = model
        }.store(in: &cancellables)

        // Act
        presenter.onAppear()

        // Observe
        expect(self.interactorMock.getByIdCalled).toEventually(beTrue())
        expect(navOptions.first?.title).toEventually(equal("Download"), timeout: .seconds(3))
    }

    func test_downloadAction_shouldStartDownloading() {
        // Arrange
        let models: [LessonModel] = [
            .mock(with: 950)
        ]
        interactorMock.models = models

        // Observer
        presenter.rightBarButtons?.sink { model in
            model.first?.action()
        }.store(in: &cancellables)

        // Act
        presenter.onAppear()

        // Observe
        expect(self.interactorMock.getByIdCalled).toEventually(beTrue())
        expect(self.downloadInteractorMock.downloadCalled).toEventually(beTrue(), timeout: .seconds(3))
    }

}
