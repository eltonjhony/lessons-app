//
//  DownloadInteractable.swift
//  LessonsApp
//
//  Created by Elton Jhony on 02/03/23.
//

import Foundation
import Combine

public protocol DownloadInteractable {
    var state: AnyPublisher<DownloadState, Never> { get }

    func download(videoURL: String, id: Int)
    func cancel()
}

public final class DownloadInteractor: DownloadInteractable {

    public var state: AnyPublisher<DownloadState, Never> {
        downloadable.state.eraseToAnyPublisher()
    }

    private let downloadable: TaskDownloadable
    private let lessonRepository: LessonRepositoryProtocol

    private var cancellables = [AnyCancellable]()

    public init(downloadable: TaskDownloadable, lessonRepository: LessonRepositoryProtocol) {
        self.downloadable = downloadable
        self.lessonRepository = lessonRepository

        registerForUpdates()
    }

    public func download(videoURL: String, id: Int) {
        guard let url = URL(string: videoURL) else { return }
        downloadable.download(url: url, id: id)
    }

    public func cancel() {
        downloadable.cancel()
    }

    private func registerForUpdates() {
        downloadable.state.sink { [weak self] state in
            guard case let .downloaded(path, id) = state else { return }
            self?.updateDownloadedVideo(with: path, id)
        }.store(in: &cancellables)
    }

    private func updateDownloadedVideo(with path: String, _ id: Int) {
        lessonRepository.getById(id)
            .replaceError(with: nil)
            .sink { [weak self] model in
                guard let model = model else { return }
                var lesson = model
                lesson.localVideoUrl = path
                self?.lessonRepository.update(with: lesson)
            }.store(in: &cancellables)
    }
}
