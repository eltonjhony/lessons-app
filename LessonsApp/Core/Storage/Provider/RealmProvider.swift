//
//  RealmProvider.swift
//  LessonsApp
//
//  Created by Elton Jhony on 28/02/23.
//

import Foundation
import RealmSwift

final class RealmProvider {

    // MARK: - Stored Properties

    let configuration: Realm.Configuration

    // MARK: - Init

    internal init(config: Realm.Configuration) {
        configuration = config
    }

    private var realm: Realm? {
        do {
            let dbInstance = try Realm(configuration: configuration)
            print("User Realm User file location: \(dbInstance.configuration.fileURL!.path)")
            return dbInstance
        } catch {
            print(error.localizedDescription)
            if error.isDbMigrationError {
                handleDbMigrationError()
            }
            return try? Realm(configuration: configuration)
        }
    }

    // MARK: - Configuration

    private static let defaultConfig = Realm.Configuration(schemaVersion: 1)

    // MARK: - Realm Instances

    public static var `default`: Realm? = {
        return RealmProvider(config: RealmProvider.defaultConfig).realm
    }()
}

private extension RealmProvider {

    func handleDbMigrationError() {
        fatalError(RealmError.migrationNeeded.localizedDescription)
    }

}

private extension Error {
    var isDbMigrationError: Bool {
        (self as NSError).code == .dbMigrationErrorCode
    }
}

private extension Int {
    static var dbMigrationErrorCode: Int {
        10
    }
}
