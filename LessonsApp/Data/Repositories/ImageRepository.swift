//
//  ImageRepository.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation
import Combine
import UIKit

public final class ImageRepository: ImageRepositoryProtocol {

    private let service: ImageServiceProtocol

    public init(service: ImageServiceProtocol) {
        self.service = service
    }

    public func downloadImage(url: URL) -> AnyPublisher<UIImage?, Error> {
        service.downloadImage(url: url)
    }
}
