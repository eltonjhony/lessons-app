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
    }

    public func download(videoURL: String, id: Int) {
        guard let url = URL(string: videoURL) else { return }
        downloadable.download(url: url, id: id)
    }

    public func cancel() {
        downloadable.cancel()
    }
}
