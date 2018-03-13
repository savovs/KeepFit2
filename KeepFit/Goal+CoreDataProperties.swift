//
//  Goal+CoreDataProperties.swift
//  KeepFit
//
//  Created by Vlady Veselinov on 3/13/18.
//  Copyright © 2018 Vlady Veselinov. All rights reserved.
//
//

import Foundation
import CoreData


extension Goal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goal> {
        return NSFetchRequest<Goal>(entityName: "Goal")
    }

    @NSManaged public var name: String?
    @NSManaged public var target: Int16
    @NSManaged public var current: Int16

}
