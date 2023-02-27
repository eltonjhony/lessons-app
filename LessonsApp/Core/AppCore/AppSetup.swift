//
//  AppSetup.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation
import UIKit

final class AppSetup {

    private let serviceRegistry: ServiceRegistryProtocol

    private let mainApplicationRouterModule: MainRouterModule
    private let applicationRouter: MainRoutable

    public init() {
        let servicesFactory = ServicesFactory()
        serviceRegistry = ServiceRegistry(servicesFactory: servicesFactory)

        let globalModule = GlobalFeatureModule(services: serviceRegistry)
        mainApplicationRouterModule = MainRouterModule(globalModule: globalModule)
        applicationRouter = MainApplicationRouter(mainApplicationRouterModule: mainApplicationRouterModule)
    }

    public func bootApp(window: UIWindow) {
        applicationRouter.start(window: window)
    }
}
