//
//  DetailsPresenter.swift
//  LessonsApp
//
//  Created by Elton Jhony on 28/02/23.
//

import Foundation
import Combine

public protocol DetailsPresentable: SUIPresentable {
    var data: AnyPublisher<DetailsViewModel?, Never> { get }
}

public final class DetailsPresenter: DetailsPresentable {

    public var data: AnyPublisher<DetailsViewModel?, Never> {
        dataSubject.eraseToAnyPublisher()
    }
    private var dataSubject: CurrentValueSubject<DetailsViewModel?, Never> = .init(nil)

    private let lessonId: Int
    private let interactor: LessonInteractor

    private var cancellables = [AnyCancellable]()

    public init(lessonId: Int, interactor: LessonInteractor) {
        self.lessonId = lessonId
        self.interactor = interactor
    }

    public func viewDidAppear() {
        interactor.getById(lessonId)
            .sink { [weak self] model in
                guard let self = self, let model = model else { return }
                self.dataSubject.send(model.data)
            }.store(in: &cancellables)
    }
}

private extension LessonModel {
    var data: DetailsViewModel {
        .init(
            title: name,
            description: description,
            videoURL: videoUrl,
            thumbnailURL: thumbnail)
    }
}
