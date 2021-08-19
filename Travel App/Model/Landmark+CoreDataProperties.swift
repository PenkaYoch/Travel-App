//
//  Landmark+CoreDataProperties.swift
//  Travel App
//
//  Created by Synergy on 19.08.21.
//
//

import Foundation
import CoreData


extension Landmark {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Landmark> {
        return NSFetchRequest<Landmark>(entityName: "Landmark")
    }

    @NSManaged public var descript: String?
    @NSManaged public var name: String?
    @NSManaged public var town: String?
    @NSManaged public var city: City?

}

extension Landmark : Identifiable {

}
