//
//  Forecast.swift
//  ForeFlight Weather
//
//  Created by Pratish Karmacharya on 2/23/24.
//

import Foundation
public struct Forecast: Codable {
    public var dateIssued: String? = nil
    public var elevation: Int? = nil
    public var ident: String? = nil
    public var text: String? = nil
    public var lat: Double? = nil
    public var lon: Double? = nil
    public var conditions: [Conditions]? = nil
  
}
