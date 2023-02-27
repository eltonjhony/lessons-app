//
//  HTTPHeadersProvider.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation

public protocol HTTPHeadersProvider {
    func headers() -> [String: String]
}

class HTTPHeadersProviders {
    private let providers: [HTTPHeadersProvider]

    init(_ providers: [HTTPHeadersProvider]) {
        self.providers = providers
    }

    func headers() -> [String: String] {
        Dictionary(providers.flatMap { $0.headers() }, uniquingKeysWith: { _, last in last })
    }
}
