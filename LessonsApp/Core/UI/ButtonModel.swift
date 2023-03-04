//
//  ButtonModel.swift
//  LessonsApp
//
//  Created by Elton Jhony on 02/03/23.
//

import Foundation

public struct ButtonModel {
    public var title: String
    public var icon: String?
    public let action: () -> Void?
}
