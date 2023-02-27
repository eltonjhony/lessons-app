//
//  MainRouterModule.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation
import UIKit
import SwiftUI

public final class MainRouterModule {

    let globalModule: GlobalModuleContaining

    public init(globalModule: GlobalModuleContaining) {
        self.globalModule = globalModule
    }

    public func createViewController() -> UIViewController {

        let imageInteractor = ImageInteractor(
            imageRepository: globalModule.services.imageRepository
        )

        let mainView = ListingView()
        return AppHostingController(
            rootView: mainView,
            imagePresenter: ImagePresenter(imageInteractor: imageInteractor)
        )
    }
}
