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

    private var cancellables = [AnyCancellable]()

    public var lessonIds: [Int] = []

    public init(service: LessonServiceProtocol, storage: LessonLocalStorable) {
        self.service = service
        self.storage = storage
    }

    public func fetchAll() -> AnyPublisher<[LessonModel], Error> {
        let cachedPublisher = storage.getAll()
        return service.fetchAllLessons()
            .handleEvents(receiveOutput: { [weak self] in
                $0.forEach {
                    self?.storage.update(with: $0)
                }
            })
            .tryCatch { error in
                guard case .connectionError = error.networkError else { throw error }
                return cachedPublisher
                    .tryMap {
                        if $0.isEmpty {
                            throw error
                        }
                        return $0
                    }
            }
            .handleEvents(receiveOutput: { [weak self] in
                self?.lessonIds.append(contentsOf: $0.map { $0.id })
            })
            .eraseToAnyPublisher()
    }

    public func getById(_ id: Int) -> AnyPublisher<LessonModel?, Error> {
        storage.getById(id)
    }

    public func update(with lesson: LessonModel) {
        storage.update(with: lesson)
    }
}
