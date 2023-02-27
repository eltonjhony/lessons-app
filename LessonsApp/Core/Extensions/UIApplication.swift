//
//  UIApplication.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation
import UIKit

public extension UIApplication {
    var firstKeyWindow: UIWindow? {
        currentScene?.windows.first { $0.isKeyWindow }
    }

    var currentScene: UIWindowScene? {
        connectedScenes.first { $0.activationState == .foregroundActive } as? UIWindowScene
    }
}
