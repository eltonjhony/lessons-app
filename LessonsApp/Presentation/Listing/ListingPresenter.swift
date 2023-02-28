//
//  ListingPresenter.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation
import Combine

public protocol ListingPresentable: ObservableObject {
    var lessons: [LessonModel] { get }
    func fetchLessons()
}

public final class ListingPresenter: ListingPresentable {
    @Published public var lessons: [LessonModel] = []

    private let interactor: LessonInteractable

    private var cancellables = [AnyCancellable]()

    public init(interactor: LessonInteractable) {
        self.interactor = interactor
        interactor.lessons.assign(to: \.lessons, on: self).store(in: &cancellables)
    }

    public func fetchLessons() {
        interactor.fetchLessons()
    }
}
