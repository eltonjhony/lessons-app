//
//  ImageService.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation
import Combine

public protocol ImageServiceProtocol {
    func downloadImage(url: URL) -> AnyPublisher<Data, Error>
}

final class ImageService: ImageServiceProtocol {

    private let webService: WebServiceProtocol

    init(webService: WebServiceProtocol) {
        self.webService = webService
    }

    func downloadImage(url: URL) -> AnyPublisher<Data, Error> {
        let imageURLRequest = URLRequest(url: url)
        let data: AnyPublisher<Data, Error> = webService.get(urlRequest: imageURLRequest)
        return data
            .eraseToAnyPublisher()
    }
}
