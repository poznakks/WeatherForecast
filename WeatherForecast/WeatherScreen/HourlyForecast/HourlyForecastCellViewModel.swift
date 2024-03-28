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

    private let service: WeatherService

    private var task: Task<Void, Never>?

    init(forecast: HourlyWeather, isNow: Bool, service: WeatherService = WeatherServiceImpl()) {
        self.time = isNow ? "Now" : forecast.time
        self.temp = "\(Int(forecast.temp))°"
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
