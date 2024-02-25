//
//  ConditionsEntity+CoreDataProperties.swift
//  ForeFlight Weather
//
//  Created by Pratish Karmacharya on 2/24/24.
//
//

import Foundation
import CoreData


extension ConditionsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ConditionsEntity> {
        return NSFetchRequest<ConditionsEntity>(entityName: "ConditionsEntity")
    }

    @NSManaged public var dateIssued: Date?
    @NSManaged public var densityAltitudeFt: Int32
    @NSManaged public var dewpointC: Int16
    @NSManaged public var elevationFt: Int32
    @NSManaged public var flightRules: String?
    @NSManaged public var ident: String?
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var pressureHg: Double
    @NSManaged public var pressureHpa: Double
    @NSManaged public var relativeHumidity: Int16
    @NSManaged public var reportedAsHpa: Bool
    @NSManaged public var tempC: Int16
    @NSManaged public var text: String?
    @NSManaged public var weather: String?
    @NSManaged public var cloudLayer: NSSet?
    @NSManaged public var cloudLayerV2: NSSet?
    @NSManaged public var visibility: VisibilityEntity?
    @NSManaged public var wind: WindEntity?

}

// MARK: Generated accessors for cloudLayer
extension ConditionsEntity {

    @objc(addCloudLayerObject:)
    @NSManaged public func addToCloudLayer(_ value: CloudLayerEntity)

    @objc(removeCloudLayerObject:)
    @NSManaged public func removeFromCloudLayer(_ value: CloudLayerEntity)

    @objc(addCloudLayer:)
    @NSManaged public func addToCloudLayer(_ values: NSSet)

    @objc(removeCloudLayer:)
    @NSManaged public func removeFromCloudLayer(_ values: NSSet)

}

// MARK: Generated accessors for cloudLayerV2
extension ConditionsEntity {

    @objc(addCloudLayerV2Object:)
    @NSManaged public func addToCloudLayerV2(_ value: CloudLayerEntity)

    @objc(removeCloudLayerV2Object:)
    @NSManaged public func removeFromCloudLayerV2(_ value: CloudLayerEntity)

    @objc(addCloudLayerV2:)
    @NSManaged public func addToCloudLayerV2(_ values: NSSet)

    @objc(removeCloudLayerV2:)
    @NSManaged public func removeFromCloudLayerV2(_ values: NSSet)

}

extension ConditionsEntity : Identifiable {

}
