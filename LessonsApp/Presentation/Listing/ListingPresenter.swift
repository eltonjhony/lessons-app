//
//  ListingPresenter.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation
import Combine

public protocol ListingPresentable: SUIPresentable {
    var lessons: [LessonModel] { get }
    func detailsTapped()
}

public final class ListingPresenter: ListingPresentable {

    public var navigationBar: SUIPresentableNavigationBar? = .init(
        title: "Lessons",
        largeTitle: true
    )

    @Published public var lessons: [LessonModel] = []

    private let interactor: LessonInteractable
    private weak var router: MainRoutable?

    private var cancellables = [AnyCancellable]()

    public init(interactor: LessonInteractable, router: MainRoutable) {
        self.interactor = interactor
        self.router = router
        interactor.lessons
            .assign(to: \.lessons, on: self)
            .store(in: &cancellables)
    }

    public func viewDidAppear() {
        interactor.fetchLessons()
    }

    public func detailsTapped() {
        router?.coordinateToDetails()
    }
}
