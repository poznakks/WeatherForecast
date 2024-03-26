//
//  Array+prefix.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 25.03.2024.
//

import Foundation

extension Array {
    func prefix(_ maxLength: Int) -> [Element] {
        let endIndex = Swift.min(maxLength, count)
        return Array(self[..<endIndex])
    }
}
