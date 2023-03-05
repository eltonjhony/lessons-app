//
//  FileManager.swift
//  LessonsApp
//
//  Created by Elton Jhony on 03/03/23.
//

import Foundation

private enum VideoDir {
    case path(Int)

    var rawValue: String {
        switch self {
        case .path(let id):
            return "video\(id).mp4"
        }
    }
}

extension FileManager {
    public var home: URL { urls(for: .documentDirectory, in: .userDomainMask)[0] }

    func saveVideo(at location: URL, with id: Int) {
        let destinationURL = home.appendingPathComponent(VideoDir.path(id).rawValue)
        try? removeItem(at: destinationURL)
        try? moveItem(at: location, to: destinationURL)
    }

    func loadVideo(with id: Int) -> URL? {
        let destinationURL = home.appendingPathComponent(VideoDir.path(id).rawValue)
        guard fileExists(atPath: destinationURL.relativePath) else { return nil }
        return destinationURL
    }
}
