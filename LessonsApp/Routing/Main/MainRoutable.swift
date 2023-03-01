//
//  MainRoutable.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation
import UIKit

public protocol MainRoutable: Coordinator {
    func start(window: UIWindow)
    func coordinateToDetails(with id: Int)
}

public class MainApplicationRouter: MainRoutable {

    public var rootViewController: UIViewController?

    private let mainApplicationRouterModule: MainRouterModule

    public init(mainApplicationRouterModule: MainRouterModule) {
        self.mainApplicationRouterModule = mainApplicationRouterModule
    }

    public func start(window: UIWindow) {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        push(mainApplicationRouterModule.createViewController(router: self))
    }

    public func coordinateToDetails(with id: Int) {
        let detailsModule = DetailsRouterModule(
            globalModule: mainApplicationRouterModule.globalModule,
            lessonId: id
        )
        let detailsRouter = DetailsRouter(detailsRouterModule: detailsModule)
        detailsRouter.rootViewController = rootViewController
        detailsRouter.start()
    }
}
