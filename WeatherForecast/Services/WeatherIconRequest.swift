//
//  WeatherIconRequest.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 24.03.2024.
//

import Foundation

struct WeatherIconRequest: NetworkRequest {
    typealias Response = WeatherIconResponse

    let host: String = "openweathermap.org"
    let path: String
    let httpMethod: HttpMethod = .GET
    let queryItems: [URLQueryItem]? = nil
    let cachePolicy: CachePolicy = .noCache
    let timeoutInterval: TimeInterval = 10

    init(iconName: String) {
        self.path = "/img/wn/\(iconName)@2x.png"
    }
}
