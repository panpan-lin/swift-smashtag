//
//  Tweet+CoreDataProperties.swift
//  Smashtag
//
//  Created by Panpan Lin on 07/11/2016.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation
import CoreData

extension Tweet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tweet> {
        return NSFetchRequest<Tweet>(entityName: "Tweet");
    }

    @NSManaged public var text: String?
    @NSManaged public var unique: String?
    @NSManaged public var posted: NSDate?
    @NSManaged public var tweeter: TwitterUser?

}
