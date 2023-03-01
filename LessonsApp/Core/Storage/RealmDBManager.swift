//
//  RealmDBManager.swift
//  LessonsApp
//
//  Created by Elton Jhony on 28/02/23.
//

import Foundation
import RealmSwift
import Combine

enum RealmError: Error {
    case eitherRealmIsNilOrNotRealmSpecificModel
    case migrationNeeded
}

extension RealmError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .eitherRealmIsNilOrNotRealmSpecificModel:
            return NSLocalizedString("Realm instance is required", comment: "")
        case .migrationNeeded:
            return NSLocalizedString("Migration is required", comment: "")
        }
    }
}

// MARK: - DataManager Implementation
final class RealmDBManager {

    // MARK: - Stored Properties

    private let realm: Realm?

    init(_ realm: Realm?) {
        self.realm = realm
    }
}

extension RealmDBManager: DBManagerProtocol {

    // MARK: - Methods

    func save(object: Storable) throws {
        guard let realm = realm, let object = object as? Object else { throw RealmError.eitherRealmIsNilOrNotRealmSpecificModel }
        try realm.write {
            realm.add(object)
        }
    }

    func update(object: Storable) throws {
        guard let realm = realm, let object = object as? Object else {
            throw RealmError.eitherRealmIsNilOrNotRealmSpecificModel
        }
        try realm.write {
            realm.add(object, update: .all)
        }
    }

    func delete(object: Storable) throws {
        guard let realm = realm, let object = object as? Object else { throw RealmError.eitherRealmIsNilOrNotRealmSpecificModel }
        try realm.write {
            realm.delete(object)
        }
    }

    func deleteAll<T>(_ model: T.Type) throws where T: Storable {
        guard let realm = realm, let model = model as? Object.Type else { throw RealmError.eitherRealmIsNilOrNotRealmSpecificModel }
        try realm.write {
            let objects = realm.objects(model)
            for object in objects {
                realm.delete(object)
            }
        }
    }

    func fetch<T>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?) -> AnyPublisher<[T], Error> where T: Storable {
        guard let realm = realm, let model = model as? Object.Type else {
            return Fail(error: RealmError.eitherRealmIsNilOrNotRealmSpecificModel).eraseToAnyPublisher()
        }
        var objects = realm.objects(model)
        if let predicate = predicate {
            objects = objects.filter(predicate)
        }
        if let sorted = sorted {
            objects = objects.sorted(byKeyPath: sorted.key, ascending: sorted.ascending)
        }
        return Just(objects.compactMap { $0 as? T })
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

}
