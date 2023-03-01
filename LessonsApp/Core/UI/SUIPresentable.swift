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
    public let isBackButtonHidden: Bool
    public let largeTitle: Bool

    init(
        title: String? = nil,
        isBackButtonHidden: Bool = false,
        largeTitle: Bool = false
    ) {
        self.title = title
        self.isBackButtonHidden = isBackButtonHidden
        self.largeTitle = largeTitle
    }
}

public protocol SUIPresentable: ObservableObject {

    /// If nil, the native navigation bar will be hidden to leave place for custom SwiftUI content
    var navigationBar: SUIPresentableNavigationBar? { get }

    func viewDidAppear()
}

extension SUIPresentable {

    public var navigationBar: SUIPresentableNavigationBar? {
        get { return .init() } set {}
    }

}

open class SUIView: UIView {
    public weak var parent: UIViewController?
}
