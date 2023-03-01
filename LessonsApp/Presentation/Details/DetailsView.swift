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
}

private enum Constants {
    static let videoPlayerHeight: CGFloat = 300
}

final class DetailsView<Presenter: DetailsPresentable>: SUIView {

    private let presenter: Presenter
    
    private var cancellables = [AnyCancellable]()

    private let videoPlayer: VideoPlayerController = .init()

    private lazy var videoPlayerContainerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    init(presenter: Presenter) {
        self.presenter = presenter
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        addSubview(videoPlayerContainerView)
        NSLayoutConstraint.activate([
            videoPlayerContainerView.topAnchor.constraint(equalTo: topAnchor, constant: .zero),
            videoPlayerContainerView.heightAnchor.constraint(equalToConstant: Constants.videoPlayerHeight),
            videoPlayerContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .zero),
            videoPlayerContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: .zero)
        ])

        sinkSubscriptions()
    }

    private func sinkSubscriptions() {
        presenter.data.sink { [weak self] model in
            guard let model = model else { return }
            self?.update(with: model)
        }.store(in: &cancellables)
    }
    
}

extension DetailsView: Updateable {
    func update(with model: DetailsViewModel) {
        guard !videoPlayer.isLoaded else {
            videoPlayer.seekPlayer()
            return
        }
        let url = URL(string: model.videoURL)
        videoPlayer.videoURL = url
        videoPlayer.view.frame = videoPlayerContainerView.bounds
        videoPlayerContainerView.addSubview(videoPlayer.view)
        attachVideoPlayerToParent()
    }

    private func attachVideoPlayerToParent() {
        guard let parent = parent else { return }
        videoPlayer.removeFromParent()
        parent.addChild(videoPlayer)
        videoPlayer.didMove(toParent: parent)
    }
}
