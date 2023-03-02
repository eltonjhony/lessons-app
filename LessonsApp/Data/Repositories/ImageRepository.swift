//
//  ImageRepository.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation
import Combine

public final class ImageRepository: ImageRepositoryProtocol {

    private let service: ImageServiceProtocol

    public init(service: ImageServiceProtocol) {
        self.service = service
    }

    public func downloadImage(url: URL) -> AnyPublisher<ImageModel, Error> {
        service.downloadImage(url: url)
            .map {
                ImageModel(data: $0)
            }
            .eraseToAnyPublisher()
    }
}
