//
//  DetailsRouterModule.swift
//  LessonsApp
//
//  Created by Elton Jhony on 28/02/23.
//

import Foundation
import UIKit

public final class DetailsRouterModule {

    let globalModule: GlobalModuleContaining

    public init(globalModule: GlobalModuleContaining) {
        self.globalModule = globalModule
    }

    public func createViewController() -> UIViewController {
        let presenter = DetailsPresenter()
        return SUIViewController(
            view: DetailsView(presenter: presenter),
            presenter: presenter,
            supportedOrientations: [.portrait, .landscape]
        )
    }
}
