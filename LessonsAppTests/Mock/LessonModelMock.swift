//
//  LessonModelMock.swift
//  LessonsAppTests
//
//  Created by Elton Jhony on 06/03/23.
//

import Foundation

@testable import LessonsApp

extension LessonModel {

    static func mock(with id: Int) -> LessonModel {
        .init(
            id: id,
            name: "The Key To Success In iPhone Photography",
            description: "",
            thumbnail: "",
            videoUrl: ""
        )
    }

}
