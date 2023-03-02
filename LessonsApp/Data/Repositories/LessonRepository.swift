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
            .map { [weak self] lessons in
                lessons.enumerated().map { (id, item) in
                    let model: LessonModel = .init(
                        id: id,
                        name: item.name,
                        description: item.description,
                        thumbnail: item.thumbnail,
                        videoUrl: item.videoUrl)
                    self?.storage.update(with: model)
                    return model
                }
            }
            .tryCatch { error in
                guard case .connectionError = error.networkError else { throw error }
                return cachedPublisher
            }
            .eraseToAnyPublisher()
    }

    public func getById(_ id: Int) -> AnyPublisher<LessonModel?, Error> {
        storage.getById(id)
    }

    public func update(with lesson: LessonModel) {
        storage.update(with: lesson)
    }
}
