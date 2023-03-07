//
//  DBManagerMock.swift
//  LessonsAppTests
//
//  Created by Elton Jhony on 06/03/23.
//

import Foundation
import Combine

@testable import LessonsApp

public final class DBManagerMock: DBManagerProtocol {

    var entities: [Storable] = []
    var hasError: Bool = false
    var fetchCalled: Bool = false

    var updateCalled: Bool = false
    var updatedEntity: Storable?

    public func deleteAll<T>(_ model: T.Type) throws where T : Storable {}
    public func delete(object: Storable) throws {}
    public func save(object: Storable) throws {}
    public func update(object: Storable) throws {
        self.updatedEntity = object
        updateCalled = true
    }

    public func fetch<T>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?) -> AnyPublisher<[T], Error> where T : Storable {
        return Just(entities as! [T])
            .tryMap { entites in
                if hasError {
                    throw RealmError.eitherRealmIsNilOrNotRealmSpecificModel
                }
                return entites
            }
            .handleEvents(receiveSubscription: { _ in
                self.fetchCalled = true
            })
            .eraseToAnyPublisher()
    }
}
