//
//  UITestsAppDelegate.swift
//  LessonsApp
//
//  Created by Elton Jhony on 05/03/23.
//

import Foundation
import UIKit
import Realm

final class UITestsAppDelegate: UIResponder, UIApplicationDelegate {
    public var window: UIWindow?
    public var appSetup: AppSetup?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        prepareForRelaunch()
        appSetup = AppSetup(applicationConfiguration: UITestAppConfiguration())
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        appSetup?.bootApp(window: window)
        return true
    }
}

private extension UITestsAppDelegate {

    func prepareForRelaunch() {
        removeEverythingInDirectory()
        removeDatabaseSchema()
    }

    func removeEverythingInDirectory() {
        let fileManager = FileManager.default
        let urls = try? fileManager.contentsOfDirectory(at: FileManager.default.home, includingPropertiesForKeys: nil)
        for url in urls ?? [] {
            try? fileManager.removeItem(at: url)
        }
    }

    func removeDatabaseSchema() {
        if let realmFile = RealmProvider.default?.configuration.fileURL {
            try? FileManager.default.removeItem(at: realmFile)
        }
    }

}
