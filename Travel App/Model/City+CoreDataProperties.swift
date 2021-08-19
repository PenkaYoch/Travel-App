//
//  City+CoreDataProperties.swift
//  Travel App
//
//  Created by Synergy on 19.08.21.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var descript: String?
    @NSManaged public var name: String?
    @NSManaged public var sights: NSSet?

}

// MARK: Generated accessors for sights
extension City {

    @objc(addSightsObject:)
    @NSManaged public func addToSights(_ value: Landmark)

    @objc(removeSightsObject:)
    @NSManaged public func removeFromSights(_ value: Landmark)

    @objc(addSights:)
    @NSManaged public func addToSights(_ values: NSSet)

    @objc(removeSights:)
    @NSManaged public func removeFromSights(_ values: NSSet)

}

extension City : Identifiable {

}
