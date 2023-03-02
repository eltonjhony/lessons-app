//
//  ImageRepositoryProtocol.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation
import Combine

public protocol ImageRepositoryProtocol {
    func downloadImage(url: URL) -> AnyPublisher<ImageModel, Error>
}
