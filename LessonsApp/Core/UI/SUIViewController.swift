//
//  SUIViewController.swift
//  LessonsApp
//
//  Created by Elton Jhony on 28/02/23.
//

import Foundation
import UIKit
import SwiftUI
import Combine

public class SUIViewController<Presenter>: UIViewController where Presenter: SUIPresentable {

    private let presenter: Presenter
    private var navigationBarData: SUIPresentableNavigationBar?

    private var hostingController: UIHostingController<AnyView>?
    private var hostingView: SUIView?

    private var supportedOrientations: UIInterfaceOrientationMask

    private var cancellables = [AnyCancellable]()

    public init<V: View>(view: V, presenter: Presenter, imagePresenter: ImagePresentable? = nil, supportedOrientations: UIInterfaceOrientationMask = .portrait) {
        self.presenter = presenter
        self.supportedOrientations = supportedOrientations
        let viewWithEnv = view
            .environmentObject(SUIImagePresenter(presenter: imagePresenter))

        hostingController = UIHostingController<AnyView>(rootView: AnyView(viewWithEnv))
        super.init(nibName: nil, bundle: nil)
        addChild(hostingController!, toCover: self.view)
        updateNavigationBar()
    }

    public init<V: SUIView>(view: V, presenter: Presenter, imagePresenter: ImagePresentable? = nil, supportedOrientations: UIInterfaceOrientationMask = .portrait) {
        self.presenter = presenter
        self.supportedOrientations = supportedOrientations
        hostingView = view
        super.init(nibName: nil, bundle: nil)
        updateNavigationBar()
    }

    @available(*, unavailable)
    @objc public dynamic required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func loadView() {
        super.loadView()
        view.backgroundColor = .secondarySystemBackground
        if let hostingView = hostingView {
            view.addAligned(subView: hostingView)
        }
    }

    override public var shouldAutorotate: Bool {
        false
    }

    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        supportedOrientations
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.sizeToFit()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        presenter.rightBarButtons.sink(receiveValue: { [weak self] buttons in
            self?.setRightBarButtons(buttons)
        }).store(in: &cancellables)

        hostingView?.parent = self
        presenter.onAppear()
    }

}

// MARK: - Navigation Bar

private extension SUIViewController {

    var hideNativeNavigationBar: Bool {
        presenter.navigationBar == nil
    }

    func updateNavigationBar() {
        navigationController?.isNavigationBarHidden = hideNativeNavigationBar
        guard presenter.navigationBar != navigationBarData else {
            return
        }
        navigationBarData = presenter.navigationBar
        guard let data = navigationBarData else {
            return
        }
        navigationItem.title = data.title
        navigationItem.largeTitleDisplayMode = data.largeTitle ? .always : .never
    }

    func setRightBarButtons(_ buttons: [ButtonModel]) {
        navigationItem.rightBarButtonItem = UIBarButtonItem()
        buttons.forEach { buttonModel in
            let customView = UIButton()
            if let icon = buttonModel.icon {
                customView.setImage(UIImage(systemName: icon), for: .normal)
            }
            customView.setTitle(buttonModel.title, for: .normal)
            customView.setTitleColor(.link, for: .normal)
            customView.tintColor = .link
            navigationItem.rightBarButtonItem?.customView = customView
            navigationItem.rightBarButtonItem?.customView?.gesture().sink(receiveValue: { _ in
                buttonModel.action()
            }).store(in: &cancellables)
        }
    }
}
