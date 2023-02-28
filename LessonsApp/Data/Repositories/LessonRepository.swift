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

    public init(service: LessonServiceProtocol) {
        self.service = service
    }

    public func fetchAll() -> AnyPublisher<[LessonModel], Error> {
        service.fetchAllLessons()
    }
}
