//
//  UIView.swift
//  LessonsApp
//
//  Created by Elton Jhony on 28/02/23.
//

import UIKit

public struct Constraints {
    public let top: NSLayoutConstraint
    public let trailing: NSLayoutConstraint
    public let bottom: NSLayoutConstraint
    public let leading: NSLayoutConstraint

    public var all: [NSLayoutConstraint] {
        [top, trailing, bottom, leading]
    }

    public var allButTop: [NSLayoutConstraint] {
        [trailing, leading, bottom]
    }

    public var allButBottom: [NSLayoutConstraint] {
        [top, trailing, leading]
    }

    public var allButLeading: [NSLayoutConstraint] {
        [top, bottom, trailing]
    }

    public var allButTrailing: [NSLayoutConstraint] {
        [top, bottom, leading]
    }

    public func activate() {
        NSLayoutConstraint.activate(all)
    }

    public init(top: NSLayoutConstraint, trailing: NSLayoutConstraint, bottom: NSLayoutConstraint, leading: NSLayoutConstraint) {
        self.top = top
        self.trailing = trailing
        self.bottom = bottom
        self.leading = leading
    }
}

public extension UIView {

    func addSubviews(_ views: [UIView]) {
        for view in views {
            addSubview(view)
        }
    }

    func addSubview(_ views: UIView...) {
        addSubviews(views)
    }

    @discardableResult
    func setAligned(subView view: UIView, constant: CGFloat = 0)
        -> Constraints
    {
        setAligned(subView: view, insets: UIEdgeInsets(top: constant, left: constant, bottom: constant, right: constant))
    }

    @discardableResult
    func setAligned(subView view: UIView, insets: UIEdgeInsets, activateConstraints: Bool = true, alignedToMargins: Bool = false)
        -> Constraints
    {
        let leading = view.leadingAnchor.constraint(equalTo: alignedToMargins ? layoutMarginsGuide.leadingAnchor : leadingAnchor, constant: insets.left)
        let trailing = view.trailingAnchor.constraint(equalTo: alignedToMargins ? layoutMarginsGuide.trailingAnchor : trailingAnchor, constant: -insets.right)
        let top = view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: insets.top)
        let bottom = view.bottomAnchor.constraint(equalTo: view.superview == nil ? view.safeAreaLayoutGuide.bottomAnchor : bottomAnchor, constant: -insets.bottom)

        if activateConstraints {
            NSLayoutConstraint.activate([leading, trailing, top, bottom])
        }
        return Constraints(top: top, trailing: trailing, bottom: bottom, leading: leading)
    }

    @discardableResult
    func insertAligned(_ subview: UIView, at index: Int, constant: CGFloat = 0, activateConstraints: Bool = true) -> Constraints {
        subview.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(subview, at: index)

        return setAligned(subView: subview, insets: UIEdgeInsets(constant: constant), activateConstraints: activateConstraints)
    }

    @discardableResult
    func addAligned(subView view: UIView, constant: CGFloat = 0, activateConstraints: Bool = true)
        -> Constraints
    {

        addAligned(subView: view, insets: UIEdgeInsets(constant: constant), activateConstraints: activateConstraints)
    }

    @discardableResult
    func addAligned(subView view: UIView, insets: UIEdgeInsets, activateConstraints: Bool = true)
        -> Constraints
    {

        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return setAligned(subView: view, insets: insets, activateConstraints: activateConstraints)
    }

    @discardableResult
    func addAlignedToMargins(subView view: UIView, constant: CGFloat = 0, activateConstraints: Bool = true)
        -> Constraints
    {

        addAlignedToMargins(subView: view, insets: UIEdgeInsets(constant: constant), activateConstraints: activateConstraints)
    }

    @discardableResult
    func addAlignedToMargins(subView view: UIView, insets: UIEdgeInsets, activateConstraints: Bool = true)
        -> Constraints
    {

        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return setAligned(subView: view, insets: insets, activateConstraints: activateConstraints, alignedToMargins: true)
    }

    func findFirstResponder() -> UIView? {

        if isFirstResponder {
            return self
        }

        for view in subviews {

            if let firstResponder = view.findFirstResponder() {
                return firstResponder
            }
        }

        return nil
    }
}

public extension Collection where Element: UIView {

    func removeAutoresizingMaskConstraints() {

        forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }
}

public extension UIEdgeInsets {

    // swiftlint:disable identifier_name
    /// Initializes a new instance of `UIEdgeInsets`
    /// - Parameters:
    ///   - x: a constant applied to `left` and `right`
    ///   - y: a constant applied to `top` and `bottom`
    init(x: CGFloat, y: CGFloat) {
        self.init(top: y, left: x, bottom: y, right: x)
    }

    // swiftlint:enable identifier_name

    init(constant: CGFloat) {
        self.init(top: constant, left: constant, bottom: constant, right: constant)
    }
}

