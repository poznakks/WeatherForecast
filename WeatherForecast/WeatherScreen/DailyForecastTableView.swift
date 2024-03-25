//
//  DailyForecastTableView.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 23.03.2024.
//

import UIKit

final class DailyForecastTableView: UITableView {

    private var dailyForecasts: [DailyWeather] = []

    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        contentSize
    }

    init() {
        super.init(frame: .zero, style: .plain)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setDailyForecasts(_ forecasts: [DailyWeather]) {
        dailyForecasts = forecasts
        reloadData()
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemMint
        layer.cornerRadius = 16
        layer.masksToBounds = true
        isScrollEnabled = false
        allowsSelection = false
        dataSource = self
        delegate = self
        register(DailyForecastCell.self, forCellReuseIdentifier: DailyForecastCell.identifier)
    }
}

extension DailyForecastTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dailyForecasts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(
            withIdentifier: DailyForecastCell.identifier,
            for: indexPath
        ) as? DailyForecastCell else { return UITableViewCell() }
        let forecast = dailyForecasts[indexPath.row]
        let cellViewModel = DailyForecastCellViewModel(
            forecast: forecast,
            isToday: indexPath.row == 0
        )
        cell.configure(with: cellViewModel)
        return cell
    }
}

extension DailyForecastTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
}
