//
//  WeatherEndpoint.swift
//  ForeFlight Weather
//
//  Created by Pratish Karmacharya on 2/23/24.
//

import Foundation

struct Endpoint {
    var path: String
}

extension Endpoint {
    static func airportWeather(withAirportIdentifier id: String) -> Self {
        return Endpoint(path: "weather/report/\(id)")
    }
}

extension Endpoint {
    var url: URL {
        return urlBuilder()
    }
    
    private func urlBuilder() -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "qa.foreflight.com"
        components.path = "/" + path
        
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        return url
    }
    
}

