//
//  DetailsView.swift
//  LessonsApp
//
//  Created by Elton Jhony on 28/02/23.
//

import Foundation
import Combine
import UIKit

public struct DetailsViewModel {
    let title: String
    let description: String
    let videoURL: String
    let thumbnailURL: String
    let nextLessonAction: () -> Void
    let cancelDownloadAction: () -> Void
}

private enum Constants {
    static let videoPlayerHeight: CGFloat = 250
    static let regularHorizontalPadding: CGFloat = 16
}

final class DetailsView<Presenter: DetailsPresentable>: SUIView {

    private let presenter: Presenter
    private let imagePresenter: ImagePresenter
    
    private var cancellables = [AnyCancellable]()

    private lazy var videoPlayerController: VideoPlayerController = {
        let controller = VideoPlayerController()
        return controller
    }()

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
        view.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        view.textAlignment = .left
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = 0
        return view
    }()

    private lazy var descriptionView: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.textAlignment = .left
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = 0
        return view
    }()

    private lazy var nextLessonButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Next lesson", for: .normal)
        view.setTitleColor(.link, for: .normal)
        view.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        view.tintColor = .link
        view.semanticContentAttribute = .forceRightToLeft
        return view
    }()

    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.frame = CGRect(x: 10, y: 60, width: 250, height: 0)
        progressView.tintColor = .orange
        return progressView
    }()

    private lazy var downloadProgressController: UIAlertController = {
        let alertController = UIAlertController(title: "Downloading...", message: "\n\n", preferredStyle: .alert)
        alertController.view.addSubview(progressView)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            self?.model?.cancelDownloadAction()
        }
        alertController.addAction(cancelAction)
        return alertController
    }()

    private var model: DetailsViewModel?

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
            videoPlayerController.goFullScreen()
        }
    }

    func setup() {
        addSubview(videoPlayerContainerView)
        videoPlayerContainerView.addSubview(thumbnailPlayerView)
        addSubview(titleView)
        addSubview(descriptionView)
        addSubview(nextLessonButton)

        videoPlayerController.view.frame = videoPlayerContainerView.bounds
        videoPlayerContainerView.insertSubview(videoPlayerController.view, belowSubview: thumbnailPlayerView)

        setupConstraints()
        sinkSubscriptions()
    }

    private func setupConstraints() {
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
        NSLayoutConstraint.activate([
            nextLessonButton.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: Constants.regularHorizontalPadding),
            nextLessonButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.regularHorizontalPadding)
        ])
    }

    private func sinkSubscriptions() {
        presenter.data.sink { [weak self] model in
            guard let model = model else { return }
            self?.videoPlayerController.resetPlayer()
            self?.update(with: model)
        }.store(in: &cancellables)

        thumbnailPlayerView.gesture().sink { [weak self] _ in
            self?.thumbnailPlayerView.isHidden = true
            self?.videoPlayerController.player?.play()
        }.store(in: &cancellables)

        nextLessonButton.gesture().sink { [weak self] _ in
            self?.model?.nextLessonAction()
        }.store(in: &cancellables)

        presenter.downloadState.sink { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .downloaded, .cancelled:
                self.downloadProgressController.dismiss(animated: true)
            case let .inProgress(value):
                self.progressView.setProgress(value, animated: true)
                self.present(self.downloadProgressController)
            default: break
            }
        }.store(in: &cancellables)

        NotificationCenter.default.addObserver(
            self, selector: #selector(orientationDidChange),
            name: UIDevice.orientationDidChangeNotification, object: nil
        )
    }

}

extension DetailsView: Updateable {
    func update(with model: DetailsViewModel) {
        self.model = model

        guard !videoPlayerController.isLoaded else {
            videoPlayerController.seekPlayer()
            return
        }

        thumbnailPlayerView.isHidden = false
        thumbnailPlayerView.update(with: .init(thumbnailURL: model.thumbnailURL))

        videoPlayerController.videoURL = URL(string: model.videoURL)
        moveChildToParent(videoPlayerController)
        
        titleView.text = model.title
        descriptionView.text = model.description
    }
}
