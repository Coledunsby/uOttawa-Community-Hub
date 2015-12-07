//
//  CHEvent.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-11-24.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import Parse

enum RecurrenceType: Int {
    case None
    case Daily
    case Weekly
    case Monthly
}

class CHEvent: PFObject, PFSubclassing {

    @NSManaged var club: CHClub
    @NSManaged var user: CHUser
    @NSManaged var name: String
    @NSManaged var info: String
    @NSManaged var recurrenceType: Int
    @NSManaged var startDate: NSDate
    @NSManaged var image: PFFile?
    @NSManaged var location: PFGeoPoint
    @NSManaged private(set) var filters: PFRelation
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Event"
    }
    
}
