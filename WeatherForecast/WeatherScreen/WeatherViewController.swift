//
//  WeatherViewController.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 25.03.2024.
//

import UIKit
import Combine

final class WeatherViewController: UIViewController {

    private let viewModel: WeatherViewModel
    private var cancellables: Set<AnyCancellable> = []

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        return contentView
    }()

    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 40, weight: .medium, design: .rounded)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()

    private lazy var currentTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 70, weight: .medium, design: .rounded)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()

    private lazy var feelsLikeTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 25, weight: .medium, design: .rounded)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()

    private lazy var currentDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 25, weight: .medium, design: .rounded)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()

    private lazy var hourlyForecastCollectionView: HourlyForecastCollectionView = {
        let collectionView = HourlyForecastCollectionView()
        contentView.addSubview(collectionView)
        return collectionView
    }()

    private lazy var dailyForecastTableView: DailyForecastTableView = {
        let tableView = DailyForecastTableView()
        contentView.addSubview(tableView)
        return tableView
    }()

    private lazy var sunriseView = WeatherParameterView()
    private lazy var sunsetView = WeatherParameterView()

    private lazy var pressureView = WeatherParameterView()
    private lazy var humidityView = WeatherParameterView()

    private lazy var cloudsView = WeatherParameterView()
    private lazy var visibilityView = WeatherParameterView()

    private lazy var windSpeedView = WeatherParameterView()
    private lazy var windDirectionView = WeatherParameterView()

    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
        subscribeOnViewModel()
        setupConstraints()
    }

    private func subscribeOnViewModel() {
        viewModel.$city
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] city in
                self?.cityLabel.text = city
            }
            .store(in: &cancellables)

        viewModel.$weatherInfo
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] weatherInfo in
                self?.updateWithWeatherInfo(weatherInfo)
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] errorMessage in
                self?.showAlert(errorMessage) { _ in
                    self?.viewModel.resetError()
                }
            }
            .store(in: &cancellables)
    }

    private func updateWithWeatherInfo(_ weatherInfo: WeatherResponse?) {
        guard let weatherInfo else { return }

        currentTempLabel.text = "\(Int(weatherInfo.current.temp))º"
        feelsLikeTempLabel.text = "Feels like \(Int(weatherInfo.current.feelsLike))º"
        currentDescriptionLabel.text = weatherInfo.current.weather.first?.description.capitalized

        let hourly = weatherInfo.hourly.prefix(24)
        hourlyForecastCollectionView.setHourlyForecasts(hourly)

        let daily = weatherInfo.daily
        dailyForecastTableView.setDailyForecasts(daily)

        sunriseView.setParameter(
            name: "Sunrise",
            value: weatherInfo.current.time(of: weatherInfo.current.sunrise)
        )

        sunsetView.setParameter(
            name: "Sunset",
            value: weatherInfo.current.time(of: weatherInfo.current.sunset)
        )

        pressureView.setParameter(
            name: "Pressure",
            value: "\(weatherInfo.current.pressure) hPa"
        )

        humidityView.setParameter(
            name: "Humidity",
            value: "\(weatherInfo.current.humidity)%"
        )

        cloudsView.setParameter(
            name: "Clouds",
            value: "\(weatherInfo.current.clouds)%"
        )

        visibilityView.setParameter(
            name: "Visibility",
            value: "\(weatherInfo.current.visibility) m"
        )

        windSpeedView.setParameter(
            name: "Wind Speed",
            value: "\(Int(weatherInfo.current.windSpeed)) m/s"
        )

        windDirectionView.setParameter(
            name: "Wind direction",
            value: "\(weatherInfo.current.windDeg) deg"
        )
    }

    private func setupConstraints() {
        NSLayoutConstraint.pinEdgesToSuperviewSafeArea(scrollView)

        NSLayoutConstraint.pinEdgesToSuperview(contentView)
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

        NSLayoutConstraint.pinTopToSuperView(cityLabel, offset: 30)
        NSLayoutConstraint.pinLeadingTrailingToSuperview(cityLabel, edgeInset: 20)

        NSLayoutConstraint.pinTop(currentTempLabel, to: cityLabel, offset: 10)
        NSLayoutConstraint.pinLeadingTrailingToSuperview(currentTempLabel, edgeInset: 20)

        NSLayoutConstraint.pinTop(feelsLikeTempLabel, to: currentTempLabel, offset: 10)
        NSLayoutConstraint.pinLeadingTrailingToSuperview(feelsLikeTempLabel, edgeInset: 20)

        NSLayoutConstraint.pinTop(currentDescriptionLabel, to: feelsLikeTempLabel, offset: 10)
        NSLayoutConstraint.pinLeadingTrailingToSuperview(currentDescriptionLabel, edgeInset: 20)

        NSLayoutConstraint.pinTop(hourlyForecastCollectionView, to: currentDescriptionLabel, offset: 16)
        NSLayoutConstraint.pinLeadingTrailingToSuperview(hourlyForecastCollectionView, edgeInset: 20)
        hourlyForecastCollectionView.heightAnchor.constraint(equalToConstant: 120).isActive = true

        NSLayoutConstraint.pinTop(dailyForecastTableView, to: hourlyForecastCollectionView, offset: 16)
        NSLayoutConstraint.pinLeadingTrailingToSuperview(dailyForecastTableView, edgeInset: 20)

        let sunriseSunsetStack = makeWeatherParametersStack(from: [sunriseView, sunsetView])

        NSLayoutConstraint.pinTop(sunriseSunsetStack, to: dailyForecastTableView, offset: 16)
        NSLayoutConstraint.pinLeadingTrailingToSuperview(sunriseSunsetStack, edgeInset: 20)

        let pressureHumidityStack = makeWeatherParametersStack(from: [pressureView, humidityView])

        NSLayoutConstraint.pinTop(pressureHumidityStack, to: sunriseSunsetStack, offset: 16)
        NSLayoutConstraint.pinLeadingTrailingToSuperview(pressureHumidityStack, edgeInset: 20)

        let cloudsVisibilityStack = makeWeatherParametersStack(from: [cloudsView, visibilityView])

        NSLayoutConstraint.pinTop(cloudsVisibilityStack, to: pressureHumidityStack, offset: 16)
        NSLayoutConstraint.pinLeadingTrailingToSuperview(cloudsVisibilityStack, edgeInset: 20)

        let windStack = makeWeatherParametersStack(from: [windSpeedView, windDirectionView])

        NSLayoutConstraint.pinTop(windStack, to: cloudsVisibilityStack, offset: 16)
        NSLayoutConstraint.pinLeadingTrailingToSuperview(windStack, edgeInset: 20)
        NSLayoutConstraint.pinBottomToSuperView(windStack, offset: -30)
    }

    private func makeWeatherParametersStack(from views: [UIView]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: views)
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)

        views.forEach { $0.heightAnchor.constraint(equalToConstant: 120).isActive = true }

        return stack
    }
}
