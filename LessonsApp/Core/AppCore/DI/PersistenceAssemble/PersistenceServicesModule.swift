//
//  PersistenceServicesModule.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation

public struct PersistenceServicesModule: PersistenceModuleProtocol {

    private let dbConfigurable: DBManagerProtocol

    public var lessonStorage: LessonLocalStorable

    public init(dbConfigurable: DBManagerProtocol) {
        self.dbConfigurable = dbConfigurable

        lessonStorage = LessonLocalStorage(dbManager: dbConfigurable)
    }

}
