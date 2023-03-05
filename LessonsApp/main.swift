//
//  main.swift
//  LessonsApp
//
//  Created by Elton Jhony on 05/03/23.
//

import Foundation
import UIKit

#if DEBUG
    let appDelegateClass: AnyClass = RuntimeInfo.isUITesting ? UITestsAppDelegate.self : AppDelegate.self
#else
    let appDelegateClass = AppDelegate.self
#endif

_ = UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(appDelegateClass))
