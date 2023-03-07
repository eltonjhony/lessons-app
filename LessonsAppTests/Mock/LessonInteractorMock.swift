//
//  LessonInteractorMock.swift
//  LessonsAppTests
//
//  Created by Elton Jhony on 06/03/23.
//

import Foundation
import Combine

@testable import LessonsApp

public final class LessonInteractorMock: LessonInteractable {
    public var lessonsData: AnyPublisher<LessonsData, Never> {
        lessonsDataSubject.eraseToAnyPublisher()
    }
    public var lessonsDataSubject: CurrentValueSubject<LessonsData, Never> = .init(.idle)

    public var detailsData: AnyPublisher<LessonModel?, Never> {
        detailsDataSubject.eraseToAnyPublisher()
    }
    public var detailsDataSubject: CurrentValueSubject<LessonModel?, Never> = .init(nil)

    public var nextLessonAvailable: AnyPublisher<Bool, Never> {
        nextLessonAvailableSubject.eraseToAnyPublisher()
    }
    public var nextLessonAvailableSubject: PassthroughSubject<Bool, Never> = .init()

    var models: [LessonModel] = []
    var error: NetworkError? = nil
    var fetchCalled: Bool = false

    var getByIdCalled: Bool = false
    var getNextLessonCalled: Bool = false

    public func fetchLessons() {
        fetchCalled = true
        if error != nil {
            lessonsDataSubject.send(.error)
        } else {
            lessonsDataSubject.send(.success(models))
        }
    }

    public func getById(_ id: Int) {
        getByIdCalled = true
        let model = models.first { $0.id == id }
        detailsDataSubject.send(model)
        if let model = model {
            let ids = models.map { $0.id }
            nextLessonAvailableSubject.send(ids.after(model.id) != nil)
        } else {
            nextLessonAvailableSubject.send(false)
        }
    }

    public func getNextLesson(_ id: Int) {
        getNextLessonCalled = true
        getById(id)
    }

}
