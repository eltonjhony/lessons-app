//
//  FileManager.swift
//  LessonsApp
//
//  Created by Elton Jhony on 03/03/23.
//

import Foundation

extension FileManager {

    private func buildPath(for id: Int) -> String {
        "video\(id).mp4"
    }

    func saveVideo(at location: URL, with id: Int) {
        let documentsDirectory = urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsDirectory.appendingPathComponent(buildPath(for: id))
        try? removeItem(at: destinationURL)
        try? moveItem(at: location, to: destinationURL)
    }

    func loadVideo(with id: Int) -> URL? {
        let path = buildPath(for: id)
        let documentsDirectory = urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsDirectory.appendingPathComponent(path)
        guard fileExists(atPath: destinationURL.relativePath) else { return nil }
        return destinationURL
    }
}
