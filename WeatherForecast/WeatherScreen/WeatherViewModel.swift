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
    @Published private(set) var errorMessage: String?

    private let service: WeatherService
    private let locationManager = LocationManager()

    private var task: Task<Void, Never>?
    private var cancellables: Set<AnyCancellable> = []

    init(coordinate: CLLocationCoordinate2D? = nil, service: WeatherService = WeatherServiceImpl()) {
        self.service = service
        if let coordinate {
            getWeatherInfo(for: coordinate)
        } else {
            subscribeOnLocationManager()
        }
    }

    deinit {
        task?.cancel()
    }

    func resetError() {
        errorMessage = nil
    }

    private func getWeatherInfo(for coordinate: CLLocationCoordinate2D) {
        task = Task {
            do {
                let city = await locationManager.getLocationByCoordinate(coordinate: coordinate)
                guard !Task.isCancelled else { return }
                let weatherInfo = try await service.weather(coordinate: coordinate)
                self.city = city
                self.weatherInfo = weatherInfo
            } catch {
                handleError(error as? NetworkError)
            }
        }
    }

    private func handleError(_ error: NetworkError?) {
        switch error {
        case .noInternetConnection:
            errorMessage = "You are not connected to the Internet. Connect and try again."
        case .timeout:
            errorMessage = "Connection timed out. Try again."
        default:
            errorMessage = "Something went wrong. Try again."
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
