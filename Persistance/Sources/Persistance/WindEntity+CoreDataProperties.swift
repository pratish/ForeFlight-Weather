//
//  WindEntity+CoreDataProperties.swift
//  ForeFlight Weather
//
//  Created by Pratish Karmacharya on 2/24/24.
//
//

import Foundation
import CoreData


extension WindEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WindEntity> {
        return NSFetchRequest<WindEntity>(entityName: "WindEntity")
    }

    @NSManaged public var direction: Int16
    @NSManaged public var from: Int16
    @NSManaged public var speedKts: Double
    @NSManaged public var variable: Bool

}

extension WindEntity : Identifiable {

}
