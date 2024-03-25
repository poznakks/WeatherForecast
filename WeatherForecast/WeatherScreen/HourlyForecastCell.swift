//
//  HourlyForecastCell.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 22.03.2024.
//

import UIKit

final class HourlyForecastCell: UICollectionViewCell {

    static let identifier = String(describing: HourlyForecastCell.self)

    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
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
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }

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

    func configure(with forecast: HourlyWeather, isNow: Bool) {
        timeLabel.text = isNow ? "Now" : forecast.time
        Task {
            let icon = try await service.weatherIcon(iconName: forecast.weather.first!.icon)
            iconImageView.image = icon
        }
        tempLabel.text = "\(Int(forecast.temp))º"
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
