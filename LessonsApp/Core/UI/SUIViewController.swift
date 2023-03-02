//
//  SUIViewController.swift
//  LessonsApp
//
//  Created by Elton Jhony on 28/02/23.
//

import Foundation
import UIKit
import SwiftUI

public class SUIViewController<Presenter>: UIViewController where Presenter: SUIPresentable {

    private let presenter: Presenter
    private var navigationBarData: SUIPresentableNavigationBar?

    private var hostingController: UIHostingController<AnyView>?
    private var hostingView: SUIView?

    private var supportedOrientations: UIInterfaceOrientationMask

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
        if let hostingView = hostingView {
            view.addAligned(subView: hostingView)
            updateBarTintColor()
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
        updateNavigationBar()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        hostingView?.parent = self
        presenter.onAppear()
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.updateBarTintColor()
    }

    private func updateBarTintColor() {
        let style = UITraitCollection.current.userInterfaceStyle
        view.backgroundColor = style == .dark ? .black : .white
        navigationController?.navigationBar.tintColor = style == .dark ? .white : .black
    }
}

// MARK: - Navigation Bar

private extension SUIViewController {

    var hideNativeNavigationBar: Bool {
        presenter.navigationBar == nil
    }

    func updateNavigationBar() {
        navigationController?.isNavigationBarHidden = hideNativeNavigationBar
        navigationItem.setHidesBackButton(presenter.navigationBar?.isBackButtonHidden == true, animated: false)
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
}
