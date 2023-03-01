//
//  ApplicationConfigurable.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation

public protocol ApplicationConfigurable {
    var webServiceConfigurable: WebServiceConfigurable { get }
    var endpointResources: APIEndpointResourcesProtocol { get }
    var dbConfigurable: DBManagerProtocol { get }
}

public struct AppConfiguration: ApplicationConfigurable {
    public let webServiceConfigurable: WebServiceConfigurable
    public let endpointResources: APIEndpointResourcesProtocol
    public let dbConfigurable: DBManagerProtocol

    public init() {
        webServiceConfigurable = WebServiceConfigurator()
        endpointResources = APIEndpointResources()
        dbConfigurable = RealmDBManager(RealmProvider.default)
    }
}
