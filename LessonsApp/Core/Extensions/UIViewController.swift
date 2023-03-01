//
//  UIViewController.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation
import UIKit

extension UIViewController {

    func popToRootViewController() {
        guard let controller = self as? UINavigationController else { return }
        controller.popToRootViewController(animated: false)
    }

    func pop(animated: Bool = false) {
        guard let controller = self as? UINavigationController else { return }
        controller.popViewController(animated: animated)
    }

    /// Adds a child view controller's view to cover a subview.
    /// - Parameters:
    ///   - childController: The child controller.
    ///   - view: The subview to contain the child view controller's view.
    /// - Returns: The child view controller's view.
    @discardableResult
    func addChild(_ childController: UIViewController, toCover view: UIView) -> UIView? {
        guard view.isDescendant(of: self.view) else {
            return nil
        }
        guard let childView = childController.view else {
            return nil
        }
        addChild(childController)
        childView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(childView)
        NSLayoutConstraint.activate([
            childView.topAnchor.constraint(equalTo: view.topAnchor),
            childView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            childView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            childView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        childController.didMove(toParent: self)
        return childView
    }
}
