//
//  NetworkServicesModule.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation

public struct NetworkServicesModule: NetworkServicesModuleProtocol {

    public var imageService: ImageServiceProtocol

    private let webService: WebServiceProtocol

    public init(webService: WebServiceProtocol) {
        self.webService = webService

        imageService = ImageService(webService: webService)
    }
}
