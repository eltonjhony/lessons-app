//
//  ServiceFactory.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation

public protocol NetworkServicesModuleProtocol {
    var imageService: ImageServiceProtocol { get }
}

public protocol PersistenceModuleProtocol {

}

public protocol ServicesFactoryProtocol {
    var networkServices: NetworkServicesModuleProtocol { get }
    var persistenceServices: PersistenceModuleProtocol { get }
}

public struct ServicesFactory: ServicesFactoryProtocol {
    public let networkServices: NetworkServicesModuleProtocol
    public let persistenceServices: PersistenceModuleProtocol

    private let webService: WebService = .init(configuration: WebServiceConfigurator())

    public init() {
        networkServices = NetworkServicesModule(webService: webService)
        persistenceServices = PersistenceServicesModule()
    }
}
