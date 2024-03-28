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

    private var task: Task<Void, Never>?
    private let service: WeatherService

    init(forecast: DailyWeather, isToday: Bool, service: WeatherService = WeatherServiceImpl()) {
        self.day = isToday ? "Today" : forecast.day
        self.minTemp = "\(Int(forecast.temp.min))°"
        self.maxTemp = "\(Int(forecast.temp.max))°"
        self.service = service
        self.getIcon(name: forecast.weather.first?.icon)
    }

    deinit {
        task?.cancel()
    }

    func getIcon(name: String?) {
        guard let name else { return }
        task = Task {
            let icon = try? await service.weatherIcon(iconName: name)
            // если картинка не пришла, то ее можно просто не отображать
            // на функциональность это никак не влияет
            // либо можно предусмотреть какую-нибудь placeholder картинку
            self.icon = icon
        }
    }
}
