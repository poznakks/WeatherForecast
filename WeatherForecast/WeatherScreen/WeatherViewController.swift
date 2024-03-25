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
        label.font = .systemFont(ofSize: 40)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()

    private lazy var currentTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 70)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()

    private lazy var feelsLikeTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 25)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        return label
    }()

    private lazy var currentDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 25)
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
            .sink { [weak self] city in
                self?.cityLabel.text = city
            }
            .store(in: &cancellables)

        viewModel.$weatherInfo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] weatherInfo in
                self?.updateWithWeatherInfo(weatherInfo)
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
    }

    private func setupConstraints() {
        NSLayoutConstraint.pinEdgesToSuperview(scrollView)

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

        NSLayoutConstraint.pinTop(hourlyForecastCollectionView, to: currentDescriptionLabel, offset: 30)
        NSLayoutConstraint.pinLeadingTrailingToSuperview(hourlyForecastCollectionView, edgeInset: 20)
        hourlyForecastCollectionView.heightAnchor.constraint(equalToConstant: 120).isActive = true

        NSLayoutConstraint.pinTop(dailyForecastTableView, to: hourlyForecastCollectionView, offset: 30)
        NSLayoutConstraint.pinLeadingTrailingToSuperview(dailyForecastTableView, edgeInset: 20)
        NSLayoutConstraint.pinBottomToSuperView(dailyForecastTableView)
    }
}

extension NSLayoutConstraint {
    static func pinEdgesToSuperview(_ view: UIView, edgeInset: CGFloat = 0) {
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
            view.topAnchor.constraint(equalTo: superview.topAnchor, constant: offset)
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
}

extension Array {
    func prefix(_ maxLength: Int) -> [Element] {
        let endIndex = Swift.min(maxLength, count)
        return Array(self[..<endIndex])
    }
}
