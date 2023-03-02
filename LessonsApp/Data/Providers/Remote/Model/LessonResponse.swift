//
//  LessonResponse.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation

public struct LessonResponse: Codable {
    let lessons: [LessonItemResponse]
}
