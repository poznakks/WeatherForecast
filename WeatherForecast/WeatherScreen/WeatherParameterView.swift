//
//  WeatherParameterView.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 25.03.2024.
//

import UIKit

final class WeatherParameterView: UIView {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .medium, design: .rounded)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
    }()

    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 30, weight: .bold, design: .rounded)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setParameter(name: String, value: String) {
        titleLabel.text = name
        valueLabel.text = value
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 16
        layer.masksToBounds = true
        setupBackground()
    }

    private func setupBackground() {
        backgroundColor = .systemCyan
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurEffectView, at: 0)
    }

    private func setupConstraints() {
        NSLayoutConstraint.pinTopToSuperView(titleLabel, offset: 8)
        NSLayoutConstraint.pinLeadingTrailingToSuperview(titleLabel)

        valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        NSLayoutConstraint.pinLeadingTrailingToSuperview(valueLabel)
    }
}
