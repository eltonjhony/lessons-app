//
//  ImageService.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation
import Combine
import UIKit

public protocol ImageServiceProtocol {
    func downloadImage(url: URL) -> AnyPublisher<UIImage?, Error>
}

final class ImageService: ImageServiceProtocol {

    private let webService: WebServiceProtocol

    init(webService: WebServiceProtocol) {
        self.webService = webService
    }

    func downloadImage(url: URL) -> AnyPublisher<UIImage?, Error> {
        let imageURLRequest = URLRequest(url: url)
        let data: AnyPublisher<Data, Error> = webService.get(urlRequest: imageURLRequest)

        return data
            .map(UIImage.init)
            .eraseToAnyPublisher()
    }
}
