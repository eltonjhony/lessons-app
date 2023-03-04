//
//  LessonService.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation
import Combine

public struct LessonResponse: Codable {
    let lessons: [LessonModel]
}

public protocol LessonServiceProtocol {
    func fetchAllLessons() -> AnyPublisher<[LessonModel], Error>
}

final class LessonService: LessonServiceProtocol {

    private let webService: WebServiceProtocol
    private let endpoint: LessonEndpointResourceable

    init(webService: WebServiceProtocol, endpoint: LessonEndpointResourceable) {
        self.webService = webService
        self.endpoint = endpoint
    }

    func fetchAllLessons() -> AnyPublisher<[LessonModel], Error> {
        let lessonsURLRequest = URLRequest(url: endpoint.lessonsURL)
        let data: AnyPublisher<NetworkResponse<LessonResponse>, Error> = webService.get(urlRequest: lessonsURLRequest)
        return data
            .map(\.payload.lessons)
            .eraseToAnyPublisher()
    }
}
