//
//  LessonItemResponse.swift
//  LessonsApp
//
//  Created by Elton Jhony on 01/03/23.
//

import Foundation

/// This is the protocol that all Models must inherit from.
public protocol ModelProtocol: Hashable, Codable {
    // Intentionally not implemented
}

public struct LessonItemResponse: ModelProtocol {
    let id: Int
    let name: String
    let description: String
    let thumbnail: String
    let videoUrl: String
}

extension LessonModel: MappableProtocol {
    func mapToPersistenceObject() -> LessonEntity {
        let entity = LessonEntity()
        entity.id = id
        entity.name = name
        entity.desc = description
        entity.thumbnail = thumbnail
        entity.videoUrl = videoUrl
        return entity
    }

    static func mapFromPersistenceObject(_ object: LessonEntity) -> LessonModel {
        LessonModel(
            id: object.id,
            name: object.name,
            description: object.desc,
            thumbnail: object.thumbnail,
            videoUrl: object.videoUrl
        )
    }
}

