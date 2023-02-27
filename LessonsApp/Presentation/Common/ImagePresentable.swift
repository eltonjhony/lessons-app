//
//  ImagePresentable.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation
import Combine
import UIKit

public protocol ImagePresentable {
    func load(imageUrl: URL) -> AnyPublisher<UIImage?, Error>
}

public class ImagePresenter: ImagePresentable {
    let imageInteractor: ImageInteractable

    public init(imageInteractor: ImageInteractable) {
        self.imageInteractor = imageInteractor
    }

    public func load(imageUrl: URL) -> AnyPublisher<UIImage?, Error> {
        imageInteractor.load(url: imageUrl)
    }
}
