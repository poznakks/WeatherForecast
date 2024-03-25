//
//  HourlyForecastCellViewModel.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 25.03.2024.
//

import UIKit
import Combine

@MainActor
final class HourlyForecastCellViewModel: ObservableObject {

    @Published private(set) var icon: UIImage?

    let time: String
    let temp: String

    private let service: WeatherService = WeatherServiceImpl()

    init(forecast: HourlyWeather, isNow: Bool) {
        self.time = isNow ? "Now" : forecast.time
        self.temp = "\(Int(forecast.temp))°"
        self.getIcon(name: forecast.weather.first?.icon)
    }

    func getIcon(name: String?) {
        guard let name else { return }
        Task {
            let icon = try await service.weatherIcon(iconName: name)
            self.icon = icon
        }
    }
}
