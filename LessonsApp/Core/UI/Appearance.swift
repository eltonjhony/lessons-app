//
//  Appearance.swift
//  LessonsApp
//
//  Created by Elton Jhony on 03/03/23.
//

import Foundation
import UIKit

public enum Appearance {
    public static func apply() {
        UINavigationBar.appearance().apply()
    }
}

private extension UINavigationBar {
    func apply() {
        tintColor = .label
    }
}
