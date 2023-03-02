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

    private let lessonId: Int

    public init(globalModule: GlobalModuleContaining, lessonId: Int) {
        self.globalModule = globalModule
        self.lessonId = lessonId
    }

    public func createViewController() -> UIViewController {
        let imageInteractor = ImageInteractor(imageRepository: globalModule.services.imageRepository)
        let imagePresenter = ImagePresenter(imageInteractor: imageInteractor)
        let interactor = LessonInteractor(lessonRepository: globalModule.services.lessonRepository)
        let presenter = DetailsPresenter(lessonId: lessonId, interactor: interactor)
        return SUIViewController(
            view: DetailsView(presenter: presenter, imagePresenter: imagePresenter),
            presenter: presenter
        )
    }
}
