//
//  VideoPlayerController.swift
//  LessonsApp
//
//  Created by Elton Jhony on 28/02/23.
//

import AVKit

public final class VideoPlayerController: AVPlayerViewController {

    private var currentTime: CMTime = .zero
    private var timeObserverToken: Any?
    
    var videoURL: URL? {
        didSet {
            guard let videoURL = videoURL else { return }
            let player = AVPlayer(url: videoURL)
            self.player = player
            seekPlayer()
            isLoaded = true
        }
    }

    var isLoaded: Bool

    public init() {
        self.isLoaded = false
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    @objc public dynamic required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addTimeObserver()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeTimeObserver()
    }

    public func seekPlayer() {
        player?.seek(to: currentTime)
    }

    func addTimeObserver() {
        let interval = CMTime(seconds: 1.0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
            guard let self = self else { return }
            self.currentTime = time
        }
    }

    func removeTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }

}
