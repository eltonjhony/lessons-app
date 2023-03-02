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

    public var rightBarButtons: AnyPublisher<[ButtonModel], Never>? {
        rightBarButtonsSubject.eraseToAnyPublisher()
    }
    private var rightBarButtonsSubject: PassthroughSubject<[ButtonModel], Never> = .init()

    public var data: AnyPublisher<DetailsViewModel?, Never> {
        dataSubject.eraseToAnyPublisher()
    }
    private var dataSubject: CurrentValueSubject<DetailsViewModel?, Never> = .init(nil)

    public var downloadState: AnyPublisher<DownloadState, Never> {
        downloadInteractor.state.eraseToAnyPublisher()
    }

    private var lessonId: Int
    private var model: LessonModel?

    private let interactor: LessonInteractable
    private let downloadInteractor: DownloadInteractable

    private var cancellables = [AnyCancellable]()

    public init(lessonId: Int, interactor: LessonInteractable, downloadInteractor: DownloadInteractable) {
        self.lessonId = lessonId
        self.interactor = interactor
        self.downloadInteractor = downloadInteractor
    }

    public func onAppear() {
        configureDownload()
        fetchData()
    }

    private func fetchData() {
        interactor.getById(lessonId)
            .sink { [weak self] model in
                guard let self = self, let model = model else { return }
                self.model = model
                let nextLessonAction = {
                    self.lessonId+=1
                    self.fetchData()
                }
                let data = model.toData(
                    nextLessonAction,
                    self.downloadInteractor.cancel
                )
                self.dataSubject.send(data)
            }.store(in: &cancellables)
    }

    private func configureDownload() {
        let downloadAction = { [weak self] in
            guard let self = self, let model = self.model else { return }
            self.downloadInteractor.download(videoURL: model.videoUrl, id: model.id)
        }
        let downloadModel: ButtonModel = .init(
            title: "Download",
            icon: "icloud.and.arrow.down",
            enabled: true, action: downloadAction
        )
        rightBarButtonsSubject.send([downloadModel])
    }
}

private extension LessonModel {
    func toData(_ nextLessonAction: @escaping () -> Void, _ cancelDownloadAction: @escaping () -> Void) -> DetailsViewModel {
        .init(
            title: name,
            description: description,
            videoURL: localVideoUrl ?? videoUrl,
            thumbnailURL: thumbnail,
            nextLessonAction: nextLessonAction,
            cancelDownloadAction: cancelDownloadAction
        )
    }
}
