//
//  DailyForecastCell.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 23.03.2024.
//

import UIKit

final class DailyForecastCell: UITableViewCell {

    static let identifier = String(describing: DailyForecastCell.self)

    private lazy var dayLabel: UILabel = {
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

    private lazy var minTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private lazy var maxTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private let service: WeatherService = WeatherServiceImpl()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemMint
        setupConstraints()
    }

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

    func configure(with forecast: DailyWeather, isToday: Bool) {
        dayLabel.text = isToday ? "Today" : forecast.day
        Task {
            let icon = try await service.weatherIcon(iconName: forecast.weather.first!.icon)
            iconImageView.image = icon
        }
        minTempLabel.text = "\(Int(forecast.temp.min))°"
        maxTempLabel.text = "\(Int(forecast.temp.max))°"
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

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
