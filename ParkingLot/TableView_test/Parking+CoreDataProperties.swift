//
//  Parking+CoreDataProperties.swift
//  TableView_test
//
//  Created by 仲輝 on 2022/2/25.
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
    @NSManaged public var loc: String?
    @NSManaged public var servTime: String?
    @NSManaged public var dataType: Bool

}

extension Parking : Identifiable {

}
