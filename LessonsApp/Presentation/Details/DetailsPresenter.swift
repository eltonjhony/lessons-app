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
    var downloadState: AnyPublisher<DownloadState, Never> { get }
}

public final class DetailsPresenter: DetailsPresentable {
    public var rightBarButtons: PassthroughSubject<[ButtonModel], Never> = .init()

    public var data: AnyPublisher<DetailsViewModel?, Never> {
        dataSubject.eraseToAnyPublisher()
    }
    private var dataSubject: CurrentValueSubject<DetailsViewModel?, Never> = .init(nil)

    public var downloadState: AnyPublisher<DownloadState, Never> {
        downloadInteractor.state.eraseToAnyPublisher()
    }

    private var lessonId: Int

    private let interactor: LessonInteractable
    private let downloadInteractor: DownloadInteractable

    private var cancellables = [AnyCancellable]()

    public init(lessonId: Int, interactor: LessonInteractable, downloadInteractor: DownloadInteractable) {
        self.lessonId = lessonId
        self.interactor = interactor
        self.downloadInteractor = downloadInteractor

        Publishers.CombineLatest(interactor.detailsData, interactor.nextLessonAvailable)
            .sink { [weak self] in
                guard let model = $0 else { return }
                self?.prepareData(with: model, $1)
            }.store(in: &cancellables)
    }

    public func onAppear() {
        interactor.getById(lessonId)
    }

    private func prepareData(with model: LessonModel, _ nextLessonAvailable: Bool) {
        self.lessonId = model.id
        let downloadAction = { [weak self] in
            self?.downloadInteractor.download(videoURL: model.videoUrl, id: model.id)
        }
        rightBarButtons.send([.init(
            title: "Download",
            icon: "icloud.and.arrow.down",
            action: downloadAction
        )])

        let nextLessonAction = { [weak self] in
            guard let lessonId = self?.lessonId else { return }
            self?.interactor.getNextLesson(lessonId)
        }
        let data = model.toData(
            nextLessonAvailable ? nextLessonAction : nil,
            downloadInteractor.cancel
        )
        dataSubject.send(data)
    }
}

private extension LessonModel {
    func toData(_ nextLessonAction: (() -> Void)?, _ cancelDownloadAction: @escaping () -> Void) -> DetailsViewModel {
        .init(
            id: id,
            title: name,
            description: description,
            videoUrl: videoUrl,
            thumbnailURL: thumbnail,
            nextLessonAction: nextLessonAction,
            cancelDownloadAction: cancelDownloadAction
        )
    }
}
