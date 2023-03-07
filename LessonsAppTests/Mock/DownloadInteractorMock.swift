//
//  DownloadInteractorMock.swift
//  LessonsAppTests
//
//  Created by Elton Jhony on 06/03/23.
//

import Foundation
import Combine

@testable import LessonsApp

public final class DownloadInteractorMock: DownloadInteractable {
    public var state: AnyPublisher<DownloadState, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    public var stateSubject: PassthroughSubject<DownloadState, Never> = .init()

    var downloadCalled = false
    var cancelCalled = false
    var stateMock: DownloadState?

    public func download(videoURL: String, id: Int) {
        downloadCalled = true
        if let state = stateMock {
            stateSubject.send(state)
        }
    }

    public func cancel() {
        cancelCalled = true
        stateSubject.send(.cancelled)
    }
}
