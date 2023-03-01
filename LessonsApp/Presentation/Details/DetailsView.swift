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
    let videoURL: String
    let thumbnailURL: String
}

private enum Constants {
    static let videoPlayerHeight: CGFloat = 250
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
        NSLayoutConstraint.activate([
            videoPlayerContainerView.topAnchor.constraint(equalTo: topAnchor, constant: .zero),
            videoPlayerContainerView.heightAnchor.constraint(equalToConstant: Constants.videoPlayerHeight),
            videoPlayerContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .zero),
            videoPlayerContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: .zero)
        ])
        NSLayoutConstraint.activate([
            thumbnailPlayerView.topAnchor.constraint(equalTo: videoPlayerContainerView.topAnchor, constant: .zero),
            thumbnailPlayerView.bottomAnchor.constraint(equalTo: videoPlayerContainerView.bottomAnchor, constant: .zero),
            thumbnailPlayerView.leadingAnchor.constraint(equalTo: videoPlayerContainerView.leadingAnchor, constant: .zero),
            thumbnailPlayerView.trailingAnchor.constraint(equalTo: videoPlayerContainerView.trailingAnchor, constant: .zero)
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
    }

    private func attachVideoPlayerToParent() {
        guard let parent = parent else { return }
        videoPlayer.removeFromParent()
        parent.addChild(videoPlayer)
        videoPlayer.didMove(toParent: parent)
    }
}
