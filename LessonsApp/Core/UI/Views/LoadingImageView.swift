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

public class LoadingImageView: UIImageView {

    private let urlSubject: CurrentValueSubject<URL?, Never> = .init(nil)
    
    private var cancellables = [AnyCancellable]()

    private var cancellablesForLoading = [AnyCancellable]()

    private var automaticRatioConstraint: NSLayoutConstraint?
    private var placeholderOverlayImage: UIImageView?

    private var activityIndicator: UIActivityIndicatorView?

    private var imagePresenter: ImagePresentable?

    private var isCancelling = false

    public var fadeImageOnLoad = false

    private var imageIsLoading: Bool = false

    public func set(url: URL) {
        urlSubject.send(url)
    }

    override public var image: UIImage? {
        didSet {
            imageUpdated?()
        }
    }

    /// Use it to perform some action after the image was downloaded and set.
    public var imageUpdated: (() -> Void)?

    /// Changes the content mode after the image has been downloaded.
    /// Useful for example when the placeholder needs a different content mode than de downloaded image.
    public var contentModeAfterLoading: UIView.ContentMode?

    /// Adds an aspect ratio constraint after the image is downloaded to match the aspect ratio of the image.
    /// The ImageView needs to have either width or height constraint, or both.
    /// In that case it has width and height constraints, one needs to be low priority, otherwise constraints will break.
    public var adjustRatioAfterLoading: Bool = false

    /// template methods, might be used as hooks in subclasses.
    func didStartLoading() {}
    func didStopLoading() {}
    func didFailLoading() {}

    public func beginPlaceholderAnimation() {
        imageIsLoading = true
    }

    public func stopPlaceholderAnimation() {
        imageIsLoading = false
    }
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

        guard let imagePresenter = imagePresenter, !isCancelling else { return }

        if let url = url {
            startLoading(imagePresenter.load(imageUrl: url))
        }

    }

    func startLoading(_ loadPublisher: AnyPublisher<UIImage?, Error>) {
        didStartLoading()
        imageIsLoading = true

        loadPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard case .failure = completion else {
                    self?.imageIsLoading = false
                    self?.didStopLoading()
                    return
                }
                self?.imageIsLoading = false
                self?.didFailLoading()
            } receiveValue: { [weak self] image in
                self?.set(image: image)
            }.store(in: &cancellablesForLoading)
    }

    func set(image: UIImage?) {
        var fadeDuration = 0.0
        if fadeImageOnLoad {
            alpha = 0
            fadeDuration = 0.5
        }

        UIView.animate(
            withDuration: fadeDuration, animations: {
                self.fadeImageOnLoad = false
                self.image = image
                self.alpha = 1
            }
        )

        if let contentModeAfterLoading = contentModeAfterLoading {
            contentMode = contentModeAfterLoading
        }
        if adjustRatioAfterLoading {
            adjustRatioConstraint()
        }
    }

    func adjustRatioConstraint() {
        guard let img = image else { return }
        automaticRatioConstraint?.isActive = false
        automaticRatioConstraint = widthAnchor.constraint(equalTo: heightAnchor, multiplier: img.size.width / img.size.height)
        automaticRatioConstraint?.isActive = true
    }

}
