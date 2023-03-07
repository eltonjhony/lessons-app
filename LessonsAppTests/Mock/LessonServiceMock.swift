//
//  LessonServiceMock.swift
//  LessonsAppTests
//
//  Created by Elton Jhony on 06/03/23.
//

import Foundation
import Combine

@testable import LessonsApp

public final class LessonServiceMock: LessonServiceProtocol {

    var models: [LessonModel] = []
    var error: NetworkError? = nil
    var fetchCalled: Bool = false

    public func fetchAllLessons() -> AnyPublisher<[LessonModel], Error> {
        return Just(models)
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

}
