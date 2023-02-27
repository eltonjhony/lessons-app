//
//  URLRequest.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation

public extension URLRequest {
    internal var getRequest: URLRequest {
        request(httpMethod: "GET")
    }
    
    func withExtraHeaders(from headers: [String: String]?) -> URLRequest {
        var urlRequest = self
        headers?.filter { decoratingHeader in
            guard let allHTTPHeaderFields = urlRequest.allHTTPHeaderFields else { return true }
            return !allHTTPHeaderFields.contains(where: { $0.key == decoratingHeader.key })
        }.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
        return urlRequest
    }
}

private extension URLRequest {
    func request(httpMethod: String) -> URLRequest {
        var request = self
        request.httpMethod = httpMethod
        return request
    }
}
