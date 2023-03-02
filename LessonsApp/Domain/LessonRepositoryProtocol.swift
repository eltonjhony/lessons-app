//
//  LessonRepositoryProtocol.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation
import Combine

public protocol LessonRepositoryProtocol {
    func fetchAll() -> AnyPublisher<[LessonModel], Error>
    func getById(_ id: Int) -> AnyPublisher<LessonModel?, Error>
    func update(with lesson: LessonModel)
}
