//
//  WeatherService.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 24.03.2024.
//

import Foundation
import CoreLocation

protocol WeatherService: AnyObject {
    func weather(coordinate: CLLocationCoordinate2D) async throws -> WeatherResponse
    func weatherIcon(iconName: String) async throws -> WeatherIconResponse
}

final class WeatherServiceImpl: WeatherService {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = NetworkClientImpl()) {
        self.networkClient = networkClient
    }

    func weather(coordinate: CLLocationCoordinate2D) async throws -> WeatherResponse {
        let weatherRequest = WeatherRequest(coordinate: coordinate)
        return try await networkClient.send(request: weatherRequest)
    }

    func weatherIcon(iconName: String) async throws -> WeatherIconResponse {
        let iconRequest = WeatherIconRequest(iconName: iconName)
        return try await networkClient.send(request: iconRequest)
    }
}
