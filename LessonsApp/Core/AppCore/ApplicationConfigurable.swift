//
//  ApplicationConfigurable.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation

public protocol ApplicationConfigurable {
    var webServiceConfigurable: WebServiceProtocol { get }
    var endpointResources: APIEndpointResourcesProtocol { get }
    var dbConfigurable: DBManagerProtocol { get }
}

public struct AppConfiguration: ApplicationConfigurable {
    public let webServiceConfigurable: WebServiceProtocol
    public let endpointResources: APIEndpointResourcesProtocol
    public let dbConfigurable: DBManagerProtocol

    public init() {
        webServiceConfigurable = WebService(configuration: WebServiceConfigurator())
        endpointResources = APIEndpointResources()
        dbConfigurable = RealmDBManager(RealmProvider.default)
    }
}

public struct UITestAppConfiguration: ApplicationConfigurable {
    public let webServiceConfigurable: WebServiceProtocol
    public let endpointResources: APIEndpointResourcesProtocol
    public let dbConfigurable: DBManagerProtocol

    public init() {
        webServiceConfigurable = FixtureWebService()
        endpointResources = APIEndpointResources()
        dbConfigurable = RealmDBManager(RealmProvider.default)
    }
}
