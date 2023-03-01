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

    public init() {

    }

    public func viewDidAppear() {
        dataSubject.send(.init(videoURL: "https://embed-ssl.wistia.com/deliveries/cc8402e8c16cc8f36d3f63bd29eb82f99f4b5f88/accudvh5jy.mp4", thumbnailURL: "https://embed-ssl.wistia.com/deliveries/b57817b5b05c3e3129b7071eee83ecb7.jpg?image_crop_resized=1000x560"))
    }
}
