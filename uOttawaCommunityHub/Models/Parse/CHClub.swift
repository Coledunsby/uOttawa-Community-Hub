//
//  CHClub.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-11-29.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import Parse

class CHClub: PFObject, PFSubclassing {
    
    @NSManaged var name: String
    @NSManaged var info: String
    @NSManaged var email: String
    @NSManaged var website: String
    @NSManaged var image: PFFile?
    @NSManaged var filter: CHFilter
    @NSManaged private(set) var admins: PFRelation
    @NSManaged private(set) var members: PFRelation
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Club"
    }
    
}