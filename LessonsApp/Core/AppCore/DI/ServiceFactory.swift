//
//  ServiceFactory.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation

public protocol NetworkServicesModuleProtocol {
    var imageService: ImageServiceProtocol { get }
    var lessonService: LessonServiceProtocol { get }
}

public protocol PersistenceModuleProtocol {
    var lessonStorage: LessonLocalStorable { get }
}

public protocol ServicesFactoryProtocol {
    var networkServices: NetworkServicesModuleProtocol { get }
    var persistenceServices: PersistenceModuleProtocol { get }
}

public struct ServicesFactory: ServicesFactoryProtocol {
    public let networkServices: NetworkServicesModuleProtocol
    public let persistenceServices: PersistenceModuleProtocol

    private let applicationConfigurable: ApplicationConfigurable

    public init(applicationConfigurable: ApplicationConfigurable) {
        self.applicationConfigurable = applicationConfigurable

        let webService = applicationConfigurable.webServiceConfigurable
        let apiEndpointResources = applicationConfigurable.endpointResources

        let dbConfigurable = applicationConfigurable.dbConfigurable

        networkServices = NetworkServicesModule(
            webService: webService,
            apiEndpointResource: apiEndpointResources
        )
        persistenceServices = PersistenceServicesModule(dbConfigurable: dbConfigurable)
    }
}
