//
//  ServiceRegistryProtocol.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation

public protocol ServiceRegistryProtocol {
    var imageRepository: ImageRepositoryProtocol { get }
}

public class ServiceRegistry: ServiceRegistryProtocol {

    public var imageRepository: ImageRepositoryProtocol

    private let servicesFactory: ServicesFactoryProtocol

    public init(servicesFactory: ServicesFactoryProtocol) {
        self.servicesFactory = servicesFactory

        imageRepository = ImageRepository(
            service: servicesFactory.networkServices.imageService
        )
    }
}
