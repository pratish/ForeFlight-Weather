//
//  AirportManager.swift
//  ForeFlight Weather
//
//  Created by Pratish Karmacharya on 2/24/24.
//

import Foundation

/// Start of an airport manager class. This class should really be the one managing all available
/// airports. This should have a "favorite" list or something similar, and for the given set of
/// airports, it will auto refresh. 
class AirportManager {
    var airportList: [AirportModel] = []
    
    init() {}
    
    func addAirport(airport: AirportModel){
        airportList.append(airport)
    }
        
}
