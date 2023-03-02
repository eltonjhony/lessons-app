//
//  LessonModel.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation

public struct LessonModel: Equatable {
    let id: Int
    let name: String
    let description: String
    let thumbnail: String
    let videoUrl: String
    var localVideoUrl: String?
}
