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

    private var lessonId: Int
    private let interactor: LessonInteractor

    private var cancellables = [AnyCancellable]()

    public init(lessonId: Int, interactor: LessonInteractor) {
        self.lessonId = lessonId
        self.interactor = interactor
    }

    public func onAppear() {
        fetchData()
    }

    private func fetchData() {
        interactor.getById(lessonId)
            .sink { [weak self] model in
                guard let self = self, let model = model else { return }
                let nextLessonAction = {
                    self.lessonId+=1
                    self.fetchData()
                }
                self.dataSubject.send(model.toData(nextLessonAction))
            }.store(in: &cancellables)
    }
}

private extension LessonModel {
    func toData(_ nextLessonAction: @escaping () -> Void) -> DetailsViewModel {
        .init(
            title: name,
            description: description,
            videoURL: videoUrl,
            thumbnailURL: thumbnail,
            nextLessonAction: nextLessonAction
        )
    }
}
