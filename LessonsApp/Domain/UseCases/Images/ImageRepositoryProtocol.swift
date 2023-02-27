//
//  ImageRepositoryProtocol.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation
import Combine
import UIKit

public protocol ImageRepositoryProtocol {
    func downloadImage(url: URL) -> AnyPublisher<UIImage?, Error>
}
