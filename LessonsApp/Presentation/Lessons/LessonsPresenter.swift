//
//  LessonsPresenter.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation
import Combine

public protocol LessonsPresentable: SUIPresentable {
    var data: LessonsData { get }
    func detailsTapped(id: Int)
}

public final class LessonsPresenter: LessonsPresentable {

    public var navigationBar: SUIPresentableNavigationBar? = .init(
        title: "Lessons",
        largeTitle: true
    )

    @Published public var data: LessonsData = .idle

    private let interactor: LessonInteractable
    private weak var router: MainRoutable?

    private var cancellables = [AnyCancellable]()

    public init(interactor: LessonInteractable, router: MainRoutable) {
        self.interactor = interactor
        self.router = router
        interactor.lessonsData
            .assign(to: \.data, on: self)
            .store(in: &cancellables)
    }

    public func onAppear() {
        interactor.fetchLessons()
    }

    public func detailsTapped(id: Int) {
        router?.coordinateToDetails(with: id)
    }
}
