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

    public func createViewController(router: MainRoutable) -> UIViewController {

        let imageInteractor = ImageInteractor(
            imageRepository: globalModule.services.imageRepository
        )

        let lessonInteractor = LessonInteractor(
            lessonRepository: globalModule.services.lessonRepository
        )

        let presenter = ListingPresenter(interactor: lessonInteractor, router: router)
        let mainView = ListingView(presenter: presenter)
        return SUIViewController(
            view: mainView,
            presenter: presenter,
            imagePresenter: ImagePresenter(imageInteractor: imageInteractor)
        )
    }
}
