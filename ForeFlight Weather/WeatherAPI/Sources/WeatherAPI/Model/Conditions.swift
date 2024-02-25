//
//  Conditions.swift
//  ForeFlight Weather
//
//  Created by Pratish Karmacharya on 2/23/24.
//

import Foundation

public struct Conditions: Codable {
    public var dateIssued: String? = nil
    public var densityAltitudeFt: Int? = nil
    public var dewpointC: Int32? = nil
    public var elevationFt: Int32? = nil
    public var flightRules: String? = nil
    public var ident: String? = nil
    public var lat: Double? = nil
    public var lon: Double? = nil
    public var pressureHg: Double? = nil
    public var pressureHpa: Double? = nil
    public var relativeHumidity: Int? = nil
    public var reportedAsHpa: Bool? = nil
    public var tempC: Int? = nil
    public var text: String? = nil
    public var weather: [String]? = nil
    public var cloudLayer: [CloudLayer]? = nil
    public var cloudLayerV2: [CloudLayer]? = nil
    public var visibility: Visibility? = nil
    public var wind: Wind? = nil
    
//    public init() {
//        
//    }
//    
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.text = try container.decode(String.self, forKey: .text)
//        self.ident = try container.decode(String.self, forKey: .ident)
//        self.dateIssued = try container.decode(String.self, forKey: .dateIssued)
//    }
    
}

public struct CloudLayer: Codable {
    public var altitudeFt: Int? = nil
    public var ceiling: Bool? = nil
    public var coverage: String? = nil
}

public struct Visibility: Codable {
    public var distanceSm: Double? = nil
    public var prevailingVisSm: Double? = nil
}

public struct Wind: Codable {
    public var direction: Int? = nil
    public var from: Int? = nil
    public var speedKts: Double? = nil
    public var variable: Bool? = nil
}
