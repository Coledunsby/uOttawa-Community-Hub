//
//  CHUser.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-11-13.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import Parse

class CHUser: PFUser {

    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var location: PFGeoPoint
    @NSManaged private(set) var clubFilters: PFRelation
    @NSManaged private(set) var eventFilters: PFRelation
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    func name() -> String {
        return firstName + " " + lastName
    }
    
}
