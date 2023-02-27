//
//  NetworkError.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation

public enum NetworkError: Error, Equatable {
    case unauthorized(String)
    case forbidden
    case clientError(statusCode: Int)
    case conflict([String: String])
    case serverError(Data?)
    case connectionError
    case badRequest(Data?)
    case parsingError
    case invalidDataError
    case unknown
}

public extension NetworkError {
    var errorDescription: String? {
        switch self {
        case let .unauthorized(message): return message
        case .connectionError: return "no connection"
        default: return nil
        }
    }
}

public extension Error {
    var errorDescription: String? {
        if let networkError = self as? NetworkError {
            return networkError.errorDescription
        }
        return nil
    }
}

extension Error {
    var networkError: NetworkError {

        if let networkError = self as? NetworkError { return networkError }

        let nserror = self as NSError

        if nserror.domain == NSURLErrorDomain {
            switch nserror.code {
            case NSURLErrorUserAuthenticationRequired: return .unauthorized("authentication required")
            default: return .connectionError
            }
        }

        return .unknown
    }
}
