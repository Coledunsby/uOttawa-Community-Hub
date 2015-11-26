//
//  CHEvent.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-11-24.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import Parse

class CHEvent: PFObject, PFSubclassing {

    dynamic var name: String?
    dynamic var info: String?
    dynamic var members: PFRelation?
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Event"
    }
    
}
