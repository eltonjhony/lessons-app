//
//  RealmObject+Storable.swift
//  LessonsApp
//
//  Created by Elton Jhony on 28/02/23.
//

import Foundation
import RealmSwift

extension Object: Storable {
    // Intentionally left empty
}

public struct Sorted {
    var key: String
    var ascending: Bool = true
}
