//
//  Coordinator.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import UIKit
import SwiftUI

public typealias ModelCoordinatorParam = Codable
public typealias StringCoordinatorParam = String

/// Enumerates coordinator main routes params.
public enum CoordinatorRoute {
    case model(ModelCoordinatorParam)
    case string(StringCoordinatorParam)
}

public protocol Coordinator {
    var rootViewController: UIViewController? { get set }

    func start(with route: CoordinatorRoute?)
    func coordinate(to coordinator: Coordinator, with route: CoordinatorRoute?)
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

    public func start(with route: CoordinatorRoute? = nil) {
        start(with: route)
    }

    public func coordinate(to coordinator: Coordinator, with route: CoordinatorRoute? = nil) {
        coordinator.start(with: route)
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

final class AppHostingController<Content>: UIHostingController<AnyView> where Content: View {

    public init(rootView: Content, imagePresenter: ImagePresentable) {
        let viewWithEnv = rootView
            .environmentObject(SUIImagePresenter(presenter: imagePresenter))
        super.init(rootView: AnyView(viewWithEnv))
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
