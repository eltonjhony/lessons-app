//
//  BidirectionalCollection.swift
//  LessonsApp
//
//  Created by Elton Jhony on 03/03/23.
//

import Foundation

extension BidirectionalCollection where Iterator.Element: Equatable {
    typealias Element = Self.Iterator.Element

    /// Returns the next element in Collection.
    /// - Parameters:
    ///  - item: Element of the collection for which the next Element is requried
    ///  - loop: false by default. Set loop parameter as `true`, if we need to jump to first item if we need the next item of the last element.
    ///          This can be useful when we start the search of element from middle of the collection
    func after(_ item: Element, loop: Bool = false) -> Element? {
        if let itemIndex = self.firstIndex(of: item) {
            let lastItem: Bool = (index(after: itemIndex) == endIndex)
            if loop && lastItem {
                return self.first
            } else if lastItem {
                return nil
            } else {
                return self[index(after: itemIndex)]
            }
        }
        return nil
    }
}
