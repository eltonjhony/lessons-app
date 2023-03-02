//
//  URLImage.swift
//  LessonsApp
//
//  Created by Elton Jhony on 27/02/23.
//

import Foundation
import SwiftUI
import Combine

struct URLImage: View {

    private let url: URL?

    @EnvironmentObject var imagePresenter: SUIImagePresenter
    @State private var image: UIImage?

    @State private var cancellable: AnyCancellable?

    public init(url: URL?) {
        self.url = url
    }

    public var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .renderingMode(.original)
                    .resizable()
            }
        }
        .onAppear(perform: loadImage)
        .onDisappear(perform: stopLoadingImage)
    }

    private func loadImage() {
        loadImageFromURL()
    }

    private func loadImageFromURL() {
        guard let url = url else { return }
        cancellable = imagePresenter.wrapped?
            .load(imageUrl: url)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { loadedImage in
                self.image = UIImage(data: loadedImage.data)
            })
    }

    private func stopLoadingImage() {
        cancellable?.cancel()
    }
}
