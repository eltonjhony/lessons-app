//
//  XCTestCaseHelper.swift
//  LessonsAppUITests
//
//  Created by Elton Jhony on 05/03/23.
//

import Foundation
import UIKit
import XCTest

extension XCTestCase {
    func stub(endpoint: String, with jsonFile: String) -> [String: String] {
        let path = Bundle(for: type(of: self)).path(forResource: jsonFile, ofType: "json")
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
        let dataStr = String(decoding: data, as: UTF8.self)
        return [endpoint: dataStr]
    }
}
