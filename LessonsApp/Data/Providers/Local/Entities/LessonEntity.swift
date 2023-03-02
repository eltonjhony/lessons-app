//
//  LessonEntity.swift
//  LessonsApp
//
//  Created by Elton Jhony on 28/02/23.
//

import Foundation
import RealmSwift

public final class LessonEntity: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var desc: String
    @Persisted var thumbnail: String
    @Persisted var videoUrl: String
    @Persisted var localVideoUrl: String?
}
