//
//  WebServiceConfigurable.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation

public protocol WebServiceConfigurable {
    var urlSessionConfiguration: URLSessionConfiguration { get }
    var urlSession: URLSession { get }
}

public final class WebServiceConfigurator: WebServiceConfigurable {
    public var urlSessionConfiguration: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        return configuration
    }

    public var urlSession: URLSession {
        URLSession(configuration: urlSessionConfiguration)
    }
}
