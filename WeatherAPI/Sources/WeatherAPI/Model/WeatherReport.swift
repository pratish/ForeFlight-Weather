//
//  WeatherForecast.swift
//  ForeFlight Weather
//
//  Created by Pratish Karmacharya on 2/23/24.
//

import Foundation

public struct WeatherReport {
    var report: Report
//    public let forecast: Forecast
//    public let windsAloft: WindsAloft
//    public let mos: MOS
}

struct Report: Codable {
    var conditions: Conditions
}

extension WeatherReport: Codable {
}




