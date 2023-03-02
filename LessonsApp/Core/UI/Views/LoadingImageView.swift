//
//  LoadingImageView.swift
//  LessonsApp
//
//  Created by Elton Jhony on 01/03/23.
//

import Foundation
import Combine
import UIKit

public protocol ImageLoadable {
    func loadImage(imagePresenter: ImagePresentable)
}

public final class LoadingImageView: UIImageView {

    private let urlSubject: CurrentValueSubject<URL?, Never> = .init(nil)
    
    private var cancellables = [AnyCancellable]()

    private var imagePresenter: ImagePresentable?

    public func set(url: URL) {
        urlSubject.send(url)
    }

    /// template methods, might be used as hooks in subclasses.
    func didStartLoading() {}
    func didStopLoading() {}
    func didFailLoading() {}
}

extension LoadingImageView: ImageLoadable {

    public func loadImage(imagePresenter: ImagePresentable) {

        guard self.imagePresenter == nil else { return }

        cancellables = [AnyCancellable]()
        self.imagePresenter = imagePresenter

        urlSubject.sink { [weak self] url in
            self?.load(url: url)
        }.store(in: &cancellables)
    }
}

private extension LoadingImageView {

    func load(url: URL?) {
        guard let imagePresenter = imagePresenter else { return }

        if let url = url {
            startLoading(
                imagePresenter.load(imageUrl: url)
                    .map { UIImage.init(data: $0.data) }
                    .eraseToAnyPublisher()
            )
        }
    }

    func startLoading(_ loadPublisher: AnyPublisher<UIImage?, Error>) {
        didStartLoading()
        loadPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard case .failure = completion else {
                    self?.didStopLoading()
                    return
                }
                self?.didFailLoading()
            } receiveValue: { [weak self] image in
                self?.set(image: image)
            }.store(in: &cancellables)
    }

    func set(image: UIImage?) {
        UIView.animate(
            withDuration: 000, animations: {
                self.image = image
                self.alpha = 1
            }
        )
    }

}
