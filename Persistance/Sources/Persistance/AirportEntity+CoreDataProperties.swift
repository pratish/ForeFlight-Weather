//
//  AirportEntity+CoreDataProperties.swift
//  ForeFlight Weather
//
//  Created by Pratish Karmacharya on 2/24/24.
//
//

import Foundation
import CoreData


extension AirportEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AirportEntity> {
        return NSFetchRequest<AirportEntity>(entityName: "AirportEntity")
    }

    @NSManaged public var identifier: String?
    @NSManaged public var weather: WeatherReportEntity?

}

extension AirportEntity : Identifiable {

}
