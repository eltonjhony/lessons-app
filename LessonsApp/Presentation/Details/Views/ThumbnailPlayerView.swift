//
//  ThumbnailPlayerView.swift
//  LessonsApp
//
//  Created by Elton Jhony on 01/03/23.
//

import Foundation
import Combine
import UIKit

public struct ThumbnailPlayerViewModel: Equatable {
    let thumbnailURL: String
}

private enum Constants {
    static let playerHeight: CGFloat = 60
    static let playerWidth: CGFloat = 50
}

final class ThumbnailPlayerView: SUIView {

    private let imagePresenter: ImagePresenter

    private var cancellables = [AnyCancellable]()

    private lazy var thumbnailPlayerContainerView: LoadingImageView = {
        let view = LoadingImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var thumbnailPlayerView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(systemName: "play.fill")
        view.tintColor = .white
        return view
    }()

    init(imagePresenter: ImagePresenter) {
        self.imagePresenter = imagePresenter
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        addSubview(thumbnailPlayerContainerView)
        thumbnailPlayerContainerView.addSubview(thumbnailPlayerView)
        NSLayoutConstraint.activate([
            thumbnailPlayerContainerView.topAnchor.constraint(equalTo: topAnchor, constant: .zero),
            thumbnailPlayerContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: .zero),
            thumbnailPlayerContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .zero),
            thumbnailPlayerContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: .zero)
        ])
        NSLayoutConstraint.activate([
            thumbnailPlayerView.centerXAnchor.constraint(equalTo: thumbnailPlayerContainerView.centerXAnchor),
            thumbnailPlayerView.centerYAnchor.constraint(equalTo: thumbnailPlayerContainerView.centerYAnchor),
            thumbnailPlayerView.heightAnchor.constraint(equalToConstant: Constants.playerHeight),
            thumbnailPlayerView.widthAnchor.constraint(equalToConstant: Constants.playerWidth),
        ])
        thumbnailPlayerContainerView.loadImage(imagePresenter: imagePresenter)
    }

}

extension ThumbnailPlayerView: Updateable {
    func update(with model: ThumbnailPlayerViewModel) {
        if let thumbURL = URL(string: model.thumbnailURL) {
            thumbnailPlayerContainerView.set(url: thumbURL)
        }
    }
}
