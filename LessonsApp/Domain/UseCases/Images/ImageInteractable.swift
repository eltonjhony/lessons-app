//
//  ImageInteractable.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation
import Combine

public protocol ImageInteractable {
    func load(url: URL) -> AnyPublisher<ImageModel, Error>
}

public final class ImageInteractor: ImageInteractable {
    private let imageRepository: ImageRepositoryProtocol

    public init(imageRepository: ImageRepositoryProtocol) {
        self.imageRepository = imageRepository
    }

    public func load(url: URL) -> AnyPublisher<ImageModel, Error> {
        imageRepository.downloadImage(url: url)
    }
}
