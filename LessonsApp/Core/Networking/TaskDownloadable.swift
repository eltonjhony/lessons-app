//
//  TaskDownloadable.swift
//  LessonsApp
//
//  Created by Elton Jhony on 02/03/23.
//

import Foundation
import Combine

public enum DownloadState {
    case inProgress(Float)
    case downloaded
    case error
    case cancelled
}

public protocol TaskDownloadable {
    var state: AnyPublisher<DownloadState, Never> { get }

    func download(url: URL, id: Int)
    func cancel()
}

public final class URLSessonTaskDownloader: NSObject, TaskDownloadable, URLSessionDownloadDelegate {

    public var state: AnyPublisher<DownloadState, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    private var stateSubject: PassthroughSubject<DownloadState, Never> = .init()

    private var id: Int?

    private var downloadTask: URLSessionDownloadTask?
    private var backgroundSession: URLSession?

    public func download(url: URL, id: Int) {
        guard downloadTask?.state != .running else { return }
        self.id = id
        // Set up the background session
        let sessionConfiguration = URLSessionConfiguration.background(withIdentifier: "com.lesson.backgroundSession")
        backgroundSession = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)

        // Start the download task
        downloadTask = backgroundSession?.downloadTask(with: url)
        downloadTask?.resume()
    }

    public func cancel() {
        if downloadTask?.state == .running {
            downloadTask?.cancel()
            DispatchQueue.main.async {
                self.stateSubject.send(.cancelled)
            }
        }
    }

    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let id = id else { return }
        FileManager.default.saveVideo(at: location, with: id)
        DispatchQueue.main.async {
            self.stateSubject.send(.downloaded)
        }
    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            DispatchQueue.main.async {
                self.stateSubject.send(.error)
            }
        }
    }

    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        DispatchQueue.main.async {
            self.stateSubject.send(.inProgress(progress))
        }
    }
}
