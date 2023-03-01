//
//  DBManagerProtocol.swift
//  LessonsApp
//
//  Created by Elton Jhony on 28/02/23.
//

import Foundation
import RealmSwift
import Combine

public protocol DBManagerProtocol {
    func save(object: Storable) throws
    func update(object: Storable) throws
    func delete(object: Storable) throws
    func deleteAll<T: Storable>(_ model: T.Type) throws
    func fetch<T>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?) -> AnyPublisher<[T], Error> where T: Storable
}
