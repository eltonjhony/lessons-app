//
//  LessonServiceTest.swift
//  LessonsAppTests
//
//  Created by Elton Jhony on 06/03/23.
//

import XCTest
import Nimble
import Combine

@testable import LessonsApp

final class LessonServiceTest: XCTestCase {

    private let requestMock = WebServiceMock()
    private var provider: LessonServiceProtocol?

    private var cancellables = [AnyCancellable]()

    override func setUp() {
        super.setUp()
        provider = LessonService(
            webService: requestMock,
            endpoint: APIEndpointResources()
        )
    }

    func test_fetchAllLessons_shouldReturnIt() {
        // Arrange
        requestMock.data = lessonsData

        // Act
        waitUntil { action in
            self.provider?.fetchAllLessons()
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

}
