//
//  WeatherForecast.swift
//  ForeFlight Weather
//
//  Created by Pratish Karmacharya on 2/23/24.
//

import Foundation
public protocol Readable {}


public struct WeatherReport: Readable {
    public var report: Report
}

public struct Report: Codable {
    public var conditions: Conditions?
    public var forecast: Forecast?
    public var wind: WindsAloft?
    public var mos: MOS?
}

extension Report {
    enum CodingKeys: String, CodingKey {
        case conditions = "conditions"
        case forecast = "forecast"
        case wind = "windsAloft"
        case mos = "mos"
    }
}




extension WeatherReport: Codable {
}




