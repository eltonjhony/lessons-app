//
//  MainRoutable.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation
import UIKit

public protocol MainRoutable {
    func start(window: UIWindow)
}

public class MainApplicationRouter: MainRoutable {

    private let mainApplicationRouterModule: MainRouterModule

    public init(mainApplicationRouterModule: MainRouterModule) {
        self.mainApplicationRouterModule = mainApplicationRouterModule
    }

    public func start(window: UIWindow) {
        window.rootViewController = mainApplicationRouterModule.createViewController()
        window.makeKeyAndVisible()
    }
}
