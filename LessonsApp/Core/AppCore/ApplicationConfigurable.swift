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
}

public struct AppConfiguration: ApplicationConfigurable {
    public let webServiceConfigurable: WebServiceConfigurable
    public let endpointResources: APIEndpointResourcesProtocol

    public init() {
        webServiceConfigurable = WebServiceConfigurator()
        endpointResources = APIEndpointResources()
    }
}
