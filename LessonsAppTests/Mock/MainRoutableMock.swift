//
//  MainRoutableMock.swift
//  LessonsAppTests
//
//  Created by Elton Jhony on 06/03/23.
//

import Foundation
import Combine
import UIKit

@testable import LessonsApp

public final class MainRoutableMock: MainRoutable {
    public var rootViewController: UIViewController?

    var startCalled: Bool = false
    var coordinateToDetailsCalled: Bool = false

    public func start(window: UIWindow) {
        startCalled = true
    }

    public func coordinateToDetails(with id: Int) {
        coordinateToDetailsCalled = true
    }
}
