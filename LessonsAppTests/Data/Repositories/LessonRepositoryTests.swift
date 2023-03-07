//
//  LessonRepositoryTests.swift
//  LessonsAppTests
//
//  Created by Elton Jhony on 06/03/23.
//

import XCTest
import Nimble
import Combine

@testable import LessonsApp

final class LessonRepositoryTests: XCTestCase {

    private let serviceMock = LessonServiceMock()
    private let storageMock = LessonStorageMock()

    private var repository: LessonRepositoryProtocol?

    private var cancellables = [AnyCancellable]()

    override func setUp() {
        super.setUp()
        repository = LessonRepository(
            service: serviceMock,
            storage: storageMock
        )
    }

    func test_fetchAll_whenRemoteReturnsSuccess_shouldCacheIt() {
        // Arrange
        serviceMock.models = [
            .mock(with: 950),
            .mock(with: 323),
            .mock(with: 112)
        ]

        // Act
        waitUntil { action in
            self.repository?.fetchAll()
                .sink(receiveCompletion: { completion in
                    guard case .finished = completion else {
                        fail("Test should not fail")
                        return
                    }
                    action()
                }, receiveValue: { models in
                    // Assert
                    expect(self.serviceMock.fetchCalled).to(beTrue())
                    expect(self.storageMock.updateCalled).to(beTrue())

                    expect(models.isEmpty).to(beFalse())
                    expect(models.count).to(equal(3))

                    expect(models.first?.id).to(equal(950))
                    expect(models[1].id).to(equal(323))
                    expect(models[2].id).to(equal(112))

                    expect(self.storageMock.updatedModels.first?.id).to(equal(950))
                    expect(self.storageMock.updatedModels[1].id).to(equal(323))
                    expect(self.storageMock.updatedModels[2].id).to(equal(112))

                    expect(self.repository?.lessonIds).to(equal([950, 323, 112]))

                }).store(in: &self.cancellables)
        }
    }

    func test_fetchAll_whenThereIsNetworkIssues_shouldReturnFromCache() {
        // Arrange
        storageMock.models = [
            .mock(with: 950),
            .mock(with: 323),
            .mock(with: 112)
        ]
        serviceMock.error = .connectionError

        // Act
        waitUntil { action in
            self.repository?.fetchAll()
                .sink(receiveCompletion: { completion in
                    guard case .finished = completion else {
                        fail("Test should not fail")
                        return
                    }
                    action()
                }, receiveValue: { models in
                    // Assert
                    expect(self.serviceMock.fetchCalled).to(beTrue())
                    expect(self.storageMock.fetchCalled).to(beTrue())
                    expect(self.storageMock.updateCalled).to(beFalse())

                    expect(models.isEmpty).to(beFalse())
                    expect(models.count).to(equal(3))

                    expect(models.first?.id).to(equal(950))
                    expect(models[1].id).to(equal(323))
                    expect(models[2].id).to(equal(112))

                    expect(self.repository?.lessonIds).to(equal([950, 323, 112]))

                }).store(in: &self.cancellables)
        }
    }

    func test_fetchAll_whenThereIsNetworkIssueWithNoCache_shouldReturnError() {
        // Arrange
        storageMock.models = []
        serviceMock.error = .connectionError

        // Act
        waitUntil { action in
            self.repository?.fetchAll()
                .sink(receiveCompletion: { completion in
                    guard case let .failure(error) = completion else {
                        fail("Test should fail")
                        action()
                        return
                    }
                    expect(error is NetworkError).to(beTrue())
                    action()
                }, receiveValue: { _ in })
                .store(in: &self.cancellables)
        }
    }

    func test_fetchAll_whenThereIsServerIssues_shouldReturnError() {
        // Arrange
        storageMock.models = [
            .mock(with: 950),
            .mock(with: 323),
            .mock(with: 112)
        ]
        serviceMock.error = .serverError(nil)

        // Act
        waitUntil { action in
            self.repository?.fetchAll()
                .sink(receiveCompletion: { completion in
                    guard case let .failure(error) = completion else {
                        fail("Test should fail")
                        action()
                        return
                    }
                    expect(error is NetworkError).to(beTrue())
                    action()
                }, receiveValue: { _ in })
                .store(in: &self.cancellables)
        }
    }

}
