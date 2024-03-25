//
//  HourlyForecastCollectionView.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 22.03.2024.
//

import UIKit

final class HourlyForecastCollectionView: UICollectionView {

    private var hourlyForecasts: [HourlyWeather] = []

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setHourlyForecasts(_ forecasts: [HourlyWeather]) {
        hourlyForecasts = forecasts
        reloadData()
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemCyan
        layer.cornerRadius = 16
        layer.masksToBounds = true
        showsHorizontalScrollIndicator = false
        delegate = self
        dataSource = self
        register(HourlyForecastCell.self, forCellWithReuseIdentifier: HourlyForecastCell.identifier)

        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView = blurEffectView
    }
}

extension HourlyForecastCollectionView: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        hourlyForecasts.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: HourlyForecastCell.identifier,
            for: indexPath
        ) as? HourlyForecastCell else { return UICollectionViewCell() }
        let forecast = hourlyForecasts[indexPath.item]
        let viewModel = HourlyForecastCellViewModel(
            forecast: forecast,
            isNow: indexPath.row == 0
        )
        cell.configure(with: viewModel)
        return cell
    }
}

extension HourlyForecastCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: bounds.width * 0.2, height: bounds.height * 0.8)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        0
    }
}
