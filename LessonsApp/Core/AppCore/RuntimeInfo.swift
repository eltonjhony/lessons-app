//
//  RuntimeInfo.swift
//  LessonsApp
//
//  Created by Elton Jhony on 05/03/23.
//

import Foundation

public enum RuntimeInfo {
    public static var isUITesting: Bool {
        ProcessInfo.environment(contains: .uiTestsAreRunning)
    }
}

public extension ProcessInfo {
    enum Environment: String {
        case uiTestsAreRunning
    }

    static func environment(contains key: Environment) -> Bool {
        ProcessInfo.processInfo.environment.contains { $0.key == key.rawValue }
    }

    static subscript(environment key: Environment) -> String? {
        ProcessInfo.processInfo.environment[key.rawValue].flatMap { $0 }
    }
}
