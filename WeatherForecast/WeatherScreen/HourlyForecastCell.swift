//
//  HourlyForecastCell.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 22.03.2024.
//

import UIKit
import Combine

final class HourlyForecastCell: UICollectionViewCell {

    static let identifier = String(describing: HourlyForecastCell.self)

    private var cancellables: Set<AnyCancellable> = []

    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .medium, design: .rounded)
        label.textAlignment = .center
        return label
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .medium, design: .rounded)
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let service: WeatherService = WeatherServiceImpl()

    override func prepareForReuse() {
        super.prepareForReuse()
        timeLabel.text = nil
        iconImageView.image = nil
        tempLabel.text = nil
    }

    func configure(with viewModel: HourlyForecastCellViewModel) {
        timeLabel.text = viewModel.time
        tempLabel.text = viewModel.temp

        viewModel.$icon
            .receive(on: DispatchQueue.main)
            .sink { [weak self] icon in
                self?.iconImageView.image = icon
            }
            .store(in: &cancellables)
    }

    private func setupConstraints() {
        let stack: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [timeLabel, iconImageView, tempLabel])
            stackView.axis = .vertical
            stackView.spacing = 0
            stackView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(stackView)
            return stackView
        }()

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
