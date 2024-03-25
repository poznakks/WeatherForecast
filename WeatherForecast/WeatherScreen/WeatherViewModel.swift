//
//  WeatherViewModel.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 25.03.2024.
//

import Foundation
import CoreLocation
import Combine

@MainActor
final class WeatherViewModel: ObservableObject {

    @Published private(set) var city: String?
    @Published private(set) var weatherInfo: WeatherResponse?

    private let service: WeatherService = WeatherServiceImpl()
    private let locationManager = LocationManager()

    private var cancellables: Set<AnyCancellable> = []

    init(coordinate: CLLocationCoordinate2D? = nil) {
        if let coordinate {
            getWeatherInfo(for: coordinate)
        } else {
            subscribeOnLocationManager()
        }
    }

    private func getWeatherInfo(for coordinate: CLLocationCoordinate2D) {
        Task {
            let city = await locationManager.getLocationByCoordinate(coordinate: coordinate)
            let weatherInfo = try await service.weather(coordinate: coordinate)
            self.city = city
            self.weatherInfo = weatherInfo
        }
    }

    private func subscribeOnLocationManager() {
        locationManager.$currentUserCoordinate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newLocation in
                guard let self, let newLocation else { return }
                self.getWeatherInfo(for: newLocation)
            }
            .store(in: &cancellables)
    }
}
