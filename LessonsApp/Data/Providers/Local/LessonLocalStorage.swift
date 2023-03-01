//
//  LessonLocalStorage.swift
//  LessonsApp
//
//  Created by Elton Jhony on 28/02/23.
//

import Foundation
import Combine

public protocol LessonLocalStorable {
    func getAll() -> AnyPublisher<[LessonModel], Error>
    func getById(_ id: Int) -> AnyPublisher<LessonModel?, Error>
    func update(with lesson: LessonModel)
}

final class LessonLocalStorage: LessonLocalStorable {
    private let dbManager: DBManagerProtocol

    init(dbManager: DBManagerProtocol) {
        self.dbManager = dbManager
    }

    func getAll() -> AnyPublisher<[LessonModel], Error> {
        dbManager.fetch(LessonEntity.self, predicate: nil, sorted: nil)
            .map {
                $0.map { entity in
                    LessonModel.mapFromPersistenceObject(entity)
                }
            }
            .eraseToAnyPublisher()
    }

    func getById(_ id: Int) -> AnyPublisher<LessonModel?, Error> {
        dbManager.fetch(LessonEntity.self, predicate: NSPredicate(format: "id == %d", id), sorted: nil)
            .map {
                $0.map { entity in
                    LessonModel.mapFromPersistenceObject(entity)
                }.first
            }
            .eraseToAnyPublisher()
    }

    func update(with lesson: LessonModel) {
        let entity = lesson.mapToPersistenceObject()
        do {
            try dbManager.update(object: entity)
        } catch {
            print(error.localizedDescription)
        }
    }
}
