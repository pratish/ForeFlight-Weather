//
//  WeatherReportEntity+CoreDataProperties.swift
//  ForeFlight Weather
//
//  Created by Pratish Karmacharya on 2/24/24.
//
//

import Foundation
import CoreData


extension WeatherReportEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherReportEntity> {
        return NSFetchRequest<WeatherReportEntity>(entityName: "WeatherReportEntity")
    }

    @NSManaged public var conditions: ConditionsEntity?
    @NSManaged public var forecast: ForecastEntity?

}

extension WeatherReportEntity : Identifiable {

}
