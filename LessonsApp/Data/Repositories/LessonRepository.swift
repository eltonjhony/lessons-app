//
//  LessonRepository.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation
import Combine

public final class LessonRepository: LessonRepositoryProtocol {
    private let service: LessonServiceProtocol
    private let storage: LessonLocalStorable

    public init(service: LessonServiceProtocol, storage: LessonLocalStorable) {
        self.service = service
        self.storage = storage
    }

    public func fetchAll() -> AnyPublisher<[LessonModel], Error> {
        let cachedPublisher = storage.getAll()
        return service.fetchAllLessons()
            .handleEvents(receiveOutput: { [weak self] lessons in
                lessons.forEach { lesson in
                    self?.storage.update(with: lesson)
                }
            })
            .tryCatch { error in
                guard case .connectionError = error.networkError else { throw error }
                return cachedPublisher
            }
            .eraseToAnyPublisher()
    }
}
