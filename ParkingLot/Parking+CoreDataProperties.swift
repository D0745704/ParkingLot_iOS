//
//  Parking+CoreDataProperties.swift
//  ParkingLotProject
//
//  Created by 仲輝 on 2022/3/30.
//
//

import Foundation
import CoreData


extension Parking {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Parking> {
        return NSFetchRequest<Parking>(entityName: "Parking")
    }

    @NSManaged public var addr: String?
    @NSManaged public var area: String?
    @NSManaged public var id: String?
    @NSManaged public var latitude: Double
    @NSManaged public var loc: String?
    @NSManaged public var longitude: Double
    @NSManaged public var payex: String?
    @NSManaged public var servTime: String?
    @NSManaged public var summary: String?
    @NSManaged public var tel: String?
    @NSManaged public var totalBike: Int16
    @NSManaged public var totalCar: Int16
    @NSManaged public var totalMotor: Int16
    @NSManaged public var type: Int16

}

extension Parking : Identifiable {

}
