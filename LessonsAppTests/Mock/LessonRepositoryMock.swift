//
//  LessonRepositoryMock.swift
//  LessonsAppTests
//
//  Created by Elton Jhony on 06/03/23.
//

import Foundation
import Combine

@testable import LessonsApp

public final class LessonRepositoryMock: LessonRepositoryProtocol {

    public var lessonIds: [Int] {
        models.map { $0.id }
    }

    var models: [LessonModel] = []
    var error: NetworkError? = nil
    var fetchCalled: Bool = false

    var getByIdCalled: Bool = false

    var updatedModels: [LessonModel] = []
    var updateCalled: Bool = false

    public func fetchAll() -> AnyPublisher<[LessonModel], Error> {
        Just(models)
            .tryMap { models in
                if let error = error {
                    throw error
                }
                return models
            }
            .handleEvents(receiveSubscription: { _ in
                self.fetchCalled = true
            })
            .eraseToAnyPublisher()
    }

    public func getById(_ id: Int) -> AnyPublisher<LessonModel?, Error> {
        Just(models.first { $0.id == id })
            .tryMap { model in
                if let error = error {
                    throw error
                }
                return model
            }
            .handleEvents(receiveSubscription: { _ in
                self.getByIdCalled = true
            })
            .eraseToAnyPublisher()
    }

    public func update(with lesson: LessonModel) {
        updateCalled = true
        updatedModels.append(lesson)
    }

}
