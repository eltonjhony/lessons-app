//
//  ServiceRegistryProtocol.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation

public protocol ServiceRegistryProtocol {
    var imageRepository: ImageRepositoryProtocol { get }
    var lessonRepository: LessonRepositoryProtocol { get }
}

public class ServiceRegistry: ServiceRegistryProtocol {

    public var imageRepository: ImageRepositoryProtocol
    public var lessonRepository: LessonRepositoryProtocol

    private let servicesFactory: ServicesFactoryProtocol

    public init(servicesFactory: ServicesFactoryProtocol) {
        self.servicesFactory = servicesFactory

        imageRepository = ImageRepository(
            service: servicesFactory.networkServices.imageService
        )

        lessonRepository = LessonRepository(
            service: servicesFactory.networkServices.lessonService
        )
    }
}
