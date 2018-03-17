//
//  HistoryAction+CoreDataProperties.swift
//  KeepFit
//
//  Created by Vlady Veselinov on 3/17/18.
//  Copyright © 2018 Vlady Veselinov. All rights reserved.
//
//

import Foundation
import CoreData


extension HistoryAction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HistoryAction> {
        return NSFetchRequest<HistoryAction>(entityName: "HistoryAction")
    }

    @NSManaged public var date: NSDate
    @NSManaged public var text: String
    @NSManaged public var typeString: String
    
    public enum type: String {
        case set
        case track
        case update
        case add
        case subtract
        case delete
        case complete
    }

}
