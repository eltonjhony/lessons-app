//
//  DetailsView.swift
//  LessonsApp
//
//  Created by Elton Jhony on 28/02/23.
//

import Foundation
import Combine
import UIKit

public protocol Updateable: AnyObject {
    associatedtype Data
    func update(with: Data)
}

public struct DetailsViewModel: Equatable {
    let title: String
    let description: String
    let videoURL: String
    let thumbnailURL: String
}

private enum Constants {
    static let videoPlayerHeight: CGFloat = 250
    static let regularHorizontalPadding: CGFloat = 16
}

final class DetailsView<Presenter: DetailsPresentable>: SUIView {

    private let presenter: Presenter
    private let imagePresenter: ImagePresenter
    
    private var cancellables = [AnyCancellable]()

    private let videoPlayer: VideoPlayerController = .init()

    private lazy var videoPlayerContainerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    private lazy var thumbnailPlayerView: ThumbnailPlayerView = {
        let view = ThumbnailPlayerView(imagePresenter: imagePresenter)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        view.textAlignment = .left
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = 0
        return view
    }()

    private lazy var descriptionView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        view.textAlignment = .left
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = 0
        return view
    }()

    init(presenter: Presenter, imagePresenter: ImagePresenter) {
        self.presenter = presenter
        self.imagePresenter = imagePresenter
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func orientationDidChange() {
        if UIDevice.current.orientation.isLandscape {
            videoPlayer.goFullScreen()
        }
    }

    func setup() {
        addSubview(videoPlayerContainerView)
        videoPlayerContainerView.addSubview(thumbnailPlayerView)
        addSubview(titleView)
        addSubview(descriptionView)
        NSLayoutConstraint.activate([
            videoPlayerContainerView.topAnchor.constraint(equalTo: topAnchor),
            videoPlayerContainerView.heightAnchor.constraint(equalToConstant: Constants.videoPlayerHeight),
            videoPlayerContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            videoPlayerContainerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            videoPlayerContainerView.topAnchor.constraint(equalTo: topAnchor),
            videoPlayerContainerView.heightAnchor.constraint(equalToConstant: Constants.videoPlayerHeight),
            videoPlayerContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            videoPlayerContainerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            thumbnailPlayerView.topAnchor.constraint(equalTo: videoPlayerContainerView.topAnchor),
            thumbnailPlayerView.bottomAnchor.constraint(equalTo: videoPlayerContainerView.bottomAnchor),
            thumbnailPlayerView.leadingAnchor.constraint(equalTo: videoPlayerContainerView.leadingAnchor),
            thumbnailPlayerView.trailingAnchor.constraint(equalTo: videoPlayerContainerView.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: videoPlayerContainerView.bottomAnchor, constant: Constants.regularHorizontalPadding),
            titleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.regularHorizontalPadding),
            titleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.regularHorizontalPadding)
        ])
        NSLayoutConstraint.activate([
            descriptionView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: Constants.regularHorizontalPadding),
            descriptionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.regularHorizontalPadding),
            descriptionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.regularHorizontalPadding)
        ])
        sinkSubscriptions()
    }

    private func sinkSubscriptions() {
        presenter.data.sink { [weak self] model in
            guard let model = model else { return }
            self?.update(with: model)
        }.store(in: &cancellables)

        thumbnailPlayerView.gesture().sink { [weak self] _ in
            self?.thumbnailPlayerView.isHidden = true
            self?.videoPlayer.player?.play()
        }.store(in: &cancellables)

        NotificationCenter.default.addObserver(
            self, selector: #selector(orientationDidChange),
            name: UIDevice.orientationDidChangeNotification, object: nil
        )
    }
    
}

extension DetailsView: Updateable {
    func update(with model: DetailsViewModel) {
        guard !videoPlayer.isLoaded else {
            videoPlayer.seekPlayer()
            return
        }
        thumbnailPlayerView.update(with: .init(thumbnailURL: model.thumbnailURL))

        let url = URL(string: model.videoURL)
        videoPlayer.videoURL = url
        videoPlayer.view.frame = videoPlayerContainerView.bounds
        videoPlayerContainerView.insertSubview(videoPlayer.view, belowSubview: thumbnailPlayerView)
        attachVideoPlayerToParent()

        titleView.text = model.title
        descriptionView.text = model.description
    }

    private func attachVideoPlayerToParent() {
        guard let parent = parent else { return }
        videoPlayer.removeFromParent()
        parent.addChild(videoPlayer)
        videoPlayer.didMove(toParent: parent)
    }
}
