//
//  WeatherRequest.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 24.03.2024.
//

import Foundation
import CoreLocation

struct WeatherRequest: NetworkRequest {
    typealias Response = WeatherResponse

    let host: String = "api.openweathermap.org"
    let path: String = "/data/3.0/onecall"
    let httpMethod: HttpMethod = .GET
    let queryItems: [URLQueryItem]?
    let cachePolicy: CachePolicy = .oneHour
    let timeoutInterval: TimeInterval = 10

    init(coordinate: CLLocationCoordinate2D) {
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "lat", value: String(coordinate.latitude)),
            URLQueryItem(name: "lon", value: String(coordinate.longitude)),
            URLQueryItem(name: "appid", value: "166d2e67f7150d578498870ed9dd83c8"),
            URLQueryItem(name: "exclude", value: "minutely,alerts"),
            URLQueryItem(name: "units", value: "metric")
        ]
        self.queryItems = queryItems
    }
}
