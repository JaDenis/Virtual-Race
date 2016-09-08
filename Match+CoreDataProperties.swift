//
//  Match+CoreDataProperties.swift
//  Virtual Race
//
//  Created by Christopher Weaver on 9/8/16.
//  Copyright © 2016 Christopher Weaver. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Match {

    @NSManaged var startDate: NSDate?
    @NSManaged var myID: String?
    @NSManaged var myDistance: NSNumber?
    @NSManaged var myAvatar: NSData?
    @NSManaged var oppID: String?
    @NSManaged var oppDistance: NSNumber?
    @NSManaged var oppAvatar: NSData?
    @NSManaged var finished: NSNumber?
    @NSManaged var started: NSNumber?
    @NSManaged var myName: String?
    @NSManaged var oppName: String?
}