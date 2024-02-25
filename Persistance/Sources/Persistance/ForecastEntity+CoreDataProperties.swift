//
//  ForecastEntity+CoreDataProperties.swift
//  ForeFlight Weather
//
//  Created by Pratish Karmacharya on 2/24/24.
//
//

import Foundation
import CoreData


extension ForecastEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForecastEntity> {
        return NSFetchRequest<ForecastEntity>(entityName: "ForecastEntity")
    }

    @NSManaged public var dateIssued: Date?
    @NSManaged public var elevationFt: Int32
    @NSManaged public var ident: String?
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var text: String?
    @NSManaged public var conditions: NSSet?

}

// MARK: Generated accessors for conditions
extension ForecastEntity {

    @objc(addConditionsObject:)
    @NSManaged public func addToConditions(_ value: ConditionsEntity)

    @objc(removeConditionsObject:)
    @NSManaged public func removeFromConditions(_ value: ConditionsEntity)

    @objc(addConditions:)
    @NSManaged public func addToConditions(_ values: NSSet)

    @objc(removeConditions:)
    @NSManaged public func removeFromConditions(_ values: NSSet)

}

extension ForecastEntity : Identifiable {

}
