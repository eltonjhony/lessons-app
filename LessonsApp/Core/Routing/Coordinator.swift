//
//  Coordinator.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import UIKit
import SwiftUI

public protocol Coordinator: AnyObject {
    var rootViewController: UIViewController? { get set }

    func start()
    func push(_ viewController: UIViewController, animated: Bool)
    func present(_ viewController: UIViewController, animated: Bool)
    func dismiss(_ animated: Bool)
    func popToRootView()
}

extension Coordinator {

    private var rootVC: UIViewController? {
        rootViewController ?? UIApplication.shared.firstKeyWindow?.rootViewController
    }

    // MARK: - Action Methods

    public func start() {
        start()
    }

    public func push(_ viewController: UIViewController, animated: Bool = true) {
        guard let navigationController = rootVC as? UINavigationController else {
            preconditionFailure("The rootViewController must be a UINavigationController. \(self)")
        }
        navigationController.pushViewController(viewController, animated: animated)
    }

    public func present(_ viewController: UIViewController, animated: Bool = true) {
        guard rootVC != nil else {
            preconditionFailure("The rootViewController can't be nil. \(self)")
        }
        rootVC?.present(viewController, animated: animated)
    }

    public func dismiss(_ animated: Bool = true) {
        rootVC?.dismiss(animated: animated)
    }

    public func popToRootView() {
        rootVC?.popToRootViewController()
    }
}
