//
//  Updateable.swift
//  LessonsApp
//
//  Created by Elton Jhony on 01/03/23.
//

import Foundation

public protocol Updateable: AnyObject {
    associatedtype Data
    func update(with: Data)
}
