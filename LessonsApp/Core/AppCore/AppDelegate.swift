//
//  AppDelegate.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import UIKit

final class AppDelegate: UIResponder, UIApplicationDelegate {
    public var window: UIWindow?
    public var appSetup: AppSetup?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        appSetup = AppSetup()
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        appSetup?.bootApp(window: window)
        return true
    }
}
