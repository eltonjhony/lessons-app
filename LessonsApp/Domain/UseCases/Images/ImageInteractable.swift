//
//  ImageInteractable.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation
import Combine
import UIKit

public protocol ImageInteractable {
    func load(url: URL) -> AnyPublisher<UIImage?, Error>
}

public final class ImageInteractor: ImageInteractable {
    private let imageRepository: ImageRepositoryProtocol

    public init(imageRepository: ImageRepositoryProtocol) {
        self.imageRepository = imageRepository
    }

    public func load(url: URL) -> AnyPublisher<UIImage?, Error> {
        imageRepository.downloadImage(url: url)
    }
}
