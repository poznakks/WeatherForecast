//
//  DailyForecastCell.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 23.03.2024.
//

import UIKit
import Combine

final class DailyForecastCell: UITableViewCell {

    static let identifier = String(describing: DailyForecastCell.self)

    private var cancellables: Set<AnyCancellable> = []

    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        return label
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var minTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .medium, design: .rounded)
        label.textAlignment = .center
        return label
    }()

    private lazy var maxTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .medium, design: .rounded)
        label.textAlignment = .center
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupBackground()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        dayLabel.text = nil
        iconImageView.image = nil
        minTempLabel.text = nil
        maxTempLabel.text = nil
    }

    func configure(with viewModel: DailyForecastCellViewModel) {
        dayLabel.text = viewModel.day
        iconImageView.image = viewModel.icon
        minTempLabel.text = viewModel.minTemp
        maxTempLabel.text = viewModel.maxTemp

        viewModel.$icon
            .receive(on: DispatchQueue.main)
            .sink { [weak self] icon in
                self?.iconImageView.image = icon
            }
            .store(in: &cancellables)
    }

    private func setupBackground() {
        backgroundColor = .systemCyan
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView = blurEffectView
    }

    private func setupConstraints() {
        let stack: UIStackView = {
            let stackView = UIStackView(
                arrangedSubviews: [dayLabel, iconImageView, minTempLabel, maxTempLabel]
            )
            stackView.axis = .horizontal
            stackView.spacing = 8
            stackView.distribution = .fillEqually
            stackView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(stackView)
            return stackView
        }()

        NSLayoutConstraint.pinEdgesToSuperview(stack)
    }
}
