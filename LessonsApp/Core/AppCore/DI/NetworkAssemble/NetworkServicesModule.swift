//
//  NetworkServicesModule.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation

public struct NetworkServicesModule: NetworkServicesModuleProtocol {

    public var imageService: ImageServiceProtocol
    public var lessonService: LessonServiceProtocol

    private let webService: WebServiceProtocol
    private let apiEndpointResource: APIEndpointResourcesProtocol

    public init(webService: WebServiceProtocol, apiEndpointResource: APIEndpointResourcesProtocol) {
        self.webService = webService
        self.apiEndpointResource = apiEndpointResource

        imageService = ImageService(webService: webService)
        lessonService = LessonService(webService: webService, endpoint: apiEndpointResource)
    }
}
