//
//  Data.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation

public extension Data {
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
