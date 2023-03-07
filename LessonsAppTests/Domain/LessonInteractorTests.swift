//
//  LessonInteractorTests.swift
//  LessonsAppTests
//
//  Created by Elton Jhony on 06/03/23.
//

import XCTest
import Nimble
import Combine

@testable import LessonsApp

final class LessonInteractorTests: XCTestCase {

    private let repositoryMock = LessonRepositoryMock()

    private var interactor: LessonInteractable?

    private var cancellables = [AnyCancellable]()

    override func setUp() {
        super.setUp()
        interactor = LessonInteractor(
            lessonRepository: repositoryMock
        )
    }

    func test_fetchLessons_shouldReturnSuccess() {
        // Arrange
        repositoryMock.models = [
            .mock(with: 950),
            .mock(with: 323),
            .mock(with: 112)
        ]

        // Act
        interactor?.fetchLessons()

        // Observe
        var lessonData: LessonsData? = nil
        self.interactor?.lessonsData
            .sink(receiveValue: { data in
                lessonData = data
            }).store(in: &self.cancellables)

        // Assert
        expect(self.repositoryMock.fetchCalled).toEventually(beTrue(), timeout: .seconds(3))
        if case let .success(models) = lessonData {
            expect(models.isEmpty).toEventually(beFalse(), timeout: .seconds(3))
        }
    }

    func test_getById_whenThereIsNextLesson_shouldReturnIt() {
        // Arrange
        repositoryMock.models = [
            .mock(with: 950),
            .mock(with: 323),
            .mock(with: 112)
        ]

        // Observe
        var lesson: LessonModel? = nil
        var isNextLessonAvailable = false
        Publishers.CombineLatest(self.interactor!.detailsData, self.interactor!.nextLessonAvailable)
            .sink(receiveValue: { (model, nextLessonAvailable)  in
                lesson = model
                isNextLessonAvailable = nextLessonAvailable
            }).store(in: &self.cancellables)

        // Act
        interactor?.getById(950)

        // Assert
        expect(self.repositoryMock.getByIdCalled).toEventually(beTrue(), timeout: .seconds(3))
        expect(lesson).toEventuallyNot(beNil(), timeout: .seconds(3))
        expect(isNextLessonAvailable).toEventually(beTrue(), timeout: .seconds(3))
    }

    func test_getById_whenThereIsNoNextLesson_shouldReturnFalse() {
        // Arrange
        repositoryMock.models = [
            .mock(with: 950),
            .mock(with: 323),
            .mock(with: 112)
        ]

        // Observe
        var lesson: LessonModel? = nil
        var isNextLessonAvailable = false
        Publishers.CombineLatest(self.interactor!.detailsData, self.interactor!.nextLessonAvailable)
            .sink(receiveValue: { (model, nextLessonAvailable)  in
                lesson = model
                isNextLessonAvailable = nextLessonAvailable
            }).store(in: &self.cancellables)

        // Act
        interactor?.getById(112)

        // Assert
        expect(self.repositoryMock.getByIdCalled).toEventually(beTrue(), timeout: .seconds(3))
        expect(lesson).toEventuallyNot(beNil(), timeout: .seconds(3))
        expect(isNextLessonAvailable).toEventually(beFalse(), timeout: .seconds(3))
    }

    func test_getNextLesson_whenThereIsNoNextLesson_shouldNotCallIt() {
        // Arrange
        repositoryMock.models = [
            .mock(with: 950),
            .mock(with: 323),
            .mock(with: 112)
        ]

        // Act
        interactor?.getNextLesson(112)

        // Assert
        expect(self.repositoryMock.getByIdCalled).toEventually(beFalse(), timeout: .seconds(3))
    }

    func test_getNextLesson_whenThereIsNextLesson_shouldCallIt() {
        // Arrange
        repositoryMock.models = [
            .mock(with: 950),
            .mock(with: 323),
            .mock(with: 112)
        ]

        // Act
        interactor?.getNextLesson(323)

        // Assert
        expect(self.repositoryMock.getByIdCalled).toEventually(beTrue(), timeout: .seconds(3))
    }

}
