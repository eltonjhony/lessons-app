//
//  WebServiceMock.swift
//  LessonsAppTests
//
//  Created by Elton Jhony on 06/03/23.
//

import Foundation
import Combine

@testable import LessonsApp

public final class WebServiceMock: WebServiceProtocol {
    public func registerDateDecodingStrategy(_ strategy: JSONDecoder.DateDecodingStrategy, for type: Decodable.Type) {}
    public func registerKeyDecodingStrategy(_ strategy: JSONDecoder.KeyDecodingStrategy, for type: Decodable.Type) {}

    private let urlSession: URLSession = URLSession.shared

    public var data: Data?

    init() {
    }

    public func get<U: Decodable>(urlRequest: URLRequest) -> AnyPublisher<NetworkResponse<U>, Error> {
        guard let data = data else {
            return Fail(error: NetworkError.parsingError).eraseToAnyPublisher()
        }
        return Just(data)
            .tryMap(decode(data:))
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    public func get<U: Decodable>(urlRequest: URLRequest) -> AnyPublisher<U, Error> {
        urlSession
            .dataTaskPublisher(for: urlRequest)
            .tryMap(decode(_:response:))
            .receive(on: DispatchQueue.main)
            .map(\.payload)
            .eraseToAnyPublisher()
    }

    func decode<T: Decodable>(_ data: Data?, response: URLResponse) throws ->
        NetworkResponse<T>
    {
        if let urlResponse = response as? HTTPURLResponse, let networkError = urlResponse.networkError(data: data) {
            throw networkError
        }

        do {
            guard let value: T = try data?.decode()
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

    func decode<T: Decodable>(data: Data?) throws ->
        NetworkResponse<T>
    {
        do {
            guard let value: T = try data?.decode()
            else {
                throw NetworkError.parsingError
            }

            return NetworkResponse(payload: value, headers: [:])
        } catch {
            print("Decoding Failure", error)
            throw error
        }
    }
}

