//
//  SUIPresentable.swift
//  LessonsApp
//
//  Created by Elton Jhony on 28/02/23.
//

import Foundation
import UIKit
import SwiftUI
import Combine

public struct SUIPresentableNavigationBar: Equatable {
    public let title: String?
    public let largeTitle: Bool

    init(
        title: String? = nil,
        largeTitle: Bool = false
    ) {
        self.title = title
        self.largeTitle = largeTitle
    }
}

public protocol SUIPresentable: ObservableObject {
    var navigationBar: SUIPresentableNavigationBar? { get }
    var rightBarButtons: PassthroughSubject<[ButtonModel], Never> { get }

    func onAppear()
}

extension SUIPresentable {

    public var navigationBar: SUIPresentableNavigationBar? {
        get { return .init() } set {}
    }

    public var rightBarButtons: PassthroughSubject<[ButtonModel], Never> {
        get { return .init() } set {}
    }

}

open class SUIView: UIView {
    weak var parent: UIViewController?

    public func present(_ viewController: UIViewController) {
        guard parent?.presentedViewController == nil else { return }
        parent?.present(viewController, animated: true)
    }

    public func moveChildToParent(_ child: UIViewController) {
        if parent?.children.first(where: { $0 == child }) == nil {
            parent?.addChild(child)
            child.didMove(toParent: parent)
        }
    }
}
