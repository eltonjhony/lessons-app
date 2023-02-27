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
}
