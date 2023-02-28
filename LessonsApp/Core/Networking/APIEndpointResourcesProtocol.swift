//
//  APIEndpointResourcesProtocol.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation

public protocol LessonEndpointResourceable {
    var lessonsURL: URL { get }
}

public protocol APIEndpointResourcesProtocol: LessonEndpointResourceable {
    var baseURL: URL { get }
}

public struct APIEndpointResources: APIEndpointResourcesProtocol {
    public let baseURL = URL(safe: "https://iphonephotographyschool.com/test-api")

    public var lessonsURL: URL {
        baseURL.appendingPathComponent("/lessons")
    }
}

private extension URL {
    init(safe string: StringLiteralType) {
        self.init(string: string)! // swiftlint:disable:this force_unwrapping
    }
}
