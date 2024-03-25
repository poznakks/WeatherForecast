//
//  WeatherResponse.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 24.03.2024.
//

import Foundation

// MARK: - WeatherResponse
struct WeatherResponse: Decodable {
    let lat, lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: CurrentWeather
    let hourly: [HourlyWeather]
    let daily: [DailyWeather]
}

// MARK: - CurrentWeather
struct CurrentWeather: Decodable {
    let dt: Date
    let sunrise, sunset: Int?
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let clouds, visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [Weather]
}

// MARK: - HourlyWeather
struct HourlyWeather: Decodable {
    let dt: Date
    let temp: Double
    let weather: [Weather]

    var time: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: dt)
    }
}

// MARK: - DailyWeather
struct DailyWeather: Decodable {
    let dt: Date
    let temp: Temp
    let weather: [Weather]

    var day: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: dt)
    }
}

// MARK: - Temp
struct Temp: Decodable {
    let min, max: Double
}

// MARK: - Weather
struct Weather: Decodable {
    let id: Int
    let main, description, icon: String
}
