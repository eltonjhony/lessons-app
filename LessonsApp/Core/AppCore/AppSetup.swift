//
//  AppSetup.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation
import UIKit

final class AppSetup: NSObject {

    private let serviceRegistry: ServiceRegistryProtocol

    private let mainApplicationRouterModule: MainRouterModule
    private let applicationRouter: MainRoutable

    public override init() {
        let applicationConfiguration = AppConfiguration()
        let servicesFactory = ServicesFactory(applicationConfigurable: applicationConfiguration)
        serviceRegistry = ServiceRegistry(servicesFactory: servicesFactory)

        let globalModule = GlobalFeatureModule(services: serviceRegistry)
        mainApplicationRouterModule = MainRouterModule(globalModule: globalModule)
        applicationRouter = MainApplicationRouter(mainApplicationRouterModule: mainApplicationRouterModule)

        let navigationController = UINavigationController()
        applicationRouter.rootViewController = navigationController
        super.init()
        navigationController.delegate = self
    }

    public func bootApp(window: UIWindow) {
        applicationRouter.start(window: window)
        Appearance.apply()
    }
}

extension AppSetup: UINavigationControllerDelegate {

    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        navigationController.topViewController?.supportedInterfaceOrientations ?? .portrait
    }

}
