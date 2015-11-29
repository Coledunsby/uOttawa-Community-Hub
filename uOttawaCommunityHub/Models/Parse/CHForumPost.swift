//
//  CHForumPost.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-11-28.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import Parse

class CHForumPost: PFObject, PFSubclassing {
    
    @NSManaged var user: CHUser
    @NSManaged var name: String
    @NSManaged var info: String
    
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "ForumPost"
    }
    
}