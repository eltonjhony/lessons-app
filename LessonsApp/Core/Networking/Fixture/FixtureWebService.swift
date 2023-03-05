//
//  FixtureWebService.swift
//  LessonsApp
//
//  Created by Elton Jhony on 05/03/23.
//

import Foundation
import Combine

public final class FixtureWebService: WebServiceProtocol {
    public func registerDateDecodingStrategy(_ strategy: JSONDecoder.DateDecodingStrategy, for type: Decodable.Type) {}
    public func registerKeyDecodingStrategy(_ strategy: JSONDecoder.KeyDecodingStrategy, for type: Decodable.Type) {}

    private let urlSession: URLSession = URLSession.shared

    init() {
    }

    public func get<U: Decodable>(urlRequest: URLRequest) -> AnyPublisher<NetworkResponse<U>, Error> {
        guard let stub: String = ProcessInfo.processInfo.environment[urlRequest.url!.relativePath] else {
            return Fail(error: NetworkError.parsingError).eraseToAnyPublisher()
        }
        return Just( Data(stub.utf8))
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
