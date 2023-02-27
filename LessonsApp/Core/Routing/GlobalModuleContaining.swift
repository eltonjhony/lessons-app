//
//  GlobalModuleContaining.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation

public protocol GlobalModuleContaining {
    var services: ServiceRegistryProtocol { get }
}

public struct GlobalFeatureModule: GlobalModuleContaining {

    public let services: ServiceRegistryProtocol

    public init(services: ServiceRegistryProtocol) {
        self.services = services
    }
}
