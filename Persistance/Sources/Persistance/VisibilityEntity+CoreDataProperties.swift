//
//  VisibilityEntity+CoreDataProperties.swift
//  ForeFlight Weather
//
//  Created by Pratish Karmacharya on 2/24/24.
//
//

import Foundation
import CoreData


extension VisibilityEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VisibilityEntity> {
        return NSFetchRequest<VisibilityEntity>(entityName: "VisibilityEntity")
    }

    @NSManaged public var distanceSm: Double
    @NSManaged public var prevailingVisSm: Double

}

extension VisibilityEntity : Identifiable {

}
