//
//  WebService.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation
import Combine

public protocol WebServiceProtocol {
    func get<U: Decodable>(urlRequest: URLRequest) -> AnyPublisher<NetworkResponse<U>, Error>
    func get<U: Decodable>(urlRequest: URLRequest) -> AnyPublisher<U, Error>
    func registerDateDecodingStrategy(_ strategy: JSONDecoder.DateDecodingStrategy, for type: Decodable.Type)
    func registerKeyDecodingStrategy(_ strategy: JSONDecoder.KeyDecodingStrategy, for type: Decodable.Type)
}

public protocol HTTPHeadersDecoratorProtocol {
    func decorateWithHeaders(request: URLRequest) -> URLRequest
}

public protocol SessionConfigurable {
    var clientHeader: String { get }
    var acceptLanguage: String { get }
    var clientVersion: String { get }
    var urlProtocolClasses: [AnyClass] { get }
}

public final class WebService: WebServiceProtocol, HTTPHeadersDecoratorProtocol {
    private let urlSession: URLSession
    private let httpHeadersProviders: HTTPHeadersProviders
    private var dateDecodingStrategies: [String: JSONDecoder.DateDecodingStrategy] = [:]
    private var keyDecodingStrategies: [String: JSONDecoder.KeyDecodingStrategy] = [:]

    public convenience init(configuration: WebServiceConfigurable, httpHeadersProviders: [HTTPHeadersProvider] = []) {
        self.init(urlSession: configuration.urlSession, httpHeadersProviders: httpHeadersProviders)
    }

    init(urlSession: URLSession, httpHeadersProviders: [HTTPHeadersProvider]) {
        self.urlSession = urlSession
        self.httpHeadersProviders = HTTPHeadersProviders(httpHeadersProviders)
    }

    public func registerDateDecodingStrategy(_ strategy: JSONDecoder.DateDecodingStrategy, for type: Decodable.Type) {
        dateDecodingStrategies[String(describing: type)] = strategy
    }

    public func registerKeyDecodingStrategy(_ strategy: JSONDecoder.KeyDecodingStrategy, for type: Decodable.Type) {
        keyDecodingStrategies[String(describing: type)] = strategy
    }

    public func decorateWithHeaders(request: URLRequest) -> URLRequest {
        request.withExtraHeaders(from: httpHeadersProviders.headers())
    }

    public func get<U: Decodable>(urlRequest: URLRequest) -> AnyPublisher<NetworkResponse<U>, Error> {
        run(request: decorateWithHeaders(request: urlRequest.getRequest))
    }

    public func get<U: Decodable>(urlRequest: URLRequest) -> AnyPublisher<U, Error> {
        run(request: decorateWithHeaders(request: urlRequest.getRequest))
    }
}

private extension WebService {

    func run<D: Decodable>(request: URLRequest) -> AnyPublisher<D, Error> {
        run(request: request)
            .map(\.payload)
            .eraseToAnyPublisher()
    }

    func run(request: URLRequest) -> AnyPublisher<Never, Error> {
        urlSession
            .dataTaskPublisher(for: request)
            .tryMap { output -> Void in
                if let response = output.response as? HTTPURLResponse,
                   let networkError = response.networkError(data: output.data)
                {
                    throw networkError
                }
                return ()
            }
            .ignoreOutput()
            .mapError { $0 as NSError }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func run<D: Decodable>(request: URLRequest) -> AnyPublisher<NetworkResponse<D>, Error> {
        urlSession
            .dataTaskPublisher(for: request)
            .tryMap(decode(_:response:))
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func decode<T: Decodable>(_ data: Data?, response: URLResponse) throws -> T {
        try decode(data, response: response).payload
    }

    func decode<T: Decodable>(_ data: Data?, response: URLResponse) throws ->
        NetworkResponse<T>
    {
        if let urlResponse = response as? HTTPURLResponse, let networkError = urlResponse.networkError(data: data) {
            throw networkError
        }

        let dateDecodingStrategy = dateDecodingStrategies[String(describing: T.self)] ?? .secondsSince1970
        let keyDecodingStrategy = keyDecodingStrategies[String(describing: T.self)] ?? .convertFromSnakeCase

        do {
            guard let value: T = try data?.decode(dateDecodingStrategy: dateDecodingStrategy,
                                                  keyDecodingStrategy: keyDecodingStrategy)
            else {
                throw NetworkError.parsingError
            }

            return NetworkResponse(payload: value,
                                   headers: (response as? HTTPURLResponse)?.allHeaderFields)
        } catch {
            print("Decoding Failure", error)
            throw error
        }
    }
}

public struct NetworkResponse<T: Decodable> {
    public let payload: T
    public let headers: [AnyHashable: Any]?
}

private enum Constants {
    static let errorDescription = "error_description"
    static let unknown = "unknown"
}

extension HTTPURLResponse {
    func networkError(data: Data?) -> NetworkError? {
        switch statusCode {
        case 200..<300: return nil
        case 400: return .badRequest(data)
        case 401: return .unauthorized(data?.dictionary?[Constants.errorDescription] ?? Constants.unknown)
        case 403: return .forbidden
        case 409: return .conflict(data?.dictionary ?? [:])
        case 401..<500: return .clientError(statusCode: statusCode)
        case 500..<600: return .serverError(data)
        default: return nil
        }
    }
}

extension Data {
    var dictionary: [String: String]? {
        guard let json = try? JSONSerialization.jsonObject(with: self, options: []) as? [String: Any] else {
            return nil
        }

        return json.mapValues(String.init(describing:))
    }

    func decode<T>(dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .secondsSince1970,
                   keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase) throws -> T? where T: Decodable
    {
        if let selfType = self as? T {
            return selfType
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy

        return try decoder.decode(T.self, from: self)
    }
}
