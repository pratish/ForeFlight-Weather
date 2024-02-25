//
//  CloudLayerEntity+CoreDataProperties.swift
//  ForeFlight Weather
//
//  Created by Pratish Karmacharya on 2/24/24.
//
//

import Foundation
import CoreData


extension CloudLayerEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CloudLayerEntity> {
        return NSFetchRequest<CloudLayerEntity>(entityName: "CloudLayerEntity")
    }

    @NSManaged public var altitudeFt: Int32
    @NSManaged public var ceiling: Bool
    @NSManaged public var coverage: String?

}

extension CloudLayerEntity : Identifiable {

}
