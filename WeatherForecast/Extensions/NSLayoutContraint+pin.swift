//
//  NSLayoutContraint+pin.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 25.03.2024.
//

import UIKit

extension NSLayoutConstraint {
    static func pinEdgesToSuperview(_ view: UIView, edgeInset: CGFloat = 0) {
        guard let superview = view.superview else {
            assertionFailure("View must have a superview to pin to")
            return
        }

        view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            view.topAnchor.constraint(equalTo: superview.topAnchor),
            view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: edgeInset),
            view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -edgeInset),
            view.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ]
        activate(constraints)
    }

    static func pinEdgesToSuperviewSafeArea(_ view: UIView, edgeInset: CGFloat = 0) {
        guard let superview = view.superview else {
            assertionFailure("View must have a superview to pin to")
            return
        }

        view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            view.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor),
            view.leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor, constant: edgeInset),
            view.trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor, constant: -edgeInset),
            view.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor)
        ]
        activate(constraints)
    }

    static func pinTopToSuperView(_ view: UIView, offset: CGFloat = 0) {
        guard let superview = view.superview else {
            assertionFailure("View must have a superview to pin to")
            return
        }

        view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            view.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: offset)
        ]
        activate(constraints)
    }

    static func pinBottomToSuperView(_ view: UIView, offset: CGFloat = 0) {
        guard let superview = view.superview else {
            assertionFailure("View must have a superview to pin to")
            return
        }

        view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            view.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: offset)
        ]
        activate(constraints)
    }

    static func pinLeadingTrailingToSuperview(_ view: UIView, edgeInset: CGFloat = 0) {
        guard let superview = view.superview else {
            assertionFailure("View must have a superview to pin to")
            return
        }

        view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            view.leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor, constant: edgeInset),
            view.trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor, constant: -edgeInset)
        ]
        activate(constraints)
    }

    static func pinTop(_ view: UIView, to toView: UIView, offset: CGFloat = 0) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            view.topAnchor.constraint(equalTo: toView.bottomAnchor, constant: offset)
        ]
        activate(constraints)
    }

    static func pinToSuperviewCenter(_ view: UIView) {
        guard let superview = view.superview else {
            assertionFailure("View must have a superview to pin to")
            return
        }

        view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            view.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ]
        activate(constraints)
    }
}
