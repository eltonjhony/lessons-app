//
//  MappableProtocol.swift
//  LessonsApp
//
//  Created by Elton Jhony on 28/02/23.
//

import Foundation
import RealmSwift

protocol MappableProtocol {
    associatedtype PersistenceType: Storable

    func mapToPersistenceObject() -> PersistenceType
    static func mapFromPersistenceObject(_ object: PersistenceType) -> Self
}
