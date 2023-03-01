//
//  DetailsRoutable.swift
//  LessonsApp
//
//  Created by Elton Jhony on 28/02/23.
//

import Foundation
import UIKit

public protocol DetailsRoutable: Coordinator {
    func start()
}

public class DetailsRouter: DetailsRoutable {
    public var rootViewController: UIViewController?

    private let detailsRouterModule: DetailsRouterModule

    public init(detailsRouterModule: DetailsRouterModule) {
        self.detailsRouterModule = detailsRouterModule
    }

    public func start() {
        let detailsViewController = detailsRouterModule.createViewController()
        push(detailsViewController)
    }
}
