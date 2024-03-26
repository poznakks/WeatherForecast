//
//  DailyForecastCellViewModel.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 25.03.2024.
//

import UIKit
import Combine

@MainActor
final class DailyForecastCellViewModel: ObservableObject {

    @Published private(set) var icon: UIImage?

    let day: String
    let minTemp: String
    let maxTemp: String

    private let service: WeatherService = WeatherServiceImpl()

    init(forecast: DailyWeather, isToday: Bool) {
        self.day = isToday ? "Today" : forecast.day
        self.minTemp = "\(Int(forecast.temp.min))°"
        self.maxTemp = "\(Int(forecast.temp.max))°"
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
